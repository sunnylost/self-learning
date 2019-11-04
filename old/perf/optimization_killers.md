# [Optimization killers](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers)

*原文最后修改时间：2014-8-22*

*挑选主要内容进行翻译*

## 介绍

该文档包含了一些建议，来使你避免写出影响性能的代码，特别是那些会阻止 V8(涉及到 Node.JS，Opera，Chromium 等) 优化受影响函数的模式。

### V8 的一些背景资料

V8 没有解释器(interpreter)，而是有两个不同的编译器：通用编译器(generic)与优化编译器(optimizing)。这意味着你的 JavaScript 始终会被编译成本地代码(native code)来运行，但是`没有经过优化`的本地代码并不会显著提升性能。

例如，`a + b` 在通用编译器中会被编译成：
```nasm
mov eax, a
mov ebx, b
call RuntimeAdd
```

如果 `a` 与 `b` 始终是数字，在优化编译器中就是：
```nasm
mov eax, a
mov ebx, b
add eax, ebx
```

一般来说，优化编译器生成的代码会比通用编译器生成的快 `100` 倍。但并不是所有代码都能被优化，对于一些特定代码，编译器会始终拒绝优化。

需要注意的是，无法被优化的代码会导致它所在的函数也不被优化。

## 主题

### 1. 工具

用 node.js 加上一些 V8 参数就能够检测哪些代码影响优化。通常的做法是，写一个函数来包含这些代码，执行，再利用 V8 的内部函数对它进行优化，比对结果。

test.js:

```javascript
//Function that contains the pattern to be inspected (using with statement)
function containsWith() {
    return 3;
    with({}) {}
}

function printStatus(fn) {
    switch(%GetOptimizationStatus(fn)) {
        case 1: console.log("Function is optimized"); break;
        case 2: console.log("Function is not optimized"); break;
        case 3: console.log("Function is always optimized"); break;
        case 4: console.log("Function is never optimized"); break;
        case 6: console.log("Function is maybe deoptimized"); break;
    }
}

//Fill type-info
containsWith();

%OptimizeFunctionOnNextCall(containsWith);
//The next call
containsWith();

//Check
printStatus(containsWith);
```

运行：
```
$ node --trace_opt --trace_deopt --allow-natives-syntax test.js
Function is not optimized
```

注释掉 `with` 再运行一遍：
```
$ node --trace_opt --trace_deopt --allow-natives-syntax test.js
[optimizing 000003FFCBF74231 <JS Function containsWith (SharedFunctionInfo 00000000FE1389E1)> - took 0.345, 0.042, 0.010 ms]
Function is optimized
```

### 2. 不支持的语法

有些结构不被优化编译器支持，使用它们会导致包含它们的整个函数不被优化。

注意：只要存在这样的结构就会导致函数不被优化，不管它们能否被执行。

例如：
```javascript
if (DEVELOPMENT) {
    debugger;
}
```
即便程序永远无法到达 `debugger` 语句，整个函数也会受到影响。

目前不会被优化的结构：

* Generator 函数
* 包含 for of 的函数
* 包含 try catch 的函数
* 包含 try finally 的函数
* 对象字面量中出现 `__proto__`，`get` 或 `set` 声明的所在函数

看样子永远不会被优化的结构：

* 包含 `debugger` 语句的函数
* 直接调用 `eval()` 的函数
* 包含 `with` 语句的函数

以下的代码会让整个函数不被优化：

```javascript
function containsObjectLiteralWithProto() {
    return {__proto__: 3};
}
```

```javascript
function containsObjectLiteralWithGetter() {
    return {
        get prop() {
            return 3;
        }
    };
}
```

```javascript
function containsObjectLiteralWithSetter() {
    return {
        set prop(val) {
            this.val = val;
        }
    };
}
```

#### 解决办法

有些时候很难避免不写 `try catch` 或 `try finally`，为了减少这些代码造成的影响，需要将它们从主要代码中隔离出去：

```javascript
var errorObject = {value: null};
function tryCatch(fn, ctx, args) {
    try {
        return fn.apply(ctx, args);
    }
    catch(e) {
        errorObject.value = e;
        return errorObject;
    }
}

var result = tryCatch(mightThrow, void 0, [1,2,3]);
//Unambiguously tells whether the call threw
if(result === errorObject) {
    var error = errorObject.value;
}
else {
    //result is the returned value
}
```

### 3. 处理 `arguments`

使用 `arguments` 时要额外注意，以下写法会导致所在函数不被优化。

#### 3.1 在函数体中使用 `arguments`，并为已经定义的参数重新赋值：

```javascript
function defaultArgsReassign(a, b) {
     if (arguments.length < 2) b = 5;
}
```

##### 解决办法：用新的变量来保存参数

```javascript
function reAssignParam(a, b_) {
    var b = b_;
    //与 b_ 不同，b 可以被安全的重新赋值
    if (arguments.length < 2) b = 5;
}
```
如果使用 `arguments` 只是用来确保 `b` 是否存在，可以直接和 `undefined` 做比较

```javascript
function reAssignParam(a, b) {
    if (b === void 0) b = 5;
}
```

#### 3.2 参数泄露

```javascript
function leaksArguments1() {
    return arguments;
}
```

```javascript
function leaksArguments2() {
    var args = [].slice.call(arguments);
}
```

```javascript
function leaksArguments3() {
    var a = arguments;
    return function() {
        return a;
    };
}
```

避免传递或泄露 `arguments` 对象。

##### 解决办法：

```javascript
function doesntLeakArguments() {
    //.length 只是个整数，不会泄露整个 arguments 对象
    var args = new Array(arguments.length);
    for(var i = 0; i < args.length; ++i) {
        //i 始终是 arguments 对象的合法下标
        args[i] = arguments[i];
    }
    return args;
}
```

#### 3.3 为 arguments 赋值：

非严格模式下，可以这么操作：

```javascript
function assignToArguments() {
    arguments = 3;
    return arguments;
}
```

##### 解决办法：不要写这种代码，或者用严格模式，代码会直接报错。

#### `arguments` 的安全使用方式

只使用

* `arguments.length`
* `arguments[i]`，其中 `i` 必须是合法的下标，不能越界
* `x.apply(y, arguments)` ，因为 `Function#apply` 比较特殊，但是 `.slice` 不行

### 4. Switch-case

`case` 不要超过 128 个：

```javascript
function over128Cases(c) {
    switch(c) {
        case 1: break;
        case 2: break;
        case 3: break;
        ...
        case 128: break;
        case 129: break;
    }
}
```

### 5. For-in

#### 5.1 key 不是局部变量

```javascript
function nonLocalKey1() {
    var obj = {}
    for(var key in obj);
    return function() {
        return key;
    };
}
```

```javascript
var key;
function nonLocalKey2() {
    var obj = {}
    for(key in obj);
}
```

必须确保 `key` 是局部变量，不能来自于其他作用域。

#### 5.2 被循环的对象不是一个“simple enumerable(简单的可遍历)”对象

##### 5.2.1 处于“hash table mode(哈希表模式)”的对象不是“simple enumerable”

“hash table mode” 也称为“normalized objects(规范化的对象)”，“dictionary mode(字典模式)”，即以哈希表作为底层数据结构的对象。

```javascript
function hashTableIteration() {
    var hashTable = {"-": 3};
    for(var key in hashTable);
}
```

动态添加过多属性(在构造器外)，`delete`属性，使用非法标识符作为属性名等等都会使对象进入哈希表模式。不要对这样的对象进行 `for-in` 操作。

在 Node.JS 中开启 `--allow-natives-syntax` 参数，使用 `console.log(%HasFastProperties(obj))` 来检查对象是否进入哈希表模式。

##### 5.2.2 对象的原型链上有可遍历属性

```javascript
Object.prototype.fn = function() {};
```

这样的对象在执行 `for-in` 操作时不会被优化。

应该使用 `Object.defineProperty` 来创建不可遍历的属性。

##### 5.2.3 对象包括可遍历的数组下标

[ECMAScript 规范](http://www.ecma-international.org/ecma-262/5.1/#sec-15.4)中定义了一个属性是否为数组下标：

> 若属性名 P (表现为一个 String 值) 为数组下标，当且仅当 ToString(ToUint32(P)) 与 P 相等，并且 ToUint32(P) 不等于 to 2<sup>32</sup>−1。属性名为数组下标的属性也称为元素(element)

普通对象也可以拥有数组下标：

```javascript
normalObj[0] = value;
```

```javascript
function iteratesOverArray() {
    var arr = [1, 2, 3];
    for (var index in arr) {

    }
}
```

这会导致整个函数不被优化。

##### 解决办法：循环对象使用 `Object.keys`，循环数组用 `for`。如果必须要获取整个原型链上的属性，使用单独的工具方法：

```javascript
function inheritedKeys(obj) {
    var ret = [];
    for(var key in obj) {
        ret.push(key);
    }
    return ret;
}
```
