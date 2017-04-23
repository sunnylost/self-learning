[Link](http://jayconrod.com/posts/55/a-tour-of-v8-garbage-collection)
[解读 V8 GC Log（一）: Node.js 应用背景与 GC 基础知识](https://alinode.aliyun.com/blog/37)

### Heap 分区：
- New-space：大部分对象分配在这里。该空间很小，被设计成能够快速的垃圾回收。不依赖于其他区域。
- Old-pointer-space: 包含大量的持有其他对象指针的对象。如果对象从 new-space 存活一段时间后，会被移动到这里。
- Old-data-space:保存原始数据(没有其他对象指针)。字符串、装箱的数字、未装箱的 double 数组，这些内容在 new-space 存活一段时间后，会被移动到这里。
- Large-object-space: 对象的容量超过其他空间时会被分配到这里，它不会被垃圾回收器移动。拥有自己的 mmap 内存区域。
- Code-space: `Code` 对象( 包含 JIT 过的指令 )会被分配到这里，这是唯一可移植性的内存(executable memory)。
- Cell-space, property-cell-space 和 map-space: 这些空间包含 `Cell`、`PropertyCell` 和 `Map`。它们包含的对象都拥有相同的大小，指向的对象也有共同的限制。用于方便回收。

每个空间由一组 `Page` 组成，`Page` 是一段连续的内存，由操作系统分配( mac 是 mmap，windows 不知道…… )。每个 `Page` 都是 1M 大小，且按 1M 内存对齐(???)。

### 识别指针：
- 保守式：没有编译器支持，认为堆中对齐的字是指针，这样会错把一些数据也当做指针
- 编译器提示：静态类型语言的编译器会提供类中所有的指针
- 标记指针：保留字的最后一位来指名它是数据还是指针。V8 使用了该方式。

SMI：小整数，V8 内部数据结构

### 分代回收
大部分对象生命周期短，少部分生命周期长——>分区处理
V8 将 heap 分成两代：新对象分配在 new-space，通常有 1M~8M 大小。
在 new-space 分配内存：持有该区域的指针，按照新增对象的大小来移动指针。当指针达到区域结尾，触发 `scavenge(minor garbage collection cycle)`，快速的将 new-space 的 dead 对象清理。

在经过两次 `scavenge` 清理后存活的对象会被移动到 old-space。old-space 在 `mark-sweep 或 mark-compact(major garbage collection cycle)` 时清理，频率十分低。当足够多的对象被移动到 old-space 后才会触发垃圾清理。

### Scavenge
[Cheney](https://www.wikiwand.com/en/Cheney's_algorithm) 算法的实现。

new-space 被分成两个相等的子区：`to-space` 和 `from-space`。大部分对象在 `to-space` 分配(`Codes`始终在 old-space 分配)，当 `to-space` 分配满了后，将它与 `from-space` 交换，再将活跃的对象复制回 `to-space` 或者存到 ol-space 中。在这个过程中，`to-space` 中的对象会被 `compacte`。

### write barrier
...

### Mark-sweep and Mark-compact
分成两个过程: marking 和 sweeping/compacting



