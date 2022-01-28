# Kubernetes

[TOC]

## 概述

Kubernetes 是一个可移植的、可扩展的开源平台，是一个开源的容器编排引擎。用于管理容器化的工作负载和服务，可促进声明式配置和自动化。 Kubernetes 拥有一个庞大且快速增长的生态系统。可以实现容器集群的自动化部署、自动扩缩容、维护等功能。

**Kubernetes** 这个名字源于希腊语，意为“舵手”或“飞行员”。k8s 这个缩写是因为 k 和 s 之间有八个字符的关系。

Google 在 2014 年开源了 Kubernetes 项目，是 Google Omega 的开源版本（原名 Borg）。

## 功能

- **服务发现和负载均衡**

  Kubernetes 可以使用 DNS 名称或自己的 IP 地址公开容器，如果进入容器的流量很大， Kubernetes 可以负载均衡并分配网络流量，从而使部署稳定。

- **存储编排**

  Kubernetes 允许自动挂载选择的存储系统，例如本地存储、公共云提供商等。

- **自动部署和回滚**

  可以使用 Kubernetes 描述已部署容器的所需状态，可以以受控的速率将实际状态更改为期望状态。例如，可以自动化 Kubernetes 来为部署创建新容器， 删除现有容器并将它们的所有资源用于新容器。

- **自动完成装箱计算**

  Kubernetes 允许指定每个容器所需 CPU 和内存（RAM）。 当容器指定了资源请求时，Kubernetes 可以做出更好的决策来管理容器的资源。

- **自我修复**

  Kubernetes 重新启动失败的容器、替换容器、杀死不响应用户定义的运行状况检查的容器，并且在准备好服务之前不将其通告给客户端。

- **密钥与配置管理**

  Kubernetes 允许存储和管理敏感信息，例如密码、OAuth 令牌和 ssh 密钥。可以在不重建容器镜像的情况下部署和更新密钥和应用程序配置，也无需在堆栈配置中暴露密钥。

## Kubernetes 不是什么

Kubernetes 不是传统的、包罗万象的 PaaS（平台即服务）系统。 由于 Kubernetes 在容器级别而不是在硬件级别运行，它提供了 PaaS 产品共有的一些普遍适用的功能， 例如部署、扩展、负载均衡、日志记录和监视。 但是，Kubernetes 不是单体系统，默认解决方案都是可选和可插拔的。 Kubernetes 提供了构建开发人员平台的基础，但是在重要的地方保留了用户的选择和灵活性。

- 不限制支持的应用程序类型。 Kubernetes 旨在支持极其多种多样的工作负载，包括无状态、有状态和数据处理工作负载。 如果应用程序可以在容器中运行，那么它应该可以在 Kubernetes 上很好地运行。
- 不部署源代码，也不构建你的应用程序。 持续集成(CI)、交付和部署（CI/CD）工作流取决于组织的文化和偏好以及技术要求。
- 不提供应用程序级别的服务作为内置服务，例如中间件（例如，消息中间件）、 数据处理框架（例如，Spark）、数据库（例如，mysql）、缓存、集群存储系统 （例如，Ceph）。这样的组件可以在 Kubernetes 上运行，并且/或者可以由运行在 Kubernetes 上的应用程序通过可移植机制（例如， [开放服务代理](https://openservicebrokerapi.org/)）来访问。

- 不要求日志记录、监视或警报解决方案。 它提供了一些集成作为概念证明，并提供了收集和导出指标的机制。
- 不提供或不要求配置语言/系统（例如 jsonnet），它提供了声明性 API， 该声明性 API 可以由任意形式的声明性规范所构成。
- 不提供也不采用任何全面的机器配置、维护、管理或自我修复系统。
- 此外，Kubernetes 不仅仅是一个编排系统，实际上它消除了编排的需要。 编排的技术定义是执行已定义的工作流程：首先执行 A，然后执行 B，再执行 C。 相比之下，Kubernetes 包含一组独立的、可组合的控制过程， 这些过程连续地将当前状态驱动到所提供的所需状态。 如何从 A 到 C 的方式无关紧要，也不需要集中控制，这使得系统更易于使用 且功能更强大、系统更健壮、更为弹性和可扩展。

## 组件

一个 Kubernetes 集群由一组被称作节点的机器组成。这些节点上运行 Kubernetes 所管理的容器化应用。集群具有至少一个工作节点。

工作节点托管作为应用负载的组件的 Pod 。

控制平面管理集群中的工作节点和 Pod 。为集群提供故障转移和高可用性，控制平面一般跨多主机运行，集群跨多个节点运行。

![Kubernetes 组件](../../../../Image/c/components-of-kubernetes.svg)

### 控制平面组件（Control Plane Components）   

控制平面的组件对集群做出全局决策(比如调度)，以及检测和响应集群事件。

控制平面组件可以在集群中的任何节点上运行。为了简单起见，设置脚本通常会在同一个计算机上启动所有控制平面组件， 并且不会在此计算机上运行用户容器。

#### kube-apiserver

API 服务器是 Kubernetes 控制面的前端， 该组件公开了 Kubernetes API。

API 服务器的主要实现是 kube-apiserver 。kube-apiserver 设计上考虑了水平伸缩，可通过部署多个实例进行伸缩。

#### etcd

etcd 是兼具一致性和高可用性的键值数据库，保存 Kubernetes 所有集群数据的后台数据库。通常需要有个备份计划。

#### kube-scheduler

负责监视新创建的、未指定运行节点（node) 的 Pods ，选择节点让 Pod 在上面运行。

调度决策考虑的因素包括单个 Pod 和 Pod 集合的资源需求、硬件/软件/策略约束、亲和性和反亲和性规范、数据位置、工作负载间的干扰和最后时限。

#### kube-controller-manager

运行控制器进程的控制平面组件。

从逻辑上讲，每个控制器都是一个单独的进程， 但是为了降低复杂性，它们都被编译到同一个可执行文件，并在一个进程中运行。

- 节点控制器（Node Controller）: 负责在节点出现故障时进行通知和响应
- 任务控制器（Job controller）: 监测代表一次性任务的 Job 对象，然后创建 Pods 来运行这些任务直至完成
- 端点控制器（Endpoints Controller）: 填充端点(Endpoints)对象(即加入 Service 与 Pod)
- 服务帐户和令牌控制器（Service Account & Token Controllers）: 为新的命名空间创建默认帐户和 API 访问令牌

#### cloud-controller-manager

云控制器管理器是指嵌入特定云的控制逻辑的控制平面组件。云控制器管理器使得可以将集群连接到云提供商的 API 之上， 并将与该云平台交互的组件同与己方集群交互的组件分离开来。

`cloud-controller-manager` 仅运行特定于云平台的控制回路。 如果在自己的环境中运行 Kubernetes，或者在本地计算机中运行学习环境， 所部署的环境中不需要云控制器管理器。

与 `kube-controller-manager` 类似，`cloud-controller-manager` 将若干逻辑上独立的控制回路组合到同一个可执行文件中，以同一进程的方式运行。可以对其执行水平扩容（运行不止一个副本）以提升性能或者增强容错能力。

下面的控制器都包含对云平台驱动的依赖：

- 节点控制器（Node Controller）: 用于在节点终止响应后检查云提供商以确定节点是否已被删除
- 路由控制器（Route Controller）: 用于在底层云基础架构中设置路由
- 服务控制器（Service Controller）: 用于创建、更新和删除云提供商负载均衡器

### Node 组件 

在每个节点上运行，维护运行的 Pod 并提供 Kubernetes 运行环境。

#### kubelet

在集群中每个节点（node）上运行的代理。 它保证容器（containers）都运行在 Pod 中。

接收一组通过各类机制提供给它的 PodSpecs，确保这些 PodSpecs 中描述的容器处于运行状态且健康。 不会管理不是由 Kubernetes 创建的容器。

#### kube-proxy

是集群中每个节点上运行的网络代理， 实现 Kubernetes 服务（Service）概念的一部分。

维护节点上的网络规则。这些网络规则允许从集群内部或外部的网络会话与 Pod 进行网络通信。

如果操作系统提供了数据包过滤层并可用的话，kube-proxy 会通过它来实现网络规则。否则， kube-proxy 仅转发流量本身。

#### Container Runtime   

负责运行容器的软件。

Kubernetes 支持多个 Container Runtime 环境: Docker 、containerd 、CRI-O 以及任何实现 Kubernetes CRI (容器运行环境接口)。

### 插件（Addons）   

插件使用 Kubernetes 资源（DaemonSet、 Deployment 等）实现集群功能。 因为这些插件提供集群级别的功能，插件中命名空间域的资源属于 `kube-system` 命名空间。

#### DNS  

尽管其他插件都并非严格意义上的必需组件，但几乎所有 Kubernetes 集群都应该有集群 DNS 。

集群 DNS 是一个 DNS 服务器，和环境中的其他 DNS 服务器一起工作，它为 Kubernetes 服务提供 DNS 记录。

Kubernetes 启动的容器自动将此 DNS 服务器包含在其 DNS 搜索列表中。

#### Web 界面（仪表盘）

Dashboard 是 Kubernetes 集群的通用的、基于 Web 的用户界面。使用户可以管理集群中运行的应用程序以及集群本身并进行故障排除。

#### 容器资源监控

容器资源监控将关于容器的一些常见的时间序列度量值保存到一个集中的数据库中，并提供用于浏览这些数据的界面。

#### 集群层面日志

集群层面日志机制负责将容器的日志数据保存到一个集中的日志存储中，该存储能够提供搜索和浏览接口。



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



## 生产环境

生产质量的 Kubernetes 集群需要规划和准备。 如果你的 Kubernetes 集群是用来运行关键负载的，该集群必须被配置为弹性的（Resilient）。 本页面阐述你在安装生产就绪的集群或将现有集群升级为生产用途时可以遵循的步骤。 

## 生产环境考量 

通常，一个生产用 Kubernetes 集群环境与个人学习、开发或测试环境所使用的 Kubernetes 相比有更多的需求。生产环境可能需要被很多用户安全地访问，需要 提供一致的可用性，以及能够与需求变化相适配的资源。

在你决定在何处运行你的生产用 Kubernetes 环境（在本地或者在云端），以及 你希望承担或交由他人承担的管理工作量时，需要考察以下因素如何影响你对 Kubernetes 集群的需求：

- 可用性

  ：一个单机的 Kubernetes 

  学习环境

  具有单点失效特点。创建高可用的集群则意味着需要考虑：

  - 将控制面与工作节点分开
  - 在多个节点上提供控制面组件的副本
  - 为针对集群的 [API 服务器](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-apiserver/) 的流量提供负载均衡
  - 随着负载的合理需要，提供足够的可用的（或者能够迅速变为可用的）工作节点

- *规模*：如果你预期你的生产用 Kubernetes 环境要承受固定量的请求， 你可能可以针对所需要的容量来一次性完成安装。 不过，如果你预期服务请求会随着时间增长，或者因为类似季节或者特殊事件的 原因而发生剧烈变化，你就需要规划如何处理请求上升时对控制面和工作节点 的压力，或者如何缩减集群规模以减少未使用资源的消耗。

- *安全性与访问管理*：在你自己的学习环境 Kubernetes 集群上，你拥有完全的管理员特权。 但是针对运行着重要工作负载的共享集群，用户账户不止一两个时，就需要更细粒度 的方案来确定谁或者哪些主体可以访问集群资源。 你可以使用基于角色的访问控制（[RBAC](https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/)） 和其他安全机制来确保用户和负载能够访问到所需要的资源，同时确保工作负载及集群 自身仍然是安全的。 你可以通过管理[策略](https://kubernetes.io/zh/docs/concets/policy/)和 [容器资源](https://kubernetes.io/zh/docs/concepts/configuration/manage-resources-containers)来 针对用户和工作负载所可访问的资源设置约束，

在自行构造 Kubernetes 生产环境之前，请考虑将这一任务的部分或者全部交给 [云方案承包服务](https://kubernetes.io/zh/docs/setup/production-environment/turnkey-solutions) 提供商或者其他 [Kubernetes 合作伙伴](https://kubernetes.io/partners/)。 选项有：

- *无服务*：仅是在第三方设备上运行负载，完全不必管理集群本身。你需要为 CPU 用量、内存和磁盘请求等付费。
- *托管控制面*：让供应商决定集群控制面的规模和可用性，并负责打补丁和升级等操作。
- *托管工作节点*：配置一个节点池来满足你的需要，由供应商来确保节点始终可用， 并在需要的时候完成升级。
- *集成*：有一些供应商能够将 Kubernetes 与一些你可能需要的其他服务集成， 这类服务包括存储、容器镜像仓库、身份认证方法以及开发工具等。

无论你是自行构造一个生产用 Kubernetes 集群还是与合作伙伴一起协作，请审阅 下面章节以评估你的需求，因为这关系到你的集群的 *控制面*、*工作节点*、 *用户访问* 以及 *负载资源*。

## 生产用集群安装 

在生产质量的 Kubernetes 集群中，控制面用不同的方式来管理集群和可以 分布到多个计算机上的服务。每个工作节点则代表的是一个可配置来运行 Kubernetes Pods 的实体。

### 生产用控制面 

最简单的 Kubernetes 集群中，整个控制面和工作节点服务都运行在同一台机器上。 你可以通过添加工作节点来提升环境能力，正如 [Kubernetes 组件](https://kubernetes.io/zh/docs/concepts/overview/components/)示意图所示。 如果只需要集群在很短的一段时间内可用，或者可以在某些事物出现严重问题时直接丢弃， 这种配置可能符合你的需要。

如果你需要一个更为持久的、高可用的集群，那么你就需要考虑扩展控制面的方式。 根据设计，运行在一台机器上的单机控制面服务不是高可用的。 如果保持集群处于运行状态并且需要确保在出现问题时能够被修复这点很重要， 可以考虑以下步骤：

- *选择部署工具*：你可以使用类似 kubeadm、kops 和 kubespray 这类工具来部署控制面。 参阅[使用部署工具安装 Kubernetes](https://kubernetes.io/zh/docs/setup/production-environment/tools/) 以了解使用这类部署方法来完成生产就绪部署的技巧。 存在不同的[容器运行时](https://kubernetes.io/zh/docs/setup/production-environment/container-runtimes/) 可供你的部署采用。

- *管理证书*：控制面服务之间的安全通信是通过证书来完成的。证书是在部署期间 自动生成的，或者你也可以使用你自己的证书机构来生成它们。 参阅 [PKI 证书和需求](https://kubernetes.io/zh/docs/setup/best-practices/certificates/)了解细节。

- *为 API 服务器配置负载均衡*：配置负载均衡器来将外部的 API 请求散布给运行在 不同节点上的 API 服务实例。参阅 [创建外部负载均衡器](https://kubernetes.io/zh/docs/access-application-cluster/create-external-load-balancer/) 了解细节。

- *分离并备份 etcd 服务*：etcd 服务可以运行于其他控制面服务所在的机器上， 也可以运行在不同的机器上以获得更好的安全性和可用性。 因为 etcd 存储着集群的配置数据，应该经常性地对 etcd 数据库进行备份， 以确保在需要的时候你可以修复该数据库。与配置和使用 etcd 相关的细节可参阅 [etcd FAQ](https://kubernetes.io/https://etcd.io/docs/v3.4/faq/)。 更多的细节可参阅[为 Kubernetes 运维 etcd 集群](https://kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/) 和[使用 kubeadm 配置高可用的 etcd 集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)。

- *创建多控制面系统*：为了实现高可用性，控制面不应被限制在一台机器上。 如果控制面服务是使用某 init 服务（例如 systemd）来运行的，每个服务应该 至少运行在三台机器上。不过，将控制面作为服务运行在 Kubernetes Pods 中可以确保你所请求的个数的服务始终保持可用。 调度器应该是可容错的，但不是高可用的。 某些部署工具会安装 [Raft](https://raft.github.io/) 票选算法来对 Kubernetes 服务执行领导者选举。如果主节点消失，另一个服务会被选中并接手相应服务。

- *跨多个可用区*：如果保持你的集群一直可用这点非常重要，可以考虑创建一个跨 多个数据中心的集群；在云环境中，这些数据中心被视为可用区。 若干个可用区在一起可构成地理区域。 通过将集群分散到同一区域中的多个可用区内，即使某个可用区不可用，整个集群 能够继续工作的机会也大大增加。 更多的细节可参阅[跨多个可用区运行](https://kubernetes.io/zh/docs/setup/best-practices/multiple-zones/)。

- *管理演进中的特性*：如果你计划长时间保留你的集群，就需要执行一些维护其 健康和安全的任务。例如，如果你采用 kubeadm 安装的集群，则有一些可以帮助你完成 [证书管理](https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/) 和[升级 kubeadm 集群](https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade) 的指令。 参见[管理集群](https://kubernetes.io/zh/docs/tasks/administer-cluster)了解一个 Kubernetes 管理任务的较长列表。

要了解运行控制面服务时可使用的选项，可参阅 [kube-apiserver](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-apiserver/)、 [kube-controller-manager](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-controller-manager/) 和 [kube-scheduler](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-scheduler/) 组件参考页面。 如要了解高可用控制面的例子，可参阅 [高可用拓扑结构选项](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/ha-topology/)、 [使用 kubeadm 创建高可用集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/high-availability/) 以及[为 Kubernetes 运维 etcd 集群](https://kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/)。 关于制定 etcd 备份计划，可参阅 [对 etcd 集群执行备份](https://kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster)。

### 生产用工作节点

生产质量的工作负载需要是弹性的；它们所依赖的其他组件（例如 CoreDNS）也需要是弹性的。 无论你是自行管理控制面还是让云供应商来管理，你都需要考虑如何管理工作节点 （有时也简称为*节点*）。

- 配置节点

  ：节点可以是物理机或者虚拟机。如果你希望自行创建和管理节点， 你可以安装一个受支持的操作系统，之后添加并运行合适的

  节点服务

  。 考虑：

  - 在安装节点时要通过配置适当的内存、CPU 和磁盘速度、存储容量来满足 你的负载的需求。
  - 是否通用的计算机系统即足够，还是你有负载需要使用 GPU 处理器、Windows 节点 或者 VM 隔离。

- *验证节点*：参阅[验证节点配置](https://kubernetes.io/zh/docs/setup/best-practices/node-conformance/) 以了解如何确保节点满足加入到 Kubernetes 集群的需求。

- *添加节点到集群中*：如果你自行管理你的集群，你可以通过安装配置你的机器， 之后或者手动加入集群，或者让它们自动注册到集群的 API 服务器。参阅 [节点](https://kubernetes.io/zh/docs/concepts/architecture/nodes/)节，了解如何配置 Kubernetes 以便以这些方式来添加节点。

- *向集群中添加 Windows 节点*：Kubernetes 提供对 Windows 工作节点的支持； 这使得你可以运行实现于 Windows 容器内的工作负载。参阅 [Kubernetes 中的 Windows](https://kubernetes.io/zh/docs/setup/production-environment/windows/) 了解进一步的详细信息。

- *扩缩节点*：制定一个扩充集群容量的规划，你的集群最终会需要这一能力。 参阅[大规模集群考察事项](https://kubernetes.io/zh/docs/setup/best-practices/cluster-large/) 以确定你所需要的节点数；这一规模是基于你要运行的 Pod 和容器个数来确定的。 如果你自行管理集群节点，这可能意味着要购买和安装你自己的物理设备。

- *节点自动扩缩容*：大多数云供应商支持 [集群自动扩缩器（Cluster Autoscaler）](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler#readme) 以便替换不健康的节点、根据需求来增加或缩减节点个数。参阅 [常见问题](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md) 了解自动扩缩器的工作方式，并参阅 [Deployment](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler#deployment) 了解不同云供应商是如何实现集群自动扩缩器的。 对于本地集群，有一些虚拟化平台可以通过脚本来控制按需启动新节点。

- *安装节点健康检查*：对于重要的工作负载，你会希望确保节点以及在节点上 运行的 Pod 处于健康状态。通过使用 [Node Problem Detector](https://kubernetes.io/zh/docs/tasks/debug-application-cluster/monitor-node-health/)， 你可以确保你的节点是健康的。

### 生产级用户环境

在生产环境中，情况可能不再是你或者一小组人在访问集群，而是几十 上百人需要访问集群。在学习环境或者平台原型环境中，你可能具有一个 可以执行任何操作的管理账号。在生产环境中，你可需要对不同名字空间 具有不同访问权限级别的很多账号。

建立一个生产级别的集群意味着你需要决定如何有选择地允许其他用户访问集群。 具体而言，你需要选择验证尝试访问集群的人的身份标识（身份认证），并确定 他们是否被许可执行他们所请求的操作（鉴权）：

- *认证（Authentication）*：API 服务器可以使用客户端证书、持有者令牌、身份 认证代理或者 HTTP 基本认证机制来完成身份认证操作。 你可以选择你要使用的认证方法。通过使用插件，API 服务器可以充分利用你所在 组织的现有身份认证方法，例如 LDAP 或者 Kerberos。 关于认证 Kubernetes 用户身份的不同方法的描述，可参阅 [身份认证](https://kubernetes.io/zh/docs/reference/access-authn-authz/authentication/)。

- 鉴权（Authorization）

  ：当你准备为一般用户执行权限判定时，你可能会需要 在 RBAC 和 ABAC 鉴权机制之间做出选择。参阅

  鉴权概述

  ，了解 对用户账户（以及访问你的集群的服务账户）执行鉴权的不同模式。

  - *基于角色的访问控制*（[RBAC](https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/)）： 让你通过为通过身份认证的用户授权特定的许可集合来控制集群访问。 访问许可可以针对某特定名字空间（Role）或者针对整个集群（CLusterRole）。 通过使用 RoleBinding 和 ClusterRoleBinding 对象，这些访问许可可以被 关联到特定的用户身上。

  - *基于属性的访问控制*（[ABAC](https://kubernetes.io/zh/docs/reference/access-authn-authz/abac/)）： 让你能够基于集群中资源的属性来创建访问控制策略，基于对应的属性来决定 允许还是拒绝访问。策略文件的每一行都给出版本属性（apiVersion 和 kind） 以及一个规约属性的映射，用来匹配主体（用户或组）、资源属性、非资源属性 （/version 或 /apis）和只读属性。 参阅[示例](https://kubernetes.io/zh/docs/reference/access-authn-authz/abac/#examples)以了解细节。

作为在你的生产用 Kubernetes 集群中安装身份认证和鉴权机制的负责人， 要考虑的事情如下：

- *设置鉴权模式*：当 Kubernetes API 服务器 （[kube-apiserver](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)） 启动时，所支持的鉴权模式必须使用 `--authorization-mode` 标志配置。 例如，`kube-apiserver.yaml`（位于 `/etc/kubernetes/manifests` 下）中对应的 标志可以设置为 `Node,RBAC`。这样就会针对已完成身份认证的请求执行 Node 和 RBAC 鉴权。

- *创建用户证书和角色绑定（RBAC）*：如果你在使用 RBAC 鉴权，用户可以创建 由集群 CA 签名的 CertificateSigningRequest（CSR）。接下来你就可以将 Role 和 ClusterRole 绑定到每个用户身上。 参阅[证书签名请求](https://kubernetes.io/zh/docs/reference/access-authn-authz/certificate-signing-requests/) 了解细节。

- *创建组合属性的策略（ABAC）*：如果你在使用 ABAC 鉴权，你可以设置属性组合 以构造策略对所选用户或用户组执行鉴权，判定他们是否可访问特定的资源 （例如 Pod）、名字空间或者 apiGroup。进一步的详细信息可参阅 [示例](https://kubernetes.io/zh/docs/reference/access-authn-authz/abac/#examples)。

- *考虑准入控制器*：针对指向 API 服务器的请求的其他鉴权形式还包括 [Webhook 令牌认证](https://kubernetes.io/zh/docs/reference/access-authn-authz/authentication/#webhook-token-authentication)。 Webhook 和其他特殊的鉴权类型需要通过向 API 服务器添加 [准入控制器](https://kubernetes.io/zh/docs/reference/access-authn-authz/admission-controllers/) 来启用。

## 为负载资源设置约束 

生产环境负载的需求可能对 Kubernetes 的控制面内外造成压力。 在针对你的集群的负载执行配置时，要考虑以下条目：

- *设置名字空间限制*：为每个名字空间的内存和 CPU 设置配额。 参阅[管理内存、CPU 和 API 资源](https://kubernetes.io/zh/docs/tasks/administer-cluster/manage-resources/) 以了解细节。你也可以设置 [层次化名字空间](https://kubernetes.io/blog/2020/08/14/introducing-hierarchical-namespaces/) 来继承这类约束。

- *为 DNS 请求做准备*：如果你希望工作负载能够完成大规模扩展，你的 DNS 服务 也必须能够扩大规模。参阅 [自动扩缩集群中 DNS 服务](https://kubernetes.io/zh/docs/tasks/administer-cluster/dns-horizontal-autoscaling/)。

- 创建额外的服务账户

  ：用户账户决定用户可以在集群上执行的操作，服务账号则定义的 是在特定名字空间中 Pod 的访问权限。 默认情况下，Pod 使用所在名字空间中的 default 服务账号。 参阅

  管理服务账号

  以了解如何创建新的服务账号。例如，你可能需要：

  - 为 Pod 添加 Secret，以便 Pod 能够从某特定的容器镜像仓库拉取镜像。 参阅[为 Pod 配置服务账号](https://kubernetes.io/zh/docs/tasks/configure-pod-container/configure-service-account/) 以获得示例。
  - 为服务账号设置 RBAC 访问许可。参阅 [服务账号访问许可](https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/#service-account-permissions) 了解细节。

## 接下来

- 决定你是想自行构造自己的生产用 Kubernetes 还是从某可用的 [云服务外包厂商](https://kubernetes.io/zh/docs/setup/production-environment/turnkey-solutions/) 或 [Kubernetes 合作伙伴](https://kubernetes.io/partners/)获得集群。
- 如果你决定自行构造集群，则需要规划如何处理 [证书](https://kubernetes.io/zh/docs/setup/best-practices/certificates/) 并为类似 [etcd](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/) 和 [API 服务器](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/ha-topology/) 这些功能组件配置高可用能力。

- 选择使用 [kubeadm](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/)、 [kops](https://kubernetes.io/zh/docs/setup/production-environment/tools/kops/) 或 [Kubespray](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubespray/) 作为部署方法。

- 通过决定[身份认证](https://kubernetes.io/zh/docs/reference/access-authn-authz/authentication/)和 [鉴权](https://kubernetes.io/zh/docs/reference/access-authn-authz/authorization/)方法来配置用户管理。

- 通过配置[资源限制](https://kubernetes.io/zh/docs/tasks/administer-cluster/manage-resources/)、 [DNS 自动扩缩](https://kubernetes.io/zh/docs/tasks/administer-cluster/dns-horizontal-autoscaling/) 和[服务账号](https://kubernetes.io/zh/docs/reference/access-authn-authz/service-accounts-admin/) 来为应用负载作准备。

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

* kubelet

  是 Node 的 agent，当 Scheduler 确定在某个 Node 上运行 Pod 后，会将 Pod 的具体配置信息（image、volume等）发送给该节点的 kubelet 。kubelet 根据这些信息创建和运行容器，并向 Master 报告运行状态。是唯一没有以容器形式运行的组件。

* kube-proxy

  负责将访问 service 的 TCP/UDP 数据流转发到后端的容器。如有多个副本，kube-proxy 会实现负载均衡。

* Pod 网络

### Node

Pod 运行的地方。Kubernetes 支持 Docker、rkt 等容器 Runtime。Node 上运行的 Kubernetes 组件有：

* kubelet
* kube-proxy
* Pod 网络

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

## Deployment

为了实现在Kubernetes集群上部署容器化应用程序。需要创建一个Kubernetes  **[Deployment](http://docs.kubernetes.org.cn/317.html)，**Deployment负责创建和更新应用。创建Deployment后，Kubernetes master 会将Deployment创建好的应用实例调度到集群中的各个节点。

应用实例创建完成后，Kubernetes Deployment Controller会持续监视这些实例。如果管理实例的节点被关闭或删除，那么 Deployment Controller将会替换它们，实现自我修复能力。

“在旧的世界中” ，一般通常安装脚本来启动应用，但是便不会在机器故障后自动恢复。通过在[Node节点](http://docs.kubernetes.org.cn/304.html)上运行创建好的应用实例，使 Kubernetes Deployment 对应用管理提供了截然不同的方法。

### 运行 Deployment

过程：

1. 用户通过 kubectl 创建 Deployment 。
2. Deployment 创建 ReplicaSet 。
3. ReplicaSet 创建 Pod 。

```bash
kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080
# 应用名称为 kubernetes-bootcamp
# --image Docker镜像
# --port  应用对外服务的端口

kubectl run nginx-deployment --image=nginx --replicas=2

# 查看状态
kubectl get deployment nginx-deployment

# 查看详细信息
kubectl describe deployment nginx-deployment

# 查看replicaset
kubectl get replicaset
kubectl describe replicaset nginx-deployment-1260098868
```

### 创建资源的方式

1. 用 kubectl 命令直接创建。
2. 通过配置文件和 kubectl apply 创建。

### 配置文件

```yaml
apiVersion: extensions/v1beta1           # 当前配置格式的版本
kind: Deployment						 # 要创建资源的类型
metadata:                                # 资源的元数据
  name: nginx-deployment                 # 必需的元数据
spec:                                    # 规格说明
  replicas: 2							 # 副本数量
  template:                              # 定义 Pod 的模板
    metadata:                            # 定义 Pod 的元数据
      labels:
        app: web_server
    sepc:								 # 描述 Pod 的规格
      containers:
        name: nginx
        image: nginx:1.7.9
```





### 在Kubernetes上部署第一个应用程序

![img](https://d33wubrfki0l68.cloudfront.net/3854a4db66ad3dd4ede078865eff41510eeba7c0/33ac5/docs/tutorials/kubernetes-basics/public/images/module_02_first_app.svg)

使用Kubernetes [Kubectl](http://docs.kubernetes.org.cn/61.html)（命令管理工具）创建和管理Deployment。Kubectl使用Kubernetes API与集群进行交互。在本学习模块中，学会在Kubernetes集群上运行应用所需Deployment的Kubectl常见命令。

创建Deployment时，需要为应用程序指定容器镜像以及要运行的副本数，后续可以通过Deployment更新来更改该这些信息; bootcamp的第[5](https://kubernetes.io/docs/tutorials/kubernetes-basics/scale-intro/)和第[6](https://kubernetes.io/docs/tutorials/kubernetes-basics/update-intro/)部分讨论了如何扩展和更新Deployment。

知道Deployment是什么，[来看看在线教程并部署你的第一个应用](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-intro/)！

## Service













# 使用Minikube 部署 Kubernetes 集群

## 单机部署

创建Kubernetes cluster（单机版）最简单的方法是[minikube](https://github.com/kubernetes/minikube):

首先下载kubectl

```
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl
chmod +x kubectl
```

安装minikube

```
# install minikube
$ brew cask install minikube
$ brew install docker-machine-driver-xhyve
# docker-machine-driver-xhyve need root owner and uid
$ sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
$ sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

最后启动minikube

```
# start minikube.
# http proxy is required in China
$ minikube start --docker-env HTTP_PROXY=http://proxy-ip:port --docker-env HTTPS_PROXY=http://proxy-ip:port --vm-driver=xhyve
```

**开发版**

minikube/localkube只提供了正式release版本，而如果想要部署master或者开发版的话，则可以用hack/local-up-cluster.sh来启动一个本地集群：

```
cd $GOPATH/src/k8s.io/kubernetes

export KUBERNETES_PROVIDER=local
hack/install-etcd.sh
export PATH=$GOPATH/src/k8s.io/kubernetes/third_party/etcd:$PATH
hack/local-up-cluster.sh
```

打开另外一个终端，配置kubectl：

```sh
cd $GOPATH/src/k8s.io/kubernetes
export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig
cluster/kubectl.sh
```





# Kubernetes 中查看Pods和Nodes

- [1 Kubernetes Pod](http://docs.kubernetes.org.cn/115.html#Kubernetes_Pod)
- [2 Pod概述](http://docs.kubernetes.org.cn/115.html#Pod)
- [3 Node](http://docs.kubernetes.org.cn/115.html#Node)
- [4 Node概述](http://docs.kubernetes.org.cn/115.html#Node-2)
- [5 Troubleshooting with kubectl](http://docs.kubernetes.org.cn/115.html#Troubleshooting_with_kubectl)

## Kubernetes Pod

在模块[2中](http://docs.kubernetes.org.cn/113.html)创建Deployment时，Kubernetes会创建了一个[**Pod**](http://docs.kubernetes.org.cn/312.html)来托管应用。Pod是Kubernetes中一个抽象化概念，由一个或多个容器组合在一起得共享资源。这些资源包括：

- 共享存储，如 Volumes 卷
- 网络，唯一的集群IP地址
- 每个容器运行的信息，例如:容器镜像版本

*Pod模型是特定应用程序的“逻辑主机”，并且包含紧密耦合的不同应用容器。*

*Pod中的容器共享IP地址和端口。*

Pod是Kubernetes中的最小单位，当在Kubernetes上创建Deployment时，该Deployment将会创建具有容器的Pods（而不会直接创建容器），每个Pod将被绑定调度到Node节点上，并一直保持在那里直到被终止（根据配置策略）或删除。在节点出现故障的情况下，群集中的其他可用节点上将会调度之前相同的Pod。

## Pod概述

![img](https://d33wubrfki0l68.cloudfront.net/fe03f68d8ede9815184852ca2a4fd30325e5d15a/98064/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg)

 

## Node

一个Pod总是在一个[（**Node）****节点**](http://docs.kubernetes.org.cn/304.html)上运行，Node是Kubernetes中的工作节点，可以是虚拟机或物理机。每个Node由 Master管理，Node上可以有多个pod，Kubernetes  Master会自动处理群集中Node的pod调度，同时Master的自动调度会考虑每个Node上的可用资源。

每个Kubernetes Node上至少运行着：

- Kubelet，管理Kubernetes Master和Node之间的通信; 管理机器上运行的Pods和containers容器。
- container runtime（如Docker，rkt）。

## Node概述

![img](https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg)

 

## Troubleshooting with kubectl

在第[2单元中](http://docs.kubernetes.org.cn/113.html)，使用了Kubectl 命令管理工具。我们继续在模块3中使用它来获取有关Deployment的应用及其环境信息。常见的操作可以通过以下kubectl命令完成：

- **kubectl get -** 列出资源
- **kubectl describe** - 显示资源的详细信息
- **kubectl logs** - 打印pod中的容器日志
- **kubectl exec** - pod中容器内部执行命令

可以使用这些命令来查看应用程序何时部署、它们当前的状态是什么、它们在哪里运行以及它们的配置是什么。

现在我们已经了解了更多关于集群组件和命令的信息，[接下来让我们来探究一下应用](https://kubernetes.io/docs/tutorials/kubernetes-basics/explore-interactive/)。

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# Kubernetes 使用Service暴露应用

### Kubernetes Services概述

（凡人皆有一死来描述[pod](http://docs.kubernetes.org.cn/312.html)，没有比这跟准确的了）。事实上，Pod是有生命周期的。当一个工作节点(Node)销毁时，节点上运行的Pod也会销毁，然后通过ReplicationController动态创建新的Pods来保持应用的运行。作为另一个例子，考虑一个图片处理 backend，它运行了3个副本，这些副本是可互换的 —— 前端不需要关心它们调用了哪个 backend  副本。也就是说，Kubernetes集群中的每个Pod都有一个独立的IP地址，甚至是同一个节点上的Pod，因此需要有一种方式来自动协调各个Pod之间的变化，以便应用能够持续运行。

Enter *Services*。Kubernetes中的Service 是一个抽象的概念，它定义了Pod的逻辑分组和一种可以访问它们的策略，这组Pod能被Service访问，使用YAML [（优先）](https://kubernetes.io/docs/concepts/configuration/overview/#general-config-tips)或JSON 来定义Service，Service所针对的一组Pod通常由*LabelSelector*实现（参见下文，为什么可能需要没有 selector 的 Service）。

可以通过type在ServiceSpec中指定一个需要的类型的 Service，Service的四种type:

- *ClusterIP*（默认） - 在集群中内部IP上暴露服务。此类型使Service只能从群集中访问。
- *NodePort* - 通过每个 Node 上的 IP  和静态端口（NodePort）暴露服务。NodePort 服务会路由到 ClusterIP 服务，这个 ClusterIP 服务会自动创建。通过请求 <NodeIP>:<NodePort>，可以从集群的外部访问一个 NodePort 服务。
- *LoadBalancer* - 使用云提供商的负载均衡器（如果支持），可以向外部暴露服务。外部的负载均衡器可以路由到 NodePort 服务和 ClusterIP 服务。
- *ExternalName* - 通过返回 `CNAME` 和它的值，可以将服务映射到 `externalName` 字段的内容，没有任何类型代理被创建。这种类型需要v1.7版本或更高版本`kube-dnsc`才支持。

更多不同类型Service的信息，请参考“[Using Source IP](https://kubernetes.io/docs/tutorials/services/source-ip/)[”](https://kubernetes.io/docs/tutorials/services/source-ip/)教程，[Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service)。

使用*ExternalName类型可以实现一种情况*，在创建Service涉及未定义`selector`的示例，创建的Service `selector`不创建相应的Endpoints对象，可以通过手动将Service映射到特定Endpoints。

*Kubernetes Service 是一个抽象层，它定义了一组逻辑的Pods，借助Service，应用可以方便的实现服务发现与负载均衡。*

### Services和Labels

![img](https://d33wubrfki0l68.cloudfront.net/cc38b0f3c0fd94e66495e3a4198f2096cdecd3d5/ace10/docs/tutorials/kubernetes-basics/public/images/module_04_services.svg)

如上图，A中Service 路由一组Pods的流量。Service允许pod在Kubernetes中被销毁并复制pod而不影响应用。相关Pod之间的发现和路由（如应用中的前端和后端组件）由Kubernetes Services处理。

Service 使用[label selectors](http://docs.kubernetes.org.cn/247.html)来匹配一组Pod，允许对Kubernetes中的对象进行逻辑运算，Label以key/value 键/值对附加到对象上。以多种方式使用：

- 指定用于开发，测试和生产的对象
- 嵌入版本Label
- 使用Label分类对象

*你可以在使用
 `--expose`kubectl 创建 Deployment 的同时创建 Service 。*

 

![img](https://d33wubrfki0l68.cloudfront.net/b964c59cdc1979dd4e1904c25f43745564ef6bee/f3351/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg)

 

Label可以在创建时或以后附加到对象上，可以随时修改。

下一步：[使用在线互动教程](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose-interactive/)



# 使用kubectl实现应用伸缩

### 伸缩应用

在之前模块中，我们创建了一个[Deployment](http://docs.kubernetes.org.cn/317.html)，然后通过[Service](https://kubernetes.io/docs/concepts/services-networking/service/)暴露，Deployment创建的Pod来运行应用，当流量增加时，我们需要扩展应用来满足用户需求。

通过Deployment更改副本数可以实现**伸缩**。

## 伸缩概述

![img](https://d33wubrfki0l68.cloudfront.net/043eb67914e9474e30a303553d5a4c6c7301f378/0d8f6/docs/tutorials/kubernetes-basics/public/images/module_05_scaling1.svg)

![img](https://d33wubrfki0l68.cloudfront.net/30f75140a581110443397192d70a4cdb37df7bfc/b5f56/docs/tutorials/kubernetes-basics/public/images/module_05_scaling2.svg)

使用Deployment扩展能确保在新的可用Node资源上创建Pods，缩小比例将减少Pod的数量到理想状态。如果伸缩需求是0，将会终止Deployment指定的所有Pod。Kubernetes还支持[自动缩放](http://kubernetes.io/docs/user-guide/horizontal-pod-autoscaling/) Pods，本节将不做介绍。

运行应用将要考虑一些情况，需要将流量分配给所有实例。Service集成了负载均衡器，可以将网络流量分配到Deployment暴露的所有Pod中。Service将使用Endpoints持续监控运行的Pod，以确保仅将流量分配到可用的Pod。

下节将讨论如何在不停机的情况下进行滚动更新。现在让我们进入[在线终端进行伸缩我们的应用](https://kubernetes.io/docs/tutorials/kubernetes-basics/scale-interactive/)。



# 使用kubectl实现应用滚动更新

### 更新应用

用户需求：需要应用始终正常运行，开发人员每天需要部署新的版本*（一个简单例子，大家在玩游戏时常常碰到这类公告：8月8日凌晨：2点-6点服务升级，暂停所有服务.....）*。在Kubernetes中可以通过**滚动更新**（**Rolling updates** ）来完成。滚动更新通过Deployments实现应用实例在不中断、不停机情况下更新，新的Pod会逐步调度到可用的资源Node节点上。

在[前面的模块](http://docs.kubernetes.org.cn/122.html)中，我们对应用进行了[伸缩](http://docs.kubernetes.org.cn/122.html)，以运行多个实例。这是在不影响应用可用性的情况下执行更新的需求。更新时的Pod数量可以是数字或百分数(pod)来表示。在Kubernetes更新中，支持升级 / 回滚（恢复）更新。

## 滚动更新概述

（1）

![img](https://d33wubrfki0l68.cloudfront.net/30f75140a581110443397192d70a4cdb37df7bfc/fa906/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates1.svg)

（2）

![img](https://d33wubrfki0l68.cloudfront.net/678bcc3281bfcc588e87c73ffdc73c7a8380aca9/703a2/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates2.svg)

（3）

![img](https://d33wubrfki0l68.cloudfront.net/9b57c000ea41aca21842da9e1d596cf22f1b9561/91786/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates3.svg)

（4）

![img](https://d33wubrfki0l68.cloudfront.net/6d8bc1ebb4dc67051242bc828d3ae849dbeedb93/fbfa8/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates4.svg)

与应用伸缩相似，滚动更新是实现流量负载均衡方式。

滚动更新允许以下操作：

- 将应用从一个环境升级到另一个环境（通过容器镜像更新）
- 回滚到之前的版本
- 持续集成和持续交付应用的零停机

在下面的[交互式教程](https://kubernetes.io/docs/tutorials/kubernetes-basics/update-interactive/)中，我们的应用将更新到一个新的版本，并执行回滚。

、

# 使用Minikube集群

- - [0.1 目标](http://docs.kubernetes.org.cn/94.html#i)
  - [0.2 Kubernetes集群](http://docs.kubernetes.org.cn/94.html#Kubernetes)

- [1 集群结构图](http://docs.kubernetes.org.cn/94.html#i-2)

### 目标

- 了解Kubernetes集群是什么。
- 了解Minikube是什么。
- 使用在线终端启动Kubernetes群集。

### Kubernetes集群

Kubernetes将底层的计算资源连接在一起对外体现为一个高可用的计算机集群。Kubernetes将资源高度抽象化，允许将容器化的应用程序部署到集群中。为了使用这种新的部署模型，需要将应用程序和使用环境一起打包成容器。与过去的部署模型相比，容器化的应用程序更加灵活和可用，在新的部署模型中，应用程序被直接安装到特定的机器上，Kubernetes能够以更高效的方式在集群中实现容器的分发和调度运行。

Kubernetes集群包括两种类型资源：

- [Master节点](http://docs.kubernetes.org.cn/306.html)：协调控制整个集群。
- [Nodes节点](http://docs.kubernetes.org.cn/304.html)：运行应用的工作节点。

## 集群结构图

![img](https://d33wubrfki0l68.cloudfront.net/99d9808dcbf2880a996ed50d308a186b5900cec9/40b94/docs/tutorials/kubernetes-basics/public/images/module_01_cluster.svg)

Master 负责集群的管理。Master 协调集群中的所有行为/活动，例如应用的运行、修改、更新等。

（Node）节点作为Kubernetes集群中的工作节点，可以是VM虚拟机、物理机。每个node上都有一个Kubelet，用于管理node节点与Kubernetes Master通信。每个Node节点上至少还要运行container runtime（比如docker或者rkt）。

Kubernetes上部署应用程序时，会先通知master启动容器中的应用程序，master调度容器以在集群的节点上运行，node节点使用master公开的Kubernetes API与主节点进行通信。最终用户还可以直接使用Kubernetes API与集群进行交互。

Kubernetes集群可以部署在物理机或虚拟机上。使用Kubernetes开发时，你可以采用[Minikube](http://docs.kubernetes.org.cn/94.html)。Minikube可以实现一种轻量级的Kubernetes集群，通过在本地计算机上创建虚拟机并部署只包含单个节点的简单集群。Minikube适用于Linux，MacOS和Windows系统。Minikube CLI提供集群管理的基本操作，包括 start、stop、status、 和delete。

知道Kubernetes是什么了，在线互动教程中：[开始使用Minikube来部署集群](https://kubernetes.io/docs/tutorials/kubernetes-basics/cluster-interactive/)吧！！



# 使用Minikube在Kubernetes中运行应用

- [1 目标](http://docs.kubernetes.org.cn/126.html#i)
- [2 准备工作](http://docs.kubernetes.org.cn/126.html#i-2)
- [3 创建Minikube集群](http://docs.kubernetes.org.cn/126.html#Minikube)
- [4 创建Node.js应用程序](http://docs.kubernetes.org.cn/126.html#Nodejs)
- [5 创建Docker容器镜像](http://docs.kubernetes.org.cn/126.html#Docker)
- [6 创建Deployment](http://docs.kubernetes.org.cn/126.html#Deployment)
- [7 创建Service](http://docs.kubernetes.org.cn/126.html#Service)
- [8 更新应用程序](http://docs.kubernetes.org.cn/126.html#i-3)
- [9 清理删除](http://docs.kubernetes.org.cn/126.html#i-4)
- [10 下一步](http://docs.kubernetes.org.cn/126.html#i-5)

教程的目标是将简单的Hello World Node.js应用转换为在Kubernetes上运行的应用。本教程将学习如何使用自己开发的代码，将其转换为Docker容器镜像，然后在[Minikube](http://docs.kubernetes.org.cn/126.html)上运行该镜像。Minikube能够在本地非常简单的创建Kubernetes。

## 目标

- 运行hello world Node.js应用。
- 在Minikube上部署应用。
- 查看应用日志
- 更新应用镜像。

## 准备工作

- 对于OS X，需要[Homebrew](https://brew.sh/)来安装xhyve 驱动程序。
- [NodeJS](https://nodejs.org/en/)。
-  在OS X上安装Docker，推荐 [Docker for Mac](https://docs.docker.com/engine/installation/mac/)。

## 创建Minikube集群

本教程使用[Minikube](http://docs.kubernetes.org.cn/126.html)创建本地集群，默认使用 [Docker for Mac](https://docs.docker.com/engine/installation/mac/)。如果在不同的平台（如Linux）上，或使用VirtualBox而不是Docker for Mac，则安装Minikube方式有些不同。有关Minikube的详细安装说明，请参考[Minikube安装指南](http://docs.kubernetes.org.cn/126.html)。

使用curl下载并安装最新版本Minikube：

```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && \
  chmod +x minikube && \
  sudo mv minikube /usr/local/bin/
```

使用Homebrew安装xhyve驱动程序并设置其权限：

```
brew install docker-machine-driver-xhyve
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

使用Homebrew下载kubectl命令管理工具：

```
brew install kubectl
```

确定是否可以直接访问https://cloud.google.com/container-registry/网站（是否翻墙？）

```
curl --proxy "" https://cloud.google.com/container-registry/
```

如果不需代理，则启动Minikube集群：

```
minikube start --vm-driver=xhyve
```

如果需代理服务器，使用以下方法启动设置了代理的Minikube集群：

```
minikube start --vm-driver=xhyve --docker-env HTTP_PROXY=http://your-http-proxy-host:your-http-proxy-port  --docker-env HTTPS_PROXY=http(s)://your-https-proxy-host:your-https-proxy-port
```

--vm-driver=xhyve flag 指定Docker for Mac。默认的VM驱动程序VirtualBox。

设置Minikube 环境。可以在~/.kube/config文件中查看所有可用的环境 。

```
kubectl config use-context minikube
```

验证kubectl配置：

```
kubectl cluster-info
```

## 创建Node.js应用程序

下一步编写应用程序。将这段代码保存在一个名为hellonode的文件夹中，文件名server.js:

**server.js**

```
var http = require('http');

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end('Hello World!');
};
var www = http.createServer(handleRequest);
www.listen(8080);
```

运行应用：

```
node server.js
```

现在可以在http：// localhost：8080 / 中查看到“Hello World！”消息。

按Ctrl-C停止正在运行的Node.js服务器。

下一步将应用程序打包到Docker容器中。

## 创建Docker容器镜像

在hellonode文件夹中创建一个Dockerfile命名的文件。Dockerfile描述了build的镜像，通过现有的镜像扩展（extend）build Docker容器镜像，本教程中的镜像扩展（extend）了现有的Node.js镜像。

[Dockerfile ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tutorials/stateless-application/Dockerfile)

```
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
```

 

本教程使用Minikube，而不是将Docker镜像push到registry，可以使用与Minikube VM相同的Docker主机构建镜像，以使镜像自动存在。为此，请确保使用Minikube Docker守护进程：

```
eval $(minikube docker-env)
```

注意：如果不在使用Minikube主机时，可以通过运行eval $(minikube docker-env -u)来撤消此更改。

使用Minikube Docker守护进程build Docker镜像：

```
docker build -t hello-node:v1 .
```

好了Minikube VM可以运行构建好的镜像。

## 创建Deployment

Kubernetes [Pod](http://docs.kubernetes.org.cn/312.html)是一个或多个容器组合在一起得共享资源，本教程中的Pod只有一个容器。Kubernetes [Deployment](http://docs.kubernetes.org.cn/317.html) 是检查Pod的健康状况，如果它终止，则重新启动一个Pod的容器，Deployment管理Pod的创建和扩展。

使用kubectl run命令创建Deployment来管理Pod。Pod根据hello-node:v1Docker运行容器镜像：

```
kubectl run hello-node --image=hello-node:v1 --port=8080
```

查看Deployment：

```
kubectl get deployments
```

输出：

```
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-node   1         1         1            1           3m
```

查看Pod：

```
kubectl get pods
```

输出：

```
NAME                         READY     STATUS    RESTARTS   AGE
hello-node-714049816-ztzrb   1/1       Running   0          6m
```

查看群集events：

```
kubectl get events
```

查看kubectl配置：

```
kubectl config view
```

有关kubectl命令的更多信息，请参阅 [kubectl概述](http://docs.kubernetes.org.cn/61.html)。

## 创建Service

默认情况，这Pod只能通过Kubernetes群集内部IP访问。要使hello-node容器从Kubernetes虚拟网络外部访问，须要使用Kubernetes [Service](http://docs.kubernetes.org.cn/703.html)暴露Pod。

我们可以使用kubectl expose命令将Pod暴露到外部环境：

```
kubectl expose deployment hello-node --type=LoadBalancer
```

查看刚创建的Service：

```
kubectl get services
```

输出：

```
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
hello-node   10.0.0.71    <pending>     8080/TCP   6m
kubernetes   10.0.0.1     <none>        443/TCP    14d
```

通过--type=LoadBalancer  flag来在群集外暴露Service，在支持负载均衡的云提供商上，将配置外部IP地址来访问Service。在Minikube上，该LoadBalancer type使服务可以通过minikube Service 命令访问。

```
minikube service hello-node
```

将打开浏览器，在本地IP地址为应用提供服务，显示“Hello World”的消息。

最后可以查看到一些日志

```
kubectl logs <POD-NAME>
```

## 更新应用程序

编辑server.js文件以返回新消息：

```
response.end('Hello World Again!');
```

build新版本镜像

```
docker build -t hello-node:v2 .
```

Deployment更新镜像：

```
kubectl set image deployment/hello-node hello-node=hello-node:v2
```

再次运行应用以查看新消息：

```
minikube service hello-node
```

## 清理删除

现在可以删除在群集中创建的资源：

```
kubectl delete service hello-node
kubectl delete deployment hello-node
```

或者停止Minikube：

```
minikube stop
```

## 下一步

- 了解[Deployment对象](http://docs.kubernetes.org.cn/317.html)。
- 了解[Deploying applications](https://kubernetes.io/docs/user-guide/deploying-applications/).。
- 了解[Service对象](http://docs.kubernetes.org.cn/703.html)。

# Kubernetes 架构

- [1 Borg简介](http://docs.kubernetes.org.cn/251.html#Borg)
- 2 Kubernetes架构
  - [2.1 分层架构](http://docs.kubernetes.org.cn/251.html#i)

Kubernetes最初源于谷歌内部的Borg，提供了面向应用的容器集群部署和管理系统。Kubernetes  的目标旨在消除编排物理/虚拟计算，网络和存储基础设施的负担，并使应用程序运营商和开发人员完全将重点放在以容器为中心的原语上进行自助运营。Kubernetes 也提供稳定、兼容的基础（平台），用于构建定制化的workflows 和更高级的自动化任务。
 Kubernetes 具备完善的集群管理能力，包括多层次的安全防护和准入机制、多租户应用支撑能力、透明的服务注册和服务发现机制、内建负载均衡器、故障发现和自我修复能力、服务滚动升级和在线扩容、可扩展的资源自动调度机制、多粒度的资源配额管理能力。
 Kubernetes 还提供完善的管理工具，涵盖开发、部署测试、运维监控等各个环节。

## Borg简介

Borg是谷歌内部的大规模集群管理系统，负责对谷歌内部很多核心服务的调度和管理。Borg的目的是让用户能够不必操心资源管理的问题，让他们专注于自己的核心业务，并且做到跨多个数据中心的资源利用率最大化。

Borg主要由BorgMaster、Borglet、borgcfg和Scheduler组成，如下图所示

![borg](https://feisky.gitbooks.io/kubernetes/architecture/images/borg.png)

- BorgMaster是整个集群的大脑，负责维护整个集群的状态，并将数据持久化到Paxos存储中；
- Scheduer负责任务的调度，根据应用的特点将其调度到具体的机器上去；
- Borglet负责真正运行任务（在容器中）；
- borgcfg是Borg的命令行工具，用于跟Borg系统交互，一般通过一个配置文件来提交任务。

## Kubernetes架构

Kubernetes借鉴了Borg的设计理念，比如Pod、Service、Labels和单Pod单IP等。Kubernetes的整体架构跟Borg非常像，如下图所示

![architecture](https://feisky.gitbooks.io/kubernetes/architecture/images/architecture.png)

Kubernetes主要由以下几个核心组件组成：

- etcd保存了整个集群的状态；
- apiserver提供了资源操作的唯一入口，并提供认证、授权、访问控制、API注册和发现等机制；
- controller manager负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
- scheduler负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；
- kubelet负责维护容器的生命周期，同时也负责Volume（CVI）和网络（CNI）的管理；
- Container runtime负责镜像管理以及Pod和容器的真正运行（CRI）；
- kube-proxy负责为Service提供cluster内部的服务发现和负载均衡；

除了核心组件，还有一些推荐的Add-ons：

- kube-dns负责为整个集群提供DNS服务
- Ingress Controller为服务提供外网入口
- Heapster提供资源监控
- Dashboard提供GUI
- Federation提供跨可用区的集群
- Fluentd-elasticsearch提供集群日志采集、存储与查询

![img](https://feisky.gitbooks.io/kubernetes/architecture/images/14791969222306.png)

![img](https://feisky.gitbooks.io/kubernetes/architecture/images/14791969311297.png)

### 分层架构

Kubernetes设计理念和功能其实就是一个类似Linux的分层架构，如下图所示

![img](https://feisky.gitbooks.io/kubernetes/architecture/images/14937095836427.jpg)

- 核心层：Kubernetes最核心的功能，对外提供API构建高层的应用，对内提供插件式应用执行环境
- 应用层：部署（无状态应用、有状态应用、批处理任务、集群应用等）和路由（服务发现、DNS解析等）
- 管理层：系统度量（如基础设施、容器和网络的度量），自动化（如自动扩展、动态Provision等）以及策略管理（[RBAC](http://docs.kubernetes.org.cn/148.html)、Quota、PSP、NetworkPolicy等）
- 接口层：[kubectl命令行工具](http://docs.kubernetes.org.cn/61.html)、客户端SDK以及集群联邦
- 生态系统：在接口层之上的庞大容器集群管理调度的生态系统，可以划分为两个范畴
  - Kubernetes外部：日志、监控、配置管理、CI、CD、Workflow、FaaS、OTS应用、ChatOps等
  - Kubernetes内部：CRI、CNI、CVI、镜像仓库、Cloud Provider、集群自身的配置和管理等

> 关于分层架构，可以关注下Kubernetes社区正在推进的Kubernetes architectual roadmap (`https://docs.google.com/document/d/1XkjVm4bOeiVkj-Xt1LgoGiqWsBfNozJ51dyI-ljzt1o`，需要加入kubernetes-dev google groups才可以查看)。

> **说明**：本文内容来自至[feisky](https://feisky.gitbooks.io/kubernetes/architecture/architecture.html)的gitbook；

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	



# Kubernetes 设计理念

- 1 Kubernetes 设计理念
  - [1.1 Kubernetes设计理念与分布式系统](http://docs.kubernetes.org.cn/249.html#Kubernetes-2)
  - [1.2 API设计原则](http://docs.kubernetes.org.cn/249.html#API)
  - [1.3 控制机制设计原则](http://docs.kubernetes.org.cn/249.html#i)
- 2 Kubernetes的核心技术概念和API对象
  - [2.1 Pod](http://docs.kubernetes.org.cn/249.html#Pod)
  - [2.2 复制控制器（Replication Controller，RC）](http://docs.kubernetes.org.cn/249.html#Replication_ControllerRC)
  - [2.3 副本集（Replica Set，RS）](http://docs.kubernetes.org.cn/249.html#Replica_SetRS)
  - [2.4 部署(Deployment)](http://docs.kubernetes.org.cn/249.html#Deployment)
  - [2.5 服务（Service）](http://docs.kubernetes.org.cn/249.html#Service)
  - [2.6 任务（Job）](http://docs.kubernetes.org.cn/249.html#Job)
  - [2.7 后台支撑服务集（DaemonSet）](http://docs.kubernetes.org.cn/249.html#DaemonSet)
  - [2.8 有状态服务集（PetSet）](http://docs.kubernetes.org.cn/249.html#PetSet)
  - [2.9 集群联邦（Federation）](http://docs.kubernetes.org.cn/249.html#Federation)
  - [2.10 存储卷（Volume）](http://docs.kubernetes.org.cn/249.html#Volume)
  - [2.11 持久存储卷（Persistent Volume，PV）和持久存储卷声明（Persistent Volume Claim，PVC）](http://docs.kubernetes.org.cn/249.html#Persistent_VolumePVPersistent_Volume_ClaimPVC)
  - [2.12 节点（Node）](http://docs.kubernetes.org.cn/249.html#Node)
  - [2.13 密钥对象（Secret）](http://docs.kubernetes.org.cn/249.html#Secret)
  - [2.14 用户帐户（User Account）和服务帐户（Service Account）](http://docs.kubernetes.org.cn/249.html#User_AccountService_Account)
  - [2.15 名字空间（Namespace）](http://docs.kubernetes.org.cn/249.html#Namespace)
  - [2.16 RBAC访问授权](http://docs.kubernetes.org.cn/249.html#RBAC)
- [3 总结](http://docs.kubernetes.org.cn/249.html#i-2)
- [4 参考](http://docs.kubernetes.org.cn/249.html#i-3)

## Kubernetes 设计理念

### Kubernetes设计理念与分布式系统

分析和理解Kubernetes的设计理念可以使我们更深入地了解Kubernetes系统，更好地利用它管理分布式部署的云原生应用，另一方面也可以让我们借鉴其在分布式系统设计方面的经验。

### API设计原则

对于云计算系统，系统API实际上处于系统设计的统领地位，正如本文前面所说，K8s集群系统每支持一项新功能，引入一项新技术，一定会新引入对应的API对象，支持对该功能的管理操作，理解掌握的API，就好比抓住了K8s系统的牛鼻子。K8s系统API的设计有以下几条原则：

1. 所有API应该是声明式的。正如前文所说，声明式的操作，相对于命令式操作，对于重复操作的效果是稳定的，这对于容易出现数据丢失或重复的分布式环境来说是很重要的。另外，声明式操作更容易被用户使用，可以使系统向用户隐藏实现的细节，隐藏实现的细节的同时，也就保留了系统未来持续优化的可能性。此外，声明式的API，同时隐含了所有的API对象都是名词性质的，例如Service、Volume这些API都是名词，这些名词描述了用户所期望得到的一个目标分布式对象。
2. API对象是彼此互补而且可组合的。这里面实际是鼓励API对象尽量实现面向对象设计时的要求，即“高内聚，松耦合”，对业务相关的概念有一个合适的分解，提高分解出来的对象的可重用性。事实上，K8s这种分布式系统管理平台，也是一种业务系统，只不过它的业务就是调度和管理容器服务。
3. 高层API以操作意图为基础设计。如何能够设计好API，跟如何能用面向对象的方法设计好应用系统有相通的地方，高层设计一定是从业务出发，而不是过早的从技术实现出发。因此，针对K8s的高层API设计，一定是以K8s的业务为基础出发，也就是以系统调度管理容器的操作意图为基础设计。
4. 低层API根据高层API的控制需要设计。设计实现低层API的目的，是为了被高层API使用，考虑减少冗余、提高重用性的目的，低层API的设计也要以需求为基础，要尽量抵抗受技术实现影响的诱惑。
5. 尽量避免简单封装，不要有在外部API无法显式知道的内部隐藏的机制。简单的封装，实际没有提供新的功能，反而增加了对所封装API的依赖性。内部隐藏的机制也是非常不利于系统维护的设计方式，例如PetSet和ReplicaSet，本来就是两种Pod集合，那么K8s就用不同API对象来定义它们，而不会说只用同一个ReplicaSet，内部通过特殊的算法再来区分这个ReplicaSet是有状态的还是无状态。
6. API操作复杂度与对象数量成正比。这一条主要是从系统性能角度考虑，要保证整个系统随着系统规模的扩大，性能不会迅速变慢到无法使用，那么最低的限定就是API的操作复杂度不能超过O(N)，N是对象的数量，否则系统就不具备水平伸缩性了。
7. API对象状态不能依赖于网络连接状态。由于众所周知，在分布式环境下，网络连接断开是经常发生的事情，因此要保证API对象状态能应对网络的不稳定，API对象的状态就不能依赖于网络连接状态。
8. 尽量避免让操作机制依赖于全局状态，因为在分布式系统中要保证全局状态的同步是非常困难的。

### 控制机制设计原则

- 控制逻辑应该只依赖于当前状态。这是为了保证分布式系统的稳定可靠，对于经常出现局部错误的分布式系统，如果控制逻辑只依赖当前状态，那么就非常容易将一个暂时出现故障的系统恢复到正常状态，因为你只要将该系统重置到某个稳定状态，就可以自信的知道系统的所有控制逻辑会开始按照正常方式运行。
- 假设任何错误的可能，并做容错处理。在一个分布式系统中出现局部和临时错误是大概率事件。错误可能来自于物理系统故障，外部系统故障也可能来自于系统自身的代码错误，依靠自己实现的代码不会出错来保证系统稳定其实也是难以实现的，因此要设计对任何可能错误的容错处理。
- 尽量避免复杂状态机，控制逻辑不要依赖无法监控的内部状态。因为分布式系统各个子系统都是不能严格通过程序内部保持同步的，所以如果两个子系统的控制逻辑如果互相有影响，那么子系统就一定要能互相访问到影响控制逻辑的状态，否则，就等同于系统里存在不确定的控制逻辑。
- 假设任何操作都可能被任何操作对象拒绝，甚至被错误解析。由于分布式系统的复杂性以及各子系统的相对独立性，不同子系统经常来自不同的开发团队，所以不能奢望任何操作被另一个子系统以正确的方式处理，要保证出现错误的时候，操作级别的错误不会影响到系统稳定性。
- 每个模块都可以在出错后自动恢复。由于分布式系统中无法保证系统各个模块是始终连接的，因此每个模块要有自我修复的能力，保证不会因为连接不到其他模块而自我崩溃。
- 每个模块都可以在必要时优雅地降级服务。所谓优雅地降级服务，是对系统鲁棒性的要求，即要求在设计实现模块时划分清楚基本功能和高级功能，保证基本功能不会依赖高级功能，这样同时就保证了不会因为高级功能出现故障而导致整个模块崩溃。根据这种理念实现的系统，也更容易快速地增加新的高级功能，以为不必担心引入高级功能影响原有的基本功能。

## Kubernetes的核心技术概念和API对象

API对象是K8s集群中的管理操作单元。K8s集群系统每支持一项新功能，引入一项新技术，一定会新引入对应的API对象，支持对该功能的管理操作。例如副本集Replica Set对应的API对象是RS。

每个API对象都有3大类属性：元数据metadata、规范spec和状态status。元数据是用来标识API对象的，每个对象都至少有3个元数据：namespace，name和uid；除此以外还有各种各样的标签labels用来标识和匹配不同的对象，例如用户可以用标签env来标识区分不同的服务部署环境，分别用env=dev、env=testing、env=production来标识开发、测试、生产的不同服务。规范描述了用户期望K8s集群中的分布式系统达到的理想状态（Desired State），例如用户可以通过复制控制器Replication  Controller设置期望的Pod副本数为3；status描述了系统实际当前达到的状态（Status），例如系统当前实际的Pod副本数为2；那么复制控制器当前的程序逻辑就是自动启动新的Pod，争取达到副本数为3。

K8s中所有的配置都是通过API对象的spec去设置的，也就是用户通过配置系统的理想状态来改变系统，这是k8s重要设计理念之一，即所有的操作都是声明式（Declarative）的而不是命令式（Imperative）的。声明式操作在分布式系统中的好处是稳定，不怕丢操作或运行多次，例如设置副本数为3的操作运行多次也还是一个结果，而给副本数加1的操作就不是声明式的，运行多次结果就错了。

### [Pod](http://docs.kubernetes.org.cn/312.html)

K8s有很多技术概念，同时对应很多API对象，最重要的也是最基础的是微服务Pod。Pod是在K8s集群中运行部署应用或服务的最小单元，它是可以支持多容器的。Pod的设计理念是支持多个容器在一个Pod中共享网络地址和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务。Pod对多容器的支持是K8s最基础的设计理念。比如你运行一个操作系统发行版的软件仓库，一个Nginx容器用来发布软件，另一个容器专门用来从源仓库做同步，这两个容器的镜像不太可能是一个团队开发的，但是他们一块儿工作才能提供一个微服务；这种情况下，不同的团队各自开发构建自己的容器镜像，在部署的时候组合成一个微服务对外提供服务。

Pod是K8s集群中所有业务类型的基础，可以看作运行在K8s集群中的小机器人，不同类型的业务就需要不同类型的小机器人去执行。目前K8s中的业务主要可以分为长期伺服型（long-running）、批处理型（batch）、节点后台支撑型（node-daemon）和有状态应用型（stateful application）；分别对应的小机器人控制器为Deployment、Job、DaemonSet和PetSet，本文后面会一一介绍。

### 复制控制器（Replication Controller，RC）

RC是K8s集群中最早的保证Pod高可用的API对象。通过监控运行中的Pod来保证集群中运行指定数目的Pod副本。指定的数目可以是多个也可以是1个；少于指定数目，RC就会启动运行新的Pod副本；多于指定数目，RC就会杀死多余的Pod副本。即使在指定数目为1的情况下，通过RC运行Pod也比直接运行Pod更明智，因为RC也可以发挥它高可用的能力，保证永远有1个Pod在运行。RC是K8s较早期的技术概念，只适用于长期伺服型的业务类型，比如控制小机器人提供高可用的Web服务。

### [副本集（Replica Set，RS）](http://docs.kubernetes.org.cn/314.html)

RS是新一代RC，提供同样的高可用能力，区别主要在于RS后来居上，能支持更多种类的匹配模式。副本集对象一般不单独使用，而是作为Deployment的理想状态参数使用。

### [部署(Deployment)](http://docs.kubernetes.org.cn/317.html)

部署表示用户对K8s集群的一次更新操作。部署是一个比RS应用模式更广的API对象，可以是创建一个新的服务，更新一个新的服务，也可以是滚动升级一个服务。滚动升级一个服务，实际是创建一个新的RS，然后逐渐将新RS中副本数增加到理想状态，将旧RS中的副本数减小到0的复合操作；这样一个复合操作用一个RS是不太好描述的，所以用一个更通用的Deployment来描述。以K8s的发展方向，未来对所有长期伺服型的的业务的管理，都会通过Deployment来管理。

### 服务（Service）

RC、RS和Deployment只是保证了支撑服务的微服务Pod的数量，但是没有解决如何访问这些服务的问题。一个Pod只是一个运行服务的实例，随时可能在一个节点上停止，在另一个节点以一个新的IP启动一个新的Pod，因此不能以确定的IP和端口号提供服务。要稳定地提供服务需要服务发现和负载均衡能力。服务发现完成的工作，是针对客户端访问的服务，找到对应的的后端服务实例。在K8s集群中，客户端需要访问的服务就是Service对象。每个Service会对应一个集群内部有效的虚拟IP，集群内部通过虚拟IP访问一个服务。在K8s集群中微服务的负载均衡是由Kube-proxy实现的。Kube-proxy是K8s集群内部的负载均衡器。它是一个分布式代理服务器，在K8s的每个节点上都有一个；这一设计体现了它的伸缩性优势，需要访问服务的节点越多，提供负载均衡能力的Kube-proxy就越多，高可用节点也随之增多。与之相比，我们平时在服务器端做个反向代理做负载均衡，还要进一步解决反向代理的负载均衡和高可用问题。

### 任务（Job）

Job是K8s用来控制批处理型任务的API对象。批处理业务与长期伺服业务的主要区别是批处理业务的运行有头有尾，而长期伺服业务在用户不停止的情况下永远运行。Job管理的Pod根据用户的设置把任务成功完成就自动退出了。成功完成的标志根据不同的spec.completions策略而不同：单Pod型任务有一个Pod成功就标志完成；定数成功型任务保证有N个任务全部成功；工作队列型任务根据应用确认的全局成功而标志成功。

### 后台支撑服务集（DaemonSet）

长期伺服型和批处理型服务的核心在业务应用，可能有些节点运行多个同类业务的Pod，有些节点上又没有这类Pod运行；而后台支撑型服务的核心关注点在K8s集群中的节点（物理机或虚拟机），要保证每个节点上都有一个此类Pod运行。节点可能是所有集群节点也可能是通过nodeSelector选定的一些特定节点。典型的后台支撑型服务包括，存储，日志和监控等在每个节点上支持K8s集群运行的服务。

### 有状态服务集（PetSet）

K8s在1.3版本里发布了Alpha版的PetSet功能。在云原生应用的体系里，有下面两组近义词；第一组是无状态（stateless）、牲畜（cattle）、无名（nameless）、可丢弃（disposable）；第二组是有状态（stateful）、宠物（pet）、有名（having  name）、不可丢弃（non-disposable）。RC和RS主要是控制提供无状态服务的，其所控制的Pod的名字是随机设置的，一个Pod出故障了就被丢弃掉，在另一个地方重启一个新的Pod，名字变了、名字和启动在哪儿都不重要，重要的只是Pod总数；而PetSet是用来控制有状态服务，PetSet中的每个Pod的名字都是事先确定的，不能更改。PetSet中Pod的名字的作用，并不是《千与千寻》的人性原因，而是关联与该Pod对应的状态。

对于RC和RS中的Pod，一般不挂载存储或者挂载共享存储，保存的是所有Pod共享的状态，Pod像牲畜一样没有分别（这似乎也确实意味着失去了人性特征）；对于PetSet中的Pod，每个Pod挂载自己独立的存储，如果一个Pod出现故障，从其他节点启动一个同样名字的Pod，要挂载上原来Pod的存储继续以它的状态提供服务。

适合于PetSet的业务包括数据库服务MySQL和PostgreSQL，集群化管理服务Zookeeper、etcd等有状态服务。PetSet的另一种典型应用场景是作为一种比普通容器更稳定可靠的模拟虚拟机的机制。传统的虚拟机正是一种有状态的宠物，运维人员需要不断地维护它，容器刚开始流行时，我们用容器来模拟虚拟机使用，所有状态都保存在容器里，而这已被证明是非常不安全、不可靠的。使用PetSet，Pod仍然可以通过漂移到不同节点提供高可用，而存储也可以通过外挂的存储来提供高可靠性，PetSet做的只是将确定的Pod与确定的存储关联起来保证状态的连续性。PetSet还只在Alpha阶段，后面的设计如何演变，我们还要继续观察。

### 集群联邦（Federation）

K8s在1.3版本里发布了beta版的Federation功能。在云计算环境中，服务的作用距离范围从近到远一般可以有：同主机（Host，Node）、跨主机同可用区（Available Zone）、跨可用区同地区（Region）、跨地区同服务商（Cloud Service  Provider）、跨云平台。K8s的设计定位是单一集群在同一个地域内，因为同一个地区的网络性能才能满足K8s的调度和计算存储连接要求。而联合集群服务就是为提供跨Region跨服务商K8s集群服务而设计的。

每个K8s Federation有自己的分布式存储、API Server和Controller  Manager。用户可以通过Federation的API Server注册该Federation的成员K8s  Cluster。当用户通过Federation的API Server创建、更改API对象时，Federation API  Server会在自己所有注册的子K8s Cluster都创建一份对应的API对象。在提供业务请求服务时，K8s  Federation会先在自己的各个子Cluster之间做负载均衡，而对于发送到某个具体K8s Cluster的业务请求，会依照这个K8s  Cluster独立提供服务时一样的调度模式去做K8s  Cluster内部的负载均衡。而Cluster之间的负载均衡是通过域名服务的负载均衡来实现的。

所有的设计都尽量不影响K8s Cluster现有的工作机制，这样对于每个子K8s集群来说，并不需要更外层的有一个K8s Federation，也就是意味着所有现有的K8s代码和机制不需要因为Federation功能有任何变化。

### 存储卷（Volume）

K8s集群中的存储卷跟Docker的存储卷有些类似，只不过Docker的存储卷作用范围为一个容器，而K8s的存储卷的生命周期和作用范围是一个Pod。每个Pod中声明的存储卷由Pod中的所有容器共享。K8s支持非常多的存储卷类型，特别的，支持多种公有云平台的存储，包括AWS，Google和Azure云；支持多种分布式存储包括GlusterFS和Ceph；也支持较容易使用的主机本地目录hostPath和NFS。K8s还支持使用Persistent Volume  Claim即PVC这种逻辑存储，使用这种存储，使得存储的使用者可以忽略后台的实际存储技术（例如AWS，Google或GlusterFS和Ceph），而将有关存储实际技术的配置交给存储管理员通过Persistent Volume来配置。

### 持久存储卷（Persistent Volume，PV）和持久存储卷声明（Persistent Volume Claim，PVC）

PV和PVC使得K8s集群具备了存储的逻辑抽象能力，使得在配置Pod的逻辑里可以忽略对实际后台存储技术的配置，而把这项配置的工作交给PV的配置者，即集群的管理者。存储的PV和PVC的这种关系，跟计算的Node和Pod的关系是非常类似的；PV和Node是资源的提供者，根据集群的基础设施变化而变化，由K8s集群管理员配置；而PVC和Pod是资源的使用者，根据业务服务的需求变化而变化，有K8s集群的使用者即服务的管理员来配置。

### 节点（Node）

K8s集群中的计算能力由Node提供，最初Node称为服务节点Minion，后来改名为Node。K8s集群中的Node也就等同于Mesos集群中的Slave节点，是所有Pod运行所在的工作主机，可以是物理机也可以是虚拟机。不论是物理机还是虚拟机，工作主机的统一特征是上面要运行kubelet管理节点上运行的容器。

### 密钥对象（Secret）

Secret是用来保存和传递密码、密钥、认证凭证这些敏感信息的对象。使用Secret的好处是可以避免把敏感信息明文写在配置文件里。在K8s集群中配置和使用服务不可避免的要用到各种敏感信息实现登录、认证等功能，例如访问AWS存储的用户名密码。为了避免将类似的敏感信息明文写在所有需要使用的配置文件中，可以将这些信息存入一个Secret对象，而在配置文件中通过Secret对象引用这些敏感信息。这种方式的好处包括：意图明确，避免重复，减少暴漏机会。

### 用户帐户（User Account）和服务帐户（[Service Account](http://docs.kubernetes.org.cn/84.html)）

顾名思义，用户帐户为人提供账户标识，而服务账户为计算机进程和K8s集群中运行的Pod提供账户标识。用户帐户和服务帐户的一个区别是作用范围；用户帐户对应的是人的身份，人的身份与服务的namespace无关，所以用户账户是跨namespace的；而服务帐户对应的是一个运行中程序的身份，与特定namespace是相关的。

### [名字空间（Namespace）](http://docs.kubernetes.org.cn/242.html)

名字空间为K8s集群提供虚拟的隔离作用，K8s集群初始有两个名字空间，分别是默认名字空间default和系统名字空间kube-system，除此以外，管理员可以可以创建新的名字空间满足需要。

### [RBAC访问授权](http://docs.kubernetes.org.cn/148.html)

K8s在1.3版本中发布了alpha版的基于角色的访问控制（Role-based Access  Control，RBAC）的授权模式。相对于基于属性的访问控制（Attribute-based Access  Control，ABAC），RBAC主要是引入了角色（Role）和角色绑定（RoleBinding）的抽象概念。在[ABAC](http://docs.kubernetes.org.cn/87.html)中，K8s集群中的访问策略只能跟用户直接关联；而在RBAC中，访问策略可以跟某个角色关联，具体的用户在跟一个或多个角色相关联。显然，RBAC像其他新功能一样，每次引入新功能，都会引入新的API对象，从而引入新的概念抽象，而这一新的概念抽象一定会使集群服务管理和使用更容易扩展和重用。

## 总结

从K8s的系统架构、技术概念和设计理念，我们可以看到K8s系统最核心的两个设计理念：一个是容错性，一个是易扩展性。容错性实际是保证K8s系统稳定性和安全性的基础，易扩展性是保证K8s对变更友好，可以快速迭代增加新功能的基础。

## 参考

- 说明：本文内容来至[feisky](https://feisky.gitbooks.io/kubernetes/architecture/concepts.html)的gitbook；
- [Kubernetes与云原生应用](http://www.infoq.com/cn/articles/kubernetes-and-cloud-native-applications-part01)

# kubeadm 实现细节

- [1 核心设计原则](http://docs.kubernetes.org.cn/829.html#i)
- [2 常量和众所周知的值和路径](http://docs.kubernetes.org.cn/829.html#i-2)
- 3 kubeadm init 工作流程内部设计
  - [3.1 预检检查](http://docs.kubernetes.org.cn/829.html#i-3)
  - [3.2 生成必要的证书](http://docs.kubernetes.org.cn/829.html#i-4)
  - [3.3 为控制平面组件生成 kubeconfig 文件](http://docs.kubernetes.org.cn/829.html#_kubeconfig)
  - 3.4 为控制平面组件生成静态 Pod 清单
    - [3.4.1 API server](http://docs.kubernetes.org.cn/829.html#API_server)
    - [3.4.2 Controller manager](http://docs.kubernetes.org.cn/829.html#Controller_manager)
    - [3.4.3 Scheduler](http://docs.kubernetes.org.cn/829.html#Scheduler)
  - [3.5 为本地 etcd 生成静态 Pod 清单](http://docs.kubernetes.org.cn/829.html#_etcd_Pod)
  - [3.6 （可选，1.9 版本中为 alpha）编写 init kubelet 配置](http://docs.kubernetes.org.cn/829.html#19_alpha_init_kubelet)
  - [3.7 等待控制平面启动](http://docs.kubernetes.org.cn/829.html#i-5)
  - [3.8 （可选，1.9 版本中为 alpha）编写基本 kubelet 配置](http://docs.kubernetes.org.cn/829.html#19_alpha_kubelet)
  - [3.9 将 kubeadm MasterConfiguration 保存在 ConfigMap 中供以后参考](http://docs.kubernetes.org.cn/829.html#_kubeadm_MasterConfiguration_ConfigMap)
  - [3.10 标记 master](http://docs.kubernetes.org.cn/829.html#_master)
  - 3.11 配置 TLS-引导 以加入节点
    - [3.11.1 创建一个引导令牌](http://docs.kubernetes.org.cn/829.html#i-6)
    - [3.11.2 允许加入节点来调用 CSR API](http://docs.kubernetes.org.cn/829.html#_CSR_API)
    - [3.11.3 为新的引导令牌设置自动批准](http://docs.kubernetes.org.cn/829.html#i-7)
    - [3.11.4 通过自动批准设置节点证书轮换](http://docs.kubernetes.org.cn/829.html#i-8)
    - [3.11.5 创建公共集群信息 ConfigMap](http://docs.kubernetes.org.cn/829.html#_ConfigMap)
  - 3.12 安装插件
    - [3.12.1 代理](http://docs.kubernetes.org.cn/829.html#i-10)
    - [3.12.2 DNS](http://docs.kubernetes.org.cn/829.html#DNS)
  - [3.13 （可选，v1.9 中是 alpha）自托管](http://docs.kubernetes.org.cn/829.html#v19_alpha)
- 4 kubeadm join 阶段的内部设计
  - [4.1 预检检查](http://docs.kubernetes.org.cn/829.html#i-11)
  - 4.2 发现集群信息
    - [4.2.1 共享令牌发现](http://docs.kubernetes.org.cn/829.html#i-13)
    - [4.2.2 文件/https 发现](http://docs.kubernetes.org.cn/829.html#https)
- 5 TLS 引导
  - [5.1 （可选，1.9 版本中为 alpha）编写init kubelet配置](http://docs.kubernetes.org.cn/829.html#19_alphainit_kubelet)

kubeadm init 和 kubeadm join 为从头开始创建一个 Kubernetes 集群的最佳实践共同提供了一个很好的用户体验。但是，kubeadm 如何 做到这一点可能并不明显。

本文档提供了有关发生了什么事情的更多详细信息，旨在分享关于 Kubernetes 集群最佳实践的知识。

## 核心设计原则

使用 kubeadm init 和 kubeadm join 设置的集群应该：

- 安全：
  - 它应该采用最新的最佳做法，如：
    - 强制实施 RBAC
    - 使用节点授权器
    - 控制平面组件之间使用安全通信
    - API server 和 kubelet 之间使用安全通信
    - 锁定 kubelet API
    - 锁定对系统组件（如 kube-proxy 和 kube-dns）的 API 访问权限
    - 锁定引导令牌可以访问的内容
    - 等等
- 使用方便：
  - 用户只需运行几个命令即可：
    - kubeadm init
    - export KUBECONFIG=/etc/kubernetes/admin.conf
    - kubectl apply -f <network-of-choice.yaml>
    - kubeadm join --token <token> <master-ip>:<master-port>
- 可扩展：
  - 例如，它 不 应该支持任何网络提供商，相反，配置网络应该是超出了它的范围
  - 应该提供使用配置文件自定义各种参数的可能性

## 常量和众所周知的值和路径

为了降低复杂性并简化 kubeadm 实施的部署解决方案的开发，kubeadm 使用一组有限的常量值，用于众所周知的路径和文件名。

Kubernetes 目录 /etc/kubernetes 在应用中是一个常量，因为它明显是大多数情况下的给定路径，也是最直观的位置; 其他常量路径和文件名是：

- /etc/kubernetes/manifests 作为 kubelet 寻找静态 Pod 的路径。静态 Pod 清单的名称是：
  - etcd.yaml
  - kube-apiserver.yaml
  - kube-controller-manager.yaml
  - kube-scheduler.yaml
- /etc/kubernetes/ 作为存储具有控制平面组件标识的 kubeconfig 文件的路径。kubeconfig 文件的名称是：
  - kubelet.conf （bootstrap-kubelet.conf - 在 TLS 引导期间）
  - controller-manager.conf
  - scheduler.conf
  - admin.conf 用于集群管理员和 kubeadm 本身
- 证书和密钥文件的名称：
  - ca.crt，ca.key 为 Kubernetes 证书颁发机构
  - apiserver.crt，apiserver.key 用于 API server 证书
  - apiserver-kubelet-client.crt，apiserver-kubelet-client.key 用于由 API server 安全地连接到 kubelet 的客户端证书
  - sa.pub，sa.key 用于签署 ServiceAccount 时控制器管理器使用的密钥
  - front-proxy-ca.crt，front-proxy-ca.key 用于前台代理证书颁发机构
  - front-proxy-client.crt，front-proxy-client.key 用于前端代理客户端

## kubeadm init 工作流程内部设计

kubeadm init 内部工作流程 由一系列要执行的原子工作任务组成，如 kubeadm init 所述。

kubeadm alpha phase 命令允许用户单独调用每个任务，并最终提供可重用和可组合的 API/工具箱，可供其他 Kubernetes 引导工具、任何 IT 自动化工具或高级用户创建自定义集群使用。

### 预检检查

Kubeadm 在启动 init 之前执行一组预检检查，目的是验证先决条件并避免常见的集群启动问题。在任何情况下，用户都可以使用 --ignore-preflight-errors 选项跳过特定的预检检查（或最终所有预检检查）。

- [警告]如果要使用的 Kubernetes 版本（与 --kubernetes-version 标记一起指定）至少比 kubeadm CLI 版本高一个次要版本
- Kubernetes 系统要求：
  - 如果在 Linux 上运行：
    - [错误] 如果不是 Kernel 3.10+ 或具有特定 KernelSpec 的 4+
    - [错误] 如果需要的 cgroups 子系统没有设置
  - 如果使用 docker：
    - [警告/错误] 如果 Docker 服务不存在，如果它被禁用，如果它不是 active 状态
    - [错误] 如果 Docker 端点不存在或不起作用
    - [警告] 如果 docker 版本 > 17.03
  - 如果使用其他 cri 引擎：
    - [错误] 如果 crictl 没有响应
- [错误] 如果用户不是root用户
- [错误] 如果机器主机名不是有效的 DNS 子域
- [警告] 如果通过网络查找无法到达主机名
- [错误] 如果 kubelet 版本低于 kubeadm 支持的最小 kubelet 版本（当前小版本 -1）
- [错误] 如果 kubelet 版本至少比所需的控制平面版本更高一些（不受支持的版本）
- [警告] 如果 kubelet 服务不存在或禁用
- [警告] 如果 firewalld 处于活动状态
- [错误] 如果 API server 的 bindPort 或者 port 10250/10251/10252 已经被使用
- [错误] 如果/etc/kubernetes/manifest 文件夹已经存在，并且非空
- [错误] 如果 /proc/sys/net/bridge/bridge-nf-call-iptables 文件不存在或者不包含 1
- [错误] 如果发布地址是 ipv6 并且 /proc/sys/net/bridge/bridge-nf-call-ip6tables 不存在或者不包含 1
- [错误] 如果 swap 打开
- [错误] 如果 ip、iptables、mount 或者 nsenter 命令没有出现在命令路径中
- [警告] 如果 ebtables、ethtool、socat、tc、touch 和 crictl 命令没有出现在命令路径中
- [警告] 如果 API server、Controller-manager、Scheduler 的额外参数中包含一些无效的选项
- [警告] 如果连接到 https://API.AdvertiseAddress:API.BindPort 需要通过代理
- [警告] 如果连接到服务子网需要通过代理（只检查第一个地址）
- [警告] 如果连接到 pod 子网需要通过代理（只检查第一个地址）
- 如果提供外部 etcd：
  - [错误] 如果 etcd 版本低于 3.0.14
  - [错误] 如果指定了 etcd 证书或密钥，但未提供
- 如果不提供外部 etcd（因此将安装本地 etcd）：
  - [错误] 如果使用端口 2379
  - [错误] 如果 Etcd.DataDir 文件夹已经存在并且不是空的
- 如果授权模式是 ABAC：
  - [错误] 如果 abac_policy.json 不存在
- 如果授权模式是 WebHook：
  - [错误] 如果 webhook_authz.conf 不存在

请注意：

1. 预检检查可以通过 kubeadm alpha phase preflight 命令单独调用

### 生成必要的证书

Kubeadm 为不同目的生成证书和私钥对:

- Kubernetes 集群的自签名证书颁发机构保存到 ca.crt 文件和 ca.key 私钥文件中
- API server 的服务证书，使用 ca.crt 作为 CA 生成，并保存到 apiserver.crt 文件中，并带有其私钥 apiserver.key。此证书应包含以下其他名称：
  - Kubernetes 服务的内部 clusterIP（服务 CIDR 中的第一个地址，例如，如果服务子网是 10.96.0.0/12 则为 10.96.0.1）
  - Kubernetes DNS  名称，例如，如果 --service-dns-domain 标志的值为 cluster.local，则为 kubernetes.default.svc.cluster.local，再加上默认的 DNS 名称 kubernetes.default.svc、kubernetes.default 和 kubernetes
  - 节点名称
  - --apiserver-advertise-address
  - 由用户指定的其他替代名称
- 用于 API server 的安全连接到 kubelet 的客户端证书，使用 ca.crt 作为 CA  生成并使用私钥 apiserver-kubelet-client.key 保存到文件 apiserver-kubelet-client.crt中。这个证书应该在 system:masters 组织中
- 一个用于签名 ServiceAccount 令牌的私钥，该令牌与它的公钥 sa.pub 一起保存到 sa.key 文件中。
- 前端代理的证书颁发机构保存到 front-proxy-ca.crt 文件中，其密钥为 front-proxy-ca.key
- 前端代理客户端的客户证书，使用 front-proxy-ca.crt 作为 CA 生成，并使用其私钥 front-proxy-client.key 保存到 front-proxy-client.crt 文件中

证书默认存储在 /etc/kubernetes/pki 中，但该目录可使用 --cert-dir 标志进行配置。

请注意：

1. 如果给定的证书和私钥对都存在，并且其内容评估符合上述规范，则将使用现有文件并跳过给定证书的生成阶段。这意味着用户可以将现有 CA  复制到 /etc/kubernetes/pki/ca.{crt,key}，然后 kubeadm 将使用这些文件来签署剩余的证书。请参与 [使用自定义证书](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#custom-certificates)
2. 只有 CA 可以提供 ca.crt 文件，但不提供 ca.key 文件，如果所有其他证书和 kubeconfig  文件已就位，kubeadm 会识别此情况并激活 ExternalCA，这也意味着 controller-manager  中的 csrsigner 控制器将不会启动
3. 如果 kubeadm 在 ExternalCA 模式下运行; 所有的证书都必须由用户提供，因为 kubeadm 本身不能生成它们
4. 在 --dry-run 模式中执行 kubeadm 的情况下，证书文件被写入临时文件夹中
5. 使用 kubeadm alpha phase certs all 命令可以单独调用证书生成动作

### 为控制平面组件生成 kubeconfig 文件

具有控制平面组件标识的 Kubeadm kubeconfig 文件：

- kubelet 使用的 kubeconfig 文件：/etc/kubernetes/kubelet.conf; 在这个文件内嵌入一个具有 kubelet 身份的客户端证书。这个客户证书应该：
  - 在 system:nodes 组织中，符合 [节点授权](http://docs.kubernetes.org.cn/156.html) 模块的要求
  - 有 CN system:node:<hostname-lowercased>
- controller-manager 使用的 kubeconfig  文件：/etc/kubernetes/controller-manager.conf; 在这个文件内嵌入一个带有  controller-manager 身份的客户端证书。此客户端证书应具有  CN system:kube-controller-manager，默认由 [RBAC 核心组件角色](http://docs.kubernetes.org.cn/148.html) 定义
- scheduler 使用的 kubeconfig 文件：/etc/kubernetes/scheduler.conf;  在这个文件内嵌入一个带有 scheduler 标识的客户端证书。此客户端证书应具有 CN system:kube-scheduler，默认由 [RBAC 核心组件角色](http://docs.kubernetes.org.cn/148.html) 定义

此外，生成一个 kubeadm 去使用它自己以及管理员使用的 kubeconfig  文件，并保存到 /etc/kubernetes/admin.conf 文件中。这里的 “管理员”  定义了正在管理集群并希望完全控制（root）集群的实际人员。管理员的嵌入式客户端证书应该：

- 在 system:masters 组织中，默认由 [RBAC 用户所面对的角色绑定](http://docs.kubernetes.org.cn/148.html) 定义
- 包括一个 CN，但可以是任何东西。Kubeadm 使用 kubernetes-admin CN

请注意：

1. ca.crt 证书嵌入在所有 kubeconfig 文件中。
2. 如果给定的 kubeconfig 文件存在，并且其内容的评估符合上述规范，则将使用现有文件，并跳过给定 kubeconfig 的生成阶段
3. 如果 kubeadm 以 ExternalCA 模式运行，则所有必需的 kubeconfig 也必须由用户提供，因为 kubeadm 本身不能生成它们中的任何一个
4. 如果在 --dry-run 模式下执行 kubeadm ，kubeconfig 文件将写入临时文件夹中
5. 使用 [kubeadm alpha phase kubeconfig all](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/#cmd-phase-kubeconfig) 命令可以单独调用 Kubeconfig 文件生成动作

### 为控制平面组件生成静态 Pod 清单

kubeadm 将控制平面组件的静态 Pod 清单文件写入 /etc/kubernetes/manifests; Kubelet 会监控这个目录，在启动时创建 pod。

静态 Pod 清单共享一组通用属性：

- 所有静态 Pod 都部署在 kube-system 命名空间上
- 所有静态 Pod 都可以获取 tier:control-plane 和 component:{component-name} 标记
- 所有的静态 Pod 都会获得 scheduler.alpha.kubernetes.io/critical-pod 注解（这将转移到适当的解决方案，即在准备就绪时使用 pod 优先级和抢占）
- 在所有静态 Pod 上设置 hostNetwork: true，以便在网络配置之前允许控制平面启动; 因此：
  - controller-manager 和 scheduler 使用来指代该 API server 的地址为 127.0.0.1
  - 如果使用本地 etcd 服务器，etcd-servers 地址将被设置为 127.0.0.1:2379
- controller-manager 和 scheduler 均启用选举
- controller-manager 和 scheduler 将引用 kubeconfig 文件及其各自的唯一标识
- 所有静态 Pod 都会获得用户指定的额外标志，如 将自定义参数传递给控制平面组件 所述
- 所有静态 Pod 都会获取用户指定的任何额外卷（主机路径）

请注意：

1. --kubernetes-version 当前体系结构中的所有镜像 将从中 gcr.io/google_containers 中拉取;  如果指定了其他镜像仓库库或 CI 镜像仓库，则将使用此仓库;  如果一个特定的容器镜像应该被用于所有控制平面组件，那么这个特定镜像将被使用。请参阅 [使用自定义镜像](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#custom-images) 了解更多详情
2. 如果在 --dry-run 模式下执行 kubeadm，则将静态 Pod 文件写入临时文件夹
3. 可以使用 kubeadm alpha phase controlplane all 命令单独调用生成主组件的静态 Pod 清单

#### API server

API server 的静态 Pod 清单受用户提供的以下参数的影响：

- 需要指定要绑定到的 apiserver-advertise-address 和 apiserver-bind-port；如果没有提供，这些值分别默认为机器上默认网络接口的 IP 地址和端口 6443
- service-cluster-ip-range 用于服务
- 如果指定了外部 etcd 服务器，则要设定 etcd-servers 地址和相关的 TLS 设置（etcd-cafile、etcd-certfile、etcd-keyfile）; 如果不提供外部 etcd 服务器，则会使用本地 etcd（通过主机网络）
- 如果指定了云提供商，则要配置相应的 --cloud-provider，如果这样的文件存在，还要配置 --cloud-config 路径（这是实验性的、alpha 功能，将在未来的版本中删除）
- 如果 kubeadm  被调用为 --feature-gates=HighAvailability，则标志 --endpoint-reconciler-type=lease 被设置，从而启用内部 API server VIP 的 endpoints 的自动协调
- 如果 kubeadm 被调用为 --feature-gates=DynamicKubeletConfig，则 API 服务器上的相应功能将通过 --feature-gates=DynamicKubeletConfig=true 标志激活

其他无条件设置的 API server 标志是：

- --insecure-port=0 避免与 api server 的不安全连接

- --enable-bootstrap-token-auth=true 启用 BootstrapTokenAuthenticator 验证模块。有关更多详细信息，请参阅 [TLS 引导](https://k8smeetup.github.io/docs/admin/kubelet-tls-bootstrapping.md)

- --allow-privileged 为 true （如 kube proxy 所要求的）

- --requestheader-client-ca-file 为 front-proxy-ca.crt

- --admission-control 为：

  - Initializers 启用 [动态准入控制](http://docs.kubernetes.org.cn/144.html)
  - NamespaceLifecycle 例如避免删除系统保留的命名空间
  - LimitRanger 和 ResourceQuota 强制限制命名空间
  - [ServiceAccount](http://docs.kubernetes.org.cn/709.html) 强制执行服务帐户自动化
  - [PersistentVolumeLabel](https://k8smeetup.github.io/docs/admin/admission-controllers/#persistentvolumelabel) 将区域或区域标签附加到由云提供商定义的 PersistentVolumes （此准入控制器已被弃用，并将在未来的版本中被删除。没有明确选择使用 gce 或 aws 作为云提供商时，它在默认情况下跟 1.9 版本一样，并不是由 kubeadm 部署）
  - DefaultStorageClass 在 PersistentVolumeClaim 对象上强制执行默认存储类
  - DefaultTolerationSeconds
  - NodeRestriction 限制 kubelet 可以修改的内容（例如，只有该节点上的 pod）

- --kubelet-preferred-address-types 为 InternalIP,ExternalIP,Hostname;，这使得 kubectl logs 和其他 api server-kubelet 通信能够在节点主机名不可解析的环境中工作。

- 使用先前步骤中生成的证书的标志：

  - --client-ca-file 为 ca.crt
  - --tls-cert-file 为 apiserver.crt
  - --tls-private-key-file 为 apiserver.key
  - --kubelet-client-certificate 为 apiserver-kubelet-client.crt
  - --kubelet-client-key 为 apiserver-kubelet-client.key
  - --service-account-key-file 为 sa.pub
  - --requestheader-client-ca-file为front-proxy-ca.crt
  - --proxy-client-cert-file 为 front-proxy-client.crt
  - --proxy-client-key-file 为 front-proxy-client.key

- 用于保护前端代理（

  API Aggregation

  ）通信的其他标志：

  - --requestheader-username-headers=X-Remote-User
  - --requestheader-group-headers=X-Remote-Group
  - --requestheader-extra-headers-prefix=X-Remote-Extra-
  - --requestheader-allowed-names=front-proxy-client

#### Controller manager

API server 的静态 Pod 清单受用户提供的以下参数的影响：

- 如果调用 kubeadm 时指定一个 --pod-network-cidr，某些 CNI 网络插件所需的子网管理器功能可以通过设置来启用：
  - --allocate-node-cidrs=true
  - --cluster-cidr 和 --node-cidr-mask-size 根据给定的 CIDR 标志
- 如果指定了云提供商，则要配置相应的 --cloud-provider，如果这样的文件存在，还要配置 --cloud-config 路径（这是实验性的、alpha 功能，将在未来的版本中删除）

其他无条件设置的标志是：

- --controllers 为 TLS 引导启用所有默认控制器加上 BootstrapSigner 和 TokenCleaner 控制器。有关更多详细信息，请参阅 [TLS 引导](https://k8smeetup.github.io/docs/admin/kubelet-tls-bootstrapping.md)
- --use-service-account-credentials为 true
- 使用先前步骤中生成的证书的标志：
  - --root-ca-file 为 ca.crt
  - --cluster-signing-cert-file 为 ca.crt，如果外部 CA 模式被禁用，则返回 ""
  - --cluster-signing-key-file 为 ca.key，如果外部 CA 模式被禁用，则返回 ""
  - --service-account-private-key-file 为 sa.key

#### Scheduler

Scheduler 的静态 Pod 清单不受用户提供的参数的影响。

### 为本地 etcd 生成静态 Pod 清单

如果用户指定了外部 etcd，则此步骤将被跳过，否则 kubeadm 将生成一个静态的 Pod 清单文件，用于创建在 Pod 中运行的本地 etcd 实例，其中包含以下属性：

- 监听 localhost:2379 并使用 HostNetwork=true
- 做一个 hostPath，从 dataDir 挂载到 主机文件系统
- 任何由用户指定的额外标志

请注意：

1. etcd 镜像将从中 gcr.io/google_containers 中拉取; 如果指定了其他镜像仓库库，则将使用此仓库; 如果一个特定的容器镜像应该被用于所有控制平面组件，那么这个特定镜像将被使用。请参阅 [使用自定义镜像](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#custom-images) 了解更多详情
2. 如果在 --dry-run 模式下执行 kubeadm，则将静态 Pod 文件写入临时文件夹
3. 可以使用 [kubeadm alpha phase etcd local](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/#cmd-phase-etcd) 命令为本地 etcd 生成的静态 Pod 清单

### （可选，1.9 版本中为 alpha）编写 init kubelet 配置

如果 kubeadm 被调用为 --feature-gates=DynamicKubeletConfig，它会将 kubelet init 配置写入 /var/lib/kubelet/config/init/kubelet 文件。

init 配置用于在此特定节点上启动 kubelet，为 kubelet 插入文件提供替代方案; 这种配置将被以下步骤中所述的 Kubelet 基本配置替代。请参阅 [通过配置文件设置 Kubelet 参数](https://k8smeetup.github.io/docs/tasks/administer-cluster/kubelet-config-file.md) 以获取更多信息。

请注意：

1. 要使动态 kubelet  配置正常工作，应该在 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf 中指定标志 --dynamic-config-dir=/var/lib/kubelet/config/dynamic
2. 通过设置.kubeletConfiguration.baseConfig，Kubelet init 配置可以通过使用 kubeadm MasterConfiguration 文件进行修改。请参阅 [在配置文件中使用 kubelet init](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#config-file) 以获取更多信息。

### 等待控制平面启动

这是 kubeadm 集群的关键时刻。kubeadm  等待 localhost:6443/healthz 返回 ok，但是为了检测死锁情况，如果localhost:10255/healthz（kubelet liveness）或 localhost:10255/healthz/syncloop（kubelet readiness）分别在 40 秒和 60 秒后不返回 ok，kubeadm 就会快速失败。

kubeadm 依靠 kubelet 来拉取控制平面镜像，并以静态 Pod 的形式正确运行它们。控制平面启动后，kubeadm 完成以下段落中描述的任务。

### （可选，1.9 版本中为 alpha）编写基本 kubelet 配置

如果 kubeadm 被调用为 --feature-gates=DynamicKubeletConfig：

1. 将 kubelet 基本配置写入命名空间 kube-system 的 kubelet-base-config-v1.9 ConfigMap 中
2. 创建 RBAC 规则来授予该 ConfigMap 对所有引导令牌和所有 kubelet 实例（即组 system:bootstrappers:kubeadm:default-node-token 和 system:nodes）的读访问权限
3. 通过将 Node.spec.configSource 指向新创建的 ConfigMap 来为初始主节点启用动态 kubelet 配置功能

### 将 kubeadm MasterConfiguration 保存在 ConfigMap 中供以后参考

kubeadm 将 kubeadm init 通过标志或配置文件传递给 ConfigMap 的配置保存在 kube-system 命名空间下的 kubeadm-config ConfigMap 中。

这将确保将来（例如 kubeadm upgrade）执行的 kubeadm 行动将能够确定 实际/当前 的集群状态并基于该数据做出新的决定。

请注意：

1. 在上传之前，敏感信息（例如令牌）会从配置中删除
2. 主配置的上传可以通过 kubeadm alpha phase upload-config 命令单独调用
3. 如果您使用 kubeadm v1.7.x 或更低版本初始化集群，则必须在使用 kubeadm upgrade 到 v1.8 之前手动创建 master 的配置 ConfigMap 。为了促进这项任务，kubeadm config upload  (from-flags|from-file) 已经实施

### 标记 master

一旦控制平面可用，kubeadm 将执行以下操作：

- 用 node-role.kubernetes.io/master="" 给 master 增加标签
- 用 node-role.kubernetes.io/master:NoSchedule 给 master 增加污点

请注意：

1. 标记 master 阶段可以通过 kubeadm alpha phase mark-master 命令单独调用

### 配置 TLS-引导 以加入节点

Kubeadm 使用 [引导令牌进行身份验证](http://docs.kubernetes.org.cn/713.html) 将新节点连接到现有集群; 欲了解更多详情，请参阅 [设计方案](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/bootstrap-discovery.md)。

kubeadm init 确保为此过程正确配置所有内容，这包括以下步骤以及设置 API server 和控制器标志，如前面几个段落中所述。

请注意：

1. 可以使用 [kubeadm alpha phase bootstrap-token all](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/#cmd-phase-bootstrap-token) 命令配置节点的 TLS 引导，执行以下段落中描述的所有配置步骤; 或者，每个步骤都可以单独调用

#### 创建一个引导令牌

kubeadm init 创建第一个引导令牌，可以自动生成或由用户使用 --token 标志提供; 在引导令牌规范中，令牌应该保存为命名空间 kube-system 下的 bootstrap-token-<token-id> secret 中。

请注意：

1. 通过 kubeadm init 创建的默认令牌将用于 TLS 在引导过程中验证临时用户；这些用户将成为 system:bootstrappers:kubeadm:default-node-token 组的成员
2. 令牌的有效期有限，默认 24 小时（间隔可以使用 —token-ttl 标志变更）
3. 额外的令牌可以使用 [kubeadm token](http://docs.kubernetes.org.cn/713.html) 命令创建，它还可以为令牌管理提供其他有用的功能

#### 允许加入节点来调用 CSR API

Kubeadm 确保 system:bootstrappers:kubeadm:default-node-token 组中的用户能够访问证书签名 API。

这是通过在上面的组和默认的 RBAC 角色 system:node-bootstrapper 之间创建一个名为 kubeadm:kubelet-bootstrap 的 ClusterRoleBinding 来实现的。

#### 为新的引导令牌设置自动批准

Kubeadm 确保引导令牌将获得 csrapprover 控制器自动批准的 CSR 请求。

这是通过 system:bootstrappers:kubeadm:default-node-token 组和默认的角色 system:certificates.k8s.io:certificatesigningrequests:nodeclient 之间创建一个名为 kubeadm:node-autoapprove-bootstrap 的 ClusterRoleBinding 来实现的。

角色 system:certificates.k8s.io:certificatesigningrequests:nodeclient 也应该创建，并授予访问 /apis/certificates.k8s.io/certificatesigningrequests/nodeclient 的 POST 权限。

#### 通过自动批准设置节点证书轮换

Kubeadm 确保为节点启用证书轮换，并且节点的新证书请求将获得由 csrapprover 控制器自动批准的 CSR 请求。

这是通过 system:nodes 组和默认的角色 system:certificates.k8s.io:certificatesigningrequests:selfnodeclient 之间创建一个名为 kubeadm:node-autoapprove-certificate-rotation 的 ClusterRoleBinding 来实现的。

#### 创建公共集群信息 ConfigMap

此阶段在 kube-public 命名空间中创建 cluster-info ConfigMap。

此外，还创建了一个角色和一个 RoleBinding，为未经身份验证的用户授予对 ConfigMap 的访问权（即 RBAC 组中的用户 system:unauthenticated）

请注意：

1. 访问 cluster-info ConfigMap 是不 受限制的。如果您将您的主机暴露在互联网上，这可能是问题，也可能不是问题；最坏的情况是 DoS 攻击，攻击者使用 Kube-apiserver 可以处理的所有请求来为 cluster-info ConfigMap 提供服务。

### 安装插件

Kubeadm 通过 API server 安装内部 DNS 服务和 kube-proxy 插件组件。

请注意：

1. 这个阶段可以通过 [kubeadm alpha phase addon all](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/#cmd-phase-addon) 命令单独调用

#### 代理

在命名空间 kube-system 下为 kube-proxy 创建一个 ServiceAccount；然后使用 DaemonSet 部署 kube-proxy：

- master 的凭证（ca.crt 和 token）来自 ServiceAccount
- master 的位置来自 ConfigMap
- kube-proxy ServiceAccount 绑定到 system:node-proxier ClusterRole 中的权限

#### DNS

在命名空间 kube-system 下为 kube-dns 创建一个 ServiceAccount。

部署 kube-dns 的 Deployment 和 Service：

- 这是相对上游来说没有修改的 kube-dns 部署
- kube-dns ServiceAccount 绑定到 system:kube-dns ClusterRole 中的权限

请注意：

1. 如果 kubeadm 被调用为 --feature-gates=CoreDNS，则会安装 CoreDNS 而不是 kube-dns

### （可选，v1.9 中是 alpha）自托管

只有在 kubeadm init 被调用为 —features-gates=selfHosting 才执行此阶段

自托管阶段基本上用 DaemonSet 取代控制平面组件的静态 Pod; 这是通过执行 API server、scheduler 和 controller manager 静态 Pod 的以下过程来实现的：

- 从磁盘加载静态 Pod 规格
- 从静态的 Pod 清单文件中提取 PodSpec
- 改变 PodSpec 与自托管兼容，更详细的内容：
  - 为带有 node-role.kubernetes.io/master="" 标签的节点增加节点选择器属性
  - 为污点 node-role.kubernetes.io/master:NoSchedule 增加一个容忍
  - 设置 spec.DNSPolicy 为 ClusterFirstWithHostNet
- 为有问题的自托管组件构建一个新的 DaemonSet 对象。使用上面提到的 PodSpec
- 在 kube-system 命名空间中创建 DaemonSet 资源。等到 Pod 运行。
- 删除静态的 Pod 清单文件。kubelet 将停止正在运行的原始静态 Pod 托管组件

请注意：

1. 自托管尚未恢复到节点重新启动的能力; 这可以通过外部检查点或控制平面 Pod 的 kubelet 检查点来修正。有关更多详细信息，请参阅 [自托管](https://k8smeetup.github.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#self-hosting)。
2. 如果被调用为 —features-gates=StoreCertsInSecrets，以下附加步骤将被执行
   - 在 kube-system 命名空间下使用各自的证书和秘钥创建 ca、apiserver、apiserver-kubelet-client、sa、front-proxy-ca、front-proxy-client TLS secrets 。重要！将 CA 密钥存储在 Secret 中可能会产生安全隐患
   - 使用各自的 kubeconfig 文件在命名空间 kube-system 中创建 schedler.conf 和 controller-manager.conf secret
   - 通过将主机路径卷替换为上述 secret 中的投影卷，对所有 POD 规范进行变更
3. 这个阶段可以通过 kubeadm alpha phase selfhosting convert-from-staticpods 命令单独调用

## kubeadm join 阶段的内部设计

与 kubeadm init 类似，kubeadm join 内部工作流也是由一系列要执行的原子工作任务组成。

这分为发现（有 Node 信任 Kubernetes Master）和 TLS 引导（有 Kubernetes Master 信任 Node）。

请参阅 [使用引导令牌进行身份验证](http://docs.kubernetes.org.cn/713.html) 或相应的 [设计方案](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/bootstrap-discovery.md)。

### 预检检查

kubeadm 在开始连接之前执行一组预检检查，目的是验证先决条件并避免常见的集群启动问题。

请注意：

1. kubeadm join 预检检查基本上是一个 kubeadm init 预检检查的子集
2. 从 1.9 开始，kubeadm 为 CRI 泛型功能提供了更好的支持; 在这种情况下，docker 特定的控件将被跳过或替换为 crictl 类似控件
3. 从 1.9 开始，kubeadm 支持加入运行在 Windows 上的节点; 在这种情况下，会跳过 linux 特定的控制
4. 在任何情况下，用户都可以使用该 --ignore-preflight-errors 选项跳过特定的预检检查（或最终所有预检检查）

### 发现集群信息

有两个主要的发现方案。首先是使用共享令牌以及 API server 的 IP 地址。第二个是提供一个文件（标准 kubeconfig 文件的一个子集）。

#### 共享令牌发现

如果 kubeadm join 被调用为 --discovery-token，则使用令牌发现; 在这种情况下，节点基本上从命名空间 kube-public 下 cluster-info ConfigMap 中检索集群 CA 证书 。

为了防止 “中间人” 攻击，采取了几个步骤：

- 首先，通过不安全的连接检索 CA 证书（这是可能的，因为 kubeadm init 对 system:unauthenticated 授予了访问 cluster-info 用户的权限）
- 然后 CA 证书通过以下验证步骤：
  - 基本验证：针对 JWT 签名使用令牌 ID
  - 发布密钥验证：使用提供的 --discovery-token-ca-cert-hash。此值可在 kubeadm  init 的输出中获取，也可以使用标准工具计算（散列是在 SPKI（Subject Public Key Info）对象的字节上计算的，如  RFC 7469 中所示）。--discovery-token-ca-cert-hash 标志可以重复多次，以允许多个公钥。  -作为附加验证，CA 证书通过安全连接进行检索，然后与最初检索的 CA 进行比较

请注意：

1. 通过 --discovery-token-unsafe-skip-ca-verification 标志可以跳过发布密钥验证; 这削弱了 kubeadm 安全模型，因为其他人可能潜在模仿 Kubernetes Master。

#### 文件/https 发现

如果 kubeadm join 被调用为 --discovery-file，则使用文件发现; 此文件可以是本地文件或通过 HTTPS URL 下载; 在 HTTPS 的情况下，主机安装的 CA 用于验证连接。

通过文件发现，集群 CA 证书被提供到文件本身; 事实上，发现的文件是一个 kubeconfig  文件，其中只设置了 server 和 certificate-authority-data 属性，如 kubeadm join 参考文档中所述; 当与集群建立连接时，kubeadm 尝试访问 cluster-info ConfigMap，如果可用，则使用它。

## TLS 引导

一旦知道了集群信息，就会编写文件 bootstrap-kubelet.conf，从而允许 kubelet 执行 TLS 引导（相反，直到 v1.7 TLS 引导被 kubeadm 管理）。

TLS 引导机制使用共享令牌临时向 Kubernetes Master 进行身份验证，以提交本地创建的密钥对的证书签名请求（CSR）。

然后自动批准该请求，并且该操作完成保存 ca.crt 文件和用于加入集群的 kubelet.conf 文件，而 bootstrap-kubelet.conf 被删除。

请注意：

- 临时验证是根据 kubeadm init 过程中保存的令牌进行验证的（或者使用 kubeadm token 创建的附加令牌）
- 对 kubeadm init 过程中被授予访问 CSR api 的 system:bootstrappers:kubeadm:default-node-token 组的用户成员的临时身份验证解析
- 自动 CSR 审批由 csrapprover 控制器管理，与 kubeadm init 过程的配置相一致

### （可选，1.9 版本中为 alpha）编写init kubelet配置

如果 kubeadm 被调用为 --feature-gates=DynamicKubeletConfig：

1. 使用引导令牌凭据从 kube-system 命名空间中的 kubelet-base-config-v1.9 ConfigMap 中读取  kubelet 基本配置，并将其写入磁盘，作为 kubelet init  配置文件 /var/lib/kubelet/config/init/kubelet
2. 当 kubelet 以节点自己的凭据（/etc/kubernetes/kubelet.conf）开始时，更新当前节点配置，指定 node/kubelet 配置的源是上面的 ConfigMap。

请注意：

1. 要使动态 kubelet  配置正常工作，应在 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf 中指定标志 --dynamic-config-dir=/var/lib/kubelet/config/dynamic

# Kubernetes 组件

- 1 Master 组件
  - [1.1 kube-apiserver](http://docs.kubernetes.org.cn/230.html#kube-apiserver)
  - [1.2 ETCD](http://docs.kubernetes.org.cn/230.html#ETCD)
  - [1.3 kube-controller-manager](http://docs.kubernetes.org.cn/230.html#kube-controller-manager)
  - [1.4 cloud-controller-manager](http://docs.kubernetes.org.cn/230.html#cloud-controller-manager)
  - [1.5 kube-scheduler](http://docs.kubernetes.org.cn/230.html#kube-scheduler)
  - 1.6 插件 addons
    - [1.6.1 DNS](http://docs.kubernetes.org.cn/230.html#DNS)
    - [1.6.2 用户界面](http://docs.kubernetes.org.cn/230.html#i)
    - [1.6.3 容器资源监测](http://docs.kubernetes.org.cn/230.html#i-2)
    - [1.6.4 Cluster-level Logging](http://docs.kubernetes.org.cn/230.html#Cluster-level_Logging)
- 2 节点（Node）组件
  - [2.1 kubelet](http://docs.kubernetes.org.cn/230.html#kubelet)
  - [2.2 kube-proxy](http://docs.kubernetes.org.cn/230.html#kube-proxy)
  - [2.3 docker](http://docs.kubernetes.org.cn/230.html#docker)
  - [2.4 RKT](http://docs.kubernetes.org.cn/230.html#RKT)
  - [2.5 supervisord](http://docs.kubernetes.org.cn/230.html#supervisord)
  - [2.6 fluentd](http://docs.kubernetes.org.cn/230.html#fluentd)

本文介绍了Kubernetes集群所需的各种二进制组件。

## Master 组件

Master组件提供集群的管理控制中心。

Master组件可以在集群中任何节点上运行。但是为了简单起见，通常在一台VM/机器上启动所有Master组件，并且不会在此VM/机器上运行用户容器。请参考 [构建高可用群集](https://kubernetes.io/docs/admin/high-availability)以来构建multi-master-VM。

### kube-apiserver

[kube-apiserver](https://kubernetes.io/docs/admin/kube-apiserver)用于暴露Kubernetes API。任何的资源请求/调用操作都是通过kube-apiserver提供的接口进行。请参阅[构建高可用群集](https://kubernetes.io/docs/admin/high-availability)。

### ETCD

[etcd](https://kubernetes.io/docs/admin/etcd)是Kubernetes提供默认的存储系统，保存所有集群数据，使用时需要为etcd数据提供备份计划。

### kube-controller-manager

[kube-controller-manager](https://kubernetes.io/docs/admin/kube-controller-manager)运行管理控制器，它们是集群中处理常规任务的后台线程。逻辑上，每个控制器是一个单独的进程，但为了降低复杂性，它们都被编译成单个二进制文件，并在单个进程中运行。

这些控制器包括：

- [节点（Node）控制器](http://docs.kubernetes.org.cn/304.html)。

- 副本（Replication）控制器：负责维护系统中每个副本中的pod。

- 端点（Endpoints）控制器：填充Endpoints对象（即连接Services＆Pods）。

- Service Account

  和Token控制器：为新的

  Namespace

   创建默认帐户访问API Token。

  

### cloud-controller-manager

云控制器管理器负责与底层云提供商的平台交互。云控制器管理器是Kubernetes版本1.6中引入的，目前还是Alpha的功能。

云控制器管理器仅运行云提供商特定的（controller loops）控制器循环。可以通过将`--cloud-provider` flag设置为external启动kube-controller-manager ，来禁用控制器循环。

cloud-controller-manager 具体功能：

- 节点（Node）控制器

- 路由（Route）控制器

- Service控制器

- 卷（Volume）控制器

  

### kube-scheduler

kube-scheduler 监视新创建没有分配到[Node](http://docs.kubernetes.org.cn/304.html)的[Pod](http://docs.kubernetes.org.cn/312.html)，为Pod选择一个Node。

### 插件 addons

插件（addon）是实现集群pod和Services功能的 。Pod由[Deployments](http://docs.kubernetes.org.cn/317.html)，ReplicationController等进行管理。Namespace 插件对象是在kube-system Namespace中创建。

#### DNS

虽然不严格要求使用插件，但Kubernetes集群都应该具有集群 DNS。

群集 DNS是一个DNS服务器，能够为 Kubernetes services提供 DNS记录。

由Kubernetes启动的容器自动将这个DNS服务器包含在他们的DNS searches中。

了解[更多详情](https://www.kubernetes.org.cn/542.html)

#### 用户界面

kube-ui提供集群状态基础信息查看。更多详细信息，请参阅[使用HTTP代理访问Kubernetes API](https://kubernetes.io/docs/tasks/access-kubernetes-api/http-proxy-access-api/)

#### 容器资源监测

[容器资源监控](https://kubernetes.io/docs/user-guide/monitoring)提供一个UI浏览监控数据。

#### Cluster-level Logging

[Cluster-level logging](https://kubernetes.io/docs/user-guide/logging/overview)，负责保存容器日志，搜索/查看日志。

## 节点（Node）组件

节点组件运行在[Node](http://docs.kubernetes.org.cn/304.html)，提供Kubernetes运行时环境，以及维护Pod。

### kubelet

[kubelet](https://kubernetes.io/docs/admin/kubelet)是主要的节点代理，它会监视已分配给节点的pod，具体功能：

- 安装Pod所需的volume。
- 下载Pod的Secrets。
- Pod中运行的 docker（或experimentally，rkt）容器。
- 定期执行容器健康检查。
- Reports the status of the pod back to the rest of the system, by creating a *mirror pod* if necessary.
- Reports the status of the node back to the rest of the system.

### kube-proxy

[kube-proxy](https://kubernetes.io/docs/admin/kube-proxy)通过在主机上维护网络规则并执行连接转发来实现Kubernetes服务抽象。

### docker

docker用于运行容器。

### RKT

rkt运行容器，作为docker工具的替代方案。

### supervisord

supervisord是一个轻量级的监控系统，用于保障kubelet和docker运行。

### fluentd

fluentd是一个守护进程，可提供[cluster-level logging](https://kubernetes.io/docs/concepts/overview/components/#cluster-level-logging).。

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# 了解Kubernetes对象

- 1 了解Kubernetes对象
  - [1.1 对象（Object）规范和状态](http://docs.kubernetes.org.cn/232.html#Object)
  - [1.2 描述Kubernetes对象](http://docs.kubernetes.org.cn/232.html#Kubernetes-2)
  - [1.3 必填字段](http://docs.kubernetes.org.cn/232.html#i)
- [2 下一步？](http://docs.kubernetes.org.cn/232.html#i-2)

## 了解Kubernetes对象

Kubernetes对象是Kubernetes系统中的持久实体。Kubernetes使用这些实体来表示集群的状态。具体来说，他们可以描述：

- 容器化应用正在运行(以及在哪些节点上)
- 这些应用可用的资源
- 关于这些应用如何运行的策略，如重新策略，升级和容错

Kubernetes对象是“record of intent”，一旦创建了对象，Kubernetes系统会确保对象存在。通过创建对象，可以有效地告诉Kubernetes系统你希望集群的工作负载是什么样的。

要使用Kubernetes对象（无论是创建，修改还是删除），都需要使用[Kubernetes API](http://docs.kubernetes.org.cn/31.html)。例如，当使用[kubectl命令管理工具](http://docs.kubernetes.org.cn/61.html)时，CLI会为提供Kubernetes API调用。你也可以直接在自己的程序中使用Kubernetes API，Kubernetes提供一个golang[客户端库](http://docs.kubernetes.org.cn/29.html) （其他语言库正在开发中-如Python）。

### 对象（Object）规范和状态

每个Kubernetes对象都包含两个嵌套对象字段，用于管理Object的配置：Object Spec和Object  Status。Spec描述了对象所需的状态 -  希望Object具有的特性，Status描述了对象的实际状态，并由Kubernetes系统提供和更新。

例如，通过Kubernetes  Deployment 来表示在集群上运行的应用的对象。创建Deployment时，可以设置Deployment  Spec，来指定要运行应用的三个副本。Kubernetes系统将读取Deployment Spec，并启动你想要的三个应用实例 -  来更新状态以符合之前设置的Spec。如果这些实例中有任何一个失败（状态更改），Kuberentes系统将响应Spec和当前状态之间差异来调整，这种情况下，将会开始替代实例。

有关object spec、status和metadata更多信息，请参考“[Kubernetes API Conventions](https://git.k8s.io/community/contributors/devel/api-conventions.md)[”](https://git.k8s.io/community/contributors/devel/api-conventions.md)。

### 描述Kubernetes对象

在Kubernetes中创建对象时，必须提供描述其所需Status的对象Spec，以及关于对象（如name）的一些基本信息。当使用Kubernetes API创建对象（直接或通过kubectl）时，该API请求必须将该信息作为JSON包含在请求body中。通常，可以将信息提供给kubectl  .yaml文件，在进行API请求时，kubectl将信息转换为JSON。

以下示例是一个.yaml文件，显示Kubernetes Deployment所需的字段和对象Spec：

| [nginx-deployment.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/overview/working-with-objects/nginx-deployment.yaml)![将nginx-deployment.yaml复制到剪贴板](https://d33wubrfki0l68.cloudfront.net/951ae1fcc65e28202164b32c13fa7ae04fab4a0b/b77dc/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: apps/v1beta1 kind: Deployment metadata:  name: nginx-deployment spec:  replicas: 3  template:    metadata:      labels:        app: nginx    spec:      containers:      - name: nginx        image: nginx:1.7.9        ports:        - containerPort: 80` |

使用上述.yaml文件创建Deployment，是通过在kubectl中使用[kubectl create](https://kubernetes.io/docs/user-guide/kubectl/v1.7/#create)命令来实现。将该.yaml文件作为参数传递。如下例子：

```
$ kubectl create -f docs/user-guide/nginx-deployment.yaml --record
```

其输出与此类似:

```
deployment "nginx-deployment" created
```

### 必填字段

对于要创建的Kubernetes对象的yaml文件，需要为以下字段设置值：

- apiVersion - 创建对象的Kubernetes API 版本
- kind - 要创建什么样的对象？
- metadata- 具有唯一标示对象的数据，包括 name（字符串）、UID和Namespace（可选项）

还需要提供对象Spec字段，对象Spec的精确格式（对于每个Kubernetes 对象都是不同的），以及容器内嵌套的特定于该对象的字段。[Kubernetes API reference](https://kubernetes.io/docs/api/)可以查找所有可创建Kubernetes对象的Spec格式。

## 下一步？

- 了解最重要的Kubernetes对象，如[Pod](http://docs.kubernetes.org.cn/312.html)

# Kubernetes Names

Kubernetes REST API中的所有对象都用Name和UID来明确地标识。

对于非唯一用户提供的属性，Kubernetes提供[labels](http://docs.kubernetes.org.cn/247.html)和[annotations](http://docs.kubernetes.org.cn/255.html)。

## Name

Name在一个对象中同一时间只能拥有单个Name，如果对象被删除，也可以使用相同Name创建新的对象，Name用于在资源引用URL中的对象，例如`/api/v1/pods/some-name`。通常情况，Kubernetes资源的Name能有最长到253个字符（包括数字字符、`-`和`.`），但某些资源可能有更具体的限制条件，具体情况可以参考：[标识符设计文档](https://git.k8s.io/community/contributors/design-proposals/identifiers.md)。

## UIDs

UIDs是由Kubernetes生成的，在Kubernetes集群的整个生命周期中创建的每个对象都有不同的UID（即它们在空间和时间上是唯一的）。

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# Kubernetes Namespaces

- [1 何时使用多个Namespaces](http://docs.kubernetes.org.cn/242.html#Namespaces)
- 2 使用 Namespaces
  - [2.1 创建](http://docs.kubernetes.org.cn/242.html#i)
  - [2.2 删除](http://docs.kubernetes.org.cn/242.html#i-2)
  - [2.3 查看 Namespaces](http://docs.kubernetes.org.cn/242.html#_Namespaces-2)
  - [2.4 Setting the namespace for a request](http://docs.kubernetes.org.cn/242.html#Setting_the_namespace_for_a_request)
  - [2.5 Setting the namespace preference](http://docs.kubernetes.org.cn/242.html#Setting_the_namespace_preference)
- [3 所有对象都在Namespace中?](http://docs.kubernetes.org.cn/242.html#Namespace)

Kubernetes可以使用Namespaces（命名空间）创建多个虚拟集群。

## 何时使用多个Namespaces

当团队或项目中具有许多用户时，可以考虑使用Namespace来区分，a如果是少量用户集群，可以不需要考虑使用Namespace，如果需要它们提供特殊性质时，可以开始使用Namespace。

Namespace为名称提供了一个范围。资源的Names在Namespace中具有唯一性。

Namespace是一种将集群资源划分为多个用途(通过 [resource quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/))的方法。

在未来的Kubernetes版本中，默认情况下，相同Namespace中的对象将具有相同的访问控制策略。

对于稍微不同的资源没必要使用多个Namespace来划分，例如同意软件的不同版本，可以使用[labels(标签)](http://docs.kubernetes.org.cn/247.html)来区分同一Namespace中的资源。

## 使用 Namespaces

Namespace的创建、删除和查看。

### 创建

```
(1) 命令行直接创建
$ kubectl create namespace new-namespace

(2) 通过文件创建
$ cat my-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: new-namespace

$ kubectl create -f ./my-namespace.yaml
```

注意：命名空间名称满足正则表达式[a-z0-9]([-a-z0-9]*[a-z0-9])?,最大长度为63位

### 删除

```
$ kubectl delete namespaces new-namespace
```

注意：

1. 删除一个namespace会自动删除所有属于该namespace的资源。
2. default和kube-system命名空间不可删除。
3. PersistentVolumes是不属于任何namespace的，但PersistentVolumeClaim是属于某个特定namespace的。
4. Events是否属于namespace取决于产生events的对象。

### 查看 Namespaces

使用以下命令列出群集中的当前的Namespace：

```
$ kubectl get namespaces
NAME          STATUS    AGE
default       Active    1d
kube-system   Active    1d
```

Kubernetes从两个初始的Namespace开始：

- default
- kube-system 由Kubernetes系统创建的对象的Namespace

### Setting the namespace for a request

要临时设置Request的Namespace，请使用--namespace 标志。

例如：

```
$ kubectl --namespace=<insert-namespace-name-here> run nginx --image=nginx
$ kubectl --namespace=<insert-namespace-name-here> get pods
```

### Setting the namespace preference

可以使用kubectl命令创建的Namespace可以永久保存在context中。

```
$ kubectl config set-context $(kubectl config current-context) --namespace=<insert-namespace-name-here>
# Validate it
$ kubectl config view | grep namespace:
```

## 所有对象都在Namespace中?

大多数Kubernetes资源（例如pod、services、replication controllers或其他）都在某些Namespace中，但Namespace资源本身并不在Namespace中。而低级别资源（如[Node](http://docs.kubernetes.org.cn/304.html)和persistentVolumes）不在任何Namespace中。[Events](https://www.kubernetes.org.cn/1031.html)是一个例外：它们可能有也可能没有Namespace，具体取决于[Events](https://www.kubernetes.org.cn/1031.html)的对象。

# Kubernetes 为 Namespace 配置Pod配额

- [1 Before you begin](http://docs.kubernetes.org.cn/749.html#Before_you_begin)
- [2 创建名字空间](http://docs.kubernetes.org.cn/749.html#i)
- [3 创建ResourceQuota对象](http://docs.kubernetes.org.cn/749.html#ResourceQuota)
- [4 练习环境的清理](http://docs.kubernetes.org.cn/749.html#i-2)
- 5 What’s next
  - [5.1 对于集群管理员](http://docs.kubernetes.org.cn/749.html#i-3)
  - [5.2 对于应用开发者](http://docs.kubernetes.org.cn/749.html#i-4)

This page shows how to set a quota for the total number of Pods that can run in a namespace. You specify quotas in a [ResourceQuota](https://k8smeetup.github.io/docs/api-reference/v1.7/#resourcequota-v1-core) object. 本任务展示了如何为某一名字空间（namespace）设置Pod配额以限制可以在名字空间中运行的Pod数量。 配额通过[ResourceQuota](https://k8smeetup.github.io/docs/api-reference/v1.7/#resourcequota-v1-core)对象设置。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

## 创建名字空间

创建一个单独的名字空间，以便于隔离您在本练习中创建的资源与集群的其他资源。

```
kubectl create namespace quota-pod-example
```

## 创建ResourceQuota对象

以下展示了ResourceQuota对象的配置文件内容：

| [quota-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/quota-pod.yaml)![Copy quota-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: ResourceQuota metadata:  name: pod-demo spec:  hard:    pods: "2" ` |

下面，首先创建ResourceQuota对象

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/quota-pod.yaml --namespace=quota-pod-example
```

然后可以通过以下命令查看ResourceQuota对象的详细信息：

```
kubectl get resourcequota pod-demo --namespace=quota-pod-example --output=yaml
```

命令输出显示了这个名字空间的Pod配额是2，由于目前没有Pod运行，所有配额并没有被使用。

```
spec:
  hard:
    pods: "2"
status:
  hard:
    pods: "2"
  used:
    pods: "0"
```

下面展示的是一个Deployment的配置文件：

| [quota-pod-deployment.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/quota-pod-deployment.yaml)![Copy quota-pod-deployment.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: apps/v1beta1 kind: Deployment metadata:  name: pod-quota-demo spec:  replicas: 3  template:    metadata:      labels:        purpose: quota-demo    spec:      containers:      - name: pod-quota-demo        image: nginx ` |

从配置文件可以看到，replicas: 3将令Kubernetes尝试创建3个Pod，所有的Pod实例都将运行同样的应用程序。

接下来尝试创建这个Deployment：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/quota-pod-deployment.yaml --namespace=quota-pod-example
```

并通过以下命令查看Deployment的详细信息：

```
kubectl get deployment pod-quota-demo --namespace=quota-pod-example --output=yaml
```

从命令输出可以看到尽管在Deployment中我们设置了需要启动3个Pod实例，但由于配额的存在，只有两个Pod被成功创建。

```
spec:
  ...
  replicas: 3
...
status:
  availableReplicas: 2
...
lastUpdateTime: 2017-07-07T20:57:05Z
    message: 'unable to create pods: pods "pod-quota-demo-1650323038-" is forbidden:
      exceeded quota: pod-demo, requested: pods=1, used: pods=2, limited: pods=2'
```

## 练习环境的清理

通过删除名字空间即可完成环境的清理：

```
kubectl delete namespace quota-pod-example
```

## What’s next

### 对于集群管理员

- [为 Namespace 设置最小和最大内存限制](http://docs.kubernetes.org.cn/745.html)
- [为 Namespace 配置默认内存请求和限制](http://docs.kubernetes.org.cn/746.html)
- [为 Namespace 配置默认 CPU 请求和限制](http://docs.kubernetes.org.cn/747.html)
- [为 Namespace 配置最小和最大 CPU 限制](https://k8smeetup.github.io/docs/tasks/administer-cluster/cpu-constraint-namespace/)
- [为 Namespace 配置内存和 CPU 配额](http://docs.kubernetes.org.cn/748.html)
- [为 Namespace 配置 Pod 配额](http://docs.kubernetes.org.cn/749.html)
- [为 API 对象配置配额](http://docs.kubernetes.org.cn/750.html)

### 对于应用开发者

- [为容器和 Pod 分配内存资源](http://docs.kubernetes.org.cn/729.html)
- [为容器和 Pod 分配 CPU 资源](http://docs.kubernetes.org.cn/728.html)
- [为 Pod 配置服务质量](http://docs.kubernetes.org.cn/751.html)

译者：[xingzhou](https://github.com/xingzhou) / [原文链接](https://k8smeetup.github.io/docs/tasks/administer-cluster/quota-pod-namespace/)

# Kubernetes 在 Namespace 中配置默认的CPU请求与限额

- [1 Before you begin](http://docs.kubernetes.org.cn/747.html#Before_you_begin)
- [2 创建一个命名空间](http://docs.kubernetes.org.cn/747.html#i)
- [3 创建一个LimitRange和一个Pod](http://docs.kubernetes.org.cn/747.html#LimitRangePod)
- [4 如果你指定了一个容器的限额值，但未指定请求值，会发生什么？](http://docs.kubernetes.org.cn/747.html#i-2)
- [5 如果你指定了一个容器的请求值，未指定限额值，会发生什么？](http://docs.kubernetes.org.cn/747.html#i-3)
- [6 默认CPU限额和请求的动机](http://docs.kubernetes.org.cn/747.html#CPU)
- 7 What’s next
  - [7.1 对于集群管理员](http://docs.kubernetes.org.cn/747.html#i-4)
  - [7.2 对于应用开发者](http://docs.kubernetes.org.cn/747.html#i-5)

本页展示了如何在命名空间中配置默认的CPU请求与限额。
 一个Kubernetes集群能细分为不同的命名空间。如果在一个拥有默认CPU限额的命名空间中创建一个容器，则这个容器不需要指定它自己的CPU限额， 它会被分配这个默认的CPU限额值。Kubernetes在某些条件下才会分配默认的CPU请求值，这个将在本主题的后面解释。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

## 创建一个命名空间

创建一个命名空间为了使你在本练习中创建的资源与集群的其它部分相隔离。

```
kubectl create namespace default-cpu-example
```

## 创建一个LimitRange和一个Pod

以下是一个LimitRange对象的配置文件。这个配置中指定了一个默认的CPU请求和一个默认的CPU限额。

| [cpu-defaults.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-defaults.yaml)![Copy cpu-defaults.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: LimitRange metadata:  name: cpu-limit-range spec:  limits:  - default:      cpu: 1    defaultRequest:      cpu: 0.5    type: Container ` |

在这个defaule-cpu-example命名空间中创建这个LimitRange:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-defaults.yaml --namespace=default-cpu-example
```

现在如果在这个defaule-cpu-example命名空间中创建一个容器，则该容器不需要指定它自己的CPU请求和CPU限额， 该容器会被赋予一个默认的CPU请求值0.5和一个默认的CPU限额值1。

| [cpu-defaults-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-defaults-pod.yaml)![Copy cpu-defaults-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-cpu-demo spec:  containers:  - name: default-cpu-demo-ctr    image: nginx ` |

创建Pod

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-defaults-pod.yaml --namespace=default-cpu-example
```

查看该Pod的配置：

```
kubectl get pod default-cpu-demo --output=yaml --namespace=default-cpu-example
```

输出显示该Pod的容器含有一个CPU请求值500m和一个CPU限额值1。 这些是由LimitRange指定的默认值。

```
containers:
- image: nginx
  imagePullPolicy: Always
  name: default-cpu-demo-ctr
  resources:
    limits:
      cpu: "1"
    requests:
      cpu: 500m
```

## 如果你指定了一个容器的限额值，但未指定请求值，会发生什么？

以下是一个含有一个容器的Pod的配置文件。该容器指定了一个CPU限额，但未指定请求：

| [cpu-defaults-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-defaults-pod-2.yaml)![Copy cpu-defaults-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-cpu-demo-2 spec:  containers:  - name: default-cpu-demo-2-ctr    image: nginx    resources:      limits:        cpu: "1" ` |

创建该Pod:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-defaults-pod-2.yaml --namespace=default-cpu-example
```

查看该Pod的配置：

```
kubectl get pod cpu-limit-no-request --output=yaml --namespace=default-cpu-example
```

输出展示该容器的CPU请求值与它的限额值相等。
 注意该容器并未被赋予这个默认的CPU请求值0.5。

```
resources:
  limits:
    cpu: "1"
  requests:
    cpu: "1"
```

## 如果你指定了一个容器的请求值，未指定限额值，会发生什么？

以下是含有一个容器的Pod的配置文件。该容器指定了一个CPU请求，但未指定一个限额：

| [cpu-defaults-pod-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-defaults-pod-3.yaml)![Copy cpu-defaults-pod-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-cpu-demo-3 spec:  containers:  - name: default-cpu-demo-3-ctr    image: nginx    resources:      requests:        cpu: "0.75" ` |

创建该Pod

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-defaults-pod-3.yaml --namespace=default-cpu-example
```

输出显示该容器的CPU请求值被设置为该容器配置文件中指定的值。该容器的CPU限额设置为1，这是该命名空间的默认CPU的限额值。

```
resources:
  limits:
    cpu: "1"
  requests:
    cpu: 750m
```

## 默认CPU限额和请求的动机

如果你的命名空间含有[资源配额](https://kubernetes.io/docs/tasks/administer-cluster/cpu-default-namespace/), 它是有帮助的对于设置一个CPU限额的默认值。 以下是资源配额对命名空间施加的两个限制：

- 在命名空间运行的每一个容器必须含有它自己的CPU限额。
- 在命名空间中所有容器使用的CPU总量不能超出指定的限额。

如果一个容器没有指定它自己的CPU限额，它将被赋予默认的限额值，然后它可以在被配额限制的命名空间中运行。

## What’s next

### 对于集群管理员

- [为 Namespace 设置最小和最大内存限制](http://docs.kubernetes.org.cn/745.html)
- [为 Namespace 配置默认内存请求和限制](http://docs.kubernetes.org.cn/746.html)
- [为 Namespace 配置默认 CPU 请求和限制](http://docs.kubernetes.org.cn/747.html)
- [为 Namespace 配置最小和最大 CPU 限制](https://k8smeetup.github.io/docs/tasks/administer-cluster/cpu-constraint-namespace/)
- [为 Namespace 配置内存和 CPU 配额](http://docs.kubernetes.org.cn/748.html)
- [为 Namespace 配置 Pod 配额](http://docs.kubernetes.org.cn/749.html)
- [为 API 对象配置配额](http://docs.kubernetes.org.cn/750.html)

### 对于应用开发者

- [为容器和 Pod 分配内存资源](http://docs.kubernetes.org.cn/729.html)
- [为容器和 Pod 分配 CPU 资源](http://docs.kubernetes.org.cn/728.html)
- [为 Pod 配置服务质量](http://docs.kubernetes.org.cn/751.html)

# Kubernetes 为 Namespace 配置默认的内存请求与限额

- [1 Before you begin](http://docs.kubernetes.org.cn/746.html#Before_you_begin)
- [2 创建命名空间](http://docs.kubernetes.org.cn/746.html#i)
- [3 创建 LimitRange 和 Pod](http://docs.kubernetes.org.cn/746.html#_LimitRange_Pod)
- [4 如果您指定了容器的限额值，但未指定请求值，会发生什么？](http://docs.kubernetes.org.cn/746.html#i-2)
- [5 如果您指定了容器的请求值，但未指定限额值，会发生什么？](http://docs.kubernetes.org.cn/746.html#i-3)
- [6 默认内存限额与请求的动机](http://docs.kubernetes.org.cn/746.html#i-4)
- 7 What’s next
  - [7.1 对于集群管理员](http://docs.kubernetes.org.cn/746.html#i-5)
  - [7.2 对于应用开发者](http://docs.kubernetes.org.cn/746.html#i-6)

本页展示了如何给命名空间配置默认的内存请求与限额。  如果在一个拥有默认内存限额的命名空间中创建一个容器，并且这个容器未指定它自己的内存限额， 它会被分配这个默认的内存限额值。Kubernetes  在某些条件下才会分配默认的内存请求值，这个将在本主题的后面解释。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

集群中的每个节点必须具有至少 300GiB 的内存。

## 创建命名空间

创建一个命名空间，以便您在本练习中创建的资源与集群的其它部分相隔离。

```
kubectl create namespace default-mem-example
```

## 创建 LimitRange 和 Pod

以下是一个 LimitRange 对象的配置文件。该配置指定了默认的内存请求与默认的内存限额。

| [memory-defaults.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-defaults.yaml)![Copy memory-defaults.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: LimitRange metadata:  name: mem-limit-range spec:  limits:  - default:      memory: 512Mi    defaultRequest:      memory: 256Mi    type: Container ` |

在 default-mem-example 命名空间中创建 LimitRange：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-defaults.yaml --namespace=default-mem-example
```

现在如果在这个 default-mem-example 命名空间中创建一个容器，并且该容器未指定它自己的内存请求与内存限额， 该容器会被赋予默认的内存请求值 256MiB 和默认的内存限额值 512MiB。

以下是一个 Pod 的配置文件，它含有一个容器。这个容器没有指定内存请求和限额。

| [memory-defaults-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-defaults-pod.yaml)![Copy memory-defaults-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-mem-demo spec:  containers:  - name: default-mem-demo-ctr    image: nginx ` |

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-defaults-pod.yaml --namespace=default-mem-example
```

查看关于该 Pod 的详细信息：

```
kubectl get pod default-mem-demo --output=yaml --namespace=default-mem-example
```

输出显示该 Pod 的容器的内存请求值是 256MiB, 内存限额值是 512MiB. 这些是由 LimitRange 指定的默认值。

```
containers:
- image: nginx
  imagePullPolicy: Always
  name: default-mem-demo-ctr
  resources:
    limits:
      memory: 512Mi
    requests:
      memory: 256Mi
```

删除 Pod:

```
kubectl delete pod default-mem-demo --namespace=default-mem-example
```

## 如果您指定了容器的限额值，但未指定请求值，会发生什么？

以下是含有一个容器的 Pod 的配置文件。该容器指定了内存限额，但未指定请求：

| [memory-defaults-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-defaults-pod-2.yaml)![Copy memory-defaults-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-mem-demo-2 spec:  containers:  - name: defalt-mem-demo-2-ctr    image: nginx    resources:      limits:        memory: "1Gi" ` |

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-defaults-pod-2.yaml --namespace=default-mem-example
```

查看关于该 Pod 的详细信息：

```
kubectl get pod mem-limit-no-request --output=yaml --namespace=default-mem-example
```

输出显示该容器的内存请求值与它的限额值相等。
 注意该容器并未被赋予默认的内存请求值 256MiB。

```
resources:
  limits:
    memory: 1Gi
  requests:
    memory: 1Gi
```

## 如果您指定了容器的请求值，但未指定限额值，会发生什么？

以下是含有一个容器的 Pod 的配置文件。该容器指定了内存请求，但未指定限额：

| [memory-defaults-pod-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-defaults-pod-3.yaml)![Copy memory-defaults-pod-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: default-mem-demo-3 spec:  containers:  - name: default-mem-demo-3-ctr    image: nginx    resources:      requests:        memory: "128Mi" ` |

创建该 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-defaults-pod-3.yaml --namespace=default-mem-example
```

查看该 Pod 的配置信息：

```
kubectl get pod default-mem-request-no-limit --output=yaml --namespace=default-mem-example
```

输出显示该容器的内存请求值被设置为该容器配置文件中指定的值。该容器的内存限额设置为 512Mi，这是该命名空间的默认内存限额值。

```
resources:
  limits:
    memory: 512Mi
  requests:
    memory: 128Mi
```

## 默认内存限额与请求的动机

如果您的命名空间具有资源配额, 它为内存限额设置默认值是有意义的。 以下是资源配额对命名空间施加的两个限制：

- 在命名空间运行的每一个容器必须有它自己的内存限额。
- 在命名空间中所有的容器使用的内存总量不能超出指定的限额。

如果一个容器没有指定它自己的内存限额，它将被赋予默认的限额值，然后它才可以在被配额限制的命名空间中运行。

## What’s next

### 对于集群管理员

- [为 Namespace 设置最小和最大内存限制](http://docs.kubernetes.org.cn/745.html)
- [为 Namespace 配置默认内存请求和限制](http://docs.kubernetes.org.cn/746.html)
- [为 Namespace 配置默认 CPU 请求和限制](http://docs.kubernetes.org.cn/747.html)
- [为 Namespace 配置最小和最大 CPU 限制](https://k8smeetup.github.io/docs/tasks/administer-cluster/cpu-constraint-namespace/)
- [为 Namespace 配置内存和 CPU 配额](http://docs.kubernetes.org.cn/748.html)
- [为 Namespace 配置 Pod 配额](http://docs.kubernetes.org.cn/749.html)
- [为 API 对象配置配额](http://docs.kubernetes.org.cn/750.html)

### 对于应用开发者

- [为容器和 Pod 分配内存资源](http://docs.kubernetes.org.cn/729.html)
- [为容器和 Pod 分配 CPU 资源](http://docs.kubernetes.org.cn/728.html)
- [为 Pod 配置服务质量](http://docs.kubernetes.org.cn/751.html)

# Kubernetes 为 Namespace 设置最小和最大内存限制

- [1 Before you begin](http://docs.kubernetes.org.cn/745.html#Before_you_begin)
- [2 创建一个 namespace](http://docs.kubernetes.org.cn/745.html#_namespace)
- [3 创建一个 LimitRange 和一个 Pod](http://docs.kubernetes.org.cn/745.html#_LimitRange_Pod)
- [4 尝试创建一个超过最大内存限制的 Pod](http://docs.kubernetes.org.cn/745.html#_Pod)
- [5 尝试创建一个不符合最小内存请求的 Pod](http://docs.kubernetes.org.cn/745.html#_Pod-2)
- [6 创建一个没有指定任何内存请求和限制的 Pod](http://docs.kubernetes.org.cn/745.html#_Pod-3)
- [7 应用最小和最大内存限制](http://docs.kubernetes.org.cn/745.html#i)
- [8 最小和最大内存限制的动因](http://docs.kubernetes.org.cn/745.html#i-2)
- [9 清理](http://docs.kubernetes.org.cn/745.html#i-3)
- 10 What’s next
  - [10.1 对于集群管理员](http://docs.kubernetes.org.cn/745.html#i-4)
  - [10.2 对于应用开发者](http://docs.kubernetes.org.cn/745.html#i-5)

本文展示了如何为 namespace 中运行的容器设置内存的最小和最大值。您可以设置 [LimitRange](https://k8smeetup.github.io/docs/api-reference/v1.8/#limitrange-v1-core) 对象中内存的最小和最大值。如果 Pod 没有符合 LimitRange 施加的限制，那么它就不能在 namespace 中创建。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

集群中的每个节点至少需要 1 GiB 内存。

## 创建一个 namespace

请创建一个 namespace，这样您在本练习中创建的资源就可以和集群中其余资源相互隔离。

```
kubectl create namespace constraints-mem-example
```

## 创建一个 LimitRange 和一个 Pod

这是 LimitRange 的配置文件：

| [memory-constraints.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-constraints.yaml)![Copy memory-constraints.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: LimitRange metadata:  name: mem-min-max-demo-lr spec:  limits:  - max:      memory: 1Gi    min:      memory: 500Mi    type: Container ` |

创建 LimitRange:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-constraints.yaml --namespace=constraints-mem-example
```

查看 LimitRange 的详细信息：

```
kubectl get limitrange cpu-min-max-demo --namespace=constraints-mem-example --output=yaml
```

输出显示了符合预期的最小和最大内存限制。但请注意，即使您没有在配置文件中为 LimitRange 指定默认值，它们也会被自动创建。

```
  limits:
  - default:
      memory: 1Gi
    defaultRequest:
      memory: 1Gi
    max:
      memory: 1Gi
    min:
      memory: 500Mi
    type: Container
```

现在，每当在 constraints-mem-example namespace 中创建一个容器时，Kubernetes 都会执行下列步骤：

- 如果容器没有指定自己的内存请求（request）和限制（limit），系统将会为其分配默认值。
- 验证容器的内存请求大于等于 500 MiB。
- 验证容器的内存限制小于等于 1 GiB。

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 600 MiB 的内存请求和 800 MiB 的内存限制。这些配置符合 LimitRange 施加的最小和最大内存限制。

| [memory-constraints-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-constraints-pod.yaml)![Copy memory-constraints-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-mem-demo spec:  containers:  - name: constraints-mem-demo-ctr    image: nginx    resources:      limits:        memory: "800Mi"      requests:        memory: "600Mi" ` |

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-constraints-pod.yaml --namespace=constraints-mem-example
```

验证 Pod 的容器是否运行正常：

```
kubectl get pod constraints-mem-demo --namespace=constraints-mem-example
```

查看关于 Pod 的详细信息：

```
kubectl get pod constraints-mem-demo --output=yaml --namespace=constraints-mem-example
```

输出显示了容器的内存请求为 600 MiB，内存限制为 800 MiB。这符合 LimitRange 施加的限制。

```
resources:
  limits:
     memory: 800Mi
  requests:
    memory: 600Mi
```

删除 Pod：

```
kubectl delete pod constraints-mem-demo --namespace=constraints-mem-example
```

## 尝试创建一个超过最大内存限制的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 800 MiB 的内存请求和 1.5 GiB 的内存限制。

| [memory-constraints-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-constraints-pod-2.yaml)![Copy memory-constraints-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-mem-demo-2 spec:  containers:  - name: constraints-mem-demo-2-ctr    image: nginx    resources:      limits:        memory: "1.5Gi"      requests:        memory: "800Mi" ` |

尝试创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-constraints-pod-2.yaml --namespace=constraints-mem-example
```

输出显示 Pod 没有能够成功创建，因为容器指定的内存限制值太大：

```
Error from server (Forbidden): error when creating "docs/tasks/administer-cluster/memory-constraints-pod-2.yaml":
pods "constraints-mem-demo-2" is forbidden: maximum memory usage per Container is 1Gi, but limit is 1536Mi.
```

## 尝试创建一个不符合最小内存请求的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 200 MiB 的内存请求和 800 MiB 的内存限制。

| [memory-constraints-pod-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-constraints-pod-3.yaml)![Copy memory-constraints-pod-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-mem-demo-3 spec:  containers:  - name: constraints-mem-demo-3-ctr    image: nginx    resources:      limits:        memory: "800Mi"      requests:        memory: "100Mi" ` |

尝试创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-constraints-pod-3.yaml --namespace=constraints-mem-example
```

输出显示 Pod 没有能够成功创建，因为容器指定的内存请求值太小：

```
Error from server (Forbidden): error when creating "docs/tasks/administer-cluster/memory-constraints-pod-3.yaml":
pods "constraints-mem-demo-3" is forbidden: minimum memory usage per Container is 500Mi, but request is 100Mi.
```

## 创建一个没有指定任何内存请求和限制的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器没有指定内存请求，也没有指定内存限制。

| [memory-constraints-pod-4.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/memory-constraints-pod-4.yaml)![Copy memory-constraints-pod-4.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-mem-demo-4 spec:  containers:  - name: constraints-mem-demo-4-ctr    image: nginx ` |

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/memory-constraints-pod-4.yaml --namespace=constraints-mem-example
```

查看关于 Pod 的细节信息：

```
kubectl get pod constraints-mem-demo-4 --namespace=constraints-mem-example --output=yaml
```

输出显示 Pod 的容器具有 1 GiB 的内存请求和 1 GiB 的内存限制。容器是如何获取这些值的呢？

```
resources:
  limits:
    memory: 1Gi
  requests:
    memory: 1Gi
```

因为您的容器没有指定自己的内存请求和限制，它将从 LimitRange 获取 [默认的内存请求和限制值](https://k8smeetup.github.io/docs/tasks/administer-cluster/memory-default-namespace/)。

到目前为止，您的容器可能在运行，也可能没有运行。回想起来，有一个先决条件就是节点必须拥有至少 1 GiB 内存。如果每个节点都只有 1  GiB 内存，那么任何一个节点上都没有足够的内存来容纳 1 GiB 的内存请求。如果碰巧使用的节点拥有 2 GiB  内存，那么它可能会有足够的内存来容纳 1 GiB 的内存请求。

删除 Pod：

```
kubectl delete pod constraints-mem-demo-4 --namespace=constraints-mem-example
```

## 应用最小和最大内存限制

LimitRange 在 namespace 中施加的最小和最大内存限制只有在创建和更新 Pod 时才会被应用。改变 LimitRange 不会对之前创建的 Pod 造成影响。

## 最小和最大内存限制的动因

作为一个集群管理员，您可能希望为 Pod 能够使用的内存数量施加限制。例如：

- 集群中每个节点拥有 2 GB 内存。您不希望任何 Pod 请求超过 2 GB 的内存，因为集群中没有节点能支持这个请求。
- 集群被生产部门和开发部门共享。 您希望生产负载最多使用 8 GB 的内存而将开发负载限制为 512 MB。这种情况下，您可以为生产环境和开发环境创建单独的 namespace，并对每个 namespace 应用内存限制。

## 清理

删除 namespace：

```
kubectl delete namespace constraints-mem-example
```

# Kubernetes 为 Namespace 配置CPU和内存配额

- [1 Before you begin](http://docs.kubernetes.org.cn/748.html#Before_you_begin)
- [2 创建名字空间](http://docs.kubernetes.org.cn/748.html#i)
- [3 创建ResourceQuota对象](http://docs.kubernetes.org.cn/748.html#ResourceQuota)
- [4 创建一个Pod](http://docs.kubernetes.org.cn/748.html#Pod)
- [5 尝试创建第二个Pod](http://docs.kubernetes.org.cn/748.html#Pod-2)
- [6 讨论](http://docs.kubernetes.org.cn/748.html#i-2)
- [7 练习环境的清理](http://docs.kubernetes.org.cn/748.html#i-3)
- 8 What’s next
  - [8.1 对于集群管理员](http://docs.kubernetes.org.cn/748.html#i-4)
  - [8.2 对于应用开发者](http://docs.kubernetes.org.cn/748.html#i-5)

本任务展示了如何为某一名字空间内运行的所有容器配置CPU和内存配额。配额可以通过 [ResourceQuota](https://k8smeetup.github.io/docs/api-reference/v1.7/#resourcequota-v1-core)对象设置。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

请确保您集群中的每个节点（node）拥有至少1GiB内存。

## 创建名字空间

创建一个单独的名字空间，以便于隔离您在本练习中创建的资源与集群的其他资源。

```
kubectl create namespace quota-mem-cpu-example
```

## 创建ResourceQuota对象

以下展示了ResourceQuota对象的配置文件内容：

| [quota-mem-cpu.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/quota-mem-cpu.yaml)![Copy quota-mem-cpu.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: ResourceQuota metadata:  name: mem-cpu-demo spec:  hard:    requests.cpu: "1"    requests.memory: 1Gi    limits.cpu: "2"    limits.memory: 2Gi ` |

下面，首先创建ResourceQuota对象

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/quota-mem-cpu.yaml --namespace=quota-mem-cpu-example
```

然后可以通过以下命令查看ResourceQuota对象的详细信息：

```
kubectl get resourcequota mem-cpu-demo --namespace=quota-mem-cpu-example --output=yaml
```

以上刚创建的ResourceQuota对象将在quota-mem-cpu-example名字空间中添加以下限制：

- 每个容器必须设置内存请求（memory request），内存限额（memory limit），cpu请求（cpu request）和cpu限额（cpu limit）。
- 所有容器的内存请求总额不得超过1 GiB。
- 所有容器的内存限额总额不得超过2 GiB。
- 所有容器的CPU请求总额不得超过1 CPU。
- 所有容器的CPU限额总额不得超过2 CPU。

## 创建一个Pod

以下展示了一个Pod的配置文件内容：

| [quota-mem-cpu-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/quota-mem-cpu-pod.yaml)![Copy quota-mem-cpu-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: quota-mem-cpu-demo spec:  containers:  - name: quota-mem-cpu-demo-ctr    image: nginx    resources:      limits:        memory: "800Mi"        cpu: "800m"       requests:        memory: "600Mi"        cpu: "400m" ` |

通过以下命令创建这个Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/quota-mem-cpu-pod.yaml --namespace=quota-mem-cpu-example
```

运行以下命令验证这个Pod的容器已经运行：

```
kubectl get pod quota-mem-cpu-demo --namespace=quota-mem-cpu-example
```

然后再次查看ResourceQuota对象的详细信息：

```
kubectl get resourcequota mem-cpu-demo --namespace=quota-mem-cpu-example --output=yaml
```

除了配额本身信息外，上述命令还显示了目前配额中有多少已经被使用。可以看到，刚才创建的Pod的内存以及 CPU的请求和限额并没有超出配额。

```
status:
  hard:
    limits.cpu: "2"
    limits.memory: 2Gi
    requests.cpu: "1"
    requests.memory: 1Gi
  used:
    limits.cpu: 800m
    limits.memory: 800Mi
    requests.cpu: 400m
    requests.memory: 600Mi
```

## 尝试创建第二个Pod

第二个Pod的配置文件如下所示：

| [quota-mem-cpu-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/quota-mem-cpu-pod-2.yaml)![Copy quota-mem-cpu-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: quota-mem-cpu-demo-2 spec:  containers:  - name: quota-mem-cpu-demo-2-ctr    image: redis    resources:      limits:        memory: "1Gi"        cpu: "800m"            requests:        memory: "700Mi"        cpu: "400m" ` |

在配置文件中，您可以看到第二个Pod的内存请求是700 MiB。可以注意到，如果创建第二个Pod, 目前的内存使用量加上新的内存请求已经超出了当前名字空间的内存请求配额。即600 MiB + 700 MiB > 1 GiB。

下面尝试创建第二个Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/quota-mem-cpu-pod-2.yaml --namespace=quota-mem-cpu-example
```

以下命令输出显示第二个Pod并没有创建成功。错误信息说明了如果创建第二个Pod，内存请求总额将超出名字空间的内存请求配额。

```
Error from server (Forbidden): error when creating "docs/tasks/administer-cluster/quota-mem-cpu-pod-2.yaml":
pods "quota-mem-cpu-demo-2" is forbidden: exceeded quota: mem-cpu-demo,
requested: requests.memory=700Mi,used: requests.memory=600Mi, limited: requests.memory=1Gi
```

## 讨论

在本练习中您已经看到，使用ResourceQuota可以限制一个名字空间中所运行的所有容器的内存请求总额。 当然，也可以通过ResourceQuota限制所有容器的内存限额、CPU请求以及CPU限额。

如果您仅仅想限制单个容器的上述各项指标，而非名字空间中所有容器的，请使用[LimitRange](https://k8smeetup.github.io/docs/tasks/administer-cluster/memory-constraint-namespace/)。

## 练习环境的清理

通过删除名字空间即可完成环境清理：

```
kubectl delete namespace quota-mem-cpu-example
```

# Kubernetes 为 Namespace 配置最小和最大 CPU 限制

- [1 Before you begin](http://docs.kubernetes.org.cn/770.html#Before_you_begin)
- [2 创建一个 namespace](http://docs.kubernetes.org.cn/770.html#_namespace)
- [3 创建一个 LimitRange 和一个 Pod](http://docs.kubernetes.org.cn/770.html#_LimitRange_Pod)
- [4 尝试创建一个超过最大 CPU 限制的 Pod](http://docs.kubernetes.org.cn/770.html#_CPU_Pod)
- [5 尝试创建一个不符合最小 CPU 请求的 Pod](http://docs.kubernetes.org.cn/770.html#_CPU_Pod-2)
- [6 创建一个没有指定任何 CPU 请求和限制的 Pod](http://docs.kubernetes.org.cn/770.html#_CPU_Pod-3)
- [7 应用最小和最大 CPU 限制](http://docs.kubernetes.org.cn/770.html#_CPU)
- [8 最小和最大 CPU 限制的动因](http://docs.kubernetes.org.cn/770.html#_CPU-2)
- [9 清理](http://docs.kubernetes.org.cn/770.html#i)
- 10 What’s next
  - [10.1 对于集群管理员](http://docs.kubernetes.org.cn/770.html#i-2)
  - [10.2 对于应用开发者](http://docs.kubernetes.org.cn/770.html#i-3)

本文展示了如何设置 namespace 中容器和 Pod 使用的 CPU 资源的最小和最大值。您可以设置 [LimitRange](https://k8smeetup.github.io/docs/api-reference/v1.8/#limitrange-v1-core) 对象中 CPU 的最小和最大值。如果 Pod 没有符合 LimitRange 施加的限制，那么它就不能在 namespace 中创建。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](http://docs.kubernetes.org.cn/94.html).

集群中的每个节点至少需要 1 CPU。

## 创建一个 namespace

请创建一个 [namespace](http://docs.kubernetes.org.cn/242.html)，这样您在本练习中创建的资源就可以和集群中其余资源相互隔离。

```
kubectl create namespace constraints-cpu-example
```

## 创建一个 LimitRange 和一个 Pod

这是 LimitRange 的配置文件：

| [cpu-constraints.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-constraints.yaml)![Copy cpu-constraints.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: LimitRange metadata:  name: cpu-min-max-demo-lr spec:  limits:  - max:      cpu: "800m"    min:      cpu: "200m"    type: Container ` |

创建 LimitRange:

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-constraints.yaml --namespace=constraints-cpu-example
```

查看 LimitRange 的详细信息：

```
kubectl get limitrange cpu-min-max-demo-lr --output=yaml --namespace=constraints-cpu-example
```

输出显示了符合预期的最小和最大 CPU 限制。但请注意，即使您没有在配置文件中为 LimitRange 指定默认值，它们也会被自动创建。

```
limits:
- default:
    cpu: 800m
  defaultRequest:
    cpu: 800m
  max:
    cpu: 800m
  min:
    cpu: 200m
  type: Container
```

现在，每当在 constraints-cpu-example namespace 中创建一个容器时，Kubernetes 都会执行下列步骤：

- 如果容器没有指定自己的 CPU 请求（CPU request）和限制（CPU limit），系统将会为其分配默认值。
- 验证容器的 CPU 请求大于等于 200 millicpu。
- 验证容器的 CPU 限制小于等于 800 millicpu。

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 500 millicpu 的 CPU 请求和 800 millicpu 的 CPU 限制。这些配置符合 LimitRange 施加的最小和最大 CPU 限制。

| [cpu-constraints-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-constraints-pod.yaml)![Copy cpu-constraints-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-cpu-demo spec:  containers:  - name: constraints-cpu-demo-ctr    image: nginx    resources:      limits:        cpu: "800m"      requests:        cpu: "500m" ` |

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-constraints-pod.yaml --namespace=constraints-cpu-example
```

验证 Pod 的容器是否运行正常：

```
kubectl get pod constraints-cpu-demo --namespace=constraints-cpu-example
```

查看关于 Pod 的详细信息：

```
kubectl get pod constraints-cpu-demo --output=yaml --namespace=constraints-cpu-example
```

输出显示了容器的 CPU 请求为 500 millicpu，CPU 限制为 800 millicpu。这符合 LimitRange 施加的限制条件。

```
resources:
  limits:
    cpu: 800m
  requests:
    cpu: 500m
```

删除 Pod：

```
kubectl delete pod constraints-cpu-demo --namespace=constraints-cpu-example
```

## 尝试创建一个超过最大 CPU 限制的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 500 millicpu 的 CPU 请求和 1.5 cpu 的 CPU 限制。

| [cpu-constraints-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-constraints-pod-2.yaml)![Copy cpu-constraints-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-cpu-demo-2 spec:  containers:  - name: constraints-cpu-demo-2-ctr    image: nginx    resources:      limits:        cpu: "1.5"      requests:        cpu: "500m" ` |

尝试创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-constraints-pod-2.yaml --namespace=constraints-cpu-example
```

输出显示 Pod 没有能够成功创建，因为容器指定的 CPU 限制值太大：

```
Error from server (Forbidden): error when creating "docs/tasks/administer-cluster/cpu-constraints-pod-2.yaml":
pods "constraints-cpu-demo-2" is forbidden: maximum cpu usage per Container is 800m, but limit is 1500m.
```

## 尝试创建一个不符合最小 CPU 请求的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器的配置清单指定了 100 millicpu 的 CPU 请求和 800 millicpu 的 CPU 限制。

| [cpu-constraints-pod-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-constraints-pod-3.yaml)![Copy cpu-constraints-pod-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-cpu-demo-4 spec:  containers:  - name: constraints-cpu-demo-4-ctr    image: nginx    resources:      limits:        cpu: "800m"      requests:        cpu: "100m" ` |

尝试创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-constraints-pod-3.yaml --namespace=constraints-cpu-example
```

输出显示 Pod 没有能够成功创建，因为容器指定的 CPU 请求值太小：

```
Error from server (Forbidden): error when creating "docs/tasks/administer-cluster/cpu-constraints-pod-3.yaml":
pods "constraints-cpu-demo-4" is forbidden: minimum cpu usage per Container is 200m, but request is 100m.
```

## 创建一个没有指定任何 CPU 请求和限制的 Pod

这是一份包含一个容器的 Pod 的配置文件。这个容器没有指定 CPU 请求，也没有指定 CPU 限制。

| [cpu-constraints-pod-4.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/administer-cluster/cpu-constraints-pod-4.yaml)![Copy cpu-constraints-pod-4.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: constraints-cpu-demo-4 spec:  containers:  - name: constraints-cpu-demo-4-ctr    image: vish/stress ` |

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/administer-cluster/cpu-constraints-pod-4.yaml --namespace=constraints-cpu-example
```

查看关于 Pod 的详细信息：

```
kubectl get pod constraints-cpu-demo-4 --namespace=constraints-cpu-example --output=yaml
```

输出显示 Pod 的容器具有 800 millicpu 的 CPU 请求和 800 millicpu 的 CPU 限制。容器是如何获取这些值的呢？

```
resources:
  limits:
    cpu: 800m
  requests:
    cpu: 800m
```

因为您的容器没有指定自己的 CPU 请求和限制，所以它将从 LimitRange 获取 [默认的 CPU 请求和限制值](http://docs.kubernetes.org.cn/747.html)。

到目前为止，您的容器可能在运行，也可能没有运行。回想起来，有一个先决条件就是节点必须至少拥有 1 CPU。如果每个节点都只有 1  CPU，那么任何一个节点上都没有足够的可用 CPU 来容纳 800 millicpu 的请求。如果碰巧使用的节点拥有 2  CPU，那么它可能会有足够的 CPU 来容纳 800 millicpu 的请求。

删除 Pod：

```
kubectl delete pod constraints-cpu-demo-4 --namespace=constraints-cpu-example
```

## 应用最小和最大 CPU 限制

LimitRange 在 namespace 中施加的最小和最大 CPU 限制只有在创建和更新 Pod 时才会被应用。改变 LimitRange 不会对之前创建的 Pod 造成影响。

## 最小和最大 CPU 限制的动因

作为一个集群管理员，您可能希望对 Pod 能够使用的 CPU 资源数量施加限制。例如：

- 集群中每个节点拥有 2 CPU。您不希望任何 Pod 请求超过 2 CPU 的资源，因为集群中没有节点能支持这个请求。
- 集群被生产部门和开发部门共享。 您希望生产负载最多使用 3 CPU 而将开发负载限制为 1 CPU。这种情况下，您可以为生产环境和开发环境创建单独的 namespace，并对每个 namespace 应用 CPU 限制。

## 清理

删除 namespace：

```
kubectl delete namespace constraints-cpu-example
```

# Kubernetes Labels 和 Selectors

- [1 Motivation](http://docs.kubernetes.org.cn/247.html#Motivation)
- [2 语法和字符集](http://docs.kubernetes.org.cn/247.html#i)
- 3 Labels选择器
  - [3.1 Equality-based requirement 基于相等的要求](http://docs.kubernetes.org.cn/247.html#Equality-basedrequirement)
  - [3.2 Set-based requirement](http://docs.kubernetes.org.cn/247.html#Set-basedrequirement)
- 4 API
  - [4.1 LIST和WATCH过滤](http://docs.kubernetes.org.cn/247.html#LISTWATCH)
  - 4.2 API对象中引用
    - [4.2.1 Service和ReplicationController](http://docs.kubernetes.org.cn/247.html#ServiceReplicationController)
    - [4.2.2 支持set-based要求的资源](http://docs.kubernetes.org.cn/247.html#set-based)
    - [4.2.3 Selecting sets of nodes](http://docs.kubernetes.org.cn/247.html#Selecting_sets_of_nodes)

Labels其实就一对 key/value  ，被关联到对象上，标签的使用我们倾向于能够标示对象的特殊特点，并且对用户而言是有意义的（就是一眼就看出了这个Pod是尼玛数据库），但是标签对内核系统是没有直接意义的。标签可以用来划分特定组的对象（比如，所有女的），标签可以在创建一个对象的时候直接给与，也可以在后期随时修改，每一个对象可以拥有多个标签，但是，key值必须是唯一的

```
"labels": {
  "key1" : "value1",
  "key2" : "value2"
}
```

我们最终会索引并且反向索引（reverse-index）labels，以获得更高效的查询和监视，把他们用到UI或者CLI中用来排序或者分组等等。我们不想用那些不具有指认效果的label来污染label，特别是那些体积较大和结构型的的数据。不具有指认效果的信息应该使用annotation来记录。

## Motivation

Labels可以让用户将他们自己的有组织目的的结构以一种松耦合的方式应用到系统的对象上，且不需要客户端存放这些对应关系（mappings）。

服务部署和批处理管道通常是多维的实体（例如多个分区或者部署，多个发布轨道，多层，每层多微服务）。管理通常需要跨越式的切割操作，这会打破有严格层级展示关系的封装，特别对那些是由基础设施而非用户决定的很死板的层级关系。

示例标签：

- "release" : "stable"， "release" : "canary"
- "environment" : "dev"，"environment" : "qa"，"environment" : "production"
- "tier" : "frontend"，"tier" : "backend"，"tier" : "cache"
- "partition" : "customerA"， "partition" : "customerB"
- "track" : "daily"， "track" : "weekly"

这些只是常用Labels的例子，你可以按自己习惯来定义，需要注意，每个对象的标签key具有唯一性。

## 语法和字符集

Label其实是一对  key/value。有效的标签键有两个段：可选的前缀和名称，用斜杠（/）分隔，名称段是必需的，最多63个字符，以[a-z0-9A-Z]带有虚线（-）、下划线（_）、点（.）和开头和结尾必须是字母或数字（都是字符串形式）的形式组成。前缀是可选的。如果指定了前缀，那么必须是DNS子域：一系列的DNSlabel通过”.”来划分，不超过253个字符，以斜杠（/）结尾。如果前缀被省略了，这个Label的key被假定为对用户私有的。自动化系统组件有（例如kube-scheduler，kube-controller-manager，kube-apiserver，kubectl，或其他第三方自动化），这些添加标签终端用户对象都必须指定一个前缀。Kuberentes.io 前缀是为Kubernetes 内核部分保留的。

有效的标签值最长为63个字符。要么为空，要么使用[a-z0-9A-Z]带有虚线（-）、下划线（_）、点（.）和开头和结尾必须是字母或数字（都是字符串形式）的形式组成。

## Labels选择器

与[Name和UID](http://docs.kubernetes.org.cn/235.html) 不同，标签不需要有唯一性。一般来说，我们期望许多对象具有相同的标签。

通过标签选择器（Labels Selectors），客户端/用户 能方便辨识出一组对象。标签选择器是kubernetes中核心的组成部分。

API目前支持两种选择器：equality-based（基于平等）和set-based（基于集合）的。标签选择器可以由逗号分隔的多个requirements 组成。在多重需求的情况下，必须满足所有要求，因此逗号分隔符作为AND逻辑运算符。

一个为空的标签选择器（即有0个必须条件的选择器）会选择集合中的每一个对象。

一个null型标签选择器（仅对于可选的选择器字段才可能）不会返回任何对象。

注意：两个控制器的标签选择器不能在命名空间中重叠。

### Equality-based requirement 基于相等的要求

基于相等的或者不相等的条件允许用标签的keys和values进行过滤。匹配的对象必须满足所有指定的标签约束，尽管他们可能也有额外的标签。有三种运算符是允许的，“=”，“==”和“!=”。前两种代表相等性（他们是同义运算符），后一种代表非相等性。例如：

```
environment = production
tier != frontend
```

第一个选择所有key等于 environment 值为 production 的资源。后一种选择所有key为 tier 值不等于  frontend 的资源，和那些没有key为 tier 的label的资源。要过滤所有处于 production 但不是 frontend  的资源，可以使用逗号操作符，

```
frontend：environment=production,tier!=frontend
```

### Set-based requirement

Set-based 的标签条件允许用一组value来过滤key。支持三种操作符: in ， notin 和 exists(仅针对于key符号) 。例如：

```
environment in (production, qa)
tier notin (frontend, backend)
partition
!partition
```

第一个例子，选择所有key等于 environment ，且value等于 production 或者 qa 的资源。  第二个例子，选择所有key等于 tier 且值是除了 frontend 和 backend 之外的资源，和那些没有标签的key是 tier  的资源。 第三个例子，选择所有有一个标签的key为partition的资源；value是什么不会被检查。  第四个例子，选择所有的没有lable的key名为 partition 的资源；value是什么不会被检查。

类似的，逗号操作符相当于一个AND操作符。因而要使用一个 partition 键（不管value是什么），并且 environment 不是 qa 过滤资源可以用 partition,environment notin (qa) 。

Set-based 的选择器是一个相等性的宽泛的形式，因为 environment=production 相当于environment in (production) ，与 != and notin 类似。

Set-based的条件可以与Equality-based的条件结合。例如， partition in (customerA,customerB),environment!=qa 。

## API

### LIST和WATCH过滤

LIST和WATCH操作可以指定标签选择器来过滤使用查询参数返回的对象集。这两个要求都是允许的（在这里给出，它们会出现在URL查询字符串中）：

LIST和WATCH操作，可以使用query参数来指定label选择器来过滤返回对象的集合。两种条件都可以使用：

- Set-based的要求：?labelSelector=environment%3Dproduction,tier%3Dfrontend
- Equality-based的要求：?labelSelector=environment+in+%28production%2Cqa%29%2Ctier+in+%28frontend%29

两个标签选择器样式都可用于通过REST客户端列出或观看资源。例如，apiserver使用kubectl和使用基于平等的人可以写：

两种标签选择器样式，都可以通过REST客户端来list或watch资源。比如使用 kubectl 来针对 apiserver ，并且使用Equality-based的条件，可以用：

```
$ kubectl get pods -l environment=production,tier=frontend
```

或使用Set-based 要求：

```
$ kubectl get pods -l 'environment in (production),tier in (frontend)'
```

如已经提到的Set-based要求更具表现力。例如，它们可以对value执行OR运算：

```
$ kubectl get pods -l 'environment in (production, qa)'
```

或者通过exists操作符进行否定限制匹配：

```
$ kubectl get pods -l 'environment,environment notin (frontend)'
```

### API对象中引用

一些Kubernetes对象，例如[services](https://kubernetes.io/docs/user-guide/services)和[replicationcontrollers](https://kubernetes.io/docs/user-guide/replication-controller)，也使用标签选择器来指定其他资源的集合，如[pod](https://kubernetes.io/docs/user-guide/pods)。

#### Service和ReplicationController

一个service针对的pods的集合是用标签选择器来定义的。类似的，一个replicationcontroller管理的pods的群体也是用标签选择器来定义的。

对于这两种对象的Label选择器是用map定义在json或者yaml文件中的，并且只支持Equality-based的条件：

```
"selector": {
    "component" : "redis",
}
```

要么

```
selector:
    component: redis
```

此选择器（分别为json或yaml格式）等同于component=redis或component in (redis)。

#### 支持set-based要求的资源

Job，[Deployment](http://docs.kubernetes.org.cn/317.html)，[Replica Set](http://docs.kubernetes.org.cn/314.html)，和Daemon Set，支持set-based要求。

```
selector:
  matchLabels:
    component: redis
  matchExpressions:
    - {key: tier, operator: In, values: [cache]}
    - {key: environment, operator: NotIn, values: [dev]}
```

matchLabels 是一个{key,value}的映射。一个单独的 {key,value} 相当于 matchExpressions  的一个元素，它的key字段是”key”,操作符是 In ，并且value数组value包含”value”。 matchExpressions  是一个pod的选择器条件的list 。有效运算符包含In, NotIn, Exists,  和DoesNotExist。在In和NotIn的情况下，value的组必须不能为空。所有的条件，包含 matchLabels  andmatchExpressions 中的，会用AND符号连接，他们必须都被满足以完成匹配。

# Kubernetes Volume

- [1 背景](http://docs.kubernetes.org.cn/429.html#i)
- 2 Volume 类型
  - [2.1 emptyDir](http://docs.kubernetes.org.cn/429.html#emptyDir)
  - [2.2 hostPath](http://docs.kubernetes.org.cn/429.html#hostPath)
  - [2.3 gcePersistentDisk](http://docs.kubernetes.org.cn/429.html#gcePersistentDisk)
  - [2.4 awsElasticBlockStore](http://docs.kubernetes.org.cn/429.html#awsElasticBlockStore)
  - [2.5 NFS](http://docs.kubernetes.org.cn/429.html#NFS)
  - [2.6 iSCSI](http://docs.kubernetes.org.cn/429.html#iSCSI)
  - [2.7 flocker](http://docs.kubernetes.org.cn/429.html#flocker)
  - [2.8 glusterfs](http://docs.kubernetes.org.cn/429.html#glusterfs)
  - [2.9 RBD](http://docs.kubernetes.org.cn/429.html#RBD)
  - [2.10 cephfs](http://docs.kubernetes.org.cn/429.html#cephfs)
  - [2.11 gitRepo](http://docs.kubernetes.org.cn/429.html#gitRepo)
  - [2.12 secret](http://docs.kubernetes.org.cn/429.html#secret)
  - [2.13 persistentVolumeClaim](http://docs.kubernetes.org.cn/429.html#persistentVolumeClaim)
  - [2.14 downwardAPI](http://docs.kubernetes.org.cn/429.html#downwardAPI)
  - [2.15 projected](http://docs.kubernetes.org.cn/429.html#projected)
  - [2.16 FlexVolume](http://docs.kubernetes.org.cn/429.html#FlexVolume)
  - [2.17 AzureFileVolume](http://docs.kubernetes.org.cn/429.html#AzureFileVolume)
  - [2.18 AzureDiskVolume](http://docs.kubernetes.org.cn/429.html#AzureDiskVolume)
  - 2.19 vsphereVolume
    - [2.19.1 创建一个VMDK卷](http://docs.kubernetes.org.cn/429.html#VMDK)
  - [2.20 Quobyte](http://docs.kubernetes.org.cn/429.html#Quobyte)
  - [2.21 PortworxVolume](http://docs.kubernetes.org.cn/429.html#PortworxVolume)
  - [2.22 ScaleIO](http://docs.kubernetes.org.cn/429.html#ScaleIO)
  - [2.23 StorageOS](http://docs.kubernetes.org.cn/429.html#StorageOS)
  - [2.24 Local](http://docs.kubernetes.org.cn/429.html#Local)
- [3 Using subPath](http://docs.kubernetes.org.cn/429.html#Using_subPath)
- [4 Resources](http://docs.kubernetes.org.cn/429.html#Resources)

默认情况下容器中的磁盘文件是非持久化的，对于运行在容器中的应用来说面临两个问题，第一：当容器挂掉kubelet将重启启动它时，文件将会丢失；第二：当[Pod](http://docs.kubernetes.org.cn/312.html)中同时运行多个容器，容器之间需要共享文件时。Kubernetes的Volume解决了这两个问题。

*建议熟悉[Pod](http://docs.kubernetes.org.cn/312.html)。*

## 背景

在Docker中也有一个[docker Volume](https://docs.docker.com/userguide/dockervolumes/)的概念 ，Docker的Volume只是磁盘中的一个目录，生命周期不受管理。当然Docker现在也提供Volume将数据持久化存储，但支持功能比较少（例如，对于Docker 1.7，每个容器只允许挂载一个Volume，并且不能将参数传递给Volume）。

另一方面，Kubernetes Volume具有明确的生命周期 -  与pod相同。因此，Volume的生命周期比Pod中运行的任何容器要持久，在容器重新启动时能可以保留数据，当然，当Pod被删除不存在时，Volume也将消失。注意，Kubernetes支持许多类型的Volume，Pod可以同时使用任意类型/数量的Volume。

内部实现中，一个Volume只是一个目录，目录中可能有一些数据，pod的容器可以访问这些数据。至于这个目录是如何产生的、支持它的介质、其中的数据内容是什么，这些都由使用的特定Volume类型来决定。

要使用Volume，pod需要指定Volume的类型和内容（`spec.volumes`字段），和映射到容器的位置（`spec.containers.volumeMounts`字段）。

## Volume 类型

Kubernetes支持Volume类型有：

- emptyDir
- hostPath
- gcePersistentDisk
- awsElasticBlockStore
- nfs
- iscsi
- fc (fibre channel)
- flocker
- glusterfs
- rbd
- cephfs
- gitRepo
- secret
- persistentVolumeClaim
- downwardAPI
- projected
- azureFileVolume
- azureDisk
- vsphereVolume
- Quobyte
- PortworxVolume
- ScaleIO
- StorageOS
- local

### emptyDir

使用emptyDir，当Pod分配到[Node](http://docs.kubernetes.org.cn/304.html)上时，将会创建emptyDir，并且只要Node上的Pod一直运行，Volume就会一直存。当Pod（不管任何原因）从Node上被删除时，emptyDir也同时会删除，存储的数据也将永久删除。注：删除容器不影响emptyDir。

示例：

```
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}
```

### hostPath

hostPath允许挂载Node上的文件系统到Pod里面去。如果Pod需要使用Node上的文件，可以使用hostPath。

示例

```
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-pd
      name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      # directory location on host
      path: /data
```

### gcePersistentDisk

gcePersistentDisk可以挂载GCE上的永久磁盘到容器，需要Kubernetes运行在GCE的VM中。与emptyDir不同，Pod删除时，gcePersistentDisk被删除，但[Persistent Disk](http://cloud.google.com/compute/docs/disks) 的内容任然存在。这就意味着gcePersistentDisk能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

**提示：使用gcePersistentDisk，必须用gcloud或使用GCE API或UI 创建PD**

创建PD

使用GCE PD与pod之前，需要创建它

```
gcloud compute disks create --size=500GB --zone=us-central1-a my-data-disk
```

示例

```
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-pd
      name: test-volume
  volumes:
  - name: test-volume
    # This GCE PD must already exist.
    gcePersistentDisk:
      pdName: my-data-disk
      fsType: ext4
```

### awsElasticBlockStore

awsElasticBlockStore可以挂载AWS上的EBS盘到容器，需要Kubernetes运行在AWS的EC2上。与emptyDir  Pod被删除情况不同，Volume仅被卸载，内容将被保留。这就意味着awsElasticBlockStore能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

提示：必须使用aws ec2 create-volumeAWS API 创建EBS Volume，然后才能使用。

**创建EBS Volume**

在使用EBS Volume与pod之前，需要创建它。

```
aws ec2 create-volume --availability-zone eu-west-1a --size 10 --volume-type gp2
```

AWS EBS配置示例

```
apiVersion: v1
kind: Pod
metadata:
  name: test-ebs
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-ebs
      name: test-volume
  volumes:
  - name: test-volume
    # This AWS EBS volume must already exist.
    awsElasticBlockStore:
      volumeID: <volume-id>
      fsType: ext4
```

### NFS

NFS 是Network File  System的缩写，即网络文件系统。Kubernetes中通过简单地配置就可以挂载NFS到Pod中，而NFS中的数据是可以永久保存的，同时NFS支持同时写操作。Pod被删除时，Volume被卸载，内容被保留。这就意味着NFS能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间相互传递。

详细信息，请参阅[NFS示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/nfs)。

### iSCSI

iscsi允许将现有的iscsi磁盘挂载到我们的pod中，和emptyDir不同的是，删除Pod时会被删除，但Volume只是被卸载，内容被保留，这就意味着iscsi能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

详细信息，请参阅[iSCSI示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/iscsi)。

### 

### flocker

[Flocker](https://clusterhq.com/flocker)是一个开源的容器集群数据卷管理器。它提供各种存储后端支持的数据卷的管理和编排。

详细信息，请参阅[Flocker示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/flocker)。

### glusterfs

glusterfs，允许将[Glusterfs](http://www.gluster.org/)（一个开源网络文件系统）Volume安装到pod中。不同于emptyDir，Pod被删除时，Volume只是被卸载，内容被保留。味着glusterfs能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

详细信息，请参阅[GlusterFS示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/glusterfs)。

### RBD

RBD允许Rados Block Device格式的磁盘挂载到Pod中，同样的，当pod被删除的时候，rbd也仅仅是被卸载，内容保留，rbd能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

详细信息，请参阅[RBD示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/rbd)。

### cephfs

cephfs Volume可以将已经存在的CephFS Volume挂载到pod中，与emptyDir特点不同，pod被删除的时，cephfs仅被被卸载，内容保留。cephfs能够允许我们提前对数据进行处理，而且这些数据可以在Pod之间“切换”。

提示：可以使用自己的Ceph服务器运行导出，然后在使用cephfs。

详细信息，请参阅[CephFS示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/cephfs/)。

### gitRepo

gitRepo volume将git代码下拉到指定的容器路径中。

示例：

```
apiVersion: v1
kind: Pod
metadata:
  name: server
spec:
  containers:
  - image: nginx
    name: nginx
    volumeMounts:
    - mountPath: /mypath
      name: git-volume
  volumes:
  - name: git-volume
    gitRepo:
      repository: "git@somewhere:me/my-git-repository.git"
      revision: "22f1d8406d464b0c0874075539c1f2e96c253775"
```

### secret

secret volume用于将敏感信息（如密码）传递给pod。可以将secrets存储在Kubernetes API中，使用的时候以文件的形式挂载到pod中，而不用连接api。 secret volume由tmpfs（RAM支持的文件系统）支持。

详细了解[secret](https://kubernetes.io/docs/user-guide/secrets)

### persistentVolumeClaim

persistentVolumeClaim用来挂载持久化磁盘的。PersistentVolumes是用户在不知道特定云环境的细节的情况下，实现持久化存储（如GCE PersistentDisk或iSCSI卷）的一种方式。

更多详细信息，请参阅[PersistentVolumes示例](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)。

### downwardAPI

通过环境变量的方式告诉容器Pod的信息

更多详细信息，请参见[downwardAPI卷示例](https://kubernetes.io/docs/tasks/configure-pod-container/downward-api-volume-expose-pod-information/)。

### projected

Projected volume将多个Volume源映射到同一个目录

目前，可以支持以下类型的卷源：

- secret
- downwardAPI
- configMap

所有卷源都要求与pod在同一命名空间中。更详细信息，请参阅[all-in-one volume design document](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/all-in-one-volume.md)。

示例

```
apiVersion: v1
kind: Pod
metadata:
  name: volume-test
spec:
  containers:
  - name: container-test
    image: busybox
    volumeMounts:
    - name: all-in-one
      mountPath: "/projected-volume"
      readOnly: true
  volumes:
  - name: all-in-one
    projected:
      sources:
      - secret:
          name: mysecret
          items:
            - key: username
              path: my-group/my-username
      - downwardAPI:
          items:
            - path: "labels"
              fieldRef:
                fieldPath: metadata.labels
            - path: "cpu_limit"
              resourceFieldRef:
                containerName: container-test
                resource: limits.cpu
      - configMap:
          name: myconfigmap
          items:
            - key: config
              path: my-group/my-config
apiVersion: v1
kind: Pod
metadata:
  name: volume-test
spec:
  containers:
  - name: container-test
    image: busybox
    volumeMounts:
    - name: all-in-one
      mountPath: "/projected-volume"
      readOnly: true
  volumes:
  - name: all-in-one
    projected:
      sources:
      - secret:
          name: mysecret
          items:
            - key: username
              path: my-group/my-username
      - secret:
          name: mysecret2
          items:
            - key: password
              path: my-group/my-password
              mode: 511
```

### FlexVolume

alpha功能

更多细节在[这里](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/flexvolume/README.md)

### AzureFileVolume

AzureFileVolume用于将Microsoft Azure文件卷（SMB 2.1和3.0）挂载到Pod中。

更多细节在[这里](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/azure_file/README.md)

### AzureDiskVolume

Azure是微软提供的公有云服务，如果使用Azure上面的虚拟机来作为Kubernetes集群使用时，那么可以通过AzureDisk这种类型的卷插件来挂载Azure提供的数据磁盘。

更多细节在[这里](https://www.kubernetes.org.cn/198.html)

### vsphereVolume

需要条件：配置了vSphere Cloud Provider的Kubernetes。有关cloudprovider配置，请参阅[vSphere入门指南](https://kubernetes.io/docs/getting-started-guides/vsphere/)。

vsphereVolume用于将vSphere VMDK Volume挂载到Pod中。卸载卷后，内容将被保留。它同时支持VMFS和VSAN数据存储。

重要提示：使用POD之前，必须使用以下方法创建VMDK。

#### 创建一个VMDK卷

- 使用vmkfstools创建。先将ssh接入ESX，然后使用以下命令创建vmdk

```
vmkfstools -c 2G /vmfs/volumes/DatastoreName/volumes/myDisk.vmdk
```

- 使用vmware-vdiskmanager创建

```
shell vmware-vdiskmanager -c -t 0 -s 40GB -a lsilogic myDisk.vmdk
```

示例

```
apiVersion: v1
kind: Pod
metadata:
  name: test-vmdk
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-vmdk
      name: test-volume
  volumes:
  - name: test-volume
    # This VMDK volume must already exist.
    vsphereVolume:
      volumePath: "[DatastoreName] volumes/myDisk"
      fsType: ext4
```

更多例子在[这里](https://git.k8s.io/kubernetes/examples/volumes/vsphere)。

### Quobyte

在kubernetes中使用Quobyte存储，需要提前部署Quobyte软件，要求必须是1.3以及更高版本，并且在kubernetes管理的节点上面部署Quobyte客户端。

详细信息，请参阅[这里](https://www.kubernetes.org.cn/198.html)。

### PortworxVolume

Portworx能把你的服务器容量进行蓄积（pool），将你的服务器或者云实例变成一个聚合的高可用的计算和存储节点。

PortworxVolume可以通过Kubernetes动态创建，也可以在Kubernetes pod中预先配置和引用。示例：

```
apiVersion: v1
kind: Pod
metadata:
  name: test-portworx-volume-pod
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /mnt
      name: pxvol
  volumes:
  - name: pxvol
    # This Portworx volume must already exist.
    portworxVolume:
      volumeID: "pxvol"
      fsType: "<fs-type>"
```

更多细节和例子可以在[这里](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/portworx/README.md)找到

### ScaleIO

ScaleIO是一种基于软件的存储平台（虚拟SAN），可以使用现有硬件来创建可扩展共享块网络存储的集群。ScaleIO卷插件允许部署的pod访问现有的ScaleIO卷（或者可以为持久卷声明动态配置新卷，请参阅 [Scaleio Persistent Volumes](https://kubernetes.io/docs/user-guide/persistent-volumes/#scaleio)）。

示例：

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-0
spec:
  containers:
  - image: gcr.io/google_containers/test-webserver
    name: pod-0
    volumeMounts:
    - mountPath: /test-pd
      name: vol-0
  volumes:
  - name: vol-0
    scaleIO:
      gateway: https://localhost:443/api
      system: scaleio
      volumeName: vol-0
      secretRef:
        name: sio-secret
      fsType: xfs
```

详细信息，请参阅[ScaleIO示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/scaleio)。

### StorageOS

StorageOS是一家英国的初创公司，给无状态容器提供简单的自动块存储、状态来运行数据库和其他需要企业级存储功能，但避免随之而来的复杂性、刚性以及成本。

核心：是StorageOS向容器提供块存储，可通过文件系统访问。

StorageOS容器需要64位Linux，没有额外的依赖关系，提供免费开发许可证。

安装说明，请参阅[StorageOS文档](https://docs.storageos.com/)

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: redis
    role: master
  name: test-storageos-redis
spec:
  containers:
    - name: master
      image: kubernetes/redis:v1
      env:
        - name: MASTER
          value: "true"
      ports:
        - containerPort: 6379
      volumeMounts:
        - mountPath: /redis-master-data
          name: redis-data
  volumes:
    - name: redis-data
      storageos:
        # The `redis-vol01` volume must already exist within StorageOS in the `default` namespace.
        volumeName: redis-vol01
        fsType: ext4
```

有关动态配置和持久卷声明的更多信息，请参阅[StorageOS示例](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/storageos)。

### Local

目前处于 Kubernetes 1.7中的 alpha 级别。

Local 是Kubernetes集群中每个节点的本地存储（如磁盘，分区或目录），在Kubernetes1.7中kubelet可以支持对kube-reserved和system-reserved指定本地存储资源。

通过上面的这个新特性可以看出来，Local Storage同HostPath的区别在于对Pod的调度上，使用Local  Storage可以由Kubernetes自动的对Pod进行调度，而是用HostPath只能人工手动调度Pod，因为Kubernetes已经知道了每个节点上kube-reserved和system-reserved设置的本地存储限制。

示例：

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
  annotations:
        "volume.alpha.kubernetes.io/node-affinity": '{
            "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                    { "matchExpressions": [
                        { "key": "kubernetes.io/hostname",
                          "operator": "In",
                          "values": ["example-node"]
                        }
                    ]}
                 ]}
              }'
spec:
    capacity:
      storage: 100Gi
    accessModes:
    - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    storageClassName: local-storage
    local:
      path: /mnt/disks/ssd1
```

请注意，本地PersistentVolume需要手动清理和删除。

有关local卷类型的详细信息，请参阅 [Local Persistent Storage user guide](https://github.com/kubernetes-incubator/external-storage/tree/master/local-volume)

## Using subPath

有时，可以在一个pod中，将同一个卷共享，使其有多个用处。volumeMounts.subPath特性可以用来指定卷中的一个子目录，而不是直接使用卷的根目录。

以下是使用单个共享卷的LAMP堆栈（Linux Apache Mysql PHP）的pod的示例。HTML内容映射到其html文件夹，数据库将存储在mysql文件夹中：

```
apiVersion: v1
kind: Pod
metadata:
  name: my-lamp-site
spec:
    containers:
    - name: mysql
      image: mysql
      volumeMounts:
      - mountPath: /var/lib/mysql
        name: site-data
        subPath: mysql
    - name: php
      image: php
      volumeMounts:
      - mountPath: /var/www/html
        name: site-data
        subPath: html
    volumes:
    - name: site-data
      persistentVolumeClaim:
        claimName: my-lamp-site-data
```

## Resources

emptyDir Volume的存储介质（Disk，SSD等）取决于kubelet根目录（如/var/lib/kubelet）所处文件系统的存储介质。不限制emptyDir或hostPath Volume使用的空间大小，不对容器或Pod的资源隔离。

> 参考：部分内容引用 [feisky博客](https://feisky.gitbooks.io/kubernetes/concepts/volume.html)

# Kubernetes Annotations

可以使用Kubernetes Annotations将任何非标识metadata附加到对象。客户端（如工具和库）可以检索此metadata。

## 将metadata附加到对象

可以使用[Labels](http://docs.kubernetes.org.cn/247.html)或Annotations将元数据附加到Kubernetes对象。标签可用于选择对象并查找满足某些条件的对象集合。相比之下，Annotations不用于标识和选择对象。Annotations中的元数据可以是small 或large，structured 或unstructured，并且可以包括标签不允许使用的字符。

Annotations就如标签一样，也是由key/value组成：

```
"annotations": {
  "key1" : "value1",
  "key2" : "value2"
}
```

以下是在Annotations中记录信息的一些例子：

- 构建、发布的镜像信息，如时间戳，发行ID，git分支，PR编号，镜像hashes和注Registry地址。
- 一些日志记录、监视、分析或audit repositories。
- 一些工具信息：例如，名称、版本和构建信息。
- 用户或工具/系统来源信息，例如来自其他生态系统组件对象的URL。
- 负责人电话/座机，或一些信息目录。

**注意**：Annotations不会被Kubernetes直接使用，其主要目的是方便用户阅读查找。

## 下一步是什么

了解有关[标签和选择器的](http://docs.kubernetes.org.cn/247.html)更多信息。

# Kubernetes Nodes

- [1 Node是什么？](http://docs.kubernetes.org.cn/304.html#Node)
- 2 Node Status
  - [2.1 Addresses](http://docs.kubernetes.org.cn/304.html#Addresses)
  - [2.2 Phase](http://docs.kubernetes.org.cn/304.html#Phase)
  - [2.3 Condition](http://docs.kubernetes.org.cn/304.html#Condition)
  - [2.4 Capacity](http://docs.kubernetes.org.cn/304.html#Capacity)
  - [2.5 Info](http://docs.kubernetes.org.cn/304.html#Info)
- 3 Management
  - [3.1 Node Controller](http://docs.kubernetes.org.cn/304.html#Node_Controller)
  - 3.2 Self-Registration of Nodes
    - [3.2.1 手动管理节点](http://docs.kubernetes.org.cn/304.html#i)
  - [3.3 Node容量](http://docs.kubernetes.org.cn/304.html#Node-2)
- [4 API 对象](http://docs.kubernetes.org.cn/304.html#API)

## Node是什么？

Node是Kubernetes中的工作节点，最开始被称为minion。一个Node可以是VM或物理机。每个Node（节点）具有运行[pod](http://docs.kubernetes.org.cn/312.html)的一些必要服务，并由Master组件进行管理，Node节点上的服务包括Docker、kubelet和kube-proxy。有关更多详细信息，请参考架构设计文档中的[“Kubernetes Node”](https://git.k8s.io/community/contributors/design-proposals/architecture.md#the-kubernetes-node)部分。

## Node Status

节点的状态信息包含：

- Addresses
- ~~Phase~~ (已弃用)
- Condition
- Capacity
- Info

下面详细描述每个部分。

### Addresses

这些字段的使用取决于云提供商或裸机配置。

- HostName：可以通过kubelet 中 --hostname-override参数覆盖。
- ExternalIP：可以被集群外部路由到的IP。
- InternalIP：只能在集群内进行路由的节点的IP地址。

### Phase

不推荐使用，已弃用。

### Condition

conditions字段描述所有Running节点的状态。

| Node Condition | Description                                                  |
| -------------- | ------------------------------------------------------------ |
| OutOfDisk      | True：如果节点上没有足够的可用空间来添加新的pod；否则为：False |
| Ready          | True：如果节点是健康的并准备好接收pod；False：如果节点不健康并且不接受pod；Unknown：如果节点控制器在过去40秒内没有收到node的状态报告。 |
| MemoryPressure | True：如果节点存储器上内存过低; 否则为：False。              |
| DiskPressure   | True：如果磁盘容量存在压力 - 也就是说磁盘容量低；否则为：False。 |

node condition被表示为一个JSON对象。例如，下面的响应描述了一个健康的节点。

```
"conditions": [
  {
    "kind": "Ready",
    "status": "True"
  }
]
```

如果Ready condition的Status是“Unknown” 或  “False”，比“pod-eviction-timeout”的时间长，则传递给“ kube-controller-manager”的参数，该节点上的所有Pod都将被节点控制器删除。默认的eviction  timeout时间为5分钟。在某些情况下，当节点无法访问时，apiserver将无法与kubelet通信，删除Pod的需求不会传递到kubelet，直到重新与apiserver建立通信，这种情况下，计划删除的Pod会继续在划分的节点上运行。

在Kubernetes  1.5之前的版本中，节点控制器将强制从apiserver中删除这些不可达（上述情况）的pod。但是，在1.5及更高版本中，节点控制器在确认它们已经停止在集群中运行之前，不会强制删除Pod。可以看到这些可能在不可达节点上运行的pod处于"Terminating"或  “Unknown”。如果节点永久退出集群，Kubernetes是无法从底层基础架构辨别出来，则集群管理员需要手动删除节点对象，从Kubernetes删除节点对象会导致运行在上面的所有Pod对象从apiserver中删除，最终将会释放names。

### Capacity

描述节点上可用的资源：CPU、内存和可以调度到节点上的最大pod数。

### Info

关于节点的一些基础信息，如内核版本、Kubernetes版本（kubelet和kube-proxy版本）、Docker版本（如果有使用）、OS名称等。信息由Kubelet从节点收集。

## Management

与 [pods](http://docs.kubernetes.org.cn/312.html) 和 services 不同，节点不是由Kubernetes 系统创建，它是由Google Compute  Engine等云提供商在外部创建的，或使用物理和虚拟机。这意味着当Kubernetes创建一个节点时，它只是创建一个代表节点的对象，创建后，Kubernetes将检查节点是否有效。例如，如果使用以下内容创建一个节点：

```
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "10.240.79.157",
    "labels": {
      "name": "my-first-k8s-node"
    }
  }
}
```

Kubernetes将在内部创建一个节点对象，并通过基于metadata.name字段的健康检查来验证节点，如果节点有效，即所有必需的服务会同步运行，则才能在上面运行pod。请注意，Kubernetes将保留无效节点的对象（除非客户端有明确删除它）并且它将继续检查它是否变为有效。

目前，有三个组件与Kubernetes节点接口进行交互：节点控制器（node controller）、kubelet和kubectl。

### Node Controller

节点控制器（Node Controller）是管理节点的Kubernetes master组件。

节点控制器在节点的生命周期中具有多个角色。第一个是在注册时将CIDR块分配给节点。

第二个是使节点控制器的内部列表与云提供商的可用机器列表保持最新。当在云环境中运行时，每当节点不健康时，节点控制器将询问云提供程序是否该节点的VM仍然可用，如果不可用，节点控制器会从其节点列表中删除该节点。

第三是监测节点的健康状况。当节点变为不可访问时，节点控制器负责将NodeStatus的NodeReady条件更新为ConditionUnknown，随后从节点中卸载所有pod  ，如果节点继续无法访问，（默认超时时间为40 --node-monitor-period秒，开始报告ConditionUnknown，之后为5m开始卸载）。节点控制器按每秒来检查每个节点的状态。

在Kubernetes 1.4中，我们更新了节点控制器的逻辑，以更好地处理大量节点到达主节点的一些问题（例如，主节某些网络问题）。从1.4开始，节点控制器将在决定关于pod卸载的过程中会查看集群中所有节点的状态。

在大多数情况下，节点控制器将逐出速率限制为 --node-eviction-rate（默认为0.1）/秒，这意味着它不会每10秒从多于1个节点驱逐Pod。

当给定可用性的区域中的节点变得不健康时，节点逐出行为发生变化，节点控制器同时检查区域中节点的不健康百分比（NodeReady条件为ConditionUnknown或ConditionFalse）。如果不健康节点的比例为 --unhealthy-zone-threshold（默认为0.55），那么驱逐速度就会降低：如果集群很小（即小于或等于--large-cluster-size-threshold节点 -  默认值为50），则停止驱逐，否则， --secondary-node-eviction-rate（默认为0.01）每秒。这些策略在可用性区域内实现的原因是，一个可用性区域可能会从主分区中被分区，而其他可用区域则保持连接。如果集群没有跨多个云提供商可用性区域，那么只有一个可用区域(整个集群)。

在可用区域之间传播节点的一个主要原因是，当整个区域停止时，工作负载可以转移到健康区域。因此，如果区域中的所有节点都不健康，则节点控制器以正常速率逐出--node-eviction-rate。如所有的区域都是完全不健康的（即群集中没有健康的节点），在这种情况下，节点控制器会假设主连接有一些问题，并停止所有驱逐，直到某些连接恢复。

从Kubernetes 1.6开始，节点控制器还负责驱逐在节点上运行的NoExecutepod。

### Self-Registration of Nodes

当kubelet flag --register-node为true（默认值）时，kubelet将向API服务器注册自身。这是大多数发行版使用的首选模式。

对于self-registration，kubelet从以下选项开始：

- `--api-servers` - Location of the apiservers.
- `--kubeconfig` - Path to credentials to authenticate itself to the apiserver.
- `--cloud-provider` - How to talk to a cloud provider to read metadata about itself.
- `--register-node` - Automatically register with the API server.
- `--register-with-taints` - Register the node with the given list of taints (comma separated `<key>=<value>:<effect>`). No-op if `register-node` is false.
- `--node-ip` IP address of the node.
- `--node-labels` - Labels to add when registering the node in the cluster.
- `--node-status-update-frequency` - Specifies how often kubelet posts node status to master.

 

#### 手动管理节点

集群管理员可以创建和修改节点对象。

如果管理员希望手动创建节点对象，请设置kubelet flag --register-node=false。

管理员可以修改节点资源（不管--register-node设置如何），修改包括在节点上设置的labels 标签，并将其标记为不可调度的。

节点上的标签可以与pod上的节点选择器一起使用，以控制调度，例如将一个pod限制为只能在节点的子集上运行。

将节点标记为不可调度将防止新的pod被调度到该节点，但不会影响节点上的任何现有的pod，这在节点重新启动之前是有用的。例如，要标记节点不可调度，请运行以下命令：

```
kubectl cordon $NODENAME
```

**注意**，由daemonSet控制器创建的pod可以绕过Kubernetes调度程序，并且不遵循节点上无法调度的属性。

### Node容量

节点的容量(cpu数量和内存数量)是节点对象的一部分。通常，节点在创建节点对象时注册并通知其容量。如果是[手动管理节点](http://docs.kubernetes.org.cn/304.html#i)，则需要在添加节点时设置节点容量。

Kubernetes调度程序可确保节点上的所有pod都有足够的资源。它会检查节点上容器的请求的总和不大于节点容量。

如果要明确保留非pod过程的资源，可以创建一个占位符pod。使用以下模板：

```
apiVersion: v1
kind: Pod
metadata:
  name: resource-reserver
spec:
  containers:
  - name: sleep-forever
    image: gcr.io/google_containers/pause:0.8.0
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
```

将cpu和内存值设置为你想要保留的资源量，将文件放置在manifest目录中(`--config=DIR` flag of kubelet)。在要预留资源的每个kubelet上执行此操作。

## API 对象

Node是Kubernetes REST API中的最高级别资源。有关API对象的更多详细信息，请参考：[Node API对象](https://kubernetes.io/docs/api-reference/v1.7/#node-v1-core)。

# Kubernetes Master-Node通信

- [1 概述](http://docs.kubernetes.org.cn/306.html#i)
- [2 Cluster -> Master](http://docs.kubernetes.org.cn/306.html#Cluster_-gt_Master)
- 3 Master -> Cluster
  - [3.1 apiserver - > kubelet](http://docs.kubernetes.org.cn/306.html#apiserver_-_gt_kubelet)
  - [3.2 apiserver -> nodes、pods、services](http://docs.kubernetes.org.cn/306.html#apiserver_-gt_nodespodsservices)
  - [3.3 SSH Tunnels](http://docs.kubernetes.org.cn/306.html#SSH_Tunnels)

## 概述

本文主要介绍master和Kubernetes集群之间通信路径。其目的是允许用户自定义安装，以增强网络配置，使集群可以在不受信任（untrusted）的网络上运行。

## Cluster -> Master

从集群到Master节点的所有通信路径都在apiserver中终止。一个典型的deployment ，如果apiserver配置为监听运程连接上的HTTPS 443端口，应启用一种或多种client [authentication](http://docs.kubernetes.org.cn/51.html)，特别是如果允许[anonymous requests](http://docs.kubernetes.org.cn/51.html#Putting_a_Bearer_Token_in_a_Request)或service account tokens 。

Node节点应该配置为集群的公共根证书，以便安全地连接到apiserver。

希望连接到apiserver的Pod可以通过service  account来实现，以便Kubernetes在实例化时自动将公共根证书和有效的bearer  token插入到pod中，kubernetes service  (在所有namespaces中)都配置了一个虚拟IP地址，该IP地址由apiserver重定向(通过kube - proxy)到HTTPS。

Master组件通过非加密(未加密或认证)端口与集群apiserver通信。这个端口通常只在Master主机的localhost接口上暴露。

## Master -> Cluster

从Master (apiserver)到集群有两个主要的通信路径。第一个是从apiserver到在集群中的每个节点上运行的kubelet进程。第二个是通过apiserver的代理功能从apiserver到任何node、pod或service 。

### apiserver - > kubelet

从apiserver到kubelet的连接用于获取pod的日志，通过kubectl来运行pod，并使用kubelet的端口转发功能。这些连接在kubelet的HTTPS终端处终止。

默认情况下，apiserver不会验证kubelet的服务证书，这会使连接不受到保护。

要验证此连接，使用--kubelet-certificate-authority flag为apiserver提供根证书包，以验证kubelet的服务证书。

如果不能实现，那么请在apiserver和kubelet之间使用 [SSH tunneling](https://kubernetes.io/docs/concepts/architecture/master-node-communication/#ssh-tunnels)。

最后，应该启用[Kubelet认证或授权](https://kubernetes.io/docs/admin/kubelet-authentication-authorization/)来保护Kubelet API。

### apiserver -> nodes、pods、services

从apiserver到Node、Pod或Service的连接默认为HTTP连接，因此不需进行认证加密。也可以通过HTTPS的安全连接，但是它们不会验证HTTPS 端口提供的证书，也不提供客户端凭据，因此连接将被加密但不会提供任何诚信的保证。这些连接不可以在不受信任/或公共网络上运行。

### SSH Tunnels

[Google Container Engine](https://cloud.google.com/container-engine/docs/) 使用SSH tunnels来保护 Master -> 集群 通信路径，SSH tunnel能够使Node、Pod或Service发送的流量不会暴露在集群外部。

# Kubernetes Pod概述

- 1 了解Pod
  - 1.1 Pods如何管理多个容器
    - [1.1.1 网络](http://docs.kubernetes.org.cn/312.html#i)
    - [1.1.2 存储](http://docs.kubernetes.org.cn/312.html#i-2)
- 2 使用Pod
  - [2.1 Pod和Controller](http://docs.kubernetes.org.cn/312.html#PodController)
- [3 Pod模板](http://docs.kubernetes.org.cn/312.html#Pod-3)

本文主要介绍Pod，了Kubernetes对象模型中可部署的最小对象。

## 了解Pod

Pod是Kubernetes创建或部署的最小/最简单的基本单位，一个Pod代表集群上正在运行的一个进程。

一个Pod封装一个应用容器（也可以有多个容器），存储资源、一个独立的网络IP以及管理控制容器运行方式的策略选项。Pod代表部署的一个单位：Kubernetes中单个应用的实例，它可能由单个容器或多个容器共享组成的资源。

> Docker是Kubernetes Pod中最常见的runtime ，Pods也支持其他容器runtimes。

Kubernetes中的Pod使用可分两种主要方式：

- Pod中运行一个容器。“one-container-per-Pod”模式是Kubernetes最常见的用法; 在这种情况下，你可以将Pod视为单个封装的容器，但是Kubernetes是直接管理Pod而不是容器。
- Pods中运行多个需要一起工作的容器。Pod可以封装紧密耦合的应用，它们需要由多个容器组成，它们之间能够共享资源，这些容器可以形成一个单一的内部service单位 - 一个容器共享文件，另一个“sidecar”容器来更新这些文件。Pod将这些容器的存储资源作为一个实体来管理。

关于Pod用法其他信息请参考：

- [The Distributed System Toolkit: Patterns for Composite Containers](http://blog.kubernetes.io/2015/06/the-distributed-system-toolkit-patterns.html)
- [Container Design Patterns](http://blog.kubernetes.io/2016/06/container-design-patterns.html)

每个Pod都是运行应用的单个实例，如果需要水平扩展应用（例如，运行多个实例），则应该使用多个Pods，每个实例一个Pod。在Kubernetes中，这样通常称为Replication。Replication的Pod通常由Controller创建和管理。更多信息，请参考[Pods和控制器](http://docs.kubernetes.org.cn/312.html#PodController)。

### Pods如何管理多个容器

Pods的设计可用于支持多进程的协同工作（作为容器），形成一个cohesive的Service单位。Pod中的容器在集群中Node上被自动分配，容器之间可以共享资源、网络和相互依赖关系，并同时被调度使用。

请注意，在单个Pod中共同管理多个容器是一个相对高级的用法，应该只有在容器紧密耦合的特殊实例中使用此模式。例如，有一个容器被用作WEB服务器，用于共享volume，以及一个单独“sidecar”容器需要从远程获取资源来更新这些文件，如下图所示：

![pod diagram](https://d33wubrfki0l68.cloudfront.net/aecab1f649bc640ebef1f05581bfcc91a48038c4/728d6/images/docs/pod.svg)

Pods提供两种共享资源：网络和存储。

#### 网络

每个Pod被分配一个独立的IP地址，Pod中的每个容器共享网络命名空间，包括IP地址和网络端口。Pod内的容器可以使用localhost相互通信。当Pod中的容器与Pod 外部通信时，他们必须协调如何使用共享网络资源（如端口）。

#### 存储

Pod可以指定一组共享存储*volumes*。Pod中的所有容器都可以访问共享*volumes*，允许这些容器共享数据。*volumes* 还用于Pod中的数据持久化，以防其中一个容器需要重新启动而丢失数据。有关Kubernetes如何在Pod中实现共享存储的更多信息，请参考Volumes。

## 使用Pod

你很少会直接在kubernetes中创建单个Pod。因为Pod的生命周期是短暂的，用后即焚的实体。当Pod被创建后（不论是由你直接创建还是被其他Controller），都会被Kuberentes调度到集群的Node上。直到Pod的进程终止、被删掉、因为缺少资源而被驱逐、或者Node故障之前这个Pod都会一直保持在那个Node上。

> 注意：重启Pod中的容器跟重启Pod不是一回事。Pod只提供容器的运行环境并保持容器的运行状态，重启容器不会造成Pod重启。

Pod不会自愈。如果Pod运行的Node故障，或者是调度器本身故障，这个Pod就会被删除。同样的，如果Pod所在Node缺少资源或者Pod处于维护状态，Pod也会被驱逐。Kubernetes使用更高级的称为Controller的抽象层，来管理Pod实例。虽然可以直接使用Pod，但是在Kubernetes中通常是使用Controller来管理Pod的。

### Pod和Controller

Controller可以创建和管理多个Pod，提供副本管理、滚动升级和集群级别的自愈能力。例如，如果一个Node故障，Controller就能自动将该节点上的Pod调度到其他健康的Node上。

包含一个或者多个Pod的Controller示例：

- [Deployment](http://docs.kubernetes.org.cn/317.html)
- [StatefulSet](http://docs.kubernetes.org.cn/443.html)
- DaemonSet

通常，Controller会用你提供的Pod Template来创建相应的Pod。

## Pod模板

Pod模板是包含了其他对象（如[Replication Controllers](http://docs.kubernetes.org.cn/437.html)，[Jobs](https://kubernetes.io/docs/concepts/jobs/run-to-completion-finite-workloads/)和 [DaemonSets）](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)中的pod定义 。Controllers控制器使用Pod模板来创建实际需要的pod。

pod模板类似cookie cutters。“一旦饼干被切掉，饼干和刀将没有关系”。随后对模板的后续更改甚至切换到新模板对已创建的pod并没有任何的影响。

> 参考：[宋净超博客](https://rootsongjc.gitbooks.io/kubernetes-handbook/content/concepts/pod-overview.html)

# Pod 安全策略

- 1 什么是 Pod 安全策略？
  - [1.1 RunAsUser](http://docs.kubernetes.org.cn/690.html#RunAsUser)
  - [1.2 SELinux](http://docs.kubernetes.org.cn/690.html#SELinux)
  - [1.3 SupplementalGroups](http://docs.kubernetes.org.cn/690.html#SupplementalGroups)
  - [1.4 FSGroup](http://docs.kubernetes.org.cn/690.html#FSGroup)
  - [1.5 控制卷](http://docs.kubernetes.org.cn/690.html#i)
  - [1.6 主机网络](http://docs.kubernetes.org.cn/690.html#i-2)
  - [1.7 允许的主机路径](http://docs.kubernetes.org.cn/690.html#i-3)
- [2 许可](http://docs.kubernetes.org.cn/690.html#i-4)
- [3 创建 Pod 安全策略](http://docs.kubernetes.org.cn/690.html#_Pod-2)
- [4 获取 Pod 安全策略列表](http://docs.kubernetes.org.cn/690.html#_Pod-3)
- [5 修改 Pod 安全策略](http://docs.kubernetes.org.cn/690.html#_Pod-4)
- [6 删除 Pod 安全策略](http://docs.kubernetes.org.cn/690.html#_Pod-5)
- [7 启用 Pod 安全策略](http://docs.kubernetes.org.cn/690.html#_Pod-6)
- [8 使用 RBAC](http://docs.kubernetes.org.cn/690.html#_RBAC)

PodSecurityPolicy 类型的对象能够控制，是否可以向 Pod 发送请求，该 Pod 能够影响被应用到 Pod 和容器的 SecurityContext。 查看 Pod 安全策略建议 获取更多信息。

## 什么是 Pod 安全策略？

Pod 安全策略 是集群级别的资源，它能够控制 Pod 运行的行为，以及它具有访问什么的能力。 PodSecurityPolicy对象定义了一组条件，指示 Pod 必须按系统所能接受的顺序运行。 它们允许管理员控制如下方面：

| 控制面                           | 字段名称                                                     |
| -------------------------------- | ------------------------------------------------------------ |
| 已授权容器的运行                 | privileged                                                   |
| 为容器添加默认的一组能力         | defaultAddCapabilities                                       |
| 为容器去掉某些能力               | requiredDropCapabilities                                     |
| 容器能够请求添加某些能力         | allowedCapabilities                                          |
| 控制卷类型的使用                 | [volumes](http://docs.kubernetes.org.cn/429.html)            |
| 主机网络的使用                   | hostNetwork                                                  |
| 主机端口的使用                   | hostPorts                                                    |
| 主机 PID namespace 的使用        | hostPID                                                      |
| 主机 IPC namespace 的使用        | hostIPC                                                      |
| 主机路径的使用                   | [allowedHostPaths](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#allowed-host-paths) |
| 容器的 SELinux 上下文            | [seLinux](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#selinux) |
| 用户 ID                          | [runAsUser](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#runasuser) |
| 配置允许的补充组                 | [supplementalGroups](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#supplementalgroups) |
| 分配拥有 Pod 数据卷的 FSGroup    | [fsGroup](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#fsgroup) |
| 必须使用一个只读的 root 文件系统 | readOnlyRootFilesystem                                       |

Pod 安全策略 由设置和策略组成，它们能够控制 Pod 访问的安全特征。这些设置分为如下三类：

- 基于布尔值控制：这种类型的字段默认为最严格限制的值。
- 基于被允许的值集合控制：这种类型的字段会与这组值进行对比，以确认值被允许。
- 基于策略控制：设置项通过一种策略提供的机制来生成该值，这种机制能够确保指定的值落在被允许的这组值中。

### RunAsUser

- MustRunAs - 必须配置一个 range。使用该范围内的第一个值作为默认值。验证是否不在配置的该范围内。
- MustRunAsNonRoot - 要求提交的 Pod 具有非零 runAsUser 值，或在镜像中定义了 USER 环境变量。不提供默认值。
- RunAsAny - 没有提供默认值。允许指定任何 runAsUser 。

### SELinux

- MustRunAs - 如果没有使用预分配的值，必须配置 seLinuxOptions。默认使用 seLinuxOptions。验证 seLinuxOptions。
- RunAsAny - 没有提供默认值。允许任意指定的 seLinuxOptions ID。

### SupplementalGroups

- MustRunAs - 至少需要指定一个范围。默认使用第一个范围的最小值。验证所有范围的值。
- RunAsAny - 没有提供默认值。允许任意指定的 supplementalGroups ID。

### FSGroup

- MustRunAs - 至少需要指定一个范围。默认使用第一个范围的最小值。验证在第一个范围内的第一个 ID。
- RunAsAny - 没有提供默认值。允许任意指定的 fsGroup ID。

### 控制卷

通过设置 PSP 卷字段，能够控制具体卷类型的使用。当创建一个卷的时候，与该字段相关的已定义卷可以允许设置如下值：

1. azureFile
2. azureDisk
3. flocker
4. flexVolume
5. hostPath
6. emptyDir
7. gcePersistentDisk
8. awsElasticBlockStore
9. gitRepo
10. secret
11. nfs
12. iscsi
13. glusterfs
14. persistentVolumeClaim
15. rbd
16. cinder
17. cephFS
18. downwardAPI
19. fc
20. configMap
21. vsphereVolume
22. quobyte
23. photonPersistentDisk
24. projected
25. portworxVolume
26. scaleIO
27. storageos
28. \* (allow all volumes)

对新的 PSP，推荐允许的卷的最小集合包括：configMap、downwardAPI、emptyDir、persistentVolumeClaim、secret 和 projected。

### 主机网络

- HostPorts， 默认为 empty。HostPortRange 列表通过 min(包含) and max(包含) 来定义，指定了被允许的主机端口。

### 允许的主机路径

- AllowedHostPaths 是一个被允许的主机路径前缀的白名单。空值表示所有的主机路径都可以使用。

## 许可

包含 PodSecurityPolicy 的 许可控制，允许控制集群资源的创建和修改，基于这些资源在集群范围内被许可的能力。

许可使用如下的方式为 Pod 创建最终的安全上下文：

1. 检索所有可用的 PSP。
2. 生成在请求中没有指定的安全上下文设置的字段值。
3. 基于可用的策略，验证最终的设置。

如果某个策略能够匹配上，该 Pod 就被接受。如果请求与 PSP 不匹配，则 Pod 被拒绝。

Pod 必须基于 PSP 验证每个字段。

## 创建 Pod 安全策略

下面是一个 Pod 安全策略的例子，所有字段的设置都被允许：

```
apiVersion: extensions/v1beta1
kind: PodSecurityPolicy
metadata:
  name: permissive
spec:
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
  hostPorts:
  - min: 8000
    max: 8080
  volumes:
  - '*'
```

下载示例文件可以创建该策略，然后执行如下命令：

```
$ kubectl create -f ./psp.yaml
podsecuritypolicy "permissive" created
```

## 获取 Pod 安全策略列表

获取已存在策略列表，使用 kubectl get：

```
$ kubectl get psp
NAME        PRIV   CAPS  SELINUX   RUNASUSER         FSGROUP   SUPGROUP  READONLYROOTFS  VOLUMES
permissive  false  []    RunAsAny  RunAsAny          RunAsAny  RunAsAny  false           [*]
privileged  true   []    RunAsAny  RunAsAny          RunAsAny  RunAsAny  false           [*]
restricted  false  []    RunAsAny  MustRunAsNonRoot  RunAsAny  RunAsAny  false           [emptyDir secret downwardAPI configMap persistentVolumeClaim projected]
```

## 修改 Pod 安全策略

通过交互方式修改策略，使用 kubectl edit：

```
$ kubectl edit psp permissive
```

该命令将打开一个默认文本编辑器，在这里能够修改策略。

## 删除 Pod 安全策略

一旦不再需要一个策略，很容易通过 kubectl 删除它：

```
$ kubectl delete psp permissive
podsecuritypolicy "permissive" deleted
```

## 启用 Pod 安全策略

为了能够在集群中使用 Pod 安全策略，必须确保如下：

1. 启用 API 类型 extensions/v1beta1/podsecuritypolicy（仅对 1.6 之前的版本）
2. 启用许可控制器 PodSecurityPolicy
3. 定义自己的策略

## 使用 RBAC

在 Kubernetes 1.5 或更新版本，可以使用 PodSecurityPolicy  来控制，对基于用户角色和组的已授权容器的访问。访问不同的 PodSecurityPolicy 对象，可以基于认证来控制。基于  Deployment、ReplicaSet 等创建的 Pod，限制访问 PodSecurityPolicy 对象，[Controller Manager](https://kubernetes.io/docs/admin/kube-controller-manager/) 必须基于安全 API 端口运行，并且不能够具有超级用户权限。

PodSecurityPolicy 认证使用所有可用的策略，包括创建 Pod 的用户，Pod 上指定的服务账户（service  acount）。当 Pod 基于 Deployment、ReplicaSet 创建时，它是创建 Pod 的 Controller  Manager，所以如果基于非安全 API 端口运行，允许所有的 PodSecurityPolicy  对象，并且不能够有效地实现细分权限。用户访问给定的 PSP 策略有效，仅当是直接部署 Pod 的情况。更多详情，查看 [PodSecurityPolicy RBAC 示例](https://git.k8s.io/kubernetes/examples/podsecuritypolicy/rbac/README.md)，当直接部署 Pod 时，应用 PodSecurityPolicy 控制基于角色和组的已授权容器的访问 。

原文地址：https://k8smeetup.github.io/docs/concepts/policy/pod-security-policy/

译者：[shirdrn](https://github.com/shirdrn)

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg)

# Kubernetes Pod 生命周期

- [1 Pod phase](http://docs.kubernetes.org.cn/719.html#Pod_phase)
- [2 Pod 状态](http://docs.kubernetes.org.cn/719.html#Pod)
- 3 容器探针
  - [3.1 该什么时候使用存活（liveness）和就绪（readiness）探针?](http://docs.kubernetes.org.cn/719.html#livenessreadiness)
- [4 Pod 和容器状态](http://docs.kubernetes.org.cn/719.html#Pod-2)
- [5 重启策略](http://docs.kubernetes.org.cn/719.html#i-2)
- [6 Pod 的生命](http://docs.kubernetes.org.cn/719.html#Pod-3)
- 7 示例
  - [7.1 高级 liveness 探针示例](http://docs.kubernetes.org.cn/719.html#_liveness)
  - [7.2 状态示例](http://docs.kubernetes.org.cn/719.html#i-4)

该页面将描述 Pod 的生命周期。

## Pod phase

Pod 的 status 定义在 [PodStatus](https://k8smeetup.github.io/docs/resources-reference/v1.7/#podstatus-v1-core) 对象中，其中有一个 phase 字段。

Pod 的相位（phase）是 Pod 在其生命周期中的简单宏观概述。该阶段并不是对容器或 Pod 的综合汇总，也不是为了做为综合状态机。

Pod 相位的数量和含义是严格指定的。除了本文档中列举的内容外，不应该再假定 Pod 有其他的 phase 值。

下面是 phase 可能的值：

- 挂起（Pending）：Pod 已被 Kubernetes 系统接受，但有一个或者多个容器镜像尚未创建。等待时间包括调度 Pod 的时间和通过网络下载镜像的时间，这可能需要花点时间。
- 运行中（Running）：该 Pod 已经绑定到了一个节点上，Pod 中所有的容器都已被创建。至少有一个容器正在运行，或者正处于启动或重启状态。
- 成功（Succeeded）：Pod 中的所有容器都被成功终止，并且不会再重启。
- 失败（Failed）：Pod 中的所有容器都已终止了，并且至少有一个容器是因为失败终止。也就是说，容器以非0状态退出或者被系统终止。
- 未知（Unknown）：因为某些原因无法取得 Pod 的状态，通常是因为与 Pod 所在主机通信失败。

## Pod 状态

Pod 有一个 PodStatus 对象，其中包含一个 [PodCondition](https://k8smeetup.github.io/docs/resources-reference/v1.7/#podcondition-v1-core) 数组。 PodCondition 数组的每个元素都有一个 type 字段和一个 status 字段。type 字段是字符串，可能的值有  PodScheduled、Ready、Initialized 和 Unschedulable。status 字段是一个字符串，可能的值有  True、False 和 Unknown。

## 容器探针

[探针](https://k8smeetup.github.io/docs/resources-reference/v1.7/#probe-v1-core) 是由 [kubelet](https://k8smeetup.github.io/docs/admin/kubelet/) 对容器执行的定期诊断。要执行诊断，kubelet 调用由容器实现的 [Handler](https://godoc.org/k8s.io/kubernetes/pkg/api/v1#Handler)。有三种类型的处理程序：

- [ExecAction](https://k8smeetup.github.io/docs/resources-reference/v1.7/#execaction-v1-core)：在容器内执行指定命令。如果命令退出时返回码为 0 则认为诊断成功。
- [TCPSocketAction](https://k8smeetup.github.io/docs/resources-reference/v1.7/#tcpsocketaction-v1-core)：对指定端口上的容器的 IP 地址进行 TCP 检查。如果端口打开，则诊断被认为是成功的。
- [HTTPGetAction](https://k8smeetup.github.io/docs/resources-reference/v1.7/#httpgetaction-v1-core)：对指定的端口和路径上的容器的 IP 地址执行 HTTP Get 请求。如果响应的状态码大于等于200 且小于 400，则诊断被认为是成功的。

每次探测都将获得以下三种结果之一：

- 成功：容器通过了诊断。
- 失败：容器未通过诊断。
- 未知：诊断失败，因此不会采取任何行动。

Kubelet 可以选择是否执行在容器上运行的两种探针执行和做出反应：

- livenessProbe：指示容器是否正在运行。如果存活探测失败，则 kubelet 会杀死容器，并且容器将受到其 [重启策略](https://k8smeetup.github.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy) 的影响。如果容器不提供存活探针，则默认状态为 Success。
- readinessProbe：指示容器是否准备好服务请求。如果就绪探测失败，端点控制器将从与 Pod 匹配的所有 Service  的端点中删除该 Pod 的 IP 地址。初始延迟之前的就绪状态默认为 Failure。如果容器不提供就绪探针，则默认状态为 Success。

### 该什么时候使用存活（liveness）和就绪（readiness）探针?

如果容器中的进程能够在遇到问题或不健康的情况下自行崩溃，则不一定需要存活探针; kubelet 将根据 Pod 的restartPolicy 自动执行正确的操作。

如果您希望容器在探测失败时被杀死并重新启动，那么请指定一个存活探针，并指定restartPolicy 为 Always 或 OnFailure。

如果要仅在探测成功时才开始向 Pod 发送流量，请指定就绪探针。在这种情况下，就绪探针可能与存活探针相同，但是 spec 中的就绪探针的存在意味着 Pod 将在没有接收到任何流量的情况下启动，并且只有在探针探测成功后才开始接收流量。

如果您希望容器能够自行维护，您可以指定一个就绪探针，该探针检查与存活探针不同的端点。

请注意，如果您只想在 Pod 被删除时能够排除请求，则不一定需要使用就绪探针；在删除 Pod 时，Pod 会自动将自身置于未完成状态，无论就绪探针是否存在。当等待 Pod 中的容器停止时，Pod 仍处于未完成状态。

## Pod 和容器状态

有关 Pod 容器状态的详细信息，请参阅 [PodStatus](https://k8smeetup.github.io/docs/resources-reference/v1.7/#podstatus-v1-core) 和 [ContainerStatus](https://k8smeetup.github.io/docs/resources-reference/v1.7/#containerstatus-v1-core)。请注意，报告的 Pod 状态信息取决于当前的 [ContainerState](https://k8smeetup.github.io/docs/resources-reference/v1.7/#containerstatus-v1-core)。

## 重启策略

PodSpec 中有一个 restartPolicy 字段，可能的值为 Always、OnFailure 和 Never。默认为  Always。 restartPolicy 适用于 Pod 中的所有容器。restartPolicy 仅指通过同一节点上的 kubelet  重新启动容器。失败的容器由 kubelet 以五分钟为上限的指数退避延迟（10秒，20秒，40秒…）重新启动，并在成功执行十分钟后重置。如 [Pod 文档](http://docs.kubernetes.org.cn/312.html) 中所述，一旦绑定到一个节点，Pod 将永远不会重新绑定到另一个节点。

## Pod 的生命

一般来说，Pod 不会消失，直到人为销毁他们。这可能是一个人或控制器。这个规则的唯一例外是成功或失败的 phase 超过一段时间（由 master 确定）的Pod将过期并被自动销毁。

有三种可用的控制器：

- 使用 [Job](https://k8smeetup.github.io/docs/concepts/jobs/run-to-completion-finite-workloads/) 运行预期会终止的 Pod，例如批量计算。Job 仅适用于重启策略为 OnFailure 或 Never 的 Pod。
- 对预期不会终止的 Pod 使用 [ReplicationController](http://docs.kubernetes.org.cn/437.html)、[ReplicaSet](http://docs.kubernetes.org.cn/314.html) 和 [Deployment](http://docs.kubernetes.org.cn/317.html) ，例如 Web 服务器。 ReplicationController 仅适用于具有 restartPolicy 为 Always 的 Pod。
- 提供特定于机器的系统服务，使用 [DaemonSet](https://k8smeetup.github.io/docs/concepts/workloads/controllers/daemonset/) 为每台机器运行一个 Pod 。

所有这三种类型的控制器都包含一个 PodTemplate。建议创建适当的控制器，让它们来创建 Pod，而不是直接自己创建 Pod。这是因为单独的 Pod 在机器故障的情况下没有办法自动复原，而控制器却可以。

如果节点死亡或与集群的其余部分断开连接，则 Kubernetes 将应用一个策略将丢失节点上的所有 Pod 的 phase 设置为 Failed。

## 示例

### 高级 liveness 探针示例

存活探针由 kubelet 来执行，因此所有的请求都在 kubelet 的网络命名空间中进行。

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-http
spec:
  containers:
  - args:
    - /server
    image: gcr.io/google_containers/liveness
    livenessProbe:
      httpGet:
        # when "host" is not defined, "PodIP" will be used
        # host: my-host
        # when "scheme" is not defined, "HTTP" scheme will be used. Only "HTTP" and "HTTPS" are allowed
        # scheme: HTTPS
        path: /healthz
        port: 8080
        httpHeaders:
          - name: X-Custom-Header
            value: Awesome
      initialDelaySeconds: 15
      timeoutSeconds: 1
    name: liveness
```

### 状态示例

- Pod 中只有一个容器并且正在运行。容器成功退出。
  - 记录完成事件。
  - 如果 restartPolicy 为：
    - Always：重启容器；Pod phase 仍为 Running。
    - OnFailure：Pod phase 变成 Succeeded。
    - Never：Pod phase 变成 Succeeded。
- Pod 中只有一个容器并且正在运行。容器退出失败。
  - 记录失败事件。
  - 如果 restartPolicy 为：
    - Always：重启容器；Pod phase 仍为 Running。
    - OnFailure：重启容器；Pod phase 仍为 Running。
    - Never：Pod phase 变成 Failed。
- Pod 中有两个容器并且正在运行。有一个容器退出失败。
  - 记录失败事件。
  - 如果 restartPolicy 为：
    - Always：重启容器；Pod phase 仍为 Running。
    - OnFailure：重启容器；Pod phase 仍为 Running。
    - Never：不重启容器；Pod phase 仍为 Running。
  - 如果有一个容器没有处于运行状态，并且两个容器退出：
    - 记录失败事件。
    - 如果 restartPolicy 为：
      - Always：重启容器；Pod phase 仍为 Running。
      - OnFailure：重启容器；Pod phase 仍为 Running。
      - Never：Pod phase 变成 Failed。
- Pod 中只有一个容器并处于运行状态。容器运行时内存超出限制：
  - 容器以失败状态终止。
  - 记录 OOM 事件。
  - 如果 restartPolicy 为：
    - Always：重启容器；Pod phase 仍为 Running。
    - OnFailure：重启容器；Pod phase 仍为 Running。
    - Never: 记录失败事件；Pod phase 仍为 Failed。
- Pod 正在运行，磁盘故障：
  - 杀掉所有容器。
  - 记录适当事件。
  - Pod phase 变成 Failed。
  - 如果使用控制器来运行，Pod 将在别处重建。
- Pod 正在运行，其节点被分段。
  - 节点控制器等待直到超时。
  - 节点控制器将 Pod phase 设置为 Failed。
  - 如果是用控制器来运行，Pod 将在别处重建。

译者：[jimmysong ](https://github.com/rootsongjc)原文：https://k8smeetup.github.io/docs/concepts/workloads/pods/pod-lifecycle/

# Init 容器

- 1 理解 Init 容器
  - [1.1 与普通容器的不同之处](http://docs.kubernetes.org.cn/688.html#i)
- 2 Init 容器能做什么？
  - [2.1 示例](http://docs.kubernetes.org.cn/688.html#i-2)
  - [2.2 使用 Init 容器](http://docs.kubernetes.org.cn/688.html#_Init-2)
- 3 具体行为
  - [3.1 资源](http://docs.kubernetes.org.cn/688.html#i-4)
  - [3.2 Pod 重启的原因](http://docs.kubernetes.org.cn/688.html#Pod)
- [4 支持与兼容性](http://docs.kubernetes.org.cn/688.html#i-5)

该特性在 1.6 版本已经退出 beta 版本。Init 容器可以在 PodSpec 中同应用程序的 containers 数组一起来指定。 beta 注解的值将仍需保留，并覆盖 PodSpec 字段值。

本文讲解 Init 容器的基本概念，它是一种专用的容器，在应用程序容器启动之前运行，并包括一些应用镜像中不存在的实用工具和安装脚本。

## 理解 Init 容器

[Pod](http://docs.kubernetes.org.cn/312.html) 能够具有多个容器，应用运行在容器里面，但是它也可能有一个或多个先于应用容器启动的 Init 容器。

Init 容器与普通的容器非常像，除了如下两点：

- Init 容器总是运行到成功完成为止。
- 每个 Init 容器都必须在下一个 Init 容器启动之前成功完成。

如果 Pod 的 Init 容器失败，Kubernetes 会不断地重启该 Pod，直到 Init 容器成功为止。然而，如果 Pod 对应的 restartPolicy 为 Never，它不会重新启动。

指定容器为 Init 容器，在 PodSpec 中添加 initContainers 字段，以 [v1.Container](https://kubernetes.io/docs/api-reference/v1.6/#container-v1-core) 类型对象的 JSON 数组的形式，还有 app 的 containers 数组。 Init  容器的状态在 status.initContainerStatuses 字段中以容器状态数组的格式返回（类似 status.containerStatuses 字段）。

### 与普通容器的不同之处

Init 容器支持应用容器的全部字段和特性，包括资源限制、数据卷和安全设置。 然而，Init 容器对资源请求和限制的处理稍有不同，在下面 [资源](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#resources) 处有说明。 而且 Init 容器不支持 Readiness Probe，因为它们必须在 Pod 就绪之前运行完成。

如果为一个 Pod 指定了多个 Init 容器，那些容器会按顺序一次运行一个。 每个 Init 容器必须运行成功，下一个才能够运行。 当所有的 Init 容器运行完成时，Kubernetes 初始化 Pod 并像平常一样运行应用容器。

## Init 容器能做什么？

因为 Init 容器具有与应用程序容器分离的单独镜像，所以它们的启动相关代码具有如下优势：

- 它们可以包含并运行实用工具，但是出于安全考虑，是不建议在应用程序容器镜像中包含这些实用工具的。
- 它们可以包含使用工具和定制化代码来安装，但是不能出现在应用程序镜像中。例如，创建镜像没必要 FROM 另一个镜像，只需要在安装过程中使用类似 sed、 awk、 python 或 dig 这样的工具。
- 应用程序镜像可以分离出创建和部署的角色，而没有必要联合它们构建一个单独的镜像。
- Init 容器使用 Linux Namespace，所以相对应用程序容器来说具有不同的文件系统视图。因此，它们能够具有访问 Secret 的权限，而应用程序容器则不能。
- 它们必须在应用程序容器启动之前运行完成，而应用程序容器是并行运行的，所以 Init 容器能够提供了一种简单的阻塞或延迟应用容器的启动的方法，直到满足了一组先决条件。

### 示例

下面是一些如何使用 Init 容器的想法：

- 等待一个 Service 创建完成，通过类似如下 shell 命令：

  ```
    for i in {1..100}; do sleep 1; if dig myservice; then exit 0; fi; exit 1
  ```

- 将 Pod 注册到远程服务器，通过在命令中调用 API，类似如下：

  ```
    curl -X POST http://$MANAGEMENT_SERVICE_HOST:$MANAGEMENT_SERVICE_PORT/register -d 'instance=$(<POD_NAME>)&ip=$(<POD_IP>)'
  ```

- 在启动应用容器之前等一段时间，使用类似 sleep 60 的命令。

- 克隆 Git 仓库到数据卷。

- 将配置值放到配置文件中，运行模板工具为主应用容器动态地生成配置文件。例如，在配置文件中存放 POD_IP 值，并使用 Jinja 生成主应用配置文件。

更多详细用法示例，可以在 [StatefulSet 文档](http://docs.kubernetes.org.cn/443.html) 和 [生产环境 Pod 指南](https://kubernetes.io/docs/user-guide/production-pods.md#handling-initialization) 中找到。

### 使用 Init 容器

下面是 Kubernetes 1.5 版本 yaml 文件，展示了一个具有 2 个 Init 容器的简单 Pod。 第一个等待 myservice 启动，第二个等待 mydb 启动。 一旦这两个 Service 都启动完成，Pod 将开始启动。

```
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
  annotations:
    pod.beta.kubernetes.io/init-containers: '[
        {
            "name": "init-myservice",
            "image": "busybox",
            "command": ["sh", "-c", "until nslookup myservice; do echo waiting for myservice; sleep 2; done;"]
        },
        {
            "name": "init-mydb",
            "image": "busybox",
            "command": ["sh", "-c", "until nslookup mydb; do echo waiting for mydb; sleep 2; done;"]
        }
    ]'
spec:
  containers:
  - name: myapp-container
    image: busybox
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
```

这是 Kubernetes 1.6 版本的新语法，尽管老的 annotation 语法仍然可以使用。我们已经把 Init 容器的声明移到 spec 中：

```
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  - name: init-mydb
    image: busybox
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
```

1.5 版本的语法在 1.6 版本仍然可以使用，但是我们推荐使用 1.6 版本的新语法。 在 Kubernetes 1.6  版本中，Init 容器在 API 中新建了一个字段。 虽然期望使用 beta 版本的 annotation，但在未来发行版将会被废弃掉。

下面的 yaml 文件展示了 mydb 和 myservice 两个 Service：

```
kind: Service
apiVersion: v1
metadata:
  name: myservice
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
---
kind: Service
apiVersion: v1
metadata:
  name: mydb
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9377
```

这个 Pod 可以使用下面的命令进行启动和调试：

```
$ kubectl create -f myapp.yaml
pod "myapp-pod" created
$ kubectl get -f myapp.yaml
NAME        READY     STATUS     RESTARTS   AGE
myapp-pod   0/1       Init:0/2   0          6m
$ kubectl describe -f myapp.yaml 
Name:          myapp-pod
Namespace:     default
[...]
Labels:        app=myapp
Status:        Pending
[...]
Init Containers:
  init-myservice:
[...]
    State:         Running
[...]
  init-mydb:
[...]
    State:         Waiting
      Reason:      PodInitializing
    Ready:         False
[...]
Containers:
  myapp-container:
[...]
    State:         Waiting
      Reason:      PodInitializing
    Ready:         False
[...]
Events:
  FirstSeen    LastSeen    Count    From                      SubObjectPath                           Type          Reason        Message
  ---------    --------    -----    ----                      -------------                           --------      ------        -------
  16s          16s         1        {default-scheduler }                                              Normal        Scheduled     Successfully assigned myapp-pod to 172.17.4.201
  16s          16s         1        {kubelet 172.17.4.201}    spec.initContainers{init-myservice}     Normal        Pulling       pulling image "busybox"
  13s          13s         1        {kubelet 172.17.4.201}    spec.initContainers{init-myservice}     Normal        Pulled        Successfully pulled image "busybox"
  13s          13s         1        {kubelet 172.17.4.201}    spec.initContainers{init-myservice}     Normal        Created       Created container with docker id 5ced34a04634; Security:[seccomp=unconfined]
  13s          13s         1        {kubelet 172.17.4.201}    spec.initContainers{init-myservice}     Normal        Started       Started container with docker id 5ced34a04634
$ kubectl logs myapp-pod -c init-myservice # Inspect the first init container
$ kubectl logs myapp-pod -c init-mydb      # Inspect the second init container
```

一旦我们启动了 mydb 和 myservice 这两个 Service，我们能够看到 Init 容器完成，并且 myapp-pod 被创建：

```
$ kubectl create -f services.yaml
service "myservice" created
service "mydb" created
$ kubectl get -f myapp.yaml
NAME        READY     STATUS    RESTARTS   AGE
myapp-pod   1/1       Running   0          9m
```

这个例子非常简单，但是应该能够为我们创建自己的 Init 容器提供一些启发。

## 具体行为

在 Pod 启动过程中，Init 容器会按顺序在网络和数据卷初始化之后启动。 每个容器必须在下一个容器启动之前成功退出。  如果由于运行时或失败退出，导致容器启动失败，它会根据 Pod 的 restartPolicy 指定的策略进行重试。 然而，如果 Pod  的 restartPolicy 设置为 Always，Init 容器失败时会使用 RestartPolicy策略。

在所有的 Init 容器没有成功之前，Pod 将不会变成 Ready 状态。 Init 容器的端口将不会在 Service 中进行聚集。 正在初始化中的 Pod 处于 Pending 状态，但应该会将条件 Initializing 设置为 true。

如果 Pod 重启，所有 Init 容器必须重新执行。

对 Init 容器 spec 的修改，被限制在容器 image 字段中。 更改 Init 容器的 image 字段，等价于重启该 Pod。

因为 Init 容器可能会被重启、重试或者重新执行，所以 Init 容器的代码应该是幂等的。 特别地，被写到 EmptyDirs 中文件的代码，应该对输出文件可能已经存在做好准备。

Init 容器具有应用容器的所有字段。 除了 readinessProbe，因为 Init 容器无法定义不同于完成（completion）的就绪（readiness）的之外的其他状态。 这会在验证过程中强制执行。

在 Pod 上使用 activeDeadlineSeconds，在容器上使用 livenessProbe，这样能够避免 Init 容器一直失败。 这就为 Init 容器活跃设置了一个期限。

在 Pod 中的每个 app 和 Init 容器的名称必须唯一；与任何其它容器共享同一个名称，会在验证时抛出错误。

### 资源

为 Init 容器指定顺序和执行逻辑，下面对资源使用的规则将被应用：

- 在所有 Init 容器上定义的，任何特殊资源请求或限制的最大值，是 有效初始请求/限制
- Pod 对资源的有效请求/限制要高于：
  - 所有应用容器对某个资源的请求/限制之和
  - 对某个资源的有效初始请求/限制
- 基于有效请求/限制完成调度，这意味着 Init 容器能够为初始化预留资源，这些资源在 Pod 生命周期过程中并没有被使用。
- Pod 的 有效 QoS 层，是 Init 容器和应用容器相同的 QoS 层。

基于有效 Pod 请求和限制来应用配额和限制。 Pod 级别的 cgroups 是基于有效 Pod 请求和限制，和调度器相同。

### Pod 重启的原因

Pod 能够重启，会导致 Init 容器重新执行，主要有如下几个原因：

- 用户更新 PodSpec 导致 Init 容器镜像发生改变。应用容器镜像的变更只会重启应用容器。
- Pod 基础设施容器被重启。这不多见，但某些具有 root 权限可访问 Node 的人可能会这样做。
- 当 restartPolicy 设置为 Always，Pod 中所有容器会终止，强制重启，由于垃圾收集导致 Init 容器完成的记录丢失。

## 支持与兼容性

Apiserver 版本为 1.6 或更高版本的集群，通过使用 spec.initContainers 字段来支持 Init 容器。  之前的版本可以使用 alpha 和 beta 注解支持 Init 容器。 spec.initContainers 字段也被加入到 alpha 和 beta 注解中，所以 Kubernetes 1.3.0 版本或更高版本可以执行 Init 容器，并且 1.6 版本的 apiserver  能够安全的回退到 1.5.x 版本，而不会使存在的已创建 Pod 失去 Init 容器的功能。

原文地址：https://k8smeetup.github.io/docs/concepts/workloads/pods/init-containers/ 	

# Kubernetes 给容器和Pod分配内存资源

- [1 Before you begin](http://docs.kubernetes.org.cn/729.html#Before_you_begin)
- [2 创建一个命名空间](http://docs.kubernetes.org.cn/729.html#i)
- [3 配置内存申请和限制](http://docs.kubernetes.org.cn/729.html#i-2)
- [4 超出容器的内存限制](http://docs.kubernetes.org.cn/729.html#i-3)
- [5 配置超出节点能力范围的内存申请](http://docs.kubernetes.org.cn/729.html#i-4)
- [6 内存单位](http://docs.kubernetes.org.cn/729.html#i-5)
- [7 如果不配置内存限制](http://docs.kubernetes.org.cn/729.html#i-6)
- [8 内存申请和限制的原因](http://docs.kubernetes.org.cn/729.html#i-7)
- [9 清理](http://docs.kubernetes.org.cn/729.html#i-8)

这篇教程指导如何给容器分配申请的内存和内存限制。我们保证让容器获得足够的内存 资源，但是不允许它使用超过限制的资源。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

你的集群里每个节点至少必须拥有300M的内存。

这个教程里有几个步骤要求[Heapster](https://github.com/kubernetes/heapster) ， 但是如果你没有Heapster的话，也可以完成大部分的实验，就算跳过这些Heapster 步骤，也不会有什么问题。

检查看Heapster服务是否运行，执行命令：

```
kubectl get services --namespace=kube-system
```

如果Heapster服务正在运行，会有如下输出：

```
NAMESPACE    NAME      CLUSTER-IP    EXTERNAL-IP  PORT(S)  AGE
kube-system  heapster  10.11.240.9   <none>       80/TCP   6d
```

## 创建一个命名空间

创建命名空间，以便你在实验中创建的资源可以从集群的资源中隔离出来。

```
kubectl create namespace mem-example
```

## 配置内存申请和限制

给容器配置内存申请，只要在容器的配置文件里添加resources:requests就可以了。配置限制的话， 则是添加resources:limits。

本实验，我们创建包含一个容器的Pod，这个容器申请100M的内存，并且内存限制设置为200M，下面 是配置文件：

| [memory-request-limit.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/memory-request-limit.yaml)![Copy memory-request-limit.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: memory-demo spec:  containers:  - name: memory-demo-ctr    image: vish/stress    resources:      limits:        memory: "200Mi"      requests:        memory: "100Mi"    args:    - -mem-total    - 150Mi    - -mem-alloc-size    - 10Mi    - -mem-alloc-sleep    - 1s ` |

在这个配置文件里，args代码段提供了容器所需的参数。-mem-total 150Mi告诉容器尝试申请150M 的内存。

创建Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/memory-request-limit.yaml --namespace=mem-example
```

验证Pod的容器是否正常运行:

```
kubectl get pod memory-demo --namespace=mem-example
```

查看Pod的详细信息:

```
kubectl get pod memory-demo --output=yaml --namespace=mem-example
```

这个输出显示了Pod里的容器申请了100M的内存和200M的内存限制。

```
...
resources:
  limits:
    memory: 200Mi
  requests:
    memory: 100Mi
...
```

启动proxy以便我们可以访问Heapster服务：

```
kubectl proxy
```

在另外一个命令行窗口，从Heapster服务获取内存使用情况：

```
curl http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/heapster/api/v1/model/namespaces/mem-example/pods/memory-demo/metrics/memory/usage
```

这个输出显示了Pod正在使用162,900,000字节的内存，大概就是150M。这很明显超过了申请 的100M,但是还没达到200M的限制。

```
{
 "timestamp": "2017-06-20T18:54:00Z",
 "value": 162856960
}
```

删除Pod:

```
kubectl delete pod memory-demo --namespace=mem-example
```

## 超出容器的内存限制

只要节点有足够的内存资源，那容器就可以使用超过其申请的内存，但是不允许容器使用超过其限制的  资源。如果容器分配了超过限制的内存，这个容器将会被优先结束。如果容器持续使用超过限制的内存，  这个容器就会被终结。如果一个结束的容器允许重启，kubelet就会重启他，但是会出现其他类型的运行错误。

本实验，我们创建一个Pod尝试分配超过其限制的内存，下面的这个Pod的配置文档，它申请50M的内存， 内存限制设置为100M。

| [memory-request-limit-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/memory-request-limit-2.yaml)![Copy memory-request-limit-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: memory-demo-2 spec:  containers:  - name: memory-demo-2-ctr    image: vish/stress    resources:      requests:        memory: 50Mi      limits:        memory: "100Mi"    args:    - -mem-total    - 250Mi    - -mem-alloc-size    - 10Mi    - -mem-alloc-sleep    - 1s ` |

在配置文件里的args段里，可以看到容器尝试分配250M的内存，超过了限制的100M。

创建Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/memory-request-limit-2.yaml --namespace=mem-example
```

查看Pod的详细信息:

```
kubectl get pod memory-demo-2 --namespace=mem-example
```

这时候，容器可能会运行，也可能会被杀掉。如果容器还没被杀掉，重复之前的命令直至 你看到这个容器被杀掉：

```
NAME            READY     STATUS      RESTARTS   AGE
memory-demo-2   0/1       OOMKilled   1          24s
```

查看容器更详细的信息:

```
kubectl get pod memory-demo-2 --output=yaml --namespace=mem-example
```

这个输出显示了容器被杀掉因为超出了内存限制。

```
lastState:
   terminated:
     containerID: docker://65183c1877aaec2e8427bc95609cc52677a454b56fcb24340dbd22917c23b10f
     exitCode: 137
     finishedAt: 2017-06-20T20:52:19Z
     reason: OOMKilled
     startedAt: null
```

本实验里的容器可以自动重启，因此kubelet会再去启动它。输入多几次这个命令看看它是怎么 被杀掉又被启动的：

```
kubectl get pod memory-demo-2 --namespace=mem-example
```

这个输出显示了容器被杀掉，被启动，又被杀掉，又被启动的过程：

```
stevepe@sperry-1:~/steveperry-53.github.io$ kubectl get pod memory-demo-2 --namespace=mem-example
NAME            READY     STATUS      RESTARTS   AGE
memory-demo-2   0/1       OOMKilled   1          37s
stevepe@sperry-1:~/steveperry-53.github.io$ kubectl get pod memory-demo-2 --namespace=mem-example
NAME            READY     STATUS    RESTARTS   AGE
memory-demo-2   1/1       Running   2          40s
```

查看Pod的历史详细信息:

```
kubectl describe pod memory-demo-2 --namespace=mem-example
```

这个输出显示了Pod一直重复着被杀掉又被启动的过程:

```
... Normal  Created   Created container with id 66a3a20aa7980e61be4922780bf9d24d1a1d8b7395c09861225b0eba1b1f8511
... Warning BackOff   Back-off restarting failed container
```

查看集群里节点的详细信息：

```
kubectl describe nodes
```

输出里面记录了容器被杀掉是因为一个超出内存的状况出现：

```
Warning OOMKilling  Memory cgroup out of memory: Kill process 4481 (stress) score 1994 or sacrifice child
```

删除Pod:

```
kubectl delete pod memory-demo-2 --namespace=mem-example
```

## 配置超出节点能力范围的内存申请

内存的申请和限制是针对容器本身的，但是认为Pod也有容器的申请和限制是一个很有帮助的想法。 Pod申请的内存就是Pod里容器申请的内存总和，类似的，Pod的内存限制就是Pod里所有容器的 内存限制的总和。

Pod的调度策略是基于请求的，只有当节点满足Pod的内存申请时，才会将Pod调度到合适的节点上。

在这个实验里，我们创建一个申请超大内存的Pod，超过了集群里任何一个节点的可用内存资源。 这个容器申请了1000G的内存，这个应该会超过你集群里能提供的数量。

| [memory-request-limit-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/memory-request-limit-3.yaml)![Copy memory-request-limit-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: memory-demo-3 spec:  containers:  - name: memory-demo-3-ctr    image: vish/stress    resources:      limits:        memory: "1000Gi"      requests:        memory: "1000Gi"    args:    - -mem-total    - 150Mi    - -mem-alloc-size    - 10Mi    - -mem-alloc-sleep    - 1s ` |

创建Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/memory-request-limit-3.yaml --namespace=mem-example
```

查看Pod的状态:

```
kubectl get pod memory-demo-3 --namespace=mem-example
```

输出显示Pod的状态是Pending，因为Pod不会被调度到任何节点，所有它会一直保持在Pending状态下。

```
kubectl get pod memory-demo-3 --namespace=mem-example
NAME            READY     STATUS    RESTARTS   AGE
memory-demo-3   0/1       Pending   0          25s
```

查看Pod的详细信息包括事件记录

```
kubectl describe pod memory-demo-3 --namespace=mem-example
```

这个输出显示容器不会被调度因为节点上没有足够的内存：

```
Events:
  ...  Reason            Message
       ------            -------
  ...  FailedScheduling  No nodes are available that match all of the following predicates:: Insufficient memory (3).
```

## 内存单位

内存资源是以字节为单位的，可以表示为纯整数或者固定的十进制数字，后缀可以是E, P, T, G, M, K, Ei, Pi, Ti, Gi, Mi, Ki.比如，下面几种写法表示相同的数值：alue:

```
128974848, 129e6, 129M , 123Mi
```

删除Pod:

```
kubectl delete pod memory-demo-3 --namespace=mem-example
```

## 如果不配置内存限制

如果不给容器配置内存限制，那下面的任意一种情况可能会出现：

- 容器使用内存资源没有上限，容器可以使用当前节点上所有可用的内存资源。
- 容器所运行的命名空间有默认内存限制，容器会自动继承默认的限制。集群管理员可以使用这个文档 [LimitRange](https://kubernetes.io/docs/api-reference/v1.6/)来配置默认的内存限制。

## 内存申请和限制的原因

通过配置容器的内存申请和限制，你可以更加有效充分的使用集群里内存资源。配置较少的内存申请， 可以让Pod跟任意被调度。设置超过内存申请的限制，可以达到以下效果：

- Pod可以在负载高峰时更加充分利用内存。
- 可以将Pod的内存使用限制在比较合理的范围。

## 清理

删除命名空间，这会顺便删除命名空间里的Pod。

```
kubectl delete namespace mem-example
```

译者：[NickSu86](https://github.com/NickSu86) [原文链接](https://k8smeetup.github.io/docs/tasks/configure-pod-container/assign-memory-resource/)

# Kubernetes 给容器和Pod分配CPU资源

- [1 Before you begin](http://docs.kubernetes.org.cn/728.html#Before_you_begin)
- [2 创建一个命名空间](http://docs.kubernetes.org.cn/728.html#i)
- [3 声明一个CPU申请和限制](http://docs.kubernetes.org.cn/728.html#CPU)
- [4 CPU 单位](http://docs.kubernetes.org.cn/728.html#CPU-2)
- [5 请求的CPU超出了节点的能力范围](http://docs.kubernetes.org.cn/728.html#CPU-3)
- [6 如果不指定CPU限额呢](http://docs.kubernetes.org.cn/728.html#CPU-4)
- [7 设置CPU申请和限制的动机](http://docs.kubernetes.org.cn/728.html#CPU-5)
- [8 清理](http://docs.kubernetes.org.cn/728.html#i-2)

这个教程指导如何给容器分配请求的CPU资源和配置CPU资源限制，我们保证容器可以拥有 所申请的CPU资源，但是并不允许它使用超过限制的CPU资源。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

集群里的每个节点至少需要1个CPU。

这篇教程里的少数步骤可能要求你的集群运行着[Heapster](https://github.com/kubernetes/heapster) 如果你没有Heapster，也可以完成大部分步骤，就算跳过Heapster的那些步骤，也不见得会有什么问题。

判断Heapster服务是否正常运行，执行以下命令：

```
kubectl get services --namespace=kube-system
```

如果heapster正常运行，命令的输出应该类似下面这样:

```
NAMESPACE    NAME      CLUSTER-IP    EXTERNAL-IP  PORT(S)  AGE
kube-system  heapster  10.11.240.9   <none>       80/TCP   6d
```

## 创建一个命名空间

创建一个命名空间，可以确保你在这个实验里所创建的资源都会被有效隔离， 不会影响你的集群。

```
kubectl create namespace cpu-example
```

## 声明一个CPU申请和限制

给容器声明一个CPU请求，只要在容器的配置文件里包含这么一句resources:requests就可以， 声明一个CPU限制，则是这么一句resources:limits.

在这个实验里，我们会创建一个只有一个容器的Pod，这个容器申请0.5个CPU，并且CPU限制设置为1. 下面是配置文件：

| [cpu-request-limit.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/cpu-request-limit.yaml)![Copy cpu-request-limit.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: cpu-demo spec:  containers:  - name: cpu-demo-ctr    image: vish/stress    resources:      limits:        cpu: "1"      requests:        cpu: "0.5"    args:    - -cpus    - "2" ` |

在这个配置文件里，整个args段提供了容器所需的参数。 -cpus "2"代码告诉容器尝试使用2个CPU资源。

创建Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/cpu-request-limit.yaml --namespace=cpu-example
```

验证Pod的容器是否正常运行:

```
kubectl get pod cpu-demo --namespace=cpu-example
```

查看Pod的详细信息:

```
kubectl get pod cpu-demo --output=yaml --namespace=cpu-example
```

输出显示了这个Pod里的容器申请了500m的cpu，同时CPU用量限制为1.

```
resources:
  limits:
    cpu: "1"
  requests:
    cpu: 500m
```

启用proxy以便访问heapster服务：

```
kubectl proxy
```

在另外一个命令窗口里，从heapster服务读取CPU使用率。

```
curl http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/heapster/api/v1/model/namespaces/cpu-example/pods/cpu-demo/metrics/cpu/usage_rate
```

输出显示Pod目前使用974m的cpu，这个刚好比配置文件里限制的1小一点点。

```
{
 "timestamp": "2017-06-22T18:48:00Z",
 "value": 974
}
```

还记得我吗设置了-cpu "2", 这样让容器尝试去使用2个CPU，但是容器却只被运行使用1一个， 因为容器的CPU使用被限制了，因为容器尝试去使用超过其限制的CPU资源。

注意: 有另外一个可能的解释为什么CPU会被限制。因为这个节点可能没有足够的CPU资源，还记得我们  这个实验的前提条件是每个节点都有至少一个CPU，如果你的容器所运行的节点只有1个CPU，那容器就无法  使用超过1个的CPU资源，这跟CPU配置上的限制以及没关系了。

## CPU 单位

CPU资源是以CPU单位来计算的，一个CPU，对于Kubernetes而言，相当于:

- 1 AWS vCPU
- 1 GCP Core
- 1 Azure vCore
- 1 Hyperthread on a bare-metal Intel processor with Hyperthreading

小数值也是允许的，一个容器申请0.5个CPU，就相当于其他容器申请1个CPU的一半，你也可以加个后缀m 表示千分之一的概念。比如说100m的CPU，100豪的CPU和0.1个CPU都是一样的。但是不支持精度超过1M的。

CPU通常都是以绝对值来申请的，绝对不能是一个相对的数值；0.1对于单核，双核，48核的CPU都是一样的。

删除Pod:

```
kubectl delete pod cpu-demo --namespace=cpu-example
```

## 请求的CPU超出了节点的能力范围

CPU资源的请求和限制是用于容器上面的，但是认为POD也有CPU资源的申请和限制，这种思想会很有帮助。 Pod的CPU申请可以看作Pod里的所有容器的CPU资源申请的总和，类似的，Pod的CPU限制就可以看出Pod里 所有容器的CPU资源限制的总和。

Pod调度是基于请求的，只有当Node的CPU资源可以满足Pod的需求的时候，Pod才会被调度到这个Node上面。

在这个实验当中，我们创建一个Pod请求超大的CPU资源，超过了集群里任何一个node所能提供的资源。 下面这个配置文件，创建一个包含一个容器的Pod。这个容器申请了100个CPU，这应该会超出你集群里 任何一个节点的CPU资源。

| [cpu-request-limit-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/cpu-request-limit-2.yaml)![Copy cpu-request-limit-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: cpu-demo-2 spec:  containers:  - name: cpu-demo-ctr-2    image: vish/stress    resources:      limits:        cpu: "100"      requests:        cpu: "100"    args:    - -cpus    - "2" ` |

创建Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/cpu-request-limit-2.yaml --namespace=cpu-example
```

查看Pod的状态:

```
kubectl get pod cpu-demo-2 --namespace=cpu-example
```

这个输出显示Pod正处在Pending状态，那是因为这个Pod并不会被调度到任何节点上，所以它会 一直保持这种状态。

```
kubectl get pod cpu-demo-2 --namespace=cpu-example
NAME         READY     STATUS    RESTARTS   AGE
cpu-demo-2   0/1       Pending   0          7m
```

查看Pod的详细信息，包括记录的事件：

```
kubectl describe pod cpu-demo-2 --namespace=cpu-example
```

这个输出显示了容器无法被调度因为节点上没有足够的CPU资源：

```
Events:
  Reason			Message
  ------			-------
  FailedScheduling	No nodes are available that match all of the following predicates:: Insufficient cpu (3).
```

删除Pod:

```
kubectl delete pod cpu-demo-2 --namespace=cpu-example
```

## 如果不指定CPU限额呢

如果你不指定容器的CPU限额，那下面所描述的其中一种情况会出现：

- 容器使用CPU资源没有上限，它可以使用它运行的Node上所有的CPU资源。
- 容器所运行的命名空间有默认的CPU限制，这个容器就自动继承了这个限制。集群管理可以使用 [限额范围](https://kubernetes.io/docs/api-reference/v1.6/) 来指定一个默认的CPU限额。

## 设置CPU申请和限制的动机

通过配置集群里的容器的CPU资源申请和限制，我们可以更好的利用集群中各个节点的CPU资源。 保持Pod的CPU请求不太高，这样才能更好的被调度。设置一个大于CPU请求的限制，可以获得以下 两点优势：

- Pod 在业务高峰期能获取到足够的CPU资源。
- 能将Pod在需求高峰期能使用的CPU资源限制在合理范围。

## 清理

删除你的命名空间:

```
kubectl delete namespace cpu-example
```

译者：[NickSu86](https://github.com/NickSu86) [原文链接](https://k8smeetup.github.io/docs/tasks/configure-pod-container/assign-cpu-resource/)

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# Kubernetes 给 Pod 配置服务质量等级

- [1 Before you begin](http://docs.kubernetes.org.cn/751.html#Before_you_begin)
- [2 QoS 等级](http://docs.kubernetes.org.cn/751.html#QoS)
- [3 创建一个命名空间](http://docs.kubernetes.org.cn/751.html#i)
- [4 创建一个 Pod 并分配 QoS 等级为 Guaranteed](http://docs.kubernetes.org.cn/751.html#_Pod_QoS_Guaranteed)
- [5 创建一个 Pod 并分配 QoS 等级为 Burstable](http://docs.kubernetes.org.cn/751.html#_Pod_QoS_Burstable)
- [6 创建一个 Pod 并分配 QoS 等级为 BestEffort](http://docs.kubernetes.org.cn/751.html#_Pod_QoS_BestEffort)
- [7 创建一个拥有两个容器的 Pod](http://docs.kubernetes.org.cn/751.html#_Pod)
- [8 清理](http://docs.kubernetes.org.cn/751.html#i-2)
- 9 What’s next
  - [9.1 对于集群管理员](http://docs.kubernetes.org.cn/751.html#i-3)
  - [9.2 对于应用开发者](http://docs.kubernetes.org.cn/751.html#i-4)

这篇教程指导如何给 Pod 配置特定的服务质量（QoS）等级。Kubernetes 使用 QoS 等级来确定何时调度和终结 Pod 。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](https://k8smeetup.github.io/docs/getting-started-guides/minikube).

## QoS 等级

当 Kubernetes 创建一个 Pod 时，它就会给这个 Pod 分配一个 QoS 等级：

- Guaranteed
- Burstable
- BestEffort

## 创建一个命名空间

创建一个命名空间，以便将我们实验需求的资源与集群其他资源隔离开。

```
kubectl create namespace qos-example
```

## 创建一个 Pod 并分配 QoS 等级为 Guaranteed

想要给 Pod 分配 QoS 等级为 Guaranteed:

- Pod 里的每个容器都必须有内存限制和请求，而且必须是一样的。
- Pod 里的每个容器都必须有 CPU 限制和请求，而且必须是一样的。

这是一个含有一个容器的 Pod 的配置文件。这个容器配置了内存限制和请求，都是200MB。它还有 CPU 限制和请求，都是700 millicpu:

| [qos-pod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/qos-pod.yaml)![Copy qos-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: qos-demo spec:  containers:  - name: qos-demo-ctr    image: nginx    resources:      limits:        memory: "200Mi"        cpu: "700m"      requests:        memory: "200Mi"        cpu: "700m" ` |

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/qos-pod.yaml --namespace=qos-example
```

查看 Pod 的详细信息:

```
kubectl get pod qos-demo --namespace=qos-example --output=yaml
```

输出显示了 Kubernetes 给 Pod 配置的 QoS 等级为 Guaranteed 。也验证了容器的内存和 CPU 的限制都满足了它的请求。

```
spec:
  containers:
    ...
    resources:
      limits:
        cpu: 700m
        memory: 200Mi
      requests:
        cpu: 700m
        memory: 200Mi
...
  qosClass: Guaranteed
```

注意: 如果一个容器配置了内存限制，但是没有配置内存申请，那 Kubernetes 会自动给容器分配一个符合内存限制的请求。 类似的，如果容器有 CPU 限制，但是没有 CPU 申请，Kubernetes 也会自动分配一个符合限制的请求。

删除你的 Pod:

```
kubectl delete pod qos-demo --namespace=qos-example
```

## 创建一个 Pod 并分配 QoS 等级为 Burstable

当出现下面的情况时，则是一个 Pod 被分配了 QoS 等级为 Burstable :

- 该 Pod 不满足 QoS 等级 Guaranteed 的要求。
- Pod 里至少有一个容器有内存或者 CPU 请求。

这是 Pod 的配置文件，里面有一个容器。这个容器配置了200MB的内存限制和100MB的内存申请。

| [qos-pod-2.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/qos-pod-2.yaml)![Copy qos-pod-2.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: qos-demo-2 spec:  containers:  - name: qos-demo-2-ctr    image: nginx    resources:      limits:        memory: "200Mi"      requests:        memory: "100Mi" ` |

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/qos-pod-2.yaml --namespace=qos-example
```

查看 Pod 的详细信息:

```
kubectl get pod qos-demo-2 --namespace=qos-example --output=yaml
```

输出显示了 Kubernetes 给这个 Pod 配置了 QoS 等级为 Burstable.

```
spec:
  containers:
  - image: nginx
    imagePullPolicy: Always
    name: qos-demo-2-ctr
    resources:
      limits:
        memory: 200Mi
      requests:
        memory: 100Mi
...
  qosClass: Burstable
```

删除你的 Pod:

```
kubectl delete pod qos-demo-2 --namespace=qos-example
```

## 创建一个 Pod 并分配 QoS 等级为 BestEffort

要给一个 Pod 配置 BestEffort 的 QoS 等级, Pod 里的容器必须没有任何内存或者 CPU　的限制或请求。

下面是一个　Pod　的配置文件，包含一个容器。这个容器没有内存或者 CPU 的限制或者请求：

| [qos-pod-3.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/qos-pod-3.yaml)![Copy qos-pod-3.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: qos-demo-3 spec:  containers:  - name: qos-demo-3-ctr    image: nginx ` |

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/qos-pod-3.yaml --namespace=qos-example
```

查看 Pod 的详细信息:

```
kubectl get pod qos-demo-3 --namespace=qos-example --output=yaml
```

输出显示了 Kubernetes 给 Pod 配置的 QoS 等级是 BestEffort.

```
spec:
  containers:
    ...
    resources: {}
  ...
  qosClass: BestEffort
```

删除你的 Pod:

```
kubectl delete pod qos-demo-3 --namespace=qos-example
```

## 创建一个拥有两个容器的 Pod

这是一个含有两个容器的 Pod 的配置文件，其中一个容器指定了内存申请为 200MB ，另外一个没有任何申请或限制。

| [qos-pod-4.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tasks/configure-pod-container/qos-pod-4.yaml)![Copy qos-pod-4.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: qos-demo-4 spec:  containers:   - name: qos-demo-4-ctr-1    image: nginx    resources:      requests:        memory: "200Mi"   - name: qos-demo-4-ctr-2    image: redis ` |

注意到这个 Pod 满足了 QoS 等级 Burstable 的要求. 就是说，它不满足 Guaranteed 的要求，而且其中一个容器有内存请求。

创建 Pod:

```
kubectl create -f https://k8s.io/docs/tasks/configure-pod-container/qos-pod-4.yaml --namespace=qos-example
```

查看 Pod 的详细信息:

```
kubectl get pod qos-demo-4 --namespace=qos-example --output=yaml
```

输出显示了 Kubernetes 给 Pod 配置的 QoS 等级是 Burstable:

```
spec:
  containers:
    ...
    name: qos-demo-4-ctr-1
    resources:
      requests:
        memory: 200Mi
    ...
    name: qos-demo-4-ctr-2
    resources: {}
    ...
  qosClass: Burstable
```

删除你的 Pod:

```
kubectl delete pod qos-demo-4 --namespace=qos-example
```

## 清理

删除你的 namespace:

```
kubectl delete namespace qos-example
```

## What’s next

# Kubernetes Pod 优先级和抢占

- [1 怎么样使用优先级和抢占](http://docs.kubernetes.org.cn/769.html#i)
- [2 启用优先级和抢占](http://docs.kubernetes.org.cn/769.html#i-2)
- 3 PriorityClass
  - [3.1 PriorityClass 示例](http://docs.kubernetes.org.cn/769.html#PriorityClass-2)
- [4 Pod priority](http://docs.kubernetes.org.cn/769.html#Pod_priority)
- 5 抢占
  - 5.1 限制抢占（alpha 版本）
    - [5.1.1 饥饿式抢占](http://docs.kubernetes.org.cn/769.html#i-4)
    - [5.1.2 PodDisruptionBudget is not supported](http://docs.kubernetes.org.cn/769.html#PodDisruptionBudget_is_not_supported)
    - [5.1.3 低优先级 Pod 之间的亲和性](http://docs.kubernetes.org.cn/769.html#_Pod)
    - [5.1.4 跨节点抢占](http://docs.kubernetes.org.cn/769.html#i-5)

FEATURE STATE: Kubernetes v1.8 alpha

Kubernetes 1.8 及其以后的版本中可以指定 Pod 的优先级。优先级表明了一个 Pod 相对于其它 Pod 的重要性。当  Pod 无法被调度时，scheduler 会尝试抢占（驱逐）低优先级的 Pod，使得这些挂起的 pod 可以被调度。在 Kubernetes  未来的发布版本中，优先级也会影响节点上资源回收的排序。

注： 抢占不遵循 PodDisruptionBudget；更多详细的信息，请查看 [限制部分](http://docs.kubernetes.org.cn/769.html#alpha)。

## 怎么样使用优先级和抢占

想要在 Kubernetes 1.8 版本中使用优先级和抢占，请参考如下步骤：

1. 启用功能。
2. 增加一个或者多个 PriorityClass。
3. 创建拥有字段 PriorityClassName 的 Pod，该字段的值选取上面增加的  PriorityClass。当然，您没有必要直接创建 pod，通常您可以把 PriorityClassName 增加到类似 Deployment 这样的集合对象的 Pod 模板中。

以下章节提供了有关这些步骤的详细信息。

## 启用优先级和抢占

Kubernetes 1.8 版本默认没有开启 Pod 优先级和抢占。为了启用该功能，需要在 API server 和 scheduler 的启动参数中设置：

```
--feature-gates=PodPriority=true
```

在 API server 中还需要设置如下启动参数：

```
--runtime-config=scheduling.k8s.io/v1alpha1=true
```

功能启用后，您能创建 [PriorityClass](http://docs.kubernetes.org.cn/769.html#PriorityClass)，也能创建使用 [PriorityClassName](https://k8smeetup.github.io/docs/concepts/configuration/pod-priority-preemption/#pod-priority) 集的 Pod。

如果在尝试该功能后想要关闭它，那么您可以把 PodPriority  这个命令行标识从启动参数中移除，或者将它的值设置为false，然后再重启 API server 和 scheduler。功能关闭后，原来的  Pod 会保留它们的优先级字段，但是优先级字段的内容会被忽略，抢占不会生效，在新的 pod 创建时，您也不能设置  PriorityClassName。

## PriorityClass

PriorityClass 是一个不受命名空间约束的对象，它定义了优先级类名跟优先级整数值的映射。它的名称通过 PriorityClass 对象 metadata 中的 name 字段指定。值在必选的 value 字段中指定。值越大，优先级越高。

PriorityClass 对象的值可以是小于或者等于 10 亿的 32 位任意整数值。更大的数值被保留给那些通常不应该取代或者驱逐的关键的系统级 Pod 使用。集群管理员应该为它们想要的每个此类映射创建一个 PriorityClass 对象。

PriorityClass 还有两个可选的字段：globalDefault 和 description。globalDefault 表示  PriorityClass 的值应该给那些没有设置 PriorityClassName 的 Pod  使用。整个系统只能存在一个 globalDefault 设置为 true 的  PriorityClass。如果没有任何 globalDefault 为 true 的 PriorityClass  存在，那么，那些没有设置 PriorityClassName 的 Pod 的优先级将为 0。

description 字段的值可以是任意的字符串。它向所有集群用户描述应该在什么时候使用这个 PriorityClass。

注1：如果您升级已经存在的集群环境，并且启用了该功能，那么，那些已经存在系统里面的 Pod 的优先级将会设置为 0。

注2：此外，将一个 PriorityClass 的 globalDefault 设置为 true，不会改变系统中已经存在的 Pod  的优先级。也就是说，PriorityClass 的值只能用于在 PriorityClass 添加之后创建的那些 Pod 当中。

注3：如果您删除一个 PriorityClass，那些使用了该 PriorityClass 的 Pod 将会保持不变，但是，该 PriorityClass 的名称不能在新创建的 Pod 里面使用。

### PriorityClass 示例

```
apiVersion: v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000
globalDefault: false
description: "This priority class should be used for XYZ service pods only."
```

## Pod priority

有了一个或者多个 PriorityClass 之后，您在创建 Pod 时就能在模板文件中指定需要使用的 PriorityClass  的名称。优先级准入控制器通过 priorityClassName 字段查找优先级数值并且填入 Pod 中。如果没有找到相应的  PriorityClass，Pod 将会被拒绝创建。

下面的 YAML 是一个使用了前面创建的 PriorityClass 对 Pod 进行配置的示例。优先级准入控制器会检测配置文件，并将该 Pod 的优先级解析为 1000000。

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  priorityClassName: high-priority
```

## 抢占

Pod 生成后，会进入一个队列等待调度。scheduler 从队列中选择一个  Pod，然后尝试将其调度到某个节点上。如果没有任何节点能够满足 Pod 指定的所有要求，对于这个挂起的  Pod，抢占逻辑就会被触发。当前假设我们把挂起的 Pod 称之为 P。抢占逻辑会尝试查找一个节点，在该节点上移除一个或多个比 P 优先级低的  Pod 后， P 能够调度到这个节点上。如果节点找到了，部分优先级低的 Pod 就会从该节点删除。Pod 消失后，P 就能被调度到这个节点上了。

### 限制抢占（alpha 版本）

#### 饥饿式抢占

Pod 被抢占时，受害者（被抢占的 Pod）会有 [优雅终止期](http://docs.kubernetes.org.cn/312.html)。他们有大量的时间完成工作并退出。如果他们不这么做，就会被强行杀死。这个优雅中止期在调度抢占 Pod 以及挂起的 Pod（P）能够被调度到节点（N）之间形成了一个时间间隔。在此期间，调度会继续对其它挂起的 Pod  进行调度。当受害者退出或者终止的时候，scheduler 尝试调度挂起队列中的 Pod，在 scheduler 正式把 Pod P 调度到节点 N 之前，会继续考虑把其它 Pod 调度到节点 N 上。这种情况下，当所有受害者退出时，很有可能 Pod P 已经不再适合于节点  N。因此，scheduler 将不得不抢占节点 N 上的其它 Pod，或者抢占其它节点，以便 P  能被调度。这种情况可能会在第二轮和随后的抢占回合中再次重复，而 P  可能在一段时间内得不到调度。这种场景可能会导致各种集群中的问题，特别是在具有高 Pod 创建率的集群中。

我们将在 Pod 抢占的 beta 版本解决这个问题。计划的解决方案可以在 这里 找到。

#### PodDisruptionBudget is not supported

Pod 破坏预算（Pod Disruption  Budget，PDB） 允许应用程序所有者在自愿中断应用的同时限制应用副本的数量。然而，抢占的 alpha 版本在选择抢占受害者时，并没有遵循  PDB。我们计划在 beta 版本增加对 PDB 遵循的支持，但即使是在 beta 版本，也只能做到尽力支持。scheduler  将会试图查找那些不会违反 PDB 的受害者，如果这样的受害者没有找到，抢占依然会发生，即便违反了 PDB，这些低优先级的 Pod 仍将被删除。

#### 低优先级 Pod 之间的亲和性

在版本1.8中，只有当这个问题的答案是肯定的时候才考虑一个节点使用抢占：“如果优先级低于挂起的 Pod 的所有 Pod 从节点中移除后，挂起的 Pod 是否能够被调度到该节点上？”

注： 抢占没有必要移除所有低优先级的 Pod。如果在不移除所有低优先级的 Pod 的情况下，挂起的 Pod 就能调度到节点上，那么就只需要移除部分低优先级的 Pod。即便如此，上述问题的答案还需要是肯定的。如果答案是否定的，抢占功能不会考虑该节点。

如果挂起的 Pod 对节点上的一个或多个较低优先级的 Pod 具有亲和性，那么在没有那些较低优先级的 Pod 的情况下，无法满足 Pod  关联规则。这种情况下，scheduler 不抢占节点上的任何 Pod。它会去查找另外的节点。scheduler  有可能会找到合适的节点，也有可能无法找到，因此挂起的 Pod 并不能保证都能被调度。

我们可能会在未来的版本中解决这个问题，但目前还没有一个明确的计划。我们也不会因为它而对 beta 或者 GA  版本的推进有所阻滞。部分原因是，要查找满足 Pod 亲和性规则的低优先级 Pod  集的计算过程非常昂贵，并且抢占过程也增加了大量复杂的逻辑。此外，即便在抢占过程中保留了这些低优先级的 Pod，从而满足了 Pod  间的亲和性，这些低优先级的 Pod 也可能会在后面被其它 Pod 给抢占掉，这就抵消了遵循 Pod 亲和性的复杂逻辑带来的好处。

对于这个问题，我们推荐的解决方案是：对于 Pod 亲和性，只跟相同或者更高优先级的 Pod 之间进行创建。

#### 跨节点抢占

假定节点 N 启用了抢占功能，以便我们能够把挂起的 Pod P 调度到节点 N 上。只有其它节点的 Pod 被抢占时，P 才有可能被调度到节点 N 上面。下面是一个示例：

- Pod P 正在考虑节点 N。
- Pod Q 正运行在跟节点 N 同区的另外一个节点上。
- Pod P 跟 Pod Q 之间有反亲和性。
- 在这个区域内没有跟 Pod P 具备反亲和性的其它 Pod。
- 为了将 Pod P 调度到节点 N 上，Pod Q 需要被抢占掉，但是 scheduler 不能执行跨节点的抢占。因此，节点 N 将被视为不可调度节点。

如果将 Pod Q 从它的节点移除，反亲和性随之消失，那么 Pod P 就有可能被调度到节点 N 上。

如果找到一个性能合理的算法，我们可以考虑在将来的版本中增加跨节点抢占。在这一点上，我们不能承诺任何东西，beta 或者 GA 版本也不会因为跨节点抢占功能而有所阻滞。

# Kubernetes 使用 PodPreset 将信息注入 Pods

- [1 什么是 Pod Preset？](http://docs.kubernetes.org.cn/789.html#_Pod_Preset)
- 2 准入控制
  - [2.1 行为](http://docs.kubernetes.org.cn/789.html#i-2)
- [3 启用 Pod Preset](http://docs.kubernetes.org.cn/789.html#_Pod_Preset-2)
- [4 为 Pod 禁用 Pod Preset](http://docs.kubernetes.org.cn/789.html#_Pod_Pod_Preset)
- 5 创建 Pod Preset
  - [5.1 简单的 Pod Spec 示例](http://docs.kubernetes.org.cn/789.html#_Pod_Spec)
  - [5.2 带有 ConfigMap 的 Pod Spec 示例](http://docs.kubernetes.org.cn/789.html#ConfigMap_Pod_Spec)
  - [5.3 带有 Pod Spec 的 ReplicaSet 示例](http://docs.kubernetes.org.cn/789.html#_Pod_Spec_ReplicaSet)
  - [5.4 多 PodPreset 示例](http://docs.kubernetes.org.cn/789.html#_PodPreset)
  - [5.5 冲突示例](http://docs.kubernetes.org.cn/789.html#i-3)
- [6 删除 Pod Preset](http://docs.kubernetes.org.cn/789.html#_Pod_Preset-4)

在 pod 创建时，用户可以使用 podpreset 对象将特定信息注入 pod 中，这些信息可以包括 secret、 卷、 卷挂载和环境变量。

查看 [PodPreset 提案](https://git.k8s.io/community/contributors/design-proposals/service-catalog/pod-preset.md) 了解更多信息。

## 什么是 Pod Preset？

Pod Preset 是一种 API 资源，在 pod 创建时，用户可以用它将额外的运行时需求信息注入 pod。 使用标签选择器（label selector）来指定 Pod Preset 所适用的 pod。 查看更多关于 [标签选择器](http://docs.kubernetes.org.cn/247.html) 的信息。

使用 Pod Preset 使得 pod 模板编写者不必显式地为每个 pod 设置信息。 这样，使用特定服务的 pod 模板编写者不需要了解该服务的所有细节。

## 准入控制

准入控制 是指 Kubernetes 如何将 Pod Preset 应用于接收到的创建请求中。 当出现创建请求时，系统会执行以下操作：

1. 检索全部可用 PodPresets 。
2. 对 PodPreset 的标签选择器和要创建的 pod 进行匹配。
3. 尝试合并 PodPreset 中定义的各种资源，并注入要创建的 pod。
4. 发生错误时抛出事件，该事件记录了 pod 信息合并错误，同时_不注入_ PodPreset 信息创建 pod。

### 行为

当 PodPreset 应用于一个或多个 Pod 时， Kubernetes 修改 pod spec。  对于 Env、 EnvFrom 和 VolumeMounts 的改动， Kubernetes 修改 pod 中所有容器的规格，  对于卷的改动，Kubernetes 修改 Pod spec。

Kubernetes 为改动的 pod spec 添加注解，来表明它被 PodPreset 所修改。  注解形如： podpreset.admission.kubernetes.io/podpreset-<pod-preset  name>": "<resource version>"。

## 启用 Pod Preset

为了在集群中使用 Pod Preset，必须确保以下内容

1. 已启用 api 类型 settings.k8s.io/v1alpha1/podpreset
2. 已启用准入控制器 PodPreset
3. 已定义 pod preset

## 为 Pod 禁用 Pod Preset

在一些情况下，用户不希望 pod 被 pod preset 所改动，这时，用户可以在 pod spec 中添加形如 podpreset.admission.kubernetes.io/exclude: "true" 的注解。

## 创建 Pod Preset

### 简单的 Pod Spec 示例

这里是一个简单的示例，展示了如何通过 Pod Preset 修改 Pod spec 。

用户提交的 pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
spec:
  containers:
    - name: website
      image: ecorp/website
      ports:
        - containerPort: 80
```

Pod Preset 示例：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: allow-database
  namespace: myns
spec:
  selector:
    matchLabels:
      role: frontend
  env:
    - name: DB_PORT
      value: "6379"
  volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
    - name: cache-volume
      emptyDir: {}
```

通过准入控制器后的 Pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
  annotations:
    podpreset.admission.kubernetes.io/podpreset-allow-database: "resource version"
spec:
  containers:
    - name: website
      image: ecorp/website
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
      ports:
        - containerPort: 80
      env:
        - name: DB_PORT
          value: "6379"
  volumes:
    - name: cache-volume
      emptyDir: {}
```

### 带有 ConfigMap 的 Pod Spec 示例

这里的示例展示了如何通过 Pod Preset 修改 Pod spec，Pod Preset 中定义了 ConfigMap 作为环境变量取值来源。

用户提交的 pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
spec:
  containers:
    - name: website
      image: ecorp/website
      ports:
        - containerPort: 80
```

用户提交的 ConfigMap：

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: etcd-env-config
data:
  number_of_members: "1"
  initial_cluster_state: new
  initial_cluster_token: DUMMY_ETCD_INITIAL_CLUSTER_TOKEN
  discovery_token: DUMMY_ETCD_DISCOVERY_TOKEN
  discovery_url: http://etcd_discovery:2379
  etcdctl_peers: http://etcd:2379
  duplicate_key: FROM_CONFIG_MAP
  REPLACE_ME: "a value"
```

Pod Preset 示例：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: allow-database
  namespace: myns
spec:
  selector:
    matchLabels:
      role: frontend
  env:
    - name: DB_PORT
      value: 6379
    - name: duplicate_key
      value: FROM_ENV
    - name: expansion
      value: $(REPLACE_ME)
  envFrom:
    - configMapRef:
        name: etcd-env-config
  volumeMounts:
    - mountPath: /cache
      name: cache-volume
    - mountPath: /etc/app/config.json
      readOnly: true
      name: secret-volume
  volumes:
    - name: cache-volume
      emptyDir: {}
    - name: secret-volume
      secret:
         secretName: config-details
```

通过准入控制器后的 Pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
  annotations:
    podpreset.admission.kubernetes.io/podpreset-allow-database: "resource version"
spec:
  containers:
    - name: website
      image: ecorp/website
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
        - mountPath: /etc/app/config.json
          readOnly: true
          name: secret-volume
      ports:
        - containerPort: 80
      env:
        - name: DB_PORT
          value: "6379"
        - name: duplicate_key
          value: FROM_ENV
        - name: expansion
          value: $(REPLACE_ME)
      envFrom:
        - configMapRef:
          name: etcd-env-config
  volumes:
    - name: cache-volume
      emptyDir: {}
    - name: secret-volume
      secret:
         secretName: config-details
```

### 带有 Pod Spec 的 ReplicaSet 示例

以下示例展示了（通过 ReplicaSet 创建 pod 后）只有 pod spec 会被 Pod Preset 所修改。

用户提交的 ReplicaSet：

```
apiVersion: settings.k8s.io/v1alpha1
kind: ReplicaSet
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
    matchExpressions:
      - {key: tier, operator: In, values: [frontend]}
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
          - name: GET_HOSTS_FROM
            value: dns
        ports:
          - containerPort: 80
```

Pod Preset 示例：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: allow-database
  namespace: myns
spec:
  selector:
    matchLabels:
      tier: frontend
  env:
    - name: DB_PORT
      value: "6379"
  volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
    - name: cache-volume
      emptyDir: {}
```

通过准入控制器后的 Pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: guestbook
    tier: frontend
  annotations:
    podpreset.admission.kubernetes.io/podpreset-allow-database: "resource version"
spec:
  containers:
  - name: php-redis
    image: gcr.io/google_samples/gb-frontend:v3
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
    env:
    - name: GET_HOSTS_FROM
      value: dns
    - name: DB_PORT
      value: "6379"
    ports:
    - containerPort: 80
  volumes:
  - name: cache-volume
    emptyDir: {}
```

### 多 PodPreset 示例

这里的示例展示了如何通过多个 Pod 注入策略修改 Pod spec。

用户提交的 pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
spec:
  containers:
    - name: website
      image: ecorp/website
      ports:
        - containerPort: 80
```

Pod Preset 示例：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: allow-database
  namespace: myns
spec:
  selector:
    matchLabels:
      role: frontend
  env:
    - name: DB_PORT
      value: "6379"
  volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
    - name: cache-volume
      emptyDir: {}
```

另一个 Pod Preset：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: proxy
  namespace: myns
spec:
  selector:
    matchLabels:
      role: frontend
  volumeMounts:
    - mountPath: /etc/proxy/configs
      name: proxy-volume
  volumes:
    - name: proxy-volume
      emptyDir: {}
```

通过准入控制器后的 Pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
  annotations:
    podpreset.admission.kubernetes.io/podpreset-allow-database: "resource version"
    podpreset.admission.kubernetes.io/podpreset-proxy: "resource version"
spec:
  containers:
    - name: website
      image: ecorp/website
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
        - mountPath: /etc/proxy/configs
          name: proxy-volume
      ports:
        - containerPort: 80
      env:
        - name: DB_PORT
          value: "6379"
  volumes:
    - name: cache-volume
      emptyDir: {}
    - name: proxy-volume
      emptyDir: {}
```

### 冲突示例

这里的示例展示了 Pod Preset 与原 Pod 存在冲突时，Pod spec 不会被修改。

用户提交的 pod spec：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
spec:
  containers:
    - name: website
      image: ecorp/website
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
      ports:
  volumes:
    - name: cache-volume
      emptyDir: {}
        - containerPort: 80
```

Pod Preset 示例：

```
kind: PodPreset
apiVersion: settings.k8s.io/v1alpha1
metadata:
  name: allow-database
  namespace: myns
spec:
  selector:
    matchLabels:
      role: frontend
  env:
    - name: DB_PORT
      value: "6379"
  volumeMounts:
    - mountPath: /cache
      name: other-volume
  volumes:
    - name: other-volume
      emptyDir: {}
```

因存在冲突，通过准入控制器后的 Pod spec 不会改变：

```
apiVersion: v1
kind: Pod
metadata:
  name: website
  labels:
    app: website
    role: frontend
spec:
  containers:
    - name: website
      image: ecorp/website
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
      ports:
        - containerPort: 80
  volumes:
    - name: cache-volume
      emptyDir: {}
```

如果运行 kubectl describe... 用户会看到以下事件：

```
$ kubectl describe ...
....
Events:
  FirstSeen             LastSeen            Count   From                    SubobjectPath               Reason      Message
  Tue, 07 Feb 2017 16:56:12 -0700   Tue, 07 Feb 2017 16:56:12 -0700 1   {podpreset.admission.kubernetes.io/podpreset-allow-database }    conflict  Conflict on pod preset. Duplicate mountPath /cache.
```

## 删除 Pod Preset

一旦用户不再需要 pod preset，可以使用 kubectl 进行删除：

```
$ kubectl delete podpreset allow-database
podpreset "allow-database" deleted
```

译者：[lichuqiang](https://github.com/lichuqiang) / [原文链接](https://k8smeetup.github.io/docs/tasks/inject-data-application/podpreset/)

# kubernetes 通过环境变量向容器暴露 Pod 信息

- [1 Before you begin](http://docs.kubernetes.org.cn/830.html#Before_you_begin)
- [2 Downward API](http://docs.kubernetes.org.cn/830.html#Downward_API)
- [3 使用 Pod 字段作为环境变量的值](http://docs.kubernetes.org.cn/830.html#_Pod)
- [4 使用容器字段作为环境变量的值](http://docs.kubernetes.org.cn/830.html#i)

本页展示了 Pod 如何使用环境变量向 Pod 中运行的容器暴露有关自身的信息。环境变量可以暴露 Pod 字段和容器字段。

## Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line  tool must be configured to communicate with your cluster. If you do not  already have a cluster, you can create one by using [Minikube](http://docs.kubernetes.org.cn/94.html), or you can use one of these Kubernetes playgrounds:

- [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
- [Play with Kubernetes](http://labs.play-with-k8s.com/)

To check the version, enter kubectl version.

## Downward API

有两种方式将 Pod 和容器字段暴露给运行中的容器：

- 环境变量
- [DownwardAPIVolumeFiles](https://k8smeetup.github.io/docs/api-reference/v1.9/#downwardapivolumefile-v1-core)

这两种暴露 Pod 和容器字段的方式被称为 Downward API。

## 使用 Pod 字段作为环境变量的值

在本练习中，您将创建一个有一个容器的 Pod。下面是POD的配置文件：

| [dapi-envars-pod.yaml ](https://raw.githubusercontent.com/kubernetes/website/master/docs/tasks/inject-data-application/dapi-envars-pod.yaml)![Copy dapi-envars-pod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: dapi-envars-fieldref spec:  containers:    - name: test-container      image: k8s.gcr.io/busybox      command: [ "sh", "-c"]      args:      - while true; do          echo -en '\n';          printenv MY_NODE_NAME MY_POD_NAME MY_POD_NAMESPACE;          printenv MY_POD_IP MY_POD_SERVICE_ACCOUNT;          sleep 10;        done;      env:        - name: MY_NODE_NAME          valueFrom:            fieldRef:              fieldPath: spec.nodeName        - name: MY_POD_NAME          valueFrom:            fieldRef:              fieldPath: metadata.name        - name: MY_POD_NAMESPACE          valueFrom:            fieldRef:              fieldPath: metadata.namespace        - name: MY_POD_IP          valueFrom:            fieldRef:              fieldPath: status.podIP        - name: MY_POD_SERVICE_ACCOUNT          valueFrom:            fieldRef:              fieldPath: spec.serviceAccountName  restartPolicy: Never ` |

在配置文件中，您可以看到五个环境变量。env 字段是 [EnvVars](https://k8smeetup.github.io/docs/api-reference/v1.9/#envvar-v1-core) 的数组。数组中的第一个元素指定 MY_NODE_NAME 环境变量从 Pod 的 spec.nodeName 字段中获取其值。类似地，其他环境变量从 Pod 字段中获取它们的名称。

注意： 示例中的字段是 Pod 的字段。它们不是 Pod 中的容器的字段。

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/inject-data-application/dapi-envars-pod.yaml
```

验证 Pod 中的容器是 running 状态：

```
kubectl get pods
```

查看容器日志：

```
kubectl logs dapi-envars-fieldref
```

输出显示选定的环境变量的值：

```
minikube
dapi-envars-fieldref
default
172.17.0.4
default
```

想要知道为什么这些值会打印在日志中，请查看配置文件的 command 和 args 字段。当容器启动时，它将 5 个环境变量的值写到标准输出中。每十秒钟重复一次。

接下来，将一个 shell 放入正在您的 Pod 中运行的容器里面：

```
kubectl exec -it dapi-envars-fieldref -- sh
```

在 shell 中，查看环境变量：

```
/# printenv
```

输出结果显示，某些环境变量已被指定为 Pod 字段的值：

```
MY_POD_SERVICE_ACCOUNT=default
...
MY_POD_NAMESPACE=default
MY_POD_IP=172.17.0.4
...
MY_NODE_NAME=minikube
...
MY_POD_NAME=dapi-envars-fieldref
```

## 使用容器字段作为环境变量的值

在前面的练习中，您使用 Pod 字段作为环境变量的值。在下一个练习中，您将使用容器字段用作环境变量的值。下面是一个 Pod 的配置文件，其中包含一个容器：

| [dapi-envars-container.yaml ](https://raw.githubusercontent.com/kubernetes/website/master/docs/tasks/inject-data-application/dapi-envars-container.yaml)![Copy dapi-envars-container.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Pod metadata:  name: dapi-envars-resourcefieldref spec:  containers:    - name: test-container      image: k8s.gcr.io/busybox:1.24      command: [ "sh", "-c"]      args:      - while true; do          echo -en '\n';          printenv MY_CPU_REQUEST MY_CPU_LIMIT;          printenv MY_MEM_REQUEST MY_MEM_LIMIT;          sleep 10;        done;      resources:        requests:          memory: "32Mi"          cpu: "125m"        limits:          memory: "64Mi"          cpu: "250m"      env:        - name: MY_CPU_REQUEST          valueFrom:            resourceFieldRef:              containerName: test-container              resource: requests.cpu        - name: MY_CPU_LIMIT          valueFrom:            resourceFieldRef:              containerName: test-container              resource: limits.cpu        - name: MY_MEM_REQUEST          valueFrom:            resourceFieldRef:              containerName: test-container              resource: requests.memory        - name: MY_MEM_LIMIT          valueFrom:            resourceFieldRef:              containerName: test-container              resource: limits.memory  restartPolicy: Never ` |

在配置文件中，您可以看到四个环境变量。env 字段是 EnvVars 的数组。数组中的第一个元素指定 MY_CPU_REQUEST 环境变量从名为 test-container 的容器的 requests.cpu 字段中获取其值。类似地，其他环境变量从容器字段中获取它们的值。

创建 Pod：

```
kubectl create -f https://k8s.io/docs/tasks/inject-data-application/dapi-envars-container.yaml
```

验证 Pod 中的容器是 running 状态：

```
kubectl get pods
```

查看容器日志：

```
kubectl logs dapi-envars-resourcefieldref
```

输出展示了选定环境变量的值：

```
1
1
33554432
67108864
```

# Kubernetes Replica Sets

- [1 如何使用ReplicaSet](http://docs.kubernetes.org.cn/314.html#ReplicaSet)
- [2 何时使用ReplicaSet](http://docs.kubernetes.org.cn/314.html#ReplicaSet-2)
- [3 示例](http://docs.kubernetes.org.cn/314.html#i)
- [4 ReplicaSet as an Horizontal Pod Autoscaler target](http://docs.kubernetes.org.cn/314.html#ReplicaSet_as_an_Horizontal_Pod_Autoscaler_target)

ReplicaSet（RS）是Replication Controller（RC）的升级版本。ReplicaSet 和  [Replication Controller](http://docs.kubernetes.org.cn/437.html)之间的唯一区别是对选择器的支持。ReplicaSet支持[labels user guide](http://docs.kubernetes.org.cn/247.html#Labels)中描述的set-based选择器要求， 而Replication Controller仅支持equality-based的选择器要求。

## 如何使用ReplicaSet

大多数[kubectl](http://docs.kubernetes.org.cn/61.html) 支持Replication Controller 命令的也支持ReplicaSets。[rolling-update](https://kubernetes.io/docs/user-guide/kubectl/v1.7/#rolling-update)命令除外，如果要使用rolling-update，请使用Deployments来实现。

虽然ReplicaSets可以独立使用，但它主要被 [Deployments](http://docs.kubernetes.org.cn/317.html)用作pod 机制的创建、删除和更新。当使用Deployment时，你不必担心创建pod的ReplicaSets，因为可以通过Deployment实现管理ReplicaSets。

## 何时使用ReplicaSet

ReplicaSet能确保运行指定数量的pod。然而，Deployment 是一个更高层次的概念，它能管理ReplicaSets，并提供对pod的更新等功能。因此，我们建议你使用Deployment来管理ReplicaSets，除非你需要自定义更新编排。

这意味着你可能永远不需要操作ReplicaSet对象，而是使用Deployment替代管理 。

## 示例

[frontend.yaml](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/workloads/controllers/frontend.yaml)

```
apiVersion: extensions/v1beta1
kind: ReplicaSet
metadata:
  name: frontend
  # these labels can be applied automatically
  # from the labels in the pod template if not set
  # labels:
    # app: guestbook
    # tier: frontend
spec:
  # this replicas value is default
  # modify it according to your case
  replicas: 3
  # selector can be applied automatically
  # from the labels in the pod template if not set,
  # but we are specifying the selector here to
  # demonstrate its usage.
  selector:
    matchLabels:
      tier: frontend
    matchExpressions:
      - {key: tier, operator: In, values: [frontend]}
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          value: dns
          # If your cluster config does not include a dns service, then to
          # instead access environment variables to find service host
          # info, comment out the 'value: dns' line above, and uncomment the
          # line below.
          # value: env
        ports:
        - containerPort: 80
```

将此配置保存到（frontend.yaml）并提交到Kubernetes集群时，将创建定义的ReplicaSet及其管理的pod。

```
$ kubectl create -f frontend.yaml
replicaset "frontend" created
$ kubectl describe rs/frontend
Name:          frontend
Namespace:     default
Image(s):      gcr.io/google_samples/gb-frontend:v3
Selector:      tier=frontend,tier in (frontend)
Labels:        app=guestbook,tier=frontend
Replicas:      3 current / 3 desired
Pods Status:   3 Running / 0 Waiting / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen    LastSeen    Count    From                SubobjectPath    Type        Reason            Message
  ---------    --------    -----    ----                -------------    --------    ------            -------
  1m           1m          1        {replicaset-controller }             Normal      SuccessfulCreate  Created pod: frontend-qhloh
  1m           1m          1        {replicaset-controller }             Normal      SuccessfulCreate  Created pod: frontend-dnjpy
  1m           1m          1        {replicaset-controller }             Normal      SuccessfulCreate  Created pod: frontend-9si5l
$ kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
frontend-9si5l   1/1       Running   0          1m
frontend-dnjpy   1/1       Running   0          1m
frontend-qhloh   1/1       Running   0          1m
```

## ReplicaSet as an Horizontal Pod Autoscaler target

ReplicaSet也可以作为 [Horizontal Pod Autoscalers (HPA)](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)的目标 。也就是说，一个ReplicaSet可以由一个HPA来自动伸缩。以下是针对我们在上一个示例中创建的ReplicaSet的HPA示例。

| [hpa-rs.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/workloads/controllers/hpa-rs.yaml)![将hpa-rs.yaml复制到剪贴板](https://d33wubrfki0l68.cloudfront.net/951ae1fcc65e28202164b32c13fa7ae04fab4a0b/b77dc/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: autoscaling/v1 kind: HorizontalPodAutoscaler metadata:  name: frontend-scaler spec:  scaleTargetRef:    kind: ReplicaSet    name: frontend  minReplicas: 3  maxReplicas: 10  targetCPUUtilizationPercentage: 50 ` |

```
kubectl create -f hpa-rs.yaml
```

# Kubernetes Deployment

- 1 创建 Deployment
  - [1.1 Pod-template-hash label](http://docs.kubernetes.org.cn/317.html#Pod-template-hash_label)
- 2 更新Deployment
  - [2.1 Rollover（多个rollout并行）](http://docs.kubernetes.org.cn/317.html#Rolloverrollout)
  - [2.2 Label selector 更新](http://docs.kubernetes.org.cn/317.html#Label_selector)
- 3 回退Deployment
  - [3.1 检查 Deployment 升级的历史记录](http://docs.kubernetes.org.cn/317.html#_Deployment-2)
  - [3.2 回退到历史版本](http://docs.kubernetes.org.cn/317.html#i)
  - [3.3 清理 Policy](http://docs.kubernetes.org.cn/317.html#_Policy)
- 4 Deployment 扩容
  - [4.1 比例扩容](http://docs.kubernetes.org.cn/317.html#i-2)
- [5 暂停和恢复Deployment](http://docs.kubernetes.org.cn/317.html#Deployment-4)
- 6 Deployment 状态
  - [6.1 进行中的 Deployment](http://docs.kubernetes.org.cn/317.html#_Deployment-3)
  - [6.2 完成的 Deployment](http://docs.kubernetes.org.cn/317.html#_Deployment-4)
  - [6.3 失败的 Deployment](http://docs.kubernetes.org.cn/317.html#_Deployment-5)
  - [6.4 操作失败的 Deployment](http://docs.kubernetes.org.cn/317.html#_Deployment-6)
- [7 清理Policy](http://docs.kubernetes.org.cn/317.html#Policy)
- 8 用例
  - [8.1 金丝雀 Deployment](http://docs.kubernetes.org.cn/317.html#_Deployment-7)
- 9 编写 Deployment Spec
  - [9.1 Pod Template](http://docs.kubernetes.org.cn/317.html#Pod_Template)
  - [9.2 Replicas](http://docs.kubernetes.org.cn/317.html#Replicas)
  - [9.3 Selector](http://docs.kubernetes.org.cn/317.html#Selector)
  - 9.4 策略
    - [9.4.1 Recreate Deployment](http://docs.kubernetes.org.cn/317.html#Recreate_Deployment)
    - 9.4.2 Rolling Update Deployment
      - [9.4.2.1 Max Unavailable](http://docs.kubernetes.org.cn/317.html#Max_Unavailable)
      - [9.4.2.2 Max Surge](http://docs.kubernetes.org.cn/317.html#Max_Surge)
  - [9.5 Progress Deadline Seconds](http://docs.kubernetes.org.cn/317.html#Progress_Deadline_Seconds)
  - [9.6 Min Ready Seconds](http://docs.kubernetes.org.cn/317.html#Min_Ready_Seconds)
  - 9.7 Rollback To
    - [9.7.1 Revision](http://docs.kubernetes.org.cn/317.html#Revision)
  - [9.8 Revision History Limit](http://docs.kubernetes.org.cn/317.html#Revision_History_Limit)
  - [9.9 Paused](http://docs.kubernetes.org.cn/317.html#Paused)
- 10 Deployment 的替代选择
  - [10.1 kubectl rolling update](http://docs.kubernetes.org.cn/317.html#kubectl_rolling_update)

Deployment为[Pod](http://docs.kubernetes.org.cn/312.html)和[Replica Set](http://docs.kubernetes.org.cn/314.html)（升级版的 [Replication Controller](http://docs.kubernetes.org.cn/437.html)）提供声明式更新。

你只需要在 Deployment 中描述您想要的目标状态是什么，Deployment controller 就会帮您将 Pod  和ReplicaSet 的实际状态改变到您的目标状态。您可以定义一个全新的 Deployment 来创建 ReplicaSet 或者删除已有的  Deployment 并创建一个新的来替换。

注意：您不该手动管理由 Deployment 创建的 [Replica Set](http://docs.kubernetes.org.cn/314.html)，否则您就篡越了 Deployment controller 的职责！下文罗列了 Deployment 对象中已经覆盖了所有的用例。如果未有覆盖您所有需要的用例，请直接在 Kubernetes 的代码库中提 issue。

典型的用例如下：

- 使用Deployment来创建ReplicaSet。ReplicaSet在后台创建pod。检查启动状态，看它是成功还是失败。
- 然后，通过更新Deployment的PodTemplateSpec字段来声明Pod的新状态。这会创建一个新的ReplicaSet，Deployment会按照控制的速率将pod从旧的ReplicaSet移动到新的ReplicaSet中。
- 如果当前状态不稳定，回滚到之前的Deployment revision。每次回滚都会更新Deployment的revision。
- 扩容Deployment以满足更高的负载。
- 暂停Deployment来应用PodTemplateSpec的多个修复，然后恢复上线。
- 根据Deployment 的状态判断上线是否hang住了。
- 清除旧的不必要的 ReplicaSet。

## 创建 Deployment

下面是一个 Deployment 示例，它创建了一个 ReplicaSet 来启动3个 nginx pod。

下载示例文件并执行命令：

```
$ kubectl create -f https://kubernetes.io/docs/user-guide/nginx-deployment.yaml --record
deployment "nginx-deployment" created
```

将kubectl的 --record 的 flag 设置为 true可以在 annotation 中记录当前命令创建或者升级了该资源。这在未来会很有用，例如，查看在每个 Deployment revision 中执行了哪些命令。

然后立即执行 get 将获得如下结果：

```
$ kubectl get deployments
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         0         0            0           1s
```

输出结果表明我们希望的repalica数是3（根据deployment中的.spec.replicas配置）当前replica数（ .status.replicas）是0,  最新的replica数（.status.updatedReplicas）是0，可用的replica数（.status.availableReplicas）是0。

过几秒后再执行get命令，将获得如下输出：

```
$ kubectl get deployments
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           18s
```

我们可以看到Deployment已经创建了3个 replica，所有的 replica 都已经是最新的了（包含最新的pod  template），可用的（根据Deployment中的.spec.minReadySeconds声明，处于已就绪状态的pod的最少个数）。执行kubectl get rs和kubectl get pods会显示Replica Set（RS）和Pod已创建。

```
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-2035384211   3         3         0       18s
```

您可能会注意到 ReplicaSet 的名字总是<Deployment的名字>-<pod template的hash值>。

```
$ kubectl get pods --show-labels
NAME                                READY     STATUS    RESTARTS   AGE       LABELS
nginx-deployment-2035384211-7ci7o   1/1       Running   0          18s       app=nginx,pod-template-hash=2035384211
nginx-deployment-2035384211-kzszj   1/1       Running   0          18s       app=nginx,pod-template-hash=2035384211
nginx-deployment-2035384211-qqcnn   1/1       Running   0          18s       app=nginx,pod-template-hash=2035384211
```

刚创建的Replica Set将保证总是有3个 nginx 的 pod 存在。

注意： 您必须在 Deployment 中的 selector 指定正确的 pod template label（在该示例中是 app = nginx），不要跟其他的 controller 的 selector 中指定的 pod template label 搞混了（包括  Deployment、Replica Set、Replication Controller 等）。Kubernetes 本身并不会阻止您任意指定 pod template label ，但是如果您真的这么做了，这些 controller 之间会相互打架，并可能导致不正确的行为。

### Pod-template-hash label

注意：这个[ label](http://docs.kubernetes.org.cn/247.html) 不是用户指定的！

注意上面示例输出中的 pod label 里的 pod-template-hash label。当 Deployment 创建或者接管  ReplicaSet 时，Deployment controller 会自动为 Pod 添加 pod-template-hash  label。这样做的目的是防止 Deployment 的子ReplicaSet 的 pod 名字重复。通过将 ReplicaSet 的  PodTemplate 进行哈希散列，使用生成的哈希值作为 label 的值，并添加到 ReplicaSet selector 里、 pod  template label 和 ReplicaSet 管理中的 Pod 上。

## 更新Deployment

注意： Deployment 的 rollout 当且仅当 Deployment 的 pod template（例如.spec.template）中的label更新或者镜像更改时被触发。其他更新，例如扩容Deployment不会触发 rollout。

假如我们现在想要让 nginx pod 使用nginx:1.9.1的镜像来代替原来的nginx:1.7.9的镜像。

```
$ kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
deployment "nginx-deployment" image updated
```

我们可以使用edit命令来编辑 Deployment，修改 .spec.template.spec.containers[0].image ，将nginx:1.7.9 改写成 nginx:1.9.1。

```
$ kubectl edit deployment/nginx-deployment
deployment "nginx-deployment" edited
```

查看 rollout 的状态，只要执行：

```
$ kubectl rollout status deployment/nginx-deployment
Waiting for rollout to finish: 2 out of 3 new replicas have been updated...
deployment "nginx-deployment" successfully rolled out
```

Rollout 成功后，get Deployment：

```
$ kubectl get deployments
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           36s
```

UP-TO-DATE 的 replica 的数目已经达到了配置中要求的数目。

CURRENT 的 replica 数表示 Deployment 管理的 replica 数量，AVAILABLE 的 replica 数是当前可用的replica数量。

我们通过执行kubectl get rs可以看到 Deployment 更新了Pod，通过创建一个新的 ReplicaSet 并扩容了3个 replica，同时将原来的 ReplicaSet 缩容到了0个 replica。

```
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-1564180365   3         3         0       6s
nginx-deployment-2035384211   0         0         0       36s
```

执行 get pods只会看到当前的新的 pod:

```
$ kubectl get pods
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-1564180365-khku8   1/1       Running   0          14s
nginx-deployment-1564180365-nacti   1/1       Running   0          14s
nginx-deployment-1564180365-z9gth   1/1       Running   0          14s
```

下次更新这些 pod 的时候，只需要更新 Deployment 中的 pod 的 template 即可。

Deployment 可以保证在升级时只有一定数量的 Pod 是 down 的。默认的，它会确保至少有比期望的Pod数量少一个是up状态（最多一个不可用）。

Deployment 同时也可以确保只创建出超过期望数量的一定数量的 Pod。默认的，它会确保最多比期望的Pod数量多一个的 Pod 是 up 的（最多1个 surge ）。

在未来的 Kuberentes 版本中，将从1-1变成25%-25%。

例如，如果您自己看下上面的 Deployment，您会发现，开始创建一个新的 Pod，然后删除一些旧的 Pod 再创建一个新的。当新的Pod创建出来之前不会杀掉旧的Pod。这样能够确保可用的 Pod 数量至少有2个，Pod的总数最多4个。

```
$ kubectl describe deployments
Name:           nginx-deployment
Namespace:      default
CreationTimestamp:  Tue, 15 Mar 2016 12:01:06 -0700
Labels:         app=nginx
Selector:       app=nginx
Replicas:       3 updated | 3 total | 3 available | 0 unavailable
StrategyType:       RollingUpdate
MinReadySeconds:    0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
OldReplicaSets:     <none>
NewReplicaSet:      nginx-deployment-1564180365 (3/3 replicas created)
Events:
  FirstSeen LastSeen    Count   From                     SubobjectPath   Type        Reason              Message
  --------- --------    -----   ----                     -------------   --------    ------              -------
  36s       36s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-2035384211 to 3
  23s       23s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 1
  23s       23s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 2
  23s       23s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 2
  21s       21s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 0
  21s       21s         1       {deployment-controller }                 Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 3
```

我们可以看到当我们刚开始创建这个 Deployment 的时候，创建了一个 ReplicaSet（nginx-deployment-2035384211），并直接扩容到了3个 replica。

当我们更新这个 Deployment 的时候，它会创建一个新的  ReplicaSet（nginx-deployment-1564180365），将它扩容到1个replica，然后缩容原先的  ReplicaSet 到2个 replica，此时满足至少2个 Pod 是可用状态，同一时刻最多有4个 Pod 处于创建的状态。

接着继续使用相同的 rolling update 策略扩容新的 ReplicaSet 和缩容旧的 ReplicaSet。最终，将会在新的 ReplicaSet 中有3个可用的 replica，旧的 ReplicaSet 的 replica 数目变成0。

### Rollover（多个rollout并行）

每当 Deployment controller 观测到有新的 deployment 被创建时，如果没有已存在的 ReplicaSet  来创建期望个数的 Pod 的话，就会创建出一个新的 ReplicaSet 来做这件事。已存在的 ReplicaSet 控制 label  与.spec.selector匹配但是 template 跟.spec.template不匹配的 Pod 缩容。最终，新的 ReplicaSet 将会扩容出.spec.replicas指定数目的 Pod，旧的 ReplicaSet 会缩容到0。

如果您更新了一个的已存在并正在进行中的 Deployment，每次更新 Deployment都会创建一个新的 ReplicaSet并扩容它，同时回滚之前扩容的 ReplicaSet ——将它添加到旧的 ReplicaSet 列表中，开始缩容。

例如，假如您创建了一个有5个niginx:1.7.9 replica的 Deployment，但是当还只有3个nginx:1.7.9的  replica 创建出来的时候您就开始更新含有5个nginx:1.9.1 replica 的  Deployment。在这种情况下，Deployment 会立即杀掉已创建的3个nginx:1.7.9的  Pod，并开始创建nginx:1.9.1的 Pod。它不会等到所有的5个nginx:1.7.9的 Pod 都创建完成后才开始改变航道。

### Label selector 更新

我们通常不鼓励更新 [label selector](http://docs.kubernetes.org.cn/247.html)，我们建议实现规划好您的 selector。

任何情况下，只要您想要执行 label selector 的更新，请一定要谨慎并确认您已经预料到所有可能因此导致的后果。

- 增添 selector 需要同时在 Deployment 的 spec 中更新新的  label，否则将返回校验错误。此更改是不可覆盖的，这意味着新的 selector 不会选择使用旧 selector 创建的  ReplicaSet 和 Pod，从而导致所有旧版本的 ReplicaSet 都被丢弃，并创建新的 ReplicaSet。
- 更新 selector，即更改 selector key 的当前值，将导致跟增添 selector 同样的后果。
- 删除 selector，即删除 Deployment selector 中的已有的 key，不需要对 Pod template  label 做任何更改，现有的 ReplicaSet 也不会成为孤儿，但是请注意，删除的 label 仍然存在于现有的 Pod 和  ReplicaSet 中。

## 回退Deployment

有时候您可能想回退一个 Deployment，例如，当 Deployment 不稳定时，比如一直 crash looping。

默认情况下，kubernetes 会在系统中保存前两次的 Deployment 的 rollout 历史记录，以便您可以随时回退（您可以修改revision history limit来更改保存的revision数）。

注意： 只要 Deployment 的 rollout 被触发就会创建一个 revision。也就是说当且仅当 Deployment 的  Pod template（如.spec.template）被更改，例如更新template 中的 label 和容器镜像时，就会创建出一个新的  revision。

其他的更新，比如扩容 Deployment 不会创建 revision——因此我们可以很方便的手动或者自动扩容。这意味着当您回退到历史 revision 是，直有 Deployment 中的 Pod template 部分才会回退。

假设我们在更新 Deployment 的时候犯了一个拼写错误，将镜像的名字写成了nginx:1.91，而正确的名字应该是nginx:1.9.1：

```
$ kubectl set image deployment/nginx-deployment nginx=nginx:1.91
deployment "nginx-deployment" image updated
```

Rollout 将会卡住。

```
$ kubectl rollout status deployments nginx-deployment
Waiting for rollout to finish: 2 out of 3 new replicas have been updated...
```

按住 Ctrl-C 停止上面的 rollout 状态监控。

您会看到旧的 replica（nginx-deployment-1564180365 和 nginx-deployment-2035384211）和新的 replica （nginx-deployment-3066724191）数目都是2个。

```
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-1564180365   2         2         0       25s
nginx-deployment-2035384211   0         0         0       36s
nginx-deployment-3066724191   2         2         2       6s
```

看下创建 Pod，您会看到有两个新的 ReplicaSet 创建的 Pod 处于 ImagePullBackOff 状态，循环拉取镜像。

```
$ kubectl get pods
NAME                                READY     STATUS             RESTARTS   AGE
nginx-deployment-1564180365-70iae   1/1       Running            0          25s
nginx-deployment-1564180365-jbqqo   1/1       Running            0          25s
nginx-deployment-3066724191-08mng   0/1       ImagePullBackOff   0          6s
nginx-deployment-3066724191-eocby   0/1       ImagePullBackOff   0          6s
```

注意，Deployment controller会自动停止坏的 rollout，并停止扩容新的 ReplicaSet。

```
$ kubectl describe deployment
Name:           nginx-deployment
Namespace:      default
CreationTimestamp:  Tue, 15 Mar 2016 14:48:04 -0700
Labels:         app=nginx
Selector:       app=nginx
Replicas:       2 updated | 3 total | 2 available | 2 unavailable
StrategyType:       RollingUpdate
MinReadySeconds:    0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
OldReplicaSets:     nginx-deployment-1564180365 (2/2 replicas created)
NewReplicaSet:      nginx-deployment-3066724191 (2/2 replicas created)
Events:
  FirstSeen LastSeen    Count   From                    SubobjectPath   Type        Reason              Message
  --------- --------    -----   ----                    -------------   --------    ------              -------
  1m        1m          1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-2035384211 to 3
  22s       22s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 1
  22s       22s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 2
  22s       22s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 2
  21s       21s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 0
  21s       21s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 3
  13s       13s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-3066724191 to 1
  13s       13s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-1564180365 to 2
  13s       13s         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-3066724191 to 2
```

为了修复这个问题，我们需要回退到稳定的 Deployment revision。

### 检查 Deployment 升级的历史记录

首先，检查下 Deployment 的 revision：

```
$ kubectl rollout history deployment/nginx-deployment
deployments "nginx-deployment":
REVISION    CHANGE-CAUSE
1           kubectl create -f https://kubernetes.io/docs/user-guide/nginx-deployment.yaml--record
2           kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
3           kubectl set image deployment/nginx-deployment nginx=nginx:1.91
```

因为我们创建 Deployment 的时候使用了--recored参数可以记录命令，我们可以很方便的查看每次 revision 的变化。

查看单个revision 的详细信息：

```
$ kubectl rollout history deployment/nginx-deployment --revision=2
deployments "nginx-deployment" revision 2
  Labels:       app=nginx
          pod-template-hash=1159050644
  Annotations:  kubernetes.io/change-cause=kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
  Containers:
   nginx:
    Image:      nginx:1.9.1
    Port:       80/TCP
     QoS Tier:
        cpu:      BestEffort
        memory:   BestEffort
    Environment Variables:      <none>
  No volumes.
```

### 回退到历史版本

现在，我们可以决定回退当前的 rollout 到之前的版本：

```
$ kubectl rollout undo deployment/nginx-deployment
deployment "nginx-deployment" rolled back
```

也可以使用 --revision参数指定某个历史版本：

```
$ kubectl rollout undo deployment/nginx-deployment --to-revision=2
deployment "nginx-deployment" rolled back
```

与 rollout 相关的命令详细文档见[kubectl rollout](https://kubernetes.io/docs/user-guide/kubectl/v1.6/#rollout)。

该 Deployment 现在已经回退到了先前的稳定版本。如您所见，Deployment controller产生了一个回退到revison 2的DeploymentRollback的 event。

```
$ kubectl get deployment
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           30m

$ kubectl describe deployment
Name:           nginx-deployment
Namespace:      default
CreationTimestamp:  Tue, 15 Mar 2016 14:48:04 -0700
Labels:         app=nginx
Selector:       app=nginx
Replicas:       3 updated | 3 total | 3 available | 0 unavailable
StrategyType:       RollingUpdate
MinReadySeconds:    0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
OldReplicaSets:     <none>
NewReplicaSet:      nginx-deployment-1564180365 (3/3 replicas created)
Events:
  FirstSeen LastSeen    Count   From                    SubobjectPath   Type        Reason              Message
  --------- --------    -----   ----                    -------------   --------    ------              -------
  30m       30m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-2035384211 to 3
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 1
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 2
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 2
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-2035384211 to 0
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-3066724191 to 2
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-3066724191 to 1
  29m       29m         1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-1564180365 to 2
  2m        2m          1       {deployment-controller }                Normal      ScalingReplicaSet   Scaled down replica set nginx-deployment-3066724191 to 0
  2m        2m          1       {deployment-controller }                Normal      DeploymentRollback  Rolled back deployment "nginx-deployment" to revision 2
  29m       2m          2       {deployment-controller }                Normal      ScalingReplicaSet   Scaled up replica set nginx-deployment-1564180365 to 3
```

### 清理 Policy

您可以通过设置.spec.revisonHistoryLimit项来指定 deployment 最多保留多少 revision 历史记录。默认的会保留所有的 revision；如果将该项设置为0，Deployment就不允许回退了。

## Deployment 扩容

您可以使用以下命令扩容 Deployment：

```
$ kubectl scale deployment nginx-deployment --replicas 10
deployment "nginx-deployment" scaled
```

假设您的集群中启用了[horizontal pod autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough)，您可以给 Deployment 设置一个 autoscaler，基于当前 Pod的 CPU 利用率选择最少和最多的 Pod 数。

```
$ kubectl autoscale deployment nginx-deployment --min=10 --max=15 --cpu-percent=80
deployment "nginx-deployment" autoscaled
```

### 比例扩容

RollingUpdate Deployment 支持同时运行一个应用的多个版本。或者 autoscaler 扩 容  RollingUpdate Deployment 的时候，正在中途的 rollout（进行中或者已经暂停的），为了降低风险，Deployment controller 将会平衡已存在的活动中的 ReplicaSet（有 Pod 的 ReplicaSet）和新加入的  replica。这被称为比例扩容。

例如，您正在运行中含有10个 replica 的 Deployment。maxSurge=3，maxUnavailable=2。

```
$ kubectl get deploy
NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment     10        10        10           10          50s
```

您更新了一个镜像，而在集群内部无法解析。

```
$ kubectl set image deploy/nginx-deployment nginx=nginx:sometag
deployment "nginx-deployment" image updated
```

镜像更新启动了一个包含ReplicaSet nginx-deployment-1989198191的新的rollout，但是它被阻塞了，因为我们上面提到的maxUnavailable。

```
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY     AGE
nginx-deployment-1989198191   5         5         0         9s
nginx-deployment-618515232    8         8         8         1m
```

然后发起了一个新的Deployment扩容请求。autoscaler将Deployment的repllica数目增加到了15个。Deployment  controller需要判断在哪里增加这5个新的replica。如果我们没有谁用比例扩容，所有的5个replica都会加到一个新的ReplicaSet中。如果使用比例扩容，新添加的replica将传播到所有的ReplicaSet中。大的部分加入replica数最多的ReplicaSet中，小的部分加入到replica数少的ReplciaSet中。0个replica的ReplicaSet不会被扩容。

在我们上面的例子中，3个replica将添加到旧的ReplicaSet中，2个replica将添加到新的ReplicaSet中。rollout进程最终会将所有的replica移动到新的ReplicaSet中，假设新的replica成为健康状态。

```
$ kubectl get deploy
NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment     15        18        7            8           7m
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY     AGE
nginx-deployment-1989198191   7         7         0         7m
nginx-deployment-618515232    11        11        11        7m
```

## 暂停和恢复Deployment

您可以在发出一次或多次更新前暂停一个 Deployment，然后再恢复它。这样您就能多次暂停和恢复 Deployment，在此期间进行一些修复工作，而不会发出不必要的 rollout。

例如使用刚刚创建 Deployment：

```
$ kubectl get deploy
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx     3         3         3            3           1m
[mkargaki@dhcp129-211 kubernetes]$ kubectl get rs
NAME               DESIRED   CURRENT   READY     AGE
nginx-2142116321   3         3         3         1m
```

使用以下命令暂停 Deployment：

```
$ kubectl rollout pause deployment/nginx-deployment
deployment "nginx-deployment" paused
```

然后更新 Deplyment中的镜像：

```
$ kubectl set image deploy/nginx nginx=nginx:1.9.1
deployment "nginx-deployment" image updated
```

注意新的 rollout 启动了：

```
$ kubectl rollout history deploy/nginx
deployments "nginx"
REVISION  CHANGE-CAUSE
1   <none>

$ kubectl get rs
NAME               DESIRED   CURRENT   READY     AGE
nginx-2142116321   3         3         3         2m
```

您可以进行任意多次更新，例如更新使用的资源：

```
$ kubectl set resources deployment nginx -c=nginx --limits=cpu=200m,memory=512Mi
deployment "nginx" resource requirements updated
```

Deployment 暂停前的初始状态将继续它的功能，而不会对 Deployment 的更新产生任何影响，只要 Deployment是暂停的。

最后，恢复这个 Deployment，观察完成更新的 ReplicaSet 已经创建出来了：

```
$ kubectl rollout resume deploy nginx
deployment "nginx" resumed
$ KUBECTL get rs -w
NAME               DESIRED   CURRENT   READY     AGE
nginx-2142116321   2         2         2         2m
nginx-3926361531   2         2         0         6s
nginx-3926361531   2         2         1         18s
nginx-2142116321   1         2         2         2m
nginx-2142116321   1         2         2         2m
nginx-3926361531   3         2         1         18s
nginx-3926361531   3         2         1         18s
nginx-2142116321   1         1         1         2m
nginx-3926361531   3         3         1         18s
nginx-3926361531   3         3         2         19s
nginx-2142116321   0         1         1         2m
nginx-2142116321   0         1         1         2m
nginx-2142116321   0         0         0         2m
nginx-3926361531   3         3         3         20s
^C
$ KUBECTL get rs
NAME               DESIRED   CURRENT   READY     AGE
nginx-2142116321   0         0         0         2m
nginx-3926361531   3         3         3         28s
```

注意： 在恢复 Deployment 之前您无法回退一个已经暂停的 Deployment。

## Deployment 状态

Deployment 在生命周期中有多种状态。在创建一个新的 ReplicaSet 的时候它可以是 [progressing](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#progressing-deployment) 状态， [complete](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#complete-deployment) 状态，或者 [fail to progress ](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#failed-deployment)状态。

### 进行中的 Deployment

Kubernetes 将执行过下列任务之一的 Deployment 标记为 progressing 状态：

- Deployment 正在创建新的ReplicaSet过程中。
- Deployment 正在扩容一个已有的 ReplicaSet。
- Deployment 正在缩容一个已有的 ReplicaSet。
- 有新的可用的 pod 出现。

您可以使用kubectl rollout status命令监控 Deployment 的进度。

### 完成的 Deployment

Kubernetes 将包括以下特性的 Deployment 标记为 complete 状态：

- Deployment 最小可用。最小可用意味着 Deployment 的可用 replica 个数等于或者超过 Deployment 策略中的期望个数。
- 所有与该 Deployment 相关的replica都被更新到了您指定版本，也就说更新完成。
- 该 Deployment 中没有旧的 Pod 存在。

您可以用kubectl rollout status命令查看 Deployment 是否完成。如果 rollout 成功完成，kubectl rollout status将返回一个0值的 Exit Code。

```
$ kubectl rollout status deploy/nginx
Waiting for rollout to finish: 2 of 3 updated replicas are available...
deployment "nginx" successfully rolled out
$ echo $?
0
```

### 失败的 Deployment

您的 Deployment 在尝试部署新的 ReplicaSet 的时候可能卡住，用于也不会完成。这可能是因为以下几个因素引起的：

- 无效的引用
- 不可读的 probe failure
- 镜像拉取错误
- 权限不够
- 范围限制
- 程序运行时配置错误

探测这种情况的一种方式是，在您的 Deployment spec 中指定[spec.progressDeadlineSeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#progress-deadline-seconds)。spec.progressDeadlineSeconds 表示 Deployment controller 等待多少秒才能确定（通过 Deployment status）Deployment进程是卡住的。

下面的kubectl命令设置progressDeadlineSeconds 使 controller 在 Deployment 在进度卡住10分钟后报告：

```
$ kubectl patch deployment/nginx-deployment -p '{"spec":{"progressDeadlineSeconds":600}}'
"nginx-deployment" patched
```

当超过截止时间后，Deployment controller 会在 Deployment 的 status.conditions中增加一条DeploymentCondition，它包括如下属性：

- Type=Progressing
- Status=False
- Reason=ProgressDeadlineExceeded

浏览 [Kubernetes API conventions](https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#typical-status-properties) 查看关于status conditions的更多信息。

注意： kubernetes除了报告Reason=ProgressDeadlineExceeded状态信息外不会对卡住的 Deployment 做任何操作。更高层次的协调器可以利用它并采取相应行动，例如，回滚 Deployment 到之前的版本。

注意： 如果您暂停了一个 Deployment，在暂停的这段时间内kubernetnes不会检查您指定的 deadline。您可以在 Deployment 的 rollout 途中安全的暂停它，然后再恢复它，这不会触发超过deadline的状态。

您可能在使用 Deployment 的时候遇到一些短暂的错误，这些可能是由于您设置了太短的 timeout，也有可能是因为各种其他错误导致的短暂错误。例如，假设您使用了无效的引用。当您 Describe Deployment 的时候可能会注意到如下信息：

```
$ kubectl describe deployment nginx-deployment
<...>
Conditions:
  Type            Status  Reason
  ----            ------  ------
  Available       True    MinimumReplicasAvailable
  Progressing     True    ReplicaSetUpdated
  ReplicaFailure  True    FailedCreate
<...>
```

执行 kubectl get deployment nginx-deployment -o yaml，Deployement 的状态可能看起来像这个样子：

```
status:
  availableReplicas: 2
  conditions:
  - lastTransitionTime: 2016-10-04T12:25:39Z
    lastUpdateTime: 2016-10-04T12:25:39Z
    message: Replica set "nginx-deployment-4262182780" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  - lastTransitionTime: 2016-10-04T12:25:42Z
    lastUpdateTime: 2016-10-04T12:25:42Z
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: 2016-10-04T12:25:39Z
    lastUpdateTime: 2016-10-04T12:25:39Z
    message: 'Error creating: pods "nginx-deployment-4262182780-" is forbidden: exceeded quota:
      object-counts, requested: pods=1, used: pods=3, limited: pods=2'
    reason: FailedCreate
    status: "True"
    type: ReplicaFailure
  observedGeneration: 3
  replicas: 2
  unavailableReplicas: 2
```

最终，一旦超过 Deployment 进程的 deadline，kuberentes 会更新状态和导致 Progressing 状态的原因：

```
Conditions:
  Type            Status  Reason
  ----            ------  ------
  Available       True    MinimumReplicasAvailable
  Progressing     False   ProgressDeadlineExceeded
  ReplicaFailure  True    FailedCreate
```

您可以通过缩容 Deployment的方式解决配额不足的问题，或者增加您的 namespace  的配额。如果您满足了配额条件后，Deployment controller 就会完成您的 Deployment rollout，您将看到  Deployment 的状态更新为成功状态（Status=True并且Reason=NewReplicaSetAvailable）。

```
Conditions:
  Type          Status  Reason
  ----          ------  ------
  Available     True    MinimumReplicasAvailable
  Progressing   True    NewReplicaSetAvailable
```

Type=Available、 Status=True 以为这您的Deployment有最小可用性。  最小可用性是在Deployment策略中指定的参数。Type=Progressing 、 Status=True意味着您的Deployment  或者在部署过程中，或者已经成功部署，达到了期望的最少的可用replica数量（查看特定状态的Reason——在我们的例子中Reason=NewReplicaSetAvailable 意味着Deployment已经完成）。

您可以使用kubectl rollout status命令查看Deployment进程是否失败。当Deployment过程超过了deadline，kubectl rollout status将返回非0的exit code。

```
$ kubectl rollout status deploy/nginx
Waiting for rollout to finish: 2 out of 3 new replicas have been updated...
error: deployment "nginx" exceeded its progress deadline
$ echo $?
1
```

### 操作失败的 Deployment

所有对完成的 Deployment 的操作都适用于失败的 Deployment。您可以对它扩/缩容，回退到历史版本，您甚至可以多次暂停它来应用 Deployment pod template。

## 清理Policy

您可以设置 Deployment 中的 .spec.revisionHistoryLimit 项来指定保留多少旧的 ReplicaSet。 余下的将在后台被当作垃圾收集。默认的，所有的 revision 历史就都会被保留。在未来的版本中，将会更改为2。

注意： 将该值设置为0，将导致所有的 Deployment 历史记录都会被清除，该 Deployment 就无法再回退了。

## 用例

### 金丝雀 Deployment

如果您想要使用 Deployment 对部分用户或服务器发布 release，您可以创建多个 Deployment，每个 Deployment 对应一个 release，参照 [managing resources](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments) 中对金丝雀模式的描述。

## 编写 Deployment Spec

在所有的 Kubernetes 配置中，Deployment 也需要apiVersion，kind和metadata这些配置项。配置文件的通用使用说明查看 [部署应用](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)，配置容器，和 [使用 kubectl 管理资源 ](https://kubernetes.io/docs/tutorials/object-management-kubectl/object-management/)文档。

Deployment也需要 [.spec section](https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#spec-and-status).

### Pod Template

.spec.template 是 .spec中唯一要求的字段。

.spec.template 是 [pod template](https://kubernetes.io/docs/user-guide/replication-controller/#pod-template). 它跟 [Pod](http://docs.kubernetes.org.cn/312.html)有一模一样的schema，除了它是嵌套的并且不需要apiVersion 和 kind字段。

另外为了划分Pod的范围，Deployment中的pod template必须指定适当的label（不要跟其他controller重复了，参考[selector](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#selector)）和适当的重启策略。

[.spec.template.spec.restartPolicy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle) 可以设置为 Always , 如果不指定的话这就是默认配置。

### Replicas

.spec.replicas 是可以选字段，指定期望的pod数量，默认是1。

### Selector

.spec.selector是可选字段，用来指定 [label selector](http://docs.kubernetes.org.cn/247.html) ，圈定Deployment管理的pod范围。

如果被指定， .spec.selector 必须匹配 .spec.template.metadata.labels，否则它将被API拒绝。如果 .spec.selector 没有被指定， .spec.selector.matchLabels 默认是 .spec.template.metadata.labels。

在Pod的template跟.spec.template不同或者数量超过了.spec.replicas规定的数量的情况下，Deployment会杀掉label跟selector不同的Pod。

注意： 您不应该再创建其他label跟这个selector匹配的pod，或者通过其他Deployment，或者通过其他Controller，例如ReplicaSet和ReplicationController。否则该Deployment会被把它们当成都是自己创建的。Kubernetes不会阻止您这么做。

如果您有多个controller使用了重复的selector，controller们就会互相打架并导致不正确的行为。

### 策略

.spec.strategy 指定新的Pod替换旧的Pod的策略。 .spec.strategy.type 可以是"Recreate"或者是 "RollingUpdate"。"RollingUpdate"是默认值。

#### Recreate Deployment

.spec.strategy.type==Recreate时，在创建出新的Pod之前会先杀掉所有已存在的Pod。

#### Rolling Update Deployment

.spec.strategy.type==RollingUpdate时，Deployment使用[rolling update](https://kubernetes.io/docs/tasks/run-application/rolling-update-replication-controller) 的方式更新Pod 。您可以指定maxUnavailable 和 maxSurge 来控制 rolling update 进程。

##### Max Unavailable

.spec.strategy.rollingUpdate.maxUnavailable 是可选配置项，用来指定在升级过程中不可用Pod的最大数量。该值可以是一个绝对值（例如5），也可以是期望Pod数量的百分比（例如10%）。通过计算百分比的绝对值向下取整。如果.spec.strategy.rollingUpdate.maxSurge 为0时，这个值不可以为0。默认值是1。

例如，该值设置成30%，启动rolling update后旧的ReplicatSet将会立即缩容到期望的Pod数量的70%。新的Pod  ready后，随着新的ReplicaSet的扩容，旧的ReplicaSet会进一步缩容，确保在升级的所有时刻可以用的Pod数量至少是期望Pod数量的70%。

##### Max Surge

.spec.strategy.rollingUpdate.maxSurge 是可选配置项，用来指定可以超过期望的Pod数量的最大个数。该值可以是一个绝对值（例如5）或者是期望的Pod数量的百分比（例如10%）。当MaxUnavailable为0时该值不可以为0。通过百分比计算的绝对值向上取整。默认值是1。

例如，该值设置成30%，启动rolling  update后新的ReplicatSet将会立即扩容，新老Pod的总数不能超过期望的Pod数量的130%。旧的Pod被杀掉后，新的ReplicaSet将继续扩容，旧的ReplicaSet会进一步缩容，确保在升级的所有时刻所有的Pod数量和不会超过期望Pod数量的130%。

### Progress Deadline Seconds

.spec.progressDeadlineSeconds 是可选配置项，用来指定在系统报告Deployment的[failed progressing](https://kubernetes.io/docs/concepts/workloads/controllers/deployment.md#failed-deployment)——表现为resource的状态中type=Progressing、Status=False、 Reason=ProgressDeadlineExceeded前可以等待的Deployment进行的秒数。Deployment controller会继续重试该Deployment。未来，在实现了自动回滚后， deployment  controller在观察到这种状态时就会自动回滚。

如果设置该参数，该值必须大于 .spec.minReadySeconds。

### Min Ready Seconds

.spec.minReadySeconds是一个可选配置项，用来指定没有任何容器crash的Pod并被认为是可用状态的最小秒数。默认是0（Pod在ready后就会被认为是可用状态）。进一步了解什么什么后Pod会被认为是ready状态，参阅 [Container Probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)。

### Rollback To

.spec.rollbackTo 是一个可以选配置项，用来配置Deployment回退的配置。设置该参数将触发回退操作，每次回退完成后，该值就会被清除。

#### Revision

.spec.rollbackTo.revision是一个可选配置项，用来指定回退到的revision。默认是0，意味着回退到历史中最老的revision。

### Revision History Limit

Deployment revision history存储在它控制的ReplicaSets中。

.spec.revisionHistoryLimit 是一个可选配置项，用来指定可以保留的旧的ReplicaSet数量。该理想值取决于心Deployment的频率和稳定性。如果该值没有设置的话，默认所有旧的Replicaset或会被保留，将资源存储在etcd中，是用kubectl get  rs查看输出。每个Deployment的该配置都保存在ReplicaSet中，然而，一旦您删除的旧的RepelicaSet，您的Deployment就无法再回退到那个revison了。

如果您将该值设置为0，所有具有0个replica的ReplicaSet都会被删除。在这种情况下，新的Deployment rollout无法撤销，因为revision history都被清理掉了。

### Paused

.spec.paused是可以可选配置项，boolean值。用来指定暂停和恢复Deployment。Paused和没有paused的Deployment之间的唯一区别就是，所有对paused deployment中的PodTemplateSpec的修改都不会触发新的rollout。Deployment被创建之后默认是非paused。

## Deployment 的替代选择

### kubectl rolling update

[Kubectl rolling update](https://kubernetes.io/docs/user-guide/kubectl/v1.6/#rolling-update) 虽然使用类似的方式更新Pod和ReplicationController。但是我们推荐使用Deployment，因为它是声明式的，客户端侧，具有附加特性，例如即使滚动升级结束后也可以回滚到任何历史版本。

> **说明**：本文由宋净超翻译，出至其[个人博客](https://rootsongjc.gitbooks.io/kubernetes-handbook/content/concepts/deployment.html) 。

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# Kubernetes 联邦 Deployment

- [1 Before you begin](http://docs.kubernetes.org.cn/806.html#Before_you_begin)
- 2 创建联邦 Deployment
  - [2.1 在底层集群中分布副本](http://docs.kubernetes.org.cn/806.html#i)
- [3 更新联邦 Deployment](http://docs.kubernetes.org.cn/806.html#_Deployment-2)
- [4 删除联邦 Deployment](http://docs.kubernetes.org.cn/806.html#_Deployment-3)

本指南说明了如何在联邦控制平面中使用 Deployment。

联邦控制平面中的 Deployment（在本指南中称为 “联邦 Deployment”）与传统的 [Kubernetes Deployment](http://docs.kubernetes.org.cn/317.html) 非常类似， 并提供相同的功能。 在联邦控制平面中创建联邦 Deployment 确保所需的副本数存在于注册的群集中。

到 Kubernetes 1.5 版本为止，联邦 Deployment 还是一个 Alpha 特性。 Deployment 的核心功能已经提供， 但一些特性（例如完整的 rollout 兼容性）仍在开发中。

## Before you begin

- This guide assumes that you have a running Kubernetes Cluster Federation installation. If not, then head over to the [federation admin guide](https://k8smeetup.github.io/docs/tutorials/federation/set-up-cluster-federation-kubefed/) to learn how to bring up a cluster federation (or have your cluster  administrator do this for you). Other tutorials, such as Kelsey  Hightower’s [Federated Kubernetes Tutorial](https://github.com/kelseyhightower/kubernetes-cluster-federation), might also help you create a Federated Kubernetes cluster.
- 通常您还应当拥有基本的 [Kubernetes 应用知识](https://k8smeetup.github.io/docs/setup/pick-right-solution/)，特别是 [Deployment](http://docs.kubernetes.org.cn/317.html) 相关的应用知识。

## 创建联邦 Deployment

联邦 Deployment 的 API 和传统的 Kubernetes Deployment API 是兼容的。 您可以通过向联邦 apiserver 发送请求来创建一个 Deployment。

您可以通过使用 [kubectl](http://docs.kubernetes.org.cn/61.html) 运行下面的指令来创建联邦 Deployment：

```
kubectl --context=federation-cluster create -f mydeployment.yaml
```

--context=federation-cluster 参数告诉 kubectl 发送请求到联邦 apiserver 而不是某个 Kubernetes 集群。

一旦联邦 Deployment 被创建，联邦控制平面会在所有底层 Kubernetes 集群中创建一个 Deployment。 您可以通过检查底层每个集群来对其进行验证，例如：

```
kubectl --context=gce-asia-east1a get deployment mydep
```

上面的命令假定您在客户端中配置了一个叫做 ‘gce-asia-east1a’ 的上下文，用于向相应区域的集群发送请求。

底层集群中的这些 Deployment 会匹配联邦 Deployment 中副本数和修订版本（revision）相关注解_之外_的信息。 联邦控制平面确保所有集群中的副本总数与联邦 Deployment 中请求的副本数量匹配。

### 在底层集群中分布副本

默认情况下，副本会被平均分布到所有的底层集群中。 例如： 如果您有3个注册的集群并且创建了一个副本数为 9 （spec.replicas = 9）的联邦 Deployment，那么这 3 个集群中的每个 Deployment 都将有 3 个副本 （spec.replicas=3）。

为修改每个集群中的 副本数，您可以在联邦 Deployment 中以注解的形式指定 [FederatedReplicaSetPreference](https://github.com/kubernetes/federation/blob/master/apis/federation/types.go)， 其中注解的键为 federation.kubernetes.io/deployment-preferences。

## 更新联邦 Deployment

您可以像更新 Kubernetes Deployment 一样更新联邦 Deployment。 但是，对于联邦 Deployment，  您必须发送请求到联邦 apiserver 而不是某个特定的 Kubernetes 集群。 联邦控制平面会确保每当联邦 Deployment  更新时，它会更新所有底层集群中相应的 Deployment 来和更新后的内容保持一致。 所以如果（在联邦 Deployment  中）选择了滚动更新，那么底层集群会独立地进行滚动更新，并且联邦 Deployment  中的 maxSurge and maxUnavailable 只会应用于独立的集群中。 将来这种行为可能会改变。

如果您的更新包括副本数量的变化，联邦控制平面会改变底层集群中的副本数量，以确保它们的总数等于联邦 Deployment 中请求的数量。

## 删除联邦 Deployment

您可以像删除 Kubernetes Deployment 一样删除联邦 Deployment。但是，对于联邦 Deployment，您必须发送请求到联邦 apiserver 而不是某个特定的 Kubernetes 集群。

例如，您可以使用 kubectl 运行下面的命令来删除联邦 Deployment：

```
kubectl --context=federation-cluster delete deployment mydep
```

译者：[lichuqiang](https://github.com/lichuqiang) / [原文链接](https://k8smeetup.github.io/docs/tasks/administer-federation/deployment/)



# Kubernetes Replication Controller

- 1 ReplicationController 工作原理
  - [1.1 示例：](http://docs.kubernetes.org.cn/437.html#i)
  - [1.2 删除ReplicationController及其Pods](http://docs.kubernetes.org.cn/437.html#ReplicationControllerPods)
  - [1.3 只删除 ReplicationController](http://docs.kubernetes.org.cn/437.html#_ReplicationController)
  - [1.4 ReplicationController隔离pod](http://docs.kubernetes.org.cn/437.html#ReplicationControllerpod)
- [2 RC常用方式](http://docs.kubernetes.org.cn/437.html#RC)
- [3 API对象](http://docs.kubernetes.org.cn/437.html#API)
- 4 RC 替代方法
  - [4.1 ReplicaSet](http://docs.kubernetes.org.cn/437.html#ReplicaSet)
  - [4.2 Deployment（推荐）](http://docs.kubernetes.org.cn/437.html#Deployment)
  - [4.3 Bare Pods](http://docs.kubernetes.org.cn/437.html#Bare_Pods)

注意：建议使用[Deployment](http://docs.kubernetes.org.cn/317.html) 配置 [ReplicaSet](http://docs.kubernetes.org.cn/314.html) （简称RS）方法来控制副本数。

ReplicationController（简称RC）是确保用户定义的Pod副本数保持不变。

## ReplicationController 工作原理

在用户定义范围内，如果pod增多，则ReplicationController会终止额外的pod，如果减少，RC会创建新的pod，始终保持在定义范围。例如，RC会在Pod维护（例如内核升级）后在节点上重新创建新Pod。

注：

- ReplicationController会替换由于某些原因而被删除或终止的pod，例如在节点故障或中断节点维护（例如内核升级）的情况下。因此，即使应用只需要一个pod，我们也建议使用ReplicationController。
- RC跨多个Node节点监视多个pod。

### 示例：

[replication.yaml](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/workloads/controllers/replication.yaml)

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

下载示例文件然后运行：

```
$ kubectl create -f ./replication.yaml
replicationcontroller "nginx" created
```

检查ReplicationController状态：

```
$ kubectl describe replicationcontrollers/nginx
Name:        nginx
Namespace:   default
Image(s):    nginx
Selector:    app=nginx
Labels:      app=nginx
Replicas:    3 current / 3 desired
Pods Status: 0 Running / 3 Waiting / 0 Succeeded / 0 Failed
Events:
  FirstSeen       LastSeen     Count    From                        SubobjectPath    Type      Reason              Message
  ---------       --------     -----    ----                        -------------    ----      ------              -------
  20s             20s          1        {replication-controller }                    Normal    SuccessfulCreate    Created pod: nginx-qrm3m
  20s             20s          1        {replication-controller }                    Normal    SuccessfulCreate    Created pod: nginx-3ntk0
  20s             20s          1        {replication-controller }                    Normal    SuccessfulCreate    Created pod: nginx-4ok8v
```

创建了三个pod：

```
Pods Status:    3 Running / 0 Waiting / 0 Succeeded / 0 Failed
```

列出属于ReplicationController的所有pod：

```
$ pods=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name})
echo $pods
nginx-3ntk0 nginx-4ok8v nginx-qrm3m
```

### 删除ReplicationController及其Pods

使用[kubectl delete](https://www.kubernetes.org.cn/doc-60)命令删除ReplicationController及其所有pod。

当使用REST API或客户端库时，需要明确地执行这些步骤（将副本缩放为0，等待pod删除，然后删除ReplicationController）。

### 只删除 ReplicationController

在删除ReplicationController时，可以不影响任何pod。

使用kubectl，为kubectl delete指定- cascade = false选项。

使用REST API或go客户端库时，只需删除ReplicationController对象即可。

原始文件被删除后，你可以创建一个新的ReplicationController来替换它。只要旧的和新.spec.selector 相匹配，那么新的将会采用旧的Pod。

### ReplicationController隔离pod

可以通过更改标签来从ReplicationController的目标集中删除Pod。

## RC常用方式

- Rescheduling（重新规划）
- 扩展
- 滚动更新
- 多版本跟踪
- 使用ReplicationControllers与关联的Services

## API对象

Replication controller是Kubernetes REST API中的顶级资源。有关API对象更多详细信息，请参见：[ReplicationController API对象](https://kubernetes.io/docs/api-reference/v1.7/#replicationcontroller-v1-core)。

## RC 替代方法

### ReplicaSet

[ReplicaSet](http://docs.kubernetes.org.cn/314.html)是支持新的set-based选择器要求的下一代ReplicationController 。它主要用作[Deployment](http://docs.kubernetes.org.cn/317.html)协调pod创建、删除和更新。请注意，除非需要自定义更新编排或根本不需要更新，否则建议使用Deployment而不是直接使用ReplicaSets。

### Deployment（推荐）

[Deployment](http://docs.kubernetes.org.cn/317.html)是一个高级的API对象，以类似的方式更新其底层的副本集和它们的Pods kubectl rolling-update。如果您希望使用这种滚动更新功能，建议您进行部署，因为kubectl  rolling-update它们是声明式的，服务器端的，并具有其他功能。

### Bare Pods

与用户直接创建pod的情况不同，ReplicationController会替换由于某些原因而被删除或终止的pod，例如在节点故障或中断节点维护（例如内核升级）的情况下。因此，即使应用只需要一个pod，我们也建议使用ReplicationController。

其他：[Job](https://kubernetes.io/docs/concepts/jobs/run-to-completion-finite-workloads/)、[DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

# Kubernetes StatefulSets

- [1 使用StatefulSets](http://docs.kubernetes.org.cn/443.html#StatefulSets)
- [2 限制](http://docs.kubernetes.org.cn/443.html#i)
- [3 组件](http://docs.kubernetes.org.cn/443.html#i-2)
- 4 部署和扩展
  - 4.1 Pod管理
    - [4.1.1 OrderedReady Pod Management](http://docs.kubernetes.org.cn/443.html#OrderedReady_Pod_Management)
    - [4.1.2 Parallel Pod Management](http://docs.kubernetes.org.cn/443.html#Parallel_Pod_Management)
- 5 Update Strategies
  - [5.1 删除](http://docs.kubernetes.org.cn/443.html#i-4)
  - 5.2 滚动更新
    - [5.2.1 Partitions](http://docs.kubernetes.org.cn/443.html#Partitions)

StatefulSets（有状态系统服务设计）在Kubernetes 1.7中还是beta特性，同时StatefulSets是1.4 版本中PetSets的替代品。PetSets的用户参考1.5 [升级指南](https://kubernetes.io/docs/tasks/manage-stateful-set/upgrade-pet-set-to-stateful-set/) 。

## 使用StatefulSets

在具有以下特点时使用StatefulSets：

- 稳定性，唯一的网络标识符。
- 稳定性，持久化存储。
- 有序的部署和扩展。
- 有序的删除和终止。
- 有序的自动滚动更新。

Pod调度运行时，如果应用不需要任何稳定的标示、有序的部署、删除和扩展，则应该使用一组无状态副本的控制器来部署应用，例如 [Deployment](http://docs.kubernetes.org.cn/317.html) 或 [ReplicaSet](http://docs.kubernetes.org.cn/314.html)更适合无状态服务需求。

## 限制

- StatefulSet还是beta特性，在Kubernetes 1.5版本之前任何版本都不可以使用。
- 与所有alpha / beta 特性的资源一样，可以通过apiserver配置-runtime-config来禁用StatefulSet。
- Pod的存储，必须基于请求storage class的[PersistentVolume Provisioner](http://releases.k8s.io/master/examples/persistent-volume-provisioning/README.md)或由管理员预先配置来提供。
- 基于数据安全性设计，删除或缩放StatefulSet将不会删除与StatefulSet关联的Volume。
- StatefulSets需要[Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)负责Pods的网络的一致性（必须创建此服务）。

## 组件

示例：

- name为nginx的Headless Service用于控制网络域。
- StatefulSet（name为web）有一个Spec，在一个Pod中启动具有3个副本的nginx容器。
- volumeClaimTemplates使用[PersistentVolumes](http://docs.kubernetes.org.cn/429.html)供应商的PersistentVolume来提供稳定的存储。

```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: nginx
        image: gcr.io/google_containers/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: my-storage-class
      resources:
        requests:
          storage: 1Gi
```

## 部署和扩展

- 对于具有N个副本的StatefulSet，当部署Pod时，将会顺序从{0..N-1}开始创建。
- Pods被删除时，会从{N-1..0}的相反顺序终止。
- 在将缩放操作应用于Pod之前，它的所有前辈必须运行和就绪。
- 对Pod执行扩展操作时，前面的Pod必须都处于Running和Ready状态。
- 在Pod终止之前，所有successors都须完全关闭。

不要将StatefulSet的pod.Spec.TerminationGracePeriodSeconds值设置为0，这样设置不安全，建议不要这么使用。更多说明，请参考[force deleting StatefulSet Pods](https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/).

在上面示例中，会按顺序部署三个pod（name: web-0、web-1、web-2）。web-0在[Running and Ready](https://kubernetes.io/docs/user-guide/pod-states)状态后开始部署web-1，web-1在Running and Ready状态后部署web-2，期间如果web-0运行失败，web-2是不会被运行，直到web-0重新运行，web-1、web-2才会按顺序进行运行。

如果用户通过StatefulSet来扩展修改部署pod副本数，比如修改replicas=1，那么web-2首先被终止。在web-2完全关闭和删除之前，web-1是不会被终止。如果在web-2被终止和完全关闭后，但web-1还没有被终止之前，此时web-0运行出错了，那么直到web-0再次变为Running and Ready状态之后，web-1才会被终止。

### Pod管理

在Kubernetes 1.7及更高版本中，StatefulSet放宽了排序规则，同时通过.spec.podManagementPolicy字段保留其uniqueness和identity guarantees

#### OrderedReady Pod Management

OrderedReady Pod Management 是StatefulSets的默认行为。它实现了上述 “部署/扩展” 行为。

#### Parallel Pod Management

Parallel Pod Management告诉StatefulSet控制器同时启动或终止所有Pod。

## Update Strategies

在Kubernetes 1.7及更高版本中，StatefulSet的.spec.updateStrategy字段允许配置和禁用StatefulSet中Pods的containers、[labels](http://docs.kubernetes.org.cn/247.html)、resource request/limits和[annotations](http://docs.kubernetes.org.cn/255.html)的滚动更新。

### 删除

当spec.updateStrategy未指定时的默认策略，OnDelete更新策略实现了传统（1.6和以前）的行为。当StatefulSet .spec.updateStrategy.type设置为OnDelete，StatefulSet控制器将不会自动更新StatefulSet中的Pod，用户必须手动删除Pods以使控制器创建新的Pod。

### 滚动更新

RollingUpdate更新策略实现了自动化，使StatefulSet中的Pod滚动更新。当StatefulSet .spec.updateStrategy.type设置为RollingUpdate，StatefulSet控制器将删除并重新创建StatefulSet中的每个Pod。它将以与Pod终止相同的顺序进行（从最大的序数到最小的顺序）来更新每个Pod。

#### Partitions

通过指定 .spec.updateStrategy.rollingUpdate.partition来分割RollingUpdate更新策略。如果指定了partition，则当更新StatefulSet时，将更新具有大于或等于partition的序数的所有Pods .spec.template，小于partition的序数的所有Pod将不会被更新。如果一个StatefulSet的.spec.updateStrategy.rollingUpdate.partition大于它.spec.replicas，它的更新.spec.template将不会被传Pods。在通常数情况下，不需要使用partition，但如果需要进行更新，推出金丝雀或执行分阶段推出，可以使用partition。

**了解更多** [StatefulSet: Kubernetes 中对有状态应用的运行和伸缩](https://www.kubernetes.org.cn/1130.html)

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# Kubernetes StatefulSet基本使用

- [1 Objectives](http://docs.kubernetes.org.cn/732.html#Objectives)
- 2 Before you begin
  - [2.1 顺序创建 Pod](http://docs.kubernetes.org.cn/732.html#_Pod)
- [3 Pods in a StatefulSet](http://docs.kubernetes.org.cn/732.html#Pods_in_a_StatefulSet)
- 4 StatefulSet 中的 Pod
  - [4.1 检查 Pod 的顺序索引](http://docs.kubernetes.org.cn/732.html#_Pod-2)
  - [4.2 使用稳定的网络身份标识](http://docs.kubernetes.org.cn/732.html#i)
  - [4.3 写入稳定的存储](http://docs.kubernetes.org.cn/732.html#i-2)
- 5 扩容/缩容 StatefulSet
  - [5.1 扩容](http://docs.kubernetes.org.cn/732.html#i-3)
  - [5.2 缩容](http://docs.kubernetes.org.cn/732.html#i-4)
  - [5.3 顺序终止 Pod](http://docs.kubernetes.org.cn/732.html#_Pod-3)
- 6 更新 StatefulSet
  - [6.1 On Delete 策略](http://docs.kubernetes.org.cn/732.html#On_Delete)
  - 6.2 Rolling Update 策略
    - [6.2.1 分段更新](http://docs.kubernetes.org.cn/732.html#i-5)
    - [6.2.2 灰度扩容](http://docs.kubernetes.org.cn/732.html#i-6)
    - [6.2.3 分阶段的扩容](http://docs.kubernetes.org.cn/732.html#i-7)
- 7 删除 StatefulSet
  - [7.1 非级联删除](http://docs.kubernetes.org.cn/732.html#i-8)
  - [7.2 级联删除](http://docs.kubernetes.org.cn/732.html#i-9)
- 8 Pod 管理策略
  - [8.1 OrderedReady Pod 管理策略](http://docs.kubernetes.org.cn/732.html#OrderedReady_Pod)
  - [8.2 Parallel Pod 管理策略](http://docs.kubernetes.org.cn/732.html#Parallel_Pod)
- [9 Cleaning up](http://docs.kubernetes.org.cn/732.html#Cleaning_up)

本教程介绍了如何使用 [StatefulSets](https://k8smeetup.github.io/docs/concepts/abstractions/controllers/statefulsets/) 来管理应用。演示了如何创建、删除、扩容/缩容和更新 StatefulSets 的 Pods。

## Objectives

StatefulSets 旨在与有状态的应用及分布式系统一起使用。然而在 Kubernetes  上管理有状态应用和分布式系统是一个宽泛而复杂的话题。为了演示 StatefulSet 的基本特性，并且不使前后的主题混淆，你将会使用  StatefulSet 部署一个简单的 web 应用。

在阅读本教程后，你将熟悉以下内容：

- 如何创建 StatefulSet
- StatefulSet 怎样管理它的 Pods
- 如何删除 StatefulSet
- 如何对 StatefulSet 进行扩容/缩容
- 如何更新一个 StatefulSet 的 Pods

## Before you begin

在开始本教程之前，你应该熟悉以下 Kubernetes 的概念：

- [Pods](http://docs.kubernetes.org.cn/312.html)
- [Cluster DNS](http://docs.kubernetes.org.cn/733.html)
- [Headless Services](http://docs.kubernetes.org.cn/703.html)
- [PersistentVolumes](http://docs.kubernetes.org.cn/429.html)
- [PersistentVolume Provisioning](https://github.com/kubernetes/examples/tree/master/staging/persistent-volume-provisioning/)
- [StatefulSets](http://docs.kubernetes.org.cn/443.html)
- [kubectl CLI](http://docs.kubernetes.org.cn/61.html)

本教程假设你的集群被配置为动态的提供 PersistentVolumes 。如果没有这样配置，在开始本教程之前，你需要手动准备5个1 GiB的存储卷。

\##创建 StatefulSet

作为开始，使用如下示例创建一个 StatefulSet。它和 [StatefulSets](http://docs.kubernetes.org.cn/443.html) 概念中的示例相似。它创建了一个 [Headless Service](http://docs.kubernetes.org.cn/703.html) nginx 用来发布StatefulSet web 中的 Pod 的 IP 地址。

| [web.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tutorials/stateful-application/web.yaml)![Copy web.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `--- apiVersion: v1 kind: Service metadata:  name: nginx  labels:    app: nginx spec:  ports:  - port: 80    name: web  clusterIP: None  selector:    app: nginx --- apiVersion: apps/v1beta1 kind: StatefulSet metadata:  name: web spec:  serviceName: "nginx"  replicas: 2  template:    metadata:      labels:        app: nginx    spec:      containers:      - name: nginx        image: gcr.io/google_containers/nginx-slim:0.8        ports:        - containerPort: 80          name: web        volumeMounts:        - name: www          mountPath: /usr/share/nginx/html  volumeClaimTemplates:  - metadata:      name: www    spec:      accessModes: [ "ReadWriteOnce" ]      resources:        requests:          storage: 1Gi ` |

下载上面的例子并保存为文件 web.yaml。

你需要使用两个终端窗口。在第一个终端中，使用 [kubectl get](http://docs.kubernetes.org.cn/626.html) 来查看 StatefulSet 的 Pods 的创建情况。

```
kubectl get pods -w -l app=nginx
```

在另一个终端中，使用 [kubectl create](http://docs.kubernetes.org.cn/490.html) 来创建定义在 web.yaml 中的 Headless Service 和 StatefulSet。

```
kubectl create -f web.yaml 
service "nginx" created
statefulset "web" created
```

上面的命令创建了两个 Pod，每个都运行了一个 NGINX web 服务器。获取 nginx Service 和 web StatefulSet 来验证是否成功的创建了它们。

```
kubectl get service nginx
NAME      CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
nginx     None         <none>        80/TCP    12s

kubectl get statefulset web
NAME      DESIRED   CURRENT   AGE
web       2         1         20s
```

### 顺序创建 Pod

对于一个拥有 N 个副本的 StatefulSet，Pod 被部署时是按照 {0..N-1}的序号顺序创建的。在第一个终端中使用 kubectl get 检查输出。这个输出最终将看起来像下面的样子。

```
kubectl get pods -w -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-0     0/1       Pending   0          0s
web-0     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         19s
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       ContainerCreating   0         0s
web-1     1/1       Running   0         18s
```

请注意在 web-0 Pod 处于 Running和Ready 状态后 web-1 Pod 才会被启动。

<!-

## Pods in a StatefulSet

–>

## StatefulSet 中的 Pod

StatefulSet 中的 Pod 拥有一个唯一的顺序索引和稳定的网络身份标识。

### 检查 Pod 的顺序索引

获取 StatefulSet 的 Pod。

```
kubectl get pods -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          1m
web-1     1/1       Running   0          1m
```

如同 StatefulSets 概念中所提到的， StatefulSet 中的 Pod  拥有一个具有黏性的、独一无二的身份标志。这个标志基于 StatefulSet 控制器分配给每个 Pod 的唯一顺序索引。 Pod  的名称的形式为<statefulset name>-<ordinal index>。web StatefulSet  拥有两个副本，所以它创建了两个 Pod：web-0和web-1。

### 使用稳定的网络身份标识

每个 Pod 都拥有一个基于其顺序索引的稳定的主机名。使用[kubectl exec](https://k8smeetup.github.io/docs/user-guide/kubectl/v1.7/#exec) 在每个 Pod 中执行hostname 。

```
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
web-0
web-1
```

使用 [kubectl run](http://docs.kubernetes.org.cn/468.html) 运行一个提供 nslookup 命令的容器，该命令来自于 dnsutils 包。通过对 Pod 的主机名执行 nslookup，你可以检查他们在集群内部的 DNS 地址。

```
kubectl run -i --tty --image busybox dns-test --restart=Never --rm /bin/sh 
nslookup web-0.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-0.nginx
Address 1: 10.244.1.6

nslookup web-1.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-1.nginx
Address 1: 10.244.2.6
```

headless service 的 CNAME 指向 SRV 记录（记录每个 Running 和 Ready 状态的 Pod）。SRV 记录指向一个包含 Pod IP 地址的记录表项。

在一个终端中查看 StatefulSet 的 Pod。

```
kubectl get pod -w -l app=nginx
```

在另一个终端中使用 [kubectl delete](http://docs.kubernetes.org.cn/618.html) 删除 StatefulSet 中所有的 Pod。

```
kubectl delete pod -l app=nginx
pod "web-0" deleted
pod "web-1" deleted
```

等待 StatefulSet 重启它们，并且两个 Pod 都变成 Running 和 Ready 状态。

```
kubectl get pod -w -l app=nginx
NAME      READY     STATUS              RESTARTS   AGE
web-0     0/1       ContainerCreating   0          0s
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          2s
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       ContainerCreating   0         0s
web-1     1/1       Running   0         34s
```

使用 kubectl exec 和 kubectl run 查看 Pod 的主机名和集群内部的 DNS 表项。

```
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
web-0
web-1

kubectl run -i --tty --image busybox dns-test --restart=Never --rm /bin/sh 
nslookup web-0.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-0.nginx
Address 1: 10.244.1.7

nslookup web-1.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-1.nginx
Address 1: 10.244.2.8
```

Pod 的序号、主机名、SRV 条目和记录名称没有改变，但和 Pod 相关联的 IP 地址可能发生了改变。在本教程中使用的集群中它们就改变了。这就是为什么不要在其他应用中使用 StatefulSet 中的 Pod 的 IP 地址进行连接，这点很重要。

如果你需要查找并连接一个 StatefulSet 的活动成员，你应该查询 Headless Service 的 CNAME。和 CNAME 相关联的 SRV 记录只会包含 StatefulSet 中处于 Running 和 Ready 状态的 Pod。

如果你的应用已经实现了用于测试 liveness 和 readiness 的连接逻辑，你可以使用 Pod 的 SRV  记录（web-0.nginx.default.svc.cluster.local, web-1.nginx.default.svc.cluster.local）。因为他们是稳定的，并且当你的 Pod 的状态变为 Running 和 Ready 时，你的应用就能够发现它们的地址。

### 写入稳定的存储

获取 web-0 和 web-1 的 PersistentVolumeClaims。

```
kubectl get pvc -l app=nginx
NAME        STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
www-web-0   Bound     pvc-15c268c7-b507-11e6-932f-42010a800002   1Gi        RWO           48s
www-web-1   Bound     pvc-15c79307-b507-11e6-932f-42010a800002   1Gi        RWO           48s
```

StatefulSet 控制器创建了两个  PersistentVolumeClaims，绑定到两个 PersistentVolumes。由于本教程使用的集群配置为动态提供  PersistentVolume，所有的 PersistentVolume 都是自动创建和绑定的。

NGINX web 服务器默认会加载位于 /usr/share/nginx/html/index.html 的 index  文件。StatefulSets spec 中的 volumeMounts 字段保证了 /usr/share/nginx/html 文件夹由一个  PersistentVolume 支持。

将Pod的主机名写入它们的 index.html 文件并验证 NGINX web 服务器使用该主机名提供服务。

```
for i in 0 1; do kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done

for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
web-0
web-1
```

请注意，如果你看见上面的 curl 命令返回了 403 Forbidden 的响应，你需要像这样修复使用 volumeMounts (due to a [bug when using hostPath volumes](https://github.com/kubernetes/kubernetes/issues/2630))挂载的目录的权限：

```
for i in 0 1; do kubectl exec web-$i -- chmod 755 /usr/share/nginx/html; done
```

在你重新尝试上面的 curl 命令之前。

在一个终端查看 StatefulSet 的 Pod。

```
kubectl get pod -w -l app=nginx
```

在另一个终端删除 StatefulSet 所有的 Pod。

```
kubectl delete pod -l app=nginx
pod "web-0" deleted
pod "web-1" deleted
```

在第一个终端里检查 kubectl get 命令的输出，等待所有 Pod 变成 Running 和 Ready 状态。

```
kubectl get pod -w -l app=nginx
NAME      READY     STATUS              RESTARTS   AGE
web-0     0/1       ContainerCreating   0          0s
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          2s
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       ContainerCreating   0         0s
web-1     1/1       Running   0         34s
```

验证所有 web 服务器在继续使用它们的主机名提供服务。

```
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
web-0
web-1
```

虽然 web-0 和 web-1 被重新调度了，但它们仍然继续监听各自的主机名，因为和它们的 PersistentVolumeClaim  相关联的 PersistentVolume  被重新挂载到了各自的 volumeMount上。不管 web-0 和 web-1 被调度到了哪个节点上，它们的  PersistentVolumes 将会被挂载到合适的挂载点上。

## 扩容/缩容 StatefulSet

扩容/缩容 StatefulSet 指增加或减少它的副本数。这通过更新 replicas 字段完成。你可以使用[kubectl scale](http://docs.kubernetes.org.cn/664.html) 或者[kubectl patch](http://docs.kubernetes.org.cn/632.html)来扩容/缩容一个 StatefulSet。

### 扩容

在一个终端窗口观察 StatefulSet 的 Pod。

```
kubectl get pods -w -l app=nginx
```

在另一个终端窗口使用 kubectl scale 扩展副本数为5。

```
kubectl scale sts web --replicas=5
statefulset "web" scaled
```

在第一个 终端中检查 kubectl get 命令的输出，等待增加的3个 Pod 的状态变为 Running 和 Ready。

```
kubectl get pods -w -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          2h
web-1     1/1       Running   0          2h
NAME      READY     STATUS    RESTARTS   AGE
web-2     0/1       Pending   0          0s
web-2     0/1       Pending   0         0s
web-2     0/1       ContainerCreating   0         0s
web-2     1/1       Running   0         19s
web-3     0/1       Pending   0         0s
web-3     0/1       Pending   0         0s
web-3     0/1       ContainerCreating   0         0s
web-3     1/1       Running   0         18s
web-4     0/1       Pending   0         0s
web-4     0/1       Pending   0         0s
web-4     0/1       ContainerCreating   0         0s
web-4     1/1       Running   0         19s
```

StatefulSet 控制器扩展了副本的数量。如同创建 StatefulSet所述，StatefulSet 按序号索引顺序的创建每个 Pod，并且会等待前一个 Pod 变为 Running 和 Ready 才会启动下一个Pod。

### 缩容

在一个终端观察 StatefulSet 的 Pod。

```
kubectl get pods -w -l app=nginx
```

在另一个终端使用 kubectl patch 将 StatefulSet 缩容回三个副本。

```
kubectl patch sts web -p '{"spec":{"replicas":3}}'
"web" patched
```

等待 web-4 和 web-3 状态变为 Terminating。

```
kubectl get pods -w -l app=nginx
NAME      READY     STATUS              RESTARTS   AGE
web-0     1/1       Running             0          3h
web-1     1/1       Running             0          3h
web-2     1/1       Running             0          55s
web-3     1/1       Running             0          36s
web-4     0/1       ContainerCreating   0          18s
NAME      READY     STATUS    RESTARTS   AGE
web-4     1/1       Running   0          19s
web-4     1/1       Terminating   0         24s
web-4     1/1       Terminating   0         24s
web-3     1/1       Terminating   0         42s
web-3     1/1       Terminating   0         42s
```

### 顺序终止 Pod

控制器会按照与 Pod 序号索引相反的顺序每次删除一个 Pod。在删除下一个 Pod 前会等待上一个被完全关闭。

获取 StatefulSet 的 PersistentVolumeClaims。

```
kubectl get pvc -l app=nginx
NAME        STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
www-web-0   Bound     pvc-15c268c7-b507-11e6-932f-42010a800002   1Gi        RWO           13h
www-web-1   Bound     pvc-15c79307-b507-11e6-932f-42010a800002   1Gi        RWO           13h
www-web-2   Bound     pvc-e1125b27-b508-11e6-932f-42010a800002   1Gi        RWO           13h
www-web-3   Bound     pvc-e1176df6-b508-11e6-932f-42010a800002   1Gi        RWO           13h
www-web-4   Bound     pvc-e11bb5f8-b508-11e6-932f-42010a800002   1Gi        RWO           13h
```

五个 PersistentVolumeClaims 和五个 PersistentVolumes 仍然存在。查看 Pod  的 稳定存储，我们发现当删除 StatefulSet 的 Pod 时，挂载到 StatefulSet 的 Pod 的  PersistentVolumes不会被删除。当这种删除行为是由 StatefulSe t缩容引起时也是一样的。

## 更新 StatefulSet

Kubernetes 1.7 版本的 StatefulSet 控制器支持自动更新。更新策略由 StatefulSet API Object 的 spec.updateStrategy 字段决定。这个特性能够用来更新一个 StatefulSet 中的 Pod 的 container  images, resource requests，以及 limits, labels 和 annotations。

### On Delete 策略

OnDelete 更新策略实现了传统（1.7之前）行为，它也是默认的更新策略。当你选择这个更新策略并修改 StatefulSet 的 .spec.template 字段时， StatefulSet 控制器将不会自动的更新Pod。

Patch web StatefulSet 的容器镜像。

```
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.7"}]'
statefulset "web" patched
```

删除 web-0 Pod。

```
kubectl delete pod web-0
pod "web-0" deleted
```

<– Watch the web-0 Pod, and wait for it to transition to Running and Ready. –> 观察 web-0 Pod， 等待它变成 Running 和 Ready。

```
kubectl get pod web-0 -w
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          54s
web-0     1/1       Terminating   0         1m
web-0     0/1       Terminating   0         1m
web-0     0/1       Terminating   0         1m
web-0     0/1       Terminating   0         1m
web-0     0/1       Pending   0         0s
web-0     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         3s
```

获取 web StatefulSet 的 Pod 来查看他们的容器镜像。

```
kubectl get pod -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
web-0   gcr.io/google_containers/nginx-slim:0.7
web-1   gcr.io/google_containers/nginx-slim:0.8
web-2   gcr.io/google_containers/nginx-slim:0.8
```

web-0 的镜像已经更新，但 web-1 和 web-2 仍然使用原来的镜像。请删除剩余的 pod 以完成更新操作。

```shell kubectl delete pod web-1 web-2 pod “web-1” deleted pod “web-2” deleted

```
观察 StatefulSet 的 Pod，等待它们全部变成 Running 和 Ready。
```

kubectl get pods -w -l app=nginx NAME READY STATUS RESTARTS AGE web-0 1/1 Running 0 8m web-1 1/1 Running 0 4h web-2 1/1 Running 0 23m NAME  READY STATUS RESTARTS AGE web-1 1/1 Terminating 0 4h web-1 1/1  Terminating 0 4h web-1 0/1 Pending 0 0s web-1 0/1 Pending 0 0s web-1 0/1 ContainerCreating 0 0s web-2 1/1 Terminating 0 23m web-2 1/1  Terminating 0 23m web-1 1/1 Running 0 4s web-2 0/1 Pending 0 0s web-2  0/1 Pending 0 0s web-2 0/1 ContainerCreating 0 0s web-2 1/1 Running 0  36s

```
获取 Pod 来查看他们的容器镜像。

```shell
kubectl get pod -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
web-0   gcr.io/google_containers/nginx-slim:0.7
web-1   gcr.io/google_containers/nginx-slim:0.7
web-2   gcr.io/google_containers/nginx-slim:0.7
```

现在，StatefulSet 中的 Pod 都已经运行了新的容器镜像。

### Rolling Update 策略

RollingUpdate 更新策略会更新一个 StatefulSet 中所有的 Pod，采用与序号索引相反的顺序并遵循 StatefulSet 的保证。

Patch web StatefulSet 来执行 RollingUpdate 更新策略。

```
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}
statefulset "web" patched
```

在一个终端窗口中 patch web StatefulSet 来再次的改变容器镜像。

```
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'
statefulset "web" patched
```

在另一个终端监控 StatefulSet 中的 Pod。

```
kubectl get po -l app=nginx -w
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          7m
web-1     1/1       Running   0          7m
web-2     1/1       Running   0          8m
web-2     1/1       Terminating   0         8m
web-2     1/1       Terminating   0         8m
web-2     0/1       Terminating   0         8m
web-2     0/1       Terminating   0         8m
web-2     0/1       Terminating   0         8m
web-2     0/1       Terminating   0         8m
web-2     0/1       Pending   0         0s
web-2     0/1       Pending   0         0s
web-2     0/1       ContainerCreating   0         0s
web-2     1/1       Running   0         19s
web-1     1/1       Terminating   0         8m
web-1     0/1       Terminating   0         8m
web-1     0/1       Terminating   0         8m
web-1     0/1       Terminating   0         8m
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       ContainerCreating   0         0s
web-1     1/1       Running   0         6s
web-0     1/1       Terminating   0         7m
web-0     1/1       Terminating   0         7m
web-0     0/1       Terminating   0         7m
web-0     0/1       Terminating   0         7m
web-0     0/1       Terminating   0         7m
web-0     0/1       Terminating   0         7m
web-0     0/1       Pending   0         0s
web-0     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         10s
```

StatefulSet 里的 Pod 采用和序号相反的顺序更新。在更新下一个 Pod 前，StatefulSet 控制器终止每个 Pod  并等待它们变成 Running 和 Ready。请注意，虽然在顺序后继者变成 Running 和 Ready 之前 StatefulSet  控制器不会更新下一个 Pod，但它仍然会重建任何在更新过程中发生故障的 Pod， 使用的是它们当前的版本。已经接收到更新请求的 Pod  将会被恢复为更新的版本，没有收到请求的 Pod  则会被恢复为之前的版本。像这样，控制器尝试继续使应用保持健康并在出现间歇性故障时保持更新的一致性。

获取 Pod 来查看他们的容器镜像。

```
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
gcr.io/google_containers/nginx-slim:0.8
gcr.io/google_containers/nginx-slim:0.8
gcr.io/google_containers/nginx-slim:0.8
```

StatefulSet 中的所有 Pod 现在都在运行之前的容器镜像。

小窍门：你还可以使用 kubectl rollout status sts/<name> 来查看 rolling update 的状态。

#### 分段更新

你可以使用 RollingUpdate 更新策略的 partition 参数来分段更新一个 StatefulSet。分段的更新将会使  StatefulSet 中的其余所有 Pod 保持当前版本的同时仅允许改变 StatefulSet 的.spec.template。

Patch web StatefulSet 来对 updateStrategy 字段添加一个分区。

```
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'
statefulset "web" patched
```

再次 Patch StatefulSet 来改变容器镜像。

```
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.7"}]'
statefulset "web" patched
```

删除 StatefulSet 中的 Pod。

```
kubectl delete po web-2
pod "web-2" deleted
```

等待 Pod 变成 Running 和 Ready。

```
kubectl get po -lapp=nginx -w
NAME      READY     STATUS              RESTARTS   AGE
web-0     1/1       Running             0          4m
web-1     1/1       Running             0          4m
web-2     0/1       ContainerCreating   0          11s
web-2     1/1       Running   0         18s
```

获取 Pod 的容器。

```
kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
gcr.io/google_containers/nginx-slim:0.8
```

请注意，虽然更新策略是 RollingUpdate，StatefulSet 控制器还是会使用原始的容器恢复 Pod。这是因为 Pod 的序号比 updateStrategy 指定的 partition 更小。

#### 灰度扩容

你可以通过减少 上文指定的 partition 来进行灰度扩容，以此来测试你的程序的改动。

Patch StatefulSet 来减少分区。

```
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'
statefulset "web" patched
```

等待 web-2 变成 Running 和 Ready。

```
kubectl get po -lapp=nginx -w
NAME      READY     STATUS              RESTARTS   AGE
web-0     1/1       Running             0          4m
web-1     1/1       Running             0          4m
web-2     0/1       ContainerCreating   0          11s
web-2     1/1       Running   0         18s
```

获取 Pod 的容器。

```
kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
gcr.io/google_containers/nginx-slim:0.7
```

当你改变 partition 时，StatefulSet 会自动的更新 web-2 Pod，这是因为 Pod 的序号小于或等于 partition。

删除 web-1 Pod。

```
kubectl delete po web-1
pod "web-1" deleted
```

等待 web-1 变成 Running 和 Ready。

```
kubectl get po -lapp=nginx -w
NAME      READY     STATUS        RESTARTS   AGE
web-0     1/1       Running       0          6m
web-1     0/1       Terminating   0          6m
web-2     1/1       Running       0          2m
web-1     0/1       Terminating   0         6m
web-1     0/1       Terminating   0         6m
web-1     0/1       Terminating   0         6m
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       ContainerCreating   0         0s
web-1     1/1       Running   0         18s
```

获取 web-1 Pod 的容器。

```
kubectl get po web-1 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
gcr.io/google_containers/nginx-slim:0.8
```

web-1 被按照原来的配置恢复，因为 Pod 的序号小于分区。当指定了分区时，如果更新了 StatefulSet  的 .spec.template，则所有序号大于或等于分区的 Pod 都将被更新。如果一个序号小于分区的 Pod  被删除或者终止，它将被按照原来的配置恢复。

#### 分阶段的扩容

你可以使用类似灰度扩容的方法执行一次分阶段的扩容（例如一次线性的、等比的或者指数形式的扩容）。要执行一次分阶段的扩容，你需要设置 partition 为希望控制器暂停更新的序号。

分区当前为2。请将分区设置为0。

```
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}'
statefulset "web" patched
```

等待 StatefulSet 中的所有 Pod 变成 Running 和 Ready。

```
kubectl get po -lapp=nginx -w
NAME      READY     STATUS              RESTARTS   AGE
web-0     1/1       Running             0          3m
web-1     0/1       ContainerCreating   0          11s
web-2     1/1       Running             0          2m
web-1     1/1       Running   0         18s
web-0     1/1       Terminating   0         3m
web-0     1/1       Terminating   0         3m
web-0     0/1       Terminating   0         3m
web-0     0/1       Terminating   0         3m
web-0     0/1       Terminating   0         3m
web-0     0/1       Terminating   0         3m
web-0     0/1       Pending   0         0s
web-0     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         3s
```

获取 Pod 的容器。

```
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
gcr.io/google_containers/nginx-slim:0.7
gcr.io/google_containers/nginx-slim:0.7
gcr.io/google_containers/nginx-slim:0.7
```

将 partition 改变为 0 以允许StatefulSet控制器继续更新过程。

## 删除 StatefulSet

StatefulSet 同时支持级联和非级联删除。使用非级联方式删除 StatefulSet 时，StatefulSet 的 Pod 不会被删除。使用级联删除时，StatefulSet 和它的 Pod 都会被删除。

### 非级联删除

在一个终端窗口查看 StatefulSet 中的 Pod。

```
kubectl get pods -w -l app=nginx
```

使用 kubectl delete 删 除StatefulSet。请确保提供了 --cascade=false 参数给命令。这个参数告诉 Kubernetes 只删除 StatefulSet 而不要删除它的任何 Pod。

```
kubectl delete statefulset web --cascade=false
statefulset "web" deleted
```

获取 Pod 来检查他们的状态。

```
kubectl get pods -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          6m
web-1     1/1       Running   0          7m
web-2     1/1       Running   0          5m
```

虽然 web 已经被删除了，但所有 Pod 仍然处于 Running 和 Ready 状态。 删除 web-0。

```
kubectl delete pod web-0
pod "web-0" deleted
```

获取 StatefulSet 的 Pod。

```
kubectl get pods -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-1     1/1       Running   0          10m
web-2     1/1       Running   0          7m
```

由于 web StatefulSet 已经被删除，web-0 没有被重新启动。

在一个终端监控 StatefulSet 的 Pod。

```
kubectl get pods -w -l app=nginx
```

在另一个终端里重新创建 StatefulSet。请注意，除非你删除了 nginx Service （你不应该这样做），你将会看到一个错误，提示 Service 已经存在。

```
kubectl create -f web.yaml 
statefulset "web" created
Error from server (AlreadyExists): error when creating "web.yaml": services "nginx" already exists
```

请忽略这个错误。它仅表示 kubernetes 进行了一次创建 nginx Headless Service 的尝试，尽管那个 Service 已经存在。

在第一个终端中运行并检查 kubectl get 命令的输出。

```
kubectl get pods -w -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-1     1/1       Running   0          16m
web-2     1/1       Running   0          2m
NAME      READY     STATUS    RESTARTS   AGE
web-0     0/1       Pending   0          0s
web-0     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         18s
web-2     1/1       Terminating   0         3m
web-2     0/1       Terminating   0         3m
web-2     0/1       Terminating   0         3m
web-2     0/1       Terminating   0         3m
```

当重新创建 web StatefulSet 时，web-0 被第一个重新启动。由于 web-1 已经处于 Running 和 Ready  状态，当 web-0 变成 Running 和 Ready 时，StatefulSet 会直接接收这个 Pod。由于你重新创建的  StatefulSet 的 replicas 等于2，一旦 web-0 被重新创建并且 web-1 被认为已经处于 Running 和  Ready 状态时，web-2 将会被终止。

让我们再看看被 Pod 的 web 服务器加载的 index.html 的内容。

```
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
web-0
web-1
```

尽管你同时删除了 StatefulSet  和 web-0 Pod，但它仍然使用最初写入 index.html 文件的主机名进行服务。这是因为 StatefulSet 永远不会删除和一个  Pod 相关联的 PersistentVolumes。当你重建这个 StatefulSet 并且重新启动了 web-0 时，它原本的  PersistentVolume 会被重新挂载。

### 级联删除

在一个终端窗口观察 StatefulSet 里的 Pod。

```
kubectl get pods -w -l app=nginx
```

在另一个窗口中再次删除这个 StatefulSet。这次省略 --cascade=false 参数。

```
kubectl delete statefulset web
statefulset "web" deleted
```

在第一个终端检查 kubectl get 命令的输出，并等待所有的 Pod 变成 Terminating 状态。

```
kubectl get pods -w -l app=nginx
NAME      READY     STATUS    RESTARTS   AGE
web-0     1/1       Running   0          11m
web-1     1/1       Running   0          27m
NAME      READY     STATUS        RESTARTS   AGE
web-0     1/1       Terminating   0          12m
web-1     1/1       Terminating   0         29m
web-0     0/1       Terminating   0         12m
web-0     0/1       Terminating   0         12m
web-0     0/1       Terminating   0         12m
web-1     0/1       Terminating   0         29m
web-1     0/1       Terminating   0         29m
web-1     0/1       Terminating   0         29m
```

如同你在缩容一节看到的，Pod 按照和他们序号索引相反的顺序每次终止一个。在终止一个 Pod 前，StatefulSet 控制器会等待 Pod 后继者被完全终止。

请注意，虽然级联删除会删除 StatefulSet 和它的 Pod，但它并不会删除和 StatefulSet 关联 的Headless Service。你必须手动删除 nginx Service。

```
kubectl delete service nginx
service "nginx" deleted
```

再一次重新创建 StatefulSet 和 Headless Service。

```
kubectl create -f web.yaml 
service "nginx" created
statefulset "web" created
```

当 StatefulSet 所有的 Pod 变成 Running 和 Ready 时，获取它们的 index.html 文件的内容。

```
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
web-0
web-1
```

即使你已经删除了 StatefulSet 和它的全部 Pod，这些 Pod 将会被重新创建并挂载它们的 PersistentVolumes，并且 web-0 和 web-1 将仍然使用它们的主机名提供服务。

最后删除 web StatefulSet 和 nginx service。

```
kubectl delete service nginx
service "nginx" deleted

kubectl delete statefulset web
statefulset "web" deleted
```

## Pod 管理策略

对于某些分布式系统来说，StatefulSet  的顺序性保证是不必要和/或者不应该的。这些系统仅仅要求唯一性和身份标志。为了解决这个问题，在 Kubernetes 1.7 中我们针对  StatefulSet API Object 引入了 .spec.podManagementPolicy。

### OrderedReady Pod 管理策略

OrderedReady pod 管理策略是 StatefulSets 的默认选项。它告诉 StatefulSet 控制器遵循上文展示的顺序性保证。

### Parallel Pod 管理策略

Parallel pod 管理策略告诉 StatefulSet 控制器并行的终止所有 Pod，在启动或终止另一个 Pod 前，不必等待这些 Pod 变成 Running 和 Ready 或者完全终止状态。

| [webp.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tutorials/stateful-application/webp.yaml)![Copy webp.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `--- apiVersion: v1 kind: Service metadata:  name: nginx  labels:    app: nginx spec:  ports:  - port: 80    name: web  clusterIP: None  selector:    app: nginx --- apiVersion: apps/v1beta1 kind: StatefulSet metadata:  name: web spec:  serviceName: "nginx"  podManagementPolicy: "Parallel"  replicas: 2  template:    metadata:      labels:        app: nginx    spec:      containers:      - name: nginx        image: gcr.io/google_containers/nginx-slim:0.8        ports:        - containerPort: 80          name: web        volumeMounts:        - name: www          mountPath: /usr/share/nginx/html  volumeClaimTemplates:  - metadata:      name: www    spec:      accessModes: [ "ReadWriteOnce" ]      resources:        requests:          storage: 1Gi ` |

下载上面的例子并保存为 webp.yaml。

这份清单和你在上文下载的完全一样，只是 web StatefulSet 的 .spec.podManagementPolicy 设置成了 Parallel。

在一个终端窗口查看 StatefulSet 中的 Pod。

```
kubectl get po -lapp=nginx -w
```

在另一个终端窗口创建清单中的 StatefulSet 和 Service。

```
kubectl create -f webp.yaml 
service "nginx" created
statefulset "web" created
```

查看你在第一个终端中运行的 kubectl get 命令的输出。

```
kubectl get po -lapp=nginx -w
NAME      READY     STATUS    RESTARTS   AGE
web-0     0/1       Pending   0          0s
web-0     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-1     0/1       Pending   0         0s
web-0     0/1       ContainerCreating   0         0s
web-1     0/1       ContainerCreating   0         0s
web-0     1/1       Running   0         10s
web-1     1/1       Running   0         10s
```

StatefulSet 控制器同时启动了 web-0 和 web-1。

保持第二个终端打开，并在另一个终端窗口中扩容 StatefulSet。

```
kubectl scale statefulset/web --replicas=4
statefulset "web" scaled
```

在 kubectl get 命令运行的终端里检查它的输出。

```
web-3     0/1       Pending   0         0s
web-3     0/1       Pending   0         0s
web-3     0/1       Pending   0         7s
web-3     0/1       ContainerCreating   0         7s
web-2     1/1       Running   0         10s
web-3     1/1       Running   0         26s
```

<! The StatefulSet controller launched two new Pods, and it did  not wait for the first to become Running and Ready prior to launching  the second.

Keep this terminal open, and in another terminal delete  the web StatefulSet. –> StatefulSet 控制器启动了两个新的  Pod，而且在启动第二个之前并没有等待第一个变成 Running 和 Ready 状态。

保持这个终端打开，并在另一个终端删除 web StatefulSet。

```
kubectl delete sts web
```

在另一个终端里再次检查 kubectl get 命令的输出。

```
web-3     1/1       Terminating   0         9m
web-2     1/1       Terminating   0         9m
web-3     1/1       Terminating   0         9m
web-2     1/1       Terminating   0         9m
web-1     1/1       Terminating   0         44m
web-0     1/1       Terminating   0         44m
web-0     0/1       Terminating   0         44m
web-3     0/1       Terminating   0         9m
web-2     0/1       Terminating   0         9m
web-1     0/1       Terminating   0         44m
web-0     0/1       Terminating   0         44m
web-2     0/1       Terminating   0         9m
web-2     0/1       Terminating   0         9m
web-2     0/1       Terminating   0         9m
web-1     0/1       Terminating   0         44m
web-1     0/1       Terminating   0         44m
web-1     0/1       Terminating   0         44m
web-0     0/1       Terminating   0         44m
web-0     0/1       Terminating   0         44m
web-0     0/1       Terminating   0         44m
web-3     0/1       Terminating   0         9m
web-3     0/1       Terminating   0         9m
web-3     0/1       Terminating   0         9m
```

StatefulSet 控制器将并发的删除所有 Pod，在删除一个 Pod 前不会等待它的顺序后继者终止。

关闭 kubectl get 命令运行的终端并删除 nginx Service。

```
kubectl delete svc nginx
```

## Cleaning up

你需要删除本教程中用到的 PersistentVolumes 的持久化存储媒体。基于你的环境、存储配置和提供方式，按照必须的步骤保证回收所有的存储。

本文由[xiaosuiba](https://github.com/xiaosuiba)翻译，点击查看[原文链接](https://k8smeetup.github.io/docs/tutorials/stateful-application/basic-stateful-set)。

# Kubernetes 示例：使用 Stateful Sets 部署 Cassandra

- [1 Objectives](http://docs.kubernetes.org.cn/736.html#Objectives)
- 2 Before you begin
  - [2.1 Minikube 附加安装说明](http://docs.kubernetes.org.cn/736.html#Minikube)
- 3 创建 Cassandra Headless Service
  - [3.1 验证（可选）](http://docs.kubernetes.org.cn/736.html#i)
- [4 使用 StatefulSet 创建 Cassandra 环](http://docs.kubernetes.org.cn/736.html#_StatefulSet_Cassandra)
- [5 验证 Cassandra StatefulSet](http://docs.kubernetes.org.cn/736.html#_Cassandra_StatefulSet)
- [6 修改 Cassandra StatefulSet](http://docs.kubernetes.org.cn/736.html#_Cassandra_StatefulSet-2)
- [7 Cleaning up](http://docs.kubernetes.org.cn/736.html#Cleaning_up)

本教程展示了如何在 Kubernetes 上开发一个云原生的 [Cassandra](http://cassandra.apache.org/) deployment。在这个实例中，Cassandra 使用了一个自定义的 SeedProvider 来发现新加入集群的节点。

在集群环境中部署类似 Cassandra 的有状态（stateful）应用可能是具有挑战性的。StatefulSets 极大的简化了这个过程。请阅读 [StatefulSets](http://docs.kubernetes.org.cn/443.html) 获取更多关于此教程中使用的这个特性的信息。

Cassandra Docker

Pod 使用了来自 Google [容器注册表（container registry）](https://cloud.google.com/container-registry/docs/) 的 [gcr.io/google-samples/cassandra:v12](https://github.com/kubernetes/examples/blob/master/cassandra/image/Dockerfile) 镜像。这个 docker 镜像基于 debian:jessie 并包含 OpenJDK 8。这个镜像包含了来自 Apache Debian 源的标准 Cassandra 安装。您可以通过环境变量来改变插入到 cassandra.yaml 中的值。

| ENV VAR                | DEFAULT VALUE  |
| ---------------------- | -------------- |
| CASSANDRA_CLUSTER_NAME | ‘Test Cluster’ |
| CASSANDRA_NUM_TOKENS   | 32             |
| CASSANDRA_RPC_ADDRESS  | 0.0.0.0        |

## Objectives

- 创建并验证 Cassandra headless [Services](http://docs.kubernetes.org.cn/703.html)。
- 使用 [StatefulSet](http://docs.kubernetes.org.cn/443.html) 创建 Cassandra 环（Cassandra ring）。
- 验证 [StatefulSet](http://docs.kubernetes.org.cn/732.html)。
- 修改 [StatefulSet](http://docs.kubernetes.org.cn/732.html)。
- 删除 [StatefulSet](http://docs.kubernetes.org.cn/732.html) 和它的 [Pod](http://docs.kubernetes.org.cn/312.html)。

## Before you begin

为了完成本教程，你应该对 [Pod](http://docs.kubernetes.org.cn/312.html)、 [Service](http://docs.kubernetes.org.cn/703.html) 和 StatefulSet 有基本的了解。此外，你还应该：

- [安装并配置 ](https://www.kubernetes.org.cn/installkubectl)kubectl 命令行工具
- 下载 [cassandra-service.yaml](https://k8smeetup.github.io/docs/tutorials/stateful-application/cassandra/cassandra-service.yaml) 和 [cassandra-statefulset.yaml](https://k8smeetup.github.io/docs/tutorials/stateful-application/cassandra/cassandra-statefulset.yaml)
- 有一个支持（这些功能）并正常运行的 Kubernetes 集群

注意： 如果你还没有集群，请查阅 [快速入门指南](http://docs.kubernetes.org.cn)。

### Minikube 附加安装说明

小心： [Minikube](http://docs.kubernetes.org.cn/94.html) 默认配置 1024MB 内存和 1 CPU，这在本例中将导致资源不足。

为了避免这些错误，请这样运行 minikube：

```
minikube start --memory 5120 --cpus=4
```

## 创建 Cassandra Headless Service

Kubernetes Service 描述了一个执行相同任务的 Pod 集合。

下面的 Service 用于在集群内部的 Cassandra Pod 和客户端之间进行 DNS 查找。

1. 在下载清单文件的文件夹下启动一个终端窗口。

2. 使用 cassandra-service.yaml 文件创建一个 Service，用于追踪所有的 Cassandra StatefulSet 节点。

```
   kubectl create -f cassandra-service.yaml
```

| [cassandra/cassandra-service.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tutorials/stateful-application/cassandra/cassandra-service.yaml)![Copy cassandra/cassandra-service.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Service metadata:  labels:    app: cassandra  name: cassandra spec:  clusterIP: None  ports:  - port: 9042  selector:    app: cassandra ` |

### 验证（可选）

获取 Cassandra Service。

   ```
kubectl get svc cassandra
   ```

响应应该像这样：

```
NAME        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
cassandra   None         <none>        9042/TCP   45s
```

如果返回了任何其它消息，这个 service 就没有被成功创建。请查阅 [调试 Services](https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-service/)，了解常见问题。

## 使用 StatefulSet 创建 Cassandra 环

上文中的 StatefulSet 清单文件将创建一个由 3 个 pod 组成的 Cassandra 环。

注意： 本例中的 Minikube 使用默认 provisioner。请根据您使用的云服务商更新下面的 StatefulSet。

1. 如有必要请修改 StatefulSet。

2. 使用 cassandra-statefulset.yaml 文件创建 Cassandra StatefulSet。

```
   kubectl create -f cassandra-statefulset.yaml
```

| [cassandra/cassandra-statefulset.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/tutorials/stateful-application/cassandra/cassandra-statefulset.yaml)![Copy cassandra/cassandra-statefulset.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: "apps/v1beta1" kind: StatefulSet metadata:  name: cassandra spec:  serviceName: cassandra  replicas: 3  template:    metadata:      labels:        app: cassandra    spec:      containers:      - name: cassandra        image: gcr.io/google-samples/cassandra:v12        imagePullPolicy: Always        ports:        - containerPort: 7000          name: intra-node        - containerPort: 7001          name: tls-intra-node        - containerPort: 7199          name: jmx        - containerPort: 9042          name: cql        resources:          limits:            cpu: "500m"            memory: 1Gi          requests:           cpu: "500m"           memory: 1Gi        securityContext:          capabilities:            add:              - IPC_LOCK        lifecycle:          preStop:            exec:              command: ["/bin/sh", "-c", "PID=$(pidof java) && kill $PID && while ps -p $PID > /dev/null; do sleep 1; done"]        env:          - name: MAX_HEAP_SIZE            value: 512M          - name: HEAP_NEWSIZE            value: 100M          - name: CASSANDRA_SEEDS            value: "cassandra-0.cassandra.default.svc.cluster.local"          - name: CASSANDRA_CLUSTER_NAME            value: "K8Demo"          - name: CASSANDRA_DC            value: "DC1-K8Demo"          - name: CASSANDRA_RACK            value: "Rack1-K8Demo"          - name: CASSANDRA_AUTO_BOOTSTRAP            value: "false"          - name: POD_IP            valueFrom:              fieldRef:                fieldPath: status.podIP        readinessProbe:          exec:            command:            - /bin/bash            - -c            - /ready-probe.sh          initialDelaySeconds: 15          timeoutSeconds: 5        # These volume mounts are persistent. They are like inline claims,        # but not exactly because the names need to match exactly one of        # the stateful pod volumes.        volumeMounts:        - name: cassandra-data          mountPath: /cassandra_data  # These are converted to volume claims by the controller  # and mounted at the paths mentioned above.  # do not use these in production until ssd GCEPersistentDisk or other ssd pd  volumeClaimTemplates:  - metadata:      name: cassandra-data      annotations:        volume.beta.kubernetes.io/storage-class: fast    spec:      accessModes: [ "ReadWriteOnce" ]      resources:        requests:          storage: 1Gi --- kind: StorageClass apiVersion: storage.k8s.io/v1beta1 metadata:  name: fast provisioner: k8s.io/minikube-hostpath parameters:  type: pd-ssd ` |

## 验证 Cassandra StatefulSet

1. 获取 Cassandra StatefulSet：

   ```
   kubectl get statefulset cassandra
   ```

   响应应该是

   ```
   NAME        DESIRED   CURRENT   AGE
   cassandra   3         0         13s
   ```

   StatefulSet 资源顺序的部署 pod。

2. 获取 pod， 查看顺序创建的状态：

   ```
   kubectl get pods -l="app=cassandra"
   ```

   响应应该像是

   ```
   NAME          READY     STATUS              RESTARTS   AGE
   cassandra-0   1/1       Running             0          1m
   cassandra-1   0/1       ContainerCreating   0          8s
   ```

   注意： 部署全部三个 pod 可能需要 10 分钟时间。

   一旦所有 pod 都已经部署，相同的命令将返回：

   ```
   NAME          READY     STATUS    RESTARTS   AGE
   cassandra-0   1/1       Running   0          10m
   cassandra-1   1/1       Running   0          9m
   cassandra-2   1/1       Running   0          8m
   ```

3. 运行 Cassandra nodetool 工具，显示环的状态。

   ```
   kubectl exec cassandra-0 -- nodetool status
   ```

   响应为：

   ```
   Datacenter: DC1-K8Demo
   ======================
   Status=Up/Down
   |/ State=Normal/Leaving/Joining/Moving
   --  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
   UN  172.17.0.5  83.57 KiB  32           74.0%             e2dd09e6-d9d3-477e-96c5-45094c08db0f  Rack1-K8Demo
   UN  172.17.0.4  101.04 KiB  32           58.8%             f89d6835-3a42-4419-92b3-0e62cae1479c  Rack1-K8Demo
   UN  172.17.0.6  84.74 KiB  32           67.1%             a6a1e8c2-3dc5-4417-b1a0-26507af2aaad  Rack1-K8Demo
   ```

## 修改 Cassandra StatefulSet

使用 kubectl edit修改 Cassandra StatefulSet 的大小。

1. 运行下面的命令：

   ```
   kubectl edit statefulset cassandra
   ```

   这个命令将在终端中打开一个编辑器。您需要修改 replicas 字段一行。

   注意： 以下示例是 StatefulSet 文件的摘录。

   ```
    # Please edit the object below. Lines beginning with a '#' will be ignored,
    # and an empty file will abort the edit. If an error occurs while saving this file will be
    # reopened with the relevant failures.
    #
    apiVersion: apps/v1beta1
    kind: StatefulSet
    metadata:
     creationTimestamp: 2016-08-13T18:40:58Z
     generation: 1
     labels:
       app: cassandra
     name: cassandra
     namespace: default
     resourceVersion: "323"
     selfLink: /apis/apps/v1beta1/namespaces/default/statefulsets/cassandra
     uid: 7a219483-6185-11e6-a910-42010a8a0fc0
    spec:
     replicas: 3
   ```

2. 修改副本数量为 4 并保存清单文件。

   这个 StatefulSet 现在包含 4 个 pod。

3. 获取 Cassandra StatefulSet 来进行验证：

   ```
   kubectl get statefulset cassandra
   ```

   响应应该为：

   ```
   NAME        DESIRED   CURRENT   AGE
   cassandra   4         4         36m
   ```

## Cleaning up

删除或缩容 StatefulSet 不会删除与其相关联的 volume。这优先保证了安全性：您的数据比其它所有自动清理的 StatefulSet 资源都更宝贵。

警告： 取决于 storage class 和回收策略（reclaim policy），删除 Persistent Volume Claims 可能导致关联的 volume 也被删除。绝对不要假设在 volume claim 被删除后还能访问数据。

1. 运行下面的命令，删除 StatefulSet 中所有能内容：

   ```
   grace=$(kubectl get po cassandra-0 -o=jsonpath='{.spec.terminationGracePeriodSeconds}') \
     && kubectl delete statefulset -l app=cassandra \
     && echo "Sleeping $grace" \
     && sleep $grace \
     && kubectl delete pvc -l app=cassandra
   ```

2. 运行下面的命令，删除 Cassandra Service。

   ```
   kubectl delete service -l app=cassandra
   ```

本文由[xiaosuiba](https://github.com/xiaosuiba)翻译，点击查看[原文链接](https://k8smeetup.github.io/docs/tutorials/stateful-application/cassandra)

![K8S中文社区微信公众号](https://www.kubernetes.org.cn/img/2018/05/2018051201.jpg) 	

# [Kubernetes Ingress解析](https://www.kubernetes.org.cn/1885.html)

​				2017-04-20 09:46 											 						 						[中文社区](https://www.kubernetes.org.cn/author/edit) 							 			 			分类：[Kubernetes教程/入门教程](https://www.kubernetes.org.cn/course) 							阅读(65127)				 			 			 			译者：Jimmy Song | [原文](https://kubernetes.io/docs/concepts/services-networking/ingress/) | [译文](http://rootsongjc.github.io/blogs/kubernetes-ingress-resource/?from=timeline&isappinstalled=0)				 			 							 			评论(3) 			 		

## 前言

这是kubernete官方文档中[Ingress Resource](https://kubernetes.io/docs/concepts/services-networking/ingress/)的翻译，因为最近工作中用到，文章也不长，也很好理解，索性翻译一下，也便于自己加深理解，同时造福[kubernetes中文社区](https://www.kubernetes.org.cn/)。后续准备使用[Traefik](https://github.com/containous/traefik)来做Ingress controller，文章末尾给出了几个相关链接，实际使用案例正在摸索中，届时相关安装文档和配置说明将同步更新到[kubernetes-handbook](https://github.com/rootsongjc/kubernetes-handbook)中。

**术语**

在本篇文章中你将会看到一些在其他地方被交叉使用的术语，为了防止产生歧义，我们首先来澄清下。

- 节点：Kubernetes集群中的一台物理机或者虚拟机。
- 集群：位于Internet防火墙后的节点，这是kubernetes管理的主要计算资源。
- 边界路由器：为集群强制执行防火墙策略的路由器。 这可能是由云提供商或物理硬件管理的网关。
- 集群网络：一组逻辑或物理链接，可根据Kubernetes[网络模型](https://kubernetes.io/docs/admin/networking/)实现群集内的通信。 集群网络的实现包括Overlay模型的 [flannel](https://github.com/coreos/flannel#flannel) 和基于SDN的[OVS](https://kubernetes.io/docs/admin/ovs-networking/)。
- 服务：使用标签选择器标识一组pod成为的Kubernetes[服务](https://kubernetes.io/docs/user-guide/services/)。 除非另有说明，否则服务假定在集群网络内仅可通过虚拟IP访问。

## 什么是Ingress？

通常情况下，service和pod仅可在集群内部网络中通过IP地址访问。所有到达边界路由器的流量或被丢弃或被转发到其他地方。从概念上讲，可能像下面这样：

   ```
    internet
        |
------------
  [ Services ]
   ```

Ingress是授权入站连接到达集群服务的规则集合。

```
    internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]
```

你可以给Ingress配置提供外部可访问的URL、负载均衡、SSL、基于名称的虚拟主机等。用户通过POST Ingress资源到API server的方式来请求ingress。 [Ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-controllers)负责实现Ingress，通常使用负载平衡器，它还可以配置边界路由和其他前端，这有助于以HA方式处理流量。

## 先决条件

在使用Ingress resource之前，有必要先了解下面几件事情。Ingress是beta版本的resource，在kubernetes1.1之前还没有。你需要一个`Ingress Controller`来实现`Ingress`，单纯的创建一个`Ingress`没有任何意义。

GCE/GKE会在master节点上部署一个ingress controller。你可以在一个pod中部署任意个自定义的ingress controller。你必须正确地annotate每个ingress，比如 [运行多个ingress controller](https://github.com/kubernetes/ingress/tree/master/controllers/nginx#running-multiple-ingress-controllers) 和 [关闭glbc](https://github.com/kubernetes/ingress/blob/master/controllers/gce/BETA_LIMITATIONS.md#disabling-glbc).

确定你已经阅读了Ingress controller的[beta版本限制](https://github.com/kubernetes/ingress/blob/master/controllers/gce/BETA_LIMITATIONS.md)。在非GCE/GKE的环境中，你需要在pod中[部署一个controller](https://github.com/kubernetes/ingress/tree/master/controllers)。

## Ingress Resource

最简化的Ingress配置：

```yaml
1: apiVersion: extensions/v1beta1
2: kind: Ingress
3: metadata:
4:   name: test-ingress
5: spec:
6:   rules:
7:   - http:
8:       paths:
9:       - path: /testpath
10:        backend:
11:           serviceName: test
12:           servicePort: 80
```

*如果你没有配置Ingress controller就将其POST到API server不会有任何用处*

**配置说明**

**1-4行**：跟Kubernetes的其他配置一样，ingress的配置也需要`apiVersion`，`kind`和`metadata`字段。配置文件的详细说明请查看[部署应用](https://kubernetes.io/docs/user-guide/deploying-applications), [配置容器](https://kubernetes.io/docs/user-guide/configuring-containers)和 [使用resources](https://kubernetes.io/docs/user-guide/working-with-resources).

**5-7行**: Ingress [spec](https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#spec-and-status) 中包含配置一个loadbalancer或proxy server的所有信息。最重要的是，它包含了一个匹配所有入站请求的规则列表。目前ingress只支持http规则。

**8-9行**：每条http规则包含以下信息：一个`host`配置项（比如for.bar.com，在这个例子中默认是*），`path`列表（比如：/testpath），每个path都关联一个`backend`(比如test:80)。在loadbalancer将流量转发到backend之前，所有的入站请求都要先匹配host和path。

**10-12行**：正如 [services doc](https://kubernetes.io/docs/user-guide/services)中描述的那样，backend是一个`service:port`的组合。Ingress的流量被转发到它所匹配的backend。

**全局参数**：为了简单起见，Ingress示例中没有全局参数，请参阅资源完整定义的[api参考](https://releases.k8s.io/master/pkg/apis/extensions/v1beta1/types.go)。 在所有请求都不能跟spec中的path匹配的情况下，请求被发送到Ingress controller的默认后端，可以指定全局缺省backend。

## Ingress Controllers

为了使Ingress正常工作，集群中必须运行Ingress controller。 这与其他类型的控制器不同，其他类型的控制器通常作为`kube-controller-manager`二进制文件的一部分运行，在集群启动时自动启动。 你需要选择最适合自己集群的Ingress controller或者自己实现一个。 示例和说明可以在[这里](https://github.com/kubernetes/ingress/tree/master/controllers)找到。

## 在你开始前

以下文档描述了Ingress资源中公开的一组跨平台功能。 理想情况下，所有的Ingress controller都应该符合这个规范，但是我们还没有实现。 GCE和nginx控制器的文档分别在[这里](https://github.com/kubernetes/ingress/blob/master/controllers/gce/README.md)和[这里](https://github.com/kubernetes/ingress/blob/master/controllers/nginx/README.md)。**确保您查看控制器特定的文档，以便您了解每个文档的注意事项。**

## Ingress类型

### 单Service Ingress

Kubernetes中已经存在一些概念可以暴露单个service（查看[替代方案](https://kubernetes.io/docs/concepts/services-networking/ingress/#alternatives)），但是你仍然可以通过Ingress来实现，通过指定一个没有rule的默认backend的方式。

ingress.yaml定义文件：

```Yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  backend:
    serviceName: testsvc
    servicePort: 80
```

使用`kubectl create -f`命令创建，然后查看ingress：

```bash
$ kubectl get ing
NAME                RULE          BACKEND        ADDRESS
test-ingress        -             testsvc:80     107.178.254.228
```

`107.178.254.228`就是Ingress controller为了实现Ingress而分配的IP地址。`RULE`列表示所有发送给该IP的流量都被转发到了`BACKEND`所列的Kubernetes service上。

### 简单展开

如前面描述的那样，kubernete  pod中的IP只在集群网络内部可见，我们需要在边界设置一个东西，让它能够接收ingress的流量并将它们转发到正确的端点上。这个东西一般是高可用的loadbalancer。使用Ingress能够允许你将loadbalancer的个数降低到最少，例如，嫁入你想要创建这样的一个设置：

```
foo.bar.com -> 178.91.123.132 -> / foo    s1:80
                                 / bar    s2:80
```

你需要一个这样的ingress：

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: s1
          servicePort: 80
      - path: /bar
        backend:
          serviceName: s2
          servicePort: 80
```

使用`kubectl create -f`创建完ingress后：

```bash
$ kubectl get ing
NAME      RULE          BACKEND   ADDRESS
test      -
          foo.bar.com
          /foo          s1:80
          /bar          s2:80
```

只要服务（s1，s2）存在，Ingress controller就会将提供一个满足该Ingress的特定loadbalancer实现。 这一步完成后，您将在Ingress的最后一列看到loadbalancer的地址。

### 基于名称的虚拟主机

Name-based的虚拟主机在同一个IP地址下拥有多个主机名。

```
foo.bar.com --|                 |-> foo.bar.com s1:80
              | 178.91.123.132  |
bar.foo.com --|                 |-> bar.foo.com s2:80
```

下面这个ingress说明基于[Host header](https://tools.ietf.org/html/rfc7230#section-5.4)的后端loadbalancer的路由请求：

```Yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - backend:
          serviceName: s1
          servicePort: 80
  - host: bar.foo.com
    http:
      paths:
      - backend:
          serviceName: s2
          servicePort: 80
```

**默认backend**：一个没有rule的ingress，如前面章节中所示，所有流量都将发送到一个默认backend。你可以用该技巧通知loadbalancer如何找到你网站的404页面，通过制定一些列rule和一个默认backend的方式。如果请求header中的host不能跟ingress中的host匹配，并且/或请求的URL不能与任何一个path匹配，则流量将路由到你的默认backend。

### TLS

你可以通过指定包含TLS私钥和证书的[secret](https://kubernetes.io/docs/user-guide/secrets)来加密Ingress。 目前，Ingress仅支持单个TLS端口443，并假定TLS termination。  如果Ingress中的TLS配置部分指定了不同的主机，则它们将根据通过SNI TLS扩展指定的主机名（假如Ingress  controller支持SNI）在多个相同端口上进行复用。 TLS secret中必须包含名为`tls.crt`和`tls.key`的密钥，这里面包含了用于TLS的证书和私钥，例如：

```Yaml
apiVersion: v1
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
kind: Secret
metadata:
  name: testsecret
  namespace: default
type: Opaque
```

在Ingress中引用这个secret将通知Ingress controller使用TLS加密从将客户端到loadbalancer的channel：

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: no-rules-map
spec:
  tls:
    - secretName: testsecret
  backend:
    serviceName: s1
    servicePort: 80
```

请注意，各种Ingress controller支持的TLS功能之间存在差距。 请参阅有关[nginx](https://github.com/kubernetes/ingress/blob/master/controllers/nginx/README.md#https)，[GCE](https://github.com/kubernetes/ingress/blob/master/controllers/gce/README.md#tls)或任何其他平台特定Ingress controller的文档，以了解TLS在你的环境中的工作原理。

Ingress controller启动时附带一些适用于所有Ingress的负载平衡策略设置，例如负载均衡算法，后端权重方案等。更高级的负载平衡概念（例如持久会话，动态权重）尚未在Ingress中公开。 你仍然可以通过[service loadbalancer](https://github.com/kubernetes/contrib/tree/master/service-loadbalancer)获取这些功能。 随着时间的推移，我们计划将适用于跨平台的负载平衡模式加入到Ingress资源中。

还值得注意的是，尽管健康检查不直接通过Ingress公开，但Kubernetes中存在并行概念，例如[准备探查](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)，可以使你达成相同的最终结果。 请查看特定控制器的文档，以了解他们如何处理健康检查（[nginx](https://github.com/kubernetes/ingress/blob/master/controllers/nginx/README.md)，[GCE](https://github.com/kubernetes/ingress/blob/master/controllers/gce/README.md#health-checks)）。

## 更新Ingress

假如你想要向已有的ingress中增加一个新的Host，你可以编辑和更新该ingress：

```Bash
$ kubectl get ing
NAME      RULE          BACKEND   ADDRESS
test      -                       178.91.123.132
          foo.bar.com
          /foo          s1:80
$ kubectl edit ing test
```

这会弹出一个包含已有的yaml文件的编辑器，修改它，增加新的Host配置。

```yaml
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - backend:
          serviceName: s1
          servicePort: 80
        path: /foo
  - host: bar.baz.com
    http:
      paths:
      - backend:
          serviceName: s2
          servicePort: 80
        path: /foo
..
```

保存它会更新API server中的资源，这会触发ingress controller重新配置loadbalancer。

```bash
$ kubectl get ing
NAME      RULE          BACKEND   ADDRESS
test      -                       178.91.123.132
          foo.bar.com
          /foo          s1:80
          bar.baz.com
          /foo          s2:80
```

在一个修改过的ingress yaml文件上调用`kubectl replace -f`命令一样可以达到同样的效果。

## 跨可用域故障

在不通云供应商之间，跨故障域的流量传播技术有所不同。 有关详细信息，请查看相关Ingress controller的文档。 有关在federation集群中部署Ingress的详细信息，请参阅[federation文档]()。

## 未来计划

- 多样化的HTTPS/TLS模型支持（如SNI，re-encryption）
- 通过声明来请求IP或者主机名
- 结合L4和L7 Ingress
- 更多的Ingress controller

请跟踪[L7和Ingress的proposal](https://github.com/kubernetes/kubernetes/pull/12827)，了解有关资源演进的更多细节，以及[Ingress repository](https://github.com/kubernetes/ingress/tree/master)，了解有关各种Ingress controller演进的更多详细信息。

## 替代方案

你可以通过很多种方式暴露service而不必直接使用ingress：

- 使用[Service.Type=LoadBalancer](https://kubernetes.io/docs/user-guide/services/#type-loadbalancer)
- 使用[Service.Type=NodePort](https://kubernetes.io/docs/user-guide/services/#type-nodeport)
- 使用[Port Proxy](https://github.com/kubernetes/contrib/tree/master/for-demos/proxy-to-service)
- 部署一个[Service loadbalancer](https://github.com/kubernetes/contrib/tree/master/service-loadbalancer) 这允许你在多个service之间共享单个IP，并通过Service Annotations实现更高级的负载平衡。

# Kubernetes Service

- 1 定义 Service
  - [1.1 没有 selector 的 Service](http://docs.kubernetes.org.cn/703.html#_selector_Service)
- 2 VIP 和 Service 代理
  - [2.1 userspace 代理模式](http://docs.kubernetes.org.cn/703.html#userspace)
  - [2.2 iptables 代理模式](http://docs.kubernetes.org.cn/703.html#iptables)
- [3 多端口 Service](http://docs.kubernetes.org.cn/703.html#_Service-2)
- 4 选择自己的 IP 地址
  - [4.1 为何不使用 round-robin DNS？](http://docs.kubernetes.org.cn/703.html#_round-robin_DNS)
- 5 服务发现
  - [5.1 环境变量](http://docs.kubernetes.org.cn/703.html#i-2)
  - [5.2 DNS](http://docs.kubernetes.org.cn/703.html#DNS)
- 6 Headless Service
  - [6.1 配置 Selector](http://docs.kubernetes.org.cn/703.html#_Selector)
  - [6.2 不配置 Selector](http://docs.kubernetes.org.cn/703.html#_Selector-2)
- 7 发布服务 —— 服务类型
  - [7.1 NodePort 类型](http://docs.kubernetes.org.cn/703.html#NodePort)
  - [7.2 LoadBalancer 类型](http://docs.kubernetes.org.cn/703.html#LoadBalancer)
  - [7.3 AWS 内部负载均衡器](http://docs.kubernetes.org.cn/703.html#AWS)
  - [7.4 AWS SSL 支持](http://docs.kubernetes.org.cn/703.html#AWS_SSL)
  - [7.5 外部 IP](http://docs.kubernetes.org.cn/703.html#_IP-2)
- [8 不足之处](http://docs.kubernetes.org.cn/703.html#i-4)
- [9 未来工作](http://docs.kubernetes.org.cn/703.html#i-5)
- 10 VIP 的那些骇人听闻的细节
  - [10.1 避免冲突](http://docs.kubernetes.org.cn/703.html#i-6)
  - 10.2 IP 和 VIP
    - [10.2.1 Userspace](http://docs.kubernetes.org.cn/703.html#Userspace)
    - [10.2.2 Iptables](http://docs.kubernetes.org.cn/703.html#Iptables)
- [11 API 对象](http://docs.kubernetes.org.cn/703.html#API)
- [12 更多信息](http://docs.kubernetes.org.cn/703.html#i-7)

Kubernetes [Pod](http://docs.kubernetes.org.cn/312.html) 是有生命周期的，它们可以被创建，也可以被销毁，然而一旦被销毁生命就永远结束。 通过 [ReplicationController](http://docs.kubernetes.org.cn/437.html) 能够动态地创建和销毁 Pod（例如，需要进行扩缩容，或者执行 [滚动升级](https://k8smeetup.github.io/docs/user-guide/kubectl/v1.7/#rolling-update)）。 每个 Pod 都会获取它自己的 IP 地址，即使这些 IP 地址不总是稳定可依赖的。 这会导致一个问题：在 Kubernetes  集群中，如果一组 Pod（称为 backend）为其它 Pod （称为 frontend）提供服务，那么那些 frontend  该如何发现，并连接到这组 Pod 中的哪些 backend 呢？

关于 Service

Kubernetes Service 定义了这样一种抽象：一个 Pod 的逻辑分组，一种可以访问它们的策略 —— 通常称为微服务。 这一组 Pod 能够被 Service 访问到，通常是通过 [Label Selector](http://docs.kubernetes.org.cn/247.html)（查看下面了解，为什么可能需要没有 selector 的 Service）实现的。

举个例子，考虑一个图片处理 backend，它运行了3个副本。这些副本是可互换的 —— frontend 不需要关心它们调用了哪个  backend 副本。 然而组成这一组 backend 程序的 Pod 实际上可能会发生变化，frontend  客户端不应该也没必要知道，而且也不需要跟踪这一组 backend 的状态。 Service 定义的抽象能够解耦这种关联。

对 Kubernetes 集群中的应用，Kubernetes  提供了简单的 Endpoints API，只要 Service 中的一组 Pod 发生变更，应用程序就会被更新。 对非 Kubernetes  集群中的应用，Kubernetes 提供了基于 VIP 的网桥的方式访问 Service，再由 Service 重定向到  backend Pod。

## 定义 Service

一个 Service 在 Kubernetes 中是一个 REST 对象，和 Pod 类似。 像所有的 REST  对象一样， Service 定义可以基于 POST 方式，请求 apiserver 创建新的实例。 例如，假定有一组 Pod，它们对外暴露了  9376 端口，同时还被打上 "app=MyApp" 标签。

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

上述配置将创建一个名称为 “my-service” 的 Service 对象，它会将请求代理到使用 TCP 端口  9376，并且具有标签 "app=MyApp" 的 Pod 上。 这个 Service 将被指派一个 IP 地址（通常称为 “Cluster  IP”），它会被服务的代理使用（见下面）。 该 Service 的 selector 将会持续评估，处理结果将被 POST 到一个名称为  “my-service” 的 Endpoints 对象上。

需要注意的是， Service 能够将一个接收端口映射到任意的 targetPort。  默认情况下，targetPort 将被设置为与 port 字段相同的值。 可能更有趣的是，targetPort 可以是一个字符串，引用了  backend Pod 的一个端口的名称。 但是，实际指派给该端口名称的端口号，在每个 backend Pod 中可能并不相同。  对于部署和设计 Service ，这种方式会提供更大的灵活性。 例如，可以在 backend 软件下一个版本中，修改 Pod  暴露的端口，并不会中断客户端的调用。

Kubernetes Service 能够支持 TCP 和 UDP 协议，默认 TCP 协议。

### 没有 selector 的 Service

Servcie 抽象了该如何访问 Kubernetes Pod，但也能够抽象其它类型的 backend，例如：

- 希望在生产环境中使用外部的数据库集群，但测试环境使用自己的数据库。
- 希望服务指向另一个 [Namespace](http://docs.kubernetes.org.cn/242.html) 中或其它集群中的服务。
- 正在将工作负载转移到 Kubernetes 集群，和运行在 Kubernetes 集群之外的 backend。

在任何这些场景中，都能够定义没有 selector 的 Service ：

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

由于这个 Service 没有 selector，就不会创建相关的 Endpoints 对象。可以手动将 Service 映射到指定的 Endpoints：

```
kind: Endpoints
apiVersion: v1
metadata:
  name: my-service
subsets:
  - addresses:
      - ip: 1.2.3.4
    ports:
      - port: 9376
```

注意：Endpoint IP 地址不能是 loopback（127.0.0.0/8）、 link-local（169.254.0.0/16）、或者 link-local 多播（224.0.0.0/24）。

访问没有 selector 的 Service，与有 selector 的 Service 的原理相同。请求将被路由到用户定义的 Endpoint（该示例中为 1.2.3.4:9376）。

ExternalName Service 是 Service 的特例，它没有 selector，也没有定义任何的端口和 Endpoint。 相反地，对于运行在集群外部的服务，它通过返回该外部服务的别名这种方式来提供服务。

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
  namespace: prod
spec:
  type: ExternalName
  externalName: my.database.example.com
```

当查询主机 my-service.prod.svc.CLUSTER时，集群的 DNS  服务将返回一个值为 my.database.example.com 的 CNAME 记录。  访问这个服务的工作方式与其它的相同，唯一不同的是重定向发生在 DNS 层，而且不会进行代理或转发。 如果后续决定要将数据库迁移到  Kubernetes 集群中，可以启动对应的 Pod，增加合适的 Selector 或 Endpoint，修改 Service 的 type。

## VIP 和 Service 代理

在 Kubernetes 集群中，每个 Node  运行一个 kube-proxy 进程。kube-proxy 负责为 Service 实现了一种 VIP（虚拟  IP）的形式，而不是 ExternalName 的形式。 在 Kubernetes v1.0 版本，代理完全在 userspace。在  Kubernetes v1.1 版本，新增了 iptables 代理，但并不是默认的运行模式。 从 Kubernetes v1.2 起，默认就是 iptables 代理。

在 Kubernetes v1.0 版本，Service 是 “4层”（TCP/UDP over IP）概念。 在 Kubernetes v1.1 版本，新增了 Ingress API（beta 版），用来表示 “7层”（HTTP）服务。

### userspace 代理模式

这种模式，kube-proxy 会监视 Kubernetes master  对 Service 对象和 Endpoints 对象的添加和移除。 对每个 Service，它会在本地 Node 上打开一个端口（随机选择）。  任何连接到“代理端口”的请求，都会被代理到 Service 的backend Pods 中的某个上面（如 Endpoints 所报告的一样）。  使用哪个 backend Pod，是基于 Service 的 SessionAffinity 来确定的。 最后，它安装 iptables  规则，捕获到达该 Service 的 clusterIP（是虚拟 IP）和 Port 的请求，并重定向到代理端口，代理端口再代理请求到  backend Pod。

网络返回的结果是，任何到达 Service 的 IP:Port 的请求，都会被代理到一个合适的 backend，不需要客户端知道关于 Kubernetes、Service、或 Pod 的任何信息。

默认的策略是，通过 round-robin 算法来选择 backend Pod。 实现基于客户端 IP 的会话亲和性，可以通过设置 service.spec.sessionAffinity 的值为 "ClientIP" （默认值为 "None"）。

![userspace代理模式下Service概览图](https://k8smeetup.github.io/images/docs/services-userspace-overview.svg)

### iptables 代理模式

这种模式，kube-proxy 会监视 Kubernetes master  对 Service 对象和 Endpoints 对象的添加和移除。 对每个 Service，它会安装 iptables  规则，从而捕获到达该 Service 的 clusterIP（虚拟 IP）和端口的请求，进而将请求重定向到 Service 的一组  backend 中的某个上面。 对于每个 Endpoints 对象，它也会安装 iptables 规则，这个规则会选择一个  backend Pod。

默认的策略是，随机选择一个 backend。 实现基于客户端 IP 的会话亲和性，可以将 service.spec.sessionAffinity 的值设置为 "ClientIP" （默认值为 "None"）。

和 userspace 代理类似，网络返回的结果是，任何到达 Service 的 IP:Port 的请求，都会被代理到一个合适的  backend，不需要客户端知道关于 Kubernetes、Service、或 Pod 的任何信息。 这应该比 userspace  代理更快、更可靠。然而，不像 userspace 代理，如果初始选择的 Pod 没有响应，iptables  代理能够自动地重试另一个 Pod，所以它需要依赖 [readiness probes](https://k8smeetup.github.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#defining-readiness-probes)。

![iptables代理模式下Service概览图](https://k8smeetup.github.io/images/docs/services-iptables-overview.svg)

## 多端口 Service

很多 Service 需要暴露多个端口。对于这种情况，Kubernetes 支持在 Service 对象中定义多个端口。 当使用多个端口时，必须给出所有的端口的名称，这样 Endpoint 就不会产生歧义，例如：

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
    selector:
      app: MyApp
    ports:
      - name: http
        protocol: TCP
        port: 80
        targetPort: 9376
      - name: https
        protocol: TCP
        port: 443
        targetPort: 9377
```

## 选择自己的 IP 地址

在 Service 创建的请求中，可以通过设置 spec.clusterIP 字段来指定自己的集群 IP 地址。  比如，希望替换一个已经已存在的 DNS 条目，或者遗留系统已经配置了一个固定的 IP 且很难重新配置。 用户选择的 IP 地址必须合法，并且这个 IP 地址在 service-cluster-ip-range CIDR 范围内，这对 API Server 来说是通过一个标识来指定的。  如果 IP 地址不合法，API Server 会返回 HTTP 状态码 422，表示值不合法。

### 为何不使用 round-robin DNS？

一个不时出现的问题是，为什么我们都使用 VIP 的方式，而不使用标准的 round-robin DNS，有如下几个原因：

- 长久以来，DNS 库都没能认真对待 DNS TTL、缓存域名查询结果
- 很多应用只查询一次 DNS 并缓存了结果
  - 就算应用和库能够正确查询解析，每个客户端反复重解析造成的负载也是非常难以管理的

我们尽力阻止用户做那些对他们没有好处的事情，如果很多人都来问这个问题，我们可能会选择实现它。

## 服务发现

Kubernetes 支持2种基本的服务发现模式 —— 环境变量和 DNS。

### 环境变量

当 Pod 运行在 Node 上，kubelet 会为每个活跃的 Service 添加一组环境变量。 它同时支持 [Docker links兼容](https://docs.docker.com/userguide/dockerlinks/) 变量（查看 [makeLinkVariables](http://releases.k8s.io/master/pkg/kubelet/envvars/envvars.go#L49)）、简单的 {SVCNAME}_SERVICE_HOST 和 {SVCNAME}_SERVICE_PORT 变量，这里 Service 的名称需大写，横线被转换成下划线。

举个例子，一个名称为 "redis-master" 的 Service 暴露了 TCP 端口 6379，同时给它分配了 Cluster IP 地址 10.0.0.11，这个 Service 生成了如下环境变量：

```
REDIS_MASTER_SERVICE_HOST=10.0.0.11
REDIS_MASTER_SERVICE_PORT=6379
REDIS_MASTER_PORT=tcp://10.0.0.11:6379
REDIS_MASTER_PORT_6379_TCP=tcp://10.0.0.11:6379
REDIS_MASTER_PORT_6379_TCP_PROTO=tcp
REDIS_MASTER_PORT_6379_TCP_PORT=6379
REDIS_MASTER_PORT_6379_TCP_ADDR=10.0.0.11
```

这意味着需要有顺序的要求 —— Pod 想要访问的任何 Service 必须在 Pod 自己之前被创建，否则这些环境变量就不会被赋值。DNS 并没有这个限制。

### DNS

一个可选（尽管强烈推荐）[集群插件](http://releases.k8s.io/master/cluster/addons/README.md) 是 DNS 服务器。 DNS 服务器监视着创建新 Service 的 Kubernetes API，从而为每一个 Service 创建一组 DNS 记录。 如果整个集群的 DNS 一直被启用，那么所有的 Pod 应该能够自动对 Service 进行名称解析。

例如，有一个名称为 "my-service" 的 Service，它在 Kubernetes  集群中名为 "my-ns" 的 Namespace 中，为 "my-service.my-ns" 创建了一条 DNS 记录。  在名称为 "my-ns" 的 Namespace 中的 Pod 应该能够简单地通过名称查询找到 "my-service"。  在另一个 Namespace 中的 Pod 必须限定名称为 "my-service.my-ns"。 这些名称查询的结果是 Cluster IP。

Kubernetes 也支持对端口名称的 DNS SRV（Service）记录。  如果名称为 "my-service.my-ns" 的 Service 有一个名为 "http" 的 TCP 端口，可以对 "_http._tcp.my-service.my-ns" 执行 DNS SRV 查询，得到 "http" 的端口号。

Kubernetes DNS 服务器是唯一的一种能够访问 ExternalName 类型的 Service 的方式。 更多信息可以查看[DNS Pod 和 Service](https://k8smeetup.github.io/docs/concepts/services-networking/dns-pod-service/)。

## Headless Service

有时不需要或不想要负载均衡，以及单独的 Service IP。 遇到这种情况，可以通过指定 Cluster IP（spec.clusterIP）的值为 "None" 来创建 Headless Service。

这个选项允许开发人员自由寻找他们自己的方式，从而降低与 Kubernetes 系统的耦合性。 应用仍然可以使用一种自注册的模式和适配器，对其它需要发现机制的系统能够很容易地基于这个 API 来构建。

对这类 Service 并不会分配 Cluster IP，kube-proxy 不会处理它们，而且平台也不会为它们进行负载均衡和路由。 DNS 如何实现自动配置，依赖于 Service 是否定义了 selector。

### 配置 Selector

对定义了 selector 的 Headless Service，Endpoint 控制器在 API 中创建了 Endpoints 记录，并且修改 DNS 配置返回 A 记录（地址），通过这个地址直接到达 Service 的后端 Pod上。

### 不配置 Selector

对没有定义 selector 的 Headless Service，Endpoint 控制器不会创建 Endpoints 记录。 然而 DNS 系统会查找和配置，无论是：

- ExternalName 类型 Service 的 CNAME 记录
  - 记录：与 Service 共享一个名称的任何 Endpoints，以及所有其它类型

## 发布服务 —— 服务类型

对一些应用（如 Frontend）的某些部分，可能希望通过外部（Kubernetes 集群外部）IP 地址暴露 Service。

Kubernetes ServiceTypes 允许指定一个需要的类型的 Service，默认是 ClusterIP 类型。

Type 的取值以及行为如下：

- ClusterIP：通过集群的内部 IP 暴露服务，选择该值，服务只能够在集群内部可以访问，这也是默认的 ServiceType。
- NodePort：通过每个 Node 上的 IP  和静态端口（NodePort）暴露服务。NodePort 服务会路由到 ClusterIP 服务，这个 ClusterIP 服务会自动创建。通过请求 <NodeIP>:<NodePort>，可以从集群的外部访问一个 NodePort 服务。
- LoadBalancer：使用云提供商的负载局衡器，可以向外部暴露服务。外部的负载均衡器可以路由到 NodePort 服务和 ClusterIP 服务。
- ExternalName：通过返回 CNAME 和它的值，可以将服务映射到 externalName 字段的内容（例如， foo.bar.example.com）。 没有任何类型代理被创建，这只有 Kubernetes 1.7 或更高版本的 kube-dns 才支持。

### NodePort 类型

如果设置 type 的值为 "NodePort"，Kubernetes master  将从给定的配置范围内（默认：30000-32767）分配端口，每个 Node 将从该端口（每个 Node  上的同一端口）代理到 Service。该端口将通过 Service 的 spec.ports[*].nodePort 字段被指定。

如果需要指定的端口号，可以配置 nodePort 的值，系统将分配这个端口，否则调用 API 将会失败（比如，需要关心端口冲突的可能性）。

这可以让开发人员自由地安装他们自己的负载均衡器，并配置 Kubernetes 不能完全支持的环境参数，或者直接暴露一个或多个 Node 的 IP 地址。

需要注意的是，Service 将能够通过 <NodeIP>:spec.ports[*].nodePort 和 spec.clusterIp:spec.ports[*].port 而对外可见。

### LoadBalancer 类型

使用支持外部负载均衡器的云提供商的服务，设置 type 的值为 "LoadBalancer"，将为 Service 提供负载均衡器。  负载均衡器是异步创建的，关于被提供的负载均衡器的信息将会通过 Service 的 status.loadBalancer 字段被发布出去。

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
      nodePort: 30061
  clusterIP: 10.0.171.239
  loadBalancerIP: 78.11.24.19
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
      - ip: 146.148.47.155
```

来自外部负载均衡器的流量将直接打到 backend Pod 上，不过实际它们是如何工作的，这要依赖于云提供商。  在这些情况下，将根据用户设置的 loadBalancerIP 来创建负载均衡器。  某些云提供商允许设置 loadBalancerIP。如果没有设置 loadBalancerIP，将会给负载均衡器指派一个临时 IP。  如果设置了 loadBalancerIP，但云提供商并不支持这种特性，那么设置的 loadBalancerIP 值将会被忽略掉。

### AWS 内部负载均衡器

在混合云环境中，有时从虚拟私有云（VPC）环境中的服务路由流量是非常有必要的。 可以通过在 Service 中增加 annotation 来实现，如下所示：

```
[...]
metadata: 
    name: my-service
    annotations: 
        service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0
[...]
```

在水平分割的 DNS 环境中，需要两个 Service 来将外部和内部的流量路由到 Endpoint 上。

### AWS SSL 支持

对运行在 AWS 上部分支持 SSL 的集群，从 1.3 版本开始，可以为 LoadBalancer 类型的 Service 增加两个 annotation：

```
    metadata:
      name: my-service
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012
```

第一个 annotation 指定了使用的证书。它可以是第三方发行商发行的证书，这个证书或者被上传到 IAM，或者由 AWS 的证书管理器创建。

```
    metadata:
      name: my-service
      annotations:
         service.beta.kubernetes.io/aws-load-balancer-backend-protocol: (https|http|ssl|tcp)
```

第二个 annotation 指定了 Pod 使用的协议。 对于 HTTPS 和 SSL，ELB 将期望该 Pod 基于加密的连接来认证自身。

HTTP 和 HTTPS 将选择7层代理：ELB 将中断与用户的连接，当转发请求时，会解析 Header 信息并添加上用户的 IP 地址（Pod 将只能在连接的另一端看到该 IP 地址）。

TCP 和 SSL 将选择4层代理：ELB 将转发流量，并不修改 Header 信息。

### 外部 IP

如果外部的 IP 路由到集群中一个或多个 Node 上，Kubernetes Service 会被暴露给这些 externalIPs。  通过外部 IP（作为目的 IP 地址）进入到集群，打到 Service 的端口上的流量，将会被路由到 Service 的 Endpoint  上。 externalIPs 不会被 Kubernetes 管理，它属于集群管理员的职责范畴。

根据 Service 的规定，externalIPs 可以同任意的 ServiceType 来一起指定。 在上面的例子中，my-service 可以在 80.11.12.10:80（外部 IP:端口）上被客户端访问。

```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
  externalIPs: 
    - 80.11.12.10
```

## 不足之处

为 VIP 使用 userspace 代理，将只适合小型到中型规模的集群，不能够扩展到上千 Service 的大型集群。 查看 [最初设计方案](http://issue.k8s.io/1107) 获取更多细节。

使用 userspace 代理，隐藏了访问 Service 的数据包的源 IP 地址。 这使得一些类型的防火墙无法起作用。  iptables 代理不会隐藏 Kubernetes 集群内部的 IP 地址，但却要求客户端请求必须通过一个负载均衡器或 Node 端口。

Type 字段支持嵌套功能 —— 每一层需要添加到上一层里面。 不会严格要求所有云提供商（例如，GCE 就没必要为了使一个 LoadBalancer 能工作而分配一个 NodePort，但是 AWS 需要 ），但当前 API 是强制要求的。

## 未来工作

未来我们能预见到，代理策略可能会变得比简单的 round-robin 均衡策略有更多细微的差别，比如 master 选举或分片。 我们也能想到，某些 Service 将具有 “真正” 的负载均衡器，这种情况下 VIP 将简化数据包的传输。

我们打算为 L7（HTTP）Service 改进我们对它的支持。

我们打算为 Service 实现更加灵活的请求进入模式，这些 Service 包含当前 ClusterIP、NodePort 和 LoadBalancer 模式，或者更多。

## VIP 的那些骇人听闻的细节

对很多想使用 Service 的人来说，前面的信息应该足够了。 然而，有很多内部原理性的内容，还是值去理解的。

### 避免冲突

Kubernetes 最主要的哲学之一，是用户不应该暴露那些能够导致他们操作失败、但又不是他们的过错的场景。  这种场景下，让我们来看一下网络端口 —— 用户不应该必须选择一个端口号，而且该端口还有可能与其他用户的冲突。  这就是说，在彼此隔离状态下仍然会出现失败。

为了使用户能够为他们的 Service 选择一个端口号，我们必须确保不能有2个 Service 发生冲突。 我们可以通过为每个 Service 分配它们自己的 IP 地址来实现。

为了保证每个 Service 被分配到一个唯一的 IP，需要一个内部的分配器能够原子地更新 etcd  中的一个全局分配映射表，这个更新操作要先于创建每一个 Service。 为了使 Service能够获取到  IP，这个映射表对象必须在注册中心存在，否则创建 Service 将会失败，指示一个 IP 不能被分配。 一个后台 Controller  的职责是创建映射表（从 Kubernetes 的旧版本迁移过来，旧版本中是通过在内存中加锁的方式实现），并检查由于管理员干预和清除任意 IP  造成的不合理分配，这些 IP 被分配了但当前没有 Service 使用它们。

### IP 和 VIP

不像 Pod 的 IP 地址，它实际路由到一个固定的目的地，Service 的 IP 实际上不能通过单个主机来进行应答。  相反，我们使用 iptables（Linux 中的数据包处理逻辑）来定义一个虚拟IP地址（VIP），它可以根据需要透明地进行重定向。  当客户端连接到 VIP 时，它们的流量会自动地传输到一个合适的 Endpoint。 环境变量和 DNS，实际上会根据 Service 的 VIP 和端口来进行填充。

#### Userspace

作为一个例子，考虑前面提到的图片处理应用程序。 当创建 backend Service 时，Kubernetes master  会给它指派一个虚拟 IP 地址，比如 10.0.0.1。 假设 Service 的端口是  1234，该 Service 会被集群中所有的 kube-proxy 实例观察到。 当代理看到一个新的 Service，  它会打开一个新的端口，建立一个从该 VIP 重定向到新端口的 iptables，并开始接收请求连接。

当一个客户端连接到一个 VIP，iptables 规则开始起作用，它会重定向该数据包到 Service代理 的端口。 Service代理 选择一个 backend，并将客户端的流量代理到 backend 上。

这意味着 Service 的所有者能够选择任何他们想使用的端口，而不存在冲突的风险。 客户端可以简单地连接到一个 IP 和端口，而不需要知道实际访问了哪些 Pod。

#### Iptables

再次考虑前面提到的图片处理应用程序。 当创建 backend Service 时，Kubernetes master 会给它指派一个虚拟  IP 地址，比如 10.0.0.1。 假设 Service 的端口是  1234，该 Service会被集群中所有的 kube-proxy 实例观察到。 当代理看到一个新的 Service， 它会安装一系列的  iptables 规则，从 VIP 重定向到 per-Service 规则。 该 per-Service 规则连接到  per-Endpoint 规则，该 per-Endpoint 规则会重定向（目标 NAT）到 backend。

当一个客户端连接到一个 VIP，iptables 规则开始起作用。一个 backend  会被选择（或者根据会话亲和性，或者随机），数据包被重定向到这个 backend。 不像 userspace  代理，数据包从来不拷贝到用户空间，kube-proxy 不是必须为该 VIP 工作而运行，并且客户端 IP 是不可更改的。 当流量打到 Node 的端口上，或通过负载均衡器，会执行相同的基本流程，但是在那些案例中客户端 IP 是可以更改的。

## API 对象

在 Kubernetes REST API 中，Service 是 top-level 资源。关于 API 对象的更多细节可以查看：[Service API 对象](https://k8smeetup.github.io/docs/api-reference/v1.7/#service-v1-core)。

## 更多信息

阅读 [使用 Service 连接 Frontend 到 Backend](https://k8smeetup.github.io/docs/tutorials/connecting-apps/connecting-frontend-backend/)。

原文：https://k8smeetup.github.io/docs/concepts/services-networking/service/

# Kubernetes 调试 Service

- [1 约定](http://docs.kubernetes.org.cn/819.html#i)
- [2 在 pod 中运行命令](http://docs.kubernetes.org.cn/819.html#_pod)
- [3 安装](http://docs.kubernetes.org.cn/819.html#i-2)
- [4 Service 存在吗？](http://docs.kubernetes.org.cn/819.html#Service)
- 5 Service 是否通过 DNS 工作？
  - [5.1 DNS 中是否存在服务？](http://docs.kubernetes.org.cn/819.html#DNS)
- [6 Service 是通过 IP 工作的吗？](http://docs.kubernetes.org.cn/819.html#Service_IP)
- [7 Service 是对的吗？](http://docs.kubernetes.org.cn/819.html#Service-2)
- [8 Service 有 Endpoints 吗？](http://docs.kubernetes.org.cn/819.html#Service_Endpoints)
- [9 Pod 工作正常吗？](http://docs.kubernetes.org.cn/819.html#Pod)
- 10 kube-proxy 工作正常吗？
  - [10.1 kube-proxy 是在运行中吗？](http://docs.kubernetes.org.cn/819.html#kube-proxy-2)
  - 10.2 kube-proxy 是否在写 iptables 规则？
    - [10.2.1 Userspace](http://docs.kubernetes.org.cn/819.html#Userspace)
    - [10.2.2 Iptables](http://docs.kubernetes.org.cn/819.html#Iptables)
  - [10.3 kube-proxy 正在代理中吗？](http://docs.kubernetes.org.cn/819.html#kube-proxy-3)
  - [10.4 Pod 无法通过 Service IP 到达自己](http://docs.kubernetes.org.cn/819.html#Pod_Service_IP)
- [11 求助](http://docs.kubernetes.org.cn/819.html#i-3)

对于新安装的 Kubernetes，经常出现的一个问题是 Service 没有正常工作。如果您已经运行了 [Deployment](http://docs.kubernetes.org.cn/317.html) 并创建了一个 Service，但是当您尝试访问它时没有得到响应，希望这份文档能帮助您找出问题所在。

## 约定

在整个文档中，您将看到可以运行的各种命令。有些命令需要在 Pod 中运行，有些命令需要在 Kubernetes Node 上运行，还有一些命令可以在您拥有 kubectl 和集群凭证的任何地方运行。为了明确命令期望运行的位置，本文档将使用以下约定。

如果命令 “COMMAND” 期望在 [Pod](http://docs.kubernetes.org.cn/312.html) 中运行，并且产生 “OUTPUT”：

```
u@pod$ COMMAND
OUTPUT
```

如果命令 “COMMAND” 期望在 Node 上运行，并且产生 “OUTPUT”：

```
u@node$ COMMAND
OUTPUT
```

如果命令是 “kubectl ARGS”：

```
$ kubectl ARGS
OUTPUT
```

## 在 pod 中运行命令

对于这里的许多步骤，您可能希望知道运行在集群中的 Pod 看起来是什么样的。最简单的方法是运行一个交互式的 busybox Pod：

```
$ kubectl run -it --rm --restart=Never busybox --image=busybox sh
If you don't see a command prompt, try pressing enter.
/ #
```

如果您已经有了您喜欢使用的正在运行的 Pod，则可以使用：

```
$ kubectl exec <POD-NAME> -c <CONTAINER-NAME> -- <COMMAND>
```

## 安装

为了完成本次分析故障的目的，我们先运行几个 Pod。因为可能正在调试您自己的 Service，所以，您可以使用自己的详细信息进行替换，或者，您也可以跟随并开始下面的步骤。

```
$ kubectl run hostnames --image=k8s.gcr.io/serve_hostname \
                        --labels=app=hostnames \
                        --port=9376 \
                        --replicas=3
deployment "hostnames" created
```

kubectl 命令将打印创建或变更的资源的类型和名称，它们可以在后续命令中使用。请注意，这与您使用以下 YAML 启动 Deployment 相同：

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hostnames
spec:
  selector:
    app: hostnames
  replicas: 3
  template:
    metadata:
      labels:
        app: hostnames
    spec:
      containers:
      - name: hostnames
        image: k8s.gcr.io/serve_hostname
        ports:
        - containerPort: 9376
          protocol: TCP
```

确认您的 Pod 是 running 状态：

```
$ kubectl get pods -l app=hostnames
NAME                        READY     STATUS    RESTARTS   AGE
hostnames-632524106-bbpiw   1/1       Running   0          2m
hostnames-632524106-ly40y   1/1       Running   0          2m
hostnames-632524106-tlaok   1/1       Running   0          2m
```

## Service 存在吗？

细心的读者会注意到我们还没有真正创建一个 [Service](http://docs.kubernetes.org.cn/703.html) - 其实这是我们有意的。这是一个有时会被遗忘的步骤，也是第一件要检查的事情。

那么，如果我试图访问一个不存在的 Service，会发生什么呢？假设您有另一个 Pod，想通过名称使用这个 Service，您将得到如下内容：

```
u@pod$ wget -qO- hostnames
wget: bad address 'hostname'
```

因此，首先要检查的是 Service 是否确实存在：

```
$ kubectl get svc hostnames
Error from server (NotFound): services "hostnames" not found
```

我们已经有一个罪魁祸首了，让我们来创建 Service。就像前面一样，这里的内容仅仅是为了步骤的执行 - 在这里您可以使用自己的 Service 细节。

```
$ kubectl expose deployment hostnames --port=80 --target-port=9376
service "hostnames" exposed
```

再查询一遍，确定一下：

```
$ kubectl get svc hostnames
NAME        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
hostnames   10.0.1.175   <none>        80/TCP    5s
```

与前面相同，这与您使用 YAML 启动的 Service 一样：

```
apiVersion: v1
kind: Service
metadata:
  name: hostnames
spec:
  selector:
    app: hostnames
  ports:
  - name: default
    protocol: TCP
    port: 80
    targetPort: 9376
```

现在您可以确认 Service 存在。

## Service 是否通过 DNS 工作？

从相同 Namespace 下的 Pod 中运行：

```
u@pod$ nslookup hostnames
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      hostnames
Address 1: 10.0.1.175 hostnames.default.svc.cluster.local
```

如果失败，那么您的 Pod 和 Service 可能位于不同的 Namespaces 中，请尝试使用限定命名空间的名称：

```
u@pod$ nslookup hostnames.default
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      hostnames.default
Address 1: 10.0.1.175 hostnames.default.svc.cluster.local
```

如果成功，那么需要调整您的应用，使用跨命名空间（cross-namespace）的名称去访问服务，或者，在相同的 Namespace 中运行应用和 Service。如果仍然失败，请尝试一个完全限定的名称：

```
u@pod$ nslookup hostnames.default.svc.cluster.local
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      hostnames.default.svc.cluster.local
Address 1: 10.0.1.175 hostnames.default.svc.cluster.local
```

注意这里的后缀：“default.svc.cluster.local”。“default” 是我们正在操作的 Namespace。“svc” 表示这是一个 Service。“cluster.local” 是您的集群域，在您自己的集群中可能会有所不同。

您也可以在集群中的 Node 上尝试此操作（注意：10.0.0.10 是我的 DNS Service，您的可能不同）：

```
u@node$ nslookup hostnames.default.svc.cluster.local 10.0.0.10
Server:         10.0.0.10
Address:        10.0.0.10#53

Name:   hostnames.default.svc.cluster.local
Address: 10.0.1.175
```

如果您能够使用完全限定的名称查找，但不能使用相对名称，则需要检查 /etc/resolv.conf 文件是否正确。

```
u@pod$ cat /etc/resolv.conf
nameserver 10.0.0.10
search default.svc.cluster.local svc.cluster.local cluster.local example.com
options ndots:5
```

nameserver 行必须指示群集的 DNS Service，它通过 --cluster-dns 传递到 kubelet。

search 行必须包含一个适当的后缀，以便查找 Service 名称。在本例中，它在本地 Namespace（default.svc.cluster.local）、所有 Namespaces 中的 Service（svc.cluster.local）以及集群（cluster.local）中查找服务。根据您自己的安装情况，可能会有额外的记录（最多 6 条）。集群后缀通过 --cluster-domain 标志传递给 kubelet。本文档中，我们假定它是  “cluster.local”，但是您的可能不同，这种情况下，您应该在上面的所有命令中更改它。

options 行必须设置足够高的 ndots，以便 DNS 客户端库考虑搜索路径。在默认情况下，Kubernetes 将这个值设置为 5，这个值足够高，足以覆盖它生成的所有 DNS 名称。

### DNS 中是否存在服务？

如果上面仍然失败 - DNS 查找不到您需要的 Service - 我们可以后退一步，看看还有什么不起作用。Kubernetes 主 Service 应该一直是正常的：

```
u@pod$ nslookup kubernetes.default
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes.default
Address 1: 10.0.0.1 kubernetes.default.svc.cluster.local
```

如果失败，您可能需要转到这个文档的 kube-proxy 部分，或者甚至回到文档的顶部重新开始，但，不是调试您自己的 Service，而是调试 DNS。

## Service 是通过 IP 工作的吗？

假设我们可以确认 DNS 工作正常，那么接下来要测试的是您的 Service 是否工作正常。从集群中的一个节点，访问 Service 的 IP（从上面的 kubectl get 命令获取）。

```
u@node$ curl 10.0.1.175:80
hostnames-0uton

u@node$ curl 10.0.1.175:80
hostnames-yp2kp

u@node$ curl 10.0.1.175:80
hostnames-bvc05
```

如果 Service 是正常的，您应该得到正确的响应。如果没有，有很多可能出错的地方，请继续。

## Service 是对的吗？

这听起来可能很傻，但您应该加倍甚至三倍检查您的 Service 是否正确，并且与您的 Pod 匹配。查看您的 Service 并验证它：

```
$ kubectl get service hostnames -o json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "hostnames",
        "namespace": "default",
        "selfLink": "/api/v1/namespaces/default/services/hostnames",
        "uid": "428c8b6c-24bc-11e5-936d-42010af0a9bc",
        "resourceVersion": "347189",
        "creationTimestamp": "2015-07-07T15:24:29Z",
        "labels": {
            "app": "hostnames"
        }
    },
    "spec": {
        "ports": [
            {
                "name": "default",
                "protocol": "TCP",
                "port": 80,
                "targetPort": 9376,
                "nodePort": 0
            }
        ],
        "selector": {
            "app": "hostnames"
        },
        "clusterIP": "10.0.1.175",
        "type": "ClusterIP",
        "sessionAffinity": "None"
    },
    "status": {
        "loadBalancer": {}
    }
}
```

spec.ports[] 中描述的是您想要尝试访问的端口吗？targetPort 对您的 Pod 来说正确吗（许多 Pod 选择使用与 Service 不同的端口）？如果您想把它变成一个数字端口，那么它是一个数字（9376）还是字符串 “9376”？如果您想把它当作一个指定的端口，那么您的 Pod 是否公开了一个同名端口？端口的 protocol 和 Pod 的一样吗？

## Service 有 Endpoints 吗？

如果您已经走到了这一步，我们假设您已经确认您的 Service 存在，并能通过 DNS 解析。现在，让我们检查一下，您运行的 Pod 确实是由 Service 选择的。

早些时候，我们已经看到 Pod 是 running 状态。我们可以再检查一下：

```
$ kubectl get pods -l app=hostnames
NAME              READY     STATUS    RESTARTS   AGE
hostnames-0uton   1/1       Running   0          1h
hostnames-bvc05   1/1       Running   0          1h
hostnames-yp2kp   1/1       Running   0          1h
```

“AGE” 列表明这些 Pod 已经启动一个小时了，这意味着它们运行良好，而不是崩溃。

-l app=hostnames 参数是一个标签选择器 - 就像我们的 Service 一样。在 Kubernetes 系统中有一个控制循环，它评估每个 Service 的选择器，并将结果保存到 Endpoints 对象中。

```
$ kubectl get endpoints hostnames
NAME        ENDPOINTS
hostnames   10.244.0.5:9376,10.244.0.6:9376,10.244.0.7:9376
```

这证实 endpoints  控制器已经为您的 Service 找到了正确的 Pods。如果 hostnames 行为空，则应检查 Service 的 spec.selector 字段，以及您实际想选择的 Pods 的 metadata.labels 的值。常见的错误是设置出现了问题，例如 Service 想选择 run=hostnames，但是 Deployment 指定的是 app=hostnames。

## Pod 工作正常吗？

到了这步，我们知道您的 Service 存在并选择了您的 Pods。让我们检查一下 Pod 是否真的在工作 - 我们可以绕过 Service 机制，直接进入 Pod。注意，这些命令使用的是 Pod 端口（9376），而不是 Service 端口（80）。

```
u@pod$ wget -qO- 10.244.0.5:9376
hostnames-0uton

pod $ wget -qO- 10.244.0.6:9376
hostnames-bvc05

u@pod$ wget -qO- 10.244.0.7:9376
hostnames-yp2kp
```

我们期望的是 Endpoints 列表中的每个 Pod 返回自己的主机名。如果这没有发生（或者您自己的 Pod 的正确行为没有发生），您应该调查发生了什么。您会发现 kubectl logs 这个时候非常有用，或者使用 kubectl exec 直接进入到您的 Pod，并从那里检查服务。

另一件要检查的事情是，您的 Pod 没有崩溃或正在重新启动。频繁的重新启动可能会导致断断续续的连接问题。

```
$ kubectl get pods -l app=hostnames
NAME                        READY     STATUS    RESTARTS   AGE
hostnames-632524106-bbpiw   1/1       Running   0          2m
hostnames-632524106-ly40y   1/1       Running   0          2m
hostnames-632524106-tlaok   1/1       Running   0          2m
```

如果重新启动计数很高，请查阅有关如何 [调试 pod](https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/#debugging-pods) 获取更多信息。

## kube-proxy 工作正常吗？

如果您到了这里，那么您的 Service 正在运行，也有 Endpoints，而您的 Pod 实际上也正在服务。在这一点上，整个 Service 代理机制是否正常就是可疑的了。我们来确认一下，一部分一部分来。

### kube-proxy 是在运行中吗？

确认 kube-proxy 正在您的节点上运行。您应该得到如下内容：

```
u@node$ ps auxw | grep kube-proxy
root  4194  0.4  0.1 101864 17696 ?    Sl Jul04  25:43 /usr/local/bin/kube-proxy --master=https://kubernetes-master --kubeconfig=/var/lib/kube-proxy/kubeconfig --v=2
```

下一步，确认它并没有出现明显的失败，比如连接 master  失败。要做到这一点，您必须查看日志。访问日志取决于您的 Node 操作系统。在某些操作系统是一个文件，如 /var/log/messages  kube-proxy.log，而其他操作系统使用 journalctl 访问日志。您应该看到类似的东西：

```
I1027 22:14:53.995134    5063 server.go:200] Running in resource-only container "/kube-proxy"
I1027 22:14:53.998163    5063 server.go:247] Using iptables Proxier.
I1027 22:14:53.999055    5063 server.go:255] Tearing down userspace rules. Errors here are acceptable.
I1027 22:14:54.038140    5063 proxier.go:352] Setting endpoints for "kube-system/kube-dns:dns-tcp" to [10.244.1.3:53]
I1027 22:14:54.038164    5063 proxier.go:352] Setting endpoints for "kube-system/kube-dns:dns" to [10.244.1.3:53]
I1027 22:14:54.038209    5063 proxier.go:352] Setting endpoints for "default/kubernetes:https" to [10.240.0.2:443]
I1027 22:14:54.038238    5063 proxier.go:429] Not syncing iptables until Services and Endpoints have been received from master
I1027 22:14:54.040048    5063 proxier.go:294] Adding new service "default/kubernetes:https" at 10.0.0.1:443/TCP
I1027 22:14:54.040154    5063 proxier.go:294] Adding new service "kube-system/kube-dns:dns" at 10.0.0.10:53/UDP
I1027 22:14:54.040223    5063 proxier.go:294] Adding new service "kube-system/kube-dns:dns-tcp" at 10.0.0.10:53/TCP
```

如果您看到有关无法连接 master 的错误消息，则应再次检查 Node 配置和安装步骤。

kube-proxy 无法正确运行的可能原因之一是找不到所需的 conntrack 二进制文件。在一些 Linux  系统上，这也是可能发生的，这取决于您如何安装集群，例如，您正在从头开始安装  Kubernetes。如果是这样的话，您需要手动安装 conntrack 包（例如，在 Ubuntu 上使用 sudo apt install  conntrack），然后重试。

### kube-proxy 是否在写 iptables 规则？

kube-proxy 的主要职责之一是写实现 Services 的 iptables 规则。让我们检查一下这些规则是否已经被写好了。

kube-proxy 可以在 “userspace” 模式或 “iptables” 模式下运行。希望您正在使用更新、更快、更稳定的 “iptables” 模式。您应该看到以下情况之一。

#### Userspace

```
u@node$ iptables-save | grep hostnames
-A KUBE-PORTALS-CONTAINER -d 10.0.1.175/32 -p tcp -m comment --comment "default/hostnames:default" -m tcp --dport 80 -j REDIRECT --to-ports 48577
-A KUBE-PORTALS-HOST -d 10.0.1.175/32 -p tcp -m comment --comment "default/hostnames:default" -m tcp --dport 80 -j DNAT --to-destination 10.240.115.247:48577
```

您的 Service 上的每个端口应该有两个规则（本例中只有一个）- “KUBE-PORTALS-CONTAINER” 和  “KUBE-PORTALS-HOST”。如果您没有看到这些，请尝试将 -V 标志设置为 4  之后重新启动 kube-proxy，然后再次查看日志。

几乎没有人应该再使用 “userspace” 模式了，所以我们不会在这里花费更多的时间。

#### Iptables

```
u@node$ iptables-save | grep hostnames
-A KUBE-SEP-57KPRZ3JQVENLNBR -s 10.244.3.6/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-57KPRZ3JQVENLNBR -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.3.6:9376
-A KUBE-SEP-WNBA2IHDGP2BOBGZ -s 10.244.1.7/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-WNBA2IHDGP2BOBGZ -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.1.7:9376
-A KUBE-SEP-X3P2623AGDH6CDF3 -s 10.244.2.3/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-X3P2623AGDH6CDF3 -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.2.3:9376
-A KUBE-SERVICES -d 10.0.1.175/32 -p tcp -m comment --comment "default/hostnames: cluster IP" -m tcp --dport 80 -j KUBE-SVC-NWV5X2332I4OT4T3
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -m statistic --mode random --probability 0.33332999982 -j KUBE-SEP-WNBA2IHDGP2BOBGZ
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-X3P2623AGDH6CDF3
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -j KUBE-SEP-57KPRZ3JQVENLNBR
```

KUBE-SERVICES 中应该有 1 条规则，KUBE-SVC-(hash) 中每个 endpoint 有 1 或 2  条规则（取决于 SessionAffinity），每个 endpoint 中应有 1  条 KUBE-SEP-(hash) 链。准确的规则将根据您的确切配置（包括 节点-端口 以及 负载均衡）而有所不同。

### kube-proxy 正在代理中吗？

假设您确实看到了上述规则，请再次尝试通过 IP 访问您的 Service：

```
u@node$ curl 10.0.1.175:80
hostnames-0uton
```

如果失败了，并且您正在使用 userspace 代理，您可以尝试直接访问代理。如果您使用的是 iptables 代理，请跳过本节。

回顾上面的 iptables-save 输出，并提取 kube-proxy 用于您的 Service 的端口号。在上面的例子中，它是 “48577”。现在连接到它：

```
u@node$ curl localhost:48577
hostnames-yp2kp
```

如果仍然失败，请查看 kube-proxy 日志中的特定行，如：

```
Setting endpoints for default/hostnames:default to [10.244.0.5:9376 10.244.0.6:9376 10.244.0.7:9376]
```

如果您没有看到这些，请尝试将 -V 标志设置为 4 并重新启动 kube-proxy，然后再查看日志。

### Pod 无法通过 Service IP 到达自己

如果网络没有正确配置为 “hairpin” 流量，通常当 kube-proxy 以 iptables 模式运行，并且 Pod  与桥接网络连接时，就会发生这种情况。Kubelet 公开了一个 hairpin-mode 标志，如果 pod 试图访问它们自己的 Service VIP，就可以让 Service 的 endpoints  重新负载到他们自己身上。hairpin-mode 标志必须设置为 hairpin-veth 或者 promiscuous-bridge。

解决这一问题的常见步骤如下：

- 确认 hairpin-mode 被设置为 hairpin-veth 或者 promiscuous-bridge。您应该看到下面这样的内容。在下面的示例中，hairpin-mode 被设置为 promiscuous-bridge。

```
u@node$ ps auxw|grep kubelet
root      3392  1.1  0.8 186804 65208 ?        Sl   00:51  11:11 /usr/local/bin/kubelet --enable-debugging-handlers=true --config=/etc/kubernetes/manifests --allow-privileged=True --v=4 --cluster-dns=10.0.0.10 --cluster-domain=cluster.local --configure-cbr0=true --cgroup-root=/ --system-cgroups=/system --hairpin-mode=promiscuous-bridge --runtime-cgroups=/docker-daemon --kubelet-cgroups=/kubelet --babysit-daemons=true --max-pods=110 --serialize-image-pulls=false --outofdisk-transition-frequency=0
```

- 确认有效的 hairpin-mode。要做到这一点，您必须查看 kubelet 日志。访问日志取决于 Node  OS。在一些操作系统上，它是一个文件，如  /var/log/kubelet.log，而其他操作系统则使用 journalctl 访问日志。请注意，由于兼容性，有效的 hairpin-mode 可能不匹配 --hairpin-mode 标志。在 kubelet.log 中检查是否有带有关键字 hairpin 的日志行。应该有日志行指示有效的 hairpin-mode，比如下面的内容。

```
I0629 00:51:43.648698    3252 kubelet.go:380] Hairpin mode set to "promiscuous-bridge"
```

- 如果有效的 hairpin-mode 是 hairpin-veth，请确保 Kubelet 具有在节点上的 /sys 中操作的权限。如果一切正常工作，您应该看到如下内容：

```
u@node$ for intf in /sys/devices/virtual/net/cbr0/brif/*; do cat $intf/hairpin_mode; done
1
1
1
1
```

- 如果有效的 hairpin-mode 是 promiscuous-bridge，则请确保 Kubelet 拥有在节点上操纵 Linux 网桥的权限。如果正确使用和配置了 cbr0 网桥，您应该看到：

```
u@node$ ifconfig cbr0 |grep PROMISC
UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1460  Metric:1
```

- 如果上述任何一项都没有效果，请寻求帮助。

## 求助

如果您走到这一步，那么就真的是奇怪的事情发生了。您的 Service 正在运行，有 Endpoints，您的 Pods 也确实在服务中。您的 DNS 正常，iptables  规则已经安装，kube-proxy看起来也正常。然而 Service 不起作用。这种情况下，您应该让我们知道，这样我们可以帮助调查！

使用 [Slack](https://k8smeetup.github.io/docs/troubleshooting/#slack) 或者 [email](https://groups.google.com/forum/#!forum/kubernetes-users) 或者 [GitHub](https://github.com/kubernetes/kubernetes) 联系我们。

译者：[chentao1596](https://github.com/chentao1596) / [原文链接](https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-service/)

# Kubernetes 应用连接到 Service

- [1 Kubernetes 连接容器模型](http://docs.kubernetes.org.cn/702.html#Kubernetes)
- [2 在集群中暴露 Pod](http://docs.kubernetes.org.cn/702.html#_Pod)
- [3 创建 Service](http://docs.kubernetes.org.cn/702.html#_Service)
- 4 访问 Service
  - [4.1 环境变量](http://docs.kubernetes.org.cn/702.html#i)
  - [4.2 DNS](http://docs.kubernetes.org.cn/702.html#DNS)
- [5 Service 安全](http://docs.kubernetes.org.cn/702.html#Service)
- [6 暴露 Service](http://docs.kubernetes.org.cn/702.html#_Service-3)
- [7 进一步阅读](http://docs.kubernetes.org.cn/702.html#i-2)
- [8 下一步](http://docs.kubernetes.org.cn/702.html#i-3)

## Kubernetes 连接容器模型

既然有了一个持续运行、可复制的应用，我们就能够将它暴露到网络上。在讨论 Kubernetes 网络连接的方式之前，非常值得我们同 Docker中 “正常” 方式的网络进行一番对比。

默认情况下，Docker 使用私有主机网络，仅能与同在一台机器上的容器间通信。为了实现容器的跨节点通信，必须在机器自己的 IP 上为这些容器分配端口，为容器进行端口转发或者代理。

多个开发人员之间协调端口的使用很难做到规模化，那些难以控制的集群级别的问题，都会交由用户自己去处理。 Kubernetes 假设 Pod  可与其它 Pod 通信，不管它们在哪个主机上。 我们给 Pod 分配属于自己的集群私有 IP 地址，所以没必要在 Pod  或映射到的容器的端口和主机端口之间显式地创建连接。 这表明了在 Pod 内的容器都能够连接到本地的每个端口，集群中的所有 Pod 不需要通过  NAT 转换就能够互相看到。 文档的剩余部分将详述，如何在一个网络模型之上运行可靠的服务。

该指南使用一个简单的 Nginx server 来演示证明谈及的概念。同样的原则也体现在一个更加完整的 [Jenkins CI 应用](http://blog.kubernetes.io/2015/07/strong-simple-ssl-for-kubernetes.html) 中。

## 在集群中暴露 Pod

我们在之前的示例中已经做过，然而再让我重试一次，这次聚焦在网络连接的视角。 创建一个 Nginx Pod，指示它具有一个容器端口的说明：

| [run-my-nginx.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/services-networking/run-my-nginx.yaml)![Copy run-my-nginx.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: apps/v1beta1 kind: Deployment metadata:  name: my-nginx spec:  replicas: 2  template:    metadata:      labels:        run: my-nginx    spec:      containers:      - name: my-nginx        image: nginx        ports:        - containerPort: 80 ` |

这使得可以从集群中任何一个节点来访问它。检查节点，该 Pod 正在运行：

```
$ kubectl create -f ./run-my-nginx.yaml
$ kubectl get pods -l run=my-nginx -o wide
NAME                        READY     STATUS    RESTARTS   AGE       IP            NODE
my-nginx-3800858182-jr4a2   1/1       Running   0          13s       10.244.3.4    kubernetes-minion-905m
my-nginx-3800858182-kna2y   1/1       Running   0          13s       10.244.2.5    kubernetes-minion-ljyd
```

检查 Pod 的 IP 地址：

```
$ kubectl get pods -l run=my-nginx -o yaml | grep podIP
    podIP: 10.244.3.4
    podIP: 10.244.2.5
```

应该能够通过 ssh 登录到集群中的任何一个节点，使用 curl 也能调通所有 IP 地址。 需要注意的是，容器不会使用该节点上的 80  端口，也不会使用任何特定的 NAT 规则去路由流量到 Pod 上。 这意味着可以在同一个节点上运行多个  Pod，使用相同的容器端口，并且可以从集群中任何其他的 Pod 或节点上使用 IP 的方式访问到它们。 像 Docker  一样，端口能够被发布到主机节点的接口上，但是出于网络模型的原因应该从根本上减少这种用法。

如果对此好奇，可以获取更多关于 [如何实现网络模型](https://k8smeetup.github.io/docs/concepts/cluster-administration/networking/#how-to-achieve-this) 的内容。

## 创建 Service

我们有 Pod 在一个扁平的、集群范围的地址空间中运行 Nginx 服务，可以直接连接到这些 Pod，但如果某个节点死掉了会发生什么呢？ Pod 会终止，Deployment 将创建新的 Pod，使用不同的 IP。这正是 Service 要解决的问题。

Kubernetes Service 从逻辑上定义了运行在集群中的一组 Pod，这些 Pod 提供了相同的功能。 当创建时，每个  Service 被分配一个唯一的 IP 地址（也称为 clusterIP）。 这个 IP 地址与一个 Service 的生命周期绑定在一起，当  Service 存在的时候它也不会改变。 可以配置 Pod 使它与 Service 进行通信，Pod 知道，与 Service  通信将被自动地负载均衡到该 Service 中的某些 Pod 上。

可以使用 kubectl expose 为 2个 Nginx 副本创建一个 Service：

```
$ kubectl expose deployment/my-nginx
service "my-nginx" exposed
```

这等价于使用 kubectl create -f 命令创建，对应如下的 yaml 文件：

| [nginx-svc.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/services-networking/nginx-svc.yaml)![Copy nginx-svc.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Service metadata:  name: my-nginx  labels:    run: my-nginx spec:  ports:  - port: 80    protocol: TCP  selector:    run: my-nginx ` |

上述规格将创建一个 Service，对应具有标签 run: my-nginx 的 Pod，目标 TCP 端口 80，并且在一个抽象的  Service 端口（targetPort：容器接收流量的端口；port：抽象的 Service 端口，可以使任何其它 Pod 访问该  Service 的端口）上暴露。 查看 [Service API 对象](https://k8smeetup.github.io/docs/api-reference/v1.7/#service-v1-core) 了解 Service 定义支持的字段列表。

```
$ kubectl get svc my-nginx
NAME       CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
my-nginx   10.0.162.149   <none>        80/TCP    21s
```

正如前面所提到的，一个 Service 由一组 backend Pod 组成。这些 Pod 通过 endpoints 暴露出来。  Service Selector 将持续评估，结果被 POST 到一个名称为 my-nginx 的 Endpoint 对象。 当 Pod  终止后，它会自动从 Endpoint 中移除，新的能够匹配上 Service Selector 的 Pod 将自动地被添加到 Endpoint  中。 检查该 Endpoint，注意到 IP 地址与在第一步创建的 Pod 是相同的。

```
$ kubectl describe svc my-nginx
Name:                my-nginx
Namespace:           default
Labels:              run=my-nginx
Selector:            run=my-nginx
Type:                ClusterIP
IP:                  10.0.162.149
Port:                <unset> 80/TCP
Endpoints:           10.244.2.5:80,10.244.3.4:80
Session Affinity:    None
No events.

$ kubectl get ep my-nginx
NAME       ENDPOINTS                     AGE
my-nginx   10.244.2.5:80,10.244.3.4:80   1m
```

现在能够从集群中任意节点上，通过 curl 请求 Nginx Service <CLUSTER-IP>:<PORT> 。 注意 Service IP 完全是虚拟的，它从来没有走过网络，如果对它如何工作的原理好奇，可以阅读更多关于 [服务代理](https://k8smeetup.github.io/docs/user-guide/services/#virtual-ips-and-service-proxies) 的内容。

## 访问 Service

Kubernetes 支持两种主要的服务发现模式 —— 环境变量和 DNS。前者在单个节点上可用使用，然而后者需要 [kube-dns 集群插件](http://releases.k8s.io/master/cluster/addons/dns/README.md)。

### 环境变量

当 Pod 在 Node 上运行时，kubelet 会为每个活跃的 Service 添加一组环境变量。这会有一个顺序的问题。想了解为何，检查正在运行的 Nginx Pod 的环境变量（Pod 名称将不会相同）：

```
$ kubectl exec my-nginx-3800858182-jr4a2 -- printenv | grep SERVICE
KUBERNETES_SERVICE_HOST=10.0.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
```

注意，还没有谈及到 Service。这是因为创建副本先于 Service。 这样做的另一个缺点是，调度器可能在同一个机器上放置所有  Pod，如果该机器宕机则所有的 Service 都会挂掉。 正确的做法是，我们杀掉 2 个 Pod，等待 Deployment 去创建它们。  这次 Service 会 先于 副本存在。这将实现调度器级别的 Service，能够使 Pod 分散创建（假定所有的 Node  都具有同样的容量），还有正确的环境变量：

```
$ kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=2;

$ kubectl get pods -l run=my-nginx -o wide
NAME                        READY     STATUS    RESTARTS   AGE     IP            NODE
my-nginx-3800858182-e9ihh   1/1       Running   0          5s      10.244.2.7    kubernetes-minion-ljyd
my-nginx-3800858182-j4rm4   1/1       Running   0          5s      10.244.3.8    kubernetes-minion-905m
```

可能注意到，Pod 具有不同的名称，因为它们被杀掉后并被重新创建。

```
$ kubectl exec my-nginx-3800858182-e9ihh -- printenv | grep SERVICE
KUBERNETES_SERVICE_PORT=443
MY_NGINX_SERVICE_HOST=10.0.162.149
KUBERNETES_SERVICE_HOST=10.0.0.1
MY_NGINX_SERVICE_PORT=80
KUBERNETES_SERVICE_PORT_HTTPS=443
```

### DNS

Kubernetes 提供了一个 DNS 插件 Service，它使用 skydns 自动为其它 Service 指派 DNS 名字。 如果它在集群中处于运行状态，可以通过如下命令来检查：

```
$ kubectl get services kube-dns --namespace=kube-system
NAME       CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   10.0.0.10    <none>        53/UDP,53/TCP   8m
```

如果没有在运行，可以 [启用它](http://releases.k8s.io/master/cluster/addons/dns/README.md#how-do-i-configure-it)。 本段剩余的内容，将假设已经有一个 Service，它具有一个长久存在的 IP（my-nginx），一个为该 IP 指派名称的 DNS  服务器（kube-dns 集群插件），所以可以通过标准做法，使在集群中的任何 Pod 都能与该 Service  通信（例如：gethostbyname）。 让我们运行另一个 curl 应用来进行测试：

```
$ kubectl run curl --image=radial/busyboxplus:curl -i --tty
Waiting for pod default/curl-131556218-9fnch to be running, status is Pending, pod ready: false
Hit enter for command prompt
```

然后，按回车并执行命令 nslookup my-nginx：

```
[ root@curl-131556218-9fnch:/ ]$ nslookup my-nginx
Server:    10.0.0.10
Address 1: 10.0.0.10

Name:      my-nginx
Address 1: 10.0.162.149
```

## Service 安全

到现在为止，我们只在集群内部访问了 Nginx server。在将 Service 暴露到 Internet 之前，我们希望确保通信信道是安全的。对于这可能需要：

- https 自签名证书（除非已经有了一个识别身份的证书）
- 使用证书配置的 Nginx server
- 使证书可以访问 Pod 的[秘钥](https://k8smeetup.github.io/docs/user-guide/secrets)

可以从 [Nginx https 示例](https://github.com/kubernetes/kubernetes/tree/master/examples/https-nginx/) 获取所有上述内容，简明示例如下：

```
$ make keys secret KEY=/tmp/nginx.key CERT=/tmp/nginx.crt SECRET=/tmp/secret.json
$ kubectl create -f /tmp/secret.json
secret "nginxsecret" created
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-il9rc   kubernetes.io/service-account-token   1         1d
nginxsecret           Opaque                                2         1m
```

现在修改 Nginx 副本，启动一个使用在秘钥中的证书的 https 服务器和 Servcie，都暴露端口（80 和 443）：

| [nginx-secure-app.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/services-networking/nginx-secure-app.yaml)![Copy nginx-secure-app.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: v1 kind: Service metadata:  name: my-nginx  labels:    run: my-nginx spec:  type: NodePort  ports:  - port: 8080    targetPort: 80    protocol: TCP    name: http  - port: 443    protocol: TCP    name: https  selector:    run: my-nginx --- apiVersion: apps/v1beta1 kind: Deployment metadata:  name: my-nginx spec:  replicas: 1  template:    metadata:      labels:        run: my-nginx    spec:      volumes:      - name: secret-volume        secret:          secretName: nginxsecret      containers:      - name: nginxhttps        image: bprashanth/nginxhttps:1.0        ports:        - containerPort: 443        - containerPort: 80        volumeMounts:        - mountPath: /etc/nginx/ssl          name: secret-volume ` |

关于 nginx-secure-app manifest 值得注意的点如下：

- 它在相同的文件中包含了 Deployment 和 Service 的规格
- [Nginx server](https://github.com/kubernetes/kubernetes/tree/master/examples/https-nginx/default.conf) 处理 80 端口上的 http 流量，以及 443 端口上的 https 流量，Nginx Service 暴露了这两个端口。
- 每个容器访问挂载在 /etc/nginx/ssl 卷上的秘钥。这需要在 Nginx server 启动之前安装好。

```
$ kubectl delete deployments,svc my-nginx; kubectl create -f ./nginx-secure-app.yaml
```

这时可以从任何节点访问到 Nginx server。

```
$ kubectl get pods -o yaml | grep -i podip
    podIP: 10.244.3.5
node $ curl -k https://10.244.3.5
...
<h1>Welcome to nginx!</h1>
```

注意最后一步我们是如何提供 -k 参数执行 curl命令的，这是因为在证书生成时，我们不知道任何关于运行 Nginx 的 Pod  的信息，所以不得不在执行 curl 命令时忽略 CName 不匹配的情况。 通过创建 Service，我们连接了在证书中的 CName 与在  Service 查询时被 Pod使用的实际 DNS 名字。 让我们从一个 Pod 来测试（为了简化使用同一个秘钥，Pod 仅需要使用  nginx.crt 去访问 Service）：

| [curlpod.yaml ](https://raw.githubusercontent.com/kubernetes/kubernetes.github.io/master/docs/concepts/services-networking/curlpod.yaml)![Copy curlpod.yaml to clipboard](https://k8smeetup.github.io/images/copycode.svg) |
| ------------------------------------------------------------ |
| `apiVersion: apps/v1beta1 kind: Deployment metadata:  name: curl-deployment spec:  replicas: 1  template:    metadata:      labels:        app: curlpod    spec:      volumes:      - name: secret-volume        secret:          secretName: nginxsecret      containers:      - name: curlpod        command:        - sh        - -c        - while true; do sleep 1; done        image: radial/busyboxplus:curl        volumeMounts:        - mountPath: /etc/nginx/ssl          name: secret-volume ` |

```
$ kubectl create -f ./curlpod.yaml
$ kubectl get pods -l app=curlpod
NAME                               READY     STATUS    RESTARTS   AGE
curl-deployment-1515033274-1410r   1/1       Running   0          1m
$ kubectl exec curl-deployment-1515033274-1410r -- curl https://my-nginx --cacert /etc/nginx/ssl/nginx.crt
...
<title>Welcome to nginx!</title>
...
```

## 暴露 Service

对我们应用的某些部分，可能希望将 Service 暴露在一个外部 IP 地址上。 Kubernetes 支持两种实现方式：NodePort 和 LoadBalancer。 在上一段创建的 Service 使用了 NodePort，因此 Nginx https  副本已经就绪，如果使用一个公网 IP，能够处理 Internet 上的流量。

```
$ kubectl get svc my-nginx -o yaml | grep nodePort -C 5
  uid: 07191fb3-f61a-11e5-8ae5-42010af00002
spec:
  clusterIP: 10.0.162.149
  ports:
  - name: http
    nodePort: 31704
    port: 8080
    protocol: TCP
    targetPort: 80
  - name: https
    nodePort: 32453
    port: 443
    protocol: TCP
    targetPort: 443
  selector:
    run: my-nginx

$ kubectl get nodes -o yaml | grep ExternalIP -C 1
    - address: 104.197.41.11
      type: ExternalIP
    allocatable:
--
    - address: 23.251.152.56
      type: ExternalIP
    allocatable:
...

$ curl https://<EXTERNAL-IP>:<NODE-PORT> -k
...
<h1>Welcome to nginx!</h1>
```

让我们重新创建一个 Service，使用一个云负载均衡器，只需要将 my-nginx Service 的 Type 由 NodePort 改成 LoadBalancer。

```
$ kubectl edit svc my-nginx
$ kubectl get svc my-nginx
NAME       CLUSTER-IP     EXTERNAL-IP        PORT(S)               AGE
my-nginx   10.0.162.149   162.222.184.144    80/TCP,81/TCP,82/TCP  21s

$ curl https://<EXTERNAL-IP> -k
...
<title>Welcome to nginx!</title>
```

在 EXTERNAL-IP 列指定的 IP 地址是在公网上可用的。CLUSTER-IP 只在集群/私有云网络中可用。

注意，在 AWS 上类型 LoadBalancer 创建一个 ELB，它使用主机名（比较长），而不是 IP。  它太长以至于不能适配标准 kubectl get svc 的输出，事实上需要通过执行 kubectl describe service  my-nginx 命令来查看它。 可以看到类似如下内容：

```
$ kubectl describe service my-nginx
...
LoadBalancer Ingress:   a320587ffd19711e5a37606cf4a74574-1142138393.us-east-1.elb.amazonaws.com
...
```

## 进一步阅读

Kubernetes 也支持联合 Service，能够跨多个集群和云提供商，提供逐步增长的可用性，更好的容错和服务的可伸缩性。 查看 [联合 Service 用户指南](https://k8smeetup.github.io/docs/concepts/cluster-administration/federation-service-discovery/) 获取更进一步信息。

## 下一步

[了解更多关于 Kubernetes 的特性，有助于在生产环境中可靠地运行容器](https://k8smeetup.github.io/docs/user-guide/production-pods)

原文：https://k8smeetup.github.io/docs/concepts/services-networking/connect-applications-service/

译者：[shirdrn](https://github.com/shirdrn)

# Kubernetes DNS Pod 与 Service  介绍

- [1 介绍](http://docs.kubernetes.org.cn/733.html#i)
- [2 怎样获取 DNS 名字?](http://docs.kubernetes.org.cn/733.html#_DNS)
- 3 支持的 DNS 模式
  - 3.1 Service
    - [3.1.1 A 记录](http://docs.kubernetes.org.cn/733.html#A)
    - [3.1.2 SRV 记录](http://docs.kubernetes.org.cn/733.html#SRV)
    - [3.1.3 后向兼容性](http://docs.kubernetes.org.cn/733.html#i-2)
  - 3.2 Pod
    - [3.2.1 A 记录](http://docs.kubernetes.org.cn/733.html#A-2)
    - [3.2.2 基于 Pod hostname、subdomain 字段的 A 记录和主机名](http://docs.kubernetes.org.cn/733.html#_Pod_hostnamesubdomain_A)
- 4 如何测试它是否可以使用?
  - [4.1 创建一个简单的 Pod 作为测试环境](http://docs.kubernetes.org.cn/733.html#_Pod)
  - [4.2 等待这个 Pod 变成运行状态](http://docs.kubernetes.org.cn/733.html#_Pod-2)
  - [4.3 验证 DNS 已经生效](http://docs.kubernetes.org.cn/733.html#_DNS-3)
  - 4.4 问题排查技巧
    - [4.4.1 先检查本地 DNS 配置](http://docs.kubernetes.org.cn/733.html#_DNS-4)
    - [4.4.2 快速诊断](http://docs.kubernetes.org.cn/733.html#i-5)
    - [4.4.3 检查是否 DNS Pod 正在运行](http://docs.kubernetes.org.cn/733.html#_DNS_Pod)
    - [4.4.4 检查 DNS Pod 中的错误信息](http://docs.kubernetes.org.cn/733.html#_DNS_Pod-2)
    - [4.4.5 DNS 服务是否运行?](http://docs.kubernetes.org.cn/733.html#DNS)
- [5 Kubernetes Federation（多 Zone 支持)](http://docs.kubernetes.org.cn/733.html#Kubernetes_Federation_Zone)
- [6 工作原理](http://docs.kubernetes.org.cn/733.html#i-6)
- [7 从 Node 继承 DNS](http://docs.kubernetes.org.cn/733.html#_Node_DNS)
- [8 已知问题](http://docs.kubernetes.org.cn/733.html#i-7)

## 介绍

Kubernetes 从 1.3 版本起， DNS 是内置的服务，通过插件管理器 集群插件 自动被启动。

Kubernetes DNS 在集群中调度 DNS Pod 和 Service ，配置 kubelet 以通知个别容器使用 DNS Service 的 IP 解析 DNS 名字。

## 怎样获取 DNS 名字?

在集群中定义的每个 Service（包括 DNS 服务器自身）都会被指派一个 DNS 名称。默认，一个客户端 Pod 的 DNS 搜索列表将包含该 Pod 自己的 Namespace 和集群默认域。可以通过如下示例进行说明：

假设在 Kubernetes 集群的  Namespace bar 中，定义了一个Service foo。运行在Namespace bar 中的一个 Pod，可以简单地通过 DNS  查询 foo 来找到该 Service。运行在 Namespace quux 中的一个 Pod 可以通过 DNS 查询 foo.bar 找到该  Service。

## 支持的 DNS 模式

下面各段详细说明支持的记录类型和布局。如果任何其它的布局、名称或查询，碰巧也能够使用，这就需要研究下它们的实现细节，以免后续修改它们又不能使用了。

### Service

#### A 记录

“正常” Service（除了Headless Service）会以 my-svc.my-namespace.svc.cluster.local 这种名字的形式被指派一个 DNS A 记录。这会解析成该 Service 的 Cluster IP。

“Headless” Service（没有Cluster  IP）也会以 my-svc.my-namespace.svc.cluster.local 这种名字的形式被指派一个 DNS A 记录。不像正常  Service，它会解析成该 Service 选择的一组 Pod 的 IP。希望客户端能够使用这一组 IP，否则就使用标准的  round-robin 策略从这一组 IP 中进行选择。

#### SRV 记录

命名端口需要创建 SRV 记录，这些端口是正常 Service或 Headless Services 的一部分。 对每个命名端口，SRV  记录具有 _my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster.local 这种形式。 对普通 Service，这会被解析成端口号和 CNAME：my-svc.my-namespace.svc.cluster.local。 对  Headless Service，这会被解析成多个结果，Service 对应的每个 backend  Pod各一个，包含 auto-generated-name.my-svc.my-namespace.svc.cluster.local 这种形式 Pod 的端口号和 CNAME。

#### 后向兼容性

上一版本的 kube-dns 使用 my-svc.my-namespace.cluster.local 这种形式的名字（后续会增加 ‘svc’ 这一级），以后这将不再被支持。

### Pod

#### A 记录

如果启用，Pod 会以 pod-ip-address.my-namespace.pod.cluster.local 这种形式被指派一个 DNS A 记录。

例如，default Namespace 具有 DNS 名字 cluster.local，在该 Namespace 中一个 IP 为 1.2.3.4 的 Pod 将具有一个条目：1-2-3-4.default.pod.cluster.local。

#### 基于 Pod hostname、subdomain 字段的 A 记录和主机名

当前，创建 Pod 后，它的主机名是该 Pod 的 metadata.name 值。

在 v1.2 版本中，用户可以配置 Pod annotation，  通过 pod.beta.kubernetes.io/hostname 来设置 Pod 的主机名。 如果为 Pod 配置了  annotation，会优先使用 Pod 的名称作为主机名。 例如，给定一个 Pod，它具有  annotation pod.beta.kubernetes.io/hostname: my-pod-name，该 Pod 的主机名被设置为  “my-pod-name”。

在 v1.3 版本中，PodSpec 具有 hostname 字段，可以用来指定 Pod 的主机名。这个字段的值优先于  annotation pod.beta.kubernetes.io/hostname。 在 v1.2 版本中引入了 beta 特性，用户可以为  Pod 指定 annotation，其中 pod.beta.kubernetes.io/subdomain 指定了 Pod 的子域名。  最终的域名将是 “ ...svc.”。 举个例子，Pod 的主机名 annotation 设置为 “foo”，子域名 annotation  设置为 “bar”，在 Namespace “my-namespace” 中对应的 FQDN 为  “foo.bar.my-namespace.svc.cluster.local”。

在 v1.3 版本中，PodSpec 具有 subdomain 字段，可以用来指定 Pod 的子域名。这个字段的值优先于 annotation pod.beta.kubernetes.io/subdomain 的值。

```
apiVersion: v1
kind: Service
metadata:
  name: default-subdomain
spec:
  selector:
    name: busybox
  clusterIP: None
  ports:
    - name: foo # Actually, no port is needed.
      port: 1234 
      targetPort: 1234
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox1
  labels:
    name: busybox
spec:
  hostname: busybox-1
  subdomain: default-subdomain
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    name: busybox
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox2
  labels:
    name: busybox
spec:
  hostname: busybox-2
  subdomain: default-subdomain
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    name: busybox
```

如果 Headless Service 与 Pod 在同一个 Namespace 中，它们具有相同的子域名，集群的 KubeDNS  服务器也会为该 Pod 的完整合法主机名返回 A 记录。在同一个 Namespace 中，给定一个主机名为 “busybox-1” 的  Pod，子域名设置为 “default-subdomain”，名称为 “default-subdomain” 的 Headless  Service ，Pod 将看到自己的 FQDN 为  “busybox-1.default-subdomain.my-namespace.svc.cluster.local”。DNS  会为那个名字提供一个 A 记录，指向该 Pod 的 IP。“busybox1” 和 “busybox2” 这两个 Pod 分别具有它们自己的 A 记录。

在Kubernetes v1.2 版本中，Endpoints 对象也具有  annotation endpoints.beta.kubernetes.io/hostnames-map。它的值是  map[string(IP)][endpoints.HostRecord] 的 JSON 格式，例如：  ‘{“10.245.1.6”:{HostName: “my-webserver”}}’。

如果是 Headless Service 的 Endpoints，会以 ...svc. 的格式创建 A 记录。对示例中的 JSON  字符串，如果 `Endpoints` 是为名称为 “bar” 的 Headless Service 而创建的，其中一个 `Endpoints` 的 IP 是 “10.245.1.6”，则会创建一个名称为  “my-webserver.bar.my-namespace.svc.cluster.local” 的 A 记录，该 A 记录查询将返回  “10.245.1.6”。

Endpoints annotation 通常没必要由最终用户指定，但可以被内部的 Service Controller 用来提供上述功能。

在 v1.3 版本中，Endpoints 对象可以为任何 endpoint 指定 hostname 和  IP。hostname 字段优先于通过 endpoints.beta.kubernetes.io/hostnames-map annotation 指定的主机名。

在 v1.3 版本中，下面的 annotation  是过时的：pod.beta.kubernetes.io/hostname、pod.beta.kubernetes.io/subdomain、endpoints.beta.kubernetes.io/hostnames-map。

## 如何测试它是否可以使用?

### 创建一个简单的 Pod 作为测试环境

创建 busybox.yaml 文件，内容如下：

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
```

然后，用该文件创建一个 Pod：

```
kubectl create -f busybox.yaml
```

### 等待这个 Pod 变成运行状态

获取它的状态，执行如下命令：

```
kubectl get pods busybox
```

可以看到如下内容：

```
NAME      READY     STATUS    RESTARTS   AGE
busybox   1/1       Running   0          <some-time>
```

### 验证 DNS 已经生效

一旦 Pod 处于运行中状态，可以在测试环境中执行如下 nslookup 查询：

```
kubectl exec -ti busybox -- nslookup kubernetes.default
```

可以看到类似如下的内容：

```
Server:    10.0.0.10
Address 1: 10.0.0.10

Name:      kubernetes.default
Address 1: 10.0.0.1
```

如果看到了，说明 DNS 已经可以正确工作了。

### 问题排查技巧

如果执行 nslookup 命令失败，检查如下内容：

#### 先检查本地 DNS 配置

查看配置文件 resolv.conf。（关于更多信息，参考下面的 “从 Node 继承 DNS” 和 “已知问题”。）

```
kubectl exec busybox cat /etc/resolv.conf
```

按照如下方法（注意搜索路径可能会因为云提供商不同而变化）验证搜索路径和 Name Server 的建立：

```
search default.svc.cluster.local svc.cluster.local cluster.local google.internal c.gce_project_id.internal
nameserver 10.0.0.10
options ndots:5
```

#### 快速诊断

出现类似如下指示的错误，说明 kube-dns 插件或相关 Service 存在问题：

```
$ kubectl exec -ti busybox -- nslookup kubernetes.default
Server:    10.0.0.10
Address 1: 10.0.0.10

nslookup: can't resolve 'kubernetes.default'
```

或者

```
$ kubectl exec -ti busybox -- nslookup kubernetes.default
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'kubernetes.default'
```

#### 检查是否 DNS Pod 正在运行

使用 kubectl get pods 命令验证 DNS Pod 正在运行：

```
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns
```

应该能够看到类似如下信息：

```
NAME                                                       READY     STATUS    RESTARTS   AGE
...
kube-dns-v19-ezo1y                                         3/3       Running   0           1h
...
```

如果看到没有 Pod 运行，或 Pod 失败/结束，DNS 插件不能默认部署到当前的环境，必须手动部署。

#### 检查 DNS Pod 中的错误信息

使用 kubectl logs 命令查看 DNS 后台进程的日志：

```
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c kubedns
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c dnsmasq
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c healthz
```

查看是否有任何可疑的日志。在行开头的字母 W、E、F 分别表示 警告、错误、失败。请搜索具有这些日志级别的日志行，通过 [Kubernetes 问题](https://github.com/kubernetes/kubernetes/issues) 报告意外的错误。

#### DNS 服务是否运行?

通过使用 kubectl get service 命令，验证 DNS 服务是否运行：

```
kubectl get svc --namespace=kube-system
```

应该能够看到：

```
NAME                    CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
...
kube-dns                10.0.0.10      <none>        53/UDP,53/TCP        1h
...
```

如果服务已经创建，或在这个例子中默认被创建，但是并没有看到，可以查看 [调试 Service 页面](https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-service/) 获取更多信息。

```
kubectl get ep kube-dns --namespace=kube-system
```

应该能够看到类似如下信息：

```
NAME       ENDPOINTS                       AGE
kube-dns   10.180.3.17:53,10.180.3.17:53    1h
```

如果没有看到 Endpoint，查看 [调试 Service 文档](https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-service/) 中的 Endpoint 段内容。

关于更多 Kubernetes DNS 的示例，参考 Kubernetes GitHub 仓库中 [集群 DNS 示例](https://git.k8s.io/kubernetes/examples/cluster-dns)。

## Kubernetes Federation（多 Zone 支持)

在1.3 发行版本中，为多站点 Kubernetes 安装引入了集群 Federation 支持。这需要对 Kubernetes 集群  DNS 服务器处理 DNS 查询的方式，做出一些微小（后向兼容）改变，从而便利了对联合 Service 的查询（跨多个 Kubernetes  集群）。参考 [集群 Federation 管理员指南](https://k8smeetup.github.io/docs/concepts/cluster-administration/federation/) 获取更多关于集群 Federation 和多站点支持的细节。

## 工作原理

运行的 Kubernetes DNS Pod 包含 3 个容器 —— kubedns、dnsmasq 和负责健康检查的 healthz。  kubedns 进程监视 Kubernetes master 对 Service 和 Endpoint 操作的变更，并维护一个内存查询结构去处理 DNS 请求。dnsmasq 容器增加了一个 DNS 缓存来改善性能。为执行对 dnsmasq 和 kubedns 的健康检查，healthz 容器提供了一个单独的健康检查 Endpoint。

DNS Pod 通过一个静态 IP 暴露为一个 Service。一旦 IP 被分配，kubelet 会通过 --cluster-dns=10.0.0.10 标志将配置的 DNS 传递给每一个容器。

DNS 名字也需要域名，本地域名是可配置的，在 kubelet 中使用 --cluster-domain=<default local domain> 标志。

Kubernetes 集群 DNS 服务器（根据 [SkyDNS](https://github.com/skynetservices/skydns) 库）支持正向查询（A 记录），Service 查询（SRV 记录）和反向 IP 地址查询（PTR 记录）。

## 从 Node 继承 DNS

当运行 Pod 时，kubelet 将集群 DNS 服务器和搜索路径追加到 Node 自己的 DNS 设置中。如果 Node 能够在大型环境中解析 DNS 名字，Pod 也应该没问题。参考下面 “已知问题” 中给出的更多说明。

如果不想这样，或者希望 Pod 有一个不同的 DNS 配置，可以使用 kubelet 的 --resolv-conf 标志。设置为 “”  表示 Pod 将不继承自 DNS。设置为一个合法的文件路径，表示 kubelet 将使用这个文件而不是 /etc/resolv.conf 。

## 已知问题

Kubernetes 安装但并不配置 Node 的 resolv.conf 文件，而是默认使用集群 DNS的，因为那个过程本质上就是和特定的发行版本相关的。最终应该会被实现。

Linux libc 在限制为3个 DNS nameserver 记录和3个 DNS search 记录是不可能卡住的（[查看 2005 年的一个 Bug](https://bugzilla.redhat.com/show_bug.cgi?id=168253)）。Kubernetes  需要使用1个 nameserver 记录和3个 search 记录。这意味着如果本地安装已经使用了3个 nameserver 或使用了3个以上 search，那些设置将会丢失。作为部分解决方法， Node 可以运行 dnsmasq ，它能提供更多 nameserver 条目，但不能运行更多 search 条目。可以使用 kubelet  的 --resolv-conf 标志。

如果使用 3.3 版本的 Alpine 或更早版本作为 base 镜像，由于 Alpine 的一个已知问题，DNS 可能不会正确工作。查看 [这里](https://github.com/kubernetes/kubernetes/issues/30215) 获取更多信息。

# Kubernetes 声明网络策略

- [1 Before you begin](http://docs.kubernetes.org.cn/777.html#Before_you_begin)
- [2 创建一个nginx deployment 并且通过服务将其暴露](http://docs.kubernetes.org.cn/777.html#nginxdeployment)
- [3 测试服务能够被其它的 pod 访问](http://docs.kubernetes.org.cn/777.html#_pod)
- [4 限制访问 nginx 服务](http://docs.kubernetes.org.cn/777.html#nginx)
- [5 为服务指定策略](http://docs.kubernetes.org.cn/777.html#i)
- [6 当访问标签没有定义时测试访问服务](http://docs.kubernetes.org.cn/777.html#i-2)
- [7 定义访问标签后再次测试](http://docs.kubernetes.org.cn/777.html#i-3)

本文可以帮助您开始使用 Kubernetes 的 [NetworkPolicy API](http://docs.kubernetes.org.cn/776.html) 声明网络策略去管理 Pod 之间的通信

## Before you begin

您首先需要有一个支持网络策略的 Kubernetes 集群。已经有许多支持 NetworkPolicy 的网络提供商，包括：

- Calico
- Romana
- Weave 网络

注意：以上列表是根据产品名称按字母顺序排序，而不是按推荐或偏好排序。下面示例对于使用了上面任何提供商的 Kubernetes 集群都是有效的

## 创建一个nginx deployment 并且通过服务将其暴露

为了查看 Kubernetes 网络策略是怎样工作的，可以从创建一个nginx deployment 并且通过服务将其暴露开始

```
$ kubectl run nginx --image=nginx --replicas=2
deployment "nginx" created
$ kubectl expose deployment nginx --port=80 
service "nginx" exposed
```

在 default 命名空间下运行了两个 nginx pod，而且通过一个名字为 nginx 的服务进行了暴露

```
$ kubectl get svc,pod
NAME                        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
svc/kubernetes              10.100.0.1    <none>        443/TCP    46m
svc/nginx                   10.100.0.16   <none>        80/TCP     33s

NAME                        READY         STATUS        RESTARTS   AGE
po/nginx-701339712-e0qfq    1/1           Running       0          35s
po/nginx-701339712-o00ef    1/1           Running       0          35s
```

## 测试服务能够被其它的 pod 访问

您应该可以从其它的 pod 访问这个新的 nginx 服务。为了验证它，从 default 命名空间下的其它 pod 来访问该服务。请您确保在该命名空间下没有执行孤立动作。

启动一个 busybox 容器，然后在容器中使用 wget 命令去访问 nginx 服务：

```
$ kubectl run busybox --rm -ti --image=busybox /bin/sh
Waiting for pod default/busybox-472357175-y0m47 to be running, status is Pending, pod ready: false

Hit enter for command prompt

/ # wget --spider --timeout=1 nginx
Connecting to nginx (10.100.0.16:80)
/ #
```

## 限制访问 nginx 服务

如果说您想限制 nginx 服务，只让那些拥有标签 access: true 的 pod 访问它，那么您可以创建一个只允许从那些 pod 连接的 NetworkPolicy：

```
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: access-nginx
spec:
  podSelector:
    matchLabels:
      run: nginx
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: "true"
```

## 为服务指定策略

使用 kubectl 工具根据上面的 nginx-policy.yaml 文件创建一个 NetworkPolicy：

```
$ kubectl create -f nginx-policy.yaml
networkpolicy "access-nginx" created
```

## 当访问标签没有定义时测试访问服务

如果您尝试从没有设定正确标签的 pod 中去访问 nginx 服务，请求将会超时：

```
$ kubectl run busybox --rm -ti --image=busybox /bin/sh
Waiting for pod default/busybox-472357175-y0m47 to be running, status is Pending, pod ready: false

Hit enter for command prompt

/ # wget --spider --timeout=1 nginx 
Connecting to nginx (10.100.0.16:80)
wget: download timed out
/ #
```

## 定义访问标签后再次测试

创建一个拥有正确标签的 pod，您将看到请求是被允许的：

```
$ kubectl run busybox --rm -ti --labels="access=true" --image=busybox /bin/sh
Waiting for pod default/busybox-472357175-y0m47 to be running, status is Pending, pod ready: false

Hit enter for command prompt

/ # wget --spider --timeout=1 nginx
Connecting to nginx (10.100.0.16:80)
/ #
```

译者：[jianzhangbjz](https://github.com/jianzhangbjz) / [原文链接](https://k8smeetup.github.io/docs/tasks/administer-cluster/declare-network-policy/)

# Kubernetes Network Policy

- [1 前提条件](http://docs.kubernetes.org.cn/694.html#i)
- [2 隔离的与未隔离的 Pod](http://docs.kubernetes.org.cn/694.html#_Pod)
- [3 NetworkPolicy 资源](http://docs.kubernetes.org.cn/694.html#NetworkPolicy)
- 4 默认策略
  - [4.1 下一步](http://docs.kubernetes.org.cn/694.html#i-3)

网络策略说明一组 [Pod](http://docs.kubernetes.org.cn/312.html) 之间是如何被允许互相通信，以及如何与其它网络 Endpoint 进行通信。 NetworkPolicy 资源使用标签来选择 Pod，并定义了一些规则，这些规则指明允许什么流量进入到选中的 Pod 上。

## 前提条件

网络策略通过网络插件来实现，所以必须使用一种支持 NetworkPolicy 的网络方案 —— 非 Controller 创建的资源，是不起作用的。

## 隔离的与未隔离的 Pod

默认 Pod 是未隔离的，它们可以从任何的源接收请求。 具有一个可以选择 Pod 的网络策略后，Pod 就会变成隔离的。 一旦  Namespace 中配置的网络策略能够选择一个特定的 Pod，这个 Pod 将拒绝任何该网络策略不允许的连接。（Namespace  中其它未被网络策略选中的 Pod 将继续接收所有流量）

## NetworkPolicy 资源

查看 [API参考](https://kubernetes.io/docs/api-reference/v1.7/#networkpolicy-v1-networking) 可以获取该资源的完整定义。

下面是一个 NetworkPolicy 的例子：

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
```

将上面配置 POST 到 API Server 将不起任何作用，除非选择的网络方案支持网络策略。

必选字段：像所有其它 Kubernetes 配置一样， NetworkPolicy 需要 apiVersion、kind 和 metadata这三个字段，关于如何使用配置文件的基本信息，可以查看 [这里](https://kubernetes.io/docs/user-guide/simple-yaml)，[这里](https://kubernetes.io/docs/user-guide/configuring-containers) 和 [这里](https://kubernetes.io/docs/user-guide/working-with-resources)。

spec：NetworkPolicy [spec](https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status) 具有在给定 Namespace 中定义特定网络的全部信息。

podSelector：每个 NetworkPolicy 包含一个 podSelector，它可以选择一组应用了网络策略的  Pod。由于 NetworkPolicy 当前只支持定义 ingress 规则，这个 podSelector 实际上为该策略定义了一组  “目标Pod”。示例中的策略选择了标签为 “role=db” 的 Pod。一个空的 podSelector 选择了该 Namespace  中的所有 Pod。

ingress：每个NetworkPolicy 包含了一个白名单 ingress 规则列表。每个规则只允许能够匹配上 from和 ports配置段的流量。示例策略包含了单个规则，它从这两个源中匹配在单个端口上的流量，第一个是通过namespaceSelector 指定的，第二个是通过 podSelector 指定的。

因此，上面示例的 NetworkPolicy：

1. 在 “default” Namespace中 隔离了标签 “role=db” 的 Pod（如果他们还没有被隔离）
2. 在 “default” Namespace中，允许任何具有 “role=frontend” 的 Pod，连接到标签为 “role=db” 的 Pod 的 TCP 端口 6379
3. 允许在 Namespace 中任何具有标签 “project=myproject” 的 Pod，连接到 “default” Namespace 中标签为 “role=db” 的 Pod 的 TCP 端口 6379

查看 [NetworkPolicy 入门指南](https://kubernetes.io/docs/getting-started-guides/network-policy/walkthrough) 给出的更进一步的例子。

## 默认策略

通过创建一个可以选择所有 Pod 但不允许任何流量的 NetworkPolicy，你可以为一个 Namespace 创建一个 “默认的” 隔离策略，如下所示：

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector:
```

这确保了即使是没有被任何 NetworkPolicy 选中的 Pod，将仍然是被隔离的。

可选地，在 Namespace 中，如果你想允许所有的流量进入到所有的 Pod（即使已经添加了某些策略，使一些 Pod 被处理为 “隔离的”），你可以通过创建一个策略来显式地指定允许所有流量：

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all
spec:
  podSelector:
  ingress:
  - {}
```

# Kubernetes 垃圾收集

- [1 Owner 和 Dependent](http://docs.kubernetes.org.cn/693.html#Owner_Dependent)
- 2 控制垃圾收集器删除 Dependent
  - [2.1 Background 级联删除](http://docs.kubernetes.org.cn/693.html#Background)
  - [2.2 Foreground 级联删除](http://docs.kubernetes.org.cn/693.html#Foreground)
  - [2.3 设置级联删除策略](http://docs.kubernetes.org.cn/693.html#i)
- [3 已知的问题](http://docs.kubernetes.org.cn/693.html#i-2)

Kubernetes 垃圾收集器的角色是删除指定的对象，这些对象曾经有但以后不再拥有 Owner 了。

注意：垃圾收集是 beta 特性，在 Kubernetes 1.4 及以上版本默认启用。

## Owner 和 Dependent

一些 Kubernetes 对象是其它一些的 Owner。例如，一个 ReplicaSet 是一组 Pod 的 Owner。具有  Owner 的对象被称为是 Owner 的 Dependent。每个 Dependent  对象具有一个指向其所属对象的 metadata.ownerReferences 字段。

有时，Kubernetes 会自动设置 ownerReference 的值。例如，当创建一个 ReplicaSet  时，Kubernetes 自动设置 ReplicaSet 中每个 Pod 的 ownerReference 字段值。在 1.6  版本，Kubernetes 会自动为一些对象设置 ownerReference 的值，这些对象是由  ReplicationController、ReplicaSet、StatefulSet、DaemonSet 和 Deployment  所创建或管理。

也可以通过手动设置 ownerReference 的值，来指定 Owner 和 Dependent 之间的关系。

这有一个配置文件，表示一个具有 3 个 Pod 的 ReplicaSet：

```
apiVersion: extensions/v1beta1
kind: ReplicaSet
metadata:
  name: my-repset
spec:
  replicas: 3
  selector:
    matchLabels:
      pod-is-for: garbage-collection-example
  template:
    metadata:
      labels:
        pod-is-for: garbage-collection-example
    spec:
      containers:
      - name: nginx
        image: nginx
```

如果创建该 ReplicaSet，然后查看 Pod 的 metadata 字段，能够看到 OwnerReferences 字段：

```
kubectl create -f https://k8s.io/docs/concepts/abstractions/controllers/my-repset.yaml
kubectl get pods --output=yaml
```

输出显示了 Pod 的 Owner 是名为 my-repset 的 ReplicaSet：

```
apiVersion: v1
kind: Pod
metadata:
  ...
  ownerReferences:
  - apiVersion: extensions/v1beta1
    controller: true
    blockOwnerDeletion: true
    kind: ReplicaSet
    name: my-repset
    uid: d9607e19-f88f-11e6-a518-42010a800195
  ...
```

## 控制垃圾收集器删除 Dependent

当删除对象时，可以指定是否该对象的 Dependent 也自动删除掉。自动删除 Dependent 也称为 级联删除。Kubernetes 中有两种 级联删除 的模式：background 模式和 foreground 模式。

如果删除对象时，不自动删除它的 Dependent，这些 Dependent 被称作是原对象的 孤儿。

### Background 级联删除

在 background 级联删除 模式下，Kubernetes 会立即删除 Owner 对象，然后垃圾收集器会在后台删除这些 Dependent。

### Foreground 级联删除

在 foreground 级联删除 模式下，根对象首先进入 “删除中” 状态。在 “删除中” 状态会有如下的情况：

- 对象仍然可以通过 REST API 可见
- 会设置对象的 deletionTimestamp 字段
- 对象的 metadata.finalizers 字段包含了值 “foregroundDeletion”

一旦被设置为 “删除中” 状态，垃圾收集器会删除对象的所有 Dependent。垃圾收集器删除了所有 “Blocking” 的  Dependent（对象的 ownerReference.blockOwnerDeletion=true）之后，它会删除 Owner 对象。

注意，在 “foreground 删除” 模式下，Dependent  只有通过 ownerReference.blockOwnerDeletion 才能阻止删除 Owner 对象。在 Kubernetes 1.7  版本中将增加 admission controller，基于 Owner  对象上的删除权限来控制用户去设置 blockOwnerDeletion 的值为 true，所以未授权的 Dependent 不能够延迟  Owner 对象的删除。

如果一个对象的ownerReferences 字段被一个 Controller（例如 Deployment 或 ReplicaSet）设置，blockOwnerDeletion 会被自动设置，没必要手动修改这个字段。

### 设置级联删除策略

通过为 Owner 对象设置 deleteOptions.propagationPolicy 字段，可以控制级联删除策略。可能的取值包括：“orphan”、“Foreground” 或 “Background”。

对很多 Controller 资源，包括  ReplicationController、ReplicaSet、StatefulSet、DaemonSet 和  Deployment，默认的垃圾收集策略是 orphan。因此，除非指定其它的垃圾收集策略，否则所有 Dependent  对象使用的都是 orphan 策略。

下面是一个在后台删除 Dependent 对象的例子：

```
kubectl proxy --port=8080
curl -X DELETE localhost:8080/apis/extensions/v1beta1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Background"}' \
-H "Content-Type: application/json"
```

下面是一个在前台删除 Dependent 对象的例子：

```
kubectl proxy --port=8080
curl -X DELETE localhost:8080/apis/extensions/v1beta1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Foreground"}' \
-H "Content-Type: application/json"
```

下面是一个孤儿 Dependent 的例子：

```
kubectl proxy --port=8080
curl -X DELETE localhost:8080/apis/extensions/v1beta1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Orphan"}' \
-H "Content-Type: application/json"
```

kubectl 也支持级联删除。 通过设置 --cascade 为 true，可以使用 kubectl 自动删除 Dependent  对象。设置 --cascade 为 false，会使 Dependent 对象成为孤儿 Dependent 对象。--cascade 的默认值是 true。

下面是一个例子，使一个[ ReplicaSet](http://docs.kubernetes.org.cn/314.html) 的 [Dependent](http://docs.kubernetes.org.cn/317.html) 对象成为孤儿 Dependent：

```
kubectl delete replicaset my-repset --cascade=false
```

## 已知的问题

- 1.7 版本，垃圾收集不支持 [自定义资源](https://kubernetes.io/docs/concepts/api-extension/custom-resources/)，比如那些通过 CustomResourceDefinition 新增，或者通过 API server 聚集而成的资源对象。

[其它已知的问题](https://github.com/kubernetes/kubernetes/issues/26120)

# Windows Server 容器

- [1 前提条件](http://docs.kubernetes.org.cn/797.html#i)
- 2 网络
  - [2.1 Linux](http://docs.kubernetes.org.cn/797.html#Linux)
  - [2.2 Windows](http://docs.kubernetes.org.cn/797.html#Windows)
- 3 在Kubernetes上搭建Windows server 容器
  - [3.1 主机配置](http://docs.kubernetes.org.cn/797.html#i-3)
- 4 组件配置
  - [4.1 路由配置](http://docs.kubernetes.org.cn/797.html#i-5)
- [5 启动集群](http://docs.kubernetes.org.cn/797.html#i-6)
- [6 启动基于Linux的Kubernetes控制面板](http://docs.kubernetes.org.cn/797.html#LinuxKubernetes)
- [7 启动Windows节点组件](http://docs.kubernetes.org.cn/797.html#Windows-2)
- [8 在Windows上调度pod](http://docs.kubernetes.org.cn/797.html#Windowspod)
- [9 已知限制：](http://docs.kubernetes.org.cn/797.html#i-7)

Kubernetes v1.5引入了对Windows  Server容器的支持。在版本1.5中，Kubernetes控制面板（API服务器，调度器，控制管理器等）仍然运行在Linux上，但是kubelet和kube-proxy可以运行在Windows Server上。

注意: 在Kubernetes 1.5中，Kubernetes中的Windows Server容器还属于Alpha功能。

## 前提条件

在Kubernetes v1.5中，Windows Server容器对Kubernetes的支持使用如下方法：

1. Kubernetes控制面板还是运行在已有的Linux基础设施（v1.5及以后的版本）上
2. 在Linux节点上搭建Kubenet网络插件
3. Windows Server 2016 （RTM版本10.0.14393或之后的）
4. 对Windows Server节点而言，需要Docker 版本 v1.12.2-cs2-ws-beta或之后的（Linux节点和Kubernetes控制面板可以运行在任何支持Docker版本的Kubernetes上）

## 网络

网络是通过L3路由实现的。由于第三方的网络插件（比如 flannel，calico等）本身在Windows  Server上无法工作，它只能依赖于内嵌在Windows和Linux操作系统中的已有技术。在这个L3网络方法中，集群中的节点都选择使用/16的子网，每个工作节点选择/24的子网。在给定工作节点上的所有pod都会连接到/24的子网。这样，在同一个节点上的所有pod就能相互通信。为了激活运行在不同节点上的pod之间的网络，它使用了内嵌在Window server 2016 和Linux内的路由功能。

### Linux

以上网络方法在Linux上已经使用网桥接口实现，网桥接口本质上是在节点上创建了一个本地私有网络。与Windows方面一样，为了使用“公开”NIC发送数据包，必须创建到所有其他节点CIDR的路由。

### Windows

每个Windows server节点都必须做如下配置：

1. 每个Windows Server节点都都必须要有两块NIC（虚拟网络适配器） - 这两种Windows容器网络模式（传输层和L2网桥）使用一个外部Hyper-V虚拟交换机。这意味着其中有一个NIC完全分配给该网桥，这也是为什么还需要创建一个NIC。
2. 创建传输层容器网络 - 这是一个手工配置步骤，会在下面的Route Setup章节中介绍
3. 启用RRAS（路由）Windows功能 -  允许同一台机器上两个NIC之间的路由，并能“截获”目标地址是运行在该节点上的POD的数据包。要启用该功能，打开“服务器管理”，点击“角色”，“添加角色”，点击“下一步”，选择“网络策略和访问服务”，点击“路由和远程访问服务”，并选择底下的复选框。
4. 通过“公开”NIC将 - 这些路由添加到内嵌的路由表中，请参考下面的Route Setup章节

以下图表显示了在Windows Server上搭建Kubernetes的网络配置

## 在Kubernetes上搭建Windows server 容器

要在Kubernetes上运行Windows Server容器，你需要配置你的主机机器和Windows上的Kubernetes节点组件，并为在不同的节点上Pod之间的通信搭建路由。

### 主机配置

Windows主机配置

1. Windows Server容器要运行Windows Server 2016 和 Docker  v1.12。参考这个博客发表的搭建方法：https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server
2. 对Windows DNS的支持最近刚并到docker  master中，目前在稳定的docker发布版中还不支持。要使用DNS，你可以从master中构建docker，或从【docker  master】(https://master.dockerproject.org/)中下载二进制。
3. 从https://hub.docker.com/r/apprenda/pause中拖拽apprenda/pause镜像
4. 启用RRAS（路由） Windows功能
5. 在PowerShell窗口下运行New-VMSwitch -Name KubeProxySwitch -SwitchType  Internal命令来安装类型为‘Internal’的VMSwitch。这会创建一个新的名为vEthernet  (KubeProxySwitch)的网络接口。kube-proxy会使用这个接口来添加Service IP。

Linux 主机配置

1. Linux主机必须根据他们各自发行版的文档和你准备使用的Kubernetes的版本需求来配置。
2. 安装CNI网络插件。

## 组件配置

要求

- Git
- Go 1.7.1+
- make (如果使用的是Linux 或 MacOS)
- 关键注解和其他依赖关系都列在【这里】(https://git.k8s.io/community/contributors/devel/development.md#building-kubernetes-on-a-local-osshell-environment)

kubelet

要构建kubelet，运行：

1. cd $GOPATH/src/k8s.io/kubernetes
2. 构建 kubelet
   1. Linux/MacOS: KUBE_BUILD_PLATFORMS=windows/amd64 make WHAT=cmd/kubelet
   2. Windows: go build cmd/kubelet/kubelet.go

kube-proxy

要投建kube-proxy,运行：

1. cd $GOPATH/src/k8s.io/kubernetes
2. 构建 kube-proxy
   1. Linux/MacOS: KUBE_BUILD_PLATFORMS=windows/amd64 make WHAT=cmd/kube-proxy
   2. Windows: go build cmd/kube-proxy/proxy.go

### 路由配置

如下实例配置是假设你有一个Linux和两个Windows Server 2016 节点，以及集群CIDR 192.168.0.0/16。

| Hostname | Routable IP address | Pod CIDR       |
| -------- | ------------------- | -------------- |
| Lin01    | <IP of Lin01 host>  | 192.168.0.0/24 |
| Win01    | <IP of Win01 host>  | 192.168.1.0/24 |
| Win02    | <IP of Win02 host>  | 192.168.2.0/24 |

Lin01

```
ip route add 192.168.1.0/24 via <IP of Win01 host>
ip route add 192.168.2.0/24 via <IP of Win02 host>
```

Win01

```
docker network create -d transparent --gateway 192.168.1.1 --subnet 192.168.1.0/24 <network name>

# 创建了一个适配器名为"vEthernet (HNSTransparent)"的网桥。将它的IP地址设置为传输层网络网关
netsh interface ipv4 set address "vEthernet (HNSTransparent)" addr=192.168.1.1
route add 192.168.0.0 mask 255.255.255.0 192.168.0.1 if <Interface Id of the Routable Ethernet Adapter> -p
route add 192.168.2.0 mask 255.255.255.0 192.168.2.1 if <Interface Id of the Routable Ethernet Adapter> -p
```

Win02

```
docker network create -d transparent --gateway 192.168.2.1 --subnet 192.168.2.0/24 <network name>

# 创建了一个适配器名为"vEthernet (HNSTransparent)"的网桥。将它的IP地址设置为传输层网络网关
netsh interface ipv4 set address "vEthernet (HNSTransparent)" addr=192.168.2.1
route add 192.168.0.0 mask 255.255.255.0 192.168.0.1 if <Interface Id of the Routable Ethernet Adapter> -p
route add 192.168.1.0 mask 255.255.255.0 192.168.1.1 if <Interface Id of the Routable Ethernet Adapter> -p
```

## 启动集群

要启动你的集群，你需要将基于Linux的Kubernetes控制面板和基于Windows Server的Kubernetes节点组件都启动。

## 启动基于Linux的Kubernetes控制面板

你可以使用喜欢的方式在Linux上启动Kubernetes集群。请注意，该集群的CIDR可能需要更新。

## 启动Windows节点组件

要在你的Windows节点上启动kubelet： 在PowerShell窗口下运行以下命令。需要注意的是，如果节点重启或进程退出了，你需要重新运行以下命令来重启kubelet

1. 将环境变量CONTAINER_NETWORK的值设置为docker容器网络 $env:CONTAINER_NETWORK = "<docker network>"
2. 使用如下命令运行可执行文件 kubelet kubelet.exe --hostname-override=<ip  address/hostname of the windows node>  --pod-infra-container-image="apprenda/pause" --resolv-conf=""  --api_servers=<api server location>

要在你的Windows节点上启动kube-proxy：  使用管理员权限在PowerShell窗口里运行以下命令。需要注意的是，如果节点重启或进程退出了，你需要重新运行以下命令来重启kube-proxy。 .\proxy.exe --v=3 --proxy-mode=userspace --hostname-override=<ip  address/hostname of the windows node> --master=<api server  location> --bind-address=<ip address of the windows node>

## 在Windows上调度pod

由于你的集群中既有Linux也有Windows节点，为了能将pod调度到Windows节点上，你必须显示地设置nodeSelector限制条件。你必须把nodeSelector的标签beta.kubernetes.io/os的值设置为windows；请看下面的例子：

```
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "iis",
    "labels": {
      "name": "iis"
    }
  },
  "spec": {
    "containers": [
      {
        "name": "iis",
        "image": "microsoft/iis",
        "ports": [
          {
            "containerPort": 80
          }
        ]
      }
    ],
    "nodeSelector": {
      "beta.kubernetes.io/os": "windows"
    }
  }
}
```

## 已知限制：

1. Windows系统没有网络命名空间，因此目前只支持一个pod上只有一个容器。
2. 由于Windows Server容器的一个问题，Secrets目前不可用。该问题在【这里】描述(https://github.com/docker/docker/issues/28401)。
3. ConfigMaps目前还没有实现。
4. kube-proxy的实现使用了netsh portproxy，由于netsh portproxy`只支持TCP，因此只有在客户端使用TCP来重试DNS查询的时候，DNS才会有用。

## Kubernetes从零开始搭建自定义集群

- 1 设计和准备
  - [1.1 学习](http://docs.kubernetes.org.cn/774.html#i-2)
  - [1.2 Cloud Provider](http://docs.kubernetes.org.cn/774.html#Cloud_Provider)
  - [1.3 节点](http://docs.kubernetes.org.cn/774.html#i-3)
  - 1.4 网络
    - [1.4.1 网络连接](http://docs.kubernetes.org.cn/774.html#i-5)
    - [1.4.2 网络策略](http://docs.kubernetes.org.cn/774.html#i-6)
  - [1.5 集群命名](http://docs.kubernetes.org.cn/774.html#i-7)
  - 1.6 软件的二进制文件
    - [1.6.1 下载并解压 Kubernetes 二进制文件](http://docs.kubernetes.org.cn/774.html#_Kubernetes)
    - [1.6.2 选择镜像](http://docs.kubernetes.org.cn/774.html#i-9)
  - 1.7 安全模型
    - [1.7.1 准备证书](http://docs.kubernetes.org.cn/774.html#i-11)
    - [1.7.2 准备凭证](http://docs.kubernetes.org.cn/774.html#i-12)
- 2 在节点上配置和安装基础软件
  - [2.1 Docker](http://docs.kubernetes.org.cn/774.html#Docker)
  - [2.2 rkt](http://docs.kubernetes.org.cn/774.html#rkt)
  - [2.3 kubelet](http://docs.kubernetes.org.cn/774.html#kubelet)
  - [2.4 kube-proxy](http://docs.kubernetes.org.cn/774.html#kube-proxy)
  - [2.5 网络](http://docs.kubernetes.org.cn/774.html#i-14)
  - [2.6 其他](http://docs.kubernetes.org.cn/774.html#i-15)
  - [2.7 使用配置管理](http://docs.kubernetes.org.cn/774.html#i-16)
- 3 引导集群启动
  - [3.1 etcd](http://docs.kubernetes.org.cn/774.html#etcd)
  - 3.2 Apiserver, Controller Manager, and Scheduler
    - 3.2.1 Apiserver pod 模板
      - [3.2.1.1 Cloud Provider](http://docs.kubernetes.org.cn/774.html#Cloud_Provider-2)
    - [3.2.2 Scheduler pod 模板](http://docs.kubernetes.org.cn/774.html#Scheduler_pod)
    - [3.2.3 Controller Manager 模板](http://docs.kubernetes.org.cn/774.html#Controller_Manager)
    - [3.2.4 启动和验证 Apiserver，Scheduler 和 Controller Manager](http://docs.kubernetes.org.cn/774.html#_ApiserverScheduler_Controller_Manager)
  - [3.3 启动集群服务](http://docs.kubernetes.org.cn/774.html#i-18)
- 4 故障排除
  - [4.1 运行 validate-cluster](http://docs.kubernetes.org.cn/774.html#_validate-cluster)
  - [4.2 检查 pod 和 service](http://docs.kubernetes.org.cn/774.html#_pod_service)
  - [4.3 试一试例子](http://docs.kubernetes.org.cn/774.html#i-20)
  - [4.4 运行一致性测试](http://docs.kubernetes.org.cn/774.html#i-21)
  - [4.5 网络](http://docs.kubernetes.org.cn/774.html#i-22)
  - [4.6 帮助](http://docs.kubernetes.org.cn/774.html#i-23)
- [5 支持级别](http://docs.kubernetes.org.cn/774.html#i-24)

本指南适用于想要搭建一个定制化 Kubernetes  集群的人员。如果您在 列表 中找到现有的入门指南可以满足您的需求，那么建议使用它们，因为可从他人的经验中获益。但是，如果您使用特定的  IaaS，网络，配置管理或操作系统，同时又不符合这些指南的要求，那么本指南会为您提供所需的步骤大纲。请注意，比起其他预定义的指南，研习本指南需做出相当多的努力。

本指南对那些想要从更高层次了解现有集群安装脚本执行步骤的人员也很有用。

## 设计和准备

### 学习

1. 您应该已经熟悉使用 Kubernetes 集群。建议按照如下入门指南启动一个临时的集群。首先帮您熟悉 CLI（[kubectl](http://docs.kubernetes.org.cn/61.html)）和概念（[pods](http://docs.kubernetes.org.cn/312.html)，[services](http://docs.kubernetes.org.cn/703.html)等）。
2. 您的工作站应该已经存在 ‘kubectl’。这是完成其他入门指南后的一个附加安装。如果没有，请遵循 [说明](https://www.kubernetes.org.cn/installkubectl)。

### Cloud Provider

Kubernetes 的 Cloud Provider 是一个模块，它提供一个管理 TCP  负载均衡，节点（实例）和网络路由的接口。此接口定义在 pkg/cloudprovider/cloud.go。未实现 Cloud Provider 也可以建立自定义集群（例如使用裸机），并不是所有的接口功能都必须实现，这取决于如何在各组件上设置标识。

### 节点

- 您可以使用虚拟机或物理机。
- 虽然可以使用一台机器构建集群，但为了运行所有的例子和测试，至少需要4个节点。
- 许多入门指南对主节点和常规节点进行区分。 这不是绝对必要的。
- 节点需要使用 x86_64 架构运行某些版本的 Linux。在其他操作系统和架构上运行是可行的，但本指南不会协助指导。
- Apiserver 和 etcd 可以运行在1个核心和 1GB RAM 的机器上，这适用于拥有数十个节点的集群。 更大或更活跃的集群可能受益于更多的核心。
- 其他节点可以配备任何合理的内存和任意数量的内核。它们不需要相同的配置。

### 网络

#### 网络连接

Kubernetes 有一个独特的 网络模型。

Kubernetes 为每个 pod 分配一个 IP 地址。创建集群时，需要为 Kubernetes 分配一段 IP 以用作 pod 的  IP。最简单的方法是为集群中的每个节点分配不同的 IP 段。 pod 中的进程可以访问其他 pod 的 IP  并与之通信。这种连接可以通过两种方式实现：

- 使用 overlay 网络
  - overlay 网络通过流量封装（例如 vxlan）来屏蔽 pod 网络的底层网络架构。
  - 封装会降低性能，但具体多少取决于您的解决方案。
- 不使用 overlay 网络
  - 配置底层网络结构（交换机，路由器等）以熟知 Pod IP 地址。
  - 不需要 overlay 的封装，因此可以实现更好的性能。

选择哪种方式取决于您的环境和需求。有多种方法来实现上述的某种选项：

- 使用 Kubernetes 调用的网络插件
  - Kubernetes 支持 [CNI](https://github.com/containernetworking/cni) 网络插件接口。
  - 有许多解决方案为 Kubernetes 提供插件（按字母顺序排列）：
    - [Calico](http://docs.projectcalico.org/)
    - [Flannel](https://github.com/coreos/flannel)
    - [Open vSwitch (OVS)](http://openvswitch.org/)
    - [Romana](http://romana.io/)
    - [Weave](http://weave.works/)
  - 您也可以编写自己的插件。
- 将网络插件直接编译进 Kubernetes
  - 可以通过 cloud provider 模块的 “Routes” 接口来实现。
  - Google Compute Engine（[GCE](http://docs.kubernetes.org.cn/282.html)）和 [AWS](http://docs.kubernetes.org.cn/288.html) 指南使用此方法。
- 为 Kubernetes 配置外部网络
  - 这可以通过手工执行命令或通过一组外部维护的脚本来完成。
  - 您不得不自己实现，此功能可以带来额外的灵活性。

需要为 Pod IP 选择一个地址范围。请注意，Pod IP 尚不支持 IPv6。

- 多种方法:
  - GCE：每个项目都有自己的 10.0.0.0/8。从该空间为每个 Kubernetes 集群分配子网 /16，多个集群都拥有自己的空间。 每个节点从该网段获取进一步的子网细分。
  - AWS：整个组织使用一个 VPC ，为每个集群划分一个块，或者为不同的集群使用不同的 VPC。
- 为每个节点的 PodIP 分配同一个 CIDR 子网，或者分配单个大型 CIDR，该大型 CIDR 由每个节点上较小的 CIDR 所组成的。
  - 您一共需要 max-pods-per-node * max-number-of-nodes 个  IP。每个节点配置子网 /24，即每台机器支持 254 个 pods，这是常见的配置。如果 IP 不充足，配置 /26（每个机器62个  pod）甚至是 /27（30个 pod）也是足够的。
  - 例如，使用 10.10.0.0/16 作为集群范围，支持最多256个节点各自使用 10.10.0.0/24 到 10.10.255.0/24 的 IP 范围。
  - 需要使它们路由可达或通过 overlay 连通。

Kubernetes 也为每个 [service](http://docs.kubernetes.org.cn/703.html) 分配一个 IP。但是，Service IP 无须路由。在流量离开节点前，kube-proxy 负责将 Service IP 转换为 Pod  IP。您需要利用 SERVICE_CLUSTER_IP_RANGE 为 service 分配一段  IP。例如，设置 SERVICE_CLUSTER_IP_RANGE="10.0.0.0/16" 以允许激活 65534  个不同的服务。请注意，您可以增大此范围，但在不中断使用它的 service 和 pod 时，您不能移动该范围（指增大下限或减小上限）。

此外，您需要为主节点选择一个静态 IP。

- 称为 MASTER_IP。
- 打开防火墙以允许访问 apiserver 的端口 80 和/或 443。
- 启用 ipv4 转发，net.ipv4.ip_forward = 1

#### 网络策略

Kubernetes 可以在 Pods 之间使用 [网络策略](http://docs.kubernetes.org.cn/694.html) 定义细粒度的网络策略。

并非所有网络提供商都支持 Kubernetes NetworkPolicy API，参阅 [使用网络策略](http://docs.kubernetes.org.cn/694.html) 获取更多内容。

### 集群命名

您应该为集群选择一个名称。为每个集群选择一个简短的名称并在以后的集群使用中将其作为唯一命名。以下几种方式中都会用到集群名称：

- 通过 kubectl 来区分您想要访问的各种集群。有时候您可能想要第二个集群，比如测试新的 Kubernetes 版本，运行在不同地区的 Kubernetes 等。
- Kubernetes 集群可以创建 cloud provider 资源（例如AWS ELB），并且不同的集群需要区分每个创建的资源。称之为 CLUSTER_NAME。

### 软件的二进制文件

您需要以下二进制文件：

- etcd
- 以下 Container 运行工具之一:
  - docker
  - rkt
- Kubernetes
  - kubelet
  - kube-proxy
  - kube-apiserver
  - kube-controller-manager
  - kube-scheduler

#### 下载并解压 Kubernetes 二进制文件

Kubernetes 发行版包括所有的 Kubernetes 二进制文件以及受支持的 etcd 发行版。 您可以使用 Kubernetes 的发行版（推荐）或按照 [开发人员文档](https://git.k8s.io/community/contributors/devel/) 中的说明构建您的 Kubernetes 二进制文件。本指南仅涉及使用 Kubernetes 发行版。

下载并解压 [最新的发行版](https://github.com/kubernetes/kubernetes/releases/latest)。服务器二进制 tar 包不再包含在 Kubernetes 的最终 tar  包中，因此您需要找到并运行 ./kubernetes/cluster/get-kube-binaries.sh 来下载客户端和服务器的二进制文件。  然后找到 ./kubernetes/server/kubernetes-server-linux-amd64.tar.gz 并解压缩。接着在被解压开的目录 ./kubernetes/server/bin 中找到所有必要的二进制文件。

#### 选择镜像

您将在容器之外运行 docker，kubelet 和  kube-proxy，与运行系统守护进程的方式相同，这些程序需要单独的二进制文件。对于  etcd，kube-apiserver，kube-controller-manager 和  kube-scheduler，我们建议您将其作为容器运行，因此需要构建相应的镜像。

获取 Kubernetes 镜像的几种方式：

- 使用谷歌容器仓库（GCR）上托管的镜像：
  - 例如 gcr.io/google_containers/hyperkube:$TAG，其中 TAG 是最新的版本标签，可在 [最新版本页面](https://github.com/kubernetes/kubernetes/releases/latest) 上找到。
  - 确保 $TAG 与您使用的 kubelet 和 kube-proxy 的发行版标签相同。
  - [hyperkube]（https://releases.k8s.io/ master/cmd/hyperkube）是一个包含全部组件的二进制文件。
    - hyperkube kubelet ... 表示运行 kubelet，hyperkube apiserver ... 表示运行一个 apiserver，以此类推。
- 构建私有镜像
  - 在使用私有镜像库时很有用
  - 包含诸如 ./kubernetes/server/bin/kube-apiserver.tar 之类的文件，可以使用诸如 docker load -i kube-apiserver.tar 之类的命令将其转换为 docker 镜像。
  - 您可以使用命令 docker images 验证镜像是否加载正确的仓库和标签。

使用 etcd：

- 使用谷歌容器仓库（GCR）上托管的 gcr.io/google_containers/etcd:2.2.1
- 使用 [Docker Hub](https://hub.docker.com/search/?q=etcd) 或 [Quay.io](https://quay.io/repository/coreos/etcd) 上托管的镜像，比如 quay.io/coreos/etcd:v2.2.1。
- 使用操作系统安装源中的 etcd 发行版。
- 构建自己的镜像
  - 执行：cd kubernetes/cluster/images/etcd; make

我们建议您使用 Kubernetes 发行版中提供的 etcd。Kubernetes 程序已经使用此版本的 etcd  进行了广泛的测试，而不是与任何其他版本的  etcd。推荐的版本号也可以在 kubernetes/cluster/images/etcd/Makefile 中作为 TAG 的值被找到。

该文档的剩余部分假定镜像标签已被选定并存储在相应的环境变量中。例子（替换最新的标签和适当的仓库源）：

- HYPERKUBE_IMAGE=gcr.io/google_containers/hyperkube:$TAG
- ETCD_IMAGE=gcr.io/google_containers/etcd:$ETCD_VERSION

### 安全模型

两种主要的安全方式：

- 用 HTTP 访问 apiserver
  - 使用防火墙进行安全防护
  - 安装简单
- 用 HTTPS 访问 apiserver
  - 使用带证书的 https 和用户凭证。
  - 这是推荐的方法
  - 配置证书可能很棘手。

如果遵循 HTTPS 方法，则需要准备证书和凭证。

#### 准备证书

您需要准备几种证书：

- 作为 HTTPS 服务端的主节点需要一个证书。
- 作为主节点的客户端，kubelet 可以选择使用证书来认证自己，并通过 HTTPS 提供自己的 API 服务。

除非您打算用一个真正的 CA 生成证书，否则您需要生成一个根证书，并使用它来签署主节点，kubelet 和 kubectl 证书。在 [认证文档](http://docs.kubernetes.org.cn/144.html) 中描述了如何做到这一点。

最终您会得到以下文件（稍后将用到这些变量）

- CA_CERT
  - 放在运行 apiserver 的节点上，例如位于 /srv/kubernetes/ca.crt。
- MASTER_CERT
  - 被 CA_CERT 签名
  - 放在运行 apiserver 的节点上，例如位于 /srv/kubernetes/server.crt。
- MASTER_KEY
  - 放在运行 apiserver 的节点上，例如位于 /srv/kubernetes/server.key。
- KUBELET_CERT
  - 可选
- KUBELET_KEY
  - 可选

#### 准备凭证

管理员用户（和任何用户）需要：

- 用于识别他们的令牌或密码。
- 令牌只是长字母数字的字符串，例如32个字符，生成方式
- TOKEN=$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d "=+/" | dd bs=32 count=1 2>/dev/null)

您的令牌和密码需要存储在文件中才能被 apiserver 读取。本指南使用 /var/lib/kube-apiserver/known_tokens.csv。此文件的格式在 [身份验证文档](http://docs.kubernetes.org.cn/144.html) 中有描述。

为了向客户端分发凭证，Kubernetes 约定将凭证放入 kubeconfig 文件 中。

可以创建管理员的 kubeconfig 文件，如下所示：

- 如果您已经使用非定制集群的 Kubernetes（例如，遵循入门指南），那么您已拥有 $HOME/.kube/config 文件。
- 您需要添加证书，密钥和主节点 IP 到 kubeconfig 文件：
  - 如果使用仅防火墙安全选项，则以此方式设置 apiserver：
    - kubectl config set-cluster $CLUSTER_NAME --server=http://$MASTER_IP --insecure-skip-tls-verify=true
  - 否则，请设置 apiserver ip，客户端证书和用户凭证。
    - kubectl config set-cluster $CLUSTER_NAME --certificate-authority=$CA_CERT --embed-certs=true --server=https://$MASTER_IP
    - kubectl config set-credentials $USER --client-certificate=$CLI_CERT --client-key=$CLI_KEY --embed-certs=true --token=$TOKEN
  - 将集群设置为要使用的默认集群
    - kubectl config set-context $CONTEXT_NAME --cluster=$CLUSTER_NAME --user=$USER
    - kubectl config use-context $CONTEXT_NAME

接下来，为 kubelet 和 kube-proxy 创建一个 kubeconfig 文件。创建多少不同文件有几种选择：

1. 使用与管理员相同的凭证 - 这是最简单的设置。
2. 所有 kubelet 用一套令牌和 kubeconfig 文件，kube-proxy 用一套，管理端用一套。 - 这是如今在 GCE 上的方式
3. 每个 kubelet 使用不同的凭证 - 我们正在改进，但所有的细节还没有准备好。

您可以通过拷贝 $HOME/.kube/config、参考 cluster/gce/configure-vm.sh 中的代码或者使用下面的模板来创建这些文件：

```
apiVersion: v1
kind: Config
users:
- name: kubelet
  user:
    token: ${KUBELET_TOKEN}
clusters:
- name: local
  cluster:
    certificate-authority: /srv/kubernetes/ca.crt
contexts:
- context:
    cluster: local
    user: kubelet
  name: service-account-context
current-context: service-account-context
```

将 kubeconfig 文件放在每个节点上。以后本指南的例子假设在 /var/lib/kube-proxy/kubeconfig 和 /var/lib/kube-proxy/kubeconfig 中有 kubeconfig。

## 在节点上配置和安装基础软件

本节讨论如何将机器配置为 Kubernetes 节点。

您应该在每个节点上运行三个守护进程：

- docker 或者 rkt
- kubelet
- kube-proxy

您还需要在安装操作系统后进行各种其他配置。

提示：比较可行的方法是先使用现有的入门指南来设置集群。在集群运行后，您可以从该集群复制 init.d 脚本或 systemd 单元文件，然后修改它们以便在您的自定义集群上使用。

### Docker

所需 Docker 的最低版本随 kubelet 版本的更改而变化。推荐使用最新的稳定版。如果版本太旧，Kubelet 将抛出警告并拒绝启动 pod，请尝试更换合适的 Docker 版本。

如果您已经安装过 Docker，但是该节点并没有配置过 Kubernetes，那么节点上可能存在 Docker 创建的网桥和 iptables 规则。您可能需要像下面这样删除这些内容，然后再为 Kubernetes 配置 Docker。

```
iptables -t nat -F
ip link set docker0 down
ip link delete docker0
```

配置 docker 的方式取决于您是否为网络选择了可路由的虚拟 IP 或 overlay 网络方式。Docker 的建议选项：

- 为每个节点的 CIDR 范围创建自己的网桥，将其称为 cbr0，并在 docker 上设置 --bridge=cbr0 选项。
- 设置 --iptables=false，docker 不会操纵有关主机端口的 iptables（Docker 的旧版本太粗糙，可能会在较新的版本中修复），以便 kube-proxy 管理 iptables 而不是通过 docker。
- --ip-masq=false
  - 在您把 PodIP 设置为可路由时，需要设置此选项，否则，docker 会将 PodIP 源地址重写为 NodeIP。
  - 某些环境（例如 GCE）需要您对离开云环境的流量进行伪装。这类环境比较特殊。
  - 如果您正在使用 overlay 网络，请参阅这些说明。
- --mtu=
  - 使用 Flannel 时可能需要该选项，因为 udp 封装会增大数据包
- --insecure-registry $CLUSTER_SUBNET
  - 使用非 SSL 方式连接到您设立的私有仓库。

如果想增加 docker 的文件打开数量，设置：

- DOCKER_NOFILE=1000000

此配置方式取决于您节点上的操作系统。例如在 GCE 上，基于 Debian 的发行版使用 /etc/default/docker。

通过 Docker 文档中给出的示例，确保在继续安装其余部分之前，您系统上的 docker 工作正常。

### rkt

[rkt](https://github.com/coreos/rkt) 是 Docker 外的另一种选择，您只需要安装 Docker 或 rkt 之一。其最低版本要求 [v0.5.6](https://github.com/coreos/rkt/releases/tag/v0.5.6)。

您的节点需要 [systemd](http://www.freedesktop.org/wiki/Software/systemd/) 来运行 rkt。匹配 rkt v0.5.6 的最小版本是 [systemd 215](http://lists.freedesktop.org/archives/systemd-devel/2014-July/020903.html)。

对 rkt 的网络支持还需要 [rkt 元数据服务](https://github.com/coreos/rkt/blob/master/Documentation/networking/overview.md)。您可以使用命令启动 rkt 元数据服务 sudo systemd-run rkt metadata-service

然后，您需要将该参数配置到 kubelet：

- --container-runtime=rkt

### kubelet

所有节点都应该运行 kubelet。参阅 软件的二进制文件。

要考虑的参数：

- 如果遵循 HTTPS 安全方法：
  - --api-servers=https://$MASTER_IP
  - --kubeconfig=/var/lib/kubelet/kubeconfig
- 否则，如果采取基于防火墙的安全方法
  - --api-servers=http://$MASTER_IP
- --config=/etc/kubernetes/manifests
- --cluster-dns= 指定要设置的 DNS 服务器地址，（请参阅启动群集服务。）
- --cluster-domain= 指定用于集群 DNS 地址的 dns 域前缀。
- --docker-root=
- --root-dir=
- --configure-cbr0= （如下面所描述的）
- --register-node （在 [节点](http://docs.kubernetes.org.cn/304.html) 文档中描述 ）

### kube-proxy

所有节点都应该运行 kube-proxy。（并不严格要求在“主”节点上运行 kube-proxy，但保持一致更简单。） 下载使用 kube-proxy 的方法和 kubelet 一样。

要考虑的参数：

- 如果遵循 HTTPS 安全方法：
  - --master=https://$MASTER_IP
  - --kubeconfig=/var/lib/kube-proxy/kubeconfig
- 否则，如果采取基于防火墙的安全方法
  - --master=http://$MASTER_IP

### 网络

每个节点需要分配自己的 CIDR 范围，用于 pod 网络。称为 NODE_X_POD_CIDR。

需要在每个节点上创建一个名为 cbr0 的网桥。在 [网络文档](http://docs.kubernetes.org.cn/776.html) 中进一步说明了该网桥。网桥本身需要从 $NODE_X_POD_CIDR 获取一个地址，按惯例是第一个  IP。称为 NODE_X_BRIDGE_ADDR。例如，如果 NODE_X_POD_CIDR 是 10.0.0.0/16，则NODE_X_BRIDGE_ADDR 是 10.0.0.1/16。 注意：由于以后使用这种方式，因此会保留后缀 /16。

- 推荐自动化方式：

  1. 在 kubelet init 脚本中设置 --configure-cbr0=true 选项并重新启动 kubelet  服务。Kubelet 将自动配置 cbr0。 直到节点控制器设置了 Node.Spec.PodCIDR，网桥才会配置完成。由于您尚未设置  apiserver 和节点控制器，网桥不会立即被设置。

- 或者使用手动方案：

  1. 在 kubelet 上设置 --configure-cbr0=false 并重新启动。

  2. 创建一个网桥。

     ```
        ip link add name cbr0 type bridge
     ```

  3. 设置适当的 MTU。 注意：MTU 的实际值取决于您的网络环境。

     ```
        ip link set dev cbr0 mtu 1460
     ```

  4. 将节点的网络添加到网桥（docker 将在桥的另一侧）。

     ```
        ip addr add $NODE_X_BRIDGE_ADDR dev cbr0
     ```

  5. 启动网桥

     ```
        ip link set dev cbr0 up
     ```

如果您已经关闭 Docker 的 IP 伪装，以允许pod相互通信，那么您可能需要为集群网络之外的目标 IP 进行伪装。例如：

```
iptables -t nat -A POSTROUTING ! -d ${CLUSTER_SUBNET} -m addrtype ! --dst-type LOCAL -j MASQUERADE
```

对于集群外部的流量，这将重写从 PodIP 到节点 IP 的源地址，并且内核 [连接跟踪](http://www.iptables.info/en/connection-state.html) 将确保目的地为节点地址的流量仍可抵达 pod。

注意：以上描述适用于特定的环境。其他环境根本不需要伪装。如 GCE，不允许 Pod IP 向外网发送流量，但在您的 GCE 项目内部之间没有问题。

### 其他

- 如果需要，为您的操作系统软件包管理器启用自动升级。
- 为所有节点组件配置日志轮转（例如使用 [logrotate](http://linux.die.net/man/8/logrotate)）。
- 设置活动监视（例如使用[supervisord](http://supervisord.org/)）。
- 设置卷支持插件（可选）
  - 安装可选卷类型的客户端，例如 GlusterFS 卷的 glusterfs-client。

### 使用配置管理

之前的步骤都涉及用于设置服务器的“常规”系统管理技术。您可能希望使用配置管理系统来自动执行节点配置过程。在各种入门指南中有 Ansible，Juju 和 CoreOS Cloud Config 的示例 [Saltstack](https://k8smeetup.github.io/docs/admin/salt)。

## 引导集群启动

虽然基础节点服务（kubelet, kube-proxy, docker）还是由传统的系统管理/自动化方法启动和管理，但是 Kubernetes 中其余的 master 组件都由 Kubernetes 配置和管理：

- 它们的选项在 Pod 定义（yaml 或 json）中指定，而不是 /etc/init.d 文件或 systemd 单元中。
- 它们由 Kubernetes 而不是 init 运行。

### etcd

您需要运行一个或多个 etcd 实例。

- 高可用且易于恢复 - 运行3或5个 etcd 实例，将其日志写入由持久性存储（RAID，GCE PD）支持的目录，
- 非高可用，但易于恢复 - 运行一个 etcd 实例，其日志写入由持久性存储（RAID，GCE PD）支持的目录， 注意： 如果实例发生中断可能导致操作中断。
- 高可用 - 运行3或5个非持久性存储 etcd 实例。 注意： 由于存储被复制，日志可以写入非持久性存储。

运行一个 etcd 实例：

1. 复制 cluster/saltbase/salt/etcd/etcd.manifest
2. 按需要进行修改
3. 通过将其放入 kubelet 清单目录来启动 pod。

### Apiserver, Controller Manager, and Scheduler

Apiserver，Controller Manager和 Scheduler 将分别以 pod 形式在主节点上运行。。

对于这些组件，启动它们的步骤类似：

1. 从所提供的 pod 模板开始。
2. 将 选取镜像 中的值设置到 HYPERKUBE_IMAGE。
3. 使用每个模板下面的建议，确定集群需要哪些参数。
4. 将完成的模板放入 kubelet 清单目录中启动 pod。
5. 验证 pod 是否启动。

#### Apiserver pod 模板

```
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-apiserver"
  },
  "spec": {
    "hostNetwork": true,
    "containers": [
      {
        "name": "kube-apiserver",
        "image": "${HYPERKUBE_IMAGE}",
        "command": [
          "/hyperkube",
          "apiserver",
          "$ARG1",
          "$ARG2",
          ...
          "$ARGN"
        ],
        "ports": [
          {
            "name": "https",
            "hostPort": 443,
            "containerPort": 443
          },
          {
            "name": "local",
            "hostPort": 8080,
            "containerPort": 8080
          }
        ],
        "volumeMounts": [
          {
            "name": "srvkube",
            "mountPath": "/srv/kubernetes",
            "readOnly": true
          },
          {
            "name": "etcssl",
            "mountPath": "/etc/ssl",
            "readOnly": true
          }
        ],
        "livenessProbe": {
          "httpGet": {
            "scheme": "HTTP",
            "host": "127.0.0.1",
            "port": 8080,
            "path": "/healthz"
          },
          "initialDelaySeconds": 15,
          "timeoutSeconds": 15
        }
      }
    ],
    "volumes": [
      {
        "name": "srvkube",
        "hostPath": {
          "path": "/srv/kubernetes"
        }
      },
      {
        "name": "etcssl",
        "hostPath": {
          "path": "/etc/ssl"
        }
      }
    ]
  }
}
```

以下是您可能需要设置的一些 apiserver 参数：

- --cloud-provider= 参阅 cloud providers
- --cloud-config= 参阅 cloud providers
- --address=${MASTER_IP} 或者 --bind-address=127.0.0.1 和 --address=127.0.0.1 如果要在主节点上运行代理。
- --service-cluster-ip-range=$SERVICE_CLUSTER_IP_RANGE
- --etcd-servers=http://127.0.0.1:4001
- --tls-cert-file=/srv/kubernetes/server.cert
- --tls-private-key-file=/srv/kubernetes/server.key
- --admission-control=$RECOMMENDED_LIST
  - 参阅 [admission controllers](http://docs.kubernetes.org.cn/144.html) 获取推荐设置。
- --allow-privileged=true，只有当您信任您的集群用户以 root 身份运行 pod 时。

如果您遵循仅防火墙的安全方法，请使用以下参数：

- --token-auth-file=/dev/null
- --insecure-bind-address=$MASTER_IP
- --advertise-address=$MASTER_IP

如果您使用 HTTPS 方法，请设置：

- --client-ca-file=/srv/kubernetes/ca.crt
- --token-auth-file=/srv/kubernetes/known_tokens.csv
- --basic-auth-file=/srv/kubernetes/basic_auth.csv

pod 使用 hostPath 卷挂载几个节点上的文件系统目录。这样的目的是：

- 挂载 /etc/ssl 以允许 apiserver 找到 SSL 根证书，以便它可以验证外部服务，例如一个 cloud provider。
  - 如果未使用 cloud provider，则不需要（例如裸机）。
- 挂载 /srv/kubernetes 以允许 apiserver 读取存储在节点磁盘上的证书和凭证。这些（证书和凭证）也可以存储在永久性磁盘上，例如 GCE PD，或烧录到镜像中。
- 可选，您也可以挂载 /var/log，并将输出重定向到那里。（未显示在模板中）。
  - 如果您希望使用 journalctl 等工具从根文件系统访问日志，请执行此操作。

待办 文档化 proxy-ssh 的安装

##### Cloud Provider

Apiserver 支持若干 cloud providers。

- --cloud-provider 标志的选项有 aws，azure，cloudstack，fake， gce， mesos， openstack， ovirt，photon，rackspace，vsphere 或者不设置。
- 在使用裸机安装的情况下无需设置。
- 通过在 [这里](https://releases.k8s.io/master/pkg/cloudprovider/providers) 贡献代码添加对新 IaaS 的支持。

一些 cloud provider 需要一个配置文件。如果是这样，您需要将配置文件放入 apiserver 镜像或通过 hostPath 挂载。

- --cloud-config= 在 cloud provider 需要配置文件时设置。
- 由 aws, gce, mesos, openshift, ovirt 和 rackspace 使用。
- 您必须将配置文件放入 apiserver 镜像或通过 hostPath 挂载。
- Cloud 配置文件语法为 [Gcfg](https://code.google.com/p/gcfg/)。
- AWS 格式由 [AWSCloudConfig](https://releases.k8s.io/master/pkg/cloudprovider/providers/aws/aws.go) 定义。
- 其他 cloud provider 的相应文件中也有类似的类型。
- GCE 例子：在 [这个文件](https://releases.k8s.io/master/cluster/gce/configure-vm.sh) 中搜索gce.conf。

#### Scheduler pod 模板

完成 Scheduler pod 模板：

```
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-scheduler"
  },
  "spec": {
    "hostNetwork": true,
    "containers": [
      {
        "name": "kube-scheduler",
        "image": "$HYBERKUBE_IMAGE",
        "command": [
          "/hyperkube",
          "scheduler",
          "--master=127.0.0.1:8080",
          "$SCHEDULER_FLAG1",
          ...
          "$SCHEDULER_FLAGN"
        ],
        "livenessProbe": {
          "httpGet": {
            "scheme": "HTTP",
            "host": "127.0.0.1",
            "port": 10251,
            "path": "/healthz"
          },
          "initialDelaySeconds": 15,
          "timeoutSeconds": 15
        }
      }
    ]
  }
}
```

通常，调度程序不需要额外的标志。

或者，您也可能需要挂载 /var/log，并重定向输出到这里。

#### Controller Manager 模板

Controller Manager pod 模板

```
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-controller-manager"
  },
  "spec": {
    "hostNetwork": true,
    "containers": [
      {
        "name": "kube-controller-manager",
        "image": "$HYPERKUBE_IMAGE",
        "command": [
          "/hyperkube",
          "controller-manager",
          "$CNTRLMNGR_FLAG1",
          ...
          "$CNTRLMNGR_FLAGN"
        ],
        "volumeMounts": [
          {
            "name": "srvkube",
            "mountPath": "/srv/kubernetes",
            "readOnly": true
          },
          {
            "name": "etcssl",
            "mountPath": "/etc/ssl",
            "readOnly": true
          }
        ],
        "livenessProbe": {
          "httpGet": {
            "scheme": "HTTP",
            "host": "127.0.0.1",
            "port": 10252,
            "path": "/healthz"
          },
          "initialDelaySeconds": 15,
          "timeoutSeconds": 15
        }
      }
    ],
    "volumes": [
      {
        "name": "srvkube",
        "hostPath": {
          "path": "/srv/kubernetes"
        }
      },
      {
        "name": "etcssl",
        "hostPath": {
          "path": "/etc/ssl"
        }
      }
    ]
  }
}
```

使用 controller manager 时需要考虑的标志：

- --cluster-cidr=，集群中 pod 的 CIDR 范围。
- --allocate-node-cidrs=，如果您使用 --cloud-provider=，请分配并设置云提供商上的 pod 的 CIDR。
- --cloud-provider= 和 --cloud-config 如 apiserver 部分所述。
- --service-account-private-key-file=/srv/kubernetes/server.key，由 [service account](http://docs.kubernetes.org.cn/703.html) 功能使用。
- --master=127.0.0.1:8080

#### 启动和验证 Apiserver，Scheduler 和 Controller Manager

将每个完成的 pod 模板放入 kubelet 配置目录中（kubelet  的参数 --config= 参数设置的值，通常是 /etc/kubernetes/manifests）。顺序不重要：scheduler 和  controller manager 将重试到 apiserver 的连接，直到它启动为止。

使用 ps 或 docker ps 来验证每个进程是否已经启动。例如，验证 kubelet 是否已经启动了一个 apiserver 的容器：

```
$ sudo docker ps | grep apiserver:
5783290746d5        gcr.io/google_containers/kube-apiserver:e36bf367342b5a80d7467fd7611ad873            "/bin/sh -c '/usr/lo'"    10 seconds ago      Up 9 seconds                              k8s_kube-apiserver.feb145e7_kube-apiserver-kubernetes-master_default_eaebc600cf80dae59902b44225f2fc0a_225a4695
```

然后尝试连接到 apiserver：

```
$ echo $(curl -s http://localhost:8080/healthz)
ok
$ curl -s http://localhost:8080/api
{
  "versions": [
    "v1"
  ]
}
```

如果您为 kubelet 选择了 --register-node=true 选项，那么它们向 apiserver 自动注册。 您应该很快就可以通过运行 kubectl get nodes 命令查看所有节点。 否则，您需要手动创建节点对象。

### 启动集群服务

您将希望通过添加集群范围的服务来完成您的 Kubernetes 集群。这些有时被称为 addons，查阅在 管理指南 中的概述。

下面给出了设置每个集群服务的注意事项：

- 集群 DNS：
  - 许多 Kubernetes 的例子都需要
  - [安装说明](http://releases.k8s.io/master/cluster/addons/dns/)
  - 管理指南
- 集群级日志
  - 集群级日志概述
  - 使用 Elasticsearch 的集群级日志
  - 使用 Stackdriver 的集群级日志
- 容器资源监控
  - [安装说明](http://releases.k8s.io/master/cluster/addons/cluster-monitoring/)
- GUI
  - 集群 [安装说明](https://github.com/kubernetes/kube-ui)

## 故障排除

### 运行 validate-cluster

cluster/kube-up.sh 调用 cluster/validate-cluster.sh 用于确定集群启动是否成功。

使用和输出示例：

```
KUBECTL_PATH=$(which kubectl) NUM_NODES=3 KUBERNETES_PROVIDER=local cluster/validate-cluster.sh
Found 3 node(s).
NAME                    STATUS    AGE     VERSION
node1.local             Ready     1h      v1.6.9+a3d1dfa6f4335
node2.local             Ready     1h      v1.6.9+a3d1dfa6f4335
node3.local             Ready     1h      v1.6.9+a3d1dfa6f4335
Validate output:
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-1               Healthy   {"health": "true"}
etcd-2               Healthy   {"health": "true"}
etcd-0               Healthy   {"health": "true"}
Cluster validation succeeded
```

### 检查 pod 和 service

尝试通过其他入门指南中的 “检查集群” 部分，例如 [GCE](https://k8smeetup.github.io/docs/getting-started-guides/gce/#inspect-your-cluster)。您应该看到一些服务。还应该看到 apiserver，scheduler 和 controller-manager 的 “镜像 pod”，以及您启动的任何加载项。

### 试一试例子

此时，您应该能够运行一个基本的例子，例如 [nginx 例子](https://k8smeetup.github.io/docs/tutorials/stateless-application/deployment.yaml)。

### 运行一致性测试

您可能想尝试运行 [一致性测试](http://releases.k8s.io/ master /test/e2e_node/conformance/run_test.sh)。任何失败都会给一个提示，您需要更多地关注它们。

### 网络

节点必须能够使用其私有 IP 通讯。从一个节点到另一个节点使用 ping 或 SSH 命令进行验证。

### 帮助

如果您遇到问题，请参阅 [troubleshooting](http://docs.kubernetes.org.cn/282.html)，联系 [kubernetes 用户组](https://groups.google.com/forum/#!forum/kubernetes-users)，或者在 Slack 提问。

## 支持级别

| IaaS 提供商 | 配置管理 | 系统 | 网络 | 文档 | 整合 | 支持级别                                        |
| ----------- | -------- | ---- | ---- | ---- | ---- | ----------------------------------------------- |
| 任何        | 任何     | 任何 | 任何 | 文档 |      | 社区 ([@erictune](https://github.com/erictune)) |

有关所有解决方案的支持级别信息，请参阅图表 解决方案表。

# Kubernetes API

Kubernetes [控制面](https://kubernetes.io/zh/docs/reference/glossary/?all=true#term-control-plane) 的核心是 [API 服务器](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-apiserver/)。 API 服务器负责提供 HTTP API，以供用户、集群中的不同部分和集群外部组件相互通信。

Kubernetes API 使你可以查询和操纵 Kubernetes API 中对象（例如：Pod、Namespace、ConfigMap 和 Event）的状态。

大部分操作都可以通过 [kubectl](https://kubernetes.io/zh/docs/reference/kubectl/overview/) 命令行接口或 类似 [kubeadm](https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/) 这类命令行工具来执行， 这些工具在背后也是调用 API。不过，你也可以使用 REST 调用来访问这些 API。

如果你正在编写程序来访问 Kubernetes API，可以考虑使用 [客户端库](https://kubernetes.io/zh/docs/reference/using-api/client-libraries/)之一。

## OpenAPI 规范    

完整的 API 细节是用 [OpenAPI](https://www.openapis.org/) 来表述的。

Kubernetes API 服务器通过 `/openapi/v2` 末端提供 OpenAPI 规范。 你可以按照下表所给的请求头部，指定响应的格式：

| 头部               | 可选值                                                       | 说明                     |
| ------------------ | ------------------------------------------------------------ | ------------------------ |
| `Accept-Encoding`  | `gzip`                                                       | *不指定此头部也是可以的* |
| `Accept`           | `application/com.github.proto-openapi.spec.v2@v1.0+protobuf` | *主要用于集群内部*       |
| `application/json` | *默认值*                                                     |                          |
| `*`                | *提供*`application/json`                                     |                          |

Kubernetes 为 API 实现了一种基于 Protobuf 的序列化格式，主要用于集群内部通信。 关于此格式的详细信息，可参考 [Kubernetes Protobuf 序列化](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/protobuf.md) 设计提案。每种模式对应的接口描述语言（IDL）位于定义 API 对象的 Go 包中。

## API 变更    

任何成功的系统都要随着新的使用案例的出现和现有案例的变化来成长和变化。 为此，Kubernetes 的功能特性设计考虑了让 Kubernetes API 能够持续变更和成长的因素。 Kubernetes 项目的目标是 *不要* 引发现有客户端的兼容性问题，并在一定的时期内 维持这种兼容性，以便其他项目有机会作出适应性变更。

一般而言，新的 API 资源和新的资源字段可以被频繁地添加进来。 删除资源或者字段则要遵从 [API 废弃策略](https://kubernetes.io/zh/docs/reference/using-api/deprecation-policy/)。

关于什么是兼容性的变更、如何变更 API 等详细信息，可参考 [API 变更](https://git.k8s.io/community/contributors/devel/sig-architecture/api_changes.md#readme)。

## API 组和版本  

为了简化删除字段或者重构资源表示等工作，Kubernetes 支持多个 API 版本， 每一个版本都在不同 API 路径下，例如 `/api/v1` 或 `/apis/rbac.authorization.k8s.io/v1alpha1`。

版本化是在 API 级别而不是在资源或字段级别进行的，目的是为了确保 API 为系统资源和行为提供清晰、一致的视图，并能够控制对已废止的和/或实验性 API 的访问。

为了便于演化和扩展其 API，Kubernetes 实现了 可被[启用或禁用](https://kubernetes.io/zh/docs/reference/using-api/#enabling-or-disabling)的 [API 组](https://kubernetes.io/zh/docs/reference/using-api/#api-groups)。

API 资源之间靠 API 组、资源类型、名字空间（对于名字空间作用域的资源而言）和 名字来相互区分。API 服务器可能通过多个 API 版本来向外提供相同的下层数据， 并透明地完成不同 API 版本之间的转换。所有这些不同的版本实际上都是同一资源 的（不同）表现形式。例如，假定同一资源有 `v1` 和 `v1beta1` 版本， 使用 `v1beta1` 创建的对象则可以使用 `v1beta1` 或者 `v1` 版本来读取、更改 或者删除。

关于 API 版本级别的详细定义，请参阅 [API 版本参考](https://kubernetes.io/zh/docs/reference/using-api/#api-versioning)。

## API 扩展 

有两种途径来扩展 Kubernetes API：

1. 你可以使用[自定义资源](https://kubernetes.io/zh/docs/concepts/extend-kubernetes/api-extension/custom-resources/) 来以声明式方式定义 API 服务器如何提供你所选择的资源 API。
2. 你也可以选择实现自己的 [聚合层](https://kubernetes.io/zh/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/) 来扩展 Kubernetes API。

## 接下来

- 了解如何通过添加你自己的 [CustomResourceDefinition](https://kubernetes.io/zh/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/) 来扩展 Kubernetes API。
- [控制 Kubernetes API 访问](https://kubernetes.io/zh/docs/concepts/security/controlling-access/) 页面描述了集群如何针对 API 访问管理身份认证和鉴权。
- 通过阅读 [API 参考](https://kubernetes.io/zh/docs/reference/kubernetes-api/) 了解 API 端点、资源类型以及示例。
