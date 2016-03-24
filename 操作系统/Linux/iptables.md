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
