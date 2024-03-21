# Horizon

[TOC]

## 概述

Horizon is the canonical implementation of [OpenStack’s Dashboard](https://github.com/openstack/horizon), 
Horizon 是 OpenStack Dashboard 的规范实现，它为 OpenStack 服务（包括 Nova、Swift、Keystone 等）提供了基于 Web 的用户界面。

Horizon 所需的唯一核心服务是 Identity 服务。可以将仪表盘与其他服务（如影像服务、计算和网络）结合使用。还可以在具有独立服务（如对象存储）的环境中使用仪表板。

这个部署示例使用的是 Apache Web 服务器。

## 安装和配置

> Note 注意
>
> This section assumes proper installation, configuration, and operation of the Identity service using the Apache HTTP server and Memcached service.
> 本部分假定使用 Apache HTTP 服务器和 Memcached 服务正确安装、配置和操作 Identity 服务。

### 系统要求

horizon 的 Ussuri 版本具有以下依赖项：

- Python 3.6 或 3.7
- Django 3.2
  - Django 支持策略记录在 [Django support](https://docs.openstack.org/horizon/yoga/contributor/policies/supported-software.html#django-support) 中。
- An accessible [keystone](https://docs.openstack.org/keystone/latest/) endpoint
  可访问的梯形校正面板点
- 所有其他服务都是可选的。自 Stein 版本起，Horizon 支持以下服务。如果配置了服务的 Keystone 端点，则 horizon 会检测到该端点并自动启用其支持。
  - cinder：块存储
  - glance： 镜像管理
  - neutron：网络
  - nova：计算
  - swift：对象存储
  - Horizon 还通过插件支持许多其他 OpenStack 服务。

### 安装并配置组件

> 注解
>
> 默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```bash
   yum install openstack-dashboard
   ```

1. 编辑文件 `/etc/openstack-dashboard/local_settings` 并完成如下动作：

   - 在 `controller` 节点上配置 dashboard 以使用 OpenStack 服务：

     ```ini
     OPENSTACK_HOST = "controller"
     ```

   - 允许主机访问仪表板：

     ```ini
     ALLOWED_HOSTS = ['one.example.com', 'two.example.com']
     ALLOWED_HOSTS = ['*']
     ```

     ALLOWED_HOSTS 也可以是  ['*']  以接受所有主机。这可能对开发工作有用，但可能不安全，不应在生产中使用。

   - 配置 `memcached` 会话存储服务：

     ```ini
     SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
     
     CACHES = {
         'default': {
              'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
              'LOCATION': 'controller:11211',
         }
     }
     ```

     > 注解
   >
     > 将其他的会话存储服务配置注释。

   - 启用第 3 版 Identity API:

     ```ini
     OPENSTACK_KEYSTONE_URL = "http://%s/identity/v3" % OPENSTACK_HOST
     ```

     > In case your keystone run at 5000 port then you would mentioned keystone port here as well i.e. OPENSTACK_KEYSTONE_URL = “http://%s:5000/identity/v3” % OPENSTACK_HOST
     > 如果您的 keystone 在 5000 端口上运行，那么您也会在这里提到 keystone 端口，即 OPENSTACK_KEYSTONE_URL = “ http：//%s：5000/identity/v3” % OPENSTACK_HOST

   - 启用对域的支持

     ```ini
     OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
     ```

   - 配置 API 版本:

     ```ini
     OPENSTACK_API_VERSIONS = {
         "identity": 3,
         "image": 2,
         "volume": 3,
     }
     ```

   - 通过仪表盘创建用户时的默认域配置为 `default` :

     ```ini
     OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "default"
     ```

   - 通过仪表盘创建的用户默认角色配置为 `user` ：

     ```ini
     OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
     ```

   - 如果您选择网络参数 1，禁用支持 3 层网络服务：

     ```ini
     OPENSTACK_NEUTRON_NETWORK = {
         ...
         'enable_router': False,
         'enable_quotas': False,
         'enable_distributed_router': False,
         'enable_ha_router': False,
         'enable_fip_topology_check': False,
     }
     ```
     
   - 可以选择性地配置时区：

     ```ini
     TIME_ZONE = "TIME_ZONE"
     ```

     使用恰当的时区标识替换 `TIME_ZONE` 。

1. Add the following line to `/etc/httpd/conf.d/openstack-dashboard.conf` if not included.
  如果未包含，请添加 `/etc/httpd/conf.d/openstack-dashboard.conf` 以下行。

  ```ini
  WSGIApplicationGroup %{GLOBAL}
  ```

## 完成安装

重启 web 服务器以及会话存储服务：

```bash
systemctl restart httpd.service memcached.service
```

## 验证操作

在浏览器中输入 http://controller/dashboard 访问仪表盘。

验证使用 `admin` 或者 `demo` 用户凭证和 `default` 域凭证。

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

你的 Openstack 环境现在已经包含了仪表盘. 你可参考：’launch-instance’ 或者添加更多的服务到你的环境中。

安装和配置好仪表板后，您可以完成以下任务：

- 给用户提供公共IP地址、用户名和密码，这样就可以通过web浏览器访问控制面板。在遇到任何SSL认证连接问题的情况下，指向服务IP到一个域名，让用户访问。

- 定制仪表盘。查看章节 [`配置仪表盘`__](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-next-steps.html#id1)。

- 配置session存储。参考 [`为仪表盘配置session存储`__](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-next-steps.html#id1)。

- 为了通过dashboard使用VNC客户端，浏览器必须支持HTML5 Canvas和HTML5 WebSockets。

  关于浏览器支持noVNC的详情，参考`README <https://github.com/kanaka/noVNC/blob/master/README.md>`__ and [browser support](https://github.com/kanaka/noVNC/wiki/Browser-support)。