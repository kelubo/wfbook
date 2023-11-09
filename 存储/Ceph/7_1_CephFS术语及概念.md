# 术语

一个 Ceph 集群可以有零个或多个 CephFS 文件系统。每个 CephFS 都有一个人类可读的名称（在创建时使用 `ceph fs new` 设置）和一个整数 ID 。该 ID 称为文件系统集群 ID 或 FSCID 。

Each CephFS file system has a number of *ranks*, numbered beginning with zero. By default there is one rank per file system.  A rank may be thought of as a metadata shard.  Management of ranks is described in [Configuring multiple active MDS daemons](https://docs.ceph.com/en/latest/cephfs/multimds/) .

每个 CephFS 文件系统都有多个等级，从零开始编号。默认情况下，每个文件系统有一个 rank 。排名可以被认为是元数据碎片。配置多个活动 MDS 守护程序中介绍了等级管理。

Each CephFS `ceph-mds` daemon starts without a rank.  It may be assigned one by the cluster’s monitors. A daemon may only hold one rank at a time, and only give up a rank when the `ceph-mds` process stops.

每个 CephFS ceph-mds 守护程序启动时都没有等级。它可以由群集的 MON 分配一个。守护进程一次只能持有一个等级，并且只有在 ceph-mds 进程停止时才给予等级。

If a rank is not associated with any daemon, that rank is considered `failed`. Once a rank is assigned to a daemon, the rank is considered `up`.

如果一个等级没有与任何守护程序相关联，则认为该等级失败。一旦一个等级被分配给一个守护进程，这个等级就被认为是上升的。

每个 `ceph-mds` 守护程序都有一个名称，该名称是在首次配置守护程序时由管理员静态分配的。每个守护进程的名称通常是进程运行的主机名。

A `ceph-mds` daemon may be assigned to a specific file system by setting its `mds_join_fs` configuration option to the file system’s `name`.

通过将ceph-mds守护程序的mds_join_fs配置选项设置为文件系统的名称，可以将其分配给特定的文件系统。

When a `ceph-mds` daemon starts, it is also assigned an integer `GID`, which is unique to this current daemon’s process.  In other words, when a `ceph-mds` daemon is restarted, it runs as a new process and is assigned a *new* `GID` that is different from that of the previous process.

当一个 `ceph-mds` 守护进程启动时，它也被分配了一个整数GID，这个GID对于当前守护进程是唯一的。换句话说，当ceph-mds守护进程重新启动时，它将作为一个新进程运行，并被分配一个与前一个进程不同的新GID。