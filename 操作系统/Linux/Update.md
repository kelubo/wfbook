# update
## Ubuntu

    sudo apt-get update
    sudo apt-get upgrade

这个命令不会更新内核和其它一些包，所以也必须要运行下面这个命令：

    sudo apt-get dist-upgrade

## openSUSE

    sudo zypper refresh
    sudo zypper up

## Fedora

    sudo dnf update
    sudo dnf upgrade

## RHEL/CentOS

    sudo yum update
    sudo yum upgrade

### 自动更新

    # yum update -y && yum install yum-cron -y

#### CentOS/RHEL 7

    /etc/yum/yum-cron.conf

    update_cmd = security
    update_messages = yes
    download_updates = yes
    apply_updates = yes

    emit_via = email
    email_from = root@localhost
    email_to = root

#### CentOS/RHEL 6

默认情况下， cron 任务被配置成了立即下载并安装所有更新，可以通过在 /etc/sysconfig/yum-cron 配置文件中把下面两个参数改为 yes，从而改变这种行为。

    # 不要安装，只做检查（有效值： yes|no）
    CHECK_ONLY=yes
    # 不要安装，只做检查和下载（有效值： yes|no）
    # 要求 CHECK_ONLY=yes（先要检查后才可以知道要下载什么）
    DOWNLOAD_ONLY=yes

为了启用关于安装包更新的邮件通知，你需要把 MAILTO 参数设置为一个有效的邮件地址。

    # 默认情况下 MAILTO 是没有设置的，crond 会将输出发送邮件给自己
    # （LCTT 译注：执行 cron 的用户，这里是 root）
    # 例子： MAILTO=root
    MAILTO=admin@tecmint.com

#### 打开并启用 yum-cron 服务：

    ------------- On CentOS/RHEL 7 -------------
    systemctl start yum-cron
    systemctl enable yum-cron
    ------------- On CentOS/RHEL 6 -------------  
    # service yum-cron start
    # chkconfig --level 35 yum-cron on
