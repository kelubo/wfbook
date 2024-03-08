# Etcd

[TOC]

Follow these instructions to locally install, run, and test a single-member cluster of etcd:
按照以下说明在本地安装、运行和测试 etcd 的单成员集群：

1. Install etcd from pre-built binaries or from source. For details, see [Install](https://etcd.io/docs/v3.5/install/).
   从预构建的二进制文件或源代码安装 etcd。有关详细信息，请参阅安装。

   **Important**: Ensure that you perform the last step of the installation instructions to verify that `etcd` is in your path.
   重要提示：请确保执行安装说明的最后一步，以验证是否 `etcd` 在您的路径中。

2. Launch `etcd`: 发射 `etcd` ：

   ```console
   $ etcd
   {"level":"info","ts":"2021-09-17T09:19:32.783-0400","caller":"etcdmain/etcd.go:72","msg":... }
   ⋮
   ```

   **Note**: The output produced by `etcd` are [logs](https://etcd.io/docs/v3.5/op-guide/configuration/#logging) — info-level logs can be ignored.
   注意：生成的 `etcd` 输出是日志 — 可以忽略信息级日志。

3. From **another terminal**, use `etcdctl` to set a key:
   在另一个终端，用于 `etcdctl` 设置密钥：

   ```console
   $ etcdctl put greeting "Hello, etcd"
   OK
   ```

4. From the same terminal, retrieve the key:
   从同一终端检索密钥：

   ```console
   $ etcdctl get greeting
   greeting
   Hello, etcd
   ```

## What’s next? 下一步是什么？

Learn about more ways to configure and use etcd from the following pages:
从以下页面了解配置和使用 etcd 的更多方法：

- Explore the gRPC [API](https://etcd.io/docs/v3.5/learning/api). 探索 gRPC API。
- Set up a [multi-machine cluster](https://etcd.io/docs/v3.5/op-guide/clustering).
  设置多计算机群集。
- Learn how to [configure](https://etcd.io/docs/v3.5/op-guide/configuration) etcd.
  了解如何配置 etcd。
- Find [language bindings and tools](https://etcd.io/docs/v3.5/integrations).
  查找语言绑定和工具。
- Use TLS to [secure an etcd cluster](https://etcd.io/docs/v3.5/op-guide/security).
  使用 TLS 保护 etcd 集群。
- [Tune etcd](https://etcd.io/docs/v3.5/tuning). 调整 etcd。

# Demo

Procedures for working with an etcd cluster



This series of examples shows the basic procedures for working with an etcd cluster.

## Auth

`auth`,`user`,`role` for authentication:

```shell
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