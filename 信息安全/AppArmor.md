# AppArmor

AppArmor is a Linux Security Module implementation of name-based mandatory  access controls. AppArmor confines individual programs to a set of  listed files and posix 1003.1e draft capabilities.
AppArmor是基于名称的强制访问控制的Linux安全模块实现。AppArmor将单个程序限制在一组列出的文件和posix 1003.1e草稿功能中。 

AppArmor is installed and loaded by default. It uses *profiles* of an application to determine what files and permissions the  application requires. Some packages will install their own profiles, and additional profiles can be found in the apparmor-profiles package.
AppArmor默认情况下已安装并加载。它使用应用程序的配置文件来确定应用程序需要哪些文件和权限。有些软件包会安装自己的配置文件，其他配置文件可以在apparmor-profiles软件包中找到。

To install the apparmor-profiles package from a terminal prompt:
要从终端提示符安装apparmor-profiles包，请执行以下操作： 

```
sudo apt install apparmor-profiles
```

AppArmor profiles have two modes of execution:
AppArmor配置文件有两种执行模式： 

- Complaining/Learning: profile violations are permitted and logged. Useful for testing and developing new profiles.
  投诉/学习：允许并记录违反配置文件的行为。用于测试和开发新的配置文件。 
- Enforced/Confined: enforces profile policy as well as logging the violation.
  强制/受限：强制执行配置文件策略并记录违规。 

## Using AppArmor 使用AppArmor 

The optional apparmor-utils package contains command line utilities that  you can use to change the AppArmor execution mode, find the status of a  profile, create new profiles, etc.
可选的apparmor-utils包包含命令行实用程序，您可以使用它们来更改AppArmor执行模式、查找配置文件的状态、创建新配置文件等。 

- apparmor_status is used to view the current status of AppArmor profiles.
  apparmor_status用于查看AppArmor配置文件的当前状态。 

  ```
  sudo apparmor_status
  ```

- aa-complain places a profile into *complain* mode.
  aa-complain将配置文件置于complain模式。

  ```
  sudo aa-complain /path/to/bin
  ```

- aa-enforce places a profile into *enforce* mode.
  aa-enforce将配置文件置于强制模式。

  ```
  sudo aa-enforce /path/to/bin
  ```

- The `/etc/apparmor.d` directory is where the AppArmor profiles are located. It also stores *abstractions* that can simplify profile authoring, such as `abstractions/base` that allows many shared libraries, writing logs to the journal, many  pseudo-devices, receiving signals from unconfined processes, and many  more things.
   `/etc/apparmor.d` 目录是AppArmor配置文件所在的位置。它还存储了可以简化概要文件创作的抽象，例如 `abstractions/base` ，它允许许多共享库，将日志写入日志，许多伪设备，从非限制进程接收信号，以及更多事情。



- apparmor_parser is used to load a profile into the kernel. It can also be used to reload a currently loaded profile using the *-r* option after modifying it to have the changes take effect.
  apparmor_parser用于将配置文件加载到内核中。它也可以用来在修改当前加载的配置文件后使用-r选项重新加载该配置文件，以使更改生效。
   To reload a profile:
   要重新加载配置文件，请执行以下操作：

  ```
  sudo apparmor_parser -r /etc/apparmor.d/profile.name
  ```

- `systemctl` can be used to *reload* all profiles:
   `systemctl` 可用于重新加载所有配置文件：

  ```
  sudo systemctl reload apparmor.service
  ```

- The `/etc/apparmor.d/disable` directory can be used along with the apparmor_parser -R option to *disable* a profile.
  可以沿着使用 `/etc/apparmor.d/disable` 目录和apparmor_parser -R选项来禁用配置文件。

  ```
  sudo ln -s /etc/apparmor.d/profile.name /etc/apparmor.d/disable/
  sudo apparmor_parser -R /etc/apparmor.d/profile.name
  ```

  To *re-enable* a disabled profile remove the symbolic link to the profile in `/etc/apparmor.d/disable/`. Then load the profile using the *-a* option.
  要重新启用禁用的配置文件，请删除指向 `/etc/apparmor.d/disable/` 中配置文件的符号链接。然后使用-a选项加载配置文件。

  ```
  sudo rm /etc/apparmor.d/disable/profile.name
  cat /etc/apparmor.d/profile.name | sudo apparmor_parser -a
  ```

- AppArmor can be disabled, and the kernel module unloaded by entering the following:
  可以通过输入以下命令禁用AppArmor并卸载内核模块： 

  ```
  sudo systemctl stop apparmor.service
  sudo systemctl disable apparmor.service
  ```

- To re-enable AppArmor enter:
  要重新启用AppArmor，请输入： 

  ```
  sudo systemctl enable apparmor.service
  sudo systemctl start apparmor.service
  ```

> **Note 注意**
>
> Replace *profile.name* with the name of the profile you want to manipulate. Also, replace `/path/to/bin/` with the actual executable file path. For example for the ping command use `/bin/ping`
> 将profile.name替换为您要操作的配置文件的名称。另外，将 `/path/to/bin/` 替换为实际的可执行文件路径。例如，对于ping命令，请使用 `/bin/ping` 

## Profiles 配置文件 

AppArmor profiles are simple text files located in `/etc/apparmor.d/`. The files are named after the full path to the executable they profile replacing the “/” with “.”. For example `/etc/apparmor.d/bin.ping` is the AppArmor profile for the `/bin/ping` command.
AppArmor配置文件是位于 `/etc/apparmor.d/` 的简单文本文件。这些文件以它们分析的可执行文件的完整路径命名，将“/”替换为“."。例如， `/etc/apparmor.d/bin.ping` 是 `/bin/ping` 命令的AppArmor配置文件。

There are two main type of rules used in profiles:
配置文件中使用的规则主要有两种类型： 

- *Path entries:* detail which files an application can access in the file system.
  路径条目：详细说明应用程序可以访问文件系统中的哪些文件。
- *Capability entries:* determine what privileges a confined process is allowed to use.
  能力条目：确定一个受限流程可以使用什么特权。

As an example, take a look at `/etc/apparmor.d/bin.ping`:
举个例子，看看 `/etc/apparmor.d/bin.ping` ：

```
#include <tunables/global>
/bin/ping flags=(complain) {
  #include <abstractions/base>
  #include <abstractions/consoles>
  #include <abstractions/nameservice>

  capability net_raw,
  capability setuid,
  network inet raw,
  
  /bin/ping mixr,
  /etc/modules.conf r,
}
```

- *#include <tunables/global>:* include statements from other files. This allows statements pertaining to multiple applications to be placed in a common file.
  \#include <tunables/global>：包含来自其他文件的语句。这允许将与多个应用程序有关的语句放在一个公共文件中。
- */bin/ping flags=(complain):* path to the profiled program, also setting the mode to *complain*.
  /bin/ping flags=（complain）：被分析程序的路径，也设置了complain模式。
- *capability net_raw,:* allows the application access to the CAP_NET_RAW Posix.1e capability.
  capability net_raw：允许应用程序访问CAP_NET_RAW Posix.1e功能。
- */bin/ping mixr,:* allows the application read and execute access to the file.
  /bin/ping mixr：允许应用程序读取和执行文件。

> **Note 注意**
>
> After editing a profile file the profile must be reloaded. See above at [Using AppArmor](https://ubuntu.com/server/docs/apparmor#loadrules) for details.
> 编辑配置文件后，必须重新加载配置文件。请参阅上面的使用AppArmor了解详细信息。

### Creating a Profile 创建简档 

- *Design a test plan:* Try to think about how the application should be exercised. The test  plan should be divided into small test cases. Each test case should have a small description and list the steps to follow.
  设计一个测试计划：试着考虑应该如何使用应用程序。测试计划应划分为小的测试用例。每个测试用例都应该有一个简短的描述，并列出要遵循的步骤。

  Some standard test cases are:
  一些标准测试用例是： 

  - Starting the program. 启动程序。 
  - Stopping the program. 停止程序。 
  - Reloading the program. 在计划中。 
  - Testing all the commands supported by the init script.
    测试init脚本支持的所有命令。 

- *Generate the new profile:* Use aa-genprof to generate a new profile. From a terminal:
  生成新配置文件：使用aa-genprof生成新配置文件。从终端：

  ```
  sudo aa-genprof executable
  ```

  For example: 举例来说： 

  ```
  sudo aa-genprof slapd
  ```

- To get your new profile included in the apparmor-profiles package, file a bug in *Launchpad* against the [AppArmor](https://bugs.launchpad.net/ubuntu/+source/apparmor/+filebug) package:
  要将您的新配置文件包含在apparmor-profiles包中，请在Launchpad中针对AppArmor包提交一个bug：

  - Include your test plan and test cases.
    包括您的测试计划和测试用例。 
  - Attach your new profile to the bug.
    将您的新配置文件附加到Bug。 

### Updating Profiles 更新配置文件 

When the program is misbehaving, audit messages are sent to the log files.  The program aa-logprof can be used to scan log files for AppArmor audit  messages, review them and update the profiles. From a terminal:
当程序行为异常时，审计消息将发送到日志文件。程序aa-logprof可用于扫描AppArmor审计消息的日志文件，查看它们并更新配置文件。从终端： 

```
sudo aa-logprof
```

### Further pre-existing Profiles 更多预先存在的配置文件 

The packages `apport-profiles` and `apparmor-profiles-extra` ship some experimental profiles for AppArmor security policies.
软件包 `apport-profiles` 和 `apparmor-profiles-extra` 为AppArmor安全策略提供了一些实验性配置文件。
 Do not expect these profiles to work out-of-the-box, but they can give  you a head start when trynig to create a new profile by starting off a  base that exists.
 不要期望这些配置文件可以开箱即用，但是当你试图从一个现有的基础开始创建一个新的配置文件时，它们可以给你一个给予好的开始。

These profiles are not considered mature enough to be shipped in enforce mode by default. Therefore they are shipped in complain mode so that users  can test them, choose which are desired, and help improve them upstream  if needed.
默认情况下，这些配置文件还不够成熟，不能以强制模式提供。因此，它们以投诉模式提供，以便用户可以测试它们，选择所需的，并在需要时帮助上游改进它们。 

Some even more experimental profiles carried by the package are placed in` /usr/share/doc/apparmor-profiles/extras/`
包中携带的一些甚至更多的实验性配置文件放在 ` /usr/share/doc/apparmor-profiles/extras/` 中

## Checking and debugging denies 检查和调试拒绝 

You will see in ‘dmesg’ and any log that collects kernel messages if you have hit a deny.
如果你点击了deny，你会在'dmesg'和任何收集内核消息的日志中看到。
 Right away it is worth to know that this will cover any access that was denied `because it was not allowed`, but `explicit denies` will put no message in your logs at all.
 值得一提的是，这将涵盖任何被拒绝的访问 `because it was not allowed` ，但 `explicit denies` 将不会在您的日志中放置任何消息。

Examples might look like:
示例可能如下所示： 

```
[1521056.552037] audit: type=1400 audit(1571868402.378:24425): apparmor="DENIED" operation="open" profile="/usr/sbin/cups-browsed" name="/var/lib/libvirt/dnsmasq/" pid=1128 comm="cups-browsed" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[1482106.651527] audit: type=1400 audit(1571829452.330:24323): apparmor="DENIED" operation="sendmsg" profile="snap.lxd.lxc" pid=24115 comm="lxc" laddr=10.7.0.69 lport=48796 faddr=10.7.0.231 fport=445 family="inet" sock_type="stream" protocol=6 requested_mask="send" denied_mask="send"
```

That follows a generic structure starting with a timestamp, an audit tag and the category `apparmor="DENIED"`.
它遵循一个以时间戳、审计标记和类别 `apparmor="DENIED"` 开始的通用结构。
 From the following fields you can derive what was going on and why it was failing.
 从以下字段中，您可以得出发生了什么以及为什么失败。

In the examples above that would be
在上面的例子中， 

First example: 第一个例子： 

- operation: `open` (program tried to open a file)
  操作： `open` （程序试图打开一个文件）
- profile: `/usr/sbin/cups-browsed` (you’ll find `/etc/apparmor.d/usr.bin.cups-browsed`)
  个人资料： `/usr/sbin/cups-browsed` （您将找到 `/etc/apparmor.d/usr.bin.cups-browsed` ）
- name: `/var/lib/libvirt/dnsmasq` (what it wanted to access)
  name： `/var/lib/libvirt/dnsmasq` （它想要访问的内容）
- pid/comm: the program that did trigger the access
  pid/pid：触发访问的程序 
- requested_mask/denied_mask/fsuid/ouid: parameters of that open call
  requested_mask/denied_mask/fsuid/ouid：打开的调用的参数 

Second example: 第二个例子： 

- operation: `sendmsg` (program tried send via network)
  操作： `sendmsg` （程序尝试通过网络发送）
- profile: `snap.lxd.lxc` (snaps are special, you’ll find `/var/lib/snapd/apparmor/profiles/snap.lxd.lxc`)
  配置文件： `snap.lxd.lxc` （快照很特殊，您会发现 `/var/lib/snapd/apparmor/profiles/snap.lxd.lxc` ）
- pid/comm: the program that did trigger the access
  pid/pid：触发访问的程序 
- laddr/lport/faddr/fport/family/sock_type/protocol: parameters of that sendmsg call
  laddr/lport/faddr/fport/family/sock_type/protocol：sendmsg调用参数 

That way you know in which profile and at what action you have to start if  you consider either debugging or adapting the profiles.
这样，您就知道在调试或调整概要文件时，必须在哪个概要文件中以及在什么操作处开始。 

## Profile customization 企业简介 

Profiles are meant to provide security and thereby can’t be all too open. But  quite often a very special setup would work with a profile if it wold *just allow this one extra access*. To handle that there are three ways.
配置文件旨在提供安全性，因此不能过于开放。但通常一个非常特殊的设置将工作与配置文件，如果它只允许这一个额外的访问。要解决这个问题，有三种方法。

- modify the profile itself

  
  修改配置文件本身 

  - always works, but has the drawback that profiles are in /etc and considered  conffiles. So after modification on a related package update you might  get a conffile prompt. Worst case depending on configuration automatic  updates might even override it and your custom rule is gone.
    总是工作，但有一个缺点，即配置文件是在/etc和考虑confiles。因此，在修改相关的软件包更新后，您可能会收到一个confile提示。最坏的情况取决于配置自动更新甚至可能覆盖它，你的自定义规则消失了。 

- use tunables

   使用可调参数 

  - those provide variables that can be used in templates, for example if you  want a custom dir considered as it would be a home directory you could  modify `/etc/apparmor.d/tunables/home` which defines the base path rules use for home directories
    这些提供了可以在模板中使用的变量，例如，如果您希望将自定义目录视为主目录，则可以修改定义用于主目录的基本路径规则的 `/etc/apparmor.d/tunables/home` 
  - by design those variables will only influence profiles that use them
    通过设计，这些变量只会影响使用它们的配置文件 

- modify a local override

  
  修改局部覆盖 

  - to mitigate the drawbacks of above approaches *local includes* got introduced adding the ability to write arbitrary rules that will be used, and not get issues on upgrades that modify the packaged rule.
    为了减轻上述方法的缺点，引入了本地包括，增加了写入将被使用的任意规则的能力，并且不会在修改打包规则的升级上产生问题。
  - The files can be found in `/etc/apparmor.d/local/` and exist for the packages that are known to sometimes need slight tweaks for special setups
    这些文件可以在 `/etc/apparmor.d/local/` 中找到，并且存在于已知有时需要轻微调整特殊设置的软件包中

## References 引用 

- See the [AppArmor Administration Guide](http://www.novell.com/documentation/apparmor/apparmor201_sp10_admin/index.html?page=/documentation/apparmor/apparmor201_sp10_admin/data/book_apparmor_admin.html) for advanced configuration options.
  有关高级配置选项，请参阅AppArmor管理指南。
- For details using AppArmor with other Ubuntu releases see the [AppArmor Community Wiki](https://help.ubuntu.com/community/AppArmor) page.
  有关在其他Ubuntu版本中使用AppArmor的详细信息，请参阅AppArmor社区Wiki页面。
- The [OpenSUSE AppArmor](http://en.opensuse.org/SDB:AppArmor_geeks) page is another introduction to AppArmor.
  OpenSUSE AppArmor页面是AppArmor的另一个介绍。
- (https://wiki.debian.org/AppArmor) is another introduction and basic howto for AppArmor.
  （https：//wiki.debian.org/AppArmor）是AppArmor的另一个介绍和基本howto。
- A great place to get involved with the Ubuntu Server community and to ask for AppArmor assistance is the *#ubuntu-server* IRC channel on [Libera](https://libera.chat). The *#ubuntu-security* IRC channel may also be of use.
  Libera上的#ubuntu-server IRC频道是参与Ubuntu Server社区并寻求AppArmor帮助的好地方。#ubuntu-security IRC频道也可能有用。

------