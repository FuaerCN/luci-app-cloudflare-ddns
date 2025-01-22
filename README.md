# OpenWrt Cloudflare DDNS LuCI App

这是一个用于OpenWrt的Cloudflare DDNS LuCI应用。

## 功能特点

- 支持IPv4和IPv6
- 支持从网卡或网络获取IP
- 支持设置更新间隔
- 支持开启/关闭Cloudflare代理
- 简单易用的Web界面

## 安装方法

1. 下载最新的发布版本
2. 通过SSH连接到你的OpenWrt设备
3. 使用opkg安装IPK文件：
   ```bash
   opkg update
   opkg install luci-app-cloudflare-ddns_*.ipk
   ```

## 配置说明

1. 在Cloudflare获取以下信息：
   - API Token
   - Zone ID
   - 域名

2. 在LuCI界面中配置：
   - 进入 服务 -> Cloudflare DDNS
   - 填写必要信息
   - 保存并应用

## 构建

本项目使用GitHub Actions自动构建。每次推送到main分支都会触发新的构建。

## 许可证

MIT License 