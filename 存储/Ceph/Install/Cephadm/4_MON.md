# MON

[TOC]

## 部署其他 MON

Ceph会随着集群的增长自动部署 MON ，会随着集群的缩小自动伸缩 MON 。这种自动增长和收缩的顺利执行取决于正确的子网配置。

cephadm引导过程将集群中的第一个 MON 分配给特定子网。 `cephadm` 将该子网指定为集群的默认子网。默认情况下，新的监视器守护进程将分配给该子网，除非cephadm被指示执行其他操作。

如果群集中的所有 MON 都在同一子网中，则不需要手动管理 MON 。因为新主机被添加到集群中，cephadm将根据需要自动向子网添加多达5个监视器。

## 指定特定子网

To designate a particular IP subnet for use by ceph monitor daemons, use a command of the following form, including the subnet’s address in [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) format (e.g., `10.1.2.0/24`):

```bash
ceph config set mon public_network <mon-cidr-network>

ceph config set mon public_network 10.1.2.0/24
```

Cephadm deploys new monitor daemons only on hosts that have IP addresses in the designated subnet.

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

You can control which hosts the monitors run on by making use of host labels. To set the `mon` label to the appropriate hosts, run this command:

```bash
ceph orch host label add <hostname> mon
```

查看所有主机及标签：

```bash
ceph orch host ls
```
例如：
```
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

Tell cephadm to deploy monitors based on the label by running this command:

```
ceph orch apply mon label:mon
```

## 在特定的网络中部署 MON

You can explicitly specify the IP address or CIDR network for each monitor and control where each monitor is placed.  To disable automated monitor deployment, run this command:

```bash
ceph orch apply mon --unmanaged
```
To deploy each additional monitor:
```bash
ceph orch daemon add mon <host1:ip-or-network1> [<host1:ip-or-network-2>...]
```
For example, to deploy a second monitor on `newhost1` using an IP address `10.1.2.123` and a third monitor on `newhost2` in network `10.1.2.0/24`, run the following commands:

```bash
ceph orch apply mon --unmanaged
ceph orch daemon add mon newhost1:10.1.2.123
ceph orch daemon add mon newhost2:10.1.2.0/24
```
> Note
> The **apply** command can be confusing. For this reason, we recommend using YAML specifications.
>
> Each `ceph orch apply mon` command supersedes the one before it. This means that you must use the proper comma-separated list-based syntax when you want to apply monitors to more than one host. If you do not use the proper syntax, you will clobber your work as you go.
>
>  例如：
>
> ```bash
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
> ```bash
> ceph orch apply mon "host1,host2,host3"
> ```
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
>   hosts:
>    - host1
>    - host2
>    - host3
> ```