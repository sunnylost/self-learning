[awesome react](https://github.com/enaqx/awesome-react)
[OSCON - React Architecture](https://speakerdeck.com/vjeux/oscon-react-architecture)
[React Presentation](https://speakerdeck.com/vjeux/react-presentation)
[React: CSS in JS](https://speakerdeck.com/vjeux/react-css-in-js)
[pure render](http://zhuanlan.zhihu.com/purerender)

目前 `React` 与 `React-DOM` 已拆分, 需要分别引入.

```javascript
    import React from 'react'
    import ReactDOM from 'react-dom'

    var Component = React.createClass({
        render() {
            return <div>
                Hello!
            </div>
        }
    })

    ReactDOM.reander( <Component/>, dom-element )
```
从父元素传递过来的数据称之为 `property`, 通过 `this.props` 访问, 子元素可以通过 `this.props.children` 访问, `property` 为不可变数据.

元素上的可变数据被称为 `state`, 通过 `this.state` 访问, 调用 `this.setState()` 改变.
