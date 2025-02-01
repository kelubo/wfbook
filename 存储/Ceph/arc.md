体系结构

# Architecture[](https://docs.ceph.com/en/latest/architecture/#architecture)

[Ceph](https://docs.ceph.com/en/latest/glossary/#term-Ceph) uniquely delivers **object, block, and file storage** in one unified system. Ceph is highly reliable, easy to manage, and free. The power of Ceph can transform your company’s IT infrastructure and your ability to manage vast amounts of data. Ceph delivers extraordinary scalability–thousands of clients accessing petabytes to exabytes of data. A [Ceph Node](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Node) leverages commodity hardware and intelligent daemons, and a [Ceph Storage Cluster](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Storage-Cluster) accommodates large numbers of nodes, which communicate with each other to replicate and redistribute data dynamically.

![../_images/stack.png](https://docs.ceph.com/en/latest/_images/stack.png)



## The Ceph Storage Cluster[](https://docs.ceph.com/en/latest/architecture/#the-ceph-storage-cluster)

Ceph provides an infinitely scalable [Ceph Storage Cluster](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Storage-Cluster) based upon RADOS, which you can read about in [RADOS - A Scalable, Reliable Storage Service for Petabyte-scale Storage Clusters](https://ceph.io/assets/pdfs/weil-rados-pdsw07.pdf).

A Ceph Storage Cluster consists of multiple types of daemons:

- [Ceph Monitor](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Monitor)
- [Ceph OSD Daemon](https://docs.ceph.com/en/latest/glossary/#term-Ceph-OSD-Daemon)
- [Ceph Manager](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Manager)
- [Ceph Metadata Server](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Metadata-Server)

![img](https://docs.ceph.com/en/latest/_images/ditaa-d2b26e342975602e1fa43df2b5dd836dffcdd598.png)

A Ceph Monitor maintains a master copy of the cluster map. A cluster of Ceph monitors ensures high availability should a monitor daemon fail. Storage cluster clients retrieve a copy of the cluster map from the Ceph Monitor.

A Ceph OSD Daemon checks its own state and the state of other OSDs and reports back to monitors.

A Ceph Manager acts as an endpoint for monitoring, orchestration, and plug-in modules.

A Ceph Metadata Server (MDS) manages file metadata when CephFS is used to provide file services.

Storage cluster clients and each [Ceph OSD Daemon](https://docs.ceph.com/en/latest/glossary/#term-Ceph-OSD-Daemon) use the CRUSH algorithm to efficiently compute information about data location, instead of having to depend on a central lookup table. Ceph’s high-level features include a native interface to the Ceph Storage Cluster via `librados`, and a number of service interfaces built on top of `librados`.

### Storing Data[](https://docs.ceph.com/en/latest/architecture/#storing-data)

The Ceph Storage Cluster receives data from [Ceph Client](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Client)s--whether it comes through a [Ceph Block Device](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Block-Device), [Ceph Object Storage](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Object-Storage), the [Ceph File System](https://docs.ceph.com/en/latest/glossary/#term-Ceph-File-System) or a custom implementation you create using `librados`-- which is stored as RADOS objects. Each object is stored on an [Object Storage Device](https://docs.ceph.com/en/latest/glossary/#term-Object-Storage-Device). Ceph OSD Daemons handle read, write, and replication operations on storage drives.  With the older Filestore back end, each RADOS object was stored as a separate file on a conventional filesystem (usually XFS).  With the new and default BlueStore back end, objects are stored in a monolithic database-like fashion.

![img](https://docs.ceph.com/en/latest/_images/ditaa-5a530b3e0aa89fe9a98cf60e943996ec43461eb9.png)

Ceph OSD Daemons store data as objects in a flat namespace (e.g., no hierarchy of directories). An object has an identifier, binary data, and metadata consisting of a set of name/value pairs. The semantics are completely up to [Ceph Client](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Client)s. For example, CephFS uses metadata to store file attributes such as the file owner, created date, last modified date, and so forth.

![img](https://docs.ceph.com/en/latest/_images/ditaa-b363b88681891164d307a947109a7d196e259dc8.png)

Note

An object ID is unique across the entire cluster, not just the local filesystem.



### Scalability and High Availability[](https://docs.ceph.com/en/latest/architecture/#scalability-and-high-availability)

In traditional architectures, clients talk to a centralized component (e.g., a gateway, broker, API, facade, etc.), which acts as a single point of entry to a complex subsystem. This imposes a limit to both performance and scalability, while introducing a single point of failure (i.e., if the centralized component goes down, the whole system goes down, too).

Ceph eliminates the centralized gateway to enable clients to interact with Ceph OSD Daemons directly. Ceph OSD Daemons create object replicas on other Ceph Nodes to ensure data safety and high availability. Ceph also uses a cluster of monitors to ensure high availability. To eliminate centralization, Ceph uses an algorithm called CRUSH.



#### CRUSH Introduction[](https://docs.ceph.com/en/latest/architecture/#crush-introduction)

Ceph Clients and Ceph OSD Daemons both use the CRUSH algorithm to efficiently compute information about object location, instead of having to depend on a central lookup table. CRUSH provides a better data management mechanism compared to older approaches, and enables massive scale by cleanly distributing the work to all the clients and OSD daemons in the cluster. CRUSH uses intelligent data replication to ensure resiliency, which is better suited to hyper-scale storage. The following sections provide additional details on how CRUSH works. For a detailed discussion of CRUSH, see [CRUSH - Controlled, Scalable, Decentralized Placement of Replicated Data](https://ceph.io/assets/pdfs/weil-crush-sc06.pdf).



#### Cluster Map[](https://docs.ceph.com/en/latest/architecture/#cluster-map)

Ceph depends upon Ceph Clients and Ceph OSD Daemons having knowledge of the cluster topology, which is inclusive of 5 maps collectively referred to as the “Cluster Map”:

1. **The Monitor Map:** Contains the cluster `fsid`, the position, name address and port of each monitor. It also indicates the current epoch, when the map was created, and the last time it changed. To view a monitor map, execute `ceph mon dump`.
2. **The OSD Map:** Contains the cluster `fsid`, when the map was created and last modified, a list of pools, replica sizes, PG numbers, a list of OSDs and their status (e.g., `up`, `in`). To view an OSD map, execute `ceph osd dump`.
3. **The PG Map:** Contains the PG version, its time stamp, the last OSD map epoch, the full ratios, and details on each placement group such as the PG ID, the Up Set, the Acting Set, the state of the PG (e.g., `active + clean`), and data usage statistics for each pool.
4. **The CRUSH Map:** Contains a list of storage devices, the failure domain hierarchy (e.g., device, host, rack, row, room, etc.), and rules for traversing the hierarchy when storing data. To view a CRUSH map, execute `ceph osd getcrushmap -o {filename}`; then, decompile it by executing `crushtool -d {comp-crushmap-filename} -o {decomp-crushmap-filename}`. You can view the decompiled map in a text editor or with `cat`.
5. **The MDS Map:** Contains the current MDS map epoch, when the map was created, and the last time it changed. It also contains the pool for storing metadata, a list of metadata servers, and which metadata servers are `up` and `in`. To view an MDS map, execute `ceph fs dump`.

Each map maintains an iterative history of its operating state changes. Ceph Monitors maintain a master copy of the cluster map including the cluster members, state, changes, and the overall health of the Ceph Storage Cluster.



#### High Availability Monitors[](https://docs.ceph.com/en/latest/architecture/#high-availability-monitors)

Before Ceph Clients can read or write data, they must contact a Ceph Monitor to obtain the most recent copy of the cluster map. A Ceph Storage Cluster can operate with a single monitor; however, this introduces a single point of failure (i.e., if the monitor goes down, Ceph Clients cannot read or write data).

For added reliability and fault tolerance, Ceph supports a cluster of monitors. In a cluster of monitors, latency and other faults can cause one or more monitors to fall behind the current state of the cluster. For this reason, Ceph must have agreement among various monitor instances regarding the state of the cluster. Ceph always uses a majority of monitors (e.g., 1, 2:3, 3:5, 4:6, etc.) and the [Paxos](https://en.wikipedia.org/wiki/Paxos_(computer_science)) algorithm to establish a consensus among the monitors about the current state of the cluster.

For details on configuring monitors, see the [Monitor Config Reference](https://docs.ceph.com/en/latest/rados/configuration/mon-config-ref).



#### High Availability Authentication[](https://docs.ceph.com/en/latest/architecture/#high-availability-authentication)

To identify users and protect against man-in-the-middle attacks, Ceph provides its `cephx` authentication system to authenticate users and daemons.

Note

The `cephx` protocol does not address data encryption in transport (e.g., SSL/TLS) or encryption at rest.

Cephx uses shared secret keys for authentication, meaning both the client and the monitor cluster have a copy of the client’s secret key. The authentication protocol is such that both parties are able to prove to each other they have a copy of the key without actually revealing it. This provides mutual authentication, which means the cluster is sure the user possesses the secret key, and the user is sure that the cluster has a copy of the secret key.

A key scalability feature of Ceph is to avoid a centralized interface to the Ceph object store, which means that Ceph clients must be able to interact with OSDs directly. To protect data, Ceph provides its `cephx` authentication system, which authenticates users operating Ceph clients. The `cephx` protocol operates in a manner with behavior similar to [Kerberos](https://en.wikipedia.org/wiki/Kerberos_(protocol)).

A user/actor invokes a Ceph client to contact a monitor. Unlike Kerberos, each monitor can authenticate users and distribute keys, so there is no single point of failure or bottleneck when using `cephx`. The monitor returns an authentication data structure similar to a Kerberos ticket that contains a session key for use in obtaining Ceph services.  This session key is itself encrypted with the user’s permanent  secret key, so that only the user can request services from the Ceph Monitor(s). The client then uses the session key to request its desired services from the monitor, and the monitor provides the client with a ticket that will authenticate the client to the OSDs that actually handle data. Ceph Monitors and OSDs share a secret, so the client can use the ticket provided by the monitor with any OSD or metadata server in the cluster. Like Kerberos, `cephx` tickets expire, so an attacker cannot use an expired ticket or session key obtained surreptitiously. This form of authentication will prevent attackers with access to the communications medium from either creating bogus messages under another user’s identity or altering another user’s legitimate messages, as long as the user’s secret key is not divulged before it expires.

To use `cephx`, an administrator must set up users first. In the following diagram, the `client.admin` user invokes  `ceph auth get-or-create-key` from the command line to generate a username and secret key. Ceph’s `auth` subsystem generates the username and key, stores a copy with the monitor(s) and transmits the user’s secret back to the `client.admin` user. This means that the client and the monitor share a secret key.

Note

The `client.admin` user must provide the user ID and secret key to the user in a secure manner.

![img](https://docs.ceph.com/en/latest/_images/ditaa-98e822f6a4f486de7dc55635f9fb80d356ad931f.png)

To authenticate with the monitor, the client passes in the user name to the monitor, and the monitor generates a session key and encrypts it with the secret key associated to the user name. Then, the monitor transmits the encrypted ticket back to the client. The client then decrypts the payload with the shared secret key to retrieve the session key. The session key identifies the user for the current session. The client then requests a ticket on behalf of the user signed by the session key. The monitor generates a ticket, encrypts it with the user’s secret key and transmits it back to the client. The client decrypts the ticket and uses it to sign requests to OSDs and metadata servers throughout the cluster.

![img](https://docs.ceph.com/en/latest/_images/ditaa-22b3096a0b880cfcdc7995b8d870653c71bd5244.png)

The `cephx` protocol authenticates ongoing communications between the client machine and the Ceph servers. Each message sent between a client and server, subsequent to the initial authentication, is signed using a ticket that the monitors, OSDs and metadata servers can verify with their shared secret.

![img](https://docs.ceph.com/en/latest/_images/ditaa-3a51d20eaaf90e1071e7dc84ea1fd784896d4b99.png)

The protection offered by this authentication is between the Ceph client and the Ceph server hosts. The authentication is not extended beyond the Ceph client. If the user accesses the Ceph client from a remote host, Ceph authentication is not applied to the connection between the user’s host and the client host.

For configuration details, see [Cephx Config Guide](https://docs.ceph.com/en/latest/rados/configuration/auth-config-ref). For user management details, see [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management).



#### Smart Daemons Enable Hyperscale[](https://docs.ceph.com/en/latest/architecture/#smart-daemons-enable-hyperscale)

In many clustered architectures, the primary purpose of cluster membership is so that a centralized interface knows which nodes it can access. Then the centralized interface provides services to the client through a double dispatch--which is a **huge** bottleneck at the petabyte-to-exabyte scale.

Ceph eliminates the bottleneck: Ceph’s OSD Daemons AND Ceph Clients are cluster aware. Like Ceph clients, each Ceph OSD Daemon knows about other Ceph OSD Daemons in the cluster.  This enables Ceph OSD Daemons to interact directly with other Ceph OSD Daemons and Ceph Monitors. Additionally, it enables Ceph Clients to interact directly with Ceph OSD Daemons.

The ability of Ceph Clients, Ceph Monitors and Ceph OSD Daemons to interact with each other means that Ceph OSD Daemons can utilize the CPU and RAM of the Ceph nodes to easily perform tasks that would bog down a centralized server. The ability to leverage this computing power leads to several major benefits:

1. **OSDs Service Clients Directly:** Since any network device has a limit to the number of concurrent connections it can support, a centralized system has a low physical limit at high scales. By enabling Ceph Clients to contact Ceph OSD Daemons directly, Ceph increases both performance and total system capacity simultaneously, while removing a single point of failure. Ceph Clients can maintain a session when they need to, and with a particular Ceph OSD Daemon instead of a centralized server.

2. **OSD Membership and Status**: Ceph OSD Daemons join a cluster and report on their status. At the lowest level, the Ceph OSD Daemon status is `up` or `down` reflecting whether or not it is running and able to service Ceph Client requests. If a Ceph OSD Daemon is `down` and `in` the Ceph Storage Cluster, this status may indicate the failure of the Ceph OSD Daemon. If a Ceph OSD Daemon is not running (e.g., it crashes), the Ceph OSD Daemon cannot notify the Ceph Monitor that it is `down`. The OSDs periodically send messages to the Ceph Monitor (`MPGStats` pre-luminous, and a new `MOSDBeacon` in luminous).  If the Ceph Monitor doesn’t see that message after a configurable period of time then it marks the OSD down. This mechanism is a failsafe, however. Normally, Ceph OSD Daemons will determine if a neighboring OSD is down and report it to the Ceph Monitor(s). This assures that Ceph Monitors are lightweight processes.  See [Monitoring OSDs](https://docs.ceph.com/en/latest/rados/operations/monitoring-osd-pg/#monitoring-osds) and [Heartbeats](https://docs.ceph.com/en/latest/rados/configuration/mon-osd-interaction) for additional details.

3. **Data Scrubbing:** As part of maintaining data consistency and cleanliness, Ceph OSD Daemons can scrub objects. That is, Ceph OSD Daemons can compare their local objects metadata with its replicas stored on other OSDs. Scrubbing happens on a per-Placement Group base. Scrubbing (usually performed daily) catches mismatches in size and other metadata. Ceph OSD Daemons also perform deeper scrubbing by comparing data in objects bit-for-bit with their checksums. Deep scrubbing (usually performed weekly) finds bad sectors on a drive that weren’t apparent in a light scrub. See [Data Scrubbing](https://docs.ceph.com/en/latest/rados/configuration/osd-config-ref#scrubbing) for details on configuring scrubbing.

4. **Replication:** Like Ceph Clients, Ceph OSD Daemons use the CRUSH algorithm, but the Ceph OSD Daemon uses it to compute where replicas of objects should be stored (and for rebalancing). In a typical write scenario, a client uses the CRUSH algorithm to compute where to store an object, maps the object to a pool and placement group, then looks at the CRUSH map to identify the primary OSD for the placement group.

   The client writes the object to the identified placement group in the primary OSD. Then, the primary OSD with its own copy of the CRUSH map identifies the secondary and tertiary OSDs for replication purposes, and replicates the object to the appropriate placement groups in the secondary and tertiary OSDs (as many OSDs as additional replicas), and responds to the client once it has confirmed the object was stored successfully.

![img](https://docs.ceph.com/en/latest/_images/ditaa-accd039a93bf169d612159bd97189a33faa6d914.png)

With the ability to perform data replication, Ceph OSD Daemons relieve Ceph clients from that duty, while ensuring high data availability and data safety.

### Dynamic Cluster Management[](https://docs.ceph.com/en/latest/architecture/#dynamic-cluster-management)

In the [Scalability and High Availability](https://docs.ceph.com/en/latest/architecture/#scalability-and-high-availability) section, we explained how Ceph uses CRUSH, cluster awareness and intelligent daemons to scale and maintain high availability. Key to Ceph’s design is the autonomous, self-healing, and intelligent Ceph OSD Daemon. Let’s take a deeper look at how CRUSH works to enable modern cloud storage infrastructures to place data, rebalance the cluster and recover from faults dynamically.



#### About Pools[](https://docs.ceph.com/en/latest/architecture/#about-pools)

The Ceph storage system supports the notion of ‘Pools’, which are logical partitions for storing objects.

Ceph Clients retrieve a [Cluster Map](https://docs.ceph.com/en/latest/architecture/#cluster-map) from a Ceph Monitor, and write objects to pools. The pool’s `size` or number of replicas, the CRUSH rule and the number of placement groups determine how Ceph will place the data.

![img](https://docs.ceph.com/en/latest/_images/ditaa-740d576a80d28d8482b9c550c6aa120b958be46d.png)

Pools set at least the following parameters:

- Ownership/Access to Objects
- The Number of Placement Groups, and
- The CRUSH Rule to Use.

See [Set Pool Values](https://docs.ceph.com/en/latest/rados/operations/pools#set-pool-values) for details.

#### Mapping PGs to OSDs[](https://docs.ceph.com/en/latest/architecture/#mapping-pgs-to-osds)

Each pool has a number of placement groups. CRUSH maps PGs to OSDs dynamically. When a Ceph Client stores objects, CRUSH will map each object to a placement group.

Mapping objects to placement groups creates a layer of indirection between the Ceph OSD Daemon and the Ceph Client. The Ceph Storage Cluster must be able to grow (or shrink) and rebalance where it stores objects dynamically. If the Ceph Client “knew” which Ceph OSD Daemon had which object, that would create a tight coupling between the Ceph Client and the Ceph OSD Daemon. Instead, the CRUSH algorithm maps each object to a placement group and then maps each placement group to one or more Ceph OSD Daemons. This layer of indirection allows Ceph to rebalance dynamically when new Ceph OSD Daemons and the underlying OSD devices come online. The following diagram depicts how CRUSH maps objects to placement groups, and placement groups to OSDs.

![img](https://docs.ceph.com/en/latest/_images/ditaa-45f879e97a08c72aa96aa7c7b94f465611ff941b.png)

With a copy of the cluster map and the CRUSH algorithm, the client can compute exactly which OSD to use when reading or writing a particular object.



#### Calculating PG IDs[](https://docs.ceph.com/en/latest/architecture/#calculating-pg-ids)

When a Ceph Client binds to a Ceph Monitor, it retrieves the latest copy of the [Cluster Map](https://docs.ceph.com/en/latest/architecture/#cluster-map). With the cluster map, the client knows about all of the monitors, OSDs, and metadata servers in the cluster. **However, it doesn’t know anything about object locations.**

> Object locations get computed.

The only input required by the client is the object ID and the pool. It’s simple: Ceph stores data in named pools (e.g., “liverpool”). When a client wants to store a named object (e.g., “john,” “paul,” “george,” “ringo”, etc.) it calculates a placement group using the object name, a hash code, the number of PGs in the pool and the pool name. Ceph clients use the following steps to compute PG IDs.

1. The client inputs the pool name and the object ID. (e.g., pool = “liverpool” and object-id = “john”)
2. Ceph takes the object ID and hashes it.
3. Ceph calculates the hash modulo the number of PGs. (e.g., `58`) to get a PG ID.
4. Ceph gets the pool ID given the pool name (e.g., “liverpool” = `4`)
5. Ceph prepends the pool ID to the PG ID (e.g., `4.58`).

Computing object locations is much faster than performing object location query over a chatty session. The CRUSH algorithm allows a client to compute where objects *should* be stored, and enables the client to contact the primary OSD to store or retrieve the objects.



#### Peering and Sets[](https://docs.ceph.com/en/latest/architecture/#peering-and-sets)

In previous sections, we noted that Ceph OSD Daemons check each other’s heartbeats and report back to the Ceph Monitor. Another thing Ceph OSD daemons do is called ‘peering’, which is the process of bringing all of the OSDs that store a Placement Group (PG) into agreement about the state of all of the objects (and their metadata) in that PG. In fact, Ceph OSD Daemons [Report Peering Failure](https://docs.ceph.com/en/latest/rados/configuration/mon-osd-interaction#osds-report-peering-failure) to the Ceph Monitors. Peering issues  usually resolve themselves; however, if the problem persists, you may need to refer to the [Troubleshooting Peering Failure](https://docs.ceph.com/en/latest/rados/troubleshooting/troubleshooting-pg#placement-group-down-peering-failure) section.

Note

Agreeing on the state does not mean that the PGs have the latest contents.

The Ceph Storage Cluster was designed to store at least two copies of an object (i.e., `size = 2`), which is the minimum requirement for data safety. For high availability, a Ceph Storage Cluster should store more than two copies of an object (e.g., `size = 3` and `min size = 2`) so that it can continue to run in a `degraded` state while maintaining data safety.

Referring back to the diagram in [Smart Daemons Enable Hyperscale](https://docs.ceph.com/en/latest/architecture/#smart-daemons-enable-hyperscale), we do not name the Ceph OSD Daemons specifically (e.g., `osd.0`, `osd.1`, etc.), but rather refer to them as *Primary*, *Secondary*, and so forth. By convention, the *Primary* is the first OSD in the *Acting Set*, and is responsible for coordinating the peering process for each placement group where it acts as the *Primary*, and is the **ONLY** OSD that will accept client-initiated writes to objects for a given placement group where it acts as the *Primary*.

When a series of OSDs are responsible for a placement group, that series of OSDs, we refer to them as an *Acting Set*. An *Acting Set* may refer to the Ceph OSD Daemons that are currently responsible for the placement group, or the Ceph OSD Daemons that were responsible  for a particular placement group as of some epoch.

The Ceph OSD daemons that are part of an *Acting Set* may not always be  `up`. When an OSD in the *Acting Set* is `up`, it is part of the  *Up Set*. The *Up Set* is an important distinction, because Ceph can remap PGs to other Ceph OSD Daemons when an OSD fails.

Note

In an *Acting Set* for a PG containing `osd.25`, `osd.32` and `osd.61`, the first OSD, `osd.25`, is the *Primary*. If that OSD fails, the Secondary, `osd.32`, becomes the *Primary*, and `osd.25` will be removed from the *Up Set*.



#### Rebalancing[](https://docs.ceph.com/en/latest/architecture/#rebalancing)

When you add a Ceph OSD Daemon to a Ceph Storage Cluster, the cluster map gets updated with the new OSD. Referring back to [Calculating PG IDs](https://docs.ceph.com/en/latest/architecture/#calculating-pg-ids), this changes the cluster map. Consequently, it changes object placement, because it changes an input for the calculations. The following diagram depicts the rebalancing process (albeit rather crudely, since it is substantially less impactful with large clusters) where some, but not all of the PGs migrate from existing OSDs (OSD 1, and OSD 2) to the new OSD (OSD 3). Even when rebalancing, CRUSH is stable. Many of the placement groups remain in their original configuration, and each OSD gets some added capacity, so there are no load spikes on the new OSD after rebalancing is complete.

![img](https://docs.ceph.com/en/latest/_images/ditaa-cb68a3f796f66334ea3d88390052d4c06d98028b.png)



#### Data Consistency[](https://docs.ceph.com/en/latest/architecture/#data-consistency)

As part of maintaining data consistency and cleanliness, Ceph OSDs also scrub objects within placement groups. That is, Ceph OSDs compare object metadata in one placement group with its replicas in placement groups stored in other OSDs. Scrubbing (usually performed daily) catches OSD bugs or filesystem errors, often as a result of hardware issues.  OSDs also perform deeper scrubbing by comparing data in objects bit-for-bit.  Deep scrubbing (by default performed weekly) finds bad blocks on a drive that weren’t apparent in a light scrub.

See [Data Scrubbing](https://docs.ceph.com/en/latest/rados/configuration/osd-config-ref#scrubbing) for details on configuring scrubbing.



### Erasure Coding[](https://docs.ceph.com/en/latest/architecture/#erasure-coding)

An erasure coded pool stores each object as `K+M` chunks. It is divided into `K` data chunks and `M` coding chunks. The pool is configured to have a size of `K+M` so that each chunk is stored in an OSD in the acting set. The rank of the chunk is stored as an attribute of the object.

For instance an erasure coded pool can be created to use five OSDs (`K+M = 5`) and sustain the loss of two of them (`M = 2`).

#### Reading and Writing Encoded Chunks[](https://docs.ceph.com/en/latest/architecture/#reading-and-writing-encoded-chunks)

When the object **NYAN** containing `ABCDEFGHI` is written to the pool, the erasure encoding function splits the content into three data chunks simply by dividing the content in three: the first contains `ABC`, the second `DEF` and the last `GHI`. The content will be padded if the content length is not a multiple of `K`. The function also creates two coding chunks: the fourth with `YXY` and the fifth with `QGC`. Each chunk is stored in an OSD in the acting set. The chunks are stored in objects that have the same name (**NYAN**) but reside on different OSDs. The order in which the chunks were created must be preserved and is stored as an attribute of the object (`shard_t`), in addition to its name. Chunk 1 contains `ABC` and is stored on **OSD5** while chunk 4 contains `YXY` and is stored on **OSD3**.

![img](https://docs.ceph.com/en/latest/_images/ditaa-86952ee961bd79c367ecd85023e44450c2b55b0d.png)

When the object **NYAN** is read from the erasure coded pool, the decoding function reads three chunks: chunk 1 containing `ABC`, chunk 3 containing `GHI` and chunk 4 containing `YXY`. Then, it rebuilds the original content of the object `ABCDEFGHI`. The decoding function is informed that the chunks 2 and 5 are missing (they are called ‘erasures’). The chunk 5 could not be read because the **OSD4** is out. The decoding function can be called as soon as three chunks are read: **OSD2** was the slowest and its chunk was not taken into account.

![img](https://docs.ceph.com/en/latest/_images/ditaa-fea104af11f5649826e45dee02f199165d3e5092.png)

#### Interrupted Full Writes[](https://docs.ceph.com/en/latest/architecture/#interrupted-full-writes)

In an erasure coded pool, the primary OSD in the up set receives all write operations. It is responsible for encoding the payload into `K+M` chunks and sends them to the other OSDs. It is also responsible for maintaining an authoritative version of the placement group logs.

In the following diagram, an erasure coded placement group has been created with `K = 2, M = 1` and is supported by three OSDs, two for `K` and one for `M`. The acting set of the placement group is made of **OSD 1**, **OSD 2** and **OSD 3**. An object has been encoded and stored in the OSDs : the chunk `D1v1` (i.e. Data chunk number 1, version 1) is on **OSD 1**, `D2v1` on **OSD 2** and `C1v1` (i.e. Coding chunk number 1, version 1) on **OSD 3**. The placement group logs on each OSD are identical (i.e. `1,1` for epoch 1, version 1).

![img](https://docs.ceph.com/en/latest/_images/ditaa-d4d4679be8341ec82717feaa06874b83a1b50772.png)

**OSD 1** is the primary and receives a **WRITE FULL** from a client, which means the payload is to replace the object entirely instead of overwriting a portion of it. Version 2 (v2) of the object is created to override version 1 (v1). **OSD 1** encodes the payload into three chunks: `D1v2` (i.e. Data chunk number 1 version 2) will be on **OSD 1**, `D2v2` on **OSD 2** and `C1v2` (i.e. Coding chunk number 1 version 2) on **OSD 3**. Each chunk is sent to the target OSD, including the primary OSD which is responsible for storing chunks in addition to handling write operations and maintaining an authoritative version of the placement group logs. When an OSD receives the message instructing it to write the chunk, it also creates a new entry in the placement group logs to reflect the change. For instance, as soon as **OSD 3** stores `C1v2`, it adds the entry `1,2` ( i.e. epoch 1, version 2 ) to its logs. Because the OSDs work asynchronously, some chunks may still be in flight ( such as `D2v2` ) while others are acknowledged and persisted to storage drives (such as `C1v1` and `D1v1`).

![img](https://docs.ceph.com/en/latest/_images/ditaa-e95fd29465a1576fc8d93ba2b001bb8f5ac057fc.png)

If all goes well, the chunks are acknowledged on each OSD in the acting set and the logs’ `last_complete` pointer can move from `1,1` to `1,2`.

![img](https://docs.ceph.com/en/latest/_images/ditaa-4bec55e3eed07c19b6bae77130bd06eb98d6e060.png)

Finally, the files used to store the chunks of the previous version of the object can be removed: `D1v1` on **OSD 1**, `D2v1` on **OSD 2** and `C1v1` on **OSD 3**.

![img](https://docs.ceph.com/en/latest/_images/ditaa-fd31eddeb770839cf3ef48a629d2b5bb5eb3ddb5.png)

But accidents happen. If **OSD 1** goes down while `D2v2` is still in flight, the object’s version 2 is partially written: **OSD 3** has one chunk but that is not enough to recover. It lost two chunks: `D1v2` and `D2v2` and the erasure coding parameters `K = 2`, `M = 1` require that at least two chunks are available to rebuild the third. **OSD 4** becomes the new primary and finds that the `last_complete` log entry (i.e., all objects before this entry were known to be available on all OSDs in the previous acting set ) is `1,1` and that will be the head of the new authoritative log.

![img](https://docs.ceph.com/en/latest/_images/ditaa-fa0be989e5935a287c921aedead28b09bc2946c4.png)

The log entry 1,2 found on **OSD 3** is divergent from the new authoritative log provided by **OSD 4**: it is discarded and the file containing the `C1v2` chunk is removed. The `D1v1` chunk is rebuilt with the `decode` function of the erasure coding library during scrubbing and stored on the new primary **OSD 4**.

![img](https://docs.ceph.com/en/latest/_images/ditaa-4d35f7a15d582e30a7b2fa61613bd3626b9348cd.png)

See [Erasure Code Notes](https://github.com/ceph/ceph/blob/40059e12af88267d0da67d8fd8d9cd81244d8f93/doc/dev/osd_internals/erasure_coding/developer_notes.rst) for additional details.

### Cache Tiering[](https://docs.ceph.com/en/latest/architecture/#cache-tiering)

A cache tier provides Ceph Clients with better I/O performance for a subset of the data stored in a backing storage tier. Cache tiering involves creating a pool of relatively fast/expensive storage devices (e.g., solid state drives) configured to act as a cache tier, and a backing pool of either erasure-coded or relatively slower/cheaper devices configured to act as an economical storage tier. The Ceph objecter handles where to place the objects and the tiering agent determines when to flush objects from the cache to the backing storage tier. So the cache tier and the backing storage tier are completely transparent to Ceph clients.

![img](https://docs.ceph.com/en/latest/_images/ditaa-644de96be5ceeacfe47c2ad4fd6748a1bc13f928.png)

See [Cache Tiering](https://docs.ceph.com/en/latest/rados/operations/cache-tiering) for additional details.  Note that Cache Tiers can be tricky and their use is now discouraged.



### Extending Ceph[](https://docs.ceph.com/en/latest/architecture/#extending-ceph)

You can extend Ceph by creating shared object classes called ‘Ceph Classes’. Ceph loads `.so` classes stored in the `osd class dir` directory dynamically (i.e., `$libdir/rados-classes` by default). When you implement a class, you can create new object methods that have the ability to call the native methods in the Ceph Object Store, or other class methods you incorporate via libraries or create yourself.

On writes, Ceph Classes can call native or class methods, perform any series of operations on the inbound data and generate a resulting write transaction  that Ceph will apply atomically.

On reads, Ceph Classes can call native or class methods, perform any series of operations on the outbound data and return the data to the client.

Ceph Class Example

A Ceph class for a content management system that presents pictures of a particular size and aspect ratio could take an inbound bitmap image, crop it to a particular aspect ratio, resize it and embed an invisible copyright or watermark to help protect the intellectual property; then, save the resulting bitmap image to the object store.

See `src/objclass/objclass.h`, `src/fooclass.cc` and `src/barclass` for exemplary implementations.

### Summary[](https://docs.ceph.com/en/latest/architecture/#summary)

Ceph Storage Clusters are dynamic--like a living organism. Whereas, many storage appliances do not fully utilize the CPU and RAM of a typical commodity server, Ceph does. From heartbeats, to  peering, to rebalancing the cluster or recovering from faults,  Ceph offloads work from clients (and from a centralized gateway which doesn’t exist in the Ceph architecture) and uses the computing power of the OSDs to perform the work. When referring to [Hardware Recommendations](https://docs.ceph.com/en/latest/start/hardware-recommendations) and the [Network Config Reference](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref),  be cognizant of the foregoing concepts to understand how Ceph utilizes computing resources.



## Ceph Protocol[](https://docs.ceph.com/en/latest/architecture/#ceph-protocol)

Ceph Clients use the native protocol for interacting with the Ceph Storage Cluster. Ceph packages this functionality into the `librados` library so that you can create your own custom Ceph Clients. The following diagram depicts the basic architecture.

![img](https://docs.ceph.com/en/latest/_images/ditaa-2fb9b073781e561c4947b74687285560dde591af.png)

### Native Protocol and `librados`[](https://docs.ceph.com/en/latest/architecture/#native-protocol-and-librados)

Modern applications need a simple object storage interface with asynchronous communication capability. The Ceph Storage Cluster provides a simple object storage interface with asynchronous communication capability. The interface provides direct, parallel access to objects throughout the cluster.

- Pool Operations
- Snapshots and Copy-on-write Cloning
- Read/Write Objects - Create or Remove - Entire Object or Byte Range - Append or Truncate
- Create/Set/Get/Remove XATTRs
- Create/Set/Get/Remove Key/Value Pairs
- Compound operations and dual-ack semantics
- Object Classes



### Object Watch/Notify[](https://docs.ceph.com/en/latest/architecture/#object-watch-notify)

A client can register a persistent interest with an object and keep a session to the primary OSD open. The client can send a notification message and a payload to all watchers and receive notification when the watchers receive the notification. This enables a client to use any object as a synchronization/communication channel.

![img](https://docs.ceph.com/en/latest/_images/ditaa-3ff59492315938be9210b21c160a9df66df0bdbe.png)



### Data Striping[](https://docs.ceph.com/en/latest/architecture/#data-striping)

Storage devices have throughput limitations, which impact performance and scalability. So storage systems often support [striping](https://en.wikipedia.org/wiki/Data_striping)--storing sequential pieces of information across multiple storage devices--to increase throughput and performance. The most common form of data striping comes from [RAID](https://en.wikipedia.org/wiki/RAID). The RAID type most similar to Ceph’s striping is [RAID 0](https://en.wikipedia.org/wiki/RAID_0#RAID_0), or a ‘striped volume’. Ceph’s striping offers the throughput of RAID 0 striping, the reliability of n-way RAID mirroring and faster recovery.

Ceph provides three types of clients: Ceph Block Device, Ceph File System, and Ceph Object Storage. A Ceph Client converts its data from the representation format it provides to its users (a block device image, RESTful objects, CephFS filesystem directories) into objects for storage in the Ceph Storage Cluster.

Tip

The objects Ceph stores in the Ceph Storage Cluster are not striped. Ceph Object Storage, Ceph Block Device, and the Ceph File System stripe their data over multiple Ceph Storage Cluster objects. Ceph Clients that write directly to the Ceph Storage Cluster via `librados` must perform the striping (and parallel I/O) for themselves to obtain these benefits.

The simplest Ceph striping format involves a stripe count of 1 object. Ceph Clients write stripe units to a Ceph Storage Cluster object until the object is at its maximum capacity, and then create another object for additional stripes of data. The simplest form of striping may be sufficient for small block device images, S3 or Swift objects and CephFS files. However, this simple form doesn’t take maximum advantage of Ceph’s ability to distribute data across placement groups, and consequently doesn’t improve performance very much. The following diagram depicts the simplest form of striping:

![img](https://docs.ceph.com/en/latest/_images/ditaa-609b2033fcdfa0a95b663189cc63db38953866a1.png)

If you anticipate large images sizes, large S3 or Swift objects (e.g., video), or large CephFS directories, you may see considerable read/write performance improvements by striping client data over multiple objects within an object set. Significant write performance occurs when the client writes the stripe units to their corresponding objects in parallel. Since objects get mapped to different placement groups and further mapped to different OSDs, each write occurs in parallel at the maximum write speed. A write to a single drive would be limited by the head movement (e.g. 6ms per seek) and bandwidth of that one device (e.g. 100MB/s).  By spreading that write over multiple objects (which map to different placement groups and OSDs) Ceph can reduce the number of seeks per drive and combine the throughput of multiple drives to achieve much faster write (or read) speeds.

Note

Striping is independent of object replicas. Since CRUSH replicates objects across OSDs, stripes get replicated automatically.

In the following diagram, client data gets striped across an object set (`object set 1` in the following diagram) consisting of 4 objects, where the first stripe unit is `stripe unit 0` in `object 0`, and the fourth stripe unit is `stripe unit 3` in `object 3`. After writing the fourth stripe, the client determines if the object set is full. If the object set is not full, the client begins writing a stripe to the first object again (`object 0` in the following diagram). If the object set is full, the client creates a new object set (`object set 2` in the following diagram), and begins writing to the first stripe (`stripe unit 16`) in the first object in the new object set (`object 4` in the diagram below).

![img](https://docs.ceph.com/en/latest/_images/ditaa-96a6fc80dad17fb53f161987ed64f0779930ffe1.png)

Three important variables determine how Ceph stripes data:

- **Object Size:** Objects in the Ceph Storage Cluster have a maximum configurable size (e.g., 2MB, 4MB, etc.). The object size should be large enough to accommodate many stripe units, and should be a multiple of the stripe unit.
- **Stripe Width:** Stripes have a configurable unit size (e.g., 64kb). The Ceph Client divides the data it will write to objects into equally sized stripe units, except for the last stripe unit. A stripe width, should be a fraction of the Object Size so that an object may contain many stripe units.
- **Stripe Count:** The Ceph Client writes a sequence of stripe units over a series of objects determined by the stripe count. The series of objects is called an object set. After the Ceph Client writes to the last object in the object set, it returns to the first object in the object set.

Important

Test the performance of your striping configuration before putting your cluster into production. You CANNOT change these striping parameters after you stripe the data and write it to objects.

Once the Ceph Client has striped data to stripe units and mapped the stripe units to objects, Ceph’s CRUSH algorithm maps the objects to placement groups, and the placement groups to Ceph OSD Daemons before the objects are stored as files on a storage drive.

Note

Since a client writes to a single pool, all data striped into objects get mapped to placement groups in the same pool. So they use the same CRUSH map and the same access controls.



## Ceph Clients[](https://docs.ceph.com/en/latest/architecture/#ceph-clients)

Ceph Clients include a number of service interfaces. These include:

- **Block Devices:** The [Ceph Block Device](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Block-Device) (a.k.a., RBD) service provides resizable, thin-provisioned block devices with snapshotting and cloning. Ceph stripes a block device across the cluster for high performance. Ceph supports both kernel objects (KO) and a QEMU hypervisor that uses `librbd` directly--avoiding the kernel object overhead for virtualized systems.
- **Object Storage:** The [Ceph Object Storage](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Object-Storage) (a.k.a., RGW) service provides RESTful APIs with interfaces that are compatible with Amazon S3 and OpenStack Swift.
- **Filesystem**: The [Ceph File System](https://docs.ceph.com/en/latest/glossary/#term-Ceph-File-System) (CephFS) service provides a POSIX compliant filesystem usable with `mount` or as a filesystem in user space (FUSE).

Ceph can run additional instances of OSDs, MDSs, and monitors for scalability and high availability. The following diagram depicts the high-level architecture.

![img](https://docs.ceph.com/en/latest/_images/ditaa-0ec10ee2b26b2d5abfa8614819a0934ef41c4cc5.png)



### Ceph Object Storage[](https://docs.ceph.com/en/latest/architecture/#ceph-object-storage)

The Ceph Object Storage daemon, `radosgw`, is a FastCGI service that provides a [RESTful](https://en.wikipedia.org/wiki/RESTful) HTTP API to store objects and metadata. It layers on top of the Ceph Storage Cluster with its own data formats, and maintains its own user database, authentication, and access control. The RADOS Gateway uses a unified namespace, which means you can use either the OpenStack Swift-compatible API or the Amazon S3-compatible API. For example, you can write data using the S3-compatible API with one application and then read data using the Swift-compatible API with another application.

S3/Swift Objects and Store Cluster Objects Compared

Ceph’s Object Storage uses the term *object* to describe the data it stores. S3 and Swift objects are not the same as the objects that Ceph writes to the Ceph Storage Cluster. Ceph Object Storage objects are mapped to Ceph Storage Cluster objects. The S3 and Swift objects do not necessarily correspond in a 1:1 manner with an object stored in the storage cluster. It is possible for an S3 or Swift object to map to multiple Ceph objects.

See [Ceph Object Storage](https://docs.ceph.com/en/latest/radosgw/) for details.



### Ceph Block Device[](https://docs.ceph.com/en/latest/architecture/#ceph-block-device)

A Ceph Block Device stripes a block device image over multiple objects in the Ceph Storage Cluster, where each object gets mapped to a placement group and distributed, and the placement groups are spread across separate `ceph-osd` daemons throughout the cluster.

Important

Striping allows RBD block devices to perform better than a single server could!

Thin-provisioned snapshottable Ceph Block Devices are an attractive option for virtualization and cloud computing. In virtual machine scenarios, people typically deploy a Ceph Block Device with the `rbd` network storage driver in QEMU/KVM, where the host machine uses `librbd` to provide a block device service to the guest. Many cloud computing stacks use `libvirt` to integrate with hypervisors. You can use thin-provisioned Ceph Block Devices with QEMU and `libvirt` to support OpenStack and CloudStack among other solutions.

While we do not provide `librbd` support with other hypervisors at this time, you may also use Ceph Block Device kernel objects to provide a block device to a client. Other virtualization technologies such as Xen can access the Ceph Block Device kernel object(s). This is done with the  command-line tool `rbd`.



### Ceph File System[](https://docs.ceph.com/en/latest/architecture/#ceph-file-system)

The Ceph File System (CephFS) provides a POSIX-compliant filesystem as a service that is layered on top of the object-based Ceph Storage Cluster. CephFS files get mapped to objects that Ceph stores in the Ceph Storage Cluster. Ceph Clients mount a CephFS filesystem as a kernel object or as a Filesystem in User Space (FUSE).

![img](https://docs.ceph.com/en/latest/_images/ditaa-a3cf58afeea95c637ca2c94368599627b433c4ff.png)

The Ceph File System service includes the Ceph Metadata Server (MDS) deployed with the Ceph Storage cluster. The purpose of the MDS is to store all the filesystem metadata (directories, file ownership, access modes, etc) in high-availability Ceph Metadata Servers where the metadata resides in memory. The reason for the MDS (a daemon called `ceph-mds`) is that simple filesystem operations like listing a directory or changing a directory (`ls`, `cd`) would tax the Ceph OSD Daemons unnecessarily. So separating the metadata from the data means that the Ceph File System can provide high performance services without taxing the Ceph Storage Cluster.

CephFS separates the metadata from the data, storing the metadata in the MDS, and storing the file data in one or more objects in the Ceph Storage Cluster. The Ceph filesystem aims for POSIX compatibility. `ceph-mds` can run as a single process, or it can be distributed out to multiple physical machines, either for high availability or for scalability.

- **High Availability**: The extra `ceph-mds` instances can be standby, ready to take over the duties of any failed `ceph-mds` that was active. This is easy because all the data, including the journal, is stored on RADOS. The transition is triggered automatically by `ceph-mon`.
- **Scalability**: Multiple `ceph-mds` instances can be active, and they will split the directory tree into subtrees (and shards of a single busy directory), effectively balancing the load amongst all active servers.

Combinations of standby and active etc are possible, for example running 3 active `ceph-mds` instances for scaling, and one standby instance for high availability.



Ceph 独一无二地用统一的系统提供了**对象、块、和文件存储**功能，它可靠性高、管理简便、并且是自由软件。 Ceph 的强大足以改变贵公司的 IT 基础架构、和管理海量数据的能力。Ceph 可提供极大的伸缩性——供成千用户访问 PB 乃至 EB 级的数据。 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)以普通硬件和智能守护进程作为支撑点， [*Ceph 存储集群*](http://docs.ceph.org.cn/glossary/#term-21)组织起了大量节点，它们之间靠相互通讯来复制数据、并动态地重分布数据。

![../_images/stack.png](http://docs.ceph.org.cn/_images/stack.png)

## Ceph 存储集群

Ceph 提供了一个可无限伸缩的 [*Ceph 存储集群*](http://docs.ceph.org.cn/glossary/#term-21)，它基于 RADOS ，见论文 [RADOS - A Scalable, Reliable Storage Service for Petabyte-scale Storage Clusters](http://ceph.com/papers/weil-rados-pdsw07.pdf) 。

Ceph 存储集群包含两种类型的守护进程：

- [*Ceph 监视器*](http://docs.ceph.org.cn/glossary/#term-59)
- [*Ceph OSD 守护进程*](http://docs.ceph.org.cn/glossary/#term-56)

![img](http://docs.ceph.org.cn/_images/ditaa-4cf6d0983521ea66cd16f98b7ce624e6666eed77.png)

Ceph 监视器维护着集群运行图的主副本。一个监视器集群确保了当某个监视器失效时的高可用性。存储集群客户端向 Ceph 监视器索取集群运行图的最新副本。

Ceph OSD 守护进程检查自身状态、以及其它 OSD 的状态，并报告给监视器们。

存储集群的客户端和各个 [*Ceph OSD 守护进程*](http://docs.ceph.org.cn/glossary/#term-56)使用 CRUSH 算法高效地计算数据位置，而不是依赖于一个中心化的查询表。它的高级功能包括：基于 `librados`的原生存储接口、和多种基于 `librados` 的服务接口。

### 数据的存储

Ceph 存储集群从 [*Ceph 客户端*](http://docs.ceph.org.cn/glossary/#term-67)接收数据——不管是来自 [*Ceph 块设备*](http://docs.ceph.org.cn/glossary/#term-38)、 [*Ceph 对象存储*](http://docs.ceph.org.cn/glossary/#term-30)、 [*Ceph 文件系统*](http://docs.ceph.org.cn/glossary/#term-45)、还是基于 `librados` 的自定义实现——并存储为对象。每个对象是文件系统中的一个文件，它们存储在[*对象存储设备*](http://docs.ceph.org.cn/glossary/#term-52)上。由 Ceph OSD 守护进程处理存储设备上的读/写操作。

![img](http://docs.ceph.org.cn/_images/ditaa-518f1eba573055135eb2f6568f8b69b4bb56b4c8.png)

Ceph OSD 在扁平的命名空间内把所有数据存储为对象（也就是没有目录层次）。对象包含一个标识符、二进制数据、和由名字/值对组成的元数据，元数据语义完全取决于 [*Ceph 客户端*](http://docs.ceph.org.cn/glossary/#term-67)。例如， CephFS 用元数据存储文件属性，如文件所有者、创建日期、最后修改日期等等。

![img](http://docs.ceph.org.cn/_images/ditaa-ae8b394e1d31afd181408bab946ca4a216ca44b7.png)

Note

一个对象 ID 不止在本地唯一 ，它在整个集群内都是唯一的。



### 伸缩性和高可用性

在传统架构里，客户端与一个中心化的组件通信（如网关、中间件、 API 、前端等等），它作为一个复杂子系统的唯一入口，它引入单故障点的同时，也限制了性能和伸缩性（就是说如果中心化组件挂了，整个系统就挂了）。

Ceph 消除了集中网关，允许客户端直接和 Ceph OSD 守护进程通讯。 Ceph OSD 守护进程自动在其它 Ceph  节点上创建对象副本来确保数据安全和高可用性；为保证高可用性，监视器也实现了集群化。为消除中心节点， Ceph 使用了 CRUSH 算法。



#### CRUSH 简介

Ceph 客户端和 OSD 守护进程都用 CRUSH 算法来计算对象的位置信息，而不是依赖于一个中心化的查询表。与以往方法相比， CRUSH  的数据管理机制更好，它很干脆地把工作分配给集群内的所有客户端和 OSD 来处理，因此具有极大的伸缩性。 CRUSH  用智能数据复制确保弹性，更能适应超大规模存储。下列几段描述了 CRUSH 如何工作，更详细的机制请参阅论文： [CRUSH - 可控、可伸缩、分布式地归置多副本数据](http://ceph.com/papers/weil-crush-sc06.pdf) 。



#### 集群运行图

Ceph 依赖于 Ceph 客户端和 OSD ，因为它们知道集群的拓扑，这个拓扑由 5 张图共同描述，统称为“集群运行图”：

1. **Montior Map：** 包含集群的 `fsid` 、位置、名字、地址和端口，也包括当前版本、创建时间、最近修改时间。要查看监视器图，用 `ceph mon dump` 命令。
2. **OSD Map：** 包含集群 `fsid` 、创建时间、最近修改时间、存储池列表、副本数量、归置组数量、 OSD 列表及其状态（如 `up` 、 `in` ）。要查看OSD运行图，用 `ceph osd dump` 命令。
3. **PG Map：**：** 包含归置组版本、其时间戳、最新的 OSD 运行图版本、占满率、以及各归置组详情，像归置组 ID 、 up set 、 acting set 、 PG 状态（如 `active+clean` ），和各存储池的数据使用情况统计。
4. **CRUSH Map：**：** 包含存储设备列表、故障域树状结构（如设备、主机、机架、行、房间、等等）、和存储数据时如何利用此树状结构的规则。要查看 CRUSH 规则，执行 `ceph osd getcrushmap -o {filename}` 命令；然后用 `crushtool -d {comp-crushmap-filename} -o {decomp-crushmap-filename}` 反编译；然后就可以用 `cat` 或编辑器查看了。
5. **MDS Map：** 包含当前 MDS 图的版本、创建时间、最近修改时间，还包含了存储元数据的存储池、元数据服务器列表、还有哪些元数据服务器是 `up` 且 `in` 的。要查看 MDS 图，执行 `ceph mds dump` 。

各运行图维护着各自运营状态的变更， Ceph 监视器维护着一份集群运行图的主拷贝，包括集群成员、状态、变更、以及 Ceph 存储集群的整体健康状况。



#### 高可用监视器

Ceph 客户端读或写数据前必须先连接到某个 Ceph 监视器、获得最新的集群运行图副本。一个 Ceph 存储集群只需要单个监视器就能运行，但它就成了单一故障点（即如果此监视器宕机， Ceph 客户端就不能读写数据了）。

为增强可靠性和容错能力， Ceph 支持监视器集群；在一个监视器集群内，延时以及其它错误会导致一到多个监视器滞后于集群的当前状态，因此，  Ceph 的各监视器例程必须就集群的当前状态达成一致。Ceph 总是使用大多数监视器（如： 1 、 2:3 、 3:5 、 4:6 等等）和

> [Paxos](http://en.wikipedia.org/wiki/Paxos_(computer_science)) 算法就集群的当前状态达成一致。

关于配置监视器的详情，见[监视器配置参考](http://docs.ceph.org.cn/rados/configuration/mon-config-ref)。



#### 高可用性认证

为识别用户并防止中间人攻击， Ceph 用 `cephx` 认证系统来认证用户和守护进程。

Note

`cephx` 协议不解决传输加密（如 SSL/TLS ）、或者存储加密问题。

Cephx 用共享密钥来认证，即客户端和监视器集群各自都有客户端密钥的副本。这样的认证协议使参与双方不用展现密钥就能相互认证，就是说集群确信用户拥有密钥、而且用户相信集群有密钥的副本。

Ceph 一个主要伸缩功能就是避免了对象存储的中央接口，这就要求 Ceph 客户端能直接和 OSD 交互。 Ceph 通过 `cephx` 认证系统保护数据，它也认证运行 Ceph 客户端的用户， `cephx` 协议运行机制类似 [Kerberos](http://en.wikipedia.org/wiki/Kerberos_(protocol)) 。

用户/参与者通过调用 Ceph 客户端来联系监视器，不像 Kerberos ，每个监视器都能认证用户、发布密钥，所以使用 `cephx` 时不会有单点故障或瓶颈。监视器返回一个类似 Kerberos 票据的认证数据结构，它包含一个可用于获取 Ceph  服务的会话密钥，会话密钥是用户的永久私钥自加密过的，只有此用户能从 Ceph  监视器请求服务。客户端用会话密钥向监视器请求需要的服务，然后监视器给客户端一个凭证用以向实际持有数据的 OSD 认证。 Ceph 的监视器和  OSD 共享相同的密钥，所以集群内任何 OSD 或元数据服务器都认可客户端从监视器获取的凭证，像 Kerberos 一样 `cephx` 凭证也会过期，以使攻击者不能用暗中得到的过期凭证或会话密钥。只要用户的私钥过期前没有泄露 ，这种认证形式就可防止中间线路攻击者以别人的 ID 发送垃圾消息、或修改用户的正常消息。

要使用 `cephx` ，管理员必须先设置好用户。在下面的图解里， `client.admin` 用户从命令行调用  `ceph auth get-or-create-key` 来生成一个用户及其密钥， Ceph 的认证子系统生成了用户名和密钥、副本存到监视器然后把此用户的密钥回传给 `client.admin` 用户，也就是说客户端和监视器共享着相同的密钥。

Note

`client.admin` 用户必须以安全方式把此用户 ID 和密钥交给用户。

![img](http://docs.ceph.org.cn/_images/ditaa-6b1dafb6d8f177ab2beb3325857f1e98e4593ec6.png)

要和监视器认证，客户端得把用户名传给监视器，然后监视器生成一个会话密钥、并且用此用户的密钥加密它，然后把加密的凭证回传给客户端，客户端用共享密钥解密载荷就可获取会话密钥。会话密钥在当前会话中标识了此用户，客户端再用此会话密钥签署过的用户名请求一个凭证，监视器生成一个凭证、用用户的密钥加密它，然后回传给客户端，客户端解密此凭证，然后用它签署连接集群内 OSD 和元数据服务器的请求。

![img](http://docs.ceph.org.cn/_images/ditaa-56e3a72e085f9070289331d64453b84ab1e9510b.png)

`cephx` 协议认证客户端机器和 Ceph 服务器间正在进行的通讯，二者间认证完成后的每条消息都用凭证签署过，监视器、 OSD 、元数据服务器都可用此共享的密钥来校验这些消息。

![img](http://docs.ceph.org.cn/_images/ditaa-f97566f2e17ba6de07951872d259d25ae061027f.png)

认证提供的保护位于 Ceph 客户端和服务器间，没有扩展到 Ceph 客户端之外。如果用户从远程主机访问 Ceph 客户端， Ceph 认证就不管用了，它不会影响到用户主机和客户端主机间的通讯。

关于配置细节，请参考 [Cephx 配置指南](http://docs.ceph.org.cn/rados/configuration/auth-config-ref)；关于用户管理细节，请参考[用户管理](http://docs.ceph.org.cn/rados/operations/user-management)。



#### 智能程序支撑超大规模

在很多集群架构中，集群成员的主要目的就是让集中式接口知道它能访问哪些节点，然后此中央接口通过一个两级调度为客户端提供服务，在 PB 到 EB 级系统中这个调度系统必将成为**最大**的瓶颈。

Ceph 消除了此瓶颈：其 OSD 守护进程和客户端都能感知集群，比如 Ceph 客户端、各 OSD 守护进程都知道集群内其他的 OSD  守护进程，这样 OSD 就能直接和其它 OSD 守护进程和监视器通讯。另外， Ceph 客户端也能直接和 OSD 守护进程交互。

Ceph 客户端、监视器和 OSD 守护进程可以相互直接交互，这意味着 OSD 可以利用本地节点的 CPU 和内存执行那些有可能拖垮中央服务器的任务。这种设计均衡了计算资源，带来几个好处：

1. **OSD 直接服务于客户端：** 由于任何网络设备都有最大并发连接上限，规模巨大时中央化的系统其物理局限性就暴露了。 Ceph 允许客户端直接和 OSD 节点联系，这在消除单故障点的同时，提升了性能和系统总容量。 Ceph 客户端可按需维护和某 OSD 的会话，而不是一中央服务器。

2. **OSD 成员和状态：** Ceph OSD 加入集群后会持续报告自己的状态。在底层， OSD 状态为 `up` 或 `down` ，反映它是否在运行、能否提供服务。如果一 OSD 状态为 `down` 且 `in` ，表明 OSD 守护进程可能故障了；如果一 OSD 守护进程没在运行（比如崩溃了），它就不能亲自向监视器报告自己是 `down` 的。 Ceph 监视器能周期性地 ping OSD 守护进程，以确保它们在运行，然而它也授权 OSD 进程去确认邻居 OSD 是否 `down` 了，并更新集群运行图、报告给监视器。这种机制意味着监视器还是轻量级进程。详情见[监控 OSD](http://docs.ceph.org.cn/rados/operations/monitoring-osd-pg/#monitoring-osds) 和[心跳](http://docs.ceph.org.cn/rados/configuration/mon-osd-interaction)。

3. **数据清洗：** 作为维护数据一致性和清洁度的一部分， OSD  能清洗归置组内的对象。就是说， Ceph OSD 能比较对象元数据与存储在其他 OSD 上的副本元数据，以捕捉 OSD  缺陷或文件系统错误（每天）。 OSD 也能做深度清洗（每周），即按位比较对象中的数据，以找出轻度清洗时未发现的硬盘坏扇区。关于清洗详细配置见[`数据清洗`_](http://docs.ceph.org.cn/architecture/#id42)。

4. **复制：** 和 Ceph 客户端一样， OSD 也用 CRUSH 算法，但用于计算副本存到哪里（也用于重均衡）。一个典型的写情形是，一客户端用 CRUSH 算法算出对象应存到哪里，并把对象映射到存储池和归置组，然后查找 CRUSH 图来确定此归置组的主 OSD 。

   客户端把对象写入目标归置组的主 OSD ，然后这个主 OSD 再用它的 CRUSH 图副本找出用于放对象副本的第二、第三个 OSD  ，并把数据复制到适当的归置组所对应的第二、第三 OSD （要多少副本就有多少 OSD ），最终，确认数据成功存储后反馈给客户端。

![img](http://docs.ceph.org.cn/_images/ditaa-54719cc959473e68a317f6578f9a2f0f3a8345ee.png)

有了做副本的能力， OSD 守护进程就可以减轻客户端的复制压力，同时保证了数据的高可靠性和安全性。

### 动态集群管理

在[伸缩性和高可用性](http://docs.ceph.org.cn/architecture/#id3)一节，我们解释了 Ceph 如何用 CRUSH 、集群感知性和智能 OSD 守护进程来扩展和维护高可靠性。 Ceph 的关键设计是自治，自修复、智能的 OSD  守护进程。让我们深入了解下 CRUSH 如何运作，如何动态实现现代云存储基础设施的数据放置、重均衡、错误恢复。



#### 关于存储池

Ceph 存储系统支持“池”概念，它是存储对象的逻辑分区。

Ceph 客户端从监视器获取一张[集群运行图](http://docs.ceph.org.cn/architecture/#id4)，并把对象写入存储池。存储池的 `size` 或副本数、 CRUSH 规则集和归置组数量决定着 Ceph 如何放置数据。

![img](http://docs.ceph.org.cn/_images/ditaa-65961c2ab9771b66c8c73e6d5fd648b0ea83c2da.png)

存储池至少可设置以下参数：

- 对象的所有权/访问权限；
- 归置组数量；以及，
- 使用的 CRUSH 规则集。

详情见[调整存储池](http://docs.ceph.org.cn/rados/operations/pools#set-pool-values)。

#### PG 映射到 OSD

每个存储池都有很多归置组， CRUSH 动态的把它们映射到 OSD 。 Ceph 客户端要存对象时， CRUSH 将把各对象映射到某个归置组。

把对象映射到归置组在 OSD 和客户端间创建了一个间接层。由于 Ceph 集群必须能增大或缩小、并动态地重均衡。如果让客户端“知道”哪个  OSD 有哪个对象，就会导致客户端和 OSD 紧耦合；相反， CRUSH 算法把对象映射到归置组、然后再把各归置组映射到一或多个 OSD  ，这一间接层可以让 Ceph 在 OSD 守护进程和底层设备上线时动态地重均衡。下列图表描述了 CRUSH  如何将对象映射到归置组、再把归置组映射到 OSD 。

![img](http://docs.ceph.org.cn/_images/ditaa-c7fd5a4042a21364a7bef1c09e6b019deb4e4feb.png)

有了集群运行图副本和 CRUSH 算法，客户端就能精确地计算出到哪个 OSD 读、写某特定对象。



#### 计算 PG ID

Ceph 客户端绑定到某监视器时，会索取最新的[集群运行图](http://docs.ceph.org.cn/architecture/#id4)副本，有了此图，客户端就能知道集群内的所有监视器、 OSD 、和元数据服务器。**然而它对对象的位置一无所知。**

> 对象位置是计算出来的。

客户端只需输入对象 ID 和存储池，此事简单： Ceph 把数据存在某存储池（如 liverpool ）中。当客户端想要存命名对象（如  john 、 paul 、 george 、 ringo 等等）时，它用对象名，一个哈希值、 存储池中的归置组数、存储池名计算归置组。 Ceph 按下列步骤计算 PG ID 。

1. 客户端输入存储池 ID 和对象 ID （如 pool=”liverpool” 和 object-id=”john” ）；
2. CRUSH 拿到对象 ID 并哈希它；
3. CRUSH 用 PG 数（如 `58` ）对哈希值取模，这就是归置组 ID ；
4. CRUSH 根据存储池名取得存储池 ID （如liverpool = `4` ）；
5. CRUSH 把存储池 ID 加到PG ID（如 `4.58` ）之前。

计算对象位置远快于查询定位， CRUSH 算法允许客户端计算对象*应该*存到哪里，并允许客户端连接主 OSD 来存储或检索对象。



#### 互联和子集

在前面的章节中，我们注意到 OSD 守护进程相互检查心跳并回馈给监视器；它们的另一行为叫“互联（ peering ）”，这是一种把一归置组内所有对象（及其元数据）所在的 OSD 带到一致状态的过程。事实上， OSD 守护进程会向监视器[报告互联失败](http://docs.ceph.org.cn/rados/configuration/mon-osd-interaction#osds-report-peering-failure)，互联问题一般会自行恢复，然而如果问题一直持续，你也许得参照[互联失败排障](http://docs.ceph.org.cn/rados/troubleshooting/troubleshooting-pg#placement-group-down-peering-failure)解决。

Note

状态达成一致并不意味着 PG 持有最新内容。

Ceph 存储集群被设计为至少存储两份对象数据（即 `size = 2` ），这是保证数据安全的最小要求。为保证高可用性， Ceph 存储集群应该保存两份以上的对象副本（如 `size = 3` 且 `min size = 2` ），这样才能在``degraded`` 状态继续运行，同时维持数据安全。

回想前面[智能程序支撑超大规模](http://docs.ceph.org.cn/architecture/#id7)中的图表，我们没明确地提 OSD 守护进程的名字（如 `osd.0` 、 `osd.1` 等等），而是称之为*主*、*次*、以此类推。按惯例，*主 OSD* 是 *acting set* 中的第一个 OSD ，而且它负责协调以它为主 OSD 的各归置组 的互联，也*只有它*会接受客户端到某归置组内对象的写入请求。

当一系列 OSD 负责一归置组时，这一系列的 OSD 就成为一个 *acting set* 。一个 *acting set* 对应当前负责此归置组的一组 OSD ，或者说截止到某个版本为止负责某个特定归置组的那些 OSD。

OSD 守护进程作为 *acting set* 的一部分，不一定总在 `up` 状态。当一 OSD 在 *acting set* 中是 `up` 状态时，它就是 `up set` 的一部分。 `up set` 是个重要特征，因为某 OSD 失败时 Ceph 会把 PG 映射到其他 OSD 。

Note

在某 PG 的 *acting set* 中包含了 `osd.25` 、 `osd.32` 和 `osd.61` ，第一个 `osd.25` 是主 OSD ，如果它失败了，第二个 `osd.32` 就成为主 OSD ， `osd.25` 会被移出 *up set* 。



#### 重均衡

你向 Ceph 存储集群新增一 OSD 守护进程时，集群运行图就要用新增的 OSD 更新。回想[计算 PG ID](http://docs.ceph.org.cn/architecture/#pg-id)  ，这个动作会更改集群运行图，因此也改变了对象位置，因为计算时的输入条件变了。下面的图描述了重均衡过程（此图很粗略，因为在大型集群里变动幅度小的多），是其中的一些而不是所有 PG 都从已有 OSD （ OSD 1 和 2 ）迁移到新 OSD （ OSD 3 ）。即使在重均衡中， CRUSH  都是稳定的，很多归置组仍维持最初的配置，且各 OSD 都腾出了些空间，所以重均衡完成后新 OSD 上不会出现负载突增。

![img](http://docs.ceph.org.cn/_images/ditaa-b31e1f646135b9706000fa0799d572563dffac81.png)



#### 数据一致性

作为维护数据一致和清洁的一部分， OSD 也能清洗归置组内的对象，也就是说， OSD 会比较归置组内位于不同 OSD  的各对象副本的元数据。清洗（通常每天执行）是为捕获 OSD 缺陷和文件系统错误， OSD  也能执行深度清洗：按位比较对象内的数据；深度清洗（通常每周执行）是为捕捉那些在轻度清洗过程中未能发现的磁盘上的坏扇区。

关于数据清洗的配置见[`数据清洗`_](http://docs.ceph.org.cn/architecture/#id44)。



### 纠删编码

纠删码存储池把各对象存储为 `K+M` 个数据块，其中有 `K` 个数据块和 `M` 个编码块。此存储池的尺寸为 `K+M` ，这样各块被存储到位于 acting set 中的 OSD ，块的位置也作为对象属性保存下来了。

比如一纠删码存储池创建时分配了五个 OSD （ `K+M = 5` ）并容忍其中两个丢失（ `M = 2` ）。

#### 读出和写入编码块

当包含 `ABCDEFGHI` 的对象 **NYAN** 被写入存储池时，纠删编码函数把内容分割为三个数据块，只是简单地切割为三份：第一份包含 `ABC` 、第二份是 `DEF` 、最后是 `GHI` ，若内容长度不是 `K` 的倍数则需填充；此函数还会创建两个编码块：第四个是 `YXY` 、第五个是 `GQC` ，各块分别存入 acting set 中的 OSD 内。这些块存储到相同名字（ **NYAN** ）的对象、但是位于不同的 OSD 上；分块顺序也必须保留，被存储为对象的一个属性（ `shard_t` ）追加到名字后面。包含 `ABC` 的块 1 存储在 **OSD5** 上、包含 `YXY` 的块 4 存储在 **OSD3** 上。

![img](http://docs.ceph.org.cn/_images/ditaa-96fe8c3c73e5e54cf27fa8a4d64ed08d17679ba3.png)

从纠删码存储池中读取 **NYAN** 对象时，解码函数会读取三个块：包含 `ABC` 的块 1 ，包含 `GHI` 的块 3 和包含 `YXY` 的块 4 ，然后重建对象的原始内容 `ABCDEFGHI` 。解码函数被告知块 2 和 5 丢失了（被称为“擦除”），块 5 不可读是因为 **OSD4** 出局了。只要有三块读出就可以成功调用解码函数。 **OSD2** 是最慢的，其数据未被采纳。

![img](http://docs.ceph.org.cn/_images/ditaa-1f3acf28921568db86bb22bb748cbf42c9db7059.png)

#### 被中断的完全写

在纠删码存储池中， up set 中的主 OSD 接受所有写操作，它负责把载荷编码为 `K+M` 个块并发送给其它 OSD 。它也负责维护归置组日志的一份权威版本。

在下图中，已创建了一个参数为 `K = 2 + M = 1` 的纠删编码归置组，存储在三个 OSD 上，两个存储 `K` 、一个存 `M` 。此归置组的 acting set 由 **OSD 1** 、**OSD 2** 、 **OSD 3** 组成。一个对象已被编码并存进了各 OSD ：块 `D1v1` （即数据块号为 1 ，版本为 1 ）在 **OSD 1** 上、 `D2v1` 在 **OSD 2** 上、 `C1v1` （即编码块号为 1 ，版本为 1 ）在 **OSD 3** 上。各 OSD 上的归置组日志都相同（即 `1,1` ，表明 epoch 为 1 ，版本为 1 ）。

![img](http://docs.ceph.org.cn/_images/ditaa-a60e808835cf8860e19b9f2a9c83691c2a4f0218.png)

**OSD 1** 是主的，它从客户端收到了 **WRITE FULL** 请求，这意味着净载荷将会完全取代此对象，而非部分覆盖。此对象的版本 2 （ v2 ）将被创建以取代版本 1 （ v1 ）。 **OSD 1** 把净载荷编码为三块： `D1v2` （即数据块号 1 、版本 2 ）将存入 **OSD 1** 、 `D2v2` 在 **OSD 2** 上、 `C1v2` （即编码块号 1 版本 2 ）在 **OSD 3** 上，各块分别被发往目标 OSD ，包括主 OSD ，它除了存储块还负责处理写操作和维护归置组日志的权威版本。当某个 OSD 收到写入块的指令消息后，它也会新建一条归置组日志来反映变更，比如在 **OSD 3** 存储 `C1v2` 时它会把 `1,2` （即 epoch 为 1 、版本为 2 ）写入它自己的日志。因为 OSD 间是异步工作的，当某些块还落盘（像 `D2v2` ），其它的可能已经被确认存在磁盘上了（像 `C1v1` 和 `D1v1` ）。

![img](http://docs.ceph.org.cn/_images/ditaa-513e0558c5877884d43ffc9e7b792a5f77466831.png)

如果一切顺利，各块被证实已在 acting set 中的 OSD 上了，日志的 `last_complete` 指针就会从 `1,1` 改为指向 `1,2` 。

![img](http://docs.ceph.org.cn/_images/ditaa-8db474f2d1f9a795067c4aef26c0530072cfa77f.png)

最后，用于存储对象前一版本的文件就可以删除了： **OSD 1** 上的 `D1v1` 、 **OSD 2** 上的 `D2v1` 和 **OSD 3** 上的 `C1v1` 。

![img](http://docs.ceph.org.cn/_images/ditaa-8459c4da0494dcbcd61e3348a59fb42fb696b014.png)

但是意外发生了，如果 **OSD 1** 挂了、同时 `D2v2` 仍写完成，此对象的版本 2 一部分已被写入了： **OSD 3** 有一块但是不足以恢复；它丢失了两块： `D1v2` 和 `D2v2` ，并且纠删编码参数 `K = 2` 、 `M = 1` 要求至少有两块可用才能重建出第三块。 **OSD 4** 成为新的主 OSD ，它发现 `last_complete` 日志条目（即在此条目之前的所有对象在之前 acting set 中的 OSD 上都可用）是 `1,1` 那么它将是新权威日志的头条。

![img](http://docs.ceph.org.cn/_images/ditaa-e211bf856cdbbf5d055980e95d39a4b60113c954.png)

在 **OSD 3** 上发现的日志条目 1,2 与 **OSD 4** 上新的权威日志有分歧：它将被忽略、且包含 `C1v2` 块的文件也被删除。 `D1v1` 块将在清洗期间通过纠删码库的 `decode` 解码功能重建，并存储到新的主 **OSD 4** 上。

![img](http://docs.ceph.org.cn/_images/ditaa-77b8a9b262ce5e9cbd7030c5da9ed7ab0edffc8a.png)

详情见[纠删码笔记](https://github.com/ceph/ceph/blob/40059e12af88267d0da67d8fd8d9cd81244d8f93/doc/dev/osd_internals/erasure_coding/developer_notes.rst)。

### 缓存分级

对于后端存储层上的部分热点数据，缓存层能向 Ceph 客户端提供更好的 IO  性能。缓存分层包含由相对高速、昂贵的存储设备（如固态硬盘）创建的存储池，并配置为  缓存层；以及一个后端存储池，可以用纠删码编码的或者相对低速、便宜的设备，作为经济存储层。 Ceph  对象管理器会决定往哪里放置对象，分层代理决定何时把缓存层的对象刷回后端存储层。所以缓存层和后端存储层对 Ceph 客户端来说是完全透明的。

![img](http://docs.ceph.org.cn/_images/ditaa-2982c5ed3031cac4f9e40545139e51fdb0b33897.png)

详情见[缓存分级](http://docs.ceph.org.cn/rados/operations/cache-tiering)。



### 扩展 Ceph

你可以通过创建 ‘Ceph Classes’ 共享对象类来扩展 Ceph 功能， Ceph 会动态地载入位于 `osd class dir` 目录下的 `.so` 类文件（即默认的 `$libdir/rados-classes` ）。如果你实现了一个类，就可以创建新的对象方法去调用 Ceph 对象存储内的原生方法、或者公用库或自建库里的其它类方法。

写入时， Ceph 类能调用原生或类方法，对入栈数据执行任意操作、生成最终写事务，并由 Ceph 原子地应用。

读出时， Ceph 类能调用原生或类方法，对出栈数据执行任意操作、把数据返回给客户端。

Ceph 类实例

一个为内容管理系统写的类可能要实现如下功能，它要展示特定尺寸和长宽比的位图，所以入栈图片要裁剪为特定长宽比、缩放它、并嵌入个不可见的版权或水印用于保护知识产权；然后把生成的位图保存为对象。

典型的实现见 `src/objclass/objclass.h` 、 `src/fooclass.cc` 、和 `src/barclass` 。

### 小结

Ceph 存储集群是动态的——像个生物体。尽管很多存储设备不能完全利用一台普通服务器上的 CPU 和 RAM 资源，但是 Ceph  能。从心跳到互联、到重均衡、再到错误恢复， Ceph 都把客户端（和中央网关，但在 Ceph 架构中不存在）解放了，用 OSD  的计算资源完成此工作。参考前面的[硬件推荐](http://docs.ceph.org.cn/install/hardware-recommendations)和[网络配置参考](http://docs.ceph.org.cn/rados/configuration/network-config-ref)理解前述概念，就不难理解 Ceph 如何利用计算资源了。



## Ceph 协议

Ceph 客户端用原生协议和存储集群交互， Ceph 把此功能封装进了 `librados` 库，这样你就能创建自己的定制客户端了，下图描述了基本架构。

![img](http://docs.ceph.org.cn/_images/ditaa-1a91351293f441ce0238c21f2c432331a0f5a9d3.png)

### 原生协议和 `librados`

现代程序都需要可异步通讯的简单对象存储接口。 Ceph 存储集群提供了一个有异步通讯能力的简单对象存储接口，此接口提供了直接、并行访问集群对象的功能。

- 存储池操作；
- 快照和写时复制克隆；
- 读/写对象； - 创建或删除； - 整个对象或某个字节范围； - 追加或裁截；
- 创建/设置/获取/删除扩展属性；
- 创建/设置/获取/删除键/值对；
- 混合操作和双重确认；
- 对象类。



### 对象监视/通知

客户端可以注册对某个对象的持续兴趣，并使到主 OSD 的会话保持打开。客户端可以发送一通知消息和载荷给所有监视者、并可收集监视者的回馈通知。这个功能使得客户端可把任意对象用作同步/通讯通道。

![img](http://docs.ceph.org.cn/_images/ditaa-afd50e13a81128d0a2c38fadcd27dfc8b7ac523b.png)



### 数据条带化

存储设备都有吞吐量限制，它会影响性能和伸缩性，所以存储系统一般都支持[条带化](http://en.wikipedia.org/wiki/Data_striping)（把连续的信息分片存储于多个设备）以增加吞吐量和性能。数据条带化最常见于 [RAID](http://en.wikipedia.org/wiki/RAID) 中， RAID 中最接近 Ceph 条带化方式的是 [RAID 0](http://en.wikipedia.org/wiki/RAID_0#RAID_0) 、或者条带卷， Ceph 的条带化提供了像 RAID 0 一样的吞吐量、像 N 路 RAID 镜像一样的可靠性、和更快的恢复。

Ceph 提供了三种类型的客户端：块设备、文件系统和对象存储。 Ceph 客户端把展现给用户的数据格式（一块设备映像、 REST 风格对象、 CephFS 文件系统目录）转换为可存储于 Ceph 存储集群的对象。

Tip

在 Ceph 存储集群内存储的那些对象是没条带化的。 Ceph 对象存储、 Ceph 块设备、和 Ceph 文件系统把他们的数据条带化到 Ceph 存储集群内的多个对象，客户端通过 `librados` 直接写入 Ceph 存储集群前必须先自己条带化（和并行 I/O ）才能享受这些优势。

最简单的 Ceph 条带化形式就是一个对象的条带。 Ceph 客户端把条带单元写入 Ceph  存储的对象，直到对象容量达到上限，才会再创建另一个对象存储未完的数据。这种最简单的条带化对小的块设备映像、 S3 、 Swift 对象或  CephFS 文件来说也许足够了；然而这种简单的形式不能最大化 Ceph  在归置组间分布数据的能力，也就不能最大化性能。下图描述了条带化的最简形式：

![img](http://docs.ceph.org.cn/_images/ditaa-deb861a26cf89e008006b63d95885b4ed88ba608.png)

如果要处理大尺寸图像、大 S3 或 Swift 对象（如视频）、或大的 CephFS  目录，你就能看到条带化到一个对象集中的多个对象能带来显著的读/写性能提升。当客户端把条带单元并行地写入相应对象时，就会有明显的写性能，因为对象映射到了不同的归置组、并进一步映射到不同 OSD ，可以并行地以最大速度写入。到单一磁盘的写入受限于磁头移动（如：6ms 寻道时间）和存储设备带宽（如：100MB/s），  Ceph把写入分布到多个对象（它们映射到了不同归置组和 OSD  ），这样可减少每设备寻道次数、联合多个驱动器的吞吐量，以达到更高的写（或读）速度。

Note

条带化独立于对象复制。因为 CRUSH 会在 OSD 间复制对象，数据条带是自动被复制的。

在下图中，客户端数据条带化到一个对象集（下图中的 `object set 1` ），它包含 4 个对象，其中，第一个条带单元是 `object 0` 的 `stripe unit 0` 、第四个条带是 `object 3` 的 `stripe unit 3` ，写完第四个条带，客户端要确认对象集是否满了。如果对象集没满，客户端再从第一个对象起写入条带（下图中的 `object 0` ）；如果对象集满了，客户端就得创建新对象集（下图的 `object set 2` ），然后从新对象集中的第一个对象（下图中的 `object 4` ）起开始写入第一个条带（ `stripe unit 16` ）。

![img](http://docs.ceph.org.cn/_images/ditaa-92220e0223f86eb33cfcaed4241c6680226c5ce2.png)

三个重要变量决定着 Ceph 如何条带化数据：

- **对象尺寸：** Ceph 存储集群里的对象有最大可配置尺寸（如 2MB 、 4MB 等等），对象尺寸必须足够大以便容纳很多条带单元、而且应该是条带单元的整数倍。
- **条带宽度：** 条带都有可配置的单元尺寸（如 64KB ）。 Ceph 客户端把数据等分成适合写入对象的条带单元，除了最后一个。条带宽度应该是对象尺寸的分片，这样对象才能 包含很多条带单元。
- **条带数量：** Ceph 客户端把一系列条带单元写入由条带数量所确定的一系列对象，这一系列的对象称为一个对象集。客户端写到对象集内的最后一个对象时，再返回到第一个。

Important

把集群投入生产环境前要先测试条带化配置的性能，因为把数据条带化到对象中之后这些参数就**不可**更改了。

Ceph 客户端把数据等分为条带单元并映射到对象后，用 CRUSH 算法把对象映射到归置组、归置组映射到 OSD ，然后才能以文件形式存储到硬盘上。

Note

因为客户端写入单个存储池，条带化到对象的所有数据也被映射到同一存储池内的归置组，所以它们要使用相同的 CRUSH 图和相同的访问权限。



## Ceph 客户端

Ceph 客户端包括数种服务接口，有：

- **块设备：** [*Ceph 块设备*](http://docs.ceph.org.cn/glossary/#term-38)（也叫 RBD ）服务提供了大小可调、精炼、支持快照和克隆的块设备。为提供高性能， Ceph 把块设备条带化到整个集群。 Ceph 同时支持内核对象（ KO ） 和 QEMU 管理程序直接使用``librbd`` ——避免了内核对象在虚拟系统上的开销。
- **对象存储：** [*Ceph 对象存储*](http://docs.ceph.org.cn/glossary/#term-30)（也叫 RGW ）服务提供了 [`RESTful 风格`_](http://docs.ceph.org.cn/architecture/#id46)的 API ，它与 Amazon S3 和 OpenStack Swift 兼容。
- **文件系统：** [*Ceph 文件系统*](http://docs.ceph.org.cn/glossary/#term-45)（ CephFS ）服务提供了兼容 POSIX 的文件系统，可以直接 `mount` 或挂载为用户空间文件系统（ FUSE ）。

Ceph 能额外运行多个 OSD 、 MDS 、和监视器来保证伸缩性和高可靠性，下图描述了高级架构。

![img](http://docs.ceph.org.cn/_images/ditaa-a116a4a81d0472ef44d503c262528e6c1ea9d547.png)



### Ceph 对象存储

Ceph 对象存储守护进程， `radosgw` ，是一个 FastCGI 服务，它提供了 [`RESTful 风格`_](http://docs.ceph.org.cn/architecture/#id48) HTTP API 用于存储对象和元数据。它位于 Ceph 存储集群之上，有自己的数据格式，并维护着自己的用户数据库、认证、和访问控制。  RADOS 网关使用统一的命名空间，也就是说，你可以用 OpenStack Swift 兼容的 API 或者 Amazon S3 兼容的 API ；例如，你可以用一个程序通过 S3 兼容 API 写入数据、然后用另一个程序通过 Swift 兼容 API 读出。

S3/Swift 对象和存储集群对象比较

Ceph 对象存储用*对象*这个术语来描述它存储的数据。 S3 和 Swift 对象不同于 Ceph 写入存储集群的对象，  Ceph 对象存储系统内的对象可以映射到 Ceph 存储集群内的对象； S3 和 Swift 对象却不一定 1:1  地映射到存储集群内的对象，它有可能映射到了多个 Ceph 对象。

详情见 [Ceph 对象存储](http://docs.ceph.org.cn/radosgw/)。



### Ceph 块设备

Ceph 块设备把一个设备映像条带化到集群内的多个对象，其中各对象映射到一个归置组并分布出去，这些归置组会分散到整个集群的 `ceph-osd` 守护进程上。

Important

条带化会使 RBD 块设备比单台服务器运行的更好！

精简的、可快照的 Ceph 块设备对虚拟化和云计算很有吸引力。在虚拟机场景中，人们一般会用 Qemu/KVM 中的 `rbd` 网络存储驱动部署 Ceph 块设备，其中宿主机用 `librbd` 向客户机提供块设备服务；很多云计算堆栈用 `libvirt` 和管理程序集成。你可以用精简的 Ceph 块设备搭配 Qemu 和``libvirt`` 来支持 OpenStack 和 CloudStack ，一起构成完整的方案。

现在``librbd``还不支持其它管理程序，你也可以用 Ceph 块设备内核对象向客户端提供块设备。其它虚拟化技术，像 Xen 能访问 Ceph 块设备内核对象，用命令行工具 `rbd` 实现。



### Ceph 文件系统

Ceph 文件系统（ Ceph FS ）提供与 POSIX 兼容的文件系统服务，坐于基于对象的 Ceph 存储集群之上，其内的文件被映射到 Ceph 存储集群内的对象。客户端可以把此文件系统挂载在内核对象或用户空间文件系统（ FUSE ）上。

![img](http://docs.ceph.org.cn/_images/ditaa-1cae553f9d207d72257429d572673632afbd108c.png)

Ceph 文件系统服务包含随 Ceph 存储集群部署的元数据服务器（ MDS ）。 MDS 的作用是把所有文件系统元数据（目录、文件所有者、访问模式等等）永久存储在相当可靠的元数据服务器中内存中。 MDS （名为 `ceph-mds` 的守护进程）存在的原因是，简单的文件系统操作像列出目录（ `ls` ）、或进入目录（ `cd` ）这些操作会不必要的扰动``OSD``。所以把元数据从数据里分出来意味着 Ceph 文件系统能提供高性能服务，又能减轻存储集群负载。

Ceph FS 从数据中分离出了元数据、并存储于 MDS ，文件数据存储于存储集群中的一或多个对象。 Ceph 力争兼容 POSIX 。 `ceph-mds` 可以只运行一个，也可以分布于多台物理机器，以获得高可用性或伸缩性。

- **高可用性：** 多余的 `ceph-mds` 例程可处于 standby （待命）状态，随时准备替下之前处于 active （活跃）状态的故障 `ceph-mds` 。这可以轻易做到，因为所有数据、包括日志都存储在 RADOS 上，这个转换过程由 `ceph-mon` 自动触发。
- **伸缩性：** 多个 `ceph-mds` 例程可以同时处于 active 状态，它们会把目录树拆分为子树（和单个热点目录的分片），在所有活跃服务器间高效地均衡负载。

Important

译者：虽然文档这么说，但实践中还不推荐这样做， MDS 稳定性尚不理想。多个活跃的 MDS 远没一个稳定，即便如此，您也应该先配置起几个 MDS 备用。

待命（ standby ）和活跃（ active ） MDS 可组合，例如，运行 3 个处于 active 状态的 `ceph-mds` 例程以实现扩展、和 1 个 standby 例程以实现高可用性。
