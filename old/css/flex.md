# CSS Flexible Box Layout

[link](https://www.w3.org/TR/css-flexbox-1/)

## Flex Layout Box Model

`display` 的计算值为 `flex` 或 `inline-flex` 时生成 `flex container`，`flex container` 的子元素称为 `flex items`。

<image src="https://www.w3.org/TR/css-flexbox-1/images/flex-direction-terms.svg"></image>

`main` 表示横向，`cross` 表示纵向。

## flex 和 inline-flex

这两个值使元素生成 block-level 和 inline-level 的 `flex container`。`flex container` 会创建 `flex formatting context`。


## flex items

flex container 的 flex items 是指 in-flow 内容。

如果一段文字直接包含在 flex container 中，会被一个 `anonymous flex item` 包裹起来。

flex item 会为它的内容创建新的 formatting context，上下文的类型根据 `display` 的值确定。

### 绝对定位

因为绝对定位是 out-of-flow，所以不参与 flex 布局。

TODO

### margin 和 padding

flex item 的 margin 不会发生折叠。

不推荐使用百分比作为 margin/padding 的值。因为目前存在两种计算方式，在不同浏览器上会出现兼容问题。

值为 `auto` 在下面介绍。

### z-index

flex item 按照 inline block 来绘制，但是 `order` 可以改变他们在文档中的位置，`z-index` 只要不是 `auto`，就会创建新的 stacking context，即使它的 `position` 是 `static`。

### collapsed items

TODO, 关于 `visibility:collapse`

### minimum size

为 `min-width` 和 `min-height` 增加了 `auto` 值。表示 `automatic minimum size` 或者 0。

`automatic minimum size` 表示 `content size` 和 `specified size` 中的较小值。
- specified size 表示 `width`/`height` 的计算值
- content size

TODO，细节太多

## ordering and Orientation

flex container 内容的顺序不影响实际的文档顺序

### flex-direction

通过设置 flex container 的 main axis 来控制内容顺序：
- row，main axis 与当前 writing mode 的 inline axis 相同，main-start 和 main-end 与 line-start 和 line-end 方向相同
- row-reverse，同 `row`，只是方向相反
- column，main axis 与当前 writing mode 的 block axis 相同
- column-reverse，同 `column`，只是方向相反

### flex-wrap

控制 flex container 是单行还是多行，cross axis 的方向，来决定新行堆叠的方向。
- nowrap，单行
- wrap，多行
- wrap-reverse，同 `wrap`，但 cross axis 方向相反

### flex-flow

就是 `flex-direction` 与 `flex-wrap` 两个属性的合并。

### order

这个设置在 flex items 上，规范上说对绝对定位的元素也生效，目前没看出来。

初始值是 0，按照从小到大排列，例如设置成 -1，就会排到前面。

## Flex Lines

flex line 是在 flex container 内包含 flex item 的容器，用于布局。

可以分为单行和多行，受 `flex-wrap` 属性控制。

`justify-content` 和 `align-self` 只针对 flex line 内生效。

在多行情况下，每行的 cross size 由包含该行所有 flex item 的最小尺寸决定。单行情况下，cross size 就是 flex container 的 cross size。

## Flexibility

所谓的 `flex` 是指改变 flex item 的宽高来适应有限的空白区域。

如果 flex item 的 `flex-grow` 和 `flex-shrink` 都为 0，那么称之为 `fully inflexible`。

### flex

值为：
- none，表示 `0 0 auto`
- \[<flex-grow> <flex-shrink>? || <flex-basis>]，初始值是 `0 1 auto`，用于 flex item。

`flex` 可以使用四个值来适用于通用状况：
- initial，等价于 `0 1 auto`
- auto，等价于 `1 1 auto`
- none，表示 `0 0 auto`
- <positive-number>，等价于 `<positive-number> 1 0`

### flex-grow

默认值是 0，设置 `flex grow factor`

### flex-shrink

默认为 1，设置 `flex shrink factor`

### flex-basis

`flex basis` 表示 flex item 的初始 main size。

初始值是 `auto`，会去获取该 item 的 main size 属性的值，如果这个值也是 `auto`，那么 `flex-basis` 的值等同于 `content`。

`content` 表示根据 item 的 content 来自动调整尺寸。

`<width>` 设置 main size。

虽然 `flex-basis` 可以设置为 0，但默认情况下，不会小于内容尺寸，这个时候，需要手动设置 `min-width` 和 `min-height`。

## Alignment

### auto margin


