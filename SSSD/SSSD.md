# SSSD
系统安全服务守护进程(System Security Services Daemon)  

红帽企业版Linux6中加入的一个守护进程，可以用来访问多种验证服务器，如LDAP，Kerberos等，并提供授权。是介于本地用户和数据存储之间的进程，本地客户端首先连接SSSD，再由SSSD联系外部资源提供者(一台远程服务器)。  

**优势：**  
1.避免了本地每个客户端程序对认证服务器大量连接，所有本地程序仅联系SSSD，由SSSD连接认证服务器或SSSD缓存，有效的降低了负载。  
2.允许离线授权。SSSD可以缓存远程服务器的用户认证身份，这允许在远程认证服务器宕机是，继续成功授权用户访问必要的资源。  

SSSD无需特殊设置即可运行，当配置完system-configure-authentication后该服务会自己运行。
SSSD默认配置文件位于/etc/sssd/sssd.conf，你可以通过命令使得SSSD以指定的配置文件运行：

    # sssd  --c  /etc/sssd/customfile.conf
    
配置文件格式如下:
 
    关键字=键值
    #####################################################
    ##  [section]                                      ##
    ##  key1 = value1                                  ##
    ##  key2 = value2,value3                           ##
    #####################################################
 
管理SSSD进程

    service  sssd  start 开启
    service  sssd  stop 关闭

使用authconfig命令开启SSSD：

    # authconfig  --enablesssd  --update

使用systemctl命令开启SSSD：

    # systemctl  enable  sssd
 
总结：简单来说现在在RHEL6中连接LDAP或Kerberos等认证服务器，都是先由SSSD连接认证服务器取得认证与授权信息，再交于本地客户端程序。