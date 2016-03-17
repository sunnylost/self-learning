
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


[package.json: An Interactive Guide](http://browsenpm.org/package.json)
