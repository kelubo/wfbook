# 使用 RHEL 9 web 控制台管理系统

Red Hat Enterprise Linux 9

## 使用 Web 控制台在 RHEL 9 中管理系统的指南

Red Hat Customer Content Services

[法律通告](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#idm140015100854256)

**摘要**

​				本文档论述了如何使用 RHEL 9 web 控制台管理基于 Linux 的物理和虚拟系统。本文档假设用于管理的服务器在 RHEL 9 中运行。 		

------

# 让开源更具包容性

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。让我们了解如何改进它。 	

**根据具体内容提交评论**

1. ​					查看 **Multi-page HTML** 格式的文档，并确保在页面完全加载后看到右上角的 **Feedback** 按钮。 			
2. ​					使用光标突出显示您要评论的文本部分。 			
3. ​					点击在高亮文本旁的 **Add Feedback** 按钮。 			
4. ​					添加您的反馈并点击 **Submit**。 			

**通过 Bugzilla 提交反馈（需要帐户）**

1. ​					登录到 [Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=Red Hat Enterprise Linux 9&component=Documentation) 网站。 			
2. ​					从 **Version** 菜单中选择正确的版本。 			
3. ​					在 **Summary** 字段中输入描述性标题。 			
4. ​					在 **Description** 字段中输入您对改进的建议。包括文档相关部分的链接。 			
5. ​					点 **Submit Bug**。 			

# 第 1 章 使用 RHEL web 控制台入门

​			在 Red Hat Enterprise Linux 9 中安装 web 控制台，并了解如何在 RHEL 9 web 控制台中添加远程主机并监控它们。 	

**先决条件**

- ​					安装了 Red Hat Enterprise Linux 9。 			
- ​					启用网络功能。 			
- ​					注册的系统并附加适当的订阅。 			

## 1.1. 什么是 RHEL web 控制台

​				RHEL web 控制台是一个 Red Hat Enterprise Linux web 界面，用于管理和监控您的本地系统，以及网络环境中的 Linux 服务器。 		

​				RHEL web 控制台允许您执行广泛的管理任务，包括： 		

- ​						管理服务 				
- ​						管理用户帐户 				
- ​						管理及监控系统服务 				
- ​						配置网络接口和防火墙 				
- ​						检查系统日志 				
- ​						管理虚拟机 				
- ​						创建诊断报告 				
- ​						设置内核转储配置 				
- ​						配置 SELinux 				
- ​						更新软件 				
- ​						管理系统订阅 				

​				RHEL web 控制台使用与在终端中相同的系统 API，终端中执行的操作会立即反映在 RHEL web 控制台中。 		

​				您可以监控网络环境中的系统日志及其性能，以图形的形式显示。另外，您可以在 web 控制台中直接或通过终端更改设置。 		

## 1.2. 安装并启用 Web 控制台

​				要访问 RHEL 9 web 控制台，首先启用 `cockpit.socket` 服务。 		

​				在 Red Hat Enterprise Linux 9 的多个变体安装中都会默认包括 RHEL 9 web 控制台。如果您的系统每以包括，请在启用 `cockpit.socket` 服务前安装 `cockpit` 软件包。 		

**流程**

1. ​						如果在安装变体中没有默认安装 Web 控制台，请手动安装 `cockpit` 软件包： 				

   

   ```none
   # dnf install cockpit
   ```

2. ​						启用并启动 `cockpit.socket` 服务，该服务运行一个 Web 服务器： 				

   

   ```none
   # systemctl enable --now cockpit.socket
   ```

3. ​						如果在安装变体中没有默认安装 Web 控制台，且您使用自定义防火墙配置集，请将 `cockpit` 服务添加到 `firewalld` 中，以在防火墙中打开端口 9090： 				

   

   ```none
   # firewall-cmd --add-service=cockpit --permanent
   # firewall-cmd --reload
   ```

**验证步骤**

- ​						要验证之前的安装和配置，请打开 [web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

## 1.3. 登录到 Web 控制台

​				使用此流程中的步骤使用系统用户名和密码首次登录到 RHEL web 控制台。 		

**先决条件**

- ​						使用以下浏览器之一打开 Web 控制台： 				

  - ​								Mozilla Firefox 52 及更新的版本 						
  - ​								Google Chrome 57 及更新的版本 						
  - ​								Microsoft Edge 16 及更新的版本 						

- ​						系统用户帐户凭证 				

  ​						RHEL web 控制台使用位于 `/etc/pam.d/cockpit` 中的特定 PAM 堆栈。使用 PAM 进行身份验证可让您使用系统中任意本地帐户的用户名和密码登录。 				

**流程**

1. ​						在网页浏览器中打开 Web 控制台，输入以下地址： 				

   

   ```none
   https://localhost:9090
   ```

   注意

   ​							这会在本地机器上登录。如果要登录到远程系统的 Web 控制台，请参阅 [第 1.4 节 “从远程机器连接至 web 控制台”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#connecting-to-the-web-console-from-a-remote-machine_getting-started-with-the-rhel-9-web-console) 					

   ​						如果您使用自签名证书，浏览器会发出警告。检查证书并接受安全例外以进行登录。 				

   ​						控制台从 `/etc/cockpit/ws-certs.d` 目录中加载证书，并使用带有 `.cert` 扩展名的最后一个文件（按字母排序）。要避免接受安全例外的操作，安装由证书颁发机构（CA）签名的证书。 				

2. ​						在登录屏幕中输入您的系统用户名和密码。 				

3. ​						点 **Log In**。 				

​				成功验证后，会打开 RHEL web 控制台界面。 		

注意

​					要在有限和管理访问权限间进行切换，请在 web 控制台页面的顶部面板中点 **Administrative access** 或 **Limited access**。您必须提供用户密码以获取管理访问权限。 			

## 1.4. 从远程机器连接至 web 控制台

​				可以从任何客户端操作系统以及手机或数位屏连接至 Web 控制台界面。 		

**先决条件**

- ​						带有互联网浏览器的设备，例如： 				
  - ​								Mozilla Firefox 52 及更新的版本 						
  - ​								Google Chrome 57 及更新的版本 						
  - ​								Microsoft Edge 16 及更新的版本 						
- ​						您需要安装的并可访问 web 控制台的 RHEL 9 服务器。 				

**流程**

1. ​						打开浏览器。 				

2. ​						使用以下格式输入远程服务器地址： 				

   1. ​								使用服务器主机名：`https://server.hostname.example.com:port_number`。 						

      ​								例如： 						

      

      ```none
      https://example.com:9090
      ```

   2. ​								使用服务器的 IP 地址：`https://server.IP_address:port_number` 						

      ​								例如： 						

      

      ```none
      https://192.0.2.2:9090
      ```

3. ​						登录界面打开后，使用 RHEL 机器凭证登录。 				

## 1.5. 使用一次性密码登录到 web 控制台

​				如果您的系统是启用了一次性密码（OTP）配置的 Identity Management（IdM）域的一部分，您可以使用 OTP 登录到 RHEL web 控制台。 		

重要

​					只有在系统是启用了 OTP 配置的 Identity Management（IdM）域的一部分时，才可以使用一次性密码登录。 			

**先决条件**

- ​						已安装 RHEL web 控制台。 				
- ​						带有启用 OTP 配置的 Identity Management 服务器。 				
- ​						配置的硬件或软件设备生成 OTP 令牌。 				

**流程**

1. ​						在浏览器中打开 RHEL web 控制台： 				

   - ​								本地：`https://localhost:PORT_NUMBER` 						

   - ​								远程使用服务器主机名： `https://example.com:PORT_NUMBER` 						

   - ​								远程使用服务器 IP 地址： `https://EXAMPLE.SERVER.IP.ADDR:PORT_NUMBER` 						

     ​								如果您使用自签名证书，浏览器会发出警告。检查证书并接受安全例外以进行登录。 						

     ​								控制台从 `/etc/cockpit/ws-certs.d` 目录中加载证书，并使用带有 `.cert` 扩展名的最后一个文件（按字母排序）。要避免接受安全例外的操作，安装由证书颁发机构（CA）签名的证书。 						

2. ​						登录窗口将打开。在登录窗口中输入您的系统用户名和密码。 				

3. ​						在您的设备中生成一次性密码。 				

4. ​						在确认您的密码后，在 web 控制台界面中出现的新字段输入一次性密码。 				

5. ​						点**登录**。 				

6. ​						成功登录会进入 web 控制台界面的 **Overview** 页面。 				

## 1.6. 使用 Web 控制台重启系统

​				您可以使用 Web 控制台重启附加到 web 控制台的 RHEL 系统。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						在 **Overview** 页面中，点 Reboot 按钮。 				
3. ​						如果有任何用户登录到系统，在**重启**对话框中写入重启的原因。 				
4. ​						可选：在 **Delay** 下拉列表中，为重启延迟选择一个时间间隔。 				
5. ​						点**重启**。 				

## 1.7. 使用 Web 控制台关闭系统

​				您可以使用 Web 控制台关闭附加到 web 控制台的 RHEL 系统。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。 				

  **流程**

  1. ​								登录到 RHEL web 控制台。 						
  2. ​								点 **Overview**。 						
  3. ​								在**重启**下拉列表中选择 **Shut Down**。 						
  4. ​								如果有用户登录到该系统，在 **Shut Down** 对话框中写入关闭的原因。 						
  5. ​								可选：在 **Delay** 下拉列表中选择一个时间间隔。 						
  6. ​								点 **Shut Down**。 						

## 1.8. 使用 Web 控制台配置时间设置

​				您可以设置时区并将系统时间与网络时间协议（NTP）服务器同步。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。 				

  **流程**

  1. ​								登录到 RHEL web 控制台。 						

  2. ​								点**概述**中的当前系统时间。 						

  3. ​								点 **System time**。 						

  4. ​								在 **更改系统时间** 对话框中，根据需要更改时区。 						

  5. ​								在 **Set Time** 下拉菜单中选择以下之一 : 						

     - 手动

       ​											如果您需要手动设定时间，而不使用 NTP 服务器，则使用这个选项。 									

     - 自动使用 NTP 服务器

       ​											这是一个默认选项，它会自动与预设置的 NTP 服务器同步。 									

     - 自动使用特定的 NTP 服务器

       ​											只有在您需要将系统与特定 NTP 服务器同步时使用这个选项。指定服务器的 DNS 名称或 IP 地址。 									

  6. ​								点 **Change**。 						

- ​						检查在 **System** 标签页中显示的系统时间。 				

## 1.9. 使用 web 控制台禁用 SMT 以防止 CPU 安全问题

​				在出现滥用 CPU SMT 的攻击时禁用 Simultaneous Multi Threading（SMT）。禁用 SMT 可缓解安全漏洞（如 L1TF 或 MDS）对系统的影响。 		

重要

​					禁用 SMT 可能会降低系统性能。 			

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						在 **Overview** 选项卡中，找到 **系统信息** 字段并点**查看硬件详细信息**。 				

3. ​						在 **CPU Security** 行上，点 **Mitigations**。 				

   ​						如果这个链接不存在，这意味着您的系统不支持 SMT，因此不会受到这个安全漏洞的影响。 				

4. ​						在 **CPU Security Toggles** 表中，打开 **Disable simultaneous multithreading (nosmt)** 选项。 				

5. ​						点保存并重启按钮。 				

​				系统重启后，CPU 不再使用 SMT。 		

**其它资源**

- ​						[L1TF - L1 Terminal Fault Attack - CVE-2018-3620 & CVE-2018-3646](https://access.redhat.com/security/vulnerabilities/L1TF) 				
- ​						[MDS - Microarchitectural Data Sampling - CVE-2018-12130, CVE-2018-12126, CVE-2018-12127, and CVE-2019-11091](https://access.redhat.com/security/vulnerabilities/mds) 				

## 1.10. 在登录页面中添加标题

​				 公司或机构有时需要显示一个警告，提示计算机需要被合法使用，用户可能会被监控，非法用户可能会被提交到法律机构进行处理。这个警告信息需要在登录前显示。与 SSH 类似,Web 控制台也可以自选显示登录屏幕上横幅文件的内容。要在 web 控制台会话中启用横幅，您需要修改 `/etc/cockpit/cockpit.conf` 文件。请注意，这个文件并不是必需的，您可能需要手动创建该文件。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。 				
- ​						您必须具有 sudo 权限。 				

**流程**

1. ​						在您首选的文本编辑器中创建 `/etc/issue.cockpit` 文件（如果您还没有该文件）。添加您要显示的内容作为文件的横幅。 				

   ​						不要在文件中包括任何宏，因为文件内容和显示的内容之间没有格式变化。使用预期的换行。可以使用 ASCII 工件。 				

2. ​						保存这个文件。 				

3. ​						在您首选的文本编辑器中，在 `/etc/cockpit/` 目录中打开或创建 `cockpit.conf` 文件。 				

   

   ```none
   $ sudo vi cockpit.conf
   ```

4. ​						在文件中添加以下文本： 				

   

   ```none
   [Session]
   Banner=/etc/issue.cockpit
   ```

5. ​						保存这个文件。 				

6. ​						重启 Web 控制台以使更改生效。 				

   

   ```none
   # systemctl try-restart cockpit
   ```

**验证步骤**

- ​						再次打开 web 控制台登录屏幕，验证标题是否可见。 				

例 1.1. 在登录页面中添加示例标题

1. ​							使用文本编辑器创建带有所需文本的 `/etc/issue.cockpit` 文件： 					

   

   ```none
   This is an example banner for the RHEL web console login page.
   ```

2. ​							打开或创建 `/etc/cockpit/cockpit.conf` 文件并添加以下文本： 					

   

   ```none
   [Session]
   Banner=/etc/issue.cockpit
   ```

3. ​							重启 Web 控制台。 					

4. ​							再次打开 web 控制台登录屏幕。 					

   ​							[![cockpit login page banner](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a629ef7e92471ff3385db181f10b0fe8/cockpit-login-page-banner.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a629ef7e92471ff3385db181f10b0fe8/cockpit-login-page-banner.png) 						

## 1.11. 在 web 控制台中配置自动闲置锁定

​				默认情况下，Web 控制台界面中未设置闲置超时。如果要在系统中启用闲置超时，可以通过修改 `/etc/cockpit/cockpit.conf` 配置文件来实现。请注意，这个文件并不是必需的，您可能需要手动创建该文件。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						您必须具有 sudo 权限。 				

**流程**

1. ​						在您首选的文本编辑器中，在 `/etc/cockpit/` 目录中打开或创建 `cockpit.conf` 文件。 				

   

   ```none
   $ sudo vi cockpit.conf
   ```

2. ​						在文件中添加以下文本： 				

   

   ```none
   [Session]
   IdleTimeout=X
   ```

   ​						以分钟为单位，使用数字替换 **X**。 				

3. ​						保存该文件。 				

4. ​						重启 Web 控制台以使更改生效。 				

   

   ```none
   # systemctl try-restart cockpit
   ```

**验证步骤**

- ​						检查在设定的时间后，用户是否会退出系统。 				

# 第 2 章 在 web 控制台中配置主机名

​			了解如何使用 Red Hat Enterprise Linux web 控制台在附加到 web 控制台的系统中配置不同类型的主机名。 	

## 2.1. 主机名

​				用于识别该系统的主机名。默认情况下，主机名设定为 `localhost`，您可以修改它。 		

​				主机名由两个部分组成： 		

- 主机名

  ​							它是识别系统的唯一名称。 					

- 域

  ​							当在网络中使用系统以及使用名称而非 IP 地址时，将域作为主机名后面的后缀添加。 					

​				附加域名的主机名称为完全限定域名（FQDN）。例如： `mymachine.example.com`。 		

​				主机名保存在 `/etc/hostname` 文件中。 		

## 2.2. Web 控制台中的用户友善的主机名

​				您可以在 RHEL web 控制台中配置用户友善的主机名。用户友善的主机名是一个带有大写字母、空格等的主机名。 		

​				在 web 控制台中会显示用户友善的主机名，但不一定与主机名对应。 		

例 2.1. Web 控制台中的主机名格式

- 用户友善主机名

  ​								`My Machine` 						

- 主机名

  ​								`mymachine` 						

- 真实主机名 - 完全限定域名（FQDN）

  ​								`mymachine.idm.company.com` 						

## 2.3. 使用 Web 控制台设置主机名

​				此流程设置 web 控制台中的真实主机名或用户友善的主机名。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。 				

  **流程**

  1. ​								登录到 Web 控制台。 						

  2. ​								点 Overview。 						

  3. ​								点击当前主机名旁的 编辑。 						

     ​								[![cockpit hostname pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/085d79565a5e1d535ebb79b542838e3a/cockpit-hostname-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/085d79565a5e1d535ebb79b542838e3a/cockpit-hostname-pf4.png) 							

  4. ​								在 **更改主机名**对话框中，在 **Pretty Host Name**  字段中输入主机名。 						

  5. ​								**Real Host Name** 字段把域名附加到用户友善名。 						

     ​								如果它不与用户友善主机名，可以手动更改真实主机名。 						

  6. ​								点 Change。 						

     ​								[![cockpit hostname change pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/359c109fb13960779c52125cd0576646/cockpit-hostname-change-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/359c109fb13960779c52125cd0576646/cockpit-hostname-change-pf4.png) 							

**验证步骤**

1. ​						从 Web 控制台登出。 				

2. ​						通过在浏览器地址栏中输入新主机名重新打开 web 控制台。 				

   ​						[![cockpit hostname change verify pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b6412dff00a249a3efd20ac14bbaa040/cockpit-hostname-change-verify-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b6412dff00a249a3efd20ac14bbaa040/cockpit-hostname-change-verify-pf4.png) 					

# 第 3 章 Red Hat Web 控制台附加组件

​			在 RHEL web 控制台中安装附加组件，并了解可以使用哪些附加组件应用程序。 	

## 3.1. 安装附加组件

​				`cockpit` 软件包是 Red Hat Enterprise Linux 的一部分。为了可以使用附加应用程序，您必须单独安装它们。 		

**先决条件**

- ​						安装并启用 `cockpit` 软件包。 				

**流程**

- ​						安装附加组件。 				

  

  ```none
  # dnf install <add-on>
  ```

## 3.2. RHEL web 控制台的附加组件

​				下表列出了 RHEL web 控制台的可用附加组件应用程序。 		

| 功能名称          | 软件包名称                | 使用                                               |
| ----------------- | ------------------------- | -------------------------------------------------- |
| Composer          | cockpit-composer          | 构建自定义操作系统镜像                             |
| Machines          | cockpit-machines          | 管理 libvirt 虚拟机                                |
| PackageKit        | cockpit-packagekit        | 软件更新和应用程序安装（通常会被默认安装）         |
| PCP               | cockpit-pcp               | 具有持久性和更精细的性能数据（根据 UI 的要求安装） |
| Podman            | cockpit-podman            | 管理 Podman 容器                                   |
| Session Recording | cockpit-session-recording | 记录和管理用户会话                                 |

# 第 4 章 使用 Web 控制台优化系统性能

​			了解如何在 RHEL web 控制台中设置性能配置集，以便为所选任务优化系统性能。 	

## 4.1. Web 控制台中的性能调优选项

​				Red Hat Enterprise Linux 9 提供几个根据以下任务优化系统的性能配置集： 		

- ​						使用桌面的系统 				
- ​						吞吐性能 				
- ​						延迟性能 				
- ​						网络性能 				
- ​						低电源消耗 				
- ​						虚拟机 				

​				`TuneD` 服务优化系统选项以匹配所选配置集。 		

​				在 Web 控制台中，您可以设置系统使用的哪个性能配置集。 		

**其它资源**

- ​						[TuneD 入门](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/monitoring_and_managing_system_status_and_performance/index#getting-started-with-tuned_monitoring-and-managing-system-status-and-performance) 				

## 4.2. 在 Web 控制台中设置性能配置集

​				此流程使用 Web 控制台优化所选任务的系统性能。 		

**先决条件**

- ​						确保 Web 控制台已安装并可以访问。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Overview**。 				

3. ​						在 **Performance Profile** 字段中点击当前的性能配置集。 				

   ​						[![cockpit performance profile pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/3ea97976404610a779d097346ee6e4ab/cockpit-performance-profile-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/3ea97976404610a779d097346ee6e4ab/cockpit-performance-profile-pf4.png) 					

4. ​						如果需要，在 **Change Performance Profile** 对话框中修改配置集。 				

5. ​						点 **Change Profile**。 				

   ​						[![cockpit performance profile change pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/27ca9aeb62a34964f25d2da2f573f2e7/cockpit-performance-profile-change-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/27ca9aeb62a34964f25d2da2f573f2e7/cockpit-performance-profile-change-pf4.png) 					

**验证步骤**

- ​						**概述**标签现在显示所选的性能配置集。 				

## 4.3. 使用 Web 控制台监控本地系统的性能

​				Red Hat Enterprise Linux Web 控制台使用 Utilization Saturation and Errors (USE) 方法进行故障排除。新的性能指标页面带有最新数据，您可以对数据进行组织化的历史视图。 		

​				在这里，您可以查看资源利用率和饱和度的事件、错误和图形表示。 		

**先决条件**

- ​						Web 控制台已安装并可以访问。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

- ​						`cockpit-pcp` 软件包（启用收集性能指标）已安装： 				

  1. ​								从 Web 控制台界面安装软件包： 						

     1. ​										使用管理权限登录到 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 								
     2. ​										在 **Overview** 页面中，点 **View details 和 history**。 								
     3. ​										点 Install cockpit-pcp 按钮。 								
     4. ​										在**安装软件**对话框窗口中，点**安装**。 								

  2. ​								要从命令行界面安装软件包，请使用： 						

     

     ```none
     # dnf install cockpit-pcp
     ```

- ​						启用 PCP 服务： 				

  

  ```none
  # systemctl enable --now pmlogger.service pmproxy.service
  ```

**流程**

1. ​						登录到 RHEL 9 web 控制台。在 **Overview** 页面中，点 **View details 和 history** 以查看 **性能指标**。 				

   ​						[![View details and history](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7ffb19e6d983ec452ee0a99a88b961da/webconsole-view-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7ffb19e6d983ec452ee0a99a88b961da/webconsole-view-details.png) 					

   ​						[![Performance metrics in Web console](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c064da47ceff53424425a6f170633b22/webconsole-performance-metrics.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c064da47ceff53424425a6f170633b22/webconsole-performance-metrics.png) 					

## 4.4. 使用 Web 控制台和 Grafana 监控多个系统的性能

​				Grafana 可让您一次从多个系统中收集数据，并查看其所收集 PCP 指标的图形化表示。您可以在 web 控制台界面中的多个系统设置性能指标监控和导出。 		

​				此流程演示了如何通过 RHEL 9 web 控制台界面中的 PCP 启用性能指标导出。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

- ​						安装 `cockpit-pcp` 软件包。 				

  1. ​								在 Web 控制台界面中： 						

     1. ​										使用管理权限登录到 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 								
     2. ​										在 **Overview** 页面中，点 **View details 和 history**。 								
     3. ​										点 Install cockpit-pcp 按钮。 								
     4. ​										在**安装软件**对话框窗口中，点**安装**。 								
     5. ​										注销并再次登录以查看指标历史记录。 								

  2. ​								要从命令行界面安装软件包，请使用： 						

     

     ```none
     # dnf install cockpit-pcp
     ```

- ​						启用 PCP 服务： 				

  

  ```none
  # systemctl enable --now pmlogger.service pmproxy.service
  ```

- ​						设置 Grafana 仪表板。如需更多信息，请参阅[设置 grafana-server](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/monitoring_and_managing_system_status_and_performance/setting-up-graphical-representation-of-pcp-metrics_monitoring-and-managing-system-status-and-performance#setting-up-a-grafana-server_setting-up-graphical-representation-of-pcp-metrics)。 				

- ​						安装 `redis` 软件包。 				

  

  ```none
  # dnf install redis
  ```

  ​						或者，您可以稍后从 Web 控制台界面安装软件包。 				

**流程**

1. ​						在 **Overview** 页面中，点 **Usage** 表中的 **View details 和 history**。 				

2. ​						点 Metrics 设置 按钮。 				

3. ​						将 **Export to network** 滑块移到活跃位置。 				

   ​						![cockpit export to network slider](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e4e62b43bd43cbb79513eb28b1d1ad41/cockpit-export-to-network-slider.png) 					

   ​						如果您没有安装 `redis` 服务，则会提示您安装它。 				

4. ​						要打开 `pmproxy` 服务，请从下拉列表中选择区并点 Add pmproxy 按钮。 				

5. ​						点 **Save**。 				

**验证**

1. ​						点 **Networking**。 				
2. ​						在 **Firewall** 表中，点 **`n` active zones** 或 Edit rules and zones 按钮。 				
3. ​						在您选择的区域中搜索 `pmproxy`。 				

重要

​					在您要监视的所有系统中重复此步骤。 			

# 第 5 章 查看 web 控制台中的日志

​			了解如何在 RHEL web 控制台中访问、查看和过滤日志。 	

## 5.1. 查看 web 控制台中的日志

​				RHEL 9 web 控制台日志部分是 `journalctl` 实用程序的 UI。这部分论述了如何在 web 控制台界面中访问系统日志。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Logs**。 				

   ​						[![cockpit logs new](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/38e2161232cc59be90b9da06be7bf7c4/cockpit-logs-new.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/38e2161232cc59be90b9da06be7bf7c4/cockpit-logs-new.png) 					

3. ​						点击列表中的选定日志条目条目，打开日志条目详情。 				

注意

​					您可以使用 暂停 按钮在显示时暂停新日志条目。恢复新日志条目后，Web 控制台将加载您使用 Pause 按钮后报告的所有日志条目。 			

​				您可以根据时间、优先级或标识符过滤日志。如需更多信息，请参阅 [web 控制台中的过滤日志](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#filtering-logs-in-the-web-console_reviewing-logs) 		

## 5.2. 在 web 控制台中过滤日志

​				本节介绍如何过滤 web 控制台中的日志条目。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台界面。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Logs**。 				

3. ​						默认情况下，Web 控制台显示最新的日志条目。要根据具体时间范围过滤，请点 **Time** 下拉菜单并选择一个首选的选项。 				

   ​						[![cockpit logs time new](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/417d97925d2c43bcfccdb4c2f6b49b27/cockpit-logs-time-new.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/417d97925d2c43bcfccdb4c2f6b49b27/cockpit-logs-time-new.png) 					

4. ​						默认情况下会显示 **Error 及更高级别**的日志列表。要根据不同的优先级过滤，请点击 **Error 及更高**下拉菜单并选择一个首选的优先级。 				

   ​						[![cockpit logs priority](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a5cb0ab5400bbff78790dad445ebbee9/cockpit-logs-priority.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a5cb0ab5400bbff78790dad445ebbee9/cockpit-logs-priority.png) 					

5. ​						默认情况下，Web 控制台会显示所有标识符的日志。要过滤特定标识符的日志，请点 **All** 下拉菜单并选择标识符。 				

   ​						[![cockpit logs identifier](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5967153f30a9ef7e8062a6cd165b1ebd/cockpit-logs-identifier.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5967153f30a9ef7e8062a6cd165b1ebd/cockpit-logs-identifier.png) 					

6. ​						要打开日志条目，请点所选日志。 				

## 5.3. 在 web 控制台中过滤日志的文本搜索选项

​				文本搜索选项功能为过滤日志提供了大量选项。如果您决定使用文本搜索过滤日志，您可以使用三个下拉菜单中定义的预定义选项，或者您可以自己键入整个搜索。 		

**下拉菜单**

​					您可以使用三个下拉菜单来指定搜索的主参数： 			

- ​						**Time**:此下拉菜单包含搜索的不同时间范围的预定义搜索。 				
- ​						**Priority**:此下拉菜单提供了不同优先级级别的选项。它对应于 `journalctl --priority` 选项。默认优先级值为 **Error 及以上**。每次在不指定其它优先级时，会设置它。 				
- ​						**Identifier**:在这个下拉菜单中，您可以选择要过滤的标识符。对应于 `journalctl --identifier` 选项。 				

**限定符**

​					您可以使用六个限定符来指定搜索。它们包含在用于过滤日志表的 Options 中。 			

**日志字段**

​					如果要搜索特定日志字段，可以用其内容指定字段。 			

**在日志信息中进行自由文本搜索**

​					您可以在日志消息中过滤您选择的任何文本字符串。字符串也可以采用正则表达式的形式。 			

**高级日志过滤 I**

​					过滤 2020 年 10 月 22 日之后带有 'systemd' 识别的、日志字段 'JOB_TYPE' 是 'start' 或 'restart 的所有日志信息。 			

1. ​						在搜索字段中输入 `identifier:systemd since:2020-10-22 JOB_TYPE=start,restart`。 				

2. ​						检查结果。 				

   ​						[![advanced logs search I](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4ef01237c538c314da63ecda63a3ef49/advanced-logs-search-I.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4ef01237c538c314da63ecda63a3ef49/advanced-logs-search-I.png) 					

**高级日志过滤 II**

​					过滤上一次启动前出现的所有来自"cockpit.service' systemd 单元且邮件正文包含"error"或"fail"的所有日志消息。 			

1. ​						在搜索字段中输入 `service:cockpit boot:-1 error|fail`。 				

2. ​						检查结果。 				

   ​						[![advanced logs search II](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/22ab6caa6210f0c26eedfea12a64d358/advanced-logs-search-II.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/22ab6caa6210f0c26eedfea12a64d358/advanced-logs-search-II.png) 					

## 5.4. 使用文本搜索框过滤 web 控制台中的日志

​				通过使用文本搜索框，您可以根据不同的参数过滤日志。搜索合并了过滤下拉菜单、限定符、日志字段和自由格式字符串搜索的使用。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台界面。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Logs**。 				

3. ​						使用下拉菜单指定您想要过滤的三个主要的限定符 - 时间范围、优先级和标识符。 				

   ​						**优先级（Priority）** 限定符总需要有一个值。如果没有指定，它会自动过滤 **Error 及以上** 优先级。请注意，您设置的选项反映了在文本搜索框中。 				

4. ​						指定您要过滤的 log 字段。 				

   ​						可以添加几个日志字段。 				

5. ​						您可以使用自由格式的字符串搜索任何其他内容。搜索框也接受正则表达式。 				

## 5.5. 日志过滤选项

​				有几个 `journalctl` 选项可用于在 web 控制台中过滤日志，这或许非常有用。其中一些已作为 web 控制台界面的下拉菜单的一部分进行介绍。 		

表 5.1. 表

| 选项名称     | 使用                                                         | 备注                                                         |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `priority`   | 按消息优先级过滤输出。取单个数字或文本日志级别。日志级别是常见的 syslog 日志级别。如果指定了单一日志级别，则会显示具有此日志级别的所有消息或低（更重要）日志级别。 | 包括在**优先级**下拉菜单中。                                 |
| `identifier` | 显示被 syslog 标识为 SYSLOG_IDENTIFIER 的信息。可多次指定。  | 包括在 **标识符** 下拉菜单中。                               |
| `follow`     | 仅显示最新的日志条目，并在新条目附加到日志中时持续打印新条目。 | 没有包含在下拉菜单中。                                       |
| `service`    | 显示指定 `systemd` 单元的消息。可多次指定。                  | 没有包含在下拉菜单中。对应于 `journalctl --unit` 参数。      |
| `boot`       | 显示来自特定启动的消息。 						 						  							正整数代表从日志开始查找启动，等于或小于零的整数代表将从日志末尾查找启动。因此, 1 表示日志中的第一个引导（按时间顺序排列）， 2 为第 2 个，以此类推 ; -0 是最后一次引导，-1 是最后一次引导的前一个，以此类推。 | 在**时间**下拉菜单中作为 **Current boot** 或 **Previous boot**。其他选项需要手动编写。 |
| `since`      | 开始显示指定日期更新或分别位于指定日期或比指定日期旧的条目。日期规格应为 "2012-10-30  18:17:16"。如果省略了时间部分，使用 "00:00:00"。如果只省略了秒的组件，使用  ":00"。如果省略了日期的部分，使用当前日期。另外，还可以使用  "yesterday"、"today"、"tomorrow"（分别代表前一天、当天和明天的 00:00:00），以及  "now"（代表当前时间）。最后，可以指定相对时间，前缀为 "-" 或 "+"，分别引用当前时间前或之后的时间。 | 没有包含在下拉菜单中。                                       |

# 第 6 章 在 Web 控制台中管理用户帐户

​			RHEL web 控制台提供了一个添加、编辑和删除系统用户帐户的界面。 	

​			在阅读这个部分后，您将了解： 	

- ​					现有帐户来自哪里。 			
- ​					如何添加新帐户。 			
- ​					如何设置密码过期。 			
- ​					如何和何时终止用户会话。 			

**先决条件**

- ​					使用分配了管理员权限的帐户登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console) 			

## 6.1. Web 控制台中管理的系统用户帐户

​				您可在 RHEL web 控制台中显示用户帐户： 		

- ​						在访问系统时验证用户。 				
- ​						设置系统的访问权限。 				

​				RHEL web 控制台显示系统中的所有用户帐户。因此，在首次登录 web 控制台后，至少可以看到一个可用的用户帐户。 		

​				登录到 RHEL web 控制台后，您可以执行以下操作： 		

- ​						创建新用户帐户。 				
- ​						更改其参数。 				
- ​						锁定帐户。 				
- ​						终止用户会话。 				

## 6.2. 使用 Web 控制台添加新帐户

​				使用以下步骤将用户帐户添加到系统，并通过 RHEL web 控制台为帐户设置管理权限。 		

**先决条件**

- ​						必须安装并可以访问 RHEL web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

2. ​						点 Account。 				

3. ​						点 Create New Account。 				

4. ​						在 **Full Name** 字段中输入用户全名。 				

   ​						RHEL web 控制台会自动在全名中推荐用户名并在 **User Name** 字段中填充该用户名。如果您不想使用原始命名规则（由名的第一个字母和完整的姓组成），对它进行更新。 				

5. ​						在 **Password/Confirm** 字段中输入密码并重新输入该密码以便验证您的密码是否正确。 				

   ​						下面的颜色栏显示您输入密码的安全等级，这不允许您创建带弱密码的用户。 				

6. ​						点 Create 保存设置并关闭对话框。 				

7. ​						选择新创建的帐户。 				

8. ​						在 **Roles** 项中选择 **Server Administrator**。 				

   ​						[![cockpit terminate session pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/61b3085ccf79b2035be698dff0dcffe2/cockpit-terminate-session-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/61b3085ccf79b2035be698dff0dcffe2/cockpit-terminate-session-pf4.png) 					

   ​						现在您可以在 **Accounts** 设置中看到新帐户，您可以使用凭证连接到该系统。 				

## 6.3. 在 web 控制台中强制密码过期

​				默认情况下，用户帐户将密码设定为永远不会过期。您可以设置系统密码在指定的天数后过期。当密码过期时，下次登录尝试会提示密码更改。 		

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				
2. ​						点 Account。 				
3. ​						选择要强制密码过期的用户帐户。 				
4. ​						在用户帐户设置中，点第二个 编辑。 				
5. ​						在 **Password Expiration** 对话框中选择 **Require password change every … days** 并输入一个正数，代表密码过期的天数。 				
6. ​						点 Change。 				

**验证步骤**

- ​						要验证是否设定了密码过期时间，打开帐户设置。 				

  ​						RHEL 9 web 控制台显示与过期日期的链接。 				

  ​						[![cockpit password expiration date](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5eafe8a863cb6a6cbd826aa6fffc922c/cockpit-password-expiration-date.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5eafe8a863cb6a6cbd826aa6fffc922c/cockpit-password-expiration-date.png) 					

## 6.4. 在 web 控制台中终止用户会话

​				用户在登录系统时创建用户会话。终止用户会话意味着从系统中注销用户。如果您需要执行对配置更改敏感的管理任务，比如升级系统，这非常有用。 		

​				在 RHEL 9 web 控制台中的每个用户帐户中，您可以终止该帐户的所有会话，但您当前使用的 web 控制台会话除外。这可防止您丢失对您的系统的访问。 		

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 Account。 				

3. ​						点击要终止会话的用户帐户。 				

4. ​						点 Terminate Session。 				

   ​						如果 Terminate Session 按钮不可用，这个用户就不能登录到系统。 				

   ​						RHEL web 控制台会终止会话。 				

# 第 7 章 在 web 控制台中管理服务

​			了解如何在 RHEL web 控制台界面中管理系统服务。您可以激活或停用服务、重新启动或重新加载服务，或者管理它们的自动启动。 	

## 7.1. 在 web 控制台中激活或取消激活系统服务

​				此流程使用 Web 控制台界面激活或取消激活系统服务。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				

流程

​					您可以根据名称或描述以及 Enabled、Disabled 或 Static 自动启动过滤服务。接口显示服务的当前状态及其最近日志。 			

1. ​						使用管理员权限登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点左侧的 web 控制台菜单中的 **Services**。 				

3. ​						**服务**的默认标签页是 **System Services**。如果要管理目标、套接字、计时器或路径，请切换到顶部菜单中的相应选项卡。 				

   [![cockpit system services pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e1a9673af808b1e29a702fe47daed156/cockpit-system-services-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e1a9673af808b1e29a702fe47daed156/cockpit-system-services-pf4.png)

4. ​						要打开服务设置，请点击列表中的所选服务。您可以选择 **State** 列来告诉哪些服务处于活跃状态或不活跃。 				

5. ​						激活或取消激活服务： 				

   - ​								要激活不活跃的服务，点开始按钮。 						

     ​								![cockpit service start pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/823cdcd4a4cff5504431f0100b0efd6d/cockpit-service-start-pf4.png) 							

   - ​								要取消激活一个活跃的服务，点停止按钮。 						

     ​								[![cockpit service stop pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/89d2eb29a196e4fe2fc96b07c94e80cf/cockpit-service-stop-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/89d2eb29a196e4fe2fc96b07c94e80cf/cockpit-service-stop-pf4.png) 							

## 7.2. 在 web 控制台中重启系统服务

​				此流程使用 Web 控制台界面重启系统服务。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				

流程

​					您可以根据名称或描述以及 Enabled、Disabled 或 Static 自动启动过滤服务。接口显示服务的当前状态及其最近日志。 			

1. ​						使用管理员权限登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点左侧的 web 控制台菜单中的 **Services**。 				

3. ​						**服务**的默认标签页是 **System Services**。如果要管理目标、套接字、计时器或路径，请切换到顶部菜单中的相应选项卡。 				

   ​						[![cockpit system services pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e1a9673af808b1e29a702fe47daed156/cockpit-system-services-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e1a9673af808b1e29a702fe47daed156/cockpit-system-services-pf4.png) 					

4. ​						要打开服务设置，请点击列表中的所选服务。 				

5. ​						要重启某个服务，点重启按钮。 				

   ​						[![cockpit service restart pf4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7f12ef1a6878ac91acf8c830d2f84190/cockpit-service-restart-pf4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7f12ef1a6878ac91acf8c830d2f84190/cockpit-service-restart-pf4.png) 					

# 第 8 章 使用 Web 控制台配置网络绑定

​			了解网络绑定的工作原理并在 RHEL 9 web 控制台中配置网络绑定。 	

注意

​				RHEL 9 web 控制台基于 NetworkManager 服务构建。 		

​				详情请参阅[开始使用 NetworkManager 管理网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/index#getting-started-with-managing-networking-with-NetworkManager_configuring-and-managing-networking)。 		

**先决条件**

- ​					已安装并启用 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

## 8.1. 了解网络绑定

​				网络绑定（network bonding）是组合或者整合网络接口的方法，以便提供一个高吞吐量或冗余的逻辑接口。 		

​				`active-backup`、`balance-tlb` 和 `balance-alb` 模式不需要任何特定于网络交换机的配置。然而，其他绑定模式需要配置交换机来聚合链接。例如，Cisco 交换机需要 `EtherChannel` 来实现模式 0、2 和 3，但对于模式 4，需要链接聚合控制协议(LACP)和 `EtherChannel`。 		

​				详情请查看您的交换机和 [Linux 以太网捆绑驱动程序 HOWTO 文档](https://www.kernel.org/doc/Documentation/networking/bonding.txt)。 		

重要

​					某些网络绑定的功能，比如故障切换机制，不支持不通过网络交换机的直接电缆连接。详情请查看[是否支持直接连接的绑定？](https://access.redhat.com/solutions/202583)KCS 解决方案。 			

## 8.2. 绑定模式

​				RHEL 9 中有几个模式选项。每个模式选项都用特定的负载平衡和容错来定性。绑定接口的行为取决于模式。绑定模式提供容错、负载平衡或两者。 		

**负载均衡模式**

- ​						**Round Robin**:按顺序传输从第一个可用接口到最后一个接口的数据包。 				

**容错模式**

- ​						**Active Backup**:只有主接口失败时，其中一个备份接口会替换它。只有活动接口使用的 MAC 地址是可见的。 				

- ​						**Broadcast**:所有传输都将在所有接口上发送。 				

  注意

  ​							广播可显著增加所有绑定接口上的网络流量。 					

**容错和负载均衡模式**

- ​						**XOR**:目标 MAC 地址在具有 modulo 哈希的接口之间平均分配。然后，每个接口都提供相同的 MAC 地址组。 				

- ​						**802.3ad**:设置 IEEE 802.3ad 动态链路聚合策略。创建共享相同速度和双工设置的聚合组。在活跃聚合器中的所有接口上传输并接收接收。 				

  注意

  ​							此模式需要兼容 802.3ad 的交换机。 					

- ​						**自适应传输负载平衡** ：传出流量会根据每个接口上的当前负载进行分发。传入流量由当前接口接收。如果接收接口失败，另一个接口会接管失败的 MAC 地址。 				

- ​						**自适应负载平衡** ：包括 IPv4 流量的传输和接收负载平衡。 				

  ​						接收负载平衡是通过地址解析协议(ARP)协商来实现的，因此需要在绑定配置中将 **Link Monitoring** 设置为 **ARP**。 				

## 8.3. 使用 RHEL web 控制台配置网络绑定

​				如果您希望使用基于 Web 浏览器的界面管理网络设置，请使用 RHEL web 控制台配置网络绑定。 		

**先决条件**

- ​						已登陆到 RHEL web 控制台。 				
- ​						在服务器中安装两个或者两个以上物理或者虚拟网络设备。 				
- ​						要将以太网设备用作绑定的成员，必须在服务器中安装物理或者虚拟以太网设备。 				
- ​						要将 team、bridge 或 VLAN 设备用作绑定成员，请预先创建它们，如： 				
  - ​								[使用 RHEL web 控制台配置网络团队](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#proc_configuring-a-network-team-by-using-the-rhel-web-console_configuring-network-teaming) 						
  - ​								[使用 RHEL web 控制台配置网络桥接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking#proc_configuring-a-network-bridge-by-using-the-rhel-web-console_configuring-a-network-bridge) 						
  - ​								[使用 RHEL web 控制台配置 VLAN 标记](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-vlan-tagging_configuring-and-managing-networking#proc_configuring-vlan-tagging-by-using-the-rhel-web-console_configuring-vlan-tagging) 						

**流程**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡。 				

2. ​						在 `Interfaces` 部分点 Add bond。 				

3. ​						输入您要创建的绑定设备名称。 				

4. ​						选择应该是绑定成员的接口。 				

5. ​						选择绑定模式。 				

   ​						如果您选择 `Active backup`，Web 控制台会显示额外的 `Primary` 字段，您可以在其中选择首选的活动设备。 				

6. ​						设置链路监控模式。例如，当您使用 `Adaptive 负载均衡` 模式时，将它设置为 `ARP`。 				

7. ​						可选：调整监控间隔、连接延迟和链路延迟设置。通常，您只需要更改默认值以进行故障排除。 				

   ![绑定设置](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/28c01d3e4242ea42f96037e208f662e7/bond-settings.png)

8. ​						点应用。 				

9. ​						默认情况下，绑定使用动态 IP 地址。如果要设置静态 IP 地址： 				

   1. ​								在 `Interfaces` 部分点绑定的名称。 						

   2. ​								点您要配置的协议旁的 `Edit`。 						

   3. ​								选择 `Addresses` 旁的 `Manual`，并输入 IP 地址、前缀和默认网关。 						

   4. ​								在 `DNS` 部分，点 + 按钮，并输入 DNS 服务器的 IP 地址。重复此步骤来设置多个 DNS 服务器。 						

   5. ​								在 `DNS search domains` 部分中，点 + 按钮并输入搜索域。 						

   6. ​								如果接口需要静态路由，请在 `Routes` 部分配置它们。 						

      [![绑定团队网桥 vlan.ipv4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)

   7. ​								点 应用 						

**验证**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡，并检查接口上是否有传入和传出流量： 				

   [![bond 验证](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7eb80fb00d3136600392a9172ad9a8a4/bond-verify.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7eb80fb00d3136600392a9172ad9a8a4/bond-verify.png)

2. ​						从主机中临时删除网络电缆。 				

   ​						请注意，无法使用软件工具正确测试链路失败事件。取消激活连接的工具（如 Web 控制台）只显示处理成员配置更改且没有实际链路失败事件的能力。 				

3. ​						显示绑定状态： 				

   

   ```none
   # cat /proc/net/bonding/bond0
   ```

## 8.4. 使用 Web 控制台向绑定添加接口

​				网络绑定可以包含多个接口，您可以随时添加或删除任何接口。 		

​				了解如何在现有绑定中添加网络接口。 		

**先决条件**

- ​						使用配置了多个接口的绑定，如[使用 Web 控制台配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring-network-bonds-using-the-web-console_system-management-using-the-rhel-9-web-console#proc_configuring-a-network-bond-using-the-rhel-web-console_configuring-network-bonds-using-the-web-console)所述 				

**流程**

1. ​						登录到 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						打开 **网络**。 				

3. ​						在 **接口** 表中，点您要配置的绑定。 				

4. ​						在绑定设置屏幕中，滚动到成员表（接口）。 				

5. ​						点 Add member 下拉列表图标。 				

6. ​						从下拉菜单中选择接口并点它。 				

**验证步骤**

- ​						检查所选接口是否出现在绑定设置屏幕中的**接口成员**表中。 				

## 8.5. 使用 Web 控制台从绑定中删除或禁用接口

​				网络绑定可以包含多个接口。如果您需要更改设备，您可以从绑定中删除或者禁用特定接口，这样可处理剩余的活跃接口。 		

​				要使用绑定中包含的接口停止，您可以： 		

- ​						从绑定中删除接口。 				
- ​						暂时禁用接口。这个接口会保持绑定的一部分，但绑定不会使用它，除非您再次启用它。 				

**先决条件**

- ​						使用配置了多个接口的绑定，如[使用 Web 控制台配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring-network-bonds-using-the-web-console_system-management-using-the-rhel-9-web-console#proc_configuring-a-network-bond-using-the-rhel-web-console_configuring-network-bonds-using-the-web-console)所述 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						打开 **网络**。 				
3. ​						点击您要配置的绑定。 				
4. ​						在绑定设置屏幕中，滚动到端口表（接口）。 				
5. ​						选择接口并删除或禁用它： 				
   - ​								要删除接口，请点击 - 按钮。 						
   - ​								要禁用或启用接口，在所选接口旁切换切换。 						

​				根据您的选择，Web 控制台可以从绑定中删除或禁用接口，您可以在 **Networking** 部分作为独立接口重新看到它。 		

## 8.6. 使用 Web 控制台删除或禁用绑定

​				使用 Web 控制台删除或禁用网络绑定。如果您禁用绑定，接口保留在绑定中，但绑定不会用于网络流量。 		

**先决条件**

- ​						web 控制台中有一个现有绑定。 				

**流程**

1. ​						登录到 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						打开 **网络**。 				

3. ​						点击您要删除的绑定。 				

4. ​						在绑定设置屏幕中，您可以通过切换切换程序或点 Delete 按钮来永久删除绑定来禁用或启用绑定。 				

   ​						[![cockpit remove bond](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/550b414867ab2472496b3a73e98b2619/cockpit-remove-bond.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/550b414867ab2472496b3a73e98b2619/cockpit-remove-bond.png) 					

**验证步骤**

- ​						返回到 **网络**，并验证绑定中的所有接口现在都是独立接口。 				

# 第 9 章 使用 Web 控制台配置网络团队（network team）

​			了解网络绑定如何工作，网络团队和网络绑定之间的区别，以及 web 控制台中配置的可能性。 	

​			另外，您还可以参阅以下指南： 	

- ​					添加新网络团队 			
- ​					在现有网络团队中添加新接口 			
- ​					从现有网络组中删除接口 			
- ​					删除网络团队 			

重要

​				网络 teaming 在 Red Hat Enterprise Linux 9 中已弃用。如果您计划将服务器升级到将来的 RHEL 版本，请考虑使用内核绑定驱动程序作为替代方案。详情请参阅 [配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-bonding_configuring-and-managing-networking)。 		

**先决条件**

- ​					已安装并启用 RHEL web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

## 9.1. 了解网络团队

​				网络团队（network teaming）是一个合并或聚合网络接口的功能，它提供了一个高吞吐量或冗余的逻辑接口。 		

​				网络团队使用内核驱动程序来实现对数据包流、用户空间库以及用于其他任务的服务的快速处理。因此，网络团队是一个易扩展的解决方案，来满足负载平衡和冗余的要求。 		

重要

​					某些网络团队的功能，比如故障切换机制，不支持不通过网络交换机的直接电缆连接。详情请查看[是否支持直接连接的绑定？](https://access.redhat.com/solutions/202583) 			

## 9.2. 网络团队和绑定功能的比较

​				了解网络团队和网络绑定支持的功能： 		

| 功能                                | 网络绑定     | 网络团队     |
| ----------------------------------- | ------------ | ------------ |
| 广播 Tx 策略                        | 是           | 是           |
| 轮询 Tx 策略                        | 是           | 是           |
| Active-backup Tx 策略               | 是           | 是           |
| LACP（802.3ad）支持                 | 是（仅活动） | 是           |
| 基于 hash 的 Tx 策略                | 是           | 是           |
| 用户可以设置哈希功能                | 否           | 是           |
| TX 负载均衡支持（TLB）              | 是           | 是           |
| LACP 哈希端口选择                   | 是           | 是           |
| LACP 支持的负载均衡                 | 否           | 是           |
| ethtool 链接监控                    | 是           | 是           |
| ARP 链路监控                        | 是           | 是           |
| NS/NA（IPv6）链路监控               | 否           | 是           |
| 端口启动/关闭延时                   | 是           | 是           |
| 端口优先级和粘性（"主要" 选项增强） | 否           | 是           |
| 独立的每个端口链路监控设置          | 否           | 是           |
| 多个链路监控设置                    | 有限         | 是           |
| Lockless Tx/Rx 路径                 | 否（rwlock） | 是（RCU）    |
| VLAN 支持                           | 是           | 是           |
| 用户空间运行时控制                  | 有限         | 是           |
| 用户空间中的逻辑                    | 否           | 是           |
| 可扩展性                            | 难           | 易           |
| 模块化设计                          | 否           | 是           |
| 性能开销                            | 低           | 非常低       |
| D-Bus 接口                          | 否           | 是           |
| 多设备堆栈                          | 是           | 是           |
| 使用 LLDP 时零配置                  | 否           | （在计划中） |
| NetworkManager 支持                 | 是           | 是           |

## 9.3. 使用 RHEL web 控制台配置网络团队

​				如果您希望使用基于 Web 浏览器的界面管理网络设置，请使用 RHEL web 控制台来配置网络团队。 		

重要

​					网络 teaming 在 Red Hat Enterprise Linux 9 中已弃用。考虑使用网络绑定驱动程序作为替代方案。详情请参阅 [配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-bonding_configuring-and-managing-networking)。 			

**先决条件**

- ​						已安装 `teamd` 和 `NetworkManager-team` 软件包。 				
- ​						在服务器中安装两个或者两个以上物理或者虚拟网络设备。 				
- ​						要将以太网设备用作组的端口，必须在服务器中安装物理或者虚拟以太网设备并连接到交换机。 				
- ​						要将 bond、bridge 或 VLAN 设备用作团队的端口，请预先创建它们，如下所述： 				
- ​						[使用 RHEL web 控制台配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#proc_configuring-a-network-bond-by-using-the-rhel-web-console_configuring-network-teaming) 				
- ​						[使用 RHEL web 控制台配置网络桥接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking#proc_configuring-a-network-bridge-by-using-the-rhel-web-console_configuring-a-network-bridge) 				
- ​						[使用 RHEL web 控制台配置 VLAN 标记](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-vlan-tagging_configuring-and-managing-networking#proc_configuring-vlan-tagging-by-using-the-rhel-web-console_configuring-vlan-tagging) 				

**流程**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡。 				

2. ​						在 `Interfaces` 部分点 Add team。 				

3. ​						输入您要创建的团队设备名称。 				

4. ​						选择应该是团队端口的接口。 				

5. ​						选择团队的运行程序。 				

   ​						如果您选择 `Load balancing` 或 `802.3ad LACP`，Web 控制台会显示额外的 `Balancer` 字段。 				

6. ​						设置链接监视器： 				

   - ​								如果您选择 `Ethtool`，请设置链接并关闭延迟。 						
   - ​								如果您设置了 `ARP ping` 或 `NSNA ping`，还要设置 ping 间隔并 ping 目标。 						

   ![团队设置](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/40261fab9f753389526117eb22339366/team-settings.png)

7. ​						点应用。 				

8. ​						默认情况下，团队使用动态 IP 地址。如果要设置静态 IP 地址： 				

   1. ​								在 `Interfaces` 部分点团队的名称。 						

   2. ​								点您要配置的协议旁的 `Edit`。 						

   3. ​								选择 `Addresses` 旁的 `Manual`，并输入 IP 地址、前缀和默认网关。 						

   4. ​								在 `DNS` 部分，点 + 按钮，并输入 DNS 服务器的 IP 地址。重复此步骤来设置多个 DNS 服务器。 						

   5. ​								在 `DNS search domains` 部分中，点 + 按钮并输入搜索域。 						

   6. ​								如果接口需要静态路由，请在 `Routes` 部分配置它们。 						

      [![绑定团队网桥 vlan.ipv4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)

   7. ​								点 应用 						

**验证**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡，并检查接口上是否有传入和传出流量。 				

   [![团队验证](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/9d0d1abde2e82451bdadc815e6e9e8d8/team-verify.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/9d0d1abde2e82451bdadc815e6e9e8d8/team-verify.png)

2. ​						显示团队状态： 				

   

   ```none
   # teamdctl team0 state
   setup:
     runner: activebackup
   ports:
     enp7s0
       link watches:
         link summary: up
         instance[link_watch_0]:
           name: ethtool
           link: up
           down count: 0
     enp8s0
       link watches:
         link summary: up
         instance[link_watch_0]:
           name: ethtool
           link: up
           down count: 0
   runner:
     active port: enp7s0
   ```

   ​						在这个示例中，两个端口都是上线的。 				

**其它资源**

- ​						[网络团队运行程序](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#understanding-the-teamd-service-runners-and-link-watchers_configuring-network-teaming) 				

## 9.4. 使用 Web 控制台向团队添加新接口

​				网络团队可以包含多个接口，可以随时添加或删除任何接口。下面的部分论述了如何为现有团队添加新网络接口。 		

**先决条件**

- ​						配置了网络团队。 				

**流程**

1. ​						登录到 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						切换到 **Networking** 选项卡。 				

3. ​						在 **Interfaces** 表中，点您要配置的团队。 				

4. ​						在团队设置窗口中，向下滚动到 **Ports** 表。 				

5. ​						点 + 按钮。 				

6. ​						从下拉列表中选择您要添加的接口。 				

   ​						[![cockpit network team add interface](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f04a602c164dacc1fe9e5b592aa2718a/cockpit-network-team-add-interface.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f04a602c164dacc1fe9e5b592aa2718a/cockpit-network-team-add-interface.png) 					

​				RHEL web 控制台为团队添加接口。 		

## 9.5. 使用 Web 控制台从团队中删除或禁用接口

​				网络团队可以包含多个接口。如果您需要更改设备，可以从网络团队中删除或者禁用特定的接口，这些接口可与其它活跃接口一同工作。 		

​				可以使用两个选项停止一个团队中的一个接口： 		

- ​						从团队中删除接口 				
- ​						临时禁用该接口。这个接口会作为团队的一部分被保留，当在重新启用它之前不会被使用。 				

**先决条件**

- ​						主机上存在具有多个接口的网络组。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						切换到 **Networking** 选项卡。 				

3. ​						点您要配置的团队。 				

4. ​						在团队设置窗口中，向下滚动到端口表（接口）。 				

5. ​						选择一个接口并删除或禁用它。 				

   1. ​								将 ON/OFF 按钮切换为 Off 以禁用接口。 						

   2. ​								点 - 按钮删除接口。 						

      ​								[![cockpit team remove interface](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7706fb5e7f43db784118325322b3f78c/cockpit-team-remove-interface.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7706fb5e7f43db784118325322b3f78c/cockpit-team-remove-interface.png) 							

​				根据您的选择，Web 控制台会删除或禁用接口。如果删除该接口，它将作为独立接口在**网络**中可用。 		

## 9.6. 使用 Web 控制台删除或禁用团队

​				使用 Web 控制台删除或禁用网络团队。如果您只禁用该团队，则团队中的接口将保留在其中，但团队不会用于网络流量。 		

**先决条件**

- ​						主机上配置了网络组。 				

**流程**

1. ​						登录到 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						切换到 **Networking** 选项卡。 				

3. ​						点您要删除的团队删除或禁用。 				

4. ​						删除或禁用所选团队。 				

   1. ​								您可以点击 Delete 按钮删除团队。 						

   2. ​								您可以通过将 ON/OFF 开关切换到禁用的位置来禁用团队。 						

      ​								[![cockpit team remove](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7f74fb27eb409f72fcb80689dd6a42df/cockpit-team-remove.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7f74fb27eb409f72fcb80689dd6a42df/cockpit-team-remove.png) 							

**验证步骤**

- ​						如果您删除了该团队，请访问 **Networking**，并验证您的团队中的所有接口现在都列为独立接口。 				

# 第 10 章 在 web 控制台中配置网络桥接

​			网络桥接用于将多个接口连接到一个具有相同 IP 地址范围的子网。 	

**先决条件**

- ​					已安装并启用 RHEL 9 web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

## 10.1. 使用 RHEL web 控制台配置网络桥接

​				如果您希望通过基于 Web 浏览器的界面管理网络设置，请使用 RHEL web 控制台来配置网桥。 		

**先决条件**

- ​						在服务器中安装两个或者两个以上物理或者虚拟网络设备。 				
- ​						要将以太网设备用作网桥的端口，必须在服务器中安装物理或者虚拟以太网设备。 				
- ​						要使用 team、bond 或 VLAN 设备作为网桥的端口，您可以在创建桥接时创建这些设备，或者预先创建它们，如： 				
  - ​								[使用 RHEL web 控制台配置网络团队](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#proc_configuring-a-network-team-by-using-the-rhel-web-console_configuring-network-teaming) 						
  - ​								[使用 RHEL web 控制台配置网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#proc_configuring-a-network-team-by-using-the-rhel-web-console_configuring-network-teaming) 						
  - ​								[使用 RHEL web 控制台配置 VLAN 标记](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-vlan-tagging_configuring-and-managing-networking#proc_configuring-vlan-tagging-by-using-the-rhel-web-console_configuring-vlan-tagging) 						

**流程**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡。 				

2. ​						在 `Interfaces` 部分点 Add bridge。 				

3. ​						输入您要创建的网桥设备名称。 				

4. ​						选择应该是网桥端口的接口。 				

5. ​						可选：可选：启用 `生成树协议(STP)` 功能，以避免桥接循环和广播。 				

   ![网桥设置](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e758f042791734bacdcdff5e3b54f5c5/bridge-settings.png)

6. ​						点应用。 				

7. ​						默认情况下，网桥使用动态 IP 地址。如果要设置静态 IP 地址： 				

   1. ​								在 `Interfaces` 部分，点网桥的名称。 						

   2. ​								点您要配置的协议旁的 `Edit`。 						

   3. ​								选择 `Addresses` 旁的 `Manual`，并输入 IP 地址、前缀和默认网关。 						

   4. ​								在 `DNS` 部分，点 + 按钮，并输入 DNS 服务器的 IP 地址。重复此步骤来设置多个 DNS 服务器。 						

   5. ​								在 `DNS search domains` 部分中，点 + 按钮并输入搜索域。 						

   6. ​								如果接口需要静态路由，请在 `Routes` 部分配置它们。 						

      [![绑定团队网桥 vlan.ipv4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)

   7. ​								点 应用 						

**验证**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡，并检查接口上是否有传入和传出流量： 				

   [![网桥验证](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f4b42ba76f5890a0113eaaa9254ac6c0/bridge-verify.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f4b42ba76f5890a0113eaaa9254ac6c0/bridge-verify.png)

## 10.2. 使用 Web 控制台从网桥中删除接口

​				网络桥接可以包含多个接口。您可以从网桥中删除它们。每个删除的接口将自动改为独立接口。 		

​				了解如何从 RHEL 9 系统中创建的软件桥接中删除网络接口。 		

**先决条件**

- ​						在系统中使用带有多个接口的网桥。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						打开 **网络**。 				
3. ​						点击您要配置的网桥。 				
4. ​						在网桥设置屏幕中，滚动到端口表（接口）。 				
5. ​						选择一个接口并点 - 按钮。 				

**验证步骤**

- ​						前往 **Networking** 以检查您可以作为接口 **成员** 表中的独立接口。 				

## 10.3. 删除 web 控制台中的网桥

​				您可以删除 RHEL web 控制台中的软件网络桥接。网桥中包括的所有网络接口将自动改为独立接口。 		

**先决条件**

- ​						在您的系统中有一个桥接。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/managing_systems_using_the_rhel_8_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-8-web-console)。 				

2. ​						打开 **Networking** 部分。 				

3. ​						点击您要配置的网桥。 				

4. ​						点击 **Delete**。 				

   ​						[![cockpit bridge delete](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b72afe156b3040537573af58851d7cb4/cockpit-bridge-delete.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b72afe156b3040537573af58851d7cb4/cockpit-bridge-delete.png) 					

**验证步骤**

- ​						返回到 **Networking**，并验证所有网络接口都显示在接口 **成员** 表中。 				

​				之前作为网桥的一部分的一些接口可能会变得不活跃。如有必要，激活它们并手动设置网络参数。 		

# 第 11 章 在 web 控制台中配置 VLAN

​			这部分论述了如何配置虚拟本地区域网络（VLAN）。VLAN 是物理网络中的一个逻辑网络。当 VLAN 接口通过接口时，VLAN 接口标签带有 VLAN ID 的数据包，并删除返回的数据包的标签。 	

## 11.1. 使用 RHEL web 控制台配置 VLAN 标记

​				如果您希望使用基于 Web 浏览器的界面管理网络设置，请使用 RHEL web 控制台配置 VLAN 标记。 		

**先决条件**

- ​						您计划用作虚拟 VLAN 接口的父接口支持 VLAN 标签。 				
- ​						如果您在绑定接口之上配置 VLAN： 				
  - ​								绑定的端口是上线的。 						
  - ​								这个绑定没有使用 `fail_over_mac=follow` 选项进行配置。VLAN 虚拟设备无法更改其 MAC 地址以匹配父设备的新 MAC 地址。在这种情况下，流量仍会与不正确的源 MAC 地址一同发送。 						
  - ​								这个绑定通常不会预期从 DHCP 服务器或 IPv6 自动配置获取 IP 地址。禁用 IPv4 和 IPv6 协议创建绑定以确保它。否则，如果 DHCP 或 IPv6 自动配置在一段时间后失败，接口可能会关闭。 						
- ​						主机连接到的交换机被配置为支持 VLAN 标签。详情请查看您的交换机文档。 				

**流程**

1. ​						在屏幕左侧的导航中选择 `Networking` 选项卡。 				

2. ​						在 `Interfaces` 部分点 Add VLAN。 				

3. ​						选择父设备。 				

4. ​						输入 VLAN ID。 				

5. ​						输入 VLAN 设备的名称，或保留自动生成的名称。 				

   [![VLAN 设置](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/801dda277f220b3c96bdcb152d1487ef/vlan-settings.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/801dda277f220b3c96bdcb152d1487ef/vlan-settings.png)

6. ​						点应用。 				

7. ​						默认情况下，VLAN 设备使用动态 IP 地址。如果要设置静态 IP 地址： 				

   1. ​								点 `Interfaces` 部分中的 VLAN 设备名称。 						

   2. ​								点您要配置的协议旁的 `Edit`。 						

   3. ​								选择 `Addresses` 旁的 `Manual`，并输入 IP 地址、前缀和默认网关。 						

   4. ​								在 `DNS` 部分，点 + 按钮，并输入 DNS 服务器的 IP 地址。重复此步骤来设置多个 DNS 服务器。 						

   5. ​								在 `DNS search domains` 部分中，点 + 按钮并输入搜索域。 						

   6. ​								如果接口需要静态路由，请在 `Routes` 部分配置它们。 						

      [![绑定团队网桥 vlan.ipv4](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7994cde2fafedf1c5a1436807dc34096/bond-team-bridge-vlan.ipv4.png)

   7. ​								点 应用 						

**验证**

- ​						在屏幕左侧的导航中选择 `Networking` 选项卡，并检查接口上是否有传入和传出流量： 				

  [![VLAN 验证](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/85f426e0a5c782a8a6407d35d3d57bdc/vlan-verify.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/85f426e0a5c782a8a6407d35d3d57bdc/vlan-verify.png)

# 第 12 章 配置 Web 控制台侦听端口

​			了解如何使用 RHEL 9 web 控制台允许新端口或更改现有端口。 	

## 12.1. 在带有活跃 SELinux 的系统中允许一个新端口

​				启用 Web 控制台以侦听所选端口。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

- ​						对于未由 SELinux 其它部分定义的端口，请运行： 				

  

  ```none
  $ sudo semanage port -a -t websm_port_t -p tcp PORT_NUMBER
  ```

- ​						对于已经由 SELinux 其它部分定义的端口，请运行： 				

  

  ```none
  $ sudo semanage port -m -t websm_port_t -p tcp PORT_NUMBER
  ```

​				更改应该会立即生效。 		

## 12.2. 使用 firewalld 在系统中允许新端口

​				启用 Web 控制台在新端口上接收连接。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						`firewalld` 服务必须正在运行。 				

**流程**

1. ​						要添加新端口号，请运行以下命令： 				

   

   ```none
   $ sudo firewall-cmd --permanent --service cockpit --add-port=PORT_NUMBER/tcp
   ```

2. ​						要从 `cockpit` 服务中删除旧的端口号，请运行： 				

   

   ```none
   $ sudo firewall-cmd --permanent --service cockpit --remove-port=OLD_PORT_NUMBER/tcp
   ```

重要

​					如果您在没有使用 `--permanent` 选项的情况下运行 `firewall-cmd --service cockpit --add-port=PORT_NUMBER/tcp`，则更改将在下次重新加载 `firewalld` 或系统重启时消失。 			

## 12.3. 更改 Web 控制台端口

​				将端口 **9090** 上的默认传输控制协议(TCP)更改为不同的端口。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-{PeoductNumber}-web-console)。 				
- ​						如果您有 SELinux 保护系统，则需要将其设置为允许 Cockpit 侦听新端口。如需更多信息，请参阅[在带有活跃 SELinux 的系统上允许一个新端口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#allowing-a-new-port-with-selinux_configuring-the-web-console-listening-port)。 				
- ​						如果您将 `firewalld` 配置为您的防火墙，您需要将其设置为允许 Cockpit 在新端口上接收连接。如需更多信息，请参阅[使用 `firewalld` 在系统中允许新端口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#allowing-a-new-port-with-selinux_configuring-the-web-console-listening-port)。 				

**流程**

1. ​						使用以下方法之一更改侦听端口： 				

   1. ​								使用 `systemctl edit cockpit.socket` 命令： 						

      1. ​										运行以下命令： 								

         

         ```none
         $ sudo systemctl edit cockpit.socket
         ```

         ​										这将打开 `/etc/systemd/system/cockpit.socket.d/override.conf` 文件。 								

      2. ​										修改 `override.conf` 内容或以以下格式添加新内容： 								

         

         ```none
         [Socket]
         ListenStream=
         ListenStream=PORT_NUMBER
         ```

   2. ​								或者，将上述内容添加到 `/etc/systemd/system/cockpit.socket.d/listen.conf` 文件中。 						

      ​								创建 `cockpit.socket.d.` 目录和 `listen.conf` 文件（如果它们尚不存在）。 						

2. ​						运行以下命令使更改生效： 				

   

   ```none
   $ sudo systemctl daemon-reload
   $ sudo systemctl restart cockpit.socket
   ```

   ​						如果您在上一步中使用了 `systemctl edit cockpit.socket`，则不需要运行 `systemctl daemon-reload`。 				

**验证步骤**

- ​						要验证更改是否成功，请尝试使用新端口连接到 web 控制台。 				

​				 		

# 第 13 章 使用 Web 控制台管理防火墙

​			防火墙是保护机器不受来自外部的、不需要的网络数据影响的一种方式。它允许用户通过定义一组防火墙规则来控制主机上的入站网络流量。这些规则用于对进入的流量进行排序，并可以阻断或允许流量。 	

**先决条件**

- ​					RHEL 9 web 控制台配置 **firewalld** 服务。 			

  ​					有关 **firewalld** 服务的详情，请参阅[开始使用 firewalld](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_networking/index#getting-started-with-firewalld_using-and-configuring-firewalls)。 			

## 13.1. 使用 Web 控制台运行防火墙

​				这部分论述了如何在 web 控制台中运行 RHEL 9 系统防火墙的位置和方式。 		

注意

​					RHEL 9 web 控制台配置 **firewalld** 服务。 			

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						打开 **Networking** 部分。 				

3. ​						在 **Firewall** 部分，点滑块运行防火墙。 				

   ​						[![cockpit turn firewall on](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f58062b5fd0e5d8ff4921d64738df21f/cockpit_turn-firewall-on.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f58062b5fd0e5d8ff4921d64738df21f/cockpit_turn-firewall-on.png) 					

   ​						如果没有看到 **Firewall** slider，使用管理权限登录到 web 控制台。 				

​				在此阶段，您的防火墙正在运行。 		

​				要配置防火墙规则，请参阅[使用 Web 控制台在防火墙中启用服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#enabling-services-on-firewall-using-the-web-console_managing-firewall-using-the-web-console) 		

## 13.2. 使用 Web 控制台停止防火墙

​				这部分论述了如何在 web 控制台中停止 RHEL 9 系统防火墙的位置和方式。 		

注意

​					RHEL 9 web 控制台配置 **firewalld** 服务。 			

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						打开 **Networking** 部分。 				

3. ​						在 **Firewall** 部分，点滑块停止防火墙。 				

   ​						[![cockpit turn firewall off](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/0df6be97ae4fea67b629309801eb5394/cockpit_turn-firewall-off.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/0df6be97ae4fea67b629309801eb5394/cockpit_turn-firewall-off.png) 					

   ​						如果没有看到 **Firewall** slider，使用管理权限登录到 web 控制台。 				

​				在这个阶段，防火墙已经停止，且不会保护您的系统的安全。 		

## 13.3. Zones

​				可以根据用户对该网络中的接口和流量设置的信任程度，使用 `firewalld` 来将网络划分为不同的区。一个连接只能是一个区的一部分，但一个区可以被用来进行很多网络连接。 		

​				`NetworkManager` 通知接口区的 `firewalld`。您可以为接口分配区： 		

- ​						`NetworkManager` 				
- ​						`firewall-config` 工具 				
- ​						`firewall-cmd` 命令行工具 				
- ​						RHEL web 控制台 				

​				后三个只能编辑适当的 `NetworkManager` 配置文件。如果您使用 web 控制台 `firewall-cmd` 或 `firewall-config` 来更改接口的区，则请求将被转发到 `NetworkManager`，且不是由 ⁠`firewalld` 来处理。 		

​				预定义的区存储在 `/usr/lib/firewalld/zones/` 目录中，并可立即应用到任何可用的网络接口。只有在修改后，这些文件才会被拷贝到 `/etc/firewalld/zones/` 目录中。预定义区的默认设置如下： 		

- `block`

  ​							任何传入的网络连接都会被拒绝，并报 `IPv4` 的 icmp-host-prohibited 消息和 `IPv6` 的 icmp6-adm-prohibited 消息 。只有从系统启动的网络连接才能进行。 					

- `dmz`

  ​							对于您的非企业化区里的计算机来说，这些计算机可以被公开访问，且有限访问您的内部网络。只接受所选的入站连接。 					

- `drop`

  ​							所有传入的网络数据包都会丢失，没有任何通知。只有外发网络连接也是可行的。 					

- `external`

  ​							适用于启用了伪装的外部网络，特别是路由器。您不信任网络中的其他计算机不会损害您的计算机。只接受所选的入站连接。 					

- `home`

  ​							用于家用，因为您可以信任其他计算机。只接受所选的入站连接。 					

- `internal`

  ​							当您主要信任网络中的其他计算机时，供内部网络使用。只接受所选的入站连接。 					

- `public`

  ​							可用于您不信任网络中其他计算机的公共区域。只接受所选的入站连接。 					

- `trusted`

  ​							所有网络连接都被接受。 					

- `work`

  ​							可用于您主要信任网络中其他计算机的工作。只接受所选的入站连接。 					

​				这些区中的一个被设置为 *default* 区。当接口连接被添加到 `NetworkManager` 中时，它们会被分配到默认区。安装时，`firewalld` 中的默认区被设为 `public` 区。默认区可以被修改。 		

注意

​					网络区名称应该自我解释，并允许用户迅速做出合理的决定。要避免安全问题，请查看默认区配置并根据您的需要和风险禁用任何不必要的服务。 			

**其它资源**

- ​						`firewalld.zone (5)` 手册页。 				

## 13.4. Web 控制台中的区

​				Red Hat Enterprise Linux Web 控制台实现 firewalld 服务的主要功能，并可让您： 		

- ​						将预定义的防火墙区添加到特定接口或 IP 地址范围 				
- ​						在启用的服务列表中配置选择服务的区域 				
- ​						通过从已启用的服务列表中删除此服务来禁用服务 				
- ​						从接口中删除区 				

## 13.5. 使用 Web 控制台启用区

​				Web 控制台允许您在特定接口或者一系列 IP 地址中应用预定义和现有防火墙区。这部分论述了如何在接口中启用区。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				
- ​						必须启用防火墙。详情请参阅[使用 Web 控制台运行防火墙](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#running-firewall-using-the-web-console_managing-firewall-using-the-web-console)。 				

**流程**

1. ​						使用管理权限登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				

2. ​						点 **Networking**。 				

3. ​						点编辑规则和区域按钮。 				

   ​						[![cockpit edit rules and zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png) 					

   ​						如果没有看到 Edit rules and zones 按钮，使用管理员权限登录到 web 控制台。 				

4. ​						在 **Firewall** 部分，点 **Add new zone**。 				

5. ​						在 **Add zone** 对话框中，从**信任级别**选项选择一个区。 				

   ​						您可以在 `firewalld` 服务中看到所有预定义区域。 				

6. ​						在**接口**部分，选择一个应用所选区的接口或接口。 				

7. ​						在 **Allowed Addresses** 部分中，您可以选择是否应用该区： 				

   - ​								整个子网 						
   - ​								或者以以下格式表示的 IP 地址范围： 						
     - ​										192.168.1.0 								
     - ​										192.168.1.0/24 								
     - ​										192.168.1.0/24, 192.168.1.0 								

8. ​						点 Add zone 按钮。 				

   ​						[![cockpit add zone](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f83e21d20ef3cce3db3034a1512f4a99/cockpit_add-zone.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/f83e21d20ef3cce3db3034a1512f4a99/cockpit_add-zone.png) 					

​				验证**防火墙**中的配置。 		

​				[![cockpit active zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/52573e07bd7271caaba32b93744d139e/cockpit_active-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/52573e07bd7271caaba32b93744d139e/cockpit_active-zones.png) 			

## 13.6. 使用 Web 控制台在防火墙中启用服务

​				默认情况下，服务添加到默认防火墙区。如果在更多网络接口中使用更多防火墙区，您必须首先选择一个区域，然后添加带有端口的服务。 		

​				RHEL 9 web 控制台显示预定义的 `firewalld` 服务，您可以将其添加到活跃的防火墙区。 		

重要

​					RHEL 9 web 控制台配置 **firewalld** 服务。 			

​					Web 控制台不允许没有在 web 控制台中列出的通用 `firewalld` 规则。 			

**先决条件**

- ​						已安装 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				
- ​						必须启用防火墙。详情请参阅[使用 Web 控制台运行防火墙](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#running-firewall-using-the-web-console_managing-firewall-using-the-web-console)。 				

**流程**

1. ​						使用管理员权限登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Networking**。 				

3. ​						点编辑规则和区域按钮。 				

   ​						[![cockpit edit rules and zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png) 					

   ​						如果没有看到 Edit rules and zones 按钮，使用管理员权限登录到 web 控制台。 				

4. ​						在 **Firewall** 部分，选择要添加该服务的区，然后点击 **Add Services**。 				

   ​						[![cockpit add services](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/be466ba1b73aee638c1afbdf3f183a48/cockpit_add-services.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/be466ba1b73aee638c1afbdf3f183a48/cockpit_add-services.png) 					

5. ​						在 **Add Services** 对话框中，找到您要在防火墙中启用的服务。 				

6. ​						启用所需的服务。 				

   ​						[![cockpit add service](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/934b2f09b17e4fbc3bcf17ae2b1874a7/cockpit_add-service.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/934b2f09b17e4fbc3bcf17ae2b1874a7/cockpit_add-service.png) 					

7. ​						点 **Add Services**。 				

​				此时，RHEL 9 web 控制台在区域的**服务**列表中显示该服务。 		

## 13.7. 使用 Web 控制台配置自定义端口

​				Web 控制台允许您添加： 		

- ​						服务侦听标准端口：[使用 Web 控制台在防火墙中启用服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#enabling-services-on-firewall-using-the-web-console_managing-firewall-using-the-web-console) 				
- ​						服务侦听自定义端口。 				

​				这部分论述了如何使用配置了自定义端口添加服务。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				
- ​						必须启用防火墙。详情请参阅[使用 Web 控制台运行防火墙](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#running-firewall-using-the-web-console_managing-firewall-using-the-web-console)。 				

**流程**

1. ​						使用管理员权限登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Networking**。 				

3. ​						点编辑规则和区域按钮。 				

   ​						[![cockpit edit rules and zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png) 					

   ​						如果没有看到 Edit rules and zones 按钮，使用管理员权限登录到 web 控制台。 				

4. ​						在 **Firewall** 部分，选择要配置自定义端口的区域，并点 **Add Services**。 				

   ​						[![cockpit add services](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/be466ba1b73aee638c1afbdf3f183a48/cockpit_add-services.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/be466ba1b73aee638c1afbdf3f183a48/cockpit_add-services.png) 					

5. ​						在 **Add services** 对话框中，点 Custom Ports 单选按钮。 				

6. ​						在 TCP 和 UDP 字段中，根据示例添加端口。您可以使用以下格式添加端口： 				

   - ​								端口号，如 22 						
   - ​								端口号范围，如 5900-5910 						
   - ​								别名，比如 nfs, rsync 						

   注意

   ​							您可以在每个字段中添加多个值。值必须用逗号分开，且没有空格，例如：8080,8081,http 					

7. ​						在 **TCP** 文件、**UDP** 文件或两者中添加端口号后，在 **Name** 字段中验证服务名称。 				

   ​						**Name** 字段显示保留此端口的服务名称。如果您确定这个端口可用，且不需要在该端口上通信，则可以重写名称。 				

8. ​						在 **Name** 字段中，为服务添加一个名称，包括定义的端口。 				

9. ​						点添加端口按钮。 				

   ​						[![cockpit add ports](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4a27ff9eaf871424cbd95afbfbd4a2da/cockpit_add-ports.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4a27ff9eaf871424cbd95afbfbd4a2da/cockpit_add-ports.png) 					

​				要验证设置，请进入**防火墙**页面，并在区域的**服务**列表中找到该服务。 		

​				[![cockpit active zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/52573e07bd7271caaba32b93744d139e/cockpit_active-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/52573e07bd7271caaba32b93744d139e/cockpit_active-zones.png) 			

## 13.8. 使用 Web 控制台禁用区

​				这部分论述了如何使用 Web 控制台在防火墙配置中禁用防火墙区。 		

**先决条件**

- ​						已安装 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#getting-started-with-the-rhel-9-web-console_system-management-using-the-RHEL-9-web-console)。 				

**流程**

1. ​						使用管理员权限登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Networking**。 				

3. ​						点编辑规则和区域按钮。 				

   ​						[![cockpit edit rules and zones](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/d27aacd3d967e45ae56180ca6ac5ae2e/cockpit_edit-rules-and-zones.png) 					

   ​						如果没有看到 Edit rules and zones 按钮，使用管理员权限登录到 web 控制台。 				

4. ​						点您要删除的区的 **Options** 图标。 				

   ​						[![cockpit delete zone](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/32c4cc4561732a522bebeb5c055e987a/cockpit_delete-zone.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/32c4cc4561732a522bebeb5c055e987a/cockpit_delete-zone.png) 					

5. ​						点击 **Delete**。 				

​				区域现在被禁用，接口不包括在区域中配置的打开的服务和端口。 		

# 第 14 章 在 web 控制台中设置系统范围的加密策略

​			您可以从预定义的系统范围的加密策略级别进行选择，并在 Red Hat Enterprise Linux Web 控制台界面中直接切换它们。如果在您的系统中设置了自定义策略，Web 控制台会在 **Overview** 页面和 **Change crypto 策略**对话窗口中显示策略。 	

**先决条件**

- ​					已安装 RHEL 9 web 控制台。详情请参阅[安装和启用 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			
- ​					有管理员特权。 			

**流程**

1. ​					登录到 RHEL web 控制台。如需更多信息，请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 			
2. ​					在 **Overview** 页面的 **Configuration** 卡中，点 **Crypto 策略**旁的当前策略值。 			
3. ​					在 **Change crypto policy** 对话框窗口中，点您要开始使用的策略级别。 			
4. ​					点应用并重新引导按钮。 			

**验证**

- ​					重新登录，检查 **Crypto 策略**值是否对应于您选择的值。 			

# 第 15 章 应用生成的 Ansible playbook

​			在对 SELinux 问题进行故障排除时，Web 控制台能够生成 shell 脚本或 Ansible playbook，然后导出并应用给更多机器。 	

**先决条件**

- ​					需要已安装并可以访问 Web 控制台界面。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

**流程**

1. ​					点 **SELinux**。 			

2. ​					点右上角的"查看自动化脚本"。 			

   ​					此时会打开一个带有生成的脚本的窗口。您可以在 shell 脚本页和 Ansible playbook 生成选项页之间转换。 			

   ​					[![cockpit ansible playbook generated](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/047a2d7a8061c93fb9e84edec574b443/cockpit-ansible-playbook-generated.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/047a2d7a8061c93fb9e84edec574b443/cockpit-ansible-playbook-generated.png) 				

3. ​					点 Copy to clipboard 按钮选择脚本或 playbook 并应用它。 			

​			因此，您有一个可应用到更多机器的自动脚本。 	

**其它资源**

- ​					[与 SELinux 相关的故障排除问题](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux) 			
- ​					[在多个系统中部署相同的 SELinux 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/using_selinux/deploying-the-same-selinux-configuration-on-multiple-systems_using-selinux) 			
- ​					有关 `ansible-playbook` 命令的详情，请查看 `ansible-playbook(1)` 手册页。 			

# 第 16 章 使用 Web 控制台管理分区

​			了解如何使用 web 控制台管理 RHEL 9 上的文件系统。 	

​			有关可用文件系统的详情，请查看[可用文件系统概述](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_file_systems/assembly_overview-of-available-file-systems_managing-file-systems)。 	

## 16.1. 在 web 控制台中显示使用文件系统格式化的分区

​				Web 控制台中的 **Storage** 部分会在 **Filesystems** 表中显示所有可用文件系统。 		

​				本节导航至使用 web 控制台中显示的文件系统分区列表。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						点 **Storage** 选项卡。 				

​				在 **Filesystems** 表中，您可以看到使用文件系统格式化的所有可用分区、其名称、大小以及每个分区中有多少可用空间。 		

​				[![cockpit filesystems partitions](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7aa30da5bbdb55237d1b954c5949bfed/cockpit-filesystems-partitions.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/7aa30da5bbdb55237d1b954c5949bfed/cockpit-filesystems-partitions.png) 			

## 16.2. 在 web 控制台中创建分区

​				创建新分区： 		

- ​						使用现有的分区表 				
- ​						创建分区 				

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						在**存储**标签的**其它设备**表中可见连接到该系统的未格式化卷。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Storage** 选项卡。 				

3. ​						在**其它设备**表中，点您要在其中创建分区的卷。 				

4. ​						在**内容**部分，点创建分区按钮。 				

5. ​						在**创建新分区**对话框中选择新分区的大小。 				

6. ​						在 **Erase** 下拉菜单中选择： 				

   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个磁盘。使用这个选项较慢，因为程序必须经过整个磁盘，但它更为安全。如果磁盘包含任何数据且需要覆盖数据，则使用这个选项。 						

7. ​						在 **Type** 下拉菜单中选择一个文件系统： 				

   - ​								**XFS** 文件系统支持大的逻辑卷，在不停止工作的情况下在线切换物理驱动器，并可以增大现有的文件系统。如果您没有不同的首选项，请保留这个文件系统。 						
   - ​								**ext4** 文件系统支持： 						
     - ​										逻辑卷 								
     - ​										在不停止工作的情况下在线切换物理驱动器 								
     - ​										增大文件系统 								
     - ​										缩小文件系统 								

   ​						额外的选项是启用 LUKS（Linux 统一密钥设置）完成的分区加密，该加密可让您使用密码短语加密卷。 				

8. ​						在 **Name** 字段输入逻辑卷名称。 				

9. ​						在 **Mounting** 下拉菜单中选择 **Custom**。 				

   ​						**Default** 选项不会保证在下次引导时挂载该文件系统。 				

10. ​						在 **Mount Point** 字段中添加挂载路径。 				

11. ​						选择 **Mount at boot**。 				

12. ​						点创建分区按钮。 				

    ​						根据卷大小以及选择格式化选项，格式化可能需要几分钟。 				

    ​						成功完成格式化后，您可以在 **Filesystem** 标签页中看到格式化逻辑卷的详情。 				

**验证步骤**

- ​						要验证分区是否已成功添加，切换到 **Storage** 选项卡并检查 **Filesystems** 表。 				

## 16.3. 删除 web 控制台中的分区

​				下面的步骤教您如何删除 web 控制台界面中的分区。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

- ​						卸载分区的文件系统。 				

  ​						有关挂载和卸载分区的详情，请参阅[在 web 控制台中挂载和卸载文件系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#mounting-and-unmounting-file-systems-in-the-web-console_managing-partitions-using-the-web-console) 				

**步骤**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Storage** 选项卡。 				

3. ​						在 **Filesystems** 表中，选择一个要删除分区的卷。 				

4. ​						在 **Content** 部分，点您要删除的分区。 				

5. ​						分区将关闭，您可以点删除按钮。 				

   ​						该分区不能挂载和使用。 				

**验证步骤**

- ​						要验证分区是否已成功删除，切换到 **Storage** 选项卡并检查**内容**表。 				

## 16.4. 在 web 控制台中挂载和卸载文件系统

​				为了能够在 RHEL 系统中使用分区，您需要在分区中作为一个设备挂载文件系统。 		

注意

​					您还可以卸载文件系统，RHEL 系统将会停止使用它。卸载文件系统可让您删除、删除或重新格式化设备。 			

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						如果要卸载文件系统，请确保系统没有使用存储在分区中的任何文件、服务或应用程序。 				

**步骤**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点 **Storage** 选项卡。 				

3. ​						在 **Filesystems** 表中，选择一个要删除分区的卷。 				

4. ​						在**内容**部分，点您要挂载或卸载的文件系统的分区。 				

5. ​						点 Mount 或 Unmount 按钮。 				

   ​						此时，文件系统已被挂载或卸载。 				

# 第 17 章 在 web 控制台中管理 NFS 挂载

​			RHEL 9 web 控制台允许您使用网络文件系统(NFS)协议挂载远程目录。 	

​			NFS 使可以访问并挂载位于网络上的远程目录，并像位于物理驱动器上一样处理文件。 	

**先决条件**

- ​					已安装 RHEL 9 web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/managing_systems_using_the_rhel_8_web_console/index#installing-the-web-console_getting-started-with-the-rhel-8-web-console)。 			

- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

- ​					NFS 服务器名称或 IP 地址。 			

- ​					到远程服务器中的目录的路径。 			

## 17.1. 在 web 控制台中连接 NFS 挂载

​				使用 NFS 将远程目录连接到文件系统。 		

**先决条件**

- ​						NFS 服务器名称或 IP 地址。 				
- ​						到远程服务器中的目录的路径。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						在 **NFS 挂载**部分点 **+**。 				

   ​						[![cockpit add NFS mount](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fc95710496283d46505b52b206e0dcab/cockpit-add-NFS-mount.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fc95710496283d46505b52b206e0dcab/cockpit-add-NFS-mount.png) 					

4. ​						在**新建 NFS Mount** 对话框中输入远程服务器的服务器或者 IP 地址。 				

5. ​						在 **Server 的 路径**字段输入您要挂载的目录的路径。 				

6. ​						在 **Local Mount Point** 字段中输入您要在本地系统中查找该目录的路径。 				

7. ​						选择 **Mount at boot**。这样可保证重启本地系统后也可以访问该目录。 				

8. ​						另外，如果您不想更改内容，选择 **Mount read only**。 				

   ​						[![cockpit NFS mount new](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/0152ffc2922c8556e646f59bf2e25a2b/cockpit-NFS-mount-new.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/0152ffc2922c8556e646f59bf2e25a2b/cockpit-NFS-mount-new.png) 					

9. ​						点击 **Add**。 				

**验证步骤**

- ​						打开挂载的目录，并验证内容可以访问。 				

​				要排除连接的问题，您可以使用 [自定义挂载选项调整它](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#customizing-nfs-mount-options-in-the-web-console_managing-nfs-mounts-in-the-web-console)。 		

## 17.2. 在 web 控制台中自定义 NFS 挂载选项

​				编辑现有 NFS 挂载并添加自定义挂载选项。 		

​				自定义挂载选项可帮助您排除 NFS 挂载的连接或更改参数，如更改超时限制或配置验证。 		

**先决条件**

- ​						添加了 NFS 挂载。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						点击您要调整的 NFS 挂载。 				

4. ​						如果挂载了远程目录，点 **Unmount**。 				

   ​						该目录不能在自定义挂载选项配置过程中挂载。否则，Web 控制台不会保存配置，这会导致错误。 				

1. ​						点 **Edit**。 				

1. ​						在 **NFS Mount** 对话框中，选择**自定义挂载选项**。 				
2. ​						输入用逗号分开的挂载选项。例如： 				
   - ​								`nfsvers=4` — NFS 协议版本号 						
   - ​								`soft` — 一个 NFS 请求超时时的恢复类型 						
   - ​								`sec=krb5` - NFS 服务器上的文件可以通过 Kerberos 身份验证进行保护。NFS 客户端和服务器都必须支持 Kerberos 验证。 						

​				如需 NFS 挂载选项的完整列表，请在命令行中输入 `man nfs`。 		

1. ​						点**应用**。 				
2. ​						点 **Mount**。 				

**验证步骤**

- ​						打开挂载的目录，并验证内容可以访问。 				

# 第 18 章 在 web 控制台中管理独立磁盘的冗余阵列

​			RAID 代表如何将多个磁盘设置为一个存储。RAID 可以保护在磁盘出现故障时磁盘中存储的数据。 	

​			RAID 使用以下数据发布策略： 	

- ​					镜像 - 数据被复制到两个不同的位置。如果一个磁盘失败，因为您有一个副本，就不会丢失数据。 			
- ​					条带 - 数据在磁盘间平均分布。 			

​			保护级别取决于 RAID 级别。 	

​			RHEL web 控制台支持以下 RAID 级别： 	

- ​					RAID 0（条带） 			
- ​					RAID 1（镜像） 			
- ​					RAID 4（专用奇偶校验） 			
- ​					RAID 5（分布奇偶校验） 			
- ​					RAID 6（双倍分布奇偶校验） 			
- ​					RAID 10（镜像的条带） 			

​			在 RAID 中使用磁盘前，您需要： 	

- ​					创建 RAID。 			
- ​					使用文件系统格式化它。 			
- ​					将 RAID 挂载到服务器。 			

**先决条件**

- ​					RHEL 9 web 控制台已安装并可以访问。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			
- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

## 18.1. 在 web 控制台中创建 RAID

​				在 RHEL 9 web 控制台中配置 RAID。 		

**先决条件**

- ​						连接到该系统的物理磁盘。每个 RAID 级别都需要不同的磁盘。 				

**流程**

1. ​						打开 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						点 **Devices** 表中的菜单图标。 				

4. ​						点**创建 RAID 设备**。 				

5. ​						在**创建 RAID 设备**对话框中，为新 RAID 输入一个名称。 				

6. ​						在 **RAID 级别**下拉列表中，选择您要使用的 RAID 级别。 				

7. ​						在 **Chunk Size** 下拉列表中，保留预先定义的值。 				

   ​						**Chunk Size** 值指定数据写入的每个块的大小。如果块大小为 512 KiB，系统会将第一个 512 KiB 写入第一个磁盘，第二个 512 KiB 写入第二个磁盘，第三个块将写入第三个磁盘。如果您的 RAID 有三个磁盘，则第四个 512 KiB 将再次写入第一个磁盘。 				

8. ​						选择您要用于 RAID 的磁盘。 				

9. ​						点击 **Create**。 				

**验证步骤**

- ​						进入 **Storage** 部分，并在 **RAID 设备**框中看到新 RAID 并进行格式化。 				

​				您可以选择在 web 控制台中格式化并挂载新 RAID： 		

​				[格式化 RAID](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#formatting-raid-in-the-web-console_managing-redundant-arrays-of-independent-disks-in-the-web-console) 		

​				[在分区表中创建分区](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#using-the-web-console-for-creating-a-partition-table-on-raid_managing-redundant-arrays-of-independent-disks-in-the-web-console) 		

​				[在 RAID 上创建卷组](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#using-the-web-console-for-creating-volume-group-on-top-of-raid_managing-redundant-arrays-of-independent-disks-in-the-web-console) 		

## 18.2. 在 web 控制台中格式化 RAID

​				格式化在 RHEL 9 web 界面中创建的新软件 RAID 设备。 		

**先决条件**

- ​						RHEL 9 已连接并看到物理磁盘。 				
- ​						创建 RAID。 				
- ​						考虑用于 RAID 的文件系统。 				
- ​						考虑创建分区表。 				

**流程**

1. ​						打开 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						在 **RAID 设备**框中，点您需要格式化的 RAID。 				

4. ​						在 RAID 详情屏幕中，向下滚动到 **内容**部分。 				

5. ​						点新创建的 RAID。 				

6. ​						点 Format 按钮。 				

7. ​						在 **Erase** 下拉列表中选择： 				

   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个磁盘。这个选项较慢，因为程序必须经过整个磁盘。如果 RAID 包含任何数据且需要重写数据，则使用这个选项。 						

8. ​						在 **Type** 下拉列表中，如果您没有其他需要的首选项，选择 XFS 文件系统。 				

9. ​						输入文件系统的名称。 				

10. ​						在 **Mounting** 下拉列表中选择 **Custom**。 				

    ​						**Default** 选项不会保证在下次引导时挂载该文件系统。 				

11. ​						在 **Mount Point** 字段中添加挂载路径。 				

12. ​						选择 **Mount at boot**。 				

13. ​						点 Format 按钮。 				

    ​						根据使用的格式化选项和 RAID 大小,格式化的过程可能需要几分钟。 				

    ​						成功完成后，您可以在 **Filesystem** 标签页中看到格式化的 RAID 的详情。 				

14. ​						要使用 RAID，点 **Mount**。 				

​				此时，系统使用挂载并格式化的 RAID。 		

## 18.3. 使用 Web 控制台在 RAID 上创建分区表

​				在 RHEL 9 接口中创建的新软件 RAID 设备中使用分区表格式化 RAID。 		

​				与任何其他存储设备一样，RAID 也需要格式化。您有两个选项： 		

- ​						格式化没有分区的 RAID 设备 				
- ​						创建带有分区的分区表 				

**先决条件**

- ​						物理磁盘已连接并可见。 				
- ​						创建 RAID。 				
- ​						考虑用于 RAID 的文件系统。 				
- ​						考虑创建一个分区表。 				

**流程**

1. ​						打开 RHEL 9 控制台。 				
2. ​						点击 **Storage**。 				
3. ​						在 **RAID 设备**框中，选择您要编辑的 RAID。 				
4. ​						在 RAID 详情屏幕中，向下滚动到 **内容**部分。 				
5. ​						点新创建的 RAID。 				
6. ​						点 Create partition table 按钮。 				
7. ​						在 **Erase** 下拉列表中选择： 				
   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个 RAID。这个选项的速度较慢，因为程序必须经过整个 RAID。如果 RAID 包含任何数据且需要重写数据，则使用这个选项。 						
8. ​						在**分区**下拉列表中选择： 				
   - ​								Compatible with modern system and hard disks > 2TB (GPT) — 对于具有超过四个分区的大型 RAID，GUID 分区表是一个现代推荐的系统。 						
   - ​								Compatible with all systems and devices (MBR) — MBR 可以在最大为 2 TB 的磁盘中使用。MBR 也最多支持四个主分区。 						
9. ​						点 **Format**。 				

​				此时创建了分区表，您可以创建分区。 		

​				有关创建分区，请参阅 [使用 Web 控制台在 RAID 上创建分区](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/managing-redundant-arrays-of-independent-disks-in-the-web-console_system-management-using-the-rhel-9-web-console#creating-partitions-on-raid-using-the-web-console_managing-redundant-arrays-of-independent-disks-in-the-web-console)。 		

## 18.4. 使用 Web 控制台在 RAID 上创建分区

​				在现有分区表中创建一个分区。 		

**先决条件**

- ​						已创建分区表。详情请参阅 [使用 Web 控制台在 RAID 上创建分区表](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#using-the-web-console-for-creating-a-partition-table-on-raid_managing-redundant-arrays-of-independent-disks-in-the-web-console) 				

**流程**

1. ​						打开 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						在 **RAID 设备**框中，点您要编辑的 RAID。 				

4. ​						在 RAID 详情屏幕中，向下滚动到 **内容**部分。 				

5. ​						点新创建的 RAID。 				

6. ​						点**创建分区**。 				

7. ​						在**创建分区** 对话框中设置第一个分区的大小。 				

8. ​						在 **Erase** 下拉列表中选择： 				

   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个 RAID。这个选项的速度较慢，因为程序必须经过整个 RAID。如果 RAID 包含任何数据且需要重写数据，则使用这个选项。 						

9. ​						在 **Type** 下拉列表中，如果您没有其他需要的首选项，选择 XFS 文件系统。 				

10. ​						为文件系统输入任意名称。不要在名称中使用空格。 				

11. ​						在 **Mounting** 下拉列表中选择 **Custom**。 				

    ​						**Default** 选项不会保证在下次引导时挂载该文件系统。 				

12. ​						在 **Mount Point** 字段中添加挂载路径。 				

13. ​						选择 **Mount at boot**。 				

14. ​						点 **Create partition**。 				

​				根据使用的格式化选项和 RAID 大小,格式化的过程可能需要几分钟。 		

​				成功完成后，您可以继续创建其他分区。 		

​				此时，系统使用挂载的和格式化的 RAID。 		

## 18.5. 使用 Web 控制台在 RAID 上创建卷组

​				从软件 RAID 构建卷组。 		

**先决条件**

- ​						没有格式化并挂载的 RAID 设备。 				

**流程**

1. ​						打开 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						点 **卷组** 框中的 + 按钮。 				

4. ​						在**创建新卷组**对话框中，为新卷组输入一个名称。 				

5. ​						在 **Disks** 列表中，选择一个 RAID 设备。 				

   ​						如果您在列表中没有看到 RAID，从系统中卸载 RAID。RHEL 9 系统不能使用 RAID 设备。 				

6. ​						点击 **Create**。 				

​				新的卷组已经创建，您可以继续创建逻辑卷。 		

# 第 19 章 使用 Web 控制台配置 LVM 逻辑卷

​			Red Hat Enterprise Linux 9 支持 LVM 逻辑卷管理器。安装 Red Hat Enterprise Linux 9 时，它将在安装时自动创建的 LVM 中安装。 	

​			[![cockpit lvm rhel](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e2d32a3ab4e80cb9b6764f8a41b12728/cockpit-lvm-rhel.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/e2d32a3ab4e80cb9b6764f8a41b12728/cockpit-lvm-rhel.png) 		

​			截屏显示 RHEL 9 系统全新安装的 web 控制台视图，在安装过程中自动创建两个逻辑卷。 	

​			要找到更多有关逻辑卷的信息，请按照以下小节进行描述： 	

- ​					[什么是逻辑卷管理器以及何时使用它](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logical-volume-manager-in-the-web-console_configuring-lvm-logical-volumes-using-the-web-console) 			
- ​					[什么是卷组以及如何创建它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-volume-groups-in-the-web-console_configuring-lvm-logical-volumes-using-the-web-console) 			
- ​					[什么是逻辑卷以及如何创建它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-logical-volumes-in-the-web-console_configuring-lvm-logical-volumes-using-the-web-console) 			
- ​					[如何格式化逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#formatting-logical-volumes-in-the-web-console_configuring-lvm-logical-volumes-using-the-web-console) 			
- ​					[如何重新定义逻辑卷大小](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#resizing-logical-volumes-in-the-web-console_configuring-lvm-logical-volumes-using-the-web-console) 			

**先决条件**

- ​					已安装 RHEL 9 web 控制台。 			

  ​					具体步骤请参阅[安装并启用 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

- ​					您可以创建逻辑卷的物理驱动器、RAID 设备或其他类型的块设备。 			

## 19.1. Web 控制台中的逻辑卷管理器

​				RHEL 9 web 控制台提供了一个图形界面来创建 LVM 卷组和逻辑卷。 		

​				卷组在物理卷和逻辑卷之间创建一个层。这样就可以在没有任何逻辑卷本身的情况下添加或删除物理卷。卷组显示为一个驱动器，其容量由组中包含的所有物理驱动器的容量组成。 		

​				您可以在 web 控制台中将物理驱动器加入到卷组中。 		

​				逻辑卷作为单一物理驱动器使用，它构建在系统中的卷组之上。 		

​				逻辑卷的主要优点是： 		

- ​						比您的物理驱动器中使用的分区系统具有更大的灵活性。 				
- ​						能够将更多物理驱动器连接到一个卷中。 				
- ​						在不重启的情况下，可以在线扩展（增加）或缩减（减少）卷的容量。 				
- ​						能够创建快照。 				

**其它资源**

- ​						[配置和管理逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_logical_volumes) 				

## 19.2. 在 web 控制台中创建卷组

​				从一个或多个物理驱动器或者其它存储设备创建卷组。 		

​				从卷组创建逻辑卷。每个卷组都可以包括多个逻辑卷。 		

​				详情请查看[管理 LVM 卷组](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/managing-lvm-volume-groups_configuring-and-managing-logical-volumes)。 		

**先决条件**

- ​						要创建卷组的物理驱动器或其他类型的存储设备。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 Storage。 				

3. ​						在 **Devices** 部分，从下拉菜单中选择 **Create LVM2 卷组**。 				

   ​						![cockpit adding volume groups](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b3f060f54dace9d572e8984d8ada92a1/cockpit-adding-volume-groups.png) 					

4. ​						在 **Name** 字段中输入一个没有空格的组群名称。 				

5. ​						选择您要组合的驱动器来创建卷组。 				

   ​						[![cockpit create volume group](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/ad42c8a4eff60ae46ab19d8bafe4a243/cockpit-create-volume-group.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/ad42c8a4eff60ae46ab19d8bafe4a243/cockpit-create-volume-group.png) 					

   ​						可能会象预期一样查看设备。RHEL web 控制台仅显示未使用的块设备。使用的设备意味着： 				

   - ​								使用文件系统格式化的设备 						

   - ​								另一个卷组中的物理卷 						

   - ​								物理卷是另一个软件 RAID 设备的成员 						

     ​								如果您没有看到该设备，将其格式化，使其为空且未被使用。 						

6. ​						点击 Create。 				

​				Web 控制台在 **Devices** 部分添加卷组。在点组后，您可以创建从那个卷组中分配的逻辑卷。 		

​				![cockpit volume group](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5477d12d24f5a6cce04ac2b1e39b8477/cockpit-volume-group.png) 			

## 19.3. 在 web 控制台中创建逻辑卷

​				逻辑卷作为物理驱动器使用。您可以使用 RHEL 9 web 控制台在卷组中创建 LVM 逻辑卷。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						已创建的卷组。详情请参阅在 [web 控制台中创建卷组](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/using-the-web-console-for-configuring-lvm-logical-volumes_system-management-using-the-rhel-9-web-console#creating-volume-groups-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 Storage。 				

3. ​						在 **Devices** 部分，点您要创建逻辑卷的卷组。 				

4. ​						在**逻辑卷**部分，点 创建新逻辑卷。 				

5. ​						在**名称**字段输入新逻辑卷名称,没有空格。 				

6. ​						在 Purpose 下拉菜单中，选择 **Block device for filesystems**。 				

   ​						此配置允许您创建一个逻辑卷，其最大卷大小等于卷组中所含所有驱动器的总和。 				

   ​						[![cockpit lv block dev](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/340894d9c966fc303de51cb5e7b1e43e/cockpit-lv-block-dev.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/340894d9c966fc303de51cb5e7b1e43e/cockpit-lv-block-dev.png) 					

7. ​						定义逻辑卷的大小。考虑： 				

   - ​								使用这个逻辑卷的系统所需的空间。 						
   - ​								您要创建的逻辑卷数量。 						

   ​						您可以选择不使用整个空间。如果需要，您可以稍后增大逻辑卷。 				

   ​						[![cockpit lv size](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c475c206d0cca8d7123e7ca133b7d0f7/cockpit-lv-size.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c475c206d0cca8d7123e7ca133b7d0f7/cockpit-lv-size.png) 					

8. ​						点 Create。 				

​				要验证设置，点您的逻辑卷并检查详情。 		

​				[![cockpit lv details](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png) 			

​				在这个阶段，创建了逻辑卷，您需要使用格式化过程创建并挂载文件系统。 		

## 19.4. 在 web 控制台中格式化逻辑卷

​				逻辑卷作为物理驱动器使用。要使用它们，您需要使用文件系统进行格式化。 		

警告

​					格式化逻辑卷将擦除卷中的所有数据。 			

​				您选择的文件系统决定了可用于逻辑卷的配置参数。例如：有些 XFS 文件系统不支持缩小卷。详情请查看 [web 控制台中重新定义逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/using-the-web-console-for-configuring-lvm-logical-volumes_system-management-using-the-rhel-9-web-console#resizing-logical-volumes-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)大小。 		

​				以下步骤描述了格式化逻辑卷的步骤。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						已创建逻辑卷。详情请参阅[在 web 控制台中创建逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/using-the-web-console-for-configuring-lvm-logical-volumes_system-management-using-the-rhel-9-web-console#creating-logical-volumes-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 Storage。 				

3. ​						在 **Devices** 部分，点放置逻辑卷的卷组。 				

4. ​						在**逻辑卷**部分，点 Format。 				

   ​						[![cockpit lv details](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png) 					

5. ​						在 **Name** 字段中输入文件系统的名称。 				

6. ​						在 Type 下拉菜单中选择一个文件系统： 				

   - ​								**XFS** 文件系统支持大的逻辑卷，在不停止工作的情况下在线切换物理驱动器，并可以增大现有的文件系统。如果您没有不同的首选项，请保留这个文件系统。 						

     ​								XFS 不支持缩小使用 XFS 文件系统格式的卷大小 						

   - ​								**ext4** 文件系统支持： 						

     - ​										逻辑卷 								
     - ​										在不停止工作的情况下在线切换物理驱动器 								
     - ​										增大文件系统 								
     - ​										缩小文件系统 								

   ​						您还可以使用 LUKS(Linux Unified Key Setup)加密选择版本，该加密允许您使用密码短语加密卷。 				

7. ​						选择 **Overwrite** 选项： 				

   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个磁盘。这个选项较慢，因为程序必须经过整个磁盘。如果磁盘包含任何数据且需要覆盖数据，则使用这个选项。 						

8. ​						在 **Mount Point** 字段中添加挂载路径。 				

   ​						[![cockpit lv format](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8351b8f914cdec7452ca8d4969452ce8/cockpit-lv-format.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8351b8f914cdec7452ca8d4969452ce8/cockpit-lv-format.png) 					

9. ​						点 Format。 				

   ​						根据卷大小以及选择格式化选项，格式化可能需要几分钟。 				

   ​						成功完成格式化后，您可以在 **Filesystem** 标签页中看到格式化逻辑卷的详情。 				

   ​						[![cockpit lv formatted](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4d2813b73869be38889692cd96a9708a/cockpit-lv-formatted.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4d2813b73869be38889692cd96a9708a/cockpit-lv-formatted.png) 					

10. ​						要使用逻辑卷，点 Mount。 				

​				此时，系统可以使用挂载的和格式化的逻辑卷。 		

## 19.5. 在 web 控制台中重新定义逻辑卷大小

​				了解如何在 RHEL 9 web 控制台中扩展或缩减逻辑卷。 		

​				您能否重新定义逻辑卷大小取决于您使用的文件系统。大多数文件系统允许您在在线扩展（不停机的情况）卷。 		

​				如果逻辑卷包含支持缩小的文件系统，您也可以减小（缩小）逻辑卷的大小。它应该在例如 ext3/ext4 的文件系统中可用。 		

警告

​					您不能减少包含 GFS2 或者 XFS 文件系统的卷。 			

**先决条件**

- ​						现有逻辑卷包含支持重新定义逻辑卷大小的文件系统。 				

**流程**

​					以下步骤提供了在不使卷离线的情况下增大逻辑卷的步骤： 			

1. ​						登录到 RHEL web 控制台。 				

2. ​						点 Storage。 				

3. ​						在 **Devices** 部分，点放置逻辑卷的卷组。 				

4. ​						在逻辑卷部分点**逻辑卷**。 				

5. ​						在 Volume 选项卡中点 Grow。 				

   ​						[![cockpit lv details](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png) 					

6. ​						在 **Grow logical volume** 对话框中调整卷大小。 				

   ​						[![cockpit lv grow](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b304473c70f872bac45c0db6b7501bae/cockpit-lv-grow.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b304473c70f872bac45c0db6b7501bae/cockpit-lv-grow.png) 					

7. ​						点 Grow。 				

​				LVM 会在不停止系统的情况下增大逻辑卷。 		

## 19.6. 其它资源

- ​						[配置和管理逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_logical_volumes) 				

# 第 20 章 使用 Web 控制台配置精简逻辑卷

​			精简配置的逻辑卷使您能够为指定的应用程序或服务器分配比逻辑卷量实际包含空间更多的空间。 	

​			详情请参阅 [创建精简配置的快照卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/creating-and-managing-thin-provisioned-volumes_configuring-and-managing-logical-volumes)。 	

​			以下部分描述： 	

- ​					[为精简配置的逻辑卷创建池。](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-pools-for-thin-logical-volumes-in-the-web-console_configuring-thin-logical-volumes-using-the-web-console) 			
- ​					[创建精简逻辑卷。](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-thin-logical-volumes-in-the-web-console_configuring-thin-logical-volumes-using-the-web-console) 			
- ​					[格式化精简逻辑卷。](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#formatting-logical-volumes-in-the-web-console_configuring-thin-logical-volumes-using-the-web-console) 			

**先决条件**

- ​					已安装 RHEL 9 web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

- ​					要创建卷组的物理驱动器或其他类型的存储设备。 			

## 20.1. 在 web 控制台中为精简逻辑卷创建池

​				为精简配置的卷创建一个池。 		

**先决条件**

- ​						[已创建的卷组](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-volume-groups-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						点击您要在其中创建精简卷的卷组。 				

4. ​						点**创建新逻辑卷**。 				

5. ​						在 **Name** 字段中输入新精简卷池名称，不要包括空格。 				

6. ​						在 **Purpose** 下拉菜单中，选择 **Pool for thin-provisioned volumes**。此配置允许您创建精简卷。 				

7. ​						定义精简卷池的大小。考虑： 				

   - ​								这个池中需要多少个精简卷？ 						
   - ​								每个精简卷的预期大小是什么？ 						

   ​						您可以选择不使用整个空间。如果需要，您可以稍后增大池。 				

8. ​						点 **Create**。 				

   ​						创建了精简卷的池，您可以添加精简卷。 				

## 20.2. 在 web 控制台中创建精简逻辑卷

​				在池中创建精简逻辑卷。该池可以包含多个精简卷，每个精简卷可以变大，作为精简卷本身的池。 		

重要

​					使用精简卷需要定期检查逻辑卷的实际可用物理空间。 			

**先决条件**

- ​						创建的精简卷池。 				

  ​						详情请参阅[在 web 控制台中为精简逻辑卷创建池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-pools-for-thin-logical-volumes-in-the-web-console_using-the-web-console-for-configuring-thin-logical-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				
2. ​						点击 **Storage**。 				
3. ​						点击您要在其中创建精简卷的卷组。 				
4. ​						点所需池。 				
5. ​						点击**创建 Thin 卷**。 				
6. ​						在 **Create Thin Volume** 对话框中，为精简卷输入一个不包括空格的名称。 				
7. ​						定义精简卷的大小。 				
8. ​						点 **Create**。 				

​				在这个阶段，创建了精简逻辑卷，您需要对其进行格式化。 		

## 20.3. 在 web 控制台中格式化逻辑卷

​				逻辑卷作为物理驱动器使用。要使用它们，您需要使用文件系统进行格式化。 		

警告

​					格式化逻辑卷将擦除卷中的所有数据。 			

​				您选择的文件系统决定了可用于逻辑卷的配置参数。例如：有些 XFS 文件系统不支持缩小卷。详情请查看 [web 控制台中重新定义逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/using-the-web-console-for-configuring-lvm-logical-volumes_system-management-using-the-rhel-9-web-console#resizing-logical-volumes-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)大小。 		

​				以下步骤描述了格式化逻辑卷的步骤。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						已创建逻辑卷。详情请参阅[在 web 控制台中创建逻辑卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/using-the-web-console-for-configuring-lvm-logical-volumes_system-management-using-the-rhel-9-web-console#creating-logical-volumes-in-the-web-console_using-the-web-console-for-configuring-lvm-logical-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 Storage。 				

3. ​						在 **Devices** 部分，点放置逻辑卷的卷组。 				

4. ​						在**逻辑卷**部分，点 Format。 				

   ​						[![cockpit lv details](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a3c06856e594925415a175859031f6b7/cockpit-lv-details.png) 					

5. ​						在 **Name** 字段中输入文件系统的名称。 				

6. ​						在 Type 下拉菜单中选择一个文件系统： 				

   - ​								**XFS** 文件系统支持大的逻辑卷，在不停止工作的情况下在线切换物理驱动器，并可以增大现有的文件系统。如果您没有不同的首选项，请保留这个文件系统。 						

     ​								XFS 不支持缩小使用 XFS 文件系统格式的卷大小 						

   - ​								**ext4** 文件系统支持： 						

     - ​										逻辑卷 								
     - ​										在不停止工作的情况下在线切换物理驱动器 								
     - ​										增大文件系统 								
     - ​										缩小文件系统 								

   ​						您还可以使用 LUKS(Linux Unified Key Setup)加密选择版本，该加密允许您使用密码短语加密卷。 				

7. ​						选择 **Overwrite** 选项： 				

   - ​								**Don’t overwrite existing data** — RHEL web 控制台只重写磁盘头数据。这个选项的优点是格式化速度快。 						
   - ​								**Overwrite existing data with zeros** — RHEL web 控制台使用零重写整个磁盘。这个选项较慢，因为程序必须经过整个磁盘。如果磁盘包含任何数据且需要覆盖数据，则使用这个选项。 						

8. ​						在 **Mount Point** 字段中添加挂载路径。 				

   ​						[![cockpit lv format](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8351b8f914cdec7452ca8d4969452ce8/cockpit-lv-format.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8351b8f914cdec7452ca8d4969452ce8/cockpit-lv-format.png) 					

9. ​						点 Format。 				

   ​						根据卷大小以及选择格式化选项，格式化可能需要几分钟。 				

   ​						成功完成格式化后，您可以在 **Filesystem** 标签页中看到格式化逻辑卷的详情。 				

   ​						[![cockpit lv formatted](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4d2813b73869be38889692cd96a9708a/cockpit-lv-formatted.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/4d2813b73869be38889692cd96a9708a/cockpit-lv-formatted.png) 					

10. ​						要使用逻辑卷，点 Mount。 				

​				此时，系统可以使用挂载的和格式化的逻辑卷。 		

# 第 21 章 使用 Web 控制台更改卷组中的物理驱动器

​			使用 RHEL 9 web 控制台更改卷组中的驱动器。 	

​			物理驱动器的更改由以下过程组成： 	

- ​					[在逻辑卷中添加物理驱动器。](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#adding-physical-drives-to-volume-groups-in-the-web-console_changing-physical-drives-in-volume-groups-using-the-web-console) 			
- ​					[从逻辑卷中删除物理驱动器。](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#removing-physical-drives-from-volume-groups-in-the-web-console_changing-physical-drives-in-volume-groups-using-the-web-console) 			

**先决条件**

- ​					已安装 RHEL 9 web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

- ​					用于替换旧的或有问题的驱动器的新物理驱动器。 			

- ​					该配置期望物理驱动器在一个卷组中进行组织。 			

## 21.1. 在 web 控制台中的卷组中添加物理驱动器

​				RHEL 9 web 控制台允许您在现有逻辑卷中添加新的物理驱动器或者其他类型的卷。 		

**先决条件**

- ​						必须创建一个卷组。 				
- ​						连接到机器的新驱动器。 				

**流程**

1. ​						登录到 RHEL 9 控制台。 				
2. ​						点击 **Storage**。 				
3. ​						在**卷组框**中，点您要在其中添加物理卷的卷组。 				
4. ​						在**物理卷框**中点 + 按钮。 				
5. ​						在 **Add Disks** 对话框中，选择首选的驱动器并点 **Add**。 				

​				因此，RHEL 9 web 控制台会添加物理卷。 		

**验证步骤**

- ​						检查**物理卷**，逻辑卷会立即开始写入该驱动器。 				

## 21.2. 在 web 控制台中，从卷组中删除物理驱动器

​				如果逻辑卷包含多个物理驱动器，您可以在线删除其中一个物理驱动器。 		

​				系统会在删除过程中自动将驱动器中的所有数据移至其他驱动器。请注意，这可能需要一些时间。 		

​				web 控制台也会验证删除物理驱动器是否会有足够的空间。 		

**先决条件**

- ​						一个连接了多个物理驱动器的卷组。 				

**流程**

​					以下步骤描述了如何通过 RHEL 9 web 控制台，在不停机的情况下从卷组中删除驱动器。 			

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点击 **Storage**。 				

3. ​						点在其中有逻辑卷的卷组。 				

4. ​						在 **Physical Volumes** 部分，找到首选卷。 				

5. ​						点 - 按钮。 				

   ​						RHEL 9 web 控制台会验证逻辑卷是否有足够可用空间来删除磁盘。如果没有，则无法删除磁盘，需要首先添加另一个磁盘。详情请查看 [web 控制台中的逻辑卷中添加物理驱动器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#adding-physical-drives-to-volume-groups-in-the-web-console_using-the-web-console-for-changing-physical-drives-in-volume-groups)。 				

​				作为结果，RHEL 9 web 控制台会从创建的逻辑卷中删除物理卷，而不会导致中断。 		

# 第 22 章 使用 Web 控制台管理 Virtual Data Optimizer 卷

​			使用 RHEL 9 web 控制台配置 Virtual Data Optimizer(VDO)。 	

​			您将学习如何： 	

- ​					创建 VDO 卷 			
- ​					格式化 VDO 卷 			
- ​					扩展 VDO 卷 			

**先决条件**

- ​					RHEL 9 web 控制台已安装并可以访问。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			
- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

## 22.1. Web 控制台中的 VDO 卷

​				Red Hat Enterprise Linux 9 支持 Virtual Data Optimizer(VDO)。 		

​				VDO 是一个组合了以下功能的虚拟化技术： 		

- 压缩

  ​							详情请参阅[在VDO 中启用或禁用压缩](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/creating-a-deduplicated-and-compressed-logical-volume_deduplicating-and-compressing-logical-volumes-on-rhel#changing-the-compression-and-deduplication-settings-on-an-lvm-vdo-volume_creating-a-deduplicated-and-compressed-logical-volume)。 					

- 重复数据删除（Deduplication）

  ​							详情请参阅[在VDO 中启用或禁用压缩](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/creating-a-deduplicated-and-compressed-logical-volume_deduplicating-and-compressing-logical-volumes-on-rhel#changing-the-compression-and-deduplication-settings-on-an-lvm-vdo-volume_creating-a-deduplicated-and-compressed-logical-volume)。 					

- 精简置备

  ​							详情请参阅[创建和管理精简置备卷（精简卷）](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/creating-and-managing-thin-provisioned-volumes_configuring-and-managing-logical-volumes)。 					

​				使用这些技术，VDO： 		

- ​						保存存储空间内联 				
- ​						压缩文件 				
- ​						消除重复 				
- ​						可让您分配超过物理或者逻辑存储量的虚拟空间 				
- ​						允许您通过增大虚拟存储来扩展虚拟存储 				

​				VDO 可以在很多类型的存储之上创建。在 RHEL 9 web 控制台中，您可以在以下之上配置 VDO： 		

- ​						LVM 				

  注意

  ​							不可能在精简置备的卷之上配置 VDO。 					

- ​						物理卷 				

- ​						软件 RAID 				

​				有关在 Storage Stack 中放置 VDO 的详情，请参阅[系统要求](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/lvm-vdo-requirements_deduplicating-and-compressing-logical-volumes-on-rhel#lvm-vdo-requirements_deduplicating-and-compressing-logical-volumes-on-rhel)。 		

**其它资源**

- ​						有关 VDO 的详情，请参阅 [重复数据删除和压缩存储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/index)。 				

## 22.2. 在 web 控制台中创建 VDO 卷

​				在 RHEL web 控制台中创建 VDO 卷。 		

**先决条件**

- ​						要创建 VDO 的物理驱动器、LVM 或者 RAID。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						点 **VDO Devices** 框中的 + 按钮。 				

4. ​						在 **Name** 字段中输入 VDO 卷的名称，没有空格。 				

5. ​						选择要使用的驱动器。 				

6. ​						在 **Logical Size** 条中，设置 VDO 卷的大小。您可以扩展超过十倍，但请考虑创建 VDO 卷的目的是： 				

   - ​								对于活跃的虚拟机或容器存储，逻辑大小为物理大小的十倍。 						
   - ​								对于对象存储，逻辑大小为物理大小的三倍。 						

   ​						详情请参阅 [Deploying VDO](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/creating-a-deduplicated-and-compressed-logical-volume_deduplicating-and-compressing-logical-volumes-on-rhel#lvm-vdo-deployment-scenarios_creating-a-deduplicated-and-compressed-logical-volume)。 				

7. ​						在 **Index Memory** 栏中，为 VDO 卷分配内存。 				

   ​						有关 VDO 系统要求的详情，请参阅[系统要求](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/lvm-vdo-requirements_deduplicating-and-compressing-logical-volumes-on-rhel#lvm-vdo-requirements_deduplicating-and-compressing-logical-volumes-on-rhel)。 				

8. ​						选择 **Compression** 选项。这个选项可以有效地减少各种文件格式。 				

   ​						详情请参阅[在VDO 中启用或禁用压缩](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/creating-a-deduplicated-and-compressed-logical-volume_deduplicating-and-compressing-logical-volumes-on-rhel#changing-the-compression-and-deduplication-settings-on-an-lvm-vdo-volume_creating-a-deduplicated-and-compressed-logical-volume)。 				

9. ​						选择 **Deduplication** 选项。 				

   ​						这个选项通过删除重复块的多个副本来减少存储资源的消耗。详情请参阅[在VDO 中启用或禁用压缩](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deduplicating_and_compressing_logical_volumes_on_rhel/creating-a-deduplicated-and-compressed-logical-volume_deduplicating-and-compressing-logical-volumes-on-rhel#changing-the-compression-and-deduplication-settings-on-an-lvm-vdo-volume_creating-a-deduplicated-and-compressed-logical-volume)。 				

10. ​						[可选] 如果要使用需要 512 字节块大小的应用程序的 VDO 卷，请选择 **使用 512 字节模拟**。这会降低 VDO 卷的性能，但应该很少需要。如果不确定，请将其关机。 				

11. ​						点 **Create**。 				

**验证步骤**

- ​						检查您是否可在 **Storage** 部分看到新的 VDO 卷。然后您可以使用文件系统对其进行格式化。 				

## 22.3. 在 web 控制台中格式化 VDO 卷

​				VDO 卷作为物理驱动器使用。要使用它们，您需要使用文件系统进行格式化。 		

警告

​					格式化 VDO 将擦除卷上的所有数据。 			

​				以下步骤描述了格式化 VDO 卷的步骤。 		

**先决条件**

- ​						已创建一个 VDO 卷。详情请参阅在 [web 控制台中创建 VDO 卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#creating-virtual-data-optimizer-in-the-web-console_using-the-web-console-for-managing-virtual-data-optimizer-volumes)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						点 VDO 卷。 				

4. ​						点 **Unrecognized Data** 标签页。 				

5. ​						点 **Format**。 				

6. ​						在 **Erase** 下拉菜单中选择： 				

   - **Don’t overwrite existing data**

     ​									RHEL web 控制台只重写磁盘标头。这个选项的优点是格式化速度。 							

   - **Overwrite existing data with zeros**

     ​									RHEL web 控制台使用 0 重写整个磁盘。这个选项较慢，因为程序必须经过整个磁盘。如果磁盘包含任何数据且需要重写数据，则使用这个选项。 							

7. ​						在 **Type** 下拉菜单中选择一个文件系统： 				

   - ​								**XFS** 文件系统支持大的逻辑卷，在不停止工作的情况下在线切换物理驱动器，并增大。如果您没有不同的首选项，请保留这个文件系统。 						

     ​								XFS 不支持缩小卷。因此，您将无法缩小使用 XFS 格式的卷。 						

   - ​								**ext4** 文件系统支持逻辑卷，在不停止工作的情况下在线切换物理驱动器，并缩减。 						

   ​						您还可以使用 LUKS(Linux Unified Key Setup)加密选择版本，该加密允许您使用密码短语加密卷。 				

8. ​						在 **Name** 字段输入逻辑卷名称。 				

9. ​						在 **Mounting** 下拉菜单中选择 **Custom**。 				

   ​						**Default** 选项不会保证在下次引导时挂载该文件系统。 				

10. ​						在 **Mount Point** 字段中添加挂载路径。 				

11. ​						选择 **Mount at boot**。 				

12. ​						点 **Format**。 				

    ​						根据使用的格式化选项和卷大小，格式化的过程可能需要几分钟。 				

    ​						成功完成后,，可以在 **Filesystem** 标签页中看到格式化的 VDO 卷的详情。 				

13. ​						要使用 VDO 卷，点 **Mount**。 				

​				此时，系统使用挂载的和格式化的 VDO 卷。 		

## 22.4. 在 web 控制台中扩展 VDO 卷

​				在 RHEL 9 web 控制台中扩展 VDO 卷。 		

**先决条件**

- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						已创建的 VDO 卷。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						在 **VDO Devices** 框中点您的 VDO 卷。 				

4. ​						在 VDO 卷详情中点 Grow 按钮。 				

5. ​						在 **Grow logical size of VDO** 对话框中，扩展 VDO 卷的逻辑大小。 				

1. ​						点 **Grow**。 				

**验证步骤**

- ​						检查 VDO 卷详情中的新大小，以验证您的更改是否成功。 				

# 第 23 章 在 RHEL web 控制台中使用 LUKS 密码锁定数据

​			在 Web 控制台的 **Storage** 选项卡中，您现在可以使用 LUKS(Linux Unified Key Setup)版本 2 格式创建、锁定、解锁、调整大小和其他配置加密设备。 	

​			这个 LUKS 的新版本提供： 	

- ​					更灵活的解锁策略 			
- ​					更强大的加密 			
- ​					更好地与将来的更改兼容 			

**先决条件**

- ​					已安装 RHEL 9 web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			
- ​					`cockpit-storaged` 软件包已安装在您的系统上。 			

## 23.1. LUKS 磁盘加密

​				Linux Unified Key Setup-disk-format(LUKS)允许您加密块设备，并提供了一组简化管理加密设备的工具。LUKS 允许多个用户密钥解密主密钥，用于分区的批量加密。 		

​				RHEL 使用 LUKS  来执行块设备加密。默认情况下，在安装过程中不选中加密块设备的选项。如果您选择加密磁盘的选项，则系统会在每次引导计算机时都提示您输入密码短语。这个密码短语"解锁"了解密您分区的批量加密密钥。如果您选择修改默认的分区表，可以选择加密哪个分区。这是在分区表设置中设定的。 		

**LUKS 做什么**

- ​						LUKS 对整个块设备进行加密，因此非常适合保护移动设备的内容，如可移动存储介质或笔记本电脑磁盘驱动器。 				
- ​						加密块设备的底层内容是任意的，这有助于加密交换设备。对于将特殊格式化块设备用于数据存储的某些数据库，这也很有用。 				
- ​						LUKS 使用现有的设备映射器内核子系统。 				
- ​						LUKS 增强了密码短语，防止字典攻击。 				
- ​						LUKS 设备包含多个密钥插槽，允许用户添加备份密钥或密码短语。 				

**LUKS \*不能\*做什么**

- ​						LUKS 等磁盘加密解决方案只在您的系统关闭时保护数据。一旦系统开启并且 LUKS 解密了磁盘后，通常有权访问该磁盘的任何人都可以使用该磁盘上的文件。 				
- ​						LUKS 不适用于需要许多用户使用同一设备的不同访问密钥的情况。LUKS1 格式提供了八个密钥插槽，LUKU2 最多提供 32 个密钥插槽。 				
- ​						LUKS 不适用于需要文件级加密的应用程序。 				

**加密系统**

​					LUKS 使用的默认密码是 `aes-xts-plain64`。LUKS 的默认密钥大小为 512 字节。具有 **Anaconda** （XTS 模式）的 LUKS 的默认密钥大小为 512 位。可用的加密系统包括： 			

- ​						AES - 高级加密标准 				
- ​						Twofish（128 位块加密） 				
- ​						Serpent 				

**其它资源**

- ​						[LUKS 项目主页](https://gitlab.com/cryptsetup/cryptsetup/blob/master/README.md) 				
- ​						[LUKS 磁盘格式规范](https://gitlab.com/cryptsetup/LUKS2-docs/blob/master/luks2_doc_wip.pdf) 				
- ​						[FIPS PUB 197](https://doi.org/10.6028/NIST.FIPS.197) 				

## 23.2. 在 web 控制台中配置 LUKS 密码短语

​				如果要在系统中的现有逻辑卷中添加加密，则只能通过格式化卷进行。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				
- ​						在没有加密的情况下可用的现有逻辑卷. 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点击 **Storage**。 				

3. ​						选择您要格式的存储设备。 				

4. ​						点菜单图标并选择 **Format** 选项。 				

5. ​						选择**加密数据**复选框在您的存储设备中激活加密。 				

6. ​						设置并确认您的新密码短语。 				

7. ​						[可选] 修改进一步加密选项。 				

8. ​						完成格式化设置。 				

9. ​						点 **Format**。 				

## 23.3. 在 web 控制台中更改 LUKS 密码短语

​				在 web 控制台中的加密磁盘或分区上更改 LUKS 密码短语。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
- ​						`cockpit-storaged` 软件包已安装在您的系统上。 				

**流程**

1. ​						登录到 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						点 **Storage** 				
3. ​						在 Drives 表中，选择带有加密数据的磁盘。 				
4. ​						在**内容**中，选择加密的分区。 				
5. ​						点 **Encryption**。 				
6. ​						在 **Keys** 表中点铅笔图标。 				
7. ​						在**更改密码短语**对话框中： 				
   1. ​								输入您当前的密码短语。 						
   2. ​								输入您的新密码短语。 						
   3. ​								确认您的新密码短语。 						
8. ​						点 **Save** 				

# 第 24 章 在 web 控制台中管理软件更新

​			在 RHEL 9 web 控制台中，如何管理软件更新，以及如何自动进行软件更新。 	

​			web 控制台中的软件更新模块基于 `dnf` 工具。有关使用 `dnf` 更新软件的更多信息，请参阅[更新软件包](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_software_with_the_dnf_tool/assembly_updating-rhel-9-content_managing-software-with-the-dnf-tool#proc_updating-packages-with-yum_assembly_updating-rhel-9-content)部分。 	

## 24.1. 在 web 控制台中管理手动软件更新

​				本节论述了如何使用 Web 控制台手动更新软件。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点**软件更新**。 				

   ​						如果最后一次检查发生时间超过 24 小时，可用更新列表会自动刷新。要触发刷新，请点 Check for Updates 按钮。 				

3. ​						应用更新。您可以在更新运行时监控更新日志。 				

   1. ​								要安装所有可用更新，请点安装所有更新按钮。 						
   2. ​								如果您有可用的安全更新，请点击安装安全更新按钮单独安装它们。 						
   3. ​								如果您有 kpatch 更新可用，请点 Install kpatch 更新按钮单独安装它们。 						

4. ​						可选：您可以选择 **Reboot after completion** 来自动重启您的系统。 				

   ​						如果执行此步骤，您可以跳过这个过程的剩余步骤。 				

5. ​						在系统应用更新后，您会看到重启系统的建议。 				

   ​						特别是，当更新中包含一个您不想单独重启的新内核或系统服务时，我们尤其建议这样做。 				

6. ​						点 **Ignore** 以取消重启，或选择 **Restart Now** 重启系统。 				

   ​						系统重启后，登录 web 控制台并进入 **Software Updates** 页面以验证更新是否成功。 				

## 24.2. 在 web 控制台中管理自动更新

​				在 web 控制台中，您可以选择应用所有更新，或者安全更新，以及管理自动更新的定期和时间。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				
2. ​						点**软件更新**。 				
3. ​						在 **Settings** 表中，点 Edit 按钮。 				
4. ​						挑选一种自动更新类型。您可以选择 **Security updates only** 或 **All updates**。 				
5. ​						要修改自动更新的日期，在下拉菜单中点 **every day** 并选择特定日期。 				
6. ​						要修改自动更新的时间，请点击 **6:00** 字段并选择或输入特定时间。 				
7. ​						如果要禁用自动软件更新，请选择 **No update** 类型。 				

## 24.3. 在 web 控制台中应用软件更新后管理按需重启

​				智能重启功能会通知用户是否在应用软件更新后重新引导整个系统，或者是否足以重新启动某些服务。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-8-web-console)。 				

2. ​						点**软件更新**。 				

3. ​						对您的系统应用更新。 				

4. ​						成功更新后，点 **Reboot system…**, **restart services…**或 **Ignore** 				

5. ​						如果您决定忽略，您可以通过执行以下操作之一来返回到重启或重启菜单： 				

   1. ​								重新引导： 						

      1. ​										点 **Software Updates** 页面的 **Status** 字段中的 Reboot system 按钮。 								
      2. ​										（可选）将消息写入登录的用户。 								
      3. ​										从 **Delay** 下拉菜单中选择一个延迟。 								
      4. ​										点**重启**。 								

   2. ​								重启服务： 						

      1. ​										点 Restart services… 按钮（在 **Software Updates** 页面的 **Status** 字段中）。 								

         ​										您将看到需要重启的所有服务的列表。 								

      2. ​										点 **重启服务**。 								

         ​										根据您的选择，系统将重新启动，或者您的服务将重启。 								

## 24.4. 在 web 控制台中使用内核实时补丁应用补丁

​				Web 控制台允许用户在不强制使用 `kpatch` 框架强制重启的情况下应用内核安全补丁。以下流程演示了如何设置首选补丁类型。 		

**先决条件**

- ​						必须安装并可以访问 Web 控制台。详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						使用管理权限登录到 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						点**软件更新**。 				

3. ​						检查内核补丁设置的状态。 				

   1. ​								如果没有安装补丁，点 Install。 						

      ​								![cockpit kernel patching install](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/ea1f022c48cda381d7816f121285ad36/cockpit-kernel-patching-install.png) 							

   2. ​								要启用内核补丁，请点击 启用。 						

      ​								![cockpit kernel patching disabled](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/080db5b76e3b348d7730fb43c0a8b83c/cockpit-kernel-patching-disabled.png) 							

   3. ​								选中应用内核补丁的复选框。 						

   4. ​								选择您要为当前和将来的内核应用补丁，还是只针对当前内核应用补丁。如果您选择为将来的内核应用补丁，系统将为后续的内核版本应用补丁。 						

      ​								![cockpit kernel patching future](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5ee3aefde508e6fc1a052e30f8e4c217/cockpit-kernel-patching-future.png) 							

      ​								![cockpit kernel patching current](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/6a257e3ccc7d59529d91ec85e9caee3c/cockpit-kernel-patching-current.png) 							

   5. ​								点应用。 						

**验证**

- ​						检查内核补丁在 **Software updates** 项的 **Settings** 表中为 **Enabled**。 				

  ​						![cockpit kernel patching enabled](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a737e0d43ea20ef0a63f8e825d691136/cockpit-kernel-patching-enabled.png) 					

**其它资源**

- ​						[使用内核实时修补程序应用补丁](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/applying-patches-with-kernel-live-patching_managing-monitoring-and-updating-the-kernel) 				

# 第 25 章 在 web 控制台中管理订阅

​			通过 web 控制台管理 Red Hat Enterprise Linux 9 的订阅。 	

​			要获得 Red Hat Enterprise Linux 订阅，您需要在 [红帽客户门户网站](https://access.redhat.com)中有一个帐户或一个激活码。 	

​			本章论述了： 	

- ​					RHEL 9 web 控制台中的订阅管理。 			
- ​					在 web 控制台中使用红帽用户名和密码为您的系统注册订阅。 			
- ​					使用激活码注册订阅。 			

**先决条件**

- ​					购买了订阅。 			
- ​					受订阅限制的系统必须连接到互联网，因为 Web 控制台需要与红帽客户门户网站通信。 			

## 25.1. Web 控制台中的订阅管理

​				RHEL 9 web 控制台为使用在本地系统中安装的红帽订阅管理器提供了一个界面。 		

​				Subscription Manager 连接到红帽客户门户网站，并验证所有可用信息： 		

- ​						活跃订阅 				
- ​						过期的订阅 				
- ​						续订的订阅 				

​				如果要续订订阅或在红帽客户门户网站中获取不同的订阅，则不需要手动更新订阅管理器数据。Subscription Manager 会自动将数据与红帽客户门户网站同步。 		

## 25.2. 在 web 控制台中使用凭证注册订阅

​				使用以下步骤通过 RHEL web 控制台使用帐户凭证注册新安装的 Red Hat Enterprise Linux。 		

**先决条件**

- ​						红帽客户门户网站中的有效用户帐户。 				

  ​						请参阅 [创建红帽登录](https://www.redhat.com/wapps/ugc/register.html) 页面。 				

- ​						RHEL 系统的有效订阅。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						在 **Overview** 页面中的 **Health** 文件中，点 **Not registered** 警告，或者点击主菜单中的 **Subscriptions** 来进入页面。 				

   ​						![cockpit subscription Health](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/70b3d80d629ec9410e661ddb238adc0c/cockpit-subscription-Health.png) 					 . 				

3. ​						在 **Overview** 文件中，点 **Register**。 				

   ​						![cockpit subscription Overview](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/ae67c7fd9174ad2e4fcb0048ce22adbd/cockpit-subscription-Overview.png) 					

4. ​						在 **Register system** 对话框中，选择您要使用您的帐户凭证进行注册。 				

   ​						[![cockpit subscriptions account](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/da3382a2e1249f00f0b9b67b62f88e32/cockpit-subscriptions-account.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/da3382a2e1249f00f0b9b67b62f88e32/cockpit-subscriptions-account.png) 					

5. ​						输入您的用户名。 				

6. ​						输入您的密码。 				

7. ​						（可选）输入您的机构名称或 ID。 				

   ​						如果您的帐户属于红帽客户门户网站中的多个机构，您必须添加机构名称或机构 ID。要获得机构 ID，请联系您的红帽相关人员。 				

   - ​								如果您不想将您的系统连接到 Red Hat Insights，请取消选中 **Insights** 复选框。 						

8. ​						点 Register 按钮。 				

​				此时您的 Red Hat Enterprise Linux Enterprise Linux 系统已被成功注册。 		

## 25.3. 在 web 控制台中使用激活码注册订阅

​				按照以下步骤，通过 RHEL web 控制台使用激活码注册新安装的 Red Hat Enterprise Linux。 		

**先决条件**

- ​						如果您在该门户中没有用户帐户，您的厂商会为您提供激活码。 				

**流程**

1. ​						登录到 RHEL web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						在 **Overview** 页面中的 **Health** 文件中，点 **Not registered** 警告，或者点击主菜单中的 **Subscriptions** 来进入页面。 				

   ​						![cockpit subscription Health](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/70b3d80d629ec9410e661ddb238adc0c/cockpit-subscription-Health.png) 					 . 				

3. ​						在 **Overview** 文件中，点 **Register**。 				

   ​						![cockpit subscription Overview](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/ae67c7fd9174ad2e4fcb0048ce22adbd/cockpit-subscription-Overview.png) 					

4. ​						在**注册系统**对话框中，选择您要使用激活码进行注册。 				

   ​						[![cockpit subscriptions key](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c76909deaeaa3d175e9eab03dc74a0b3/cockpit-subscriptions-key.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/c76909deaeaa3d175e9eab03dc74a0b3/cockpit-subscriptions-key.png) 					

5. ​						输入您的密钥或密钥。 				

6. ​						输入您的机构名称或 ID。 				

   ​						要获得机构 ID，请联系您的红帽联系点。 				

   - ​								如果您不想将您的系统连接到 Red Hat Insights，请取消选中 **Insights** 复选框。 						

7. ​						点 Register 按钮。 				

​				此时您的 Red Hat Enterprise Linux 系统已被成功注册。 		

# 第 26 章 在 web 控制台中配置 kdump

​			在 RHEL 9 web 控制台中设置并测试 `kdump` 配置。 	

​			web 控制台是 RHEL 9 的默认安装的一部分，可在引导时启用或禁用 `kdump` 服务。另外，web 控制台可让您为 `kdump` 配置保留的内存 ; 或者以未压缩格式选择 *vmcore* 保存的位置。 	

## 26.1. 在 web 控制台中配置 kdump 内存用量和目标位置

​				下面的步骤显示如何使用 RHEL web 控制台界面中的`内核转储`标签页配置 `kdump` 内核保留的内存量。它还介绍了如何指定 `vmcore` 转储文件的目标位置以及如何测试您的配置。 		

**流程**

1. ​						打开 `Kernel Dump` 标签页，启动 `kdump` 服务。 				

2. ​						使用命令行配置 `kdump` 内存用量。 				

3. ​						点 `Crash dump location` 选项旁的链接。 				

   [![Cockpit kdump 主屏幕](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/6265bf6c911385fd705ca8fc5cf8f8f1/cockpit-kdump-main-screen.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/6265bf6c911385fd705ca8fc5cf8f8f1/cockpit-kdump-main-screen.png)

4. ​						从下拉菜单中选择 `Local Filesystem` 选项，并指定要保存转储的目录。 				

   [![Cockpit kdump 位置](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/189eea5e5ebf6232d38444c85c95f646/cockpit-kdump-location.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/189eea5e5ebf6232d38444c85c95f646/cockpit-kdump-location.png)

   - ​								或者，从下拉菜单中选择 `Remote over SSH` 选项，使用 SSH 协议将该 vmcore 发送到远程机器。 						

     ​								在 `Server`、`ssh key` 和 `Directory` 项中提供远程机器的地址、ssh 密钥位置和目的地目录。 						

   - ​								另一种选择是从下拉菜单中选择 `Remote over NFS` 选项，并填写 `Mount` 字段，以使用 NFS 协议将 vmcore 发送到远程计算机。 						

     注意

     ​									选择 `Compression` 复选框来缩小 vmcore 文件的大小。 							

5. ​						崩溃内核以测试您的配置。 				

   ![Cockpit kdump 测试](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/58b203e390329393f911f577db46c3e8/cockpit-kdump-test.png)

   1. ​								点 `Test 配置`。 						

   2. ​								在 **Test kdump settings** 字段中，点 `Crash system`。 						

      警告

      ​									这一步会破坏内核的执行，并导致系统崩溃和数据丢失。 							

**其它资源**

- ​						[支持的 kdump 目标](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/supported-kdump-configurations-and-targets_managing-monitoring-and-updating-the-kernel#supported-kdump-targets_supported-kdump-configurations-and-targets) 				
- ​						[使用 OpenSSH 的两个系统间使用安全通讯](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_using-secure-communications-between-two-systems-with-openssh_configuring-basic-system-settings) 				

## 26.2. 其它资源

- ​						[使用 RHEL web 控制台入门](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console) 				

# 第 27 章 在 web 控制台中管理虚拟机

​			要在 RHEL 9 主机上的图形界面管理虚拟机，您可以在 RHEL 9 web 控制台中使用 `Virtual Machines` 窗格。 	

[![显示 web 控制台的虚拟机选项卡的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)

## 27.1. 使用 web 控制台管理虚拟机概述

​				RHEL 9 web 控制台是一个用于系统管理的基于 web 的界面。作为其功能之一，Web 控制台提供主机系统中虚拟机（VM）的图形视图，并可创建、访问和配置这些虚拟机。 		

​				请注意，要使用 Web 控制台在 RHEL 9 上管理虚拟机，您必须首先为虚拟化安装 [web 控制台插件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 		

**后续步骤**

- ​						有关在 web 控制台中启用虚拟机管理的说明，请参阅 [设置 web 控制台来管理虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/managing-virtual-machines-in-the-web-console_system-management-using-the-rhel-9-web-console#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						有关 web 控制台提供的虚拟机管理操作的完整列表，请参阅 [web 控制台中提供的虚拟机管理功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization#virtual-machine-management-features-available-in-the-web-console_managing-virtual-machines-in-the-web-console)。 				

## 27.2. 设置 web 控制台以管理虚拟机

​				在使用 RHEL 9 web 控制台管理虚拟机 (VM) 之前，您必须在主机上安装 web 控制台虚拟机插件。 		

**先决条件**

- ​						确保机器上安装并启用了 Web 控制台。 				

  

  ```none
  # systemctl status cockpit.socket
  cockpit.socket - Cockpit Web Service Socket
  Loaded: loaded (/usr/lib/systemd/system/cockpit.socket
  [...]
  ```

  ​						如果此命令返回 `Unit cockpit.socket could not be found`，请按照 [安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console) 文档来启用 Web 控制台。 				

**流程**

- ​						安装 `cockpit-machines` 插件。 				

  

  ```none
  # dnf install cockpit-machines
  ```

**验证**

1. ​						访问 Web 控制台，例如在浏览器中输入 `https://localhost:9090` 地址。 				

2. ​						登录。 				

3. ​						如果安装成功，Virtual Machines 会出现在 web 控制台侧菜单中。 				

   [![显示 web 控制台的虚拟机选项卡的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)

**其它资源**

- ​						[使用 RHEL 9 web 控制台管理系统.](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_managing-systems-using-the-web-console#connecting-to-the-web-console-from-a-remote-machine_getting-started-with-the-rhel-9-web-console) 				

## 27.3. 使用 web 控制台重命名虚拟机

​				创建虚拟机(VM)后，您可能想要重命名虚拟机以避免冲突，或者根据您的用例分配一个新的唯一的名称。您可以使用 RHEL web 控制台来重命名虚拟机。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)。 				
- ​						确保虚拟机已关闭。 				

**流程**

1. ​						在 Virtual Machines 界面中，点击您要重命名的虚拟机的菜单按钮 ⋮。 				

   ​						此时会出现一个下拉菜单，控制各种虚拟机操作。 				

2. ​						点 Rename。 				

   ​						此时会出现重命名虚拟机对话框。 				

   [![显示重命名虚拟机对话框的图片。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/771f1470b3a2af2374ec2d96ccbed15a/virt-cockpit-vm-rename-confirm.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/771f1470b3a2af2374ec2d96ccbed15a/virt-cockpit-vm-rename-confirm.png)

3. ​						在 **New name** 字段中输入虚拟机的名称。 				

4. ​						点 Rename。 				

**验证**

- ​						新虚拟机名称应该出现在 Virtual Machines 界面中。 				

## 27.4. web 控制台中提供的虚拟机管理功能

​				使用 RHEL 9 web 控制台，您可以执行以下操作来管理系统上的虚拟机(VM)。 		

表 27.1. RHEL 9 web 控制台中执行的虚拟机任务

| 任务                                                 | 详情请查看：                                                 |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| 创建虚拟机并将其安装到客户端操作系统                 | [使用 web 控制台创建虚拟机并安装客户端操作系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#creating-vms-and-installing-an-os-using-the-rhel-web-console_assembly_creating-virtual-machines) |
| 删除虚拟机。                                         | [使用 web 控制台删除虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#deleting-vms-using-the-rhel-web-console_assembly_deleting-virtual-machines)。 |
| 启动、关闭和重启虚拟机                               | [使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines) 以及[使用 web 控制台关闭和重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#powering-down-and-restarting-vms-using-the-rhel-web-console_assembly_shutting-down-virtual-machines) |
| 使用各种控制台连接到虚拟机并与虚拟机交互             | [使用 web 控制台与虚拟机交互](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#viewing-vm-consoles-using-the-rhel-web-console_assembly_connecting-to-virtual-machines) |
| 查看有关虚拟机的各种信息                             | [使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) |
| 调整分配给虚拟机的主机内存                           | [使用 web 控制台添加和删除虚拟机内存](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/optimizing-virtual-machine-performance-in-rhel_configuring-and-managing-virtualization#adding-and-removing-virtual-machine-ram-using-the-web-console_configuring-virtual-machine-ram) |
| 管理虚拟机的网络连接                                 | [使用 web 控制台管理虚拟机网络接口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/configuring-virtual-machine-network-connections_configuring-and-managing-virtualization#managing-virtual-machine-network-interfaces-using-the-web-console_configuring-virtual-machine-network-connections) |
| 管理主机上可用的虚拟机存储，并将虚拟磁盘附加到虚拟机 | [为虚拟机管理存储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#managing-storage-for-virtual-machines_configuring-and-managing-virtualization) |
| 配置虚拟机的虚拟 CPU 设置                            | [使用 Web 控制台管理虚拟 CPU](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/optimizing-virtual-machine-performance-in-rhel_configuring-and-managing-virtualization#managing-virtual-cpus-using-the-web-console_optimizing-virtual-machine-cpu-performance) |
| 实时迁移虚拟机                                       | [使用 web 控制台实时迁移虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/migrating-virtual-machines_configuring-and-managing-virtualization#proc_live-migrating-a-virtual-machine-using-the-web-console_migrating-virtual-machines) |
| 重命名虚拟机                                         | [使用 web 控制台重命名虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/migrating-virtual-machines_configuring-and-managing-virtualization#proc_renaming-virtual-machnies-using-the-web-console_managing-virtual-machines-in-the-web-console) |
| 在主机和虚拟机间共享文件                             | [通过 web 控制台使用 virtiofs 在主机及其虚拟机之间共享文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/migrating-virtual-machines_configuring-and-managing-virtualization#proc_using-the-web-console-to-share-files-between-the-host-and-its-virtual-machines-using-virtiofs_sharing-files-between-the-host-and-its-virtual-machines) |
| 管理主机设备                                         | [使用 web 控制台管理虚拟设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/assembly_managing-virtual-devices-using-the-web-console_managing-virtual-devices) |

# 第 28 章 在 web 控制台中管理远程系统

​			连接到远程系统，并在 RHEL 9 web 控制台中管理它们。 	

​			下面的章节描述： 	

- ​					连接系统的最佳拓扑。 			
- ​					如何添加和删除远程系统。 			
- ​					何时，以及如何使用 SSH 密钥进行远程系统身份验证。 			
- ​					如何配置 Web 控制台客户端，以允许使用智能卡通过 `SSH` 访问远程主机并访问服务的用户。 			

**先决条件**

- ​					在远程系统中打开 SSH 服务。 			

## 28.1. Web 控制台中的远程系统管理器

​				使用 RHEL 9 Web 控制台管理网络中的远程系统需要考虑连接的服务器拓扑。 		

​				为了获得最佳安全性，红帽建议以下连接设置： 		

- ​						使用一个带有 Web 控制台的系统作为堡垒主机。堡垒主机是带有打开 HTTPS 端口的系统。 				
- ​						所有其他系统通过 SSH 进行通信。 				

​				通过在堡垒主机上运行的 Web 接口，您可以使用默认配置中的端口 22 通过 SSH 协议访问所有其他系统。 		

​				[![RHEL Cockpit ManagingSystems 484190 0119](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/eb365d3b7d9bd36f9a41d381977c12b4/RHEL_Cockpit-ManagingSystems_484190_0119.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/eb365d3b7d9bd36f9a41d381977c12b4/RHEL_Cockpit-ManagingSystems_484190_0119.png) 			

## 28.2. 在 web 控制台中添加远程主机

​				本节帮助您使用用户名和密码连接其他系统。 		

**先决条件**

- ​						您需要使用管理权限登录到 web 控制台。详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						在 RHEL 9 web 控制台中，点 **Overview** 页面左上角的 `username@hostname`。 				

   ​						![cockpit username dropdown](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/9bedb4c177625dee3fe990b5695001a4/cockpit-username-dropdown.png) 					

2. ​						在下拉菜单中选择添加新主机按钮。 				

   ​						![cockpit add new host](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8b6cc1330f884d0d054f5e22b95e239e/cockpit-add-new-host.png) 					

3. ​						在 **Add new host** 对话框中，指定要添加的主机。 				

4. ​						（可选）为您要连接的帐户添加用户名。 				

   ​						您可以使用远程系统的任意用户帐户。但是，如果您使用一个没有管理特权的用户凭证时，将无法执行管理任务。 				

   ​						如果您与本地系统使用相同的凭证，Web 控制台会在您登录时自动验证远程系统。但是，对更多机器使用相同的凭证可能会带来潜在的安全风险。 				

5. ​						（可选）点 **Color** 字段更改系统颜色。 				

6. ​						点击 **Add**。 				

   ​						新主机将显示在 `username@hostname` 下拉菜单中的主机列表中。 				

注意

​					Web 控制台不会保存用于登录到远程系统的密码，这意味着您必须在每次系统重启后再次登录。下次登录时，点登录 按钮放置在断开连接的远程系统的主屏幕中，以打开登录对话框。 			

​					![cockpit not connected to host](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/997335574c7dc1c25f0c819ef528c41a/cockpit-not-connected-to-host.png) 				

## 28.3. 从 web 控制台删除远程主机

​				本节介绍了从 web 控制台删除其他系统的信息。 		

**先决条件**

- ​						添加了远程系统。 				

  ​						详情请参阅[在 web 控制台中添加远程主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/managing-remote-systems-in-the-web-console_system-management-using-the-rhel-9-web-console#adding-remote-hosts-to-the-web-console_managing-remote-systems-in-the-web-console)。 				

- ​						您必须使用管理员权限登录到 web 控制台。 				

  ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						登录到 RHEL 9 web 控制台。 				

2. ​						点 **Overview** 页面左上角的 `username@hostname`。 				

   ​						![cockpit username dropdown](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/9bedb4c177625dee3fe990b5695001a4/cockpit-username-dropdown.png) 					

3. ​						点 Edit hosts 图标。 				

   ​						![cockpit edit hosts](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/cc57fcf560860902438f625c3bad3bcf/cockpit-edit-hosts.png) 					

4. ​						要从 web 控制台删除主机，请点其主机名旁的红色减号 - 按钮。请注意，您无法删除当前连接的主机。 				

   ​						![cockpit remove host](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/5d480ecee088e7bc7d4711fb7795a09d/cockpit-remove-host.png) 					

​				因此，服务器会从 web 控制台中删除。 		

## 28.4. 为新主机启用 SSH 登录

​				当您添加新主机时，您也可以使用 SSH 密钥登录。如果您的系统中已有 SSH 密钥，Web 控制台将使用现有的密钥；否则，Web 控制台可以创建密钥。 		

**先决条件**

- ​						您需要使用管理权限登录到 web 控制台。 				

  ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

**流程**

1. ​						在 RHEL 9 web 控制台中，点 **Overview** 页面左上角的 `username@hostname`。 				

   ​						![cockpit username dropdown](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/9bedb4c177625dee3fe990b5695001a4/cockpit-username-dropdown.png) 					

2. ​						在下拉菜单中选择添加新主机按钮。 				

   ​						![cockpit add new host](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/8b6cc1330f884d0d054f5e22b95e239e/cockpit-add-new-host.png) 					

3. ​						在 **Add new host** 对话框中，指定要添加的主机。 				

4. ​						为要连接的帐户添加用户名。 				

   ​						您可以使用远程系统的任意用户帐户。但是，如果您使用一个没有管理特权的用户凭证时，将无法执行管理任务。 				

5. ​						（可选）点 **Color** 字段更改系统颜色。 				

6. ​						点击 **Add**。 				

   ​						系统将显示一个新对话框窗口，要求输入密码。 				

7. ​						输入用户帐户密码。 				

8. ​						如果您已有一个 SSH 密钥，请选择 **Authorize ssh key**。 				

   ​						[![cockpit authorize ssh key](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/93bbea0f009f6e850e365ed605915b26/cockpit-authorize-ssh-key.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/93bbea0f009f6e850e365ed605915b26/cockpit-authorize-ssh-key.png) 					

9. ​						如果您没有 SSH 密钥，选择 **Create a new SSH key and authorize it**。Web 控制台会为您创建它。 				

   ​						[![cockpit ssh key add from login](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/79571c014088fed734b2aaed94bf3bc6/cockpit-ssh-key-add-from-login.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/79571c014088fed734b2aaed94bf3bc6/cockpit-ssh-key-add-from-login.png) 					

   1. ​								为 SSH 密钥添加密码。 						
   2. ​								确认密码。 						

10. ​						点 **Log in** 				

    ​						新主机将显示在 `username@hostname` 下拉菜单中的主机列表中。 				

**验证步骤**

1. ​						注销。 				

2. ​						重新登录。 				

3. ​						在 **Not connected to host** 屏幕中点 **Log in**。 				

4. ​						选择 **SSH 密钥** 作为您的身份验证选项。 				

   [![Cockpit ssh 登录对话框](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a5a3ff35e43c9dedd4a423222bcd38d2/cockpit-ssh-login-dialog.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/a5a3ff35e43c9dedd4a423222bcd38d2/cockpit-ssh-login-dialog.png)

5. ​						输入您的密钥密码。 				

6. ​						点**登录**。 				

**其它资源**

- ​						[使用 OpenSSH 的两个系统间使用安全通讯](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_using-secure-communications-between-two-systems-with-openssh_configuring-basic-system-settings) 				

## 28.5. 身份管理中的受限委托

​				用户到代理 (`S4U2proxy`) 扩展的服务为代表用户的另一服务获取服务票据。此功能称为**受限委托**。第二个服务通常是在用户的授权上下文下代表第一个服务执行某些工作的代理。使用受限委托无需用户委派其完整票据授予票 (TGT)。 		

​				身份管理 (IdM) 通常使用 Kerberos `S4U2proxy` 功能来允许 Web 服务器框架代表用户获取 LDAP 服务票据。IdM-AD 信任系统也使用受限委托来获取 `cifs` 主体。 		

​				您可以使用 `S4U2proxy` 功能配置 Web 控制台客户端，以允许使用智能卡进行身份验证的 IdM 用户来实现以下内容： 		

- ​						在运行 web 控制台服务的 RHEL 主机上以超级用户权限运行命令，而无需再次进行身份验证。 				
- ​						使用 `SSH` 访问远程主机并访问主机上的服务，而无需再次进行身份验证。 				

**其它资源**

- ​						[使用 Ansible 配置 Web 控制台，允许用户使用智能卡通过 SSH 向远程主机进行身份验证，而无需再次进行身份验证](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/configuring_and_managing_identity_management/index#proc_using-ansible-to-configure-a-web-console-to-allow-a-user-authenticated-with-a-smart-card-to-ssh-to-a-remote-host-without-being-asked-to-authenticate-again_assembly_using-constrained-delegation-in-idm) 				
- ​						[使用 Ansible 配置 Web 控制台，允许用户使用智能卡进行身份验证的用户运行 sudo，而无需再次进行身份验证](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/configuring_and_managing_identity_management/index#proc_using-ansible-to-configure-a-web-console-to-allow-a-user-authenticated-with-a-smart-card-to-run-sudo-without-being-asked-to-authenticate-again_assembly_using-constrained-delegation-in-idm) 				
- ​						[S4U2proxy](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-sfu/bde93b0e-f3c9-4ddf-9f44-e1453be7af5a) 				
- ​						[服务受限委托](https://www.freeipa.org/page/V4/Service_Constraint_Delegation) 				

## 28.6. 将 Web 控制台配置为允许使用智能卡通过 SSH 验证到远程主机的用户，而无需再次进行身份验证

​				登录到 RHEL web 控制台中的用户帐户后，作为身份管理 (IdM) 系统管理员，您可能需要使用 `SSH` 协议连接到远程机器。您可以使用[受限委托](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#con_constrained-delegation-in-identity-management_managing-remote-systems-in-the-web-console) 功能来使用 `SSH`，而无需再次进行身份验证。 		

​				此流程描述了如何配置 Web 控制台以使用受限委托。在以下示例中，web 控制台会话在 **myhost.idm.example.com** 主机上运行，它被配置为代表经过身份验证的用户使用 `SSH` 访问 **remote.idm.example.com** 主机。 		

**先决条件**

- ​						您已获得 IdM `admin` 票据授予票(TGT)。 				

- ​						您有访问 **remote.idm.example.com** 的 `root` 权限。 				

- ​						Web 控制台服务存在于 IdM 中。 				

- ​						**remote.idm.example.com** 主机存在于 IdM 中。 				

- ​						Web 控制台在用户会话中创建了一个 `S4U2Proxy` Kerberos ticket。要验证是否是这种情况，请以 IdM 用户身份登录 Web 控制台，打开 `Terminal` 页面，并输入： 				

  

  ```none
  $ klist
  Ticket cache: FILE:/run/user/1894000001/cockpit-session-3692.ccache
  Default principal: user@IDM.EXAMPLE.COM
  
  Valid starting     Expires            Service principal
  07/30/21 09:19:06 07/31/21 09:19:06 HTTP/myhost.idm.example.com@IDM.EXAMPLE.COM
  07/30/21 09:19:06  07/31/21 09:19:06  krbtgt/IDM.EXAMPLE.COM@IDM.EXAMPLE.COM
          for client HTTP/myhost.idm.example.com@IDM.EXAMPLE.COM
  ```

**流程**

1. ​						创建可以通过委派规则访问的目标主机列表： 				

   1. ​								创建服务委托目标： 						

      

      ```none
      $ ipa servicedelegationtarget-add cockpit-target
      ```

   2. ​								将目标主机添加到委派目标： 						

      

      ```none
      $ ipa servicedelegationtarget-add-member cockpit-target \ --principals=host/remote.idm.example.com@IDM.EXAMPLE.COM
      ```

2. ​						通过创建服务委派规则并将 `HTTP` 服务 Kerberos 主体添加到其中，允许 `cockpit` 会话访问目标主机列表： 				

   1. ​								创建服务委派规则： 						

      

      ```none
      $ ipa servicedelegationrule-add cockpit-delegation
      ```

   2. ​								将 Web 控制台客户端添加到委派规则中： 						

      

      ```none
      $ ipa servicedelegationrule-add-member cockpit-delegation \ --principals=HTTP/myhost.idm.example.com@IDM.EXAMPLE.COM
      ```

   3. ​								将委派目标添加到委派规则中： 						

      

      ```none
      $ ipa servicedelegationrule-add-target cockpit-delegation \ --servicedelegationtargets=cockpit-target
      ```

3. ​						在 **remote.idm.example.com** 主机上启用 Kerberos 身份验证： 				

   1. ​								以 `root` 身份通过 `SSH` 连接到 **remote.idm.example.com**。 						
   2. ​								打开 `/etc/ssh/sshd_config` 文件进行编辑。 						
   3. ​								通过取消注释 `GSSAPIAuthentication no` 行，并将它替换为 `GSSAPIAuthentication yes` 来启用 `GSSAPIAuthentication`。 						

4. ​						在 **remote.idm.example.com** 上重启 `SSH` 服务，以便上述更改会立即生效： 				

   

   ```none
   $ systemctl try-restart sshd.service
   ```

**其它资源**

- ​						[使用智能卡登录到 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/managing_systems_using_the_rhel_8_web_console/configuring-smart-card-authentication-with-the-web-console_system-management-using-the-rhel-8-web-console#logging-in-to-the-web-console-with-smart-cards_configuring-smart-card-authentication-with-the-web-console) 				
- ​						[身份管理中的受限委托](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#con_constrained-delegation-in-identity-management_managing-remote-systems-in-the-web-console) 				

## 28.7. 使用 Ansible 配置 Web 控制台，允许用户使用智能卡通过 SSH 向远程主机进行身份验证，而无需再次进行身份验证

​				登录到 RHEL web 控制台中的用户帐户后，作为身份管理 (IdM) 系统管理员，您可能需要使用 `SSH` 协议连接到远程机器。您可以使用[受限委托](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#con_constrained-delegation-in-identity-management_managing-remote-systems-in-the-web-console) 功能来使用 `SSH`，而无需再次进行身份验证。 		

​				此流程描述了如何使用 `servicedelegationrule` 和 `servicedelegationtarget` `ansible-freeipa` 模块将 Web 控制台配置为使用受限委托。在以下示例中，web 控制台会话在 **myhost.idm.example.com** 主机上运行，它被配置为代表经过身份验证的用户使用 `SSH` 访问 **remote.idm.example.com** 主机。 		

**先决条件**

- ​						IdM `admin` 密码。 				

- ​						对 **remote.idm.example.com** 的 `root` 访问权限。 				

- ​						Web 控制台服务存在于 IdM 中。 				

- ​						**remote.idm.example.com** 主机存在于 IdM 中。 				

- ​						Web 控制台在用户会话中创建了一个 `S4U2Proxy` Kerberos ticket。要验证是否是这种情况，请以 IdM 用户身份登录 Web 控制台，打开 `Terminal` 页面，并输入： 				

  

  ```none
  $ klist
  Ticket cache: FILE:/run/user/1894000001/cockpit-session-3692.ccache
  Default principal: user@IDM.EXAMPLE.COM
  
  Valid starting     Expires            Service principal
  07/30/21 09:19:06 07/31/21 09:19:06 HTTP/myhost.idm.example.com@IDM.EXAMPLE.COM
  07/30/21 09:19:06  07/31/21 09:19:06  krbtgt/IDM.EXAMPLE.COM@IDM.EXAMPLE.COM
          for client HTTP/myhost.idm.example.com@IDM.EXAMPLE.COM
  ```

- ​						您已配置了 Ansible 控制节点以满足以下要求： 				

  - ​								您使用 Ansible 版本 2.8 或更高版本。 						
  - ​								您已在 Ansible 控制器上安装了 [`ansible-freeipa`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/installing_identity_management/installing-an-identity-management-server-using-an-ansible-playbook_installing-identity-management#installing-the-ansible-freeipa-package_server-ansible) 软件包。 						
  - ​								示例假定在 **~/\*MyPlaybooks\*/** 目录中，您已创建了一个带有 IdM 服务器的完全限定域名(FQDN)的 [Ansible 清单文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/using_ansible_to_install_and_manage_identity_management/preparing-your-environment-for-managing-idm-using-ansible-playbooks_using-ansible-to-install-and-manage-identity-management)。 						
  - ​								示例假定 **secret.yml** Ansible vault 存储了 `ipaadmin_password`。 						

**流程**

1. ​						进入您的 **~/\*MyPlaybooks\*/** 目录： 				

   

   ```none
   $ cd ~/MyPlaybooks/
   ```

2. ​						创建包含以下内容的 `web-console-smart-card-ssh.yml` playbook： 				

   1. ​								创建确保存在委派目标的任务： 						

      

      ```none
      ---
      - name: Playbook to create a constrained delegation target
        hosts: ipaserver
      
        vars_files:
        - /home/user_name/MyPlaybooks/secret.yml
        tasks:
        - name: Ensure servicedelegationtarget web-console-delegation-target is present
          ipaservicedelegationtarget:
            ipaadmin_password: "{{ ipaadmin_password }}"
            name: web-console-delegation-target
      ```

   2. ​								添加将目标主机添加到委派目标的任务： 						

      

      ```none
        - name: Ensure servicedelegationtarget web-console-delegation-target member principal host/remote.idm.example.com@IDM.EXAMPLE.COM is present
          ipaservicedelegationtarget:
            ipaadmin_password: "{{ ipaadmin_password }}"
            name: web-console-delegation-target
            principal: host/remote.idm.example.com@IDM.EXAMPLE.COM
            action: member
      ```

   3. ​								添加一个任务来确保存在委派规则： 						

      

      ```none
        - name: Ensure servicedelegationrule delegation-rule is present
          ipaservicedelegationrule:
            ipaadmin_password: "{{ ipaadmin_password }}"
            name: web-console-delegation-rule
      ```

   4. ​								添加一项任务，该任务确保 Web 控制台客户端服务的 Kerberos 主体是受限委派规则的成员： 						

      

      ```none
        - name: Ensure the Kerberos principal of the web console client service is added to the servicedelegationrule web-console-delegation-rule
          ipaservicedelegationrule:
            ipaadmin_password: "{{ ipaadmin_password }}"
            name: web-console-delegation-rule
            principal: HTTP/myhost.idm.example.com
            action: member
      ```

   5. ​								添加一个任务，以确保 delegation 规则与 web-console-delegation-target 委派目标关联： 						

      

      ```none
        - name: Ensure a constrained delegation rule is associated with a specific delegation target
          ipaservicedelegationrule:
            ipaadmin_password: "{{ ipaadmin_password }}"
            name: web-console-delegation-rule
            target: web-console-delegation-target
            action: member
      ```

3. ​						保存该文件。 				

4. ​						运行 Ansible playbook。指定 playbook 文件、存储保护 **secret.yml** 文件的密码，以及清单文件： 				

   

   ```none
   $ ansible-playbook --vault-password-file=password_file -v -i inventory web-console-smart-card-ssh.yml
   ```

5. ​						在 **remote.idm.example.com** 上启用 Kerberos 身份验证： 				

   1. ​								以 `root` 身份通过 `SSH` 连接到 **remote.idm.example.com**。 						
   2. ​								打开 `/etc/ssh/sshd_config` 文件进行编辑。 						
   3. ​								通过取消注释 `GSSAPIAuthentication no` 行，并将它替换为 `GSSAPIAuthentication yes` 来启用 `GSSAPIAuthentication`。 						

**其它资源**

- ​						[使用智能卡登录到 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring-smart-card-authentication-with-the-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console-with-smart-cards_configuring-smart-card-authentication-with-the-web-console) 				
- ​						[身份管理中的受限委托](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index#con_constrained-delegation-in-identity-management_managing-remote-systems-in-the-web-console) 				
- ​						`/usr/share/doc/ansible-freeipa/` 目录中的 `README-servicedelegationrule.md` 和 `README-servicedelegationtarget.md` 				
- ​						`/usr/share/doc/ansible-freeipa/playbooks/servicedelegationtarget` 和 `/usr/share/doc/ansible-freeipa/playbooks/servicedelegationrule` 目录中的 playbook 示例 				

# 第 29 章 为 IdM 域中的 RHEL 9 web 控制台配置单点登录

​			了解如何使用 RHEL 9 web 控制台中的 Identity Management(IdM)提供的单点登录(SSO)身份验证。 	

​			优点： 	

- ​					IdM 域管理员可以使用 RHEL 9 web 控制台来管理本地机器。 			
- ​					IdM 域中具有 Kerberos 票据的用户不需要提供登录凭据来访问 Web 控制台。 			
- ​					IdM 域已知的所有主机均可通过 RHEL 9 web 控制台本地实例的 SSH 访问。 			
- ​					不需要证书配置。控制台的 Web 服务器会自动切换到 IdM 证书颁发机构发布的证书，并被浏览器接受。 			

​			本章论述了配置用于登录到 RHEL web 控制台的 SSO 的步骤： 	

1. ​					使用 RHEL 9 web 控制台将机器添加到 IdM 域中。 			

   ​					详情请参阅[使用 Web 控制台将 RHEL 9 系统添加到 IdM 域中](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring_single_sign_on_for_the_rhel_8_web_console_in_the_idm_domain_system-management-using-the-rhel-9-web-console#joining-a-rhel-8-system-to-an-idm-domain-using-the-web-console_configuring-single-sign-on-for-the-web-console-in-the-idm-domain)。 			

2. ​					如果要使用 Kerberos 进行身份验证，则需要在机器上获得 Kerberos ticket。 			

   ​					详情请参阅[使用 Kerberos 身份验证登录到 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring_single_sign_on_for_the_rhel_8_web_console_in_the_idm_domain_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console-using-a-kerberos-ticket_configuring-single-sign-on-for-the-web-console-in-the-idm-domain)。 			

3. ​					允许 IdM 服务器上的管理员在任何主机上运行任何命令。 			

   ​					详情请参阅[为 IdM 服务器上的域管理员启用管理员的 admin sudo 访问权限](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring_single_sign_on_for_the_rhel_8_web_console_in_the_idm_domain_system-management-using-the-rhel-9-web-console#enabling-admin-sudo-access-to-domain-administrators-on-the-idm-server_configuring-single-sign-on-for-the-web-console-in-the-idm-domain) 			

**先决条件**

- ​					在 RHEL 9 系统上安装的 RHEL web 控制台。 			

  ​					详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 			

- ​					在使用 RHEL web 控制台的系统中安装 IdM 客户端。 			

  ​					详情请查看 [IdM 客户端安装](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_identity_management/index#installing-an-ipa-client-basic-scenario)。 			

## 29.1. 使用 web 控制台将 RHEL 9 系统添加到 IdM 域中

​				您可以使用 Web 控制台将 Red Hat Enterprise Linux 9 系统添加到 Identity Management(IdM)域中。 		

**先决条件**

- ​						IdM 域正在运行，并可访问您想要加入的客户端。 				
- ​						您有 IdM 域管理员凭证。 				

**流程**

1. ​						登录到 RHEL web 控制台。 				

   ​						详情请参阅 [Web 控制台的日志记录](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#logging-in-to-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

2. ​						在 **Overview** 选项卡的 **Configuration** 字段中点 **Join Domain**。 				

3. ​						在 **Join a Domain** 对话框的 **Domain Address** 字段中输入 IdM 服务器的主机名。 				

4. ​						在 **Domain administrator name** 字段中输入 IdM 管理帐户的用户名。 				

5. ​						在域 **管理员密码** 中，添加密码。 				

6. ​						点 Join。 				

**验证步骤**

1. ​						如果 RHEL 9 web 控制台没有显示错误，系统已加入到 IdM 域，您可以在 **System** 屏幕中看到域名。 				

2. ​						要验证该用户是否为域的成员，点 Terminal 页面并输入 `id` 命令： 				

   

   ```none
   $ id
   euid=548800004(example_user) gid=548800004(example_user) groups=548800004(example_user) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
   ```

**其它资源**

- ​						[规划身份管理](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/planning_identity_management/index) 				
- ​						[安装身份管理](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/installing_identity_management/index) 				
- ​						[管理 IdM 用户、组、主机和访问控制规则](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_idm_users_groups_hosts_and_access_control_rules/index) 				

## 29.2. 使用 Kerberos 身份验证登录到 web 控制台

​				以下流程描述了如何设置 RHEL 9 系统以使用 Kerberos 验证的步骤。 		

重要

​					使用 SSO 时，通常在 Web 控制台中拥有任何管理特权。这只有在您配置了免密码 sudo 时有效。Web 控制台不以交互方式询问 sudo 密码。 			

**先决条件**

- ​						IdM 域在您的公司环境中运行并可访问。 				

  ​						详情请参阅[使用 Web 控制台将 RHEL 9 系统添加到 IdM 域中](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring_single_sign_on_for_the_rhel_8_web_console_in_the_idm_domain_system-management-using-the-rhel-9-web-console#joining-a-rhel-8-system-to-an-idm-domain-using-the-web-console_configuring-single-sign-on-for-the-web-console-in-the-idm-domain)。 				

- ​						在您要通过 RHEL web 控制台连接和管理的远程系统中启用 `cockpit.socket` 服务。 				

  ​						详情请参阅[安装 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_system-management-using-the-rhel-9-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)。 				

- ​						如果系统没有使用 SSSD 客户端管理的 Kerberos ticket，请尝试使用 `kinit` 程序手动请求 ticket。 				

**流程**

​					使用以下地址登录到 RHEL web 控制台：`https://dns_name:9090` 			

​				此时，您已成功连接到 RHEL web 控制台，您可以使用配置启动。 		

​				[![A screenshot of the web console with a menu in a column along the left that has the following buttons: System - Logs - Storage - Networking - Accounts - Services - Applications - Diagnostic Reports - Kernel Dump - SELinux. The "System" option has been chosen and displays details for the system such as Hardware - Machine ID - Operating system - Secure Shell Keys - Hostname - and others. 3 graphs display usage of CPUs over time - use of Memory and Swap over time - and Disk I/O over time.](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b6fe536ed401ee02d68bed066e72abf3/idm-cockpit-logging-done.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_systems_using_the_RHEL_9_web_console-zh-CN/images/b6fe536ed401ee02d68bed066e72abf3/idm-cockpit-logging-done.png) 			

## 29.3. 为 IdM 服务器上的域管理员启用管理员 sudo 访问权限

​				以下流程描述了如何让域管理员在 Identity Management(IdM)域中的任何主机上运行任何命令的步骤。 		

​				要实现这一目的，请启用对 IdM 服务器安装过程中自动创建的 **admins** 用户组的 sudo 访问权限。 		

​				如果在组上运行 `ipa-advise` 脚本，添加到 **admins** 组的所有用户都将具有 sudo 访问权限。 		

**先决条件**

- ​						服务器运行 IdM 4.7.1 或更高版本。 				

**流程**

1. ​						连接到 IdM 服务器。 				

2. ​						运行 ipa-advise 脚本： 				

   

   ```none
   $ ipa-advise enable-admins-sudo | sh -ex
   ```

​				如果控制台没有显示错误，则 **admins** 组对 IdM 域中的所有机器都有 admin 权限。 		

# 第 30 章 使用 Web 控制台为集中管理的用户配置智能卡验证

​			在 RHEL web 控制台中为集中管理的用户配置智能卡验证： 	

- ​					身份管理 			
- ​					Active Directory，它在 Identity Management 的跨林信任中连接 			

**先决条件**

- ​					您要使用智能卡验证的系统必须是 Active Directory 或 Identity Management 域的成员。 			

- ​					用于智能卡验证的证书必须与身份管理或 Active Directory 中的特定用户关联。 			

  ​					有关在 Identity Management 中将证书与用户关联的详情，请参阅[在 IdM Web UI 中的用户条目中添加证书](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_smart_card_authentication/configuring-idm-for-smart-card-auth_managing-smart-card-authentication#proc-add-cert-idm-user-webui_configuring-idm-for-smart-card-auth)，或[将证书添加到 IdM CLI 中的用户条目中](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_smart_card_authentication/configuring-idm-for-smart-card-auth_managing-smart-card-authentication#proc-add-cert-idm-user-cli_configuring-idm-for-smart-card-auth)。 			

## 30.1. 实现中央管理用户的智能卡验证

​				智能卡是一个物理设备，可以使用保存在卡中的证书提供个人验证。个人验证意味着，您可以象使用用户密码一样使用智能卡。 		

​				您可以使用私钥和证书的形式在智能卡中保存用户凭证。特殊的软件和硬件可用于访问它们。您可以将智能卡插入到读取器或者 USB 套接字中，并为智能卡提供 PIN 代码，而不是提供密码。 		

​				身份管理(IdM)支持使用如下方式的智能卡身份验证： 		

- ​						IdM 证书颁发机构发布的用户证书。 				
- ​						Active Directory 证书服务(ADCS)证书颁发机构发布的用户证书。 				

注意

​					如果要使用智能卡验证，请参阅硬件要求：[RHEL8+ 中的智能卡支持](https://access.redhat.com/articles/4253861)。 			

## 30.2. 安装用来管理和使用智能卡的工具

​				要配置智能卡，您需要一些工具来生成证书并将其保存在智能卡中。 		

​				您必须： 		

- ​						安装 `gnutls-utils` 软件包，它可帮助您管理证书。 				
- ​						安装 `opensc` 软件包，它提供一组库和实用程序来使用智能卡。 				
- ​						启动 `pcscd` 服务，该服务与智能卡读取器通信。 				

**流程**

1. ​						安装 `opensc` 和 `gnutls-utils` 软件包： 				

   

   ```none
   # dnf -y install opensc gnutls-utils
   ```

2. ​						启动 `pcscd` 服务。 				

   

   ```none
   # systemctl start pcscd
   ```

​				验证 `pcscd` 服务是否已启动并运行。 		

## 30.3. 准备智能卡并将证书和密钥上传到智能卡

​				本节描述了使用 `pkcs15-init` 工具配置智能卡，该工具可帮助您配置： 		

- ​						擦除智能卡 				
- ​						设置新的 PIN 和可选的 PIN Unblocking Keys（PUKs） 				
- ​						在智能卡上创建新插槽 				
- ​						在插槽存储证书、私钥和公钥 				
- ​						如果需要，请锁定智能卡设置，因为某些智能卡需要这个类型的最终化 				

注意

​					`pkcs15-init` 工具可能无法使用所有智能卡。您必须使用您使用智能卡的工具。 			

**先决条件**

- ​						已安装 `opensc` 软件包，其中包括 `pkcs15-init` 工具。 				

  ​						详情请查看[安装用于管理和使用智能卡的工具](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_smart_card_authentication/configuring-idm-for-smart-card-auth_managing-smart-card-authentication#installing-tools-for-managing-and-using-smart-cards_configuring-idm-for-smart-card-auth)。 				

- ​						该卡插入读卡器并连接到计算机。 				

- ​						您有可保存在智能卡中的私钥、公钥和证书。在此流程中，`testuser.key`、`testuserpublic.key` 和 `testuser.crt` 是用于私钥、公钥和证书的名称。 				

- ​						您有当前的智能卡用户 PIN 和 Security Officer PIN (SO-PIN)。 				

**流程**

1. ​						擦除智能卡并使用您的 PIN 验证自己： 				

   

   ```none
   $ pkcs15-init --erase-card --use-default-transport-keys
   Using reader with a card: Reader name
   PIN [Security Officer PIN] required.
   Please enter PIN [Security Officer PIN]:
   ```

   ​						这个卡已经被清除。 				

2. ​						初始化智能卡，设置您的用户 PIN 和 PUK，以及您的安全响应 PIN 和 PUK： 				

   

   ```none
   $ pkcs15-init --create-pkcs15 --use-default-transport-keys \
       --pin 963214 --puk 321478 --so-pin 65498714 --so-puk 784123
   Using reader with a card: Reader name
   ```

   ​						`pcks15-init` 工具在智能卡上创建一个新插槽。 				

3. ​						为插槽设置标签和验证 ID： 				

   

   ```none
   $ pkcs15-init --store-pin --label testuser \
       --auth-id 01 --so-pin 65498714 --pin 963214 --puk 321478
   Using reader with a card: Reader name
   ```

   ​						标签设置为人类可读的值，在本例中为 `testuser`。`auth-id` 必须是两个十六进制值，在本例中设为 `01`。 				

4. ​						在智能卡的新插槽中存储并标记私钥： 				

   

   ```none
   $ pkcs15-init --store-private-key testuser.key --label testuser_key \
       --auth-id 01 --id 01 --pin 963214
   Using reader with a card: Reader name
   ```

   注意

   ​							在存储您的私钥并将证书存储在下一步中时，您为 `--id` 指定的值必须相同。建议为 `--id` 指定自己的值，否则它们将更复杂的值由工具计算。 					

5. ​						在智能卡上的新插槽中存储并标记该证书： 				

   

   ```none
   $ pkcs15-init --store-certificate testuser.crt --label testuser_crt \
       --auth-id 01 --id 01 --format pem --pin 963214
   Using reader with a card: Reader name
   ```

6. ​						（可选）在智能卡上新插槽中保存并标记公钥： 				

   

   ```none
   $ pkcs15-init --store-public-key testuserpublic.key
       --label testuserpublic_key --auth-id 01 --id 01 --pin 963214
   Using reader with a card: Reader name
   ```

   注意

   ​							如果公钥与私钥或证书对应，请指定与私钥或证书的 ID 相同的 ID。 					

7. ​						（可选）Certain 智能卡要求您通过锁定设置来完善卡： 				

   

   ```none
   $ pkcs15-init -F
   ```

   ​						此时您的智能卡在新创建的插槽中包含证书、私钥和公钥。您还创建了您的用户 PIN 和 PUK，以及安全响应 PIN 和 PUK。 				

## 30.4. 为 web 控制台启用智能卡验证

​				要在 web 控制台中使用智能卡验证，请在 `cockpit.conf` 文件中启用智能卡验证。 		

​				另外，您还可以在同一文件中禁用密码验证。 		

**先决条件**

- ​						已安装 RHEL web 控制台。 				

  **流程**

  1. ​								使用管理员权限登录到 RHEL web 控制台。 						

  2. ​								点 **Terminal**。 						

  3. ​								在 `/etc/cockpit/cockpit.conf` 中，将 `ClientCertAuthentication` 设置为 `yes` ： 						

     

     ```none
     [WebService]
     ClientCertAuthentication = yes
     ```

  4. ​								另外，还可通过以下命令禁用 `cockpit.conf` 中基于密码的身份验证： 						

     

     ```none
     [Basic]
     action = none
     ```

     ​								这个配置禁用了密码验证，且必须总是使用智能卡。 						

  5. ​								重启 Web 控制台，以确保 `cockpit.service` 接受更改： 						

     

     ```none
     # systemctl restart cockpit
     ```

## 30.5. 使用智能卡登录到 web 控制台

​				您可以使用智能卡登录到 web 控制台。 		

**先决条件**

- ​						保存在智能卡中的有效证书，该证书与 Active Directory 或 Identity Management 域中的用户帐户关联。 				
- ​						PIN 用于解锁智能卡。 				
- ​						已经将智能卡放入读卡器。 				

**流程**

1. ​						打开 Web 浏览器，并在地址栏中添加 Web 控制台的地址。 				

   ​						浏览器要求您添加 PIN 保护保存在智能卡中的证书。 				

2. ​						在 **Password Required** 对话框中，输入 PIN 并点 **OK**。 				

3. ​						在 **User Identification Request** 对话框中，选择保存在智能卡中的证书。 				

4. ​						选择 **Remember this decision**。 				

   ​						系统下次打开这个窗口。 				

   注意

   ​							此步骤不适用于 Google Chrome 用户。 					

5. ​						点击 **确定**。 				

​				您现在已连接，Web 控制台会显示其内容。 		

## 30.6. 为智能卡用户启用免密码 sudo

​				使用证书登录到 web 控制台后，您可能需要切换到管理模式（通过 `sudo`进行 root 权限）。如果您的用户帐户有密码，它可以用于对 `sudo` 进行身份验证。 		

​				另外，如果您使用 Red Hat Identity Management，您可以声明初始 Web 控制台证书身份验证，以对 `sudo`、SSH 或其他服务进行身份验证。为此，Web 控制台会在用户会话中自动创建 S4U2Proxy Kerberos ticket。 		

**先决条件**

- ​						身份管理 				
- ​						使用 Identity Management 在跨林信任中连接的活跃目录 				
- ​						设置为登录到 web 控制台的智能卡。如需更多信息，请参阅[使用 Web 控制台配置智能卡验证](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/configuring-smart-card-authentication-with-the-web-console_system-management-using-the-rhel-9-web-console)。 				

**流程**

1. ​						设置约束委派规则，以列出托管票据可以访问哪些主机。 				

   例 30.1. 设置约束委派规则

   ​							Web 控制台会话运行主机 `host.example.com`，并应受信任，以通过 `sudo` 访问自己的主机。此外，我们还添加了第二个可信主机 - `remote.example.com`。 					

   - ​									创建以下委派： 							

     - ​											运行以下命令添加特定规则可以访问的目标机器列表： 									

       

       ```none
       # ipa servicedelegationtarget-add cockpit-target
       # ipa servicedelegationtarget-add-member cockpit-target \
          --principals=host/host.example.com@EXAMPLE.COM \
          --principals=host/remote.example.com@EXAMPLE.COM
       ```

     - ​											要允许 web 控制台会话(HTTP/principal)访问该主机列表，请运行以下命令： 									

       

       ```none
       # ipa servicedelegationrule-add cockpit-delegation
       # ipa servicedelegationrule-add-member cockpit-delegation \
         --principals=HTTP/host.example.com@EXAMPLE.COM
       # ipa servicedelegationrule-add-target cockpit-delegation \
         --servicedelegationtargets=cockpit-target
       ```

2. ​						在对应服务中启用 GSS 身份验证： 				

   1. ​								对于 sudo，在 `/etc/sssd/sssd.conf` 文件中启用 `pam_sss_gss` 模块： 						

      1. ​										以 root 用户身份，将域的条目添加到 `/etc/sssd/sssd.conf` 配置文件。 								

         

         ```none
         [domain/example.com]
         pam_gssapi_services = sudo, sudo-i
         ```

      2. ​										在第一行启用 `/etc/pam.d/sudo` 文件中的模块。 								

         

         ```none
         auth sufficient pam_sss_gss.so
         ```

   2. ​								对于 SSH，将 `/etc/ssh/sshd_config` 文件中的 `GSSAPIAuthentication` 选项更新为 `yes`。 						

警告

​					从 Web 控制台连接到远程 SSH 主机时，委派的 S4U 票据不会被转发到远程 SSH 主机。使用您的票据在远程主机上向 sudo 进行身份验证将无法正常工作。 			

**验证**

1. ​						使用智能卡登录到 web 控制台。 				
2. ​						点 `Limited access` 按钮。 				
3. ​						使用您的智能卡进行验证。 				

​				或者 		

1. ​						尝试使用 SSH 连接到其他主机。 				

## 30.7. 限制用户会话和内存以防止 DoS 攻击

​				证书验证通过分离和隔离 `cockpit-ws` Web 服务器实例，以防范想要模拟其他用户的攻击者。但是，这会产生潜在的 Service(DoS)攻击：远程攻击者可以创建大量证书，并将大量 HTTPS 请求发送到 `cockpit-ws` 各自使用不同的证书。 		

​				为防止这一 DoS，这些 Web 服务器实例的收集资源受到限制。默认情况下，对连接数量和内存用量限制为 200 个线程，且具有 75%（软）/ 90%（硬）内存限值。 		

​				以下流程描述了通过限制连接和内存量的资源保护。 		

**流程**

1. ​						在终端中，打开 `system-cockpithttps.slice` 配置文件： 				

   

   ```none
   # systemctl edit system-cockpithttps.slice
   ```

2. ​						将 `TasksMax` 限制为 *100*，将 `CPUQuota` 限制为 *30%* ： 				

   

   ```none
   [Slice]
   # change existing value
   TasksMax=100
   # add new restriction
   CPUQuota=30%
   ```

3. ​						要应用这些更改，请重启系统： 				

   

   ```none
   # systemctl daemon-reload
   # systemctl stop cockpit
   ```

​				现在，新的内存和用户会话限制了 `cockpit-ws` Web 服务器不受 DoS 攻击。 		