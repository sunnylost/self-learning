#Cascading Style Sheets Level 2 Revision 2 (CSS 2.2) Specification

[https://www.w3.org/TR/CSS22/](https://www.w3.org/TR/CSS22/)

在文档树中的每个元素都会生成 0 到多个 box，它们的布局受到以下因素影响：
- box 的尺寸和类型
- 定位方案(normal flow, float, absolute positioning)
- 元素之间的关系
- 外部信息(视口尺寸，图片内在尺寸等)

**viewport**

用于查看文档的窗口，当窗口小于绘制的 canvas 大小时，需要提供滚动机制。

**containing blocks**

box 的 containing block 是指它存在的 containing block，而不是它生成的 containing block。

## 控制 box 生成

`display` 属性定义了 box 的类型。

### block-level 元素和 block box

`display` 的值为 `block`、`list-item`、`table` 会使元素成为  block-level 元素。它会生成 block-level principal box，它参与 `block formatting context`。

block-level box 还是一个 `block container box`(table box，或 replaced element 除外)。

`block container box` 只能包含 block-level box，或者创建一个 `inline formatting context` 来包含 inline-level box。

`display` 的值为 `block`、`list-item`、`inline-block` 会让 non-replaced 元素生成 block container。

如果元素的 principal box 是一个 `block container box`，那么该元素就称为 `block container element`。

如果 `block container box` 包含了至少一个 block-level 的元素，那么如果它还包含了 inline-level 元素，那么该 inline-level 元素会被一个称为 `anonymous block box` 包裹起来。

如果 inline-level box 里又包含了一个 block-level 元素，那么在该元素的前后会分别生成两个 `anonymouse block box`，将 inline-level 拆分成两个。

### inline-level 元素和 inline box

`display` 值为 `inline`、`inline-table`、`inline-block` 将元素定义为 inline-level。inline-level 元素生成 inline-level box，参与 `inline formatting context`。

如果一个 inline-level 元素的内容参与它包含的 `inline formatting context`，那么它称为 `inline box`。`display` 为 `inline` 的非替换元素生成 `inline box`。对于不是 `inline box` 的 inline-level box(替换的 inline-level 元素，inline-block 元素，inline-table 元素)称为 `atomic inline-level box`，因为他们本身会作为一个不透明的 box 来参与 `inline formatting context`。



