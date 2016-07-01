# Zabbix

a.从windows下控制面板->字体->选择一种中文字库，例如“微软雅黑”

b.把它拷贝到zabbix的web端的fonts目录下例如：/usr/local/apache2/htdocs/zabbix/fonts，并且把TTF后缀改为ttf

c.修改zabbix的web端 include/defines.inc.php

# cd /usr/local/apache2/htdocs/zabbix

# vi include/defines.inc.php

搜索 'DejaVuSans'

用"//"注释掉系统默认行，并添加新的字体参数行。

其中msyh为字库名字,不包含ttf后缀

----------------------

//define('ZBX_FONT_NAME', 'DejaVuSans');

define('ZBX_FONT_NAME', 'msyh');


//define('ZBX_GRAPH_FONT_NAME', 'DejaVuSans');

define('ZBX_GRAPH_FONT_NAME', 'msyh');


3.监控windows主机：

下载地址：http://www.zabbix.com/downloads/2.0.6/zabbix_agents_2.0.6.win.zip

在C:\Program Files\下创建zabbix文件夹

解压zip包后：将包内bin/win64/下的所有文件复制到 C:\Program Files\zabbix下

并在该目录下创建一个zabbix_agentd.conf文件，内容为

-------------------

LogFile=C:\Program Files\zabbix\zabbix_agentd.log

Server=192.168.7.11

UnsafeUserParameters=1

-------------------

进入cmd命令行：

# cd C:\Program Files\zabbix

安装zabbix客户端：

# zabbix_agentd.exe -c "c:\Program Files\zabbix\zabbix_agentd.conf" -i

启动zabbix服务：

# zabbix_agentd.exe -c "c:\Program Files\zabbix\zabbix_agentd.conf" -s

参数含义：

-c    制定配置文件所在位置

-i    安装客户端

-s    启动客户端

-x    停止客户端

-d    卸载客户端

如图:

1

在服务端添加客户端主机监控同上。。
