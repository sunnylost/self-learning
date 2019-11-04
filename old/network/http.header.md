# 14 Header Field Definitions

## 14.1 Accept

响应中可接受的媒体类型。

`*/*` 表示接受任意类型。`\*`表示范围。

每种类型后面还可以有参数：

`text/html; q=0.9` 中的 0.9 用于排序。因为浏览器可能会允许多种格式，而对不同格式之间的需求又不同，可能更偏好某种类型，在这种情况下就可以使用 `q` 来决定它们的优先级顺序。

如果服务器不能返回对应的类型，那么应该发送 406(not acceptable)。

## 14.2 Accept-Charset

同上，表示可以接受的字符集，同样具有 `q` 参数。

## 14.3 Accept-Encoding

可以接受的内容编码。3.5 节中定义了支持的编码方式。

## 14.4 Accept-Language

略

## 14.5 Accept-Ranges

响应头，表示是否支持范围请求。它目前有两个值：

- none，表示不允许，默认就是该值，所以可以不用明确设置

- bytes，允许范围请求，并且单位是字节。

通常表明服务器支持断点续传。

## 14.6 Age

通常来自于缓存服务器(不是源服务器)，表明请求的资源已经在该服务器上存在了多久。越接近 0，说明该资源越新。

单位是秒。

## 14.7 Allow

资源允许哪些方法来请求，可以是逗号分隔的方法列表：`Allow: GET, HEAD, PUT`

## 14.8 Authorization
暂略

## 14.9 Cache-Control

### 14.9.1 什么是可被缓存( cacheable )？

13.4 中有解释。

以下指令会覆盖响应的默认可缓存性：

* public

  响应可以被缓存。
  
* private

  响应只适用于单独用户，不能被分享。
  
* no-cache

  `no-cache` 后如果没有指定字段名，表示在没有和服务器成功验证前缓存不能使用该响应。

  如果指定了字段名，那么缓存可以使用该响应，但指定的字段名不会被发送(在经过服务端验证之前，验证通过以后还是可以发送的)。

### 14.9.2 哪些能被缓存？

* no-store

  可以用于请求或响应中，如果是请求，那么请求和对应的响应不能被缓存；如果是响应，那么引发响应的请求也不能被缓存。
  
  有些时候可能会不小心发送了敏感信息，那么该指令就是用于做补救操作的，但不能完全依赖它，因为它也不是绝对可靠的。

### 14.9.3 基本失效机制的修改

失效时间可以由 `Expires` 指定，也可以通过 `max-age` 指令设置。

响应中包含 `max-age` 意味着该响应可以被缓存，除非有更严格的缓存指令存在。

`max-age` 的优先级高于 `Expires`，即便 `Expires` 更严格。

许多 HTTP/1.0 缓存实现将 `Expires` 的值设置的小于 `Date` 值来达到 `Cache-Control` 中 `no-cache` 同样的效果。如果 HTTP/1.1 缓存接收到如此的响应，并且没有设置 `Cache-Control`，那么认为该响应不能被缓存。

* s-maxage

  该指令适用于可分享的缓存( 非 `private` )，优先级高于 `Expires` 和 `max-age`。

  该指令也暗含 `proxy-revalidate` 指令的语义，即在失效后应该先去进行验证，然后才能被使用。

  `private` 缓存始终忽略该指令。

以下指令允许用户代理修改基本失效机制，可以用于请求中：

* max-age

  表明客户端将接受 `age` 不大于指定时间( 以秒为单位 )的响应。除非有 `max-stale` 指令，否则客户端将不接受陈旧响应( `stale response` )。
* min-fresh

  表明客户端将接受保鲜寿命( `freshness lifetime` )不小于当前 `age` 加上指定时间( 以秒为单位 )的响应。
* max-stale

  表明客户端将接受超过失效时间的响应。如果 `max-stale` 设置了值，那么该响应超出的失效时间不能大于该值。如果没有设置值，那么任何失效的响应都将被接受。

### 14.9.4 缓存重新生效与重新载入控制

* 端到端重载( end-to-end reload )

  请求中包含 `no-cache`，或为了兼容 HTTP/1.0 `Pragma:no-cache`。`no-cache` 指令后不能添加字段名。服务器在处理这种请求时，不能使用缓存的拷贝。
* 指定端到端重新生效( Specific end-to-end revalidation )

  请求中包含 `max-age=0` 指令，强制通往服务器路径上的每一个缓存重新验证自己的缓存条目。初始请求包含了客户端当前的验证器。
* 未指定的端到端重新生效( Unspecific end-to-end revalidation )

  同上，但请求中不包含验证器。
* max-age

  当中介缓存被强制要求重新验证缓存条目时，客户端可能提供了自己的验证器，该验证器可能与中介缓存自身的验证器不同。在这种情况下，缓存可以使用任意验证器来确保语义透明化。

  但是，验证器的选择可能会影响性能。最好的方式是，在发送请求时，中介缓存使用自己的验证器。如果服务器返回 304，缓存可以将自身验证过的缓存拷贝以 200 的方式响应给客户端。如果服务器端返回了新的实体和缓存验证器，中介缓存可以用客户端传递过来的验证器与响应的验证器进行比较。如果客户端的验证器等同于服务器的，那么中介缓存返回 304，否则返回 200.

  如果请求包含 `no-cache`，那就不应该包含 `min-fresh`，`max-stale` 或 `max-age`。
* only-if-cached

  在网络很差的情况下，客户端可能希望缓存返回它当前已经缓存的内容，而不进行重载或重新生效操作。要达到这样的效果，需要在请求中增加 `only-if-cached`。缓存要么返回已经保存的缓存条目，或者返回 504( `Gateway Timeout` )。
* must-revalidate
* proxy-revalidate

### 14.9.5 No-Transform 指令

* no-transform

  在 13.5.2 中列出的 `header` 不能被中介缓存或代理修改，也包括实体的主体( `entity body` )。

### 14.9.6 缓存控制扩展

## 14.10 Connection

## 14.30 Location