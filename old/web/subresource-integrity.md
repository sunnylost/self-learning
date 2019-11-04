对内嵌资源的完整性验证。

即在引用资源的时候，增加根据资源内容生成的一串编码，在浏览器加载资源后，自己通过对加载内容的解析生成另一段编码，如果二者相同，认为该资源是完整的，可以执行。

## integrity metadata

该数据包含三部分内容：
- 用于生成密码的哈希函数
- 密码值
- option，可以省略。规范中暂时没有定义

例如对于一个 js 文件，使用 SHA-384 来生成一段密码：
```
H8BRh8j48O9oYatfu5AZzq6A9RINhZO5H16dQZngK7T62em8MUt1FLm52t+eX6xO
```

则该资源的 integrity 属性为：
```
sha384-H8BRh8j48O9oYatfu5AZzq6A9RINhZO5H16dQZngK7T62em8MUt1FLm52t+eX6xO
```

同一个资源可以拥有多个 integrity metadata：
```html
<script src="hello_world.js"
   integrity="sha384-dOTZf16X8p34q2/kYyEFm0jh89uTjikhnzjeLeF0FHsEaYKb1A1cv+Lyv4Hk8vHd
              sha512-Q2bFTOhEALkN8hOms2FKTDLy7eugP2zFZ1T8LCvX42Fp3WoNr3bjZSAHeOsHrbV1Fu9/A0EzCinRE7Af1ofPrw=="
   crossorigin="anonymous"></script>
```

浏览器应该选择其中更强壮的哈希函数。
