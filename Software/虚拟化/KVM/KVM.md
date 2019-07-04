# KVM
KVM，基于内核的虚拟机，是 Linux 内核的一部分。于 2006 年 10 月 19 日由 Avi Kivity 首次发布在 Linux 内核的邮件列表里。

KVM 补丁集的第一个版本一经发布就支持了英特尔 CPU 刚刚引入的 VMX 指令。对 AMD 的 SVM 指令的支持紧随其后。KVM 补丁集在 2006 年 12 月合并进上游内核，并在 2007 年 2 月作为 2.6.20 内核的一部分发布。
背景

## 系统需求
### 主机系统
1. one core or thread for each virtualized CPU and one for the host
2. 2GB RAM，plus additional RAM for virtual machines.
3. 6GB disk space for the host, plus the required disk place for the virtual machines.

### KVM hypervisor

```bash
# lscpu
Virtualization:   VT-x
Virtualization:   AMD-V
# egrep 'svm|vmx' /proc/cpuinfo
# svm Intel  vmx AMD
```
### BIOS Enable Virtualization

## 安装

### CentOS

```bash
yum -y groupinstall "Virtualization Host"
yum -y install virt-{install,viewer,manager}

echo "net,ipv4.ip_forward = 1" > /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf

lsmod | grep kvm
```

## 故障处理
1. 修改网络相关信息，网卡不可用。
修改虚拟机配置文件　`/etc/udev/rules.d/70-persistent-net.rules`
