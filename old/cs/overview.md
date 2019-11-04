# [计算机科学概论](http://book.douban.com/subject/4027938/)

### 欧几里得算法——求两个正整数的最大公约数

```javascript
function euclid(m, n) {
    if(n > m) return euclid(n, m);

	var r;

	if(r = m % n) {
		return euclid(n, r);
	}
	return n;
}
```

## 数据存储

位: bit(binary digits)，0 或 1。

布尔运算：处理真假值的运算。

字节: byte, 8 位的串称为字节。

主存储器是以存储单元(cell) 组织起来, 每个存储单元都有一个地址。

# 计算机组成

## 计算机系统组成

### 数字逻辑层
