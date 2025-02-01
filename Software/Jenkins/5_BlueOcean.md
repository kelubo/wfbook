# Blue Ocean 蓝色海洋

Chapter Sub-Sections 章节小节

- [ Getting started with Blue Ocean 
  开始使用 Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started)
- [ Creating a Pipeline  创建 Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines)
- [ Dashboard  挡泥板](https://www.jenkins.io/doc/book/blueocean/dashboard)
- [ Activity View  Activity 视图](https://www.jenkins.io/doc/book/blueocean/activity)
- [ Pipeline Run Details View 
  Pipeline Run Details 视图](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details)
- [ Pipeline Editor  Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)

Table of Contents 目录

- [What is Blue Ocean? 什么是蓝海？](https://www.jenkins.io/doc/book/blueocean/#blue-ocean-overview)
- Frequently asked questions
  常见问题解答
  - [Why does Blue Ocean exist?
    Blue Ocean 为什么存在？](https://www.jenkins.io/doc/book/blueocean/#why-does-blue-ocean-exist)
  - [Where is the name from?
    这个名字来自哪里？](https://www.jenkins.io/doc/book/blueocean/#where-is-the-name-from)
  - [What does this mean for my plugins?
    这对我的插件意味着什么？](https://www.jenkins.io/doc/book/blueocean/#what-does-this-mean-for-my-plugins)
  - [What technologies are currently in use?
    目前正在使用哪些技术？](https://www.jenkins.io/doc/book/blueocean/#what-technologies-are-currently-in-use)
  - [Where can I find the source code?
    我在哪里可以找到源代码？](https://www.jenkins.io/doc/book/blueocean/#where-can-i-find-the-source-code)
- [Join the Blue Ocean community
  加入 Blue Ocean 社区](https://www.jenkins.io/doc/book/blueocean/#join-the-blue-ocean-community)

This chapter covers all aspects of Blue Ocean’s functionality, including how to:
本章介绍了 Blue Ocean 功能的所有方面，包括如何：

- [get started with Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started), which covers how to set up Blue Ocean in Jenkins and access the Blue Ocean interface.
  [开始使用 Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started)，其中介绍了如何在 Jenkins 中设置 Blue Ocean 并访问 Blue Ocean 界面。
- [create a new Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) project in Blue Ocean.
  在 Blue Ocean 中[创建新的 Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) 项目。
- use Blue Ocean’s [dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard).
  使用 Blue Ocean 的[仪表板](https://www.jenkins.io/doc/book/blueocean/dashboard)。
- use the [Activity view](https://www.jenkins.io/doc/book/blueocean/activity), where you can access [your current and historic run data](https://www.jenkins.io/doc/book/blueocean/activity#activity), your Pipeline’s [branches](https://www.jenkins.io/doc/book/blueocean/activity#branches), and any open [pull requests](https://www.jenkins.io/doc/book/blueocean/activity#pull-requests).
  使用 [Activity （活动） 视图](https://www.jenkins.io/doc/book/blueocean/activity)，您可以在其中访问[当前和历史运行数据](https://www.jenkins.io/doc/book/blueocean/activity#activity)、管道[的分支](https://www.jenkins.io/doc/book/blueocean/activity#branches)以及任何打开的[拉取请求](https://www.jenkins.io/doc/book/blueocean/activity#pull-requests)。
- use the [Pipeline run details view](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details) to access details such as console output, for a particular Pipeline or item run.
  使用 [Pipeline run details （管道运行详细信息） 视图](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details)可访问特定 Pipeline 或项目运行的详细信息，例如控制台输出。
- use the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor) to modify Pipelines as code, which you can then commit to source control.
  使用 [Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)将 Pipelines 修改为代码，然后您可以将其提交到源代码管理。

This chapter is intended for Jenkins users of all skill levels, but beginners may need to refer to the [Pipeline](https://www.jenkins.io/doc/book/pipeline/) chapter to understand some topics covered here.
本章适用于所有技能水平的 Jenkins 用户，但初学者可能需要参考 [流水线](https://www.jenkins.io/doc/book/pipeline/) 一章来理解这里涵盖的一些主题。

For an overview of content in the Jenkins User Handbook, refer to [user handbook overview](https://www.jenkins.io/doc/book/getting-started/).
有关 Jenkins 用户手册中内容的概述，请参阅[用户手册概述](https://www.jenkins.io/doc/book/getting-started/)。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  Alternative options for Pipeline visualization, such as the [Pipeline: Stage View](https://plugins.jenkins.io/pipeline-stage-view/) and [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) plugins, are available and offer some of the same functionality. While not complete replacements for Blue Ocean, contributions are  encouraged from the community for continued development of these  plugins. 管道可视化的替代选项（例如 [Pipeline： Stage View](https://plugins.jenkins.io/pipeline-stage-view/) 和 [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) 插件）可用，并提供一些相同的功能。虽然不是 Blue Ocean 的完全替代品，但鼓励社区为这些插件的持续开发做出贡献。  The [Pipeline syntax snippet generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) assists users as they define Pipeline steps with their arguments. It is the preferred tool for Jenkins Pipeline creation, as it provides  online help for the Pipeline steps available in your Jenkins controller. It uses the plugins installed on your Jenkins controller to generate the Pipeline syntax. Refer to the [Pipeline steps reference](https://www.jenkins.io/doc/pipeline/steps/) page for information on all available Pipeline steps. [Pipeline 语法代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)可帮助用户使用其参数定义 Pipeline 步骤。它是创建 Jenkins Pipeline 的首选工具，因为它为 Jenkins 控制器中可用的 Pipeline  步骤提供在线帮助。它使用安装在 Jenkins 控制器上的插件来生成 Pipeline 语法。请参阅 [Pipeline steps 参考](https://www.jenkins.io/doc/pipeline/steps/)页面 以了解有关所有可用 Pipeline 步骤的信息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## What is Blue Ocean? 什么是蓝海？

Blue Ocean as it stands provides easy-to-use Pipeline visualization. It was intended to be a rethink of the Jenkins user experience, designed from the ground up for [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/). Blue Ocean was intended to reduce clutter and increases clarity for all users.
Blue Ocean 目前提供易于使用的 Pipeline 可视化。它旨在重新思考 Jenkins 用户体验，为 [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/) 从头开始设计。Blue Ocean 旨在为所有用户减少杂乱并提高清晰度。

However, Blue Ocean will not receive further functionality or enhancement updates. It will only receive selective updates for significant security issues or functional defects. If you are just starting out, you can still use Blue Ocean, or you may want to consider alternative options such as the [Pipeline: Stage View](https://plugins.jenkins.io/pipeline-stage-view/) and [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) plugins. These offer some of the same functionality.
但是，Blue Ocean 将不会收到进一步的功能或增强功能更新。它只会接收针对重大安全问题或功能缺陷的选择性更新。如果您刚刚开始，您仍然可以使用 Blue Ocean，或者您可能需要考虑其他选项，例如 [Pipeline： Stage View](https://plugins.jenkins.io/pipeline-stage-view/) 和 [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) 插件。这些 API 提供一些相同的功能。

To sum up, Blue Ocean’s main features include:
综上所述，Blue Ocean 的主要特点包括：

- **Sophisticated visualization** of continuous delivery (CD) Pipelines, allowing for fast and intuitive comprehension of your Pipeline’s status.
  持续交付 （CD） 管道的**复杂可视化**，允许快速直观地理解管道的状态。
- **Pipeline editor** makes the creation of Pipelines more approachable, by guiding the user through a visual process to create a Pipeline.
  **Pipeline Editor** 通过引导用户完成可视化过程来创建 Pipeline，使 Pipelines 的创建更加易于理解。
- **Personalization** to suit the role-based needs of each member of the team.
  **个性化**以满足团队每个成员基于角色的需求。
- **Pinpoint precision** when intervention is needed or issues arise. Blue Ocean shows where attention is needed, facilitating exception handling and increasing productivity.
  在需要干预或出现问题时**精确定位**。Blue Ocean 显示需要注意的地方，促进异常处理并提高生产力。
- **Native integration for branches and pull requests**, which enables maximum developer productivity when collaborating on code in GitHub and Bitbucket.
  **分支和拉取请求的原生集成**，可在 GitHub 和 Bitbucket 中协作处理代码时最大限度地提高开发人员的工作效率。

If you would like to start using Blue Ocean, please refer to [getting started with Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started/).
如果您想开始使用 Blue Ocean，请参考 [开始使用 Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started/)。



## Frequently asked questions 常见问题解答

### Why does Blue Ocean exist? Blue Ocean 为什么存在？

The DevOps world has transitioned from developer tools that are purely  functional, to developer tools being part of a "developer experience." It was no longer about a single tool, but the many tools developers use  throughout the day, and how they work together to achieve a better  workflow for the developer.
DevOps 世界已经从纯粹功能性的开发人员工具转变为作为“开发人员体验”一部分的开发人员工具。这不再是关于单个工具，而是开发人员全天使用的许多工具，以及它们如何协同工作以为开发人员实现更好的工作流程。

Developer tool companies like Heroku, Atlassian, and GitHub have raised the bar  for what is considered a good developer experience. Gradually, developers have become more attracted to tools that are not  only functional, but are designed to fit into their existing workflow  seamlessly. This shift represents a higher standard for design and function, where  developers are expecting an exceptional user experience. Jenkins needed to rise to meet this higher standard.
Heroku、Atlassian 和 GitHub  等开发人员工具公司已经提高了良好开发人员体验的标准。渐渐地，开发人员越来越喜欢那些不仅功能强大，而且旨在无缝适应其现有工作流程的工具。这种转变代表了设计和功能的更高标准，开发人员期望获得卓越的用户体验。Jenkins 需要站出来才能达到这个更高的标准。

Creating and visualising continuous delivery Pipelines has always been something valuable for many Jenkins users. This has been demonstrated in the plugins that the Jenkins community has created to meet their needs. This also indicates a need to revisit how Jenkins currently expresses  these concepts, and consider delivery pipelines as a central theme to  the Jenkins user experience.
对于许多 Jenkins 用户来说，创建和可视化持续交付管道一直是一件有价值的事情。这在 Jenkins  社区为满足他们的需求而创建的插件中得到了证明。这也表明需要重新审视 Jenkins 目前如何表达这些概念，并将交付管道视为 Jenkins  用户体验的中心主题。

It is not just continuous delivery concepts, but the tools that developers use every day such as GitHub, Bitbucket, Slack, Puppet, or Docker. It is about more than Jenkins, as it includes the developer workflow  surrounding Jenkins, which comprised multiple tools.
这不仅仅是持续交付概念，还有开发人员每天使用的工具，例如 GitHub、Bitbucket、Slack、Puppet 或 Docker。它不仅仅是 Jenkins，因为它包括围绕 Jenkins 的开发人员工作流程，其中包括多个工具。

New teams can encounter challenges when learning how to assemble their own  Jenkins experience. However, the goal to improve their time to market by shipping better  software more consistently is the same. Assembling the ideal Jenkins experience is something we, as a community  of Jenkins users and contributors, can work together to define. As time progresses, developers' expectations of a good user experience  change, and the Jenkins project needs to be receptive to these  expectations.
新团队在学习如何组装自己的 Jenkins 体验时可能会遇到挑战。但是，通过更一致地交付更好的软件来缩短上市时间的目标是相同的。作为 Jenkins  用户和贡献者社区，我们可以共同定义理想的 Jenkins 体验。随着时间的推移，开发人员对良好用户体验的期望会发生变化，Jenkins  项目需要接受这些期望。

The Jenkins community has worked constantly to build the most technically  capable and extensible software automation tool in existence. Not revolutionizing the Jenkins developer experience today could mean  that a closed source option attempts to capitalize on this in the  future.
Jenkins 社区一直在努力构建现有的技术能力最强、可扩展性最强的软件自动化工具。今天没有彻底改变 Jenkins 开发人员的体验可能意味着闭源选项将来会尝试利用这一点。

Blue Ocean was created to meet such demands of its time. However, as time passed, more modern tools have cropped up to replace  it. Now, the time has come for the rise of other plugins of similar  functionality. Therefore, any new development or enhancement of Blue Ocean has ceased. If you are interested in contributing to a plugin which serves a similar purpose, you should consider the alternative options as suggested in **[What is Blue Ocean?](https://www.jenkins.io/doc/book/blueocean/#blue-ocean-overview)** section on above.
Blue Ocean 的创建是为了满足当时的此类需求。然而，随着时间的推移，出现了更多现代工具来取代它。现在，是时候出现其他具有类似功能的插件了。因此，Blue Ocean 的任何新开发或增强都已停止。如果您有兴趣为具有类似目的的插件做出贡献，您应该考虑 **[什么是蓝海？](https://www.jenkins.io/doc/book/blueocean/#blue-ocean-overview)**上面部分建议的替代选项。



### Where is the name from? 这个名字来自哪里？

The name Blue Ocean comes from the book [Blue Ocean Strategy](https://en.wikipedia.org/wiki/Blue_Ocean_Strategy). This strategy involves looking at problems in the larger uncontested  space, instead of strategic problems within a contested space. To put this more simply, consider this quote from ice hockey legend  Wayne Gretzky: "Skate to where the puck is going to be, not where it has been."
Blue Ocean 这个名字来自[《Blue Ocean Strategy](https://en.wikipedia.org/wiki/Blue_Ocean_Strategy)》一书。这种策略涉及在更大的无争议空间中寻找问题，而不是在有争议的领域中寻找战略问题。更简单地说，考虑一下冰球传奇人物韦恩·格雷茨基 （Wayne Gretzky） 的这句话：“滑到冰球将要去的地方，而不是它曾经所在的地方。

#### Does Blue Ocean support freestyle jobs? Blue Ocean 是否支持自由式工作？

Blue Ocean aims to deliver a great experience around Pipeline and  compatibility with any freestyle jobs you already have configured in  your Jenkins controller. However, you will not benefit from the features built for Pipelines, for example Pipeline visualization.
Blue Ocean 旨在围绕 Pipeline 提供出色的体验，并与您已经在 Jenkins 控制器中配置的任何 freestyle 作业兼容。但是，您不会从为 Pipelines 构建的功能中受益，例如 Pipeline 可视化。

Blue Ocean was designed to be extensible, so that the Jenkins community  could extend Blue Ocean functionality. While there will not be any further functionalities added to Blue Ocean, it still provides Pipeline visualization and other features that users  find valuable.
Blue Ocean 被设计为可扩展的，因此 Jenkins 社区可以扩展 Blue Ocean 功能。虽然 Blue Ocean 不会添加任何其他功能，但它仍然提供 Pipeline 可视化和用户认为有价值的其他功能。

### What does this mean for my plugins? 这对我的插件意味着什么？

Extensibility is a core feature of Jenkins and being able to extend the Blue Ocean UI is equally important. The `<ExtensionPoint name=..>` can be used in the markup of Blue Ocean, leaving places for plugins to contribute to the UI. This means plugins can have their own Blue Ocean extension points. Blue Ocean itself is implemented using these extension points.
可扩展性是 Jenkins 的核心功能，能够扩展 Blue Ocean UI 同样重要。`<ExtensionPoint 名称=..>` 可用于 Blue Ocean 的标记，为插件留出为 UI 做出贡献的地方。这意味着插件可以拥有自己的 Blue Ocean 扩展点。Blue Ocean 本身就是使用这些扩展点实现的。

Extensions are delivered by plugins as usual. Plugins must include some additional JavaScript to connect to Blue Ocean’s extension points. Developers that have contributed to the Blue Ocean user experience will have added this JavaScript accordingly.
扩展像往常一样由插件交付。插件必须包含一些额外的 JavaScript 才能连接到 Blue Ocean 的扩展点。为 Blue Ocean 用户体验做出贡献的开发人员将相应地添加此 JavaScript。

### What technologies are currently in use? 目前正在使用哪些技术？

Blue Ocean is built as a collection of Jenkins plugins. The key difference is that Blue Ocean provides both its own endpoint for HTTP requests, and it delivers HTML/JavaScript via a different path,  without using the existing Jenkins UI markup or scripts. React.js and ES6 are used to deliver the JavaScript components of Blue  Ocean. Inspired by this excellent open-source project, which you can refer to  in the [building plugins for React apps](https://nylas.com/blog/react-plugins) blog post, an `<ExtensionPoint>` pattern was established that allows extensions to come from any Jenkins plugin with JavaScript. If the extensions fail to load, their failures are isolated.
Blue Ocean 是作为 Jenkins 插件的集合构建的。主要区别在于 Blue Ocean 为 HTTP  请求提供自己的端点，并通过不同的路径交付 HTML/JavaScript，而无需使用现有的 Jenkins UI 标记或脚本。React.js 和 ES6 用于交付 Blue Ocean 的 JavaScript 组件。受这个优秀的开源项目（你可以在[为 React 应用程序构建插件](https://nylas.com/blog/react-plugins)博客文章中引用）的启发，建立了`一个 <ExtensionPoint>` 模式，该模式允许扩展来自任何带有 JavaScript 的 Jenkins 插件。如果扩展无法加载，则隔离其失败。

### Where can I find the source code? 我在哪里可以找到源代码？

The source code can be found on Github:
源代码可以在 Github 上找到：

- [Blue Ocean 蓝色海洋](https://github.com/jenkinsci/blueocean-plugin)
- [Jenkins Design Language Jenkins 设计语言](https://github.com/jenkinsci/jenkins-design-language)

## Join the Blue Ocean community 加入 Blue Ocean 社区

As the development of Blue Ocean has frozen, we do not anticipate or  expect any new contributions made to its codebase for new features. However, there are still a few ways you can join the community:
由于 Blue Ocean 的开发已冻结，我们预计或期望对其代码库的新功能做出任何新的贡献。但是，您仍然可以通过以下几种方式加入社区：

1. Chat with the community and development team on Gitter [![blueocean plugin](https://badges.gitter.im/jenkinsci/blueocean-plugin.svg)](https://app.gitter.im/#/room/#jenkinsci_blueocean-plugin:gitter.im)
   在 Gitter [ ![blueocean plugin](https://badges.gitter.im/jenkinsci/blueocean-plugin.svg) ](https://app.gitter.im/#/room/#jenkinsci_blueocean-plugin:gitter.im) 上与社区和开发团队聊天
2. Request features or report bugs against the [`blueocean-plugin` component in JIRA](https://issues.jenkins.io/).
   针对 [JIRA 中的 `blueocean-plugin` 组件](https://issues.jenkins.io/)请求功能或报告 bug。
3. Subscribe and ask questions on the [Jenkins Users mailing list](https://groups.google.com/g/jenkinsci-users).
   在 [Jenkins 用户邮件列表](https://groups.google.com/g/jenkinsci-users)上订阅并提问。
4. Developer? We’ve [labeled a few issues](https://issues.jenkins.io/issues/?filter=16142) that are great for anyone wanting to get started developing Blue Ocean. Don’t forget to drop by the Gitter chat and introduce yourself!
   开发 人员？我们[标记了一些问题](https://issues.jenkins.io/issues/?filter=16142)，这些问题非常适合任何想要开始开发 Blue Ocean 的人。别忘了来 Gitter 聊天室介绍自己！

# Getting started with Blue Ocean  开始使用 Blue Ocean

Table of Contents 目录

- Installing Blue Ocean 安装 Blue Ocean
  - [On an existing Jenkins controller
    在现有的 Jenkins 控制器上](https://www.jenkins.io/doc/book/blueocean/getting-started/#on-an-existing-jenkins-controller)
  - [As part of Jenkins in Docker
    作为 Docker 中 Jenkins 的一部分](https://www.jenkins.io/doc/book/blueocean/getting-started/#as-part-of-jenkins-in-docker)
- [Accessing Blue Ocean 访问 Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started/#accessing-blue-ocean)
- [Navigation bar 导航栏](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar)
- [Switching to the classic UI
  切换到经典 UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#switching-to-the-classic-ui)

This section describes how to get started with Blue Ocean in Jenkins. It includes instructions for [setting up Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started/#installing-blue-ocean) on your Jenkins controller, how to [access the Blue Ocean UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#accessing-blue-ocean), and [returning to the Jenkins classic UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#switching-to-the-classic-ui).
本节介绍如何在 Jenkins 中开始使用 Blue Ocean。它包括在 Jenkins 控制器上[设置 Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started/#installing-blue-ocean)、如何[访问 Blue Ocean UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#accessing-blue-ocean) 以及[返回 Jenkins 经典 UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#switching-to-the-classic-ui) 的说明。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## Installing Blue Ocean 安装 Blue Ocean

You can install Blue Ocean using the following methods:
您可以使用以下方法安装 Blue Ocean：

- As a suite of plugins on an [existing Jenkins controller](https://www.jenkins.io/doc/book/blueocean/getting-started/#on-an-existing-jenkins-instance).
  作为[现有 Jenkins 控制器](https://www.jenkins.io/doc/book/blueocean/getting-started/#on-an-existing-jenkins-instance)上的一套插件。
- As a part of [Jenkins in Docker](https://www.jenkins.io/doc/book/blueocean/getting-started/#as-part-of-jenkins-in-docker).
  作为 [Docker 中 Jenkins 的一部分](https://www.jenkins.io/doc/book/blueocean/getting-started/#as-part-of-jenkins-in-docker)。

### On an existing Jenkins controller 在现有的 Jenkins 控制器上

When Jenkins is installed on most platforms, the [Blue Ocean](https://plugins.jenkins.io/blueocean) plugin and all necessary dependent plugins, which compile the Blue Ocean suite of plugins, are not installed by default.
当 Jenkins 安装在大多数平台上时，默认情况下不会安装 [Blue Ocean](https://plugins.jenkins.io/blueocean) 插件和所有必要的依赖插件，这些插件编译了 Blue Ocean 插件套件。

Plugins can be installed on a Jenkins controller by any Jenkins user who has the **Administer** permission. This is set through **Matrix-based security**. Jenkins users with this permission can also configure the permissions of other users on their system. Refer to the [Authorization](https://www.jenkins.io/doc/book/security/managing-security/#authorization) section of [Managing Security](https://www.jenkins.io/doc/book/security/managing-security/) for more information.
任何具有 **Administer** 权限的 Jenkins 用户都可以安装在 Jenkins 控制器上。这是通过**基于 Matrix 的安全性**设置的。具有此权限的 Jenkins 用户还可以配置其系统上其他用户的权限。有关更多信息，请参阅 [Managing Security](https://www.jenkins.io/doc/book/security/managing-security/) 的 [Authorization](https://www.jenkins.io/doc/book/security/managing-security/#authorization) 部分。

To install the Blue Ocean suite of plugins to your Jenkins controller:
要将 Blue Ocean 插件套件安装到 Jenkins 控制器：

1. Ensure you are logged in to Jenkins as a user with the **Administer** permission.
   确保您以具有 **Administer** 权限的用户身份登录到 Jenkins。

2. From the Jenkins home page, select **Manage Jenkins** on the left and then **Plugins**.
   在 Jenkins 主页中，选择左侧的 **Manage Jenkins**，然后选择 **Plugins**。

3. Select the **Available** tab and enter `blue ocean` in the **Filter** text box. This filters the list of plugins based on the name and description.
   选择 **Available** 选项卡，然后在 **Filter** 文本框中输入 `blue ocean`。这将根据名称和描述筛选插件列表。

   ![Available Blue Ocean plugins after being filtered list.](https://www.jenkins.io/doc/book/resources/blueocean/intro/blueocean-plugins-filtered.png)

4. Select the box to the left of **Blue Ocean**, and then select either the **Download now and install after restart** option (recommended) or the **Install without restart** option at the bottom of the page.
   选中 **Blue Ocean** 左侧的框，然后选择页面底部的 **Download now and install after restart** 选项（推荐）或 **Install without restart** 选项。

   |      | It is not necessary to select other plugins in this list. The main **Blue Ocean** plugin automatically selects and installs all dependent plugins, composing the Blue Ocean suite of plugins. 无需在此列表中选择其他插件。主 **Blue Ocean** 插件会自动选择并安装所有相关插件，组成 Blue Ocean 插件套件。  If you select the **Install without restart** option, you must restart Jenkins to gain full Blue Ocean functionality. 如果选择 **Install without restart** 选项，则必须重新启动 Jenkins 才能获得完整的 Blue Ocean 功能。 |
   | ---- | ------------------------------------------------------------ |
   |      |                                                              |

Refer to the the [Managing Plugins](https://www.jenkins.io/doc/book/managing/plugins) page for more information. Blue Ocean does not require additional configuration after installation. Existing Pipelines and projects will continue to work as usual.
请参阅 [管理插件](https://www.jenkins.io/doc/book/managing/plugins) 页面以了解更多信息。Blue Ocean 安装后不需要额外配置。现有 Pipelines 和项目将继续照常工作。

|      | The first time you [create a Pipeline in Blue Ocean](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) for a specific Git server, Blue Ocean prompts you for your Git  credentials to allow you to create Pipelines in the repositories. This is required since Blue Ocean can add a `Jenkinsfile` to your repositories.  首次[在 Blue Ocean 中为](https://www.jenkins.io/doc/book/blueocean/creating-pipelines)特定 Git 服务器创建 Pipeline 时，Blue Ocean 会提示您输入 Git 凭证，以允许您在存储库中创建 Pipelines。这是必需的，因为 Blue Ocean 可以将 `Jenkinsfile` 添加到您的存储库中。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### As part of Jenkins in Docker 作为 Docker 中 Jenkins 的一部分

The Blue Ocean suite of plugins is not bundled with the official Jenkins Docker image, [`jenkins/jenkins`](https://hub.docker.com/r/jenkins/jenkins/), which is available from the [Docker Hub repository](https://hub.docker.com/).
Blue Ocean 插件套件未与官方 Jenkins Docker 镜像 [`jenkins/jenkins`](https://hub.docker.com/r/jenkins/jenkins/) 捆绑在一起，该镜像可从 [Docker Hub 存储库](https://hub.docker.com/)获得。

Read more about running Jenkins and Blue Ocean inside Docker in the [Docker](https://www.jenkins.io/doc/book/installing/#docker) section of the installing Jenkins page.
在安装 Jenkins 页面的 [Docker](https://www.jenkins.io/doc/book/installing/#docker) 部分中阅读有关在 Docker 中运行 Jenkins 和 Blue Ocean 的更多信息。

## Accessing Blue Ocean 访问 Blue Ocean

Once a Jenkins environment has Blue Ocean installed and you log in to the Jenkins classic UI, you can access the Blue Ocean UI by selecting **Open Blue Ocean** on the left side of the screen.
安装 Jenkins 环境 Blue Ocean 并登录到 Jenkins 经典 UI 后，您可以通过选择屏幕左侧的 **Open Blue Ocean** 来访问 Blue Ocean UI。

![Open Blue Ocean link](https://www.jenkins.io/doc/book/resources/blueocean/intro/open-blue-ocean-link.png)

Alternatively, you can access Blue Ocean directly by appending `/blue` to the end of your Jenkins server’s URL. For example `https://jenkins-server-url/blue`.
或者，您可以通过将 `/blue` 附加到 Jenkins 服务器 URL 的末尾来直接访问 Blue Ocean。例如 `https://jenkins-server-url/blue` .

If your Jenkins controller:
如果您的 Jenkins 控制器：

- Already has existing Pipeline projects or other items present, the [Blue Ocean Dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard) displays.
  已经存在现有的 Pipeline 项目或其他项目，则会显示 [Blue Ocean Dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard)。

- Is new or does not have projects or other items configured, Blue Ocean displays a **Welcome to Jenkins** pane with a **Create a new Pipeline** button. You can select this to begin creating a new Pipeline project. For more information, refer to the [Creating a Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) page for more information on creating a Pipeline project in Blue Ocean.
  是新的或没有配置项目或其他项目，Blue Ocean 会显示 **Welcome to Jenkins** 窗格，其中包含 **Create a new Pipeline** 按钮。您可以选择此项以开始创建新的 Pipeline 项目。有关更多信息，请参阅[创建 Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) 页面，了解有关在 Blue Ocean 中创建 Pipeline 项目的更多信息。

  ![Welcome to Jenkins - Create a New Pipeline message box](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/create-a-new-pipeline-box.png)

## Navigation bar 导航栏

The Blue Ocean UI has a navigation bar along the top of its interface, allowing you to access the different views and features.
Blue Ocean UI 的界面顶部有一个导航栏，允许您访问不同的视图和功能。

The navigation bar is divided into two sections:
导航栏分为两个部分：

- A common section along the top of most Blue Ocean views.
  大多数 Blue Ocean 视图顶部的公共部分。
- A contextual section below.
  下面的上下文部分。

The contextual section is specific to the current Blue Ocean page you are viewing.
上下文部分特定于您正在查看的当前 Blue Ocean 页面。

The navigation bar’s common section includes the following buttons:
导航栏的 common 部分包括以下按钮：

- **Jenkins**: Selecting the Jenkins icon takes you to the [Dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard) or reloads this page if you are already viewing it.
  **Jenkins**：选择 Jenkins 图标会将您带到[控制面板](https://www.jenkins.io/doc/book/blueocean/dashboard)，或者如果您已在查看此页面，请重新加载此页面。
- **Pipelines**: This also takes you to the Dashboard. If you are already on the Dashboard, this option reloads the page. This button serves a different purpose when you are viewing a [Pipeline run details](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details) page.
  **管道**：这还会将您带到 Dashboard。如果您已在 Dashboard 上，则此选项会重新加载页面。当您查看 [Pipeline run details （管道运行详细信息](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details)） 页面时，此按钮具有不同的用途。
- **Administration**: This takes you to the **[Manage Jenkins](https://www.jenkins.io/doc/book/managing)** page of the Jenkins classic UI. This button is not available if you do not have the **Administer** permission. Refer to the [Authorization](https://www.jenkins.io/doc/book/managing/security/#authorization) section of the Managing Security page for more information.
  **管理**：这将带您进入 Jenkins 经典 UI 的 **[Manage Jenkins](https://www.jenkins.io/doc/book/managing)** 页面。如果您没有 **Administer** 权限，则此按钮不可用。有关更多信息，请参阅 Managing Security 页面的 [Authorization](https://www.jenkins.io/doc/book/managing/security/#authorization) 部分。
- **Go to classic** icon: This takes you back to the Jenkins classic UI. Read more about this in [Switching to the classic UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#switching-to-the-classic-ui).
  **转到经典**图标：这会将您带回 Jenkins 经典 UI。有关更多信息，请参阅[切换到经典 UI](https://www.jenkins.io/doc/book/blueocean/getting-started/#switching-to-the-classic-ui)。
- **Logout**: This logs out your current Jenkins user and returns you to the Jenkins login page.
  **注销**：这将注销您当前的 Jenkins 用户，并将您返回到 Jenkins 登录页面。

Views that use the common navigation bar add another bar below it. This second bar includes options specific to that view. Some views replace the common navigation bar with one specifically suited to that view.
使用公共导航栏的视图会在其下方添加另一个栏。第二个栏包含特定于该视图的选项。某些视图将公共导航栏替换为专门适合该视图的导航栏。

## Switching to the classic UI 切换到经典 UI

Blue Ocean does not support some legacy or administrative features of Jenkins that are necessary to some users.
Blue Ocean 不支持某些用户所必需的 Jenkins 的某些遗留或管理功能。

If you need to access these features, select the **Go to classic** icon at the top of a common section of Blue Ocean’s [navigation bar](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar).
如果您需要访问这些功能，请选择 Blue Ocean [导航栏](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar)公共部分顶部的 **Go to classic** 图标。

![Go to classic icon](https://www.jenkins.io/doc/book/resources/blueocean/intro/go-to-classic-icon.png)

Selecting this button takes you to the equivalent page in the Jenkins classic UI  or the most relevant classic UI page that parallels the current page in  Blue Ocean.
选择此按钮会将您带到 Jenkins 经典 UI 中的等效页面或与 Blue Ocean 中的当前页面平行的最相关的经典 UI 页面。

# Creating a Pipeline 创建 Pipeline

Table of Contents 目录

- [Creating a Pipeline 创建 Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#creating-a-pipeline)
- Setting up your Pipeline project
  设置 Pipeline 项目
  - For a Git repository 对于 Git 存储库
    - [Local repository 本地存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#local-repository)
    - [Remote repository 远程存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#remote-repository)
  - For a repository on GitHub
    对于 GitHub 上的存储库
    - [Create your access token 创建您的访问令牌](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#create-your-access-token)
    - [Choose your GitHub account/organization and repository
      选择您的 GitHub 帐户/组织和存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-github-account)
  - For a repository on Bitbucket Cloud
    对于 Bitbucket Cloud 上的存储库
    - [Choose your Bitbucket account/team and repository
      选择您的 Bitbucket 帐户/团队和存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-bitbucket-account)

## Creating a Pipeline 创建 Pipeline

Blue Ocean makes it easy to create a Pipeline project in Jenkins.
Blue Ocean 使在 Jenkins 中创建 Pipeline 项目变得容易。

You can generate a Pipeline from an existing `Jenkinsfile` in source control, or you can use the [Blue Ocean Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor) to create a Pipeline as a `Jenkinsfile` that is committed to source control.
您可以在源代码控制中从现有的 `Jenkinsfile` 生成管道，也可以使用 [Blue Ocean Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)将管道创建为提交到源代码控制的 `Jenkinsfile`。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  Alternative options for Pipeline visualization, such as the [Pipeline: Stage View](https://plugins.jenkins.io/pipeline-stage-view/) and [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) plugins, are available and offer some of the same functionality. While not complete replacements for Blue Ocean, contributions are  encouraged from the community for continued development of these  plugins. 管道可视化的替代选项（例如 [Pipeline： Stage View](https://plugins.jenkins.io/pipeline-stage-view/) 和 [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) 插件）可用，并提供一些相同的功能。虽然不是 Blue Ocean 的完全替代品，但鼓励社区为这些插件的持续开发做出贡献。  The [Pipeline syntax snippet generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) assists users as they define Pipeline steps with their arguments. It is the preferred tool for Jenkins Pipeline creation, as it provides  online help for the Pipeline steps available in your Jenkins controller. It uses the plugins installed on your Jenkins controller to generate the Pipeline syntax. Refer to the [Pipeline steps reference](https://www.jenkins.io/doc/pipeline/steps/) page for information on all available Pipeline steps. [Pipeline 语法代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)可帮助用户使用其参数定义 Pipeline 步骤。它是创建 Jenkins Pipeline 的首选工具，因为它为 Jenkins 控制器中可用的 Pipeline  步骤提供在线帮助。它使用安装在 Jenkins 控制器上的插件来生成 Pipeline 语法。请参阅 [Pipeline steps 参考](https://www.jenkins.io/doc/pipeline/steps/)页面 以了解有关所有可用 Pipeline 步骤的信息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## Setting up your Pipeline project 设置 Pipeline 项目

To start setting up your Pipeline project in Blue Ocean, select the **New Pipeline** button at the top-right of the [Blue Ocean Dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard).
要开始在 Blue Ocean 中设置 Pipeline 项目，请选择 [Blue Ocean Dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard) 右上角的 **New Pipeline** 按钮。

![New Pipeline Button](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/new-pipeline-button.png)

If your Jenkins instance is new or has no Pipeline projects or other items configured, Blue Ocean displays a **Welcome to Jenkins** message that allows you to select the **Create a new Pipeline** option to start setting up your Pipeline project.
如果您的 Jenkins 实例是新的或未配置管道项目或其他项目，Blue Ocean 会显示**一条欢迎使用 Jenkins** 的消息，允许您选择 **Create a new Pipeline （创建新管道**） 选项以开始设置管道项目。

![Welcome to Jenkins - Create a New Pipeline message box](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/create-a-new-pipeline-box.png)

You now have a choice of creating your new Pipeline project from a:
现在，您可以选择从以下位置创建新的 Pipeline 项目：

- [Standard Git repository 标准 Git 存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#for-a-git-repository)
- [Repository on GitHub](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#for-a-repository-on-github) or GitHub Enterprise
  GitHub 或 GitHub Enterprise [上的存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#for-a-repository-on-github)
- [Repository on Bitbucket Cloud](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#for-a-repository-on-bitbucket-cloud) or Bitbucket Server
  [Bitbucket Cloud](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#for-a-repository-on-bitbucket-cloud) 或 Bitbucket Server 上的存储库

### For a Git repository 对于 Git 存储库

To create your Pipeline project for a Git repository, click the **Git** button under **Where do you store your code?**
要为 Git 存储库创建 Pipeline 项目，请单击 **Where do you store your code？** 

![Where do you store your code](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/where-do-you-store-your-code.png)

In the **Connect to a Git repository** section, enter the URL for your Git repository in the **Repository URL** field.
在 **Connect to a Git repository （连接到 Git 存储库**） 部分中，在 **Repository URL （存储库 URL**） 字段中输入 Git 存储库的 URL。

![Connect to a Git repository](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/connect-to-a-git-repository.png)

You now must specify a [local](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#local-repository) or [remote](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#remote-repository) repository from which to build your Pipeline project.
现在，您必须指定用于构建 Pipeline 项目[的本地或](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#local-repository)[远程](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#remote-repository)存储库。

#### Local repository 本地存储库

If your URL is a local directory path beginning with a forward slash `/`, such as `/home/cloned-git-repos/my-git-repo.git`, you can proceed to select the **Create Pipeline** option.
如果您的 URL 是以正斜杠 `/` 开头的本地目录路径，例如 `/home/cloned-git-repos/my-git-repo.git` ，您可以继续选择 **Create Pipeline** 选项。

Blue Ocean then scans your local repository’s branches for a `Jenkinsfile`, and starts a Pipeline run for each branch containing a `Jenkinsfile`. If Blue Ocean cannot find a `Jenkinsfile`, you are prompted to create one through the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/).
然后，Blue Ocean 会扫描本地存储库的分支以查找 `Jenkinsfile`，并为包含 `Jenkinsfile` 的每个分支启动流水线运行。如果 Blue Ocean 找不到 `Jenkinsfile`，系统会提示您通过 [Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/)创建一个。

Local repositories are typically limited to file system access and are normally only available from the controller node. Local repositories are also known to require more complicated path names on Windows than most users want to manage. Users are advised to run jobs on agents, rather than running them directly on the controller. Therefore, you should use a remote repository rather than a local repository for the best Blue Ocean experience.
本地存储库通常仅限于文件系统访问，并且通常只能从控制器节点访问。众所周知，本地存储库在 Windows  上需要比大多数用户想要管理的更复杂的路径名。建议用户在代理上运行作业，而不是直接在控制器上运行它们。因此，您应该使用远程存储库而不是本地存储库，以获得最佳 Blue Ocean 体验。

#### Remote repository 远程存储库

Since the Pipeline editor saves edited Pipelines to Git repositories as  `Jenkinsfile`s, Blue Ocean only supports connections to remote Git  repositories over the SSH protocol.
由于 Pipeline 编辑器将编辑后的 Pipelines 保存到 Git 存储库中作为“Jenkinsfile”，因此 Blue Ocean 仅支持通过 SSH 协议连接到远程 Git 存储库。

If your URL is for a remote Git repository, be sure your URL starts with either:
如果您的 URL 用于远程 Git 存储库，请确保您的 URL 以以下任一方式开头：

- `ssh://` - which displays as `ssh://gituser@git-server-url/git-server-repos-group/my-git-repo.git`
  `ssh://` - 显示为 `ssh://gituser@git-server-url/git-server-repos-group/my-git-repo.git` 
   or 或
- `user@host:path/to/git/repo.git` - which displays as `gituser@git-server-url:git-server-repos-group/my-git-repo.git`
   `user@host:path/to/git/repo.git` - 显示为 `gituser@git-server-url:git-server-repos-group/my-git-repo.git` 

Blue Ocean automatically generates an SSH public/private key pair or  provides you with an existing pair for the current Jenkins user. This credential is automatically registered in Jenkins with the  following details for this Jenkins user:
Blue Ocean 会自动生成 SSH 公钥/私钥对，或为当前 Jenkins 用户提供现有密钥对。此凭证会自动在 Jenkins 中注册，其中包含此 Jenkins 用户的以下详细信息：

- **Domain**: `blueocean-private-key-domain`
  **域名**：`blueocean-private-key-domain`
- **ID**: `jenkins-generated-ssh-key`
  **ID**：`jenkins-generated-ssh-key`
- **Name**: `<jenkins-username> (jenkins-generated-ssh-key)` **名称**： `<jenkins-username> (jenkins-generated-ssh-key)` 

You must ensure that this SSH public/private key pair is registered with your Git server before continuing.
在继续之前，您必须确保此 SSH 公钥/私钥对已注册到 Git 服务器。

If you have not already done this, follow these two steps.
如果您尚未执行此操作，请遵循以下两个步骤。

1. Configure the SSH public key component of this key pair (which you can copy and  paste from the Blue Ocean interface) for the remote Git server’s user   account (e.g., within the `authorized_keys` file of the machine’s `gituser/.ssh` directory).
   为远程 Git 服务器的用户账户（例如，在机器的 `gituser/.ssh` 目录的 `authorized_keys` 文件中）配置此密钥对的 SSH 公钥组件（您可以从 Blue Ocean 界面复制和粘贴）。

   |      | This process allows your Jenkins user to access the repositories that  your Git server’s user account has access to. Refer to the ["Setting Up the Server"](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server) of the [Pro Git documentation](https://git-scm.com/book/en/v2/).  此过程允许您的 Jenkins 用户访问您的 Git 服务器的用户账户有权访问的存储库。请参阅 [Pro Git 文档](https://git-scm.com/book/en/v2/)的 [“设置服务器”。](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server) |
   | ---- | ------------------------------------------------------------ |
   |      |                                                              |

2. Return to the Blue Ocean interface.
   返回 Blue Ocean 界面。

Select the **Create Pipeline** option.
选择 **Create Pipeline** 选项。

Blue Ocean scans your local repository’s branches for a `Jenkinsfile` and starts a Pipeline run for each branch containing a `Jenkinsfile`. If Blue Ocean does not find a `Jenkinsfile` you are prompted to create one through the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor).
Blue Ocean 扫描本地存储库的分支以查找 `Jenkinsfile`，并为每个包含 `Jenkinsfile` 的分支启动 Pipeline 运行。如果 Blue Ocean 没有找到 `Jenkinsfile`，系统会提示您通过 [Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)创建一个。

### For a repository on GitHub 对于 GitHub 上的存储库

To create your Pipeline project directly for a repository on GitHub, select the **GitHub** option under **Where do you store your code?**.
要直接为 GitHub 上的存储库创建 Pipeline 项目，请在 **Where do you store your code （您将代码存储在何处？**） 下选择 **GitHub** 选项。

![Where do you store your code](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/where-do-you-store-your-code.png)

In the **Connect to GitHub** section, enter your GitHub access token into the **Your GitHub access token** field.
在 **Connect to GitHub （连接到 GitHub**） 部分中，在 **Your GitHub access token （您的 GitHub 访问令牌） 字段中输入您的 GitHub 访问令牌**。
 If you previously configured Blue Ocean to connect to GitHub using a personal access token, Blue Ocean takes you directly to the [GitHub account/organization and repository choice](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-github-account) steps below:
如果您之前将 Blue Ocean 配置为使用个人访问令牌连接到 GitHub，则 Blue Ocean 会将您直接转到 [GitHub 帐户/组织和仓库选择](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-github-account)步骤如下：

![Connect to GitHub](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/connect-to-github.png)

If you do not have a GitHub access token, select the **Create an access key here** option to open GitHub to the [New personal access token](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#create-your-access-token) page.
如果您没有 GitHub 访问令牌，请选择 **Create an access key here （在此处创建访问密钥**） 选项，将 GitHub 打开 New [personal access token （新建个人访问令牌](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#create-your-access-token)） 页面。

#### Create your access token 创建您的访问令牌

1. In the new tab, sign in to your GitHub account. On the **New Personal Access Token** page, specify a brief **Token description** for your GitHub access token, such as `Blue Ocean`.
   在新选项卡中，登录到 GitHub 帐户。在 **New Personal Access Token （新建个人访问令牌**） 页面上，为您的 GitHub 访问令牌指定简短的**令牌描述**，例如 `Blue Ocean`。

   |      | An access token is usually an alphanumeric string that represents your  GitHub account, along with permissions to access various GitHub features and areas through your GitHub account. The new access token process, initiated by selecting **Create an access key here**, has the appropriate permissions pre-selected that Blue Ocean requires to access and interact with your GitHub account.  访问令牌通常是代表您的 GitHub 账户的字母数字字符串，以及通过 GitHub 账户访问各种 GitHub 功能和区域的权限。通过选择 **“在此处创建访问密钥**” 启动的新访问令牌流程预先选择了 Blue Ocean 访问您的 GitHub 账户并与之交互所需的适当权限。 |
   | ---- | ------------------------------------------------------------ |
   |      |                                                              |

2. Scroll down to the end of the page, and select **Generate token**.
   向下滚动到页面末尾，然后选择 **Generate token（生成令牌**）。

3. On the resulting **Personal access tokens** page, copy your newly generated access token.
   在生成的 **Personal access tokens** 页面上，复制新生成的访问令牌。

4. Back in Blue Ocean, paste the access token into the **Your GitHub access token** field, and then select **Connect**.
   返回 Blue Ocean，将访问令牌粘贴到 **Your GitHub access token （您的 GitHub 访问令牌**） 字段中，然后选择 **Connect （连接**）。

Your current Jenkins user now has access to your GitHub account and you can now [choose your GitHub account/organization and repository](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-github-account). Jenkins registers this credential with the following details for this Jenkins user:
您当前的 Jenkins 用户现在可以访问您的 GitHub 账户，您现在可以[选择您的 GitHub 账户/组织和存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-github-account)。Jenkins 为此 Jenkins 用户使用以下详细信息注册此凭证：

- **Domain**: `blueocean-github-domain`
  **域**：`blueocean-github-domain`
- **ID**: `github`
  **ID**：`github`
- **Name**: `<jenkins-username>/****** (GitHub Access Token)` **名称**： `<jenkins-username>/****** (GitHub Access Token)` 

#### Choose your GitHub account/organization and repository 选择您的 GitHub 帐户/组织和存储库

Blue Ocean prompts you to choose your GitHub account or an organization you are a member of. You are also asked for the repository containing your Pipeline project.
Blue Ocean 会提示您选择您的 GitHub 帐户或您所属的组织。系统还会要求您提供包含 Pipeline 项目的存储库。

1. In the **Which organization does the repository belong to?** section, select either:
   在 **Which organization does the repository belong to？**部分中，选择以下任一选项：

   - Your GitHub account, to create a Pipeline project for one of your own GitHub repositories or one which you have forked from elsewhere on GitHub.
     您的 GitHub 帐户，用于为您自己的 GitHub 存储库之一或您从 GitHub 上的其他位置分叉的存储库之一创建 Pipeline 项目。
      or 或
   - The organization of which you are a member, to create a Pipeline project  for a GitHub repository located within this organization.
     您所属的组织，用于为位于此组织内的 GitHub 存储库创建 Pipeline 项目。

2. In the **Choose a repository** section, select the repository within your GitHub account or organization from which to build your Pipeline project.
   在 **Choose a repository （选择存储库**） 部分中，选择您的 GitHub 账户 或组织中用于构建 Pipeline 项目的存储库。

   |      | If your list of repositories is long, you can use the **Search** option to filter your results.  如果您的仓库列表很长，则可以使用 **Search （搜索**） 选项来筛选结果。 |
   | ---- | ------------------------------------------------------------ |
   |      |                                                              |

![Choose a repository](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/choose-a-repository.png)

1. Click **Create Pipeline**.
   单击 **Create Pipeline （创建管道**）。

Blue Ocean scans your local repository’s branches for a `Jenkinsfile` and starts a Pipeline run for each branch containing a `Jenkinsfile`. If Blue Ocean does not find a `Jenkinsfile`, you are prompted to create one through the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor).
Blue Ocean 扫描本地存储库的分支以查找 `Jenkinsfile`，并为每个包含 `Jenkinsfile` 的分支启动 Pipeline 运行。如果 Blue Ocean 没有找到 `Jenkinsfile`，系统会提示您通过 [Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)创建一个。

|      | Under the hood, a Pipeline project created through Blue Ocean is actually a "multibranch Pipeline." Therefore, Jenkins looks for the presence of at least one Jenkinsfile in any branch of your repository.  在后台，通过 Blue Ocean 创建的 Pipeline 项目实际上是一个 “多分支 Pipeline”。因此，Jenkins 会在存储库的任何分支中查找至少一个 Jenkinsfile。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### For a repository on Bitbucket Cloud 对于 Bitbucket Cloud 上的存储库

To create your Pipeline project directly for a Git or Mercurial repository on Bitbucket Cloud, select the **Bitbucket Cloud** button under **Where do you store your code?**
要直接在 Bitbucket Cloud 上为 Git 或 Mercurial 存储库创建 Pipeline 项目，请选择“**将代码存储在哪里”**下的“**Bitbucket Cloud**”按钮。

![Where do you store your code](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/where-do-you-store-your-code.png)

In the **Connect to Bitbucket** section, enter your Bitbucket email address and password into the **Username** and **Password** fields.
在 **Connect to Bitbucket （连接到 Bitbucket**） 部分中，在 **Username （用户名**） 和 **Password （密码**） 字段中输入您的 Bitbucket 电子邮件地址和密码。

- If you previously configured Blue Ocean to connect to Bitbucket with your  email address and password, Blue Ocean takes you directly to the [Bitbucket account/team and repository selection](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-bitbucket-account) steps below.
  如果您之前将 Blue Ocean 配置为使用电子邮件地址和密码连接到 Bitbucket，Blue Ocean 会将您直接带到下面的 [Bitbucket 帐户/团队和存储库选择](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-bitbucket-account)步骤。
- If you entered these credentials, Jenkins registers them with the following details for this Jenkins user:
  如果您输入了这些凭证，Jenkins 会为此 Jenkins 用户使用以下详细信息注册这些凭证：
- **Domain**: `blueocean-bitbucket-cloud-domain`
  **域**： `blueocean-bitbucket-cloud-domain` 
- **ID**: `bitbucket-cloud`
  **ID**：`bitbucket-cloud`
- **Name**: `+<bitbucket-user@email.address>/ (Bitbucket server credentials)` **名称**： `+<bitbucket-user@email.address>/ (Bitbucket server credentials)` 

![Connect to Bitbucket](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/connect-to-bitbucket.png)

Select **Connect** and your current/logged in Jenkins user will now have access to your Bitbucket account. You can now [choose your Bitbucket account/team and repository](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-bitbucket-account).
选择 **Connect（连接**），您当前/登录的 Jenkins 用户现在可以访问您的 Bitbucket 帐户。您现在可以[选择您的 Bitbucket 帐户/团队和存储库](https://www.jenkins.io/doc/book/blueocean/creating-pipelines/#choose-your-bitbucket-account)。

#### Choose your Bitbucket account/team and repository 选择您的 Bitbucket 帐户/团队和存储库

Blue Ocean prompts you to choose your Bitbucket account or a team you are a  member of, as well as the repository containing your project to be  built.
Blue Ocean 会提示您选择您的 Bitbucket 帐户或您所属的团队，以及包含要构建的项目的存储库。

1. In the **Which team does the repository belong to?** section, select either:
   在 **Which team does the repository belong to？**部分中，选择以下任一选项：

   - Your Bitbucket account to create a Pipeline project for one of your own  Bitbucket repositories, or one which you have forked from elsewhere on  Bitbucket.
     您的 Bitbucket 帐户，为您自己的 Bitbucket 存储库之一或您从 Bitbucket 上的其他位置分叉的存储库之一创建 Pipeline 项目。
   - A team of which you are a member to create a Pipeline project for a Bitbucket repository located within this team.
     您是其成员的团队，用于为位于此团队中的 Bitbucket 存储库创建 Pipeline 项目。

2. In the **Choose a repository** section, select the repository in your Bitbucket account or team from which to build your Pipeline project.
   在 **Choose a repository （选择存储库**） 部分中，选择您的 Bitbucket 账户或团队中用于构建 Pipeline 项目的存储库。

   |      | If your list of repositories is long, you can filter this list using the **Search** option.  如果您的存储库列表很长，则可以使用 **Search （搜索）** 选项筛选此列表。 |
   | ---- | ------------------------------------------------------------ |
   |      |                                                              |

   ![Choose a repository](https://www.jenkins.io/doc/book/resources/blueocean/creating-pipelines/choose-a-repository.png)

3. Click **Create Pipeline**.
   单击 **Create Pipeline （创建管道**）。

Blue Ocean scans your local repository’s branches for a `Jenkinsfile` and starts a Pipeline run for each branch containing a `Jenkinsfile`. If Blue Ocean does not find a `Jenkinsfile`, you are prompted to create one through the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor).
Blue Ocean 扫描本地存储库的分支以查找 `Jenkinsfile`，并为每个包含 `Jenkinsfile` 的分支启动 Pipeline 运行。如果 Blue Ocean 没有找到 `Jenkinsfile`，系统会提示您通过 [Pipeline 编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor)创建一个。

|      | Under the hood, a Pipeline project created through Blue Ocean is actually a "multibranch Pipeline." Therefore, Jenkins looks for the presence of at least one Jenkinsfile in any branch of your repository.  在后台，通过 Blue Ocean 创建的 Pipeline 项目实际上是一个 “多分支 Pipeline”。因此，Jenkins 会在存储库的任何分支中查找至少一个 Jenkinsfile。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

# Dashboard 挡泥板

Table of Contents 目录

- [Navigation bar 导航栏](https://www.jenkins.io/doc/book/blueocean/dashboard/#navigation-bar)
- [Pipelines list 管道列表](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list)
- Favorites list 收藏夹列表
  - [Health icons 运行状况图标](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health)
  - [Run status 运行状态](https://www.jenkins.io/doc/book/blueocean/dashboard/#run-status)

Blue Ocean’s "Dashboard" is the default view when opening Blue Ocean. It displays an overview of all Pipeline projects configured on a Jenkins controller.
Blue Ocean 的 “Dashboard” 是打开 Blue Ocean 时的默认视图。它显示在 Jenkins 控制器上配置的所有 Pipeline 项目的概述。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

The Dashboard consists of a blue [navigation bar](https://www.jenkins.io/doc/book/blueocean/dashboard/#navigation-bar) at the top, the [Pipelines list](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list), and the [Favorites list](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites-list).
Dashboard 由顶部的蓝色[导航栏](https://www.jenkins.io/doc/book/blueocean/dashboard/#navigation-bar)、[Pipelines 列表](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list)和 [Favorites 列表](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites-list)组成。

![Overview of the Blue Ocean Dashboard](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/overview.png)

## Navigation bar 导航栏

The Dashboard includes the blue [navigation bar](https://www.jenkins.io/doc/book/blueocean/getting-started#navigation-bar) along the top of the interface.
Dashboard 包括界面顶部的蓝色[导航栏](https://www.jenkins.io/doc/book/blueocean/getting-started#navigation-bar)。

The bar is divided into two sections:
该栏分为两个部分：

- A common section along the top.
  沿顶部的公共部分。
- A contextual section below.
  下面的上下文部分。
  - The contextual section changes depending on the Blue Ocean page you are viewing.
    上下文部分根据您正在查看的 Blue Ocean 页面而变化。

When viewing the Dashboard, the navigation bar’s contextual section includes:
查看 Dashboard 时，导航栏的上下文部分包括：

- **Search pipelines**: This field allows users to filter the [Pipelines list](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list) to match the text you enter into this field.
  **搜索管道**：此字段允许用户筛选[管道列表](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list)，以匹配您在此字段中输入的文本。
- **New Pipeline**: This option begins the process of [creating a Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines).
  **New Pipeline （新建管道**）：此选项将开始[创建 Pipeline](https://www.jenkins.io/doc/book/blueocean/creating-pipelines) 的过程。

## Pipelines list 管道列表

The **Pipelines** list is the Dashboard’s default list. It is the only list displayed the first time Blue Ocean is accessed.
**Pipelines** 列表是 Dashboard 的默认列表。这是首次访问 Blue Ocean 时显示的唯一列表。

The list shows the overall state of each Pipeline configured in the Jenkins controller. The list can include other items configured in the Jenkins controller. The following information is displayed for each Pipeline listed:
该列表显示了在 Jenkins 控制器中配置的每个 Pipeline 的总体状态。该列表可以包含在 Jenkins 控制器中配置的其他项。对于列出的每个 Pipeline，将显示以下信息：

- The item’s **NAME** 项目的 **NAME**
- The item’s [**HEALTH**](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health)
  项目的 [**HEALTH**](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health)
- The number of **BRANCHES** and pull requests **(PRs)** that are passing or failing within the Pipeline’s source control repository.
  在管道的源代码管理存储库中通过或失败的 **BRANCHES** 和拉取请求 **（PR）** 的数量。
- A ☆, indicating whether or not the item has been manually added to your current Jenkins [Favorites list](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites-list).
  A ☆，表示该项目是否已手动添加到您当前的 Jenkins [收藏夹列表中](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites-list)。

Selecting an item’s ☆ will toggle between:
选择项目的 ☆ 将在以下之间切换：

- Adding the default branch of the item’s repository to your Favorites list, which is indicated by a solid ★.
  将项目存储库的默认分支添加到收藏夹列表，该列表由实线★表示。
- Removing the item’s default branch from this list, which is indicated by an outlined ☆.
  从此列表中删除项的默认分支，该分支由轮廓 ☆ 表示。

Selecting an item in the Pipelines list will display that item’s [Activity View](https://www.jenkins.io/doc/book/blueocean/activity).
在 Pipelines 列表中选择一个项目将显示该项目[的 Activity View （活动视图](https://www.jenkins.io/doc/book/blueocean/activity)）。

## Favorites list 收藏夹列表

The Favorites list appears above the Dashboard’s default [Pipelines list](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list) when at least one Pipeline/item is present in your Favorites list.
当 Favorites （收藏夹） 列表中至少存在一个 Pipeline/item 时，Favorites （收藏夹） 列表将显示在 Dashboard 的默认 [Pipelines （](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list)管道） 列表上方。

This list provides key information and actions for a core subset of your accessible items in the [Pipelines list](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list). This key information includes the current [run status](https://www.jenkins.io/doc/book/blueocean/dashboard/#run-status) for an item and its repository’s branch, the name of the branch, the initial part of the commit hash, and the last run time. This list also includes options to run or re-run the item on the indicated branch.
此列表为 [Pipelines 列表中](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipelines-list)可访问项目的核心子集提供关键信息和操作。此关键信息包括项目及其存储库分支的当前[运行状态](https://www.jenkins.io/doc/book/blueocean/dashboard/#run-status)、分支的名称、提交哈希的初始部分和上次运行时间。此列表还包括在指示的分支上运行或重新运行项的选项。

You should only add an item or branch to your Favorites list if it needs regular monitoring. Adding an item’s specific branch to your Favorites list can be done through the item’s [Activity View](https://www.jenkins.io/doc/book/blueocean/activity).
仅当需要定期监控时，您才应将项目或分支添加到您的收藏夹列表中。可以通过项目的 [Activity View](https://www.jenkins.io/doc/book/blueocean/activity) 将项目的特定分支添加到 Favorites 列表。

Blue Ocean automatically adds branches and PRs to this list when they  include a run that contains any modifications you have performed.
当 Blue Ocean 包含包含您执行的任何修改的运行时，它们会自动将分支和 PR 添加到此列表中。

You can also manually remove items from your Favorites list by deselecting the solid ★ in this list. When there are no longer items in this list, the list is removed from the Dashboard. Selecting the favorite ★ for any item will bring the list back to your Dashboard.
您还可以通过取消选择此列表中的实体★来手动从 Favorites （收藏夹） 列表中删除项目。当此列表中不再有项目时，将从 Dashboard 中删除该列表。为任何项目选择收藏夹★都会将列表带回您的 Dashboard。

Selecting an item in the Favorites list opens the [Pipeline run details](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details) for the latest run on the branch or PR indicated.
在 “收藏夹” 列表中选择一个项目将打开指示的分支或 PR 上的最新运行的[管道运行详细信息](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details)。

### Health icons 运行状况图标

Blue Ocean represents the overall health of a Pipeline/item or one of its branches using weather icons. These icons change depending on the number of recent builds that have passed.
Blue Ocean 使用天气图标表示 Pipeline/Item 或其分支之一的整体运行状况。这些图标会根据已传递的最近版本的数量而变化。

Health icons on the Dashboard represent overall Pipeline health, whereas the health icons in the [Branches tab of the Activity View](https://www.jenkins.io/doc/book/blueocean/activity#branches) represent the overall health for each branch.
控制面板上的运行状况图标表示管道的整体运行状况，而[活动视图的 Branches （分支） 选项卡中](https://www.jenkins.io/doc/book/blueocean/activity#branches)的运行状况图标表示每个分支的整体运行状况。

| Icon 图标                                                    | Health 健康                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![Sunny](https://www.jenkins.io/doc/book/resources/blueocean/icons/weather/sunny.svg) | **Sunny**, more than 80% of Runs passing **晴朗**，超过 80% 的跑位传球 |
| ![Partially Sunny](https://www.jenkins.io/doc/book/resources/blueocean/icons/weather/partially-sunny.svg) | **Partially Sunny**, 61% to 80% of Runs passing **部分晴天**，61% 到 80% 的跑位通过 |
| ![Cloudy](https://www.jenkins.io/doc/book/resources/blueocean/icons/weather/cloudy.svg) | **Cloudy**, 41% to 60% of Runs passing **多云**，41% 到 60% 的跑位通过 |
| ![Raining](https://www.jenkins.io/doc/book/resources/blueocean/icons/weather/raining.svg) | **Raining**, 21% to 40% of Runs passing **下雨**，21% 到 40% 的跑位传球 |
| ![Storm](https://www.jenkins.io/doc/book/resources/blueocean/icons/weather/storm.svg) | **Storm**, less than 21% of Runs passing **Storm**，不到 21% 的跑位传球 |

### Run status 运行状态

Blue Ocean represents the run status of a Pipeline/item or one of its branches using a consistent set of icons throughout.
Blue Ocean 使用一组一致的图标表示 Pipeline/item 或其分支之一的运行状态。

| Icon 图标                                                    | Status 地位            |
| ------------------------------------------------------------ | ---------------------- |
| ![In Progress](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/status-in-progress.png) | **In Progress 进行中** |
| ![Passed](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/status-passed.png) | **Passed 通过**        |
| ![Unstable](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/status-unstable.png) | **Unstable 稳定**      |
| ![Failed](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/status-failed.png) | **Failed 失败**        |
| ![Aborted](https://www.jenkins.io/doc/book/resources/blueocean/dashboard/status-aborted.png) | **Aborted 中止**       |

# Activity View Activity 视图

Table of Contents 目录

- Navigation Bar 导航栏
  - [Activity 活动](https://www.jenkins.io/doc/book/blueocean/activity/#activity)
  - [Branches 分支](https://www.jenkins.io/doc/book/blueocean/activity/#branches)
  - [Pull Requests 拉取请求](https://www.jenkins.io/doc/book/blueocean/activity/#pull-requests)

The Blue Ocean Activity view shows all activities related to one Pipeline.
Blue Ocean Activity （蓝色海洋活动） 视图显示与一个 Pipeline 相关的所有活动。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## Navigation Bar 导航栏

The Activity view includes the [standard navigation bar](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar) at the top and a local navigation bar below it.
Activity （活动） 视图包括顶部的[标准导航栏](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar)和其下方的本地导航栏。

![Navigation bars from the Activity view](https://www.jenkins.io/doc/book/resources/blueocean/activity/navigation-bars.png)

The local navigation bar includes:
本地导航栏包括：

- **Pipeline Name** - Selecting this displays the [default Activity tab](https://www.jenkins.io/doc/book/blueocean/activity/#).
  **管道名称** - 选择此选项将显示[默认的 Activity 选项卡](https://www.jenkins.io/doc/book/blueocean/activity/#)。
- **Favorites Toggle** - Selecting the favorite icon ☆ to the right of the Pipeline name, adds a branch to the favorites list shown on the [dashboard’s favorites list](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites).
  **收藏夹切换** - 选择管道名称右侧的收藏夹图标 ☆，将分支添加到[仪表板收藏夹列表](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites)上显示的收藏夹列表中。
- **Tabs** ([Activity](https://www.jenkins.io/doc/book/blueocean/activity/#activity), [Branches](https://www.jenkins.io/doc/book/blueocean/activity/#branches) [Pull Requests](https://www.jenkins.io/doc/book/blueocean/activity/#pull-requests)) - Selecting one of these navigates to the corresponding information in the Activity view.
  **选项卡** （[Activity](https://www.jenkins.io/doc/book/blueocean/activity/#activity)， [Branches](https://www.jenkins.io/doc/book/blueocean/activity/#branches)[， Pull Requests](https://www.jenkins.io/doc/book/blueocean/activity/#pull-requests)） - 选择其中一个选项卡可导航到 Activity 视图中的相应信息。

### Activity 活动

The default tab of the Activity view shows a list of the latest completed or active runs. Each line represents the [status](https://www.jenkins.io/doc/book/blueocean/dashboard/#run-status) of a run, run ID, commit information, and when the run completed.
Activity （活动） 视图的默认选项卡显示最新完成或活动的运行列表。每行表示运行[的状态](https://www.jenkins.io/doc/book/blueocean/dashboard/#run-status)、运行 ID、提交信息以及运行完成的时间。

![Default activity tab view of the Activity view](https://www.jenkins.io/doc/book/resources/blueocean/activity/overview.png)

- Selecting a run will bring up the [Pipeline run details](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/) to provide Pipeline visualization.
  选择运行将显示 [Pipeline run details （管道运行详细信息](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/)） 以提供管道可视化。
- Active runs can be aborted from this list by selecting the **stop** icon, which is represented by a ◾ within a circle.
  通过选择**停止**图标（由圆圈内的 表示◾），可以从此列表中中止活动运行。
- Runs that have been completed can be re-run by selecting the **re-run** icon ↺.
  可以通过选择**重新运行**图标 ↺ 来重新运行已完成的运行。
- The list can be filtered by branch using the "Branch" drop-down in the list header. ![Branch filter in Blue Ocean activity view](https://www.jenkins.io/doc/book/resources/blueocean/activity/branch-filter.png)
  可以使用列表标题中的 “Branch” 下拉列表按分支筛选列表。 ![Branch filter in Blue Ocean activity view](https://www.jenkins.io/doc/book/resources/blueocean/activity/branch-filter.png) 

This view does not allow runs to be edited or marked as favorites. To perform these actions, select the **Branches** tab.
此视图不允许编辑运行或将其标记为收藏夹。要执行这些操作，请选择 **Branches** 选项卡。

### Branches 分支

The **Branches** tab shows a list of all branches that have a completed or active run in the current Pipeline. Each line in the list corresponds to a branch in source control, displaying the [overall health of the branch](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health) based on the status of the most recent run, branch name, commit information, and when the run completed.
**的 Branches （分支）** 选项卡显示在当前管道中具有已完成或活动运行的所有分支的列表。列表中的每一行都对应于源代码管理中的一个分支，根据最近运行的状态、分支名称、提交信息以及运行完成时间显示[分支的整体运行状况](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health)。

![Branches tab of Activity view](https://www.jenkins.io/doc/book/resources/blueocean/activity/branches.png)

Selecting a branch brings up the [Pipeline run details](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/) for the latest completed or active run of that branch.
选择一个分支会显示该分支的最新完成或活动运行的 [Pipeline run details （管道运行详细信息](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/)）。

1. Pipelines where the latest run has been completed can be run again by selecting the **run** icon, represented by a  in a circle.
   可以通过选择**运行图标（**由圆圈中的 表示）再次运行已完成最新运行的管道。
   - Active runs can be aborted, and display a **stop** icon, which is represented by a ◾ within a circle.
     活动运行可以中止，并显示**停止**图标，该图标由圆圈内的 表示◾。
2. Selecting the **history** icon  allows you to view the run history for that branch.
   选择**历史记录**图标可查看该分支的运行历史记录。
3. The **edit** icon, represented by a , opens the [Pipeline editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/) for that branch.
   **编辑**图标（由 表示）将打开该分支的[管道编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/)。
4. The **favorite** ☆ icon adds a branch to your favorites list on the [dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites). On the dashboard a branch listed under favorites displays a solid star ★. Deselecting the star removes the branch from the favorites list.
   **收藏夹** ☆ 图标将分支添加到[仪表板](https://www.jenkins.io/doc/book/blueocean/dashboard/#favorites)上的收藏夹列表中。在仪表板上，“favorites”下列出的分支显示一个实心星号 ★ 。取消选择星号将从收藏夹列表中删除该分支。

### Pull Requests 拉取请求

The Pull Requests tab displays a list of all pull requests for the current  Pipeline, that have a completed or active run. Each line in the list corresponds to a pull request in source control,  which displays the status of the most recent run, run ID, summary,  author, and when the run completed.
Pull Requests （拉取请求） 选项卡显示当前管道的所有拉取请求的列表，这些请求已完成或活动运行。列表中的每一行都对应于源代码管理中的拉取请求，其中显示最近运行的状态、运行 ID、摘要、作者以及运行完成的时间。

![Activity Pull Requests view](https://www.jenkins.io/doc/book/resources/blueocean/activity/pull-requests.png)

Blue Ocean displays pull requests and branches separately, but the lists behave similarly. Selecting a pull request in this list will bring up the [Pipeline run details](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/) for the latest completed or active run of that pull request.
Blue Ocean 分别显示拉取请求和分支，但列表的行为类似。在此列表中选择拉取请求将显示该拉取请求的最新完成或活动运行的 [Pipeline run details（管道运行详细信息](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/)）。

- Active runs can be aborted from this list by selecting the **stop** icon, which is represented by a ◾ within a circle.
  通过选择**停止**图标（由圆圈内的 表示◾），可以从此列表中中止活动运行。
- Pull requests whose latest run has been completed can be run again by selecting the **run** icon, represented by a  in a circle.
  最近一次运行已完成的拉取请求可以通过选择**运行**图标（由圆圈中的 表示）再次运行。

The pull request list does not display [health icons](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health), and pull requests cannot be edited or marked as favorites.
拉取请求列表不显示[运行状况图标](https://www.jenkins.io/doc/book/blueocean/dashboard/#pipeline-health)，并且拉取请求无法编辑或标记为收藏夹。

|      | By default, when a pull request is closed, Jenkins removes the Pipeline  from Jenkins, and runs for that pull request are no longer accessible  from Jenkins. The Pipelines removed in this way will need to be cleaned up in the  future. This can be changed by adjusting the configuration of the underlying  multi-branch Pipeline job.  默认情况下，当拉取请求关闭时，Jenkins 会从 Jenkins 中删除管道，并且无法再从 Jenkins 访问该拉取请求的运行。以这种方式删除的 Pipeline 将来需要清理。这可以通过调整底层多分支 Pipeline 作业的配置来更改。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

# Pipeline Run Details View  Pipeline Run Details 视图

Table of Contents 目录

- [Pipeline Run Status 管道运行状态](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#pipeline-run-status)
- Special cases 特殊情况
  - [Pipelines outside of Source Control
    源代码控制之外的管道](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#pipelines-outside-of-source-control)
  - [Freestyle Projects Freestyle 项目](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#freestyle-projects)
  - [Matrix projects 矩阵项目](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#matrix-projects)
- Tabs 制表符
  - [Pipeline 管道](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#pipeline)
  - [Changes 变化](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#changes)
  - [Tests 测试](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tests)
  - [Artifacts 工件](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#artifacts)

The Blue Ocean Pipeline Run Details view shows the information related to a single Pipeline Run, and allows users to edit or replay that run. Below is a detailed overview of the parts of the Run Details view.
Blue Ocean Pipeline Run Details 视图显示与单个 Pipeline Run 相关的信息，并允许用户编辑或重放该运行。以下是 Run Details （运行详细信息） 视图各部分的详细概述。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

![Overview of the Pipeline Run Details](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/overview.png)

1. **Run Status** - An icon indicating the status of this Pipeline run. The color of the navigation bar matches the status icon.
   **Run Status （运行状态**） - 指示此 Pipeline 运行状态的图标。导航栏的颜色与状态图标匹配。
2. **Pipeline Name** - The name of this run’s Pipeline.
   **Pipeline Name （管道名称**） - 此运行的 Pipeline 的名称。
3. **Run Number** - The id number for this Pipeline run. Id numbers are unique for each Branch and Pull Request of a Pipeline.
   **Run Number （运行编号**） - 此 Pipeline 运行的 ID 号。Id 号对于管道的每个分支和拉取请求都是唯一的。
4. **View Tabs** - Access the **Pipeline**, **Changes**, **Tests**, and **Artifacts** views with one of the [tabs](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs) for this run. The default view is "[Pipeline](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#pipeline)".
   **View Tabs （视图选项卡**） - 使用此运行的[选项卡](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs)之一访问 **Pipeline （管道**）、**Changes （更改**）、Tests （**测试**） 和 Artifacts （**构件）** 视图。默认视图为 “[Pipeline](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#pipeline)”。
5. **Re-run Pipeline** - Execute this run’s Pipeline again.
   **重新运行 Pipeline** - 再次执行此运行的 Pipeline。
6. **Edit Pipeline** - Open this run’s Pipeline in the [Pipeline Editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/).
   **Edit Pipeline （编辑管道**） - 在 [Pipeline Editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/) 中打开此运行的 Pipeline。
7. **Configure** - Open the Pipeline configuration page in Jenkins.
   **配置** - 在 Jenkins 中打开 Pipeline configuration （管道配置） 页面。
8. **Go to Classic** - Switch to the "Classic" UI view of the details for this run.
   **转到 Classic** - 切换到此运行详细信息的 “Classic” UI 视图。
9. **Close Details** - Closes the Details view and returns the user to the [Activity view](https://www.jenkins.io/doc/book/blueocean/activity/) for this Pipeline.
   **Close Details （关闭详细信息**） - 关闭 Details （详细信息） 视图，并将用户返回到此管道的 [Activity （活动） 视图](https://www.jenkins.io/doc/book/blueocean/activity/)。
10. **Branch** or **Pull Request** - The branch or pull request for this run.
    **Branch** or **Pull Request** （分支或拉取请求） - 此运行的分支或拉取请求。
11. **Commit Id** - The commit id for this run.
    **Commit ID （提交 ID**） - 此运行的提交 ID。
12. **Duration** - The duration of this run.
    **Duration （持续时间**） - 此运行的持续时间。
13. **Completed Time** - When this run was completed.
    **Completed Time （完成时间**） - 此运行完成的时间。
14. **Change Author** - Names of the authors with changes in this run.
    **Change Author （更改作者**） - 此运行中发生更改的作者的姓名。
15. **Tab View** - Shows the information for the selected tab.
    **Tab View （选项卡视图**） - 显示所选选项卡的信息。

## Pipeline Run Status 管道运行状态

Blue Ocean makes it easy to see the status of the current Pipeline Run, by  changing the color of the top menu bar to match the status:
Blue Ocean 通过更改顶部菜单栏的颜色以匹配状态，可以轻松查看当前 Pipeline Run 的状态：

- Blue for "In progress" 蓝色表示“正在进行”
- Green for "Passed" 绿色表示“Passed”
- Yellow for "Unstable" 黄色表示 “Unstable”
- Red for "Failed" 红色表示 “失败”
- Gray for "Aborted" 灰色表示 “Aborted”

## Special cases 特殊情况

Blue Ocean is optimized for working with Pipelines in Source Control, but can display details for other kinds of projects. Blue Ocean offers the same [tabs](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs) for all supported projects types, but those tabs display different information depending on the type.
Blue Ocean 针对在 Source Control 中使用 Pipelines 进行了优化，但可以显示其他类型项目的详细信息。Blue Ocean 为所有支持的项目类型提供相同的[选项卡](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs)，但这些选项卡根据类型显示不同的信息。

### Pipelines outside of Source Control 源代码控制之外的管道

For Pipelines that are not based in Source Control, Blue Ocean shows the  "Commit Id", "Branch", and "Changes", but those fields are left blank. In this case, the top menu bar does not include the "Edit" option.
对于不基于源代码控制的管道，Blue Ocean 会显示“Commit Id”、“Branch”和“Changes”，但这些字段留空。在这种情况下，顶部菜单栏不包含 “Edit” 选项。

### Freestyle Projects Freestyle 项目

For Freestyle projects, Blue Ocean offers the same [tabs](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs), but the Pipeline tab only displays the console log output. The "Rerun" or "Edit" options are not available in the top menu bar.
对于 Freestyle 项目，Blue Ocean 提供相同的[选项卡](https://www.jenkins.io/doc/book/blueocean/pipeline-run-details/#tabs)，但 Pipeline 选项卡仅显示控制台日志输出。“Rerun” 或 “Edit” 选项在顶部菜单栏中不可用。

### Matrix projects 矩阵项目

Matrix projects are not supported in Blue Ocean. Viewing a Matrix project will redirect to the "Classic UI" view for that project.
Blue Ocean 不支持 Matrix 项目。查看 Matrix 项目将重定向到该项目的“Classic UI”视图。

## Tabs 制表符

Each tab of the Run Detail view provides information on a specific aspect of a run.
Run Detail （运行详细信息） 视图的每个选项卡都提供有关运行的特定方面的信息。

### Pipeline 管道

**Pipeline** is the default tab and gives an overall view of the flow of this Pipeline Run. It shows each stage and parallel branch, the steps in those stages, and the console output from those steps. The overview image above shows a successful Pipeline run. If a particular step during the run fails, this tab automatically defaults to showing the console log from the failed step. The image below shows a failed Run.
**Pipeline** 是默认选项卡，提供此 Pipeline Run  流程的总体视图。它显示每个阶段和并行分支、这些阶段中的步骤以及这些步骤的控制台输出。上面的概述图显示了成功的 Pipeline  运行。如果运行期间的特定步骤失败，则此选项卡会自动默认显示失败步骤的控制台日志。下图显示了失败的 Run。

![Failed Run](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/pipeline-failed.png)

### Changes 变化

The **Changes** tab displays the information of any changes made between the most recently completed and current runs. This includes the commit id for the change, change author, message, and date completed.
**Changes （更改**） 选项卡显示在最近完成的运行和当前运行之间所做的任何更改的信息。这包括更改的提交 ID、更改作者、消息和完成日期。

![List of Changes for a Run](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/changes-one-change.png)

### Tests 测试

The **Tests** tab shows information about test results for this run. This tab only contains information if a test result publishing step is present, such as the "Publish JUnit test results" (`junit`) step. If no results are recorded, this table displays a message. If all tests pass, this tab will report the total number of passing tests. If there are failures, the tab will display log details from the failures as shown below.
**Tests （测试**） 选项卡显示有关此运行的测试结果的信息。如果存在测试结果发布步骤，例如“发布 JUnit 测试结果”（`junit`） 步骤，则此选项卡仅包含信息。如果未记录任何结果，则此表将显示一条消息。如果所有测试都通过，此选项卡将报告通过的测试总数。如果存在失败，该选项卡将显示失败的日志详细信息，如下所示。

![Test Results for Unstable Run](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/tests-unstable.png)

When a previous run has failures, and the current run fixes those failures, this tab notes the fixes and displays their logs.
当上一个运行失败，并且当前运行修复了这些失败时，此选项卡会记录修复并显示其日志。

![Test Results for Fixed Run](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/tests-fixed.png)

### Artifacts 工件

The **Artifacts** tab shows a list of any artifacts saved using the "Archive Artifacts" (`archiveArtifacts`) step. Selecting an item in the list downloads it. The full output log from the Run can be downloaded from this list.
**Artifacts （构件**） 选项卡显示使用 “Archive Artifacts” （`archiveArtifacts`） 步骤保存的所有构件的列表。在列表中选择一个项目将下载该项目。可以从此列表下载 Run 的完整输出日志。

![List of Artifacts from a Run](https://www.jenkins.io/doc/book/resources/blueocean/pipeline-run-details/artifacts-list.png)

# Pipeline Editor Pipeline 编辑器

Table of Contents 目录

- [Starting the editor 启动编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#starting-the-editor)
- [Navigation bar 导航栏](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#navigation-bar)
- Pipeline Settings
  - [Agent 代理](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#agent)
  - [Environment 环境](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#environment)
- [Stage editor 舞台编辑器](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-editor)
- [Stage configuration 舞台配置](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-configuration)
- [Step configuration 步骤配置](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#step-configuration)
- [Save Pipeline dialog Save Pipeline 对话框](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#save-pipeline-dialog)

The Blue Ocean Pipeline Editor is an easy way for anyone to get started with creating Pipelines in Jenkins. It’s also great for existing Jenkins users to start adopting Pipeline.
Blue Ocean Pipeline Editor 是任何人都可以开始在 Jenkins 中创建管道的简单方法。对于现有的 Jenkins 用户来说，开始采用 Pipeline 也很棒。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  The [Pipeline syntax snippet generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) assists users as they define Pipeline steps with their arguments. It is the preferred tool for Jenkins Pipeline creation, as it provides  online help for the Pipeline steps available in your Jenkins controller. It uses the plugins installed on your Jenkins controller to generate the Pipeline syntax. Refer to the [Pipeline steps reference](https://www.jenkins.io/doc/pipeline/steps/) page for information on all available Pipeline steps. [Pipeline 语法代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)可帮助用户使用其参数定义 Pipeline 步骤。它是创建 Jenkins Pipeline 的首选工具，因为它为 Jenkins 控制器中可用的 Pipeline  步骤提供在线帮助。它使用安装在 Jenkins 控制器上的插件来生成 Pipeline 语法。请参阅 [Pipeline steps 参考](https://www.jenkins.io/doc/pipeline/steps/)页面 以了解有关所有可用 Pipeline 步骤的信息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

The editor allows users to create and edit Declarative Pipelines and  perform actions such as adding stages or configuring parallel tasks,  depending on their needs. When the user completes their configuration, the editor saves the  Pipeline to a source code repository as a `Jenkinsfile`. If the Pipeline requires further modification, Blue Ocean makes it easy  to jump back into the visual editor to modify the Pipeline at any time.
该编辑器允许用户创建和编辑声明式管道，并根据自己的需要执行添加阶段或配置并行任务等操作。当用户完成配置后，编辑器会将 Pipeline 作为 `Jenkinsfile` 保存到源代码存储库中。如果 Pipeline 需要进一步修改，Blue Ocean 可以轻松跳回到可视化编辑器，以便随时修改 Pipeline。

<iframe width="640" height="360" src="https://www.youtube.com/embed/FhDomw6BaHU?rel=0" frameborder="0" allowfullscreen=""></iframe>

|      | Blue Ocean Pipeline Editor limitations Blue Ocean Pipeline Editor 限制 The Blue Ocean Pipeline Editor is a great alternative for Jenkins users, but there are some limitations to its functionality: Blue Ocean Pipeline Editor 是 Jenkins 用户的绝佳选择，但其功能存在一些限制：   The editor utilizes SCM-based Declarative Pipelines only. 编辑器仅使用基于 SCM 的声明性管道。  User credentials must have write permission. 用户凭证必须具有写入权限。  The editor does not have full parity with Declarative Pipeline. 编辑器与 Declarative Pipeline 不完全对等。  The Pipeline is re-ordered and comments are removed. 管道将重新排序并删除注释。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## Starting the editor 启动编辑器

To use the editor, a user must first [create a Pipeline in Blue Ocean](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#creating-pipelines) or have at least one existing Pipeline in Jenkins. If editing an existing Pipeline, the credentials for that Pipeline must allow pushing changes to the target repository.
要使用该编辑器，用户必须首先[在 Blue Ocean 中创建一个 Pipeline](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#creating-pipelines)，或者在 Jenkins 中至少有一个现有 Pipeline。如果编辑现有 Pipeline，则该 Pipeline 的凭证必须允许将更改推送到目标存储库。

The editor can be launched through the:
编辑器可以通过以下方式启动：

- **New Pipeline** option from the [Blue Ocean dashboard](https://www.jenkins.io/doc/book/blueocean/dashboard/).
  [Blue Ocean 控制面板](https://www.jenkins.io/doc/book/blueocean/dashboard/)中的 **New Pipeline** 选项。
- **Branches** tab within the [Activity view](https://www.jenkins.io/doc/book/blueocean/activity/#branches).
  **Activity** [（活动） 视图中](https://www.jenkins.io/doc/book/blueocean/activity/#branches)的 Branches （分支） 选项卡。
- **Edit** () in the Pipeline run details view.
  **在** Pipeline run details （管道运行详细信息） 视图中编辑 （）。

## Navigation bar 导航栏

The Pipeline editor includes the [standard navigation bar](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar) at the top, with a local navigation bar below it. The local navigation bar includes:
Pipeline 编辑器在顶部包含[标准导航栏](https://www.jenkins.io/doc/book/blueocean/getting-started/#navigation-bar)，其下方有一个本地导航栏。本地导航栏包括：

- **Pipeline Name** - This also includes the branch name.
  **管道名称** - 这还包括分支名称。
- **Cancel** - Discards changes made to the pipeline.
  **Cancel** - 放弃对管道所做的更改。
- **Save** - Opens the [save Pipeline dialog](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#save-pipeline-dialog).
  **Save** - 打开 [save Pipeline 对话框](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#save-pipeline-dialog)。

## Pipeline Settings

By default, the pane on the right side of the editor displays the **Pipeline Settings**. Selecting an existing stage or adding a stage displays the [stage configuration](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-configuration) pane instead. To navigate back to the **Pipeline Settings** pane, select any empty space in the background of the editor. Within the Pipeline Settings pane, there are two sections that are configurable.
默认情况下，编辑器右侧的窗格显示 **Pipeline Settings （工作流设置**）。选择现有阶段或添加阶段将显示[阶段配置](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-configuration)窗格。要导航回 **Pipeline Settings （工作流设置）** 窗格，请选择编辑器背景中的任何空白区域。在 Pipeline Settings （工作流设置） 窗格中，有两个部分是可配置的。

### Agent 代理

The **Agent** section controls which agent the Pipeline uses. This performs the same process as the [agent directive](https://www.jenkins.io/doc/book/pipeline/syntax/#agent). The **Image** field allows users to configure which container image runs when the Pipeline is active.
**Agent （代理）** 部分控制 Pipeline 使用的代理。这将执行与 [agent 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#agent)相同的过程。**Image** 字段允许用户配置在 Pipeline 处于活动状态时运行的容器镜像。

### Environment 环境

The **Environment** section allows users to configure environment variables for the Pipeline. This is the same process as the [environment directive](https://www.jenkins.io/doc/book/pipeline/syntax/#environment).
**Environment** 部分允许用户为 Pipeline 配置环境变量。此过程与 [environment 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#environment)相同。

## Stage editor 舞台编辑器

The left pane displays the stage editor UI, which allows users to create or add stages of a Pipeline.
左侧窗格显示阶段编辑器 UI，它允许用户创建或添加管道的阶段。

![Stage editor view of new pipeline.](https://www.jenkins.io/doc/book/resources/blueocean/editor/stage-editor-basic.png)

- To add a stage to the Pipeline, select the  icon to the right of an existing stage. Selecting the  icon below an existing stage adds a parallel stage.
  要将阶段添加到管道，请选择现有阶段右侧的图标。选择现有阶段下方的图标可添加并行阶段。
- To delete unwanted stages, use the [more menu in the stage configuration pane](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-configuration).
  要删除不需要的阶段，请使用 [stage configuration 窗格中的 more （更多） 菜单](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/#stage-configuration)。

After setting the stage name and saving, the name displays above the stage. Stages that contain incomplete or invalid information display a . Pipelines can have validation errors during editing, but saving is blocked until the errors are fixed.
设置舞台名称并保存后，该名称将显示在舞台上方。包含不完整或无效信息的阶段会显示一个 .管道在编辑过程中可能会出现验证错误，但在修复错误之前，保存会被阻止。

![Stage editor with error displayed.](https://www.jenkins.io/doc/book/resources/blueocean/editor/stage-editor-error.png)

## Stage configuration 舞台配置

Selecting a stage in the editor displays the **Stage Configuration** pane on the right side of the screen. Here, you can modify the name of the stage, delete the stage, and add steps to a stage.
在编辑器中选择一个阶段会在屏幕右侧显示 **Stage Configuration （阶段配置**） 窗格。在这里，您可以修改阶段的名称、删除阶段以及向阶段添加步骤。

![Stage configuration pane](https://www.jenkins.io/doc/book/resources/blueocean/editor/stage-configuration.png)

The name of the stage can be set at the top of the stage configuration pane. The more menu, represented by three dots to the right of the stage name, allows users to delete the currently selected stage. Selecting **Add step** displays the list of available step types. After selecting a step type, the page displays the step configuration pane.
阶段的名称可以在阶段配置窗格的顶部设置。more 菜单（由阶段名称右侧的三个点表示）允许用户删除当前选定的阶段。选择 **Add step （添加步骤**） 将显示可用步骤类型的列表。选择步骤类型后，页面将显示步骤配置窗格。

![Step list filtered by 'file'](https://www.jenkins.io/doc/book/resources/blueocean/editor/step-list.png)

## Step configuration 步骤配置

This pane display is based on the step type selected, and contains the necessary fields or controls.
此窗格显示基于所选的步骤类型，并包含必要的字段或控件。

![Step configuration for JUnit step](https://www.jenkins.io/doc/book/resources/blueocean/editor/step-configuration.png)

Be sure to provide a strong name for the step, as the name retains its original configuration. Deleting the step and recreating it is the only way to provide a different name. The more menu, represented by three dots to the right of the step name, allows users to delete the current step. Fields that contain incomplete or invalid information display a . Any validation errors must be addressed before saving.
请务必为步骤提供强名称，因为该名称会保留其原始配置。删除步骤并重新创建它是提供其他名称的唯一方法。more 菜单由步骤名称右侧的三个点表示，允许用户删除当前步骤。包含不完整或无效信息的字段会显示 .在保存之前，必须解决任何验证错误。

![Step configuration with error](https://www.jenkins.io/doc/book/resources/blueocean/editor/step-error.png)

## Save Pipeline dialog Save Pipeline 对话框

Changes to a Pipeline must be saved in source control before running. The **Save Pipeline** dialog controls the saving of changes to source control.
在运行之前，必须将对 Pipeline 的更改保存在源代码管理中。**Save Pipeline** 对话框控制对源代码控制的更改的保存。

![Save Pipeline dialog](https://www.jenkins.io/doc/book/resources/blueocean/editor/save-pipeline.png)

You can optionally enter a description of the changes before saving. The dialog also provides options for saving changes to the same branch or creating a new branch to save to. Selecting **Save & run** saves any changes to the Pipeline as a new commit, starts a new Pipeline run based on those changes, and navigates to the [Activity view](https://www.jenkins.io/doc/book/blueocean/activity/) for this pipeline.
您可以选择在保存之前输入更改的描述。该对话框还提供了用于将更改保存到同一分支或创建要保存到的新分支的选项。选择**保存并运行**会将对管道的任何更改保存为新的提交，根据这些更改启动新的管道运行，并导航到此管道的活动[视图](https://www.jenkins.io/doc/book/blueocean/activity/)。