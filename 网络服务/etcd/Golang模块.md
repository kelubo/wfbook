# Golang modules Golang 模块

Organization of the etcd project’s golang modules
etcd 项目的 golang 模块的组织



The etcd project (since version 3.5) is organized into multiple [golang modules](https://golang.org/ref/mod) hosted in a [single repository](https://golang.org/ref/mod#vcs-dir).
etcd 项目（从 3.5 版本开始）被组织成多个 golang 模块，托管在一个存储库中。

![modules graph](https://etcd.io/docs/v3.5/dev-internal/img/modules.svg)

There are following modules:
有以下模块：

- **go.etcd.io/etcd/api/v3** - contains API definitions (like protos & proto-generated libraries) that defines communication protocol between etcd clients and server.
  go.etcd.io/etcd/api/v3 - 包含 API 定义（如 protos 和 proto 生成的库），用于定义 etcd 客户端和服务器之间的通信协议。
- **go.etcd.io/etcd/pkg/v3** - collection of utility packages used by etcd without being specific to etcd itself. A package belongs here only if it could possibly be moved out into its own repository in the future. Please avoid adding here code that has a lot of dependencies on its own, as they automatically becoming dependencies of the client library (that we want to keep lightweight).
  go.etcd.io/etcd/pkg/v3 - etcd 使用的实用程序包的集合，但不特定于 etcd  本身。只有当一个包将来可能被移出到它自己的存储库中时，它才属于这里。请避免在此处添加本身具有大量依赖项的代码，因为它们会自动成为客户端库的依赖项（我们希望保持轻量级）。
- **go.etcd.io/etcd/client/v3** - client library used to contact etcd over the network (grpc). Recommended for all new usage of etcd.
  go.etcd.io/etcd/client/v3 - 用于通过网络 （gRPC） 联系 etcd 的客户端库。推荐用于 etcd 的所有新用途。
- **go.etcd.io/etcd/client/v2** - legacy client library used to contact etcd over HTTP protocol. Deprecated. All new usage should depend on /v3 library.
  go.etcd.io/etcd/client/v2 - 用于通过 HTTP 协议联系 etcd 的旧客户端库。荒废的。所有新用法都应依赖于 /v3 库。
- **go.etcd.io/etcd/raft/v3** - implementation of distributed consensus protocol. Should have no etcd specific code.
  go.etcd.io/etcd/raft/v3 - 分布式共识协议的实现。应该没有 etcd 特定的代码。
- **go.etcd.io/etcd/server/v3** - etcd implementation. The code in this package is etcd internal and should not be consumed by external projects. The package layout and API can change within the minor versions.
  go.etcd.io/etcd/server/v3 - etcd 实现。此包中的代码是 etcd 内部的，不应被外部项目使用。包布局和 API 可以在次要版本中更改。
- **go.etcd.io/etcd/etcdctl/v3** - a command line tool to access and manage etcd.
  go.etcd.io/etcd/etcdctl/v3 - 用于访问和管理 etcd 的命令行工具。
- **go.etcd.io/etcd/tests/v3** - a module that contains all integration tests of etcd. Notice: All unit-tests (fast and not requiring cross-module dependencies) should be kept in the local modules to the code under the test.
  go.etcd.io/etcd/tests/v3 - 包含 etcd 所有集成测试的模块。注意：所有单元测试（快速且不需要跨模块依赖）都应保存在测试代码的本地模块中。
- **go.etcd.io/bbolt** - implementation of persistent b-tree. Hosted in a separate repository: https://github.com/etcd-io/bbolt.
  go.etcd.io/bbolt - 持久性 b-tree 的实现。托管在单独的存储库中：https://github.com/etcd-io/bbolt。

### Operations 操作

1. All etcd modules should be released in the same versions, e.g. `go.etcd.io/etcd/client/v3@v3.5.10` must depend on `go.etcd.io/etcd/api/v3@v3.5.10`.
   所有 etcd 模块都应该以相同的版本发布，例如 `go.etcd.io/etcd/client/v3@v3.5.10` 必须依赖于 `go.etcd.io/etcd/api/v3@v3.5.10` .

   The consistent updating of versions can by performed using:
   版本的一致更新可以通过以下方式执行：

   ```shell
   % DRY_RUN=false TARGET_VERSION="v3.5.10" ./scripts/release_mod.sh update_versions
   ```

2. The released modules should be tagged according to https://golang.org/ref/mod#vcs-version rules, i.e. each module should get its own tag. The tagging can be performed using:
   发布的模块应该根据 https://golang.org/ref/mod#vcs-version 规则进行标记，即每个模块都应该有自己的标签。可以使用以下方法执行标记：

   ```shell
   % DRY_RUN=false REMOTE_REPO="origin" ./scripts/release_mod.sh push_mod_tags
   ```

3. All etcd modules should depend on the same versions of underlying dependencies. This can be verified using:
   所有 etcd 模块都应该依赖于相同版本的底层依赖。这可以通过以下方法进行验证：

   ```shell
   % PASSES="dep" ./test.sh
   ```

4. The go.mod files must not contain dependencies not being used and must conform to `go mod tidy` format. This is being verified by:
   go.mod 文件不得包含未使用的依赖项，并且必须符合 `go mod tidy` 格式。这正在通过以下方式进行验证：

   ```
   % PASSES="mod_tidy" ./test.sh
   ```

5. To trigger actions across all modules (e.g. auto-format all files), please use/expand the following script:
   要触发所有模块的操作（例如，自动格式化所有文件），请使用/展开以下脚本：

   ```shell
   % ./scripts/fix.sh
   ```

### Future 前途

As a North Star, we would like to evaluate etcd modules towards following model:
作为北极星，我们想根据以下模型评估 etcd 模块：

![modules graph](https://etcd.io/docs/v3.5/dev-internal/img/modules-future.svg)

This assumes: 这假设：

- Splitting etcdmigrate/etcdadm out of etcdctl binary. Thanks to this etcdctl would become clearly a command-line wrapper around network client API, while etcdmigrate/etcdadm would support direct physical operations on the etcd storage files.
  将 etcdmigrate/etcdadm 从 etcdctl 二进制文件中拆分出来。多亏了这一点，etcdctl 显然将成为网络客户端 API 的命令行包装器，而 etcdmigrate/etcdadm 将支持对 etcd 存储文件的直接物理操作。
- Splitting etcd-proxy out of ./etcd binary, as it contains more experimental code so carries additional risk & dependencies.
  将 etcd-proxy 从 ./etcd 二进制文件中拆分出来，因为它包含更多的实验性代码，因此会带来额外的风险和依赖性。
- Deprecation of support for v2 protocol.
  弃用对 v2 协议的支持。