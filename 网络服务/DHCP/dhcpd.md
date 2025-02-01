# How to install and configure isc-dhcp-server 如何安装和配置 isc-dhcp-server

> **Note**: 注意：
>  Although Ubuntu still supports `isc-dhcp-server`, this software is [no longer supported by its vendor](https://www.isc.org/blogs/isc-dhcp-eol/). It has been replaced by [Kea](https://www.isc.org/kea/).
> 尽管 Ubuntu 仍然支持 `isc-dhcp-server` ，但其供应商不再支持该软件。它已被 Kea 取代。

In this guide we show how to install and configure `isc-dhcp-server`, which installs the dynamic host configuration protocol daemon, `dhcpd`. For `isc-kea` instructions, [refer to this guide instead](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-kea).
在本指南中，我们将展示如何安装和配置 `isc-dhcp-server` ，这将安装动态主机配置协议守护程序。 `dhcpd` 有关 `isc-kea` 说明，请参阅本指南。

## Install isc-dhcp-server 安装 isc-dhcp-server

At a terminal prompt, enter the following command to install `isc-dhcp-server`:
在终端提示符下，输入以下命令进行安装 `isc-dhcp-server` ：

```bash
sudo apt install isc-dhcp-server
```

> **Note**: 注意：
>  You can find diagnostic messages from `dhcpd` in `syslog`.
> 您可以从 `dhcpd` 中找到诊断 `syslog` 消息。

## Configure isc-dhcp-server 配置 isc-dhcp-server

You will probably need to change the default configuration by editing `/etc/dhcp/dhcpd.conf` to suit your needs and particular configuration.
您可能需要通过编辑 `/etc/dhcp/dhcpd.conf` 来更改默认配置，以满足您的需求和特定配置。

Most commonly, what you want to do is assign an IP address randomly. This can be done with `/etc/dhcp/dhcpd.conf` settings as follows:
最常见的是，您要做的是随机分配一个 IP 地址。这可以通过如下 `/etc/dhcp/dhcpd.conf` 设置来完成：

```plaintext
# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
    
subnet 192.168.1.0 netmask 255.255.255.0 {
 range 192.168.1.150 192.168.1.200;
 option routers 192.168.1.254;
 option domain-name-servers 192.168.1.1, 192.168.1.2;
 option domain-name "mydomain.example";
}
```

This will result in the DHCP server giving clients an IP address from the range `192.168.1.150 - 192.168.1.200`. It will lease an IP address for 600 seconds if the client doesn’t ask  for a specific time frame. Otherwise the maximum (allowed) lease will be 7200 seconds. The server will also “advise” the client to use `192.168.1.254` as the default-gateway and `192.168.1.1` and `192.168.1.2` as its DNS servers.
这将导致 DHCP 服务器向客户端提供 范围 `192.168.1.150 - 192.168.1.200` 的 IP 地址。如果客户端不要求特定的时间范围，它将租用 IP 地址 600 秒。否则，最大（允许）租约将为 7200 秒。服务器还将“建议”客户端用作 `192.168.1.254` 默认网关和 `192.168.1.1`  `192.168.1.2` 其 DNS 服务器。

You also may need to edit `/etc/default/isc-dhcp-server` to specify the interfaces `dhcpd` should listen to.
您可能还需要进行编辑 `/etc/default/isc-dhcp-server` 以指定 `dhcpd` 应侦听的接口。

```auto
INTERFACESv4="eth4"
```

After changing the config files you need to restart the `dhcpd` service:
更改配置文件后，您需要重新启动 `dhcpd` 服务：

```auto
sudo systemctl restart isc-dhcp-server.service
```

## Further reading 延伸阅读

- The [isc-dhcp-server Ubuntu Wiki](https://help.ubuntu.com/community/isc-dhcp-server) page has more information.
  isc-dhcp-server Ubuntu Wiki 页面有更多信息。
- For more `/etc/dhcp/dhcpd.conf` options see the [dhcpd.conf man page](https://manpages.ubuntu.com/manpages/focal/en/man5/dhcpd.conf.5.html?_gl=1*8w9p8d*_gcl_au*MTA4Nzc1OTY4Mi4xNzA4NTkxMzIz&_ga=2.20823608.1270490133.1713754079-464715154.1708591317).
  有关更多 `/etc/dhcp/dhcpd.conf` 选项，请参见 dhcpd.conf 手册页。
- [ISC dhcp-server ISC dhcp-服务器](https://www.isc.org/software/dhcp)

------