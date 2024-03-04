# 认证服务 keystone

[TOC]

## 概览

OpenStack Identity 服务是为 OpenStack 云环境中用户的账户和角色信息提供认证和管理服务的。是一个关键的服务，也是环境中需第一个安装的服务。OpenStack 云环境中所有服务之间的鉴权和认证都需要经过它。通过在所有服务之间传输有效的鉴权密钥，来对用户和租户鉴权。

Identity 服务为管理身份验证、授权和服务目录提供了单点集成。

标识服务通常是用户与之交互的第一个服务。通过身份验证后，最终用户可以使用其身份访问其他 OpenStack 服务。同样，其他 OpenStack 服务利用 Identity  服务来确保用户是他们所说的人，并发现其他服务在部署中的位置。身份服务还可以与某些外部用户管理系统（如 LDAP）集成。

用户和服务可以使用由 Identity 服务管理的服务目录来查找其他服务。顾名思义，服务目录是 OpenStack  部署中可用服务的集合。每个服务可以有一个或多个终结点，每个终结点可以是以下三种类型之一：管理、内部或公共。在生产环境中，出于安全原因，不同的终结点类型可能驻留在向不同类型的用户公开的不同网络上。例如，公共 API 网络可能从 Internet 上可见，因此客户可以管理他们的云。管理 API 网络可能仅限于管理云基础结构的组织内的操作员。内部  API 网络可能仅限于包含 OpenStack 服务的主机。此外，OpenStack  支持多个区域以实现可扩展性。为简单起见，本指南将管理网络用于所有终结点类型和默认 `RegionOne` 区域。在 Identity 服务中创建的区域、服务和端点共同构成了部署的服务目录。部署中的每个 OpenStack 服务都需要一个服务条目，其中包含存储在 Identity 服务中的相应端点。这一切都可以在安装和配置 Identity 服务后完成。

当某个 OpenStack 服务收到来自用户的请求时，该服务询问 Identity 服务，验证该用户是否有权限进行此次请求。

包含这些组件：

- 服务器

  集中式服务器使用 RESTful 接口提供身份验证和授权服务。

- Drivers 驱动

  驱动程序或服务后端被整合进集中式服务器中。它们被用来访问 OpenStack 外部存储库的身份信息, 并且它们可能已经存在于部署 OpenStack 的基础设施（例如，SQL 数据库或 LDAP 服务器）中。

- 模块

  中间件模块运行于使用身份认证服务的 OpenStack 组件的地址空间中。这些模块拦截服务请求，取出用户凭据，并将它们送入集中式服务器寻求授权。中间件模块和 OpenStack 组件间的整合使用 Python Web 服务器网关接口。

当安装 OpenStack 身份服务，用户必须将之注册到其 OpenStack 安装环境的每个服务。身份服务才可以追踪哪些 OpenStack 服务已经安装，以及在网络中定位它们。

本节介绍如何在控制器节点上安装和配置代号为 keystone 的 OpenStack Identity 服务。出于可伸缩性目的，此配置部署了 Fernet 令牌和 Apache HTTP 服务器来处理请求。

### 概念

* 租户

  租户就像一个项目，有一些资源，比如用户、镜像和实例，并且其中有仅仅对该项目可知的网络。

* 角色

  租户里的用户可以被指定为多种角色。在最基本的应用场景中，一个用户可以被指定为管理用角色，或者只是成员角色。当用户在租户中拥有管理员权限时，可以使用那些影响租户的功能。当用户被指定为成员角色，通常被指定执行与用户相关的功能。

* 用户

  用户可隶属于一个或多个租户，并且可以在这些项目中切换，去获取相应资源。

## 先决条件

创建一个数据库和管理员令牌。默认使用 MariaDB 数据库。确保已安装最新版本的 `python-pyasn1` 。

1. 创建数据库：

   ```mysql
   CREATE DATABASE keystone;
   
   GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
   GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';
   ```

## 安装和配置

> Note：
>
> 默认配置文件因发行版而异。可能需要添加这些部分和选项，而不是修改现有部分和选项。此外，配置代码段中的省略号 （ `...` ） 表示应保留的潜在默认配置选项。
>
> 从 Newton 发行版开始，SUSE OpenStack 软件包随上游默认配置文件一起提供。例如 `/etc/keystone/keystone.conf` ，在 中 `/etc/keystone/keystone.conf.d/010-keystone.conf` 进行自定义。虽然以下说明修改了默认配置文件，但添加 `/etc/keystone/keystone.conf.d` 新文件会获得相同的结果。
>
> Red Hat Enterprise Linux 7 及其衍生产品上通过 RDO 存储库安装 Keystone。
>
> 使用带有 `mod_wsgi` 的 Apache HTTP 服务器来服务认证服务请求，端口为5000和35357。缺省情况下，Kestone服务仍然监听这些端口。然而，本教程手动禁用keystone服务。

1. 运行以下命令来安装包。

   ```bash
   # SUSE Linux Enterprise Server 12 、openSUSE Leap 42.2 通过 Open Build Service Cloud 存储库
   zypper install openstack-keystone apache2 apache2-mod_wsgi
   
   # CentOS 7
   yum install openstack-keystone httpd mod_wsgi
   # CentOS 8
   yum install openstack-keystone httpd python3-mod_wsgi
   
   # Ubuntu
   sudo apt update
   sudo apt install keystone
   ```

2. 编辑文件 `/etc/keystone/keystone.conf` 并完成如下动作：

   在 `[database]` 部分，配置数据库访问：

   ```ini
   [database]
   ...
   connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
   # 将 KEYSTONE_DBPASS 替换为你为数据库选择的密码。
   # 注释掉或删除该 [database] 部分中的任何其他 connection 选项。
   ```

   在 `[token]` 部分，配置 Fernet 令牌提供程序。

   ```ini
   [token]
   ...
   provider = fernet
   ```

3. 初始化身份认证服务的数据库：

   ```bash
   su -s /bin/sh -c "keystone-manage db_sync" keystone
   ```

4. 初始化 Fernet 密钥存储库：

   `--keystone-user` 和 `--keystone-group` 标志用于指定将用于运行 keystone 的操作系统的用户/组。提供这些是为了允许在另一个操作系统用户/组下运行 keystone。在下面的示例中，我们使用 `keystone` 。

   ```bash
   keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
   keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
   ```

5. 引导 Identity 服务：

   在 Queens 版本发布之前，keystone 需要在两个单独的端口上运行，以适应 Identity v2 API，该 API 通常在端口  35357 上运行单独的仅限管理员的服务。删除 v2 API 后，keystone 可以在所有接口的同一端口上运行。替换 `ADMIN_PASS` 为适合管理用户的密码。

   ```bash
   keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
     --bootstrap-admin-url http://controller:5000/v3/ \
     --bootstrap-internal-url http://controller:5000/v3/ \
     --bootstrap-public-url http://controller:5000/v3/ \
     --bootstrap-region-id RegionOne
   ```

## 配置 Apache HTTP 服务器

A secure deployment should have the web server configured to use SSL or running behind an SSL terminator.
安全部署应将 Web 服务器配置为使用 SSL 或在 SSL 终结器后面运行。

1. SUSE

   编辑 `/etc/sysconfig/apache2` 文件并配置 `APACHE_SERVERNAME` 选项以引用控制器节点：

   ```bash
   APACHE_SERVERNAME="controller"
   ```

2. CentOS

   编辑 `/etc/httpd/conf/httpd.conf` 文件，配置 `ServerName` 选项为控制节点：

   ```ini
   ServerName controller
   ```

3. Ubuntu

   编辑 `/etc/apache2/apache2.conf` 文件并配置 `ServerName` 选项以引用控制器节点：

   ```bash
   ServerName controller
   ```

4. SUSE

   创建包含以下内容的文件 `/etc/apache2/conf.d/wsgi-keystone.conf` ：

   ```bash
   Listen 5000
   
   <VirtualHost *:5000>
       WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
       WSGIProcessGroup keystone-public
       WSGIScriptAlias / /usr/bin/keystone-wsgi-public
       WSGIApplicationGroup %{GLOBAL}
       WSGIPassAuthorization On
       ErrorLogFormat "%{cu}t %M"
       ErrorLog /var/log/apache2/keystone.log
       CustomLog /var/log/apache2/keystone_access.log combined
   
       <Directory /usr/bin>
           Require all granted
       </Directory>
   </VirtualHost>
   ```

5. CentOS

   创建指向该文件的 `/usr/share/keystone/wsgi-keystone.conf` 链接：

   ```bash
   ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
   ```

6. 递归更改 `/etc/keystone` 目录的所有权：

   ```bash
   chown -R keystone:keystone /etc/keystone
   ```

7. 启动 Apache HTTP 服务并配置其随系统启动：

   ```bash
   # SUSE
   systemctl enable apache2.service
   systemctl start apache2.service
   
   # CentOS
   systemctl enable httpd.service
   systemctl start httpd.service
   
   # Ubuntu
   service apache2 restart
   ```

8. 通过设置适当的环境变量来配置管理帐户：

   ```bash
   $ export OS_USERNAME=admin
   $ export OS_PASSWORD=ADMIN_PASS
   $ export OS_PROJECT_NAME=admin
   $ export OS_USER_DOMAIN_NAME=Default
   $ export OS_PROJECT_DOMAIN_NAME=Default
   $ export OS_AUTH_URL=http://controller:5000/v3
   $ export OS_IDENTITY_API_VERSION=3
   ```

   此处显示的这些值是从 `keystone-manage bootstrap` 创建的默认值。

   替换 `ADMIN_PASS` 为之前 `keystone-manage bootstrap` 命令中使用的密码。

## 创建域、项目、用户和角色

认证服务使用 domains，projects，users 和 roles 的组合。

1. 创建域：

   ```bash
   openstack domain create --description "An Example Domain" example
   
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | An Example Domain                |
   | enabled     | True                             |
   | id          | 2f4f80574fd84fe6ba9067228ae0a50c |
   | name        | example                          |
   | tags        | []                               |
   +-------------+----------------------------------+
   ```

2. 本指南使用一个服务项目，该项目包含添加到环境中的每个服务的唯一用户。创建 `service` 项目：

   ```bash
   openstack project create --domain default --description "Service Project" service
   
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | Service Project                  |
   | domain_id   | default                          |
   | enabled     | True                             |
   | id          | 24ac7f19cd944f4cba1d77469b2a73ed |
   | is_domain   | False                            |
   | name        | service                          |
   | parent_id   | default                          |
   | tags        | []                               |
   +-------------+----------------------------------+
   ```

3. 常规（非管理）任务应该使用无特权的项目和用户。例如，本指南创建 `myproject` 项目和 `myuser` 用户。

   - 创建 `myproject` 项目：

     ```bash
     openstack project create --domain default --description "Demo Project" myproject
     
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Demo Project                     |
     | domain_id   | default                          |
     | enabled     | True                             |
     | id          | 231ad6e7ebba47d6a1e57e1cc07ae446 |
     | is_domain   | False                            |
     | name        | myproject                        |
     | parent_id   | default                          |
     | tags        | []                               |
     +-------------+----------------------------------+
     ```
     
   - 创建 `myuser` 用户：

     ```bash
     openstack user create --domain default --password-prompt myuser
     
     User Password:
     Repeat User Password:
     +---------------------+----------------------------------+
     | Field               | Value                            |
     +---------------------+----------------------------------+
     | domain_id           | default                          |
     | enabled             | True                             |
     | id                  | aeda23aa78f44e859900e22c24817832 |
     | name                | myuser                           |
     | options             | {}                               |
     | password_expires_at | None                             |
     +---------------------+----------------------------------+
     ```
     
   - 创建 `myrole` 角色：

     ```bash
     openstack role create myrole
     
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | 997ce8d05fc143ac97d83fdfb5998552 |
     | name      | myrole                           |
     +-----------+----------------------------------+
     ```
     
   - 将 `myrole` 角色添加到 `myproject` 项目和 `myuser` 用户：

     ```bash
     openstack role add --project myproject --user myuser myrole
     ```

## 验证操作

> 注解:
> 在控制节点上执行这些命令。

1. 取消设置临时 `OS_AUTH_URL` 变量和 `OS_PASSWORD` 环境变量：

   ```bash
   unset OS_AUTH_URL OS_PASSWORD
   ```

2. 作为 `admin` 用户，请求认证令牌：

   ```bash
   openstack --os-auth-url http://controller:5000/v3 \
     --os-project-domain-name Default --os-user-domain-name Default \
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

3. 作为 `myuser` 用户，请求认证令牌：

   ```bash
   openstack --os-auth-url http://controller:5000/v3 \
     --os-project-domain-name Default --os-user-domain-name Default \
     --os-project-name myproject --os-username myuser token issue
   
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


## 创建客户端环境脚本

前一节中使用环境变量和命令选项的组合，通过 `openstack` 客户端与身份认证服务交互。为了提升客户端操作的效率，OpenStack 支持简单的客户端环境变量脚本即 OpenRC 文件。这些脚本通常包含客户端所有常见的选项，当然也支持独特的选项。

### 创建脚本

创建 `admin` 和 `demo` 项目和用户创建客户端环境变量脚本。

> Note：
>
> 客户端环境脚本的路径不受限制。为方便起见，您可以将脚本放置在任何位置，但请确保它们可访问并位于适合您的部署的安全位置，因为它们确实包含敏感凭据。OpenStack 客户端还支持使用 `clouds.yaml` 文件。

1. 编辑文件 `admin-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=Default
   export OS_USER_DOMAIN_NAME=Default
   export OS_PROJECT_NAME=admin
   export OS_USERNAME=admin
   export OS_PASSWORD=ADMIN_PASS
   export OS_AUTH_URL=http://controller:5000/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `ADMIN_PASS` 替换为你在认证服务中为 `admin` 用户选择的密码。

2. 编辑文件 `demo-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=Default
   export OS_USER_DOMAIN_NAME=Default
   export OS_PROJECT_NAME=myproject
   export OS_USERNAME=myuser
   export OS_PASSWORD=DEMO_PASS
   export OS_AUTH_URL=http://controller:5000/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `DEMO_PASS` 替换为你在认证服务中为 `demo` 用户选择的密码。

### 使用脚本

使用特定租户和用户运行客户端，只需在运行客户端环境脚本之前加载关联的客户端环境脚本即可。

1. Load the `admin-openrc` file to populate environment variables with the location of the Identity service and the `admin` project and user credentials:

   加载 `admin-openrc` 文件以使用 Identity 服务的位置以及 `admin` 项目和用户凭据填充环境变量：

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
