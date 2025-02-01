# etcd API etcd 接口

etcd API central design overview
etcd API 中心设计概述



This document is meant to give an overview of the v3 etcd APIs central  design. This should not be mistaken with etcd v2 API, deprecated in etcd v3.5. It is by no means all encompassing, but intended to focus on the basic  ideas needed to understand etcd without the distraction of less common  API calls. All etcd APIs are defined in [gRPC services](https://github.com/etcd-io/etcd/blob/master/api/etcdserverpb/rpc.proto), which categorize remote procedure calls (RPCs) understood by the etcd server. A full listing of all etcd RPCs are documented in markdown in the [gRPC API listing](https://etcd.io/docs/v3.5/dev-guide/api_reference_v3/).
本文档旨在概述 v3 etcd API 的中心设计。这不应与 etcd v2 API 混淆，在 etcd v3.5  中已弃用。它绝不是包罗万象的，而是旨在专注于理解 etcd 所需的基本思想，而不会被不太常见的 API 调用所干扰。所有 etcd API 都在 gRPC 服务中定义，这些服务对 etcd 服务器理解的远程过程调用 （RPC） 进行分类。所有 etcd RPC 的完整列表都记录在  gRPC API 列表中的 markdown 中。

## gRPC Services gRPC 服务

Every API request sent to an etcd server is a gRPC remote procedure call.  RPCs in etcd are categorized based on functionality into services.
发送到 etcd 服务器的每个 API 请求都是一个 gRPC 远程过程调用。etcd 中的 RPC 根据功能分类到服务中。

Services important for dealing with etcd’s key space include:
处理 etcd 密钥空间的重要服务包括：

- KV - Creates, updates, fetches, and deletes key-value pairs.
  KV - 创建、更新、提取和删除键值对。
- Watch - Monitors changes to keys.
  监视 - 监视对按键的更改。
- Lease - Primitives for consuming client keep-alive messages.
  Lease - 用于使用客户端保持活动消息的基元。

Services which manage the cluster itself include:
管理集群本身的服务包括：

- Auth - Role based authentication mechanism for authenticating users.
  Auth - 用于对用户进行身份验证的基于角色的身份验证机制。
- Cluster - Provides membership information and configuration facilities.
  群集 - 提供成员身份信息和配置工具。
- Maintenance - Takes recovery snapshots, defragments the store, and returns per-member status information.
  维护 - 拍摄恢复快照，对存储进行碎片整理，并返回每个成员的状态信息。

### Requests and Responses 请求和回应

All RPCs in etcd follow the same format. Each RPC has a function `Name` which takes `NameRequest` as an argument and returns `NameResponse` as a response. For example, here is the `Range` RPC description:
etcd 中的所有 RPC 都遵循相同的格式。每个 RPC 都有一个函数，该函数 `Name` 作为 `NameRequest` 参数并作为响应返回 `NameResponse` 。例如，下面是 `Range` RPC 说明：

```protobuf
service KV {
  Range(RangeRequest) returns (RangeResponse)
  ...
}
```

### Response header 响应标头

All Responses from etcd API have an attached response header which includes cluster metadata for the response:
所有来自 etcd API 的响应都有一个附加的响应头，其中包含响应的集群元数据：

```proto
message ResponseHeader {
  uint64 cluster_id = 1;
  uint64 member_id = 2;
  int64 revision = 3;
  uint64 raft_term = 4;
}
```

- Cluster_ID - the ID of the cluster generating the response.
  Cluster_ID - 生成响应的集群的 ID。
- Member_ID - the ID of the member generating the response.
  Member_ID - 生成响应的成员的 ID。
- Revision - the revision of the key-value store when generating the response.
  修订版 - 生成响应时键值存储的修订版。
- Raft_Term - the Raft term of the member when generating the response.
  Raft_Term - 生成响应时成员的 Raft 项。

An application may read the `Cluster_ID` or `Member_ID` field to ensure it is communicating with the intended cluster (member).
应用程序可以读取 `Cluster_ID` or `Member_ID` 字段，以确保它与预期的集群（成员）通信。

Applications can use the `Revision` field to know the latest revision of the key-value store. This is  especially useful when applications specify a historical revision to  make a `time travel query` and wish to know the latest revision at the time of the request.
应用程序可以使用该 `Revision` 字段来了解键值存储的最新版本。当应用程序指定要进行 `time travel query` 的历史修订并希望在请求时了解最新修订版本时，这尤其有用。

Applications can use `Raft_Term` to detect when the cluster completes a new leader election.
应用程序可用于 `Raft_Term` 检测群集何时完成新的领导者选举。

## Key-Value API 键值 API

The Key-Value API manipulates key-value pairs stored inside etcd. The  majority of requests made to etcd are usually key-value requests.
Key-Value API 操作存储在 etcd 中的键值对。向 etcd 发出的大多数请求通常是键值请求。

### System primitives 系统基元

### Key-Value pair 键值对

A key-value pair is the smallest unit that the key-value API can  manipulate. Each key-value pair has a number of fields, defined in [protobuf format](https://github.com/etcd-io/etcd/blob/master/api/mvccpb/kv.proto):
键值对是键值 API 可以操作的最小单位。每个键值对都有许多字段，以 protobuf 格式定义：

```protobuf
message KeyValue {
  bytes key = 1;
  int64 create_revision = 2;
  int64 mod_revision = 3;
  int64 version = 4;
  bytes value = 5;
  int64 lease = 6;
}
```

- Key - key in bytes. An empty key is not allowed.
  key - 以字节为单位的键。不允许使用空密钥。
- Value - value in bytes.
  Value - 以字节为单位的值。
- Version - version is the version of the key. A deletion resets the version to  zero and any modification of the key increases its version.
  version - version 是密钥的版本。删除会将版本重置为零，并且对密钥的任何修改都会增加其版本。
- Create_Revision - revision of the last creation on the key.
  Create_Revision - 对密钥上上次创建的修订。
- Mod_Revision - revision of the last modification on the key.
  Mod_Revision - 对密钥上次修改的修订。
- Lease - the ID of the lease attached to the key. If lease is 0, then no lease is attached to the key.
  租约 - 附加到密钥的租约的 ID。如果 lease 为 0，则不会将租约附加到密钥。

In addition to just the key and value, etcd attaches additional revision  metadata as part of the key message. This revision information orders  keys by time of creation and modification, which is useful for managing  concurrency for distributed synchronization. The etcd client’s [distributed shared locks](https://github.com/etcd-io/etcd/blob/master/client/v3/concurrency/mutex.go) use the creation revision to wait for lock ownership. Similarly, the modification revision is used for detecting [software transactional memory](https://github.com/etcd-io/etcd/blob/master/client/v3/concurrency/stm.go) read set conflicts and waiting on [leader election](https://github.com/etcd-io/etcd/blob/master/client/v3/concurrency/election.go) updates.
除了键和值之外，etcd 还会附加其他修订元数据作为键消息的一部分。此修订信息按创建和修改时间对密钥进行排序，这对于管理分布式同步的并发性非常有用。etcd  客户端的分布式共享锁使用创建修订来等待锁所有权。同样，修改修订版用于检测软件事务内存读取集冲突和等待领导者选举更新。

#### Revisions 修改

etcd maintains a 64-bit cluster-wide counter, the store revision, that is  incremented each time the key space is modified. The revision serves as a global logical clock, sequentially ordering all updates to the store.  The change represented by a new revision is incremental; the data  associated with a revision is the data that changed the store.  Internally, a new revision means writing the changes to the backend’s  B+tree, keyed by the incremented revision.
etcd 维护一个 64  位集群范围的计数器，即存储修订版，每次修改密钥空间时都会递增。该修订版充当全局逻辑时钟，按顺序对存储区的所有更新进行排序。新修订版所代表的更改是增量的;与修订版本关联的数据是更改存储的数据。在内部，新修订意味着将更改写入后端的 B+树，由递增的修订进行键控。

Revisions become more valuable when considering etcd’s [multi-version concurrency control](https://en.wikipedia.org/wiki/Multiversion_concurrency_control) backend. The MVCC model means that the key-value store can be viewed  from past revisions since historical key revisions are retained. The  retention policy for this history can be configured by cluster  administrators for fine-grained storage management; usually etcd  discards old revisions of keys on a timer. A typical etcd cluster  retains superseded key data for hours. This also provides reliable  handling for long client disconnection, not just transient network  disruptions: watchers simply resume from the last observed historical  revision. Similarly, to read from the store at a particular  point-in-time, read requests can be tagged with a revision to return  keys from a view of the key space at the point-in-time that revision was committed.
在考虑 etcd 的多版本并发控制后端时，修订变得更有价值。MVCC  模型意味着可以从过去的修订版中查看键值存储，因为保留了历史键修订版。群集管理员可以配置此历史记录的保留策略，以实现细粒度的存储管理;通常  etcd 会丢弃计时器上的旧版本的密钥。典型的 etcd  集群会将被取代的密钥数据保留数小时。这也为长时间的客户端断开连接提供了可靠的处理，而不仅仅是暂时的网络中断：观察者只需从上次观察到的历史修订中恢复即可。同样，若要在特定时间点从存储中读取，可以使用修订标记读取请求，以在提交修订的时间点从密钥空间视图返回键。

#### Key ranges 关键范围

The etcd data model indexes all keys over a flat binary key space. This  differs from other key-value store systems that use a hierarchical  system of organizing keys into directories. Instead of listing keys by  directory, keys are listed by key intervals `[a, b)`.
etcd 数据模型在平面二进制密钥空间上索引所有密钥。这与其他键值存储系统不同，后者使用将键组织到目录中的分层系统。不是按目录列出键，而是按键间隔列出键 `[a, b)` 。

These intervals are often referred to as “ranges” in etcd. Operations over  ranges are more powerful than operations on directories. Like a  hierarchical store, intervals support single key lookups via `[a, a+1)` (e.g., [‘a’, ‘a\x00’) looks up ‘a’) and directory lookups by encoding  keys by directory depth. In addition to those operations, intervals can  also encode prefixes; for example the interval `['a', 'b')` looks up all keys prefixed by the string ‘a’.
这些间隔在 etcd 中通常称为“范围”。跨范围操作比对目录执行操作更强大。与分层存储一样，间隔支持通过 `[a, a+1)` （例如，['a'， 'a\x00'）查找“a”进行单键查找，并通过按目录深度对键进行编码来支持目录查找。除了这些操作之外，间隔还可以对前缀进行编码;例如，间隔 `['a', 'b')` 查找所有以字符串“a”为前缀的键。

By convention, ranges for a request are denoted by the fields `key` and `range_end`. The `key` field is the first key of the range and should be non-empty. The `range_end` is the key following the last key of the range. If `range_end` is not given or empty, the range is defined to contain only the key argument. If `range_end` is `key` plus one (e.g., “aa”+1 == “ab”, “a\xff”+1 == “b”), then the range represents all keys prefixed with key. If both `key` and `range_end` are ‘\0’, then range represents all keys. If `range_end` is ‘\0’, the range is all keys greater than or equal to the key argument.
按照惯例，请求的范围由字段 `key` 和 `range_end` 表示。该 `key` 字段是范围的第一个键，应为非空。是 `range_end` 范围的最后一个键之后的键。如果未给出或为空，则 `range_end` 将范围定义为仅包含键参数。如果 `range_end` 为 `key` 加一（例如，“aa”+1 == “ab”， “a\xff”+1 == “b”），则范围表示所有以 key 为前缀的键。如果 和 `key` `range_end` 都是 '\0'，则 range 表示所有键。如果 `range_end` 为 '\0'，则范围为大于或等于 key 参数的所有键。

### Range 范围

Keys are fetched from the key-value store using the `Range` API call, which takes a `RangeRequest`:
使用 `Range` API 调用从键值存储中获取密钥，该调用采用 `RangeRequest` ：

```protobuf
message RangeRequest {
  enum SortOrder {
	NONE = 0; // default, no sorting
	ASCEND = 1; // lowest target value first
	DESCEND = 2; // highest target value first
  }
  enum SortTarget {
	KEY = 0;
	VERSION = 1;
	CREATE = 2;
	MOD = 3;
	VALUE = 4;
  }

  bytes key = 1;
  bytes range_end = 2;
  int64 limit = 3;
  int64 revision = 4;
  SortOrder sort_order = 5;
  SortTarget sort_target = 6;
  bool serializable = 7;
  bool keys_only = 8;
  bool count_only = 9;
  int64 min_mod_revision = 10;
  int64 max_mod_revision = 11;
  int64 min_create_revision = 12;
  int64 max_create_revision = 13;
}
```

- Key, Range_End - The key range to fetch.
  Key， Range_End - 要提取的密钥范围。
- Limit - the maximum number of keys returned for the request. When limit is set to 0, it is treated as no limit.
  Limit - 为请求返回的最大密钥数。当 limit 设置为 0 时，它被视为无限制。
- Revision - the point-in-time of the key-value store to use for the range. If  revision is less or equal to zero, the range is over the latest  key-value store. If the revision is compacted, ErrCompacted is returned  as a response.
  修订 - 要用于范围的键值存储的时间点。如果修订小于或等于零，则范围超过最新的键值存储。如果压缩了修订版本，则 ErrCompacted 将作为响应返回。
- Sort_Order - the ordering for sorted requests.
  Sort_Order - 排序请求的排序。
- Sort_Target - the key-value field to sort.
  Sort_Target - 要排序的键值字段。
- Serializable - sets the range request to use serializable member-local reads. By  default, Range is linearizable; it reflects the current consensus of the cluster. For better performance and availability, in exchange for  possible stale reads, a serializable range request is served locally  without needing to reach consensus with other nodes in the cluster.
  Serializable - 将范围请求设置为使用可序列化的成员本地读取。默认情况下，Range 是可线性化的;它反映了该集群目前的共识。为了获得更好的性能和可用性，为了换取可能的过时读取，在本地提供可序列化的范围请求，而无需与集群中的其他节点达成共识。
- Keys_Only - return only the keys and not the values.
  Keys_Only - 仅返回键，不返回值。
- Count_Only - return only the count of the keys in the range.
  Count_Only - 仅返回范围内键的计数。
- Min_Mod_Revision - the lower bound for key mod revisions; filters out lesser mod revisions.
  Min_Mod_Revision - 关键 mod 修订的下限;过滤掉较小的 mod 修订版。
- Max_Mod_Revision - the upper bound for key mod revisions; filters out greater mod revisions.
  Max_Mod_Revision - 关键 mod 修订的上限;过滤掉更大的 mod 修订版。
- Min_Create_Revision - the lower bound for key create revisions; filters out lesser create revisions.
  Min_Create_Revision - 键创建修订的下限;过滤掉较小的创建修订。
- Max_Create_Revision - the upper bound for key create revisions; filters out greater create revisions.
  Max_Create_Revision - 键创建修订的上限;过滤掉更大的创建修订。

The client receives a `RangeResponse` message from the `Range` call:
客户端从 `Range` 呼叫中收到一条 `RangeResponse` 消息：

```protobuf
message RangeResponse {
  ResponseHeader header = 1;
  repeated mvccpb.KeyValue kvs = 2;
  bool more = 3;
  int64 count = 4;
}
```

- Kvs - the list of key-value pairs matched by the range request. When `Count_Only` is set, `Kvs` is empty.
  Kvs - 与范围请求匹配的键值对列表。设置时 `Count_Only` ， `Kvs` 为空。
- More - indicates if there are more keys to return in the requested range if `limit` is set.
  更多 - 指示 `limit` 如果设置了请求的范围内是否有更多键要返回。
- Count - the total number of keys satisfying the range request.
  计数 - 满足范围请求的键总数。

### Put

Keys are saved into the key-value store by issuing a `Put` call, which takes a `PutRequest`:
通过发出 `Put` 调用将密钥保存到键值存储中，该调用需要 `PutRequest` ：

```protobuf
message PutRequest {
  bytes key = 1;
  bytes value = 2;
  int64 lease = 3;
  bool prev_kv = 4;
  bool ignore_value = 5;
  bool ignore_lease = 6;
}
```

- Key - the name of the key to put into the key-value store.
  键 - 要放入键值存储的键的名称。
- Value - the value, in bytes, to associate with the key in the key-value store.
  值 - 要与键值存储中的键关联的值（以字节为单位）。
- Lease - the lease ID to associate with the key in the key-value store. A lease value of 0 indicates no lease.
  Lease - 要与键值存储中的密钥关联的租约 ID。租约值为 0 表示没有租约。
- Prev_Kv - when set, responds with the key-value pair data before the update from this `Put` request.
  Prev_Kv - 设置后，在从此 `Put` 请求更新之前使用键值对数据进行响应。
- Ignore_Value - when set, update the key without changing its current value. Returns an error if the key does not exist.
  Ignore_Value - 设置后，在不更改其当前值的情况下更新密钥。如果密钥不存在，则返回错误。
- Ignore_Lease - when set, update the key without changing its current lease. Returns an error if the key does not exist.
  Ignore_Lease - 设置后，在不更改其当前租约的情况下更新密钥。如果密钥不存在，则返回错误。

The client receives a `PutResponse` message from the `Put` call:
客户端从 `Put` 呼叫中收到一条 `PutResponse` 消息：

```protobuf
message PutResponse {
  ResponseHeader header = 1;
  mvccpb.KeyValue prev_kv = 2;
}
```

- Prev_Kv - the key-value pair overwritten by the `Put`, if `Prev_Kv` was set in the `PutRequest`.
  Prev_Kv - 被 `Put` 覆盖的键值对，如果 `Prev_Kv` 在 中设置 `PutRequest` 。

### Delete Range 删除范围

Ranges of keys are deleted using the `DeleteRange` call, which takes a `DeleteRangeRequest`:
使用 `DeleteRange` 调用删除键的范围，该调用采用 `DeleteRangeRequest` ：

```protobuf
message DeleteRangeRequest {
  bytes key = 1;
  bytes range_end = 2;
  bool prev_kv = 3;
}
```

- Key, Range_End - The key range to delete.
  键、Range_End - 要删除的键范围。
- Prev_Kv - when set, return the contents of the deleted key-value pairs.
  Prev_Kv - 设置后，返回已删除的键值对的内容。

The client receives a `DeleteRangeResponse` message from the `DeleteRange` call:
客户端从 `DeleteRange` 呼叫中收到一条 `DeleteRangeResponse` 消息：

```protobuf
message DeleteRangeResponse {
  ResponseHeader header = 1;
  int64 deleted = 2;
  repeated mvccpb.KeyValue prev_kvs = 3;
}
```

- Deleted - number of keys deleted.
  已删除 - 已删除的密钥数。
- Prev_Kv - a list of all key-value pairs deleted by the `DeleteRange` operation.
  Prev_Kv - `DeleteRange` 操作删除的所有键值对的列表。

### Transaction 交易

A transaction is an atomic If/Then/Else construct over the key-value  store. It provides a primitive for grouping requests together in atomic  blocks (i.e., then/else) whose execution is guarded (i.e., if) based on  the contents of the key-value store. Transactions can be used for  protecting keys from unintended concurrent updates, building  compare-and-swap operations, and developing higher-level concurrency  control.
事务是键值存储上的原子 If/Then/Else 构造。它提供了一个原语，用于将请求分组到原子块（即 then/else）中，其执行根据键值存储的内容受到保护（即  if）。事务可用于保护密钥免受意外并发更新的影响、构建比较和交换操作以及开发更高级别的并发控制。

A transaction can atomically process multiple requests in a single  request. For modifications to the key-value store, this means the  store’s revision is incremented only once for the transaction and all  events generated by the transaction will have the same revision.  However, modifications to the same key multiple times within a single  transaction are forbidden.
事务可以在单个请求中以原子方式处理多个请求。对于键值存储的修改，这意味着存储的修订仅针对事务递增一次，并且事务生成的所有事件都将具有相同的修订。但是，禁止在单个事务中多次修改同一密钥。

All transactions are guarded by a conjunction of comparisons, similar to an `If` statement. Each comparison checks a single key in the store. It may  check for the absence or presence of a value, compare with a given  value, or check a key’s revision or version. Two different comparisons  may apply to the same or different keys. All comparisons are applied  atomically; if all comparisons are true, the transaction is said to  succeed and etcd applies the transaction’s then / `success` request block, otherwise it is said to fail and applies the else / `failure` request block.
所有交易都由比较组合保护，类似于语 `If` 句。每次比较都会检查存储中的单个键。它可以检查值的缺失或存在，与给定值进行比较，或检查键的修订版或版本。两种不同的比较可能适用于相同或不同的键。所有比较都是原子应用的;如果所有比较都为真，则表示交易成功，etcd 应用交易的 then / `success` 请求块，否则称为失败并应用 else / `failure` 请求块。

Each comparison is encoded as a `Compare` message:
每个比较都编码为一条 `Compare` 消息：

```protobuf
message Compare {
  enum CompareResult {
    EQUAL = 0;
    GREATER = 1;
    LESS = 2;
    NOT_EQUAL = 3;
  }
  enum CompareTarget {
    VERSION = 0;
    CREATE = 1;
    MOD = 2;
    VALUE= 3;
  }
  CompareResult result = 1;
  // target is the key-value field to inspect for the comparison.
  CompareTarget target = 2;
  // key is the subject key for the comparison operation.
  bytes key = 3;
  oneof target_union {
    int64 version = 4;
    int64 create_revision = 5;
    int64 mod_revision = 6;
    bytes value = 7;
  }
}
```

- Result - the kind of logical comparison operation (e.g., equal, less than, etc).
  结果 - 逻辑比较运算的类型（例如，等于、小于等）。
- Target - the key-value field to be compared. Either the key’s version, create revision, modification revision, or value.
  目标 - 要比较的键值字段。键的版本、创建修订、修改修订或值。
- Key - the key for the comparison.
  键 - 比较的键。
- Target_Union - the user-specified data for the comparison.
  Target_Union - 用户指定的比较数据。

After processing the comparison block, the transaction applies a block of requests. A block is a list of `RequestOp` messages:
处理比较块后，事务将应用一个请求块。块是 `RequestOp` 消息列表：

```protobuf
message RequestOp {
  // request is a union of request types accepted by a transaction.
  oneof request {
    RangeRequest request_range = 1;
    PutRequest request_put = 2;
    DeleteRangeRequest request_delete_range = 3;
  }
}
```

- Request_Range - a `RangeRequest`.
  Request_Range - 一个 `RangeRequest` .
- Request_Put - a `PutRequest`. The keys must be unique. It may not share keys with any other Puts or Deletes.
  Request_Put - 一个 `PutRequest` .密钥必须是唯一的。它不得与任何其他 Put 或 Delete 共享密钥。
- Request_Delete_Range - a `DeleteRangeRequest`. It may not share keys with any Puts or Deletes requests.
  Request_Delete_Range - 一个 `DeleteRangeRequest` .它不得与任何 Puts 或 Deletes 请求共享密钥。

All together, a transaction is issued with a `Txn` API call, which takes a `TxnRequest`:
总而言之，交易是通过 `Txn` API 调用发出的，该调用需要： `TxnRequest` 

```protobuf
message TxnRequest {
  repeated Compare compare = 1;
  repeated RequestOp success = 2;
  repeated RequestOp failure = 3;
}
```

- Compare - A list of predicates representing a conjunction of terms for guarding the transaction.
  比较 - 一个谓词列表，表示用于保护事务的术语的组合。
- Success - A list of requests to process if all compare tests evaluate to true.
  成功 - 如果所有比较测试的计算结果都为 true，则要处理的请求列表。
- Failure - A list of requests to process if any compare test evaluates to false.
  失败 - 如果任何比较测试的计算结果为 false，则要处理的请求列表。

The client receives a `TxnResponse` message from the `Txn` call:
客户端从 `Txn` 呼叫中收到一条 `TxnResponse` 消息：

```protobuf
message TxnResponse {
  ResponseHeader header = 1;
  bool succeeded = 2;
  repeated ResponseOp responses = 3;
}
```

- Succeeded - Whether `Compare` evaluated to true or false.
  Succeeded - 计算结果为 `Compare` true 还是 false。
- Responses - A list of responses corresponding to the results from applying the `Success` block if succeeded is true or the `Failure` if succeeded is false.
  响应 - 与应用 `Success` 块的结果相对应的响应列表，if succeeded 为 true 或 `Failure` if succeeded 为 false。

The `Responses` list corresponds to the results from the applied `RequestOp` list, with each response encoded as a `ResponseOp`:
该 `Responses` 列表对应于应用 `RequestOp` 列表的结果，每个响应都编码为 `ResponseOp` ：

```protobuf
message ResponseOp {
  oneof response {
    RangeResponse response_range = 1;
    PutResponse response_put = 2;
    DeleteRangeResponse response_delete_range = 3;
  }
}
```

The `ResponseHeader` included in each inner response shouldn’t be interpreted in any way. If clients need to get the latest revision, then they should always check the top level `ResponseHeader` in `TxnResponse`.
 `ResponseHeader` 不应以任何方式解释每个内部反应中包含的内容。如果客户需要获取最新版本，那么他们应该始终检查 `TxnResponse` 中的顶层 `ResponseHeader` 。

## Watch API 观看 API

The `Watch` API provides an event-based interface for asynchronously monitoring  changes to keys. An etcd watch waits for changes to keys by continuously watching from a given revision, either current or historical, and  streams key updates back to the client.
该 `Watch` API 提供了一个基于事件的接口，用于异步监视对键的更改。etcd 监视通过持续监视给定的修订版（当前或历史版本）来等待密钥的更改，并将密钥更新流式传输回客户端。

### Events 事件

Every change to every key is represented with `Event` messages. An `Event` message provides both the update’s data and the type of update:
对每个键的每次更改都用 `Event` 消息表示。一条 `Event` 消息同时提供更新的数据和更新类型：

```protobuf
message Event {
  enum EventType {
    PUT = 0;
    DELETE = 1;
  }
  EventType type = 1;
  KeyValue kv = 2;
  KeyValue prev_kv = 3;
}
```

- Type - The kind of event. A PUT type indicates new data has been stored to the key. A DELETE indicates the key was deleted.
  类型 - 事件的类型。PUT 类型表示新数据已存储到密钥中。DELETE 表示密钥已删除。
- KV - The KeyValue associated with the event. A PUT event contains current  kv pair. A PUT event with kv.Version=1 indicates the creation of a key. A DELETE event contains the deleted key with its modification revision  set to the revision of deletion.
  KV - 与事件关联的 KeyValue。PUT 事件包含当前 kv 对。带有 kv 的 PUT 事件。Version=1 表示创建密钥。DELETE 事件包含已删除的项，其修改修订设置为删除修订。
- Prev_KV - The key-value pair for the key from the revision immediately before  the event. To save bandwidth, it is only filled out if the watch has  explicitly enabled it.
  Prev_KV - 紧接事件发生前的修订版中键的键值对。为了节省带宽，只有在手表明确启用它时才会填写它。

### Watch streams 观看直播

Watches are long-running requests and use gRPC streams to stream event data. A  watch stream is bi-directional; the client writes to the stream to  establish watches and reads to receive watch events. A single watch  stream can multiplex many distinct watches by tagging events with  per-watch identifiers. This multiplexing helps reducing the memory  footprint and connection overhead on the core etcd cluster.
监视是长时间运行的请求，使用 gRPC  流来流式传输事件数据。监视流是双向的;客户端写入流以建立监视，读取以接收监视事件。单个监视流可以通过使用每个监视标识符标记事件来多路复用多个不同的监视。这种多路复用有助于减少核心 etcd 集群上的内存占用和连接开销。

Watches make three guarantees about events:
手表对事件做出三点保证：

- Ordered - events are ordered by revision; an event will never appear on a watch if it precedes an event in time that has already been posted.
  有序 - 事件按修订排序;如果某个事件在已发布的时间内先于某个事件，则该事件将永远不会出现在手表上。
- Reliable - a sequence of events will never drop any subsequence of events; if  there are events ordered in time as a < b < c, then if the watch  receives events a and c, it is guaranteed to receive b.
  可靠 - 事件序列永远不会删除事件的任何子序列;如果有事件按 A < B < C 排序，那么如果手表接收到事件 A 和 C，则保证接收 B。
- Atomic - a list of events is guaranteed to encompass complete revisions;  updates in the same revision over multiple keys will not be split over  several lists of events.
  原子 - 事件列表保证包含完整的修订;同一修订版中多个键的更新不会拆分为多个事件列表。

A client creates a watch by sending a `WatchCreateRequest` over a stream returned by `Watch`:
客户端通过发送 `WatchCreateRequest` over 流来创建监视 `Watch` ：

```protobuf
message WatchCreateRequest {
  bytes key = 1;
  bytes range_end = 2;
  int64 start_revision = 3;
  bool progress_notify = 4;

  enum FilterType {
    NOPUT = 0;
    NODELETE = 1;
  }
  repeated FilterType filters = 5;
  bool prev_kv = 6;
}
```

- Key, Range_End - The key range to watch.
  键、Range_End - 要监视的关键范围。
- Start_Revision - An optional revision for where to inclusively begin watching. If not  given, it will stream events following the revision of the watch  creation response header revision. The entire available event history  can be watched starting from the last compaction revision.
  Start_Revision - 关于从何处开始观看的可选修订。如果未给出，它将在监视创建响应标头修订后流式传输事件。从上次压实修订开始，可以查看整个可用的事件历史记录。
- Progress_Notify - When set, the watch will periodically receive a WatchResponse with no events, if there are no recent events. It is useful when clients wish  to recover a disconnected watcher starting from a recent known revision. The etcd server decides how often to send notifications based on  current server load.
  Progress_Notify - 设置后，如果没有最近发生的事件，监视将定期收到没有事件的 WatchResponse。当客户端希望从最近的已知修订版开始恢复断开连接的观察程序时，它非常有用。etcd 服务器根据当前服务器负载决定发送通知的频率。
- Filters - A list of event types to filter away at server side.
  过滤器 - 要在服务器端过滤掉的事件类型列表。
- Prev_Kv - When set, the watch receives the key-value data from before the event happens. This is useful for knowing what data has been overwritten.
  Prev_Kv - 设置后，监视将接收事件发生前的键值数据。这对于了解哪些数据已被覆盖非常有用。

In response to a `WatchCreateRequest` or if there is a new event for some established watch, the client receives a `WatchResponse`:
作为对 a `WatchCreateRequest` 的响应，或者如果某些已建立的监视有新事件，客户端会收到一个 `WatchResponse` ：

```protobuf
message WatchResponse {
  ResponseHeader header = 1;
  int64 watch_id = 2;
  bool created = 3;
  bool canceled = 4;
  int64 compact_revision = 5;

  repeated mvccpb.Event events = 11;
}
```

- Watch_ID - the ID of the watch that corresponds to the response.
  Watch_ID - 与响应对应的手表的 ID。
- Created - set to true if the response is for a create watch request. The client should store the ID and expect to receive events for the watch on the  stream. All events sent to the created watcher will have the same  watch_id.
  已创建 - 如果响应是针对创建监视请求，则设置为 true。客户端应存储 ID，并期望在流上接收监视的事件。发送到创建的观察程序的所有事件都将具有相同的watch_id。
- Canceled - set to true if the response is for a cancel watch request. No further events will be sent to the canceled watcher.
  已取消 - 如果响应是针对取消监视请求，则设置为 true。不会再向已取消的观察者发送其他事件。
- Compact_Revision - set to the minimum historical revision available to etcd if a watcher tries watching at a compacted revision. This happens when creating a  watcher at a compacted revision or the watcher cannot catch up with the  progress of the key-value store. The watcher will be canceled; creating  new watches with the same start_revision will fail.
  Compact_Revision - 设置为 etcd  可用的最小历史修订版，如果观察者尝试监视压缩的修订版。当在压缩的修订版中创建观察程序或观察程序无法跟上键值存储的进度时，会发生这种情况。观察者将被取消;使用相同start_revision创建新手表将失败。
- Events - a list of new events in sequence corresponding to the given watch ID.
  事件 - 与给定监视 ID 相对应的新事件列表。

If the client wishes to stop receiving events for a watch, it issues a `WatchCancelRequest`:
如果客户端希望停止接收监视的事件，则会发出： `WatchCancelRequest` 

```protobuf
message WatchCancelRequest {
   int64 watch_id = 1;
}
```

- Watch_ID - the ID of the watch to cancel so that no more events are transmitted.
  Watch_ID - 要取消的监视的 ID，以便不再传输事件。

## Lease API 租赁 API

Leases are a mechanism for detecting client liveness. The cluster grants  leases with a time-to-live. A lease expires if the etcd cluster does not receive a keepAlive within a given TTL period.
租约是一种检测客户端活动状态的机制。群集授予具有生存时间的租约。如果 etcd 集群在给定的 TTL 周期内没有收到 keepAlive，则租约将过期。

To tie leases into the key-value store, each key may be attached to at  most one lease. When a lease expires or is revoked, all keys attached to that lease will be deleted. Each expired key generates a delete event  in the event history.
若要将租约绑定到键值存储中，每个键最多可以附加到一个租约。当租约到期或被吊销时，附加到该租约的所有密钥都将被删除。每个过期的密钥都会在事件历史记录中生成一个删除事件。

### Obtaining leases 获取租约

Leases are obtained through the `LeaseGrant` API call, which takes a `LeaseGrantRequest`:
租约是通过 `LeaseGrant` API 调用获取的，该调用采用： `LeaseGrantRequest` 

```protobuf
message LeaseGrantRequest {
  int64 TTL = 1;
  int64 ID = 2;
}
```

- TTL - the advisory time-to-live, in seconds.
  TTL - 建议生存时间，以秒为单位。
- ID - the requested ID for the lease. If ID is set to 0, etcd will choose an ID.
  ID - 请求的租约 ID。如果 ID 设置为 0，etcd 将选择一个 ID。

The client receives a `LeaseGrantResponse` from the `LeaseGrant` call:
客户端从 `LeaseGrant` 调用中接收： `LeaseGrantResponse` 

```protobuf
message LeaseGrantResponse {
  ResponseHeader header = 1;
  int64 ID = 2;
  int64 TTL = 3;
}
```

- ID - the lease ID for the granted lease.
  ID - 已授予租约的租约 ID。
- TTL - is the server selected time-to-live, in seconds, for the lease.
  TTL - 是为租约选择的生存时间（以秒为单位）。

```protobuf
message LeaseRevokeRequest {
  int64 ID = 1;
}
```

- ID - the lease ID to revoke. When the lease is revoked, all attached keys are deleted.
  ID - 要撤销的租约 ID。撤销租约后，将删除所有附加的密钥。

### Keep alives 保持活力

Leases are refreshed using a bi-directional stream created with the `LeaseKeepAlive` API call. When the client wishes to refresh a lease, it sends a `LeaseKeepAliveRequest` over the stream:
使用通过 `LeaseKeepAlive` API 调用创建的双向流刷新租约。当客户端希望刷新租约时，它会通过流发送： `LeaseKeepAliveRequest` 

```protobuf
message LeaseKeepAliveRequest {
  int64 ID = 1;
}
```

- ID - the lease ID for the lease to keep alive.
  ID - 要保持活动状态的租约 ID。

The keep alive stream responds with a `LeaseKeepAliveResponse`:
保持活动状态流以以下方式 `LeaseKeepAliveResponse` 响应：

```protobuf
message LeaseKeepAliveResponse {
  ResponseHeader header = 1;
  int64 ID = 2;
  int64 TTL = 3;
}
```

- ID - the lease that was refreshed with a new TTL.
  ID - 使用新 TTL 刷新的租约。
- TTL - the new time-to-live, in seconds, that the lease has remaining.
  TTL - 租约剩余的新生存时间（以秒为单位）。

# KV API 保证

KV API guarantees made by etcd
etcd 提供的 KV API 保证



etcd is a consistent and durable key value store with [mini-transaction](https://etcd.io/docs/v3.5/learning/api/#transaction) support. The key value store is exposed through the KV APIs. etcd tries to ensure the strongest consistency and durability guarantees for a distributed system. This specification enumerates the KV API guarantees made by etcd.
etcd 是一个一致且持久的键值存储，支持小型事务。键值存储通过 KV API 公开。etcd 试图确保分布式系统最强的一致性和持久性保证。此规范列举了 etcd 所做的 KV API 保证。

### APIs to consider 要考虑的 API

- Read APIs

   读取 API

  - range 范围
  - watch 看

- Write APIs

   编写 API

  - put
  - delete 删除

- Combination (read-modify-write) APIs

  
  组合（读-修改-写）API

  - txn

- Lease APIs

   租赁 API

  - grant 授予
  - revoke 撤回
  - put (attaching a lease to a key)
    put（将租约附加到密钥）

### etcd specific definitions etcd 特定定义

#### Operation completed 操作完成

An etcd operation is considered complete when it is committed through consensus, and therefore “executed” – permanently stored – by the etcd storage engine. The client knows an operation is completed when it receives a response from the etcd server. Note that the client may be uncertain about the status of an operation if it times out, or there is a network disruption between the client and the etcd member. etcd may also abort operations when there is a leader election. etcd does not send `abort` responses to clients’ outstanding requests in this event.
当 etcd 操作通过共识提交时，它被认为是完整的，因此由 etcd 存储引擎“执行”——永久存储。当客户端收到来自 etcd  服务器的响应时，它就知道操作已经完成。请注意，如果操作超时，或者客户端和 etcd 成员之间出现网络中断，客户端可能不确定操作的状态。etcd  也可能在进行领导人选举时中止操作。在此事件中，etcd 不会对客户的未完成请求发送 `abort` 响应。

#### Revision 校订

An etcd operation that modifies the key value store is assigned a single increasing revision. A transaction operation might modify the key value store multiple times, but only one revision is assigned. The revision attribute of a key value pair that was modified by the operation has the same value as the revision of the operation. The revision can be used as a logical clock for key value store. A key value pair that has a larger revision is modified after a key value pair with a smaller revision. Two key value pairs that have the same revision are modified by an operation “concurrently”.
修改键值存储的 etcd 操作被分配一个递增修订版本。事务操作可能会多次修改键值存储，但只分配一个修订。操作修改的键值对的 revision  属性与操作的修订版本具有相同的值。该修订版可用作键值存储的逻辑时钟。在修订版本较小的键值对之后，会修改具有较大修订版本的键值对。具有相同修订版本的两个键值对通过“并发”操作进行修改。

### Guarantees provided 提供担保

#### Atomicity 原子数

All API requests are atomic; an operation either completes entirely or not at all. For watch requests, all events generated by one operation will be in one watch response. Watch never observes partial events for a single operation.
所有 API 请求都是原子的;操作要么完全完成，要么根本不完成。对于监视请求，一个操作生成的所有事件都将在一个监视响应中。监视从不观察单个操作的部分事件。

#### Durability 耐久性

Any completed operations are durable. All accessible data is also durable data. A read will never return data that has not been made durable.
任何已完成的操作都是持久的。所有可访问的数据也是持久数据。读取永远不会返回尚未持久化的数据。

#### Isolation level and consistency of replicas 副本的隔离级别和一致性

etcd ensures [strict serializability](http://jepsen.io/consistency/models/strict-serializable), which is the strongest isolation guarantee of distributed transactional database systems. Read operations will never observe any intermediate data.
etcd 保证了严格的序列化性，这是分布式事务数据库系统最强的隔离保证。读取操作永远不会观察到任何中间数据。

etcd ensures [linearizability](https://cs.brown.edu/~mph/HerlihyW90/p463-herlihy.pdf) as consistency of replicas basically. As described below, exceptions are watch operations and read operations which explicitly specifies serializable option.
etcd 基本上保证了副本的线性化。如下所述，显式指定可序列化选项的监视操作和读取操作除外。

From the perspective of client, linearizability provides useful properties which make reasoning easily. This is a clean description quoted from [the original paper](https://cs.brown.edu/~mph/HerlihyW90/p463-herlihy.pdf): `Linearizability provides the illusion that each operation applied by concurrent  processes takes effect instantaneously at some point between its  invocation and its response.`
从客户的角度来看，线性化提供了有用的属性，使推理变得容易。这是从原始论文中引用的清晰描述： `Linearizability provides the illusion that each operation applied by concurrent  processes takes effect instantaneously at some point between its  invocation and its response.` 

For example, consider a client completing a write at time point 1 (*t1*). A client issuing a read at *t2* (for *t2* > *t1*) should receive a value at least as recent as the previous write, completed at *t1*. However, the read might actually complete only by *t3*. Linearizability guarantees the read returns the most current value. Without linearizability guarantee, the returned value, current at *t2* when the read began, might be “stale” by *t3* because a concurrent write might happen between *t2* and *t3*.
例如，假设客户端在时间点 1 （t1） 完成写入。在 t2 处发出读取的客户端（对于 t2 > t1）应至少收到与上一次写入一样近的值，在 t1  处完成。但是，读取实际上可能仅在 t3 之前完成。线性化保证读取返回最新值。如果没有线性化保证，则返回值（读取开始时 t2 的当前值）可能会在  t3 中“过时”，因为 t2 和 t3 之间可能会发生并发写入。

etcd does not ensure linearizability for watch operations. Users are expected to verify the revision of watch responses to ensure correct ordering.
etcd 不保证手表操作的线性化。用户应验证监视响应的修订，以确保正确排序。

etcd ensures linearizability for all other operations by default. Linearizability comes with a cost, however, because linearized requests must go through the Raft consensus process. To obtain lower latencies and higher throughput for read requests, clients can configure a request’s consistency mode to `serializable`, which may access stale data with respect to quorum, but removes the performance penalty of linearized accesses’ reliance on live consensus.
etcd 默认确保所有其他操作的线性化。然而，线性化是有代价的，因为线性化请求必须经过 Raft 共识过程。为了获得更低的延迟和更高的读取请求吞吐量，客户端可以将请求的一致性模式配置为 `serializable` ，该模式可以访问与仲裁相关的过时数据，但消除了线性化访问对实时共识的依赖的性能损失。

### Granting, attaching and revoking leases 授予、附加和撤销租约

etcd provides [a lease mechanism](https://web.stanford.edu/class/cs240/readings/89-leases.pdf). The primary use case of a lease is implementing distributed coordination mechanisms like distributed locks. The lease mechanism itself is simple: a lease can be created with the grant API, attached to a key with the put API, revoked with the revoke API, and will be expired by the wall clock time to live (TTL). However, users need to be aware about [the important properties of the APIs and usage](https://etcd.io/docs/v3.5/learning/why/#notes-on-the-usage-of-lock-and-lease) for implementing correct distributed coordination mechanisms.
etcd 提供了一种租赁机制。租约的主要用例是实现分布式协调机制，如分布式锁。租约机制本身很简单：租约可以使用授权 API 创建，使用 put API  附加到密钥，使用 revoke API 撤销，并将在挂钟生存时间 （TTL） 到期。但是，用户需要了解 API  的重要属性以及实现正确的分布式协调机制的用法。