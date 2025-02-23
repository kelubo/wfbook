# API

[TOC]

# Cluster API - MicroK8s 集群 API - MicroK8s

#### On this page 本页内容

​                                                [CAPI Architecture CAPI 体系结构](https://microk8s.io/docs/clusterapi#capi-architecture)                                                      [Links 链接](https://microk8s.io/docs/clusterapi#links)                                                              

*ClusterAPI* (CAPI) is an open-source Kubernetes project that provides a declarative API for cluster creation, configuration, and management. It is designed to automate the creation and management of Kubernetes clusters in  various environments, including on-premises data centers, public clouds, and edge devices.
*ClusterAPI* （CAPI） 是一个开源 Kubernetes 项目，它为集群创建、配置和管理提供声明性 API。它旨在在各种环境（包括本地数据中心、公有云和边缘设备）中自动创建和管理 Kubernetes 集群。

CAPI abstracts away the details of infrastructure provisioning, networking,  and other low-level tasks, allowing users to define their desired  cluster configuration using simple YAML manifests. This makes it easier  to create and manage clusters in a repeatable and consistent manner,  regardless of the underlying infrastructure. In this way a wide range of infrastructure providers has been made available, including but not  limited to Amazon Web Services (AWS), Microsoft Azure, Google Cloud  Platform (GCP), and OpenStack.
CAPI 抽象出基础设施预置、联网和其他低级任务的详细信息，允许用户使用简单的 YAML  清单定义所需的集群配置。这使得以可重复且一致的方式创建和管理集群变得更加容易，而不管底层基础设施如何。通过这种方式，提供了广泛的基础设施提供商，包括但不限于 Amazon Web Services （AWS）、Microsoft Azure、Google Cloud Platform （GCP） 和 OpenStack。

CAPI also abstracts the provisioning and management of Kubernetes clusters  allowing for a variety of Kubernetes distributions to be delivered in  all of the supported infrastructure providers. MicroK8s is one such  Kubernetes distribution that seamlessly integrates with Cluster API.
CAPI 还抽象了 Kubernetes 集群的预置和管理，允许在所有受支持的基础设施提供商中交付各种 Kubernetes 发行版。MicroK8s 就是这样一种与 Cluster API 无缝集成的 Kubernetes 发行版。

With MicroK8s CAPI you can:
使用 MicroK8s CAPI，您可以：

- provision a cluster with:

  
  为集群预置：

  - Kubernetes version 1.24 onwards
    Kubernetes 版本 1.24 及更高版本
  - risk level of the track you want to follow (stable, candidate, beta, edge)
    您要关注的轨道的风险级别（稳定、候选、测试版、边缘）
  - integration to a snapstore proxy
    集成到 Snapstore 代理
  - deploy behind proxies 部署在代理后面

- upgrade clusters with no downtime:

  
  在不停机的情况下升级集群：

  - rolling upgrades for HA clusters and worker nodes
    HA 集群和 Worker 节点的滚动升级
  - in-place upgrades for non-HA control planes
    非 HA 控制平面的就地升级

- initilize clusters with workloads:

  
  使用工作负载启动集群：

  - enable addons during bootstrap
    在 Bootstrap 期间启用插件

Please refer to the “HowTo” section for concrete examples on CAPI deployments:
请参阅 “HowTo” 部分，了解有关 CAPI 部署的具体示例：

- [Deploy a cluster 部署集群](https://microk8s.io/docs/capi-provision)
- [Management cluster lifecycle
  管理集群生命周期](https://microk8s.io/docs/capi-management)
- [Cluster upgrades 集群升级](https://microk8s.io/docs/capi-upgrade)

## [ CAPI Architecture CAPI 体系结构](https://microk8s.io/docs/clusterapi#capi-architecture)

Being a cloud-native framework, CAPI implements all its components as  controllers that run within a Kubernetes cluster. There is a separate  controller, called a ‘provider’, for each supported infrastructure  substrate. The infrastructure providers are responsible for provisioning physical or virtual nodes and setting up networking elements such as  load balancers and virtual networks. In a similar way, each Kubernetes  distribution that integrates with ClusterAPI is managed by two  providers: the control plane provider and the bootstrap provider. The  bootstrap provider is responsible for delivering and managing Kubernetes on the nodes, while the control plane provider handles the control  plane’s specific lifecycle.
作为云原生框架，CAPI 将其所有组件实现为在 Kubernetes 集群中运行的控制器。对于每个支持的基础设施  substrate，都有一个单独的控制器，称为“provider”。基础设施提供商负责预置物理或虚拟节点，并设置负载均衡器和虚拟网络等网络元素。以类似的方式，与 ClusterAPI 集成的每个 Kubernetes 发行版都由两个提供者管理：控制平面提供者和 bootstrap  提供者。引导提供程序负责在节点上交付和管理 Kubernetes，而控制平面提供程序处理控制平面的特定生命周期。

The CAPI providers operate within a Kubernetes cluster known as the  management cluster. The administrator is responsible for selecting the  desired combination of infrastructure and Kubernetes distribution by  instantiating the respective infrastructure, bootstrap, and control  plane providers on the management cluster.
CAPI 提供程序在称为管理集群的 Kubernetes 集群中运行。管理员负责通过在管理集群上实例化相应的基础设施、引导程序和控制平面提供程序来选择所需的基础设施和 Kubernetes 发行版组合。

The management cluster functions as the control plane for the ClusterAPI  operator, which is responsible for provisioning and managing the  infrastructure resources necessary for creating and managing additional  Kubernetes clusters. It is important to note that the management cluster is not intended to support any other workload, as the workloads are  expected to run on the provisioned clusters. As a result, the  provisioned clusters are referred to as workload clusters.
管理集群充当 ClusterAPI作员的控制平面，该作员负责预置和管理创建和管理其他 Kubernetes 集群所需的基础设施资源。请务必注意，管理集群并非旨在支持任何其他工作负载，因为工作负载应在预置的集群上运行。因此，预置的集群称为工作负载集群。

Typically, the management cluster runs in a separate environment from the clusters it manages, such as a public cloud or an on-premises data center. It  serves as a centralized location for managing the configuration,  policies, and security of multiple managed clusters. By leveraging the  management cluster, users can easily create and manage a fleet of  Kubernetes clusters in a consistent and repeatable manner.
通常，管理集群在与其管理的集群不同的环境中运行，例如公有云或本地数据中心。它用作管理多个托管集群的配置、策略和安全性的集中位置。通过利用管理集群，用户可以以一致且可重复的方式轻松创建和管理 Kubernetes 集群队列。

The MicroK8s team maintains the two providers required for integrating with CAPI:
MicroK8s 团队维护与 CAPI 集成所需的两个提供程序：

- The Cluster API Bootstrap Provider MicroK8s (**CABPM**) responsible for provisioning the nodes in the cluster and preparing  them to be joined to the Kubernetes control plane. When you use the  CABPM you define a Kubernetes Cluster object that describes the desired  state of the new cluster and includes the number and type of nodes in  the cluster, as well as any additional configuration settings. The  Bootstrap Provider then creates the necessary resources in the  Kubernetes API server to bring the cluster up to the desired state.  Under the hood, the Bootstrap Provider uses cloud-init to configure the  nodes in the cluster. This includes setting up SSH keys, configuring the network, and installing necessary software packages.
  集群 API 引导提供程序 MicroK8s （**CABPM）** 负责配置集群中的节点并准备将它们加入 Kubernetes 控制平面。当您使用 CABPM 时，您可以定义一个 Kubernetes  Cluster 对象，该对象描述新集群的所需状态，并包括集群中节点的数量和类型，以及任何其他配置设置。然后，Bootstrap Provider 在 Kubernetes API 服务器中创建必要的资源，以将集群恢复到所需的状态。在后台，引导提供程序使用 cloud-init  来配置集群中的节点。这包括设置 SSH 密钥、配置网络和安装必要的软件包。
- The Cluster API Control Plane Provider MicroK8s (**CACPM**) enables the creation and management of Kubernetes control planes using  MicroK8s as the underlying Kubernetes distribution. Its main tasks are  to update the machine state and to generate the kubeconfig file used for accessing the cluster. The kubeconfig file is stored as a secret which  the user can then retrieve using the  `clusterctl`command.
  集群 API 控制平面提供程序 MicroK8s （**CACPM**） 支持使用 MicroK8s 作为底层 Kubernetes 发行版创建和管理 Kubernetes 控制平面。它的主要任务是更新机器状态并生成用于访问集群的 kubeconfig 文件。kubeconfig 文件存储为 secret，然后用户可以使用 `clusterctl`命令检索该密钥。



[![deployment_diagram](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/optimized/2X/6/635ed6ac2c8e60ffcb94eed516277fd4151c33b3_2_636x500.jpeg)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/6/635ed6ac2c8e60ffcb94eed516277fd4151c33b3.jpeg)



## [ Links 链接](https://microk8s.io/docs/clusterapi#links)

- Cluster API docs: [Introduction - The Cluster API Book](https://cluster-api.sigs.k8s.io/introduction.html)
  Cluster API 文档：[简介 - The Cluster API Book](https://cluster-api.sigs.k8s.io/introduction.html)
- Cluster API control plane provider MicroK8s docs in Cluster API docs:
  Cluster API 控制平面提供商 Cluster API 文档中的 MicroK8s 文档：
   [MicroK8s based control plane management - The Cluster API Book
  基于 MicroK8s 的控制平面管理 - The Cluster API Book](https://cluster-api.sigs.k8s.io/tasks/control-plane/microk8s-control-plane.html)
- Cluster API bootstrap provider MicroK8s docs in Cluster API docs: [MicroK8s based bootstrap - The Cluster API Book](https://cluster-api.sigs.k8s.io/tasks/bootstrap/microk8s-bootstrap.html)
  Cluster API 引导提供程序 Cluster API 文档中的 MicroK8s 文档：[基于 MicroK8s 的引导 - The Cluster API Book](https://cluster-api.sigs.k8s.io/tasks/bootstrap/microk8s-bootstrap.html)
- GitHub repo for CACPM: [GitHub  - canonical/cluster-api-control-plane-provider-microk8s: This project  offers a cluster API control plane controller that manages the control  plane of a MicroK8s cluster. It is expected to be used along with the  respective MicroK8s specific machine bootstrap provider.](https://github.com/canonical/cluster-api-control-plane-provider-microk8s)
  CACPM 的 GitHub 存储库：[GitHub  - canonical/cluster-api-control-plane-provider-microk8s：该项目提供了一个集群 API  控制平面控制器，用于管理 MicroK8s 集群的控制平面。它应与相应的 MicroK8s 特定计算机引导提供程序一起使用。](https://github.com/canonical/cluster-api-control-plane-provider-microk8s)
- GitHub repo for CABPM: [GitHub  - canonical/cluster-api-bootstrap-provider-microk8s: This project  offers a cluster API bootstrap provider controller that manages the node  provision of a MicroK8s cluster.](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s)
  CABPM 的 GitHub 存储库：[GitHub - canonical/cluster-api-bootstrap-provider-microk8s：此项目提供了一个集群 API 引导提供程序控制器，用于管理 MicroK8s 集群的节点配置。](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s)

## Cluster Provisioning with CAPI 使用 CAPI 进行集群配置                                                   

This page covers how to deploy a MicroK8s multi-node cluster using the Cluster API.
本页介绍如何使用 Cluster API 部署 MicroK8s 多节点集群。

### [Install clusterctl 安装 clusterctl](https://microk8s.io/docs/capi-provision#p-38735-install-clusterctl)

The clusterctl CLI tool handles the lifecycle of a Cluster API management cluster. To install it follow the [upstream instructions](https://cluster-api.sigs.k8s.io/user/quick-start.html#install-clusterctl).
clusterctl CLI 工具处理 Cluster API 管理集群的生命周期。要按照[上游说明](https://cluster-api.sigs.k8s.io/user/quick-start.html#install-clusterctl)进行安装。
 Typically this involves fetching the executable that matches your  hardware architecture, and placing it in your PATH. For example, at the  time this HowTo was authored for AMD64 you would:
通常，这涉及获取与硬件体系结构匹配的可执行文件，并将其放置在 PATH 中。例如，在为 AMD64 编写此 HowTo 时，您将：

```auto
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.7.0/clusterctl-linux-amd64 -o clusterctl
sudo install -o root -g root -m 0755 clusterctl /usr/local/bin/clusterctl
```

### [Setup a management cluster 设置管理集群](https://microk8s.io/docs/capi-provision#p-38735-setup-a-management-cluster)

The management cluster hosts the CAPI providers. You can use a MicroK8s cluster as a management cluster:
管理集群托管 CAPI 提供程序。您可以将 MicroK8s 集群用作管理集群：

```bash
sudo snap install microk8s --classic
sudo microk8s status --wait-ready
mkdir -p ~/.kube/
sudo microk8s.config  > ~/.kube/config
sudo microk8s enable dns
```

When setting up the management cluster place its kubeconfig under `~/.kube/config` so other tools such as `clusterctl` can discover and interact with it.
在设置管理集群时，将其 kubeconfig 放在 `~/.kube/config` 下，以便其他工具（如 `clusterctl`）可以发现它并与之交互。

### [Prepare the infrastructure provider 准备基础设施提供商](https://microk8s.io/docs/capi-provision#p-38735-prepare-the-infrastructure-provider)

Before generating a cluster, you have to configure the infrastructure  provider. Each such provider has its own prerequisites. Please, follow
在生成集群之前，您必须配置基础设施提供商。每个此类提供商都有自己的先决条件。请关注
 the [Cluster API instructions](https://cluster-api.sigs.k8s.io/user/quick-start.html#initialization-for-common-providers) on the additional infrastructure specific configuration.
有关其他基础设施特定配置的 [Cluster API 说明](https://cluster-api.sigs.k8s.io/user/quick-start.html#initialization-for-common-providers)。

#### Example using AWS 使用 AWS 的示例

The AWS infrastructure provider requires the `clusterawsadm` tool to be installed:
AWS 基础设施提供商需要安装 `clusterawsadm` 工具：

```bash
curl -L https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v2.0.2/clusterawsadm-linux-amd64 -o clusterawsadm
chmod +x clusterawsadm
sudo mv clusterawsadm /usr/local/bin
```

With `clusterawsadm` you can then bootstrap the AWS environment  that CAPI will use.
然后，使用 `clusterawsadm` 可以引导 CAPI 将使用的 AWS 环境。

Start by  setting up environment variables defining the AWS account to use, if these are not already defined
首先设置定义要使用的 AWS 账户的环境变量（如果尚未定义）

```bash
export AWS_REGION=<your-region-eg-us-east-1>
export AWS_ACCESS_KEY_ID=<your-access-key>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
```

If you are using multi-factor authentication, you will also need:
如果您使用的是多重身份验证，则还需要：

```bash
export AWS_SESSION_TOKEN=<session-token> # If you are using Multi-Factor Auth.
```

The `clusterawsadm` uses these details to create a CloudFormation stack in your AWS account
`clusterawsadm` 使用这些详细信息在您的 AWS 账户中创建 CloudFormation 堆栈
 with the correct IAM resources:
替换为正确的 IAM 资源：

```bash
clusterawsadm bootstrap iam create-cloudformation-stack
```

The credentials should also be encoded and stored as a kubernetes secret
这些凭证也应该被编码并存储为 kubernetes secret

```bash
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
```

### [Initialse the management cluster 初始化管理集群](https://microk8s.io/docs/capi-provision#p-38735-initialse-the-management-cluster)

To initialise the management cluster with the latest released version of the providers and the infrastructure of your choice:
要使用最新发布的提供程序版本和您选择的基础设施初始化管理集群：

```auto
clusterctl init --bootstrap microk8s --control-plane microk8s -i <infra-provider-of-choice>
```

### [Generate a cluster spec manifest 生成集群规范清单](https://microk8s.io/docs/capi-provision#p-38735-generate-a-cluster-spec-manifest)

As soon as the bootstrap and control-plane controllers are up and running  you can apply the cluster manifests with the specifications of the  cluster you want to provision.
一旦引导和控制平面控制器启动并运行，您就可以将集群清单与要预置的集群的规范一起应用。

For MicroK8s there are example manifests in the [bootstrap provider examples](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s/tree/main/templates) directory on GitHub.
对于 MicroK8s，GitHub 上的 [bootstrap provider examples](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s/tree/main/templates) 目录中有示例清单。

Alternatively, you can generate a cluster manifest for a selected set of commonly used infrastructures via templates provided by the MicroK8s team.
或者，您可以通过 MicroK8s 团队提供的模板为一组选定的常用基础设施生成集群清单。
 Visit the usage [instructions](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s#usage) for a list of different providers and their deployment.
有关不同提供商及其部署的列表，请访问使用[说明](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s#usage)。

Make sure you have initialised the desired infrastructure provider and fetch the MicroK8s bootstrap provider repository:
确保您已初始化所需的基础设施提供商并获取 MicroK8s 引导提供程序存储库：

```bash
git clone https://github.com/canonical/cluster-api-bootstrap-provider-microk8s
```

Review list of variables needed for the cluster template:
查看集群模板所需的变量列表：

```bash
cd cluster-api-bootstrap-provider-microk8s
clusterctl generate cluster microk8s-<cloud_provider> --from ./templates/cluster-template-<cloud_provider>.yaml --list-variables
```

Set the respective environment variables by editing the rc file as needed  before sourcing it. Then generate the cluster manifest:
在获取 rc 文件之前，根据需要编辑 rc 文件，以设置相应的环境变量。然后生成集群清单：

```bash
source ./templates/cluster-template-<cloud_provider>.rc
clusterctl generate cluster microk8s-<cloud_provider> --from ./templates/cluster-template-<cloud_proider>.yaml > cluster.yaml
```

Each provisioned node is associated with a `MicroK8sConfig`, through which you can set the cluster’s properties.
每个预置节点都与一个 `MicroK8sConfig 相关联，通过该 MicroK8sConfig` 您可以设置集群的属性。
 Please, review the available options in the [respective definitions](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s/blob/main/apis/v1beta1/microk8sconfig_types.go#L44) file and
请查看[相应定义](https://github.com/canonical/cluster-api-bootstrap-provider-microk8s/blob/main/apis/v1beta1/microk8sconfig_types.go#L44)文件中的可用选项，并且
 edit the cluster manifest (`cluster.yaml` above) to match your needs.
编辑集群清单（上面的 `cluster.yaml`）以满足您的需求。
 Note that the configuration structure followed is similar to that of kubeadm - in the `MicroK8sConfig` you will find a `ClusterConfiguration` and an `InitConfiguration` section.
请注意，遵循的配置结构类似于 kubeadm 的配置结构 - 在 `MicroK8sConfig` 中，你会找到一个 `ClusterConfiguration` 和一个 `InitConfiguration` 部分。

### [Deploy the cluster 部署集群](https://microk8s.io/docs/capi-provision#p-38735-deploy-the-cluster)

Deploying the cluster is achieved by running:
部署集群是通过运行以下命令来实现的：

```auto
sudo microk8s kubectl apply -f cluster.yaml
```

To see the deployed machines:
要查看已部署的计算机，请执行以下作：

```auto
sudo microk8s kubectl get machine 
```

After the first control plane node is provisioned you are able to get the kubeconfig of the workload cluster:
在配置第一个 control plane 节点后，您可以获取工作负载集群的 kubeconfig：

```auto
clusterctl get kubeconfig <provisioned-cluster> > kubeconfig
```

You can then see the workload nodes using:
然后，您可以使用以下方法查看工作负载节点：

```auto
KUBECONFIG=./kubeconfig kubectl get node
```

### [Delete the cluster 删除集群](https://microk8s.io/docs/capi-provision#p-38735-delete-the-cluster)

To get the list of provisioned clusters:
要获取预置集群的列表，请执行以下作：

```auto
sudo microk8s kubectl get clusters
```

To delete one 删除一个

```auto
microk8s kubectl delete cluster <provisioned-cluster>
```

# MicroK8s CAPI - management cluster ops MicroK8s CAPI - 管理集群作

In this HowTo we build on the [Cluster Provisioning with CAPI](https://microk8s.io/docs/capi-provision) guide to demonstrate two
在本作文档中，我们将以[使用 CAPI 进行集群配置](https://microk8s.io/docs/capi-provision)指南为基础，演示两个
 useful operations in the lifecycle of the CAPI management cluster:
CAPI 管理集群生命周期中的有用作：

- the upgrade of providers 提供商的升级
- the migration of the management workloads to another cluster
  将管理工作负载迁移到另一个集群

# Upgrading the providers of a management cluster 升级管理集群的提供者

#### Prerequisites 先决条件

We assume we already have a management cluster and the infrastructure provider configured as described in the [Cluster Provisioning with CAPI](https://microk8s.io/docs/capi-provision) guide. The selected infrastructure provider is AWS. We have not yet called `clusterctl init` to initialise the cluster.
我们假设我们已经有一个管理集群和基础设施提供商，如[使用 CAPI 进行集群配置](https://microk8s.io/docs/capi-provision)指南中所述。所选的基础设施提供商是 AWS。我们还没有调用 `clusterctl init` 来初始化集群。

#### Initialise the cluster 初始化集群

To demonstrate the steps of upgrading the management cluster, we will  begin by initialising an old version of the MicroK8s CAPI providers.
为了演示升级管理集群的步骤，我们将首先初始化旧版本的 MicroK8s CAPI 提供程序。

To set the version of the providers to be installed we use the following notation:
要设置要安装的提供程序的版本，我们使用以下表示法：

```auto
clusterctl init --bootstrap microk8s:v0.4.0 --control-plane microk8s:v0.4.0 --infrastructure aws
```

#### Check for updates 检查更新

With clusterctl we can check if there are any new versions on the running providers:
使用 clusterctl 我们可以检查正在运行的提供程序上是否有任何新版本：

```auto
clusterctl upgrade plan
```

The output shows the existing version of each provider as well as the version that we can upgrade into:
输出显示每个提供程序的现有版本以及我们可以升级到的版本：

```auto
NAME                     NAMESPACE                            TYPE                     CURRENT VERSION   NEXT VERSION
bootstrap-microk8s       capi-microk8s-bootstrap-system       BootstrapProvider        v0.4.0            v0.5.0
control-plane-microk8s   capi-microk8s-control-plane-system   ControlPlaneProvider     v0.4.0            v0.5.0
cluster-api              capi-system                          CoreProvider             v1.3.5            Already up to date
infrastructure-aws       capa-system                          InfrastructureProvider   v2.0.2            Already up to date
```

#### Trigger providers upgrade 触发器提供程序升级

To apply the upgrade plan recommended by `clusterctl upgrade plan` simply:
要应用 `clusterctl upgrade plan` 推荐的升级计划，只需：

```auto
clusterctl upgrade apply --contract v1beta1
```

To upgrade each provider one by one, issue:
要逐个升级每个提供程序，请发出：

```auto
clusterctl upgrade apply --bootstrap capi-microk8s-bootstrap-system/microk8s:v0.5.0
clusterctl upgrade apply --control-plane capi-microk8s-control-plane-system/microk8s:v0.5.0
```

# Migrate the managment cluster 迁移管理集群

Management cluster migration is a really powerful operation in the cluster’s lifecycle as it allows admins
管理集群迁移是集群生命周期中一项非常强大的作，因为它允许管理员
 to move the management cluster in a more reliable substrate or perform maintenance tasks without disruptions.
将管理集群移动到更可靠的 substrate 中，或执行维护任务而不会中断。

#### Prerequisites 先决条件

In the [Cluster Provisioning with CAPI](https://microk8s.io/docs/capi-provision) guide we showed how to provision a workloads cluster. Here, we start  from the point where the workloads cluster is available and we will  migrate the management cluster to the one cluster we just provisioned.
在[使用 CAPI 进行集群配置](https://microk8s.io/docs/capi-provision)指南中，我们展示了如何配置工作负载集群。在这里，我们从工作负载集群可用的点开始，我们将管理集群迁移到我们刚刚配置的一个集群。

#### Install the same set of providers to the provisioned cluster 将同一组提供程序安装到预置的集群

Before migrating a cluster, we must make sure that both the target and source  management clusters run the same version of providers (infrastructure,  bootstrap, control plane). To do so `clusterctl init` should be called against he target cluster:
在迁移集群之前，我们必须确保目标集群和源管理集群运行相同版本的提供程序（基础设施、引导、控制平面）。为此，应该对目标集群调用 `clusterctl init`：

```auto
clusterctl get kubeconfig <provisioned-cluster> > targetconfig
clusterctl init --kubeconfig=$PWD/targetconfig --bootstrap microk8s --control-plane microk8s --infrastructure aws
```

#### Move the cluster 移动集群

Simply call: 只需调用：

```auto
clusterctl move --to-kubeconfig=$PWD/targetconfig
```

# Links: 链接：

Provider upgrade: [upgrade - The Cluster API Book](https://cluster-api.sigs.k8s.io/clusterctl/commands/upgrade.html)
提供者升级：[upgrade - 集群 API 手册](https://cluster-api.sigs.k8s.io/clusterctl/commands/upgrade.html)
 Cluster API move: [move - The Cluster API Book](https://cluster-api.sigs.k8s.io/clusterctl/commands/move.html)
Cluster API move： [move - The Cluster API Book](https://cluster-api.sigs.k8s.io/clusterctl/commands/move.html)

# MicroK8s CAPI - cluster upgrades MicroK8s CAPI - 集群升级

In this guide, we will provide a comprehensive overview of upgrading a  MicroK8s cluster that is managed by Cluster API. We will demonstrate how to upgrade a cluster from one minor version to another, and we will  also cover how to pin a cluster to a specific patch release using a  snapstore proxy.
在本指南中，我们将全面概述如何升级由 Cluster API 管理的 MicroK8s 集群。我们将演示如何将集群从一个次要版本升级到另一个次要版本，还将介绍如何使用 Snapstore 代理将集群固定到特定的补丁版本。

# Minor version upgrade 次要版本升级

Kubernetes is an ever-evolving platform that ships one minor release every  approximately 4 months. With each new release comes new features, bug  fixes, and performance improvements, making upgrading a Kubernetes  cluster a common and important task. In the [Cluster Provisioning with CAPI](https://microk8s.io/docs/capi-provision) guide, we provide a detailed walkthrough of how to generate a cluster manifest. This manifest includes two main sections: `MicroK8sControlPlane` and `MachineDeployment`. The `MicroK8sControlPlane` section specifies the version of Kubernetes that the control plane is running, while the `MachineDeployment` section specifies the version of Kubernetes that the worker nodes are  running. In the snippets that follow, we provide an example of how to  set the Kubernetes version to 1.25.0 in both the `MicroK8sControlPlane` and `MachineDeployment` sections of the cluster manifest:
Kubernetes 是一个不断发展的平台，大约每 4 个月发布一个次要版本。每个新版本都会带来新功能、错误修复和性能改进，这使得升级 Kubernetes 集群成为一项常见且重要的任务。在[使用 CAPI 进行集群配置](https://microk8s.io/docs/capi-provision)指南中，我们提供了有关如何生成集群清单的详细演练。此清单包括两个主要部分：`MicroK8sControlPlane` 和 `MachineDeployment`。`MicroK8sControlPlane` 部分指定控制平面正在运行的 Kubernetes 版本，而 `MachineDeployment` 部分指定 Worker 节点正在运行的 Kubernetes 版本。在下面的代码片段中，我们提供了一个示例，说明如何在集群清单的 `MicroK8sControlPlane` 和 `MachineDeployment` 部分中将 Kubernetes 版本设置为 1.25.0：

```yaml
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: MicroK8sControlPlane
metadata:
  name: test-ci-cluster-control-plane
  namespace: default
spec:
  controlPlaneConfig:
    clusterConfiguration:
      portCompatibilityRemap: true
    initConfiguration:
      IPinIP: true
      addons:
      - dns
      joinTokenTTLInSecs: 900000
  machineTemplate:
    infrastructureTemplate:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AWSMachineTemplate
      name: test-ci-cluster-control-plane
  replicas: 1
  version: v1.25.0
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  name: test-ci-cluster-md-0
  namespace: default
spec:
  clusterName: test-ci-cluster
  replicas: 1
  selector:
    matchLabels: null
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: MicroK8sConfigTemplate
          name: test-ci-cluster-md-0
      clusterName: test-ci-cluster
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta
        kind: AWSMachineTemplate
        name: test-ci-cluster-md-0
      version: 1.25.0
```

To update a cluster to a new version ammend the cluster manifest with the desired version and re-apply the manifest:
要将集群更新到新版本，请使用所需版本修改集群清单，然后重新应用清单：

```auto
sudo microk8s kubectl apply cluster.yaml
```

When upgrading a MicroK8s cluster managed by CAPI, the bootstrap and  control-plane providers will automatically detect the new version and  initiate the update process.
升级由 CAPI 管理的 MicroK8s 集群时，引导和控制平面提供程序将自动检测新版本并启动更新过程。
 Single-node control plane clusters only support updating in-place, with  minimal downtime for kube-apiserver (during the service restart).  In-place upgrades are handled by spawning a pod in the cluster. This pod might have to be manually deleted at the end.
单节点 control plane 集群仅支持就地更新，kube-apiserver 的停机时间最短（在服务重启期间）。就地升级是通过在集群中生成 Pod 来处理的。最后，可能需要手动删除此 Pod。
 For worker nodes, the upgrade strategy is a rolling one. The CAPI  provider spawns a node with the new version, selects one of the old  nodes, drains it, and then removes it from the cluster. This process is  repeated until all worker nodes have been replaced by nodes running the  new version. This rolling upgrade strategy is also the default strategy  for upgrading control-planes with more than 3 nodes that operate in HA  mode. In HA clusters, rolling upgrades of the control-plane nodes do not cause any service disruption. However, in non-HA clusters, a rolling  upgrade strategy will result in downtime, and an in-place strategy is  followed instead. In an in-place upgrade, the CAPI provider will cycle  through all control-plane nodes and simply refresh the snap to the new  version. To try the in-place upgrade in an HA cluster, you can set the  respective flag in the `MicroK8sControlPlane` section of the cluster manifest:
对于 worker 节点，升级策略是滚动策略。CAPI  提供程序使用新版本生成一个节点，选择一个旧节点，将其耗尽，然后将其从集群中删除。重复此过程，直到所有 worker  节点都被运行新版本的节点替换。此滚动升级策略也是升级具有 3 个以上在 HA 模式下运行的节点的 control-plane 的默认策略。在  HA 集群中，控制平面节点的滚动升级不会导致任何服务中断。但是，在非 HA  集群中，滚动升级策略将导致停机，而是遵循就地策略。在就地升级中，CAPI 提供程序将循环访问所有控制平面节点，并简单地刷新到新版本。要在 HA  集群中尝试就地升级，您可以在集群清单的 `MicroK8sControlPlane` 部分中设置相应的标志：

```yaml
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: MicroK8sControlPlane
metadata:
  name: test-ci-cluster-control-plane
  namespace: default
spec:
  controlPlaneConfig:
    clusterConfiguration:
      portCompatibilityRemap: true
    initConfiguration:
      IPinIP: true
      addons:
      - dns
      joinTokenTTLInSecs: 900000
  machineTemplate:
    infrastructureTemplate:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AWSMachineTemplate
      name: test-ci-cluster-control-plane
  replicas: 1
  version: v1.25.0
  upgradeStrategy: "InPlaceUpgrade"
```

# Patch releases 补丁版本

By default, MicroK8s will automatically update to the latest patch version within the track it follows. This means that the patch number specified in the cluster manifest is ignored. For example, if the `version` field in the manifest specifies `v1.25.0`, the trailing patch number `0` is ignored, and if the snapstore holds the `v1.25.4` version in the `1.25` track, then that is the version that will be used. However, there may  be cases where you want to pin the deployment to a specific version. In  such cases, you will need to set up a snapstore proxy following the [official instructions](https://docs.ubuntu.com/snap-store-proxy/en/install)s. If you are using an Ubuntu machine, setting up a snapstore proxy is done with:
默认情况下，MicroK8s 将自动更新到它遵循的轨道中的最新补丁版本。这意味着将忽略集群清单中指定的补丁编号。例如，如果清单中的 `version` 字段指定 `v1.25.0`，则尾部补丁编号 `0` 将被忽略，如果 snapstore 在 `1.25` 轨道中包含 `v1.25.4` 版本，则将使用该版本。但是，在某些情况下，您可能希望将部署固定到特定版本。在这种情况下，您需要按照[官方说明](https://docs.ubuntu.com/snap-store-proxy/en/install)设置 snapstore 代理。如果您使用的是 Ubuntu 计算机，则通过以下方式设置 snapstore 代理：

```auto
sudo snap install snap-store-proxy
sudo apt install postgresql
```

Get the IP or host endpoint and put it in:
获取 IP 或主机终端节点并将其放入：

```auto
sudo snap-proxy config proxy.domain=<IP or host domain>
```

Configure postgress with:
使用以下命令配置 postgress：

```auto
$ cat ./ps.sql 
CREATE ROLE "snapproxy-user" LOGIN CREATEROLE PASSWORD 'snapproxy-password';

CREATE DATABASE "snapproxy-db" OWNER "snapproxy-user";

\connect "snapproxy-db"

CREATE EXTENSION "btree_gist";
```

and apply the configuration:
并应用配置：

```auto
sudo -u postgres psql < ps.sql 
sudo snap-proxy config proxy.db.connection="postgresql://snapproxy-user@localhost:5432/snapproxy-db"
```

Register the proxy: 注册代理：

```auto
sudo snap-proxy register
```

Get the store proxy ID and endpoint with:
使用以下方法获取 store 代理 ID 和终端节点：

```auto
snap-proxy status
```

The snapstore proxy domain and the store ID need to set on the cluster spec manifest. In the example that follows we have setup a snapstore proxy  on an AWS VM instance `ec2-3-231-147-126.compute-1.amazonaws.com`:
需要在集群规范清单上设置 snapstore 代理域和存储 ID。在下面的示例中，我们在 AWS VM 实例 `ec2-3-231-147-126.compute-1.amazonaws.com` 上设置了一个 snapstore 代理：

```yaml
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: MicroK8sControlPlane
metadata:
  name: test-ci-cluster-control-plane
  namespace: default
spec:
  controlPlaneConfig:
    clusterConfiguration:
      portCompatibilityRemap: true
    initConfiguration:
      IPinIP: true
      snapstoreProxyDomain: "ec2-3-231-147-126.compute-1.amazonaws.com"
      snapstoreProxyId: "zIozFdcA7qd1eDWh3Fzfdsadsadsa"
      addons:
      - dns
      - ingress
      joinTokenTTLInSecs: 900000
  machineTemplate:
    infrastructureTemplate:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AWSMachineTemplate
      name: test-ci-cluster-control-plane
  replicas: 1
  version: v1.25.0
```

and 和

```yaml
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: MicroK8sConfigTemplate
metadata:
  name: test-ci-cluster-md-0
  namespace: default
spec:
  template:
    spec:
      clusterConfiguration:
        portCompatibilityRemap: true
      initConfiguration:
        snapstoreProxyDomain: "ec2-3-231-147-126.compute-1.amazonaws.com"
        snapstoreProxyId: "zIozFdcA7qd1eDWh3Fzfdsadsadsa"
```

The snapstore proxy allows for snap revision overrides. Please visit the [snapstore proxy documentation](https://docs.ubuntu.com/snap-store-proxy/en/) pages for the full list of offered features.
snapstore 代理允许 snap 修订覆盖。请访问 [snapstore 代理文档](https://docs.ubuntu.com/snap-store-proxy/en/)页面，了解所提供功能的完整列表。