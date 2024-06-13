# CLI

[TOC]

## Console 配置

| 属性     | 缺省配置  |
| -------- | --------- |
| 传输速率 | 9600bit/s |
| 流控方式 | No        |
| 校验方式 | No        |
| 停止位   | 1         |
| 数据位   | 8         |

| 用户名 | 密码 |
| ------ | ---- |
| admin  | NULL |

## 命令列表

| 命令       | 作用                                                         |
| ---------- | ------------------------------------------------------------ |
| initialize | 删除设备存储介质中保存的下次启动配置文件，并以默认配置重启设备。 |
| ipsetup    | 修改 VLAN-interface 1 接口 IP 。                             |
| password   | 修改用户登录密码。                                           |
| ping       | Ping function                                                |
| quit       | 退出系统                                                     |
| reboot     | Reboot system/board/card                                     |
| summary    | 查看设备概要信息。                                           |
| upgrade    | Upgrade the system boot file or the Boot ROM program         |

### ipsetup

```bash
ipsetup { dhcp | ip-address ip { mask | mask-length } [ default-gateway ip ] }

ipsetup ipv6 { auto | address { ip prefix-length | ipv6-address/prefix-length } [ default-gateway ip ] }
```

### ping

```bash
ping host

ping ipv6 host
```

### upgrade

```bash
upgrade [ ipv6 ] server-address source-filename { bootrom | runtime }

# server-address	TFTP 服务器 IP
# source-filename	TFTP 服务器上的源文件名
# bootrom			使用下载的文件更新 Bootrom 。暂不支持。
# runtime			使用下载的文件更新系统启动文件。
```

