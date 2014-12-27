PC Assembly Language

[PC Assembly](http://www.drpaulcarter.com/pcasm/)

## 1.2 计算机结构
### 1.2.1 内存

内存的基本单位是 byte，每个 byte 都使用一个唯一数字做为地址。

内存单元：

* word(字)          = 2 bytes
* double word(双字) = 4 bytes
* quad word(四字)   = 8 bytes
* paragraph(一节)   = 16 bytes

### 1.2.2 CPU

CPU 执行指令(instruction)，这些指令通常都很简单。指令可能需要操作的数据存储在寄存器(register)中。CPU 访问寄存器比内存要快。

CPU 使用的指令组成了它的机器语言。

计算机使用时钟(clock)来同步指令的执行。

### 1.2.4 8086 16 位寄存器

最初的 8086 CPU 提供了 4 个 16 位通用寄存器：`AX`，`BX`，`CX`，和 `DX`。它们都可以分解为两个 8 位寄存器。

`AX` 可以分解为 `AH` 与 `AL`。H 表示 high。

寄存器 `SI` 与 `DI` 通常当作指针使用，也可以作为通用寄存器使用，但不能分解为 8 位寄存器。

`BP` 与 `SP` 寄存器用于指向机器语言栈中的数据，分别称为 “Base Pointer” 与 “Stack Pointer”。

`CS`，`DS`，`SS` 和 `ES` 称为 “segment register(段寄存器)”，分别表示“Code Segment”，“Data Segment”，“Stack Segment” 和 “Extra Segment”。

`IP`(Instruction Pointer，指令指针) 寄存器与 `CS` 寄存器配合使用，来跟踪 CPU 接下来要执行指令的地址。

`FLAGS` 寄存器存储了前一条指令执行结果的重要信息。

### 1.2.5 80386 32 位寄存器

80386 和之后的处理器扩展了寄存器，例如 16 位的 `AX` 寄存器被扩展为 32 位，为了向后兼容，`AX` 仍然表示 16 位寄存器，`EAX` 表示扩展的 32 位寄存器。 `AX` 表示 `EAX` 的低 16 位，无法访问高 16 位。

### 1.2.6 Real Mode(实模式)

在 real mode 下，内存只有 1M，合法的地址是从 00000 到 FFFFF。需要 20 位数字，但 8086 的寄存器只有 16 位。Intel 使用两个 16 位值来决定一个地址。第一个 16 位值称为 `selector(段地址)`，必须存在段寄存器中。第二个 16 位值称为 `offset(偏移地址)`。selector:offset 表示的物理地址的计算公式为：

```
16 * selector + offset
```

缺点：`offset` 只有 16 位，所以它最多只能指向 64KB 大小的内存。如果代码超过 64 KB，一个 CS 是无法用于执行整个程序。因此代码必须要分段，当从一个 segment 转向另一 segment 时，CS 寄存器的值就要改变。

### 1.2.7 16 位 Protected Mode(保护模式)

在 real mode 中，selector 的值是物理内存里的一节的首地址。在 protected mode 下，是指向 `descriptor table(描述符表)` 的一个 `index`。