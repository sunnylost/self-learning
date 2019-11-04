## GIF

[What's In A GIF](http://www.matthewflickinger.com/lab/whatsinagif/index.html)，很详细介绍了 GIF 文件的细节，还未读完。

[x-gif](https://github.com/geelen/x-gif)，GIF 内部会包含多张图片来实现动画，图片使用了 LZW 压缩算法。关于控制 gif 文件，我最开始的思路是分析文件，把所有图片提取出来，但 x-gif 采用了更聪明的做法。

GIF 图片结构：

* Header
	* Signature "GIF"
	* Version   "87a" or "89a" 
	* Width
	* Height
	* ...
* Image

大致结构如上，实际上还有各种 Extension 块。x-gif 的做法是，先分析出 Header，再找到每张图片，但不必关心图片的编码，只要确定图片在数据流中的起始和截至位置，获取这些信息后，将 Header 和每张图片的内容拼接在一起，这样就形成了一张合法的静态图片(默认还要一个 footer，但那个内容获取更简单)。

在 Typed Array 中使用 subarray(begin, end) 就可以实现数组的截取操作。

使用 new Blob([Header, frame], {type: 'image/gif'}) 来表示每一张图片。

使用 URL.createObjectURL(blob) 获得图片的 url，这样把它设置到图片的 src 中就可以生效了。

目前还没弄清楚 GIF 的动画是如何实现的。