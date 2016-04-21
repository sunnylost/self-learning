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
