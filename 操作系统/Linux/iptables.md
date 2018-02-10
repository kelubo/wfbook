# iptables
## CentOS 7 替换 Firewalld 为 iptables

    systemctl mask firewalld
    systemctl stop firewalld
    yum install iptables-devel
    yum install iptables-service iptables
    systemctl enable iptables
    yum install iptables-services
    systemctl enable iptables
    systemctl start iptables



## 例子

### 步骤 1 启用 IP 转发

第一步，我们启用 IP 转发。 这一步在 RHEL/CentOS 6 和 7 上是相同的。 运行

```
$ sysctl -w net.ipv4.ip_forward=1
```

但是这样会在系统重启后恢复。要让重启后依然生效需要打开

```
$ vi /etc/sysctl.conf
```

然后输入下面内容，

```
net.ipv4.ip_forward = 1
```

保存并退出。现在系统就启用 IP 转发了。

### 步骤 2 配置 IPtables/Firewalld 的规则

下一步我们需要启动 IPtables/firewalld 服务并配置 NAT 规则，

```
$ systemctl start firewalld (For Centos/RHEL 7)$ service iptables start  (For Centos/RHEL 6)
```

然后运行下面命令来配置防火墙的 NAT 规则：

```
CentOS/RHEL 6$ iptables -t nat -A POSTROUTING -o XXXX -j MASQUERADE$ service iptables restart CentOS/RHEL 7$ firewall-cmd  -permanent -direct -passthrough ipv4 -t nat -I POSTROUTING -o XXXX -j MASQUERADE -s 192.168.1.0/24$ systemctl restart firewalld
```

这里，`XXXX` 是配置有外网 IP 的那个网卡名称。 这就将 Linux 机器配置成了路由器了， 下面我们就可以配置客户端然后测试路由器了。

### 步骤 3 配置客户端

要测试路由器，我们需要在客户端的网关设置成内网 IP， 本例中就是 192.168.1.1。 因此不管客户机是 Windows 还是 Linux， 请先确保网关是 192.168.1.1。 完成后， 打开终端或命令行并 `ping` 一个网站来测试客户端是否能访问互联网了：

```
$ ping google.com
```

我们也可以通过网络浏览器访问网站的方式来检查。