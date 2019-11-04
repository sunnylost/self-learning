# Cookie

保存在浏览器中的一小段文本, 在每次请求过程中都会携带.

用于在无状态的 HTTP 协议下实现状态的记录.

## `Set-Cookie`

- NAME=VALUE
    - 必填, 设置 `cookie` 的名称与值
- expires=DATE
    - 有效期, 如果不填, 默认为浏览器的会话时间段内
- path=PATH
    - 限定 `cookie` 发送的范围, 尽在某些服务器路径下生效, 默认是全路径
- domain=DOMAIN
    - `domain` 与请求的域名匹配后才发送 `cookie`
- secure
    - 仅在 `Https` 的连接下发送
- HttpOnly
    - 防止 JS 读取
