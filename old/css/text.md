[Text Level 3](http://www.w3.org/TR/css3-text/)

[Text Level 4](http://www.w3.org/TR/css-text-4/)

`grapheme cluster`, 字素族, 字母的基本单位

character 可以认为是 grapheme cluster 的同义词

## `text-transform`

value: none | capitalize | uppercase | lowercase

## `white-space`

value: normal | pre | nowrap | pre-wrap | pre-line

- normal

    合并连续空白为一个空白字符
    
- pre

    不合并连续空白, 保留换行与回车, 文字可能会溢出容器
    
- nowrap
    
    合并连续空白, 保留换行与回车
    
- pre-wrap

    不合并连续空白, 允许自动换行
    
- pre-line

    合并连续空白, 允许自动换行, 保留换行与回车
