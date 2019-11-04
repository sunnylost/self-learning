## 基本类型

* 整型
    * bool
    * char
    * int
    * ...     
* 浮点型
    * float
    * double 
    
    
除 bool 和 char 外，其他类型分为 `signed` 和 `unsigned`。

char 分为 `char`，`signed char` 和 `unsigned char`。其中 `char` 会表现为其他两种之一，具体由编译器来决定。

### literal

十进制：10

八进制：010

十六进制：0x10

默认情况下，十进制是带符号的，会转为 `int`、`long`、`long long` 中能容纳下它的尺寸最小的类型。

浮点数：0.001 或 1E5

char literal： 'a'

string literal: "abc"


## 变量

### 列表初始化

* int foo = 0
* int foo = {0}
* int foo{0}
* int foo(0)

对于内置类型来说，定义于*函数体外*的变量被初始化为 0，在*函数体内部*的变量**不被初始化**。

### 声明与定义

**声明(declaration)**使名字为程序所知，**定义(definition)**负责创建与名字关联的实体。

声明不会申请存储空间，定义则会。

    extern int i; //声明 i
    int i;        //声明并定义 i
    extern double pi = 3.1416; //定义
    
**变量能且只能被定义一次，但是可以被多次声明。**

『引用』(Reference) 就是别名，一旦声明，它就与一个变量进行了绑定，无法解绑。

```
int val = 10;
int val2 = 20;
int& rval = val;
rval = val2;  //无效
```
关于『引用』的两点注意：

- 引用的类型必须与绑定的类型一致
- 只能绑定对象，不能绑定 literal

```
int &ref = 10; //error
double dval = 3.14;
int &ref = dval; //error
```


---

[size_type](http://stackoverflow.com/questions/4849678/c-for-loop-size-type-vs-size-t)，它是无符号的，可以作为最大的索引值，所以选择使用它而不是 `int`。

`typedef type name;` 使用 `name` 来替代 `type`。

`Vector` 是一种容器，类似于 JS 的数组。包含方法 `begin()`、`end()`、`size()`、`push_back()`。

