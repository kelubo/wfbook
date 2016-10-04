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
