# kubectl

[TOC]

## 概述

kubectl 版本和集群版本之间的差异必须在一个小版本号内。 例如：v1.26 版本的客户端能与 v1.25、 v1.26 和 v1.27 版本的控制面通信。 用最新兼容版的 kubectl 有助于避免不可预见的问题。

## Linux

在 Linux 系统中安装 kubectl 有如下几种方法：

- 用 curl 在 Linux 系统中安装
- 用原生包管理工具安装
- 用其他包管理工具安装

### 用 curl 在 Linux 系统中安装 kubectl

1. 用以下命令下载最新发行版：

   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   ```

   > **说明：**
   >
   > 如需下载某个指定的版本，请用指定版本号替换该命令的这一部分： `$(curl -L -s https://dl.k8s.io/release/stable.txt)`。
   >
   > 例如，要在 Linux 中下载 v1.26.0 版本，请输入：
   >
   > ```bash
   > curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl
   > ```

1. 验证该可执行文件（可选步骤）

   下载 kubectl 校验和文件：

   ```bash
   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
   ```

   基于校验和文件，验证 kubectl 的可执行文件：

   ```bash
   echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
   ```

   验证通过时，输出为：

   ```bash
   kubectl: OK
   ```

   验证失败时，`sha256` 将以非零值退出，并打印如下输出：

   ```bash
   kubectl: FAILED
   sha256sum: WARNING: 1 computed checksum did NOT match
   ```

   > **说明：**
>
   > 下载的 kubectl 与校验和文件版本必须相同。

1. 安装 kubectl

   ```bash
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

   > **说明：**
   >
   > 即使你没有目标系统的 root 权限，仍然可以将 kubectl 安装到目录 `~/.local/bin` 中：
   >
   > ```bash
   > chmod +x kubectl
   > mkdir -p ~/.local/bin
   > mv ./kubectl ~/.local/bin/kubectl
   > # 之后将 ~/.local/bin 附加（或前置）到 $PATH
   > ```

1. 执行测试，以保障你安装的版本是最新的：

   ```bash
   kubectl version --client
   ```

   或者使用如下命令来查看版本的详细信息：

   ```bash
   kubectl version --client --output=yaml
   ```

### 用原生包管理工具安装

#### 基于 Debian 的发行版

1. 更新 `apt` 包索引，并安装使用 Kubernetes `apt` 仓库所需要的包：

   ```bash
   sudo apt-get update
   sudo apt-get install -y ca-certificates curl
   ```

   如果你使用 Debian 9（stretch）或更早版本，则你还需要安装 `apt-transport-https`：

   ```bash
   sudo apt-get install -y apt-transport-https
   ```

1. 下载 Google Cloud 公开签名秘钥：

   ```bash
   sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
   ```

1. 添加 Kubernetes `apt` 仓库：

   ```bash
   echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   ```

1. 更新 `apt` 包索引，使之包含新的仓库并安装 kubectl：

   ```bash
   sudo apt-get update
   sudo apt-get install -y kubectl
   ```

> **说明：**
>
> 在低于 Debian 12 和 Ubuntu 22.04 的发行版本中，`/etc/apt/keyrings` 默认不存在。 如有需要，你可以创建此目录，并将其设置为对所有人可读，但仅对管理员可写。

#### 基于 Red Hat 的发行版

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
```

### 用其他包管理工具安装

#### Snap

如果你使用的 Ubuntu 或其他 Linux 发行版，内建支持 snap 包管理工具， 则可用 snap 命令安装 kubectl。

```bash
snap install kubectl --classic
kubectl version --client
```

#### Homebrew

如果你使用 Linux 系统，并且装了 Homebrew 包管理工具， 则可以使用这种方式安装 kubectl。

```bash
brew install kubectl
kubectl version --client
```

### 验证 kubectl 配置

为了让 kubectl 能发现并访问 Kubernetes 集群，需要一个 kubeconfig 文件， 该文件在 [kube-up.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/kube-up.sh) 创建集群时，或成功部署一个 Miniube 集群时，均会自动生成。 通常，kubectl 的配置信息存放于文件 `~/.kube/config` 中。

通过获取集群状态的方法，检查是否已恰当地配置了 kubectl：

```bash
kubectl cluster-info
```

如果返回一个 URL，则意味着 kubectl 成功地访问到了集群。

如果看到如下所示的消息，则代表 kubectl 配置出了问题，或无法连接到 Kubernetes 集群。

```bash
The connection to the server <server-name:port> was refused - did you specify the right host or port?
```

例如，如果你想在自己的笔记本上（本地）运行 Kubernetes 集群，你需要先安装一个 Minikube 这样的工具，然后再重新运行上面的命令。

如果命令 `kubectl cluster-info` 返回了 URL，但你还不能访问集群，那可以用以下命令来检查配置是否妥当：

```bash
kubectl cluster-info dump
```

### kubectl 的可选配置和插件

#### 启用 shell 自动补全功能

kubectl 为 Bash、Zsh、Fish 和 PowerShell 提供自动补全功能，可以为你节省大量的输入。

##### Bash

kubectl 的 Bash 补全脚本可以用命令 `kubectl completion bash` 生成。 在 Shell 中导入（Sourcing）补全脚本，将启用 kubectl 自动补全功能。

然而，补全脚本依赖于工具 [**bash-completion**](https://github.com/scop/bash-completion)， 所以要先安装它（可以用命令 `type _init_completion` 检查 bash-completion 是否已安装）。

###### 安装 bash-completion

很多包管理工具均支持 bash-completion 。 可以通过 `apt-get install bash-completion` 或 `yum install bash-completion` 等命令来安装它。

上述命令将创建文件 `/usr/share/bash-completion/bash_completion`，它是 bash-completion 的主脚本。 依据包管理工具的实际情况，你需要在 `~/.bashrc` 文件中手工导入此文件。

要查看结果，请重新加载你的 Shell，并运行命令 `type _init_completion`。 如果命令执行成功，则设置完成，否则将下面内容添加到文件 `~/.bashrc` 中：

```bash
source /usr/share/bash-completion/bash_completion
```

重新加载 Shell，再输入命令 `type _init_completion` 来验证 bash-completion 的安装状态。

###### 启动 kubectl 自动补全功能

现在需要确保一点：kubectl 补全脚本已经导入（sourced）到 Shell 会话中。 可以通过以下两种方法进行设置：

- 当前用户

  ```bash
  echo 'source <(kubectl completion bash)' >>~/.bashrc
  ```

- 系统全局

  ```bash
  kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
  ```

如果 kubectl 有关联的别名，你可以扩展 Shell 补全来适配此别名：

```bash
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
```

> **说明：**
>
> bash-completion 负责导入 `/etc/bash_completion.d` 目录中的所有补全脚本。

两种方式的效果相同。重新加载 Shell 后，kubectl 自动补全功能即可生效。 若要在当前 Shell 会话中启用 Bash 补全功能，需要运行 `exec bash` 命令：

```bash
exec bash
```

##### Fish

> **说明：**
>
> 自动补全 Fish 需要 kubectl 1.23 或更高版本。

kubectl 通过命令 `kubectl completion fish` 生成 Fish 自动补全脚本。 在 shell 中导入（Sourcing）该自动补全脚本，将启动 kubectl 自动补全功能。

为了在所有的 shell 会话中实现此功能，请将下面内容加入到文件 `~/.config/fish/config.fish` 中。

```bash
kubectl completion fish | source
```

重新加载 shell 后，kubectl 自动补全功能将立即生效。

##### Zsh

kubectl 通过命令 `kubectl completion zsh` 生成 Zsh 自动补全脚本。 在 shell 中导入（Sourcing）该自动补全脚本，将启动 kubectl 自动补全功能。

为了在所有的 shell 会话中实现此功能，请将下面内容加入到文件 `~/.zshrc` 中。

```zsh
source <(kubectl completion zsh)
```

如果你为 kubectl 定义了别名，kubectl 自动补全将自动使用它。

重新加载 shell 后，kubectl 自动补全功能将立即生效。

如果你收到 `2: command not found: compdef` 这样的错误提示，那请将下面内容添加到 `~/.zshrc` 文件的开头：

```zsh
autoload -Uz compinit
compinit
```

#### 安装 `kubectl convert` 插件

一个 `kubectl` 的插件，允许你将清单在不同 API 版本间转换。 这对于将清单迁移到新的 Kubernetes 发行版上未被废弃的 API 版本时尤其有帮助。 

1. 用以下命令下载最新发行版：

   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"
   ```

1. 验证该可执行文件（可选步骤）

   下载 kubectl-convert 校验和文件：

   ```bash
   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert.sha256"
   ```

   基于校验和，验证 kubectl-convert 的可执行文件：

   ```bash
   echo "$(cat kubectl-convert.sha256) kubectl-convert" | sha256sum --check
   ```

   验证通过时，输出为：

   ```bash
   kubectl-convert: OK
   ```

   验证失败时，`sha256` 将以非零值退出，并打印输出类似于：

   ```bash
   kubectl-convert: FAILED
   sha256sum: WARNING: 1 computed checksum did NOT match
   ```

   > **说明：**
>
   > 下载相同版本的可执行文件和校验和。

1. 安装 kubectl-convert

   ```bash
   sudo install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert
   ```

1. 验证插件是否安装成功

   ```shell
   kubectl convert --help
   ```

   如果你没有看到任何错误就代表插件安装成功了。

## MacOS

在 macOS 系统上安装 kubectl 有如下方法：

- 用 curl 在 macOS 系统上安装
- 用 Homebrew 在 macOS 系统上安装
- 用 Macports 在 macOS 上安装

### 用 curl 在 macOS 系统上安装

1. 下载最新的发行版：

   * Intel

   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
   ```

   - Apple Silicon

     ```bash
     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
     ```

   > **说明：**
   >
   > 如果需要下载某个指定的版本，用该指定版本号替换掉命令的这个部分：`$(curl -L -s https://dl.k8s.io/release/stable.txt)`。 例如：要为 Intel macOS 系统下载 v1.26.0 版本，则输入：
   >
   > ```bash
   > curl -LO "https://dl.k8s.io/release/v1.26.0/bin/darwin/amd64/kubectl"
   > ```
   >
   > 对于 Apple Silicon 版本的 macOS，输入：
   >
   > ```bash
   > curl -LO "https://dl.k8s.io/release/v1.26.0/bin/darwin/arm64/kubectl"
   > ```

2. 验证可执行文件（可选操作）

1. 下载 kubectl 的校验和文件：

   - [Intel](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-checksum-macos-0)
   - [Apple Silicon](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-checksum-macos-1)

   

   ```bash
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl.sha256"
      
   ```

   根据校验和文件，验证 kubectl：

   ```bash
   echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check
   ```

   验证通过时，输出如下：

   ```console
   kubectl: OK
   ```

   验证失败时，`shasum` 将以非零值退出，并打印如下输出：

   ```
   kubectl: FAILED
   shasum: WARNING: 1 computed checksum did NOT match
   ```

   **说明：**

   下载的 kubectl 与校验和文件版本要相同。

1. 将 kubectl 置为可执行文件：

   ```bash
   chmod +x ./kubectl
   ```

1. 将可执行文件 kubectl 移动到系统可寻址路径 `PATH` 内的一个位置：

   ```bash
   sudo mv ./kubectl /usr/local/bin/kubectl
   sudo chown root: /usr/local/bin/kubectl
   ```

   **说明：**

   确保 `/usr/local/bin` 在你的 PATH 环境变量中。

1. 测试一下，确保你安装的是最新的版本：

   ```bash
   kubectl version --client
   ```

   或者使用下面命令来查看版本的详细信息：

   ```cmd
   kubectl version --client --output=yaml
   ```

### 用 Homebrew 在 macOS 系统上安装

如果你是 macOS 系统，且用的是 [Homebrew](https://brew.sh/) 包管理工具， 则可以用 Homebrew 安装 kubectl。

1. 运行安装命令：

   ```bash
   brew install kubectl 
   ```

   或

   ```bash
   brew install kubernetes-cli
   ```

1. 测试一下，确保你安装的是最新的版本：

   ```bash
   kubectl version --client
   ```

### 用 Macports 在 macOS 上安装

如果你用的是 macOS，且用 [Macports](https://macports.org/) 包管理工具，则你可以用 Macports 安装kubectl。

1. 运行安装命令：

   ```bash
   sudo port selfupdate
   sudo port install kubectl
   ```

1. 测试一下，确保你安装的是最新的版本：

   ```bash
   kubectl version --client
   ```

### 验证 kubectl 配置

为了让 kubectl 能发现并访问 Kubernetes 集群，你需要一个 [kubeconfig 文件](https://kubernetes.io/zh-cn/docs/concepts/configuration/organize-cluster-access-kubeconfig/)， 该文件在 [kube-up.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/kube-up.sh) 创建集群时，或成功部署一个 Miniube 集群时，均会自动生成。 通常，kubectl 的配置信息存放于文件 `~/.kube/config` 中。

通过获取集群状态的方法，检查是否已恰当地配置了 kubectl：

```shell
kubectl cluster-info
```

如果返回一个 URL，则意味着 kubectl 成功地访问到了你的集群。

如果你看到如下所示的消息，则代表 kubectl 配置出了问题，或无法连接到 Kubernetes 集群。

```
The connection to the server <server-name:port> was refused - did you specify the right host or port?
（访问 <server-name:port> 被拒绝 - 你指定的主机和端口是否有误？）
```

例如，如果你想在自己的笔记本上（本地）运行 Kubernetes 集群，你需要先安装一个 Minikube 这样的工具，然后再重新运行上面的命令。

如果命令 `kubectl cluster-info` 返回了 URL，但你还不能访问集群，那可以用以下命令来检查配置是否妥当：

```shell
kubectl cluster-info dump
```

#### 可选的 kubectl 配置和插件

##### 启用 shell 自动补全功能

kubectl 为 Bash、Zsh、Fish 和 PowerShell 提供自动补全功能，可以为你节省大量的输入。

下面是为 Bash、Fish 和 Zsh 设置自动补全功能的操作步骤。

- [Bash](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#kubectl-autocompletion-0)
- [Fish](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#kubectl-autocompletion-1)
- [Zsh](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#kubectl-autocompletion-2)



### 简介

kubectl 的 Bash 补全脚本可以通过 `kubectl completion bash` 命令生成。 在你的 Shell 中导入（Sourcing）这个脚本即可启用补全功能。

此外，kubectl 补全脚本依赖于工具 [**bash-completion**](https://github.com/scop/bash-completion)， 所以你必须先安装它。

**警告：**

bash-completion 有两个版本：v1 和 v2。v1 对应 Bash 3.2（也是 macOS 的默认安装版本），v2 对应 Bash 4.1+。 kubectl 的补全脚本**无法适配** bash-completion v1 和 Bash 3.2。 必须为它配备 **bash-completion v2** 和 **Bash 4.1+**。 有鉴于此，为了在 macOS 上使用 kubectl 补全功能，你必须要安装和使用 Bash 4.1+ （[**说明**](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)）。 后续说明假定你用的是 Bash 4.1+（也就是 Bash 4.1 或更新的版本）。

### 升级 Bash

后续说明假定你已使用 Bash 4.1+。你可以运行以下命令检查 Bash 版本：

```bash
echo $BASH_VERSION
```

如果版本太旧，可以用 Homebrew 安装/升级：

```bash
brew install bash
```

重新加载 Shell，并验证所需的版本已经生效：

```bash
echo $BASH_VERSION $SHELL
```

Homebrew 通常把它安装为 `/usr/local/bin/bash`。

### 安装 bash-completion

**说明：**

如前所述，本说明假定你使用的 Bash 版本为 4.1+，这意味着你要安装 bash-completion v2 （不同于 Bash 3.2 和 bash-completion v1，kubectl 的补全功能在该场景下无法工作）。

你可以用命令 `type _init_completion` 测试 bash-completion v2 是否已经安装。 如未安装，用 Homebrew 来安装它：

```bash
brew install bash-completion@2
```

如命令的输出信息所显示的，将如下内容添加到文件 `~/.bash_profile` 中：

```bash
brew_etc="$(brew --prefix)/etc" && [[ -r "${brew_etc}/profile.d/bash_completion.sh" ]] && . "${brew_etc}/profile.d/bash_completion.sh"
```

重新加载 Shell，并用命令 `type _init_completion` 验证 bash-completion v2 已经恰当的安装。

### 启用 kubectl 自动补全功能

你现在需要确保在所有的 Shell 环境中均已导入（sourced）kubectl 的补全脚本， 有若干种方法可以实现这一点：

- 在文件 `~/.bash_profile` 中导入（Source）补全脚本：

  ```bash
  echo 'source <(kubectl completion bash)' >>~/.bash_profile
  ```

- 将补全脚本添加到目录 `/usr/local/etc/bash_completion.d` 中：

  ```bash
  kubectl completion bash >/usr/local/etc/bash_completion.d/kubectl
  ```

- 如果你为 kubectl 定义了别名，则可以扩展 Shell 补全来兼容该别名：

  ```bash
  echo 'alias k=kubectl' >>~/.bash_profile
  echo 'complete -o default -F __start_kubectl k' >>~/.bash_profile
  ```

- 如果你是用 Homebrew 安装的 kubectl （如[此页面](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos)所描述）， 则 kubectl 补全脚本应该已经安装到目录 `/usr/local/etc/bash_completion.d/kubectl` 中了。这种情况下，你什么都不需要做。

  **说明：**

  用 Hommbrew 安装的 bash-completion v2 会初始化目录 `BASH_COMPLETION_COMPAT_DIR` 中的所有文件，这就是后两种方法能正常工作的原因。

总之，重新加载 Shell 之后，kubectl 补全功能将立即生效。

### 安装 `kubectl convert` 插件

一个 Kubernetes 命令行工具 `kubectl` 的插件，允许你将清单在不同 API 版本间转换。 这对于将清单迁移到新的 Kubernetes 发行版上未被废弃的 API 版本时尤其有帮助。 更多信息请访问 [迁移到非弃用 API](https://kubernetes.io/zh-cn/docs/reference/using-api/deprecation-guide/#migrate-to-non-deprecated-apis)

1. 用以下命令下载最新发行版：

   - [Intel](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-convert-binary-macos-0)
   - [Apple Silicon](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-convert-binary-macos-1)

   

   ```bash
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl-convert"
      
   ```

1. 验证该可执行文件（可选步骤）

   下载 kubectl-convert 校验和文件：

   - [Intel](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-convert-checksum-macos-0)
   - [Apple Silicon](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-macos/#download-convert-checksum-macos-1)

   

   ```bash
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl-convert.sha256"
      
   ```

   基于校验和，验证 kubectl-convert 的可执行文件：

   ```bash
   echo "$(cat kubectl-convert.sha256)  kubectl-convert" | shasum -a 256 --check
   ```

   验证通过时，输出为：

   ```console
   kubectl-convert: OK
   ```

   验证失败时，`sha256` 将以非零值退出，并打印输出类似于：

   ```bash
   kubectl-convert: FAILED
   shasum: WARNING: 1 computed checksum did NOT match
   ```

   **说明：**

   下载相同版本的可执行文件和校验和。

1. 使 kubectl-convert 二进制文件可执行

   ```bash
   chmod +x ./kubectl-convert
   ```

1. 将 kubectl-convert 可执行文件移动到系统 `PATH` 环境变量中的一个位置。

   ```bash
   sudo mv ./kubectl-convert /usr/local/bin/kubectl-convert
   sudo chown root: /usr/local/bin/kubectl-convert
   ```

   **说明：**

   确保你的 PATH 环境变量中存在 `/usr/local/bin`

1. 验证插件是否安装成功

   ```shell
   kubectl convert --help
   ```

   如果你没有看到任何错误就代表插件安装成功了。

## Windows

在 Windows 系统中安装 kubectl 有如下几种方法：

- [用 curl 在 Windows 上安装 kubectl](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-windows/#install-kubectl-binary-with-curl-on-windows)
- [在 Windows 上用 Chocolatey、Scoop 或 Winget 安装](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-windows/#install-nonstandard-package-tools)

### 用 curl 在 Windows 上安装 kubectl

1. 下载 [最新发行版 v1.26.0](https://dl.k8s.io/release/v1.26.0/bin/windows/amd64/kubectl.exe)。

   如果你已安装了 `curl`，也可以使用此命令：

   ```powershell
   curl.exe -LO "https://dl.k8s.io/release/v1.26.0/bin/windows/amd64/kubectl.exe"
   ```

   **说明：**

   要想找到最新稳定的版本（例如：为了编写脚本），可以看看这里 https://dl.k8s.io/release/stable.txt。

1. 验证该可执行文件（可选步骤）

   下载 `kubectl` 校验和文件：

   ```powershell
   curl.exe -LO "https://dl.k8s.io/v1.26.0/bin/windows/amd64/kubectl.exe.sha256"
   ```

   基于校验和文件，验证 `kubectl` 的可执行文件：

   - 在命令行环境中，手工对比 `CertUtil` 命令的输出与校验和文件：

   ```cmd
   CertUtil -hashfile kubectl.exe SHA256
   type kubectl.exe.sha256
   ```

   - 用 PowerShell 自动验证，用运算符 `-eq` 来直接取得 `True` 或 `False` 的结果：

   ```powershell
   $($(CertUtil -hashfile .\kubectl.exe SHA256)[1] -replace " ", "") -eq $(type .\kubectl.exe.sha256)
   ```

1. 将 `kubectl` 二进制文件夹追加或插入到你的 `PATH` 环境变量中。

2. 测试一下，确保此 `kubectl` 的版本和期望版本一致：

   ```cmd
   kubectl version --client
   ```

   或者使用下面命令来查看版本的详细信息：

   ```cmd
   kubectl version --client --output=yaml
   ```

**说明：**

[Windows 版的 Docker Desktop](https://docs.docker.com/docker-for-windows/#kubernetes) 将其自带版本的 `kubectl` 添加到 `PATH`。 如果你之前安装过 Docker Desktop，可能需要把此 `PATH` 条目置于 Docker Desktop 安装的条目之前， 或者直接删掉 Docker Desktop 的 `kubectl`。

### 在 Windows 上用 Chocolatey、Scoop 或 Winget 安装

1. 要在 Windows 上安装 kubectl，你可以使用包管理器 [Chocolatey](https://chocolatey.org)、 命令行安装器 [Scoop](https://scoop.sh) 或包管理器 [Winget](https://winget.run/)。

   - [choco](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-windows/#kubectl-win-install-0)
   - [scoop](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-windows/#kubectl-win-install-1)
   - [winget](https://kubernetes.io/zh-cn/docs/tasks/tools/install-kubectl-windows/#kubectl-win-install-2)

   

   ```powershell
   choco install kubernetes-cli
   ```

1. 测试一下，确保安装的是最新版本：

   ```powershell
   kubectl version --client
   ```

1. 导航到你的 home 目录：

   ```powershell
   # 当你用 cmd.exe 时，则运行： cd %USERPROFILE%
   cd ~
   ```

1. 创建目录 `.kube`：

   ```powershell
   mkdir .kube
   ```

1. 切换到新创建的目录 `.kube`：

   ```powershell
   cd .kube
   ```

1. 配置 kubectl，以接入远程的 Kubernetes 集群：

   ```powershell
   New-Item config -type file
   ```

**说明：**

编辑配置文件，你需要先选择一个文本编辑器，比如 Notepad。

## 验证 kubectl 配置

为了让 kubectl 能发现并访问 Kubernetes 集群，你需要一个 [kubeconfig 文件](https://kubernetes.io/zh-cn/docs/concepts/configuration/organize-cluster-access-kubeconfig/)， 该文件在 [kube-up.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/kube-up.sh) 创建集群时，或成功部署一个 Miniube 集群时，均会自动生成。 通常，kubectl 的配置信息存放于文件 `~/.kube/config` 中。

通过获取集群状态的方法，检查是否已恰当地配置了 kubectl：

```shell
kubectl cluster-info
```

如果返回一个 URL，则意味着 kubectl 成功地访问到了你的集群。

如果你看到如下所示的消息，则代表 kubectl 配置出了问题，或无法连接到 Kubernetes 集群。

```
The connection to the server <server-name:port> was refused - did you specify the right host or port?
（访问 <server-name:port> 被拒绝 - 你指定的主机和端口是否有误？）
```

例如，如果你想在自己的笔记本上（本地）运行 Kubernetes 集群，你需要先安装一个 Minikube 这样的工具，然后再重新运行上面的命令。

如果命令 `kubectl cluster-info` 返回了 URL，但你还不能访问集群，那可以用以下命令来检查配置是否妥当：

```shell
kubectl cluster-info dump
```

## kubectl 可选配置和插件

### 启用 shell 自动补全功能

kubectl 为 Bash、Zsh、Fish 和 PowerShell 提供自动补全功能，可以为你节省大量的输入。

下面是设置 PowerShell 自动补全功能的操作步骤。

使用命令 `kubectl completion powershell` 生成 PowerShell 的 kubectl 自动补全脚本。

如果需要自动补全在所有 shell 会话中生效，请将以下命令添加到 `$PROFILE` 文件中：

```powershell
kubectl completion powershell | Out-String | Invoke-Expression
```

此命令将在每次 PowerShell 启动时重新生成自动补全脚本。你还可以将生成的自动补全脚本添加到 `$PROFILE` 文件中。

如果需要将自动补全脚本直接添加到 `$PROFILE` 文件中，请在 PowerShell 终端运行以下命令：

```powershell
kubectl completion powershell >> $PROFILE
```

完成上述操作后重启 shell，kubectl的自动补全就可以工作了。

### 安装 `kubectl convert` 插件

一个 Kubernetes 命令行工具 `kubectl` 的插件，允许你将清单在不同 API 版本间转换。 这对于将清单迁移到新的 Kubernetes 发行版上未被废弃的 API 版本时尤其有帮助。 更多信息请访问 [迁移到非弃用 API](https://kubernetes.io/zh-cn/docs/reference/using-api/deprecation-guide/#migrate-to-non-deprecated-apis)

1. 用以下命令下载最新发行版：

   ```powershell
   curl.exe -LO "https://dl.k8s.io/release/v1.26.0/bin/windows/amd64/kubectl-convert.exe"
   ```

1. 验证该可执行文件（可选步骤）

   下载 `kubectl-convert` 校验和文件：

   ```powershell
   curl.exe -LO "https://dl.k8s.io/v1.26.0/bin/windows/amd64/kubectl-convert.exe.sha256"
   ```

   基于校验和验证 `kubectl-convert` 的可执行文件：

   - 用提示的命令对 `CertUtil` 的输出和下载的校验和文件进行手动比较。

   ```cmd
   CertUtil -hashfile kubectl-convert.exe SHA256
   type kubectl-convert.exe.sha256
   ```

   - 使用 PowerShell `-eq` 操作使验证自动化，获得 `True` 或者 `False` 的结果：

     ```powershell
     $($(CertUtil -hashfile .\kubectl-convert.exe SHA256)[1] -replace " ", "") -eq $(type .\kubectl-convert.exe.sha256)
     ```

1. 将 `kubectl-convert` 二进制文件夹附加或添加到你的 `PATH` 环境变量中。

2. 验证插件是否安装成功。

   ```shell
   kubectl convert --help
   ```

   如果你没有看到任何错误就代表插件安装成功了。
