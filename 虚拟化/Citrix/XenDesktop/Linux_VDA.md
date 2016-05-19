# Linux VDA
## 确认网络配置
1. 设置hostname
2. 配置hosts文件

    127.0.0.1 hostname-fqdn hostname localhost localhost.localdomain localhost4 localhost4.localdomain4

3. 确认hostname

    hostname -f

4. 确认DNS解析和DDC的连通性

    nslookup domain-controller-fqdn
    ping domain-controller-fqdn
    nslookup delivery-controller-fqdn
    ping delivery-controller-fqdn

5. 配置时间同步
NTP & Chrony

6. 禁用Network Proxy Authentication Popup(貌似CentOS6不可用)
创建/etc/polkit-1/localauthority/30-site.d/20-no-show-proxy-dialog.pkla

    [No Show Proxy Dialog]
    Identity=unix-user:*
    Action=org.freedesktop.packagekit.system-network-proxy-configure
    ResultAny=no
    ResultInactive=no
    ResultActive=no

7. 安装OpenJDK(此处CentOS6不同，需要确认)

    yum install java-1.7.0-openjdk
    export JAVA_HOME=/usr/lib/jvm/java

8. 安装PostgreSQL

    yum install postgresql-server
    yum install postgresql-jdbc

CentOS 6:

    service postgresql initdb

CentOS 7:

    service postgresql-setup initdb

    chkconfig postgresql on
    service postgresql start

9. Motif

    yum install openmotif
    yum install motif

10. Other

    yum install redhat-lsb-core
    yum install ImageMagick


