## Scripting

所有脚本都拥有一个 `settings object`，包含环境信息，用于在相同的上下文中与其他 `script` 共享。

脚本分为两种：
- classic script
  - Source text，脚本源码
  - muted errors，可选参数，控制脚本信息的错误是否出现，主要是为了防止跨域脚本通过错误信息来泄露私有信息。
- module script
  - module record，解析后的模块，准备执行
  - base URL，用于解析模块的区分符(specifier)
  - instantiation state，`uninstantiated`、`errored` 或 `instantiated` 三者之一
  - instantiation error
  - credentials mode
  - cryptographic nonce
  - parser state
  

### 与 JavaScript 的 job queue 结合

html 规范目前没有遵守 ECMAScript 中的 `RunJobs` 操作，而是重新定义了 `EnqueueJob`

`EnqueueJob( queueName, job, arguments )`：
- `queueName` 必须为 `PromiseJobs`
- `Promise` 任务会被塞进 `microtask` 里。

在执行完毕脚本后，会执行 `clean up after running script`，在这里，会判断 `execution context stack` 是否为空，如果是的话，执行 `microtask checkpoint`

### Event loops

为了协调事件、用户操作、脚本、渲染、网络请求等等，user agent 必须要使用 event loop。

有两种 event loop: 用于 browsing context 的，用于 worker 的。

每个 event loop 会有多个 task queue。task 的来源称为 task source，来自于相同 task source 的 task 必须要添加到相同的 task queue 里，不同的 task source 则不一定。

每个 event loop 拥有一个 `currently running task`，初始值为 `null`，还有一个 `performing a microtask checkpoint`，初始值为 `false`。

在执行 microtask 时，脚本可能还向 microtask queue 里增加了新的 task，为了避免重复进入，因此需要设置 `performing a microtask checkpoint`。

#### 执行模型

只要 event loop 存在，就会按顺序执行以下步骤：
1. 从 event loop 的一个 task queue 中挑出最老(the oldest)的 task，如果不存在，则跳到 `microtask` 步骤执行。(对于挑选哪个 task queue 还没有定义)
2. 将 event loop 的 `currently running task` 设置为上一步选中的 task
3. 运行选中的 task
4. 将 event loop 的 `currently running task` 设置为 `null`
5. 将该 task 从它的 task queue 里移除
6. Microtasks，设置一个 microtask checkpoint
7. 更新渲染：worker 里的 event loop 不需要这个步骤，只针对 browsing context
  - 设置 now 为 `Performance` 的 `now()` 方法执行结果
  - 设置 docs 为 event loop 关联的 Document 对象(可能存在多个 Document 对象，所以以下步骤会在多个 Document 对象上执行)
  - 如果 user agent 认为此次渲染更新，对某些 browsing context 无益，则会移除这些 browsing context 的 Document 对象。所谓的无益(not benefit)，例如为了达到某个更新频率，而忽略更新。
  -. 执行 Document 上的 resize
  -. 执行 Document 上的 scroll
  -. 执行 Document 上的 media query
  -. 执行 Document 上的 CSS animation，并发送事件
  -. 执行 Document 上的 fullscreen rendering
  -. 执行 Document 上的 animation frame callback(就是 equestAnimationFrame() 的回调)
  -. 执行 Document 上的 update intersection observation
  -. 更新 Document 的渲染或者用户界面
8. 如果这是个 worker 的 event loop，并且 task queue 为空，`WorkerGlobalScope` 的 `closing` 为 true，则销毁 event loop
9. 返回第一步

每个 event loop 都有一个 microtask queue。

如果 `performing a microtask checkpoint` 为 `false`，则 `perform a microtask checkpoint`：
1. 设置 `performing a microtask checkpoint` 为 `true`
2. `microtask queue handling`: 如果 microtask queue 为空，则跳至 `Done`
3. 选择 microtask queue 里的最老的 microtask
4. 设置 event loop 的 `currently running task` 为上一步选中的 task
5. 执行选中的 task
6. 设置 event loop 的 `currently running task` 为 null
7. 将 task 从 microtask queue 移除，回到 `microtask queue handling` 步骤
8. `Done`: 通知被 rejected 的 promise
9. 清除 `indexed Database transaction`
10. 设置 `performing a microtask checkpoint` 为 `false`
