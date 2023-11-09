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

# MDS States[](https://docs.ceph.com/en/latest/cephfs/mds-states/#mds-states)

The Metadata Server (MDS) goes through several states during normal operation in CephFS. For example, some states indicate that the MDS is recovering from a failover by a previous instance of the MDS. Here we’ll document all of these states and include a state diagram to visualize the transitions.

## State Descriptions[](https://docs.ceph.com/en/latest/cephfs/mds-states/#state-descriptions)

### Common states[](https://docs.ceph.com/en/latest/cephfs/mds-states/#common-states)

```
up:active
```

This is the normal operating state of the MDS. It indicates that the MDS and its rank in the file system is available.

```
up:standby
```

The MDS is available to takeover for a failed rank (see also [Terminology](https://docs.ceph.com/en/latest/cephfs/standby/#mds-standby)). The monitor will automatically assign an MDS in this state to a failed rank once available.

```
up:standby_replay
```

The MDS is following the journal of another `up:active` MDS. Should the active MDS fail, having a standby MDS in replay mode is desirable as the MDS is replaying the live journal and will more quickly takeover. A downside to having standby replay MDSs is that they are not available to takeover for any other MDS that fails, only the MDS they follow.

### Less common or transitory states[](https://docs.ceph.com/en/latest/cephfs/mds-states/#less-common-or-transitory-states)

```
up:boot
```

This state is broadcast to the Ceph monitors during startup. This state is never visible as the Monitor immediately assign the MDS to an available rank or commands the MDS to operate as a standby. The state is documented here for completeness.

```
up:creating
```

The MDS is creating a new rank (perhaps rank 0) by constructing some per-rank metadata (like the journal) and entering the MDS cluster.

```
up:starting
```

The MDS is restarting a stopped rank. It opens associated per-rank metadata and enters the MDS cluster.

```
up:stopping
```

When a rank is stopped, the monitors command an active MDS to enter the `up:stopping` state. In this state, the MDS accepts no new client connections, migrates all subtrees to other ranks in the file system, flush its metadata journal, and, if the last rank (0), evict all clients and shutdown (see also [CephFS Administrative commands](https://docs.ceph.com/en/latest/cephfs/administration/#cephfs-administration)).

```
up:replay
```

The MDS taking over a failed rank. This state represents that the MDS is recovering its journal and other metadata.

```
up:resolve
```

The MDS enters this state from `up:replay` if the Ceph file system has multiple ranks (including this one), i.e. it’s not a single active MDS cluster. The MDS is resolving any uncommitted inter-MDS operations. All ranks in the file system must be in this state or later for progress to be made, i.e. no rank can be failed/damaged or `up:replay`.

```
up:reconnect
```

An MDS enters this state from `up:replay` or `up:resolve`. This state is to solicit reconnections from clients. Any client which had a session with this rank must reconnect during this time, configurable via `mds_reconnect_timeout`.

```
up:rejoin
```

The MDS enters this state from `up:reconnect`. In this state, the MDS is rejoining the MDS cluster cache. In particular, all inter-MDS locks on metadata are reestablished.

If there are no known client requests to be replayed, the MDS directly becomes `up:active` from this state.

```
up:clientreplay
```

The MDS may enter this state from `up:rejoin`. The MDS is replaying any client requests which were replied to but not yet durable (not journaled). Clients resend these requests during `up:reconnect` and the requests are replayed once again. The MDS enters `up:active` after completing replay.

### Failed states[](https://docs.ceph.com/en/latest/cephfs/mds-states/#failed-states)

```
down:failed
```

No MDS actually holds this state. Instead, it is applied to the rank in the file system. For example:

```
$ ceph fs dump
...
max_mds 1
in      0
up      {}
failed  0
...
```

Rank 0 is part of the failed set and is pending to be taken over by a standby MDS. If this state persists, it indicates no suitable MDS daemons found to be assigned to this rank. This may be caused by not enough standby daemons, or all standby daemons have incompatible compat (see also [Upgrading the MDS Cluster](https://docs.ceph.com/en/latest/cephfs/upgrading/#upgrade-mds-cluster)).

```
down:damaged
```

No MDS actually holds this state. Instead, it is applied to the rank in the file system. For example:

```
$ ceph fs dump
...
max_mds 1
in      0
up      {}
failed
damaged 0
...
```

Rank 0 has become damaged (see also [Disaster recovery](https://docs.ceph.com/en/latest/cephfs/disaster-recovery/#cephfs-disaster-recovery)) and placed in the `damaged` set. An MDS which was running as rank 0 found metadata damage that could not be automatically recovered. Operator intervention is required.

```
down:stopped
```

No MDS actually holds this state. Instead, it is applied to the rank in the file system. For example:

```
$ ceph fs dump
...
max_mds 1
in      0
up      {}
failed
damaged
stopped 1
...
```

The rank has been stopped by reducing `max_mds` (see also [Configuring multiple active MDS daemons](https://docs.ceph.com/en/latest/cephfs/multimds/#cephfs-multimds)).

## State Diagram[](https://docs.ceph.com/en/latest/cephfs/mds-states/#state-diagram)

This state diagram shows the possible state transitions for the MDS/rank. The legend is as follows:

### Color[](https://docs.ceph.com/en/latest/cephfs/mds-states/#color)

- Green: MDS is active.
- Orange: MDS is in transient state trying to become active.
- Red: MDS is indicating a state that causes the rank to be marked failed.
- Purple: MDS and rank is stopping.
- Black: MDS is indicating a state that causes the rank to be marked damaged.

### Shape[](https://docs.ceph.com/en/latest/cephfs/mds-states/#shape)

- Circle: an MDS holds this state.
- Hexagon: no MDS holds this state (it is applied to the rank).

### Lines[](https://docs.ceph.com/en/latest/cephfs/mds-states/#lines)

- A double-lined shape indicates the rank is “in”.

![](../../Image/c/ceph_state.png)

Brought to you by the Ceph Foundation

The Ceph Documentation is a community resource funded and hosted by the non-profit [Ceph Foundation](https://ceph.io/en/foundation/). If you would like to support this and our other efforts, please consider [joining now](https://ceph.io/en/foundation/join/).



# Differences from POSIX[](https://docs.ceph.com/en/latest/cephfs/posix/#differences-from-posix)

CephFS aims to adhere to POSIX semantics wherever possible.  For example, in contrast to many other common network file systems like NFS, CephFS maintains strong cache coherency across clients.  The goal is for processes communicating via the file system to behave the same when they are on different hosts as when they are on the same host.

However, there are a few places where CephFS diverges from strict POSIX semantics for various reasons:

- If a client is writing to a file and fails, its writes are not necessarily atomic. That is, the client may call write(2) on a file opened with O_SYNC with an 8 MB buffer and then crash and the write may be only partially applied.  (Almost all file systems, even local file systems, have this behavior.)
- In shared simultaneous writer situations, a write that crosses object boundaries is not necessarily atomic. This means that you could have writer A write “aa|aa” and writer B write “bb|bb” simultaneously (where | is the object boundary), and end up with “aa|bb” rather than the proper “aa|aa” or “bb|bb”.
- Sparse files propagate incorrectly to the stat(2) st_blocks field. Because CephFS does not explicitly track which parts of a file are allocated/written, the st_blocks field is always populated by the file size divided by the block size.  This will cause tools like du(1) to overestimate consumed space.  (The recursive size field, maintained by CephFS, also includes file “holes” in its count.)
- When a file is mapped into memory via mmap(2) on multiple hosts, writes are not coherently propagated to other clients’ caches.  That is, if a page is cached on host A, and then updated on host B, host A’s page is not coherently invalidated.  (Shared writable mmap appears to be quite rare--we have yet to hear any complaints about this behavior, and implementing cache coherency properly is complex.)
- CephFS clients present a hidden `.snap` directory that is used to access, create, delete, and rename snapshots.  Although the virtual directory is excluded from readdir(2), any process that tries to create a file or directory with the same name will get an error code.  The name of this hidden directory can be changed at mount time with `-o snapdirname=.somethingelse` (Linux) or the config option `client_snapdir` (libcephfs, ceph-fuse).
- CephFS does not currently maintain the `atime` field. Most applications do not care, though this impacts some backup and data tiering applications that can move unused data to a secondary storage system. You may be able to workaround this for some use cases, as CephFS does support setting `atime` via the `setattr` operation.

## Perspective[](https://docs.ceph.com/en/latest/cephfs/posix/#perspective)

People talk a lot about “POSIX compliance,” but in reality most file system implementations do not strictly adhere to the spec, including local Linux file systems like ext4 and XFS.  For example, for performance reasons, the atomicity requirements for reads are relaxed: processing reading from a file that is also being written may see torn results.

Similarly, NFS has extremely weak consistency semantics when multiple clients are interacting with the same files or directories, opting instead for “close-to-open”.  In the world of network attached storage, where most environments use NFS, whether or not the server’s file system is “fully POSIX” may not be relevant, and whether client applications notice depends on whether data is being shared between clients or not.  NFS may also “tear” the results of concurrent writers as client data may not even be flushed to the server until the file is closed (and more generally writes will be significantly more time-shifted than CephFS, leading to less predictable results).

Regardless, these are all similar enough to POSIX, and applications still work most of the time. Many other storage systems (e.g., HDFS) claim to be “POSIX-like” but diverge significantly from the standard by dropping support for things like in-place file modifications, truncate, or directory renames.

## Bottom line[](https://docs.ceph.com/en/latest/cephfs/posix/#bottom-line)

CephFS relaxes more than local Linux kernel file systems (for example, writes spanning object boundaries may be torn).  It relaxes strictly less than NFS when it comes to multiclient consistency, and generally less than NFS when it comes to write atomicity.

In other words, when it comes to POSIX,

```
HDFS < NFS < CephFS < {XFS, ext4}
```

## fsync() and error reporting[](https://docs.ceph.com/en/latest/cephfs/posix/#fsync-and-error-reporting)

POSIX is somewhat vague about the state of an inode after fsync reports an error. In general, CephFS uses the standard error-reporting mechanisms in the client’s kernel, and therefore follows the same conventions as other file systems.

In modern Linux kernels (v4.17 or later), writeback errors are reported once to every file description that is open at the time of the error. In addition, unreported errors that occurred before the file description was opened will also be returned on fsync.

See [PostgreSQL’s summary of fsync() error reporting across operating systems](https://wiki.postgresql.org/wiki/Fsync_Errors) and [Matthew Wilcox’s presentation on Linux IO error handling](https://www.youtube.com/watch?v=74c19hwY2oE) for more information.



# MDS Journaling[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#mds-journaling)

## CephFS Metadata Pool[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#cephfs-metadata-pool)

CephFS uses a separate (metadata) pool for managing file metadata (inodes and dentries) in a Ceph File System. The metadata pool has all the information about files in a Ceph File System including the File System hierarchy. Additionally, CephFS maintains meta information related to other entities in a file system such as file system journals, open file table, session map, etc.

This document describes how Ceph Metadata Servers use and rely on journaling.

## CephFS MDS Journaling[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#cephfs-mds-journaling)

CephFS metadata servers stream a journal of metadata events into RADOS in the metadata pool prior to executing a file system operation. Active MDS daemon(s) manage metadata for files and directories in CephFS.

CephFS uses journaling for couple of reasons:

1. Consistency: On an MDS failover, the journal events can be replayed to reach a consistent file system state. Also, metadata operations that require multiple updates to the backing store need to be journaled for crash consistency (along with other consistency mechanisms such as locking, etc..).
2. Performance: Journal updates are (mostly) sequential, hence updates to journals are fast. Furthermore, updates can be batched into single write, thereby saving disk seek time involved in updates to different parts of a file. Having a large journal also helps a standby MDS to warm its cache which helps indirectly during MDS failover.

Each active metadata server maintains its own journal in the metadata pool. Journals are striped over multiple objects. Journal entries which are not required (deemed as old) are trimmed by the metadata server.

## Journal Events[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#journal-events)

Apart from journaling file system metadata updates, CephFS journals various other events such as client session info and directory import/export state to name a few. These events are used by the metadata sever to reestablish correct state as required, e.g., Ceph MDS tries to reconnect clients on restart when journal events get replayed and a specific event type in the journal specifies that a client entity type has a session with the MDS before it was restarted.

To examine the list of such events recorded in the journal, CephFS provides a command line utility cephfs-journal-tool which can be used as follows:

```
cephfs-journal-tool --rank=<fs>:<rank> event get list
```

cephfs-journal-tool is also used to discover and repair a damaged Ceph File System. (See [cephfs-journal-tool](https://docs.ceph.com/en/latest/cephfs/cephfs-journal-tool/) for more details)

## Journal Event Types[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#journal-event-types)

Following are various event types that are journaled by the MDS.

1. EVENT_COMMITTED: Mark a request (id) as committed.
2. EVENT_EXPORT: Maps directories to an MDS rank.
3. EVENT_FRAGMENT: Tracks various stages of directory fragmentation (split/merge).
4. EVENT_IMPORTSTART: Logged when an MDS rank starts importing directory fragments.
5. EVENT_IMPORTFINISH: Logged when an MDS rank finishes importing directory fragments.
6. EVENT_NOOP: No operation event type for skipping over a journal region.
7. EVENT_OPEN: Tracks which inodes have open file handles.
8. EVENT_RESETJOURNAL: Used to mark a journal as reset post truncation.
9. EVENT_SESSION: Tracks open client sessions.
10. EVENT_SLAVEUPDATE: Logs various stages of an operation that has been forwarded to a (slave) mds.
11. EVENT_SUBTREEMAP: Map of directory inodes to directory contents (subtree partition).
12. EVENT_TABLECLIENT: Log transition states of MDSs view of client tables (snap/anchor).
13. EVENT_TABLESERVER: Log transition states of MDSs view of server tables (snap/anchor).
14. EVENT_UPDATE: Log file operations on an inode.
15. EVENT_SEGMENT: Log a new journal segment boundary.
16. EVENT_LID: Mark the beginning of a journal without a logical subtree map.

## Journal Segments[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#journal-segments)

The MDS journal is composed of logical segments, called LogSegments in the code. These segments are used to collect metadata updates by multiple events into one logical unit for the purposes of trimming. Whenever the journal tries to commit metadata operations (e.g. flush a file create out as an omap update to a dirfrag object), it does so in a replayable batch of updates from the LogSegment. The updates must be replayable in case the MDS fails during the series of updates to various metadata objects. The reason the updates are performed in batch is to group updates to the same metadata object (a dirfrag) where multiple omap entries are probably updated in the same time period.

Once a segment is trimmed, it is considered “expired”. An expired segment is eligible for deletion by the journaler as all of its updates are flushed to the backing RADOS objects. This is done by updating the “expire position” of the journaler to advance past the end of the expired segment. Some expired segments may be kept in the journal to improve cache locality when the MDS restarts.

For most of CephFS’s history (up to 2023), the journal segments were delineated by subtree maps, the `ESubtreeMap` event. The major reason for this is that journal recovery must start with a copy of the subtree map before replaying any other events.

Now, log segments can be delineated by events which are a `SegmentBoundary`. These include, `ESubtreeMap`, `EResetJournal`, `ESegment` (2023), or `ELid` (2023).  For `ESegment`, this light-weight segment boundary allows the MDS to journal the subtree map less frequently while also keeping the journal segments small to keep trimming events short.  In order to maintain the constraint that the first event journal replay sees is the `ESubtreeMap`, those segments beginning with that event are considered “major segments” and a new constraint was added to the deletion of expired segments: the first segment of the journal must always be a major segment.

The `ELid` event exists to mark the MDS journal as “new” where a logical `LogSegment` and log sequence number is required for other operations to proceed, in particular the MDSTable operations. The MDS uses this event when creating a rank or shutting it down. No subtree map is required when replaying the rank from this initial state.

## Configurations[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#configurations)

The targetted size of a log segment in terms of number of events is controlled by:

- mds_log_events_per_segment[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#confval-mds_log_events_per_segment)

  maximum number of events in an MDS journal segment type `uint` default `1024` min `1`

The frequency of major segments (noted by the journaling of the latest `ESubtreeMap`) is controlled by:

- mds_log_major_segment_event_ratio[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#confval-mds_log_major_segment_event_ratio)

  multiple of mds_log_events_per_segment between major segments type `uint` default `12` min `1` see also [`mds_log_events_per_segment`](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#confval-mds_log_events_per_segment)

When `mds_log_events_per_segment * mds_log_major_segment_event_ratio` non-`ESubtreeMap` events are logged, the MDS will journal a new `ESubtreeMap`. This is necessary to allow the journal to shrink in size during the trimming of expired segments.

The target maximum number of segments is controlled by:

- mds_log_max_segments[](https://docs.ceph.com/en/latest/cephfs/mds-journaling/#confval-mds_log_max_segments)

  The maximum number of segments (objects) in the journal before we initiate trimming. Set to `-1` to disable limits. type `uint` default `128` min `8`

The MDS will often sit a little above this number due to non-major segments awaiting trimming up to the next major segment.

# File layouts[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#file-layouts)

The layout of a file controls how its contents are mapped to Ceph RADOS objects.  You can read and write a file’s layout using *virtual extended attributes* or xattrs.

The name of the layout xattrs depends on whether a file is a regular file or a directory.  Regular files’ layout xattrs are called `ceph.file.layout`, whereas directories’ layout xattrs are called `ceph.dir.layout`.  Where subsequent examples refer to `ceph.file.layout`, substitute `dir` as appropriate when dealing with directories.

Tip

Your linux distribution may not ship with commands for manipulating xattrs by default, the required package is usually called `attr`.

## Layout fields[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#layout-fields)

- pool

  String, giving ID or name. String can only have  characters in the set [a-zA-Z0-9_-.]. Which RADOS pool a file’s data  objects will be stored in.

- pool_id

  String of digits. This is the system assigned pool id for the RADOS pool whenever it is created.

- pool_name

  String, given name. This is the user defined name for the RADOS pool whenever user creates it.

- pool_namespace

  String with only characters in the set [a-zA-Z0-9_-.].  Within the data pool, which RADOS namespace the objects will be written to.  Empty by default (i.e. default namespace).

- stripe_unit

  Integer in bytes.  The size (in bytes) of a  block of data used in the RAID 0 distribution of a file. All stripe  units for a file have equal size. The last stripe unit is typically  incomplete–i.e. it represents the data at the end of the file as well as unused “space” beyond it up to the end of the fixed stripe unit size.

- stripe_count

  Integer.  The number of consecutive stripe units that constitute a RAID 0 “stripe” of file data.

- object_size

  Integer in bytes.  File data is chunked into RADOS objects of this size.

Tip

RADOS enforces a configurable limit on object sizes: if you increase CephFS object sizes beyond that limit then writes may not succeed.  The OSD setting is `osd_max_object_size`, which is 128MB by default. Very large RADOS objects may prevent smooth operation of the cluster, so increasing the object size limit past the default is not recommended.

## Reading layouts with `getfattr`[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#reading-layouts-with-getfattr)

Read the layout information as a single string:

```
$ touch file
$ getfattr -n ceph.file.layout file
# file: file
ceph.file.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304 pool=cephfs_data"
```

Read individual layout fields:

```
$ getfattr -n ceph.file.layout.pool_name file
# file: file
ceph.file.layout.pool_name="cephfs_data"
$ getfattr -n ceph.file.layout.pool_id file
# file: file
ceph.file.layout.pool_id="5"
$ getfattr -n ceph.file.layout.pool file
# file: file
ceph.file.layout.pool="cephfs_data"
$ getfattr -n ceph.file.layout.stripe_unit file
# file: file
ceph.file.layout.stripe_unit="4194304"
$ getfattr -n ceph.file.layout.stripe_count file
# file: file
ceph.file.layout.stripe_count="1"
$ getfattr -n ceph.file.layout.object_size file
# file: file
ceph.file.layout.object_size="4194304"
```

Note

When reading layouts, the pool will usually be indicated by name.  However, in rare cases when pools have only just been created, the ID may be output instead.

Directories do not have an explicit layout until it is customized.  Attempts to read the layout will fail if it has never been modified: this indicates that layout of the next ancestor directory with an explicit layout will be used.

```
$ mkdir dir
$ getfattr -n ceph.dir.layout dir
dir: ceph.dir.layout: No such attribute
$ setfattr -n ceph.dir.layout.stripe_count -v 2 dir
$ getfattr -n ceph.dir.layout dir
# file: dir
ceph.dir.layout="stripe_unit=4194304 stripe_count=2 object_size=4194304 pool=cephfs_data"
```

Getting the layout in json format. If there’s no specific layout set for the particular inode, the system traverses the directory path backwards and finds the closest ancestor directory with a layout and returns it in json format. A file layout also can be retrieved in json format using `ceph.file.layout.json` vxattr.

A virtual field named `inheritance` is added to the json output to show the status of layout. The `inheritance` field can have the following values:

`@default` implies the system default layout `@set` implies that a specific layout has been set for that particular inode `@inherited` implies that the returned layout has been inherited from an ancestor

```
$ getfattr -n ceph.dir.layout.json --only-values /mnt/mycephs/accounts
{"stripe_unit": 4194304, "stripe_count": 1, "object_size": 4194304, "pool_name": "cephfs.a.data", "pool_id": 3, "pool_namespace": "", "inheritance": "@default"}
```

## Writing layouts with `setfattr`[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#writing-layouts-with-setfattr)

Layout fields are modified using `setfattr`:

```
$ ceph osd lspools
0 rbd
1 cephfs_data
2 cephfs_metadata

$ setfattr -n ceph.file.layout.stripe_unit -v 1048576 file2
$ setfattr -n ceph.file.layout.stripe_count -v 8 file2
$ setfattr -n ceph.file.layout.object_size -v 10485760 file2
$ setfattr -n ceph.file.layout.pool -v 1 file2  # Setting pool by ID
$ setfattr -n ceph.file.layout.pool -v cephfs_data file2  # Setting pool by name
$ setfattr -n ceph.file.layout.pool_id -v 1 file2  # Setting pool by ID
$ setfattr -n ceph.file.layout.pool_name -v cephfs_data file2  # Setting pool by name
```

Note

When the layout fields of a file are modified using `setfattr`, this file must be empty, otherwise an error will occur.

```
# touch an empty file
$ touch file1
# modify layout field successfully
$ setfattr -n ceph.file.layout.stripe_count -v 3 file1

# write something to file1
$ echo "hello world" > file1
$ setfattr -n ceph.file.layout.stripe_count -v 4 file1
setfattr: file1: Directory not empty
```

File and Directory layouts can also be set using the json format. The `inheritance` field is ignored when setting the layout. Also, if both, `pool_name` and `pool_id` fields are specified, then the `pool_name` is given preference for better disambiguation.

```
$ setfattr -n ceph.file.layout.json -v '{"stripe_unit": 4194304, "stripe_count": 1, "object_size": 4194304, "pool_name": "cephfs.a.data", "pool_id": 3, "pool_namespace": "", "inheritance": "@default"}' file1
```

## Clearing layouts[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#clearing-layouts)

If you wish to remove an explicit layout from a directory, to revert to inheriting the layout of its ancestor, you can do so:

```
setfattr -x ceph.dir.layout mydir
```

Similarly, if you have set the `pool_namespace` attribute and wish to modify the layout to use the default namespace instead:

```
# Create a dir and set a namespace on it
mkdir mydir
setfattr -n ceph.dir.layout.pool_namespace -v foons mydir
getfattr -n ceph.dir.layout mydir
ceph.dir.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304 pool=cephfs_data_a pool_namespace=foons"

# Clear the namespace from the directory's layout
setfattr -x ceph.dir.layout.pool_namespace mydir
getfattr -n ceph.dir.layout mydir
ceph.dir.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304 pool=cephfs_data_a"
```

## Inheritance of layouts[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#inheritance-of-layouts)

Files inherit the layout of their parent directory at creation time.  However, subsequent changes to the parent directory’s layout do not affect children.

```
$ getfattr -n ceph.dir.layout dir
# file: dir
ceph.dir.layout="stripe_unit=4194304 stripe_count=2 object_size=4194304 pool=cephfs_data"

# Demonstrate file1 inheriting its parent's layout
$ touch dir/file1
$ getfattr -n ceph.file.layout dir/file1
# file: dir/file1
ceph.file.layout="stripe_unit=4194304 stripe_count=2 object_size=4194304 pool=cephfs_data"

# Now update the layout of the directory before creating a second file
$ setfattr -n ceph.dir.layout.stripe_count -v 4 dir
$ touch dir/file2

# Demonstrate that file1's layout is unchanged
$ getfattr -n ceph.file.layout dir/file1
# file: dir/file1
ceph.file.layout="stripe_unit=4194304 stripe_count=2 object_size=4194304 pool=cephfs_data"

# ...while file2 has the parent directory's new layout
$ getfattr -n ceph.file.layout dir/file2
# file: dir/file2
ceph.file.layout="stripe_unit=4194304 stripe_count=4 object_size=4194304 pool=cephfs_data"
```

Files created as descendents of the directory also inherit the layout, if the intermediate directories do not have layouts set:

```
$ getfattr -n ceph.dir.layout dir
# file: dir
ceph.dir.layout="stripe_unit=4194304 stripe_count=4 object_size=4194304 pool=cephfs_data"
$ mkdir dir/childdir
$ getfattr -n ceph.dir.layout dir/childdir
dir/childdir: ceph.dir.layout: No such attribute
$ touch dir/childdir/grandchild
$ getfattr -n ceph.file.layout dir/childdir/grandchild
# file: dir/childdir/grandchild
ceph.file.layout="stripe_unit=4194304 stripe_count=4 object_size=4194304 pool=cephfs_data"
```



## Adding a data pool to the File System[](https://docs.ceph.com/en/latest/cephfs/file-layouts/#adding-a-data-pool-to-the-file-system)

Before you can use a pool with CephFS you have to add it to the Metadata Servers.

```
$ ceph fs add_data_pool cephfs cephfs_data_ssd
$ ceph fs ls  # Pool should now show up
.... data pools: [cephfs_data cephfs_data_ssd ]
```

Make sure that your cephx keys allows the client to access this new pool.

You can then update the layout on a directory in CephFS to use the pool you added:

```
$ mkdir /mnt/cephfs/myssddir
$ setfattr -n ceph.dir.layout.pool -v cephfs_data_ssd /mnt/cephfs/myssddir
```

All new files created within that directory will now inherit its layout and place their data in your newly added pool.

You may notice that object counts in your primary data pool (the one passed to `fs new`) continue to increase, even if files are being created in the pool you  added.  This is normal: the file data is stored in the pool specified by the layout, but a small amount of metadata is kept in the primary data  pool for all files.

# CephFS Distributed Metadata Cache[](https://docs.ceph.com/en/latest/cephfs/mdcache/#cephfs-distributed-metadata-cache)

While the data for inodes in a Ceph file system is stored in RADOS and accessed by the clients directly, inode metadata and directory information is managed by the Ceph metadata server (MDS). The MDS’s act as mediator for all metadata related activity, storing the resulting information in a separate RADOS pool from the file data.

CephFS clients can request that the MDS fetch or change inode metadata on its behalf, but an MDS can also grant the client **capabilities** (aka **caps**) for each inode (see [Capabilities in CephFS](https://docs.ceph.com/en/latest/cephfs/capabilities/)).

A capability grants the client the ability to cache and possibly manipulate some portion of the data or metadata associated with the inode. When another client needs access to the same information, the MDS will revoke the capability and the client will eventually return it, along with an updated version of the inode’s metadata (in the event that it made changes to it while it held the capability).

Clients can request capabilities and will generally get them, but when there is competing access or memory pressure on the MDS, they may be **revoked**. When a capability is revoked, the client is responsible for returning it as soon as it is able. Clients that fail to do so in a timely fashion may end up **blocklisted** and unable to communicate with the cluster.

Since the cache is distributed, the MDS must take great care to ensure that no client holds capabilities that may conflict with other clients’ capabilities, or operations that it does itself. This allows cephfs clients to rely on much greater cache coherence than a filesystem like NFS, where the client may cache data and metadata beyond the point where it has changed on the server.

## Client Metadata Requests[](https://docs.ceph.com/en/latest/cephfs/mdcache/#client-metadata-requests)

When a client needs to query/change inode metadata or perform an operation on a directory, it has two options. It can make a request to the MDS directly, or serve the information out of its cache. With CephFS, the latter is only possible if the client has the necessary caps.

Clients can send simple requests to the MDS to query or request changes to certain metadata. The replies to these requests may also grant the client a certain set of caps for the inode, allowing it to perform subsequent requests without consulting the MDS.

Clients can also request caps directly from the MDS, which is necessary in order to read or write file data.

## Distributed Locks in an MDS Cluster[](https://docs.ceph.com/en/latest/cephfs/mdcache/#distributed-locks-in-an-mds-cluster)

When an MDS wants to read or change information about an inode, it must gather the appropriate locks for it. The MDS cluster may have a series of different types of locks on the given inode and each MDS may have disjoint sets of locks.

If there are outstanding caps that would conflict with these locks, then they must be revoked before the lock can be acquired. Once the competing caps are returned to the MDS, then it can get the locks and do the operation.

On a filesystem served by multiple MDS’, the metadata cache is also distributed among the MDS’ in the cluster. For every inode, at any given time, only one MDS in the cluster is considered **authoritative**. Any requests to change that inode must be done by the authoritative MDS, though non-authoritative MDS can forward requests to the authoritative one.

Non-auth MDS’ can also obtain read locks that prevent the auth MDS from changing the data until the lock is dropped, so that they can serve inode info to the clients.

The auth MDS for an inode can change over time as well. The MDS’ will actively balance responsibility for the inode cache amongst themselves, but this can be overridden by **pinning** certain subtrees to a single MDS.

# CephFS Dynamic Metadata Management[](https://docs.ceph.com/en/latest/cephfs/dynamic-metadata-management/#cephfs-dynamic-metadata-management)

Metadata operations usually take up more than 50 percent of all file system operations. Also the metadata scales in a more complex fashion when compared to scaling storage (which in turn scales I/O throughput linearly). This is due to the hierarchical and interdependent nature of the file system metadata. So in CephFS, the metadata workload is decoupled from data workload so as to avoid placing unnecessary strain on the RADOS cluster. The metadata is hence handled by a cluster of Metadata Servers (MDSs). CephFS distributes metadata across MDSs via [Dynamic Subtree Partitioning](https://ceph.com/assets/pdfs/weil-mds-sc04.pdf).

## Dynamic Subtree Partitioning[](https://docs.ceph.com/en/latest/cephfs/dynamic-metadata-management/#dynamic-subtree-partitioning)

In traditional subtree partitioning, subtrees of the file system hierarchy are assigned to individual MDSs. This metadata distribution strategy provides good hierarchical locality, linear growth of cache and horizontal scaling across MDSs and a fairly good distribution of metadata across MDSs.

![../../_images/subtree-partitioning.svg](https://docs.ceph.com/en/latest/_images/subtree-partitioning.svg)

The problem with traditional subtree partitioning is that the workload growth by depth (across a single MDS) leads to a hotspot of activity. This results in lack of vertical scaling and wastage of non-busy resources/MDSs.

This led to the adoption of a more dynamic way of handling metadata: Dynamic Subtree Partitioning, where load intensive portions of the directory hierarchy from busy MDSs are migrated to non busy MDSs.

This strategy ensures that activity hotspots are relieved as they appear and so leads to vertical scaling of the metadata workload in addition to horizontal scaling.

## Export Process During Subtree Migration[](https://docs.ceph.com/en/latest/cephfs/dynamic-metadata-management/#export-process-during-subtree-migration)

Once the exporter verifies that the subtree is permissible to be exported (Non degraded cluster, non-frozen subtree root), the subtree root directory is temporarily auth pinned, the subtree freeze is initiated, and the exporter is committed to the subtree migration, barring an intervening failure of the importer or itself.

The MExportDiscover message is exchanged to ensure that the inode for the base directory being exported is open on the destination node. It is auth pinned by the importer to prevent it from being trimmed. This occurs before the exporter completes the freeze of the subtree to ensure that the importer is able to replicate the necessary metadata. When the exporter receives the MDiscoverAck, it allows the freeze to proceed by removing its temporary auth pin.

A warning stage occurs only if the base subtree directory is open by nodes other than the importer and exporter. If it is not, then this implies that no metadata within or nested beneath the subtree is replicated by any node other than the importer and exporter. If it is, then an MExportWarning message informs any bystanders that the authority for the region is temporarily ambiguous, and lists both the exporter and importer as authoritative MDS nodes. In particular, bystanders who are trimming items from their cache must send MCacheExpire messages to both the old and new authorities. This is necessary to ensure that the surviving authority reliably receives all expirations even if the importer or exporter fails. While the subtree is frozen (on both the importer and exporter), expirations will not be immediately processed; instead, they will be queued until the region is unfrozen and it can be determined that the node is or is not authoritative.

The exporter then packages an MExport message containing all metadata of the subtree and flags the objects as non-authoritative. The MExport message sends the actual subtree metadata to the importer. Upon receipt, the importer inserts the data into its cache, marks all objects as authoritative, and logs a copy of all metadata in an EImportStart journal message. Once that has safely flushed, it replies with an MExportAck. The exporter can now log an EExport journal entry, which ultimately specifies that the export was a success. In the presence of failures, it is the existence of the EExport entry only that disambiguates authority during recovery.

Once logged, the exporter will send an MExportNotify to any bystanders, informing them that the authority is no longer ambiguous and cache expirations should be sent only to the new authority (the importer). Once these are acknowledged back to the exporter, implicitly flushing the bystander to exporter message streams of any stray expiration notices, the exporter unfreezes the subtree, cleans up its migration-related state, and sends a final MExportFinish to the importer. Upon receipt, the importer logs an EImportFinish(true) (noting locally that the export was indeed a success), unfreezes its subtree, processes any queued cache expirations, and cleans up its state.

# Ceph File System IO Path[](https://docs.ceph.com/en/latest/cephfs/cephfs-io-path/#ceph-file-system-io-path)

All file data in CephFS is stored as RADOS objects. CephFS clients can directly access RADOS to operate on file data. MDS only handles metadata operations.

To read/write a CephFS file, client needs to have ‘file read/write’ capabilities for corresponding inode. If client does not have required capabilities, it sends a ‘cap message’ to MDS, telling MDS what it wants. MDS will issue capabilities to client when it is possible. Once client has ‘file read/write’ capabilities, it can directly access RADOS to read/write file data. File data are stored as RADOS objects in the form of <inode number>.<object index>. See ‘Data Striping’ section of [Architecture](https://docs.ceph.com/en/latest/cephfs/architecture) for more information. If the file is only opened by one client, MDS also issues ‘file cache/buffer’ capabilities to the only client. The ‘file cache’ capability means that file read can be satisfied by client cache. The ‘file buffer’ capability means that file write can be buffered in client cache.

![img](https://docs.ceph.com/en/latest/_images/ditaa-a82a1ec1b70dbdb641b20e887c272adae1dca5af.png)



# LazyIO[](https://docs.ceph.com/en/latest/cephfs/lazyio/#lazyio)

LazyIO relaxes POSIX semantics. Buffered reads/writes are allowed even when a file is opened by multiple applications on multiple clients. Applications are responsible for managing cache coherency themselves.

Libcephfs supports LazyIO since nautilus release.

## Enable LazyIO[](https://docs.ceph.com/en/latest/cephfs/lazyio/#enable-lazyio)

LazyIO can be enabled by following ways.

- `client_force_lazyio` option enables LAZY_IO globally for libcephfs and ceph-fuse mount.
- `ceph_lazyio(...)` and `ceph_ll_lazyio(...)` enable LAZY_IO for file handle in libcephfs.

## Using LazyIO[](https://docs.ceph.com/en/latest/cephfs/lazyio/#using-lazyio)

LazyIO includes two methods `lazyio_propagate()` and `lazyio_synchronize()`. With LazyIO enabled, writes may not be visible to other clients until `lazyio_propagate()` is called. Reads may come from local cache (irrespective of changes to the file by other clients) until `lazyio_synchronize()` is called.

- `lazyio_propagate(int fd, loff_t offset, size_t count)` - Ensures that any buffered writes of the client, in the specific region (offset to offset+count), has been propagated to the shared file. If offset and count are both 0, the operation is performed on the entire file. Currently only this is supported.
- `lazyio_synchronize(int fd, loff_t offset, size_t count)` - Ensures that the client is, in a subsequent read call, able to read the updated file with all the propagated writes of the other clients. In CephFS this is facilitated by invalidating the file caches pertaining to the inode and hence forces the client to refetch/recache the data from the updated file. Also if the write cache of the calling client is dirty (not propagated), lazyio_synchronize() flushes it as well.

An example usage (utilizing libcephfs) is given below. This is a sample I/O loop for a particular client/file descriptor in a parallel application:

```
/* Client a (ca) opens the shared file file.txt */
int fda = ceph_open(ca, "shared_file.txt", O_CREAT|O_RDWR, 0644);

/* Enable LazyIO for fda */
ceph_lazyio(ca, fda, 1));

for(i = 0; i < num_iters; i++) {
    char out_buf[] = "fooooooooo";

    ceph_write(ca, fda, out_buf, sizeof(out_buf), i);
    /* Propagate the writes associated with fda to the backing storage*/
    ceph_propagate(ca, fda, 0, 0);

    /* The barrier makes sure changes associated with all file descriptors
    are propagated so that there is certainty that the backing file
    is up to date */
    application_specific_barrier();

    char in_buf[40];
    /* Calling ceph_lazyio_synchronize here will ascertain that ca will
    read the updated file with the propagated changes and not read
    stale cached data */
    ceph_lazyio_synchronize(ca, fda, 0, 0);
    ceph_read(ca, fda, in_buf, sizeof(in_buf), 0);

    /* A barrier is required here before returning to the next write
    phase so as to avoid overwriting the portion of the shared file still
    being read by another file descriptor */
    application_specific_barrier();
}
```

Brought to you by the Ceph Foundation

# Configuring Directory fragmentation[](https://docs.ceph.com/en/latest/cephfs/dirfrags/#configuring-directory-fragmentation)

In CephFS, directories are *fragmented* when they become very large or very busy.  This splits up the metadata so that it can be shared between multiple MDS daemons, and between multiple objects in the metadata pool.

In normal operation, directory fragmentation is invisible to users and administrators, and all the configuration settings mentioned here should be left at their default values.

While directory fragmentation enables CephFS to handle very large numbers of entries in a single directory, application programmers should remain conservative about creating very large directories, as they still have a resource cost in situations such as a CephFS client listing the directory, where all the fragments must be loaded at once.

Tip

The root directory cannot be fragmented.

All directories are initially created as a single fragment.  This fragment may be *split* to divide up the directory into more fragments, and these fragments may be *merged* to reduce the number of fragments in the directory.

## Splitting and merging[](https://docs.ceph.com/en/latest/cephfs/dirfrags/#splitting-and-merging)

When an MDS identifies a directory fragment to be split, it does not do the split immediately.  Because splitting interrupts metadata IO, a short delay is used to allow short bursts of client IO to complete before the split begins.  This delay is configured with `mds_bal_fragment_interval`, which defaults to 5 seconds.

When the split is done, the directory fragment is broken up into a power of two number of new fragments.  The number of new fragments is given by two to the power `mds_bal_split_bits`, i.e. if `mds_bal_split_bits` is 2, then four new fragments will be created.  The default setting is 3, i.e. splits create 8 new fragments.

The criteria for initiating a split or a merge are described in the following sections.

## Size thresholds[](https://docs.ceph.com/en/latest/cephfs/dirfrags/#size-thresholds)

A directory fragment is eligible for splitting when its size exceeds `mds_bal_split_size` (default 10000 directory entries).  Ordinarily this split is delayed by `mds_bal_fragment_interval`, but if the fragment size exceeds a factor of `mds_bal_fragment_fast_factor` the split size, the split will happen immediately (holding up any client metadata IO on the directory).

`mds_bal_fragment_size_max` is the hard limit on the size of directory fragments.  If it is reached, clients will receive ENOSPC errors if they try to create files in the fragment.  On a properly configured system, this limit should never be reached on ordinary directories, as they will have split long before.  By default, this is set to 10 times the split size, giving a dirfrag size limit of 100000 directory entries.  Increasing this limit may lead to oversized directory fragment objects in the metadata pool, which the OSDs may not be able to handle.

A directory fragment is eligible for merging when its size is less than `mds_bal_merge_size`.  There is no merge equivalent of the “fast splitting” explained above: fast splitting exists to avoid creating oversized directory fragments, there is no equivalent issue to avoid when merging.  The default merge size is 50 directory entries.

## Activity thresholds[](https://docs.ceph.com/en/latest/cephfs/dirfrags/#activity-thresholds)

In addition to splitting fragments based on their size, the MDS may split directory fragments if their activity exceeds a threshold.

The MDS maintains separate time-decaying load counters for read and write operations on directory fragments.  The decaying load counters have an exponential decay based on the `mds_decay_halflife` setting.

On writes, the write counter is incremented, and compared with `mds_bal_split_wr`, triggering a split if the threshold is exceeded.  Write operations include metadata IO such as renames, unlinks and creations.

The `mds_bal_split_rd` threshold is applied based on the read operation load counter, which tracks readdir operations.

The `mds_bal_split_rd` and `mds_bal_split_wr` configs represent the popularity threshold. In the MDS these are measured as “read/write temperatures” which is closely related to the number of respective read/write operations. By default, the read threshold is 25000 operations and the write threshold is 10000 operations, i.e. 2.5x as many reads as writes would be required to trigger a split.

After fragments are split due to the activity thresholds, they are only merged based on the size threshold (`mds_bal_merge_size`), so a spike in activity may cause a directory to stay fragmented forever unless some entries are unlinked.

# Configuring multiple active MDS daemons[](https://docs.ceph.com/en/latest/cephfs/multimds/#configuring-multiple-active-mds-daemons)

*Also known as: multi-mds, active-active MDS*

Each CephFS file system is configured for a single active MDS daemon by default.  To scale metadata performance for large scale systems, you may enable multiple active MDS daemons, which will share the metadata workload with one another.

## When should I use multiple active MDS daemons?[](https://docs.ceph.com/en/latest/cephfs/multimds/#when-should-i-use-multiple-active-mds-daemons)

You should configure multiple active MDS daemons when your metadata performance is bottlenecked on the single MDS that runs by default.

Adding more daemons may not increase performance on all workloads.  Typically, a single application running on a single client will not benefit from an increased number of MDS daemons unless the application is doing a lot of metadata operations in parallel.

Workloads that typically benefit from a larger number of active MDS daemons are those with many clients, perhaps working on many separate directories.

## Increasing the MDS active cluster size[](https://docs.ceph.com/en/latest/cephfs/multimds/#increasing-the-mds-active-cluster-size)

Each CephFS file system has a *max_mds* setting, which controls how many ranks will be created.  The actual number of ranks in the file system will only be increased if a spare daemon is available to take on the new rank. For example, if there is only one MDS daemon running, and max_mds is set to two, no second rank will be created. (Note that such a configuration is not Highly Available (HA) because no standby is available to take over for a failed rank. The cluster will complain via health warnings when configured this way.)

Set `max_mds` to the desired number of ranks.  In the following examples the “fsmap” line of “ceph status” is shown to illustrate the expected result of commands.

```
# fsmap e5: 1/1/1 up {0=a=up:active}, 2 up:standby

ceph fs set <fs_name> max_mds 2

# fsmap e8: 2/2/2 up {0=a=up:active,1=c=up:creating}, 1 up:standby
# fsmap e9: 2/2/2 up {0=a=up:active,1=c=up:active}, 1 up:standby
```

The newly created rank (1) will pass through the ‘creating’ state and then enter this ‘active state’.

## Standby daemons[](https://docs.ceph.com/en/latest/cephfs/multimds/#standby-daemons)

Even with multiple active MDS daemons, a highly available system **still requires standby daemons** to take over if any of the servers running an active daemon fail.

Consequently, the practical maximum of `max_mds` for highly available systems is at most one less than the total number of MDS servers in your system.

To remain available in the event of multiple server failures, increase the number of standby daemons in the system to match the number of server failures you wish to withstand.

## Decreasing the number of ranks[](https://docs.ceph.com/en/latest/cephfs/multimds/#decreasing-the-number-of-ranks)

Reducing the number of ranks is as simple as reducing `max_mds`:

```
# fsmap e9: 2/2/2 up {0=a=up:active,1=c=up:active}, 1 up:standby
ceph fs set <fs_name> max_mds 1
# fsmap e10: 2/2/1 up {0=a=up:active,1=c=up:stopping}, 1 up:standby
# fsmap e10: 2/2/1 up {0=a=up:active,1=c=up:stopping}, 1 up:standby
...
# fsmap e10: 1/1/1 up {0=a=up:active}, 2 up:standby
```

The cluster will automatically stop extra ranks incrementally until `max_mds` is reached.

See [CephFS Administrative commands](https://docs.ceph.com/en/latest/cephfs/administration/) for more details which forms `<role>` can take.

Note: stopped ranks will first enter the stopping state for a period of time while it hands off its share of the metadata to the remaining active daemons.  This phase can take from seconds to minutes.  If the MDS appears to be stuck in the stopping state then that should be investigated as a possible bug.

If an MDS daemon crashes or is killed while in the `up:stopping` state, a standby will take over and the cluster monitors will against try to stop the daemon.

When a daemon finishes stopping, it will respawn itself and go back to being a standby.



## Manually pinning directory trees to a particular rank[](https://docs.ceph.com/en/latest/cephfs/multimds/#manually-pinning-directory-trees-to-a-particular-rank)

In multiple active metadata server configurations, a balancer runs which works to spread metadata load evenly across the cluster. This usually works well enough for most users but sometimes it is desirable to override the dynamic balancer with explicit mappings of metadata to particular ranks. This can allow the administrator or users to evenly spread application load or limit impact of users’ metadata requests on the entire cluster.

The mechanism provided for this purpose is called an `export pin`, an extended attribute of directories. The name of this extended attribute is `ceph.dir.pin`.  Users can set this attribute using standard commands:

```
setfattr -n ceph.dir.pin -v 2 path/to/dir
```

The value of the extended attribute is the rank to assign the directory subtree to. A default value of `-1` indicates the directory is not pinned.

A directory’s export pin is inherited from its closest parent with a set export pin.  In this way, setting the export pin on a directory affects all of its children. However, the parents pin can be overridden by setting the child directory’s export pin. For example:

```
mkdir -p a/b
# "a" and "a/b" both start without an export pin set
setfattr -n ceph.dir.pin -v 1 a/
# a and b are now pinned to rank 1
setfattr -n ceph.dir.pin -v 0 a/b
# a/b is now pinned to rank 0 and a/ and the rest of its children are still pinned to rank 1
```



## Setting subtree partitioning policies[](https://docs.ceph.com/en/latest/cephfs/multimds/#setting-subtree-partitioning-policies)

It is also possible to setup **automatic** static partitioning of subtrees via a set of **policies**. In CephFS, this automatic static partitioning is referred to as **ephemeral pinning**. Any directory (inode) which is ephemerally pinned will be automatically assigned to a particular rank according to a consistent hash of its inode number. The set of all ephemerally pinned directories should be uniformly distributed across all ranks.

Ephemerally pinned directories are so named because the pin may not persist once the directory inode is dropped from cache. However, an MDS failover does not affect the ephemeral nature of the pinned directory. The MDS records what subtrees are ephemerally pinned in its journal so MDS failovers do not drop this information.

A directory is either ephemerally pinned or not. Which rank it is pinned to is derived from its inode number and a consistent hash. This means that ephemerally pinned directories are somewhat evenly spread across the MDS cluster. The **consistent hash** also minimizes redistribution when the MDS cluster grows or shrinks. So, growing an MDS cluster may automatically increase your metadata throughput with no other administrative intervention.

Presently, there are two types of ephemeral pinning:

**Distributed Ephemeral Pins**: This policy causes a directory to fragment (even well below the normal fragmentation thresholds) and distribute its fragments as ephemerally pinned subtrees. This has the effect of distributing immediate children across a range of MDS ranks.  The canonical example use-case would be the `/home` directory: we want every user’s home directory to be spread across the entire MDS cluster. This can be set via:

```
setfattr -n ceph.dir.pin.distributed -v 1 /cephfs/home
```

**Random Ephemeral Pins**: This policy indicates any descendent sub-directory may be ephemerally pinned. This is set through the extended attribute `ceph.dir.pin.random` with the value set to the percentage of directories that should be pinned. For example:

```
setfattr -n ceph.dir.pin.random -v 0.5 /cephfs/tmp
```

Would cause any directory loaded into cache or created under `/tmp` to be ephemerally pinned 50 percent of the time.

It is recommended to only set this to small values, like `.001` or `0.1%`. Having too many subtrees may degrade performance. For this reason, the config `mds_export_ephemeral_random_max` enforces a cap on the maximum of this percentage (default: `.01`). The MDS returns `EINVAL` when attempting to set a value beyond this config.

Both random and distributed ephemeral pin policies are off by default in Octopus. The features may be enabled via the `mds_export_ephemeral_random` and `mds_export_ephemeral_distributed` configuration options.

Ephemeral pins may override parent export pins and vice versa. What determines which policy is followed is the rule of the closest parent: if a closer parent directory has a conflicting policy, use that one instead. For example:

```
mkdir -p foo/bar1/baz foo/bar2
setfattr -n ceph.dir.pin -v 0 foo
setfattr -n ceph.dir.pin.distributed -v 1 foo/bar1
```

The `foo/bar1/baz` directory will be ephemerally pinned because the `foo/bar1` policy overrides the export pin on `foo`. The `foo/bar2` directory will obey the pin on `foo` normally.

For the reverse situation:

```
mkdir -p home/{patrick,john}
setfattr -n ceph.dir.pin.distributed -v 1 home
setfattr -n ceph.dir.pin -v 2 home/patrick
```

The `home/patrick` directory and its children will be pinned to rank 2 because its export pin overrides the policy on `home`.

To remove a partitioning policy, remove the respective extended attribute or set the value to 0.

For export pins, remove the extended attribute or set the extended attribute value to -1.

## Dynamic subtree partitioning with Balancer on specific ranks[](https://docs.ceph.com/en/latest/cephfs/multimds/#dynamic-subtree-partitioning-with-balancer-on-specific-ranks)

The CephFS file system provides the `bal_rank_mask` option to enable the balancer to dynamically rebalance subtrees within particular active MDS ranks. This allows administrators to employ both the dynamic subtree partitioning and static pining schemes in different active MDS ranks so that metadata loads are optimized based on user demand. For instance, in realistic cloud storage environments, where a lot of subvolumes are allotted to multiple computing nodes (e.g., VMs and containers), some subvolumes that require high performance are managed by static partitioning, whereas most subvolumes that experience a moderate workload are managed by the balancer. As the balancer evenly spreads the metadata workload to all active MDS ranks, performance of static pinned subvolumes inevitably may be affected or degraded. If this option is enabled, subtrees managed by the balancer are not affected by static pinned subtrees.

This option can be configured with the `ceph fs set` command. For example:

```
ceph fs set <fs_name> bal_rank_mask <hex>
```

Each bitfield of the `<hex>` number represents a dedicated rank. If the `<hex>` is set to `0x3`, the balancer runs on active `0` and `1` ranks. For example:

```
ceph fs set <fs_name> bal_rank_mask 0x3
```

If the `bal_rank_mask` is set to `-1` or `all`, all active ranks are masked and utilized by the balancer. As an example:

```
ceph fs set <fs_name> bal_rank_mask -1
```

On the other hand, if the balancer needs to be disabled, the `bal_rank_mask` should be set to `0x0`. For example:

```
ceph fs set <fs_name> bal_rank_mask 0x0
```