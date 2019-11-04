first-hand:

如果响应直接通过服务器返回，没有任何延迟，例如通过一个或多个代理。或者响应的合法性被服务器直接验证过。

## 13. Caching

### 缓存的目的

提高性能

### 手段

1. 避免不必要的请求( expiration )

2. 避免返回完整响应( validation )


(什么是 semantic transparency？)


### 13.1.1 什么是正确的缓存？

1. 通过服务器验证的缓存

2. 足够新( fresh enough )的缓存，即符合服务器、客户端、缓存的最小限制新鲜需求的。

3. 304，305( Proxy Redirect )，或错误( 4xx 或 5xx ) 响应消息

### 13.1.2 警告

如果从缓存返回的响应不是 `first-hand` 或 `fresh enough` 的，缓存必须在响应中增加 `Warning` 头。

### 13.1.3 缓存机制

服务器或客户端显式的在请求或响应中增加缓存指令( `directive` )，即使用 `Cache-Control` 头。

因为可以设置多个指令，如果指令之间有冲突，能被最严格解析的指令生效。

### 13.2 失效模型( Expiration Model )

#### 13.2.1 服务端指定失效

指定实体( `entity` )在未来一段时间内不会被改变，这样来避免向服务器发出请求。

如果服务器强制要求对每个请求进行验证，那么可以将失效时间设置在过去，这意味着每个响应都是 `stale` 的，缓存在使用它们前必须要进行验证。

设置 `must-revalidate` 缓存控制指令来强制验证每一次请求。

失效时间并不能强制客户端刷新显示或重载资源，它的语义只适用于缓存，即当对某个资源的新请求初始化时，才进行缓存失效状态验证。

#### 13.2.3 age 计算

HTTP/1.1 要求服务器在每次响应中返回 `Date` 头，表明响应的生成时间。

`Age` 头表示响应从源服务器生成到传输路径中每个缓存停留的时间，再加上网络传输中消耗的时间。

`now` 表示客户端开始计算时的时间，`date_value` 表示 `Date`，`age_value` 表示 `Age`。

响应的 `age_value`：

1. 用当前时间减去 `Date` 时间
2. `Age` 头表示的时间

最终结果：`corrected_received_age = max( now - date_value, age_value )`

完整计算如下：

    apparent_age           = max( 0, response_time - date_value );
    corrected_received_age = max( now - date_value, age_value );
    response_delay         = response_time - request_time;
    corrected_initial_age  = corrected_received_age + ( now - request_time );
    resident_time          = now - response_time;
    current_age            = corrected_initial_age + resident_time;

如果响应头中包含 `Age`，表明响应不是 `first-hand`，反之并不成立。

#### 13.2.4 expiration 计算

`expires_value` 表示 `Expires` 头，`max_age_value` 表示 `max-age` 头，`max-age` 的优先级高于 `Expires`。

`freshness_lifetime = max_age_value`

或者

`freshness_lifetime = expires_value - date_value`

判断响应是否过期：

`response_is_fresh = ( freshness_lifetime > current_age )`

### 13.3 验证模型( Validation Model )

当使用一条过期( `stale` )的缓存时，客户端会向服务器检测该缓存是否依然可用。如果依然可用，服务器不需要返回完整的响应，否则亦然。这时候就需要使用条件方法( `conditional method` )。

当服务器生成完整响应时，它会添加一个类似验证器( `validator` )的东西。当客户端要验证缓存时，它会将该验证器包含在请求中。

服务器接到验证器后会与当前请求实体的验证器比对，如果两者吻合，则返回特殊状态码( 通常是 304 )，并且不包含实体主体( `entity-body` )。

#### 13.3.1 Last-Modified 日期

通常作为验证器使用。

#### 13.3.2 Entity Tag Cache 验证器

`ETag` 响应头提供更可靠的验证。

#### 13.3.3 强与弱验证器

如果实体改变了，验证器随之改变，则该验证器称为“强验证器”，如果验证器不改变，则称为“弱验证器”。

实体的内容改变，强验证器改变；实体的含义改变，弱验证器改变

客户端只能在 `GET` 请求中使用弱验证器。

`ETag` 是强验证器，但可以被标记为弱验证器。

`Last-Modified` 是弱验证器，但如果使用以下规则，可以被认为是强验证器( **以下内容有待进一步确认** )：

- 验证器与源服务器对应实体的验证器比较，并且，
- 源服务器确保该实体并没有在一秒钟内改变多次

或者：

- 客户端在 `If-Modified-Since` 或 `If-Unmodified-Since` 头中使用验证器，因为客户端在缓存中拥有对应的实体
- 缓存实体包含 `Date` 值
- `Last-Modified` 至少比 `Date` 小 60 秒

或者：

- 验证器与中介缓存( intermediate cache )的验证器进行比较
- 缓存实体包含 `Date` 值
- `Last-Modified` 至少比 `Date` 小 60 秒

#### 13.3.4 使用 ETag 与 Last-Modified 的规则

HTTP/1.1 倾向于服务器同时发送 `ETag` 与 `Last-Modified`

HTTP/1.1 客户端：

- 如果存在 `ETag`，则在任意 `cache-conditional` 请求中( 使用 `If-Match` 或 `If-None-Match` )使用它。
- 如果只有 `Last-Modified`，则在 `non-subrange cache-conditional` 请求( 使用 `If-Modified-Since` )中使用。
- 如果 `Last-Modified` 是由 HTTP/1.0 服务器提供的，那么该值可以在 `subrange cache-conditional` 请求( 使用 `If-Unmodified-Since` )中使用。
- 如果 `ETag` 与 `Last-Modified` 同时被提供，那么应该在 `cache-conditional` 请求中使用。

### 13.4 响应可缓存性( Response Cacheability )

A response received with a status code of 200, 203, 206, 300, 301 or 410 MAY be stored by a cache and used in reply to a subsequent request, subject to the expiration mechanism, unless a cache-control directive prohibits caching. However, a cache that does not support the Range and Content-Range headers MUST NOT cache 206 (Partial Content) responses.

### 13.5 从缓存中构建响应

HTTP 缓存的目的在于将请求对应的响应中的信息存储来应对未来的请求。

#### 13.5.1 End-to-end 和 Hop-by-hop Header

HTTP 头分为两类：

- End-to-end header，传递给请求或响应的最终接受者，它们必须作为缓存记录的一部分保存起来
- Hop-by-hop header，只对单独的某一层链接有意义，不会被缓存或者被代理转发。

以下是 `hop-by-hop` 头：

- Connection
- Keep-Alive
- Proxy-Authenticate
- Proxy-Authorization
- TE
- Trailers
- Transfer-Encoding
- Upgrade

HTTP/1.1 中其余的头都是 `end-to-end` 头。

#### 13.5.2 Non-modifiable Headers

以下 header 不应该被修改( 如果不存在，也不应该被添加 ):

- Content-Location
- Content-MD5
- ETag
- Last-Modified

以下 header 不应该被修改( 可以被添加 )：

- Expires

代理不应该在任意请求或包含 `no-transform` 缓存控制指令的消息中修改或添加如下 header：

- Content-Encoding
- Content-Range
- Content-Type

#### 13.5.3 COmbining Headers

主要涉及 206 状态码，暂略。

#### 13.5.4 Combining Byte Ranges

略。

### 13.8 错误或不完整的缓存行为

不完整的响应( 字节长度小于 `Content-Length` )会作为部分响应( `partial response` )而缓存起来。

部分响应的缓存必须使用 206( `partial content` ) 标记，不能使用 200.

### 13.9 GET 与 HEAD 的副作用

暂略。
