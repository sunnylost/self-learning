# Webpack

模块打包器( module bundler )

## 特点

- [code splitting](http://webpack.github.io/docs/code-splitting.html)

    将代码按照依赖拆分 `sync` 与 `async`, `async` 会异步加载, 减少初次下载量.

- [Loader](http://webpack.github.io/docs/loaders.html)

- clever parsing, 除了处理 `AMD` 与 `CMD` 格式的代码, 还能处理类似 `require("./templates/" + name + ".jade")` 这样的

- [插件](http://webpack.github.io/docs/plugins.html)


[教程](http://webpack.github.io/docs/tutorials/getting-started/)

`webpack --profile --json > stats.json` 执行分析, [这里](http://webpack.github.io/analyse/)查看分析结果.

## [webpack dev server](http://webpack.github.io/docs/webpack-dev-server.html)

`webpack-dev-server`, 启动一个 `Express` 服务器, 所有的缓存都在内存中, 不需要写入文件.

两种模式:

1. `iframe` 模式, 访问 `http://<host>:<port>/webpack-dev-server/<path>`, 页面顶部会显示一个信息栏, 不需要额外配置.

2. `inline` 模式, 访问 `http://<host>:<port>/<path>`, 启动 `server` 的时候需要增加 `--inline` 参数.

这两种模式都可以达到自动刷新效果.

## Hot Module Replacement

使用 `webpack-dev-server --hot --inline`

注意, 需要在本地安装 `webpack`, `--hot` 命令会自动将 `node_modules/webpack/hot/dev-server.js` 添加进 `entry` 中.

大致流程:

- `dev-server.js` 监听 `message` 事件
- `webpack` 监听到资源变动, 编译后, 通过 `Socket` 将变动的 `hash` 值传到页面
- `upToDate()` 检测 `hash` 是否传递过, 如果没有, 则是新改动
- 如果此时的 `module.hot` 是 `idle` 状态, 那么调用 `module.hot.check()` 检测(`HotModuleReplacement.runtime.js`)
- `hotDownloadManifest()` 中向服务器请求 `${hotCurrentHash}.hot-update.json`, 它的返回值包括 `chunk id`
- 根据 `chunk id` 执行 `hotDownloadUpdateChunk()` 来获取更新的 `chunk`
- `webpackHotUpdateCallback()` 获得更新的模块, 调用 `hotAddUpdateChunk()`
- `getAffectedStuff()` 获取受影响的模块
- 进入 `dispose` 阶段, 设置当前模块的 `active` 为 `false`, 将将其从 `installedModules` 已安装模块列表中删除, 如果存在子模块, 模块将子模块删除
- 进入 `apply` 阶段, 执行真正应用模块的回调函数. 真正操作的函数由 `loader` 提供, 例如 `css` 的修改会使用 `style-loader` 中提供的函数更新样式.
- 更新完毕, 重新进入 `idle` 阶段.
- 再次检测 `upToDate()`, 确认 `hash` 是否相符


