# Performance(*DRAFT*)

### 浏览器渲染顺序

1. 解析 HTML，生成 DOM tree
2. 解析 CSS，生成 CSSOM
3. 生成 render tree
4. paint

### 耗能最少的四种动画属性

* position
    * translate(npx, npx)
* scale
* rotation
* opacity

### 由 DOM 到像素经历的过程

1. Recalculate Style：计算适用于元素的样式
2. Layout：生成元素的尺寸与位置
3. Paint Setup and Paint：为每个元素向 layer 里填充像素
4. Composite Layers：将 layer 绘制到屏幕上

**前几个步骤耗时越多，元素就越晚被绘制**


参考资料
===

* [Rendering: repaint, reflow/relayout, restyle](http://www.phpied.com/rendering-repaint-reflowrelayout-restyle/)
* [High Performance Animations](http://www.html5rocks.com/en/tutorials/speed/high-performance-animations/)
* [The Runtime Performance Checklist](http://calendar.perfplanet.com/2013/the-runtime-performance-checklist/)
* [Performance profiling with the Timeline](https://developer.chrome.com/devtools/docs/timeline)