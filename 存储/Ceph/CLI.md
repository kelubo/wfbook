# CLI

[TOC]

## ceph

```bash
ceph <OPTION>
    -w                                         #查看整个集群的状态。
    status                                     #查看整个集群的状态。

ceph mds <COMMAND>
    dump		                               #查看MDS map

ceph mon <COMMAND>
    dump                                       #查看monitor map
    stat                                       #查看monitor状态

ceph mon_status                                #查看monitor状态

ceph osd <COMMAND>
    crush dump                                 #查看CRUSH map
          add-bucket name rack                 #创建Bucket
          move name root=default               #移动Bucket
    getcrushmap -o filename.txt                #将CRUSH导出为不可读的配置文件。
    ls                                         #查看所有OSD的ID
    map pool_name obj_name					   #查看池内对象的信息（/var/lib/ceph/osd/）
    dump                                       #查看OSD map
    pool create pool_name pg_num pgp_num       #创建池
         set pool_name size n                  #设置副本数
         rename pool_name new_name             #重命名池
    stat                                       #检查OSD map和状态
    tree                                       #检查OSD树形图

ceph pg <COMMAND>
    dump                                       #查看PG map
```

## rados

```bash
rados [OPTION] COMMAND

    df					                       #查看集群空间的使用情况
    lspools				                       #查看RADOS池
    -p <pool_name> ls	                       #查看池中的对象
                   put obj_name /path/filename #想池中添加对象
```

## service

```bash
service ceph status <COMMAND>
    mon                                        #检查monitor服务的状态
    osd                                        #检查单个节点上OSD的状态

service ceph -a status osd                     #检查整个集群上OSD的状态,ceph.conf文件必须有所有OSD的所有信息。
```

## crushtool

```bash
#解码CRUSH配置文件为可读的文本文件。
crushtool -d crushmap.txt -o crushmap-decompile.txt
```





# Control Commands[](https://docs.ceph.com/en/latest/rados/operations/control/#control-commands)

## Monitor Commands[](https://docs.ceph.com/en/latest/rados/operations/control/#monitor-commands)

Monitor commands are issued using the `ceph` utility:

```
ceph [-m monhost] {command}
```

The command is usually (though not always) of the form:

```
ceph {subsystem} {command}
```

## System Commands[](https://docs.ceph.com/en/latest/rados/operations/control/#system-commands)

Execute the following to display the current cluster status.

```
ceph -s
ceph status
```

Execute the following to display a running summary of cluster status and major events.

```
ceph -w
```

Execute the following to show the monitor quorum, including which monitors are participating and which one is the leader.

```
ceph mon stat
ceph quorum_status
```

Execute the following to query the status of a single monitor, including whether or not it is in the quorum.

```
ceph tell mon.[id] mon_status
```

where the value of `[id]` can be determined, e.g., from `ceph -s`.

## Authentication Subsystem[](https://docs.ceph.com/en/latest/rados/operations/control/#authentication-subsystem)

To add a keyring for an OSD, execute the following:

```
ceph auth add {osd} {--in-file|-i} {path-to-osd-keyring}
```

To list the cluster’s keys and their capabilities, execute the following:

```
ceph auth ls
```

## Placement Group Subsystem[](https://docs.ceph.com/en/latest/rados/operations/control/#placement-group-subsystem)

To display the statistics for all placement groups (PGs), execute the following:

```
ceph pg dump [--format {format}]
```

The valid formats are `plain` (default), `json` `json-pretty`, `xml`, and `xml-pretty`. When implementing monitoring and other tools, it is best to use `json` format. JSON parsing is more deterministic than the human-oriented `plain`, and the layout is much less variable from release to release.  The `jq` utility can be invaluable when extracting data from JSON output.

To display the statistics for all placement groups stuck in a specified state, execute the following:

```
ceph pg dump_stuck inactive|unclean|stale|undersized|degraded [--format {format}] [-t|--threshold {seconds}]
```

`--format` may be `plain` (default), `json`, `json-pretty`, `xml`, or `xml-pretty`.

`--threshold` defines how many seconds “stuck” is (default: 300)

**Inactive** Placement groups cannot process reads or writes because they are waiting for an OSD with the most up-to-date data to come back.

**Unclean** Placement groups contain objects that are not replicated the desired number of times. They should be recovering.

**Stale** Placement groups are in an unknown state - the OSDs that host them have not reported to the monitor cluster in a while (configured by `mon_osd_report_timeout`).

Delete “lost” objects or revert them to their prior state, either a previous version or delete them if they were just created.

```
ceph pg {pgid} mark_unfound_lost revert|delete
```



## OSD Subsystem[](https://docs.ceph.com/en/latest/rados/operations/control/#osd-subsystem)

Query OSD subsystem status.

```
ceph osd stat
```

Write a copy of the most recent OSD map to a file. See [osdmaptool](https://docs.ceph.com/en/latest/man/8/osdmaptool/#osdmaptool).

```
ceph osd getmap -o file
```

Write a copy of the crush map from the most recent OSD map to file.

```
ceph osd getcrushmap -o file
```

The foregoing is functionally equivalent to

```
ceph osd getmap -o /tmp/osdmap
osdmaptool /tmp/osdmap --export-crush file
```

Dump the OSD map. Valid formats for `-f` are `plain`, `json`, `json-pretty`, `xml`, and `xml-pretty`. If no `--format` option is given, the OSD map is dumped as plain text.  As above, JSON format is best for tools, scripting, and other automation.

```
ceph osd dump [--format {format}]
```

Dump the OSD map as a tree with one line per OSD containing weight and state.

```
ceph osd tree [--format {format}]
```

Find out where a specific object is or would be stored in the system:

```
ceph osd map <pool-name> <object-name>
```

Add or move a new item (OSD) with the given id/name/weight at the specified location.

```
ceph osd crush set {id} {weight} [{loc1} [{loc2} ...]]
```

Remove an existing item (OSD) from the CRUSH map.

```
ceph osd crush remove {name}
```

Remove an existing bucket from the CRUSH map.

```
ceph osd crush remove {bucket-name}
```

Move an existing bucket from one position in the hierarchy to another.

```
ceph osd crush move {id} {loc1} [{loc2} ...]
```

Set the weight of the item given by `{name}` to `{weight}`.

```
ceph osd crush reweight {name} {weight}
```

Mark an OSD as `lost`. This may result in permanent data loss. Use with caution.

```
ceph osd lost {id} [--yes-i-really-mean-it]
```

Create a new OSD. If no UUID is given, it will be set automatically when the OSD starts up.

```
ceph osd create [{uuid}]
```

Remove the given OSD(s).

```
ceph osd rm [{id}...]
```

Query the current `max_osd` parameter in the OSD map.

```
ceph osd getmaxosd
```

Import the given crush map.

```
ceph osd setcrushmap -i file
```

Set the `max_osd` parameter in the OSD map. This defaults to 10000 now so most admins will never need to adjust this.

```
ceph osd setmaxosd
```

Mark OSD `{osd-num}` down.

```
ceph osd down {osd-num}
```

Mark OSD `{osd-num}` out of the distribution (i.e. allocated no data).

```
ceph osd out {osd-num}
```

Mark `{osd-num}` in the distribution (i.e. allocated data).

```
ceph osd in {osd-num}
```

Set or clear the pause flags in the OSD map. If set, no IO requests will be sent to any OSD. Clearing the flags via unpause results in resending pending requests.

```
ceph osd pause
ceph osd unpause
```

Set the override weight (reweight) of `{osd-num}` to `{weight}`. Two OSDs with the same weight will receive roughly the same number of I/O requests and store approximately the same amount of data. `ceph osd reweight` sets an override weight on the OSD. This value is in the range 0 to 1, and forces CRUSH to re-place (1-weight) of the data that would otherwise live on this drive. It does not change weights assigned to the buckets above the OSD in the crush map, and is a corrective measure in case the normal CRUSH distribution is not working out quite right. For instance, if one of your OSDs is at 90% and the others are at 50%, you could reduce this weight to compensate.

```
ceph osd reweight {osd-num} {weight}
```

Balance OSD fullness by reducing the override weight of OSDs which are overly utilized.  Note that these override aka `reweight` values default to 1.00000 and are relative only to each other; they not absolute. It is crucial to distinguish them from CRUSH weights, which reflect the absolute capacity of a bucket in TiB.  By default this command adjusts override weight on OSDs which have + or - 20% of the average utilization, but if you include a `threshold` that percentage will be used instead.

```
ceph osd reweight-by-utilization [threshold [max_change [max_osds]]] [--no-increasing]
```

To limit the step by which any OSD’s reweight will be changed, specify `max_change` which defaults to 0.05.  To limit the number of OSDs that will be adjusted, specify `max_osds` as well; the default is 4.  Increasing these parameters can speed leveling of OSD utilization, at the potential cost of greater impact on client operations due to more data moving at once.

To determine which and how many PGs and OSDs will be affected by a given invocation you can test before executing.

```
ceph osd test-reweight-by-utilization [threshold [max_change max_osds]] [--no-increasing]
```

Adding `--no-increasing` to either command prevents increasing any override weights that are currently < 1.00000.  This can be useful when you are balancing in a hurry to remedy `full` or `nearful` OSDs or when some OSDs are being evacuated or slowly brought into service.

Deployments utilizing Nautilus (or later revisions of Luminous and Mimic) that have no pre-Luminous cients may instead wish to instead enable the balancer` module for `ceph-mgr`.

Add/remove an IP address or CIDR range to/from the blocklist. When adding to the blocklist, you can specify how long it should be blocklisted in seconds; otherwise, it will default to 1 hour. A blocklisted address is prevented from connecting to any OSD. If you blocklist an IP or range containing an OSD, be aware that OSD will also be prevented from performing operations on its peers where it acts as a client. (This includes tiering and copy-from functionality.)

If you want to blocklist a range (in CIDR format), you may do so by including the `range` keyword.

These commands are mostly only useful for failure testing, as blocklists are normally maintained automatically and shouldn’t need manual intervention.

```
ceph osd blocklist ["range"] add ADDRESS[:source_port][/netmask_bits] [TIME]
ceph osd blocklist ["range"] rm ADDRESS[:source_port][/netmask_bits]
```

Creates/deletes a snapshot of a pool.

```
ceph osd pool mksnap {pool-name} {snap-name}
ceph osd pool rmsnap {pool-name} {snap-name}
```

Creates/deletes/renames a storage pool.

```
ceph osd pool create {pool-name} [pg_num [pgp_num]]
ceph osd pool delete {pool-name} [{pool-name} --yes-i-really-really-mean-it]
ceph osd pool rename {old-name} {new-name}
```

Changes a pool setting.

```
ceph osd pool set {pool-name} {field} {value}
```

Valid fields are:

> - `size`: Sets the number of copies of data in the pool.
> - `pg_num`: The placement group number.
> - `pgp_num`: Effective number when calculating pg placement.
> - `crush_rule`: rule number for mapping placement.

Get the value of a pool setting.

```
ceph osd pool get {pool-name} {field}
```

Valid fields are:

> - `pg_num`: The placement group number.
> - `pgp_num`: Effective number of placement groups when calculating placement.

Sends a scrub command to OSD `{osd-num}`. To send the command to all OSDs, use `*`.

```
ceph osd scrub {osd-num}
```

Sends a repair command to OSD.N. To send the command to all OSDs, use `*`.

```
ceph osd repair N
```

Runs a simple throughput benchmark against OSD.N, writing `TOTAL_DATA_BYTES` in write requests of `BYTES_PER_WRITE` each. By default, the test writes 1 GB in total in 4-MB increments. The benchmark is non-destructive and will not overwrite existing live OSD data, but might temporarily affect the performance of clients concurrently accessing the OSD.

```
ceph tell osd.N bench [TOTAL_DATA_BYTES] [BYTES_PER_WRITE]
```

To clear an OSD’s caches between benchmark runs, use the ‘cache drop’ command

```
ceph tell osd.N cache drop
```

To get the cache statistics of an OSD, use the ‘cache status’ command

```
ceph tell osd.N cache status
```

## MDS Subsystem[](https://docs.ceph.com/en/latest/rados/operations/control/#mds-subsystem)

# CephFS Administrative commands[](https://docs.ceph.com/en/latest/cephfs/administration/#cephfs-administrative-commands)

## File Systems[](https://docs.ceph.com/en/latest/cephfs/administration/#file-systems)

Note

The names of the file systems, metadata pools, and data pools can only have characters in the set [a-zA-Z0-9_-.].

These commands operate on the CephFS file systems in your Ceph cluster. Note that by default only one file system is permitted: to enable creation of multiple file systems use `ceph fs flag set enable_multiple true`.

```
fs new <file system name> <metadata pool name> <data pool name>
```

This command creates a new file system. The file system name and metadata pool name are self-explanatory. The specified data pool is the default data pool and cannot be changed once set. Each file system has its own set of MDS daemons assigned to ranks so ensure that you have sufficient standby daemons available to accommodate the new file system.

```
fs ls
```

List all file systems by name.

```
fs lsflags <file system name>
```

List all the flags set on a file system.

```
fs dump [epoch]
```

This dumps the FSMap at the given epoch (default: current) which includes all file system settings, MDS daemons and the ranks they hold, and the list of standby MDS daemons.

```
fs rm <file system name> [--yes-i-really-mean-it]
```

Destroy a CephFS file system. This wipes information about the state of the file system from the FSMap. The metadata pool and data pools are untouched and must be destroyed separately.

```
fs get <file system name>
```

Get information about the named file system, including settings and ranks. This is a subset of the same information from the `fs dump` command.

```
fs set <file system name> <var> <val>
```

Change a setting on a file system. These settings are specific to the named file system and do not affect other file systems.

```
fs add_data_pool <file system name> <pool name/id>
```

Add a data pool to the file system. This pool can be used for file layouts as an alternate location to store file data.

```
fs rm_data_pool <file system name> <pool name/id>
```

This command removes the specified pool from the list of data pools for the file system.  If any files have layouts for the removed data pool, the file data will become unavailable. The default data pool (when creating the file system) cannot be removed.

```
fs rename <file system name> <new file system name> [--yes-i-really-mean-it]
```

Rename a Ceph file system. This also changes the application tags on the data pools and metadata pool of the file system to the new file system name. The CephX IDs authorized to the old file system name need to be reauthorized to the new name. Any on-going operations of the clients using these IDs may be disrupted. Mirroring is expected to be disabled on the file system.

## Settings[](https://docs.ceph.com/en/latest/cephfs/administration/#settings)

```
fs set <fs name> max_file_size <size in bytes>
```

CephFS has a configurable maximum file size, and it’s 1TB by default. You may wish to set this limit higher if you expect to store large files in CephFS. It is a 64-bit field.

Setting `max_file_size` to 0 does not disable the limit. It would simply limit clients to only creating empty files.

## Maximum file sizes and performance[](https://docs.ceph.com/en/latest/cephfs/administration/#maximum-file-sizes-and-performance)

CephFS enforces the maximum file size limit at the point of appending to files or setting their size. It does not affect how anything is stored.

When users create a file of an enormous size (without necessarily writing any data to it), some operations (such as deletes) cause the MDS to have to do a large number of operations to check if any of the RADOS objects within the range that could exist (according to the file size) really existed.

The `max_file_size` setting prevents users from creating files that appear to be eg. exabytes in size, causing load on the MDS as it tries to enumerate the objects during operations like stats or deletes.

## Taking the cluster down[](https://docs.ceph.com/en/latest/cephfs/administration/#taking-the-cluster-down)

Taking a CephFS cluster down is done by setting the down flag:

```
fs set <fs_name> down true
```

To bring the cluster back online:

```
fs set <fs_name> down false
```

This will also restore the previous value of max_mds. MDS daemons are brought down in a way such that journals are flushed to the metadata pool and all client I/O is stopped.

## Taking the cluster down rapidly for deletion or disaster recovery[](https://docs.ceph.com/en/latest/cephfs/administration/#taking-the-cluster-down-rapidly-for-deletion-or-disaster-recovery)

To allow rapidly deleting a file system (for testing) or to quickly bring the file system and MDS daemons down, use the `fs fail` command:

```
fs fail <fs_name>
```

This command sets a file system flag to prevent standbys from activating on the file system (the `joinable` flag).

This process can also be done manually by doing the following:

```
fs set <fs_name> joinable false
```

Then the operator can fail all of the ranks which causes the MDS daemons to respawn as standbys. The file system will be left in a degraded state.

```
# For all ranks, 0-N:
mds fail <fs_name>:<n>
```

Once all ranks are inactive, the file system may also be deleted or left in this state for other purposes (perhaps disaster recovery).

To bring the cluster back up, simply set the joinable flag:

```
fs set <fs_name> joinable true
```

## Daemons[](https://docs.ceph.com/en/latest/cephfs/administration/#daemons)

Most commands manipulating MDSs take a `<role>` argument which can take one of three forms:

```
<fs_name>:<rank>
<fs_id>:<rank>
<rank>
```

Commands to manipulate MDS daemons:

```
mds fail <gid/name/role>
```

Mark an MDS daemon as failed.  This is equivalent to what the cluster would do if an MDS daemon had failed to send a message to the mon for `mds_beacon_grace` second.  If the daemon was active and a suitable standby is available, using `mds fail` will force a failover to the standby.

If the MDS daemon was in reality still running, then using `mds fail` will cause the daemon to restart.  If it was active and a standby was available, then the “failed” daemon will return as a standby.

```
tell mds.<daemon name> command ...
```

Send a command to the MDS daemon(s). Use `mds.*` to send a command to all daemons. Use `ceph tell mds.* help` to learn available commands.

```
mds metadata <gid/name/role>
```

Get metadata about the given MDS known to the Monitors.

```
mds repaired <role>
```

Mark the file system rank as repaired. Unlike the name suggests, this command does not change a MDS; it manipulates the file system rank which has been marked damaged.

## Required Client Features[](https://docs.ceph.com/en/latest/cephfs/administration/#required-client-features)

It is sometimes desirable to set features that clients must support to talk to CephFS. Clients without those features may disrupt other clients or behave in surprising ways. Or, you may want to require newer features to prevent older and possibly buggy clients from connecting.

Commands to manipulate required client features of a file system:

```
fs required_client_features <fs name> add reply_encoding
fs required_client_features <fs name> rm reply_encoding
```

To list all CephFS features

```
fs feature ls
```

Clients that are missing newly added features will be evicted automatically.

Here are the current CephFS features and first release they came out:

| Feature          | Ceph release | Upstream Kernel |
| ---------------- | ------------ | --------------- |
| jewel            | jewel        | 4.5             |
| kraken           | kraken       | 4.13            |
| luminous         | luminous     | 4.13            |
| mimic            | mimic        | 4.19            |
| reply_encoding   | nautilus     | 5.1             |
| reclaim_client   | nautilus     | N/A             |
| lazy_caps_wanted | nautilus     | 5.1             |
| multi_reconnect  | nautilus     | 5.1             |
| deleg_ino        | octopus      | 5.6             |
| metric_collect   | pacific      | N/A             |
| alternate_name   | pacific      | PLANNED         |

CephFS Feature Descriptions

```
reply_encoding
```

MDS encodes request reply in extensible format if client supports this feature.

```
reclaim_client
```

MDS allows new client to reclaim another (dead) client’s states. This feature is used by NFS-Ganesha.

```
lazy_caps_wanted
```

When a stale client resumes, if the client supports this feature, mds only needs to re-issue caps that are explicitly wanted.

```
multi_reconnect
```

When mds failover, client sends reconnect messages to mds, to reestablish cache states. If MDS supports this feature, client can split large reconnect message into multiple ones.

```
deleg_ino
```

MDS delegate inode numbers to client if client supports this feature. Having delegated inode numbers is a prerequisite for client to do async file creation.

```
metric_collect
```

Clients can send performance metric to MDS if MDS support this feature.

```
alternate_name
```

Clients can set and understand “alternate names” for directory entries. This is to be used for encrypted file name support.

## Global settings[](https://docs.ceph.com/en/latest/cephfs/administration/#global-settings)

```
fs flag set <flag name> <flag val> [<confirmation string>]
```

Sets a global CephFS flag (i.e. not specific to a particular file system). Currently, the only flag setting is ‘enable_multiple’ which allows having multiple CephFS file systems.

Some flags require you to confirm your intentions with “--yes-i-really-mean-it” or a similar string they will prompt you with. Consider these actions carefully before proceeding; they are placed on especially dangerous activities.



## Advanced[](https://docs.ceph.com/en/latest/cephfs/administration/#advanced)

These commands are not required in normal operation, and exist for use in exceptional circumstances.  Incorrect use of these commands may cause serious problems, such as an inaccessible file system.

```
mds rmfailed
```

This removes a rank from the failed set.

```
fs reset <file system name>
```

This command resets the file system state to defaults, except for the name and pools. Non-zero ranks are saved in the stopped set.

```
fs new <file system name> <metadata pool name> <data pool name> --fscid <fscid> --force
```

This command creates a file system with a specific **fscid** (file system cluster ID). You may want to do this when an application expects the file system’s ID to be stable after it has been recovered, e.g., after monitor databases are lost and rebuilt. Consequently, file system IDs don’t always keep increasing with newer file systems.

Change configuration parameters on a running mds.

```
ceph tell mds.{mds-id} config set {setting} {value}
```

Example:

```
ceph tell mds.0 config set debug_ms 1
```

Enables debug messages.

```
ceph mds stat
```

Displays the status of all metadata servers.

```
ceph mds fail 0
```

Marks the active MDS as failed, triggering failover to a standby if present.

Todo

`ceph mds` subcommands missing docs: set, dump, getmap, stop, setmap

## Mon Subsystem[](https://docs.ceph.com/en/latest/rados/operations/control/#mon-subsystem)

Show monitor stats:

```
ceph mon stat

e2: 3 mons at {a=127.0.0.1:40000/0,b=127.0.0.1:40001/0,c=127.0.0.1:40002/0}, election epoch 6, quorum 0,1,2 a,b,c
```

The `quorum` list at the end lists monitor nodes that are part of the current quorum.

This is also available more directly:

```
ceph quorum_status -f json-pretty
{
    "election_epoch": 6,
    "quorum": [
        0,
        1,
        2
    ],
    "quorum_names": [
        "a",
        "b",
        "c"
    ],
    "quorum_leader_name": "a",
    "monmap": {
        "epoch": 2,
        "fsid": "ba807e74-b64f-4b72-b43f-597dfe60ddbc",
        "modified": "2016-12-26 14:42:09.288066",
        "created": "2016-12-26 14:42:03.573585",
        "features": {
            "persistent": [
                "kraken"
            ],
            "optional": []
        },
        "mons": [
            {
                "rank": 0,
                "name": "a",
                "addr": "127.0.0.1:40000\/0",
                "public_addr": "127.0.0.1:40000\/0"
            },
            {
                "rank": 1,
                "name": "b",
                "addr": "127.0.0.1:40001\/0",
                "public_addr": "127.0.0.1:40001\/0"
            },
            {
                "rank": 2,
                "name": "c",
                "addr": "127.0.0.1:40002\/0",
                "public_addr": "127.0.0.1:40002\/0"
            }
        ]
    }
}
```

The above will block until a quorum is reached.

For a status of just a single monitor:

```
ceph tell mon.[name] mon_status
```

where the value of `[name]` can be taken from `ceph quorum_status`. Sample output:

```
{
    "name": "b",
    "rank": 1,
    "state": "peon",
    "election_epoch": 6,
    "quorum": [
        0,
        1,
        2
    ],
    "features": {
        "required_con": "9025616074522624",
        "required_mon": [
            "kraken"
        ],
        "quorum_con": "1152921504336314367",
        "quorum_mon": [
            "kraken"
        ]
    },
    "outside_quorum": [],
    "extra_probe_peers": [],
    "sync_provider": [],
    "monmap": {
        "epoch": 2,
        "fsid": "ba807e74-b64f-4b72-b43f-597dfe60ddbc",
        "modified": "2016-12-26 14:42:09.288066",
        "created": "2016-12-26 14:42:03.573585",
        "features": {
            "persistent": [
                "kraken"
            ],
            "optional": []
        },
        "mons": [
            {
                "rank": 0,
                "name": "a",
                "addr": "127.0.0.1:40000\/0",
                "public_addr": "127.0.0.1:40000\/0"
            },
            {
                "rank": 1,
                "name": "b",
                "addr": "127.0.0.1:40001\/0",
                "public_addr": "127.0.0.1:40001\/0"
            },
            {
                "rank": 2,
                "name": "c",
                "addr": "127.0.0.1:40002\/0",
                "public_addr": "127.0.0.1:40002\/0"
            }
        ]
    }
}
```

A dump of the monitor state:

```
ceph mon dump

dumped monmap epoch 2
epoch 2
fsid ba807e74-b64f-4b72-b43f-597dfe60ddbc
last_changed 2016-12-26 14:42:09.288066
created 2016-12-26 14:42:03.573585
0: 127.0.0.1:40000/0 mon.a
1: 127.0.0.1:40001/0 mon.b
2: 127.0.0.1:40002/0 mon.c
```