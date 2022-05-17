## 部署 RGW

[TOC]

​			作为存储管理员，您可以使用命令行界面或使用服务规格来部署 Ceph 对象网关。 	

​			您还可以配置多站点对象网关，并使用 Ceph 编排器移除 Ceph 对象网关。 	

​			Cephadm 将 Ceph 对象网关部署为一组守护进程，这些守护进程在多站点部署中管理单一集群部署或特定的域和区域。 	

# 使用命令行界面部署 Ceph 对象网关

​				使用 Ceph 编排器，您可以在命令行界面中使用 `ceph orch` 命令来部署 Ceph 对象网关 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						您可以通过三种不同的方式部署 Ceph 对象网关守护进程： 				

**方法 1**

- ​						创建 realm、zone group 和 zone，然后将放置规格与主机名搭配使用： 				

  1. ​								创建一个域： 						

     **语法**

     ​									

     ```none
     radosgw-admin realm create --rgw-realm=REALM_NAME --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin realm create --rgw-realm=test_realm --default
     ```

  2. ​								创建区组： 						

     **语法**

     ​									

     ```none
     radosgw-admin zonegroup create --rgw-zonegroup=ZONE_GROUP_NAME  --master --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin zonegroup create --rgw-zonegroup=default  --master --default
     ```

  3. ​								创建区： 						

     **语法**

     ​									

     ```none
     radosgw-admin zone create --rgw-zonegroup=ZONE_GROUP_NAME --rgw-zone=ZONE_NAME --master --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin zone create --rgw-zonegroup=default --rgw-zone=test_zone --master --default
     ```

  4. ​								提交更改： 						

     **语法**

     ​									

     ```none
     radosgw-admin period update --rgw-realm=REALM_NAME --commit
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin period update --rgw-realm=test_realm --commit
     ```

  5. ​								运行 `ceph orch apply` 命令： 						

     **语法**

     ​									

     ```none
     ceph orch apply rgw NAME [--realm=REALM_NAME] [--zone=ZONE_NAME] --placement="NUMBER_OF_DAEMONS [HOST_NAME_1 HOST_NAME_2]"
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph orch apply rgw test --realm=test_realm --zone=test_zone --placement="2 host01 host02"
     ```

**方法 2**

- ​						使用任意服务名称为单个集群部署部署两个 Ceph 对象网关守护进程： 				

  **语法**

  ​							

  ```none
  ceph orch apply rgw SERVICE_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch apply rgw foo
  ```

**方法 3**

- ​						在标记的一组主机上使用任意服务名称： 				

  **语法**

  ​							

  ```none
  ceph orch host label add HOST_NAME_1 LABEL_NAME
  ceph orch host label add HOSTNAME_2 LABEL_NAME
  ceph orch apply rgw SERVICE_NAME '--placement=label:_LABEL_NAME_ count-per-host:_NUMBER_OF_DAEMONS_' --port=8000
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch host label add host01 rgw  # the 'rgw' label can be anything
  [ceph: root@host01 /]# ceph orch host label add host02 rgw
  [ceph: root@host01 /]# ceph orch apply rgw foo '--placement=label:rgw count-per-host:2' --port=8000
  ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=rgw
  ```

# 使用服务规格部署 Ceph 对象网关

​				利用 Ceph 编排器，您可以使用服务规格部署 Ceph 对象网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						进入以下目录： 				

   **语法**

   ​							

   ```none
   cd /var/lib/ceph/DAEMON_PATH/
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs/]# cd /var/lib/ceph/rgw/
   ```

   ​						如果 `rgw` 目录不存在，请在路径中创建 目录。 				

3. ​						创建 `rgw.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 rgw]# touch rgw.yml
   ```

4. ​						编辑 `rgw.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
   service_type: rgw
   service_id: REALM_NAME.ZONE_NAME
   placement:
     hosts:
     - HOST_NAME_1
     - HOST_NAME_2
   spec:
     rgw_realm: REALM_NAME
     rgw_zone: ZONE_NAME
   networks:
     -  NETWORK_IP_ADDRESS # RGW service binds to a specific network
   ```

   **示例**

   ​							

   ```none
   service_type: rgw
   service_id: test_realm.test_zone
   placement:
     hosts:
     - host01
     - host02
     - host03
   spec:
     rgw_realm: test_realm
     rgw_zone: test_zone
   networks:
     - 192.169.142.0/24
   ```

5. ​						使用服务规格部署 Ceph 对象网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 rgw]# ceph orch apply -i rgw.yml
   ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=rgw
  ```

# 使用 Ceph 编排器部署多站点 Ceph 对象网关

​				Ceph 编排器支持用于 Ceph 对象网关的多站点配置选项。 		

​				您可以将每个对象网关配置为在主动区域配置中工作，从而允许写入到非主要区域。多站点配置存储在名为 realm 的容器中。 		

​				realm 存储 zone group、区域和一个时间周期。`rgw` 守护进程处理同步消除了对独立同步代理的需求，因此使用主动-主动配置运行。 		

​				您还可以使用命令行界面(CLI)部署多站点区域。 		

注意

​					以下配置假定在地理上至少有两个红帽 Ceph 存储集群。但是，配置也在同一站点工作。 			

**先决条件**

- ​						至少两个正在运行的 Red Hat Ceph Storage 集群 				
- ​						至少两个 Ceph 对象网关实例，每个实例对应一个红帽 Ceph 存储集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						节点或容器添加到存储集群中。 				
- ​						部署所有 Ceph 管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						在 `cephadm` shell 中，配置主区： 				

   1. ​								创建一个域： 						

      **语法**

      ​									

      ```none
      radosgw-admin realm create --rgw-realm=REALM_NAME --default
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin realm create --rgw-realm=test_realm --default
      ```

      ​								如果存储集群只有一个域，则指定 `--default` 标志。 						

   2. ​								创建主要区组： 						

      **语法**

      ​									

      ```none
      radosgw-admin zonegroup create --rgw-zonegroup=ZONE_GROUP_NAME --endpoints=http://RGW_PRIMARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ --master --default
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zonegroup create --rgw-zonegroup=us --endpoints=http://rgw1:80 --master --default
      ```

   3. ​								创建一个主要区： 						

      **语法**

      ​									

      ```none
      radosgw-admin zone create --rgw-zonegroup=PRIMARY_ZONE_GROUP_NAME --rgw-zone=PRIMARY_ZONE_NAME --endpoints=http://RGW_PRIMARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zone create --rgw-zonegroup=us --rgw-zone=us-east-1 --endpoints=http://rgw1:80
      ```

   4. ​								可选：删除默认 zone、zone group 和关联的池： 						

      重要

      ​									如果您使用默认 zone 和 zone group 存储数据，则不要删除默认区域及其池。此外，删除默认 zone group 也会删除系统用户。 							

      **示例**

      ​										

      ```none
      [ceph: root@host01 /]# radosgw-admin zonegroup delete --rgw-zonegroup=default
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.log default.rgw.log --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.meta default.rgw.meta --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.control default.rgw.control --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.data.root default.rgw.data.root --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.gc default.rgw.gc --yes-i-really-really-mean-it
      ```

   5. ​								创建系统用户： 						

      **语法**

      ​									

      ```none
      radosgw-admin user create --uid=USER_NAME --display-name="USER_NAME" --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY --system
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin user create --uid=zone.user --display-name="Zone user" --system
      ```

      ​								记录 `access_key` 和 `secret_key`。 						

   6. ​								在主区中添加 access key 和 system key： 						

      **语法**

      ​									

      ```none
      radosgw-admin zone modify --rgw-zone=PRIMARY_ZONE_NAME --access-key=ACCESS_KEY --secret=SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zone modify --rgw-zone=us-east-1 --access-key=NE48APYCAODEPLKBCZVQ--secret=u24GHQWRE3yxxNBnFBzjM4jn14mFIckQ4EKL6LoW
      ```

   7. ​								提交更改： 						

      **语法**

      ​									

      ```none
      radosgw-admin period update --commit
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin period update --commit
      ```

   8. ​								在 `cephadm` shell 外部，获取存储集群的 `FSID` 及进程： 						

      **示例**

      ​									

      ```none
      [root@host01 ~]#  systemctl list-units | grep ceph
      ```

   9. ​								启动 Ceph 对象网关守护进程： 						

      **语法**

      ​									

      ```none
      systemctl start ceph-FSID@DAEMON_NAME
      systemctl enable ceph-FSID@DAEMON_NAME
      ```

      **示例**

      ​									

      ```none
      [root@host01 ~]# systemctl start ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-1.host01.ahdtsw.service
      [root@host01 ~]# systemctl enable ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-1.host01.ahdtsw.service
      ```

2. ​						在 Cephadm shell 中，配置 second zone。 				

   1. ​								使用 primary zone 和 primary zone group 的 URL 路径、访问密钥和 secret 密钥，并从主机拉取 realm 配置： 						

      **语法**

      ​									

      ```none
      radosgw-admin period pull --url=URL_TO_PRIMARY_ZONE_GATEWAY --access-key=ACCESS_KEY --secret-key=SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin period pull --url=http://10.74.249.26:80 --access-key=LIPEYZJLTWXRKXS9LPJC --secret-key=IsAje0AVDNXNw48LjMAimpCpI7VaxJYSnfD0FFKQ
      ```

   2. ​								配置 second zone: 						

      **语法**

      ​									

      ```none
      radosgw-admin zone create --rgw-zonegroup=ZONE_GROUP_NAME \
                   --rgw-zone=SECONDARY_ZONE_NAME --endpoints=http://RGW_SECONDARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ \
                   --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY \
                   --endpoints=http://FQDN:80 \
                   [--read-only]
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin zone create --rgw-zonegroup=us --rgw-zone=us-east-2 --endpoints=http://rgw2:80 --access-key=LIPEYZJLTWXRKXS9LPJC --secret-key=IsAje0AVDNXNw48LjMAimpCpI7VaxJYSnfD0FFKQ
      ```

   3. ​								可选：删除默认区： 						

      重要

      ​									如果您使用默认 zone 和 zone group 存储数据，则不要删除默认区域及其池。 							

      **示例**

      ​										

      ```none
      [ceph: root@host04 /]# radosgw-admin zone rm --rgw-zone=default
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.log default.rgw.log --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.meta default.rgw.meta --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.control default.rgw.control --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.data.root default.rgw.data.root --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.gc default.rgw.gc --yes-i-really-really-mean-it
      ```

   4. ​								更新 Ceph 配置数据库： 						

      **语法**

      ​									

      ```none
      ceph config set _SERVICE_NAME_ rgw_zone _SECONDARY_ZONE_NAME_
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# ceph config set rgw rgw_zone us-east-2
      ```

   5. ​								提交更改： 						

      **语法**

      ​									

      ```none
      radosgw-admin period update --commit
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin period update --commit
      ```

   6. ​								在 Cephadm shell 外，获取存储集群的 FSID 及进程： 						

      **示例**

      ​									

      ```none
      [root@host04 ~]#  systemctl list-units | grep ceph
      ```

   7. ​								启动 Ceph 对象网关守护进程： 						

      **语法**

      ​									

      ```none
      systemctl start ceph-FSID@DAEMON_NAME
      systemctl enable ceph-FSID@DAEMON_NAME
      ```

      **示例**

      ​									

      ```none
      [root@host04 ~]# systemctl start ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-2.host04.ahdtsw.service
      [root@host04 ~]# systemctl enable ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-2.host04.ahdtsw.service
      ```

3. ​						可选：使用放置规格部署多站点 Ceph 对象网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply rgw _NAME_ --realm=_REALM_NAME_ --zone=_PRIMARY_ZONE_NAME_ --placement="_NUMBER_OF_DAEMONS_ _HOST_NAME_1_ _HOST_NAME_2_"
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host04 /]# ceph orch apply rgw east --realm=test_realm --zone=us-east-1 --placement="2 host01 host02"
   ```

**验证**

- ​						检查同步状态以验证部署： 				

  **示例**

  ​							

  ```none
  [ceph: root@host04 /]# radosgw-admin sync status
  ```



# 使用 Ceph 编排器移除 Ceph 对象网关

​				您可以使用 `ceph 或ch rm` 命令移除 Ceph 对象网关守护进程。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 Ceph 对象网关守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						列出服务： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch ls
   ```

   1. ​								删除服务 						

      **语法**

      ​									

      ```none
      ceph orch rm SERVICE_NAME
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# ceph orch rm rgw.test_realm.test_zone_bb
      ```

**验证**

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps
  ```



Cephadm 将 radosgw 部署为守护进程的集合，这些守护进程管理单个集群部署或多站点部署中的特定领域和区域。

Note that with cephadm, radosgw daemons are configured via the monitor configuration database instead of via a ceph.conf or the command line.  If that configuration isn’t already in place (usually in the `client.rgw.<something>` section), then the radosgw daemons will start up with default settings .

注意，对于cephadm，radosgw守护进程是通过监视器配置数据库配置的，而不是通过ceph.conf或命令行配置的。如果该配置尚未到位（通常在client.rgw.部分），那么radosgw守护进程将以默认设置启动（例如绑定到端口80）。

使用任意服务名称部署一组 radosgw ，运行以下命令：

```bash
ceph orch apply rgw <name> [--realm=<realm-name>] [--zone=<zone-name>] --placement="<num-daemons> [<host1> ...]"
```

### Trivial setup

For example, to deploy 2 RGW daemons (the default) for a single-cluster RGW deployment under the arbitrary service id *foo*:

```bash
ceph orch apply rgw foo
```

### 指定网关

A common scenario is to have a labeled set of hosts that will act as gateways, with multiple instances of radosgw running on consecutive ports 8000 and 8001:

一种常见的情况是有一组标记的主机作为网关，多个radosgw实例在连续的端口8000和8001上运行：

```bash
ceph orch host label add gwhost1 rgw  # the 'rgw' label can be anything
ceph orch host label add gwhost2 rgw
ceph orch apply rgw foo '--placement=label:rgw count-per-host:2' --port=8000
```

### Multisite zones

To deploy RGWs serving the multisite *myorg* realm and the *us-east-1* zone on *myhost1* and *myhost2*:

```
ceph orch apply rgw east --realm=myorg --zone=us-east-1 --placement="2 myhost1 myhost2"
```

Note that in a multisite situation, cephadm only deploys the daemons.  It does not create or update the realm or zone configurations.  To create a new realm and zone, you need to do something like:

```
radosgw-admin realm create --rgw-realm=<realm-name> --default
radosgw-admin zonegroup create --rgw-zonegroup=<zonegroup-name>  --master --default
radosgw-admin zone create --rgw-zonegroup=<zonegroup-name> --rgw-zone=<zone-name> --master --default
radosgw-admin period update --rgw-realm=<realm-name> --commit
```

See [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec) for details of the placement specification.  See [Multi-Site](https://docs.ceph.com/en/latest/radosgw/multisite/#multisite) for more information of setting up multisite RGW.



## High availability service for RGW

This service allows the user to create a high avalilability RGW service providing a minimun set of configuration options.

The orchestrator will deploy and configure automatically several HAProxy and Keepalived containers to assure the continuity of the RGW service while the Ceph cluster will have at least 1 RGW daemon running.

The next image explains graphically how this service works:

![../../_images/HAProxy_for_RGW.svg](https://docs.ceph.com/en/latest/_images/HAProxy_for_RGW.svg)

There are N hosts where the HA RGW service is deployed. This means that we have an HAProxy and a keeplived daemon running in each of this hosts. Keepalived is used to provide a “virtual IP” binded to the hosts. All RGW clients use this  “virtual IP”  to connect with the RGW Service.

Each keeplived daemon is checking each few seconds what is the status of the HAProxy daemon running in the same host. Also it is aware that the “master” keepalived daemon will be running without problems.

If the “master” keepalived daemon or the Active HAproxy is not responding, one of the keeplived daemons running in backup mode will be elected as master, and the “virtual ip” will be moved to that node.

The active HAProxy also acts like a load balancer, distributing all RGW requests between all the RGW daemons available.

**Prerequisites:**

- At least two RGW daemons running in the Ceph cluster

- Operating system prerequisites: In order for the Keepalived service to forward network packets properly to the real servers, each router node must have IP forwarding turned on in the kernel. So it will be needed to set this system option:

  ```
  net.ipv4.ip_forward = 1
  ```

  Load balancing in HAProxy and Keepalived at the same time also requires the ability to bind to an IP address that are nonlocal, meaning that it is not assigned to a device on the local system. This allows a running load balancer instance to bind to an IP that is not local for failover. So it will be needed to set this system option:

  ```
  net.ipv4.ip_nonlocal_bind = 1
  ```

  Be sure to set properly these two options in the file `/etc/sysctl.conf` in order to persist this values even if the hosts are restarted. These configuration changes must be applied in all the hosts where the HAProxy for RGW service is going to be deployed.

**Deploy of the high availability service for RGW**

Use the command:

```
ceph orch apply -i <service_spec_file>
```

**Service specification file:**

It is a yaml format file with the following properties:

```
service_type: ha-rgw
service_id: haproxy_for_rgw
placement:
  hosts:
    - host1
    - host2
    - host3
spec:
  virtual_ip_interface: <string> # ex: eth0
  virtual_ip_address: <string>/<string> # ex: 192.168.20.1/24
  frontend_port: <integer>  # ex: 8080
  ha_proxy_port: <integer> # ex: 1967
  ha_proxy_stats_enabled: <boolean> # ex: true
  ha_proxy_stats_user: <string> # ex: admin
  ha_proxy_stats_password: <string> # ex: true
  ha_proxy_enable_prometheus_exporter: <boolean> # ex: true
  ha_proxy_monitor_uri: <string> # ex: /haproxy_health
  keepalived_password: <string> # ex: admin
  ha_proxy_frontend_ssl_certificate: <optional string> ex:
    [
      "-----BEGIN CERTIFICATE-----",
      "MIIDZTCCAk2gAwIBAgIUClb9dnseOsgJWAfhPQvrZw2MP2kwDQYJKoZIhvcNAQEL",
      ....
      "-----END CERTIFICATE-----",
      "-----BEGIN PRIVATE KEY-----",
      ....
      "sCHaZTUevxb4h6dCEk1XdPr2O2GdjV0uQ++9bKahAy357ELT3zPE8yYqw7aUCyBO",
      "aW5DSCo8DgfNOgycVL/rqcrc",
      "-----END PRIVATE KEY-----"
    ]
  ha_proxy_frontend_ssl_port: <optional integer> # ex: 8090
  ha_proxy_ssl_dh_param: <optional integer> # ex: 1024
  ha_proxy_ssl_ciphers: <optional string> # ex: ECDH+AESGCM:!MD5
  ha_proxy_ssl_options: <optional string> # ex: no-sslv3
  haproxy_container_image: <optional string> # ex: haproxy:2.4-dev3-alpine
  keepalived_container_image: <optional string> # ex: arcts/keepalived:1.2.2
```

where the properties of this service specification are:

- - `service_type`

    Mandatory and set to “ha-rgw”

- - `service_id`

    The name of the service.

- - `placement hosts`

    The hosts where it is desired to run the HA daemons. An HAProxy and a Keepalived containers will be deployed in these hosts. The RGW daemons can run in other different hosts or not.

- - `virtual_ip_interface`

    The physical network interface where the virtual ip will be binded

- - `virtual_ip_address`

    The virtual IP ( and network ) where the HA RGW service will be available. All your RGW clients must point to this IP in order to use the HA RGW service .

- - `frontend_port`

    The port used to access the HA RGW service

- - `ha_proxy_port`

    The port used by HAProxy containers

- - `ha_proxy_stats_enabled`

    If it is desired to enable the statistics URL in HAProxy daemons

- - `ha_proxy_stats_user`

    User needed to access the HAProxy statistics URL

- - `ha_proxy_stats_password`

    The password needed to access the HAProxy statistics URL

- - `ha_proxy_enable_prometheus_exporter`

    If it is desired to enable the Promethes exporter in HAProxy. This will allow to consume RGW Service metrics from Grafana.

- - `ha_proxy_monitor_uri`:

    To set the API endpoint where the health of HAProxy daemon is provided

- - `keepalived_password`:

    The password needed to access keepalived daemons

- - `ha_proxy_frontend_ssl_certificate`:

    SSl certificate. You must paste the content of your .pem file

- - `ha_proxy_frontend_ssl_port`:

    The https port used by HAProxy containers

- - `ha_proxy_ssl_dh_param`:

    Value used for the tune.ssl.default-dh-param setting in the HAProxy config file

- - `ha_proxy_ssl_ciphers`:

    Value used for the ssl-default-bind-ciphers setting in HAProxy config file.

- - `ha_proxy_ssl_options`:

    Value used for the ssl-default-bind-options setting in HAProxy config file.

- - `haproxy_container_image`:

    HAProxy image location used to pull the image

- - `keepalived_container_image`:

    Keepalived image location used to pull the image

**Useful hints for the RGW Service:**

- Good to have at least 3 RGW daemons
- Use at least 3 hosts for the HAProxy for RGW service
- In each host an HAProxy and a Keepalived daemon will be deployed. These daemons can be managed as systemd services