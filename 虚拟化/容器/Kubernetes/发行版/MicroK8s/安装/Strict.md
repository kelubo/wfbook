# Strict MicroK8s 严格的 MicroK8s

#### On this page 本页内容

​                                                [Install strict 安装 strict](https://microk8s.io/docs/install-strict#install-strict)                                                              

Before you install the strictly confined version of MicroK8s, please familiarise yourself with the differences by reading this [explanation of strict confinement](https://microk8s.io/docs/strict-confinement).
在安装 MicroK8s 的严格限制版本之前，请阅读此[严格限制说明](https://microk8s.io/docs/strict-confinement)，以熟悉差异。

## [Install strict 安装 strict](https://microk8s.io/docs/install-strict#install-strict)

Strictly confined MicroK8s is installed via the tracks that include strict in their name. For example:
严格受限的 MicroK8s 是通过名称中包含 strict 的轨道安装的。例如：

```auto
snap install microk8s --channel 1.29-strict
```

If there are workloads that don’t run as expected under strict confinement Apparmor denials will be reported in the system logs. You can try to  find what is causing the problem by using [snappy-debug](https://snapcraft.io/docs/debug-snaps).
如果存在在严格限制下未按预期运行的工作负载，系统日志中将报告 Apparmor 拒绝。您可以尝试使用 [snappy-debug](https://snapcraft.io/docs/debug-snaps) 查找导致问题的原因。

You can also try running the snap in devmode. A devmode snap runs as a  strictly confined snap with full access to system resources and produces debug output to identify unspecified interfaces. You need to install  the snap with the devmode flag:
您还可以尝试在 devmode 中运行 snap。devmode 快照作为严格限制的快照运行，具有对系统资源的完全访问权限，并生成调试输出以识别未指定的接口。您需要安装带有 devmode 标志的 snap：

```auto
snap install microk8s --channel=1.29-strict --devmode
```

# Strict confinement 严格禁闭

#### On this page 本页内容

​                                                [What is strict confinement?
什么是严格禁闭？](https://microk8s.io/docs/strict-confinement#what-is-strict-confinement)                                                      [How to grant permissions?
如何授予权限？](https://microk8s.io/docs/strict-confinement#how-to-grant-permissions)                                                      [What does this mean for MicroK8s?
这对 MicroK8s 意味着什么？](https://microk8s.io/docs/strict-confinement#what-does-this-mean-for-microk8s)                                                              

## [ What is strict confinement? 什么是严格禁闭？](https://microk8s.io/docs/strict-confinement#what-is-strict-confinement)

Strict confinement is a [snap confinement level](https://snapcraft.io/docs/snap-confinement) that provides complete isolation, up to a minimal access level to the  host resources. Strictly confined snaps can not access files, networks,  processes, or any other system resource without requesting specific  permission. It is therefore deemed safe. Strict confinement uses  security features of the Linux kernel, including AppArmor, seccomp, and  namespaces to prevent applications and services from accessing the wider system.
严格限制是一种[快照限制级别](https://snapcraft.io/docs/snap-confinement)，可提供完全隔离，最高可达对主机资源的最低访问级别。严格限制的快照在未请求特定权限的情况下无法访问文件、网络、进程或任何其他系统资源。因此，它被认为是安全的。严格限制使用 Linux 内核的安全功能，包括 AppArmor、seccomp 和命名空间，以防止应用程序和服务访问更广泛的系统。

## [ How to grant permissions? 如何授予权限？](https://microk8s.io/docs/strict-confinement#how-to-grant-permissions)

Interfaces are the key. Interfaces have two sides a plug and a slot. Plugs can be  thought of as resource access requests while slots are the resource  access options available on a host. Each snap’s slot is carefully  selected by the creator to map resource requirements while plugs are  predefined system wide. An interface needs to be connected to be active  so connections are made (either automatically at install time or  manually) depending on their function. See the full list of interfaces  interfaces [here](https://snapcraft.io/docs/supported-interfaces).
接口是关键。接口有两侧：插头和插槽。插件可以被视为资源访问请求，而槽是主机上可用的资源访问选项。每个快照的插槽都由创建者精心选择，以映射资源需求，而插头则在系统范围内预定义。需要连接接口才能处于活动状态，以便根据其功能建立连接（在安装时自动或手动）。[在此处](https://snapcraft.io/docs/supported-interfaces)查看接口接口的完整列表。

## [ What does this mean for MicroK8s? 这对 MicroK8s 意味着什么？](https://microk8s.io/docs/strict-confinement#what-does-this-mean-for-microk8s)

Strict confinement proves to be a great match for the Kubernetes runtime and  hosted workloads. Often times these application workloads interact with  the host machines in ways that can be unpredictable and might even be  insecure. Strict confinement makes sure that this dynamic environment is isolated and that application workloads are doing what they are  expected to be doing. Any CVEs, malicious actors, bugs, etc. will be  limited to the sandbox setup by strict confinement.
事实证明，严格限制非常适合 Kubernetes  运行时和托管工作负载。通常，这些应用程序工作负载以不可预测的方式与主机交互，甚至可能不安全。严格限制可确保此动态环境是隔离的，并且应用程序工作负载正在执行预期作。任何 CVE、恶意行为者、错误等都将通过严格限制限制在沙盒设置中。

Note that there are caveats to this level of isolation. Some applications  that require elevated permissions to critical system resources which  might not be allowed to run.
请注意，此隔离级别有一些注意事项。某些应用程序需要对可能不允许运行的关键系统资源具有提升的权限。

#### Notable differences between strict and classic MicroK8s versions 严格版和经典版 MicroK8s 之间的显著差异

- Workloads requiring “shared mount” point with the host are blocked because they  break the expected isolation. For these workloads the classic snap  should be used instead (`snap install microk8s --classic`). Addons affected by this include, `cilium`, `gpu` and `multus`.
  需要与主机“共享挂载”点的工作负载将被阻止，因为它们会破坏预期的隔离。对于这些工作负载，应改用经典快照 （ `snap install microk8s --classic` ）。受此影响的插件包括 `cilium`、`gpu` 和 `multus`。
- The MicroK8s team tests the strictly confined snap extensively against a  large set of workloads. However this does not guarantee that every  possible workload will run unaffected in a strictly confined setup.  Should you find one such workload we would appreciate if you opened a [github issue](https://github.com/canonical/microk8s/issues) so we can review the case and include proper mitigation in future releases. To handle such cases users can use the `--devmode` flag when installing the strict snap.
  MicroK8s 团队针对大量工作负载对严格受限快照进行了广泛的测试。但是，这并不能保证每个可能的工作负载在严格受限的设置中不受影响地运行。如果您找到这样的工作负载，如果您打开 [github 问题](https://github.com/canonical/microk8s/issues)，我们将不胜感激，以便我们审查案例并在未来的版本中包括适当的缓解措施。要处理此类情况，用户可以在安装 strict snap 时使用 `--devmode` 标志。
- Due to limitations in how strictly confined services are handled certain `microk8s` commands that anyone from the `microk8s` user groups could execute now require elevated permissions.
  由于处理严格受限服务的方式存在限制，`microk8s` 用户组中的任何人都可以执行的某些 `microk8s` 命令现在需要提升的权限。