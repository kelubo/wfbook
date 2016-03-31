# Ansible

## 安装要求
支持SSH
Python 2.6

## 安装
### 从源码安装

    $ git clone git://github.com/ansible/ansible.git --recursive
    $ cd ./ansible
    $ source ./hacking/env-setup
    $ sudo easy_install pip  //如果未安装pip，执行此命令
    $ sudo pip install paramiko PyYAML Jinja2 httplib2

### YUM安装

    # yum install ansible

### Apt安装

    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get update
    $ suod apt-get install ansible

### Portage(Gentoo)安装

    $ emerge -av app-admin/ansible

### pkg(FreeBSD)安装

    $ sudo pkg install ansible

### Homebrew(Mac OS X)安装

    $ brew update
    $ brew install ansible

### Pip安装

    $ sudo pip install ansible
