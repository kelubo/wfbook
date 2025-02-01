# AWX

[TOC]

## a

AWX

目前 `Ansible Tower `最新版是`3.8.6`

Tower

对于 `Redhat`的 `Ansible Tower` ，官网上看到在 2022 年 11 月之后不在维护了，改版之后现在叫 Ansible Automation Platform，

Ansible Automation Platform

虽然有`AWX`是`Tower`的上游版本，但 `Ansible Automation Platform` 严格来说是企业生产，只能通过 Red Hat 订阅获得。

`AWX`和`Tower`的区别：https://www.ansible.com/products/awx-project/faq

#### **AWX  控制面板**

控制面板含有四个报告区域:

- `资源概况`：控制面板的顶部是关于受管主机、清单和 Ansible 项目的状态的摘要报告。
- `作业状态`：作业是  AWX  运行 playbook 的一次尝试。这一区域中提供随时间成功和失败的作业数的图形化显示。
- `最近的模板`：这一区域显示最近用于执行作业的作业模板列表。
- `最近的作业`：这一区域显示最近执行的作业以及执行日期和时间的列表。

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/4f27e27772d1d12c8d0a8566326b8aa6.png)

AWX

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/7b6d116f2fe68fada497d669f105a300.png)

Tower

#### **导航栏**

AWX  Web UI 左侧提供一系列导航链接，可用于访问常用的  AWX  资源。不同版本菜单略有区别

- `作业`：作业表示  AWX  针对某一主机清单单次运行某一 Ansible Playbook。
- `模板`：模板定义了用于通过  AWX  启动作业（以运行 Ansible Playbook）的参数。
- `凭据`：使用此接口管理凭据。凭据是[身份验证](https://cloud.tencent.com/product/mfas?from_column=20065&from=20065)数据，供  AWX  用于登录受管主机来运行 play，解密Ansible Vault 文件，从外部来源同步清单数据，从版本控制系统下载更新过的项目资料，以及执行类似任务。
- `项目`：项目表示一组相关的 Ansible Playbook。
- `Inventories 主机清单`：清单包含一组要管理的主机。
- `清单脚本`：使⽤此界面管理从外部来源（如云提供商和配置管理[数据库](https://cloud.tencent.com/solution/database?from_column=20065&from=20065) (CMDB) 等）生成和更新动态清单的脚本。(只有Tower有)
- `Organizations 机构`：使用此界面管理  AWX  内的组织实体，表示  AWX  资源的逻辑集合。
- `用户`：使用此界面管理  AWX  用户。
- `Teams`：使用此界面管理  AWX  团队。
- `Notifications`：使用此界面管理通知模板。
- `Management Jobs`：使用此界面管理系统作业，这将清理来自  AWX  操作的旧数据。

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/0c79bee6a06f2c3a2491b67867ca6a3e.png)

AWX

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/fd463a2c9ec4e74c508701bedecfbaae.png)

Tower

#### **管理工具链接**

AWX  Web UI 的右上方包含各种  AWX  管理工具的链接。

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/e368821bdebb1dce113910ef1782e5b3.png)

AWX

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/db8d21c5fe8327e5dae1d67ee956a12a.png)

Tower

- `账户配置`：当前用户账户名称显示为一个链接。可以点击进入配置界面。
- `关于`：显示  AWX  的已安装版本，以及使用的 Ansible 版本。
- `查看文档`：在新窗口显示  AWX  文档网站。
- `注销`：从  AWX  Web UI 注销。

#### **AWX  设置**

单击左侧导航栏中的 Settings，以访问  AWX  Settings 页面。

Settings 页面中提供的不同类型如下：

- `身份验证`：身份验证类别包含的设置用于在  AWX  中使用第三方登录信息（如 LDAP、AzureActive Directory、GitHub 或 Google OAuth2）为用户帐户配置简化的身份验证。
- `作业`：作业类别包含用于配置作业执行的高级设置。来控制用户可以设置的计划作业数量、支持由  AWX  启动 ad hoc 作业的 Ansible 模块，以及项目更新、事实缓存和作业运行的超时。
- `系统`：系统类别包含高级设置，可以使用它们来配置日志聚合、活动流设置和其他各种  AWX  选项。
- `用户界面`：用户界面类别允许配置分析报告，并为  AWX  [服务器](https://cloud.tencent.com/act/pro/promotion-cvm?from_column=20065&from=20065)设置自定义徽标或自定义登录消息。
- `许可`：Tower 比 AWX 多一个 License,此界面提供安装的许可证的详细信息，也可用于执行许可证管理任务，如安装和升级许可证等。

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/a55ba2d79052b9a06ef725482d45fd32.png)

AWX

![img](https://developer.qcloudimg.com/http-save/yehe-9163071/454f055b7555fbfde79ee7a4e7af3400.png)

Tower

#### **常规控件**

除了前面概述的导航和管理控件外， AWX  Web UI 中也使用了⼀些其它控件。

面包屑导航链接：浏览  AWX  Web UI 时，页面的左上角会创建一个“面包屑”轨迹。此轨迹清楚地标识各个页面的路径，同时还提供了返回到上一页的快捷方式。

活动流：位于 Logout 图表下。单击此图标可显示与当前页面相关的活动的报告。

搜索栏：可用于搜索或过滤数据集合。