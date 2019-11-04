# CSS Positioned Layout

[https://www.w3.org/TR/css-position-3/](https://www.w3.org/TR/css-position-3/)

如果 `position` 是 `fixed`，那么 `containing block` 是 viewport

如果 `position` 是 `absolute`，那么 `containing block` 由离它最近的、`position` 不是 `static` 的祖先元素建立
- 如果该祖先元素是 block-level，那么 `containing block` 以元素的 padding edge 为边界
- 如果祖先元素是 inline-level，那么根据它的 `direction` 来确定：
    * 如果 `direction` 是 `ltr`，那么 `containing block` 的左上角和该元素创建的第一个 box 的 content edge 左上角重叠，右下角和生成的最后一个 box 的右下角重合。

## position schemes

### relative positioning

不改变自身尺寸，不对其他元素的定位有影响。为 `position:absolute` 的后代创建新的 containing block。

如果 `left` 和 `right` 为 `auto`，那么解析为 0

如果两者都不为 `auto`，根据 `containing block` 的 `direction` 决定，如果是 `ltr`，那么使用 `left`，`right` 解析为 `-left`，反之亦然。

如果 `top` 和 `bottom` 两者均不为 `auto`，忽略 `bottom`。

### sticky positioning

和 `relative` 定位类似，但是相对于离元素最近的、拥有 scrolling box 的祖先元素，或者是 viewport。

`left`、`top` 这些值用于限制元素的 offset，水平方向的百分比值相对于它 flow box 的宽度，垂直方向的百分比值相对于 flow box 的高度。

### top、bottom、left、right

`top`、`bottom` 的值为百分比时，是相对于 `containing block` 的 `height`；`left` 和 `right` 是相对于 `width`。

### Sizing and positioning details

https://www.w3.org/TR/css-position-3/#size-and-position-details
