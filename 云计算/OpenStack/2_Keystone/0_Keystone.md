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

## Supported clients 支持的客户端

​                                          

There are two supported clients, [python-keystoneclient](https://docs.openstack.org/python-keystoneclient/latest) project provides python bindings and [python-openstackclient](https://docs.openstack.org/python-openstackclient/latest) provides a command line interface.
有两个受支持的客户端，python-keystoneclient 项目提供 python 绑定，python-openstackclient 提供命令行界面。

### Authenticating with a Password via CLI 通过 CLI 使用密码进行身份验证 ¶

To authenticate with keystone using a password and `python-openstackclient`, set the following flags, note that the following user referenced below should be granted the `admin` role.
要使用密码和 `python-openstackclient` 进行 keystone 身份验证，请设置以下标志，请注意，应向下面引用的以下用户授予该 `admin` 角色。

- `--os-username OS_USERNAME`: Name of your user
   `--os-username OS_USERNAME` ：您的用户名
- `--os-user-domain-name OS_USER_DOMAIN_NAME`: Name of the user’s domain
   `--os-user-domain-name OS_USER_DOMAIN_NAME` ：用户域的名称
- `--os-password OS_PASSWORD`: Password for your user
   `--os-password OS_PASSWORD` ：用户的密码
- `--os-project-name OS_PROJECT_NAME`: Name of your project
   `--os-project-name OS_PROJECT_NAME` ：项目名称
- `--os-project-domain-name OS_PROJECT_DOMAIN_NAME`: Name of the project’s domain
   `--os-project-domain-name OS_PROJECT_DOMAIN_NAME` ：项目域的名称
- `--os-auth-url OS_AUTH_URL`: URL of the keystone authentication server
   `--os-auth-url OS_AUTH_URL` ：keystone 认证服务器的 URL
- `--os-identity-api-version OS_IDENTITY_API_VERSION`: This should always be set to 3
   `--os-identity-api-version OS_IDENTITY_API_VERSION` ：这应始终设置为 3

You can also set these variables in your environment so that they do not need to be passed as arguments each time:
您还可以在环境中设置这些变量，以便它们不需要每次都作为参数传递：

```
$ export OS_USERNAME=my_username
$ export OS_USER_DOMAIN_NAME=my_user_domain
$ export OS_PASSWORD=my_password
$ export OS_PROJECT_NAME=my_project
$ export OS_PROJECT_DOMAIN_NAME=my_project_domain
$ export OS_AUTH_URL=http://localhost:5000/v3
$ export OS_IDENTITY_API_VERSION=3
```

For example, the commands `user list`, `token issue` and `project create` can be invoked as follows:
例如，命令 `user list` 和 `token issue` `project create` 可以按如下方式调用：

```
# Using password authentication, with environment variables
$ export OS_USERNAME=admin
$ export OS_USER_DOMAIN_NAME=Default
$ export OS_PASSWORD=secret
$ export OS_PROJECT_NAME=admin
$ export OS_PROJECT_DOMAIN_NAME=Default
$ export OS_AUTH_URL=http://localhost:5000/v3
$ export OS_IDENTITY_API_VERSION=3
$ openstack user list
$ openstack project create demo
$ openstack token issue

# Using password authentication, with flags
$ openstack --os-username=admin --os-user-domain-name=Default \
            --os-password=secret \
            --os-project-name=admin --os-project-domain-name=Default \
            --os-auth-url=http://localhost:5000/v3 --os-identity-api-version=3 \
            user list
$ openstack --os-username=admin --os-user-domain-name=Default \
            --os-password=secret \
            --os-project-name=admin --os-project-domain-name=Default \
            --os-auth-url=http://localhost:5000/v3 --os-identity-api-version=3 \
            project create demo
```

# Application Credentials 应用程序凭据

​                                          



Users can create application credentials to allow their applications to authenticate to keystone. Users can delegate a subset of their role assignments on a project to an application credential, granting the application the same or restricted authorization to a project. With application credentials, applications authenticate with the application credential ID and a secret string which is not the user’s password. This way, the user’s password is not embedded in the application’s configuration, which is especially important for users whose identities are managed by an external system such as LDAP or a single-signon system.
用户可以创建应用程序凭据，以允许其应用程序向 keystone  进行身份验证。用户可以将项目上的角色分配子集委派给应用程序凭据，从而向应用程序授予对项目的相同或受限的授权。使用应用程序凭据，应用程序使用应用程序凭据 ID 和不是用户密码的机密字符串进行身份验证。这样，用户的密码就不会嵌入到应用程序的配置中，这对于身份由外部系统（如 LDAP  或单点登录系统）管理的用户尤其重要。

See the [Identity API reference](https://docs.openstack.org/api-ref/identity/v3/index.html#application-credentials) for more information on authenticating with and managing application credentials.
有关使用应用程序凭据进行身份验证和管理应用程序凭据的详细信息，请参阅标识 API 参考。

## Managing Application Credentials 管理应用程序凭据 ¶

Create an application credential using python-openstackclient:
使用 python-openstackclient 创建应用程序凭据：

```
openstack application credential create monitoring
+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | None                                                                                   |
| id           | 26bb287fd56a41f8a577c47f79221187                                                       |
| name         | monitoring                                                                             |
| project_id   | e99b6f4b9bf84a9da27e20c9cbfe887a                                                       |
| roles        | Member anotherrole                                                                     |
| secret       | PJXxBFGPOLwdl3PA6tSivJT9S4RpWhLcNZH2gXzCoxX1C2cnZsj2_Xmfw-LE7Wc-NwuJEYoHcG0gQ5bjWwe-bg |
| unrestricted | False                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
```

The only required parameter is a name. The application credential is created for the project to which the user is currently scoped with the same role assignments the user has on that project. Keystone will automatically generate a secret string that will be revealed once at creation time. You can also provide your own secret, if desired:
唯一需要的参数是名称。应用程序凭据是为用户当前范围限定为的项目创建的，其角色分配与用户在该项目上具有的角色分配相同。Keystone 将自动生成一个秘密字符串，该字符串将在创建时显示一次。如果需要，还可以提供自己的密钥：

```
openstack application credential create monitoring --secret securesecret
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| description  | None                             |
| expires_at   | None                             |
| id           | bc257241e21747768c83fb9806af392d |
| name         | monitoring                       |
| project_id   | e99b6f4b9bf84a9da27e20c9cbfe887a |
| roles        | Member anotherrole               |
| secret       | securesecret                     |
| unrestricted | False                            |
+--------------+----------------------------------+
```

The secret is hashed before it is stored, so the original secret is not retrievable after creation. If the secret is lost, a new application credential must be created.
密钥在存储之前会进行哈希处理，因此原始密钥在创建后无法检索。如果机密丢失，则必须创建新的应用程序凭据。

If none are provided, the application credential is created with the same role assignments on the project that the user has. You can find out what role assignments you have on a project by examining your token or your keystoneauth session:
如果未提供任何凭据，则在项目上使用与用户相同的角色分配创建应用程序凭据。可以通过检查令牌或 keystoneauth 会话来了解项目上的角色分配：

```
mysession.auth.auth_ref.role_names
[u'anotherrole', u'Member']
```

If you have more than one role assignment on a project, you can grant your application credential only a subset of your role assignments if desired. This is useful if you have administrator privileges on a project but only want the application to have basic membership privileges, or if you have basic membership privileges but want the application to only have read-only privileges. You cannot grant the application a role assignment that your user does not already have; for instance, if you are an admin on a project, and you want your application to have read-only access to the project, you must acquire a read-only role assignment on that project yourself before you can delegate it to the application credential. Removing a user’s role assignment on a project will invalidate the user’s application credentials for that project.
如果一个项目上有多个角色分配，则可以根据需要仅向应用程序凭据授予角色分配的子集。如果您对项目具有管理员权限，但仅希望应用程序具有基本成员资格权限，或者您具有基本成员资格权限，但希望应用程序仅具有只读权限，这将非常有用。不能向应用程序授予用户尚不具有的角色分配;例如，如果你是某个项目的管理员，并且希望应用程序对该项目具有只读访问权限，则必须先自行获取该项目的只读角色分配，然后才能将其委派给应用程序凭据。删除用户在项目上的角色分配将使该用户在该项目中的应用程序凭据失效。

```
openstack application credential create monitoring --role Member
+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | None                                                                                   |
| id           | 5d04e42491a54e83b313aa2625709411                                                       |
| name         | monitoring                                                                             |
| project_id   | e99b6f4b9bf84a9da27e20c9cbfe887a                                                       |
| roles        | Member                                                                                 |
| secret       | vALEOMENxB_QaKFZOA2XOd7stwrhTlqPKrOdrXXM5BORss9u3O6GT-w_HYCPaZbtg96sDPCdtzVARZLpgUOY_g |
| unrestricted | False                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
```

An alternative way to limit the application credential’s privileges is to use [Access Rules](https://docs.openstack.org/keystone/latest/user/application_credentials.html#access-rules).
限制应用程序凭据权限的另一种方法是使用访问规则。

You can provide an expiration date for application credentials:
您可以为应用程序凭据提供到期日期：

```
openstack application credential create monitoring --expiration '2019-02-12T20:52:43'
+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | 2019-02-12T20:52:43.000000                                                             |
| id           | 4ea8c4a84f7b4c65a3d84460be9cd1f7                                                       |
| name         | monitoring                                                                             |
| project_id   | e99b6f4b9bf84a9da27e20c9cbfe887a                                                       |
| roles        | Member anotherrole                                                                     |
| secret       | _My16dlySn6jr7pGvBxjcMrmPA0MCpYlkKWs3gpY3-Ybk05yt2Hh83uMdTLPWlFeh8lOXajIAVHrQaBQ06iz5Q |
| unrestricted | False                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
```

By default, application credentials are restricted from creating or deleting other application credentials and from creating or deleting trusts. If your application needs to be able to perform these actions and you accept the risks involved, you can disable this protection:
默认情况下，应用程序凭据被限制为创建或删除其他应用程序凭据以及创建或删除信任。如果您的应用程序需要能够执行这些操作，并且您接受所涉及的风险，则可以禁用此保护：



 

Warning 警告



Restrictions on these Identity operations are deliberately imposed as a safeguard to prevent a compromised application credential from regenerating itself. Disabling this restriction poses an inherent added risk.
对这些标识操作的限制是特意施加的，以防止泄露的应用程序凭据自行再生。禁用此限制会带来固有的额外风险。

```
openstack application credential create monitoring --unrestricted
+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| description  | None                                                                                   |
| expires_at   | None                                                                                   |
| id           | 0a0372dbedfb4e82ab66449c3316ef1e                                                       |
| name         | monitoring                                                                             |
| project_id   | e99b6f4b9bf84a9da27e20c9cbfe887a                                                       |
| roles        | Member anotherrole                                                                     |
| secret       | ArOy6DYcLeLTRlTmfvF1TH1QmRzYbmD91cbVPOHL3ckyRaLXlaq5pTGJqvCvqg6leEvTI1SQeX3QK-3iwmdPxg |
| unrestricted | True                                                                                   |
+--------------+----------------------------------------------------------------------------------------+
```



## Access Rules 访问规则 ¶

In addition to delegating a subset of roles to an application credential, you may also delegate more fine-grained access control by using access rules.
除了将角色子集委派给应用程序凭据之外，还可以使用访问规则委派更精细的访问控制。



 

Note 注意



Application credentials with access rules require additional configuration of each service that will use it. See below for details.
具有访问规则的应用程序凭据需要对将使用它的每个服务进行额外配置。有关详细信息，请参见下文。

If application credentials with access rules are required, an OpenStack service using keystonemiddleware to authenticate with keystone, needs to define `service_type` in its configuration file. Following is an example for the cinder V3 service:
如果需要具有访问规则的应用程序凭据，则需要在其配置文件中定义 `service_type` 使用 keystone中间件进行身份验证的 OpenStack 服务。以下是 cinder V3 服务的示例：

```
[keystone_authtoken]
service_type = volumev3
```

For other OpenStack sevices, their types can be obtained using the OpenStack client. For example:
对于其他 OpenStack 服务，可以使用 OpenStack 客户端获取其类型。例如：

```
openstack service list -c Name -c Type
+-----------+-----------+
| Name      | Type      |
+-----------+-----------+
| glance    | image     |
| cinderv3  | volumev3  |
| cinderv2  | volumev2  |
| keystone  | identity  |
| nova      | compute   |
| neutron   | network   |
| placement | placement |
+-----------+-----------+
```



 

Note 注意



Updates to the configuration files of a service require restart of the appropriate services for the changes to take effect.
对服务的配置文件的更新需要重新启动相应的服务才能使更改生效。

In order to create an example application credential that is constricted to creating servers in nova, the user can add the following access rules:
为了创建限制为在 nova 中创建服务器的示例应用程序凭据，用户可以添加以下访问规则：

```
openstack application credential create scaler-upper --access-rules '[
    {
        "path": "/v2.1/servers",
        "method": "POST",
        "service": "compute"
    }
]'
```

The `"path"` attribute of application credential access rules uses a wildcard syntax to make it more flexible. For example, to create an application credential that is constricted to listing server IP addresses, you could use either of the following access rules:
应用程序凭据访问规则的 `"path"` 属性使用通配符语法使其更加灵活。例如，若要创建限制为列出服务器 IP 地址的应用程序凭据，可以使用以下任一访问规则：

```
[
    {
        "path": "/v2.1/servers/*/ips",
        "method": "GET",
        "service": "compute"
    }
]
```

or equivalently: 或同等学历：

```
[
    {
        "path": "/v2.1/servers/{server_id}/ips",
        "method": "GET",
        "service": "compute"
    }
]
```

In both cases, a request path containing any server ID will match the access rule. For even more flexibility, the recursive wildcard `**` indicates that request paths containing any number of `/` will be matched. For example:
在这两种情况下，包含任何服务器 ID 的请求路径都将与访问规则匹配。为了获得更大的灵活性，递归通配符 `**` 指示包含任意数量的 `/` 请求路径将被匹配。例如：

```
[
    {
        "path": "/v2.1/**",
        "method": "GET",
        "service": "compute"
    }
]
```

will match any nova API for version 2.1.
将匹配版本 2.1 的任何 nova API。

An access rule created for one application credential can be re-used by providing its ID to another application credential. You can list existing access rules:
通过向另一个应用程序凭据提供其 ID，可以重复使用为一个应用程序凭据创建的访问规则。您可以列出现有的访问规则：

```
openstack access rule list
+--------+---------+--------+---------------+
| ID     | Service | Method | Path          |
+--------+---------+--------+---------------+
| abcdef | compute | POST   | /v2.1/servers |
+--------+---------+--------+---------------+
```

and create an application credential using that rule:
并使用该规则创建应用程序凭据：

```
openstack application credential create scaler-upper-02 \
 --access-rules '[{"id": "abcdef"}]'
```

## Using Application Credentials 使用应用程序凭据 ¶

Applications can authenticate using the application_credential auth method. For a service using keystonemiddleware to authenticate with keystone, the auth section would look like this:
应用程序可以使用 application_credential 身份验证方法进行身份验证。对于使用 keystonemiddleware 向 keystone 进行身份验证的服务，auth 部分如下所示：

```
[keystone_authtoken]
auth_url = https://keystone.server/identity/v3
auth_type = v3applicationcredential
application_credential_id = 6cb5fa6a13184e6fab65ba2108adf50c
application_credential_secret= glance_secret
```

You can also identify your application credential with its name and the name or ID of its owner. For example:
您还可以使用应用程序凭据的名称及其所有者的名称或 ID 来标识应用程序凭据。例如：

```
[keystone_authtoken]
auth_url = https://keystone.server/identity/v3
auth_type = v3applicationcredential
username = glance
user_domain_name = Default
application_credential_name = glance_cred
application_credential_secret = glance_secret
```

## Rotating Application Credentials 轮换应用程序凭据 ¶

A user can create multiple application credentials with the same role assignments on the same project. This allows the application credential to be gracefully rotated with minimal or no downtime for your application. In contrast, changing a service user’s password results in immediate downtime for any application using that password until the application can be updated with the new password.
用户可以在同一项目上创建具有相同角色分配的多个应用程序凭据。这允许应用程序凭据正常轮换，而应用程序的停机时间最短或没有停机时间。相反，更改服务用户的密码会导致使用该密码的任何应用程序立即停机，直到可以使用新密码更新应用程序。



 

Note 注意



Rotating application credentials is essential if a team member who has knowledge of the application credential identifier and secret leaves the team for any reason. Rotating application credentials is also recommended as part of regular application maintenance.
如果知道应用程序凭据标识符和机密的团队成员出于任何原因离开团队，则轮换应用程序凭据至关重要。还建议将轮换应用程序凭据作为定期应用程序维护的一部分。

Rotating an application credential is a simple process:
轮换应用程序凭据是一个简单的过程：

1. Create a new application credential. Application credential names must be unique within the user’s set of application credentials, so this new application credential must not have the same name as the old one.
   创建新的应用程序凭据。应用程序凭据名称在用户的应用程序凭据集中必须是唯一的，因此此新应用程序凭据的名称不得与旧凭据同名。
2. Update your application’s configuration to use the new ID (or name and user identifier) and the new secret. For a distributed application, this can be done one node at a time.
   更新应用程序的配置以使用新 ID（或名称和用户标识符）和新密钥。对于分布式应用程序，可以一次完成一个节点。
3. When your application is fully set up with the new application credential, delete the old one.
   使用新的应用程序凭据完全设置应用程序后，请删除旧凭据。

## Frequently Asked Questions 常见问题解答 ¶

### Why is the application credential owned by the user rather than the project? 为什么应用程序凭据归用户而不是项目所有？¶

Having application credentials be owned by a project rather than by an individual user would be convenient for cases where teams want applications to continue running after the creating user has left the team. However, this would open up a security hole by which the creating user could still gain access to the resources accessible by the application credential even after the user is disabled. Rather than relying on the application credential persisting after users are disabled, it is recommended to proactively rotate the application credential to another user prior to the original creating user being disabled.
如果团队希望应用程序在创建用户离开团队后继续运行，那么将应用程序凭据归项目而不是单个用户所有会很方便。但是，这将打开一个安全漏洞，即使在禁用用户后，创建用户仍可以通过该漏洞访问应用程序凭据可访问的资源。建议在禁用原始创建用户之前主动将应用程序凭据轮换给其他用户，而不是依赖于禁用用户后保留的应用程序凭据。

# Trusts 信托

​                                          

OpenStack Identity manages authentication and authorization. A trust is an OpenStack Identity extension that enables delegation and, optionally, impersonation through `keystone`. A trust extension defines a relationship between:
OpenStack Identity 管理身份验证和授权。信任是一个 OpenStack Identity 扩展，它支持委派，也可以选择通过 `keystone` 进行模拟。信任扩展定义了以下关系：

- **Trustor 委托人**

  The user delegating a limited set of their own rights to another user. 用户将自己的一组有限权限委派给其他用户。

- **Trustee 受托 人**

  The user trust is being delegated to, for a limited time. 用户信任在有限的时间内被委派给。 The trust can eventually allow the trustee to impersonate the trustor. For security reasons, some safeties are added. For example, if a trustor loses a given role, any trusts the user issued with that role, and the related tokens, are automatically revoked. 信托最终可以允许受托人冒充委托人。出于安全原因，添加了一些安全措施。例如，如果委托人丢失了给定的角色，则用户授予该角色的任何信任以及相关令牌都将自动撤销。

The delegation parameters are:
委派参数包括：

- **User ID 用户 ID**

  The user IDs for the trustor and trustee. 委托人和受托人的用户 ID。

- **Privileges 特权**

  The delegated privileges are a combination of a project ID and a number of roles that must be a subset of the roles assigned to the trustor. 委派权限是项目 ID 和多个角色的组合，这些角色必须是分配给委托人的角色的子集。 If you omit all privileges, nothing is delegated. You cannot delegate everything. 如果省略所有权限，则不会委派任何内容。你不能委派一切。

- **Delegation depth 委派深度**

  Defines whether or not the delegation is recursive. If it is recursive, defines the delegation chain length. 定义委派是否为递归委派。如果它是递归的，则定义委派链长度。 Specify one of the following values: 指定以下值之一： `0`. The delegate cannot delegate these permissions further.  `0` 。委托人无法进一步委派这些权限。 `1`. The delegate can delegate the permissions to any set of delegates but the latter cannot delegate further.  `1` 。委托可以将权限委派给任何一组代理，但后者不能进一步委派。 `inf`. The delegation is infinitely recursive.  `inf` 。委派是无限递归的。

- **Endpoints 端点**

  A list of endpoints associated with the delegation. 与委派关联的终结点列表。 This parameter further restricts the delegation to the specified endpoints only. If you omit the endpoints, the delegation is useless. A special value of `all_endpoints` allows the trust to be used by all endpoints associated with the delegated project. 此参数进一步将委派限制为仅对指定的终结点。如果省略终结点，则委派将毫无用处。特殊值 允许 `all_endpoints` 与委派项目关联的所有终结点使用信任。

- **Duration 期间**

  (Optional) Comprised of the start time and end time for the trust. （可选）由信任的开始时间和结束时间组成。



 

Note 注意



See the administrator guide on [removing expired trusts](https://docs.openstack.org/keystone/latest/admin/manage-trusts.html) for recommended maintenance procedures.
有关建议的维护过程，请参阅有关删除过期信任的管理员指南。

# API Discovery with JSON Home 使用 JSON 主页进行 API 发现

​                                          

## What is JSON Home? 什么是 JSON Home？¶

JSON Home describes a method of API discovery for non-browser HTTP clients. The [draft](https://mnot.github.io/I-D/json-home/) is still in review, but keystone supplies an implementation accessible to end-users. The result of calling keystone’s JSON Home API is a JSON document that informs the user about API endpoints, where to find them, and even information about the API’s status (e.g. experimental, supported, deprecated). More information keystone’s implementation of JSON Home can be found in the [specification](http://specs.openstack.org/openstack/keystone-specs/specs/keystone/juno/json-home.html).
JSON 主页描述了一种针对非浏览器 HTTP 客户端的 API 发现方法。该草案仍在审查中，但 keystone 提供了最终用户可访问的实现。调用  keystone 的 JSON 主 API 的结果是一个 JSON 文档，该文档通知用户有关 API 端点、在哪里找到它们，甚至有关 API  状态的信息（例如实验性、支持、已弃用）。有关 keystone 的 JSON Home 实现的更多信息，请参阅规范。

## Requesting JSON Home Documents 请求 JSON 主文档 ¶

Requesting keystone’s JSON Home document is easy. The API does not require a token, but future implementations might expand in it’s protection with token validation and enforcement. To get a JSON Home document, just query a keystone endpoint with `application/json-home` specified in the `Accept` header:
请求 keystone 的 JSON Home 文档很容易。该 API 不需要令牌，但未来的实现可能会通过令牌验证和强制执行来扩展其保护。若要获取 JSON 主文档，只需查询 `Accept` 标头 `application/json-home` 中指定的 keystone 端点：

```
curl -X GET -H "Accept: application/json-home" http://example.com/identity/
```

The result will be a JSON document containing a list of `resources`:
结果将是一个 JSON 文档，其中包含以下 `resources` 列表：

```
{
    "resources": [
        "https://docs.openstack.org/api/openstack-identity/3/ext/OS-TRUST/1.0/rel/trusts": {
            "href": "/v3/OS-TRUST/trusts"
        },
        "https://docs.openstack.org/api/openstack-identity/3/ext/s3tokens/1.0/rel/s3tokens": {
            "href": "/v3/s3tokens"
        },
        "https://docs.openstack.org/api/openstack-identity/3/rel/application_credential": {
            "href-template": "/v3/users/{user_id}/application_credentials/{application_credential_id}",
            "href-vars": {
                "application_credential_id": "https://docs.openstack.org/api/openstack-identity/3/param/application_credential_id",
                "user_id": "https://docs.openstack.org/api/openstack-identity/3/param/user_id"
            }
        },
        "https://docs.openstack.org/api/openstack-identity/3/rel/auth_catalog": {
            "href": "/v3/auth/catalog"
        },
        "https://docs.openstack.org/api/openstack-identity/3/rel/auth_domains": {
            "href": "/v3/auth/domains"
        },
        "https://docs.openstack.org/api/openstack-identity/3/rel/auth_projects": {
            "href": "/v3/auth/projects"
        },
        "https://docs.openstack.org/api/openstack-identity/3/rel/auth_system": {
            "href": "/v3/auth/system"
        },
        ...
    ]
}
```

The list of resources can then be parsed based on the relationship key for a dictionary of data about that endpoint. This includes a path where users can find interact with the endpoint for that specific resources. API status information will also be present.
然后，可以根据有关该终结点的数据字典的关系键分析资源列表。这包括一个路径，用户可以在其中找到与该特定资源的终结点交互。API 状态信息也将显示。

# API Examples using Curl 使用 Curl 的 API 示例

​                                          

## v3 API Examples Using Curl 使用 curl 的 v3 API 示例 ¶



 

Note 注意



Following are some API examples using curl. Note that these examples are not automatically generated. They can be outdated as things change and are subject to regular updates and changes.
以下是一些使用 curl 的 API 示例。请注意，这些示例不是自动生成的。随着事物的变化，它们可能会过时，并且会定期更新和更改。

### GET / 获取 / ¶

Discover API version information, links to documentation (PDF, HTML, WADL), and supported media types:
发现 API 版本信息、文档链接（PDF、HTML、WADL）和支持的媒体类型：



 

Warning 警告



The v2.0 portion of this response will be removed in the T release. It is only advertised here because the v2.0 API supports the ec2tokens API until the T release. All other functionality of the v2.0 has been removed as of the Queens release. Use v3 for all functionality as it is more complete and secure.
此响应的 v2.0 部分将在 T 版本中删除。它仅在此处公布，因为 v2.0 API 在 T 版本发布之前支持 ec2tokens API。自 Queens 版本起，v2.0 的所有其他功能都已被删除。将 v3 用于所有功能，因为它更完整、更安全。

```
$ curl "http://localhost:5000"
{
    "versions": {
        "values": [
            {
                "id": "v3.10",
                "links": [
                    {
                        "href": "http://127.0.0.1:5000/v3/",
                        "rel": "self"
                    }
                ],
                "media-types": [
                    {
                        "base": "application/json",
                        "type": "application/vnd.openstack.identity-v3+json"
                    }
                ],
                "status": "stable",
                "updated": "2018-02-28T00:00:00Z"
            },
            {
                "id": "v2.0",
                "links": [
                    {
                        "href": "http://127.0.0.1:5000/v2.0/",
                        "rel": "self"
                    },
                    {
                        "href": "https://docs.openstack.org/",
                        "rel": "describedby",
                        "type": "text/html"
                    }
                ],
                "media-types": [
                    {
                        "base": "application/json",
                        "type": "application/vnd.openstack.identity-v2.0+json"
                    }
                ],
                "status": "deprecated",
                "updated": "2016-08-04T00:00:00Z"
            }
        ]
    }
}
```

### Tokens 代币 ¶

#### Unscoped 无作用域 ¶

Get an unscoped token:
获取无作用域令牌：

```
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "admin",
          "domain": { "id": "default" },
          "password": "adminpwd"
        }
      }
    }
  }
}' \
  "http://localhost:5000/v3/auth/tokens" ; echo
```

Example response: 响应示例：

```
HTTP/1.1 201 Created
X-Subject-Token: MIIFvgY...
Vary: X-Auth-Token
Content-Type: application/json
Content-Length: 312
Date: Fri, 11 May 2018 03:15:01 GMT

{
  "token": {
      "issued_at": "2018-05-11T03:15:01.000000Z",
      "audit_ids": [
          "0PKh_BDKTWqqaFONE-Sxbg"
      ],
      "methods": [
          "password"
      ],
      "expires_at": "2018-05-11T04:15:01.000000Z",
      "user": {
          "password_expires_at": null,
          "domain": {
              "id": "default",
              "name": "Default"
          },
          "id": "9a7e43333cc44ef4b988f05fc3d3a49d",
          "name": "admin"
      }
  }
}
```

#### Project-scoped 项目范围 ¶

Get a project-scoped token:
获取项目范围的令牌：

```
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "admin",
          "domain": { "id": "default" },
          "password": "adminpwd"
        }
      }
    },
    "scope": {
      "project": {
        "name": "admin",
        "domain": { "id": "default" }
      }
    }
  }
}' \
  "http://localhost:5000/v3/auth/tokens" ; echo
```

Example response: 响应示例：

```
HTTP/1.1 201 Created
X-Subject-Token: MIIFfQ...
Vary: X-Auth-Token
Content-Type: application/json
Content-Length: 3518
Date: Fri, 11 May 2018 03:38:39 GMT

{
  "token": {
      "is_domain": false,
      "methods": [
          "password"
      ],
      "roles": [
          {
              "id": "b57680c826b44b5ca6122d0f792c3184",
              "name": "Member"
          },
          {
              "id": "3a7bd258345f47479a26aea11a6cc2bb",
              "name": "admin"
          }
      ],
      "expires_at": "2018-05-11T04:38:39.000000Z",
      "project": {
          "domain": {
              "id": "default",
              "name": "Default"
          },
          "id": "3a705b9f56bb439381b43c4fe59dccce",
          "name": "admin"
      },
      "catalog": [
          {
              "endpoints": [
                  {
                      "url": "http://localhost/identity",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "30a91932e4e94a8ca4dc145bb1bb6b4b"
                  },
                  {
                      "url": "http://localhost/identity",
                      "interface": "admin",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "94d4768735104c9091f0468e7d31c189"
                  }
              ],
              "type": "identity",
              "id": "09af9253500b41ef976a07322b2fa388",
              "name": "keystone"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/volume/v2/3a705b9f56bb439381b43c4fe59dccce",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "1c4ffe935e7643d99b55938cb12bc38d"
                  }
              ],
              "type": "volumev2",
              "id": "413a44234e1a4c3781d4a3c7a7e4c895",
              "name": "cinderv2"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/image",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "33237fdd1a744d0fb40f9127f21ddad4"
                  }
              ],
              "type": "image",
              "id": "4d473252145546d2aa589605f1e177c7",
              "name": "glance"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/placement",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "1a421e2f97684d3f86ab4d2cc9c86362"
                  }
              ],
              "type": "placement",
              "id": "5dcecbdd4a1d44d0855c560301b27bb5",
              "name": "placement"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/compute/v2.1",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "8e7ea663cc41477c9629cc710bbb1c7d"
                  }
              ],
              "type": "compute",
              "id": "87d49efa8fb64006bdb123d223ddcae2",
              "name": "nova"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/volume/v1/3a705b9f56bb439381b43c4fe59dccce",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "97a2c0ac7e304316a1eb58a3757e6ef8"
                  }
              ],
              "type": "volume",
              "id": "9408080f1970482aa0e38bc2d4ea34b7",
              "name": "cinder"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost:8080/v1/AUTH_3a705b9f56bb439381b43c4fe59dccce",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "d0d823615b0747a9aeca8b83fba105f0"
                  },
                  {
                      "url": "http://localhost:8080",
                      "interface": "admin",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "e4cb86d9232349f091e0a02390deeb79"
                  }
              ],
              "type": "object-store",
              "id": "957ba1fe8b0443f0afe64bfd0858ba5e",
              "name": "swift"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost:9696/",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "aa4a0e61cdc54372967ee9e2298f1d53"
                  }
              ],
              "type": "network",
              "id": "960fbc66bfcb4fa7900023f647fdc3a5",
              "name": "neutron"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/volume/v3/3a705b9f56bb439381b43c4fe59dccce",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "0c38045a91c34d798e0d2008fee7521d"
                  }
              ],
              "type": "volumev3",
              "id": "98adb083914f423d9cb74ad5527e37cb",
              "name": "cinderv3"
          },
          {
              "endpoints": [
                  {
                      "url": "http://localhost/compute/v2/3a705b9f56bb439381b43c4fe59dccce",
                      "interface": "public",
                      "region": "RegionOne",
                      "region_id": "RegionOne",
                      "id": "562e12b9ee9549e8b857218ccf2ae321"
                  }
              ],
              "type": "compute_legacy",
              "id": "a31e688016614430b28cddddf12d7b88",
              "name": "nova_legacy"
          }
      ],
      "user": {
          "password_expires_at": null,
          "domain": {
              "id": "default",
              "name": "Default"
          },
          "id": "9a7e43333cc44ef4b988f05fc3d3a49d",
          "name": "admin"
      },
      "audit_ids": [
          "TbdrnW4MQDq_GPAVN9-JOQ"
      ],
      "issued_at": "2018-05-11T03:38:39.000000Z"
  }
}
```

#### Domain-Scoped 域范围 ¶

Get a domain-scoped token (Note that you’re going to need a role-assignment on the domain first!):
获取域范围的令牌（请注意，首先需要在域上分配角色！

```
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "admin",
          "domain": { "id": "default" },
          "password": "adminpwd"
        }
      }
    },
    "scope": {
      "domain": {
        "id": "default"
      }
    }
  }
}' \
  "http://localhost:5000/v3/auth/tokens" ; echo
```

Example response: 响应示例：

```
HTTP/1.1 201 Created
X-Subject-Token: MIIFNg...
Vary: X-Auth-Token
Content-Type: application/json
Content-Length: 2590
Date: Fri, 11 May 2018 03:37:09 GMT

{
  "token": {
      "domain": {
          "id": "default",
          "name": "Default"
      },
      "methods": [
          "password"
      ],
      "roles": [
          {
              "id": "b57680c826b44b5ca6122d0f792c3184",
              "name": "Member"
          },
          {
              "id": "3a7bd258345f47479a26aea11a6cc2bb",
              "name": "admin"
          }
      ],
      "expires_at": "2018-05-11T04:37:09.000000Z",
      "catalog": [
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost/identity",
                      "region": "RegionOne",
                      "interface": "public",
                      "id": "30a91932e4e94a8ca4dc145bb1bb6b4b"
                  },
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost/identity",
                      "region": "RegionOne",
                      "interface": "admin",
                      "id": "94d4768735104c9091f0468e7d31c189"
                  }
              ],
              "type": "identity",
              "id": "09af9253500b41ef976a07322b2fa388",
              "name": "keystone"
          },
          {
              "endpoints": [],
              "type": "volumev2",
              "id": "413a44234e1a4c3781d4a3c7a7e4c895",
              "name": "cinderv2"
          },
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost/image",
                      "region": "RegionOne",
                      "interface": "public",
                      "id": "33237fdd1a744d0fb40f9127f21ddad4"
                  }
              ],
              "type": "image",
              "id": "4d473252145546d2aa589605f1e177c7",
              "name": "glance"
          },
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost/placement",
                      "region": "RegionOne",
                      "interface": "public",
                      "id": "1a421e2f97684d3f86ab4d2cc9c86362"
                  }
              ],
              "type": "placement",
              "id": "5dcecbdd4a1d44d0855c560301b27bb5",
              "name": "placement"
          },
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost/compute/v2.1",
                      "region": "RegionOne",
                      "interface": "public",
                      "id": "8e7ea663cc41477c9629cc710bbb1c7d"
                  }
              ],
              "type": "compute",
              "id": "87d49efa8fb64006bdb123d223ddcae2",
              "name": "nova"
          },
          {
              "endpoints": [],
              "type": "volume",
              "id": "9408080f1970482aa0e38bc2d4ea34b7",
              "name": "cinder"
          },
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost:8080",
                      "region": "RegionOne",
                      "interface": "admin",
                      "id": "e4cb86d9232349f091e0a02390deeb79"
                  }
              ],
              "type": "object-store",
              "id": "957ba1fe8b0443f0afe64bfd0858ba5e",
              "name": "swift"
          },
          {
              "endpoints": [
                  {
                      "region_id": "RegionOne",
                      "url": "http://localhost:9696/",
                      "region": "RegionOne",
                      "interface": "public",
                      "id": "aa4a0e61cdc54372967ee9e2298f1d53"
                  }
              ],
              "type": "network",
              "id": "960fbc66bfcb4fa7900023f647fdc3a5",
              "name": "neutron"
          },
          {
              "endpoints": [],
              "type": "volumev3",
              "id": "98adb083914f423d9cb74ad5527e37cb",
              "name": "cinderv3"
          },
          {
              "endpoints": [],
              "type": "compute_legacy",
              "id": "a31e688016614430b28cddddf12d7b88",
              "name": "nova_legacy"
          }
      ],
      "user": {
          "password_expires_at": null,
          "domain": {
              "id": "default",
              "name": "Default"
          },
          "id": "9a7e43333cc44ef4b988f05fc3d3a49d",
          "name": "admin"
      },
      "audit_ids": [
          "Sfc8_kywQx-tWNkEVqA1Iw"
      ],
      "issued_at": "2018-05-11T03:37:09.000000Z"
  }
}
```

#### Getting a token from a token 从令牌中获取令牌 ¶

Get a token from a token:
从令牌中获取令牌：

```
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["token"],
      "token": {
        "id": "'$OS_TOKEN'"
      }
    }
  }
}' \
  "http://localhost:5000/v3/auth/tokens" ; echo
```

Example response: 响应示例：

```
HTTP/1.1 201 Created
X-Subject-Token: MIIFxw...
Vary: X-Auth-Token
Content-Type: application/json
Content-Length: 347
Date: Fri, 11 May 2018 03:41:29 GMT

{
  "token": {
      "issued_at": "2018-05-11T03:41:29.000000Z",
      "audit_ids": [
          "zS_C_KROTFeZm-VlG1LjbA",
          "RAjE82q8Rz-Cd50ogCpx3Q"
      ],
      "methods": [
          "token",
          "password"
      ],
      "expires_at": "2018-05-11T04:40:00.000000Z",
      "user": {
          "password_expires_at": null,
          "domain": {
              "id": "default",
              "name": "Default"
          },
          "id": "9a7e43333cc44ef4b988f05fc3d3a49d",
          "name": "admin"
      }
  }
}
```



 

Note 注意



If a scope was included in the request body then this would get a token with the new scope.
如果请求正文中包含范围，则将获得具有新范围的令牌。

#### DELETE /v3/auth/tokens 删除 /v3/auth/tokens ¶

Revoke a token: 吊销令牌：

```
curl -i -X DELETE \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "X-Subject-Token: $OS_TOKEN" \
  "http://localhost:5000/v3/auth/tokens"
```

If there’s no error then the response is empty.
如果没有错误，则响应为空。

### Domains 域 ¶

#### GET /v3/domains GET /v3/域 ¶

List domains: 列出域：

```
curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  "http://localhost:5000/v3/domains" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "domains": [
        {
            "description": "Owns users and tenants (i.e. projects) available on Identity API v2.",
            "enabled": true,
            "id": "default",
            "links": {
                "self": "http://identity-server:5000/v3/domains/default"
            },
            "name": "Default"
        }
    ],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://identity-server:5000/v3/domains"
    }
}
```

#### POST /v3/domains POST /v3/域 ¶

Create a domain: 创建域：

```
curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "domain": { "name": "newdomain"}}' \
  "http://localhost:5000/v3/domains" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "domain": {
        "enabled": true,
        "id": "3a5140aecd974bf08041328b53a62458",
        "links": {
            "self": "http://identity-server:5000/v3/domains/3a5140aecd974bf08041328b53a62458"
        },
        "name": "newdomain"
    }
}
```

### Projects 项目 ¶

#### GET /v3/projects 获取 /v3/projects ¶

List projects: 列出项目：

```
curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "http://localhost:5000/v3/projects" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/projects"
    },
    "projects": [
        {
            "description": null,
            "domain_id": "default",
            "enabled": true,
            "id": "3d4c2c82bd5948f0bcab0cf3a7c9b48c",
            "links": {
                "self": "http://localhost:5000/v3/projects/3d4c2c82bd5948f0bcab0cf3a7c9b48c"
            },
            "name": "demo"
        }
    ]
}
```

#### PATCH /v3/projects/{id} 补丁 /v3/projects/{id} ¶

Disable a project: 禁用项目：

```
curl -s -X PATCH \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
  "project": {
      "enabled": false
    }
}'\
  "http://localhost:5000/v3/projects/$PROJECT_ID"  | python -mjson.tool
```

Example response: 响应示例：

```
{
    "project": {
        "description": null,
        "domain_id": "default",
        "enabled": false,
        "extra": {},
        "id": "3d4c2c82bd5948f0bcab0cf3a7c9b48c",
        "links": {
            "self": "http://localhost:5000/v3/projects/3d4c2c82bd5948f0bcab0cf3a7c9b48c"
        },
        "name": "demo"
    }
}
```

### GET /v3/services 获取 /v3/services ¶

List the services: 列出服务：

```
curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  "http://localhost:5000/v3/services" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/services"
    },
    "services": [
        {
            "description": "Keystone Identity Service",
            "enabled": true,
            "id": "bd7397d2c0e14fb69bae8ff76e112a90",
            "links": {
                "self": "http://localhost:5000/v3/services/bd7397d2c0e14fb69bae8ff76e112a90"
            },
            "name": "keystone",
            "type": "identity"
        }
    ]
}
```

### GET /v3/endpoints GET /v3/端点 ¶

List the endpoints: 列出终结点：

```
curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "http://localhost:5000/v3/endpoints" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "endpoints": [
        {
            "enabled": true,
            "id": "29beb2f1567642eb810b042b6719ea88",
            "interface": "admin",
            "links": {
                "self": "http://localhost:5000/v3/endpoints/29beb2f1567642eb810b042b6719ea88"
            },
            "region": "RegionOne",
            "service_id": "bd7397d2c0e14fb69bae8ff76e112a90",
            "url": "http://localhost:5000/v3"
        }
    ],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/endpoints"
    }
}
```

### Users 用户 ¶

#### GET /v3/users 获取 /v3/users ¶

List users: 列出用户：

```
curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "http://localhost:5000/v3/users" | python -mjson.tool
```

#### POST /v3/users POST /v3/用户 ¶

Create a user: 创建用户：

```
curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"user": {"name": "newuser", "password": "changeme"}}' \
 "http://localhost:5000/v3/users" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "user": {
        "domain_id": "default",
        "enabled": true,
        "id": "ec8fc20605354edd91873f2d66bf4fc4",
        "links": {
            "self": "http://identity-server:5000/v3/users/ec8fc20605354edd91873f2d66bf4fc4"
        },
        "name": "newuser"
    }
}
```

#### GET /v3/users/{user_id} 获取 /v3/users/{user_id} ¶

Show details for a user:
显示用户的详细信息：

```
USER_ID=ec8fc20605354edd91873f2d66bf4fc4

curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "http://localhost:5000/v3/users/$USER_ID" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "user": {
        "domain_id": "default",
        "enabled": true,
        "id": "ec8fc20605354edd91873f2d66bf4fc4",
        "links": {
            "self": "http://localhost:5000/v3/users/ec8fc20605354edd91873f2d66bf4fc4"
        },
        "name": "newuser"
    }
}
```

#### POST /v3/users/{user_id}/password

Change password (using the default policy, this can be done as the user):
更改密码（使用默认策略，可以以用户身份完成此操作）：

```
USER_ID=b7793000f8d84c79af4e215e9da78654
ORIG_PASS=userpwd
NEW_PASS=newuserpwd

curl \
 -H "X-Auth-Token: $OS_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{ "user": {"password": "'$NEW_PASS'", "original_password": "'$ORIG_PASS'"} }' \
 "http://localhost:5000/v3/users/$USER_ID/password"
```



 

Note 注意



This command doesn’t print anything if the request was successful.
如果请求成功，此命令不会打印任何内容。

#### PATCH /v3/users/{user_id} 补丁 /v3/users/{user_id} ¶

Reset password (using the default policy, this requires admin):
重置密码（使用默认策略，这需要管理员）：

```
USER_ID=b7793000f8d84c79af4e215e9da78654
NEW_PASS=newuserpwd

curl -s -X PATCH \
 -H "X-Auth-Token: $OS_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{ "user": {"password": "'$NEW_PASS'"} }' \
 "http://localhost:5000/v3/users/$USER_ID" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "user": {
        "default_project_id": "3d4c2c82bd5948f0bcab0cf3a7c9b48c",
        "domain_id": "default",
        "email": "demo@example.com",
        "enabled": true,
        "extra": {
            "email": "demo@example.com"
        },
        "id": "269348fdd9374b8885da1418e0730af1",
        "links": {
            "self": "http://localhost:5000/v3/users/269348fdd9374b8885da1418e0730af1"
        },
        "name": "demo"
    }
}
```

### PUT /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}

Create group role assignment on project:
在项目上创建组角色分配：

```
curl -s -X PUT \
 -H "X-Auth-Token: $OS_TOKEN" \
 "http://localhost:5000/v3/projects/$PROJECT_ID/groups/$GROUP_ID/roles/$ROLE_ID" |
   python -mjson.tool
```

There’s no data in the response if the operation is successful.
如果操作成功，响应中没有数据。

### POST /v3/OS-TRUST/trusts

Create a trust: 创建信任：

```
curl -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 -H "Content-Type: application/json" \
 -d '
{ "trust": {
    "expires_at": "2014-12-30T23:59:59.999999Z",
    "impersonation": false,
    "project_id": "'$PROJECT_ID'",
    "roles": [
        { "name": "admin" }
      ],
    "trustee_user_id": "'$DEMO_USER_ID'",
    "trustor_user_id": "'$ADMIN_USER_ID'"
}}'\
 "http://localhost:5000/v3/OS-TRUST/trusts" | python -mjson.tool
```

Example response: 响应示例：

```
{
    "trust": {
        "expires_at": "2014-12-30T23:59:59.999999Z",
        "id": "394998fa61f14736b1f0c1f322882949",
        "impersonation": false,
        "links": {
            "self": "http://localhost:5000/v3/OS-TRUST/trusts/394998fa61f14736b1f0c1f322882949"
        },
        "project_id": "3d4c2c82bd5948f0bcab0cf3a7c9b48c",
        "remaining_uses": null,
        "roles": [
            {
                "id": "c703057be878458588961ce9a0ce686b",
                "links": {
                    "self": "http://localhost:5000/v3/roles/c703057be878458588961ce9a0ce686b"
                },
                "name": "admin"
            }
        ],
        "roles_links": {
            "next": null,
            "previous": null,
            "self": "http://localhost:5000/v3/OS-TRUST/trusts/394998fa61f14736b1f0c1f322882949/roles"
        },
        "trustee_user_id": "269348fdd9374b8885da1418e0730af1",
        "trustor_user_id": "3ec3164f750146be97f21559ee4d9c51"
    }
}
```

​                      

# Multi-Factor Authentication 多重身份验证

​                                          



## Configuring MFA 配置 MFA ¶

Configuring MFA right now has to be done entirely by an admin, for how to do that, see [Multi-Factor Authentication](https://docs.openstack.org/keystone/latest/admin/multi-factor-authentication.html#multi-factor-authentication).
现在配置 MFA 必须完全由管理员完成，有关如何执行此操作，请参阅多重身份验证。

## Using MFA 使用 MFA ¶

Multi-Factor Authentication with Keystone can be used in two ways, either you treat it like current single method authentication and provide all the details upfront, or you doing it as a multi-step process with auth receipts.
Keystone 的多重身份验证可以通过两种方式使用，您可以将其视为当前的单一方法身份验证并预先提供所有详细信息，或者将其视为带有身份验证收据的多步骤过程。

### Single step 单步 ¶

In the single step approach you would supply all the required authentication methods in your request for a token.
在单步方法中，您将在令牌请求中提供所有必需的身份验证方法。

Here is an example using 2 factors (`password` and `totp`):
下面是一个使用 2 个因素（ `password` 和 `totp` ）的示例：

```
{ "auth": {
        "identity": {
            "methods": [
                "password",
                "totp"
            ],
            "totp": {
                "user": {
                    "id": "2ed179c6af12496cafa1d279cb51a78f",
                    "passcode": "012345"
                }
            },
            "password": {
                "user": {
                    "id": "2ed179c6af12496cafa1d279cb51a78f",
                    "password": "super sekret pa55word"
                }
            }
        }
    }
}
```

If all the supplied auth methods are valid, Keystone will return a token.
如果提供的所有身份验证方法都有效，Keystone 将返回一个令牌。

### Multi-Step 多步骤 ¶

In the multi-step approach you can supply any one method from the auth rules:
在多步骤方法中，您可以从身份验证规则中提供任何一个方法：

Again we do a 2 factor example, starting with `password`:
我们再次做一个 2 因素示例，从以下开始 `password` ：

```
{ "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "id": "2ed179c6af12496cafa1d279cb51a78f",
                    "password": "super sekret pa55word"
                }
            }
        }
    }
}
```

Provided the method is valid, Keystone will still return a `401`, but will in the response header `Openstack-Auth-Receipt` return a receipt of valid auth method for reuse later.
如果该方法有效，Keystone 仍将返回 `401` ，但会在响应标头 `Openstack-Auth-Receipt` 中返回有效身份验证方法的收据，以便稍后重用。

The response body will also contain information about the auth receipt, and what auth methods may be missing:
响应正文还将包含有关身份验证收据的信息，以及可能缺少哪些身份验证方法：

```
{
    "receipt":{
        "expires_at":"2018-07-05T08:39:23.000000Z",
        "issued_at":"2018-07-05T08:34:23.000000Z",
        "methods": [
            "password"
        ],
        "user": {
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "ee4dfb6e5540447cb3741905149d9b6e",
            "name": "admin"
        }
    },
    "required_auth_methods": [
        ["totp", "password"]
    ]
}
```

Now you can continue authenticating by supplying the missing auth methods, and supplying the header `Openstack-Auth-Receipt` as gotten from the previous response:
现在，您可以通过提供缺少的身份验证方法，并提供从上一个响应中获取的标头 `Openstack-Auth-Receipt` 来继续进行身份验证：

```
{ "auth": {
        "identity": {
            "methods": [
                "totp"
            ],
            "totp": {
                "user": {
                    "id": "2ed179c6af12496cafa1d279cb51a78f",
                    "passcode": "012345"
                }
            }
        }
    }
}
```

Provided the auth methods are valid, Keystone will now supply a token. If not you can try again until the auth receipt expires (e.g in case of TOTP timeout).
如果身份验证方法有效，Keystone 现在将提供令牌。如果没有，您可以重试，直到身份验证回执过期（例如，在 TOTP 超时的情况下）。
