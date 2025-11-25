# App.Bin.feishunet
应用包名：feishunet

显示名称：飞鼠组网

版本：1.0.10

发布者：@wbxingkong

## 应用简介
......
# 编译方法 
fnpack build
# 基本安装命令
appcenter-cli install-fpk feishunet.fpk

# 注意事项
更新版本要修改如下路径参数
manifest/version=""


## 手动安装要打开手动安装功能
### 查看当前状态
appcenter-cli manual-install

### 开启手动安装功能
appcenter-cli manual-install enable

### 关闭手动安装功能
appcenter-cli manual-install disable

