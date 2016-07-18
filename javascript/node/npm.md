
- 更新: `sudo npm install npm -g`

- 查找 NPM package 安装路径: `npm config get prefix`

- 设置 NPM package 安装路径: `npm config set prefix new_directory_path`

    修改 `~/.profile`:

    ```
    export PATH=new_directory_path/bin:$PATH
    ```

    然后 `source ~/.profile`

- 快速创建 `package.json`: `npm init --yes`

- `npm install xxx --save` 表示安装模块时自动更新 `package.json`, 或者使用 `--save-dev`

- 查看安装包是否有新版本: `npm outdated`

- 查看全局安装包是否有新版本: `npm outdated -g --depth=0`

## Semantic versioning

项目版本号应该从 1.0.0 开始:

- bug 修复或小改动, 增加最后一个数字, 例如 1.0.1
- 增加新功能, 并且不会有兼容性问题, 增加中间的数字, 例如 1.1.0
- 重大更新, 会有兼容问题, 增加第一个数字, 例如 2.0.0

semver range:

如果依赖包的版本号是 1.0.4, 那么:

- 更新补丁
    - 1.0
    - 1.0.x
    - ~1.0.4
- 次要改进
    - 1
    - 1.x
    - ^1.0.4
- 重大更新
    - \*
    - x


[package.json: An Interactive Guide](http://browsenpm.org/package.json)

## 命令

- `npm view [package-name@version]`

    查看包信息

- `npm version [newversion]`

    更新 npm 包的版本
    
- `npm publish`
    
    发布包
    
- `npm adduser` 或 `npm login`

    登录, 注意, 如果设置了全局的 `registry`, 那么无论是 `login` 还是 `publish` 都会有问题, 在使用这些命令的时候需要指定官方的地址:
    
    ```
    npm publish --registry=https://registry.npmjs.org/
    ```
