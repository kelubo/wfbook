# Installing MicroK8s on a Raspberry Pi 在 Raspberry Pi 上安装 MicroK8s

#### On this page 本页内容

​                                                [Kernel modules 内核模块](https://microk8s.io/docs/install-raspberry-pi#kernel-modules)                                                      [Installation 安装](https://microk8s.io/docs/install-raspberry-pi#installation)                                                              

**Note:**  Running Kubernetes can cause a lot of I/O requests and pressure on  storage. It is not recommended to use a USB stick as primary storage  when running MicroK8s.
**注意：**运行 Kubernetes 可能会导致大量 I/O 请求和存储压力。在运行 MicroK8s 时，不建议使用 U 盘作为主存储。

Running MicroK8s on some ARM hardware may run into difficulties because cgroups
在某些 ARM 硬件上运行 MicroK8s 可能会遇到困难，因为 cgroups
 (required!) are not enabled by default. This can be remedied on the Rasberry Pi
（必填！默认情况下不启用。这可以在 Rasberry Pi 上修复
 by editing the boot parameters:
通过编辑引导参数：

```bash
sudo vi /boot/firmware/cmdline.txt
```

Note: In some Raspberry Pi Linux distributions  the boot parameters are in `/boot/firmware/nobtcmd.txt`.
注意：在某些 Raspberry Pi Linux 发行版中，引导参数位于 '/boot/firmware/nobtcmd.txt' 中。

And adding the following:
并添加以下内容：

```no-highlight
cgroup_enable=memory cgroup_memory=1
```

To address disk performance issues often present on Raspberry Pi see the [troubleshooting section](https://microk8s.io/docs/troubleshooting).
要解决 Raspberry Pi 上经常出现的磁盘性能问题，请参阅[故障排除部分](https://microk8s.io/docs/troubleshooting)。

## [Kernel modules 内核模块](https://microk8s.io/docs/install-raspberry-pi#kernel-modules)

For Ubuntu 21.10+ it is necessary to install extra kernel modules:
对于 Ubuntu 21.10+，需要安装额外的内核模块：

```auto
sudo apt install linux-modules-extra-raspi
```

Then restart MicroK8s: 然后重新启动 MicroK8s：

```auto
sudo microk8s stop; sudo microk8s start
```

## [Installation 安装](https://microk8s.io/docs/install-raspberry-pi#installation)

Installation is then via the snap as usual:
然后像往常一样通过快照进行安装：

```bash
sudo snap install microk8s --classic --channel=1.30
```