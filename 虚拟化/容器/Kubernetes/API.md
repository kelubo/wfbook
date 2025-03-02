# API

[TOC]

## 概述

Kubernetes API 使你可以查询和操纵 Kubernetes 中对象的状态。 Kubernetes 控制平面的核心是 API 服务器和它暴露的 HTTP API。 用户、集群的不同部分以及外部组件都通过 API 服务器相互通信。

Kubernetes [控制面](https://kubernetes.io/zh-cn/docs/reference/glossary/?all=true#term-control-plane)的核心是 [API 服务器](https://kubernetes.io/zh-cn/docs/concepts/architecture/#kube-apiserver)。 API 服务器负责提供 HTTP API，以供用户、集群中的不同部分和集群外部组件相互通信。

Kubernetes API 使你可以在 Kubernetes 中查询和操纵 API 对象 （例如 Pod、Namespace、ConfigMap 和 Event）的状态。

大部分操作都可以通过 [kubectl](https://kubernetes.io/zh-cn/docs/reference/kubectl/) 命令行接口或类似 [kubeadm](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/) 这类命令行工具来执行， 这些工具在背后也是调用 API。不过，你也可以使用 REST 调用来访问这些 API。 Kubernetes 为那些希望使用 Kubernetes API 编写应用的开发者提供一组[客户端库](https://kubernetes.io/zh-cn/docs/reference/using-api/client-libraries/)。

每个 Kubernetes 集群都会发布集群所使用的 API 规范。 Kubernetes 使用两种机制来发布这些 API 规范；这两种机制都有助于实现自动互操作。 例如，`kubectl` 工具获取并缓存 API 规范，以实现命令行补全和其他特性。所支持的两种机制如下：

- [发现 API](https://kubernetes.io/zh-cn/docs/concepts/overview/kubernetes-api/#discovery-api) 提供有关 Kubernetes API 的信息：API 名称、资源、版本和支持的操作。 此 API 是特定于 Kubernetes 的一个术语，因为它是一个独立于 Kubernetes OpenAPI 的 API。 其目的是为可用的资源提供简要总结，不详细说明资源的具体模式。有关资源模式的参考，请参阅 OpenAPI 文档。

- [Kubernetes OpenAPI 文档](https://kubernetes.io/zh-cn/docs/concepts/overview/kubernetes-api/#openapi-interface-definition)为所有 Kubernetes API 端点提供（完整的） [OpenAPI v2.0 和 v3.0 模式](https://www.openapis.org/)。OpenAPI v3 是访问 OpenAPI 的首选方法， 因为它提供了更全面和准确的 API 视图。其中包括所有可用的 API 路径，以及每个端点上每个操作所接收和生成的所有资源。 它还包括集群支持的所有可扩展组件。这些数据是完整的规范，比 Discovery API 提供的规范要大得多。

## Discovery API

Kubernetes 通过 Discovery API 发布集群所支持的所有组版本和资源列表。对于每个资源，包括以下内容：

- 名称
- 集群作用域还是名字空间作用域
- 端点 URL 和所支持的动词
- 别名
- 组、版本、类别

API 以聚合和非聚合形式提供。聚合的发现提供两个端点，而非聚合的发现为每个组版本提供单独的端点。

### 聚合的发现

特性状态： `Kubernetes v1.30 [stable]` (enabled by default: true)

Kubernetes 为**聚合的发现**提供了 Beta 支持，通过两个端点（`/api` 和 `/apis`）发布集群所支持的所有资源。 请求这个端点会大大减少从集群获取发现数据时发送的请求数量。你可以通过带有 `Accept` 头（`Accept: application/json;v=v2beta1;g=apidiscovery.k8s.io;as=APIGroupDiscoveryList`） 的请求发送到不同端点，来指明聚合发现的资源。

如果没有使用 `Accept` 头指示资源类型，对于 `/api` 和 `/apis` 端点的默认响应将是一个非聚合的发现文档。

内置资源的[发现文档](https://github.com/kubernetes/kubernetes/blob/release-1.32/api/discovery/aggregated_v2.json)可以在 Kubernetes GitHub 代码仓库中找到。如果手头没有 Kubernetes 集群可供查询， 此 Github 文档可用作可用资源的基础集合的参考。端点还支持 ETag 和 protobuf 编码。

### 非聚合的发现

在不使用聚合发现的情况下，发现 API 以不同级别发布，同时根端点为下游文档发布发现信息。

集群支持的所有组版本列表发布在 `/api` 和 `/apis` 端点。例如：

```
{
  "kind": "APIGroupList",
  "apiVersion": "v1",
  "groups": [
    {
      "name": "apiregistration.k8s.io",
      "versions": [
        {
          "groupVersion": "apiregistration.k8s.io/v1",
          "version": "v1"
        }
      ],
      "preferredVersion": {
        "groupVersion": "apiregistration.k8s.io/v1",
        "version": "v1"
      }
    },
    {
      "name": "apps",
      "versions": [
        {
          "groupVersion": "apps/v1",
          "version": "v1"
        }
      ],
      "preferredVersion": {
        "groupVersion": "apps/v1",
        "version": "v1"
      }
    },
    ...
}
```

用户需要发出额外的请求才能在 `/apis/<group>/<version>`（例如 `/apis/rbac.authorization.k8s.io/v1alpha1`） 获取每个组版本的发现文档。这些发现文档会公布在特定组版本下所提供的资源列表。 kubectl 使用这些端点来获取某集群所支持的资源列表。



## OpenAPI 接口定义

有关 OpenAPI 规范的细节，参阅 [OpenAPI 文档](https://www.openapis.org/)。

Kubernetes 同时提供 OpenAPI v2.0 和 OpenAPI v3.0。OpenAPI v3 是访问 OpenAPI 的首选方法， 因为它提供了对 Kubernetes 资源更全面（无损）的表示。由于 OpenAPI v2 的限制， 所公布的 OpenAPI 中会丢弃掉一些字段，包括但不限于 `default`、`nullable`、`oneOf`。

### OpenAPI v2

Kubernetes API 服务器通过 `/openapi/v2` 端点提供聚合的 OpenAPI v2 规范。 你可以按照下表所给的请求头部，指定响应的格式：

| 头部               | 可选值                                                       | 说明                     |
| ------------------ | ------------------------------------------------------------ | ------------------------ |
| `Accept-Encoding`  | `gzip`                                                       | *不指定此头部也是可以的* |
| `Accept`           | `application/com.github.proto-openapi.spec.v2@v1.0+protobuf` | *主要用于集群内部*       |
| `application/json` | *默认值*                                                     |                          |
| `*`                | *提供*`application/json`                                     |                          |

#### 警告：

作为 OpenAPI 模式的一部分发布的校验规则可能不完整，而且通常也确实不完整。 在 API 服务器内部会进行额外的校验。如果你希望进行精确且完整的验证， 可以使用 `kubectl apply --dry-run=server`，这条命令将运行所有适用的校验（同时也会触发准入时检查）。

### OpenAPI v3

特性状态： `Kubernetes v1.27 [stable]` (enabled by default: true)

Kubernetes 支持将其 API 的描述以 OpenAPI v3 形式发布。

发现端点 `/openapi/v3` 被提供用来查看可用的所有组、版本列表。 此列表仅返回 JSON。这些组、版本以下面的格式提供：

```yaml
{
    "paths": {
        ...,
        "api/v1": {
            "serverRelativeURL": "/openapi/v3/api/v1?hash=CC0E9BFD992D8C59AEC98A1E2336F899E8318D3CF4C68944C3DEC640AF5AB52D864AC50DAA8D145B3494F75FA3CFF939FCBDDA431DAD3CA79738B297795818CF"
        },
        "apis/admissionregistration.k8s.io/v1": {
            "serverRelativeURL": "/openapi/v3/apis/admissionregistration.k8s.io/v1?hash=E19CC93A116982CE5422FC42B590A8AFAD92CDE9AE4D59B5CAAD568F083AD07946E6CB5817531680BCE6E215C16973CD39003B0425F3477CFD854E89A9DB6597"
        },
        ....
    }
}
```

为了改进客户端缓存，相对的 URL 会指向不可变的 OpenAPI 描述。 为了此目的，API 服务器也会设置正确的 HTTP 缓存标头 （`Expires` 为未来 1 年，和 `Cache-Control` 为 `immutable`）。 当一个过时的 URL 被使用时，API 服务器会返回一个指向最新 URL 的重定向。

Kubernetes API 服务器会在端点 `/openapi/v3/apis/<group>/<version>?hash=<hash>` 发布一个 Kubernetes 组版本的 OpenAPI v3 规范。

请参阅下表了解可接受的请求头部。

| 头部               | 可选值                                                       | 说明                       |
| ------------------ | ------------------------------------------------------------ | -------------------------- |
| `Accept-Encoding`  | `gzip`                                                       | *不提供此头部也是可接受的* |
| `Accept`           | `application/com.github.proto-openapi.spec.v3@v1.0+protobuf` | *主要用于集群内部使用*     |
| `application/json` | *默认*                                                       |                            |
| `*`                | *以* `application/json` 形式返回                             |                            |

[`k8s.io/client-go/openapi3`](https://pkg.go.dev/k8s.io/client-go/openapi3) 包中提供了获取 OpenAPI v3 的 Golang 实现。

Kubernetes 1.32 发布了 OpenAPI v2.0 和 v3.0； 近期没有支持 v3.1 的计划。

### Protobuf 序列化

Kubernetes 为 API 实现了一种基于 Protobuf 的序列化格式，主要用于集群内部通信。 关于此格式的详细信息，可参考 [Kubernetes Protobuf 序列化](https://git.k8s.io/design-proposals-archive/api-machinery/protobuf.md)设计提案。 每种模式对应的接口描述语言（IDL）位于定义 API 对象的 Go 包中。

## 持久化

Kubernetes 通过将序列化状态的对象写入到 [etcd](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/configure-upgrade-etcd/) 中完成存储操作。

## API 组和版本控制

为了更容易消除字段或重组资源的呈现方式，Kubernetes 支持多个 API 版本，每个版本位于不同的 API 路径， 例如 `/api/v1` 或 `/apis/rbac.authorization.k8s.io/v1alpha1`。

版本控制是在 API 级别而不是在资源或字段级别完成的，以确保 API 呈现出清晰、一致的系统资源和行为视图， 并能够控制对生命结束和/或实验性 API 的访问。

为了更容易演进和扩展其 API，Kubernetes 实现了 [API 组](https://kubernetes.io/zh-cn/docs/reference/using-api/#api-groups)， 这些 API 组可以被[启用或禁用](https://kubernetes.io/zh-cn/docs/reference/using-api/#enabling-or-disabling)。

API 资源通过其 API 组、资源类型、名字空间（用于名字空间作用域的资源）和名称来区分。 API 服务器透明地处理 API 版本之间的转换：所有不同的版本实际上都是相同持久化数据的呈现。 API 服务器可以通过多个 API 版本提供相同的底层数据。

例如，假设针对相同的资源有两个 API 版本：`v1` 和 `v1beta1`。 如果你最初使用其 API 的 `v1beta1` 版本创建了一个对象， 你稍后可以使用 `v1beta1` 或 `v1` API 版本来读取、更新或删除该对象， 直到 `v1beta1` 版本被废弃和移除为止。此后，你可以使用 `v1` API 继续访问和修改该对象。

### API 变更

任何成功的系统都要随着新的使用案例的出现和现有案例的变化来成长和变化。 为此，Kubernetes 已设计了 Kubernetes API 来持续变更和成长。 Kubernetes 项目的目标是**不要**给现有客户端带来兼容性问题，并在一定的时期内维持这种兼容性， 以便其他项目有机会作出适应性变更。

一般而言，新的 API 资源和新的资源字段可以被频繁地添加进来。 删除资源或者字段则要遵从 [API 废弃策略](https://kubernetes.io/zh-cn/docs/reference/using-api/deprecation-policy/)。

Kubernetes 对维护达到正式发布（GA）阶段的官方 API 的兼容性有着很强的承诺，通常这一 API 版本为 `v1`。 此外，Kubernetes 保持与 Kubernetes 官方 API 的 **Beta** API 版本持久化数据的兼容性， 并确保在该功能特性已进入稳定期时数据可以通过 GA API 版本进行转换和访问。

如果你采用一个 Beta API 版本，一旦该 API 进阶，你将需要转换到后续的 Beta 或稳定的 API 版本。 执行此操作的最佳时间是 Beta API 处于弃用期，因为此时可以通过两个 API 版本同时访问那些对象。 一旦 Beta API 结束其弃用期并且不再提供服务，则必须使用替换的 API 版本。

#### 说明：

尽管 Kubernetes 也努力为 **Alpha** API 版本维护兼容性，在有些场合兼容性是无法做到的。 如果你使用了任何 Alpha API 版本，需要在升级集群时查看 Kubernetes 发布说明， 如果 API 确实以不兼容的方式发生变更，则需要在升级之前删除所有现有的 Alpha 对象。

关于 API 版本分级的定义细节，请参阅 [API 版本参考](https://kubernetes.io/zh-cn/docs/reference/using-api/#api-versioning)页面。

## API 扩展

有两种途径来扩展 Kubernetes API：

1. 你可以使用[自定义资源](https://kubernetes.io/zh-cn/docs/concepts/extend-kubernetes/api-extension/custom-resources/)来以声明式方式定义 API 服务器如何提供你所选择的资源 API。
2. 你也可以选择实现自己的[聚合层](https://kubernetes.io/zh-cn/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/)来扩展 Kubernetes API。