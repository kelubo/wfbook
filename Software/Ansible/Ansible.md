# Ansible

配置管理系统。

Ansible默认通过  SSH 协议管理机器。安装Ansible之后,不需要启动或运行一个后台进程,或是添加一个数据库.只要在一台电脑(可以是一台笔记本)上安装好,就可以通过这台电脑管理一组远程的机器.在远程被管理的机器上,不需要安装运行任何软件,因此升级Ansible版本不会有太多问题.

## 特性

- 拥有模块化的设计，Ansible能够调用特定的模块来完成特定任务 ，本身是核心组件，短小精悍 ；
- Ansible是基于**Python语言**实现的，由Paramiko (python 的一个可并发连接 ssh 主机功能库 ) , PyYAML和Jinja2 ( 模板化 ) 三个关键模块实现；
- Ansible的部署比较简单，agentless 无客户端工具；    
- 以主从模式工作；    
- 支持自定义模块功能；    
- 支持playbook剧本，连续任务按先后设置顺序完成；    
- 期望每个命令具有**幂等性**：        

## 安装要求

### 管理主机

支持SSH
Python 2.6
windows系统不可以做控制主机
自2.0版本开始,ansible使用了更多句柄来管理它的子进程,对于OS X系统,需要增加ulimit值才能使用15个以上子进程,方法 sudo launchctl limit maxfiles 1024 2048,否则可能会看见”Too many open file”的错误提示.

### 托管节点

通常使用 ssh 与托管节点通信，默认使用 sftp.如果 sftp 不可用，可在 ansible.cfg 配置文件中配置成 scp 的方式. 在托管节点上也需要安装 Python 2.4 或以上的版本.如果版本低于 Python 2.5 ,还需要额外安装一个模块`python-simplejson`

Note

如果托管节点上开启了SElinux,你需要安装libselinux-python,这样才可使用Ansible中与copy/file/template相关的函数.

## 安装
### 从源码安装

    $ git clone git://github.com/ansible/ansible.git --recursive
    $ cd ./ansible
    $ source ./hacking/env-setup
    $ sudo easy_install pip  //如果未安装pip，执行此命令
    $ sudo pip install paramiko PyYAML Jinja2 httplib2

### YUM安装

```bash
yum install epel-release
yum install ansible
```

### Apt(Ubuntu)安装

```bash
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible
```

### Portage(Gentoo)安装

    $ emerge -av app-admin/ansible

### pkg(FreeBSD)安装

    $ sudo pkg install ansible

### Homebrew(Mac OS X)安装

    $ brew update
    $ brew install ansible

### Pip安装

```bash
yum install python-pip python-devel
yum install gcc glibc-devel zlib-devel rpm-build openssl-devel
pip install --upgrade pip
pip install ansible -upgrade
```



### [从源码运行](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id16)

从项目的checkout中可以很容易运行Ansible,Ansible的运行不要求root权限,也不依赖于其他软件,不要求运行后台进程,也不需要设置数据库.因此我们社区的许多用户一直使用Ansible的开发版本,这样可以利用最新的功能特性,也方便对项目做贡献.因为不需要安装任何东西,跟进Ansible的开发版相对于其他开源项目要容易很多.

从源码安装的步骤

```
$ git clone git://github.com/ansible/ansible.git --recursive
$ cd ./ansible
```

使用 Bash:

```
$ source ./hacking/env-setup
```

使用 Fish:

```
$ . ./hacking/env-setup.fish
```

If you want to suppress spurious warnings/errors, use:

```
$ source ./hacking/env-setup -q
```

如果没有安装pip, 请先安装对应于你的Python版本的pip:

```
$ sudo easy_install pip
```

以下的Python模块也需要安装 [[1\]_](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id26):

```
$ sudo pip install paramiko PyYAML Jinja2 httplib2 six
```

注意,当更新ansible版本时,不只要更新git的源码树,也要更新git中指向Ansible自身模块的 “submodules” (不是同一种模块)

```
$ git pull --rebase
$ git submodule update --init --recursive
```

一旦运行env-setup脚本,就意味着Ansible从源码中运行起来了.默认的inventory文件是 /etc/ansible/hosts.inventory文件也可以另行指定 (详见 [Inventory文件](https://ansible-tran.readthedocs.io/en/latest/docs/intro_inventory.html)) :

```
$ echo "127.0.0.1" > ~/ansible_hosts
$ export ANSIBLE_HOSTS=~/ansible_hosts
```

你可以在手册的后续章节阅读更多关于 inventory 文件的使用,现在让我们测试一条ping命令:

```
$ ansible all -m ping --ask-pass
```

你也可以使用命令 “sudo make install”



### [通过Yum安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id17)

通过Yum安装RPMs适用于 [EPEL](http://fedoraproject.org/wiki/EPEL) 6, 7, 以及仍在支持中的Fedora发行版.

托管节点的操作系统版本可以是更早的版本(如 EL5), 但必须安装 Python 2.4 或更高版本的Python.

Fedora 用户可直接安装Ansible, 但RHEL或CentOS用户,需要 [配置 EPEL](http://fedoraproject.org/wiki/EPEL)

```
# install the epel-release RPM if needed on CentOS, RHEL, or Scientific Linux
$ sudo yum install ansible
```

你也可以自己创建RPM软件包.在Ansible项目的checkout的根目录下,或是在一个tarball中,使用 `make rpm` 命令创建RPM软件包. 然后可分发这个软件包或是使用它来安装Ansible.在创建之前,先确定你已安装了 `rpm-build`, `make`, and `python2-devel` .

```
$ git clone git://github.com/ansible/ansible.git
$ cd ./ansible
$ make rpm
$ sudo rpm -Uvh ~/rpmbuild/ansible-*.noarch.rpm
```



### [通过Apt (Ubuntu)安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id18)

Ubuntu 编译版可在PPA中获得: ` <<https://launchpad.net/~ansible/+archive/ansible>>`_.

配置PPA及安装ansible,执行如下命令:

```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```

Note

在早期Ubuntu发行版中, “software-properties-common” 名为 “python-software-properties”.

也可从源码checkout中创建 Debian/Ubuntu 软件包,执行:

```
$ make deb
```

你或许也想从源码中运行最新发行版本,可看前面的说明.



### [通过 Portage (Gentoo)安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id19)

```
$ emerge -av app-admin/ansible
```

要安装最新版本,你可能需要在执行 emerge 之前，先做如下操作(unmsk ansible)

```
$ echo 'app-admin/ansible' >> /etc/portage/package.accept_keywords
```

若在Gentoo托管节点中,已经安装了 Python 3 并将之作为默认的 Python slot(这也是默认设置),则你必须在 组变量 或 inventory 变量中设置如下变量 `ansible_python_interpreter = /usr/bin/python2`

### [通过 pkg (FreeBSD)安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id20)

```
$ sudo pkg install ansible
```

你或许想从ports中安装:

```
$ sudo make -C /usr/ports/sysutils/ansible install
```



### [在Mac OSX 上安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id21)

在 Mac 上安装 ansible，最好是通过 pip 安装，在 [通过 Pip 安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#pip) 小节介绍.



### [通过 OpenCSW 安装最新发布版本(Solaris)](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id22)

在 Solaris 上安装 ansible: [SysV package from OpenCSW](https://www.opencsw.org/packages/ansible/).

```
# pkgadd -d http://get.opencsw.org/now
# /opt/csw/bin/pkgutil -i ansible
```



### [通过 Pacman 安装最新发布版本(Arch Linux)](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id23)

Ansible 已经放入了 Community repository:

```
$ pacman -S ansible
```

The AUR has a PKGBUILD for pulling directly from Github called [ansible-git](https://aur.archlinux.org/packages/ansible-git).

Also see the [Ansible](https://wiki.archlinux.org/index.php/Ansible) page on the ArchWiki.

如果在 Arch Linux 上已经安装了 Python 3，并设置为默认的 Python slot，你必须在 组变量 或 inventory 变量中设置如下变量: `ansible_python_interpreter = /usr/bin/python2`



### [通过 Pip 安装最新发布版本](https://ansible-tran.readthedocs.io/en/latest/docs/intro_installation.html#id24)

Ansible可通过 “pip” 安装(安装和管理Python包的工具),若你还没有安装 pip,可执行如下命令安装:

```
$ sudo easy_install pip
```

然后安装Ansible:

```
$ sudo pip install ansible
```

如果你是在 OS X Mavericks 上安装,编译器可能或告警或报错,可通过如下设置避免这种情况:

```
$ sudo CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments pip install ansible
```

使用 virtualenv 的读者可通过 virtualenv 安装 Ansible, 然而我们建议不用这样做,直接在全局安装 Ansible.不要使用 easy_install 直接安装 ansible.



### 测试

编辑(或创建)/etc/ansible/hosts 并在其中加入一个或多个远程系统:

```bash
192.168.1.50
```

现在ping 你的所有节点:

```bash
$ ansible all -m ping
```

Ansible会像SSH那样试图用你的当前用户名来连接你的远程机器.要覆写远程用户名,只需使用’-u’参数. 如果你想访问 sudo模式,这里也有标识(flags)来实现:

```bash
# as bruce
$ ansible all -m ping -u bruce
# as bruce, sudoing to root
$ ansible all -m ping -u bruce --sudo
# as bruce, sudoing to batman
$ ansible all -m ping -u bruce --sudo --sudo-user batman
```

现在对你的所有节点运行一个命令:

```bash
$ ansible all -a "/bin/echo hello"
```

## Inventory文件

Ansible 可同时操作属于一个组的多台主机,组和主机之间的关系通过 inventory 文件配置. 默认的文件路径为 /etc/ansible/hosts

除默认文件外,你还可以同时使用多个 inventory 文件,也可以从动态源,或云上拉取 inventory 配置信息。

### 主机与组

/etc/ansible/hosts 文件的格式与windows的ini配置文件类似:

```bash
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

方括号[]中是组名,用于对系统进行分类,便于对不同系统进行个别的管理。

一个系统可以属于不同的组,比如一台服务器可以同时属于 webserver组 和 dbserver组.这时属于两个组的变量都可以为这台主机所用。

如果有主机的SSH端口不是标准的22端口,可在主机名之后加上端口号,用冒号分隔。

```bash
badwolf.example.com:5309
```

假设你有一些静态IP地址,希望设置一些别名,但不是在系统的 host 文件中设置,又或者你是通过隧道在连接,那么可以设置如下:

```bash
jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50
```

在这个例子中,通过 “jumper” 别名,会连接 192.168.1.50:5555.记住,这是通过 inventory 文件的特性功能设置的变量. 一般而言,这不是设置变量(描述你的系统策略的变量)的最好方式。

一组相似的 hostname , 可简写如下:

```bash
[webservers]
www[01:50].example.com
```

数字的简写模式中,01:50 也可写为 1:50,意义相同。还可以定义字母范围的简写模式:

```bash
[databases]
db-[a:f].example.com
```

对于每一个 host,你还可以选择连接类型和连接用户名:

```bash
[targets]

localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_ssh_user=mpdehaan
other2.example.com     ansible_connection=ssh        ansible_ssh_user=mdehaan
```

#### 主机变量

```bash
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
host2 http_port=303 maxRequestsPerChild=909
```

#### 组的变量

可以定义属于整个组的变量:

```
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

#### 把一个组作为另一个组的子成员

可以把一个组作为另一个组的子成员,以及分配变量给整个组使用. 这些变量可以给 /usr/bin/ansible-playbook 使用,但不能给 /usr/bin/ansible 使用:

```
[atlanta]
host1
host2

[raleigh]
host2
host3

[southeast:children]
atlanta
raleigh

[southeast:vars]
some_server=foo.southeast.example.com
halon_system_timeout=30
self_destruct_countdown=60
escape_pods=2

[usa:children]
southeast
northeast
southwest
northwest
```

#### 分文件定义 Host 和 Group 变量

在 inventory 主文件中保存所有的变量并不是最佳的方式.还可以保存在独立的文件中,这些独立文件与 inventory 文件保持关联. 不同于 inventory 文件( INI 格式),这些独立文件的格式为 YAML 。

假设 inventory 文件的路径为:

```
/etc/ansible/hosts
```

假设有一个主机名为 ‘foosball’, 主机同时属于两个组,一个是 ‘raleigh’, 另一个是 ‘webservers’. 那么以下配置文件(YAML 格式)中的变量可以为 ‘foosball’ 主机所用.依次为 ‘raleigh’ 的组变量,’webservers’ 的组变量,’foosball’ 的主机变量:

```bash
/etc/ansible/group_vars/raleigh
/etc/ansible/group_vars/webservers
/etc/ansible/host_vars/foosball
```

还有更进一步的运用,你可以为一个主机,或一个组,创建一个目录,目录名就是主机名或组名.目录中的可以创建多个文件, 文件中的变量都会被读取为主机或组的变量.如下 ‘raleigh’ 组对应于 /etc/ansible/group_vars/raleigh/ 目录,其下有两个文件 db_settings 和 cluster_settings, 其中分别设置不同的变量:

```
/etc/ansible/group_vars/raleigh/db_settings
/etc/ansible/group_vars/raleigh/cluster_settings
```

Tip: Ansible 1.2 及以上的版本中,group_vars/ 和 host_vars/ 目录可放在 inventory 目录下,或是 playbook 目录下. 如果两个目录下都存在,那么 playbook 目录下的配置会覆盖 inventory 目录的配置.

Tip: 把 inventory 文件 和 变量 放入 git repo 中,以便跟踪他们的更新,这是一种非常推荐的方式.

### Inventory 参数的说明

通过设置下面的参数,可以控制 ansible 与远程主机的交互方式:

```bash
ansible_ssh_host
# 将要连接的远程主机名.与想要设定的主机的别名不同的话,可通过此变量设置.

ansible_ssh_port
# ssh端口号.如果不是默认的端口号,通过此变量设置.

ansible_ssh_user
# 默认的 ssh 用户名

ansible_ssh_pass
# ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

ansible_sudo_pass
# sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

ansible_sudo_exe (new in version 1.8)
# sudo 命令路径(适用于1.8及以上版本)

ansible_connection
# 与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

ansible_ssh_private_key_file
# ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

ansible_shell_type
# 目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

ansible_python_interpreter
# 目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如  *BSD, 或者 /usr/bin/python 不是 2.X 版本的 Python.我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python 以外的名字(实际有可能名为python26).
```

一个主机文件的例子:

```bash
some_host         ansible_ssh_port=2222     ansible_ssh_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
freebsd_host      ansible_python_interpreter=/usr/local/bin/python
ruby_module_host  ansible_ruby_interpreter=/usr/bin/ruby.1.9.3
```

## 动态 Inventory

在其他软件系统保存配置信息的例子有:

```bash
1, 从云端拉取 inventory
2, LDAP（Lightweight Directory Access Protocol,轻量级目录访问协议）
3, Cobbler <http://cobbler.github.com>
4, 或者是一份昂贵的企业版的 CMDB（配置管理数据库） 软件.
```

对于这些需求,Ansible 可通过一个外部 inventory 系统来支持.在 ansible 的 “/plugins”  插件目录下已经含有一些选项 – 包括 EC2/Eucalyptus, Rackspace Cloud,and  OpenStack。

Ansible [Ansible Tower](https://ansible-tran.readthedocs.io/en/latest/docs/tower.html) 提供了一个数据库来存储 inventory 配置信息, 这个数据库可以通过 web 访问,或通过 REST 访问. Tower 与所有你使用的 Ansible 动态 inventory 源保持同步,并提供了一个图形化的 inventory 编辑器. 有了这个数据库,便可以很容易的关联过去的事件历史,可以看到在上一次 playbook 运行时,哪里出现了运行失败的情况.

### Cobbler 外部 Inventory 脚本

当管理的物理机器到达了一定数量的时,很多使用 Ansible 的用户可能同时也会使用到 [Cobbler](http://cobbler.github.com) . （注: Cobbler 最初由 Michael DeHaan 编写,现在项目主导人是 James Cammarata, 他目前在 Ansible 公司工作）.

Cobbler 主要用于操作系统的 kickoff 安装,以及管理 DHCP 和 DNS,除此之外,它有一个通用层,可为多种配置管理系统（甚至是同时的）提供数据. 所以 Cobbler 也被一些管理员称为是轻量级的 CMDB.

将 Ansible 的 inventory 与 Cobbler 联系起来，方法是: 将脚本拷贝到 /etc/ansible,通过 chmod +x 赋予可执行权限.

在使用 Ansible 之前,先启动 cobblerd 进程.

现在使用 Ansible 要加上  `-i` 选项 （ 例如:`-i /etc/ansible/cobbler.py`）。cobbler.py这个脚本使用 Cobbler 的 XMLRPC API 与 Cobbler 通信.

执行脚本 `/etc/ansible/cobbler.py` ,应该能看到一些 JSON 格式的数据输出。

在 cobbler 中,假设有一个如下的场景:

```
cobbler profile add --name=webserver --distro=CentOS6-x86_64
cobbler profile edit --name=webserver --mgmt-classes="webserver" --ksmeta="a=2 b=3"
cobbler system edit --name=foo --dns-name="foo.example.com" --mgmt-classes="atlanta" --ksmeta="c=4"
cobbler system edit --name=bar --dns-name="bar.example.com" --mgmt-classes="atlanta" --ksmeta="c=5"
```

‘foo.example.com’ 是一个域名,Ansible 可以通过这个域名寻址找到对应的主机foo,对其进行操作.也可以通过组名  ‘webserver’ 或者 ‘atlanta’ 寻址找到这个主机,只要这个主机是属于这两个组的。直接使用 foo 是不行的。

这个脚本不仅提供主机和组的信息.如果运行了 ‘setup’ 模块（只要使用 playbooks,’setup’ 模块会自动运行）,变量 a, b, c 可按照以下模板自动填充:

```
# file: /srv/motd.j2
Welcome, I am templated with a value of a={{ a }}, b={{ b }}, and c={{ c }}
```

模板的使用如下:

```
ansible webserver -m setup
ansible webserver -m template -a "src=/tmp/motd.j2 dest=/etc/motd"
```

Note

组名 ‘webserver’ 是 cobbler 中定义的.你仍然可以在 Ansible 的配置文件中定义变量. 但要注意,变量名相同时,外部 inventory 脚本中定义的变量会覆盖 Ansible 中的变量.

执行上面命令后,主机 foo 的/etc/motd文件被写入如下的内容:

```
Welcome, I am templated with a value of a=2, b=3, and c=4
```

主机 ‘bar’ (bar.example.com)的 /etc/motd 中写入如下内容:

```
Welcome, I am templated with a value of a=2, b=3, and c=5
```

你也可以通过下面这个命令测试变量的替换:

```
ansible webserver -m shell -a "echo {{ a }}"
```

也就是说,你可以在参数或命令操作中使用变量的替换.

### AWS EC2 外部 inventory 脚本

使用 AWC EC2时,维护一份 inventory 文件有时不是最好的方法.因为主机的数量有可能发生变动,或者主机是由外部的应用管理的,或者使用了 AWS autoscaling.这时,使用 [EC2 external inventory](https://raw.github.com/ansible/ansible/devel/plugins/inventory/ec2.py) 脚本是更好的选择.

脚本的使用方式有两种,最简单的是直接使用 Ansible 的命令行选项 `-i` ,指定脚本的路径（脚本要有可执行权限）:

```
ansible -i ec2.py -u ubuntu us-east-1d -m ping
```

第二种方式,把脚本拷贝为 /etc/ansible/hosts ,并赋予可执行权限.还需把 [ec2.ini](https://raw.githubusercontent.com/ansible/ansible/devel/plugins/inventory/ec2.ini) 文件拷贝到 /etc/ansible/ec2.ini,然后运行 ansible.

要成功的调用 API 访问 AWS,需要配置 Boto （Boto 是 AWS 的 Python 接口）.可用的方法有多种,请参见: [methods](http://docs.pythonboto.org/en/latest/boto_config_tut.html) .

最简单的方法是定义两个环境变量:

```
export AWS_ACCESS_KEY_ID='AK123'
export AWS_SECRET_ACCESS_KEY='abc123'
```

如何知道配置是否正确,执行脚本来测试:

```
cd plugins/inventory
./ec2.py --list
```

你可以看到以 JSON 格式表示的覆盖所有 regions 的 inventory 信息.

因为每一个 region 需要自己的 API 调用,如果你仅使用了所有 regions 中的一个子集,可以编辑 `ec2.ini` ,使之仅显示你所感兴趣的那些 regions. 在配置文件 `ec2.ini` 中,包含了其他配置选项,包括缓存控制和目的地址变量.

inventory 文件的核心部分,是一些名字到目的地址的映射.默认的 `ec2.ini` 设置适用于在 EC2 之外运行 Ansible（比如一台笔记本电脑）,但这不是最有效的方式.

在 EC2 内部运行 Ansible 时,内部的 DNS 名和 IP 地址比公共 DNS 名更容易理解.你可以在 `ec2.ini` 文件中修改 `destination_variable` 变量, 改为一个实例的私有 DNS 名.对于在私有子网的 VPC 上运行 Ansible ,这种设置很重要,使得我们可以使用内部IP地址之外的方式访问到一个VPC.在 `ec2.ini` 文件中, vpc_destination_variable 可以命名为任意一个 [boto.ec2.instance](http://docs.pythonboto.org/en/latest/ref/ec2.html#module-boto.ec2.instance) 变量.

EC2 外部 inventory 提供了一种从多个组到实例的映射:

全局 实例都属于 `ec2` 这个组.

- 实例ID

  例如: `i-00112233` `i-a1b1c1d1`

- Region

  属于一个 AWS region 的所有实例构成的一个组. 例如: `us-east-1` `us-west-2`

- 可用性区域

  所有属于 availability zone 的实例构成一个组. 例如: `us-east-1a` `us-east-1b`

- 安全组

  实例可属于一个或多个安全组.每一个组的前缀都是 `security_group_` ,符号(-) 已被转换为(_). with all characters except alphanumerics (这句没明白) 例如: `security_group_default` `security_group_webservers` `security_group_Pete_s_Fancy_Group` 

- 标签

  每一个实例可有多个不同的 key/value 键值对,这些键值对被称为标签.标签名可以随意定义,最常见的标签是 ‘Name’.每一个键值对是这个实例自己的组. 特殊字符已转换为下划线,格式为 `tag_KEY_VALUE` 例如: `tag_Name_Web` `tag_Name_redis-master-001` `tag_aws_cloudformation_logical-id_WebServerGroup`

使用 Ansible 与指定的服务器进行交互时,EC2 inventory 脚本被再次调用（调用时加上了命令行选项  `--host HOST` ）,这个调用会在索引缓存中进行查找,获取实例 ID,然后调用 API 访问 AWS,获取指定实例的所有信息.这些信息被转换为 playbooks 中的变量,可以进行访问.每一个变量的前缀为 `ec2_`,下面是一些变量的示例:

- ec2_architecture
- ec2_description
- ec2_dns_name
- ec2_id
- ec2_image_id
- ec2_instance_type
- ec2_ip_address
- ec2_kernel
- ec2_key_name
- ec2_launch_time
- ec2_monitored
- ec2_ownerId
- ec2_placement
- ec2_platform
- ec2_previous_state
- ec2_private_dns_name
- ec2_private_ip_address
- ec2_public_dns_name
- ec2_ramdisk
- ec2_region
- ec2_root_device_name
- ec2_root_device_type
- ec2_security_group_ids
- ec2_security_group_names
- ec2_spot_instance_request_id
- ec2_state
- ec2_state_code
- ec2_state_reason
- ec2_status
- ec2_subnet_id
- ec2_tag_Name
- ec2_tenancy
- ec2_virtualization_type
- ec2_vpc_id

其中 `ec2_security_group_ids` 和 `ec2_security_group_names` 变量的值为所有安全组的列表,使用逗号分隔.每一个 EC2 标签是一个格式为 `ec2_tag_KEY` 的变量.

要查看一个实例的完整的可用变量的列表,执行脚本:

```
cd plugins/inventory
./ec2.py --host ec2-12-12-12-12.compute-1.amazonaws.com
```

注意,AWS inventory 脚本会将结果进行缓存,以避免重复的 API 调用,这个缓存的设置可在 ec2.ini 文件中配置.要显式地清空缓存,你可以加上 `--refresh-cache` 选项,执行脚本如下:

```
# ./ec2.py --refresh-cache
```

### 其它 inventory 脚本

除了 Cobbler 和 EC2 之外,还有以下的系统可以使用 inventory 脚本:

```
BSD Jails
DigitalOcean
Google Compute Engine
Linode
OpenShift
OpenStack Nova
Red Hat's SpaceWalk
Vagrant (not to be confused with the provisioner in vagrant, which is preferred)
Zabbix
```

### 使用多个 inventory 源

如果 -i 选项后给出的地址是一个目录 （or as so configured in ansible.cfg）,Ansible  可以同一时间使用多个 inventory 源.这样在同一个 ansible 运行操作中,可混合的使用动态和静态的 inventory 源.

### 动态组作为静态组的子组

在静态 inventory 文件中,如果定义一个由一些组作为子成员的组,这些子组也需要定义,否则执行时 ansible 会返回一个错误. 如果定义一些动态组作为一个静态组的子组,也需在静态 inventory 文件中定义动态组,但是动态组定义为一个空的组即可:

```
[tag_Name_staging_foo]

[tag_Name_staging_bar]

[staging:children]
tag_Name_staging_foo
tag_Name_staging_bar
```

## Patterns

Topics

- [Patterns](https://ansible-tran.readthedocs.io/en/latest/docs/intro_patterns.html#patterns)

在Ansible中,Patterns 是指我们怎样确定由哪一台主机来管理. 意思就是与哪台主机进行交互. 但是在:doc:playbooks 中它指的是对应主机应用特定的配置或执行特定进程.

我们再来复习下:doc:intro_adhoc 章节中介绍的命令用法,命令格式如下:

```
ansible <pattern_goes_here> -m <module_name> -a <arguments>
```

示例如下:

```
ansible webservers -m service -a "name=httpd state=restarted"
```

一个pattern通常关联到一系列组(主机的集合) –如上示例中,所有的主机均在 “webservers” 组中.

不管怎么样,在使用Ansible前,我们需事先告诉Ansible哪台机器将被执行. 能这样做的前提是需要预先定义唯一的 host names 或者 主机组.

如下的patterns等同于目标为仓库(inventory)中的所有机器:

```
all
*
```

也可以写IP地址或系列主机名:

```
one.example.com
one.example.com:two.example.com
192.168.1.50
192.168.1.*
```

如下patterns分别表示一个或多个groups.多组之间以冒号分隔表示或的关系.这意味着一个主机可以同时存在多个组:

```
webservers
webservers:dbservers
```

你也可以排队一个特定组,如下实例中,所有执行命令的机器必须隶属 webservers 组但同时不在 phoenix组:

```
webservers:!phoenix
```

你也可以指定两个组的交集,如下实例表示,执行命令有机器需要同时隶属于 webservers 和 staging 组.

> webservers:&staging

你也可以组合更复杂的条件:

```
webservers:dbservers:&staging:!phoenix
```

上面这个例子表示“‘webservers’ 和 ‘dbservers’ 两个组中隶属于 ‘staging’ 组并且不属于 ‘phoenix’ 组的机器才执行命令” ... 哟！唷! 好烧脑的说！

你也可以使用变量如果你希望通过传参指定group,ansible-playbook通过 “-e” 参数可以实现,但这种用法不常用:

```
webservers:!{{excluded}}:&{{required}}
```

你也可以不必严格定义groups,单个的host names, IPs , groups都支持通配符:

```
*.example.com
*.com
```

Ansible同时也支持通配和groups的混合使用:

```
one*.com:dbservers
```

在高级语法中,你也可以在group中选择对应编号的server:

```
webservers[0]
```

或者一个group中的一部分servers:

```
webservers[0-25]
```

大部分人都在patterns应用正则表达式,但你可以.只需要以 ‘~’ 开头即可:

```
~(web|db).*\.example\.com
```

同时让我们提前了解一些技能,除了如上,你也可以通过 `--limit` 标记来添加排除条件,/usr/bin/ansible or /usr/bin/ansible-playbook都支持:

```
ansible-playbook site.yml --limit datacenter2
```

如果你想从文件读取hosts,文件名以@为前缀即可.从Ansible 1.2开始支持该功能:

```
ansible-playbook site.yml --limit @retry_hosts.txt
```

​                

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





## 使用 Ansible 需要具备什么基础知识？

1. 具备 Linux 服务器 (server) 基础操作和管理经验。
2. 会使用 ssh 远端连线至 server。
3. 知道基本的标准输入 (stdin) 输出 (stdout) 等观念。[6](https://www.w3cschool.cn/automate_with_ansible/automate_with_ansible-atvo27or.html#fn_6)
4. 会安装 Linux 套件。[7](https://www.w3cschool.cn/automate_with_ansible/automate_with_ansible-atvo27or.html#fn_7)
5. 知道 `sudo` 指令在做什么，并且会使用它。[8](https://www.w3cschool.cn/automate_with_ansible/automate_with_ansible-atvo27or.html#fn_8)
6. 知道什么是档案权限，并且会修改它。
7. 知道如何启用和停止系统服务 (Daemon / Service)。
8. 会撰写简易的脚本 (Script)

## 配置文件

```bash
# config file for ansible -- https://ansible.com/
# ===============================================

# nearly all parameters can be overridden in ansible-playbook
# or with command line flags. ansible will read ANSIBLE_CONFIG,
# ansible.cfg in the current working directory, .ansible.cfg in
# the home directory or /etc/ansible/ansible.cfg, whichever it
# finds first

[defaults]

# some basic default values...

#inventory      = /etc/ansible/hosts
# 定义Inventory
#library        = /usr/share/my_modules/
# 自定义lib存放目录
#module_utils   = /usr/share/my_module_utils/
#remote_tmp     = ~/.ansible/tmp
# 临时文件，远程主机存放目录
#local_tmp      = ~/.ansible/tmp
# 临时文件，本地存放目录
#plugin_filters_cfg = /etc/ansible/plugin_filters.yml
#forks          = 5
# 默认开启的并发数
#poll_interval  = 15
# 默认轮询时间间隔
#sudo_user      = root
# 默认sudo用户
#ask_sudo_pass = True
# 是否需要sudo密码
#ask_pass      = True
# 是否需要密码
#transport      = smart
#remote_port    = 22
#module_lang    = C
#module_set_locale = False

# plays will gather facts by default, which contain information about
# the remote system.
#
# smart - gather by default, but don't regather if already gathered
# implicit - gather by default, turn off with gather_facts: False
# explicit - do not gather by default, must say gather_facts: True
#gathering = implicit

# This only affects the gathering done by a play's gather_facts directive,
# by default gathering retrieves all facts subsets
# all - gather all subsets
# network - gather min and network facts
# hardware - gather hardware facts (longest facts to retrieve)
# virtual - gather min and virtual facts
# facter - import facts from facter
# ohai - import facts from ohai
# You can combine them using comma (ex: network,virtual)
# You can negate them using ! (ex: !hardware,!facter,!ohai)
# A minimal set of facts is always gathered.
#gather_subset = all

# some hardware related facts are collected
# with a maximum timeout of 10 seconds. This
# option lets you increase or decrease that
# timeout to something more suitable for the
# environment.
# gather_timeout = 10

# Ansible facts are available inside the ansible_facts.* dictionary
# namespace. This setting maintains the behaviour which was the default prior
# to 2.5, duplicating these variables into the main namespace, each with a
# prefix of 'ansible_'.
# This variable is set to True by default for backwards compatibility. It
# will be changed to a default of 'False' in a future release.
# ansible_facts.
# inject_facts_as_vars = True

# additional paths to search for roles in, colon separated
#roles_path    = /etc/ansible/roles
# 默认下载的roles存放目录

# uncomment this to disable SSH key host checking
#host_key_checking = False

# change the default callback, you can only have one 'stdout' type  enabled at a time.
#stdout_callback = skippy


## Ansible ships with some plugins that require whitelisting,
## this is done to avoid running all of a type by default.
## These setting lists those that you want enabled for your system.
## Custom plugins should not need this unless plugin author specifies it.

# enable callback plugins, they can output to stdout but cannot be 'stdout' type.
#callback_whitelist = timer, mail

# Determine whether includes in tasks and handlers are "static" by
# default. As of 2.0, includes are dynamic by default. Setting these
# values to True will make includes behave more like they did in the
# 1.x versions.
#task_includes_static = False
#handler_includes_static = False

# Controls if a missing handler for a notification event is an error or a warning
#error_on_missing_handler = True

# change this for alternative sudo implementations
#sudo_exe = sudo

# What flags to pass to sudo
# WARNING: leaving out the defaults might create unexpected behaviours
#sudo_flags = -H -S -n

# SSH timeout
#timeout = 10

# default user to use for playbooks if user is not specified
# (/usr/bin/ansible will use current user as default)
#remote_user = root

# logging is off by default unless this path is defined
# if so defined, consider logrotate
#log_path = /var/log/ansible.log

# default module name for /usr/bin/ansible
#module_name = command

# use this shell for commands executed under sudo
# you may need to change this to bin/bash in rare instances
# if sudo is constrained
#executable = /bin/sh

# if inventory variables overlap, does the higher precedence one win
# or are hash values merged together?  The default is 'replace' but
# this can also be set to 'merge'.
#hash_behaviour = replace

# by default, variables from roles will be visible in the global variable
# scope. To prevent this, the following option can be enabled, and only
# tasks and handlers within the role will see the variables there
#private_role_vars = yes

# list any Jinja2 extensions to enable here:
#jinja2_extensions = jinja2.ext.do,jinja2.ext.i18n

# if set, always use this private key file for authentication, same as
# if passing --private-key to ansible or ansible-playbook
#private_key_file = /path/to/file

# If set, configures the path to the Vault password file as an alternative to
# specifying --vault-password-file on the command line.
#vault_password_file = /path/to/vault_password_file

# format of string {{ ansible_managed }} available within Jinja2
# templates indicates to users editing templates files will be replaced.
# replacing {file}, {host} and {uid} and strftime codes with proper values.
#ansible_managed = Ansible managed: {file} modified on %Y-%m-%d %H:%M:%S by {uid} on {host}
# {file}, {host}, {uid}, and the timestamp can all interfere with idempotence
# in some situations so the default is a static string:
#ansible_managed = Ansible managed

# by default, ansible-playbook will display "Skipping [host]" if it determines a task
# should not be run on a host.  Set this to "False" if you don't want to see these "Skipping"
# messages. NOTE: the task header will still be shown regardless of whether or not the
# task is skipped.
#display_skipped_hosts = True

# by default, if a task in a playbook does not include a name: field then
# ansible-playbook will construct a header that includes the task's action but
# not the task's args.  This is a security feature because ansible cannot know
# if the *module* considers an argument to be no_log at the time that the
# header is printed.  If your environment doesn't have a problem securing
# stdout from ansible-playbook (or you have manually specified no_log in your
# playbook on all of the tasks where you have secret information) then you can
# safely set this to True to get more informative messages.
#display_args_to_stdout = False

# by default (as of 1.3), Ansible will raise errors when attempting to dereference
# Jinja2 variables that are not set in templates or action lines. Uncomment this line
# to revert the behavior to pre-1.3.
#error_on_undefined_vars = False

# by default (as of 1.6), Ansible may display warnings based on the configuration of the
# system running ansible itself. This may include warnings about 3rd party packages or
# other conditions that should be resolved if possible.
# to disable these warnings, set the following value to False:
#system_warnings = True

# by default (as of 1.4), Ansible may display deprecation warnings for language
# features that should no longer be used and will be removed in future versions.
# to disable these warnings, set the following value to False:
#deprecation_warnings = True

# (as of 1.8), Ansible can optionally warn when usage of the shell and
# command module appear to be simplified by using a default Ansible module
# instead.  These warnings can be silenced by adjusting the following
# setting or adding warn=yes or warn=no to the end of the command line
# parameter string.  This will for example suggest using the git module
# instead of shelling out to the git command.
# command_warnings = False


# set plugin path directories here, separate with colons
#action_plugins     = /usr/share/ansible/plugins/action
#become_plugins     = /usr/share/ansible/plugins/become
#cache_plugins      = /usr/share/ansible/plugins/cache
#callback_plugins   = /usr/share/ansible/plugins/callback
#connection_plugins = /usr/share/ansible/plugins/connection
#lookup_plugins     = /usr/share/ansible/plugins/lookup
#inventory_plugins  = /usr/share/ansible/plugins/inventory
#vars_plugins       = /usr/share/ansible/plugins/vars
#filter_plugins     = /usr/share/ansible/plugins/filter
#test_plugins       = /usr/share/ansible/plugins/test
#terminal_plugins   = /usr/share/ansible/plugins/terminal
#strategy_plugins   = /usr/share/ansible/plugins/strategy


# by default, ansible will use the 'linear' strategy but you may want to try
# another one
#strategy = free

# by default callbacks are not loaded for /bin/ansible, enable this if you
# want, for example, a notification or logging callback to also apply to
# /bin/ansible runs
#bin_ansible_callbacks = False


# don't like cows?  that's unfortunate.
# set to 1 if you don't want cowsay support or export ANSIBLE_NOCOWS=1
#nocows = 1

# set which cowsay stencil you'd like to use by default. When set to 'random',
# a random stencil will be selected for each task. The selection will be filtered
# against the `cow_whitelist` option below.
#cow_selection = default
#cow_selection = random

# when using the 'random' option for cowsay, stencils will be restricted to this list.
# it should be formatted as a comma-separated list with no spaces between names.
# NOTE: line continuations here are for formatting purposes only, as the INI parser
#       in python does not support them.
#cow_whitelist=bud-frogs,bunny,cheese,daemon,default,dragon,elephant-in-snake,elephant,eyes,\
#              hellokitty,kitty,luke-koala,meow,milk,moofasa,moose,ren,sheep,small,stegosaurus,\
#              stimpy,supermilker,three-eyes,turkey,turtle,tux,udder,vader-koala,vader,www

# don't like colors either?
# set to 1 if you don't want colors, or export ANSIBLE_NOCOLOR=1
#nocolor = 1

# if set to a persistent type (not 'memory', for example 'redis') fact values
# from previous runs in Ansible will be stored.  This may be useful when
# wanting to use, for example, IP information from one group of servers
# without having to talk to them in the same playbook run to get their
# current IP information.
#fact_caching = memory

#This option tells Ansible where to cache facts. The value is plugin dependent.
#For the jsonfile plugin, it should be a path to a local directory.
#For the redis plugin, the value is a host:port:database triplet: fact_caching_connection = localhost:6379:0

#fact_caching_connection=/tmp



# retry files
# When a playbook fails a .retry file can be created that will be placed in ~/
# You can enable this feature by setting retry_files_enabled to True
# and you can change the location of the files by setting retry_files_save_path

#retry_files_enabled = False
#retry_files_save_path = ~/.ansible-retry

# squash actions
# Ansible can optimise actions that call modules with list parameters
# when looping. Instead of calling the module once per with_ item, the
# module is called once with all items at once. Currently this only works
# under limited circumstances, and only with parameters named 'name'.
#squash_actions = apk,apt,dnf,homebrew,pacman,pkgng,yum,zypper

# prevents logging of task data, off by default
#no_log = False

# prevents logging of tasks, but only on the targets, data is still logged on the master/controller
#no_target_syslog = False

# controls whether Ansible will raise an error or warning if a task has no
# choice but to create world readable temporary files to execute a module on
# the remote machine.  This option is False by default for security.  Users may
# turn this on to have behaviour more like Ansible prior to 2.1.x.  See
# https://docs.ansible.com/ansible/become.html#becoming-an-unprivileged-user
# for more secure ways to fix this than enabling this option.
#allow_world_readable_tmpfiles = False

# controls the compression level of variables sent to
# worker processes. At the default of 0, no compression
# is used. This value must be an integer from 0 to 9.
#var_compression_level = 9

# controls what compression method is used for new-style ansible modules when
# they are sent to the remote system.  The compression types depend on having
# support compiled into both the controller's python and the client's python.
# The names should match with the python Zipfile compression types:
# * ZIP_STORED (no compression. available everywhere)
# * ZIP_DEFLATED (uses zlib, the default)
# These values may be set per host via the ansible_module_compression inventory
# variable
#module_compression = 'ZIP_DEFLATED'

# This controls the cutoff point (in bytes) on --diff for files
# set to 0 for unlimited (RAM may suffer!).
#max_diff_size = 1048576

# This controls how ansible handles multiple --tags and --skip-tags arguments
# on the CLI.  If this is True then multiple arguments are merged together.  If
# it is False, then the last specified argument is used and the others are ignored.
# This option will be removed in 2.8.
#merge_multiple_cli_flags = True

# Controls showing custom stats at the end, off by default
#show_custom_stats = True

# Controls which files to ignore when using a directory as inventory with
# possibly multiple sources (both static and dynamic)
#inventory_ignore_extensions = ~, .orig, .bak, .ini, .cfg, .retry, .pyc, .pyo

# This family of modules use an alternative execution path optimized for network appliances
# only update this setting if you know how this works, otherwise it can break module execution
#network_group_modules=eos, nxos, ios, iosxr, junos, vyos

# When enabled, this option allows lookups (via variables like {{lookup('foo')}} or when used as
# a loop with `with_foo`) to return data that is not marked "unsafe". This means the data may contain
# jinja2 templating language which will be run through the templating engine.
# ENABLING THIS COULD BE A SECURITY RISK
#allow_unsafe_lookups = False

# set default errors for all plays
#any_errors_fatal = False

[inventory]
# enable inventory plugins, default: 'host_list', 'script', 'auto', 'yaml', 'ini', 'toml'
#enable_plugins = host_list, virtualbox, yaml, constructed

# ignore these extensions when parsing a directory as inventory source
#ignore_extensions = .pyc, .pyo, .swp, .bak, ~, .rpm, .md, .txt, ~, .orig, .ini, .cfg, .retry

# ignore files matching these patterns when parsing a directory as inventory source
#ignore_patterns=

# If 'true' unparsed inventory sources become fatal errors, they are warnings otherwise.
#unparsed_is_failed=False

[privilege_escalation]
#become=True
#become_method=sudo
#become_user=root
#become_ask_pass=False

[paramiko_connection]

# uncomment this line to cause the paramiko connection plugin to not record new host
# keys encountered.  Increases performance on new host additions.  Setting works independently of the
# host key checking setting above.
#record_host_keys=False

# by default, Ansible requests a pseudo-terminal for commands executed under sudo. Uncomment this
# line to disable this behaviour.
#pty=False

# paramiko will default to looking for SSH keys initially when trying to
# authenticate to remote devices.  This is a problem for some network devices
# that close the connection after a key failure.  Uncomment this line to
# disable the Paramiko look for keys function
#look_for_keys = False

# When using persistent connections with Paramiko, the connection runs in a
# background process.  If the host doesn't already have a valid SSH key, by
# default Ansible will prompt to add the host key.  This will cause connections
# running in background processes to fail.  Uncomment this line to have
# Paramiko automatically add host keys.
#host_key_auto_add = True

[ssh_connection]

# ssh arguments to use
# Leaving off ControlPersist will result in poor performance, so use
# paramiko on older platforms rather than removing it, -C controls compression use
#ssh_args = -C -o ControlMaster=auto -o ControlPersist=60s

# The base directory for the ControlPath sockets.
# This is the "%(directory)s" in the control_path option
#
# Example:
# control_path_dir = /tmp/.ansible/cp
#control_path_dir = ~/.ansible/cp

# The path to use for the ControlPath sockets. This defaults to a hashed string of the hostname,
# port and username (empty string in the config). The hash mitigates a common problem users
# found with long hostnames and the conventional %(directory)s/ansible-ssh-%%h-%%p-%%r format.
# In those cases, a "too long for Unix domain socket" ssh error would occur.
#
# Example:
# control_path = %(directory)s/%%h-%%r
#control_path =

# Enabling pipelining reduces the number of SSH operations required to
# execute a module on the remote server. This can result in a significant
# performance improvement when enabled, however when using "sudo:" you must
# first disable 'requiretty' in /etc/sudoers
#
# By default, this option is disabled to preserve compatibility with
# sudoers configurations that have requiretty (the default on many distros).
#
#pipelining = False

# Control the mechanism for transferring files (old)
#   * smart = try sftp and then try scp [default]
#   * True = use scp only
#   * False = use sftp only
#scp_if_ssh = smart

# Control the mechanism for transferring files (new)
# If set, this will override the scp_if_ssh option
#   * sftp  = use sftp to transfer files
#   * scp   = use scp to transfer files
#   * piped = use 'dd' over SSH to transfer files
#   * smart = try sftp, scp, and piped, in that order [default]
#transfer_method = smart

# if False, sftp will not use batch mode to transfer files. This may cause some
# types of file transfer failures impossible to catch however, and should
# only be disabled if your sftp version has problems with batch mode
#sftp_batch_mode = False

# The -tt argument is passed to ssh when pipelining is not enabled because sudo 
# requires a tty by default. 
#usetty = True

# Number of times to retry an SSH connection to a host, in case of UNREACHABLE.
# For each retry attempt, there is an exponential backoff,
# so after the first attempt there is 1s wait, then 2s, 4s etc. up to 30s (max).
#retries = 3

[persistent_connection]

# Configures the persistent connection timeout value in seconds.  This value is
# how long the persistent connection will remain idle before it is destroyed.
# If the connection doesn't receive a request before the timeout value
# expires, the connection is shutdown. The default value is 30 seconds.
#connect_timeout = 30

# The command timeout value defines the amount of time to wait for a command
# or RPC call before timing out. The value for the command timeout must
# be less than the value of the persistent connection idle timeout (connect_timeout)
# The default value is 30 second.
#command_timeout = 30

[accelerate]
#accelerate_port = 5099
#accelerate_timeout = 30
#accelerate_connect_timeout = 5.0

# The daemon timeout is measured in minutes. This time is measured
# from the last activity to the accelerate daemon.
#accelerate_daemon_timeout = 30

# If set to yes, accelerate_multi_key will allow multiple
# private keys to be uploaded to it, though each user must
# have access to the system via SSH to add a new key. The default
# is "no".
#accelerate_multi_key = yes

[selinux]
# file systems that require special treatment when dealing with security context
# the default behaviour that copies the existing context or uses the user default
# needs to be changed to use the file system dependent context.
#special_context_filesystems=nfs,vboxsf,fuse,ramfs,9p

# Set this to yes to allow libvirt_lxc connections to work without SELinux.
#libvirt_lxc_noseclabel = yes

[colors]
#highlight = white
#verbose = blue
#warn = bright purple
#error = red
#debug = dark gray
#deprecate = purple
#skip = cyan
#unreachable = red
#ok = green
#changed = yellow
#diff_add = green
#diff_remove = red
#diff_lines = cyan


[diff]
# Always print diff when running ( same as always running with -D/--diff )
# always = no

# Set how many context lines to show in diff
# context = 3

```









