# cephadm 命令

[TOC]

`cephadm` 是一个命令行工具，用于管理 Cephadm Orchestrator 的本地主机。它提供了用于调查和修改当前主机状态的命令。 	

其中一些命令通常用于调试。 	

注意

​				并非所有主机上都要求 `cephadm`，但在调查特定的守护进程时很有用。`cephadm-ansible 预flight` playbook 在所有主机上安装 `cephadm`，`cephadm-ansible 清除` playbook 要求在所有主机上安装 `cephadm` 才能正常工作。 		

- `add-repo`

  描述 								配置本地软件包存储库，以也包含 Ceph 存储库。这主要用于断开连接的红帽 Ceph 存储安装。 							语法`cephadm add-repo [--release *RELEASE*] [--version *VERSION*] [--repo-url *REPO_URL*]`示例`[root@host01 ~]# ./cephadm add-repo --version 15.2.1 [root@host01 ~]# ./cephadm add-repo --release pacific`

- `adopt`

  描述 								转换升级的存储集群守护进程，以运行 `cephadm`。 							语法`cephadm adopt [-h] --name *DAEMON_NAME* --style *STYLE* [--cluster *CLUSTER*] --legacy-dir [*LEGACY_DIR*] --config-json *CONFIG_JSON*] [--skip-firewalld] [--skip-pull]`示例`[root@host01 ~]# cephadm adopt --style=legacy --name prometheus.host02`

- `ceph-volume`

  描述 								此命令用于列出特定主机上的所有设备。在容器内运行 `ceph-volume` 命令，使用可插拔工具部署具有不同设备技术（如 `lvm` 或物理磁盘）的 OSD，并遵循可预测、可靠的方法来准备、激活和启动 OSD。 							语法`cephadm ceph-volume inventory/simple/raw/lvm [-h] [--fsid *FSID*] [--config-json *CONFIG_JSON*] [--config *CONFIG*, -c *CONFIG*] [--keyring *KEYRING*, -k *KEYRING*]`示例`[root@host01 ~]# cephadm ceph-volume inventory --fsid f64f341c-655d-11eb-8778-fa163e914bcc`

- `check-host`

  描述 								检查适合 Ceph 群集的主机配置。 							语法`cephadm check-host [--expect-hostname *HOSTNAME*]`示例`[root@host01 ~]# cephadm check-host --expect-hostname host02`

- `deploy`

  描述 								在本地主机上部署守护进程。 							语法`cephadm shell deploy *DAEMON_TYPE* [-h] [--name *DAEMON_NAME*] [--fsid *FSID*] [--config *CONFIG*, -c *CONFIG*] [--config-json *CONFIG_JSON*] [--keyring *KEYRING*] [--key *KEY*] [--osd-fsid *OSD_FSID*] [--skip-firewalld] [--tcp-ports *TCP_PORTS*] [--reconfig] [--allow-ptrace] [--memory-request *MEMORY_REQUEST*] [--memory-limit *MEMORY_LIMIT*] [--meta-json *META_JSON*]`示例`[root@host01 ~]# cephadm shell deploy mon --fsid f64f341c-655d-11eb-8778-fa163e914bcc`

- `enter`

  描述 								在运行的守护进程容器内运行交互式 shell。 							语法`cephadm enter [-h] [--fsid *FSID*] --name *NAME* [command [command …]]`示例`[root@host01 ~]# cephadm enter --name 52c611f2b1d9`

- `help`

  描述 								查看 `cephadm` 支持的所有命令。 							语法`cephadm help`示例`[root@host01 ~]# cephadm help`

- `install`

  描述 								安装软件包。 							语法`cephadm install *PACKAGES*`示例`[root@host01 ~]# cephadm install ceph-common ceph-osd`

- `inspect-image`

  描述 								检查本地 Ceph 容器镜像。 							语法`cephadm --image *IMAGE_ID* inspect-image`示例`[root@host01 ~]# cephadm --image 13ea90216d0be03003d12d7869f72ad9de5cec9e54a27fd308e01e467c0d4a0a inspect-image`

- `list-networks`

  描述 								列出 IP 网络。 							语法`cephadm list-networks`示例`[root@host01 ~]# cephadm list-networks`

- `ls`

  描述 								列出主机上 `cephadm` 已知的守护进程实例。您可以使用 `--no-detail` 命令加快运行速度，这会提供每个守护进程守护进程名称、fsid、style 和 systemd 单元的详细信息。您可以使用 `--legacy-dir` 选项指定用于搜索后台程序的旧基础目录。 							语法`cephadm ls [--no-detail] [--legacy-dir *LEGACY_DIR*]`示例`[root@host01 ~]# cephadm ls --no-detail`

- `logs`

  描述 								守护进程容器的打印 `journald` 日志.这类似于 `journalctl` 命令。 							语法`cephadm logs [--fsid *FSID*] --name *DAEMON_NAME* cephadm logs [--fsid *FSID*] --name *DAEMON_NAME* -- -n *NUMBER* # Last N lines cephadm logs [--fsid *FSID*] --name *DAEMON_NAME* -- -f # Follow the logs`示例`[root@host01 ~]# cephadm logs --fsid 57bddb48-ee04-11eb-9962-001a4a000672 --name osd.8 [root@host01 ~]# cephadm logs --fsid 57bddb48-ee04-11eb-9962-001a4a000672 --name osd.8 -- -n 20 [root@host01 ~]# cephadm logs --fsid 57bddb48-ee04-11eb-9962-001a4a000672 --name osd.8 -- -f`

- `prepare-host`

  描述 								为 `cephadm` 准备主机。 							语法`cephadm prepare-host [--expect-hostname *HOSTNAME*]`示例`[root@host01 ~]# cephadm prepare-host [root@host01 ~]# cephadm prepare-host --expect-hostname host03`

- `pull`

  描述 								拉取 Ceph 镜像。 							语法`cephadm [-h] [--image *IMAGE_ID*] pull`示例`[root@host01 ~]# cephadm --image 13ea90216d0be03003d12d7869f72ad9de5cec9e54a27fd308e01e467c0d4a0a pull`

- `registry-login`

  描述 								为经过身份验证的注册表提供 cephadm 登录信息。Cephadm 尝试将调用主机记录到该注册表。 							语法`cephadm registry-login --registry-url [*REGISTRY_URL*] --registry-username [*USERNAME*] --registry-password [*PASSWORD*] [--fsid *FSID*] [--registry-json *JSON_FILE*]`示例`[root@host01 ~]# cephadm registry-login --registry-url registry.redhat.io --registry-username myuser1 --registry-password mypassword1` 								您还可以使用包含登录信息格式的 JSON registry 文件，格式如下： 							语法`cat *REGISTRY_FILE* { "url":"*REGISTRY_URL*", "username":"*REGISTRY_USERNAME*", "password":"*REGISTRY_PASSWORD*" }`示例`[root@host01 ~]# cat registry_file { "url":"registry.redhat.io", "username":"myuser", "password":"mypass" } [root@host01 ~]# cephadm registry-login -i registry_file`

- `rm-daemon`

  描述 								删除特定的守护进程实例。如果您直接在主机上运行 `cephadm rm-daemon` 命令，但 命令删除了 守护进程，ceph `adm mgr` 模块会注意到缺少 守护进程并重新部署它。此命令存在问题，应该仅用于实验目的和调试。 							语法`cephadm rm-daemon [--fsid *FSID*] [--name *DAEMON_NAME*] [--force ] [--force-delete-data]`示例`[root@host01 ~]# cephadm rm-daemon --fsid f64f341c-655d-11eb-8778-fa163e914bcc --name osd.8`

- `rm-cluster`

  描述 								从运行它的特定主机上的存储集群中删除所有守护进程。与 to `rm-daemon` 类似，如果您以这种方式移除了几个守护进程，并且 Ceph 编排器没有暂停，并且其中一些守护进程属于非受管服务，ceph `adm` 编排器刚刚在此重新部署。 							语法`cephadm rm-cluster [--fsid *FSID*] [--force]`示例`[root@host01 ~]# cephadm rm-cluster --fsid f64f341c-655d-11eb-8778-fa163e914bcc`

- `rm-repo`

  描述 								删除软件包存储库配置。这主要用于断开连接的红帽 Ceph 存储安装。 							语法`cephadm rm-repo [-h]`示例`[root@host01 ~]# cephadm rm-repo`

- `run`

  描述 								在容器内运行 Ceph 守护进程，在前台运行。 							语法`cephadm run [--fsid *FSID*] --name *DAEMON_NAME*`示例`[root@host01 ~]# cephadm run --fsid f64f341c-655d-11eb-8778-fa163e914bcc --name osd.8`

- `shell`

  描述 								运行交互式 shell，该 shell 可通过禁止或指定的 Ceph 集群访问 Ceph 命令。您可以使用 `cephadm shell 命令进入 shell`，并在 shell 中运行所有编排器命令。 							语法`cephadm shell  [--fsid *FSID*] [--name *DAEMON_NAME*, -n *DAEMON_NAME*] [--config *CONFIG*, -c *CONFIG*] [--mount *MOUNT*, -m *MOUNT*] [--keyring *KEYRING*, -k *KEYRING*] [--env *ENV*, -e *ENV*]`示例`[root@host01 ~]# cephadm shell -- ceph orch ls [root@host01 ~]# cephadm shell`

- `unit`

  描述 								通过此操作启动、停止、重新启动、启用和禁用守护进程。这可在守护进程的 `systemd` 单元上运行。 							语法`cephadm unit [--fsid *FSID*] --name *DAEMON_NAME* start/stop/restart/enable/disable`示例`[root@host01 ~]# cephadm unit --fsid f64f341c-655d-11eb-8778-fa163e914bcc --name osd.8 start`

- `version`

  描述 								提供存储集群的版本。 							语法`cephadm version`示例`[root@host01 ~]# cephadm version`