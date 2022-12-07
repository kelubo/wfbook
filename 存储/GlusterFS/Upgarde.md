# Upgrade-Guide Index

## Upgrading GlusterFS

- [About op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/)

If you are using GlusterFS version 6.x or above, you can upgrade it to the following:

- [Upgrading to 10](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-10/)
- [Upgrading to 9](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-9/)
- [Upgrading to 8](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-8/)
- [Upgrading to 7](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-7/)

If you are using GlusterFS version 5.x or above, you can upgrade it to the following:

- [Upgrading to 8](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-8/)
- [Upgrading to 7](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-7/)
- [Upgrading to 6](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-6/)

If you are using GlusterFS version 4.x or above, you can upgrade it to the following:

- [Upgrading to 6](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-6/)
- [Upgrading to 5](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-5/)

If you are using GlusterFS version 3.4.x or above, you can upgrade it to following:

- [Upgrading to 3.5](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.5/)
- [Upgrading to 3.6](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.6/)
- [Upgrading to 3.7](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.7/)
- [Upgrading to 3.9](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.9/)
- [Upgrading to 3.10](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.10/)
- [Upgrading to 3.11](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.11/)
- [Upgrading to 3.12](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.12/)
- [Upgrading to 3.13](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.13/)

# Op-version

### op-version

op-version is the operating version of the Gluster which is running.

op-version was introduced to ensure gluster running with different  versions do not end up in a problem and backward compatibility issues  can be tackled.

After Gluster upgrade, it is advisable to have op-version updated.

### Updating op-version

Current op-version can be queried as below:

For 3.10 onwards:

```

gluster volume get all cluster.op-version
```

For release < 3.10:

```console
# gluster volume get <VOLNAME> cluster.op-version
```

To get the maximum possible op-version a cluster can support, the  following query can be used (this is available 3.10 release onwards):

```

gluster volume get all cluster.max-op-version
```

For example, if some nodes in a cluster have been upgraded to X and  some to X+, then the maximum op-version supported by the cluster is X,  and the cluster.op-version can be bumped up to X to support new  features.

op-version can be updated as below. For example, after upgrading to glusterfs-4.0.0, set op-version as:

```

gluster volume set all cluster.op-version 40000
```

Note: This is not mandatory, but advisable to have updated op-version if you  want to make use of latest features in the updated gluster.

### Client op-version

When trying to set a volume option, it might happen that one or more  of the connected clients cannot support the feature being set and might  need to be upgraded to the op-version the cluster is currently running  on.

To check op-version information for the connected clients and find  the offending client, the following query can be used for 3.10 release  onwards:

```console
# gluster volume status <all|VOLNAME> clients
```

The respective clients can then be upgraded to the required version.

This information could also be used to make an informed decision  while bumping up the op-version of a cluster, so that connected clients  can support all the new features provided by the upgraded cluster as  well.

# Generic Upgrade procedure

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT:** If there are disperse or, pure distributed  volumes in the storage pool being upgraded, this procedure is NOT  recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/generic-upgrade-procedure/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to new-version :

1. Stop all gluster services, either using the command below, or through other means.

   ```
   
   ```

```
systemctl stop glusterd
systemctl stop glustereventsd
killall glusterfs glusterfsd glusterd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster new-version, below example shows how to create a repository on fedora and use it to upgrade :

3.1 Create a private repository (assuming /new-gluster-rpms/ folder has the new rpms ):

```

createrepo /new-gluster-rpms/
```

3.2 Create the .repo file in /etc/yum.d/ :

```

# cat /etc/yum.d/newglusterrepo.repo
 [newglusterrepo]
 name=NewGlusterRepo
 baseurl="file:///new-gluster-rpms/"
 gpgcheck=0
 enabled=1
```

3.3 Upgrade glusterfs, for example to upgrade glusterfs-server to x.y version :

```

yum update glusterfs-server-x.y.fc30.x86_64.rpm
```

Ensure that version reflects new-version in the output of,

```

gluster --version
```

Start glusterd on the upgraded server

```

systemctl start glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

systemctl start glustereventsd
```

Invoke self-heal on all the gluster volumes by running,

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Verify that there are no heal backlog by running the command for all the volumes,

```

```

1. ```
   gluster volume heal <volname> info
   ```

> **NOTE:** Before proceeding to upgrade the next server  in the pool it is recommended to check the heal backlog. If there is a  heal backlog, it is recommended to wait until the backlog is empty, or,  the backlog does not contain any entries requiring a sync to the just  upgraded server.

1. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
systemctl stop glusterd
systemctl stop glustereventsd
killall glusterfs glusterfsd glusterd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster new-version, on all servers

Ensure that version reflects new-version in the output of the following command on all servers,

```

gluster --version
```

Start glusterd on all the upgraded servers

```

systemctl start glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

```

1. ```
   systemctl start glustereventsd
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/generic-upgrade-procedure/#upgrade-procedure-for-clients) to new-version version as well
- Post upgrading the clients, for replicate volumes, it is recommended to enable the option `gluster volume set <volname> fips-mode-rchecksum on` to turn off usage of MD5 checksums during healing. This enables running Gluster on FIPS compliant systems.

#### If upgrading from a version lesser than Gluster 7.0

> **NOTE:** If you have ever enabled quota on your volumes then after the upgrade is done, you will have to restart all the nodes in the cluster one by one so as to fix the checksum values in the quota.cksum file under the `/var/lib/glusterd/vols/<volname>/ directory.` The peers may go into `Peer rejected` state while doing so but once all the nodes are rebooted everything will be back to normal.

### Upgrade procedure for clients

Following are the steps to upgrade clients to the new-version version,

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster new-version
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade procedure to Gluster 10, from Gluster 9.x, 8.x and 7.x

We recommend reading the [release notes for 10.0](https://docs.gluster.org/en/latest/release-notes/10.0/) to be aware of the features and fixes provided with the release.

> **NOTE:** Before following the generic upgrade procedure checkout the "**Major Issues**" section given below.

Refer, to the [generic upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/generic-upgrade-procedure/) guide and follow documented instructions.

## Major issues

### The following options are removed from the code base and require to be unset

before an upgrade from releases older than release 4.1.0,

```

- features.lock-heal
- features.grace-timeout
```

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

### Make sure you are not using any of the following depricated features :

```

- Block device (bd) xlator
- Decompounder feature
- Crypt xlator
- Symlink-cache xlator
- Stripe feature
- Tiering support (tier xlator and changetimerecorder)
- Glupy
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

### Deprecated translators and upgrade procedure for volumes using these features

[If you are upgrading from a release prior to release-6 be aware of deprecated xlators and functionality](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_6/#deprecated-translators-and-upgrade-procedure-for-volumes-using-these-features).

# Upgrade procedure to Gluster 9, from Gluster 8.x, 7.x and 6.x

We recommend reading the [release notes for 9.0](https://docs.gluster.org/en/latest/release-notes/9.0/) to be aware of the features and fixes provided with the release.

> **NOTE:** Before following the generic upgrade procedure checkout the "**Major Issues**" section given below.

Refer, to the [generic upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/generic-upgrade-procedure/) guide and follow documented instructions.

## Major issues

### The following options are removed from the code base and require to be unset

before an upgrade from releases older than release 4.1.0,

```

- features.lock-heal
- features.grace-timeout
```

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

### Make sure you are not using any of the following deprecated features :

```

- Block device (bd) xlator
- Decompounder feature
- Crypt xlator
- Symlink-cache xlator
- Stripe feature
- Tiering support (tier xlator and changetimerecorder)
- Glupy
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

### Deprecated translators and upgrade procedure for volumes using these features

[If you are upgrading from a release prior to release-6 be aware of deprecated xlators and functionality](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_6/#deprecated-translators-and-upgrade-procedure-for-volumes-using-these-features).

# Upgrade procedure to Gluster 8, from Gluster 7.x, 6.x and 5.x

We recommend reading the [release notes for 8.0](https://docs.gluster.org/en/latest/release-notes/8.0/) to be aware of the features and fixes provided with the release.

> **NOTE:** Before following the generic upgrade procedure checkout the "**Major Issues**" section given below.
>
> With version 8, there are certain changes introduced to the directory structure of changelog files in gluster geo-replication. Thus, before the upgrade of geo-rep packages, we need to execute the [upgrade script](https://github.com/gluster/glusterfs/commit/2857fe3fad4d2b30894847088a54b847b88a23b9) with the brick path as argument, as described below:
>
> 1. Stop the geo-rep session
> 2. Run the upgrade script with the brick path as the argument. Script can be used in loop for multiple bricks.
> 3. Start the upgradation process.    This script will update the existing changelog directory structure  and the paths inside the htime files to a new format introduced in  version 8.    If the above mentioned script is not executed, the search algorithm, used during the history crawl will fail with the wrong result for  upgradation from version 7 and below to version 8 and above.

Refer, to the [generic upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/generic-upgrade-procedure/) guide and follow documented instructions.

## Major issues

### The following options are removed from the code base and require to be unset

before an upgrade from releases older than release 4.1.0,

```

- features.lock-heal
- features.grace-timeout
```

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

### Make sure you are not using any of the following depricated features :

```

- Block device (bd) xlator
- Decompounder feature
- Crypt xlator
- Symlink-cache xlator
- Stripe feature
- Tiering support (tier xlator and changetimerecorder)
- Glupy
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

### Deprecated translators and upgrade procedure for volumes using these features

[If you are upgrading from a release prior to release-6 be aware of deprecated xlators and functionality](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_6/#deprecated-translators-and-upgrade-procedure-for-volumes-using-these-features).

# Upgrade to 7

## Upgrade procedure to Gluster 7, from Gluster 6.x, 5.x, 4.1.x, and 3.12.x

We recommend reading the [release notes for 7.0](https://docs.gluster.org/en/latest/release-notes/7.0/) to be aware of the features and fixes provided with the release.

> **NOTE:** Upgrade procedure remains the same as with 4.1.x release

Refer, to the [Upgrading to 4.1](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.1/) guide and follow documented instructions, replacing 7 when you encounter 4.1 in the guide as the version reference.

> **NOTE:** If you have ever enabled quota on your volumes then after the upgrade is done, you will have to restart all the nodes in the cluster one by one so as to fix the checksum values in the quota.cksum file under the `/var/lib/glusterd/vols/<volname>/ directory.` The peers may go into `Peer rejected` state while doing so but once all the nodes are rebooted everything will be back to normal.

### Major issues

1. The following options are removed from the code base and require to be unset    before an upgrade from releases older than release 4.1.0,
   - features.lock-heal
   - features.grace-timeout

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

### Deprecated translators and upgrade procedure for volumes using these features

[If you are upgrading from a release prior to release-6 be aware of deprecated xlators and functionality](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_6/#deprecated-translators-and-upgrade-procedure-for-volumes-using-these-features).

# Upgrade to 6

## Upgrade procedure to Gluster 6, from Gluster 5.x, 4.1.x, and 3.12.x

We recommend reading the [release notes for 6.0](https://docs.gluster.org/en/latest/release-notes/6.0/) to be aware of the features and fixes provided with the release.

> **NOTE:** Upgrade procedure remains the same as with 4.1.x release

Refer, to the [Upgrading to 4.1](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.1/) guide and follow documented instructions, replacing 6 when you encounter 4.1 in the guide as the version reference.

### Major issues

1. The following options are removed from the code base and require to be unset    before an upgrade from releases older than release 4.1.0,
   - features.lock-heal
   - features.grace-timeout

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

### Deprecated translators and upgrade procedure for volumes using these features

With this release of Gluster, the following xlator/features are deprecated and are not available in the distribution specific packages. If any of these xlators or features are in use, refer to instructions on steps needed pre-upgrade to plan for an upgrade to this release.

### Stripe volume

Stripe xlator, provided the ability to stripe data across bricks. This functionality was used to create and support files larger than a single brick and also to provide better disk utilization across large file IO, by spreading the IO blocks across bricks and hence physical disks.

This functionality is now provided by the [shard xlator](https://access.redhat.com/documentation/en-us/red_hat_gluster_storage/3.4/html/administration_guide/sect-creating_replicated_volumes#sect-Managing_Sharding).

There is no in place upgrade feasible for volumes using the stripe feature, and users are encouraged to migrate their data from existing stripe based volumes to sharded volumes.

#### Tier volume

Tier feature is no longer supported with this release. There is no replacement for the tiering feature as well.

Volumes using the existing Tier feature need to be converted to regular volumes before upgrading to this release.

Command reference:

```

volume tier <VOLNAME> detach <start|stop|status|commit|[force]>
```

### Other miscellaneous features

- BD xlator
- glupy

The above translators were not supported in previous versions as well, but users had an option to create volumes using these features. If such volumes were in use, data from the same need to me migrated into a new volume without the feature, before upgrading the clusters.

# Upgrade to 5

## Upgrade procedure to Gluster 5, from Gluster 4.1.x, 4.0.x, 3.12.x and 3.10.x

> **NOTE:** Upgrade procedure remains the same as with 4.1 release

Refer, to the [Upgrading to 4.1](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.1/) guide and follow documented instructions, replacing 5 when you encounter 4.1 in the guide as the version reference.

### Major issues

1. The following options are removed from the code base and require to be unset    before an upgrade from releases older than release 4.1.0,
   - features.lock-heal
   - features.grace-timeout

To check if these options are set use,

```

gluster volume info
```

and ensure that the above options are not part of the `Options Reconfigured:` section in the output of all volumes in the cluster.

If these are set, then unset them using the following commands,

```console
# gluster volume reset <volname> <option>
```

**NOTE:** Failure to do the above may result in failure during online upgrades, and the reset of these options to their defaults needs to be done **prior** to upgrading the cluster.

# Upgrade to 4.1

## Upgrade procedure to Gluster 4.1, from Gluster 4.0.x, 3.12.x, and 3.10.x

> **NOTE:** Upgrade procedure remains the same as with 3.12 and 3.10 releases

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT:** If there are disperse or, pure distributed  volumes in the storage pool being upgraded, this procedure is NOT  recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.1/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 4.1 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
systemctl stop glustereventsd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 4.1

Ensure that version reflects 4.1.x in the output of,

```

```

1. ```
   gluster --version
   ```

> **NOTE:** x is the minor release number for the release

1. Start glusterd on the upgraded server

   ```
   
   ```

```
glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

systemctl start glustereventsd
```

Invoke self-heal on all the gluster volumes by running,

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Verify that there are no heal backlog by running the command for all the volumes,

```

```

1. ```
   gluster volume heal <volname> info
   ```

> **NOTE:** Before proceeding to upgrade the next server  in the pool it is recommended to check the heal backlog. If there is a  heal backlog, it is recommended to wait until the backlog is empty, or,  the backlog does not contain any entries requiring a sync to the just  upgraded server.

1. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd glustereventsd
systemctl stop glustereventsd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 4.1, on all servers

Ensure that version reflects 4.1.x in the output of the following command on all servers,

```

gluster --version
```

> **NOTE:** x is the minor release number for the release

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

```

1. ```
   systemctl start glustereventsd
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.1/#upgrade-procedure-for-clients) to 4.1 version as well
- Post upgrading the clients, for replicate volumes, it is recommended to enable the option `gluster volume set <volname> fips-mode-rchecksum on` to turn off usage of MD5 checksums during healing. This enables running Gluster on FIPS compliant systems.

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 4.1.x version,

> **NOTE:** x is the minor release number for the release

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 4.1
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 4.0

## Upgrade procedure to Gluster 4.0, from Gluster 3.13.x, 3.12.x, and 3.10.x

**NOTE:** Upgrade procedure remains the same as with 3.12 and 3.10 releases

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT**: If any of your volumes, in the trusted  storage pool that is being upgraded, uses disperse or is a pure  distributed volume, this procedure is **NOT** recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.0/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 4.0 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 4.0

Ensure that version reflects 4.0.x in the output of,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

Self-heal all gluster volumes by running

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Ensure that there is no heal backlog by running the below command for all volumes

```

```

1. ```
   gluster volume heal <volname> info
   ```

   > NOTE: If there is a heal backlog, wait till the backlog is empty, or  the backlog does not have any entries needing a sync to the just  upgraded server, before proceeding to upgrade the next server in the  pool

2. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 4.0, on all servers

Ensure that version reflects 4.0.x in the output of the following command on all servers,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

```

1. ```
   gluster volume status
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-4.0/#upgrade-procedure-for-clients) to 4.0 version as well
- Post upgrading the clients, for replicate volumes, it is recommended to enable the option `gluster volume set <volname> fips-mode-rchecksum on` to turn off usage of MD5 checksums during healing. This enables running Gluster on FIPS compliant systems.

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 4.0.x version,

**NOTE:** x is the minor release number for the release

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 4.0
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 3.13

## Upgrade procedure to Gluster 3.13, from Gluster 3.12.x, and 3.10.x

**NOTE:** Upgrade procedure remains the same as with 3.12 and 3.10 releases

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT**: If any of your volumes, in the trusted  storage pool that is being upgraded, uses disperse or is a pure  distributed volume, this procedure is **NOT** recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.13/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 3.13 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 3.13

Ensure that version reflects 3.13.x in the output of,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

Self-heal all gluster volumes by running

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Ensure that there is no heal backlog by running the below command for all volumes

```

```

1. ```
   gluster volume heal <volname> info
   ```

   > NOTE: If there is a heal backlog, wait till the backlog is empty, or  the backlog does not have any entries needing a sync to the just  upgraded server, before proceeding to upgrade the next server in the  pool

2. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 3.13, on all servers

Ensure that version reflects 3.13.x in the output of the following command on all servers,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

```

1. ```
   gluster volume status
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.13/#upgrade-procedure-for-clients) to 3.13 version as well

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 3.13.x version,

**NOTE:** x is the minor release number for the release

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 3.13
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 3.12

## Upgrade procedure to Gluster 3.12, from Gluster 3.11.x, 3.10.x, and 3.8.x

> **NOTE:** Upgrade procedure remains the same as with 3.11 and 3.10 releases

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT:** If there are disperse or, pure distributed  volumes in the storage pool being upgraded, this procedure is NOT  recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.12/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 3.12 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
systemctl stop glustereventsd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 3.12

Ensure that version reflects 3.12.x in the output of,

```

gluster --version
```

> **NOTE:** x is the minor release number for the release

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

systemctl start glustereventsd
```

Invoke self-heal on all the gluster volumes by running,

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Verify that there are no heal backlog by running the command for all the volumes,

```

```

1. ```
   gluster volume heal <volname> info
   ```

   > **NOTE:** Before proceeding to upgrade the next server  in the pool it is recommended to check the heal backlog. If there is a  heal backlog, it is recommended to wait until the backlog is empty, or,  the backlog does not contain any entries requiring a sync to the just  upgraded server.

2. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd glustereventsd
systemctl stop glustereventsd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 3.12, on all servers

Ensure that version reflects 3.12.x in the output of the following command on all servers,

```

gluster --version
```

> **NOTE:** x is the minor release number for the release

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

If the glustereventsd service was previously enabled, it is required  to start it using the commands below, or, through other means,

```

```

1. ```
   systemctl start glustereventsd
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.12/#upgrade-procedure-for-clients) to 3.12 version as well

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 3.12.x version,

> **NOTE:** x is the minor release number for the release

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 3.12
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 3.11

## Upgrade procedure to Gluster 3.11, from Gluster 3.10.x, and 3.8.x

**NOTE:** Upgrade procedure remains the same as with the 3.10 release

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT**: If any of your volumes, in the trusted  storage pool that is being upgraded, uses disperse or is a pure  distributed volume, this procedure is **NOT** recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.11/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 3.11 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 3.11

Ensure that version reflects 3.11.x in the output of,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

Self-heal all gluster volumes by running

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Ensure that there is no heal backlog by running the below command for all volumes

```

```

1. ```
   gluster volume heal <volname> info
   ```

   > NOTE: If there is a heal backlog, wait till the backlog is empty, or  the backlog does not have any entries needing a sync to the just  upgraded server, before proceeding to upgrade the next server in the  pool

2. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 3.11, on all servers

Ensure that version reflects 3.11.x in the output of the following command on all servers,

```

gluster --version
```

**NOTE:** x is the minor release number for the release

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

```

1. ```
   gluster volume status
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.11/#upgrade-procedure-for-clients) to 3.11 version as well

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 3.11.x version,

**NOTE:** x is the minor release number for the release

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 3.11
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 3.10

## Upgrade procedure to Gluster 3.10.0, from Gluster 3.9.x, 3.8.x and 3.7.x

### Pre-upgrade notes

- Online upgrade is only possible with replicated and distributed replicate volumes
- Online upgrade is not supported for dispersed or distributed dispersed volumes
- Ensure no configuration changes are done during the upgrade
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master
- Upgrading the servers ahead of the clients is recommended
- It is recommended to have the same client and server, major versions running eventually

### Online upgrade procedure for servers

This procedure involves upgrading **one server at a time**, while keeping the volume(s) online and client IO ongoing. This  procedure assumes that multiple replicas of a replica set, are not part  of the same server in the trusted storage pool.

> **ALERT**: If any of your volumes, in the trusted  storage pool that is being upgraded, uses disperse or is a pure  distributed volume, this procedure is **NOT** recommended, use the [Offline upgrade procedure](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.10/#offline-upgrade-procedure) instead.

#### Repeat the following steps, on each server in the trusted storage pool, to upgrade the entire pool to 3.10 version:

1. Stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that run on this server and access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.)

Install Gluster 3.10

Ensure that version reflects 3.10.0 in the output of,

```

gluster --version
```

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

gluster volume status
```

Self-heal all gluster volumes by running

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Ensure that there is no heal backlog by running the below command for all volumes

```

```

1. ```
   gluster volume heal <volname> info
   ```

   > NOTE: If there is a heal backlog, wait till the backlog is empty, or  the backlog does not have any entries needing a sync to the just  upgraded server, before proceeding to upgrade the next server in the  pool

2. Restart any gfapi based application stopped previously in step (2)

### Offline upgrade procedure

This procedure involves cluster downtime and during the upgrade window, clients are not allowed access to the volumes.

#### Steps to perform an offline upgrade:

1. On every server in the trusted storage pool, stop all gluster services, either using the command below, or through other means,

   ```
   
   ```

```
killall glusterfs glusterfsd glusterd
```

Stop all applications that access the volumes via gfapi (qemu, NFS-Ganesha, Samba, etc.), across all servers

Install Gluster 3.10, on all servers

Ensure that version reflects 3.10.0 in the output of the following command on all servers,

```

gluster --version
```

Start glusterd on all the upgraded servers

```

glusterd
```

Ensure that all gluster processes are online by checking the output of,

```

```

1. ```
   gluster volume status
   ```

2. Restart any gfapi based application stopped previously in step (2)

### Post upgrade steps

Perform the following steps post upgrading the entire trusted storage pool,

- It is recommended to update the op-version of the cluster. Refer, to the [op-version](https://docs.gluster.org/en/latest/Upgrade-Guide/op-version/) section for further details
- Proceed to [upgrade the clients](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.10/#upgrade-procedure-for-clients) to 3.10 version as well

### Upgrade procedure for clients

Following are the steps to upgrade clients to the 3.10.0 version,

1. Unmount all glusterfs mount points on the client
2. Stop all applications that access the volumes via gfapi (qemu, etc.)
3. Install Gluster 3.10
4. Mount all gluster shares
5. Start any applications that were stopped previously in step (2)

# Upgrade to 3.9

## Upgrade procedure from Gluster 3.8.x and 3.7.x

The steps to uprade to Gluster 3.9 are the same as for upgrading to Gluster 3.8. Please follow the detailed instructions from [the 3.8 upgrade guide](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-3.8/).

Note that there is only a single difference, related to the `op-version`:

After the upgrade is complete on all servers, run the following command:

```

gluster volume set all cluster.op-version 30900
```

# Upgrade to 3.8

## Upgrade procedure from Gluster 3.7.x

### Pre-upgrade Notes

- Online upgrade is only possible with replicated and distributed replicate volumes.
- Online upgrade is not yet supported for dispersed or distributed dispersed volumes.
- Ensure no configuration changes are done during the upgrade.
- If you are using geo-replication, please upgrade the slave cluster(s) before upgrading the master.
- Upgrading the servers ahead of the clients is recommended.
- Upgrade the clients after the servers are upgraded. It is recommended to have the same client and server major versions.

### Online Upgrade Procedure for Servers

The procedure involves upgrading one server at a time . On every storage server in your trusted storage pool:

- Stop all gluster services using the below command or through your favorite way to stop them.

  ```
  
  ```

```
killall glusterfs glusterfsd glusterd
```

If you are using gfapi based applications (qemu, NFS-Ganesha, Samba etc.) on the servers, please stop those applications too.

Install Gluster 3.8

Ensure that version reflects 3.8.x in the output of

```

gluster --version
```

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by executing

```

gluster volume status
```

Self-heal all gluster volumes by running

```

for i in `gluster volume list`; do gluster volume heal $i; done
```

Ensure that there is no heal backlog by running the below command for all volumes

```

gluster volume heal <volname> info
```

Restart any gfapi based application stopped previously.

After the upgrade is complete on all servers, run the following command:

```

```

- ```
  gluster volume set all cluster.op-version 30800
  ```

### Offline Upgrade Procedure

For this procedure, schedule a downtime and prevent all your clients from accessing the servers.

On every storage server in your trusted storage pool:

- Stop all gluster services using the below command or through your favorite way to stop them.

  ```
  
  ```

```
killall glusterfs glusterfsd glusterd
```

If you are using gfapi based applications (qemu, NFS-Ganesha, Samba etc.) on the servers, please stop those applications too.

Install Gluster 3.8

Ensure that version reflects 3.8.x in the output of

```

gluster --version
```

Start glusterd on the upgraded server

```

glusterd
```

Ensure that all gluster processes are online by executing

```

gluster volume status
```

Restart any gfapi based application stopped previously.

After the upgrade is complete on all servers, run the following command:

```

```

- ```
  gluster volume set all cluster.op-version 30800
  ```

### Upgrade Procedure for Clients

- Unmount all glusterfs mount points on the client
- Stop applications using gfapi (qemu etc.)
- Install Gluster 3.8
- Mount all gluster shares
- Start applications using libgfapi that were stopped previously

# GlusterFS upgrade to 3.7.x

Now that GlusterFS 3.7.0 is out, here is the process to upgrade from earlier installed versions of GlusterFS. Please read the entire howto before proceeding with an upgrade of your deployment

### Pre-upgrade

GlusterFS contains afrv2 implementation from 3.6.0 by default. If you are using GlusterFS replication ( \< 3.6) in your setup, please note that the new afrv2 implementation is only compatible with 3.6 or greater GlusterFS clients. If you are not updating your clients to GlusterFS version 3.6 along with your servers you would need to disable client self healing process before the upgrade. You can perform this by below steps.

```console
# gluster v set testvol cluster.entry-self-heal off
volume set: success

# gluster v set testvol cluster.data-self-heal off
volume set: success

# gluster v set testvol cluster.metadata-self-heal off
volume set: success
```

### GlusterFS upgrade to 3.7.x

**a) Scheduling a downtime**

For this approach, schedule a downtime and prevent all your clients from accessing (umount your volumes, stop gluster Volumes..etc) the servers.

```

1. Stop all glusterd, glusterfsd and glusterfs processes on your server.
2. Install  GlusterFS 3.7.0
3. Start glusterd.
4. Ensure that all started volumes have processes online in “gluster volume status”.
```

You would need to repeat these steps on all servers that form your trusted storage pool.

After upgrading the servers, it is recommended to upgrade all client installations to 3.7.0.

**b) Rolling Upgrade**

If you have replicated or distributed replicated volumes with bricks  placed in the right fashion for redundancy, have no data to be  self-healed and feel adventurous, you can perform a rolling upgrade  through the following procedure:

```

1.Stop all glusterd, glusterfs and glusterfsd processes on your server.
2.Install GlusterFS 3.7.0.
3.Start glusterd.
4.Run “gluster volume heal <volname> info” on all volumes and ensure that there is nothing left to be 5.self-healed on every volume. If you have pending data for self-heal, run “gluster volume heal <volname>” and wait for self-heal to complete.
6.Ensure that all started volumes have processes online in “gluster volume status”.
```

Repeat the above steps on all servers that are part of your trusted storage pool.

Again after upgrading the servers, it is recommended to upgrade all client installations to 3.7.0.

### Special notes for upgrading from 3.4.x to 3.7.X

If you have quota or geo-replication configured in 3.4.x, please read below. Else you can skip this section.

Architectural changes in Quota & geo-replication were introduced in Gluster 3.5.0. Hence scheduling a downtime is recommended for upgrading from 3.4.x to 3.7.x if you have these features enabled.

### **Upgrade Steps For Quota**

The upgrade process for quota involves the following:

1. Run pre-upgrade-script-for-quota.sh
2. Upgrade to 3.7.0
3. Run post-upgrade-script-for-quota.sh

More details on the scripts are as under.

*Pre-Upgrade Script:*

What it does:

The pre-upgrade script (pre-upgrade-script-for-quota.sh) iterates over the list of volumes that have quota enabled and captures the configured quota limits for each such volume in a file under /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> by executing 'quota list' command on each one of them.

Pre-requisites for running Pre-Upgrade Script:

1. Make sure glusterd and the brick processes are running on all nodes    in the cluster.
2. The pre-upgrade script must be run prior to upgradation.
3. The pre-upgrade script must be run on only one of the nodes in the    cluster.

Location:

pre-upgrade-script-for-quota.sh must be retrieved from the source tree under the 'extras' directory.

Invocation:

Invoke the script by executing `./pre-upgrade-script-for-quota.sh` from the shell on any one of the nodes in the cluster.

Example:

```

[root@server1 extras]#./pre-upgrade-script-for-quota.sh
```

*Post-Upgrade Script:*

What it does:

The post-upgrade script (post-upgrade-script-for-quota.sh) picks the volumes that have quota enabled.

Because the cluster must be operating at op-version 3 for quota to work, the 'default-soft-limit' for each of these volumes is set to 80% (which is its default value) via `volume set` operation as an explicit trigger to bump up the op-version of the cluster and also to trigger a re-write of volfiles which knocks quota off client volume file.

Once this is done, these volumes are started forcefully using `volume start force` to launch the Quota Daemon on all the nodes.

Thereafter, for each of these volumes, the paths and the limits configured on them are retrieved from the backed up file /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> and limits are set on them via the `quota limit-usage` interface.

Note:

In the new version of quota, the command `quota limit-usage` will fail if the directory on which quota limit is to be set for a given volume does not exist. Therefore, it is advised that you create these directories first before running post-upgrade-script-for-quota.sh if you want limits to be set on these directories.

Pre-requisites for running Post-Upgrade Script:

1. The post-upgrade script must be executed after all the nodes in the    cluster have upgraded.
2. Also, all the clients accessing the given volume must also be    upgraded before the script is run.
3. Make sure glusterd and the brick processes are running on all nodes    in the cluster post upgrade.
4. The script must be run from the same node where the pre-upgrade    script was run.

Location:

post-upgrade-script-for-quota.sh can be found under the 'extras' directory of the source tree for glusterfs.

Invocation:

post-upgrade-script-for-quota.sh takes one command line argument. This argument could be one of the following: ''the name of the volume which has quota enabled; or' '' 'all'.''

In the first case, invoke post-upgrade-script-for-quota.sh from the shell for each volume with quota enabled, with the name of the volume passed as an argument in the command-line:

Example: For a volume "vol1" on which quota is enabled, invoke the script in the following way:

```

[root@server1 extras]#./post-upgrade-script-for-quota.sh vol1
```

In the second case, the post-upgrade script picks on its own, the volumes on which quota is enabled, and executes the post-upgrade procedure on each one of them. In this case, invoke post-upgrade-script-for-quota.sh from the shell with 'all' passed as an argument in the command-line:

Example:

```

[root@server1 extras]#./post-upgrade-script-for-quota.sh all
```

Note:

In the second case, post-upgrade-script-for-quota.sh exits prematurely upon failure to ugprade any given volume. In that case, you may run post-upgrade-script-for-quota.sh individually (using the volume name as command line argument) on this volume and also on all volumes appearing after this volume in the output of `gluster volume list`, that have quota enabled.

The backed up files under /var/tmp/glusterfs/quota-config-backup/ are retained after the post-upgrade procedure for reference.

### **Upgrade steps for geo replication:**

New version supports only syncing between two gluster volumes via ssh+gluster.

''Below are the steps to upgrade. ''

1. Stop the geo-replication session in older version ( \< 3.5) using the below command

```

    # gluster volume geo-replication <master_vol> <slave_host>::<slave_vol> stop
```

2. Now since the new geo-replication requires gfids of master and slave volume to be same, generate a file containing the gfids of all the files in master

```

    # cd /usr/share/glusterfs/scripts/ ;
    # bash generate-gfid-file.sh localhost:<master_vol> $PWD/get-gfid.sh    /tmp/master_gfid_file.txt ;
    # scp /tmp/master_gfid_file.txt root@<slave_host>:/tmp
```

3. Upgrade the slave cluster installation to 3.7.0

4. Now go to the slave host and apply the gfid to the slave volume.

```

    # cd /usr/share/glusterfs/scripts/
    # bash slave-upgrade.sh localhost:<slave_vol> /tmp/master_gfid_file.txt    $PWD/gsync-sync-gfid
```

This will ask you for password of all the nodes in slave cluster. Please provide them, if asked. Also note that this will restart your slave gluster volume (stop and start)

5. Upgrade the master cluster to 3.7.0

6. Now create and start the geo-rep session between master and slave. For instruction on creating new geo-rep session please refer distributed-geo-rep chapter in admin guide.

```

    # gluster volume geo-replication <master_volume> <slave_host>::<slave_volume> create push-pem force
    # gluster volume geo-replication <master_volume> <slave_host>::<slave_volume> start
```

At this point, your distributed geo-replication should be configured appropriately.

# GlusterFS upgrade from 3.5.x to 3.6.x

Now that GlusterFS 3.6.0 is out, here is the process to upgrade from earlier installed versions of GlusterFS.

If you are using GlusterFS replication ( \< 3.6) in your setup , please note that the new afrv2 implementation is only compatible with 3.6 GlusterFS clients. If you are not updating your clients to GlusterFS version 3.6 you need to disable client self healing process. You can perform this by below steps.

```console
# gluster v set testvol cluster.entry-self-heal off
volume set: success

# gluster v set testvol cluster.data-self-heal off
volume set: success

# gluster v set testvol cluster.metadata-self-heal off
volume set: success
```

### GlusterFS upgrade from 3.5.x to 3.6.x

**a) Scheduling a downtime (Recommended)**

For this approach, schedule a downtime and prevent all your clients from accessing ( umount your volumes, stop gluster Volumes..etc)the servers.

1. Stop all glusterd, glusterfsd and glusterfs processes on your server.
2. Install GlusterFS 3.6.0
3. Start glusterd.
4. Ensure that all started volumes have processes online in “gluster volume status”.

You would need to repeat these steps on all servers that form your trusted storage pool.

After upgrading the servers, it is recommended to upgrade all client installations to 3.6.0

### GlusterFS upgrade from 3.4.x to 3.6.X

Upgrade from GlusterFS 3.4.x:

GlusterFS 3.6.0 is compatible with 3.4.x (yes, you read it right!). You can upgrade your deployment by following one of the two procedures below.

**a) Scheduling a downtime (Recommended)**

For this approach, schedule a downtime and prevent all your clients from accessing ( umount your volumes, stop gluster Volumes..etc)the servers.

If you have quota configured, you need to perform step 1 and 6, otherwise you can skip it.

If you have geo-replication session running, stop the session using the geo-rep stop command (please refer to step 1 of geo-rep upgrade steps provided below)

1. Execute "pre-upgrade-script-for-quota.sh" mentioned under "Upgrade Steps For Quota" section.
2. Stop all glusterd, glusterfsd and glusterfs processes on your server.
3. Install GlusterFS 3.6.0
4. Start glusterd.
5. Ensure that all started volumes have processes online in “gluster volume status”.
6. Execute "Post-Upgrade Script" mentioned under "Upgrade Steps For Quota" section.

You would need to repeat these steps on all servers that form your trusted storage pool.

To upgrade geo-replication session, please refer to geo-rep upgrade steps provided below (from step 2)

After upgrading the servers, it is recommended to upgrade all client installations to 3.6.0.

Do report your findings on 3.6.0 in gluster-users, #gluster on Freenode and bugzilla.

Please note that this may not work for all installations & upgrades. If you notice anything amiss and would like to see it covered here, please point the same.

### **Upgrade Steps For Quota**

The upgrade process for quota involves executing two upgrade scripts:

1. pre-upgrade-script-for-quota.sh, and\
2. post-upgrade-script-for-quota.sh

*Pre-Upgrade Script:*

What it does:

The pre-upgrade script (pre-upgrade-script-for-quota.sh) iterates over the list of volumes that have quota enabled and captures the configured quota limits for each such volume in a file under /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> by executing 'quota list' command on each one of them.

Pre-requisites for running Pre-Upgrade Script:

1. Make sure glusterd and the brick processes are running on all nodes    in the cluster.
2. The pre-upgrade script must be run prior to upgradation.
3. The pre-upgrade script must be run on only one of the nodes in the    cluster.

Location:

pre-upgrade-script-for-quota.sh must be retrieved from the source tree under the 'extras' directory.

Invocation:

Invoke the script by executing `./pre-upgrade-script-for-quota.sh` from the shell on any one of the nodes in the cluster.

Example:

```

[root@server1 extras]#./pre-upgrade-script-for-quota.sh
```

*Post-Upgrade Script:*

What it does:

The post-upgrade script (post-upgrade-script-for-quota.sh) picks the volumes that have quota enabled.

Because the cluster must be operating at op-version 3 for quota to work, the 'default-soft-limit' for each of these volumes is set to 80% (which is its default value) via `volume set` operation as an explicit trigger to bump up the op-version of the cluster and also to trigger a re-write of volfiles which knocks quota off client volume file.

Once this is done, these volumes are started forcefully using `volume start force` to launch the Quota Daemon on all the nodes.

Thereafter, for each of these volumes, the paths and the limits configured on them are retrieved from the backed up file /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> and limits are set on them via the `quota limit-usage` interface.

Note:

In the new version of quota, the command `quota limit-usage` will fail if the directory on which quota limit is to be set for a given volume does not exist. Therefore, it is advised that you create these directories first before running post-upgrade-script-for-quota.sh if you want limits to be set on these directories.

Pre-requisites for running Post-Upgrade Script:

1. The post-upgrade script must be executed after all the nodes in the    cluster have upgraded.
2. Also, all the clients accessing the given volume must also be    upgraded before the script is run.
3. Make sure glusterd and the brick processes are running on all nodes    in the cluster post upgrade.
4. The script must be run from the same node where the pre-upgrade    script was run.

Location:

post-upgrade-script-for-quota.sh can be found under the 'extras' directory of the source tree for glusterfs.

Invocation:

post-upgrade-script-for-quota.sh takes one command line argument. This argument could be one of the following: ''the name of the volume which has quota enabled; or' '' 'all'.''

In the first case, invoke post-upgrade-script-for-quota.sh from the shell for each volume with quota enabled, with the name of the volume passed as an argument in the command-line:

Example:

*For a volume "vol1" on which quota is enabled, invoke the script in the following way:*

```

[root@server1 extras]#./post-upgrade-script-for-quota.sh vol1
```

In the second case, the post-upgrade script picks on its own, the volumes on which quota is enabled, and executes the post-upgrade procedure on each one of them. In this case, invoke post-upgrade-script-for-quota.sh from the shell with 'all' passed as an argument in the command-line:

Example:

```

[root@server1 extras]#./post-upgrade-script-for-quota.sh all
```

Note:

In the second case, post-upgrade-script-for-quota.sh exits prematurely upon failure to ugprade any given volume. In that case, you may run post-upgrade-script-for-quota.sh individually (using the volume name as command line argument) on this volume and also on all volumes appearing after this volume in the output of `gluster volume list`, that have quota enabled.

The backed up files under /var/tmp/glusterfs/quota-config-backup/ are retained after the post-upgrade procedure for reference.

### **Upgrade steps for geo replication:**

Here are the steps to upgrade your existing geo-replication setup to new distributed geo-replication in glusterfs-3.5. The new version leverges all the nodes in your master volume and provides better performace.

Note:

Since new version of geo-rep very much different from the older one, this has to be done offline.

New version supports only syncing between two gluster volumes via ssh+gluster.

This doc deals with upgrading geo-rep. So upgrading the volumes are not covered in detail here.

**Below are the steps to upgrade:**

1. Stop the geo-replication session in older version ( \< 3.5) using the below command

```

    # gluster volume geo-replication `<master_vol>` `<slave_host>`::`<slave_vol>` stop
```

2. Now since the new geo-replication requires gfids of master and slave volume to be same, generate a file containing the gfids of all the files in master

```

    # cd /usr/share/glusterfs/scripts/ ;
    # bash generate-gfid-file.sh localhost:`<master_vol>` $PWD/get-gfid.sh    /tmp/master_gfid_file.txt ;
    # scp /tmp/master_gfid_file.txt root@`<slave_host>`:/tmp
```

3. Now go to the slave host and aplly the gfid to the slave volume.

```

    # cd /usr/share/glusterfs/scripts/
    # bash slave-upgrade.sh localhost:`<slave_vol>` /tmp/master_gfid_file.txt    $PWD/gsync-sync-gfid
```

This will ask you for password of all the nodes in slave cluster. Please provide them, if asked.

4. Also note that this will restart your slave gluster volume (stop and start)

5. Now create and start the geo-rep session between master and slave. For instruction on creating new geo-rep seesion please refer distributed-geo-rep admin guide.

```

    # gluster volume geo-replication `<master_volume>` `<slave_host>`::`<slave_volume>` create push-pem force
    # gluster volume geo-replication `<master_volume>` `<slave_host>`::`<slave_volume>` start
```

6. Now your session is upgraded to use distributed-geo-rep

# Upgrade to 3.5

### Glusterfs upgrade from 3.4.x to 3.5

Now that GlusterFS 3.5.0 is out, here are some mechanisms to upgrade from earlier installed versions of GlusterFS.

**Upgrade from GlusterFS 3.4.x:**

GlusterFS 3.5.0 is compatible with 3.4.x (yes, you read it right!). You can upgrade your deployment by following one of the two procedures below.

**a) Scheduling a downtime (Recommended)**

For this approach, schedule a downtime and prevent all your clients from accessing the servers.

If you have quota configured, you need to perform step 1 and 6, otherwise you can skip it.

If you have geo-replication session running, stop the session using the geo-rep stop command (please refer to step 1 of geo-rep upgrade steps provided below)

1. Execute "pre-upgrade-script-for-quota.sh" mentioned under "Upgrade Steps For Quota" section.
2. Stop all glusterd, glusterfsd and glusterfs processes on your server.
3. Install GlusterFS 3.5.0
4. Start glusterd.
5. Ensure that all started volumes have processes online in “gluster volume status”.
6. Execute "Post-Upgrade Script" mentioned under "Upgrade Steps For Quota" section.

You would need to repeat these steps on all servers that form your trusted storage pool.

To upgrade geo-replication session, please refer to geo-rep upgrade steps provided below (from step 2)

After upgrading the servers, it is recommended to upgrade all client installations to 3.5.0.

**b) Rolling upgrades with no downtime**

If you have replicated or distributed replicated volumes with bricks placed in the right fashion for redundancy, have no data to be self-healed and feel adventurous, you can perform a rolling upgrade through the following procedure:

NOTE: Rolling upgrade of geo-replication session from glusterfs version \< 3.5 to 3.5.x is not supported.

If you have quota configured, you need to perform step 1 and 7, otherwise you can skip it.

1. Execute "pre-upgrade-script-for-quota.sh" mentioned under "Upgrade Steps For Quota" section.
2. Stop all glusterd, glusterfs and glusterfsd processes on your server.
3. Install GlusterFS 3.5.0.
4. Start glusterd.
5. Run “gluster volume heal `<volname>` info” on all  volumes and ensure that there is nothing left to be self-healed on every volume. If you have pending data for self-heal, run “gluster volume  heal `<volname>`” and wait for self-heal to complete.
6. Ensure that all started volumes have processes online in “gluster volume status”.
7. Execute "Post-Upgrade Script" mentioned under "Upgrade Steps For Quota" section.

Repeat the above steps on all servers that are part of your trusted storage pool.

Again after upgrading the servers, it is recommended to upgrade all client installations to 3.5.0.

Do report your findings on 3.5.0 in gluster-users, #gluster on Freenode and bugzilla.

Please note that this may not work for all installations & upgrades. If you notice anything amiss and would like to see it covered here, please point the same.

### **Upgrade Steps For Quota**

The upgrade process for quota involves executing two upgrade scripts:

1. pre-upgrade-script-for-quota.sh, and\
2. post-upgrade-script-for-quota.sh

*Pre-Upgrade Script:*

What it does:

The pre-upgrade script (pre-upgrade-script-for-quota.sh) iterates over the list of volumes that have quota enabled and captures the configured quota limits for each such volume in a file under /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> by executing 'quota list' command on each one of them.

Pre-requisites for running Pre-Upgrade Script:

1. Make sure glusterd and the brick processes are running on all nodes    in the cluster.
2. The pre-upgrade script must be run prior to upgradation.
3. The pre-upgrade script must be run on only one of the nodes in the    cluster.

Location:

pre-upgrade-script-for-quota.sh must be retrieved from the source tree under the 'extras' directory.

Invocation:

Invoke the script by executing `./pre-upgrade-script-for-quota.sh` from the shell on any one of the nodes in the cluster.

- Example:

  [root@server1 extras]#./pre-upgrade-script-for-quota.sh

*Post-Upgrade Script:*

What it does:

The post-upgrade script (post-upgrade-script-for-quota.sh) picks the volumes that have quota enabled.

Because the cluster must be operating at op-version 3 for quota to work, the 'default-soft-limit' for each of these volumes is set to 80% (which is its default value) via `volume set` operation as an explicit trigger to bump up the op-version of the cluster and also to trigger a re-write of volfiles which knocks quota off client volume file.

Once this is done, these volumes are started forcefully using `volume start force` to launch the Quota Daemon on all the nodes.

Thereafter, for each of these volumes, the paths and the limits configured on them are retrieved from the backed up file /var/tmp/glusterfs/quota-config-backup/vol_\<VOLNAME> and limits are set on them via the `quota limit-usage` interface.

Note:

In the new version of quota, the command `quota limit-usage` will fail if the directory on which quota limit is to be set for a given volume does not exist. Therefore, it is advised that you create these directories first before running post-upgrade-script-for-quota.sh if you want limits to be set on these directories.

Pre-requisites for running Post-Upgrade Script:

1. The post-upgrade script must be executed after all the nodes in the    cluster have upgraded.
2. Also, all the clients accessing the given volume must also be    upgraded before the script is run.
3. Make sure glusterd and the brick processes are running on all nodes    in the cluster post upgrade.
4. The script must be run from the same node where the pre-upgrade    script was run.

Location:

post-upgrade-script-for-quota.sh can be found under the 'extras' directory of the source tree for glusterfs.

Invocation:

post-upgrade-script-for-quota.sh takes one command line argument. This argument could be one of the following: ''the name of the volume which has quota enabled; or' '' 'all'.''

In the first case, invoke post-upgrade-script-for-quota.sh from the shell for each volume with quota enabled, with the name of the volume passed as an argument in the command-line:

- Example:

*For a volume "vol1" on which quota is enabled, invoke the script in the following way:*

```

    [root@server1 extras]#./post-upgrade-script-for-quota.sh vol1
```

In the second case, the post-upgrade script picks on its own, the volumes on which quota is enabled, and executes the post-upgrade procedure on each one of them. In this case, invoke post-upgrade-script-for-quota.sh from the shell with 'all' passed as an argument in the command-line:

- Example:

  [root@server1 extras]#./post-upgrade-script-for-quota.sh all

Note:

In the second case, post-upgrade-script-for-quota.sh exits prematurely upon failure to ugprade any given volume. In that case, you may run post-upgrade-script-for-quota.sh individually (using the volume name as command line argument) on this volume and also on all volumes appearing after this volume in the output of `gluster volume list`, that have quota enabled.

The backed up files under /var/tmp/glusterfs/quota-config-backup/ are retained after the post-upgrade procedure for reference.

### **Upgrade steps for geo replication:**

Here are the steps to upgrade your existing geo-replication setup to new distributed geo-replication in glusterfs-3.5. The new version leverges all the nodes in your master volume and provides better performace.

Note:

Since new version of geo-rep very much different from the older one, this has to be done offline.

New version supports only syncing between two gluster volumes via ssh+gluster.

This doc deals with upgrading geo-rep. So upgrading the volumes are not covered in detail here.

**Below are the steps to upgrade:**

1. Stop the geo-replication session in older version ( \< 3.5) using the below command

```

    #gluster volume geo-replication `<master_vol>` `<slave_host>`::`<slave_vol>` stop
```

2. Now since the new geo-replication requires gfids of master and slave volume to be same, generate a file containing the gfids of all the files in master

```

    cd /usr/share/glusterfs/scripts/ ;
    bash generate-gfid-file.sh localhost:`<master_vol>` $PWD/get-gfid.sh    /tmp/master_gfid_file.txt ;
    scp /tmp/master_gfid_file.txt root@`<slave_host>`:/tmp
```

3. Now go to the slave host and aplly the gfid to the slave volume.

```

    cd /usr/share/glusterfs/scripts/
    bash slave-upgrade.sh localhost:`<slave_vol>` /tmp/master_gfid_file.txt    $PWD/gsync-sync-gfid
```

This will ask you for password of all the nodes in slave cluster. Please provide them, if asked.

4. Also note that this will restart your slave gluster volume (stop and start)

5. Now create and start the geo-rep session between master and slave. For instruction on creating new geo-rep seesion please refer distributed-geo-rep admin guide.

```

    gluster volume geo-replication `<master_volume>` `<slave_host>`::`<slave_volume>` create push-pem force
    gluster volume geo-replication `<master_volume>` `<slave_host>`::`<slave_volume>` start
```

6. Now your session is upgraded to use distributed-geo-rep