[CSS Inline Layout Module Level 3](http://www.w3.org/TR/css-inline-3/)

## dominant-baseline

value: auto | text-bottom | alphabetic | central | mathematical | hanging | text-top

指定 dominant baseline, 用于文本与行级元素的对齐

- auto
    
    水平模式下等于 `alphabetic`, 垂直模式下, 如果 `text-orientation` 是 `sideways`, `sideways-right`, `sideways-left`, 它等于 `alphabetic`, 如果 `text-orientation` 值为 `mixed` 或者 `upright`, 它为 `central`
    
- text-bottom

    em box 的底部作为基线
    
- alphabetic

    使用字母基线
    
- central
    
    使用中央基线
    
- mathematical

    使用 mathematical 基线
    
- hanging

    使用 hanging 基线
    
- text-top

    使用 em box 的顶部作为基线
    
## vertical-align

value: \<baseline-shift\> | \<alignment-baseline\>

### alignment-baseline

value: baseline | text-bottom | alphabetic | middle | central | mathematical | text-top | bottom | center | top

- baseline

    将 box 的对应基线与父容器的 dominant baseline 对齐
    
- text-bottom

    box 的底部与父容器的内容区底部
    
- alphabetic

    box 的 alphabetic baseline 与父容器对应的基线对齐

- middle

    box 的垂直中心点与父容器的基线加上父容器 x-height 的一半高度
    
- central

    box 的 central baseline 与父容器的 central baseline 对齐
    
- mathematical

    box 的 mathematical baseline 与父容器的 mathematical baseline 对齐

- text-top

    box 的顶部与父容器的内容区顶部

- top

    Align the top of the aligned subtree with the top of the line box.

- center
    
    Align the center of the aligned subtree with the center of the line box.

- bottom
    
    Align the bottom of the aligned subtree with the bottom of the line box.
