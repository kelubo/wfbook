# CephFS 挂载

[TOC]

## 先决条件

可以通过将 CephFS 挂载到本地文件系统或使用 cephfs-shell 来使用 CephFS 。Mounting CephFS requires superuser privileges to trim dentries by issuing a remount of itself. 装载CephFS需要超级用户权限，才能通过发出自身的重新装载来修剪dentries。CephFS 可以使用内核和 FUSE 挂载。两者各有优势。

FUSE 客户端是最容易访问的，也是最容易升级到存储集群使用的 Ceph 版本的，而内核客户端总是提供更好的性能。

当遇到 bug 或性能问题时，尝试使用另一个客户端通常是有益的，以便找出 bug 是否是特定于客户端的（然后让开发人员知道）。

在挂载 CephFS 之前，请确保客户端主机具有 Ceph 配置文件（即 `ceph.conf` ）的副本和有权访问 MDS 的 CephX 用户的密钥环。这两个文件必须已经存在于Ceph MON 所在的主机上。

1. 为客户端主机生成一个最小的 conf 文件，并将其放置在标准位置：

   ```bash
   # on client host
   mkdir -p -m 755 /etc/ceph
   ssh {user}@{mon-host} "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf
   ```

   或者，可以复制 conf 文件。但上面的方法生成了一个具有最少细节的 conf ，这通常就足够了。

2. 确保 conf 具有适当的权限：

   ```bash
   chmod 644 /etc/ceph/ceph.conf
   ```

3. 创建一个 CephX 用户并获取其密钥：

   ```bash
   ssh {user}@{mon-host} "sudo ceph fs authorize cephfs client.foo / rw" | sudo tee /etc/ceph/ceph.client.foo.keyring
   ```

   在上面的命令中，将 `cephfs` 替换为您的 CephFS 的名称，`foo` 替换为您想要的 CephX 用户的名称和and `/` by the path within your CephFS for which you want to allow access to the client host `/` 替换为您想要允许访问客户端主机的CephFS中的路径， `rw` 代表读取和写入权限。或者，可以将 Ceph 密钥环从 MON 主机复制到客户端主机的 `/etc/ceph` 中，但创建特定于客户端主机的密钥环更好。在创建 CephX 密钥环/客户端时，在多台机器上使用相同的客户端名称是完全可以的。

   > 注意
   >
   > 如果你在运行以上2个命令中的任何一个时得到2个密码提示，请在这些命令之前立即运行sudo ls（或任何其他带有sudo的普通命令）。
   >
   > If you get 2 prompts for password while running above any of 2 above command, run `sudo ls` (or any other trivial command with sudo) immediately before these commands.

4. 确保密钥环具有适当的权限：

   ```bash
   chmod 600 /etc/ceph/ceph.client.foo.keyring
   ```

##  使用 Kernel Driver 挂载

CephFS 内核驱动程序是 Linux 内核的一部分。它允许将 CephFS 挂载为具有本机内核性能的常规文件系统。它是大多数用例的首选客户端。

> 注意
>
> CephFS mount device string now uses a new (v2) syntax. The mount helper (and the kernel) is backward compatible with the old syntax. This means that the old syntax can still be used for mounting with newer mount helpers and kernel. 
>
> CephFS 装载设备字符串现在使用新的（v2）语法。挂载助手（和内核）与旧语法向后兼容。这意味着旧的语法仍然可以用于使用更新的挂载助手和内核进行挂载。但是，建议尽可能使用新语法。



# Supported Features of the Kernel Driver[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#supported-features-of-the-kernel-driver)

The kernel driver is developed separately from the core ceph code, and as such it sometimes differs from the FUSE driver in feature implementation. The following details the implementation status of various CephFS features in the kernel driver.

## Inline data[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#inline-data)

Inline data was introduced by the Firefly release. This feature is being deprecated in mainline CephFS, and may be removed from a future kernel release.

Linux kernel clients >= 3.19 can read inline data and convert existing inline data to RADOS objects when file data is modified. At present, Linux kernel clients do not store file data as inline data.

See [Experimental Features](https://docs.ceph.com/en/latest/cephfs/experimental-features) for more information.

## Quotas[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#quotas)

Quota was first introduced by the hammer release. Quota disk format got renewed by the Mimic release. Linux kernel clients >= 4.17 can support the new format quota. At present, no Linux kernel client support the old format quota.

See [Quotas](https://docs.ceph.com/en/latest/cephfs/quota) for more information.

## Multiple file systems within a Ceph cluster[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#multiple-file-systems-within-a-ceph-cluster)

The feature was introduced by the Jewel release. Linux kernel clients >= 4.7 can support it.

See [Experimental Features](https://docs.ceph.com/en/latest/cephfs/experimental-features) for more information.

## Multiple active metadata servers[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#multiple-active-metadata-servers)

The feature has been supported since the Luminous release. It is recommended to use Linux kernel clients >= 4.14 when there are multiple active MDS.

## Snapshots[](https://docs.ceph.com/en/latest/cephfs/kernel-features/#snapshots)

The feature has been supported since the Mimic release. It is recommended to use Linux kernel clients >= 4.17 if snapshot is used.

Brought to you by the Ceph Foundation

The Ceph Documentation is a community resource funded and hosted by the non-profit [Ceph Foundation](https://ceph.io/en/foundation/). If you would like to support this and our other efforts, please consider [joining now](https://ceph.io/en/foundation/join/).



### 是否存在挂载助手？

`mount.ceph` 助手由 Ceph 软件包安装。助手会自动传递 MON 地址和 CephX 用户密钥环，从而节省 Ceph 管理员在挂载 CephFS 时显式传递这些详细信息的工作量。如果客户端机器上没有帮助程序，CephFS 仍然可以使用内核进行挂载，但要将这些详细信息明确地传递给 `mount` 命令。要检查它是否存在于您的系统中，请执行以下操作：

```bash
stat /sbin/mount.ceph
```

### 哪个内核版本？

由于内核客户端是作为 linux 内核的一部分（而不是作为 ceph 打包版本的一部分）发布的，因此您需要考虑在客户端节点上使用哪个内核版本。较旧的内核包含有 bug 的 Ceph 客户端，并且可能不支持较新的 Ceph 集群支持的功能。

请记住，稳定的 Linux 发行版中的"最新"内核可能比 Ceph 开发（包括 bug 修复）的最新上游 Linux 内核晚几年。

作为一个粗略的指南，从 Ceph 10.x（Jewel）开始，应该使用至少 4.x 内核。如果你必须使用一个旧的内核，应该使用 fuse 客户端而不是内核客户端。

如果使用的是包含 CephFS 支持的 Linux 发行版，则此建议不适用，因为在这种情况下，发行版将负责将修复程序反向移植到其稳定内核：请与您的供应商联系。

### 语法

通常，通过内核驱动程序挂载 CephFS 的命令如下所示：

```bash
mount -t ceph {device-string}={path-to-mounted} {mount-point} -o {key-value-args} {other-args}
```

### 挂载

在 Ceph 集群上，默认情况下启用 CephX 。使用 `mount` 命令挂载带有内核驱动的 CephFS ：

```bash
mkdir /mnt/mycephfs
mount -t ceph <name>@<fsid>.<fs_name>=/ /mnt/mycephfs
```

`name` 是我们用来挂载 CephFS 的 CephX 用户的用户名。`fsid` 是 ceph 集群的 FSID ，可以使用 `ceph fsid` 命令找到。`fs_name` 是要挂载的文件系统。内核驱动程序需要 MON 的套接字和 CephX 用户的密钥，例如：

```bash
mount -t ceph cephuser@b3acfc0d-575f-41d3-9c91-0e7ed3dbb3fa.cephfs=/ /mnt/mycephfs -o mon_addr=192.168.0.1:6789,secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

使用挂载助手时，MON 和 FSID 是可选的。`mount.ceph`  helper 通过查找和阅读 ceph conf 文件自动计算出这些细节，例如：

```bash
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

> Note
>
> 请注意，点（ `.` ）仍然需要成为设备串的一部分。

上述命令的一个潜在问题是，密钥会留在 shell 的命令历史记录中。为了防止，您可以复制文件内的密钥并通过使用选项 `secretfile` 而不是 `secret` 来传递文件：

```bash
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

确保密钥文件上的权限是适当的（最好是 600）。

可以通过使用 `/` 分隔每个地址来传递多个 MON 主机：

```bash
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o mon_addr=192.168.0.1:6789/192.168.0.2:6789,secretfile=/etc/ceph/cephuser.secret
```

如果 CephX 被禁用，可以忽略任何与凭据相关的选项：

```bash
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs
```

> Note
>
> ceph 用户名仍然需要作为设备字符串的一部分传递。

要装载 CephFS 根目录的子树，请将路径附加到设备字符串：

```bash
mount -t ceph cephuser@.cephfs=/subvolume/dir1/dir2 /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

### 向后兼容性

支持旧语法是为了向后兼容。

使用内核驱动程序挂载 CephFS ：

```bash
mkdir /mnt/mycephfs
mount -t ceph :/ /mnt/mycephfs -o name=admin
```

选项 `-o` 后面的 key-value 参数是 CephX credential; `name` 是我们用来挂载 CephFS 的 CephX 用户的用户名。

如果集群有多个FS，要挂载非默认 `cephfs2` ：

```bash
mount -t ceph :/ /mnt/mycephfs -o name=admin,fs=cephfs2
# OR
mount -t ceph :/ /mnt/mycephfs -o name=admin,mds_namespace=cephfs2
```

> Note
>
> 不推荐使用选项 `mds_namespace` 。在使用旧语法挂载时，请使用 `fs=`  。

### 卸载

```bash
umount /mnt/mycephfs
```

> Tip
>
> 在执行此命令之前，请确保您不在文件系统目录中。

### 持久挂载

To mount CephFS in your file systems table as a kernel driver要在文件系统表中挂载 CephFS 作为内核驱动程序，请将以下内容添加到 `/etc/fstab` ：

```bash
{name}@.{fs_name}=/ {mount}/{mountpoint} ceph [mon_addr={ipaddress},secret=secretkey|secretfile=/path/to/secretfile],[{mount.options}]  {fs_freq}  {fs_passno}
```

例如：

```bash
cephuser@.cephfs=/     /mnt/ceph    ceph    mon_addr=192.168.0.1:6789,noatime,_netdev    0       0
```

如果未指定 `secret` 或 `secretfile` 选项，则挂载助手将尝试在一个已配置的密钥环中查找给定 `name` 的 secret 。

# Mount CephFS using FUSE[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#mount-cephfs-using-fuse)

[ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#options) is an alternate way of mounting CephFS, although it mounts it in userspace. Therefore, performance of FUSE can be relatively lower but FUSE clients can be more manageable, especially while upgrading CephFS.

## Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#prerequisites)

Go through the prerequisites required by both, kernel as well as FUSE mounts, in [Mount CephFS: Prerequisites](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites) page.

Note

Mounting CephFS using FUSE requires superuser privileges to trim dentries by issuing a remount of itself.

## Synopsis[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#synopsis)

In general, the command to mount CephFS via FUSE looks like this:

```
ceph-fuse {mountpoint} {options}
```

## Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#mounting-cephfs)

To FUSE-mount the Ceph file system, use the `ceph-fuse` command:

```
mkdir /mnt/mycephfs
ceph-fuse --id foo /mnt/mycephfs
```

Option `-id` passes the name of the CephX user whose keyring we intend to use for mounting CephFS. In the above command, it’s `foo`. You can also use `-n` instead, although `--id` is evidently easier:

```
ceph-fuse -n client.foo /mnt/mycephfs
```

In case the keyring is not present in standard locations, you may pass it too:

```
ceph-fuse --id foo -k /path/to/keyring /mnt/mycephfs
```

You may pass the MON’s socket too, although this is not mandatory:

```
ceph-fuse --id foo -m 192.168.0.1:6789 /mnt/mycephfs
```

You can also mount a specific directory within CephFS instead of mounting root of CephFS on your local FS:

```
ceph-fuse --id foo -r /path/to/dir /mnt/mycephfs
```

If you have more than one FS on your Ceph cluster, use the option `--client_fs` to mount the non-default FS:

```
ceph-fuse --id foo --client_fs mycephfs2 /mnt/mycephfs2
```

You may also add a `client_fs` setting to your `ceph.conf`

## Unmounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#unmounting-cephfs)

Use `umount` to unmount CephFS like any other FS:

```
umount /mnt/mycephfs
```

Tip

Ensure that you are not within the file system directories before executing this command.

## Persistent Mounts[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#persistent-mounts)

To mount CephFS as a file system in user space, add the following to `/etc/fstab`:

```
#DEVICE PATH       TYPE      OPTIONS
none    /mnt/mycephfs  fuse.ceph ceph.id={user-ID}[,ceph.conf={path/to/conf.conf}],_netdev,defaults  0 0
```

For example:

```
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,_netdev,defaults  0 0
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,ceph.conf=/etc/ceph/foo.conf,_netdev,defaults  0 0
```

Ensure you use the ID (e.g., `myuser`, not `client.myuser`). You can pass any valid `ceph-fuse` option to the command line this way.

To mount a subdirectory of the CephFS, add the following to `/etc/fstab`:

```
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,ceph.client_mountpoint=/path/to/dir,_netdev,defaults  0 0
```

`ceph-fuse@.service` and `ceph-fuse.target` systemd units are available. As usual, these unit files declare the default dependencies and recommended execution context for `ceph-fuse`. After making the fstab entry shown above, run following commands:

```
systemctl start ceph-fuse@/mnt/mycephfs.service
systemctl enable ceph-fuse.target
systemctl enable ceph-fuse@-mnt-mycephfs.service
```

See [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/#user-management) for details on CephX user management and [ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#options) manual for more options it can take. For troubleshooting, see [ceph-fuse debugging](https://docs.ceph.com/en/latest/cephfs/troubleshooting/#ceph-fuse-debugging).

# Mount CephFS on Windows[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mount-cephfs-on-windows)

`ceph-dokan` can be used for mounting CephFS filesystems on Windows. It leverages Dokany, a Windows driver that allows implementing filesystems in userspace, pretty much like FUSE.

Please check the [installation guide](https://docs.ceph.com/en/latest/install/windows-install) to get started.

## Usage[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#usage)

### Mounting filesystems[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mounting-filesystems)

In order to mount a ceph filesystem, the following command can be used:

```
ceph-dokan.exe -c c:\ceph.conf -l x
```

This will mount the default ceph filesystem using the drive letter `x`. If `ceph.conf` is placed at the default location, which is `%ProgramData%\ceph\ceph.conf`, then this argument becomes optional.

The `-l` argument also allows using an empty folder as a mountpoint instead of a drive letter.

The uid and gid used for mounting the filesystem default to 0 and may be changed using the following `ceph.conf` options:

```
[client]
# client_permissions = true
client_mount_uid = 1000
client_mount_gid = 1000
```

If you have more than one FS on your Ceph cluster, use the option `--client_fs` to mount the non-default FS:

```
mkdir -Force C:\mnt\mycephfs2
ceph-dokan.exe --mountpoint C:\mnt\mycephfs2 --client_fs mycephfs2
```

CephFS subdirectories can be mounted using the `--root-path` parameter:

```
ceph-dokan -l y --root-path /a
```

If the `-o --removable` flags are set, the mounts will show up in the `Get-Volume` results:

```
PS C:\> Get-Volume -FriendlyName "Ceph*" | `
        Select-Object -Property @("DriveLetter", "Filesystem", "FilesystemLabel")

DriveLetter Filesystem FilesystemLabel
----------- ---------- ---------------
          Z Ceph       Ceph
          W Ceph       Ceph - new_fs
```

Please use `ceph-dokan --help` for a full list of arguments.

### Credentials[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#credentials)

The `--id` option passes the name of the CephX user whose keyring we intend to use for mounting CephFS. The following commands are equivalent:

```
ceph-dokan --id foo -l x
ceph-dokan --name client.foo -l x
```

### Unmounting filesystems[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#unmounting-filesystems)

The mount can be removed by either issuing ctrl-c or using the unmap command, like so:

```
ceph-dokan.exe unmap -l x
```

Note that when unmapping Ceph filesystems, the exact same mountpoint argument must be used as when the mapping was created.

### Limitations[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#limitations)

Be aware that Windows ACLs are ignored. Posix ACLs are supported but cannot be modified using the current CLI. In the future, we may add some command actions to change file ownership or permissions.

Another thing to note is that cephfs doesn’t support mandatory file locks, which Windows is heavily rely upon. At the moment, we’re letting Dokan handle file locks, which are only enforced locally.

Unlike `rbd-wnbd`, `ceph-dokan` doesn’t currently provide a `service` command. In order for the cephfs mount to survive host reboots, consider using `NSSM`.

## Troubleshooting[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#troubleshooting)

Please consult the [Windows troubleshooting](https://docs.ceph.com/en/latest/install/windows-troubleshooting) page.