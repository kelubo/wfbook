# Bonding
Linux上双网卡绑定实现就是使用两块网卡虚拟成为一块网卡，这个结合起来的设备看起来是一个单独的以太网接口设备（两块网卡具有相同的IP地址而并行链接聚合成一个逻辑链路工作）。在Sun和Cisco中被称为Trunking和Etherchannel技术，在Linux的2.4.x的内核中也采用这种技术，被称为bonding。

bonding技术的最早应用是在集群——beowulf上，为了提高集群节点间的数据传输而设计的。在正常情况下，网卡只接收目的硬件地址(MAC Address)是自身Mac的以太网帧，对于别的数据帧都滤掉，以减轻驱动程序的负担。网卡也支持另外一种被称为混杂promisc的模式，可以接收网络上所有的帧，比如说tcpdump，就是运行在这个模式下。bonding也运行在这个模式下，而且修改了驱动程序中的mac地址，将两块网卡的Mac地址改成相同，可以接收特定MAC的数据帧。然后把相应的数据帧传送给bond驱动程序处理。  
## RHEL 5/6 配置
### 备份网卡配置文件  
    [root@redhat5 ~]# cp /etc/sysconfig/network-scripts/ifcfg-eth0 ~/ifcfg-eth0.bak  
    [root@redhat5 ~]# cp /etc/sysconfig/network-scripts/ifcfg-eth1 ~/ifcfg-eth1.bak

### 配置绑定  
虚拟网络接口配置文件，指定网卡IP，ifcfg-bond0：  

    root@redhat5 ~]#vi /etc/sysconfig/network-scripts/ifcfg-bond0  
    DEVICE=bond0  
    IPADDR=192.168.1.11  
    NETMASK=255.255.255.0  
    ONBOOT=yes  
    BOOTPROTO=none  
    USERCTL=no  
    NM_CONTROLLED=no                  //6中此项禁掉networkmanager
    BONDING_OPTS="mode=1 miimon=100"  //设置网卡的运行模式，也可以在配置文件中设置  

miimon是用来进行链路监测的。比如:miimon=100，那么系统每100ms监测一次链路连接状态，如果有一条线路不通就转入另一条线路；模式1为主备模式。

### 配置真实的网卡，eth0 和 eth1
    [root@redhat5 ~]#vi /etc/sysconfig/network-scripts/ifcfg-eth<N>
    DEVICE=eth<N>
    BOOTPROTO=none
    ONBOOT=yes
    MASTER=bond0
    SLAVE=yes
    USERCTL=no
    NM_CONTROLLED=no

### 加载模块，让系统支持bonding
修改/etc/modprobe.conf配置  

    alias bond0 bonding

### 重启网络服务

    [root@redhat5 ~]#service network restart

### 测试网络
拔下一根网线看ping数据，确认没问题之后插上该网线连通之后，再拔下另外一根网线，观察双网卡绑定效果。
## Bonding的7种模式
    1.BOND_MODE_ROUNDROBIN 0 （balance-rr模式）网卡的负载均衡模式。需要交换机支持及设定。轮询模式，所绑定的网卡会针对访问以轮询算法进行平分。
    2.BOND_MODE_ACTIVEBACKUP 1 （active-backup模式）网卡的容错模式。其中一条线若断线，其他线路将会自动备援。在负载不超过单块网卡带宽或压力时建议使用。
    3.BOND_MODE_XOR 2 （balance-xor模式）需要交换机支持。基于HASH算法的负载均衡模式，网卡的分流按照xmit_hash_policy的TCP协议层设置来进行HASH计算分流，使各种不同处理来源的访问都尽量在同一个网卡上进行处理。
    4.BOND_MODE_BROADCAST 3 （broadcast模式）广播模式，所有被绑定的网卡都将得到相同的数据，一般用于十分特殊的网络需求，如需要对两个互相没有连接的交换机发送相同的数据。
    5.BOND_MODE_8023AD 4 （IEEE 802.3ab动态链路聚合模式）需要交换机支持。在交换机支持LACP时推荐使用，其能提供更好的性能和稳定性。理论上服务器及交换机都支持此模式时，网卡带宽最高可以翻倍(如从1Gbps翻到2Gbps)  
    6.BOND_MODE_TLB 5 自适应传输负载均衡模式。适配器输出负载均衡模式，输出的数据会通过所有被绑定的网卡输出，接收数据时则只选定其中一块网卡。如果正在用于接收数据的网卡发生故障，则由其他网卡接管，要求所用的网卡及网卡驱动可通过ethtool命令得到speed信息。  
    7.BOND_MODE_ALB 6 网卡虚拟化方式。平衡负载模式，有自动备援，不需要”Switch”支援及设定。适配器输入/输出负载均衡模式，在”模式5″的基础上，在接收数据的同时实现负载均衡，除要求ethtool命令可得到speed信息外，还要求支持对网卡MAC地址的动态修改功能。
mode的值共有0-6 七种模式，常用的为0，1，6三种。  