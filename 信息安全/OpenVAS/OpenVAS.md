# OpenVAS
## ## 安装

### RHEL/CentOS/Fedora

**Step 1:** 配置 Atomicorp Repository

    wget -q -O - http://www.atomicorp.com/installers/atomic |sh

**Step 2:**  Quick-Install OpenVAS

    yum upgrade
    yum install openvas
    openvas-setup

Step 3: Quick-Start OpenVAS  
( nothing to do, all is up and running directly after installation )

Step 4: 使用step 2中创建的账户登录OpenVAS。   
访问https://localhost:9392/



​                                         



```
vim /etc/selinux/config

修改参数：
SELINUX=disabled

更新：
yum -y update

重启：
reboot

安装依赖：
yum install -y wget bzip2 texlive net-tools alien gnutls-utils

添加仓库：
wget -q -O - https://www.atomicorp.com/installers/atomic | sh

安装：
yum install openvas -y

编辑文件：
vim /etc/redis.conf
修改配置：
unixsocket /tmp/redis.sock
unixsocketperm 700

重启redis：
systemctl enable redis && systemctl restart redis

启动openvas初始环境配置：
openvas-setup

防火墙放行端口：
firewall-cmd --permanent --add-port=9392/tcp
firewall-cmd --reload
firewall-cmd --list-port

访问登录：
https://本机IP:9392

验证完整性以及运行的可靠性：
openvas-check-setup --v9


据部分用户反馈可能出现一些故障，临时解决办法，但我没遇到：
# yum -y install texlive-changepage texlive-titlesec
# mkdir -p /usr/share/texlive/texmf-local/tex/latex/comment
# cd /usr/share/texlive/texmf-local/tex/latex/comment
#wget http://mirrors.ctan.org/macros/latex/contrib/comment/comment.sty
# chmod 644 comment.sty
# texhash
```

另：其中非特殊需要，里面的配置尽量默认就好。仅供学习交流。这东西用着挺爽的。更新速度和自己网络环境有关，条件允许情况下，可以用阿里云的国外节点，或者zun云的国外九元优惠节点，其他的有推荐的请留言。毕竟省钱还好用的才是我们需要的。亚马逊那个需要信用卡，有一定的失败率，谷歌的就直接不想了。