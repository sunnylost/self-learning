[MDN](https://developer.mozilla.org/en-US/docs/Web/API/Navigator)

- `navigator.connection`

    [Network Information](https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API)
    
    [Spec](https://w3c.github.io/netinfo/)
    
    检测网络连接环境
    
    ```javascript
    // 连接类型, 可能为: bluethooth, wifi, cellular, ethernet...
    var type = navigator.connection.type
    
    // 最高下载速度, 单位是 Mbps.
    var max = navigator.connection.downlinkMax
    
    // type 或 downlinkMax 改变触发事件
    navigator.connection.onchange = function() {
        console.log( navigator.connection.type )
    }
    ```


