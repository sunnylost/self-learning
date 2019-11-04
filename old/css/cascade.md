# CSS Cascading and Inheritance

[Link](https://www.w3.org/TR/css-cascade-4/)

## @import

带条件的 `@import`

```css
@import url("narrow.css") handheld and (max-width: 400px);

@import url("fallback-layout.css") supports(not (display: flex));
```

## shorthand properties

有些属性是缩写，例如 `font`、`background`，设置它们会设置对应的 `longhand property` 的值。如果在 `shorthand` 形式中没有全部设置，那么遗漏的属性默认设置为 `initial value`。

如果设置的值是 `CSS-wide` 关键字之一(`initial`、`inherit`、`unset`)，那么所有子属性都会设置成该值。

`all` 属性表示元素的所有 CSS 属性(除了 `direction` 和 `unicode-bidi`)。可以设置为 `initial | inherit | unset | rever`。

## 值的计算过程

通常会经过以下过程：
1. 所有对元素生效的 `declared value` 被收集
2. 层叠生成 `cascaded value`，即 `declared value` 中权重最高的
3. 如果有些属性没有值，使用它的默认值，生成 `specified value`
4. 生成计算值，例如有些值使用相对单位，如 `em` 等，在这个阶段要计算成绝对值，即 `computed value`。
5. 完成剩余计算，得到 `used value`。
6. 由于显示环境的限制，`used value` 最终还需要处理成 `actual value`，例如环境不支持像素值为小数，颜色有限制等等。

## Cascading

