# ES 6

## Learning Materials

- [Understanding ECMAScript 6](https://leanpub.com/understandinges6/read/)
- [ECMAScript 6 入门](http://es6.ruanyifeng.com/)
- [ES6 in depth](https://ponyfoo.com/articles/tagged/es6-in-depth)
- [ES6 Overview in 350 Bullet Points](https://github.com/bevacqua/es6)

## Block Binding

使用 `let` 和 `const` 定义的变量不会 hoist.

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

## Symbol

新增基础类型, 用于作为对象的 `key`.

`System.for( name )` 会去根据 `name` 查找已经存在的 `Symbol` 并返回.

`Symbol` 实例无法用于字符串拼接, 只能手动调用 `toString()` 或用 `String()` 构造函数转换.

## Object

### `is()`

绝大部分时候等同于 `===`，除了对于 `NaN`，`0`，`-0`

```javascript
NaN === NaN  	      //false
Object.is( NaN, NaN ) //true

0 === -0           //true
Object.is( 0, -0 ) //false
```

正负 0 只有做为被除数的时候才有区别，`x / 0` 得到 `Infinity`，`x / -0 ` 得到 `-Infinity`。

## Class

- 目前只支持方法,不支持属性(ES 7). 
- 所有方法均不可遍历.
- `Class` 内的代码处于严格模式下.
- 调用 `Class` 必须使用 `new`, 否则报错.
- `Class` 名对于内部来说是 `const` 定义的,无法覆盖. 对于外部代码没有影响.
- `Class` 与 `function` 一样, 均有声明和表达式两种定义方式, 也能作为参数传递.

## Function

### default parameter

    ```javascript
    function test( a, b = 12 ) {
    }
    ```
    
只要使用了 ES 6 的默认参数, `arguments` 就自动遵从 ES 5 的严格模式,与参数解绑.
    
    ```javascript
    function getValue() {
        return 5;
    }
    
    function add(first, second = getValue()) {
        return first + second;
    }
    
    console.log(add(1, 1));     // 2
    console.log(add(1));        // 6
    ```

`getValue()` 只有在 `add` 调用,并且没有传第二个参数时才会被执行.
