# Converting an existing cluster to cephadm

Cephadm allows you to convert an existing Ceph cluster that has been deployed with ceph-deploy, ceph-ansible, DeepSea, or similar tools.

## Limitations

- Cephadm only works with BlueStore OSDs.  If there are FileStore OSDs in your cluster you cannot manage them.

## Preparation

1. Get the `cephadm` command line tool on each host in the existing cluster.  

2. Prepare each host for use by `cephadm`:

   ```
   # cephadm prepare-host
   ```

3. Determine which Ceph version you will use.  You can use any Octopus (15.2.z) release or later.  For example, `docker.io/ceph/ceph:v15.2.0`.  The default will be the latest stable release, but if you are upgrading from an earlier release at the same time be sure to refer to the upgrade notes for any special steps to take while upgrading.

   The image is passed to cephadm with:

   ```
   # cephadm --image $IMAGE <rest of command goes here>
   ```

4. Cephadm can provide a list of all Ceph daemons on the current host:

   ```
   # cephadm ls
   ```

   Before starting, you should see that all existing daemons have a style of `legacy` in the resulting output.  As the adoption process progresses, adopted daemons will appear as style `cephadm:v1`.

## Adoption process

1. Ensure the ceph configuration is migrated to use the cluster config database. If the `/etc/ceph/ceph.conf` is identical on each host, then on one host:

   ```
   # ceph config assimilate-conf -i /etc/ceph/ceph.conf
   ```

   If there are config variations on each host, you may need to repeat this command on each host.  You can view the cluster’s configuration to confirm that it is complete with:

   ```
   # ceph config dump
   ```

2. Adopt each monitor:

   ```
   # cephadm adopt --style legacy --name mon.<hostname>
   ```

   Each legacy monitor should stop, quickly restart as a cephadm container, and rejoin the quorum.

3. Adopt each manager:

   ```
   # cephadm adopt --style legacy --name mgr.<hostname>
   ```

4. Enable cephadm:

   ```
   # ceph mgr module enable cephadm
   # ceph orch set backend cephadm
   ```

5. Generate an SSH key:

   ```
   # ceph cephadm generate-key
   # ceph cephadm get-pub-key > ceph.pub
   ```

6. Install the cluster SSH key on each host in the cluster:

   ```
   # ssh-copy-id -f -i ceph.pub root@<host>
   ```

   Note

   It is also possible to import an existing ssh key. See [ssh errors](https://docs.ceph.com/docs/master/cephadm/troubleshooting/#cephadm-ssh-errors) in the troubleshooting document for instructions describing how to import existing ssh keys.

7. Tell cephadm which hosts to manage:

   ```
   # ceph orch host add <hostname> [ip-address]
   ```

   This will perform a `cephadm check-host` on each host before adding it to ensure it is working.  The IP address argument is only required if DNS does not allow you to connect to each host by its short name.

8. Verify that the adopted monitor and manager daemons are visible:

   ```
   # ceph orch ps
   ```

9. Adopt all OSDs in the cluster:

   ```
   # cephadm adopt --style legacy --name <name>
   ```

   For example:

   ```
   # cephadm adopt --style legacy --name osd.1
   # cephadm adopt --style legacy --name osd.2
   ```

10. Redeploy MDS daemons by telling cephadm how many daemons to run for each file system.  You can list file systems by name with `ceph fs ls`.  Run the following command on the master nodes:

    ```
    # ceph orch apply mds <fs-name> [--placement=<placement>]
    ```

    For example, in a cluster with a single file system called foo:

    ```
    # ceph fs ls
    name: foo, metadata pool: foo_metadata, data pools: [foo_data ]
    # ceph orch apply mds foo 2
    ```

    Wait for the new MDS daemons to start with:

    ```
    # ceph orch ps --daemon-type mds
    ```

    Finally, stop and remove the legacy MDS daemons:

    ```
    # systemctl stop ceph-mds.target
    # rm -rf /var/lib/ceph/mds/ceph-*
    ```

11. Redeploy RGW daemons.  Cephadm manages RGW daemons by zone.  For each zone, deploy new RGW daemons with cephadm:

    ```
    # ceph orch apply rgw <realm> <zone> [--subcluster=<subcluster>] [--port=<port>] [--ssl] [--placement=<placement>]
    ```

    where *<placement>* can be a simple daemon count, or a list of specific hosts (see [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec)).

    Once the daemons have started and you have confirmed they are functioning, stop and remove the old legacy daemons:

    ```
    # systemctl stop ceph-rgw.target
    # rm -rf /var/lib/ceph/radosgw/ceph-*
    ```

    For adopting single-site systems without a realm, see also [Migrating a Single Site System to Multi-Site](https://docs.ceph.com/docs/master/radosgw/multisite/#rgw-multisite-migrate-from-single-site).

12. Check the `ceph health detail` output for cephadm warnings about stray cluster daemons or hosts that are not yet managed.

# Upgrading Ceph

Cephadm is capable of safely upgrading Ceph from one bugfix release to another.  For example, you can upgrade from v15.2.0 (the first Octopus release) to the next point release v15.2.1.

The automated upgrade process follows Ceph best practices.  For example:

- The upgrade order starts with managers, monitors, then other daemons.
- Each daemon is restarted only after Ceph indicates that the cluster will remain available.

Keep in mind that the Ceph cluster health status is likely to switch to HEALTH_WARNING during the upgrade.

## Starting the upgrade

Before you start, you should verify that all hosts are currently online and your cluster is healthy.

```
# ceph -s
```

To upgrade (or downgrade) to a specific release:

```
# ceph orch upgrade start --ceph-version <version>
```

For example, to upgrade to v15.2.1:

```
# ceph orch upgrade start --ceph-version 15.2.1
```

## Monitoring the upgrade

Determine whether an upgrade is in process and what version the cluster is upgrading to with:

```
# ceph orch upgrade status
```

While the upgrade is underway, you will see a progress bar in the ceph status output.  For example:

```
# ceph -s
[...]
  progress:
    Upgrade to docker.io/ceph/ceph:v15.2.1 (00h 20m 12s)
      [=======.....................] (time remaining: 01h 43m 31s)
```

You can also watch the cephadm log with:

```
# ceph -W cephadm
```

## Canceling an upgrade

You can stop the upgrade process at any time with:

```
# ceph orch upgrade stop
```

## Potential problems

There are a few health alerts that can arise during the upgrade process.

### UPGRADE_NO_STANDBY_MGR

Ceph requires an active and standby manager daemon in order to proceed, but there is currently no standby.

You can ensure that Cephadm is configured to run 2 (or more) managers with:

```
# ceph orch apply mgr 2  # or more
```

You can check the status of existing mgr daemons with:

```
# ceph orch ps --daemon-type mgr
```

If an existing mgr daemon has stopped, you can try restarting it with:

```
# ceph orch daemon restart <name>
```

### UPGRADE_FAILED_PULL

Ceph was unable to pull the container image for the target version. This can happen if you specify an version or container image that does not exist (e.g., 1.2.3), or if the container registry is not reachable from one or more hosts in the cluster.

You can cancel the existing upgrade and specify a different target version with:

```
# ceph orch upgrade stop
# ceph orch upgrade start --ceph-version <version>
```

## Using customized container images

For most users, simplify specifying the Ceph version is sufficient. Cephadm will locate the specific Ceph container image to use by combining the `container_image_base` configuration option (default: `docker.io/ceph/ceph`) with a tag of `vX.Y.Z`.

You can also upgrade to an arbitrary container image.  For example, to upgrade to a development build:

```
# ceph orch upgrade start --image quay.io/ceph-ci/ceph:recent-git-branch-name
```

For more information about available container images, see [Ceph Container Images](https://docs.ceph.com/docs/master/install/containers/#containers).

# Cephadm Operations

## Watching cephadm log messages

Cephadm logs to the `cephadm` cluster log channel, meaning you can monitor progress in realtime with:

```
# ceph -W cephadm
```

By default it will show info-level events and above.  To see debug-level messages too:

```
# ceph config set mgr mgr/cephadm/log_to_cluster_level debug
# ceph -W cephadm --watch-debug
```

Be careful: the debug messages are very verbose!

You can see recent events with:

```
# ceph log last cephadm
```

These events are also logged to the `ceph.cephadm.log` file on monitor hosts and to the monitor daemons’ stderr.



## Ceph daemon logs

### Logging to stdout

Traditionally, Ceph daemons have logged to `/var/log/ceph`.  By default, cephadm daemons log to stderr and the logs are captured by the container runtime environment.  For most systems, by default, these logs are sent to journald and accessible via `journalctl`.

For example, to view the logs for the daemon `mon.foo` for a cluster with ID `5c5a50ae-272a-455d-99e9-32c6a013e694`, the command would be something like:

```
journalctl -u ceph-5c5a50ae-272a-455d-99e9-32c6a013e694@mon.foo
```

This works well for normal operations when logging levels are low.

To disable logging to stderr:

```
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
```

### Logging to files

You can also configure Ceph daemons to log to files instead of stderr, just like they have in the past.  When logging to files, Ceph logs appear in `/var/log/ceph/<cluster-fsid>`.

To enable logging to files:

```
ceph config set global log_to_file true
ceph config set global mon_cluster_log_to_file true
```

We recommend disabling logging to stderr (see above) or else everything will be logged twice:

```
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
```

By default, cephadm sets up log rotation on each host to rotate these files.  You can configure the logging retention schedule by modifying `/etc/logrotate.d/ceph.<cluster-fsid>`.

## Data location

Cephadm daemon data and logs in slightly different locations than older versions of ceph:

- `/var/log/ceph/<cluster-fsid>` contains all cluster logs.  Note that by default cephadm logs via stderr and the container runtime, so these logs are normally not present.
- `/var/lib/ceph/<cluster-fsid>` contains all cluster daemon data (besides logs).
- `/var/lib/ceph/<cluster-fsid>/<daemon-name>` contains all data for an individual daemon.
- `/var/lib/ceph/<cluster-fsid>/crash` contains crash reports for the cluster.
- `/var/lib/ceph/<cluster-fsid>/removed` contains old daemon data directories for stateful daemons (e.g., monitor, prometheus) that have been removed by cephadm.

### Disk usage

Because a few Ceph daemons may store a significant amount of data in `/var/lib/ceph` (notably, the monitors and prometheus), we recommend moving this directory to its own disk, partition, or logical volume so that it does not fill up the root file system.

## SSH Configuration

Cephadm uses SSH to connect to remote hosts.  SSH uses a key to authenticate with those hosts in a secure way.

### Default behavior

Cephadm stores an SSH key in the monitor that is used to connect to remote hosts.  When the cluster is bootstrapped, this SSH key is generated automatically and no additional configuration is necessary.

A *new* SSH key can be generated with:

```
ceph cephadm generate-key
```

The public portion of the SSH key can be retrieved with:

```
ceph cephadm get-pub-key
```

The currently stored SSH key can be deleted with:

```
ceph cephadm clear-key
```

You can make use of an existing key by directly importing it with:

```
ceph config-key set mgr/cephadm/ssh_identity_key -i <key>
ceph config-key set mgr/cephadm/ssh_identity_pub -i <pub>
```

You will then need to restart the mgr daemon to reload the configuration with:

```
ceph mgr fail
```

### Configuring a different SSH user

Cephadm must be able to log into all the Ceph cluster nodes as an user that has enough privileges to download container images, start containers and execute commands without prompting for a password. If you do not want to use the “root” user (default option in cephadm), you must provide cephadm the name of the user that is going to be used to perform all the cephadm operations. Use the command:

```
ceph cephadm set-user <user>
```

Prior to running this the cluster ssh key needs to be added to this users authorized_keys file and non-root users must have passwordless sudo access.

### Customizing the SSH configuration

Cephadm generates an appropriate `ssh_config` file that is used for connecting to remote hosts.  This configuration looks something like this:

```
Host *
User root
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```

There are two ways to customize this configuration for your environment:

1. Import a customized configuration file that will be stored by the monitor with:

   ```
   ceph cephadm set-ssh-config -i <ssh_config_file>
   ```

   To remove a customized SSH config and revert back to the default behavior:

   ```
   ceph cephadm clear-ssh-config
   ```

2. You can configure a file location for the SSH configuration file with:

   ```
   ceph config set mgr mgr/cephadm/ssh_config_file <path>
   ```

   We do *not recommend* this approach.  The path name must be visible to *any* mgr daemon, and cephadm runs all daemons as containers. That means that the file either need to be placed inside a customized container image for your deployment, or manually distributed to the mgr data directory (`/var/lib/ceph/<cluster-fsid>/mgr.<id>` on the host, visible at `/var/lib/ceph/mgr/ceph-<id>` from inside the container).

## Health checks

### CEPHADM_PAUSED

Cephadm background work has been paused with `ceph orch pause`.  Cephadm continues to perform passive monitoring activities (like checking host and daemon status), but it will not make any changes (like deploying or removing daemons).

Resume cephadm work with:

```
ceph orch resume
```



### CEPHADM_STRAY_HOST

One or more hosts have running Ceph daemons but are not registered as hosts managed by *cephadm*.  This means that those services cannot currently be managed by cephadm (e.g., restarted, upgraded, included in ceph orch ps).

You can manage the host(s) with:

```
ceph orch host add *<hostname>*
```

Note that you may need to configure SSH access to the remote host before this will work.

Alternatively, you can manually connect to the host and ensure that services on that host are removed or migrated to a host that is managed by *cephadm*.

You can also disable this warning entirely with:

```
ceph config set mgr mgr/cephadm/warn_on_stray_hosts false
```

See [Fully qualified domain names vs bare host names](https://docs.ceph.com/docs/master/cephadm/concepts/#cephadm-fqdn) for more information about host names and domain names.

### CEPHADM_STRAY_DAEMON

One or more Ceph daemons are running but not are not managed by *cephadm*.  This may be because they were deployed using a different tool, or because they were started manually.  Those services cannot currently be managed by cephadm (e.g., restarted, upgraded, or included in ceph orch ps).

If the daemon is a stateful one (monitor or OSD), it should be adopted by cephadm; see [Converting an existing cluster to cephadm](https://docs.ceph.com/docs/master/cephadm/adoption/#cephadm-adoption).  For stateless daemons, it is usually easiest to provision a new daemon with the `ceph orch apply` command and then stop the unmanaged daemon.

This warning can be disabled entirely with:

```
ceph config set mgr mgr/cephadm/warn_on_stray_daemons false
```

### CEPHADM_HOST_CHECK_FAILED

One or more hosts have failed the basic cephadm host check, which verifies that (1) the host is reachable and cephadm can be executed there, and (2) that the host satisfies basic prerequisites, like a working container runtime (podman or docker) and working time synchronization. If this test fails, cephadm will no be able to manage services on that host.

You can manually run this check with:

```
ceph cephadm check-host *<hostname>*
```

You can remove a broken host from management with:

```
ceph orch host rm *<hostname>*
```

You can disable this health warning with:

```
ceph config set mgr mgr/cephadm/warn_on_failed_host_check false
```

## /etc/ceph/ceph.conf

Cephadm uses a minimized `ceph.conf` that only contains a minimal set of information to connect to the Ceph cluster.

To update the configuration settings, use:

```
ceph config set ...
```

To set up an initial configuration before calling bootstrap, create an initial `ceph.conf` file. For example:

```
cat <<EOF > /etc/ceph/ceph.conf
[global]
osd crush chooseleaf type = 0
EOF
cephadm bootstrap -c /root/ceph.conf ...
```

# Monitoring Stack with Cephadm

Ceph Dashboard uses [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/), and related tools to store and visualize detailed metrics on cluster utilization and performance.  Ceph users have three options:

1. Have cephadm deploy and configure these services.  This is the default when bootstrapping a new cluster unless the `--skip-monitoring-stack` option is used.
2. Deploy and configure these services manually.  This is recommended for users with existing prometheus services in their environment (and in cases where Ceph is running in Kubernetes with Rook).
3. Skip the monitoring stack completely.  Some Ceph dashboard graphs will not be available.

The monitoring stack consists of [Prometheus](https://prometheus.io/), Prometheus exporters ([Prometheus Module](https://docs.ceph.com/docs/master/mgr/prometheus/#mgr-prometheus), [Node exporter](https://prometheus.io/docs/guides/node-exporter/)), [Prometheus Alert Manager](https://prometheus.io/docs/alerting/alertmanager/) and [Grafana](https://grafana.com/).

Note

Prometheus’ security model presumes that untrusted users have access to the Prometheus HTTP endpoint and logs. Untrusted users have access to all the (meta)data Prometheus collects that is contained in the database, plus a variety of operational and debugging information.

However, Prometheus’ HTTP API is limited to read-only operations. Configurations can *not* be changed using the API and secrets are not exposed. Moreover, Prometheus has some built-in measures to mitigate the impact of denial of service attacks.

Please see Prometheus’ Security model <https://prometheus.io/docs/operating/security/> for more detailed information.

## Deploying monitoring with cephadm

By default, bootstrap will deploy a basic monitoring stack.  If you did not do this (by passing `--skip-monitoring-stack`, or if you converted an existing cluster to cephadm management, you can set up monitoring by following the steps below.

1. Enable the prometheus module in the ceph-mgr daemon.  This  exposes the internal Ceph metrics so that prometheus can scrape them.:

   ```
   ceph mgr module enable prometheus
   ```

2. Deploy a node-exporter service on every node of the cluster.  The node-exporter provides host-level metrics like CPU and memory  utilization.:

   ```
   ceph orch apply node-exporter '*'
   ```

3. Deploy alertmanager:

   ```
   ceph orch apply alertmanager 1
   ```

4. Deploy prometheus.  A single prometheus instance is sufficient, but for HA you may want to deploy two.:

   ```
   ceph orch apply prometheus 1    # or 2
   ```

5. Deploy grafana:

   ```
   ceph orch apply grafana 1
   ```

Cephadm handles the prometheus, grafana, and alertmanager configurations automatically.

It may take a minute or two for services to be deployed.  Once completed, you should see something like this from `ceph orch ls`:

```
$ ceph orch ls
NAME           RUNNING  REFRESHED  IMAGE NAME                                      IMAGE ID        SPEC
alertmanager       1/1  6s ago     docker.io/prom/alertmanager:latest              0881eb8f169f  present
crash              2/2  6s ago     docker.io/ceph/daemon-base:latest-master-devel  mix           present
grafana            1/1  0s ago     docker.io/pcuzner/ceph-grafana-el8:latest       f77afcf0bcf6   absent
node-exporter      2/2  6s ago     docker.io/prom/node-exporter:latest             e5a616e4b9cf  present
prometheus         1/1  6s ago     docker.io/prom/prometheus:latest                e935122ab143  present
```

### Using custom images

It is possible to install or upgrade monitoring components based on other images.  To do so, the name of the image to be used needs to be stored in the configuration first.  The following configuration options are available.

- `container_image_prometheus`
- `container_image_grafana`
- `container_image_alertmanager`
- `container_image_node_exporter`

Custom images can be set with the `ceph config` command:

```
ceph config set mgr mgr/cephadm/<option_name> <value>
```

For example:

```
ceph config set mgr mgr/cephadm/container_image_prometheus prom/prometheus:v1.4.1
```

Note

By setting a custom image, the default value will be overridden (but not overwritten).  The default value changes when updates become available. By setting a custom image, you will not be able to update the component you have set the custom image for automatically.  You will need to manually update the configuration (image name and tag) to be able to install updates.

If you choose to go with the recommendations instead, you can reset the custom image you have set before.  After that, the default value will be used again.  Use `ceph config rm` to reset the configuration option:

```
ceph config rm mgr mgr/cephadm/<option_name>
```

For example:

```
ceph config rm mgr mgr/cephadm/container_image_prometheus
```

## Disabling monitoring

If you have deployed monitoring and would like to remove it, you can do so with:

```
ceph orch rm grafana
ceph orch rm prometheus --force   # this will delete metrics data collected so far
ceph orch rm node-exporter
ceph orch rm alertmanager
ceph mgr module disable prometheus
```

## Deploying monitoring manually

If you have an existing prometheus monitoring infrastructure, or would like to manage it yourself, you need to configure it to integrate with your Ceph cluster.

- Enable the prometheus module in the ceph-mgr daemon:

  ```
  ceph mgr module enable prometheus
  ```

  By default, ceph-mgr presents prometheus metrics on port 9283 on each host running a ceph-mgr daemon.  Configure prometheus to scrape these.

- To enable the dashboard’s prometheus-based alerting, see [Enabling Prometheus Alerting](https://docs.ceph.com/docs/master/mgr/dashboard/#dashboard-alerting).

- To enable dashboard integration with Grafana, see [Enabling the Embedding of Grafana Dashboards](https://docs.ceph.com/docs/master/mgr/dashboard/#dashboard-grafana).

## Enabling RBD-Image monitoring

Due to performance reasons, monitoring of RBD images is disabled by default. For more information please see [RBD IO statistics](https://docs.ceph.com/docs/master/mgr/prometheus/#prometheus-rbd-io-statistics). If disabled, the overview and details dashboards will stay empty in Grafana and the metrics will not be visible in Prometheus.

# Orchestrator CLI

This module provides a command line interface (CLI) to orchestrator modules (ceph-mgr modules which interface with external orchestration services).

As the orchestrator CLI unifies different external orchestrators, a common nomenclature for the orchestrator module is needed.

| *host*         | hostname (not DNS name) of the physical host. Not the podname, container name, or hostname inside the container. |
| -------------- | ------------------------------------------------------------ |
| *service type* | The type of the service. e.g., nfs, mds, osd, mon, rgw, mgr, iscsi |
| *service*      | A logical service, Typically comprised of multiple service instances on multiple hosts for HA `fs_name` for mds type `rgw_zone` for rgw type `ganesha_cluster_id` for nfs type |
| *daemon*       | A single instance of a service. Usually a daemon, but maybe not (e.g., might be a kernel service like LIO or knfsd or whatever) This identifier should uniquely identify the instance |

The relation between the names is the following:

- A *service* has a specfic *service type*
- A *daemon* is a physical instance of a *service type*

Note

Orchestrator modules may only implement a subset of the commands listed below. Also, the implementation of the commands are orchestrator module dependent and will differ between implementations.

## Status

```
ceph orch status
```

Show current orchestrator mode and high-level status (whether the module able to talk to it)

## Host Management

List hosts associated with the cluster:

```
ceph orch host ls
```

Add and remove hosts:

```
ceph orch host add <hostname> [<addr>] [<labels>...]
ceph orch host rm <hostname>
```

For cephadm, see also [Fully qualified domain names vs bare host names](https://docs.ceph.com/docs/master/cephadm/concepts/#cephadm-fqdn).

### Host Specification

Many hosts can be added at once using `ceph orch apply -i` by submitting a multi-document YAML file:

```
---
service_type: host
addr: node-00
hostname: node-00
labels:
- example1
- example2
---
service_type: host
addr: node-01
hostname: node-01
labels:
- grafana
---
service_type: host
addr: node-02
hostname: node-02
```

This can be combined with service specifications (below) to create a  cluster spec file to deploy a whole cluster in one command.  see `cephadm bootstrap --apply-spec` also to do this during bootstrap. Cluster SSH Keys must be copied to hosts prior.

## OSD Management

### List Devices

Print a list of discovered devices, grouped by host and optionally filtered to a particular host:

```
ceph orch device ls [--host=...] [--refresh]
```

Example:

```
HOST    PATH      TYPE   SIZE  DEVICE  AVAIL  REJECT REASONS
master  /dev/vda  hdd   42.0G          False  locked
node1   /dev/vda  hdd   42.0G          False  locked
node1   /dev/vdb  hdd   8192M  387836  False  locked, LVM detected, Insufficient space (<5GB) on vgs
node1   /dev/vdc  hdd   8192M  450575  False  locked, LVM detected, Insufficient space (<5GB) on vgs
node3   /dev/vda  hdd   42.0G          False  locked
node3   /dev/vdb  hdd   8192M  395145  False  LVM detected, locked, Insufficient space (<5GB) on vgs
node3   /dev/vdc  hdd   8192M  165562  False  LVM detected, locked, Insufficient space (<5GB) on vgs
node2   /dev/vda  hdd   42.0G          False  locked
node2   /dev/vdb  hdd   8192M  672147  False  LVM detected, Insufficient space (<5GB) on vgs, locked
node2   /dev/vdc  hdd   8192M  228094  False  LVM detected, Insufficient space (<5GB) on vgs, locked
```

### Erase Devices (Zap Devices)

Erase (zap) a device so that it can be resued. `zap` calls `ceph-volume zap` on the remote host.

```
orch device zap <hostname> <path>
```

Example command:

```
ceph orch device zap my_hostname /dev/sdx
```

Note

Cephadm orchestrator will automatically deploy drives that match the DriveGroup in your OSDSpec if the unmanaged flag is unset. For example, if you use the `all-available-devices` option when creating OSD’s, when you `zap` a device the cephadm orchestrator will automatically create a new OSD in the device . To disable this behavior, see [Create OSDs](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-create-osds).



### Create OSDs

Create OSDs on a set of devices on a single host:

```
ceph orch daemon add osd <host>:device1,device2
```

Another way of doing it is using `apply` interface:

```
ceph orch apply osd -i <json_file/yaml_file> [--dry-run]
```

Where the `json_file/yaml_file` is a DriveGroup specification. For a more in-depth guide to DriveGroups please refer to [OSD Service Specification](https://docs.ceph.com/docs/master/cephadm/drivegroups/#drivegroups)

Along with `apply` interface if `dry-run` option is used, it will present a preview of what will happen.

Example:

```
# ceph orch apply osd --all-available-devices --dry-run
NAME                  HOST  DATA     DB WAL
all-available-devices node1 /dev/vdb -  -
all-available-devices node2 /dev/vdc -  -
all-available-devices node3 /dev/vdd -  -
```

Note

Example output from cephadm orchestrator

When the parameter `all-available-devices` or a DriveGroup specification is used, a cephadm service is created. This service guarantees that all available devices or devices included in the DriveGroup will be used for OSD’s. Take into account the implications of this behavior, which is automatic and enabled by default.

For example:

After using:

```
ceph orch apply osd --all-available-devices
```

- If you add new disks to the cluster they will automatically be used to create new OSD’s.
- A new OSD will be created automatically if you remove an OSD and clean the LVM physical volume.

If you want to avoid this behavior (disable automatic creation of OSD in available devices), use the `unmanaged` parameter:

```
ceph orch apply osd --all-available-devices --unmanaged=true
```

In the case that you have already created the OSD’s using the `all-available-devices` service, you can change the automatic OSD creation using the following command:

```
ceph orch osd spec --service-name  osd.all-available-devices --unmanaged
```

### Remove an OSD

```
ceph orch osd rm <svc_id(s)> [--replace] [--force]
```

Evacuates PGs from an OSD and removes it from the cluster.

Example:

```
# ceph orch osd rm 0
Scheduled OSD(s) for removal
```

OSDs that are not safe-to-destroy will be rejected.

You can query the state of the operation with:

```
# ceph orch osd rm status
OSD_ID  HOST         STATE                    PG_COUNT  REPLACE  FORCE  STARTED_AT
2       cephadm-dev  done, waiting for purge  0         True     False  2020-07-17 13:01:43.147684
3       cephadm-dev  draining                 17        False    True   2020-07-17 13:01:45.162158
4       cephadm-dev  started                  42        False    True   2020-07-17 13:01:45.162158
```

When no PGs are left on the osd, it will be decommissioned and removed from the cluster.

Note

After removing an OSD, if you wipe the LVM physical volume in the device used by the removed OSD, a new OSD will be created. Read information about the `unmanaged` parameter in [Create OSDs](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-create-osds).

### Stopping OSD Removal

You can stop the operation with

```
ceph orch osd rm stop <svc_id(s)>
```

Example:

```
# ceph orch osd rm stop 4
Stopped OSD(s) removal
```

This will reset the initial state of the OSD and remove it from the queue.

### Replace an OSD

```
orch osd rm <svc_id(s)> --replace [--force]
```

Example:

```
# ceph orch osd rm 4 --replace
Scheduled OSD(s) for replacement
```

This follows the same procedure as the “Remove OSD” part with the exception that the OSD is not permanently removed from the crush hierarchy, but is assigned a ‘destroyed’ flag.

**Preserving the OSD ID**

The previously set the ‘destroyed’ flag is used to determined osd ids that will be reused in the next osd deployment.

If you use OSDSpecs for osd deployment, your newly added disks will be assigned with the osd ids of their replaced counterpart, granted the new disk still match the OSDSpecs.

For assistance in this process you can use the ‘–dry-run’ feature:

Tip: The name of your OSDSpec can be retrieved from **ceph orch ls**

Alternatively, you can use your OSDSpec file:

```
ceph orch apply osd -i <osd_spec_file> --dry-run
NAME                  HOST  DATA     DB WAL
<name_of_osd_spec>    node1 /dev/vdb -  -
```

If this matches your anticipated behavior, just omit the –dry-run flag to execute the deployment.

## Monitor and manager management

Creates or removes MONs or MGRs from the cluster. Orchestrator may return an error if it doesn’t know how to do this transition.

Update the number of monitor hosts:

```
ceph orch apply mon <num> [host, host:network...] [--dry-run]
```

Each host can optionally specify a network for the monitor to listen on.

Update the number of manager hosts:

```
ceph orch apply mgr <num> [host...] [--dry-run]
```

## Service Status

Print a list of services known to the orchestrator. The list can be limited to services on a particular host with the optional –host parameter and/or services of a particular type via optional –type parameter (mon, osd, mgr, mds, rgw):

```
ceph orch ls [--service_type type] [--service_name name] [--export] [--format f] [--refresh]
```

Discover the status of a particular service or daemons:

```
ceph orch ls --service_type type --service_name <name> [--refresh]
```

Export the service specs known to the orchestrator as yaml in format that is compatible to `ceph orch apply -i`:

```
ceph orch ls --export
```

## Daemon Status

Print a list of all daemons known to the orchestrator:

```
ceph orch ps [--hostname host] [--daemon_type type] [--service_name name] [--daemon_id id] [--format f] [--refresh]
```

Query the status of a particular service instance (mon, osd, mds, rgw).  For OSDs the id is the numeric OSD ID, for MDS services it is the file system name:

```
ceph orch ps --daemon_type osd --daemon_id 0
```



## Depoying CephFS

In order to set up a [CephFS](https://docs.ceph.com/docs/master/glossary/#term-cephfs), execute:

```
ceph fs volume create <fs_name> <placement spec>
```

Where `name` is the name of the CephFS, `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec).

This command will create the required Ceph pools, create the new CephFS, and deploy mds servers.

## Stateless services (MDS/RGW/NFS/rbd-mirror/iSCSI)

The orchestrator is not responsible for configuring the services. Please look into the corresponding documentation for details.

The `name` parameter is an identifier of the group of instances:

- a CephFS file system for a group of MDS daemons,
- a zone name for a group of RGWs

Creating/growing/shrinking/removing services:

```
ceph orch apply mds <fs_name> [--placement=<placement>] [--dry-run]
ceph orch apply rgw <realm> <zone> [--subcluster=<subcluster>] [--port=<port>] [--ssl] [--placement=<placement>] [--dry-run]
ceph orch apply nfs <name> <pool> [--namespace=<namespace>] [--placement=<placement>] [--dry-run]
ceph orch rm <service_name> [--force]
```

Where `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec).

e.g., `ceph orch apply mds myfs --placement="3 host1 host2 host3"`

Service Commands:

```
ceph orch <start|stop|restart|redeploy|reconfig> <service_name>
```



## Service Specification

As *Service Specification* is a data structure often represented as YAML to specify the deployment of services. For example:

```
service_type: rgw
service_id: realm.zone
placement:
  hosts:
    - host1
    - host2
    - host3
spec: ...
unmanaged: false
```

Where the properties of a service specification are the following:

- - `service_type` is the type of the service. Needs to be either a Ceph

    service (`mon`, `crash`, `mds`, `mgr`, `osd` or `rbd-mirror`), a gateway (`nfs` or `rgw`), or part of the monitoring stack (`alertmanager`, `grafana`, `node-exporter` or `prometheus`).

- `service_id` is the name of the service. Omit the service time

- `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec)

- `spec`: additional specifications for a specific service.

- - `unmanaged`: If set to `true`, the orchestrator will not deploy nor

    remove any daemon associated with this service. Placement and all other properties will be ignored. This is useful, if this service should not be managed temporarily.

Each service type can have different requirements for the spec.

Service specifications of type `mon`, `mgr`, and the monitoring types do not require a `service_id`

A service of type `nfs` requires a pool name and contain an optional namespace:

```
service_type: nfs
service_id: mynfs
placement:
  hosts:
    - host1
    - host2
spec:
  pool: mypool
  namespace: mynamespace
```

Where `pool` is a RADOS pool where NFS client recovery data is stored and `namespace` is a RADOS namespace where NFS client recovery data is stored in the pool.

A service of type `osd` is in detail described in [OSD Service Specification](https://docs.ceph.com/docs/master/cephadm/drivegroups/#drivegroups)

Many service specifications can then be applied at once using `ceph orch apply -i` by submitting a multi-document YAML file:

```
cat <<EOF | ceph orch apply -i -
service_type: mon
placement:
  host_pattern: "mon*"
---
service_type: mgr
placement:
  host_pattern: "mgr*"
---
service_type: osd
service_id: default_drive_group
placement:
  host_pattern: "osd*"
data_devices:
  all: true
EOF
```



## Placement Specification

In order to allow the orchestrator to deploy a *service*, it needs to know how many and where it should deploy *daemons*. The orchestrator defines a placement specification that can either be passed as a command line argument.

### Explicit placements

Daemons can be explictly placed on hosts by simply specifying them:

```
orch apply prometheus "host1 host2 host3"
```

Or in yaml:

```
service_type: prometheus
placement:
  hosts:
    - host1
    - host2
    - host3
```

MONs and other services may require some enhanced network specifications:

```
orch daemon add mon myhost:[v2:1.2.3.4:3000,v1:1.2.3.4:6789]=name
```

Where `[v2:1.2.3.4:3000,v1:1.2.3.4:6789]` is the network address of the monitor and `=name` specifies the name of the new monitor.

### Placement by labels

Daemons can be explictly placed on hosts that match a specifc label:

```
orch apply prometheus label:mylabel
```

Or in yaml:

```
service_type: prometheus
placement:
  label: "mylabel"
```

### Placement by pattern matching

Daemons can be placed on hosts as well:

```
orch apply prometheus 'myhost[1-3]'
```

Or in yaml:

```
service_type: prometheus
placement:
  host_pattern: "myhost[1-3]"
```

To place a service on *all* hosts, use `"*"`:

```
orch apply crash '*'
```

Or in yaml:

```
service_type: node-exporter
placement:
  host_pattern: "*"
```

### Setting a limit

By specifying `count`, only that number of daemons will be created:

```
orch apply prometheus 3
```

To deploy *daemons* on a subset of hosts, also specify the count:

```
orch apply prometheus "2 host1 host2 host3"
```

If the count is bigger than the amount of hosts, cephadm still deploys two daemons:

```
orch apply prometheus "3 host1 host2"
```

Or in yaml:

```
service_type: prometheus
placement:
  count: 3
```

Or with hosts:

```
service_type: prometheus
placement:
  count: 2
  hosts:
    - host1
    - host2
    - host3
```

## Updating Service Specifications

The Ceph Orchestrator maintains a declarative state of each service in a `ServiceSpec`. For certain operations, like updating the RGW HTTP port, we need to update the existing specification.

1. List the current `ServiceSpec`:

   ```
   ceph orch ls --service_name=<service-name> --export > myservice.yaml
   ```

2. Update the yaml file:

   ```
   vi myservice.yaml
   ```

3. Apply the new `ServiceSpec`:

   ```
   ceph orch apply -i myservice.yaml [--dry-run]
   ```

## Configuring the Orchestrator CLI

To enable the orchestrator, select the orchestrator module to use with the `set backend` command:

```
ceph orch set backend <module>
```

For example, to enable the Rook orchestrator module and use it with the CLI:

```
ceph mgr module enable rook
ceph orch set backend rook
```

Check the backend is properly configured:

```
ceph orch status
```

### Disable the Orchestrator

To disable the orchestrator, use the empty string `""`:

```
ceph orch set backend ""
ceph mgr module disable rook
```

## Current Implementation Status

This is an overview of the current implementation status of the orchestrators.

| Command                       | Rook | Cephadm |
| ----------------------------- | ---- | ------- |
| apply iscsi                   | ⚪    | ✔       |
| apply mds                     | ✔    | ✔       |
| apply mgr                     | ⚪    | ✔       |
| apply mon                     | ✔    | ✔       |
| apply nfs                     | ✔    | ✔       |
| apply osd                     | ✔    | ✔       |
| apply rbd-mirror              | ✔    | ✔       |
| apply rgw                     | ⚪    | ✔       |
| host add                      | ⚪    | ✔       |
| host ls                       | ✔    | ✔       |
| host rm                       | ⚪    | ✔       |
| daemon status                 | ⚪    | ✔       |
| daemon {stop,start,…}         | ⚪    | ✔       |
| device {ident,fault}-(on,off} | ⚪    | ✔       |
| device ls                     | ✔    | ✔       |
| iscsi add                     | ⚪    | ✔       |
| mds add                       | ✔    | ✔       |
| nfs add                       | ✔    | ✔       |
| rbd-mirror add                | ⚪    | ✔       |
| rgw add                       | ✔    | ✔       |
| ps                            | ✔    | ✔       |

where

- ⚪ = not yet implemented
- ❌ = not applicable
- ✔ = implemented

# Basic Ceph Client Setup

Client machines need some basic configuration in order to interact with a cluster. This document describes how to configure a client machine for cluster interaction.

Note

Most client machines only need the ceph-common package and its dependencies installed. That will supply the basic ceph and rados commands, as well as other commands like mount.ceph and rbd.

## Config File Setup

Client machines can generally get away with a smaller config file than a full-fledged cluster member. To generate a minimal config file, log into a host that is already configured as a client or running a cluster daemon, and then run:

```
ceph config generate-minimal-conf
```

This will generate a minimal config file that will tell the client how to reach the Ceph Monitors. The contents of this file should typically be installed in /etc/ceph/ceph.conf.

## Keyring Setup

Most Ceph clusters are run with authentication enabled, and the client will need keys in order to communicate with cluster machines. To generate a keyring file with credentials for client.fs, log into an extant cluster member and run:

```
ceph auth get-or-create client.fs
```

The resulting output should be put into a keyring file, typically /etc/ceph/ceph.keyring.

# OSD Service Specification

[Service Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-service-spec) of type `osd` are a way to describe a cluster layout using the properties of disks. It gives the user an abstract way tell ceph which disks should turn into an OSD with which configuration without knowing the specifics of device names and paths.

Instead of doing this:

```
[monitor 1] # ceph orch daemon add osd *<host>*:*<path-to-device>*
```

for each device and each host, we can define a yaml|json file that allows us to describe the layout. Here’s the most basic example.

Create a file called i.e. osd_spec.yml

```
service_type: osd
service_id: default_drive_group  <- name of the drive_group (name can be custom)
placement:
  host_pattern: '*'              <- which hosts to target, currently only supports globs
data_devices:                    <- the type of devices you are applying specs to
  all: true                      <- a filter, check below for a full list
```

This would translate to:

Turn any available(ceph-volume decides what ‘available’ is) into an OSD on all hosts that match the glob pattern ‘*’. (The glob pattern matches against the registered hosts from host ls) There will be a more detailed section on host_pattern down below.

and pass it to osd create like so:

```
[monitor 1] # ceph orch apply osd -i /path/to/osd_spec.yml
```

This will go out on all the matching hosts and deploy these OSDs.

Since we want to have more complex setups, there are more filters than just the ‘all’ filter.

Also, there is a –dry-run flag that can be passed to the apply osd command, which gives you a synopsis of the proposed layout.

Example:

```
[monitor 1] # ceph orch apply osd -i /path/to/osd_spec.yml --dry-run
```

## Filters

Note

Filters are applied using a AND gate by default. This essentially means that a drive needs to fulfill all filter criteria in order to get selected. If you wish to change this behavior you can adjust this behavior by setting

> filter_logic: OR  # valid arguments are AND, OR

in the OSD Specification.

You can assign disks to certain groups by their attributes using filters.

The attributes are based off of ceph-volume’s disk query. You can retrieve the information with:

```
ceph-volume inventory </path/to/disk>
```

### Vendor or Model:

You can target specific disks by their Vendor or by their Model

```
model: disk_model_name
```

or

```
vendor: disk_vendor_name
```

### Size:

You can also match by disk Size.

```
size: size_spec
```

#### Size specs:

Size specification of format can be of form:

- LOW:HIGH
- :HIGH
- LOW:
- EXACT

Concrete examples:

Includes disks of an exact size:

```
size: '10G'
```

Includes disks which size is within the range:

```
size: '10G:40G'
```

Includes disks less than or equal to 10G in size:

```
size: ':10G'
```

Includes disks equal to or greater than 40G in size:

```
size: '40G:'
```

Sizes don’t have to be exclusively in Gigabyte(G).

Supported units are Megabyte(M), Gigabyte(G) and Terrabyte(T). Also appending the (B) for byte is supported. MB, GB, TB

### Rotational:

This operates on the ‘rotational’ attribute of the disk.

```
rotational: 0 | 1
```

1 to match all disks that are rotational

0 to match all disks that are non-rotational (SSD, NVME etc)

### All:

This will take all disks that are ‘available’

Note: This is exclusive for the data_devices section.

```
all: true
```

### Limiter:

When you specified valid filters but want to limit the amount of matching disks you can use the ‘limit’ directive.

```
limit: 2
```

For example, if you used vendor to match all disks that are from VendorA but only want to use the first two you could use limit.

```
data_devices:
  vendor: VendorA
  limit: 2
```

Note: Be aware that limit is really just a last resort and shouldn’t be used if it can be avoided.

## Additional Options

There are multiple optional settings you can use to change the way OSDs are deployed. You can add these options to the base level of a DriveGroup for it to take effect.

This example would deploy all OSDs with encryption enabled.

```
service_type: osd
service_id: example_osd_spec
placement:
  host_pattern: '*'
data_devices:
  all: true
encrypted: true
```

See a full list in the DriveGroupSpecs

- *class* `ceph.deployment.drive_group.``DriveGroupSpec`(*placement=None*, *service_id=None*, *data_devices=None*, *db_devices=None*, *wal_devices=None*, *journal_devices=None*, *data_directories=None*, *osds_per_device=None*, *objectstore='bluestore'*, *encrypted=False*, *db_slots=None*, *wal_slots=None*, *osd_id_claims=None*, *block_db_size=None*, *block_wal_size=None*, *journal_size=None*, *service_type=None*, *unmanaged=False*, *filter_logic='AND'*, *preview_only=False*)

  Describe a drive group in the same form that ceph-volume understands.  `block_db_size` *= None* Set (or override) the “bluestore_block_db_size” value, in bytes   `block_wal_size` *= None* Set (or override) the “bluestore_block_wal_size” value, in bytes   `data_devices` *= None* A `ceph.deployment.drive_group.DeviceSelection`   `data_directories` *= None* A list of strings, containing paths which should back OSDs   `db_devices` *= None* A `ceph.deployment.drive_group.DeviceSelection`   `db_slots` *= None* How many OSDs per DB device   `encrypted` *= None* `true` or `false`   `filter_logic` *= None* The logic gate we use to match disks with filters. defaults to ‘AND’   `journal_devices` *= None* A `ceph.deployment.drive_group.DeviceSelection`   `journal_size` *= None* set journal_size in bytes   `objectstore` *= None* `filestore` or `bluestore`   `osd_id_claims` *= None* Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/docs/master/mgr/orchestrator_modules/#orchestrator-osd-replace)   `osds_per_device` *= None* Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required.   `preview_only` *= None* If this should be treated as a ‘preview’ spec   `wal_devices` *= None* A `ceph.deployment.drive_group.DeviceSelection`   `wal_slots` *= None* How many OSDs per WAL device

## Examples

### The simple case

All nodes with the same setup:

```
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

This is a common setup and can be described quite easily:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: HDD-123-foo <- note that HDD-123 would also be valid
db_devices:
  model: MC-55-44-XZ <- same here, MC-55-44 is valid
```

However, we can improve it by reducing the filters on core properties of the drives:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  rotational: 1
db_devices:
  rotational: 0
```

Now, we enforce all rotating devices to be declared as ‘data devices’ and all non-rotating devices will be used as shared_devices (wal, db)

If you know that drives with more than 2TB will always be the slower data devices, you can also filter by size:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  size: '2TB:'
db_devices:
  size: ':2TB'
```

Note: All of the above DriveGroups are equally valid. Which of those  you want to use depends on taste and on how much you expect your node  layout to change.

### The advanced case

Here we have two distinct setups:

```
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

12 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

- 20 HDDs should share 2 SSDs
- 10 SSDs should share 2 NVMes

This can be described with two layouts.

```
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
data_devices:
  rotational: 0
db_devices:
  model: MC-55-44-XZ
  limit: 2 (db_slots is actually to be favoured here, but it's not implemented yet)

service_type: osd
service_id: osd_spec_ssd
placement:
  host_pattern: '*'
data_devices:
  model: MC-55-44-XZ
db_devices:
  vendor: VendorC
```

This would create the desired layout by using all HDDs as data_devices with two SSD assigned as dedicated db/wal devices. The remaining SSDs(8) will be data_devices that have the ‘VendorC’ NVMEs assigned as dedicated db/wal devices.

### The advanced case (with non-uniform nodes)

The examples above assumed that all nodes have the same drives. That’s however not always the case.

Node1-5:

```
20 HDDs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
2 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

Node6-10:

```
5 NVMEs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
20 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

You can use the ‘host_pattern’ key in the layout to target certain nodes. Salt target notation helps to keep things easy.

```
service_type: osd
service_id: osd_spec_node_one_to_five
placement:
  host_pattern: 'node[1-5]'
data_devices:
  rotational: 1
db_devices:
  rotational: 0


service_type: osd
service_id: osd_spec_six_to_ten
placement:
  host_pattern: 'node[6-10]'
data_devices:
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
```

This applies different OSD specs to different hosts depending on the host_pattern key.

### Dedicated wal + db

All previous cases co-located the WALs with the DBs. It’s however possible to deploy the WAL on a dedicated device as well, if it makes sense.

```
20 HDDs
Vendor: VendorA
Model: SSD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

The OSD spec for this case would look like the following (using the model filter):

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
wal_devices:
  model: NVME-QQQQ-987
```

This can easily be done with other filters, like size or vendor as well.

# Troubleshooting

Sometimes there is a need to investigate why a cephadm command failed or why a specific service no longer runs properly.

As cephadm deploys daemons as containers, troubleshooting daemons is slightly different. Here are a few tools and commands to help investigating issues.

## Pausing or disabling cephadm

If something goes wrong and cephadm is doing behaving in a way you do not like, you can pause most background activity with:

```
ceph orch pause
```

This will stop any changes, but cephadm will still periodically check hosts to refresh its inventory of daemons and devices.  You can disable cephadm completely with:

```
ceph orch set backend ''
ceph mgr module disable cephadm
```

This will disable all of the `ceph orch ...` CLI commands but the previously deployed daemon containers will still continue to exist and start as they did before.

## Checking cephadm logs

You can monitor the cephadm log in real time with:

```
ceph -W cephadm
```

You can see the last few messages with:

```
ceph log last cephadm
```

If you have enabled logging to files, you can see a cephadm log file called `ceph.cephadm.log` on monitor hosts (see [Ceph daemon logs](https://docs.ceph.com/docs/master/cephadm/operations/#cephadm-logs)).

## Gathering log files

Use journalctl to gather the log files of all daemons:

Note

By default cephadm now stores logs in journald. This means that you will no longer find daemon logs in `/var/log/ceph/`.

To read the log file of one specific daemon, run:

```
cephadm logs --name <name-of-daemon>
```

Note: this only works when run on the same host where the daemon is running. To get logs of a daemon running on a different host, give the `--fsid` option:

```
cephadm logs --fsid <fsid> --name <name-of-daemon>
```

where the `<fsid>` corresponds to the cluster ID printed by `ceph status`.

To fetch all log files of all daemons on a given host, run:

```
for name in $(cephadm ls | jq -r '.[].name') ; do
  cephadm logs --fsid <fsid> --name "$name" > $name;
done
```

## Collecting systemd status

To print the state of a systemd unit, run:

```
systemctl status "ceph-$(cephadm shell ceph fsid)@<service name>.service";
```

To fetch all state of all daemons of a given host, run:

```
fsid="$(cephadm shell ceph fsid)"
for name in $(cephadm ls | jq -r '.[].name') ; do
  systemctl status "ceph-$fsid@$name.service" > $name;
done
```

## List all downloaded container images

To list all container images that are downloaded on a host:

Note

`Image` might also be called ImageID

```
podman ps -a --format json | jq '.[].Image'
"docker.io/library/centos:8"
"registry.opensuse.org/opensuse/leap:15.2"
```

## Manually running containers

Cephadm writes small wrappers that run a containers. Refer to `/var/lib/ceph/<cluster-fsid>/<service-name>/unit.run` for the container execution command.



## ssh errors

Error message:

```
xxxxxx.gateway_bootstrap.HostNotFound: -F /tmp/cephadm-conf-kbqvkrkw root@10.10.1.2
raise OrchestratorError('Failed to connect to %s (%s).  Check that the host is reachable and accepts  connections using the cephadm SSH key' % (host, addr)) from
orchestrator._interface.OrchestratorError: Failed to connect to 10.10.1.2 (10.10.1.2).  Check that the host is reachable and accepts connections using the cephadm SSH key
```

Things users can do:

1. Ensure cephadm has an SSH identity key:

   ```
   [root@mon1~]# cephadm shell -- ceph config-key get mgr/cephadm/ssh_identity_key > key
   INFO:cephadm:Inferring fsid f8edc08a-7f17-11ea-8707-000c2915dd98
   INFO:cephadm:Using recent ceph image docker.io/ceph/ceph:v15 obtained 'mgr/cephadm/ssh_identity_key'
   [root@mon1 ~] # chmod 0600 key
   ```

> If this fails, cephadm doesn’t have a key. Fix this by running the following command:
>
> ```
> [root@mon1 ~]# cephadm shell -- ceph cephadm generate-ssh-key
> ```
>
> or:
>
> ```
> [root@mon1 ~]# cat key | cephadm shell -- ceph cephadm set-ssk-key -i -
> ```

1. Ensure that the ssh config is correct:

   ```
   [root@mon1 ~]# cephadm shell -- ceph cephadm get-ssh-config > config
   ```

2. Verify that we can connect to the host:

   ```
   [root@mon1 ~]# ssh -F config -i key root@mon1
   ```

3. There is a limitation right now: the ssh user is always root.

### Verifying that the Public Key is Listed in the authorized_keys file

To verify that the public key is in the authorized_keys file, run the following commands:

```
[root@mon1 ~]# cephadm shell -- ceph config-key get mgr/cephadm/ssh_identity_pub > key.pub
[root@mon1 ~]# grep "`cat key.pub`"  /root/.ssh/authorized_keys
```

## Failed to infer CIDR network error

If you see this error:

```
ERROR: Failed to infer CIDR network for mon ip ***; pass --skip-mon-network to configure it later
```

Or this error:

```
Must set public_network config option or specify a CIDR network, ceph addrvec, or plain IP
```

This means that you must run a command of this form:

```
ceph config set mon public_network <mon_network>
```

For more detail on operations of this kind, see [Deploy additional monitors (optional)](https://docs.ceph.com/docs/master/cephadm/install/#deploy-additional-monitors)

## Accessing the admin socket

Each Ceph daemon provides an admin socket that bypasses the MONs (See [Using the Admin Socket](https://docs.ceph.com/docs/master/rados/operations/monitoring/#rados-monitoring-using-admin-socket)).

To access the admin socket, first enter the daemon container on the host:

```
[root@mon1 ~]# cephadm enter --name <daemon-name>
[ceph: root@mon1 /]# ceph --admin-daemon /var/run/ceph/ceph-<daemon-name>.asok config show
```

# Cephadm Concepts



## Fully qualified domain names vs bare host names

cephadm has very minimal requirements when it comes to resolving host names etc. When cephadm initiates an ssh connection to a remote host, the host name  can be resolved in four different ways:

- a custom ssh config resolving the name to an IP
- via an externally maintained `/etc/hosts`
- via explicitly providing an IP address to cephadm: `ceph orch host add <hostname> <IP>`
- automatic name resolution via DNS.

Ceph itself uses the command `hostname` to determine the name of the current host.

Note

cephadm demands that the name of the host given via `ceph orch host add` equals the output of `hostname` on remote hosts.

Otherwise cephadm can’t be sure, the host names returned by `ceph * metadata` match the hosts known to cephadm. This might result in a [CEPHADM_STRAY_HOST](https://docs.ceph.com/docs/master/cephadm/operations/#cephadm-stray-host) warning.

When configuring new hosts, there are two **valid** ways to set the `hostname` of a host:

1. Using the bare host name. In this case:

- `hostname` returns the bare host name.
- `hostname -f` returns the FQDN.

1. Using the fully qualified domain name as the host name. In this case:

- `hostname` returns the FQDN
- `hostname -s` return the bare host name

Note that `man hostname` recommends `hostname` to return the bare host name:

> The FQDN (Fully Qualified Domain Name) of the system is the name that the resolver(3) returns for the host name, such as, ursula.example.com. It is usually the hostname followed by the DNS domain name (the part after the first dot). You can check the FQDN using `hostname --fqdn` or the domain name using `dnsdomainname`.
>
> ```
> You cannot change the FQDN with hostname or dnsdomainname.
> 
> The recommended method of setting the FQDN is to make the hostname
> be an alias for the fully qualified name using /etc/hosts, DNS, or
> NIS. For example, if the hostname was "ursula", one might have
> a line in /etc/hosts which reads
> 
>     127.0.1.1    ursula.example.com ursula
> ```

Which means, `man hostname` recommends `hostname` to return the bare host name. This in turn means that Ceph will return the bare host names when executing `ceph * metadata`. This in turn means cephadm also requires the bare host name when adding a host to the cluster: `ceph orch host add <bare-name>`.

## Cephadm Scheduler

Cephadm uses a declarative state to define the layout of the cluster. This state consists of a list of service specifications containing placement specifications (See [Service Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-service-spec) ).

Cephadm constantly compares list of actually running daemons in the cluster with the desired service specifications and will either add or remove new daemons.

First, cephadm will select a list of candidate hosts. It first looks for explicit host names and will select those. In case there are no explicit hosts defined, cephadm looks for a label specification. If there is no label defined in the specification, cephadm will select hosts based on a host pattern. If there is no pattern defined, cepham will finally select all known hosts as candidates.

Then, cephadm will consider existing daemons of this services and will try to avoid moving any daemons.

Cephadm supports the deployment of a specific amount of services. Let’s consider a service specification like so:

```
service_type: mds
service_name: myfs
placement:
  count: 3
  label: myfs
```

This instructs cephadm to deploy three daemons on hosts labeled with `myfs` across the cluster.

Then, in case there are less than three daemons deployed on the candidate hosts, cephadm will then then randomly choose hosts for deploying new daemons.

In case there are more than three daemons deployed, cephadm will remove existing daemons.

Finally, cephadm will remove daemons on hosts that are outside of the list of candidate hosts.

However, there is a special cases that cephadm needs to consider.

In case the are fewer hosts selected by the placement specification than demanded by `count`, cephadm will only deploy on selected hosts.







# Converting an existing cluster to cephadm

Cephadm allows you to convert an existing Ceph cluster that has been deployed with ceph-deploy, ceph-ansible, DeepSea, or similar tools.

## Limitations

- Cephadm only works with BlueStore OSDs.  If there are FileStore OSDs in your cluster you cannot manage them.

## Preparation

1. Get the `cephadm` command line tool on each host in the existing cluster.  See [Install cephadm](https://docs.ceph.com/docs/master/cephadm/install/#get-cephadm).

2. Prepare each host for use by `cephadm`:

   ```
   # cephadm prepare-host
   ```

3. Determine which Ceph version you will use.  You can use any Octopus (15.2.z) release or later.  For example, `docker.io/ceph/ceph:v15.2.0`.  The default will be the latest stable release, but if you are upgrading from an earlier release at the same time be sure to refer to the upgrade notes for any special steps to take while upgrading.

   The image is passed to cephadm with:

   ```
   # cephadm --image $IMAGE <rest of command goes here>
   ```

4. Cephadm can provide a list of all Ceph daemons on the current host:

   ```
   # cephadm ls
   ```

   Before starting, you should see that all existing daemons have a style of `legacy` in the resulting output.  As the adoption process progresses, adopted daemons will appear as style `cephadm:v1`.

## Adoption process

1. Ensure the ceph configuration is migrated to use the cluster config database. If the `/etc/ceph/ceph.conf` is identical on each host, then on one host:

   ```
   # ceph config assimilate-conf -i /etc/ceph/ceph.conf
   ```

   If there are config variations on each host, you may need to repeat this command on each host.  You can view the cluster’s configuration to confirm that it is complete with:

   ```
   # ceph config dump
   ```

2. Adopt each monitor:

   ```
   # cephadm adopt --style legacy --name mon.<hostname>
   ```

   Each legacy monitor should stop, quickly restart as a cephadm container, and rejoin the quorum.

3. Adopt each manager:

   ```
   # cephadm adopt --style legacy --name mgr.<hostname>
   ```

4. Enable cephadm:

   ```
   # ceph mgr module enable cephadm
   # ceph orch set backend cephadm
   ```

5. Generate an SSH key:

   ```
   # ceph cephadm generate-key
   # ceph cephadm get-pub-key > ~/ceph.pub
   ```

6. Install the cluster SSH key on each host in the cluster:

   ```
   # ssh-copy-id -f -i ~/ceph.pub root@<host>
   ```

   Note

   It is also possible to import an existing ssh key. See [ssh errors](https://docs.ceph.com/docs/master/cephadm/troubleshooting/#cephadm-ssh-errors) in the troubleshooting document for instructions describing how to import existing ssh keys.

7. Tell cephadm which hosts to manage:

   ```
   # ceph orch host add <hostname> [ip-address]
   ```

   This will perform a `cephadm check-host` on each host before adding it to ensure it is working.  The IP address argument is only required if DNS does not allow you to connect to each host by its short name.

8. Verify that the adopted monitor and manager daemons are visible:

   ```
   # ceph orch ps
   ```

9. Adopt all OSDs in the cluster:

   ```
   # cephadm adopt --style legacy --name <name>
   ```

   For example:

   ```
   # cephadm adopt --style legacy --name osd.1
   # cephadm adopt --style legacy --name osd.2
   ```

10. Redeploy MDS daemons by telling cephadm how many daemons to run for each file system.  You can list file systems by name with `ceph fs ls`.  Run the following command on the master nodes:

    ```
    # ceph orch apply mds <fs-name> [--placement=<placement>]
    ```

    For example, in a cluster with a single file system called foo:

    ```
    # ceph fs ls
    name: foo, metadata pool: foo_metadata, data pools: [foo_data ]
    # ceph orch apply mds foo 2
    ```

    Wait for the new MDS daemons to start with:

    ```
    # ceph orch ps --daemon-type mds
    ```

    Finally, stop and remove the legacy MDS daemons:

    ```
    # systemctl stop ceph-mds.target
    # rm -rf /var/lib/ceph/mds/ceph-*
    ```

11. Redeploy RGW daemons.  Cephadm manages RGW daemons by zone.  For each zone, deploy new RGW daemons with cephadm:

    ```
    # ceph orch apply rgw <realm> <zone> [--subcluster=<subcluster>] [--port=<port>] [--ssl] [--placement=<placement>]
    ```

    where *<placement>* can be a simple daemon count, or a list of specific hosts (see [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec)).

    Once the daemons have started and you have confirmed they are functioning, stop and remove the old legacy daemons:

    ```
    # systemctl stop ceph-rgw.target
    # rm -rf /var/lib/ceph/radosgw/ceph-*
    ```

    For adopting single-site systems without a realm, see also [Migrating a Single Site System to Multi-Site](https://docs.ceph.com/docs/master/radosgw/multisite/#rgw-multisite-migrate-from-single-site).

12. Check the `ceph health detail` output for cephadm warnings about stray cluster daemons or hosts that are not yet managed.

# Upgrading Ceph

Cephadm is capable of safely upgrading Ceph from one bugfix release to another.  For example, you can upgrade from v15.2.0 (the first Octopus release) to the next point release v15.2.1.

The automated upgrade process follows Ceph best practices.  For example:

- The upgrade order starts with managers, monitors, then other daemons.
- Each daemon is restarted only after Ceph indicates that the cluster will remain available.

Keep in mind that the Ceph cluster health status is likely to switch to HEALTH_WARNING during the upgrade.

## Starting the upgrade

Before you start, you should verify that all hosts are currently online and your cluster is healthy.

```
# ceph -s
```

To upgrade (or downgrade) to a specific release:

```
# ceph orch upgrade start --ceph-version <version>
```

For example, to upgrade to v15.2.1:

```
# ceph orch upgrade start --ceph-version 15.2.1
```

## Monitoring the upgrade

Determine whether an upgrade is in process and what version the cluster is upgrading to with:

```
# ceph orch upgrade status
```

While the upgrade is underway, you will see a progress bar in the ceph status output.  For example:

```
# ceph -s
[...]
  progress:
    Upgrade to docker.io/ceph/ceph:v15.2.1 (00h 20m 12s)
      [=======.....................] (time remaining: 01h 43m 31s)
```

You can also watch the cephadm log with:

```
# ceph -W cephadm
```

## Canceling an upgrade

You can stop the upgrade process at any time with:

```
# ceph orch upgrade stop
```

## Potential problems

There are a few health alerts that can arise during the upgrade process.

### UPGRADE_NO_STANDBY_MGR

Ceph requires an active and standby manager daemon in order to proceed, but there is currently no standby.

You can ensure that Cephadm is configured to run 2 (or more) managers with:

```
# ceph orch apply mgr 2  # or more
```

You can check the status of existing mgr daemons with:

```
# ceph orch ps --daemon-type mgr
```

If an existing mgr daemon has stopped, you can try restarting it with:

```
# ceph orch daemon restart <name>
```

### UPGRADE_FAILED_PULL

Ceph was unable to pull the container image for the target version. This can happen if you specify an version or container image that does not exist (e.g., 1.2.3), or if the container registry is not reachable from one or more hosts in the cluster.

You can cancel the existing upgrade and specify a different target version with:

```
# ceph orch upgrade stop
# ceph orch upgrade start --ceph-version <version>
```

## Using customized container images

For most users, simplify specifying the Ceph version is sufficient. Cephadm will locate the specific Ceph container image to use by combining the `container_image_base` configuration option (default: `docker.io/ceph/ceph`) with a tag of `vX.Y.Z`.

You can also upgrade to an arbitrary container image.  For example, to upgrade to a development build:

```
# ceph orch upgrade start --image quay.io/ceph-ci/ceph:recent-git-branch-name
```

For more information about available container images, see [Ceph Container Images](https://docs.ceph.com/docs/master/install/containers/#containers).

# Cephadm Operations

## Watching cephadm log messages

Cephadm logs to the `cephadm` cluster log channel, meaning you can monitor progress in realtime with:

```
# ceph -W cephadm
```

By default it will show info-level events and above.  To see debug-level messages too:

```
# ceph config set mgr mgr/cephadm/log_to_cluster_level debug
# ceph -W cephadm --watch-debug
```

Be careful: the debug messages are very verbose!

You can see recent events with:

```
# ceph log last cephadm
```

These events are also logged to the `ceph.cephadm.log` file on monitor hosts and to the monitor daemons’ stderr.



## Ceph daemon logs

### Logging to stdout

Traditionally, Ceph daemons have logged to `/var/log/ceph`.  By default, cephadm daemons log to stderr and the logs are captured by the container runtime environment.  For most systems, by default, these logs are sent to journald and accessible via `journalctl`.

For example, to view the logs for the daemon `mon.foo` for a cluster with ID `5c5a50ae-272a-455d-99e9-32c6a013e694`, the command would be something like:

```
journalctl -u ceph-5c5a50ae-272a-455d-99e9-32c6a013e694@mon.foo
```

This works well for normal operations when logging levels are low.

To disable logging to stderr:

```
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
```

### Logging to files

You can also configure Ceph daemons to log to files instead of stderr, just like they have in the past.  When logging to files, Ceph logs appear in `/var/log/ceph/<cluster-fsid>`.

To enable logging to files:

```
ceph config set global log_to_file true
ceph config set global mon_cluster_log_to_file true
```

We recommend disabling logging to stderr (see above) or else everything will be logged twice:

```
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
```

By default, cephadm sets up log rotation on each host to rotate these files.  You can configure the logging retention schedule by modifying `/etc/logrotate.d/ceph.<cluster-fsid>`.

## Data location

Cephadm daemon data and logs in slightly different locations than older versions of ceph:

- `/var/log/ceph/<cluster-fsid>` contains all cluster logs.  Note that by default cephadm logs via stderr and the container runtime, so these logs are normally not present.
- `/var/lib/ceph/<cluster-fsid>` contains all cluster daemon data (besides logs).
- `/var/lib/ceph/<cluster-fsid>/<daemon-name>` contains all data for an individual daemon.
- `/var/lib/ceph/<cluster-fsid>/crash` contains crash reports for the cluster.
- `/var/lib/ceph/<cluster-fsid>/removed` contains old daemon data directories for stateful daemons (e.g., monitor, prometheus) that have been removed by cephadm.

### Disk usage

Because a few Ceph daemons may store a significant amount of data in `/var/lib/ceph` (notably, the monitors and prometheus), we recommend moving this directory to its own disk, partition, or logical volume so that it does not fill up the root file system.

## SSH Configuration

Cephadm uses SSH to connect to remote hosts.  SSH uses a key to authenticate with those hosts in a secure way.

### Default behavior

Cephadm stores an SSH key in the monitor that is used to connect to remote hosts.  When the cluster is bootstrapped, this SSH key is generated automatically and no additional configuration is necessary.

A *new* SSH key can be generated with:

```
ceph cephadm generate-key
```

The public portion of the SSH key can be retrieved with:

```
ceph cephadm get-pub-key
```

The currently stored SSH key can be deleted with:

```
ceph cephadm clear-key
```

You can make use of an existing key by directly importing it with:

```
ceph config-key set mgr/cephadm/ssh_identity_key -i <key>
ceph config-key set mgr/cephadm/ssh_identity_pub -i <pub>
```

You will then need to restart the mgr daemon to reload the configuration with:

```
ceph mgr fail
```

### Configuring a different SSH user

Cephadm must be able to log into all the Ceph cluster nodes as an user that has enough privileges to download container images, start containers and execute commands without prompting for a password. If you do not want to use the “root” user (default option in cephadm), you must provide cephadm the name of the user that is going to be used to perform all the cephadm operations. Use the command:

```
ceph cephadm set-user <user>
```

Prior to running this the cluster ssh key needs to be added to this users authorized_keys file and non-root users must have passwordless sudo access.

### Customizing the SSH configuration

Cephadm generates an appropriate `ssh_config` file that is used for connecting to remote hosts.  This configuration looks something like this:

```
Host *
User root
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```

There are two ways to customize this configuration for your environment:

1. Import a customized configuration file that will be stored by the monitor with:

   ```
   ceph cephadm set-ssh-config -i <ssh_config_file>
   ```

   To remove a customized SSH config and revert back to the default behavior:

   ```
   ceph cephadm clear-ssh-config
   ```

2. You can configure a file location for the SSH configuration file with:

   ```
   ceph config set mgr mgr/cephadm/ssh_config_file <path>
   ```

   We do *not recommend* this approach.  The path name must be visible to *any* mgr daemon, and cephadm runs all daemons as containers. That means that the file either need to be placed inside a customized container image for your deployment, or manually distributed to the mgr data directory (`/var/lib/ceph/<cluster-fsid>/mgr.<id>` on the host, visible at `/var/lib/ceph/mgr/ceph-<id>` from inside the container).

## Health checks

### CEPHADM_PAUSED

Cephadm background work has been paused with `ceph orch pause`.  Cephadm continues to perform passive monitoring activities (like checking host and daemon status), but it will not make any changes (like deploying or removing daemons).

Resume cephadm work with:

```
ceph orch resume
```



### CEPHADM_STRAY_HOST

One or more hosts have running Ceph daemons but are not registered as hosts managed by *cephadm*.  This means that those services cannot currently be managed by cephadm (e.g., restarted, upgraded, included in ceph orch ps).

You can manage the host(s) with:

```
ceph orch host add *<hostname>*
```

Note that you may need to configure SSH access to the remote host before this will work.

Alternatively, you can manually connect to the host and ensure that services on that host are removed or migrated to a host that is managed by *cephadm*.

You can also disable this warning entirely with:

```
ceph config set mgr mgr/cephadm/warn_on_stray_hosts false
```

See [Fully qualified domain names vs bare host names](https://docs.ceph.com/docs/master/cephadm/concepts/#cephadm-fqdn) for more information about host names and domain names.

### CEPHADM_STRAY_DAEMON

One or more Ceph daemons are running but not are not managed by *cephadm*.  This may be because they were deployed using a different tool, or because they were started manually.  Those services cannot currently be managed by cephadm (e.g., restarted, upgraded, or included in ceph orch ps).

If the daemon is a stateful one (monitor or OSD), it should be adopted by cephadm; see [Converting an existing cluster to cephadm](https://docs.ceph.com/docs/master/cephadm/adoption/#cephadm-adoption).  For stateless daemons, it is usually easiest to provision a new daemon with the `ceph orch apply` command and then stop the unmanaged daemon.

This warning can be disabled entirely with:

```
ceph config set mgr mgr/cephadm/warn_on_stray_daemons false
```

### CEPHADM_HOST_CHECK_FAILED

One or more hosts have failed the basic cephadm host check, which verifies that (1) the host is reachable and cephadm can be executed there, and (2) that the host satisfies basic prerequisites, like a working container runtime (podman or docker) and working time synchronization. If this test fails, cephadm will no be able to manage services on that host.

You can manually run this check with:

```
ceph cephadm check-host *<hostname>*
```

You can remove a broken host from management with:

```
ceph orch host rm *<hostname>*
```

You can disable this health warning with:

```
ceph config set mgr mgr/cephadm/warn_on_failed_host_check false
```

## /etc/ceph/ceph.conf

Cephadm distributes a minimized `ceph.conf` that only contains a minimal set of information to connect to the Ceph cluster.

To update the configuration settings, instead of manually editing the `ceph.conf` file, use the config database instead:

```
ceph config set ...
```

See [Monitor configuration database](https://docs.ceph.com/docs/master/rados/configuration/ceph-conf/#ceph-conf-database) for details.

By default, cephadm does not deploy that minimized `ceph.conf` across the cluster. To enable the management of `/etc/ceph/ceph.conf` files on all hosts, please enable this by running:

```
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf true
```

To set up an initial configuration before bootstrapping the cluster, create an initial `ceph.conf` file. For example:

```
cat <<EOF > /etc/ceph/ceph.conf
[global]
osd crush chooseleaf type = 0
EOF
```

Then, run bootstrap referencing this file:

```
cephadm bootstrap -c /root/ceph.conf ...
```

# Monitoring Stack with Cephadm

Ceph Dashboard uses [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/), and related tools to store and visualize detailed metrics on cluster utilization and performance.  Ceph users have three options:

1. Have cephadm deploy and configure these services.  This is the default when bootstrapping a new cluster unless the `--skip-monitoring-stack` option is used.
2. Deploy and configure these services manually.  This is recommended for users with existing prometheus services in their environment (and in cases where Ceph is running in Kubernetes with Rook).
3. Skip the monitoring stack completely.  Some Ceph dashboard graphs will not be available.

The monitoring stack consists of [Prometheus](https://prometheus.io/), Prometheus exporters ([Prometheus Module](https://docs.ceph.com/docs/master/mgr/prometheus/#mgr-prometheus), [Node exporter](https://prometheus.io/docs/guides/node-exporter/)), [Prometheus Alert Manager](https://prometheus.io/docs/alerting/alertmanager/) and [Grafana](https://grafana.com/).

Note

Prometheus’ security model presumes that untrusted users have access to the Prometheus HTTP endpoint and logs. Untrusted users have access to all the (meta)data Prometheus collects that is contained in the database, plus a variety of operational and debugging information.

However, Prometheus’ HTTP API is limited to read-only operations. Configurations can *not* be changed using the API and secrets are not exposed. Moreover, Prometheus has some built-in measures to mitigate the impact of denial of service attacks.

Please see Prometheus’ Security model <https://prometheus.io/docs/operating/security/> for more detailed information.

## Deploying monitoring with cephadm

By default, bootstrap will deploy a basic monitoring stack.  If you did not do this (by passing `--skip-monitoring-stack`, or if you converted an existing cluster to cephadm management, you can set up monitoring by following the steps below.

1. Enable the prometheus module in the ceph-mgr daemon.  This  exposes the internal Ceph metrics so that prometheus can scrape them.:

   ```
   ceph mgr module enable prometheus
   ```

2. Deploy a node-exporter service on every node of the cluster.  The node-exporter provides host-level metrics like CPU and memory  utilization.:

   ```
   ceph orch apply node-exporter '*'
   ```

3. Deploy alertmanager:

   ```
   ceph orch apply alertmanager 1
   ```

4. Deploy prometheus.  A single prometheus instance is sufficient, but for HA you may want to deploy two.:

   ```
   ceph orch apply prometheus 1    # or 2
   ```

5. Deploy grafana:

   ```
   ceph orch apply grafana 1
   ```

Cephadm handles the prometheus, grafana, and alertmanager configurations automatically.

It may take a minute or two for services to be deployed.  Once completed, you should see something like this from `ceph orch ls`:

```
$ ceph orch ls
NAME           RUNNING  REFRESHED  IMAGE NAME                                      IMAGE ID        SPEC
alertmanager       1/1  6s ago     docker.io/prom/alertmanager:latest              0881eb8f169f  present
crash              2/2  6s ago     docker.io/ceph/daemon-base:latest-master-devel  mix           present
grafana            1/1  0s ago     docker.io/pcuzner/ceph-grafana-el8:latest       f77afcf0bcf6   absent
node-exporter      2/2  6s ago     docker.io/prom/node-exporter:latest             e5a616e4b9cf  present
prometheus         1/1  6s ago     docker.io/prom/prometheus:latest                e935122ab143  present
```

### Using custom images

It is possible to install or upgrade monitoring components based on other images.  To do so, the name of the image to be used needs to be stored in the configuration first.  The following configuration options are available.

- `container_image_prometheus`
- `container_image_grafana`
- `container_image_alertmanager`
- `container_image_node_exporter`

Custom images can be set with the `ceph config` command:

```
ceph config set mgr mgr/cephadm/<option_name> <value>
```

For example:

```
ceph config set mgr mgr/cephadm/container_image_prometheus prom/prometheus:v1.4.1
```

Note

By setting a custom image, the default value will be overridden (but not overwritten).  The default value changes when updates become available. By setting a custom image, you will not be able to update the component you have set the custom image for automatically.  You will need to manually update the configuration (image name and tag) to be able to install updates.

If you choose to go with the recommendations instead, you can reset the custom image you have set before.  After that, the default value will be used again.  Use `ceph config rm` to reset the configuration option:

```
ceph config rm mgr mgr/cephadm/<option_name>
```

For example:

```
ceph config rm mgr mgr/cephadm/container_image_prometheus
```

## Disabling monitoring

If you have deployed monitoring and would like to remove it, you can do so with:

```
ceph orch rm grafana
ceph orch rm prometheus --force   # this will delete metrics data collected so far
ceph orch rm node-exporter
ceph orch rm alertmanager
ceph mgr module disable prometheus
```

## Deploying monitoring manually

If you have an existing prometheus monitoring infrastructure, or would like to manage it yourself, you need to configure it to integrate with your Ceph cluster.

- Enable the prometheus module in the ceph-mgr daemon:

  ```
  ceph mgr module enable prometheus
  ```

  By default, ceph-mgr presents prometheus metrics on port 9283 on each host running a ceph-mgr daemon.  Configure prometheus to scrape these.

- To enable the dashboard’s prometheus-based alerting, see [Enabling Prometheus Alerting](https://docs.ceph.com/docs/master/mgr/dashboard/#dashboard-alerting).

- To enable dashboard integration with Grafana, see [Enabling the Embedding of Grafana Dashboards](https://docs.ceph.com/docs/master/mgr/dashboard/#dashboard-grafana).

## Enabling RBD-Image monitoring

Due to performance reasons, monitoring of RBD images is disabled by default. For more information please see [RBD IO statistics](https://docs.ceph.com/docs/master/mgr/prometheus/#prometheus-rbd-io-statistics). If disabled, the overview and details dashboards will stay empty in Grafana and the metrics will not be visible in Prometheus.

# Orchestrator CLI

This module provides a command line interface (CLI) to orchestrator modules (ceph-mgr modules which interface with external orchestration services).

As the orchestrator CLI unifies different external orchestrators, a common nomenclature for the orchestrator module is needed.

| *host*         | hostname (not DNS name) of the physical host. Not the podname, container name, or hostname inside the container. |
| -------------- | ------------------------------------------------------------ |
| *service type* | The type of the service. e.g., nfs, mds, osd, mon, rgw, mgr, iscsi |
| *service*      | A logical service, Typically comprised of multiple service instances on multiple hosts for HA `fs_name` for mds type `rgw_zone` for rgw type `ganesha_cluster_id` for nfs type |
| *daemon*       | A single instance of a service. Usually a daemon, but maybe not (e.g., might be a kernel service like LIO or knfsd or whatever) This identifier should uniquely identify the instance |

The relation between the names is the following:

- A *service* has a specific *service type*
- A *daemon* is a physical instance of a *service type*

Note

Orchestrator modules may only implement a subset of the commands listed below. Also, the implementation of the commands may differ between modules.

## Status

```
ceph orch status
```

Show current orchestrator mode and high-level status (whether the orchestrator plugin is available and operational)

## Host Management

List hosts associated with the cluster:

```
ceph orch host ls
```

Add and remove hosts:

```
ceph orch host add <hostname> [<addr>] [<labels>...]
ceph orch host rm <hostname>
```

For cephadm, see also [Fully qualified domain names vs bare host names](https://docs.ceph.com/docs/master/cephadm/concepts/#cephadm-fqdn).

### Host Specification

Many hosts can be added at once using `ceph orch apply -i` by submitting a multi-document YAML file:

```
---
service_type: host
addr: node-00
hostname: node-00
labels:
- example1
- example2
---
service_type: host
addr: node-01
hostname: node-01
labels:
- grafana
---
service_type: host
addr: node-02
hostname: node-02
```

This can be combined with service specifications (below) to create a  cluster spec file to deploy a whole cluster in one command.  see `cephadm bootstrap --apply-spec` also to do this during bootstrap. Cluster SSH Keys must be copied to hosts prior to adding them.

## OSD Management

### List Devices

Print a list of discovered devices, grouped by host and optionally filtered to a particular host:

```
ceph orch device ls [--host=...] [--refresh]
```

Example:

```
HOST    PATH      TYPE   SIZE  DEVICE  AVAIL  REJECT REASONS
master  /dev/vda  hdd   42.0G          False  locked
node1   /dev/vda  hdd   42.0G          False  locked
node1   /dev/vdb  hdd   8192M  387836  False  locked, LVM detected, Insufficient space (<5GB) on vgs
node1   /dev/vdc  hdd   8192M  450575  False  locked, LVM detected, Insufficient space (<5GB) on vgs
node3   /dev/vda  hdd   42.0G          False  locked
node3   /dev/vdb  hdd   8192M  395145  False  LVM detected, locked, Insufficient space (<5GB) on vgs
node3   /dev/vdc  hdd   8192M  165562  False  LVM detected, locked, Insufficient space (<5GB) on vgs
node2   /dev/vda  hdd   42.0G          False  locked
node2   /dev/vdb  hdd   8192M  672147  False  LVM detected, Insufficient space (<5GB) on vgs, locked
node2   /dev/vdc  hdd   8192M  228094  False  LVM detected, Insufficient space (<5GB) on vgs, locked
```

### Erase Devices (Zap Devices)

Erase (zap) a device so that it can be reused. `zap` calls `ceph-volume zap` on the remote host.

```
orch device zap <hostname> <path>
```

Example command:

```
ceph orch device zap my_hostname /dev/sdx
```

Note

Cephadm orchestrator will automatically deploy drives that match the DriveGroup in your OSDSpec if the unmanaged flag is unset. For example, if you use the `all-available-devices` option when creating OSDs, when you `zap` a device the cephadm orchestrator will automatically create a new OSD in the device . To disable this behavior, see [Create OSDs](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-create-osds).



### Create OSDs

Create OSDs on a set of devices on a single host:

```
ceph orch daemon add osd <host>:device1,device2
```

Another way of doing it is using `apply` interface:

```
ceph orch apply osd -i <json_file/yaml_file> [--dry-run]
```

where the `json_file/yaml_file` is a DriveGroup specification. For a more in-depth guide to DriveGroups please refer to [OSD Service Specification](https://docs.ceph.com/docs/master/cephadm/drivegroups/#drivegroups)

`dry-run` will cause the orchestrator to present a preview of what will happen without actually creating the OSDs.

Example:

```
# ceph orch apply osd --all-available-devices --dry-run
NAME                  HOST  DATA     DB WAL
all-available-devices node1 /dev/vdb -  -
all-available-devices node2 /dev/vdc -  -
all-available-devices node3 /dev/vdd -  -
```

When the parameter `all-available-devices` or a DriveGroup specification is used, a cephadm service is created. This service guarantees that all available devices or devices included in the DriveGroup will be used for OSDs. Note that the effect of `--all-available-devices` is persistent; that is, drives which are added to the system or become available (say, by zapping) after the command is complete will be automatically found and added to the cluster.

That is, after using:

```
ceph orch apply osd --all-available-devices
```

- If you add new disks to the cluster they will automatically be used to create new OSDs.
- A new OSD will be created automatically if you remove an OSD and clean the LVM physical volume.

If you want to avoid this behavior (disable automatic creation of OSD on available devices), use the `unmanaged` parameter:

```
ceph orch apply osd --all-available-devices --unmanaged=true
```

If you have already created the OSDs using the `all-available-devices` service, you can change the automatic OSD creation using the following command:

```
ceph orch osd spec --service-name osd.all-available-devices --unmanaged
```

### Remove an OSD

```
ceph orch osd rm <svc_id(s)> [--replace] [--force]
```

Evacuates PGs from an OSD and removes it from the cluster.

Example:

```
# ceph orch osd rm 0
Scheduled OSD(s) for removal
```

OSDs that are not safe-to-destroy will be rejected.

You can query the state of the operation with:

```
# ceph orch osd rm status
OSD_ID  HOST         STATE                    PG_COUNT  REPLACE  FORCE  STARTED_AT
2       cephadm-dev  done, waiting for purge  0         True     False  2020-07-17 13:01:43.147684
3       cephadm-dev  draining                 17        False    True   2020-07-17 13:01:45.162158
4       cephadm-dev  started                  42        False    True   2020-07-17 13:01:45.162158
```

When no PGs are left on the OSD, it will be decommissioned and removed from the cluster.

Note

After removing an OSD, if you wipe the LVM physical volume in the device used by the removed OSD, a new OSD will be created. Read information about the `unmanaged` parameter in [Create OSDs](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-create-osds).

### Stopping OSD Removal

You can stop the queued OSD removal operation with

```
ceph orch osd rm stop <svc_id(s)>
```

Example:

```
# ceph orch osd rm stop 4
Stopped OSD(s) removal
```

This will reset the initial state of the OSD and take it off the removal queue.

### Replace an OSD

```
orch osd rm <svc_id(s)> --replace [--force]
```

Example:

```
# ceph orch osd rm 4 --replace
Scheduled OSD(s) for replacement
```

This follows the same procedure as the “Remove OSD” part with the exception that the OSD is not permanently removed from the CRUSH hierarchy, but is assigned a ‘destroyed’ flag.

**Preserving the OSD ID**

The previously-set ‘destroyed’ flag is used to determine OSD ids that will be reused in the next OSD deployment.

If you use OSDSpecs for OSD deployment, your newly added disks will be assigned the OSD ids of their replaced counterparts, assuming the new disks still match the OSDSpecs.

For assistance in this process you can use the ‘–dry-run’ feature.

Tip: The name of your OSDSpec can be retrieved from **ceph orch ls**

Alternatively, you can use your OSDSpec file:

```
ceph orch apply osd -i <osd_spec_file> --dry-run
NAME                  HOST  DATA     DB WAL
<name_of_osd_spec>    node1 /dev/vdb -  -
```

If this matches your anticipated behavior, just omit the –dry-run flag to execute the deployment.

## Monitor and manager management

Creates or removes MONs or MGRs from the cluster. Orchestrator may return an error if it doesn’t know how to do this transition.

Update the number of monitor hosts:

```
ceph orch apply mon <num> [host, host:network...] [--dry-run]
```

Each host can optionally specify a network for the monitor to listen on.

Update the number of manager hosts:

```
ceph orch apply mgr <num> [host...] [--dry-run]
```

## Service Status

Print a list of services known to the orchestrator. The list can be limited to services on a particular host with the optional –host parameter and/or services of a particular type via optional –type parameter (mon, osd, mgr, mds, rgw):

```
ceph orch ls [--service_type type] [--service_name name] [--export] [--format f] [--refresh]
```

Discover the status of a particular service or daemons:

```
ceph orch ls --service_type type --service_name <name> [--refresh]
```

Export the service specs known to the orchestrator as yaml in format that is compatible to `ceph orch apply -i`:

```
ceph orch ls --export
```

## Daemon Status

Print a list of all daemons known to the orchestrator:

```
ceph orch ps [--hostname host] [--daemon_type type] [--service_name name] [--daemon_id id] [--format f] [--refresh]
```

Query the status of a particular service instance (mon, osd, mds, rgw).  For OSDs the id is the numeric OSD ID, for MDS services it is the file system name:

```
ceph orch ps --daemon_type osd --daemon_id 0
```



## Deploying CephFS

In order to set up a [CephFS](https://docs.ceph.com/docs/master/glossary/#term-CephFS), execute:

```
ceph fs volume create <fs_name> <placement spec>
```

where `name` is the name of the CephFS and `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec).

This command will create the required Ceph pools, create the new CephFS, and deploy mds servers.

## Stateless services (MDS/RGW/NFS/rbd-mirror/iSCSI)

(Please note: The orchestrator will not configure the services. Please look into the corresponding documentation for service configuration details.)

The `name` parameter is an identifier of the group of instances:

- a CephFS file system for a group of MDS daemons,
- a zone name for a group of RGWs

Creating/growing/shrinking/removing services:

```
ceph orch apply mds <fs_name> [--placement=<placement>] [--dry-run]
ceph orch apply rgw <realm> <zone> [--subcluster=<subcluster>] [--port=<port>] [--ssl] [--placement=<placement>] [--dry-run]
ceph orch apply nfs <name> <pool> [--namespace=<namespace>] [--placement=<placement>] [--dry-run]
ceph orch rm <service_name> [--force]
```

where `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec).

e.g., `ceph orch apply mds myfs --placement="3 host1 host2 host3"`

Service Commands:

```
ceph orch <start|stop|restart|redeploy|reconfig> <service_name>
```



## Service Specification

A *Service Specification* is a data structure represented as YAML to specify the deployment of services.  For example:

```
service_type: rgw
service_id: realm.zone
placement:
  hosts:
    - host1
    - host2
    - host3
spec: ...
unmanaged: false
```

where the properties of a service specification are:

- - `service_type` is the type of the service. Needs to be either a Ceph

    service (`mon`, `crash`, `mds`, `mgr`, `osd` or `rbd-mirror`), a gateway (`nfs` or `rgw`), or part of the monitoring stack (`alertmanager`, `grafana`, `node-exporter` or `prometheus`)

- `service_id` is the name of the service

- `placement` is a [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec)

- `spec`: additional specifications for a specific service

- - `unmanaged`: If set to `true`, the orchestrator will not deploy nor

    remove any daemon associated with this service. Placement and all other properties will be ignored. This is useful, if this service should not be managed temporarily.

Each service type can have different requirements for the `spec` element.

Service specifications of type `mon`, `mgr`, and the monitoring types do not require a `service_id`.

A service of type `nfs` requires a pool name and may contain an optional namespace:

```
service_type: nfs
service_id: mynfs
placement:
  hosts:
    - host1
    - host2
spec:
  pool: mypool
  namespace: mynamespace
```

where `pool` is a RADOS pool where NFS client recovery data is stored and `namespace` is a RADOS namespace where NFS client recovery data is stored in the pool.

A service of type `osd` is described in [OSD Service Specification](https://docs.ceph.com/docs/master/cephadm/drivegroups/#drivegroups)

Many service specifications can be applied at once using `ceph orch apply -i` by submitting a multi-document YAML file:

```
cat <<EOF | ceph orch apply -i -
service_type: mon
placement:
  host_pattern: "mon*"
---
service_type: mgr
placement:
  host_pattern: "mgr*"
---
service_type: osd
service_id: default_drive_group
placement:
  host_pattern: "osd*"
data_devices:
  all: true
EOF
```



## Placement Specification

For the orchestrator to deploy a *service*, it needs to know where to deploy *daemons*, and how many to deploy.  This is the role of a placement specification.  Placement specifications can either be passed as command line arguments or in a YAML files.

### Explicit placements

Daemons can be explicitly placed on hosts by simply specifying them:

```
orch apply prometheus "host1 host2 host3"
```

Or in YAML:

```
service_type: prometheus
placement:
  hosts:
    - host1
    - host2
    - host3
```

MONs and other services may require some enhanced network specifications:

```
orch daemon add mon myhost:[v2:1.2.3.4:3000,v1:1.2.3.4:6789]=name
```

where `[v2:1.2.3.4:3000,v1:1.2.3.4:6789]` is the network address of the monitor and `=name` specifies the name of the new monitor.

### Placement by labels

Daemons can be explictly placed on hosts that match a specific label:

```
orch apply prometheus label:mylabel
```

Or in YAML:

```
service_type: prometheus
placement:
  label: "mylabel"
```

### Placement by pattern matching

Daemons can be placed on hosts as well:

```
orch apply prometheus 'myhost[1-3]'
```

Or in YAML:

```
service_type: prometheus
placement:
  host_pattern: "myhost[1-3]"
```

To place a service on *all* hosts, use `"*"`:

```
orch apply crash '*'
```

Or in YAML:

```
service_type: node-exporter
placement:
  host_pattern: "*"
```

### Setting a limit

By specifying `count`, only that number of daemons will be created:

```
orch apply prometheus 3
```

To deploy *daemons* on a subset of hosts, also specify the count:

```
orch apply prometheus "2 host1 host2 host3"
```

If the count is bigger than the amount of hosts, cephadm deploys one per host:

```
orch apply prometheus "3 host1 host2"
```

results in two Prometheus daemons.

Or in YAML:

```
service_type: prometheus
placement:
  count: 3
```

Or with hosts:

```
service_type: prometheus
placement:
  count: 2
  hosts:
    - host1
    - host2
    - host3
```

## Updating Service Specifications

The Ceph Orchestrator maintains a declarative state of each service in a `ServiceSpec`. For certain operations, like updating the RGW HTTP port, we need to update the existing specification.

1. List the current `ServiceSpec`:

   ```
   ceph orch ls --service_name=<service-name> --export > myservice.yaml
   ```

2. Update the yaml file:

   ```
   vi myservice.yaml
   ```

3. Apply the new `ServiceSpec`:

   ```
   ceph orch apply -i myservice.yaml [--dry-run]
   ```

## Configuring the Orchestrator CLI

To enable the orchestrator, select the orchestrator module to use with the `set backend` command:

```
ceph orch set backend <module>
```

For example, to enable the Rook orchestrator module and use it with the CLI:

```
ceph mgr module enable rook
ceph orch set backend rook
```

Check the backend is properly configured:

```
ceph orch status
```

### Disable the Orchestrator

To disable the orchestrator, use the empty string `""`:

```
ceph orch set backend ""
ceph mgr module disable rook
```

## Current Implementation Status

This is an overview of the current implementation status of the orchestrators.

| Command                       | Rook | Cephadm |
| ----------------------------- | ---- | ------- |
| apply iscsi                   | ⚪    | ✔       |
| apply mds                     | ✔    | ✔       |
| apply mgr                     | ⚪    | ✔       |
| apply mon                     | ✔    | ✔       |
| apply nfs                     | ✔    | ✔       |
| apply osd                     | ✔    | ✔       |
| apply rbd-mirror              | ✔    | ✔       |
| apply rgw                     | ⚪    | ✔       |
| host add                      | ⚪    | ✔       |
| host ls                       | ✔    | ✔       |
| host rm                       | ⚪    | ✔       |
| daemon status                 | ⚪    | ✔       |
| daemon {stop,start,…}         | ⚪    | ✔       |
| device {ident,fault}-(on,off} | ⚪    | ✔       |
| device ls                     | ✔    | ✔       |
| iscsi add                     | ⚪    | ✔       |
| mds add                       | ✔    | ✔       |
| nfs add                       | ✔    | ✔       |
| rbd-mirror add                | ⚪    | ✔       |
| rgw add                       | ✔    | ✔       |
| ps                            | ✔    | ✔       |

where

- ⚪ = not yet implemented
- ❌ = not applicable
- ✔ = implemented

# Basic Ceph Client Setup

Client machines need some basic configuration in order to interact with a cluster. This document describes how to configure a client machine for cluster interaction.

Note

Most client machines only need the ceph-common package and its dependencies installed. That will supply the basic ceph and rados commands, as well as other commands like mount.ceph and rbd.

## Config File Setup

Client machines can generally get away with a smaller config file than a full-fledged cluster member. To generate a minimal config file, log into a host that is already configured as a client or running a cluster daemon, and then run:

```
ceph config generate-minimal-conf
```

This will generate a minimal config file that will tell the client how to reach the Ceph Monitors. The contents of this file should typically be installed in /etc/ceph/ceph.conf.

## Keyring Setup

Most Ceph clusters are run with authentication enabled, and the client will need keys in order to communicate with cluster machines. To generate a keyring file with credentials for client.fs, log into an extant cluster member and run:

```
ceph auth get-or-create client.fs
```

The resulting output should be put into a keyring file, typically /etc/ceph/ceph.keyring.

# OSD Service Specification

[Service Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-service-spec) of type `osd` are a way to describe a cluster layout using the properties of disks. It gives the user an abstract way tell ceph which disks should turn into an OSD with which configuration without knowing the specifics of device names and paths.

Instead of doing this:

```
[monitor 1] # ceph orch daemon add osd *<host>*:*<path-to-device>*
```

for each device and each host, we can define a yaml|json file that allows us to describe the layout. Here’s the most basic example.

Create a file called i.e. osd_spec.yml

```
service_type: osd
service_id: default_drive_group  <- name of the drive_group (name can be custom)
placement:
  host_pattern: '*'              <- which hosts to target, currently only supports globs
data_devices:                    <- the type of devices you are applying specs to
  all: true                      <- a filter, check below for a full list
```

This would translate to:

Turn any available(ceph-volume decides what ‘available’ is) into an OSD on all hosts that match the glob pattern ‘*’. (The glob pattern matches against the registered hosts from host ls) There will be a more detailed section on host_pattern down below.

and pass it to osd create like so:

```
[monitor 1] # ceph orch apply osd -i /path/to/osd_spec.yml
```

This will go out on all the matching hosts and deploy these OSDs.

Since we want to have more complex setups, there are more filters than just the ‘all’ filter.

Also, there is a –dry-run flag that can be passed to the apply osd command, which gives you a synopsis of the proposed layout.

Example:

```
[monitor 1] # ceph orch apply osd -i /path/to/osd_spec.yml --dry-run
```

## Filters

Note

Filters are applied using a AND gate by default. This essentially means that a drive needs to fulfill all filter criteria in order to get selected. If you wish to change this behavior you can adjust this behavior by setting

> filter_logic: OR  # valid arguments are AND, OR

in the OSD Specification.

You can assign disks to certain groups by their attributes using filters.

The attributes are based off of ceph-volume’s disk query. You can retrieve the information with:

```
ceph-volume inventory </path/to/disk>
```

### Vendor or Model:

You can target specific disks by their Vendor or by their Model

```
model: disk_model_name
```

or

```
vendor: disk_vendor_name
```

### Size:

You can also match by disk Size.

```
size: size_spec
```

#### Size specs:

Size specification of format can be of form:

- LOW:HIGH
- :HIGH
- LOW:
- EXACT

Concrete examples:

Includes disks of an exact size:

```
size: '10G'
```

Includes disks which size is within the range:

```
size: '10G:40G'
```

Includes disks less than or equal to 10G in size:

```
size: ':10G'
```

Includes disks equal to or greater than 40G in size:

```
size: '40G:'
```

Sizes don’t have to be exclusively in Gigabyte(G).

Supported units are Megabyte(M), Gigabyte(G) and Terrabyte(T). Also appending the (B) for byte is supported. MB, GB, TB

### Rotational:

This operates on the ‘rotational’ attribute of the disk.

```
rotational: 0 | 1
```

1 to match all disks that are rotational

0 to match all disks that are non-rotational (SSD, NVME etc)

### All:

This will take all disks that are ‘available’

Note: This is exclusive for the data_devices section.

```
all: true
```

### Limiter:

When you specified valid filters but want to limit the amount of matching disks you can use the ‘limit’ directive.

```
limit: 2
```

For example, if you used vendor to match all disks that are from VendorA but only want to use the first two you could use limit.

```
data_devices:
  vendor: VendorA
  limit: 2
```

Note: Be aware that limit is really just a last resort and shouldn’t be used if it can be avoided.

## Additional Options

There are multiple optional settings you can use to change the way OSDs are deployed. You can add these options to the base level of a DriveGroup for it to take effect.

This example would deploy all OSDs with encryption enabled.

```
service_type: osd
service_id: example_osd_spec
placement:
  host_pattern: '*'
data_devices:
  all: true
encrypted: true
```

See a full list in the DriveGroupSpecs

- *class* `ceph.deployment.drive_group.``DriveGroupSpec`(**args*, ***kwargs*)

  Describe a drive group in the same form that ceph-volume understands.  `block_db_size` Set (or override) the “bluestore_block_db_size” value, in bytes   `block_wal_size` Set (or override) the “bluestore_block_wal_size” value, in bytes   `data_devices` A `ceph.deployment.drive_group.DeviceSelection`   `data_directories` A list of strings, containing paths which should back OSDs   `db_devices` A `ceph.deployment.drive_group.DeviceSelection`   `db_slots` How many OSDs per DB device   `encrypted` `true` or `false`   `filter_logic` The logic gate we use to match disks with filters. defaults to ‘AND’   `journal_devices` A `ceph.deployment.drive_group.DeviceSelection`   `journal_size` set journal_size in bytes   `objectstore` `filestore` or `bluestore`   `osd_id_claims` Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/docs/master/mgr/orchestrator_modules/#orchestrator-osd-replace)   `osds_per_device` Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required.   `preview_only` If this should be treated as a ‘preview’ spec   `wal_devices` A `ceph.deployment.drive_group.DeviceSelection`   `wal_slots` How many OSDs per WAL device

## Examples

### The simple case

All nodes with the same setup:

```
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

This is a common setup and can be described quite easily:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: HDD-123-foo <- note that HDD-123 would also be valid
db_devices:
  model: MC-55-44-XZ <- same here, MC-55-44 is valid
```

However, we can improve it by reducing the filters on core properties of the drives:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  rotational: 1
db_devices:
  rotational: 0
```

Now, we enforce all rotating devices to be declared as ‘data devices’ and all non-rotating devices will be used as shared_devices (wal, db)

If you know that drives with more than 2TB will always be the slower data devices, you can also filter by size:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  size: '2TB:'
db_devices:
  size: ':2TB'
```

Note: All of the above DriveGroups are equally valid. Which of those  you want to use depends on taste and on how much you expect your node  layout to change.

### The advanced case

Here we have two distinct setups:

```
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

12 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

- 20 HDDs should share 2 SSDs
- 10 SSDs should share 2 NVMes

This can be described with two layouts.

```
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
data_devices:
  rotational: 0
db_devices:
  model: MC-55-44-XZ
  limit: 2 (db_slots is actually to be favoured here, but it's not implemented yet)

service_type: osd
service_id: osd_spec_ssd
placement:
  host_pattern: '*'
data_devices:
  model: MC-55-44-XZ
db_devices:
  vendor: VendorC
```

This would create the desired layout by using all HDDs as data_devices with two SSD assigned as dedicated db/wal devices. The remaining SSDs(8) will be data_devices that have the ‘VendorC’ NVMEs assigned as dedicated db/wal devices.

### The advanced case (with non-uniform nodes)

The examples above assumed that all nodes have the same drives. That’s however not always the case.

Node1-5:

```
20 HDDs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
2 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

Node6-10:

```
5 NVMEs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
20 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

You can use the ‘host_pattern’ key in the layout to target certain nodes. Salt target notation helps to keep things easy.

```
service_type: osd
service_id: osd_spec_node_one_to_five
placement:
  host_pattern: 'node[1-5]'
data_devices:
  rotational: 1
db_devices:
  rotational: 0


service_type: osd
service_id: osd_spec_six_to_ten
placement:
  host_pattern: 'node[6-10]'
data_devices:
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
```

This applies different OSD specs to different hosts depending on the host_pattern key.

### Dedicated wal + db

All previous cases co-located the WALs with the DBs. It’s however possible to deploy the WAL on a dedicated device as well, if it makes sense.

```
20 HDDs
Vendor: VendorA
Model: SSD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

The OSD spec for this case would look like the following (using the model filter):

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
wal_devices:
  model: NVME-QQQQ-987
```

This can easily be done with other filters, like size or vendor as well.

# Troubleshooting

Sometimes there is a need to investigate why a cephadm command failed or why a specific service no longer runs properly.

As cephadm deploys daemons as containers, troubleshooting daemons is slightly different. Here are a few tools and commands to help investigating issues.

## Pausing or disabling cephadm

If something goes wrong and cephadm is doing behaving in a way you do not like, you can pause most background activity with:

```
ceph orch pause
```

This will stop any changes, but cephadm will still periodically check hosts to refresh its inventory of daemons and devices.  You can disable cephadm completely with:

```
ceph orch set backend ''
ceph mgr module disable cephadm
```

This will disable all of the `ceph orch ...` CLI commands but the previously deployed daemon containers will still continue to exist and start as they did before.

## Checking cephadm logs

You can monitor the cephadm log in real time with:

```
ceph -W cephadm
```

You can see the last few messages with:

```
ceph log last cephadm
```

If you have enabled logging to files, you can see a cephadm log file called `ceph.cephadm.log` on monitor hosts (see [Ceph daemon logs](https://docs.ceph.com/docs/master/cephadm/operations/#cephadm-logs)).

## Gathering log files

Use journalctl to gather the log files of all daemons:

Note

By default cephadm now stores logs in journald. This means that you will no longer find daemon logs in `/var/log/ceph/`.

To read the log file of one specific daemon, run:

```
cephadm logs --name <name-of-daemon>
```

Note: this only works when run on the same host where the daemon is running. To get logs of a daemon running on a different host, give the `--fsid` option:

```
cephadm logs --fsid <fsid> --name <name-of-daemon>
```

where the `<fsid>` corresponds to the cluster ID printed by `ceph status`.

To fetch all log files of all daemons on a given host, run:

```
for name in $(cephadm ls | jq -r '.[].name') ; do
  cephadm logs --fsid <fsid> --name "$name" > $name;
done
```

## Collecting systemd status

To print the state of a systemd unit, run:

```
systemctl status "ceph-$(cephadm shell ceph fsid)@<service name>.service";
```

To fetch all state of all daemons of a given host, run:

```
fsid="$(cephadm shell ceph fsid)"
for name in $(cephadm ls | jq -r '.[].name') ; do
  systemctl status "ceph-$fsid@$name.service" > $name;
done
```

## List all downloaded container images

To list all container images that are downloaded on a host:

Note

`Image` might also be called ImageID

```
podman ps -a --format json | jq '.[].Image'
"docker.io/library/centos:8"
"registry.opensuse.org/opensuse/leap:15.2"
```

## Manually running containers

Cephadm writes small wrappers that run a containers. Refer to `/var/lib/ceph/<cluster-fsid>/<service-name>/unit.run` for the container execution command.



## ssh errors

Error message:

```
execnet.gateway_bootstrap.HostNotFound: -F /tmp/cephadm-conf-73z09u6g -i /tmp/cephadm-identity-ky7ahp_5 root@10.10.1.2
...
raise OrchestratorError(msg) from e
orchestrator._interface.OrchestratorError: Failed to connect to 10.10.1.2 (10.10.1.2).
Please make sure that the host is reachable and accepts connections using the cephadm SSH key
...
```

Things users can do:

1. Ensure cephadm has an SSH identity key:

   ```
   [root@mon1~]# cephadm shell -- ceph config-key get mgr/cephadm/ssh_identity_key > ~/cephadm_private_key
   INFO:cephadm:Inferring fsid f8edc08a-7f17-11ea-8707-000c2915dd98
   INFO:cephadm:Using recent ceph image docker.io/ceph/ceph:v15 obtained 'mgr/cephadm/ssh_identity_key'
   [root@mon1 ~] # chmod 0600 ~/cephadm_private_key
   ```

> If this fails, cephadm doesn’t have a key. Fix this by running the following command:
>
> ```
> [root@mon1 ~]# cephadm shell -- ceph cephadm generate-ssh-key
> ```
>
> or:
>
> ```
> [root@mon1 ~]# cat ~/cephadm_private_key | cephadm shell -- ceph cephadm set-ssk-key -i -
> ```

1. Ensure that the ssh config is correct:

   ```
   [root@mon1 ~]# cephadm shell -- ceph cephadm get-ssh-config > config
   ```

2. Verify that we can connect to the host:

   ```
   [root@mon1 ~]# ssh -F config -i ~/cephadm_private_key root@mon1
   ```

### Verifying that the Public Key is Listed in the authorized_keys file

To verify that the public key is in the authorized_keys file, run the following commands:

```
[root@mon1 ~]# cephadm shell -- ceph cephadm get-pub-key > ~/ceph.pub
[root@mon1 ~]# grep "`cat ~/ceph.pub`"  /root/.ssh/authorized_keys
```

## Failed to infer CIDR network error

If you see this error:

```
ERROR: Failed to infer CIDR network for mon ip ***; pass --skip-mon-network to configure it later
```

Or this error:

```
Must set public_network config option or specify a CIDR network, ceph addrvec, or plain IP
```

This means that you must run a command of this form:

```
ceph config set mon public_network <mon_network>
```

For more detail on operations of this kind, see [Deploy additional monitors (optional)](https://docs.ceph.com/docs/master/cephadm/install/#deploy-additional-monitors)

## Accessing the admin socket

Each Ceph daemon provides an admin socket that bypasses the MONs (See [Using the Admin Socket](https://docs.ceph.com/docs/master/rados/operations/monitoring/#rados-monitoring-using-admin-socket)).

To access the admin socket, first enter the daemon container on the host:

```
[root@mon1 ~]# cephadm enter --name <daemon-name>
[ceph: root@mon1 /]# ceph --admin-daemon /var/run/ceph/ceph-<daemon-name>.asok config show
```

# Cephadm Concepts



## Fully qualified domain names vs bare host names

cephadm has very minimal requirements when it comes to resolving host names etc. When cephadm initiates an ssh connection to a remote host, the host name  can be resolved in four different ways:

- a custom ssh config resolving the name to an IP
- via an externally maintained `/etc/hosts`
- via explicitly providing an IP address to cephadm: `ceph orch host add <hostname> <IP>`
- automatic name resolution via DNS.

Ceph itself uses the command `hostname` to determine the name of the current host.

Note

cephadm demands that the name of the host given via `ceph orch host add` equals the output of `hostname` on remote hosts.

Otherwise cephadm can’t be sure, the host names returned by `ceph * metadata` match the hosts known to cephadm. This might result in a [CEPHADM_STRAY_HOST](https://docs.ceph.com/docs/master/cephadm/operations/#cephadm-stray-host) warning.

When configuring new hosts, there are two **valid** ways to set the `hostname` of a host:

1. Using the bare host name. In this case:

- `hostname` returns the bare host name.
- `hostname -f` returns the FQDN.

1. Using the fully qualified domain name as the host name. In this case:

- `hostname` returns the FQDN
- `hostname -s` return the bare host name

Note that `man hostname` recommends `hostname` to return the bare host name:

> The FQDN (Fully Qualified Domain Name) of the system is the name that the resolver(3) returns for the host name, such as, ursula.example.com. It is usually the hostname followed by the DNS domain name (the part after the first dot). You can check the FQDN using `hostname --fqdn` or the domain name using `dnsdomainname`.
>
> ```
> You cannot change the FQDN with hostname or dnsdomainname.
> 
> The recommended method of setting the FQDN is to make the hostname
> be an alias for the fully qualified name using /etc/hosts, DNS, or
> NIS. For example, if the hostname was "ursula", one might have
> a line in /etc/hosts which reads
> 
>        127.0.1.1    ursula.example.com ursula
> ```

Which means, `man hostname` recommends `hostname` to return the bare host name. This in turn means that Ceph will return the bare host names when executing `ceph * metadata`. This in turn means cephadm also requires the bare host name when adding a host to the cluster: `ceph orch host add <bare-name>`.

## Cephadm Scheduler

Cephadm uses a declarative state to define the layout of the cluster. This state consists of a list of service specifications containing placement specifications (See [Service Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-service-spec) ).

Cephadm constantly compares list of actually running daemons in the cluster with the desired service specifications and will either add or remove new daemons.

First, cephadm will select a list of candidate hosts. It first looks for explicit host names and will select those. In case there are no explicit hosts defined, cephadm looks for a label specification. If there is no label defined in the specification, cephadm will select hosts based on a host pattern. If there is no pattern defined, cepham will finally select all known hosts as candidates.

Then, cephadm will consider existing daemons of this services and will try to avoid moving any daemons.

Cephadm supports the deployment of a specific amount of services. Let’s consider a service specification like so:

```
service_type: mds
service_name: myfs
placement:
  count: 3
  label: myfs
```

This instructs cephadm to deploy three daemons on hosts labeled with `myfs` across the cluster.

Then, in case there are less than three daemons deployed on the candidate hosts, cephadm will then then randomly choose hosts for deploying new daemons.

In case there are more than three daemons deployed, cephadm will remove existing daemons.

Finally, cephadm will remove daemons on hosts that are outside of the list of candidate hosts.

However, there is a special cases that cephadm needs to consider.

In case the are fewer hosts selected by the placement specification than demanded by `count`, cephadm will only deploy on selected hosts.