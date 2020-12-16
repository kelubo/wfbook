# RGW

[TOC]

网关守护进程内嵌了 Civetweb，无需额外安装 web 服务器或配置 FastCGI。

> Tip
>
> Civetweb 默认使用 `7480` 端口。要么直接打开 `7480` 端口，要么在你的 Ceph 配置文件中设置首选端口（例如 `80` 端口）。

## 安装对象网关

1. 使用 Civetweb 的默认端口 `7480` ，必须通过 `firewall-cmd` 或 `iptables` 来打开它。

2. 从管理节点的工作目录，在 `client-node` 上安装 Ceph 对象网关软件包。例如：

   ```bash
   ceph-deploy install --rgw <client-node> [<client-node> ...]
   ```

## 新建对象网关实例

从管理节点的工作目录，在 `client-node` 上新建一个 Ceph 对象网关实例。例如：

```bash
ceph-deploy rgw create
```

一旦网关开始运行，可以通过 `7480` 端口来访问它（比如 `http://client-node:7480` ）。

## 配置对象网关实例

1. 通过修改 Ceph 配置文件可以更改默认端口（比如改成 `80` ）。增加名为 `[client.rgw.<client-node>]` 的小节，把 `<client-node>` 替换成你自己 Ceph 客户端节点的短名称（即 `hostname -s` 的输出）。例如，你的节点名就是 `client-node` ，在 `[global]` 节后增加一个类似于下面的小节：

   ```bash
   [client.rgw.client-node]
   rgw_frontends = "civetweb port=80"
   ```

   > Note
>
   > 确保在 `rgw_frontends` 键值对的 `port=<port-number>` 中没有空格。

2. 为了使新端口的设置生效，需要重启 Ceph 对象网关。在 RHEL 7 和 Fedora 上 ，执行：

   ```bash
   sudo systemctl restart ceph-radosgw.service
   ```

   在 RHEL 6 和 Ubuntu 上，执行：

   ```bash
   sudo service radosgw restart id=rgw.<short-hostname>
   ```

3. 最后，检查节点的防火墙，确保你所选用的端口（例如 `80` 端口）处于开放状态。如果没有，把该端口加入放行规则并重载防火墙的配置。例如：

   ```bash
   sudo firewall-cmd --list-all sudo firewall-cmd --zone=public --add-port
   80/tcp --permanent
   sudo firewall-cmd --reload
   ```

   应该可以生成一个未授权的请求，并收到应答。例如，一个如下不带参数的请求：

   ```bash
http://<client-node>:80
   ```
   
   应该收到这样的应答：

   ```bash
<?xml version="1.0" encoding="UTF-8"?>
   <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
     <Owner>
       <ID>anonymous</ID>
       <DisplayName></DisplayName>
     </Owner>
     <Buckets>
     </Buckets>
   </ListAllMyBucketsResult>
   ```
   