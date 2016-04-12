[Backbone.js Tips And Patterns](http://coding.smashingmagazine.com/2013/08/09/backbone-js-tips-patterns/)

[Developing Backbone.js Applications](https://addyosmani.com/backbone-fundamentals/)

Backbone 提供了 `noConflict`, 说明它真的只是个 library.

## Event

on, off, once, trigger (bind, unbind) 标准的 PubSub 模式

- eventsApi

    用于处理事件名为对象或空格分隔的多事件的情况

- triggerEvents

    经过优化，看起来是很奇怪

- listenTo、 listenToOnce

    `object.listenTo( other, event, callback )`

    使 `object` 监听 `other` 上的事件，实际上还是 `other` 监听了事件，但 `object` 拥有 `other` 的引用

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

## View

el 表示视图的容器

功能很少, 和 model 没有绑定, 需要手动监听 `change` 来改变视图

主要为局部绑定事件提供了便利

- 构造函数

    设置 cid

    `_ensureElement()`

    `initialize()`

- $( selector )

    `$el.find( selector )`

- setElement( element )

    `undelegateEvents()`

    设置元素 `element`

    `delegateEvents()`

- render()

    用于覆盖

- remove()

    `$el.remove()`

    `stopListening()`

- _ensureElement()

    如果 `el` 不存在, 根据 `tagName` 属性创建一个新的元素作为容器

    存在调用 `setElement()`

- delegateEvents()

    利用名空间来注册事件

- undelegateEvents()

    清除所有代理事件

    `$el.off( '.delegateEvents' + this.cid )`


## Collection

model 的集合

实现了 `underscore` 90% 的功能

集合中 `model` 触发的事件，会同样导致 `collection` 触发

- 构造函数

    设置 `model`、 `comparator`( 用于排序 )

    `this._reset()`

    if ( models ) this.reset( models, _.extend( {silent: true}, options ) )

- _reset()

    `this.length = 0` 这个 `length` 应该是为了方便获取模型个数而设置在 `this` 上的.

    `this.models = []` 这里保存着真正的模型

    `this._byId  = {}` 使用 `id` 与模型进行关联, 用于快速获取模型对象.

- add( models, options )

    调用 `this.set()`， 但 `option` 包括 `{ add: true, remove: false, merge: false }`

    忽略已经存在的 `model`

- set( models, options )

    略


## Router

- 构造函数

    设置 this.routes

    _bindRoutes()

- _bindRoutes()

    循环调用 route()

- _routeToRegExp()

    将 route 字符串转成 RegExp 对象

- route(route, name, callback)

    Backbone.history.route(route, fn) 方法

    fn
        处理 url 参数
        调用 callback
        触发 route:name 对应的事件
        触发 route 事件
        触发 history 的 route 事件


## Sync

发送 CRUD 请求

Backbone.sync 函数, 依赖于 `jQuery` 或 `Zepto` 的 `ajax` 方法, 大部分是做配置操作.

对于老的服务器, 设置 `X-HTTP-Method-Override` 表明使用 `POST` 来模拟服务器不支持的方法, 真正的方法通过 `_method` 传递.

触发 `request` 事件


## History

处理全局 `hashchange` 或 `pushState` 事件

对于低版本 ie 想使用 `hashchange`， 使用 `iframe`

`interval` 默认间隔时间，检测 `url`

- getHash()

    Firefox 会将 `hash` 内容编码, 所以不能使用 `location.hash`

- start()

    History.started 为 true 会抛异常，确保该方法只执行一次

    如果支持 pushState，监听该事件
    如果向用 hashchange 并且浏览器支持，监听 hashchange
    否则定时调用 checkUrl()，默认间隔时间 50 毫秒。

- route()

    向 this.handlers 插入 { route: route, callback: callback }
