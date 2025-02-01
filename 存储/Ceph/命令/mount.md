# mount.ceph -- mount a Ceph file system[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#mount-ceph-mount-a-ceph-file-system)

## Synopsis[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#synopsis)

**mount.ceph** *name\*@*fsid*.*fs_name*=/[*subdir*] *dir* [-o *options* ]

## Description[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#description)

**mount.ceph** is a helper for mounting the Ceph file system on a Linux host. It serves to resolve monitor hostname(s) into IP addresses and read authentication keys from disk; the Linux kernel client component does most of the real work. To mount a Ceph file system use:

```
mount.ceph name@07fe3187-00d9-42a3-814b-72a4d5e7d5be.fs_name=/ /mnt/mycephfs -o mon_addr=1.2.3.4
```

where “name” is the RADOS client name (referred to hereafter as “RADOS user”, and meaning any individual or system actor such as an application).

Mount helper can fill in the cluster FSID by reading the ceph configuration file. Its recommended to call the mount helper via mount(8) as per:

```
mount -t ceph name@.fs_name=/ /mnt/mycephfs -o mon_addr=1.2.3.4
```

Note that the dot `.` still needs to be a part of the device string in this case.

The first argument is the device part of the mount command. It includes the RADOS user for authentication, the file system name and a path within CephFS that will be mounted at the mount point.

Monitor addresses can be passed using `mon_addr` mount option. Multiple monitor addresses can be passed by separating addresses with a slash (/). Only one monitor is needed to mount successfully; the client will learn about all monitors from any responsive monitor. However, it is a good idea to specify more than one in case the one happens to be down at the time of mount. Monitor addresses takes the form ip_address[:port]. If the port is not specified, the Ceph default of 6789 is assumed.

If monitor addresses are not specified, then **mount.ceph** will attempt to determine monitor addresses using local configuration files and/or DNS SRV records. In similar way, if authentication is enabled on Ceph cluster (which is done using CephX) and options `secret` and `secretfile` are not specified in the command, the mount helper will spawn a child process that will use the standard Ceph library routines to find a keyring and fetch the secret from it (including the monitor address and FSID if those not specified).

A sub-directory of the file system can be mounted by specifying the (absolute) path to the sub-directory right after “=” in the device part of the mount command.

Mount helper application conventions dictate that the first two options are device to be mounted and the mountpoint for that device. Options must be passed only after these fixed arguments.

## Options[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#options)

### Basic[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#basic)

- **conf**

  Path to a ceph.conf file. This is used to initialize the Ceph context for autodiscovery of monitor addresses and auth secrets. The default is to use the standard search path for ceph.conf files.

- **mount_timeout**

  int (seconds), Default: 60

- **ms_mode=<legacy|crc|secure|prefer-crc|prefer-secure>**

  Set the connection mode that the client uses for transport. The available modes are: `legacy`: use messenger v1 protocol to talk to the cluster `crc`: use messenger v2, without on-the-wire encryption `secure`: use messenger v2, with on-the-wire encryption `prefer-crc`: crc mode, if denied agree to secure mode `prefer-secure`: secure mode, if denied agree to crc mode

- **mon_addr**

  Monitor address of the cluster in the form of ip_address[:port]

- **fsid**

  Cluster FSID. This can be found using ceph fsid command.

- **secret**

  secret key for use with CephX. This option is insecure because it exposes the secret on the command line. To avoid this, use the secretfile option.

- **secretfile**

  path to file containing the secret key to use with CephX

- **recover_session=<no|clean>**

  Set auto reconnect mode in the case where the client is blocklisted. The available modes are `no` and `clean`. The default is `no`. `no`: never attempt to reconnect when client detects that it has been blocklisted. Blocklisted clients will not attempt to reconnect and their operations will fail too. `clean`: client reconnects to the Ceph cluster automatically when it detects that it has been blocklisted. During reconnect, client drops dirty data/metadata, invalidates page caches and writable file handles. After reconnect, file locks become stale because the MDS loses track of them. If an inode contains any stale file locks, read/write on the inode is not allowed until applications release all stale file locks.

- command

  fs=<fs-name> Specify the non-default file system to be mounted, when using the old syntax.

- command

  mds_namespace=<fs-name> A synonym of “fs=” (Deprecated).

### Advanced[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#advanced)

- **cap_release_safety**

  int, Default: calculated

- **caps_wanted_delay_max**

  int, cap release delay, Default: 60

- **caps_wanted_delay_min**

  int, cap release delay, Default: 5

- **dirstat**

  funky cat dirname for stats, Default: off

- **nodirstat**

  no funky cat dirname for stats

- **ip**

  my ip

- **noasyncreaddir**

  no dcache readdir

- **nocrc**

  no data crc on writes

- **noshare**

  create a new client instance, instead of sharing an existing instance of a client mounting the same cluster

- **osdkeepalive**

  int, Default: 5

- **osd_idle_ttl**

  int (seconds), Default: 60

- **rasize**

  int (bytes), max readahead. Default: 8388608 (8192*1024)

- **rbytes**

  Report the recursive size of the directory contents for st_size on directories.  Default: off

- **norbytes**

  Do not report the recursive size of the directory contents for st_size on directories.

- **readdir_max_bytes**

  int, Default: 524288 (512*1024)

- **readdir_max_entries**

  int, Default: 1024

- **rsize**

  int (bytes), max read size. Default: 16777216 (16*1024*1024)

- **snapdirname**

  string, set the name of the hidden snapdir. Default: .snap

- **write_congestion_kb**

  int (kb), max writeback in flight. scale with available memory. Default: calculated from available memory

- **wsize**

  int (bytes), max write size. Default: 16777216 (16*1024*1024) (writeback uses smaller of wsize and stripe unit)

- **wsync**

  Execute all namespace operations synchronously. This ensures that the namespace operation will only complete after receiving a reply from the MDS. This is the default.

- **nowsync**

  Allow the client to do namespace operations asynchronously. When this option is enabled, a namespace operation may complete before the MDS replies, if it has sufficient capabilities to do so.

## Examples[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#examples)

Mount the full file system:

```
mount -t ceph fs_user@.mycephfs2=/ /mnt/mycephfs
```

Mount only part of the namespace/file system:

```
mount.ceph fs_user@.mycephfs2=/some/directory/in/cephfs /mnt/mycephfs
```

Pass the monitor host’s IP address, optionally:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs -o mon_addr=192.168.0.1
```

Pass the port along with IP address if it’s running on a non-standard port:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs -o mon_addr=192.168.0.1:7000
```

If there are multiple monitors, pass each address separated by a /:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs -o mon_addr=192.168.0.1/192.168.0.2/192.168.0.3
```

Pass secret key for CephX user optionally:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

Pass file containing secret key to avoid leaving secret key in shell’s command history:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs -o secretfile=/etc/ceph/fs_username.secret
```

If authentication is disabled on Ceph cluster, omit the credential related option:

```
mount.ceph fs_user@.mycephfs2=/ /mnt/mycephfs
```

To mount using the old syntax:

```
mount -t ceph 192.168.0.1:/ /mnt/mycephfs
```

## Availability[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#availability)

**mount.ceph** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

## Feature Availability[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#feature-availability)

The `recover_session=` option was added to mainline Linux kernels in v5.4. `wsync` and `nowsync` were added in v5.7.

## See also[](https://docs.ceph.com/en/latest/man/8/mount.ceph/#see-also)

[ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/)(8), [ceph](https://docs.ceph.com/en/latest/man/8/ceph/)(8)

# mount.fuse.ceph -- mount ceph-fuse from /etc/fstab.[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#mount-fuse-ceph-mount-ceph-fuse-from-etc-fstab)

## Synopsis[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#synopsis)

**mount.fuse.ceph** [-h] [-o OPTIONS [*OPTIONS* …]] device [*device* …] mountpoint [*mountpoint* …]

## Description[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#description)

**mount.fuse.ceph** is a helper for mounting ceph-fuse from `/etc/fstab`.

To use mount.fuse.ceph, add an entry in `/etc/fstab` like:

```
DEVICE    PATH        TYPE        OPTIONS
none      /mnt/ceph   fuse.ceph   ceph.id=admin,_netdev,defaults  0 0
none      /mnt/ceph   fuse.ceph   ceph.name=client.admin,_netdev,defaults  0 0
none      /mnt/ceph   fuse.ceph   ceph.id=myuser,ceph.conf=/etc/ceph/foo.conf,_netdev,defaults  0 0
```

ceph-fuse options are specified in the `OPTIONS` column and must begin with ‘`ceph.`’ prefix. This way ceph related fs options will be passed to ceph-fuse and others will be ignored by ceph-fuse.

## Options[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#options)

- ceph.id=<username>[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#cmdoption-mount.fuse.ceph-arg-ceph.id)

  Specify that the ceph-fuse will authenticate as the given user.

- ceph.name=client.admin[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#cmdoption-mount.fuse.ceph-arg-ceph.name)

  Specify that the ceph-fuse will authenticate as client.admin

- ceph.conf=/etc/ceph/foo.conf[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#cmdoption-mount.fuse.ceph-arg-ceph.conf)

  Sets ‘conf’ option to /etc/ceph/foo.conf via ceph-fuse command line.

Any valid ceph-fuse options can be passed this way.

## Additional Info[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#additional-info)

The old format /etc/fstab entries are also supported:

```
DEVICE                              PATH        TYPE        OPTIONS
id=admin                            /mnt/ceph   fuse.ceph   defaults   0 0
id=myuser,conf=/etc/ceph/foo.conf   /mnt/ceph   fuse.ceph   defaults   0 0
```

## Availability[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#availability)

**mount.fuse.ceph** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

## See also[](https://docs.ceph.com/en/latest/man/8/mount.fuse.ceph/#see-also)

[ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/)(8), [ceph](https://docs.ceph.com/en/latest/man/8/ceph/)(8)