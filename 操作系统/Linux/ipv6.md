# ipv6
## CentOS 7 禁用 ipv6

    echo -e 'net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p
