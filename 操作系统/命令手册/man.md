# man

man 命令中常用按键及用途

| 按键 | 用途                       |
| ---- | -------------------------- |
| 空格 | 向下翻一页                 |
| PgDn | 向下翻一页                 |
| PgUp | 向上翻一页                 |
| home | 直接前往首页               |
| end  | 直接前往尾页               |
| /    | 从上至下搜索某个关键词     |
| ?    | 从下至上搜索某个关键词     |
| n    | 定位到下一个搜索到的关键词 |
| N    | 定位到上一个搜索到的关键词 |
| q    | 退出帮助文档               |

man 命令帮助信息的结构以及意义

| 结构名称    | 意义                     |
| ----------- | ------------------------ |
| NAME        | 命令的名称               |
| SYNOPSIS    | 参数的大致使用方法       |
| DESCRIPTION | 介绍说明                 |
| EXAMPLES    | 演示（附带简单说明）     |
| OVERVIEW    | 概述                     |
| DEFAULTS    | 默认的功能               |
| OPTIONS     | 具体的可用选项（带介绍） |
| ENVIRONMENT | 环境变量                 |
| FILES       | 用到的文件               |
| SEE ALSO    | 相关的资料               |
| HISTORY     | 维护历史与联系方式       |

1. 手册页的 nroff 输入通常保存在 /usr/share/man/ 下的多个目录中。Linux会用gzip进行压缩。
2. 在 /var/cache/man 或 /var/share/man 下，存在一个有格式的手册页的缓存。

## 搜索

1. man  -K  XXX
2. whatis  XXX
3. apropos  XXX