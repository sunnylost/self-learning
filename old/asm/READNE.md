PC Assembly Language

[PC Assembly](http://www.drpaulcarter.com/pcasm/)

## 1 介绍
### 1.2 计算机结构
#### 1.2.1 内存

内存的基本单位是 byte，每个 byte 都使用一个唯一数字做为地址。

内存单元：

* word(字)          = 2 bytes
* double word(双字) = 4 bytes
* quad word(四字)   = 8 bytes
* paragraph(一节)   = 16 bytes

#### 1.2.2 CPU

CPU 执行指令(instruction)，这些指令通常都很简单。指令可能需要操作的数据存储在寄存器(register)中。CPU 访问寄存器比内存要快。

CPU 使用的指令组成了它的机器语言。

计算机使用时钟(clock)来同步指令的执行。

#### 1.2.4 8086 16 位寄存器

最初的 8086 CPU 提供了 4 个 16 位通用寄存器：`AX`，`BX`，`CX`，和 `DX`。它们都可以分解为两个 8 位寄存器。

`AX` 可以分解为 `AH` 与 `AL`。H 表示 high。

寄存器 `SI` 与 `DI` 通常当作指针使用，也可以作为通用寄存器使用，但不能分解为 8 位寄存器。

`BP` 与 `SP` 寄存器用于指向机器语言栈中的数据，分别称为 “Base Pointer” 与 “Stack Pointer”。

`CS`，`DS`，`SS` 和 `ES` 称为 “segment register(段寄存器)”，分别表示“Code Segment”，“Data Segment”，“Stack Segment” 和 “Extra Segment”。

`IP`(Instruction Pointer，指令指针) 寄存器与 `CS` 寄存器配合使用，来跟踪 CPU 接下来要执行指令的地址。

`FLAGS` 寄存器存储了前一条指令执行结果的重要信息。

#### 1.2.5 80386 32 位寄存器

80386 和之后的处理器扩展了寄存器，例如 16 位的 `AX` 寄存器被扩展为 32 位，为了向后兼容，`AX` 仍然表示 16 位寄存器，`EAX` 表示扩展的 32 位寄存器。 `AX` 表示 `EAX` 的低 16 位，无法访问高 16 位。

#### 1.2.6 Real Mode(实模式)

在 real mode 下，内存只有 1M，合法的地址是从 00000 到 FFFFF。需要 20 位数字，但 8086 的寄存器只有 16 位。Intel 使用两个 16 位值来决定一个地址。第一个 16 位值称为 `selector(段地址)`，必须存在段寄存器中。第二个 16 位值称为 `offset(偏移地址)`。selector:offset 表示的物理地址的计算公式为：

```
16 * selector + offset
```

缺点：`offset` 只有 16 位，所以它最多只能指向 64KB 大小的内存。如果代码超过 64 KB，一个 CS 是无法用于执行整个程序。因此代码必须要分段，当从一个 segment 转向另一 segment 时，CS 寄存器的值就要改变。

#### 1.2.7 16 位 Protected Mode(保护模式)

在 real mode 中，selector 的值是物理内存里的一节的首地址。在 protected mode 下，是指向 `descriptor table(描述符表)` 的一个 `index`。


#### 1.2.9 Interrupt(中断)

普通的程序流被中断，执行需要快速响应的事件，例如鼠标移动，鼠标硬件会中断当前的程序，来移动鼠标指针。

中断导致控制权移动到*interrupt handler(中断处理程序)*中，每种中断都被分配一个中断号，它是指向*interrup vector(中断向量)*表的指针。

CPU 内部会产生两种中断：由错误导致的中断称为*trap(陷阱)*，由中断指令产生的中断称为*software interrupts(软中断)*。


### 1.3 汇编语言

#### Instruction operands(指令操作数)

每条指令最多有三个操作数，它们的类型为：

* register：指向 CPU 寄存器中的内容
* memory：指向内存中的数据
* immediate：立即数，就是指令本身表示的值，它保存在 code segment 中，而不在 data segment
* implied：没有明确显示的操作数，例如向寄存器或内存加一的加法指令中，“一”就是 implied。

#### 基本指令

`MOV` 移动数据。将 `src` 复制到 `dest`。**这两个操作数不能同时为内存操作数**

```nasm
mov dest, src
```

`ADD` 用于整数的相加

```nasm
add eax, 4
add al, ah
```

`SUB` 用于整数的相减

```nasm
sub bx, 10
sub ebx, edi
```

`INC` 和 `DEC` 表示加一或减一

```nasm
inc ecx
dec dl
```

#### Directives(指示符)

由汇编语言生成，不会被翻译成机器码，经常被用于：

* 定义常量
* 定义用来存储数据的内存
* 将内存组合成段
* 有条件地包含源代码
* 包含其他文件

NASM 的代码会经过预处理器处理，预处理指示符以 % 开头。

`equ` 指示符用于定义一个 `symbol(符号)`，它是可以在汇编程序中使用的常量，一旦赋值后，符号的值不能被修改。

```nasm
symbol equ value
```

`%define` 定义一个常量宏

```nasm
%define SIZE 100
mov eax, SIZE
```

##### 数据指示符

用于在数据段中定义内存空间。有两种方式，只为数据定义空间，或者在定义的同时赋予一个初始值。第一种方式使用 RES*X* 指令，第二种方式使用 D*X* 指令，*X* 都可以替换成表示大小的字母。

单位  	   |字母
-----------|----
byte       | B
word	   | W
double word| D
quad word  | Q
ten bytes  | T

```nasm
L1 db 0
L2 dw 1000
```

其中，`L1` 和 `L2` 可以看作是标签名，可以在代码中使用。如果直接使用标签名，那么它会被解析成成对应的地址，如果放在方括号里，会被解析成对应地址所存储的数据。

```nasm
mov al, [L1]  ;复制 L1 的字节到 al
mov eax, L1   ; EAX = L1 表示的地址
```