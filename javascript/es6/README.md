# ES 6

## Learning Materials

- [Understanding ECMAScript 6](https://leanpub.com/understandinges6/read/)
- [ECMAScript 6 入门](http://es6.ruanyifeng.com/)

## 字符串

`repeat()`，不必再用创建数组后 `join('')` 来模拟了。

### 更好的支持 Unicode

`String` 增加了 `codePointAt()`, `fromCodePoint()`, `normalize()` 方法。

`u{xxxxx}` 来转义 Non-BMP 字符

### 简化匹配操作

`includes()` 来替代 `indexOf() != -1` 这样的判断。

`startsWith()` 与 `endsWith()` 同样简化匹配操作。


## 正则表达式

用已存在的正则对象来创建新的正则对象(并修改 flag) 不会报错。

```javascript
var r1 = /ab/i,
	r2 = new RegExp( r1, 'g' )
```

ES 5 中，正则对象的 `source` 属性没有 `flag` 的信息，ES 6 增加了 `flags` 属性：

```javascript
var r = /ab/i
r.source //ab
r.flags  //i
```

### `u` flag

更好的支持 Unicode

### `y` flag

sticky，黏着，会在匹配后自动更新正则对象的 `lastIndex` 属性，作为匹配的起点。

**注意，带有 `y` flag 的正则会默认拥有 `/^/`。** 

## Object

### `is()`

绝对部分时候等同于 `===`，除了对于 `NaN`，`0`，`-0`

```javascript
NaN === NaN  	      //false
Object.is( NaN, NaN ) //true

0 === -0           //true
Object.is( 0, -0 ) //false
```

正负 0 只有做为被除数的时候才有区别，`x / 0` 得到 `Infinity`，`x / -0 ` 得到 `-Infinity`。