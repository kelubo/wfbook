# Terminology[](https://docs.ceph.com/en/latest/cephfs/standby/#terminology)

A Ceph cluster may have zero or more CephFS *file systems*.  Each CephFS has a human readable name (set at creation time with `fs new`) and an integer ID.  The ID is called the file system cluster ID, or *FSCID*.

Each CephFS file system has a number of *ranks*, numbered beginning with zero. By default there is one rank per file system.  A rank may be thought of as a metadata shard.  Management of ranks is described in [Configuring multiple active MDS daemons](https://docs.ceph.com/en/latest/cephfs/multimds/) .

Each CephFS `ceph-mds` daemon starts without a rank.  It may be assigned one by the cluster’s monitors. A daemon may only hold one rank at a time, and only give up a rank when the `ceph-mds` process stops.

If a rank is not associated with any daemon, that rank is considered `failed`. Once a rank is assigned to a daemon, the rank is considered `up`.

Each `ceph-mds` daemon has a *name* that is assigned statically by the administrator when the daemon is first configured.  Each daemon’s *name* is typically that of the hostname where the process runs.

A `ceph-mds` daemon may be assigned to a specific file system by setting its `mds_join_fs` configuration option to the file system’s `name`.

When a `ceph-mds` daemon starts, it is also assigned an integer `GID`, which is unique to this current daemon’s process.  In other words, when a `ceph-mds` daemon is restarted, it runs as a new process and is assigned a *new* `GID` that is different from that of the previous process.