# Firewalld

[TOC]

## 概述

`firewalld` 是一个防火墙服务守护进程，其提供一个带有 D-Bus 接口的、动态可定制的、基于主机的防火墙。如果是动态的，可在每次修改规则时启用、修改和删除规则，而不需要在每次修改规则时重启防火墙守护进程。

* netfilter：位于Linux内核中的包过滤功能体系，成为Linux防火墙的“内核态”。
* firewalld：CentOS 7 默认的管理防火墙规则的工具，成为Linux防火墙的“用户态”。

以前的 iptables 防火墙是静态的，每次修改都要求防火墙完全重启，这个过程包括内核 netfilter 防火墙模块的卸载和新配置所需模块的装载等，而模块的卸载将会破坏状态防火墙和确立建立的连接。firewalld 可以动态管理防火墙。

- firewalld 提供了支持 网络/防火墙区域（zone）定义网络链接以及接口安全等级的动态防火墙管理工具。
- 支持 IPv4，IPv6 的防火墙设置以及以太网桥接。
- 支持服务或者应用程序直接添加防火墙规则的接口。
- 拥有运行时配置和永久配置两种选项。
  - 运行时配置——服务或系统重启后失效。
  - 永久配置——服务或系统关机、重启后生效。

`firewalld` 使用区和服务的概念来简化流量管理。zones 是预定义的规则集。网络接口和源可以分配给区。允许的流量取决于您计算机连接到的网络，并分配了这个网络的安全级别。防火墙服务是预定义的规则，覆盖了允许特定服务进入流量的所有必要设置，并在区中应用。 	

服务使用一个或多个端口或地址进行网络通信。防火墙会根据端口过滤通讯。要允许服务的网络流量，必须打开其端口。`firewalld` 会阻止未明确设置为打开的端口的所有流量。一些区（如可信区）默认允许所有流量。

请注意，带有 `nftables` 后端的 `firewalld` 不支持使用 `--direct` 选项将自定义的 `nftables` 规则传递到 `firewalld`。 	

## 运行

### 启动

```bash
systemctl unmask firewalld
systemctl start firewalld

systemctl enable firewalld
```

### 停止 					

```bash
systemctl stop firewalld
systemctl disable firewalld

# 要确保访问 firewalld D-Bus 接口时未启动 firewalld ，并且其他服务需要 firewalld 时也未启动 firewalld 。
systemctl mask firewalld
```

## Zone

`firewalld` 可以用来根据用户决定在该网络中的接口和流量上设置的信任级别来将网络划分为不同的区。一个连接只能是一个区的一部分，但一个区可以被用来进行很多网络连接。

`NetworkManager` 通知接口区的 `firewalld`。可以为接口分配区： 			

- `NetworkManager` 
- `firewall-config` 工具
- `firewall-cmd` 命令行工具
- RHEL web 控制台 					

后三个只能编辑适当的 `NetworkManager` 配置文件。如果您使用 web 控制台、`firewall-cmd` 或 `firewall-config` 修改了接口区，那么请求会被转发到 `NetworkManager`，并且不会由 ⁠`firewalld` 来处理。 			

预定义区存储在 `/usr/lib/firewalld/zones/` 目录中，并可立即应用到任何可用的网络接口上。只有在修改后，这些文件才会复制到 `/etc/firewalld/zones/` 目录中。

预定义区的默认设置如下：

- `block`

  任何传入的网络连接都会被拒绝，对于 `IPv4` 会显示 icmp-host-prohibited 消息，对于 `IPv6` 会显示 icmp6-adm-prohibited 消息。只有从系统启动的网络连接才能进行。 						

- `dmz`

  对于您的非企业化区里的计算机来说，这些计算机可以被公开访问，且有限访问您的内部网络。只接受所选的入站连接。 						

- `drop`

  所有传入的网络数据包都会丢失，没有任何通知。只有外发网络连接也是可行的。 						

- `external`

  适用于启用了伪装的外部网络，特别是路由器。您不信任网络中的其他计算机不会损害您的计算机。只接受所选的入站连接。 						

- `home`

  用于家用，因为您可以信任其他计算机。只接受所选的入站连接。 						

- `internal`

  当您主要信任网络中的其他计算机时，供内部网络使用。只接受所选的入站连接。 						

- `public`

  可用于您不信任网络中其他计算机的公共区域。只接受所选的入站连接。 						

- `trusted`

  所有网络连接都被接受。 						

- `work`

  可用于您主要信任网络中其他计算机的工作。只接受所选的入站连接。 						

这些区中的一个被设置为 *default* 区。当接口连接被添加到 `NetworkManager` 时，它们会被分配给默认区。安装时，`firewalld` 中的默认区被设置为 `public` 区。默认区可以被修改。 			

> **注意:**
>
> 网络区名称应该自我解释，并允许用户迅速做出合理的决定。要避免安全问题，请查看默认区配置并根据您的需要和风险禁用任何不必要的服务。

## 预定义的服务

服务可以是本地端口、协议、源端口和目的地列表，并在启用了服务时自动载入防火墙帮助程序模块列表。使用服务可节省用户时间，因为它们可以完成一些任务，如打开端口、定义协议、启用数据包转发等等，而不必在另外的步骤中设置所有任务。 			

`firewalld.service(5)` 手册页中描述了服务配置选项和通用文件信息。服务通过单独的 XML 配置文件来指定，这些文件采用以下格式命名：`*service-name*.xml` 。协议名称优先于 `firewalld` 中的服务或应用程序名称。 			

可以使用图形化的 `firewall-config` 工具、`firewall-cmd` 和 `firewall-offline-cmd` 来添加和删除服务。 			

或者，您可以编辑 `/etc/firewalld/services/` 目录中的 XML 文件。如果用户未添加或更改服务，则在 `/etc/firewalld/services/` 中没有相应的 XML 文件。如果要添加或更改服务，`/usr/lib/firewalld/services/` 目录中的文件可作用作模板。 

## 验证永久 firewalld 配置

在某些情况下，例如在手动编辑 `firewalld` 配置文件后，管理员想验证更改是否正确。

验证 `firewalld` 服务的永久配置： 					

```bash
firewall-cmd --check-config
success
```

如果永久配置有效，该命令将返回 `成功`。在其他情况下，命令返回一个带有更多详情的错误，如下所示： 					

```bash
firewall-cmd --check-config
Error: INVALID_PROTOCOL: 'public.xml': 'tcpx' not from {'tcp'|'udp'|'sctp'|'dccp'}
```

## 查看 `firewalld`的当前状态和设置	

### 查看 `firewalld` 的当前状态

使用 `firewalld` CLI 接口来检查该服务是否正在运行。

1. 查看服务的状态： 					

   ```none
   # firewall-cmd --state
   ```

2. 如需有关服务状态的更多信息，请使用 `systemctl status` 子命令： 					

   ```none
   # systemctl status firewalld
   firewalld.service - firewalld - dynamic firewall daemon
      Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor pr
      Active: active (running) since Mon 2017-12-18 16:05:15 CET; 50min ago
        Docs: man:firewalld(1)
    Main PID: 705 (firewalld)
       Tasks: 2 (limit: 4915)
      CGroup: /system.slice/firewalld.service
              └─705 /usr/bin/python3 -Es /usr/sbin/firewalld --nofork --nopid
   ```

### 使用 GUI 查看允许的服务

​					要使用图形化的 **firewall-config** 工具来查看服务列表，请按 **Super** 键进入"活动概览"，输入 `firewall`，然后按 **Enter** 键。**firewall-config** 工具会出现。现在，您可以在 `Services` 选项卡下查看服务列表。 			

​					您可以使用命令行启动图形防火墙配置工具。 			

**先决条件**

- ​							已安装 `firewall-config` 软件包。 					

**步骤**

- ​							使用命令行启动图形防火墙配置工具： 					

  ```none
  $ firewall-config
  ```

​					`防火墙配置` 窗口打开。请注意，这个命令可以以普通用户身份运行，但偶尔会提示您输入管理员密码。 			

### 使用 CLI 查看 firewalld 设置

​					使用 CLI 客户端可能会对当前防火墙设置有不同的视图。`--list-all` 选项显示 `firewalld` 设置的完整概述。 			

​					`Firewalld` 使用区来管理流量。如果没有用 `--zone` 选项来指定区，该命令将在分配给活跃网络接口和连接的默认区中有效。 			

**步骤**

- ​							要列出默认区的所有相关信息： 					

  ```none
  # firewall-cmd --list-all
  public
    target: default
    icmp-block-inversion: no
    interfaces:
    sources:
    services: ssh dhcpv6-client
    ports:
    protocols:
    masquerade: no
    forward-ports:
    source-ports:
    icmp-blocks:
    rich rules:
  ```

- ​							要指定显示设置的区，请在 `firewall-cmd--list-all` 命令中添加 `--zone=*zone-name*` 参数，例如： 					

  ```none
  # firewall-cmd --list-all --zone=home
  home
    target: default
    icmp-block-inversion: no
    interfaces:
    sources:
    services: ssh mdns samba-client dhcpv6-client
  ... [trimmed for clarity]
  ```

- ​							要查看特定信息（如服务或端口）的设置，请使用特定选项。使用命令帮助来查看 `firewalld` 手册页或获取选项列表： 					

  ```none
  # firewall-cmd --help
  ```

- ​							查看当前区中允许哪些服务： 					

  ```none
  # firewall-cmd --list-services
  ssh dhcpv6-client
  ```

注意

​						使用 CLI 工具列出某个子部分的设置有时会比较困难。例如，您允许 `SSH` 服务，`firewalld` 为该服务开放必要的端口(22)。之后，如果您列出允许的服务，列表将显示 `SSH` 服务，但如果列出开放的端口，则不会显示任何内容。因此，建议您使用 `--list-all` 选项来确保您收到完整的信息。 				

## 1.3. 使用 `firewalld` 控制网络流量

​				本节涵盖了使用 `firewalld` 来控制网络流量的信息。 		

### 1.3.1. 使用 CLI 禁用紧急事件的所有流量

​					在紧急情况下，如系统攻击，可以禁用所有网络流量并关闭攻击者。 			

**流程**

1. ​							要立即禁用网络流量，请切换 panic 模式： 					

   ```none
   # firewall-cmd --panic-on
   ```

   重要

   ​								启用 panic 模式可停止所有网络流量。因此，只有当您具有对机器的物理访问权限或使用串行控制台登录时，才应使用它。 						

2. ​							关闭 panic 模式会使防火墙恢复到其永久设置。要关闭 panic 模式，请输入： 					

   ```none
   # firewall-cmd --panic-off
   ```

**验证**

- ​							要查看是否打开或关闭 panic 模式，请使用： 					

  ```none
  # firewall-cmd --query-panic
  ```

### 1.3.2. 使用 CLI 控制预定义服务的流量

​					控制流量的最简单的方法是向 `firewalld` 添加预定义的服务。这会打开所有必需的端口并根据 *服务定义文件* 修改其他设置。 			

**流程**

1. ​							检查该服务是否还未被允许： 					

   ```none
   # firewall-cmd --list-services
   ssh dhcpv6-client
   ```

2. ​							列出所有预定义的服务： 					

   ```none
   # firewall-cmd --get-services
   RH-Satellite-6 amanda-client amanda-k5-client bacula bacula-client bitcoin bitcoin-rpc bitcoin-testnet bitcoin-testnet-rpc ceph ceph-mon cfengine condor-collector ctdb dhcp dhcpv6 dhcpv6-client dns docker-registry ...
   [trimmed for clarity]
   ```

3. ​							在允许的服务中添加服务： 					

   ```none
   # firewall-cmd --add-service=<service-name>
   ```

4. ​							使新设置持久： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

### 1.3.3. 通过 GUI，使用预定义服务控制流量

​					这个步骤描述了如何使用图形用户界面控制预定义服务的网络流量。 			

**先决条件**

- ​							已安装 `firewall-config` 软件包 					

**步骤**

1. ​							启用或禁用预定义或自定义服务： 					
   1. ​									启动 **firewall-config** 工具并选择要配置的服务的网络区。 							
   2. ​									选择 `Zones` 选项卡，然后选下面的 `Services` 选项卡。 							
   3. ​									选择需要在所选区中信任的服务类型的复选框，或者取消选择要阻断的服务复选框。 							
2. ​							编辑服务： 					
   1. ​									启动 **firewall-config** 工具。 							
   2. ​									从标为 `Configuration` 的菜单中选择 `Permanent` 。其它图标和菜单按钮会出现在服务窗口底部。 							
   3. ​									选择您要配置的服务。 							

​					`Ports` 、`Protocols` 和 `Source Port` 选项卡可为所选的服务启用、更改和删除端口、协议和源端口。模块标签是用来配置 **Netfilter** helper 模块。`Destination` 选项卡允许将流量限制到特定的目标地址和Internet协议(`IPv4` 或 `IPv6`)。 			

注意

​						在`Runtime` 模式下无法更改服务设置。 				

### 1.3.4. 添加新服务

​					可以使用图形化的 **firewall-config** 工具、`firewall-cmd` 和 `firewall-offline-cmd` 来添加和删除服务。或者，您可以编辑 `/etc/firewalld/services/` 中的 XML 文件。如果用户未添加或更改服务，则在 `/etc/firewalld/services/` 中没有相应的 XML 文件。如果要添加或更改服务，则文件 `/usr/lib/firewalld/services/` 可用作模板。 			

注意

​						服务名称必须是字母数字，此外只能包含 `_` （下划线）和 `-` （短划线）字符。 				

**步骤**

​						要在终端中添加新服务，请使用 `firewall-cmd` 或在 `firewalld` 未激活的情况下，使用`firewall-offline-cmd` 。 				

1. ​							运行以下命令以添加新和空服务： 					

   ```none
   $ firewall-cmd --new-service=service-name --permanent
   ```

2. ​							要使用本地文件添加新服务，请使用以下命令： 					

   ```none
   $ firewall-cmd --new-service-from-file=service-name.xml --permanent
   ```

   ​							您可以使用 `--name=*service-name*` 选项来更改服务名称。 					

3. ​							更改服务设置后，服务的更新副本放在 `/etc/firewalld/services/` 中。 					

   ​							作为 `root` 用户，您可以输入以下命令来手动复制服务： 					

   ```none
   # cp /usr/lib/firewalld/services/service-name.xml /etc/firewalld/services/service-name.xml
   ```

​					`firewalld` 首先从 `/usr/lib/firewalld/services` 加载文件。如果文件放在 `/etc/firewalld/services` 中，并且有效，则这些文件将覆盖 `/usr/lib/firewalld/services` 中的匹配文件。一旦删除了 `/etc/firewalld/services` 中的匹配文件，或者要求 `firewalld` 加载服务的默认值，就会使用 `/usr/lib/firewalld/services` 中的覆盖文件。这只适用于永久性环境。要在运行时环境中获取这些回退，则需要重新载入。 			

### 1.3.5. 使用 GUI 打开端口

​					要允许流量通过防火墙到达某个端口，您可以在 GUI 中打开端口。 			

**先决条件**

- ​							已安装 `firewall-config` 软件包 					

**步骤**

1. ​							启动 **firewall-config** 工具并选择要更改的网络区。 					
2. ​							选择 `Ports` 选项卡，然后点击右侧的 Add 按钮。此时会打开 `端口和协议` 窗口。 					
3. ​							输入要允许的端口号或者端口范围。 					
4. ​							从列表中选择 `tcp` 或 `udp`。 					

### 1.3.6. 使用 GUI 控制协议的流量

​					如果想使用某种协议允许流量通过防火墙，您可以使用 GUI。 			

**先决条件**

- ​							已安装 `firewall-config` 软件包 					

**步骤**

1. ​							启动 **firewall-config** 工具并选择要更改的网络区。 					
2. ​							选择 `Protocols` 选项卡，然后点击右侧的 `Add` 按钮。此时会打开 `协议` 窗口。 					
3. ​							从列表中选择协议，或者选择 `Other Protocol` 复选框，并在字段中输入协议。 					

### 1.3.7. 使用 GUI 打开源端口

​					要允许来自某个端口的流量通过防火墙，您可以使用 GUI。 			

**先决条件**

- ​							已安装 `firewall-config` 软件包 					

**步骤**

1. ​							启动 firewall-config 工具并选择要更改的网络区。 					
2. ​							选择 `Source Port` 选项卡，然后点击右侧的 `Add` 按钮。`源端口` 窗口将打开。 					
3. ​							输入要允许的端口号或者端口范围。从列表中选择 `tcp` 或 `udp`。 					

## 1.4. 使用 CLI 控制端口

​				端口是可让操作系统接收和区分网络流量并将其转发到系统服务的逻辑设备。它们通常由侦听端口的守护进程来表示，它会等待到达这个端口的任何流量。 		

​				通常，系统服务侦听为它们保留的标准端口。例如，`httpd` 守护进程监听 80 端口。但默认情况下，系统管理员会将守护进程配置为在不同端口上侦听以便增强安全性或出于其他原因。 		

### 1.4.1. 打开端口

​					通过打开端口，系统可从外部访问，这代表了安全风险。通常，让端口保持关闭，且只在某些服务需要时才打开。 			

**流程**

​						要获得当前区的打开端口列表： 				

1. ​							列出所有允许的端口： 					

   ```none
   # firewall-cmd --list-ports
   ```

2. ​							在允许的端口中添加一个端口，以便为入站流量打开这个端口： 					

   ```none
   # firewall-cmd --add-port=port-number/port-type
   ```

   ​							端口类型为 `tcp`、`udp`、`sctp` 或 `dccp`。这个类型必须与网络通信的类型匹配。 					

3. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

   ​							端口类型为 `tcp`、`udp`、`sctp` 或 `dccp`。这个类型必须与网络通信的类型匹配。 					

### 1.4.2. 关闭端口

​					当打开的端口不再需要时，在 `firewalld` 中关闭此端口。强烈建议您尽快关闭所有不必要的端口，因为端口处于打开状态会存在安全隐患。 			

**流程**

​						要关闭某个端口，请将其从允许的端口列表中删除： 				

1. ​							列出所有允许的端口： 					

   ```none
   # firewall-cmd --list-ports
   ```

   警告

   ​								这个命令只为您提供已打开作为端口的端口列表。您将无法看到作为服务打开的任何打开端口。因此，您应该考虑使用 `--list-all` 选项，而不是 `--list-ports`。 						

2. ​							从允许的端口中删除端口，以便对传入的流量关闭： 					

   ```none
   # firewall-cmd --remove-port=port-number/port-type
   ```

3. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

## 1.5. 使用系统角色配置端口

​				您可以使用 Red Hat Enterprise Linux(RHEL) `firewalld` 系统角色为传入的流量打开或关闭本地防火墙中的端口，并在重新引导后保持新配置。这个示例描述了如何配置 default 区以允许 `HTTPS` 服务的传入流量。 		

​				在 Ansible 控制节点上运行此步骤。 		

**先决条件**

- ​						可以访问一个或多个 *受管节点*，它们是您要使用 `firewalld` 系统角色来配置的系统。 				
- ​						对 *控制节点* 的访问和权限，这是 Red Hat Ansible Core 配置其他系统的系统。 				
- ​						`ansible-core` 和 `rhel-system-roles` 软件包在控制节点上安装。 				
- ​						如果您在运行 playbook 时使用了与 `root` 不同的远程用户，则此用户在受管节点上具有合适的 `sudo` 权限。 				
- ​						主机使用 NetworkManager 配置网络。 				

**流程**

1. ​						如果您要在其上执行 playbook 中指令的主机还没有被列入清单，请将此主机的 IP 或名称添加到 `/etc/ansible/hosts` Ansible 清单文件中： 				

   ```none
   node.example.com
   ```

2. ​						使用以下内容创建 `~/adding-and-removing-ports.yml` playbook： 				

   ```none
   ---
   - name: Allow incoming HTTPS traffic to the local host
     hosts: node.example.com
     become: true
   
     tasks:
       - include_role:
           name: linux-system-roles.firewall
   
         vars:
           firewall:
             - port: 443/tcp
               service: http
               state: enabled
               runtime: true
               permanent: true
   ```

   ​						`permanent: true` 选项可使新设置在重新引导后仍然有效。 				

3. ​						运行 playbook： 				

   - ​								要以 `root` 用户身份连接到受管主机，请输入： 						

     ```none
     # ansible-playbook -u root ~/adding-and-removing-ports.yml
     ```

   - ​								以用户身份连接到受管主机，请输入： 						

     ```none
     # ansible-playbook -u user_name --ask-become-pass ~/adding-and-removing-ports.yml
     ```

     ​								`--ask-become-pass` 选项确保 `ansible-playbook` 命令提示输入 `-u *user_name*` 选项中定义的用户的 `sudo` 密码。 						

   ​						如果没有指定 `-u *user_name*` 选项，`ansible-playbook` 以当前登录到控制节点的用户身份连接到受管主机。 				

**验证**

1. ​						连接到受管节点： 				

   ```none
   $ ssh user_name@node.example.com
   ```

2. ​						验证与 `HTTPS` 服务关联的 `443/tcp` 端口是否打开： 				

   ```none
   $ sudo firewall-cmd --list-ports
   443/tcp
   ```

**其他资源**

- ​						`/usr/share/ansible/roles/rhel-system-roles.network/README.md` 				
- ​						`ansible-playbook(1)` 手册页 				

## 1.6. 使用 firewalld 区

​				zones 代表一种更透明管理传入流量的概念。这些区域连接到联网接口或者分配一系列源地址。您可以独立为每个区管理防火墙规则，这样就可以定义复杂的防火墙设置并将其应用到流量。 		

### 1.6.1. 列出区域

​					这个步骤描述了如何使用命令行列出区。 			

**流程**

1. ​							查看系统中有哪些可用区： 					

   ```none
   # firewall-cmd --get-zones
   ```

   ​							`firewall-cmd --get-zones` 命令显示系统上所有可用的区，但不显示特定区的任何详情。 					

2. ​							查看所有区的详细信息： 					

   ```none
   # firewall-cmd --list-all-zones
   ```

3. ​							查看特定区的详细信息： 					

   ```none
   # firewall-cmd --zone=zone-name --list-all
   ```

### 1.6.2. 更改特定区的 firewalld 设置

​					[使用 cli 控制预定义服务的流量](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_firewalls_and_packet_filters/index#controlling-traffic-with-predefined-services-using-cli_controlling-network-traffic-using-firewalld) 和 [使用cli控制端口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_firewalls_and_packet_filters/index#controlling-ports-using-cli_using-and-configuring-firewalld) 解释了如何在当前工作区范围内添加服务或修改端口。有时，需要在不同区内设置规则。 			

**步骤**

- ​							要在不同的区中工作，请使用 `--zone=*zone-name*` 选项。例如，允许在区 *public* 中使用 `SSH` 服务： 					

  ```none
  # firewall-cmd --add-service=ssh --zone=public
  ```

### 1.6.3. 更改默认区

​					系统管理员在其配置文件中为网络接口分配区域。如果接口没有被分配给指定区，它将被分配给默认区。每次重启 `firewalld` 服务后，`firewalld` 加载默认区的设置，使其处于活动状态。 			

**步骤**

​						设置默认区： 				

1. ​							显示当前的默认区： 					

   ```none
   # firewall-cmd --get-default-zone
   ```

2. ​							设置新的默认区： 					

   ```none
   # firewall-cmd --set-default-zone zone-name
   ```

   注意

   ​								遵循此流程后，该设置是永久设置，即使没有 `--permanent` 选项。 						

### 1.6.4. 将网络接口分配给区

​					可以为不同区定义不同的规则集，然后通过更改所使用的接口的区来快速改变设置。使用多个接口，可以为每个具体区设置一个区来区分通过它们的网络流量。 			

**流程**

​						要将区分配给特定的接口： 				

1. ​							列出活跃区以及分配给它们的接口： 					

   ```none
   # firewall-cmd --get-active-zones
   ```

2. ​							为不同的区分配接口： 					

   ```none
   # firewall-cmd --zone=zone_name --change-interface=interface_name --permanent
   ```

### 1.6.5. 使用 nmcli 为连接分配区域

​					这个流程描述了如何使用 `nmcli` 工具将 `firewalld` 区添加到 `NetworkManager` 连接中。 			

**步骤**

1. ​							将区分配到 `NetworkManager` 连接配置文件： 					

   ```none
   # nmcli connection modify profile connection.zone zone_name
   ```

2. ​							激活连接： 					

   ```none
   # nmcli connection up profile
   ```

### 1.6.6. 在 ifcfg 文件中手动将区分配给网络连接

​					当连接由 **网络管理器（NetworkManager）**管理时，必须了解它使用的区域。为每个网络连接指定区域，根据计算机有可移植设备的位置提供各种防火墙设置的灵活性。因此，可以为不同的位置（如公司或家）指定区域和设置。 			

**步骤**

- ​							要为连接设置区，请编辑 `/etc/sysconfig/network-scripts/ifcfg-*connection_name*` 文件，并添加一行，将区分配给这个连接： 					

  ```none
  ZONE=zone_name
  ```

### 1.6.7. 创建一个新区

​					要使用自定义区，创建一个新的区并使用它像预定义区一样。新区需要 `--permanent` 选项，否则 命令不起作用。 			

**步骤**

1. ​							创建一个新区： 					

   ```none
   # firewall-cmd --permanent --new-zone=zone-name
   ```

2. ​							检查是否在您的永久设置中添加了新的区： 					

   ```none
   # firewall-cmd --get-zones
   ```

3. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

### 1.6.8. 区配置文件

​					区也可以通过*区配置文件*创建。如果您需要创建新区，但想从不同区重复使用设置，这种方法就很有用了。 			

​					`firewalld` 区配置文件包含区的信息。这些区描述、服务、端口、协议、icmp-blocks、masquerade、forward-ports 和丰富的语言规则采用 XML 文件格式。文件名必须是 `*zone-name*.xml`，其中 *zone-name* 的长度目前限制为 17 个字符。区配置文件位于 `/usr/lib/firewalld/zones/` 和 `/etc/firewalld/zones/` 目录中。 			

​					以下示例显示了允许一个服务(`SSH`)和一个端口范围的配置，适用于 `TCP` 和 `UDP` 协议： 			

```none
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>My Zone</short>
  <description>Here you can describe the characteristic features of the zone.</description>
  <service name="ssh"/>
  <port protocol="udp" port="1025-65535"/>
  <port protocol="tcp" port="1025-65535"/>
</zone>
```

​					要更改那个区的设置，请添加或者删除相关的部分来添加端口、转发端口、服务等等。 			

**其他资源**

- ​							`firewalld.zone` 手册页 					

### 1.6.9. 使用区目标设定传入流量的默认行为

​					对于每个区，您可以设置一种处理尚未进一步指定的传入流量的默认行为。此行为是通过设置区目标来定义的。有四个选项： 			

- ​							`ACCEPT`:接受除特定规则不允许的所有传入的数据包。 					
- ​							`REJECT`:拒绝所有传入的数据包，但特定规则允许的数据包除外。当 `firewalld` 拒绝数据包时，源机器会发出有关拒绝的信息。 					
- ​							`DROP`:除非由特定规则允许，丢弃所有传入数据包。当 `firewalld` 丢弃数据包时，源机器不知道数据包丢弃的信息。 					
- ​							`default`:与 `REJECT` 的行为类似，但在某些情况下有特殊含义。详情请查看 `firewall-cmd(1)` man page 中的 `Options to Adapt and Query Zones and Policies` 部分。 					

**流程**

​						为区设置目标： 				

1. ​							列出特定区的信息以查看默认目标： 					

   ```none
   # firewall-cmd --zone=zone-name --list-all
   ```

2. ​							在区中设置一个新目标： 					

   ```none
   # firewall-cmd --permanent --zone=zone-name --set-target=<default|ACCEPT|REJECT|DROP>
   ```

**其他资源**

- ​							`firewall-cmd(1)` 手册页 					

## 1.7. 根据源使用区管理传入流量

​				您可以使用区管理传入的流量，根据其源管理传入的流量。这可让您对进入的流量进行排序，并将其路由到不同的区，以允许或禁止该流量可访问的服务。 		

​				如果您给区添加一个源，区就会成为活跃的，来自该源的所有进入流量都会被定向到它。您可以为每个区指定不同的设置，这些设置相应地应用于来自给定源的网络流量。即使只有一个网络接口，您可以使用更多区域。 		

### 1.7.1. 添加源

​					要将传入的流量路由到特定区，请将源添加到那个区。源可以是一个使用 CIDR 格式的 IP 地址或 IP 掩码。 			

注意

​						如果您添加多个带有重叠网络范围的区域，则根据区名称排序，且只考虑第一个区。 				

- ​							在当前区中设置源： 					

  ```none
  # firewall-cmd --add-source=<source>
  ```

- ​							要为特定区设置源 IP 地址： 					

  ```none
  # firewall-cmd --zone=zone-name --add-source=<source>
  ```

​					以下流程允许来自 `受信任` 区中 *192.168.2.15* 的所有传入的流量： 			

**步骤**

1. ​							列出所有可用区： 					

   ```none
   # firewall-cmd --get-zones
   ```

2. ​							将源 IP 添加到持久性模式的信任区中： 					

   ```none
   # firewall-cmd --zone=trusted --add-source=192.168.2.15
   ```

3. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

### 1.7.2. 删除源

​					从区中删除源会关闭来自它的网络流量。 			

**流程**

1. ​							列出所需区的允许源： 					

   ```none
   # firewall-cmd --zone=zone-name --list-sources
   ```

2. ​							从区永久删除源： 					

   ```none
   # firewall-cmd --zone=zone-name --remove-source=<source>
   ```

3. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

### 1.7.3. 添加源端口

​					要启用基于源端口的流量排序，请使用 `--add-source-port` 选项来指定源端口。您还可以将其与 `--add-source` 选项结合使用，将流量限制在某个 IP 地址或 IP 范围。 			

**步骤**

- ​							添加源端口： 					

  ```none
  # firewall-cmd --zone=zone-name --add-source-port=<port-name>/<tcp|udp|sctp|dccp>
  ```

### 1.7.4. 删除源端口

​					通过删除源端口，您可以根据原始端口禁用对流量排序。 			

**流程**

- ​							要删除源端口： 					

  ```none
  # firewall-cmd --zone=zone-name --remove-source-port=<port-name>/<tcp|udp|sctp|dccp>
  ```

### 1.7.5. 使用区和源来允许一个服务只适用于一个特定的域

​					要允许特定网络的流量在机器上使用服务，请使用区和源。以下流程只允许来自 `192.0.2.0/24` 网络的 HTTP 流量，而任何其他流量都被阻止。 			

警告

​						配置此场景时，请使用具有`默认`目标的区。使用将目标设为 `ACCEPT` 的区存在安全风险，因为对于来自 `192.0.2.0/24` 的流量，所有网络连接都将被接受。 				

**步骤**

1. ​							列出所有可用区： 					

   ```none
   # firewall-cmd --get-zones
   block dmz drop external home internal public trusted work
   ```

2. ​							将 IP 范围添加到 `internal` 区，以将来自源的流量路由到区： 					

   ```none
   # firewall-cmd --zone=internal --add-source=192.0.2.0/24
   ```

3. ​							将`http` 服务添加到 `internal` 区中： 					

   ```none
   # firewall-cmd --zone=internal --add-service=http
   ```

4. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

**验证**

- ​							检查 `internal` 区是否处于活跃状态，以及该区中是否允许服务： 					

  ```none
  # firewall-cmd --zone=internal --list-all
  internal (active)
    target: default
    icmp-block-inversion: no
    interfaces:
    sources: 192.0.2.0/24
    services: cockpit dhcpv6-client mdns samba-client ssh http
    ...
  ```

**其他资源**

- ​							`firewalld.zones(5)` 手册页 					

## 1.8. 在区域间过滤转发的流量

​				使用策略对象，用户可以对策略中需要类似权限的不同身份进行分组。您可以根据流量的方向应用策略。 		

​				策略对象功能在 firewalld 中提供转发和输出过滤。以下描述了使用 firewalld 来过滤不同区域之间的流量，以允许访问本地托管的虚拟机来连接主机。 		

### 1.8.1. 策略对象和区域之间的关系

​					策略对象允许用户将 firewalld 的原语（如服务、端口和丰富的规则）附加到策略上。您可以将策略对象应用到以有状态和单向的方式在区域间传输的流量上。 			

```none
# firewall-cmd --permanent --new-policy myOutputPolicy

# firewall-cmd --permanent --policy myOutputPolicy --add-ingress-zone HOST

# firewall-cmd --permanent --policy myOutputPolicy --add-egress-zone ANY
```

​					`HOST` 和 `ANY` 是 ingress 和 egress 区域列表中使用的符号区域。 			

- ​							`HOST` 符号区域对于来自运行 firewalld 的主机的流量，或具有到运行 firewalld 的主机的流量允许策略。 					
- ​							`ANY` 符号区对所有当前和将来的区域应用策略。`ANY` 符号区域充当所有区域的通配符。 					

### 1.8.2. 使用优先级对策略进行排序

​					多个策略可以应用到同一组流量，因此应使用优先级为可能应用的策略创建优先级顺序。 			

​					要设置优先级来对策略进行排序： 			

```none
# firewall-cmd --permanent --policy mypolicy --set-priority -500
```

​					在上例中，*-500* 是较低的优先级值，但具有较高的优先级。因此，-500 将在 -100 之前执行。较高的优先级值优先于较低的优先级值。 			

​					以下规则适用于策略优先级： 			

- ​							具有负优先级的策略在区域中的规则之前应用。 					
- ​							具有正优先级的策略在区域中的规则之后应用。 					
- ​							优先级 0 被保留，因此不能使用。 					

### 1.8.3. 使用策略对象来过滤本地托管容器与主机物理连接的网络之间的流量

​					策略对象功能允许用户过滤其容器和虚拟机流量。 			

**步骤**

1. ​							创建新策略。 					

   ```none
   # firewall-cmd --permanent --new-policy podmanToHost
   ```

2. ​							阻止所有流量。 					

   ```none
   # firewall-cmd --permanent --policy podmanToHost --set-target REJECT
   
   # firewall-cmd --permanent --policy podmanToHost --add-service dhcp
   
   # firewall-cmd --permanent --policy podmanToHost --add-service dns
   ```

   注意

   ​								红帽建议您默认阻止到主机的所有流量，然后有选择地打开主机所需的服务。 						

3. ​							定义与策略一起使用的 ingress 区域。 					

   ```none
   # firewall-cmd --permanent --policy podmanToHost --add-ingress-zone podman
   ```

4. ​							定义与策略一起使用的 egress 区域。 					

   ```none
   # firewall-cmd --permanent --policy podmanToHost --add-egress-zone ANY
   ```

**验证**

- ​							验证关于策略的信息。 					

  ```none
  # firewall-cmd --info-policy podmanToHost
  ```

### 1.8.4. 设置策略对象的默认目标

​					您可以为策略指定 --set-target 选项。可用的目标如下： 			

- ​							**ACCEPT** - 接受数据包 					

- ​							**DROP** - 丢弃不需要的数据包 					

- ​							**REJECT** - 拒绝不需要的数据包，并带有 ICMP 回复 					

- ​							**CONTINUE （默认）** - 数据包将遵循以下策略和区域中的规则。 					

  ```none
  # firewall-cmd --permanent --policy mypolicy --set-target CONTINUE
  ```

**验证**

- ​							验证有关策略的信息 					

  ```none
  # firewall-cmd --info-policy mypolicy
  ```

## 1.9. 使用 firewalld 配置 NAT

​				使用 `firewalld`，您可以配置以下网络地址转换(NAT)类型： 		

- ​						伪装 				
- ​						源 NAT（SNAT） 				
- ​						目标 NAT（DNAT） 				
- ​						重定向 				

### 1.9.1. 不同的 NAT 类型： masquerading、source NAT、destination NAT 和 redirect

​					这些是不同的网络地址转换（NAT）类型： 			

- 伪装和源 NAT（SNAT）

  ​								使用以上 NAT 类型之一更改数据包的源 IP 地址。例如，互联网服务提供商不会路由私有 IP 范围，如 `10.0.0.0/8`。如果您在网络中使用私有 IP 范围，并且用户应该能够访问 Internet 上的服务器，请将这些范围内的数据包的源 IP 地址映射到公共 IP 地址。 						 							伪装和 SNAT 都非常相似。不同之处是： 						 									伪装自动使用传出接口的 IP 地址。因此，如果传出接口使用了动态 IP 地址，则使用伪装。 								 									SNAT 将数据包的源 IP 地址设置为指定的 IP 地址，且不会动态查找传出接口的 IP 地址。因此，SNAT 要比伪装更快。如果传出接口使用了固定 IP 地址，则使用 SNAT。 								

- 目标 NAT（DNAT）

  ​								使用此 NAT 类型重写传入数据包的目标地址和端口。例如，如果您的 Web 服务器使用私有 IP 范围内的 IP 地址，那么无法直接从互联网访问它，您可以在路由器上设置 DNAT 规则，以便将传入的流量重定向到此服务器。 						

- 重定向

  ​								这个类型是 IDT 的特殊示例，它根据链 hook 将数据包重定向到本地机器。例如，如果服务运行在与其标准端口不同的端口上，您可以将传入的流量从标准端口重定向到此特定端口。 						

### 1.9.2. 配置 IP 地址伪装

​					以下流程描述了如何在系统中启用 IP 伪装。IP 伪装会在访问互联网时隐藏网关后面的独立机器。 			

**步骤**

1. ​							要检查是否启用了 IP 伪装（例如，对于 `external` 区），以 `root` 用户身份输入以下命令： 					

   ```none
   # firewall-cmd --zone=external --query-masquerade
   ```

   ​							如果已启用，命令将会打印 `yes`，且退出状态为 `0`。否则，将打印 `no` ，且退出状态为 `1`。如果省略了 `zone`，则将使用默认区。 					

2. ​							要启用 IP 伪装，请以 `root` 用户身份输入以下命令： 					

   ```none
   # firewall-cmd --zone=external --add-masquerade
   ```

3. ​							要使此设置具有持久性，请将 `--permanent` 选项传递给命令。 					

4. ​							要禁用 IP 伪装，请以 `root` 身份输入以下命令： 					

   ```none
   # firewall-cmd --zone=external --remove-masquerade
   ```

   ​							要使此设置永久生效，请将 `--permanent` 选项传递给命令。 					

## 1.10. 端口转发

​				使用此方法重定向端口只可用于基于 IPv4 的流量。对于 IPv6 重定向设置，您必须使用丰富的规则。 		

​				要重定向到外部系统，需要启用伪装。如需更多信息，请参阅[配置 IP 地址伪装](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_firewalls_and_packet_filters/index#configuring-ip-address-masquerading_assembly_configuring-nat-using-firewalld)。 		

注意

​					您无法通过从配置了本地转发的主机重定向的端口访问服务。 			

### 1.10.1. 添加一个端口来重定向

​					使用 `firewalld`，您可以设置端口重定向，以便到达您系统上某个端口的任何传入的流量都被传送到您选择的其他内部端口或另一台计算机上的外部端口。 			

**先决条件**

- ​							在您将从一个端口的流量重新指向另一个端口或另一个地址前，您必须了解 3 个信息：数据包到达哪个端口，使用什么协议，以及您要重定向它们的位置。 					

**流程**

1. ​							将端口重新指向另一个端口： 					

   ```none
   # firewall-cmd --add-forward-port=port=port-number:proto=tcp|udp|sctp|dccp:toport=port-number
   ```

2. ​							将端口重定向到不同 IP 地址的另一个端口： 					

   1. ​									添加要转发的端口： 							

      ```none
      # firewall-cmd --add-forward-port=port=port-number:proto=tcp|udp:toport=port-number:toaddr=IP
      ```

   2. ​									启用伪装： 							

      ```none
      # firewall-cmd --add-masquerade
      ```

### 1.10.2. 将 TCP 端口 80 重定向到同一台机器中的 88 端口

​					按照以下步骤将 TCP 端口 80 重定向到端口 88。 			

**流程**

1. ​							将端口 80 重定向到 TCP 流量的端口 88: 					

   ```none
   # firewall-cmd --add-forward-port=port=80:proto=tcp:toport=88
   ```

2. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

3. ​							检查是否重定向了端口： 					

   ```none
   # firewall-cmd --list-all
   ```

### 1.10.3. 删除重定向的端口

​					这个步骤描述了如何删除重定向的端口。 			

**流程**

1. ​							要删除重定向的端口： 					

   ```none
   # firewall-cmd --remove-forward-port=port=port-number:proto=<tcp|udp>:toport=port-number:toaddr=<IP>
   ```

2. ​							要删除重定向到不同地址的转发端口： 					

   1. ​									删除转发的端口： 							

      ```none
      # firewall-cmd --remove-forward-port=port=port-number:proto=<tcp|udp>:toport=port-number:toaddr=<IP>
      ```

   2. ​									禁用伪装： 							

      ```none
      # firewall-cmd --remove-masquerade
      ```

### 1.10.4. 在同一台机器上将 TCP 端口 80 转发到端口 88

​					这个步骤描述了如何删除端口重定向。 			

**流程**

1. ​							列出重定向的端口： 					

   ```none
   ~]# firewall-cmd --list-forward-ports
   port=80:proto=tcp:toport=88:toaddr=
   ```

2. ​							从防火墙中删除重定向的端口： 					

   ```none
   ~]# firewall-cmd  --remove-forward-port=port=80:proto=tcp:toport=88:toaddr=
   ```

3. ​							使新设置具有持久性： 					

   ```none
   ~]# firewall-cmd --runtime-to-permanent
   ```

## 1.11. 管理 ICMP 请求

​				`Internet 控制消息协议` (`ICMP`)是一种支持协议，供各种网络设备用来发送错误消息和表示连接问题的操作信息，例如，请求的服务不可用。`ICMP` 与 TCP 和 UDP 等传输协议不同，因为它不用于在系统之间交换数据。 		

​				不幸的是，可以使用 `ICMP` 消息（特别是 `echo-request` 和 `echo-reply` ）来揭示关于您网络的信息，并将这些信息滥用于各种欺诈活动。因此，`firewalld` 允许阻止 `ICMP` 请求，来保护您的网络信息。 		

### 1.11.1. 列出和阻塞 ICMP 请求

**列出 `ICMP` 请求**

​						位于 `/usr/lib/firewalld/icmptypes/` 目录中的单独的 XML 文件描述了 `ICMP` 请求。您可以阅读这些文件来查看请求的描述。`firewall-cmd` 命令控制 `ICMP` 请求操作。 				

- ​							要列出所有可用的 `ICMP` 类型： 					

  ```none
  # firewall-cmd --get-icmptypes
  ```

- ​							IPv4、IPv6 或这两种协议都可以使用 `ICMP` 请求。要查看 `ICMP` 请求使用了哪种协议： 					

  ```none
  # firewall-cmd --info-icmptype=<icmptype>
  ```

- ​							如果请求当前被阻止了，则 `ICMP` 请求的状态显示为 `yes` ，如果没有被阻止，则显示为 `no`。查看 `ICMP` 请求当前是否被阻断了： 					

  ```none
  # firewall-cmd --query-icmp-block=<icmptype>
  ```

**阻止或取消阻止 `ICMP` 请求**

​						当您的服务器阻止了 `ICMP` 请求时，它不会提供任何通常会提供的信息。但这并不意味着根本不给出任何信息。客户端会收到特定的 `ICMP` 请求被阻止（拒绝）的信息。应仔细考虑阻止 `ICMP` 请求，因为它可能会导致通信问题，特别是与 IPv6 流量有关的通信问题。 				

- ​							要查看 `ICMP` 请求当前是否被阻断了： 					

  ```none
  # firewall-cmd --query-icmp-block=<icmptype>
  ```

- ​							要阻止 `ICMP` 请求： 					

  ```none
  # firewall-cmd --add-icmp-block=<icmptype>
  ```

- ​							要删除 `ICMP` 请求的块： 					

  ```none
  # firewall-cmd --remove-icmp-block=<icmptype>
  ```

**在不提供任何信息的情况下阻塞 `ICMP` 请求**

​						通常，如果您阻止了 `ICMP` 请求，客户端会知道您阻止了 ICMP 请求。这样潜在的攻击者仍然可以看到您的 IP 地址在线。要完全隐藏此信息，您必须丢弃所有 `ICMP` 请求。 				

- ​							要阻止和丢弃所有 `ICMP` 请求： 					

- ​							将区的目标设为 `DROP` ： 					

  ```none
  # firewall-cmd --permanent --set-target=DROP
  ```

​					现在，除您明确允许的流量外，所有流量（包括 `ICMP` 请求）都将被丢弃。 			

​					阻止和丢弃某些 `ICMP` 请求，而允许其他的请求： 			

1. ​							将区的目标设为 `DROP` ： 					

   ```none
   # firewall-cmd --permanent --set-target=DROP
   ```

2. ​							添加 ICMP block inversion 以一次阻止所有 `ICMP` 请求： 					

   ```none
   # firewall-cmd --add-icmp-block-inversion
   ```

3. ​							为您要允许的 `ICMP` 请求添加 ICMP 块： 					

   ```none
   # firewall-cmd --add-icmp-block=<icmptype>
   ```

4. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

​					*block inversion* 会颠倒 `ICMP` 请求块的设置，因此所有之前没有被阻止的请求都会被阻止，因为区的目标变成了 `DROP`。被阻断的请求不会被阻断。这意味着，如果您想要取消阻塞请求，则必须使用 blocking 命令。 			

​					将块 inversion 恢复到完全 permissive 设置： 			

1. ​							将区的目标设置为 `default` 或 `ACCEPT`: 					

   ```none
   # firewall-cmd --permanent --set-target=default
   ```

2. ​							删除 `ICMP` 请求的所有添加的块： 					

   ```none
   # firewall-cmd --remove-icmp-block=<icmptype>
   ```

3. ​							删除 `ICMP` block inversion： 					

   ```none
   # firewall-cmd --remove-icmp-block-inversion
   ```

4. ​							使新设置具有持久性： 					

   ```none
   # firewall-cmd --runtime-to-permanent
   ```

### 1.11.2. 使用 GUI 配置 ICMP 过滤器

- ​							要启用或禁用 `ICMP` 过滤器，请启动 **firewall-config** 工具,并选择其消息要被过滤的网络区。选择 `ICMP Filter` 选项卡，再选中您要过滤的每种 `ICMP` 消息的复选框。清除复选框以禁用过滤器。这个设置按方向设置，默认允许所有操作。 					
- ​							若要启用反向 `ICMP Filter`，可点击右侧的 `Invert Filter` 复选框。现在只接受标记为 `ICMP` 的类型，所有其他的均被拒绝。在使用 DROP 目标的区域里它们会被丢弃。 					

## 1.12. 使用 `firewalld` 设置和控制 IP 集

​				要查看 `firewalld` 所支持的 IP 集设置类型列表，请以 root 用户身份输入以下命令。 		

```none
~]# firewall-cmd --get-ipset-types
hash:ip hash:ip,mark hash:ip,port hash:ip,port,ip hash:ip,port,net hash:mac hash:net hash:net,iface hash:net,net hash:net,port hash:net,port,net
```

### 1.12.1. 使用 CLI 配置 IP 设置选项

​					IP 集可以在 `firewalld` 区中用作源，也可以用作富规则中的源。在 Red Hat Enterprise Linux 中，首选的方法是使用在直接规则中使用通过 `firewalld` 创建的 IP 集。 			

- ​							要列出 permanent 环境中 `firewalld` 已知的 IP 集，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --get-ipsets
  ```

- ​							要添加新的 IP 集，请以 `root` 用户身份使用 permanent 环境来运行以下命令： 					

  ```none
  # firewall-cmd --permanent --new-ipset=test --type=hash:net
  success
  ```

  ​							上述命令为 `IPv4` 创建了一个名为 *test* ， 类型为 `hash:net` 的新的 IP 集。要创建用于 `IPv6` 的 IP 集，请添加 `--option=family=inet6` 选项。要使新设置在运行时环境中有效，请重新加载 `firewalld`。 					

- ​							使用以下命令，以 `root` 用户身份列出新的 IP 集： 					

  ```none
  # firewall-cmd --permanent --get-ipsets
  test
  ```

- ​							要获取有关 IP 集的更多信息，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --info-ipset=test
  test
  type: hash:net
  options:
  entries:
  ```

  ​							请注意，IP 集目前没有任何条目。 					

- ​							要在 *test* IP 集中添加一个条目，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --ipset=test --add-entry=192.168.0.1
  success
  ```

  ​							前面的命令将 IP 地址 *192.168.0.1* 添加到 IP 集合中。 					

- ​							要获取 IP 集中的当前条目列表，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --ipset=test --get-entries
  192.168.0.1
  ```

- ​							生成包含 IP 地址列表的文件，例如： 					

  ```none
  # cat > iplist.txt <<EOL
  192.168.0.2
  192.168.0.3
  192.168.1.0/24
  192.168.2.254
  EOL
  ```

  ​							包含 IP 集合 IP 地址列表的文件应该每行包含一个条目。以 hash、分号或空行开头的行将被忽略。 					

- ​							要添加 *iplist.txt* 文件中的地址，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --ipset=test --add-entries-from-file=iplist.txt
  success
  ```

- ​							要查看 IP 集的扩展条目列表，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --ipset=test --get-entries
  192.168.0.1
  192.168.0.2
  192.168.0.3
  192.168.1.0/24
  192.168.2.254
  ```

- ​							要从 IP 集中删除地址，并检查更新的条目列表，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --permanent --ipset=test --remove-entries-from-file=iplist.txt
  success
  # firewall-cmd --permanent --ipset=test --get-entries
  192.168.0.1
  ```

- ​							您可以将 IP 集合作为一个源添加到区，以便处理所有来自 IP 集合中列出的任意地址的网络流量。例如，要将 *test* IP 集作为源添加到 *drop* 区域，以便丢弃来自 *test* IP 集中列出的所有条目的所有数据包，请以 `root` 用户身份运行以下命令 ： 					

  ```none
  # firewall-cmd --permanent --zone=drop --add-source=ipset:test
  success
  ```

  ​							源中的 `ipset:` 前缀显示 `firewalld` 的源是一个 IP 集，而不是 IP 地址或地址范围。 					

​					IP 集的创建和删除只限于 permanent 环境，所有其他 IP 集选项也可以用在运行时环境中，而不需要 `--permanent` 选项。 			

警告

​						红帽不推荐使用不是通过 `firewalld` 管理的 IP 集。要使用这样的 IP 组，需要一个永久直接规则来引用集合，且必须添加自定义服务来创建这些 IP 组件。这个服务需要在 `firewalld` 启动前启动，否则 `firewalld` 无法使用这些集合来添加直接规则。您可以使用 `/etc/firewalld/direct.xml` 文件来添加永久的直接规则。 				

## 1.13. 丰富规则的优先级

​				默认情况下，富规则是根据其规则操作进行组织的。例如，`deny` 规则优先于 `allow` 规则。富规则中的 `priority` 参数可让管理员对富规则及其执行顺序进行精细的控制。 		

### 1.13.1. priority 参数如何将规则组织为不同的链

​					您可以将富规则中的 `priority` 参数设置为 `-32768` 和 `32767` 之间的任意数字，值越小优先级越高。 			

​					`firewalld` 服务会根据其优先级的值将规则组织到不同的链中： 			

- ​							优先级低于 0：规则被重定向到带有 `_pre` 后缀的链中。 					
- ​							优先级高于 0：规则被重定向到带有 `_post` 后缀的链中。 					
- ​							优先级等于 0：根据操作，规则将重定向到带有 `_log`、`_deny` 或 `_allow` 的链中。 					

​					在这些子链中，`firewalld` 会根据其优先级的值对规则进行排序。 			

### 1.13.2. 设置丰富的规则的优先级

​					该流程描述了如何创建一个富规则的示例，该规则使用 `priority` 参数来记录其他规则不允许或拒绝的所有流量。您可以使用此规则标记意非预期的流量。 			

**流程**

1. ​							添加一个带有非常低优先级的丰富规则来记录未由其他规则匹配的所有流量： 					

   ```none
   # firewall-cmd --add-rich-rule='rule priority=32767 log prefix="UNEXPECTED: " limit value="5/m"'
   ```

   ​							命令还将日志条目的数量限制为每分钟 `5` 个。 					

2. ​							另外，还可显示上一步中命令创建的 `nftables` 规则： 					

   ```none
   # nft list chain inet firewalld filter_IN_public_post
   table inet firewalld {
     chain filter_IN_public_post {
       log prefix "UNEXPECTED: " limit rate 5/minute
     }
   }
   ```

## 1.14. 配置防火墙锁定

​				如果本地应用或服务以 `root` 身份运行（如 **libvirt**），则可以更改防火墙配置。使用这个特性，管理员可以锁定防火墙配置，从而达到没有应用程序或只有添加到锁定白名单中的应用程序可以请求防火墙更改的目的。锁定设置默认会被禁用。如果启用，用户就可以确定，防火墙没有被本地的应用程序或服务进行了不必要的配置更改。 		

### 1.14.1. 使用 CLI 配置锁定

​					这个流程描述了如何使用命令行来启用或禁用锁定。 			

- ​							要查询是否启用了锁定，请以 `root` 用户身份运行以下命令： 					

  ```none
  # firewall-cmd --query-lockdown
  ```

  ​							如果启用了锁定，该命令将打印 `yes`，且退出状态为 `0`。否则，将打印 `no` ，且退出状态为 `1`。 					

- ​							要启用锁定，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --lockdown-on
  ```

- ​							要禁用锁定，请以 `root` 用户身份使用以下命令： 					

  ```none
  # firewall-cmd --lockdown-off
  ```

### 1.14.2. 使用 CLI 配置锁定允许列表选项

​					锁定允许名单中可以包含命令、安全上下文、用户和用户 ID。如果允许列表中的命令条目以星号"*"结尾，则以该命令开头的所有命令行都将匹配。如果没有 "*"，那么包括参数的绝对命令必须匹配。 			

- ​							上下文是正在运行的应用程序或服务的安全（SELinux）上下文。要获得正在运行的应用程序的上下文，请使用以下命令： 					

  ```none
  $ ps -e --context
  ```

  ​							该命令返回所有正在运行的应用程序。通过 **grep** 工具管道输出以便获取您感兴趣的应用程序。例如： 					

  ```none
  $ ps -e --context | grep example_program
  ```

- ​							要列出允许列表中的所有命令行，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --list-lockdown-whitelist-commands
  ```

- ​							要在允许列表中添加命令 *command* ，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --add-lockdown-whitelist-command='/usr/bin/python3 -Es /usr/bin/command'
  ```

- ​							要从允许列表中删除命令 *command* ，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --remove-lockdown-whitelist-command='/usr/bin/python3 -Es /usr/bin/command'
  ```

- ​							要查询命令 *command* 是否在允许列表中，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --query-lockdown-whitelist-command='/usr/bin/python3 -Es /usr/bin/command'
  ```

  ​							如果为真，该命令将打印 `yes`，且退出状态为 `0`。否则，将打印 `no` ，且退出状态为 `1`。 					

- ​							要列出允许列表中的所有安全上下文，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --list-lockdown-whitelist-contexts
  ```

- ​							要在允许列表中添加上下文 *context*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --add-lockdown-whitelist-context=context
  ```

- ​							要从允许列表中删除上下文 *context*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --remove-lockdown-whitelist-context=context
  ```

- ​							要查询上下文 *context* 是否在允许列表中，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --query-lockdown-whitelist-context=context
  ```

  ​							如果为真，则打印 `yes` ，且退出状态为 `0` ，否则，打印 `no`，且退出状态为 `1`。 					

- ​							要列出允许列表中的所有用户 ID，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --list-lockdown-whitelist-uids
  ```

- ​							要在允许列表中添加用户 ID *uid*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --add-lockdown-whitelist-uid=uid
  ```

- ​							要从允许列表中删除用户 ID *uid*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --remove-lockdown-whitelist-uid=uid
  ```

- ​							要查询用户 ID *uid* 是否在 allowlist 中，请输入以下命令： 					

  ```none
  $ firewall-cmd --query-lockdown-whitelist-uid=uid
  ```

  ​							如果为真，则打印 `yes` ，且退出状态为 `0` ，否则，打印 `no`，且退出状态为 `1`。 					

- ​							要列出允许列表中的所有用户名，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --list-lockdown-whitelist-users
  ```

- ​							要在允许列表中添加用户名 *user*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --add-lockdown-whitelist-user=user
  ```

- ​							要从允许列表中删除用户名 *user*，请以 `root` 用户身份输入以下命令： 					

  ```none
  # firewall-cmd --remove-lockdown-whitelist-user=user
  ```

- ​							要查询用户名 *user* 是否在 allowlist 中，请输入以下命令： 					

  ```none
  $ firewall-cmd --query-lockdown-whitelist-user=user
  ```

  ​							如果为真，则打印 `yes` ，且退出状态为 `0` ，否则，打印 `no`，且退出状态为 `1`。 					

### 1.14.3. 使用配置文件配置锁定的 allowlist 选项

​					默认的允许列表配置文件包含 `NetworkManager` 上下文和 `libvirt` 的默认上下文。用户 ID 0 也位于列表中。 			

​					+ allowlist 配置文件存储在 `/etc/firewalld/` 目录中。 			

```none
<?xml version="1.0" encoding="utf-8"?>
	<whitelist>
	  <selinux context="system_u:system_r:NetworkManager_t:s0"/>
	  <selinux context="system_u:system_r:virtd_t:s0-s0:c0.c1023"/>
	  <user id="0"/>
	</whitelist>
```

​					以下是一个允许列表配置文件示例，为 `firewall-cmd` 工具启用所有命令，对于名为 *user* 的用户，其用户 ID 为 `815` ： 			

```none
<?xml version="1.0" encoding="utf-8"?>
	<whitelist>
	  <command name="/usr/libexec/platform-python -s /bin/firewall-cmd*"/>
	  <selinux context="system_u:system_r:NetworkManager_t:s0"/>
	  <user id="815"/>
	  <user name="user"/>
	</whitelist>
```

​					此示例显示了`user id` 和 `user name`，但只需要其中一个选项。Python 是程序解释器，它位于命令行的前面。您还可以使用特定的命令，例如： 			

```none
/usr/bin/python3 /bin/firewall-cmd --lockdown-on
```

​					在该示例中，只允许 `--lockdown-on` 命令。 			

​					在 Red Hat Enterprise Linux 中，所有工具都放在 `/usr/bin/` 目录中，`/bin/` 目录被符号链接到 `/usr/bin/` 目录。换句话说，尽管以 `root` 身份输入的 `firewall-cmd` 的路径可能会被解析为 `/bin/firewall-cmd`，但现在 `/usr/bin/firewall-cmd` 可以使用。所有新脚本都应该使用新位置。但请注意，如果以 `root` 身份运行的脚本被写为使用 `/bin/firewall-cmd` 路径，那么除了通常只用于非`root` 用户的 `/usr/bin/firewall-cmd` 路径外，还必须在允许列表中添加该命令的路径。 			

​					命令的 name 属性末尾的 `*` 表示所有以这个字符串开头的命令都匹配。如果没有 `*`，则包括参数的绝对命令必须匹配。 			

## 1.15. 启用 firewalld 区域中不同接口或源之间的流量转发

​				区内转发是 `firewalld` 的一种功能，它允许 `firewalld` 区域内接口或源之间的流量转发。 		

### 1.15.1. 区域内部转发与默认目标设置为 ACCEPT 的区域之间的区别

​					启用区内部转发时，单个 `firewalld` 区域中的流量可以从一个接口或源流到另一个接口或源。区域指定接口和源的信任级别。如果信任级别相同，则接口或源之间的通信是可能的。 			

​					请注意，如果您在 `firewalld` 的默认区域中启用了区域内部转发，则它只适用于添加到当前默认区域的接口和源。 			

​					`firewalld` 的 `trusted` 区域使用设为 `ACCEPT` 的默认目标。这个区域接受所有转发的流量，但不支持区域内转发。 			

​					对于其他默认目标值，默认情况下会丢弃转发的流量，这适用于除可信区域之外的所有标准的区域。 			

### 1.15.2. 使用区域内部转发来在以太网和 Wi-Fi 网络间转发流量

​					您可以使用区域内部转发来转发同一 `firewalld` 区域内接口和源之间转发流量。例如，使用此功能来转发连接到 `enp1s0` 以太网和连接到 `wlp0s20` Wi-Fi 网络之间的流量。 			

**步骤**

1. ​							在内核中启用数据包转发： 					

   ```none
   # echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/95-IPv4-forwarding.conf
   
   # sysctl -p /etc/sysctl.d/95-IPv4-forwarding.conf
   ```

2. ​							确保要在其之间启用区域内部转发的接口没有被分配给与 `internal` 区域不同的区域： 					

   ```none
   # firewall-cmd --get-active-zones
   ```

3. ​							如果接口当前分配给了 `internal` 以外的区域，请对其重新分配： 					

   ```none
   # firewall-cmd --zone=internal --change-interface=interface_name --permanent
   ```

4. ​							将 `enp1s0` 和 `wlp0s20` 接口添加到 `internal` 区域： 					

   ```none
   # firewall-cmd --zone=internal --add-interface=enp1s0 --add-interface=wlp0s20
   ```

5. ​							启用区域内部转发： 					

   ```none
   # firewall-cmd --zone=internal --add-forward
   ```

**验证**

​						以下验证步骤要求 `nmap-ncat` 软件包在两个主机上都已安装。 				

1. ​							登录到与您启用了区域转发的主机的 `enp1s0` 接口位于同一网络的主机。 					

2. ​							使用 `ncat` 启动 echo 服务来测试连接： 					

   ```none
   # ncat -e /usr/bin/cat -l 12345
   ```

3. ​							登录到与 `wlp0s20` 接口位于同一网络的主机。 					

4. ​							连接到运行在与 `enp1s0` 在同一网络的主机上的 echo 服务器： 					

   ```none
   # ncat <other host> 12345
   ```

5. ​							输入一些内容，并按 Enter，然后验证文本是否发送回来。 					

**其他资源**

- ​							`firewalld.zones(5)` 手册页 					

## 1.16. 在 Ansible 中使用 RHEL 系统角色配置 firewalld 设置

​				您可以使用 Ansible 防火墙系统角色一次性在多个客户端上配置 `firewalld` 服务的设置。这个解决方案： 		

- ​						提供具有有效输入设置的接口。 				
- ​						保留所有预期的 `firewalld` 参数。 				

​				在控制节点上运行 `firewall` 角色后，系统角色会立即将 `firewalld` 参数应用到受管节点，并使其在重启后持久保留。 		

重要

​					请注意，通过 RHEL 频道提供的 RHEL 系统角色可在默认 **AppStream** 软件仓库中作为 RPM 软件包提供给 RHEL 客户。RHEL 系统角色还可以通过 Ansible Automation Hub 为客户提供 Ansible 订阅的集合。 			

### 1.16.1. 防火墙 RHEL 系统角色简介

​					RHEL 系统角色是 Ansible 自动化实用程序的一组内容。此内容与 Ansible 自动化实用程序相结合，提供了一致的配置界面，用于远程管理多个系统。 			

​					RHEL 系统角色中的 `rhel-system-roles.firewall` 角色是为 `firewalld` 服务的自动配置而引入的。`rhel-system-roles` 软件包包含这个系统角色以及参考文档。 			

​					要以自动化的方式在一个或多个系统上应用 `firewalld` 参数，请在 playbook 中使用 `firewall` 系统角色变量。playbook 是一个或多个以基于文本的 YAML 格式编写的 play 的列表。 			

​					您可以使用清单文件来定义您希望 Ansible 配置的一组系统。 			

​					使用 `firewall` 角色，您可以配置许多不同的 `firewalld` 参数，例如： 			

- ​							区（zone）。 					
- ​							应允许数据包的服务。 					
- ​							授予、拒绝或丢弃对端口的流量访问。 					
- ​							为区转发端口或端口范围。 					

**其他资源**

- ​							`README.md` 和 `README.html` 文件位于 `/usr/share/doc/rhel-system-roles/firewall/` 目录中 					
- ​							[使用 playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) 					
- ​							[如何构建清单](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) 					

### 1.16.2. 将传入的流量从一个本地端口转发到不同的本地端口

​					使用 `rhel-system-roles.firewall` 角色，您可以远程配置 `firewalld` 参数，同时对多个受管主机的影响具有持久性。 			

**先决条件**

- ​							RHEL 订阅授权，您将在控制节点上安装 `ansible-core` 和 `rhel-system-roles` 软件包。 					
- ​							受管主机清单存在于控制计算机上，Ansible 能够连接它们。 					
- ​							有权限在受管主机上运行 Ansible playbook。 					
- ​							如果您运行 playbook 时使用了与 `root` 不同的远程用户，则此用户对受管主机具有适当的 `sudo` 权限。 					
- ​							清单文件列出 playbook 应执行操作的主机。此流程中的 playbook 在组 `testinservers` 的主机上运行。 					

重要

​						RHEL 8.0 - 8.5 提供对基于 Ansible 的自动化需要 Ansible Engine 2.9 的独立 Ansible 存储库的访问权限。Ansible Engine 包含命令行实用程序，如 `ansible`、`ansible-playbook`; 连接器，如 `docker` 和 `podman`; 以及插件和模块的整个环境。有关如何获取并安装 Ansible Engine 的信息，请参阅[如何下载和安装 Red Hat Ansible Engine?](https://access.redhat.com/articles/3174981)。 				

​						RHEL 8.6 和更新的版本中引入了 Ansible Core（以 `ansible-core` RPM 提供），其中包含 Ansible 命令行工具、命令以及小型内置 Ansible 插件。AppStream 存储库提供 `ansible-core`，它的范围有限。如需更多信息，请参阅 [RHEL 9 AppStream 中包含的 ansible-core 软件包的范围](https://access.redhat.com/articles/6325611)。 				

**步骤**

1. ​							创建 `~/port_forwarding.yml` 文件并添加以下内容： 					

   ```none
   ---
   - name: Forward incoming traffic on port 8080 to 443
     hosts: testingservers
   
     tasks:
       - include_role:
           name: rhel-system-roles.firewall
   
     vars:
       firewall:
         - { forward_port: 8080/tcp;443;, state: enabled, runtime: true, permanent: true }
   ```

   ​							此文件代表一个 playbook，通常包含了一组有特定顺序的任务（也称为 *play* ）列表。这些任何会根据 `inventory` 文件中选择的特定管理主机进行。在这种情况下，该 playbook 将针对受管主机的 `testingservers` 组运行。 					

   ​							Play 中的 `hosts` 键指定对其运行 play 的主机。您可以将这个键的值作为受管主机的单独名称，或作为 `inventory` 文件中定义的主机组提供。 					

   ​							`tasks` 部分包含 `include_role` 键，它指定了哪些系统角色将配置 `vars` 部分中提到的参数和值。 					

   ​							`vars` 部分包含一个名为 `firewall` 的角色变量。此变量是字典值列表，并指定应用于受管主机上的 `firewalld` 的参数。example 角色将进入端口 8080 的流量转发到端口 443。设置将立即生效，并将在重启后保留。 					

2. ​							（可选）验证 playbook 中的语法是否正确： 					

   ```none
   # ansible-playbook --syntax-check ~/port_forwarding.yml
   
   playbook: port_forwarding.yml
   ```

   ​							本例演示了对 playbook 的成功验证。 					

3. ​							执行 playbook： 					

   ```none
   # ansible-playbook ~/port_forwarding.yml
   ```

**验证**

- ​							在受管主机上： 					

  - ​									重启主机以验证 `firewalld` 设置是否在重启后是否仍存在： 							

    ```none
    # reboot
    ```

  - ​									显示 `firewalld` 设置： 							

    ```none
    # firewall-cmd --list-forward-ports
    ```

**其他资源**

- ​							[RHEL 系统角色入门](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/administration_and_configuration_tasks_using_system_roles_in_rhel/getting-started-with-rhel-system-roles_administration-and-configuration-tasks-using-system-roles-in-rhel) 					
- ​							`README.html` 和 `README.md` 文件在 `/usr/share/doc/rhel-system-roles/firewall/` 目录中 					
- ​							[构建您的清单](https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html) 					
- ​							[配置 Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html) 					
- ​							[使用 Playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) 					
- ​							[使用变量](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) 					
- ​							[角色](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) 					

### 1.16.3. 使用系统角色配置端口

​					您可以使用 Red Hat Enterprise Linux(RHEL) `firewalld` 系统角色为传入的流量打开或关闭本地防火墙中的端口，并在重新引导后保持新配置。这个示例描述了如何配置 default 区以允许 `HTTPS` 服务的传入流量。 			

​					在 Ansible 控制节点上运行此步骤。 			

**先决条件**

- ​							可以访问一个或多个 *受管节点*，它们是您要使用 `firewalld` 系统角色来配置的系统。 					
- ​							对 *控制节点* 的访问和权限，这是 Red Hat Ansible Core 配置其他系统的系统。 					
- ​							`ansible-core` 和 `rhel-system-roles` 软件包在控制节点上安装。 					
- ​							如果您在运行 playbook 时使用了与 `root` 不同的远程用户，则此用户在受管节点上具有合适的 `sudo` 权限。 					
- ​							主机使用 NetworkManager 配置网络。 					

**步骤**

1. ​							如果您要在其上执行 playbook 中指令的主机还没有被列入清单，请将此主机的 IP 或名称添加到 `/etc/ansible/hosts` Ansible 清单文件中： 					

   ```none
   node.example.com
   ```

2. ​							使用以下内容创建 `~/adding-and-removing-ports.yml` playbook： 					

   ```none
   ---
   - name: Allow incoming HTTPS traffic to the local host
     hosts: node.example.com
     become: true
   
     tasks:
       - include_role:
           name: linux-system-roles.firewall
   
         vars:
           firewall:
             - port: 443/tcp
               service: http
               state: enabled
               runtime: true
               permanent: true
   ```

   ​							`permanent: true` 选项可使新设置在重新引导后仍然有效。 					

3. ​							运行 playbook： 					

   - ​									要以 `root` 用户身份连接到受管主机，请输入： 							

     ```none
     # ansible-playbook -u root ~/adding-and-removing-ports.yml
     ```

   - ​									以用户身份连接到受管主机，请输入： 							

     ```none
     # ansible-playbook -u user_name --ask-become-pass ~/adding-and-removing-ports.yml
     ```

     ​									`--ask-become-pass` 选项确保 `ansible-playbook` 命令提示输入 `-u *user_name*` 选项中定义的用户的 `sudo` 密码。 							

   ​							如果没有指定 `-u *user_name*` 选项，`ansible-playbook` 以当前登录到控制节点的用户身份连接到受管主机。 					

**验证**

1. ​							连接到受管节点： 					

   ```none
   $ ssh user_name@node.example.com
   ```

2. ​							验证与 `HTTPS` 服务关联的 `443/tcp` 端口是否打开： 					

   ```none
   $ sudo firewall-cmd --list-ports
   443/tcp
   ```

**其他资源**

- ​							`/usr/share/ansible/roles/rhel-system-roles.network/README.md` 					
- ​							`ansible-playbook(1)` 手册页 					

### 1.16.4. 使用 firewalld RHEL 系统角色配置 DMZ `firewalld` 区域

​					作为系统管理员，您可以使用 RHEL `firewalld` 系统角色在 **enp1s0** 接口上配置 `dmz` 区域，以允许到区域的 `HTTPS` 流量。这样，您可以让外部用户访问您的 web 服务器。 			

**先决条件**

- ​							对一个或多个 *受管节点* 的访问和权限，受管节点是您要使用 VPN 系统角色配置的系统。 					
- ​							对 *控制节点* 的访问和权限，这是 Red Hat Ansible Core 配置其他系统的系统。 					
- ​							列出受管节点的清单文件。 					
- ​							`ansible-core` 和 `rhel-system-roles` 软件包在控制节点上安装。 					
- ​							如果您在运行 playbook 时使用了与 `root` 不同的远程用户，则此用户在受管节点上具有合适的 `sudo` 权限。 					
- ​							受管节点使用 `NetworkManager` 配置网络。 					

**步骤**

1. ​							使用以下内容创建 `~/configuring-a-dmz-using-the-firewall-system-role.yml` playbook： 					

   ```none
   ---
   - name: Creating a DMZ with access to HTTPS port and masquerading for hosts in DMZ
     hosts: node.example.com
     become: true
   
     tasks:
       - include_role:
           name: linux-system-roles.firewall
   
         vars:
           firewall:
             - zone: dmz
               interface: enp1s0
               service: https
               state: enabled
               runtime: true
               permanent: true
   ```

2. ​							运行 playbook： 					

   - ​									要以 `root` 用户身份连接到受管主机，请输入： 							

     ```none
     $ ansible-playbook -u root ~/configuring-a-dmz-using-the-firewall-system-role.yml
     ```

   - ​									以用户身份连接到受管主机，请输入： 							

     ```none
     $ ansible-playbook -u user_name --ask-become-pass ~/configuring-a-dmz-using-the-firewall-system-role.yml
     ```

     ​									`--ask-become-pass` 选项确保 `ansible-playbook` 命令提示输入 `-u *user_name*` 选项中定义的用户的 `sudo` 密码。 							

   ​							如果没有指定 `-u *user_name*` 选项，`ansible-playbook` 以当前登录到控制节点的用户身份连接到受管主机。 					

**验证**

- ​							在受管节点上，查看 `dmz` 区域的详细信息： 					

  ```none
  # firewall-cmd --zone=dmz --list-all
  dmz (active)
    target: default
    icmp-block-inversion: no
    interfaces: enp1s0
    sources:
    services: https ssh
    ports:
    protocols:
    forward: no
    masquerade: no
    forward-ports:
    source-ports:
    icmp-blocks:
  ```

## 1.17. 其他资源

- ​						`firewalld(1)` 书册页 				
- ​						`firewalld.conf(5)` 手册页 				
- ​						`firewall-cmd(1)` 手册页 				
- ​						`firewall-config(1)` 手册页 				
- ​						`firewall-offline-cmd(1)` 手册页 				
- ​						`firewalld.icmptype(5)` 手册页 				
- ​						`firewalld.ipset(5)` 手册页 				
- ​						`firewalld.service(5)` 手册页 				
- ​						`firewalld.zone(5)` 手册页 				
- ​						`firewalld.direct(5)` 手册页 				
- ​						`firewalld.lockdown-whitelist(5)` 				
- ​						`firewalld.richlanguage(5)` 				
- ​						`firewalld.zones(5)` 手册页 				
- ​						`firewalld.dbus(5)` 手册页 				

# 第 2 章 nftables 入门

​			`nftables` 框架提供了数据包分类功能。最显著的功能是： 	

- ​					内置查找表而不是线性处理 			
- ​					`IPv4` 和 `IPv6` 使用同一个协议框架 			
- ​					规则会以一个整体被应用，而不是分为抓取、更新和存储完整的规则集的步骤 			
- ​					支持在规则集(`nftrace`)和监控追踪事件（`nft`）中调试和追踪 			
- ​					更加一致和压缩的语法，没有特定协议的扩展 			
- ​					用于第三方应用程序的 Netlink API 			

​			`nftables` 框架使用表来存储链。链包含执行动作的独立规则。`libnftnl` 库可用于通过 `libmnl` 库与 `nftables` Netlink API 进行低级交互。 	

​			要显示规则集变化的影响，请使用 `nft list ruleset` 命令。由于这些工具将表、链、规则、集合和其他对象添加到 `nftables` 规则集中，请注意， `nftables` 规则集操作（如 `nft flush ruleset` 命令）可能会影响使用之前独立的旧命令安装的规则集。 	

## 2.1. 从 iptables 迁移到 nftables

​				如果您的防火墙配置仍然使用 `iptables` 规则，您可以将 `iptables` 规则迁移到 `nftables`。 		

重要

​					`ipset` 和 `iptables-nft` 软件包已在 Red Hat Enterprise Linux 9 中弃用。这包括 `nft-variants` （如 `iptables`、`ip6tables`、`arptables` 和 `ebtables` 工具）的弃用。如果您使用其中任何一个工具，例如，因为您从早期的 RHEL 版本升级，红帽建议迁移到 `nftables` 软件包提供的 `nft` 命令行工具。 			

### 2.1.1. 使用 firewalld、nftables 或者 iptables 时

​					以下是您应该使用以下工具之一的概述： 			

- ​							`firewalld`:使用 `firewalld` 实用程序进行简单防火墙用例。此工具易于使用，并涵盖了这些场景的典型用例。 					
- ​							`nftables`:使用 `nftables` 工具来设置复杂和性能关键的防火墙，如整个网络。 					
- ​							`iptables`:Red Hat Enterprise Linux 上的 `iptables` 工具使用 `nf_tables` 内核 API 而不是 `legacy` 后端。`nf_tables` API 提供了向后兼容性，以便使用 `iptables` 命令的脚本仍可在 Red Hat Enterprise Linux 上工作。对于新的防火墙脚本，红帽建议使用 `nftables`。 					

重要

​						要避免不同的防火墙服务相互影响，在 RHEL 主机中只有一个服务，并禁用其他服务。 				

### 2.1.2. 将 iptables 规则转换为 nftables 规则

​					Red Hat Enterprise Linux 提供了 `iptables-translate` 和 `ip6tables-translate` 工具，将现有 `iptables` 或 `ip6tables` 规则转换为与 `nftables` 相同的规则。 			

​					请注意，一些扩展可能缺少响应的转换支持。如果存在这样的扩展，工具会打印以 `#` 符号为前缀的未转换的规则。例如： 			

```none
# iptables-translate -A INPUT -j CHECKSUM --checksum-fill
nft # -A INPUT -j CHECKSUM --checksum-fill
```

​					此外，用户可以使用 `iptables-restore-translate` 和 `ip6tables-restore-translate` 工具来转换规则的转储。请注意，在此之前，用户可以使用 `iptables-save` 或 `ip6tables-save` 命令来打印当前规则的转储。例如： 			

```none
# iptables-save >/tmp/iptables.dump
# iptables-restore-translate -f /tmp/iptables.dump

# Translated by iptables-restore-translate v1.8.0 on Wed Oct 17 17:00:13 2018
add table ip nat
...
```

​					如需更多信息，以及可能的选项和值列表，请输入 `iptables-translate --help` 命令。 			

### 2.1.3. 常见的 iptables 和 nftables 命令的比较

​					以下是常见的 `iptables` 和 `nftables` 命令的比较： 			

- ​							列出所有规则： 					

  | iptables        | nftables           |
  | --------------- | ------------------ |
  | `iptables-save` | `nft list ruleset` |

- ​							列出某个表和链： 					

  | iptables                        | nftables                           |
  | ------------------------------- | ---------------------------------- |
  | `iptables -L`                   | `nft list table ip filter`         |
  | `iptables -L INPUT`             | `nft list chain ip filter INPUT`   |
  | `iptables -t nat -L PREROUTING` | `nft list chain ip nat PREROUTING` |

  ​							`nft` 命令不会预先创建表和链。只有当用户手动创建它们时它们才会存在。 					

  **Example:列出 firewalld 生成的规则**

  ​								

  ```none
  # nft list table inet firewalld
  # nft list table ip firewalld
  # nft list table ip6 firewalld
  ```

## 2.2. 编写和执行 nftables 脚本

​				`nftables` 框架提供了一个原生脚本环境，与使用shell脚本来维护防火墙规则相比，它带来了一个主要好处：执行脚本是原子的。这意味着，系统会应用整个脚本，或者在出现错误时防止执行。这样可保证防火墙始终处于一致状态。 		

​				另外，`nftables` 脚本环境使管理员能够： 		

- ​						添加评论 				
- ​						定义变量 				
- ​						包含其他规则集文件 				

​				本节介绍了如何使用这些功能，以及如何创建和执行 `nftables` 脚本。 		

​				安装 `nftables` 软件包时，Red Hat Enterprise Linux 会在 `/etc/nftables/` 目录中自动创建 `*.nft` 脚本。这些脚本包含为不同目的创建表和空链的命令。 		

### 2.2.1. 支持的 nftables 脚本格式

​					`nftables` 脚本环境支持以下格式的脚本： 			

- ​							您可以以与 `nft list ruleset` 命令相同的格式来编写脚本，显示规则集： 					

  ```none
  #!/usr/sbin/nft -f
  
  # Flush the rule set
  flush ruleset
  
  table inet example_table {
    chain example_chain {
      # Chain for incoming packets that drops all packets that
      # are not explicitly allowed by any rule in this chain
      type filter hook input priority 0; policy drop;
  
      # Accept connections to port 22 (ssh)
      tcp dport ssh accept
    }
  }
  ```

- ​							你可以对命令使用与 `nft` 命令相同的语法： 					

  ```none
  #!/usr/sbin/nft -f
  
  # Flush the rule set
  flush ruleset
  
  # Create a table
  add table inet example_table
  
  # Create a chain for incoming packets that drops all packets
  # that are not explicitly allowed by any rule in this chain
  add chain inet example_table example_chain { type filter hook input priority 0 ; policy drop ; }
  
  # Add a rule that accepts connections to port 22 (ssh)
  add rule inet example_table example_chain tcp dport ssh accept
  ```

### 2.2.2. 运行 nftables 脚本

​					您可以通过将其传给 `nft` 工具或直接执行脚本来运行 `nftables` 脚本。 			

**先决条件**

- ​							本节的流程假设您在 `/etc/nftables/example_firewall.nft` 文件中存储了 `nftables` 脚本。 					

**步骤**

- ​							要通过将其传给 `nft` 工具来运行 `nftables` 脚本，请输入： 					

  ```none
  # nft -f /etc/nftables/example_firewall.nft
  ```

- ​							要直接运行 `nftables` 脚本： 					

  1. ​									只需要执行一次的步骤： 							

     1. ​											确保脚本以以下 shebang 序列开头： 									

        ```none
        #!/usr/sbin/nft -f
        ```

        重要

        ​												如果省略 `-f` 参数，`nft` 实用程序不会读取脚本并显示：`Error: syntax error, unexpected newline, expecting string`。 										

     2. ​											可选：将脚本的所有者设置为 `root` ： 									

        ```none
        # chown root /etc/nftables/example_firewall.nft
        ```

     3. ​											使脚本可以被其所有者执行： 									

        ```none
        # chmod u+x /etc/nftables/example_firewall.nft
        ```

  2. ​									运行脚本： 							

     ```none
     # /etc/nftables/example_firewall.nft
     ```

     ​									如果没有输出结果，系统将成功执行该脚本。 							

重要

​						即使 `nft` 成功执行了脚本，在脚本中错误放置的规则、缺少参数或其他问题都可能导致防火墙的行为不符合预期。 				

**其他资源**

- ​							`chown(1)` 手册页 					
- ​							`chmod(1)` 手册页 					
- ​							[系统引导时自动载入 nftables 规则](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_firewalls_and_packet_filters/index#automatically-loading-nftables-rules-when-the-system-boots_writing-and-executing-nftables-scripts) 					

### 2.2.3. 使用 nftables 脚本中的注释

​					`nftables` 脚本环境将 `#` 字符右侧的所有内容都视为注释。 			

**例 2.1. nftables 脚本中的注释**

​						注释可在一行的开始，也可以在命令后： 				

```none
...
# Flush the rule set
flush ruleset

add table inet example_table  # Create a table
...
```

### 2.2.4. 使用 nftables 脚本中的变量

​					要在 `nftables` 脚本中定义变量，请使用 `define` 关键字。您可以在变量中存储单个值和匿名集合。对于更复杂的场景，请使用 set 或 verdict 映射。 			

- 只有一个值的变量

  ​								以下示例定义了一个名为 `INET_DEV` 的变量，其值为 `enp1s0` ： 						`define INET_DEV = *enp1s0*` 							您可以在脚本中使用变量，方法是在 `$` 符号后跟变量名： 						`... add rule inet example_table example_chain iifname **$INET_DEV** tcp dport ssh accept ...`

- 包含匿名集合的变量

  ​								以下示例定义了一个包含匿名集合的变量： 						`define DNS_SERVERS = { *192.0.2.1*, *192.0.2.2* }` 							您可以在脚本中使用变量，方法是在 `$` 符号后跟变量名： 						`add rule inet example_table example_chain ip daddr **$DNS_SERVERS** accept`注意 								请注意，在规则中使用大括号时具有特殊的意义，因为它们表示变量代表一个集合。 							

**其他资源**

- ​							[使用 nftables 命令中的设置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_firewalls_and_packet_filters/getting-started-with-nftables_firewall-packet-filters#using-sets-in-nftables-commands_getting-started-with-nftables) 					
- ​							[在 nftables 命令中使用 verdict 映射](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_firewalls_and_packet_filters/getting-started-with-nftables_firewall-packet-filters#using-verdict-maps-in-nftables-commands_getting-started-with-nftables) 					

### 2.2.5. 在 nftables 脚本中包含文件

​					`nftables` 脚本环境可让管理员通过使用 `include` 语句来包含其他脚本。 			

​					如果您只指定没有绝对或相对路径的文件名，`nftables` 包含了默认搜索路径（设置为 Red Hat Enterprise Linux 上的 `/etc` ）。 			

**例 2.2. 包含默认搜索目录中的文件**

​						从默认搜索目录中包含一个文件： 				

```none
include "example.nft"
```

**例 2.3. 包含目录中的所有 \*.nft 文件**

​						要包括以 `*.nft` 结尾的所有文件，它们存储在 `/etc/nftables/rulesets/` 目录中： 				

```none
include "/etc/nftables/rulesets/*.nft"
```

​						请注意，`include` 语句不匹配以点开头的文件。 				

**其他资源**

- ​							`nft(8)` 手册页中的 `Include files` 部分 					

### 2.2.6. 系统引导时自动载入 nftables 规则

​					`nftables` systemd 服务加载包含在 `/etc/sysconfig/nftables.conf` 文件中的防火墙脚本。这部分论述了如何在系统引导时载入防火墙规则。 			

**先决条件**

- ​							`nftables` 脚本存储在 `/etc/nftables/` 目录中。 					

**步骤**

1. ​							编辑 `/etc/sysconfig/nftables.conf` 文件。 					

   - ​									如果您在安装 `nftables` 软件包时增强了在 `/etc/nftables/` 中创建的 `*.nft` 脚本，请取消对这些脚本的 `include` 语句的注释。 							

   - ​									如果您从头开始编写脚本，请添加 `include` 语句来包含这些脚本。例如，要在 `nftables` 服务启动时载入 `/etc/nftables/*example*.nft` 脚本，请添加： 							

     ```none
     include "/etc/nftables/example.nft"
     ```

2. ​							（可选）启动 `nftables` 服务来载入防火墙规则，而不用重启系统： 					

   ```none
   # systemctl start nftables
   ```

3. ​							启用 `nftables` 服务。 					

   ```none
   # systemctl enable nftables
   ```

**其他资源**

- ​							[支持的 nftables 脚本格式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_firewalls_and_packet_filters/index#supported-nftables-script-formats_writing-and-executing-nftables-scripts) 					

## 2.3. 创建和管理 nftables 表、链和规则

​				本节介绍了如何显示 `nftables` 规则集以及如何管理它们。 		

### 2.3.1. 标准链优先级值和文本名称

​					当创建链时，您可以将 `priority` 设为整数值或标准名称，来指定具有相同 `hook` 值链的顺序。 			

​					名称和值是根据 `xtables` 在注册其默认链时使用的优先级来定义的。 			

注意

​						`nft list chain` 命令默认显示文本优先级值。您可以通过将 `-y` 选项传给命令来查看数字值。 				

**例 2.4. 使用文本值设定优先级**

​						以下命令使用标准优先级值 `50`， 在 `example_table` 中创建一个名为 `example_chain` 的链： 				

​						`# nft add chain inet *example_table* *example_chain* { type *filter* hook *input* priority *50* \; policy accept \; }` 				

​						因为优先级是一个标准值，所以您可以使用文本值： 				

​						`# nft add chain inet *example_table* *example_chain* { type *filter* hook *input* priority *security* \; policy accept \; }` 				

**表 2.1. 标准优先级名称、系列和 hook 兼容性列表**

| 名称     | 值   | 系列                                 | Hook        |
| -------- | ---- | ------------------------------------ | ----------- |
| `raw`    | -300 | `ip` `ip6`、`inet`                   | all         |
| `mangle` | -150 | `ip` `ip6`、`inet`                   | all         |
| `dstnat` | -100 | `ip` `ip6`、`inet`                   | prerouting  |
| `filter` | 0    | `ip`、`ip6`、`inet`、`arp`、`netdev` | all         |
| `安全`   | 50   | `ip` `ip6`、`inet`                   | all         |
| `srcnat` | 100  | `ip` `ip6`、`inet`                   | postrouting |

​					所有系列都使用相同的值，但 `bridge` 系列使用以下值： 			

**表 2.2. 网桥系列的标准优先级名称和 hook 兼容性**

| 名称     | 值   | Hook        |
| -------- | ---- | ----------- |
| `dstnat` | -300 | prerouting  |
| `filter` | -200 | all         |
| `out`    | 100  | output      |
| `srcnat` | 300  | postrouting |

**其他资源**

- ​							`nft(8)` 手册页中的 `Chains` 部分 					

### 2.3.2. 显示 nftables 规则集

​					`nftables` 的规则集包含表、链和规则。本节介绍如何显示规则集。 			

**流程**

- ​							要显示规则集，请输入： 					

  ```none
  # nft list ruleset
  table inet example_table {
    chain example_chain {
      type filter hook input priority filter; policy accept;
      tcp dport http accept
      tcp dport ssh accept
    }
  }
  ```

  注意

  ​								默认情况下，`nftables` 不预先创建表。因此，在没有表的情况下显示主机上设置的规则，`nft list ruleset` 命令不会显示任何结果。 						

### 2.3.3. 创建 nftables 表

​					`nftables` 中的表是包含链、规则、集合和其他对象的集合的名字空间。本节介绍如何创建表。 			

​					每个表都必须定义一个地址系列。表的地址系列定义了表进程的类型。在创建表时，您可以设置以下地址系列之一： 			

- ​							`ip`:仅匹配 IPv4 数据包。如果没有指定地址系列，这是默认设置。 					
- ​							`ip6` ：仅匹配 IPv6 数据包. 					
- ​							`inet`:匹配 IPv4 和 IPv6 数据包。 					
- ​							`arp`:匹配 IPv4 地址解析协议(ARP)数据包。 					
- ​							`bridge`:匹配通过网桥设备的数据包。 					
- ​							`netdev`:匹配来自 ingress 的数据包。 					

**步骤**

1. ​							使用 `nft add table` 命令来创建新表。例如，要创建一个名为 `example_table` 、用来处理 IPv4 和 IPv6 数据包的表： 					

   ```none
   # nft add table inet example_table
   ```

2. ​							另外，还可列出规则集中的所有表： 					

   ```none
   # nft list tables
   table inet example_table
   ```

**其他资源**

- ​							`nft(8)` 手册页中的 `Address families` 部分 					
- ​							`nft(8)` 手册页中的 `Tables` 部分 					

### 2.3.4. 创建 nftables 链

​					chains 是规则的容器。存在以下两种规则类型： 			

- ​							基本链：您可以使用基本链作为来自网络堆栈的数据包的入口点。 					
- ​							常规链：您可以使用常规链作为 `jump` 目标，并更好地组织规则。 					

​					这个步骤描述了如何在现有表中添加基本链。 			

**先决条件**

- ​							已存在您要添加新链的表。 					

**步骤**

1. ​							使用 `nft add chain` 命令来创建新链。例如，要在 `example_table` 中创建一个名为 `example_chain` 的链： 					

   ```none
   # nft add chain inet example_table example_chain { type filter hook input priority 0 \; policy accept \; }
   ```

   重要

   ​								为避免 shell 将分号解析为命令的结尾，请在分号前加上 `\` 转义字符。 						

   ​							这个链过滤传入的数据包。`priority` 参数指定 `nftables` 进程处理相同 hook 值的链的顺序。较低优先级的值优先于优先级更高的值。`policy` 参数设置此链中规则的默认操作。请注意，如果您远程登录到服务器，并将默认策略设置为 `drop`，如果没有其他规则允许远程访问，则会立即断开连接。 					

2. ​							另外，还可以显示所有链： 					

   ```none
   # nft list chains
   table inet example_table {
     chain example_chain {
       type filter hook input priority filter; policy accept;
     }
   }
   ```

**其他资源**

- ​							`nft(8)` 手册页中的 `Address families` 部分 					
- ​							`nft(8)` 手册页中的 `Chains` 部分 					

### 2.3.5. 将规则附加到 nftables 链的末尾

​					本节介绍了如何将规则附加到现有 `nftables` 链的末尾。 			

**先决条件**

- ​							您要添加该规则的链已存在。 					

**步骤**

1. ​							要添加新的规则，请使用 `nft add rule` 命令。例如，要在 `example_table` 的 `example_chain` 中添加一条允许端口 22 上 TCP 流量的规则： 					

   ```none
   # nft add rule inet example_table example_chain tcp dport 22 accept
   ```

   ​							您可以选择指定服务名称而不是端口号。在该示例中，您可以使用 `ssh` 而不是端口号 `22`。请注意，会根据其在 `/etc/services` 文件中的条目将服务名称解析为端口号。 					

2. ​							另外，还可在 `example_table` 中显示所有的链及其规则： 					

   ```none
   # nft list table inet example_table
   table inet example_table {
     chain example_chain {
       type filter hook input priority filter; policy accept;
       ...
       tcp dport ssh accept
     }
   }
   ```

**其他资源**

- ​							`nft(8)` 手册页中的 `Address families` 部分 					
- ​							`nft(8)` 手册页中的 `Rules` 部分 					

### 2.3.6. 在 nftables 链的开头插入一条规则

​					本节介绍了如何在现有 `nftables` 链的开头插入一条规则。 			

**先决条件**

- ​							您要添加该规则的链已存在。 					

**步骤**

1. ​							要插入新规则，请使用 `nft insert rule` 命令。例如，要在 `example_table` 的 `example_chain` 中插入一条允许端口 22 上 TCP 流量的规则： 					

   ```none
   # nft insert rule inet example_table example_chain tcp dport 22 accept
   ```

   ​							您还可以指定服务名称而不是端口号。在该示例中，您可以使用 `ssh` 而不是端口号 `22`。请注意，会根据其在 `/etc/services` 文件中的条目将服务名称解析为端口号。 					

2. ​							另外，还可在 `example_table` 中显示所有的链及其规则： 					

   ```none
   # nft list table inet example_table
   table inet example_table {
     chain example_chain {
       type filter hook input priority filter; policy accept;
       tcp dport ssh accept
       ...
     }
   }
   ```

**其他资源**

- ​							`nft(8)` 手册页中的 `Address families` 部分 					
- ​							`nft(8)` 手册页中的 `Rules` 部分 					

### 2.3.7. 在 nftables 链的特定位置插入一条规则

​					本节介绍了如何在 `nftables` 链中现有规则的前和后插入规则。这样，您可以将新规则放在正确的位置上。 			

**先决条件**

- ​							您要添加规则的链存在。 					

**步骤**

1. ​							使用 `nft -a list ruleset` 命令显示 `example_table` 中的所有的链及其规则，包括它们的句柄： 					

   ```none
   # nft -a list table inet example_table
   table inet example_table { # handle 1
     chain example_chain { # handle 1
       type filter hook input priority filter; policy accept;
       tcp dport 22 accept # handle 2
       tcp dport 443 accept # handle 3
       tcp dport 389 accept # handle 4
     }
   }
   ```

   ​							使用 `-a` 显示句柄。您需要此信息才能在后续步骤中定位新规则。 					

2. ​							在 `example_table` 的 `example_chain` 链中插入新规则 ： 					

   - ​									要在句柄 `3` 前插入一条允许端口 `636` 上TCP 流量的规则，请输入： 							

     ```none
     # nft insert rule inet example_table example_chain position 3 tcp dport 636 accept
     ```

   - ​									要在句柄 `3` 后添加一条允许端口 `80` 上 TCP 流量的规则，请输入： 							

     ```none
     # nft add rule inet example_table example_chain position 3 tcp dport 80 accept
     ```

3. ​							另外，还可在 `example_table` 中显示所有的链及其规则： 					

   ```none
   # nft -a list table inet example_table
   table inet example_table { # handle 1
     chain example_chain { # handle 1
       type filter hook input priority filter; policy accept;
       tcp dport 22 accept # handle 2
       tcp dport 636 accept # handle 5
       tcp dport 443 accept # handle 3
       tcp dport 80 accept # handle 6
       tcp dport 389 accept # handle 4
     }
   }
   ```

**其他资源**

- ​							`nft(8)` 手册页中的 `Address families` 部分 					
- ​							`nft(8)` 手册页中的 `Rules` 部分 					

## 2.4. 使用 nftables 配置 NAT

​				使用 `nftables`，您可以配置以下网络地址转换(NAT)类型： 		

- ​						伪装 				
- ​						源 NAT（SNAT） 				
- ​						目标 NAT（DNAT） 				
- ​						重定向 				

重要

​					您只能在 `iifname` 和 `oifname` 参数中使用实际接口名称，不支持其他名称(`altname`)。 			

### 2.4.1. 不同的 NAT 类型： masquerading、source NAT、destination NAT 和 redirect

​					这些是不同的网络地址转换（NAT）类型： 			

- 伪装和源 NAT（SNAT）

  ​								使用以上 NAT 类型之一更改数据包的源 IP 地址。例如，互联网服务提供商不会路由私有 IP 范围，如 `10.0.0.0/8`。如果您在网络中使用私有 IP 范围，并且用户应该能够访问 Internet 上的服务器，请将这些范围内的数据包的源 IP 地址映射到公共 IP 地址。 						 							伪装和 SNAT 都非常相似。不同之处是： 						 									伪装自动使用传出接口的 IP 地址。因此，如果传出接口使用了动态 IP 地址，则使用伪装。 								 									SNAT 将数据包的源 IP 地址设置为指定的 IP 地址，且不会动态查找传出接口的 IP 地址。因此，SNAT 要比伪装更快。如果传出接口使用了固定 IP 地址，则使用 SNAT。 								

- 目标 NAT（DNAT）

  ​								使用此 NAT 类型重写传入数据包的目标地址和端口。例如，如果您的 Web 服务器使用私有 IP 范围内的 IP 地址，那么无法直接从互联网访问它，您可以在路由器上设置 DNAT 规则，以便将传入的流量重定向到此服务器。 						

- 重定向

  ​								这个类型是 IDT 的特殊示例，它根据链 hook 将数据包重定向到本地机器。例如，如果服务运行在与其标准端口不同的端口上，您可以将传入的流量从标准端口重定向到此特定端口。 						

### 2.4.2. 使用 nftables 配置伪装

​					伪装使路由器动态地更改通过接口到接口 IP 地址发送的数据包的源 IP。这意味着，如果接口被分配了新的 IP，`nftables` 会在替换源 IP 时自动使用新的 IP。 			

​					以下流程描述了如何将通过 `ens3` 接口的离开主机的数据包的源 IP 替换为 `ens3` 上设置的 IP。 			

**步骤**

1. ​							创建一个表： 					

   ```none
   # nft add table nat
   ```

2. ​							将 `prerouting` 和 `postrouting` 链添加到表中： 					

   ```none
   # nft -- add chain nat prerouting { type nat hook prerouting priority -100 \; }
   # nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
   ```

   重要

   ​								即使您没有向 `prerouting` 添加规则，`nftables` 框架也要求此链与传入的数据包回复匹配。 						

   ​							请注意，您必须将 `--` 选项传给 `nft` 命令，以避免 shell 将负优先级的值解析为 `nft` 命令的一个选项。 					

3. ​							在 `postrouting` 链中添加一条与 `ens3` 接口上的传出数据包匹配的规则： 					

   ```none
   # nft add rule nat postrouting oifname "ens3" masquerade
   ```

### 2.4.3. 使用 nftables 配置源 NAT

​					在路由器中，源 NAT（SNAT）可让您将通过接口发送的数据包 IP 改为专门的 IP 地址。 			

​					以下流程描述了如何将通过 `ens3` 接口的离开路由器的数据包的源 IP 替换为 `192.0.2.1`。 			

**步骤**

1. ​							创建一个表： 					

   ```none
   # nft add table nat
   ```

2. ​							将 `prerouting` 和 `postrouting` 链添加到表中： 					

   ```none
   # nft -- add chain nat prerouting { type nat hook prerouting priority -100 \; }
   # nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
   ```

   重要

   ​								即使您没有向 `postrouting` 链添加规则，`nftables` 框架也要求此链与传出的数据包回复匹配。 						

   ​							请注意，您必须将 `--` 选项传给 `nft` 命令，以避免 shell 将负优先级的值解析为 `nft` 命令的一个选项。 					

3. ​							在 `postrouting` 链中添加一条规则，其将通过 `ens3` 传出的数据包的源 IP 替换为 `192.0.2.1` ： 					

   ```none
   # nft add rule nat postrouting oifname "ens3" snat to 192.0.2.1
   ```

## 网络区域

firewalld 预定义的九种网络区域（默认情况就有一些有效的区域，由 firewalld 提供的区域按照从不信任到信任的顺序排序）：

* trusted

  信任区域：允许所有网络通信通过，因为该区域是最被信任的，即使没有设置任何的服务，那么也是被允许的，因为该区域是允许所有连接的。

* public

  公共区域：只接受那些被选中的连接，默认只允许 ssh 和 dhcpv6-client ，是缺省 zone。在没有任何配置的情况下走的是公共区域。

* work

  工作区域：在这个区域中，只能定义内部网络，比如私有网络通信才被允许，只允许 ssh、ipp-client 和 dhcpv6-client 。

* home

  家庭区域：用于家庭环境，同样只允许被选中的连接，即 ssh、ipp-client、mdns、samba-client 和 dhcpv6-client 。

* internal

  内部区域：和 Work Zone 类似，只允许通过被选中的连接，与 Home Zone 相同。

* external

  外部区域：这个区域相当于路由器的启动伪装（masquerading）选项，只有指定的连接会被接受，即 ssh，而其他的连接将被丢弃或者不被接受。

* dmz

  隔离区域：如果想要只允许给部分服务能被外部访问，可以在DMZ区域中定义，它也拥有只通过被选中连接的特性，即 ssh 。

* block

  阻塞区域：阻塞区域会拒绝进入的网络连接，返回 icmp-host-prohibited ，只有服务器已经建立的连接会被通过，即只允许由该系统初始化的网络连接。

* drop
  丢弃区域（Drop Zone）：如果使用丢弃区域，任何进入的数据包将被丢弃，类似于 Centos 6 上的 `iptables -j drop` ，使用丢弃规则意味着将不存在响应。 

不是所有的区域（Zone）都在使用，只有活跃的区域（Zone）才有实际操作意义。因为默认区域只允许 ssh 和 dhcp，所以在没有任何配置的情况下默认是拒绝 ping 包的。

## 检查原则

如果一个客户端访问服务器，服务器根据以下原则决定使用哪个区域（zone）的策略去匹配：

*  如果一个客户端数据包的源 IP 地址匹配 Zone 的来源（sources） 也就是匹配区域的规则，那么该 Zone 的规则就适用这个客户端，一个源只能属于一个 Zone，不能同时属于多个 Zone 。
* 如果一个客户端数据包进入服务器的某一个接口（如 ens33 网卡接口）匹配了 Zone 的接口（interfaces），则该Zone的规则就适用这个客户端，一个接口只能属于一个 Zone ，不能同时属于多个 Zone 。
* 如果上述两个原则都不满足，那么默认的 Zone 将被应用 firewalld 数据处理流程，检查数据来源的源地址。

## 数据处理流程

检查数据来源的源地址

*  若源地址关联到特定的区域，则执行该区域所制定的规则。
* 若源地址未关联到特定的区域，则使用关联网络接口的区域并执行该区域所制定的规则。
* 若网络接口未关联到特定的区域，则使用默认区域并执行该区域所制定的规则。

## 数据包处理原则

检查源地址的处理规则

- 匹配源地址所在区域
- 匹配入站接口所在区域
- 匹配默认区域

## 配置方法

**有三种配置方法，分别是：**

- firewall-config 图行化工具
- firewall-cmd 命令行工具
- /etc/firewalld/ 中的配置文件

### firewall-config

 ![窗口](https://img-blog.csdnimg.cn/20210104165643408.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3J6eTEyNDg4NzM1NDU=,size_16,color_FFFFFF,t_70)

**配置：** 运行时和永久 **`（运行时的是服务重启失效，永久的是服务重启生效）`**
 ![配置](https://img-blog.csdnimg.cn/20210104165718584.png)

**区域：**

- 服务 ：哪些服务可信

- 端口 ：允许访问的端口范围

- 协议 ：可访问的协议

- 源端口 ：额外的源端口或范围

- 伪装 ：私有地址映射为公有ip

- 端口转发 ：指定端口映射为其他端口 **`（本机或者其他主机）`**

- ICMP过滤器 ：设置具体的icmp类型
   ![区域选项卡](https://img-blog.csdnimg.cn/20210105091926307.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3J6eTEyNDg4NzM1NDU=,size_16,color_FFFFFF,t_70)

  

  **服务：** **`（只适用于永久模式）`**

  - 模块 ：设置网络过滤的辅助模块
  - 目标 ：如果指定了目的地址，服务则仅限于目的地址和类型，默认没有限制
     ![服务子选择项](https://img-blog.csdnimg.cn/20210105100612157.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3J6eTEyNDg4NzM1NDU=,size_16,color_FFFFFF,t_70)

### firewall-cmd

```bash
# 启动、停止、查看firewalld服务
systemctl start firewalld
systemctl enable firewalld

systemctl stop firewalld

systemctl status firewalld
firewall-cmd --state

# 查看预定义信息
# 查看可用区域
firewall-cmd --get-zones

# 查看防火墙默认区域
firewall-cmd --get-default-zone

# 查看防火墙可用服务
firewall-cmd --get-service

# 查看防火墙可用的icmp阻塞类型
firewall-cmd --get-icmptypes 

# 拒绝所有包
firewall-cmd --panic-on    
# 取消拒绝状态
firewall-cmd --panic-off
# 查看是否拒绝
firewall-cmd --query-panic
```

#### 清空防火墙规则

当防火墙配置了很多规则想一次性清空，firewalld 默认没有命令来清空规则，可以通过编辑配置文件来清除规则。
/etc/firewalld/zones/ 此处为配置生效后保存的配置文件，建议修改前先备份。

```bash
# 此目录会显示已经配置的规则
ll /etc/firewalld/zones/
=======================================
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
</zone>
========================================
firewall-cmd --set-default-zone=public
systemctl restart firewalld
```

#### 区域管理选项说明

```bash
--get-default-zone
# 显示网络连接或接口的默认区域
--set-default-zone=区域名称
# 设置网络连接或接口的默认区域
--get-active-zones
# 显示已激活的所有区域
--get-zone-of-interface=网卡名称
# 显示指定接口绑定的区域
--zone=区域名称 --add-interface=网卡名称
# 为指定接口绑定区域
--zone=区域名称 --change-interface=网卡名称
# 为指定的区域更改绑定的网络接口
--zone=区域名称 --remove-interface=网卡名称
# 为指定的区域删除绑定的网络接口
--list-all-zones
# 显示所有区域及其规则
--zone=区域名称 --list-all
# 显示指定区域的所有规则
--list-all
# 显示默认区域的所有规则
```

##### 示例

```bash
# 显示当前系统的默认区域
firewall-cmd --get-default-zone 
public
******显示默认区域的所有规则
[root@Firewalld ~]# firewall-cmd --list-all
public (active)                    （表示public这个区域是活动区域即可用区域，如果是默认区域会多一个defaults）
  target: default                  
  icmp-block-inversion: no         
  interfaces: ens33                （表示public这个区域的网卡接口是ens33）
  sources:                         （列出了public这个区域的源，现在这里没有，但是如果有的话，格式是xxx.xxx.xxx.xxx/xx）
  services: dhcpv6-client ssh      （表示public区域允许通过的服务类型）
  ports:                           （表示public区域允许通过的端口）
  protocols:                       （允许的通过的协议）
  masquerade: no                   （表示这个区域不允许ip伪装，如果允许的话也同时会允许IP转发，即开启路由功能）
  forward-ports:                   （列出转发的端口）
  source-ports:                   
  icmp-blocks:                     （列出阻塞icmp流量的黑名单）
  rich rules:                      （在public区域中优先处理的高级配置）
-------------------------华丽丽的分割线-------------------------
target的作用：
当一个区域处理它的源或接口上的一个包时，但是没有处理该包的显式规则时，这个时候区域的目标target决定了该行为
（1）ACCEPT ： 通过这个包
（2）%%REJECT%% ： 拒绝这个包，并且返回一个拒绝的回复
（3）DROP ： 丢弃这个包，不回复任何信息
（4）default ： 不做任何事情，该区域不再管他，把它提到“楼上”
--------------------------------------------------------------
******显示网络接口ens33的对应区域
[root@Firewalld ~]# firewall-cmd --get-zone-of-interface=ens33
public                           （说明ens33的区域是public）
******更改ens33的区域为internal
[root@Firewalld ~]# firewall-cmd --zone=internal --change-interface=ens33 
success                          （更改成功）
[root@Firewalld ~]# firewall-cmd --get-zone-of-interface=ens33
internal                         （再次查看发现已经更改为internal区域）
******查看全部活动区域
[root@Firewalld ~]# firewall-cmd --get-active-zones 
internal
  interfaces: ens33
```

### - 服务管理选项说明：

```bash
***服务存放在/usr/lib/firewalld/services目录中，通过单个的xml配置文件来指定
***xml文件：service-name。xml
（1）--zone=区域名称 --list-services                         显示指定区域内允许访问的所有服务
（2）--zone=区域名称 --add-service=服务名称                   为指定区域设置允许访问的某项服务
（3）--zone=区域名称 --remove-service=服务名称                删除指定区域已设置的允许访问的某项服务
（4）--zone=区域名称 --list-ports                            显示指定区域内允许访问的所有端口号
（5）--zone=区域名称 --add-port=端口号-端口号/协议名          为指定区域设置允许访问的某个或某段端口号并指定协议名（中间的-表示从多少到多少端口号， / 和后面跟端口的协议）
（6）--zone=区域名称 --remove-port=端口号-端口号/协议名        删除指定区域已设置的允许访问的某个端口号或某段端口号并且指定协议名（中间的-表示从多少到多少端口号， / 和后面跟端口的协议）
（7）--zone=区域名称 --list-icmp-blocks                      显示指定区域内拒绝访问的所有ICMP类型
（8）--zone=区域名称 --add-icmp-block=icmp类型               为指定区域设置拒绝访问的某项ICMP类型
（9）--zone=区域名称 --remove-icmp-block=icmp类型            删除指定区域已设置的拒绝访问的某项ICMP类型，省略 --zone=区域名称 时表示对默认区域操作
```

#### - 示例：

```bash
******显示默认区域允许访问的所有服务
[root@Firewalld ~]# firewall-cmd --list-services
You're performing an operation over default zone ('public'),
but your connections/interfaces are in zone 'internal' (see --get-active-zones)
You most likely need to use --zone=internal option.

dhcpv6-client ssh    （说明允许dhcp和ssh）
******设置默认区域允许访问http和https服务 （不加--zone指定的话就是配置默认区域）
[root@Firewalld ~]# firewall-cmd --add-service=http
You're performing an operation over default zone ('public'),
but your connections/interfaces are in zone 'internal' (see --get-active-zones)
You most likely need to use --zone=internal option.

success
[root@Firewalld ~]# firewall-cmd --add-service=https
You're performing an operation over default zone ('public'),
but your connections/interfaces are in zone 'internal' (see --get-active-zones)
You most likely need to use --zone=internal option.

success
[root@Firewalld ~]# firewall-cmd --list-services   （再次查看）
You're performing an operation over default zone ('public'),
but your connections/interfaces are in zone 'internal' (see --get-active-zones)
You most likely need to use --zone=internal option.

dhcpv6-client http https ssh  （多了http和https）
1234567891011121314151617181920212223242526
预定义的服务可以使用服务名配置，同时其对应端口会自动打开，非预定义的服务只能手动指定端口
******给指定区域添加tcp443端口
[root@Firewalld ~]# firewall-cmd --zone=internal --add-port=443/tcp
success
[root@Firewalld ~]# firewall-cmd --zone=internal --list-all 
internal (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33
  sources: 
  services: dhcpv6-client mdns samba-client ssh
  ports: 443/tcp  （发现添加成功）
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

******删除指定区域的443/tcp端口
[root@Firewalld ~]# firewall-cmd --zone=internal --remove-port=443/tcp
success
[root@Firewalld ~]# firewall-cmd --zone=internal --list-all 
internal (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33
  sources: 
  services: dhcpv6-client mdns samba-client ssh
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
123456789101112131415161718192021222324252627282930313233343536
```

### - 两种配置方式

- **运行时模式（runtime mode）：** 当前内存中运行，系统或防火墙服务重启或停止，配置失效
- **永久模式（permanent mode）：** 永久存储在配置文件中，但是配置完成要重启系统或防火墙

```bash
******相关选项：（配置时添加此选项即可）
--reload 将永久配置应用为运行时配置 
--permanent 设置永久性规则。服务重启或重新加载时生效 
--runtime-to-permanent 将当前的运行时配置写入规则，成为永久性配置 
1234
```

文章知识点与官方知识档案匹配，可进一步学习相关知识

[CS入门技能树](https://bbs.csdn.net/skill/gml/gml-0e773f845e08441798e9ebae59547e1a)[Linux环境安装](https://bbs.csdn.net/skill/gml/gml-0e773f845e08441798e9ebae59547e1a)[安装CentOS](https://bbs.csdn.net/skill/gml/gml-0e773f845e08441798e9ebae59547e1a)1363 人正在系统学习中

[![img](https://profile.csdnimg.cn/E/5/8/3_rzy1248873545)礁之](https://renzeyuan.blog.csdn.net)

​                    [已关注](javascript:;)                            

- ​                                                            ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newHeart2021Black.png)                                          5                                                    
- ​                                            ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newUnHeart2021Black.png)                                                    
- ​            [                 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newComment2021Black.png)                 5             ](https://blog.csdn.net/rzy1248873545/article/details/112168647#commentBox)                        
- ​            [                                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newCollectBlack.png)                                                       8                              ](javascript:;)                        
- ​            
- ​                [                     ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newShareBlack.png)                 ](javascript:;)                            

​                    专栏目录                

[ 					*Linux* *firewalld* *防火墙*使用 				](https://wangmaoxiong.blog.csdn.net/article/details/80738012)

​					[蚩尤后裔](https://blog.csdn.net/wangmx1993328) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				2万+ 				 			

[ 				目录  firewall *防火墙*服务简述与安装  *firewalld* 服务基本使用  *firewalld*-cmd 防护墙命令使用  public.xml 文件修改*防火墙*端口  注意事项  firewall *防火墙*服务简述与安装  1*、**Centos7* 默认的*防火墙**是* firewall*，*替代了以前的 iptables  2*、*firewall 使用更加方便*、*功能也更加强大一些  3*、**firewalld* ... 			](https://wangmaoxiong.blog.csdn.net/article/details/80738012)

[ 					*firewalld*的图形化管理和命令管理(内含伪装和转发) 				](https://blog.csdn.net/ymeng9527/article/details/90721991)

​					[ymeng9527的博客](https://blog.csdn.net/ymeng9527) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				1489 				 			

[ 				1.*什么**是**firewalld*？ *防火墙**（*Firewall*）**，*也称防护墙*，**是*由Check Point创立者Gil Shwed于1993年发明并引入国际互联网*（*US5606668*（*A*）*1993-12-15*）* *防火墙**是*位于内部网和外部网之间的屏障*，*它按照系统管理员预先定义好的*规则*来控制数据包的进出 *防火墙**是*系统的第一道防线*，*其作用*是*防止非法用户的进入  *centos* 7中*防火墙**FirewallD**是*一个非... 			](https://blog.csdn.net/ymeng9527/article/details/90721991)



评论5

​			[ 				![img](https://profile.csdnimg.cn/0/B/E/3_weixin_43835748) 			](https://renzeyuan.blog.csdn.net) 	

​					 				

​						![表情包](https://csdnimg.cn/release/blogv2/dist/pc/img/commentEmotionIcon.png) 					 					 				

​						![表情包](https://csdnimg.cn/release/blogv2/dist/pc/img/commentCodeIcon.png) 					 					 				

​						 					 					 					 					

- [![WANTAWAY314](https://profile.csdnimg.cn/C/9/9/3_wantaway314)](https://blog.csdn.net/WANTAWAY314)

  [ water___Wang](https://blog.csdn.net/WANTAWAY314) 2021.02.23

  ![点赞](https://csdnimg.cn/release/blogv2/dist/pc/img/commentLikeBlack.png)

  ![表情包](https://g.csdnimg.cn/static/face/monkey2/062.png)![表情包](https://g.csdnimg.cn/static/face/monkey2/062.png)

- [![weixin_46902396](https://profile.csdnimg.cn/4/C/F/3_weixin_46902396)](https://blog.csdn.net/weixin_46902396)

  [ 愿许浪尽天涯](https://blog.csdn.net/weixin_46902396) 2021.01.11

  ![点赞](https://csdnimg.cn/release/blogv2/dist/pc/img/commentLikeBlack.png)1

  棒棒哒

- [![qq_42444778](https://profile.csdnimg.cn/E/2/1/3_qq_42444778)](https://blog.csdn.net/qq_42444778)

  [ 不如温暖过生活](https://blog.csdn.net/qq_42444778) 2021.01.07

  ![点赞](https://csdnimg.cn/release/blogv2/dist/pc/img/commentLikeBlack.png)1

  专业，太牛了，欢迎回踩互粉哦

- <
- 1
- 2
- \>

[					                *Firewalld**防火墙*_从不吃素陈长老的博客				                  ](https://blog.csdn.net/weixin_50344760/article/details/110081962)

​                        3-29                      

[                      一*、**Firewalld*概述 *Firewalld**简介* 1.支持*网络*区域所定义的*网络*链接以*及*接口安全等级的动态*防火墙*管理工具 2.支持IPv4,IPv6*防火墙*设置以*及*以太网桥 3.支持服务或应用程序直接添加*防火墙**规则*接口                     ](https://blog.csdn.net/weixin_50344760/article/details/110081962)

[					                *firewalld*_贪吃小松鼠的博客				                  ](https://blog.csdn.net/weixin_55614692/article/details/118527315)

​                        2-26                      

[                      1.*简介*在RHEL7里有几种*防火墙*共存:*firewalld**、*iptables*、*ebtables,默认*是*使用*firewalld*来管理netfilter子系统,不过底层调用的命令仍然*是*iptables等。——iptables的具体配置在下一章博客中会详细介绍,本章主要介绍*Firewalld* *Firewalld*与iptab...                    ](https://blog.csdn.net/weixin_55614692/article/details/118527315)

[ 					*CentOS7*中*firewalld*的安装与使用详解 				](https://blog.csdn.net/weixin_30376163/article/details/97967356)

​					[weixin_30376163的博客](https://blog.csdn.net/weixin_30376163) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				1057 				 			

[ 				一*、*软件环境 [root@Geeklp201 ~\]# cat /etc/redhat-release  *CentOS* *Linux* release 7.4.1708 (Core)       二*、*安装*firewalld* 1*、**firewalld*提供了支持*网络*/*防火墙*区域(zone)定义*网络*链接以*及*接口安全等级的动态*防火墙*管理工具。它支持 IPv4, IPv6 *防火墙*... 			](https://blog.csdn.net/weixin_30376163/article/details/97967356)

[ 					@*linux* --*firewalld**防火墙*概述 				](https://blog.csdn.net/weixin_55972781/article/details/115364936)

​					[ଲ一笑奈@何](https://blog.csdn.net/weixin_55972781) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				161 				 			

[ 				*firewalld**防火墙* 一*、**防火墙*安全概述 在*CentOS7*系统中集成了多款*防火墙*管理工具*，*默认启用的*是**firewalld**（*动态*防火墙*管理器*）**防火墙*管理工具*，**Firewalld*支持CLI*（*命令行*）*以*及*GUI*（*图形*）*的两种管理方式。  对于接触*Linux*较早的人员对Iptables比较熟悉*，*但由于Iptables的*规则*比较的麻烦*，*并且对*网络*有一定要求*，*所以学习成本较高。但*firewalld*的学习对*网络*并没有那么高的要求*，*相对iptables来说要简单不少*，*所以建议刚接触*CentOS7*系统的人员直接学习Fir 			](https://blog.csdn.net/weixin_55972781/article/details/115364936)

[					                *linux*两堵墙之一:*firewalld*_风雨兼程,披星戴月。的博客...				                  ](https://blog.csdn.net/qq_42534026/article/details/105074400)

​                        4-2                      

[                      *firewalld* *是*一款动态*防火墙*管理器。 *firewalld* 通过“*网络*/*防火墙*”空间的方式,为不同的 *网络*连接 或 接口 定义其自身的信任等级,通过这种方式达到了动态管理的效果。同时,它支持 IPv4*、*IPv6 *防火墙*的设置 *、*以太网网桥以*及* 配置选项...                    ](https://blog.csdn.net/qq_42534026/article/details/105074400)

[					                *Firewalld**防火墙*基础_xwy9526的博客				                  ](https://blog.csdn.net/xwy9526/article/details/112284374)

​                        2-21                      

[                      *什么**是*DMZ区域,DMZ区域的作用与原理一. 概念: DMZ*是*为了解决安装*防火墙*后外部*网络*的访问用户不能访问内部*网络*服务器的问题,而设立的一个非安全系统与安全系统之间的缓冲区。该缓冲区位于企业内部*网络*和外部*网络*之间的小*网络*区域内。在这个...                    ](https://blog.csdn.net/xwy9526/article/details/112284374)

[ 					三章——*firewalld**防火墙**（*二*）**（*应用——*linux*防护与群集*）* 					最新发布 				](https://blog.csdn.net/KW__jiaoq/article/details/119824191)

​					[MKC__jiaoq的博客](https://blog.csdn.net/KW__jiaoq) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				230 				 			

[ 				三期总目录链接  			](https://blog.csdn.net/KW__jiaoq/article/details/119824191)

[ 					*Firewalld*详解 				](https://blog.csdn.net/meltsnow/article/details/88392497)

​					[meltsnow的博客](https://blog.csdn.net/meltsnow) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				3913 				 			

[ 				1.*简介* 在RHEL7里有几种*防火墙*共存：*firewalld**、*iptables*、*ebtables*，*默认*是*使用*firewalld*来管理netfilter子系统*，*不过底层调用的命令仍然*是*iptables等。——iptables的具体配置在下一章博客中会详细介绍*，*本章主要介绍*Firewalld* *Firewalld*与iptables对比 *firewalld* *是* iptables 的前端控制器 iptabl... 			](https://blog.csdn.net/meltsnow/article/details/88392497)

[ 					*防火墙**（**firewalld*与iptables*）* 					热门推荐 				](https://blog.csdn.net/weixin_40658000/article/details/78708375)

​					[一涵的博客](https://blog.csdn.net/weixin_40658000) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				5万+ 				 			

[ 				*防火墙**是*整个数据包进入主机前的第一道关卡。*防火墙*主要通过Netfilter与TCPwrappers两个机制来管理的。  1*）*Netfilter：数据包过滤机制  2*）*TCP Wrappers：程序管理机制  关于数据包过滤机制有两个软件：*firewalld*与iptables  关于两者的不同介绍如下：  1    2 iptables通过控制端口来控制服务*，*而*firewalld*则*是*通过控制协议来控制 			](https://blog.csdn.net/weixin_40658000/article/details/78708375)

[ 					*Linux* *Firewalld*用法*及*案例 				](https://blog.csdn.net/xiazichenxi/article/details/80169927)

​					[陈洋的博客](https://blog.csdn.net/xiazichenxi) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				1万+ 				 			

[ 				官方文档   RHEL *FIREWALLD*     *Firewalld*概述   动态*防火墙*管理工具 定义区域与接口安全等级 运行时和永久配置项分离 两层结构  核心层 处理配置和后端*，*如iptables*、*ip6tables*、*ebtables*、*ipset和模块加载器 顶层D-Bus 更改和创建*防火墙*配置的主要方式。所有*firewalld*都使用该接口提供在线工具     原理图        Fire... 			](https://blog.csdn.net/xiazichenxi/article/details/80169927)

[ 					*firewalld* 操作指南 				](https://blog.csdn.net/weixin_43273168/article/details/85109597)

​					[weixin_43273168的博客](https://blog.csdn.net/weixin_43273168) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				1625 				 			

[ 				*Firewalld**简介*：   *firewalld**是**centos7*的一大特性*，**firewalld*同时拥有命令行终端和图形化界面的配置工具*，*相比于iptables对火墙的管理更加容易上手但没有iptables控制精准*，*最大的好处有两个：支持动态更新*，*不用重启服务；第二个就*是*加入了*防火墙*的zone概念,以分配对一个*网络**及*其相关链接和界面一定程度的信任。支持以太网桥并有分离运行时间*及*永久配置选择*，*并且还具... 			](https://blog.csdn.net/weixin_43273168/article/details/85109597)

[ 					*CentOS7*使用*firewalld*打开关闭*防火墙*与端口 				](https://gblfy.blog.csdn.net/article/details/91411010)

​					[Gblfy_Blog](https://blog.csdn.net/weixin_40816738) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				135 				 			

[ 				1*、**firewalld*的基本使用 启动： systemctl start *firewalld* 关闭： systemctl stop *firewalld* 查看状态： systemctl status *firewalld* 开机禁用  ： systemctl disable *firewalld* 开机启用  ： systemctl enable *firewalld* 2.systemctl*是**CentOS7*的... 			](https://gblfy.blog.csdn.net/article/details/91411010)

[ 					*Firewalld* 详解 				](https://blog.csdn.net/wo18237095579/article/details/89376763)

​					[大漠知秋的小秘密](https://blog.csdn.net/wo18237095579) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				2584 				 			

[ 				文章目录*Firewalld*好处详解zone*网络*请求如何判断使用哪个 zone 的servicerich langulage rule理解多*规则*命令常用命令收集关于 zone配置文件关于 source关于 interface*（*网卡*）*关于 port关于服务配置文件关于伪装 ip关于转发关于 rich language rule其他配置特殊说明 *Firewalld*   *Linux* 上新的*防火墙*软件*，*和原... 			](https://blog.csdn.net/wo18237095579/article/details/89376763)

[ 					*Firewalld*概述 				](https://blog.csdn.net/m0_55614372/article/details/118728606)

​					[m0_55614372的博客](https://blog.csdn.net/m0_55614372) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				78 				 			

[ 				一*、**Firewalld*概述  1.*firewalld**防火墙**是**Centos7*系统默认的*防火墙*管理工具*，*取代了之前的iptables*防火墙**，*也*是*工作在*网络*层*，*属于包过滤*防火墙*  2.*firewalld*提供了支持*网络*区域所定义的*网络*连接以*及*接口安全等级的动态*防火墙*管理工具。  二*、**firewalld*与iptables 的区别  1.ipta... 			](https://blog.csdn.net/m0_55614372/article/details/118728606)

[ 					*Linux*下*防火墙*管理之*firewalld* 				](https://blog.csdn.net/weixin_45792518/article/details/105065056)

​					[weixin_45792518的博客](https://blog.csdn.net/weixin_45792518) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				117 				 			

[ 				1.*firewalld*的开启 systemctl stop iptables  systemctl disable iptables systemctl mask iptables  systemctl unmask *firewalld* systemctl enable --now *firewalld*   2.关于*firewalld*的域 trusted 	##接受所有的*网络*连接 home 		##... 			](https://blog.csdn.net/weixin_45792518/article/details/105065056)

[ 					*CentOS* 7:*firewalld*启动不了 提示 Active: failed (Result: timeout) 				](https://blog.csdn.net/crynono/article/details/76132611)

​					[crynono的博客](https://blog.csdn.net/crynono) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				2万+ 				 			

[ 				查看status如下： [root@localhost ~\]# systemctl status *firewalld*.service -l [0m *firewalld*.service - *firewalld* - dynamic firewall daemon   Loaded: loaded (/usr/lib/systemd/system/*firewalld*.service; enabl 			](https://blog.csdn.net/crynono/article/details/76132611)

[ 					*firewalld* 端口*、*富*规则* 				](https://blog.csdn.net/qq_44029297/article/details/98754458)

​					[舍人的学习工厂](https://blog.csdn.net/qq_44029297) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				3756 				 			

[ 				章节概述： 保证数据的安全性*是*继可用性之后最为重要的一项工作*，**防火墙*技术作为公网与内网之间的保护屏障*，*起着至关重要的作用。 本章节内将会分别使用iptables*、*firewall-cmd*、*firewall-config和Tcp_wrappers等*防火墙**策略*配置服务*，*够熟练的对请求数据包流量进行过滤*，*还能够基于服务程序进行允许和关闭操作*，*从更好的层面保证了*Linux*系统的安全... 			](https://blog.csdn.net/qq_44029297/article/details/98754458)

[ 					*Linux*下*防火墙*服务：*firewalld*服务以*及*iptables服务的部署与相关命令 				](https://blog.csdn.net/Leslie_qlh/article/details/99711283)

​					[Leslie_qlh的博客](https://blog.csdn.net/Leslie_qlh) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				351 				 			

[ 				*防火墙*服务 文章目录*防火墙*服务1.配置2.*Firewalld*的域3.*Firewalld*设置4.*Firewalld*中网卡与ip设置*（*1*）*网卡设置：测试：*（*2*）*ip设置测试：4.火墙添加服务：5.火墙中的端口修改*（*1*）*临时修改*（*2*）*永久修改命令修改：文件修改：5.火墙的刷新测试：6*、*火墙的三表五链*（*1*）*filter表*（*2*）*nat表*（*3*）*mangle表7*、*地址伪装和端口转发8.iptables火墙服务*（*... 			](https://blog.csdn.net/Leslie_qlh/article/details/99711283)

[ 					【RHEL7/*CentOS7**防火墙*之firewall-cmd命令详解】 				](https://blog.csdn.net/weixin_30408165/article/details/97675859)

​					[weixin_30408165的博客](https://blog.csdn.net/weixin_30408165) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				5005 				 			

[ 				目录                       *Firewalld* zone         firewall-cmd         开始配置*防火墙**策略*         总结                Redhat Enterprise *Linux*7已默认使用*firewalld**防火墙**，*其管理工具*是*firewall-cmd。使用方式也发生了很大的改变。 基于iptables的*防火墙*... 			](https://blog.csdn.net/weixin_30408165/article/details/97675859)

[ 					*firewalld**防火墙* 				](https://blog.csdn.net/weixin_45950635/article/details/109628286)

​					[weixin_45950635的博客](https://blog.csdn.net/weixin_45950635) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				239 				 			

[ 				firewall *防火墙* 技能展示 理解frewalda方火墙基本原理 使用firewall-confg配置*防火墙* 使用firewall-cmd配置*防火墙* *简介*  在hternet 中,企业通过架设各种应用系统来为用户提供各种*网络*服务,如Web网站,电子邮件系统, FTP服务器,数据库系统等。那么,如何来保护这些服务器,过滤企业非授权的访问,甚至*是*·恶意的入侵呢? 本章将开始学习*Linux*系统中的*防火墙*-netiter frewalld ,括*防火墙*的结构与匹配流程以*及*如何编写*防火墙**规则*  重点 熟悉frew 			](https://blog.csdn.net/weixin_45950635/article/details/109628286)

[ 					*firewalld*拓展*、*chkconfig说明 				](https://blog.csdn.net/chuangai7820/article/details/100814244)

​					[chuangai7820的博客](https://blog.csdn.net/chuangai7820) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 				55 				 			

[ 				*firewalld*默认的9个zone说明 区域  说明  drop*（*丢弃*）*  任何接收的*网络*数据包都被丢弃*，*没有任何回复。仅能有发送出去的*网络*连接。  block*（*限制*）*  任何接收的*网络*连接都被 IPv4 的 icmp-host-prohibited 信息和 IPv6 的 icmp6-adm... 			](https://blog.csdn.net/chuangai7820/article/details/100814244)

### “相关推荐”对你有帮助么？

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel1.png)                                

  非常没帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel2.png)                                

  没帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel3.png)                                

  一般

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel4.png)                                

  有帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel5.png)                                

  非常有帮助

​                ©️2022 CSDN                皮肤主题：鲸                 设计师：meimeiellie                                    [返回首页](https://blog.csdn.net/)                            

- ​              [关于我们](https://www.csdn.net/company/index.html#about)            
- ​              [招贤纳士](https://www.csdn.net/company/index.html#recruit)            
- [商务合作](https://marketing.csdn.net/questions/Q2202181741262323995)
- [寻求报道](https://marketing.csdn.net/questions/Q2202181748074189855)
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/tel.png)              400-660-0108            
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/email.png)              [kefu@csdn.net](mailto:webmaster@csdn.net)            
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/cs.png)              [在线客服](https://csdn.s2.udesk.cn/im_client/?web_plugin_id=29181)            
- ​              工作时间 8:30-22:00            

- [公安备案号11010502030143](http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=11010502030143)
- [京ICP备19004658号](http://beian.miit.gov.cn/publish/query/indexFirst.action)
- [京网文〔2020〕1039-165号](https://csdnimg.cn/release/live_fe/culture_license.png)
- [经营性网站备案信息](https://csdnimg.cn/cdn/content-toolbar/csdn-ICP.png)
- [北京互联网违法和不良信息举报中心](http://www.bjjubao.org/)
- [家长监护](https://download.csdn.net/tutelage/home)
- [网络110报警服务](http://www.cyberpolice.cn/)
- [中国互联网举报中心](http://www.12377.cn/)
- [Chrome商店下载](https://chrome.google.com/webstore/detail/csdn开发者助手/kfkdboecolemdjodhmhmcibjocfopejo?hl=zh-CN)
- ©1999-2022北京创新乐知网络技术有限公司
- [版权与免责声明](https://www.csdn.net/company/index.html#statement)
- [版权申诉](https://blog.csdn.net/blogdevteam/article/details/90369522)
- [出版物许可证](https://img-home.csdnimg.cn/images/20210414021151.jpg)
- [营业执照](https://img-home.csdnimg.cn/images/20210414021142.jpg)

​            [                 ![img](https://profile.csdnimg.cn/E/5/8/3_rzy1248873545)             ](https://renzeyuan.blog.csdn.net)        

​                [                     礁之                 ](https://renzeyuan.blog.csdn.net)                                ![img](https://csdnimg.cn/release/blogv2/dist/mobile/img/vipNew.png)                                                                                                                            

​                码龄2年                                        [                     ![img](https://csdnimg.cn/identity/enstaf.png)                     企业员工                     ](https://i.csdn.net/#/uc/profile?utm_source=14998968)                                







- 9万+

  访问

- [                 ![img](https://csdnimg.cn/identity/blog4.png)             ](https://blog.csdn.net/blogdevteam/article/details/103478461)            

  等级

- 1383

  积分

- 1996

  粉丝

- 374

  获赞

- 302

  评论

- 690

  收藏

​                        ![领英](https://csdnimg.cn/medal/linkedin@240.png)                    

​                        ![GitHub](https://csdnimg.cn/medal/github@240.png)                    

​                        ![脉脉勋章](https://csdnimg.cn/medal/maimai@240.png)                    

​                        ![签到新秀](https://csdnimg.cn/medal/qiandao20@240.png)                    

​                        ![阅读者勋章Lv3](https://csdnimg.cn/medal/yuedu30@240.png)                    

​                        ![新秀勋章](https://csdnimg.cn/medal/xinxiu@240.png)                    

​                        ![持之以恒](https://csdnimg.cn/medal/chizhiyiheng@240.png)                    

​                        ![勤写标兵Lv4](https://csdnimg.cn/medal/qixiebiaobing4@240.png)                    

​                        ![分享小兵](https://csdnimg.cn/medal/fengxiangxiaobing@240.png)                    

​        [私信](https://im.csdn.net/chat/rzy1248873545)        

​             已关注          

​                                             ![img](https://csdnimg.cn/cdn/content-toolbar/csdn-white-search.png?v=1587006908)            

### 热门文章

- ​				[ 				运维必备——ELK日志分析系统 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 					5178                 ](https://renzeyuan.blog.csdn.net/article/details/115316688) 		
- ​				[ 				LAMP平台服务简介、部署及应用 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 					5030                 ](https://renzeyuan.blog.csdn.net/article/details/111171114) 		
- ​				[ 				Web基础 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 					4901                 ](https://renzeyuan.blog.csdn.net/article/details/116000154) 		
- ​				[ 				Apache（httpd）的简介、安装以及如何使用 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 					4760                 ](https://renzeyuan.blog.csdn.net/article/details/110915506) 		
- ​				[ 				HTTP请求方法 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountBlack.png) 					3637                 ](https://renzeyuan.blog.csdn.net/article/details/122131243) 		

### 最新评论

- Python入门——变量与数据类型

  ​                    [我的小fafa_a: ](https://blog.csdn.net/qq_46391668)                    我超，太有用辣开导。![表情包](https://g.csdnimg.cn/static/face/emoji/017.png)                

- Mysql-MHA集群

  ​                    [礁之: ](https://renzeyuan.blog.csdn.net)                    嘿嘿![表情包](https://g.csdnimg.cn/static/face/emoji/005.png)                

- Mysql-MHA集群

  ​                    [愿许浪尽天涯: ](https://blog.csdn.net/weixin_46902396)                    支持博主，写的很棒                

- mysql常用命令、以及小技巧

  ​                    [TimeFriends: ](https://blog.csdn.net/qq_44590469)                    支持支持 支持大佬的好文章,互相关注,相互学习 写的非常详细                

### 您愿意向朋友推荐“博客详情页”吗？

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel1.png)                                    

  强烈不推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel2.png)                                    

  不推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel3.png)                                    

  一般般

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel4.png)                                    

  推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel5.png)                                    

  强烈推荐

### 最新文章

- ​            [Python的高级特性](https://renzeyuan.blog.csdn.net/article/details/124184465)            
- ​            [制作离线yum源](https://renzeyuan.blog.csdn.net/article/details/124173229)            
- ​            [python列表推导式示例](https://renzeyuan.blog.csdn.net/article/details/123979366)            

[2022年22篇](https://renzeyuan.blog.csdn.net?type=blog&year=2022&month=04)

[2021年75篇](https://renzeyuan.blog.csdn.net?type=blog&year=2021&month=12)

### 目录

1. [防火墙策略与规则](https://blog.csdn.net/rzy1248873545/article/details/112168647#t0)
2. [一、linux防火墙简介](https://blog.csdn.net/rzy1248873545/article/details/112168647#t1)
3. 1. [- 防火墙技术种类：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t2)
   2. [- 包过滤防火墙概述：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t3)
   3. [- 包过滤的工作层次：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t4)
4. [二、firewalld简介](https://blog.csdn.net/rzy1248873545/article/details/112168647#t5)
5. 1. [- 概述：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t6)
   2. [- 特点：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t7)
   3. [- 网络区域：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t8)
   4. [- 检查原则：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t9)
   5. [- firewalld数据处理流程：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t10)
   6. [- 数据包处理原则：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t11)
   7. [- firewalld防火墙的配置方法：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t12)
6. [三、配置firewalld防火墙](https://blog.csdn.net/rzy1248873545/article/details/112168647#t13)
7. 1. [（1）使用firewall-config图形化工具配置](https://blog.csdn.net/rzy1248873545/article/details/112168647#t14)
   2. [（2）使用firewall-cmd命令进行配置](https://blog.csdn.net/rzy1248873545/article/details/112168647#t15)
   3. 1. [- 如何清空防火墙规则：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t16)
      2. [- 区域管理选项说明：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t17)
      3. [- 服务管理选项说明：](https://blog.csdn.net/rzy1248873545/article/details/112168647#t18)
      4. [- 两种配置方式](https://blog.csdn.net/rzy1248873545/article/details/112168647#t19)

### 分类专栏

- ![img](https://img-blog.csdnimg.cn/20190927151132530.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            遇到的问题                                        

  7篇

- ![img](https://img-blog.csdnimg.cn/20201014180756923.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            常用命令                                        

  7篇

- ![img](https://img-blog.csdnimg.cn/20201014180756930.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            Python                                        

  4篇

- ![img](https://img-blog.csdnimg.cn/20201014180756913.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            常用软件                                        

  13篇

- ![img](https://img-blog.csdnimg.cn/e867eb43403149c18f901df07043f614.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            msyql                                        

  11篇

- ![img](https://img-blog.csdnimg.cn/98a09ae1cb374ebd9c0b961f6d2a5a83.jpg?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            Centos                                        

  10篇

- ![img](https://img-blog.csdnimg.cn/20201014180756916.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            php                                        

  2篇

- ![img](https://img-blog.csdnimg.cn/20201014180756916.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            shell                                        

  7篇

- ![img](https://img-blog.csdnimg.cn/20201014180756757.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            Prometheus                                        

  2篇

- ![img](https://img-blog.csdnimg.cn/20201014180756913.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            消息队列                                        

  2篇

- ![img](https://img-blog.csdnimg.cn/20201014180756927.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            ansible                                        

  4篇

- ![img](https://img-blog.csdnimg.cn/c18e0c23d1f046768ff1d5228c39412d.jpg?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            Web基础                                        

  22篇

- ![img](https://img-blog.csdnimg.cn/f729582084b248bf89809381a4298799.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            运维必备                                        

  13篇

- ![img](https://img-blog.csdnimg.cn/20201014180756930.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            databases                                        

  1篇

- ![img](https://img-blog.csdnimg.cn/20201014180756738.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            高可用、负载均衡                                        

  2篇

- ![img](https://img-blog.csdnimg.cn/b467192dd14346b9a7b7833e54d550a9.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            docker                                        

  8篇

- ![img](https://img-blog.csdnimg.cn/20201014180756927.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            cicd                                        

  3篇

- ![img](https://img-blog.csdnimg.cn/387de251536b486bb31fff8be6c35a5e.jpg?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            redis                                        

  1篇

- ![img](https://img-blog.csdnimg.cn/20201014180756923.png?x-oss-process=image/resize,m_fixed,h_64,w_64)

  ​                                            kubernetes                                        

  2篇



​              ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/guide.png)                                    ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/kefu.png)                                举报                      ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/fanhuidingbucopy.png)                

在 RHEL7 里有几种防火墙共存：firewalld、iptables、ebtables，默认是使用 firewalld 来管理 netfilter 子系统，不过底层调用的命令仍然是iptables 。

**Firewalld与iptables对比**

**firewalld 是 iptables 的前端控制器
 iptables 静态防火墙 任一策略变更需要reload所有策略，丢失现有链接
 firewalld 动态防火墙 任一策略变更不需要reload所有策略 将变更部分保存到iptables,不丢失现有链接
 firewalld 提供一个daemon和service 底层使用iptables
 基于内核的Netfilter**

**firewalld跟iptables比起来至少有两大好处：**

**1）irewalld可以动态修改单条规则，而不需要像iptables那样，在修改了规则后必须得全部刷新才可以生效；**

**2）firewalld在使用上要比iptables人性化很多，即使不明白“五张表五条链”而且对TCP/IP协议也不理解也可以实现大部分功能。**
 **firewalld跟iptables比起来，不好的地方是每个服务都需要去设置才能放行，因为默认是拒绝。而iptables里默认是每个服务是允许，需要拒绝的才去限制。**
 **firewalld自身并不具备防火墙的功能，而是和iptables一样需要通过内核的netfilter来实现，也就是说firewalld和  iptables一样，他们的作用都是用于维护规则，而真正使用规则干活的是内核的netfilter，只不过firewalld和iptables的结构以及使用方法不一样罢了。**

**一个重要的概念：区域管理**

**通过将网络划分成不同的区域，制定出不同区域之间的访问控制策略来控制不同程序区域间传送的数据流。例如，互联网是不可信任的区域，而内部网络是高度信任的区域。网络安全模型可以在安装，初次启动和首次建立网络连接时选择初始化。该模型描述了主机所连接的整个网络环境的可信级别，并定义了新连接的处理方式。有如下几种不同的初始化区域：**

| 网络区名称           | 默认配置                                                     |
| -------------------- | ------------------------------------------------------------ |
| 阻塞区域（block）    | 任何传入的网络数据包都将被阻止。拒绝所有的网络连接           |
| 工作区域（work）     | 相信网络上的其他计算机，不会损害你的计算机。仅接受ssh、ipp-client或dhcpv6-client服务连接 |
| 家庭区域（home）     | 相信网络上的其他计算机，不会损害你的计算机。用于家庭网络，仅接受ssh、mdns、ipp-client或dhcpv6-client服务连接 |
| 公共区域（public）   | 在公共区域内使用。仅接受ssh或dhcpv6-client服务连接           |
| 隔离区域（DMZ）      | 隔离区域也称为非军事区域，内外网络之间增加的一层网络，起到缓冲作用。对于隔离区域，只有选择接受传入的网络连接。仅接受ssh服务连接 |
| 信任区域（trusted）  | 所有的网络连接都可以接受。                                   |
| 丢弃区域（drop）     | 任何传入的网络连接都被拒绝。接受的数据包都被抛弃，且没有任何回复 |
| 内部区域（internal） | 信任网络上的其他计算机，不会损害你的计算机。只有选择接受传入的网络连接。仅接受ssh、mdns、ipp-client或dhcpv6-client服务连接 |
| 外部区域（external） | 不相信网络上的其他计算机，不会损害你的计算机。只有选择接受传入的网络连接。仅接受ssh服务连接 |

**注：FirewallD的默认区域是public。**

**firewalld默认提供了九个zone配置文件：block.xml、dmz.xml、drop.xml、external.xml、 home.xml、internal.xml、public.xml、trusted.xml、work.xml，他们都保存在“/usr/lib  /firewalld/zones/”目录下。**

## 2.Firewalld策略管理

**1）安装软件**

**2）基本命令**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311104651606.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**操作演示**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311105824314.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311110030110.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**3）火墙策略修改——图形化界面方式**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311111233521.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311111807766.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311111920847.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**4）火墙策略修改——修改火墙配置文件**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311112158778.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**演示：我把允许的服务删掉一些，只剩下ssh和3260端口，然后重启火墙，查看策略**
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311112229586.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311112323324.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

## 3.火墙中端口的相关设置

**1）基本命令**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311112716382.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**2）下面我们利用上面命令完成下面两个实验**

**实验一：通过火墙接口的设置，来实现ssh的访问控制**

**<1>在火墙策略中去掉ssh服务**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311120320246.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)
 **连接失败**
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311120353724.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**<2>添加火墙策略**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311121006685.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)
 **连接成功！**

**实验二：利用火墙策略实现路由功能**

**<1>准备一台双网卡主机，并配置IP分别为172.25.6.106、1.1.1.106；一台单网卡主机，IP为1.1.1.206**

**双网卡主机配置**
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311122120996.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)
 开启火墙地址伪装功能
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019031112521242.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**单网卡主机配置**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311124443786.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**2）单网卡主机通过双网卡主机的路由功能，连接172.25.6.250（通过上面的配置可以实现）**

![在这里插入图片描述](https://img-blog.csdnimg.cn/2019031112562866.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)
 **那么问题来了：我明明使用1.1.1.206主机连接172.25.6.250，由于路由端开启了火墙地址伪装功能，在172.25.6.250端查询是路由端连接的；所以我怎么做才能知道访问者的IP呢？**

**解决方案：路由端转接**

**服务端：添加火墙的转接策略**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311135035403.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

**测试：**

**我们在172.25.6.250上连接刚刚查询到的IP：172.25.6.106——查询IP后发现，IP为刚刚真正连接的主机IP**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190311135351931.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21lbHRzbm93,size_16,color_FFFFFF,t_70)

[![img](https://profile.csdnimg.cn/C/A/2/3_meltsnow)@Limerence](https://blog.csdn.net/meltsnow)

​                    [关注](javascript:;)                            

- ​                                                            ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newHeart2021White.png)                                          4                                                    
- ​                                            ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newUnHeart2021White.png)                                                    
- ​            [                 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newComment2021White.png)                                      1                              ](https://blog.csdn.net/meltsnow/article/details/88392497#commentBox)                        
- ​            [                                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newCollectWhite.png)                                                       14                              ](javascript:;)                        
- ​                [                 ![打赏](https://csdnimg.cn/release/blogv2/dist/pc/img/newRewardWhite.png)                                  ](javascript:;)                            
- ​            
- ​                [                     ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/newShareWhite.png)                 ](javascript:;)                            

​                    专栏目录                

[ 					Centos7的*Firewalld*防火墙基础命令*详解* 				](https://download.csdn.net/download/weixin_38609693/14094030)

​					01-10 			

[ 				一、Linux防火墙的基础  Linux的防火墙体系主要工作在网络层，针对TCP/IP数据包实时过滤和限制，属于典型的包过滤防火墙（或称为网络层防火墙）。Linux系统的防火墙体系基于内核共存：*firewalld*、iptables、ebtables，默认使用*firewalld*来管理netfilter子系统。   netfilter：指的是Linux内核中实现包过滤防火墙的内部结构，不以程序或文件的形式存在，属于“内核态”的防火墙功能体系；   *firewalld*：指用来管理Linux防护墙的命令程序，属于“用户态”的防火墙管理体系； 1、*firewalld*概述  *firewalld*的作用是为包 			](https://download.csdn.net/download/weixin_38609693/14094030)

[ 					Firewald 防火墙使用手册 				](https://blog.csdn.net/qq_40907977/article/details/104229674)

​					[qq_40907977的博客](https://blog.csdn.net/qq_40907977) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				135 				 			

[ 				1、添加黑名单 firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address="192.168.0.23" drop'   然后reload一下firewall  firewall-cmd --reload   2、添加 端口白名单 查看下防火墙的状态：systemctl status *firewalld* 需要开... 			](https://blog.csdn.net/qq_40907977/article/details/104229674)



​			评论 1 		您还未登录，请先 		登录 		后发表或查看评论 

[					                *Firewalld*防火墙_从不吃素陈长老的博客				                  ](https://blog.csdn.net/weixin_50344760/article/details/110081962)

​                        3-29                      

[                      一、*Firewalld*概述 *Firewalld*简介 1.支持网络区域所定义的网络链接以及接口安全等级的动态防火墙管理工具 2.支持IPv4,IPv6防火墙设置以及以太网桥 3.支持服务或应用程序直接添加防火墙规则接口                     ](https://blog.csdn.net/weixin_50344760/article/details/110081962)

[					                linux两堵墙之一:*firewalld*_风雨兼程,披星戴月。的博客...				                  ](https://blog.csdn.net/qq_42534026/article/details/105074400)

​                        4-2                      

[                      *firewalld* 是一款动态防火墙管理器。 *firewalld* 通过“网络/防火墙”空间的方式,为不同的 网络连接 或 接口 定义其自身的信任等级,通过这种方式达到了动态管理的效果。同时,它支持 IPv4、IPv6 防火墙的设置 、以太网网桥以及 配置选项...                    ](https://blog.csdn.net/qq_42534026/article/details/105074400)

[ 					centos7 *firewalld**详解*，添加删除策略.docx 				](https://download.csdn.net/download/wang1553523054/13761535)

​					12-23 			

[ 				centos7 *firewalld**详解*，超级详细 			](https://download.csdn.net/download/wang1553523054/13761535)

[ 					LInux防火墙*Firewalld*基础详细解读 				](https://blog.csdn.net/weixin_45551608/article/details/117301503)

​					[码海小虾米_的博客](https://blog.csdn.net/weixin_45551608) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				146 				 			

[ 				*Firewalld*一、*Firewalld*概述二、*Firewalld*和iptables的关系2.1 *Firewalld*和iptables分析2.1 *Firewalld*和iptables区别三、*Firewalld*网络区域3.1 *firewalld* 区域的概念3.2	*firewalld*防火墙预定义了9个区域3.2	*firewalld*数据处理流程四、*Firewalld*防火墙的配置方法4.1 *Firewalld*配置方案4.2 *Firewalld*配置方法五、使用firewall-cmd 命令行工具5.1 常用的fir. 			](https://blog.csdn.net/weixin_45551608/article/details/117301503)

[					                Linux下防火墙管理之*firewalld*_Li_barroco的博客				                  ](https://blog.csdn.net/weixin_45792518/article/details/105065056)

​                        3-13                      

[                      1.*firewalld*的开启 systemctl stop iptables systemctl disable iptables systemctl mask iptables systemctl unmask *firewalld* systemctl enable --now *firewalld* 2.关于*firewalld*的域 trusted ##接受所有的网络连接 home ##用于家庭网...                    ](https://blog.csdn.net/weixin_45792518/article/details/105065056)

[					                *Firewalld*防火墙基础_xwy9526的博客				                  ](https://blog.csdn.net/xwy9526/article/details/112284374)

​                        2-21                      

[                      什么是DMZ区域,DMZ区域的作用与原理一. 概念: DMZ是为了解决安装防火墙后外部网络的访问用户不能访问内部网络服务器的问题,而设立的一个非安全系统与安全系统之间的缓冲区。该缓冲区位于企业内部网络和外部网络之间的小网络区域内。在这个...                    ](https://blog.csdn.net/xwy9526/article/details/112284374)

[ 					防火墙（*firewalld*与iptables） 					热门推荐 				](https://blog.csdn.net/weixin_40658000/article/details/78708375)

​					[一涵的博客](https://blog.csdn.net/weixin_40658000) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				5万+ 				 			

[ 				防火墙是整个数据包进入主机前的第一道关卡。防火墙主要通过Netfilter与TCPwrappers两个机制来管理的。  1）Netfilter：数据包过滤机制  2）TCP Wrappers：程序管理机制  关于数据包过滤机制有两个软件：*firewalld*与iptables  关于两者的不同介绍如下：  1    2 iptables通过控制端口来控制服务，而*firewalld*则是通过控制协议来控制 			](https://blog.csdn.net/weixin_40658000/article/details/78708375)

[ 					什么是*firewalld*，简介、策略及规则（Centos7防火墙） 					最新发布 				](https://renzeyuan.blog.csdn.net/article/details/112168647)

​					[礁之的博客](https://blog.csdn.net/rzy1248873545) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				1408 				 			

[ 				防火墙策略与规则一、linux防火墙简介- 防火墙技术种类：- 包过滤防火墙概述：- 包过滤的工作层次：二、*firewalld*简介- 概述：- 特点：- 工作原理（数据处理流程）：- 网络区域： 一、linux防火墙简介 - 防火墙技术种类： （1）包过滤防火墙 packet filtering （2）应用代理防火墙 application proxy （3）状态检测防火墙  stateful inspection （*firewalld*是包过滤防火墙，所以这里只讲包过滤防火墙） - 包过滤防火墙概述： （1 			](https://renzeyuan.blog.csdn.net/article/details/112168647)

[ 					Linux *Firewalld*用法及案例 				](https://blog.csdn.net/xiazichenxi/article/details/80169927)

​					[陈洋的博客](https://blog.csdn.net/xiazichenxi) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				1万+ 				 			

[ 				官方文档   RHEL *FIREWALLD*     *Firewalld*概述   动态防火墙管理工具 定义区域与接口安全等级 运行时和永久配置项分离 两层结构  核心层 处理配置和后端，如iptables、ip6tables、ebtables、ipset和模块加载器 顶层D-Bus 更改和创建防火墙配置的主要方式。所有*firewalld*都使用该接口提供在线工具     原理图        Fire... 			](https://blog.csdn.net/xiazichenxi/article/details/80169927)

[ 					*firewalld* 操作指南 				](https://blog.csdn.net/weixin_43273168/article/details/85109597)

​					[weixin_43273168的博客](https://blog.csdn.net/weixin_43273168) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				1625 				 			

[ 				*Firewalld*简介：   *firewalld*是centos7的一大特性，*firewalld*同时拥有命令行终端和图形化界面的配置工具，相比于iptables对火墙的管理更加容易上手但没有iptables控制精准，最大的好处有两个：支持动态更新，不用重启服务；第二个就是加入了防火墙的zone概念,以分配对一个网络及其相关链接和界面一定程度的信任。支持以太网桥并有分离运行时间及永久配置选择，并且还具... 			](https://blog.csdn.net/weixin_43273168/article/details/85109597)

[ 					CentOS7使用*firewalld*打开关闭防火墙与端口 				](https://gblfy.blog.csdn.net/article/details/91411010)

​					[Gblfy_Blog](https://blog.csdn.net/weixin_40816738) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				135 				 			

[ 				1、*firewalld*的基本使用 启动： systemctl start *firewalld* 关闭： systemctl stop *firewalld* 查看状态： systemctl status *firewalld* 开机禁用  ： systemctl disable *firewalld* 开机启用  ： systemctl enable *firewalld* 2.systemctl是CentOS7的... 			](https://gblfy.blog.csdn.net/article/details/91411010)

[ 					Linux *firewalld* 防火墙使用 				](https://wangmaoxiong.blog.csdn.net/article/details/80738012)

​					[蚩尤后裔](https://blog.csdn.net/wangmx1993328) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				2万+ 				 			

[ 				目录  firewall 防火墙服务简述与安装  *firewalld* 服务基本使用  *firewalld*-cmd 防护墙命令使用  public.xml 文件修改防火墙端口  注意事项  firewall 防火墙服务简述与安装  1、Centos7 默认的防火墙是 firewall，替代了以前的 iptables  2、firewall 使用更加方便、功能也更加强大一些  3、*firewalld* ... 			](https://wangmaoxiong.blog.csdn.net/article/details/80738012)

[ 					*FirewallD**详解*（转载） 				](https://blog.csdn.net/u010478095/article/details/50608767)

​					[菲比他爹的专栏](https://blog.csdn.net/u010478095) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				1345 				 			

[ 				在CentOS7开始,默认是没有iptables的,而是使用了firewall防火墙. 与时俱进,简单的整理了一下firewall的使用方法. 关于详细的介绍参考官网,就不搬字了.这个网站有中文选项.可以直接看中文.关于CentOS7 非常多是资料这里面都能找到. 官方文档地址：  https://access.redhat.com/documentation/en-US/Red_Hat 			](https://blog.csdn.net/u010478095/article/details/50608767)

[ 					*firewalld*防火墙规则 				](https://yankerp.blog.csdn.net/article/details/77387650)

​					[延瓒](https://blog.csdn.net/qq_39591494) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				1万+ 				 			

[ 				在Redhat Enterprise Linux7中已经默认使用*firewalld*作为防火墙，其使用方式已经变化。基于iptables的防火墙被默认不启动，但仍然可以继续使用.RHRE7中有几种防火墙共存：*firewalld*，iptables，ebtables等，默认使用*firewalld*作为防火墙，管理工具是firewall-cmd.RHEL7的内核版本是3.10，在此版本的内核里防火墙的包过滤... 			](https://yankerp.blog.csdn.net/article/details/77387650)

[ 					*firewalld*拓展、chkconfig说明 				](https://blog.csdn.net/chuangai7820/article/details/100814244)

​					[chuangai7820的博客](https://blog.csdn.net/chuangai7820) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				55 				 			

[ 				*firewalld*默认的9个zone说明 区域  说明  drop（丢弃）  任何接收的网络数据包都被丢弃，没有任何回复。仅能有发送出去的网络连接。  block（限制）  任何接收的网络连接都被 IPv4 的 icmp-host-prohibited 信息和 IPv6 的 icmp6-adm... 			](https://blog.csdn.net/chuangai7820/article/details/100814244)

[ 					*firewalld* 				](https://blog.csdn.net/weixin_55614692/article/details/118527315)

​					[weixin_55614692的博客](https://blog.csdn.net/weixin_55614692) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				51 				 			

[ 				*Firewalld*  一、*Firewalld*概述二、*Firewalld*和iptables的关系2.1 *Firewalld*和iptables分析2.1 *Firewalld*和iptables区别   三、*Firewalld*网络区域3.1 *firewalld* 区域的概念3.2 *firewalld*防火墙预定义了9个区域3.2 *firewalld*数据处理流程   四、*Firewalld*防火墙的配置方法4.1 *Firewalld*配置方案4.2 *Firewalld*配置方法   五、使用firewall-cmd 命令行.. 			](https://blog.csdn.net/weixin_55614692/article/details/118527315)

[ 					*Firewalld*防火墙基础——centos7开始存在的防火墙 				](https://blog.csdn.net/m0_47452405/article/details/109463042)

​					[m0_47452405的博客](https://blog.csdn.net/m0_47452405) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				56 				 			

[ 				*Firewalld*防火墙基础一、概述二、*Firewalld*和iptables的关系三、*Firewalld*网络区域四、*Firewalld*防火墙的配置方法五、Firewall-config图形工具六、*Firewalld*防火墙案例实验 一、概述 ■*Firewalld*  支持网络区域所定义的网络链接以及接安全等级的动态防火墙管理工具 支持IPv4、IPv6防火 墙设置以及以太网桥 拥有两种配置模式 ◆运行时配置 ◆永久配置  二、*Firewalld*和iptables的关系 ■netfilter  位于Linux内核 			](https://blog.csdn.net/m0_47452405/article/details/109463042)

[ 					Linux下防火墙服务：*firewalld*服务以及iptables服务的部署与相关命令 				](https://blog.csdn.net/Leslie_qlh/article/details/99711283)

​					[Leslie_qlh的博客](https://blog.csdn.net/Leslie_qlh) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				351 				 			

[ 				防火墙服务 文章目录防火墙服务1.配置2.*Firewalld*的域3.*Firewalld*设置4.*Firewalld*中网卡与ip设置（1）网卡设置：测试：（2）ip设置测试：4.火墙添加服务：5.火墙中的端口修改（1）临时修改（2）永久修改命令修改：文件修改：5.火墙的刷新测试：6、火墙的三表五链（1）filter表（2）nat表（3）mangle表7、地址伪装和端口转发8.iptables火墙服务（... 			](https://blog.csdn.net/Leslie_qlh/article/details/99711283)

[ 					*Firewalld*概述 				](https://blog.csdn.net/m0_55614372/article/details/118728606)

​					[m0_55614372的博客](https://blog.csdn.net/m0_55614372) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				78 				 			

[ 				一、*Firewalld*概述  1.*firewalld*防火墙是Centos7系统默认的防火墙管理工具，取代了之前的iptables防火墙，也是工作在网络层，属于包过滤防火墙  2.*firewalld*提供了支持网络区域所定义的网络连接以及接口安全等级的动态防火墙管理工具。  二、*firewalld*与iptables 的区别  1.ipta... 			](https://blog.csdn.net/m0_55614372/article/details/118728606)

[ 					【RHEL7/CentOS7防火墙之firewall-cmd命令*详解*】 				](https://blog.csdn.net/weixin_30408165/article/details/97675859)

​					[weixin_30408165的博客](https://blog.csdn.net/weixin_30408165) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				5005 				 			

[ 				目录                       *Firewalld* zone         firewall-cmd         开始配置防火墙策略         总结                Redhat Enterprise Linux7已默认使用*firewalld*防火墙，其管理工具是firewall-cmd。使用方式也发生了很大的改变。 基于iptables的防火墙... 			](https://blog.csdn.net/weixin_30408165/article/details/97675859)

[ 					*firewalld*防火墙 				](https://blog.csdn.net/weixin_45950635/article/details/109628286)

​					[weixin_45950635的博客](https://blog.csdn.net/weixin_45950635) 			

​					 				![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 				239 				 			

[ 				firewall 防火墙 技能展示 理解frewalda方火墙基本原理 使用firewall-confg配置防火墙 使用firewall-cmd配置防火墙 简介  在hternet 中,企业通过架设各种应用系统来为用户提供各种网络服务,如Web网站,电子邮件系统, FTP服务器,数据库系统等。那么,如何来保护这些服务器,过滤企业非授权的访问,甚至是·恶意的入侵呢? 本章将开始学习Linux系统中的防火墙-netiter frewalld ,括防火墙的结构与匹配流程以及如何编写防火墙规则  重点 熟悉frew 			](https://blog.csdn.net/weixin_45950635/article/details/109628286)

### “相关推荐”对你有帮助么？

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel1.png)                                

  非常没帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel2.png)                                

  没帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel3.png)                                

  一般

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel4.png)                                

  有帮助

- ​                  ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel5.png)                                

  非常有帮助

​                ©️2022 CSDN                皮肤主题：技术工厂                 设计师：CSDN官方博客                                    [返回首页](https://blog.csdn.net/)                            

- ​              [关于我们](https://www.csdn.net/company/index.html#about)            
- ​              [招贤纳士](https://www.csdn.net/company/index.html#recruit)            
- [商务合作](https://marketing.csdn.net/questions/Q2202181741262323995)
- [寻求报道](https://marketing.csdn.net/questions/Q2202181748074189855)
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/tel.png)              400-660-0108            
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/email.png)              [kefu@csdn.net](mailto:webmaster@csdn.net)            
- ​              ![img](https://g.csdnimg.cn/common/csdn-footer/images/cs.png)              [在线客服](https://csdn.s2.udesk.cn/im_client/?web_plugin_id=29181)            
- ​              工作时间 8:30-22:00            

- [公安备案号11010502030143](http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=11010502030143)
- [京ICP备19004658号](http://beian.miit.gov.cn/publish/query/indexFirst.action)
- [京网文〔2020〕1039-165号](https://csdnimg.cn/release/live_fe/culture_license.png)
- [经营性网站备案信息](https://csdnimg.cn/cdn/content-toolbar/csdn-ICP.png)
- [北京互联网违法和不良信息举报中心](http://www.bjjubao.org/)
- [家长监护](https://download.csdn.net/tutelage/home)
- [网络110报警服务](http://www.cyberpolice.cn/)
- [中国互联网举报中心](http://www.12377.cn/)
- [Chrome商店下载](https://chrome.google.com/webstore/detail/csdn开发者助手/kfkdboecolemdjodhmhmcibjocfopejo?hl=zh-CN)
- ©1999-2022北京创新乐知网络技术有限公司
- [版权与免责声明](https://www.csdn.net/company/index.html#statement)
- [版权申诉](https://blog.csdn.net/blogdevteam/article/details/90369522)
- [出版物许可证](https://img-home.csdnimg.cn/images/20210414021151.jpg)
- [营业执照](https://img-home.csdnimg.cn/images/20210414021142.jpg)

​            [                 ![img](https://profile.csdnimg.cn/C/A/2/3_meltsnow)             ](https://blog.csdn.net/meltsnow)        

​                [                     @Limerence                 ](https://blog.csdn.net/meltsnow)                                                                                                                                            

​                码龄4年                                        [                     ![img](https://csdnimg.cn/identity/nocErtification.png)                     暂无认证                     ](https://i.csdn.net/#/uc/profile?utm_source=14998968)                                







- 27万+

  访问

- [                 ![img](https://csdnimg.cn/identity/blog5.png)             ](https://blog.csdn.net/blogdevteam/article/details/103478461)            

  等级

- 3953

  积分

- 291

  粉丝

- 396

  获赞

- 74

  评论

- 1305

  收藏

​                        ![签到新秀](https://csdnimg.cn/medal/qiandao3@240.png)                    

​                        ![阅读者勋章Lv2](https://csdnimg.cn/medal/yuedu7@240.png)                    

​                        ![持之以恒](https://csdnimg.cn/medal/chizhiyiheng@240.png)                    

​                        ![勤写标兵Lv2](https://csdnimg.cn/medal/qixiebiaobing2@240.png)                    

​        [私信](https://im.csdn.net/chat/meltsnow)        

​             关注          

​                                             ![img](https://csdnimg.cn/cdn/content-toolbar/csdn-sou.png?v=1587021042)            

### 热门文章

- ​				[ 				Docker网络详解——原理篇 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 					33045                 ](https://blog.csdn.net/meltsnow/article/details/94490994) 		
- ​				[ 				Git本地仓库的搭建及使用 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 					24415                 ](https://blog.csdn.net/meltsnow/article/details/95949485) 		
- ​				[ 				如何在Linux中运用vim命令轻松编辑文件 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 					17257                 ](https://blog.csdn.net/meltsnow/article/details/86233493) 		
- ​				[ 				Linux运维工程师应具备哪些技能？ 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 					13705                 ](https://blog.csdn.net/meltsnow/article/details/87868368) 		
- ​				[ 				Docker网络——实现容器间通信、容器与外网通信以及容器的跨主机访问 					![img](https://csdnimg.cn/release/blogv2/dist/pc/img/readCountWhite.png) 					12797                 ](https://blog.csdn.net/meltsnow/article/details/94548066) 		

### 最新评论

- Python面对对象编程——对象、类详解及实例

  ​                    [Asiifalaloo: ](https://blog.csdn.net/weixin_54620825)                    讲得好                

- Git本地仓库的搭建及使用

  ​                    [Gaysee: ](https://blog.csdn.net/Gaysee)                    写的好，下次在写点                

- Docker网络详解——原理篇

  ​                    [不渝矢志: ](https://blog.csdn.net/starmy1987)                    写得好，受益匪浅                

- Docker网络详解——原理篇

  ​                    [qiqishuang: ](https://blog.csdn.net/qiqishuang)                    图有很多问题，没有分清楚网桥、端口、接口。                

- Docker网络详解——原理篇

  ​                    [leonken88: ](https://blog.csdn.net/leonken88)                    我也看不太懂，因为平时对网络知识比较少                

### 您愿意向朋友推荐“博客详情页”吗？

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel1.png)                                    

  强烈不推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel2.png)                                    

  不推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel3.png)                                    

  一般般

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel4.png)                                    

  推荐

- ​                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/npsFeel5.png)                                    

  强烈推荐

### 最新文章

- ​            [几种常见的攻击方式扫盲(二)——DNS 反射放大攻击](https://blog.csdn.net/meltsnow/article/details/103402023)            
- ​            [几种常见的攻击方式扫盲(一)——NTP反射放大](https://blog.csdn.net/meltsnow/article/details/103400399)            
- ​            [SalttSack自动化运维（四）——JINJA模块](https://blog.csdn.net/meltsnow/article/details/96505257)            

[2019年131篇](https://blog.csdn.net/meltsnow?type=blog&year=2019&month=12)

[2018年2篇](https://blog.csdn.net/meltsnow?type=blog&year=2018&month=12)

### 目录

1. [1.简介](https://blog.csdn.net/meltsnow/article/details/88392497#t0)
2. [2.Firewalld策略管理](https://blog.csdn.net/meltsnow/article/details/88392497#t1)
3. [3.火墙中端口的相关设置](https://blog.csdn.net/meltsnow/article/details/88392497#t2)

![img](https://kunyu.csdn.net/1.png?p=479&adId=3267&a=3267&c=0&k=Firewalld详解&spm=1001.2101.3001.4834&articleId=88392497&d=1&t=3&u=a6c84a96a1b641fe9ba436e3805f40ef)

### 分类专栏

- ![img](https://img-blog.csdnimg.cn/20190310205242136.jpeg?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            LINUX                                        

- ![img](https://img-blog.csdnimg.cn/20201014180756916.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            Linux基础                                        

  41篇

- ![img](https://img-blog.csdnimg.cn/20201014180756913.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            Python                                        

  22篇

- ![img](https://img-blog.csdnimg.cn/20201014180756738.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            运维企业部分                                        

  37篇

- ![img](https://img-blog.csdnimg.cn/20201014180756922.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            复习整理                                        

  3篇

- ![img](https://img-blog.csdnimg.cn/20201014180756724.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            闲谈                                        

  3篇

- ![img](https://img-blog.csdnimg.cn/20201014180756916.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            Docker                                        

  19篇

- ![img](https://img-blog.csdnimg.cn/20201014180756925.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            ansible                                        

  2篇

- ![img](https://img-blog.csdnimg.cn/20201014180756918.png?x-oss-process=image/resize,m_fixed,h_64,w_64)                                            SaltStack                                        

  4篇



​              ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/guide.png)                                    ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/kefu.png)                                举报                      ![img](https://g.csdnimg.cn/side-toolbar/3.1/images/fanhuidingbucopy.png)                

![img](moz-extension://e2e4c729-fe25-403a-a8cb-e6b819e0ad9b/assets/img/T.cb83a013.svg)

​          [![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleSearchWhite.png)](https://so.csdn.net/so/search?from=pc_blog_select&q=d 提供一个daemon和service 底层使用iptables)          [![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleComment1White.png)](javascript:;)          

FirewallD 是 iptables 的前端控制器，用于实现持久的网络流量规则。

提供命令行和图形界面，在大多数 Linux 发行版的仓库中都有。

与直接控制 iptables 相比，使用 FirewallD 有两个主要区别：

1. FirewallD 使用区域和服务而不是链式规则。
2. 动态管理规则集，允许更新规则而不破坏现有会话和连接。

## 安装

[CentOS](https://www.linuxprobe.com/) 7 和 Fedora 20+ 已经包含了 FirewallD，但是默认没有激活。

**1、 启动服务，并在系统引导时启动该服务：**

```bash
systemctl start firewalld
systemctl enable firewalld
```

要停止并禁用：

```bash
systemctl stop firewalld
systemctl disable firewalld
```

**2、 检查防火墙状态。输出应该是 running或者 not running。**

```bash
firewall-cmd --state
```

**3、 要查看 FirewallD 守护进程的状态：**

```bash
systemctl status firewall
```

**4、 重新加载 FirewallD 配置：**

```bash
firewall-cmd --reload
```

## 配置

FirewallD 使用 XML 进行配置。建议使用 firewall-cmd。

**配置文件**

* /usr/lib/FirewallD

  保存默认配置，如默认区域和公用服务。避免修改它们，因为每次 firewall 软件包更新时都会覆盖这些文件。

* /etc/firewalld

  保存系统配置文件。 这些文件将覆盖默认配置。 

**配置集**

FirewallD 使用两个配置集：“运行时”和“持久”。 在系统重新启动或重新启动 FirewallD 时，不会保留运行时的配置更改，而对持久配置集的更改不会应用于正在运行的系统。

默认情况下，firewall-cmd 命令适用于运行时配置，但使用 --permanent 标志将保存到持久配置中。要添加和激活持久性规则，你可以使用两种方法之一。

**1、 将规则同时添加到持久规则集和运行时规则集中。**

```
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=http
```

**2、 将规则添加到持久规则集中并重新加载 FirewallD。** 

```
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
```

reload 命令会删除所有运行时配置并应用永久配置。firewalld 动态管理规则集，所以它不会破坏现有的连接和会话。

**防火墙的区域**

“区域”是针对给定位置或场景（例如家庭、公共、受信任等）可能具有的各种信任级别的预构建规则集。不同的区域允许不同的网络服务和入站流量类型，而拒绝其他任何流量。 首次启用 FirewallD 后，public 将是默认区域。

区域也可以用于不同的网络接口。例如，要分离内部网络和互联网的接口，你可以在 internal 区域上允许 DHCP，但在 external区域仅允许 HTTP 和 SSH。未明确设置为特定区域的任何接口将添加到默认区域。

要找到默认区域： 

```
sudo firewall-cmd --get-default-zone
```

要修改默认区域：

```
sudo firewall-cmd --set-default-zone=internal
```

要查看你网络接口使用的区域：

```
sudo firewall-cmd --get-active-zones
```

示例输出：

```
public
  interfaces: eth0
```

要得到特定区域的所有配置：

```
sudo firewall-cmd --zone=public --list-all
```

示例输出：

```
public (default, active)
  interfaces: ens160
  sources:
  services: dhcpv6-client http ssh
  ports: 12345/tcp
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
```

要得到所有区域的配置： 

```
sudo firewall-cmd --list-all-zones
```

示例输出：

```
block
  interfaces:
  sources:
  services:
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
  ...
work
  interfaces:
  sources:
  services: dhcpv6-client ipp-client ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
```

**与服务一起使用**

FirewallD 可以根据特定网络服务的预定义规则来允许相关流量。你可以创建自己的自定义系统规则，并将它们添加到任何区域。 默认支持的服务的配置文件位于 /usr/lib /firewalld/services，用户创建的服务文件在 /etc/firewalld/services 中。

要查看默认的可用服务：

```
sudo firewall-cmd --get-services
```

比如，要启用或禁用 HTTP 服务： 

```
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --remove-service=http --permanent
```

**允许或者拒绝任意端口/协议** 

比如：允许或者禁用 12345 端口的 TCP 流量。

```
sudo firewall-cmd --zone=public --add-port=12345/tcp --permanent
sudo firewall-cmd --zone=public --remove-port=12345/tcp --permanent
```

**端口转发**

下面是在同一台服务器上将 80 端口的流量转发到 12345 端口。

```
sudo firewall-cmd --zone="public" --add-forward-port=port=80:proto=tcp:toport=12345
```

要将端口转发到另外一台服务器上：

**1、 在需要的区域中激活 masquerade。**

```
sudo firewall-cmd --zone=public --add-masquerade
```

**2、 添加转发规则。例子中是将 IP 地址为 ：123.456.78.9 的远程服务器上 80 端口的流量转发到 8080 上。**

```
sudo firewall-cmd --zone="public" --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=123.456.78.9
```

要删除规则，用 --remove替换 --add。比如：

```
sudo firewall-cmd --zone=public --remove-masquerade
```

**用 FirewallD 构建规则集**

例如，以下是如何使用 FirewallD 为你的服务器配置基本规则（如果您正在运行 web 服务器）。

**1、将 eth0的默认区域设置为 dmz。 在所提供的默认区域中，dmz（非军事区）是最适合于这个程序的，因为它只允许 SSH 和 ICMP。**

```
sudo firewall-cmd --set-default-zone=dmz
sudo firewall-cmd --zone=dmz --add-interface=eth0
```

**2、把 HTTP 和 HTTPS 添加永久的服务规则到 dmz 区域中：**

```
sudo firewall-cmd --zone=dmz --add-service=http --permanent
sudo firewall-cmd --zone=dmz --add-service=https --permanent
```

**3、 重新加载 FirewallD 让规则立即生效：**

```
sudo firewall-cmd --reload
```

如果你运行 firewall-cmd --zone=dmz --list-all， 会有下面的输出：

```
dmz (default)
  interfaces: eth0
  sources:
  services: http https ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
```

这告诉我们， dmz区域是我们的默认区域，它被用于 eth0  接口中所有网络的源地址和端口。 允许传入 HTTP（端口 80）、HTTPS（端口 443）和 SSH（端口 22）的流量，并且由于没有 IP  版本控制的限制，这些适用于 IPv4 和 IPv6。 不允许IP 伪装以及端口转发。 我们没有 ICMP 块，所以 ICMP  流量是完全允许的。没有丰富Rich规则，允许所有出站流量。

**高级配置**

服务和端口适用于基本配置，但对于高级情景可能会限制较多。 丰富Rich规则和直接Direct接口允许你为任何端口、协议、地址和操作向任何区域 添加完全自定义的防火墙规则。

**丰富规则**

丰富规则的语法有很多，但都完整地记录在 firewalld.richlanguage(5) 的手册页中（或在终端中 man firewalld.richlanguage。)使用 --add-rich-rule、 --list-rich-rules、 --remove-rich-rule。 和 firewall-cmd命令来管理它们。

这里有一些常见的例子：

允许来自主机 192.168.0.14 的所有 IPv4 流量。

```
sudo firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address=192.168.0.14 accept'
```

拒绝来自主机 192.168.1.10 到 22 端口的 IPv4 的 TCP 流量。

```
sudo firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.10" port port=22 protocol=tcp reject'
```

允许来自主机 10.1.0.3 到 80 端口的 IPv4 的 TCP 流量，并将流量转发到 6532 端口上。 

```
sudo firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 source address=10.1.0.3 forward-port port=80 protocol=tcp to-port=6532'
```

将主机 172.31.4.2 上 80 端口的 IPv4 流量转发到 8080 端口（需要在区域上激活 masquerade）。

```
sudo firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 forward-port port=80 protocol=tcp to-port=8080 to-addr=172.31.4.2'
```

列出你目前的丰富规则：

```
sudo firewall-cmd --list-rich-rules
```

**iptables 的直接接口**

对于最高级的使用，或对于 iptables 专家，FirewallD 提供了一个直接Direct接口，允许你给它传递原始 iptables 命令。 直接接口规则不是持久的，除非使用 --permanent。

要查看添加到 FirewallD 的所有自定义链或规则：

```
firewall-cmd --direct --get-all-chains
firewall-cmd --direct --get-all-rules
```

讨论 iptables 的具体语法已经超出了这篇文章的范围。如果你想学习更多，你可以查看我们的 iptables 指南。

## 定义
**区域**  
网络区域定义了网络连接的可信等级。这是一个一对多的关系，这意味着一次连接可以仅仅是一个区域的一部分，而一个区域可以用于很多连接。  

**预定义的服务**  
服务是端口和/或协议入口的组合。备选内容包括 netfilter 助手模块以及 IPv4、IPv6地址。  

**端口和协议**  
定义了 tcp 或 udp 端口，端口可以是一个端口或者端口范围。  

**ICMP 阻塞**  
可以选择 Internet 控制报文协议的报文。这些报文可以是信息请求亦可是对信息请求或错误条件创建的响应。  

**伪装**  
私有网络地址可以被映射到公开的IP地址。这是一次正规的地址转换。  

**端口转发**  
端口可以映射到另一个端口以及/或者其他主机。
## 区域
由firewalld 提供的区域按照从不信任到信任的顺序排序：  

**丢弃（drop）**  
任何流入网络的包都被丢弃，不作出任何响应。只允许流出的网络连接。  

**阻塞（block）**  
任何进入的网络连接都被拒绝，并返回 IPv4 的 icmp-host-prohibited 报文或者 IPv6 的 icmp6-adm-prohibited 报文。只允许由该系统初始化的网络连接。  

**公开（public）**  
用以可以公开的部分。该网络中其他的计算机对你来说不可信并且可能伤害你的计算机。只允许选中的连接接入。  

**外部（external）**
用在路由器等启用伪装的外部网络。该网络中其他的计算机对你来说不可信并且可能伤害你的计算机。只允许选中的连接接入。  

**隔离区（dmz）**  
用以允许隔离区（dmz）中的电脑有限地被外界网络访问。只接受被选中的连接。  

**工作（work）**  
用在工作网络。该网络中的大多数计算机可以信任，不会影响你的计算机。只接受被选中的连接。  

**家庭（home）**  
用在家庭网络。该网络中的大多数计算机可以信任，不会影响你的计算机。只接受被选中的连接。  

**内部（internal）**  
用在内部网络。该网络中的大多数计算机可以信任，不会影响你的计算机。只接受被选中的连接。  

**受信任的（trusted）**  
允许所有网络连接。
## 为网络连接设置或者修改区域
区域设置以 ZONE= 选项 存储在网络连接的ifcfg文件中。如果这个选项缺失或者为空，firewalld 将使用配置的默认区域。如果这个连接受到 NetworkManager 控制，你也可以使用 nm-connection-editor 来修改区域。
## 由 NetworkManager 控制的网络连接
防火墙不能够通过 NetworkManager 显示的名称来配置网络连接，只能配置网络接口。因此在网络连接之前 NetworkManager 将配置文件所述连接对应的网络接口告诉 firewalld 。如果在配置文件中没有配置区域，接口将配置到 firewalld 的默认区域。如果网络连接使用了不止一个接口，所有的接口都会应用到 fiwewalld。接口名称的改变也将由 NetworkManager 控制并应用到firewalld。为了简化，自此，网络连接将被用作与区域的关系。如果一个接口断开了， NetworkManager 也将告诉 firewalld 从区域中删除该接口。当 firewalld 由 systemd 或者 init 脚本启动或者重启后，firewalld 将通知 NetworkManager 把网络连接增加到区域。
## 由脚本控制的网络
对于由网络脚本控制的连接有一条限制：没有守护进程通知 firewalld 将连接增加到区域。这项工作仅在 ifcfg-post 脚本进行。因此，此后对网络连接的重命名将不能被应用到firewalld。同样，在连接活动时重启 firewalld 将导致与其失去关联。现在有意修复此情况。最简单的是将全部未配置连接加入默认区域。
##使用 firewalld
通过图形界面工具 firewall-config 或者命令行客户端 firewall-cmd 启用或者关闭防火墙特性。
### 使用 firewall-cmd
命令行工具 firewall-cmd 支持全部防火墙特性。对于状态和查询模式，命令只返回状态，没有其他输出。  
#### 获取 firewalld 状态
    firewall-cmd --state
此举返回 firewalld 的状态，没有任何输出。可以使用以下方式获得状态输出：

    firewall-cmd --state && echo "Running" || echo "Not running"
在 Fedora 19 中, 状态输出比此前直观:

    # rpm -qf $( which firewall-cmd )
    firewalld-0.3.3-2.fc19.noarch
    # firewall-cmd --state
    not running
#### 在不改变状态的条件下重新加载防火墙：
    firewall-cmd --reload
如果你使用 --complete-reload ，状态信息将会丢失。这个选项应当仅用于处理防火墙问题时，例如，状态信息和防火墙规则都正常，但是不能建立任何连接的情况。
#### 获取支持的区域列表
    firewall-cmd --get-zones
这条命令输出用空格分隔的列表。
#### 获取所有支持的服务
    firewall-cmd --get-services
这条命令输出用空格分隔的列表。
#### 获取所有支持的ICMP类型
    firewall-cmd --get-icmptypes
这条命令输出用空格分隔的列表。
#### 列出全部启用的区域的特性
    firewall-cmd --list-all-zones
输出格式是：

    <zone>
       interfaces: <interface1> ..
       services: <service1> ..
       ports: <port1> ..
       forward-ports: <forward port1> ..
       icmp-blocks: <icmp type1> ..
       ..
####　输出区域 <zone> 全部启用的特性。
如果省略区域，将显示默认区域的信息。

    firewall-cmd [--zone=<zone>] --list-all

#### 获取默认区域的网络设置
    firewall-cmd --get-default-zone　　

#### 设置默认区域
    firewall-cmd --set-default-zone=<zone>
流入默认区域中配置的接口的新访问请求将被置入新的默认区域。当前活动的连接将不受影响。
#### 获取活动的区域
    firewall-cmd --get-active-zones
这条命令将用以下格式输出每个区域所含接口：

     <zone1>: <interface1> <interface2> ..
     <zone2>: <interface3> ..
#### 根据接口获取区域
    firewall-cmd --get-zone-of-interface=<interface>
这条命令将输出接口所属的区域名称。
#### 将接口增加到区域
    firewall-cmd [--zone=<zone>] --add-interface=<interface>
如果接口不属于区域，接口将被增加到区域。如果区域被省略了，将使用默认区域。接口在重新加载后将重新应用。
#### 修改接口所属区域
    firewall-cmd [--zone=<zone>] --change-interface=<interface>
这个选项与 --add-interface 选项相似，但是当接口已经存在于另一个区域的时候，该接口将被添加到新的区域。
#### 从区域中删除一个接口
    firewall-cmd [--zone=<zone>] --remove-interface=<interface>
#### 查询区域中是否包含某接口
    firewall-cmd [--zone=<zone>] --query-interface=<interface>
返回接口是否存在于该区域。没有输出。
#### 列举区域中启用的服务
    firewall-cmd [ --zone=<zone> ] --list-services
#### 启用应急模式阻断所有网络连接，以防出现紧急状况
    firewall-cmd --panic-on
#### 禁用应急模式
    firewall-cmd --panic-off
应急模式在 0.3.0 版本中发生了变化
在 0.3.0 之前的 FirewallD版本中, panic 选项是 --enable-panic 与 --disable-panic.
#### 查询应急模式
    firewall-cmd --query-panic
此命令返回应急模式的状态，没有输出。可以使用以下方式获得状态输出：

    firewall-cmd --query-panic && echo "On" || echo "Off"
运行时模式下对区域进行的修改不是永久有效的。重新加载或者重启后修改将失效。
#### 启用区域中的一种服务
    firewall-cmd [--zone=<zone>] --add-service=<service> [--timeout=<seconds>]
此举启用区域中的一种服务。如果未指定区域，将使用默认区域。如果设定了超时时间，服务将只启用特定秒数。如果服务已经活跃，将不会有任何警告信息。  
例: 使区域中的 ipp-client 服务生效60秒:

    firewall-cmd --zone=home --add-service=ipp-client --timeout=60
例: 启用默认区域中的http服务:

    firewall-cmd --add-service=http
#### 禁用区域中的某种服务
    firewall-cmd [--zone=<zone>] --remove-service=<service>
此举禁用区域中的某种服务。如果未指定区域，将使用默认区域。  
例: 禁止 home 区域中的 http 服务:
 firewall-cmd --zone=home --remove-service=http
区域中的服务将被禁用。如果服务没有启用，将不会有任何警告信息。
查询区域中是否启用了特定服务
 firewall-cmd [--zone=<zone>] --query-service=<service>
如果服务启用，将返回1,否则返回0。没有输出信息。
启用区域端口和协议组合
 firewall-cmd [--zone=<zone>] --add-port=<port>[-<port>]/<protocol> [--timeout=<seconds>]
此举将启用端口和协议的组合。端口可以是一个单独的端口 <port> 或者是一个端口范围 <port>-<port> 。协议可以是 tcp 或 udp。
禁用端口和协议组合
 firewall-cmd [--zone=<zone>] --remove-port=<port>[-<port>]/<protocol>
查询区域中是否启用了端口和协议组合
 firewall-cmd [--zone=<zone>] --query-port=<port>[-<port>]/<protocol>
如果启用，此命令将有返回值。没有输出信息。
启用区域中的 IP 伪装功能
 firewall-cmd [--zone=<zone>] --add-masquerade
此举启用区域的伪装功能。私有网络的地址将被隐藏并映射到一个公有IP。这是地址转换的一种形式，常用于路由。由于内核的限制，伪装功能仅可用于IPv4。
禁用区域中的 IP 伪装
 firewall-cmd [--zone=<zone>] --remove-masquerade
查询区域的伪装状态
 firewall-cmd [--zone=<zone>] --query-masquerade
如果启用，此命令将有返回值。没有输出信息。
启用区域的 ICMP 阻塞功能
 firewall-cmd [--zone=<zone>] --add-icmp-block=<icmptype>
此举将启用选中的 Internet 控制报文协议 （ICMP） 报文进行阻塞。 ICMP 报文可以是请求信息或者创建的应答报文，以及错误应答。
禁止区域的 ICMP 阻塞功能
 firewall-cmd [--zone=<zone>] --remove-icmp-block=<icmptype>
查询区域的 ICMP 阻塞功能
 firewall-cmd [--zone=<zone>] --query-icmp-block=<icmptype>
如果启用，此命令将有返回值。没有输出信息。
例: 阻塞区域的响应应答报文:
 firewall-cmd --zone=public --add-icmp-block=echo-reply
在区域中启用端口转发或映射
 firewall-cmd [--zone=<zone>] --add-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
端口可以映射到另一台主机的同一端口，也可以是同一主机或另一主机的不同端口。端口号可以是一个单独的端口 <port> 或者是端口范围 <port>-<port> 。协议可以为 tcp 或udp 。目标端口可以是端口号 <port> 或者是端口范围 <port>-<port> 。目标地址可以是 IPv4 地址。受内核限制，端口转发功能仅可用于IPv4。
禁止区域的端口转发或者端口映射
 firewall-cmd [--zone=<zone>] --remove-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
查询区域的端口转发或者端口映射
 firewall-cmd [--zone=<zone>] --query-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
如果启用，此命令将有返回值。没有输出信息。
例: 将区域 home 的 ssh 转发到 127.0.0.2
 firewall-cmd --zone=home --add-forward-port=port=22:proto=tcp:toaddr=127.0.0.2
处理永久区域

永久选项不直接影响运行时的状态。这些选项仅在重载或者重启服务时可用。为了使用运行时和永久设置，需要分别设置两者。 选项 --permanent 需要是永久设置的第一个参数。
获取永久选项所支持的服务
 firewall-cmd --permanent --get-services
获取永久选项所支持的ICMP类型列表
 firewall-cmd --permanent --get-icmptypes
获取支持的永久区域
 firewall-cmd --permanent --get-zones
启用区域中的服务
 firewall-cmd --permanent [--zone=<zone>] --add-service=<service>
此举将永久启用区域中的服务。如果未指定区域，将使用默认区域。
禁用区域中的一种服务
 firewall-cmd --permanent [--zone=<zone>] --remove-service=<service>
查询区域中的服务是否启用
 firewall-cmd --permanent [--zone=<zone>] --query-service=<service>
如果服务启用，此命令将有返回值。此命令没有输出信息。
例: 永久启用 home 区域中的 ipp-client 服务
 firewall-cmd --permanent --zone=home --add-service=ipp-client
永久启用区域中的一个端口-协议组合
 firewall-cmd --permanent [--zone=<zone>] --add-port=<port>[-<port>]/<protocol>
永久禁用区域中的一个端口-协议组合
 firewall-cmd --permanent [--zone=<zone>] --remove-port=<port>[-<port>]/<protocol>
查询区域中的端口-协议组合是否永久启用
 firewall-cmd --permanent [--zone=<zone>] --query-port=<port>[-<port>]/<protocol>
如果服务启用，此命令将有返回值。此命令没有输出信息。
例: 永久启用 home 区域中的 https (tcp 443) 端口
 firewall-cmd --permanent --zone=home --add-port=443/tcp
永久启用区域中的伪装
 firewall-cmd --permanent [--zone=<zone>] --add-masquerade
此举启用区域的伪装功能。私有网络的地址将被隐藏并映射到一个公有IP。这是地址转换的一种形式，常用于路由。由于内核的限制，伪装功能仅可用于IPv4。
永久禁用区域中的伪装
 firewall-cmd --permanent [--zone=<zone>] --remove-masquerade
查询区域中的伪装的永久状态
 firewall-cmd --permanent [--zone=<zone>] --query-masquerade
如果服务启用，此命令将有返回值。此命令没有输出信息。
永久启用区域中的ICMP阻塞
 firewall-cmd --permanent [--zone=<zone>] --add-icmp-block=<icmptype>
此举将启用选中的 Internet 控制报文协议 （ICMP） 报文进行阻塞。 ICMP 报文可以是请求信息或者创建的应答报文或错误应答报文。
永久禁用区域中的ICMP阻塞
 firewall-cmd --permanent [--zone=<zone>] --remove-icmp-block=<icmptype>
查询区域中的ICMP永久状态
 firewall-cmd --permanent [--zone=<zone>] --query-icmp-block=<icmptype>
如果服务启用，此命令将有返回值。此命令没有输出信息。
例: 阻塞公共区域中的响应应答报文:
 firewall-cmd --permanent --zone=public --add-icmp-block=echo-reply
在区域中永久启用端口转发或映射
 firewall-cmd --permanent [--zone=<zone>] --add-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
端口可以映射到另一台主机的同一端口，也可以是同一主机或另一主机的不同端口。端口号可以是一个单独的端口 <port> 或者是端口范围 <port>-<port> 。协议可以为 tcp 或udp 。目标端口可以是端口号 <port> 或者是端口范围 <port>-<port> 。目标地址可以是 IPv4 地址。受内核限制，端口转发功能仅可用于IPv4。
永久禁止区域的端口转发或者端口映射
 firewall-cmd --permanent [--zone=<zone>] --remove-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
查询区域的端口转发或者端口映射状态
 firewall-cmd --permanent [--zone=<zone>] --query-forward-port=port=<port>[-<port>]:proto=<protocol> {&nbsp;:toport=<port>[-<port>] |&nbsp;:toaddr=<address> |&nbsp;:toport=<port>[-<port>]:toaddr=<address> }
如果服务启用，此命令将有返回值。此命令没有输出信息。
例: 将 home 区域的 ssh 服务转发到 127.0.0.2
 firewall-cmd --permanent --zone=home --add-forward-port=port=22:proto=tcp:toaddr=127.0.0.2
直接选项

直接选项主要用于使服务和应用程序能够增加规则。 规则不会被保存，在重新加载或者重启之后必须再次提交。传递的参数 <args> 与 iptables, ip6tables 以及 ebtables 一致。
选项 --direct 需要是直接选项的第一个参数。
将命令传递给防火墙。参数 <args> 可以是 iptables, ip6tables 以及 ebtables 命令行参数。
 firewall-cmd --direct --passthrough { ipv4 | ipv6 | eb } <args>
为表 <table> 增加一个新链 <chain> 。
 firewall-cmd --direct --add-chain { ipv4 | ipv6 | eb } <table> <chain>
从表 <table> 中删除链 <chain> 。
 firewall-cmd --direct --remove-chain { ipv4 | ipv6 | eb } <table> <chain>
查询 <chain> 链是否存在与表 <table>. 如果是，返回0,否则返回1.
 firewall-cmd --direct --query-chain { ipv4 | ipv6 | eb } <table> <chain>
如果启用，此命令将有返回值。此命令没有输出信息。
获取用空格分隔的表 <table> 中链的列表。
 firewall-cmd --direct --get-chains { ipv4 | ipv6 | eb } <table>
为表 <table> 增加一条参数为 <args> 的链 <chain> ，优先级设定为 <priority>。
 firewall-cmd --direct --add-rule { ipv4 | ipv6 | eb } <table> <chain> <priority> <args>
从表 <table> 中删除带参数 <args> 的链 <chain>。
 firewall-cmd --direct --remove-rule { ipv4 | ipv6 | eb } <table> <chain> <args>
查询 带参数 <args> 的链 <chain> 是否存在表 <table> 中. 如果是，返回0,否则返回1.

    firewall-cmd --direct --query-rule { ipv4 | ipv6 | eb } <table> <chain> <args>
如果启用，此命令将有返回值。此命令没有输出信息。
获取表 <table> 中所有增加到链 <chain> 的规则，并用换行分隔。

    firewall-cmd --direct --get-rules { ipv4 | ipv6 | eb } <table> <chain> 

当前的 firewalld 特性

D-BUS 接口

D-BUS 接口提供防火墙状态的信息，使防火墙的启用、停用或查询设置成为可能。
区域

网络或者防火墙区域定义了连接的可信程度。firewalld 提供了几种预定义的区域。区域配置选项和通用配置信息可以在firewall.zone(5)的手册里查到。
服务

服务可以是一系列本读端口、目的以及附加信息，也可以是服务启动时自动增加的防火墙助手模块。预定义服务的使用使启用和禁用对服务的访问变得更加简单。服务配置选项和通用文件信息在 firewalld.service(5) 手册里有描述。
ICMP 类型

Internet 控制报文协议 (ICMP) 被用以交换报文和互联网协议 (IP) 的错误报文。在 firewalld 中可以使用 ICMP 类型来限制报文交换。 ICMP 类型配置选项和通用文件信息可以参阅 firewalld.icmptype(5) 手册。
直接接口

直接接口主要用于服务或者应用程序增加特定的防火墙规则。这些规则并非永久有效，并且在收到 firewalld 通过 D-Bus 传递的启动、重启、重载信号后需要重新应用。
运行时配置

运行时配置并非永久有效，在重新加载时可以被恢复，而系统或者服务重启、停止时，这些选项将会丢失。
永久配置

永久配置存储在配置文件种，每次机器重启或者服务重启、重新加载时将自动恢复。
托盘小程序

托盘小程序 firewall-applet 为用户显示防火墙状态和存在的问题。它也可以用来配置用户允许修改的设置。
图形化配置工具

firewall daemon 主要的配置工具是 firewall-config 。它支持防火墙的所有特性（除了由服务/应用程序增加规则使用的直接接口）。 管理员也可以用它来改变系统或用户策略。
命令行客户端

firewall-cmd 是命令行下提供大部分图形工具配置特性的工具。
对于 ebtables 的支持

要满足 libvirt daemon 的全部需求，在内核 netfilter 级上防止 ip*tables 和 ebtables 间访问问题，ebtables 支持是需要的。由于这些命令是访问相同结构的，因而不能同时使用。
/usr/lib/firewalld 中的默认/备用配置

该目录包含了由 firewalld 提供的默认以及备用的 ICMP 类型、服务、区域配置。由 firewalld 软件包提供的这些文件不能被修改，即使修改也会随着 firewalld 软件包的更新被重置。 其他的 ICMP 类型、服务、区域配置可以通过软件包或者创建文件的方式提供。
/etc/firewalld 中的系统配置设置

存储在此的系统或者用户配置文件可以是系统管理员通过配置接口定制的，也可以是手动定制的。这些文件将重载默认配置文件。
为了手动修改预定义的 icmp 类型，区域或者服务，从默认配置目录将配置拷贝到相应的系统配置目录，然后根据需求进行修改。
如果你加载了有默认和备用配置的区域，在 /etc/firewalld 下的对应文件将被重命名为 <file>.old 然后启用备用配置。
正在开发的特性

富语言

富语言特性提供了一种不需要了解iptables语法的通过高级语言配置复杂 IPv4 和 IPv6 防火墙规则的机制。
Fedora 19 提供了带有 D-Bus 和命令行支持的富语言特性第2个里程碑版本。第3个里程碑版本也将提供对于图形界面 firewall-config 的支持。
对于此特性的更多信息，请参阅： firewalld Rich Language
锁定

锁定特性为 firewalld 增加了锁定本地应用或者服务配置的简单配置方式。它是一种轻量级的应用程序策略。
Fedora 19 提供了锁定特性的第二个里程碑版本，带有 D-Bus 和命令行支持。第3个里程碑版本也将提供图形界面 firewall-config 下的支持。
更多信息请参阅： firewalld Lockdown
永久直接规则

这项特性处于早期状态。它将能够提供保存直接规则和直接链的功能。通过规则不属于该特性。更多关于直接规则的信息请参阅Direct options。
从 ip*tables 和 ebtables 服务迁移

这项特性处于早期状态。它将尽可能提供由iptables,ip6tables 和 ebtables 服务配置转换为永久直接规则的脚本。此特性在由firewalld提供的直接链集成方面可能存在局限性。
此特性将需要大量复杂防火墙配置的迁移测试。
计划和提议功能

防火墙抽象模型

在 ip*tables 和 ebtables 防火墙规则之上添加抽象层使添加规则更简单和直观。要抽象层功能强大，但同时又不能复杂，并不是一项简单的任务。为此，不得不开发一种防火墙语言。使防火 墙规则拥有固定的位置，可以查询端口的访问状态、访问策略等普通信息和一些其他可能的防火墙特性。
对于 conntrack 的支持

要终止禁用特性已确立的连接需要 conntrack 。不过，一些情况下终止连接可能是不好的，如：为建立有限时间内的连续性外部连接而启用的防火墙服务。
用户交互模型

这是防火墙中用户或者管理员可以启用的一种特殊模式。应用程序所有要更改防火墙的请求将定向给用户知晓，以便确认和否认。为一个连接的授权设置一个 时间限制并限制其所连主机、网络或连接是可行的。配置可以保存以便将来不需通知便可应用相同行为。 该模式的另一个特性是管理和应用程序发起的请求具有相同功能的预选服务和端口的外部链接尝试。服务和端口的限制也会限制发送给用户的请求数量。
用户策略支持

管理员可以规定哪些用户可以使用用户交互模式和限制防火墙可用特性。
端口元数据信息(由 Lennart Poettering 提议)

拥有一个端口独立的元数据信息是很好的。当前对 /etc/services 的端口和协议静态分配模型不是个好的解决方案，也没有反映当前使用情况。应用程序或服务的端口是动态的，因而端口本身并不能描述使用情况。
元数据信息可以用来为防火墙制定简单的规则。下面是一些例子：
允许外部访问文件共享应用程序或服务
允许外部访问音乐共享应用程序或服务
允许外部访问全部共享应用程序或服务
允许外部访问 torrent 文件共享应用程序或服务
允许外部访问 http 网络服务
这里的元数据信息不只有特定应用程序，还可以是一组使用情况。例如：组“全部共享”或者组“文件共享”可以对应于全部共享或文件共享程序(如：torrent 文件共享)。这些只是例子，因而，可能并没有实际用处。
这里是在防火墙中获取元数据信息的两种可能途径：
第一种是添加到 netfilter (内核空间)。好处是每个人都可以使用它，但也有一定使用限制。还要考虑用户或系统空间的具体信息，所有这些都需要在内核层面实现。
第二种是添加到 firewall daemon 中。这些抽象的规则可以和具体信息(如：网络连接可信级、作为具体个人/主机要分享的用户描述、管理员禁止完全共享的应归则等)一起使用。
第二种解决方案的好处是不需要为有新的元数据组和纳入改变(可信级、用户偏好或管理员规则等等)重新编译内核。这些抽象规则的添加使得 firewall daemon 更加自由。即使是新的安全级也不需要更新内核即可轻松添加。
sysctld

现在仍有 sysctl 设置没有正确应用。一个例子是，在 rc.sysinit 正运行时，而提供设置的模块在启动时没有装载或者重新装载该模块时会发生问题。
另一个例子是 net.ipv4.ip_forward ，防火墙设置、libvirt 和用户/管理员更改都需要它。如果有两个应用程序或守护进程只在需要时开启 ip_forwarding ，之后可能其中一个在不知道的情况下关掉服务，而另一个正需要它，此时就不得不重启它。
sysctl daemon 可以通过对设置使用内部计数来解决上面的问题。此时，当之前请求者不再需要时，它就会再次回到之前的设置状态或者是直接关闭它。
防火墙规则

netfilter 防火墙总是容易受到规则顺序的影响，因为一条规则在链中没有固定的位置。在一条规则之前添加或者删除规则都会改变此规则的位置。 在静态防火墙模型中，改变防火墙就是重建一个干净和完善的防火墙设置，且受限于 system-config-firewall / lokkit 直接支持的功能。也没有整合其他应用程序创建防火墙规则，且如果自定义规则文件功能没在使用 s-c-fw / lokkit 就不知道它们。默认链通常也没有安全的方式添加或删除规则而不影响其他规则。
动态防火墙有附加的防火墙功能链。这些特殊的链按照已定义的顺序进行调用，因而向链中添加规则将不会干扰先前调用的拒绝和丢弃规则。从而利于创建更为合理完善的防火墙配置。
下面是一些由守护进程创建的规则，过滤列表中启用了在公共区域对 ssh , mdns 和 ipp-client 的支持：

    *filter
     :INPUT ACCEPT [0:0]
     :FORWARD ACCEPT [0:0]
     :OUTPUT ACCEPT [0:0]
     :FORWARD_ZONES - [0:0]
     :FORWARD_direct - [0:0]
     :INPUT_ZONES - [0:0]
     :INPUT_direct - [0:0]
     :IN_ZONE_public - [0:0]
     :IN_ZONE_public_allow - [0:0]
     :IN_ZONE_public_deny - [0:0]
     :OUTPUT_direct - [0:0]
     -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     -A INPUT -i lo -j ACCEPT
     -A INPUT -j INPUT_direct
     -A INPUT -j INPUT_ZONES
     -A INPUT -p icmp -j ACCEPT
     -A INPUT -j REJECT --reject-with icmp-host-prohibited
     -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
     -A FORWARD -i lo -j ACCEPT
     -A FORWARD -j FORWARD_direct
     -A FORWARD -j FORWARD_ZONES
     -A FORWARD -p icmp -j ACCEPT
     -A FORWARD -j REJECT --reject-with icmp-host-prohibited
     -A OUTPUT -j OUTPUT_direct
     -A IN_ZONE_public -j IN_ZONE_public_deny
     -A IN_ZONE_public -j IN_ZONE_public_allow
     -A IN_ZONE_public_allow -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
     -A IN_ZONE_public_allow -d 224.0.0.251/32 -p udp -m udp --dport 5353 -m conntrack --ctstate NEW -j ACCEPT
     -A IN_ZONE_public_allow -p udp -m udp --dport 631 -m conntrack --ctstate NEW -j ACCEPT
使用 deny/allow 模型来构建一个清晰行为(最好没有冲突规则)。例如： ICMP 块将进入 IN_ZONE_public_deny 链(如果为公共区域设置了的话)，并将在 IN_ZONE_public_allow 链之前处理。
该模型使得在不干扰其他块的情况下向一个具体块添加或删除规则而变得更加容易。



 [莫小安](https://www.cnblogs.com/moxiaoan/) 



##  			[CentOS7使用firewalld打开关闭防火墙与端口](https://www.cnblogs.com/moxiaoan/p/5683743.html) 		

1、firewalld的基本使用

启动： systemctl start firewalld

关闭： systemctl stop firewalld

查看状态： systemctl status firewalld 

开机禁用  ： systemctl disable firewalld

开机启用  ： systemctl enable firewalld

 

 

2.systemctl是CentOS7的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。

启动一个服务：systemctl start firewalld.service
关闭一个服务：systemctl stop firewalld.service
重启一个服务：systemctl restart firewalld.service
显示一个服务的状态：systemctl status firewalld.service
在开机时启用一个服务：systemctl enable firewalld.service
在开机时禁用一个服务：systemctl disable firewalld.service
查看服务是否开机启动：systemctl is-enabled firewalld.service
查看已启动的服务列表：systemctl list-unit-files|grep enabled
查看启动失败的服务列表：systemctl --failed

3.配置firewalld-cmd

查看版本： firewall-cmd --version

查看帮助： firewall-cmd --help

显示状态： firewall-cmd --state

查看所有打开的端口： firewall-cmd --zone=public --list-ports

更新防火墙规则： firewall-cmd --reload

查看区域信息:  firewall-cmd --get-active-zones

查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0

拒绝所有包：firewall-cmd --panic-on

取消拒绝状态： firewall-cmd --panic-off

查看是否拒绝： firewall-cmd --query-panic

 

那怎么开启一个端口呢

添加

firewall-cmd --zone=public --add-port=80/tcp --permanent    （--permanent永久生效，没有此参数重启后失效）

重新载入

firewall-cmd --reload

查看

firewall-cmd --zone= public --query-port=80/tcp

删除

firewall-cmd --zone= public --remove-port=80/tcp --permanent

 

# Centos7-----firewalld详解

 					[![img](https://s1.51cto.com/wyfs02/M01/8A/58/wKioL1guZSuS1TVxAAANL2NkVRo236_middle.jpg)](https://blog.51cto.com/11638832) 				

壹休哥

0人评论



25720人阅读

2018-03-28 22:06:51



**Centos7-----firewalld详解**

概述：
Filewalld（动态防火墙）作为redhat7系统中变更对于netfilter内核模块的管理工具；
iptables service 管理防火墙规则的模式（静态）：用户将新的防火墙规则添加进 /etc/sysconfig/iptables 配置文件当中，
再执行命令 /etc/init.d/iptables reload 使变更的规则生效。在这整个过程的背后，iptables service 首先对旧的防火墙规则进行了清空，
然后重新完整地加载所有新的防火墙规则，如果加载了防火墙的模块，需要在重新加载后进行手动加载防火墙的模块；
firewalld 管理防火墙规则的模式（动态）:任何规则的变更都不需要对整个防火墙规则列表进行重新加载，只需要将变更部分保存并更新到运行中的 iptables 即可。
还有命令行和图形界面配置工具，它仅仅是替代了 iptables service 部分，其底层还是使用 iptables 作为防火墙规则管理入口。
firewalld 使用 python 语言开发，在新版本中已经计划使用 c++ 重写 daemon 部分。
![Centos7-----firewalld详解](https://s1.51cto.com/images/blog/201803/28/90263d4831ee5fc6732479ba1d83414e.jpg?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

便于理解：
相较于传统的防火墙管理配置工具，firewalld支持动态更新技术并加入了区域（zone）的概念。
简单来说，区域就是firewalld预先准备了几套防火墙策略集合（策略模板），用户可以根据生产场景的不同而选择合适的策略集合，
从而实现防火墙策略之间的快速切换。例如，我们有一台笔记本电脑，每天都要在办公室、咖啡厅和家里使用。
按常理来讲，这三者的安全性按照由高到低的顺序来排列，应该是家庭、公司办公室、咖啡厅。
当前，我们希望为这台笔记本电脑指定如下防火墙策略规则：在家中允许访问所有服务；
在办公室内仅允许访问文件共享服务；在咖啡厅仅允许上网浏览。
在以往，我们需要频繁地手动设置防火墙策略规则，而现在只需要预设好区域集合，
然后只需轻点鼠标就可以自动切换了，从而极大地提升了防火墙策略的应用效率。
firewalld中常见的区域名称（默认为public）；

区域：
firewalld将网卡对应到不同的区域（zone），zone 默认共有9个：block（拒绝）
block（拒绝） dmz（非军事化） drop（丢弃） external（外部） home（家庭） internal（内部） public（公开） trusted（信任） work（工作区）.
不同的区域之间的差异是其对待数据包的默认行为不同，firewalld的默认区域为public；

文件：
/usr/lib/firewalld/services/   ：firewalld服务默认在此目录下定义了70+种服务供我们使用，格式：服务名.xml；
/etc/firewalld/zones/     : 默认区域配置文件，配置文件中指定了编写完成的规则（规则中的服务名必须与上述文件名一致）；
分为多个文件的优点 :
第一，通过服务名字来管理规则更加人性化，
第二，通过服务来组织端口分组的模式更加高效，如果一个服务使用了若干个网络端口，则服务的配置文件就相当于提供了到这些端口的规则管理的批量操作快捷方式；

命令语法：firewall-cmd [--zone=zone] 动作 [--permanent]        
注：如果不指定--zone选项，则为当前所在的默认区域，--permanent选项为是否将改动写入到区域配置文件中

firewall的状态：
--state               ##查看防火墙的状态
--reload              ##重新加载防火墙，中断用户的连接，将临时配置清掉，加载配置文件中的永久配置
--complete-reload     ##重新加载防火墙，不中断用户的连接（防火墙出严重故障时使用）
--panic-on                ##紧急模式，强制关闭所有网络连接,--panic-off是关闭紧急模式

动作中查看操作：
--get-icmptypes           ##查看支持的所有ICMP类型
--get-zones               ##查看所有区域
--get-default-zone        ##查看当前的默认区域
--get-active-zones        ##查看当前正在使用的区域
--get-services            ##查看当前区域支持的服务
--list-services           ##查看当前区域开放的服务列表
--list-all                ##查看此区域内的所有配置，类似与iptables -L -n

更改区域操作：
--set-default-zone=work                   ##更改默认的区域

新建--add或删除--remove规则：
--add-interface=eth0                  ##将网络接口添加到默认的区域内
--add-port=12222/tcp   --permanent        ##添加端口到区域开放列表中
--add-port=5000-10000/tcp --permanent     ##将端口范围添加到开放列表中；
--add-service=ftp --permanent         ##添加服务到区域开放列表中（注意服务的名称需要与此区域支持的服务列表中的名称一致）
--add-source=192.168.1.1              ##添加源地址的流量到指定区域
--remove-source=192.168.1.1           ##删除源地址的流量到指定区域
--change-interface=eth1               ##改变指定的接口到其他区域
--remove-service=http             ##在home区域内将http服务删除在开放列表中删除
--add-masquerade                  ##开启SNAT（源地址转换）
--query-masquerade                    ##查询SNAT的状态
--remove-interface=eth0               ##将网络接口在默认的区域内删除
--query-interface=eth0              ##确定该网卡接口是否存在于此区域  
--add-forward-port=port=513:proto=tcp:toport=22:toaddr=192.168.100.101        ##端口转发

Rich规则：
当基本firewalld语法规则不能满足要求时，可以使用以下更复杂的规则
.rich-rules 富规则，功能强,表达性语言,查看帮助：man 5 firewalld.richlanguage
.rich规则比基本的firewalld语法实现更强的功能，不仅实现允许/拒绝，还可以实现日志syslog和auditd，也可以实现端口转发，伪装和限制速率
rich规则实施顺序有以下四点
a.该区域的端口转发，伪造规则
b.该区域的日志规则
c.该区域的允许规则
d.该区域的拒绝规则
每个匹配的规则都生效，所有规则都不匹配，该区域默认规则生效；

Rich规则语法：

Rich规则选项：
--add-rich-rule=’rule’              ##新建rich规则
--remove-rich-rule=’rule’           ##删除rich规则
--query-rich-rule=’rule’            ##查看单条rich规则
--list-rich-rules                   ##查看rich规则列表

Rich规则示例：
#拒绝从192.168.0.11的所有流量
firewall-cmd  --permanent --zone=cla***oom  --add-rich-rule=‘rule family=ipv4  source address=192.168.0.11/32  reject‘
#限制每分钟只有两个连接到ftp服务
firewall-cmd  --add-rich-rule=’rule service name=ftp limitvalue=2/m  accept’
#抛弃esp协议的所有数据包
firewall-cmd  --permanent  --add-rich-rule=‘rule protocol value=esp drop‘
#接受所有192.168.1.0/24子网端口范置7900-7905的TCP流量
firewall-cmd
  --permanent --zone=vnc  --add-rich-rule=‘rule family=ipv4 source 
address=192.168.1.0/24  port  port=7900-7905 protocol=tcp accept‘
##开启SNAT
firewall-cmd   --permanent --add-rich-rule=‘rule family=ipv4 source address=192.168.0.0/24 masquerade‘
##使用rule规则实现端口转发，to-addr选项如果不指定默认转发到本机
firewall-cmd
 --permanent  --add-rich-rule='rule family=ipv4 source 
address=192.168.100.0/24 forward-port port=80 protocol=tcp to-port=8080 
to-addr=192.168.100.100'



# Linux Firewalld用法及案例

 																				2018年05月02日 18:12:51 					[_Leo](https://me.csdn.net/xiazichenxi) 						阅读数：1576 										


 									

# 官方文档

- [RHEL](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-using_firewalls)
- [FIREWALLD](http://www.firewalld.org/documentation/)

# Firewalld概述

- 动态防火墙管理工具
- 定义区域与接口安全等级
- 运行时和永久配置项分离
- 两层结构 
  - 核心层 处理配置和后端，如iptables、ip6tables、ebtables、ipset和模块加载器
  - 顶层D-Bus 更改和创建防火墙配置的主要方式。所有firewalld都使用该接口提供在线工具

# 原理图

![这里写图片描述](https://img-blog.csdn.net/20180502182244373?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3hpYXppY2hlbnhp/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 
 ![这里写图片描述](https://img-blog.csdn.net/20180502182231252?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3hpYXppY2hlbnhp/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

# Firewalld与iptables对比

- firewalld 是 iptables 的前端控制器
- iptables  静态防火墙 任一策略变更需要reload所有策略，丢失现有链接
- firewalld 动态防火墙 任一策略变更不需要reload所有策略 将变更部分保存到iptables,不丢失现有链接
- firewalld 提供一个daemon和service 底层使用iptables
- 基于内核的Netfilter

# 配置方式

- firewall-config 图形界面
- firewall-cmd 命令行工具
- 直接修改配置文件  
   /lib/firewalld 用于默认和备用配置 
   /etc/firewalld 用于用户创建和自定义配置文件 覆盖默认配置 
   /etc/firewalld/firewall.conf 全局配置

# 运行时配置和永久配置

- firewall-cmd –zone=public –add-service=smtp 运行时配置，重启后失效
- firewall-cmd –permanent –zone=public –add-service=smtp 永久配置，不影响当前连接，重启后生效
- firewall-cmd –runtime-to-permanent 将运行时配置保存为永久配置

# Zone

- 网络连接的可信等级,一对多，一个区域对应多个连接
- drop.xml       拒绝所有的连接
- block.xml    拒绝所有的连接
- public.xml   只允许指定的连接 *默认区域
- external.xml 只允许指定的连接
- dmz.xml      只允许指定的连接
- work.xml   只允许指定的连接
- home.xml     只允许指定的连接
- internal.xml 只允许指定的连接
- trusted.xml  允许所有的连接 
   /lib/firewalld/zones 默认和备用区域配置 
   /etc/firewalld/zones 用户创建和自定义区域配置文件 覆盖默认配置

```
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas. You do not trust the other computers on networks to not harm yo
ur computer. Only selected incoming connections are accepted.</description>
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
</zone>12345678
version="string" 版本
target="ACCEPT|%%REJECT%%|DROP" 默认REJECT 策略
short 名称
description 描述
interface 接口
    name="string"
source 源地址
    address="address[/mask]"
    mac="MAC"
    ipset="ipset"
service 服务
    name="string"
port 端口
    port="portid[-portid]"
    protocol="tcp|udp"
protocol 协议
    value="string"
icmp-block 
    name="string"
icmp-block-inversion
masquerade
forward-port
    port="portid[-portid]"
    protocol="tcp|udp"
    to-port="portid[-portid]"
    to-addr="address"
source-port
    port="portid[-portid]"
    protocol="tcp|udp"
rule 
<rule [family="ipv4|ipv6"]>
  [ <source address="address[/mask]" [invert="True"]/> ]
  [ <destination address="address[/mask]" [invert="True"]/> ]
  [
    <service name="string"/> |
    <port port="portid[-portid]" protocol="tcp|udp"/> |
    <protocol value="protocol"/> |
    <icmp-block name="icmptype"/> |
    <masquerade/> |
    <forward-port port="portid[-portid]" protocol="tcp|udp" [to-port="portid[-portid]"] [to-addr="address"]/> |
    <source-port port="portid[-portid]" protocol="tcp|udp"/> |
  ]
  [ <log [prefix="prefixtext"] [level="emerg|alert|crit|err|warn|notice|info|debug"]/> [<limit value="rate/duration"/>] </log> ]
  [ <audit> [<limit value="rate/duration"/>] </audit> ]
  [
    <accept> [<limit value="rate/duration"/>] </accept> |
    <reject [type="rejecttype"]> [<limit value="rate/duration"/>] </reject> |
    <drop> [<limit value="rate/duration"/>] </drop> |
    <mark set="mark[/mask]"> [<limit value="rate/duration"/>] </mark>
  ]
</rule>

rich rule 
<rule [family="ipv4|ipv6"]>
  <source address="address[/mask]" [invert="True"]/>
  [ <log [prefix="prefixtext"] [level="emerg|alert|crit|err|warn|notice|info|debug"]/> [<limit value="rate/duration"/>] </log> ]
  [ <audit> [<limit value="rate/duration"/>] </audit> ]
  <accept> [<limit value="rate/duration"/>] </accept> |
  <reject [type="rejecttype"]> [<limit value="rate/duration"/>] </reject> |
  <drop> [<limit value="rate/duration"/>] </drop>
</rule>12345678910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061
```

# services

```
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>MySQL</short>
  <description>MySQL Database Server</description>
  <port protocol="tcp" port="3306"/>
</service>123456
version="string"
short
description
port
    port="string"
    protocol="string"
protocol
    value="string"
source-port
    port="string"
    protocol="string"
module
    name="string"
destination
    ipv4="address[/mask]"
    ipv6="address[/mask]"12345678910111213141516
```

# ipset配置

```
系统默认没有ipset配置文件，需要手动创建ipset配置文件
mkdir -p /etc/firewalld/ipsets/mytest.xml mytest就是ipset名称
根据官方手册提供的配置模板
<?xml version="1.0" encoding="utf-8"?>
<ipset type="hash:net">
  <short>white-list</short>
  <entry>192.168.1.1</entry>
  <entry>192.168.1.2</entry>
  <entry>192.168.1.3</entry>
</ipset>
entry也就是需要加入的IP地址
firewall-cmd --get-ipsets 显示当前的ipset
firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source ipset="mytest" port port=80 protocol=tcp accept' 将ipset应用到策略中12345678910111213
```

# 服务管理

- yum -y install firewalld firewall-config #安装firewalld
- systemctl enable|disable firewalld #开机启动
- systemctl start|stop|restart firewalld #启动、停止、重启firewalld

# 如果想使用iptables配置防火墙规则，要先安装iptables并禁用firewalld

- yum -y install iptables-services #安装iptables
- systemctl enable iptables #开机启动
- systemctl start|stop|restart iptables #启动、停止、重启iptables

# firewall-cmd常用命令

```
firewall-cmd --version 查看firewalld版本
firewall-cmd --help 查看firewall-cmd用法
man firewall-cmd123
firewall-cmd --state #查看firewalld的状态
systemctl status firewalld #查看firewalld的状态,详细12
firewall-cmd --reload 重新载入防火墙配置，当前连接不中断
firewall-cmd --complete-reload 重新载入防火墙配置，当前连接中断12
firewall-cmd --get-services 列出所有预设服务
firewall-cmd --list-services 列出当前服务
firewall-cmd --permanent --zone=public --add-service=smtp 启用服务
firewall-cmd --permanent --zone=public --remove-service=smtp 禁用服务1234
firewall-cmd --zone=public --list-ports 
firewall-cmd --permanent --zone=public --add-port=8080/tcp 启用端口
firewall-cmd --permanent --zone=public --remove-port=8080/tcp 禁用端口
firewall-cmd --zone="public" --add-forward-port=port=80:proto=tcp:toport=12345 同服务器端口转发 80端口转发到12345端口
firewall-cmd --zone=public --add-masquerade 不同服务器端口转发，要先开启 masquerade
firewall-cmd --zone="public" --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=192.168.1.1 不同服务器端口转发，转发到192.168.1.1的8080端口123456
firewall-cmd --get-zones 查看所有可用区域
firewall-cmd --get-active-zones 查看当前活动的区域,并附带一个目前分配给它们的接口列表
firewall-cmd --list-all-zones 列出所有区域的所有配置
firewall-cmd --zone=work --list-all 列出指定域的所有配置
firewall-cmd --get-default-zone 查看默认区域
firewall-cmd --set-default-zone=public 设定默认区域123456
firewall-cmd --get-zone-of-interface=eno222
firewall-cmd [--zone=<zone>] --add-interface=<interface> 添加网络接口
firewall-cmd [--zone=<zone>] --change-interface=<interface> 修改网络接口
firewall-cmd [--zone=<zone>] --remove-interface=<interface> 删除网络接口
firewall-cmd [--zone=<zone>] --query-interface=<interface> 查询网络接口12345
firewall-cmd --permanent --zone=internal --add-source=192.168.122.0/24 设置网络地址到指定的区域
firewall-cmd --permanent --zone=internal --remove-source=192.168.122.0/24 删除指定区域中的网路地址12
firewall-cmd --get-icmptypes1
```

# Rich Rules

- firewall-cmd –list-rich-rules 列出所有规则
- firewall-cmd [–zone=zone] –query-rich-rule=’rule’ 检查一项规则是否存在
- firewall-cmd [–zone=zone] –remove-rich-rule=’rule’ 移除一项规则
- firewall-cmd [–zone=zone] –add -rich-rule=’rule’  新增一

## 复杂规则配置案例

```
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address=192.168.0.14 accept' 允许来自主机 192.168.0.14 的所有 IPv4 流量
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.10" port port=22 protocol=tcp reject' 拒绝来自主机 192.168.1.10 到 22 端口的 IPv4 的 TCP 流量
firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 source address=10.1.0.3 forward-port port=80 protocol=tcp to-port=6532' 许来自主机 10.1.0.3 到 80 端口的 IPv4 的 TCP 流量，并将流量转发到 6532 端口上
firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 forward-port port=80 protocol=tcp to-port=8080 to-addr=172.31.4.2' 将主机 172.31.4.2 上 80 端口的 IPv4 流量转发到 8080 端口（需要在区域上激活 masquerade）
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.122.0" accept' 允许192.168.122.0/24主机所有连接
firewall-cmd --add-rich-rule='rule service name=ftp limit value=2/m accept' 每分钟允许2个新连接访问ftp服务
firewall-cmd --add-rich-rule='rule service name=ftp log limit value="1/m" audit accept' 同意新的IPv4和IPv6连接FTP ,并使用审核每分钟登录一次
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.122.0/24" service name=ssh log prefix="ssh" level="notice" limit value="3/m" accept' 允许来自1192.168.122.0/24地址的新IPv4连接连接TFTP服务,并且每分钟记录一次
firewall-cmd --permanent --add-rich-rule='rule protocol value=icmp drop' 丢弃所有icmp包
firewall-cmd --add-rich-rule='rule family=ipv4 source address=192.168.122.0/24 reject' --timeout=10 当使用source和destination指定地址时,必须有family参数指定ipv4或ipv6。如果指定超时,规则将在指定的秒数内被激活,并在之后被自动移除
firewall-cmd --add-rich-rule='rule family=ipv6 source address="2001:db8::/64" service name="dns" audit limit value="1/h" reject' --timeout=300 拒绝所有来自2001:db8::/64子网的主机访问dns服务,并且每小时只审核记录1次日志
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.122.0/24 service name=ftp accept' 允许192.168.122.0/24网段中的主机访问ftp服务
firewall-cmd --add-rich-rule='rule family="ipv6" source address="1:2:3:4:6::" forward-portto-addr="1::2:3:4:7" to-port="4012" protocol="tcp" port="4011"' 转发来自ipv6地址1:2:3:4:6::TCP端口4011,到1:2:3:4:7的TCP端口401212345678910111213
```

# Direct Rules

- firewall-cmd –direct –add-rule ipv4 filter IN_public_allow 0 -p tcp –dport 80 -j ACCEPT 添加规则
- firewall-cmd –direct –remove-rule ipv4 filter IN_public_allow 10 -p tcp –dport 80 -j ACCEPT 删除规则
- firewall-cmd –direct –get-all-rules 列出规则



**1.firewalld介绍** 
动态防火墙后台程序 firewalld 提供了一个 动态管理的防火墙, 用以支持网络  “ zones” , 以分配对一个网络及其相关链接 
和界面一定程度的信任。它具备对 IP v4 和 IP v6 防火墙设置的支持。  
它支持以太网桥 , 并有分离运行时间和永久性配置选择，它还具备一个通向服务或者应用程序以直接增加防火墙规则 
的接口  
系统提供了图像化的配置工具 firewall-config 、 system-config-firewall, 提供命令行客户端  firewall-cmd, 用于配 
置 firewalld 永久性或非永久性运行时间的改变 : [英语培训费用](http://wh.xhd.cn/ielts/ieltsnews/761434.html)它依次用iptables 工具与执行数据包筛选的内核中的  Netfilter 通信 
**2.firewalld和 iptables service** 
firewalld 和  iptables service 之间最本质的不同是 :

- iptables service 在 /etc/sysconfig/iptables 中储存配 置  
- firewalld 将配置储存在 /usr/lib/firewalld/ 和 /etc/firewalld/ 中的各种 XML 文件里 .  

当 firewalld 在Red Hat Enterprise Linux上安装失败时， /etc/sysconfig/iptables  文件就不存在

**3,firewalld域** 
基于用户对网络中设备和交通所给与的信任程度，防火墙可以用来将网络分割成不同的区域 
![这里写图片描述](https://img-blog.csdn.net/2018060713542987?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

**1.命令管理firewalld** 
下载并开启服务关闭iptables

![这里写图片描述](https://img-blog.csdn.net/20180607140639524?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
打开图形管理工具

![这里写图片描述](https://img-blog.csdn.net/2018060714235346?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
firewalld管理命令

![这里写图片描述](https://img-blog.csdn.net/2018060714455847?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
![这里写图片描述](https://img-blog.csdn.net/20180607144520489?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
**2.修改默认域** 
安装apache并修改默认发布页

查看默认域：

测试： 
![这里写图片描述](https://img-blog.csdn.net/20180607145222264?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
修改默认的域为trusted

再次测试： 
![这里写图片描述](https://img-blog.csdn.net/20180607145355467?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
**3.对指定ip或网段的控制** 
添加一块新的网卡，并且给其配ip 
![这里写图片描述](https://img-blog.csdn.net/20180607150355222?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
![这里写图片描述](https://img-blog.csdn.net/2018060715063812?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

临时添加主机域，重启之后会失效：

![这里写图片描述](https://img-blog.csdn.net/20180607152525945?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
永久生效需要添加参数–permanentt

重启之后不消失 
![这里写图片描述](https://img-blog.csdn.net/20180607153120187?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
从trusted域移除 
![这里写图片描述](https://img-blog.csdn.net/20180607153858830?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
**4.用文件的方式添加**

![这里写图片描述](https://img-blog.csdn.net/20180607154928251?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
![这里写图片描述](https://img-blog.csdn.net/201806071549494?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
**5.修改端口**

![这里写图片描述](https://img-blog.csdn.net/20180607155350183?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
**6.移除防火墙的服务** 
暂时性移除

![这里写图片描述](https://img-blog.csdn.net/20180607155818404?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
永久性移除

![这里写图片描述](https://img-blog.csdn.net/20180607160011542?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
测试： 
![这里写图片描述](https://img-blog.csdn.net/2018060716010856?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

添加direct rules 使62这台主机可以访问80端口 -p 协议 –dport 目的端口 -s 来源 -j  动作

查看direct rules

测试： 
在62这台主机可以访问172.25.254.105 
![这里写图片描述](https://img-blog.csdn.net/20180615090550372?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
其他主机不能访问 
![这里写图片描述](https://img-blog.csdn.net/20180615091208640?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

当别的主机通过22端口连接105时会转发至205这台主机

![这里写图片描述](https://img-blog.csdn.net/20180615091809769?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)  
测试：

![这里写图片描述](https://img-blog.csdn.net/20180615092144377?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

取消地址转发：

在desktop中： 
添加两块网卡 分别修改ip为 eth0 172.25.4.105 eth1  172.25.254.105 
使内核让两块网卡可以通信

![这里写图片描述](https://img-blog.csdn.net/20180615093807386?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

在server中： 
修改ip为172.25.4.205 GATEWAY=172.25.4.105  
再测试：ping 172.25.254.62 成功

![这里写图片描述](https://img-blog.csdn.net/20180615094318354?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTQ3Njk3OA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



# FirewallD 基本知识（FirewallD入门教程）

centos 7中防火墙FirewallD是一个非常的强大的功能了, FirewallD  提供了支持网络/防火墙区域(zone)定义网络链接以及接口安全等级的动态防火墙管理工具。它支持 IPv4, IPv6  防火墙设置以及以太网桥接，并且拥有运行时配置和永久配置选项。它也支持允许服务或者应用程序直接添加防火墙规则的接口。 以前的  system-config-firewall/lokkit 防火墙模型是静态的，每次修改都要求防火墙完全重启。这个过程包括内核  netfilter 防火墙模块的卸载和新配置所需模块的装载等。而模块的卸载将会破坏状态防火墙和确立的连接。

 

相反，firewall daemon  动态管理防火墙，不需要重启整个防火墙便可应用更改。因而也就没有必要重载所有内核防火墙模块了。不过，要使用 firewall daemon  就要求防火墙的所有变更都要通过该守护进程来实现，以确保守护进程中的状态和内核里的防火墙是一致的。另外，firewall daemon 无法解析由  ip*tables 和 ebtables 命令行工具添加的防火墙规则。[![FirewallD](https://www.fujieace.com/wp-content/uploads/2018/04/005-4.png?x86494)](https://www.fujieace.com/wp-content/uploads/2018/04/005-4.png?x86494)

 

**下面我们一起来详细的看看关于centos 7中FirewallD 防火墙使用方法：**

 

启动FirewallD服务：

systemctl enable firewalld.service #设置开机启动

systemctl start firewalld.service #开启服务

 

查看防火墙状态：

systemctl status firewalld

 

## 一、区域管理

 

1、网络区域简介

通过将网络划分成不同的区域，制定出不同区域之间的访问控制策略来控制不同程序区域间传送的数据流。例如，互联网是不可信任的区域，而内部网络是高度信任的区域。网络安全模型可以在安装，初次启动和首次建立网络连接时选择初始化。该模型描述了主机所连接的整个网络环境的可信级别，并定义了新连接的处理方式。

 

**有如下几种不同的初始化区域：**

- 阻塞区域（block）：任何传入的网络数据包都将被阻止。
- 工作区域（work）：相信网络上的其他计算机，不会损害你的计算机。
- 家庭区域（home）：相信网络上的其他计算机，不会损害你的计算机。
- 公共区域（public）：不相信网络上的任何计算机，只有选择接受传入的网络连接。
- 隔离区域（DMZ）：隔离区域也称为非军事区域，内外网络之间增加的一层网络，起到缓冲作用。对于隔离区域，只有选择接受传入的网络连接。
- 信任区域（trusted）：所有的网络连接都可以接受。
- 丢弃区域（drop）：任何传入的网络连接都被拒绝。
- 内部区域（internal）：信任网络上的其他计算机，不会损害你的计算机。只有选择接受传入的网络连接。
- 外部区域（external）：不相信网络上的其他计算机，不会损害你的计算机。只有选择接受传入的网络连接。

 

注：FirewallD的默认区域是public。

 

2、显示支持的区域列表

```
firewall-cmd --get-zones
```

 

3、 设置为家庭区域

```
firewall-cmd --set-default-zone=home
```

 

4、查看当前区域

```
firewall-cmd --get-active-zones
```

 

5、设置当前区域的接口

```
firewall-cmd --get-zone-of-interface=enp03s
```

 

6、显示所有公共区域（public）

```
firewall-cmd --zone=public --list-all
```

 

7、 临时修改网络接口（enp0s3）为内部区域（internal）

```
firewall-cmd --zone=internal --change-interface=enp03s
```

 

8、 永久修改网络接口enp03s为内部区域（internal）

```
firewall-cmd --permanent --zone=internal --change-interface=enp03s
```

 

## 二、 服务管理

 

1、显示服务列表

Amanda, FTP, Samba和TFTP等最重要的服务已经被FirewallD提供相应的服务，可以使用如下命令查看：

```
firewall-cmd --get-services
```

 

2、允许SSH服务通过

```
firewall-cmd --enable service=ssh
```

 

3、禁止SSH服务通过

```
firewall-cmd --disable service=ssh
```

 

4、打开TCP的8080端口

```
firewall-cmd --enable ports=8080/tcp
```

 

5、临时允许Samba服务通过600秒

```
firewall-cmd --enable service=samba --timeout=600
```

 

6、显示当前服务

```
firewall-cmd --list-services
```

 

7、添加HTTP服务到内部区域（internal）

```
firewall-cmd --permanent --zone=internal --add-service=http
```

 

firewall-cmd --reload #在不改变状态的条件下重新加载防火墙

 

## 三、端口管理

 

1、打开端口

 

\#打开443/TCP端口

```
firewall-cmd --add-port=443/tcp
```

 

\#永久打开3690/TCP端口

```
firewall-cmd --permanent --add-port=3690/tcp
```

 

\#永久打开一个端口段

```
firewall-cmd --permanent --add-port=1000-2000/tcp
```

 

\#永久打开端口好像需要reload一下，临时打开好像不用，如果用了reload临时打开的端口就失效了

\#其它服务也可能是这样的，这个没有测试

```
firewall-cmd --reload
```

 

\#查看防火墙，添加的端口也可以看到

```
firewall-cmd --list-all
```

 

2、删除服务或端口

```
firewall-cmd --permanent --zone=public --remove-service=https
firewall-cmd --permanent --zone=public --remove-port=8080-8081/tcp
firewall-cmd --reload
```

 

## 四、 直接模式

FirewallD包括一种直接模式，使用它可以完成一些工作，例如打开TCP协议的9999端口：

```
firewall-cmd --direct -add-rule ipv4 filter INPUT 0 -p tcp --dport 9000 -j ACCEPT
firewall-cmd --reload
```

 

## 五、关闭服务的方法

你也可以关闭目前还不熟悉的FirewallD防火墙，而使用iptables，命令如下：

```
systemctl stop firewalld
systemctl disable firewalld
yum install iptables-services
systemctl start iptables
systemctl enable iptables
```



<svg aria-hidden="true" style="position: absolute; width: 0px; height: 0px; overflow: hidden;"></svg>
<svg aria-hidden="true" style="position: absolute; width: 0px; height: 0px; overflow: hidden;"></svg>
- ​                          
- [首页](https://www.csdn.net/)
- [博客](https://blog.csdn.net/)
- [学院](https://edu.csdn.net)
- [下载](https://download.csdn.net)
- [图文课](https://gitchat.csdn.net/?utm_source=csdn_toolbar)
- [论坛](https://bbs.csdn.net)
- [APP](https://www.csdn.net/app/)                          
- [问答](https://ask.csdn.net)
- [商城](https://mall.csdn.net)
- [VIP会员](https://mall.csdn.net/vip_code)
- [活动](https://huiyi.csdn.net/)
- [招聘](http://job.csdn.net)
- [ITeye](http://www.iteye.com)
- [GitChat](https://gitbook.cn/?ref=csdn)

- 
- ​                                                    
- [写博客](https://mp.csdn.net/postedit)              
- [![img](https://csdnimg.cn/public/common/toolbar/images/baiduapplogo@2x.png)小程序](javascript:;)                
- ​              [![img](https://csdnimg.cn/public/common/toolbar/images/message-icon.png)消息](https://i.csdn.net/#/msg/index)                              
- [登录](https://passport.csdn.net/account/login)[注册](https://passport.csdn.net/account/login)

​                         [                             ![img](https://img-ads.csdn.net/2019/201903221114185850.gif)                         ](https://bss.csdn.net/m/topic/python_developer?utm_source=bkhd)                     

转

# Linux防火墙设置 FirewallD

 																				2018年07月03日 16:47:55 					[sforiz](https://me.csdn.net/sforiz) 						阅读数：581 										


 									

entos从7.0  开始将原先的防火墙iptables换成了FirewallD。FirewallD支持 IPv4, IPv6  防火墙设置以及以太网桥接，并且拥有运行时配置和永久配置选项，被称作动态管理防火墙，也就是说不需要重启整个防火墙便可应用更改。centos7默认安装了firewalld，若没有安装，执行 yum install firewalld firewalld-config 安装，其中firewalld-config是GUI工具。FirewallD与iptables关系：

![firewalld-iptables](https://www.biaodianfu.com/wp-content/uploads/2016/12/firewalld-iptables.png)

firewalld底层仍旧是基于iptables的，但还是有很多不同的地方：

- iptables在  /etc/sysconfig/iptables 中储存配置，而 firewalld 将配置储存在 /usr/lib/firewalld/ 和  /etc/firewalld/ 中的各种 XML  文件里，其中前者是默认的配置，请不要修改。可以在/etc/firewalld/中编辑自己的配置，firewalld优先使用/etc/firewalld/中的配置。
- 使用  iptables，每一个单独更改意味着清除所有旧有的规则和从 /etc/sysconfig/iptables里读取所有新的规则，然而使用  firewalld 却不会再创建任何新的规则；仅仅运行规则中的不同之处。因此，firewalld 可以在运行时间内，改变设置而不丢失现行连接。

**firewalld****中zone概念（区域）**

RHEL7中的不过貌似其实现方式还是和iptables一样的，但是不像mariaDB那样兼容MySQL命令，FirewallD无法解析由 ip*tables 和 ebtables 命令行工具添加的防火墙规则

FirewallD使用区域（zone）的概念来管理，每个网卡对应一个zone，这些zone的配置文件可在/usr/lib/firewalld/zones/下看到，默认的是public.由firewalld 提供的区域按照从不信任到信任的顺序排序：

- drop（丢弃）任何流入网络的包都被丢弃，不作出任何响应。只允许流出的网络连接。
- block（阻塞）任何进入的网络连接都被拒绝，并返回 IPv4 的 icmp-host-prohibited 报文或者 IPv6 的 icmp6-adm-prohibited 报文。只允许由该系统初始化的网络连接。
- public（公开） 在用以可以公开的部分。你认为网络中其他的计算机不可信并且可能伤害你的计算机。只允许选中的连接接入。
- external（外部）用在路由器等启用伪装的外部网络。你认为网络中其他的计算机不可信并且可能伤害你的计算机。只允许选中的连接接入。
- dmz（隔离区）用以允许隔离区（dmz）中的电脑有限地被外界网络访问。只接受被选中的连接。
- work（工作）用在工作网络。你信任网络中的大多数计算机不会影响你的计算机。只接受被选中的连接。
- home（家庭）用在家庭网络。你信任网络中的大多数计算机不会影响你的计算机。只接受被选中的连接。
- internal（内部）用在内部网络。你信任网络中的大多数计算机不会影响你的计算机。只接受被选中的连接。
- trusted（信任）允许所有网络连接。

**firewalld****中的过滤规则**

- source: 根据源地址过滤
- interface: 根据网卡过滤
- service: 根据服务名过滤
- port: 根据端口过滤
- icmp-block: icmp 报文过滤，按照 icmp 类型配置
- masquerade: ip 地址伪装
- forward-port: 端口转发
- rule: 自定义规则

其中，过滤规则的优先级遵循如下顺序

- source
- interface
- conf

**firewalld****常用命令**

fierwalld可以直接修改配置文件进行配置，也可以通过配置工具的命令，这里因为是远程操作为了确保开启后ssh端口是开放的，所以直接修改配置文件。

先查看/etc/firewalld/firewalld.conf中DefaultZone的值，默认是DefaultZone=public，这时/etc/firewalld/zones/目录下应该有个public.xml文件，vi打开它修改成：















| 123456789 | <?xml version="1.0" encoding="utf-8"?><zone>    <short>Public</short>    <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>    <service name="dhcpv6-client"/>    <service name="ssh"/>    <service name="http"/>    <service name="https"/></zone> |
| --------- | ------------------------------------------------------------ |
|           |                                                              |

这就代表在public zone中开放ssh（22）、http（80）、https（443）端口，其中对应每一个在/usr/lib/firewalld/services/下*.xml文件定义好的服务类型，比如http.xml文件如下：















| 123456 | <?xml version="1.0" encoding="utf-8"?><service>    <short>WWW (HTTP)</short>    <description>HTTP is the protocol used to serve Web pages. If you plan to make your Web server publicly available, enable this option. This option is not required for viewing pages locally or developing Web pages.</description>    <port protocol="tcp" port="80"/></service> |
| ------ | ------------------------------------------------------------ |
|        |                                                              |

所以也可以直接在public.xml中这样：















| 123456789 | <?xml version="1.0" encoding="utf-8"?><zone>    <short>Public</short>    <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>    <service name="dhcpv6-client"/>    <service name="ssh"/>    <port protocol="tcp" port="80"/> #等效的    <service name="https"/></zone> |
| --------- | ------------------------------------------------------------ |
|           |                                                              |

每次改配置文件还是比较麻烦的，firewalld可以使用firewall-config和firewall-cmd进行配置，前者是由于GUI模式下，后者为命令行下工具,一些常用命令如下：













| 1234567891011121314151617181920 | systemctl start firewalld #启动systemctl status firewalld #或者firewall-cmd –state 查看状态sytemctl disable firewalld #停止并禁用开机启动systemctl enable firewalld #设置开机启动systemctl stop firewalld #禁用firewall-cmd –version #查看版本firewall-cmd –help#帮助信息firewall-cmd –get-active-zones#查看区域信息firewall-cmd –get-zone-of-interface=eth0#查看指定接口所属区域firewall-cmd –panic-on #拒绝所有包firewall-cmd –panic-off#取消拒绝状态firewall-cmd –query-panic#查看是否拒绝firewall-cmd –reload #更新防火墙规则firewall-cmd –complete-reload #断开再连接firewall-cmd –zone=public –add-interface=eth0 #将接口添加到public区域 ， 默认接口都在public。若加上–permanet则永久生效firewall-cmd –set-default-zone=public #设置public为默认接口区域firewall-cmd –zone=pulic –list-ports #查看所有打开的端口firewall-cmd –zone=pulic –add-port=80/tcp #把tcp 80端口加入到区域firewall-cmd –zone=public –add-service=http #把http服务加入到区域firewall-cmd –zone=public –remove-service=http #移除http服务 |
| ------------------------------- | ------------------------------------------------------------ |
|                                 |                                                              |

部分命令共同的参数说明：

- –zone=ZONE 指定命令作用的zone，省缺的话命令作用于默认zone
- –permanent 有此参数表示命令只是修改配置文件，需要reload才能生效；无此参数则立即在当前运行的实例中生效，不过不会改动配置文件，重启firewalld服务就没效果了。
- –timeout=seconds 表示命令效果持续时间，到期后自动移除，不能和–permanent同时使用。例如因调试的需要加了某项配置，到时间自动移除了，不需要再回来手动删除。也可在出现异常情况时加入特定规则，过一段时间自动解除。

参考连接：

- <https://fedoraproject.org/wiki/FirewallD/zh-cn>
- <https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7>

## 拓展知识：Linux中的防火墙

### netfilter

iptables、firewalld这些软件本身其实并不具备防火墙功能，他们的作用都是在用户空间中管理和维护规则，只不过规则结构和使用方法不一样罢了，真正利用规则进行过滤是由内核的netfilter完成的。netfilter是Linux   2.4内核引入的包过滤引擎。由一些数据包过滤表组成，这些表包含内核用来控制信息包过滤的规则集。iptables、firewalld等等都是在用户空间修改过滤表规则的便捷工具。

linux内部结构可以分为三部分，从最底层到最上层依次是：硬件–>内核空间–>用户空间

![linux](https://www.biaodianfu.com/wp-content/uploads/2016/12/linux.png)

netfilter在数据包必须经过且可以读取规则的位置，共设有5个控制关卡。这5个关卡处的检查规则分别放在5个规则链中：

- PREROUTING 数据包刚进入网络接口之后，路由之前
- INPUT 数据包从内核流入用户空间
- FORWARD 在内核空间中，从一个网络接口进入，到另一个网络接口去。转发过滤。
- OUTPUT 数据包从用户空间流出到内核空间。
- POSTROUTING 路由后，数据包离开网络接口前。

链其实就是包含众多规则的检查清单，每一条链中包含很多规则。当一个数据包到达一个链时，系统就会从链中第一条规则开始检查，看该数据包是否满足规则所定义的条件。如果满足，系统就会根据该条规则所定义的方法处理该数据包；否则就继续检查下一条规则，如果该数据包不符合链中任一条规则，系统就会根据该链预先定义的默认策略来处理数据包。

当一个数据包进入网卡时，它首先进入PREROUTING链，内核根据数据包目的IP判断是否需要转送出去。如果数据包就是进入本机的，它就会沿着图向下移动，到达INPUT链。数据包到了INPUT链后，任何进程都会收到它。本机上运行的程序可以发送数据包，这些数据包会经过OUTPUT链，然后到达POSTROUTING链输出。如果数据包是要转发出去的，且内核允许转发，数据包就会如图所示向右移动，经过FORWARD链，然后到达POSTROUTING链输出

![netfilter](https://www.biaodianfu.com/wp-content/uploads/2016/12/netfilter.png)

可以看出，刚从网络接口进入的数据包尚未进行路由决策，还不知道数据要走向哪里，所以进出口处没办法实现数据过滤，需要在内核空间设置转发关卡、进入用户空间关卡和离开用户空间关卡。

### iptables

iptablses按照用途和使用场合，将5条链各自切分到五张不同的表中。也就是说每张表中可以按需要单独为某些链配置规则。例如，mangle表和filter表中都能为INPUT链配置规则，当数据包流经INPUT位置（进入用户空间），这两个表中INPUT链的规则都会用来做过滤检查。

![iptables](https://www.biaodianfu.com/wp-content/uploads/2016/12/iptables.jpg)

五张表，每张表侧重于不同的功能

- filter 数据包过滤功能。只涉及INPUT, FORWARD, OUTPUT三条链。是iptables命令默认操纵的表。
- nat 地址转换功能。NAT转换只涉及PREROUTING, OUTPUT, POSTOUTING三条链。可通过转发让局域网机器连接互联网
- mangle 数据包修改功能。每条链上都可以做修改操作。修改报文元数据，做防火墙标记等。
- raw 快速通道功能。为了提高效率，优先级最高，符合raw表规则的数据包会跳过一些检查。
- security 需要和selinux结合使用，内置规则比较复杂，通常都会被关闭。

iptables还支持自定义规则链。自定义的链必须和某个特定的链关联起来。可在某个链中设定规则，满足一定条件的数据包跳转到某个目标链处理，目标链处理完成后返回当前链中继续处理后续规则。因为链中规则是从头到尾依次检查的，所以规则的次序是非常重要的。越严格的规则应该越靠前。

#### **iptablse服务管理**















| 12345678910 | service iptables start\|stop\|restart\|statusservice iptables save   *//定义的所有内容，在重启时都会失效。调用save命令可以把规则保存到文件/etc/sysconfig/iptables中。*iptables-save           *//保存规则*iptables-restore        *//加载规则。开机的时候，会自动加载/etc/sysconfig/iptables*iptables-restore < /etc/sysconfig/iptables2     *//加载自定义的规则文件* *//iptables服务配置文件：   /etc/sysconfig/iptables-config**//iptables规则文件：       /etc/sysconfig/iptables* echo "1">/proc/sys/net/ipv4/ip_forward   *//打开iptables转发：* |
| ----------- | ------------------------------------------------------------ |
|             |                                                              |



#### **iptables命令参考**













| 1    | iptables [-t TABLE] COMMAND [CHAIN] [CRETIRIA]...  [-j  ACTION] |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

省缺表名为filter。命令中用到的序号(RULENUM)都基于1。

**COMMAND 命令选项**













| 123456789101112 | -A\|--append  CHAIN                                 *//链尾添加新规则*-D\|--delete  CHAIN [RULENUM]                       *//删除链中规则，按需序号或内容确定要删除的规则*-I\|--insert  CHAIN [RULENUM]                       *//在链中插入一条新的规则，默认插在开头*-R\|--replace CHAIN  RULENUM                        *//替换、修改一条规则，按序号或内容确定*-L\|--list   [CHAIN [RULENUM]]                      *//列出指定链或所有链中指定规则或所有规则*-S\|--list-urles [CHAIN [RULENUM]]                  *//显示链中规则*-F\|--flush [CHAIN]                                 *//清空指定链或所有链中规则*-Z\|--zero [CHAIN [RULENUM]]                        *//重置指定链或所有链的计数器(匹配的数据包数和流量字节数)*-N\|--new-chain CHAIN                               *//新建自定义规则链*-X\|--delete-cahin [CHAIN]                          *//删除指定表中用户自定义的规则链*-E\|--rename-chain OLDCHAIN NEWCHAIN                *//重命名链，移动任何引用*-P\|-policy CHAIN TARGET                            *//设置链的默认策略，数据包未匹配任意一条规则就按此策略处理* |
| --------------- | ------------------------------------------------------------ |
|                 |                                                              |

**CRETIRIA 条件匹配** 

分为基本匹配和扩展匹配，扩展匹配又分为隐式匹配和显示匹配。

基本匹配：（可使用 ! 可以否定一个子句，如-p !tcp）













| 12345 | -p\|--proto  PROTO                      *//按协议匹配，如tcp、udp、icmp，all表示所有协议。 （/etc/protocols中的协议名）*-s\|--source ADDRESS[/mask]...          *//按数据包的源地址匹配，可使用IP地址、网络地址、主机名、域名*-d\|--destination ADDRESS[/mask]...     *//按目标地址匹配，可使用IP地址、网络地址、主机名、域名*-i\|--in-interface INPUTNAME[ +]        *//按入站接口(网卡)名匹配，+用于通配。如 eth0, eth+ 。一般用在INPUT和PREROUTING链*-o\|--out-interface OUTPUTNAME[+]       *//按出站接口(网卡)名匹配，+用于通配。如 eth0, eth+ 。一般用在OUTPUT和POSTROUTING链* |
| ----- | ------------------------------------------------------------ |
|       |                                                              |

扩展匹配：（如: -p tcp  -m tcp  –dport 80）











| 1    | -m\|--match MATCHTYPE  EXTENSIONMATCH...    *//扩展匹配，可能加载extension* |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

隐式扩展匹配

对-p PROTO的扩展，或者说是-p PROTO的附加匹配条件，-m PROTO 可以省略，所以叫隐式













| 1234567891011 | -m tcp   *//-p tcp的扩展*　　　　--sport  [!]N[:M]                      *//源端口, 服务名、端口、端口范围。*　　　　--dport  [!]N[:M]                      *//目标端口，服务名、端口、端口范围*　　　　--tcp-flags CHECKFLAGS FLAGSOFTRUE  *//TCP标志位:SYN(同步),ACK(应答),RST(重置),FIN(结束),URG(紧急),PSH(强迫推送)。多个标志位逗号分隔。*　　　　　　　　　　　　　　　　　　　　　　　　　*//CHECKFLAGS为要检查的标志位，FLAGSOFTRUE为必须为1的标志位（其余的应该为0）*　　　　--syn                               *//第一次握手。 等效于 --tcpflags syn,ack,fin,rst syn   四个标志中只有syn为1*-m udp   *//-p udp的扩展*　　　　--sport N[-M] 　　　　--dport N[-M]-m icmp  *//隐含条件为-p icmp*　　　　--icmp-type  N             *//8:echo-request  0:echo-reply* |
| ------------- | ------------------------------------------------------------ |
|               |                                                              |

显示扩展匹配













| 12345678910111213141516171819202122232425262728293031323334353637383940 | -m state　　　　--state    *//连接状态检测，NEW,ESTABLISHED,RELATED,INVALID*-m multiport 　　　　--source-ports   PORT[,PORT]...\|N:M            *//多个源端口，多个端口用逗号分隔，*　　　　--destination-ports PORT[,PORT]...\|N:M         *//多个目的端口*　　　　--ports     　　　　　　　　　　　　　　　　　　　　 *//多个端口，每个包的源端口和目的端口相同才会匹配*-m limit　　　　--limit   N/UNIT    *//速率，如3/minute, 1/s, n/second , n/day*　　　　--limit-burst N     *//峰值速率，如100，表示最大不能超过100个数据包*-m connlimit　　　　--connlimit-above N  *//多于n个，前面加!取反*-m iprange　　　　--src-range IP-IP　　　　--dst-range IP-IP-m mac                    　　　　--mac-source         *//mac地址限制，不能用在OUTPUT和POSTROUTING规则链上，因为封包要送到网卡后，才能由网卡驱动程序透过ARP 通讯协议查出目的地的MAC 地址*-m string　　　　--algo [bm\|kmp]      *//匹配算法*　　　　--string "PATTERN"   *//匹配字符模式*-m recent　　　　--name               *//设定列表名称，默认为DEFAULT*　　　　--rsource            *//源地址*　　　　--rdest              *//目的地址*　　　　--set                *//添加源地址的包到列表中*　　　　--update             *//每次建立连接都更新列表*　　　　--rcheck             *//检查地址是否在列表*　　　　--seconds            *//指定时间。必须与--rcheck或--update配合使用*　　　　--hitcount           *//命中次数。必须和--rcheck或--update配合使用*　　　　--remove             *//在列表中删除地址*-m time　　　　--timestart h:mm　　　　--timestop  hh:mm　　　　--days DAYS          *//Mon,Tue,Wed,Thu,Fri,Sat,Sun; 逗号分隔*-m mark　　　　--mark N            *//是否包含标记号N*-m owner 　　　　--uid-owner 500   *//用来匹配来自本机的封包，是否为某特定使用者所产生的,可以避免服务器使用root或其它身分将敏感数据传送出*　　　　--gid-owner O     *//用来匹配来自本机的封包，是否为某特定使用者群组所产生的*　　　　--pid-owner 78    *//用来匹配来自本机的封包，是否为某特定进程所产生的*　　　　--sid-owner 100   *//用来匹配来自本机的封包，是否为某特定连接（Session ID）的响应封包* |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**ACTION 目标策略(TARGET)**













| 1234567891011121314151617181920212223 | -j\|--jump TARGET                *//跳转到目标规则，可能加载target extension*-g\|--goto  CHAIN                *//跳转到指定链，不再返回*ACCEPT             规则验证通过，不再检查当前链的后续规则，直接跳到下一个规则链。DROP                直接丢弃数据包，不给任何回应。中断过滤。REJECT             拒绝数据包通过，会返回响应信息。中断过滤。--reject-with  tcp-reset\|port-unreachable\|echo-replyLOG                  在/var/log/messages文件中记录日志，然后将数据包传递给下一条规则。详细位置可查看/etc/syslog.conf配置文件--log-prefix "INPUT packets"ULOG                更广范围的日志记录信息QUEUE              防火墙将数据包移交到用户空间，通过一个内核模块把包交给本地用户程序。中断过滤。RETURN            防火墙停止执行当前链中的后续规则，并返回到调用链。主要用在自定义链中。custom_chain    转向自定义规则链DNAT                目标地址转换，改变数据包的目标地址。外网访问内网资源，主要用在PREROUTING。完成后跳到下一个规则链--to-destination ADDRESS[-ADDRESS][:PORT[-PORT]]SNAT                源地址转换，改变数据包的源地址。内网访问外网资源。主机的IP地址必须是静态的，主要用在POSTROUTING。完成后跳到下一个规则链。--to-source ADDRESS[-ADDRESS][:PORT[-PORT]]MASQUERADE   源地址伪装，用于主机IP是ISP动态分配的情况，会从网卡读取主机IP。直接跳到下一个规则链。--to-ports 1024-31000REDIRECT        数据包重定向，主要是端口重定向，把包分流。处理完成后继续匹配其他规则。能会用这个功能来迫使站点上的所有Web流量都通过一个Web高速缓存，比如Squid。--to-ports 8080MARK                 打防火墙标记。继续匹配规则。--set-mark 2MIRROR           发送包之前交换IP源和目的地址，将数据包返回。中断过滤。 |
| ------------------------------------- | ------------------------------------------------------------ |
|                                       |                                                              |

辅助选项：











| 123456789101112 | -t\|--table TABLE     *//指定操作的表，默认的表为filter*-n\|--numeric         *//用数字形式显示地址和端口，显示主机IP地址而不是主机名*-x\|--exact           *//计数器显示精确值，不做单位换算*-v\|--verbose  (x3)   *//查看规则列表时，显示更详细的信息*-line-numbers        *//查看规则表时，显示在链中的序号*-V\|--version -h\|--help   [option]  --help     *//查看特定选项的帮助，如iptables -p icmp --help* --fragment -f               *//match second or further fragments only*--modprobe=<command>        *//try to insert modules using this command*--set-counters PKTS BYTES   *//set the counter during insert/append* |
| --------------- | ------------------------------------------------------------ |
|                 |                                                              |

**state  TCP链接状态**













| 12345 | NEW                 第一次握手，要起始一个连接（重设连接或将连接重导向） ESTABLISHED   数据包属于某个已经建立的连接。第二次和第三次握手   (ack=1)INVALID           数据包的连接编号（Session ID）无法辨识或编号不正确。如SYN=1 ACK=1 RST=1   RELATED          表示该封包是属于某个已经建立的连接，所建立的新连接。如有些服务使用两个相关的端口，如FTP，21和20端口一去一回，FTP数据传输(上传/下载)还会使用特殊的端口只允许NEW和ESTABLISHED进，只允许ESTABLISHED出可以阻止反弹式木马。 |
| ----- | ------------------------------------------------------------ |
|       |                                                              |

**使用示例：**













| 123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960 | iptables -F           *//删除iptables现有规则*iptables -L [-v[vv] -n]   *//查看iptables规则*iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT       *//在INPUT链尾添加一条规则*iptables -I INPUT 2 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT     *//在INPUT链中插入为第2条规则*iptables -D  INPUT 2      *//删除INPUT链中第2条规则*iptables -R INPUT 3 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT    *//替换修改第三条规则*iptables -P INPUT DROP    *//设置INPUT链的默认策略为DROP* *//允许远程主机进行SSH连接*iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT  *//允许本地主机进行SSH连接*iptables -A OUTPUT -o eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT iptables -A INTPUT -i eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT  *//允许HTTP请求*iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT  *//限制ping 192.168.146.3主机的数据包数，平均2/s个，最多不能超过3个*iptables -A INPUT -i eth0 -d 192.168.146.3 -p icmp --icmp-type 8 -m limit --limit 2/second --limit-burst 3 -j ACCEPT  *//限制SSH连接速率（默认策略是DROP）*iptables -I INPUT 1 -p tcp --dport 22 -d 192.168.146.3 -m state --state ESTABLISHED -j ACCEPT  iptables -I INPUT 2 -p tcp --dport 22 -d 192.168.146.3 -m limit --limit 2/minute --limit-burst 2 -m state --state NEW -j ACCEPT  *//防止syn攻击（限制syn的请求速度）*iptables -N syn-flood iptables -A INPUT -p tcp --syn -j syn-flood iptables -A syn-flood -m limit --limit 1/s --limit-burst 4 -j RETURN iptables -A syn-flood -j DROP  *//防止syn攻击（限制单个ip的最大syn连接数）*iptables –A INPUT –i eth0 –p tcp --syn -m connlimit --connlimit-above 15 -j DROP  iptables -I INPUT -p tcp -dport 22 -m connlimit --connlimit-above 3 -j DROP   *//利用recent模块抵御DOS攻击*iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH   *//单个IP最多连接3个会话*Iptables -I INPUT -p tcp --dport 22 -m state NEW -m recent --update --seconds 300 --hitcount 3 --name SSH -j DROP  *//只要是新的连接请求，就把它加入到SSH列表中。5分钟内你的尝试次数达到3次，就拒绝提供SSH列表中的这个IP服务。被限制5分钟后即可恢复访问。* iptables -I INPUT -p tcp --dport 80 -m connlimit --connlimit-above 30 -j DROP    *//防止单个IP访问量过大*iptables –A OUTPUT –m state --state NEW –j DROP  *//阻止反弹木马*iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/m -j ACCEPT   *//防止ping攻击* *//只允许自己ping别人，不允许别人ping自己*iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPTiptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT *//对于127.0.0.1比较特殊，我们需要明确定义它*iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPTiptables -A OUTPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT *//SNAT 基于原地址转换。许多内网用户通过一个外网 口上网的情况。将我们内网的地址转换为一个外网的IP，共用外网IP访问外网资源。*iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT --to-source 172.16.100.1 *//当外网地址不是固定的时候。将外网地址换成 MASQUERADE(动态伪装):它可以实现自动读取外网网卡获取的IP地址。*iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE *//DNAT 目标地址转换。目标地址转换要做在到达网卡之前进行转换,所以要做在PREROUTING这个位置上*iptables -t nat -A PREROUTING -d 192.168.10.18 -p tcp --dport 80 -j DNAT --to-destination |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

​                                                          烟台25岁美女手机做这个，1年存款吓呆父母！！             泰盛投资 · 鹓鶵                   





 			[ 				![img](https://g.csdnimg.cn/static/user-img/anonymous-User-img.png) 			](javascript:void(0);) 		


 			 			 			 		



 		

####  						防火墙（*firewalld*与iptables）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							防火墙是整个数据包进入主机前的第一道关卡。防火墙主要通过Netfilter与TCPwrappers两个机制来管理的。1）Netfilter：数据包过滤机制2）TCPWrappers：程序管理机制关于数... 						](https://blog.csdn.net/weixin_40658000/article/details/78708375) 						   							                博文                                   [来自：	 一涵的博客](https://blog.csdn.net/weixin_40658000)                 							               					

####  						Linux *Firewalld*用法及案例				

 						 						               阅读数  							1576 						
 	
 						[ 							官方文档RHELFIREWALLDFirewalld概述动态防火墙管理工具定义区域与接口安全等级运行时和永久配置项分离两层结构核心层处理配置和后端，如iptables、ip6tables、ebtabl... 						](https://blog.csdn.net/xiazichenxi/article/details/80169927) 						   							                博文                                   [来自：	 陈洋的博客](https://blog.csdn.net/xiazichenxi)                 							               					

####  						*firewalld*的基本规则				

 						 						               阅读数  							1646 						
 	
 						[ 							一、图形化管理火墙系统提供了图像化的配置工具firewall-config、system-config-firewall,提供命令行客户端firewall-cmd,用于配置firewalld永久性或非... 						](https://blog.csdn.net/hahaha_yan/article/details/78709549) 						   							                博文                                   [来自：	 hahaha_yan的博客](https://blog.csdn.net/hahaha_yan)                 							               					

<iframe src="https://kunpeng-sc.csdnimg.cn/#/preview/40?positionId=59" scrolling="no" width="100%" height="75px" frameborder="0"></iframe>
####  						Linux 下 *firewalld* 防火墙服务*设置*				

 						 						               阅读数  							953 						
 	
 						[ 							Linux下firewalld防火墙服务设置firewalld简述动态防火墙后台程序firewalld提供了一个动态管理的防火墙用以支持网络“zones”，以分配对一一个网络及其相关链接和界面一定程度... 						](https://blog.csdn.net/Buster_ZR/article/details/80604933) 						   							                博文                                   [来自：	 Buster_ZR的博客](https://blog.csdn.net/Buster_ZR)                 							               					

####  						CentOS 7 *firewalld*使用简介				

 						 						               阅读数  							4万+ 						
 	
 						[ 							学习apache安装的时候需要打开80端口，由于centos7版本以后默认使用firewalld后，网上关于iptables的设置方法已经不管用了，想着反正iptable也不会用，索性直接搬官方文档，... 						](https://blog.csdn.net/spxfzc/article/details/39645133) 						   							                博文                                   [来自：	 感知初心](https://blog.csdn.net/spxfzc)                 							               					

####  						*firewalld*				

 						 						               阅读数  							92 						
 	
 						[ 							RHEL中的防火墙种类1.iptables2.firewalld3.ip6tables4.ebtables这些软件本身并不具备防火墙功能，他们的作用都是在用户空间中管理和维护规则，只不过规则结构和使用... 						](https://blog.csdn.net/k_mmkkk/article/details/82802838) 						   							                博文                                   [来自：	 k_mmkkk的博客](https://blog.csdn.net/k_mmkkk)                 							               					

####  						CentOS7防火墙*firewalld*简单配置和使用				

 						 						               阅读数  							35 						
 	
 						[ 							   网上找了好多文章，关于CentOS7的防火墙配置和使用，都没有比较理想的说明firewalld的用法，还有一些网上摒弃centos7firewalld防火墙，使用旧版本的iptables的替代的... 						](https://blog.csdn.net/wanlic2008/article/details/84691548) 						   							                博文                                   [来自：	 wanlic2008的博客](https://blog.csdn.net/wanlic2008)                 							               					

####  						日常运维（五）：CentOS7 *firewalld*				

 						 						               阅读数  							4078 						
 	
 						[ 							主要内容：iptables规则备份和恢复firewalld的9个zonefirewalld关于zone的操作firewalld关于service的操作			1.iptables补充——规则备份和恢复保... 						](https://blog.csdn.net/qq_38157974/article/details/78405000) 						   							                博文                                   [来自：	 宁信1617](https://blog.csdn.net/qq_38157974)                 							               					

​                                                          本月烟台本地用户最新消息！眼袋松弛下垂？千万不要手术，用这...             华壬商贸 · 鹓鶵                   

####  						Linux 之 *firewalld*				

 						 						               阅读数  							443 						
 	
 						[ 							一、firewalld的认识1、firewalld提供了支持网络/防火墙区域(zone)定义网络链接以及接口安全等级的动态防火墙管理工具。2、firewalld将网卡分为不同的区域，这些区域的区别在于... 						](https://blog.csdn.net/JaneNancy/article/details/80600740) 						   							                博文                                   [来自：	 JaneNancy的博客](https://blog.csdn.net/JaneNancy)                 							               					

####  					centos7防火墙*firewalld*打不开			

 					06-20 			

​         \-                   问答         			

[![MRIVANDU](https://avatar.csdn.net/5/6/E/3_solaraceboy.jpg)](https://blog.csdn.net/solaraceboy)关注

[MRIVANDU](https://blog.csdn.net/solaraceboy)



 163篇文章

 排名:千里之外



[![衣舞晨风](https://avatar.csdn.net/7/7/C/3_xunzaosiyecao.jpg)](https://blog.csdn.net/xunzaosiyecao)关注

[衣舞晨风](https://blog.csdn.net/xunzaosiyecao)



 1129篇文章

 排名:147



[![letter_A](https://avatar.csdn.net/0/F/5/3_letter_a.jpg)](https://blog.csdn.net/letter_A)关注

[letter_A](https://blog.csdn.net/letter_A)



 77篇文章

 排名:千里之外



[![咆哮的橙子](https://avatar.csdn.net/8/0/3/3_qq_33376750.jpg)](https://blog.csdn.net/qq_33376750)关注

[咆哮的橙子](https://blog.csdn.net/qq_33376750)



 17篇文章

 排名:千里之外



####  						关于linux-centos7,防火墙 Failed to start *firewalld*.service: Unit *firewalld*.service is masked				

 						 						               阅读数  							1045 						
 	
 						[ 							卸载Firewall并安装iptables后重新安装回Firewall。安装Firewall启动时，提示Failedtostartfirewalld.service:Unitfirewalld.ser... 						](https://blog.csdn.net/qq_41139036/article/details/81126221) 						   							                博文                                   [来自：	 冀忠的博客](https://blog.csdn.net/qq_41139036)                 							               					

####  						*firewalld*&iptables				

 						 						               阅读数  							118 						
 	
 						[ 							一.Firewalld动态防火墙后台程序-firewalld，提供了一个动态管理的防火墙，用以支持网络“zones”，以分配对一个网络及其相关链接和界面一定程序的信任。它具备对ipv4和ipv6防火墙... 						](https://blog.csdn.net/sky__man/article/details/78700123) 						   							                博文                                   [来自：	 sky__man的博客](https://blog.csdn.net/sky__man)                 							               					

####  						细说*firewalld*和iptables				

 						 						               阅读数  							126 						
 	
 						[ 							转载自  http://blog.51cto.com/xjsunjie/1902993在RHEL7里有几种防火墙共存：firewalld、iptables、ebtables，默认是使用firewall... 						](https://blog.csdn.net/wz947324/article/details/80284239) 						   							                博文                                   [来自：	 会飞的鱼的博客](https://blog.csdn.net/wz947324)                 							               					

​                                                          周围人喜欢的！眼袋松弛下垂？千万不要手术，用这个在家...             华壬商贸 · 鹓鶵                   

####  						linux系统之网络防火墙（*firewalld*服务和iptables服务）				

 						 						               阅读数  							559 						
 	
 						[ 							linux系统之网络安全防火墙 						](https://blog.csdn.net/weixin_40378804/article/details/78698251) 						   							                博文                                   [来自：	 Mangke的博客](https://blog.csdn.net/weixin_40378804)                 							               					

####  						关闭CentOS7的*firewalld*并启用iptables操作				

 						 						               阅读数  							5070 						
 	
 						[ 							CentOS7发布也挺长时间了，但是因为与旧版本差异过大，一直使用的CentOS6，为了安全性以及技术的更新，总是要换成CentOS7的在CentOS7中，防火墙iptables被firewalld取... 						](https://blog.csdn.net/lqy461929569/article/details/74370396) 						   							                博文                                   [来自：	 Ray的博客](https://blog.csdn.net/lqy461929569)                 							               					

####  						iptables 与 *firewalld* 防火墙				

 						 						               阅读数  							28 						
 	
 						[ 							防火墙管理工具众所周知，相较于企业内网，外部的公网环境更加恶劣，罪恶丛生。在公网与企业内网之间充当保护屏障的防火墙，虽然有软件或硬件之分，但主要功能都是依据策略对穿越防火墙自身的流量进行过滤。防火墙策... 						](https://blog.csdn.net/santtde/article/details/85077096) 						   							                博文                                   [来自：	 santtde的博客](https://blog.csdn.net/santtde)                 							               					

####  						防火墙的规则表与规则链				

 						 						               阅读数  							446 						
 	
 						[ 							1、防火墙防火墙是根据配置文件/etc/sysconfig/iptables来控制本机的"出、入"的网络访问行为。Filter表：主要是跟进入linux本机的数据包有关，过滤数据包... 						](https://blog.csdn.net/weixin_42604344/article/details/81119977) 						   							                博文                                   [来自：	 weixin_42604344的博客](https://blog.csdn.net/weixin_42604344)                 							               					

####  						Ubuntu iptables详细教程-基本命令				

 						 						               阅读数  							4309 						
 	
 						[ 							Typing#sudoiptables-Llistsyourcurrentrulesiniptables.Ifyouhavejustsetupyourserver,youwillhavenorules... 						](https://blog.csdn.net/adparking/article/details/6947457) 						   							                博文                                   [来自：	 大鹏](https://blog.csdn.net/adparking)                 							               					

​                                                          每天用它泡着喝，排尽体内10年湿毒，健康又漂亮！神奇！             林凯 · 鹓鶵                   

####  						Linux-iptables命令				

 						 						               阅读数  							5113 						
 	
 						[ 							概述Linux-iptables命令Linux-SNAT和DNATnetfilter/iptables（简称为iptables）组成Linux平台下的包过滤防火墙，与大多数的Linux软件一样，这个包... 						](https://blog.csdn.net/yangshangwei/article/details/52772414) 						   							                博文                                   [来自：	 小工匠](https://blog.csdn.net/yangshangwei)                 							               					

####  						linux系统中查看己*设置*iptables规则				

 						 						               阅读数  							5万+ 						
 	
 						[ 							1、iptables-L查看filter表的iptables规则，包括所有的链。filter表包含INPUT、OUTPUT、FORWARD三个规则链。说明：-L是--list的简写，作用是列出规则。2... 						](https://blog.csdn.net/chengxuyuanyonghu/article/details/51897666) 						   							                博文                                   [来自：	 chengxuyuanyonghu的专栏](https://blog.csdn.net/chengxuyuanyonghu)                 							               					

####  						Linux运维学习笔记之三十二： 防火墙实战				

 						 						               阅读数  							332 						
 	
 						[ 							第四十三章防火墙实战一、Iptables基础概念1、一般使用情况（1）seLinux关闭（生产系统也是关闭的）（2）使用硬件ids（入侵检测）（3）iptables在生产环境中一般是内网关闭，外网打开... 						](https://blog.csdn.net/rumengjian/article/details/80451815) 						   							                博文                                   [来自：	 放飞的心灵－记录学习的点点滴滴](https://blog.csdn.net/rumengjian)                 							               					

####  						linux系统防火墙常用指令,以及指定ip的访问权限设定，*firewalld*的端口转接，地址伪装				

 						 						               阅读数  							128 						
 	
 						[ 							首先是防火墙的域，每种域支持不同的访问权限和服务：常用指令：   firewall-cmd--state  #查看防火墙状态   firewall-cmd--get-active-zones #查看防... 						](https://blog.csdn.net/letter_A/article/details/80602883) 						   							                博文                                   [来自：	 letter_A的博客](https://blog.csdn.net/letter_A)                 							               					

####  						centOS 7 下防火墙*firewalld*添加和开发端口				

 						 						               阅读数  							142 						
 	
 						[ 							1、firewalld的基本使用启动： systemctl start firewalld查看状态： systemctl status firewalld 停止： systemctl disable ... 						](https://blog.csdn.net/qq_33376750/article/details/78720818) 						   							                博文                                   [来自：	 不是每一次努力都会有收获，但是每一次收获都必须努力，这是一个不公平的不可逆转。](https://blog.csdn.net/qq_33376750)                 							               					

​                                                          每天用它泡着喝，排尽体内10年湿毒，健康又漂亮！神奇！             林凯 · 鹓鶵                   

####  						linux禁止开机启动防火墙*firewalld*.service				

 						 						               阅读数  							2879 						
 	
 						[ 							每次重启测试环境会发现外网都无法访问80端口，用systemctlstatusfirewalld.service检查防火墙，是开启的状态 要使firewall不开机启动，使用命令systemctldi... 						](https://blog.csdn.net/lileihappy/article/details/79591504) 						   							                博文                                   [来自：	 挨踢学霸](https://blog.csdn.net/lileihappy)                 							               					

####  						*Linux防火墙*的配置方法(*firewalld*服务)				

 						 						               阅读数  							1341 						
 	
 						[ 							红帽RHEL7系统已经用firewalld服务替代了iptables服务，新的防火墙管理命令firewall-cmd与图形化工具firewall-config。执行firewall-config命令即... 						](https://blog.csdn.net/u014242496/article/details/51658821) 						   							                博文                                   [来自：	 龙炎轻舞](https://blog.csdn.net/u014242496)                 							               					

####  						*linux防火墙*实现端口转发、端口映射及双向通路				

 						 						               阅读数  							2634 						
 	
 						[ 							iptables实现端口转发、端口映射及双向通路其实不难配置，看下文：允许数据包转发：#echo1>/proc/sys/net/ipv4/ip_forward 转发TCP8081到xx.xx.xx.x... 						](https://blog.csdn.net/meitesiluyuan/article/details/48791873) 						   							                博文                                   [来自：	 鲁元的博客](https://blog.csdn.net/meitesiluyuan)                 							               					

####  						*firewalld*服务				

 						 						               阅读数  							943 						
 	
 						[ 							firewalld服务在企业7以上的版本，，是一款类似于windows界面的可以图形化设置防火墙策略的工具。一.firewalld服务的安装与启用yuminstallfirewalld##安装fire... 						](https://blog.csdn.net/xixlxl/article/details/79416025) 						   							                博文                                   [来自：	 xixlxl的博客](https://blog.csdn.net/xixlxl)                 							               					

####  						拥抱*firewalld*，但也别忘了iptables——下篇（*firewalld*详解）				

 						 						               阅读数  							5171 						
 	
 						[ 							本文介绍了当前linux系统上官方权威且简单易用的包过滤防火墙软件——firewalld（替代了之前的iptables），重点解析其配置命令，通过分模块的清晰的系统学习，相信大家可以看懂大部分的fir... 						](https://blog.csdn.net/gg_18826075157/article/details/72834694) 						   							                博文                                   [来自：	 hyman.lu](https://blog.csdn.net/gg_18826075157)                 							               					

​                                                          传奇变态版！无VIP！无付费！装备不花一分钱！无敌神兽免费送             新数网络                   

####  						*Firewalld*				

 						 						               阅读数  							149 						
 	
 						[ 							RHEL中的防火墙种类1.iptables2.firewalld3.ip6tables4.ebtables系统中防火墙的结构：1.firewalldfirewalld不是防火墙，只是用来管理防火墙的一... 						](https://blog.csdn.net/weixin_40571637/article/details/78735825) 						   							                博文                                   [来自：	 weixin_40571637的博客](https://blog.csdn.net/weixin_40571637)                 							               					

####  						*Firewalld*详解				

 						 						               阅读数  							1395 						
 	
 						[ 							firewall概述动态防火墙后台程序firewalld提供了一个动态管理的防火墙,用以支持网络“zones”,以分配对一个网络及其相关链接和界面一定程度的信任。它具备对IPv4和IPv6防火墙设置的... 						](https://blog.csdn.net/tallercc/article/details/53079900) 						   							                博文                                   [来自：	 tallercc的博客](https://blog.csdn.net/tallercc)                 							               					

####  						linux系统中的防火墙（iptables与*firewalld*）——iptables				

 						 						               阅读数  							98 						
 	
 						[ 							iptables关闭firewalld打开iptables相关概念IPTABLES是与最新的3.5版本Linux内核集成的IP信息包过滤系统。如果Linux系统连接到因特网或LAN、服务器或连接LAN... 						](https://blog.csdn.net/gd0306/article/details/83868062) 						   							                博文                                   [来自：	 gd0306的博客](https://blog.csdn.net/gd0306)                 							               					

####  						linux系统中的防火墙（iptables与*firewalld*）——*firewalld*				

 						 						               阅读数  							71 						
 	
 						[ 							防火墙防火墙是整个数据包进入主机前的第一道关卡。防火墙主要通过Netfilter与TCPwrappers两个机制来管理的。1）Netfilter：数据包过滤机制2）TCPWrappers：程序管理机制... 						](https://blog.csdn.net/gd0306/article/details/83831768) 						   							                博文                                   [来自：	 gd0306的博客](https://blog.csdn.net/gd0306)                 							               					

####  						iptables与*firewalld*防火墙				

 						 						               阅读数  							100 						
 	
 						[ 							Linux防火墙：iptables与firewalld首先iptablesiptables基本概念四张表：表里有链(chain)filter:用来进行包过滤：INPUTOUTPUTFORWARDnat... 						](https://blog.csdn.net/weixin_42061232/article/details/81413771) 						   							                博文                                   [来自：	 weixin_42061232的博客](https://blog.csdn.net/weixin_42061232)                 							               					

​                                                          烟台25岁美女手机做这个，1年存款吓呆父母！！             泰盛投资 · 鹓鶵                   

####  						iptables/*firewalld*的常用操作				

 						 						               阅读数  							32 						
 	
 						[ 							iptablesfirewalld查看防火墙状态serviceiptablesstatussystemctlstatusfirewalld/firewall-cmd--state启动防火墙servic... 						](https://blog.csdn.net/junweicn/article/details/84101737) 						   							                博文                                   [来自：	 junweicn的博客](https://blog.csdn.net/junweicn)                 							               					

####  						iptables备份和恢复、*firewalld*的9个zone和操作				

 						 						               阅读数  							214 						
 	
 						[ 							七周五次课（12月1日）10.19iptables规则备份和恢复iptables-save>/tmp/iptab.txt#备份iptables-restore... 						](https://blog.csdn.net/lovektm/article/details/78691549) 						   							                博文                                   [来自：	 pcct的专栏](https://blog.csdn.net/lovektm)                 							               					

####  						Cento OS7防火墙*设置*之图形化配置				

 						 						               阅读数  							69 						
 	
 						[ 							现在我们来看下在图形化界面中是如何配置防火墙的打开配置工具看到如下界面，你可能马上就懵逼了，不知道这些东东是干啥用的。 什么是区域？网络区域定义了网络连接的可信等级。这是一个一对多的关系，这意味着一次... 						](https://blog.csdn.net/bewithme/article/details/84774690) 						   							                博文                                   [来自：	 bewithme的专栏](https://blog.csdn.net/bewithme)                 							               					

####  						linux   防火墙*firewalld*、selinux开启和关闭				

 						 						               阅读数  							427 						
 	
 						[ 							一、firewalld###查看防火墙状态systemctlstatusfirewalld ###临时开启防火墙systemctlstartfirewalld###临时停止防火墙systemctlst... 						](https://blog.csdn.net/qq_21840201/article/details/80930832) 						   							                博文                                   [来自：	 qq_21840201的博客](https://blog.csdn.net/qq_21840201)                 							               					

####  						Linux（RHEL7及CentOS7）最简单的*firewalld*防火墙操作流程				

 						 						               阅读数  							2787 						
 	
 						[ 							经常看到网上的一些文章，遇到防火墙就关闭，禁用，好low！从Redhat7或者CentOS7开始，系统默认防火墙已经变更为firewalld，本着存在即合理的原则，经过几天的摸索，总结了一个简单的防火... 						](https://blog.csdn.net/solaraceboy/article/details/78527522) 						   							                博文                                   [来自：	 耕耘实录](https://blog.csdn.net/solaraceboy)                 							               					

#### 道士十五狗全区横着走，快来和大哥一起玩传奇！



![img](http://recom-1252788780.cosbj.myqcloud.com/ad_material/鲁大师游戏3.jpg)

####  						Linux之*firewalld*防火墙策略优化				

 						 						               阅读数  							266 						
 	
 						[ 							firewalld域开启firewalldsystemctlstopiptables.servicesystemctldisableiptables.servicesystemctlstartfire... 						](https://blog.csdn.net/Ying_smile/article/details/80603346) 						   							                博文                                   [来自：	 Ying_smile的博客](https://blog.csdn.net/Ying_smile)                 							               					

####  						*firewalld*的配置				

 						 						               阅读数  							2495 						
 	
 						[ 							firewalld的配置 						](https://blog.csdn.net/a18829898663/article/details/72869923) 						   							                博文                                   [来自：	 a18829898663的博客](https://blog.csdn.net/a18829898663)                 							               					

####  						*firewalld*详解				

 						 						               阅读数  							159 						
 	
 						[ 							https://blog.csdn.net/gg_18826075157/article/details/72834694从CentOS7(RHEL7)开始，官方的标准防火墙设置软件从iptables... 						](https://blog.csdn.net/Michaelwubo/article/details/80998556) 						   							                博文                                   [来自：	 码农崛起](https://blog.csdn.net/Michaelwubo)                 							               					

####  						Linux关闭防火墙并*设置*开机启动/不启动				

 						 						               阅读数  							4611 						
 	
 						[ 							本文针对Centos6和7对于Centos6：查看防火墙：[root@CactiEZ~\]#serviceiptablesstatus关闭防火墙：[root@CactiEZ~]#serviceiptab... 						](https://blog.csdn.net/qq_41116956/article/details/82767418) 						   							                博文                                   [来自：	 傲娇的博客](https://blog.csdn.net/qq_41116956)                 							               					

####  						Linux系统下添加防火墙规则（添加IP白名单）				

 						 						               阅读数  							2773 						
 	
 						[ 							参考文档：1、linux防火墙iptables规则的查看、添加、删除和修改方法总结2、查看linux的iptables配置,都是什么意思各个参数？防火墙的作用：  可以通过设置ip白名单/黑名单的方式... 						](https://blog.csdn.net/qq_37837701/article/details/80578807) 						   							                博文                                   [来自：	 qq_37837701的博客](https://blog.csdn.net/qq_37837701)                 							               					

<iframe style="width: 100%; height: 60px; border: 0px none;" scrolling="no"></iframe>
####  						linux下关闭了防火墙，重新启动不了的情况				

 						 						               阅读数  							212 						
 	
 						[ 							问题描述：我用systemctlstopfirewalld命令关闭了防火墙后无法启动（报错unitismasked）解决方法：先解锁 命令 systemctlunmaskfirewalld，然后在执行... 						](https://blog.csdn.net/wsyh12345678/article/details/83720580) 						   							                博文                                   [来自：	 wsyh12345678的博客](https://blog.csdn.net/wsyh12345678)                 							               					

####  							*linux防火墙**设置*						

05-22

 							简单 好用 linux防火墙设置命令 linux防火墙设置命令 linux防火墙设置命令 linux防火墙设置命令 简单 好用					

下载

####  						*Linux防火墙*管理（*firewalld*）				

 						 						               阅读数  							22 						
 	
 						[ 							防火墙管理工具众所周知，相较于企业内网，外部的公网环境更加恶劣，罪恶丛生。在公网与企业内网之间充当保护屏障的防火墙，虽然有软件或硬件之分，但主要功能都是依据策略对穿越防火墙自身的流量进行过滤。防火墙策... 						](https://blog.csdn.net/weixin_43407305/article/details/85128895) 						   							                博文                                   [来自：	 weixin_43407305的博客](https://blog.csdn.net/weixin_43407305)                 							               					

####  						【Centos7】5分钟理解防火墙*firewalld*				

 						 						               阅读数  							1万+ 						
 	
 						[ 							Centos7中默认将原来的防火墙iptables升级为了firewalld，firewalld跟iptables比起来至少有两大好处：1、firewalld可以动态修改单条规则，而不需要像iptab... 						](https://blog.csdn.net/dream361/article/details/54022470) 						   							                博文                                   [来自：	 放心飞吧](https://blog.csdn.net/dream361)                 							               					

####  						*FirewallD*入门手册				

 						 						               阅读数  							896 						
 	
 						[ 							导读FirewallD是iptables的一个封装，可以让你更容易地管理iptables规则-它并不是iptables的替代品。虽然iptables命令仍可用于FirewallD，但建议使用Firew... 						](https://blog.csdn.net/linuxnews/article/details/55120144) 						   							                博文                                   [来自：	 Linux运维的博客](https://blog.csdn.net/linuxnews)                 							               					

#### 博洛尼每年3千业主的选择 27年高端装修品牌 北京业主专享

"博洛尼整体家装,纯德系施工工艺,质保10年;全屋空气环保,不达标全额退款;1价全含,全程0增项0延期;200位一线设计师,专注空间美学<预约看工地>"

![img](http://recom-1252788780.cosbj.myqcloud.com/ad_material/博洛尼.png)

####  						*Linux防火墙*（*firewalld*篇）				

 						 						               阅读数  							74 						
 	
 						[ 							firewalld（centos7中的防火墙）是iptables的前端控制器(iptables的封装)，用于实现持久的网络流量规则。它提供命令行和图形界面，在大多数Linux发行版的仓库中都有。与直接... 						](https://blog.csdn.net/cxs123678/article/details/79966939) 						   							                博文                                   [来自：	 cxs123678的博客](https://blog.csdn.net/cxs123678)                 							               					

####  						*linux防火墙*管理——*firewalld*				

 						 						               阅读数  							10 						
 	
 						[ 							在linux中，firewalld并不具备防火墙功能，它的作用是管理和维护规则。firewalld的基础设定systemctlstartfirewalld			##开启systemctlenabled... 						](https://blog.csdn.net/qq_41961805/article/details/87911513) 						   							                博文                                   [来自：	 qq_41961805的博客](https://blog.csdn.net/qq_41961805)                 							               					

####  						CTF/CTF练习平台-flag在index里【php://filter的利用】				

 						 						               阅读数  							9382 						
 	
 						[ 							原题内容：  http://120.24.86.145:8005/post/    Mark一下这道题，前前后后弄了两个多小时，翻了一下别的博主的wp感觉还是讲的太粗了，这里总结下自己的理解：    ... 						](https://blog.csdn.net/wy_97/article/details/77431111) 						   							                博文                                   [来自：	 Sp4rkW的博客](https://blog.csdn.net/wy_97)                 							               					

####  						关于树的几个ensemble模型的比较（GBDT、xgBoost、lightGBM、RF）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							决策树的Boosting方法比较 原始的Boost算法是在算法开始的时候，为每一个样本赋上一个权重值，初始的时候，大家都是一样重要的。在每一步训练中得到的模型，会使得数据点的估计有对有错，我们就在每一... 						](https://blog.csdn.net/xwd18280820053/article/details/68927422) 						   							                博文                                   [来自：	 AI_盲的博客](https://blog.csdn.net/xwd18280820053)                 							               					

####  						【小程序】微信小程序开发实践				

 						 						               阅读数  							23万+ 						
 	
 						[ 							帐号相关流程注册范围 企业 政府 媒体 其他组织换句话讲就是不让个人开发者注册。 :)填写企业信息不能使用和之前的公众号账户相同的邮箱,也就是说小程序是和微信公众号一个层级的。填写公司机构信息,对公账... 						](https://blog.csdn.net/diandianxiyu/article/details/53068012) 						   							                博文                                   [来自：	 小雨同学的技术博客](https://blog.csdn.net/diandianxiyu)                 							               					

####  						DM368开发 -- 编码并实时播放				

 						 						               阅读数  							3730 						
 	
 						[ 							最近正好又用到 DM368 开发板，就将之前做的编解码的项目总结一下。话说一年多没碰，之前做的笔记全忘记是个什么鬼了。还好整理了一下出图像了。不过再看看做的这个东西，真是够渣的，只能作为参考了。项目效... 						](https://blog.csdn.net/qq_29350001/article/details/77941902) 						   							                博文                                   [来自：	 不积跬步，无以至千里](https://blog.csdn.net/qq_29350001)                 							               					

####  						【STM库应用】stm32 之 TIM （详解一 通用定时器）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							STM32的TIM一般有高级定时器TIM1，(TIM8只有在互联性产品有)，普通定时器TIM2，TIM3，TIM4，(TIM5，TIM6，TIM7有点设备中没有)；今天就只介绍普通定时器，因为高级定时... 						](https://blog.csdn.net/ieczw/article/details/17188865) 						   							                博文                                   [来自：	 ieczw的专栏](https://blog.csdn.net/ieczw)                 							               					

####  						servlet+jsp实现过滤器，防止用户未登录访问				

 						 						               阅读数  							2万+ 						
 	
 						[ 							我们可能经常会用到这一功能，比如有时，我们不希望用户没有进行登录访问后台的操作页面，而且这样的非法访问会让系统极为的不安全，所以我们常常需要进行登录才授权访问其它页面，否则只会出现登录页面，当然我的思... 						](https://blog.csdn.net/lsx991947534/article/details/45499205) 						   							                博文                                   [来自：	 沉默的鲨鱼的专栏](https://blog.csdn.net/lsx991947534)                 							               					

####  						通俗理解条件熵				

 						 						               阅读数  							2万+ 						
 	
 						[ 							1  信息熵以及引出条件熵     我们首先知道信息熵是考虑该随机变量的所有可能取值，即所有可能发生事件所带来的信息量的期望。公式如下：     我们的条件熵的定义是：定义为X给定条件下，Y的条件概率... 						](https://blog.csdn.net/xwd18280820053/article/details/70739368) 						   							                博文                                   [来自：	 AI_盲的博客](https://blog.csdn.net/xwd18280820053)                 							               					

####  						将Excel文件导入数据库（POI+Excel+MySQL+jsp页面导入）第一次优化				

 						 						               阅读数  							2万+ 						
 	
 						[ 							本篇文章是根据我的上篇博客，给出的改进版，由于时间有限，仅做了一个简单的优化。相关文章：将excel导入数据库2018年4月1日，新增下载地址链接：点击打开源码下载地址十分抱歉，这个链接地址没有在这篇... 						](https://blog.csdn.net/meng564764406/article/details/52444644) 						   							                博文                                   [来自：	 Lynn_Blog](https://blog.csdn.net/meng564764406)                 							               					

####  						jquery/js实现一个网页同时调用多个倒计时(最新的)				

 						 						               阅读数  							41万+ 						
 	
 						[ 							jquery/js实现一个网页同时调用多个倒计时(最新的)  最近需要网页添加多个倒计时. 查阅网络,基本上都是千遍一律的不好用. 自己按需写了个.希望对大家有用. 有用请赞一个哦!    //js ... 						](https://blog.csdn.net/wuchengzeng/article/details/50037611) 						   							                博文                                   [来自：	 Websites](https://blog.csdn.net/wuchengzeng)                 							               					

####  						ThreadLocal的设计理念与作用				

 						 						               阅读数  							4万+ 						
 	
 						[ 							Java中的ThreadLocal类允许我们创建只能被同一个线程读写的变量。因此，如果一段代码含有一个ThreadLocal变量的引用，即使两个线程同时执行这段代码，它们也无法访问到对方的Thread... 						](https://blog.csdn.net/u011860731/article/details/48733073) 						   							                博文                                   [来自：	 u011860731的专栏](https://blog.csdn.net/u011860731)                 							               					



C

​              

- [首页](https://www.csdn.net/)
- [博客](https://blog.csdn.net/)
- [学院](https://edu.csdn.net)
- [下载](https://download.csdn.net)
- [图文课](https://gitchat.csdn.net/?utm_source=csdn_toolbar)
- [论坛](https://bbs.csdn.net)
- [APP](https://www.csdn.net/app/)                          
- [问答](https://ask.csdn.net)
- [商城](https://mall.csdn.net)
- [VIP会员](https:							

 									

一、图形化管理火墙

系统提供了图像化的配置工具 firewall-config 、 system-config-firewall, 提供命令行客户端 firewall-cmd, 用于配置 firewalld 永久性或非永久性运行时间的改变。

1、下载图形管理命令

yum install firewall-config

2、使用命令调出图形

firewall-config

3、在图形处进行选择，另一方进行监控firewalld的变化

watch -n 1 'firewall-cmd --list-all'

![img](https://img-blog.csdn.net/20171204144307640?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

图形化的[界面](https://www.baidu.com/s?wd=%E7%95%8C%E9%9D%A2&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)

![img](https://img-blog.csdn.net/20171204144403203?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

若为runtime模式仅选中即可，不用重启火墙，但若选择permanent，要重启火墙才能使策略生效。

二、firewalld的配置存储

/etc/firewalld

进行所有的命令，均是改变此中文件/etc/firewalld/zones中的文件的内容，也可在文件中直接改动，改完后需要进行重启服务。

![img](https://img-blog.csdn.net/20171204151747253?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)![img](https://img-blog.csdn.net/20171204151751753?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

/usr/lib/firewalld中的各种xml文件中

![img](https://img-blog.csdn.net/20171204144954355?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)![img](https://img-blog.csdn.net/20171204144958849?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

三、firewalld的基本使用命令

启用命令

systemctl start firewalld              ##开启防火墙

systemctl enable firewalld          ##开机自动开启防火墙

systemctl stop firewalld              ##关闭防火墙

systemctl disable firewalld         ##开机不自动开启防火墙

配置火墙命令

firewall-cmd --state                     ##火墙状态，开启或者停止

![img](https://img-blog.csdn.net/20171204145549108?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --get-active-zones   ##正在活跃的火墙域

![img](https://img-blog.csdn.net/20171204145730587?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --get-default-zone     ##火墙中默认的域

![img](https://img-blog.csdn.net/20171204145918250?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --get-zones              ##火墙中所有存在的域

![img](https://img-blog.csdn.net/20171204150102082?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --zone=public --list-all   ##查看public域中的所有信息

![img](https://img-blog.csdn.net/20171204150219421?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --get-services             ##火墙中所有可以提供的服务

![img](https://img-blog.csdn.net/20171204150339882?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

此中所有列出的服务的名字均可以进行自行改变，在/usr/lib/firewalld/service中有所有的服务列表，将其中的名字进行改变，但仍然以xml进行结尾，即可进行改变名字，但通常不这么做。

![img](https://img-blog.csdn.net/20171204151357466?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --list-all-zones        ##列出火墙中的所有域及所有信息

![img](https://img-blog.csdn.net/20171204150726570?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

firewall-cmd --set-default-zone=dmz       ##将dmz域设置为默认的域

![img](https://img-blog.csdn.net/20171204150859361?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

[root@localhost zones]# firewall-cmd --add-service=http                           ##给默认域中添加服务http
 [root@localhost zones]# firewall-cmd --remove-service=http                     ##删除默认域中的服务http

![img](https://img-blog.csdn.net/20171204152158581?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

测试：

![img](https://img-blog.csdn.net/20171204152657289?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

[root@localhost zones]# firewall-cmd --add-port=8080/tcp                     ##给默认域中添加tcp端口8080
 [root@localhost zones]# firewall-cmd --remove-port=8080/tcp               ##删除默认域中的8080端口
![img](https://img-blog.csdn.net/20171204152448707?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
 测试：将httpd服务的端口改为8080，并在火墙中加入该端口

![img](https://img-blog.csdn.net/20171204152838339?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
![img](https://img-blog.csdn.net/20171204153219740?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

此时，火墙的默认域为public，且没有添加http服务

[root@localhost zones]# firewall-cmd --add-source=172.25.254.73 --zone=trusted

[root@localhost zones]# firewall-cmd --remove-source=172.25.254.73 --zone=trusted
 \##此ip在访问时可以进行火墙中的额任何服务，走的是trusted这个域

![img](https://img-blog.csdn.net/20171204153700246?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)



测试：

![img](https://img-blog.csdn.net/20171204153955916?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

此时server虚拟机有两块网卡，可以进行设置，将eth0走public域，eth1走bmz域

此间有一个问题，必须将两块网卡的ip设置为在不同的网段内，经过实验，若将两块网卡放在同一个网段内的话，会出现两块网卡都走的是默认的域，没有实验效果。

![img](https://img-blog.csdn.net/20171204154843108?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

[root@localhost zones]# firewall-cmd --change-interface=eth1 --zone=dmz
![img](https://img-blog.csdn.net/20171204154946033?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

测试：

172.25.71.1    走的是dmz域

172.25.254.173  走的是public域，我在其中加入了http服务

![img](https://img-blog.csdn.net/20171204155324508?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

![img](https://img-blog.csdn.net/20171204155445403?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

通过 firewall-cmd 工具 , 可以使用 --direct 选项在运行时间里增加或者移除链。

[root@localhost zones]# firewall-cmd --direct --add-rule ipv4 filter INPUT 1 -s 172.25.254.73 -p tcp --dport 80 -j REJECT

表示在filter表中第一行加入 http服务（80端口）对于172.25.254.73不开放

![img](https://img-blog.csdn.net/20171204162055342?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

测试：

![img](https://img-blog.csdn.net/20171204161129472?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

语句成功后：

![img](https://img-blog.csdn.net/20171204161136543?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

\##使用--direct 语句使得172.25.254.73主机不能实现ftp服务的连接

[root@localhost zones]# firewall-cmd --direct --add-rule ipv4 filter INPUT 1 ! -s 172.25.254.73 -p tcp --dport 21 -j REJECT

![img](https://img-blog.csdn.net/20171204163034975?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

测试：

172.25.254.73主机：

![img](https://img-blog.csdn.net/20171204163116850?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

别的主机：

![img](https://img-blog.csdn.net/20171204163155236?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

地址伪装：

将172.25.71.2主机使用sshd访问172.25.254.73主机时访问的是173主机

思想：

1、需要一个双网卡的主机充当路由器，此路由器必须与172.25.71.2和172.25.254.73可以进行通信



2、172.25.71.2主机将可以与他进行通信的路由器的端口设置成网关

路由器：

[root@localhost zones]# firewall-cmd --add-masquerade 
 [root@localhost zones]# firewall-cmd --add-forward-port=port=22:proto=tcp:toport=22:toaddr=172.25.254.173
![img](https://img-blog.csdn.net/20171204170618355?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
 测试：

![img](https://img-blog.csdn.net/20171204171003459?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGFoYWhhX3lhbg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)









​                                                          烟台25岁美女手机做这个，1年存款吓呆父母！！             泰盛投资 · 鹓鶵                   





 			[ 				![img](https://g.csdnimg.cn/static/user-img/anonymous-User-img.png) 			](javascript:void(0);) 		


 			 			 			 		



 		

####  						Linux *Firewalld*用法及案例				

 						 						               阅读数  							1576 						
 	
 						[ 							官方文档RHELFIREWALLDFirewalld概述动态防火墙管理工具定义区域与接口安全等级运行时和永久配置项分离两层结构核心层处理配置和后端，如iptables、ip6tables、ebtabl... 						](https://blog.csdn.net/xiazichenxi/article/details/80169927) 						   							                博文                                   [来自：	 陈洋的博客](https://blog.csdn.net/xiazichenxi)                 							               					

####  						Linux防火墙设置 *FirewallD*				

 						 						               阅读数  							581 						
 	
 						[ 							entos从7.0开始将原先的防火墙iptables换成了FirewallD。FirewallD支持IPv4,IPv6防火墙设置以及以太网桥接，并且拥有运行时配置和永久配置选项，被称作动态管理防火墙，... 						](https://blog.csdn.net/sforiz/article/details/80900957) 						   							                博文                                   [来自：	 远方](https://blog.csdn.net/sforiz)                 							               					

####  						*firewalld*				

 						 						               阅读数  							92 						
 	
 						[ 							RHEL中的防火墙种类1.iptables2.firewalld3.ip6tables4.ebtables这些软件本身并不具备防火墙功能，他们的作用都是在用户空间中管理和维护规则，只不过规则结构和使用... 						](https://blog.csdn.net/k_mmkkk/article/details/82802838) 						   							                博文                                   [来自：	 k_mmkkk的博客](https://blog.csdn.net/k_mmkkk)                 							               					

​                                                          年轻人注意啦！眼袋松弛下垂？千万不要手术，用这个在家...             华壬商贸 · 鹓鶵                   

####  						防火墙（*firewalld*与iptables）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							防火墙是整个数据包进入主机前的第一道关卡。防火墙主要通过Netfilter与TCPwrappers两个机制来管理的。1）Netfilter：数据包过滤机制2）TCPWrappers：程序管理机制关于数... 						](https://blog.csdn.net/weixin_40658000/article/details/78708375) 						   							                博文                                   [来自：	 一涵的博客](https://blog.csdn.net/weixin_40658000)                 							               					

####  						CentOS7防火墙*firewalld*简单配置和使用				

 						 						               阅读数  							35 						
 	
 						[ 							   网上找了好多文章，关于CentOS7的防火墙配置和使用，都没有比较理想的说明firewalld的用法，还有一些网上摒弃centos7firewalld防火墙，使用旧版本的iptables的替代的... 						](https://blog.csdn.net/wanlic2008/article/details/84691548) 						   							                博文                                   [来自：	 wanlic2008的博客](https://blog.csdn.net/wanlic2008)                 							               					

####  						CentOS 7 *firewalld*使用简介				

 						 						               阅读数  							4万+ 						
 	
 						[ 							学习apache安装的时候需要打开80端口，由于centos7版本以后默认使用firewalld后，网上关于iptables的设置方法已经不管用了，想着反正iptable也不会用，索性直接搬官方文档，... 						](https://blog.csdn.net/spxfzc/article/details/39645133) 						   							                博文                                   [来自：	 感知初心](https://blog.csdn.net/spxfzc)                 							               					

####  						日常运维（五）：CentOS7 *firewalld*				

 						 						               阅读数  							4078 						
 	
 						[ 							主要内容：iptables规则备份和恢复firewalld的9个zonefirewalld关于zone的操作firewalld关于service的操作			1.iptables补充——规则备份和恢复保... 						](https://blog.csdn.net/qq_38157974/article/details/78405000) 						   							                博文                                   [来自：	 宁信1617](https://blog.csdn.net/qq_38157974)                 							               					

####  						Linux 之 *firewalld*				

 						 						               阅读数  							443 						
 	
 						[ 							一、firewalld的认识1、firewalld提供了支持网络/防火墙区域(zone)定义网络链接以及接口安全等级的动态防火墙管理工具。2、firewalld将网卡分为不同的区域，这些区域的区别在于... 						](https://blog.csdn.net/JaneNancy/article/details/80600740) 						   							                博文                                   [来自：	 JaneNancy的博客](https://blog.csdn.net/JaneNancy)                 							               					

​                                                          眼袋松弛下垂？千万不要手术，用这个在家2分钟就能消除眼袋！             华壬商贸 · 鹓鶵                   

####  						*firewalld*服务				

 						 						               阅读数  							943 						
 	
 						[ 							firewalld服务在企业7以上的版本，，是一款类似于windows界面的可以图形化设置防火墙策略的工具。一.firewalld服务的安装与启用yuminstallfirewalld##安装fire... 						](https://blog.csdn.net/xixlxl/article/details/79416025) 						   							                博文                                   [来自：	 xixlxl的博客](https://blog.csdn.net/xixlxl)                 							               					

####  						2-4端口\富*规则*firewall				

 						 						               阅读数  							1330 						
 	
 						[ 							firewall域firewall将所有传入流量划分区域，每个区域都有自己一套规则；1、若传入包的源地址与区域规则设置相同，则包将通过该区域进行路由；2、如果包的传入接口和区域过滤器设置匹配，则使用该... 						](https://blog.csdn.net/jmkmlm123456/article/details/77131075) 						   							                博文                                   [来自：	 郝大侠的博客](https://blog.csdn.net/jmkmlm123456)                 							               					

[![MRIVANDU](https://avatar.csdn.net/5/6/E/3_solaraceboy.jpg)](https://blog.csdn.net/solaraceboy)关注

[MRIVANDU](https://blog.csdn.net/solaraceboy)



 163篇文章

 排名:千里之外



[![二进制-程序猿](https://avatar.csdn.net/D/9/7/3_wylfengyujiancheng.jpg)](https://blog.csdn.net/wylfengyujiancheng)关注

[二进制-程序猿](https://blog.csdn.net/wylfengyujiancheng)



 162篇文章

 排名:6000+



[![moxiaomomo](https://avatar.csdn.net/8/D/C/3_moxiaomomo.jpg)](https://blog.csdn.net/moxiaomomo)关注

[moxiaomomo](https://blog.csdn.net/moxiaomomo)



 443篇文章

 排名:568



[![_houxr](https://avatar.csdn.net/3/4/B/3_houxuerong.jpg)](https://blog.csdn.net/houxuerong)关注

[_houxr](https://blog.csdn.net/houxuerong)



 69篇文章

 排名:千里之外



####  						自己装服务器之防火墙之停止*firewalld*以及开放端口				

 						 						               阅读数  							1829 						
 	
 						[ 							在服务器上安装了tomcat跟redis，启动后发现都访问不了，排除了网络问题后，最终把问题定位在了防火墙上停止防火墙的服务然后查询了下原因：centos从7开始默认用的是firewalld，这个是基... 						](https://blog.csdn.net/skymouse2002/article/details/54616838) 						   							                博文                                   [来自：	 skymouse2002的专栏](https://blog.csdn.net/skymouse2002)                 							               					

####  						从一个错误映射到centos7 *firewalld* 防火墙的使用				

 						 						               阅读数  							5401 						
 	
 						[ 							错误提示如下：FirewallDisnotrunning是你的防火墙还没开。可以执行systemctlstartfirewalld开启防火墙。相关命令CentOS7上systemctl的用法http:... 						](https://blog.csdn.net/u011192409/article/details/51627164) 						   							                博文                                   [来自：	 不积跬步无以至千里](https://blog.csdn.net/u011192409)                 							               					

####  						linux 使用*firewalld*添加开放端口				

 						 						               阅读数  							3852 						
 	
 						[ 							博主使用的Redhat本身没有iptables服务，也不能联网安装，因此，只能使用firewalld添加开放端口，以下是一些最基本的关于firewalld的命令：启动：systemctlstartfi... 						](https://blog.csdn.net/death05/article/details/79122220) 						   							                博文                                   [来自：	 death05的博客](https://blog.csdn.net/death05)                 							               					

​                                                          每天用它泡着喝，排尽体内10年湿毒，健康又漂亮！神奇！             林凯 · 鹓鶵                   

####  						CentOS 7 为*firewalld*添加开放端口及相关资料				

 						 						               阅读数  							3057 						
 	
 						[ 							转载自：CentOS7为firewalld添加开放端口及相关资料============================================1、运行、停止、禁用firewalld启动：#s... 						](https://blog.csdn.net/JeremyYu66/article/details/72809701) 						   							                博文                                   [来自：	 JeremyYu的博客](https://blog.csdn.net/JeremyYu66)                 							               					

####  						*firewalld*&iptables				

 						 						               阅读数  							118 						
 	
 						[ 							一.Firewalld动态防火墙后台程序-firewalld，提供了一个动态管理的防火墙，用以支持网络“zones”，以分配对一个网络及其相关链接和界面一定程序的信任。它具备对ipv4和ipv6防火墙... 						](https://blog.csdn.net/sky__man/article/details/78700123) 						   							                博文                                   [来自：	 sky__man的博客](https://blog.csdn.net/sky__man)                 							               					

####  						细说*firewalld*和iptables				

 						 						               阅读数  							126 						
 	
 						[ 							转载自  http://blog.51cto.com/xjsunjie/1902993在RHEL7里有几种防火墙共存：firewalld、iptables、ebtables，默认是使用firewall... 						](https://blog.csdn.net/wz947324/article/details/80284239) 						   							                博文                                   [来自：	 会飞的鱼的博客](https://blog.csdn.net/wz947324)                 							               					

####  						linux系统之网络防火墙（*firewalld*服务和iptables服务）				

 						 						               阅读数  							559 						
 	
 						[ 							linux系统之网络安全防火墙 						](https://blog.csdn.net/weixin_40378804/article/details/78698251) 						   							                博文                                   [来自：	 Mangke的博客](https://blog.csdn.net/weixin_40378804)                 							               					

####  						关闭CentOS7的*firewalld*并启用iptables操作				

 						 						               阅读数  							5070 						
 	
 						[ 							CentOS7发布也挺长时间了，但是因为与旧版本差异过大，一直使用的CentOS6，为了安全性以及技术的更新，总是要换成CentOS7的在CentOS7中，防火墙iptables被firewalld取... 						](https://blog.csdn.net/lqy461929569/article/details/74370396) 						   							                博文                                   [来自：	 Ray的博客](https://blog.csdn.net/lqy461929569)                 							               					

​                                                          每天用它泡着喝，排尽体内10年湿毒，健康又漂亮！神奇！             林凯 · 鹓鶵                   

####  						iptables 与 *firewalld* 防火墙				

 						 						               阅读数  							28 						
 	
 						[ 							防火墙管理工具众所周知，相较于企业内网，外部的公网环境更加恶劣，罪恶丛生。在公网与企业内网之间充当保护屏障的防火墙，虽然有软件或硬件之分，但主要功能都是依据策略对穿越防火墙自身的流量进行过滤。防火墙策... 						](https://blog.csdn.net/santtde/article/details/85077096) 						   							                博文                                   [来自：	 santtde的博客](https://blog.csdn.net/santtde)                 							               					

####  						Centos7防火墙*firewalld**基本*配置与端口转发				

 						 						               阅读数  							412 						
 	
 						[ 							1.firewalld基本介绍    Centos7开始已经放弃iptables，转而使用firewalld。从本质意义上讲，iptables和firewalld是防火墙软件，其实现方式都是调用内核N... 						](https://blog.csdn.net/teisite/article/details/84999582) 						   							                博文                                   [来自：	 忒斯特的博客](https://blog.csdn.net/teisite)                 							               					

####  						*firewalld*的配置				

 						 						               阅读数  							2495 						
 	
 						[ 							firewalld的配置 						](https://blog.csdn.net/a18829898663/article/details/72869923) 						   							                博文                                   [来自：	 a18829898663的博客](https://blog.csdn.net/a18829898663)                 							               					

####  						拥抱*firewalld*，但也别忘了iptables——下篇（*firewalld*详解）				

 						 						               阅读数  							5171 						
 	
 						[ 							本文介绍了当前linux系统上官方权威且简单易用的包过滤防火墙软件——firewalld（替代了之前的iptables），重点解析其配置命令，通过分模块的清晰的系统学习，相信大家可以看懂大部分的fir... 						](https://blog.csdn.net/gg_18826075157/article/details/72834694) 						   							                博文                                   [来自：	 hyman.lu](https://blog.csdn.net/gg_18826075157)                 							               					

####  						【Centos7】5分钟理解防火墙*firewalld*				

 						 						               阅读数  							1万+ 						
 	
 						[ 							Centos7中默认将原来的防火墙iptables升级为了firewalld，firewalld跟iptables比起来至少有两大好处：1、firewalld可以动态修改单条规则，而不需要像iptab... 						](https://blog.csdn.net/dream361/article/details/54022470) 						   							                博文                                   [来自：	 放心飞吧](https://blog.csdn.net/dream361)                 							               					

​                                                          烟台25岁美女手机做这个，1年存款吓呆父母！！             泰盛投资 · 鹓鶵                   

####  						Centos7 & 之*fir	

下载

####  						*firewalld*命令参数详解				

 						 						               阅读数  							1021 						
 	
 						[ 							firewall-cmd命令是Firewalld动态防火墙管理器服务的命令行终端。它的参数一般都是以“长格式”来执行的，但同学们也不用太过于担心，因为红帽RHEL7系统非常酷的支持了部分命令的        							               					

####  						*Firewalld*				

 						 						               阅读数  							149 						
 	
 						[ 							RHEL中的防火墙种类1.iptables2.firewalld3.ip6tables4.ebtables系统中防火墙的结构：1.firewalldfirewalld不是防火墙，只是用来管理防火墙的一... 						](https://blog.csdn.net/weixin_40571637/article/details/78735825) 						   							                博文                                   [来自：	 weixin_40571637的博客](https://blog.csdn.net/weixin_40571637)                 							               					

####  						*Firewalld*详解				

 						 						               阅读数  							1395 						
 	
 						[ 							firewall概述动态防火墙后台程序firewalld提供了一个动态管理的防火墙,用以支持网络“zones”,以分配对一个网络及其相关链接和界面一定程度的信任。它具备对IPv4和IPv6防火墙设置的... 						](https://blog.csdn.net/tallercc/article/details/53079900) 						   							                博文                                   [来自：	 tallercc的博客](https://blog.csdn.net/tallercc)                 							               					

####  						CentOS7 Firewall防火墙配置用法详解				

 						 						               阅读数  							5万+ 						
 	
 						[ 							entos7中防火墙是一个非常的强大的功能了，但对于centos7中在防火墙中进行了升级了，下面我们一起来详细的看看关于centos7中防火墙使用方法。FirewallD提供了支持网络/防火墙区域(z... 						](https://blog.csdn.net/steveguoshao/article/details/45999645) 						   							                博文                                   [来自：	 steveguoshao的专栏](https://blog.csdn.net/steveguoshao)                 							               					

####  						RHEL7中防火墙*firewalld*基础使用配置				

 						 						               阅读数  							9499 						
 	
 						[ 							RHEL7中防火墙firewalld基础使用配置 						](https://blog.csdn.net/junjunjiao/article/details/50809304) 						   							                博文                                   [来自：	 Mainux的专栏](https://blog.csdn.net/junjunjiao)                 							               					

​                                                          身体湿气重？不拔罐不花冤枉钱，简单1招湿气就消除了，特管用！             罗谦 · 鹓鶵                   

####  						CentOS7一键增加删除防火墙端口				

 						 						               阅读数  							1万+ 						
 	
 						[ 							简介:本文介绍CentOS7上安装shadowsocks后，关于防火墙的处理。CentOS7上防火墙变成了firewalld,而非iptables，所以操作上也不太一样。尤其是安装完shadowsoc... 						](https://blog.csdn.net/yanzi1225627/article/details/51470962) 						   							                博文                                   [来自：	 yanzi1225627的专栏](https://blog.csdn.net/yanzi1225627)                 							               					

####  						CentOS7下*firewalld*使用				

 						 						               阅读数  							2527 						
 	
 						[ 							CentOS7默认的防火墙使用的是firewalld(http://www.firewalld.org/)，其相关的使用方法如下：1.firewalld的启动与停止停止：启动：查看运行状态：或2.fi... 						](https://blog.csdn.net/rossisy/article/details/61423262) 						   							                博文                                   [来自：	 rossisy的博客](https://blog.csdn.net/rossisy)                 							               					

####  						linux系统中的防火墙（iptables与*firewalld*）——iptables				

 						 						               阅读数  							98 						
 	
 						[ 							iptables关闭firewalld打开iptables相关概念IPTABLES是与最新的3.5版本Linux内核集成的IP信息包过滤系统。如果Linux系统连接到因特网或LAN、服务器或连接LAN... 						](https://blog.csdn.net/gd0306/article/details/83868062) 						   							                博文                                   [来自：	 gd0306的博客](https://blog.csdn.net/gd0306)                 							               					

####  						linux系统中的防火墙（iptables与*firewalld*）——*firewalld*				

 						 						               阅读数  							71 						
 	
 						[ 							防火墙防火墙是整个数据包进入主机前的第一道关卡。防火墙主要通过Netfilter与TCPwrappers两个机制来管理的。1）Netfilter：数据包过滤机制2）TCPWrappers：程序管理机制... 						](https://blog.csdn.net/gd0306/article/details/83831768) 						   							                博文                                   [来自：	 gd0306的博客](https://blog.csdn.net/gd0306)                 							               					

####  						iptables与*firewalld*防火墙				

 						 						               阅读数  							100 						
 	
 						[ 							Linux防火墙：iptables与firewalld首先iptablesiptables基本概念四张表：表里有链(chain)filter:用来进行包过滤：INPUTOUTPUTFORWARDnat... 						](https://blog.csdn.net/weixin_42061232/article/details/81413771) 						   							                博文                                   [来自：	 weixin_42061232的博客](https://blog.csdn.net/weixin_42061232)                 							               					

#### 道士十五狗全区横着走，快来和大哥一起玩传奇！



![img](http://recom-1252788780.cosbj.myqcloud.com/ad_material/鲁大师游戏2.jpg)

####  						linux中*firewalld*与iptables的配置				

 						 						               阅读数  							177 						
 	
 						[ 							firewall-cmd --state 查看状态   firewall-cmd  --get-active-zones  查看活动的域  firewall-cmd  --get-zones 查看所有... 						](https://blog.csdn.net/iaMay_____/article/details/80685351) 						   							                博文                                   [来自：	 iaMay_____的博客](https://blog.csdn.net/iaMay_____)                 							               					

####  						iptables/*firewalld*的常用操作				

 						 						               阅读数  							32 						
 	
 						[ 							iptablesfirewalld查看防火墙状态serviceiptablesstatussystemctlstatusfirewalld/firewall-cmd--state启动防火墙servic... 						](https://blog.csdn.net/junweicn/article/details/84101737) 						   							                博文                                   [来自：	 junweicn的博客](https://blog.csdn.net/junweicn)                 							               					

####  						*firewalld*防火墙配置和应用				

 						 						               阅读数  							174 						
 	
 						[ 							firewalld介绍firewalld和iptables的区别(动态防火墙和静态防火墙)我们首先需要弄明白的第一个问题是到底什么是动态防火墙。为了解答这个问题，我们先来回忆一下iptablesser... 						](https://blog.csdn.net/MW_CSDN/article/details/80447845) 						   							                博文                                   [来自：	 chenxinmeng](https://blog.csdn.net/MW_CSDN)                 							               					

####  						Centos的网络环境配置：防火墙*firewalld*，ifconfig+route/ip手动配置网络，用iptables增加网络访问*规则*				

 						 						               阅读数  							154 						
 	
 						[ 							一、防火墙firewalld的操作1、firewalld的基本使用启动：systemctlstartfirewalld查看状态：systemctlstatusfirewalld停止：systemctl... 						](https://blog.csdn.net/qq_27901091/article/details/80940899) 						   							                博文                                   [来自：	 歌古道的博客](https://blog.csdn.net/qq_27901091)                 							               					

####  						CentOs7 防火墙*firewalld**基本*使用方法				

 						 						               阅读数  							127 						
 	
 						[ 							原文地址：https://www.ningto.com/edit/5abaf23c43bef42108349a5d1.firewalld的基本使用启动：systemctlstartfirewalld查... 						](https://blog.csdn.net/tujiaw/article/details/80899648) 						   							                博文                                   [来自：	 Keep It Simple, Stupid](https://blog.csdn.net/tujiaw)                 							               					

#### 电脑上网卡到爆？快用遨游浏览器，体验极速上网



![img](http://recom-1252788780.cosbj.myqcloud.com/img/maxthon_ad.png)

####  							linux端口开放方法						

08-14

 							firewalld的基本使用 启动： systemctl start firewalld 关闭： systemctl stop firewalld 查看状态： systemctl status firewalld  开机禁用  ： sys...					

下载

####  						*Firewalld*使用方法				

 						 						               阅读数  							867 						
 	
 						[ 							RHEL7中的FirewallD支持IPv4,IPv6防火墙设置以及以太网桥接，并且拥有运行时配置和永久配置选项，被称作动态管理防火墙，也就是说不需要重启整个防火墙便可应用更改，不过貌似其实现方式还是... 						](https://blog.csdn.net/Kuma_Migoyan/article/details/50996875) 						   							                博文                                   [来自：	 Kuma_Migoyan的专栏](https://blog.csdn.net/Kuma_Migoyan)                 							               					

####  						*firewalld*详解				

 						 						               阅读数  							159 						
 	
 						[ 							https://blog.csdn.net/gg_18826075157/article/details/72834694从CentOS7(RHEL7)开始，官方的标准防火墙设置软件从iptables... 						](https://blog.csdn.net/Michaelwubo/article/details/80998556) 						   							                博文                                   [来自：	 码农崛起](https://blog.csdn.net/Michaelwubo)                 							               					

####  						*firewalld*对指定IP开放指定端口的配置				

 						 						               阅读数  							1万+ 						
 	
 						[ 							firewalld添加防火墙规则（对指定ip开放指定端口） 						](https://blog.csdn.net/Qguanri/article/details/51673845) 						   							                博文                                   [来自：	 覃冠日的博客](https://blog.csdn.net/Qguanri)                 							               					

####  						Centos7  只启用iptables 禁用*firewalld*功能.				

 						 						               阅读数  							5129 						
 	
 						[ 							首先介绍下Centos7的firewalld和iptables的关系！ 1，centos7中才开始引用firewalld的概念，它是iptables的升级版，以上两者都不是真正的防火墙，都需要与内核n... 						](https://blog.csdn.net/Jerrylfen999/article/details/54318337) 						   							                博文                                   [来自：	 Jerrylfen999的博客](https://blog.csdn.net/Jerrylfen999)                 							               					

#### 抢博洛尼装修 家装新年活动 抢德系施工95折 北京业主专享

"参加3月装修活动,装修施工95折+0元装修规划,还能享装修质保双10年.年度好货底价抢,嗨爆5折"

![img](http://recom-1252788780.cosbj.myqcloud.com/ad_material/博洛尼.png)

####  						fedora/centos7防火墙*FirewallD*详解				

 						 						               阅读数  							858 						
 	
 						[ 							1使用FirewallD构建动态防火墙1.1“守护进程”1.2静态防火墙(system-config-firewall/lokkit)1.3使用iptables和ip6tables的静态防火墙规则1.... 						](https://blog.csdn.net/yudar1024/article/details/43854559) 						   							                博文                                   [来自：	 陈罗杰的专栏](https://blog.csdn.net/yudar1024)                 							               					

####  						*firewalld*防火墙*基本*命令				

 						 						               阅读数  							130 						
 	
 						[ 							1、firewalld的基本使用启动：systemctlstartfirewalld查看状态：systemctlstatusfirewalld停止：systemctldisablefirewalld禁... 						](https://blog.csdn.net/webmaJusse/article/details/79445201) 						   							                博文                                   [来自：	 webmaJusse的博客](https://blog.csdn.net/webmaJusse)                 							               					

####  						CTF/CTF练习平台-flag在index里【php://filter的利用】				

 						 						               阅读数  							9382 						
 	
 						[ 							原题内容：  http://120.24.86.145:8005/post/    Mark一下这道题，前前后后弄了两个多小时，翻了一下别的博主的wp感觉还是讲的太粗了，这里总结下自己的理解：    ... 						](https://blog.csdn.net/wy_97/article/details/77431111) 						   							                博文                                   [来自：	 Sp4rkW的博客](https://blog.csdn.net/wy_97)                 							               					

####  						关于树的几个ensemble模型的比较（GBDT、xgBoost、lightGBM、RF）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							决策树的Boosting方法比较 原始的Boost算法是在算法开始的时候，为每一个样本赋上一个权重值，初始的时候，大家都是一样重要的。在每一步训练中得到的模型，会使得数据点的估计有对有错，我们就在每一... 						](https://blog.csdn.net/xwd18280820053/article/details/68927422) 						   							                博文                                   [来自：	 AI_盲的博客](https://blog.csdn.net/xwd18280820053)                 							               					

####  						【小程序】微信小程序开发实践				

 						 						               阅读数  							23万+ 						
 	
 						[ 							帐号相关流程注册范围 企业 政府 媒体 其他组织换句话讲就是不让个人开发者注册。 :)填写企业信息不能使用和之前的公众号账户相同的邮箱,也就是说小程序是和微信公众号一个层级的。填写公司机构信息,对公账... 						](https://blog.csdn.net/diandianxiyu/article/details/53068012) 						   							                博文                                   [来自：	 小雨同学的技术博客](https://blog.csdn.net/diandianxiyu)                 							               					

####  						DM368开发 -- 编码并实时播放				

 						 						               阅读数  							3730 						
 	
 						[ 							最近正好又用到 DM368 开发板，就将之前做的编解码的项目总结一下。话说一年多没碰，之前做的笔记全忘记是个什么鬼了。还好整理了一下出图像了。不过再看看做的这个东西，真是够渣的，只能作为参考了。项目效... 						](https://blog.csdn.net/qq_29350001/article/details/77941902) 						   							                博文                                   [来自：	 不积跬步，无以至千里](https://blog.csdn.net/qq_29350001)                 							               					

####  						【STM库应用】stm32 之 TIM （详解一 通用定时器）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							STM32的TIM一般有高级定时器TIM1，(TIM8只有在互联性产品有)，普通定时器TIM2，TIM3，TIM4，(TIM5，TIM6，TIM7有点设备中没有)；今天就只介绍普通定时器，因为高级定时... 						](https://blog.csdn.net/ieczw/article/details/17188865) 						   							                博文                                   [来自：	 ieczw的专栏](https://blog.csdn.net/ieczw)                 							               					

####  						servlet+jsp实现过滤器，防止用户未登录访问				

 						 						               阅读数  							2万+ 						
 	
 						[ 							我们可能经常会用到这一功能，比如有时，我们不希望用户没有进行登录访问后台的操作页面，而且这样的非法访问会让系统极为的不安全，所以我们常常需要进行登录才授权访问其它页面，否则只会出现登录页面，当然我的思... 						](https://blog.csdn.net/lsx991947534/article/details/45499205) 						   							                博文                                   [来自：	 沉默的鲨鱼的专栏](https://blog.csdn.net/lsx991947534)                 							               					

####  						通俗理解条件熵				

 						 						               阅读数  							2万+ 						
 	
 						[ 							1  信息熵以及引出条件熵     我们首先知道信息熵是考虑该随机变量的所有可能取值，即所有可能发生事件所带来的信息量的期望。公式如下：     我们的条件熵的定义是：定义为X给定条件下，Y的条件概率... 						](https://blog.csdn.net/xwd18280820053/article/details/70739368) 						   							                博文                                   [来自：	 AI_盲的博客](https://blog.csdn.net/xwd18280820053)                 							               					

####  						将Excel文件导入数据库（POI+Excel+MySQL+jsp页面导入）第一次优化				

 						 						               阅读数  							2万+ 						
 	
 						[ 							本篇文章是根据我的上篇博客，给出的改进版，由于时间有限，仅做了一个简单的优化。相关文章：将excel导入数据库2018年4月1日，新增下载地址链接：点击打开源码下载地址十分抱歉，这个链接地址没有在这篇... 						](https://blog.csdn.net/meng564764406/article/details/52444644) 						   							                博文                                   [来自：	 Lynn_Blog](https://blog.csdn.net/meng564764406)                 							               					

####  						jquery/js实现一个网页同时调用多个倒计时(最新的)				

 						 						               阅读数  							41万+ 						
 	
 						[ 							jquery/js实现一个网页同时调用多个倒计时(最新的)  最近需要网页添加多个倒计时. 查阅网络,基本上都是千遍一律的不好用. 自己按需写了个.希望对大家有用. 有用请赞一个哦!    //js ... 						](https://blog.csdn.net/wuchengzeng/article/details/50037611) 						   							                博文                                   [来自：	 Websites](https://blog.csdn.net/wuchengzeng)                 							               					

####  						ThreadLocal的设计理念与作用				

 						 						               阅读数  							4万+ 						
 	
 						[ 							Java中的ThreadLocal类允许我们创建只能被同一个线程读写的变量。因此，如果一段代码含有一个ThreadLocal变量的引用，即使两个线程同时执行这段代码，它们也无法访问到对方的Thread... 						](https://blog.csdn.net/u011860731/article/details/48733073) 						   							                博文                                   [来自：	 u011860731的专栏](https://blog.csdn.net/u011860731)                 							               					

####  						配置简单功能强大的excel工具类搞定excel导入导出工具类(一)				

 						 						               阅读数  							3万+ 						
 	
 						[ 							对于J2EE项目导入导出Excel是最普通和实用功能,本工具类使用步骤简单,功能强大,只需要对实体类进行简单的注解就能实现导入导出功能,导入导出操作的都是实体对象. 请看一下这个类都有哪些功能:   ... 						](https://blog.csdn.net/lk_blog/article/details/8007777) 						   							                博文                                   [来自：	 李坤 大米时代 第五期](https://blog.csdn.net/lk_blog)                 							               					

####  						【深入Java虚拟机】之五：多态性实现机制——静态分派与动态分派				

 						 						               阅读数  							3万+ 						
 	
 						[ 							Class文件的编译过程中不包含传统编译中的连接步骤，一切方法调用在Class文件里面存储的都只是符号引用，而不是方法在实际运行时内存布局中的入口地址。这个特性给Java带来了更强大的动态扩展能力，使... 						](https://blog.csdn.net/mmc_maodun/article/details/17965867) 						   							                博文                                   [来自：	 兰亭风雨的专栏](https://blog.csdn.net/mmc_maodun)                 							               					

####  						关于SpringBoot bean无法注入的问题（与文件包位置有关）				

 						 						               阅读数  							14万+ 						
 	
 						[ 							问题场景描述整个项目通过Maven构建，大致结构如下： 核心Spring框架一个module spring-boot-base service和dao一个module server-core 提供系统... 						](https://blog.csdn.net/gefangshuai/article/details/50328451) 						   							                博文                                   [来自：	 开发随笔](https://blog.csdn.net/gefangshuai)                 							               					

####  						非局部均值去噪（NL-means）				

 						 						               阅读数  							1万+ 						
 	
 						[ 							非局部均值（NL-means）是近年来提出的一项新型的去噪技术。该方法充分利用了图像中的冗余信息，在去噪的同时能最大程度地保持图像的细节特征。基本思想是：当前像素的估计值由图像中与它具有相似邻域结构的... 						](https://blog.csdn.net/u010839382/article/details/48229579) 						   							                博文                                   [来自：	 xiaoluo91的专栏](https://blog.csdn.net/u010839382)                 							               					

####  						centos 查看命令源码				

 						 						               阅读数  							6万+ 						
 	
 						[ 							# yum install yum-utils   设置源: [base-src\] name=CentOS-5.4 - Base src - baseurl=http://vault.ce... 						](https://blog.csdn.net/silentpebble/article/details/41279285) 						   							                博文                                   [来自：	 linux/unix](https://blog.csdn.net/silentpebble)                 							               					

####  						expat介绍文档翻译				

 						 						               阅读数  							2万+ 						
 	
 						[ 							原文地址：http://www.xml.com/pub/a/1999/09/expat/index.html   因为需要用，所以才翻译了这个文档。但总归赖于英语水平很有限，翻译出来的中文有可能... 						](https://blog.csdn.net/ymj7150697/article/details/7384126) 						   							                博文                                   [来自：	 ymj7150697的专栏](https://blog.csdn.net/ymj7150697)                 							               					

​                                        [             Series基本结构          ](https://edu.csdn.net/course/play/3904/91718)                                                [             机器学习          ](https://edu.csdn.net/courses/o5329_s5330_k)                                                [             机器学习课程          ](https://edu.csdn.net/courses/o5329_s5330_k)                                                [             机器学习教程          ](https://edu.csdn.net/courses/o5329_s5330_k)                                                [             深度学习视频教程          ](https://edu.csdn.net/combos/o5329_s5331_l0_t)                         

​                                [             c++ 基本](https://www.csdn.net/gather_28/MtzaUg4sMjQtYmxvZwO0O0OO0O0O.html)                                           [             c++regex库正则表达式规则](https://www.csdn.net/gather_20/MtzaUg1sMDktYmxvZwO0O0OO0O0O.html)                                           [             c++类定义规则](https://www.csdn.net/gather_2a/MtTaIg4sMDE0LWJsb2cO0O0O.html)                                           [             android 防火墙规则](https://www.csdn.net/gather_28/MtTakg5sMDI3Ny1ibG9n.html)                                           [             c++ duilib基本使用](https://www.csdn.net/gather_23/NtTaQg1sMDktYmxvZwO0O0OO0O0O.html)                                           [             人工智能基本课程](https://www.csdn.net/gather_4a/NtzaIgxsOS1lZHUO0O0O.html)                                           [             python基本教程](https://www.csdn.net/gather_4a/NtTaQgwsOC1lZHUO0O0O.html)                            

​             [                 ![img](https://avatar.csdn.net/E/4/F/3_hahaha_yan.jpg)             ](https://blog.csdn.net/hahaha_yan)                      

​                 [hahaha_yan](https://blog.csdn.net/hahaha_yan)             

​                              关注                      

- [原创](https://blog.csdn.net/hahaha_yan?t=1)

  [57](https://blog.csdn.net/hahaha_yan?t=1)

- 粉丝

  11

- 喜欢

  2

- 评论

  0

- 等级：

  ​                 [                                                                                    ](https://blog.csdn.net/home/help.html#level)             

- 访问：

  ​                 1万+            

- 积分：

  ​                 674            

- 排名：

  9万+

勋章：

​                                                                                     

   

### 最新文章

- ​                 [mysq的相关设定](https://blog.csdn.net/hahaha_yan/article/details/79192104)             
- ​                 [php的memcache模块](https://blog.csdn.net/hahaha_yan/article/details/79184475)             
- ​                 [lanmp](https://blog.csdn.net/hahaha_yan/article/details/79184250)             
- ​                 [负载均衡lvs](https://blog.csdn.net/hahaha_yan/article/details/79176940)             
- ​                 [cdn](https://blog.csdn.net/hahaha_yan/article/details/79175145)             

### 归档

- ​                 [                     2018年1月                    14篇                 ](https://blog.csdn.net/hahaha_yan/article/month/2018/01)             
- ​                 [                     2017年12月                    12篇                 ](https://blog.csdn.net/hahaha_yan/article/month/2017/12)             
- ​                 [                     2017年11月                    17篇                 ](https://blog.csdn.net/hahaha_yan/article/month/2017/11)             
- ​                 [                     2017年10月                    13篇                 ](https://blog.csdn.net/hahaha_yan/article/month/2017/10)             
- ​                 [                     2017年9月                    3篇                 ](https://blog.csdn.net/hahaha_yan/article/month/2017/09)             

### 热门文章

- 简易自动售卖机系统

  阅读数 1785

- firewalld的基本规则

  阅读数 1641

- 简易ATM柜员机管理系统

  阅读数 791

- FTP服务器工作原理及如何通过PAM认证实现虚拟用户登录

  阅读数 537

- 分区加密

  阅读数 446

   

![CSDN学院](https://csdnimg.cn/pubfooter/images/edu-QR.png)

CSDN学院



CSDN企业招聘



kefu@csdn.net



*QQ客服*



[客服论坛](http://bbs.csdn.net/forums/Service)

<svg t="1538013874294" width="17" height="17" style="" viewBox="0 0 1194 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="23784" xlink="http://www.w3.org/1999/xlink"><defs></defs></svg>
400-660-0108 

工作时间 8:30-22:00

[关于我们](https://www.csdn.net/company/index.html#about)[招聘](https://www.csdn.net/company/index.html#recruit)[广告服务](https://www.csdn.net/company/index.html#contact)            [            网站地图](https://www.csdn.net/gather/A)



[*百度提供站内搜索*](https://zn.baidu.com/cse/home/index) [京ICP证19004658号](http://www.miibeian.gov.cn/)

©1999-2019 北京创新乐知网络技术有限公司 

经营性网站备案信息        *网络110报警服务*

[北京互联网违法和不良信息举报中心](http://www.bjjubao.org/)

[中国互联网举报中心](http://www.12377.cn/)

 [Python怎么学](https://edu.csdn.net/topic/python115?utm_source=ditong) 

 [转型AI人工智能指南](https://edu.csdn.net/topic/ai30?utm_source=ditong) 

 [区块链趋势解析](https://edu.csdn.net/topic/blockchain10?utm_source=ditong) 

 [28 天算法训练营](https://gitbook.cn/gitchat/column/5c86261f029620739b167498?utm_source=wzl190315) 

 [2019 Python 开发者日](https://pythondevdays2019.csdn.net/?utm_source=dbad) 

<iframe scrolling="no" src="https://pos.baidu.com/s?hei=36&amp;wid=286&amp;di=u3486002&amp;ltu=https%3A%2F%2Fblog.csdn.net%2Fhahaha_yan%2Farticle%2Fdetails%2F78709549&amp;psi=fc53f4ec04f27b688575d08679020406&amp;ant=0&amp;pis=-1x-1&amp;pss=1309x7474&amp;chi=1&amp;tcn=1553438069&amp;dc=3&amp;dri=0&amp;tlm=1553438069&amp;ti=firewalld%E7%9A%84%E5%9F%BA%E6%9C%AC%E8%A7%84%E5%88%99%20-%20hahaha_yan%E7%9A%84%E5%8D%9A%E5%AE%A2%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;cfv=0&amp;cja=false&amp;ps=620x739&amp;cpl=1&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D5XObMNOCN4M_77LHdVL0Uw_fY0yxFb-uwJuLUQY_hM0-2qPDyZiWaX1AEM04_f2Y-bTDKHpzz7wuz9BE2eUgYhx5kpipYOzh1ezrVfln7QW%26wd%3D%26eqid%3Deb434ab200012440000000045c9795aa&amp;dis=0&amp;dtm=HTML_POST&amp;drs=1&amp;cdo=-1&amp;cec=UTF-8&amp;cce=true&amp;par=1280x760&amp;col=zh&amp;ari=2&amp;dai=1&amp;pcs=1263x669&amp;psr=1280x800&amp;cmi=2&amp;prot=2&amp;tpr=1553438069434&amp;ccd=24&amp;exps=111000,110011" width="286" height="36" frameborder="0"></iframe>
​                 登录             

​                 [注册](https://passport.csdn.net/account/mobileregister)             

 		

-  			

<svg class="icon hover-hide" aria-hidden="true">
					<use xlink:href="https://blog.csdn.net/hahaha_yan/article/details/78709549#csdnc-comments"></use>
				</svg>

 										

 			

- ​          				 					 				 				 			
-  				[ 					 						 					 					 				](https://blog.csdn.net/hahaha_yan/article/details/78668757) 			
-  			[ 				 					 				 				 			](https://blog.csdn.net/hahaha_yan/article/details/78732834) 		

[                          ](https://mall.csdn.net/vip_code)    [              ](https://blog.csdn.net/hahaha_yan/article/details/78709549#)

​          

​                                                      

[![到百度首页](https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superlanding/img/logo_top.png)](https://www.baidu.com)

百度首页

[wfab12](http://i.baidu.com/)

## Centos7/RHEL7-firewalld设置访问规则

![img](https://timg01.bdimg.com/timg?pacompress&imgtype=0&sec=1439619614&autorotate=1&di=7fafa63b28931440e43f32125fc02bcd&quality=90&size=b200_200&src=http%3A%2F%2Fbos.nj.bpc.baidu.com%2Fv1%2Fmediaspot%2Fbf8aced868ed2ddb5bb0d64165e258ea.jpeg)

linux运维菜

18-08-1923:46

前言



CentOS7/RHEL7系统默认的iptables管理工具是firewalld，不再是以往的iptables-services，命令用起来也是不一样了，当然你也可以选择卸载firewalld，安装iptables-services。

![img](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2868471007,1391575169&fm=173&app=25&f=JPEG?w=640&h=480&s=52D65892425217C846A70391030070AE)





firewalld 服务管理



1、安装firewalld



yum -y install firewalld 



2、开机启动/禁用服务



systemctl     enable/disable     firewalld



3、启动/关闭服务



systemctl     start/stop    firewalld



4、查看服务状态



systemctl     status firewalld

![img](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=1714829722,3294341199&fm=173&app=25&f=JPEG?w=640&h=440&s=8D02E4171EF3668E331031C60300E0E0)





使用firewall-cmd命令设置规则



1、查看状态



firewall-cmd  --state



2、获取活动的区域



firewall-cmd --get-active-zones



3、 获取所有支持的服务



firewall-cmd --get-service



4、应急模式（阻断所有的网络连接）



firewall-cmd --panic-on     #开启应急模式



firewall-cmd --panic-off    #关闭应急模式



firewall-cmd --query-panic   #查询应急模式





5、修改配置文件后 使用命令重新加载



firewall-cmd --reload





6、启用某个服务/端口



firewall-cmd --zone=public --add-service=https #临时



firewall-cmd --permanent --zone=public --add-service=https #永久



firewall-cmd --permanent --zone=public --add-port=8080-8081/tcp #永久



firewall-cmd --zone=public --add-port=8080-8081/tcp #临时



如果是要删除，直接修改成remove-service或者remove-port



7、查看开启的端口和服务



firewall-cmd --permanent --zone=public --list-services     #服务空格隔开 例如 dhcpv6-client https ss 



firewall-cmd --permanent --zone=public --list-ports       #端口空格隔开 例如 8080-8081



在每次修改 端口和服务后  /etc/firewalld/zones/public.xml  文件就会被修改。





8、设置某个ip 访问某个服务



firewall-cmd  --permanent --zone=public --add-rich-rule="rule family="ipv4" source  address="192.168.122.0/24" service name="http" accept"     #ip  192.168.122.0/24 访问 http





总结



防火墙预定义的服务配置文件是xml文件，目录在  /usr/lib/firewalld/services/； 在 /etc/firewalld/services/  这个目录中也有配置文件，但是/etc/firewalld/services/目录优先于 /usr/lib/firewalld/services/   目录。



![img](https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2662515155,2545595537&fm=173&app=25&f=JPEG?w=640&h=426&s=582435724F226D201E581CC20100A0B2)





![img](https://timg01.bdimg.com/timg?pacompress&imgtype=0&sec=1439619614&autorotate=1&di=7fafa63b28931440e43f32125fc02bcd&quality=90&size=b200_200&src=http%3A%2F%2Fbos.nj.bpc.baidu.com%2Fv1%2Fmediaspot%2Fbf8aced868ed2ddb5bb0d64165e258ea.jpeg)

- ### https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9846432532562507793%22%7D&n_type=1&p_from=4)



# [Excelib](https://www.cnblogs.com/excelib/)

随笔 - 3, 文章 - 0, 评论 - 6, 引用 - 0

##  			[用活firewalld防火墙中的zone](https://www.cnblogs.com/excelib/p/5155951.html) 		

版权声明：本内容为原创内容，转载请声明出处。

原文地址：<http://www.excelib.com/article/290/show>

firewalld中zone的含义学生[前面](http://www.excelib.com/article/287/show#g5vTC3)已经给大家介绍过了，说白了一个zone就是一套规则集。可是什么时候该用哪个zone、每个zone中的规则具体是怎么设置呢？下面学生就来给大家详细讲解。

## 名词解释

在具体介绍zone之前学生先给大家介绍几个相关的名词，因为如果不理解这几个名词zone就无从入手。

- target：目标，这个前面学生也已经给大家介绍过了，可以理解为默认行为，有四个可选值：default、ACCEPT、%%REJECT%%、DROP，如果不设置默认为default
- service：这个在前面学生已经给大家解释过了，他表示一个服务
- port：端口，使用port可以不通过service而直接对端口进行设置
- interface：接口，可以理解为网卡
- source：源地址，可以是ip地址也可以是ip地址段
- icmp-block：icmp报文阻塞，可以按照icmp类型进行设置
- masquerade：ip地址伪装，也就是按照源网卡地址进行NAT转发
- forward-port：端口转发
- rule：自定义规则

## 哪个zone在起作用

我们知道每个zone就是一套规则集，但是有那么多zone，对于一个具体的请求来说应该使用哪个zone（哪套规则）来处理呢？这个问题至关重要，如果这点不弄明白其他的都是空中楼阁，即使规则设置的再好，不知道怎样用、在哪里用也不行。

对于一个接受到的请求具体使用哪个zone，firewalld是通过三种方法来判断的：

1、source，也就是源地址

2、interface，接收请求的网卡

3、firewalld.conf中配置的默认zone

这三个的优先级按顺序依次降低，也就是说如果按照source可以找到就不会再按interface去查找，如果前两个都找不到才会使用第三个，也就是学生在前面给大家讲过的在firewalld.conf中配置的[默认zone](http://www.excelib.com/article/287/show#eFZCbt)。

好了，我们现在知道其原理了，下面学生就给大家介绍每一种方式所对应的配置方法。

### 配置source

source是在zone的xml文件中配置的，其格式为

  `<``zone``>` `    ``<``source` `address``=``"address[/mask]"``/>` `</``zone``>`  

只要我们将source节点放入相应的zone配置文件中就可以了，节点的address属性就是源地址，不过我们要注意相同的source节点只  可以在一个zone中进行配置，也就是说同一个源地址只能对于一个zone，另外，直接编辑xml文件之后还需要reload才可以起作用，这些学生[前面](http://www.excelib.com/article/table/237/preview#04hhAd)已经给大家讲过，这里就不再重述了。

另外，我们当然也可以使用firewall-cmd命令进行配置，这里主要有五个相关命令（参数）

  `firewall-cmd [--permanent] [--zone=zone] --list-sources` `firewall-cmd [--permanent] [--zone=zone] --query-``source``=``source``[``/mask``]` `firewall-cmd [--permanent] [--zone=zone] --add-``source``=``source``[``/mask``]` `firewall-cmd [--zone=zone] --change-``source``=``source``[``/mask``]` `firewall-cmd [--permanent] [--zone=zone] --remove-``source``=``source``[``/mask``]`  

我们分别来介绍一下

- --list-sources：用于列出指定zone的所有绑定的source地址
- --query-source：用于查询指定zone是否跟指定source地址进行了绑定
- --add-source：用于将一个source地址绑定到指定的zone（只可绑定一次，第二次绑定到不同的zone会报错）
- --change-source：用于改变source地址所绑定的zone，如果原来没有绑定则进行绑定，这样就跟--add-source的作用一样了
- --remove-source：用于删除source地址跟zone的绑定

 

另外，大家可以看到上面的命令中有两个可选参数：--permanent和--zone，--permanent学生在前面已经给大家介绍过了，表  示是否存储到配置文件中（如果存储到配置文件中这不会立即生效），--zone用于指定所要设置的zone，如果不指定则使用默认zone。

我们来看个例子

  `[root@excelib.com ~]``# firewall-cmd --zone=drop --change-source=1.2.3.4`  

这样就可以将1.2.3.4绑定到drop这个zone中了，如果没有修改过drop规则的话所有来自1.2.3.4这个ip的连接将会被drop。

至于什么时候使用add什么时候使用change，如果我们就是想将某源地址绑定到指定的zone那么最好使用change，而如果想在源地址没绑定的时候进行绑定，如果已经绑定过则不绑定那么就使用add。

### 配置interface

interface有两个可以配置的位置：1、zone所对应的xml配置文件2、网卡配置文件（也就是ifcfg-*文件）。

第一种配置跟source大同小异，学生这里就不再细述了，interface在zone配置文件中的节点为

  `<``zone``>` `    ``<``interface` `name``=``"string"``/>` `</``zone``>`  

相关的firewall-cmd命令为

  `firewall-cmd [--permanent] [--zone=zone] --list-interfaces` `firewall-cmd [--permanent] [--zone=zone] --add-interface=interface` `firewall-cmd [--zone=zone] --change-interface=interface` `firewall-cmd [--permanent] [--zone=zone] --query-interface=interface` `firewall-cmd [--permanent] [--zone=zone] --remove-interface=interface`  

另外，我们还可以在`网卡配置文件中进行配置，比如可以在ifcfg-em1文件中添加下面的配置`

  `ZONE=public`  

这行配置就相当于下面的命令

  `[root@excelib.com ~]``# firewall-cmd --zone=public --change-interface=em1`  

这样配置之后来自em1的连接就会使用public这个zone进行管理（如果source匹配了其他的zone除外）。

### 配置默认zone

默认zone的配置学生[前面](http://www.excelib.com/article/287/show#eFZCbt)已经给大家介绍过了，他是通过firewalld.conf配置文件的DefaultZone配置项来配置的，当然也可以使用firewall-cmd命令来配置

  `firewall-cmd --``set``-default-zone=zone`  

另外还可以通过--get-default-zone来获取默认zone的值。

### 查看当前起作用的zone

我们可以使用下面的命令来查看当前所有起作用的zone

  `firewall-cmd --get-active-zones`  

这个命令会返回所有绑定了source、interface以及默认的zone，并会说明在什么情况下使用。

### 反向查询

firewalld还给我们提供了反向查询的命令，也就是根据source或者interface查询所对应的zone，其命令如下

  `firewall-cmd --get-zone-of-interface=interface` `firewall-cmd --get-zone-of-``source``=``source``[``/mask``]`  

有了这两个命令我们就可以检查我们的设置是否正确了。

 

好了，现在大家就明白了一个接收到的请求具体使用哪个zone了，那么zone具体的规则怎么配置呢？下面学生就来给大家详细介绍。

## zone规则配置

### target

zone规则中首先最重要的是target的设置，他默认可以取四个值：default、ACCEPT、%%REJECT%%、DROP，其含义很容易理解，这里学生就不介绍了，下面来说怎么配置。

在xml文件中target是zone节点的一个属性，比如drop.xml中为

  `<``zone` `target``=``"DROP"``>`  

block.xml中为

  `<``zone` `target``=``"%%REJECT%%"``>`  

如果使用firewall-cmd命令来操作，命令如下

  `firewall-cmd --permanent [--zone=zone] --get-target` `firewall-cmd --permanent [--zone=zone] --``set``-target=target`  

我们要特别注意，这里的--permanent不是可选的，也就是说使用firewall-cmd命令也不可以让他直接生效，也需要reload才可以。

### service

service学生在[前面](http://www.excelib.com/article/287/show#Zpg77S)也已经给大家介绍过了，他的配置和我们上面所介绍的source基本相同，只不过同一个service可以配置到多个不同的zone中，当然也就不需要--change命令了，他在zone配置文件中的节点为

  `<``zone``>` `    ``<``service` `name``=``"string"``/>` `</``zone``>`  

相应的配置命令为

  `firewall-cmd [--permanent] [--zone=zone] --list-services` `firewall-cmd [--permanent] [--zone=zone] --add-service=service [--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-service=service` `firewall-cmd [--permanent] [--zone=zone] --query-service=service`  

具体每个命令的含义大家对照上面的source很容易就理解了，不过这里的--add命令中多了一个--timeout选项，学生这里给大家介绍一下。

--add-service中的--timeout的含义是这样的：添加一个服务，但是不是一直生效而是生效一段时间，过期之后自动删除。

这个选项非常有用，比如我们想暂时开放一个端口进行一些特殊的操作（比如远程调试），等处理完成后再关闭，不过有时候我们处理完之后就忘记关闭了，   而现在的--timeout选项就可以帮我们很好地解决这个问题，我们在打开的时候就可以直接设置一个时间，到时间之后他自动就可以关闭了。另外，这个参  数还有更有用的用法，学生会在下面给大家讲到。当然--timeout和--permanent是不可以一起使用的。

另外，这里我们主要讲的是怎么在zone中使用service，而service自己的配置学生下节再给大家详细介绍。

### port

port是直接对端口的操作，他和service非常相似，所以这里也不详细介绍了，port在zone中的配置节点为

  `<``zone``>` `    ``<``port` `port``=``"portid[-portid]"` `protocol``=``"tcp|udp"``/>` `</``zone``>`  

相应命令为

  `firewall-cmd [--permanent] [--zone=zone] --list-ports` `firewall-cmd [--permanent] [--zone=zone] --add-port=portid[-portid]``/protocol` `[--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-port=portid[-portid]``/protocol` `firewall-cmd [--permanent] [--zone=zone] --query-port=portid[-portid]``/protocol`  

### icmp-block

icmp-block是按照icmp的类型进行设置阻塞，比如我们不想接受ping报文就可以使用下面的命令来设置

  `[root@excelib.com ~]``# firewall-cmd --add-icmp-block=echo-request`  

当然，如果需要长久保存就需要加--permanent选项，不过那样就需要reload才能生效。

icmp-block在zone配置文件中的节点为

  `<``zone``>` `    ``<``icmp-block` `name``=``"string"``/>` `</``zone``>`  

相应操作命令为

  `firewall-cmd [--permanent] [--zone=zone] --list-icmp-blocks` `firewall-cmd [--permanent] [--zone=zone] --add-icmp-block=icmptype [--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-icmp-block=icmptype` `firewall-cmd [--permanent] [--zone=zone] --query-icmp-block=icmptype`  

### masquerade

masquerade大家应该都比较熟悉，其作用就是ip地址伪装，也就是NAT转发中的一种，具体处理方式是将接收到的请求的源地址设置为转发请   求网卡的地址，这在路由器等相关设备中非常重要，比如大家很多都使用的是路由器连接的局域网，而想上互联网就得将我们的ip地址给修改一下，要不大家都是  192.168.1.XXX的内网地址，那请求怎么能正确返回呢？所以在路由器中将请求实际发送到互联网的时候就会将请求的源地址设置为路由器的外网地  址，这样请求就能正确地返回给路由器了，然后路由器再根据记录返回给我们发送请求的主机了，这就是masquerade。

其设置非常简单，在zone中是一个没有参数（属性）的节点

  `<``zone``>` `    ``<``masquerade``/>` `</``zone``>`  

操作命令为

  `firewall-cmd [--permanent] [--zone=zone] --add-masquerade [--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-masquerade` `firewall-cmd [--permanent] [--zone=zone] --query-masquerade`  

### forward-port

这项也非常容易理解，他是进行端口转发的，比如我们要将在80端口接收到tcp请求转发到8080端口可以使用下面的命令

  `[root@excelib.com ~]``# firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080`  

forward-port还支持范围转发，比如我们还可以将80到85端口的所有请求都转发到8080端口，这时只需要将上面命令中的port修改为80-85即可。

在zone配置文件中节点如下

  `<``zone``>` `    ``<``forward-port` `port``=``"portid[-portid]"` `protocol``=``"tcp|udp"` `[``to-port``=``"portid[-portid]"``] [``to-addr``=``"ipv4address"``]/>` `</``zone``>`  

相关操作命令如下

  `firewall-cmd [--permanent] [--zone=zone] --list-forward-ports` `firewall-cmd [--permanent] [--zone=zone] --add-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[``/mask``]][--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[``/mask``]]` `firewall-cmd [--permanent] [--zone=zone] --query-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[``/mask``]]`  

### rule

rule可以用来定义一条复杂的规则，其在zone配置文件中的节点定义如下

  `<``zone``>` `    ``<``rule` `[``family``=``"ipv4|ipv6"``]>` `               ``[ <``source` `address``=``"address[/mask]"` `[``invert``=``"bool"``]/> ]` `               ``[ <``destination` `address``=``"address[/mask]"` `[``invert``=``"bool"``]/> ]` `               ``[` `                 ``<``service` `name``=``"string"``/> |` `                 ``<``port` `port``=``"portid[-portid]"` `protocol``=``"tcp|udp"``/> |` `                 ``<``protocol` `value``=``"protocol"``/> |` `                 ``<``icmp-block` `name``=``"icmptype"``/> |` `                 ``<``masquerade``/> |` `                 ``<``forward-port` `port``=``"portid[-portid]"` `protocol``=``"tcp|udp"` `[``to-port``=``"portid[-portid]"``] [``to-addr``=``"address"``]/>` `               ``]` `               ``[ <``log` `[``prefix``=``"prefixtext"``] [``level``=``"emerg|alert|crit|err|warn|notice|info|debug"``]/> [<``limit` `value``=``"rate/duration"``/>] </``log``> ]` `               ``[ <``audit``> [<``limit` `value``=``"rate/duration"``/>] </``audit``> ]` `               ``[ <``accept``/> | <``reject` `[``type``=``"rejecttype"``]/> | <``drop``/> ]` `     ``</``rule``>` `</``zone``>`  

可以看到这里一条rule的配置的配置项非常多，比zone本身还多出了destination、log、audit等配置项。其实这里的rule就相当于使用iptables时的一条规则。rule的操作命令如下

  `firewall-cmd [--permanent] [--zone=zone] --list-rich-rules` `firewall-cmd [--permanent] [--zone=zone] --add-rich-rule=``'rule'` `[--timeout=seconds]` `firewall-cmd [--permanent] [--zone=zone] --remove-rich-rule=``'rule'` `firewall-cmd [--permanent] [--zone=zone] --query-rich-rule=``'rule'`  

这里的参数'rule'代表一条规则语句，语句结构就是直接按照上面学生给大家的节点结构去掉尖括号来书写就可以了，比如要设置地址为  1.2.3.4的source就可以写成source  address="1.2.3.4"，也就是直接写标签名，然后跟着写属性就可以了，我们来看个例子

  `[root@excelib.com ~]``# firewall-cmd --add-rich-rule='rule family="ipv4" source address="1.2.3.4" drop'`  

这条规则就会将1.2.3.4这个源地址的连接全部给drop掉。

使用rule结合--timeout我们可以实现一些非常好玩和有用的功能，比如我们可以写个自动化脚本，当发现有异常的连接时就可以添加一条rule将其相应的地址drop掉，而且还可以使用--timeout给设置个时间段，过了之后再自动开放！

​					



**系统中防火墙的结构：**

**![img](https://img-blog.csdn.net/20171206193917417?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**firewalld**

**firewalld不是防火墙，只是用来管理防火墙的一种软件，对iptables进行操作，之后会对内核进行修改**

**Firewalld的工作状态**

**![img](https://img-blog.csdn.net/20171206205231578?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-config &              ##打开图形管理防火墙界面**

**![img](https://img-blog.csdn.net/20171206202946373?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**![img](https://img-blog.csdn.net/20171206203056197?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**

**Runtime                  ##临时性修改会立即生效，服务重启后消失**

**Permanet                 ##永久性修改，需要重启服务后才会生效**



**监控命令:**

**![img](https://img-blog.csdn.net/20171206203350215?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**临时性修改：（会立即生效）**

**![img](https://img-blog.csdn.net/20171206203744421?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**永久性修改：（不会立即生效）**

**![img](https://img-blog.csdn.net/20171206203809741?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**需要重启防火墙服务**

**![img](https://img-blog.csdn.net/20171206204008209?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**永久性更改火墙的服务，会记录到防火墙的配置文件中**

**![img](https://img-blog.csdn.net/20171206204543130?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**

**public.xml.old是对public.xml的备份**



**![img](https://img-blog.csdn.net/20171206204600598?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**/usr/lib/firewalld/目录下是对所有火墙服务状态的记录，永久性更改火墙服务，该目录下的文件也会及时做出相应的修改**

**![img](https://img-blog.csdn.net/20171206204247139?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**![img](https://img-blog.csdn.net/20171206204306543?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-cmd --state                                          ##查看防火墙的状态**

**firewall-cmd --get-active-zones                      ##查看防火墙正在运行的网络区**

**firewall-cmd --get-services                             ##查看防火墙所有的服务**

**firewall-cmd --get-default-zone                       ##查看默认网络区**

**firewall-cmd --get-zones                                  ##查看防火墙所有的网络区**

**![img](https://img-blog.csdn.net/20171206210107912?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**如果想更改服务的名称，可以切换到/usr/lib/firewalld/services目录下进行修改，修改后需要重启火墙服务**

**但是一般不建议随意修改服务的名称**

**![img](https://img-blog.csdn.net/20171207104128122?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**firewall-cmd --list-all-zones                            ##查看防火墙所有网络区的详细信息**

**![img](https://img-blog.csdn.net/20171206210353932?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-cmd --list-all --zone=public                            ##查看public网络区的所有信息**

**firewall-cmd --list-all --zone=trusted                          ##查看trusted网络区的所有信息**

**![img](https://img-blog.csdn.net/20171206210521420?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-cmd --set-default-zone=trusted                          ##设定默认网络区为trusted**

**![img](https://img-blog.csdn.net/20171206210832670?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-cmd --add-sourse=172.25.254.49 --zone=trusted                    ##将172.25.254.49这个ip添加到trusted网络区**

**firewall-cmd --remove-sourse=172.25.254.49 --zone=trusted            ##将172.25.254.49这个ip移除trusted网络区**

**![img](https://img-blog.csdn.net/20171206211938661?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**为了方便实验，我们可以安装一个httpd服务来检测试验的效果**

**![img](https://img-blog.csdn.net/20171206212436317?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**编辑服务下可读取的文件，启动服务**

**![img](https://img-blog.csdn.net/20171206212527357?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**

**![img](https://img-blog.csdn.net/20171206212539638?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**将默认网络区设为dmz，将eth1网卡从dmz网络区中移除添加到trusted网络区**

**eth0的ip为：172.25.254.149**

**eth1的ip为：172.25.49.149**

**![img](https://img-blog.csdn.net/20171206212802230?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**此时httpd服务只能通过eth1这块网卡的ip**

**![img](https://img-blog.csdn.net/20171206213238268?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**

**上面的更改为临时性更改，重启火墙服务后会消失**



**编辑httpd的主配置文件，将服务端口改为8080**

![img](https://img-blog.csdn.net/20171206213943459?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![img](https://img-blog.csdn.net/20171206213959745?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



**在图形管理火墙界面中添加8080/tcp端口**

**Reload Firewalld                ##重启火墙服务**

![img](https://img-blog.csdn.net/20171206214056586?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



![img](https://img-blog.csdn.net/20171206214149142?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



**此时默认的80端口将无法登陆httpd服务，需在访问的ip后添加8080端口**

**![img](https://img-blog.csdn.net/20171206214257583?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**![img](https://img-blog.csdn.net/20171206214317368?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**永久性的移除http和https服务，需要重启火墙服务才会生效**

**![img](https://img-blog.csdn.net/20171206214708166?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**永久性移除8080/tcp端口，也需要重启火墙服务才会生效**

**![img](https://img-blog.csdn.net/20171206214902266?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**此时将无法登陆httpd服务**

**![img](https://img-blog.csdn.net/20171206220844021?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)**



**firewall-cmd --reload                                ##重启火墙服务临时性的修改会消失，但临时性正在连接中的服务不会断开**

**firewall-cmd --complete-reload              ##重启火墙服务临时性的修改会消失，如果临时性的服务正在连接中服务将会断开**



**firewall-cmd --direct --get-all-rules         ##查看火墙服务中的所有规则**

**firewall-cmd --direct --add-rule ipv4 filter INPUT 1 -s 172.25.254.49 -p tcp --dport 22 -j REJECT**

**拒绝ip为172.25.254.49的主机访问22端口的ssh服务**

**![img](https://img-blog.csdn.net/20171207104904532?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**测试：**

**![img](https://img-blog.csdn.net/20171207105335668?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**firewall-cmd --direct --add-rule ipv4 filter INPUT 1 ! -s 172.25.254.49 -p tcp --dport 21 -j REJECT**

**只允许ip为172.25.254.49的主机访问21端口的ftp服务，其他主机都拒绝**

**![img](https://img-blog.csdn.net/20171207105422356?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**测试之前需要将ftp服务添加到火墙服务上**

**![img](https://img-blog.csdn.net/20171207110802727?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**



**测试：**

**![img](https://img-blog.csdn.net/20171207105843187?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2VpeGluXzQwNTcxNjM3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)**





- [网站首页](https://www.linuxprobe.com/)
- [开始读书](https://www.linuxprobe.com/chapter-00.html)  
- [下载](https://www.linuxprobe.com/tools)  
- [Linux资讯](https://www.linuxprobe.com/news)
- [Linux书籍](https://www.linuxprobe.com/books)
- [技术干货](https://www.linuxprobe.com/thread)
- [投稿](https://www.linuxprobe.com/tougao)
- [Linux培训](https://www.linuxprobe.com/training)
- [培训记录](https://www.linuxprobe.com/train)
- [红帽认证](https://www.linuxprobe.com/redhat-certificate)  
- [加入我们](https://www.linuxprobe.com/team)  
- [登录](https://www.linuxprobe.com/login)

# Concepts

firewalld has a two layer design: The core layer and the D-Bus  layer on top. The core layer is responsible for handling the  configuration and the back ends like iptables, ip6tables, ebtables,  ipset and the module loader.

![firewalld-structure+nftables](https://firewalld.org/documentation/firewalld-structure+nftables.png) *firewalld structure*

The firewalld D-Bus interface is the primary way to alter and create  the firewall configuration. The interface is used by all firewalld  provided online tools, like for example firewall-cmd, firewall-config  and firewall-applet. firewall-offline-cmd is not talking to firewalld,  but altering and creating firewalld configuration files directly using  the firewalld core with the IO handlers. firewall-offline-cmd can be  used while firewalld is running, but it is not recommended as it is only  able to alter the permanent configuration that are visible in firewall  after about five seconds.

More information on the firewalld D-Bus API is available [here](https://firewalld.org/documentation/man-pages/firewalld.dbus).

firewalld does not depend on NetworkManager, but the use is  recommended. If NetworkManager is not used, there are some limitations:  firewalld will not get notified about network device renames. If  firewalld gets started after the network is already up, the connections  and manually created interfaces are not bound to a zone. You can add  them to a zone with `firewall-cmd [--permanent] --zone=zone --add-interface=interface`, but make sure that if there’s a `/etc/sysconfig/network-scripts/ifcfg-<interface>`, the zone specified there with `ZONE=zone` is the same (or both are empty/missing for default zone), otherwise the behaviour would be undefined.

firewalld provides support for [zones](https://firewalld.org/documentation/zone/), [services](https://firewalld.org/documentation/service/), [IPSets](https://firewalld.org/documentation/ipset/) and [ICMP types](https://firewalld.org/documentation/icmptype/).

There is also a so called [direct interface](https://firewalld.org/documentation/direct-interface.html)  for use in daemons and applications and also to be able to add firewall  rules, that are not supported yet in firewalld directly.

# 概念

firewalld 具有两个设计层 ： 所述芯层和所述 D - Bus 上。内核层负责处理的后端配置和 iptables 一样 ， ip6tables ， ebtables ， ipset 和模块加载器。

 *firewalld 结构*

将 D - BUS 接口 firewalld 是主要的途径来改变和创建的防火墙配置。该接口用于所有 firewalld  提供在线工具、像例如 CMD - 防火墙、防火墙和应用程序防火墙 - - config 。防火墙 - - 离线 firewalld CMD  不对话 ， 但改变和创建配置文件用 firewalld firewalld 核心直接与 IO 处理程序。防火墙 - - 可以脱机使用 CMD  firewalld 同时运行 ， 但是不建议 ， 因为它是唯一能改变的 ， 永久配置在防火墙后可见约 5 秒。

更多信息 firewalld D - 总线 API 可[这里](https://firewalld.org/documentation/man-pages/firewalld.dbus)。

NetworkManager firewalld 不依赖 ， 但推荐使用。如果网络管理器不使用 ， 但仍存在一些局限性 ：  firewalld 不通知网络装置进行重命名。如果 firewalld 开始后已经是网络上 ，  这些连接和手动创建未绑定到的接口区。可以将它们添加到区域`firewall-cmd [--permanent] --zone=zone --add-interface=interface`但要确保如果有`/etc/sysconfig/network-scripts/ifcfg-<interface>`存在与指定的区域 ，`ZONE=zone`两者是相同的 (或默认是空的 / 缺失的区域 ） ， 否则行为未定义。

firewalld 提供支持[区](https://firewalld.org/documentation/zone/)，[服务](https://firewalld.org/documentation/service/)，[ipsets](https://firewalld.org/documentation/ipset/)和[ICMP 类型](https://firewalld.org/documentation/icmptype/)。

还有一个所谓[直接接口](https://firewalld.org/documentation/direct-interface.html)用于应用程序和后台程序 ， 还可以添加防火墙规则 ， 但在不支持直接 firewalld 。



# Configuration

The configuration for firewalld is stored in various XML files in the [configuration directories](https://firewalld.org/documentation/configuration/directories.html). This allows a great flexibility with fallbacks and system overrides.

## The Configuration Options

1.    [Directories](https://firewalld.org/documentation/configuration/directories.html)  
2.    [Runtime versus Permanent](https://firewalld.org/documentation/configuration/runtime-versus-permanent.html)  
3.    [firewalld.conf](https://firewalld.org/documentation/configuration/firewalld-conf.html)  

# 配置

该结构用于各种 firewalld 存储在 XML 文件中[目录配置](https://firewalld.org/documentation/configuration/directories.html)。这允许极大的灵活性和回退的系统覆盖。

## 配置选项

1.    [目录](https://firewalld.org/documentation/configuration/directories.html)  
2.    [相对于长期运行](https://firewalld.org/documentation/configuration/runtime-versus-permanent.html)  
3.    [firewalld.conf](https://firewalld.org/documentation/configuration/firewalld-conf.html)



# Directories

firewalld supports two configuration directories:

## Default and Fallback Configuration

The directory `/usr/lib/firewalld`  contains the default and fallback configuration provided by firewalld  for icmptypes, services and zones. The files provided with the firewalld  package should not get changed and the changes are gone with an update  of the firewalld package. Additional icmptypes, services and zones can  be provided with packages or by creating files.

## System Specific Configuration

The system or user configuration stored in `/etc/firewalld`  is either created by the system administrator or by customization with  the configuration interface of firewalld or by hand. The files will  overload the default configuration files.

To manually change settings of pre-defined icmptypes, zones or  services, copy the file from the default configuration directory to the  corresponding directory in the system configuration directory and change  it accordingly.

If there is no `/etc/firewalld`  directory of if it there is no configuration in there, firewalld will  start using the default configuration and default settings for `firewalld.conf`.

# Runtime versus Permanent

The configuration is separated into the runtime and the permanent configuration.

## Runtime Configuration

The runtime configuration is the actual effective configuration and  applied to the firewall in the kernel. At firewalld service start the  permanent configuration becomes the runtime configuration. Changes in  the runtime configuration are not automatically saved to the permanent  configuration.

The runtime configuration will be lost with a firewalld service stop.  A firewalld reload will replace the runtime configuration by the  permanent configuration. Changed zone bindings will be restored after  the reload.

## Permanent Configuration

The permanent configuration is stored in configuration files and will  be loaded and become new runtime configuration with every machine boot  or service reload/restart.

## Runtime to Permanent

The runtime environment can also be used to create a firewall setup  that fits the needs. When it is complete and working it can be migrated  with the runtime to permanent migration. It is available in `firewall-config` and `firewall-cmd`.

The firewall-cmd is:

```
firewall-cmd --runtime-to-permanent
```

If the firewall setup is not working, a simple firewalld reload/restart will reapply the working permanent configuration.

# firewalld.conf

The firewalld.conf file in `/etc/firewalld` provides the base configuration for firewalld. If it is absent or if `/etc/firewalld` is missing, the firewalld internal defaults will be used.

The settings listed below are the default values.

## Default Zone

The default zone used if an empty zone string is used. Everything  that is not explicitly bound to another zone will be handled by the  default zone.

```
DefaultZone=public
```

## Minimal Mark

Marks up to this minimum are free for use for example in the direct  interface. If more free marks are needed, increase the minimum.

```
MinimalMark=100
```

## Clean Up On Exit

If set to no or false the firewall configuration will not get cleaned up on exit or stop of firewalld.

```
CleanupOnExit=yes
```

## Lockdown

If set to enabled, firewall changes with the D-Bus interface will be  limited to applications that are listed in the lockdown whitelist. The  lockdown whitelist file is lockdown-whitelist.xml.

```
Lockdown=no
```

## IPv6_rpfilter

Performs a reverse path filter test on a packet for IPv6. If a reply  to the packet would be sent via the same interface that the packet  arrived on, the packet will match and be accepted, otherwise dropped.  The rp_filter for IPv4 is controlled using sysctl.

```
IPv6_rpfilter=yes
```

## Individual Calls

Do not use combined -restore calls, but individual calls. This  increases the time that is needed to apply changes and to start the  daemon, but is good for debugging.

```
IndividualCalls=no
```

## Log Denied

Add logging rules right before reject and drop rules in the INPUT,  FORWARD and OUTPUT chains for the default rules and also final reject  and drop rules in zones. Possible values are: `all`, `unicast`, `broadcast`, `multicast` and `off`.

```
LogDenied=off
```

​                            Recent Posts                        [Rich Rule Priorities](https://firewalld.org/2018/12/rich-rule-priorities)                            [firewalld 0.6.3 release](https://firewalld.org/2018/10/firewalld-0-6-3-release)                            [firewalld 0.6.2 release](https://firewalld.org/2018/09/firewalld-0-6-2-release)                            [firewalld 0.5.5 release](https://firewalld.org/2018/09/firewalld-0-5-5-release)                            [Testsuite Primer](https://firewalld.org/2018/08/testsuite-primer)                           Quick Links               [Report a new issue](https://github.com/firewalld/firewalld/issues/new)                 [Browse issues](https://github.com/firewalld/firewalld/issues)               



# Utilities

These are the tools that are part of firewalld:

-    [firewall-cmd](https://firewalld.org/documentation/utilities/firewall-cmd.html)  
-    [firewall-offline-cmd](https://firewalld.org/documentation/utilities/firewall-offline-cmd.html)  
-    [firewall-config](https://firewalld.org/documentation/utilities/firewall-config.html)  
-    [firewall-applet](https://firewalld.org/documentation/utilities/firewall-applet.html) 





防火墙被用来拦截那些不请自来的网络流量，然而不同网络需要的安全级别也不尽相同。比如说，和在外面一家咖啡馆里使用公共 WiFi  相比，你在家里的时候可以更加信任网络里的其它计算机和设备。你或许希望计算机能够区分可以信任和不可信任的网络，不过最好还是应该学会自己去管理（或者至少是核实）你的安全设置。

### 防火墙的工作原理

网络里不同设备之间的通信是通过一种叫做端口port的网关实现的。这里的端口指的并不是像 USB 端口 或者 HDMI 端口这样的物理连接。在网络术语中，端口是一个纯粹的虚拟概念，用来表示某种类型的数据到达或离开一台计算机时候所走的路径。其实也可以换个名字来称呼，比如叫“连接”或者“门口”，不过 [早在 1981 年的时候](https://tools.ietf.org/html/rfc793)[1] 它们就被称作端口了，这个叫法也沿用至今。其实端口这个东西没有任何特别之处，只是一种用来指代一个可能会发生数据传输的地址的方式。

1972 年，发布了一份 [端口号列表](https://tools.ietf.org/html/rfc433)[2]（那时候的端口被称为“套接字socket”），并且从此演化为一组众所周知的标准端口号，帮助管理特定类型的网络流量。比如说，你每天访问网站的时候都会使用  80 和 443 端口，因为互联网上的绝大多数人都同意（或者是默认）数据从 web  服务器上传输的时候是通过这两个端口的。如果想要验证这一点，你可以在使用浏览器访问网站的时候在 URL 后面加上一个非标准的端口号码。比如说，访问  `example.com:42` 的请求会被拒绝，因为 example.com 在 42 端口上并不提供网站服务。

![Navigating to a nonstandard port produces an error](https://img.linux.net.cn/data/attachment/album/201907/13/114508qjl4azm23y322tm2.png)

*Navigating to a nonstandard port produces an error*

如果你是通过 80 端口访问同一个网站，就可以（不出所料地）正常访问了。你可以在 URL 后面加上 `:80` 来指定使用 80 端口，不过由于 80 端口是 HTTP 访问的标准端口，所以你的浏览器其实已经默认在使用 80 端口了。

当一台计算机（比如说 web 服务器）准备在指定端口接收网络流量的时候，保持该端口向网络流量开放是一种可以接受的（也是必要的）行为。但是不需要接收流量的端口如果也处在开放状态就比较危险了，这就是需要用防火墙解决的问题。

#### 安装 firewalld

有很多种配置防火墙的方式，这篇文章介绍 [firewalld](https://firewalld.org/)[3]。在桌面环境下它被集成在网络管理器Network Manager里，在终端里则是集成在 `firewall-cmd` 里。很多 Linux 发行版都预装了这些工具。如果你的发行版里没有，你可以把这篇文章当成是管理防火墙的通用性建议，在你所使用的防火墙软件里使用类似的方法，或者你也可以选择安装 `firewalld`。

比如说在 Ubuntu 上，你必须启用 universe 软件仓库，关闭默认的 `ufw` 防火墙，然后再安装 `firewalld`：

```
$ sudo systemctl disable ufw
$ sudo add-apt-repository universe
$ sudo apt install firewalld
```

Fedora、CentOS、RHEL、OpenSUSE，以及其它很多发行版默认就包含了 `firewalld`。

无论你使用哪个发行版，如果希望防火墙发挥作用，就必须保持它在开启状态，并且设置成开机自动加载。你应该尽可能减少在防火墙维护工作上所花费的精力。

```
$ sudo systemctl enable --now firewalld
```

### 使用网络管理器选择区域

或许你每天都会连接到很多不同的网络。在工作的时候使用的是一个网络，在咖啡馆里是另一个，在家里又是另一个。你的计算机可以判断出哪一个网络的使用频率比较高，但是它并不知道哪一个是你信任的网络。

一个防火墙的区域zone里包含了端口开放和关闭的预设规则。你可以通过使用区域来选择一个对当前网络最适用的策略。

你可以打开网络管理器里的连接编辑器（可以在应用菜单里找到），或者是使用 `nm-connection-editor &` 命令以获取所有可用区域的列表。

![Network Manager Connection Editor](https://img.linux.net.cn/data/attachment/album/201907/13/114508k2f2fvzvf20yrzly.png)

*Network Manager Connection Editor*

在网络连接列表中，双击你现在所使用的网络。

在出现的网络配置窗口中，点击“通用”标签页。

在“通用”面板中，点击“防火墙区域”旁边的下拉菜单以获取所有可用区域的列表。

![Firewall zones](https://img.linux.net.cn/data/attachment/album/201907/13/114511w3t3zpoqdzo66op3.png)

*Firewall zones*

也可以使用下面的终端命令以获取同样的列表：

```
$ sudo firewall-cmd --get-zones
```

每个区域的名称已经可以透露出设计者创建这个区域的意图，不过你也可以使用下面这个终端命令获取任何一个区域的详细信息：

```
$ sudo firewall-cmd --zone work --list-all
work
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh dhcpv6-client
  ports:
  protocols:
  [...]
```

在这个例子中，`work` 区域的配置是允许接收 SSH 和 DHCPv6-client 的流量，但是拒绝接收其他任何用户没有明确请求的流量。（换句话说，`work` 区域并不会在你浏览网站的时候拦截 HTTP 响应流量，但是 **会** 拦截一个针对你计算机上 80 端口的 HTTP 请求。）

你可以依次查看每一个区域，弄清楚它们分别都允许什么样的流量。比较常见的有：

- `work`：这个区域应该在你非常信任的网络上使用。它允许 SSH、DHCPv6 和 mDNS，并且还可以添加更多允许的项目。该区域非常适合作为一个基础配置，然后在此之上根据日常办公的需求自定义一个工作环境。
- `public`： 用在你不信任的网络上。这个区域的配置和工作区域是一样的，但是你不应该再继续添加其它任何允许项目。
- `drop`：  所有传入连接都会被丢弃，并且不会有任何响应。在不彻底关闭网络的条件下，这已经是最接近隐形模式的配置了，因为只允许传出网络连接（不过随便一个端口扫描器就可以通过传出流量检测到你的计算机，所以这个区域并不是一个隐形装置）。如果你在使用公共  WiFi，这个区域可以说是最安全的选择；如果你觉得当前的网络比较危险，这个区域也一定是最好的选择。
- `block`： 所有传入连接都会被拒绝，但是会返回一个消息说明所请求的端口被禁用了。只有你主动发起的网络连接是被允许的。这是一个友好版的 `drop` 区域，因为虽然还是没有任何一个端口允许传入流量，但是说明了会拒绝接收任何不是本机主动发起的连接。
- `home`： 在你信任网络里的其它计算机的情况下使用这个区域。该区域只会允许你所选择的传入连接，但是你可以根据需求添加更多的允许项目。
- `internal`： 和工作区域类似，该区域适用于内部网络，你应该在基本信任网络里的计算机的情况下使用。你可以根据需求开放更多的端口和服务，同时保持和工作区域不同的一套规则。
- `trusted`： 接受所有的网络连接。适合在故障排除的情况下或者是在你绝对信任的网络上使用。

### 为网络指定一个区域

你可以为你的任何一个网络连接都指定一个区域，并且对于同一个网络的不同连接方式（比如以太网、WiFi 等等）也可以指定不同的区域。

选择你想要的区域，点击“保存”按钮提交修改。

![Setting a new zone](https://img.linux.net.cn/data/attachment/album/201907/13/114513drb7gmkdren3a7ja.png)

*Setting a new zone*

养成为网络连接指定区域的习惯的最好办法是从你最常用的网络开始。为你的家庭网络指定家庭区域，为工作网络指定工作区域，为你最喜欢的图书馆或者咖啡馆的网络指定公关区域。

一旦你为所有常用的网络都指定了一个区域，在之后加入新的网络的时候（无论是一个新的咖啡馆还是你朋友家的网络），试图也为它指定一个区域吧。这样可以很好地让你意识到不同的网络的安全性是不一样的，你并不会仅仅因为使用了 Linux 而比任何人更加安全。

### 默认区域

每次你加入一个新的网络的时候，`firewalld` 并不会提示你进行选择，而是会指定一个默认区域。你可以在终端里输入下面这个命令来获取你的默认区域：

```
$ sudo firewall-cmd --get-default
public
```

在这个例子里，默认区域是 `public` 区域。你应该保证该区域有非常严格的限制规则，这样在将它指定到未知网络中的时候才比较安全。或者你也可以设置你自己的默认区域。

比如说，如果你是一个比较多疑的人，或者需要经常接触不可信任的网络的话，你可以设置一个非常严格的默认区域：

```
$ sudo firewall-cmd --set-default-zone drop
success
$ sudo firewall-cmd --get-default
drop
```

这样一来，任何你新加入的网络都会被指定使用 `drop` 区域，除非你手动将它制定为另一个没有这么严格的区域。

### 通过开放端口和服务实现自定义区域

Firewalld 的开发者们并不是想让他们设定的区域能够适应世界上所有不同的网络和所有级别的信任程度。你可以直接使用这些区域，也可以在它们基础上进行个性化配置。

你可以根据自己所需要进行的网络活动决定开放或关闭哪些端口，这并不需要对防火墙有多深的理解。

#### 预设服务

在你的防火墙上添加许可的最简单的方式就是添加预设服务。严格来讲，你的防火墙并不懂什么是“服务”，因为它只知道端口号码和使用协议的类型。不过在标准和传统的基础之上，防火墙可以为你提供一套端口和协议的组合。

比如说，如果你是一个 web 开发者并且希望你的计算机对本地网络开放（这样你的同事就可以看到你正在搭建的网站了），可以添加 `http` 和 `https` 服务。如果你是一名游戏玩家，并且在为你的游戏公会运行开源的 [murmur](https://www.mumble.com/)[4] 语音聊天服务器，那么你可以添加 `murmur` 服务。还有其它很多可用的服务，你可以使用下面这个命令查看：

```
$ sudo firewall-cmd --get-services
    amanda-client amanda-k5-client bacula bacula-client \
    bgp bitcoin bitcoin-rpc ceph cfengine condor-collector \
    ctdb dhcp dhcpv6 dhcpv6-client dns elasticsearch \
    freeipa-ldap freeipa-ldaps ftp [...]
```

如果你找到了一个自己需要的服务，可以将它添加到当前的防火墙配置中，比如说：

```
$ sudo firewall-cmd --add-service murmur
```

这个命令 **在你的默认区域里** 添加了指定服务所需要的所有端口和协议，不过在重启计算机或者防火墙之后就会失效。如果想让你的修改永久有效，可以使用 `--permanent` 标志：

```
$ sudo firewall-cmd --add-service murmur --permanent
```

你也可以将这个命令用于一个非默认区域：

```
$ sudo firewall-cmd --add-service murmur --permanent --zone home
```

#### 端口

有时候你希望允许的流量并不在 `firewalld` 定义的服务之中。也许你想在一个非标准的端口上运行一个常规服务，或者就是想随意开放一个端口。

举例来说，也许你正在运行开源的 [虚拟桌游](https://opensource.com/article/18/5/maptool)[5] 软件 [MapTool](https://github.com/RPTools)[6]。由于 MapTool 服务器应该使用哪个端口这件事情并没有一个行业标准，所以你可以自行决定使用哪个端口，然后在防火墙上“开一个洞”，让它允许该端口上的流量。

实现方式和添加服务差不多：

```
$ sudo firewall-cmd --add-port 51234/tcp
```

这个命令 **在你的默认区域** 里将 51234 端口向 TCP 传入连接开放，不过在重启计算机或者防火墙之后就会失效。如果想让你的修改永久有效，可以使用 `--permanent` 标志：

```
$ sudo firewall-cmd --add-port 51234/tcp --permanent
```

你也可以将这个命令用于一个非默认区域：

```
$ sudo firewall-cmd --add-port 51234/tcp --permanent --zone home
```

在路由器的防火墙上设置允许流量和在本机上设置的方式是不同的。你的路由器可能会为它的内嵌防火墙提供一个不同的配置界面（原理上是相同的），不过这就超出本文范围了。

### 移除端口和服务

如果你不再需要某项服务或者某个端口了，并且设置的时候没有使用 `--permanent` 标志的话，那么可以通过重启防火墙来清除修改。

如果你已经将修改设置为永久生效了，可以使用 `--remove-port` 或者 `--remove-service` 标志来清除：

```
$ sudo firewall-cmd --remove-port 51234/tcp --permanent
```

你可以通过在命令中指定一个区域以将端口或者服务从一个非默认区域中移除。

```
$ sudo firewall-cmd --remove-service murmur --permanent --zone home
```

### 自定义区域

你可以随意使用 `firewalld` 默认提供的这些区域，不过也完全可以创建自己的区域。比如如果希望有一个针对游戏的特别区域，你可以创建一个，然后只有在玩儿游戏的时候切换到该区域。

如果想要创建一个新的空白区域，你可以创建一个名为 `game` 的新区域，然后重新加载防火墙规则，这样你的新区域就启用了：

```
$ sudo firewall-cmd --new-zone game --permanent
success
$ sudo firewall-cmd --reload
```

一旦创建好并且处于启用状态，你就可以通过添加玩游戏时所需要的服务和端口来实现个性化定制了。

### 勤勉

从今天起开始思考你的防火墙策略吧。不用着急，可以试着慢慢搭建一些合理的默认规则。你也许需要花上一段时间才能习惯于思考防火墙的配置问题，以及弄清楚你使用了哪些网络服务，不过无论是处在什么样的环境里，只要稍加探索你就可以让自己的  Linux 工作站变得更为强大。