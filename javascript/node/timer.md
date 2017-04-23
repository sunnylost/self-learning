内部使用 linkedlist 数据结构，在 `lib/internal/linkedlist.js` 中。

`TimerWrap` 为 `process.binding('timer_wrap').Timer`

只要存在未执行的定时器，那么 `node` 的事件循环就不会停。该行为可以通过 `ref()` 和 `unref()` 来控制。`ref` 表示遵循默认行为，`unref` 表示在定时器存在的情况下，事件循环也可以退出。

`refedLists` 和 `unrefedLists` 为两个空对象，用于存储定时器。

`const kOnTimeout = TimerWrap.kOnTimeout | 0;` 还不知道是做什么用的

## setTimeout( callback, after, arg1, arg2, arg3 )
这里一个技巧是判断 `arguments` 的长度，将常用参数个数情况列出来，当参数过多时，动态修改数组来增加新的参数，这样在 v6.0.0 里的性能会好

解析完参数，调用 `createSingleTimeout( callback, after, args )`

## createSingleTimeout( callback, after, args )
将 `after` 转为数字，如果它小于 1，或者大于 `TIMEOUT_MAX`，将它设置成 1

实例化 `Timeout` 对象

判断 `process.domain`，关于 `domain` 还需要稍候再看

`active( timer )`

返回 `timer` 实例

## Timeout( after, callback, args )
实际上是个链表，拥有如下属性：
- _called = false 是否被调用
- _idleTimeout = after 
- _idlePrev = this
- _idleNext = this
- _idleStart = null
- _onTimeout = callback
- _timerArgs = args
- _repeat = null

## TimersList( msecs, unrefed )
创建一个空的链表

它的 `_timer` 是 `TimerWrap` 实例

## active( item )

`insert( item, false )`

## insert( item, unrefed )
设置 `item._idleStart` 为 `TimerWrap.now()`

通过 `unrefed` 来确定该定时器存储在哪个列表里

该列表使用定时器的时间间隔参数作为 `key`，如果该 `key` 
对应的值不存在，调用 `createTimersList( msecs, unrefed )` 来创建新的链表

将 `item` 加入到链表中

## createTimersList( msecs, unrefed )
根据 `msecs` 创建一个空的链表

调用链表的 `_timer.start( msecs )`，这个 `start` 是 C++
里的方法，具体是 `uv_timer_start()`

`list._timer[kOnTimeout] = listOnTimeout`

## listOnTimeout()
目前看来是 C++ 调用的，当定时结束时执行。

`var list = this._list`

接下来判断了 `list.nextTick`，应该是针对 `immediate`，还有就是回调函数执行异常的定时器之后的定时器。

使用 `TimerWrap.now()` 创建当前时间，暂时不知道该时间是根据什么来得到的，表示什么意思，总之就是一串数字。

循环 `list`：
- 将当前时间与定时器的 `_idleStart` 做差值，如果这个差值比定时器设置的时间短，那么再计算还有多久才能触发，然后调用 `this.start( timeRemaining )`
- 如果已经可以触发，将定时器从链表中删除
- 如果该定时器没有绑定回调函数，那么返回
- 继续处理定时器的 `domain` 相关内容
- 调用 `tryOnTimeout( timer, list )`

## tryOnTimeout( timer, list )
设置 `timer` 的 `_called` 为 `true`

调用 `ontimeout( timer )`，这里需要在 `try catch` 中执行。

如果回调函数正常执行，那么返回

如果有异常，那么会将剩余的定时器循环一遍，设置它们的 `nextTick` 为 `true`，并在 `process.nextTick()` 中执行。

这里有个疑问：在 `process.nextTick()` 中执行的是 `listOnTimeoutNT()`，这个函数会调用 `listOnTimeout()`，而在 `listOnTimeout()` 中，又会在下一个 tick 去执行这些定时器。这样就相当于两个 tick 后才会执行。

## ontimeout( timer )
执行回调函数，传入参数

如果定时器的 `_repeat` 设置了，调用 `rearm(timer)`

## setInterval()
最后调用 `createRepeatTimeout()`

## createRepeatTimeout()
大同小异吧
