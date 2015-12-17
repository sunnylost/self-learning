[ECMA 262](https://github.com/tc39/ecma262)

[ES7 and beyond](https://speakerdeck.com/jfairbank/html5devconf-es7-and-beyond)

[ES7 compat table](http://kangax.github.io/compat-table/es7/)

[ES6 rename to ES2015](https://esdiscuss.org/topic/javascript-2015)

## Stage 4 - Finished

- [Array.prototype.includes](https://github.com/tc39/Array.prototype.includes/)
    
    之前是 `Array.prototype.contains`,但是存在兼容问题,所以 `Array.prototype.contains` 与 `String.prototype.includes` 都改成了 `includes`.
    
    ```javascript
    if ( arr.includes( el ) ) {
    }
    ```
    
## Stage 3 - Candidate

- [Exponentiation Operator](https://github.com/rwaldron/exponentiation-operator)
    
    ```javascript
        5**3 == Math.pow( 5, 3 )
    ```
    
- [Trailing commas in function parameter lists and calls](https://jeffmo.github.io/es-trailing-function-commas/)

    ```javascript
    function test(
        param1,
        param2,
        param3,
    )
    ```
    
- [Object.values / Object.entries](https://github.com/tc39/proposal-object-values-entries)

    ```javascript
    var obj = {
        a: 1,
        b: 2,
        c: 3
    }
    
    Object.keys( obj ); //[ "a", "b", "c" ]  ES 5
    Object.values( obj ); //[ 1, 2, 3 ]
    Object.entries( obj );//[ [ "a", 1 ], [ "b", 2 ], [ "c", 3 ] ]
    ```
    
- [String.prototype.padStart / String.prototype.padEnd](https://github.com/tc39/proposal-string-pad-start-end)
    
    ```javascript
    //String.prototype.padStart( maxLength [, fillString ] )
    "hello".padStart( 6, '123' ); //"1hello"
    ```
    
- [Async Functions](https://tc39.github.io/ecmascript-asyncawait/)


## Stage 2 - Draft

- [Object Rest/Spread Properties for ECMAScript](https://github.com/sebmarkbage/ecmascript-rest-spread)

    ```javascript
    //Rest properties
    let { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
    x; // 1
    y; // 2
    z; // { a: 3, b: 4 }
    
    //Spread Properties
    let n = { x, y, ...z };
    n; // { x:1, y:2, a:3, b:4 }
    ```
    
- [function.sent](https://github.com/allenwb/ESideas/blob/master/Generator%20metaproperty.md)

第一次调用 `next()` 时会执行 `generator` 的函数体,这时候通过 `next()` 传入的参数会被忽略掉.

`function.sent` 表示通过 `next()` 传入的参数值.


## Stage 1 - Proposal

- [trimLeft and trimRight](https://github.com/sebmarkbage/ecmascript-string-left-right-trim)

    `String.prototype.trimLeft/trimRight` 将改名为 `String.prototype.trimStart/trimEnd`.
    
- [System.global](https://github.com/tc39/proposal-global)

    获取全局对象.
    
- [ES Class Fields & Static Properties](https://github.com/jeffmo/es-class-fields-and-static-properties)

    ```javascript
    //instance field
    class MyClass {
      myProp = 42;
    
      constructor() {
        console.log(this.myProp); // Prints '42'
      }
    }
    
    //static property
    class MyClass {
      static myStaticProp = 42;
    
      constructor() {
        console.log(MyClass.myStaticProp); // Prints '42'
      }
    }
    ```
    
- [Function.prototype.toString revision](https://github.com/michaelficarra/Function-prototype-toString-revision)

- [String.prototype.matchAll](https://github.com/tc39/String.prototype.matchAll)

- [ArrayBuffer.transfer](https://gist.github.com/lukewagner/2735af7eea411e18cf20)

- [Additional export-from statements](https://github.com/leebyron/ecmascript-more-export-from)

- [Call constructor](https://github.com/tc39/ecma262/blob/master/workingdocs/callconstructor.md)

    ES 5 中构造函数既可以用 `new` 调用, 也可以直接作为函数调用. ES 6 的 `Class` 只能用 `new`.
    
    ES 6 增加了 `new.target`[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target) 来在函数中判断是否通过 `new` 调用.
    
    ```javascript
    function Foo() {
      if (!new.target) throw "Foo() must be called with new";
      console.log("Foo instantiated with new");
    }
    ```
    
    `new.target` 缺点:
        - 需要使用 `function`
        - 语义不明显
        
    使用新的 `call`:
    
        ```javascript
        import { initializeDate, ToDateString } from './date-implementation';
        
        class Date {
          constructor(...args) {
            initializeDate(super(), ...args);
          }
        
          call constructor() {
            return ToDateString(clockGetTime());
          }
        }
        ```
        
- [ECMAScript Observable](https://github.com/zenparsing/es-observable)

    [RxJS](https://github.com/Reactive-Extensions/RxJS)
    
- [Class and Property Decorators](https://github.com/wycats/javascript-decorators/blob/master/README.md)
    
## Stage 0 - Strawman

- [Private State](https://github.com/wycats/javascript-private-state)

    ```javascript
    class {
      private #data1;   // data1 is the name of a private data slot
                        // the scope of 'data1' is the body of the class definition 
      constructor(d) {
        // #data1 has the value undefined here
    
        // # is used to access a private data slot
        // #data1 is shorthand for this.#data1
        #data1 = d; 
      }
    
      // a method that accesses a private data slot
      get data() {
        return #data1;
      }
    }
    ```

- [Function Bind Syntax](https://github.com/zenparsing/es-function-bind)
    
    ```javascript
    // Create bindings for just the methods that we need
    let { find, html } = jake;
    
    // Find all the divs with class="myClass", then get all of the "p"s and
    // replace their content.
    document.querySelectorAll("div.myClass")::find("p")::html("hahaha");
    
    
    $(".some-link").on("click", ::view.reset);
    ```
    
## Removed

- `Object.observe`
    
    * [An update on Object.observe](https://esdiscuss.org/topic/an-update-on-object-observe)
    * [Death of Object.observe()](https://www.sitepen.com/blog/2015/11/06/death-of-object-observe/)
