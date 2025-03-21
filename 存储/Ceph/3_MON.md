# MON

[TOC]

## 概述

Ceph 会随着集群的增长自动部署 MON 守护进程，而 Ceph 会在集群收缩时自动缩减 MON 守护进程。这种自动增长和收缩的顺利执行取决于正确的子网配置。

cephadm 引导过程将集群中的第一个 MON 分配给特定子网。cephadm 将该子网指定为集群的默认子网。默认情况下，新的监视器守护进程将分配给该子网，除非 cephadm 被指示执行其他操作。

如果群集中的所有 MON 都在同一子网中，则不需要手动管理 MON 。因为新主机被添加到集群中，cephadm 将根据需要自动向子网添加多达 5 个 MON 。

默认情况下，cephadm 将在任意主机上部署 5 个守护进程。

##  指定特定子网

要指定特定的 IP 子网供 MON 使用，使用以下形式的命令，包括 CIDR 格式的子网地址（例如 10.1.2.0/24 ）：

```bash
ceph config set mon public_network <mon-cidr-network>
ceph config set mon public_network 10.1.2.0/24
```

Cephadm 只在指定子网中有 IP 地址的主机上部署新的监控守护进程。

还可以使用网络列表指定两个公共网络：

 ```bash
ceph config set mon public_network <mon-cidr-network1>,<mon-cidr-network2>
ceph config set mon public_network 10.1.2.0/24,192.168.0.1/24
 ```

## 更改 MON 的默认数目

```bash
ceph orch apply mon <number-of-monitors>
```

## 仅将 MON 部署到特定主机

```bash
ceph orch apply mon <host1,host2,host3,...>
```

确信列表中包含第一个主机 (bootstrap) 。

## 使用主机标签

You can control which hosts the monitors run on by making use of host labels.为主机分配 `mon` 标签：

```bash
ceph orch host label add <hostname> mon
```

查看所有主机及标签：

```bash
ceph orch host ls
```
例如：
```bash
ceph orch host label add host1 mon
ceph orch host label add host2 mon
ceph orch host label add host3 mon

ceph orch host ls
HOST   ADDR   LABELS  STATUS
host1         mon
host2         mon
host3         mon
host4
host5
```

根据主机标签部署 monitor：

```bash
ceph orch apply mon label:mon
```

## 在特定网络中部署 MON

可以为每个 MON 明确指定 IP 地址或 CIDR 网络，并控制每个 MON 的放置位置。要禁用 MON 自动部署，请运行以下命令：

```bash
ceph orch apply mon --unmanaged
```
要部署每个额外的 MON ：

```bash
ceph orch daemon add mon <host1:ip-or-network1>
```
例如，要使用 IP 地址 `10.1.2.123` 在 `newhost1` 上部署第二个 MON，并在网络 `10.1.2.0/24` 中 `newhost2` 上部署第三个 MON，请运行以下命令：

```bash
ceph orch apply mon --unmanaged
ceph orch daemon add mon newhost1:10.1.2.123
ceph orch daemon add mon newhost2:10.1.2.0/24
```
启用守护进程的自动放置

```bash
ceph orch apply mon --placement="newhost1,newhost2,newhost3" --dry-run
```

最后通过删除 `--dry-run` 来应用这个新位置。

```bash
ceph orch apply mon --placement="newhost1,newhost2,newhost3"
```

## 将 MON 移动到不同的网络

要将 MON 移动到新网络，请在新网络上部署新 MON ，然后从旧网络中删除 MON 。不建议手动修改和注入 monmap 。

首先，禁用守护进程的自动放置：

```bash
ceph orch apply mon --unmanaged
```

要部署每个额外的 MON ，执行以下操作：

 ```bash
ceph orch daemon add mon <newhost1:ip-or-network1>
 ```

例如，要使用 IP 地址 `10.1.2.123` 在 `newhost1` 上部署第二台 MON，并在网络 `10.1.2.0/24` 中在 `newhost2` 上部署第三台 MON：

 ```bash
ceph orch apply mon --unmanaged
ceph orch daemon add mon newhost1:10.1.2.123
ceph orch daemon add mon newhost2:10.1.2.0/24
 ```

随后从旧网络中删除 MON ：

 ```bash
ceph orch daemon rm mon.<oldhost1>
 ```

 更新 `public_network`:

 ```bash
ceph config set mon public_network <mon-cidr-network>
 
ceph config set mon public_network 10.1.2.0/24
 ```

现在，启用自动放置守护程序：

 ```bash
ceph orch apply mon --placement="newhost1,newhost2,newhost3" --dry-run
 ```

最后通过删除 `--dry-run` 来应用这个新位置。

 ```bash
ceph orch apply mon --placement="newhost1,newhost2,newhost3"
 ```

## 监控选举策略

monitor 选择策略标识网络分割并处理故障。可以在三种不同的模式下配置选举监控策略： 		

1. classic

   默认模式，其中根据两个站点之间的选举器模块对等级最低的监控器进行投票。 				

2. disallow

   此模式允许将 monitor 标记为不允许，在这种情况下，他们将参与仲裁并为客户端服务，但不能成为选定领导者。这可让你将监控器添加到不允许的领导列表中。如果 monitor 列在不允许的列表中，它将始终延迟到另一个 monitor。 				

3. connectivity

   此模式主要用于解决网络差异。它评估每个监控器提供的对等点的连接分数，并选择连接最强且最可靠的监控器作为领导者。此模式旨在处理网络分割，如果集群扩展到多个数据中心或易受攻击，则可能会出现此问题。此模式包含连接分数评级，并以最佳分数选择 monitor。 				

建议您继续使用 `classic` 模式，除非您需要其他模式的功能。

在构建集群前，使用以下命令修改 `elect_strategy` ：

```bash
ceph mon set election_strategy {classic|disallow|connectivity}
```

## 为 Monitor 设置 Crush 位置

Cephadm supports setting CRUSH locations for mon daemons using the mon service spec. The CRUSH locations are set by hostname. When cephadm deploys a mon on a host that matches a hostname specified in the CRUSH locations, it will add `--set-crush-location <CRUSH-location>` where the CRUSH location is the first entry in the list of CRUSH locations for that host. If multiple CRUSH locations are set for one host, cephadm will attempt to set the additional locations using the “ceph mon set_location” command.
Cephadm 支持为 MON 守护进程设置 CRUSH 位置 使用 mon 服务规范。CRUSH 位置已设置 按主机名。当 cephadm 在匹配 在 CRUSH 位置中指定的主机名，它将添加 `--set-crush-location <CRUSH-location>` 其中 CRUSH 位置是该主机的 CRUSH 位置列表中的第一个条目。如果为一台主机设置了多个 CRUSH 位置，cephadm 将尝试使用 `ceph mon set_location` 命令设置其他位置。

Note 注意

> Setting the CRUSH location in the spec is the recommended way of replacing tiebreaker mon daemons, as they require having a location set when they are added.
> 在规范中设置 CRUSH 位置是替换 tiebreaker mon 守护进程的推荐方法，因为它们需要在添加时设置位置。
>
> Tiebreaker mon daemons are a part of stretch mode clusters. For more info on stretch mode clusters see [Stretch Clusters](https://docs.ceph.com/en/latest/rados/operations/stretch-mode/#stretch-mode)
> Tiebreaker mon 守护程序是 stretch mode 集群的一部分。有关拉伸模式集群的更多信息，请参阅[拉伸集群](https://docs.ceph.com/en/latest/rados/operations/stretch-mode/#stretch-mode)

设置 CRUSH 位置的语法示例：

```yaml
service_type: mon
service_name: mon
placement:
  count: 5
spec:
  crush_locations:
    host1:
    - datacenter=a
    host2:
    - datacenter=b
    - rack=2
    host3:
    - datacenter=a
```

> Note 注意
>
> Sometimes, based on the timing of mon daemons being admitted to the mon quorum, cephadm may fail to set the CRUSH location for some mon daemons when multiple locations are specified. In this case, the recommended action is to re-apply the same mon spec to retrigger the service action.
> 有时，根据 mon 守护进程被允许进入 mon 仲裁的时间，当指定了多个位置时，cephadm 可能无法为某些 mon 守护进程设置 CRUSH 位置。在这种情况下，建议的作是重新应用相同的 mon 规范以重新触发 service作。
>
> Mon daemons will only get the `--set-crush-location` flag set when cephadm actually deploys them. This means if a spec is applied that includes a CRUSH location for a mon that is already deployed, the flag may not be set until a redeploy command is issued for that mon daemon.
> Mon 守护进程只有在 cephadm 实际部署它们时才会设置 `--set-crush-location` 标志。这意味着，如果应用的规范包含已部署的 mon 的 CRUSH 位置，则在为该 mon 守护进程发出 redeploy 命令之前，可能无法设置该标志。

## 拓展阅读

- [Cluster Operations](https://docs.ceph.com/en/latest/rados/operations/#rados-operations)
- [Troubleshooting Monitors](https://docs.ceph.com/en/latest/rados/troubleshooting/troubleshooting-mon/#rados-troubleshooting-mon)
- [Restoring the MON quorum](https://docs.ceph.com/en/latest/cephadm/troubleshooting/#cephadm-restore-quorum)