# Stream

[Node Stream API](https://nodejs.org/api/stream.html)
[stream handbook](https://github.com/substack/stream-handbook)

readable, writable, transform, duplex, and "classic"

## Readable

两种模式:

- flowing mode
- paused mode, 需要手动调用 `stream.read()`. 默认处于该模式.

### _read(size)

下划线表示该函数不应该手动调用.

如果手动实现了该函数, 那么首先要调用 `this.push( data )` 将数据传入队列中

### push( chunk )

将 `chunk` 内容加入队列中, 为接下来的流操作做准备, 如果 `chunk` 为 `null`, 表示输入结束, 没有更多的内容了.

### pipe()

```javascript
    src.pipe( dest )
```
