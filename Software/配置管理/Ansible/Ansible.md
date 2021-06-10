# Ansible

[TOC]

## 架构

![](../../../Image/a/ansible.png)

默认通过  SSH 协议管理。安装之后,不需要启动或运行一个后台进程,或是添加一个数据库。只要在一台电脑(可以是一台笔记本)上安装好,就可以通过这台电脑管理一组远程的机器。无代理软件。
- **INVENTORY：** Ansible管理主机的清单`/etc/anaible/hosts`。
- **MODULES：**     Ansible执行命令的功能模块，多数为内置核心模块，也可自定义。
- **PLUGINS：**       模块功能的补充，如连接类型插件、循环插件、变量插件、过滤插件等，该功能不常用。
- **API：**                 供第三方程序调用的应用程序编程接口。

### Ansible 命令执行来源

- USER 普通用户，即SYSTEM ADMINISTRATOR。
- PLAYBOOKS任务剧本（任务集），编排定义Ansible任务集的配置文件，由Ansible顺序依次执行，通常是JSON格式的YML文件。
- CMDB（配置管理数据库） API 调用。
- PUBLIC/PRIVATE CLOUD API调用。

### 注意事项

- 执行ansible的主机一般称为主控端，中控，master或堡垒机。
- 主控端Python版本需要2.6或以上。
- 被控端Python版本小于2.4，需要安装python-simplejson。
- 被控端如开启SELinux需要安装libselinux-python。
- windows 不能做为主控端。

## 特性

- 模块化设计，能够调用特定的模块来完成特定任务 ，本身是核心组件，短小精悍 ；
- 基于**Python语言**实现，由Paramiko (python 的一个可并发连接 ssh 主机功能库 ) , PyYAML和 Jinja2 ( 模板化 ) 三个关键模块实现；
- 部署比较简单，无客户端工具；    
- 以主从模式工作；    
- 支持自定义模块功能；
- 支持playbook，连续任务按先后设置顺序完成；
- 期望每个命令具有**幂等性**

## 利用ansible实现管理的主要方式

- Ad-Hoc 即利用ansible命令，主要用于临时命令使用场景。
- Ansible-playbook 主要用于长期规划好的，大型项目的场景，需要有前期的规划过程 。

## 相关工具

- /usr/bin/ansible                        主程序，临时命令执行工具。
- /usr/bin/ansible-doc                 查看配置文档，模块功能查看工具。
- /usr/bin/ansible-galaxy            下载/上传优秀代码或Roles模块的官网平台。
- /usr/bin/ansible-playbook        定制自动化任务，编排剧本工具。
- /usr/bin/ansible-pull                 远程执行命令的工具。
- /usr/bin/ansible-vault               文件加密工具。
- /usr/bin/ansible-console          基于Console界面与用户交互的执行工具。

### ansible-doc

用来显示模块帮助。

```bash
ansible-doc [options] [module...]
-l, --list          #列出可用模块
-s, --snippet       #显示指定模块的playbook片段
```

**范例：**

```bash
#列出所有模块
ansible-doc -l  
#查看指定模块帮助用法
ansible-doc ping  
#查看指定模块帮助用法
ansible-doc -s  ping 
```

### ansible

**场景：**

* 非固化需求
* 临时一次性操作
* 二次开发接口调用

通过ssh协议，实现对远程主机的配置管理、应用部署、任务执行等功能。

**建议：**使用此工具前，先配置ansible主控端能基于密钥认证的方式联系各个被管理节点

利用sshpass批量实现基于key验证

```bash
#!/bin/bash
ssh-keygen -f /root/.ssh/id_rsa  -P ''
NET=192.168.100
export SSHPASS=magedu
for IP in {1..200};do 
    sshpass -e ssh-copy-id  NET.IP 
done
```

**格式：**

```bash
ansible <host-pattern> [-m module_name] [-a args]

--version               #显示版本
-m module               #指定模块，默认为command
-v                      #详细过程 –vv  -vvv更详细
--list-hosts            #显示主机列表，可简写 --list
-k, --ask-pass          #提示输入ssh连接密码，默认Key验证    
-C, --check             #检查，并不执行
-T, --timeout=TIMEOUT   #执行命令的超时时间，默认10s
-u, --user=REMOTE_USER  #执行远程执行的用户
-b, --become            #代替旧版的sudo 切换
--become-user=USERNAME  #指定sudo的runas用户，默认为root
-K, --ask-become-pass   #提示输入sudo时的口令
```

#### Host-pattern

 用于匹配被控制的主机的列表

**All ：表示所有Inventory中的所有主机**

```bash
ansible all –m ping
```

**通配符  ***

```bash
ansible  “*”  -m ping 
ansible  192.168.1.* -m ping
ansible  “srvs”  -m ping
```

**或关系  ：** 

```
ansible “websrvs:appsrvs”  -m ping 
ansible “192.168.1.10:192.168.1.20”  -m ping
```

**逻辑与  ：&**

```bash
#在websrvs组并且在dbsrvs组中的主机
ansible “websrvs:&dbsrvs” –m ping
```

**逻辑非  ：！**

```bash
#在websrvs组，但不在dbsrvs组中的主机
#注意：此处为单引号
ansible ‘websrvs:!dbsrvs’ –m ping 
```

**综合逻辑**

```bash
ansible ‘websrvs:dbsrvs:&appsrvs:!ftpsrvs’ –m ping
```

**正则表达式**

```bash
ansible “websrvs:dbsrvs” –m ping 
ansible “~(web|db).*\.magedu\.com” –m ping 
```

#### 命令执行过程

1. 加载自己的配置文件，默认`/etc/ansible/ansible.cfg` 。
2. 加载自己对应的模块文件，如：command 。
3. 通过ansible将模块或命令生成对应的临时py文件，并将该文件传输至远程服务器的对应执行用户目录下，如`$HOME/.ansible/tmp/ansible-tmp-数字/XXX.PY` 。
4. 给文件+x执行权限。
5. 执行并返回结果。
6. 删除临时py文件，退出。

#### 执行状态

```bash
grep -A 14 '\[colors\]' /etc/ansible/ansible.cfg 

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
```

- 绿色：执行成功并且不需要做改变的操作
- 黄色：执行成功并且对目标主机做变更
- 红色：执行失败

### ansible-playbook

此工具用于执行编写好的 playbook 任务。

```bash
ansible-playbook <filename.yml> ... [options]

-C --check          #只检测可能会发生的改变，但不真正执行操作
--list-hosts        #列出运行任务的主机
--list-tags         #列出tag
--list-tasks        #列出task
--limit 主机列表      #只针对主机列表中的主机执行
-v -vv  -vvv        #显示过程
```

范例

```bash
ansible-playbook  file.yml  --check               #只检测
ansible-playbook  file.yml  
ansible-playbook  file.yml  --limit websrvs
```

### ansible-pull

```bash
ansible-pull [options] [playbook.yml]
```

### ansible-vault

此工具可以用于加密解密yml文件

```bash
ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

**范例：**

```bash
ansible-vault encrypt hello.yml     #加密
ansible-vault decrypt hello.yml     #解密
ansible-vault view hello.yml        #查看
ansible-vault edit  hello.yml       #编辑加密文件
ansible-vault rekey  hello.yml      #修改口令
ansible-vault create new.yml        #创建新文件
```

### ansible-console

此工具可交互执行命令，支持tab，ansible 2.0+新增

**提示符格式：**

```
执行用户@当前操作的主机组 (当前组的主机数量)[f:并发数]$
```

**常用子命令：**

- 设置并发数： forks n  例如： forks 10
- 切换组： cd 主机组  例如： cd web
- 列出当前组主机列表： list
- 列出所有的内置命令： ?或help

```bash
ansible-console
Welcome to the ansible console.
Type help or ? to list commands.

root@all (3)[f:5]list
10.0.0.8
10.0.0.7
10.0.0.6
root@all (3)[f:5] cd websrvs
root@websrvs (2)[f:5]list
10.0.0.7
10.0.0.8
root@websrvs (2)[f:5] forks 10
root@websrvs (2)[f:10]cd appsrvs
root@appsrvs (2)[f:5] yum name=httpd state=present
root@appsrvs (2)[f:5]$ service name=httpd state=started
```

### ansible-galaxy

此工具会连接 [https://galaxy.ansible.com](http://www.yunweipai.com/go?_=ae1f7f3df2aHR0cHM6Ly9nYWxheHkuYW5zaWJsZS5jb20=) 下载相应的roles。

```bash
ansible-galaxy [init | info | install | list | remove] [--help] [options] ...

[init | info | install | list | remove]
   init      初始化本地的Roles配置，以便上传Roles至galaxy
   info      列表指定Role的详细信息
   install   下载并安装galaxy指定的Role到本地
   list      列出本地已下载的Roles
   remove    删除本地已下载的Roles

#列出所有已安装的galaxy
ansible-galaxy list
#安装galaxy
ansible-galaxy install geerlingguy.mysql
ansible-galaxy install geerlingguy.redis
#删除galaxy
ansible-galaxy remove geerlingguy.redis
```

## Playbook

![Ansible-Playbook详解插图](http://www.yunweipai.com/wp-content/uploads/2020/06/image-20191102181113906-780x281.png)

**playbook** 是由一个或多个play组成的列表。

**play**的主要功能在于将预定义的一组主机，装扮成事先通过ansible中的task定义好的角色。

**Task**实际是调用ansible的一个module，将多个play组织在一个playbook中，即可以让它们联合起来，按事先编排的机制执行预定义的动作。是工作的最小单位。

**Playbook 文件**是采用YAML语言编写的。

### 核心元素

- Hosts   执行的远程主机列表
- Tasks   任务集
- Variables 内置变量或自定义变量在playbook中调用
- Templates  模板，可替换模板文件中的变量并实现一些简单逻辑的文件
- Handlers  和 notify 结合使用，由特定条件触发的操作，满足条件方才执行，否则不执行
- tags 标签   指定某条任务执行，用于选择运行playbook中的部分代码。ansible具有幂等性，因此会自动跳过没有变化的部分，即便如此，有些代码为测试其确实没有发生变化的时间依然会非常地长。此时，如果确信其没有变化，就可以通过tags跳过此些代码片断

![](../../../Image/a/ansible_galaxy.png)

#### hosts 组件

playbook中的每一个play的目的都是为了让特定主机以某个指定的用户身份执行任务。hosts用于指定要执行指定任务的主机，须事先定义在主机清单中

```bash
one.example.com
one.example.com:two.example.com
192.168.1.50
192.168.1.*
Websrvs:dbsrvs      #或者，两个组的并集
Websrvs:&dbsrvs     #与，两个组的交集
webservers:!phoenix  #在websrvs组，但不在dbsrvs组
```

案例：

```yaml
- hosts: websrvs:appsrvs
```

#### remote_user 组件

可用于Host和task中。也可以通过指定其通过sudo的方式在远程主机上执行任务，其可用于play全局或某任务；此外，甚至可以在sudo时使用sudo_user指定sudo时切换的用户

```yaml
---
- hosts: websrvs
  remote_user: root
  become_user: root
  become: true

  tasks:
    - name: test connection
      ping:
      remote_user: xu
      sudo: yes                 #默认sudo为root
      sudo_user:wang            #sudo为wang
```

#### task列表和action组件

play的主体部分是task list，task list中有一个或多个task。各个task 按次序逐个在hosts中指定的所有主机上执行，即在所有主机上完成第一个task后，再开始第二个task。

task的目的是使用指定的参数执行模块，而在模块参数中可以使用变量。模块执行是幂等的，这意味着多次执行是安全的，因为其结果均一致。

每个task都应该有其name，用于playbook的执行结果输出，建议其内容能清晰地描述任务执行步骤。如果未提供name，则action的结果将用于输出

**task两种格式：**

 (1) action: module arguments
 (2) module: arguments      建议使用

注意：shell和command模块后面跟命令，而非key=value

范例：

```yaml
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: install httpd
      yum: name=httpd 
    - name: start httpd
      service: name=httpd state=started enabled=yes
```

#### 其它组件

某任务的状态在运行后为changed时，可通过“notify”通知给相应的handlers。

任务可以通过"tags“打标签，可在ansible-playbook命令上使用-t指定进行调用。

#### ShellScripts VS  Playbook 案例

```yaml
#SHELL脚本实现
#!/bin/bash
# 安装Apache
yum install --quiet -y httpd 
# 复制配置文件
cp /tmp/httpd.conf /etc/httpd/conf/httpd.conf
cp/tmp/vhosts.conf /etc/httpd/conf.d/
# 启动Apache，并设置开机启动
systemctl enable --now httpd 

#Playbook实现
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: "安装Apache"
      yum: name=httpd
    - name: "复制配置文件"
      copy: src=/tmp/httpd.conf dest=/etc/httpd/conf/
    - name: "复制配置文件"
      copy: src=/tmp/vhosts.conf dest=/etc/httpd/conf.d/
    - name: "启动Apache，并设置开机启动"
      service: name=httpd state=started enabled=yes
```

### Playbook 初步

#### 创建 mysql 用户

```yaml
---
- hosts: dbsrvs
  remote_user: root

  tasks:
    - {name: create group, group: name=mysql system=yes gid=306}
    - name: create user
      user: name=mysql shell=/sbin/nologin system=yes group=mysql uid=306 home=/data/mysql create_home=no
```

#### 安装 nginx

```yaml
---
- hosts: websrvs
  remote_user: root  
  tasks:
    - name: add group nginx
      user: name=nginx state=present
      # !!!!!!!!此处可能不对 #
    - name: add user nginx
      user: name=nginx state=present group=nginx
    - name: Install Nginx
      yum: name=nginx state=present
    - name: web page
      copy: src=files/index.html dest=/usr/share/nginx/html/index.html
    - name: Start Nginx
      service: name=nginx state=started enabled=yes
```

#### 安装和卸载 httpd

```yaml
---
- hosts: websrvs
  remote_user: root
  gather_facts: no

  tasks:
    - name: Install httpd
      yum: name=httpd state=present
    - name: Install configure file
      copy: src=files/httpd.conf dest=/etc/httpd/conf/
    - name: web html
      copy: src=files/index.html  dest=/var/www/html/
    - name: start service
      service: name=httpd state=started enabled=yes
```

```yaml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: remove httpd package
      yum: name=httpd state=absent
    - name: remove apache user 
      user: name=apache state=absent
    - name: remove config file
      file: name=/etc/httpd  state=absent
    - name: remove web html
      file: name=/var/www/html/index.html state=absent
```

#### 安装mysql

**范例：安装mysql-5.6.46-linux-glibc2.12**

```bash
ls -l /data/ansible/files/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz 
-rw-r--r-- 1 root root 403177622 Dec  4 13:05 /data/ansible/files/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz

cat /data/ansible/files/my.cnf 
[mysqld]
socket=/tmp/mysql.sock
user=mysql
symbolic-links=0
datadir=/data/mysql
innodb_file_per_table=1
log-bin
pid-file=/data/mysql/mysqld.pid

[client]
port=3306
socket=/tmp/mysql.sock

[mysqld_safe]
log-error=/var/log/mysqld.log

cat /data/ansible/files/secure_mysql.sh 
#!/bin/bash
/usr/local/mysql/bin/mysql_secure_installation <<EOF

y
ma
ma
y
y
y
y
EOF

tree /data/ansible/files/
/data/ansible/files/
├── my.cnf
├── mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
└── secure_mysql.sh

0 directories, 3 files

cat /data/ansible/install_mysql.yml
---
# install mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
- hosts: dbsrvs
  remote_user: root
  gather_facts: no

  tasks:
    - name: install packages
      yum: name=libaio,perl-Data-Dumper,perl-Getopt-Long
    - name: create mysql group
      group: name=mysql gid=306 
    - name: create mysql user
      user: name=mysql uid=306 group=mysql shell=/sbin/nologin system=yes create_home=no home=/data/mysql
    - name: copy tar to remote host and file mode 
      unarchive: src=/data/ansible/files/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz dest=/usr/local/ owner=root group=root 
    - name: create linkfile  /usr/local/mysql 
      file: src=/usr/local/mysql-5.6.46-linux-glibc2.12-x86_64 dest=/usr/local/mysql state=link
    - name: data dir
      shell: chdir=/usr/local/mysql/  ./scripts/mysql_install_db --datadir=/data/mysql --user=mysql
      tags: data
    - name: config my.cnf
      copy: src=/data/ansible/files/my.cnf  dest=/etc/my.cnf 
    - name: service script
      shell: /bin/cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
    - name: enable service
      shell: /etc/init.d/mysqld start;chkconfig --add mysqld;chkconfig mysqld on  
      tags: service
    - name: PATH variable
      copy: content='PATH=/usr/local/mysql/bin:$PATH' dest=/etc/profile.d/mysql.sh
    - name: secure script
      script: /data/ansible/files/secure_mysql.sh
      tags: script
```

**范例：install_mariadb.yml**

```bash
---
#Installing MariaDB Binary Tarballs
- hosts: dbsrvs
  remote_user: root
  gather_facts: no

  tasks:
    - name: create group
      group: name=mysql gid=27 system=yes
    - name: create user
      user: name=mysql uid=27 system=yes group=mysql shell=/sbin/nologin home=/data/mysql create_home=no
    - name: mkdir datadir
      file: path=/data/mysql owner=mysql group=mysql state=directory
    - name: unarchive package
      unarchive: src=/data/ansible/files/mariadb-10.2.27-linux-x86_64.tar.gz dest=/usr/local/ owner=root group=root
    - name: link
      file: src=/usr/local/mariadb-10.2.27-linux-x86_64 path=/usr/local/mysql state=link 
    - name: install database
      shell: chdir=/usr/local/mysql   ./scripts/mysql_install_db --datadir=/data/mysql --user=mysql
    - name: config file
      copy: src=/data/ansible/files/my.cnf  dest=/etc/ backup=yes
    - name: service script
      shell: /bin/cp  /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
    - name: start service
      service: name=mysqld state=started enabled=yes
    - name: PATH variable
      copy: content='PATH=/usr/local/mysql/bin:$PATH' dest=/etc/profile.d/mysql.sh
```

### 使用变量

**变量名：**仅能由字母、数字和下划线组成，且只能以字母开头。

**变量定义：**

```yaml
variable=value
```

**变量调用方式：**

通过`{{ variable_name }} `调用变量，且变量名前后建议加空格，有时用“{{ variable_name }}”才生效

**变量来源：**

1. ansible 的 setup facts 远程主机的所有变量都可直接调用。

2. 通过命令行指定变量，优先级最高。

   ```bash
   ansible-playbook -e varname=value
   ```

3. 在playbook文件中定义。

   ```yaml
   vars:
     - var1: value1
     - var2: value2
   ```

4. 在独立的变量YAML文件中定义。

   ```yaml
   - hosts: all
        vars_files:
          - vars.yml
   ```

5. 在 /etc/ansible/hosts 中定义

​        主机（普通）变量：主机组中主机单独定义，优先级高于公共变量。

​        组（公共）变量：针对主机组中所有主机定义统一变量。

6. 在role中定义

#### 使用 setup 模块中变量

本模块自动在playbook调用，不要用ansible命令调用。

```yaml
---
#var.yml
- hosts: all
  remote_user: root
  gather_facts: yes

  tasks:
    - name: create log file
      file: name=/data/{{ ansible_nodename }}.log state=touch owner=wang mode=600

ansible-playbook  var.yml
```

#### 在playbook 命令行中定义变量

```yaml
vim var2.yml
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: install package
      yum: name={{ pkname }} state=present

ansible-playbook  –e pkname=httpd  var2.yml
```

#### 在playbook文件中定义变量

```yaml
vim var3.yml
---
- hosts: websrvs
  remote_user: root
  vars:
    - username: user1
    - groupname: group1

  tasks:
    - name: create group
      group: name={{ groupname }} state=present
    - name: create user
      user: name={{ username }} group={{ groupname }} state=present

ansible-playbook -e "username=user2 groupname=group2”  var3.yml
```

#### 使用变量文件

可以在一个独立的playbook文件中定义变量，在另一个playbook文件中引用变量文件中的变量，比playbook中定义的变量优化级高。

```bash
vim vars.yml
---
# variables file
package_name: mariadb-server
service_name: mariadb

vim  var4.yml
---
#install package and start service
- hosts: dbsrvs
  remote_user: root
  vars_files:
    - /root/vars.yml

  tasks:
    - name: install package
      yum: name={{ package_name }}
      tags: install
    - name: start service
      service: name={{ service_name }} state=started enabled=yes
```

范例：

```yaml
cat  vars2.yml
---
var1: httpd
var2: nginx

cat  var5.yml
---         
- hosts: web
  remote_user: root
  vars_files:
    - vars2.yml

   tasks:
     - name: create httpd log
       file: name=/app/{{ var1 }}.log state=touch
     - name: create nginx log
       file: name=/app/{{ var2 }}.log state=touch   
```

#### 主机清单文件中定义变量

##### 主机变量

在inventory 主机清单文件中为指定的主机定义变量以便于在playbook中使用。

```yaml
[websrvs]
www1.magedu.com http_port=80 maxRequestsPerChild=808
www2.magedu.com http_port=8080 maxRequestsPerChild=909
```

##### 组（公共）变量

在inventory 主机清单文件中赋予给指定组内所有主机上的在playbook中可用的变量，如果和主机变是同名，优先级低于主机变量。

```yaml
[websrvs]
www1.magedu.com
www2.magedu.com

[websrvs:vars]
ntp_server=ntp.magedu.com
nfs_server=nfs.magedu.com
```

### template 模板

模板是一个文本文件，可以做为生成文件的模版，并且模板文件中还可嵌套jinja语法。可以根据和参考模块文件，动态生成相类似的配置文件。

template文件必须存放于templates目录下，且命名为 .j2 结尾。

yaml/yml 文件需和templates目录平级，目录结构如下示例：

```bash
 ./ 
  ├── temnginx.yml 
  └── templates 
  └── nginx.conf.j2
```

范例：利用template 同步nginx配置文件

```yaml
#准备templates/nginx.conf.j2文件
vim temnginx.yml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: template config to remote hosts
      template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf

 ansible-playbook temnginx.yml
```

**变更替换**

```yaml
#修改文件nginx.conf.j2 
mkdir templates
vim templates/nginx.conf.j2
worker_processes {{ ansible_processor_vcpus }};

vim temnginx2.yml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: install nginx
      yum: name=nginx
    - name: template config to remote hosts
      template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf 
    - name: start service
      service: name=nginx state=started enable=yes

ansible-playbook temnginx2.yml
```

**算术运算**

范例：

```jinja2
vim nginx.conf.j2 
worker_processes {{ ansible_processor_vcpus**2 }};    
worker_processes {{ ansible_processor_vcpus+2 }}; 
```

范例：

```yaml
vim templates/nginx.conf.j2
worker_processes {{ ansible_processor_vcpus**3 }};

cat templnginx.yml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: install nginx
      yum: name=nginx
    - name: template config to remote hosts
      template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf
      notify: restart nginx
    - name: start service
      service: name=nginx state=started enabled=yes

  handlers:
    - name: restart nginx
      service: name=nginx state=restarted

ansible-playbook  templnginx.yml
```

#### 使用流程控制 for 和 if

template中也可以使用流程控制 for 循环和 if 条件判断，实现动态生成文件功能。

```yaml
#temlnginx2.yml
---
- hosts: websrvs
  remote_user: root
  vars:
    nginx_vhosts:
      - 81
      - 82
      - 83
  tasks:
    - name: template config
      template: src=nginx.conf.j2 dest=/data/nginx.conf

#templates/nginx.conf2.j2
{% for vhost in  nginx_vhosts %}
server {
   listen {{ vhost }}
}
{% endfor %}

ansible-playbook -C  templnginx2.yml

#生成的结果：
server {
   listen 81   
}
server {
   listen 82   
}
server {
   listen 83   
}
```

范例：

```yaml
#temlnginx3.yml
---
- hosts: websrvs
  remote_user: root
  vars:
    nginx_vhosts:
      - listen: 8080
  tasks:
    - name: config file
      template: src=nginx.conf3.j2 dest=/data/nginx3.conf

#templates/nginx.conf3.j2
{% for vhost in nginx_vhosts %}   
server {
  listen {{ vhost.listen }}
}
{% endfor %}

ansible-playbook   templnginx3.yml

#生成的结果
server {
  listen 8080  
}
```

范例：

```yaml
#templnginx4.yml
- hosts: websrvs
  remote_user: root
  vars:
    nginx_vhosts:
      - listen: 8080
        server_name: "web1.magedu.com"
        root: "/var/www/nginx/web1/"
      - listen: 8081
        server_name: "web2.magedu.com"
        root: "/var/www/nginx/web2/"
      - {listen: 8082, server_name: "web3.magedu.com", root: "/var/www/nginx/web3/"}
  tasks:
    - name: template config 
      template: src=nginx.conf4.j2 dest=/data/nginx4.conf

# templates/nginx.conf4.j2
{% for vhost in nginx_vhosts %}
server {
   listen {{ vhost.listen }}
   server_name {{ vhost.server_name }}
   root {{ vhost.root }}  
}
{% endfor %}

ansible-playbook  templnginx4.yml

#生成结果：
server {
    listen 8080
    server_name web1.magedu.com
    root /var/www/nginx/web1/  
}
server {
    listen 8081
    server_name web2.magedu.com
    root /var/www/nginx/web2/  
}
server {
    listen 8082
    server_name web3.magedu.com
    root /var/www/nginx/web3/  
} 
```

在模版文件中还可以使用 if条件判断，决定是否生成相关的配置信息。

```yaml
#templnginx5.yml
- hosts: websrvs
  remote_user: root
  vars:
    nginx_vhosts:
      - web1:
        listen: 8080
        root: "/var/www/nginx/web1/"
      - web2:
        listen: 8080
        server_name: "web2.magedu.com"
        root: "/var/www/nginx/web2/"
      - web3:
        listen: 8080
        server_name: "web3.magedu.com"
        root: "/var/www/nginx/web3/"
  tasks:
    - name: template config to 
      template: src=nginx.conf5.j2 dest=/data/nginx5.conf

#templates/nginx.conf5.j2
{% for vhost in  nginx_vhosts %}
server {
   listen {{ vhost.listen }}
   {% if vhost.server_name is defined %}
server_name {{ vhost.server_name }}
   {% endif %}
root  {{ vhost.root }}
}
{% endfor %}

#生成的结果
server {
   listen 8080
   root  /var/www/nginx/web1/
}
server {
   listen 8080
   server_name web2.magedu.com
   root  /var/www/nginx/web2/
}
server {
   listen 8080
   server_name web3.magedu.com
   root  /var/www/nginx/web3/
}
```

### 使用 when

when语句，可以实现条件测试。如果需要根据变量、facts或此前任务的执行结果来做为某task执行与否的前提时要用到条件测试,通过在task后添加when子句即可使用条件测试，jinja2的语法格式。

```yaml
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: "shutdown RedHat flavored systems"
      command: /sbin/shutdown -h now
      when: ansible_os_family == "RedHat"
```

范例：

```yaml
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: add group nginx
      tags: user
      user: name=nginx state=present
    - name: add user nginx
      user: name=nginx state=present group=nginx
    - name: Install Nginx
      yum: name=nginx state=present
    - name: restart Nginx
      service: name=nginx state=restarted
      when: ansible_distribution_major_version == “6”
```

范例：

```yaml
---
- hosts: websrvs
  remote_user: root
  tasks: 
    - name: install conf file to centos7
      template: src=nginx.conf.c7.j2 dest=/etc/nginx/nginx.conf
      when: ansible_distribution_major_version == "7"
    - name: install conf file to centos6
      template: src=nginx.conf.c6.j2 dest=/etc/nginx/nginx.conf
      when: ansible_distribution_major_version == "6"
```

### 使用迭代 with_items

当有需要重复性执行的任务时，可以使用迭代机制。

对迭代项的引用，固定变量名为”item“。

要在task中使用with_items给定要迭代的元素列表。

**列表元素格式：**

- 字符串
- 字典

```yaml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: add several users
      user: name={{ item }} state=present groups=wheel
      with_items:
        - testuser1
        - testuser2
#上面语句的功能等同于下面的语句
    - name: add user testuser1
      user: name=testuser1 state=present groups=wheel
    - name: add user testuser2
      user: name=testuser2 state=present groups=wheel
```

范例：

```yaml
---
#remove mariadb server
- hosts: appsrvs:!192.168.38.8
  remote_user: root

  tasks:
    - name: stop service
      shell: /etc/init.d/mysqld stop
    - name:  delete files and dir
      file: path={{item}} state=absent
      with_items:
        - /usr/local/mysql
        - /usr/local/mariadb-10.2.27-linux-x86_64
        - /etc/init.d/mysqld
        - /etc/profile.d/mysql.sh
        - /etc/my.cnf
        - /data/mysql
    - name: delete user
      user: name=mysql state=absent remove=yes 
```

范例：

```yaml
---
- hosts：websrvs
  remote_user: root

  tasks
    - name: install some packages
      yum: name={{ item }} state=present
      with_items:
        - nginx
        - memcached
        - php-fpm 
```

范例：

```bash
---
- hosts: websrvs
  remote_user: root
  tasks:
    - name: copy file
      copy: src={{ item }} dest=/tmp/{{ item }}
      with_items:
        - file1
        - file2
        - file3
    - name: yum install httpd
      yum: name={{ item }}  state=present 
      with_items:
        - apr
        - apr-util
        - httpd
```

**迭代嵌套子变量：**在迭代中，还可以嵌套子变量，关联多个变量在一起使用

示例：

```yaml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: add some groups
      group: name={{ item }} state=present
      with_items:
        - nginx
        - mysql
        - apache
    - name: add some users
      user: name={{ item.name }} group={{ item.group }} state=present
      with_items:
        - { name: 'nginx', group: 'nginx' }
        - { name: 'mysql', group: 'mysql' }
        - { name: 'apache', group: 'apache' }
```

范例：

```yaml
---
- hosts: websrvs
  remote_user: root

  tasks:
    - name: add some groups
      group: name={{ item }} state=present
      with_items:
        - g1
        - g2
        - g3
    - name: add some users
      user: name={{ item.name }} group={{ item.group }} home={{ item.home }} create_home=yes state=present
      with_items:
        - { name: 'user1', group: 'g1', home: '/data/user1' }
        - { name: 'user2', group: 'g2', home: '/data/user2' }
        - { name: 'user3', group: 'g3', home: '/data/user3' }
```

### 管理节点过多导致的超时问题解决方法

默认情况下，Ansible将尝试并行管理playbook中所有的机器。对于滚动更新用例，可以使用serial关键字定义Ansible一次应管理多少主机，还可以将serial关键字指定为百分比，表示每次并行执行的主机数占总数的比例。

```yaml
---
- hosts: all
  serial: 2  #每次只同时处理2个主机
  gather_facts: False

  tasks:
    - name: task one
      comand: hostname
    - name: task two
      command: hostname
```

范例：

```yaml
- name: test serail
  hosts: all
  serial: "20%"   #每次只同时处理20%的主机
```

### roles角色

用于层次性、结构化地组织playbook。

roles能够根据层次型结构自动装载变量文件、tasks以及handlers等。要使用roles只需要在playbook中使用include指令即可。简单来讲，roles就是通过分别将变量、文件、任务、模板及处理器放置于单独的目录中，并可以便捷地include它们的一种机制。

角色一般用于基于主机构建服务的场景中，但也可以是用于构建守护进程等场景中运维复杂的场景：建议使用roles，代码复用度高。

roles：多个角色的集合， 可以将多个的role，分别放至roles目录下的独立子目录中。

#### Ansible Roles目录编排

![](../../../Image/a/ansible_role.png)

每个角色，以特定的层级目录结构进行组织。

**roles目录结构：**

```bash
tree ansible_playbooks/

ansible_playbooks/
└── roles                          # 必须叫roles
    ├── dbsrvs                     # role名称
        ├── defaults               # 必须存在的目录，存放默认的变量，模板文件中的变量就是引用自这里。其变量优先级最低，可以临时指定变量来进行覆盖。
        │   └── main.yml
        ├── files                  # ansible中unarchive、copy等模块会自动来这里找文件，从而不必写绝对路径，只需写文件名。
        │   └── nginx.tar.gz
        ├── handlers               # 存放tasks中的notify指定的内容。
        │   └── main.yml
        ├── meta                   # 定义当前角色的特殊设定及其依赖关系
        │   └── main.yml        
        ├── tasks                  # 存放playbook的目录，其中main.yml是主入口文件，在main.yml中导入其他yml文件，要采用import_tasks关键字。
        │   └── main.yml           # 主入口文件。
        ├── templates              # 存放模板文件。template模块会将模板文件中的变量替换为实际值，然后覆盖到客户机指定路径上。
        │   └── nginx.conf.j2
        └── vars                   # 定义变量
            └── main.yml
```

#### 创建 role

1. 创建以roles命名的目录。
2. 在roles目录中分别创建以各角色名称命名的目录。
3. 在每个角色命名的目录中分别创建files、handlers、meta、tasks、templates和vars目录；用不到的目录可以创建为空目录，也可以不创建。
4. 在playbook文件中，调用各角色。

#### playbook调用角色

**调用角色方法1：**

```yaml
---
- hosts: websrvs
  remote_user: root
  roles:
    - mysql
    - memcached
    - nginx   
```

**调用角色方法2：**

键role用于指定角色名称，后续的k/v用于传递变量给角色。

```yaml
---
- hosts: all
  remote_user: root
  roles:
    - mysql
    - { role: nginx, username: nginx }
```

**调用角色方法3：**

可基于条件测试实现角色调用。

```yaml
---
- hosts: all
  remote_user: root
  roles:
    - { role: nginx, username: nginx, when: ansible_distribution_major_version == ‘7’  }
```

#### tags 的使用

```yaml
#nginx-role.yml
---
- hosts: websrvs
  remote_user: root
  roles:
    - { role: nginx ,tags: [ 'nginx', 'web' ] ,when: ansible_distribution_major_version == "6“ }
    - { role: httpd ,tags: [ 'httpd', 'web' ]  }
    - { role: mysql ,tags: [ 'mysql', 'db' ] }
    - { role: mariadb ,tags: [ 'mariadb', 'db' ] }

ansible-playbook --tags="nginx,httpd,mysql" nginx-role.yml
```

#### 实战案例

##### 案例1：实现 httpd 角色

```yaml
#创建角色相关的目录
mkdir -pv /data/ansible/roles/httpd/{tasks,handlers,files}

#创建角色相关的文件
cd /data/ansible/roles/httpd/

vim tasks/main.yml
- include: group.yml
- include: user.yml
- include: install.yml
- include: config.yml
- include: index.yml
- include: service.yml

vim  tasks/user.yml
- name: create apache user
  user: name=apache system=yes shell=/sbin/nologin home=/var/www/ uid=80 group=apache

vim  tasks/group.yml
- name: create apache group
  group: name=apache system=yes gid=80

vim tasks/install.yml
- name: install httpd package
  yum: name=httpd

vim tasks/config.yml
- name: config file
  copy: src=httpd.conf dest=/etc/httpd/conf/ backup=yes
  notify: restart

vim tasks/index.yml
- name: index.html
  copy: src=index.html dest=/var/www/html/

vim tasks/service.yml
- name: start service
  service: name=httpd state=started enabled=yes

vim handlers/main.yml
- name: restart
  service: name=httpd state=restarted

#在files目录下准备两个文件
ls files/
httpd.conf index.html

tree /data/ansible/roles/httpd/
/data/ansible/roles/httpd/
├── files
│   ├── httpd.conf
│   └── index.html
├── handlers
│   └── main.yml
└── tasks
    ├── config.yml
    ├── group.yml
    ├── index.yml
    ├── install.yml
    ├── main.yml
    ├── service.yml
    └── user.yml

3 directories, 10 files

#在playbook中调用角色
vim  /data/ansible/role_httpd.yml
---
# httpd role
- hosts: websrvs
  remote_user: root

  roles:
    - httpd

#运行playbook
ansible-playbook  /data/ansible/role_httpd.yml
```

##### 案例2：实现 nginx 角色

```yaml
mkdir -pv  /data/ansible/roles/nginx/{tasks,handlers,templates,vars}

#创建task文件
cd /data/ansible/roles/nginx/

vim tasks/main.yml 
- include: install.yml
- include: config.yml
- include: index.yml
- include: service.yml

vim  tasks/install.yml 
- name: install
  yum: name=nginx 

vim tasks/config.yml 
- name: config file for centos7
  template: src=nginx7.conf.j2 dest=/etc/nginx/nginx.conf
  when: ansible_distribution_major_version=="7"
  notify: restart
- name: config file for centos8
  template: src=nginx8.conf.j2 dest=/etc/nginx/nginx.conf
  when: ansible_distribution_major_version=="8"
  notify: restart

vim  tasks/index.yml 
- name: index.html
  copy: src=roles/httpd/files/index.html dest=/usr/share/nginx/html/

vim tasks/service.yml 
- name: start service
  service: name=nginx state=started enabled=yes

#创建handler文件
cat handlers/main.yml 
- name: restart
  service: name=nginx state=restarted

#创建两个template文件
cat templates/nginx7.conf.j2
...省略...
user {{user}};
worker_processes {{ansible_processor_vcpus+3}};   #修改此行
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
...省略...

cat templates/nginx8.conf.j2
...省略...
user nginx;
worker_processes {{ansible_processor_vcpus**3}};  #修改此行
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
...省略...

#创建变量文件
vim vars/main.yml 
user: daemon

#目录结构如下

tree /data/ansible/roles/nginx/
/data/ansible/roles/nginx/
├── handlers
│   └── main.yml
├── tasks
│   ├── config.yml
│   ├── file.yml
│   ├── install.yml
│   ├── main.yml
│   └── service.yml
├── templates
│   ├── nginx7.conf.j2
│   └── nginx8.conf.j2
└── vars
    └── main.yml

4 directories, 9 files

#在playbook中调用角色
vim /data/ansible/role_nginx.yml 
---
#nginx role 
- hosts: websrvs

  roles:
    - role: nginx

#运行playbook
ansible-playbook  /data/ansible/role_nginx.yml
```

##### 案例3：实现 memcached 角色

```yaml
mkdir -pv  /data/ansible/roles/memcached/{tasks,templates}

cd /data/ansible/roles/memcached
vim tasks/main.yml 
- include: install.yml
- include: config.yml
- include: service.yml

vim tasks/install.yml 
- name: install
  yum: name=memcached

vim tasks/config.yml 
- name: config file
  template: src=memcached.j2  dest=/etc/sysconfig/memcached

vim tasks/service.yml 
- name: service
  service: name=memcached state=started enabled=yes

vim templates/memcached.j2 
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="{{ansible_memtotal_mb//4}}"
OPTIONS=""

tree /data/ansible/roles/memcached/
/data/ansible/roles/memcached/
├── tasks
│   ├── config.yml
│   ├── install.yml
│   ├── main.yml
│   └── service.yml
└── templates
    └── memcached.j2

2 directories, 5 files

vim /data/ansible/role_memcached.yml 
---
- hosts: appsrvs

  roles:
    - role: memcached

ansible-play /data/ansible/role_memcached.yml 
```

##### 案例4：实现 mysql 5.6 的角色

```yaml
cat /data/ansible/roles/mysql/files/my.cnf 
[mysqld]
socket=/tmp/mysql.sock
user=mysql
symbolic-links=0
datadir=/data/mysql
innodb_file_per_table=1
log-bin
pid-file=/data/mysql/mysqld.pid

[client]
port=3306
socket=/tmp/mysql.sock

[mysqld_safe]
log-error=/var/log/mysqld.log

cat /data/ansible/roles/mysql/files/secure_mysql.sh 
#!/bin/bash
/usr/local/mysql/bin/mysql_secure_installation <<EOF

y
magedu
magedu
y
y
y
y
EOF

chmod +x  /data/ansible/roles/mysql/files/secure_mysql.sh

ls /data/ansible/roles/mysql/files/
my.cnf  mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz  secure_mysql.sh

cat /data/ansible/roles/mysql/tasks/main.yml
- include: install.yml
- include: group.yml
- include: user.yml
- include: unarchive.yml
- include: link.yml
- include: data.yml
- include: config.yml
- include: service.yml
- include: path.yml
- include: secure.yml

cat /data/ansible/roles/mysql/tasks/install.yml 
- name: install packages                                            
  yum: name=libaio,perl-Data-Dumper,perl-Getopt-Long

cat /data/ansible/roles/mysql/tasks/group.yml 
- name: create mysql group
  group: name=mysql gid=306

cat /data/ansible/roles/mysql/tasks/user.yml 
- name: create mysql user
  user: name=mysql uid=306 group=mysql shell=/sbin/nologin system=yes create_home=no home=/data/mysql

cat /data/ansible/roles/mysql/tasks/unarchive.yml 
- name: copy tar to remote host and file mode 
  unarchive: src=mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz dest=/usr/local/ owner=root group=root

cat /data/ansible/roles/mysql/tasks/link.yml 
- name: mkdir /usr/local/mysql 
  file: src=/usr/local/mysql-5.6.46-linux-glibc2.12-x86_64 dest=/usr/local/mysql state=link

cat /data/ansible/roles/mysql/tasks/data.yml 
- name: data dir
  shell: chdir=/usr/local/mysql/  ./scripts/mysql_install_db --datadir=/data/mysql --user=mysql

cat /data/ansible/roles/mysql/tasks/config.yml 
- name: config my.cnf
  copy: src=my.cnf  dest=/etc/my.cnf 

cat /data/ansible/roles/mysql/tasks/service.yml 
- name: service script
  shell: /bin/cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld;chkconfig --add mysqld;chkconfig mysqld on;/etc/init.d/mysqld start

cat /data/ansible/roles/mysql/tasks/path.yml 
- name: PATH variable
  copy: content='PATH=/usr/local/mysql/bin:$PATH' dest=/etc/profile.d/mysql.sh  

cat /data/ansible/roles/mysql/tasks/secure.yml 
- name: secure script
  script: secure_mysql.sh

tree /data/ansible/roles/mysql/
/data/ansible/roles/mysql/
├── files
│   ├── my.cnf
│   ├── mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
│   └── secure_mysql.sh
└── tasks
    ├── config.yml
    ├── data.yml
    ├── group.yml
    ├── install.yml
    ├── link.yml
    ├── main.yml
    ├── path.yml
    ├── secure.yml
    ├── service.yml
    ├── unarchive.yml
    └── user.yml

2 directories, 14 files

cat /data/ansible/mysql_roles.yml
- hosts: dbsrvs
  remote_user: root

  roles:
    - {role: mysql,tags: ["mysql","db"]}
    - {role: nginx,tage: ["nginx","web"]}

ansible-playbook -t mysql /data/ansible/mysql_roles.yml
```

##### 案例5 ：实现多角色的选择

```yaml
vim /data/ansible/role_httpd_nginx.yml 
---
- hosts: websrvs

  roles:
    - {role: httpd,tags: [httpd,web], when: ansible_distribution_major_version=="7" }
    - {role: nginx,tags: [nginx,web], when: ansible_distribution_major_version=="8" }

ansible-playbook -t nginx /data/ansible/role_httpd_nginx.yml 
```

## Inventory文件

Ansible 可同时操作属于一个组的多台主机，组和主机之间的关系通过 inventory 文件配置。默认的路径为 `/etc/ansible/hosts`。

除默认文件外,还可以同时使用多个 inventory 文件,也可以从动态源,或云上拉取 inventory 配置信息。

### 主机与组

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

方括号[]中是组名,用于对系统进行分类,便于对不同系统进行个别的管理。一个系统可以属于不同的组。这时属于两个组的变量都可以为这台主机所用。

如果有主机的SSH端口不是标准的22端口,可在主机名之后加上端口号,用冒号分隔。

```ini
one.example.com:5309
```

假设有一些静态IP地址,希望设置一些别名,但不是在系统的 host 文件中设置,又或者你是通过隧道在连接,那么可以设置如下:

```ini
jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50
# 例子中,通过 “jumper” 别名,会连接 192.168.1.50:5555。一般而言,这不是设置变量的最好方式。
```

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

可以把一个组作为另一个组的子成员,以及分配变量给整个组使用。这些变量可以给 /usr/bin/ansible-playbook 使用,但不能给 /usr/bin/ansible 使用:

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

还有更进一步的运用,你可以为一个主机,或一个组,创建一个目录,目录名就是主机名或组名。目录中的可以创建多个文件, 文件中的变量都会被读取为主机或组的变量.如下 ‘raleigh’ 组对应于 /etc/ansible/group_vars/raleigh/ 目录,其下有两个文件 db_settings 和 cluster_settings, 其中分别设置不同的变量:

```bash
/etc/ansible/group_vars/raleigh/db_settings
/etc/ansible/group_vars/raleigh/cluster_settings
```

> **Tip:**
>
> Ansible 1.2 及以上的版本中，group_vars/ 和 host_vars/ 目录可放在 inventory 目录下，或是 playbook 目录下。 如果两个目录下都存在,那么 playbook 目录下的配置会覆盖 inventory 目录的配置。
>
> 把 inventory 文件 和 变量 放入 git repo 中，以便跟踪他们的更新，这是一种非常推荐的方式。

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

1. 从云端拉取 inventory。
2. LDAP（Lightweight Directory Access Protocol,轻量级目录访问协议）
3. Cobbler
4. 一份昂贵的企业版的 CMDB（配置管理数据库） 软件。

对于这些需求，Ansible 可通过一个外部 inventory 系统来支持。在 ansible 的 “/plugins”  插件目录下已经含有一些选项 – 包括 EC2/Eucalyptus，Rackspace Cloud  and  OpenStack。

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

1. BSD Jails
2. DigitalOcean
3. Google Compute Engine
4. Linode
5. OpenShift
6. OpenStack Nova
7. Red Hat's SpaceWalk
8. Vagrant (not to be confused with the provisioner in vagrant, which is preferred)
9. Zabbix

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
