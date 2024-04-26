# How to install and configure gitolite 如何安装和配置 gitolite

Gitolite provides a traditional source control management server for git, with multiple users and access rights management.
Gitolite 为 git 提供了一个传统的源代码控制管理服务器，具有多个用户和访问权限管理。

## Install a gitolite server 安装 gitolite 服务器

Gitolite can be installed with the following command:
可以使用以下命令安装 Gitolite：

```bash
sudo apt install gitolite3
```

## Configure gitolite 配置 gitolite

Configuration of the gitolite server is a little different that most other servers on Unix-like systems, in that gitolite stores its configuration in a git  repository rather than in files in `/etc/`. The first step to configuring a new installation is to allow access to the configuration repository.
gitolite 服务器的配置与类 Unix 系统上的大多数其他服务器略有不同，因为 gitolite 将其配置存储在 git 存储库中，而不是存储在 中的 `/etc/` 文件中。配置新安装的第一步是允许访问配置存储库。

First of all, let’s create a user for gitolite to use for the service:
首先，让我们为 gitolite 创建一个用户以用于该服务：

```bash
sudo adduser --system --shell /bin/bash --group --disabled-password --home /home/git git
```

Now we want to let gitolite know about the repository administrator’s  public SSH key. This assumes that the current user is the repository  administrator. If you have not yet configured an SSH key, refer to the  section on [SSH keys in our OpenSSH guide](https://ubuntu.com/server/docs/openssh-server#ssh-keys-4).
现在，我们想让 gitolite 知道存储库管理员的公共 SSH 密钥。这假定当前用户是存储库管理员。如果您尚未配置 SSH 密钥，请参阅我们的 OpenSSH 指南中有关 SSH 密钥的部分。

```bash
cp ~/.ssh/id_rsa.pub /tmp/$(whoami).pub
```

Let’s switch to the git user and import the administrator’s key into gitolite.
让我们切换到 git 用户并将管理员的密钥导入 gitolite。

```bash
sudo su - git
gl-setup /tmp/*.pub
```

Gitolite will allow you to make initial changes to its configuration file during the setup process. You can now clone and modify the gitolite  configuration repository from your administrator user (the user whose  public SSH key you imported). Switch back to that user, then clone the  configuration repository:
Gitolite 将允许您在设置过程中对其配置文件进行初始更改。现在，您可以从管理员用户（导入其公有 SSH 密钥的用户）克隆和修改 gitolite 配置存储库。切换回该用户，然后克隆配置存储库：

```bash
exit
git clone git@$IP_ADDRESS:gitolite-admin.git
cd gitolite-admin
```

The `gitolite-admin` contains two subdirectories:
包含 `gitolite-admin` 两个子目录：

- **`conf`** : contains the configuration files
   `conf` ：包含配置文件
- **`keydir`** : contains the list of user’s public SSH keys
   `keydir` ：包含用户的公有 SSH 密钥列表

## Managing gitolite users and repositories 管理 gitolite 用户和存储库

Adding a new user to gitolite is simple: just obtain their public SSH key and add it to the `keydir` directory as `$DESIRED_USER_NAME.pub`. Note that the gitolite usernames don’t have to match the system  usernames - they are only used in the gitolite configuration file to  manage access control.
将新用户添加到 gitolite 很简单：只需获取他们的公有 SSH 密钥并将其作为 `keydir` `$DESIRED_USER_NAME.pub` .请注意，gitolite 用户名不必与系统用户名匹配 - 它们仅在 gitolite 配置文件中用于管理访问控制。

Similarly, users are deleted by deleting their public key files. After each  change, do not forget to commit the changes to git, and push the changes back to the server with:
同样，通过删除用户的公钥文件来删除用户。每次更改后，不要忘记将更改提交到 git，并使用以下命令将更改推送回服务器：

```bash
git commit -a
git push origin master
```

Repositories are managed by editing the `conf/gitolite.conf` file. The syntax is space-separated, and specifies the list of  repositories followed by some access rules. The following is a default  example:
存储库通过编辑 `conf/gitolite.conf` 文件进行管理。语法是以空格分隔的，并指定存储库列表，后跟一些访问规则。以下是默认示例：

```plaintext
repo    gitolite-admin
        RW+     =   admin
        R       =   alice
    
repo    project1
        RW+     =   alice
        RW      =   bob
        R       =   denise
```

## Using your server 使用服务器

Once a user’s public key has been imported by the gitolite admin, granting  the user authorisation to use one or more repositories, the user can  access those repositories with the following command:
一旦 gitolite 管理员导入了用户的公钥，授予用户使用一个或多个存储库的权限，用户就可以使用以下命令访问这些存储库：

```bash
git clone git@$SERVER_IP:$PROJECT_NAME.git
```

To add the server as a new remote for an existing git repository:
要将服务器添加为现有 git 存储库的新远程，请执行以下操作：

```bash
git remote add gitolite git@$SERVER_IP:$PROJECT_NAME.git
```

## Further reading 延伸阅读

- [Gitolite’s code repository](https://github.com/sitaramc/gitolite) provides access to source code
  Gitolite 的代码存储库提供对源代码的访问
- [Gitolite’s documentation](https://gitolite.com/gitolite/) includes a “fool-proof setup” guide and a cookbook with recipes for common tasks
  Gitolite 的文档包括一个“万无一失的设置”指南和一本包含常见任务食谱的食谱
- Gitolite’s maintainer has written a book, [Gitolite Essentials](https://www.packtpub.com/hardware-and-creative/gitolite-essentials), for more in-depth information about the software
  Gitolite 的维护者写了一本书 Gitolite Essentials，以获取有关该软件的更深入信息
- General information about git itself can be found at the [Git homepage](http://git-scm.com)
  有关 git 本身的一般信息可以在 Git 主页上找到