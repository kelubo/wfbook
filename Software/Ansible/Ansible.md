# Ansible
配置管理系统。
## 安装要求
支持SSH
Python 2.6

## 安装
### 从源码安装

    $ git clone git://github.com/ansible/ansible.git --recursive
    $ cd ./ansible
    $ source ./hacking/env-setup
    $ sudo easy_install pip  //如果未安装pip，执行此命令
    $ sudo pip install paramiko PyYAML Jinja2 httplib2

### YUM安装

    # yum install ansible

### Apt(Ubuntu)安装

    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get update
    $ sudo apt-get install ansible

### Portage(Gentoo)安装

    $ emerge -av app-admin/ansible

### pkg(FreeBSD)安装

    $ sudo pkg install ansible

### Homebrew(Mac OS X)安装

    $ brew update
    $ brew install ansible

### Pip安装

    $ sudo pip install ansible

## 清单
Ansible 使用清单文件来了解要使用的服务器，以及如何将它们分组以并行执行任务。

        [all:children]
        webs
        db
        [all:vars]
        ansible_user=vagrant
        ansible_ssh_pass=vagrant
        [webs]
        web1 ansible_host=10.1.1.11
        web2 ansible_host=10.1.1.12
        [db]
        dbserver ansible_host=10.1.1.21
    
        [all：children] 定义一个组的组（all）
        [all：vars] 定义属于组 all 的变量
        [webs] 定义一个组，就像 [db] 一样
        文件的其余部分只是主机的声明，带有它们的名称和 IP
        空行表示声明结束
    
    现在我们有了一个清单，我们可以从命令行开始使用 ansible，指定一个主机或一个组来执行命令。以下是检查与服务器的连接的命令示例：
    
        $ ansible -i inventory all -m ping
    
        -i 指定清单文件
        all 指定要操作的服务器或服务器组
        -m' 指定一个 ansible 模块，在这种情况下为ping`
    
    下面是命令输出：
    
        dbserver | SUCCESS => {
            "changed": false,
            "ping": "pong"
        }
        web1 | SUCCESS => {
            "changed": false,
            "ping": "pong"
        }
        web2 | SUCCESS => {
            "changed": false,
            "ping": "pong"
        }
    
    服务器以不同的顺序响应，这只取决于谁先响应，但是这个没有关系，因为 ansible 独立保持每台服务器的状态。
    
    你也可以使用另外一个选项来运行任何命令：
    
        -a <command>
    
        $ ansible -i inventory all -a uptime
        web1 | SUCCESS | rc=0 >>
         21:43:27 up 25 min,  1 user,  load average: 0.00, 0.01, 0.05
        dbserver | SUCCESS | rc=0 >>
         21:43:27 up 24 min,  1 user,  load average: 0.00, 0.01, 0.05
        web2 | SUCCESS | rc=0 >>
         21:43:27 up 25 min,  1 user,  load average: 0.00, 0.01, 0.05
    
    这是只有一台服务器的另外一个例子：
    
        $ ansible -i inventory dbserver -a "df -h /"
        dbserver | SUCCESS | rc=0 >>
        Filesystem      Size  Used Avail Use% Mounted on
        /dev/sda1        40G  1.4G   37G   4% /
    
    剧本
    
    剧本（playbook）只是个 YAML 文件，它将清单文件中的服务器组与命令关联。在 ansible 中的对于关键字是 tasks，它可以是一个预期的状态、shell 命令或许多其它的选项。有关 ansible 可做的所有事情列表，可以查看所有模块的列表。
    
    下面是一个运行 shell 命令的剧本示例，将其保存为 playbook1.yml：
    
        ---
        - hosts: all
          tasks:
            - shell: uptime
    
        --- 是 YAML 文件的开始
        - hosts：指定要使用的组
        tasks：标记任务列表的开始
        - shell：指定第一个任务使用 shell 模块
        记住：YAML 需要缩进结构，确保你始终遵循剧本中的正确结构
    
    用下面的命令运行它：
    
        $ ansible-playbook -i inventory playbook1.yml
        PLAY [all] *********************************************************************
        TASK [setup] *******************************************************************
        ok: [web1]
        ok: [web2]
        ok: [dbmaster]
        TASK [command] *****************************************************************
        changed: [web1]
        changed: [web2]
        changed: [dbmaster]
        PLAY RECAP *********************************************************************
        dbmaster                   : ok=2    changed=1    unreachable=0    failed=0
        web1                       : ok=2    changed=1    unreachable=0    failed=0
        web2                       : ok=2    changed=1    unreachable=0    failed=0
    
    正如你所见，ansible 运行了 2 个任务，而不是只有剧本中的一个。TASK [setup] 是一个隐式任务，它会首先运行以捕获服务器的信息，如主机名、IP、发行版和更多详细信息，然后可以使用这些信息运行条件任务。
    
    还有最后的 PLAY RECAP，其中 ansible 显示了运行了多少个任务以及每个对应的状态。在我们的例子中，因为我们运行了一个 shell 命令，ansible 不知道结果的状态，它被认为是 changed。
    安装软件
    
    我们将使用 apt 在我们的服务器上安装软件，因为我们需要 root 权限，所以我们必须使用 become 语句，将这个内容保存在 playbook2.yml 中并运行它（ansible-playbook playbook2.yml）：
    
        ---
        - hosts: webs
          become_user: root
          become: true
          tasks:
            - apt: name=git state=present
    
    有一些语句可以应用于 ansible 中所有模块；一个是 name 语句，可以让我们输出关于正在执行的任务的更具描述性的文本。要使用它，保持任务内容一样，但是添加 name ：描述性文本 作为第一行，所以我们以前的文本将改成：
    
        ---
        - hosts: webs
          become_user: root
          become: true
          tasks:
            - name: This task will make sure git is present on the system
              apt: name=git state=present
    
    使用 with_items
    
    当你要处理一个列表时，比如要安装的项目和软件包、要创建的文件，可以用 ansible 提供的 with_items。下面是我们如何在 playbook3.yml 中使用它，同时添加一些我们已经知道的其他语句：
    
        ---
        - hosts: all
          become_user: root
          become: true
          tasks:
            - name: Installing dependencies
              apt: name={{item}} state=present
              with_items:
                - git
                - mysql-client
                - libmysqlclient-dev
                - build-essential
                - python-software-properties
    
    使用 template 和 vars
    
    vars 是一个定义变量语句，可以在 task 语句或 template 文件中使用。 Jinja2 是 Ansible 中使用的模板引擎，但是关于它你不需要学习很多。在你的剧本中定义变量，如下所示：
    
        ---
        - hosts: all
          vars:
            - secret_key: VqnzCLdCV9a3jK
            - path_to_vault: /opt/very/deep/path
          tasks:
            - name: Setting a configuration file using template
              template: src=myconfig.j2 dest={{path_to_vault}}/app.conf
    
    正如你看到的，我可以使用 {{path_to_vault}} 作为剧本的一部分，但也因为我使用了 template语句，我可以使用 myconfig.j2 中的任何变量，该文件必须存在一个名为 templates 的子文件夹中。你项目树应该如下所示：
    
        ├── Vagrantfile
        ├── inventory
        ├── playbook1.yml
        ├── playbook2.yml
        └── templates
            └── myconfig.j2
    
    当 ansible 找到一个 template 语句后它会在 templates 文件夹内查找，并将把被 {{ 和 }} 括起来的变量展开来。
    
    示例模板：
    
        this is just an example vault_dir: {{path_to_vault}} secret_password: {{secret_key}}
    
    即使你不扩展变量你也可以使用 template。考虑到将来会添加所以我先做了。比如创建一个 hosts.j2 模板并加入主机名和 IP。
    
        10.1.1.11 web1
        10.1.1.12 web2
        10.1.1.21 dbserver
    
    这里要用像这样的语句：
    
          -  name: Installing the hosts file in all servers
             template: src=hosts.j2 dest=/etc/hosts mode=644
    
    shell 命令
    
    你应该尽量使用模块，因为 Ansible 可以跟踪任务的状态，并避免不必要的重复，但有时 shell 命令是不可避免的。 对于这些情况，Ansible 提供两个选项：
    
        command：直接运行一个命令，没有环境变量或重定向（|，<，> 等）
        shell：运行 /bin/sh 并展开变量和支持重定向
    
    其他有用的模块
    
        apt_repository - 在 Debian 系的发行版中添加/删除包仓库
        yum_repository - 在 RedHat 系的发行版中添加/删除包仓库
        service - 启动/停止/重新启动/启用/禁用服务
        git - 从 git 服务器部署代码
        unarchive - 从 Web 或本地源解开软件包
    
    只在一台服务器中运行任务
    
    Rails 使用 migrations 来逐步更改数据库，但由于你有多个应用程序服务器，因此这些迁移任务不能被分配为组任务，而我们只需要一个服务器来运行迁移。在这种情况下，当使用 run_once 时，run_once 将分派任务到一个服务器，并直到这个任务完成继续下一个任务。你只需要在你的任务中设置 run_once：true。
    
            - name: 'Run db:migrate'
              shell: cd {{appdir}};rails db:migrate
              run_once: true
    
    会失败的任务
    
    通过指定 ignore_errors：true，你可以运行可能会失败的任务，但不会影响剧本中剩余的任务完成。这是非常有用的，例如，当删除最初并不存在的日志文件时。
    
            - name: 'Delete logs'
              shell: rm -f /var/log/nginx/errors.log
              ignore_errors: true
    
    放到一起
    
    现在用我们先前学到的，这里是每个文件的最终版：
    
    Vagrantfile：
    
        VMs = [
            [ "web1", "10.1.1.11"],
            [ "web2", "10.1.1.12"],
            [ "dbserver", "10.1.1.21"],
          ]
        Vagrant.configure(2) do |config|
          VMs.each { |vm|
            config.vm.define vm[0] do |box|
              box.vm.box = "ubuntu/trusty64"
              box.vm.network "private_network", ip: vm[1]
              box.vm.hostname = vm[0]
              box.vm.provider "virtualbox" do |vb|
                 vb.memory = "512"
              end
            end
          }
        end
    
    inventory：
    
        [all:children]
        webs
        db
        [all:vars]
        ansible_user=vagrant
        ansible_ssh_pass=vagrant
        [webs]
        web1 ansible_host=10.1.1.11
        web2 ansible_host=10.1.1.12
        [db]
        dbserver ansible_host=10.1.1.21
    
    templates/hosts.j2:
    
        10.1.1.11 web1
        10.1.1.12 web2
        10.1.1.21 dbserver
    
    templates/my.cnf.j2：
    
        [client]
        port        = 3306
        socket      = /var/run/mysqld/mysqld.sock
        [mysqld_safe]
        socket      = /var/run/mysqld/mysqld.sock
        nice        = 0
        [mysqld]
        server-id   = 1
        user        = mysql
        pid-file    = /var/run/mysqld/mysqld.pid
        socket      = /var/run/mysqld/mysqld.sock
        port        = 3306
        basedir     = /usr
        datadir     = /var/lib/mysql
        tmpdir      = /tmp
        lc-messages-dir = /usr/share/mysql
        skip-external-locking
        bind-address        = 0.0.0.0
        key_buffer      = 16M
        max_allowed_packet  = 16M
        thread_stack        = 192K
        thread_cache_size       = 8
        myisam-recover         = BACKUP
        query_cache_limit   = 1M
        query_cache_size        = 16M
        log_error = /var/log/mysql/error.log
        expire_logs_days    = 10
        max_binlog_size         = 100M
        [mysqldump]
        quick
        quote-names
        max_allowed_packet  = 16M
        [mysql]
        [isamchk]
        key_buffer      = 16M
        !includedir /etc/mysql/conf.d/
    
    final-playbook.yml：
    
        - hosts: all
          become_user: root
          become: true
          tasks:
            - name: 'Install common software on all servers'
              apt: name={{item}} state=present
              with_items:
                - git
                - mysql-client
                - libmysqlclient-dev
                - build-essential
                - python-software-properties
            - name: 'Install hosts file'
              template: src=hosts.j2 dest=/etc/hosts mode=644
        - hosts: db
          become_user: root
          become: true
          tasks:
            - name: 'Software for DB server'
              apt: name={{item}} state=present
              with_items:
                - mysql-server
                - percona-xtrabackup
                - mytop
                - mysql-utilities
            - name: 'MySQL config file'
              template: src=my.cnf.j2 dest=/etc/mysql/my.cnf
            - name: 'Restart MySQL'
              service: name=mysql state=restarted
            - name: 'Grant access to web app servers'
              shell: echo 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;FLUSH PRIVILEGES;'|mysql -u root mysql
        - hosts: webs
          vars:
            - appdir: /opt/dummyapp
          become_user: root
          become: true
          tasks:
            - name: 'Add ruby-ng repo'
              apt_repository: repo='ppa:brightbox/ruby-ng'
            - name: 'Install rails software'
              apt: name={{item}} state=present
              with_items:
                - ruby-dev
                - ruby-all-dev
                - ruby2.2
                - ruby2.2-dev
                - ruby-switch
                - libcurl4-openssl-dev
                - libssl-dev
                - zlib1g-dev
                - nodejs
            - name: 'Set ruby to 2.2'
              shell: ruby-switch --set ruby2.2
            - name: 'Install gems'
              shell: gem install bundler rails
            - name: 'Kill puma if running'
              shell: file /run/puma.pid >/dev/null && kill `cat /run/puma.pid` 2>/dev/null
              ignore_errors: True
            - name: 'Clone app repo'
              git:
                   repo=https://github.com/c0d5x/rails_dummyapp.git
                   dest={{appdir}}
                   version=staging
                   force=yes
            - name: 'Run bundler'
              shell: cd {{appdir}};bundler
            - name: 'Run db:setup'
              shell: cd {{appdir}};rails db:setup
              run_once: true
            - name: 'Run db:migrate'
              shell: cd {{appdir}};rails db:migrate
              run_once: true
            - name: 'Run rails server'
              shell: cd {{appdir}};rails server -b 0.0.0.0 -p 80 --pid /run/puma.pid -d
    
    放在你的环境中
    
    将这些文件放在相同的目录，运行下面的命令打开你的开发环境：
    
        vagrant up
        ansible-playbook -i inventory final-playbook.yml
    
    部署新的代码
    
    确保修改了代码并推送到了仓库中。接下来，确保你 git 语句中使用了正确的分支：
    
            - name: 'Clone app repo'
              git:
                   repo=https://github.com/c0d5x/rails_dummyapp.git
                   dest={{appdir}}
                   version=staging
                   force=yes
    
    作为一个例子，你可以修改 version 字段为 master，再次运行剧本：
    
        ansible-playbook -i inventory final-playbook.yml
    
    检查所有的 web 服务器上的页面是否已更改：http://10.1.1.11 或 http://10.1.1.12。将其更改为 version = staging 并重新运行剧本并再次检查页面。
    
    你还可以创建只包含与部署相关的任务的替代剧本，以便其运行更快。
    接下来是什么 ？！
    
    这只是可以做的很小一部分。我们没有接触角色、过滤器、调试等许多其他很棒的功能，但我希望它给了你一个良好的开始！所以，请继续学习并使用它。如果你有任何问题，你可以在 twitter 或评论栏联系我，让我知道你还想知道哪些关于 ansible 的东西！





远程管理工具有很多，SaltStack、Puppet、Chef，以及 Ansible 都是很流行的选择。在本文中，我将重点放在 Ansible 上并会解释它是如何帮到你的，不管你是有 5 台还是 1000 台虚拟机。

让我们从多机（不管这些机器是虚拟的还是物理的）的基本管理开始。我假设你知道要做什么，有基础的 Linux 管理技能（至少要有能找出执行每个任务具体步骤的能力）。我会向你演示如何使用这一工具，而是否使用它由你自己决定。

### 什么是 Ansible？

Ansible 的网站上将之解释为 “一个超级简单的 IT 自动化引擎，可以自动进行云供给、配置管理、应用部署、服务内部编排，以及其他很多 IT 需求。” 通过在一个集中的位置定义好服务器集合，Ansible 可以在多个服务器上执行相同的任务。

如果你对 Bash 的 `for` 循环很熟悉，你会发现 Ansible 操作跟这很类似。区别在于 Ansible 是幕等的idempotent。通俗来说就是 Ansible 一般只有在确实会发生改变时才执行所请求的动作。比如，假设你执行一个 Bash 的 for 循环来为多个机器创建用户，像这样子：

```
for server in serverA serverB serverC; do ssh ${server} "useradd myuser"; done
```

这会在 serverA、serverB，以及 serverC 上创建 myuser 用户；然而不管这个用户是否存在，每次运行这个 for 循环时都会执行 `useradd` 命令。一个幕等的系统会首先检查用户是否存在，只有在不存在的情况下才会去创建它。当然，这个例子很简单，但是幕等工具的好处将会随着时间的推移变得越发明显。

#### Ansible 是如何工作的？

Ansible 会将 Ansible playbooks 转换成通过 SSH 运行的命令，这在管理类 UNIX 环境时有很多优势：

1. 绝大多数类 UNIX 机器默认都开了 SSH。
2. 依赖 SSH 意味着远程主机不需要有代理。
3. 大多数情况下都无需安装额外的软件，Ansible 需要 2.6 或更新版本的 Python。而绝大多数 Linux 发行版默认都安装了这一版本（或者更新版本）的 Python。
4. Ansible 无需主节点。他可以在任何安装有 Ansible 并能通过 SSH 访问的主机上运行。
5. 虽然可以在 cron 中运行 Ansible，但默认情况下，Ansible 只会在你明确要求的情况下运行。

#### 配置 SSH 密钥认证

使用 Ansible 的一种常用方法是配置无需密码的 SSH 密钥登录以方便管理。（可以使用 Ansible Vault 来为密码等敏感信息提供保护，但这不在本文的讨论范围之内）。现在只需要使用下面命令来生成一个 SSH 密钥，如示例 1 所示。

```
[09:44 user ~]$ ssh-keygenGenerating public/private rsa key pair。Enter file in which to save the key (/home/user/.ssh/id_rsa):Created directory '/home/user/.ssh'。Enter passphrase (empty for no passphrase):Enter same passphrase again:Your identification has been saved in /home/user/.ssh/id_rsa。Your public key has been saved in /home/user/.ssh/id_rsa.pub。The key fingerprint is:SHA256:TpMyzf4qGqXmx3aqZijVv7vO9zGnVXsh6dPbXAZ+LUQ user@user-fedoraThe key's randomart image is:+---[RSA 2048]----+|                 ||                 ||              E  ||       o .   .。||   .  + S    o+。||  . .o * .  .+ooo|| . .+o  o o oo+。*||。.ooo* o。*  .*+|| . o+*BO.o+    .o|+----[SHA256]-----+
```

*示例 1 ：生成一个 SSH 密钥*

在示例 1 中，直接按下回车键来接受默认值。任何非特权用户都能生成 SSH 密钥，也能安装到远程系统中任何用户的 SSH 的 `authorized_keys` 文件中。生成密钥后，还需要将之拷贝到远程主机上去，运行下面命令：

```
ssh-copy-id root@servera
```

注意：运行 Ansible 本身无需 root 权限；然而如果你使用非 root 用户，你*需要*为要执行的任务配置合适的 sudo 权限。

输入 servera 的 root 密码，这条命令会将你的 SSH 密钥安装到远程主机上去。安装好 SSH 密钥后，再通过 SSH 登录远程主机就不再需要输入 root 密码了。

### 安装 Ansible

只需要在示例 1 中生成 SSH 密钥的那台主机上安装 Ansible。若你使用的是 Fedora，输入下面命令：

```
sudo dnf install ansible -y
```

若运行的是 CentOS，你需要为 EPEL 仓库配置额外的包：

```
sudo yum install epel-release -y
```

然后再使用 yum 来安装 Ansible：

```
sudo yum install ansible -y
```

对于基于 Ubuntu 的系统，可以从 PPA 上安装 Ansible：

```
sudo apt-get install software-properties-common -ysudo apt-add-repository ppa:ansible/ansiblesudo apt-get updatesudo apt-get install ansible -y
```

若你使用的是 macOS，那么推荐通过 Python PIP 来安装：

```
sudo pip install ansible
```

对于其他发行版，请参见 [Ansible 安装文档 ](http://docs.ansible.com/ansible/intro_installation.html)。

### Ansible Inventory

Ansible 使用一个 INI 风格的文件来追踪要管理的服务器，这种文件被称之为库存清单Inventory。默认情况下该文件位于 `/etc/ansible/hosts`。本文中，我使用示例 2 中所示的 Ansible 库存清单来对所需的主机进行操作（为了简洁起见已经进行了裁剪）：

```
[arch]nextcloudprometheusdesktop1desktop2vm-host15[fedora]netflix[centos]conanconfluence7-repovm-server1gitlab[ubuntu]trusty-mirrornwnkids-tvmedia-centrenas[satellite]satellite[ocp]lb00ocp_dnsmaster01app01infra01
```

*示例 2 ： Ansible 主机文件*

每个分组由中括号和组名标识（像这样 `[group1]` )，是应用于一组服务器的任意组名。一台服务器可以存在于多个组中，没有任何问题。在这个案例中，我有根据操作系统进行的分组（`arch`、`ubuntu`、`centos`、`fedora`），也有根据服务器功能进行的分组（`ocp`、`satellite`）。Ansible 主机文件可以处理比这复杂的多的情况。详细内容，请参阅 [库存清单文档](http://docs.ansible.com/ansible/intro_inventory.html)。

### 运行命令

将你的 SSH 密钥拷贝到库存清单中所有服务器上后，你就可以开始使用 Ansible 了。Ansible 的一项基本功能就是运行特定命令。语法为：

```
ansible -a "some command"
```

例如，假设你想升级所有的 CentOS 服务器，可以运行：

```
ansible centos -a 'yum update -y'
```

*注意：不是必须要根据服务器操作系统来进行分组的。我下面会提到，Ansible Facts 可以用来收集这一信息；然而，若使用 Facts 的话，则运行特定命令会变得很复杂，因此，如果你在管理异构环境的话，那么为了方便起见，我推荐创建一些根据操作系统来划分的组。*

这会遍历 `centos` 组中的所有服务器并安装所有的更新。一个更加有用的命令应该是 Ansible 的 `ping` 模块了，可以用来验证服务器是否准备好接受命令了：

```
ansible all -m ping
```

这会让 Ansible 尝试通过 SSH 登录库存清单中的所有服务器。在示例 3 中可以看到 `ping` 命令的部分输出结果。

```
nwn | SUCCESS => {    "changed":false，    "ping":"pong"}media-centre | SUCCESS => {    "changed":false，    "ping":"pong"}nas | SUCCESS => {    "changed":false，    "ping":"pong"}kids-tv | SUCCESS => {    "changed":false，    "ping":"pong"}...
```

*示例 3 ：Ansible ping 命令输出*

运行指定命令的能力有助于完成快速任务（LCTT 译注：应该指的那种一次性任务），但是如果我想在以后也能以同样的方式运行同样的任务那该怎么办呢？Ansible [playbooks](http://docs.ansible.com/ansible/playbooks.html) 就是用来做这个的。

### 复杂任务使用 Ansible playbooks

Ansible 剧本playbook 就是包含 Ansible 指令的 YAML 格式的文件。我这里不打算讲解类似 Roles 和 Templates 这些比较高深的内容。有兴趣的话，请阅读 [Ansible 文档](http://docs.ansible.com/ansible/playbooks_roles.html)。

在前一章节，我推荐你使用 `ssh-copy-id` 命令来传递你的 SSH 密钥；然而，本文关注于如何以一种一致的、可重复性的方式来完成任务。示例 4 演示了一种以冥等的方式，即使 SSH 密钥已经存在于目标主机上也能保证正确性的实现方法。

```
---- hosts:all  gather_facts:false  vars:    ssh_key:'/root/playbooks/files/laptop_ssh_key'  tasks:    - name:copy ssh key      authorized_key:        key:"{{ lookup('file'，ssh_key) }}"        user:root
```

*示例 4：Ansible 剧本 “pushsshkeys.yaml”*

`- hosts:` 行标识了这个剧本应该在那个主机组上执行。在这个例子中，它会检查库存清单里的所有主机。

`gather_facts:` 行指明 Ansible 是否去搜索每个主机的详细信息。我稍后会做一次更详细的检查。现在为了节省时间，我们设置 `gather_facts` 为 `false`。

`vars:` 部分，顾名思义，就是用来定义剧本中所用变量的。在示例 4 的这个简短剧本中其实不是必要的，但是按惯例我们还是设置了一个变量。

最后由 `tasks:` 标注的这个部分，是存放主体指令的地方。每个任务都有一个 `-name:`。Ansbile 在运行剧本时会显示这个名字。

`authorized_key:` 是剧本所使用 Ansible 模块的名字。可以通过命令 `ansible-doc -a` 来查询 Ansible 模块的相关信息； 不过通过网络浏览器查看 [文档 ](http://docs.ansible.com/ansible/modules_by_category.html) 可能更方便一些。[authorized_key 模块](http://docs.ansible.com/ansible/authorized_key_module.html) 有很多很好的例子可以参考。要运行示例 4 中的剧本，只要运行 `ansible-playbook` 命令就行了：

```
ansible-playbook push_ssh_keys.yaml
```

如果是第一次添加 SSH 密钥，SSH 会提示你输入 root 用户的密码。

现在 SSH 密钥已经传输到服务器中去了，可以来做点有趣的事了。

### 使用 Ansible 收集信息

Ansible 能够收集目标系统的各种信息。如果你的主机数量很多，那它会特别的耗时。按我的经验，每台主机大概要花个 1 到 2 秒钟，甚至更长时间；然而有时收集信息是有好处的。考虑下面这个剧本，它会禁止 root 用户通过密码远程登录系统：

```
---- hosts:all  gather_facts:true  vars:  tasks:    - name:Enabling ssh-key only root access      lineinfile:        dest:/etc/ssh/sshd_config        regexp:'^PermitRootLogin'        line:'PermitRootLogin without-password'      notify:        - restart_sshd        - restart_ssh  handlers:    - name:restart_sshd      service:        name:sshd        state:restarted        enabled:true      when:ansible_distribution == 'RedHat'    - name:restart_ssh      service:        name:ssh        state:restarted        enabled:true      when:ansible_distribution == 'Debian'
```

*示例 5：锁定 root 的 SSH 访问*

在示例 5 中 `sshd_config` 文件的修改是有[条件](http://docs.ansible.com/ansible/lineinfile_module.html) 的，只有在找到匹配的发行版的情况下才会执行。在这个案例中，基于 Red Hat 的发行版与基于 Debian 的发行版对 SSH 服务的命名是不一样的，这也是使用条件语句的目的所在。虽然也有其他的方法可以达到相同的效果，但这个例子很好演示了 Ansible 信息的作用。若你想查看 Ansible 默认收集的所有信息，可以在本地运行 `setup` 模块：

```
ansible localhost -m setup |less
```

Ansible 收集的所有信息都能用来做判断，就跟示例 4 中 `vars:` 部分所演示的一样。所不同的是，Ansible 信息被看成是**内置** 变量，无需由系统管理员定义。

### 更近一步

现在可以开始探索 Ansible 并创建自己的基本了。Ansible 是一个富有深度、复杂性和灵活性的工具，只靠一篇文章不可能就把它讲透。希望本文能够激发你的兴趣，鼓励你去探索 Ansible 的功能。在下一篇文章中，我会再聊聊 `Copy`、`systemd`、`service`、`apt`、`yum`、`virt`，以及 `user` 模块。我们可以在剧本中组合使用这些模块，还可以创建一个简单的 Git 服务器来存储这些所有剧本。