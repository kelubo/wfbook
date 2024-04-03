# ACME http-01 challenge support ACME http-01 challenge 支持

​        version 版本              



This guide describes how to configure Kolla Ansible to enable ACME http-01 challenge support. As of Victoria, Kolla Ansible supports configuring HAProxy Horizon frontend to proxy ACME http-01 challenge requests to selected external (not deployed by Kolla Ansible) ACME client servers. These can be ad-hoc or regular servers. This guide assumes general knowledge of ACME.
本指南介绍如何配置 Kolla Ansible 以启用 ACME http-01 质询支持。从 Victoria 开始，Kolla Ansible 支持配置  HAProxy Horizon 前端，以将 ACME http-01 质询请求代理到选定的外部（不是由 Kolla Ansible  部署的）ACME 客户端服务器。这些服务器可以是临时服务器或常规服务器。本指南假定您具备 ACME 的一般知识。

Do note ACME supports http-01 challenge only over official HTTP(S) ports, that is 80 (for HTTP) and 443 (for HTTPS). Only Horizon is normally deployed on such port with Kolla Ansible (other services use custom ports). This means that, as of now, running Horizon is mandatory to support ACME http-01 challenge.
请注意，ACME 仅支持通过官方 HTTP（S） 端口（即 80（用于 HTTP）和 443（用于 HTTPS））进行 http-01 质询。通常只有  Horizon 使用 Kolla Ansible 部署在此类端口上（其他服务使用自定义端口）。这意味着，截至目前，必须运行 Horizon  才能支持 ACME http-01 挑战。

## How To (External ACME client) 操作方法（外部 ACME 客户端）¶

You need to determine the IP address (and port) of the ACME client server used for http-01 challenge (e.g. the host you use to run certbot). The default port is usually `80` (HTTP). Assuming the IP address of that host is `192.168.1.1`, the config would look like the following:
您需要确定用于 http-01 质询的 ACME 客户端服务器的 IP 地址（和端口）（例如，用于运行 certbot 的主机）。默认端口通常 `80` 为 （HTTP）。假设该主机的 IP 地址为 `192.168.1.1` ，则配置如下所示：

```
enable_horizon: "yes"
acme_client_servers:
  - server certbot 192.168.1.1:80
```

`acme_client_servers` is a list of HAProxy backend server directives. The first parameter is the name of the backend server - it can be arbitrary and is used for logging purposes.
 `acme_client_servers` 是 HAProxy 后端服务器指令的列表。第一个参数是后端服务器的名称 - 它可以是任意的，用于日志记录目的。

After (re)deploying, you can proceed with running the client to host the http-01 challenge files. Please ensure Horizon frontend responds on the domain you request the certificate for.
（重新）部署后，可以继续运行客户端以托管 http-01 质询文件。请确保 Horizon 前端在您为其请求证书的域上做出响应。

To use the newly-generated key-cert pair, follow the [TLS](https://docs.openstack.org/kolla-ansible/latest/admin/tls.html) guide.
要使用新生成的密钥证书对，请遵循 TLS 指南。