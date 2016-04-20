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
