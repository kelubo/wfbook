# Install MicroK8s on WSL2 在 WSL2 上安装 MicroK8s

#### On this page 本页内容

​                                                [Install MicroK8s on WSL2 在 WSL2 上安装 MicroK8s](https://microk8s.io/docs/install-wsl2#install-microk8s-on-wsl2)                                                                                            [What next? 下一步是什么？](https://microk8s.io/docs/install-wsl2#what-next)                                                                                                            

## [ Install MicroK8s on WSL2 在 WSL2 上安装 MicroK8s](https://microk8s.io/docs/install-wsl2#install-microk8s-on-wsl2)

The Windows Subsystem For Linux Version 2 (also known as **WSL2**) supports running Ubuntu with systemd as the init process. This enables running snap (and MicroK8s!) natively on Windows hosts.
适用于 Linux 版本 2 的 Windows 子系统（也称为 **WSL2**）支持运行 Ubuntu，并将 systemd 作为 init 进程。这允许在 Windows 主机上本地运行 snap（和 MicroK8s！

1. [**Install WSL2**](https://learn.microsoft.com/en-us/windows/wsl/install) on your machine following the instructions from Microsoft. Ensure that  the installation completed successfully. Troubleshooting issues around  WSL2 are beyond the scope of this document, but you will find lots of  information on the WSL2 link above if you run into problems.
   按照 Microsoft 的说明[**在您的计算机上安装 WSL2**](https://learn.microsoft.com/en-us/windows/wsl/install)。确保安装成功完成。排查有关 WSL2 的问题超出了本文档的范围，但如果您遇到问题，您可以在上面的 WSL2 链接上找到大量信息。

2. **Update WSL to the latest version** and ensure WSL2 is set as the default version:
   **将 WSL 更新到最新版本**，并确保将 WSL2 设置为默认版本：

   ```auto
   wsl --update
   wsl --set-default-version 2
   ```

3. **Install Ubuntu** and wait for the machine to come up. Configure your username and password for the Ubuntu instance. Below, we choose username `ubuntu`:
   **安装 Ubuntu** 并等待计算机启动。配置 Ubuntu 实例的用户名和密码。下面，我们选择用户名 `ubuntu`：

   

   [![Screenshot_20230130_023636](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/optimized/2X/9/90c203ca5341c6e39a33e6e7b56b3132a2e3c3e1_2_690x404.jpeg)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/9/90c203ca5341c6e39a33e6e7b56b3132a2e3c3e1.jpeg)

   

4. **Enable systemd** by running the following command in the WSL terminal:
   通过在 WSL 终端中运行以下命令**来启用 systemd**：

   ```auto
   echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf
   ```

   ![Screenshot_20230130_025228](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/7/711d9dccaeb2c7c86a8a4a3be07fe9099e49a1e5.png)

5. **Exit the WSL terminal, then restart WSL**.
   **退出 WSL 终端，然后重启 WSL**。

   ```auto
   wsl --shutdown
   wsl
   ```

From this point, `systemd` is enabled and snaps should work properly. You can list the installed snaps with
从这时起，`systemd` 已启用，snap 应该可以正常工作。您可以使用

```auto
sudo snap list
```

1. **Install MicroK8s**.
   **安装 MicroK8s**。

   ```auto
   sudo snap install microk8s --classic
   ```

   

   [![Screenshot_20230130_024210](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/f/f4723205f8e5bdd477d6e983c58073c174544431.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/f/f4723205f8e5bdd477d6e983c58073c174544431.png)

   

2. **Wait for MicroK8s to start**.
   **等待 MicroK8s 启动**。

   ```auto
   sudo microk8s status --wait-ready
   ```

   

   [![Screenshot_20230130_025935](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/570e46bc5ec1e15f3ebbc38b318a909db11962b1.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/570e46bc5ec1e15f3ebbc38b318a909db11962b1.png)

   

   We can also verify that our node is using the WSL2 kernel with:
   我们还可以通过以下方式验证我们的节点是否正在使用 WSL2 内核：

   ```auto
   sudo microk8s kubectl get node -o wide
   ```

   

   [![Screenshot_20230130_030043](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/5e14316dcae3623f2fea16949b6875b49f164723.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/5/5e14316dcae3623f2fea16949b6875b49f164723.png)

   

3. **Enable services and start using Kubernetes**!
   **启用服务并开始使用 Kubernetes**！

   MicroK8s with a number of powerful addons out of the box. Enable the functionality you want to get started:
   MicroK8s 具有许多开箱即用的强大插件。启用要开始使用的功能：

   ```auto
   sudo microk8s enable dns
   sudo microk8s enable storage
   sudo microk8s enable dashboard
   ```

   To access the dashboard, MicroK8s offers a helper command:
   要访问仪表板，MicroK8s 提供了一个辅助命令：

   ```auto
   sudo microk8s dashboard-proxy
   ```

   

   [![Screenshot_20230130_030549](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/c/c7192bcc643d72a0f5ce0ac12b3de98e27b7595f.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/c/c7192bcc643d72a0f5ce0ac12b3de98e27b7595f.png)

   

   Open a browser window to the URL shown in the text and use the token to login:
   打开一个浏览器窗口，访问文本中显示的 URL，并使用令牌登录：

   

   [![Screenshot_20230130_030606](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/optimized/2X/d/d29a1f59d46be738d0ba3bc9891adb9e80f48acf_2_690x368.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/d/d29a1f59d46be738d0ba3bc9891adb9e80f48acf.png)

   

   MicroK8s wraps the `kubectl` binary, and you can use it to interact with the cluster:
   MicroK8s 包装了 `kubectl` 二进制文件，您可以使用它来与集群交互：

   ```auto
   sudo microk8s kubectl create deploy --image nginx --replicas 3 nginx
   ```

   

   [![Screenshot_20230130_031700](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/0/05e67834c07bab4fafa15c417e34a7c20f9a166c.png)](https://us1.discourse-cdn.com/flex016/uploads/kubernetes/original/2X/0/05e67834c07bab4fafa15c417e34a7c20f9a166c.png)

   

### [ What next? 下一步是什么？](https://microk8s.io/docs/install-wsl2#what-next)

- Want to experiment with alpha releases of Kubernetes? [See the documentation on setting channels](https://microk8s.io/docs/setting-snap-channel).
  想试用 Kubernetes 的 Alpha 版本吗？[请参阅有关设置通道的文档](https://microk8s.io/docs/setting-snap-channel)。
- Need to tweak the Kubernetes configuration? [Find out how to configure the Kubernetes services](https://microk8s.io/docs/services-and-ports).
  需要调整 Kubernetes 配置？[了解如何配置 Kubernetes 服务](https://microk8s.io/docs/services-and-ports)。
- Having problems? Check out our [troubleshooting section](https://microk8s.io/docs/troubleshooting).
  有问题吗？查看我们的[故障排除部分](https://microk8s.io/docs/troubleshooting)。
- Love MicroK8s? Want to contribute or suggest a feature? [Give us your feedback](https://microk8s.io/docs/get-in-touch).
  喜欢 MicroK8s？想要贡献或建议某个功能？[请向我们提供您的反馈](https://microk8s.io/docs/get-in-touch)。