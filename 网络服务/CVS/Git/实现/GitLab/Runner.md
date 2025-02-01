# GitLab Runner

[GitLab Runner](https://gitlab.com/gitlab-org/gitlab-runner) runs the CI/CD jobs defined in GitLab. GitLab Runner can run as a single binary and has no language-specific requirements. 
[GitLab Runner](https://gitlab.com/gitlab-org/gitlab-runner) 运行 GitLab 中定义的 CI/CD 作业。GitLab Runner 可以作为单个二进制文件运行，并且没有特定于语言的要求。

For security and performance reasons, install GitLab Runner on a machine separate from the machine that hosts your GitLab instance. 
出于安全和性能原因，请将 GitLab Runner 安装在与托管 GitLab 实例的计算机不同的计算机上。

## Supported operating systems 支持的操作系统

You can install GitLab Runner on: 
您可以在以下设备上安装 GitLab Runner：

- Linux from a [GitLab repository](https://docs.gitlab.com/17.5/runner/install/linux-repository.html) or [manually](https://docs.gitlab.com/17.5/runner/install/linux-manually.html)
  Linux 从 [GitLab 存储库](https://docs.gitlab.com/17.5/runner/install/linux-repository.html)或[手动](https://docs.gitlab.com/17.5/runner/install/linux-manually.html)
- [FreeBSD FreeBSD 软件](https://docs.gitlab.com/17.5/runner/install/freebsd.html)
- [macOS macOS 的](https://docs.gitlab.com/17.5/runner/install/osx.html)
- [Windows 窗户](https://docs.gitlab.com/17.5/runner/install/windows.html)

[Bleeding-edge binaries](https://docs.gitlab.com/17.5/runner/install/bleeding-edge.html) are also available. 
还提供[最前沿的二进制文件](https://docs.gitlab.com/17.5/runner/install/bleeding-edge.html)。

To use a different operating system, ensure the operating system can compile a Go binary. 
要使用其他操作系统，请确保操作系统可以编译 Go 二进制文件。

## Supported containers 支持的容器

You can install GitLab Runner with: 
您可以使用以下命令安装 GitLab Runner：

- [Docker 码头工人](https://docs.gitlab.com/17.5/runner/install/docker.html)
- [The GitLab Helm chart GitLab Helm 图表](https://docs.gitlab.com/17.5/runner/install/kubernetes.html)
- [The GitLab agent for Kubernetes
  适用于 Kubernetes 的 GitLab 代理](https://docs.gitlab.com/17.5/runner/install/kubernetes-agent.html)
- [The GitLab Operator GitLab 操作员](https://docs.gitlab.com/17.5/runner/install/operator.html)

## Supported architectures 支持的架构

GitLab Runner is available for the following architectures: 
GitLab Runner 可用于以下架构：

- x86
- AMD64 AMD64的
- ARM64 ARM64 的
- ARM 手臂
- s390x S390X系列
- ppc64le PPC64LE 系列

## System requirements 系统要求

The system requirements for GitLab Runner depend on the: 
GitLab Runner 的系统要求取决于：

- Anticipated CPU load of CI/CD jobs 
  CI/CD 作业的预期 CPU 负载
- Anticipated memory usage of CI/CD jobs 
  CI/CD 作业的预期内存使用情况
- Number of concurrent CI/CD jobs 
  并发 CI/CD 作业数
- Number of projects in active development 
  正在开发的项目数量
- Number of developers expected to work in parallel 
  预期并行工作的开发人员数量

For more information about the machine types available for GitLab.com, see [GitLab-hosted runners](https://docs.gitlab.com/17.5/ee/ci/runners/). 
有关可用于 GitLab.com 的机器类型的更多信息，请参阅[GitLab 托管的运行器](https://docs.gitlab.com/17.5/ee/ci/runners/)。

## FIPS-compliant GitLab Runner 符合 FIPS 标准的 GitLab Runner

A GitLab Runner binary compliant with FIPS 140-2 is available for Red Hat Enterprise Linux (RHEL) distributions and the AMD64 architecture. Support for other distributions and architectures is proposed in [issue 28814](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/28814). 
符合 FIPS 140-2 的 GitLab Runner 二进制文件可用于 Red Hat Enterprise Linux （RHEL） 发行版和 AMD64 架构。[Issue 28814](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/28814) 中提出了对其他发行版和体系结构的支持。

This binary is built with the [Red Hat Go compiler](https://developers.redhat.com/blog/2019/06/24/go-and-fips-140-2-on-red-hat-enterprise-linux) and calls into a FIPS 140-2 validated cryptographic library. A [UBI-8 minimal image](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index#con_understanding-the-ubi-minimal-images_assembly_types-of-container-images) is used as the base for creating the GitLab Runner FIPS image. 
此二进制文件使用 [Red Hat Go 编译器](https://developers.redhat.com/blog/2019/06/24/go-and-fips-140-2-on-red-hat-enterprise-linux)构建，并调用经过 FIPS 140-2 验证的加密库。[UBI-8 最小镜像](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index#con_understanding-the-ubi-minimal-images_assembly_types-of-container-images)用作创建 GitLab Runner FIPS 镜像的基础。

For more information about using FIPS-compliant GitLab Runner in RHEL, see [Switching RHEL to FIPS mode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/security_hardening/switching-rhel-to-fips-mode_security-hardening). 
有关在 RHEL 中使用符合 FIPS 的 GitLab Runner 的更多信息，请参阅[将 RHEL 切换到 FIPS 模式](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/security_hardening/switching-rhel-to-fips-mode_security-hardening)。