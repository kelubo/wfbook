# DRBD

[TOC]

# Distributed Replicated Block Device (DRBD) 分布式复制块设备（DRBD） 

Distributed Replicated Block Device (DRBD) mirrors block devices between multiple  hosts. The replication is transparent to other applications on the host  systems. Any block device hard disks, partitions, RAID devices, logical  volumes, etc can be mirrored.
分布式复制块设备（DRBD）在多个主机之间镜像块设备。复制对主机系统上的其他应用程序是透明的。任何块设备硬盘，分区，RAID设备，逻辑卷等都可以镜像。 

## Install DRBD 安装DRBD 

To get started using DRBD, first install the necessary packages. In a terminal window, run the following command:
要开始使用DRBD，首先安装必要的包。在终端窗口中，运行以下命令： 

```bash
sudo apt install drbd-utils
```

> **Note**: 注意事项：
>  If you are using the **virtual kernel** as part of a virtual machine you will need to manually compile the `drbd` module. It may be easier to install the `linux-modules-extra-$(uname -r)` package inside the virtual machine.
>  如果你使用虚拟内核作为虚拟机的一部分，你需要手动编译 `drbd` 模块。在虚拟机内部安装 `linux-modules-extra-$(uname -r)` 包可能更容易。

## Configure DRBD 配置DRBD 

This section covers setting up a DRBD to replicate a separate `/srv` partition, with an `ext3` filesystem between two hosts. The partition size is not particularly relevant, but both partitions need to be the same size.
本节介绍如何设置DRBD来复制一个单独的 `/srv` 分区，并在两台主机之间使用一个 `ext3` 文件系统。分区大小并不特别相关，但两个分区的大小必须相同。

The two hosts in this example will be called **`drbd01`** and **`drbd02`**. They will need to have name resolution configured either through DNS or the `/etc/hosts` file. See our [guide to DNS](https://ubuntu.com/server/docs/domain-name-service-dns) for details.
本例中的两台主机将被称为 `drbd01` 和 `drbd02` 。他们需要通过DNS或 `/etc/hosts` 文件配置名称解析。请参阅我们的DNS指南了解详情。

On the first host, edit `/etc/drbd.conf` as follows:
在第一台主机上，按如下方式编辑 `/etc/drbd.conf` ：

```auto
global { usage-count no; }
common { syncer { rate 100M; } }
resource r0 {
        protocol C;
        startup {
                wfc-timeout  15;
                degr-wfc-timeout 60;
        }
        net {
                cram-hmac-alg sha1;
                shared-secret "secret";
        }
        on drbd01 {
                device /dev/drbd0;
                disk /dev/sdb1;
                address 192.168.0.1:7788;
                meta-disk internal;
        }
        on drbd02 {
                device /dev/drbd0;
                disk /dev/sdb1;
                address 192.168.0.2:7788;
                meta-disk internal;
        }
} 
```

> **Note**: 注意事项：
>  There are many other options in `/etc/drbd.conf`, but for this example the default values are enough.
>  `/etc/drbd.conf` 中还有许多其他选项，但对于本例，默认值就足够了。

Now copy `/etc/drbd.conf` to the second host:
现在将 `/etc/drbd.conf` 复制到第二台主机：

```bash
scp /etc/drbd.conf drbd02:~
```

And, on `drbd02`, move the file to `/etc`:
然后，在 `drbd02` 上，将文件移动到 `/etc` ：

```bash
sudo mv drbd.conf /etc/
```

Now using the `drbdadm` utility, initialise the meta data storage. On both servers, run:
现在使用 `drbdadm` 实用程序初始化Meta数据存储。在两台服务器上运行：

```bash
sudo drbdadm create-md r0
```

Next, on both hosts, start the `drbd` daemon:
接下来，在两台主机上启动 `drbd` 守护程序：

```bash
sudo systemctl start drbd.service
```

On `drbd01` (or whichever host you wish to be the primary), enter the following:
在 `drbd01` （或您希望作为主主机的任何主机）上，输入以下内容：

```bash
sudo drbdadm -- --overwrite-data-of-peer primary all
```

After running the above command, the data will start syncing with the secondary host. To watch the progress, on `drbd02` enter the following:
运行上述命令后，数据将开始与辅助主机同步。要查看进度，请在 `drbd02` 上输入以下内容：

```bash
watch -n1 cat /proc/drbd
```

To stop watching the output press Ctrl + C.
要停止观看输出，请按 Ctrl + C 。

Finally, add a filesystem to `/dev/drbd0` and mount it:
最后，将文件系统添加到 `/dev/drbd0` 并挂载它：

```bash
sudo mkfs.ext3 /dev/drbd0
sudo mount /dev/drbd0 /srv
```

## Testing 测试 

To test that the data is actually syncing between the hosts copy some files on `drbd01`, the primary, to `/srv`:
要测试数据是否在主机之间实际同步，请将 `drbd01` （主主机）上的一些文件复制到 `/srv` ：

```bash
sudo cp -r /etc/default /srv
```

Next, unmount `/srv`: 接下来，卸载 `/srv` ：

```bash
sudo umount /srv
```

Now demote the **primary** server to the **secondary** role:
现在将主服务器降级为辅助角色：

```bash
sudo drbdadm secondary r0
```

Now on the **secondary** server, promote it to the **primary** role:
现在，在辅助服务器上，将其提升为主角色：

```bash
sudo drbdadm primary r0
```

Lastly, mount the partition:
最后，挂载分区： 

```bash
sudo mount /dev/drbd0 /srv
```

Using `ls` you should see `/srv/default` copied from the former primary host `drbd01`.
使用 `ls` 时，您应该看到 `/srv/default` 是从以前的主主机 `drbd01` 复制的。

## Further reading 进一步阅读 

- For more information on DRBD see the [DRBD web site](http://www.drbd.org/).
  有关DRBD的更多信息，请参阅DRBD网站。
- The [drbd.conf manpage](http://manpages.ubuntu.com/manpages/en/man5/drbd.conf.5.html) contains details on the options not covered in this guide.
  conf手册页包含本指南中未涉及的选项的详细信息。
- Also, see the [drbdadm manpage](http://manpages.ubuntu.com/manpages/en/man8/drbdadm.8.html).
  另请参阅drbdadm手册页。

------

Distributed Replicated Block Device (DRBD) mirrors block devices  between multiple hosts. The replication is transparent to other  applications on the host systems. Any block device hard disks,  partitions, RAID devices, logical volumes, etc can be mirrored.

To get started using drbd, first install the necessary packages. From a terminal enter:

```
sudo apt install drbd8-utils
```

> **Note**
>
> If you are using the *virtual kernel* as part of a virtual  machine you will need to manually compile the drbd module. It may be  easier to install the linux-server package inside the virtual machine.

This section covers setting up a drbd to replicate a separate `/srv` partition, with an ext3 filesystem between two hosts. The partition  size is not particularly relevant, but both partitions need to be the  same size.

## Configuration

The two hosts in this example will be called *drbd01* and *drbd02*. They will need to have name resolution configured either through DNS or the `/etc/hosts` file. See [???](https://ubuntu.com/server/docs/ubuntu-ha-drbd#dns) for details.

- To configure drbd, on the first host edit `/etc/drbd.conf`:

  ```
  global { usage-count no; }
  common { syncer { rate 100M; } }
  resource r0 {
          protocol C;
          startup {
                  wfc-timeout  15;
                  degr-wfc-timeout 60;
          }
          net {
                  cram-hmac-alg sha1;
                  shared-secret "secret";
          }
          on drbd01 {
                  device /dev/drbd0;
                  disk /dev/sdb1;
                  address 192.168.0.1:7788;
                  meta-disk internal;
          }
          on drbd02 {
                  device /dev/drbd0;
                  disk /dev/sdb1;
                  address 192.168.0.2:7788;
                  meta-disk internal;
          }
  } 
  ```

  > **Note**
  >
  > There are many other options in `/etc/drbd.conf`, but for this example their default values are fine.

- Now copy `/etc/drbd.conf` to the second host:

  ```
  scp /etc/drbd.conf drbd02:~
  ```

- And, on *drbd02* move the file to `/etc`:

  ```
  sudo mv drbd.conf /etc/
  ```

- Now using the drbdadm utility initialize the meta data storage. On each server execute:

  ```
  sudo drbdadm create-md r0
  ```

- Next, on both hosts, start the drbd daemon:

  ```
  sudo systemctl start drbd.service
  ```

- On the *drbd01*, or whichever host you wish to be the primary, enter the following:

  ```
  sudo drbdadm -- --overwrite-data-of-peer primary all
  ```

- After executing the above command, the data will start syncing with the secondary host. To watch the progress, on *drbd02* enter the following:

  ```
  watch -n1 cat /proc/drbd
  ```

  To stop watching the output press *Ctrl+c*.

- Finally, add a filesystem to `/dev/drbd0` and mount it:

  ```
  sudo mkfs.ext3 /dev/drbd0
  sudo mount /dev/drbd0 /srv
  ```

## Testing

To test that the data is actually syncing between the hosts copy some files on the *drbd01*, the primary, to `/srv`:

```
sudo cp -r /etc/default /srv
```

Next, unmount `/srv`:

```
sudo umount /srv
```

*Demote* the *primary* server to the *secondary* role:

```
sudo drbdadm secondary r0
```

Now on the *secondary* server *promote* it to the *primary* role:

```
sudo drbdadm primary r0
```

Lastly, mount the partition:

```
sudo mount /dev/drbd0 /srv
```

Using *ls* you should see `/srv/default` copied from the former *primary* host *drbd01*.

## References

- For more information on DRBD see the [DRBD web site](http://www.drbd.org/).
- The [drbd.conf man page](http://manpages.ubuntu.com/manpages/eoan/en/man5/drbd.conf.5.html) contains details on the options not covered in this guide.
- Also, see the [drbdadm man page](http://manpages.ubuntu.com/manpages/eoan/en/man8/drbdadm.8.html).
- The [DRBD Ubuntu Wiki](https://help.ubuntu.com/community/DRBD) page also has more information.