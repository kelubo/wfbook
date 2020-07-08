# 认证服务 Keystone

Keystone is an OpenStack service that provides API client authentication, service discovery, and distributed multi-tenant authorization by implementing [OpenStack’s Identity API](https://docs.openstack.org/api-ref/identity/index.html).

## Related Projects[¶](https://docs.openstack.org/keystone/ussuri/index.html#related-projects)

In addition to creating OpenStack’s Identity Service, the Keystone team also provides a [WSGI middleware](https://docs.openstack.org/keystonemiddleware/latest), an [Authentication library](https://docs.openstack.org/keystoneauth/latest) and a [Python client library](https://docs.openstack.org/python-keystoneclient/latest).



OpenStack  Identity  service为认证管理，授权管理和服务目录服务管理提供单点整合。其它OpenStack服务将身份认证服务当做通用统一API来使用。此外，提供用户信息但是不在OpenStack项目中的服务（如LDAP服务）可被整合进先前存在的基础设施中。

为了从identity服务中获益，其他的OpenStack服务需要与它合作。当某个OpenStack服务收到来自用户的请求时，该服务询问Identity服务，验证该用户是否有权限进行此次请求。

身份服务包含这些组件：

- 服务器

  一个中心化的服务器使用RESTful 接口来提供认证和授权服务。

- 驱动

  驱动或服务后端被整合进集中式服务器中。它们被用来访问OpenStack外部仓库的身份信息, 并且它们可能已经存在于OpenStack被部署在的基础设施（例如，SQL数据库或LDAP服务器）中。

- 模块

  中间件模块运行于使用身份认证服务的OpenStack组件的地址空间中。这些模块拦截服务请求，取出用户凭据，并将它们送入中央是服务器寻求授权。中间件模块和OpenStack组件间的整合使用Python Web服务器网关接口。

当安装OpenStack身份服务，用户必须将之注册到其OpenStack安装环境的每个服务。身份服务才可以追踪那些OpenStack服务已经安装，以及在网络中定位它们。

## 安装和配置

在控制节点上安装和配置OpenStack身份认证服务，代码名称keystone。出于性能原因，这个配置部署Fernet令牌和Apache HTTP服务处理请求。

### 先决条件

在你配置 OpenStack 身份认证服务前，你必须创建一个数据库和管理员令牌。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```bash
     mysql -u root -p
     ```

   - 创建 `keystone` 数据库：

     ```mysql
     CREATE DATABASE keystone;
     ```

   - 对``keystone``数据库授予恰当的权限：

     ```bash
     GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
     GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';
     ```
     
     用合适的密码替换 `KEYSTONE_DBPASS` 。

   - 退出数据库客户端。

2. 生成一个随机值在初始的配置中作为管理员的令牌。

   ```bash
   openssl rand -hex 10
   ```

### 安全并配置组件

> **注解:**
>
> 默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

教程使用带有``mod_wsgi``的Apache HTTP服务器来服务认证服务请求，端口为5000和35357。缺省情况下，Kestone服务仍然监听这些端口。然而，本教程手动禁用keystone服务。

1. 运行以下命令来安装包。

   ```bash
   yum install openstack-keystone httpd mod_wsgi
   ```

2. 编辑文件 `/etc/keystone/keystone.conf` 并完成如下动作：

   - 在``[DEFAULT]``部分，定义初始管理令牌的值：

     ```bash
     [DEFAULT]
     ...
     admin_token = ADMIN_TOKEN
     ```

     使用前面步骤生成的随机数替换``ADMIN_TOKEN`` 值。

   - 在 `[database]` 部分，配置数据库访问：

     ```bash
     [database]
     ...
     connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
     ```

     将``KEYSTONE_DBPASS``替换为你为数据库选择的密码。

   - 在``[token]``部分，配置Fernet UUID令牌的提供者。

     ```bash
     [token]
     ...
     provider = fernet
     ```

3. 初始化身份认证服务的数据库：

   ```bash
   su -s /bin/sh -c "keystone-manage db_sync" keystone
   ```

   忽略输出中任何不推荐使用的信息。

4. 初始化Fernet keys：

   ```bash
   keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
   ```

### 配置 Apache HTTP 服务器

1. 编辑``/etc/httpd/conf/httpd.conf`` 文件，配置``ServerName`` 选项为控制节点：

   ```bash
   ServerName controller
   ```

2. 用下面的内容创建文件 `/etc/httpd/conf.d/wsgi-keystone.conf`。

   ```bash
   Listen 5000
   Listen 35357
   
   <VirtualHost *:5000>
       WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
       WSGIProcessGroup keystone-public
       WSGIScriptAlias / /usr/bin/keystone-wsgi-public
       WSGIApplicationGroup %{GLOBAL}
       WSGIPassAuthorization On
       ErrorLogFormat "%{cu}t %M"
       ErrorLog /var/log/httpd/keystone-error.log
       CustomLog /var/log/httpd/keystone-access.log combined
   
       <Directory /usr/bin>
           Require all granted
       </Directory>
   </VirtualHost>
   
   <VirtualHost *:35357>
       WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
       WSGIProcessGroup keystone-admin
       WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
       WSGIApplicationGroup %{GLOBAL}
       WSGIPassAuthorization On
       ErrorLogFormat "%{cu}t %M"
       ErrorLog /var/log/httpd/keystone-error.log
       CustomLog /var/log/httpd/keystone-access.log combined
   
       <Directory /usr/bin>
           Require all granted
       </Directory>
   </VirtualHost>
   ```

### 完成安装

- 启动 Apache HTTP 服务并配置其随系统启动：

  ```bash
  systemctl enable httpd.service
  systemctl start httpd.service
  ```

## 创建服务实体和API端点

 身份认证服务提供服务的目录和他们的位置。每个你添加到OpenStack环境中的服务在目录中需要一个 [*service*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-service) 实体和一些 [*API endpoints*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-api-endpoint) 。

### 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#prerequisites)

默认情况下，身份认证服务数据库不包含支持传统认证和目录服务的信息。你必须使用:doc:keystone-install 章节中为身份认证服务创建的临时身份验证令牌用来初始化的服务实体和API端点。

你必须使用``–os-token``参数将认证令牌的值传递给:command:openstack 命令。类似的，你必须使用``–os-url`` 参数将身份认证服务的 URL传递给 **openstack** 命令或者设置OS_URL环境变量。本指南使用环境变量以缩短命令行的长度。



 

警告



因为安全的原因，，除非做必须的认证服务初始化，不要长时间使用临时认证令牌。

1. 配置认证令牌：

   ```bash
   $ export OS_TOKEN=ADMIN_TOKEN
   ```

   将``ADMIN_TOKEN``替换为你在 :doc:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)keystone-install`章节中生成的认证令牌。例如：

   ```bash
   $ export OS_TOKEN=294a4c8a8a475f9b9836
   ```

2. 配置端点URL：

   ```bash
   $ export OS_URL=http://controller:35357/v3
   ```

3. 配置认证 API 版本：

   ```bash
   $ export OS_IDENTITY_API_VERSION=3
   ```

### 创建服务实体和API端点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)

1. 在你的Openstack环境中，认证服务管理服务目录。服务使用这个目录来决定您的环境中可用的服务。

   创建服务实体和身份认证服务：

   ```bash
   $ openstack service create \
     --name keystone --description "OpenStack Identity" identity
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | OpenStack Identity               |
   | enabled     | True                             |
   | id          | 4ddaae90388b4ebc9d252ec2252d8d10 |
   | name        | keystone                         |
   | type        | identity                         |
   +-------------+----------------------------------+
   ```

   

    

   注解

   

   OpenStack 是动态生成 ID 的，因此您看到的输出会与示例中的命令行输出不相同。

2. 身份认证服务管理了一个与您环境相关的 API 端点的目录。服务使用这个目录来决定如何与您环境中的其他服务进行通信。

   OpenStack使用三个API端点变种代表每种服务：admin，internal和public。默认情况下，管理API端点允许修改用户和租户而公共和内部APIs不允许这些操作。在生产环境中，处于安全原因，变种为了服务不同类型的用户可能驻留在单独的网络上。对实例而言，公共API网络为了让顾客管理他们自己的云在互联网上是可见的。管理API网络在管理云基础设施的组织中操作也是有所限制的。内部API网络可能会被限制在包含OpenStack服务的主机上。此外，OpenStack支持可伸缩性的多区域。为了简单起见，本指南为所有端点变种和默认``RegionOne``区域都使用管理网络。

   创建认证服务的 API 端点：

   ```bash
   $ openstack endpoint create --region RegionOne \
     identity public http://controller:5000/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 30fff543e7dc4b7d9a0fb13791b78bf4 |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c8c0927262a45ad9066cfe70d46892c |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:5000/v3        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     identity internal http://controller:5000/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 57cfa543e7dc4b712c0ab137911bc4fe |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 6f8de927262ac12f6066cfe70d99ac51 |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:5000/v3        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     identity admin http://controller:35357/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 78c3dfa3e7dc44c98ab1b1379122ecb1 |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 34ab3d27262ac449cba6cfe704dbc11f |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:35357/v3       |
   +--------------+----------------------------------+
   ```

   

    

   注解

   

   每个添加到OpenStack环境中的服务要求一个或多个服务实体和三个认证服务中的API 端点变种。

## 创建域、项目、用户和角色

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

身份认证服务为每个OpenStack服务提供认证服务。认证服务使用 T [*domains*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-domain)， [*projects*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-project) (tenants)， :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id1)users<user>`和 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id3)roles<role>`的组合。

1. 创建域``default``：

   ```bash
   $ openstack domain create --description "Default Domain" default
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | Default Domain                   |
   | enabled     | True                             |
   | id          | e0353a670a9e496da891347c589539e9 |
   | name        | default                          |
   +-------------+----------------------------------+
   ```

2. 在你的环境中，为进行管理操作，创建管理的项目、用户和角色：

   - 创建 `admin` 项目：

     ```
     $ openstack project create --domain default \
       --description "Admin Project" admin
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Admin Project                    |
     | domain_id   | e0353a670a9e496da891347c589539e9 |
     | enabled     | True                             |
     | id          | 343d245e850143a096806dfaefa9afdc |
     | is_domain   | False                            |
     | name        | admin                            |
     | parent_id   | None                             |
     +-------------+----------------------------------+
     ```

     

      

     注解

     

     OpenStack 是动态生成 ID 的，因此您看到的输出会与示例中的命令行输出不相同。

   - 创建 `admin` 用户：

     ```bash
     $ openstack user create --domain default \
       --password-prompt admin
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | ac3377633149401296f6c0d92d79dc16 |
     | name      | admin                            |
     +-----------+----------------------------------+
     ```

   - 创建 `admin` 角色：

     ```bash
     $ openstack role create admin
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | cd2cb9a39e874ea69e5d4b896eb16128 |
     | name      | admin                            |
     +-----------+----------------------------------+
     ```

   - 添加``admin`` 角色到 `admin` 项目和用户上：

     ```bash
     $ openstack role add --project admin --user admin admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

     

      

     注解

     

     你创建的任何角色必须映射到每个OpenStack服务配置文件目录下的``policy.json`` 文件中。默认策略是给予“admin“角色大部分服务的管理访问权限。更多信息，参考 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id1)Operations Guide - Managing Projects and Users <http://docs.openstack.org/ops-guide/ops-projects-users.html>`__.

3. 本指南使用一个你添加到你的环境中每个服务包含独有用户的service 项目。创建``service``项目：

   ```bash
   $ openstack project create --domain default \
     --description "Service Project" service
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | Service Project                  |
   | domain_id   | e0353a670a9e496da891347c589539e9 |
   | enabled     | True                             |
   | id          | 894cdfa366d34e9d835d3de01e752262 |
   | is_domain   | False                            |
   | name        | service                          |
   | parent_id   | None                             |
   +-------------+----------------------------------+
   ```

4. 常规（非管理）任务应该使用无特权的项目和用户。作为例子，本指南创建 `demo` 项目和用户。

   - 创建``demo`` 项目：

     ```bash
     $ openstack project create --domain default \
       --description "Demo Project" demo
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Demo Project                     |
     | domain_id   | e0353a670a9e496da891347c589539e9 |
     | enabled     | True                             |
     | id          | ed0b60bf607743088218b0a533d5943f |
     | is_domain   | False                            |
     | name        | demo                             |
     | parent_id   | None                             |
     +-------------+----------------------------------+
     ```

     

      

     注解

     

     当为这个项目创建额外用户时，不要重复这一步。

   - 创建``demo`` 用户：

     ```bash
     $ openstack user create --domain default \
       --password-prompt demo
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | 58126687cbcc4888bfa9ab73a2256f27 |
     | name      | demo                             |
     +-----------+----------------------------------+
     ```

   - 创建 `user` 角色：

     ```bash
     $ openstack role create user
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | 997ce8d05fc143ac97d83fdfb5998552 |
     | name      | user                             |
     +-----------+----------------------------------+
     ```

   - 添加 `user``角色到 ``demo` 项目和用户：

     ```bash
     $ openstack role add --project demo --user demo user
     ```

     

      

     注解

     

     这个命令执行后没有输出。



 

注解



你可以重复此过程来创建额外的项目和用户。

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

在安装其他服务之前确认身份认证服务的操作。



 

注解



在控制节点上执行这些命令。

1. 因为安全性的原因，关闭临时认证令牌机制：

   编辑 `/etc/keystone/keystone-paste.ini` 文件，从``[pipeline:public_api]``，`[pipeline:admin_api]``和``[pipeline:api_v3]``部分删除``admin_token_auth` 。

2. 重置``OS_TOKEN``和``OS_URL`` 环境变量：

   ```bash
   $ unset OS_TOKEN OS_URL
   ```

3. 作为 `admin` 用户，请求认证令牌：

   ```bash
   $ openstack --os-auth-url http://controller:35357/v3 \
     --os-project-domain-name default --os-user-domain-name default \
     --os-project-name admin --os-username admin token issue
   Password:
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:14:07.056119Z                                     |
   | id         | gAAAAABWvi7_B8kKQD9wdXac8MoZiQldmjEO643d-e_j-XXq9AmIegIbA7UHGPv |
   |            | atnN21qtOMjCFWX7BReJEQnVOAj3nclRQgAYRsfSU_MrsuWb4EDtnjU7HEpoBb4 |
   |            | o6ozsA_NmFWEpLeKy0uNn_WeKbAhYygrsmQGA49dclHVnz-OMVLiyM9ws       |
   | project_id | 343d245e850143a096806dfaefa9afdc                                |
   | user_id    | ac3377633149401296f6c0d92d79dc16                                |
   +------------+-----------------------------------------------------------------+
   ```

   

    

   注解

   

   这个命令使用``admin``用户的密码。

4. 作为``demo`` 用户，请求认证令牌：

   ```bash
   $ openstack --os-auth-url http://controller:5000/v3 \
     --os-project-domain-name default --os-user-domain-name default \
     --os-project-name demo --os-username demo token issue
   Password:
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:15:39.014479Z                                     |
   | id         | gAAAAABWvi9bsh7vkiby5BpCCnc-JkbGhm9wH3fabS_cY7uabOubesi-Me6IGWW |
   |            | yQqNegDDZ5jw7grI26vvgy1J5nCVwZ_zFRqPiz_qhbq29mgbQLglbkq6FQvzBRQ |
   |            | JcOzq3uwhzNxszJWmzGC7rJE_H0A_a3UFhqv8M4zMRYSbS2YF0MyFmp_U       |
   | project_id | ed0b60bf607743088218b0a533d5943f                                |
   | user_id    | 58126687cbcc4888bfa9ab73a2256f27                                |
   +------------+-----------------------------------------------------------------+
   ```

   

    

   注解

   

   这个命令使用``demo`` 用户的密码和API端口5000，这样只会允许对身份认证服务API的常规（非管理）访问。

## 创建 OpenStack 客户端环境脚本

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#creating-the-scripts)
  - [使用脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#using-the-scripts)

前一节中使用环境变量和命令选项的组合通过``openstack``客户端与身份认证服务交互。为了提升客户端操作的效率，OpenStack支持简单的客户端环境变量脚本即OpenRC 文件。这些脚本通常包含客户端所有常见的选项，当然也支持独特的选项。更多信息，请参考`OpenStack End User Guide <http://docs.openstack.org/user-guide/common/ cli_set_environment_variables_using_openstack_rc.html>`__。

### 创建脚本[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#creating-the-scripts)

创建 `admin` 和 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#id1)demo``项目和用户创建客户端环境变量脚本。本指南的接下来的部分会引用这些脚本，为客户端操作加载合适的的凭证。

1. 编辑文件 `admin-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=default
   export OS_USER_DOMAIN_NAME=default
   export OS_PROJECT_NAME=admin
   export OS_USERNAME=admin
   export OS_PASSWORD=ADMIN_PASS
   export OS_AUTH_URL=http://controller:35357/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `ADMIN_PASS` 替换为你在认证服务中为 `admin` 用户选择的密码。

2. 编辑文件 `demo-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=default
   export OS_USER_DOMAIN_NAME=default
   export OS_PROJECT_NAME=demo
   export OS_USERNAME=demo
   export OS_PASSWORD=DEMO_PASS
   export OS_AUTH_URL=http://controller:5000/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `DEMO_PASS` 替换为你在认证服务中为 `demo` 用户选择的密码。

### 使用脚本[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#using-the-scripts)

使用特定租户和用户运行客户端，你可以在运行之前简单地加载相关客户端脚本。例如：

1. 加载``admin-openrc``文件来身份认证服务的环境变量位置和``admin``项目和用户证书：

   ```bash
   . admin-openrc
   ```

2. 请求认证令牌:

   ```bash
   openstack token issue
   
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:44:35.659723Z                                     |
   | id         | gAAAAABWvjYj-Zjfg8WXFaQnUd1DMYTBVrKw4h3fIagi5NoEmh21U72SrRv2trl |
   |            | JWFYhLi2_uPR31Igf6A8mH2Rw9kv_bxNo1jbLNPLGzW_u5FC7InFqx0yYtTwa1e |
   |            | eq2b0f6-18KZyQhs7F3teAta143kJEWuNEYET-y7u29y0be1_64KYkM7E       |
   | project_id | 343d245e850143a096806dfaefa9afdc                                |
   | user_id    | ac3377633149401296f6c0d92d79dc16                                |
   +------------+-----------------------------------------------------------------+
   ```

​                      