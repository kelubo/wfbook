# NFS

[TOC]

## 概述

NFS（Network File System）

由 SUN 公司研制的 UNIX 表示层协议 (presentation layer protocol)，允许远程主机通过网络挂载文件系统，并像它们挂载在本地那样与这些文件系统进行交互。

将 NFS 服务器中的一个或多个目录共享出来，NFS 服务器参考 `/etc/exports` 配置文件，来确定是否允许客户端访问任何导出的文件系统。一旦被验证，所有文件和目录操作都对用户有效。

端口号：2049

## 版本

- 与 NFSv2 相比，NFS 版本 3（NFSv3）支持安全异步写入操作，并在处理错误时更可靠。也支持 64 位文件大小和偏移，允许客户端访问超过 2 GB 文件数据。
- NFS 版本 4 (NFSv4) 通过防火墙，并在 Internet 上工作，不再需要 `rpcbind` 服务，支持访问控制列表 (ACL)，并且使用有状态操作。
- RHEL 不再支持 NFS 版本 2 (NFSv2)。 		

### 默认 NFS 版本

RHEL 9 默认版本为 4.2。支持 NFSv4 和 NFSv3 的主要版本，NFSv2 已不再受支持。

NFS 客户端默认试图使用 NFSv4.2  挂载，并在服务器不支持 NFSv4.2 时回退到 NFSv4.1。之后挂载会返回 NFSv4.0，然后回退到 NFSv3。 		

### NFS 版本的特性

NFSv4.2 的功能：

- 服务器端复制

  使用 `copy_file_range()` 系统调用，可以使 NFS 客户端高效地复制数据，而不浪费网络资源。

- 稀疏文件

  使文件有一个或者多个 洞（hole），它们是不分配或者未初始化的数据块，只由 0 组成。NFSv4.2 中的 `lseek()` 操作支持 `seek_hole()` 和 `seek_data()`，这使得应用程序能够在稀疏文件中映射漏洞的位置。

- 保留空间

  允许存储服务器保留空闲空间，这会防止服务器耗尽空间。NFSv4.2 支持 `allocate()` 操作来保留空间，支持 `deallocate()` 操作来释放空间，支持 `fallocate()` 操作来预分配和释放文件中的空间。

- 标记的 NFS

  强制实施数据访问权限，并为 NFS 文件系统上的各个文件在客户端和服务器之间启用 SELinux 标签。

- 布局增强

  提供 `layoutstats()` 操作，它可让一些并行 NFS(pNFS)服务器收集更好的性能统计数据。

NFSv4.1 的功能： 		

- 增强性能和网络安全，同时包括对 pNFS 的客户端支持。 
- 对于回调不再需要单独的 TCP 连接，回调允许 NFS 服务器在无法联系客户端的情况下授予委托：例如，当 NAT 或防火墙干扰时。
- 只提供一次语义（除重启操作外），防止出现先前的问题，即如果回复丢失，且操作被发送了两次，则某些操作有时会返回不准确的结果。

NFSv4 仅使用 TCP 协议与服务器进行通信。较早的版本可使用 TCP 或 UDP。

## NFS 所需的服务

RHEL 使用内核级支持和服务流程组合提供 NFS 文件共享。所有 NFS 版本都依赖于客户端和服务器间的远程过程调用（RPC）。

要共享或者挂载 NFS 文件系统，下列服务根据所使用的 NFS 版本而定：

- `nfsd`

  为共享 NFS 文件系统请求的 NFS 服务器内核模块。

- `rpcbind`

  接受本地 RPC 服务的端口保留。这些端口随后可用（或公布出去），这样相应的远程 RPC 服务可以访问它们。`rpcbind` 服务响应对 RPC 服务的请求，并建立到请求的 RPC 服务的连接。不能与 NFSv4 一起使用。

- `rpc.mountd`

  NFS 服务器使用这个进程来处理来自 NFSv3 客户端的 `MOUNT` 请求。它检查所请求的 NFS 共享是否目前由 NFS 服务器导出，并且允许客户端访问它。如果允许挂载请求，`nfs-mountd` 服务会回复 Success 状态，并将此 NFS 共享的文件句柄返回给 NFS 客户端。

- `rpc.nfsd`

  这个过程启用了要定义的服务器公告的显式 NFS 版本和协议。它与 Linux 内核一起使用，来满足 NFS 客户端的动态需求，例如，在每次连接 NFS 客户端时提供服务器线程。这个进程对应于 `nfs-server` 服务。

- `lockd`

  这是一个在客户端和服务器中运行的内核线程。它实现网络锁管理器 (NLM) 协议，它允许 NFSv3 客户端锁住服务器上的文件。每当运行 NFS 服务器以及挂载 NFS 文件系统时，它会自动启动。

- `rpc.statd`

  这个进程实现网络状态监控器 (NSM) RPC 协议，该协议可在 NFS 服务器没有正常关机而重启时通知 NFS 客户端。`rpc-statd` 服务由 `nfs-server` 服务自动启动，不需要用户配置。不能与 NFSv4 一起使用。

- `rpc.rquotad`

  这个过程为远程用户提供用户配额信息。启动 `nfs-server` 时，用户也必须启动 `quota-rpc` 软件包提供的 `rpc-rquotad` 服务。

- `rpc.idmapd`

  此进程为 NFSv4 客户端和服务器提供上行调用，这些调用在线上 NFSv4 名称（`user@domain`形式的字符串）和本地 UID 和 GID 之间进行映射。要使 `idmapd` 与 NFSv4 正常工作，必须配置 `/etc/idmapd.conf` 文件。至少应指定 `Domain` 参数，该参数定义 NFSv4 映射域。如果 NFSv4 映射域与 DNS 域名相同，可以跳过这个参数。客户端和服务器必须同意 NFSv4 映射域才能使 ID 映射正常工作。
  
  只有 NFSv4 服务器使用 `rpc.idmapd`，它由 `nfs-idmapd` 服务启动。NFSv4 客户端使用基于密钥环的 `nfsidmap` 工具，内核按需调用它来执行 ID 映射。如果 `nfsidmap` 有问题，客户端将退回使用 `rpc.idmapd`。 

### NFSv4 的 RPC 服务

挂载和锁定协议已合并到 NFSv4 协议中。该服务器还会监听已知的 TCP 端口 2049。NFSv4 不需要与 `rpcbind`、`lockd` 和 `rpc-statd` 服务进行交互。NFS 服务器上仍然需要 `nfs-mountd` 服务来设置导出，但不涉及任何线上操作。

## 安装 NFS

安装 `nfs-utils` 软件包：

```bash
# CentOS
dnf install nfs-utils		
```

## NFS 主机名格式

在挂载或导出 NFS 共享时用来指定主机的不同格式。

- 单台机器

  以下任意一种：

  * 完全限定域名（可由服务器解析）
  * 主机名（可由服务器解析）
  * IP 地址

- IP 网络

  以下格式之一有效：

  * `a.b.c.d/z` ，例如 `192.168.0.0/24`。
  * `a.b.c.d/netmask`，例如 `192.168.100.8/255.255.255.0`。

- Netgroups

  `@group-name` 格式，其中`group-name` 是 NIS netgroup 名称。

## NFS 服务器

### 启动 NFS 服务器

- 对于支持 NFSv3 连接的服务器，`rpcbind` 服务必须处于运行状态。

  ```bash
  systemctl enable --now rpcbind
  systemctl status rpcbind
  ```


- 启动 NFS 服务器，并使其在引导时自动启动： 				

  ```bash
  systemctl enable --now nfs-server
  ```

### 配置

- 手动编辑 `/etc/exports` 配置文件
- 在命令行上使用 `exportfs` 工具

#### /etc/exports 配置文件

`/etc/exports` 文件控制哪些文件系统被导出到远程主机，并指定选项。遵循以下语法规则：

- 空白行将被忽略。
- 要添加注释，以井号(`#`)开始一行。
- 您可以使用反斜杠(`\`)换行长行。
- 每个导出的文件系统都应该独立。
- 所有在导出的文件系统后放置的授权主机列表都必须用空格分开。
- 每个主机的选项必须在主机标识符后直接放在括号中，没有空格分离主机和第一个括号。

##### 导出条目

导出的文件系统的每个条目都有以下结构：

```bash
export host(options)
```

还可以指定多个主机以及每个主机的特定选项。要做到这一点，在同一行中列出主机列表（以空格分隔），每个主机名带有其相关的选项（在括号中），如下所示：

```bash
export host1(options1) host2(options2) host3(options3)		
```

**示例：**

在最简单的形式中，`/etc/exports` 文件只指定导出的目录和允许访问它的主机：

```bash
/exported/directory bob.example.com
```

这里，`bob.example.com` 可以挂载 NFS 服务器的 `/exported/directory/`。因为在这个示例中没有指定选项，所以 NFS 使用默认选项。

>  重要:
>
>  `/etc/exports` 文件的格式要求非常精确，特别是在空格字符的使用方面。需要将导出的文件系统与主机、不同主机间使用空格分隔。但是，除了注释行外，文件中不应该包括其他空格。
>
>  例如，下面两行并不具有相同的意义：
>
>  第一行仅允许来自 `bob.example.com` 的用户读写 `/home` 目录。第二行允许来自 `bob.example.com` 的用户以只读方式挂载目录（默认），而其他用户可以将其挂载为读/写。
>
>  ```bash
>  /home bob.example.com(rw)
>  /home bob.example.com (rw)	 				
>  ```

##### 默认选项

- `ro`

  导出的文件系统是只读的。远程主机无法更改文件系统中共享的数据。

- `rw`

- `sync`

  在将之前的请求所做的更改写入磁盘前，NFS 服务器不会回复请求。

- `async` 

  启用异步写。

- `wdelay`

  如果 NFS 服务器预期另外一个写入请求即将发生，则 NFS 服务器会延迟写入磁盘。这可以提高性能，因为它可减少不同的写命令访问磁盘的次数，从而减少写开销。要禁用此功能，请指定 `no_wdelay` 选项，该选项仅在指定了默认 sync 选项时才可用。

- `root_squash`

  可以防止远程连接的 root 用户（与本地连接相反）具有 root 特权；相反，NFS 服务器为他们分配用户 ID `nobody`。这可以有效地将远程 root 用户的权限"挤压"成最低的本地用户，从而防止在远程服务器上可能的未经授权的写操作。要禁用 root 挤压，请指定 `no_root_squash` 选项。
  
  要挤压每个远程用户（包括 root 用户），使用 `all_squash` 选项。要指定 NFS 服务器应该分配给来自特定主机的远程用户的用户和组 ID，请分别使用 `anonuid` 和 `anongid` 选项，如下所示：
  
  ```bash
  export host(anonuid=uid,anongid=gid)
  ```
  
  `anonuid` 和 `anongid` 选项允许你为要共享的远程 NFS 用户创建特殊的用户和组帐户。 						

​		默认情况下，RHEL 下的 NFS 支持访问控制列表 (ACL) 。要禁用此功能，请在导出文件系统时指定 `no_acl` 选项。 			

##### 默认和覆盖选项

每个导出的文件系统的默认值都必须被显式覆盖。例如，如果没有指定 `rw` 选项，则导出的文件系统将以只读形式共享。

以下是 `/etc/exports` 中的示例行，其覆盖两个默认选项：

```bash
/another/exported/directory 192.168.0.3(rw,async)
```


在此示例中，`192.168.0.3` 可以以读写形式挂载 `/another/exported/directory/` ，并且所有对磁盘的写入都是异步的。 			

#### exportfs 工具

`exportfs` 工具使 root 用户能够有选择地导出或取消导出目录，而无需重启 NFS 服务。给定合适的选项后，`exportfs` 工具将导出的文件系统写到 `/var/lib/nfs/xtab`。由于 `nfs-mountd` 服务在决定访问文件系统的特权时参考 `xtab` 文件，所以对导出的文件系统列表的更改会立即生效。 			

用于 `exportfs` 的常用选项列表：

- `-r`

  通过在 `/var/lib/nfs/etab` 中构建新的导出列表，将 `/etc/exports` 中列出的所有目录导出。如果对 `/etc/exports` 做了任何更改，这个选项可以有效地刷新导出列表。

- `-a`

  根据哪些其它选项传给了 `exportfs`，将导出或取消导出所有目录。如果没有指定其他选项，`exportfs` 会导出 `/etc/exports` 中指定的所有文件系统。

- `-o file-systems`

  指定没有在 `/etc/exports` 中列出的要导出的目录。使用要导出的额外文件系统替换 file-systems。这些文件系统的格式化方式必须与 `/etc/exports` 中指定的方式相同。此选项通常用于在将其永久添加到导出的文件系统列表之前测试导出的文件系统。

- `-i`

  忽略 `/etc/exports` ；只有命令行上指定的选项才会用于定义导出的文件系统。

- `-u`

  不导出所有共享目录。命令 `exportfs -ua` 可暂停 NFS 文件共享，同时保持所有 NFS 服务正常运行。要重新启用 NFS 共享，请使用 `exportfs -r`。

- `-v`

  详细操作，当执行 `exportfs` 命令时，更详细地显示正在导出的或取消导出的文件系统。

如果没有选项传给 `exportfs` 工具，将显示当前导出的文件系统列表。

## NFS 和 rpcbind

`rpcbind` 服务将远程过程调用(RPC)服务映射到其侦听的端口。RPC 进程在启动时通知 `rpcbind`，注册它们正在侦听的端口以及它们期望提供服务的 RPC 程序号。然后，客户端系统会使用特定的 RPC 程序号联系服务器上的 `rpcbind`。`rpcbind` 服务将客户端重定向到正确的端口号，这样它就可以与请求的服务进行通信。

由于基于 RPC 的服务依赖 `rpcbind` 来与所有传入的客户端请求建立连接，因此 `rpcbind` 必须在这些服务启动之前可用。 

`rpcbind` 的访问控制规则会影响所有基于 RPC 的服务。另外，也可以为每个 NFS RPC 守护进程指定访问控制规则。

## NFS 和 rpcbind 故障排除

由于 `rpcbind` 服务在 RPC 服务和用于与之通信的端口号之间提供协调，因此在排除故障时，使用 `rpcbind` 查看当前 RPC 服务的状态非常有用。`rpcinfo` 工具显示每个基于 RPC 的服务，以及其端口号、RPC 程序号、版本号和 IP 协议类型（TCP 或 UDP）。

1. 要确保为 `rpcbind` 启用了正确的基于 NFS RPC 的服务，请使用以下命令： 				

   ```bash
   rpcinfo -p					
   ```
   
   示例：
   
   ```bash
   program vers proto   port  service
   100000    4   tcp    111  portmapper
   100000    3   tcp    111  portmapper
   100000    2   tcp    111  portmapper
   100000    4   udp    111  portmapper
   100000    3   udp    111  portmapper
   100000    2   udp    111  portmapper
   100005    1   udp  20048  mountd
   100005    1   tcp  20048  mountd
   100005    2   udp  20048  mountd
   100005    2   tcp  20048  mountd
   100005    3   udp  20048  mountd
   100005    3   tcp  20048  mountd
   100024    1   udp  37769  status
   100024    1   tcp  49349  status
   100003    3   tcp   2049  nfs
   100003    4   tcp   2049  nfs
   100227    3   tcp   2049  nfs_acl
   100021    1   udp  56691  nlockmgr
   100021    3   udp  56691  nlockmgr
   100021    4   udp  56691  nlockmgr
   100021    1   tcp  46193  nlockmgr
   100021    3   tcp  46193  nlockmgr
   100021    4   tcp  46193  nlockmgr
   ```
   
   如果其中一个 NFS 服务没有正确启动，`rpcbind` 将不能将来自客户端的对该服务的 RPC 请求映射到正确的端口。 
2. 在很多情况下，如果 NFS 没有出现在 `rpcinfo` 输出中，重启 NFS 会使服务正确使用 `rpcbind` 注册，并开始工作：

   ```bash
   systemctl restart nfs-server
   ```

## 将 NFS 服务器配置为在防火墙后运行

NFS 需要 `rpcbind` 服务，该服务为 RPC 服务动态分配端口，并可能导致配置防火墙规则时出现问题。如何在防火墙后配置 NFS 版本（如果要支持）： 

- NFSv3

  这包括支持 NFSv3 的任何服务器：

  - NFSv3-only 服务器
  - 支持 NFSv3 和 NFSv4 的服务器

- 只使用 NFSv4

### 将 NFSv3-enabled 服务器配置为在防火墙后运行

下面的步骤描述了如何将支持 NFSv3 的服务器配置为在防火墙后运行。这包括支持 NFSv3 和 NFSv4 的 NFSv3-only 服务器和服务器。 			

**流程**

1. 要允许客户端访问防火墙后面的 NFS 共享，请在 NFS 服务器上运行以下命令来配置防火墙： 					

   ```none
   firewall-cmd --permanent --add-service mountd
   firewall-cmd --permanent --add-service rpc-bind
   firewall-cmd --permanent --add-service nfs
   ```

2. 指定 `/etc/nfs.conf` 文件中 RPC 服务 `nlockmgr` 使用的端口，如下所示： 					

   ```none
   [lockd]
   
   port=tcp-port-number
   udp-port=udp-port-number
   ```

   或者，您可以在 `/etc/modprobe.d/lockd.conf` 文件中指定 `nlm_tcpport` 和 `nlm_udpport`。 					

3. 在 NFS 服务器中运行以下命令打开防火墙中指定的端口： 					

   ```none
   firewall-cmd --permanent --add-port=<lockd-tcp-port>/tcp
   firewall-cmd --permanent --add-port=<lockd-udp-port>/udp
   ```

4. 通过编辑 `/etc/nfs.conf` 文件的 `[statd]` 部分为 `rpc.statd` 添加静态端口，如下所示： 					

   ```none
   [statd]
   
   port=port-number
   ```

5. 在 NFS 服务器中运行以下命令，在防火墙中打开添加的端口： 					

   ```none
   firewall-cmd --permanent --add-port=<statd-tcp-port>/tcp
   firewall-cmd --permanent --add-port=<statd-udp-port>/udp
   ```

6. 重新载入防火墙配置： 					

   ```none
   firewall-cmd --reload
   ```

7. 先重启 `rpc-statd` 服务，然后重启 `nfs-server` 服务： 					

   ```none
   # systemctl restart rpc-statd.service
   # systemctl restart nfs-server.service
   ```

   或者，如果您在 `/etc/modprobe.d/ lockd.conf` 文件中指定锁定端口： 					

   1. 更新 `/proc/sys/fs/nfs/nlm_tcpport` 和 `/proc/sys/fs/nfs/nlm_udpport` 的当前值： 							

      ```none
      # sysctl -w fs.nfs.nlm_tcpport=<tcp-port>
      # sysctl -w fs.nfs.nlm_udpport=<udp-port>
      ```

   2. 重启 `rpc-statd` 和 `nfs-server` 服务： 							

      ```none
      # systemctl restart rpc-statd.service
      # systemctl restart nfs-server.service
      ```

### 将只使用 NFSv4 的服务器配置为在防火墙后运行

下面的步骤描述了如何将只使用 NFSv4 的服务器配置为在防火墙后运行。

1. 要允许客户端在防火墙后访问 NFS 共享，在 NFS 服务器中运行以下命令配置防火墙： 					

   ```none
   firewall-cmd --permanent --add-service nfs
   ```

2. 重新载入防火墙配置： 					

   ```none
   firewall-cmd --reload
   ```

3. 重启 nfs-server： 					

   ```none
   # systemctl restart nfs-server
   ```

### 将 NFSv3 客户端配置为在防火墙后运行

将 NFSv3 客户端配置为在防火墙后运行的步骤类似于将 NFSv3 服务器配置为在防火墙后运行。 			

如果您要配置的机器既是 NFS 客户端和服务器，请按照 [将 NFSv3-enabled 服务器配置为在防火墙后运行](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_network_file_services/index#proc_configuring-the-nfsv3-enabled-server-to-run-behind-a-firewall_assembly_configuring-the-nfs-server-to-run-behind-a-firewall) 中所述的步骤进行。 			

以下流程描述了如何配置只在防火墙后运行的 NFS 客户端的机器。

1. 要在客户端位于防火墙后允许 NFS 客户端对 NFS 客户端执行回调，请在 NFS 客户端上运行以下命令将 `rpc-bind` 服务添加到防火墙中： 					

   ```none
   firewall-cmd --permanent --add-service rpc-bind
   ```

2. 指定 `/etc/nfs.conf` 文件中 RPC 服务 `nlockmgr` 使用的端口，如下所示： 					

   ```none
   [lockd]
   
   port=port-number
   udp-port=upd-port-number
   ```

   或者，您可以在 `/etc/modprobe.d/lockd.conf` 文件中指定 `nlm_tcpport` 和 `nlm_udpport`。 					

3. 在 NFS 客户端中运行以下命令打开防火墙中指定的端口： 					

   ```none
   firewall-cmd --permanent --add-port=<lockd-tcp-port>/tcp
   firewall-cmd --permanent --add-port=<lockd-udp-port>/udp
   ```

4. 通过编辑 `/etc/nfs.conf` 文件的 `[statd]` 部分为 `rpc.statd` 添加静态端口，如下所示： 					

   ```none
   [statd]
   
   port=port-number
   ```

5. 在 NFS 客户端中运行以下命令，在防火墙中打开添加的端口： 					

   ```none
   firewall-cmd --permanent --add-port=<statd-tcp-port>/tcp
   firewall-cmd --permanent --add-port=<statd-udp-port>/udp
   ```

6. 重新载入防火墙配置： 					

   ```none
   firewall-cmd --reload
   ```

7. 重启 `rpc-statd` 服务： 					

   ```none
   # systemctl restart rpc-statd.service
   ```

   或者，如果您在 `/etc/modprobe.d/ lockd.conf` 文件中指定锁定端口： 					

   1. 更新 `/proc/sys/fs/nfs/nlm_tcpport` 和 `/proc/sys/fs/nfs/nlm_udpport` 的当前值： 							

      ```none
      # sysctl -w fs.nfs.nlm_tcpport=<tcp-port>
      # sysctl -w fs.nfs.nlm_udpport=<udp-port>
      ```

   2. 重启 `rpc-statd` 服务： 							

      ```none
      # systemctl restart rpc-statd.service
      ```

### 将 NFSv4 客户端配置为在防火墙后运行

仅在客户端使用 NFSv4.0 时执行此步骤。在这种情况下，需要为 NFSv4.0 回调打开端口。 			

NFSv4.1 或更高版本不需要这个过程，因为在后续协议版本中，服务器在客户端发起的同一连接上执行回调。

1. 要允许 NFSv4.0 回调通过防火墙，请设置 `/proc/sys/fs/nfs_callback_tcpport` 并允许服务器连接到客户端上的该端口，如下所示： 					

   ```none
   # echo "fs.nfs.nfs_callback_tcpport = <callback-port>" >/etc/sysctl.d/90-nfs-callback-port.conf
   # sysctl -p /etc/sysctl.d/90-nfs-callback-port.conf
   ```

2. 在 NFS 客户端中运行以下命令打开防火墙中指定的端口： 					

   ```none
   firewall-cmd --permanent --add-port=<callback-port>/tcp
   ```

3. 重新载入防火墙配置： 					

   ```none
   firewall-cmd --reload
   ```

## 通过防火墙导出 RPC 配额

如果您导出使用磁盘配额的文件系统，您可以使用配额远程过程调用(RPC)服务来给 NFS 客户端提供磁盘配额数据。

1. 启用并启动 `rpc-rquotad` 服务： 				

   ```none
   # systemctl enable --now rpc-rquotad
   ```

   注意

   如果启用了 `rpc-rquotad` 服务，其会在启动 nfs-server 服务后自动启动。 					

2. 为了使配额 RPC 服务可在防火墙后访问，需要打开 TCP（如果启用了 UDP，则为 UDP）端口 875。默认端口号定义在 `/etc/services` 文件中。 				

   您可以通过将 `-p port-number` 附加到 `/etc/sysconfig/rpc-rquotad` 文件中的 `RPCRQUOTADOPTS` 变量来覆盖默认端口号。 				

3. 默认情况下，远程主机只能读配额。如果要允许客户端设置配额，请将 `-S` 选项附加到 `/etc/sysconfig/rpc-rquotad` 文件中的 `RPCRQUOTADOPTS` 变量中。 				

4. 重启 `rpc-rquotad` ，以使 `/etc/sysconfig/rpc-rquotad` 文件中的更改生效： 				

   ```none
   # systemctl restart rpc-rquotad
   ```

## 启用通过 RDMA(NFSoRDMA) 的 NFS

如果存在支持 RDMA 的硬件，则在 Red Hat Enterprise Linux 9 中，远程直接内存访问(RDMA)服务会自动工作。

1. 安装 `rdma-core` 软件包： 				

   ```none
   # dnf install rdma-core
   ```

2. 重启 `nfs-server` 服务： 				

   ```none
   # systemctl restart nfs-server
   ```

# 配置只使用 NFSv4 的服务器

​			作为 NFS 服务器管理员，您可以配置 NFS 服务器来仅支持 NFSv4，这可最大程度地减少系统上开放端口的数量和运行的服务。 	

## 5.1. 只使用 NFSv4 的服务器的好处和缺陷

​				这部分论述了将 NFS 服务器配置为只支持 NFSv4 的优点和缺陷。 		

​				默认情况下，NFS 服务器在 Red Hat Enterprise Linux 9 中支持 NFSv3 和 NFSv4  连接。但是，您还可以将 NFS 配置为只支持 NFS 版本 4.0 及更新的版本。这可最大限度地减少系统上打开的端口的数量和运行的服务，因为  NFSv4 不需要 `rpcbind` 服务来侦听网络。 		

​				当您的 NFS 服务器配置为仅使用 NFSv4 时，尝试使用 NFSv3 挂载共享的客户端会失败，并显示类似如下的错误： 		

```none
Requested NFS version or transport protocol is not supported.
```

​				另外，您还可以禁用对 `RPCBIND` 、`MOUNT` 和 `NSM` 协议调用的监听，这在仅使用 NFSv4 的情况下不需要。 		

​				禁用这些额外选项的影响有： 		

- ​						试图使用 NFSv3 从服务器挂载共享的客户端变得无响应。 				
- ​						NFS 服务器本身无法挂载 NFSv3 文件系统。 				

# 将 NFS 服务器配置为只支持 NFSv4

​				这个步骤描述了如何配置 NFS 服务器来支持 NFS 版本 4.0 及更新的版本。 		

**流程**

1. ​						通过在 `/etc/nfs.conf` 配置文件的 `[nfsd]` 部分添加以下行来禁用 NFSv3： 				

   ```none
   [nfsd]
   
   vers3=no
   ```

2. ​						（可选）禁用对 `RPCBIND`、`MOUNT` 和 `NSM` 协议调用的监听，在仅使用 NFSv4 情况下不需要这些调用。禁用相关服务： 				

   ```none
   # systemctl mask --now rpc-statd.service rpcbind.service rpcbind.socket
   ```

3. ​						重启 NFS 服务器： 				

   ```none
   # systemctl restart nfs-server
   ```

​				一旦启动或重启 NFS 服务器，这些改变就会生效。 		

# 验证只读 NFSv4 配置

​				这个流程描述了如何使用 `netstat` 工具来验证您的 NFS 服务器是否是在仅使用 NFSv4 模式下配置的。 		

**流程**

- ​						使用 `netstat` 工具列出侦听 TCP 和 UDP 协议的服务： 				

  ```none
  # netstat --listening --tcp --udp
  ```

  **例 5.1. 仅使用 NFSv4 服务器上的输出**

  ​							以下是仅使用 NFSv4 服务器上 `netstat` 输出的示例；也禁用了对 `RPCBIND`、`MOUNT` 和 `NSM` 的侦听。这里，`nfs` 是唯一侦听 NFS 的服务： 					

  ```none
  # netstat --listening --tcp --udp
  
  Active Internet connections (only servers)
  Proto Recv-Q Send-Q Local Address           Foreign Address         State
  tcp        0      0 0.0.0.0:ssh             0.0.0.0:*               LISTEN
  tcp        0      0 0.0.0.0:nfs             0.0.0.0:*               LISTEN
  tcp6       0      0 [::]:ssh                [::]:*                  LISTEN
  tcp6       0      0 [::]:nfs                [::]:*                  LISTEN
  udp        0      0 localhost.locald:bootpc 0.0.0.0:*
  ```

  **例 5.2. 配置仅使用 NFSv4 服务器前的输出**

  ​							相比之下，在配置仅使用 NFSv4 服务器前，`netstat` 输出中包含 `sunrpc` 和 `mountd` 服务： 					

  ```none
  # netstat --listening --tcp --udp
  
  Active Internet connections (only servers)
  Proto Recv-Q Send-Q Local Address           Foreign Address State
  tcp        0      0 0.0.0.0:ssh             0.0.0.0:*       LISTEN
  tcp        0      0 0.0.0.0:40189           0.0.0.0:*       LISTEN
  tcp        0      0 0.0.0.0:46813           0.0.0.0:*       LISTEN
  tcp        0      0 0.0.0.0:nfs             0.0.0.0:*       LISTEN
  tcp        0      0 0.0.0.0:sunrpc          0.0.0.0:*       LISTEN
  tcp        0      0 0.0.0.0:mountd          0.0.0.0:*       LISTEN
  tcp6       0      0 [::]:ssh                [::]:*          LISTEN
  tcp6       0      0 [::]:51227              [::]:*          LISTEN
  tcp6       0      0 [::]:nfs                [::]:*          LISTEN
  tcp6       0      0 [::]:sunrpc             [::]:*          LISTEN
  tcp6       0      0 [::]:mountd             [::]:*          LISTEN
  tcp6       0      0 [::]:45043              [::]:*          LISTEN
  udp        0      0 localhost:1018          0.0.0.0:*
  udp        0      0 localhost.locald:bootpc 0.0.0.0:*
  udp        0      0 0.0.0.0:mountd          0.0.0.0:*
  udp        0      0 0.0.0.0:46672           0.0.0.0:*
  udp        0      0 0.0.0.0:sunrpc          0.0.0.0:*
  udp        0      0 0.0.0.0:33494           0.0.0.0:*
  udp6       0      0 [::]:33734              [::]:*
  udp6       0      0 [::]:mountd             [::]:*
  udp6       0      0 [::]:sunrpc             [::]:*
  udp6       0      0 [::]:40243              [::]:*
  ```

## NFS 客户端

### 发现 NFS 导出

- 对于支持 NFSv3 的任何服务器，使用 `showmount` 工具：

  ```bash
  showmount --exports my-server
  
  Export list for my-server
  /exports/foo
  /exports/bar
  ```

- 对于支持 NFSv4 的任何服务器，挂载根目录并查找：

  ```bash
  mount my-server:/ /mnt/
  
  ls /mnt/
  exports
  
  ls /mnt/exports/
  foo
  bar
  ```

在同时支持 NFSv4 和 NFSv3 的服务器上，这两种方法都可以工作，并给出同样的结果。

### 使用 mount 挂载 NFS 共享		

```bash
mount -t nfs -o options host:/remote/export /local/directory
```

以下列出在挂载 NFS 共享时常用的选项。这些选项可用于手动挂载命令、`/etc/fstab` 设置和 `autofs`。

- `lookupcache=mode`

  指定内核应该如何管理给定挂载点的目录条目缓存。mode 的有效参数为 `all`、`none` 或 `positive`。 					

- `nfsvers=version`

  指定要使用 NFS 协议的哪个版本，其中 version 为 `3`、`4`、`4.0`、`4.1` 或 `4.2`。对于运行多个 NFS 服务器的主机很有用，或者禁止使用较低版本重试挂载。如果没有指定版本，NFS 将使用内核和 `mount` 工具支持的最高版本。

  选项 `vers` 等同于 `nfsvers` ，出于兼容性的原因包含在此发行版本中。

- `noacl`

  关闭所有 ACL 处理。当与旧版本的 RHEL、Red Hat Linux 或 Solaris 交互时，可能需要此功能，因为最新的 ACL 技术与较旧的系统不兼容。

- `nolock`

  禁用文件锁定。当连接到非常旧的 NFS 服务器时，有时需要这个设置。

- `noexec`

  防止在挂载的文件系统中执行二进制文件。这在系统挂载不兼容二进制文件的非 Linux 文件系统时有用。

- `nosuid`

  禁用 `set-user-identifier` 和 `set-group-identifier` 位。这可防止远程用户通过运行 `setuid` 程序获得更高的特权。

- `port=num`

  指定 NFS 服务器端口的数字值。如果 *num* 为 `0`（默认值），则 `mount` 查询远程主机上 `rpcbind` 服务，以获取要使用的端口号。如果远程主机上的 NFS 服务没有注册其 `rpcbind` 服务，则使用标准的 NFS 端口号 TCP 2049。

- `rsize=num` 和 `wsize=num`

  这些选项设定单一 NFS 读写操作传输的最大字节数。`rsize` 和 `wsize` 没有固定的默认值。默认情况下，NFS 使用服务器和客户端都支持的最大的可能值。在 RHEL 9 中，客户端和服务器最大为 1,048,576 字节。			

- `sec=flavors`

  用于访问挂载导出上文件的安全类别。flavors 值是一个冒号分隔的、由一个或多个安全类别组成的列表。

  默认情况下，客户端会尝试查找客户端和服务器都支持的安全类别。如果服务器不支持任何选定的类别，挂载操作将失败。可用类别：

  * `sec=sys` 使用本地 UNIX UID 和 GID。它们使用 `AUTH_SYS` 验证 NFS 操作。
  * `sec=krb5` 使用 Kerberos V5 ,而不是本地 UNIX UID 和 GID 来验证用户。
  * `sec=krb5i` 使用 Kerberos V5 进行用户身份验证，并使用安全校验和执行 NFS 操作的完整性检查，以防止数据被篡改。
  * `sec=krb5p` 使用 Kerberos V5 进行用户身份验证、完整性检查，并加密 NFS 流量以防止流量嗅探。这是最安全的设置，但它也会涉及最大的性能开销。

- `tcp`

  指示 NFS 挂载使用 TCP 协议。 					

# 第 3 章 保护 NFS

​			为最大程度地降低 NFS 安全风险并保护服务器上的数据，在服务器上导出 NFS 文件系统或将其挂载到客户端上时，请考虑以下部分： 	

## 3.1. 带有 AUTH_SYS 和导出控制的 NFS 安全性

​				NFS 提供以下传统选项来控制对导出文件的访问： 		

- ​						服务器限制哪些主机可以通过 IP 地址或主机名挂载哪些文件系统。 				
- ​						服务器对 NFS 客户端上的用户强制执行文件系统权限的方式与对本地用户强制执行权限的方式相同。传统上，NFS 使用 `AUTH_SYS` 调用消息（也称为 `AUTH_UNIX`）来执行此操作，该消息依赖于客户端来声明用户的 UID 和 GID。请注意，这意味着恶意或者错误配置的客户端可能会轻松地利用这个问题，导致用户可以访问不应该被访问的文件。 				

​				为限制潜在的风险，管理员通常将访问权限限制为只读或将用户权限挤压成普通用户和组 ID。不幸的是，这些解决方案会阻止 NFS 共享以最初预期的方式使用。 		

​				另外，如果攻击者获得了对导出 NFS 文件系统的系统所使用的 DNS 服务器的控制，它们可将与特定主机名或完全限定域名关联的系统指向未授权的机器。此时，未经授权的机器 *是* 允许挂载 NFS 共享的系统，因为没有交换用户名或密码信息来为 NFS 挂载提供额外的安全。 		

​				在通过 NFS 导出目录时应谨慎使用通配符，因为通配符的范围可能包含比预期更多的系统。 				

## 3.2. 带有 `AUTH_GSS` 的 NFS 安全性

​				NFS 的所有版本都支持 RPCSEC_GSS 和 Kerberos 机制。 		

​				与 AUTH_SYS 不同，使用 RPCSEC_GSS Kerberos  机制，服务器不依赖于客户端就可以正确地表示哪个用户正在访问文件。相反，加密用于向服务器验证用户的身份，这可防止恶意的客户端在没有用户的  Kerberos 凭据的情况下模拟该用户。使用 RPCSEC_GSS Kerberos 机制是保护挂载的最直接方法，因为配置了 Kerberos 后不需要额外的设置。 		

## 3.3. 配置 NFS 服务器和客户端使用 Kerberos

​				Kerberos 是一种网络身份验证系统，其允许客户端和服务器使用对称加密和信任的第三方 KDC 来互相进行身份验证。红帽建议使用身份管理(IdM)来设置 Kerberos。 		

**先决条件**

- ​						Kerberos 密钥分发中心(`KDC`)已安装和配置 。 				

**流程**

1. ​					

   - ​								在 NFS 服务器端创建 `nfs/hostname.*domain@REALM*` 主体。 						
   - ​								在服务器和客户端端创建 `host/hostname.*domain@REALM*` 主体。 						
   - ​								将对应的密钥添加到客户端和服务器的 keytab 中。 						

2. ​						在服务器端，使用 `sec=` 选项来启用所想要的安全类别。启用所有安全类型和非加密挂载： 				

   ```none
   /export *(sec=sys:krb5:krb5i:krb5p)
   ```

   ​						与 `sec=` 选项一起使用的有效安全类型为： 				

   - ​								`sys`: 无加密保护，默认值 						
   - ​								`krb5` ：仅用于验证 						
   - ​								`krb5i` ：完整性保护 						
     - ​										使用 Kerberos V5 进行用户身份验证，并使用安全校验和执行 NFS 操作的完整性检查，以防止数据篡改。 								
   - ​								`krb5p` ：隐私保护 						
     - ​										使用 Kerberos V5 进行用户身份验证、完整性检查及加密 NFS 流量以防止流量嗅探。这是最安全的设置，但它也会涉及最大的性能开销。 								

3. ​						在客户端，将 `sec=krb5` （或 `sec=krb5i` 或 `sec=krb5p`，取决于设置 ）添加到挂载选项： 				

   ```none
   # mount -o sec=krb5 server:/export /mnt
   ```

**其它资源**

- ​						[在 krb5 保护的 NFS 上以 root 用户身份创建文件](https://access.redhat.com/articles/4040141).不建议。 				
- ​						`exports(5)` 手册页 				
- ​						`nfs(5)` 手册页 				

## 3.4. NFSv4 安全选项

​				NFSv4 包括基于 Microsoft Windows NT 模型，而非 POSIX 模型的 ACL 支持，因为 Microsoft Windows NT 模型的功能和广泛的部署。 		

​				NFSv4 的另一个重要安全功能是，对挂载文件系统删除了 `MOUNT` 协议的使用。`MOUNT` 协议存在安全风险，因为协议处理文件句柄的方式。 		

## 3.5. 挂载的 NFS 导出的文件权限

​				远程主机一旦将 NFS 文件系统挂载为读取或读写，则保护每个共享文件的唯一方法就是其权限。如果共享同一用户 ID  值的两个用户在不同的客户端系统上挂载相同的 NFS 文件系统，他们可以修改彼此的文件。此外，在客户端系统上以 root  身份登录的任何人都可以使用 `su -` 命令来访问 NFS 共享的任何文件。 		

​				默认情况下，Red Hat Enterprise Linux 的 NFS 支持访问控制列表（ACL）。红帽建议启用此功能。 		

​				默认情况下，NFS 在导出文件系统时使用 *root squashing*。这会将本地机器上以 root 用户身份访问 NFS 共享的任何人的用户 ID 设为 `nobody`。Root squashing 由默认选项 `root_squash` 控制；有关此选项的更多信息，请参阅 [NFS 服务器配置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_file_systems/exporting-nfs-shares_managing-file-systems#nfs-server-configuration_exporting-nfs-shares)。 		

​				将 NFS 共享导出为只读时，请考虑使用 `all_squash` 选项。这个选项使访问导出的文件系统的每个用户都使用 `nobody` 用户的用户 ID。 		

# 第 4 章 在 NFS 中启用 pNFS SCSI 布局

​			您可以将 NFS 服务器和客户端配置为使用 pNFS SCSI 布局访问数据。 	

**先决条件**

- ​					客户端和服务器必须能够向同一个块设备发送 SCSI 命令。就是说块设备必须位于共享的 SCSI 总线中。 			
- ​					块设备必须包含 XFS 文件系统。 			
- ​					SCSI 设备必须支持 SCSI Persistent Reservations，如 SCSI-3 Ppriary Commands 规格中所述。 			

## 4.1. pNFS 技术

​				pNFS 构架提高了 NFS 的可伸缩性。当服务器实现 pNFS 时，客户端可以同时通过多个服务器访问数据。这可提高性能。 		

​				pNFS 支持 RHEL 中的以下存储协议或布局： 		

- ​						文件 				
- ​						Flexfiles 				
- ​						SCSI 				

## 4.2. pNFS SCSI 布局

​				SCSI 布局基于 pNFS 块布局的工作。布局在 SCSI 设备中定义。它包含一系列固定大小的块来作为逻辑单元(LU)，这些逻辑单元必须能够支持 SCSI 持久保留。LU 设备识别通过其 SCSI 设备识别。 		

​				在涉及长时间的单客户端访问文件的用例中，pNFS SCSI 表现良好。例如：邮件服务器或者虚拟机。 		

#### 客户端和服务器间的操作

​				当 NFS 客户端从文件读取或写入文件时，客户端会执行 `LAYOUTGET` 操作。服务器会使用文件在 SCSI 设备中的位置进行响应。客户端可能需要执行 `GETDEVICEINFO` 的额外操作，以确定要使用哪个 SCSI 设备。如果这些操作正常工作，客户端可以直接向 SCSI 设备发出 I/O 请求，而不必向服务器发送 `READ` 和 `WRITE` 操作。 		

​				客户端之间的错误或争用可能会导致服务器重新调用布局，或者不将它们发送给客户端。在这些情况下，客户端回退到向服务器发出 `READ` 和 `WRITE` 操作，而不是直接向 SCSI 设备发送 I/O 请求。 		

​				要监控操作，请参阅 [监控 pNFS SCSI 布局功能](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/managing_file_systems/index#monitoring-pnfs-scsi-layouts-functionality_managing-file-systems)。 		

#### 设备保留

​				pNFS SCSI 通过分配保留来处理保护。在服务器向客户端发送布局之前，它会保留 SCSI  设备，以确保只有注册的客户端才可以访问该设备。如果客户端可以向那个 SCSI  设备发送命令，但没有在该设备上注册，那么该设备上的客户端的许多操作都会失败。例如，如果服务器没有向客户端提供该设备的布局，则客户端上的 `blkid` 命令将无法显示 XFS 文件系统的 UUID。 		

​				服务器不会删除其自身的持久性保留。这样可在重启客户端和服务器后保护该设备中的文件系统中的数据。为了重新使用 SCSI 设备，您可能需要手动删除 NFS 服务器中的持久性保留。 		

## 4.3. 检查与 pNFS 兼容的 SCSI 设备

​				这个过程检查 SCSI 设备是否支持 pNFS SCSI 布局。 		

**先决条件**

- ​						安装 `sg3_utils` 软件包： 				

  ```none
  # dnf install sg3_utils
  ```

**流程**

- ​						在服务器和客户端中检查正确的 SCSI 设备支持： 				

  ```none
  # sg_persist --in --report-capabilities --verbose path-to-scsi-device
  ```

  ​						确保设置了 *Persist Through Power Los Active* (`PTPL_A`)位。 				

  **例 4.1. 支持 pNFS SCSI 的 SCSI 设备**

  ​							以下是支持 pNFS SCSI 的 SCSI 设备的 `sg_persist` 输出示例。`PTPL_A` 位报告 `1`。 					

  ```none
      inquiry cdb: 12 00 00 00 24 00
      Persistent Reservation In cmd: 5e 02 00 00 00 00 00 20 00 00
    LIO-ORG   block11           4.0
    Peripheral device type: disk
  Report capabilities response:
    Compatible Reservation Handling(CRH): 1
    Specify Initiator Ports Capable(SIP_C): 1
    All Target Ports Capable(ATP_C): 1
    Persist Through Power Loss Capable(PTPL_C): 1
    Type Mask Valid(TMV): 1
    Allow Commands: 1
    Persist Through Power Loss Active(PTPL_A): 1
      Support indicated in Type mask:
        Write Exclusive, all registrants: 1
        Exclusive Access, registrants only: 1
        Write Exclusive, registrants only: 1
        Exclusive Access: 1
        Write Exclusive: 1
        Exclusive Access, all registrants: 1
  ```

**其它资源**

- ​						`sg_persist(8)` man page 				

## 4.4. 在服务器中设置 pNFS SCSI

​				这个过程将 NFS 服务器配置为导出 pNFS SCSI 布局。 		

**流程**

1. ​						在服务器中挂载在 SCSI 设备中创建的 XFS 文件系统。 				

2. ​						将 NFS 服务器配置为导出 NFS 版本 4.1 或更高版本。在 `/etc/nfs.conf` 文件的 `[nfsd]` 部分设置以下选项： 				

   ```none
   [nfsd]
   
   vers4.1=y
   ```

3. ​						配置 NFS 服务器，来使用 `pnfs` 选项通过 NFS 导出 XFS 文件系统： 				

   **例 4.2. /etc/exports 中的条目导出 pNFS SCSI**

   ​							`/etc/exports` 配置文件中的以下条目将挂载于 `/exported/directory/` 的文件系统导出到 `allowed.example.com` 客户端，来作为 pNFS SCSI 布局： 					

   ```none
   /exported/directory allowed.example.com(pnfs)
   ```

**其它资源**

- ​						[导出 NFS 共享](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_file_systems/exporting-nfs-shares_managing-file-systems). 				

## 4.5. 在客户端中设置 pNFS SCSI

​				这个过程将 NFS 客户端配置为挂载 pNFS SCSI 布局。 		

**先决条件**

- ​						NFS 服务器被配置为通过 pNFS SCSI 导出 XFS 文件系统。[请参阅在服务器 中设置 pNFS SCSI](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/managing_file_systems/index#setting-up-pnfs-scsi-on-the-server_enabling-pnfs-scsi-layouts-in-nfs)。 				

**流程**

- ​						在客户端中使用 NFS 版本 4.1 或更高版本挂载导出的 XFS 文件系统： 				

  ```none
  # mount -t nfs -o nfsvers=4.1 host:/remote/export /local/directory
  ```

  ​						不要在没有 NFS 的情况下直接挂载 XFS 文件系统。 				

**其它资源**

- ​						[挂载 NFS 共享](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/managing_file_systems/index#mounting-nfs-shares_managing-file-systems)。 				

## 4.6. 在服务器中释放 pNFS SCSI 保留

​				此流程释放 NFS 服务器在 SCSI 设备中拥有的持久保留。这可让您在不再需要导出 pNFS SCSI 时重新使用 SCSI 设备。 		

​				您必须从服务器中删除保留。它不能从不同的 IT Nexus 中删除。 		

**先决条件**

- ​						安装 `sg3_utils` 软件包： 				

  ```none
  # dnf install sg3_utils
  ```

**流程**

1. ​						在服务器上查询现有保留： 				

   ```none
   # sg_persist --read-reservation path-to-scsi-device
   ```

   **例 4.3. 在 /dev/sda 中查询保留**

   ```none
   # *sg_persist --read-reservation /dev/sda*
   
     LIO-ORG   block_1           4.0
     Peripheral device type: disk
     PR generation=0x8, Reservation follows:
       Key=0x100000000000000
       scope: LU_SCOPE,  type: Exclusive Access, registrants only
   ```

2. ​						删除服务器上的现有注册： 				

   ```none
   # sg_persist --out \
                --release \
                --param-rk=reservation-key \
                --prout-type=6 \
                path-to-scsi-device
   ```

   **例 4.4. 删除 /dev/sda 中的保留**

   ```none
   # sg_persist --out \
                --release \
                --param-rk=0x100000000000000 \
                --prout-type=6 \
                /dev/sda
   
     LIO-ORG   block_1           4.0
     Peripheral device type: disk
   ```

#  监控 pNFS SCSI 布局功能

​			您可以监控 pNFS 客户端和服务器是否交换正确的 pNFS SCSI 操作，或者它们是否回退到常规的 NFS 操作。 	

**先决条件**

- ​					配置了 pNFS SCSI 客户端和服务器。 			

## 8.1. 使用 nfsstat 从服务器检查 pNFS SCSI 操作

​				这个流程使用 `nfsstat` 工具来监控服务器的 pNFS SCSI 操作。 		

**流程**

1. ​						监控服务器中服务的操作： 				

   ```none
   # watch --differences \
           "nfsstat --server | egrep --after-context=1 read\|write\|layout"
   
   Every 2.0s: nfsstat --server | egrep --after-context=1 read\|write\|layout
   
   putrootfh    read         readdir      readlink     remove	 rename
   2         0% 0         0% 1         0% 0         0% 0         0% 0         0%
   --
   setcltidconf verify	  write        rellockowner bc_ctl	 bind_conn
   0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
   --
   getdevlist   layoutcommit layoutget    layoutreturn secinfononam sequence
   0         0% 29        1% 49        1% 5         0% 0         0% 2435     86%
   ```

2. ​						客户端和服务器在以下情况下使用 pNFS SCSI 操作： 				

   - ​								`layoutget`、`layoutreturn` 和 `layoutcommit` 计数器递增。这意味着服务器提供布局。 						
   - ​								服务器 `读` 和 `写` 计数器不会递增。这意味着客户端正在直接向 SCSI 设备执行 I/O 请求。 						

# 使用 mountstats 检查客户端中的 pNFS SCSI 操作

​				这个流程使用 `/proc/self/mountstats` 文件来监控客户端的 pNFS SCSI 操作。 		

**流程**

1. ​						列出每个挂载的操作计数器： 				

   ```none
   # cat /proc/self/mountstats \
         | awk /scsi_lun_0/,/^$/ \
         | egrep device\|READ\|WRITE\|LAYOUT
   
   device 192.168.122.73:/exports/scsi_lun_0 mounted on /mnt/rhel7/scsi_lun_0 with fstype nfs4 statvers=1.1
       nfsv4:  bm0=0xfdffbfff,bm1=0x40f9be3e,bm2=0x803,acl=0x3,sessions,pnfs=LAYOUT_SCSI
               READ: 0 0 0 0 0 0 0 0
              WRITE: 0 0 0 0 0 0 0 0
           READLINK: 0 0 0 0 0 0 0 0
            READDIR: 0 0 0 0 0 0 0 0
          LAYOUTGET: 49 49 0 11172 9604 2 19448 19454
       LAYOUTCOMMIT: 28 28 0 7776 4808 0 24719 24722
       LAYOUTRETURN: 0 0 0 0 0 0 0 0
        LAYOUTSTATS: 0 0 0 0 0 0 0 0
   ```

2. ​						在结果中： 				

   - ​								`LAYOUT` 统计数据指示客户端和服务器使用 pNFS SCSI 操作的请求。 						
   - ​								`读` 和 `写` 统计指示客户端和服务器回退到 NFS 操作的请求。 						

# 在 NFS 中使用缓存

​			除非明确指示，否则 NFS 将不会使用缓存。本段落介绍了如何使用 FS-Cache 配置 NFS 挂载。 	

**先决条件**

- ​					**cachefilesd** 软件包已安装并在运行。要确保它正在运行，请使用以下命令： 			

  ```none
  # systemctl start cachefilesd
  # systemctl status cachefilesd
  ```

  ​					状态必须 *处于活动状态（正在运行）* 。 			

- ​					使用以下选项挂载 NFS 共享： 			

  ```none
  # mount nfs-share:/ /mount/point -o fsc
  ```

  ​					对 `*/mount/point*` 下文件的所有访问都将通过缓存，除非文件是为了直接 I/O 或写而打开。如需更多信息，请参阅 [NFS 的缓存限制](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/managing_file_systems/index#cache-limitations-with-nfs_using-the-cache-with-nfs)。 			

​			NFS 使用 NFS 文件句柄 *而不是* 文件名来索引缓存内容，这意味着硬链接的文件可以正确共享缓存。 	

​			NFS 版本 3、4.0、4.1 和 4.2 支持缓存。但是，每个版本使用不同的分支进行缓存。 	

## 10.1. 配置 NFS 缓存共享

​				与 NFS 缓存共享相关的一些潜在问题。因为缓存是持久的，所以缓存中的数据块会根据由四个键组成的序列来索引的： 		

- ​						第 1 级：服务器详情 				
- ​						第 2 级：一些挂载选项；安全类型；FSID；uniquifier 				
- ​						第 3 级：文件处理 				
- ​						第 4 级：文件中的页号 				

​				为避免超级块之间一致性管理的问题，需要缓存数据的所有 NFS 超级块都有唯一的第 2 级键。通常，两个 NFS 挂载使用相同的源卷和选项共享超级块，因此共享缓存，即使它们在该卷中挂载不同的目录。 		

​				以下是如何通过不同选项配置缓存共享的示例。 		

**流程**

1. ​						使用以下命令挂载 NFS 共享： 				

   ```none
   mount home0:/disk0/fred /home/fred -o fsc
   mount home0:/disk0/jim /home/jim -o fsc
   ```

   ​						这里，`/home/fred` 和 `/home/jim` 可能会共享超级块，因为它们具有相同的选项，尤其是如果它们来自 NFS 服务器(`home0`)上的相同的卷/分区。 				

2. ​						要不共享超级块，请使用 `mount` 命令和以下选项： 				

   ```none
   mount home0:/disk0/fred /home/fred -o fsc,rsize=8192
   mount home0:/disk0/jim /home/jim -o fsc,rsize=65536
   ```

   ​						在这种情况下，`/home/fred` 和 `/home/jim` 将不会共享超级块，因为它们具有不同的网络访问参数，这些参数是第 2 级键的一部分。 				

3. ​						要在不共享超级块的情况下缓存两个子树（`/home/fred1` 和 `/home/fred2`）的内容 *两次*，请使用以下命令： 				

   ```none
   mount home0:/disk0/fred /home/fred1 -o fsc,rsize=8192
   mount home0:/disk0/fred /home/fred2 -o fsc,rsize=65536
   ```

4. ​						避免超级块共享的另一种方法是使用 `nosharecache` 参数显式阻止它。使用相同的示例： 				

   ```none
   mount home0:/disk0/fred /home/fred -o nosharecache,fsc
   mount home0:/disk0/jim /home/jim -o nosharecache,fsc
   ```

   ​						但是，在这种情况下，只允许其中一个超级块使用缓存，因为无法区分 `home0:/disk0/fred` 和 `home0:/disk0/jim` 的第 2 级键。 				

5. ​						要指定对超级块的寻址，请在至少在一个挂载上添加一个 *唯一标识符*，例如 `fsc=*唯一标识符*` ： 				

   ```none
   mount home0:/disk0/fred /home/fred -o nosharecache,fsc
   mount home0:/disk0/jim /home/jim -o nosharecache,fsc=jim
   ```

   ​						这里，唯一标识符 `jim` 被添加到 `/home/jim` 缓存中所使用的第 2 级键中。 				

重要

​					用户不能在具有不同通信或协议参数的超级块之间共享缓存。例如，在 NFSv4.0 和 NFSv3 之间或在 NFSv4.1 和  NFSv4.2  之间无法共享，因为它们会强制使用不同的超级块。另外，设置读取大小(rsize)等参数可防止缓存共享，因为它也强制使用不同的超级块。 					

# NFS 的缓存限制

​				NFS 有一些缓存限制： 		

- ​						为直接 I/O 打开共享文件系统的文件将自动绕过缓存。这是因为这种访问类型必须与服务器直接进行。 				

- ​						从共享文件系统打开一个文件直接 I/O 或写入清除文件缓存的副本。FS-Cache 不会再次缓存文件，直到它不再为直接 I/O 或写操作而打开。 				
- ​						另外，FS-Cache 的这个发行版本只缓存常规 NFS 文件。FS-Cache *不会* 缓存目录、符号链接、设备文件、FIFO 和套接字。 				

## RPC (Remote Procedure Call)

NFS 支持的功能相当的多，而不同的功能都会使用不同的程序来启动， 	每启动一个功能就会启用一些端口来传输数据，因此， NFS 的功能所对应的端口才没有固定住， 	而是随机取用一些未被使用的小于 1024 的埠口来作为传输之用。但如此一来又造成客户端想要连上服务器时的困扰， 	因为客户端得要知道服务器端的相关埠口才能够联机吧！

此时我们就得需要远程过程调用 (RPC) 的服务啦！RPC 最主要的功能就是在指定每个  	NFS 功能所对应的 port number ，并且回报给客户端，让客户端可以连结到正确的埠口上去。 	那 RPC 又是如何知道每个 NFS 的埠口呢？这是因为当服务器在启动  	NFS 时会随机取用数个埠口，并主动的向 RPC 注册，因此 RPC 可以知道每个埠口对应的 NFS 	功能，然后 RPC 又是固定使用 port 111 来监听客户端的需求并回报客户端正确的埠口， 	所以当然可以让 NFS 的启动更为轻松愉快了！

![NFS 与 RPC 服务及文件系统操作的相关性](http://cn.linux.vbird.org/linux_server/0330nfs_files/nfs_rpc.png)
如上图所示，当客户端有 NFS 档案存取需求时，他会如何向服务器端要求数据呢？

1. 客户端会向服务器端的 RPC (port 111) 发出 NFS 档案存取功能的询问要求；
2. 服务器端找到对应的已注册的 NFS daemon 埠口后，会回报给客户端；
3. 客户端了解正确的埠口后，就可以直接与 NFS daemon 来联机。

由于 NFS 的各项功能都必须要向 RPC 来注册，如此一来 RPC 才能了解 NFS 这个服务的各项功能之 	port number, PID, NFS 在服务器所监听的 IP 等等，而客户端才能够透过 RPC 的询问找到正确对应的埠口。 	也就是说，NFS 必须要有 RPC 存在时才能成功的提供服务，因此我们称 NFS 为 RPC server  	的一种。事实上，有很多这样的服务器都是向 RPC 注册的，举例来说，NIS (Network Information Service) 也是  	RPC server 的一种呢。此外，由图 13.1-2 你也会知道，不论是客户端还是服务器端，要使用 NFS  	时，两者都需要启动 RPC 才行喔！

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.1.3 NFS 启动的 RPC daemons

我们现在知道 NFS 服务器在启动的时候就得要向 RPC 注册，所以 NFS 服务器也被称为 RPC server 之一。 	那么 NFS 服务器主要的任务是进行文件系统的分享，文件系统的分享则与权限有关。 	所以 NFS 服务器启动时至少需要两个 daemons ，一个管理客户端是否能够登入的问题， 	一个管理客户端能够取得的权限。如果你还想要管理 quota 的话，那么 NFS  	还得要再加载其他的 RPC 程序就是了。我们以较单纯的 NFS 服务器来说：

- rpc.nfsd：
   	最主要的 NFS 服务器服务提供商。这个 daemon 主要的功能就是在管理客户端是否能够使用服务器文件系统挂载信息等， 	其中还包含这个登入者的 ID 的判别喔！

  

- rpc.mountd
   	这个 daemon 主要的功能，则是在管理 NFS 的文件系统哩！当客户端顺利的通过 rpc.nfsd  	而登入服务器之后，在他可以使用 NFS 服务器提供的档案之前，还会经过档案权限  	(就是那个 -rwxrwxrwx 与 owner, group 那几个权限啦) 的认证程序！他会去读 NFS 的配置文件  	/etc/exports 来比对客户端的权限，当通过这一关之后客户端就可以取得使用 NFS  	档案的权限啦！(注：这个也是我们用来管理 NFS 分享之目录的权限与安全设定的地方哩！)

  

- rpc.lockd (非必要)
   	这个玩意儿可以用在管理档案的锁定 (lock) 用途。为何档案需要『锁定』呢？ 	因为既然分享的 NFS 档案可以让客户端使用，那么当多个客户端同时尝试写入某个档案时， 	就可能对于该档案造成一些问题啦！这个 rpc.lockd 则可以用来克服这个问题。 	但 rpc.lockd 必须要同时在客户端与服务器端都开启才行喔！此外， rpc.lockd 也常与 rpc.statd 同时启用。

  

- rpc.statd (非必要)
   	可以用来检查档案的一致性，与 rpc.lockd 有关！若发生因为客户端同时使用同一档案造成档案可能有所损毁时， 	rpc.statd 可以用来检测并尝试回复该档案。与 rpc.lockd 	同样的，这个功能必须要在服务器端与客户端都启动才会生效。

上述这几个 RPC 所需要的程序，其实都已经写入到两个基本的服务启动脚本中了，那就是 nfs 以及 nfslock 啰！ 	亦即是在 /etc/init.d/nfs, /etc/init.d/nfslock，与服务器较有关的写入在 nfs 服务中，而与客户端的 rpc.lockd  	之类的，就设定于 nfslock 服务中。

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.1.4 NFS 的档案访问权限

不知道你有没有想过这个问题，在[图 13.1-1](http://cn.linux.vbird.org/linux_server/0330nfs.php#fig13.1-1) 的环境下，假如我在 NFS client 1 上面以 	dmtsai 这个使用者身份想要去存取 /home/data/sharefile/ 这个来自 NFS server 所提供的文件系统时， 	请问 NFS server 所提供的文件系统会让我以什么身份去存取？是 dmtsai 还是？

为什么会这么问呢？这是因为 NFS 本身的服务并没有进行身份登入的识别， 	所以说，当你在客户端以 dmtsai 的身份想要存取服务器端的文件系统时， 	服务器端会以客户端的使用者 	UID 与 GID 等身份来尝试读取服务器端的文件系统。这时有个有趣的问题就产生啦！ 	那就是如果客户端与服务器端的使用者身份并不一致怎么办？  	我们以底下这个图示来说明一下好了：

![NFS 的服务器端与客户端的使用者身份确认机制](http://cn.linux.vbird.org/linux_server/0330nfs_files/nfs_auth.png)
 	图 13.1-3、NFS 的服务器端与客户端的使用者身份确认机制

当我以 dmtsai 这个一般身份使用者要去存取来自服务器端的档案时，你要先注意到的是： 	文件系统的 inode 所记录的属性为 UID, GID 而非账号与群组名。 	那一般 Linux 主机会主动的以自己的 /etc/passwd, /etc/group 来查询对应的使用者、组名。 	所以当 dmtsai 进入到该目录后，会参照 NFS client 1 的使用者与组名。 	但是由于该目录的档案主要来自 NFS server ，所以可能就会发现几个情况：

- NFS server/NFS client 刚好有相同的账号与群组
   	则此时使用者可以直接以 dmtsai 的身份进行服务器所提供的文件系统之存取。

  

- NFS server 的 501 这个 UID 账号对应为 vbird
   	若 NFS 服务器上的 /etc/passwd 里面 UID 501 的使用者名称为 vbird 时， 	则客户端的 dmtsai 可以存取服务器端的 vbird 这个使用者的档案喔！只因为两者具有相同的 	UID 而已。这就造成很大的问题了！因为没有人可以保证客户端的 UID 所对应的账号会与服务器端相同， 	那服务器所提供的数据不就可能会被错误的使用者乱改？

  

- NFS server 并没有 501 这个 UID
   	另一个极端的情况是，在服务器端并没有 501 这个 UID 的存在，则此时 dmtsai 的身份在该目录下会被压缩成匿名者， 	一般 NFS 的匿名者会以 UID 为 65534 为其使用者，早期的 Linux distributions 这个 65534 的账号名称通常是 	nobody ，我们的 CentOS 则取名为 nfsnobody 。但有时也会有特殊的情况，例如在服务器端分享 /tmp 的情况下， dmtsain 	的身份还是会保持 501 但建立的各项数据在服务器端来看，就会属于无拥有者的资料。

  

- 如果使用者身份是 root 时
   	有个比较特殊的使用者，那就是每个 Linux 主机都有的 UID 为 0 的 root 。 	想一想，如果客户端可以用 root 的身份去存取服务器端的文件系统时，那服务器端的数据哪有什么保护性？ 	所以在预设的情况下， root 的身份会被主动的压缩成为匿名者。

总之，客户端使用者能做的事情是与 UID 及其 GID 有关的，那当客户端与服务器端的 UID 及账号的对应不一致时， 	可能就会造成文件系统使用上的困扰，这个就是 NFS 文件系统在使用上面的一个很重要的地方！ 	而在了解使用者账号与 UID 及文件系统的关系之后，要实际在客户端以 NFS 取用服务器端的文件系统时， 	你还得需要具有：

- NFS 服务器有开放可写入的权限 (与 /etc/exports 设定有关)；
- 实际的档案权限具有可写入 (w) 的权限。

当你满足了 (1)使用者账号，亦即 UID 的相关身份； (2)NFS 服务器允许有写入的权限；  	(3)文件系统确实具有 w 的权限时，你才具有该档案的可写入权限喔！ 	尤其是身份 (UID) 确认的环节部分，最容易搞错啦！也因为如此， 	所以 NFS 通常需要与 [NIS (十四章)](http://linux.vbird.org/linux_server/0430nis.php)  	这一个可以确认客户端与服务器端身份一致的服务搭配使用，以避免身份的错乱啊！ ^_^

### 

## 配置

### NFS Server

#### /etc/exports

#### /usr/sbin/exportfs
维护 NFS 分享资源的指令，可以利用这个指令重新分享 /etc/exports 变更的目录资源、将 NFS Server 分享的目录卸除或重新分享等等.

#### /var/lib/nfs/*tab
​	在 NFS 服务器的登录文件都放置到 /var/lib/nfs/ 目录里面，在该目录下有两个比较重要的登录档， 	一个是 etab ，主要记录了 NFS 所分享出来的目录的完整权限设定值；另一个 xtab  	则记录曾经链接到此 NFS 服务器的相关客户端数据。

### NFS Client

客户端查询服务器分享资源的指令：/usr/sbin/showmount
exportfs 是用在 NFS Server 端，而 showmount  	则主要用在 Client 端。这个 showmount 可以用来察看 NFS 分享出来的目录资源喔！

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.2.3 /etc/exports  配置文件的语法与参数

在开始 NFS 服务器的设定之前，你必须要了解的是，NFS  	会直接使用到核心功能，所以你的核心必须要有支持 NFS 才行。万一如果你的核心版本小于 2.2  	版，或者重新自行编译过核心的话，那么就得要很注意啦！因为你可能会忘记选择 NFS 的核心支持啊！

还好，我们 CentOS 或者是其他版本的 Linux ，预设核心通常是支持 NFS 功能的，所以你只要确认你的核心版本是目前新的  	2.6.x 版，并且使用你的 distribution 所提供的核心，那应该就不会有问题啦！

| **Tips:** 		上面会提醒您这个问题的原因是，以前鸟哥都很喜欢自行编译一个特别的核心，但是某次编译核心时，却忘记加上了 NFS 	的核心功能，结果 NFS server 无论如何也搞不起来～最后才想到原来俺的核心是非正规的... | ![鸟哥的图示](http://cn.linux.vbird.org/linux_server/0330nfs_files/vbird_face.gif) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

至于 NFS 服务器的架设实在很简单，你只要编辑好主要配置文件 /etc/exports  	之后，先启动 rpcbind (若已经启动了，就不要重新启动)，然后再启动 nfs ，你的 NFS 就成功了！ 	不过这样的设定能否对客户端生效？那就得要考虑你权限方面的设定能力了。废话少说，我们就直接来看看那个 /etc/exports  	应该如何设定吧！某些 distributions 并不会主动提供 /etc/exports 档案，所以请你自行手动建立它吧。

```
[root@www ~]# vim /etc/exports /tmp         192.168.100.0/24(ro)   localhost(rw)   *.ev.ncku.edu.tw(ro,sync) [分享目录]   [第一部主机(权限)]     [可用主机名]    [可用通配符] 
```

你看看，这个配置文件有够简单吧！每一行最前面是要分享出来的目录，注意喔！是以目录为单位啊！ 	然后这个目录可以依照不同的权限分享给不同的主机，像鸟哥上面的例子说明是： 	要将 /tmp 分别分享给三个不同的主机或网域的意思。记得主机后面以小括号 () 设计权限参数， 	若权限参数不止一个时，则以逗号 (,) 分开。且主机名与小括号是连在一起的喔！在这个档案内也可以利用 # 来批注呢。

至于主机名的设定主要有几个方式：

- 可以使用完整的 IP 或者是网域，例如 192.168.100.10 或 192.168.100.0/24 ，或 	192.168.100.0/255.255.255.0 都可以接受！

  

- 也可以使用主机名，但这个主机名必须要在 /etc/hosts 内，或可使用 DNS 找到该名称才行啊！反正重点是可找到 IP  	就是了。如果是主机名的话，那么他可以支持通配符，例如 * 或 ? 均可接受。

至于权限方面 (就是小括号内的参数) 常见的参数则有：

| 参数值                     | 内容说明                                                     |
| -------------------------- | ------------------------------------------------------------ |
| rw ro                      | 该目录分享的权限是可擦写 (read-write) 或只读 (read-only)，但最终能不能读写，还是与文件系统的 rwx 及身份有关。 |
| sync async                 | sync 代表数据会同步写入到内存与硬盘中，async  则代表数据会先暂存于内存当中，而非直接写入硬盘！ |
| no_root_squash root_squash | 客户端使用 NFS 文件系统的账号若为  root 时，系统该如何判断这个账号的身份？预设的情况下，客户端 root 的身份会由 root_squash 的设定压缩成 nfsnobody， 如此对服务器的系统会较有保障。但如果你想要开放客户端使用 root 身份来操作服务器的文件系统，那么这里就得要开  no_root_squash 才行！ |
| all_squash                 | 不论登入 NFS 的使用者身份为何， 他的身份都会被压缩成为匿名用户，通常也就是  nobody(nfsnobody) 啦！ |
| anonuid anongid            | anon 意指 anonymous (匿名者) 前面关于 *_squash 提到的匿名用户的 UID  设定值，通常为 nobody(nfsnobody)，但是你可以自行设定这个 UID 的值！当然，这个 UID 必需要存在于你的 /etc/passwd 当中！ anonuid 指的是 UID 而 anongid 则是群组的 GID 啰。 |

这是几个比较常见的权限参数，如果你有兴趣玩其他的参数时，请自行 man exports 可以发现很多有趣的数据。 	接下来我们利用上述的几个参数来实际思考一下几个有趣的小习题：

例题一：让 root 保有 root 的权限 我想将 /tmp 分享出去给大家使用，由于这个目录本来就是大家都可以读写的，因此想让所有的人都可以存取。此外，我要让 root  写入的档案还是具有 root 的权限，那如何设计配置文件？ 答： `[root@www ~]# vim /etc/exports # 任何人都可以用我的 /tmp ，用通配符来处理主机名，重点在 no_root_squash /tmp  *(rw,no_root_squash) ` 主机名可以使用通配符，上头表示无论来自哪里都可以使用我的 /tmp 这个目录。 再次提醒，『 *(rw,no_root_squash) 』这一串设定值中间是没有空格符的喔！而  /tmp 与 *(rw,no_root_squash) 则是有空格符来隔开的！特别注意到那个  no_root_squash 的功能！在这个例子中，如果你是客户端，而且你是以 root 的身份登入你的 Linux  主机，那么当你 mount 上我这部主机的 /tmp 之后，你在该 mount 的目录当中，将具有『root 的权限！』



例题二：同一目录针对不同范围开放不同权限 我要将一个公共的目录 /home/public 公开出去，但是只有限定我的局域网络 192.168.100.0/24 这个网域且加入 vbirdgroup (第一章的例题建立的群组) 的用户才能够读写，其他来源则只能读取。 答： `[root@www ~]# mkdir /home/public [root@www ~]# setfacl -m g:vbirdgroup:rwx /home/public [root@www ~]# vim /etc/exports /tmp          *(rw,no_root_squash) /home/public  192.168.100.0/24(rw)    *(ro) # 继续累加在后面，注意，我有将主机与网域分为两段 (用空白隔开) 喔！ ` 上面的例子说的是，当我的 IP 是在 192.168.100.0/24 这个网段的时候，那么当我在 Client 端挂载了  Server 端的 /home/public 后，针对这个被我挂载的目录我就具有可以读写的权限～ 至于如果我不是在这个网段之内，那么这个目录的数据我就仅能读取而已，亦即为只读的属性啦！   需要注意的是，通配符仅能用在主机名的分辨上面，IP 或网段就只能用 192.168.100.0/24 的状况， 不可以使用 192.168.100.* 喔！



例题三：仅给某个单一主机使用的目录设定 我要将一个私人的目录 /home/test 开放给 192.168.100.10 这个 Client 端的机器来使用时，该如何设定？ 假设使用者的身份是 dmtsai 才具有完整的权限时。 答： `[root@www ~]# mkdir /home/test [root@www ~]# setfacl -m u:dmtsai:rwx /home/test [root@www ~]# vim /etc/exports /tmp          *(rw,no_root_squash) /home/public  192.168.100.0/24(rw)    *(ro) /home/test    192.168.100.10(rw) # 只要设定 IP 正确即可！ ` 这样就设定完成了！而且，只有 192.168.100.10 这部机器才能对 /home/test 这个目录进行存取喔！



例题四：开放匿名登录的情况 我要让 *.centos.vbird 网域的主机，登入我的 NFS 主机时，可以存取 /home/linux ，但是他们存数据的时候，我希望他们的  UID 与 GID 都变成 45 这个身份的使用者，假设我 NFS 服务器上的 UID 45 与 GID 45 的用户/组名为 nfsanon。 答： `[root@www ~]# groupadd -g 45 nfsanon [root@www ~]# useradd -u 45 -g nfsanon nfsanon [root@www ~]# mkdir /home/linux [root@www ~]# setfacl -m u:nfsanon:rwx /home/linux [root@www ~]# vim /etc/exports /tmp          *(rw,no_root_squash) /home/public  192.168.100.0/24(rw)    *(ro) /home/test    192.168.100.10(rw) /home/linux   *.centos.vbird(rw,all_squash,anonuid=45,anongid=45) # 如果要开放匿名，那么重点是 all_squash，并且要配合 anonuid 喔！ ` 特别注意到那个 all_squash 与 anonuid, anongid 的功能！如此一来，当 clientlinux.centos.vbird 登入这部 NFS 主机，并且在 /home/linux  写入档案时，该档案的所有人与所有群组，就会变成 /etc/passwd 里面对应的 UID 为 45 的那个身份的使用者了！



上面四个案例的权限如果依照[13.1.4 存取设定权限](http://cn.linux.vbird.org/linux_server/0330nfs.php#What_NFS_perm)来思考的话， 	那么权限会是什么情况呢？让我们来检查一下：



- ------

  客户端与服务器端具有相同的 UID 与账号：

假设我在 192.168.100.10 登入这部 NFS (IP 假设为 192.168.100.254) 服务器，并且我在  	192.168.100.10 的账号为 dmtsai 这个身份，同时，在这部 NFS 上面也有 dmtsai 这个账号， 	并具有相同的 UID ，果真如此的话，那么：

1. 由于 192.168.100.254 这部 NFS 服务器的 /tmp 权限为 -rwxrwxrwt ，所以我 (dmtsai 在 192.168.100.10 上面)  		在 /tmp 底下具有存取的权限，并且写入的档案所有人为 dmtsai ；

2. 在 /home/public 当中，由于我有读写的权限，所以如果在 /home/public 这个目录的权限对于 dmtsai  		有开放写入的话，那么我就可以读写，并且我写入的档案所有人是 dmtsai 。但是万一  		/home/public 对于 dmtsai 这个使用者并没有开放可以写入的权限时， 		那么我还是没有办法写入档案喔！这点请特别留意！

3. 在 /home/test 当中，我的权限与 /home/public 相同的状态！还需要 NFS 服务器的 /home/test 对于  		dmtsai 有开放权限；

4. 在 /home/linux 当中就比较麻烦！因为不论你是何种 user ，你的身份一定会被变成 UID=45  		这个账号！所以，这个目录就必需要针对 UID = 45 的那个账号名称，修改他的权限才行！

   

- ------

  客户端与服务器端的账号并未相同时：

假如我在 192.168.100.10 的身份为 vbird (uid 为 600)，但是 192.168.100.254 这部 NFS 主机却没有 uid=600 	的账号时，情况会变成怎样呢？

1. 我在 /tmp 底下还是可以写入，只是该档案的权限会保持为 UID=600 ，因此服务器端看起来就会怪怪的， 		因为找不到 UID=600 这个账号的显示，故档案拥有者会填上 600 呦！

2. 我在 /home/public 里面是否可以写入，还需要视 /home/public 的权限而定，不过，由于没有加上 all_squash 的参数， 		因此在该目录下会保留客户端的使用者 UID，同上一点所示。

3. /home/test 的观点与 /home/public 相同！

4. /home/linux 底下，我的身份就被变成 UID = 45 那个使用者就是了！

   

- ------

  当客户端的身份为 root 时：

假如我在 192.168.100.10 的身份为 root 呢？ root 这个账号每个系统都会有呀！权限变成怎样呢？

1. 我在 /tmp 里面可以写入，并且由于 no_root_squash 的参数，改变了预设的  		root_squash 设定值，所以在 /tmp 写入的档案所有人为 root 喔！

2. 我在 /home/public 底下的身份还是被压缩成为 nobody 了！因为默认属性里面都具有  		root_squash 呢！所以，如果 /home/public 有针对 nobody  		开放写入权限时，那么我就可以写入，但是档案所有人变成 nobody 就是了！

3. /home/test 与 /home/public 相同；

4. /home/linux 的情况中，我 root 的身份也被压缩成为 UID = 45 的那个使用者了！

   

------

这样的权限讲解之后，你可以了解了吗？这里是最重要的地方，如果这一关通过了，底下的咚咚就没有问题啦！ ^_^！ 	在你将本文读完后，最好还是回到[13.1.4 NFS 的档案访问权限](http://cn.linux.vbird.org/linux_server/0330nfs.php#What_NFS_perm)好好的瞧一瞧， 	才能解决 NFS 的问题喔！

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.2.4 启动 NFS

配置文件搞定后，当然要开始来启动才行啊！而前面我们也提到过，NFS 的启动还需要 rpcbind 的协助才行啊！ 	所以赶紧来启动吧！

```
[root@www ~]# /etc/init.d/rpcbind start # 如果 rpcbind 本来就已经在执行了，那就不需要启动啊！ [root@www ~]# /etc/init.d/nfs start # 有时候某些 distributions 可能会出现如下的警告讯息： exportfs: /etc/exports [3]: No 'sync' or 'async' option specified  for export "192.168.100.10:/home/test".  Assuming default behaviour ('sync'). # 上面的警告讯息仅是在告知因为我们没有指定 sync 或 async 的参数， # 则 NFS 将默认会使用 sync 的信息而已。你可以不理他，也可以加入 /etc/exports。 [root@www ~]# /etc/init.d/nfslock start [root@www ~]# chkconfig rpcbind on [root@www ~]# chkconfig nfs on [root@www ~]# chkconfig nfslock on 
```

那个 rpcbind 根本就不需要设定！只要直接启动它就可以啦！启动之后，会出现一个  	port 111 的 sunrpc 的服务，那就是 rpcbind 啦！至于 nfs 则会启动至少两个以上的 daemon  	出现！然后就开始在监听 Client 端的需求啦！你必须要很注意屏幕上面的输出信息， 	因为如果配置文件写错的话，屏幕上会显示出错误的地方喔！

此外，如果你想要增加一些 NFS 服务器的数据一致性功能时，可能需要用到 rpc.lockd 及 rpc.statd 等 RPC 服务， 	那么或许你可以增加一个服务，那就是 nfslock 啰！启动之后，请赶快到 /var/log/messages 里面看看有没有被正确的启动呢？

```
[root@www ~]# tail /var/log/messages Jul 27 17:10:39 www kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de). Jul 27 17:10:54 www kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state  recovery directory Jul 27 17:10:54 www kernel: NFSD: starting 90-second grace period Jul 27 17:11:32 www rpc.statd[3689]: Version 1.2.2 starting 
```

在确认启动没有问题之后，接下来我们来瞧一瞧那么 NFS 到底开了哪些埠口？

```
[root@www ~]# netstat -tulnp| grep -E '(rpc|nfs)' Active Internet connections (only servers) Proto Recv-Q Send-Q Local Address  Foreign Address  State   PID/Program name tcp        0      0 0.0.0.0:875    0.0.0.0:*        LISTEN  3631/rpc.rquotad tcp        0      0 0.0.0.0:111    0.0.0.0:*        LISTEN  3601/rpcbind tcp        0      0 0.0.0.0:48470  0.0.0.0:*        LISTEN  3647/rpc.mountd tcp        0      0 0.0.0.0:59967  0.0.0.0:*        LISTEN  3689/rpc.statd tcp        0      0 0.0.0.0:2049   0.0.0.0:*        LISTEN  - udp        0      0 0.0.0.0:875    0.0.0.0:*                3631/rpc.rquotad udp        0      0 0.0.0.0:111    0.0.0.0:*                3601/rpcbind udp        0      0 0.0.0.0:897    0.0.0.0:*                3689/rpc.statd udp        0      0 0.0.0.0:46611  0.0.0.0:*                3647/rpc.mountd udp        0      0 0.0.0.0:808    0.0.0.0:*                3601/rpcbind udp        0      0 0.0.0.0:46011  0.0.0.0:*                3689/rpc.statd 
```

注意看到上面喔！总共产生了好多的 port 喔！真是可怕！不过主要的埠口是：

- rpcbind 启动的 port 在 111 ，同时启动在 UDP 与 TCP；
- nfs 本身的服务启动在 port 2049 上头！
- 其他 rpc.* 服务启动的 port 则是随机产生的，因此需向 port 111 注册。



好了，那我怎么知道每个 RPC 服务的注册状况？没关系，你可以使用 rpcinfo 来观察的。

```
[root@www ~]# rpcinfo -p [IP|hostname] [root@www ~]# rpcinfo -t|-u  IP|hostname 程序名称 选项与参数： -p ：针对某 IP (未写则预设为本机) 显示出所有的 port 与 porgram 的信息； -t ：针对某主机的某支程序检查其 TCP 封包所在的软件版本； -u ：针对某主机的某支程序检查其 UDP 封包所在的软件版本； # 1. 显示出目前这部主机的 RPC 状态 [root@www ~]# rpcinfo -p localhost   program vers proto   port  service    100000    4   tcp    111  portmapper    100000    3   tcp    111  portmapper    100000    2   tcp    111  portmapper    100000    4   udp    111  portmapper    100000    3   udp    111  portmapper    100000    2   udp    111  portmapper    100011    1   udp    875  rquotad    100011    2   udp    875  rquotad    100011    1   tcp    875  rquotad    100011    2   tcp    875  rquotad    100003    2   tcp   2049  nfs ....(底下省略).... # 程序代号 NFS版本 封包类型 埠口  服务名称 # 2. 针对 nfs 这个程序检查其相关的软件版本信息 (仅察看 TCP 封包) [root@www ~]# rpcinfo -t localhost nfs program 100003 version 2 ready and waiting program 100003 version 3 ready and waiting program 100003 version 4 ready and waiting # 可发现提供 nfs 的版本共有三种，分别是 2, 3, 4 版呦！ 
```

仔细瞧瞧，上面出现的信息当中除了程序名称与埠口的对应可以与 netstat -tlunp 输出的结果作比对之外，还需要注意到  	NFS 的版本支持！新的 NFS 版本传输速度较快，由上表看起来，我们的 NFS 至少支持到第 4 版，应该还算合理啦！ ^_^！ 	如果你的 rpcinfo 无法输出，那就表示注册的数据有问题啦！可能需要重新启动 	rpcbind 与 nfs 喔！

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.2.5 NFS 的联机观察

在你的 NFS 服务器设定妥当之后，我们可以在 server 端先自我测试一下是否可以联机喔！就是利用 showmount  	这个指令来查阅！



```
[root@www ~]# showmount [-ae] [hostname|IP] 选项与参数： -a ：显示目前主机与客户端的 NFS 联机分享的状态； -e ：显示某部主机的 /etc/exports 所分享的目录数据。 # 1. 请显示出刚刚我们所设定好的相关 exports 分享目录信息 [root@www ~]# showmount -e localhost Export list for localhost: /tmp         * /home/linux  *.centos.vbird /home/test   192.168.100.10 /home/public (everyone) 
```

很简单吧！所以，当你要扫瞄某一部主机他提供的 NFS 分享的目录时，就使用 showmount -e  	IP (或hostname) 即可！非常的方便吧！这也是 NFS client 端最常用的指令喔！ 	另外， NFS 关于目录权限设定的数据非常之多！在 /etc/exports  只是比较特别的权限参数而已，还有很多预设参数呢！ 	这些预设参数在哪？我们可以检查一下 /var/lib/nfs/etab 就知道了！

```
[root@www ~]# tail /var/lib/nfs/etab /home/public    192.168.100.0/24(rw,sync,wdelay,hide,nocrossmnt,secure,root_squash, no_all_squash,no_subtree_check,secure_locks,acl,anonuid=65534,anongid=65534) # 上面是同一行，可以看出除了 rw, sync, root_squash 等等， # 其实还有 anonuid 及 anongid 等等的设定！ 
```

上面仅仅是一个小范例，透过分析 anonuid=65534 对比 /etc/passwd 后，会发现 CentOS 出现的是  	nfsnobody 啦！这个账号在不同的版本都可能会不一样的！另外，如果有其他客户端挂载了你的  	NFS 文件系统时，那么该客户端与文件系统信息就会被记录到 /var/lib/nfs/xtab 里头去的！



另外，如果你想要重新处理 /etc/exports 档案，当重新设定完 /etc/exports 后需不需要重新启动 nfs ？ 	不需要啦！如果重新启动 nfs 的话，要得再向 RPC 注册！很麻烦～这个时候我们可以透过 exportfs 这个指令来帮忙喔！

```
[root@www ~]# exportfs [-aruv] 选项与参数： -a ：全部挂载(或卸除) /etc/exports 档案内的设定 -r ：重新挂载 /etc/exports 里面的设定，此外，亦同步更新 /etc/exports     及 /var/lib/nfs/xtab 的内容！ -u ：卸除某一目录 -v ：在 export 的时候，将分享的目录显示到屏幕上！ # 1. 重新挂载一次 /etc/exports 的设定 [root@www ~]# exportfs -arv exporting 192.168.100.10:/home/test exporting 192.168.100.0/24:/home/public exporting *.centos.vbird:/home/linux exporting *:/home/public exporting *:/tmp # 2. 将已经分享的 NFS 目录资源，通通都卸除 [root@www ~]# exportfs -auv # 这时如果你再使用 showmount -e localhost 就会看不到任何资源了！ 
```

要熟悉一下这个指令的用法喔！这样一来，就可以直接重新 exportfs 我们的记录在 /etc/exports  	的目录数据啰！但是要特别留意，如果你仅有处理配置文件，但并没有相对应的目录 (/home/public 等目录) 可以提供使用啊！ 	那可能会出现一些警告讯息喔！所以记得要建立分享的目录才对！

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.2.6 NFS 的安全性

在 NFS 的安全性上面，有些地方是你必须要知道的喔！底下我们分别来谈一谈：





- ------

  防火墙的设定问题与解决方案：

一般来说， NFS 的服务仅会对内部网域开放，不会对因特网开放的。然而，如果你有特殊需求的话， 	那么也可能会跨不同网域就是了。但是，NFS 的防火墙特别难搞，为什么呢？因为除了固定的 port 111, 2049 之外， 	还有很多不固定的埠口是由 rpc.mountd, rpc.rquotad 等服务所开启的，所以，你的 iptables 就很难设定规则！ 	那怎办？难道整个防火墙机制都要取消才可以？

为了解决这个问题， CentOS 6.x 有提供一个固定特定 NFS 服务的埠口配置文件，那就是 /etc/sysconfig/nfs 啦！ 	你在这个档案里面就能够指定特定的埠口，这样每次启动 nfs 时，相关服务启动的埠口就会固定，如此一来， 	我们就能够设定正确的防火墙啰！这个配置文件内容很多，绝大部分的数据你都不要去更改，只要改跟 PORT 这个关键词有关的数据即可。 	那么需要更改的 rpc 服务有哪些呢？主要有 mountd, rquotad, nlockmgr 这三个，所以你应该要这样改：

```
[root@www ~]# vim /etc/sysconfig/nfs RQUOTAD_PORT=1001   <==约在 13 行左右 LOCKD_TCPPORT=30001 <==约在 21 行左右 LOCKD_UDPPORT=30001 <==约在 23 行左右 MOUNTD_PORT=1002    <==约在 41 行左右 # 记得设定值最左边的批注服务要拿掉之外，埠口的值你也可以自行决定。 [root@www ~]# /etc/init.d/nfs restart [root@www ~]# rpcinfo -p | grep -E '(rquota|mount|nlock)'    100011    2   udp   1001  rquotad    100011    2   tcp   1001  rquotad    100021    4   udp  30001  nlockmgr    100021    4   tcp  30001  nlockmgr    100005    3   udp   1002  mountd    100005    3   tcp   1002  mountd # 上述的输出数据已经被鸟哥汇整过了，没用到的埠口先挪掉了啦！ 
```

很可怕吧！如果想要开放 NFS 给别的网域的朋友使用，又不想要让对方拥有其他服务的登入功能， 	那你的防火墙就得要开放上述的十个埠口啦！有够麻烦的～假设你想要开放 120.114.140.0/24 这个网域的人能够使用你这部服务器的 	NFS 的资源，且假设你已经使用[第九章提供的防火墙脚本](http://linux.vbird.org/linux_server/0250simple_firewall.php)， 	那么你还得要这样做才能够针对该网域放行喔：

```
[root@www ~]# vim /usr/local/virus/iptables/iptables.allow iptables -A INPUT -i $EXTIF -p tcp -s 120.114.140.0/24 -m multiport \         --dport 111,2049,1001,1002,30001 -j ACCEPT iptables -A INPUT -i $EXTIF -p udp -s 120.114.140.0/24 -m multiport \         --dport 111,2049,1001,1002,30001 -j ACCEPT [root@www ~]# /usr/local/virus/iptables/iptables.rule # 总是要重新执行这样防火墙规则才会顺利的生效啊！别忘记！别忘记！ 
```



- ------

  使用 /etc/exports 设定更安全的权限：

这就牵涉到你的逻辑思考了！怎么设定都没有关系，但是在『便利』与『安全』之间，要找到你的平衡点吶！善用  	root_squash 及 all_squash 等功能，再利用 anonuid  	等等的设定来规范登入你主机的用户身份！应该还是有办法提供一个较为安全的 NFS 服务器的！

另外，当然啦，你的 NFS 服务器的文件系统之权限设定也需要很留意！ 	不要随便设定成为 -rwxrwxrwx ，这样会造成你的系统『很大的困扰』的啊！



- ------

  更安全的 partition 规划：

如果你的工作环境中，具有多部的 Linux 主机，并且预计彼此分享出目录时，那么在安装 Linux  	的时候，最好就可以规划出一块 partition 作为预留之用。因为『  	NFS 可以针对目录来分享』，因此，你可以将预留的  	partition 挂载在任何一个挂载点，再将该挂载点 (就是目录啦！)由 /etc/exports  	的设定中分享出去，那么整个工作环境中的其他 Linux 主机就可以使用该 NFS 服务器的那块预留的  	partition 了！所以，在主机的规划上面，主要需要留意的只有 partition 而已。此外，由于分享的  	partition 可能较容易被入侵，最好可以针对该 partition 设定比较严格的参数在 /etc/fstab 当中喔！

此外，如果你的分割做的不够好，举例来说，很多人都喜欢使用懒人分割法，亦即整个系统中只有一个根目录的 partition  	而已。这样做会有什么问题呢？假设你分享的是 /home 这个给一般用户的目录好了，有些用户觉得这个 NFS 的磁盘太好用了， 	结果使用者就将他的一大堆暂存数据通通塞进这个 NFS 磁盘中。想一想，如果整个根目录就因为这个 /home 被塞爆了， 	那么你的系统将会造成无法读写的困扰。因此，一个良好的分割规划，或者是利用磁盘配额来限制还是很重要的工作。 	





- ------

  NFS 服务器关机前的注意事项：

需要注意的是，由于 NFS 使用的这个 RPC 服务，当客户端连上服务器时，那么你的服务器想要关机， 	那可就会成为『不可能的任务』！如果你的服务器上面还有客户端在联机，那么你要关机， 	可能得要等到数个钟头才能够正常的关机成功！嗄！真的假的！不相信吗？不然你自个儿试试看！^_^！

所以啰，建议你的 NFS Server 想要关机之前，能先『关掉 rpcbind 与 nfs 』这两个东西！ 	如果无法正确的将这两个 daemons 关掉，那么先以 netstat -utlp 找出 PID ，然后以 kill  	将他关掉先！这样才有办法正常的关机成功喔！这个请特别特别的注意呢！

当然啦，你也可以利用 [showmount](http://cn.linux.vbird.org/linux_server/0330nfs.php#showmount) -a localhost 来查出来那个客户端还在联机？ 	或者是查阅 /var/lib/nfs/rmtab 或 xtab 等档案来检查亦可。找到这些客户端后， 	可以直接 call 他们啊！让他们能够帮帮忙先！ ^_^

事实上，客户端以 NFS 联机到服务器端时，如果他们可以下达一些比较不那么『硬』的挂载参数时， 	就能够减少这方面的问题喔！相关的安全性可以参考下一小节的 	[客户端可处理的挂载参数与开机挂载](http://cn.linux.vbird.org/linux_server/0330nfs.php#nfsclient_mount)。

------

![大标题的图示](http://cn.linux.vbird.org/image/logo.png)13.3 NFS 客户端的设定

既然 NFS 服务器最主要的工作就是分享文件系统给网络上其他的客户端，所以客户端当然得要挂载这个玩意儿啰！ 此外，服务器端可以加设防火墙来保护自己的文件系统，那么客户端挂载该文件系统后，难道不需要保护自己？ 呵呵！所以底下我们要来谈一谈几个 NFS 客户端的课题。



------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.3.1 手动挂载 NFS  服务器分享的资源

你要如何挂载 NFS 服务器所提供的文件系统呢？基本上，可以这样做：

1. 确认本地端已经启动了 rpcbind 服务！
2. 扫瞄 NFS 服务器分享的目录有哪些，并了解我们是否可以使用 ([showmount](http://cn.linux.vbird.org/linux_server/0330nfs.php#showmount))；
3. 在本地端建立预计要挂载的挂载点目录 (mkdir)；
4. 利用 mount 将远程主机直接挂载到相关目录。

好，现在假设客户端在 192.168.100.10 这部机器上，而服务器是 192.168.100.254 ， 	那么赶紧来检查一下我们是否已经有 rpcbind 的启动，另外远程主机有什么可用的目录呢！

```
# 1. 启动必备的服务：若没有启动才启动，有启动则保持原样不动。 [root@clientlinux ~]# /etc/init.d/rpcbind start [root@clientlinux ~]# /etc/init.d/nfslock start # 一般来说，系统默认会启动 rpcbind ，不过鸟哥之前关闭过，所以要启动。 # 另外，如果服务器端有启动 nfslock 的话，客户端也要启动才能生效！ # 2. 查询服务器提供哪些资源给我们使用呢？ [root@clientlinux ~]# showmount -e 192.168.100.254 Export list for 192.168.100.254: /tmp         * /home/linux  *.centos.vbird /home/test   192.168.100.10 /home/public (everyone)   <==这是等一下我们要挂载的目录 
```

接下来我想要将远程主机的 /home/public 挂载到本地端主机的 /home/nfs/public ， 	所以我就得要在本地端主机先建立起这个挂载点目录才行啊！然后就可以用 mount 	这个指令直接挂载 NFS 的文件系统啰！

```
# 3. 建立挂载点，并且实际挂载看看啰！ [root@clientlinux ~]# mkdir -p /home/nfs/public [root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/public \ > /home/nfs/public # 注意一下挂载的语法！『 -t nfs 』指定文件系统类型， # IP:/dir 则是指定某一部主机的某个提供的目录！另外，如果出现如下错误： mount: 192.168.100.254:/home/public failed, reason given by server: No such file  or directory # 这代表你在 Server 上面并没有建立 /home/public 啦！自己在服务器端建立他吧！ # 4. 总是得要看看挂载之后的情况如何，可以使用 df 或 mount 啦！ [root@clientlinux ~]# df 文件系统               1K-区段      已用     可用 已用% 挂载点 ....(中间省略).... 192.168.100.254:/home/public                       7104640    143104   6607104   3% /home/nfs/public 
```

先注意一下挂载 NFS 档案的格式范例喔！呵呵！这样就可以将数据挂载进来啦！请注意喔！ 	以后，只要你进入你的目录 /home/nfs/public 就等于到了 192.168.100.254 那部远程主机的  	/home/public 那个目录中啰！很不错吧！至于你在该目录下有什么权限？ 	那就请你回去前一小节查一查权限的思考吧！ ^_^ ！那么如何将挂载的 NFS 目录卸除呢？就使用 umount 啊！

```
[root@clientlinux ~]# umount /home/nfs/public 
```

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.3.2 客户端可处理的挂载参数与开机挂载

瞧！客户端的挂载工作很简单吧！不过不晓得你有没有想过，如果你刚刚挂载到本机 /home/nfs/public  	的文件系统当中，含有一支 script ，且这支 script 的内容为『 rm -rf / 』且该档案权限为 555 ， 	夭寿～如果你因为好奇给他执行下去，可有的你受的了～因为整个系统都会被杀光光！真可怜！

所以说，除了 NFS 服务器需要保护之外，我们取用人家的 NFS 文件系统也需要自我保护才行啊！ 	那要如何自我保护啊？可以透过 mount 的指令参数喔！包括底下这些主要的参数可以尝试加入：

| 参数        | 参数代表意义                                                 | 系统默认值 |
| ----------- | ------------------------------------------------------------ | ---------- |
| suid nosuid | 晓得啥是 SUID 吧？如果挂载的 partition 上面有任何 SUID 的 binary 程序时， 你只要使用 nosuid 就能够取消 SUID 的功能了！嗄？不知道什么是 SUID ？那就不要学人家架站嘛！@_@！ 赶紧回去基础学习篇第三版复习一下[第十七章、程序与资源管理](http://linux.vbird.org/linux_basic/0440processcontrol.php#suid_sgid)啦！ | suid       |
| rw ro       | 你可以指定该文件系统是只读 (ro) 或可擦写喔！服务器可以提供给你可擦写， 但是客户端可以仅允许只读的参数设定值！ | rw         |
| dev nodev   | 是否可以保留装置档案的特殊功能？一般来说只有 /dev 这个目录才会有特殊的装置，因此你可以选择 nodev 喔！ | dev        |
| exec noexec | 是否具有执行 binary file 的权限？ 如果你想要挂载的仅是数据区 (例如 /home)，那么可以选择 noexec  啊！ | exec       |
| user nouser | 是否允许使用者进行档案的挂载与卸除功能？ 如果要保护文件系统，最好不要提供使用者进行挂载与卸除吧！ | nouser     |
| auto noauto | 这个 auto 指的是『mount -a』时，会不会被挂载的项目。 如果你不需要这个 partition 随时被挂载，可以设定为 noauto。 | auto       |



一般来说，如果你的 NFS 服务器所提供的只是类似 /home 底下的个人资料， 	应该不需要可执行、SUID 与装置档案，因此当你在挂载的时候，可以这样下达指令喔：

```
[root@clientlinux ~]# umount /home/nfs/public [root@clientlinux ~]# mount -t nfs -o nosuid,noexec,nodev,rw \ > 192.168.100.254:/home/public /home/nfs/public [root@clientlinux ~]# mount | grep addr 192.168.100.254:/home/public on /home/nfs/public type nfs (rw,noexec,nosuid, nodev,vers=4,addr=192.168.100.254,clientaddr=192.168.100.10) 
```

这样一来你所挂载的这个文件系统就只能作为资料存取之用，相对来说，对于客户端是比较安全一些的。 	所以说，这个 nosuid, noexec, nodev 等等的参数可得记得啊！





- ------

  关于 NFS 特殊的挂载参数

除了上述的 mount 参数之外，其实针对 NFS 服务器，咱们的 Linux 还提供不少有用的额外参数喔！这些特殊参数还非常有用呢！ 	为什么呢？举例来说，由于文件系统对 Linux 是非常重要的东西，因为我们进行任何动作时，只要有用到文件系统， 	那么整个目录树系统就会主动的去查询全部的挂载点。如果你的 NFS 服务器与客户端之间的联机因为网络问题， 	或者是服务器端先关机了，却没有通知客户端，那么客户端只要动到文件系统的指令 (例如 df, ls, cp 等等)  	，整个系统就会慢到爆！因为你必须要等到文件系统搜寻等待逾时后，系统才会饶了你！(鸟哥等过 df 指令 30 分钟过...)

为了避免这些困扰，我们还有一些额外的 NFS 挂载参数可用！例如：

| 参数        | 参数功能                                                     | 预设参数              |
| ----------- | ------------------------------------------------------------ | --------------------- |
| fg bg       | 当执行挂载时，该挂载的行为会在前景 (fg) 还是在背景 (bg) 执行？ 若在前景执行时，则 mount 会持续尝试挂载，直到成功或 time out 为止，若为背景执行， 则 mount 会在背景持续多次进行 mount ，而不会影响到前景的程序操作。 如果你的网络联机有点不稳定，或是服务器常常需要开关机，那建议使用 bg 比较妥当。 | fg                    |
| soft hard   | 如果是 hard 的情况，则当两者之间有任何一部主机脱机，则 RPC  会持续的呼叫，直到对方恢复联机为止。如果是 soft 的话，那 RPC 会在 time out 后『重复』呼叫，而非『持续』呼叫， 因此系统的延迟会比较不这么明显。同上，如果你的服务器可能开开关关，建议用 soft 喔！ | hard                  |
| intr        | 当你使用上头提到的 hard 方式挂载时，若加上 intr 这个参数， 则当 RPC 持续呼叫中，该次的呼叫是可以被中断的 (interrupted)。 | 没有                  |
| rsize wsize | 读出(rsize)与写入(wsize)的区块大小 (block size)。 这个设定值可以影响客户端与服务器端传输数据的缓冲记忆容量。一般来说， 如果在局域网络内 (LAN) ，并且客户端与服务器端都具有足够的内存，那这个值可以设定大一点， 比如说 32768 (bytes) 等，提升缓冲记忆区块将可提升 NFS 文件系统的传输能力！ 但要注意设定的值也不要太大，最好是达到网络能够传输的最大值为限。 | rsize=1024 wsize=1024 |



更多的参数可以参考 man nfs 的输出数据喔！ 	通常如果你的 NFS 是用在高速运作的环境当中的话，那么可以建议加上这些参数的说：

```
[root@clientlinux ~]# umount /home/nfs/public [root@clientlinux ~]# mount -t nfs -o nosuid,noexec,nodev,rw \ > -o bg,soft,rsize=32768,wsize=32768 \ > 192.168.100.254:/home/public /home/nfs/public 
```

则当你的 192.168.100.254 这部服务器因为某些因素而脱机时，你的 NFS 可以继续在背景当中重复的呼叫！ 	直到 NFS 服务器再度上线为止。这对于系统的持续操作还是有帮助的啦！ 	当然啦，那个 rsize 与 wsize 的大小则需要依据你的实际网络环境而定喔！

| **Tips:** 		在鸟哥的实际案例中，某些大型的模式运算并不允许 soft 这个参数喔！举例来说，鸟哥惯用的 CMAQ 空气质量模式， 	这个模式的丛集架构分享文件系统中，就不允许使用 soft 参数！这点需要特别留意喔！ | ![鸟哥的图示](http://cn.linux.vbird.org/linux_server/0330nfs_files/vbird_face.gif) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

- ------

  将 NFS 开机即挂载

我们知道开机就挂载的挂载点与相关参数是写入 /etc/fstab 中的，那 NFS 能不能写入 /etc/fstab 当中呢？非常可惜的是， 	不可以呢！为啥呢？分析一下开机的流程，我们可以发现网络的启动是在本机挂载之后，因此当你利用 /etc/fstab  尝试挂载 	NFS 时，系统由于尚未启动网络，所以肯定是无法挂载成功的啦！那怎办？简单！就写入 /etc/rc.d/rc.local 即可！

```
[root@clientlinux ~]# vim /etc/rc.d/rc.local mount -t nfs -o nosuid,noexec,nodev,rw,bg,soft,rsize=32768,wsize=32768 \ 192.168.100.254:/home/public /home/nfs/public 
```

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.3.3 无法挂载的原因分析

如果客户端就是无法挂载服务器端所分享的目录时，到底是发生什么问题？你可以这样分析看看：



- ------

  客户端的主机名或 IP 网段不被允许使用：

以上面的例子来说明，我的 /home/test 只能提供 192.168.100.0/24 这个网域，所以如果我在 192.168.100.254 	这部服务器中，以 localhost (127.0.0.1) 来挂载时，就会无法挂载上，这个权限概念没问题吧！不然你可以在服务器上试试看：

```
[root@www ~]# mount -t nfs localhost:/home/test /mnt mount.nfs: access denied by server while mounting localhost:/home/test 
```

看到 access denied 了吧？没错啦～权限不符啦！如果确定你的 IP 没有错误，那么请通知服务器端，请管理员将你的 IP 加入  	/etc/exports 这个档案中。



- ------

  服务器或客户端某些服务未启动：

这个最容易被忘记了！就是忘记了启动 rpcbind 这个服务啦！如果你在客户端发现 mount 的讯息是这样：

```
[root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/test /mnt mount: mount to NFS server '192.168.100.254' failed: System Error: Connection refused. # 如果你使用 ping 却发现网络与服务器都是好的，那么这个问题就是 rpcbind 没有开啦！ [root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/test /home/nfs mount: mount to NFS server '192.168.100.254' failed: RPC Error: Program not registered. # 注意看最后面的数据，确实有连上 RPC ，但是服务器的 RPC 告知我们，该程序无注册 
```

要嘛就是 rpcbind 忘记开 (第一个错误)，要嘛就是服务器端的 nfs 忘记开。最麻烦的是， 	重新启动了 rpcbind 但是却忘记重新启动其他服务 (上述第二个错误)！解决的方法就是去重新启动 rpcbind 	管理的其他所有服务就是了！



- ------

  被防火墙档掉了：

由于 NFS 几乎不对外开放，而内部网域又通常是全部的资源都放行，因此过去玩 NFS 的朋友 (包括鸟哥本人啦！) 	都没有注意过 NFS 的防火墙问题。最近这几年鸟哥在管理计算机教室时，有掌管一部计算机教室主控防火墙， 	为了担心太厉害的学生给鸟哥乱搞，因此该 Linux 防火墙预设是仅放行部分资源而已。但由于计算机教室的区网内需要用到 	Linux 的 NFS 资源，结果呢？竟然没办法放行啊！原来就是 iptables 没有放行 NFS 所使用到的埠口～

所以，当你一直无法顺利的连接 NFS 服务器，请先到服务器端，将客户端的 IP 完全放行，若确定这样就连的上， 	那代表就是防火墙有问题啦！怎么解决呢？上一小节介绍过了，参考将 NFS 服务器埠口固定的方式吧！

------

![小标题的图示](http://cn.linux.vbird.org/image/logo.png)13.3.4 自动挂载 autofs 的使用

在一般 NFS 文件系统的使用情况中，如果客户端要使用服务器端所提供的 NFS 文件系统时，要嘛就是得在  	/etc/rc.d/rc.local 当中设定开机时挂载，要嘛就得要登入系统后手动利用 mount 来挂载。 	此外，客户端得要预先手动的建立好挂载点目录，然后挂载上来。但是这样的使用情况恐怕有点小问题。



- ------

  NFS 文件系统与网络联机的困扰：

我们知道 NFS 服务器与客户端的联机或许不会永远存在，而 RPC 这个服务又挺讨厌的，如果挂载了 NFS  	服务器后，任何一方脱机都可能造成另外一方老是在等待逾时～而且，挂载的 NFS  	文件系统可能又不是常常被使用，但若不挂载的话，有时候紧急要使用时又得通知系统管理员， 	这又很不方便...啊！好讨厌的感觉啊～@_@

所以，让我们换个思考的角度来讨论一下使用 NFS 的情境：

- 可不可以让客户端在有使用到 NFS 文件系统的需求时才让系统自动挂载？
- 当 NFS 文件系统使用完毕后，可不可以让 NFS 自动卸除，以避免可能的 RPC 错误？

如果能达到上述的功能，那就太完美啦！有没有这东西呢？有的，在现在的 Linux 环境下这是可以达成的理想！用的就是  	autofs 这个服务啦！



- ------

  autofs 的设定概念：

autofs 这个服务在客户端计算机上面，会持续的侦测某个指定的目录， 	并预先设定当使用到该目录下的某个次目录时，将会取得来自服务器端的 NFS 文件系统资源，并进行自动挂载的动作。 	讲这样或许你有点模糊，让我们拿底下这个图示来看看：

![autofs 自动挂载的配置文件内容示意图](http://cn.linux.vbird.org/linux_server/0330nfs_files/autofs.gif)
 	图 13.3-1、autofs 自动挂载的配置文件内容示意图

如上图所示，我们的 autofs 主要配置文件为 /etc/auto.master，这个档案的内容很简单， 	如上所示，我只要定义出最上层目录 (/home/nfsfile) 即可，这个目录就是 autofs 会一直持续侦测的目录啦。 	至于后续的档案则是该目录底下各次目录的对应。在 /etc/auto.nfs (这个档案的档名可自定义)  	里面则可以定义出每个次目录所欲挂载的远程服务器的 NFS 目录资源！

举例来说：『当我们在客户端要使用 /home/nfsfile/public 的数据时，此时 autofs 才会去  	192.168.100.254 服务器上挂载 /home/public ！』且『当隔了 5 分钟没有使用该目录下的数据后，则客户端系统将会主动的卸除 	/home/nfsfile/public 』。

很不错用的一个工具吧！因为有用到服务器的数据时才自动挂载，没有使用了就会自动卸除！ 	而不是传统的情况一直是挂载的！既然这么好用，那就让我们实际来操演一下：



- ------

  建立主配置文件 /etc/auto.master ，并指定侦测的特定目录

这个主要配置文件的内容很简单，只要有要被持续侦测的目录及『数据对应文件』即可。 	那个数据对应文件的文件名是可以自行设定的，在鸟哥这个例子当中我使用 /etc/auto.nfs 来命名。

```
[root@clientlinux ~]# vim /etc/auto.master /home/nfsfile  /etc/auto.nfs 
```

上述数据中比较需要注意的是，那个 /home/nfsfile 目录不需要存在，因为 autofs 会主动的建立该目录！ 	如果你建立了，可能反而会出问题～因此，先确定一下没有该目录吧！



- ------

  建立数据对应文件内 (/etc/auto.nfs) 的挂载信息与服务器对应资源

刚刚我们所指定的 /etc/auto.nfs 是自行设定的，所以这个档案是不存在的。那么这个档案的格式是如何呢？你可以这样看：

```
[本地端次目录]  [-挂载参数]  [服务器所提供的目录] 选项与参数： [本地端次目录] ：指的就是在 /etc/auto.master 内指定的目录之次目录 [-挂载参数]    ：就是前一小节提到的 rw,bg,soft 等等的参数啦！可有可无； [服务器所提供的目录] ：例如 192.168.100.254:/home/public 等 [root@clientlinux ~]# vim /etc/auto.nfs public   -rw,bg,soft,rsize=32768,wsize=32768  192.168.100.254:/home/public testing  -rw,bg,soft,rsize=32768,wsize=32768  192.168.100.254:/home/test temp     -rw,bg,soft,rsize=32768,wsize=32768  192.168.100.254:/tmp # 参数部分，只要最前面加个 - 符号即可！ 
```

这样就可以建立对应了！要注意的是，那些 /home/nfsfile/public 是不需要事先建立的！ 	咱们的 autofs 会事情况来处理喔！好了，接下来让我们看看如何实际运作吧！



- ------

  实际运作与观察

配置文件设定妥当后，当然就是要启动 autofs 啦！

```
[root@clientlinux ~]# /etc/init.d/autofs stop [root@clientlinux ~]# /etc/init.d/autofs start # 很奇怪！非常怪！CentOS 6.x 的 autofs 使用 restart 会失效！所以鸟哥才进行两次 
```

假设你目前并没有挂载任何来自 192.168.100.254 这部 NFS 服务器的资源目录。好了， 	那让我们实际来观察看看几个重要的数据吧！先看看 /home/nfsfile 会不会主动的被建立？ 	然后，如果我要进入 /home/nfsfile/public 时，文件系统会如何变化呢？

```
[root@clientlinux ~]# ll -d /home/nfsfile drwxr-xr-x. 2 root root 0 2011-07-28 00:07 /home/nfsfile # 仔细看，妳会发现 /home/nfsfile 容量是 0 喔！那是正常的！因为是 autofs 建立的 [root@clientlinux ~]# cd /home/nfsfile/public [root@clientlinux public]# mount | grep nfsfile 192.168.100.254:/home/public on /home/nfsfile/public type nfs (rw,soft,rsize=32768, wsize=32768,sloppy,vers=4,addr=192.168.100.254,clientaddr=192.168.100.10) # 上面的输出是同一行！瞧！突然出现这个玩意儿！因为是自动挂载的嘛！ [root@clientlinux public]# df  /home/nfsfile/public 文件系统               1K-区段      已用     可用 已用% 挂载点 192.168.100.254:/home/public                       7104640    143104   6607040   3% /home/nfsfile/public # 档案的挂载也出现没错！ 
```

呵呵！真是好啊！如此一来，如果真的有需要用到该目录时，系统才会去相对的服务器上面挂载！ 	若是一阵子没有使用，那么该目录就会被卸除呢！这样就减少了很多不必要的使用时机啦！还不错用吧！ ^_^

------

![大标题的图示](http://cn.linux.vbird.org/image/logo.png)13.4 案例演练

让我们来做个实际演练，在练习之前，请将服务器的 NFS 设定数据都清除，但是保留 rpcbind 不可关闭。至于客户端的环境下， 先关闭 autofs 以及取消之前在 /etc/rc.d/rc.local 里面写入的开机自动挂载项目。同时删除 /home/nfs 目录呦！ 接下来请看看我们要处理的环境为何：

------

模拟的环境状态中，服务器端的想法如下：

1. 假设服务器的 IP 为 192.168.100.254 这一部；
2. /tmp 分享为可擦写，并且不限制使用者身份的方式，分享给所有 192.168.100.0/24 这个网域中的所有计算机；
3. /home/nfs 分享的属性为只读，可提供除了网域内的工作站外，向 Internet 亦提供数据内容；
4. /home/upload 做为 192.168.100.0/24 这个网域的数据上传目录，其中，这个  	/home/upload 的使用者及所属群组为 nfs-upload 这个名字，他的 UID 与 GID 均为 210；
5. /home/andy 这个目录仅分享给 192.168.100.10 这部主机，以提供该主机上面  	andy 这个使用者来使用，也就是说， andy 在 192.168.100.10 及 192.168.100.254 均有账号，且账号均为  	andy ，所以预计开放 /home/andy 给 andy 使用他的家目录啦！

------

服务器端设定的实地演练：

好了，那么请你先不要看底下的答案，先自己动笔或者直接在自己的机器上面动手作作看，等到得到你要的答案之后， 再看底下的说明吧！

1. 首先，就是要建立 /etc/exports 这个档案的内容啰，你可以这样写吧！

   

   `[root@www ~]# vim /etc/exports /tmp         192.168.100.0/24(rw,no_root_squash) /home/nfs    192.168.100.0/24(ro)  *(ro,all_squash) /home/upload 192.168.100.0/24(rw,all_squash,anonuid=210,anongid=210) /home/andy   192.168.100.10(rw) `

2. 再来，就是要建立每个对应的目录的实际 Linux 权限了！我们一个一个来看：

   `# 1. /tmp [root@www ~]# ll -d /tmp drwxrwxrwt. 12 root root 4096 2011-07-27 23:49 /tmp # 2. /home/nfs [root@www ~]# mkdir -p /home/nfs [root@www ~]# chmod 755 -R /home/nfs # 修改较为严格的档案权限将目录与档案设定成只读！不能写入的状态，会更保险一点！ # 3. /home/upload [root@www ~]# groupadd -g 210 nfs-upload [root@www ~]# useradd -g 210 -u 210 -M nfs-upload # 先建立对应的账号与组名及 UID 喔！ [root@www ~]# mkdir -p /home/upload [root@www ~]# chown -R nfs-upload:nfs-upload /home/upload # 修改拥有者！如此，则用户与目录的权限都设定妥当啰！ # 4. /home/andy [root@www ~]# useradd andy [root@www ~]# ll -d /home/andy drwx------. 4 andy andy 4096 2011-07-28 00:15 /home/andy `

   ​	这样子一来，权限的问题大概就可以解决啰！

3. 重新启动 nfs 服务：

   `[root@www ~]# /etc/init.d/nfs restart `

4. 在 192.168.100.10 这部机器上面演练一下：

   `# 1. 确认远程服务器的可用目录： [root@clientlinux ~]# showmount -e 192.168.100.254 Export list for 192.168.100.254: /home/andy   192.168.100.10 /home/upload 192.168.100.0/24 /home/nfs    (everyone) /tmp         192.168.100.0/24 # 2. 建立挂载点： [root@clientlinux ~]# mkdir -p /mnt/{tmp,nfs,upload,andy} # 3. 实际挂载： [root@clientlinux ~]# mount -t nfs 192.168.100.254:/tmp         /mnt/tmp [root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/nfs    /mnt/nfs [root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/upload /mnt/upload [root@clientlinux ~]# mount -t nfs 192.168.100.254:/home/andy   /mnt/andy `

整个步骤大致上就是这样吶！加油喔！

------

![大标题的图示](http://cn.linux.vbird.org/image/logo.png)13.5 重点回顾

- Network FileSystem (NFS) 可以让主机之间透过网络分享彼此的档案与目录；
- NFS 主要是透过 RPC 来进行 file share 的目的，所以 Server 与 Client 的 RPC 一定要启动才行！
- NFS 的配置文件就是 /etc/exports 这个档案；
- NFS 的权限可以观察 /var/lib/nfs/etab，至于的重要登录档可以参考 /var/lib/nfs/xtab  	这个档案，还包含相当多有用的信息在其中！
- NFS 服务器与客户端的使用者账号名称、UID 最好要一致，可以避免权限错乱：
- NFS 服务器预设对客户端的 root 进行权限压缩，通常压缩其成为 nfsnobody 或 nobody。
- NFS 服务器在更动 /etc/exports 这个档案之后，可以透过 exportfs 这个指令来重新挂载分享的目录！
- 可以使用 rpcinfo 来观察 RPC program 之间的关系！！！
- NFS 服务器在设定之初，就必须要考虑到 client 端登入的权限问题，很多时候无法写入或者无法进行分享，主要是  	Linux 实体档案的权限设定问题所致！
- NFS 客户端可以透过使用 showmount, mount 与 umount 来使用 NFS 主机提供的分享的目录！
- NFS 亦可以使用挂载参数，如 bg, soft, rsize, wsize, nosuid, noexec, nodev 等参数， 	来达到保护自己文件系统的目标！
- 自动挂载的 autofs 服务可以在客户端需要 NFS 服务器提供的资源时才挂载。

------

![大标题的图示](http://cn.linux.vbird.org/image/logo.png)13.6 本章习题

- NFS 的主要配置文件为何？而在该档案内主要设定项目为何？ 

  ​	主要的配置文件为 /etc/exports 而至于其设定的内容项目在每一行当中则为： 

  1. 分享的目录
  2. 针对此分享目录开放的主机或 IP或网域
  3. 针对这部主机所开放的权限参数！

- 在 NFS 主要的配置文件当中仅有少许的参数说明，至于预设的参数说明则没有在该档案当中出现， 请问，如果要查阅更详细的分享出来的档案的属性，要看那个档案？ 

  ​	/var/lib/nfs/etab 

- 在 client 端如果要挂载 NFS 所提供分享的档案，可以使用那个指令？ 

  ​	那自然就是 mount 啦！还有卸除是 umount 喔！ 

- 在 NFS 主要配置文件当中，可以透过那个参数来控制不让 client 端以 root 的身份使用你所分享出来的目录与档案？ 

  ​	可以在 /etc/exports 当中的参数项目，设定『 root_squash 』来控制压缩 root 的身份喔！ 

- 我在 client 端挂载了 NFS Server 的某个目录在我的 /home/data  底下，当我执行其中某个程序时，却发现我的系统被破坏了？你认为可能的原因为何？ 该如何克服这样的问题，尤其是当我的 Client 端主机其实是多人共享的环境， 怕其他的使用者也同样发生类似的问题呢？！ 

  - 可能由于你挂载进来的 NFS Server 的 partition 当中具有 SUID  的文件属性，而你不小心使用了该执行档，因此就可能会发生系统被破坏的问题了！
  - 可以将挂载进来的 NFS 目录的 SUID 功能取消！例如：
  - 可能由于你挂载进来的 NFS Server 的 partition 当中具有 SUID  的文件属性，而你不小心使用了该执行档，因此就可能会发生系统被破坏的问题了！
  - 可以将挂载进来的 NFS 目录的 SUID 功能取消！例如：
     mount -t nfs -o nosuid,ro server:/directory /your/directory

------

## 状态

跟踪每个客户机打开的文件，这种信息一般称为“状态”。  
## 文件上锁机制
NFSv4不再想要lockd和statd两个守护进程。


## 安全性
不建议用NFSv2和NFSv3通过广域网提供文件服务。应禁止对TCP和UDP 2049端口的访问，禁止对portmap用的TCP和UDP 111端口的访问。

NFS既然是网络文件系统，客户端和服务端就需要网络来传输数据，NFS服务器端基本会使用2049端口，但因文件系统非常复杂，NFS还会有其他的程序去启动额外的端口用于数据传输，这些额外的传输数据的端口是随机选择小于1024的端口；客户端需要通过远程过程调用（Remote Procedure Call,RPC）协议来找到对应的端口。

**基于RPC通讯调用的NFS实现原理：**

NFS运行过程中需要支持的相当多的功能，不同的功能会使用不同的程序来启动，相对应的就需要启用一些端口来传输数据，所以NFS的功能对应的端口并不固定，客户端需要清楚NFS服务器端的相关端口才能建立连接进行数据传输，RPC就是用来统一管理NFS端口的服务，并且统一对外的端口是111（有点类似nginx，当然这里没有负载均衡，仅仅有点类似代理），RPC会记录NFS每个功能服务的端口的信息，客户端通过RPC实现双方沟通端口信息。

NFS启动就会向RPC去注册自己的所有功能的端口信息，RPC记录下这些端口信息，而RPC会开启111端口对外服务，等待客户端RPC的请求，有客户端请求，服务器端的RPC就会将记录的NFS端口信息发送给客户端，以实际端口进行数据的传输。因此在启动NFS服务之前，需要先启动RPC服务（即centos5.x以下的系统中是portmap服务，centos6.x以上是**rpc-bind**服务，red hat enterprise linux同理），RPC服务重新启动，原来已注册好的NFS端口数据就会全部丢失。此时RPC服务管理的NFS程序需要重新启动以重新向RPC注册。

**注意：**修改NFS配置文件后，不要重启NFS服务，直接命令执行**exportfs –rv**即可使修改的/etc/exports配置文件重新载入而生效。

**NFS工作流程**

1. 服务端启动RPC服务，开启111端口（rpc-bind服务）；
2. 服务端启动NFS服务，向RPC注册端口信息（一般是1024以下的端口）；
3. 客户端启动RPC（rpc-bind服务），向服务端的RPC(rpc-bind服务)服务请求服务端的NFS端口；
4. 服务端的RPC(rpc-bind服务)服务返回NFS端口信息给客户端；
5. 客户端通过获得的NFS端口与服务端的RPC连接并进行数据传输。



安装系统环境：CentOS7

所需软件：

1. **RPC主程序：rpcbind**
2. **NFS主程序：nfs-utils**

**NFS服务主要文件说明：**

**主要配置文件：/etc/exports**

NFS 的主要配置文件，NFS的配置只需在此文件中配置即可。此文件需要手动生成。

**NFS 文件系统维护命令：/usr/sbin/exportfs**

维护 NFS 分享资源的命令，可使用此命令重新载入 /etc/exports内容、实现将NFS服务端共享的目录卸除或重新共享。

**查询服务器共享资源详情的命令：/usr/sbin/showmount**

exportfs 用在 NFS 服务端，showmount 主要用在客户端。showmount 主要用来察看 NFS 客户端共享的目录资源详情。

## NFS服务端

第一步：安装所需软件

**yum install -y nfs-utils rpcbind**

第二部：启动RPC、NFS服务

**systemctl start rpcbind** #先启动rpc服务

**systemctl enable rpcbind**  #设置开机启动

**systemctl start nfs-server** #启动nfs服务

**firewall-cmd --permanent --add-service=nfs** #配置防火墙放行nfs服务

**firewall-cmd --reload** #防火墙重载生效

第三部：新建共享目录

**mkdir -p /nfsdata01** #创建共享目录

**mkdir -p /nfsdata02** #创建共享目录

第四步：编辑配置文件：

**vim /etc/exports**  #vim编辑共享配置文件

内容：

**/nfsdata01 10.211.55.0/24(rw,async,all_squash,insecure)**

**/nfsdata02 \*(rw,async,all_squash,insecure)**

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p3.pstatp.com/large/pgc-image/c049fc2fb9d94235ac16705c21f3087f)

exports文件内容

**配置内容说明：**

格式： **共享目录的路径** **允许访问的NFS客户端**(共享权限参数)

如上，共享目录为/**nfsdata01** , 允许访问的客户端为**10.211.55.0/24**网络用户，权限为可读写，优先将数据保存到内存然后在写入到硬盘，无论客户端是说明账户都映射为nfsnobody账户。

**请注意，NFS客户端地址与权限之间没有空格。**

参数：作用

1. ro：只读
2. rw：读写
3. root_squash：当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户
4. no_root_squash：当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员
5. all_squash：无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户
6. sync：同时将数据写入到内存与硬盘中，保证不丢失数据
7. async：优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据
8. insecure：允许客户端从大于1024的tcp/ip端口连接服务器

第五步：重新载入共享配置使之生效

**exportfs -rv**

第六步：查看共享状态

**showmount -e localhost**

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p3.pstatp.com/large/pgc-image/102892f7a7ea45adadf790f396725c60)

共享生效

## NFS客户端

### 挂载NFS共享的方式

* 使用`mount`命令手动挂载。
* 使用`/etc/fstab`条目在启动时自动挂载。
* 按需挂载，使用`autofs`服务或`systemd.automount`功能。



第一步：从客户端远程查看服务端共享状态

**showmount -e 10.211.55.20**

### 挂载NFS

```bash
# 方法1
mount -t nfs -o rw,sync serverb:/share mountpoint
# -o sync	使mount立即与NFS服务器同步写操作（默认值为异步）

# 方法2
vim /etc/fstab
serverb:/share  /mountpoint  nfs  rw,sync  0 0

mount /mountpoint
```

第三步：查看挂载

df -h

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p1.pstatp.com/large/pgc-image/c269ab13fea64a8c8530013e0e4e9c38)

### 卸载NFS

```bash
umount mountpoint
```

## nfsconf工具

RHEL8 引入nfsconf工具，用于管理NFSv4与NFSv3下的NFS客户端和服务器配置文件。

配置文件：`/etc/nfs.conf`  (早期版本的操作系统中的/etc/sysconfig/nfs文件现已被弃用).1

```bash
/etc/nfs.conf

[nfsd]
# debug=0
# threads=8
# host=
# port=0
# grace-time=90
# lease-time=90
# tcp=y
# vers2=n
# vers3=y
# vers4=y
# vers4.0=y
# vers4.1=y
# vers4.2=y
# rdma=n
```

使用 `nfsconf --set  section  key  value` 来设置指定部分的键值。

```bash
nfsconf --set nfsd vers4.2 y
```

使用 `nfsconf --get section key` 来检索指定部分的键值。

```bash
nfsconf --get nfsd vers4.2
y
```

使用 `nfsconf --unset section key` 来取消设置指定部分的键值。

```bash
nfsconf --unset nfsd vers4.2
```

### 配置一个仅限使用NFSv4的客户端

```bash
# 禁用UDP以及其他与NFSv2和NFSv3有关的键
nfsconf --set nfsd udp n
nfsconf --set nfsd vers2 n
nfsconf --set nfsd vers3 n

# 启用TCP和NFSv4相关键
nfsconf --set nfsd tcp y
nfsconf --set nfsd vers4 y
nfsconf --set nfsd vers4.0 y
nfsconf --set nfsd vers4.1 y
nfsconf --set nfsd vers4.2 y
```

## autofs

自动挂载器是一种服务，可以“根据需要”自动挂载NFS共享，并将在不再使用NFS共享时自动卸载这些共享。

**优势：**

* 用户无需具有root特权就可以运行mount和umount命令。
* 自动挂载器中配置的NFS共享可供计算机上的所有用户使用，受访问权限约束。
* NFS共享不像/etc/fstab中的条目一样永久连接，从而可释放网络和系统资源。
* 自动挂载器在客户端配置，无需进行任何服务器端配置。
* 自动挂载器与mount命令使用相同的选项，包括安全性选项。
* 支持直接和间接挂载点映射，在挂载点位置方面提供了灵活性。
* 可创建和删除间接挂载点，从而避免了手动管理。
* NFS是默认的自动挂载器网络文件系统，但也可以自动挂载其他网络文件系统。
* autofs是一种服务，其管理方式类似于其他系统服务。

### 创建自动挂载

安装 `autofs` 软件包

```bash
yum install autofs
```

向 `/etc/auto.master.d` 添加一个主映射文件。该文件确定用于挂载点的基础目录，并确定用于创建自动挂载的映射文件。

```bash
vim /etc/auto.master.d/demo.autofs
# 文件名可以是任意的。
/shares		/etc/auto.demo
# 为间接映射的挂载添加主映射条目。
# 此条目将使用/shares目录作为间接自动挂载的基础目录。/etc/auto.demo文件中包含挂载详细信息。# 使用绝对文件名。在启动autofs服务之前创建auto.demo文件。
```

创建映射文件。

```bash
vim /etc/auto.demo
# 映射文件的命名规则是/etc/auto.name，其中name反映了映射内容。
work	-rw,sync	serverb:/shares/work
# 条目的格式为 挂载点、挂载选项和源位置。
# 挂载点在man page中被称为"密钥"，由autofs服务自动创建和删除。此例中，完全限定挂载点
# 是/shares/work。autofs服务将根据需要创建和删除/shares目录和/shares/work目录。
# 其他选项：
#		-fstype=	指定文件系统类型
#		-strict		将错误视为严重
```

启动并启用自动挂载器服务。

```bash
systemctl enable --now autofs
```

### 直接映射

用于将NFS共享映射到现有的绝对路径挂载点。

```bash
vim /etc/auto.master.d/demo.autofs
# 文件名可以是任意的。
/-		/etc/auto.direct

vim /etc/auto.direct
/mnt/docs	-rw,sync	serverb:/shares/docs
```

### 间接通配符映射

当NFS服务器导出一个目录中的多个子目录时，可将自动挂载程序配置为使用单个映射条目访问这些子目录其中的任何一个。

```bash
vim /etc/auto.demo
*	-rw,sync	serverb:/shares/&
# 当用户尝试访问/shares/work时，密钥*（此例中为work）将代替源位置中的&符号，并挂载serverb:/shares/work。
```



**三、维护NFS**

格式：

exportfs 选项参数

-a:输出/etc/exports中设置的所有目录

-r:重新读取/etc/exports文件中的设置，并且立即生效，而不需要重新启动NFS服务。

-u:停止输出某一目录

-v:在输出目录时，将目录显示在屏幕上。

1.修改vi /etc/exports后，不用重启服务，直接使用命令输出共享目录

\# exportfs -rv

2.停止输出所有共享目录

\# exportfs -auv

**四、启动和停止NFS服务**

1.启动NFS服务

为了是NFS正常工作，需要启动portmap和nfs这两个目录，并且portmap一定要先于nfs启动。

\# /etc/init.d/portmap start

\# /etc/init.d/nfs start

2.停止NFS 服务

停止NFS服务器前，需要先停止NFS服务再停止portmap服务。如果系统中还有其它服务需要portmap时，则可以不用停止portmap服务。

/etc/init.d/nfs stop

/etc/init.d/portmap stop

3。自启动NFS服务

chkconfig --level 35 portmap on

chkconfig --level 35 nfs on

**五、测试**

1.检查输出目录所使用的选项

在/etc/exports配置文件中，即使只设置了一两个选项，在真正输出目录时，实际上还带了很多某人选项。通过查看 /var/lib/nfs/etab文件，就可以知道真正输出目录时，都是用了什么选项。

2.使用showmount测试NFS输出目录状态

格式：

showmount 参数选项 nfs服务器名称或地址

-a:显示指定的nfs服务器的所有客户端主机及其所连接的目录

-d:显示指定的nfs服务器中已经被客户端连接的所有共享目录

-e:显示指定的nfs服务器上所有输出的共享目录

（1）查看所有输出的共享目录

\# showmount -e

（2）显示所有被挂载的所有输出目录

\# showmount -d

 **六、nfs客户端使用配置**

1.查看nfs服务器信息

在客户端，要查看nfs服务器上有哪些共享目录，可以使用showmount命令。

\# showmount -e 192.168.0.51

如果出现报错信息，首先查看服务器nfs和portmap服务是否启动。再看是否被防火墙屏蔽掉了。

**2.挂载nfs服务器上的共享目录**

 \# mount -t nfs 192.168.0.51:/home/test /mnt/

-t:指定挂载设备的文件类型（nfs是网络文件系统）

192.168.0.51：nfs服务器ip地址

/home/test ：nfs服务器的共享目录

/mnt/：挂载在本地的目录

3.卸载nfs

在不使用nfs目录时，可以用umount命令来卸载该目录

注意：当有客户机正在连接nfs服务器时，此时想要将nfs服务器关机，应该先关掉portmap和nfs这两个服务，否则要等很久才能正常关机。如果无法将portmap和nfs关掉，就直接kill掉进程。也可以用exportmap －auv命令将当前主机中的所有输出目录停止后再关机。

 

 4.启动时自动连接nfs服务器

要先在启动时自动连接nfs服务器上的共享目录，要编辑/etc/fstab文件。在文件中加入

192.168.0.51:/home/test /mnt nfs defaults 0 0

192.168.0.51:/home/test:nfs服务器的共享目录

/mnt：本机挂载目录

 

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

拷贝时cp命令常用参数

cp -a -v /mnt /home/

\- a 该选项通常在拷贝目录时使用。它保留链接、文件属性，并递归地拷贝目录，其作用等于dpR选项的组合。

-v或–verbose 显示指令执行过程。

-V<备份方式>或–version-control=<备份方式> 用”-b”参数备份目标文件后，备份文件的字尾会被加上一个备份字符串，这字符串不仅可用”-S”参数变更，当使用”-V”参数指定不同备份方式时，也会产生不同字尾的备份字串。

\- i 和f选项相反，在覆盖目标文件之前将给出提示要求用户确认。回答y时目标文件将被覆盖，是交互式拷贝。





NFS是基于[UDP](https://baike.baidu.com/item/UDP/571511)/IP协议的应用，其实现主要是采用[远程过程调用](https://baike.baidu.com/item/远程过程调用)[RPC](https://baike.baidu.com/item/RPC/609861)机制，RPC提供了一组与机器、操作系统以及低层传送协议无关的存取远程文件的操作。[RPC](https://baike.baidu.com/item/RPC)采用了[XDR](https://baike.baidu.com/item/XDR)的支持。[XDR](https://baike.baidu.com/item/XDR/8796904)是一种与机器无关的数据描述编码的协议，他以独立与任意[机器体系结构](https://baike.baidu.com/item/机器体系结构/22707109)的格式对网上传送的数据进行编码和解码，支持在异构系统之间数据的传送。 [2] 







## 特点



（1）提供透明文件访问以及文件传输； [2] 

（2）容易扩充新的资源或软件，不需要改变现有的工作环境； [2] 

（3） 高性能，可灵活配置。 [2] 



## 工作原理

NFS（Network File  System，网络文件系统）是当前主流异构平台共享文件系统之一。主要应用在UNIX环境下。最早是由Sun  Microsystems开发，现在能够支持在不同类型的系统之间通过网络进行文件共享，广泛应用在FreeBSD、SCO、Solaris等异构操作系统平台，允许一个系统在网络上与他人共享目录和文件。通过使用NFS，用户和程序可以像访问本地文件一样访问远端系统上的文件，使得每个计算机的节点能够像使用本地资源一样方便地使用网上资源。换言之，NFS可用于不同类型计算机、操作系统、网络架构和传输协议运行环境中的网络文件远程访问和共享。 [4] 

NFS的工作原理是使用客户端/服务器架构，由一个客户端程序和服务器程序组成。服务器程序向其他计算机提供对文件系统的访问，其过程称为输出。NFS客户端程序对共享文件系统进行访问时，把它们从NFS服务器中“输送”出来。文件通常以块为单位进行传输。其大小是8KB（虽然它可能会将操作分成更小尺寸的分片）。NFS传输协议用于服务器和客户机之间文件访问和共享的通信，从而使客户机远程地访问保存在存储设备上的数据。 [4] 



## 网络文件系统架构

NFS 允许计算的客户 — 服务器模型。服务器实施共享文件系统，以及客户端所连接的存储。客户端实施[用户接口](https://baike.baidu.com/item/用户接口)来共享文件系统，并加载到本地文件空间当中。 [3] 

在 Linux中，[虚拟文件系统](https://baike.baidu.com/item/虚拟文件系统/10986803)交换（[VFS](https://baike.baidu.com/item/VFS/7519887)）提供在一个主机上支持多个并发文件系统的方法（比如 [CD-ROM](https://baike.baidu.com/item/CD-ROM/513612) 上的 International Organization for Standardization [ISO] 9660，以及本地硬盘上的  ext3fs）。VFS 确定需求倾向于哪个存储，然后使用哪些文件系统来满足需求。由于这一原因，NFS 是与其他文件系统类似的可插拔文件系统。对于 NFS 来说，唯一的区别是输入/输出（I/O）需求无法在本地满足，而是需要跨越网络来完成。 [3] 

一旦发现了为 NFS 指定的需求，VFS 会将其传递给[内核](https://baike.baidu.com/item/内核)中的 NFS 实例。NFS 解释 I/O 请求并将其翻译为 NFS 程序（OPEN、ACCESS、CREATE、READ、CLOSE、REMOVE  等等）。这些程序，归档在特定 NFS RFC 中，指定了 NFS 协议中的行为。一旦从 I/O 请求中选择了程序，它会在远程程序调用（[RPC](https://baike.baidu.com/item/RPC/609861)）层中执行。正如其名称所暗示的，RPC 提供了在系统间执行程序调用的方法。它将封送 NFS 请求，并伴有参数，管理将它们发送到合适的远程对等级，然后管理并追踪响应，提供给合适的请求者。 [3] 

进一步来说，RPC 包括重要的[互操作](https://baike.baidu.com/item/互操作/9878042)层，称为外部数据表示（[XDR](https://baike.baidu.com/item/XDR/8796904)），它确保当涉及到数据类型时，所有 NFS 参与者使用相同的语言。当给定架构执行请求时，数据类型表示可能不同于满足需求的目标主机上的数据类型。XDR 负责将[类型转换](https://baike.baidu.com/item/类型转换/8832591)为公共表示（XDR），便于所有架构能够与共享文件系统互操作。XDR 指定类型字节格式（比如 float）和类型的字节排序（比如修复可变长数组）。虽然 XDR 以其在 NFS 中的使用而闻名，当您在公共应用程序设置中处理多个架构时，它是一个有用的规范。 [3] 

一旦 XDR 将数据转换为公共表示，需求就通过网络传输给出[传输层](https://baike.baidu.com/item/传输层)协议。早期 NFS 采用 Universal Datagram Protocol(UDP），但是，今天 TCP 因为其优越的可靠性而更加通用。 [3] 

在服务器端，NFS 以相似的风格运行。需求到达网络[协议栈](https://baike.baidu.com/item/协议栈/3155224)，通过 RPC/[XDR](https://baike.baidu.com/item/XDR/8796904)（将数据类型转换为服务器架构） 然后到达 NFS 服务器。NFS 服务器负责满足需求。需求向上提交给 NFS [守护进程](https://baike.baidu.com/item/守护进程)，它为需求标示出目标文件系统树，并且 VFS 再次用于在本地存储中获取文件系统。整个流程在图 3 中有展示。注意，服务器中的本地文件系统是典型的 Linux 文件系统（比如  ext4fs）。因此，NFS 不是传统意义上的文件系统，而是访问远程文件系统的协议。 [3] 

对于高延迟网络，NFSv4 实现称为 compound procedure 的程序。这一程序从本质上允许在单个请求中嵌入多个 RPC 调用，来最小化通过网络请求的 transfer tax。它还为响应实现[回调](https://baike.baidu.com/item/回调/9837525)模式。 [3] 



## 网络文件系统协议

从客户端的角度来说，NFS 中的第一个操作称为 mount。Mount 代表将远程文件系统加载到本地文件系统空间中。该流程以对 mount(Linux [系统调用](https://baike.baidu.com/item/系统调用/861110)）的调用开始，它通过 VFS 路由到 NFS 组件。确认了加载[端口号](https://baike.baidu.com/item/端口号/10883658)之后（通过 get_port 请求对远程服务器 RPC 调用），客户端执行 RPC mount 请求。这一请求发生在客户端和负责 mount  协议（rpc.mountd）的特定守护进程之间。这一守护进程基于服务器当前导出文件系统来检查客户端请求；如果所请求的文件系统存在，并且客户端已经访问了，一个 RPC mount 响应为文件系统建立了[文件句柄](https://baike.baidu.com/item/文件句柄/3978023)。客户端这边存储具有本地加载点的远程加载信息，并建立执行 I/O 请求的能力。这一协议表示一个潜在的安全问题；因此，NFSv4 用内部 RPC 调用替换这一辅助 mount 协议，来管理加载点。 [3] 

要读取一个文件，文件必须首先被打开。在 RPC 内没有 OPEN 程序；反之，客户端仅检查目录和文件是否存在于所加载的文件系统中。客户端以对目录的 GETATTR RPC  请求开始，其结果是一个具有目录属性或者目录不存在指示的响应。接下来，客户端发出 LOOKUP RPC  请求来查看所请求的文件是否存在。如果是，会为所请求的文件发出 GETATTR RPC 请求，为文件返回属性。基于以上成功的 GETATTRs 和 LOOKUPs，客户端创建[文件句柄](https://baike.baidu.com/item/文件句柄)，为用户的未来需求而提供的。 [3] 

利用在远程文件系统中指定的文件，客户端能够触发 READ RPC 请求。READ  包含文件句柄、状态、偏移、和读取计数。客户端采用状态来确定操作是否可执行（那就是，文件是否被锁定）。偏移指出是否开始读取，而计数指出所读取字节的数量。服务器可能返回或不返回所请求字节的数量，但是会指出在 READ RPC 回复中所返回（随着数据）字节的数量。 [3] 



## 网络文件系统中的创新

NFS 的两个最新版本（4 和 4.1）对于 NFS 来说是最有趣和最重要的。让我们来看一下 NFS 创新最重要的一些方面。 [3] 

在 NFSv4 之前，存在一定数量的辅助协议用于加载、锁定、和文件管理中的其他元素。NFSv4 将这一流程简化为一个协议，并将对 UDP 协议的支持作为[传输协议](https://baike.baidu.com/item/传输协议)移除。NFSv4 还集成支持 UNⅨ 和基于 Windows? 的文件访问语义，将本地集成 NFS 扩展到其他操作系统中。 [3] 

NFSv4.1 介绍针对更高扩展性和更高性能的并行 NFS(pNFS）的概念。要支持更高的可扩展性，NFSv4.1 具有脚本，与集群化文件系统风格类似的拆分数据/[元数据](https://baike.baidu.com/item/元数据/1946090)架构。pNFS 将生态系统拆分为三个部分：客户端、服务器和存储。您可看到存在两个路径：一个用于数据，另一个用于控制。pNFS  将数据布局与数据本身拆分，允许双路径架构。当客户想要访问文件时，服务器以布局响应。布局描述了文件到存储设备的映射。当客户端具有布局时，它能够直接访问存储，而不必通过服务器（这实现了更大的灵活性和更优的性能)。当客户端完成文件操作时，它会提交数据（变更）和布局。如果需要，服务器能够请求从客户端返回布局。 [3] 

pNFS 实施多个新协议操作来支持这一行为。LayoutGet 和 LayoutReturn 分别从服务器获取发布和布局，而 LayoutCommit 将来自客户端的数据提交到[存储库](https://baike.baidu.com/item/存储库)，以便于其他用户使用。服务器采用 LayoutRecall 从客户端[回调](https://baike.baidu.com/item/回调/9837525)布局。布局跨多个存储设备展开，来支持并行访问和更高的性能。 [3] 

数据和[元数据](https://baike.baidu.com/item/元数据/1946090)都存储在[存储区域](https://baike.baidu.com/item/存储区域)中。客户端可能执行直接 I/O ，给出布局的回执，而 NFSv4.1 服务器处理元[数据管理](https://baike.baidu.com/item/数据管理/295844)和存储。虽然这一行为不一定是新的，pNFS 增加功能来支持对存储的多访问方法。当前，pNFS 支持采用基于块的协议（[光纤通道](https://baike.baidu.com/item/光纤通道/305148)），基于对象的协议，和 NFS 本身（甚至以非 pNFS 形式）。 [3] 

通过 2010 年 9 月发布的对 NFSv2 的请求，继续开展 NFS 工作。其中以新的提升定位了虚拟环境中存储的变化。例如，数据复制与在[虚拟机环境](https://baike.baidu.com/item/虚拟机环境/4777921)中非常类似（很多操作系统读取/写入和缓存相同的数据）。由于这一原因，[存储系统](https://baike.baidu.com/item/存储系统)从整体上理解复制发生在哪里是很可取的。这将在客户端保留缓存空间，并在存储端保存容量。NFSv4.2  建议用共享块来处理这一问题。因为存储系统已经开始在后端集成处理功能，所以服务器端复制被引入，当服务器可以高效地在存储后端自己解决数据复制时，就能减轻内部存储网络的负荷。其他创新出现了，包括针对 flash 存储的子文件缓存，以及针对 I/O 的客户端提示 （潜在地采用 mapadvise 作为路径）。 

## 网络文件系统的替代物

虽然 NFS 是在 UNIX和 Linux 系统中最流行的网络文件系统，但它当然不是唯一的选择。在 Windows系统中，Server Message Block [[SMB](https://baike.baidu.com/item/SMB/4750512)]（也称为 CIFS）是最广泛使用的选项（如同 Linux 支持 SMB一样，Windows 也支持 NFS）。 [3] 

最新的[分布式文件系统](https://baike.baidu.com/item/分布式文件系统)之一，在 Linux 中也支持，是 [Ceph](https://baike.baidu.com/item/Ceph)。Ceph 设计为容错的分布式文件系统，它具有 UNⅨ 兼容的 Portable Operating System Interface(POSⅨ）。您可在 参考资料 中深入了解 Ceph。 [3] 

其他例子包括 OpenAFS，是 Andrew 分布式文件系统的开源版（来自 Carnegie Mellon 和 IBM），[GlusterFS](https://baike.baidu.com/item/GlusterFS/8422801)，关注于可扩展存储的通用分布式文件系统，以及 Lustre，关注于[集群计算](https://baike.baidu.com/item/集群计算/3691564)的大规模并行分布式文件系统。所有都是用于[分布式存储](https://baike.baidu.com/item/分布式存储/5557030)的开源软件解决方案。 [3] 

FS介绍

网络文件系统（network files system）简称NFS是一种基于TCP传输协议的文件共享习通。
NFS的CS体系中的服务端启用协议将文件共享到网络上，然后允许本地NFS客户端通过网络挂载服务端共享的文件。
应用场景：
为web服务器作为视频，图片资源的服务器。域用户家目录服务器。内容文件存储服务器。
NFS部署

安装：
yum install nfs-utils -y
启动：
systemctl status rpcbind.server 确保rpc启动
systemctl start nfs 启动nfs
systemctl enable nfs 确保开机启动
验证：
systeam is-active nfs
配置共享文件
vim /etc/exports
共享格式： 共享目录绝对路径 授权的ip或网段（权限1，权限2）
权限说明
权限	用途
ro	只读
rw	读写访问
sync	客户端写入数据同步到服务器后才会返回
no_root_squash	客户端root用户具有完全的权限
root_squash	root用户权限被映射成服务端上的普通用户nobody
anonuid	指定匿名用户的UID
anongid	指定匿名用户的GID
NFS管理

通过exportfs对NFS进行管理
exportfs 管理NFS共享文件列表
-a 打开或取消所有目录共享
-o options 指定选项
-r 重读
-v 详细
通过showmount检查是否共享成果
NFS原理

在这里插入图片描述
当NFS服务器设置好一个共享目录，且设置好授权ip以及权限后，有访问权的客户机就可以将此目录挂载到自己某个挂载点。
例
既然NS的客户及服务器是基于TCP会话建立访问的，那么两者能够互访的前提是知道互相的IP和程序的端口号。
对于IP，服务器是设置对某一IP网段授权的；客户机是设置挂载某个网络目录的。所以他们IP互知。
对于端口号。NFS的端口号大概位于2049，但是因为文件系统非常复杂，往往的情况是端口号不固定（2049+的形式），以及NFS需要启动额外的端口，这些端口是1024以下的随机端口。那么客户机如何知道服务器的端口号呢？答案是：通过rpcbind实现
RPC机制介绍

rpc程序会随着nfs启用而自动开启，默认端口号为固定的111.
当nfs启动后，会随机占用一些端口。
然后nfs会找rpcbind进行注册，记录这些端口信息。
rpc的固定端口是111，当rpc记录到nfs的端口号后会沟通客户机的111端口，并且通知nfs的端口。
当客户端知道了rpc通知的nfs端口号，就可以不依靠rpc进行工作了。
在这里插入图片描述
1）首先服务器端启动RPC服务，并开启111端口
2）服务器端启动NFS服务，并向RPC注册端口信息
3）客户端启动RPC（portmap服务），向服务端的RPC(portmap)服务请求服务端的NFS端口
4）服务端的RPC(portmap)服务反馈NFS端口信息给客户端。
5）客户端通过获取的NFS端口来建立和服务端的NFS连接并进行数据的传输。
在这里插入图片描述
注：rpc重启后，nfs的注册信息会丢失，因此需要重启nfs完成注册。

利用autofs自动挂载
/etc/aotu.master 定义本地挂载点
/etc/auto.misc 配置挂载的文件系统 以及 选项

master
/服务器共享的目录 /子配置目录（可以自己创建）
子配置文件格式
【挂载点目录】【参数】【:/文件系统】



 

RPC，基于C/S模型。程序可以使用这个协议请求网络中另一台计算机上某程序的服务而不需知道网络细节，甚至可以请求对方的系统调用。 

对于Linux而言，文件系统是在内核空间实现的，即文件系统比如ext3、ext4等是在Kernel启动时，以内核模块的身份加载运行的。 

 

## 二、原理

NFS本身的服务并没有提供数据传递的协议，而是通过使用RPC（远程过程调用 Remote Procedure Call）来实现。当NFS启动后，会随机的使用一些端口，NFS就会向RPC去注册这些端口。RPC就会记录下这些端口，RPC会开启111端口。通过client端和sever端端口的连接来进行数据的传输。在启动nfs之前，首先要确保rpc服务启动。 

具体过程如下： 

![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618221958977-1162276457.png)

1. 本地用户要访问nfs服务器中文件，先向内核发起请求，内核处理调用nfs模块及rpc client 
2. rpc client向rpc server发起连接 
3. 在连接之前，NFS服务除了启动nfsd本身监听的端口2049/tcp和2049/udp，还会启动其它进程（如mountd，statd，rquotad等）以完成文件共享，这些进程的端口是不固定的；是每次NFS服务启动时向RPC服务注册的，RPC服务会随机分配未使用的端口 
4. 完成连接，接受访问请求 
5. nfs应用程序向内核发起请求 
6. 内核调用文件系统 

​    然后client端通过获取的NFS端口来建立和server端的NFS连接并进行数据的传输。

 

 

以下为启动**各服务的作用** 

**rpc：**远程过程调用协议，是实现本地调用远程主机实现系统调用的协议。 

**portmapper：**负责分配rpc server的端口，并在client端请求时，负责响应目的rpc server端口返回给client端，工作在tcp与udp的111端口上。 

**mountd：**是nfs服务的认证服务的守护进程，client在收到返回的真正端口时，就会去连接mountd，认证取得令牌。 

**nfsd：**nfs的守护进程，负责接收到用户的调用请求后与内核发出请求并得到调用结果响应给用户，工作在tcp和udp的2049端口。 

**idmapd：**是NFS的一个程序，用来负责远程client端创建文件后的权限问题。 

**quotad：**用用于实现磁盘配额，当client端挂载nfs后可以限制磁盘空间的大小。 

 

## 三、NFS服务配置安装

 

![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618221959395-624353756.png)

 

**相关配置文件及命令的使用** 

/etc/exports 

/path/to/somedir CLIENT_LIST 

  多个客户之间使用空白字符分隔 

每个客户端后面必须跟一个小括号，里面定义了此客户访问特性，如访问权限等 

172.16.0.0/16(ro,async) 192.16.0.0/24(rw,sync) *(ro) 

 

权限属性： 

  ro:只读 

  rw:读写 

  sync:同步，数据同步写到内存与硬盘中 

  async:异步，数据先暂存内存 

  root_squash: 将root用户映射为来宾账号 

  no_root_squash: 有root的权限，不建议使用 

  all_squash: 全部映射为来宾账号 

  anonuid, anongid: 指定映射的来宾账号的UID和GID 

 

exportfs命令： 

  -a：跟-r或-u选项同时使用，表示重新挂载所有文件系统或取消导出所有文件系统； 

  -r: 重新导出 

  -u: 取消导出 

  -v: 显示详细信息 

 

showmount命令： 

showmount -e NFS_SERVER: 查看NFS服务器"导出"的各文件系统 

showmount -a NFS_SERVER: 查看NFS服务器所有被挂载的文件系统及其挂载的客户端对应关系列表 

showmount -d NFS_SERVER: 显示NFS服务器所有导出的文件系统中被客户端挂载了文件系统列表 

 

rpcinfo 

-p hostname(orIP) 

-p ：显示所有的 port 与 program 的信息！ 

 

如果要让mountd和quotad等进程监听在固定端口，编辑配置文件/etc/sysconfig/nfs 

 

客户端使用mount命令挂载 

mount -t nfs NFS_SERVER:/PATH/TO/SOME_EXPORT /PATH/TO/SOMEWHRERE 

 

**安装配置** 

环境准备： 

server端：192.168.1.222 centos 7 

client端：192.168.1.200 centos 6.5 

 

 

　　1.在服务端安装nfs， 

　　# yum install nfs-utils rpcbind -y 

 

  ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618221959663-426589246.png) 

 

　　2.编辑/etc/exports，并启动nfs 

　　![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618221959844-803084024.png)

　　#systemctl start nfs 

 

　　3.客户端同样安装nfs-utils和rpcbind并启动，必须先启动rpcbind，否则报错（注意防火墙等） 

　　![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222000220-762626715.png)

　　4.挂载并查看挂载信息 

　　# mount -t nfs 192.168.1.222:/var/nfs /mnt 

　　#showmount –e 192.168.1.222 

　　![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222000513-1219450687.png)

　　在服务器端/var/nfs创建目录或文件，并在客户端/mnt查看即可。 

 

将所有用户映射为来宾账号实验 

1. 在服务器端添加用户hot，并修改配置文件并重新挂载文件系统 

   添加用户 

   useradd –u 520 hot 

   修改/etc/exports 

   /var/nfs  192.168.1.0/24(rw,async,all_squash,anonuid=520) 

   重新挂载导出 

   exportfs –ra 

   ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222000774-835400305.png)

2. 在客户端上添加用户code，分别在code用户和root用户下创建文件，查看文件属性 

   ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222000966-209472388.png)

   ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222001157-957798719.png)

    

   可以看到文件属主都为服务器端设置好的来宾账号hot的uid 

    

    

   让mountd和quotad等进程监听在固定端口，编辑配置文件/etc/sysconfig/nfs，取消注释 

   ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222001480-825645119.png)

   重启nfs，查看端口 

   ![img](https://images2018.cnblogs.com/blog/1387124/201806/1387124-20180618222001779-1588876937.png)

​      

以下是NFS最显而易见的好处：

　　1. 节省本地存储空间，将常用的数据存放在一台NFS服务器上且可以通过网络访问，那么本地终端将可以减少自身存储空间的使用。

　　2. 用户不需要在网络中的每个机器上都建有Home目录，Home目录可以放在NFS服务器上且可以在网络上被访问使用。

　　3. 一些存储设备CDROM和Zip（一种高储存密度的磁盘驱动器与磁盘）等都可以在网络上被别的机器使用。这可以减少整个网络上可移动介质设备的数量。

　　NFS 的基本原则是“容许不同的客户端及服务端通过一组RPC分享相同的文件系统”，它是独立于操作系统，容许不同硬件及操作系统的系统共同进行文件的分享。

　　NFS在文件传送或信息传送过程中依赖于RPC协议。RPC，远程过程调用 (Remote Procedure Call) 是能使客户端执行其他系统中程序的一种机制。NFS本身是没有提供信息传输的协议和功能的，但NFS却能让我们通过网络进行资料的分享，这是因为NFS使用了一些其它的传输协议。而这些传输协议用到这个RPC功能的。可以说NFS本身就是使用RPC的一个程序。或者说NFS也是一个RPC SERVER。所以只要用到NFS的地方都要启动RPC服务，不论是NFS SERVER或者NFS CLIENT。这样SERVER和CLIENT才能通过RPC来实现PROGRAM PORT的对应。可以这么理解RPC和NFS的关系：NFS是一个文件系统，而RPC是负责负责信息的传输。

**二、NFS服务端所需的软件列表**

**nfs-utils:** 这个是NFS服务主程序（包含rpc.nfsd、rpc.mountd、daemons）

**rpcbind:** 这个是CentOS6.X的RPC主程序（CentOS5.X的为portmap）

**三、检查软件是否安装**

```
[root@NFS-server ~]# rpm -qa nfs-utils rpcbind #检查安装的软件包
rpcbind-0.2.0-12.el6.x86_64
nfs-utils-1.2.3-70.el6_8.2.x86_64
```

<如果没有安装在系统中通过yum 命令进行安装以上两个包>

```
[root@NFS-server ~]# yum install -y nfs-utils rpcbind #安装上述所需的两个软件包
```

**四、启动NFS服务端相关服务**

-**--开启rpcbind服务**

```
[root@NFS-server ~]# /etc/init.d/rpcbind status  #查询rpcbind服务状态并启动
rpcbind (pid 1281) is running...
[root@NFS-server ~]# LANG=en
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# lsof -i :111  #查询rpcbind监听状态 (111是rpcbind的主端口)
COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
rpcbind 1281 rpc 6u IPv4 10766 0t0 UDP *:sunrpc
rpcbind 1281 rpc 8u IPv4 10769 0t0 TCP *:sunrpc (LISTEN)
rpcbind 1281 rpc 9u IPv6 10771 0t0 UDP *:sunrpc
rpcbind 1281 rpc 11u IPv6 10774 0t0 TCP *:sunrpc (LISTEN)
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# netstat -lntup |grep rpcbind #查询rpcbind服务启动状态 (同lsof查询端口效果一样)
tcp 0 0 0.0.0.0:111 0.0.0.0:* LISTEN 1281/rpcbind
tcp 0 0 :::111 :::* LISTEN 1281/rpcbind
udp 0 0 0.0.0.0:608 0.0.0.0:* 1281/rpcbind
udp 0 0 0.0.0.0:111 0.0.0.0:* 1281/rpcbind
udp 0 0 :::608 :::* 1281/rpcbind
udp 0 0 :::111 :::* 1281/rpcbind
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# chkconfig --list rpcbind #检查rpcbind自启动情况
rpcbind 0:off 1:off 2:on 3:on 4:on 5:on 6:off
root@NFS-server ~]# rpcinfo -p localhost #查看NFS服务项rpc服务器注册的端口信
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224441143-164142395.png)

<这个是还未启动FNS服务的rpcbind状态>

**---启动NFS服务**

```
[root@NFS-server ~]# /etc/init.d/nfs status #查看NFS服务并启动
rpc.svcgssd is stopped
rpc.mountd (pid 1526) is running...
nfsd (pid 1542 1541 1540 1539 1538 1537 1536 1535) is running...
rpc.rquotad (pid 1521) is running...
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# netstat -lntup|grep nfs #查看NFS端口启动(FNS默认端口为2049)
[root@NFS-server ~]# lsof -i :2049 #查看NFS端口启动(FNS默认端口为2049)
[root@NFS-server ~]# netstat -lntup|grep 2049 #查看NFS端口启动(FNS默认端口为2049)
tcp 0 0 0.0.0.0:2049 0.0.0.0:* LISTEN -
tcp 0 0 :::2049 :::* LISTEN -
udp 0 0 0.0.0.0:2049 0.0.0.0:* -
udp 0 0 :::2049 :::* -
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# rpcinfo -p localhost #启动NFS过后rpcbind服务已经启用了对FNS的端口映射
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224315940-1809764269.png)

<这个是启动FNS服务过后 的rpcbind的状态>

```
[root@NFS-server ~]# chkconfig --list nfs  #查看nfs的开机自启动情况
nfs 0:off 1:off 2:on 3:on 4:on 5:on 6:off
[root@NFS-server ~]# chkconfig nfs on #让FNS开机自启动
```

由于在FNS服务过程中，必须先启动rpcbind，再启动nfs，这样才能让NFS在rpcbind上注册成功

```
[root@NFS-server ~]# less /etc/init.d/rpcbind  #查看rpcbind服务启动详情
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224555159-1562993864.png)

同理我们查看nfs服务的自启动详情

```
[root@NFS-server ~]# less /etc/init.d/nfs
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224625237-989426736.png)

<由上面可以看出系统默认会让rpcbind服务先启动，再启动nfs服务，但是在实际生产环境中，我们最好不要用chkconfig来控制服务的开机自启动，我们生产环境中我们一般用rc.local来管理。主要是为了方便以后查阅哪些服务开机自己，并且能控制先后顺序，如图>

<为了规范化我们用rc.local来管理开机自启动>

```
[root@NFS-server ~]# vi /etc/rc.local
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224643596-1663100751.png)

**NFS服务常见进程的详细说明**

我们可以重NFS服务的启动过程看到以下几个进程：

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224703050-392902948.png)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@NFS-server ~]# ps -ef |egrep "rpc|nfs" #查看nfs相进程
rpcuser 1303 1 0 Nov22 ? 00:00:00 rpc.statd  #检查文件一致性
root 1512 2 0 Nov22 ? 00:00:00 [rpciod/0]
rpc 2723 1 0 02:43 ? 00:00:00 rpcbind
root 2896 1 0 02:56 ? 00:00:00 rpc.rquotad  #磁盘配额进程
root 2901 1 0 02:56 ? 00:00:00 rpc.mountd #权限管理验证等
root 2908 2 0 02:56 ? 00:00:00 [nfsd4]
root 2909 2 0 02:56 ? 00:00:00 [nfsd4_callbacks]
root 2910 2 0 02:56 ? 00:00:00 [nfsd]
root 2911 2 0 02:56 ? 00:00:00 [nfsd]
root 2912 2 0 02:56 ? 00:00:00 [nfsd]
root 2913 2 0 02:56 ? 00:00:00 [nfsd] #NFS主进程，管理登入，身份判定
root 2914 2 0 02:56 ? 00:00:00 [nfsd]
root 2915 2 0 02:56 ? 00:00:00 [nfsd]
root 2916 2 0 02:56 ? 00:00:00 [nfsd]
root 2917 2 0 02:56 ? 00:00:00 [nfsd]
root 2948 1 0 02:56 ? 00:00:00 rpc.idmapd  #名称映射
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

<如果对上述进程不明白可以 用man命令查阅帮助信息，如 “man rpc.statd”>

**五、配置NFS服务端**

前面介绍了NFS的启动，接下来我们配置NFS服务端的配置

/etc/exports 是NFS程序的配置文件。并且默认为空

/etc/exports文件的配置格式为：

NFS共享目录 NFS客户端地址1(参数1,参数2,参数3......) 客户端地址2(参数1,参数2,参数3......)

NFS共享目录 NFS客户端地址(参数1,参数2,参数3......) 

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224724487-467363803.png)

<我们在此共享给 192.168.1.0/24所有主机，>

<man exports 查看 例子和参数详情。如下：>

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224738175-417538432.png)

配置完成exports后平滑重启NFS服务 ，下面两条命令等同

```
[root@NFS-server ~]# /etc/init.d/nfs reload
[root@NFS-server ~]# exportfs -r
[root@NFS-server ~]# showmount -e 127.0.0.1 #查看本机挂载情况
```

<必须先启动rpcbinc 再启动nfs才会显示正确>

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224835206-224243257.png)

```
[root@NFS-server ~]# mount -t nfs 192.168.1.5:/data /mnt #在本机测试挂载
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224913534-1073828712.png)

<我们用客户机器进行挂载并测试>

<挂在过后由于权限问题，我们不能再/mnt里面进行编辑删除新增文件等操作。接下来为/data目录进行权限的设置>

**六、配置NFS客户端**

客户端也需要安装rpcbind和nfs-utils软件，并且设置开机自启动。(只需要启动rpcbind即可)

然后再进行如下操作

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224934518-253203039.png)

<自此，我们配置成功，但是别高兴。我们只是挂载动作完成了，但是我们没有权限对挂载的目录进行各种操作。>

**接下来我们在服务端配置如下命令，给/data目录添加nfsnobody权限，**

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126224949846-277755994.png)

```
[root@NFS-server ~]# cat /var/lib/nfs/etab  #查看一条配置的详细信息
```

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126225010675-1803912564.png)

现在我们可以对挂载目录进行各种操作，但是还没有完。我们需要把挂载命令放在rc.local里面，

我们不要把挂载命令放在fstab，因为fstab比网络先启动，会出现挂载不上网络NFS

\-------------------------------------------------------------------------------------------------------

**WINDOWS客户端的配置**

现在我们客户端和服务端的NFS配置都已经完成，多台客户端同上的客户端操作，

如果是WINDOWS客户端，我们需要在程序和功能里面启用 NFS客户端。

![img](https://images2015.cnblogs.com/blog/986848/201611/986848-20161126225115050-2055018922.png)

 

Windows 7 连接 NFS Server：

控制面板——所有控制面板项——程序和功能——勾选NFS服务，NFS客户端

CMD 进入命令行

mount ip:/www/abc/ z:

 

其它不支持直接连接NFS Server的windows，可以在系统上面安装SFU ([Windows Services for UNIX](http://pan.baidu.com/s/1eRROvZk))，点开始–>点程序–>点Windows Services for UNIX–>Korn Shell

mount ip:/www/abc/ z:

\------------------------------------------------------------------------------------------------------

**总结NFS服务的配置过程：**

**--服务端--**

1.安装软件

yum install -y nfs-utils rpcbind

2.启动服务(先启动rpcbind)

/etc/init.d/rpcbind start

/etc/init.d/nfs start

3.设置开机自启动

chkconfig nfs on

chkconfig rpcbind on

修改rc.local

4.配置NFS服务

echo "/data 192.168.1.5/24(rw,sync)"

mkdir -p /data

chown -R nfsnobody.nfsnobody /data

5.重新加载服务

/etc/init.d/nfs reload 或者 exportfs -r

6.检查或测试挂载

showmount -e localhost

mount -t nfs 192.168.1.5:/data /mnt

 

**--客户端-**

1.安装软件

yum install -y nfs-utils rpcbind

2.启动rpcbind

/etc/init.d/rpcbind start

3.配置开机自启动

chkconfig rpcbind on

或者修改rc.local

4.测试服务端共享情况

show -e 192.168.1.5

5.挂载

mkdir -p /data

mount -t nfs 192.168.1.5:/data /data

6.测试是否有读写权限

\-----------------------------------------------------------------------------------------------

**常见错误**

1.df -h 检查服务端的NFS服务是不是启动成功，

2.确认NFS客户端showmount是否OK。

3.确认rpcbind上是否有NFS注册，(rpcbind必须先启动)

3.确认网络是否通畅

4.确认是否因为防火墙挡住(一般内网不需要开启防火墙，在出口加防火墙就够了)

\-----------------------------------------------------------------------------------------

后续会对NFS各种优化的内容进行更新

 

 

在绝大多数情况下，NFS 支持已经安装在 Linux 内核中。我们可以使用以下命令安装内核态的 NFS 服务器实现：

```
sudo apt install nfs-kernel-server
```

（如果有兼容 NFSv2 和 NFSv3 的需求，需要安装 `portmap`）

出于安全性的考虑[2](https://lug.ustc.edu.cn/planet/2019/08/NFS-intro/#fn:2)，我们假设 NFS 共享的根目录是 `/srv/nfs4`。 如果需要共享的目录在其他位置，可以使用 bind mount 的方式挂载上去。（当然，对于简单的配置来说，不这样做问题也不大）

```
mount --bind 实际放置文件的目录 /srv/nfs/your_folder_name
```

编辑 `/etc/exports`，设置共享文件夹的位置、允许访问的 IP、权限等，以下是一个示例。

```
/srv/nfs4/Downloads 192.168.124.0/24(rw,sync)
```

这里设置了 `/srv/nfs4/Downloads` 可以被 192.168.124.0/24 的子网访问，如果希望所有人都可以访问，可以用星号 `*` 代替这里的网段。参数为可读写 (rw)，同步 (sync，即更改操作完成之后才会返回用户的请求)。更多的参数细节可以至 `man exports` 查看。

接下来，重启 NFS 服务，服务器端就配置好了。

```
sudo systemctl restart nfs-kernel-server
```

接下来配置一下客户端。安装 `nfs-common`，之后就可以愉快地挂载了。

```
sudo mount -t nfs4 192.168.124.18:/srv/nfs4/Downloads /mnt/nfs_mount/
```

此处将服务器 192.168.124.18 上的 NFS 共享挂载到了 `/mnt/nfs_mount/` 文件夹下。可以看到服务器的文件显示在了客户端中，可以正常打开。

可以使用 `showmount -e 服务器名称或 IP` 来查看某台服务器上可挂载的 NFS 共享。

如果发现写入没有权限的话，这是由于客户端用户访问时的权限在服务器端会变为匿名用户 (nobody. uid, gid = 65534) 以保障安全性。可以调整文件夹的权限、调整「匿名用户」为指定的 UID 和 GID，或者设置导出参数 `no_root_squash`，使客户端用户权限可以在服务端保持（很危险，因为在挂载点中，客户端的 root 和服务端的 root 是一样的）。

### Windows[Permalink](https://lug.ustc.edu.cn/planet/2019/08/NFS-intro/#windows)

下面以一台在同一局域网的 Windows 10 机器为例。在「启用或关闭 Windows 功能」中添加 NFS 客户端支持。

​                ![img](https://lug.ustc.edu.cn/static/planet/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7-2019-08-28-13.57.03-1.png)                                  Windows 功能 => NFS 服务 => NFS 客户端                              

此客户端会在系统中安装 `mount` 等工具。

​                ![img](https://lug.ustc.edu.cn/static/planet/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7-2019-08-28-13.59.48-1-1024x824.png)                                  Windows 版本 `mount` 的使用帮助                              

如果我们需要挂载上面那个服务器的共享，可以输入以下命令：

```cmd
mount \\服务器名称\共享路径 设备名（盘符）
```

​                ![img](https://lug.ustc.edu.cn/static/planet/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7-2019-08-28-14.10.47.png)                                  大概是成功挂载了                              

只不过……好像哪里不太对劲？

​                ![img](https://lug.ustc.edu.cn/static/planet/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7-2019-08-28-14.14.09-1024x555.png)                                  中文的文件名变成了乱码                              

Windows 中官方的 NFS 支持提供的 `mount` 不支持 UTF-8 编码，导致了乱码的产生。如果需要 Windows 支持，考虑以下一些方法：

- 使用 `fuse-convmvfs` 修改服务端文件的编码，详见[此 Super User 上的回答](https://superuser.com/questions/302407/what-to-do-with-nfs-server-utf-8-and-windows-7)。
- 找一个别的 Windows 的 NFS 客户端。
- 如果正在使用新版的 Windows 10，在区域设置中启用 Beta 版本的 UTF-8 支持。注意这可能会导致一部分软件出现乱码。

如果要取消挂载，使用 `umount` 即可。

### macOS[Permalink](https://lug.ustc.edu.cn/planet/2019/08/NFS-intro/#macos)

相比于 Windows 的挂载体验来说，macOS 由于是 Unix 系的操作系统，挂载 NFS 就方便一些。直接把 Linux 的命令复制过来就……

```
$ sudo mount -t nfs4 192.168.124.18:/srv/nfs4/Downloads nfs_mount
Password:
mount: exec /Library/Filesystems/nfs4.fs/Contents/Resources/mount_nfs4 for /Users/tao/nfs_mount: No such file or directory
```

诶？稍微调整一下……

```
$ sudo mount -t nfs 192.168.124.18:/srv/nfs4/Downloads nfs_mount
mount_nfs: can't mount /srv/nfs4/Downloads from 192.168.124.18 onto /Users/tao/nfs_mount: Operation not permitted
```

这是因为 NFS 服务器默认配置要求来源端口小于 1024 以「保障安全」（因为这样的端口只有 root 用户可以开）。当然 macOS 中 mount_nfs 的文档里面也这样吐槽：

> resvport: Use a reserved socket port number.
>
> This is useful for mounting servers that require  clients to use a reserved port number on the mistaken belief that this  makes NFS more secure. (For the rare case where the client has a trusted root account but untrustworthy users and the network cables are in  secure areas this does help, but for normal desktop clients this does  not apply.)
>
> BSD System Manager’s Manual, mount_nfs

有两个解决方案：

- 服务器端参数加入 `insecure`。这样的话 Finder 也可以轻松挂载。
- 命令行加入 `-o resvport` 参数。

挂载之后，在 Finder 侧边栏也会显示。编码显示非常正常。

## 历史

网络文件系统（NFS）是文件系统之上的一个网络抽象，来允许远程客户端以与本地文件系统类似的方式，来通过网络进行访问。虽然 NFS 不是第一个此类系统，但是它已经发展并演变成 UNIX系统中最强大最广泛使用的网络文件系统。NFS  允许在多个用户之间共享公共文件系统，并提供数据集中的优势，来最小化所需的存储空间。

网络文件系统（[NFS](https://baike.baidu.com/item/NFS/812203)）从1984 年问世以来持续演变，并已成为[分布式文件系统](https://baike.baidu.com/item/分布式文件系统/1250388)的基础。当前，NFS（通过 pNFS 扩展）通过网络对分布的文件提供可扩展的访问。 

第一个网络文件系统称为 File Access Listener — 由 Digital Equipment Corporation(DEC）在 1976 年开发。Data Access Protocol(DAP）的实施，这是 DECnet [协议集](https://baike.baidu.com/item/协议集/10291708)的一部分。比如 [TCP/IP](https://baike.baidu.com/item/TCP%2FIP/214077)，DEC 为其网络协议发布了协议规范，包括DAP。

NFS 是第一个现代网络文件系统（构建于 IP 协议之上）。在 20 世纪 80 年代，它首先作为实验文件系统，由 Sun Microsystems  在内部完成开发。NFS 协议已归档为 Request for Comments(RFC）标准，并演化为大家熟知的 NFSv2。作为一个标准，由于 NFS 与其他客户端和服务器的[互操作](https://baike.baidu.com/item/互操作/9878042)能力而发展快速。

标准持续地演化为 NFSv3，在 RFC 1813 中有定义。这一新的协议比以前的版本具有更好的可扩展性，支持大文件（超过 2GB），异步写入，以及将 TCP  作为传输协议，为文件系统在更广泛的网络中使用铺平了道路。在 2000 年，RFC 3010（由 RFC 3530 修订）将 NFS  带入企业设置。Sun 引入了具有较高安全性，带有状态协议的 NFSv4(NFS 之前的版本都是无状态的）。今天，NFS 是版本 4.1（由  RFC 5661 定义），它增加了对跨越分布式服务器的并行访问的支持（称为 pNFS extension）。 
