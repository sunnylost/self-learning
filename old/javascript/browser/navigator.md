[MDN](https://developer.mozilla.org/en-US/docs/Web/API/Navigator)

- [`navigator.connection`](https://www.chromestatus.com/feature/5857463882481664)

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

- [online and offline](https://developer.mozilla.org/en-US/docs/Online_and_offline_events)

    `navigator.onLine` 为 `true` 或 `false` 表示是否在线。
  
    `online` 与 `offline` 事件，可以在 `window`、`document`、`document.body` 上绑定。
