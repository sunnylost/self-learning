## 读书笔记

* [Flash ActionScript 3.0 动画教程](http://book.douban.com/subject/3016575/)
* [Foundation HTML5 Animation with JavaScript (上本书的 canvas 版)](http://book.douban.com/subject/6749476/)

## 三角学(Trigonometry)

研究三角形与其边和角关系的学科。

### 弧度制(radian)与角度制(degress)

一个圆的弧度是 2π，角度是 360°

* radians = degrees * Math.PI / 180
* degrees = radians * 180 / Math.PI

在直角三角形中，构成直角的两条边称为 *Leg*，斜边为 *Hypotenuse*。一个角的 *opposite side(对边)*是不构成该角的那条边，*adjacent side(邻边)*是构成角的两条边之一。

### Sine 正弦

sin(angle) = opposite / hypotenuse

### Cosine 余弦

cos(angle) = adjacent / hypotenuse

### Tangent 正切

tan(angle) = opposite / adjacent

### Arcsine, Arccosine, Arctangent

根据比值返回角度值。其中反正切使用 `Math.atan2()`，它能计算出角度的正负值。

## Canvas

### 获取上下文

```javascript
var canvas = document.getElementById( 'canvas' )
var ctx = canvas.getContext( '2d' )
```

### 清空绘制区域

```javascript
ctx.clearRect( x, y, width, height )
```

### 设置线

* **strokeStyle** 线的颜色
* **lineWidth** 线的宽度
* **lineCap** 端点样式
* **lineJoin** 交汇点样式
* **miterLimit** 跟 **lineJoin** 值为 *miter* 相关

**canvas.save()** 将当前样式入栈，**canvas.restor()** 样式出栈。

### lineTo 和 moveTo

**lineTo** 表示从当前点画一条线到终点，**moveTo** 移动到起始点。

canvas 有且只有一条当前路径(path)，`ctx.beginPath()` 开始绘制一条新路径。使用 `ctx.stroke()` 将线绘制到画布上。

```javascript
ctx.beginPath()
ctx.moveTo( 0, 0 )
ctx.lineTo( 100, 100 )
ctx.stroke()
```

## 曲线

`ctx.quadraticCurveTo( cpx, cpy, x, y )` 需要两个点做参数，第一个点是控制点，控制曲线形状，第二点是终点。曲线形状根据贝塞尔曲线公式计算。

除此之外还有 `bezierCurveTo( cp1x, cp1y, cp2x, cp2y, x, y )`、`arcTo( cp1x, cp1y, cp2x, cp2y, radius )`、`arc( x, y, radius, startAngle, endAngle[, antiClockwise] )` 等方法绘制曲线。

## 操作像素

获取像素数据：

```javascript
var imagedata = ctxt.getImageData( x, y, width, height )
```

创建空白的 `ImageData` 对象：

```javascript
var imagedata = ctxt.createImageData( width, height )
```

`ImageData` 的 `data` 属性是个一维数组，按照 RGBA 的顺序保存了所有像素的信息。

在画布上绘制 `ImageData`，其中，`x` 和 `y` 是绘制区域的左上角：

```javascript
ctx.putImageData( imageData, x, y )
```

## Velocity(速率)与 Acceleration(加速度)

velocity 不同于 speed，因为它还包含了 direction(方向)，因此它的完整定义为：某个方向上的速度。

acceleration 与 velocity 类似，同样是向量，但它改变的不是 speed，而是 velocity。

将角速度转换为 x, y 速度向量：

* `vx = speed * Math.cos( angle )`
* `vy = speed * Math.sin( angle )`

## friction(摩擦力)

与速度向量相反

```javascript
speed = Math.sqrt( vx * vx + vy * vy )
angle = Math.atan2( vy, vx )
if ( speed > friction ) {
    speed -= friction
} else {
    speed = 0
}
```

计算摩擦力的简便方法：

```javascript
vx *= friction
vy *= friction
```

## easing 与 spring

最简单的 easing(缓动) 解释就是速度与距离成比例。

```javascript
var dx = targetX - o.x,
	dy = targetY - o.y

vx = dx * easing
vy = dy * easing

o.x += vx
o.y += vy
```

spring(弹簧) 运动则是加速度与距离成比例。

```javascript
var ax = ( targetX - o.x ) * spring,
	ay = ( targetY - o.y ) * spring

vx += ax
vy += ay

vx *= friction
vy *= friction

o.x += vx
o.y += vy
```

偏移弹性运动：

```javascript
var dx = o.x - fixedX,
	dy = o.y - fixedY,
	angle = Math.atan2( dy, dx ),
	targetX = fixedX + Math.cos( angle ) * springLength,
	targetY = fixedY + Math.sin( angle ) * springLength
```

## 坐标旋转

### 简单坐标旋转

当物体绕着一个点进行旋转时，根据如下方式计算出每次旋转时，物体的位置：

```javascript
x, y       //物体的坐标
angle      //初始角度
rv = .05   //每次旋转的角度
centerX, centerY //中心点的坐标，物体绕着该点旋转

angle += rv  //旋转
dx = x - centerX //物体距离旋转点的横坐标
dy = y - centerY //...
dist  = Math.sqrt( dx * dx + dy * dy ) //物体和中心点的距离
angle = Math.atan2( dy, dx )
x1 = centerX + cos( angle ) * dist
y1 = centerY + sin( angle ) * dist
```

### 高级坐标旋转

公式：

- x1 = x * cos( rotation ) - y * sin( rotation )
- y1 = y * cos( rotation ) + x * sin( rotation )

rotation 是物体在这一帧中旋转的角度

公式推导：

```javascript
x = radius * cos( angle )
y = radius * sin( angle )
x1 = radius * cos( angle + rotation )
y1 = radius * sin( angle + rotation )

//根据三角函数的公式进行变换
//cos( a + b ) = cos( a ) * cos( b ) - sin( a ) * sin( b )
//sin( a + b ) = sin( a ) * cos( b ) + cos( a ) * sin( b )

x1 = radius * cos( angle ) * cos( rotation ) - radius * sin( angle ) * sin( rotation )
y1 = radius * sin( angle ) * cos( rotation ) + radius * cos( angle ) * sin( rotation )

//再根据前面 x 和 y 的等式
x1 = x * cos( rotation ) - y * sin( rotation )
y1 = y * cos( rotation ) + x * sin( rotation )
```