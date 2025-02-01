# Run etcd clusters inside containers 在容器内运行 etcd 集群

Running etcd with rkt and Docker using static bootstrapping
使用静态引导使用 rkt 和 Docker 运行 etcd



The following guide shows how to run etcd with rkt and Docker using the [static bootstrap process](https://etcd.io/docs/v3.5/op-guide/clustering/#static).
以下指南展示了如何使用静态引导过程与 rkt 和 Docker 一起运行 etcd。

## rkt

### Running a single node etcd 运行单个节点 etcd

The following rkt run command will expose the etcd client API on port 2379 and expose the peer API on port 2380.
以下 rkt run 命令将在端口 2379 上公开 etcd 客户端 API，并在端口 2380 上公开对等 API。

Use the host IP address when configuring etcd.
配置 etcd 时使用主机 IP 地址。

```
export NODE1=192.168.1.21
```

Trust the CoreOS [App Signing Key](https://coreos.com/security/app-signing-key/).
信任 CoreOS 应用签名密钥。

```
sudo rkt trust --prefix quay.io/coreos/etcd
# gpg key fingerprint is: 18AD 5014 C99E F7E3 BA5F  6CE9 50BD D3E0 FC8A 365E
```

Run the `v3.2` version of etcd or specify another release version.
运行 etcd `v3.2` 的版本或指定其他发布版本。

```
sudo rkt run --net=default:IP=${NODE1} quay.io/coreos/etcd:v3.2 -- -name=node1 -advertise-client-urls=http://${NODE1}:2379 -initial-advertise-peer-urls=http://${NODE1}:2380 -listen-client-urls=http://0.0.0.0:2379 -listen-peer-urls=http://${NODE1}:2380 -initial-cluster=node1=http://${NODE1}:2380
```

List the cluster member.
列出集群成员。

```
etcdctl --endpoints=http://192.168.1.21:2379 member list
```

### Running a 3 node etcd cluster 运行 3 节点 etcd 集群

Setup a 3 node cluster with rkt locally, using the `-initial-cluster` flag.
使用 rkt 在本地设置一个 3 节点集群，使用 `-initial-cluster` 标志。

```sh
export NODE1=172.16.28.21
export NODE2=172.16.28.22
export NODE3=172.16.28.23
# node 1
sudo rkt run --net=default:IP=${NODE1} quay.io/coreos/etcd:v3.2 -- -name=node1 -advertise-client-urls=http://${NODE1}:2379 -initial-advertise-peer-urls=http://${NODE1}:2380 -listen-client-urls=http://0.0.0.0:2379 -listen-peer-urls=http://${NODE1}:2380 -initial-cluster=node1=http://${NODE1}:2380,node2=http://${NODE2}:2380,node3=http://${NODE3}:2380

# node 2
sudo rkt run --net=default:IP=${NODE2} quay.io/coreos/etcd:v3.2 -- -name=node2 -advertise-client-urls=http://${NODE2}:2379 -initial-advertise-peer-urls=http://${NODE2}:2380 -listen-client-urls=http://0.0.0.0:2379 -listen-peer-urls=http://${NODE2}:2380 -initial-cluster=node1=http://${NODE1}:2380,node2=http://${NODE2}:2380,node3=http://${NODE3}:2380

# node 3
sudo rkt run --net=default:IP=${NODE3} quay.io/coreos/etcd:v3.2 -- -name=node3 -advertise-client-urls=http://${NODE3}:2379 -initial-advertise-peer-urls=http://${NODE3}:2380 -listen-client-urls=http://0.0.0.0:2379 -listen-peer-urls=http://${NODE3}:2380 -initial-cluster=node1=http://${NODE1}:2380,node2=http://${NODE2}:2380,node3=http://${NODE3}:2380
```

Verify the cluster is healthy and can be reached.
验证群集是否正常运行且可以访问。

```
ETCDCTL_API=3 etcdctl --endpoints=http://172.16.28.21:2379,http://172.16.28.22:2379,http://172.16.28.23:2379 endpoint health
```

### DNS

Production clusters which refer to peers by DNS name known to the local resolver must mount the [host’s DNS configuration](https://coreos.com/kubernetes/docs/latest/kubelet-wrapper.html#customizing-rkt-options).
通过本地解析程序已知的 DNS 名称引用对等体的生产群集必须挂载主机的 DNS 配置。

## Docker 码头工人

In order to expose the etcd API to clients outside of Docker host, use the host IP address of the container. Please see [`docker inspect`](https://docs.docker.com/engine/reference/commandline/inspect) for more detail on how to get the IP address. Alternatively, specify `--net=host` flag to `docker run` command to skip placing the container inside of a separate network stack.
为了向 Docker 主机外部的客户端公开 etcd API，请使用容器的主机 IP 地址。有关如何获取 IP 地址的更多详细信息，请参阅 `docker inspect` 。或者，将 flag 指定 `--net=host` 为 `docker run` 命令以跳过将容器放置在单独的网络堆栈中。

### Running a single node etcd 运行单个节点 etcd

Use the host IP address when configuring etcd:
配置 etcd 时使用主机 IP 地址：

```
export NODE1=192.168.1.21
```

Configure a Docker volume to store etcd data:
配置 Docker 卷以存储 etcd 数据：

```
docker volume create --name etcd-data
export DATA_DIR="etcd-data"
```

Run the latest version of etcd:
运行最新版本的 etcd：

```
REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:latest \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380
```

List the cluster member:
列出集群成员：

```
etcdctl --endpoints=http://${NODE1}:2379 member list
```

### Running a 3 node etcd cluster 运行 3 节点 etcd 集群

```
REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd

# For each machine
ETCD_VERSION=latest
TOKEN=my-etcd-token
CLUSTER_STATE=new
NAME_1=etcd-node-0
NAME_2=etcd-node-1
NAME_3=etcd-node-2
HOST_1=10.20.30.1
HOST_2=10.20.30.2
HOST_3=10.20.30.3
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
DATA_DIR=/var/lib/etcd

# For node 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For node 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For node 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

To run `etcdctl` using API version 3:
要使用 API 版本 3 运行 `etcdctl` ，请执行以下操作：

```
docker exec etcd /usr/local/bin/etcdctl put foo bar
```

## Bare Metal 裸机

To provision a 3 node etcd cluster on bare-metal, the examples in the [baremetal repo](https://github.com/coreos/coreos-baremetal/tree/master/examples) may be useful.
要在裸机上预配 3 节点 etcd 集群，裸机存储库中的示例可能很有用。

## Mounting a certificate volume 挂载证书卷

The etcd release container does not include default root certificates. To  use HTTPS with certificates trusted by a root authority (e.g., for  discovery), mount a certificate directory into the etcd container:
etcd 发布容器不包含默认根证书。要将 HTTPS 与根证书颁发机构信任的证书一起使用（例如，用于发现），请将证书目录挂载到 etcd 容器中：

```
REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=docker://gcr.io/etcd-development/etcd

rkt run \
  --insecure-options=image \
  --volume etcd-ssl-certs-bundle,kind=host,source=/etc/ssl/certs/ca-certificates.crt \
  --mount volume=etcd-ssl-certs-bundle,target=/etc/ssl/certs/ca-certificates.crt \
  ${REGISTRY}:latest -- --name my-name \
  --initial-advertise-peer-urls http://localhost:2380 --listen-peer-urls http://localhost:2380 \
  --advertise-client-urls http://localhost:2379 --listen-client-urls http://localhost:2379 \
  --discovery https://discovery.etcd.io/c11fbcdc16972e45253491a24fcf45e1
REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt \
  ${REGISTRY}:latest \
  /usr/local/bin/etcd --name my-name \
  --initial-advertise-peer-urls http://localhost:2380 --listen-peer-urls http://localhost:2380 \
  --advertise-client-urls http://localhost:2379 --listen-client-urls http://localhost:2379 \
  --discovery https://discovery.etcd.io/86a9ff6c8cb8b4c4544c1a2f88f8b801
```