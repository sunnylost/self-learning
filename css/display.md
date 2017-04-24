# CSS Display

[https://drafts.csswg.org/css-display-3/](https://drafts.csswg.org/css-display-3/)

`display` 由两部分组成：
- inner display type，创建什么类型的 formatting context
- outer display type，在父级 formatting context 中如何表现

它的值为:
```
[ <display-outside> || <display-inside> ] | <display-listitem> | <display-internal> | <display-box> | <display-legacy>
```

\<display-outside\>  = `block` | `inline` | `run-in`

\<display-inside\>   = `flow` | `flow-root` | `table` | `flex` | `grid` | `ruby` 

\<display-listitem> = `list-item` && \<display-outside\>? && [ `flow` | `flow-root` ]?

<display-internal> = `table-row-group` | `table-header-group` | `table-footer-group` | `table-row` | `table-cell` | `table-column-group` | `table-column` | `table-caption` | `ruby-base` | `ruby-text` | `ruby-base-container` |
`ruby-text-container`

\<display-box>      = `contents` | `none`

\<display-legacy>   = `inline-block` | `inline-list-item` | `inline-table` | `inline-flex` | `inline-grid`

## 默认值

- 如果只设置了 `<display-outside>`，那么 `<display-inside>` 为 `flow`
- 如果只设置了 `<display-inside>`，那么 `<display-outside>` 为 `block`(`ruby` 例外，为 `inline`)

## display-outside

- block，在 `flow layout` 中生成 block-level box
- inline，在 `flow layout` 中生成 inline-level box
- run-in，在 `flow layout` 中生成 run-in box


## display-inside

- flow，使用 `flow layout` 布局内容
- flow-root，生成 block container box，始终为内容创建 BFC
- table，生成 table wrapper box 和 table box，创建 `table formatting context`
- flex，生成 flex container box，创建 `flex formatting context`
- grid，生成 grid container box，创建 `grid formatting context`
- ruby，略

## display-listitem

元素会额外生成一个 `::marker` 伪元素

## display-box

- contents，元素本身不生成 box，但对后代不影响
- none，元素与后代不生成 box

## display-legacy

- inline-block，等价于 `inline flow-root`
- inline-table，等价于 `inline table`
- inline-flex，等价于 `inline flex`
- inline-grid，等价于 `inline grid`