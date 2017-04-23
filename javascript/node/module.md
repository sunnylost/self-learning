# module.js

## 初始化

调用 `Module._initPaths()`，初始化 `modulePaths` 与 `Module.globalPaths` 两个变量。

## 工具方法

### stat( filename )
根据 filename 对应的文件类型
`stat` 主要用于缓存，`stat.cache` 是个 Map
如果缓存不存在，则调用 `fs` 的 `internalModuleStat` 方法。

### tryExtensions( p, exts, isMain )
循环 exts，使用 `tryFile()` 解析文件名

### tryFile( requestPath, isMain )
解析文件名

### tryModuleLoad( module, filename )
`module.load(filename)`
`module` 在初始化的时候，已经得到了 `filename`，为什么这里还要传进去？

嗷，实例化时，`filename` 是作为模块的 `id`

### tryPackage( requestPath, exts, isMain )
调用 `readPackage()` 获取 `main` 入口，解析该文件路径

### readPackage( requestPath )
找到该路径下的 `package.json`，获取其中的 `main` 字段

## 静态方法

## runMain()
调用 `_load()` 加载用户代码
`process._tickCallback()`

### _load( request, parent, isMain )
解析模块的文件名`_resolveFilename()`
检查是否有该文件缓存 `Module._cache[filename]`，如果存在，直接返回它的 `exports`

检查是否为内置模块，使用 `expose-internals` 可以暴露 `internal` 下的模块。如果是的话，使用 NativeModule 的引入方式。

初始化 `Module` 实例

如果 `isMain` 为 true，设置 
```javascript
process.mainModule = module;
module.id = '.';
```
缓存 module
调用 `tryModuleLoad(module, filename)`
返回 `module.exports`

### _resolveFilename(request, parent, isMain)
如果是内置模块，直接返回 `request`
调用 `Module._resolveLookupPaths()` 获取检查模块路径。
调用 `Module._findPath()` 查找模块文件名并返回(如果不存在，就抛出“找不到模块”的错误)

### _resolveLookupPaths( request, parent, newReturn )
如果 `request` 是相对路径，解析该路径，添加到 `modulePaths` 内，因为是从 `runMain()` 执行过来，算是第一次执行，所以 `newReturn` 为 `true`，直接返回 `modulePaths`。如果为 `false`，则返回数组 `[ request, paths ]`

第一次执行的时候，没有 `parent`，调用 `Module._nodeModulePaths( '.' )`，并与 `'.'` 和 `modulePaths` 作为数组返回。

如果存在 `parent`，先解析

### _nodeModulePaths( from )
这个方法在 `win32` 平台和其他平台实现不同。
在非 `win32` 平台下，先将 `from` 转为绝对路径。
如果是 `/`，返回 `[ '/node_modules' ]`
接下来的代码是在绝对路径的每个目录下都增加 `node_modules` 路径，然后返回

### _findPath( request, paths, isMain )
这个函数就是在 `paths` 里查找 `request` 模块。

如果 `request` 是个绝对路径，就清空 `paths`，因为绝对路径就不需要查找了。

将 `request` 与 `paths` 组成个对象，生成一个 key，用于缓存查找路径。

检查 `Module._pathCache` 是否有 `request` 的缓存，有就返回

循环 `paths`
如果路径对应存在文件夹，就解析该文件夹与 `request`，看这个路径是什么：
如果是个文件，就获取它的绝对路径
如果是文件夹，执行 `tryPackage(basePath, exts, isMain);` 获取文件名

如果文件还是不存在，执行 `tryExtensions(basePath, exts, isMain)`

### _extensions[ 'js' ]
使用 `fs` 的 `readFileSync()` 加载文件
调用实例的 `_compile()`

### _extensions[ 'json' ]
读取文件，将 `JSON.parse()` 后的内容作为 `module.exports` 的值

### _extensions[ 'node' ]
调用 `process.dlopen()`

## 实例方法

### load( filename )
检测文件的扩展名，根据不同的扩展名调用对应的方法

### _compile( content, filename )
先清除掉内容的 shebang 信息
调用 `var wrapper = Module.wrap( content )`
调用 `var compiledWrapper = vm.runInThisContext( wrapper )`

如果符合 `process._debugWaitConnect && process._eval == null`，还会在入口处设置断点。

使用 `var require = internalModule.makeRequireFunction(this);` 来设置 `require` 函数，主要是和当前的 `Module` 对象实例绑定。共享 `cache` 缓存
调用 `compiledWrapper` 函数，将当前的 `exports` 作为 `this`。
返回调用结果。

### require( path )
用户层面的 `require` 函数，最终会调用该方法。
使用 `Module._load( path, this, false )`，第三个参数是 `isMain`，因为已经不是第一次启动了，所以不是主函数。


## 循环引用

bar.js:
```javascript
var foo = require('./foo')
```

foo.js:
```javascriot
var bar = require('./bar')
```

当 bar.js 被加载后，在执行内容前，它已经被加入到模块缓存中。当处理内容，发现需要引入 `foo.js`，会去执行 `foo.js` 对应的内容，但此时，`bar.js` 的 `exports` 还只是个空对象。

当 `foo.js` 里引入 `bar.js`，会先解析出 id，然后在缓存中找到对应的对象。这样就不会存在循环引用问题。当 `foo.js` 加载完，`bar.js` 就可以真正初始化完成，生成它的 `exports`。

## 缓存

模块的 `exports` 有 cache，路径查找也有 `_pathCache`
