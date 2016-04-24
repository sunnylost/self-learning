# [Memcached](https://memcached.org/)

homebrew 安装脚本: [homebrew.rb](https://raw.githubusercontent.com/Homebrew/install/master/install)



安装 [libevent](http://libevent.org/).

直接下载源码的话, 需要先执行 `autogen.sh`,

提示 `aclocal` 不存在, 需要安装 `automake`.

提示 `openssl/bio.h` 不存在, 需要安装 `openssl`

安装过程:

- `brew install automake libtool openssl`
- [`brew link openssl --force`](http://stackoverflow.com/questions/33165174/fatal-error-openssl-bio-h-file-not-found)
- `sh autogen.sh`
- `./configure && make && make install`

启动 `memcached`:

- `memcached`

## 在 node 中使用
[memcached](https://github.com/3rd-Eden/memcached)

```javascript
var Memcached = require( 'memcached' ),
    memcached = new Memcached( 'localhost' )

var key = 'key-' + Date.now()

memcached.set( key, 'Hello!', 2, next )

setTimeout( next, 2500 )

function next() {
    memcached.get( key, ( err, data ) => {
        console.log( 'get', data )
    } )

    memcached.touch( key, 10, err => {
        console.log( 'touch!' )
    } )
}
```
