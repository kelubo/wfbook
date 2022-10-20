# FS-Cache

[TOC]

## 概述

FS-Cache 是一种持久的本地缓存，文件系统可以使用它通过网络检索数据，并将其缓存在本地磁盘上。这有助于最小化网络流量，以便用户从通过网络挂载的文件系统访问数据（例如 NFS）。

​				下图显示了 FS-Cache 的工作原理：

![FS-Cache 概述](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_file_systems-zh-CN/images/315fe3b891f2a78cb30c1cebbf0373e0/fs-cache.png)

​				FS-Cache 旨在对系统的用户和管理员尽可能透明。与 Solaris 上的 `cachefs` 不同，FS-Cache 允许服务器上的文件系统直接与客户端的本地缓存进行交互，而不创建过度挂载的文件系统。使用 NFS 时，挂载选项指示客户端挂载启用了 FS-cache 的 NFS 共享。挂载点将导致两个内核模块的自动上传：`fscache` 和 `cachefile`。`cachefilesd` 守护进程与内核模块进行通信来实施缓存。 		

​				FS-Cache 不会改变通过网络工作的文件系统的基本操作 -  它只是为文件系统提供了一个永久的位置，它可以在该位置缓存数据。例如，客户端仍然可以挂载 NFS 共享，无论是否启用了  FS-Cache。此外，缓存的 NFS  可以处理不能全部放入缓存的文件（无论是单独的还是总体的），因为文件可以部分缓存，且不必预先完全读取。FS-Cache  还会隐藏发生在客户端文件系统驱动程序的缓存中的所有 I/O 错误。 		

​				要提供缓存服务，FS-Cache 需要一个 *缓存后端*。缓存后端是配置来提供缓存服务的存储驱动程序，即 `cachefile`。在这种情况下，FS-Cache 需要一个挂载的基于块的文件系统，该文件系统支持 `bmap` 和扩展属性（例如 ext3）来作为其缓存后端。 		

​				支持 FS-Cache 缓存后端所需的功能的文件系统包括以下文件系统的 Red Hat Enterprise Linux 9 实现： 		

- ​						ext3（启用了扩展属性） 				
- ​						ext4 				
- ​						XFS 				

​				FS-Cache 不能任意缓存任何文件系统，不论是通过网络还是通过其他方式：必须更改共享文件系统的驱动程序，来允许与 FS-Cache、数据存储/检索以及元数据设置和验证进行交互。FS-Cache 需要来自缓存文件系统的 *索引密钥* 和 *一致性数据* 来支持持久性：使用索引密钥匹配文件系统对象来缓存对象，使用一致性数据来确定缓存对象是否仍然有效。 		

注意

​					在 Red Hat Enterprise Linux 9 中，不会默认安装 **cachefilesd** 软件包，需要手动安装。 			

## 性能保证

​				FS-Cache *不*保证更高的性能。使用缓存会导致性能下降：例如，缓存的 NFS 共享会为跨网络查找增加对磁盘的访问。虽然 FS-Cache 尝试尽可能异步，但有一些同步路径（例如读取）的情况，其中异步是不可能的。 		

​				例如，使用 FS-Cache ，通过没有负载的 GigE 网络在两台计算机之间缓存 NFS 共享，可能不会在文件访问方面显示出任何性能的改进。相反，从服务器内存而不是从本地磁盘可以更快地满足NFS 请求。 		

​				因此，使用 FS-Cache 是各种因素之间的 *折衷*。例如，如果使用 FS-Cache 来缓存 NFS 流量，它可能会减慢一点儿客户端的速度，但通过满足本地的读请求而无需消耗网络带宽，可以大量减少网络和服务器加载。 		

## 设置缓存

​				目前，Red Hat Enterprise Linux 9 只提供 `cachefiles` 缓存后端。`cachefilesd` 守护进程启动并管理 `cachefile`。`/etc/cachefilesd.conf` 文件控制 `cachefile` 如何提供缓存服务。 		

​				缓存后端的工作原理是在托管缓存的分区上维护一定数量的空闲空间。当系统的其他元素耗尽空闲空间时，它会增长和收缩缓存，使得可以在根文件系统（例如，在笔记本电脑上）上安全地使用。FS-Cache 对此行为设置默认值，可以通过 *cache cull limits* 进行配置。有关配置 cache cull limits 的更多信息，请参阅 [Cache cull limits 配置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/managing_file_systems/index#cache-cull-limits-configuration_getting-started-with-fs-cache)。 		

​				这个过程演示了如何设置缓存。 		

**先决条件**

- ​						已 **安装** cachefilesd 软件包，且服务已成功启动。要确定该服务正在运行，请使用以下命令： 				

  ```none
  # systemctl start cachefilesd
  # systemctl status cachefilesd
  ```

  ​						状态必须 *处于活动状态（正在运行）* 。 				

**流程**

1. ​						在缓存后端中配置要将哪个目录用作缓存，请使用以下参数： 				

   ```none
   $ dir /path/to/cache
   ```

2. ​						通常，缓存后端目录是在 `/etc/cachefilesd.conf` 中将其设为 `/var/cache/fscache`，如下所示： 				

   ```none
   $ dir /var/cache/fscache
   ```

3. ​						如果要更改缓存后端目录，selinux 上下文必须与 `/var/cache/fscache` 相同： 				

   ```none
   # semanage fcontext -a -e /var/cache/fscache /path/to/cache
   # restorecon -Rv /path/to/cache
   ```

4. ​						设置缓存时，将 */path/to/cache* 替换为目录名称。 				

5. ​						如果给定的设置 selinux 上下文的命令无法工作，请使用以下命令： 				

   ```none
   # semanage permissive -a cachefilesd_t
   # semanage permissive -a cachefiles_kernel_t
   ```

   ​						FS-Cache 会将缓存存储在托管 `*/path/to/cache*` 的文件系统中。在笔记本电脑上，建议使用 root 文件系统(`/`)作为主机文件系统，但对于台式电脑而言，挂载专门用于缓存的磁盘分区更为明智。 				

6. ​						主机文件系统必须支持用户定义的扩展属性；FS-Cache 使用这些属性来存储一致的维护信息。要为 ext3 文件系统（例如 `*device*`）启用用户定义的扩展属性，请使用： 				

   ```none
   # tune2fs -o user_xattr /dev/device
   ```

7. ​						要在挂载时为文件系统启用扩展属性，作为替代方法，请使用以下命令： 				

   ```none
   # mount /dev/device /path/to/cache -o user_xattr
   ```

8. ​						配置文件就位后，启动 `cachefilesd` 服务： 				

   ```none
   # systemctl start cachefilesd
   ```

9. ​						要将 `cachefilesd` 配置为在引导时启动，请以 root 用户身份执行以下命令： 				

   ```none
   # systemctl enable cachefilesd
   ```

## cache cull limits 配置

​				`cachefilesd` 守护进程的工作原理是：缓存来自共享文件系统的远程数据，以释放磁盘上的空间。这可能会消耗掉所有空闲空间，如果磁盘还存放 root 分区，这可能会很糟糕。为了对此进行控制，`cachefiled` 会尝试通过丢弃缓存中的旧对象（例如，最近不经常访问的）来维护一定数量的空闲空间。这个行为被称为 *cache culling*。 		

​				缓存筛选是根据底层文件系统中可用块的百分比以及可用文件的百分比来实现的。`/etc/cachefilesd.conf` 中有控制六个限制的设置： 		

- brun *N*%（块百分比）、frun *N*%（文件百分比）

  ​							如果缓存中空闲空间的数量和可用文件的数量超过这两个限制，则关闭筛选。 					

- bcull *N*%（块百分比）、fcull *N*%（文件百分比）

  ​							如果缓存中可用空间的数量或文件的数量低于其中任何一个限制，则启动筛选。 					

- bstop *N*%（块百分比）、fstop *N*%（文件百分比）

  ​							如果缓存中可用空间的数量或可用文件的数量低于其中任何一个限制，则不允许进一步分配磁盘空间或文件，直到筛选再次引发超过这些限制的情况。 					

​				每个设置的 `N` 的默认值如下： 		

- ​						`brun`/`frun` - 10% 				
- ​						`bcull`/`fcull` - 7% 				
- ​						`bstop`/`fstop` - 3% 				

​				在配置这些设置时，必须满足以下条件： 		

- ​						0 ࣘ `bstop` < `bcull` < `brun` < 100 				
- ​						0 ࣘ `fstop` < `fcull` < `frun` < 100 				

​				这些是可用空间和可用文件的百分比，不会显示成 100 减去 `df` 程序所显示的百分比。 		

重要

​					筛选同时依赖于 b*xxx* 和 f*xxx* 对；用户不能单独处理它们。 			

## 从 fscache 内核模块检索统计信息

​				FS-Cache 还跟踪一般的统计信息。这个流程演示了如何获取此信息。 		

**流程**

1. ​						要查看有关 FS-Cache 的统计信息，请使用以下命令： 				

   ```none
   # cat /proc/fs/fscache/stats
   ```

​				FS-Cache 统计数据包括有关决策点和对象计数器的信息。如需更多信息，请参阅以下内核文档： 		

​				`/usr/share/doc/kernel-doc-4.18.0/Documentation/filesystems/caching/fscache.txt` 