## Document
1. 资源元数据管理
- readyState: 只读，loading、interactive、complete。`interactive` 表示文档已经解析完毕，但是还有资源没下载完。状态改变会触发 `readystatechange` 事件。
- lastModified，只读
- cookie
- referrer，只读
- domain
- location，只读

2. DOM 树访问
- title
- dir
- body
- head
- images，只读的属性集合，以下属性都是同样的类型
- embeds
- plugins
- links
- forms
- scripts
- getElementsByName( elementName )
- currentScript，只是 classic script

3. 动态标记插入
- close()
- write( text )
- writeln( text )

4.用户交互
- defaultView
- activeElement
- hasFocus()
- designMode


## HTMLElement
- title
- lang
- translate
- dir
- dataset
- hidden
- tabIndex
- accessKey
- accessKeyLabel
- draggable
- contextMenu
- spellcheck
- forceSpellCheck()
- click()
- focus()
- blur()
- innerText

## content model

定义了元素的内容类型。

空白字符是始终允许出现的。

ASCII whitespace
- U+0009 TAB
- U+000A LF
- U+000C FF
- U+000D CR
- U+0020 SPACE

空 Text 节点，和包含一个或多个 ASCII 空白字符的 Text 节点，被称为 `inter-element whitespace`。

内容分类：
- Metadata content
- Flow content
- Sectioning content
- Heading content
- Phrasing content
- Embedded content
- Interactive content

特殊情况：
- nothing，不应该有文本节点或其它元素节点
- transparent，由该元素的父元素来决定它能包含什么内容，如果父元素也是 `transparent`，那么继续向上查找

### metadata

为后续内容的显示/行为做设置，或是传递信息。

包含的元素有：
- base
- link
- meta
- noscript
- script
- style
- template
- title

### flow

`body` 中的大部分元素都属于该类别

### sectioning

定义头部/页脚的范围。

包含的元素有：
- article
- aside
- nav
- section

### heading

定义区域内的标题。

包含的元素有：
- h1
- h2
- h3
- h4
- h5
- h6
- hgroup

### phrasing

修饰文档中的文本。绝大多数 `phrasing` 中的元素只能包含同样是 `phrasing` 的元素。

### embedded

引入其他资源到当前文档中。

包含的元素有：
- audio
- canvas
- embed
- iframe
- img
- mathml matho
- bject
- picture
- svg
- video

### interactive

用于用户交互的内容。

包含的元素有：
- a，如果存在 `href`
- audio, 如果存在 `controls`
- button
- details
- embed
- iframe
- img, 如果存在 `usemap`
- input, 如果 `type` 不为 `hidden`
- label
- object, 如果存在 `usemap`
- select
- textarea
- video, 如果存在 `controls`

**只要包含 `tabindex` 就可以变为 `interactive`**

## 全局特性 

所有元素都可以设置的 attribute：
- accesskey
- contenteditable
- contextmenu
- dir
- draggable
- hidden
- is
- itemid
- itemprop
- itemref
- itemscope
- itemtype
- lang
- spellcheck
- style
- tabindex
- title
- translate
