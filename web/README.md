## 演化

- 应用服务和数据服务分离
- 使用缓存
    - 本地缓存
    - 分布式缓存
- 应用服务器集群
- 数据库读写分离
    - 主数据库用于写操作
    - 从数据库用于读操作, 从主数据库同步数据
- 反向代理, CDN
    - 缓存
- 分布式文件系统和分布式数据库系统
    - 数据库拆分
- 使用 NoSQL 和搜索引擎
- 业务拆分
- 分布式服务

## 分层

- 应用层
- 服务层
- 数据层

### 分层的目的: 方便分布式部署

### 分布式的坏处:

- 网络调用, 对性能有影响
- 服务器越多, 越增加不稳定概率, 影响可用性
- 要保证数据一致
- 开发管理复杂

### 分布式方案:

- 分布式应用和服务
- 分布式静态资源
- 分布式数据和存储
- 分布式计算

### 集群: 多台服务器部署相同应用, 通过负载均衡对外提供服务.

- 可扩展性, 增加机器即可
- 稳定性, 一台服务器挂了还有其他服务器

### 缓存

- CDN, 离终端用户近, 部署静态资源或热点内容
- 反向代理
- 本地缓存, 应用服务器在内存中缓存
- 分布式缓存

### 异步

- 内存队列
- 分布式消息队列

### 冗余

### 自动化

- 发布
    - 代码管理
    - 测试
    - 安全检测
    - 部署
- 监控
    - 报警
    - 失效转移(将失效的服务器移出集群)
    - 失效恢复(重启服务, 同步数据等)
    - 降级(拒绝请求, 降低负载)
    - 分配资源

### 安全

- 验证
- 加密
- 风控

## 架构

- 性能
- 可用性
- 伸缩性
- 扩展性
- 安全性

## 高可用

### Session 管理

- Session 复制
    - 所有机器都拥有全部 Session 信息, 占用内存高, 复制操作占用太多网络请求
- Session 绑定
    - 根据来源始终访问相同的机器, 如果机器挂了, Session 也没了
- Cookie
    - 将信息记录在客户端, 每次请求都会携带, 简单, 但影响性能
- Session 服务器

### 高可用服务

- 分级管理, 不同应用与服务存在优先级
- 超时设置
- 异步调用
- 服务降级
    - 拒绝服务
    - 关闭服务
- 幂等性设计, 重复调用与一次调用的结果相同

### 高可用数据

- 持久性, 不会丢失数据
- 可访问性
- 一致性

### CAP: 一个提供数据服务的存储系统无法同时满足数据一致性(Consistency), 数据可用性(Availability), 分区耐受性(Patition Tolerance) 这三个条件.

### 数据备份

- 冷备, 定期将数据复制到存储介质中
- 热备
    - 异步, 写入主存储服务器, 异步更新到从服务器
    - 同步, 不分主从

### 失效转移

- 失效确认
    - 心跳检测
    - 应用程序访问失败报告
- 访问转移
- 数据恢复

## 伸缩性

- 不同功能进行物理分离
- 单一功能通过集群

### 负载均衡

- `HTTP` 重定向: 请求重定向服务器, 利用 302 状态码返回真实的 `Web` 服务器地址
    - 优点:简单
    - 缺点:两次请求, 重定向服务器自身可能成为性能瓶颈
- `DNS` 域名解析: 解析域名时返回服务器地址
    - 优点:不需要负载均衡服务器
    - 缺点:缺乏直接控制
- 反向代理
    - 优点:部署简单
    - 缺点:代理服务器可能成为性能瓶颈
- `IP` 负载均衡: 修改用户请求的 `IP` 地址
- 数据链路层负载均衡: 不修改 `IP`, 修改的是目的 `mac` 地址

### 分布式缓存

分布式缓存服务器集群中的每个服务器缓存的数据不同, 缓存访问首先需要找到缓存数据所在的服务器.

#### Memcached

路由算法根据提供的 `Key` 来决定数据缓存到集群的哪台服务器上, 读取也是同样的道理

分布式缓存的一致性 Hash 算法

### 数据存储服务器集群

- 关系数据库集群的伸缩性设计
    - 主从读写分离
    - 数据复制
    - 数据分库(不同业务数据表部署在不同的数据库集群上)
    - 数据分片(一张表存储在不同数据库中)
- NoSQL 数据库的伸缩性设计
    - `HBase`

## 可扩展

### 事件驱动架构

## 安全

### XSS 攻击
- 反射型, 诱使用户点击连接
- 持久型, 恶意脚本上传到 Web 站点, 用户访问时即受到攻击

对用户的输入进行过滤, 将特殊字符转义

### 注入攻击
- SQL 注入, 在 `http` 请求中构造 `SQL` 命令

### CSRF 攻击
- CSRF, 夸站点请求伪造,

### 加密
- 单向散列加密, 将用户输入的密码加密, 将密文存入数据库
    - 可通过彩虹表进行猜测式破解
- 对称加密, 加密解密使用相同的密钥
    - 密钥丢失
- 非对称加密, 使用不同的密钥加密解密, 对外公布的密钥叫公钥, 另外的叫私钥

### 密钥安全管理
- 将密钥和算法独立部署在服务器上, 对外提供服务, 但需要远程调用, 开销较大
- 加解密算法放在应用系统中, 密钥放在服务器上

### 信息过滤与反垃圾
- 文本匹配
    - 正则
    - `Trie` 树
    - 多级 `Hash` 表
- 分类算法, 贝叶斯分类算法
- 黑名单
    - `Hash` 表
    - 布隆过滤器(不完全精确)

### 电子商务风险控制
- 风控
    - 规则引擎
    - 统计模型
