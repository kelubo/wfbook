# MON

[TOC]

## 概述

cephadm 引导过程将集群中的第一个 MON 分配给特定子网。cephadm 将该子网指定为集群的默认子网。默认情况下，新的监视器守护进程将分配给该子网，除非 cephadm 被指示执行其他操作。

典型的 Ceph 集群在不同主机上部署了 3 个或 5 个 monitor 守护进程。如果集群中有5个或更多节点，建议部署5个 monitor 节点。

如果群集中的所有 MON 都在同一子网中，则不需要手动管理 MON 。因为新主机被添加到集群中，cephadm 将根据需要自动向子网添加多达5个监视器。`cephadm` 自动配置新主机上的 monitor 守护进程。新主机与存储集群中的第一个（引导）主机位于同一个子网中。`cephadm` 还可以部署和缩放 monitor，以响应存储集群大小的变化。Ceph assumes that other monitors should use the same subnet as the first monitor’s IP.默认情况下，Ceph假定其他监视器应使用与第一台监视器IP相同的子网。

##  指定特定子网

要指定特定的 IP 子网供 ceph MON 使用，使用以下形式的命令，包括 CIDR 格式的子网地址（例如10.1.2.0/24）：

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

## 在特定的网络中部署 MON

可以为每个 MON 明确指定 IP 地址或 CIDR 网络，并控制放置每个 MON 的位置。要禁用自动监视器部署，请运行以下命令：

```bash
ceph orch apply mon --unmanaged
```
要部署每个额外的 MON ：

```bash
ceph orch daemon add mon <host1:ip-or-network1> [<host1:ip-or-network-2>...]
```
For example, to deploy a second monitor on `newhost1` using an IP address `10.1.2.123` and a third monitor on `newhost2` in network `10.1.2.0/24`, run the following commands:

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

要部署每个额外的 MON ：

 ```bash
 ceph orch daemon add mon <newhost1:ip-or-network1>
 ```

For example, to deploy a second monitor on `newhost1` using an IP address `10.1.2.123` and a third monitor on `newhost2` in network `10.1.2.0/24`, run the following commands:例如，要使用IP地址10.1.2.123在newhost1上部署第二台监视器，并在网络10.1.2.0/24中在newhost2上部署第三台监视器：

 ```bash
 ceph orch apply mon --unmanaged
 ceph orch daemon add mon newhost1:10.1.2.123
 ceph orch daemon add mon newhost2:10.1.2.0/24
 ```

随后从旧网络中删除 MON ：

 ```bash
 ceph orch daemon rm mon.<oldhost1>
 ```

 Update the `public_network`:

 ```bash
 ceph config set mon public_network <mon-cidr-network>
 
 ceph config set mon public_network 10.1.2.0/24
 ```

 Now, enable automatic placement of Daemons

 ```bash
 ceph orch apply mon --placement="newhost1,newhost2,newhost3" --dry-run
 ```

 Finally apply this new placement by dropping `--dry-run`

 ```bash
 ceph orch apply mon --placement="newhost1,newhost2,newhost3"
 ```

**注意：**

> The **apply** command can be confusing. For this reason, we recommend using YAML specifications.
>
> apply命令可能会造成混淆。因此，我们建议使用YAML规范。 
>
> Each `ceph orch apply mon` command supersedes the one before it. This means that you must use the proper comma-separated list-based syntax when you want to apply monitors to more than one host. If you do not use the proper syntax, you will clobber your work as you go.
>
> 每个“ ceph orch apply mon”命令都会取代之前的命令。这意味着要将监视器应用于多个主机时，必须使用正确的逗号分隔的基于列表的语法。如果您使用的语法不正确，那么您将无法进行工作。 
>
> 例如：
>
> ```bash
> ceph orch apply mon host1
> ceph orch apply mon host2
> ceph orch apply mon host3
> ```
>
> This results in only one host having a monitor applied to it: host 3.
>
> 这样只会导致一个主机上应用了监视器：主机3。 
>
> (The first command creates a monitor on host1. Then the second command clobbers the monitor on host1 and creates a monitor on host2. Then the third command clobbers the monitor on host2 and creates a monitor on host3. In this scenario, at this point, there is a monitor ONLY on host3.)
>
> （第一个命令在host1上创建一个监视器。然后第二个命令在host1上创建一个监视器，然后在host2上创建一个监视器。然后第三个命令在host2上创建一个监视器，然后在host3上创建一个监视器。在这种情况下，在host3上只有一个监视器。） 
>
> To make certain that a monitor is applied to each of these three hosts, run a command like this:
>
> 为了确保将监视器应用于这三台主机中的每台，请运行以下命令： 
>
> ```bash
> ceph orch apply mon "host1,host2,host3"
> ```
>
> 务必在同一 `ceph orch apply` 命令中指定所有主机名。如果您指定了 `ceph orch apply mon --placement host1`，然后指定了 `ceph orch apply mon --placement host2`，第二个命令将删除 host1 上的 monitor 服务，并将 monitor 服务应用到 host2。 
>
> There is another way to apply monitors to multiple hosts: a `yaml` file can be used. Instead of using the “ceph orch apply mon” commands, run a command of this form:
>
> ```bash
> ceph orch apply -i file.yaml
> ```
>
> 样例文件 **file.yaml** :
>
> ```yaml
> service_type: mon
> placement:
> hosts:
>    - host1
>    - host2
>    - host3
> ```


