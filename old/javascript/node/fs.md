# fs.js

fs.contants 静态常量，多用于描述状态或权限。多个常量可以使用 `|` 来组合。

`handleError( val, callback )` 用来处理异常，如果传了 `callback` 函数，那么将 `val` 传入 `callback` 中，否则抛出异常。使用该函数来实现 node 异步模式的错误处理方式。与此类似的方法还有 `nullCheck( path, callback )`

## fs.access( path[, mode], callback )

检查 `path` 对应文件的权限。`mode` 默认是 `fs.contants.F_OK`，可以用该方法检测文件是否存在。

`R_OK` 表示可读取，`W_OK` 表示可以写入，`X_OK` 表示可执行。

但是不推荐在 `fs.open()`、`fs.readFile()`、`fs.writeFile()` 前使用该方法来检测文件状态。

