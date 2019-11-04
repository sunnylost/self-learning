Content Security Policy

[CSP 2](https://www.w3.org/TR/CSP2/)
[CSP 3](https://www.w3.org/TR/CSP/)
[http://cspisawesome.com/](http://cspisawesome.com/)

可以用来减少内容注入引发的攻击，主要手段是对资源的来源进行控制，例如可以控制只加载某个域名下的资源、行内 js 是否执行、动态代码是否执行等等。

使用的方式为定义一系列的 policy，它可以通过 http 的响应头传输，也可以写在 html 的 meta 标签中。

响应头：
- `Content-Security-Policy`
- `Content-Security-Policy-Report-Only`

`Content-Security-Policy-Report-Only` 设置的 policy 不会生效，只会上报，用于试验某些特性。它的值和 `Content-Security-Policy` 一样。

该头不会在 `meta` 标签内生效。

使用 `<meta>`:

```html
<meta http-equiv="Content-Security-Policy" content="script-src 'self'">
```

该 `<meta>` 需要靠前放置，否则在它之前的资源加载不会受到影响。

## 指令分类

### fetch directives

该类指令指定了哪里的资源能够获取。

- child-src

  child 表示嵌套的浏览上下文，即 `iframe`， `frame` 和 Worker。

- connect-src

  控制通过脚本来进行的通信。
  
- default-src
  
  如果其余 fetch 指令没有设置，那么默认使用该值

其余指令：
- font-src
- frame-src
- img-src
- manifest-src
- media-src
- object-src
- script-src
- style-src
- worker-src

对于想要执行行内 js，可以指定 `script-src 'unsafe-inline'`，但正因为禁止了行内代码的执行，才能有效抵御 XSS 攻击。

还有一种方式是指定 nonce code，即在 csp 头中定义一个 nonce code，在 `<script>` 上指定 `nonce` 属性，使用同样的值。这种方式同样也是不安全的。

### document directives

用于 document 或 worker 环境。

- base-uri

  控制 `<base>` 元素的 URL 值。
  
- plugin-types

  允许哪些插件。值为 media-type
  
- sandbox

  使当前页面与 `<iframe>` 上设置 `sandbox` 效果一样。
  
- disown-opener

  例如新打开的窗口不会拥有父窗口的引用。
  
### navigation directives

- form-action

  指定 form 可以提交到哪里
  
- frame-ancestors

  控制 `<frame>`、`<iframe>`、`<object>`、`<embed>`、`<applet>` 等元素的 url
  
### reporting directives

- report-to

  如果出现了违反 policy 的情况，那么应该上报到哪里。
  

### DOM 事件

可以在脚本中监听违反规则的情况，用 `window` 或 `document` 监听 `securitypolicyviolation` 事件。注意该事件监听，应该尽早进行，在事件注册之前的违反规则情况不会被触发。

[事件包含的属性](https://www.w3.org/TR/CSP/#violation-events)
