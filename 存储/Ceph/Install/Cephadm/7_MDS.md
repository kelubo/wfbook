# MDS

[TOC]

## 部署CephFS

使用 CephFS 文件系统需要一个或多个 MDS 守护进程。如果使用较新的 `ceph fs volume` 接口创建新的文件系统，则会自动创建这些卷。

例如：

```bash
ceph fs volume create <fs_name> --placement="<placement spec>"
```
对于手动部署MDS守护程序，请使用以下规范：

```yaml
service_type: mds
service_id: fs_name
placement:
  count: 3
```

然后可使用以下方法应用本规范：

```bash
ceph orch apply -i mds.yaml
```
