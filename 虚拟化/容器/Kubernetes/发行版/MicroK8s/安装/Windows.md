# Installing MicroK8s on Windows 10/11 在 Windows 8/10 上安装 MicroK11s

**Note:**  We recommend Windows 10 Professional or Windows 10 Enterprise.  MicroK8s will also require at least 4GB of available RAM and 40GB of  storage.
**注意：**我们建议使用 Windows 10 专业版或 Windows 10 企业版。MicroK8s 还需要至少 4GB 的可用 RAM 和 40GB 的存储空间。

1. **Download the MicroK8s Installer
   下载 MicroK8s 安装程序**
    [Download the latest installer here
   在此处下载最新的安装程序](https://microk8s.io/microk8s-installer.exe)

2. **Run the installer 运行安装程序**
    ![installer-image](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/7/748b76ed4495ee1958fd88d701b0b3c391aa8f85.png)

   The installer checks if Hyper-V is available and switched on. If you don’t  have Hyper-v (e.g. on Windows 10 Home edition) it is possible to use  VirtualBox as an alternative.
   安装程序将检查 Hyper-V 是否可用并已打开。如果您没有 Hyper-V（例如在 Windows 10 家庭版上），则可以使用 VirtualBox 作为替代方案。

3. **Configure MicroK8s 配置 MicroK8s**
    ![configure installer](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/4/41d821b91cf710806b7b497e7fc08251e3c10290.png)

   You can now configure MicroK8s - the minimum recommendations are already  provided. For information on changing the ‘Snap Track’, see [this page](https://microk8s.io/docs/setting-snap-channel).
   您现在可以配置 MicroK8s - 已经提供了最低建议。有关更改“对齐轨道”的信息，请参阅[此页面](https://microk8s.io/docs/setting-snap-channel)。

   You can change this configuration at a later date by re-running the  installer. Note that the Memory and Disk limits are initially set at the **minimum** values. If you are planning on running large workloads (e.g. `kubeflow` will require around 12GB RAM) you will want to set these higher.
   您可以稍后通过重新运行安装程序来更改此配置。请注意，Memory （内存） 和 Disk （磁盘） 限制最初设置为**最小值**。如果您计划运行大型工作负载（例如 `kubeflow` 需要大约 12GB 的 RAM），则需要将这些设置得更高。

4. **Open a command line** and check the status with `microk8s status --wait-ready`:
   **打开命令行**并使用 `microk8s status --wait-ready` 检查状态：

   [![a2-status-wait-ready](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/5cb96213f0910df3615dc0b210d25165c98de096.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/5cb96213f0910df3615dc0b210d25165c98de096.png)

   

5. **Turn on the services you want
   开启您想要的服务**
    MicroK8s includes a series of add-ons and services which can be enabled at any time. For example:
   MicroK8s 包括一系列可以随时启用的附加组件和服务。例如：

   ```auto
   microk8s enable dns
   microk8s enable storage
   microk8s enable ingress
   microk8s enable dashboard
   ```

   You can disable addons with the `microk8s disable <addon>` command.
   您可以使用 `microk8s disable <addon>` 命令禁用插件。

6. **Start using Kubernetes! 开始使用 Kubernetes！**
    MicroK8s wraps the `kubectl` command familiar to Kubernetes users, so you can simply perform any usual Kubernetes operation. Try:
   MicroK8s 封装了 Kubernetes 用户熟悉的 `kubectl` 命令，因此您可以简单地执行任何常见的 Kubernetes作。尝试：

   ```bash
   microk8s kubectl get all --all-namespaces
   ```

7. **Access the Kubernetes dashboard** using the dashboard-proxy command:
   使用 dashboard-proxy 命令**访问 Kubernetes 控制面板**：

   ```auto
   microk8s dashboard-proxy
   ```

   

   [![a4-dashboard-proxy](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/a/af6d648dd1e271499da012de63e344f0003ce140.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/a/af6d648dd1e271499da012de63e344f0003ce140.png)

   

   Open a browser, go to the URL shown in the output and use the token to log in to the dashboard:
   打开浏览器，转到输出中显示的 URL，然后使用令牌登录到仪表板：

   

   [![a3-dashboard-open](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/optimized/2X/8/85a92b727ab1e278124ff51dd1264226befe4b7c_2_690x371.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/8/85a92b727ab1e278124ff51dd1264226befe4b7c.png)

   

8. **Start and stop Kubernetes
   启动和停止 Kubernetes**

   Kubernetes services are always running in the background consuming power and  resources. When not using MicroK8s, use the following command to stop  the Kubernetes services:
   Kubernetes 服务始终在后台运行，消耗电力和资源。不使用 MicroK8s 时，使用以下命令停止 Kubernetes 服务：

   ```auto
   microk8s stop
   ```

   To start the services, you can use:
   要启动服务，您可以使用：

   ```auto
   microk8s start
   ```