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