# MON

[TOC]

## 部署额外的MON

典型的Ceph集群有三到五个分布在不同主机上的监视守护进程。如果集群中有五个或更多节点，建议部署五个监视器。

Ceph会随着集群的增长自动部署监控守护进程，而Ceph会随着集群的缩小自动伸缩监控守护进程。这种自动增长和收缩的顺利执行取决于正确的子网配置。

cephadm引导过程将集群中的第一个监视器守护进程分配给特定子网。cephadm将该子网指定为集群的默认子网。默认情况下，新的监视器守护进程将分配给该子网，除非cephadm被指示执行其他操作。

如果群集中的所有ceph monitor守护程序都在同一子网中，则不需要手动管理ceph monitor守护程序。cephadm将根据需要自动向子网添加多达5个监视器，因为新主机被添加到集群中。

## 指定特定子网

要指定特定的IP子网供ceph MON 使用，使用以下形式的命令，包括CIDR格式的子网地址（例如10.1.2.0/24）：

```bash
ceph config set mon public_network <mon-cidr-network>

ceph config set mon public_network 10.1.2.0/24
```

Cephadm deploys new monitor daemons only on hosts that have IP addresses in the designated subnet.

Cephadm只在指定子网中有IP地址的主机上部署新的监控守护进程。

## Changing the number of monitors from the default

If you want to adjust the default of 5 monitors, run this command:

> ```
> ceph orch apply mon *<number-of-monitors>*
> ```

## Deploying monitors only to specific hosts

To deploy monitors on a specific set of hosts, run this command:

> ```
> ceph orch apply mon *<host1,host2,host3,...>*
> ```
>
> Be sure to include the first (bootstrap) host in this list.

## Using Host Labels

You can control which hosts the monitors run on by making use of host labels. To set the `mon` label to the appropriate hosts, run this command:

> ```
> ceph orch host label add *<hostname>* mon
> ```
>
> To view the current hosts and labels, run this command:
>
> ```
> ceph orch host ls
> ```
>
> For example:
>
> ```
> ceph orch host label add host1 mon
> ceph orch host label add host2 mon
> ceph orch host label add host3 mon
> ceph orch host ls
> HOST   ADDR   LABELS  STATUS
> host1         mon
> host2         mon
> host3         mon
> host4
> host5
> ```
>
> Tell cephadm to deploy monitors based on the label by running this command:
>
> ```
> ceph orch apply mon label:mon
> ```

See also [host labels](https://docs.ceph.com/en/latest/cephadm/host-management/#orchestrator-host-labels).

## Deploying Monitors on a Particular Network

You can explicitly specify the IP address or CIDR network for each monitor and control where each monitor is placed.  To disable automated monitor deployment, run this command:

> ```
> ceph orch apply mon --unmanaged
> ```
>
> To deploy each additional monitor:
>
> ```
> ceph orch daemon add mon *<host1:ip-or-network1> [<host1:ip-or-network-2>...]*
> ```
>
> For example, to deploy a second monitor on `newhost1` using an IP address `10.1.2.123` and a third monitor on `newhost2` in network `10.1.2.0/24`, run the following commands:
>
> ```
> ceph orch apply mon --unmanaged
> ceph orch daemon add mon newhost1:10.1.2.123
> ceph orch daemon add mon newhost2:10.1.2.0/24
> ```
>
> Note
>
> The **apply** command can be confusing. For this reason, we recommend using YAML specifications.
>
> Each `ceph orch apply mon` command supersedes the one before it. This means that you must use the proper comma-separated list-based syntax when you want to apply monitors to more than one host. If you do not use the proper syntax, you will clobber your work as you go.
>
> For example:
>
> ```
> ceph orch apply mon host1
> ceph orch apply mon host2
> ceph orch apply mon host3
> ```
>
> This results in only one host having a monitor applied to it: host 3.
>
> (The first command creates a monitor on host1. Then the second command clobbers the monitor on host1 and creates a monitor on host2. Then the third command clobbers the monitor on host2 and creates a monitor on host3. In this scenario, at this point, there is a monitor ONLY on host3.)
>
> To make certain that a monitor is applied to each of these three hosts, run a command like this:
>
> ```
> ceph orch apply mon "host1,host2,host3"
> ```
>
> There is another way to apply monitors to multiple hosts: a `yaml` file can be used. Instead of using the “ceph orch apply mon” commands, run a command of this form:
>
> ```
> ceph orch apply -i file.yaml
> ```
>
> Here is a sample **file.yaml** file:
>
> ```
> service_type: mon
> placement:
>   hosts:
>    - host1
>    - host2
>    - host3
> ```