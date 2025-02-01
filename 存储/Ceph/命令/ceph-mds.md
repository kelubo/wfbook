# ceph-mds

[TOC]

## 概述

ceph metadata server daemon

## Synopsis

**ceph-mds** -i <*ID*> [flags]

## Description

**ceph-mds** is the metadata server daemon for the Ceph distributed file system. One or more instances of ceph-mds collectively manage the file system namespace, coordinating access to the shared OSD cluster.

Each ceph-mds daemon instance should have a unique name. The name is used to identify daemon instances in the ceph.conf.

Once the daemon has started, the monitor cluster will normally assign it a logical rank, or put it in a standby pool to take over for another daemon that crashes. Some of the specified options can cause other behaviors.

## Options

- -f, --foreground[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-f)

  Foreground: do not daemonize after startup (run in foreground). Do not generate a pid file. Useful when run via [ceph-run](https://docs.ceph.com/en/latest/man/8/ceph-run/)(8).

- -d[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-d)

  Debug mode: like `-f`, but also send all log output to stderr.

- --setuser userorgid[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-setuser)

  Set uid after starting.  If a username is specified, the user record is looked up to get a uid and a gid, and the gid is also set as well, unless --setgroup is also specified.

- --setgroup grouporgid[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-setgroup)

  Set gid after starting.  If a group name is specified the group record is looked up to get a gid.

- -c ceph.conf, --conf=ceph.conf[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-c)

  Use *ceph.conf* configuration file instead of the default `/etc/ceph/ceph.conf` to determine monitor addresses during startup.

- -m monaddress[:port][](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-m)

  Connect to specified monitor (instead of looking through `ceph.conf`).

- --id/-i ID[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-id-i)

  Set ID portion of the MDS name. The ID should not start with a numeric digit.

- --name/-n TYPE.ID[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-name-n)

  Set the MDS name of the format TYPE.ID. The TYPE is obviously ‘mds’. The ID should not start with a numeric digit.

## Availability

**ceph-mds** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

​        