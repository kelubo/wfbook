# Kubernetes

[TOC]

## 概述

Kubernetes (K8S) 是谷歌在 2014 年发布的一个开源项目。是 Google Omega 的开源版本（原名 Borg）。

## 概念

### Cluster

是计算、存储和网络资源的集合，Kubernetes 利用这些资源运行各种基于容器的应用。

### Master

主要职责是调度。可以运行多个。

### Node

职责是运行容器应用。由 Master 管理，Node 负责监控并汇报容器的状态，同时根据 Master 的要求管理容器的生命周期。

### Pod

Pod 是 kubernetes 调度的最小单位，同一 Pod 中的容器始终被一起调度。

### Controller

Kubernetes 通常不会直接创建 Pod ，而是通过 Controller 来管理 Pod 。Controller 中定义了 Pod 的部署特性。有多种 Controller ：

* Deployment

  最常用。可以管理 Pod 的多个副本，并确保 Pod 按照期望的状态运行。

* ReplicaSet

  实现了 Pod 的多副本管理。使用 Deployment 时会自动创建 ReplicaSet 。Deployment 是通过 ReplicaSet 来管理 Pod 的多个副本。

* DaemonSet

  用于每个 Node 最多只运行一个 Pod 副本的场景。通常用于运行 daemon 。

* StatefuleSet

  能保证 Pod 的每个副本在整个生命周期中名称是不变的，而其他 Controller 不提供这个功能。当某个 Pod 发生故障需要删除并重新启动时， Pod 的名称会发生变化。StatefulSet 会保证副本按照固定的顺序启动、更新或者删除。

* Job

  用于运行结束就删除的应用。

### Service

定义了外界访问一组特定 Pod 的方式。Service 有自己的 IP 和端口，为 Pod 提供了负载均衡。

### Namespace

将一个物理的 Cluster 逻辑上划分成多个虚拟 Cluster ,每个 Cluster 就是一个 Namespace 。不同的 Namespace 里的资源时完全隔离的。

Kubernetes 默认创建了两个 Namespace :

* default

  创建资源时，如果不指定，将被放到这个 Namespace 中。

* kube-system

  Kubernetes 自己创建的系统资源将放到这个 Nampspace 中。

## 安装

| ID   | IP             | hostname   |
| ---- | -------------- | ---------- |
| 1    | 192.168.16.105 | k8s-master |
| 2    | 192.168.16.106 | k8s-node1  |
| 3    | 192.168.16.107 | k8s-node2  |

### 安装 Docker

```bash
# all hosts
# Ubuntu
apt-get update && apt-get install docker.io
```

### 安装 kubelet、kubeadm 和 kubectl

在所有节点上安装。

* kubelet 运行在 Cluster 所有节点，负责启动 Pod 和容器。
* kubeadm 用于初始化 Cluster 。
* kubectl 是 Kubernetes 命令行工具。

```bash
# all hosts
# Ubuntu
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

### 创建 Cluster

#### 初始化 Master

```bash
# k8s-master
kubeadm init --apiserver-advertise-address 192.168.16.105 --pod-network-cidr=10.244.0.0/16

# --apiserver-advertise-address 指明用 Master 的那个 interface 与 Cluster 的其他节点通信。
# --pod-network-cidr            指定 Pod 网络的范围。此处使用 flannel 网络方案。
```

#### 配置 kubectl

```bash
# k8s-master
# Ubuntu
su - krupp	# 建议用普通用户
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### 安装 Pod 网络

```bash
# k8s-master
# flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

#### 添加 node 节点

```bash
# node hosts
kubeadm join --token d38a01.134532add343c1883 192.168.16.105:6443\

# 如丢失 token ,可通过如下命令查看、
kubeadm token list

# 查看节点状态
kubectl get nodes
# 状态在所有组件未完成启动前，应该是NotReady

# 查看 Pod 状态。
kubectl get pod --all-namespaces

# 查看某个 Pod 具体情况。
kubectl describe pod pod_name --namespace=kube-system

# 查看集群信息
kubectl cluster-info

Kubernetes control plane is running at https://127.0.0.1:8443
KubeDNS is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
KubeDNSUpstream is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/kube-dns-upstream:dns/proxy
Metrics-server is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## 节点

### Master

Master 节点是主节点。

运行着的服务包括：

* kube-apiserver

  提供 http/https RESTful API，即 Kubernetes API 。是 Kubernetes Cluster 的前端接口，各种客户端工具以及 Kubernetes 其他组件可以通过它管理 Cluster 的各种资源。

* kube-scheduler

  负责决定将 Pod 放在哪个 Node 上运行。 Scheduler 在调度时会充分考虑 Cluster 的拓扑结构，当前各个节点的负载，以及应用对高可用、性能、数据亲和性的需求。

* kube-controller-manager

  负责管理 Cluster 各种资源，保证资源处于预期的状态。有多种 controller 组成，包括：

  * replication controller

    管理 Deployment、StatefulSet、DaemonSet 的生命周期。

  * endpoints controller

  * namespace controller

    管理 Namespace 资源。

  * serviceaccounts controller

* etcd

  负责保存 Kubernetes Cluster 的配置信息和各种资源的状态信息。当数据发生变化时，etcd 会快速地通知 Kubernetes 相关组件。

* Pod 网络

### Node



## 部署应用

```bash
kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080
# 应用名称为 kubernetes-bootcamp
# --image Docker镜像
# --port  应用对外服务的端口
```

## Pod

Pod 是容器的集合，通常会将紧密相关的一组容器放到1个 Pod 中，同一个 Pod 中的所有容器共享 IP 地址和 Port 空间，即在一个 network namespace 中。

### 使用方式

* 运行单一容器。
* 运行多个容器。

获取 Pod 信息：

```bash
kubectl get pods

NAME           READY   STATUS    RESTARTS   AGE
centos-nginx   1/1     Running   0          109m
```

## 访问应用

默认情况下，所有 Pod 只能在集群内部访问。为了能在外部访问应用，需要将容器的端口映射到节点的端口。

```bash
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
```

查看应用被映射到节点的哪个端口：

```bash
kubectl get services

NAME         		TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)  		 AGE
kubernetes   		ClusterIP   10.11.254.1   <none>        443/TCP  		 6d18h
kubernetes-bootcamp				10.0.0.131	  <nodes>		8080:32320/TCP	 6d18h
```

## Scale 应用

默认情况下应用只会运行一个副本，查看副本数：

```bash
kubectl get deployments

NAME				DESIRED	CURRENT	UP-TO-DATE	AVAILABLE	AGE
kubernetes-bootcamp	1		1		1			1			15m
```

增加副本数：

```bash
kubectl scale deployments/kubernetes-bootcamp --replicas=3
# 副本数和pod增加到3个
kubectl get deployments
kubectl get pods
```

减少副本数：

```bash
kubectl scale deployments/kubernetes-bootcamp --replicas=2
```

## 滚动更新

使用新 image 更新：

```bash
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
```

版本回退：

```bash
kubectl rollout undo deployments/kubernetes-bootcamp
```

