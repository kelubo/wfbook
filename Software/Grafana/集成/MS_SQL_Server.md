# MS SQL Server

> You can use Grafana Cloud to avoid installing, maintaining, and scaling your own instance of Grafana. [Create a free account](https://grafana.com/auth/sign-up/create-user?pg=docs-grafana-latest-getting-started-get-started-grafana-ms-sql-server) to get started, which includes free forever access to 10k metrics, 50GB logs, 50GB traces, 500VUh k6 testing & more.
> 您可以使用 Grafana Cloud 来避免安装、维护和扩展您自己的 Grafana 实例。[创建一个免费账户](https://grafana.com/auth/sign-up/create-user?pg=docs-grafana-latest-getting-started-get-started-grafana-ms-sql-server)以开始使用，其中包括永久免费访问10k指标、50GB日志、50GB跟踪、500VUh k6测试等。

Microsoft SQL Server is a popular relational database management system that is  widely used in development and production environments. This topic walks you through the steps to create a series of dashboards in Grafana to  display metrics from a MS SQL Server database.
Microsoft SQL Server 是一种流行的关系数据库管理系统，广泛用于开发和生产环境。本主题将指导您完成在 Grafana 中创建一系列控制面板以显示 MS SQL Server 数据库中的量度的步骤。

#### Download MS SQL Server 下载 MS SQL Server

MS SQL Server can be installed on Windows or Linux operating systems and also on Docker containers. Refer to the [MS SQL Server downloads page](https://www.microsoft.com/en-us/sql-server/sql-server-downloads), for a complete list of all available options.
MS SQL Server 可以安装在 Windows 或 Linux 操作系统上，也可以安装在 Docker 容器上。请参阅 [MS SQL Server 下载页面](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)，以获取所有可用选项的完整列表。

#### Install MS SQL Server 安装 MS SQL Server

You can install MS SQL Server on the host running Grafana or on a remote server. To install the software from the [downloads page](https://www.microsoft.com/en-us/sql-server/sql-server-downloads), follow their setup prompts.
您可以在运行 Grafana 的主机上或远程服务器上安装 MS SQL Server。要从[下载页面](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)安装软件，请按照其设置提示进行操作。

If you are on a Windows host but want to use Grafana and MS SQL data source on a Linux environment, refer to the [WSL to set up your Grafana development environment](https://grafana.com/blog/2021/03/03/.how-to-set-up-a-grafana-development-environment-on-a-windows-pc-using-wsl). This will allow you to leverage the resources available in [grafana/grafana](https://github.com/grafana/grafana) GitHub repository. Here you will find a collection of supported data  sources, including MS SQL Server, along with test data and  pre-configured dashboards for use.
如果您使用的是 Windows 主机，但希望在 Linux 环境中使用 Grafana 和 MS SQL 数据源，请参阅 [WSL 以设置 Grafana 开发环境](https://grafana.com/blog/2021/03/03/.how-to-set-up-a-grafana-development-environment-on-a-windows-pc-using-wsl)。这将允许您利用 [grafana/grafana](https://github.com/grafana/grafana) GitHub 存储库中提供的资源。在这里，您将找到一系列受支持的数据源，包括 MS SQL Server，以及测试数据和预配置的仪表板以供使用。

#### Add the MS SQL data source 添加 MS SQL 数据源

There are several ways to authenticate in MSSQL. Start by:
在 MSSQL 中，有几种方法可以进行身份验证。开始：

1. Click **Connections** in the left-side menu and filter by `mssql`.
   单击左侧菜单中的 **Connections（连接**），然后按 `mssql` 进行筛选。
2. Select the **Microsoft SQL Server** option.
   选择 **Microsoft SQL Server** 选项。
3. Click **Create a Microsoft SQL Server data source** in the top right corner to open the configuration page.
   单击右上角的 **Create a Microsoft SQL Server data source** 以打开配置页面。
4. Select the desired authentication method and fill in the right information as detailed below.
   选择所需的身份验证方法并填写正确的信息，如下所述。
5. Click **Save & test**.
   点击**保存并测试**。

##### General configuration 常规配置

| Name 名字           | Description 描述                                             |
| ------------------- | ------------------------------------------------------------ |
| `Name` `名字`       | The data source name. This is how you refer to the data source in panels and queries. 数据源名称。这是您在面板和查询中引用数据源的方式。 |
| `Host` `主机`       | The IP address/hostname and optional port of your MS SQL instance. If port is omitted, the default 1433 will be used. MS SQL 实例的 IP 地址/主机名和可选端口。如果省略 port ，则将使用默认的 1433。 |
| `Database` `数据库` | Name of your MS SQL database. 您的 MS SQL 数据库的名称。     |

##### SQL Server Authentication SQL Server 身份验证

| Name 名字         | Description 描述                                            |
| ----------------- | ----------------------------------------------------------- |
| `User` `用户`     | Database user’s login/username. 数据库用户的登录名/用户名。 |
| `Password` `密码` | Database user’s password. 数据库用户的密码。                |

##### Windows Active Directory (Kerberos) Windows Active Directory （Kerberos）

Below are the four possible ways to authenticate via Windows Active Directory/Kerberos.
以下是通过 Windows Active Directory/Kerberos 进行身份验证的四种可能方法。

> Note 注意
>
> Windows Active Directory (Kerberos) authentication is not supported in Grafana Cloud at the moment.
>
> 
> Grafana Cloud 目前不支持 Windows Active Directory （Kerberos） 身份验证。

| Method 方法                            | Description 描述                                             |
| -------------------------------------- | ------------------------------------------------------------ |
| **Username + password 用户名 + 密码**  | Enter the domain user and password 输入域用户和密码          |
| **Keytab file Keytab 文件**            | Specify the path to a valid keytab file to use that for authentication. 指定用于身份验证的有效密钥表文件的路径。 |
| **Credential cache 凭证缓存**          | Log in on the host via `kinit` and pass the path to the credential cache. The cache path can be found by running `klist` on the host in question. 通过 `kinit` 登录主机，并将路径传递给凭证缓存。可以通过在相关主机上运行 `klist` 来找到缓存路径。 |
| **Credential cache file 凭证缓存文件** | This option allows multiple valid configurations to be present and matching  is performed on host, database, and user. See the example JSON below  this table. 此选项允许存在多个有效配置，并在主机、数据库和用户上执行匹配。请参阅此表下方的示例 JSON。 |

json JSON 格式

```json
[
  {
    "user": "grot@GF.LAB",
    "database": "dbone",
    "address": "mysql1.mydomain.com:3306",
    "credentialCache": "/tmp/krb5cc_1000"
  },
  {
    "user": "grot@GF.LAB",
    "database": "dbtwo",
    "address": "mysql2.gf.lab",
    "credentialCache": "/tmp/krb5cc_1000"
  }
]
```

For installations from the [grafana/grafana](https://github.com/grafana/grafana/tree/main) repository, `gdev-mssql` data source is available. Once you add this data source, you can use the `Datasource tests - MSSQL` dashboard with three panels showing metrics generated from a test database.
对于从 [grafana/grafana](https://github.com/grafana/grafana/tree/main) 存储库进行的安装，可以使用 `gdev-mssql` 数据源。添加此数据源后，您可以使用 `Datasource tests - MSSQL` 控制面板，其中包含三个面板，其中显示了从测试数据库生成的量度。

![MS SQL Server dashboard](https://grafana.com/static/img/docs/getting-started/gdev-sql-dashboard.png)

Optionally, play around this dashboard and customize it to:
（可选）尝试使用此仪表板并将其自定义为：

- Create different panels. 创建不同的面板。
- Change titles for panels.
  更改面板的标题。
- Change frequency of data polling.
  更改数据轮询的频率。
- Change the period for which the data is displayed.
  更改显示数据的时间段。
- Rearrange and resize panels.
  重新排列面板并调整其大小。

#### Start building dashboards 开始构建仪表板

Now that you have gained some idea of using the pre-packaged MS SQL data  source and some test data, the next step is to setup your own instance  of MS SQL Server database and data your development or sandbox area.
现在，您已经对使用预打包的 MS SQL 数据源和一些测试数据有所了解，下一步是设置您自己的 MS SQL Server 数据库实例，并在您的开发或沙盒区域提供数据。

To fetch data from your own instance of MS SQL Server, add the data source using instructions in Step 4 of this topic. In Grafana [Explore](https://grafana.com/docs/grafana/latest/explore/) build queries to experiment with the metrics you want to monitor.
要从您自己的 MS SQL Server 实例中获取数据，请按照本主题步骤 4 中的说明添加数据源。在 Grafana [Explore 中，](https://grafana.com/docs/grafana/latest/explore/)构建查询以试验要监控的指标。

Once you have a curated list of queries, create [dashboards](https://grafana.com/docs/grafana/latest/dashboards/) to render metrics from the SQL Server database. For troubleshooting,  user permissions, known issues, and query examples, refer to [Using Microsoft SQL Server in Grafana](https://grafana.com/docs/grafana/latest/datasources/mssql/).
获得精选的查询列表后，创建[控制面板](https://grafana.com/docs/grafana/latest/dashboards/)以呈现 SQL Server 数据库中的指标。有关故障排除、用户权限、已知问题和查询示例，请参阅[在 Grafana 中使用 Microsoft SQL Server](https://grafana.com/docs/grafana/latest/datasources/mssql/)。