# Mount CephFS: Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#mount-cephfs-prerequisites)

You can use CephFS by mounting it to your local filesystem or by using [cephfs-shell](https://docs.ceph.com/en/latest/cephfs/cephfs-shell). Mounting CephFS requires superuser privileges to trim dentries by issuing a remount of itself. CephFS can be mounted [using kernel](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver) as well as [using FUSE](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse). Both have their own advantages. Read the following section to understand more about both of these ways to mount CephFS.

For Windows CephFS mounts, please check the [ceph-dokan](https://docs.ceph.com/en/latest/cephfs/ceph-dokan) page.

## Which CephFS Client?[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#which-cephfs-client)

The FUSE client is the most accessible and the easiest to upgrade to the version of Ceph used by the storage cluster, while the kernel client will always gives better performance.

When encountering bugs or performance issues, it is often instructive to try using the other client, in order to find out whether the bug was client-specific or not (and then to let the developers know).

## General Pre-requisite for Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#general-pre-requisite-for-mounting-cephfs)

Before mounting CephFS, ensure that the client host (where CephFS has to be mounted and used) has a copy of the Ceph configuration file (i.e. `ceph.conf`) and a keyring of the CephX user that has permission to access the MDS. Both of these files must already be present on the host where the Ceph MON resides.

1. Generate a minimal conf file for the client host and place it at a standard location:

   ```
   # on client host
   mkdir -p -m 755 /etc/ceph
   ssh {user}@{mon-host} "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf
   ```

   Alternatively, you may copy the conf file. But the above method generates a conf with minimal details which is usually sufficient. For more information, see [Client Authentication](https://docs.ceph.com/en/latest/cephfs/client-auth) and [Bootstrap options](https://docs.ceph.com/en/latest/rados/configuration/ceph-conf/#bootstrap-options).

2. Ensure that the conf has appropriate permissions:

   ```
   chmod 644 /etc/ceph/ceph.conf
   ```

3. Create a CephX user and get its secret key:

   ```
   ssh {user}@{mon-host} "sudo ceph fs authorize cephfs client.foo / rw" | sudo tee /etc/ceph/ceph.client.foo.keyring
   ```

   In above command, replace `cephfs` with the name of your CephFS, `foo` by the name you want for your CephX user and `/` by the path within your CephFS for which you want to allow access to the client host and `rw` stands for both read and write permissions. Alternatively, you may copy the Ceph keyring from the MON host to client host at `/etc/ceph` but creating a keyring specific to the client host is better. While creating a CephX keyring/client, using same client name across multiple machines is perfectly fine.

   Note

   If you get 2 prompts for password while running above any of 2 above command, run `sudo ls` (or any other trivial command with sudo) immediately before these commands.

4. Ensure that the keyring has appropriate permissions:

   ```
   chmod 600 /etc/ceph/ceph.client.foo.keyring
   ```

Note

There might be few more prerequisites for kernel and FUSE mounts individually, please check respective mount documents.

# Mount CephFS using Kernel Driver[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#mount-cephfs-using-kernel-driver)

The CephFS kernel driver is part of the Linux kernel. It allows mounting CephFS as a regular file system with native kernel performance. It is the client of choice for most use-cases.

Note

CephFS mount device string now uses a new (v2) syntax. The mount helper (and the kernel) is backward compatible with the old syntax. This means that the old syntax can still be used for mounting with newer mount helpers and kernel. However, it is recommended to use the new syntax whenever possible.

## Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#prerequisites)

### Complete General Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#complete-general-prerequisites)

Go through the prerequisites required by both, kernel as well as FUSE mounts, in [Mount CephFS: Prerequisites](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites) page.

### Is mount helper is present?[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#is-mount-helper-is-present)

`mount.ceph` helper is installed by Ceph packages. The helper passes the monitor address(es) and CephX user keyrings automatically saving the Ceph admin the effort to pass these details explicitly while mounting CephFS. In case the helper is not present on the client machine, CephFS can still be mounted using kernel but by passing these details explicitly to the `mount` command. To check whether it is present on your system, do:

```
stat /sbin/mount.ceph
```

### Which Kernel Version?[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#which-kernel-version)

Because the kernel client is distributed as part of the linux kernel (not as part of packaged ceph releases), you will need to consider which kernel version to use on your client nodes. Older kernels are known to include buggy ceph clients, and may not support features that more recent Ceph clusters support.

Remember that the “latest” kernel in a stable linux distribution is likely to be years behind the latest upstream linux kernel where Ceph development takes place (including bug fixes).

As a rough guide, as of Ceph 10.x (Jewel), you should be using a least a 4.x kernel. If you absolutely have to use an older kernel, you should use the fuse client instead of the kernel client.

This advice does not apply if you are using a linux distribution that includes CephFS support, as in this case the distributor will be responsible for backporting fixes to their stable kernel: check with your vendor.

## Synopsis[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#synopsis)

In general, the command to mount CephFS via kernel driver looks like this:

```
mount -t ceph {device-string}={path-to-mounted} {mount-point} -o {key-value-args} {other-args}
```

## Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#mounting-cephfs)

On Ceph clusters, CephX is enabled by default. Use `mount` command to mount CephFS with the kernel driver:

```
mkdir /mnt/mycephfs
mount -t ceph <name>@<fsid>.<fs_name>=/ /mnt/mycephfs
```

`name` is the username of the CephX user we are using to mount CephFS. `fsid` is the FSID of the ceph cluster which can be found using `ceph fsid` command. `fs_name` is the file system to mount. The kernel driver requires MON’s socket and the secret key for the CephX user, e.g.:

```
mount -t ceph cephuser@b3acfc0d-575f-41d3-9c91-0e7ed3dbb3fa.cephfs=/ -o mon_addr=192.168.0.1:6789,secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

When using the mount helper, monitor hosts and FSID are optional. `mount.ceph` helper figures out these details automatically by finding and reading ceph conf file, .e.g:

```
mount -t ceph cephuser@.cephfs=/ -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

Note

Note that the dot (`.`) still needs to be a part of the device string.

A potential problem with the above command is that the secret key is left in your shell’s command history. To prevent that you can copy the secret key inside a file and pass the file by using the option `secretfile` instead of `secret`:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

Ensure the permissions on the secret key file are appropriate (preferably, `600`).

Multiple monitor hosts can be passed by separating each address with a `/`:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o mon_addr=192.168.0.1:6789/192.168.0.2:6789,secretfile=/etc/ceph/cephuser.secret
```

In case CephX is disabled, you can omit any credential related options:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs
```

Note

The ceph user name still needs to be passed as part of the device string.

To mount a subtree of the CephFS root, append the path to the device string:

```
mount -t ceph cephuser@.cephfs=/subvolume/dir1/dir2 /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

## Unmounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#unmounting-cephfs)

To unmount the Ceph file system, use the `umount` command as usual:

```
umount /mnt/mycephfs
```

Tip

Ensure that you are not within the file system directories before executing this command.

## Persistent Mounts[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#persistent-mounts)

To mount CephFS in your file systems table as a kernel driver, add the following to `/etc/fstab`:

```
{name}@.{fs_name}=/ {mount}/{mountpoint} ceph [mon_addr={ipaddress},secret=secretkey|secretfile=/path/to/secretfile],[{mount.options}]  {fs_freq}  {fs_passno}
```

For example:

```
cephuser@.cephfs=/     /mnt/ceph    ceph    mon_addr=192.168.0.1:6789,noatime,_netdev    0       0
```

If the `secret` or `secretfile` options are not specified then the mount helper will attempt to find a secret for the given `name` in one of the configured keyrings.

See [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/) for details on CephX user management and [mount.ceph](https://docs.ceph.com/en/latest/man/8/mount.ceph/) manual for more options it can take. For troubleshooting, see [Kernel mount debugging](https://docs.ceph.com/en/latest/cephfs/troubleshooting/#kernel-mount-debugging).

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