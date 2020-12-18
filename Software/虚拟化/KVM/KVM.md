# KVM
KVM，基于内核的虚拟机，是 Linux 内核的一部分。

## 管理工具

1. virsh

2. Cockpit虚拟机工具

   ```bash
   yum install cockpit-machines
   systemctl enable --now cockpit.socket
   ```

## 系统需求
### 主机系统
1. one core or thread for each virtualized CPU and one for the host
2. 2GB RAM，plus additional RAM for virtual machines.
3. 6GB disk space for the host, plus the required disk place for the virtual machines.

### KVM hypervisor

Intel处理器（Intel VT-x和基于x86的系统的Intel64扩展）或者AMD处理器（AMD-V及AMD64扩展）

```bash
方法1：
# lscpu
Virtualization:   VT-x
Virtualization:   AMD-V
# egrep 'svm|vmx' /proc/cpuinfo
# svm Intel  vmx AMD

方法2：
virt-host-validate
# 系统必须通过所有验证项
```
### BIOS Enable Virtualization

## 安装

### CentOS

```bash
# 安装virt Yum模块
yum module list virt
yum module install virt

yum -y groupinstall "Virtualization Host"
yum -y install virt-{install,viewer,manager}

echo "net,ipv4.ip_forward = 1" > /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf

lsmod | grep kvm
```

## 故障处理
1. 修改网络相关信息，网卡不可用。
修改虚拟机配置文件　`/etc/udev/rules.d/70-persistent-net.rules`

## 发展历程

以色列创业公司 Qumranet员工 Avi Kivity 等人开发，2006 年 8 月完全开源，10 月 19 日首次发布在 Linux 内核的邮件列表里。

KVM 补丁集的第一个版本一经发布就支持了英特尔 CPU 刚刚引入的 VMX 指令。对 AMD 的 SVM 指令的支持紧随其后。KVM 补丁集在 2006 年 12 月合并进上游内核。

2007 年 2 月，Linux Kernel-2.6.20 中第一次包含了 KVM。

2008 年 9 月，红帽收购了 Qumranet ，由此入手了 KVM 的虚拟化技术。在之前，红帽是将 Xen 加入到自己的默认特性当中。那是2006 年，因为当时Xen技术脱离了内核的维护方式，也许是因为采用 Xen 的 RHEL  在企业级虚拟化方面没有赢得太多的市场，也许是因为思杰跟微软走的太近了，种种原因，导致其萌生了放弃 Xen。而且在正式采用 KVM 一年后，就宣布在新的产品线中彻底放弃 Xen ，集中资源和精力进行 KVM 的工作。

2009 年 9 月，红帽发布 RHEL5.4 ，在原先的 Xen 虚拟化机制之上，将 KVM 添加了进来。

2010 年 11 月，红帽发布 RHEL6.0 ，将默认安装的 Xen 虚拟化机制彻底去除，仅提供 KVM 虚拟化机制。

2011 年初，红帽的老搭档 IBM 找上红帽，表示 KVM 这个东西值得加大力度去做。于是到了 5 月， IBM  和红帽，联合惠普和英特尔一起，成立了开放虚拟化联盟（ Open Virtualization Alliance ），一起声明要提升 KVM  的形象，加速 KVM 投入市场的速度，由此避免 VMware 一家独大的情况出现。联盟成立之时，红帽的发言人表示， 大家都希望除 “  VMware 之外还有一种开源选择。未来的云基础设施一定会基于开源。自 Linux 2.6.20 之后逐步取代 Xen 被集成在Linux 的各个主要发行版本中，使用 Linux 自身的调度器进行管理。