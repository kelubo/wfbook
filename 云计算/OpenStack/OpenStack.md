# OpenStack

OpenStack系统服务包括计算服务、认证服务、网络服务、镜像服务、块存储服务、对象存储服务、计量服务、编排服务和数据库服务。

## 服务

| 服务        | 项目名称    | 描述                                       |
| :-------- | ------- | ---------------------------------------- |
| Dashboard | Horizon | 提供了一个基于web的自服务门户，与OpenStack底层服务交互。诸如启动一个实例，分配IP地址以及配置访问控制。 |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |
|           |         |                                          |

在你对基础安装，配置，操作和故障诊断熟悉之后，你应该考虑按照以下步骤使用生产架构来进行部署

- 确定并补充必要的核心和可选服务，以满足性能和冗余要求。
- 使用诸如防火墙，加密和服务策略的方式来加强安全。
- 使用自动化部署工具，例如Ansible, Chef, Puppet, or Salt来自动化部署，管理生产环境

## 示例的架构[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#example-architecture)

这个示例架构需要至少2个（主机）节点来启动基础服务：term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)virtual machine <virtual machine (VM)>`或者实例。像块存储服务，对象存储服务这一类服务还需要额外的节点

这个示例架构不同于下面这样的最小生产结构

- 网络代理驻留在控制节点上而不是在一个或者多个专用的网络节点上。
- 私有网络的覆盖流量通过管理网络而不是专用网络

关于生产架构的更多信息，参考`Architecture Design Guide <<http://docs.openstack.org/arch-design/content/>>`__, [Operations Guide `__和`Networking Guide](http://docs.openstack.org/networking-guide/)。