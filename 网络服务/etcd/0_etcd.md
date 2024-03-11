# Etcd

[TOC]

## 概述

etcd 是一种高度一致的，分布式键值存储，它提供了一种可靠的方法来存储需要由分布式系统或机器集群访问的数据。It gracefully handles leader elections during network partitions and can tolerate machine failure, even in the leader node.它可以在网络分区期间优雅地处理领导者选举，并且可以容忍计算机故障，即使在领导者节点中也是如此。

## 特征

**简单的界面**

使用标准 HTTP 工具（如 curl）读取和写入值。

 ![](https://etcd.io/img/interface.svg)

**键值存储**

Store data in hierarchically organized directories, 
将数据存储在分层组织的目录中，就像在标准文件系统中一样。

 ![](https://etcd.io/img/kv.svg)

**Watch for changes 注意变化**

监视特定键或目录的更改，并对值的更改做出反应

 ![](https://etcd.io/img/watch.svg)



Optional SSL client certificate authentication

**可选的 SSL 客户端证书身份验证**

Benchmarked at 1000s of writes/s per instance
**基准测试为每个实例 1000 次写入/秒**

Optional TTLs for keys expiration
**用于密钥过期的可选 TTL**

Properly distributed via Raft protocol
**通过 Raft 协议正确分发**

## 访问

1. 在另一个终端上，用于 `etcdctl` 设置一个 key：

   ```bash
   $ etcdctl --endpoints=$ENDPOINTS put foo "Hello World!"
   
   $ etcdctl put foo "Hello World!"
   OK
   ```

2. 从同一终端检索 key ：

   ```bash
   $ etcdctl --endpoints=$ENDPOINTS get foo
   $ etcdctl --endpoints=$ENDPOINTS --write-out="json" get foo
   
   $ etcdctl get foo
   foo
   Hello, etcd
   ```

3. 按前缀提取 etcd key

   ```bash
   etcdctl --endpoints=$ENDPOINTS put web1 value1
   etcdctl --endpoints=$ENDPOINTS put web2 value2
   etcdctl --endpoints=$ENDPOINTS put web3 value3
   
   etcdctl --endpoints=$ENDPOINTS get web --prefix
   ```

4. 删除 etcd 

   ```bash
   etcdctl --endpoints=$ENDPOINTS put key myvalue
   etcdctl --endpoints=$ENDPOINTS del key
   
   etcdctl --endpoints=$ENDPOINTS put k1 value1
   etcdctl --endpoints=$ENDPOINTS put k2 value2
   etcdctl --endpoints=$ENDPOINTS del k --prefix
   ```

5. 进行事务性写入的指南

   `txn` 将多个请求包装到一个事务中：

   ```shell
   etcdctl --endpoints=$ENDPOINTS put user1 bad
   etcdctl --endpoints=$ENDPOINTS txn --interactive
   
   compares:
   value("user1") = "bad"
   
   success requests (get, put, delete):
   del user1
   
   failure requests (get, put, delete):
   put user1 good
   ```

6. watch keys 如何观看按键

   `watch` 获得有关未来更改的通知：

   ```bash
   etcdctl --endpoints=$ENDPOINTS watch stock1
   etcdctl --endpoints=$ENDPOINTS put stock1 1000
   
   etcdctl --endpoints=$ENDPOINTS watch stock --prefix
   etcdctl --endpoints=$ENDPOINTS put stock1 10
   etcdctl --endpoints=$ENDPOINTS put stock2 20
   ```

7. 创建租约的指南

   `lease` to write with TTL:
   `lease` 使用 TTL 写入：

   ```bash
   etcdctl --endpoints=$ENDPOINTS lease grant 300
   # lease 2be7547fbc6a5afa granted with TTL(300s)
   
   etcdctl --endpoints=$ENDPOINTS put sample value --lease=2be7547fbc6a5afa
   etcdctl --endpoints=$ENDPOINTS get sample
   
   etcdctl --endpoints=$ENDPOINTS lease keep-alive 2be7547fbc6a5afa
   etcdctl --endpoints=$ENDPOINTS lease revoke 2be7547fbc6a5afa
   # or after 300 seconds
   etcdctl --endpoints=$ENDPOINTS get sample
   ```

8. 创建分布式锁

   `lock` for distributed lock:
    `lock` 对于分布式锁定：

   ```bash
   etcdctl --endpoints=$ENDPOINTS lock mutex1
   
   # another client with the same name blocks
   etcdctl --endpoints=$ENDPOINTS lock mutex1
   ```

9. 

   ```bash
   
   ```



## Cluster

在每个 etcd 节点上，指定集群成员：

```shell
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
```

在每台计算机上运行以下命令：

```shell
# For machine 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For machine 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For machine 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

或者使用我们的公共发现服务：

```shell
curl https://discovery.etcd.io/new?size=3
https://discovery.etcd.io/a81b5818e67a6ea83e9d4daea5ecbc92

# grab this token
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
DISCOVERY=https://discovery.etcd.io/a81b5818e67a6ea83e9d4daea5ecbc92

THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

现在 etcd 已经准备好了！要使用 etcdctl 连接到 etcd：

```shell
export ETCDCTL_API=3
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379

etcdctl --endpoints=$ENDPOINTS member list
```

### 进行 leader 选举

`elect` for leader election:
 `elect` 对于领导人选举：

```bash
etcdctl --endpoints=$ENDPOINTS elect one p1

# another client with the same name blocks
etcdctl --endpoints=$ENDPOINTS elect one p2
```

### 添加和删除成员

`member` to add,remove,update membership:
 `member` 要添加、删除、更新成员资格，请执行以下操作：

```shell
# For each machine
TOKEN=my-etcd-token-1
CLUSTER_STATE=new
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_3=etcd-node-3
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_3=10.240.0.15
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380

# For node 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}

# For node 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}

# For node 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}
```

Then replace a member with `member remove` and `member add` commands:
然后将成员替换为 `member remove` 和 `member add` 命令：

```shell
# get member ID
export ETCDCTL_API=3
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_3=10.240.0.15
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379,${HOST_3}:2379 member list

# remove the member
MEMBER_ID=278c654c9a6dfd3b
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379,${HOST_3}:2379 \
	member remove ${MEMBER_ID}

# add a new member (node 4)
export ETCDCTL_API=3
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_4=etcd-node-4
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_4=10.240.0.16 # new member
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379 \
	member add ${NAME_4} \
	--peer-urls=http://${HOST_4}:2380
```

Next, start the new member with `--initial-cluster-state existing` flag:
接下来，使用 `--initial-cluster-state existing` flag 启动新成员：

```shell
# [WARNING] If the new member starts from the same disk space,
# make sure to remove the data directory of the old member
#
# restart with 'existing' flag
TOKEN=my-etcd-token-1
CLUSTER_STATE=existing
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_4=etcd-node-4
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_4=10.240.0.16 # new member
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_4}=http://${HOST_4}:2380

THIS_NAME=${NAME_4}
THIS_IP=${HOST_4}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}
```

### 检查集群状态

指定每台计算机的初始群集配置：

```bash
etcdctl --write-out=table --endpoints=$ENDPOINTS endpoint status

+------------------+----------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|    ENDPOINT      |    ID    | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+------------------+----------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 10.240.0.17:2379 | 491babe7 |  3.5.0  |   45 kB |      true |      false |         4 |      16726 |              16726 |        |
| 10.240.0.18:2379 | 5979cd72 |  3.5.0  |   45 kB |     false |      false |         4 |      16726 |              16726 |        |
| 10.240.0.19:2379 | 94df3e6c |  3.5.0  |   45 kB |     false |      false |         4 |      16726 |              16726 |        |
+------------------+----------+---------+---------+-----------+------------+-----------+------------+--------------------+--------|

etcdctl --endpoints=$ENDPOINTS endpoint health

10.240.0.17:2379 is healthy: successfully committed proposal: took = 3.345431ms
10.240.0.19:2379 is healthy: successfully committed proposal: took = 3.767967ms
10.240.0.18:2379 is healthy: successfully committed proposal: took = 4.025451ms
```

## Auth

`auth` ，`user` ，`role` 用于身份验证：

```bash
export ETCDCTL_API=3
ENDPOINTS=localhost:2379

etcdctl --endpoints=${ENDPOINTS} role add root
etcdctl --endpoints=${ENDPOINTS} role get root

etcdctl --endpoints=${ENDPOINTS} user add root
etcdctl --endpoints=${ENDPOINTS} user grant-role root root
etcdctl --endpoints=${ENDPOINTS} user get root

etcdctl --endpoints=${ENDPOINTS} role add role0
etcdctl --endpoints=${ENDPOINTS} role grant-permission role0 readwrite foo
etcdctl --endpoints=${ENDPOINTS} user add user0
etcdctl --endpoints=${ENDPOINTS} user grant-role user0 role0

etcdctl --endpoints=${ENDPOINTS} auth enable
# now all client requests go through auth

etcdctl --endpoints=${ENDPOINTS} --user=user0:123 put foo bar
etcdctl --endpoints=${ENDPOINTS} get foo
# permission denied, user name is empty because the request does not issue an authentication request
etcdctl --endpoints=${ENDPOINTS} --user=user0:123 get foo
# user0 can read the key foo
etcdctl --endpoints=${ENDPOINTS} --user=user0:123 get foo1
```

## 保存数据库

`snapshot` to save point-in-time snapshot of etcd database:
 `snapshot` 要保存 etcd 数据库的时间点快照：

Snapshot can only be requested from one etcd node, so `--endpoints` flag should contain only one endpoint.
快照只能从一个 etcd 节点请求，因此 `--endpoints` flag 应该只包含一个端点。

```bash
ENDPOINTS=$HOST_1:2379
etcdctl --endpoints=$ENDPOINTS snapshot save my.db

Snapshot saved at my.db
etcdutl --write-out=table snapshot status my.db

+---------+----------+------------+------------+
|  HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+---------+----------+------------+------------+
| c55e8b8 |        9 |         13 | 25 kB      |
+---------+----------+------------+------------+
```

## 升级

将 etcd 从 v2 迁移到 v3

`migrate` to transform etcd v2 to v3 data:
 `migrate` 要将 etcd v2 转换为 v3 数据：

```bash
# write key in etcd version 2 store
export ETCDCTL_API=2
etcdctl --endpoints=http://$ENDPOINT set foo bar

# read key in etcd v2
etcdctl --endpoints=$ENDPOINTS --output="json" get foo

# stop etcd node to migrate, one by one

# migrate v2 data
export ETCDCTL_API=3
etcdctl --endpoints=$ENDPOINT migrate --data-dir="default.etcd" --wal-dir="default.etcd/member/wal"

# restart etcd node after migrate, one by one

# confirm that the key got migrated
etcdctl --endpoints=$ENDPOINTS get /foo
```