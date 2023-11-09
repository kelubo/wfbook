# CephFS 客户端

[TOC]

## 更新客户端配置

某些客户端配置可以在运行时应用。要检查配置选项是否可以在运行时应用（由客户端生效），请使用 `config help` 命令：

```bash
ceph config help debug_client
 debug_client - Debug level for client
 (str, advanced)                                                                                                                      Default: 0/5
 Can update at runtime: true

 The value takes the form 'N' or 'N/M' where N and M are values between 0 and 99.  N is the debug level to log (all values below this are included), and M is the level to gather and buffer in memory.  In the event of a crash, the most recent items <= M are dumped to the log file.
```

`config help` 说明给定的配置是否可以在运行时应用，沿着默认值和配置选项的说明。tells if a given configuration can be applied at runtime along with the defaults and a description of the configuration option.

要在运行时更新配置选项，请使用 `config set` 命令：

```bash
ceph config set client debug_client 20/20
```

请注意，这会更改所有客户端的给定配置。

要检查配置的选项，请使用 `config get` 命令：

```bash
ceph config get client
 WHO    MASK LEVEL    OPTION                    VALUE     RO
 client      advanced debug_client              20/20
 global      advanced osd_pool_default_min_size 1
 global      advanced osd_pool_default_size     3
```

## 客户端配置参考

- client_acl_type

  Set the ACL type. Currently, only possible value is `"posix_acl"` to enable POSIX ACL, or an empty string. This option only takes effect when the `fuse_default_permissions` is set to `false`. type `str`

- client_cache_mid

  Set client cache midpoint. The midpoint splits the least recently used lists into a hot and warm list. type `float` default `0.75`

- client_cache_size

  Set the number of inodes that the client keeps in the metadata cache. type `size` default `16Ki`

- client_caps_release_delay

  Set the delay between capability releases in seconds. The delay sets how many   seconds a client waits to release capabilities that it no longer needs in case the capabilities are needed for another user space operation. type `secs` default `5`

- client_debug_force_sync_read

  If set to `true`, clients read data directly from OSDs instead of using a local page cache. type `bool` default `false`

- client_dirsize_rbytes

  This option enables a CephFS feature that stores the recursive directory size (the bytes used by files in the directory and its descendents) in the st_size field of the stat structure. type `bool` default `true`

- client_max_inline_size

  Set the maximum size of inlined data stored in a file inode rather than in a separate data object in RADOS. This setting only applies if the `inline_data` flag is set on the MDS map. type `size` default `4Ki`

- client_metadata

  Comma-delimited strings for client metadata sent to each MDS, in addition to the automatically generated version, host name, and other metadata. type `str`

- client_mount_gid

  Set the group ID of CephFS mount. type `int` default `-1`

- client_mount_timeout

  Set the timeout for CephFS mount in seconds. type `secs` default `5 minutes`

- client_mount_uid

  Set the user ID of CephFS mount. type `int` default `-1`

- client_mountpoint

  Directory to mount on the CephFS file system. An alternative to the `-r` option of the `ceph-fuse` command. type `str` default `/`

- client_oc

  enable object caching type `bool` default `true`

- client_oc_max_dirty

  Set the maximum number of dirty bytes in the object cache. type `size` default `100Mi`

- client_oc_max_dirty_age

  Set the maximum age in seconds of dirty data in the object cache before writeback. type `float` default `5.0`

- client_oc_max_objects

  Set the maximum number of objects in the object cache. type `int` default `1000`

- client_oc_size

  Set how many bytes of data will the client cache. type `size` default `200Mi`

- client_oc_target_dirty

  Set the target size of dirty data. We recommend to keep this number low. type `size` default `8Mi`

- client_permissions

  Check client permissions on all I/O operations. type `bool` default `true`

- client_quota_df

  Report root directory quota for the `statfs` operation. type `bool` default `true`

- client_readahead_max_bytes

  Set the maximum number of bytes that the client reads ahead for future read operations. Overridden by the `client_readahead_max_periods` setting. type `size` default `0B`

- client_readahead_max_periods

  Set the number of file layout periods (object size * number of stripes) that the client reads ahead. Overrides the `client_readahead_max_bytes` setting. type `int` default `4`

- client_readahead_min

  Set the minimum number bytes that the client reads ahead. type `size` default `128Ki`

- client_reconnect_stale

  reconnect when the session becomes stale type `bool` default `false`

- client_snapdir

  Set the snapshot directory name. type `str` default `.snap`

- client_tick_interval

  Set the interval in seconds between capability renewal and other upkeep. type `secs` default `1`

- client_use_random_mds

  Choose random MDS for each request. type `bool` default `false`

- fuse_default_permissions

  When set to `false`, `ceph-fuse` utility checks does its own permissions checking, instead of relying on the permissions enforcement in FUSE. Set to `false` together with the `client acl type=posix_acl` option to enable POSIX ACL. type `bool` default `false`

- fuse_max_write

  Set the maximum number of bytes in a single write operation. A value of 0 indicates no change; the FUSE default of 128 kbytes remains in force. type `size` default `0B`

- fuse_disable_pagecache

  If set to `true`, kernel page cache is disabled for `ceph-fuse` mounts. When multiple clients read/write to a file at the same time, readers may get stale data from page cache. Due to limitations of FUSE, `ceph-fuse` can’t disable page cache dynamically. type `bool` default `false`

### 开发者选项

> Important
>
> 这些选项是内部的。这里列出这些选项只是为了完成选项列表。

- client_debug_getattr_caps

  type `bool` default `false`

- client_debug_inject_tick_delay

  type `secs` default `0`

- client_inject_fixed_oldest_tid

  type `bool` default `false`

- client_inject_release_failure

  type `bool` default `false`

- client_trace

  file containing trace of client operations type `str`

## 客户端认证

使用 Ceph 身份验证功能将您的文件系统客户端限制为所需的最低权限级别。

> Note
>
> 路径限制和布局修改限制是 Ceph 的 Jewel 版本中的新功能。
>
> 只有 BlueStore 后端支持将擦除编码（EC）池与 CephFS 配合使用。它们不能用作元数据池，并且必须在数据池上启用覆盖。

### 路径限制

默认情况下，clients are not restricted in what paths they are allowed to mount. 客户端不受允许装载的路径限制。此外，当客户端挂载子目录（例如 `/home/user` ）时，MDS 默认情况下不会验证后续操作是否“锁定”在该目录中。

要限制客户端只能在某个目录中挂载和工作，请使用基于路径的 MDS 身份验证功能。

请注意，此限制只影响文件系统层次结构—— MDS 管理的元数据树。客户端仍然可以直接访问 RADOS 中的底层文件数据。要完全隔离客户端，还必须在其自己的 RADOS 命名空间中隔离不受信任的客户端。可以使用文件布局将客户端的文件系统子树放置在特定的命名空间中，然后使用 OSD 功能限制其 RADOS 对该命名空间的访问。

#### 语法

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

#### 可用空间报告

By default, when a client is mounting a sub-directory, the used space (`df`) will be calculated from the quota on that sub-directory, rather than reporting the overall amount of space used on the cluster.

If you would like the client to report the overall usage of the file system, and not just the quota usage on the sub-directory mounted, then set the following config option on the client:

```
client quota df = false
```

If quotas are not enabled, or no quota is set on the sub-directory mounted, then the overall usage of the file system will be reported irrespective of the value of this setting.

### Layout and Quota restriction (the ‘p’ flag)

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

### Snapshot restriction (the ‘s’ flag)

To create or delete snapshots, clients require the ‘s’ flag in addition to ‘rw’. Note that when capability string also contains the ‘p’ flag, the ‘s’ flag must appear after it (all flags except ‘rw’ must be specified in alphabetical order).

For example, in the following snippet client.0 can create or delete snapshots in the `bar` directory of file system `cephfs_a`:

```
client.0
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rw, allow rws path=/bar
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a
```

### 网络约束

```
client.foo
  key: *key*
  caps: [mds] allow r network 10.0.0.0/8, allow rw path=/bar network 10.0.0.0/8
  caps: [mon] allow r network 10.0.0.0/8
  caps: [osd] allow rw tag cephfs data=cephfs_a network 10.0.0.0/8
```

The optional `{network/prefix}` is a standard network name and prefix length in CIDR notation (e.g., `10.3.0.0/16`).  If present, the use of this capability is restricted to clients connecting from this network.

### 文件系统信息限制

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

### MDS通信限制

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

### Root squash

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

### Updating Capabilities using `fs authorize`

After Ceph’s Reef version, `fs authorize` can not only be used to create a new client with caps for a CephFS but it can also be used to add new caps (for a another CephFS or another path in same FS) to an already existing client.

Let’s say we run following and create a new client:

```
$ ceph fs authorize a client.x / rw
[client.x]
    key = AQAOtSVk9WWtIhAAJ3gSpsjwfIQ0gQ6vfSx/0w==
$ ceph auth get client.x
[client.x]
        key = AQAOtSVk9WWtIhAAJ3gSpsjwfIQ0gQ6vfSx/0w==
        caps mds = "allow rw fsname=a"
        caps mon = "allow r fsname=a"
        caps osd = "allow rw tag cephfs data=a"
```

Previously, running `fs authorize a client.x / rw` a second time used to print an error message. But after Reef, it instead prints message that there’s not update:

```
$ ./bin/ceph fs authorize a client.x / rw
no update for caps of client.x
```

#### Adding New Caps Using `fs authorize`

Users can now add caps for another path in same CephFS:

```
$ ceph fs authorize a client.x /dir1 rw
updated caps for client.x
$ ceph auth get client.x
[client.x]
        key = AQAOtSVk9WWtIhAAJ3gSpsjwfIQ0gQ6vfSx/0w==
        caps mds = "allow r fsname=a, allow rw fsname=a path=some/dir"
        caps mon = "allow r fsname=a"
        caps osd = "allow rw tag cephfs data=a"
```

And even add caps for another CephFS on Ceph cluster:

```
$ ceph fs authorize b client.x / rw
updated caps for client.x
$ ceph auth get client.x
[client.x]
        key = AQD6tiVk0uJdARAABMaQuLRotxTi3Qdj47FkBA==
        caps mds = "allow rw fsname=a, allow rw fsname=b"
        caps mon = "allow r fsname=a, allow r fsname=b"
        caps osd = "allow rw tag cephfs data=a, allow rw tag cephfs data=b"
```

#### Changing rw permissions in caps

It’s not possible to modify caps by running `fs authorize` except for the case when read/write permissions have to be changed. This so because the `fs authorize` becomes ambiguous. For example, user runs `fs authorize cephfs1 /dir1 client.x rw` to create a client and then runs `fs authorize cephfs1 /dir2 client.x rw` (notice `/dir1` is changed to `/dir2`). Running second command can be interpreted as changing `/dir1` to `/dir2` in current cap or can also be interpreted as authorizing the client with a new cap for path `/dir2`. As seen in previous sections, second interpretation is chosen and therefore it’s impossible to update a part of capability granted except rw permissions. Following is how read/write permissions for `client.x` (that was created above) can be changed:

```
$ ceph fs authorize a client.x / r
[client.x]
    key = AQBBKjBkIFhBDBAA6q5PmDDWaZtYjd+jafeVUQ==
$ ceph auth get client.x
[client.x]
        key = AQBBKjBkIFhBDBAA6q5PmDDWaZtYjd+jafeVUQ==
        caps mds = "allow r fsname=a"
        caps mon = "allow r fsname=a"
        caps osd = "allow r tag cephfs data=a"
```

#### `fs authorize` never deducts any part of caps

It’s not possible to remove caps issued to a client by running `fs authorize` again. For example, if a client cap has `root_squash` applied on a certain CephFS, running `fs authorize` again for the same CephFS but without `root_squash` will not lead to any update, the client caps will remain unchanged:

```
$ ceph fs authorize a client.x / rw root_squash
[client.x]
        key = AQD61CVkcA1QCRAAd0XYqPbHvcc+lpUAuc6Vcw==
$ ceph auth get client.x
[client.x]
        key = AQD61CVkcA1QCRAAd0XYqPbHvcc+lpUAuc6Vcw==
        caps mds = "allow rw fsname=a root_squash"
        caps mon = "allow r fsname=a"
        caps osd = "allow rw tag cephfs data=a"
$ ceph fs authorize a client.x / rw
[client.x]
        key = AQD61CVkcA1QCRAAd0XYqPbHvcc+lpUAuc6Vcw==
no update was performed for caps of client.x. caps of client.x remains unchanged.
```

And if a client already has a caps for FS name `a` and path `dir1`, running `fs authorize` again for FS name `a` but path `dir2`, instead of modifying the caps client already holds, a new cap for `dir2` will be granted:

```
$ ceph fs authorize a client.x /dir1 rw
$ ceph auth get client.x
[client.x]
        key = AQC1tyVknMt+JxAAp0pVnbZGbSr/nJrmkMNKqA==
        caps mds = "allow rw fsname=a path=/dir1"
        caps mon = "allow r fsname=a"
        caps osd = "allow rw tag cephfs data=a"
$ ceph fs authorize a client.x /dir2 rw
updated caps for client.x
$ ceph auth get client.x
[client.x]
        key = AQC1tyVknMt+JxAAp0pVnbZGbSr/nJrmkMNKqA==
        caps mds = "allow rw fsname=a path=dir1, allow rw fsname=a path=dir2"
        caps mon = "allow r fsname=a"
        caps osd = "allow rw tag cephfs data=a"
```