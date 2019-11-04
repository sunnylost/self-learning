[Dirty Tricks From The Dark Corners Of Front-End](https://speakerdeck.com/smashingmag/dirty-tricks-from-the-dark-corners-of-front-end)

### 在 `a` 标签中嵌套 `a` 标签, 做法就是用 `object` 标签包裹第二个 `a` 标签:

```html
<a href="#link-1">
This is a <object><a href="#link-2">inside link</a></object>, click on it.
</a>
```
### 为加载失败的图片增加样式

`img` 是替换元素, 但加载失败的图片内容不会被替换, 因此可以使用伪元素 `::before` 和 `::after`
