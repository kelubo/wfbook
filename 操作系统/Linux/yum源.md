# YUM 源
## 系统分区建议
建议/var分区空间尽可能大一些，以便于存放需要的源文件。

## 安装HTTP服务

    yum install httpd
    systemctl start httpd.service
    systemctl enable httpd.service

## 同步YUM源文件

    mkdir /var/www/html/centos
    touch /var/www/html/centos/exclude.txt
    rsync -av --exclude-from=/var/www/html/centos/exclude.txt rsync://mirrors.yun-idc.com/centos /var/www/html/centos
