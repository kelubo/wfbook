# Etckeeper Etckeeper （英语）

[etckeeper](https://etckeeper.branchable.com/) allows the contents of `/etc` to be stored in a Version Control System (VCS) repository. It integrates with APT and automatically commits changes to `/etc` when packages are installed or upgraded.
etckeeper 允许将内容 `/etc` 存储在版本控制系统 （VCS） 存储库中。它与 APT 集成，并在安装或升级软件包 `/etc` 时自动提交更改。

Placing `/etc` under version control is considered an industry best practice, and the  goal of etckeeper is to make this process as painless as possible.
将版本控制置于 `/etc` 行业最佳实践之下被认为是一种行业最佳实践，etckeeper 的目标是使这个过程尽可能轻松。

## Install etckeeper 安装 etckeeper

Install etckeeper by entering the following in a terminal:
通过在终端中输入以下内容来安装 etckeeper：

```bash
sudo apt install etckeeper
```

## Initialise etckeeper 初始化 etckeeper

The main configuration file, `/etc/etckeeper/etckeeper.conf`, is fairly simple. The main option defines which VCS to use, and by default etckeeper is configured to use git.
主配置文件 `/etc/etckeeper/etckeeper.conf` ，相当简单。main 选项定义要使用的 VCS，默认情况下，etckeeper 配置为使用 git。

The repository is automatically initialised (and committed for the first  time) during package installation. It is possible to undo this by  entering the following command:
存储库在软件包安装期间自动初始化（并首次提交）。可以通过输入以下命令来撤消此操作：

```bash
sudo etckeeper uninit
```

## Configure autocommit frequency 配置自动提交频率

By default, etckeeper will commit uncommitted changes made to `/etc` on a daily basis. This can be disabled using the `AVOID_DAILY_AUTOCOMMITS` configuration option.
默认情况下，etckeeper 将每天提交未 `/etc` 提交的更改。可以使用 `AVOID_DAILY_AUTOCOMMITS` 配置选项禁用此功能。

It will also automatically commit changes before and after package  installation. For a more precise tracking of changes, it is recommended  to commit your changes manually, together with a commit message, using:
它还将在软件包安装之前和之后自动提交更改。为了更精确地跟踪更改，建议使用以下命令手动提交更改，并附上提交消息：

```bash
sudo etckeeper commit "Reason for configuration change"
```

The `vcs` etckeeper command provides access to any subcommand of the VCS that etckeeper is configured to run. It will be run in `/etc`. For example, in the case of git:
etckeeper `vcs` 命令提供对 etckeeper 配置为运行的 VCS 的任何子命令的访问。它将在 `/etc` 中运行。例如，在 git 的情况下：

```bash
sudo etckeeper vcs log /etc/passwd
```

To demonstrate the integration with the package management system (APT), install `postfix`:
要演示与包管理系统 （APT） 的集成，请安装 `postfix` ：

```bash
sudo apt install postfix
```

When the installation is finished, all the `postfix` configuration files should be committed to the repository:
安装完成后，所有 `postfix` 配置文件都应提交到存储库：

```plaintext
[master 5a16a0d] committing changes in /etc made by "apt install postfix"
 Author: Your Name <xyz@example.com>
 36 files changed, 2987 insertions(+), 4 deletions(-)
 create mode 100755 init.d/postfix
 create mode 100644 insserv.conf.d/postfix
 create mode 100755 network/if-down.d/postfix
 create mode 100755 network/if-up.d/postfix
 create mode 100644 postfix/dynamicmaps.cf
 create mode 100644 postfix/main.cf
 create mode 100644 postfix/main.cf.proto
 create mode 120000 postfix/makedefs.out
 create mode 100644 postfix/master.cf
 create mode 100644 postfix/master.cf.proto
 create mode 100755 postfix/post-install
 create mode 100644 postfix/postfix-files
 create mode 100755 postfix/postfix-script
 create mode 100755 ppp/ip-down.d/postfix
 create mode 100755 ppp/ip-up.d/postfix
 create mode 120000 rc0.d/K01postfix
 create mode 120000 rc1.d/K01postfix
 create mode 120000 rc2.d/S01postfix
 create mode 120000 rc3.d/S01postfix
 create mode 120000 rc4.d/S01postfix
 create mode 120000 rc5.d/S01postfix
     create mode 120000 rc6.d/K01postfix
     create mode 100755 resolvconf/update-libc.d/postfix
     create mode 100644 rsyslog.d/postfix.conf
     create mode 120000 systemd/system/multi-user.target.wants/postfix.service
     create mode 100644 ufw/applications.d/postfix
```

For an example of how `etckeeper` tracks manual changes, add new a host to `/etc/hosts`. Using git you can see which files have been modified:
有关如何 `etckeeper` 跟踪手动更改的示例，请将 new 主机添加到 `/etc/hosts` 。使用 git，您可以查看哪些文件已被修改：

```bash
sudo etckeeper vcs status
```

and how: 以及如何：

```bash
sudo etckeeper vcs diff
```

If you are happy with the changes you can now commit them:
如果您对更改感到满意，现在可以提交它们：

```bash
sudo etckeeper commit "added new host"
```

## Resources 资源

- See the [etckeeper](https://etckeeper.branchable.com/) site for more details on using etckeeper.
  有关使用 etckeeper 的更多详细信息，请参见 etckeeper 网站。
- For documentation on the git VCS tool see [the Git website](https://git-scm.com/).
  有关 git VCS 工具的文档，请参阅 Git 网站。

------