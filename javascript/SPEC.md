## 5 约定标记

(非)终结符后的 `opt` 表示该符号可选.

## 6 数据类型

语言类型:

- Undefined
- Null
- Boolean
- String
- Symbol
    * 作为 Object 的 key
    * 拥有一个值 [[Description]]，为 `undefined` 或字符串。
    * well-known Symbols，规范中内置的 Symbol，@@name 格式，在整个 Code Realms 中生效。6.1.5.1 中列举.

- Number
    * 共有 18437736874454810627 个值
    * IEEE 中有 9007199254740990 个非数字值, 在 ES 中统一用 `NaN` 表示(所以 `NaN` 和 `NaN` 不等).
    * IEEE 754-2008
    * positive Infinity 与 negative Infinity
    * +0 与 -0
    
- Object
    * 属性集合
    * 属性为数据属性或访问器属性
    * internal slot 表示对象的私有状态, 不可继承

规范类型：

- List

    解释 `new` 表达式、函数调用等情况下的参数列表
  
    用《》表示

- Record
       
    数据的聚合，和对象类似
       
    用这种方式表示 { \[[value]]: ’test' }

- Completion Record
       
    解释运行时控制流的行为，如 `break`、`continue`、`return` 和 `throw`

    它有三个属性：
       
    - \[[type]]: normal, break, continue, return, throw
    - \[[value]]: 生成的值
    - \[[target]]: 用于直接控制转移的目标标记
    
    `abrupt completion` 表明 \[[type]] 不为 `normal` 的 completion
    
    ReturnIfAbrupt( argument ) 操作表示如果 `argument` 是 `abrupt completion`, 那么返回 `argument`, 否则设置 `argument` 为 `argument.[[Value]]`

- `Reference`

    解释 `delete`、`typeof`、赋值操作符、`super` 等语言特性。
    
    `Reference` 是一个解决过的名字或属性绑定。
    
    包括：base、referenced name 和 strict reference 标记
    
- Property Descriptor

    解释对象属性的操作与实例化
    
    Property Descriptor 的值是 Record
    
    它还可以细分为 data Property Descriptor 和 accessor Property Descriptor
    
- Lexical Environment 和 Environment Record
    
    略
    
- Data Blocks

    表示可变的数字序列
    

## 7 抽象操作

略

## 8 执行代码与执行环境

ES 中共有三类可执行代码：

- 全局代码（ECMAScript Program），不包括被解析为 FunctionBody 的代码
- Eval 代码
- 函数代码，不包括内嵌函数的 FunctionBody

### 8.1 Lexical Environment
 
定义 Identifier 与变量和函数之间的关联关系

由两部分组成
  
- EnvironmentRecord 记录 environment 内 identifier 的绑定
- outer Lexical Environment

与特定的语言语法结构关联：FunctionDeclaration，BlockStatement，TryStatement 中的 Catch，这些代码执行时就会创建一个新的词法环境

global environment：outer environment 为 `null`, global object 就是全局环境的 `this`

module environment: 包含模块的顶层声明(top level declaration)绑定, 也包括显式 `import` 进来的模块绑定, 模块的 outer environment 为 global environment.

function environment: ES 函数对象的调用

#### 8.1.1 Environment Record

Environment Record

* declarative Environment Record
    - Function Environment Record
    - Module Environment Record
* object Environment Record
* global Environment Record

- declarative Environment Record

定义 FunctionDeclaration，VariableDeclaration，catch 的效果

包括：variable，constant，let，class，module，import，function declaration
       
- object environment record

    定义 WithStatement
    
    包含了一个称为 binding object 的对象. 在 object environment record 中不存在不可变绑定(immutable binding)

    global environment record 是 object environment record 的特例。

- Function Environment Record

    Function Environment Record 包含额外的状态：
    
    * \[[thisValue]]
    * \[[thisBindingStatus]] ‘lexical’ 表示 arrow 函数
    * \[[FunctionObject]]
    * \[[HomeObject]]
    * \[[NewTarget]]

    arrow 函数没有 [[thisValue]] 值

- Global Environment Record
    
    表示被所有 Script 元素共享的最外层范围.

    实际上由两个 record 组成
    
    * Object Environment Record 将 Realm 内的全局对象作为它的 base 对象，它所包含的绑定：
        - 内置全局对象
        - FunctionDeclaration
        - GeneratorDeclaration
        - VariableStatement
    * 其余绑定都包含在 declarative Environment Record 中

    拥有的额外字段：
    
    * \[[ObjectRecord]]
    * \[[DeclarativeRecord]]
    * \[[VarNames]]  FunctionDeclaration，GeneratorDeclaration，VariableDeclaration 的字符串名

### 8.2 Code Realms

- \[[intrinsics]]

    与该 Realm 关联的代码所使用的 intrinsic 值，包括各种构造函数，如 Object、Array 等
    
- \[[globalThis]]

    该 Realm 中的全局对象
    
- \[[globalEnv]]

    该 Realm 中的全局环境
    
- \[[templateMap]]


### 8.3 Execution Contexts

同一时间最多只有一个 execution context 在执行代码，它被称为 running execution context
每个 EC 都会包含的状态组件：

- code evaluate state
- Function 如果 EC 是在执行函数的代码，那么该 Function 就指向那个函数，如果是 Script 或 Module，该值为 null
- Realm
- LexicalEnvironment 标识符引用的解析
- VariableEnvironment EnvironmentRecord 记录了通过 VariableStatement 创建的绑定

EC 可以暂停，一个新的 EC 被推入 stack 中，它执行完毕后，旧的 EC 可以恢复运行。
LexicalEnvironment 和 VariableEnvironment 都是 Lexical Environment，EC 创建时，这两个值相同。

### 8.4 Jobs and Job Queues
     
目前存在两种：
  
- ScriptJobs，运行 Script 或 Module 代码
- PromiseJobs

### 8.5 ES 初始化

在执行任何 Job 或代码前，需进行如下操作：

1. 调用 CreateRealm() 生成 realm
2. 创建新的 Execution Context，赋值为 newContext
3. 设置 newContext 的 Function 为 null
4. 设置 newContext 的 Realm 为 realm
5. 将 newContext 放进 execution context stack 中
6. status = InitializeHostDefinedRealm( realm )
7. 如果 status 是 abrupt completion
    * realm 无法创建
    * ES 执行失败
8. 获取 ES 源代码 sourceText
    - a. 如果 sourceText 是 script
        * 执行 EnqueueJob( ’ScriptJobs’, ScriptEvaluationJob, \<\<sourceText>> )
    - b. 如果 sourceText 是 module
        * 执行 EnqueueJob( ‘ScriptJobs’, TopLevelModuleEvaluationJob, \<\<sourceText>> )
9. NextJob NormalCompletion( undefined )



