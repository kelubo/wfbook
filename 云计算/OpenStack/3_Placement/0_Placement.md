# Placement

[TOC]

## 概述

Placement API 服务是在 14.0.0 Newton 版本中引入 nova 存储库的，并在 19.0.0 Stein  版本中解压缩到 Placement 存储库中。This is a REST API stack and data model used to track resource provider inventories and usages, along with different classes of resources. 这是一个 REST API  堆栈和数据模型，用于跟踪资源提供程序清单和使用情况，以及不同类别的资源。例如，资源提供程序可以是计算节点、共享存储池或 IP  分配池。Placement 服务跟踪每个提供商的库存和使用情况。例如，an instance created on a compute node may be a consumer of resources such as RAM and CPU from a compute node resource provider, disk from an external shared storage pool resource provider and IP addresses from an external IP pool resource provider.在计算节点上创建的实例可能是资源的使用者，例如来自计算节点资源提供程序的 RAM 和 CPU、来自外部共享存储池资源提供程序的磁盘以及来自外部 IP 池资源提供程序的 IP 地址。

The types of resources consumed are tracked as **classes**. 消耗的资源类型作为类进行跟踪。该服务提供了一组标准资源类（例如 `DISK_GB` 、 `MEMORY_MB` 和 `VCPU` ），并提供了根据需要定义自定义资源类的功能。

Each resource provider may also have a set of traits which describe qualitative aspects of the resource provider. 每个资源提供程序还可能具有一组特征，用于描述资源提供程序的定性方面。Traits describe an aspect of a resource provider that cannot itself be consumed but a workload may wish to specify. 特征描述资源提供程序的某个方面，该方面本身不能被使用，但工作负载可能希望指定。例如，可用的磁盘可能是固态硬盘 （SSD）。

## Placement Usage 使用情况

### 跟踪资源

Placement 服务使其他项目能够跟踪自己的资源。这些项目可以通过 Placement HTTP API 在 Placement 中注册/删除自己的资源。

Placement 服务起源于 Nova 项目。因此，much of the functionality in placement was driven by nova’s requirements. Placement 中的大部分功能都是由 nova 的要求驱动的。但是，该功能被设计为足够通用，可供任何需要管理资源选择和消耗的服务使用。

#### Nova 如何使用 Placement

两个进程 `nova-compute` 和 `nova-scheduler` 承载了 nova 与 Placement 的大部分交互。

The nova resource tracker in `nova-compute` is responsible for [creating the resource provider](https://docs.openstack.org/api-ref/placement/?expanded=create-resource-provider-detail#create-resource-provider) record corresponding to the compute host on which the resource tracker runs, [setting the inventory](https://docs.openstack.org/api-ref/placement/?expanded=update-resource-provider-inventories-detail#update-resource-provider-inventories) that describes the quantitative resources that are available for workloads to consume (e.g., `VCPU`), and [setting the traits](https://docs.openstack.org/api-ref/placement/?expanded=update-resource-provider-traits-detail#update-resource-provider-traits) that describe qualitative aspects of the resources (e.g., `STORAGE_DISK_SSD`).
中的 nova 资源跟踪器 `nova-compute` 负责创建与运行资源跟踪器的计算主机相对应的资源提供程序记录，设置描述可供工作负载使用的定量资源的清单（例如 `VCPU` ），并设置描述资源定性方面的特征（例如 `STORAGE_DISK_SSD` ）。

If other projects – for example, Neutron or Cyborg – wish to manage resources on a compute host, they should create resource providers as children of the compute host provider and register their own managed resources as inventory on those child providers. 
如果其他项目（例如 Neutron 或 Cyborg）希望管理计算主机上的资源，则它们应将资源提供程序创建为计算主机提供程序的子级，并在这些子提供程序上将自己的托管资源注册为清单。

It begins by formulating a request to placement for a list of [allocation candidates](https://docs.openstack.org/api-ref/placement/?expanded=list-allocation-candidates-detail#list-allocation-candidates). That request expresses quantitative and qualitative requirements, membership in aggregates, and in more complex cases, the topology of related resources. That list is reduced and ordered by filters and weighers within the scheduler process. An [allocation](https://docs.openstack.org/api-ref/placement/?expanded=update-allocations-detail#update-allocations) is made against a resource provider representing a destination, consuming a portion of the inventory set by the resource tracker.
`nova-scheduler`  负责为工作负载选择一组合适的目标主机。它首先提出分配候选人名单的安置请求。该请求表达了定量和定性的要求、聚合中的成员资格，在更复杂的情况下，还表达了相关资源的拓扑结构。该列表由调度程序进程中的过滤器和称重器进行缩减和排序。针对表示目标的资源提供程序进行分配，消耗资源跟踪器设置的部分清单。

### REST API

The placement API service provides a well-documented, JSON-based [HTTP API](https://docs.openstack.org/api-ref/placement/) and data model. Placement API 服务提供有据可查的基于 JSON 的 HTTP API 和数据模型。It is designed to be easy to use from whatever HTTP client is suitable. 它被设计为易于从任何合适的 HTTP  客户端使用。openstackclient 命令行工具有一个名为 osc-placement 的插件，它可用于偶尔检查和操作 Placement 服务中的资源。

#### 微版本

The placement API uses microversions for making incremental changes to the API which client requests must opt into.
Placement API 使用微版本对客户端请求必须选择加入的 API 进行增量更改。

It is especially important to keep in mind that nova-compute is a client of the placement REST API and based on how Nova supports rolling upgrades the nova-compute service could be Newton level code making requests to an Ocata placement API, and vice-versa, an Ocata compute service in a cells v2 cell could be making requests to a Newton placement API.
特别重要的是要记住，nova-compute 是放置 REST API 的客户端，并且根据 Nova 支持滚动升级的方式，nova-compute 服务可能是向 Ocata 放置 API  发出请求的牛顿级代码，反之亦然，单元 v2 单元中的 Ocata 计算服务可以向 Newton 放置 API 发出请求。

This history of placement microversions may be found in the following subsection.
这种放置微版本的历史可以在以下小节中找到。

- REST API 版本历史
  - [Newton](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#newton)
  - [Ocata](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#ocata)
  - [Pike](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#pike)
  - [Queens](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#queens)
  - [Rocky](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#rocky)
  - [Stein](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#stein)
  - [Train](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#train)
  - [Xena](https://docs.openstack.org/placement/yoga/placement-api-microversion-history.html#xena)
