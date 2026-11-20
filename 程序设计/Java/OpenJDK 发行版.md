# OpenJDK 发行版：Temurin / Corretto / Zulu 怎么选

[TOC]

## OpenJDK 与发行版的关系

OpenJDK 是 Java Platform, Standard Edition（Java SE）的免费开源参考实现，源码公开。各家拿同一份上游源码自行构建、打包、提供更新和安全支持，就形成了不同的**发行版（distribution）**。

发行版 ≠ Java 版本。`java -version` 里的 `17`、`21` 是语言/平台版本，由版本号决定；Temurin、Corretto、Zulu 只是同一版本的不同"牌子"，核心功能基本等价。差别主要在维护方、支持周期、发布节奏和附加服务。

## 三大发行版对比

| 发行版 | 维护方 | 授权 | 定位与特点 |
|---|---|---|---|
| **Eclipse Temurin** | Eclipse 基金会（Adoptium 项目） | 免费、开源 | AdoptOpenJDK 于 2021 年并入 Eclipse 基金会后改名而来。社区驱动，通过 AQAvit 质量认证，多平台覆盖，是最主流的中立选择 |
| **Amazon Corretto** | Amazon | 免费 | 2018 年推出，提供长期支持（LTS）与季度更新，针对 AWS 环境（Amazon Linux / EC2）优化，提供容器镜像 |
| **Azul Zulu** | Azul Systems | 免费社区版 + 付费企业版（Azul Platform Core） | 商业 JVM 厂商出品，平台覆盖最广（含 Windows ARM、嵌入式、特殊架构），付费版带商业支持 |

### Eclipse Temurin

- 官网：<https://adoptium.net/>，项目页 <https://adoptium.net/temurin/>
- 支持平台清单：<https://adoptium.net/supported-platforms/>
- Docker 官方镜像：`eclipse-temurin`（Docker Hub 官方镜像）
- 包仓库：`packages.adoptium.net` 提供 RPM/DEB 安装包；也提供 MSI、归档包和 API（<https://api.adoptium.net/>）
- 各版本都带 JDK Flight Recorder（JFR），可用 JDK Mission Control（JMC）分析；从 11 起包含 Shenandoah GC
- LTS 版本为 8u、11u、17u（后续 LTS 依上游节奏延续）

适用场景：想要免费、可靠、不绑定特定云厂商的 JDK，开发或生产都适用。

### Amazon Corretto

- 官网：<https://aws.amazon.com/corretto/>
- Docker 镜像：`amazoncorretto`
- 提供 LTS 版本（Corretto 8/11/17/21 等），季度更新，免费用于生产环境
- 在 Amazon Linux 上集成最好，aws 官方 AMI 常预装

适用场景：业务跑在 AWS 上（EC2、EKS、Lambda 自定义运行时等），或希望获得厂商维护的免费 LTS 构建。

### Azul Zulu

- 官网：<https://www.azul.com/downloads/>
- Docker 镜像：`azul/zulu-openjdk`
- 分免费社区版（Zulu Community）和付费企业版（现名 Azul Platform Core），后者提供商业支持与 SLA
- Azul 是该领域老牌商业公司，另有高性能 JVM 产品 Zing / Prime
- 覆盖平台最广：Windows、Linux、macOS，以及 ARM、嵌入式等少见架构

适用场景：需要商业支持与合规保障，或部署在冷门平台/架构上。

## 其他常见发行版

| 发行版 | 来源 | 备注 |
|---|---|---|
| Microsoft Build of OpenJDK | Microsoft | 免费，对 Azure / Windows 有优化 |
| Liberica JDK | BellSoft | 免费版 + 商业版， embedded 与 Alpine 支持好 |
| SapMachine | SAP | SAP 维护，SAP 应用场景优化 |
| Oracle OpenJDK | Oracle | 免费构建，但更新周期短（半年），长期支持需商业授权 |
| Red Hat build of OpenJDK | Red Hat | RHEL 上通过 `yum` 安装（`java-17-openjdk` 等），带 FIPS / 加密策略集成 |
| GraalVM | Oracle | 基于 OpenJDK 但路线不同，主打 AOT 原生镜像与多语言 |

> 注意：Oracle JDK 与新版 JDK 的商用授权规则变化频繁，生产环境选型前请核对当前许可条款。

## 选型速查

- **通用免费、要稳妥中立**：Temurin。
- **在 AWS 上跑**：Corretto。
- **要商业支持 / SLA，或特殊架构**：Zulu（付费版）。
- **RHEL 环境**：直接用系统自带的 Red Hat build of OpenJDK，与发行版配套的 FIPS、加密策略、debug 符号集成省事；本目录 `JDK.md` 收录的红帽官方文档就是讲这个（含 Temurin 入门章节的下载与安装步骤）。

## 相关文件

- `JDK.md`：Red Hat OpenJDK 17 官方文档译文合集，涵盖 RHEL 上的安装、版本切换（`alternatives`）、`JAVA_HOME`、堆大小、调试符号、`jlink` 定制运行时、Shenandoah GC 等，其中"Eclipse Temurin 入门"一节讲 Temurin 的下载渠道与发行选择。
- `Java.md`：Java 语言入门笔记（起源、特点等）。
