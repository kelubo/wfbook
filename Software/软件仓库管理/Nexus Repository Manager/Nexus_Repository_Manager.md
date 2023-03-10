# Nexus Repository Manager 3

[TOC]

## 概述

Sonatype has discovered a [critical bug](https://issues.sonatype.org/browse/NEXUS-34642) that can cause cleanup policies to unintentionally delete binaries in **Nexus Repository Pro deployments** which use H2 or PostgreSQL. See our [official advisory](https://help.sonatype.com/repomanager3/product-information/critical-cleanup-policy-bug-advisory) for detailed information about who is affected and suggested remediation steps.

 

Sonatype products are not vulnerable to the recently reported Apache Log4j2 security issues ([CVE-2021-44228](https://ossindex.sonatype.org/vulnerability/f0ac54b6-9b81-45bb-99a4-e6cb54749f9d) and [CVE-2021-45046](https://ossindex.sonatype.org/vulnerability/edaf092e-e7f3-4c69-8f01-a5c6fc44890a)). For detailed product-by-product information, please see [Sonatype Product Log4j Vulnerability Status](https://help.sonatype.com/docs/important-announcements/sonatype-product-log4j-vulnerability-status).

 

In response to the log4j vulnerability [CVE-2021-44228](https://ossindex.sonatype.org/vulnerability/f0ac54b6-9b81-45bb-99a4-e6cb54749f9d) (also called "log4shell") impacting organizations world-wide, we are  providing an experimental Log4j Visualizer capability to help our users  identify log4shell downloads so that they can mitigate the impact. Check out the [3.37.3 Release Notes](https://help.sonatype.com/repomanager3/product-information/release-notes/2021-release-notes/nexus-repository-3.37.0---3.37.3-release-notes) and our [Log4j Visualizer documentation](https://help.sonatype.com/repomanager3/nexus-repository-administration/capabilities/log4j-visualizer) for more information!



Our online help provides everything you need to know to use the latest Nexus Repository version.

Are you on the newest version? Get the latest version of [Nexus Repository](https://help.sonatype.com/repomanager3/product-information/download) and learn about all the [new features](https://help.sonatype.com/repomanager3/release-notes) we have released.

We always recommend upgrading to the latest release so you don't miss out on any new features or important bug fixes.

Unsure where to start? Check out some of our [most popular topics](https://help.sonatype.com/repomanager3#RepositoryManager3-New), look through our [supported formats](https://help.sonatype.com/repomanager3#RepositoryManager3-Formats), or learn more about [Nexus Repository Pro features](https://help.sonatype.com/repomanager3#RepositoryManager3-ProvsOSS).

Sonatype发现了一个关键错误，它可能导致清理策略无意中删除Nexus Repository Pro部署中使用H2或Postgre SQL的二进制文件。有关受影响的人员和建议的补救措施的详细信息，请参阅我们的官方咨询。

Sonatype产品不易受到最近报告的Apache Log4j2安全问题的影响（CVE-221-44228和CVE-2021-45046）。有关每个产品的详细信息，请参阅Sonatype product Log4j漏洞状态。

为了应对影响全球组织的log4j漏洞CVE-221-44228（也称为“log4shell”），我们正在提供实验性的log4j可视化工具功能，帮助用户识别log4shel下载，从而减轻影响。查看3.37.3发行说明和我们的Log4j Visualizer文档以了解更多信息！

我们的在线帮助提供了使用最新Nexus Repository版本所需的一切信息。

你是最新版本的吗？获取Nexus Repository的最新版本，了解我们发布的所有新功能。

我们始终建议您升级到最新版本，这样您就不会错过任何新功能或重要的错误修复。

不确定从何开始？查看我们最流行的一些主题，查看我们支持的格式，或了解更多有关Nexus Repository Pro功能的信息。

In addition, you can always check out a variety of additional content available via [Sonatype Learning](https://help.sonatype.com/repomanager3#).

------

## Looking for Formats?  

Nexus Repository delivers universal support for package managers and formats! Select a link below to view our [format documentation](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats):

| ![debian logo](https://help.sonatype.com/repomanager3/files/329991/95388595/1/1637077929056/apt.png)[Apt ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/apt-repositories) | ![CocoaPods logo](https://help.sonatype.com/repomanager3/files/329991/95388594/1/1637077929035/Screen+Shot+2021-11-09+at+7.29.16+AM.png)[CocoaPods ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/cocoapods-repositories) | ![Conan logo](https://help.sonatype.com/repomanager3/files/329991/95388593/1/1637077929015/conan.png)[Conan ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/conan-repositories) | ![CONDA logo](https://help.sonatype.com/repomanager3/files/329991/95388592/1/1637077928997/Screen+Shot+2021-11-09+at+7.34.24+AM.png)[Conda ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/conda-repositories) | ![docker logo](https://help.sonatype.com/repomanager3/files/329991/95388591/1/1637077928979/docker.png)[Docker ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/docker-registry) | ![Git LFS logo](https://help.sonatype.com/repomanager3/files/329991/95388590/1/1637077928963/git_lfs.png)[Git LFS ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/git-lfs-repositories) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![Golang logo](https://help.sonatype.com/repomanager3/files/329991/95388589/1/1637077928946/golang.png)[Go ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/go-repositories) | ![Helm logo](https://help.sonatype.com/repomanager3/files/329991/95388588/1/1637077928929/helm.png)[Helm ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/helm-repositories) | ![Maven logo](https://help.sonatype.com/repomanager3/files/329991/95388587/1/1637077928910/maven.png)[Maven ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/maven-repositories) | ![npm logo](https://help.sonatype.com/repomanager3/files/329991/95388586/1/1637077928892/npm.png)[npm ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/npm-registry) | ![NuGet logo](https://help.sonatype.com/repomanager3/files/329991/95388585/1/1637077928874/nuget.png)[NuGet ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/nuget-repositories) | ![p2 logo](https://help.sonatype.com/repomanager3/files/329991/95388584/1/1637077928856/p2.png)[p2 ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/p2-repositories) |
| ![PyPI logo](https://help.sonatype.com/repomanager3/files/329991/95388583/1/1637077928839/pypi.png)[PyPI ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/pypi-repositories) | ![R logo](https://help.sonatype.com/repomanager3/files/329991/95388582/1/1637077928822/r.png)[R ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/r-repositories) | ![Folder structure icon representing Raw format](https://help.sonatype.com/repomanager3/files/329991/95388581/1/1637077928805/raw.png)[Raw ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/raw-repositories) | ![RubyGems logo](https://help.sonatype.com/repomanager3/files/329991/95388580/1/1637077928786/rubygems.png)[RubyGems ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/rubygems-repositories) | ![yum logo](https://help.sonatype.com/repomanager3/files/329991/95388579/1/1637077928750/yum.png)[Yum ](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/yum-repositories) | Learn More About [Formats](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats)! |



------

## Which Nexus Repository is best for you?  

Did you know Nexus Repository comes in OSS and Pro versions? Check out the features you may be missing:

| Type                     | Features                                                     | Where to Start                                               |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **Nexus Repository OSS** | [Basic Repository Management](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management)[Storage](https://help.sonatype.com/repomanager3/planning-your-implementation/storage-guide)[Routing Rules](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/routing-rules)[Cleanup](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/cleanup-policies)[Formats](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats)[Backup and Restore](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore) | [Download Nexus Repository](https://help.sonatype.com/repomanager3/product-information/download). |
| **Nexus Repository Pro** | These features are only available in Nexus Repository Pro:Cloud Options like Azure Blob Store[Resilient Deployment Options](https://help.sonatype.com/repomanager3/planning-your-implementation/resiliency-and-high-availability)[External PostgreSQL Database Option](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options)[Import](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks/repository-import)/[Export](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks/repository-export)[Repository Replication (Legacy)](https://help.sonatype.com/repomanager3#)[Staging](https://help.sonatype.com/repomanager3/nexus-repository-administration/staging) and [Tagging](https://help.sonatype.com/repomanager3/nexus-repository-administration/tagging)[Group Blob Stores](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/configuring-blob-stores#ConfiguringBlobStores-PromotingaBlobStoretoaGroup)[Change Repository Blob Store](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks/change-repository-blob-store)[Enhanced Repository Health Check](https://support.sonatype.com/hc/en-us/articles/360009119153?_ga=2.22912189.709526397.1636361732-189973748.1631708937)[SAML and SSO](https://help.sonatype.com/repomanager3/nexus-repository-administration/user-authentication/saml)[User Token Support](https://help.sonatype.com/repomanager3/nexus-repository-administration/user-authentication/security-setup-with-user-tokens)Enterprise Support from Sonatype | Interested in a free trial? [Start here](https://www.sonatype.com/products/repository-pro/trial)!Already have a Pro license? [Download Nexus Repository](https://help.sonatype.com/repomanager3/product-information/download). Your Pro license will enable Pro features. |



Have a suggestion for our documentation? Let us know by emailing us at [docs@sonatype.com](mailto:docs@sonatype.com)!

To learn more about Nexus solutions and licenses, see http://www.sonatype.com/ or contact [sales@sonatype.com](mailto:sales@sonatype.com).

此外，您还可以通过Sonatype Learning查看各种其他内容。

正在查找格式？

Nexus Repository为包管理器和格式提供通用支持！选择下面的链接以查看我们的格式文档：

debian标志

恰当的

Cocoa Pods徽标

可可荚

柯南标志

柯南

CONDA标志

康达

码头工人标志

Docker公司

Git LFS徽标

Git LFS公司

Golang标志

去

Helm徽标

赫尔姆

Maven徽标

专家

npm徽标

净现值

Nu Get徽标

Nu Get公司

p2徽标

第2页

Py PI徽标

比例PI

R徽标

R

代表原始格式的文件夹结构图标

未经加工的

红宝石宝石标志

红宝石宝石

yum徽标

呀呣

了解更多有关格式的信息！

哪个Nexus存储库最适合您？

你知道Nexus Repository有OSS和Pro版本吗？查看您可能缺少的功能：

键入功能开始位置

Nexus存储库OSS

基本存储库管理

存储

路由规则

清理

格式

备份和恢复

下载Nexus Repository。

Nexus存储库专业版

这些功能仅在Nexus Repository Pro中可用：

Azure Blob Store等云选项

弹性部署选项

外部Postgre SQL数据库选项

导入/导出

存储库复制（旧版）

暂存和标记

组Blob存储

更改存储库Blob存储

增强的存储库运行状况检查

SAML和SSO

用户令牌支持

Sonatype的企业支持

对免费试用感兴趣？从这里开始！

已经拥有Pro许可证？下载Nexus Repository。

您的Pro许可证将启用Pro功能。

对我们的文档有什么建议吗？请发送电子邮件至docs@sonatype.com!

要了解有关Nexus解决方案和许可证的更多信息，请参阅http://www.sonatype.com/或联系人sales@sonatype.com.

# Product Information

This space contains important Nexus Repository product information for your reference needs.

## Just Getting Started?

- [Download](https://help.sonatype.com/repomanager3/product-information/download) Nexus Repository
- Make sure you understand our [System Requirements](https://help.sonatype.com/repomanager3/product-information/system-requirements)
- Learn about new features from our [Release Notes](https://help.sonatype.com/repomanager3/product-information/release-notes)

## Trying to Decide Which Nexus Repository is Right for You?

- Check out our [Nexus Repository Pro features](https://help.sonatype.com/repomanager3/product-information/repository-manager-pro-features)
- Start a [Nexus Repository Pro trial](https://www.sonatype.com/products/repository-pro/trial)
- Take a look at our [feature matrix](https://help.sonatype.com/repomanager3/product-information/repository-manager-feature-matrix)

产品信息

此空间包含重要的Nexus Repository产品信息，供您参考。

刚刚开始？

下载Nexus存储库

确保您了解我们的系统要求

从我们的发行说明中了解新功能

试图决定哪一个Nexus存储库适合您？

查看我们的Nexus Repository Pro功能

启动Nexus Repository Pro试用版

看看我们的特征矩阵

# Database Options

 

 

 

We highly recommend that you have your Nexus Repository 3 instance use an external PostgreSQL database. See our [documentation on configuring Nexus Repository Pro for an external PostgreSQL database](https://help.sonatype.com/repomanager3/installation-and-upgrades/configuring-nexus-repository-pro-for-h2-or-postgresql#ConfiguringNexusRepositoryProforH2orPostgreSQL-ConfiguringforExternalPostgreSQL) or on [migrating an existing Nexus Repository 3 instance to a PostgreSQL database](https://help.sonatype.com/repomanager3/installation-and-upgrades/migrating-to-a-new-database).

## Database Options for Nexus Repository

Nexus Repository has a few database options:

1.  An    external PostgreSQL database (Preferred) PRO
2. An embedded H2 database PRO
3. An embedded OrientDB database

This topic will explain the database options and benefits to an external database.

## Choosing a Database Mode

We recommend that all new and existing Nexus Repository Pro deployments  use PostgreSQL or H2. Using PostgreSQL will help organizations meet  their resiliency, scaling, and business continuity requirements.  PostgreSQL should be used for any centralized repository which require fault tolerant deployments.

The table below can help you choose the appropriate database mode for your deployment:

| Database Mode                           | Appropriate For                                              |
| --------------------------------------- | ------------------------------------------------------------ |
| **External PostgreSQL (Preferred)** PRO | Moderate or large workloadsEnterprise deploymentsMission-critical deployments of any sizeCloud deployments (AWS, Azure)Deployments planning to use a resiliency deployment modelDynamic backups for a shorter maintaince window |
| **Embedded H2 ****PRO**                 | Smaller workloads (supported workload limitation is 20K requests per day and 100K components)Single-team deploymentsNon-mission-critical deploymentsDisposable deployments (e.g., temporary proxies) |
| **Embedded OrientDB**                   | Deployments that require [formats not yet available in the new database modes](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options/feature-availability-for-postgresql-and-h2-databases)Existing deployments that are not ready to migrateRepository OSS deployments For smaller workloads; for workloads over 20K requests per day and 100K components, use PostgreSQL and Nexus Repository Pro |

## Benefits of an External Database

There are a number of benefits to using an external database:

- Easier to scale deployment; *PostgreSQL will be required for planned HA functionality*
- Leverage managed, fault-tolerant cloud databases: AWS Aurora, RDS, Azure, etc.
- Improved container orchestration such as Kubernetes and OpenShift
- Fully available during backups
- Support for multi-AZ cloud deployment models
- Simpler and easier disaster recovery

![img](https://help.sonatype.com/repomanager3/files/78579239/78579240/1/1623890712188/new+DB-01.png)

## Embedded Mode for Nexus Repository

Nexus Repository provides an embedded-database mode with improved speed using H2 instead of OrientDB. This mode is appropriate for the following  scenarios:

- Teams and smaller organizations with non-mission-critical Nexus Repository needs
- Automatically provisioned, disposable Nexus Repository instances (e.g., pools of  proxy-only instances used to shield a primary instance from a heavy read load)

## Migration Information

If you are considering moving from OrientDB to H2 or PostgreSQL, read the following to stand up or migrate your instance:

- [Configuring Nexus Repository Pro for H2 or PostgreSQL](https://help.sonatype.com/repomanager3/installation-and-upgrades/configuring-nexus-repository-pro-for-h2-or-postgresql) (for new instances)

- [Migrating to a New Database](https://help.sonatype.com/repomanager3/installation-and-upgrades/migrating-to-a-new-database) (for migrating existing instances)

  

 

1. Unsupported formats will not be migrated; you will not be able to add new formats  that your new database does not support. Review [Feature Availability for PostgreSQL and H2 Databases](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options/feature-availability-for-postgresql-and-h2-databases) and ensure that your new database supports all of your formats before attemping the migration.
2. Migration is a one-time process; attempts to migrate again will overwrite data.

## Other Database Options Topics

 

- [Feature Availability for PostgreSQL and H2 Databases](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options/feature-availability-for-postgresql-and-h2-databases)

# Feature Availability for PostgreSQL and H2 Databases

 

 

 

**Only available in Nexus Repository Pro. Interested in a free trial? [Start here](https://www.sonatype.com/products/repository-pro/trial).**

There are some important considerations to keep in mind before migrating to a new database:

1. Not all formats are currently compatible with the new database options. Unsupported formats will not be migrated; you will not be able to add new formats  that your new database does not support. Review [Feature Compatibility](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options/feature-availability-for-postgresql-and-h2-databases#FeatureAvailabilityforPostgreSQLandH2Databases-FeatureCompatibility) and ensure that your new database supports all of your formats before migrating.
2. There are some permanent differences at a detailed level.
3. Migration is a one-time process; attempts to migrate again will overwrite data.

##   Feature Compatibility

The table below details features and formats that are compatible and incompatible with the new databases.

| Compatible with New Databases                                | Not Yet Compatible with New Databases                        | Not Compatible with New Databases and No Plan to Support     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **Formats** AptCocoapodsConanCondaDockerGit LFSGoHelmMavennpmNuGet V2NEW IN 3.43.0NuGet V3p2PyPIRRawRubyGemsYum **Cross-Cutting Features** Search, BrowseBlob Storage, GroupsCleanup PoliciesStaging/TaggingRouting RulesFirewall/IQ IntegrationREST APISecurity, Content SelectorsSAML/SSO, Crowd, LDAPRUT Auth, User TokensTasks2-to-3 Upgrade MigratorImport/Export | **Community Formats** APKComposerCPANPuppet**Legacy Formats**[Bower](https://help.sonatype.com/repomanager3/planning-your-implementation/database-options/feature-availability-for-postgresql-and-h2-databases#FeatureAvailabilityforPostgreSQLandH2Databases-Bower) | **High Availability Clustering (HA-C)**  (To be replaced by a new clustering feature.) |

## Feature Changes

While we've made every effort to keep Nexus Repository's external behavior consistent during this change, there are a number of differences to note.

### High Availability Clustering (HA-C)

High Availability Clustering in its current form is a feature of the  embedded OrientDB database. Database externalization lays the groundwork for a new clustering method based on stateless nodes that will be easier to manage and more flexible.  Once this is released, HA-C will be deprecated and replaced.

### Bower Format - Legacy   

In 2017, Bower maintainers announced that Bower itself was deprecated and began recommending that developers switch to package managers such as Yarn. The Bower format will not be made compatible with the new database architecture.

### Backup & Restore

You can back up the embedded H2 database using the same process you've used before , but you will need to use the *Admin - Backup H2 Database* scheduled   task. 

Any existing OrientDB backups will not be compatible with either of the new database options. Nexus  Repository will no longer handle external PostgreSQL database backups;  this will be the system administrator's responsibility.

### Asset Paths

References to Assets via the REST API now require a forwardslash in front a path to work. For example "ticketlist.txt" now must be "/ticketlist.txt".

### Logs

There are no changes to log file locations, but any logging related to database interactions will be different.

### Groovy Scripting

Nexus Repository has a feature for extending its functionality with Groovy  scripts. (This feature is disabled by default for security reasons, but  is still available.) In many cases, these scripts accessed undocumented, non-public Nexus Repository APIs. You may need to update scripts connecting to non-public APIs in order for them to work.

For both security and forward compatibility reasons, we recommend making  use of the public REST API as much as possible rather than using Groovy  scripting.

### Webhooks Events

- Asset events contain the same information as before except that the value assigned to the asset name now begins with a forward slash. Beginning the asset's name with a forward slash is not specfic to webhooks.

- There are no changes to the contents of a Component event.

- The following event types are generated for respository uploads:

  - Asset and Component events of type `CREATED`  *-* the quantities of these are the same as before*.* 
  - Several Asset and Component events of type `UPDATED`  *-* more events of this type are generated.

- The following scenarios will emit an event of type 

  ```
  PURGED
  ```

   containing the IDs of all 

  deleted

   assets and components:

  - When performing component clean up. Nexus Repository no longer generates `DELETED` events for each component and asset deleted during component clean up.
  - Whenever deleting the last component from a maven repository.

- Deleting individual assets/components (i.e., not via component clean up) from a repository generates the same number and types of events as before. 

### Coordinate-Based Content Selectors

Path-based content selectors are fully compatible with the new architecture.  However, we are using the transition to remove a deprecated feature: **coordinate-based**  content selectors. These are any content selectors with references to format-specific coordinates.

### External Plugins

You will need to update external plugins that introduce new repository types, interact repositories or repository content, or  interact with the database directly to be compatible with the new data  access approach.

# Storage Guide

## Introduction

A binary large object (blob) storage, or blobstore, is the folder or  network location for where Nexus Repository will store everthing  uploaded to or proxied from a repository, including basic metadata for  the object. Contents added to the blobstore are obfuscated internally by Nexus Repository to avoid naming collitions and file system constraints and are not meant to be modified externally. The blobstore location  should be configured with as low latency as possible to avoid impacting  performance. Every repository is configured against a single blobstore  or blobstore group with one or many repositores using a given blobstore. 

Generally, blobstore configuration should be limited to the either the storage  disks available, cloud object storage, or a few potential business  requirements where this is recommended. Having a large number of  blobstores will impact performance since querying, [cleanup](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/cleanup-policies), and [indexing tasks](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks) are specific to a giving blobstore. Learn about different options in [the blob store layouts section of Storage Planning.](https://help.sonatype.com/repomanager3/planning-your-implementation/storage-guide/storage-planning#StoragePlanning-BlobStoreLayouts)

By default, Nexus Repository creates a file blob store named `default` in the `$data-dir` directory during installation. You can configure new blob stores by navigating to *Administration* → *Repository* → *Blob Stores* in Nexus Repository. You will need *nx-all* or *nx-blobstore* [privileges](https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control/privileges) to access this section of Nexus Repository.

Find more information in the [Configuring Blob Stores](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/configuring-blob-stores) topic.



​                            

Terminology

- **Binary large object (Blob)** - An object containing data (e.g., component binaries and metadata files) within a blob store.

- **Blob Store** - An internal storage mechanism for the binary parts of components and their assets.

- **Fill Policy** **PRO** - For a group blob store, the fill policy determines to which blob store a blob is written.

- **Group Blob Store PRO** - A blob store that delegates operations to one of the other blob stores on its list.

- **Hard Delete**  - When a soft-deleted blob is permanently removed from the blob store (usually via the *Admin - Compact blob store* task).

-  **Promote to Group PRO** - A process by which a concrete blob store becomes a group blob store that can access the original concrete blob store's blobs.

- **Soft Delete** - When a blob is marked for deletion from a blob store but still exists within the blob store. This exists to protect against accidental deletion.

- Soft Quota 

  \- A feature that monitors a blob store and raises an alert when a  specified metric exceeds a constraint. If a monitoring check fails, then the blob store is considered unhealthy. Writes still proceed, but a  warning is logged. Types of soft quotas are as follows:

  -   **Space Limit**   - A limit (i.e., *Constraint Limit (in MB)*) compared against specific blob store metrics by a soft quota.
  - **Space Used**  **Quota** - This type of quota is violated when the total size of the blob store exceeds the space limit.
  - **Space Remaining Quota** - This type of quota is violated when the available space of a blob store falls below the space limit.

# Storage Planning

 

 

Once you've created a blob store, many of its attributes are immutable. This makes it important to carefully plan your blob store configuration.

You will need to choose which types to use, how many blob stores to create, and how you allocate repositories to these blob stores. These decisions should be based on the following:

- the size of your repositories
- the rate at which you expect them to grow over time
- the storage space available
- the options you have available for adding storage space

## Blob Store Types

Nexus Repository supports several types of blob stores. In general, file  system blob stores have better performance, but object store blob stores offer unbounded storage and convenience. Cloud object stores perform  better if you are also running Nexus Repository in the cloud with the  same cloud provider. File blob store is the default and is recommended for most installations. 

### File Blob Store

A file blob store lets Nexus Repository store blobs as files in a directory. The `Path` parameter supplied during blob store creation determines the blob files' location. The `Path` can be on either a local disk or a NFSv4-compatible mount. If you are  running Nexus Repository in AWS, it is also possible to use EFS, which  acts as a limitless NFS version 4 server.

See [Configuring Blob Stores](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/configuring-blob-stores) for more in-depth information about configuring storage services for use with blob stores.

 

Nexus Repository does not support the following file systems types:

- NFS versions 3 and older
- GlusterFS
- FUSE-based user space file systems

### S3 Blob Store

 

Nexus Repository only supports AWS S3 as documented in our [System Requirements Supported File Systems section](https://help.sonatype.com/repomanager3/product-information/system-requirements#SystemRequirements-FileSystems). Other implementations of the S3 protocol may or may not work, and are not officially supported.

An S3 blob store saves blobs as objects within a bucket on AWS S3.

S3 blob stores have the following requirements:

- The S3 blob store is only recommended for Nexus Repository installations hosted in AWS.
- The S3 blob store should be in the same AWS region as the Nexus Repository  installation. Using different regions will result in unacceptably slow  performance.
- Nexus Repository only supports AWS S3. We neither test nor support other S3 protocol implementations.

Carefully consider whether S3 is the right storage solution for you. Performance  is highly dependent on the speed of the network between Nexus Repository and the AWS endpoint to which you connect. Nexus Repository will send  multiple outbound HTTP requests to AWS to store blobs into S3; large  blobs are split into chunks over multiple requests. If your Nexus  Repository instance is not in AWS or connecting to another region, an S3 blob store may be significantly slower than a file-based blob store.

### Azure Blob Store 

NEW IN 3.31.0 PRO

An Azure blob store saves blobs as objects within a storage account container on Microsoft Azure.

Azure blob stores have the following requirements:

- The Azure blob store is only recommended for Nexus Repository installations hosted in Azure.
- The Azure blob store should be in the same Azure region as the Nexus  Repository installation. Using different regions will result in  unacceptably slow performance.

Carefully consider whether  Azure is the right storage solution for you. Performance is highly  dependent on the network speed between Nexus Repository and Azure. Nexus Repository will send multiple outbound HTTP requests to Azure to store  blobs in the storage account; large blobs are split into chunks over  multiple requests. If your Nexus Repository instance is not in Azure or  connecting to another location, an Azure blob store may be significantly slower than a file-based blob store.

## Blob Store Layouts

Once a repository is associated with a blob store, it can take significant time to run the [tasks](https://help.sonatype.com/repomanager3/system-configuration/tasks/change-repository-blob-store) necessary to change this, and tasks are also only available in Nexus  Repository Pro. Blob stores cannot be split but they can be moved from  one storage device to another using a process described [in Configuring Blob Stores](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/configuring-blob-stores#ConfiguringBlobStores-MovingaBlobStore). For these reasons, your approach to using blob stores should be chosen carefully.

### Single Blob Store

The simplest approach is to create a single blob store per storage device  and divide your repositories among them. This is suitable in the  following cases:

- If you exceed available storage, you will be able to move blob stores to larger storage devices.
- Your repositories are growing slowly enough that you will not exceed your available storage within a year.

### Multiple Blob Stores

If you need to implement multiple blob stores in your configuration, do so with caution. While Nexus Repository can handle many blob store  configurations, performance issues can occur in some scenarios: 

- Repositories that are grouped together or are a part of a shared build pipeline  (e.g., staging) benefit from being on a single blob store. If you use  multiple blob stores in this scenario, components must be copied across  multiple blob stores instead of just updating a database.
- Because cleanup tasks are configured and serialized against each blob store, having many of them can cause them to run slowly.
- The remaining disk space calculations can be inaccurate when multiple blob stores are located on the same disk.
- Having many blob stores may negatively impact database search efficiency.

When creating blob stores, focus on the utility gained versus the cost  associated with managing multiple blob stores. Here are some best  practices and considerations:

- Consider separating blob stores by format as they are often on different build pipelines or repository stages.
- You might split out Docker repositories since they can grow very quickly.
- Consider splitting out more critical components (hosted vs. proxy/replicated repositories).
- Nexus Repository doesn't support partial backup restoration, so you may benefit from keeping more actively developed components on a separate blob store from archived components. You can also put priority components on faster disks while archived ones go on slower, cheaper  storage.
- Only split by teams or lines of business when the team  will never overlap or share components and when there are a reasonably  fixed number of teams.
- Only use automation for initial blob store provisioning, not for mass blob store creation.
- Don't partition blobs per repository. This will cause performance impacts at scale.

### Group Blob Store 

A  group blob store combines concrete blob stores so that they act as a single blob store for repositories. Repositories  can only act singularly or as part of a group. A repository can either  use a concrete blob store directly or as a member of a single group, but not both.

 Group blob stores are a good choice if you meet the following criteria:

- You need to add more storage space via multiple devices.
- You need the ability to spread writes and reads across multiple blob stores.
- You need to mix both disk and cloud storage.

## Estimating Blob Store Storage Requirements

Blob stores contain two files for each binary component stored in Nexus Repository:

- The binary component (stored as a .bytes file thats size is the same as the component).
- A properties file that stores a small amount of metadata for disaster recovery purposes (<1KB).

The total blob store storage size is therefore approximately the total size of all of your components plus an allowance for the properties files  and the block size of your storage device.

On average, the allowance will be 1.5 * # of components * block size.

## High-Availiability Clustering (Legacy) Considerations

If you have a High Availability cluster, then you should also refer to [Configuring Storage](https://help.sonatype.com/repomanager3/planning-your-implementation/storage-guide/storage-planning#).

# Using Replicated S3 Blob Stores for Recovery or Testing

 

 

PRO

NEW IN 3.31.0

 

**Only available in Nexus Repository Pro. Interested in a free trial? [Start here](https://www.sonatype.com/products/repository-pro/trial).**

 

Nexus Repository only supports AWS S3 as documented in our [System Requirements Supported File Systems section](https://help.sonatype.com/repomanager3/product-information/system-requirements#SystemRequirements-FileSystems). Other implementations of the S3 protocol may or may not work, and are not officially supported.

Should you need to use a replica of a production S3 blob store for recovery or testing purposes, you will also need a copy of the Nexus Respository  database that corresponds to the blob store. This database will contain  references to the production blob store. Using the database copy  unmodified will result in unintended modifications to the production S3  blob store. For this reason, Nexus Repository provides a mechanism to  override specific blob store attributes via an environment variable (`NEXUS_BLOB_STORE_OVERRIDE`) used during Nexus Repository startup. Using this mechanism, you can override the S3 blob store bucket name attribute to point to the replica to avoid  unintended modification of the production blob store.

For example, suppose you have a production S3 blob store named `nxrm-blob-store` that is associated with an S3 bucket named `nxrm-bucket-prod`. You have set up replication of this bucket to another bucket named `nxrm-bucket-stage` for testing purposes. In the testing environment, you can restore a  backup or snapshot of the production Nexus Repository database and use  the following environment variable when starting Nexus Repository to  update the S3 blob store bucket name in the staging environment to point to `nxrm-bucket-stage` instead of `nxrm-bucket-prod`:

```
NEXUS_BLOB_STORE_OVERRIDE='{"nxrm-blob-store": {"s3": {"bucket": "nxrm-bucket-stage"}}}'
```

The `NEXUS_BLOB_STORE_OVERRIDE` environment variable is expected to contain a JSON representation of a  map for which the key is the name of the blob store you are modifying.  The value is another map with the same structure as the blob store  attributes in the Nexus Repository database. In the case of an S3 blob  store, the attributes map key is expected to be `"s3"` and the value associated with that key is a map of attributes that you wish to override (in our example, it would be "`bucket`").

Nexus Repository will only attempt blob store overrides where the blob store  name in the environment variable matches an existing blob store in the  Nexus Repository database. When there is a matching blob store name,  Nexus Repository will only make a modification when the attribute value  provided is different than the existing value in the Nexus Repository  database.

It is important to note that the blob store override  environment variable only changes blob store configuration in the Nexus  Repository database and does not modify the referenced underlying blob  store in any way. It is up to you to ensure that the new S3 bucket in  this case contains blob store files that correspond to the Nexus  Repository database being used (in this case, a replica of the  production S3 bucket). The blob store override environment variable will not do any sort of copying of information from the existing production  S3 bucket to the staging S3 bucket.

You can use `NEXUS_BLOB_STORE_OVERRIDE` to modified several blob stores:

```
NEXUS_BLOB_STORE_OVERRIDE='{"blob-store-1": {"s3": {...}}, "blob-store-2": {"s3": {...}}, "blob-store-3": {"s3": {...}}}'
```

You can also modify several attributes for each blob store:

```
NEXUS_BLOB_STORE_OVERRIDE='{"nxrm-blob-store": {"s3": {"bucket": "nxrm-bucket-stage", "region": "us-east-2"}}}'
```

The attributes available for override are any attributes that are defined  for the blob store configuration in the Nexus Repository database. For  S3 blob stores, the most common attributes are as follows: 

- `"bucket"`
- `"region"`
- `"prefix"`
- `"accessKeyId"`
- `"assumeRole"` 
- `"sessionToken"`

# Run Behind a Reverse Proxy

 

 

Nexus Repository Manager is a sophisticated server application with a  web-application user interface, answering HTTP requests using the  high-performance servlet container Eclipse Jetty. Organizations are  sometimes required to run applications like Nexus Repository Manager  behind a reverse proxy. Reasons may include:

- security and auditing concerns
- network administrator familiarity
- organizational policy
- disparate application consolidation
- virtual hosting
- exposing applications on restricted ports
- SSL termination
- SSO or SAML Integration

This section provides some general guidance on how to configure common  reverse proxy servers to work with Nexus Repository Manager. Always  consult your reverse proxy administrator to ensure you configuration is  secure. The default webapp context path for the repository manager user  interface is `/`. In the instance where the repository  manager needs to be proxied at a different base path you must change the default path by editing a property value. In [Base URL Creation](https://help.sonatype.com/repomanager3/nexus-repository-administration/capabilities/base-url-capability), follow the steps to change or update the Base URL if you want an alternate server name.

In the following examples, review the sections on changing the HTTP port  and context path to properly reverse-proxy the repository manager. Consult your reverse proxy product documentation for details: [Apache httpd](http://httpd.apache.org/) ( [mod_proxy](http://httpd.apache.org/docs/current/mod/mod_proxy.html) , [mod_ssl](http://httpd.apache.org/docs/current/mod/mod_ssl.html) ), [nginx](http://nginx.org/en/docs/) ( [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) , [ssl compatibility](http://nginx.org/en/docs/http/configuring_https_servers.html#compatibility) ). 

 

When setting up SSO and using a reverse proxy instead of Nexus Repository, you need to forward to the same context path on the reverse proxy and the Nexus Repository instance for SSO host headers to be accepted.

## Example: Reverse Proxy on Restricted Ports

 **Scenario**: You need to expose the repository manager on restricted port `80`. The repository manager should not be run with the root user. Instead run your reverse proxy on the restricted port `80` and the repository manager on the default port `8081`. End users will access the repository manager using the virtual host URL `http://www.example.com/` instead of `http://localhost:8081/`. Ensure your external hostname (`www.example.com`) routes to your reverse proxy server. This example uses the default content path (`/`).

### Apache httpd

```
ProxyRequests Off
ProxyPreserveHost On
  
<VirtualHost *:80>
  ServerName www.example.com
  ServerAdmin admin@example.com

  AllowEncodedSlashes NoDecode

  ProxyTimeout 300
  ProxyPass / http://localhost:8081/ nocanon
  ProxyPassReverse / http://localhost:8081/
  ErrorLog logs/www.example.com/error.log
  CustomLog logs/www.example.com/access.log common
</VirtualHost>
```

### nginx

```
http {
  
  proxy_send_timeout 120;
  proxy_read_timeout 300;
  proxy_buffering    off;
  proxy_request_buffering off;
  keepalive_timeout  5 5;
  tcp_nodelay        on;
  
  server {
    listen   *:80;
    server_name  www.example.com;
  
    # allow large uploads of files
    client_max_body_size 1G;
  
    # optimize downloading files larger than 1G
    #proxy_max_temp_file_size 2G;
  
    location / {
      # Use IPv4 upstream address instead of DNS name to avoid attempts by nginx to use IPv6 DNS lookup
      proxy_pass http://127.0.0.1:8081/;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
}
```

## Example: Reverse Proxy Virtual Host and Custom Context Path

**Scenario**: You need to expose the repository manager using a custom host name `repo.example.com` on a restricted port at a base path of `/nexus`. Ensure your external hostname (`repo.example.com`) routes to your reverse proxy server and edit the webapp path a slash at end (`/`).

### Apache httpd

```
ProxyRequests Off
ProxyPreserveHost On
  
<VirtualHost *:80>
  ServerName repo.example.com
  ServerAdmin admin@example.com

  AllowEncodedSlashes NoDecode

  ProxyTimeout 300
  ProxyPass /nexus http://localhost:8081/nexus nocanon
  ProxyPassReverse /nexus http://localhost:8081/nexus
  ErrorLog logs/repo.example.com/nexus/error.log
  CustomLog logs/repo.example.com/nexus/access.log common
</VirtualHost>
```

### nginx

```
http {
  
  proxy_send_timeout 120;
  proxy_read_timeout 300;
  proxy_buffering    off;
  proxy_request_buffering off;
  keepalive_timeout  5 5;
  tcp_nodelay        on;
  
  server {
    listen   *:80;
    server_name  repo.example.com;
  
    # allow large uploads of files
    client_max_body_size 1G;
  
    # optimize downloading files larger than 1G
    # proxy_max_temp_file_size 2G;
  
    location /nexus {
      # Use IPv4 upstream address instead of DNS name to avoid attempts by nginx to use IPv6 DNS lookup
      proxy_pass http://127.0.0.1:8081/nexus;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
)
```

## Example: Reverse Proxy SSL Termination at Base Path

 **Scenario:** Your organization has standardized a reverse proxy to handle SSL  certificates and termination. The reverse proxy virtual host will accept HTTPS requests on the standard port `443` and serve content from the repository manager running on the default non-restricted HTTP port `8081` transparently to end users. Ensure your external host name (`repo.example.com`) routes to your reverse proxy server and edit the webapp path to be slash (`/`). To test your configuration, review the steps to [generate a self-signed SSL certificate](https://support.sonatype.com/hc/en-us/articles/213465768-SSL-Certificate-Guide) for reverse proxy servers.

### Apache httpd

The example assumes that Apache httpd has been [configured to load](https://httpd.apache.org/docs/2.4/configuring.html#modules)` mod_ssl` and `mod_headers` modules.

```
Listen 443
  
ProxyRequests Off
ProxyPreserveHost On
  
<VirtualHost *:443>
  SSLEngine on
  
  SSLCertificateFile "example.pem"
  SSLCertificateKeyFile "example.key"
  
  AllowEncodedSlashes NoDecode

  ServerName repo.example.com
  ServerAdmin admin@example.com


  ProxyTimeout 300
  ProxyPass / http://localhost:8081/ nocanon
  ProxyPassReverse / http://localhost:8081/
  RequestHeader set X-Forwarded-Proto "https"
  
  ErrorLog logs/repo.example.com/nexus/error.log
  CustomLog logs/repo.example.com/nexus/access.log common
</VirtualHost>
```

### nginx

The example assumes that nginx has been compiled using the `--with-http_ssl_module` option.

```
http {
  
  proxy_send_timeout 120;
  proxy_read_timeout 300;
  proxy_buffering    off;
  proxy_request_buffering off;
  keepalive_timeout  5 5;
  tcp_nodelay        on;
  
  server {
    listen   *:443;
    server_name  repo.example.com;
  
    # allow large uploads of files
    client_max_body_size 1G;
  
    # optimize downloading files larger than 1G
    #proxy_max_temp_file_size 2G;
  
    ssl on;
    ssl_certificate      example.pem;
    ssl_certificate_key  example.key;
  
    location / {
      # Use IPv4 upstream address instead of DNS name to avoid attempts by nginx to use IPv6 DNS lookup
      proxy_pass http://127.0.0.1:8081/;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto "https";
    }
  }
}
```

## Apache httpd with npm Repositories

Npm [scoped packages](https://docs.npmjs.com/misc/scope) use encoded slash characters ("/") in their URL's. By default Apache  will not allow encoded slashes through. If you're using npm and have  Apache running in front of Nexus add the following to your configuration so that it will allow encoded slashes through:

```
AllowEncodedSlashes NoDecode
```

The ProxyPass directive will also need nocanon option:

```
ProxyPass / http://localhost:8081/ nocanon
```

Note that the [documentation](https://httpd.apache.org/docs/2.2/mod/mod_proxy.html#proxypass) for "nocanon" says "this keyword may affect the security of your  backend". Sonatype server products do not rely on reverse proxies to  filter out suspect URLs containing path info with encoded values, so it  is OK to use "noncanon" with Nexus Repository Manager.

Apache httpd 2.0.52 to 2.2.8

 

If you are running Apache httpd 2.0.52 to 2.2.8 and you choose to set:

```
AllowEncodedSlashes On
```

Then this will trigger a bug that incorrectly decodes encoded slashes when they should not be:

https://bz.apache.org/bugzilla/show_bug.cgi?id=35256

​        

# Securing Nexus Repository Manager

Below are a few suggestions for making your Nexus Repository instance more secure.

## Limit IPs that can be Reached from your Nexus Repository Host

Nexus Repository can be configured by an administrator to contact internal and external IPs for various reasons such as  retrieving certificates, creating proxy repositories, dispatching events to remote URLs and so on. You may limit the IPs that can be reached from the host machine running your Nexus Repository instance but note that doing so could block the main use case for some features. For example, webhooks give  administrators a way of integrating Nexus Repository with other systems  (e.g an auditing system, another Nexus Repository instance, or a  lightweight listener potentially on the same host), typically in the  same data center. Hence, limiting webhook destinations to, for example,  IPs external to your data center effectively blocks the main use case  for them.

##  Privileges and Service Account

- Only assign the least necessary privileges to Nexus Repository users.
- Create a dedicated operating system service account for running Nexus Repository - do not run as the root user. In addition, the service account must have read/write permissions to the `$install-dir` and sonatype-work directories and must be able to create a valid shell. Please see [here](https://help.sonatype.com/repomanager3/product-information/system-requirements#SystemRequirements-DedicatedOperatingSystemUserAccount) for detailed operating system service account recommendations.

## Containerization

Running Nexus Repository in a Docker container may reduce the impact of a successful attack. Without containerisation, if a malicious person successfully exploits a service and gains root access, they could do damage to other services running on the host. On the  other hand, containerising means a successful attack on that service is  restricted to the container running that service. The Nexus Repository 3 docker images can be found at: https://hub.docker.com/r/sonatype/nexus3/.

# Keeping Disk Usage Low

  Generally, we recommend using [Cleanup Policies](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/cleanup-policies) and the *Admin - Compact blob store* task to keep disk usage low. However, this page details several other items for when policies are not enough. 

 



 

## Tasks

If Cleanup Policies are not meeting your needs, you may need to use the existing tasks. See [the FAQ section of Cleanup Policies](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/cleanup-policies#CleanupPolicies-GeneralGuide(FAQ)) for more about what Cleanup Policies cover and what needs Tasks used instead.

Task Reminder

 

Like Cleanup, these tasks soft delete and the *Admin - Compact blob store* task is needed after to actually free your disk space.

## For More Complex Cleanup Scenarios

For scenarios the policies and tasks don't cover with their provided variables, we suggest using the [REST API](https://help.sonatype.com/repomanager3/integrations/rest-and-integration-api) to find and delete what you need via REST call.

For example, if you'd like to delete all components named `alpha`, you can perform the following curl to identify them:

```
curl -X GET "http://localhost:8081/service/rest/v1/search?name=alpha" -H "accept: application/json"
```

Depending on your results, you can then call individual deletes or design a  script to remove them all.  Example of what a delete curl might look  like:

```
curl -X DELETE "http://localhost:8081/service/rest/v1/components/bWF2ZW4tcmVsZWFzZXM6ODg0OTFjZDFkMTg1ZGQxMzgwYjA3YWQzNDAwOGVmNTc" -H "accept: application/json"
```

## Examining Blobstore Space Usage

If you would like more insight into how blobstore space is being consumed  to make better informed configuration decisions, you can run groovy  scripts either from the command line or from within NXRM using the *Execute Script* task. This [Knowledge Base article](https://support.sonatype.com/hc/en-us/articles/115009519847-Investigating-Blobstore-Space-Usage) provides samples to get you started.

## Totally Out of Space / Seeing Errors?

If you are currently out of disk space, there are a couple of other  Knowledge Base articles you can look at to free up space urgently and  get the system up and running:

[What to Do When the Database is Out of Disk Space](https://support.sonatype.com/hc/en-us/articles/360000052388)

[What to Do When the Blobstore is Out of Disk Space](https://support.sonatype.com/hc/en-us/articles/360000096228)

# Backup and Restore

For those using OrientDB or H2 databases, Nexus  Repository lets you use a scheduled task to aid with backing up your  repository manager.

Along with your backup procedure, you can  configure Nexus Repository to save the OrientDB or H2 databases that  store your component metadata and system configurations. 

You can  configure this task to export settings and metadata from the underlying  OrientDB or H2 databases. The scheduled task does the following:

- Stores the databases to a new location when configured
- Generates a snapshot of the databases for you to back up
- Suspends access to the database until the backup is complete
- Cancels any currently running scheduled tasks

This section shows you how to configure and execute the tasks as well as to  learn how to and recover the exported databases of your Nexus  Repository.

#### Topics in this section:

 

- [Configure and Run the Backup Task](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/configure-and-run-the-backup-task)
- [Prepare a Backup](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/prepare-a-backup)
- [Restore Exported Databases](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/restore-exported-databases)
- [Backup and Restore in Amazon Web Services](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/backup-and-restore-in-amazon-web-services)

# Configure and Run the Backup Task

 

 



There are two scheduled tasks that you can use for database backup depending on what database you are using (OrientDB or H2). 

 

PostgreSQL backups take place outside of Nexus Repository and are not covered in our documentation. See [PostgreSQL documentation](https://www.postgresql.org/docs/current/backup.html) for more information.



In either case, you will need to follow the steps in [Tasks](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-ConfiguringandExecutingTasks) to configure and run a new backup task.

See the sections below for your specific database for additional explanations of backup task-specific fields.

## Configuring the Backup Task for OrientDB

If you are using OrientDB, you will configure a new *[Admin - Export databases for backup](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Admin-Exportdatabasesforbackup)* task for database backup.

Beyond the standard fields described in [Tasks](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-ConfiguringandExecutingTasks), the form for this task includes a field called *Backup location*. In this field, enter the path to a directory where you want to store backup data.

  **![img](https://help.sonatype.com/repomanager3/files/5412144/10553055/1/1519860818875/Screen+Shot+2018-01-26+at+1.46.16+PM.png)**  

 **Figure: Admin - Export databases backup Task Form** 

When the task runs, it exports backup data to the path specified in the *Backup location* field. The directory you input will contain `.bak` files of the following databases:

- Component - All related data that make up components within the repository manager
- Configuration - General administrative configurations such as scheduled tasks and email server configuration
- Security - All user and access rights management content

All backup files are presented in the timestamp format based on the time the task was started.

## Configuring the Backup Task for H2 

PRO

NEW IN 3.31.0

If you are using H2, you will configure a new *[Admin - Backup H2 Database](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Admin-BackupH2Database)*   task for database backup.

Beyond the standard fields described in [Tasks](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-ConfiguringandExecutingTasks), the form for this task includes a field called *Location*. In this field, enter the path to a directory where you want to store backup data.

![img](https://help.sonatype.com/repomanager3/files/5412144/78580751/1/1625581455805/Task.png) **Figure: Admin - Backup H2 Database Form**



When the task runs, it exports backup data to the path specified in the *Location* field. The directory you input will contain a zip file that will contain the H2 database directory (nexus.mv.db).

# Prepare a Backup

Nexus Repository stores data in [blob stores](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management#RepositoryManagement-BlobStores) and keeps some metadata and configuration information separately in databases. You must back up the blob stores and metadata databases together. Your backup strategy should involve backing up both your databases and blob stores together to a new location in order to keep the data intact.

Complete the steps below to perform a backup:

## Blob Store Backup

You must back up the filesystem or object store containing the blobs separately from Nexus Repository.

- For 

  File

   blob stores, back up the 

  directory

   storing the blobs. 

  - For a typical configuration, this will be `$data-dir/blobs`. 

- For *S3* blob stores, you can use bucket versioning as an alternative to  backups. You can also mirror the bucket to another S3 bucket instead.



 

For cloud-based storage providers (S3, Azure, etc.), refer to their documentation about storage backup options.



## Node ID Backup

Each Nexus Repository instance is associated with a distinct ID. You must  back up this ID so that blob storage metrics (the size and count of  blobs on disk) and Nexus Firewall reports will function in the event of a restore / moving Nexus Repository from one server to another. The files to back up to preserve the node ID are located in the following  location (also see [Directories](https://help.sonatype.com/repomanager3/installation-and-upgrades/directories)):

```
$data-dir/keystores/node/
```

To use this backup, place these files in the same location before starting Nexus Repository.

## Database Backup

The databases that you export have pointers to blob stores that contain components and assets potentially across multiple repositories. If you don’t back them up together, the component metadata can point to  non-existent blob stores. So, your backup strategy should involve backing up both your databases and blob stores together to a new location in order to keep the data intact.

Here’s a common scenario for backing up custom configurations in tandem with the database export task:

1. Configure the appropriate backup task to export databases:
   1. Use the *[Admin - Export databases for backup](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Admin-BackupH2Database)* task for OrientDB databases 
   2. Use the *[Admin - Backup H2 Database](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Admin-Exportdatabasesforbackup)* task for H2 databases PRO
2. Run the task to export the databases to the configured folder.
3. Back up custom configurations in your installation and data directories at the same time you run the export task.
4. Back up all blob stores.
5. Store all backed up configurations and exported data together.



 

Write access to databases is temporarily suspended until a backup is complete. It’s advised to schedule backup tasks during off-hours.

# Restore Exported Databases

You can restore exported database files to the state when you ran the scheduled backup task by taking the following steps:

- Access the location specified in the *Backup location* field from the *Admin - Export databases for backup* task (OrientDB) or *Admin - Backup H2 Database* task (H2) where the databases were exported
- Remove all of the database directories in order to restore them to the previous state

The restoration should include all of the databases exported during the  backup process. Do not restore the databases individually, and only use  files from a single backup (i.e., those with the same timestamp).

Start the database restoration with these steps:

1. Stop Nexus Repository

2. Remove the following directories from 

   ```
   $data-dir/db
   ```

   - `component`
   - `config`
   - `security`

3. Go to the location where you stored the exported databases

4. Copy the corresponding `.bak` files to `$data-dir/restore-from-backup` for restoration (**Note**: For version 3.10.0 or earlier use `$data-dir/backup` as the restore location)

5. Restore blob store backup corresponding to the DB backup

6. Restart Nexus Repository

7. Verify Nexus Repository is running correctly

8. Remove `.bak` files from `restore-from-backup` directory

You can verify the restoration is complete by viewing the fully-restored databases previously removed from `$data-dir/nexus3/db`.

 

As noted above, when the component database is restored, the corresponding blob stores containing components must also be restored. Not doing this will cause syncronization issues between the blobstore and the  database.

 

If the blob store and database backups were not taken at exactly the same  moment they may be out of sync following a restore. To fix this,  schedule and run a *Repair - Reconcile component database from blob store* [task](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks) under *System* → *Tasks* in the *Adminitration* UI.

# Backup and Restore in Amazon Web Services

 

 

This section covers recovery from backup in Amazon Web Services (AWS). While the details here are specific to AWS, a similarly effective  deployment model is likely possible with other cloud vendors. As a best  practice, you should also examine current AWS documentation before  implementing your own deployment to validate that AWS services have not  changed in a way that will impact your needs and to estimate deployment  costs. 

## Planning Your Backup Strategy

When determining your backup strategy, consider the following:

- Your organization’s data retention policy

- Your budget

- The scenarios against which you are trying to protect, such as the following:

- - AWS outages
  - Data corruption
  - Inadvertent large-scale deletes
  - Deployment errors 
  - Cyber attacks 

You will need to account for these areas of your Nexus Repository deployment when creating a backup strategy:

- [Database Backups](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/backup-and-restore-in-amazon-web-services#BackupandRestoreinAmazonWebServices-DBBackup)
- [Blob Store Backups](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/backup-and-restore-in-amazon-web-services#BackupandRestoreinAmazonWebServices-Blob)
- [File System Backups](https://help.sonatype.com/repomanager3/planning-your-implementation/backup-and-restore/backup-and-restore-in-amazon-web-services#BackupandRestoreinAmazonWebServices-FileSystemBackups)

While backed up independently, the database does include references to  objects in the blob store(s), so you should ensure that the backups of  both occur around the same time to minimize the drift between the two.

As you review the backup strategies in the following sections, there are two important terms to remember:

- **Recovery Point Objective (RPO)** - the amount of downtime and resultant data loss that is acceptable to lose if a restore becomes necessary
- **Recovery Time Objective (RTO)** - the length of time required to restore the service 

## Database Backups  

 

The backup method described here requires an external database.  If using H2 or Orient, you should take down the instance to do the snapshot to avoid catching the database in an inconsistent state.

You can configure Amazon’s Relational Database Service (RDS) to  automatically snapshot RDS instances as frequently as every 5 minutes;  you can also create a manual snapshot on demand. It is important to  configure the retention policy for these snapshots to meet your data  retention requirements.

RDS provides a mechanism for  restoring to a specific point in time. Depending upon the nature of the  incident, you may still be able to recover Nexus Repository content (not configuration) added after the incident using the *[Repair - reconcile component database from blob store](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Repair-Reconcilecomponentdatabasefromblobstore)* task.

 

If you have a support contract, contact Sonatype support for assistance **before** using any repair task.

You can also configure RDS to automatically replicate backup snapshots to a distinct region. This allows you to restore Nexus Repository to a  secondary AWS region in the event of a complete failure of the deployed  region. When using this replication, you must also replicate the blob  storage to the same region as the RDS backup.

Snapshots of an RDS instance are associated with that instance. In some  scenarios, the snapshots may be deleted automatically when an RDS  instance is removed. To avoid this, you should periodically export  database snapshot data to S3. These exported snapshots are also  important should access to the database be maliciously compromised.

## Blob Store Backups  

Note that you can't use all file systems for all purposes; consult the [System Requirements](https://help.sonatype.com/repomanager3/product-information/system-requirements) for more information.

Amazon S3’s standard storage classes largely provide redundancy across at  least three availability zones (AZs). When used for Nexus Repository’s  blob storage in conjunction with an available RDS database, this allows  an RTO on the order of minutes from detecting an AWS AZ outage.

Amazon’s S3 service also supports cross-region replication. Their documentation  states that replication typically occurs within 15 minutes;  however, objects may take longer in some cases. This means you can  expect an average RTO of 15 minutes or less for blobs and should allow  eventual recovery of all blobs.

## File System Backups  

If using EBS, point-in-time snapshots can help provide multi-AZ redundancy. While EBS only uses one AZ, it stores snapshots in multiple AZs. In the event of an AZ failure, you could use EBS snapshots to provision a new EBS  volume in another AZ. However, this is not automatic. You will need to  implement a process such as specifiying the EBS snapshot ID in EC2  launch configuration. See [the AWS documentation](https://aws.amazon.com/ebs/features/#Amazon_EBS_Snapshots) for more information. Amazon EBS also offers a higher durability volume type (i.e., io2), that is designed to provide 99.999% durability with an annual failure  rate (AFR) of 0.001%, where failure refers to a complete or partial loss of the volume. 

Amazon EFS Standard is inherently designed to protect against losing an entire AZ. 

Nexus Repository also stores Elasticsearch indexes on the local disk.  Snapshots of the file system do not guarantee a consistent index, but  you can rebuild this while Nexus Repository is online.

## Expected Results

The table below outlines various recovery methods and the RPO and RTO you  can expect to achieve given your selected database, blob storage, and  file system. The expected RTO does not include the time required to rebuild the Elasticsearch index. Primary Nexus Repository services are expected to be functional while  this occurs; even large instances typically rebuild the index in less  than 1 hour.

| **Recovery Method Used** | **Expected**                   |                 |                |         |
| ------------------------ | ------------------------------ | --------------- | -------------- | ------- |
| **Database**             | **Blob Storage**               | **File System** | **RPO**        | **RTO** |
| AZ Failover              | AZ Redundancy                  | Snapshot        | No loss        | Minutes |
| Point of Time Snapshot   | Same Region Replication (SRR)  | Snapshot        | 5-15 minutes * | Minutes |
| Cross Region Snapshot    | Cross Region Replication (CRR) | Snapshot        | 5-15 minutes * | Minutes |



\* Use of the *[Repair - Reconcile component database from blob store](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks#Tasks-Repair-Reconcilecomponentdatabasefromblobstore)* task within Nexus Repository may further reduce the RPO with some delay after recovery.

​        

# Quick Start Guide - Proxying Maven and NPM

If you're new to repository management with Nexus  Repository Manager 3, use this guide to get familiar with configuring  the application as a dedicated proxy server for Maven and npm builds. To reach that goal, follow each section to:

- Install Nexus Repository Manager 3
- Run the repository manager locally
- Proxy a basic Maven and npm build

When you complete the steps, the components will be cached locally to your  repository manager. After meeting the requirements to run the repository manager, it should take approximately 15 minutes to proxy Maven and npm with the code snippets below.

##  Requirements 

Before you can set up the proxy server for Maven and npm, you'll need to  install and configure the following external tools for the repository  manager:

- Java 8 Development Kit (JDK) - Nexus Repository Manager is a Java server application. As explained in [System Requirements](https://help.sonatype.com/repomanager3/installation/system-requirements#SystemRequirements-Java), we strongly recommend using [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) to ensure effective runtime of Nexus Repository Manager 3.
- [Apache Maven](https://maven.apache.org/download.cgi) - When downloaded, Nexus Repository Manager 3 includes access to open source components from the [Central Repository](https://search.maven.org/) by default. These components are defined by both a `settings.xml` file and a Project Object Model file (POM), which maintains information on projects and dependencies.
- [npm](https://www.npmjs.com/get-npm) - A popular format supported by the repository manager. Unlike Maven,  Nexus Repository Manager 3 doesn’t currently ship with a default npm  repository configuration. These components are configured with an `.npmrc` file.

## Part 1 - Installing and Starting Nexus Repository Manager 3

1. Create an [installation directory](https://support.sonatype.com/hc/en-us/articles/231742807#InstallDir) in your desired location.
2. [Download the most recent repository manager](https://help.sonatype.com/repomanager3/product-information/download) for your operating system.
3. If the file is downloaded to a location outside the installation directory, move it there.
4. Unpack the `.tar.gz` or `.zip` file in its new location. Both an application (i.e. `nexus-<version>`) and data directory (i.e. `../sonatype-work/nexus3`) are created after extraction.
5. Go to the application directory which contains the repository manager file you need to start up.
6. In the application directory, run the startup script launching the repository manager:
   - Linux or Mac: `./bin/nexus run`
   - Windows: `bin/nexus.exe /run`
7. Wait until the log shows the message “Started Sonatype Nexus.”
8. Open your browser and type http://localhost:8081/ in your URL field.
9. From the user interface click **Sign In**, which generates a modal to enter your credentials.
10. Navigate to `../sonatype-work/nexus3/` in your terminal.
11. Locate the `admin.password` file.
12. Copy the string from the file to the password field, and sign in.
13. Complete the step-by-step setup modal to update your password and set **Anonymous Access** defaults upon logging in.

## Part 2 - Proxying Maven and npm Components

When you proxy components the repository manager acts as a local intermediary server for any download requests going to remote repositories / registries. After logging in, these next steps will show you how to configure then test your configuration with local builds for a Maven and npm project.

When you proxy components the repository manager acts as a local  intermediary server for any download requests going to remote  repositories / registries. After logging in, these next steps will show  you how to configure then test your configuration with local builds for a Maven and npm project.

### Maven

> **NOTE: If you have an existing Maven configuration file (`settings.xml`) that you want to retain, back it up before doing any modifications.**

1. In your Maven file directory, open your `settings.xml` and change the contents of the snippet below. You can find this file in `.m2, e.g ~/.m2/settings.xml`.

   ```
   <settings>
   <mirrors>
     <mirror>
     <!--This sends everything else to /public -->
     <id>nexus</id>
     <mirrorOf>*</mirrorOf>
     <url>http://localhost:8081/repository/maven-public/</url>
     </mirror>
   </mirrors>
   <profiles>
     <profile>
     <id>nexus</id>
     <!--Enable snapshots for the built in central repo to direct -->
     <!--all requests to nexus via the mirror -->
     <repositories>
         <repository>
         <id>central</id>
         <url>http://central</url>
         <releases><enabled>true</enabled></releases>
         <snapshots><enabled>true</enabled></snapshots>
         </repository>
     </repositories>
     <pluginRepositories>
         <pluginRepository>
         <id>central</id>
         <url>http://central</url>
         <releases><enabled>true</enabled></releases>
         <snapshots><enabled>true</enabled></snapshots>
         </pluginRepository>
     </pluginRepositories>
     </profile>
   </profiles>
   <activeProfiles>
     <!--make the profile active all the time -->
     <activeProfile>nexus</activeProfile>
   </activeProfiles>
   </settings>
   ```

   ```xml
   
   ```

2. Go to the repository manager user interface.

3. Click **Administration** in the left navigational menu, then click **Repositories**.

4. Click **Create repository** and choose the **maven2 (proxy)** recipe from the list.

5. Add the following text in the required fields:

   - Name: `maven-proxy`
   - Remote storage URL: `https://repo1.maven.org/maven2`

6. Click **Create repository** to complete the form.

7. From the command-line interface, create the POM file (`pom.xml`) with the values below:

   ```
   <project>
     <modelVersion>4.0.0</modelVersion>
     <groupId>com.example</groupId>
     <artifactId>nexus-proxy</artifactId>
     <version>1.0-SNAPSHOT</version>
     <dependencies>
       <dependency>
         <groupId>junit</groupId>
         <artifactId>junit</artifactId>
         <version>4.10</version>
       </dependency>
     </dependencies>
   </project>
   ```

   ```xml
   
   ```

8. Run the Maven build with the command `mvn package`.

> **NOTE: If you to want to view the details of your Maven test build, skip to  Part 3. However, if you want to test an npm build, continue to the next  section in this part.**

### npm

> **NOTE: If you have an existing npm configuration file (.npmrc) that you want  to retain, back it up before doing any modifications.**

1. Click **Administration** in the left navigational menu, then click **Repositories**.

2. Click **Create repository** and choose **npm (proxy)** from the list.

3. Add the following text in the required fields:

   - Name: `npm-proxy`
   - Remote Store URL: `https://registry.npmjs.org/`

4. From the command-line interface run `npm config set registry http://localhost:8081/repository/npm-proxy`.

5. From the command-line interface, create a `package.json` with the values below:

   ```
   {
   "name": "sample_project1",
   "version": "0.0.1",
   "description": "Test Project 1",
   "dependencies" : {
     "commonjs" : "0.0.1"
   }
   }
   ```

   ```
   
   ```

6. Run the npm build with the command `npm install`.

## Part 3 - Viewing Proxied Components

After your Maven and npm projects are successfully built, follow these steps to view the cached components:

1. Click **Browse** from the main toolbar.
2. Click **Components**.
3. Of your components, choose **maven-proxy** or **npm-proxy**. You’ll see the test component you proxied for the respective format during the previous build steps.
4. Click on a component name to review its details.
5. The *Components* screen is a sub-section to the Browse interface. In order to view other components, click **Components** directly from the current screen and select another repository name from step 3 in this part.



 Staging Concepts

## Overview

Staging is a simple but powerful feature in Nexus Repository that lets you move artifacts from one repository to another with your CI/CD tools. You can use this to build workflows with quality checks so artifacts are never  used before they’re ready. Staging also connects with other features  like Cleanup, helping you keep your build pipelines lean and light on  storage space. Starting staging after having already integrated with  build pipelines may lead to a fair amount of rework. This guide will  review the concept of staging, how to set up a basic staging workflow,  and the steps to migrate legacy environments.

Here are some quick benefits to staging:

- Repository endpoints at each stage in the pipeline
- Artifacts are not copied or duplicated
- Everything as a release candidate
- Promotion workflow is driven by CI
- Cleanup is automated based on stage policy

## Why Staging?

The concepts behind staging come from requirements for modern CI/CD  pipelines which are not managed effectively with just a single  repository. A few common requirements are:

- Create a release candidate to test or discard before being promoted
- Keep build metadata for release artifacts
- Avoid dependencies on non-production artifacts
- Clean up fast based on artifact lifecycle

In Nexus Repository Manager, artifacts in a repository are not related to  where the artifact is located on a disk. When a file is uploaded, it is  stored in a blobstore and the repository path is included as metadata  stored in a database. At build time, artifacts may also be tagged with  additional metadata needed by the CI pipeline such as build and  environment details. These tags are used to group the artifacts needed  for a release and promote them through the release process. This  workflow gives build administrators complete control over the artifact’s lifecycle from an automated pipeline.

### Artifact Lifecycle

Another way to think about staging is the lifecycle of the artifacts your  organization produces. In this context, an artifact is one of the  tangible by-products produced during software development. Artifacts  commonly go through a set of lifecycle phases, or ‘stages’, where they  are promoted from one stage to the next as they pass automated quality  checks. A core DevSecOps principle is to fail fast. If a release  candidate fails checks, they are quickly dropped to not take up time and space in the workflow. Anything left around too long will be removed by regular cleanup policies.

Production environments need to be  protected from artifacts that have not passed the required quality  checks. The risk to organizations is too great. Stages make it easier to control access to artifacts through the pipeline. Here are the stages  commonly found in use.

1. Development > build first stores artifact in a hosted repository
2. Testing > release candidates are promoted for quality testing
3. Production > artifacts made available to production environments
4. End of Life > artifacts are deleted or archived to match retention policies

### Staging Environments

The NXRM best practice in staging is to funnel access through group  repositories aligned to lifecycle stages. This gives administrators  control over the mix of repositories, and in turn artifacts, available  in a given stage. This mix can later be edited without having to change  the access endpoints used by the pipeline. Even with one repository in a group, this step will make the management of environments easier in the long term.

Deploying to a repository, tagging of release  candidates, and the promotion of artifacts should happen as a part of an automated CI/CD pipeline. Any dependence on a manual workflow may lead  to errors and does not scale well. This is why the staging and tagging  functions are done through the platform plugins and API calls. The  workflow can be simulated through NXRM’s built-in [swagger interface](https://help.sonatype.com/repomanager3/rest-and-integration-api) to test out the calls mentioned below.

### Planning for Cleanup

Planning for cleanup is a Nexus administrator’s top priority. The number of  artifacts moving into the repository will need to be matched by the  artifacts being cleaned. This is critical to keeping server costs  manageable and avoiding running out of space. Staging environments are  an effective means to clean up the repository.

Aligning cleanup policies with the artifact’s lifecycle makes more sense when selecting by age and last downloaded. Review the [Cleanup Guide](https://help.sonatype.com/repomanager3/repository-management/cleanup-policies) for suggestions on configuring this effectively for different stages and formats.

### Format-based vs Team-based Repositories

When designing the initial layout of repositories in NXRM3 there are 2 common models used.

| Models      | format-based                                                 | team-based                                                   |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Description | repository made for each language format                     | repository made for each team or line of business            |
| Example     | MavennpmNuGetPyPI                                            | team-ateam-b                                                 |
| Traits      | enforced naming convention for team name-spaceuse content selectors for access enforcementsimple staging and cleanup workflowscales for large organizationssupports inner-source components | easy to set up and manage accessclear separation between business unitsstaging and cleanup per teamcan lead to repository sprawl |
| Features    | easier to set up and deploy staging because only a single set of staging environments are needed per format | trying to use a single staging environment can be very difficult to manage many team repositoriesteam staging environments will result in a large number of repositories/groups to manage |
|             | one size fits all model may not work with very different teams with different release cadence and requirements | teams can have their pipeline customized to best fit their needs |
|             | creating meaningful unique tags may pose a challenge to avoid overlapping with other teams | operations are repository-specific resulting in fewer issues with overlapping tagscleaning up tags may affect other teams |
|             | cleanup policies are time-basedteams with different release cadences may have different cleanup requirements | teams can have their cleanup match their release cadence     |


Generally, the best practice is to standardize on the format-based model however  there are very good reasons to leverage the team-based model. This is  especially true when the number of teams will not grow over time and  their pipelines will not overlap. For some organizations, they may wish  to leverage both models where most development teams share the same  pipeline and a limited few keep their own. With either model, the  deployment of the staging environments will be a similar process. They  should take careful planning for repository naming to make managing them easier in the long run.

## Starting with Staging

Staging in NXRM3 requires a few basic steps to implement.

1. Set up the staging environment using group repositories and separate hosted repositories for each stage.
   1. Map out the user access requirements for each stage.
   2. It may be easier to add additional stages once the basic workflow is implemented.
2. Use the REST API endpoints to move artifacts from one hosted repository to another.
   1. Optionally, tagging can be used to label artifacts with the release candidate identifier.
   2. These tags will be used as the target in the move REST call.
3. Apply cleanup policies to each stage of the workflow.

### Repository Configuration

Staging is intended to fit into an organization’s existing workflow and should  not require a complex setup. To start, add group repositories with a  corresponding hosted repository for each stage. Here is a simple  example.

| Environment        | Development                        | Testing             | Production          |
| ------------------ | ---------------------------------- | ------------------- | ------------------- |
| group (read)       | maven-dev                          | maven-uat           | maven-prod          |
| stage (write/move) | maven-dev-hosted                   | maven-uat-hosted    | maven-prod-hosted   |
| proxy              | maven-central-proxy                | maven-central-proxy | maven-central-proxy |
| read-only          | maven-uat-hosted maven-prod-hosted | maven-prod-hosted   | ---                 |


In this example, there are three stages however this could also be done with just two; dev and prod.

- Each stage is made of (1) a group repository and (1) hosted repository for that stage.
- A proxy to maven central can be shared by all stages where needed.
- The hosted repositories of later stages may be added to the previous groups.
  - In development, this is for build-tools to determine the ‘latest’ versions of an artifact available by having access to all the available  artifacts under the single group repository.
  - It may also be necessary to have the production artifacts available during the testing stage if there are cross dependencies.
- Everything required for a release candidate is promoted to testing and production together.

### Additional Tips

- Establish a normalized, meaningful naming convention for your groups and stages.  This makes managing the process easier in the long run. This is  especially true if using team-based, or mixed, repositories. This will  also reduce the chance of errors configuring the pipeline.
- Keep  the stages on the same blobstore if possible. So long as the  repositories are on the same blobstore, the move action is only an  update to the metadata in the database. If different blob stores are  used, then a copy / soft delete action is needed. This will cause  additional server load and increase the disk space used.
- [npm](https://help.sonatype.com/repomanager3/formats/npm-registry#npmRegistry-PublishingnpmPackages) and [docker](https://help.sonatype.com/repomanager3/formats/docker-registry/pushing-images) formats allow for deploying to group repositories. This makes configuring staging much easier for these formats.

### Simple Workflow:

1. Build systems use the [maven-dev] group for pulling components for the build.
2. Artifacts are deployed to [maven-dev-hosted] and optionally tagged with the metadata for the release candidate.
3. Build artifacts are promoted from [maven-dev-hosted] to [maven-uat-hosted] using the rest API move command.
4. Testing uses the artifacts from the [maven-uat] group. Depending on the job they may also need artifacts from releases to test.
5. Artifacts are promoted from [maven-uat-hosted] to [maven-prod-hosted] using the API.
   Production artifacts are pulled from the [maven-prod] group.

### Using the API

The staging API uses a simple POST to move artifacts from a source repository to a destination repository.

```
POST service/rest/v1/staging/move/{repository}
```

This post uses the same structure to search for components as the Search  API. Below is the endpoint with a simple search for an artifact in the  [maven-dev-hosted] repository which we will move to the  [maven-uat-hosted] repository.

```
POST service/rest/v1/staging/move/maven-uat-hosted?repository=maven-dev-hosted&group=org.osgi&name=org.osgi.core&version=4.3.1
```

The move command can be made against any number of artifacts that match the search criteria. It can be further simplified using a tag that is  associated with the artifacts of the release candidate.

```
POST service/rest/v1/staging/move/maven-uat-hosted?repository=maven-dev-hosted&tag=maven-build-100
```

## Tagging Simplified

Staging is used to promote the artifacts associated with a release candidate  from one environment to the next. The Tagging feature is grouped with  staging as it makes the process easier as seen in the above example. It  is important to note that using tags to promote is not required to do  staging. We do recommend adopting it since Tagging is done primarily  through the rest APIs so that it can be automatically added during the  build process. Tags can be searched through the UI however the only way  to manage tags is through API calls.

### Tagging Workflow

The only pieces required for tagging are creating your tag “name” as a  unique identifier and assigning artifacts to the tag. We recommend using a name that is meaningful and unique but for performance reasons, not  too long. Aligning identifiers with ids used in the release process is  ideal. In this example, the “attributes” are optional and can contain  any JSON data that would be meaningful to associate with the release  candidate.

```
curl -u admin:admin123 -X POST -H 'Content-Type: application/json' \
'http://localhost:8081/service/rest/v1/tags' \
-d '{"name": "org.osgi.core_4.3.1","attributes": {"built-by": "jenkins"}}'
```

Associating artifacts to a tag is similar to the search API, where any artifacts  identified with the search will be tagged. It is usually better to  associate the tag when uploading the artifacts to the repository. This  can be done using API or with any of the CI tooling used to upload.

See [tagging documentation](https://help.sonatype.com/repomanager3/tagging) for details.

```
POST /service/rest/v1/tags/associate/{tagName}
```

## Legacy Conversions

The primary challenge for existing users is that they may have to  rearchitect actively used repositories to mature to a staging model.  Often a single repository will be used for both dev and production or  the pipeline is using a hosted repository rather than a group  repository. In these cases, the simplicity of both the tagging and  staging features allows for adoption to be done in stages without too  much disruption.

This example assumes a single repository (legacy) is actively used for dev and production artifacts.

1. Setup group repositories (dev, prod) and add the existing hosted repositories.
   - The most time-consuming part here is switching to use these group repositories.
2. Create hosted repositories for dev and prod and add them to groups.
   - When planning to use the prod group, add the legacy repo to the prod group so the artifacts are available from this group.
3. Coordinate with pipeline teams to switch to using the new group repositories.
   - Allowing anonymous access to pipeline repositories is a security risk and is not recommended. Set up user access controls if not already in place.
   - Implement tagging even if it is not being used yet.
   - Adding the legacy repo to each of the new groups will ensure that any needed artifacts are still available.
   - This would be a good opportunity to test the staging workflow.
4. Move production artifacts from legacy to the prod hosted repository.
   - Moving artifacts will not change the availability of the artifacts at this point.
   - Search and move artifacts using the staging APIs. General searches can move many artifacts at once.
   - Generic tags, such as ‘prod’, could also be used effectively as well.
   - Note that these endpoints are limited to 10K artifacts at a time. The  operation may need to be carried out multiple times until all artifacts  have been moved.
5. When builds teams are all leveraging the staging workflow, repository groups can be cleaned up to match our staging model.

## Additional Resources

Staging does not need to be overly complicated nor take a long time to  implement. There is no reason to not build a staging environment from  the start. The key reason organizations often do not is due to the  planning and decision-making involved to do it effectively. The Sonatype Customer Success team can help with this process and set up the  discussions needed to be effective.

- [Staging Documentation](https://help.sonatype.com/repomanager3/staging)
- [Tagging Documentation](https://help.sonatype.com/repomanager3/tagging)
- [Search API](https://help.sonatype.com/repomanager3/rest-and-integration-api/search-api)
- [Cleanup Policies](https://help.sonatype.com/repomanager3/repository-management/cleanup-policies)
- [Staging Blog](https://blog.sonatype.com/staging-in-nexus-repository-3.11)

​       

# Nexus Repository Administration

This section contains everything you need to know about Nexus Repository administration, including the following:

- Authentication options such as [LDAP](https://help.sonatype.com/repomanager3/nexus-repository-administration/user-authentication/ldap) and [SAML](https://help.sonatype.com/repomanager3/nexus-repository-administration/user-authentication/saml)
- Managing [role-based access control](https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control)
- Helpful Nexus Repository Pro features like [staging](https://help.sonatype.com/repomanager3/nexus-repository-administration/staging) and [tagging](https://help.sonatype.com/repomanager3/nexus-repository-administration/tagging)
- How to manage [Nexus Repository capabilities](https://help.sonatype.com/repomanager3/nexus-repository-administration/capabilities)

These features and those outlined below are accessible only to authorized  users. The default user for accessing these features has the username  admin; the password is configured as part of [initial setup](https://help.sonatype.com/repomanager3/installation-and-upgrades/post-install-checklist). More fine-grained access can be configured as detailed in [Access Control](https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control).

------

Read about the above topics and much more in this section:

 

- [Administration Menu](https://help.sonatype.com/repomanager3/nexus-repository-administration/administration-menu)
- [Repository Management](https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management)
- [Formats](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats)
- [Staging](https://help.sonatype.com/repomanager3/nexus-repository-administration/staging)
- [Tagging](https://help.sonatype.com/repomanager3/nexus-repository-administration/tagging)
- [Maven and Jenkins Plugins](https://help.sonatype.com/repomanager3/nexus-repository-administration/maven-and-jenkins-plugins)
- [Tasks](https://help.sonatype.com/repomanager3/nexus-repository-administration/tasks)
- [Access Control](https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control)
- [User Authentication](https://help.sonatype.com/repomanager3/nexus-repository-administration/user-authentication)
- [Capabilities](https://help.sonatype.com/repomanager3/nexus-repository-administration/capabilities)
- [Nodes](https://help.sonatype.com/repomanager3/nexus-repository-administration/nodes)
- [Configuring SSL](https://help.sonatype.com/repomanager3/nexus-repository-administration/configuring-ssl)
- [HTTP and HTTPS Request and Proxy Settings](https://help.sonatype.com/repomanager3/nexus-repository-administration/http-and-https-request-and-proxy-settings)
- [Email Server Configuration](https://help.sonatype.com/repomanager3/nexus-repository-administration/email-server-configuration)
- [Retry Limit Configuration](https://help.sonatype.com/repomanager3/nexus-repository-administration/retry-limit-configuration)
- [Auditing](https://help.sonatype.com/repomanager3/nexus-repository-administration/auditing)
- [Installing and Updating Licenses](https://help.sonatype.com/repomanager3/nexus-repository-administration/installing-and-updating-licenses)
- [Support Features](https://help.sonatype.com/repomanager3/nexus-repository-administration/support-features)

# Administration Menu

The *Administration* menu, located on the left panel, contains the following sections:

**Repository**

The *Repository* section allows you to manage all Repositories and related configurations such as Routing and Targets.

**IQ Server**

The *IQ Server* item (visible to users with *nx-all* or *nx-settings* [privileges](https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control/privileges)) allows you to configure the connection of Nexus Repository to Nexus IQ Server. Further documentation is available in the [Nexus IQ Server documentation](https://help.sonatype.com/iqserver).

 

If you desire to utilize Nexus Firewall to quarantine and block  unacceptable components that may harm your repository manager, review  the [quick start guide](https://help.sonatype.com/display/NXIQ/Nexus+Firewall+Quick+Start).

**Security**

This section provides access to all the configuration features related to authentication and authorization of users including *Privileges*, *Roles*, *Users*, but also *LDAP*, *Atlassian Crowd* (Pro only), *SSL Certificates* and *User Token* (Pro only).

**Support**

Access a number of features that allow you to administer and monitor your repository manager successfully like *Logging* and *System Information*.

**System**

The general configuration for getting started and running the repository manager with e.g. *HTTP* or *Email Server* settings but also *Capabilities* and *Tasks* to run regularly and other configurations.