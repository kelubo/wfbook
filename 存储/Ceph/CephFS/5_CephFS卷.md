# 卷和子卷

[TOC]

## 概述

Ceph Manager 守护程序（ceph-mgr）的卷模块为 CephFS 导出提供了单一的真实数据源。The OpenStack shared file system service ([manila](https://github.com/openstack/manila)), Ceph Container Storage Interface ([CSI](https://github.com/ceph/ceph-csi)), storage administrators among others can use the common CLI provided by the ceph-mgr volumes module to manage the CephFS exports. OpenStack共享文件系统服务（马尼拉）和Ceph容器存储接口（CSI）存储管理员使用ceph-mgr卷模块提供的通用CLI来管理CephFS导出。

The ceph-mgr volumes module implements the following file system export abstractions:ceph-mgr 卷模块实现以下文件系统导出抽象：

- FS volumes, an abstraction for CephFS file systems
- FS卷，CephFS文件系统的抽象

- FS subvolumes, an abstraction for independent CephFS directory trees
- FS子卷，独立CephFS目录树的抽象
- FS subvolume groups, an abstraction for a directory level higher than FS subvolumes to effect policies (e.g., [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/)) across a set of subvolumes
- FS子卷组，一个高于FS子卷的目录级别的抽象。用于影响政策（例如，文件布局）跨一组子卷

Some possible use-cases for the export abstractions:

- FS subvolumes used as manila shares or CSI volumes
- FS subvolume groups used as manila share groups

## Requirements[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#requirements)

- Nautilus (14.2.x) or a later version of Ceph

- Cephx client user (see [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/)) with the following minimum capabilities:

  ```
  mon 'allow r'
  mgr 'allow rw'
  ```

## FS Volumes[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-volumes)

Create a volume using:

```
$ ceph fs volume create <vol_name> [<placement>]
```

This creates a CephFS file system and its data and metadata pools. It can also try to create MDSes for the filesystem using the enabled ceph-mgr orchestrator module (see [Orchestrator CLI](https://docs.ceph.com/en/latest/mgr/orchestrator/)), e.g. rook.

<vol_name> is the volume name (an arbitrary string), and

<placement> is an optional string signifying which hosts should have NFS Ganesha daemon containers running on them and, optionally, the total number of NFS Ganesha daemons the cluster (should you want to have more than one NFS Ganesha daemon running per node). For example, the following placement string means “deploy NFS Ganesha daemons on nodes host1 and host2 (one daemon per host):

> “host1,host2”

and this placement specification says to deploy two NFS Ganesha daemons each on nodes host1 and host2 (for a total of four NFS Ganesha daemons in the cluster):

> “4 host1,host2”

For more details on placement specification refer to the [Service Specification](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-service-spec), but keep in mind that specifying the placement via a YAML file is not supported.

Remove a volume using:

```
$ ceph fs volume rm <vol_name> [--yes-i-really-mean-it]
```

This removes a file system and its data and metadata pools. It also tries to remove MDSes using the enabled ceph-mgr orchestrator module.

List volumes using:

```
$ ceph fs volume ls
```

Rename a volume using:

```
$ ceph fs volume rename <vol_name> <new_vol_name> [--yes-i-really-mean-it]
```

Renaming a volume can be an expensive operation. It does the following:

- renames the orchestrator managed MDS service to match the <new_vol_name>. This involves launching a MDS service with <new_vol_name> and bringing down the MDS service with <vol_name>.
- renames the file system matching <vol_name> to <new_vol_name>
- changes the application tags on the data and metadata pools of the file system to <new_vol_name>
- renames the  metadata and data pools of the file system.

The CephX IDs authorized to <vol_name> need to be reauthorized to <new_vol_name>. Any on-going operations of the clients using these IDs may be disrupted. Mirroring is expected to be disabled on the volume.

## FS Subvolume groups[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-subvolume-groups)

Create a subvolume group using:

```
$ ceph fs subvolumegroup create <vol_name> <group_name> [--size <size_in_bytes>] [--pool_layout <data_pool_name>] [--uid <uid>] [--gid <gid>] [--mode <octal_mode>]
```

The command succeeds even if the subvolume group already exists.

When creating a subvolume group you can specify its data pool layout (see [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/)), uid, gid, file mode in octal numerals and size in bytes. The size of the subvolume group is specified by setting a quota on it (see [Quotas](https://docs.ceph.com/en/latest/cephfs/quota/)). By default, the subvolume group is created with an octal file mode ‘755’, uid ‘0’, gid ‘0’ and data pool layout of its parent directory.

Remove a subvolume group using:

```
$ ceph fs subvolumegroup rm <vol_name> <group_name> [--force]
```

The removal of a subvolume group fails if it is not empty or non-existent. ‘--force’ flag allows the non-existent subvolume group remove command to succeed.

Fetch the absolute path of a subvolume group using:

```
$ ceph fs subvolumegroup getpath <vol_name> <group_name>
```

List subvolume groups using:

```
$ ceph fs subvolumegroup ls <vol_name>
```

Note

Subvolume group snapshot feature is no longer supported in mainline CephFS (existing group snapshots can still be listed and deleted)

Fetch the metadata of a subvolume group using:

```
$ ceph fs subvolumegroup info <vol_name> <group_name>
```

The output format is json and contains fields as follows.

- atime: access time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- mtime: modification time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- ctime: change time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- uid: uid of subvolume group path
- gid: gid of subvolume group path
- mode: mode of subvolume group path
- mon_addrs: list of monitor addresses
- bytes_pcent: quota used in percentage if quota is set, else displays “undefined”
- bytes_quota: quota size in bytes if quota is set, else displays “infinite”
- bytes_used: current used size of the subvolume group in bytes
- created_at: time of creation of subvolume group in the format “YYYY-MM-DD HH:MM:SS”
- data_pool: data pool the subvolume group belongs to

Resize a subvolume group using:

```
$ ceph fs subvolumegroup resize <vol_name> <group_name> <new_size> [--no_shrink]
```

The command resizes the subvolume group quota using the size specified by ‘new_size’. The ‘--no_shrink’ flag prevents the subvolume group to shrink below the current used size of the subvolume group.

The subvolume group can be resized to an infinite size by passing ‘inf’ or ‘infinite’ as the new_size.

Remove a snapshot of a subvolume group using:

```
$ ceph fs subvolumegroup snapshot rm <vol_name> <group_name> <snap_name> [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the snapshot did not exist.

List snapshots of a subvolume group using:

```
$ ceph fs subvolumegroup snapshot ls <vol_name> <group_name>
```

## FS Subvolumes[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-subvolumes)

Create a subvolume using:

```
$ ceph fs subvolume create <vol_name> <subvol_name> [--size <size_in_bytes>] [--group_name <subvol_group_name>] [--pool_layout <data_pool_name>] [--uid <uid>] [--gid <gid>] [--mode <octal_mode>] [--namespace-isolated]
```

The command succeeds even if the subvolume already exists.

When creating a subvolume you can specify its subvolume group, data pool layout, uid, gid, file mode in octal numerals, and size in bytes. The size of the subvolume is specified by setting a quota on it (see [Quotas](https://docs.ceph.com/en/latest/cephfs/quota/)). The subvolume can be created in a separate RADOS namespace by specifying --namespace-isolated option. By default a subvolume is created within the default subvolume group, and with an octal file mode ‘755’, uid of its subvolume group, gid of its subvolume group, data pool layout of its parent directory and no size limit.

Remove a subvolume using:

```
$ ceph fs subvolume rm <vol_name> <subvol_name> [--group_name <subvol_group_name>] [--force] [--retain-snapshots]
```

The command removes the subvolume and its contents. It does this in two steps. First, it moves the subvolume to a trash folder, and then asynchronously purges its contents.

The removal of a subvolume fails if it has snapshots, or is non-existent. ‘--force’ flag allows the non-existent subvolume remove command to succeed.

A subvolume can be removed retaining existing snapshots of the subvolume using the ‘--retain-snapshots’ option. If snapshots are retained, the subvolume is considered empty for all operations not involving the retained snapshots.

Note

Snapshot retained subvolumes can be recreated using ‘ceph fs subvolume create’

Note

Retained snapshots can be used as a clone source to recreate the subvolume, or clone to a newer subvolume.

Resize a subvolume using:

```
$ ceph fs subvolume resize <vol_name> <subvol_name> <new_size> [--group_name <subvol_group_name>] [--no_shrink]
```

The command resizes the subvolume quota using the size specified by ‘new_size’. ‘--no_shrink’ flag prevents the subvolume to shrink below the current used size of the subvolume.

The subvolume can be resized to an infinite size by passing ‘inf’ or ‘infinite’ as the new_size.

Authorize cephx auth IDs, the read/read-write access to fs subvolumes:

```
$ ceph fs subvolume authorize <vol_name> <sub_name> <auth_id> [--group_name=<group_name>] [--access_level=<access_level>]
```

The ‘access_level’ takes ‘r’ or ‘rw’ as value.

Deauthorize cephx auth IDs, the read/read-write access to fs subvolumes:

```
$ ceph fs subvolume deauthorize <vol_name> <sub_name> <auth_id> [--group_name=<group_name>]
```

List cephx auth IDs authorized to access fs subvolume:

```
$ ceph fs subvolume authorized_list <vol_name> <sub_name> [--group_name=<group_name>]
```

Evict fs clients based on auth ID and subvolume mounted:

```
$ ceph fs subvolume evict <vol_name> <sub_name> <auth_id> [--group_name=<group_name>]
```

Fetch the absolute path of a subvolume using:

```
$ ceph fs subvolume getpath <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Fetch the information of a subvolume using:

```
$ ceph fs subvolume info <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

The output format is json and contains fields as follows.

- atime: access time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- mtime: modification time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- ctime: change time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- uid: uid of subvolume path
- gid: gid of subvolume path
- mode: mode of subvolume path
- mon_addrs: list of monitor addresses
- bytes_pcent: quota used in percentage if quota is set, else displays “undefined”
- bytes_quota: quota size in bytes if quota is set, else displays “infinite”
- bytes_used: current used size of the subvolume in bytes
- created_at: time of creation of subvolume in the format “YYYY-MM-DD HH:MM:SS”
- data_pool: data pool the subvolume belongs to
- path: absolute path of a subvolume
- type: subvolume type indicating whether it’s clone or subvolume
- pool_namespace: RADOS namespace of the subvolume
- features: features supported by the subvolume
- state: current state of the subvolume

If a subvolume has been removed retaining its snapshots, the output only contains fields as follows.

- type: subvolume type indicating whether it’s clone or subvolume
- features: features supported by the subvolume
- state: current state of the subvolume

The subvolume “features” are based on the internal version of the subvolume and is a list containing a subset of the following features,

- “snapshot-clone”: supports cloning using a subvolumes snapshot as the source
- “snapshot-autoprotect”: supports automatically protecting snapshots, that are active clone sources, from deletion
- “snapshot-retention”: supports removing subvolume contents, retaining any existing snapshots

The subvolume “state” is based on the current state of the subvolume and contains one of the following values.

- “complete”: subvolume is ready for all operations
- “snapshot-retained”: subvolume is removed but its snapshots are retained

List subvolumes using:

```
$ ceph fs subvolume ls <vol_name> [--group_name <subvol_group_name>]
```

Note

subvolumes that are removed but have snapshots retained, are also listed.

Set custom metadata on the subvolume as a key-value pair using:

```
$ ceph fs subvolume metadata set <vol_name> <subvol_name> <key_name> <value> [--group_name <subvol_group_name>]
```

Note

If the key_name already exists then the old value will get replaced by the new value.

Note

key_name and value should be a string of ASCII characters (as  specified in python’s string.printable). key_name is case-insensitive  and always stored in lower case.

Note

Custom metadata on a subvolume is not preserved when snapshotting the subvolume, and hence, is also not preserved when cloning the subvolume  snapshot.

Get custom metadata set on the subvolume using the metadata key:

```
$ ceph fs subvolume metadata get <vol_name> <subvol_name> <key_name> [--group_name <subvol_group_name>]
```

List custom metadata (key-value pairs) set on the subvolume using:

```
$ ceph fs subvolume metadata ls <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Remove custom metadata set on the subvolume using the metadata key:

```
$ ceph fs subvolume metadata rm <vol_name> <subvol_name> <key_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the metadata key did not exist.

Create a snapshot of a subvolume using:

```
$ ceph fs subvolume snapshot create <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

Remove a snapshot of a subvolume using:

```
$ ceph fs subvolume snapshot rm <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the snapshot did not exist.

Note

if the last snapshot within a snapshot retained subvolume is removed, the subvolume is also removed

List snapshots of a subvolume using:

```
$ ceph fs subvolume snapshot ls <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Fetch the information of a snapshot using:

```
$ ceph fs subvolume snapshot info <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

The output format is json and contains fields as follows.

- created_at: time of creation of snapshot in the format “YYYY-MM-DD HH:MM:SS:ffffff”
- data_pool: data pool the snapshot belongs to
- has_pending_clones: “yes” if snapshot clone is in progress otherwise “no”
- size: snapshot size in bytes

Set custom metadata on the snapshot as a key-value pair using:

```
$ ceph fs subvolume snapshot metadata set <vol_name> <subvol_name> <snap_name> <key_name> <value> [--group_name <subvol_group_name>]
```

Note

If the key_name already exists then the old value will get replaced by the new value.

Note

The key_name and value should be a string of ASCII characters (as  specified in python’s string.printable). The key_name is  case-insensitive and always stored in lower case.

Note

Custom metadata on a snapshots is not preserved when snapshotting the subvolume, and hence, is also not preserved when cloning the subvolume  snapshot.

Get custom metadata set on the snapshot using the metadata key:

```
$ ceph fs subvolume snapshot metadata get <vol_name> <subvol_name> <snap_name> <key_name> [--group_name <subvol_group_name>]
```

List custom metadata (key-value pairs) set on the snapshot using:

```
$ ceph fs subvolume snapshot metadata ls <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

Remove custom metadata set on the snapshot using the metadata key:

```
$ ceph fs subvolume snapshot metadata rm <vol_name> <subvol_name> <snap_name> <key_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the metadata key did not exist.

## Cloning Snapshots[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#cloning-snapshots)

Subvolumes can be created by cloning subvolume snapshots. Cloning is an asynchronous operation involving copying data from a snapshot to a subvolume. Due to this bulk copy nature, cloning is currently inefficient for very huge data sets.

Note

Removing a snapshot (source subvolume) would fail if there are pending or in progress clone operations.

Protecting snapshots prior to cloning was a pre-requisite in the Nautilus release, and the commands to protect/unprotect snapshots were introduced for this purpose. This pre-requisite, and hence the commands to protect/unprotect, is being deprecated in mainline CephFS, and may be removed from a future release.

- The commands being deprecated are:

  $ ceph fs subvolume  snapshot protect <vol_name> <subvol_name> <snap_name>  [--group_name <subvol_group_name>] $ ceph fs subvolume snapshot unprotect <vol_name>  <subvol_name> <snap_name> [--group_name  <subvol_group_name>]

Note

Using the above commands would not result in an error, but they serve no useful function.

Note

Use subvolume info command to fetch subvolume metadata regarding  supported “features” to help decide if protect/unprotect of snapshots is required, based on the “snapshot-autoprotect” feature availability.

To initiate a clone operation use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name>
```

If a snapshot (source subvolume) is a part of non-default group, the group name needs to be specified as per:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --group_name <subvol_group_name>
```

Cloned subvolumes can be a part of a different group than the source  snapshot (by default, cloned subvolumes are created in default group).  To clone to a particular group use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --target_group_name <subvol_group_name>
```

Similar to specifying a pool layout when creating a subvolume, pool  layout can be specified when creating a cloned subvolume. To create a  cloned subvolume with a specific pool layout use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --pool_layout <pool_layout>
```

Configure maximum number of concurrent clones. The default is set to 4:

```
$ ceph config set mgr mgr/volumes/max_concurrent_clones <value>
```

To check the status of a clone operation use:

```
$ ceph fs clone status <vol_name> <clone_name> [--group_name <group_name>]
```

A clone can be in one of the following states:

1. pending     : Clone operation has not started
2. in-progress : Clone operation is in progress
3. complete    : Clone operation has successfully finished
4. failed      : Clone operation has failed
5. canceled    : Clone operation is cancelled by user

The reason for a clone failure is shown as below:

1. errno     : error number
2. error_msg : failure error string

Sample output of an in-progress clone operation:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "in-progress",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
    }
  }
}
```

Note

The failure section will be shown only if the clone is in failed or cancelled state

Sample output of a failed clone operation:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "failed",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
      "size": "104857600"
    },
    "failure": {
      "errno": "122",
      "errstr": "Disk quota exceeded"
    }
  }
}
```

(NOTE: since subvol1 is in default group, source section in clone status does not include group name)

Note

Cloned subvolumes are accessible only after the clone operation has successfully completed.

For a successful clone operation, clone status would look like so:

```
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "complete"
  }
}
```

or failed state when clone is unsuccessful.

On failure of a clone operation, the partial clone needs to be deleted and the clone operation needs to be retriggered. To delete a partial clone use:

```
$ ceph fs subvolume rm <vol_name> <clone_name> [--group_name <group_name>] --force
```

Note

Cloning only synchronizes directories, regular files and symbolic links. Also, inode timestamps (access and modification times) are synchronized up to seconds granularity.

An in-progress or a pending clone operation can be canceled. To cancel a clone operation use the clone cancel command:

```
$ ceph fs clone cancel <vol_name> <clone_name> [--group_name <group_name>]
```

On successful cancellation, the cloned subvolume is moved to canceled state:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone cancel cephfs clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "canceled",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
    }
  }
}
```

Note

The canceled cloned can be deleted by using --force option in fs subvolume rm command.



## Pinning Subvolumes and Subvolume Groups[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#pinning-subvolumes-and-subvolume-groups)

Subvolumes and subvolume groups can be automatically pinned to ranks according to policies. This can help distribute load across MDS ranks in predictable and stable ways.  Review [Manually pinning directory trees to a particular rank](https://docs.ceph.com/en/latest/cephfs/multimds/#cephfs-pinning) and [Setting subtree partitioning policies](https://docs.ceph.com/en/latest/cephfs/multimds/#cephfs-ephemeral-pinning) for details on how pinning works.

Pinning is configured by:

```
$ ceph fs subvolumegroup pin <vol_name> <group_name> <pin_type> <pin_setting>
```

or for subvolumes:

```
$ ceph fs subvolume pin <vol_name> <group_name> <pin_type> <pin_setting>
```

Typically you will want to set subvolume group pins. The `pin_type` may be one of `export`, `distributed`, or `random`. The `pin_setting` corresponds to the extended attributed “value” as in the pinning documentation referenced above.

So, for example, setting a distributed pinning strategy on a subvolume group:

```
$ ceph fs subvolumegroup pin cephfilesystem-a csi distributed 1
```

Will enable distributed subtree partitioning policy for the “csi” subvolume group.  This will cause every subvolume within the group to be automatically pinned to one of the available ranks on the file system.