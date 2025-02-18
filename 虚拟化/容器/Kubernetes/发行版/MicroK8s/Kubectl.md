# Working with kubectl 使用 kubectl

MicroK8s comes with its own packaged version of the `kubectl` command for operating Kubernetes. By default, this is accessed through  MicroK8s, to avoid interfering with any version which may already be on  the host machine (including its configuration). It is run in a terminal  like this:
MicroK8s 自带了自己的打包版本的 `kubectl` 命令，用于作 Kubernetes。默认情况下，这是通过 MicroK8s 访问的，以避免干扰主机上可能已经存在的任何版本（包括其配置）。它在终端中运行，如下所示：

```auto
microk8s kubectl
```

If you are using or want to use a different kubectl command, see the relevant sections below for your OS
如果您正在使用或想要使用不同的 kubectl 命令，请参阅下面适用于您的作系统的相关部分

### Linux Linux的

If you’d prefer to use your host’s [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command, running the following command will output the kubeconfig file from MicroK8s.
如果您更喜欢使用主机的 [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) 命令，运行以下命令将从 MicroK8s 输出 kubeconfig 文件。

```nohighlight
microk8s config
```

If you have not already configured kubectl on the host, you can just open a terminal and generate the required config :
如果您尚未在主机上配置 kubectl，则只需打开一个终端并生成所需的配置即可：

```auto
cd $HOME
mkdir .kube
cd .kube
microk8s config > config
```

If you have already configured other Kubernetes clusters, you should merge the output from the `microk8s config` with the existing config (copy the output, omitting the first two  lines, and paste it onto the end of the existing config using a text  editor).
如果您已经配置了其他 Kubernetes 集群，则应将 `microk8s 配置`的输出与现有配置合并（复制输出，省略前两行，然后使用文本编辑器将其粘贴到现有配置的末尾）。

### Windows 窗户

MicroK8s comes with its own [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command, which can be accessed like this:
MicroK8s 自带 [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) 命令，可以像这样访问：

```auto
microk8s kubectl
```

There are some advantages to running the Windows native version of `kubectl`, notably when working with files(which otherwise need to be copied to/from the VM). To install the Windows version of `kubectl`, see the [official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows). Running the following command will output the kubeconfig file from MicroK8s:
运行 Windows 原生版本的 `kubectl` 有一些好处，尤其是在处理文件时（否则需要复制到 VM 或从 VM 复制文件）。要安装 Windows 版本的 `kubectl`，请参阅[官方文档](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows)。运行以下命令将从 MicroK8s 输出 kubeconfig 文件：

```auto
microk8s config
```

If you have not already configured kubectl on the host for other clusters, you can open a ‘cmd’ Command Prompt and run the following:
如果您尚未在主机上为其他集群配置 kubectl，则可以打开“cmd”命令提示符并运行以下命令：

```auto
cd %USERPROFILE%
mkdir .kube
cd .kube
microk8s config > config
```

If you have already configured other Kubernetes clusters, you should merge the output from the  `microk8s config`  with the existing config (copy the output, omitting the first two  lines, and paste it onto the end of the existing config using a text  editor).
如果您已经配置了其他 Kubernetes 集群，则应将 `microk8s 配置`的输出与现有配置合并（复制输出，省略前两行，然后使用文本编辑器将其粘贴到现有配置的末尾）。

### macOS macOS 的

MicroK8s comes with its own [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command, which can be accessed like this:
MicroK8s 自带 [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) 命令，可以像这样访问：

```auto
microk8s kubectl
```

There are some advantages to running the native version of `kubectl` for macOS, notably when working with files (which otherwise need to be copied to/from the VM). To install the macOS version of `kubectl`, see the [official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos). Running the following command will output the kubeconfig file from MicroK8s:
为 macOS 运行原生版本的 `kubectl` 有一些优势，尤其是在处理文件时（否则需要将文件复制到 VM 或从 VM 复制文件）。要安装 macOS 版本的 `kubectl`，请参阅[官方文档](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)。运行以下命令将从 MicroK8s 输出 kubeconfig 文件：

```nohighlight
microk8s config
```

If you have not already configured kubectl on the host, you can just open a terminal and generate the required config :
如果您尚未在主机上配置 kubectl，则只需打开一个终端并生成所需的配置即可：

```auto
cd $HOME
mkdir .kube
cd .kube
microk8s config > config
```

If you have already configured other Kubernetes clusters, you should merge the output from the `microk8s config` with the existing config (copy the output, omitting the first two  lines, and paste it onto the end of the existing config using a text  editor).
如果您已经配置了其他 Kubernetes 集群，则应将 `microk8s 配置`的输出与现有配置合并（复制输出，省略前两行，然后使用文本编辑器将其粘贴到现有配置的末尾）。