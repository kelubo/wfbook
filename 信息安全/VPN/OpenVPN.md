# How to install and use OpenVPN 如何安装和使用OpenVPN 

OpenVPN is a flexible, reliable and secure Virtual Private Networking (VPN)  solution. It belongs to the family of SSL/TLS VPN stacks (different from IPSec VPNs). This chapter will show how to install and configure  OpenVPN to create a VPN.
OpenVPN是一个灵活，可靠和安全的虚拟专用网络（VPN）解决方案。它属于SSL/TLS VPN堆栈家族（不同于IPSec VPN）。本章将介绍如何安装和配置OpenVPN以创建VPN。 

## Install the server 安装服务器 

To install OpenVPN, run the following command in your terminal:
要安装OpenVPN，请在终端中运行以下命令： 

```bash
sudo apt install openvpn easy-rsa
```

## Set up the Public Key Infrastructure (PKI) 建立公钥基础设施（PKI） 

If you want more than just pre-shared keys, OpenVPN makes it easy to set  up a Public Key Infrastructure (PKI) to use SSL/TLS certificates for  authentication and key exchange between the VPN server and clients.
如果您想要的不仅仅是预共享密钥，OpenVPN可以轻松设置公钥基础设施（PKI），以使用SSL/TLS证书进行VPN服务器和客户端之间的身份验证和密钥交换。 

OpenVPN can be used in a routed or bridged VPN mode and can be configured to  use either UDP or TCP. The port number can be configured as well, but  port 1194 is the official one; this single port is used for all  communication. [VPN client implementations](https://ubuntu.com/server/docs/openvpn-client-implementations) are available for almost anything including all Linux distributions, macOS, Windows and OpenWRT-based WLAN routers.
OpenVPN可用于路由或桥接VPN模式，并可配置为使用UDP或TCP。端口号也可以配置，但端口1194是官方端口;这个端口用于所有通信。VPN客户端实施可用于几乎任何东西，包括所有Linux发行版、macOS、Windows和基于OpenWRT的WLAN路由器。

The first step in building an OpenVPN configuration is to establish a PKI, which consists of:
构建OpenVPN配置的第一步是建立PKI，其中包括： 

- A separate certificate (also known as a public key) and private key for the server and each client
  服务器和每个客户端的单独证书（也称为公钥）和私钥 
- A primary Certificate Authority (CA) certificate and key, used to sign the server and client certificates
  主证书颁发机构（CA）证书和密钥，用于对服务器和客户端证书进行签名 

OpenVPN supports bi-directional authentication based on certificates, meaning  that the client must authenticate the server certificate and the server  must authenticate the client certificate before mutual trust is  established.
OpenVPN支持基于证书的双向身份验证，这意味着在建立相互信任之前，客户端必须验证服务器证书，服务器必须验证客户端证书。 

Both the server and the client will authenticate each other by first  verifying that the presented certificate was signed by the primary  Certificate Authority (CA), and then by testing information in the  now-authenticated certificate header, such as the certificate common  name or certificate type (client or server).
服务器和客户端将通过以下方式相互验证：首先验证所提供的证书是否由主证书颁发机构（CA）签名，然后测试现在已验证的证书标头中的信息，例如证书通用名或证书类型（客户端或服务器）。 

### Set up the Certificate Authority 设置证书颁发机构 

To set up your own CA, and generate certificates and keys for an OpenVPN server with multiple clients, first copy the `easy-rsa` directory to `/etc/openvpn`. This will ensure that any changes to the scripts will not be lost when the package is updated. From a terminal, run:
要设置自己的CA，并为具有多个客户端的OpenVPN服务器生成证书和密钥，请首先将 `easy-rsa` 目录复制到 `/etc/openvpn` 。这将确保在更新软件包时不会丢失对脚本的任何更改。从终端运行：

```bash
sudo make-cadir /etc/openvpn/easy-rsa
```

> **Note**: 注意事项：
>  You can alternatively edit `/etc/openvpn/easy-rsa/vars` directly, adjusting it to your needs.
>  您也可以直接编辑 `/etc/openvpn/easy-rsa/vars` ，根据您的需要进行调整。

As a `root` user, change to the newly created directory `/etc/openvpn/easy-rsa` and run:
作为 `root` 用户，切换到新创建的目录 `/etc/openvpn/easy-rsa` 并运行：

```bash
./easyrsa init-pki
./easyrsa build-ca
```

The PEM passphrase set when creating the CA will be asked for every time  you need to encrypt the output of a command (such as a private key). The encryption here is important, to avoid printing any private key in  plain text.
每次需要加密命令输出（如私钥）时，都会询问创建CA时设置的PEM密码。这里的加密很重要，以避免以纯文本形式打印任何私钥。 

### Create server keys and certificates 创建服务器密钥和证书 

Next, we will generate a key pair for the server:
接下来，我们将为服务器生成一个密钥对： 

```bash
./easyrsa gen-req myservername nopass
```

Diffie Hellman parameters must be generated for the OpenVPN server. The following command will place them in `pki/dh.pem`:
必须为OpenVPN服务器生成Diffie Hellman参数。下面的命令将把它们放在 `pki/dh.pem` 中：

```bash
./easyrsa gen-dh
```

And finally, create a certificate for the server:
最后，为服务器创建一个证书： 

```bash
./easyrsa sign-req server myservername
```

All certificates and keys have been generated in subdirectories. Common practice is to copy them to `/etc/openvpn/`:
所有证书和密钥都已在子目录中生成。通常的做法是将它们复制到 `/etc/openvpn/` ：

```bash
cp pki/dh.pem pki/ca.crt pki/issued/myservername.crt pki/private/myservername.key /etc/openvpn/
```

### Create client certificates 创建客户端证书 

The VPN client will also need a certificate to authenticate itself to the  server. Usually you create a different certificate for each client.
VPN客户端还需要一个证书来向服务器验证自己。通常，您会为每个客户端创建不同的证书。 

This can be done either on the server (as with the keys and certificates  above) and then securely distributed to the client, or the client can  generate and submit a request that is sent and signed by the server.
这可以在服务器上完成（与上面的密钥和证书一样），然后安全地分发给客户端，或者客户端可以生成并提交由服务器发送和签名的请求。 

To create the certificate, enter the following in a terminal as a root user:
要创建证书，请以root用户身份在终端中输入以下内容： 

```bash
./easyrsa gen-req myclient1 nopass
./easyrsa sign-req client myclient1
```

If the first command above was done on a remote system, then copy the `.req` file to the CA server. From there, you can import it via `easyrsa import-req /incoming/myclient1.req myclient1`. Then you can go on with the second `sign-eq` command.
如果上面的第一个命令是在远程系统上执行的，则将 `.req` 文件复制到CA服务器。你可以通过 `easyrsa import-req /incoming/myclient1.req myclient1` 导入它。然后你可以继续使用第二个 `sign-eq` 命令。

After this is done, in both cases you will need to copy the following files to the client using a secure method:
完成此操作后，在这两种情况下，您都需要使用安全方法将以下文件复制到客户端： 

- `pki/ca.crt`
- `pki/issued/myclient1.crt`

Since the client certificates and keys are only required on the client machine, you can remove them from the server.
由于客户端证书和密钥仅在客户端计算机上需要，因此您可以将它们从服务器上删除。 

## Simple server configuration 简单的服务器配置 

Included with your OpenVPN installation are these (and many more) sample configuration files:
OpenVPN安装中包含以下（以及更多）示例配置文件： 

```bash
root@server:/# ls -l /usr/share/doc/openvpn/examples/sample-config-files/
total 68
-rw-r--r-- 1 root root 3427 2011-07-04 15:09 client.conf
-rw-r--r-- 1 root root 4141 2011-07-04 15:09 server.conf.gz
```

Start by copying and unpacking `server.conf.gz` to `/etc/openvpn/server.conf`:
首先复制并解包 `server.conf.gz` 到 `/etc/openvpn/server.conf` ：

```bash
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/myserver.conf.gz
sudo gzip -d /etc/openvpn/myserver.conf.gz
```

Edit `/etc/openvpn/myserver.conf` to make sure the following lines are pointing to the certificates and keys you created in the section above.
编辑 `/etc/openvpn/myserver.conf` 以确保以下行指向您在上一节中创建的证书和密钥。

```auto
ca ca.crt
cert myservername.crt
key myservername.key
dh dh2048.pem
```

Complete this set with a TLS Authentication (TA) key in `etc/openvpn` for `tls-auth` like this:
在 `etc/openvpn` 中为 `tls-auth` 使用TLS身份验证（TA）密钥完成此设置，如下所示：

```bash
sudo openvpn --genkey --secret ta.key
```

Edit `/etc/sysctl.conf` and uncomment the following line to enable IP forwarding:
编辑 `/etc/sysctl.conf` 并取消注释以下行以启用IP转发：

```auto
#net.ipv4.ip_forward=1
```

Then reload `sysctl`: 然后重新加载 `sysctl` ：

```bash
sudo sysctl -p /etc/sysctl.conf
```

This is the minimum you need to configure to get a working OpenVPN server. You can use all the default settings in the sample `server.conf` file. Now you can start the server.
这是您需要配置以获得工作OpenVPN服务器的最低要求。您可以使用示例 `server.conf` 文件中的所有默认设置。现在你可以启动服务器了。

```bash
$ sudo systemctl start openvpn@myserver
```

> **Note**: 注意事项：
>  Be aware that the `systemctl start openvpn` is **not** starting the `openvpn` you just defined.
>  请注意， `systemctl start openvpn` 不会启动您刚刚定义的 `openvpn` 。
>  OpenVPN uses templated `systemd` jobs, `openvpn@CONFIGFILENAME`. So if, for example, your configuration file is `myserver.conf` your service is called `openvpn@myserver`. You can run all kinds of service and `systemctl` commands like `start/stop/enable/disable/preset` against a templated service like `openvpn@server`.
>  OpenVPN使用模板化的 `systemd` 作业， `openvpn@CONFIGFILENAME` 。例如，如果您的配置文件是 `myserver.conf` ，则服务称为 `openvpn@myserver` 。您可以针对模板化的服务（如 `openvpn@server` ）运行所有类型的service和 `systemctl` 命令（如 `start/stop/enable/disable/preset` ）。

You will find logging and error messages in the journal. For example, if you started a [templated service](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) `openvpn@server` you can filter for this particular message source with:
您将在日志中找到日志和错误消息。例如，如果您启动了模板化服务 `openvpn@server` ，则可以使用以下命令筛选此特定消息源：

```bash
sudo journalctl -u openvpn@myserver -xe
```

The same templated approach works for all of `systemctl`:
相同的模板化方法适用于所有 `systemctl` ：

```bash
$ sudo systemctl status openvpn@myserver
openvpn@myserver.service - OpenVPN connection to myserver
   Loaded: loaded (/lib/systemd/system/openvpn@.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2019-10-24 10:59:25 UTC; 10s ago
     Docs: man:openvpn(8)
           https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage
           https://community.openvpn.net/openvpn/wiki/HOWTO
 Main PID: 4138 (openvpn)
   Status: "Initialization Sequence Completed"
    Tasks: 1 (limit: 533)
   Memory: 1.0M
   CGroup: /system.slice/system-openvpn.slice/openvpn@myserver.service
           └─4138 /usr/sbin/openvpn --daemon ovpn-myserver --status /run/openvpn/myserver.status 10 --cd /etc/openvpn --script-security 2 --config /etc/openvpn/myserver.conf --writepid /run/

Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: /sbin/ip addr add dev tun0 local 10.8.0.1 peer 10.8.0.2
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: /sbin/ip route add 10.8.0.0/24 via 10.8.0.2
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: Could not determine IPv4/IPv6 protocol. Using AF_INET
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: Socket Buffers: R=[212992->212992] S=[212992->212992]
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: UDPv4 link local (bound): [AF_INET][undef]:1194
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: UDPv4 link remote: [AF_UNSPEC]
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: MULTI: multi_init called, r=256 v=256
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: IFCONFIG POOL: base=10.8.0.4 size=62, ipv6=0
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: IFCONFIG POOL LIST
Oct 24 10:59:26 eoan-vpn-server ovpn-myserver[4138]: Initialization Sequence Completed
```

You can enable/disable various OpenVPN services on one system, but you  could also let Ubuntu do it for you. There is a config for `AUTOSTART `in `/etc/default/openvpn`. Allowed values are “all”, “none” or a space-separated list of names of  the VPNs. If empty, “all” is assumed. The VPN name refers to the VPN  configuration file name, i.e., `home` would be `/etc/openvpn/home.conf`.
您可以在一个系统上启用/禁用各种OpenVPN服务，但您也可以让Ubuntu为您做这件事。 `/etc/default/openvpn` 中有 `AUTOSTART ` 的配置。允许的值为“all”、“none”或以空格分隔的VPN名称列表。如果为空，则假定为“all”。VPN名称是指VPN配置文件名，即， `home` 是 `/etc/openvpn/home.conf` 。

If you’re running `systemd`, changing this variable requires running `systemctl daemon-reload` followed by a restart of the `openvpn` service (if you removed entries you may have to stop those manually).
如果您正在运行 `systemd` ，则更改此变量需要运行 `systemctl daemon-reload` ，然后重新启动 `openvpn` 服务（如果您删除了条目，则可能需要手动停止这些条目）。

After `systemctl daemon-reload`, a restart of the “generic” OpenVPN will restart all dependent services that the generator in `/lib/systemd/system-generators/openvpn-generator` created for your `conf` files when you called `daemon-reload`.
在 `systemctl daemon-reload` 之后，重新启动“通用”OpenVPN将重新启动所有依赖服务，这些服务是在您调用 `daemon-reload` 时， `/lib/systemd/system-generators/openvpn-generator` 中的生成器为您的 `conf` 文件创建的。

Now, check if OpenVPN created a `tun0` interface:
现在，检查OpenVPN是否创建了 `tun0` 接口：

```bash
root@server:/etc/openvpn# ip addr show dev tun0
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    link/none 
    inet 10.8.0.1 peer 10.8.0.2/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::b5ac:7829:f31e:32c5/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

## Simple client configuration 简单的客户端配置 

There are various different OpenVPN client implementations – both with and without GUIs. You can read more about clients in [our page on OpenVPN Clients](https://ubuntu.com/server/docs/openvpn-client-implementations). For now, we use the command-line/service-based OpenVPN client for  Ubuntu, which is part of the same package as the server. So you must  install the `openvpn` package again on the client machine:
有各种不同的OpenVPN客户端实现-有和没有GUI。您可以在我们的OpenVPN客户端页面中阅读更多有关客户端的信息。目前，我们使用Ubuntu的基于命令行/服务的OpenVPN客户端，它与服务器属于同一个包。因此，您必须在客户端计算机上再次安装 `openvpn` 包：

```bash
sudo apt install openvpn
```

This time, copy the `client.conf` sample config file to `/etc/openvpn/`:
这一次，将 `client.conf` 示例配置文件复制到 `/etc/openvpn/` ：

```bash
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/
```

Copy the following client keys and certificate files you created in the section above to e.g. `/etc/openvpn/` and edit `/etc/openvpn/client.conf` to make sure the following lines are pointing to those files. If you have the files in `/etc/openvpn/` you can omit the path:
将您在上一节中创建的以下客户端密钥和证书文件复制到例如 `/etc/openvpn/` ，并编辑 `/etc/openvpn/client.conf` 以确保以下行指向这些文件。如果你有文件在 `/etc/openvpn/` 中，你可以省略路径：

```plaintext
ca ca.crt
cert myclient1.crt
key myclient1.key
tls-auth ta.key 1
```

And you have to specify the OpenVPN server name or address. Make sure the keyword **`client`** is in the config file, since that’s what enables client mode.
您必须指定OpenVPN服务器名称或地址。确保关键字 `client` 在配置文件中，因为这是启用客户端模式的关键字。

```plaintext
client
remote vpnserver.example.com 1194
```

Now start the OpenVPN client with the same templated mechanism:
现在，使用相同的模板机制启动OpenVPN客户端： 

```bash
$ sudo systemctl start openvpn@client
```

You can check the status as you did on the server:
您可以像在服务器上一样检查状态： 

```bash
$ sudo systemctl status openvpn@client
openvpn@client.service - OpenVPN connection to client
   Loaded: loaded (/lib/systemd/system/openvpn@.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2019-10-24 11:42:35 UTC; 6s ago
     Docs: man:openvpn(8)
           https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage
           https://community.openvpn.net/openvpn/wiki/HOWTO
 Main PID: 3616 (openvpn)
   Status: "Initialization Sequence Completed"
    Tasks: 1 (limit: 533)
   Memory: 1.3M
   CGroup: /system.slice/system-openvpn.slice/openvpn@client.service
           └─3616 /usr/sbin/openvpn --daemon ovpn-client --status /run/openvpn/client.status 10 --cd /etc/openvpn --script-security 2 --config /etc/openvpn/client.conf --writepid /run/openvp

Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: ROUTE_GATEWAY 192.168.122.1/255.255.255.0 IFACE=ens3 HWADDR=52:54:00:3c:5a:88
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: TUN/TAP device tun0 opened
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: TUN/TAP TX queue length set to 100
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: /sbin/ip link set dev tun0 up mtu 1500
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: /sbin/ip addr add dev tun0 local 10.8.0.6 peer 10.8.0.5
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: /sbin/ip route add 10.8.0.1/32 via 10.8.0.5
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Oct 24 11:42:36 eoan-vpn-client ovpn-client[3616]: Initialization Sequence Completed
```

On the server log, an incoming connection looks like the following (you  can see client name and source address as well as success/failure  messages):
在服务器日志中，传入连接如下所示（您可以看到客户端名称和源地址以及成功/失败消息）： 

```auto
ovpn-myserver[4818]: 192.168.122.114:55738 TLS: Initial packet from [AF_INET]192.168.122.114:55738, sid=5e943ab8 40ab9fed
ovpn-myserver[4818]: 192.168.122.114:55738 VERIFY OK: depth=1, CN=Easy-RSA CA
ovpn-myserver[4818]: 192.168.122.114:55738 VERIFY OK: depth=0, CN=myclient1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_VER=2.4.7
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_PLAT=linux
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_PROTO=2
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_NCP=2
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_LZ4=1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_LZ4v2=1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_LZO=1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_COMP_STUB=1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_COMP_STUBv2=1
ovpn-myserver[4818]: 192.168.122.114:55738 peer info: IV_TCPNL=1
ovpn-myserver[4818]: 192.168.122.114:55738 Control Channel: TLSv1.3, cipher TLSv1.3 TLS_AES_256_GCM_SHA384, 2048 bit RSA
ovpn-myserver[4818]: 192.168.122.114:55738 [myclient1] Peer Connection Initiated with [AF_INET]192.168.122.114:55738
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 MULTI_sva: pool returned IPv4=10.8.0.6, IPv6=(Not enabled)
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 MULTI: Learn: 10.8.0.6 -> myclient1/192.168.122.114:55738
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 MULTI: primary virtual IP for myclient1/192.168.122.114:55738: 10.8.0.6
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 PUSH: Received control message: 'PUSH_REQUEST'
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 SENT CONTROL [myclient1]: 'PUSH_REPLY,route 10.8.0.1,topology net30,ping 10,ping-restart 120,ifconfig 10.8.0.6 10.8.0.5,peer-id 0,cipher AES-256-GCM' (status=1)
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 Data Channel: using negotiated cipher 'AES-256-GCM'
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
ovpn-myserver[4818]: myclient1/192.168.122.114:55738 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
```

And you can check on the client if it created a `tun0` interface:
你可以检查客户端是否创建了一个 `tun0` 接口：

```bash
$ ip addr show dev tun0
4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    link/none 
    inet 10.8.0.6 peer 10.8.0.5/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::5a94:ae12:8901:5a75/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

Check if you can ping the OpenVPN server:
检查是否可以ping OpenVPN服务器： 

```bash
root@client:/etc/openvpn# ping 10.8.0.1
PING 10.8.0.1 (10.8.0.1) 56(84) bytes of data.
64 bytes from 10.8.0.1: icmp_req=1 ttl=64 time=0.920 ms
```

> **Note**: 注意事项：
>  The OpenVPN server always uses the first usable IP address in the client network and only that IP is pingable. E.g., if you configured a `/24` for the client network mask, the `.1` address will be used. The P-t-P address you see in the `ip addr` output above does not usually answer ping requests.
>  OpenVPN服务器始终使用客户端网络中的第一个可用IP地址，并且只有该IP是可ping的。例如，在一个示例中，如果为客户端网络掩码配置了 `/24` ，则将使用 `.1` 地址。您在上面的 `ip addr` 输出中看到的P—t—P地址通常不会响应ping请求。

Check out your routes:
查看您的路线： 

```bash
$ ip route 
default via 192.168.122.1 dev ens3 proto dhcp src 192.168.122.114 metric 100 
10.8.0.1 via 10.8.0.5 dev tun0 
10.8.0.5 dev tun0 proto kernel scope link src 10.8.0.6 
192.168.122.0/24 dev ens3 proto kernel scope link src 192.168.122.114 
192.168.122.1 dev ens3 proto dhcp scope link src 192.168.122.114 metric 100
```

## First troubleshooting 首次故障排除 

If the above didn’t work for you, check the following:
如果以上方法对您不起作用，请检查以下内容： 

- Check your `journal -xe`. 检查你的 `journal -xe` 。
- Check that you have specified the key filenames correctly in the client and server `conf` files.
  检查您是否在客户端和服务器 `conf` 文件中正确指定了密钥文件名。
- Can the client connect to the server machine? Maybe a firewall is blocking access? Check the journal on the server.
  客户端可以连接到服务器吗？也许是防火墙阻止了访问？检查服务器上的日志。 
- Client and server must use same protocol and port, e.g. UDP port 1194, see `port` and `proto` config options.
  客户端和服务器必须使用相同的协议和端口，例如UDP端口1194，请参阅 `port` 和 `proto` 配置选项。
- Client and server must use the same compression configuration, see `comp-lzo` config option.
  客户端和服务器必须使用相同的压缩配置，请参阅 `comp-lzo` 配置选项。
- Client and server must use same config regarding bridged vs. routed mode, see `server vs server-bridge` config option
  客户端和服务器必须使用相同的配置，关于桥接模式和路由模式，请参阅 `server vs server-bridge` 配置选项

## Advanced configuration 高级配置 

### Advanced routed VPN configuration on server 服务器上的高级路由VPN配置 

The above is a very simple working VPN. The client can access services on  the VPN server machine through an encrypted tunnel. If you want to reach more servers or anything in other networks, push some routes to the  clients. E.g. if your company’s network can be summarised to the network `192.168.0.0/16`, you could push this route to the clients. But you will also have to  change the routing for the way back – your servers need to know a route  to the VPN client-network.
上面是一个非常简单的VPN。客户端可以通过加密的隧道访问VPN服务器上的服务。如果你想到达更多的服务器或其他网络中的任何东西，把一些路由推到客户端。例如，如果您公司的网络可以总结为网络 `192.168.0.0/16` ，您可以将此路由推送到客户端。但是，您还必须更改返回的路由—您的服务器需要知道到VPN客户端网络的路由。

The example config files that we have been using in this guide are full of  these advanced options in the form of a comment and a disabled  configuration line as an example.
我们在本指南中使用的示例配置文件以注释和禁用配置行的形式充满了这些高级选项。 

> **Note**: 注意事项：
>  Read the OpenVPN [hardening security guide](http://openvpn.net/index.php/open-source/documentation/howto.html#security) for further security advice.
>  阅读OpenVPN强化安全指南以获取更多安全建议。

### Advanced bridged VPN configuration on server 服务器上的高级桥接VPN配置 

OpenVPN can be set up for either a routed or a bridged VPN mode. Sometimes this is also referred to as OSI layer-2 versus layer-3 VPN. In a bridged VPN all layer-2 frames – e.g. all Ethernet frames – are sent to the VPN  partners and in a routed VPN only layer-3 packets are sent to VPN  partners. In bridged mode, all traffic including traffic which was  traditionally LAN-local (like local network broadcasts, DHCP requests,  ARP requests etc) are sent to VPN partners, whereas in routed mode this  would be filtered.
OpenVPN可以设置为路由或桥接VPN模式。有时这也被称为OSI第2层与第3层VPN。在桥接VPN中，所有第2层帧（例如，所有以太网帧）被发送到VPN伙伴，并且在路由VPN中，仅第3层分组被发送到VPN伙伴。在桥接模式下，所有流量（包括传统LAN本地流量（如本地网络广播，DHCP请求，阿普请求等））都将发送到VPN合作伙伴，而在路由模式下，这将被过滤。 

#### Prepare interface config for bridging on server 为服务器上的桥接准备接口配置 

First, use Netplan to configure a bridge device using the desired Ethernet device:
首先，使用Netplan配置使用所需以太网设备的网桥设备： 

```bash
$ cat /etc/netplan/01-netcfg.yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s31f6:
            dhcp4: no
    bridges:
        br0:
            interfaces: [enp0s31f6]
            dhcp4: no
            addresses: [10.0.1.100/24]
            gateway4: 10.0.1.1
            nameservers:
                addresses: [10.0.1.1]
```

Static IP addressing is highly suggested. DHCP addressing can also work, but  you will still have to encode a static address in the OpenVPN  configuration file.
强烈建议使用静态IP寻址。DHCP寻址也可以工作，但您仍然需要在OpenVPN配置文件中编码静态地址。 

The next step on the server is to configure the Ethernet device for promiscuous mode on boot. To do this, ensure the `networkd-dispatcher` package is installed and create the following configuration script:
服务器上的下一步是在靴子时将以太网设备配置为混杂模式。为此，请确保安装了 `networkd-dispatcher` 包，并创建以下配置脚本：

```bash
sudo apt update
sudo apt install networkd-dispatcher
sudo touch /usr/lib/networkd-dispatcher/dormant.d/promisc_bridge
sudo chmod +x /usr/lib/networkd-dispatcher/dormant.d/promisc_bridge
```

Then add the following contents:
然后添加以下内容： 

```sh
#!/bin/sh
set -e
if [ "$IFACE" = br0 ]; then
    # no networkd-dispatcher event for 'carrier' on the physical interface
    ip link set enp0s31f6 up promisc on
fi
```

#### Prepare server config for bridging 为桥接准备服务器配置 

Edit `/etc/openvpn/server.conf` to use `tap` rather than `tun` and set the server to use the `server-bridge` directive:
编辑 `/etc/openvpn/server.conf` 以使用 `tap` 而不是 `tun` ，并将服务器设置为使用 `server-bridge` 指令：

```auto
;dev tun
dev tap
;server 10.8.0.0 255.255.255.0
server-bridge 10.0.0.4 255.255.255.0 10.0.0.128 10.0.0.254
```

After configuring the server, restart OpenVPN by entering:
配置服务器后，输入以下命令重新启动OpenVPN： 

```bash
sudo systemctl restart openvpn@myserver
```

#### Prepare client config for bridging 为桥接准备客户端配置 

The only difference on the client side for bridged mode to what was outlined above is that you need to edit `/etc/openvpn/client.conf` and set `tap` mode:
桥接模式在客户端与上面概述的唯一区别是，您需要编辑 `/etc/openvpn/client.conf` 并设置 `tap` 模式：

```auto
dev tap
;dev tun
```

Finally, restart OpenVPN:
最后，重启OpenVPN： 

```bash
sudo systemctl restart openvpn@client
```

You should now be able to connect to the fully remote LAN through the VPN.
您现在应该能够通过VPN连接到完全远程的LAN。 

## Further reading 进一步阅读 

- [EasyRSA](https://github.com/OpenVPN/easy-rsa/blob/master/README.quickstart.md)
- [OpenVPN quick start guide
   OpenVPN快速入门指南](https://openvpn.net/quick-start-guide/)
- Snap’ed version of OpenVPN [easy-openvpn](https://snapcraft.io/easy-openvpn-server)
  Snap'艾德版本的OpenVPN easy-openvpn
- Debian’s [OpenVPN Guide](https://wiki.debian.org/OpenVPN) Debian的OpenVPN指南

------