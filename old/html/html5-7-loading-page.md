# 7 Loading Web Pages

## 7.1 Browsing contexts 

浏览上下文是用于展现 `Document` 对象的环境。这个 `Document` 称为 `active document`。

一个 tab 、窗口、`iframe` 等都包含一个 `browsing context`.

每个 `browsing context` 都有一个对应的 `WindowProxy`
还包含了一个 `session history`，里面列出了上下文展现过(或即将展现)的所有 `Document` 对象。

`creator browsing context`:类似于父上下文，例如包含 `iframe` 标签的页面，调用了 `window.open()` 的页面。

### 创建一个 `browsing context`

- 设置 `browsingContext` 为一个新的 `browsing context`
- 调用 JS 的 `InitializeHostDefinedRealm()`
  - 创建全局对象 `Window`
  - 设置全局对象 `this` 为 `browsingContext` 的 `WindowProxy`
  - 令 `realm execution context` 为 `JavaScript execution context`
- `Set up a browsing context environment settings object with realm execution context.`
- 令 `document` 为新的 `Document`，标记为 `quirks mode` 下的 `HTML document`，内容类型为 `text/html`
- 确保 `document` 拥有一个子节点 `html`，该子节点拥有两个空的子节点 `head` 和 `body` 元素
- 设置 `window` 的关联 `Document` 为 `document`
- 设置 `browsingContext` 的 `WindowProxy` 对象的 `[[Window]]` 值为 `window`
- 

