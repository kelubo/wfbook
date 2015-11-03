# SNTP
1）配置SNTP Server的地址  
网络上存在着较多的NTP Server，您可以选择一个网络延迟较少的一个作为设备上的SNTP Server。具体的NTP server 地址可以登录http://www.time.edu.cn/或http://www.ntp.org/上获取。如192.43.244.18(time.nist.gov)。

    Ruijie(config)# sntp server 192.43.244.18
2）配置SNTP同步时钟的间隔

    Ruijie(config)# sntp interval 1800
    //设置每半个小时间隔与SNTP服务器同步下时间
3）配置本地时区

    Ruijie(config)# clock timezone 8
    //默认是GMT时间，对中国用户需设置为东八区，否则时间会相差8小时
4）打开SNTP功能

    Ruijie(config)# sntp enable              //必须使能SNTP功能