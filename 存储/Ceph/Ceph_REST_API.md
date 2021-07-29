# Ceph REST API

[TOC]

## 简介

Ceph 官方提供的 RESTful API 接口，启动其进程后，可以通过 HTTP 接口来收集Ceph 集群状态与数据，并且进行起停 OSD 等管理操作。

## 启动API

```bash
ceph-rest-api -n client.admin
```

## 测试API

通过简单的curl命令即可获得集群的状态信息。

```bash
curl 127.0.0.1:5000/api/v0.1/health

HEALTH_OK
```

或者查询更复杂的数据。

```bash
curl 127.0.0.1:5000/api/v0.1/osd/tree

ID WEIGHT  TYPE NAME            UP/DOWN REWEIGHT PRIMARY-AFFINITY
-1 1.00000 root default
-2 1.00000      host dev
 0 1.00000      osd.0           up      1.00000  1.00000
-3       0      rack rack01
-4       0      rack rack02
-5       0      rack rack03
```

