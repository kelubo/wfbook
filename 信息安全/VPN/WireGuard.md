# WireGuard VPN peer-to-site WireGuard VPN点对点 

To help understand the WireGuard concepts, we will show some practical setups that hopefully match many scenarios out there.
为了帮助理解WireGuard的概念，我们将展示一些实际的设置，希望能匹配许多场景。 

This is probably the most common setup for a VPN: connecting a single system to a remote site, and getting access to the remote network “as if you  were there”.
这可能是VPN最常见的设置：将单个系统连接到远程站点，并“就像您在那里一样”访问远程网络。 

Where to place the remote WireGuard endpoint in the network will vary a lot  depending on the topology. It can be in a firewall box, the router  itself, or some random system in the middle of the network.
将远程WireGuard端点放置在网络中的位置会因拓扑而异。它可以在防火墙盒中，路由器本身，或者网络中间的一些随机系统中。 

Here we will cover a simpler case more resembling what a home network could be like:
在这里，我们将介绍一个更类似于家庭网络的简单情况： 

```auto
               public internet
     
                xxxxxx      ppp0 ┌────────┐
 ┌────┐         xx   xxxx      ──┤ router │
 │    ├─ppp0  xxx      xx        └───┬────┘
 │    │       xx        x            │         home 10.10.10.0/24
 │    │        xxx    xxx            └───┬─────────┬─────────┐
 └────┘          xxxxx                   │         │         │
                                       ┌─┴─┐     ┌─┴─┐     ┌─┴─┐
                                       │   │     │   │     │   │
                                       │pi4│     │NAS│     │...│
                                       │   │     │   │     │   │
                                       └───┘     └───┘     └───┘
```

This diagram represents a typical simple home network setup. You have a  router/modem, usually provided by the ISP (Internet Service Provider),  and some internal devices like a Raspberry PI perhaps, a NAS (Network  Attached Storage), and some other device.
此图表示一个典型的简单家庭网络设置。您有一个路由器/调制解调器，通常由ISP（互联网服务提供商）提供，以及一些内部设备，如Raspberry PI，NAS（网络附加存储）和其他设备。 

There are basically two approaches that can be taken here: install WireGuard [on the router](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site-on-router), or on [another system in the home network](https://ubuntu.com/server/docs/wireguard-on-an-internal-system).
这里基本上有两种方法可以采用：在路由器上安装WireGuard，或者在家庭网络中的另一个系统上安装WireGuard。

Note that in this scenario the “fixed” side, the home network, normally won’t have a WireGuard `Endpoint` configured, as the peer is typically “on the road” and will have a dynamic IP address.
请注意，在这种情况下，“固定”端（家庭网络）通常不会配置WireGuard `Endpoint` ，因为对等端通常“在路上”，并且将具有动态IP地址。

------

# peer-to-site (on router) WireGuard VPN点对点（在路由器上） 

In this diagram, we are depicting a home network with some devices and a router where we can install WireGuard.
在此图中，我们描述了一个家庭网络，其中包含一些设备和一个路由器，我们可以在其中安装WireGuard。 

```auto
                       public internet              ┌─── wg0 10.10.11.1/24
10.10.11.2/24                                       │        VPN network
        home0│            xxxxxx       ppp0 ┌───────┴┐
           ┌─┴──┐         xx   xxxxx  ──────┤ router │
           │    ├─wlan0  xx       xx        └───┬────┘    home network, .home domain
           │    │       xx        x             │.1       10.10.10.0/24
           │    │        xxx    xxx             └───┬─────────┬─────────┐
           └────┘          xxxxxx                   │         │         │
Laptop in                                         ┌─┴─┐     ┌─┴─┐     ┌─┴─┐
Coffee shop                                       │   │     │   │     │   │
                                                  │pi4│     │NAS│     │...│
                                                  │   │     │   │     │   │
                                                  └───┘     └───┘     └───┘
```

Of course, this setup is only possible if you can install software on the  router. Most of the time, when it’s provided by your ISP, you can’t. But some ISPs allow their device to be put into a bridge mode, in which  case you can use your own device (a computer, a Raspberry PI, or  something else) as the routing device.
当然，这种设置只有在您可以在路由器上安装软件的情况下才可能。大多数情况下，当它由您的ISP提供时，您不能。但是有些ISP允许他们的设备进入桥接模式，在这种情况下，您可以使用自己的设备（计算机，Raspberry PI或其他设备）作为路由设备。 

Since the router is the default gateway of the network already, this means  you can create a whole new network for your VPN users. You also won’t  have to create any (D)NAT rules since the router is directly reachable  from the Internet.
由于路由器已经是网络的默认网关，这意味着您可以为VPN用户创建一个全新的网络。您也不必创建任何（D）NAT规则，因为路由器可以从Internet直接访问。 

Let’s define some addresses, networks, and terms used in this guide:
让我们定义本指南中使用的一些地址、网络和术语： 

- **laptop in coffee shop**: just your normal user at a coffee shop, using the provided Wi-Fi access to connect to their home network. This will be one of our **peers** in the VPN setup.
  咖啡店中的笔记本电脑：只是咖啡店中的普通用户，使用提供的Wi-Fi接入连接到家庭网络。这将是我们在VPN设置中的同行之一。
- **`home0`**: this will be the WireGuard interface on the laptop. It’s called `home0` to convey that it is used to connect to the **home** network.
   `home0` ：这将是笔记本电脑上的WireGuard接口。它被称为 `home0` ，以表示它用于连接到家庭网络。
- **router**: the existing router at the home network. It has a public interface `ppp0` that has a routable but dynamic IPv4 address (not CGNAT), and an internal interface at `10.10.10.1/24` which is the default gateway for the home network.
  路由器：家庭网络中现有的路由器。它有一个公共接口 `ppp0` ，它有一个可路由但动态的IPv4地址（不是CGNAT），以及一个内部接口 `10.10.10.1/24` ，它是家庭网络的默认网关。
- **home network**: the existing home network (`10.10.10.0/24` in this example), with existing devices that the user wishes to access remotely over the WireGuard VPN.
  家庭网络：现有的家庭网络（本例中为 `10.10.10.0/24` ），以及用户希望通过WireGuard VPN远程访问的现有设备。
- **`10.10.11.0/24`**: the WireGuard VPN network. This is a whole new network that was created just for the VPN users.
   `10.10.11.0/24` ：WireGuard VPN网络。这是一个专为VPN用户创建的全新网络。
- **`wg0`** on the **router**: this is the WireGuard interface that we will bring up on the router, at the `10.10.11.1/24` address. It is the gateway for the `10.10.11.0/24` VPN network.
  路由器上的 `wg0` ：这是我们将在路由器上启用的WireGuard接口，位于 `10.10.11.1/24` 地址。它是 `10.10.11.0/24` VPN网络的网关。

With this topology, if, say, the NAS wants to send traffic to `10.10.11.2/24`, it will send it to the default gateway (since the NAS has no specific route to `10.10.11.0/24`), and the gateway will know how to send it to `10.10.11.2/24` because it has the `wg0` interface on that network.
在此拓扑中，如果NAS想要将流量发送到 `10.10.11.2/24` ，它会将其发送到默认网关（因为NAS没有到 `10.10.11.0/24` 的特定路由），并且网关将知道如何将其发送到 `10.10.11.2/24` ，因为它在该网络上具有 `wg0` 接口。

## Configuration 配置 

First, we need to create keys for the peers of this setup. We need one pair of keys for the laptop, and another for the home router:
首先，我们需要为此设置的对等体创建密钥。我们需要一对笔记本电脑的钥匙，另一对家庭路由器的钥匙： 

```bash
$ umask 077
$ wg genkey > laptop-private.key
$ wg pubkey < laptop-private.key > laptop-public.key
$ wg genkey > router-private.key
$ wg pubkey < router-private.key > router-public.key
```

Let’s create the router `wg0` interface configuration file. The file will be `/etc/wireguard/wg0.conf` and have these contents:
让我们创建路由器 `wg0` 接口配置文件。该文件将是 `/etc/wireguard/wg0.conf` ，并具有以下内容：

```plaintext
[Interface]
PrivateKey = <contents-of-router-private.key>
ListenPort = 51000
Address = 10.10.11.1/24

[Peer]
PublicKey = <contents-of-laptop-public.key>
AllowedIPs = 10.10.11.2
```

There is no `Endpoint` configured for the laptop peer, because we don’t know what IP address  it will have beforehand, nor will that IP address be always the same.  This laptop could be connecting from a coffee shop’s free Wi-Fi, an  airport lounge, or a friend’s house.
没有为笔记本电脑对等体配置 `Endpoint` ，因为我们事先不知道它将拥有什么IP地址，也不知道该IP地址始终相同。这台笔记本电脑可以从咖啡店的免费Wi-Fi、机场休息室或朋友家连接。

Not having an endpoint here also means that the home network side will never be able to *initiate*  the VPN connection. It will sit and wait, and can only *respond* to VPN handshake requests, at which time it will learn the endpoint  from the peer and use that until it changes (i.e. when the peer  reconnects from a different site) or it times out.
这里没有端点也意味着家庭网络侧将永远无法发起VPN连接。它将等待，并且只能响应VPN握手请求，此时它将从对等端学习端点并使用它，直到它发生变化（即对等端从不同站点重新连接时）或超时。

> **Important**: 重要提示：
>  This configuration file contains a secret: **PrivateKey**.
>  此配置文件包含一个秘密：PrivateKey。
>  Make sure to adjust its permissions accordingly, as follows:
>  请确保相应地调整其权限，如下所示：
>
> ```auto
> sudo chmod 0600 /etc/wireguard/wg0.conf
> sudo chown root: /etc/wireguard/wg0.conf
> ```

When activated, this will bring up a `wg0` interface with the address `10.10.11.1/24`, listening on port `51000/udp`, and add a route for the `10.10.11.0/24` network using that interface.
激活后，这将打开地址为 `10.10.11.1/24` 的 `wg0` 接口，侦听端口 `51000/udp` ，并使用该接口为 `10.10.11.0/24` 网络添加路由。

The `[Peer]` section is identifying a peer via its public key, and listing who can connect from that peer. This `AllowedIPs` setting has two meanings:
 `[Peer]` 部分通过其公钥识别对等体，并列出可以从该对等体连接的人。这个 `AllowedIPs` 设置有两个含义：

- When sending packets, the `AllowedIPs` list serves as a routing table, indicating that this peer’s public key should be used to encrypt the traffic.
  当发送数据包时， `AllowedIPs` 列表充当路由表，指示应该使用此对等方的公钥来加密流量。
- When receiving packets, `AllowedIPs` behaves like an access control list. After decryption, the traffic is only allowed if it matches the list.
  当接收数据包时， `AllowedIPs` 的行为类似于访问控制列表。解密后，只有与列表匹配的流量才被允许。

Finally, the `ListenPort` parameter specifies the **UDP** port on which WireGuard will listen for traffic. This port will have to be allowed in the firewall rules of the router. There is neither a  default nor a standard port for WireGuard, so you can pick any value you prefer.
最后， `ListenPort` 参数指定WireGuard将监听流量的UDP端口。路由器的防火墙规则必须允许此端口。WireGuard既没有默认端口，也没有标准端口，因此您可以选择您喜欢的任何值。

Now let’s create a similar configuration on the other peer, the laptop. Here the interface is called `home0`, so the configuration file is `/etc/wireguard/home0.conf`:
现在让我们在另一个对等体（笔记本电脑）上创建一个类似的配置。这里接口名为 `home0` ，所以配置文件为 `/etc/wireguard/home0.conf` ：

```auto
[Interface]
PrivateKey = <contents-of-laptop-private.key>
ListenPort = 51000
Address = 10.10.11.2/24

[Peer]
PublicKey = <contents-of-router-public.key>
Endpoint = <home-ppp0-IP-or-hostname>:51000
AllowedIPs = 10.10.11.0/24,10.10.10.0/24
```

> **Important**: 重要提示：
>  As before, this configuration file contains a secret: **PrivateKey**.
>  和前面一样，这个配置文件包含一个秘密：PrivateKey。
>  You need to adjust its permissions accordingly, as follows:
>  您需要相应地调整其权限，如下所示：
>
> ```auto
> sudo chmod 0600 /etc/wireguard/home0.conf
> sudo chown root: /etc/wireguard/home0.conf
> ```

We have given this laptop the `10.10.11.2/24` address. It could have been any valid address in the `10.10.11.0/24` network, as long as it doesn’t collide with an existing one, and is allowed in the router’s peer’s `AllowedIPs` list.
我们已经给这台笔记本电脑提供了 `10.10.11.2/24` 地址。它可以是 `10.10.11.0/24` 网络中的任何有效地址，只要它不与现有地址冲突，并且在路由器的对等体 `AllowedIPs` 列表中是允许的。

> **Note**: 注意事项：
>  You may have noticed by now that address allocation is manual, and not via something like DHCP. Keep tabs on it!
>  您可能已经注意到，地址分配是手动的，而不是通过DHCP之类的方式。密切关注！

In the `[Peer]` stanza for the laptop we have:
在笔记本电脑的 `[Peer]` 节中，我们有：

- The usual **`PublicKey`** item, which identifies the peer. Traffic to this peer will be encrypted using this public key.
  通常的 `PublicKey` 项，用于标识对等体。将使用此公钥对到此对等方的通信进行加密。
- **`Endpoint`**: this tells WireGuard where to actually send the encrypted traffic to.  Since in our scenario the laptop will be initiating connections, it has  to know the public IP address of the home router. If your ISP gave you a fixed IP address, great! You have nothing else to do. If, however, you  have a dynamic IP address (one that changes every time you establish a  new connection), then you will have to set up some sort of dynamic DNS  service. There are many such services available for free on the  Internet, but setting one up is out of scope for this guide.
   `Endpoint`  ：这告诉WireGuard将加密流量实际发送到何处。由于在我们的场景中，笔记本电脑将发起连接，因此它必须知道家庭路由器的公共IP地址。如果你的ISP给了你一个固定的IP地址，那就太好了！你没有别的事可做。但是，如果您有一个动态IP地址（每次建立新连接时都会更改），则必须设置某种动态DNS服务。互联网上有许多免费的此类服务，但设置一个超出了本指南的范围。
- In **`AllowedIPs`** we list our destinations. The VPN network `10.10.11.0/24` is listed so that we can ping `wg0` on the home router as well as other devices on the same VPN, and the actual home network, which is `10.10.10.0/24`.
  在 `AllowedIPs` 中，我们列出了目的地。列出了VPN网络 `10.10.11.0/24` ，以便我们可以ping家庭路由器上的 `wg0` 以及同一VPN上的其他设备，以及实际的家庭网络，即 `10.10.10.0/24` 。

If we had used `0.0.0.0/0` alone in `AllowedIPs`, then the VPN would become our default gateway, and all traffic would be sent to this peer. See [Default Gateway](https://ubuntu.com/server/docs/using-the-vpn-as-the-default-gateway) for details on that type of setup.
如果我们在 `AllowedIPs` 中单独使用 `0.0.0.0/0` ，那么VPN将成为我们的默认网关，所有流量都将发送到此对等端。有关该类型设置的详细信息，请参阅默认网关。

## Testing 测试 

With these configuration files in place, it’s time to bring the WireGuard interfaces up.
有了这些配置文件，就可以启动WireGuard接口了。 

On the home router, run:
在家用路由器上，运行： 

```bash
$ sudo wg-quick up wg0
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip -4 address add 10.10.11.1/24 dev wg0
[#] ip link set mtu 1378 up dev wg0
```

Verify you have a `wg0` interface with an address of `10.10.11.1/24`:
验证您有一个地址为 `10.10.11.1/24` 的 `wg0` 接口：

```bash
$ ip a show dev wg0
9: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1378 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none
    inet 10.10.11.1/24 scope global wg0
       valid_lft forever preferred_lft forever
```

Verify you have a `wg0` interface up with an address of `10.10.11.1/24`:
验证是否有地址为 `10.10.11.1/24` 的 `wg0` 接口：

```bash
$ ip a show dev wg0
9: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1378 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none
    inet 10.10.11.1/24 scope global wg0
       valid_lft forever preferred_lft forever
```

And a route to the `10.10.1.0/24` network via the `wg0` interface:
以及通过 `wg0` 接口到 `10.10.1.0/24` 网络的路由：

```bash
$ ip route | grep wg0
10.10.11.0/24 dev wg0 proto kernel scope link src 10.10.11.1
```

And `wg show` should show some status information, but no connected peer yet:
和 `wg show` 应该显示一些状态信息，但尚未连接对等体：

```bash
$ sudo wg show
interface: wg0
  public key: <router public key>
  private key: (hidden)
  listening port: 51000

peer: <laptop public key>
  allowed ips: 10.10.11.2/32
```

In particular, verify that the listed public keys match what you created (and expected!).
特别是，验证列出的公钥是否与您创建的（和预期的）公钥匹配。 

Before we start the interface on the other peer, it helps to leave the above `show` command running continuously, so we can see when there are changes:
在我们在另一个对等体上启动接口之前，让上面的 `show` 命令持续运行会有所帮助，这样我们就可以看到什么时候有变化：

```bash
$ sudo watch wg show
```

Now start the interface on the laptop:
现在启动笔记本电脑上的界面： 

```bash
$ sudo wg-quick up home0
[#] ip link add home0 type wireguard
[#] wg setconf home0 /dev/fd/63
[#] ip -4 address add 10.10.11.2/24 dev home0
[#] ip link set mtu 1420 up dev home0
[#] ip -4 route add 10.10.10.0/24 dev home0
```

Similarly, verify the interface’s IP and added routes:
同样，验证接口的IP和添加的路由： 

```bash
$ ip a show dev home0
24: home0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none
    inet 10.10.11.2/24 scope global home0
       valid_lft forever preferred_lft forever

$ ip route | grep home0
10.10.10.0/24 dev home0 scope link
10.10.11.0/24 dev home0 proto kernel scope link src 10.10.11.2
```

Up to this point, the `wg show` output on the home router probably didn’t change. That’s because we  haven’t sent any traffic to the home network, which didn’t trigger the  VPN yet. By default, WireGuard is very “quiet” on the network.
到目前为止，家用路由器上的 `wg show` 输出可能没有改变。这是因为我们还没有向家庭网络发送任何流量，这还没有触发VPN。默认情况下，WireGuard在网络上非常“安静”。

If we trigger some traffic, however, the VPN will “wake up”. Let’s ping the internal address of the home router a few times:
但是，如果我们触发了一些流量，VPN就会“醒来”。让我们ping家庭路由器的内部地址几次： 

```bash
$ ping -c 3 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=603 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=300 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=304 ms
```

Note how the first ping was slower. That’s because the VPN was “waking up”  and being established. Afterwards, with the tunnel already established,  the latency reduced.
注意第一次ping是如何慢的。这是因为VPN正在“醒来”并正在建立。之后，随着隧道的建立，延迟减少了。 

At the same time, the `wg show` output on the home router will have changed to something like this:
与此同时，家用路由器上的 `wg show` 输出将更改为如下内容：

```bash
$ sudo wg show
interface: wg0
  public key: <router public key>
  private key: (hidden)
  listening port: 51000

peer: <laptop public key>
  endpoint: <laptop public IP>:51000
  allowed ips: 10.10.11.2/32
  latest handshake: 1 minute, 8 seconds ago
  transfer: 564 B received, 476 B sent
```

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              [                   Previous 先前                    Peer-to-site 点对点                  ](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         [                   Next 下                    Peer-to-site (inside device)
点对点（设备内部）                  ](https://ubuntu.com/server/docs/wireguard-on-an-internal-system)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

# WireGuard on an internal system 内部系统上的WireGuard 

Sometimes it’s not possible to install WireGuard [on the home router itself](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site-on-router). Perhaps it’s a closed system to which you do not have access, or there  is no easy build for that architecture, or any of the other possible  reasons.
有时不可能在家庭路由器本身上安装WireGuard。也许这是一个封闭的系统，您无法访问它，或者没有简单的架构构建，或者任何其他可能的原因。

However, you do have a spare system inside your network that you could use. Here we are going to show one way to make this work. There are others, but  we believe this to be the least “involved” as it only requires a couple  of (very common) changes in the router itself: NAT port forwarding, and  DHCP range editing.
但是，您的网络中确实有一个可以使用的备用系统。在这里，我们将展示一种方法来实现这一点。还有其他的，但我们认为这是最不“涉及”的，因为它只需要路由器本身的几个（非常常见的）更改：NAT端口转发和DHCP范围编辑。 

To recap, our home network has the `10.10.10.0/24` address, and we want to connect to it from a remote location and be “inserted” into that network as if we were there:
概括一下，我们的家庭网络有 `10.10.10.0/24` 地址，我们希望从远程位置连接到它，并像我们在那里一样“插入”到该网络中：

```auto
                       public internet
10.10.10.3/24
        home0│            xxxxxx       ppp0 ┌────────┐
           ┌─┴──┐         xx   xxxxx  ──────┤ router │
           │    ├─ppp0  xxx       xx        └───┬────┘    home network, .home domain
           │    │       xx        x             │         10.10.10.0/24
           │    │        xxx    xxx             └───┬─────────┬─────────┐
           └────┘          xxxxxx                   │         │         │
                                                  ┌─┴─┐     ┌─┴─┐     ┌─┴─┐
                                            wg0 ──┤   │     │   │     │   │
                                  10.10.10.10/32  │pi4│     │NAS│     │...│
                                                  │   │     │   │     │   │
                                                  └───┘     └───┘     └───┘
Reserved for VPN users:
10.10.10.2-9
```

## Router changes 工艺路线变更 

Since, in this scenario, we don’t have a new network dedicated to our VPN  users, we need to “carve out” a section of the home network and reserve  it for the VPN.
由于在这种情况下，我们没有专用于VPN用户的新网络，因此我们需要“划分”家庭网络的一部分并将其保留给VPN。 

The easiest way to reserve IPs for the VPN is to change the router  configuration (assuming it’s responsible for DHCP in this network) and  tell its DHCP server to only hand out addresses from a specific range,  leaving a “hole” for our VPN users.
为VPN保留IP的最简单方法是更改路由器配置（假设它负责此网络中的DHCP），并告诉其DHCP服务器仅分发特定范围内的地址，为我们的VPN用户留下一个“洞”。 

For example, in the case of the `10.10.10.0/24` network, the DHCP server on the router might already be configured to hand out IP addresses from `10.10.10.2` to `10.10.10.254`. We can carve out a “hole” for our VPN users by reducing the DHCP range, as in this table:
例如，在 `10.10.10.0/24` 网络的情况下，路由器上的DHCP服务器可能已经配置为分发从 `10.10.10.2` 到 `10.10.10.254` 的IP地址。我们可以通过减少DHCP范围为VPN用户挖一个“洞”，如下表所示：

|                           |                                                              |
| ------------------------- | ------------------------------------------------------------ |
| Network                   | `10.10.10.0/24`                                              |
| Usable addresses 可用地址 | `10.10.10.2` – `10.10.10.254` (`.1` is the router)  `10.10.10.2` - `10.10.10.254` （ `.1` 是路由器） |
| DHCP range                | `10.10.10.50` – `10.10.10.254` `10.10.10.50` - `10.10.10.254` |
| VPN range                 | `10.10.10.10` – `10.10.10.59` `10.10.10.10` - `10.10.10.59`  |
|                           |                                                              |

Or via any other layout that is better suited for your case. In this way,  the router will never hand out a DHCP address that conflicts with one  that we selected for a VPN user.
 或者通过任何其他更适合您情况的布局。通过这种方式，路由器将永远不会发出与我们为VPN用户选择的DHCP地址冲突的DHCP地址。 

The second change we need to do in the router is to **port forward** the WireGuard traffic to the internal system that will be the endpoint. In the diagram above, we selected the `10.10.10.10` system to be the internal WireGuard endpoint, and we will run it on the `51000/udp` port. Therefore, you need to configure the router to forward all `51000/udp` traffic to `10.10.10.10` on the same `51000/udp` port.
我们需要在路由器中做的第二个更改是将WireGuard流量端口转发到将成为端点的内部系统。在上图中，我们选择 `10.10.10.10` 系统作为内部WireGuard端点，并将在 `51000/udp` 端口上运行它。因此，您需要将路由器配置为将所有 `51000/udp` 流量转发到同一 `51000/udp` 端口上的 `10.10.10.10` 。

Finally, we also need to allow hosts on the internet to send traffic to the router on the `51000/udp` port we selected for WireGuard. This is done in the firewall rules of  the device. Sometimes, performing the port forwarding as described  earlier also configures the firewall to allow that traffic, but it’s  better to check.
最后，我们还需要允许互联网上的主机将流量发送到我们为WireGuard选择的 `51000/udp` 端口上的路由器。这在设备的防火墙规则中完成。有时，执行前面描述的端口转发也会配置防火墙允许该流量，但最好进行检查。

Now we are ready to configure the internal endpoint.
现在我们准备好配置内部端点了。 

## Configure the internal WireGuard endpoint 配置内部WireGuard端点 

Install the `wireguard` package: 安装 `wireguard` 包：

```bash
$ sudo apt install wireguard
```

Generate the keys for this host:
为此主机生成密钥： 

```bash
$ umask 077
$ wg genkey > internal-private.key
$ wg pubkey < internal-private.key > internal-public.key
```

And create the `/etc/wireguard/wg0.conf` file with these contents:
然后创建包含以下内容的 `/etc/wireguard/wg0.conf` 文件：

```auto
[Interface]
Address = 10.10.10.10/32
ListenPort = 51000
PrivateKey = <contents of internal-private.key>

[Peer]
# laptop
PublicKey = <contents of laptop-public.key>
AllowedIPs = 10.10.10.11/32 # any available IP in the VPN range
```

> **Note**: 注意事项：
>  Just like in the [peer-to-site](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site-on-router) scenario with WireGuard on the router, there is no `Endpoint` configuration here for the laptop peer, because we don’t know where it will be connecting from beforehand.
>  就像在路由器上使用WireGuard的点对点场景中一样，这里没有笔记本电脑对等端的 `Endpoint` 配置，因为我们事先不知道它将从哪里连接。

The final step is to configure this internal system as a router for the VPN users. For that, we need to enable a couple of settings:
最后一步是将此内部系统配置为VPN用户的路由器。为此，我们需要启用几个设置： 

- **`ip_forward`**: to enable forwarding (aka, routing) of traffic between interfaces.
   `ip_forward` ：启用接口之间的流量转发（又名路由）。
- **`proxy_arp`**: to reply to Address Resolution Protocol (ARP) requests on behalf of the VPN systems, as if they were locally present on the network segment.
   `proxy_arp` ：代表VPN系统回复地址解析协议（阿普）请求，就好像它们在网段上本地存在一样。

To do that, and make it persist across reboots, create the file `/etc/sysctl.d/70-wireguard-routing.conf` file with this content:
要做到这一点，并使其在重新启动时保持不变，请创建文件 `/etc/sysctl.d/70-wireguard-routing.conf` 文件，其中包含以下内容：

```auto
net.ipv4.ip_forward = 1
net.ipv4.conf.all.proxy_arp = 1
```

Then run this command to apply those settings:
然后运行此命令以应用这些设置： 

```bash
$ sudo sysctl -p /etc/sysctl.d/70-wireguard-routing.conf -w
```

Now the WireGuard interface can be brought up:
现在可以打开WireGuard接口： 

```bash
$ sudo wg-quick up wg0
```

## Configuring the peer 配置对等体 

The peer configuration will be very similar to what was done before. What  changes will be the address, since now it won’t be on an exclusive  network for the VPN, but will have an address carved out of the home  network block.
对等配置将与之前所做的非常相似。什么变化将是地址，因为现在它不会在VPN的专用网络上，但将有一个从家庭网络块中分割出来的地址。 

Let’s call this new configuration file `/etc/wireguard/home_internal.conf`:
让我们把这个新的配置文件命名为 `/etc/wireguard/home_internal.conf` ：

```auto
[Interface]
ListenPort = 51000
Address = 10.10.10.11/24
PrivateKey = <contents of the private key for this system>

[Peer]
PublicKey = <contents of internal-public.key>
Endpoint = <home-ppp0-IP-or-hostname>:51000
AllowedIPs = 10.10.10.0/24
```

And bring up this WireGuard interface:
打开WireGuard界面： 

```bash
$ sudo wg-quick up home_internal
```

> **Note**: 注意事项：
>  There is no need to add an index number to the end of the interface name. That is a convention, but not strictly a requirement.
>  不需要在接口名称的末尾添加索引号。这是一个惯例，但不是严格的要求。

## Testing 测试 

With the WireGuard interfaces up on both peers, traffic should flow seamlessly in the `10.10.10.0/24` network between remote and local systems.
通过在两个对等体上启用WireGuard接口，流量应该在远程和本地系统之间的 `10.10.10.0/24` 网络中无缝流动。

More specifically, it’s best to test the non-trivial cases, that is, traffic between the remote peer and a host other than the one with the  WireGuard interface on the home network.
更具体地说，最好测试非平凡的情况，即远程对等点与家庭网络上具有WireGuard接口的主机之间的流量。 

# WireGuard VPN site-to-site WireGuard VPN站点到站点 

Another usual VPN configuration where one could deploy WireGuard is to connect  two distinct networks over the internet. Here is a simplified diagram:
另一种可以部署WireGuard的常见VPN配置是通过互联网连接两个不同的网络。下面是一个简化的示意图： 

```auto
                      ┌─────── WireGuard tunnel ──────┐
                      │         10.10.9.0/31          │
                      │                               │
         10.10.9.0 wgA│               xx              │wgB 10.10.9.1
                    ┌─┴─┐          xxx  xxxx        ┌─┴─┐
    alpha site      │   │ext     xx        xx    ext│   │  beta site
                    │   ├───    x           x    ───┤   │
    10.10.10.0/24   │   │      xx           xx      │   │  10.10.11.0/24
                    │   │      x             x      │   │
                    └─┬─┘      x              x     └─┬─┘
            10.10.10.1│        xx             x       │10.10.11.1
    ...┌─────────┬────┘          xx   xxx    xx       └───┬─────────┐...
       │         │                  xx   xxxxx            │         │
       │         │                                        │         │
     ┌─┴─┐     ┌─┴─┐           public internet          ┌─┴─┐     ┌─┴─┐
     │   │     │   │                                    │   │     │   │
     └───┘     └───┘                                    └───┘     └───┘
```

The goal here is to seamlessly integrate network **alpha** with network **beta**, so that systems on the alpha site can transparently access systems on the beta site, and vice-versa.
这里的目标是无缝集成网络alpha和网络beta，这样alpha站点上的系统就可以透明地访问beta站点上的系统，反之亦然。

Such a setup has a few particular details:
这样的设置有一些特定的细节： 

- Both peers are likely to be always up and running.
  两个对等点可能始终处于启动和运行状态。 
- We can’t assume one side will always be the initiator, like the laptop in a coffee shop scenario.
  我们不能假设一方总是发起者，就像咖啡店里的笔记本电脑一样。 
- Because of the above, both peers should have a static endpoint, like a fixed IP address, or valid domain name.
  由于上述原因，两个对等端都应该有一个静态端点，如固定的IP地址或有效的域名。 
- Since we are not assigning VPN IPs to all systems on each side, the VPN network here will be very small (a `/31`, which allows for two IPs) and only used for routing. The only systems  with an IP in the VPN network are the gateways themselves.
  由于我们没有将VPN IP分配给每一端的所有系统，这里的VPN网络将非常小（ `/31` ，允许两个IP），并且仅用于路由。VPN网络中唯一具有IP的系统是网关本身。
- There will be no NAT applied to traffic going over the WireGuard network. Therefore, the networks of both sites **must** be different and not overlap.
  不会对通过WireGuard网络的流量应用NAT。因此，两个站点的网络必须不同，不能重叠。

This is what an MTR (My Traceroute) report from a system in the beta network to an alpha system will look like:
下面是从beta网络中的系统到alpha系统的MTR（My Traceroute）报告： 

```bash
ubuntu@b1:~$ mtr -n -r 10.10.10.230
Start: 2022-09-02T18:56:51+0000
HOST: b1                Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 10.10.11.1       0.0%    10    0.1   0.1   0.1   0.2   0.0
  2.|-- 10.10.9.0        0.0%    10  299.6 299.3 298.3 300.0   0.6
  3.|-- 10.10.10.230     0.0%    10  299.1 299.1 298.0 300.2   0.6
```

> **Note**: 注意事项：
>  Technically, a `/31` Classless Inter-Domain Routing (CIDR) network has no usable IP  addresses, since the first one is the network address, and the second  (and last) one is the broadcast address. [RFC 3021](https://www.ietf.org/rfc/rfc3021.txt) allows for it, but if you encounter routing or other networking issues, switch to a `/30` CIDR and its two valid host IPs.
>  从技术上讲， `/31` 无类域间路由（CIDR）网络没有可用的IP地址，因为第一个是网络地址，第二个（也是最后一个）是广播地址。RFC 3021允许它，但如果您遇到路由或其他网络问题，请切换到 `/30` CIDR及其两个有效的主机IP。

## Configure WireGuard 配置WireGuard 

On the system that is the gateway for each site (that has internet  connectivity), we start by installing WireGuard and generating the keys. For the **alpha** site:
在作为每个站点（具有互联网连接）的网关的系统上，我们首先安装WireGuard并生成密钥。对于Alpha站点：

```bash
$ sudo apt install wireguard
$ wg genkey | sudo tee /etc/wireguard/wgA.key
$ sudo cat /etc/wireguard/wgA.key | wg pubkey | sudo tee /etc/wireguard/wgA.pub
```

And the configuration on alpha will be:
alpha上的配置将是： 

```auto
[Interface]
PostUp = wg set %i private-key /etc/wireguard/%i.key
Address = 10.10.9.0/31
ListenPort = 51000

[Peer]
# beta site
PublicKey = <contents of /etc/wireguard/wgB.pub>
AllowedIPs = 10.10.11.0/24,10.10.9.0/31
Endpoint = <beta-gw-ip>:51000
```

On the gateway for the **beta** site we take similar steps:
在beta站点的网关上，我们采取类似的步骤：

```bash
$ sudo apt install wireguard
$ wg genkey | sudo tee /etc/wireguard/wgB.key
$ sudo cat /etc/wireguard/wgB.key | wg pubkey | sudo tee /etc/wireguard/wgB.pub
```

And create the corresponding configuration file for beta:
并为beta创建相应的配置文件： 

```auto
[Interface]
Address = 10.10.9.1/31
PostUp = wg set %i private-key /etc/wireguard/%i.key
ListenPort = 51000

[Peer]
# alpha site
PublicKey = <contents of /etc/wireguard/wgA.pub>
AllowedIPs = 10.10.10.0/24,10.10.9.0/31
Endpoint = <alpha-gw-ip>:51000
```

> **Important**: 重要提示：
>  WireGuard is being set up on the gateways for these two networks. As  such, there are no changes needed on individual hosts of each network,  but keep in mind that the WireGuard tunneling and encryption is only  happening between the *alpha* and *beta* gateways, and **NOT** between the hosts of each network.
>  WireGuard正在这两个网络的网关上设置。因此，每个网络的各个主机上不需要更改，但请记住，WireGuard隧道和加密只发生在alpha和beta网关之间，而不是每个网络的主机之间。

## Bring the interfaces up 打开接口 

Since this VPN is permanent between static sites, it’s best to use the systemd unit file for `wg-quick` to bring the interfaces up and control them in general. In particular,  we want them to be brought up automatically on reboot events.
由于此VPN在静态站点之间是永久性的，因此最好使用 `wg-quick` 的systemd单元文件来启动接口并对其进行一般控制。特别是，我们希望它们在重启事件中自动出现。

On **alpha**: 在alpha上：

```bash
$ sudo systemctl enable --now wg-quick@wgA
```

And similarly on **beta**: 在Beta上也是一样：

```bash
$ sudo systemctl enable --now wg-quick@wgB
```

This both enables the interface on reboot, and starts it right away.
这既可以在重新引导时启用接口，也可以立即启动它。 

## Firewall and routing 防火墙和路由 

Both gateways probably already have some routing and firewall rules. These might need changes depending on how they are set up.
这两个网关可能已经有了一些路由和防火墙规则。这些可能需要根据它们的设置方式进行更改。 

The individual hosts on each network won’t need any changes regarding the  remote alpha or beta networks, because they will just send that traffic  to the default gateway (as any other non-local traffic), which knows how to route it because of the routes that `wg-quick` added.
每个网络上的各个主机不需要对远程alpha或beta网络进行任何更改，因为它们只会将该流量发送到默认网关（与任何其他非本地流量一样），因为 `wg-quick` 添加的路由，该网关知道如何路由它。

In the configuration we did so far, there have been no restrictions in  place, so traffic between both sites flows without impediments.
在我们迄今为止所做的配置中，没有任何限制，因此两个站点之间的流量没有障碍。 

In general, what needs to be done or checked is:
一般来说，需要做或检查的是： 

- Make sure both gateways can contact each other on the specified endpoint  addresses and UDP port. In the case of this example, that is port `51000`. For extra security, create a firewall rule that only allows each peer to contact this port, instead of the Internet at large.
  确保两个网关可以在指定的端点地址和UDP端口上相互联系。在本例中，即端口 `51000` 。为了获得额外的安全性，请创建一个防火墙规则，只允许每个对等方联系此端口，而不是整个Internet。

- Do NOT masquerade or NAT the traffic coming from the internal network and  going out via the WireGuard interface towards the other site. This is  purely routed traffic.
  不要伪装或NAT来自内部网络的流量，并通过WireGuard接口前往其他站点。这是纯粹的路由流量。 

- There shouldn’t be any routing changes needed on the gateways, since `wg-quick` takes care of adding the route for the remote site, but do check the routing table to see if it makes sense (`ip route` and `ip route | grep wg` are a good start).
  网关上不需要任何路由更改，因为 `wg-quick` 负责为远程站点添加路由，但请检查路由表，看看它是否有意义（ `ip route` 和 `ip route | grep wg` 是一个很好的开始）。

- You may have to create new firewall rules if you need to restrict traffic between the alpha and beta networks.
  如果您需要限制alpha和beta网络之间的流量，则可能需要创建新的防火墙规则。 

  For example, if you want to prevent SSH between the sites, you could add a firewall rule like this one to **alpha**:
  例如，如果你想阻止站点之间的SSH，你可以在alpha中添加这样一条防火墙规则：

  `$ sudo iptables -A FORWARD -i wgA -p tcp --dport 22 -j REJECT`

  And similarly on **beta**: 在Beta上也是一样：

  `$ sudo iptables -A FORWARD -i wgB -p tcp --dport 22 -j REJECT`

  You can add these as `PostUp` actions in the WireGuard interface config. Just don’t forget to remove them in the corresponding `PreDown` hook, or you will end up with multiple rules.
  您可以在WireGuard接口配置中将这些作为 `PostUp` 操作添加。只是不要忘记在相应的 `PreDown` 钩子中删除它们，否则你将最终得到多个规则。

------

# Using the VPN as the default gateway 使用VPN作为默认网关 

WireGuard can be set up to route all traffic through the VPN, and not just  specific remote networks. There could be many reasons to do this, but  mostly they are related to privacy.
WireGuard可以设置为通过VPN路由所有流量，而不仅仅是特定的远程网络。这样做的原因可能有很多，但大多数都与隐私有关。 

Here we will assume a scenario where the local network is considered to be  “untrusted”, and we want to leak as little information as possible about our behaviour on the Internet. This could apply to the case of an  airport, or a coffee shop, a conference, a hotel, or any other public  network.
在这里，我们将假设一个场景，其中本地网络被认为是“不可信的”，我们希望尽可能少地泄露有关我们在互联网上行为的信息。这可以应用于机场、咖啡店、会议、酒店或任何其他公共网络的情况。 

```auto
                       public untrusted          ┌── wg0 10.90.90.2/24
10.90.90.1/24          network/internet          │   VPN network
        wg0│            xxxxxx            ┌──────┴─┐
         ┌─┴──┐         xx   xxxxx  ──────┤ VPN gw │
         │    ├─wlan0  xx       xx   eth0 └────────┘
         │    │       xx        x 
         │    │        xxx    xxx
         └────┘          xxxxxx
         Laptop
```

For the best results, we need a system we can reach on the internet and  that we control. Most commonly this can be a simple small VM in a public cloud, but a home network also works. Here we will assume it’s a brand  new system that will be configured from scratch for this very specific  purpose.
为了达到最佳效果，我们需要一个我们可以在互联网上访问并控制的系统。最常见的是，这可以是公共云中的一个简单的小型VM，但家庭网络也可以工作。在这里，我们将假设这是一个全新的系统，将从头开始配置这个非常特定的目的。 

## Install and configure WireGuard 安装和配置WireGuard 

Let’s start the configuration by installing WireGuard and generating the keys. On the client, run the following commands:
让我们通过安装WireGuard并生成密钥来开始配置。在客户端上，运行以下命令： 

```bash
sudo apt install wireguard
umask 077
wg genkey > wg0.key
wg pubkey < wg0.key > wg0.pub
sudo mv wg0.key wg0.pub /etc/wireguard
```

And on the gateway server:
在网关服务器上： 

```bash
sudo apt install wireguard
umask 077
wg genkey > gateway0.key
wg pubkey < gateway0.key > gateway0.pub
sudo mv gateway0.key gateway0.pub /etc/wireguard
```

On the client, we will create `/etc/wireguard/wg0.conf`:
在客户端，我们将创建 `/etc/wireguard/wg0.conf` ：

```auto
[Interface]
PostUp = wg set %i private-key /etc/wireguard/wg0.key
ListenPort = 51000
Address = 10.90.90.1/24

[Peer]
PublicKey = <contents of gateway0.pub>
Endpoint = <public IP of gateway server>
AllowedIPs = 0.0.0.0/0
```

Key points here: 这里的要点： 

- We selected the `10.90.90.1/24` IP address for the WireGuard interface. This can be any private IP  address, as long as it doesn’t conflict with the network you are on, so  double check that. If it needs to be changed, don’t forget to also  change the IP for the WireGuard interface on the gateway server.
  我们为WireGuard接口选择了 `10.90.90.1/24` IP地址。这可以是任何私有IP地址，只要它不与您所在的网络冲突，因此请仔细检查。如果需要更改，请不要忘记更改网关服务器上WireGuard接口的IP。
- The `AllowedIPs` value is `0.0.0.0/0`, which means “all IPv4 addresses”.
   `AllowedIPs` 值为 `0.0.0.0/0` ，表示“所有IPv4地址”。
- We are using `PostUp` to load the private key instead of specifying it directly in the  configuration file, so we don’t have to set the permissions on the  config file to `0600`.
  我们使用 `PostUp` 来加载私钥，而不是直接在配置文件中指定它，因此我们不必将配置文件上的权限设置为 `0600` 。

The counterpart configuration on the gateway server is `/etc/wireguard/gateway0.conf` with these contents:
网关服务器上的对应配置为 `/etc/wireguard/gateway0.conf` ，内容如下：

```auto
[Interface]
PostUp = wg set %i private-key /etc/wireguard/%i.key
Address = 10.90.90.2/24
ListenPort = 51000

[Peer]
PublicKey = <contents of wg0.pub>
AllowedIPs = 10.90.90.1/32
```

Since we don’t know where this remote peer will be connecting from, there is no `Endpoint` setting for it, and the expectation is that the peer will be the one initiating the VPN.
由于我们不知道这个远程对等端将从哪里连接，因此没有 `Endpoint` 设置，并且期望对等端将是发起VPN的那个。

This finishes the WireGuard configuration on both ends, but there is one extra step we need to take on the gateway server.
这就完成了两端的WireGuard配置，但是我们需要在网关服务器上执行一个额外的步骤。 

## Routing and masquerading 路由和伪装 

The WireGuard configuration that we did so far is enough to send the  traffic from the client (in the untrusted network) to the gateway  server. But what about from there onward? There are two extra  configuration changes we need to make on the gateway server:
到目前为止，我们所做的WireGuard配置足以将流量从客户端（在不受信任的网络中）发送到网关服务器。但从那以后呢？我们需要在网关服务器上进行两个额外的配置更改： 

- Masquerade (or apply source NAT rules) the traffic from `10.90.90.1/24`.
  伪装（或应用源NAT规则）来自 `10.90.90.1/24` 的流量。
- Enable IPv4 forwarding so our gateway server acts as a router.
  启用IPv4转发，使我们的网关服务器充当路由器。 

To enable routing, create `/etc/sysctl.d/70-wireguard-routing.conf` with this content:
要启用路由，请使用以下内容创建 `/etc/sysctl.d/70-wireguard-routing.conf` ：

```auto
net.ipv4.ip_forward = 1
```

And run: 然后跑： 

```bash
sudo sysctl -p /etc/sysctl.d/70-wireguard-routing.conf -w
```

To masquerade the traffic from the VPN, one simple rule is needed:
要伪装来自VPN的流量，需要一个简单的规则： 

```bash
sudo iptables -t nat -A POSTROUTING -s 10.90.90.0/24 -o eth0 -j MASQUERADE
```

Replace `eth0` with the name of the network interface on the gateway server, if it’s different.
将 `eth0` 替换为网关服务器上网络接口的名称（如果不同）。

To have this rule persist across reboots, you can add it to `/etc/rc.local` (create the file if it doesn’t exist and make it executable):
要使此规则在重新引导时保持不变，您可以将其添加到 `/etc/rc.local` （如果文件不存在，则创建该文件并使其可执行）：

```auto
#!/bin/sh
iptables -t nat -A POSTROUTING -s 10.90.90.0/24 -o eth0 -j MASQUERADE
```

This completes the gateway server configuration.
这就完成了网关服务器的配置。 

## Testing 测试 

Let’s bring up the WireGuard interfaces on both peers. On the gateway server:
让我们在两个对等体上打开WireGuard接口。在网关服务器上： 

```bash
$ sudo wg-quick up gateway0
[#] ip link add gateway0 type wireguard
[#] wg setconf gateway0 /dev/fd/63
[#] ip -4 address add 10.90.90.2/24 dev gateway0
[#] ip link set mtu 1378 up dev gateway0
[#] wg set gateway0 private-key /etc/wireguard/gateway0.key
```

And on the client:
在客户端： 

```bash
$ sudo wg-quick up wg0
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip -4 address add 10.90.90.1/24 dev wg0
[#] ip link set mtu 1420 up dev wg0
[#] wg set wg0 fwmark 51820
[#] ip -4 route add 0.0.0.0/0 dev wg0 table 51820
[#] ip -4 rule add not fwmark 51820 table 51820
[#] ip -4 rule add table main suppress_prefixlength 0
[#] sysctl -q net.ipv4.conf.all.src_valid_mark=1
[#] nft -f /dev/fd/63
[#] wg set wg0 private-key /etc/wireguard/wg0.key
```

From the client you should now be able to verify that your traffic reaching  out to the internet is going through the gateway server via the  WireGuard VPN. For example:
从客户端，您现在应该能够验证您到达互联网的流量是否通过WireGuard VPN通过网关服务器。举例来说： 

```bash
$ mtr -r 1.1.1.1
Start: 2022-09-01T12:42:59+0000
HOST: laptop.lan                 Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 10.90.90.2                 0.0%    10  184.9 185.5 184.9 186.9   0.6
  2.|-- 10.48.128.1                0.0%    10  185.6 185.8 185.2 188.3   0.9
  (...)
  7.|-- one.one.one.one            0.0%    10  186.2 186.3 185.9 186.6   0.2
```

Above, hop 1 is the `gateway0` interface on the gateway server, then `10.48.128.1` is the default gateway for that server, then come some in-between hops, and the final hit is the target.
上面，跳1是网关服务器上的 `gateway0` 接口，然后 `10.48.128.1` 是该服务器的默认网关，然后是一些中间跳，最后命中的是目标。

If you only look at the output of `ip route`, however, it’s not immediately obvious that the WireGuard VPN is the default gateway:
但是，如果您只查看 `ip route` 的输出，则无法立即看出WireGuard VPN是默认网关：

```bash
$ ip route
default via 192.168.122.1 dev enp1s0 proto dhcp src 192.168.122.160 metric 100 
10.90.90.0/24 dev wg0 proto kernel scope link src 10.90.90.1 
192.168.122.0/24 dev enp1s0 proto kernel scope link src 192.168.122.160 metric 100 
192.168.122.1 dev enp1s0 proto dhcp scope link src 192.168.122.160 metric 100 
```

That’s because WireGuard is using `fwmarks` and policy routing. WireGuard cannot simply set the `wg0` interface as the default gateway: that traffic needs to reach the specified endpoint on port `51000/UDP` outside of the VPN tunnel.
这是因为WireGuard使用 `fwmarks` 和策略路由。WireGuard不能简单地将 `wg0` 接口设置为默认网关：流量需要到达VPN隧道外部端口 `51000/UDP` 上的指定端点。

If you want to dive deeper into how this works, check `ip rule list`, `ip route list table 51820`, and consult the documentation on “Linux Policy Routing”.
如果您想深入了解它的工作原理，请选中 `ip rule list` 、 `ip route list table 51820` ，并查阅“Linux Policy Routing”上的文档。

## DNS leaks DNS泄漏 

The traffic is now being routed through the VPN to the gateway server that  you control, and from there onwards, to the Internet at large. The local network you are in cannot see the contents of that traffic, because  it’s encrypted. But you are still leaking information about the sites  you access via DNS.
流量现在通过VPN路由到您控制的网关服务器，并从那里开始，到整个Internet。您所在的本地网络无法看到该流量的内容，因为它是加密的。但是你仍然在泄露你通过DNS访问的网站的信息。 

When the laptop got its IP address in the local (untrusted) network it is  in, it likely also got a pair of IPs for DNS servers to use. These might be servers from that local network, or other DNS servers from the  internet like `1.1.1.1` or `8.8.8.8`. When you access an internet site, a DNS query will be sent to those  servers to discover their IP addresses. Sure, that traffic goes over the VPN, but at some point it exits the VPN, and then reaches those  servers, which will then know what you are trying to access.
当笔记本电脑在其所在的本地（不受信任）网络中获得其IP地址时，它可能也获得了一对供DNS服务器使用的IP。这些服务器可能是本地网络的服务器，也可能是互联网上的其他DNS服务器，如 `1.1.1.1` 或 `8.8.8.8` 。当您访问互联网网站时，DNS查询将发送到这些服务器以发现其IP地址。当然，流量会通过VPN，但在某个时候它会退出VPN，然后到达那些服务器，然后这些服务器就会知道你试图访问的内容。

There are DNS leak detectors out there, and if you want a quick check you can try out https://dnsleaktest.com. It will tell you which DNS servers your connection is using, and it’s  up to you if you trust them or not. You might be surprised that even if  you are in a conference network, for example, using a default gateway  VPN like the one described here, you are still using the DNS servers  from the conference infrastructure. In a way, the DNS traffic is leaving your machine encrypted, and then coming back in clear text to the local DNS server.
有DNS泄漏检测器在那里，如果你想快速检查，你可以尝试https://dnsleaktest.com。它会告诉你你的连接正在使用哪些DNS服务器，这取决于你是否信任它们。您可能会感到惊讶，即使您在会议网络中，例如，使用此处描述的默认网关VPN，您仍然使用会议基础设施的DNS服务器。在某种程度上，DNS流量是加密的，然后以明文形式返回到本地DNS服务器。

There are two things you can do about this: select a specific DNS server to  use for your VPN connection, or install your own DNS server.
您可以做两件事：选择特定的DNS服务器用于VPN连接，或者安装自己的DNS服务器。 

### Selecting a DNS server 选择DNS服务器 

If you can use a DNS server that you trust, or don’t mind using, this is  probably the easiest solution. Many people would start with the DNS  server assigned to the gateway server used for the VPN. This address can be checked by running the following command in a shell on the gateway  server:
如果您可以使用您信任的DNS服务器，或者不介意使用，这可能是最简单的解决方案。许多人会从分配给用于VPN的网关服务器的DNS服务器开始。可以通过在网关服务器上的shell中运行以下命令来检查此地址： 

```bash
$ resolvectl status
Global
       Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
resolv.conf mode: stub

Link 2 (ens2)
    Current Scopes: DNS
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 10.48.0.5
       DNS Servers: 10.48.0.5
        DNS Domain: openstacklocal

Link 5 (gateway0)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
```

Look for `Current DNS Server`. In the example above, it’s `10.48.0.5`.
看 `Current DNS Server` 。在上面的例子中，它是 `10.48.0.5` 。

Let’s change the WireGuard `wg0` interface config to use that DNS server. Edit `/etc/wireguard/wg0.conf` and add a second `PostUp` line with the `resolvectl` command like below:
让我们更改WireGuard `wg0` 接口配置以使用该DNS服务器。编辑 `/etc/wireguard/wg0.conf` 并使用如下所示的 `resolvectl` 命令添加第二个 `PostUp` 行：

```auto
[Interface]
PostUp = wg set %i private-key /etc/wireguard/wg0.key
PostUp = resolvectl dns %i 10.48.0.5; resolvectl domain %i \~.
ListenPort = 51000
Address = 10.90.90.1/24

[Peer]
PublicKey = <contents of gateway0.pub>
Endpoint = <public IP of gateway server>
AllowedIPs = 0.0.0.0/0
```

You can run that `resolvectl` command by hand if you want to avoid having to restart the WireGuard VPN:
如果您想避免重新启动WireGuard VPN，您可以手动运行该 `resolvectl` 命令：

```bash
sudo resolvectl dns wg0 10.48.0.5; sudo resolvectl domain wg0 \~.
```

Or just restart the WireGuard interface:
或者重新启动WireGuard接口： 

```bash
sudo wg-quick down wg0; sudo wg-quick up wg0
```

And if you check again for DNS leaks, this time you will see that you are only using the DNS server you specified.
如果您再次检查DNS泄漏，这一次您将看到您仅使用指定的DNS服务器。 

### Installing your own DNS server 安装自己的DNS服务器 

If you don’t want to use even the DNS server from the hosting provider  where you have your gateway server, another alternative is to install  your own DNS server.
如果你不想使用甚至从托管服务提供商的DNS服务器，你有你的网关服务器，另一种选择是安装自己的DNS服务器。 

There are multiple choices out there for this: `bind9` and `unbound` are quite popular, and it is easy to find quick tutorials and instructions on how to do it.
有多种选择： `bind9` 和 `unbound` 非常受欢迎，很容易找到关于如何做到这一点的快速教程和说明。

Here we will proceed with `bind9`, which is in the Ubuntu *main* repository.
在这里，我们将继续使用 `bind9` ，它位于Ubuntu主存储库中。

On the gateway server, install the `bind9` package:
在网关服务器上，安装 `bind9` 包：

```bash
sudo apt install bind9
```

And that’s it for the server part.
这就是服务器部分。 

On the client, add a `PostUp` line specifying this IP (or change the line we added in the previous section):
在客户端上，添加一个 `PostUp` 行指定此IP（或更改我们在上一节中添加的行）：

```auto
[Interface]
PostUp = wg set %i private-key /etc/wireguard/wg0.key
PostUp = resolvectl dns %i 10.90.90.2; resolvectl domain %i \~.
ListenPort = 51000
Address = 10.90.90.1/24

[Peer]
PublicKey = <contents of gateway0.pub>
Endpoint = <public IP of gateway server>
AllowedIPs = 0.0.0.0/0
```

And restart the WireGuard interface. Now your VPN client will be using the gateway server as the DNS server.
然后重启WireGuard接口。现在，您的VPN客户端将使用网关服务器作为DNS服务器。 

------

# Common tasks in WireGuard VPN WireGuard VPN中的常见任务 

Here are some common tasks and other useful tips that can help you in your WireGuard deployment.
以下是一些常见任务和其他有用的提示，可以帮助您进行WireGuard部署。 

## Controlling the WireGuard interface with systemd 使用systemd控制WireGuard接口 

The `wg-quick` tool is a simple way to bring the WireGuard interface up and down. That control is also exposed via a systemd service, which means the standard `systemctl` tool can be used.
 `wg-quick` 工具是一种简单的方法来使WireGuard接口向上和向下。该控件也通过systemd服务公开，这意味着可以使用标准的 `systemctl` 工具。

Probably the greatest benefit of this is that it gives you the ability to  configure the interface to be brought up automatically on system boot.  For example, to configure the `wg0` interface to be brought up at boot, run the following command:
这样做的最大好处可能是它使您能够配置在系统靴子时自动启动的接口。例如，要将 `wg0` 接口配置为在靴子时启动，请运行以下命令：

```bash
$ sudo systemctl enable wg-quick@wg0
```

The name of the systemd service follows the WireGuard interface name, and  multiple such services can be enabled/started at the same time.  You can also use the `systemctl status`, `start`, `stop`, `reload` and `restart` commands to control the WireGuard interface and query its status:
systemd服务的名称跟在WireGuard接口名称之后，可以同时启用/启动多个此类服务。您还可以使用 `systemctl status` 、 `start` 、 `stop` 、 `reload` 和 `restart` 命令来控制WireGuard接口并查询其状态：

```bash
$ sudo systemctl reload wg-quick@wg0
```

The `reload` action does exactly what we expect: it reloads the configuration of the interface without disrupting existing WireGuard tunnels. To add or  remove peers, `reload` is sufficient, but if `wg-quick` options, such as `PostUp`, `Address`, or similar are changed, then a `restart` is needed.
 `reload` 操作完全符合我们的预期：它重新加载接口的配置，而不会中断现有的WireGuard隧道。要添加或删除对等体， `reload` 就足够了，但如果 `wg-quick` 选项（如 `PostUp` 、 `Address` 或类似选项）发生更改，则需要 `restart` 。

## DNS resolving DNS解析 

Let’s say when you are inside the home network (literally – at home), you can connect to your other systems via DNS names, because your router at `10.10.10.1` can act as an internal DNS server. It would be nice to have this capability also when connected via the WireGuard VPN.
比方说，当你在家庭网络中（字面意思是在家），你可以通过DNS名称连接到你的其他系统，因为你的路由器在 `10.10.10.1` 可以作为一个内部DNS服务器。如果通过WireGuard VPN连接时也具有此功能，那就太好了。

To do that, we can add a `PostUp` command to the WireGuard configuration to run a command for us right  after the VPN is established. This command can be anything you would run in a shell (as root). We can use that to adjust the DNS resolver  configuration of the laptop that is remotely connected to the home  network.
为此，我们可以在WireGuard配置中添加 `PostUp` 命令，以便在VPN建立后立即为我们运行命令。这个命令可以是你在shell中运行的任何命令（作为root）。我们可以使用它来调整远程连接到家庭网络的笔记本电脑的DNS解析器配置。

For example, if we have a WireGuard setup as follows:
例如，如果我们有一个WireGuard设置如下： 

- `home0` WireGuard interface. `home0` WireGuard接口。
- `.home` DNS domain for the remote network.
   `.home` 远程网络的DNS域。
- `10.10.10.1/24` is the DNS server for the `.home` domain, reachable after the VPN is established.
   `10.10.10.1/24` 是 `.home` 域的DNS服务器，在VPN建立后可访问。

We can add this `PostUp` command to the `home0.conf` configuration file to have our systemd-based resolver use `10.10.10.1` as the DNS server for any queries for the `.home` domain:
我们可以将这个 `PostUp` 命令添加到 `home0.conf` 配置文件中，让我们基于systemd的解析器使用 `10.10.10.1` 作为DNS服务器，用于对 `.home` 域的任何查询：

```bash
[Interface]
...
PostUp = resolvectl dns %i 10.10.10.1; resolvectl domain %i \~home
```

For `PostUp` (and `PostDown` – see the [`wg-quick(8)` manpage](https://manpages.ubuntu.com/manpages/en/man8/wg-quick.8.html) for details), the `%i` text is replaced with the WireGuard interface name. In this case, that would be `home0`.
对于 `PostUp` （和 `PostDown` -有关详细信息，请参见 `wg-quick(8)` 手册页）， `%i` 文本将替换为WireGuard接口名称。在这种情况下，这将是 `home0` 。

These two `resolvectl` commands tell the local *systemd-resolved* resolver to:
这两个 `resolvectl` 命令告诉本地systemd解析的解析器：

- associate the DNS server at `10.10.10.1` to the `home0` interface, and
  将 `10.10.10.1` 处的DNS服务器关联到 `home0` 接口，以及
- associate the `home` domain to the `home0` interface.
  将 `home` 域关联到 `home0` 接口。

When you bring the `home0` WireGuard interface up again, it will run the `resolvectl` commands:
当您再次打开 `home0` WireGuard接口时，它将运行 `resolvectl` 命令：

```bash
$ sudo wg-quick up home0
[#] ip link add home0 type wireguard
[#] wg setconf home0 /dev/fd/63
[#] ip -4 address add 10.10.11.2/24 dev home0
[#] ip link set mtu 1420 up dev home0
[#] ip -4 route add 10.10.10.0/24 dev home0
[#] resolvectl dns home0 10.10.10.1; resolvectl domain home0 \~home
```

You can verify that it worked by pinging some hostname in your home network, or checking the DNS resolution status for the `home0` interface:
您可以通过在家庭网络中ping某个主机名或检查 `home0` 接口的DNS解析状态来验证它是否工作：

```bash
$ resolvectl status home0
Link 26 (home0)
    Current Scopes: DNS
         Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 10.10.10.1
       DNS Servers: 10.10.10.1
        DNS Domain: ~home
```

If you are using `systemctl` to control the WireGuard interface, this is the type of change (adding or changing `PostUp`) where the `reload` action won’t be enough, and you actually need to issue a `restart`.
如果您使用 `systemctl` 来控制WireGuard接口，这是一种更改类型（添加或更改 `PostUp` ），其中 `reload` 操作不够，您实际上需要发出 `restart` 。

> **Note**: 注意事项：
>  The [`wg-quick(8)` manpage](https://manpages.ubuntu.com/manpages/en/man8/wg-quick.8.html) documents the DNS setting of the WireGuard interface which has the same purpose, but only works if you have `resolveconf` installed. Ubuntu systems by default don’t, and rely on `systemd-resolved` instead.
>  `wg-quick(8)` 手册页记录了WireGuard接口的DNS设置，其目的相同，但仅在安装了 `resolveconf` 时才有效。Ubuntu系统默认不支持，而是依赖于 `systemd-resolved` 。

## Adding another peer 添加另一个peer 

To add another peer to an existing WireGuard setup, we have to:
要向现有WireGuard设置添加另一个对等点，我们必须： 

1. Generate a new keypair for the new peer
   为新对等体生成新密钥对 
2. Create a new `[Peer]` section on the “other side” of the WireGuard setup
   在WireGuard设置的“另一侧”创建一个新的 `[Peer]` 部分
3. Pick a new IP for the new peer
   为新对等点选择新IP 

Let’s call the new system `ontheroad`, and generate the keys for it:
让我们调用新系统 `ontheroad` ，并为它生成密钥：

```bash
$ umask 077
$ wg genkey > ontheroad-private.key
$ wg pubkey < ontheroad-private.key > ontheroad-public.key
$ ls -la ontheroad.*
-rw------- 1 ubuntu ubuntu 45 Aug 22 20:12 ontheroad-private.key
-rw------- 1 ubuntu ubuntu 45 Aug 22 20:13 ontheroad-public.key
```

As for its IP address, let’s pick `10.10.11.3/24` for it, which is the next one in the sequence from one of the previous examples in our WireGuard guide:
至于它的IP地址，让我们为它选择 `10.10.11.3/24` ，这是我们WireGuard指南中前面的一个例子中的下一个：

```auto
[Interface]
PrivateKey = <contents-of-ontheroad-private.key>
ListenPort = 51000
Address = 10.10.11.3/24

[Peer]
PublicKey = <contents-of-router-public.key>
Endpoint = <home-ppp0-IP-or-hostname>:51000
AllowedIPs = 10.10.11.0/24,10.10.10.0/24
```

The only difference between this config and one for an existing system in this same WireGuard setup will be `PrivateKey` and `Address`.
此配置与同一WireGuard设置中现有系统的配置之间的唯一区别是 `PrivateKey` 和 `Address` 。

On the “other side”, we add the new `[Peer]` section to the existing config:
在“另一边”，我们将新的 `[Peer]` 部分添加到现有配置中：

```auto
[Interface]
PrivateKey = <contents-of-router-private.key>
ListenPort = 51000
Address = 10.10.11.1/24

[Peer]
# laptop
PublicKey = <contents-of-laptop-public.key>
AllowedIPs = 10.10.11.2

[Peer]
# ontheroad
PublicKey = <contents-of-ontheroad-public.key>
AllowedIPs = 10.10.11.3
```

To update the interface with the new peer without disrupting existing connections, we use the `reload` action of the systemd unit:
为了在不中断现有连接的情况下使用新对等体更新接口，我们使用systemd单元的 `reload` 操作：

```bash
$ systemctl reload wg-quick@wg0
```

> **Note**: 注意事项：
>  For this case of a “server” or “VPN gateway”, where we are just adding another peer to an existing config, the `systemctl reload` action will work well enough to insert the new peer into the WireGuard  configuration. However, it won’t create new routes, or do any of the  other steps that `wg-quick` does. Depending on your setup, you might need a full restart so that `wg-quick` can fully do its job.
>  对于这种“服务器”或“VPN网关”的情况，我们只是在现有配置中添加另一个对等点， `systemctl reload` 操作将足以将新对等点插入WireGuard配置。但是，它不会创建新的路由，也不会执行 `wg-quick` 执行的任何其他步骤。根据您的设置，您可能需要完全重新启动，以便 `wg-quick` 可以完全完成其工作。

## Adding a smartphone peer 添加智能手机对等设备 

WireGuard can be installed on many different platforms, and smartphones are included. The upstream installation page has [links for Android](https://www.wireguard.com/install/#android-play-store-f-droid) and [for iOS apps](https://www.wireguard.com/install/#ios-app-store).
WireGuard可以安装在许多不同的平台上，包括智能手机。上游安装页面有Android和iOS应用程序的链接。

Such a mobile client can be configured more easily with the use of QR codes.
这样的移动的客户端可以通过使用QR码来更容易地配置。 

We start by creating the new peer’s config normally, as if it were any  other system (generate keys, pick an IP address, etc). Then, to convert  that configuration file to a QR code, install the `qrencode` package:
我们从正常创建新对等体的配置开始，就像它是任何其他系统一样（生成密钥，选择IP地址等）。然后，要将该配置文件转换为QR码，请安装 `qrencode` 包：

```bash
$ sudo apt install qrencode
```

Next, run the following command (assuming the config was written to `phone.conf`):
接下来，运行以下命令（假设配置已写入 `phone.conf` ）：

```bash
$ cat phone.conf | qrencode -t ansiutf8 
```

That will generate a QR code in the terminal, ready for scanning with the  smartphone app. Note that there is no need for a graphical environment,  and this command can be run remotely over SSH for example.
这将在终端中生成一个QR码，准备使用智能手机应用程序进行扫描。请注意，不需要图形环境，例如，此命令可以通过SSH远程运行。 

Note that you need to put the private key contents directly into that configuration file, and not use `PostUp` to load it from a separate file.
请注意，您需要将私钥内容直接放入该配置文件中，而不是使用 `PostUp` 从单独的文件加载它。

> **Important 重要**
>  Treat this QR code as a secret, as it contains the private key for the WireGuard interface!
>  将此QR码视为机密，因为它包含WireGuard接口的私钥！

------

# Security tips for WireGuard VPN WireGuard VPN的安全提示 

Here are some security tips for your WireGuard deployment.
这里有一些关于您的WireGuard部署的安全提示。 

## Traffic goes both ways 交通双向通行 

Remember that the VPN traffic goes both ways. Once you are connected to the  remote network, it means any device on that network can connect back to  you! That is, unless you create specific firewall rules for this VPN  network.
请记住，VPN流量是双向的。一旦您连接到远程网络，这意味着该网络上的任何设备都可以连接回您！也就是说，除非您为此VPN网络创建特定防火墙规则。 

Since WireGuard is “just” an interface, you can create normal firewall rules  for its traffic, and control the access to the network resources as  usual. This is done more easily if you have a dedicated network for the  VPN clients.
由于WireGuard“只是”一个接口，您可以为其流量创建正常的防火墙规则，并像往常一样控制对网络资源的访问。如果你有一个专用的VPN客户端网络，这会更容易完成。 

## Using PreSharedKey 使用PreSharedKey 

You can add another layer of cryptographic protection to your VPN with the `PreSharedKey` option. Its use is optional, and adds a layer of symmetric-key cryptography to the traffic between specific peers.
您可以使用 `PreSharedKey` 选项为VPN添加另一层加密保护。它的使用是可选的，并为特定对等点之间的流量添加了一层密钥加密。

Such a key can be generated with the `genpsk` command:
可以使用 `genpsk` 命令生成这样的密钥：

```bash
$ wg genpsk
vxlX6eMMin8uhxbKEhe/iOxi8ru+q1qWzCdjESXoFZY=
```

And then used in a `[Peer]` section, like this:
然后在 `[Peer]` 节中使用，如下所示：

```auto
[Peer]
PublicKey = ....
Endpoint = ....
AllowedIPs = ....
PresharedKey = vxlX6eMMin8uhxbKEhe/iOxi8ru+q1qWzCdjESXoFZY=
```

> **Note**: 注意事项：
>  Both sides need to have the same `PresharedKey` in their respective `[Peer]` sections.
>  双方需要在各自的 `[Peer]` 部分中具有相同的 `PresharedKey` 。

## Preventing accidental leakage of private keys 防止私钥意外泄漏 

When troubleshooting WireGuard, it’s common to post the contents of the  interface configuration file somewhere for others to help, like in a  mailing list, or internet forum. Since the private key is listed in that file, one has to remember to strip or obfuscate it before sharing, or  else the secret is leaked.
在对WireGuard进行故障排除时，通常会将接口配置文件的内容发布到其他人可以帮助的地方，例如邮件列表或互联网论坛。由于私钥列在该文件中，因此在共享之前必须记住剥离或混淆它，否则秘密就会泄露。 

To avoid such mistakes, we can remove the private key from the  configuration file and leave it in its own file. This can be done via a `PostUp`` hook. For example, let's update the `home0.conf` file to use such a hook:
为了避免这样的错误，我们可以从配置文件中删除私钥，并将其保留在自己的文件中。这可以通过一个 `PostUp`` hook. For example, let's update the ` home0.conf`文件来使用这样一个钩子：

```auto
[Interface]
ListenPort = 51000
Address = 10.10.11.3/24
PostUp = wg set %i private-key /etc/wireguard/%i.key

[Peer]
PublicKey = <contents-of-router-public.key>
Endpoint = 10.48.132.39:51000
AllowedIPs = 10.10.11.0/24,10.10.10.0/24
```

The `%i` macro is replaced by the WireGuard interface name (`home0` in this case). When the interface comes up, the `PostUp` shell commands will be executed with that substitution in place, and  the private key for this interface will be set with the contents of the `/etc/wireguard/home0.key` file.
 `%i` 宏被WireGuard接口名称替换（在本例中为 `home0` ）。当接口出现时，将使用该替换执行 `PostUp` shell命令，并且将使用 `/etc/wireguard/home0.key` 文件的内容设置该接口的私钥。

There are some other advantages to this method, and perhaps one disadvantage.
这种方法还有其他一些优点，也许还有一个缺点。 

Pros: 优点： 

- The configuration file can now safely be stored in version control, like a  git repository, without fear of leaking the private key (unless you also use the `PreSharedKey` option, which is also a secret).
  配置文件现在可以安全地存储在版本控制中，就像git存储库一样，不用担心私钥泄露（除非你也使用 `PreSharedKey` 选项，这也是一个秘密）。
- Since the key is now stored in a file, you can give that file a meaningful  name, which helps to avoid mix-ups with keys and peers when setting up  WireGuard.
  由于密钥现在存储在文件中，因此您可以给予该文件一个有意义的名称，这有助于避免在设置WireGuard时混淆密钥和对等项。 

Cons: 缺点： 

- You cannot directly use the `qrcode` tool to convert this image to a QR code and use it to configure the  mobile version of WireGuard, because that tool won’t go after the  private key in that separate file.
  您不能直接使用 `qrcode` 工具将此图像转换为QR码并使用它来配置WireGuard的移动的版本，因为该工具不会在该单独文件中使用私钥。

# Troubleshooting WireGuard VPN WireGuard VPN故障排除 

The following general checklist should help as a first set of steps to try when you run into problems with WireGuard.
下面的一般检查表应该有助于作为第一组步骤，尝试当你遇到问题的WireGuard。 

- **Verify public and private keys**: When dealing with multiple peers, it’s easy to mix these up, especially because the contents of these keys are just random data. There is  nothing identifying them, and public and private keys are basically the  same (format-wise).
  验证公钥和私钥：当处理多个对等体时，很容易混淆这些密钥，特别是因为这些密钥的内容只是随机数据。没有任何东西可以识别它们，公钥和私钥基本上是相同的（格式方面）。
- **Verify `AllowedIPs` list on all peers**.
  验证所有对等体上的 `AllowedIPs` 列表。
- **Check with `ip route` and `ip addr show dev <wg-interface>`** if the routes and IPs are set as you expect.
  使用 `ip route` 和 `ip addr show dev <wg-interface>` 检查路由和IP是否按预期设置。
- Double check that you have **`/proc/sys/net/ipv4/ip_forward` set to `1`** where needed.
  仔细检查是否在需要时将 `/proc/sys/net/ipv4/ip_forward` 设置为 `1` 。
- When injecting the VPN users into an existing network, without routing, make sure **`/proc/sys/net/ipv4/conf/all/proxy_arp` is set to `1`**.
  当将VPN用户注入现有网络时，如果没有路由，请确保将 `/proc/sys/net/ipv4/conf/all/proxy_arp` 设置为 `1` 。
- Make sure the above `/proc` entries are in **`/etc/sysctl.conf` or a file in `/etc/sysctl.d`** so that they persist reboots.
  确保上述 `/proc` 条目在 `/etc/sysctl.conf` 中或 `/etc/sysctl.d` 中的文件中，以便它们持久化重新引导。

## The watch wg command watch wg命令 

It can be helpful to leave a terminal open with the `watch wg` command. Here is a sample output showing a system with two peers configured, where only one has established the VPN so far:
使用 `watch wg` 命令使终端保持打开状态可能会有所帮助。下面是一个示例输出，显示了配置了两个对等方的系统，其中到目前为止只有一个对等方建立了VPN：

```bash
Every 2.0s: wg                j-wg: Fri Aug 26 17:44:37 2022

interface: wg0
  public key: +T3T3HTMeyrEDvim8FBxbYjbz+/POeOtG3Rlvl9kJmM=
  private key: (hidden)
  listening port: 51000

peer: 2cJdFcNzXv4YUGyDTahtOfrbsrFsCByatPnNzKTs0Qo=
  endpoint: 10.172.196.106:51000 
  allowed ips: 10.10.11.2/32
  latest handshake: 3 hours, 27 minutes, 35 seconds ago
  transfer: 3.06 KiB received, 2.80 KiB sent

peer: ZliZ1hlarZqvfxPMyME2ECtXDk611NB7uzLAD4McpgI=
  allowed ips: 10.10.11.3/32
```

## Kernel debug messages 内核调试消息 

WireGuard is also silent when it comes to logging. Being (essentially) a kernel  module, we need to explicitly enable verbose logging of its module. This is done with the following command:
WireGuard在日志记录方面也是沉默的。作为（本质上）一个内核模块，我们需要显式地启用其模块的详细日志记录。这是通过以下命令完成的： 

```bash
$ echo "module wireguard +p" | sudo tee /sys/kernel/debug/dynamic_debug/control
```

This will write WireGuard logging messages to the kernel log, which can be watched live with:
这将把WireGuard日志记录消息写入内核日志，可以通过以下方式实时观看： 

```bash
$ sudo dmesg -wT
```

To disable logging, run this:
要禁用日志记录，请运行以下命令： 

```bash
$ echo "module wireguard -p" | sudo tee /sys/kernel/debug/dynamic_debug/control
```

## Destination address required 需要目的地地址 

If you ping an IP and get back an error like this:
如果你ping一个IP并得到这样的错误： 

```bash
$ ping 10.10.11.2
PING 10.10.11.2 (10.10.11.2) 56(84) bytes of data.
From 10.10.11.1 icmp_seq=1 Destination Host Unreachable
ping: sendmsg: Destination address required
```

This is happening because the WireGuard interface selected for this  destination doesn’t know the endpoint for it. In other words, it doesn’t know where to send the encrypted traffic.
这是因为为该目的地选择的WireGuard接口不知道它的端点。换句话说，它不知道将加密流量发送到哪里。 

One common scenario for this is on a peer where there is no `Endpoint` configuration, which is perfectly valid, and the host is trying to send traffic to that peer. Let’s take the coffee shop scenario we described  earlier as an example.
一种常见的情况是，在没有完全有效的 `Endpoint` 配置的对等体上，主机正在尝试向该对等体发送流量。让我们以前面描述的咖啡店场景为例。

The laptop is connected to the VPN and exchanging traffic as usual. Then it stops for a bit (the person went to get one more cup). Traffic ceases  (WireGuard is silent, remember). If the WireGuard on the home router is  now restarted, when it comes back up, it won’t know how to reach the  laptop, because it was never contacted by it before. This means that at  this time, if the home router tries to send traffic to the laptop in the coffee shop, it will get the above error.
笔记本电脑连接到VPN并像往常一样交换流量。然后它停了一会儿（这个人又去拿了一杯）。通信停止（WireGuard是无声的，记住）。如果家庭路由器上的WireGuard现在重新启动，当它重新启动时，它将不知道如何到达笔记本电脑，因为它以前从未联系过它。这意味着，此时，如果家庭路由器尝试向咖啡店中的笔记本电脑发送流量，就会得到上述错误。 

Now the laptop user comes back, and generates some traffic to the home network (remember: the laptop has the home network’s `Endpoint` value). The VPN “wakes up”, data is exchanged, handshakes are completed, and now the home router knows the `Endpoint` associated with the laptop, and can again initiate new traffic to it without issues.
现在，笔记本电脑用户回来了，并生成了一些到家庭网络的流量（记住：笔记本电脑具有家庭网络的 `Endpoint` 值）。VPN“醒来”，交换数据，完成握手，现在家庭路由器知道与笔记本电脑相关联的 `Endpoint` ，并且可以再次向其发起新流量而不会出现问题。

Another possibility is that one of the peers is behind a NAT, and there wasn’t  enough traffic for the stateful firewall to consider the “connection”  alive, and it dropped the NAT mapping it had. In this case, the peer  might benefit from the `PersistentKeepalive` configuration, which makes WireGuard send a *keepalive* probe every so many seconds.
另一种可能性是，其中一个对等体位于NAT之后，并且没有足够的流量让状态防火墙认为“连接”是活动的，因此它丢弃了它所拥有的NAT映射。在这种情况下，对等体可能会从 `PersistentKeepalive` 配置中受益，该配置使WireGuard每隔这么多秒发送一次keepalive探测。

## Required key not available 所需密钥不可用 

This error: 此错误： 

```bash
$ ping 10.10.11.1 
PING 10.10.11.1 (10.10.11.1) 56(84) bytes of data.
From 10.10.11.2 icmp_seq=1 Destination Host Unreachable
ping: sendmsg: Required key not available
```

Can happen when you have a route directing traffic to the WireGuard  interface, but that interface does not have the target address listed in its `AllowedIPs` configuration.
当您有一个路由将流量定向到WireGuard接口，但该接口的 `AllowedIPs` 配置中没有列出目标地址时，可能会发生这种情况。

If you have enabled kernel debugging for WireGuard, you will also see a message like this one in the `dmesg` output:
如果你已经为WireGuard启用了内核调试，你也会在 `dmesg` 输出中看到这样的消息：

```auto
wireguard: home0: No peer has allowed IPs matching 10.10.11.1
```

------