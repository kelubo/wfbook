# How to install and configure isc-kea 如何安装和配置 isc-kea

In this guide we show how to install and configure `isc-kea` in Ubuntu 23.04
在本指南中，我们将展示如何在 Ubuntu 23.04 中安装和配置 `isc-kea` 
 or greater. [Kea](https://www.isc.org/kea/) is the DHCP server developed by ISC to replace `isc-dhcp`. It is newer and designed for more modern network environments.
或更大。Kea 是 ISC 开发的 DHCP 服务器，用于取代 `isc-dhcp` .它较新，专为更现代的网络环境而设计。

For `isc-dhcp-server` instructions, [refer to this guide instead](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-dhcp-server).
有关 `isc-dhcp-server` 说明，请参阅本指南。

## Install isc-kea 安装 isc-kea

At a terminal prompt, enter the following command to install `isc-kea`:
在终端提示符下，输入以下命令进行安装 `isc-kea` ：

```bash
sudo apt install kea
```

This will also install a few binary packages, including
这还将安装一些二进制包，包括

- `kea-dhcp4-server`: The IPv4 DHCP server (the one we will configure in this guide).
   `kea-dhcp4-server` ：IPv4 DHCP 服务器（我们将在本指南中配置的服务器）。
- `kea-dhcp6-server`: The IPv6 DHCP server.
   `kea-dhcp6-server` ：IPv6 DHCP 服务器。
- `kea-ctrl-agent`: A REST API service for Kea.
   `kea-ctrl-agent` ：用于 Kea 的 REST API 服务。
- `kea-dhcp-ddns-server`: A Dynamic DNS service to update DNS based on DHCP lease events.
   `kea-dhcp-ddns-server` ：一种动态DNS服务，用于根据DHCP租用事件更新DNS。

Since the `kea-ctrl-agent` service has some administrative rights to the Kea
由于该 `kea-ctrl-agent` 服务对 Kea 具有一些管理权限
 services, we need to ensure regular users are not allowed to use the API
服务中，我们需要确保普通用户不被允许使用API
 without permissions. Ubuntu does it by requiring user authentication to access
未经许可。Ubuntu 通过要求用户身份验证才能访问来做到这一点
 the `kea-ctrl-agent` API service ([LP: #2007312 has more details on this](https://bugs.launchpad.net/ubuntu/+source/isc-kea/+bug/2007312)).
 `kea-ctrl-agent` API 服务（ LP： #2007312 对此有更多详细信息）。

Therefore, the installation process described above will get a debconf “high”
因此，上述安装过程将获得 debconf “高”
 priority prompt with 3 options:
带有 3 个选项的优先级提示：

- no action (default); 无操作（默认）;
- configure with a random password; or
  使用随机密码进行配置;或
- configure with a given password.
  使用给定的密码进行配置。

If there is no password, the `kea-ctrl-agent` will **not** start.
如果没有密码， `kea-ctrl-agent` 则不会启动。

The password is expected to be in `/etc/kea/kea-api-password`, with ownership
密码应位于 `/etc/kea/kea-api-password` 中，具有所有权
 `root:_kea` and permissions `0640`. To change it, run `dpkg-reconfigure kea-ctrl-agent`
 `root:_kea` 和权限 `0640` 。要更改它，请运行 `dpkg-reconfigure kea-ctrl-agent` 
 (which will present the same 3 options from above again), or just edit the file
（这将再次从上面显示相同的 3 个选项），或者只是编辑文件
 manually. 手动地。

## Configure kea-dhcp4 配置 kea-dhcp4

The `kea-dhcp4` service can be configured by editing `/etc/kea/kea-dhcp4.conf`.
 `kea-dhcp4` 可以通过编辑 `/etc/kea/kea-dhcp4.conf` 来配置服务。

Most commonly, what you want to do is let Kea assign an IP address from a
最常见的是，您要做的是让 Kea 从
 pre-configured IP address pool. This can be done with settings as follows:
预配置的 IP 地址池。这可以通过如下设置来完成：

```auto
{
  "Dhcp4": {
	"interfaces-config": {
  	"interfaces": [ "eth4" ]
	},
	"control-socket": {
    	"socket-type": "unix",
    	"socket-name": "/run/kea/kea4-ctrl-socket"
	},
	"lease-database": {
    	"type": "memfile",
    	"lfc-interval": 3600
	},
	"valid-lifetime": 600,
	"max-valid-lifetime": 7200,
	"subnet4": [
  	{
    	"id": 1,
    	"subnet": "192.168.1.0/24",
    	"pools": [
      	{
        	"pool": "192.168.1.150 - 192.168.1.200"
      	}
    	],
    	"option-data": [
      	{
        	"name": "routers",
        	"data": "192.168.1.254"
      	},
      	{
        	"name": "domain-name-servers",
        	"data": "192.168.1.1, 192.168.1.2"
      	},
      	{
        	"name": "domain-name",
        	"data": "mydomain.example"
      	}
    	]
  	}
	]
  }
}
```

This will result in the DHCP server listening on interface “eth4”, giving clients an IP address from the range `192.168.1.150 - 192.168.1.200`. It will lease an IP address for 600 seconds if the client doesn’t ask  for a specific time frame. Otherwise the maximum (allowed) lease will be 7200 seconds. The server will also “advise” the client to use `192.168.1.254` as the default-gateway and `192.168.1.1` and `192.168.1.2` as its DNS servers.
这将导致DHCP服务器侦听接口“eth4”，从而为客户端提供以下范围 `192.168.1.150 - 192.168.1.200` 的IP地址。如果客户端不要求特定的时间范围，它将租用 IP 地址 600 秒。否则，最大（允许）租约将为 7200 秒。服务器还将“建议”客户端用作 `192.168.1.254` 默认网关和 `192.168.1.1`  `192.168.1.2` 其 DNS 服务器。

After changing the config file you can reload the server configuration through `kea-shell` with the following command (considering you have the `kea-ctrl-agent` running as described above):
更改配置文件后， `kea-shell` 您可以使用以下命令重新加载服务器配置（假设您已按上述 `kea-ctrl-agent` 方式运行）：

```bash
kea-shell --host 127.0.0.1 --port 8000 --auth-user kea-api --auth-password $(cat /etc/kea/kea-api-password) --service dhcp4 config-reload
```

Then, press ctrl-d. The server should respond with:
然后，按 ctrl - d 。服务器应响应：

```json
[ { "result": 0, "text": "Configuration successful." } ]
```

meaning your configuration was received by the server.
表示服务器已收到您的配置。

The `kea-dhcp4-server` service logs should contain an entry similar to:
 `kea-dhcp4-server` 服务日志应包含类似于以下内容的条目：

```auto
DHCP4_DYNAMIC_RECONFIGURATION_SUCCESS dynamic server reconfiguration succeeded with file: /etc/kea/kea-dhcp4.conf
```

signaling that the server was successfully reconfigured.
表示服务器已成功重新配置。

You can read `kea-dhcp4-server` service logs with `journalctl`:
您可以使用以下命令 `journalctl` 读取 `kea-dhcp4-server` 服务日志：

```bash
journalctl -u kea-dhcp4-server
```

Alternatively, instead of reloading the DHCP4 server configuration through
或者，而不是通过
 `kea-shell`,  you can restart the `kea-dhcp4-service` with:
 `kea-shell` ，您可以通过以下命令重新启动： `kea-dhcp4-service` 

```bash
systemctl restart kea-dhcp4-server
```

## Further reading 延伸阅读

- [ISC Kea Documentation ISC Kea 文档](https://kb.isc.org/docs/kea-administrator-reference-manual)