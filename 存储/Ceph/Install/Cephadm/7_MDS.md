# MDS Service



## Deploy CephFS

One or more MDS daemons is required to use the [CephFS](https://docs.ceph.com/en/latest/glossary/#term-CephFS) file system. These are created automatically if the newer `ceph fs volume` interface is used to create a new file system. For more information, see [FS volumes and subvolumes](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-volumes-and-subvolumes).

For example:

```
ceph fs volume create <fs_name> --placement="<placement spec>"
```

where `fs_name` is the name of the CephFS and `placement` is a [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec).

For manually deploying MDS daemons, use this specification:

```
service_type: mds
service_id: fs_name
placement:
  count: 3
```

The specification can then be applied using:

```
ceph orch apply -i mds.yaml
```

See [Stateless services (MDS/RGW/NFS/rbd-mirror/iSCSI)](https://docs.ceph.com/en/latest/mgr/orchestrator/#orchestrator-cli-stateless-services) for manually deploying MDS daemons on the CLI.