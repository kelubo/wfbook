# OpenHPC

[TOC]

## 概述

OpenHPC is a collaborative, community effort that  initiated from a desire to aggregate a number of common ingredients  required to deploy and manage High Performance Computing (HPC) Linux  clusters including provisioning tools, resource management, I/O clients, development tools, and a variety of scientific libraries. 

OpenHPC 是一个协作的社区项目，最初的愿望是聚合部署和管理高性能计算（HPC）Linux 集群所需的许多常见成分，包括配置工具、资源管理、I/O 客户端、开发工具和各种科学库。

Packages  provided by OpenHPC have been pre-built with HPC integration in mind  with a goal to provide re-usable building blocks for the HPC community.  Over time, the community also plans to identify and develop abstraction  interfaces between key components to further enhance modularity and  interchangeability. 
OpenHPC 提供的软件包已经预先构建了 HPC 集成，目标是为 HPC 社区提供可重用的构建块。随着时间的推移，社区还计划识别和开发关键组件之间的抽象接口，以进一步增强模块化和可重用性。该社区包括来自各种来源的代表，包括软件供应商，设备制造商，研究机构，超级计算站点等。

This community works to integrate a multitude of components that are  commonly used in HPC systems, and are freely available for open source  distribution. We are grateful for the efforts undertaken by the  developers and maintainers of these upstream communities that provide  key components used in HPC around the world today, and for which this  OpenHPC community works to integrate and validate as a cohesive software stack. 
该社区致力于集成 HPC 系统中常用的大量组件，并可免费用于开源分发。我们感谢这些上游社区的开发人员和维护人员所做的努力，这些社区提供了当今世界 HPC 中使用的关键组件，OpenHPC 社区致力于将其集成和验证为一个有凝聚力的软件堆栈。

## 愿景/使命

### 使命

OpenHPC  是一个 [Linux 基金会](http://www.linuxfoundation.org/)协作项目，其使命是提供开源 HPC 软件组件和最佳实践的参考集合，降低部署、推进和使用现代 HPC 方法和工具的障碍。

### 愿景

OpenHPC components and best practices will enable and accelerate innovation and discoveries by broadening access to state-of-the-art, open-source HPC  methods and tools in a consistent environment, supported by a  collaborative, worldwide community of HPC users, developers,  researchers, administrators, and vendors.
OpenHPC 组件和最佳实践将通过在一致的环境中扩大对最先进的开源 HPC 方法和工具的访问来实现和加速创新和发现，并得到 HPC 用户，开发人员，研究人员，管理员和供应商的协作全球社区的支持。

## 源储存库

与 OpenHPC 集成工作相关的所有源资料都使用 git 进行管理，并托管在 GitHub 上的以下位置：

https://github.com/openhpc/ohpc

git 仓库的顶层组织分为三个主要类别：

- components/
- docs/
- tests/

### Components

The components/ directory houses all of the build-related and packaging  collateral for each individual packages currently included within  OpenHPC. 组件/目录包含 OpenHPC 中当前包含的每个单独软件包的所有构建相关和打包资料。这通常包括诸如 RPM .spec 文件和在构建期间应用的任何修补程序之类的项目。请注意，软件包通常按功能分组，并确定了以下功能分组：

- admin/  – 管理工具
- compiler-families/ – compiler toolchains for which development libraries are built against
  编译器系列/编译器工具链，开发库是针对其构建的
- dev-tools/ – 各种配套的面向开发的工具
- distro-packages/ – OS/distro related packages (these are generally included as dependencies for other OpenHPC packages)
  发行版包/ -操作系统/发行版相关包（这些通常作为其他OpenHPC包的依赖项包含）
- io-libs/ – 各种 I/O 库
- lustre/ – Lustre 客户端
- mpi-families/ – MPI toolchains for which parallel development libraries are built against
  mpi-families/ -并行开发库所针对的MPI工具链
- parallel-libs/ – variety of parallel development/scientific libraries
  parallel-libs/ - variety of parallel development/scientific libraries
- perf-tools/ – 性能分析工具集合
- provisioning/ – 用于裸机资源调配的工具
- rms/ – 资源管理服务
- serial-libs/ – collection of (non-MPI) libraries
  serial-libs/ - collection of（non-MPI）libraries（非MPI库）

Note that the above functionality groupings are also used to organize  work-item issues on the OpenHPC GitHub site via labels assigned to each  component.
请注意，上述功能分组还用于通过分配给每个组件的标签来组织OpenHPC GitHub站点上的工作项问题。

### Documentation

The documentation is typeset  using [LaTeX](https://www.latex-project.org/) and companion parsing utilities are used to derive automated installation  scripts directly from the raw LatTeX files in order to validate the  embedded instructions as part of the continuous integration (CI)  process.
GitHub 存储库中的 docs/ 目录包含利用 OpenHPC 打包组件的相关安装方法。文档使用 [LaTeX](https://www.latex-project.org/) 进行排版，配套的解析实用程序用于直接从原始 LatTeX 文件中导出自动安装脚本，以验证作为持续集成（CI）过程一部分的嵌入式指令。最新文档产品的副本可在[下载](http://openhpc.community/downloads/)页面上获得。

### Tests

An important aspect of the OpenHPC effort is the companion integration  testing effort that is performed. To help support this effort, the  tests/ directory houses a standalone integration test that is used  during the CI process. This test harness is autotools based and is  intended to test some basic functionality of OpenHPC provided components post-installation. To mimic end-user usage, it makes extensive use of  the underlying resource manager and the modules system to perform  compilation/execution against packaged development libraries.  The test  harness has two modes of operation which are designed to cover a broad  spectrum of tests:
OpenHPC 工作的一个重要方面是执行的配套集成测试工作。为了帮助支持这项工作，tests/ 目录包含了一个在 CI 过程中使用的独立集成测试。此测试工具基于autotools，旨在测试 OpenHPC提 供的组件安装后的一些基本功能。为了模拟最终用户的使用，它广泛使用了底层资源管理器和模块系统来对打包的开发库执行编译/执行。测试线束具有两种操作模式，旨在涵盖广泛的测试范围：

- tests requiring elevated credentials
  需要更高证书的测试
- tests as a normal user
  作为普通用户进行测试

 ![](../../Image/o/openhpc_overview.png)

## 集成约定

### 路径约定

When practical, OpenHPC packaging endeavors to install into a consistent  directory organization (although some packages that are not easily  amenable to non-default path installations do not follow this strategy).  The typical top-level organizing installation path is:
在实际情况下，OpenHPC 打包会努力安装到一致的目录组织中（尽管某些不容易接受非默认路径安装的包不遵循此策略）。典型的顶层组织安装路径是：

/opt/ohpc

A variety of pre-defined RPM macro definitions are used to organize  installations underneath this top-level path. These definitions are  housed in the components/OHPC_macros file and a subset of this file is  shown here to illustrate common macro names available for use by  packagers:
各种预定义的RPM宏定义用于组织此顶级路径下的安装。这些定义位于components/OHPC_macros文件中，此处显示此文件的一个子集，以说明可供打包程序使用的常用宏名称：

```bash
%global PROJ_NAME ohpc 
%global OHPC_HOME /opt/%{PROJ_NAME} 
%global OHPC_ADMIN %{OHPC_HOME}/admin 
%global OHPC_PUB %{OHPC_HOME}/pub 
%global OHPC_APPS %{OHPC_PUB}/apps 
%global OHPC_COMPILERS %{OHPC_PUB}/compiler 
%global OHPC_LIBS %{OHPC_PUB}/libs 
%global OHPC_MODULES %{OHPC_PUB}/modulefiles 
%global OHPC_MODULEDEPS %{OHPC_PUB}/moduledeps 
%global OHPC_MPI_STACKS %{OHPC_PUB}/mpi 
%global OHPC_UTILS %{OHPC_PUB}/utils
```

Note that the naming scheme is organized around functionality with separate  macros defined for compilers, mpi toolchains, 3rd party libraries, and  modulefiles.
请注意，命名方案是围绕功能组织的，为编译器、mpi工具链、第三方库和模块文件定义了单独的宏。

### 命名约定

In addition to a set of path conventions, the RPM naming for scheme  OpenHPC packages also strives for consistency. To avoid potential  conflicts with other packaging repositories, OpenHPC packages are  appended with a common delimiter of “-ohpc“.  Also, since OpenHPC  supports a variety of compiler and MPI toolchains, multiple builds for  the same component package are necessary and are reflected in the RPM  naming scheme.
除了一组路径约定之外，方案OpenHPC包的RPM命名也力求一致。为了避免与其他打包存储库的潜在冲突，OpenHPC包附加了一个通用的“-ohpc”字符串。此外，由于OpenHPC支持各种编译器和MPI工具链，因此同一组件包的多个构建是必要的，并反映在RPM命名方案中。

The general naming convention  is to append the compiler and MPI family  name that the library was built against directly into the package name.  For example, libraries that do not require MPI as part of the build  process adopt the following RPM name:
一般的命名约定是将编译器和MPI系列名称直接附加到包名称中。例如，不需要MPI作为构建过程一部分的库采用以下RPM名称：

```bash
package-<compiler family>-ohpc-<package version>-<release>.rpm
```

Packages that require MPI as part of the build expand upon this convention to  additionally include the MPI family name as follows:
需要MPI作为构建的一部分的软件包在此约定的基础上扩展，以额外包括MPI系列名称，如下所示：

```bash
package-<compiler family>-<mpi family>-ohpc-<package version>-<release>.rpm
```

### 模块约定

In order to provide a flexible development environment, OpenHPC adopts the use of modules (via [Lmod](https://github.com/TACC/Lmod)) and includes creation of module files for relevant components as part  of the build process. If you are not familiar with modules, they provide a convenient way to setup standard environment variables  (e.g. PATH, LD_LIBRARY_PATH, etc) in your shell in order to access and  compile against provided software components.  Furthermore, OpenHPC  leverages the hierarchical capability of [Lmod](https://github.com/TACC/Lmod) to ensure a consistent development environment is maintained.  In addition to setting common environment variables  like PATH and LD_LIBRARY_PATH, the packaging conventions also define a  set of component-specific environment variables that provide convenience mapping to the top-level install path and location of component  binaries, development (header) files, libraries, and documentation.  To illustrate this convention and resulting environment variable names,  the following highlights the relevant modulefile commands included in  the .spec file for the Adios package.
为了提供一个灵活的开发环境，OpenHPC采用了模块的使用（通过[Lmod](https://github.com/TACC/Lmod)），并将为相关组件创建模块文件作为构建过程的一部分。如果您不熟悉模块，它们提供了一种方便的方法来在您的shell中设置标准环境变量（例如PATH，LD_LIBRARY_PATH等），以便访问和编译提供的软件组件。  此外，OpenHPC利用[Lmod](https://github.com/TACC/Lmod)的分层功能来确保维护一致的开发环境。   除了设置PATH和LD_LIBRARY_PATH这样的公共环境变量外，打包约定还定义了一组特定于组件的环境变量，这些环境变量提供了到顶层安装路径和组件二进制文件、开发（头）文件、库和文档的位置的方便映射。   为了说明这种约定和产生的环境变量名称，下面突出显示了Adios包的.spec文件中包含的相关modulefile命令。

```bash
%{__mkdir} -p %{buildroot}%{OHPC_MODULEDEPS}/%{compiler_family}-%{mpi_family}/%{pname}
%{__cat} << EOF > %{buildroot}/%{OHPC_MODULEDEPS}/%{compiler_family}-%{mpi_family}/%{pname}/%{version}
...
setenv ADIOS_DIR %{install_path}
setenv ADIOS_DOC %{install_path}/docs
setenv ADIOS_BIN %{install_path}/bin
setenv ADIOS_LIB %{install_path}/lib
setenv ADIOS_INC %{install_path}/include
EOF
```

Note that the %{} macro variables referenced in the above would have all  been been defined previously in the .spec file. See the [Build Environment](https://openhpc.community/development/build-environment/) discussion for more information regarding the %{compiler_family} and %{mpi_family} definitions.
请注意，上面引用的%{}宏变量之前都已在.spec文件中定义。有关%{compiler_family}和%{mpi_family}定义的详细信息，请参阅[生成环境](https://openhpc.community/development/build-environment/)讨论。

## 构建环境

The community build infrastructure uses a standalone instance of the [Open Build Service](http://openbuildservice.org/) to automate the build and release of a variety of RPMs under the auspices  of the OpenHPC project. When combined with a matching base OS install,  the collection of assembled tools and development packages can be used  to deploy HPC Linux clusters.  The public build system is available at:
社区构建基础设施使用 [Open Build Service](http://openbuildservice.org/) 的独立实例，在OpenHPC 项目的支持下自动构建和发布各种 RPM 。当与匹配的基本操作系统安装结合使用时，组装的工具和开发包集合可用于部署 HPC Linux 集群。  公共构建系统可在以下网址获得：

[https://obs.openhpc.community](https://obs.openhpc.community/)

Information on how to enable a package repository hosted from this site is outlined separately in the [Downloads](https://openhpc.community/downloads/) area.
有关如何启用从该站点托管的软件包存储库的信息在[下载](https://openhpc.community/downloads/)区域中单独列出。

Note that OpenHPC’s OBS instance is integrated with the GitHub repository  such that commits made on key branches within git will trigger  corresponding rebuilds in OBS. OBS also tracks inter-package  dependencies such that downstream packages are rebuilt as well.  The  configuration of the OpenHPC component packages within OBS is  purposefully designed to accommodate the hierarchical nature of the  stack, with special treatment applied to packages that have a compiler  or MPI toolchain dependency. In particular, the design philosophy is to  maintain a single set of inputs that are capable of generating builds  for a variety of toolchains.  To help support this effort, many of the  OpenHPC .spec files make use of template code to support multiple  toolchains and define appropriate package dependencies. An example  snippet from the Adios .spec  file outlining this approach is  highlighted below. Note that unless specified otherwise, the default  toolchain combination for the build is identified as the gnu compiler  and openmpi toolchain. However, the .spec file can be used to perform  builds for any supported toolchain by overriding  the %{compiler_family} and %{mpi_family} macros and the OpenHPC OBS  design uses this fact combined with an OBS capability to define package  links. The net effect is that a single commit to the git repository will trigger rebuilds in OBS for each supported toolchain combination for a  given package, all from a single set of inputs.
请注意，OpenHPC的OBS实例与GitHub存储库集成，因此在git内的关键分支上进行的提交将触发OBS中的相应重建。OBS还跟踪包间依赖关系，以便下游包也会重建。OBS中OpenHPC组件包的配置是专门设计的，以适应堆栈的分层性质，并对具有编译器或MPI工具链依赖性的包进行特殊处理。特别是，设计理念是维护一组能够为各种工具链生成构建的输入。为了帮助支持这项工作，许多OpenHPC .spec文件使用模板代码来支持多个工具链并定义适当的包依赖项。下面突出显示了Adios.spec文件中概述这种方法的示例片段。  请注意，除非另有说明，否则构建的默认工具链组合被标识为gnu编译器和openmpi工具链。但是，通过覆盖%{compiler_family}和%{mpi_family}宏，.spec文件可用于为任何受支持的工具链执行构建，OpenHPC  OBS设计将此事实与OBS功能结合使用来定义包链接。最终效果是，对git存储库的单个提交将触发给定包的每个支持的工具链组合在OBS中的重建，所有这些都来自一组输入。

```bash
# OpenHPC convention: the default assumes the gnu compiler family; however, this can be 
# overridden by specifying the compiler_family variable via rpmbuild or other mechanisms.

%{!?compiler_family: %global compiler_family gnu7}
%{!?mpi_family: %global mpi_family openmpi}

# Compiler dependencies
%if 0%{?ohpc_compiler_dependent} == 1

%if "%{compiler_family}" == "gnu7"
BuildRequires: gnu7-compilers%{PROJ_DELIM} >= 7.1.0
Requires:      gnu7-compilers%{PROJ_DELIM} >= 7.1.0
%endif
%if "%{compiler_family}" == "intel"
BuildRequires: gcc-c++ intel-compilers-devel%{PROJ_DELIM}
Requires:      gcc-c++ intel-compilers-devel%{PROJ_DELIM}
%if 0%{OHPC_BUILD}
BuildRequires: intel_licenses
%endif
%endif

# MPI dependencies
%if 0%{?ohpc_mpi_dependent} == 1
%if "%{mpi_family}" == "impi"
BuildRequires: intel-mpi-devel%{PROJ_DELIM}
Requires:      intel-mpi-devel%{PROJ_DELIM}
%global __requires_exclude ^libmpi\\.so.*$|^libmpifort\\.so.*$|^libmpicxx\\.so.*$
%endif
%if "%{mpi_family}" == "mpich"
BuildRequires: mpich-%{compiler_family}%{PROJ_DELIM}
Requires:      mpich-%{compiler_family}%{PROJ_DELIM}
%endif
%if "%{mpi_family}" == "mvapich2"
BuildRequires: mvapich2-%{compiler_family}%{PROJ_DELIM}
Requires:      mvapich2-%{compiler_family}%{PROJ_DELIM}
%endif
%if "%{mpi_family}" == "openmpi"
BuildRequires: openmpi-%{compiler_family}%{PROJ_DELIM}
Requires:      openmpi-%{compiler_family}%{PROJ_DELIM}
%endif
%endif
```

## FAQ

### [OpenHPC的发布周期是什么？](https://openhpc.community/support/faq/#)

We strive to make incremental updates at roughly 6 months intervals.  Release history and roadmap information can be found on the [GitHub Wiki](https://github.com/openhpc/ohpc/wiki/Release-History-and-Roadmap).
我们努力在大约6个月的时间间隔进行增量更新。发布历史和路线图信息可以在[GitHub Wiki](https://github.com/openhpc/ohpc/wiki/Release-History-and-Roadmap)上找到。

### [OpenHPC的总体支持计划是什么？](https://openhpc.community/support/faq/#)

OpenHPC offers community driven support via several [email lists](http://openhpc.community/support/mail-lists/) for end users and developers.
OpenHPC通过多[个电子邮件列表](http://openhpc.community/support/mail-lists/)为最终用户和开发人员提供社区驱动的支持。

### [OpenHPC中包含哪些工具集？](https://openhpc.community/support/faq/#)

Please see the Component List page on the [GitHub Wiki](https://github.com/openhpc/ohpc/wiki/) for the latest list of packages. In addition, the documentation for each  release includes a manifest of pre-packaged components (and their  version info).
请参阅[GitHub Wiki](https://github.com/openhpc/ohpc/wiki/)上的组件列表页面以获取最新的软件包列表。此外，每个版本的文档都包括预打包组件的清单（及其版本信息）。

### [Is it required that all components from the stack be used or can you pick and choose? 是否需要使用堆栈中的所有组件，或者您可以挑选？](https://openhpc.community/support/faq/#)

No, it is not required to install all components. In particular,  development tools and libraries can be chosen based on local application requirements. Note, however, that package dependencies are includes as  part of the OpenHPC integration effort, so sub dependencies may be  required in order to install particular components.
不，不需要安装所有组件。特别是，可以根据本地应用程序的要求选择开发工具和库。但是，请注意，包依赖关系是作为OpenHPC集成工作的一部分包含的，因此可能需要子依赖关系才能安装特定组件。

### [How can one view the dependencies of packages and the resulting growth in code size as packages are added? 如何查看软件包的依赖关系以及随着软件包的添加而导致的代码大小的增长？](https://openhpc.community/support/faq/#)

Package dependencies can be ascertained via package manager tools during  installation from an OpenHPC repository (or mirror). Similarly, the  repository size can also be queried via standard package manager tools  (e.g. “dnf repoinfo”).
在从OpenHPC存储库（或镜像）安装期间，可以通过包管理器工具确定包依赖关系。类似地，存储库的大小也可以通过标准的包管理器工具（例如“dnf repoinfo”）来查询。

### [Is the base OS included in with the stack? 基本操作系统是否包含在堆栈中？](https://openhpc.community/support/faq/#)

No. A supported base operating system should be installed first.
号应首先安装受支持的基本操作系统。

### [构建和测试环境是什么意思？](https://openhpc.community/support/faq/#)

The build environment refers to the Open Build Service (OBS) that serves as the underlying build infrastructure. It initiates package builds based  on commit triggers, tracks inter-package dependencies, and publishes  resulting repositories. The test environment corresponds to the use of  continuous integration (CI) infrastructure and the companion OpenHPC  test suite to carry out a variety of integration oriented tests as the  project evolves.
构建环境指的是作为底层构建基础设施的开放构建服务（Open Build  Service，OBS）。它基于提交触发器启动包构建，跟踪包间依赖关系，并发布结果存储库。测试环境对应于使用持续集成（CI）基础设施和配套的OpenHPC测试套件，以随着项目的发展执行各种面向集成的测试。

### [How is the OpenHPC stack validated? 如何验证OpenHPC堆栈？](https://openhpc.community/support/faq/#)

Included within OpenHPC is an integration test suite that is executed on a  variety of cluster platforms prior to release. The intent of this suite  is to ensure basic functionality of each tested component when installed on a cluster beginning with a bare metal installation.
OpenHPC中包括一个集成测试套件，在发布之前在各种集群平台上执行。此套件的目的是确保每个已测试组件在安装到群集上（从裸机安装开始）时的基本功能。

### [How were the initial packages for the stack selected? 堆栈的初始包是如何选择的？](https://openhpc.community/support/faq/#)

Package selection was prioritized initially with an initial goal of being able  to provide basic end-to-end functionality for common services typical of HPC deployments. The initial functionality includes example  provisioning and resource management services along with a variety of  administrative utilities and development tools/libraries.
软件包的选择最初是按照优先顺序进行的，最初的目标是能够为HPC部署的常见服务提供基本的端到端功能。初始功能包括示例供应和资源管理服务沿着以及各种管理实用程序和开发工具/库。

### [How are future packages for the stack selected? 如何为堆栈选择未来的包？](https://openhpc.community/support/faq/#)

Package selection will be prioritized based on a number of factors  including (but not limited to) its relevance and usage by the HPC  community, development stability, required integration effort,  coexistence capability with other included packages, functionality  coverage, and willingness of community members to help integrate and  maintain the package. Requests for package inclusion can be made in our [Submission Repository](https://github.com/openhpc/submissions/issues/new).
软件包的选择将根据许多因素进行优先排序，包括（但不限于）HPC社区的相关性和使用情况、开发稳定性、所需的集成工作、与其他包含的软件包的共存能力、功能覆盖范围以及社区成员帮助集成和维护软件包的意愿。可以在我们[的提交库中](https://github.com/openhpc/submissions/issues/new)请求包含软件包。

## 下载

There are currently two release tracks of OpenHPC, both consisting of binary  downloads in the form of RPMs. These RPMs are organized into  repositories that can be accessed via standard package manager utilities (e.g. dnf, zypper). The [2.x](https://github.com/openhpc/ohpc/wiki/2.x) track of OpenHPC provides builds that are compatible with RHEL 8.x and  tested against AlmaLinux and Rocky Linux as well as openSUSE Leap 15.3  and the [3.x](https://github.com/openhpc/ohpc/wiki/3.x) track builds against RHEL 9.x, openSUSE Leap 15.5 and openEuler 22.03  LTS . A typical deployment on a new system will begin with the  installation of the base operating system on a chosen host identified as the system management server (SMS), followed by enabling access to a  compatible OpenHPC repository.
OpenHPC 目前有两个发行版，都是以 RPM 的形式下载的二进制文件。这些 RPM 被组织到可以通过标准包管理器实用程序（例如 dnf，zypper）访问的存储库中。

OpenHPC的[2.x](https://github.com/openhpc/ohpc/wiki/2.x)轨道提供与RHEL 8.x兼容的构建，并针对Alma Linux和Rocky Linux以及openSUSE Leap 15.3进行了测试，而[3.x](https://github.com/openhpc/ohpc/wiki/3.x)轨道构建针对RHEL 9.x，openSUSE Leap 15.5和openEuler 22.03 LTS进行了测试。在新系统上的典型部署开始是在选定的主机上安装基本操作系统（标识为系统管理服务器（SMS）），然后启用对兼容OpenHPC存储库的访问。

The OpenHPC repository is created and maintained using a [dedicated instance](https://obs.openhpc.community/) of the [Open Build Service](https://openbuildservice.org/) (OBS). Once built by OBS, packages are released at [https://repos.openhpc.community](https://repos.openhpc.community/).
OpenHPC存储库是使用[Open Build Service](https://openbuildservice.org/)（OBS）的[专用实例](https://obs.openhpc.community/)创建和维护的。一旦由OBS构建，软件包将在[https://repos.openhpc.community](https://repos.openhpc.community/)上发布。

To get started, you can enable an OpenHPC repository locally through  installation of an ohpc-release RPM which includes gpg keys for package  signing and defines the URL locations for [base] and [update] package  repositories. A copy of the ohpc-release RPM is available for download  here:
要开始使用，您可以通过安装ohpc版本RPM在本地启用OpenHPC存储库，该RPM包含用于包签名的gpg密钥，并定义[base]和[update]包存储库的URL位置。可在此处下载ohpc版本RPM的副本：

### 2.x系列：

- [CentOS 8 ‘ohpc-release-2.0’ (aarch64)](https://repos.openhpc.community/OpenHPC/2/CentOS_8/aarch64/ohpc-release-2-1.el8.aarch64.rpm) (md5sum:27681582824037843d9e38dd063c8e57)
- [CentOS 8 ‘ohpc-release-2.0’ (x86_64)](https://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm) (md5sum:2e7924faa925d4f9078749092749242d)
- [Leap 15 ‘ohpc-release-2.0’ (aarch64)](https://repos.openhpc.community/OpenHPC/2/Leap_15/aarch64/ohpc-release-2-1.leap15.aarch64.rpm) (md5sum:7d57d55fc95cf6a49cf1ae9a4a6403cf)
- [Leap 15 ‘ohpc-release-2.0’ (x86_64)](https://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm) (md5sum:156d2919b4659b5f15f7706945527cd2)

### 3.x系列：

- [‘ohpc-release-3’ for EL9 (aarch64)](https://repos.openhpc.community/OpenHPC/3/EL_9/aarch64/ohpc-release-3-1.el9.aarch64.rpm) (md5sum:03ffb92167272274298ed17a333dba99)
- [‘ohpc-release-3’ for EL9 (x86_64)](http://repos.openhpc.community/OpenHPC/3/EL_9/x86_64/ohpc-release-3-1.el9.x86_64.rpm) (md5sum:f577ab5bb99f131b52277e4e77dfccfe)
- [‘ohpc-release-3’ for Leap 15.5 (aarch64)](https://repos.openhpc.community/OpenHPC/3/Leap_15/aarch64/ohpc-release-3-1.leap15.aarch64.rpm) (md5sum:4621cd47e119ceadd1db00dfebd105d1)
- [‘ohpc-release-3’ for Leap 15.5 (x86_64)](https://repos.openhpc.community/OpenHPC/3/Leap_15/x86_64/ohpc-release-3-1.leap15.x86_64.rpm) (md5sum:458c38d67a3aae6dd51a01bf1936ee14)
- [‘ohpc-release-3’ for openEuler 22.03 LTS (aarch64)](https://repos.openhpc.community/OpenHPC/3/openEuler_22.03/aarch64/ohpc-release-3-1.oe2203.aarch64.rpm) (md5sum:74bd46f701cf7887f06e1322e8661123)
- [‘ohpc-release-3’ for openEuler 22.03 LTS (x86_64)](http://repos.openhpc.community/OpenHPC/3/openEuler_22.03/x86_64/ohpc-release-3-1.oe2203.x86_64.rpm) (md5sum:7e4584244778b968b27aba151653f747)

### Install Recipes 安装食谱

To aid in the installation of OpenHPC packaged components, a variety of  companion installation recipes are available. These can be obtained via  installation of the docs-ohpc RPM after the OpenHPC repository has been  enabled locally. Alternatively, copies of the guides are also provided  for each release track on the OpenHPC GitHub Wiki:
为了帮助安装OpenHPC打包组件，提供了各种配套安装方法。在本地启用OpenHPC存储库后，可以通过安装docs-ohpc RPM获得这些信息。或者，OpenHPC GitHub Wiki上也为每个发布轨道提供了指南的副本：

- [OpenHPC 2.x](https://github.com/openhpc/ohpc/wiki/2.x)
- [OpenHPC 3.x](https://github.com/openhpc/ohpc/wiki/3.x)

The intent of these guides is to present a simple cluster installation  procedure using components from the OpenHPC software stack. The  documentation is intended to be reasonably generic, but uses the  underlying motivation of a small, stateless cluster installation to  define a step-by-step process. Several optional customizations are  included and the intent is that these collective instructions can be  modified as needed for local site use cases.  Please consult the install guide for more detail and discussion regarding a companion template  install script.
这些指南的目的是使用OpenHPC软件堆栈中的组件提供一个简单的群集安装过程。本文档的目的是合理地通用，但使用小型无状态集群安装的基本动机来定义一个分步过程。包括了几个可选的自定义，目的是可以根据本地站点用例的需要修改这些集体指令。有关配套模板安装脚本的详细信息和讨论，请参阅安装指南。