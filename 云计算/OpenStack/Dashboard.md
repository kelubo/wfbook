## Dashboard

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- 安装和配置
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-next-steps.html)

Dashboard(horizon)是一个web接口，使得云平台管理员以及用户可以管理不同的Openstack资源以及服务。

这个部署示例使用的是 Apache Web 服务器。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#finalize-installation)

这个部分将描述如何在控制节点上安装和配置仪表板。

The dashboard relies on functional core services including Identity, Image service, Compute, and either Networking (neutron) or legacy networking (nova-network). Environments with stand-alone services such as Object Storage cannot use the dashboard. For more information, see the [developer documentation](http://docs.openstack.org/developer/horizon/topics/deployment.html).



 

注解



这部分假设认证服务使用的Apache HTTP服务和Memcached服务，已经像在 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#id1)Install and configure the Identity service <keystone-install>`中描述的一样正确的安装，配置和操作。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-dashboard
   ```

1. 编辑文件 `/etc/openstack-dashboard/local_settings` 并完成如下动作：

   - 在 `controller` 节点上配置仪表盘以使用 OpenStack 服务：

     ```
     OPENSTACK_HOST = "controller"
     ```

   - 允许所有主机访问仪表板：

     ```
     ALLOWED_HOSTS = ['*', ]
     ```

   - 配置 `memcached` 会话存储服务：

     ```
     SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
     
     CACHES = {
         'default': {
              'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
              'LOCATION': 'controller:11211',
         }
     }
     ```

     

      

     注解

     

     将其他的会话存储服务配置注释。

   - 启用第3版认证API:

     ```
     OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
     ```

   - 启用对域的支持

     ```
     OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
     ```

   - 配置API版本:

     ```
     OPENSTACK_API_VERSIONS = {
         "identity": 3,
         "image": 2,
         "volume": 2,
     }
     ```

   - 通过仪表盘创建用户时的默认域配置为 `default` :

     ```
     OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "default"
     ```

   - 通过仪表盘创建的用户默认角色配置为 `user` ：

     ```
     OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
     ```

   - 如果您选择网络参数1，禁用支持3层网络服务：

     ```
     OPENSTACK_NEUTRON_NETWORK = {
         ...
         'enable_router': False,
         'enable_quotas': False,
         'enable_distributed_router': False,
         'enable_ha_router': False,
         'enable_lb': False,
         'enable_firewall': False,
         'enable_vpn': False,
         'enable_fip_topology_check': False,
     }
     ```

   - 可以选择性地配置时区：

     ```
     TIME_ZONE = "TIME_ZONE"
     ```

     使用恰当的时区标识替换``TIME_ZONE`` 。更多信息，参考 [list of time zones](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones)。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#finalize-installation)

- 重启web服务器以及会话存储服务：

  ```
  # systemctl restart httpd.service memcached.service
  ```

  

   

  注解

  

  如果当前的服务当前没有运行，用 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-install.html#id1)systemctl_restart``来启动每个服务。

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

验证仪表盘的操作。

在浏览器中输入 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/horizon-verify.html#id1)http://controller/dashboard``访问仪表盘。

验证使用 `admin` 或者``demo``用户凭证和``default``域凭证。

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