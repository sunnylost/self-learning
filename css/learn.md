## pointer-events

CSS 属性，设置为`none`，元素就不会响应鼠标事件(包括 hover/click)，鼠标可以**穿透**元素，点到它后面的元素上。

默认值为`auto`。

**注意**： 该值可以继承，如果在后代元素上设置了 `pointer-events: "auto"`，那么事件会冒泡上来，元素还是能触发鼠标事件。

最初在 SVG 中实现，拥有更多的可选值。

文档：[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/pointer-events)

兼容性：[Caniuse](http://caniuse.com/#feat=pointer-events)

## mask-box-image

为元素的 `border-box` 设置蒙层. 目前需要加 `-webkit-` 前缀.

文档: [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-mask-box-image)

