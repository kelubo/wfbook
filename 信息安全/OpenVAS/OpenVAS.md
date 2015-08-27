# OpenVAS
## RHEL/CentOS/Fedora
**Step 1:** Configure Atomicorp Repository
(as user root, only once)

    wget -q -O - http://www.atomicorp.com/installers/atomic |sh

Step 2: Quick-Install OpenVAS
(as user root, only once)

    yum upgrade
    yum install openvas
    openvas-setup

Step 3: Quick-Start OpenVAS  
( nothing to do, all is up and running directly after installation )

Step 4: 使用step 2中创建的账户登录OpenVAS。   
访问https://localhost:9392/