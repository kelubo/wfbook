# Client Configuration[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#client-configuration)

## Updating Client Configuration[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#updating-client-configuration)

Certain client configurations can be applied at runtime. To check if a configuration option can be applied (taken into affect by a client) at  runtime, use the config help command:

```
ceph config help debug_client
 debug_client - Debug level for client
 (str, advanced)                                                                                                                      Default: 0/5
 Can update at runtime: true

 The value takes the form 'N' or 'N/M' where N and M are values between 0 and 99.  N is the debug level to log (all values below this are included), and M is the level to gather and buffer in memory.  In the event of a crash, the most recent items <= M are dumped to the log file.
```

config help tells if a given configuration can be applied at runtime along with the defaults and a description of the configuration option.

To update a configuration option at runtime, use the config set command:

```
ceph config set client debug_client 20/20
```

Note that this changes a given configuration for all clients.

To check configured options use the config get command:

```
ceph config get client
 WHO    MASK LEVEL    OPTION                    VALUE     RO
 client      advanced debug_client              20/20
 global      advanced osd_pool_default_min_size 1
 global      advanced osd_pool_default_size     3
```

## Client Config Reference[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#client-config-reference)

- client_acl_type[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_acl_type)

  Set the ACL type. Currently, only possible value is `"posix_acl"` to enable POSIX ACL, or an empty string. This option only takes effect when the `fuse_default_permissions` is set to `false`. type `str`

- client_cache_mid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_cache_mid)

  Set client cache midpoint. The midpoint splits the least recently used lists into a hot and warm list. type `float` default `0.75`

- client_cache_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_cache_size)

  Set the number of inodes that the client keeps in the metadata cache. type `size` default `16Ki`

- client_caps_release_delay[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_caps_release_delay)

  Set the delay between capability releases in seconds. The delay sets how many   seconds a client waits to release capabilities that it no longer needs in case the capabilities are needed for another user space operation. type `secs` default `5`

- client_debug_force_sync_read[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_force_sync_read)

  If set to `true`, clients read data directly from OSDs instead of using a local page cache. type `bool` default `false`

- client_dirsize_rbytes[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_dirsize_rbytes)

  This option enables a CephFS feature that stores the recursive directory size (the bytes used by files in the directory and its descendents) in the st_size field of the stat structure. type `bool` default `true`

- client_max_inline_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_max_inline_size)

  Set the maximum size of inlined data stored in a file inode rather than in a separate data object in RADOS. This setting only applies if the `inline_data` flag is set on the MDS map. type `size` default `4Ki`

- client_metadata[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_metadata)

  Comma-delimited strings for client metadata sent to each MDS, in addition to the automatically generated version, host name, and other metadata. type `str`

- client_mount_gid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_gid)

  Set the group ID of CephFS mount. type `int` default `-1`

- client_mount_timeout[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_timeout)

  Set the timeout for CephFS mount in seconds. type `secs` default `5 minutes`

- client_mount_uid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_uid)

  Set the user ID of CephFS mount. type `int` default `-1`

- client_mountpoint[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mountpoint)

  Directory to mount on the CephFS file system. An alternative to the `-r` option of the `ceph-fuse` command. type `str` default `/`

- client_oc[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc)

  enable object caching type `bool` default `true`

- client_oc_max_dirty[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_dirty)

  Set the maximum number of dirty bytes in the object cache. type `size` default `100Mi`

- client_oc_max_dirty_age[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_dirty_age)

  Set the maximum age in seconds of dirty data in the object cache before writeback. type `float` default `5.0`

- client_oc_max_objects[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_objects)

  Set the maximum number of objects in the object cache. type `int` default `1000`

- client_oc_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_size)

  Set how many bytes of data will the client cache. type `size` default `200Mi`

- client_oc_target_dirty[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_target_dirty)

  Set the target size of dirty data. We recommend to keep this number low. type `size` default `8Mi`

- client_permissions[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_permissions)

  Check client permissions on all I/O operations. type `bool` default `true`

- client_quota_df[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_quota_df)

  Report root directory quota for the `statfs` operation. type `bool` default `true`

- client_readahead_max_bytes[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_max_bytes)

  Set the maximum number of bytes that the client reads ahead for future read operations. Overridden by the `client_readahead_max_periods` setting. type `size` default `0B`

- client_readahead_max_periods[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_max_periods)

  Set the number of file layout periods (object size * number of stripes) that the client reads ahead. Overrides the `client_readahead_max_bytes` setting. type `int` default `4`

- client_readahead_min[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_min)

  Set the minimum number bytes that the client reads ahead. type `size` default `128Ki`

- client_reconnect_stale[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_reconnect_stale)

  reconnect when the session becomes stale type `bool` default `false`

- client_snapdir[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_snapdir)

  Set the snapshot directory name. type `str` default `.snap`

- client_tick_interval[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_tick_interval)

  Set the interval in seconds between capability renewal and other upkeep. type `secs` default `1`

- client_use_random_mds[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_use_random_mds)

  Choose random MDS for each request. type `bool` default `false`

- fuse_default_permissions[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_default_permissions)

  When set to `false`, `ceph-fuse` utility checks does its own permissions checking, instead of relying on the permissions enforcement in FUSE. Set to `false` together with the `client acl type=posix_acl` option to enable POSIX ACL. type `bool` default `false`

- fuse_max_write[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_max_write)

  Set the maximum number of bytes in a single write operation. A value of 0 indicates no change; the FUSE default of 128 kbytes remains in force. type `size` default `0B`

- fuse_disable_pagecache[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_disable_pagecache)

  If set to `true`, kernel page cache is disabled for `ceph-fuse` mounts. When multiple clients read/write to a file at the same time, readers may get stale data from page cache. Due to limitations of FUSE, `ceph-fuse` can’t disable page cache dynamically. type `bool` default `false`

### Developer Options[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#developer-options)

Important

These options are internal. They are listed here only to complete the list of options.

- client_debug_getattr_caps[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_getattr_caps)

  type `bool` default `false`

- client_debug_inject_tick_delay[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_inject_tick_delay)

  type `secs` default `0`

- client_inject_fixed_oldest_tid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_inject_fixed_oldest_tid)

  type `bool` default `false`

- client_inject_release_failure[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_inject_release_failure)

  type `bool` default `false`

- client_trace[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_trace)

  file containing trace of client operations type `str`

​        

# CephFS Client Capabilities[](https://docs.ceph.com/en/latest/cephfs/client-auth/#cephfs-client-capabilities)

Use Ceph authentication capabilities to restrict your file system clients to the lowest possible level of authority needed.

Note

Path restriction and layout modification restriction are new features in the Jewel release of Ceph.

Note

Using Erasure Coded(EC) pools with CephFS is supported only with the BlueStore Backend. They cannot be used as metadata pools and overwrites must be enabled on the data pools.

## Path restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#path-restriction)

By default, clients are not restricted in what paths they are allowed to mount. Further, when clients mount a subdirectory, e.g., `/home/user`, the MDS does not by default verify that subsequent operations are ‘locked’ within that directory.

To restrict clients to only mount and work within a certain directory, use path-based MDS authentication capabilities.

### Syntax[](https://docs.ceph.com/en/latest/cephfs/client-auth/#syntax)

To grant rw access to the specified directory only, we mention the specified directory while creating key for a client using the following syntax:

```
ceph fs authorize <fs_name> client.<client_id> <path-in-cephfs> rw
```

For example, to restrict client `foo` to writing only in the `bar` directory of file system `cephfs_a`, use

```
ceph fs authorize cephfs_a client.foo / r /bar rw

results in:

client.foo
  key: *key*
  caps: [mds] allow r, allow rw path=/bar
  caps: [mon] allow r
  caps: [osd] allow rw tag cephfs data=cephfs_a
```

To completely restrict the client to the `bar` directory, omit the root directory

```
ceph fs authorize cephfs_a client.foo /bar rw
```

Note that if a client’s read access is restricted to a path, they will only be able to mount the file system when specifying a readable path in the mount command (see below).

Supplying `all` or `*` as the file system name will grant access to every file system. Note that it is usually necessary to quote `*` to protect it from the shell.

See [User Management - Add a User to a Keyring](https://docs.ceph.com/en/latest/rados/operations/user-management/#add-a-user-to-a-keyring). for additional details on user management

To restrict a client to the specified sub-directory only, we mention the specified directory while mounting using the following syntax:

```
ceph-fuse -n client.<client_id> <mount-path> -r *directory_to_be_mounted*
```

For example, to restrict client `foo` to `mnt/bar` directory, we will use:

```
ceph-fuse -n client.foo mnt -r /bar
```

### Free space reporting[](https://docs.ceph.com/en/latest/cephfs/client-auth/#free-space-reporting)

By default, when a client is mounting a sub-directory, the used space (`df`) will be calculated from the quota on that sub-directory, rather than reporting the overall amount of space used on the cluster.

If you would like the client to report the overall usage of the file system, and not just the quota usage on the sub-directory mounted, then set the following config option on the client:

```
client quota df = false
```

If quotas are not enabled, or no quota is set on the sub-directory mounted, then the overall usage of the file system will be reported irrespective of the value of this setting.

## Layout and Quota restriction (the ‘p’ flag)[](https://docs.ceph.com/en/latest/cephfs/client-auth/#layout-and-quota-restriction-the-p-flag)

To set layouts or quotas, clients require the ‘p’ flag in addition to ‘rw’. This restricts all the attributes that are set by special extended attributes with a “ceph.” prefix, as well as restricting other means of setting these fields (such as openc operations with layouts).

For example, in the following snippet client.0 can modify layouts and quotas on the file system cephfs_a, but client.1 cannot:

```
client.0
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rwp
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a

client.1
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rw
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a
```

## Snapshot restriction (the ‘s’ flag)[](https://docs.ceph.com/en/latest/cephfs/client-auth/#snapshot-restriction-the-s-flag)

To create or delete snapshots, clients require the ‘s’ flag in addition to ‘rw’. Note that when capability string also contains the ‘p’ flag, the ‘s’ flag must appear after it (all flags except ‘rw’ must be specified in alphabetical order).

For example, in the following snippet client.0 can create or delete snapshots in the `bar` directory of file system `cephfs_a`:

```
client.0
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rw, allow rws path=/bar
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a
```

## Network restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#network-restriction)

```
client.foo
  key: *key*
  caps: [mds] allow r network 10.0.0.0/8, allow rw path=/bar network 10.0.0.0/8
  caps: [mon] allow r network 10.0.0.0/8
  caps: [osd] allow rw tag cephfs data=cephfs_a network 10.0.0.0/8
```

The optional `{network/prefix}` is a standard network name and prefix length in CIDR notation (e.g., `10.3.0.0/16`).  If present, the use of this capability is restricted to clients connecting from this network.



## File system Information Restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#file-system-information-restriction)

If desired, the monitor cluster can present a limited view of the file systems available. In this case, the monitor cluster will only inform clients about file systems specified by the administrator. Other file systems will not be reported and commands affecting them will fail as if the file systems do not exist.

Consider following example. The Ceph cluster has 2 FSs:

```
$ ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
name: cephfs2, metadata pool: cephfs2_metadata, data pools: [cephfs2_data ]
```

But we authorize client `someuser` for only one FS:

```
$ ceph fs authorize cephfs client.someuser / rw
[client.someuser]
    key = AQAmthpf89M+JhAAiHDYQkMiCq3x+J0n9e8REQ==
$ cat ceph.client.someuser.keyring
[client.someuser]
    key = AQAmthpf89M+JhAAiHDYQkMiCq3x+J0n9e8REQ==
    caps mds = "allow rw fsname=cephfs"
    caps mon = "allow r fsname=cephfs"
    caps osd = "allow rw tag cephfs data=cephfs"
```

And the client can only see the FS that it has authorization for:

```
$ ceph fs ls -n client.someuser -k ceph.client.someuser.keyring
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

Standby MDS daemons will always be displayed. Note that the information about restricted MDS daemons and file systems may become available by other means, such as `ceph health detail`.

## MDS communication restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#mds-communication-restriction)

By default, user applications may communicate with any MDS, whether or not they are allowed to modify data on an associated file system (see Path restriction above). Client’s communication can be restricted to MDS daemons associated with particular file system(s) by adding MDS caps for that particular file system. Consider the following example where the Ceph cluster has 2 FSs:

```
$ ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
name: cephfs2, metadata pool: cephfs2_metadata, data pools: [cephfs2_data ]
```

Client `someuser` is authorized only for one FS:

```
$ ceph fs authorize cephfs client.someuser / rw
[client.someuser]
    key = AQBPSARfg8hCJRAAEegIxjlm7VkHuiuntm6wsA==
$ ceph auth get client.someuser > ceph.client.someuser.keyring
exported keyring for client.someuser
$ cat ceph.client.someuser.keyring
[client.someuser]
    key = AQBPSARfg8hCJRAAEegIxjlm7VkHuiuntm6wsA==
    caps mds = "allow rw fsname=cephfs"
    caps mon = "allow r"
    caps osd = "allow rw tag cephfs data=cephfs"
```

Mounting `cephfs1` with `someuser` works:

```
$ sudo ceph-fuse /mnt/cephfs1 -n client.someuser -k ceph.client.someuser.keyring --client-fs=cephfs
ceph-fuse[96634]: starting ceph client
ceph-fuse[96634]: starting fuse
$ mount | grep ceph-fuse
ceph-fuse on /mnt/cephfs1 type fuse.ceph-fuse (rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other)
```

But mounting `cephfs2` does not:

```
$ sudo ceph-fuse /mnt/cephfs2 -n client.someuser -k ceph.client.someuser.keyring --client-fs=cephfs2
ceph-fuse[96599]: starting ceph client
ceph-fuse[96599]: ceph mount failed with (1) Operation not permitted
```

## Root squash[](https://docs.ceph.com/en/latest/cephfs/client-auth/#root-squash)

The `root squash` feature is implemented as a safety measure to prevent scenarios such as accidental `sudo rm -rf /path`. You can enable `root_squash` mode in MDS caps to disallow clients with uid=0 or gid=0 to perform write access operations -- e.g., rm, rmdir, rmsnap, mkdir, mksnap. However, the mode allows the read operations of a root client unlike in other file systems.

Following is an example of enabling root_squash in a filesystem except within ‘/volumes’ directory tree in the filesystem:

```
$ ceph fs authorize a client.test_a / rw root_squash /volumes rw
$ ceph auth get client.test_a
[client.test_a]
    key = AQBZcDpfEbEUKxAADk14VflBXt71rL9D966mYA==
    caps mds = "allow rw fsname=a root_squash, allow rw fsname=a path=/volumes"
    caps mon = "allow r fsname=a"
    caps osd = "allow rw tag cephfs data=a"
```

​        

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