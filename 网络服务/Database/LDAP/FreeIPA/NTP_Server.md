# NTP Server

Kerberos协议对KDC和认证节点之间适当的时间同步是非常敏感的。时差超过几分钟，认证将无法进行。由于这个原因，服务器安装者在每一台FreeIPA服务器上配置NTP服务(此时是ntpd)。 
##Known NTP services

Client and server installers detect 2 time synchronization services - ntpd and chrony. While on the FreeIPA server ntpd is required as chrony only provides NTP client services, the Client accepts already configured chrony. In future versions, chronyd configuration should be preferred. 