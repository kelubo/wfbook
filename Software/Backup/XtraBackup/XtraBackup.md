# XtraBackup

[TOC]

## 概述

Percona XtraBackup 是一个开源的热备份工具，适用于基于 MySQL 的服务器，可在计划的维护窗口内保持数据库完全可用。适用于所有版本的 Percona Server for MySQL 和 MySQL®，可在事务系统上执行在线无阻塞、紧密压缩、高度安全的完整备份。

无论是 24x7 高负载服务器还是低事务量服务器，Percona XtraBackup 都能在不影响服务器性能的情况下实现无缝备份。Percona  XtraBackup （PXB） 是一种 100% 开源备份解决方案，为希望从 MySQL  的全面、响应迅速且成本灵活的数据库支持中受益的组织提供[商业支持](https://www.percona.com/mysql-support/)。

这是一个创新版本。这种类型的版本仅在短时间内受支持，旨在用于升级周期较快的环境。开发人员和 DBA 可以接触到最新的功能和改进。

## 支持的存储引擎

Percona XtraBackup 可以备份 MySQL 8.4 服务器上的 InnoDB、XtraDB、MyISAM、MyRocks 表以及带有  XtraDB 的 Percona Server for MySQL、Percona Server for MySQL 8.4 和 Percona XtraDB Cluster 8.4 上的数据。

Percona XtraBackup 8.4 支持 MyRocks 存储引擎。MyRocks 存储引擎上的增量备份不会确定早期的完整备份或增量备份是否包含重复文件。Percona XtraBackup 每次备份时都会复制所有 MyRocks 文件。

### 限制

Percona XtraBackup 8.4 不支持备份版本在 8.4 之前的 MySQL 、Percona Server for MySQL 或 Percona XtraDB Cluster 中创建的数据库。

