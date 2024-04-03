# Rating 额定值

​        version 版本              



This section describes configuring rating service such as CloudKitty.
本节介绍如何配置 CloudKitty 等评级服务。

- [CloudKitty - Rating service guide
  CloudKitty - 评级服务指南](https://docs.openstack.org/kolla-ansible/latest/reference/rating/cloudkitty-guide.html)

# CloudKitty - Rating service guide CloudKitty - 评级服务指南

​        version 版本              





## Overview 概述 ¶

CloudKitty is the Openstack service used to rate your platform usage. As a rating service, CloudKitty does not provide billing services such as generating a bill to send to your customers every month.
CloudKitty 是用于评估您的平台使用情况的 Openstack 服务。作为评级服务，CloudKitty 不提供计费服务，例如生成账单以每月发送给您的客户。

However, it provides you the building bricks you can use to build your own billing service upon internally.
但是，它为您提供了可用于在内部构建自己的计费服务的构建砖块。

Because cloudkitty is a flexible rating service, it’s highly customizable while still offering a generic approach to the rating of your platform.
由于 cloudkitty 是一种灵活的评级服务，因此它是高度可定制的，同时仍提供一种通用的方法来评估您的平台。

It lets you choose which metrics you want to rate, from which datasource and where to finally store the processed rate of those resources.
它允许您选择要对哪些指标进行评分、从哪个数据源以及最终存储这些资源的处理速率的位置。

This document will explain how to use the different features available and that Kolla Ansible supports.
本文档将解释如何使用 Kolla Ansible 支持的不同可用功能。

See the [CloudKitty documentation](https://docs.openstack.org/cloudkitty/latest//) for further information.
有关详细信息，请参阅 CloudKitty 文档。

## CloudKitty Collector backend CloudKitty Collector 后端 ¶

CloudKitty natively supports multiple collector backends.
CloudKitty 原生支持多个收集器后端。

By default Kolla Ansible uses the Gnocchi backend. Using data collected by Prometheus is also supported.
默认情况下，Kolla Ansible 使用 Gnocchi 后端。还支持使用 Prometheus 收集的数据。

The configuration parameter related to this option is `cloudkitty_collector_backend`.
与此选项相关的配置参数是 `cloudkitty_collector_backend` 。

To use the Prometheus collector backend:
要使用 Prometheus 收集器后端，请执行以下操作：

```
cloudkitty_collector_backend: prometheus
```

## CloudKitty Fetcher Backend CloudKitty Fetcher 后端 ¶

CloudKitty natively supports multiple fetcher backends.
CloudKitty 原生支持多个 fetcher 后端。

By default Kolla Ansible uses the `keystone` backend. This can be changed using the `cloudkitty_fetcher_backend` option.
默认情况下， `keystone` Kolla Ansible 使用后端。这可以使用该 `cloudkitty_fetcher_backend` 选项进行更改。

Kolla Ansible also supports the `prometheus` backend type, which is configured to discover scopes from the `id` label of the `openstack_identity_project_info` metric of OpenStack exporter.
Kolla Ansible 还支持 `prometheus` 后端类型，该类型配置为从 OpenStack 导出器 `openstack_identity_project_info` 的指标 `id` 标签中发现范围。

You will need to provide extra configuration for unsupported fetchers in `/etc/kolla/config/cloudkitty.conf`.
您需要为 中不支持的 `/etc/kolla/config/cloudkitty.conf` 提取器提供额外的配置。

## Cloudkitty Storage Backend Cloudkitty 存储后端 ¶

As for collectors, CloudKitty supports multiple backend to store ratings. By default, Kolla Ansible uses the InfluxDB based backend.
至于收藏家，CloudKitty支持多个后端到商店评级。默认情况下，Kolla Ansible 使用基于 InfluxDB 的后端。

Another famous alternative is Elasticsearch and can be activated in Kolla Ansible using the `cloudkitty_storage_backend`  configuration option in your `globals.yml` configuration file:
另一个著名的替代方案是 Elasticsearch，可以使用配置文件中的 `cloudkitty_storage_backend`  `globals.yml` 配置选项在 Kolla Ansible 中激活：

```
cloudkitty_storage_backend: elasticsearch
```

You can only use one backend type at a time, selecting elasticsearch will automatically enable Elasticsearch deployment and creation of the required CloudKitty index.
您一次只能使用一种后端类型，选择 elasticsearch 将自动启用 Elasticsearch 部署并创建所需的 CloudKitty 索引。