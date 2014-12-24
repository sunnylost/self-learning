# CSS pixel 笔记(to be continued...)

名词：

* `hardware pixel`: 屏幕能显示的最小点，通常由红，绿，蓝三个 sub-pixels 组成。
* `reference pixel`: 在一个像素密度(pixel density)为 96dpi 的设备上，从一臂的距离外看屏幕上的一个像素的视角。(这里说的一像素是指 1pt，即 1/96 英寸，一臂的距离是指 28  英寸)
* `device-pixel-ratio`: 设备像素与 CSS 像素的比例
* `dpi`: 分辨率单位，每英寸内的点数(点就是设备像素)。
* `dppx`: 分辨率单位，每像素内的点数。1ddpx = 96dpi

**CSS 像素 != 设备像素**

如果两者相同，那么分辨率越高，像素就会越小。使用与设备像素无关的角度度量就不会有这样的问题。

>CSS 中的像素与屏幕像素无关，它实际上是角度度量(angular measurement)，它与弧度之间的转换公式为：

> radians = arctan(px / 5376) * 2
> 
> px = 5376 * tan(radians / 2)



#### 参考资料：

* [像素（px）到底是个什么单位](http://hax.iteye.com/blog/374323)
* [Master CSS pixels for Retina displays](http://www.creativebloq.com/css3/master-css-pixels-retina-displays-8122955)
* [CSS px is an Angular Measurement](http://inamidst.com/stuff/notes/csspx)
* [A pixel is not a pixel is not a pixel](http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html)
* [A tale of two viewports — part one](http://www.quirksmode.org/mobile/viewports.html)
* [CSS Values and Units Module Level 3](http://www.w3.org/TR/css3-values/#reference-pixel)
* [CSS Units](https://www.webkit.org/blog/57/css-units/)
* [Pixel](http://en.wikipedia.org/wiki/Pixel)
* [A Pixel Identity Crisis](http://alistapart.com/article/a-pixel-identity-crisis/)
* [Working with dppx](http://madewithdrew.com/blog/working-with-dppx/)
* [Device pixel density tests](http://bjango.com/articles/min-device-pixel-ratio/)