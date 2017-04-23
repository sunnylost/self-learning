
node.cc 中的 `SetupProcessObject` 设置 `process` 对象，它是 C++ 对象
process.binding 是在引入 C++ 模块，来使用对应的方法

## 编译后的模块
node/out/Release/obj/gen/node_javascript.cc 中含有 `lib` 下的模块内容，以 uint8 数组形式存储

## lib/bootstrap_node.js

这是 js 部分的入口文件

该文件实现了一个简单的模块系统，用于加载 node 核心文件(`/lib/*.js`)，所有的这些文件都已经被编译进了 node 的可执行文件中，因此加载速度很快。

`NativeModule._source = process.binding('natives')`

所有的内部模块的源码都在这里，通过 id 获取

- require:
  不知道这个是有什么用 `process.moduleLoadList.push(`NativeModule ${id}`)` 
  先从缓存中获取
  否则检查 id 是否存在
  存在就去创建对应的 NativeModule 实例
  执行 `cache()` 和 `compile()`
  返回 `exports`

- compile:
  编译内部模块。先获取源码，然后调用 `wrap()`
  `wrap()` 就是在源码前后增加额外的代码：

  ```javascript
  NativeModule.wrapper = [
      '(function (exports, require, module, __filename, __dirname) { ',
      '\n});'
    ];
  ```
  
  执行代码 `runInThisContext()`
  
### startup()

将 `process` 的原型设置为 `EventEmitter`，`Object.setPrototypeOf()` 是个性能非常差的方法，尽量避免使用。node 在初始化时使用没有关系。

`setupProcessFatal()`: 设置 `process._fatalException()`，如果异常没有被捕获，那么触发 `process` 的 `uncaughtException` 事件，然后线程准备退出，触发 `exit` 事件。如果被捕获，执行 `NativeModule.require('timers').setImmediate(process._tickCallback);`

`setupGlobalVariables()`： **不知道 `global` 对象在哪里注入的。**
  只看到设置了 `toString` 的值，设置了 process 引用
  
如果在启动时增加了 `--no-browser-globals` 参数，表示不会引入全局定时器和 console 方法。

接下来是处理 `/internal/process`
然后是命令行参数，这里先略过

开始解析用户代码：

```javascript
if (process.argv[1] && process.env.NODE_UNIQUE_ID) {
    const cluster = NativeModule.require('cluster');
    cluster._setupWorker();

    // Make sure it's not accidentally inherited by child processes.
    delete process.env.NODE_UNIQUE_ID;
  }
  ```
  
引入 `path` 模块，解析文件路径
引入 `module` 模块
预加载模块(如果存在)
执行 `Module.runMain()`

其他分支是直接执行命令行输入的代码，或者进入 repl 模式

