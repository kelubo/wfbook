# ceph-deploy

[TOC]

创建一个 Ceph 存储集群，有一个 Monitor 和两个 OSD 守护进程。一旦集群达到 `active + clean` 状态，再扩展它：增加第三个 OSD 、增加MDS和两个 Ceph Mon。

node1:MON

node2:OSD

node3:OSD

![](D:\wfbook\Image\c\ceph.png)

为获得最佳体验，先在管理节点上创建一个目录，用于保存 `ceph-deploy` 生成的配置文件和密钥对。

```bash
mkdir my-cluster
cd my-cluster
```

`ceph-deploy` 会把文件输出到当前目录，所以请确保在此目录下执行 `ceph-deploy` 。

> **禁用 `requiretty`**
>
> 在某些发行版（如 CentOS ）上，执行 `ceph-deploy` 命令时，如果你的 Ceph 节点默认设置了 `requiretty` 那就会遇到报错。可以这样禁用此功能：执行 `sudo visudo` ，找到 `Defaults requiretty` 选项，把它改为 `Defaults:ceph !requiretty` ，这样 `ceph-deploy` 就能用 `ceph` 用户登录并使用 `sudo` 了。

## 创建集群

在管理节点上，进入刚创建的放置配置文件的目录，用 `ceph-deploy` 执行如下步骤。

1. 创建集群。

   ```bash
   ceph-deploy new {initial-monitor-node(s)}
   ```

   例如：

   ```bash
   ceph-deploy new node1
   ```

   在当前目录下用 `ls` 和 `cat` 检查 `ceph-deploy` 的输出，应该有一个 Ceph 配置文件、一个 monitor 密钥环和一个日志文件。

2. 把 Ceph 配置文件里的默认副本数从 `3` 改成 `2` ，这样只有两个 OSD 也可以达到 `active + clean` 状态。把下面这行加入 `[global]` 段：

   ```bash
   osd pool default size = 2
   ```

3. 如果有多个网卡，可以把 `public network` 写入 Ceph 配置文件的 `[global]` 段下。

   ```bash
   public network = {ip-address}/{netmask}
   ```

4. 安装 Ceph 。

   ```bash
   ceph-deploy install {ceph-node} [{ceph-node} ...]
   ```

   例如：

   ```bash
   ceph-deploy install admin-node node1 node2 node3
   ```

   `ceph-deploy` 将在各节点安装 Ceph 。

5. 配置初始 monitor(s)、并收集所有密钥：

   ```bash
   ceph-deploy mon create-initial
   ```

   完成上述操作后，当前目录里应该会出现这些密钥环：

   ```bash
   {cluster-name}.client.admin.keyring
   {cluster-name}.bootstrap-osd.keyring
   {cluster-name}.bootstrap-mds.keyring
   {cluster-name}.bootstrap-rgw.keyring
   ```

   只有在安装 Hammer 或更高版时才会创建 bootstrap-rgw 密钥环。

   > Note:
   >
   > 如果此步失败并输出类似于如下信息 “Unable to find /etc/ceph/ceph.client.admin.keyring”，请确认 ceph.conf 中为 monitor 指定的 IP 是  Public IP，而不是 Private IP。

6. 添加两个 OSD 。(为了测试，把目录而非整个硬盘用于 OSD 守护进程）。登录到 Ceph 节点、并给 OSD 守护进程创建一个目录。

   ```bash
   ssh node2
   sudo mkdir /var/local/osd0
   exit
   
   ssh node3
   sudo mkdir /var/local/osd1
   exit
   ```

   然后，从管理节点执行 `ceph-deploy` 来准备 OSD 。

   ```bash
   ceph-deploy osd prepare {ceph-node}:/path/to/directory
   ```

   例如：

   ```bash
   ceph-deploy osd prepare node2:/var/local/osd0 node3:/var/local/osd1
   ```

   最后，激活 OSD 。

   ```bash
   ceph-deploy osd activate {ceph-node}:/path/to/directory
   ```

   例如：

   ```bash
   ceph-deploy osd activate node2:/var/local/osd0 node3:/var/local/osd1
   ```

7. 用 `ceph-deploy` 把配置文件和 admin 密钥拷贝到管理节点和 Ceph 节点，这样你每次执行 Ceph 命令行时就无需指定 monitor 地址和 `ceph.client.admin.keyring` 了。

   ```bash
   ceph-deploy admin {admin-node} {ceph-node}
   ```

   例如：

   ```bash
   ceph-deploy admin admin-node node1 node2 node3
   ```

   `ceph-deploy` 和本地管理主机（ `admin-node` ）通信时，必须通过主机名可达。必要时可修改 `/etc/hosts` ，加入管理主机的名字。

8. 确保你对 `ceph.client.admin.keyring` 有正确的操作权限。

   ```bash
   sudo chmod +r /etc/ceph/ceph.client.admin.keyring
   ```

9. 检查集群的健康状况。

   ```bash
   ceph health
   ```

   等 peering 完成后，集群应该达到 `active + clean` 状态。



如果在某些地方碰到麻烦，想从头再来，可以用下列命令清除配置：

```bash
ceph-deploy purgedata {ceph-node} [{ceph-node}]
ceph-deploy forgetkeys
```

用下列命令可以连 Ceph 安装包一起清除：

```bash
ceph-deploy purge {ceph-node} [{ceph-node}]
```

## 扩展集群（扩容）

在 `node1` 上添加一个 OSD 守护进程和一个MDS。然后分别在 `node2` 和 `node3` 上添加 Ceph Monitor ，以形成 Monitors 的法定人数。

![img](http://docs.ceph.org.cn/_images/ditaa-c5495708ed5fc570308611ac28339196614c050a.png)

### 添加 OSD

你运行的这个三节点集群只是用于演示的，把 OSD 添加到 monitor 节点就行。

```bash
ssh node1
sudo mkdir /var/local/osd2
exit
```

然后，从 `ceph-deploy` 节点准备 OSD 。

```bash
ceph-deploy osd prepare {ceph-node}:/path/to/directory
```

例如：

```bash
ceph-deploy osd prepare node1:/var/local/osd2
```

最后，激活 OSD 。

```bash
ceph-deploy osd activate {ceph-node}:/path/to/directory
```

例如：

```bash
ceph-deploy osd activate node1:/var/local/osd2
```

一旦你新加了 OSD ， Ceph 集群就开始重均衡，把归置组迁移到新 OSD 。可以用下面的 `ceph` 命令观察此过程：

```bash
ceph -w
```

你应该能看到归置组状态从 `active + clean` 变为 `active` ，还有一些降级的对象；迁移完成后又会回到 `active + clean` 状态（ Control-C 退出）。

### 添加MDS

至少需要一个MDS才能使用 CephFS ，执行下列命令创建元数据服务器：

```bash
ceph-deploy mds create {ceph-node}
```

例如：

```bash
ceph-deploy mds create node1
```

> Note
>
> 当前生产环境下的 Ceph 只能运行一个MDS。

### 添加 RGW 例程

要使用 Ceph 的 Ceph 对象网关组件，必须部署 RGW 例程。用下列方法创建新 RGW 例程：

```bash
ceph-deploy rgw create {gateway-node}
```

例如：

```bash
ceph-deploy rgw create node1
```

RGW例程默认会监听 7480 端口，可以更改该节点 ceph.conf 内与 RGW 相关的配置，如下：

```bash
[client]
rgw frontends = civetweb port=80
```

用的是 IPv6 地址的话：

```bash
[client]
rgw frontends = civetweb port=[::]:80
```

### 添加 Monitors

为达到高可用，典型的 Ceph 存储集群会运行多个 Monitors，这样在单个 Monitor 失败时不会影响 Ceph 存储集群的可用性。Ceph 使用 PASOX 算法，此算法要求有多半 monitors（即 1 、  2:3 、 3:4 、 3:5 、 4:6 等 ）形成法定人数。

新增两个监视器到 Ceph 集群。

```bash
ceph-deploy mon add {ceph-node}
```

例如：

```bash
ceph-deploy mon add node2 node3
```

新增 Monitor 后，Ceph 会自动开始同步并形成法定人数。你可以用下面的命令检查法定人数状态：

```bash
ceph quorum_status --format json-pretty
```

> Tip
>
> 当Ceph 集群运行着多个 monitor 时，各 monitor 主机上都**应该**配置 NTP ，而且要确保这些 monitor 位于 NTP 服务的同一级。

## 存入/检出对象数据

要把对象存入 Ceph 存储集群，客户端必须做到：

1. 指定对象名
2. 指定存储池

Ceph 客户端检出最新集群运行图，用 CRUSH 算法计算出如何把对象映射到归置组，然后动态地计算如何把归置组分配到 OSD 。要定位对象，只需要对象名和存储池名字即可，例如：

```bash
ceph osd map {poolname} {object-name}
```

### 练习：定位某个对象

作为练习，我们先创建一个对象，用 `rados put` 命令加上对象名、一个有数据的测试文件路径、并指定存储池。例如：

```bash
echo {Test-data} > testfile.txt
rados put {object-name} {file-path} --pool=data
rados put test-object-1 testfile.txt --pool=data
```

为确认 Ceph 存储集群存储了此对象，可执行：

```bash
rados -p data ls
```

现在，定位对象：

```bash
ceph osd map {pool-name} {object-name}
ceph osd map data test-object-1
```

Ceph 应该会输出对象的位置，例如：

```bash
osdmap e537 pool 'data' (0) object 'test-object-1' -> pg 0.d1743484 (0.4) -> up [1,0] acting [1,0]
```

用``rados rm`` 命令可删除此测试对象，例如：

```bash
rados rm test-object-1 --pool=data
```

随着集群的运行，对象位置可能会动态改变。 Ceph 有动态均衡机制，无需手动干预即可完成。