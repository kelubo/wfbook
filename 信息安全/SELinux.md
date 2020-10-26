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
