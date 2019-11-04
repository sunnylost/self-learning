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

block-level box 还是一个 `block container box`(table box，或 replaced element 除外) 的话，称为 `block box`。

`block container box` 只能包含 block-level box，或者创建一个 `inline formatting context` 来包含 inline-level box。

`display` 的值为 `block`、`list-item`、`inline-block` 会让 non-replaced 元素生成 block container。

如果元素的 principal box 是一个 `block container box`，那么该元素就称为 `block container element`。

如果 `block container box` 包含了至少一个 block-level 的元素，那么如果它还包含了 inline-level 元素，那么该 inline-level 元素会被一个称为 `anonymous block box` 包裹起来。

如果 inline-level box 里又包含了一个 block-level 元素，那么在该元素的前后会分别生成两个 `anonymouse block box`，将 inline-level 拆分成两个。

### inline-level 元素和 inline box

`display` 值为 `inline`、`inline-table`、`inline-block` 将元素定义为 inline-level。inline-level 元素生成 inline-level box，参与 `inline formatting context`。

如果一个 inline-level 元素的内容参与它包含的 `inline formatting context`，那么它称为 `inline box`。`display` 为 `inline` 的非替换元素生成 `inline box`。对于不是 `inline box` 的 inline-level box(替换的 inline-level 元素，inline-block 元素，inline-table 元素)称为 `atomic inline-level box`，因为他们本身会作为一个不透明的 box 来参与 `inline formatting context`。

### 9.3 定位
 
- normal flow，包括块级 box 的 block formatting，行内 box 的 inline formatting，块级与行内 box 的相对定位。
- float，box 先按照 normal flow 定位，再尽量远的向左/右移动。
- absolute positioning，完全从 normal flow 中移除，相对于它的 containing block 定位。

### 9.4 normal flow

#### BFC

浮动、绝对定位、不是 block box 的 block container，`overflow` 不是 `visible` 的 block box 会创建 BFC。

BFC 内，毗邻的 block-level box 的纵向 margin 会折叠。

### IFC

IFC 由一个不包含 block-level box 的 block container 创建。

一个矩形区域，包含 box 从而形成 line 的称为 line box。

line box 的宽度受到 containing block 和 float 影响。

## 10. Visual formatting model details

### containing block

- `root element` 所在的 CB 称为 `initial containing block`
- 如果 `position` 是 `relative` 或 `static`，它的 CB 是离它最近的祖先元素中的 `block container`，或者是创建了 `formatting context` 的 box
- 如果 `position` 是 `fixed`，CB 由 viewport 创建
- 如果 `position` 是 `absolute`，CB 由离它最近的祖先元素中 `position` 为 `absolute`、`relative`、`fixed` 的创建
    - 如果该祖先元素 inline 元素，根据它的第一个、最后一个 inline box 组成
    - 否则以祖先元素的 `padding edge` 为边界

### width

如果值为百分比，相对于 CB 的宽。如果是绝对定位，那么相对于它的 CB 对应的元素的 padding box。

### 计算 width 和 margin

1. inline，non-replaced 元素

`width` 不生效，`margin-left` 或 `margin-right` 的 `auto` 值转为 0

2. inline, replaced 元素

`margin-left` 或 `margin-right` 的 `auto` 值转为 0

7. absolute，non-replaced 元素

`static position` 是指元素在 normal flow 中的位置。
