## 脚本

### `script` 标签
- 分类
  - Metadata content
  - Flow content
  - Phrasing content
  - Script-supporting element
- 内容模型
  - 如果没有 `src` 属性，根据 `type` 来确定内容
  - 如果有 `src` 属性，标签或者为空，或者包含脚本的文档
- 标签不允许省略
- attribute( 动态改变以下属性无效 )
  - src
  - type
  - charset
  - async
  - defer
  - crossorigin
  - nonce
- `type` 属性
  - 省略，或者设置为 `JavaScript` 的 MIME 类型，会按照脚本来解析，受 `charset`、`async` 和 `defer` 影响。推荐省略
  - 设置为 `module`(大小写不敏感)，表示为模块脚本，**不受** `charset` 和 `defer` 影响。
  - 推荐设置为非 `JavaScript` 的 MIME 类型，为了不受到以后取值上的冲突(例如新增的 `module` 值)。这样表示一个数据块，不受 `script` 标签上的任何属性影响。
- `async` 和 `defer`
  - `async` 表示脚本并行加载，加载完毕后立即执行
  - `defer` 会并行加载，等待 HTML 解析完毕后再执行
  - 模块不受 `defer` 影响
  - `defer` 和 `async` 可以同时设置，用于兼容不支持 `async` 属性的浏览器( `async` 优先级高 )
- `crossorigin`，用于 `CORS`
- `nonce`，用于 `CSP`，值为加密数字( nonce="number used once" )
- `script.text` 获取标签子文本内容。
- 标签使用 `document.write()` 写入会执行，使用 `innerHTML` 或 `outerHTML` 的则不会执行
- 内容限制：在 `script` 标签内将 `<!--` 转义为 `<\!--`，`<script` 转义为 `<\script`，`</script` 转义为 `<\/script`。

### `noscript` 标签
可以包含 `link`，`style`，`meta` 标签。

### `template` 标签
标签内容存储在一个 `DocumentFragment` 中，可以通过 `template.content` 获取。该 fragment 的 `Document` 和标签所在的 `Document` 不同。

### `slot` 标签
用于 `shadow tree`。拥有 `name` 属性

## [自定义元素](https://html.spec.whatwg.org/multipage/scripting.html#custom-elements)
