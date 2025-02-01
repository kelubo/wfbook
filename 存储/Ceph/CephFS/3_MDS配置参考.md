# MDS 配置参考

[TOC]

- mds_cache_mid

  The insertion point for new items in the cache LRU (from the top). type `float` default `0.7`

- mds_dir_max_commit_size

  The maximum size of a directory update before Ceph breaks it into smaller transactions (MB). type `int` default `10`

- mds_dir_max_entries

  The maximum number of entries before any new entries are rejected with ENOSPC. type `uint` default `0`

- mds_decay_halflife[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_decay_halflife)

  rate of decay for temperature counters on each directory for balancing type `float` default `5.0`

- mds_beacon_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_beacon_interval)

  interval in seconds between MDS beacon messages sent to monitors type `float` default `4.0`

- mds_beacon_grace[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_beacon_grace)

  The interval without beacons before Ceph declares an MDS laggy (and possibly replace it). type `float` default `15.0`

- mon_mds_blocklist_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mon_mds_blocklist_interval)

  The blocklist duration for failed MDSs in the OSD map. Note, this controls how long failed MDS daemons will stay in the OSDMap blocklist. It has no effect on how long something is blocklisted when the administrator blocklists it manually. For example, `ceph osd blocklist add` will still use the default blocklist time. type `float` default `1 day` min `1_hr`

- mds_reconnect_timeout[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_reconnect_timeout)

  timeout in seconds to wait for clients to reconnect during MDS reconnect recovery state type `float` default `45.0`

- mds_tick_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_tick_interval)

  How frequently the MDS performs internal periodic tasks. type `float` default `5.0`

- mds_dirstat_min_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dirstat_min_interval)

  The minimum interval (in seconds) to try to avoid propagating recursive stats up the tree. type `float` default `1.0`

- mds_scatter_nudge_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_scatter_nudge_interval)

  How quickly dirstat changes propagate up. type `float` default `5.0`

- mds_client_prealloc_inos[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_client_prealloc_inos)

  The number of inode numbers to preallocate per client session. type `int` default `1000`

- mds_early_reply[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_early_reply)

  Determines whether the MDS should allow clients to see request results before they commit to the journal. type `bool` default `true`

- mds_default_dir_hash[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_default_dir_hash)

  The function to use for hashing files across directory fragments. type `int` default `2`

- mds_log_skip_corrupt_events[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_skip_corrupt_events)

  Determines whether the MDS should try to skip corrupt journal events during journal replay. type `bool` default `false`

- mds_log_max_events[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_max_events)

  The maximum events in the journal before we initiate trimming. Set to `-1` to disable limits. type `int` default `-1`

- mds_log_max_segments[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_max_segments)

  The maximum number of segments (objects) in the journal before we initiate trimming. Set to `-1` to disable limits. type `uint` default `128`

- mds_bal_sample_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_sample_interval)

  Determines how frequently to sample directory temperature (for fragmentation decisions). type `float` default `3.0`

- mds_bal_replicate_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_replicate_threshold)

  The maximum temperature before Ceph attempts to replicate metadata to other nodes. type `float` default `8000.0`

- mds_bal_unreplicate_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_unreplicate_threshold)

  The minimum temperature before Ceph stops replicating metadata to other nodes. type `float` default `0.0`

- mds_bal_split_size[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_size)

  The maximum directory size before the MDS will split a directory fragment into smaller bits. type `int` default `10000`

- mds_bal_split_rd[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_rd)

  The maximum directory read temperature before Ceph splits a directory fragment. type `float` default `25000.0`

- mds_bal_split_wr[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_wr)

  The maximum directory write temperature before Ceph splits a directory fragment. type `float` default `10000.0`

- mds_bal_split_bits[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_bits)

  The number of bits by which to split a directory fragment. type `int` default `3` allowed range `[1, 24]`

- mds_bal_merge_size[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_merge_size)

  The minimum directory size before Ceph tries to merge adjacent directory fragments. type `int` default `50`

- mds_bal_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_interval)

  The frequency (in seconds) of workload exchanges between MDSs. type `int` default `10`

- mds_bal_fragment_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_interval)

  The delay (in seconds) between a fragment being eligible for split or merge and executing the fragmentation change. type `int` default `5`

- mds_bal_fragment_fast_factor[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_fast_factor)

  The ratio by which frags may exceed the split size before a split is executed immediately (skipping the fragment interval) type `float` default `1.5`

- mds_bal_fragment_size_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_size_max)

  The maximum size of a fragment before any new entries are rejected with ENOSPC. type `int` default `100000`

- mds_bal_idle_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_idle_threshold)

  The minimum temperature before Ceph migrates a subtree back to its parent. type `float` default `0.0`

- mds_bal_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_max)

  The number of iterations to run balancer before Ceph stops. (used for testing purposes only) type `int` default `-1`

- mds_bal_max_until[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_max_until)

  The number of seconds to run balancer before Ceph stops. (used for testing purposes only) type `int` default `-1`

- mds_bal_mode[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_mode)

  The method for calculating MDS load.  `0` = Hybrid. `1` = Request rate and latency. `2` = CPU load.  type `int` default `0`

- mds_bal_min_rebalance[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_min_rebalance)

  The minimum subtree temperature before Ceph migrates. type `float` default `0.1`

- mds_bal_min_start[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_min_start)

  The minimum subtree temperature before Ceph searches a subtree. type `float` default `0.2`

- mds_bal_need_min[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_need_min)

  The minimum fraction of target subtree size to accept. type `float` default `0.8`

- mds_bal_need_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_need_max)

  The maximum fraction of target subtree size to accept. type `float` default `1.2`

- mds_bal_midchunk[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_midchunk)

  Ceph will migrate any subtree that is larger than this fraction of the target subtree size. type `float` default `0.3`

- mds_bal_minchunk[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_minchunk)

  Ceph will ignore any subtree that is smaller than this fraction of the target subtree size. type `float` default `0.001`

- mds_replay_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_replay_interval)

  The journal poll interval when in standby-replay mode. (“hot standby”) type `float` default `1.0`

- mds_shutdown_check[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_shutdown_check)

  The interval for polling the cache during MDS shutdown. type `int` default `0`

- mds_thrash_exports[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_thrash_exports)

  Ceph will randomly export subtrees between nodes (testing only). type `int` default `0`

- mds_thrash_fragments[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_thrash_fragments)

  Ceph will randomly fragment or merge directories. type `int` default `0`

- mds_dump_cache_on_map[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dump_cache_on_map)

  Ceph will dump the MDS cache contents to a file on each MDSMap. type `bool` default `false`

- mds_dump_cache_after_rejoin[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dump_cache_after_rejoin)

  Ceph will dump MDS cache contents to a file after rejoining the cache (during recovery). type `bool` default `false`

- mds_verify_scatter[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_verify_scatter)

  Ceph will assert that various scatter/gather invariants are `true` (developers only). type `bool` default `false`

- mds_debug_scatterstat[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_scatterstat)

  Ceph will assert that various recursive stat invariants are `true` (for developers only). type `bool` default `false`

- mds_debug_frag[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_frag)

  Ceph will verify directory fragmentation invariants when convenient (developers only). type `bool` default `false`

- mds_debug_auth_pins[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_auth_pins)

  The debug auth pin invariants (for developers only). type `bool` default `false`

- mds_debug_subtrees[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_subtrees)

  The debug subtree invariants (for developers only). type `bool` default `false`

- mds_kill_mdstable_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_mdstable_at)

  Ceph will inject MDS failure in MDSTable code (for developers only). type `int` default `0`

- mds_kill_export_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_export_at)

  Ceph will inject MDS failure in the subtree export code (for developers only). type `int` default `0`

- mds_kill_import_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_import_at)

  Ceph will inject MDS failure in the subtree import code (for developers only). type `int` default `0`

- mds_kill_link_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_link_at)

  Ceph will inject MDS failure in hard link code (for developers only). type `int` default `0`

- mds_kill_rename_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_rename_at)

  Ceph will inject MDS failure in the rename code (for developers only). type `int` default `0`

- mds_wipe_sessions[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_wipe_sessions)

  Ceph will delete all client sessions on startup (for testing only). type `bool` default `false`

- mds_wipe_ino_prealloc[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_wipe_ino_prealloc)

  Ceph will delete ino preallocation metadata on startup (for testing only). type `bool` default `false`

- mds_skip_ino[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_skip_ino)

  The number of inode numbers to skip on startup (for testing only). type `int` default `0`

- mds_min_caps_per_client[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_min_caps_per_client)

  minimum number of capabilities a client may hold type `uint` default `100`

- mds_symlink_recovery[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_symlink_recovery)

  Stores symlink target on the first data object of symlink file. Allows recover of symlink using recovery tools. type `bool` default `true`