# Ansible

[TOC]

配置管理系统

![](../../../Image/a/ansible.png)

默认通过  SSH 协议管理。安装之后,不需要启动或运行一个后台进程,或是添加一个数据库。只要在一台电脑(可以是一台笔记本)上安装好,就可以通过这台电脑管理一组远程的机器。无代理软件。

## 特性

- 模块化设计，能够调用特定的模块来完成特定任务 ，本身是核心组件，短小精悍 ；
- 基于**Python语言**实现，由Paramiko (python 的一个可并发连接 ssh 主机功能库 ) , PyYAML和 Jinja2 ( 模板化 ) 三个关键模块实现；
- 部署比较简单，无客户端工具；    
- 以主从模式工作；    
- 支持自定义模块功能；
- 支持playbook，连续任务按先后设置顺序完成；
- 期望每个命令具有**幂等性**

## 指令

### ansible

**场景：**

* 非固化需求
* 临时一次性操作
* 二次开发接口调用

### ansible-galayx

```bash
ansible-galaxy [init | info | install | list | remove] [--help] [options] ...

[init | info | install | list | remove]
   init      初始化本地的Roles配置，以便上传Roles至galaxy
   info      列表指定Role的详细信息
   install   下载并安装galaxy指定的Role到本地
   list      列出本地已下载的Roles
   remove    删除本地已下载的Roles
```

### ansible-pull

```bash
ansible-pull [options] [playbook.yml]
```

### ansible-doc

```bash
ansible-doc [options] [module...]
```

### ansible-playbook

```bash
ansible-playbook playbook.yml
```

### ansible-vault

配置文件加密

```bash
ansible-vault [create | decrypt | edit | encrypt | rekey | view] [--help] [options] file_name
```

### ansible-console

### 测试

编辑(或创建)/etc/ansible/hosts 并在其中加入一个或多个远程系统:

```bash
192.168.1.50
```

现在ping 你的所有节点:

```bash
ansible all -m ping
```

Ansible会像SSH那样试图用你的当前用户名来连接你的远程机器.要覆写远程用户名,只需使用’-u’参数. 如果你想访问 sudo模式,这里也有标识(flags)来实现:

```bash
# as bruce
ansible all -m ping -u bruce
# as bruce, sudoing to root
ansible all -m ping -u bruce --sudo
# as bruce, sudoing to batman
ansible all -m ping -u bruce --sudo --sudo-user batman
```

### 颜色

* 红		执行过程有异常
* 绿        执行过程没有异常
* 橘黄    执行过程没有异常，但目标有状态的变化

## Inventory文件

Ansible 可同时操作属于一个组的多台主机，组和主机之间的关系通过 inventory 文件配置。默认的路径为 /etc/ansible/hosts

除默认文件外,还可以同时使用多个 inventory 文件,也可以从动态源,或云上拉取 inventory 配置信息。

### 主机与组

/etc/ansible/hosts 文件的格式与windows的ini配置文件类似:

```ini
mail.example.com
192.168.11.222
one.example.com:5309

[webservers]
foo.example.com
bar.example.com

[dbservers]
foo.example.com
one.example.com
two.example.com
three.example.com
```

方括号[]中是组名,用于对系统进行分类,便于对不同系统进行个别的管理。

一个系统可以属于不同的组。这时属于两个组的变量都可以为这台主机所用。

如果有主机的SSH端口不是标准的22端口,可在主机名之后加上端口号,用冒号分隔。

```ini
one.example.com:5309
```

假设有一些静态IP地址,希望设置一些别名,但不是在系统的 host 文件中设置,又或者你是通过隧道在连接,那么可以设置如下:

```ini
jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50
```

例子中,通过 “jumper” 别名,会连接 192.168.1.50:5555。一般而言,这不是设置变量的最好方式。

一组相似的 hostname , 可简写如下:

```ini
[webservers]
www[01:50].example.com
```

数字的简写模式中,01:50 也可写为 1:50,意义相同。可以定义字母范围的简写模式:

```ini
[databases]
db-[a:f].example.com
```

对于每一个 host,还可以选择连接类型和连接用户名:

```ini
[targets]
localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_ssh_user=xxxx
```

#### 主机变量

```ini
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
```

#### 组的变量

可以定义属于整个组的变量:

```ini
[atlanta]
host1

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

#### 把一个组作为另一个组的子成员

可以把一个组作为另一个组的子成员,以及分配变量给整个组使用. 这些变量可以给 /usr/bin/ansible-playbook 使用,但不能给 /usr/bin/ansible 使用:

```ini
[atlanta]
host1

[raleigh]
host2

[southeast:children]
atlanta
raleigh

[southeast:vars]
some_server=foo.southeast.example.com
halon_system_timeout=30
```

#### 分文件定义 Host 和 Group 变量

在 inventory 主文件中保存所有的变量并不是最佳的方式.还可以保存在独立的文件中,这些独立文件与 inventory 文件保持关联。不同于 inventory 文件( INI 格式),这些独立文件的格式为 YAML 。

假设 inventory 文件的路径为/etc/ansible/hosts

假设有一个主机名为 ‘foosball’, 主机同时属于两个组,一个是 ‘raleigh’, 另一个是 ‘webservers’. 那么以下配置文件(YAML 格式)中的变量可以为 ‘foosball’ 主机所用.依次为 ‘raleigh’ 的组变量,’webservers’ 的组变量,’foosball’ 的主机变量:

```bash
/etc/ansible/group_vars/raleigh
/etc/ansible/group_vars/webservers
/etc/ansible/host_vars/foosball
```

还有更进一步的运用,你可以为一个主机,或一个组,创建一个目录,目录名就是主机名或组名.目录中的可以创建多个文件, 文件中的变量都会被读取为主机或组的变量.如下 ‘raleigh’ 组对应于 /etc/ansible/group_vars/raleigh/ 目录,其下有两个文件 db_settings 和 cluster_settings, 其中分别设置不同的变量:

```bash
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
从云端拉取 inventory
LDAP（Lightweight Directory Access Protocol,轻量级目录访问协议）
Cobbler <http://cobbler.github.com>
一份昂贵的企业版的 CMDB（配置管理数据库） 软件
```

对于这些需求,Ansible 可通过一个外部 inventory 系统来支持.在 ansible 的 “/plugins”  插件目录下已经含有一些选项 – 包括 EC2/Eucalyptus, Rackspace Cloud,and  OpenStack。

Ansible Tower提供了一个数据库来存储 inventory 配置信息, 这个数据库可以通过 web 访问,或通过 REST 访问。Tower 与所有你使用的 Ansible 动态 inventory 源保持同步,并提供了一个图形化的 inventory 编辑器。有了这个数据库,便可以很容易的关联过去的事件历史,可以看到在上一次 playbook 运行时,哪里出现了运行失败的情况。

### Cobbler 外部 Inventory 脚本

当管理的物理机器到达了一定数量的时,很多使用 Ansible 的用户可能同时也会使用到 Cobbler。

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

使用 AWC EC2时,维护一份 inventory 文件有时不是最好的方法。因为主机的数量有可能发生变动,或者主机是由外部的应用管理的,或者使用了 AWS autoscaling。这时,使用 [EC2 external inventory](https://raw.github.com/ansible/ansible/devel/plugins/inventory/ec2.py) 脚本是更好的选择.

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

## 正则表达式



## 任务执行模式

Ad-Hoc Commands

Playbooks



## Patterns

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

## Playbook

是个 YAML 文件，它将清单文件中的服务器组与命令关联。tasks，可以是一个预期的状态、shell 命令或许多其它的选项。

**示例**，playbook1.yml：

```yaml
---
- hosts: all
  tasks:
    - shell: uptime

--- 是 YAML 文件的开始
- hosts：指定要使用的组
tasks：标记任务列表的开始
- shell：指定第一个任务使用 shell 模块
```

运行：

```bash
ansible-playbook -i inventory playbook1.yml

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
```

运行了 2 个任务。TASK [setup] 是一个隐式任务，它会首先运行以捕获服务器的信息，如主机名、IP、发行版和更多详细信息，然后可以使用这些信息运行条件任务。

PLAY RECAP，显示了运行了多少个任务以及每个对应的状态。

**权限**

需要 root 权限，必须使用 become 语句，playbook2.yml：

```yaml
---
- hosts: webs
  become_user: root
  become: true
  tasks:
    - apt: name=git state=present
```

**name 语句**

可以输出关于正在执行的任务的更具描述性的文本。作为第一行

```yaml
---
- hosts: webs
  become_user: root
  become: true
  tasks:
    - name: This task will make sure git is present on the system
      apt: name=git state=present
```

**使用 with_items**

处理一个列表时，比如要安装的项目和软件包、要创建的文件，可以with_items。

```yaml
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
```

**使用 template 和 vars**

vars 是一个定义变量语句，可以在 task 语句或 template 文件中使用。 Jinja2 是 Ansible 中使用的模板引擎，但是关于它你不需要学习很多。在你的剧本中定义变量，如下所示：

```yaml
---
- hosts: all
  vars:
    - secret_key: VqnzCLdCV9a3jK
    - path_to_vault: /opt/very/deep/path
  tasks:
    - name: Setting a configuration file using template
      template: src=myconfig.j2 dest={{path_to_vault}}/app.conf
```

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


​    
​    

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









### 定义

- 任务task：是工作的最小单位，它可以是个动作，比如“安装一个数据库服务”、“安装一个 web 服务器”、“创建一条防火墙规则”或者“把这个配置文件拷贝到那个服务器上去”。
- 动作play： 由任务组成，例如，一个动作的内容是要“设置一个数据库，给 web 服务用”，这就包含了如下任务：1）安装数据库包；2）设置数据库管理员密码；3）创建数据库实例；4）为该实例分配权限。
- 剧本playbook：由动作组成，一个剧本可能像这样：“设置我的网站，包含后端数据库”，其中的动作包括：1）设置数据库服务器；2）设置 web 服务器。
- 角色role：用来保存和组织剧本，以便分享和再次使用它们。还拿上个例子来说，如果你需要一个全新的 web 服务器，就可以用别人已经写好并分享出来的角色来设置。因为角色是高度可配置的（如果编写正确的话），可以根据部署需求轻松地复用它们。
- [Ansible 星系](https://galaxy.ansible.com/)Ansible Galaxy：是一个在线仓库，里面保存的是由社区成员上传的角色，方便彼此分享。它与 GitHub 紧密集成，因此这些角色可以先在 Git 仓库里组织好，然后通过 Ansible 星系分享出来。

这些定义以及它们之间的关系可以用下图来描述：

![img](https://img.linux.net.cn/data/attachment/album/201903/08/092456wmzneaoarvh9yas6.png)

请注意上面的例子只是组织任务的方式之一，我们当然也可以把安装数据库和安装 web 服务器的剧本拆开，放到不同的角色里。Ansible 星系上最常见的角色是独立安装、配置每个应用服务，你可以参考这些安装 [mysql](https://galaxy.ansible.com/bennojoy/mysql/) 和 [httpd](https://galaxy.ansible.com/xcezx/httpd/) 的例子。



- 在测试的时候少选几台服务器，这样你的动作可以执行的更快一些。如果它们在一台机器上执行成功，在其他机器上也没问题。
- 总是在真正运行前做一次测试dry run，以确保所有的命令都能正确执行（要运行测试，加上 `--check-mode` 参数 ）。
- 尽可能多做测试，别担心搞砸。任务里描述的是所需的状态，如果系统已经达到预期状态，任务会被简单地忽略掉。
- 确保在 `/etc/ansible/hosts` 里定义的主机名都可以被正确解析。
- 因为是用 SSH  与远程主机通信，主控节点必须要能接受密钥，所以你面临如下选择：1）要么在正式使用之前就做好与远程主机的密钥交换工作；2）要么在开始管理某台新的远程主机时做好准备输入 “Yes”，因为你要接受对方的 SSH 密钥交换请求。
- 尽管你可以在同一个剧本内把不同 Linux 发行版的任务整合到一起，但为每个发行版单独编写剧本会更明晰一些。



Ansible 是你在数据中心里实施运维自动化的好选择，因为它：

- 无需客户端，所以比其他自动化工具更易安装。
- 将指令保存在 YAML 文件中（虽然也支持 JSON），比写 shell 脚本更简单。
- 开源，因此你也可以做出自己的贡献，让它更加强大！