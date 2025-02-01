# ceph-fuse -- FUSE-based client for ceph[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#ceph-fuse-fuse-based-client-for-ceph)

## Synopsis[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#synopsis)

**ceph-fuse** [-n *client.username*] [ -m *monaddr*:*port* ] *mountpoint* [ *fuse options* ]

## Description[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#description)

**ceph-fuse** is a FUSE (“Filesystem in USErspace”) client for Ceph distributed file system. It will mount a ceph file system specified via the -m option or described by ceph.conf (see below) at the specific mount point. See [Mount CephFS using FUSE](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/) for detailed information.

The file system can be unmounted with:

```
fusermount -u mountpoint
```

or by sending `SIGINT` to the `ceph-fuse` process.

## Options[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#options)

Any options not recognized by ceph-fuse will be passed on to libfuse.

- -o opt,[opt...][](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-o)

  Mount options.

- -c ceph.conf, --conf=ceph.conf[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-c)

  Use *ceph.conf* configuration file instead of the default `/etc/ceph/ceph.conf` to determine monitor addresses during startup.

- -m monaddress[:port][](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-m)

  Connect to specified monitor (instead of looking through ceph.conf).

- -n client.{cephx-username}[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-n)

  Pass the name of CephX user whose secret key is be to used for mounting.

- --id <client-id>[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-id)

  Pass the name of CephX user whose secret key is be to used for mounting. `--id` takes just the ID of the client in contrast to `-n`. For example, `--id 0` for using `client.0`.

- -k <path-to-keyring>[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-k)

  Provide path to keyring; useful when it’s absent in standard locations.

- --client_mountpoint/-r root_directory[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-client_mountpoint-r)

  Use root_directory as the mounted root, rather than the full Ceph tree.

- -f[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-f)

  Foreground: do not daemonize after startup (run in foreground). Do not generate a pid file.

- -d[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-d)

  Run in foreground, send all log output to stderr and enable FUSE debugging (-o debug).

- -s[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-s)

  Disable multi-threaded operation.

- --client_fs[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#cmdoption-ceph-fuse-client_fs)

  Pass the name of Ceph FS to be mounted. Not passing this option mounts the default Ceph FS on the Ceph cluster.

## Availability[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#availability)

**ceph-fuse** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

## See also[](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#see-also)

fusermount(8), [ceph](https://docs.ceph.com/en/latest/man/8/ceph/)(8)