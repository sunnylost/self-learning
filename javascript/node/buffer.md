旧有的调用方式被废弃，使用四个静态方法：
- from()
- alloc( size, fill, encoding )
- allocUnsafe( size ) 和 allocUnsafeSlow( size )

所谓的 `unsafe` 是指分配的内存没有经过初始化，可能包含原有数据。

Buffer.poolSize = 8 * 1024

内部先初始化一个 allocPool，开辟一段内存。

## Buffer.from( value, encodingOrOffset, length )

根据 `from()` 参数不同，共有三个工具方法来处理输入内容：
- fromArrayBuffer
- fromString
- fromObject

第二、三个参数都是可选，因此第二个参数就有多种情况，学习一下这个命名方式。

### fromString( string, encoding )

检查 `encoding`，默认 `utf8`。

如果传入了 `encoding`，那么会调用 `internalUtil.normalizeEncoding()` 处理，这个工具函数里的注释说明，最多执行两次来决定编码，而且是使用循环的方式来实现的。

如果是空字符串，调用 `new FastBuffer()`

获得字符串长度 `byteLength( string, encoding )`，对于 `utf8`，使用的是 C++
 中 `buffer` 的 `byteLengthUtf8()`。
 
如果字符串长度大于内存池剩余的空间，需要为内存池开辟新的内存。

生成 `FastBuffer` 的实例 b

调用 `alignPool()`，不知道什么意思

返回 b

