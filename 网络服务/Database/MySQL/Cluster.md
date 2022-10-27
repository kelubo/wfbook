# MySQL Cluster

[TOC]

## 概述

MySQL Cluster 是一种技术，允许在无共享的系统中部署“内存中”数据库的 Cluster 。通过无共享体系结构，系统能够使用廉价的硬件，而且对软硬件无特殊要求。此外，由于每个组件都有自己的内存和硬盘，因此不存在单点故障。

由一组计算机构成，每台计算机上均运行着多种进程，包括 MySQL 服务器、NDB Cluster 的数据节点、管理服务器以及（可能）专门的数据访问程序。

 ![](../../../Image/c/cluster-components-1.png)

采用 NDB Cluster 存储引擎。