# SELinux![img](../Image/s/selinux.png)
Security Enhanced Linux (SELinux)，由美国国家安全局（NSA）贡献的，为 Linux 内核子系统引入了一个健壮的强制控制访问架构。SELinux属于MAC强制访问控制（Mandatory Access Control）—— 即让系统中的各个服务进程都受到约束，即仅能访问到所需要的文件。

## DAC vs. MAC
Linux 上传统的访问控制标准是自主访问控制（DAC）。在这种形式下，一个软件或守护进程以 User ID（UID）或 Set owner User ID（SUID）的身份运行，并且拥有该用户的目标（文件、套接字、以及其它进程）权限。这使得恶意代码很容易运行在特定权限之下，从而取得访问关键的子系统的权限。
强制访问控制（MAC）基于保密性和完整性强制信息的隔离以限制破坏。该限制单元独立于传统的 Linux 安全机制运作，并且没有超级用户的概念。

## 概念

    主体
    目标
    策略
    模式

当一个主体（如一个程序）尝试访问一个目标（如一个文件），SELinux 安全服务器（在内核中）从策略数据库中运行一个检查。基于当前的模式，如果 SELinux 安全服务器授予权限，该主体就能够访问该目标。如果 SELinux 安全服务器拒绝了权限，就会在 /var/log/messages 中记录一条拒绝信息。


## 模式

SELinux 有三个模式。这些模式将规定 SELinux 在主体请求时如何应对。

* **Enforcing**     — SELinux 策略强制执行，基于 SELinux 策略规则授予或拒绝主体对目标的访问。计算机通常在该模式下运行。
* **Permissive**   — SELinux 策略不强制执行，不实际拒绝访问，但会有拒绝信息写入日志。主要用于测试和故障排除。
* **Disabled**      —  完全禁用 SELinux,对于越权的行为不警告，也不拦截。不建议。

查看系统当前模式：`getenforce` 。命令会返回 Enforcing、Permissive，或者 Disabled。

设置 SELinux 的模式:

* 修改 /etc/selinux/config 文件。

  ```bash
  # This file controls the state of SELinux on the system.
  # SELINUX= can take one of these three values:
  #		enforcing - SELinux security policy is enforced.
  #		permissive - SELinux prints warnings instead of enforcing.
  #		disabled - No SELinux policy is loaded.
  SELINUX=enforcing
  ```
  
* 从命令行设置模式，使用 `setenforce` 工具。

  ```bash
  setenforce [ Enforcing | Permissive | 1 | 0 ]
  ```

* 在启动时，通过将向内核传递参数来设置SELinux模式：

  ```bash
  enforcing=0		#将以许可模式启动系统
  enforcing=1		#设置强制模式
  selinux=0		#彻底禁用SELinux
  selinux=1		#启用SELinux
  ```

## 策略类型

策略有两种:

* Targeted — 只有目标网络进程（dhcpd，httpd，named，nscd，ntpd，portmap，snmpd，squid，以及 syslogd）受保护

* Strict — 对所有进程完全的 SELinux 保护

在 /etc/selinux/config 文件中修改策略类型。

```bash
# SELINUXTYPE= can take one of these two values:
#		targeted - Targeted processes are protected,
#		minimum - Modification of targeted policy. Only selected processes
#				  are protected.
#		mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

有个方便的 SELinux 工具，获取启用了 SELinux 的系统的详细状态报告。

```bash
sestatus -v
```









# SELinux security[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#selinux-security)

With the arrival of kernel version 2.6, a new security system was  introduced to provide a security mechanism to support access control  security policies.

This system is called **SELinux** (**S**ecurity **E**nhanced **Linux**) and was created by the **NSA** (**N**ational **S**ecurity **A**dministration) to implement a robust **M**andatory **A**ccess **C**ontrol (**MAC**) architecture in the Linux kernel subsystems.

If, throughout your career, you have either disabled or ignored  SELinux, this document will be a good introduction to this system.  SELinux works to limit privileges or remove the risks associated with  compromising a program or daemon.

Before starting, you should know that SELinux is mainly intended for  RHEL distributions, although it is possible to implement it on other  distributions like Debian (but good luck!). The distributions of the  Debian family generally integrate the AppArmor system, which works  differently from SELinux.

## Generalities[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#generalities)

**SELinux** (Security Enhanced Linux) is a Mandatory Access Control system.

Before the appearance of MAC systems, standard access management security was based on **DAC** (**D**iscretionary **A**ccess **C**ontrol) systems. An application, or a daemon, operated with **UID** or **SUID** (**S**et **O**wner **U**ser **I**d) rights, which made it possible to evaluate permissions (on files,  sockets, and other processes...) according to this user. This operation  does not sufficiently limit the rights of a program that is corrupted,  potentially allowing it to access the subsystems of the operating  system.

A MAC system reinforces the separation of confidentiality and  integrity information in the system to achieve a containment system. The containment system is independent of the traditional rights system and  there is no notion of a superuser.

With each system call, the kernel queries SELinux to see if it allows the action to be performed.

![SELinux](https://docs.rockylinux.org/guides/images/selinux_001.png)

SELinux uses a set of rules (policies) for this. A set of two standard rule sets (**targeted** and **strict**) is provided and each application usually provides its own rules.

### The SELinux context[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context)

The operation of SELinux is totally different from traditional Unix rights.

The SELinux security context is defined by the trio **identity**+**role**+**domain**.

The identity of a user depends directly on his Linux account. An  identity is assigned one or more roles, but to each role corresponds to  one domain, and only one.

It is according to the domain of the security context (and thus the role) that the rights of a user on a resource are evaluated.

![SELinux context](https://docs.rockylinux.org/guides/images/selinux_002.png)

The terms "domain" and "type" are similar. Typically "domain" is used when referring to a process, while "type" refers to an object.

The naming convention is: **user_u:role_r:type_t**.

The security context is assigned to a user at the time of his  connection, according to his roles. The security context of a file is  defined by the `chcon` (**ch**ange **con**text) command, which we will see later in this document.

Consider the following pieces of the SELinux puzzle:

- The subjects
- The objects
- The policies
- The mode

When a subject (an application for example) tries to access an object (a file for example), the SELinux part of the Linux kernel queries its  policy database. Depending on the mode of operation, SELinux authorizes  access to the object in case of success, otherwise it records the  failure in the file `/var/log/messages`.

#### The SELinux context of standard processes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context-of-standard-processes)

The rights of a process depend on its security context.

By default, the security context of the process is defined by the  context of the user (identity + role + domain) who launches it.

A domain being a specific type (in the SELinux sense) linked to a  process and inherited (normally) from the user who launched it, its  rights are expressed in terms of authorization or refusal on types  linked to objects:

A process whose context has security **domain D** can access objects of **type T**.

![The SELinux context of standard processes](https://docs.rockylinux.org/guides/images/selinux_003.png)

#### The SELinux context of important processes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context-of-important-processes)

Most important programs are assigned a dedicated domain.

Each executable is tagged with a dedicated type (here **sshd_exec_t**) which automatically switches the associated process to the **sshd_t** context (instead of **user_t**).

This mechanism is essential since it restricts the rights of a process as much as possible.

![The SELinux context of an important process - example of sshd](https://docs.rockylinux.org/guides/images/selinux_004.png)

## Management[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#management)

The `semanage` command is used to manage SELinux rules.

```
semanage [object_type] [options]
```

Example:

```
$ semanage boolean -l
```

| Options | Observations     |
| ------- | ---------------- |
| -a      | Adds an object   |
| -d      | Delete an object |
| -m      | Modify an object |
| -l      | List the objects |

The `semanage` command may not be installed by default under Rocky Linux.

Without knowing the package that provides this command, you should search for its name with the command:

```
dnf provides */semanage
```

then install it:

```
sudo dnf install policycoreutils-python-utils
```

### Administering Boolean objects[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#administering-boolean-objects)

Booleans allow the containment of processes.

```
semanage boolean [options]
```

To list the available Booleans:

```
semanage boolean –l
SELinux boolean    State Default  Description
…
httpd_can_sendmail (off , off)  Allow httpd to send mail
…
```

Note

As you can see, there is a `default` state (eg. at startup) and a running state.

The `setsebool` command is used to change the state of a boolean object:

```
setsebool [-PV] boolean on|off
```

Example:

```
sudo setsebool -P httpd_can_sendmail on
```

| Options | Observations                                                 |
| ------- | ------------------------------------------------------------ |
| `-P`    | Changes the default value at startup (otherwise only until reboot) |
| `-V`    | Deletes an object                                            |

Warning

Don't forget the `-P` option to keep the state after the next startup.

### Administering Port objects[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#administering-port-objects)

The `semanage` command is used to manage objects of type port:

```
semanage port [options]
```

Example: allow port 81 for httpd domain processes

```
sudo semanage port -a -t http_port_t -p tcp 81
```

## Operating modes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#operating-modes)

SELinux has three operating modes:

- Enforcing

Default mode for Rocky Linux. Access will be restricted according to the rules in force.

- Permissive

Rules are polled, access errors are logged, but access will not be blocked.

- Disabled

Nothing will be restricted, nothing will be logged.

By default, most operating systems are configured with SELinux in Enforcing mode.

The `getenforce` command returns the current operating mode

```
getenforce
```

Example:

```
$ getenforce
Enforcing
```

The `sestatus` command returns information about SELinux

```
sestatus
```

Example:

```
$ sestatus
SELinux status:                enabled
SELinuxfs mount:                 /sys/fs/selinux
SELinux root directory:    /etc/selinux
Loaded policy name:        targeted
Current mode:                enforcing
Mode from config file:     enforcing
...
Max kernel policy version: 33
```

The `setenforce` command changes the current operating mode:

```
setenforce 0|1
```

Switch SELinux to permissive mode:

```
sudo setenforce 0
```

### The `/etc/sysconfig/selinux` file[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-etcsysconfigselinux-file)

The `/etc/sysconfig/selinux` file allows you to change the operating mode of SELinux.

Warning

Disabling SELinux is done at your own risk! It is better to learn how SELinux works than to disable it systematically!

Edit the file `/etc/sysconfig/selinux`

```
SELINUX=disabled
```

Note

```
/etc/sysconfig/selinux` is a symlink to `/etc/selinux/config
```

Reboot the system:

```
sudo reboot
```

Warning

Beware of the SELinux mode change!

In permissive or disabled mode, newly created files will not have any labels.

To reactivate SELinux, you will have to reposition the labels on your entire system.

Labeling the entire system:

```
sudo touch /.autorelabel
sudo reboot
```

## The Policy Type[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-policy-type)

SELinux provides two standard types of rules:

- **Targeted**: only network daemons are protected (`dhcpd`, `httpd`, `named`, `nscd`, `ntpd`, `portmap`, `snmpd`, `squid` and `syslogd`)
- **Strict**: all daemons are protected

## Context[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#context)

The display of security contexts is done with the `-Z` option. It is associated with many commands:

Examples:

```
id -Z   # the user's context
ls -Z   # those of the current files
ps -eZ  # those of the processes
netstat –Z # for network connections
lsof -Z # for open files
```

The `matchpathcon` command returns the context of a directory.

```
matchpathcon directory
```

Example:

```
sudo matchpathcon /root
 /root  system_u:object_r:admin_home_t:s0

sudo matchpathcon /
 /      system_u:object_r:root_t:s0
```

The `chcon` command modifies a security context:

```
chcon [-vR] [-u USER] [–r ROLE] [-t TYPE] file
```

Example:

```
sudo chcon -vR -t httpd_sys_content_t /data/websites/
```

| Options        | Observations                    |
| -------------- | ------------------------------- |
| `-v`           | Switch into verbose mode        |
| `-R`           | Apply recursion                 |
| `-u`,`-r`,`-t` | Applies to a user, role or type |

The `restorecon` command restores the default security context (the one provided by the rules):

```
restorecon [-vR] directory
```

Example:

```
sudo restorecon -vR /home/
```

| Options | Observations             |
| ------- | ------------------------ |
| `-v`    | Switch into verbose mode |
| `-R`    | Apply recursion          |

To make a context change survive to a `restorecon`, you have to modify the default file contexts with the `semanage fcontext` command:

```
semanage fcontext -a options file
```

Note

If you are performing a context switch for a folder that is not  standard for the system, creating the rule and then applying the context is a good practice as in the example below!

Example:

```
$ sudo semanage fcontext -a -t httpd_sys_content_t "/data/websites(/.*)?"
$ sudo restorecon -vR /data/websites/
```

## `audit2why` command[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#audit2why-command)

The `audit2why` command indicates the cause of a SELinux rejection:

```
audit2why [-vw]
```

Example to get the cause of the last rejection by SELinux:

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2why
```

| Options | Observations                                                 |
| ------- | ------------------------------------------------------------ |
| `-v`    | Switch into verbose mode                                     |
| `-w`    | Translates the cause of a rejection by SELinux and proposes a solution to remedy it (default option) |

### Going further with SELinux[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#going-further-with-selinux)

The `audit2allow` command creates a module to allow a SELinux action (when no module exists) from a line in an "audit" file:

```
audit2allow [-mM]
```

Example:

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2allow -M mylocalmodule
```

| Options | Observations                                       |
| ------- | -------------------------------------------------- |
| `-m`    | Just create the module (`*.te`)                    |
| `-M`    | Create the module, compile and package it (`*.pp`) |

#### Example of configuration[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#example-of-configuration)

After the execution of a command, the system gives you back the  command prompt but the expected result is not visible: no error message  on the screen.

- **Step 1**: Read the log file knowing that the message  we are interested in is of type AVC (SELinux), refused (denied) and the  most recent one (therefore the last one).

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1
```

The message is correctly isolated but is of no help to us.

- **Step 2**: Read the isolated message with the `audit2why` command to get a more explicit message that may contain the solution to our problem (typically a boolean to be set).

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2why
```

There are two cases: either we can place a context or fill in a boolean, or we must go to step 3 to create our own context.

- **Step 3**: Create your own module.

```
$ sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2allow -M mylocalmodule
Generating type enforcement: mylocalmodule.te
Compiling policy: checkmodule -M -m -o mylocalmodule.mod mylocalmodule.te
Building package: semodule_package -o mylocalmodule.pp -m mylocalmodule.mod

$ sudo semodule -i mylocalmodule.pp
```
