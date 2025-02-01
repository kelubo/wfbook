# 支持的客户端

[TOC]

[python-keystoneclient](https://docs.openstack.org/python-keystoneclient/latest) project provides python bindings and [python-openstackclient](https://docs.openstack.org/python-openstackclient/latest) provides a command line interface.
有两个受支持的客户端，python-keystoneclient 项目提供 python 绑定，python-openstackclient 提供命令行界面。

## 通过 CLI 使用密码进行身份验证

要使用密码和 `python-openstackclient` 进行 keystone 身份验证，请设置以下标志，note that the following user referenced below should be granted the `admin` role.请注意，应向下面引用的以下用户授予该 `admin` 角色。

- `--os-username OS_USERNAME`: 用户名
- `--os-user-domain-name OS_USER_DOMAIN_NAME`: 用户域的名称
- `--os-password OS_PASSWORD`: 用户的密码
- `--os-project-name OS_PROJECT_NAME`: 项目名称
- `--os-project-domain-name OS_PROJECT_DOMAIN_NAME`: Name of the project’s domain项目域的名称
- `--os-auth-url OS_AUTH_URL`: keystone 认证服务器的 URL
- `--os-identity-api-version OS_IDENTITY_API_VERSION`: 这应始终设置为 3

还可以在环境中设置这些变量，以便它们不需要每次都作为参数传递：

```bash
$ export OS_USERNAME=my_username
$ export OS_USER_DOMAIN_NAME=my_user_domain
$ export OS_PASSWORD=my_password
$ export OS_PROJECT_NAME=my_project
$ export OS_PROJECT_DOMAIN_NAME=my_project_domain
$ export OS_AUTH_URL=http://localhost:5000/v3
$ export OS_IDENTITY_API_VERSION=3
```

例如，命令 `user list` 、 `token issue` 和 `project create` 可以按如下方式调用：

```bash
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

