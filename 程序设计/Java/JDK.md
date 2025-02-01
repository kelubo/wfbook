# 在 RHEL 上配置 OpenJDK 17

OpenJDK 17

##  

 Red Hat Customer Content Services  

[法律通告](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#idm140293215874736)

**摘要**

​				OpenJDK 是 Red Hat Enterprise Linux 平台上的红帽产品。在 *RHEL 上配置 OpenJDK 17* 指南提供了此产品的概述，并解释了如何配置软件。 		

------

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。要提供反馈，您可以突出显示文档中的文本并添加注释。 	

​			本节介绍如何提交反馈。 	

**先决条件**

- ​					已登陆到红帽客户门户网站。 			
- ​					在红帽客户门户中，以**多页 HTML** 格式查看文档。 			

**流程**

​				要提供反馈，请执行以下步骤： 		

1. ​					点文档右上角的**反馈**按钮查看现有的反馈。 			

   注意

   ​						反馈功能仅在**多页 HTML** 格式中启用。 				

2. ​					高亮标记您要提供反馈的文档中的部分。 			

3. ​					点在高亮文本旁弹出的 **Add Feedback**。 			

   ​					文本框将在页面右侧的"反馈"部分中打开。 			

4. ​					在文本框中输入您的反馈，然后点 **Submit**。 			

   ​					创建了一个与文档相关的问题。 			

5. ​					要查看问题，请单击反馈视图中的问题跟踪器链接。 			

# 第 1 章 在 RHEL 中以交互方式选择系统范围的 OpenJDK 版本

​			如果您在 RHEL 中安装了多个 OpenJDK 版本，您可以以交互方式选择使用默认的 OpenJDK 版本来使用系统范围。 	

注意

​				如果您没有 root 特权，您可以通过配置 [ `JAVA_HOME` 环境变量来选择 OpenJDK 版本。](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#configuring-javahome-environment-variable-on-rhel) 		

**先决条件**

- ​					必须具有系统上的 root 权限。 			
- ​					OpenJDK 的多个版本使用 `yum` 软件包管理器安装。 			

**流程**

1. ​					查看系统上安装的 OpenJDK 版本。 			

   ​					`$ yum list installed "java the"` 			

   ​					此时会出现已安装的 Java 软件包列表。 			

   

   ```none
   Installed Packages
   java-1.8.0-openjdk.x86_64                       1:1.8.0.302.b08-0.el8_4               @rhel-8-appstream-rpms
   java-11-openjdk.x86_64                          1:11.0.12.0.7-0.el8_4                 @rhel-8-appstream-rpms
   java-11-openjdk-headless.x86_64                 1:11.0.12.0.7-0.el8_4                 @rhel-8-appstream-rpms
   java-17-openjdk.x86_64                          1:17.0.0.0.35-4.el8                   @rhel-8-appstream-rpms
   java-17-openjdk-headless.x86_64                 1:17.0.0.0.35-4.el8                   @rhel-8-appstream-rpms
   ```

2. ​					显示可用于特定 `java` 命令的 OpenJDK 版本，并选择要使用的 OpenJDK 版本： 			

   

   ```none
   $ sudo alternatives --config java
   There are 3 programs which provide 'java'.
   
     Selection    Command
   -----------------------------------------------
      1           java-11-openjdk.x86_64 (/usr/lib/jvm/java-11-openjdk-11.0.12.0.7-0.el8_4.x86_64/bin/java)
   *  2           java-1.8.0-openjdk.x86_64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.302.b08-0.el8_4.x86_64/jre/bin/java)
    + 3           java-17-openjdk.x86_64 (/usr/lib/jvm/java-17-openjdk-17.0.0.0.35-4.el8.x86_64/bin/java)
   
   
   
   Enter to keep the current selection[+], or type selection number: 1
   ```

   - ​							当前系统范围的 OpenJDK 版本被标记为星号。 					
   - ​							指定 `java` 命令的当前 OpenJDK 版本被标记为加号。 					

3. ​					按 **Enter** 键保留当前的选择，**或者** 输入您要选择的 OpenJDK 版本的选择号，后跟 **Enter** 键。 			

   ​					系统的默认 OpenJDK 版本是所选版本。 			

4. ​					验证是否选择了所选二进制文件。 			

   

   ```none
   $ java -version
   openjdk version "17" 2021-09-14
   OpenJDK Runtime Environment 21.9 (build 17+35)
   OpenJDK 64-Bit Server VM 21.9 (build 17+35, mixed mode, sharing)
   ```

   注意

   ​						此流程配置 `java` 命令。然后，可以使用类似方式设置 `javac` 命令，但它可以独立运行。 				

   ​					如果您安装了 OpenJDK，`替代方案会` 提供更多可能的选择。特别是，`javac` master 替代方案会切换 `-devel` 子软件包提供的很多二进制文件。 			

   ​					即使安装了 OpenJDK，`java` （和其他 JRE master）和其他 JRE master （及其他 OpenJDK master）仍然单独运行，因此您可以为 JRE 和 JDK 具有不同的选择。```alternatives --config java` 命令会影响 `jre` 及其关联的从设备。 			

   ​					如果要更改 OpenJDK，请使用 `javac alternatives` 命令。`--config javac` 工具配置 `SDK` 和相关的从设备。要查看所有可能的 master，请使用 `alternatives --list` 并检查所有 java、` java c`、`jre` 和 `sdk` master。 			

# 第 2 章 在 RHEL 中非互动选择系统范围的 OpenJDK 版本

​			如果您在 RHEL 中安装了多个 OpenJDK 版本，您可以选择默认 OpenJDK 版本以非互动方式使用系统范围系统。这对在 Red  Hat Enterprise Linux 系统上具有 root 权限的管理员有用，并且需要以自动化的方式切换多个系统上的默认 OpenJDK。 	

注意

​				如果您没有 root 特权，您可以通过配置 [ `JAVA_HOME` 环境变量来](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#configuring-javahome-environment-variable-on-rhel) 选择 OpenJDK 版本。 		

**先决条件**

- ​					必须具有系统上的 root 权限。 			
- ​					OpenJDK 的多个版本使用 `yum` 软件包管理器安装。 			

**流程**

1. ​					选择要切换到的主 OpenJDK 版本。例如，对于 OpenJDK 17，请使用 `java-17-openjdk`。 			

   

   ```none
   # PKG_NAME=java-17-openjdk
   # JAVA_TO_SELECT=$(alternatives --display java | grep "family $PKG_NAME" | cut -d' ' -f1)
   # alternatives --set java $JAVA_TO_SELECT
   ```

2. ​					验证活跃的 OpenJDK 版本是您指定的版本。 			

   

   ```none
   $ java -version
   openjdk version "17" 2021-09-14
   OpenJDK Runtime Environment 21.9 (build 17+35)
   OpenJDK 64-Bit Server VM 21.9 (build 17+35, mixed mode, sharing)
   ```

# 第 3 章 为特定应用程序选择已安装的 OpenJDK 版本

​			有些应用程序需要运行特定的 OpenJDK 版本。如果使用 `yum` 软件包管理器或可移植捆绑包在系统中安装了 OpenJDK 的多个版本，您可以通过设置 `JAVA_HOME` 环境变量的值或使用 wrapper 脚本根据需要为每个应用程序选择一个 OpenJDK 版本。 	

**先决条件**

- ​					在机器上安装的多个 OpenJDK 版本。 			
- ​					确保已安装您要运行的应用程序。 			

**流程**

1. ​					设置 `JAVA_HOME` 环境变量。例如，如果使用 `yum` 安装 OpenJDK 17： 			

   ​					`$ JAVA_HOME=/usr/lib/jvm/java-17-openjdk` 			

   注意

   ​						符号链接 `java-17-openjdk` 由 `alternatives` 命令控制。 				

2. ​					执行以下操作之一： 			

   - ​							使用默认的系统范围的配置启动应用程序。 					

     

     ```none
     $ mvn --version
     Apache Maven 3.5.4 (Red Hat 3.5.4-5)
     Maven home: /usr/share/maven
     Java version: 11.0.9, vendor: Oracle Corporation, runtime: /usr/lib/jvm/java-11-openjdk-11.0.9.10-0.el8_0.x86_644/jre
     Default locale: en_US, platform encoding: UTF-8
     OS name: "linux", version: "4.18.0-144.el8.x86_64", arch: "amd64", family: "unix"
     ```

   - ​							启动指定 `JAVA_HOME` 变量的应用程序： 					

     

     ```none
     $ JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.0.0.35-4.el8.x86_64/ mvn --version
     
     Apache Maven 3.5.4 (Red Hat 3.5.4-5)
     Maven home: /usr/share/maven
     Java version: 17, vendor: Red Hat, Inc., runtime: /usr/lib/jvm/java-17-openjdk-17.0.0.0.35-4.el8.x86_64
     Default locale: en_US, platform encoding: UTF-8
     OS name: "linux", version: "4.18.0-305.19.1.el8_4.x86_64", arch: "amd64", family: "unix"
     ```

# 第 4 章 选择系统范围的归档 OpenJDK 版本

​			如果您在 RHEL 上安装了多个版本的 OpenJDK，您可以选择一个特定的 OpenJDK 版本来使用系统范围。 	

**先决条件**

- ​					了解使用存档安装的 OpenJDK 版本的位置。 			

**流程**

​				指定用于单个会话的 OpenJDK 版本： 		

1. ​					使用您要使用系统范围的 OpenJDK 版本的路径配置 `JAVA_HOME`。 			

   ​					`$ export JAVA_HOME=/opt/jdk/openjdk-17.0.0.0.35` 			

2. ​					将 `$JAVA_HOME/bin` 添加到 `PATH` 环境变量。 			

   ​					`$ export PATH="$JAVA_HOME/bin:$PATH"` 			

​			要指定为单个用户永久使用的 OpenJDK 版本，请将这些命令添加到 `~/.bashrc` 中： 	



```none
export JAVA_HOME=/opt/jdk/openjdk-17.0.0.0.35
export PATH="$JAVA_HOME/bin:$PATH"
```

​			要指定为所有用户永久使用的 OpenJDK 版本，请将这些命令添加到 `/etc/bashrc` 中： 	



```none
export JAVA_HOME=/opt/jdk/openjdk-17.0.0.0.35
export PATH="$JAVA_HOME/bin:$PATH"
```

注意

​				如果您不想重新定义 `JAVA_HOME`，请将 PATH 命令添加到 `bashrc` 中，指定到 Java 二进制文件的路径。例如，`export PATH="/opt/jdk/openjdk-17.0.0.0.35/bin:$PATH"`。 		

**其他资源**

- ​					请注意 `JAVA_HOME` 的确切含义。如需更多信息，请参阅 java [命令设置中的更改/删除系统 java 设置](https://fedoraproject.org/wiki/Changes/Decouple_system_java_setting_from_java_command_setting)。 			

# 第 5 章 在 RHEL 上配置 JAVA_HOME 环境变量

​			有些应用程序需要您设置 `JAVA_HOME` 环境变量，以便可以找到 OpenJDK 安装。 	

**先决条件**

- ​					您知道您在系统中安装 OpenJDK 的位置。例如： `/opt/jdk/11`。 			

**流程**

1. ​					设置 `JAVA_HOME` 的值。 			

   

   ```none
   $ export JAVA_HOME=/opt/jdk/11
   ```

2. ​					验证 `JAVA_HOME` 是否已正确设置。 			

   

   ```none
   $ printenv | grep JAVA_HOME
   JAVA_HOME=/opt/jdk/11
   ```

   注意

   ​						您可以通过在 `~/.bashrc` 中为单个用户或 `/etc/bashrc` 导出系统范围的设置，使 `JAVA_HOME` 的值具有持久性。Persistent 意味着，如果您关闭终端或重新引导计算机，则不需要为 `JAVA_HOME` 环境变量重置值。 				

   ​						以下示例演示了使用文本编辑器为单个用户在 `~/.bashrc` 中输入用于导出 `JAVA_HOME` 的命令： 				

   

   ```none
   > vi ~/.bash_profile
   
   export JAVA_HOME=/opt/jdk/11
   export PATH="$JAVA_HOME/bin:$PATH"
   ```

**其他资源**

- ​					请注意 `JAVA_HOME` 的确切含义。如需更多信息，请参阅 java [命令设置中的更改/删除系统 java 设置](https://fedoraproject.org/wiki/Changes/Decouple_system_java_setting_from_java_command_setting)。 			

# 第 6 章 在 RHEL 上为 OpenJDK 应用程序配置堆大小

​			您可以将 OpenJDK 配置为使用自定义堆大小。 	

**流程**

- ​					在运行应用程序时，将最大堆大小选项添加到 `java` 命令中。例如，要将最大堆大小设置为 100MB，请使用 `-Xmx100m` 选项： 			

  

  ```none
  $ java -Xmx100m <your_application_name>
  ```

**其他资源**

- ​					有关 `Xmx` 选项的更多信息，请参阅 [Java 文档中的](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html#BABDJJFI) **-Xmxsize**。 			

​			*更新于 2023-04-24* 	

# Eclipse Temurin 入门

OpenJDK 17

## 指南

**摘要**

​				Eclipse Temurin 文档入门提供了此产品的概述，并解释了如何安装软件并开始使用。 		

------

# 前言

​			Open Java Development Kit(OpenJDK)是 Java Platform, Standard  Edition(Java SE)的免费且开源实现。Eclipse Temurin 有三个 LTS 版本：OpenJDK 8u、OpenJDK  11u 和 OpenJDK 17u。 	

​			用于 Eclipse Temurin 的软件包在 Microsoft Windows 上提供，并在多个 Linux x86 操作系统（包括 Red Hat Enterprise Linux 和 Ubuntu）上提供。 	

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。有关更多详情，请参阅[我们的首席技术官 Chris Wright 提供的消息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 第 1 章 OpenJDK 的支持策略

​			红帽将会支持在其产品中精选的 OpenJDK 主要版本。为保持一致性，这些版本与被指定为长期支持(LTS)的 Oracle JDK 版本保持相似。 	

​			从红帽首次推出 OpenJDK 时，Red Hat 支持 OpenJDK 的主要版本最少为 6 年。 	

​			Microsoft Windows 和 Red Hat Enterprise Linux 上支持 OpenJDK 17，直到 11 月 2027 日为止。 	

注意

​				RHEL 6 在 2020 年 11 月达到生命周期结束。因此，OpenJDK 不支持 RHEL 6 作为支持的配置。 		

**其他资源**

​				请参阅 [OpenJDK 生命周期和支持政策（红帽客户门户网站）](https://access.redhat.com/articles/1299013) 		

# 第 2 章 Eclipse Temurin 概述

​			Eclipse Temurin 是 Eclipse Temurin 工作组中 Java 平台标准版本(Java  SE)的免费开源实施。Eclipse Temurin 基于上游 OpenJDK 8u、OpenJDK 11u 和 OpenJDK 17u  项目，包括来自版本 11 及更新的版本的 Shenandoah 垃圾收集器。 	

​			Eclipse Temurin 与 OpenJDK 的上游发行版本不相同。Eclipse Temurin 与 OpenJDK 相似的功能共享： 	

- ​					多平台 - 红帽在 Microsoft Windows、RHEL 和 macOS 上提供对 Eclipse Temurin 的支持，以便您可以在多个环境中（如桌面、数据中心和混合云）上标准化。 			
- ​					频繁发布的版本 - Eclipse Temurin 为 OpenJDK 8、OpenJDK 11 和 OpenJDK 17 发行版本提供 JRE 和 JDK 的季度更新。这些更新可用，如 RPM、MSI、归档文件和容器。 			
- ​					长期支持(LTS)- 红帽支持最近发布的 Eclipse Temurin 8、Eclipse Temurin 11 和 Eclipse Temurin 17。有关支持生命周期的更多信息，请参阅 [OpenJDK 生命周期和支持政策](https://access.redhat.com/articles/1299013)。 			

# 第 3 章 下载 Eclipse Temurin 发行版本

​			您可以从许多来源下载 Eclipse Temurin 发行版，如 Eclipse Adoptium 网站。 	

​			Eclipse Adoptium 主网页和 Eclipse Temurin 网页均包括几个下载不同 Eclipse Temurin 发行版的下载按钮。 	

**流程**

1. ​					选择以下选项之一下载 Eclipse Temurin 发行版： 			
   1. ​							在 [Adoptium 主页](https://adoptium.net/) 或 [Eclipse Temurin 项目页面中](https://adoptium.net/temurin/)，点击 web 页面中的以下按钮之一： 					
      - ​									对于检测到您使用的平台，`最新 LTS Release` 按钮可预选择 OpenJDK 17，并开始下载该选择。 							
      - ​									`其他定向到所有平台和版本` 选项的平台和版本按钮，您可以在其中选择最适合您不同格式的分发版本，如存档、JRE 归档和安装程序等。 							
      - ​									`版本归档` 按钮可定向到特定的最新版本、旧版本和每日测试版。Eclipse Adoptium 为开发提供旧版本和 beta 版本。beta 版本包含 OpenJDK 的最新更改，您可以在开发模式中验证修复程序很有用。测试版本不被视为生产环境，红帽不直接被红帽支持。 							
   2. ​							使用 Eclipse Adoptium API，查看 [Swagger UI v3 文档 Eclipse Temurin](https://api.adoptium.net/q/swagger-ui/#/)。 					
   3. ​							在 Eclipse Temurin Docker Hub Official Images 中，请参见 [eclipse-temurin 文档(docker hub)](https://hub.docker.com/_/eclipse-temurin)。 					
   4. ​							通过 [AdoptiumTM Marketplace 网页，使用 Eclipse Temurin Marketplace API。](https://adoptium.net/marketplace/)此网页列出了各种发行版，如 Red Hat build of OpenJDK 和 Eclipse Temurin。另外，您可以向 [Eclipse Adoptium Marketplace API v1](https://marketplace-api.adoptium.net/) 发出请求，以服务这些发行版。 					
   5. ​							有关 [`package.adoptium.net`](https://packages.adoptium.net/ui/packages)，请查看 [Eclipse Temurin Linux(RPM/DEB)Installer Packages(Eclipse Adoptium)](https://blog.adoptium.net/2021/12/eclipse-temurin-linux-installers-available/) 中概述的相关步骤。 					

**其他资源**

- ​					[Adoptium 主页(Adoptium)](https://adoptium.net/) 			
- ​					[Eclipse Temurin(Adoptium)](https://adoptium.net/temurin/) 			

# 第 4 章 发行选择

​			Eclipse Temurin 会生成 OpenJDK 的几个发行版本。红帽对这些发行版的子集提供支持。 	

​			OpenJDK 的所有 Eclipse Temurin 发行版本都包含 JDK Flight Recorder(JFR)功能。此功能生成诊断和性能分析数据，供其他应用程序使用，如 JDK Mission Control(JMC)。 	

​			为了帮助选择适合您的需求的分发，请参阅有关 [Eclipse Temurin(Red Hat Customer Portal)的支持的支持](https://access.redhat.com/articles/1299013)。 	

**其他资源**

- ​					[TemurinTM 支持的平台(Adoptium)](https://adoptium.net/supported-platforms/) 			
- ​					[Eclipse Mission Control(Adoptium)](https://adoptium.net/jmc/) 			
- ​					[JDK Flight Recorder OpenJDK 简介](https://access.redhat.com/documentation/en-us/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/assembly_openjdk-flight-recorder-overview_openjdk) 			

​			*在 2022-08-28 09:45:23 +1000 上修订* 	、

# 在 RHEL 上安装并使用 OpenJDK 17

OpenJDK 17

##  

 Red Hat Customer Content Services  

[法律通告](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/installing_and_using_openjdk_17_on_rhel/index#idm140256390220960)

**摘要**

​				OpenJDK 是 Red Hat Enterprise Linux 平台上的红帽产品。*安装和使用 OpenJDK 17* 指南概述了此产品，并解释了如何安装软件和开始使用它。 		

------

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。要提供反馈，您可以突出显示文档中的文本并添加注释。 	

​			本节介绍如何提交反馈。 	

**先决条件**

- ​					登录到红帽客户门户网站。 			
- ​					在红帽客户门户网站中，以 **多页 HTML** 格式查看文档。 			

**流程**

​				要提供反馈，请执行以下步骤： 		

1. ​					点文档右上角的 **Feedback** 按钮查看现有的反馈。 			

   注意

   ​						反馈功能仅在**多页 HTML** 格式中启用。 				

2. ​					高亮标记您要提供反馈的文档中的部分。 			

3. ​					点在高亮文本旁弹出的 **Add Feedback**。 			

   ​					文本框中会出现在页面右侧的 feedback 部分中。 			

4. ​					在文本框中输入您的反馈，然后点 **Submit**。 			

   ​					文档问题已创建。 			

5. ​					要查看问题，请单击反馈视图中的问题跟踪器链接。 			

# 第 1 章 OpenJDK 17 概述

​			OpenJDK (Open Java Development Kit)是 Java Platform, Standard Edition  (Java SE)的免费开源实现。Red Hat build of OpenJDK 有三个版本：OpenJDK 8u、OpenJDK 11u 和 OpenJDK 17u。 	

​			Red Hat build of OpenJDK 的软件包包括在 Red Hat Enterprise Linux 和 Microsoft Windows 上，并作为 Red Hat Ecosystem Catalog 中的 JDK 和 JRE 提供。 	

# 第 2 章 在 Red Hat Enterprise Linux 上安装 OpenJDK 17

​			OpenJDK 是一个用于开发和运行各种平台无关应用程序的环境，从移动应用程序到桌面和 Web 应用程序和企业系统。红帽提供了名为 OpenJDK 的 Java Platform SE （标准版本）的开源实现。 	

​			使用 JDK (Java Development Kit)开发应用程序。应用在 JVM (Java 虚拟机)上运行，它包含在 JRE  (Java Runtime Environment)和 JDK 中。还有一个 Java  的无头版本，其占用空间最小，不包括用户界面所需的库。无头版本打包在无头子软件包中。 	

注意

​				如果您不确定是否需要 JRE 还是 JDK，建议您安装 JDK。 		

​			以下小节提供了在 Red Hat Enterprise Linux 上安装 OpenJDK 的说明。 	

注意

​				您可以在本地系统中安装 OpenJDK 的多个主要版本。如果您需要从一个主要版本切换到另一个主要版本，请在命令行界面(CLI)中运行以下命令，然后按照屏幕提示进行操作： 		



```none
$ sudo update-alternatives --config 'java'
```

## 2.1. 使用 yum 在 RHEL 上安装 JRE

​				您可以使用系统软件包管理器 `yum` 安装 OpenJDK Java Runtime Environment (JRE)。 		

**先决条件**

- ​						以具有 root 权限的用户身份登录系统。 				
- ​						将本地系统注册到您的 Red Hat Subscription Manager 帐户。请参阅 [*使用 Red Hat Subscription Manager 用户注册系统*](https://access.redhat.com/documentation/zh-cn/red_hat_subscription_management/1/html-single/using_red_hat_subscription_management/index#registration_con) 指南。 				

**流程**

1. ​						运行 `yum` 命令，指定您要安装的软件包： 				

   

   ```none
   $ sudo yum install java-17-openjdk
   ```

2. ​						检查安装是否正常工作： 				

   

   ```none
   $ java -version
   
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   ```

   注意

   ​							如果上一命令的输出显示您系统中有一个不同的 OpenJDK 主版本，您可以在 CLI 中输入以下命令来切换您的系统以使用 OpenJDK 17： 					

   

   ```none
   $ sudo update-alternatives --config 'java'
   ```

## 2.2. 使用归档在 RHEL 上安装 JRE

​				您可以使用存档安装 OpenJDK Java 运行时环境(JRE)。如果 Java 管理员没有 root 特权，这将非常有用。 		

注意

​					为便于以后的版本升级，请创建一个包含您的 JRE 的父目录，并使用通用路径创建指向最新 JRE 的符号链接。 			

**流程**

1. ​						创建要下载归档文件的目录，然后导航到命令行界面(CLI)上的该目录。例如： 				

   

   ```none
   $ mkdir ~/jres
   
   $ cd ~/jres
   ```

2. ​						导航到红帽客户门户网站中的 [Software Downloads](https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?product=core.service.openjdk&downloadType=distributions) 页面。 				

3. ​						从 **Version** 下拉列表中选择最新版本的 OpenJDK 17，然后将 Linux 的 JRE 归档下载到本地系统。 				

4. ​						将存档内容提取到您选择的目录中： 				

   

   ```none
   $ tar -xf java-17-openjdk-17.0.2.0.8-3.portable.jre.el7.x86_64.tar.xz -C ~/jres
   ```

5. ​						使用到您的 JRE 的符号链接创建通用路径以便更轻松地进行升级： 				

   

   ```none
   $ ln -s ~/jres/java-17-openjdk-17.0.2.0.8-3.portable.jdk.el7.x86_64 ~/jres/java-17
   ```

6. ​						配置 `JAVA_HOME` 环境变量： 				

   

   ```none
   $ export JAVA_HOME=~/jres/java-17
   ```

7. ​						验证 `JAVA_HOME` 环境变量是否已正确设置： 				

   

   ```none
   $ printenv | grep JAVA_HOME
   JAVA_HOME=~/jres/java-17
   ```

   注意

   ​							使用此方法安装时，Java 仅适用于当前用户。 					

8. ​						为 `PATH` 环境变量添加通用 JRE 路径的 `bin` 目录： 				

   

   ```none
   $ export PATH="$JAVA_HOME/bin:$PATH"
   ```

9. ​						验证 `java -version` 是否可以提供完整路径： 				

   

   ```none
   $ java -version
   
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   ```

   注意

   ​							您可以通过在 `~/.bashrc` 中导出环境变量来确保当前用户保留 `JAVA_HOME` 环境变量。 					

## 2.3. 使用 yum 在 RHEL 上安装 OpenJDK

​				您可以使用系统软件包管理器 `yum` 安装 OpenJDK。 		

**先决条件**

- ​						以具有 root 权限的用户身份登录。 				
- ​						将本地系统注册到您的 Red Hat Subscription Manager 帐户。请参阅 [*使用 Red Hat Subscription Manager 用户注册系统*](https://access.redhat.com/documentation/zh-cn/red_hat_subscription_management/1/html-single/using_red_hat_subscription_management/index#registration_con) 指南。 				

**流程**

1. ​						运行 `yum` 命令，指定您要安装的软件包： 				

   

   ```none
   $ sudo yum install java-17-openjdk-devel
   ```

2. ​						检查安装是否正常工作： 				

   

   ```none
   $ javac -version
   
   javac 17.0.2
   ```

## 2.4. 使用归档在 RHEL 上安装 OpenJDK

​				您可以使用存档安装 OpenJDK。如果 Java 管理员没有 root 特权，这将非常有用。 		

注意

​					为简化升级，请创建一个包含您的 JRE 的父目录，并使用通用路径创建指向最新 JRE 的符号链接。 			

**流程**

1. ​						创建要下载归档文件的目录，然后导航到命令行界面(CLI)上的该目录。例如： 				

   

   ```none
   $ mkdir ~/jdks
   
   $ cd ~/jdks
   ```

2. ​						导航到红帽客户门户网站中的 [Software Downloads](https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?product=core.service.openjdk&downloadType=distributions) 页面。 				

3. ​						从 **Version** 下拉列表中选择最新版本的 OpenJDK 17，然后将 Linux 的 JDK 存档下载到本地系统。 				

4. ​						将存档内容提取到您选择的目录中： 				

   

   ```none
   $ tar -xf java-17-openjdk-17.0.2.0.8-3.portable.jre.el7.x86_64.tar.xz -C ~/jdks
   ```

5. ​						使用 JDK 的符号链接创建通用路径以便更轻松地进行升级： 				

   

   ```none
   $ ln -s ~/jdks/java-17-openjdk-17.0.2.0.8-3.portable.jdk.el7.x86_64 ~/jdks/java-17
   ```

6. ​						配置 `JAVA_HOME` 环境变量： 				

   

   ```none
   $ export JAVA_HOME=~/jdks/java-17
   ```

7. ​						验证 `JAVA_HOME` 环境变量是否已正确设置： 				

   

   ```none
   $ printenv | grep JAVA_HOME
   JAVA_HOME=~/jdks/java-17
   ```

   注意

   ​							使用此方法安装时，Java 仅适用于当前用户。 					

8. ​						为 `PATH` 环境变量添加通用 JRE 路径的 `bin` 目录： 				

   

   ```none
   $ export PATH="$JAVA_HOME/bin:$PATH"
   ```

9. ​						验证 `java -version` 是否可以提供完整路径： 				

   

   ```none
   $ java -version
   
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   ```

注意

​					您可以通过在 `~/.bashrc` 中导出环境变量来确保当前用户保留 `JAVA_HOME` 环境变量。 			

## 2.5. 使用 yum 在 RHEL 上安装多个 OpenJDK 主版本

​				您可以使用系统软件包管理器 `yum` 安装多个 OpenJDK 版本。 		

**先决条件**

- ​						具有有效订阅的 Red Hat Subscription Manager (RHSM)帐户，提供对提供您要安装的 OpenJDK 的存储库的访问。 				
- ​						必须具有系统上的 root 权限。 				

**流程**

1. ​						运行以下 `yum` 命令来安装软件包： 				

   ​						OpenJDK 17 				

   

   ```none
   $ sudo yum install java-17-openjdk
   ```

   ​						对于 OpenJDK 11 				

   

   ```none
   $ sudo yum install java-11-openjdk
   ```

   ​						对于 OpenJDK 8 				

   

   ```none
   $ sudo yum install java-1.8.0-openjdk
   ```

2. ​						安装后，检查可用的 Java 版本： 				

   

   ```none
   $ sudo yum list installed "java*"
   
   Installed Packages
   
   java-1.8.0-openjdk.x86_64    1:1.8.0.322.b06-2.el8_5    @rhel-8-for-x86_64-appstream-rpms
   java-11-openjdk.x86_64    1:11.0.14.0.9-2.el8_5    @rhel-8-for-x86_64-appstream-rpms
   java-17-openjdk.x86_64    1:17.0.2.0.8-4.el8_5    @rhel-8-for-x86_64-appstream-rpms
   ```

3. ​						检查当前的 java 版本： 				

   

   ```none
   $ java -version
   
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   ```

   注意

   ​							您可以在本地系统中安装 OpenJDK 的多个主要版本。如果您需要从一个主要版本切换到另一个主要版本，请在命令行界面(CLI)中运行以下命令，然后按照屏幕提示进行操作： 					

   

   ```none
   $ sudo update-alternatives --config 'java'
   ```

**其他资源**

- ​						您可以使用 `java --alternatives` 将默认 Java 版本配置为使用。如需更多信息，请参阅 [RHEL 上的非交互选择系统范围的 OpenJDK 版本](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#noninteractively-selecting-systemwide-openjdk-version-on-rhel)。 				

## 2.6. 使用归档在 RHEL 上安装多个 OpenJDK 主版本

​				您可以使用使用归档在 *RHEL 上安装 JRE 中的相同步骤安装 OpenJDK 的多个主要版本，或 \*使用多个主要版本的归档\* 在 RHEL 8 上安装 OpenJDK*。 		

注意

​					有关如何为系统配置默认 OpenJDK 版本的说明，请参阅 [选择系统范围的 java 版本](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#noninteractively-selecting-systemwide-openjdk-version-on-rhel)。 			

**其他资源**

- ​						有关安装 JRE 的说明，请参阅使用 [归档在 RHEL 上安装 JRE](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/#installing-jre-on-rhel-using-archive_openjdk)。 				
- ​						有关安装 JDK 的说明，请参阅使用 [归档在 RHEL 8 上安装 OpenJDK](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/index#installing-jdk11-on-rhel-using-archive_openjdk)。 				

## 2.7. 使用 yum 在 RHEL 上安装多个 OpenJDK 的次版本

​				您可以在 RHEL 上安装 OpenJDK 的多个次版本。这可以通过防止安装的次版本被更新来实现。 		

**先决条件**

- ​						从 [非交互方式选择 OpenJDK 的系统范围版本，在 RHEL 上选择一个系统范围的 OpenJDK 版本](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#noninteractively-selecting-systemwide-openjdk-version-on-rhel)。 				

**流程**

1. ​						在 `/etc/yum.conf` 目录中添加 `installonlypkgs` 选项，以指定 `yum` 可以安装但不更新的 OpenJDK 软件包。 				

   

   ```none
   installonlypkgs=java-<version>--openjdk,java-<version>--openjdk-headless,java-<version>--openjdk-devel
   ```

   ​						更新将安装新的软件包，同时在系统中保留旧版本。 				

   

   ```none
   $ rpm -qa | grep java-17.0.2-openjdk
   
   java-17-openjdk-17.0.1.0.12-2.el8_5.x86_64
   java-17-openjdk-17.0.2.0.8-4.el8_5.x86_64
   ```

2. ​						OpenJDK 的不同次版本可以在 `/usr/lib/jvm/ <*minor version>*` 文件中找到。 				

   ​						例如，下面显示了 `/usr/lib/jvm/java-17.0.2-openjdk` 的一部分： 				

   

   ```none
   $ /usr/lib/jvm/java-17-openjdk-17.0.2.0.8-4.el8_5.x86_64/bin/java -version
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   
   $ /usr/lib/jvm/java-17-openjdk-17.0.1.0.12-2.el8_5.x86_64/bin/java -version
   openjdk version "17" 2021-10-19
   OpenJDK Runtime Environment 21.9 (build 17+35)
   OpenJDK 64-Bit Server VM 21.9 (build 17+35, mixed mode, sharing)
   ```

## 2.8. 使用归档在 RHEL 上安装多个 OpenJDK 的次版本

​				安装多个次版本与使用归档在 RHEL 上安装 JRE 相同，或使用多个次版本的归档在 RHEL 8 上安装 OpenJDK。 		

注意

​					有关如何为系统选择默认次版本的说明，请参阅非交互 [地选择 RHEL 上的系统范围 OpenJDK 版本](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel/index#noninteractively-selecting-systemwide-openjdk-version-on-rhel)。 			

**其他资源**

- ​						有关安装 JRE 的说明，请参阅使用 [归档在 RHEL 上安装 JRE](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/#installing-jre-on-rhel-using-archive_openjdk)。 				
- ​						有关安装 JDK 的说明，请参阅使用 [归档在 RHEL 8 上安装 OpenJDK](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/index#installing-jdk11-on-rhel-using-archive_openjdk)。 				

# 第 3 章 OpenJDK 17 的调试符号

​			调试符号有助于在 OpenJDK 应用程序中调查崩溃。 	

## 3.1. 安装调试符号

​				这个步骤描述了如何为 OpenJDK 安装 debug 符号。 		

**先决条件**

- ​						在本地 sytem 上安装了 `gdb` 软件包。 				
  - ​								您可以在 CLI 中发出 `sudo yum install gdb` 命令，以便在本地系统中安装这个软件包。 						

**流程**

1. ​						要安装 debug 符号，请输入以下命令： 				

   

   ```none
   $ sudo debuginfo-install java-17-openjdk
   
   $ sudo debuginfo-install java-17-openjdk-headless
   ```

   ​						这些命令安装 `java-17-openjdk-debuginfo`、`java-17-openjdk-headless-debuginfo` 以及为 OpenJDK 17 二进制文件提供调试符号的其他软件包。这些软件包不是自足的，*不包含* 可执行的二进制文件。 				

   注意

   ​							`debuginfo-install` 由 `yum-utils` 软件包提供。 					

2. ​						要验证是否安装了 debug 符号，请输入以下命令： 				

   

   ```none
   $ gdb which java
   
   Reading symbols from /usr/bin/java...Reading symbols from /usr/lib/debug/usr/lib/jvm/java-17-openjdk-17.0.2.0.8-4.el8_5/bin/java-17.0.2.0.8-4.el8_5.x86_64.debug...done.
   (gdb)
   ```

## 3.2. 检查调试符号的安装位置

​				此流程解释了如何查找调试符号的位置。 		

注意

​					如果安装了 `debuginfo` 软件包，但无法获取软件包的安装位置，然后检查是否安装了正确的软件包和 java 版本。确认版本后，再次检查调试符号的位置。 			

**先决条件**

- ​						在本地 sytem 上安装了 `gdb` 软件包。 				
  - ​								您可以在 CLI 中发出 `sudo yum install gdb` 命令，以便在本地系统中安装这个软件包。 						
  - ​								安装 debug 符号软件包。[请参阅安装 debug 符号](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel#installing-debug-symbols_openjdk)。 						

**流程**

1. ​						要查找调试符号的位置，请在 `哪个 java` 命令中使用 `gdb` ： 				

   

   ```none
   $ gdb which java
   
   Reading symbols from /usr/bin/java...Reading symbols from /usr/lib/debug/usr/lib/jvm/java-17-openjdk-17.0.2.0.8-4.el8_5/bin/java-17.0.2.0.8-4.el8_5.x86_64.debug...done.
   (gdb)
   ```

2. ​						使用以下命令来探索 `*-debug` 目录来查看库的所有调试版本，其中包括 `java`、`javac` 和 `javah` ： 				

   

   ```none
   $ cd /usr/lib/debug/lib/jvm/java-17-openjdk-17.0.2.0.8-4.el8_5
   ```

   

   ```none
   $ tree
   
   OJDK 17 version:
   └── java-17-openjdk-17.0.2.0.8-4.el8_5
   ├── bin
   │   ...
   │ │──  java-java-17.0.2.0.8-4.el8_5.x86_64.debug
   │   ├── javac-java-17.0.2.0.8-4.el8_5.x86_64.debug
   │   ├── javadoc-java-17.0.2.0.8-4.el8_5.x86_64.debug
   │   ...
   └── lib
   ├── jexec-java-17.0.2.0.8-4.el8_5.x86_64.debug
   ├── jli
   │   └── libjli.so-java-17.0.2.0.8-4.el8_5.x86_64.debug
   ├── jspawnhelper-java-17.0.2.0.8-4.el8_5.x86_64.debug
   │   ...
   ```

注意

​					`javac` 和 `javah` 工具由 `java-17-openjdk-devel` 软件包提供。您可以使用 命令来安装软件包 `：$ sudo debuginfo-install java-17-openjdk-devel`。 			

## 3.3. 检查调试符号的配置

​				您可以检查和设置调试符号的配置。 		

- ​						输入以下命令获取安装的软件包列表： 				

  

  ```none
  $ sudo yum list installed | grep 'java-17-openjdk-debuginfo'
  ```

- ​						如果没有安装一些调试信息软件包，请输入以下命令安装缺少的软件包： 				

  

  ```none
  $ sudo yum debuginfo-install glibc-2.28-151.el8.x86_64 libgcc-8.4.1-1.el8.x86_64 libstdc++-8.4.1-1.el8.x86_64 sssd-client-2.4.0-9.el8.x86_64 zlib-1.2.11-17.el8.x86_64
  ```

- ​						如果要点击特定的断点，请运行以下命令： 				

  

  ```none
  $ gdb -ex 'handle SIGSEGV noprint nostop pass' -ex 'set breakpoint pending on' -ex 'break JavaCalls::call' -ex 'run' --args java ./HelloWorld
  ```

  ​						以上命令完成以下任务： 				

  - ​								处理 SIGSEGV 错误，因为 JVM 使用 SEGV 进行堆栈溢出检查。 						
  - ​								将待处理断点设置为 `yes`。 						
  - ​								调用 `JavaCalls::call` 函数中的 break 语句。在 HotSpot (libjvm.so)中启动应用程序的功能。 						

## 3.4. 在致命错误日志文件中配置调试符号

​				当 Java 应用因为 JVM 崩溃而停机时，会生成致命错误日志文件，例如： `hs_error`,`java_error`.这些错误日志文件在应用的当前工作目录中生成。崩溃文件包含堆栈中的信息。 		

**流程**

1. ​						您可以使用 `strip -g` 命令删除所有调试符号。 				

   ​						以下代码显示了非往返 `hs_error` 文件的示例： 				

   

   ```none
   Native frames: (J=compiled Java code, j=interpreted, Vv=VM code, C=native code)
   V  [libjvm.so+0xb83d2a]  Unsafe_SetLong+0xda
   j  sun.misc.Unsafe.putLong(Ljava/lang/Object;JJ)V+0
   j  Crash.main([Ljava/lang/String;)V+8
   v  ~StubRoutines::call_stub
   V  [libjvm.so+0x6c0e65]  JavaCalls::call_helper(JavaValue*, methodHandle*, JavaCallArguments*, Thread*)+0xc85
   V  [libjvm.so+0x73cc0d]  jni_invoke_static(JNIEnv_*, JavaValue*, _jobject*, JNICallType, _jmethodID*, JNI_ArgumentPusher*, Thread*) [clone .constprop.1]+0x31d
   V  [libjvm.so+0x73fd16]  jni_CallStaticVoidMethod+0x186
   C  [libjli.so+0x48a2]  JavaMain+0x472
   C  [libpthread.so.0+0x9432]  start_thread+0xe2
   ```

   ​						以下代码显示了一个剥离的 `hs_error` 文件示例： 				

   

   ```none
   Stack: [0x00007ff7e1a44000,0x00007ff7e1b44000],  sp=0x00007ff7e1b42850,  free space=1018k
   Native frames: (J=compiled Java code, j=interpreted, Vv=VM code, C=native code)
   V  [libjvm.so+0xa7ecab]
   j  sun.misc.Unsafe.putAddress(JJ)V+0
   j  Crash.crash()V+5
   j  Crash.main([Ljava/lang/String;)V+0
   v  ~StubRoutines::call_stub
   V  [libjvm.so+0x67133a]
   V  [libjvm.so+0x682bca]
   V  [libjvm.so+0x6968b6]
   C  [libjli.so+0x3989]
   C  [libpthread.so.0+0x7dd5]  start_thread+0xc5
   ```

2. ​						输入以下命令检查是否有相同的 debug 符号版本以及致命错误日志文件： 				

   

   ```none
   $ java -version
   ```

   注意

   ​							您还可以使用 `sudo update-alternatives --config 'java'` 完成此检查。 					

3. ​						使用 `nm` 命令，确保 `libjvm.so` 具有 ELF 数据和文本符号： 				

   

   ```none
   $ nm /usr/lib/debug/usr/lib/jvm/java-17-openjdk-17.0.2.0.8-4.el8_5/lib/server/libjvm.so-17.0.2.0.8-4.el8_5.x86_64.debug
   ```

**其他资源**

- ​						崩溃文件 `hs_error` 没有安装 debug 符号。如需更多信息，请参阅 [因为 JVM 崩溃导致 Java 应用](https://access.redhat.com/solutions/20507)。 				

# 第 4 章 在 Red Hat Enterprise Linux 上更新 OpenJDK 17

​			以下小节提供了在 Red Hat Enterprise Linux 上更新 OpenJDK 17 的说明。 	

## 4.1. 使用 yum 更新 RHEL 上的 OpenJDK 17

​				可以使用 `yum` system 软件包管理器更新已安装的 OpenJDK 软件包。 		

**先决条件**

- ​						必须具有系统上的 root 权限。 				

**流程**

1. ​						检查当前的 OpenJDK 版本： 				

   

   ```none
   $ sudo yum list installed "java*"
   ```

   ​						此时会显示已安装的 OpenJDK 软件包的列表。 				

   

   ```none
   Installed Packages
   
   java-1.8.0-openjdk.x86_64    1:1.8.0.322.b06-2.el8_5    @rhel-8-for-x86_64-appstream-rpms
   java-11-openjdk.x86_64    1:11.0.14.0.9-2.el8_5    @rhel-8-for-x86_64-appstream-rpms
   java-17-openjdk.x86_64    1:17.0.2.0.8-4.el8_5    @rhel-8-for-x86_64-appstream-rpms
   ```

2. ​						更新特定软件包。例如： 				

   

   ```none
   $ sudo yum update java-17-openjdk
   ```

3. ​						通过检查当前的 OpenJDK 版本来验证更新是否正常工作： 				

   

   ```none
   $ java -version
   
   openjdk version "17.0.2" 2022-01-18 LTS
   OpenJDK Runtime Environment 21.9 (build 17.0.2+8-LTS)
   OpenJDK 64-Bit Server VM 21.9 (build 17.0.2+8-LTS, mixed mode, sharing)
   ```

   注意

   ​							您可以在本地系统中安装 OpenJDK 的多个主要版本。如果您需要从一个主要版本切换到另一个主要版本，请在命令行界面(CLI)中运行以下命令，然后按照屏幕提示进行操作： 					

   

   ```none
   $ sudo update-alternatives --config 'java'
   ```

## 4.2. 使用存档更新 RHEL 上的 OpenJDK 17

​				您可以使用存档更新 OpenJDK。如果 OpenJDK 管理员没有 root 权限，这很有用。 		

**先决条件**

- ​						了解指向 JDK 或 JRE 安装的通用路径。例如： `~/jdks/java-17` 				

**流程**

1. ​						删除 JDK 或 JRE 的通用路径的现有符号链接。 				

   ​						例如： 				

   

   ```none
   $ unlink ~/jdks/java-17
   ```

2. ​						在您的安装位置安装 JDK 或 JRE 的最新版本。 				

**其他资源**

- ​						有关安装 JRE 的说明，请参阅使用 [归档在 RHEL 上安装 JRE](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/#installing-jre-on-rhel-using-archive_openjdk)。 				
- ​						有关安装 JDK 的说明，请参阅使用 [归档在 RHEL 8 上安装 OpenJDK](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/installing_and_using_openjdk_17_on_rhel/index#installing-jdk11-on-rhel-using-archive_openjdk)。 				

​				*更新于 2023-04-06* 		

# Getting started with OpenJDK 17

OpenJDK 17

##  

 Red Hat Customer Content Services  

[Legal Notice](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/getting_started_with_openjdk_17/index#idm139733898275120)

**Abstract**

​				OpenJDK is a Red Hat offering on Microsoft Windows and Red Hat Enterprise Linux platforms. The *Getting Started with OpenJDK 17* guide provides an overview of this product and explains how to install the software and start using it. 		

------

# Making open source more inclusive

​			Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. Because of the enormity  of this endeavor, these changes will be implemented gradually over  several upcoming releases. For more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language). 	

# Providing feedback on Red Hat documentation

​			We appreciate your feedback on our documentation. To provide  feedback, you can highlight the text in a document and add comments. 	

​			This section explains how to submit feedback. 	

**Prerequisites**

- ​					You are logged in to the Red Hat Customer Portal. 			
- ​					In the Red Hat Customer Portal, view the document in **Multi-page HTML** format. 			

**Procedure**

​				To provide your feedback, perform the following steps: 		

1. ​					Click the **Feedback** button in the top-right corner of the document to see existing feedback. 			

   Note

   ​						The feedback feature is enabled only in the **Multi-page HTML** format. 				

2. ​					Highlight the section of the document where you want to provide feedback. 			

3. ​					Click the **Add Feedback** pop-up that appears near the highlighted text. 			

   ​					A text box appears in the feedback section on the right side of the page. 			

4. ​					Enter your feedback in the text box and click **Submit**. 			

   ​					A documentation issue is created. 			

5. ​					To view the issue, click the issue tracker link in the feedback view. 			

# Chapter 1. Red Hat build of OpenJDK overview

​			The Red Hat build of OpenJDK is a free and open source implementation of the Java Platform, Standard Edition (Java SE). It is based on the  upstream OpenJDK 8u, OpenJDK 11u, and OpenJDK 17u projects and includes  the Shenandoah Garbage Collector in all versions. 	

- ​					**Multi-platform** - The Red Hat build of OpenJDK is now supported on Windows and RHEL. This helps you standardize on a single Java platform across desktop,  datacenter, and hybrid cloud. 			
- ​					**Frequent releases** - Red Hat delivers quarterly updates of JRE and JDK for the OpenJDK 8,  OpenJDK 11, and OpenJDK 17 distributions. These are available as `rpm`, portables, `msi`, `zip` files and containers. 			
- ​					**Long-term support** - Red Hat supports the recently released OpenJDK 8, OpenJDK 11, and  OpenJDK 17 distributions. For more information about the support  lifecycle, see [OpenJDK Life Cycle and Support Policy](https://access.redhat.com/articles/1299013). 			
- ​					**Java Web Start** - Red Hat build of OpenJDK supports Java Web Start for RHEL. 			

# Chapter 2. Differences from upstream OpenJDK 17

​			OpenJDK in Red Hat Enterprise Linux contains a number of structural  changes from the upstream distribution of OpenJDK. The Windows version  of OpenJDK attempts to follow Red Hat Enterprise Linux updates as  closely as possible. 	

​			The following list details the most notable Red Hat OpenJDK 17 changes: 	

- ​					FIPS support. Red Hat OpenJDK 17 automatically detects whether the  RHEL system is in FIPS mode and automatically configures OpenJDK 17 to  operate in that mode. This change does not apply to OpenJDK builds for  Microsoft Windows. 			
- ​					Cryptographic policy support. Red Hat OpenJDK 17 obtains the list  of enabled cryptographic algorithms and key size constraints, which are  used by for the TLS, a certificate path validation, and signed JARs,  from the Red Hat Enterprise Linux system configuration. You can set  different security profiles to balance safety and compatibility. This  change does not apply to OpenJDK builds for Microsoft Windows. 			
- ​					Red Hat Enterprise Linux dynamically links against native libraries such as `zlib` for archive format support and `libjpeg-turbo`, `libpng`, and `giflib` for image support. RHEL also dynamically links against `Harfzbuzz` and `Freetype` for font rendering and management. 			
- ​					The `src.zip` file includes the source for all of the JAR libraries shipped with OpenJDK. 			
- ​					Red Hat Enterprise Linux uses system-wide timezone data files as a source for timezone information. 			
- ​					Red Hat Enterprise Linux uses system-wide CA certificates. 			
- ​					Microsoft Windows includes the latest available timezone data from Red Hat Enterprise Linux. 			
- ​					Microsoft Windows uses the latest available CA certificate from Red Hat Enterprise Linux. 			

**Additional resources**

- ​					For more information about detecting if a system is in FIPS mode, see the [Improve system FIPS detection](https://issues.redhat.com/browse/RHELPLAN-67668) example on the Red Hat RHEL Planning Jira web page. 			
- ​					For more information about cryptographic policies, see [Using system-wide cryptographic policies](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening) in the Red Hat Enterprise Linux *Security hardening* guide. 			

# Chapter 3. Distribution selection

​			Red Hat provides several distributions of OpenJDK. This module helps  you select the distribution that is right for your needs. All  distributions of OpenJDK contain the JDK Flight Recorder (JFR) feature.  This feature produces diagnostics and profiling data that can be  consumed by other applications, such as JDK Mission Control (JMC). 	

- OpenJDK RPMs for RHEL 8

  ​						RPM distributions of OpenJDK 8, OpenJDK 11, and OpenJDK 17 for RHEL 8. 				

- OpenJDK 8 JRE portable archive for RHEL

  ​						Portable OpenJDK 8 JRE archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK 8 portable archive for RHEL

  ​						Portable OpenJDK 8 archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK 11 JRE portable archive for RHEL

  ​						Portable OpenJDK 11 JRE archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK 11 portable archive for RHEL

  ​						Portable OpenJDK 11 archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK 17 JRE portable archive for RHEL

  ​						Portable OpenJDK 17 JRE archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK 17 portable archive for RHEL

  ​						Portable OpenJDK 17 archive distribution for RHEL 7 and 8 hosts. 				

- OpenJDK archive for Windows

  ​						OpenJDK 8, OpenJDK 11, and OpenJDK 17 distributions for all  supported Windows hosts. Recommended for cases where multiple OpenJDK  versions may be installed on a host. This distribution includes the  following: 				 							Java Web Start 						 							Mission Control 						

- OpenJDK installers for Windows

  ​						OpenJDK 8, OpenJDK 11, and OpenJDK 17 MSI installers for all  supported Windows hosts. Optionally installs Java Web Start and sets  environment variables. Suitable for system wide installs of a single  OpenJDK version. 				

**Additional resources**

- ​					For more information about the JDK Flight Recorder (JFR), see [Introduction to JDK Flight Recorder](https://access.redhat.com/documentation/en-us/openjdk/17/html/using_jdk_flight_recorder_for_jdk_mission_control/openjdk-flight-recorded-overview). 			
- ​					For more information about the JDK Flight Recorder (JFR), see [Introduction to JDK Mission Control](https://access.redhat.com/documentation/en-us/openjdk/17/html/using_jdk_flight_recorder_for_jdk_mission_control/overview-jmc). 			
- ​					JDK Mission Control is available for RHEL with [Red Hat Software Collections 3.2](https://access.redhat.com/documentation/en-us/red_hat_software_collections/3/html/3.2_release_notes/chap-RHSCL#tabl-RHSCL-Components). 			

​			*Revised on 2021-11-26 09:36:08 UTC* 	

# 使用 alt-java

OpenJDK 17

##  

 Red Hat Customer Content Services  

[法律通告](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_alt-java/index#idm140378764859456)

**摘要**

​				OpenJDK 17 是 Red Hat Enterprise Linux 平台上的红帽产品。*使用 alt-java* 指南提供了 *alt-java* 概述，定义 *java* 和 *alt-java* 二进制文件之间的区别，并解释了如何使用 *alt-java*。 		

------

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。要提供反馈，您可以突出显示文档中的文本并添加注释。 	

​			本节介绍如何提交反馈。 	

**先决条件**

- ​					已登陆到红帽客户门户网站。 			
- ​					在红帽客户门户中，以**多页 HTML** 格式查看文档。 			

**流程**

​				要提供反馈，请执行以下步骤： 		

1. ​					点文档右上角的**反馈**按钮查看现有的反馈。 			

   注意

   ​						反馈功能仅在**多页 HTML** 格式中启用。 				

2. ​					高亮标记您要提供反馈的文档中的部分。 			

3. ​					点在高亮文本旁弹出的 **Add Feedback**。 			

   ​					文本框将在页面右侧的"反馈"部分中打开。 			

4. ​					在文本框中输入您的反馈，然后点 **Submit**。 			

   ​					创建了一个与文档相关的问题。 			

5. ​					要查看问题，请单击反馈视图中的问题跟踪器链接。 			

# 第 1 章 alt-java概述

​			红帽软件包包含对 `java` 二进制文件的补丁形式的 SSB 漏洞的缓解方案。此补丁禁用 x86-64 (Intel 和 AMD)处理器中的优化。禁用这种优化降低了内核侧通道攻击的风险，同时降低了 CPU 性能。 	

​			由于补丁降低了性能，因此已从 `java` launcher 中删除。现在提供了一个新的二进制 `alt-java`。在 2021 年 1 月发布(1.8.0 282.b08, 11.0.10.9)以后，`alt-java` 二进制文件包含在 OpenJDK 17 和 OpenJDK 11 GA RPM 软件包中。 	

**其他资源**

- ​					有关 SSB 缓解措施的性能影响的更多信息，请参阅红帽客户门户网站 [上使用 Speculative Store Bypass - CVE-2018-3639 的 Kernel Side-Channel Attack](https://access.redhat.com/security/vulnerabilities/ssbd) 			
- ​					有关 `java` 二进制补丁的更多信息，请参阅 *Red Hat Bugzilla* 文档中的 [RH1566890](https://bugzilla.redhat.com/show_bug.cgi?id=1566890)。 			

# 第 2 章 java 和 alt-java之间的区别

​			`alt-java` 和 `java` 二进制文件之间存在相似性，但 SSB 缓解方案除外。 	

​			虽然 SBB 缓解方案仅存在于 x86-64 架构、Intel 和 AMD 中，但所有架构中都存在 `alt-java`。对于非 x86 架构，alt-java 二进制文件与 `java` 二进制文件相同，但 ` alt-java ` 没有补丁。 	

**其他资源**

- ​					有关 `alt-java` 和 `java` 之间的相似的更多信息，请参阅 *Red Hat Bugzilla* 文档中的 [RH1750419](https://bugzilla.redhat.com/show_bug.cgi?id=1750419)。 			

# 第 3 章 Alt-java 和 java 使用

​			根据您的需要，您可以使用 `alt-java` 二进制文件或 `java` 二进制文件来运行应用程序的代码。 	

## 3.1. Alt-java 用法

​				对于运行不受信任的代码的任何应用程序，使用 `alt-java`。请注意，使用 `alt-java` 不是所有指定执行漏洞的解决方案。 		

## 3.2. Java 用法

​				在安全环境中，对性能关键任务使用 `java` 二进制文件。 		

**其他资源**

- ​						请参阅 [Java 和 Speculative Execution Vulnerabilities](https://mail.openjdk.java.net/pipermail/vuln-announce/2019-July/000002.html)。 				

# 第 4 章 alt-java的性能影响

​			`alt-java` 二进制文件包含 SSB 缓解方案，因此 `java` 上不再存在 SSB 缓解性能影响。 	

注意

​				使用 `alt-java` 可能会显著降低 Java 程序的性能。 		

​			您可以通过选择附加资源部分中列出的任何 Red Hat Bugzilla 链接来查找一些使用 `alt-java` 的 Java 性能问题的详细信息。 	

**其他资源**

- ​					[(Java-11-openjdk)在 RHEL8 中与性能回归相关的性能回归](https://bugzilla.redhat.com/show_bug.cgi?id=1784116)。 			
- ​					[(Java-1.8.0-openjdk)在 RHEL8 中与性能回归相关的性能回归](https://bugzilla.redhat.com/show_bug.cgi?id=1750419)。 			
- ​					[CVE-2018-3639 详情](https://nvd.nist.gov/vuln/detail/CVE-2018-3639). 			
- ​					[CVE-2018-3639 hw: cpu: speculative store bypass](https://bugzilla.redhat.com/show_bug.cgi?id=1566890). 			
- ​					[CVE-2018-3639 java-1.8.0-openjdk: hw: cpu: speculative store bypass (rhel-7.6)](https://bugzilla.redhat.com/show_bug.cgi?id=1578558) 			

​			*更新于 2023-04-27* 	

# Using jlink to customize Java runtime environment

OpenJDK 17

##  

 Red Hat Customer Content Services  

[Legal Notice](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/using_jlink_to_customize_java_runtime_environment/index#idm140063416220960)

**Abstract**

​				OpenJDK 17 is a Red Hat offering on the Red Hat Enterprise Linux platform. The *Using jlink to customize Java runtime images* guide provides an overview of Jlink, and explains how to create a customized Java runtime image by using jlink. 		

------

# Making open source more inclusive

​			Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. Because of the enormity  of this endeavor, these changes will be implemented gradually over  several upcoming releases. For more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language). 	

# Providing feedback on Red Hat documentation

​			We appreciate your feedback on our documentation. To provide  feedback, you can highlight the text in a document and add comments. 	

​			This section explains how to submit feedback. 	

**Prerequisites**

- ​					You are logged in to the Red Hat Customer Portal. 			
- ​					In the Red Hat Customer Portal, view the document in **Multi-page HTML** format. 			

**Procedure**

​				To provide your feedback, perform the following steps: 		

1. ​					Click the **Feedback** button in the top-right corner of the document to see existing feedback. 			

   Note

   ​						The feedback feature is enabled only in the **Multi-page HTML** format. 				

2. ​					Highlight the section of the document where you want to provide feedback. 			

3. ​					Click the **Add Feedback** pop-up that appears near the highlighted text. 			

   ​					A text box appears in the feedback section on the right side of the page. 			

4. ​					Enter your feedback in the text box and click **Submit**. 			

   ​					A documentation issue is created. 			

5. ​					To view the issue, click the issue tracker link in the feedback view. 			

# Chapter 1. Overview of jlink

​			Jlink is a Java command line tool that is used to generate a custom  Java runtime environment (JRE). You can use your customized JRE to run  Java applications. 	

​			Using jlink, you can create a custom runtime environment that only includes the relevant class file. 	

# Chapter 2. Creating a custom Java runtime environment for non-modular applications

​			You can create a custom Java runtime environment from a non-modular application by using the `jlink` tool. 	

**Prerequisites**

- ​					Install [Installing OpenJDK on RHEL using an archive](https://access.redhat.com/documentation/en-us/openjdk/17/html/installing_and_using_openjdk_17_on_rhel/installing-openjdk11-on-rhel8_openjdk#installing-jdk11-on-rhel-using-archive_openjdk). 			

  Note

  ​						For best results, use portable Red Hat binaries as a basis for a  Jlink runtime, because these binaries contain bundled libraries. 				

**Procedure**

1. ​					Create a simple Hello World application by using the `Logger` class. 			

   1. ​							Check the base OpenJDK 17 binary exists in the `jdk-17` folder: 					

      

      ```none
      $ ls jdk-17
      bin  conf  demo  include  jmods  legal  lib  man  NEWS  release
      $ ./jdk-17/bin/java -version
      openjdk version "17.0.10" 2021-01-19 LTS
      OpenJDK Runtime Environment 18.9 (build 17.0.10+9-LTS)
      OpenJDK 64-Bit Server VM 18.9 (build 17.0.10+9-LTS, mixed mode)
      ```

   2. ​							Create a directory for your application: 					

      

      ```none
      $ mkdir -p hello-example/sample
      ```

   3. ​							Create `hello-example/sample/HelloWorld.java` file with the following content: 					

      

      ```java
      package sample;
      
      import java.util.logging.Logger;
      
      public class HelloWorld {
          private static final Logger LOG = Logger.getLogger(HelloWorld.class.getName());
          public static void main(String[] args) {
              LOG.info("Hello World!");
          }
      }
      ```

   4. ​							Compile your application: 					

      

      ```none
      $ ./jdk-17/bin/javac -d . $(find hello-example -name \*.java)
      ```

   5. ​							Run your application **without** a custom JRE: 					

      

      ```none
      $ ./jdk-17/bin/java sample.HelloWorld
      Mar 09, 2021 10:48:59 AM sample.HelloWorld main
      INFO: Hello World!
      ```

      ​							The previous example shows the base OpenJDK requiring 311 MB to run a single class. 					

   6. ​							*(Optional)* You can inspect the OpenJDK and see many non-required modules for your application: 					

      

      ```none
      $ du -sh jdk-17/
      313M	jdk-17/
      ```

      

1. 1. ```none
      $ ./jdk-17/bin/java --list-modules
      java.base@17.0.1
      java.compiler@17.0.1
      java.datatransfer@17.0.1
      java.desktop@17.0.1
      java.instrument@17.0.1
      java.logging@17.0.1
      java.management@17.0.1
      java.management.rmi@17.0.1
      java.naming@17.0.1
      java.net.http@17.0.1
      java.prefs@17.0.1
      java.rmi@17.0.1
      java.scripting@17.0.1
      java.se@17.0.1
      java.security.jgss@17.0.1
      java.security.sasl@17.0.1
      java.smartcardio@17.0.1
      java.sql@17.0.1
      java.sql.rowset@17.0.1
      java.transaction.xa@17.0.1
      java.xml@17.0.1
      java.xml.crypto@17.0.1
      jdk.accessibility@17.0.1
      jdk.attach@17.0.1
      jdk.charsets@17.0.1
      jdk.compiler@17.0.1
      jdk.crypto.cryptoki@17.0.1
      jdk.crypto.ec@17.0.1
      jdk.dynalink@17.0.1
      jdk.editpad@17.0.1
      jdk.hotspot.agent@17.0.1
      jdk.httpserver@17.0.1
      jdk.incubator.foreign@17.0.1
      jdk.incubator.vector@17.0.1
      jdk.internal.ed@17.0.1
      jdk.internal.jvmstat@17.0.1
      jdk.internal.le@17.0.1
      jdk.internal.opt@17.0.1
      jdk.internal.vm.ci@17.0.1
      jdk.internal.vm.compiler@17.0.1
      jdk.internal.vm.compiler.management@17.0.1
      jdk.jartool@17.0.1
      jdk.javadoc@17.0.1
      jdk.jcmd@17.0.1
      jdk.jconsole@17.0.1
      jdk.jdeps@17.0.1
      jdk.jdi@17.0.1
      jdk.jdwp.agent@17.0.1
      jdk.jfr@17.0.1
      jdk.jlink@17.0.1
      jdk.jpackage@17.0.1
      jdk.jshell@17.0.1
      jdk.jsobject@17.0.1
      jdk.jstatd@17.0.1
      jdk.localedata@17.0.1
      jdk.management@17.0.1
      jdk.management.agent@17.0.1
      jdk.management.jfr@17.0.1
      jdk.naming.dns@17.0.1
      jdk.naming.rmi@17.0.1
      jdk.net@17.0.1
      jdk.nio.mapmode@17.0.1
      jdk.random@17.0.1
      jdk.sctp@17.0.1
      jdk.security.auth@17.0.1
      jdk.security.jgss@17.0.1
      jdk.unsupported@17.0.1
      jdk.unsupported.desktop@17.0.1
      jdk.xml.dom@17.0.1
      jdk.zipfs@17.0.1
      ```

      ​							This sample `Hello World` application  has very few dependencies. You can use jlink to create custom runtime  images for your application. With these images you can run your  application with only the required OpenJDK dependencies. 					

2. ​					Determine module dependencies of your application using `jdeps` command: 			

   

   ```none
   $ ./jdk-17/bin/jdeps -s ./sample/HelloWorld.class
   HelloWorld.class -> java.base
   HelloWorld.class -> java.logging
   ```

3. ​					Build a custom java runtime image for your application: 			

   

   ```none
   $ ./jdk-17/bin/jlink --add-modules java.base,java.logging --output custom-runtime
   $ du -sh custom-runtime
   50M	custom-runtime/
   $ ./custom-runtime/bin/java --list-modules
   java.base@17.0.10
   java.logging@17.0.10
   ```

   Note

   ​						OpenJDK reduces the size of your custom Java runtime image from a 313 M runtime image to a 50 M runtime image. 				

4. ​					You can verify the reduced runtime of your application: 			

   

   ```none
   $ ./custom-runtime/bin/java sample.HelloWorld
   Jan 14, 2021 12:13:26 PM HelloWorld main
   INFO: Hello World!
   ```

   ​					The generated JRE with your sample application does not have any other dependencies. 			

   ​					You can distribute your application together with your custom runtime for deployment. 			

   Note

   ​						You must rebuild the custom Java runtime images for your application with every security update of your base OpenJDK. 				

# Chapter 3. Creating a custom Java runtime environment for modular applications

​			You can create a custom Java runtime environment from a modular application by using the `jlink` tool. 	

**Prerequisites**

- ​					Install [Installing OpenJDK on RHEL using an archive](https://access.redhat.com/documentation/en-us/openjdk/17/html/installing_and_using_openjdk_17_on_rhel/installing-openjdk11-on-rhel8_openjdk#installing-jdk11-on-rhel-using-archive_openjdk). 			

  Note

  ​						For best results, use portable Red Hat binaries as a basis for a  Jlink runtime, because these binaries contain bundled libraries. 				

**Procedure**

1. ​					Create a simple Hello World application by using the `Logger` class. 			

   1. ​							Check the base OpenJDK 17 binary exists in the `jdk-17` folder: 					

      

      ```none
      $ ls jdk-17
      bin  conf  demo  include  jmods  legal  lib  man  NEWS  release
      $ ./jdk-17/bin/java -version
      openjdk version "17.0.10" 2021-01-19 LTS
      OpenJDK Runtime Environment 18.9 (build 17.0.10+9-LTS)
      OpenJDK 64-Bit Server VM 18.9 (build 17.0.10+9-LTS, mixed mode)
      ```

   2. ​							Create a directory for your application: 					

      

      ```none
      $ mkdir -p hello-example/sample
      ```

   3. ​							Create `hello-example/sample/HelloWorld.java` file with the following content: 					

      

      ```java
      package sample;
      
      import java.util.logging.Logger;
      
      public class HelloWorld {
          private static final Logger LOG = Logger.getLogger(HelloWorld.class.getName());
          public static void main(String[] args) {
              LOG.info("Hello World!");
          }
      }
      ```

   4. ​							Create a file called `hello-example/module-info.java` and include the following code in the file: 					

      

      ```java
      module sample
      {
          requires java.logging;
      }
      ```

   5. ​							Compile your application: 					

      

      ```none
      $ ./jdk-17/bin/javac -d example $(find hello-example -name \*.java)
      ```

   6. ​							Run your application *without* a custom JRE: 					

      

      ```none
      $ ./jdk-17/bin/java -cp example sample.HelloWorld
      Mar 09, 2021 10:48:59 AM sample.HelloWorld main
      INFO: Hello World!
      ```

      ​							The previous example shows the base OpenJDK requiring 311 MB to run a single class. 					

   7. ​							*(Optional)* You can inspect the OpenJDK and see many non-required modules for your application: 					

      

      ```none
      $ du -sh jdk-17/
      313M	jdk-17/
      ```

      

1. 1. ```none
      $ ./jdk-17/bin/java --list-modules
      java.base@17.0.1
      java.compiler@17.0.1
      java.datatransfer@17.0.1
      java.desktop@17.0.1
      java.instrument@17.0.1
      java.logging@17.0.1
      java.management@17.0.1
      java.management.rmi@17.0.1
      java.naming@17.0.1
      java.net.http@17.0.1
      java.prefs@17.0.1
      java.rmi@17.0.1
      java.scripting@17.0.1
      java.se@17.0.1
      java.security.jgss@17.0.1
      java.security.sasl@17.0.1
      java.smartcardio@17.0.1
      java.sql@17.0.1
      java.sql.rowset@17.0.1
      java.transaction.xa@17.0.1
      java.xml@17.0.1
      java.xml.crypto@17.0.1
      jdk.accessibility@17.0.1
      jdk.attach@17.0.1
      jdk.charsets@17.0.1
      jdk.compiler@17.0.1
      jdk.crypto.cryptoki@17.0.1
      jdk.crypto.ec@17.0.1
      jdk.dynalink@17.0.1
      jdk.editpad@17.0.1
      jdk.hotspot.agent@17.0.1
      jdk.httpserver@17.0.1
      jdk.incubator.foreign@17.0.1
      jdk.incubator.vector@17.0.1
      jdk.internal.ed@17.0.1
      jdk.internal.jvmstat@17.0.1
      jdk.internal.le@17.0.1
      jdk.internal.opt@17.0.1
      jdk.internal.vm.ci@17.0.1
      jdk.internal.vm.compiler@17.0.1
      jdk.internal.vm.compiler.management@17.0.1
      jdk.jartool@17.0.1
      jdk.javadoc@17.0.1
      jdk.jcmd@17.0.1
      jdk.jconsole@17.0.1
      jdk.jdeps@17.0.1
      jdk.jdi@17.0.1
      jdk.jdwp.agent@17.0.1
      jdk.jfr@17.0.1
      jdk.jlink@17.0.1
      jdk.jpackage@17.0.1
      jdk.jshell@17.0.1
      jdk.jsobject@17.0.1
      jdk.jstatd@17.0.1
      jdk.localedata@17.0.1
      jdk.management@17.0.1
      jdk.management.agent@17.0.1
      jdk.management.jfr@17.0.1
      jdk.naming.dns@17.0.1
      jdk.naming.rmi@17.0.1
      jdk.net@17.0.1
      jdk.nio.mapmode@17.0.1
      jdk.random@17.0.1
      jdk.sctp@17.0.1
      jdk.security.auth@17.0.1
      jdk.security.jgss@17.0.1
      jdk.unsupported@17.0.1
      jdk.unsupported.desktop@17.0.1
      jdk.xml.dom@17.0.1
      jdk.zipfs@17.0.1
      ```

      ​							This sample `Hello World` application  has very few dependencies. You can use jlink to create custom runtime  images for your application. With these images you can run your  application with only the required OpenJDK dependencies. 					

2. ​					Create your application module: 			

   

   ```none
   $ mkdir sample-module
   $ ./jdk-17/bin/jmod create --class-path example/ --main-class sample.HelloWorld --module-version 1.0.0 -p example sample-module/hello.jmod
   ```

3. ​					Create a custom JRE with the required modules and a custom application launcher for your application: 			

   

   ```none
   $ ./jdk-17/bin/jlink --launcher hello=sample/sample.HelloWorld --module-path sample-module --add-modules sample --output custom-runtime
   ```

4. ​					List the modules of the produced custom JRE. 			

   ​					Observe that only a fraction of the original OpenJDK remains. 			

   

   ```none
   $ du -sh custom-runtime
   50M	custom-runtime/
   $ ./custom-runtime/bin/java --list-modules
   java.base@17.0.10
   java.logging@17.0.10
   sample@1.0.0
   ```

   Note

   ​						OpenJDK reduces the size of your custom Java runtime image from a 313 M runtime image to a 50 M runtime image. 				

5. ​					Launch the application using the `hello` launcher: 			

   

   ```none
   $ ./custom-runtime/bin/hello
   Jan 14, 2021 12:13:26 PM HelloWorld main
   INFO: Hello World!
   ```

   ​					The generated JRE with your sample application does not have any other dependencies besides `java.base`, `java.logging`, and `sample` module. 			

   ​					You can distribute your application that is bundled with the custom runtime in `custom-runtime`. This custom runtime includes your application. 			

   Note

   ​						You must rebuild the custom Java runtime images for your application with every security update of your base OpenJDK. 				

​			*Revised on 2021-11-29 09:29:07 UTC* 	

# Using Shenandoah garbage collector with OpenJDK 17

OpenJDK 17

##  

 Red Hat Customer Content Services  

[Legal Notice](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/using_shenandoah_garbage_collector_with_openjdk_17/index#idm139697632144032)

**Abstract**

​				OpenJDK is a Red Hat offering on the Red Hat Enterprise Linux platform. The *Using Shenandoah garbage collector with OpenJDK 17* guide provides an overview of Shenandoah garbage collector and explains how to configure it with OpenJDK 17. 		

------

# Making open source more inclusive

​			Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. Because of the enormity  of this endeavor, these changes will be implemented gradually over  several upcoming releases. For more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language). 	

# Providing feedback on Red Hat documentation

​			We appreciate your feedback on our documentation. To provide  feedback, you can highlight the text in a document and add comments. 	

​			This section explains how to submit feedback. 	

**Prerequisites**

- ​					You are logged in to the Red Hat Customer Portal. 			
- ​					In the Red Hat Customer Portal, view the document in **Multi-page HTML** format. 			

**Procedure**

​				To provide your feedback, perform the following steps: 		

1. ​					Click the **Feedback** button in the top-right corner of the document to see existing feedback. 			

   Note

   ​						The feedback feature is enabled only in the **Multi-page HTML** format. 				

2. ​					Highlight the section of the document where you want to provide feedback. 			

3. ​					Click the **Add Feedback** pop-up that appears near the highlighted text. 			

   ​					A text box appears in the feedback section on the right side of the page. 			

4. ​					Enter your feedback in the text box and click **Submit**. 			

   ​					A documentation issue is created. 			

5. ​					To view the issue, click the issue tracker link in the feedback view. 			

# Chapter 1. Shenandoah garbage collector

​			Shenandoah is the low pause time garbage collector (GC) that reduces  GC pause times by performing more garbage collection work concurrently  with the running Java program. Concurrent Mark Sweep garbage collector  (CMS) and G1, default garbage collector for OpenJDK 17 perform  concurrent marking of live objects. 	

​			Shenandoah adds concurrent compaction. Shenandoah also reduces GC  pause times by compacting objects concurrently with running Java  threads. Pause times with Shenandoah are independent of the heap size,  meaning you will have consistent pause time whether your heap is 200 MB  or 200 GB. Shenandoah is an algorithm for applications which require  responsiveness and predictable short pauses. 	

**Additional resources**

- ​					For more information about the Shenandoah garbage collector, see [Shenandoah GC](https://wiki.openjdk.java.net/display/shenandoah/Main) in the Oracle OpenJDK documentation. 			

# Chapter 2. Running Java applications with Shenandoah garbage collector

​			You can run your Java application with the Shenandoah garbage collector (GC). 	

**Prerequisites**

- ​					Installed OpenJDK. See [Installing OpenJDK 17 on Red Hat Enterprise Linux](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/installing_and_using_openjdk_17_on_rhel/index#installing-openjdk17-on-rhel8) in the *Installing and using OpenJDK 17 on RHEL* guide. 			

**Procedure**

- ​					Run your Java application with Shenandoah GC by using **-XX:+UseShenandoahGC** JVM option. 			

  

  ```java
  $ java <PATH_TO_YOUR_APPLICATION> -XX:+UseShenandoahGC
  ```

# Chapter 3. Shenandoah garbage collector modes

​			You can run Shenandoah in three different modes. Select a specific mode with the **-XX:ShenandoahGCMode=<name>**. The following list describes each Shenandoah mode: 	

- **normal/satb (product, default)**

  ​						This mode runs a concurrent garbage collector (GC) with  Snapshot-At-The-Beginning (SATB) marking. This marking mode does the  similar work as G1, the default garbage collector for OpenJDK 17. 				

- **iu (experimental)**

  ​						This mode runs a concurrent GC with Incremental Update (IU)  marking. It can reclaim unreachably memory more aggressively. This  marking mode mirrors the SATB mode. This may make marking less  conservative, especially around accessing weak references. 				

- **passive (diagnostic)**

  ​						This mode runs Stop the World Event GCs. This mode is used for  functional testing, but sometimes it is useful for bisecting performance anomalies with GC barriers, or to ascertain the actual live data size  in the application. 				

# Chapter 4. Basic configuration options of Shenandoah garbage collector

​			Shenandoah garbage collector (GC) has the following basic configuration options: 	

- **-Xlog:gc**

  ​						Print the individual GC timing. 				

- **-Xlog:gc+ergo**

  ​						Print the heuristics decisions, which might shed light on outliers, if any. 				

- **-Xlog:gc+stats**

  ​						Print the summary table on Shenandoah internal timings at the end of the run. 				 					It is best to run this with logging enabled. This summary table  conveys important information about GC performance. Heuristics logs are  useful to figure out GC outliers. 				

- **-XX:+AlwaysPreTouch**

  ​						Commit heap pages into memory and helps to reduce latency hiccups. 				

- **-Xms** and **-Xmx**

  ​						Making the heap non-resizeable with `-Xms = -Xmx` reduces difficulties with heap management. Along with `AlwaysPreTouch`, the `-Xms = -Xmx` commit all memory on startup, which avoids difficulties when memory is finally used. `-Xms` also defines the low boundary for memory uncommit, so with `-Xms = -Xmx` all memory stays committed. If you want to configure Shenandoah for a lower footprint, then setting lower `-Xms` is recommended. You need to decide how low to set it to balance the  commit/uncommit overhead versus memory footprint. In many cases, you can set `-Xms` arbitrarily low. 				

- **-XX:+UseLargePages**

  ​						Enables `hugetlbfs` Linux support. 				

- **-XX:+UseTransparentHugePages**

  ​						Enables huge pages transparently. With transparent huge pages, it is recommended to set `/sys/kernel/mm/transparent_hugepage/enabled` and `/sys/kernel/mm/transparent_hugepage/defrag` to `madvise`. When running with `AlwaysPreTouch`, it will also pay the `defrag` tool costs upfront at startup. 				

- **-XX:+UseNUMA**

  ​						While Shenandoah does not support NUMA explicitly yet, it is a  good idea to enable NUMA interleaving on multi-socket hosts. Coupled  with `AlwaysPreTouch`, it provides better performance than the default out-of-the-box configuration. 				

- **-XX:-UseBiasedLocking**

  ​						There is a tradeoff between uncontended (biased) locking  throughput, and the safepoints JVM does to enable and disable them. For  latency-oriented workloads, turn biased locking off. 				

- **-XX:+DisableExplicitGC**

  ​						Invoking System.gc() from user code forces Shenandoah to perform additional GC cycle. It usually does not harm, as **-XX:+ExplicitGCInvokesConcurrent** gets enabled by default, which means the concurrent GC cycle would be invoked, not the STW Full GC. 				

​			*Revised on 2021-11-25 16:29:11 UTC* 	

# Packaging OpenJDK 17 applications in containers

OpenJDK 17

##  

 Red Hat Customer Content Services  

[Legal Notice](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/packaging_openjdk_17_applications_in_containers/index#idm140112285735696)

**Abstract**

​				OpenJDK is a Red Hat offering on the Red Hat Enterprise Linux platform. The *Packaging OpenJDK 17 applications in containers* guide provides an overview of this product and explains how to package the applications in a container. 		

------

# Making open source more inclusive

​			Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. Because of the enormity  of this endeavor, these changes will be implemented gradually over  several upcoming releases. For more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language). 	

# Providing feedback on Red Hat documentation

​			We appreciate your feedback on our documentation. To provide  feedback, you can highlight the text in a document and add comments. 	

​			This section explains how to submit feedback. 	

**Prerequisites**

- ​					You are logged in to the Red Hat Customer Portal. 			
- ​					In the Red Hat Customer Portal, view the document in **Multi-page HTML** format. 			

**Procedure**

​				To provide your feedback, perform the following steps: 		

1. ​					Click the **Feedback** button in the top-right corner of the document to see existing feedback. 			

   Note

   ​						The feedback feature is enabled only in the **Multi-page HTML** format. 				

2. ​					Highlight the section of the document where you want to provide feedback. 			

3. ​					Click the **Add Feedback** pop-up that appears near the highlighted text. 			

   ​					A text box appears in the feedback section on the right side of the page. 			

4. ​					Enter your feedback in the text box and click **Submit**. 			

   ​					A documentation issue is created. 			

5. ​					To view the issue, click the issue tracker link in the feedback view. 			

# Chapter 1. OpenJDK applications in containers

​			OpenJDK images have default startup scripts that automatically detect application `JAR` files and launch Java. The script’s behavior can be customized using environment variables. For more information, see `/help.md` in the container. 	

​			The Java applications in the `/deployments` directory of the OpenJDK image are run when the image loads. 	

Note

​				Containers that contain OpenJDK applications are not automatically  updated with security updates. Ensure that you update these images at  least once every three months. 		

​			Application `JAR` files can be fat JARs or thin JARs. 	

- ​					Fat JARs contain all of the application’s dependencies. 			

- ​					Thin JARs reference other JARs that contain some, or all, of the application’s dependencies. 			

  ​					Thin JARs are only supported if: 			

  - ​							They have a flat classpath. 					
  - ​							All dependencies are JARs that are in the `/deployments` directory. 					

# Chapter 2. Deploying OpenJDK application in containers

​			You can deploy OpenJDK applications in containers and have them run when the container is loaded. 	

**Procedure**

- ​					Copy the application `JAR` to the `/deployments` directory in the image `JAR` file. 			

  ​					For example, the following shows a brief Dockerfile that adds an application called `testubi.jar` to the OpenJDK 17 UBI8 image: 			

  

  ```none
  FROM registry.access.redhat.com/ubi8/openjdk-17
  
  COPY target/testubi.jar /deployments/testubi.jar
  ```

# Chapter 3. Updating OpenJDK container images

​			To ensure that an OpenJDK container with Java applications includes the latest security updates, rebuild the container. 	

**Procedure**

1. ​					Pull the base OpenJDK image. 			

2. ​					Deploy the OpenJDK application. For more information, see [Deploying OpenJDK applications in containers](https://access.redhat.com/documentation/en-us/openjdk/17/html-single/packaging_openjdk_17_applications_in_containers/index#deploying-openjdk-apps-in-containers). 			

   ​					The OpenJDK container with the OpenJDK application is updated. 			

**Additional resources**

- ​					For more information, see [Red Hat OpenJDK Container images](https://catalog.redhat.com/software/containers/search?q=Openjdk&p=1). 			

​			*Revised on 2021-11-25 16:29:01 UTC* 	

# 在 OpenJDK 中使用 JDK Flight Recorder

OpenJDK 17

##  

 Red Hat Customer Content Services  

[法律通告](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/index#idm140593844219200)

**摘要**

​				OpenJDK 17 是 Red Hat Enterprise Linux 和 Microsoft Windows 上的红帽产品。*使用带有 OpenJDK 的 JDK Flight Recorder* 指南提供了 JDK Flight Recorder (JFR)和 JDK Mission Control (JMC)的概述，并解释了如何启动 JFR。 		

------

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。要提供反馈，您可以突出显示文档中的文本并添加注释。 	

​			本节介绍如何提交反馈。 	

**先决条件**

- ​					登录到红帽客户门户网站。 			
- ​					在红帽客户门户网站中，以 **多页 HTML** 格式查看文档。 			

**流程**

​				要提供反馈，请执行以下步骤： 		

1. ​					点文档右上角的 **Feedback** 按钮查看现有的反馈。 			

   注意

   ​						反馈功能仅在**多页 HTML** 格式中启用。 				

2. ​					高亮标记您要提供反馈的文档中的部分。 			

3. ​					点在高亮文本旁弹出的 **Add Feedback**。 			

   ​					文本框中会出现在页面右侧的 feedback 部分中。 			

4. ​					在文本框中输入您的反馈，然后点 **Submit**。 			

   ​					文档问题已创建。 			

5. ​					要查看问题，请单击反馈视图中的问题跟踪器链接。 			

# 第 1 章 JDK Flight Recorder 简介

​			JDK Flight Recorder (JFR)是用于监控和分析 Java 应用程序的低开销框架。如需更多信息，请参阅 [JEP 328: Flight Recorder](https://openjdk.java.net/jeps/328)。 	

​			您可以从源自 JVM 和应用代码的事件收集数据。然后，数据会在内存中写入。首先，到 thread-local 缓冲区，然后提升到固定大小的全局环缓冲，然后再刷新到磁盘上的 `JFR` 文件(*.jfr)。其他应用程序可以使用这些文件进行分析。例如，`JDK Mission Control` (JMC)工具。 	

## 1.1. JDK Flight Recorder (JFR)组件

​				您可以使用 JFR 功能观察 JVM 内运行的事件，然后从这些观察的事件中创建记录。 		

​				以下列表详细列出了键 JFR 功能： 		

- **记录**

  ​							您可以管理系统记录。每个记录都有唯一的配置。您可以启动或停止记录，或者根据需要将其保存到磁盘中。 					

- **事件**

  ​							您可以使用事件或自定义事件跟踪 Java 应用程序的数据和元数据，然后在 JFR 文件中从事件类型保存数据和元数据。您可以使用各种工具，如 Java Mission Control (JMC)、`jcmd` 等等，来查看和分析存储在 JFR 文件中的信息。 					 						Java 虚拟机(JVM)具有多个已存在的事件，这些事件会被持续添加。一个 API 供用户将自定义事件注入其应用。 					 						您可以在记录时启用或禁用任何事件，以通过提供事件配置来最小化开销。这些配置采用 `xml` 文档的形式，并称为 JFR 配置集(`*.jfc`)。OpenJDK 对于最常见的用例集合提供了以下两个配置集： 					 								`默认` ： *default* 配置集是一个低层次的配置，在生产环境中持续使用。通常，开销小于 1%。 							 								`配置集` ： *配置集* 是一个低级别配置，非常适合性能分析。通常，开销小于 2%。 							

## 1.2. 使用 JDK Flight Recorder 的好处

​				使用 JDK Flight Recorder (JFR)的一些主要优点是： 		

- ​						JFR 允许在运行的 JVM 上记录。最好在生产环境中使用 JFR，但无法重新启动或重新构建应用程序。 				
- ​						JFR 允许定义要监控的自定义事件和指标。 				
- ​						在 JVM 中内置 JFR，以获得最低性能开销（大约 1%）。 				
- ​						JFR 使用一致性数据模型来提供更好的事件引用和数据过滤。 				
- ​						JFR 允许使用 API 监控第三方应用程序。 				
- ​						JFR 通过以下方式帮助降低所有权成本： 				
  - ​								花费较少的时间诊断。 						
  - ​								解决故障排除问题. 						
- ​						JFR 通过以下方法降低操作成本和业务中断： 				
  - ​								提供更快的解决方案时间。 						
  - ​								识别有助于提高系统效率的性能问题。 						

# 第 2 章 JDK Mission Control 简介

​			JDK Mission Control (JMC)是读取和分析 JFR 文件的工具集合。JMC 包括图表 JFR 事件的详细视图和图表。使用 JFR 分析时，JMC 还由以下组件组成： 	

- ​					JMX Console MBean 			
- ​					通过 flight 记录和 `hprof` 文件(JMC 7.1.0)的历史分析） 			
- ​					HPROF-dump 分析器 			

​			JMC 基于 Eclipse 平台。您可以使用 Eclipse RCP API 和其他特定 API 添加插件来扩展 JMC。 	

​			您可以在 Red Hat Enterprise Linux 或 Microsoft Windows 上使用 JMC 及其插件。 	

## 2.1. 下载并安装 JDK Mission Control (JMC)

​				Red Hat Enterprise Linux 和 Microsoft Windows 的 Red Hat OpenJDK 构建包括 JMC 版本。 		

​				对于 Red Hat Enterprise Linux，您可以使用 Red Hat Subscription Manager 工具在本地操作系统中下载并安装 JMC。 		

​				在 Microsoft Windows 中，JMC 软件包包含在 归档文件中，您可以从红帽客户门户网站下载。在 Microsoft Windows 上下载并安装 OpenJDK 17 后，您可以进入包含 `jmc.exe` 文件的目录，然后发出 `jmc` 命令。 		

​				这个过程详情在 Red Hat Enterprise Linux 上安装 JMC。 		

**先决条件**

- ​						在 RHEL 上下载并安装 OpenJDK 17.0.5。 				
- ​						以 root 用户身份登录您的操作系统。 				
- ​						[在红帽客户门户网站中](https://access.redhat.com/) 注册了一个帐户。 				
- ​						注册了一个具有有效订阅的 Red Hat Subscription Manager (RHSM)帐户，供您访问 OpenJDK 17 软件仓库。 				
  - ​								有关如何将您的系统注册到 RHSM 帐户的更多信息，请参阅 使用 [*Red Hat Subscription \*Management 指南中的 使用 Red Hat Subscription\* Manager 注册系统*](https://access.redhat.com/documentation/zh-cn/red_hat_subscription_management/1/html-single/using_red_hat_subscription_management/index#registration_con)。 						

**流程**

1. ​						在命令行界面中运行以下命令，在 Red Hat Enterprise Linux 中下载 JMC 软件包： 				

   

   ```none
   # sudo yum module install jmc:rhel8/common
   ```

   ​						以上命令使用 Red Hat Subscription Manager 工具将 JMC 软件包下载到 RHEL 操作系统。这个 JMC 软件包包括在 Red Hat Subscription Manager 服务的 `jmc` 模块流中。 				

2. ​						选择以下选项之一启动操作系统中的 JMC 控制台： 				

   1. ​								进入包含 JMC 可执行文件的目录，然后运行以下命令： 						

      

      ```none
      $ jmc -vm /usr/lib/jvm/java-11/bin/java
      ```

   2. ​								使用系统的文件浏览器应用程序进入 **JDK Mission Control** 目录，如 `/usr/bin/jmc`，然后双击 JMC 可执行文件。 						

**其他资源**

- ​						在 [RHEL 上安装和使用 OpenJDK 17](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/{installing-openjdk-rhel-url})。 				
- ​						[为 Microsoft Windows 安装和使用 OpenJDK 8](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/{installing-openjdk-windows-url}) 				
- ​						[使用模块流（使用红帽订阅管理）](https://access.redhat.com/documentation/zh-cn/red_hat_subscription_management/1/html-single/using_red_hat_subscription_management/index#rhsm-module-con) 				

## 2.2. JDK Mission Control (JMC)代理

​				您可以使用 JMC 代理将 JDK Flight Recorder (JFR)功能添加到正在运行的应用程序中。您还可以使用 JMC 代理将自定义 flight 记录器事件添加到正在运行的 Java 虚拟机(JVM)中。 		

​				JMC 代理包括以下功能： 		

- ​						更好地控制在使用 JFR 模板时启用或禁用生成的事件。 				
- ​						使用 `Timestamp` 类时捕获高效时间戳。 				
- ​						生成交通记录时的内存消耗较低。 				

​				Red Hat Enterprise Linux 和 Microsoft Windows 的 OpenJDK 17.0.5  安装文件不包括 JMC 软件包的 JMC 代理。您必须下载并安装 JMC 代理的第三方版本，然后在您选择的平台上检查其与 OpenJDK 的  JMC 软件包的兼容性。 		

重要

​					红帽不支持第三方应用程序，如 JMC 代理。在决定将任何第三方应用程序与红帽产品搭配使用之前，请确保测试所下载软件的安全性和可信赖性。 			

注意

​					JMC Agent 的图形用户界面(GUI)在 Red Hat Enterprise Linux 和 Microsoft Windows 上都类似，除了特定于任一平台的标准 Widget Toolkit (SWT)引入的图形更改。 			

​				当您构建 JMC 代理且您有 JMC Agent JAR 文件时，您可以访问 JMC 控制台的 **JVM 浏览器** 面板中的 JMC 代理插件。使用这个插件，您可以在 JMC 控制台中使用 JMC Agent 功能，如配置 JMC 代理或管理 JMC 代理如何与 JFR 数据交互。 		

## 2.3. 启动 JDK Mission Control (JMC)代理

​				您可以使用 JMC 代理插件启动 JMC 代理。Red Hat Enterprise Linux 和 Microsoft Windows 支持使用此插件。 		

​				启动 JMC 代理后，您可以配置代理或管理代理如何与 JFR 数据进行交互。 		

**先决条件**

- ​						在 Red Hat Enterprise Linux 或 Microsoft Windows 上下载并安装 `jmc` 软件包 				
- ​						下载 Eclipse Adoptium Agent JAR 文件。请参阅 [adoptium/jmc-build (GitHub)](https://github.com/adoptium/jmc-build/releases)。 				
- ​						使用 `--add-opens=java.base/jdk.internal.misc=ALL-UNNAMED` 标志启动您的 Java 应用程序。例如，. ` /<your_application> --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED`。 				

注意

​					Eclipse Adoptium 是社区支持的项目。红帽生产服务级别协议(SLA)不支持使用 Eclipse Adoptium 的 `agent.jar` 文件。 			

**流程**

1. ​						根据您的操作系统，选择以下方法启动 JMC 控制台： 				

   1. ​								在 Red Hat Enterprise Linux 上，进入包含可执行文件的目录，然后发出 `./jmc` 命令。 						

   2. ​								在 Microsoft Windows 上，导航到包含 `jmc.exe` 文件的目录，然后发出 `jmc` 命令。 						

      注意

      ​									您还可以使用系统的文件管理器应用程序在任一操作系统上启动 JMC 应用程序，以导航到 **JDK Mission Control** 目录，然后双击 JMC 可执行文件。 							

2. ​						导航到 **JVM 浏览器** 导航面板。在此面板中，您可以查看任何可用的 JVM 连接。 				

3. ​						在 JVM **浏览器面板中，展开目标 JVM 实例，如 `[11.0.13] JVM` Running Mission Control**。目标 JVM 实例下会显示项目列表。 				

4. ​						双击导航面板中的 **JMC Agent** 项。在 JMC 控制台中打开一个 **Start JMC Agent** 窗口： 				

   图 2.1. 启动 JMC Agent 窗口

   ![jmc start jmc 浏览器](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/e0a88895a04daf1cf4f5b9e8120c402c/jmc_start-jmc-browser.png)

5. ​						使用 **Browse** 按钮，将 JMC Agent 的 JAR 文件添加到 **Agent JAR** 字段中。**Agent XML** 字段是可选的。 				

   注意

   ​							您不需要在 **Target JVM** 字段中输入值，因为 JMC 根据您选择的目标 JVM 实例自动添加一个值。 					

6. ​						点 **Start** 按钮。 				

   ​						JMC 在 JVM **浏览器导航面板中** 的目标 JVM 实例下添加 **Agent 插件** 项目。JMC 控制台会自动打开 **Agent Live Config** 窗格。 				

   图 2.2. 代理实时配置窗格

   [![jmc 代理实时配置](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/742b3625553a92e669065a0e6cb369d7/jmc_agent-live-config.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/742b3625553a92e669065a0e6cb369d7/jmc_agent-live-config.png)

   ​						现在，您可以配置 JMC 代理，或者管理 JMC 代理和 JFR 数据之间的交互。生成 XML 配置并将其上传到 JMC 控制台后，**Agent Live Config** 窗格会显示与该 XML 文件关联的元数据。 				

   图 2.3. 添加到 JMC 控制台中的 XML 配置文件示例

   [![jmc 代理实时配置完成](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/b014dc7a7c0f3f330b0c4312dc7d3a59/jmc_agent-live-config-complete.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/b014dc7a7c0f3f330b0c4312dc7d3a59/jmc_agent-live-config-complete.png)

## 2.4. 使用 JMC 代理创建预设置

​				您可以在 JMC 控制台中配置 JMC Agent 实例。 		

​				JMC 控制台提供以下 JMC Agent 配置选项，用于名称，但有几个： 		

- ​						使用 *Agent Preset Manager* 选项创建自定义预设置。 				
- ​						将 XML 配置导入到您的 JMC 代理预设置中。 				
- ​						使用 `defineEventProbes` 函数添加自定义 JFR 事件的 XML 描述。 				
- ​						将活跃的自定义 JFR 事件存储为预设，以便您可以在以后的阶段检索它们。 				

**先决条件**

- ​						在 JMC 控制台中启动 JMC 代理实例。 				

**流程**

1. ​						您可以通过点菜单栏中的 **Window** 来创建新预设置，然后点 **JMC Agent Preset Manager** 菜单项。**JMC Agent Configuration Preset Manager** 向导会在 JMC 控制台中打开。 				

2. ​						点 **Add** 按钮访问 **Edit Preset Global Configurations** 窗口。 				

   图 2.4. 编辑 Preset Global configuration 窗口

   [![jmc edit preset 全局配置](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/d8f1a50ef75f4a4826e7ade6a63c7076/jmc_edit-preset-global-configurations.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/d8f1a50ef75f4a4826e7ade6a63c7076/jmc_edit-preset-global-configurations.png)

   ​						在此窗口中，您可以为预先设置输入一个名称。另外，您可以为您要注入目标 JVM 的任何事件输入一个类前缀。您还可以选中 **AllowtoString** 复选框和 **Allow Converter** 复选框。 				

3. ​						点 **Next** 按钮。此时会打开 **Add 或 Remove Preset Events** 窗口。在此窗口中，您可以为预先设置添加新的事件、编辑事件或删除事件。 				

   图 2.5. 添加或删除预设置事件

   [![jmc add remove preset events](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/1ae22bbf2f16daf653a29f046802bbe4/jmc_add-remove-preset-events.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/1ae22bbf2f16daf653a29f046802bbe4/jmc_add-remove-preset-events.png)

4. ​						按照向导的说明，您可以完成以下步骤： 				

   1. ​								**编辑事件配置** 						

   2. ​								**编辑参数或返回值步骤** 						

   3. ​								**编辑参数或返回值 Capturing** 						

      提示

      ​								您可以选择每个向导步骤中的任何可用按钮来完成所需的配置，如 **添加**、**Remove** 等等。您可以单击任何阶段的 **Back** 按钮来编辑之前的向导步骤。 						

5. ​						点 **Finish** 按钮返回到 **Add** 或 **Remove Preset Events** 窗口。 				

6. ​						点 **Next**。此时会打开 **Preview Preset Output** 窗口。 				

7. ​						在点 **Finish** 按钮前查看生成的 XML 数据： 				

   图 2.6. 预览预设置输出

   [![jmc preview preset 输出](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/c3d243b6c9c9732345b3a12f0517b081/jmc_preview-preset-output.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/c3d243b6c9c9732345b3a12f0517b081/jmc_preview-preset-output.png)

8. ​						点 JMC 控制台窗口右上角的 **Load preset** 按钮，然后将您的预设上传到 JMC 应用程序。 				

9. ​						在 **JMC Agent Configuration Preset Manager** 窗口中，点 **OK** 按钮将预先设置加载到您的目标 JVM 中。JMC 控制台上的 **Agent Live Present** 面板会显示您的活跃代理配置及其注入的事件。例如： 				

   图 2.7. Agent Live Present 窗格中的输出示例

   [![jmc 代理实时配置示例](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/bb87902d41209b058ec9b5431d4b2816/jmc_agent-live-config-example.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/bb87902d41209b058ec9b5431d4b2816/jmc_agent-live-config-example.png)

**其他资源**

- ​						有关 JMC XML 属性的详情，请参考 [JMC 代理插件属性](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/overview-jmc/jmc-agent-plugin-attributes)。 				

## 2.5. JMC 代理插件属性

​				JMC 控制台以按钮、下拉列表、文本字段等形式支持许多属性。您可以使用特定的 JMC Agent 属性来配置代理。 		

​				下表概述了可用于配置 JMC 代理的属性类别，以便您可以使用代理来监控特定于您的需要的 JFR 数据。 		

表 2.1. 用于 JMC 代理的配置属性列表。

| 属性               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| `<allowconverter>` | 确定 JMC 代理是否可以使用转换器。启用转换器后，您可以将自定义数据类型或对象转换为 JFR 内容类型。然后，JFR 可以与自定义事件一起记录这些类型。 |
| `<allowtostring>`  | 决定 JMC 代理是否可以将数组和对象参数作为字符串记录。 						 						  							**注：** 检查 `toString` 方法支持 JMC Agent 数组元素和对象。否则，`toString` 方法的行为可能会导致 JMC 代理出现问题。 |
| `<classPrefix>`    | 决定注入的事件的前缀。例如：_ `_JFR_EVENT`                   |
| `<config>`         | 包含 JMC 代理的配置选项。                                    |
| `<jfragent>`       | 开始事件定义。& `lt;jfragent` > 属性是所有其他配置属性的父属性。 |

表 2.2. 用于 JMC 代理的事件类型属性列表。

| 属性            | 描述                                                         |
| --------------- | ------------------------------------------------------------ |
| `<class>`       | 定义从方法接收事件类型的类。                                 |
| `<description>` | 描述事件类型。                                               |
| `<events>`      | 列出代理注入定义的方法的一组事件。事件标签需要 ID。JFR 将 event 标签用于自定义事件。 |
| `<label>`       | 定义事件类型的名称。                                         |
| `<location>`    | 决定接收注入事件的方法中的位置。例如： `ENTRY`,`EXIT`,`WRAP` 等等。 |
| `<path>`        | 指向存储自定义事件位置的路径。此路径与 JMC 控制台上的 **JVM 浏览器** 导航面板下列出的任何事件相关。 |
| `<method>`      | 定义接收注入的事件的方法。`method` 属性要求您定义以下两个值： 						 						  									`名称` ：方法的名称 								 									`描述符` ：正式方法描述符.采用 `(ParameterDescriptors) ReturnDescriptor`的形式 |
| `<stacktrace>`  | 确定事件类型是否记录堆栈追踪。                               |

表 2.3. 与 JMC 代理一起使用的自定义 caption 属性列表。

| 属性            | 描述                                               |
| --------------- | -------------------------------------------------- |
| `<converter>`   | 将属性转换为 JFR 数据类型的转换器类的合格名称。    |
| `<contenttype>` | 定义 converter 属性接收的 JFR 内容类型。           |
| `<description>` | 自定义 caption 属性的描述。                        |
| `<parameters>`  | 可选属性。根据分配给参数标签的索引值列出方法参数。 |
| `<name>`        | 自定义 caption 属性的名称。                        |

表 2.4. 用于 JMC 代理的字段捕获属性列表。

| 属性            | 描述                                                        |
| --------------- | ----------------------------------------------------------- |
| `<description>` | 要捕获的字段的描述。                                        |
| `<expression>`  | 定义一个表达式，代理分析以定位已定义的字段。                |
| `<fields>`      | 决定 JMC Agent 使用任何定义的事件类型捕获和发出的类字段值。 |
| `<name>`        | class 字段捕获属性的名称。                                  |

# 第 3 章 启动 JDK Flight Recorder

## 3.1. 当 JVM 启动时启动 JDK Flight Recorder

​				当 Java 进程启动时，您可以启动 JDK Flight Recorder (JFR)。您可以通过添加可选参数来修改 JFR 的行为。 		

**流程**

- ​						使用 `--XX` 选项运行 `java` 命令。 				

  ​						`$` `java -XX:StartFlightRecording *Demo*` 				

  ​						其中 *Demo* 是 Java 应用的名称。 				

  ​						JFR 从 Java 应用程序开始。 				

**示例**

​					以下命令启动一个 Java 进程(*Demo*)，它启动一个长达一小时的 flight 记录，该记录被保存到名为 `demorecording.jfr` 的文件： 			

​				`$` `java -XX:StartFlightRecording=duration=1h,filename=demorecording.jfr *Demo*` 		

**其他资源**

- ​						有关 JFR 选项的详细列表，请参阅 [Java 工具参考](https://docs.oracle.com/en/java/javase/11/tools/java.html#GUID-3B1CE181-CD30-4178-9602-230B800D4FAE)。 				

## 3.2. 在运行 JVM 上启动 JDK Flight Recorder

​				您可以使用 `jcmd` 实用程序将诊断命令请求发送到正在运行的 JVM。`jcmd` 包括与 JFR 交互的命令，具有 `启动`、`转储` 和 `stop` 的最基本命令。 		

​				要与 JVM 交互，`jcmd` 需要 JVM 的进程 ID (pid)。您可以使用 `jcmd -l` 命令来检索正在运行的 JVM 进程 ID 的列表，以及其他信息，如用于启动进程的主要类和命令行参数。 		

​				`jcmd` 实用程序位于 `$JAVA_HOME/bin` 下。 		

**流程**

- ​						使用以下命令启动 flight 记录： 				

  ​						`$` `jcmd < *;pid>* JFR.start < *;options>*` 				

  ​						例如，以下命令启动一个名为 `demorecording` 的记录，它会保留最后四小时的数据，其大小限制为 400 MB： 				

  ​						`$` `jcmd *<pid>* JFR.start name=demorecording maxage=4h maxsize=400MB` 				

**其他资源**

- ​						有关 `jcmd` 选项的详细列表，请参阅 [jcmd Tools Reference](https://docs.oracle.com/en/java/javase/11/tools/jcmd.html#GUID-59153599-875E-447D-8D98-0078A5778F05)。 				

## 3.3. 使用 JDK Mission Control 应用程序在 JVM 上启动 JDK Flight Recorder

​				`JDK Mission Control` (JMC)应用程序有一个 Flight Recording 向导，它可简化启动和配置无线记录体验。 		

**流程**

1. ​						打开 JVM 浏览器。 				

   ​						`$` `JAVA_HOME/bin/jmc` 				

2. ​						右键单击 JVM 浏览器视图中的 JVM，然后选择 `Start Flight Recording`。 				

   ​						此时会打开 Flight Recording Wizard。 				

   图 3.1. JMC JFR 向导

   [![jmc jfrwizard 2](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/5948c15a69e791c86888383b89bab962/jmc_jfrwizard_2.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/5948c15a69e791c86888383b89bab962/jmc_jfrwizard_2.png)

   ​						JDK Flight Recording 向导有三个页面： 				

   - ​								向导的第一个页面包含 flight 记录的常规设置，包括： 						
     - ​										记录的名称 								
     - ​										记录保存的路径和文件名 								
     - ​										记录是固定时间还是持续记录，将使用事件模板 								
     - ​										记录的描述 								
   - ​								第二个页面包含 flight 记录的事件选项。您可以配置 Garbage Collections、Memory Profiling 和 Method Sampling 和其他事件记录的详情级别。 						
   - ​								第三个页面包含事件详细信息的设置。您可以打开或关闭事件，启用堆栈跟踪的记录，并更改记录事件所需的时间阈值。 						

3. ​						编辑记录的设置。 				

4. ​						点 

1. 。 				

   ​						这个向导会退出，flight 记录会启动。 				

## 3.4. 定义并使用自定义事件 API

​				JDK Flight Recorder (JFR)是一个事件记录器，其中包含自定义事件 API。存储在 `jdk.jfr` 模块中的自定义事件 API 是软件接口，使您的应用程序能够与 JFR 通信。 		

​				JFR API 包括可以用来管理记录并为 Java 应用程序、JVM 或操作系统创建自定义事件的类。 		

​				在使用自定义事件 API 监控事件前，您必须为自定义事件类型定义名称和元数据。 		

​				您可以通过扩展 `Event` 类来定义 JFR 基本事件，如 `Duration`、`Instant`、`Requestable` 或 `Time 事件`。具体来说，您可以将字段（如持续时间值）添加到与应用程序有效负载属性定义的数据类型匹配的类。定义 `Event` 类后，您可以创建事件对象。 		

​				此流程演示了如何使用带有 JFR 和 JDK Mission Control (JMC)的自定义事件类型来分析简单示例程序的运行时性能。 		

**流程**

1. ​						在自定义事件类型中，在 `Event` 类中，使用 `@name` 注释来命名自定义事件。这个名称显示在 JMC 图形用户界面(GUI)中。 				

   **在 `Event` 类中定义自定义事件类型名称的示例**

   ​							

   

   ```java
   @Name(“SampleCustomEvent”)
   public class SampleCustomEvent extends Event {...}
   ```

2. ​						定义 `Event` 类及其属性的元数据，如名称、类别和标签。标签显示客户端的事件类型，如 JMC。 				

   注意

   ​							大型记录文件可能会导致性能问题，这可能会影响您想与文件交互的方式。确保正确定义您需要的事件记录注解数量。定义不必要的注解可能会增加您的记录文件的大小。 					

   **为示例 `事件` 类定义注解示例**

   ​							

   

   ```java
   @Name(“SampleCustomEvent”)  1
   @Label("Sample Custom Event")
   @Category("Sample events")
   @Description("Custom Event to demonstrate the Custom Events API")
   @StackTrace(false) 2
   public class SampleCustomEvent extends Event {
   
   
       @Label("Method") 3
       public String method;
   
   
       @Label("Generated Number")
       public int number;
   
   
       @Label("Size")
       @DataAmount 4
       public int size;
   }
   ```

   - [*1*](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/index#CO1-1) 

     ​								详情注解，如 `@Name`，用于定义在 JMC GUI 上如何显示自定义事件的元数据。 						

   - [*2*](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/index#CO1-2) 

     ​								`@StackTrace` 注释会增加航班记录的大小。默认情况下，JFR 不包含为事件创建的位置的 `stackTrace`。 						

   - [*3*](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/index#CO1-3) 

     ​								`@Label` 注释定义每种方法的参数，如 HTTP 请求的资源方法。 						

   - [*4*](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/using_jdk_flight_recorder_with_openjdk/index#CO1-4) 

     ​								`@DataAmount` 注释包含定义数据数（以字节为单位）的属性。JMC 自动以其他单位呈现数据数量，如 MB (MB)。 						

3. ​						在 `Event` 类中定义上下文信息。此信息设定自定义事件类型的请求处理行为，以便您可以配置事件类型来收集特定的 JFR 数据。 				

   **定义简单 `主` 类和事件循环示例**

   ​							

1. ```java
   public class Main {
   
   	private static int requestsSent;
   
   	public static void main(String[] args) {
       	// Register the custom event
       	FlightRecorder.register(SampleCustomEvent.class);
       	// Do some work to generate the events
       	while (requestsSent <= 1000) {
           	try {
               	eventLoopBody();
               	Thread.sleep(100);
           	} catch (Exception e) {
               	e.printStackTrace();
           	}
       	}
       }
   
   	private static void eventLoopBody() {
       	// Create and begin the event
       	SampleCustomEvent event = new SampleCustomEvent();
       	event.begin();
       	// Generate some data for the event
       	Random r = new Random();
       	int someData = r.nextInt(1000000);
       	// Set the event fields
       	event.method = "eventLoopBody";
       	event.number = someData;
       	event.size = 4;
       	// End the event
       	event.end();
       	event.commit();
       	requestsSent++;
       }
   ```

   ​						在上例中，simple `main` 类注册事件，事件循环会填充事件字段，然后发出自定义事件。 				

2. ​						检查您选择的应用程序中的事件类型，如 JMC 或 JFR 工具。 				

   图 3.2. 在 JMC 中检查事件类型的示例

   [![检查事件类型示例应用程序](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/16bcdc14b43b1334d45e24278c1188a4/examine_event_type_example_application.png)](https://access.redhat.com/webassets/avalon/d/OpenJDK-17-Using_JDK_Flight_Recorder_with_OpenJDK-zh-CN/images/16bcdc14b43b1334d45e24278c1188a4/examine_event_type_example_application.png)

   ​						JFR 记录可以包括不同的事件类型。您可以检查应用程序中的每个事件类型。 				

**其他资源**

- ​						有关 JMC 的更多信息，请参阅 [JDK Mission Control 简介](https://access.redhat.com/documentation/zh-cn/openjdk/17/html/using_jdk_flight_recorder_with_openjdk/overview-jmc)。 				

# 第 4 章 JDK Flight Recorder 的配置选项

​			您可以配置 JDK Flight Recorder (JFR)，以使用命令行或诊断命令捕获各种事件集合。 	

## 4.1. 使用命令行配置 JDK Flight Recorder

​				您可以使用以下选项从命令行配置 JDK Flight Recorder (JFR)： 		

### 4.1.1. 启动 JFR

​					使用 `-XX:StartFlightRecording` 选项为 Java 应用程序启动 JFR 记录。例如： 			



```none
java -XX:StartFlightRecording=delay=5s,disk=false,dumponexit=true,duration=60s,filename=myrecording.jfr <<YOUR_JAVA_APPLICATION>>
```

​					您可以在启动 JFR 记录时 `设置以下参数=值` 条目： 			

- **delay=time**

  ​								使用这个参数指定 Java 应用程序启动时间和记录开始之间的延迟。附加 s 以指定时间（以秒为单位）、m （分钟）、h （小时）或 d （天）。例如，指定 10m 表示 10 分钟。默认情况下，没有延迟，此参数被设置为 0。 						

- **disk={true|false}**

  ​								使用这个参数指定是否在记录时将数据写入磁盘。默认情况下，此参数为 `true`。 						

- **dumponexit={true|false}**

  ​								使用此参数指定在 JVM  关闭时是否转储正在运行的记录。如果启用了参数且未设置文件名，则会将记录写入记录进度所在的目录中的文件。文件名是一个系统生成的名称，其中包含进程  ID、记录 ID 和当前时间戳。例如：  hotspot-pid-47496-id-1-2018Registration25_19_10_41.jfr。默认情况下，此参数为 `false`。 						

- **duration=time**

  ​								使用这个参数指定记录的持续时间。附加 s 以指定时间（以秒为单位）、m （分钟）、h （小时）或 d （天）。例如，如果您将持续时间指定为 5h，这表示 5 小时。默认情况下，此参数被设置为 0，这意味着在记录期间没有设置限制。 						

- **filename=path**

  ​								使用这个参数指定记录文件的路径和名称。记录会在停止时写入此文件。例如： 						 							where recording.jfr 						 							· /home/user/recordings/recording.jfr 						

- **name=identifier**

  ​								使用这个参数指定记录的名称和标识符。 						

- **maxage=time**

  ​								使用这个参数指定磁盘上应提供的最大天数。只有 disk 参数设置为 true 时，这个参数才有效。附加 s  以指定时间（以秒为单位）、m （分钟）、h （小时）或 d （天）。例如，当您指定 30s 时，它表示 30 秒。默认情况下，此参数设为  0，这意味着没有设置限制。 						

- **maxsize=size**

  ​								使用这个参数指定要保留的最大磁盘大小进行记录。只有 disk 参数设置为 true 时，这个参数才有效。该值不能小于使用 `-XX:FlightRecorderOptions` 设置的 `maxchunksize` 参数的值。附加 m 或 M 以 MB 或 G 为单位指定大小，以 GB 为单位指定大小。默认情况下，磁盘数据的最大大小没有限制，此参数设为 0。 						

- **path-to-gc-roots={true|false}**

  ​								使用这个参数指定是否在记录结束时收集垃圾回收(GC)根的路径。默认情况下，此参数设为 false。 						 							到 GC root 的路径对于查找内存泄漏非常有用。对于 OpenJDK 17，您可以启用 `OldObjectSample` 事件，它是比使用堆转储更有效的替代方案。您还可以在生产环境中使用 `OldObjectSample` 事件。收集内存泄漏信息会非常耗时，并会产生额外的开销。只有在您开始记录具有内存泄漏的应用程序时，才应启用此参数。如果将 JFR 配置集参数设置为 profile，您可以从对象泄漏时跟踪堆栈。它包含在收集的信息中。 						

- **settings=path**

  ​								使用这个参数指定事件设置文件的路径和名称（类型为 JFC）。默认情况下，使用了 default.jfc 文件，该文件位于  JAVA_HOME/lib/jfr  中。此默认设置文件收集一组低开销的预定义信息，因此它对性能的影响很小，并可与持续运行的记录一起使用。另外还提供了第二个设置文件  profile.jfc，它提供比默认配置更多的数据，但其开销和影响性能可能会增加。当需要更多信息时，请在短时间内使用此配置。 						

注意

​						您可以使用逗号分隔多个参数的值。例如，`-XX:StartFlightRecording=disk=false`,`name=example-recording`. 				

### 4.1.2. JFR 的控制行为

​					使用 `-XX:FlightRecorderOptions` 选项来设置控制 JFR 行为的参数。例如： 			



```none
java -XX:FlightRecorderOptions=duration=60s,filename=myrecording.jfr -XX:FlightRecorderOptions=stackdepth=128,maxchunksize=2M <<YOUR_JAVA_APPLICATION>>
```

​					您可以 `设置以下参数=值` 条目来控制 JFR 的行为： 			

- **globalbuffersize=size**

  ​								使用这个参数指定用于数据保留的主内存量。默认值基于为 `memorysize` 指定的值。您可以更改 `memorysize` 参数，以更改全局缓冲区的大小。 						

- **maxchunksize=size**

  ​								使用这个参数在记录中指定数据块的最大大小。附加 m 或 M 以 MB (MB)或 G 为单位来指定大小（以 GB 为单位）。默认情况下，数据块的最大大小被设置为 12 MB。允许的最小大小为 1 MB。 						

- **memorysize=size**

  ​								使用这个参数确定应使用的缓冲区内存量。参数根据指定的大小 `设置全局buffersize` 和 `numglobalbuffers` 参数。附加 m 或 M 以 MB (MB)或 G 为单位来指定大小（以 GB 为单位）。默认情况下，内存大小被设置为 10 MB。 						

- **numglobalbuffers=number**

  ​								使用此参数指定使用的全局缓冲区数量。默认值基于 `memorysize` 参数中指定的大小。您可以更改 `memorysize` 参数，以更改全局缓冲区的数量。 						

- **old-object-queue-size=number-of-objects**

  ​								使用此参数跟踪旧对象的最大数量。默认情况下，对象数量设置为 256。 						

- **repository=path**

  ​								使用此参数为临时磁盘存储指定存储库。默认情况下，它使用系统临时目录。 						

- **retransform={true|false}**

  ​								使用此参数指定是否应通过 JVMTI 重新传输事件类。如果设置为 `false`，则会将检测添加到载入的事件类中。默认情况下，此参数被设置为 `true` 以启用类重新传输。 						

- **samplethreads={true|false}**

  ​								使用此参数指定是否启用了线程抽样。只有在启用抽样事件且此参数设为 `true` 时，线程抽样才会发生。默认情况下，此参数设为 `true`。 						

- **stackdepth=depth**

  ​								使用此参数为堆栈追踪设置堆栈深度。默认情况下，堆栈深度设置为 64 方法调用。您可以将最大堆栈深度设置为 2048。大于 64 的值可能会造成大量开销并降低性能。 						

- **threadbuffersize=size**

  ​								使用此参数指定线程的本地缓冲区大小。默认情况下，本地缓冲区大小被设置为 8 KB，最小值为 4 KB。覆盖此参数可能会降低性能，我们不推荐这样做。 						

注意

​						您可以使用逗号分隔多个参数的值。 				

## 4.2. 使用诊断命令(JCMD)配置 JDK Flight Recorder

​				您可以使用 Java 诊断命令配置 JDK Flight Recorder (JFR)。执行诊断命令的最简单方法是使用 `jcmd` 工具，它位于 Java 安装目录中。要使用命令，您必须传递 JVM 的进程标识符或主类的名称，并将实际命令作为参数传给 `jcmd`。您可以通过运行不带参数的 `jcmd` 或使用 `jps` 来检索主类的 JVM 或名称。`jps`(Java Process Status)工具列出了其具有访问权限的目标系统的 JVM。 		

​				要查看所有正在运行的 Java 进程的列表，请使用不带任何参数的 `jcmd` 命令。要查看正在运行的 Java 应用程序可用的命令的完整列表，请在进程标识符或主类名称后将 help 指定为诊断命令。 		

​				对 JFR 使用以下诊断命令： 		

### 4.2.1. 启动 JFR

​					使用 `JFR.start` 诊断命令启动机票记录。例如： 			



```none
jcmd <PID> JFR.start delay=10s duration=10m filename=recording.jfr
```

表 4.1. 下表列出了您可以在这个命令中使用的参数：

| 参数             | 描述                         | 数据类型 | 默认值 |
| ---------------- | ---------------------------- | -------- | ------ |
| name             | 记录的名称                   | 字符串   | -      |
| 设置             | 服务器端模板                 | 字符串   | -      |
| duration         | 记录期间                     | Time     | 0s     |
| filename         | 生成记录文件名               | 字符串   | -      |
| maxAge           | 缓冲区数据的最长期限         | Time     | 0s     |
| maxsize          | 以字节为单位的最大缓冲区大小 | Long     | 0      |
| dumponexit       | 在 JVM 关闭时转储运行记录    | 布尔值   | -      |
| path-to-gc-roots | 收集到垃圾收集器根的路径     | 布尔值   | False  |

### 4.2.2. 停止 JFR

​					使用 `JFR.stop` 诊断命令停止运行 flight 记录。例如： 			



```none
jcmd <PID> JFR.stop name=output_file
```

表 4.2. 下表列出了您可以在此命令中使用的参数。

| 参数     | 描述                   | 数据类型 | 默认值 |
| -------- | ---------------------- | -------- | ------ |
| name     | 记录的名称             | 字符串   | -      |
| filename | 将记录数据复制到文件中 | 字符串   | -      |

### 4.2.3. 检查 JFR

​					使用 `JFR.check` 命令显示有关正在进行的记录的信息。例如： 			



```none
jcmd <PID> JFR.check
```

表 4.3. 下表列出了您可以在此命令中使用的参数。

| 参数             | 描述                     | 数据类型 | 默认值 |
| ---------------- | ------------------------ | -------- | ------ |
| name             | 记录的名称               | 字符串   | -      |
| filename         | 将记录数据复制到文件中   | 字符串   | -      |
| maxAge           | 转储文件的最大持续时间   | Time     | 0s     |
| maxsize          | 要转储的最大字节数       | Long     | 0      |
| begin            | 开始转储数据的时间       | 字符串   | -      |
| end              | 转储数据的结束时间       | 字符串   | -      |
| path-to-gc-roots | 收集到垃圾收集器根的路径 | 布尔值   | false  |

### 4.2.4. 转储 JFR

​					使用 `JFR.dump` 诊断命令将 flight 记录的内容复制到文件中。例如： 			



```none
jcmd <PID> JFR.dump name=output_file filename=output.jfr
```

表 4.4. 下表列出了您可以在此命令中使用的参数。

| 参数             | 描述                     | 数据类型 | 默认值 |
| ---------------- | ------------------------ | -------- | ------ |
| name             | 记录的名称               | 字符串   | -      |
| filename         | 将记录数据复制到文件中   | 字符串   | -      |
| maxAge           | 转储文件的最大持续时间   | Time     | 0s     |
| maxsize          | 要转储的最大字节数       | Long     | 0      |
| begin            | 开始转储数据的时间       | 字符串   | -      |
| end              | 转储数据的结束时间       | 字符串   | -      |
| path-to-gc-roots | 收集到垃圾收集器根的路径 | 布尔值   | false  |

### 4.2.5. 配置 JFR

​					使用 `JFR.configure` 诊断命令配置 flight 记录。例如： 			



```none
jcmd <PID> JFR.configure repositorypath=/home/jfr/recordings
```

表 4.5. 下表列出了您可以在此命令中使用的参数。

| 参数               | 描述             | 数据类型 | 默认值   |
| ------------------ | ---------------- | -------- | -------- |
| repositorypath     | 仓库的路径       | 字符串   | -        |
| dumppath           | 转储的路径       | 字符串   | -        |
| stackdepth         | 堆栈深度         | Jlong    | 64       |
| globalbuffercount  | 全局缓冲区数     | Jlong    | 32       |
| globalbuffersize   | 全局缓冲区的大小 | Jlong    | 524288   |
| thread_buffer_size | 线程缓冲区的大小 | Jlong    | 8192     |
| memorysize         | 总内存大小       | Jlong    | 16777216 |
| maxchunksize       | 单个磁盘块的大小 | Jlong    | 12582912 |
| Samplethreads      | 激活线程抽样     | 布尔值   | true     |

​					*更新于 2023-04-27* 			

# 在 RHEL 上使用 FIPS 配置 OpenJDK 17

OpenJDK 17

##  

 Red Hat Customer Content Services  

[法律通告](https://access.redhat.com/documentation/zh-cn/openjdk/17/html-single/configuring_openjdk_17_on_rhel_with_fips/index#idm140000514958608)

**摘要**

​				OpenJDK 是 Red Hat Enterprise Linux 平台上的红帽产品。*使用 FIPS 在 RHEL 上配置 OpenJDK 17* 概述了 FIPS，并解释了如何使用 FIPS 启用和配置 OpenJDK。 		

------

# 使开源包含更多

​			红帽致力于替换我们的代码、文档和 Web 属性中存在问题的语言。我们从这四个术语开始：master、slave、黑名单和白名单。由于此项工作十分艰巨，这些更改将在即将推出的几个发行版本中逐步实施。详情请查看 [CTO Chris Wright 的信息](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language)。 	

# 对红帽文档提供反馈

​			我们感谢您对我们文档的反馈。要提供反馈，您可以突出显示文档中的文本并添加注释。 	

​			本节介绍如何提交反馈。 	

**先决条件**

- ​					已登陆到红帽客户门户网站。 			
- ​					在红帽客户门户中，以**多页 HTML** 格式查看文档。 			

**流程**

​				要提供反馈，请执行以下步骤： 		

1. ​					点文档右上角的**反馈**按钮查看现有的反馈。 			

   注意

   ​						反馈功能仅在**多页 HTML** 格式中启用。 				

2. ​					高亮标记您要提供反馈的文档中的部分。 			

3. ​					点在高亮文本旁弹出的 **Add Feedback**。 			

   ​					文本框将在页面右侧的"反馈"部分中打开。 			

4. ​					在文本框中输入您的反馈，然后点 **Submit**。 			

   ​					创建了一个与文档相关的问题。 			

5. ​					要查看问题，请单击反馈视图中的问题跟踪器链接。 			

# 第 1 章 联邦信息处理标准(FIPS)简介

​			联邦信息处理标准(FIPS)提供了提高计算机系统和网络的安全性和互操作性的指南和要求。FIPS 140-2 和 140-3  系列适用于硬件和软件级别的加密模块。美国美国美国美国美国美国美国美国美国国家标准与技术的国家公司实施加密模块验证程序，且可搜索模块以及经过批准的加密模块列表。 	

​			Red Hat Enterprise Linux (RHEL)提供了一个集成的框架，以便在系统范围内启用 FIPS 140-2  合规性。当在 FIPS  模式下运行时，使用加密库的软件包会根据全局策略自行配置。大多数软件包都提供了一种方式来更改默认对齐行为以实现兼容性或其他需求。 	

​			OpenJDK 17 是一个 FIPS 策略感知软件包。 	

**其他资源**

- ​					有关加密模块验证程序的更多信息，请参阅美国 *标准和技术* 网站上的加密模块 [验证程序 CMVP](https://csrc.nist.gov/Projects/Cryptographic-Module-Validation-Program)。 			
- ​					有关如何安装启用了 FIPS 模式的 RHEL 的更多信息，请参阅 [安装启用了 FIPS 模式的 RHEL 8 系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/security_hardening/assembly_securing-rhel-during-installation-security-hardening#assembly_installing-a-rhel-8-system-with-fips-mode-enabled_securing-rhel-during-installation)。 			
- ​					有关如何在安装 RHEL 后启用 FIPS 模式的更多信息，请参阅 [将系统切换到 FIPS 模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening#switching-the-system-to-fips-mode_using-the-system-wide-cryptographic-policies)。 			
- ​					有关如何在 RHEL 中以 FIPS 模式运行 OpenJDK 的更多信息。[请参阅在 RHEL 上以 FIPS 模式运行 OpenJDK](https://access.redhat.com/articles/5895481)。 			
- ​					有关红帽遵守政府标准的更多信息，请参阅 [政府标准](https://access.redhat.com/articles/2918071)。 			

# 第 2 章 在 FIPS 模式中配置 OpenJDK 17

​			OpenJDK 17 检查系统中是否启用了 FIPS 模式。如果为 yes，它会根据全局策略自助配置 FIPS。这是自 RHEL 8.3 开始的默认行为。以前的 RHEL 8 版本需要将 `com.redhat.fips` 系统属性设置为 `true` 作为 JVM 参数。例如，`-Dcom.redhat.fips=true`。 	

注意

​				如果在 JVM 实例运行时在系统中启用了 FIPS 模式，则需要重启实例以使更改生效。 		

​			您可以配置 OpenJDK 17 来绕过全局 FIPS 校准。例如，您可能希望通过硬件安全模块(HSM)而不是 OpenJDK 提供的方案启用 FIPS 合规性。 	

​			以下是 OpenJDK 17 的 FIPS 属性： 	

- ​					`security.useSystemPropertiesFile` 			
  - ​							位于 `$JAVA_HOME/conf/security/java.security` 或定向到 `java.security.properties` 的文件中的安全属性。 					
  - ​							修改默认 `java.security` 文件中的值需要特权访问权限。 					
  - ​							永久配置。 					
  - ​							当设置为 `false` 时，全局 FIPS 和 crypto-policies 校准都被禁用。默认情况下，它被设置为 `true`。 					
- ​					`java.security.disableSystemPropertiesFile` 			
  - ​							作为参数传递到 JVM 的系统属性。For example, `-Djava.security.disableSystemPropertiesFile=true`. 					
  - ​							非特权访问就足够了。 					
  - ​							非持久性配置。 					
  - ​							当设置为 `true` 时，全局 FIPS 和 crypto-policies 校准都被禁用；生成与 `security.useSystemPropertiesFile=false` 安全属性相同的效果。如果这两个属性都被设置为不同的行为，则 `java.security.disableSystemPropertiesFile` 覆盖。默认情况下，它被设置为 `false`。 					
- ​					`com.redhat.fips` 			
  - ​							作为参数传递到 JVM 的系统属性。例如： `-Dcom.redhat.fips=false`。 					
  - ​							非特权访问就足够了。 					
  - ​							非持久性配置。 					
  - ​							当设置为 `false` 时，在仍然应用全局 crypto-policies 时禁用 FIPS 校准。如果将之前属性设置为禁用 crypto-policies 校准，此属性无效。换句话说，crypto-policies 是 FIPS 校准的先决条件。默认情况下，它被设置为 `true`。 					

**其他资源**

- ​					有关如何启用 FIPS 模式的更多信息，请参阅 [将系统切换到 FIPS 模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening#switching-the-system-to-fips-mode_using-the-system-wide-cryptographic-policies)。 			

# 第 3 章 OpenJDK 17 中的默认 FIPS 配置

​			OpenJDK 17 包括了一个默认为 FIPS-complaint 设置的联邦信息处理标准(FIPS)配置简介。 	

​			在考虑对这些默认配置进行任何更改前，请查看以下 OpenJDK 17 默认 FIPS 配置： 	

## 3.1. 安全供应商

​				全局 java 安全策略文件控制 OpenJDK 安全策略。您可以在 `$JRE_HOME/lib/security/java.security` 中找到 java 安全策略文件。 		

​				启用 FIPS 模式后，OpenJDK 将已安装的安全供应商替换为以下供应商，这些供应商按降序列出： 		

#### SunPKCS11-NSS-FIPS

- ​						使用网络安全服务(NSS)软件令牌(PKCS39)后端）初始化。NSS Software Token 包含以下配置： 				
  - ​								name = NSS-FIPS 						
  - ​								nssLibraryDirectory = /usr/lib64 						
  - ​								nssSecmodDirectory = /etc/pki/nssdb 						
  - ​								nssDbMode = readOnly 						
  - ​								nssModule = fips 						
- ​						NSS 库实现 FIPS 兼容软件令牌。另外，RHEL 中的 FIPS 策略感知。 				

#### SUN

- ​						对于 X.509 证书，仅支持。检查您的应用程序是否使用此提供程序的其他加密算法。否则，安全提供程序会抛出 `java.security.NoSuchAlgorithmException` 消息。 				

#### SunEC

- ​						对于 `SunPKCS11` 辅助帮助程序。检查您的应用程序没有明确使用此提供程序。 				

#### SunJSSE

- ​						对于 TLS 支持，`SunJSSE` 将 `SUN` 提供程序用于 X.509 证书，对所有加密原语使用 `SunPKCS11-NSS-FIPS` 提供程序。 				

## 3.2. crypto-policies

​				启用 FIPS 模式后，OpenJDK 从全局加密策略获取加密算法的配置值。您可以在 `/etc/crypto-policies/back-ends/java.config` 中找到这些值。您可以使用 RHEL 中的 `update-crypto-policies` 工具以一致的方式管理 crypto-policies。 		

注意

​					在 OpenJDK 的 FIPS 模式中可能无法使用 crypto-policies 批准算法。当 NSS 库或 OpenJDK 的 `SunPKCS11` 安全供应商不支持 FIPS 的实现时，会出现这种情况。 			

## 3.3. 信任 Anchor 证书

​				在 FIPS 模式中时，OpenJDK 使用全局信任 Anchor 证书存储库。您可以在 `/etc/pki/java/cacerts` 中找到此存储库。使用 RHEL 中的 `update-ca-trust` 工具以一致的方式管理证书。 		

## 3.4. 密钥存储

​				使用 FIPS 模式，OpenJDK 使用 NSS DB 作为密钥的只读 `PKCS` the 存储。因此，`keystore.type` 安全属性被设置为 `PKCS11`。您可以在 `/etc/pki/nssdb` 中找到 NSS DB 存储库。使用 RHEL 中的 `modutil` 工具来管理 NSS DB 密钥。 		

​				*更新于 2023-04-24* 		