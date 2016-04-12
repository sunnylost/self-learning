[Backbone.js Tips And Patterns](http://coding.smashingmagazine.com/2013/08/09/backbone-js-tips-patterns/)

[Developing Backbone.js Applications](https://addyosmani.com/backbone-fundamentals/)

Backbone 提供了 `noConflict`, 说明它真的只是个 library.

## Event
on, off, once, trigger (bind, unbind)
标准的 PubSub 模式。

Backbone 也有上述接口

eventsApi 用于处理事件名为对象或空格分隔的多事件的情况。

triggerEvents 经过优化，看起来是很奇怪

listenTo、 listenToOnce
    object.listenTo(other, event, callback)
    使 object 监听 other 上的事件，实际上还是 other 监听了事件，但 object 拥有 other 的引用。

## Model

模型的基础功能包括: 属性的访问控制(读取与设置), 验证, 属性变化的事件通知, 持久化等等.

Backbone 使用 `get()` 和 `set()` 来实现访问控制.

- constructor( attributes, options )

    为模型设置唯一的 `cid`

    设置 `attributes`

    执行 `initizlize`

- changed

    包含值有变化的属性

- toJSON

    返回 `attributes` 的拷贝

- get( attr )

    从 `attributes` 中获取 attr

- set( key, val, options )

    调用 `_validate` 验证, 没通过验证返回 `false`. 在 `fetch` 中, 如果 `set` 失败, 不会触发 `sync` 事件.

    设置前先检测 `_changing`

    如果属性值有变动，触发 `change:attrname` 事件

    如果 `_changing` 为 `true`, 表明当前正在 `change` 事件中, 直接返回, 确保当前的 `change` 事件结束.

    如果在 `change` 事件中又修改了 `attribute`, 那么接下来的 `while` 循环会保证 `change` 事件再次触发.

    如果修改成 `if` 判断, 那么在 `change` 事件触发后, 虽然 `_pending` 被设置成了 `object`, 但没有对它进行再次检测, 所以 `change` 事件不会再触发, 这就解释了注释中的内容.

    `_changing` 这个内部属性还会在其他地方使用, 例如 `changedAttributes` 中.

- destroy

    向服务器端发送 `delete` 请求删除当前 `model`

    触发 `destroy` 事件

    如果 `model` 已经存储过，触发 `sync` 事件

    提供了 `options.wait` 来设置内部 `destroy` 函数执行时机, 是否需要等待服务器端的值返回.

- _validate( attrs, options )

    调用用户自定义的 `validate` 方法

    会触发 `invalid` 事件
