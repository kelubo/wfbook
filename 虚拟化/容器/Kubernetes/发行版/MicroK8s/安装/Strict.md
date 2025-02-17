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