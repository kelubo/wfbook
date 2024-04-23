# Ubuntu Pro 订阅

including [Linux kernel livepatching](https://ubuntu.com/security/livepatch), access to [FIPS-validated packages](https://ubuntu.com/security/fips), and [compliance with security profiles](https://ubuntu.com/security/certifications) such as CIS.
将 Ubuntu Pro 订阅附加到 Ubuntu 可为您带来企业生命周期，包括 Linux 内核实时修补、访问 FIPS 验证的软件包以及符合 CIS 等安全配置文件。对于通过 AWS、Azure 或 GCP 等公有云的 Ubuntu Pro  实例，这不是必需的，因为这些实例在启动时会自动附加。

> **Νote**: 
> 订阅不仅适用于企业客户。任何人都可以在最多 5 台机器上免费获得个人订阅，如果您是 Ubuntu 社区的正式成员，则可以免费获得 50 台机器。

## 安装 Ubuntu Pro 客户端

对于 Ubuntu Pro 用户或个人订阅持有者来说，此步骤是必需的。如果是通过公有云产品/服务的 Ubuntu Pro 用户，则订阅已附加，可以跳过这些说明。

首先需要确保运行的是最新版本的 Ubuntu Pro 客户端。用于访问 Pro Client （ `pro` ） 的软件包是 `ubuntu-advantage-tools` ：

```bash
sudo apt update 
sudo apt install ubuntu-advantage-tools
```

如果已安装 `ubuntu-advantage-tools` ，则此安装命令会将软件包升级到最新版本。

## 附加订阅

安装最新版本的 Pro 客户端后，需要将 Ubuntu Pro 令牌附加到 Pro 客户端，以访问 Ubuntu Pro 下提供的服务。

首先，需要从 Ubuntu Pro 仪表板中检索 Ubuntu Pro 令牌。要访问仪表板，需要一个 Ubuntu One 帐户。如果仍需要创建一个订阅，请务必使用用于创建订阅的电子邮件地址进行注册。

Ubuntu One 帐户用作单点登录 （SSO），因此登录后，可以直接进入 ubuntu.com/pro 的 Ubuntu Pro 仪表板。然后单击“您的付费订阅”表中的“机器”列以显示您的令牌。

现在，已准备好将 Ubuntu Pro 令牌附加到 Pro 客户端：

```bash
sudo pro attach <your_pro_token>
```

当在类似于以下内容的表中看到服务、描述及其启用/禁用状态的列表时，将知道令牌已成功附加：

```bash
SERVICE          ENTITLED  STATUS    DESCRIPTION
esm-apps         yes       enabled   Expanded Security Maintenance for Applications
esm-infra        yes       enabled   Expanded Security Maintenance for Infrastructure
livepatch        yes       enabled   Canonical Livepatch service
realtime-kernel  yes       disabled  Ubuntu kernel with PREEMPT_RT patches integrated
```

请注意，扩展安全维护 （ESM） 和 Livepatch 将在令牌附加到计算机后自动启用。

使用令牌附加 Pro 客户端后，还可以使用 Pro 客户端激活大多数 Ubuntu Pro 服务，包括 Livepatch、FIPS 和 CIS 基准测试工具。

## 延伸阅读

- For more information about the Ubuntu Pro Client, you can [read our documentation](https://canonical-ubuntu-pro-client.readthedocs-hosted.com/en/latest/).
  有关 Ubuntu Pro 客户端的更多信息，您可以阅读我们的文档。
- For a guided tour through the most commonly-used commands available through the Ubuntu Pro Client, [check out this tutorial](https://canonical-ubuntu-pro-client.readthedocs-hosted.com/en/latest/tutorials/basic_commands.html).
  有关通过 Ubuntu Pro 客户端提供的最常用命令的指导教程，请查看本教程。