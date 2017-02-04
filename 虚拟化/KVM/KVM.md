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

    # lscpu
    Virtualization:   VT-x
    Virtualization:   AMD-V
    # egrep 'svm|vmx' /proc/cpuinfo
### BIOS Enable Virtualization
