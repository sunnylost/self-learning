https://www.chromium.org/developers/design-documents/compositor-hit-testing

##背景
例如在手机上，触摸页面可以导致页面滚动，而 touch 事件的 handler 可以 `preventDefault()`，来阻止滚动，所以 browser 进程在接收到类似的事件时，需要交给 blink 进程处理，来决定页面是否可以滚动。问题在于 blink 进程并不总是能及时响应，导致 touch 事件触发与页面滚动之间有较大的延迟。

##blink
blink 把所有带 `touch` 事件 handler 的节点存到 `WebCore::Document` 中。layout 出现，或 `Touch` 事件 handler 添加或被删除，`WebCore::ScrollingCoordinator` 会遍历所有追踪的 Node 的 renderer 来生成矩形。

##compositor
hit testing 只对 `touchstart` 生效。

在 `touchstart` 事件触发后，compositor 查询每个层的 `touchEventHandlerRegion`，来判断是否命中这些区域，如果有命中，那么 compositor 将该 `touch` 事件转发给 renderer 进而发送到 blink 来处理。如果没有命中，返回 `NO_CONSUMER_EXISTS`。

##browser
`touchstart` 事件触发后，浏览器通过 IPC 将该事件发送给 compositor，并等待 ACK。

如果 ACK 为 `NO_CONSUMER_EXISTS`，表明没有事件 handler，那么就不会将后续 `touch` 事件转发给 compositor(在新的 `touchstart` 出现前)，而是交给平台相关的手势检测器(gesture detector)。

如果 ACK 为 `NOT_CONSUMED` 或 `CONSUMED`，表明 有 `touchEventHandlerRegion` 被命中，那么后续的 `touchmove` 和 `touchend` 事件会继续发送到 compositor。

如果是 `CONSUMED`，表明调用了 `preventDefault()`，则在新的 `touchstart` 事件出现前，不会将后续的 `touch` 事件发送到手势检测器。

如果是 `NOT_CONSUMED`，则可能是没有命中 `touchEventHandlerRegion`，或是 handler 没有处理该 touch 事件。后续 `touch` 事件依旧会发送给手势检测器。

## 注意
在 `window` 或 `document` 上绑定 `touch` 事件不会受到该项目的任何优化。
