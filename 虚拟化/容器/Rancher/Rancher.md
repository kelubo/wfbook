# Rancher

[TOC]

## 概述

Rancher 是一个 Kubernetes 管理工具，让你能在任何地方和任何提供商上部署和运行集群。

Rancher 可以创建来自 Kubernetes 托管服务提供商的集群，创建节点并安装 Kubernetes，或者导入在任何地方运行的现有 Kubernetes 集群。

Rancher 基于 Kubernetes 添加了新的功能，包括统一所有集群的身份验证和 RBAC，让系统管理员从一个位置控制全部集群的访问。

此外，Rancher 可以为集群和资源提供更精细的监控和告警，将日志发送到外部提供商，并通过应用商店（Application Catalog）直接集成  Helm。如果你拥有外部 CI/CD 系统，你可以将其与 Rancher 对接。没有的话，你也可以使用 Rancher 提供的 Fleet  自动部署和升级工作负载。

Rancher 是一个 *全栈式* 的 Kubernetes 容器管理平台，为你提供在任何地方都能成功运行 Kubernetes 的工具。

# 概述

Rancher 是一个为使用容器的公司打造的容器管理平台。Rancher 使得开发者可以随处运行 Kubernetes（Run Kubernetes Everywhere），满足 IT 需求规范，赋能 DevOps 团队。

## Run Kubernetes Everywhere

Kubernetes 已经成为容器编排标准。现在，大多数云和虚拟化提供商都提供容器编排服务。Rancher 用户可以选择使用 Rancher Kubernetes  Engine（RKE）或云 Kubernetes 服务（例如 GKE、AKS 和 EKS）创建 Kubernetes  集群，还可以导入和管理使用任何 Kubernetes 发行版或安装程序创建的现有 Kubernetes 集群。

## 满足 IT 需求规范

Rancher 支持对其控制的所有 Kubernetes 集群进行集中认证、访问控制和监控。例如，你可以：

- 使用你的 Active Directory 凭证访问由云提供商（例如 GKE）托管的 Kubernetes 集群。
- 设置所有用户、组、项目、集群和云服务的权限控制策略和安全策略。
- 一站式查看 Kubernetes 集群的运行状况和容量。

## 赋能 DevOps 团队

Rancher 为 DevOps 工程师提供简单直接的用户界面，以管理其应用负载。用户不需要对 Kubernetes 有非常深入的了解，即可使用  Rancher。Rancher 应用商店包含一套实用的 DevOps 开发工具。Rancher  获得了多种云原生生态系统产品的认证，包括安全工具、监控系统、容器镜像仓库、存储和网络驱动等。

下图讲述了 Rancher 在 IT 管理团队和 DevOps 开发团队之间扮演的角色。DevOps 团队把他们的应用部署在他们选择的公有云或私有云上。IT 管理员负责查看并管理用户、集群、云服务的权限。

![平台](https://ranchermanager.docs.rancher.com/zh/assets/images/platform-9c0c4130a7a0828898dbc7af56f76df7.png)

## Rancher API Server 的功能

Rancher API Server 是基于嵌入式 Kubernetes API Server 和 etcd 数据库建立的，它提供了以下功能：

### 授权和基于角色的权限控制（RBAC）

- **用户管理**：Rancher API Server 除了管理本地用户，还[管理用户用来访问外部服务所需的认证信息](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config)，如登录 Active Directory 和 GitHub 所需的账号密码。
- **授权**：Rancher API Server 可以管理[访问控制策略](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/manage-role-based-access-control-rbac)和[安全策略](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/create-pod-security-policies)。

### 使用 Kubernetes 的功能

- **配置 Kubernetes 集群**：Rancher API Server 可以在已有节点上[配置 Kubernetes](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup)，或进行 [Kubernetes 版本升级](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/upgrade-and-roll-back-kubernetes)。
- **管理应用商店**：Rancher 支持使用 [Helm Chart 应用商店](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/helm-charts-in-rancher)实现轻松重复部署应用。
- **管理项目**：项目由集群中多个命名空间和访问控制策略组成，是 Rancher 中的一个概念，Kubernetes 中并没有这个概念。你可以使用项目实现以组为单位，管理多个命名空间，并进行 Kubernetes 相关操作。Rancher UI 提供用于[项目管理](https://ranchermanager.docs.rancher.com/zh/how-to-guides/advanced-user-guides/manage-projects)和[项目内应用管理](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-resources-setup)的功能。
- **Fleet 持续交付**：在 Rancher 中，你可以使用 [Fleet 持续交付](https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/fleet)将应用程序从 Git 仓库部署到目标下游 Kubernetes 集群，无需任何手动操作。
- **Istio**：[Rancher 与 Istio 集成](https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/istio)，使得管理员或集群所有者可以将 Istio 交给开发者，然后开发者使用 Istio 执行安全策略，排查问题，或为蓝绿部署，金丝雀部署，和 A/B 测试进行流量管理。

### 配置云基础设施

- **同步节点信息**：Rancher API Server 可以同步所有集群中全部[节点](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/nodes-and-node-pools)的信息。
- **配置云基础设施**：如果你为 Rancher 配置了云提供商，Rancher 可以在云端动态配置[新节点](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider)和[持久化存储](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/create-kubernetes-persistent-storage)。

### 查看集群信息

- **日志管理**：Rancher 可以与多种 Kubernetes 集群之外的主流日志管理工具集成。
- **监控**：你可以使用 Rancher，通过业界领先并开源的 Prometheus 来监控集群节点、Kubernetes 组件和软件部署的状态和进程。
- **告警**：为了保证集群和应用的正常运行，提高公司的生产效率，你需要随时了解集群和项目的计划内和非计划事件。

## 使用 Rancher 编辑下游集群

对于已有集群而言，可提供的选项和设置取决于你配置集群的方法。例如，只有[通过 RKE 启动](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/launch-kubernetes-with-rancher)的集群才有可编辑的**集群选项**。

使用 Rancher 创建集群后，集群管理员可以管理集群成员，管理节点池，或进行[其他操作](https://ranchermanager.docs.rancher.com/zh/reference-guides/cluster-configuration)。

下表总结了每一种类型的集群和对应的可编辑的选项和设置：

| 操作                                                         | Rancher 启动的 Kubernetes 集群 | EKS、GKE 和 AKS 集群1 | 其他托管的 Kubernetes 集群 | 非 EKS 或 GKE 注册集群 |
| ------------------------------------------------------------ | ------------------------------ | --------------------- | -------------------------- | ---------------------- |
| [使用 kubectl 和 kubeconfig 文件来访问集群](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/access-clusters/use-kubectl-and-kubeconfig) | ✓                              | ✓                     | ✓                          | ✓                      |
| [管理集群成员](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/access-clusters/add-users-to-clusters) | ✓                              | ✓                     | ✓                          | ✓                      |
| [编辑和升级集群](https://ranchermanager.docs.rancher.com/zh/reference-guides/cluster-configuration) | ✓                              | ✓                     | ✓                          | ✓2                     |
| [管理节点](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/nodes-and-node-pools) | ✓                              | ✓                     | ✓                          | ✓3                     |
| [管理持久卷和存储类](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/create-kubernetes-persistent-storage) | ✓                              | ✓                     | ✓                          | ✓                      |
| [管理项目、命名空间和工作负载](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/projects-and-namespaces) | ✓                              | ✓                     | ✓                          | ✓                      |
| [使用应用目录](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/helm-charts-in-rancher) | ✓                              | ✓                     | ✓                          | ✓                      |
| 配置工具（[Alerts、Notifiers、Monitoring](https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/monitoring-and-alerting)、[Logging](https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/logging) 和 [Istio](https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/istio)） | ✓                              | ✓                     | ✓                          | ✓                      |
| [运行安全扫描](https://ranchermanager.docs.rancher.com/zh/how-to-guides/advanced-user-guides/cis-scan-guides) | ✓                              | ✓                     | ✓                          | ✓                      |
| [轮换证书](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/rotate-certificates) | ✓                              | ✓                     |                            |                        |
| [备份](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher-launched-kubernetes-clusters)和[恢复](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/restore-rancher-launched-kubernetes-clusters-from-backup) Rancher 启动的集群 | ✓                              | ✓                     |                            | ✓4                     |
| [在 Rancher 无法访问集群时清理 Kubernetes 组件](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/clean-cluster-nodes) | ✓                              |                       |                            |                        |
| [配置 Pod 安全策略](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/manage-clusters/add-a-pod-security-policy) | ✓                              | ✓                     |                            |                        |

1. 注册的 EKS、GKE 和 AKS 集群与从 Rancher UI 创建的 EKS、GKE 和 AKS 集群的可用选项一致。不同之处是，从 Rancher UI 中删除已注册的集群后，集群不会被销毁。
2. 无法编辑已注册的集群的集群配置选项（[K3s 和 RKE2 集群](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/register-existing-clusters)除外）。
3. Rancher UI 为已注册的集群节点提供了封锁、清空和编辑节点的功能。
4. 对于使用 etcd 作为 controlplane 的注册集群，必须在 Rancher UI 之外手动创建快照以用于备份和恢复。

# Rancher 部署快速入门指南



警告

本章节中提供的指南，旨在帮助你快速启动一个用于 Rancher 的沙盒，以评估 Rancher 是否能满足你的使用需求。快速入门指南不适用于生产环境。如果你需要获取生产环境的操作指导，请参见[安装](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade)。

你可以阅读本章节，以快速开始部署和测试 Rancher 2.x。本章节包含 Rancher 的简单设置和一些常见用例的说明。未来，我们会在本章节中添加更多内容。

我们提供以下快速入门指南：

- [部署 Rancher Server](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager)：使用最方便的方式运行 Rancher。
- [部署工作负载](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-workloads)：部署一个简单的[工作负载](https://kubernetes.io/docs/concepts/workloads/)并公暴露工作负载，以从集群外部访问工作负载。

# 部署 Rancher Server

你可使用以下指南之一，在你选择的提供商中部署和配置 Rancher 和 Kubernetes 集群。

- [AWS](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/aws)（使用 Terraform）
- [AWS Marketplace](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/aws-marketplace)（使用 Amazon EKS）
- [Azure](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/azure)（使用 Terraform）
- [DigitalOcean](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/digitalocean)（使用 Terraform）
- [GCP](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/gcp)（使用 Terraform）
- [Hetzner Cloud](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/hetzner-cloud)（使用 Terraform）
- [Linode](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/linode) (使用 Terraform)
- [Vagrant](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/vagrant)
- [Equinix Metal](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/equinix-metal)
- [Outscale](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/outscale-qs)（使用 Terraform）

如有需要，你可以查看以下指南以了解分步步骤。如果你需要在其他提供商中或本地运行 Rancher，或者你只是想看看它是多么容易上手，你可阅读以下指南：

- [手动安装](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/helm-cli)

# 部署工作负载

这些指南指导你完成一个应用的部署，包括如何将应用暴露在集群之外使用。

- [部署带有 Ingress 的工作负载](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-workloads/workload-ingress)
- [部署带有 NodePort 的工作负载](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-workloads/nodeports)

# 部署带有 Ingress 的工作负载

## 先决条件

你已有一个正在运行的集群，且该集群中有至少一个节点。

## 1. 部署工作负载

你可以开始创建你的第一个 Kubernetes [工作负载](https://kubernetes.io/docs/concepts/workloads/)。工作负载是一个对象，其中包含 pod 以及部署应用所需的其他文件和信息。

在本文的工作负载中，你将部署一个 Rancher Hello-World 应用。

1. 点击 **☰ > 集群管理**。
2. 选择你创建的集群，并点击 **Explore**。
3. 点击**工作负载**。
4. 单击**创建**。
5. 点击 **Deployment**。
6. 为工作负载设置**名称**。
7. 在**容器镜像**字段中，输入 `rancher/hello-world`。注意区分大小写。
8. 在 `Service Type` 点击 **Add Port** 和 `Cluster IP`，并在 **Private Container Port** 字段中输入`80`。你可以将 `Name` 留空或指定名称。通过添加端口，你可以访问集群内外的应用。有关详细信息，请参阅 [Service](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-resources-setup/workloads-and-pods#services)。
9. 单击**创建**。

**结果**：

- 工作负载已部署。此过程可能需要几分钟。
- 当工作负载完成部署后，它的状态会变为 **Active**。你可以从项目的**工作负载**页面查看其状态。

## 2. 通过 Ingress 暴露应用

现在应用已启动并运行，你需要暴露应用以让其他服务连接到它。

1. 点击 **☰ > 集群管理**。
2. 选择你创建的集群，并点击 **Explore**。
3. 点击**服务发现 > Ingresses**。
4. 点击**创建**。
5. 在选择**命名空间**时，你需要选择在创建 deployment 时使用的命名空间。否则，在步骤8中选择**目标服务**时，你的 deployment 会不可用。
6. 输入**名称**，例如 **hello**。
7. 指定**路径**，例如 `/hello`。
8. 在**目标服务**字段的下拉菜单中，选择你为服务设置的名称。
9. 在**端口**字段中的下拉菜单中，选择 `80`。
10. 点击右下角的**创建**。

**结果**：应用分配到了一个 `sslip.io` 地址并暴露。这可能需要一两分钟。

## 查看应用

在 **Deployments** 页面中，找到你 deployment 的 **endpoint** 列，然后单击一个 endpoint。可用的 endpoint 取决于你添加到 deployment 中的端口配置。如果你看不到随机分配端口的  endpoint，请将你在创建 Ingress 时指定的路径尾附到 IP 地址上。例如，如果你的 endpoint 是 `xxx.xxx.xxx.xxx` 或 `https://xxx.xxx.xxx.xxx`，把它修改为 `xxx.xxx.xxx.xxx/hello` 或 `https://xxx.xxx.xxx.xxx/hello`。

应用将在另一个窗口中打开。

### 已完成！

恭喜！你已成功通过 Ingress 部署工作负载。

### 后续操作

使用完沙盒后，你需要清理 Rancher Server 和集群。详情请参见：

- [Amazon AWS：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/aws#销毁环境)
- [DigitalOcean：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/digitalocean#销毁环境)
- [Vagrant：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/vagrant#销毁环境)

# 部署带有 NodePort 的工作负载

## 先决条件

你已有一个正在运行的集群，且该集群中有至少一个节点。

## 1. 部署工作负载

你可以开始创建你的第一个 Kubernetes [工作负载](https://kubernetes.io/docs/concepts/workloads/)。工作负载是一个对象，其中包含 pod 以及部署应用所需的其他文件和信息。

在本文的工作负载中，你将部署一个 Rancher Hello-World 应用。

1. 点击 **☰ > 集群管理**。

2. 在**集群**页面中，进入需要部署工作负载的集群，然后单击 **Explore**。

3. 点击**工作负载**。

4. 单击**创建**。

5. 为工作负载设置**名称**。

6. 在**容器镜像**字段中，输入 `rancher/hello-world`。注意区分大小写。

7. 点击**添加端口**。

8. 在**服务类型**下拉菜单中，确保选择了 **NodePort**。

   ![NodePort 下拉菜单（在每个所选节点处）](data:image/png;base64,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)

9. 在**发布容器端口**字段中，输入端口`80`。

   ![发布容器端口，端口 80 已输入](data:image/png;base64,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)

10. 单击**创建**。

**结果**：

- 工作负载已部署。此过程可能需要几分钟。
- 当工作负载完成部署后，它的状态会变为 **Active**。你可以从项目的**工作负载**页面查看其状态。

## 2. 查看应用

在**工作负载**页面中，点击工作负载下方的链接。如果 deployment 已完成，你的应用会打开。

## 注意事项

如果使用云虚拟机，你可能无法访问运行容器的端口。这种情况下，你可以使用 `Execute Shell` 在本地主机的 SSH 会话中测试 Nginx。如果可用的话，使用工作负载下方的链接中 `:` 后面的端口号。在本例中，端口号为 `31568`。

```html
gettingstarted@rancher:~$ curl http://localhost:31568
<!DOCTYPE html>
<html>
  <head>
    <title>Rancher</title>
    <link rel="icon" href="img/favicon.png">
    <style>
      body {
        background-color: white;
        text-align: center;
        padding: 50px;
        font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
      }
      button {
          background-color: #0075a8;
          border: none;
          color: white;
          padding: 15px 32px;
          text-align: center;
          text-decoration: none;
          display: inline-block;
          font-size: 16px;
      }

      #logo {
        margin-bottom: 40px;
      }
    </style>
  </head>
  <body>
    <img id="logo" src="img/rancher-logo.svg" alt="Rancher logo" width=400 />
    <h1>Hello world!</h1>
    <h3>My hostname is hello-world-66b4b9d88b-78bhx</h3>
    <div id='Services'>
      <h3>k8s services found 2</h3>

      <b>INGRESS_D1E1A394F61C108633C4BD37AEDDE757</b> tcp://10.43.203.31:80<br />

      <b>KUBERNETES</b> tcp://10.43.0.1:443<br />

    </div>
    <br />

    <div id='rancherLinks' class="row social">
      <a class="p-a-xs" href="https://rancher.com/docs"><img src="img/favicon.png" alt="Docs" height="25" width="25"></a>
      <a class="p-a-xs" href="https://slack.rancher.io/"><img src="img/icon-slack.svg" alt="slack" height="25" width="25"></a>
      <a class="p-a-xs" href="https://github.com/rancher/rancher"><img src="img/icon-github.svg" alt="github" height="25" width="25"></a>
      <a class="p-a-xs" href="https://twitter.com/Rancher_Labs"><img src="img/icon-twitter.svg" alt="twitter" height="25" width="25"></a>
      <a class="p-a-xs" href="https://www.facebook.com/rancherlabs/"><img src="img/icon-facebook.svg" alt="facebook" height="25" width="25"></a>
      <a class="p-a-xs" href="https://www.linkedin.com/groups/6977008/profile"><img src="img/icon-linkedin.svg" height="25" alt="linkedin" width="25"></a>
    </div>
    <br />
    <button class='button' onclick='myFunction()'>Show request details</button>
    <div id="reqInfo" style='display:none'>
      <h3>Request info</h3>
      <b>Host:</b> 172.22.101.111:31411 <br />
      <b>Pod:</b> hello-world-66b4b9d88b-78bhx </b><br />

      <b>Accept:</b> [*/*]<br />

      <b>User-Agent:</b> [curl/7.47.0]<br />

    </div>
    <br />
    <script>
      function myFunction() {
          var x = document.getElementById("reqInfo");
          if (x.style.display === "none") {
              x.style.display = "block";
          } else {
              x.style.display = "none";
          }
      }
    </script>
  </body>
</html>
gettingstarted@rancher:~$
```

## 已完成！

恭喜！你已成功通过 NodePort 部署工作负载。

### 后续操作

使用完沙盒后，你需要清理 Rancher Server 和集群。详情请参见：

- [Amazon AWS：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/aws#销毁环境)
- [DigitalOcean：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/digitalocean#销毁环境)
- [Vagrant：销毁环境](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/vagrant#销毁环境)

# 安装/升级 Rancher

本节介绍了 Rancher 各种安装方式以及每个安装方式的优点。

## 名词解释

本章节涉及以下名词：

- **Rancher Server**：用于管理和配置 Kubernetes 集群。你可以通过 Rancher Server 的 UI 与下游 Kubernetes 集群进行交互。Rancher  Management Server 可以安装到任意 Kubernetes 集群上，包括托管的集群，如 Amazon EKS 集群。
- **RKE（Rancher Kubernetes Engine）**：是经过认证的 Kubernetes 发行版，也是用于创建和管理 Kubernetes 集群的 CLI 工具和库。
- **K3s（轻量级 Kubernetes）**：也是经过认证的 Kubernetes 发行版。它比 RKE 更新，更易用且更轻量，其所有组件都在一个小于 100 MB 的二进制文件中。
- **RKE2**：一个完全合规的 Kubernetes 发行版，专注于安全和合规性。

`restrictedAdmin` Helm Chart 选项在 **Rancher Server** 可用。如果该选项设置为 true，初始的 Rancher 用户访问本地 Kubernetes 集群会受到限制，以避免权限升级。详情请参见 [restricted-admin 角色](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/manage-role-based-access-control-rbac/global-permissions#受限管理员)。

## 安装方式概述

Rancher 可以安装在以下主要架构上：

### 使用 Helm CLI 安装的高可用 Kubernetes

我们建议使用 Kubernetes 包管理器 Helm 在专用的 Kubernetes 集群上安装 Rancher。在 RKE 集群中，需要使用三个节点才能实现高可用集群。在 K3s 集群中，只需要两个节点即可。

### 通过 AWS Marketplace 在 EKS 上安装 Rancher

你可以[通过 AWS Marketplace](https://ranchermanager.docs.rancher.com/zh/getting-started/quick-start-guides/deploy-rancher-manager/aws-marketplace) 将 Rancher 安装到 Amazon Elastic Kubernetes Service (EKS) 上。部署的 EKS 集群已生产就绪，并遵循 AWS 最佳实践。

### 单节点 Kubernetes 安装

Rancher 可以安装在单节点 Kubernetes 集群上。但是，在单节点安装的情况下，Rancher Server 没有高可用性。而高可用性对在生产环境中运行 Rancher 非常重要。

但是，如果你想要短期内使用单节点节省资源，同时又保留高可用性迁移路径，那么单节点 Kubernetes 安装也是合适的。你也可以之后向集群中添加节点，获得高可用的 Rancher Server。

### Docker 安装

如果你的目的是测试或演示，你可以使用 Docker 把 Rancher 安装到单个节点中。本地 Kubernetes 集群是安装到单个 Docker 容器中的，而 Rancher 是安装到本地集群中的。

Rancher backup operator 可将 Rancher 从单个 Docker 容器迁移到高可用 Kubernetes 集群上。详情请参见[把 Rancher 迁移到新集群](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/migrate-rancher-to-new-cluster)。

### 其他方式

如果你需要在离线环境中或使用 HTTP 代理安装 Rancher，请参见以下独立的说明文档：

| 网络访问方式     | 基于 Kubernetes 安装（推荐）                                 | 基于 Docker 安装                                             |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 可直接访问互联网 | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster) | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/rancher-on-a-single-node-with-docker) |
| 使用 HTTP 代理   | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/rancher-behind-an-http-proxy) | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/rancher-on-a-single-node-with-docker)及[配置](https://ranchermanager.docs.rancher.com/zh/reference-guides/single-node-rancher-in-docker/http-proxy-configuration) |
| 离线环境         | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/air-gapped-helm-cli-install) | [文档](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/air-gapped-helm-cli-install) |

我们建议在 Kubernetes 集群上安装 Rancher，因为在多节点集群中，Rancher Server 可以实现高可用。高可用配置可以提升 Rancher 访问其管理的下游 Kubernetes 集群的稳定性。

因此，我们建议在生产级别的架构中，设置一个高可用的 Kubernetes 集群，然后在这个集群上安装 Rancher。安装 Rancher 后，你可以使用 Rancher 部署和管理 Kubernetes 集群。

如果你的目的是测试或演示，你可以将 Rancher 安装到单个 Docker 容器中。Docker 安装可以让你实现开箱即用，以使用 Rancher 设置 Kubernetes  集群。Docker 安装主要是用于探索 Rancher Server 的功能，只适用于开发和测试。

[在 Kubernetes 上安装 Rancher 的说明](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)介绍了如何首先使用 K3s 或 RKE 创建和管理 Kubernetes 集群，然后再将 Rancher 安装到该集群上。

如果 Kubernetes 集群中的节点正在运行且满足[节点要求](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements)，你可以使用 Helm 将 Rancher 部署到 Kubernetes 上。Helm 使用 Rancher 的 Helm Chart 在  Kubernetes 集群的每个节点上安装 Rancher 的副本。我们建议使用负载均衡器将流量定向到集群中的每个 Rancher 副本上。

如需进一步了解 Rancher 架构，请参见[架构概述](https://ranchermanager.docs.rancher.com/zh/reference-guides/rancher-manager-architecture)，[生产级别架构推荐](https://ranchermanager.docs.rancher.com/zh/reference-guides/rancher-manager-architecture/architecture-recommendations)或[最佳实践指南](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tips-for-running-rancher)。

## 先决条件

安装 Rancher 之前，请确保你的节点满足所有[安装要求](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements)。

## 架构建议

为了达到最佳性能和安全性，我们建议你为 Rancher Management Server 使用单独的专用 Kubernetes 集群。不建议在此集群上运行用户工作负载。部署 Rancher 后，你可以[创建或导入集群](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup)来运行你的工作负载。

详情请参见[架构推荐](https://ranchermanager.docs.rancher.com/zh/reference-guides/rancher-manager-architecture/architecture-recommendations)。

### 在 Kubernetes 上安装 Rancher 的更多选项

参见 [Helm Chart 选项](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-references/helm-chart-options)以了解在 Kubernetes 集群上安装 Rancher 的其他配置，包括：

- [开启 API 审计日志来记录所有事务](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-references/helm-chart-options#api-审计日志)
- [负载均衡器上的 TLS 终止](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-references/helm-chart-options#外部-tls-终止)
- [自定义 Ingress](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-references/helm-chart-options#自定义-ingress)

在 Rancher 的安装指南中，我们推荐使用 K3s 或 RKE 来配置 Kubernetes 集群，然后再在这个集群中安装  Rancher。K3s 和 RKE 均提供许多配置选项，用于为你的具体环境自定义 Kubernetes 集群。有关选项和功能的完整列表，请参见：

- [RKE 配置选项](https://rancher.com/docs/rke/latest/en/config-options/)
- [K3s 配置选项](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

### 在 Docker 上安装 Rancher 的更多选项

参见 [Docker 安装选项](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/other-installation-methods/rancher-on-a-single-node-with-docker)了解其他配置，包括：

- [开启 API 审计日志来记录所有事务](https://ranchermanager.docs.rancher.com/zh/reference-guides/single-node-rancher-in-docker/advanced-options#api-审计日志)
- [外部负载均衡器](https://ranchermanager.docs.rancher.com/zh/how-to-guides/advanced-user-guides/configure-layer-7-nginx-load-balancer)
- [持久化数据存储](https://ranchermanager.docs.rancher.com/zh/reference-guides/single-node-rancher-in-docker/advanced-options#持久化数据)

# 安装要求

本文描述了对需要安装 Rancher Server 的节点的软件、硬件和网络要求。Rancher Server 可以安装在单个节点或高可用的 Kubernetes 集群上。



重要提示：

如果你需要在 Kubernetes 集群上安装 Rancher，该节点的要求与用于运行应用和服务的[下游集群的节点要求](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/node-requirements-for-rancher-managed-clusters)不同。

Rancher UI 在基于 Firefox 或 Chromium 的浏览器（Chrome、Edge、Opera、Brave）中效果最佳。

查看我们的[最佳实践](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tips-for-running-rancher)页面，获取在生产环境中运行 Rancher Server 的建议。

## Kubernetes 与 Rancher 的兼容性

Rancher 需要安装在支持的 Kubernetes 版本上。请查阅 [Rancher 支持矩阵](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions)，确保你的 Kubernetes 版本受支持。

## 在安全加固的 Kubernetes 集群上安装 Rancher

如果你在安全加固的 Kubernetes 集群上安装 Rancher，请查看[豁免必须的 Rancher 命名空间](https://ranchermanager.docs.rancher.com/zh/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/psa-config-templates#豁免必须的-rancher-命名空间)以了解详细的要求。

## 操作系统和容器运行时要求

所有支持的操作系统都使用 64-bit x86 架构。Rancher 兼容当前所有的主流 Linux 发行版。

[Rancher 支持矩阵](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions)列出了每个 Rancher 版本测试过的操作系统和 Docker 版本。

运行 RKE 集群的节点需要安装 Docker。RKE2 或 K3s 集群不需要它。

请安装 `ntp`（Network Time Protocol），以防止在客户端和服务器之间由于时间不同步造成的证书验证错误。

某些 Linux 发行版的默认防火墙规则可能会阻止 Kubernetes 集群内的通信。从 Kubernetes v1.19 开始，你必须关闭 firewalld，因为它与 Kubernetes 网络插件冲突。

如果你不太想这样做的话，你可以查看[相关问题](https://github.com/rancher/rancher/issues/28840)中的建议。某些用户已能成功[使用 ACCEPT 策略 为 Pod CIDR 创建一个独立的 firewalld 区域](https://github.com/rancher/rancher/issues/28840#issuecomment-787404822)。

如果你需要在 ARM64 上使用 Rancher，请参见[在 ARM64（实验功能）上运行 Rancher](https://ranchermanager.docs.rancher.com/zh/how-to-guides/advanced-user-guides/enable-experimental-features/rancher-on-arm64)。

### RKE2 要求

对于容器运行时，RKE2 附带了自己的 containerd。RKE2 安装不需要 Docker。

如需了解 RKE2 通过了哪些操作系统版本的测试，请参见 [Rancher 支持矩阵](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions)。

### K3s 要求

对于容器运行时，K3s 默认附带了自己的 containerd。你也可以将 K3s 配置为使用已安装的 Docker 运行时。有关在 Docker 中使用 K3s 的更多信息，请参阅 [K3s 文档](https://docs.k3s.io/advanced#using-docker-as-the-container-runtime)。

Rancher 需要安装在支持的 Kubernetes 版本上。如需了解你使用的 Rancher 版本支持哪些 Kubernetes 版本，请参见 [Rancher 支持矩阵](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions)。如需指定 K3s 版本，在运行 K3s 安装脚本时，使用 `INSTALL_K3S_VERSION` 环境变量。

如果你使用 **Raspbian Buster** 在 K3s 集群上安装 Rancher，请按照[这些步骤](https://rancher.com/docs/k3s/latest/en/advanced/#enabling-legacy-iptables-on-raspbian-buster)切换到旧版 iptables。

如果你使用 Alpine Linux 的 K3s 集群上安装 Rancher，请按照[这些步骤](https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-alpine-linux-setup)进行其他设置。

### RKE 要求

RKE 需要 Docker 容器运行时。支持的 Docker 版本请参见 [Rancher 支持矩阵](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions)

有关详细信息，请参阅[安装 Docker](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements/install-docker)。

## 硬件要求

本节描述安装 Rancher Server 的节点的 CPU、内存和磁盘要求。硬件要求根据你的 Rancher 部署规模而定。

### 实际考虑

Rancher 的硬件占用空间取决于许多因素，包括：

- 托管的基础设施规模 (例如： 节点数量，集群数量)。
- 所需访问控制规则的复杂性（例如：RoleBinding 对象计数）。
- 工作负载数量 (例如： Kubernetes 部署，Fleet 部署)。
- 使用模式 (例如：主动使用的功能集合，使用频率，并发用户数量).

由于存在许多可能随时间变化的影响因素，因此此处列出的要求为适合大多数用例的起点。 然而，你的用例可能有不同的要求。 若你需要对于特定场景的咨询，请[联系 Rancher](https://rancher.com/contact/) 以获得进一步指导。

特别指出，本页面中的要求基于以下假设的环境提出，包括：

- 每种类型的 Kubernetes 资源数量小于 60,000 个。
- 每个节点最多 120 个 Pod。
- 上游（本地）集群中最多 200 个 CRD。
- 下游集群中最多 100 个 CRD。
- 最多 50 个 Fleet 部署。

更多的数量也是能够达到的，但需要更高的硬件要求。 如果你有超过 20,000 个相同类型的资源，通过 Rancher UI 加载整个列表的时间可能需要几秒钟。



Evolution:

Rancher 的代码库不断发展，用例不断变化，Rancher 积累的经验也在不断增长。

随着指导方针的准确性不断的提高并且变得更加具体，硬件要求也会发生变化。

如果你发现你的 Rancher 部署不再符合列出的建议，请[联系 Rancher](https://rancher.com/contact/) 进行重新评估。

### RKE2 Kubernetes

下面的表格列出了[上游集群](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)中每个节点最小的 CPU 和内存要求。

请注意，生产环境下的高可用安装最少需要 3 个节点。

| 部署规模 | 最大集群数量 | 最大节点数量 | vCPUs | 内存  |
| -------- | ------------ | ------------ | ----- | ----- |
| 小       | 150          | 1500         | 4     | 16 GB |
| 中       | 300          | 3000         | 8     | 32 GB |
| 大 (*)   | 500          | 5000         | 16    | 64 GB |
| 更大 (†) | (†)          | (†)          | (†)   | (†)   |

(*)： 大规模的部署需要你[遵循最佳实践](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tuning-and-best-practices-for-rancher-at-scale)以获得足够的性能。

(†)： 通过特别的硬件建议和调整能够实现更大的部署规模。 你可以[联系 Rancher](https://rancher.com/contact/) 进行定制评估。

有关 RKE2 一般要求的更多详细信息，请参见 [RKE2 文档](https://docs.rke2.io/install/requirements)。

### K3s Kubernetes

下面的表格列出了[上游集群](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)中每个节点最小的 CPU 和内存要求。

请注意，生产环境下的高可用安装最少需要 3 个节点。

| 部署规模  | 最大集群数量 | 最大节点数量 | vCPUs | 内存  | 外部数据库(*)              |
| --------- | ------------ | ------------ | ----- | ----- | -------------------------- |
| Small     | 150          | 1500         | 4     | 16 GB | 2 vCPUs, 8 GB + 1000 IOPS  |
| Medium    | 300          | 3000         | 8     | 32 GB | 4 vCPUs, 16 GB + 2000 IOPS |
| Large (†) | 500          | 5000         | 16    | 64 GB | 8 vCPUs, 32 GB + 4000 IOPS |

(*)：外部数据库是指将 K3s 集群数据存储在[专用的外部主机](https://docs.k3s.io/datastore)上。 这是可选的。 具体要求取决于使用的外部数据库。

(†)：大规模的部署需要你[遵循最佳实践](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tuning-and-best-practices-for-rancher-at-scale)以获得足够的性能。

有关 K3s 一般要求的更多详细信息，请参见 [K3s 文档](https://docs.k3s.io/installation/requirements)。

### 托管 Kubernetes

下面的表格列出了[上游集群](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)中每个节点最小的 CPU 和内存要求。

请注意，生产环境下的高可用安装最少需要 3 个节点。

这些要求适用于托管 Kubernetes 集群，例如 Amazon Elastic Kubernetes Service (EKS)、Azure  Kubernetes Service (AKS) 或 Google Kubernetes Engine (GKE)。 它们不适用于  Rancher SaaS 解决方案，例如 [Rancher Prime Hosted](https://www.rancher.com/products/rancher)。

| 部署规模 | 最大集群数量 | 最大节点数量 | vCPUs | 内存  |
| -------- | ------------ | ------------ | ----- | ----- |
| 小       | 150          | 1500         | 4     | 16 GB |
| 中       | 300          | 3000         | 8     | 32 GB |
| 大 (*)   | 500          | 5000         | 16    | 64 GB |

(*)：大规模的部署需要你[遵循最佳实践](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tuning-and-best-practices-for-rancher-at-scale)以获得足够的性能。

### RKE

下面的表格列出了[上游集群](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)中每个节点最小的 CPU 和内存要求。

请注意，生产环境下的高可用安装最少需要 3 个节点。

| 部署规模 | 最大集群数量 | 最大节点数量 | vCPUs | 内存  |
| -------- | ------------ | ------------ | ----- | ----- |
| 小       | 150          | 1500         | 4     | 16 GB |
| 中       | 300          | 3000         | 8     | 32 GB |
| 大 (*)   | 500          | 5000         | 16    | 64 GB |

(*)： 大规模的部署需要你[遵循最佳实践](https://ranchermanager.docs.rancher.com/zh/reference-guides/best-practices/rancher-server/tuning-and-best-practices-for-rancher-at-scale)以获得足够的性能。

有关 RKE 一般要求的更多详细信息，请参见 [RKE 文档](https://rke.docs.rancher.com/os)。

### Docker

下面的表格列出了[上游集群](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster)中每个节点最小的 CPU 和内存要求。

请注意，在 Docker 中安装 Rancher 仅适用于开发或测试目的。不建议在生产环境中使用。

| 部署规模 | 最大集群数量 | 最大节点数量 | vCPUs | 内存 |
| -------- | ------------ | ------------ | ----- | ---- |
| 小       | 5            | 50           | 1     | 4 GB |
| 中       | 15           | 200          | 2     | 8 GB |

## Ingress

安装 Rancher 的 Kubernetes 集群中的每个节点都应该运行一个 Ingress。

Ingress 需要部署为 DaemonSet 以确保负载均衡器能成功把流量转发到各个节点。

如果是 RKE，RKE2 和 K3s 安装，你不需要手动安装 Ingress，因为它是默认安装的。

对于托管的 Kubernetes 集群（EKS、GKE、AKS），你需要设置 Ingress。

- **Amazon EKS**：[在 Amazon EKS 上安装 Rancher 以及如何安装 Ingress 以访问 Rancher Server](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster/rancher-on-amazon-eks)。
- **AKS**：[使用 Azure Kubernetes 服务安装 Rancher 以及如何安装 Ingress 以访问 Rancher Server](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster/rancher-on-aks)。
- **GKE**：[使用 GKE 安装 Rancher 以及如何安装 Ingress 以访问 Rancher Server](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster/rancher-on-gke)。

## 磁盘

etcd 在集群中的性能决定了 Rancher 的性能。因此，为了获得最佳速度，我们建议使用 SSD 磁盘来支持 Rancher 管理的  Kubernetes 集群。在云提供商上，你还需使用能获得最大 IOPS 的最小大小。在较大的集群中，请考虑使用专用存储设备存储 etcd  数据和 wal 目录。

## 网络要求

本节描述了安装 Rancher Server 的节点的网络要求。



警告

如果包含 Rancher 的服务器带有 `X-Frame-Options=DENY` 标头，在升级旧版 UI 之后，Rancher UI 中的某些页面可能无法渲染。这是因为某些旧版页面在新 UI 中是以 iFrames 模式嵌入的。

### 节点 IP 地址

无论你是在单个节点还是高可用集群上安装 Rancher，每个节点都应配置一个静态 IP。如果使用 DHCP，则每个节点都应该有一个 DHCP 预留，以确保节点分配到相同的 IP 地址。

### 端口要求

为了确保能正常运行，Rancher 需要在 Rancher 节点和下游 Kubernetes 集群节点上开放一些端口。不同集群类型的 Rancher 和下游集群的所有必要端口，请参见[端口要求](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements/port-requirements)。

## Dockershim 支持

有关 Dockershim 支持的详情，请参见[此页面](https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements/dockershim)。