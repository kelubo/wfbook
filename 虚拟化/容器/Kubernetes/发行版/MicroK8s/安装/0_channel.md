# 选择对齐通道

[TOC]

上游 Kubernetes 大约每三个月发布一次新的版本系列（例如 1.27.x）。以前的版本系列可能会定期获得错误修复版本：例如，最新的 1.24 版本是 1.24.8。

## 选择正确的渠道

The channel  specified is made up of two components; the track and the risk level.  For example to install MicroK8s v1.29 with risk level set to stable:
安装 MicroK8s 时，可以指定一个频道。指定的通道由两个组件组成：跟踪和风险级别。例如，要安装风险级别设置为 stable 的 MicroK8s v1.29，您需要：

```bash
snap install microk8s --classic --channel=1.29/stable
```

The track denotes the upstream Kubernetes version while the risk level reflects the maturity level of the release. The  `stable` risk level indicates that your cluster is updated when the MicroK8s  team decides a release is ready and no issues have been revealed by  users running the same revision on riskier branches (edge and  candidate).
track 表示上游 Kubernetes 版本，而 Risk level 反映发布的成熟度级别。`stable` 的风险级别表示，当 MicroK8s 团队决定版本准备就绪时，您的集群已更新，并且在风险较高的分支（edge 和 candidate）上运行相同修订的用户未发现任何问题。

如果运行 `snap info microk8s`，则会显示所有当前可用的通道：

```bash
...
channels:
  1.29/stable:           v1.29.2  2024-03-07 (6641) 169MB classic
  1.29/candidate:        v1.29.3  2024-04-13 (6727) 170MB classic
  1.29/beta:             v1.29.3  2024-04-13 (6727) 170MB classic
  1.29/edge:             v1.29.4  2024-04-16 (6757) 170MB classic
  latest/stable:         v1.29.0  2024-01-25 (6364) 168MB classic
  latest/candidate:      v1.30.0  2024-04-18 (6776) 168MB classic
  latest/beta:           v1.30.0  2024-04-18 (6776) 168MB classic
  latest/edge:           v1.30.0  2024-04-19 (6798) 168MB classic
  1.30-strict/stable:    v1.30.0  2024-04-18 (6783) 168MB -
  1.30-strict/candidate: v1.30.0  2024-04-18 (6783) 168MB -
  1.30-strict/beta:      v1.30.0  2024-04-18 (6783) 168MB -
  1.30-strict/edge:      v1.30.0  2024-04-18 (6783) 168MB -
  1.30/stable:           v1.30.0  2024-04-18 (6782) 168MB classic
  1.30/candidate:        v1.30.0  2024-04-18 (6782) 168MB classic
  1.30/beta:             v1.30.0  2024-04-18 (6782) 168MB classic
  1.30/edge:             v1.30.0  2024-04-19 (6797) 168MB classic
  1.29-strict/stable:    v1.29.2  2024-02-20 (6529) 169MB -
  1.29-strict/candidate: v1.29.2  2024-02-20 (6529) 169MB -
  1.29-strict/beta:      v1.29.2  2024-02-20 (6529) 169MB -
  1.29-strict/edge:      v1.29.4  2024-04-16 (6756) 170MB -
  1.28-strict/stable:    v1.28.7  2024-02-20 (6532) 186MB -
  1.28-strict/candidate: v1.28.7  2024-02-20 (6532) 186MB -
  ...
```

如果在安装时未设置频道...

```bash
snap install microk8s --classic
```

…the snap install will default to the latest current stable version, e.g. ‘1.27/stable’.
…快照安装将默认为最新的当前稳定版本，例如 '1.27/stable'。

In this case you will get periodic snap updates to the current stable release at the time of the installation. Updates will **not** include a new series, only patch releases. This means that MicroK8s  should continue running normally, even when a new series is released.
在这种情况下，将在安装时获得对当前稳定版本的定期快照更新。更新将**不包括**新系列，仅包含补丁版本。这意味着 MicroK8s 应该继续正常运行，即使发布了新系列也是如此。

要使用特定版本的 Kubernetes，可以使用 `--channel` 选项。例如，要安装 MicroK8s 并让它遵循 `v1.24` 稳定版本系列，可以运行：

```bash
snap install microk8s --classic --channel=1.24/stable
```

在这种情况下，只会收到 Kubernetes 1.24 版本的更新，而 MicroK8s 永远不会升级到 1.25，除非您明确刷新快照。

## [Stable, candidate, beta and edge releases 稳定版、候选版、测试版和边缘版](https://microk8s.io/docs/setting-snap-channel#stable-candidate-beta-and-edge-releases)

The `*/stable` channels serve the latest stable upstream Kubernetes release of the  respective release series. Upstream releases are propagated to the  MicroK8s snap in about a week. This means your MicroK8s will upgrade to  the latest upstream release in your selected channel roughly one week  after the upstream release.
`*/stable` 通道为相应版本系列的最新稳定上游 Kubernetes 版本提供服务。上游版本将在大约一周内传播到 MicroK8s 快照。这意味着您的 MicroK8s 将在上游发布大约一周后升级到所选频道中的最新上游版本。

The `*/candidate` and `*/beta` channels get updated within hours of an upstream release. Getting a MicroK8s deployment pointing to `1.26/beta` is as simple as:
`*/candidate` 和 `*/beta` 通道会在上游发布后的数小时内更新。获取指向 `1.26/beta 版`的 MicroK8s 部署非常简单：

```bash
snap install microk8s --classic --channel=1.26/beta
```

The `*/edge` channels get updated on each MicroK8s patch or upstream Kubernetes patch release.
`*/edge` 通道在每个 MicroK8s 补丁或上游 Kubernetes 补丁版本上更新。

请记住，edge 和 beta 是快照结构，与特定的 Kubernetes 版本名称无关。

## [Tracks with pre-stable releases 具有预稳定版本的轨道](https://microk8s.io/docs/setting-snap-channel#tracks-with-pre-stable-releases)

On tracks where no stable Kubernetes release is available, MicroK8s ships pre-release versions under the following scheme:
在没有稳定 Kubernetes 版本的轨道上，MicroK8s 根据以下方案提供预发布版本：

- The `*/edge` channel (eg `1.26/edge`) holds the alpha upstream releases.
  `*/edge` 频道（例如 `1.26/edge`）保存 alpha 上游版本。
- The `*/beta` channel (eg `1.26/beta`) holds the beta upstream releases.
  `*/beta` 频道（例如 `1.26/beta`）保存 beta 上游版本。
- The `*/candidate` channel (eg `1.26/candidate`) holds the release candidate
  `*/candidate` 通道（例如 `1.26/candidate`）保存 release candidate
   of upstream releases. 的上游版本。

Pre-release versions will be available the same day they are released upstream.
预发布版本将在上游发布的同一天提供。

For example, to test your work against the alpha `v1.26` release simply run:
例如，要针对 alpha `v1.26` 版本测试您的工作，只需运行：

```bash
sudo snap install microk8s --classic --channel=1.26/edge
```

However, be aware that pre-release versions may require you to configure the Kubernetes services on your own.
但是，请注意，预发布版本可能需要您自己配置 Kubernetes 服务。

## [Strict confinement tracks 严格的禁闭轨道](https://microk8s.io/docs/setting-snap-channel#strict-confinement-tracks)

MicroK8s now supports a track which conforms to the `strict`mode of snap installs. Strictly confined MicroK8s is installed via the tracks that include strict in their name. For example:
MicroK8s 现在支持符合 `Strictly`快照安装模式的 track。严格受限的 MicroK8s 是通过名称中包含 strict 的轨道安装的。例如：

```auto
snap install microk8s --channel 1.26-strict
```

For more information on the differences between strictly-confined MicroK8s and the classic version, please see [this explanation](https://microk8s.io/docs/strict-confinement).
有关严格受限的 MicroK8s 和经典版本之间差异的更多信息，请参阅[此说明](https://microk8s.io/docs/strict-confinement)。

## 我很困惑。哪个频道适合我？

The single question you need to focus on is what channel should be used below:
您需要关注的唯一问题是下面应该使用哪个频道：

```bash
sudo snap install microk8s --classic --channel=<which_channel?>
```

Here are some suggestions for the channel to use based on your needs:
以下是频道根据您的需求使用的一些建议：

- 希望始终使用最新稳定的 Kubernetes。
  
  使用 `--channel=latest/stable`
  
- I want to always be on the latest release in a specific upstream K8s release.
  我希望始终使用特定上游 K8s 版本中的最新版本。

  – Use `--channel=<release>/stable`, eg `--channel=1.25/stable`.
  – 使用 `--channel=<release>/stable`，例如 `--channel=1.25/stable`。

- I want to test-drive a pre-stable release.
  我想试驾一个预稳定版本。

  – Use `--channel=<next_release>/edge` for alpha releases.
  – 使用 `--channel=<next_release>/edge` 进行 alpha 版本。

  – Use `--channel=<next_release>/beta` for beta releases.
  – 使用 `--channel=<next_release>/beta` 进行测试版发布。

  – Use `--channel=<next_release>/candidate` for candidate releases.
  – 用于 `--channel=<next_release>/candidate` 候选版本。

- I am waiting for a bug fix on MicroK8s:
  我正在等待 MicroK8s 的错误修复：

  – Use `--channel=<release>/edge`.
  – 使用 `--channel=<release>/edge`。

- I am waiting for a bug fix on upstream Kubernetes:
  我正在等待上游 Kubernetes 的错误修复：

  – Use `--channel=<release>/candidate`.
  – 使用 `--channel=<release>/candidate`。 

## 更改频道

It is possible to change the snap channel using the refresh command. E.g. to transition to the latest alpha:
可以使用 refresh 命令更改捕捉通道。例如，要过渡到最新的 alpha：

```bash
sudo snap refresh microk8s --channel=latest/edge
```

## [Changing the refresh schedule 更改刷新计划](https://microk8s.io/docs/setting-snap-channel#changing-the-refresh-schedule)

By default, snaps are set to check for updates and automatically refresh to the
默认情况下，捕捉设置为检查更新并自动刷新到
 latest version (for your selected channel) four times per day. For  deployments where this behavior is undesirable you are given the option  to postpone, schedule or even block automatic updates. The [snap refreshes page](https://microk8s.io/docs/snap-refreshes) outlines how to configure these options.
最新版本（适用于您选择的频道）每天四次。对于不希望出现此行为的部署，您可以选择推迟、计划甚至阻止自动更新。[snap refreshes 页面](https://microk8s.io/docs/snap-refreshes)概述了如何配置这些选项。