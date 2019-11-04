## events.js

`EventEmitter.defaultMaxListeners`, 监听器最多为 10 个,超过这个数字会给出警告,用于查找内存泄露

依赖了 `domain` 模块

`emitNone`, `emitOne`, `emitTwo`, `emitThree` 参数个数固定可以更好的优化,提升性能.

`once` 中使用了 `fired` 变量来验证事件是否执行过,应该是考虑到了在事件中又触发自身事件的情况.
