# OpenHPC (v1.0)
# Cluster Building Recipes
## CentOS 7.1 Base OS
### Base Linux* Edition
Document Last Update:2015-11-12  
Document Revision:bf8c471
## 1 Introduction
This guide presents a simple cluster installation procedure using components from the OpenHPC software stack.
### 1.1 Target Audience
### 1.2 Requirements/Assumptions
### 1.3 Bring your own license
### 1.4 Inputs
## 2 Install Base Operating System (BOS)
## 3 Install OpenHPC Components
### 3.1 Enable OpenHPC repository for local use

    [sms]# ohpc_repo=http://build.openhpc.community\ 
    /OpenHPC:/1.0/CentOS_7.1/OpenHPC:1.0.repo
    [sms]# wget -P /etc/yum.repos.d ${ohpc_repo}

### 3.2 Installation template

### 3.3 Add provisioning services on master node

    [sms]# yum -y groupinstall ohpc-base
    [sms]# yum -y groupinstall ohpc-warewulf
    [sms]# systemctl disable firewalld
    [sms]# systemctl stop firewalld
    [sms]# systemctl enable ntpd.service
    [sms]# echo "server ${ntp_server}" >> /etc/ntp.conf
    [sms]# systemctl restart ntpd
### 3.4 Add resource management services on master node

    [sms]# yum -y groupinstall ohpc-slurm-server
    [sms]# useradd slurm
### 3.5 Add InfiniBand support services on master node

    [sms]# yum -y groupinstall "InfiniBand Support"
    [sms]# yum -y install infinipath-psm
    # Load IB drivers
    [sms]# systemctl start rdma 
### 3.6 Complete basic Warewulf setup for master node
### 3.7 Define compute image for provisioning
#### 3.7.1 Build initial BOS image
#### 3.7.2 Add OpenHPC components
#### 3.7.3 Customize System configuration
#### 3.7.4 Additional Customizations (optional)
##### 3.7.4.1 Increase locked memory limits
##### 3.7.4.2 Enable ssh control via resource manager
##### 3.7.4.3 Add Cluster Checker
##### 3.7.4.4 Add Lustre Client
##### 3.7.4.5 Add Nagios monitoring
##### 3.7.4.6 Add Ganglia monitoring
##### 3.7.4.7 Enable forwarding of system logs
#### 3.7.5 Import files
### 3.8 Finalizing provisioning configuration
#### 3.8.1 Assemble bootstrap image
#### 3.8.2 Assemble Virtual Node File System (VNFS)image
#### 3.8.3 Register nodes for provisioning
### 3.9 Boot compute nodes
## 4.Install OpenHPC Development Components
### 4.1 Development Tools
### 4.2 Compilers
### 4.3 Performance Tools
### 4.4 MPI Stacks
### 4.5 Setup default development environment
### 4.6 3rd Party Libraries and Tools
## 5.Resource Manager Startup
## 6.Run a Test Job
### 6.1 Interactive execution
### 6.2 Batch execution
## Appendices
### A Installation Template
### B Package Manifest
### C Package signatures