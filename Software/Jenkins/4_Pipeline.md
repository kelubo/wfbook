# Pipeline 管道

Chapter Sub-Sections 章节小节

- [ Getting started with Pipeline 
  Pipeline 入门](https://www.jenkins.io/doc/book/pipeline/getting-started)
- [ Using a Jenkinsfile  使用 Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile)
- [ Running Pipelines  运行管道](https://www.jenkins.io/doc/book/pipeline/running-pipelines)
- [ Branches and Pull Requests 
  分支和拉取请求](https://www.jenkins.io/doc/book/pipeline/multibranch)
- [ Using Docker with Pipeline 
  将 Docker 与 Pipeline 结合使用](https://www.jenkins.io/doc/book/pipeline/docker)
- [ Extending with Shared Libraries 
  使用共享库进行扩展](https://www.jenkins.io/doc/book/pipeline/shared-libraries)
- [ Pipeline Development Tools 
  管道开发工具](https://www.jenkins.io/doc/book/pipeline/development)
- [ Pipeline Syntax  管道语法](https://www.jenkins.io/doc/book/pipeline/syntax)
- [ Pipeline as Code  管道即代码](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code)
- [ Pipeline Best Practices  管道最佳实践](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices)
- [ Scaling Pipelines  扩展管道](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline)
- [ Pipeline CPS Method Mismatches 
  管道 CPS 方法不匹配](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches)

Table of Contents 目录

- What is Jenkins Pipeline?
  什么是 Jenkins 管道？
  - [Declarative versus Scripted Pipeline syntax
    声明性与脚本化管道语法](https://www.jenkins.io/doc/book/pipeline/#declarative-versus-scripted-pipeline-syntax)
- [Why Pipeline? 为什么选择 Pipeline？](https://www.jenkins.io/doc/book/pipeline/#why)
- Pipeline concepts 管道概念
  - [Pipeline 管道](https://www.jenkins.io/doc/book/pipeline/#pipeline)
  - [Node 节点](https://www.jenkins.io/doc/book/pipeline/#node)
  - [Stage 阶段](https://www.jenkins.io/doc/book/pipeline/#stage)
  - [Step 步](https://www.jenkins.io/doc/book/pipeline/#step)
- Pipeline syntax overview Pipeline 语法概述
  - [Declarative Pipeline fundamentals
    声明式管道基础知识](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals)
  - [Scripted Pipeline fundamentals
    脚本化管道基础知识](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals)
- [Pipeline example 管道示例](https://www.jenkins.io/doc/book/pipeline/#pipeline-example)

This chapter covers all recommended aspects of Jenkins Pipeline functionality, including how to:
本章介绍了 Jenkins Pipeline 功能的所有推荐方面，包括如何：

- [get started with Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started) — covers how to [define a Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline) (i.e. your `Pipeline`) through [Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started#through-blue-ocean), through the [classic UI](https://www.jenkins.io/doc/book/pipeline/getting-started#through-the-classic-ui) or in [SCM](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline-in-scm),
  [管道入门](https://www.jenkins.io/doc/book/pipeline/getting-started) — 介绍如何通过 [Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started#through-blue-ocean)、[经典 UI](https://www.jenkins.io/doc/book/pipeline/getting-started#through-the-classic-ui) 或 [SCM](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline-in-scm) [定义 Jenkins 管道](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline)（即您的`管道`），
- [create and use a `Jenkinsfile`](https://www.jenkins.io/doc/book/pipeline/jenkinsfile) — covers use-case scenarios on how to craft and construct your `Jenkinsfile`,
  [创建和使用 `Jenkinsfile`](https://www.jenkins.io/doc/book/pipeline/jenkinsfile) — 涵盖有关如何制作和构造 `Jenkinsfile` 的用例场景，
- work with [branches and pull requests](https://www.jenkins.io/doc/book/pipeline/multibranch),
  使用[分支和拉取请求](https://www.jenkins.io/doc/book/pipeline/multibranch)，
- [use Docker with Pipeline](https://www.jenkins.io/doc/book/pipeline/docker) — covers how Jenkins can invoke Docker containers on agents/nodes (from a `Jenkinsfile`) to build your Pipeline projects,
  [将 Docker 与 Pipeline 结合使用](https://www.jenkins.io/doc/book/pipeline/docker) — 介绍 Jenkins 如何调用代理/节点上的 Docker 容器（从 `Jenkinsfile`）来构建 Pipeline 项目，
- [extend Pipeline with shared libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries),
  [使用共享库扩展 Pipeline](https://www.jenkins.io/doc/book/pipeline/shared-libraries)，
- use different [development tools](https://www.jenkins.io/doc/book/pipeline/development) to facilitate the creation of your Pipeline, and
  使用不同的[开发工具](https://www.jenkins.io/doc/book/pipeline/development)来促进 Pipeline 的创建，以及
- work with [Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/syntax) — this page is a comprehensive reference of all Declarative Pipeline syntax.
  使用 [Pipeline 语法](https://www.jenkins.io/doc/book/pipeline/syntax) — 此页面是所有声明性 Pipeline 语法的全面参考。

For an overview of content in the Jenkins User Handbook, see [User Handbook Overview](https://www.jenkins.io/doc/book/pipeline/getting-started).
有关 Jenkins 用户手册中内容的概述，请参阅[用户手册概述](https://www.jenkins.io/doc/book/pipeline/getting-started)。

## What is Jenkins Pipeline? 什么是 Jenkins 管道？

Jenkins Pipeline (or simply "Pipeline" with a capital "P") is a suite of plugins which supports implementing and integrating *continuous delivery pipelines* into Jenkins.
Jenkins Pipeline（或简称为大写“P”的“Pipeline”）是一套插件，支持实现*持续交付管道*并将其集成到 Jenkins 中。

A *continuous delivery (CD) pipeline* is an automated expression of your process for getting software from version control right through to your users and customers. Every change to your software (committed in source control) goes through a complex process on its way to being released. This process involves building the software in a reliable and repeatable manner, as well as progressing the built software (called a "build") through multiple stages of testing and deployment.
*持续交付 （CD） 管道*是将软件从版本控制直接交付给用户和客户的流程的自动化表达。对软件的每项更改（在源代码管理中提交）在发布过程中都会经历一个复杂的过程。此过程涉及以可靠且可重复的方式构建软件，以及通过测试和部署的多个阶段来推进构建的软件（称为“构建”）。

Pipeline provides an extensible set of tools for modeling simple-to-complex delivery pipelines "as code" via the [Pipeline domain-specific language (DSL) syntax](https://www.jenkins.io/doc/book/pipeline/syntax). [[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)]
Pipeline 提供了一组可扩展的工具，用于通过 [Pipeline 域特定语言 （DSL） 语法](https://www.jenkins.io/doc/book/pipeline/syntax)将简单到复杂的交付管道“即代码”建模。[[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)]

The definition of a Jenkins Pipeline is written into a text file (called a [`Jenkinsfile`](https://www.jenkins.io/doc/book/pipeline/jenkinsfile)) which in turn can be committed to a project’s source control repository. [[2](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_2)] This is the foundation of "Pipeline-as-code"; treating the CD pipeline as a part of the application to be versioned and reviewed like any other code.
Jenkins Pipeline 的定义被写入文本文件（称为 [`Jenkinsfile`](https://www.jenkins.io/doc/book/pipeline/jenkinsfile)），而文本文件又可以提交到项目的源代码控制存储库。[[2](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_2)] 这是“管道即代码”的基础;将 CD 管道视为应用程序的一部分，以便像任何其他代码一样进行版本控制和审查。

Creating a `Jenkinsfile` and committing it to source control provides a number of immediate benefits:
创建 `Jenkinsfile` 并将其提交到源代码管理提供了许多直接的好处：

- Automatically creates a Pipeline build process for all branches and pull requests.
  自动为所有分支和拉取请求创建 Pipeline 构建过程。
- Code review/iteration on the Pipeline (along with the remaining source code).
  Pipeline 上的代码审查/迭代（以及剩余的源代码）。
- Audit trail for the Pipeline.
  管道的审计跟踪。
- Single source of truth [[3](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_3)] for the Pipeline, which can be viewed and edited by multiple members of the project.
  管道的单一事实来源 [[3](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_3)]，可由项目的多个成员查看和编辑。

While the syntax for defining a Pipeline, either in the web UI or with a `Jenkinsfile` is the same, it is generally considered best practice to define the Pipeline in a `Jenkinsfile` and check that in to source control.
虽然在 Web UI 中或使用 `Jenkinsfile` 定义流水线的语法相同，但通常认为在 `Jenkinsfile` 中定义流水线并将其签入源代码控制是最佳实践。

### Declarative versus Scripted Pipeline syntax 声明性与脚本化管道语法

A `Jenkinsfile` can be written using two types of syntax — Declarative and Scripted.
`Jenkinsfile` 可以使用两种类型的语法编写 — 声明式和脚本式。

Declarative and Scripted Pipelines are constructed fundamentally differently. Declarative Pipeline is a more recent feature of Jenkins Pipeline which:
声明式管道和脚本化管道的构造从根本上不同。声明式管道是 Jenkins 管道的一个较新的功能，它：

- provides richer syntactical features over Scripted Pipeline syntax, and
  提供比 Scripted Pipeline 语法更丰富的语法功能，以及
- is designed to make writing and reading Pipeline code easier.
  旨在简化 Pipeline 代码的编写和读取。

Many of the individual syntactical components (or "steps") written into a `Jenkinsfile`, however, are common to both Declarative and Scripted Pipeline. Read more about how these two types of syntax differ in [Pipeline concepts](https://www.jenkins.io/doc/book/pipeline/#pipeline-concepts) and [Pipeline syntax overview](https://www.jenkins.io/doc/book/pipeline/#pipeline-syntax-overview) below.
然而，写入 `Jenkinsfile` 的许多单独的语法组件（或“步骤”）对于声明式流水线和脚本化流水线都是通用的。有关这两种类型的语法有何区别的更多信息，请参阅下面的 [Pipeline 概念](https://www.jenkins.io/doc/book/pipeline/#pipeline-concepts)和 [Pipeline 语法概述](https://www.jenkins.io/doc/book/pipeline/#pipeline-syntax-overview)。

## Why Pipeline? 为什么选择 Pipeline？

Jenkins is, fundamentally, an automation engine which supports a number of automation patterns. Pipeline adds a powerful set of automation tools onto Jenkins, supporting use cases that span from simple continuous integration to comprehensive CD pipelines. By modeling a series of related tasks, users can take advantage of the many features of Pipeline:
从根本上说，Jenkins 是一个支持多种自动化模式的自动化引擎。Pipeline 在 Jenkins 上添加了一组强大的自动化工具，支持从简单的持续集成到全面的 CD  管道的使用案例。通过对一系列相关任务进行建模，用户可以利用 Pipeline 的许多功能：

- **Code**: Pipelines are implemented in code and typically checked into source control, giving teams the ability to edit, review, and iterate upon their delivery pipeline.
  **代码**：管道在代码中实现，通常签入源代码管理，使团队能够编辑、审查和迭代其交付管道。
- **Durable**: Pipelines can survive both planned and unplanned restarts of the Jenkins controller.
  **持久：**管道可以在 Jenkins 控制器的计划内和计划外重启中继续存在。
- **Pausable**: Pipelines can optionally stop and wait for human input or approval before continuing the Pipeline run.
  **Pausable**：Pipelines 可以选择停止并等待人工输入或批准，然后再继续 Pipeline 运行。
- **Versatile**: Pipelines support complex real-world CD requirements, including the ability to fork/join, loop, and perform work in parallel.
  **多功能**：管道支持复杂的实际 CD 要求，包括分叉/联接、循环和并行执行工作的能力。
- **Extensible**: The Pipeline plugin supports custom extensions to its DSL [[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)] and multiple options for integration with other plugins.
  **可扩展**：Pipeline 插件支持对其 DSL [[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)] 的自定义扩展，以及用于与其他插件集成的多个选项。

While Jenkins has always allowed rudimentary forms of chaining Freestyle Jobs together to perform sequential tasks, [[4](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_4)] Pipeline makes this concept a first-class citizen in Jenkins.
虽然 Jenkins 一直允许将 Freestyle 作业链接在一起的基本形式来执行顺序任务，但 [[4](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_4)] Pipeline 使这个概念成为 Jenkins 中的一等公民。

What is the difference between Freestyle and Pipeline in Jenkins
Jenkins 中的 Freestyle 和 Pipeline 有什么区别

<iframe width="800" height="420" src="https://www.youtube.com/embed/IOUm1lw7F58?rel=0" frameborder="0" allowfullscreen=""></iframe>

Building on the core Jenkins value of extensibility, Pipeline is also extensible both by users with [Pipeline Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries) and by plugin developers. [[5](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_5)]
Pipeline 基于 Jenkins 的核心价值可扩展性构建，可供使用 [Pipeline 共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries)的用户和插件开发人员进行扩展。[[5](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_5)]

The flowchart below is an example of one CD scenario easily modeled in Jenkins Pipeline:
下面的流程图是在 Jenkins Pipeline 中轻松建模的一个 CD 场景示例：

![Pipeline Flow](https://www.jenkins.io/doc/book/resources/pipeline/realworld-pipeline-flow.png)

## Pipeline concepts 管道概念

The following concepts are key aspects of Jenkins Pipeline, which tie in closely to Pipeline syntax (see the [overview](https://www.jenkins.io/doc/book/pipeline/#pipeline-syntax-overview) below).
以下概念是 Jenkins Pipeline 的关键方面，它们与 Pipeline 语法密切相关（请参阅下面的[概述](https://www.jenkins.io/doc/book/pipeline/#pipeline-syntax-overview)）。

### Pipeline 管道

A Pipeline is a user-defined model of a CD pipeline. A Pipeline’s code defines your entire build process, which typically includes stages for building an application, testing it and then delivering it.
Pipeline 是用户定义的 CD 管道模型。Pipeline 的代码定义了您的整个构建过程，其中通常包括构建应用程序、测试应用程序然后交付应用程序的阶段。

Also, a `pipeline` block is a [key part of Declarative Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals).
此外，`管道`块是[声明性管道语法的关键部分](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals)。

### Node 节点

A node is a machine which is part of the Jenkins environment and is capable of executing a Pipeline.
节点是 Jenkins 环境的一部分，能够执行 Pipeline 的机器。

Also, a `node` block is a [key part of Scripted Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals).
此外，`节点`块是[脚本化管道语法的关键部分](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals)。

### Stage 阶段

A `stage` block defines a conceptually distinct subset of tasks performed through the entire Pipeline (e.g. "Build", "Test" and "Deploy" stages), which is used by many plugins to visualize or present Jenkins Pipeline status/progress. [[6](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_6)]
`阶段`块定义了通过整个 Pipeline 执行的任务的概念上不同的子集（例如“构建”、“测试”和“部署”阶段），许多插件使用它来可视化或呈现 Jenkins Pipeline 状态/进度。[[6](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_6)]

### Step 步

A single task. Fundamentally, a step tells Jenkins *what* to do at a particular point in time (or "step" in the process). For example, to execute the shell command `make`, use the `sh` step: `sh 'make'`. When a plugin extends the Pipeline DSL, [[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)] that typically means the plugin has implemented a new *step*.
单个任务。从根本上说，一个步骤告诉 Jenkins 在特定时间点（或流程中的“步骤”）要*做什么*。例如，要执行 shell 命令 `make`，请使用 `sh` 步骤：`sh 'make'`。当插件扩展 Pipeline DSL 时，[[1](https://www.jenkins.io/doc/book/pipeline/#_footnotedef_1)] 这通常意味着该插件已经实现了一个新的*步骤*。

## Pipeline syntax overview Pipeline 语法概述

The following Pipeline code skeletons illustrate the fundamental differences between [Declarative Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals) and [Scripted Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals).
以下 Pipeline 代码框架说明了[声明性 Pipeline 语法](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals)和 [Scripted Pipeline 语法](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals)之间的基本区别。

Be aware that both [stages](https://www.jenkins.io/doc/book/pipeline/#stage) and [steps](https://www.jenkins.io/doc/book/pipeline/#step) (above) are common elements of both Declarative and Scripted Pipeline syntax.
请注意，[阶段](https://www.jenkins.io/doc/book/pipeline/#stage)和[步骤](https://www.jenkins.io/doc/book/pipeline/#step)（如上所述）都是声明性管道语法和脚本化管道语法的常见元素。

### Declarative Pipeline fundamentals 声明式管道基础知识

In Declarative Pipeline syntax, the `pipeline` block defines all the work done throughout your entire Pipeline.
在 Declarative Pipeline 语法中，`pipeline` 块定义了整个 Pipeline 中完成的所有工作。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any 
    stages {
        stage('Build') { 
            steps {
                // 
            }
        }
        stage('Test') { 
            steps {
                // 
            }
        }
        stage('Deploy') { 
            steps {
                // 
            }
        }
    }
}
```

|      | Execute this Pipeline or any of its stages, on any available agent. 在任何可用的代理上执行此 Pipeline 或其任何阶段。 |
| ---- | ------------------------------------------------------------ |
|      | Defines the "Build" stage. 定义 “Build” 阶段。               |
|      | Perform some steps related to the "Build" stage. 执行一些与 “Build” 阶段相关的步骤。 |
|      | Defines the "Test" stage. 定义 “Test” 阶段。                 |
|      | Perform some steps related to the "Test" stage. 执行一些与 “Test” 阶段相关的步骤。 |
|      | Defines the "Deploy" stage. 定义 “Deploy” 阶段。             |
|      | Perform some steps related to the "Deploy" stage. 执行一些与 “Deploy” 阶段相关的步骤。 |

### Scripted Pipeline fundamentals 脚本化管道基础知识

In Scripted Pipeline syntax, one or more `node` blocks do the core work throughout the entire Pipeline. Although this is not a mandatory requirement of Scripted Pipeline syntax, confining your Pipeline’s work inside of a `node` block does two things:
在 Scripted Pipeline 语法中，一个或多个`节点`块执行整个 Pipeline 的核心工作。虽然这不是脚本化管道语法的强制性要求，但将管道的工作限制在`节点`块内可以做两件事：

1. Schedules the steps contained within the block to run by adding an item to the Jenkins queue. As soon as an executor is free on a node, the steps will run.
   通过将项添加到 Jenkins 队列来计划块中包含的步骤以运行。一旦节点上的执行程序空闲，这些步骤就会运行。
2. Creates a workspace (a directory specific to that particular Pipeline) where work can be done on files checked out from source control.
   创建工作区（特定于该特定 Pipeline） 中，可以在其中对从源代码管理中签出的文件执行工作。
    **Caution:** Depending on your Jenkins configuration, some workspaces may not get automatically cleaned up after a period of inactivity. See tickets and discussion linked from [JENKINS-2111](https://issues.jenkins.io/browse/JENKINS-2111) for more information.
   **谨慎：**根据您的 Jenkins 配置，某些工作区在一段时间处于非活动状态后可能不会自动清理。有关更多信息，请参阅 [JENKINS-2111](https://issues.jenkins.io/browse/JENKINS-2111) 中链接的票证和讨论。

Jenkinsfile (Scripted Pipeline)
Jenkinsfile（脚本化管道）

```groovy
node {  
    stage('Build') { 
        // 
    }
    stage('Test') { 
        // 
    }
    stage('Deploy') { 
        // 
    }
}
```

|      | Execute this Pipeline or any of its stages, on any available agent. 在任何可用的代理上执行此 Pipeline 或其任何阶段。 |
| ---- | ------------------------------------------------------------ |
|      | Defines the "Build" stage. `stage` blocks are optional in Scripted Pipeline syntax. However, implementing `stage` blocks in a Scripted Pipeline provides clearer visualization of each `stage`'s subset of tasks/steps in the Jenkins UI. 定义 “Build” 阶段。`stage` 块在 Scripted Pipeline 语法中是可选的。但是，在脚本化管道中实现`阶段`块可以在 Jenkins UI 中更清晰地可视化每个`阶段`的任务/步骤子集。 |
|      | Perform some steps related to the "Build" stage. 执行一些与 “Build” 阶段相关的步骤。 |
|      | Defines the "Test" stage. 定义 “Test” 阶段。                 |
|      | Perform some steps related to the "Test" stage. 执行一些与 “Test” 阶段相关的步骤。 |
|      | Defines the "Deploy" stage. 定义 “Deploy” 阶段。             |
|      | Perform some steps related to the "Deploy" stage. 执行一些与 “Deploy” 阶段相关的步骤。 |

## Pipeline example 管道示例

Here is an example of a `Jenkinsfile` using Declarative Pipeline syntax — its Scripted syntax equivalent can be accessed by clicking the **Toggle Scripted Pipeline** link below:
以下是使用声明式流水线语法的 `Jenkinsfile` 示例——其等效的脚本语法可以通过单击下面的 **Toggle Scripted Pipeline** 链接来访问：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') { 
            steps { 
                sh 'make' 
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish' 
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/#)*（高级）*  

|      | [`pipeline`](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-pipeline) is Declarative Pipeline-specific syntax that defines a "block" containing all content and instructions for executing the entire Pipeline. [`pipeline`](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-pipeline) 是特定于 Pipeline 的声明性语法，它定义了一个 “块” ，其中包含执行整个 Pipeline 的所有内容和指令。 |
| ---- | ------------------------------------------------------------ |
|      | [`agent`](https://www.jenkins.io/doc/book/pipeline/syntax#agent) is Declarative Pipeline-specific syntax that instructs Jenkins to allocate an executor (on a node) and workspace for the entire Pipeline. [`agent`](https://www.jenkins.io/doc/book/pipeline/syntax#agent) 是特定于 Declarative Pipeline 的语法，它指示 Jenkins 为整个 Pipeline 分配一个执行程序（在节点上）和工作区。 |
|      | `stage` is a syntax block that describes a [stage of this Pipeline](https://www.jenkins.io/doc/book/pipeline/#stage). Read more about `stage` blocks in Declarative Pipeline syntax on the [Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/syntax#stage) page. As mentioned [above](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals), `stage` blocks are optional in Scripted Pipeline syntax. `stage` 是描述[此 Pipeline 的某个阶段](https://www.jenkins.io/doc/book/pipeline/#stage)的语法块。在 [Pipeline syntax](https://www.jenkins.io/doc/book/pipeline/syntax#stage) 页面上的 Declarative Pipeline syntax 中阅读有关`阶段`块的更多信息。[如上所述](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals)，`stage` 块在 Scripted Pipeline 语法中是可选的。 |
|      | [`steps`](https://www.jenkins.io/doc/book/pipeline/syntax#steps) is Declarative Pipeline-specific syntax that describes the steps to be run in this `stage`. [`steps`](https://www.jenkins.io/doc/book/pipeline/syntax#steps) 是特定于声明性管道的语法，用于描述要在此`阶段`运行的步骤。 |
|      | `sh` is a Pipeline [step](https://www.jenkins.io/doc/book/pipeline/syntax#steps) (provided by the [Pipeline: Nodes and Processes plugin](https://plugins.jenkins.io/workflow-durable-task-step)) that executes the given shell command. `sh` 是执行给定 shell 命令的 Pipeline [步骤](https://www.jenkins.io/doc/book/pipeline/syntax#steps)（由 [Pipeline： Nodes and Processes 插件](https://plugins.jenkins.io/workflow-durable-task-step)提供）。 |
|      | `junit` is another Pipeline [step](https://www.jenkins.io/doc/book/pipeline/syntax#steps) (provided by the [JUnit plugin](https://plugins.jenkins.io/junit)) for aggregating test reports. `junit` 是另一个 Pipeline [步骤](https://www.jenkins.io/doc/book/pipeline/syntax#steps)（由 [JUnit 插件](https://plugins.jenkins.io/junit)提供），用于聚合测试报告。 |
|      | `sh` is a Pipeline [step](https://www.jenkins.io/doc/book/pipeline/syntax#steps) (provided by the [Pipeline: Nodes and Processes plugin](https://plugins.jenkins.io/workflow-durable-task-step)) that executes the given shell command. `sh` 是执行给定 shell 命令的 Pipeline [步骤](https://www.jenkins.io/doc/book/pipeline/syntax#steps)（由 [Pipeline： Nodes and Processes 插件](https://plugins.jenkins.io/workflow-durable-task-step)提供）。 |

Read more about Pipeline syntax on the [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax) page.
在 [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax) 页面上阅读有关 Pipeline 语法的更多信息。

------

[1](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_1). [Domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language)
[1](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_1). [域特定语言](https://en.wikipedia.org/wiki/Domain-specific_language)

[2](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_2). [Source control management](https://en.wikipedia.org/wiki/Version_control)
[2](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_2). [源控制管理](https://en.wikipedia.org/wiki/Version_control)

[3](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_3). [Single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth)
[3](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_3). [单一事实来源](https://en.wikipedia.org/wiki/Single_source_of_truth)

[4](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_4). Additional plugins have been used to implement complex behaviors  utilizing Freestyle Jobs such as the Copy Artifact, Parameterized  Trigger, and Promoted Builds plugins 
[4](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_4). 其他插件已用于利用 Freestyle 作业实现复杂行为，例如 Copy Artifact、Parameterized Trigger 和 Promoted Builds 插件

[5](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_5). [GitHub Branch Source plugin](https://plugins.jenkins.io/github-branch-source)
[5](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_5). [GitHub Branch Source 插件](https://plugins.jenkins.io/github-branch-source)

[6](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_6). [Blue Ocean](https://www.jenkins.io/doc/book/blueocean), [Pipeline: Stage View plugin](https://plugins.jenkins.io/pipeline-stage-view)
[6](https://www.jenkins.io/doc/book/pipeline/#_footnoteref_6). [Blue Ocean，Pipeline](https://www.jenkins.io/doc/book/blueocean)[：Stage View 插件](https://plugins.jenkins.io/pipeline-stage-view)

# Pipeline 入门

Table of Contents 目录

- [Prerequisites 先决条件](https://www.jenkins.io/doc/book/pipeline/getting-started/#prerequisites)
- Defining a Pipeline 定义管道
  - [Through Blue Ocean 穿越 Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean)
  - [Through the classic UI 通过经典 UI](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui)
  - [In SCM 在 SCM 中](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm)
- Built-in Documentation 内置文档
  - [Snippet Generator 代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)
  - [Global Variable Reference
    全局变量参考](https://www.jenkins.io/doc/book/pipeline/getting-started/#global-variable-reference)
  - [Declarative Directive Generator
    声明式指令生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#directive-generator)
- Further Reading 延伸阅读
  - [Additional Resources 其他资源](https://www.jenkins.io/doc/book/pipeline/getting-started/#additional-resources)

As mentioned [previously](https://www.jenkins.io/doc/book/pipeline/), Jenkins Pipeline is a suite of plugins that supports implementing and integrating continuous delivery pipelines into Jenkins. Pipeline provides an extensible set of tools for modeling simple-to-complex delivery pipelines "as code" via the Pipeline DSL. [[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_1)]
[如前所述](https://www.jenkins.io/doc/book/pipeline/)，Jenkins Pipeline 是一套插件，支持在 Jenkins 中实现和集成持续交付管道。Pipeline 提供了一组可扩展的工具，用于通过 Pipeline DSL 将简单到复杂的交付管道“作为代码”进行建模。[[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_1)]

This section describes how to get started with creating your Pipeline project in Jenkins and introduces you to the various ways that a `Jenkinsfile` can be created and stored.
本节介绍如何开始在 Jenkins 中创建流水线项目，并向您介绍创建和存储 `Jenkinsfile` 的各种方法。

## Prerequisites 先决条件

To use Jenkins Pipeline, you will need:
要使用 Jenkins Pipeline，您需要：

- Jenkins 2.x or later (older versions back to 1.642.3 may work but are not recommended)
  Jenkins 2.x 或更高版本（可追溯到 1.642.3 的旧版本可能有效，但不推荐使用）
- Pipeline plugin, [[2](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_2)] which is installed as part of the "suggested plugins" (specified when running through the [Post-installation setup wizard](https://www.jenkins.io/doc/book/installing/linux/#setup-wizard) after [installing Jenkins](https://www.jenkins.io/doc/book/installing)).
  管道插件，[[2](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_2)]作为“建议插件”的一部分安装（在[安装 Jenkins](https://www.jenkins.io/doc/book/installing) 后通过[安装后设置向导](https://www.jenkins.io/doc/book/installing/linux/#setup-wizard)运行时指定）。

Read more about how to install and manage plugins in [Managing Plugins](https://www.jenkins.io/doc/book/managing/plugins).
在[管理插件](https://www.jenkins.io/doc/book/managing/plugins)中阅读更多关于如何安装和管理插件的信息。

## Defining a Pipeline 定义管道

Both [Declarative and Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/#declarative-versus-scripted-pipeline-syntax) are DSLs [[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_1)] to describe portions of your software delivery pipeline. Scripted Pipeline is written in a limited form of [Groovy syntax](http://groovy-lang.org/semantics.html).
[声明式管道和脚本化管道](https://www.jenkins.io/doc/book/pipeline/#declarative-versus-scripted-pipeline-syntax)都是 DSL [[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_1)]，用于描述软件交付管道的各个部分。脚本化管道是用有限形式的 [Groovy 语法](http://groovy-lang.org/semantics.html)编写的。

Relevant components of Groovy syntax will be introduced as required throughout this documentation, so while an understanding of Groovy is helpful, it is not required to work with Pipeline.
本文档中将根据需要介绍 Groovy 语法的相关组件，因此，虽然了解 Groovy 很有帮助，但不需要使用 Pipeline。

A Pipeline can be created in one of the following ways:
可以通过以下方式之一创建 Pipeline：

- [Through Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean) - after setting up a Pipeline project in Blue Ocean, the Blue Ocean UI helps you write your Pipeline’s `Jenkinsfile` and commit it to source control.
  [通过 Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean) - 在 Blue Ocean 中设置 Pipeline 项目后，Blue Ocean UI 可帮助您编写 Pipeline 的 `Jenkinsfile` 并将其提交到源代码控制。
- [Through the classic UI](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui) - you can enter a basic Pipeline directly in Jenkins through the classic UI.
  [通过经典 UI](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui) - 您可以通过经典 UI 直接在 Jenkins 中输入基本管道。
- [In SCM](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) - you can write a `Jenkinsfile` manually, which you can commit to your project’s source control repository. [[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_3)]
  [在 SCM 中](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) - 您可以手动编写 `Jenkinsfile`，并将其提交到项目的源代码控制存储库。[[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_3)]

The syntax for defining a Pipeline with either approach is the same, but while Jenkins supports entering Pipeline directly into the classic UI, it is generally considered best practice to define the Pipeline in a `Jenkinsfile` which Jenkins will then load directly from source control.
使用这两种方法定义流水线的语法是相同的，但虽然 Jenkins 支持直接在经典 UI 中输入流水线，但通常认为最佳实践是在 `Jenkinsfile` 中定义流水线，然后 Jenkins 将直接从源代码控制加载该流水线。

This video provides basic instructions on how to write both Declarative and Scripted Pipelines.
此视频提供了有关如何编写声明式管道和脚本化管道的基本说明。

Writing a Pipeline script in Jenkins
在 Jenkins 中编写 Pipeline 脚本

<iframe width="800" height="420" src="https://www.youtube.com/embed/TiTrcFEsj7A?rel=0" frameborder="0" allowfullscreen=""></iframe>

### Through Blue Ocean 穿越 Blue Ocean

If you are new to Jenkins Pipeline, the Blue Ocean UI helps you [set up your Pipeline project](https://www.jenkins.io/doc/book/blueocean/creating-pipelines), and automatically creates and writes your Pipeline (i.e. the `Jenkinsfile`) for you through the graphical Pipeline editor.
如果您是 Jenkins Pipeline 的新手，Blue Ocean UI 可以帮助您[设置 Pipeline 项目](https://www.jenkins.io/doc/book/blueocean/creating-pipelines)，并通过图形 Pipeline 编辑器自动为您创建和写入 Pipeline（即 `Jenkinsfile`）。

As part of setting up your Pipeline project in Blue Ocean, Jenkins configures a secure and appropriately authenticated connection to your project’s source control repository. Therefore, any changes you make to the `Jenkinsfile` via Blue Ocean’s Pipeline editor are automatically saved and committed to source control.
作为在 Blue Ocean 中设置 Pipeline 项目的一部分，Jenkins 会配置一个安全且经过适当身份验证的连接，以连接到项目的源代码控制存储库。因此，您通过 Blue Ocean 的 Pipeline 编辑器对 `Jenkinsfile` 所做的任何更改都会自动保存并提交到源代码控制中。

Read more about Blue Ocean in the [Blue Ocean](https://www.jenkins.io/doc/book/blueocean) chapter and [Getting started with Blue Ocean](https://www.jenkins.io/doc/book/blueocean/getting-started) page.
在 [Blue Ocean](https://www.jenkins.io/doc/book/blueocean) 章节和 [Blue Ocean 入门](https://www.jenkins.io/doc/book/blueocean/getting-started)页面中阅读有关 Blue Ocean 的更多信息。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  The [Pipeline syntax snippet generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) assists users as they define Pipeline steps with their arguments. It is the preferred tool for Jenkins Pipeline creation, as it provides  online help for the Pipeline steps available in your Jenkins controller. It uses the plugins installed on your Jenkins controller to generate the Pipeline syntax. Refer to the [Pipeline steps reference](https://www.jenkins.io/doc/pipeline/steps/) page for information on all available Pipeline steps. [Pipeline 语法代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)可帮助用户使用其参数定义 Pipeline 步骤。它是创建 Jenkins Pipeline 的首选工具，因为它为 Jenkins 控制器中可用的 Pipeline  步骤提供在线帮助。它使用安装在 Jenkins 控制器上的插件来生成 Pipeline 语法。请参阅 [Pipeline steps 参考](https://www.jenkins.io/doc/pipeline/steps/)页面 以了解有关所有可用 Pipeline 步骤的信息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Through the classic UI 通过经典 UI

A `Jenkinsfile` created using the classic UI is stored by Jenkins itself (within the Jenkins home directory).
使用经典 UI 创建的 `Jenkinsfile` 由 Jenkins 本身存储（在 Jenkins 主目录中）。

To create a basic Pipeline through the Jenkins classic UI:
要通过 Jenkins 经典 UI 创建基本管道，请执行以下操作：

1. If required, ensure you are logged in to Jenkins.
   如果需要，请确保您已登录到 Jenkins。

2. From the Jenkins home page (i.e. the Dashboard of the Jenkins classic UI), click **New Item** at the top left.
   在 Jenkins 主页（即 Jenkins 经典 UI 的仪表板）中，单击左上角的 **New Item**。

   ![Classic UI left column](https://www.jenkins.io/doc/book/resources/pipeline/classic-ui-left-column.png)

3. In the **Enter an item name** field, specify the name for your new Pipeline project.
   在 **Enter an item name （输入项目名称**） 字段中，指定新 Pipeline 项目的名称。
    **Caution:** Jenkins uses this item name to create directories on disk. It is recommended to avoid using spaces in item names, since doing so may uncover bugs in scripts that do not properly handle spaces in directory paths.
   **谨慎：**Jenkins 使用此项名称在磁盘上创建目录。建议避免在项名称中使用空格，因为这样做可能会发现脚本中未正确处理目录路径中空格的错误。

4. Scroll down and click **Pipeline**, then click **OK** at the end of the page to open the Pipeline configuration page (whose **General** tab is selected).
   向下滚动并单击 **Pipeline**，然后单击页面末尾的 **OK** 以打开 Pipeline configuration 页面（其 **General** 选项卡处于选中状态）。

   ![Enter a name, click <strong>Pipeline</strong> and then click <strong>OK</strong>](https://www.jenkins.io/doc/book/resources/pipeline/new-item-creation.png)

5. Click the **Pipeline** tab at the top of the page to scroll down to the **Pipeline** section.
   单击页面顶部的 **Pipeline** 选项卡，向下滚动到 **Pipeline** 部分。
    **Note:** If instead you are defining your `Jenkinsfile` in source control, follow the instructions in [In SCM](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) below.
   **注意：**如果您在源代码控制中定义 `Jenkinsfile`，请按照下面[在 SCM](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) 中的说明进行操作。

6. In the **Pipeline** section, ensure that the **Definition** field indicates the **Pipeline script** option.
   在 **Pipeline** 部分中，确保 **Definition** 字段指示 **Pipeline script** 选项。

7. Enter your Pipeline code into the **Script** text area.
   在 Script text （**脚本**） 文本区域中输入您的 Pipeline 代码。
    For instance, copy the following Declarative example Pipeline code (below the *Jenkinsfile ( …​ )* heading) or its Scripted version equivalent and paste this into the **Script** text area. (The Declarative example below is used throughout the remainder of this procedure.)
   例如，复制以下声明性示例 Pipeline 代码（在 *Jenkinsfile （ ... ）*heading） 或其等效的脚本版本，然后将其粘贴到 Script text （**脚本**文本） 区域中。（下面的声明性示例将在整个过程中使用。

   Jenkinsfile (Declarative Pipeline)
   Jenkinsfile（声明式管道）

   ```groovy
   pipeline {
       agent any 
       stages {
           stage('Stage 1') {
               steps {
                   echo 'Hello world!' 
               }
           }
       }
   }
   ```

1. ​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started/#)    *(Advanced)*
   [Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/getting-started/#)*（高级）*  

   |      | `agent` instructs Jenkins to allocate an executor (on any available agent/node in the Jenkins environment) and workspace for the entire Pipeline. `agent` 指示 Jenkins 为整个 Pipeline 分配执行程序（在 Jenkins 环境中任何可用的代理/节点上）和工作区。 |
   | ---- | ------------------------------------------------------------ |
   |      | `echo` writes simple string in the console output. `echo` 在控制台输出中写入 Simple String。 |
   |      | `node` effectively does the same as `agent` (above).  `Node` 实际上与 `agent` （上面） 的作用相同。 ![Example Pipeline in the classic UI](https://www.jenkins.io/doc/book/resources/pipeline/example-pipeline-in-classic-ui.png)  **Note:** You can also select from canned *Scripted* Pipeline examples from the **try sample Pipeline** option at the top right of the **Script** text area. Be aware that there are no canned Declarative Pipeline examples available from this field. **注意：**您还可以从 **Script** 文本区域右上角的 **try sample Pipeline** 选项中选择固定的脚本*化*管道示例。请注意，此字段中没有可用的固定声明式管道示例。 |

2. Click **Save** to open the Pipeline project/item view page.
   单击 **Save** 以打开 Pipeline project/item view 页面。

3. On this page, click **Build Now** on the left to run the Pipeline.
   在此页面上，单击左侧的 **Build Now** 以运行 Pipeline。

   ![Classic UI left column on an item](https://www.jenkins.io/doc/book/resources/pipeline/classic-ui-left-column-on-item.png)

4. Under **Build History** on the left, click **#1** to access the details for this particular Pipeline run.
   在左侧的 **Build History （构建历史记录**） 下，单击 **#1** 以访问此特定 Pipeline 运行的详细信息。

5. Click **Console Output** to see the full output from the Pipeline run. The following output shows a successful run of your Pipeline.
   单击 **Console Output （控制台输出**） 以查看 Pipeline 运行的完整输出。以下输出显示了 Pipeline 的成功运行。

   ![<strong>Console Output</strong> for the Pipeline](https://www.jenkins.io/doc/book/resources/pipeline/hello-world-console-output.png)

   **Notes: 笔记：**

   - You can also access the console output directly from the Dashboard by clicking the colored globe to the left of the build number (e.g. **#1**).
     您还可以通过单击内部版本号左侧的彩色地球（例如 **#1**）直接从控制面板访问控制台输出。
   - Defining a Pipeline through the classic UI is convenient for testing Pipeline code snippets, or for handling simple Pipelines or Pipelines that do not require source code to be checked out/cloned from a repository. As mentioned above, unlike `Jenkinsfile`s you define through Blue Ocean ([above](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean)) or in source control ([below](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm)), `Jenkinsfile`s entered into the **Script** text area area of Pipeline projects are stored by Jenkins itself, within the Jenkins home directory. Therefore, for greater control and flexibility over your Pipeline, particularly for projects in source control that are likely to gain complexity, it is recommended that you use [Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean) or [source control](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) to define your `Jenkinsfile`.
     通过经典 UI 定义管道有助于测试 Pipeline 代码片段，或处理简单的管道或不需要从存储库中签出/克隆源代码的管道。如上所述，与您通过 Blue Ocean（[上图](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean)）或源代码控制（[下图](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm)）定义的 `Jenkinsfile`不同，输入到流水线项目的**脚本**文本区域区域的 `Jenkinsfile`由 Jenkins 本身存储在 Jenkins 主目录中。因此，为了更好地控制和灵活地控制流水线，特别是对于源代码控制中可能会增加复杂性的项目，建议使用 [Blue Ocean](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-blue-ocean) 或[源代码控制](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm)来定义 `Jenkinsfile`。

### In SCM 在 SCM 中

Complex Pipelines are difficult to write and maintain within the [classic UI’s](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui) **Script** text area of the Pipeline configuration page.
复杂管道很难在 Pipeline configuration （管道配置） 页面的[经典 UI 的](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui)**Script** 文本区域中编写和维护。

To make this easier, your Pipeline’s `Jenkinsfile` can be written in a text editor or integrated development environment (IDE) and committed to source control [[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_3)] (optionally with the application code that Jenkins will build). Jenkins can then check out your `Jenkinsfile` from source control as part of your Pipeline project’s build process and then proceed to execute your Pipeline.
为了简化此操作，可以在文本编辑器或集成开发环境 （IDE） 中编写流水线的 `Jenkinsfile` 并提交到源代码控制 [[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_3)]（可选择使用 Jenkins 将构建的应用程序代码）。然后，Jenkins 可以从源代码控制中签出您的 `Jenkinsfile`，作为 Pipeline 项目构建过程的一部分，然后继续执行您的 Pipeline。

To configure your Pipeline project to use a `Jenkinsfile` from source control:
要将 Pipeline 项目配置为使用源代码控制中的 `Jenkinsfile`，请执行以下操作：

1. Follow the procedure above for defining your Pipeline [through the classic UI](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui) until you reach step 5 (accessing the **Pipeline** section on the Pipeline configuration page).
   按照上述过程[通过经典 UI](https://www.jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui) 定义管道，直到到达第 5 步（访问 Pipeline configuration 页面上的 **Pipeline** 部分）。
2. From the **Definition** field, choose the **Pipeline script from SCM** option.
   从 **Definition** 字段中，选择 **Pipeline script from SCM** 选项。
3. From the **SCM** field, choose the type of source control system of the repository containing your `Jenkinsfile`.
   从 **SCM** 字段中，选择包含 `Jenkinsfile` 的存储库的源代码控制系统类型。
4. Complete the fields specific to your repository’s source control system.
   填写特定于存储库源代码管理系统的字段。
    **Tip:** If you are uncertain of what value to specify for a given field, click its **?** icon to the right for more information.
   **提示：**如果您不确定要为给定字段指定什么值，请单击右侧的 **？**图标以了解更多信息。
5. In the **Script Path** field, specify the location (and name) of your `Jenkinsfile`. This location is the one that Jenkins checks out/clones the repository containing your `Jenkinsfile`, which should match that of the repository’s file structure. The default value of this field assumes that your `Jenkinsfile` is named "Jenkinsfile" and is located at the root of the repository.
   在 **Script Path** 字段中，指定 `Jenkinsfile` 的位置（和名称）。此位置是 Jenkins 签出/克隆包含 `Jenkinsfile` 的存储库的位置，该位置应与存储库的文件结构匹配。此字段的默认值假定您的 `Jenkinsfile` 名为 “Jenkinsfile” 并位于存储库的根目录。

When you update the designated repository, a new build is triggered, as long as the Pipeline is configured with an SCM polling trigger.
更新指定的存储库时，只要管道配置了 SCM 轮询触发器，就会触发新的构建。

|      | Since Pipeline code (i.e. Scripted Pipeline in particular) is written in Groovy-like syntax, if your IDE is not correctly syntax highlighting your `Jenkinsfile`, try inserting the line `#!/usr/bin/env groovy` at the top of the `Jenkinsfile`, [[4](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_4)] footnotegroovy_shebang:[[Shebang line (Groovy syntax)](http://groovy-lang.org/syntax.html#_shebang_line)] which may rectify the issue. 由于 Pipeline 代码（特别是脚本化流水线）是用类似 Groovy 的语法编写的，如果您的 IDE 没有正确地语法高亮显示您的 `Jenkinsfile`，请尝试在 `Jenkinsfile` 的顶部插入行 `#！/usr/bin/env groovy`，[[4](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnotedef_4)] footnotegroovy_shebang：[[Shebang line （Groovy syntax）](http://groovy-lang.org/syntax.html#_shebang_line)]，这可能会纠正这个问题。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## Built-in Documentation 内置文档

Pipeline ships with built-in documentation features to make it easier to create Pipelines of varying complexities. This built-in documentation is automatically generated and updated based on the plugins installed in the Jenkins controller.
Pipeline 附带了内置的文档功能，可以更轻松地创建不同复杂程度的 Pipeline。此内置文档是根据 Jenkins 控制器中安装的插件自动生成和更新的。

The built-in documentation can be found globally at `${YOUR_JENKINS_URL}/pipeline-syntax`. The same documentation is also linked as **Pipeline Syntax** in the side-bar for any configured Pipeline project.
内置文档可在 Global 上找到 `${YOUR_JENKINS_URL}/pipeline-syntax` 。对于任何已配置的 Pipeline 项目，相同的文档也作为 **Pipeline Syntax** 在侧边栏中链接。

![Classic UI left column on an item](https://www.jenkins.io/doc/book/resources/pipeline/classic-ui-left-column-on-item.png)

### Snippet Generator 代码段生成器

The built-in "Snippet Generator" utility is helpful for creating bits of code for individual steps, discovering new steps provided by plugins, or experimenting with different parameters for a particular step.
内置的 “Snippet Generator” 实用程序有助于为各个步骤创建代码位、发现插件提供的新步骤或为特定步骤试验不同的参数。

The Snippet Generator is dynamically populated with a list of the steps available to the Jenkins controller. The number of steps available is dependent on the plugins installed which explicitly expose steps for use in Pipeline.
代码段生成器 （Snippet Generator） 动态填充了 Jenkins 控制器可用的步骤列表。可用步骤的数量取决于安装的插件，这些插件明确公开了要在 Pipeline 中使用的步骤。

To generate a step snippet with the Snippet Generator:
要使用代码段生成器生成步骤代码段，请执行以下操作：

1. Navigate to the **Pipeline Syntax** link (referenced above) from a configured Pipeline, or at `${YOUR_JENKINS_URL}/pipeline-syntax`.
   从配置的管道导航到 **Pipeline Syntax** 链接（如上所述），或在 中导航到 `${YOUR_JENKINS_URL}/pipeline-syntax` 。
2. Select the desired step in the **Sample Step** dropdown menu
   在 **Sample Step** 下拉菜单中选择所需的步骤
3. Use the dynamically populated area below the **Sample Step** dropdown to configure the selected step.
   使用 **Sample Step** 下拉列表下的动态填充区域来配置所选步骤。
4. Click **Generate Pipeline Script** to create a snippet of Pipeline which can be copied and pasted into a Pipeline.
   单击 **Generate Pipeline Script （生成管道脚本**） 以创建可复制并粘贴到管道中的管道代码段。

![Snippet Generator](https://www.jenkins.io/doc/book/resources/pipeline/snippet-generator.png)

To access additional information and/or documentation about the step selected, click on the help icon (indicated by the red arrow in the image above).
要访问有关所选步骤的其他信息和/或文档，请单击帮助图标（由上图中的红色箭头指示）。

### Global Variable Reference 全局变量参考

In addition to the Snippet Generator, which only surfaces steps, Pipeline also provides a built-in "**Global Variable Reference**." Like the Snippet Generator, it is also dynamically populated by plugins. Unlike the Snippet Generator however, the Global Variable Reference only contains documentation for **variables** provided by Pipeline or plugins, which are available for Pipelines.
除了仅显示步骤的 Snippet Generator 之外，Pipeline 还提供了内置的“**全局变量引用**”。与 Snippet Generator 一样，它也由插件动态填充。但是，与代码段生成器不同的是，全局变量引用仅包含管道或插件提供的**变量**文档，这些变量可用于管道。

The variables provided by default in Pipeline are:
Pipeline 中默认提供的变量是：

- env 环境

  Exposes environment variables, for example: `env.PATH` or `env.BUILD_ID`. Consult the built-in global variable reference at `${YOUR_JENKINS_URL}/pipeline-syntax/globals#env` for a complete, and up to date, list of environment variables available in Pipeline. 公开环境变量，例如：`env。PATH` 或 `env.BUILD_ID`。请参阅 内置全局变量参考 ， `${YOUR_JENKINS_URL}/pipeline-syntax/globals#env` 以获取 Pipeline 中可用环境变量的完整和最新列表。

- params 参数

  Exposes all parameters defined for the Pipeline as a read-only [Map](http://groovy-lang.org/syntax.html#_maps), for example: `params.MY_PARAM_NAME`. 将为 Pipeline 定义的所有参数公开为只读 [Map](http://groovy-lang.org/syntax.html#_maps)，例如：`params。MY_PARAM_NAME`。

- currentBuild 当前构建

  May be used to discover information about the currently executing Pipeline, with properties such as `currentBuild.result`, `currentBuild.displayName`, etc. Consult the built-in global variable reference at `${YOUR_JENKINS_URL}/pipeline-syntax/globals` for a complete, and up to date, list of properties available on `currentBuild`. 可用于发现有关当前正在执行的 Pipeline 的信息，具有 `currentBuild.result`、`currentBuild.displayName` 等属性。请参阅 内置全局变量参考 ， `${YOUR_JENKINS_URL}/pipeline-syntax/globals` 以获取 `currentBuild` 上可用属性的完整和最新列表。

This video reviews using the `currentBuild` variable in Jenkins Pipeline.
此视频回顾了在 Jenkins Pipeline 中使用 `currentBuild` 变量。

<iframe width="800" height="420" src="https://www.youtube.com/embed/gcUORgHuna4?rel=0" frameborder="0" allowfullscreen=""></iframe>

### Declarative Directive Generator 声明式指令生成器

While the Snippet Generator helps with generating steps for a Scripted Pipeline or for the `steps` block in a `stage` in a Declarative Pipeline, it does not cover the [sections](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-sections) and [directives](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-directives) used to define a Declarative Pipeline. The "Declarative Directive Generator" utility helps with that. Similar to the [Snippet Generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator), the Directive Generator allows you to choose a Declarative directive, configure it in a form, and generate the configuration for that directive, which you can then use in your Declarative Pipeline.
虽然代码段生成器有助于为脚本化管道或声明性管道`中阶段`中的 `steps` 块生成步骤，但它并不涵盖用于定义声明性管道[的部分和](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-sections)[指令](https://www.jenkins.io/doc/book/pipeline/syntax#declarative-directives)。“Declarative Directive Generator” 实用程序有助于实现这一点。与 [Snippet Generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) 类似，Directive Generator 允许您选择 Declarative 指令，在表单中对其进行配置，然后为该指令生成配置，然后您可以在 Declarative Pipeline 中使用该指令。

To generate a Declarative directive using the Declarative Directive Generator:
要使用 Declarative Directive Generator 生成 Declarative 指令：

1. Navigate to the **Pipeline Syntax** link (referenced above) from a configured Pipeline, and then click on the **Declarative Directive Generator** link in the sidepanel, or go directly to `${YOUR_JENKINS_URL}/directive-generator`.
   从配置的管道导航到 **Pipeline Syntax** 链接（如上所述），然后单击侧面板中的 **Declarative Directive Generator** 链接，或直接转到 `${YOUR_JENKINS_URL}/directive-generator` 。
2. Select the desired directive in the dropdown menu
   在下拉菜单中选择所需的指令
3. Use the dynamically populated area below the dropdown to configure the selected directive.
   使用下拉列表下方的动态填充区域来配置所选指令。
4. Click **Generate Directive** to create the directive’s configuration to copy into your Pipeline.
   单击 **Generate Directive （生成指令**） 以创建要复制到 Pipeline 中的指令配置。

The Directive Generator can generate configuration for nested directives, such as conditions inside a `when` directive, but it cannot generate Pipeline steps. For the contents of directives which contain steps, such as `steps` inside a `stage` or conditions like `always` or `failure` inside `post`, the Directive Generator adds a placeholder comment instead. You will still need to add steps to your Pipeline by hand.
Directive Generator 可以为嵌套指令生成配置，例如 `when` 指令内的条件，但它不能生成 Pipeline 步骤。对于包含步骤的指令内容，例如 `stage` 中的`步骤`或 `post` 内的 `always` 或 `failure` 等条件，指令生成器会添加占位符注释。您仍然需要手动向 Pipeline 添加步骤。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
stage('Stage 1') {
    steps {
        // One or more steps need to be included within the steps block.
    }
}
```



## Further Reading 延伸阅读

This section merely scratches the surface of what can be done with Jenkins Pipeline, but should provide enough of a foundation for you to start experimenting with a test Jenkins controller.
本节只是触及了 Jenkins Pipeline 可以做什么的皮毛，但应该为你提供足够的基础来开始试验测试 Jenkins 控制器。

In the next section, [The Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/), more Pipeline steps will be discussed along with patterns for implementing successful, real-world, Jenkins Pipelines.
在下一节 [Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) 中，将讨论更多流水线步骤以及实现成功的真实 Jenkins 流水线的模式。

### Additional Resources 其他资源

- [Pipeline Steps Reference](https://www.jenkins.io/doc/pipeline/steps), encompassing all steps provided by plugins distributed in the Jenkins Update Center.
  [Pipeline Steps Reference](https://www.jenkins.io/doc/pipeline/steps)，包含在 Jenkins Update Center 中分发的插件提供的所有步骤。
- [Pipeline Examples](https://www.jenkins.io/doc/pipeline/examples), a community-curated collection of copyable Pipeline examples.
  [Pipeline Examples](https://www.jenkins.io/doc/pipeline/examples)，一个由社区策划的可复制 Pipeline 示例集合。

------

[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_1). [Domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language)
[1](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_1). [域特定语言](https://en.wikipedia.org/wiki/Domain-specific_language)

[2](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_2). [Pipeline plugin](https://plugins.jenkins.io/workflow-aggregator)
[2](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_2). [管道插件](https://plugins.jenkins.io/workflow-aggregator)

[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_3). [Source control management](https://en.wikipedia.org/wiki/Version_control)
[3](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_3). [源头控制管理](https://en.wikipedia.org/wiki/Version_control)

[4](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_4). [Shebang (general definition)](https://en.wikipedia.org/wiki/Shebang_(Unix))
[4](https://www.jenkins.io/doc/book/pipeline/getting-started/#_footnoteref_4). [Shebang（一般定义）](https://en.wikipedia.org/wiki/Shebang_(Unix))

# Using a Jenkinsfile 使用 Jenkinsfile

Table of Contents 目录

- Creating a Jenkinsfile 创建 Jenkinsfile
  - [Build 建](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#build)
  - [Test 测试](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#test)
  - [Deploy 部署](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#deploy)
- Working with your Jenkinsfile
  使用 Jenkinsfile
  - Using environment variables
    使用环境变量
    - [Setting environment variables
      设置环境变量](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#setting-environment-variables)
    - [Setting environment variables dynamically
      动态设置环境变量](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#setting-environment-variables-dynamically)
  - Handling credentials 处理凭据
    - For secret text, usernames and passwords, and secret files
      对于 secret 文本、用户名和密码以及 secret 文件
      - [Secret text 秘密文本](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text)
      - [Usernames and passwords 用户名和密码](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords)
      - [Secret files 机密文件](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-files)
    - For other credential types
      对于其他凭证类型
      - [Combining credentials in one step
        将凭据合并到一个步骤](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#combining-credentials-in-one-step)
  - String interpolation 字符串插值
    - [Interpolation of sensitive environment variables
      敏感环境变量的插值](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#interpolation-of-sensitive-environment-variables)
    - [Injection via interpolation
      通过插值进行注入](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#injection-via-interpolation)
  - [Handling parameters 处理参数](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-parameters)
  - [Handling failure 处理失败](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-failure)
  - [Using multiple agents 使用多个代理](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#using-multiple-agents)
  - [Optional step arguments 可选步骤参数](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#optional-step-arguments)
  - Advanced Scripted Pipeline
    高级脚本化管道
    - [Parallel execution 并行执行](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#parallel-execution)

This section builds on the information covered in [Getting started with Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started) and introduces more useful steps, common patterns, and demonstrates some non-trivial `Jenkinsfile` examples.
本节以 [Pipeline 入门](https://www.jenkins.io/doc/book/pipeline/getting-started) 中介绍的信息为基础，介绍了更多有用的步骤、常见模式，并演示了一些重要的 `Jenkinsfile` 示例。

Creating a `Jenkinsfile`, which is checked into source control [[1](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_1)], provides a number of immediate benefits:
创建一个签入源代码管理 [[1](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_1)] 的 `Jenkinsfile` 提供了许多直接的好处：

- Code review/iteration on the Pipeline
  Pipeline 上的代码审查/迭代
- Audit trail for the Pipeline
  管道的审计跟踪
- Single source of truth [[2](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_2)] for the Pipeline, which can be viewed and edited by multiple members of the project.
  管道的单一事实来源 [[2](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_2)]，可由项目的多个成员查看和编辑。

Pipeline supports [two syntaxes](https://www.jenkins.io/doc/book/pipeline/syntax), Declarative (introduced in Pipeline 2.5) and Scripted Pipeline. Both of which support building continuous delivery pipelines. Both may be used to define a Pipeline in either the web UI or with a `Jenkinsfile`, though it’s generally considered a best practice to create a `Jenkinsfile` and check the file into the source control repository.
Pipeline 支持[两种语法](https://www.jenkins.io/doc/book/pipeline/syntax)：Declarative （在 Pipeline 2.5 中引入） 和 Scripted Pipeline。这两者都支持构建持续交付管道。两者都可用于在 Web UI 中或使用 `Jenkinsfile` 定义管道，但通常认为创建 `Jenkinsfile` 并将文件签入源代码控制存储库是最佳实践。

## Creating a Jenkinsfile 创建 Jenkinsfile

As discussed in the [Defining a Pipeline in SCM](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline-in-scm), a `Jenkinsfile` is a text file that contains the definition of a Jenkins Pipeline and is checked into source control. Consider the following Pipeline which implements a basic three-stage continuous delivery pipeline.
如[在 SCM 中定义管道](https://www.jenkins.io/doc/book/pipeline/getting-started#defining-a-pipeline-in-scm)中所述，`Jenkinsfile` 是一个文本文件，其中包含 Jenkins 管道的定义，并被签入源代码管理。请考虑以下 Pipeline，它实现了一个基本的三阶段持续交付管道。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

Not all Pipelines will have these same three stages, but it is a good starting point to define them for most projects. The sections below will demonstrate the creation and execution of a simple Pipeline in a test installation of Jenkins.
并非所有 Pipelines 都具有相同的 3 个阶段，但对于大多数项目来说，定义它们是一个很好的起点。以下部分将演示如何在 Jenkins 的测试安装中创建和执行简单的 Pipeline。

|      | It is assumed that there is already a source control repository set up for the project and a Pipeline has been defined in Jenkins following [these instructions](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm). 假设已经为项目设置了一个源代码控制存储库，并且已按照[这些说明](https://www.jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm)在 Jenkins 中定义了 Pipeline。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Using a text editor, ideally one which supports [Groovy](http://groovy-lang.org) syntax highlighting, create a new `Jenkinsfile` in the root directory of the project.
使用文本编辑器（最好是支持 [Groovy](http://groovy-lang.org) 语法高亮的编辑器），在项目的根目录中创建一个新的 `Jenkinsfile`。

The Declarative Pipeline example above contains the minimum necessary structure to implement a continuous delivery pipeline. The [agent directive](https://www.jenkins.io/doc/book/pipeline/syntax/#agent), which is required, instructs Jenkins to allocate an executor and workspace for the Pipeline. Without an `agent` directive, not only is the Declarative Pipeline not valid, it would not be capable of doing any work! By default the `agent` directive ensures that the source repository is checked out and made available for steps in the subsequent stages.
上面的声明式管道示例包含实现持续交付管道所需的最低限度的结构。[agent 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#agent)是必需的，它指示 Jenkins 为 Pipeline 分配一个执行程序和工作区。如果没有 `agent` 指令，Declarative Pipeline 不仅无效，而且无法执行任何工作！默认情况下，`agent` 指令可确保源存储库已签出并可用于后续阶段中的步骤。

The [stages directive](https://www.jenkins.io/doc/book/pipeline/syntax/#stages), and [steps directives](https://www.jenkins.io/doc/book/pipeline/syntax/#steps) are also required for a valid Declarative Pipeline as they instruct Jenkins what to execute and in which stage it should be executed.
[stages 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#stages)和 [steps 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#steps)对于有效的声明式管道也是必需的，因为它们指示 Jenkins 要执行什么以及应该在哪个阶段执行。

For more advanced usage with Scripted Pipeline, the example above `node` is a crucial first step as it allocates an executor and workspace for the Pipeline. In essence, without `node`, a Pipeline cannot do any work! From within `node`, the first order of business will be to checkout the source code for this project.  Since the `Jenkinsfile` is being pulled directly from source control, Pipeline provides a quick and easy way to access the right revision of the source code
对于脚本化管道的更高级用法，上面的示例 `node` 是关键的第一步，因为它为 Pipeline 分配了执行程序和工作区。从本质上讲，没有 `node，Pipeline` 就无法执行任何工作！在 `node` 中，首要任务是签出此项目的源代码。由于 `Jenkinsfile` 是直接从源代码控制中提取的，因此 Pipeline 提供了一种快速简便的方法来访问源代码的正确版本

Jenkinsfile (Scripted Pipeline)
Jenkinsfile（脚本化管道）

```groovy
node {
    checkout scm 
    /* .. snip .. */
}
```

|      | The `checkout` step will checkout code from source control; `scm` is a special variable which instructs the `checkout` step to clone the specific revision which triggered this Pipeline run. `checkout` 步骤将从源代码控制中签出代码;`scm` 是一个特殊变量，它指示 `checkout` 步骤克隆触发此管道运行的特定修订。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Build 建

For many projects the beginning of "work" in the Pipeline would be the "build" stage. Typically this stage of the Pipeline will be where source code is assembled, compiled, or packaged. The `Jenkinsfile` is **not** a replacement for an existing build tool such as GNU/Make, Maven, Gradle, etc, but rather can be viewed as a glue layer to bind the multiple phases of a project’s development lifecycle (build, test, deploy, etc) together.
对于许多项目，Pipeline 中 “work” 的开始是 “build” 阶段。通常，Pipeline 的这个阶段将是组装、编译或打包源代码的地方。`Jenkinsfile` **不能**替代现有的构建工具，如 GNU/Make、Maven、Gradle 等，而是可以被视为一个胶水层，将项目开发生命周期的多个阶段（构建、测试、部署等）绑定在一起。

Jenkins has a number of plugins for invoking practically any build tool in general use, but this example will simply invoke `make` from a shell step (`sh`).  The `sh` step assumes the system is Unix/Linux-based, for Windows-based systems the `bat` could be used instead.
Jenkins 有许多插件，用于调用几乎所有常用的构建工具，但此示例将简单地从 shell 步骤 （`sh`） 调用 `make`。`sh` 步骤假定系统基于 Unix/Linux，对于基于 Windows 的系统，可以使用 `bat` 代替。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'make' 
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

|      | The `sh` step invokes the `make` command and will only continue if a zero exit code is returned by the command. Any non-zero exit code will fail the Pipeline. `sh` 步骤调用 `make` 命令，并且仅当命令返回的退出代码为零时，该命令才会继续。任何非零退出代码都将使 Pipeline 失败。 |
| ---- | ------------------------------------------------------------ |
|      | `archiveArtifacts` captures the files built matching the include pattern (`**/target/*.jar`) and saves them to the Jenkins controller for later retrieval. `archiveArtifacts` 捕获与包含模式 （`**/target/*.jar`） 匹配的文件，并将其保存到 Jenkins 控制器以供以后检索。 |

|      | Archiving artifacts is not a substitute for using external artifact repositories such as Artifactory or Nexus and should be considered only for basic reporting and file archival. 归档工件不能替代使用外部工件存储库（如 Artifactory 或 Nexus），应仅考虑用于基本报告和文件归档。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Test 测试

Running automated tests is a crucial component of any successful continuous delivery process. As such, Jenkins has a number of test recording, reporting, and visualization facilities provided by a [number of plugins](https://plugins.jenkins.io/?labels=report). At a fundamental level, when there are test failures, it is useful to have Jenkins record the failures for reporting and visualization in the web UI.  The example below uses the `junit` step, provided by the [JUnit plugin](https://plugins.jenkins.io/junit).
运行自动化测试是任何成功的持续交付流程的关键组成部分。因此，Jenkins 具有许多插件提供的测试记录、报告和可视化[工具。](https://plugins.jenkins.io/?labels=report)从根本上讲，当出现测试失败时，让 Jenkins 记录失败以在 Web UI 中进行报告和可视化非常有用。下面的示例使用 [JUnit 插件](https://plugins.jenkins.io/junit)提供的 `junit` 步骤。

In the example below, if tests fail, the Pipeline is marked "unstable", as denoted by a yellow ball in the web UI. Based on the recorded test reports, Jenkins can also provide historical trend analysis and visualization.
在下面的示例中，如果测试失败，则管道将标记为“不稳定”，如 Web UI 中的黄球所示。基于记录的测试报告，Jenkins 还可以提供历史趋势分析和可视化。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                /* `make check` returns non-zero on test failures,
                * using `true` to allow the Pipeline to continue nonetheless
                */
                sh 'make check || true' 
                junit '**/target/*.xml' 
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

|      | Using an inline shell conditional (`sh 'make check || true'`) ensures that the `sh` step always sees a zero exit code, giving the `junit` step the opportunity to capture and process the test reports. Alternative approaches to this are covered in more detail in the [Handling failure](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-failure) section below. 使用内联 shell 条件 （`sh 'make check || true'`） 可确保 `sh` 步骤始终看到零退出代码，从而使 `junit` 步骤有机会捕获和处理测试报告。下面的 [处理失败](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-failure) 部分更详细地介绍了其他方法。 |
| ---- | ------------------------------------------------------------ |
|      | `junit` captures and associates the JUnit XML files matching the inclusion pattern (`**/target/*.xml`). `junit` 捕获并关联与包含模式 （`**/target/*.xml`） 匹配的 JUnit XML 文件。 |

### Deploy 部署

Deployment can imply a variety of steps, depending on the project or organization requirements, and may be anything from publishing built artifacts to an Artifactory server, to pushing code to a production system.
根据项目或组织要求，部署可能意味着各种步骤，可以是从将构建的构件发布到 Artifactory 服务器，到将代码推送到生产系统的任何步骤。

At this stage of the example Pipeline, both the "Build" and "Test" stages have successfully executed. In essence, the "Deploy" stage will only execute assuming previous stages completed successfully, otherwise the Pipeline would have exited early.
在示例 Pipeline 的此阶段，“Build” 和 “Test” 阶段都已成功执行。从本质上讲，“部署”阶段只会在前几个阶段成功完成的情况下执行，否则管道会提前退出。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any

    stages {
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'make publish'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

|      | Accessing the `currentBuild.result` variable allows the Pipeline to determine if there were any test failures. In which case, the value would be `UNSTABLE`. 访问 `currentBuild.result` 变量可让 Pipeline 确定是否存在任何测试失败。在这种情况下，该值将为 `UNSTABLE。` |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Assuming everything has executed successfully in the example Jenkins Pipeline, each successful Pipeline run will have associated build artifacts archived, test results reported upon and the full console output all in Jenkins.
假设在示例 Jenkins Pipeline 中成功执行了所有内容，则每个成功的 Pipeline 运行都将在 Jenkins 中存档关联的构建构件、报告测试结果和完整的控制台输出。

A Scripted Pipeline can include conditional tests (shown above), loops, try/catch/finally blocks and even functions. The next section will cover this advanced Scripted Pipeline syntax in more detail.
脚本化管道可以包括条件测试（如上所示）、循环、try/catch/finally 块甚至函数。下一节将更详细地介绍这种高级脚本化管道语法。

## Working with your Jenkinsfile 使用 Jenkinsfile

The following sections provide details about handling:
以下部分提供了有关处理的详细信息：

- specific Pipeline syntax in your `Jenkinsfile` and
  specific Pipeline `语法和`
- features and functionality of Pipeline syntax which are essential in building your application or Pipeline project.
  Pipeline 语法的特性和功能，这对于构建应用程序或 Pipeline 项目至关重要。

### Using environment variables 使用环境变量

Jenkins Pipeline exposes environment variables via the global variable `env`, which is available from anywhere within a `Jenkinsfile`. The full list of environment variables accessible from within Jenkins Pipeline is documented at ${YOUR_JENKINS_URL}/pipeline-syntax/globals#env and includes:
Jenkins Pipeline 通过全局变量 `env` 公开环境变量，该变量可从 `Jenkinsfile` 中的任何位置使用。可从 Jenkins Pipeline 中访问的环境变量的完整列表记录在 ${YOUR_JENKINS_URL}/pipeline-syntax/globals#env 中，包括：

- BUILD_ID

  The current build ID, identical to BUILD_NUMBER for builds created in Jenkins versions 1.597+ 当前构建 ID，与在 Jenkins 版本 1.597+ 中创建的构建的 BUILD_NUMBER 相同

- BUILD_NUMBER

  The current build number, such as "153" 当前内部版本号，例如“153”

- BUILD_TAG

  String of jenkins-${JOB_NAME}-${BUILD_NUMBER}. Convenient to put into a resource file, a jar file, etc for easier identification jenkins-${JOB_NAME}-${BUILD_NUMBER} 的字符串。方便放入资源文件、jar 文件等中，便于识别

- BUILD_URL

  The URL where the results of this build can be found (for example http://buildserver/jenkins/job/MyJobName/17/ ) 可找到此内部版本结果的 URL（例如 http://buildserver/jenkins/job/MyJobName/17/ ）

- EXECUTOR_NUMBER

  The unique number that identifies the current executor (among executors of  the same machine) performing this build. This is the number you see in  the "build executor status", except that the number starts from 0, not 1 标识当前执行程序（在同一台计算机的执行程序中）执行此生成的唯一编号。这是您在 “build executor status（构建执行程序状态）”中看到的数字，不同之处在于该数字从 0 开始，而不是 1

- JAVA_HOME

  If your job is configured to use a specific JDK, this variable is set to  the JAVA_HOME of the specified JDK. When this variable is set, PATH is  also updated to include the bin subdirectory of JAVA_HOME 如果您的作业配置为使用特定 JDK，则此变量将设置为指定 JDK 的 JAVA_HOME。设置此变量后，PATH 也会更新以包含 JAVA_HOME 的 bin 子目录

- JENKINS_URL

  Full URL of Jenkins, such as https://example.com:port/jenkins/ (NOTE: only  available if Jenkins URL set in "System Configuration") Jenkins 的完整 URL，例如 https：//example.com：port/jenkins/（注意：仅在“系统配置”中设置了 Jenkins URL 时可用）

- JOB_NAME

  Name of the project of this build, such as "foo" or "foo/bar". 此生成的项目名称，例如 “foo” 或 “foo/bar”。

- NODE_NAME

  The name of the node the current build is running on. Set to 'master' for the Jenkins controller. 运行当前构建的节点的名称。设置为 Jenkins 控制器的 'master'。

- WORKSPACE 工作

  The absolute path of the workspace 工作区的绝对路径

Referencing or using these environment variables can be accomplished like accessing any key in a Groovy [Map](http://groovy-lang.org/syntax.html#_maps), for example:
引用或使用这些环境变量可以像访问 Groovy [Map](http://groovy-lang.org/syntax.html#_maps) 中的任何键一样完成，例如：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

#### Setting environment variables 设置环境变量

Setting an environment variable within a Jenkins Pipeline is accomplished differently depending on whether Declarative or Scripted Pipeline is used.
在 Jenkins 管道中设置环境变量的完成方式不同，具体取决于使用的是声明式管道还是脚本化管道。

Declarative Pipeline supports an [environment](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) directive, whereas users of Scripted Pipeline must use the `withEnv` step.
Declarative Pipeline 支持 [environment](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) 指令，而 Scripted Pipeline 的用户必须使用 `withEnv` 步骤。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    environment { 
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment { 
                DEBUG_FLAGS = '-g'
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

|      | An `environment` directive used in the top-level `pipeline` block will apply to all steps within the Pipeline. 顶级 `pipeline` 块中使用的 `environment` 指令将应用于 Pipeline 中的所有步骤。 |
| ---- | ------------------------------------------------------------ |
|      | An `environment` directive defined within a `stage` will only apply the given environment variables to steps within the `stage`. `在阶段`中定义的`环境`指令将仅将给定的环境变量应用于`阶段`中的步骤。 |

#### Setting environment variables dynamically 动态设置环境变量

Environment variables can be set at run time and can be used by shell scripts (`sh`), Windows batch scripts (`bat`) and PowerShell scripts (`powershell`). Each script can either `returnStatus` or `returnStdout`. [More information on scripts](https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step).
环境变量可以在运行时设置，并可供 shell 脚本 （`sh`）、Windows 批处理脚本 （`bat`） 和 PowerShell 脚本 （`powershell`） 使用。每个脚本都可以是 `returnStatus` 或 `returnStdout`。[有关脚本的更多信息](https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step)。

Below is an example in a declarative pipeline using `sh` (shell) with both `returnStatus` and `returnStdout`.
下面是使用 `sh` （shell） 的声明式管道中的一个示例，其中同时具有 `returnStatus` 和 `returnStdout`。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any 
    environment {
        // Using returnStdout
        CC = """${sh(
                returnStdout: true,
                script: 'echo "clang"'
            )}""" 
        // Using returnStatus
        EXIT_STATUS = """${sh(
                returnStatus: true,
                script: 'exit 1'
            )}"""
    }
    stages {
        stage('Example') {
            environment {
                DEBUG_FLAGS = '-g'
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```

|      | An `agent` must be set at the top level of the pipeline. This will fail if agent is set as `agent none`. 必须在管道的顶层设置`代理`。如果将 agent 设置为 `agent none`，这将失败。 |
| ---- | ------------------------------------------------------------ |
|      | When using `returnStdout` a trailing whitespace will be appended to the returned string. Use `.trim()` to remove this. 使用 `returnStdout` 时，返回的字符串将附加一个尾随空格。使用 `.trim（）` 删除此 URL。 |

### Handling credentials 处理凭据

Credentials [configured in Jenkins](https://www.jenkins.io/doc/book/using/using-credentials#configuring-credentials) can be handled in Pipelines for immediate use. Read more about using credentials in Jenkins on the [Using credentials](https://www.jenkins.io/doc/book/using/using-credentials) page.
[在 Jenkins 中配置的](https://www.jenkins.io/doc/book/using/using-credentials#configuring-credentials)凭据可以在 Pipelines 中处理，以便立即使用。有关在 Jenkins 中使用凭证的更多信息，请参阅[使用凭证](https://www.jenkins.io/doc/book/using/using-credentials)页面。

The correct way to handle credentials in Jenkins
在 Jenkins 中处理凭证的正确方法

<iframe width="800" height="420" src="https://www.youtube.com/embed/yfjtMIDgmfs?rel=0" frameborder="0" allowfullscreen=""></iframe>

#### For secret text, usernames and passwords, and secret files 对于 secret 文本、用户名和密码以及 secret 文件

Jenkins' declarative Pipeline syntax has the `credentials()` helper method (used within the [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) directive) which supports [secret text](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text), [username and password](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords), as well as [secret file](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-files) credentials. If you want to handle other types of credentials, refer to the [For other credential types](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-other-credential-types) section (below).
Jenkins 的声明式 Pipeline 语法具有 `credentials（）` 辅助方法（在 [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) 指令中使用），该方法支持[秘密文本](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text)、[用户名和密码](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords)以及[秘密文件](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-files)凭证。如果要处理其他类型的凭证，请参阅 [对于其他凭证类型](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-other-credential-types) 部分（如下）。

##### Secret text 秘密文本

The following Pipeline code shows an example of how to create a Pipeline using environment variables for secret text credentials.
以下 Pipeline 代码显示了如何使用环境变量为秘密文本凭证创建 Pipeline 的示例。

In this example, two secret text credentials are assigned to separate environment variables to access Amazon Web Services (AWS). These credentials would have been configured in Jenkins with their respective credential IDs
在此示例中，将分配两个机密文本凭证以分隔 环境变量来访问 Amazon Web Services （AWS）。这些凭证 将在 Jenkins 中配置其各自的凭证 ID
 `jenkins-aws-secret-key-id` and `jenkins-aws-secret-access-key`.
`jenkins-aws-secret-key-id` 和 `jenkins-aws-secret-access-key` 的密钥。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        // Define agent details here
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('Example stage 1') {
            steps {
                // 
            }
        }
        stage('Example stage 2') {
            steps {
                // 
            }
        }
    }
}
```

|      | You can reference the two credential environment variables (defined in this Pipeline’s [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) directive), within this stage’s steps using the syntax `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY`. For example, here you can authenticate to AWS using the secret text credentials assigned to these credential variables. 您可以引用两个凭证环境变量（在此 Pipeline [`的环境`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment)指令），在此阶段的步骤中使用语法 `$AWS_ACCESS_KEY_ID` 和 `$AWS_SECRET_ACCESS_KEY`。例如，您可以在此处使用分配给这些凭证变量的密钥文本凭证向 AWS 进行身份验证。  To maintain the security and anonymity of these credentials, if the job displays the value of these credential variables from within the Pipeline (e.g. `echo $AWS_SECRET_ACCESS_KEY`), Jenkins only returns the value “****” to reduce the risk of secret information being disclosed to the console output and any logs. Any sensitive information in credential IDs themselves (such as usernames) are also returned as “****” in the Pipeline run’s output. 为了维护这些凭证的安全性和匿名性，如果作业 显示管道中这些凭证变量的值（例如 `echo $AWS_SECRET_ACCESS_KEY`） 中，Jenkins 仅返回值 “****”，以降低机密信息泄露到控制台输出和任何日志的风险。凭证 ID 本身（例如用户名）中的任何敏感信息也会在管道运行的输出中返回为 “****”。  This only reduces the risk of **accidental exposure**.  It does not prevent a malicious user from capturing the credential value by other means. A Pipeline that uses credentials can also disclose those credentials.  Don’t allow untrusted Pipeline jobs to use trusted credentials. 这只会降低**意外接触**的风险。 它确实 不阻止恶意用户捕获凭据值 通过其他方式。使用凭证的 Pipeline 也可以披露 那些凭证。 不允许不受信任的 Pipeline 作业使用 trusted 凭据。 |
| ---- | ------------------------------------------------------------ |
|      | In this Pipeline example, the credentials assigned to the two `AWS_…` environment variables are scoped globally for the entire Pipeline, so these credential variables could also be used in this stage’s steps. If, however, the `environment` directive in this Pipeline were moved to a specific stage (as is the case in the [Usernames and passwords](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords) Pipeline example below), then these `AWS_…` environment variables would only be scoped to the steps in that stage. 在此 Pipeline 示例中，分配给两个 `AWS_...`环境变量的凭证是整个 Pipeline 的全局范围，因此这些凭证变量也可以在此阶段的步骤中使用。但是，如果此 Pipeline 中的 `environment` 指令被移动到特定阶段（如下面的 [Usernames and passwords](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords) Pipeline 示例中的情况），则这些 `AWS_...`环境变量将仅限定为该阶段中的步骤。 |

|      | Storing static AWS keys in Jenkins credentials is not very secure. If you can run Jenkins itself in AWS (at least the agent), it is preferable to use IAM roles for a [computer](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html) or [EKS service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html). It is also possible to use [web identity federation](https://github.com/jenkinsci/oidc-provider-plugin#accessing-aws).  将静态 AWS 密钥存储在 Jenkins 凭证中不是很安全。如果您可以在 AWS 中运行 Jenkins 本身（至少是代理），则最好将 IAM 角色用于[计算机](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html)或 [EKS 服务账户](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)。也可以使用 [Web 联合身份验证](https://github.com/jenkinsci/oidc-provider-plugin#accessing-aws)。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

##### Usernames and passwords 用户名和密码

The following Pipeline code snippets show an example of how to create a Pipeline using environment variables for username and password credentials.
以下 Pipeline 代码片段显示了如何使用用户名和密码凭据的环境变量创建 Pipeline 的示例。

In this example, username and password credentials are assigned to environment variables to access a Bitbucket repository in a common account or team for your organization; these credentials would have been configured in Jenkins with the credential ID `jenkins-bitbucket-common-creds`.
在此示例中，将用户名和密码凭证分配给环境变量，以访问您组织的公共帐户或团队中的 Bitbucket 存储库;这些凭证将在 Jenkins 中使用凭证 ID `jenkins-bitbucket-common-creds` 进行配置。

When setting the credential environment variable in the [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) directive:
在 [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) 指令中设置 credential 环境变量时：

```
environment {
    BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
}
```

this actually sets the following three environment variables:
这实际上设置了以下三个环境变量：

- `BITBUCKET_COMMON_CREDS` - contains a username and a password separated by a colon in the format `username:password`.
  `BITBUCKET_COMMON_CREDS` - 包含用户名和密码，以冒号分隔，格式为 `username：password`。
- `BITBUCKET_COMMON_CREDS_USR` - an additional variable containing the username component only.
  `BITBUCKET_COMMON_CREDS_USR` - 仅包含 username 组件的附加变量。
- `BITBUCKET_COMMON_CREDS_PSW` - an additional variable containing the password component only.
  `BITBUCKET_COMMON_CREDS_PSW` - 仅包含密码组件的附加变量。

|      | By convention, variable names for environment variables are typically specified in capital case, with individual words separated by underscores. You can, however, specify any legitimate variable name using lower case characters. Bear in mind that the additional environment variables created by the `credentials()` method (above) will always be appended with `_USR` and `_PSW` (i.e. in the format of an underscore followed by three capital letters). 按照惯例，环境变量的变量名称通常以大写形式指定，各个单词用下划线分隔。但是，您可以使用小写字符指定任何合法的变量名称。请记住，由 `credentials（）` 方法（上面）创建的其他环境变量将始终附加 `_USR` 和 `_PSW`（即以下划线后跟三个大写字母的格式）。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

The following code snippet shows the example Pipeline in its entirety:
以下代码片段完整地显示了示例 Pipeline：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        // Define agent details here
    }
    stages {
        stage('Example stage 1') {
            environment {
                BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
            }
            steps {
                // 
            }
        }
        stage('Example stage 2') {
            steps {
                // 
            }
        }
    }
}
```

|      | The following credential environment variables (defined in this Pipeline’s [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) directive) are available within this stage’s steps and can be referenced using the syntax:  以下凭证环境变量（在此管道的 [`environment`](https://www.jenkins.io/doc/book/pipeline/syntax/#environment) 指令）中可用的 stage 的步骤，可以使用以下语法进行引用：  `$BITBUCKET_COMMON_CREDS`  `$BITBUCKET_COMMON_CREDS_USR`  `$BITBUCKET_COMMON_CREDS_PSW`   For example, here you can authenticate to Bitbucket with the username and password assigned to these credential variables. 例如，在这里，您可以使用用户名和 password 分配给这些凭证变量。  To maintain the security and anonymity of these credentials, if the job displays the value of these credential variables from within the Pipeline the same behavior described in the [Secret text](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text) example above applies to these username and password credential variable types too. 为了维护这些凭证的安全性和匿名性，如果作业 显示管道中这些凭证变量的值 上面 [Secret 文本](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text)示例中描述的相同行为也适用于这些 username 和 password 凭证变量类型。  This only reduces the risk of **accidental exposure**.  It does not prevent a malicious user from capturing the credential value by other means. A Pipeline that uses credentials can also disclose those credentials.  Don’t allow untrusted Pipeline jobs to use trusted credentials. 这只会降低**意外接触**的风险。 它确实 不阻止恶意用户捕获凭据值 通过其他方式。使用凭证的 Pipeline 也可以披露 那些凭证。 不允许不受信任的 Pipeline 作业使用 trusted 凭据。 |
| ---- | ------------------------------------------------------------ |
|      | In this Pipeline example, the credentials assigned to the three `BITBUCKET_COMMON_CREDS…` environment variables are scoped only to `Example stage 1`, so these credential variables are not available for use in this `Example stage 2` stage’s steps. If, however, the `environment` directive in this Pipeline were moved immediately within the [`pipeline`](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline) block (as is the case in the [Secret text](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text) Pipeline example above), then these `BITBUCKET_COMMON_CREDS…` environment variables would be scoped globally and could be used in any stage’s steps. 在此管道示例中，分配给三个 `BITBUCKET_COMMON_CREDS...` 环境变量的凭据的范围仅限于`示例阶段 1`，因此这些凭据变量不可用于此示例`阶段 2` 阶段的步骤。但是，如果此 Pipeline 中的 `environment` 指令立即在 [`pipeline`](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline) 块中移动（如上面的 [Secret 文本](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text) Pipeline 示例中的情况），则这些 `BITBUCKET_COMMON_CREDS...`环境变量将具有全局范围，并且可以在任何阶段的步骤中使用。 |

##### Secret files 机密文件

A secret file is a credential which is stored in a file and uploaded to Jenkins. Secret files are used for credentials that are:
密钥文件是存储在文件中并上传到 Jenkins 的凭证。密钥文件用于以下凭据：

- too unwieldy to enter directly into Jenkins, and/or
  太笨拙，无法直接进入 Jenkins，和/或
- in binary format, such as a GPG file.
  采用二进制格式，例如 GPG 文件。

In this example, we use a Kubernetes config file that has been configured as a secret file credential named `my-kubeconfig`.
在此示例中，我们使用一个 Kubernetes 配置文件，该文件已配置为名为 `my-kubeconfig` 的秘密文件凭证。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        // Define agent details here
    }
    environment {
        // The MY_KUBECONFIG environment variable will be assigned
        // the value of a temporary file.  For example:
        //   /home/user/.jenkins/workspace/cred_test@tmp/secretFiles/546a5cf3-9b56-4165-a0fd-19e2afe6b31f/kubeconfig.txt
        MY_KUBECONFIG = credentials('my-kubeconfig')
    }
    stages {
        stage('Example stage 1') {
            steps {
                sh("kubectl --kubeconfig $MY_KUBECONFIG get pods")
            }
        }
    }
}
```



#### For other credential types 对于其他凭证类型

If you need to set credentials in a Pipeline for anything other than secret text, usernames and passwords, or secret files ([above](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-secret-text-usernames-and-passwords-and-secret-files)) - i.e SSH keys or certificates, then use Jenkins' **Snippet Generator** feature, which you can access through Jenkins' classic UI.
如果您需要在管道中为机密文本、用户名和密码或机密文件（[如上](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-secret-text-usernames-and-passwords-and-secret-files)）以外的任何内容设置凭据，即 SSH 密钥或证书，请使用 Jenkins 的代码**段生成器**功能，您可以通过 Jenkins 的经典 UI 访问该功能。

To access the **Snippet Generator** for your Pipeline project/item:
要访问 Pipeline 项目/项的代码**段生成器**，请执行以下操作：

1. From the Jenkins home page (i.e. the Dashboard of Jenkins' classic UI), click the name of your Pipeline project/item.
   在 Jenkins 主页（即 Jenkins 经典 UI 的仪表板）中，单击流水线项目/项的名称。
2. On the left, click **Pipeline Syntax** and ensure that the **Snippet Generator** link is in bold at the top-left. (If not, click its link.)
   在左侧，单击 **Pipeline Syntax（管道语法**），并确保 **Snippet Generator （代码片段生成器**） 链接在左上角以粗体显示。（如果没有，请单击其链接。
3. From the **Sample Step** field, choose **withCredentials: Bind credentials to variables**.
   从 **Sample Step** 字段中，选择 **withCredentials： Bind credentials to variables**。
4. Under **Bindings**, click **Add** and choose from the dropdown:
   在 **Bindings（绑定）**下，单击 **Add（添加**）并从下拉列表中选择：
   - **SSH User Private Key** - to handle [SSH public/private key pair credentials](http://www.snailbook.com/protocols.html), from which you can specify:
     **SSH 用户私钥** - 用于处理 [SSH 公钥/私钥对凭据](http://www.snailbook.com/protocols.html)，您可以从中指定：
     - **Key File Variable** - the name of the environment variable that will be bound to these credentials. Jenkins actually assigns this temporary variable to the secure location of the private key file required in the SSH public/private key pair authentication process.
       **Key File Variable** - 将绑定到这些凭证的环境变量的名称。Jenkins 实际上将此临时变量分配给 SSH 公钥/私钥对身份验证过程中所需的私钥文件的安全位置。
     - **Passphrase Variable** ( *Optional* ) - the name of the environment variable that will be bound to the [passphrase](https://tools.ietf.org/html/rfc4251#section-9.4.4) associated with the SSH public/private key pair.
       **Passphrase Variable** （ *Optional* ） - 将绑定到与 SSH 公钥/私钥对关联的[密码的](https://tools.ietf.org/html/rfc4251#section-9.4.4)环境变量的名称。
     - **Username Variable** ( *Optional* ) - the name of the environment variable that will be bound to username associated with the SSH public/private key pair.
       **用户名变量** （ *可选* ） - 将绑定到与 SSH 公钥/私钥对关联的用户名的环境变量的名称。
     - **Credentials** - choose the SSH public/private key credentials stored in Jenkins. The value of this field is the credential ID, which Jenkins writes out to the generated snippet.
       **凭证** - 选择存储在 Jenkins 中的 SSH 公有/私有密钥凭证。此字段的值是凭证 ID，Jenkins 将其写出到生成的代码段中。
   - **Certificate** - to handle [PKCS#12 certificates](https://tools.ietf.org/html/rfc7292), from which you can specify:
     **证书** - 处理 [PKCS#12 证书](https://tools.ietf.org/html/rfc7292)，您可以从中指定：
     - **Keystore Variable** - the name of the environment variable that will be bound to these credentials. Jenkins actually assigns this temporary variable to the secure location of the certificate’s keystore required in the certificate authentication process.
       **密钥库变量** - 将绑定到这些凭据的环境变量的名称。Jenkins 实际上将此临时变量分配给证书身份验证过程中所需的证书密钥库的安全位置。
     - **Password Variable** ( *Optional* ) - the name of the environment variable that will be bound to the password associated with the certificate.
       **密码变量** （ *Optional* ） - 将绑定到与证书关联的密码的环境变量的名称。
     - **Alias Variable** ( *Optional* ) - the name of the environment variable that will be bound to the unique alias associated with the certificate.
       **别名变量** （ *Optional* ） — 将绑定到与证书关联的唯一别名的环境变量的名称。
     - **Credentials** - choose the certificate credentials stored in Jenkins. The value of this field is the credential ID, which Jenkins writes out to the generated snippet.
       **Credentials （凭证**） - 选择存储在 Jenkins 中的证书凭证。此字段的值是凭证 ID，Jenkins 将其写出到生成的代码段中。
   - **Docker client certificate** - to handle Docker Host Certificate Authentication.
     **Docker 客户端证书** - 用于处理 Docker 主机证书身份验证。
5. Click **Generate Pipeline Script** and Jenkins generates a `withCredentials( … ) { … }` Pipeline step snippet for the credentials you specified, which you can then copy and paste into your Declarative or Scripted Pipeline code.
   单击 **Generate Pipeline Script，Jenkins** 将生成一个 `withCredentials（ ... ） { ... }`您指定的凭证的管道步骤代码段，然后您可以将其复制并粘贴到您的声明式或脚本化管道代码中。
    **Notes: 笔记：**
   - The **Credentials** fields (above) show the names of credentials configured in Jenkins. However, these values are converted to credential IDs after clicking **Generate Pipeline Script**. 
     **Credentials** 字段（上面）显示在 Jenkins 中配置的凭证的名称。但是，这些值将在单击 **Generate Pipeline Script （生成管道脚本**） 后转换为凭证 ID。
   - To combine more than one credential in a single `withCredentials( … ) { … }` Pipeline step, see [Combining credentials in one step](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#combining-credentials-in-one-step) (below) for details.
     将多个凭证合并到一个凭证中 `withCredentials（ ... ） { ... }`管道步骤，有关详细信息，请参阅[将凭证合并到一个步骤](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#combining-credentials-in-one-step)中（下文）。

**SSH User Private Key example
SSH 用户私钥示例**

```
withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'jenkins-ssh-key-for-abc', \
                                             keyFileVariable: 'SSH_KEY_FOR_ABC', \
                                             passphraseVariable: '', \
                                             usernameVariable: '')]) {
  // some block
}
```

The optional `passphraseVariable` and `usernameVariable` definitions can be deleted in your final Pipeline code.
可选的 `passphraseVariable` 和 `usernameVariable` 定义可以在最终的管道代码中删除。

**Certificate example 证书示例**

```
withCredentials(bindings: [certificate(aliasVariable: '', \
                                       credentialsId: 'jenkins-certificate-for-xyz', \
                                       keystoreVariable: 'CERTIFICATE_FOR_XYZ', \
                                       passwordVariable: 'XYZ-CERTIFICATE-PASSWORD')]) {
  // some block
}
```

The optional `aliasVariable` and `passwordVariable` variable definitions can be deleted in your final Pipeline code.
可选的 `aliasVariable` 和 `passwordVariable` 变量定义可以在最终的 Pipeline 代码中删除。

The following code snippet shows an example Pipeline in its entirety, which implements the **SSH User Private Key** and **Certificate** snippets above:
以下代码片段完整显示了一个示例 Pipeline，它实现了上面的 **SSH 用户私钥**和**证书**片段：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        // define agent details
    }
    stages {
        stage('Example stage 1') {
            steps {
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'jenkins-ssh-key-for-abc', \
                                                             keyFileVariable: 'SSH_KEY_FOR_ABC')]) {
                  // 
                }
                withCredentials(bindings: [certificate(credentialsId: 'jenkins-certificate-for-xyz', \
                                                       keystoreVariable: 'CERTIFICATE_FOR_XYZ', \
                                                       passwordVariable: 'XYZ-CERTIFICATE-PASSWORD')]) {
                  // 
                }
            }
        }
        stage('Example stage 2') {
            steps {
                // 
            }
        }
    }
}
```

|      | Within this step, you can reference the credential environment variable with the syntax `$SSH_KEY_FOR_ABC`. For example, here you can authenticate to the ABC application with its configured SSH public/private key pair credentials, whose **SSH User Private Key** file is assigned to `$SSH_KEY_FOR_ABC`. 在此步骤中，您可以使用语法 `$SSH_KEY_FOR_ABC` 引用凭证环境变量。例如，在这里，您可以使用其配置的 SSH 公钥/私钥对凭证向 ABC 应用程序进行身份验证，其 **SSH 用户私钥**文件分配给 `$SSH_KEY_FOR_ABC。` |
| ---- | ------------------------------------------------------------ |
|      | Within this step, you can reference the credential environment variable with the syntax `$CERTIFICATE_FOR_XYZ` and 在此步骤中，您可以使用 语法 `$CERTIFICATE_FOR_XYZ` 和  `$XYZ-CERTIFICATE-PASSWORD`. For example, here you can authenticate to the XYZ application with its configured certificate credentials, whose **Certificate**'s keystore file and password are assigned to the variables `$CERTIFICATE_FOR_XYZ` and `$XYZ-CERTIFICATE-PASSWORD`, respectively. `$XYZ-CERTIFICATE-PASSWORD。`例如，在这里，您可以使用其配置的证书凭证对 XYZ 应用程序进行身份验证，其**证书**的密钥库文件和密码分别分配给变量 `$CERTIFICATE_FOR_XYZ` 和 `$XYZ-CERTIFICATE-PASSWORD`。 |
|      | In this Pipeline example, the credentials assigned to the `$SSH_KEY_FOR_ABC`, `$CERTIFICATE_FOR_XYZ` and 在此 Pipeline 示例中，分配给 `$SSH_KEY_FOR_ABC`、`$CERTIFICATE_FOR_XYZ` 和  `$XYZ-CERTIFICATE-PASSWORD` environment variables are scoped only within their respective `withCredentials( … ) { … }` steps, so these credential variables are not available for use in this `Example stage 2` stage’s steps. `$XYZ-CERTIFICATE-PASSWORD` 环境变量的范围仅限于其各自的 `withCredentials（ ... ） { ... }` 步骤，因此这些凭证变量不可用于此示例`阶段 2` 阶段的步骤。 |

To maintain the security and anonymity of these credentials, if you attempt to retrieve the value of these credential variables from within these `withCredentials( … ) { … }` steps, the same behavior described in the [Secret text](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text) example (above) applies to these SSH public/private key pair credential and certificate variable types too.
为了维护这些凭证的安全性和匿名性，如果您尝试 从这些 `withCredentials（ ... ） { ... }`步骤中，[密钥文本](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#secret-text)示例（上述）中描述的相同行为也适用于这些 SSH 公钥/私钥对凭证和证书变量类型。
 This only reduces the risk of **accidental exposure**.  It does not prevent a malicious user from capturing the credential value by other means. A Pipeline that uses credentials can also disclose those credentials.  Don’t allow untrusted Pipeline jobs to use trusted credentials.
这只会降低**意外接触**的风险。 它确实 不阻止恶意用户捕获凭据值 通过其他方式。使用凭证的 Pipeline 也可以披露 那些凭证。 不允许不受信任的 Pipeline 作业使用 trusted 凭据。

|      | When using the **Sample Step** field’s **withCredentials: Bind credentials to variables** option in the **Snippet Generator**, only credentials which your current Pipeline project/item has access to can be selected from any **Credentials** field’s list. While you can manually write a `withCredentials( … ) { … }` step for your Pipeline (like the examples [above](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#withcredentials-script-examples)), using the **Snippet Generator** is recommended to avoid specifying credentials that are out of scope for this Pipeline project/item, which when run, will make the step fail. 在**代码片段生成器**中使用 **Sample Step** 字段的 **withCredentials： Bind credentials to variables** 选项时，只能从任何 **Credentials** 字段的列表中选择您当前管道项目/项有权访问的凭据。虽然您可以为管道手动编写 `withCredentials（ ... ） { ... }` 步骤（如[上面的](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#withcredentials-script-examples)示例），但建议使用**代码段生成器**，以避免指定超出此管道项目/项范围的凭据，否则在运行时，将导致步骤失败。  You can also use the **Snippet Generator** to generate `withCredentials( … ) { … }` steps to handle secret text, usernames and passwords and secret files. However, if you only need to handle these types of credentials, it is recommended you use the relevant procedure described in the section [above](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-secret-text-usernames-and-passwords-and-secret-files) for improved Pipeline code readability. 您还可以使用**代码段生成器**生成 `withCredentials（ ... ） { ... }` 步骤来处理密钥文本、用户名和密码以及密钥文件。但是，如果您只需要处理这些类型的凭证，建议您使用[上](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-secret-text-usernames-and-passwords-and-secret-files)一节中描述的相关过程来提高 Pipeline 代码的可读性。  The use of **single-quotes** instead of  **double-quotes** to define the `script` (the implicit parameter to `sh`) in Groovy above. The single-quotes will cause the secret to be expanded by the shell as an environment variable. The double-quotes are potentially less secure as the secret is interpolated by Groovy, and so typical operating system process listings will accidentally disclose it : 在上面的 Groovy 中使用**单引号**而不是**双引号**来定义`脚本`（`sh` 的隐式参数）。单引号将导致 shell 将 secret 作为环境变量进行扩展。双引号可能不太安全，因为 secret 是由 Groovy 插值的，因此典型的 os 进程列表会意外地泄露它：   `node {  withCredentials([string(credentialsId: 'mytoken', variable: 'TOKEN')]) {    sh /* WRONG! */ """      set +x      curl -H 'Token: $TOKEN' https://some.api/    """    sh /* CORRECT */ '''      set +x      curl -H 'Token: $TOKEN' https://some.api/    '''  } }` |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

##### Combining credentials in one step 将凭据合并到一个步骤

Using the **Snippet Generator**, you can make multiple credentials available within a single `withCredentials( … ) { … }` step by doing the following:
使用**代码段生成器**，您可以通过执行以下操作，在单个 `withCredentials（ ... ） { ... }` 步骤中提供多个凭证：

1. From the Jenkins home page (i.e. the Dashboard of Jenkins' classic UI), click the name of your Pipeline project/item.
   在 Jenkins 主页（即 Jenkins 经典 UI 的仪表板）中，单击流水线项目/项的名称。
2. On the left, click **Pipeline Syntax** and ensure that the **Snippet Generator** link is in bold at the top-left. (If not, click its link.)
   在左侧，单击 **Pipeline Syntax（管道语法**），并确保 **Snippet Generator （代码片段生成器**） 链接在左上角以粗体显示。（如果没有，请单击其链接。
3. From the **Sample Step** field, choose **withCredentials: Bind credentials to variables**.
   从 **Sample Step** 字段中，选择 **withCredentials： Bind credentials to variables**。
4. Click **Add** under **Bindings**.
   单击 **Bindings** 下的 **Add**。
5. Choose the credential type to add to the `withCredentials( … ) { … }` step from the dropdown list.
   从下拉列表中选择要添加到 `withCredentials（ ... ） { ... }` 步骤的凭证类型。
6. Specify the credential **Bindings** details. Read more above these in the procedure under [For other credential types](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-other-credential-types) (above).
   指定凭证 **Bindings** details （绑定详细信息）。在[上述 For other credential types](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-other-credential-types) （above） 下的过程中阅读更多内容。
7. Repeat from "Click **Add** …" (above) for each (set of) credential/s to add to the `withCredentials( … ) { … }` step.
   从“单击 **Add** ...“（上面）对于要添加到 `withCredentials（ ... ） 的每个（一组）凭证{ ... }`步。
8. Click **Generate Pipeline Script** to generate the final `withCredentials( … ) { … }` step snippet.
   单击 **Generate Pipeline Script** 以生成最终的 `withCredentials（ ... ） { ... }` 步骤代码段。

### String interpolation 字符串插值

Jenkins Pipeline uses rules identical to [Groovy](http://groovy-lang.org) for string interpolation. Groovy’s String interpolation support can be confusing to many newcomers to the language. While Groovy supports declaring a string with either single quotes, or double quotes, for example:
Jenkins Pipeline 使用与 [Groovy](http://groovy-lang.org) 相同的规则进行字符串插值。Groovy 的 String 插值支持可能会让许多语言新手感到困惑。虽然 Groovy 支持使用单引号或双引号声明字符串，例如：

```
def singlyQuoted = 'Hello'
def doublyQuoted = "World"
```

Only the latter string will support the dollar-sign (`$`) based string interpolation, for example:
只有后一个字符串支持基于美元符号 （`$`） 的字符串插值，例如：

```
def username = 'Jenkins'
echo 'Hello Mr. ${username}'
echo "I said, Hello Mr. ${username}"
```

Would result in: 将导致：

```
Hello Mr. ${username}
I said, Hello Mr. Jenkins
```

Understanding how to use string interpolation is vital for using some of Pipeline’s more advanced features.
了解如何使用字符串插值对于使用 Pipeline 的一些更高级的功能至关重要。

#### Interpolation of sensitive environment variables 敏感环境变量的插值

|      | Groovy string interpolation should **never** be used with credentials. Groovy 字符串插值**永远不应**与凭据一起使用。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Groovy string interpolation can leak sensitive environment variables (i.e. credentials, see: [Handling credentials](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials)). This is because the sensitive environment variable will be interpolated  during Groovy evaluation, and the environment variable’s value could be  made available earlier than intended, resulting in sensitive data  leaking in various contexts.
Groovy 字符串插值可能会泄漏敏感的环境变量（即凭证，请参阅：[处理凭证](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials)）。这是因为在 Groovy 评估期间将对敏感环境变量进行插值，并且环境变量的值可能会比预期更早地可用，从而导致敏感数据在各种上下文中泄漏。

For example, consider a sensitive environment variable passed to the `sh` step.
例如，考虑传递给 `sh` 步骤的敏感环境变量。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    environment {
        EXAMPLE_CREDS = credentials('example-credentials-id')
    }
    stages {
        stage('Example') {
            steps {
                /* WRONG! */
                sh("curl -u ${EXAMPLE_CREDS_USR}:${EXAMPLE_CREDS_PSW} https://example.com/")
            }
        }
    }
}
```

Should Groovy perform the interpolation, the sensitive value will be injected directly into the arguments of the `sh` step, which among other issues, means that the literal value will be visible as an argument to the `sh` process on the agent in OS process listings. Using single-quotes instead of double-quotes when referencing these  sensitive environment variables prevents this type of leaking.
如果 Groovy 执行插值，敏感值将直接注入到 `sh` 步骤的参数中，除其他问题外，这意味着 Literals 值将作为 OS 进程列表中代理上的 `sh` 进程的参数可见。在引用这些敏感环境变量时使用单引号而不是双引号可以防止这种类型的泄漏。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    environment {
        EXAMPLE_CREDS = credentials('example-credentials-id')
    }
    stages {
        stage('Example') {
            steps {
                /* CORRECT */
                sh('curl -u $EXAMPLE_CREDS_USR:$EXAMPLE_CREDS_PSW https://example.com/')
            }
        }
    }
}
```

#### Injection via interpolation 通过插值进行注入

|      | Groovy string interpolation can inject rogue commands into command interpreters via special characters. Groovy 字符串插值可以通过特殊字符将流氓命令注入命令解释器。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Another note of caution. Using Groovy string interpolation for user-controlled  variables with steps that pass their arguments to command interpreters  such as the `sh`, `bat`, `powershell`, or `pwsh` steps can result in problems analogous to SQL injection. This occurs when a user-controlled variable (generally an environment  variable, usually a parameter passed to the build) that contains special characters (e.g. `/ \ $ & % ^ > < | ;`) is passed to the `sh`, `bat`, `powershell`, or `pwsh` steps using Groovy interpolation. For a simple example:
另一个注意事项。对用户控制的变量使用 Groovy 字符串插值，并执行将其参数传递给命令解释器的步骤，例如 `sh`、`bat`、`powershell` 或 `pwsh` 步骤，可能会导致类似于 SQL 注入的问题。当包含特殊字符（例如`/ \ $ & % ^ > < | ;`）的用户控制变量（通常是环境变量，通常是传递给构建的参数）使用Groovy插值传递给`sh`、`bat`、`powershell`或`pwsh`步骤时，就会发生这种情况。举个简单的例子：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
  agent any
  parameters {
    string(name: 'STATEMENT', defaultValue: 'hello; ls /', description: 'What should I say?')
  }
  stages {
    stage('Example') {
      steps {
        /* WRONG! */
        sh("echo ${STATEMENT}")
      }
    }
  }
}
```

In this example, the argument to the `sh` step is evaluated by Groovy, and `STATEMENT` is interpolated directly into the argument as if `sh('echo hello; ls /')` has been written in the Pipeline. When this is processed on the agent, rather than echoing the value `hello; ls /`, it will echo `hello` then proceed to list the entire root directory of the agent. Any user able to control a variable interpolated by such a step would be able to make the `sh` step run arbitrary code on the agent. To avoid this problem, make sure arguments to steps such as `sh` or `bat` that reference parameters or other user-controlled environment variables use single quotes to avoid Groovy interpolation.
在此示例中，`Groovy 评估 sh` 步骤的参数，并将 `STATEMENT` 直接插入到参数中，就像 `sh（'echo 你好; ls /'）` 已写入管道一样。在代理上处理此操作时，它不会回显值 `你好; ls /`，而是回显 `你好`，然后继续列出代理的整个根目录。任何能够控制由此类步骤插值的变量的用户都能够使 `sh` 步骤在代理上运行任意代码。为避免此问题，请确保引用参数或其他用户控制的环境变量的步骤（如 `sh` 或 `bat`）的参数使用单引号以避免 Groovy 插值。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
  agent any
  parameters {
    string(name: 'STATEMENT', defaultValue: 'hello; ls /', description: 'What should I say?')
  }
  stages {
    stage('Example') {
      steps {
        /* CORRECT */
        sh('echo ${STATEMENT}')
      }
    }
  }
}
```

Credential mangling is another issue that can occur when credentials that contain  special characters are passed to a step using Groovy interpolation. When the credential value is mangled, it is no longer valid and will no  longer be masked in the console log.
凭证修饰是使用 Groovy 插值将包含特殊字符的凭证传递给步骤时可能出现的另一个问题。当凭证值被破坏时，它不再有效，并且将不再在控制台日志中被屏蔽。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
  agent any
  environment {
    EXAMPLE_KEY = credentials('example-credentials-id') // Secret value is 'sec%ret'
  }
  stages {
    stage('Example') {
      steps {
          /* WRONG! */
          bat "echo ${EXAMPLE_KEY}"
      }
    }
  }
}
```

Here, the `bat` step receives `echo sec%ret` and the Windows batch shell will simply drop the `%` and print out the value `secret`. Because there is a single character difference, the value `secret` will not be masked. Though the value is not the same as the actual credential, this is still a significant exposure of sensitive information. Again, single-quotes avoids this issue.
在这里，`bat` 步骤接收到 `echo sec%ret，Windows` 批处理 shell 将简单地删除 `%` 并打印出值 `secret`。由于存在单个字符差异，因此不会屏蔽值 `secret`。尽管该值与实际凭证不同，但这仍然是敏感信息的重大暴露。同样，单引号避免了这个问题。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
  agent any
  environment {
    EXAMPLE_KEY = credentials('example-credentials-id') // Secret value is 'sec%ret'
  }
  stages {
    stage('Example') {
      steps {
          /* CORRECT */
          bat 'echo %EXAMPLE_KEY%'
      }
    }
  }
}
```



### Handling parameters 处理参数

Declarative Pipeline supports parameters out-of-the-box, allowing the Pipeline to accept user-specified parameters at runtime via the [parameters directive](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters). Configuring parameters with Scripted Pipeline is done with the `properties` step, which can be found in the Snippet Generator.
Declarative Pipeline 支持开箱即用的参数，允许 Pipeline 在运行时通过 [parameters 指令](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters)接受用户指定的参数。使用 Scripted Pipeline 配置参数是通过 `properties` 步骤完成的，该步骤可以在 Snippet Generator 中找到。

If you configured your pipeline to accept parameters using the **Build with Parameters** option, those parameters are accessible as members of the `params` variable.
如果您使用 **Build with Parameters** 选项将管道配置为接受参数，则这些参数可以作为 `params` 变量的成员进行访问。

Assuming that a String parameter named "Greeting" has been configured in the `Jenkinsfile`, it  can access that parameter via `${params.Greeting}`:
假设在 `Jenkinsfile` 中配置了名为 “Greeting” 的 String 参数，它可以通过 `${params 访问该参数。问候}`：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    parameters {
        string(name: 'Greeting', defaultValue: 'Hello', description: 'How should I greet the world?')
    }
    stages {
        stage('Example') {
            steps {
                echo "${params.Greeting} World!"
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

### Handling failure 处理失败

Declarative Pipeline supports robust failure handling by default via its [post section](https://www.jenkins.io/doc/book/pipeline/syntax/#post) which allows declaring a number of different "post conditions" such as: `always`, `unstable`, `success`, `failure`, and `changed`. The [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/#post) section provides more detail on how to use the various post conditions.
默认情况下，Declarative Pipeline 通过其 [post 部分](https://www.jenkins.io/doc/book/pipeline/syntax/#post)支持健壮的故障处理，该部分允许声明许多不同的 “post 条件”，例如：`always`、`unstable`、`success`、`failure` 和 `changed`。[Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/#post) 部分提供了有关如何使用各种 POST 条件的更多详细信息。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'make check'
            }
        }
    }
    post {
        always {
            junit '**/target/*.xml'
        }
        failure {
            mail to: team@example.com, subject: 'The Pipeline failed :('
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

Scripted Pipeline however relies on Groovy’s built-in `try`/`catch`/`finally` semantics for handling failures during execution of the Pipeline.
然而，脚本化管道依赖于 Groovy 内置的 `try`/`catch`/`finally` 语义来处理管道执行期间的故障。

In the [Test](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#test) example above, the `sh` step was modified to never return a non-zero exit code (`sh 'make check || true'`). This approach, while valid, means the following stages need to check `currentBuild.result` to know if there has been a test failure or not.
在上面的 [Test](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#test) 示例中，`sh` 步骤被修改为从不返回非零退出代码 （`sh 'make check || true'`）。这种方法虽然有效，但意味着以下阶段需要检查 `currentBuild.result` 以了解是否存在测试失败。

An alternative way of handling this, which preserves the early-exit behavior of failures in Pipeline, while still giving `junit` the chance to capture test reports, is to use a series of `try`/`finally` blocks:
另一种处理此问题的方法是使用一系列 `try`/`finally` 块，它保留了 Pipeline 中失败的提前退出行为，同时仍然让 `junit` 有机会捕获测试报告：

### Using multiple agents 使用多个代理

In all the previous examples, only a single agent has been used. This means Jenkins will allocate an executor wherever one is available, regardless of how it is labeled or configured. Not only can this behavior be overridden, but Pipeline allows utilizing multiple agents in the Jenkins environment from within the *same* `Jenkinsfile`, which can helpful for more advanced use-cases such as  executing builds/tests across multiple platforms.
在前面的所有示例中，只使用了一个代理。这意味着 Jenkins 将在可用的地方分配一个 executor，无论它如何标记或配置。不仅可以覆盖此行为，而且 Pipeline 允许从*同一*`Jenkinsfile` 中使用 Jenkins 环境中的多个代理，这对于更高级的用例（例如跨多个平台执行构建/测试）非常有用。

In the example below, the "Build" stage will be performed on one agent and the built results will be reused on two subsequent agents, labelled "linux" and "windows" respectively, during the "Test" stage.
在下面的示例中，“Build”阶段将在一个代理上执行，在“Test”阶段，构建结果将在两个分别标记为“linux”和“windows”的后续代理上重用。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent none
    stages {
        stage('Build') {
            agent any
            steps {
                checkout scm
                sh 'make'
                stash includes: '**/target/*.jar', name: 'app' 
            }
        }
        stage('Test on Linux') {
            agent { 
                label 'linux'
            }
            steps {
                unstash 'app' 
                sh 'make check'
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
        stage('Test on Windows') {
            agent {
                label 'windows'
            }
            steps {
                unstash 'app'
                bat 'make check' 
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#)*（高级）*  

|      | The `stash` step allows capturing files matching an inclusion pattern (`**/target/*.jar`) for reuse within the *same* Pipeline. Once the Pipeline has completed its execution, stashed files are deleted from the Jenkins controller. `存储`步骤允许捕获与包含模式 （`**/target/*.jar`） 匹配的文件，以便*在同一*管道中重复使用。一旦 Pipeline 完成执行，就会从 Jenkins 控制器中删除隐藏的文件。 |
| ---- | ------------------------------------------------------------ |
|      | The parameter in `agent`/`node` allows for any valid Jenkins label expression. Consult the [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/) section for more details. `agent`/`node` 中的参数允许任何有效的 Jenkins 标签表达式。有关更多详细信息，请参阅 [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/) 部分。 |
|      | `unstash` will retrieve the named "stash" from the Jenkins controller into the Pipeline’s current workspace. `unstash` 会将命名的 “stash” 从 Jenkins 控制器检索到流水线的当前工作区中。 |
|      | The `bat` script allows for executing batch scripts on Windows-based platforms. `bat` 脚本允许在基于 Windows 的平台上执行批处理脚本。 |

### Optional step arguments 可选步骤参数

Pipeline follows the Groovy language convention of allowing parentheses to be omitted around method arguments.
Pipeline 遵循 Groovy 语言约定，允许在方法参数周围省略括号。

Many Pipeline steps also use the named-parameter syntax as a shorthand for creating a Map in Groovy, which uses the syntax `[key1: value1, key2: value2]`. Making statements like the following functionally equivalent:
许多 Pipeline 步骤还使用命名参数语法作为在 Groovy 中创建 Map 的简写，它使用语法 `[key1： value1， key2： value2]。`使类似于以下的语句在功能上等效：

```
git url: 'git://example.com/amazing-project.git', branch: 'master'
git([url: 'git://example.com/amazing-project.git', branch: 'master'])
```

For convenience, when calling steps taking only one parameter (or only one mandatory parameter), the parameter name may be omitted, for example:
为方便起见，当调用仅采用一个参数（或仅一个强制参数）的步骤时，可以省略参数名称，例如：

```
sh 'echo hello' /* short form  */
sh([script: 'echo hello'])  /* long form */
```

### Advanced Scripted Pipeline 高级脚本化管道

Scripted Pipeline is a domain-specific language [[3](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_3)] based on Groovy, most [Groovy syntax](http://groovy-lang.org/semantics.html) can be used in Scripted Pipeline without modification.
Scripted Pipeline 是一种基于 Groovy 的领域特定语言 [[3](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnotedef_3)]，大多数 [Groovy 语法](http://groovy-lang.org/semantics.html)都可以在 Scripted Pipeline 中使用，而无需修改。

#### Parallel execution 并行执行

The example in the [section above](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#using-multiple-agents) runs tests across two different platforms in a linear series. In practice, if the `make check` execution takes 30 minutes to complete, the "Test" stage would now take 60 minutes to complete!
[上一节](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#using-multiple-agents)中的示例在线性序列中的两个不同平台上运行测试。在实践中，如果 `make check` 执行需要 30 分钟才能完成，那么“Test”阶段现在需要 60 分钟才能完成！

Fortunately, Pipeline has built-in functionality for executing portions of Scripted Pipeline in parallel, implemented in the aptly named `parallel` step.
幸运的是，Pipeline 具有用于并行执行脚本化管道各部分的内置功能，在恰如其分地命名的`并行`步骤中实现。

Refactoring the example above to use the `parallel` step:
重构上面的示例以使用 `parallel` 步骤：

Jenkinsfile (Scripted Pipeline)
Jenkinsfile（脚本化管道）

```groovy
stage('Build') {
    /* .. snip .. */
}

stage('Test') {
    parallel linux: {
        node('linux') {
            checkout scm
            try {
                unstash 'app'
                sh 'make check'
            }
            finally {
                junit '**/target/*.xml'
            }
        }
    },
    windows: {
        node('windows') {
            /* .. snip .. */
        }
    }
}
```

Instead of executing the tests on the "linux" and "windows" labelled nodes in series, they will now execute in parallel assuming the requisite capacity exists in the Jenkins environment.
假设 Jenkins 环境中存在必要的容量，它们现在将并行执行，而不是在标记为 “linux” 和 “windows” 的节点上串行执行测试。

------

[1](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnoteref_1). [en.wikipedia.org/wiki/Source_control_management](https://en.wikipedia.org/wiki/Source_control_management)

[2](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnoteref_2). [en.wikipedia.org/wiki/Single_Source_of_Truth](https://en.wikipedia.org/wiki/Single_Source_of_Truth)

[3](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#_footnoteref_3). [en.wikipedia.org/wiki/Domain-specific_language](https://en.wikipedia.org/wiki/Domain-specific_language)

------

# Running Pipelines 运行管道

Table of Contents 目录

- Running a Pipeline 运行管道
  - [Multibranch 多分支](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#multibranch)
  - [Parameters 参数](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#parameters)
- Restarting or Rerunning a Pipeline
  重新启动或重新运行管道
  - [Replay 重播](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#replay)
  - Restart from a Stage 从阶段重新启动
    - How to Use 如何使用
      - [Restarting from the Classic UI
        从经典 UI 重新启动](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#restarting-from-the-classic-ui)
      - [Restarting from the Blue Ocean UI
        从 Blue Ocean UI 重新启动](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#restarting-from-the-blue-ocean-ui)
    - [Preserving `stash`es for Use with Restarted Stages
      保留 'stash' 以用于重新启动的阶段](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#preserving-stashes-for-use-with-restarted-stages)
- [Scheduling jobs in Jenkins
  在 Jenkins 中调度作业](https://www.jenkins.io/doc/book/pipeline/running-pipelines/#scheduling-jobs-in-jenkins)

## Running a Pipeline 运行管道

### Multibranch 多分支

See [the Multibranch documentation](https://www.jenkins.io/doc/book/pipeline/multibranch/) for more information.
有关更多信息[，请参阅 Multibranch 文档](https://www.jenkins.io/doc/book/pipeline/multibranch/)。

### Parameters 参数

See [the Jenkinsfile documentation](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-parameters) for more information
有关更多信息[，请参阅 Jenkinsfile 文档](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-parameters)

## Restarting or Rerunning a Pipeline 重新启动或重新运行管道

There are a number of ways to rerun or restart a completed Pipeline.
有多种方法可以重新运行或重新启动已完成的 Pipeline。

### Replay 重播

See [the Replay documentation](https://www.jenkins.io/doc/book/pipeline/development/#replay) for more information.
有关更多信息[，请参阅 Replay 文档](https://www.jenkins.io/doc/book/pipeline/development/#replay)。

### Restart from a Stage 从阶段重新启动

You can restart any completed Declarative Pipeline from any top-level stage which ran in that Pipeline. This allows you to rerun a Pipeline from a stage which failed due to transient or environmental considerations, for example. All inputs to the Pipeline will be the same. This includes SCM information, build parameters, and the contents of any `stash` step calls in the original Pipeline, if specified.
您可以从该 Pipeline 中运行的任何顶级阶段重新启动任何已完成的 Declarative  Pipeline。例如，这允许从由于瞬态或环境考虑而失败的阶段重新运行 Pipeline。Pipeline 的所有输入都将相同。这包括 SCM  信息、构建参数以及原始 Pipeline 中任何`存储`步骤调用的内容（如果指定）。

#### How to Use 如何使用

No additional configuration is needed in the Jenkinsfile to allow you to restart stages in your Declarative Pipelines. This is an inherent part of Declarative Pipelines and is available automatically.
Jenkinsfile 中不需要额外的配置来允许您重新启动声明式管道中的阶段。这是声明式管道的固有部分，并且会自动可用。

##### Restarting from the Classic UI 从经典 UI 重新启动

Once your Pipeline has completed, whether it succeeds or fails, you can go to the side panel for the run in the classic UI and click on "Restart from Stage".
管道完成后，无论成功还是失败，您都可以转到经典 UI 中运行的侧面板，然后单击“从舞台重新启动”。

![Restart from Stage link](https://www.jenkins.io/doc/book/resources/pipeline/restart-stages-sidebar.png)

You will be prompted to choose from a list of top-level stages that were executed in the original run, in the order they were executed. Stages which were skipped due to an earlier failure will not be available to be restarted, but stages which were skipped due to a `when` condition not being satisfied will be available. The parent stage for a group of `parallel` stages, or a group of nested `stages` to be run sequentially will also not be available - only top-level stages are allowed.
系统将提示您按照执行顺序从原始运行中执行的顶级阶段列表中进行选择。由于先前的失败而跳过的阶段将无法重新启动，但由于不满足 `when` 条件而跳过的阶段将可用。一组`并行`阶段的父阶段或一组要按顺序运行的嵌套`阶段`也将不可用 - 只允许顶级阶段。

![Choose the stage to restart](https://www.jenkins.io/doc/book/resources/pipeline/restart-stages-dropdown.png)

Once you choose a stage to restart from and click submit, a new build, with a new build number, will be started. All stages before the selected stage will be skipped, and the Pipeline will start executing at the selected stage. From that point on, the Pipeline will run as normal.
选择要重新启动的阶段并单击 submit 后，将启动具有新内部版本号的新内部版本。将跳过所选阶段之前的所有阶段，并且 Pipeline 将在所选阶段开始执行。从那时起，管道将正常运行。

##### Restarting from the Blue Ocean UI 从 Blue Ocean UI 重新启动

Restarting stages can also be done in the Blue Ocean UI.  Once your Pipeline has completed, whether it succeeds or fails, you can click on the node which represents the stage.  You can then click on the `Restart` link for that stage.
重启阶段也可以在 Blue Ocean UI 中完成。管道完成后，无论成功还是失败，您都可以单击代表该阶段的节点。然后，您可以单击该阶段的 `Restart` 链接。

![Click on Restart link for stage](https://www.jenkins.io/doc/book/resources/pipeline/pipeline-restart-stages-blue-ocean.png)

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  Alternative options for Pipeline visualization, such as the [Pipeline: Stage View](https://plugins.jenkins.io/pipeline-stage-view/) and [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) plugins, are available and offer some of the same functionality. While not complete replacements for Blue Ocean, contributions are  encouraged from the community for continued development of these  plugins. 管道可视化的替代选项（例如 [Pipeline： Stage View](https://plugins.jenkins.io/pipeline-stage-view/) 和 [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view/) 插件）可用，并提供一些相同的功能。虽然不是 Blue Ocean 的完全替代品，但鼓励社区为这些插件的持续开发做出贡献。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

#### Preserving `stash`es for Use with Restarted Stages 保留 'stash' 以用于重新启动的阶段

Normally, when you run the `stash` step in your Pipeline, the resulting stash of artifacts is cleared when the Pipeline completes, regardless of the result of the Pipeline. Since `stash` artifacts aren’t accessible outside of the Pipeline run that created them, this has not created any limitations on usage. But with Declarative stage restarting, you may want to be able to `unstash` artifacts from a stage which ran before the stage you’re restarting from.
通常，当您在 Pipeline 中运行 `stash` 步骤时，无论 Pipeline 的结果如何，都会在 Pipeline 完成时清除生成的构件存储。由于无法在创建它们的 Pipeline 运行之外访问`存储`构件，因此这不会对使用产生任何限制。但是，使用 Declarative 阶段重启时，你可能希望能够从要从中重启的阶段之前运行的阶段`中取消存储`构件。

To enable this, there is a job property that allows you to configure a maximum number of completed runs whose `stash` artifacts should be preserved for reuse in a restarted run. You can specify anywhere from 1 to 50 as the number of runs to preserve.
要启用此功能，有一个 job 属性，允许您配置已完成运行的最大数量，这些运行应保留其`存储`构件，以便在重新启动的运行中重复使用。您可以指定 1 到 50 之间的任意值作为要保留的运行数。

This job property can be configured in your Declarative Pipeline’s `options` section, as below:
可以在 Declarative Pipeline 的 `options` 部分中配置此 job 属性，如下所示：

```
options {
    preserveStashes() 
    // or
    preserveStashes(buildCount: 5) 
}
```

|      | The default number of runs to preserve is 1, just the most recent completed build. 要保留的默认运行数为 1，即最近完成的构建。 |
| ---- | ------------------------------------------------------------ |
|      | If a number for `buildCount` outside of the range of 1 to 50 is specified, the Pipeline will fail with a validation error. 如果指定的 `buildCount` 数字超出 1 到 50 的范围，则管道将失败并出现验证错误。 |

When a Pipeline completes, it will check to see if any previously completed runs should have their `stash` artifacts cleared.
当 Pipeline 完成时，它将检查是否应清除任何以前完成的运行其`存储`构件。

## Scheduling jobs in Jenkins 在 Jenkins 中调度作业

The scheduling function lets you schedule jobs to run automatically during off-hours or down times. Scheduling jobs can help you to scale your environment as Jenkins usage increases. This video provides insight on the scheduling function and its various configuration options.
计划功能允许您将作业计划为在非工作时间或停机时间自动运行。随着 Jenkins 使用量的增加，调度作业可以帮助您扩展环境。此视频提供了有关计划功能及其各种配置选项的见解。

<iframe width="800" height="420" src="https://www.youtube.com/embed/JhvVJtYFUm0?rel=0" frameborder="0" allowfullscreen=""></iframe>

------

[ ⇐ Using a Jenkinsfile  ⇐ 使用 Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile)

[ ⇑ Pipeline  ⇑ 管道](https://www.jenkins.io/doc/book/pipeline/) [ Index  指数](https://www.jenkins.io/doc/book/)

[ Branches and Pull Requests ⇒ 
](https://www.jenkins.io/doc/book/pipeline/multibranch)

# Branches and Pull Requests  分支和拉取请求

Table of Contents 目录

- Creating a Multibranch Pipeline
  创建多分支管道
  - [Additional Environment Variables
    其他环境变量](https://www.jenkins.io/doc/book/pipeline/multibranch/#additional-environment-variables)
  - [Supporting Pull Requests 支持拉取请求](https://www.jenkins.io/doc/book/pipeline/multibranch/#supporting-pull-requests)
- [Using Organization Folders
  使用组织文件夹](https://www.jenkins.io/doc/book/pipeline/multibranch/#organization-folders)

In the [previous section](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) a `Jenkinsfile` which could be checked into source control was implemented. This section covers the concept of **Multibranch** Pipelines which build on the `Jenkinsfile` foundation to provide more dynamic and automatic functionality in Jenkins.
在[上一节](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/)中，实现了一个可以签入源代码控制的 `Jenkinsfile`。本节介绍了**多分支**管道的概念，它建立在 `Jenkinsfile` 基础之上，在 Jenkins 中提供更多动态和自动化功能。

Creating a Multibranch Pipeline in Jenkins
在 Jenkins 中创建多分支管道

<iframe width="800" height="420" src="https://www.youtube.com/embed/B_2FXWI6CWg?rel=0" frameborder="0" allowfullscreen=""></iframe>

## Creating a Multibranch Pipeline 创建多分支管道

The **Multibranch Pipeline** project type enables you to implement different Jenkinsfiles for different branches of the same project. In a Multibranch Pipeline project, Jenkins automatically discovers, manages and executes Pipelines for branches which contain a `Jenkinsfile` in source control.
**Multibranch Pipeline** 项目类型使您能够为同一项目的不同分支实现不同的 Jenkinsfile。在 Multibranch Pipeline 项目中，Jenkins 会自动发现、管理和执行源代码控制中包含 `Jenkinsfile` 的分支的 Pipelines。

This eliminates the need for manual Pipeline creation and management.
这样就无需手动创建和管理 Pipeline。

To create a Multibranch Pipeline:
要创建 Multibranch Pipeline：

- Click **New Item** on Jenkins home page.
  单击 Jenkins 主页上的 **New Item**。

![Classic UI left column](https://www.jenkins.io/doc/book/resources/pipeline/classic-ui-left-column.png)

- Enter a name for your Pipeline, select **Multibranch Pipeline** and click **OK**.
  输入 Pipeline 的名称，选择 **Multibranch Pipeline** 并单击 **OK。**

|      | Jenkins uses the name of the Pipeline to create directories on disk. Pipeline names which include spaces may uncover bugs in scripts which do not expect paths to contain spaces. Jenkins 使用 Pipeline 的名称在磁盘上创建目录。包含空格的管道名称可能会发现脚本中的错误，这些脚本不希望路径包含空格。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

![Enter a name, select *Multibranch Pipeline*, and click *OK*](https://www.jenkins.io/doc/book/resources/pipeline/new-item-multibranch-creation.png)

- Add a **Branch Source** (for example, Git) and enter the location of the repository.
  添加 **Branch Source**（例如 Git）并输入存储库的位置。

![Add a Branch Source](https://www.jenkins.io/doc/book/resources/pipeline/multibranch-branch-source.png)

![Add the URL to the project repository](https://www.jenkins.io/doc/book/resources/pipeline/multibranch-branch-source-configuration.png)

- **Save** the Multibranch Pipeline project.
  **保存** Multibranch Pipeline 工程。

Upon **Save**, Jenkins automatically scans the designated repository and creates appropriate items for each branch in the repository which contains a `Jenkinsfile`.
**保存**后，Jenkins 会自动扫描指定的存储库，并为存储库中包含 `Jenkinsfile` 的每个分支创建适当的项目。

By default, Jenkins will not automatically re-index the repository for branch additions or deletions (unless using an [Organization Folder](https://www.jenkins.io/doc/book/pipeline/multibranch/#organization-folders)), so it is often useful to configure a Multibranch Pipeline to periodically re-index in the configuration:
默认情况下，Jenkins 不会自动为仓库的添加或删除重新索引（除非使用[组织文件夹](https://www.jenkins.io/doc/book/pipeline/multibranch/#organization-folders)），因此将 Multibranch Pipeline 配置为定期在配置中重新索引通常很有用：

![Setting up branch re-indexing](https://www.jenkins.io/doc/book/resources/pipeline/multibranch-branch-indexing.png)

### Additional Environment Variables 其他环境变量

Multibranch Pipelines expose additional information about the branch being built through the `env` global variable, such as:
Multibranch Pipelines 通过 `env` 全局变量公开有关正在构建的分支的其他信息，例如：

- BRANCH_NAME

  Name of the branch for which this Pipeline is executing, for example `master`. 此 Pipeline 正在为其执行的分支的名称，例如 `master`。

- CHANGE_ID

  An identifier corresponding to some kind of change request, such as a pull request number 与某种类型的更改请求对应的标识符，例如拉取请求编号

Additional environment variables are listed in the [Global Variable Reference](https://www.jenkins.io/doc/book/pipeline/getting-started/#global-variable-reference#).
其他环境变量在 [Global Variable Reference](https://www.jenkins.io/doc/book/pipeline/getting-started/#global-variable-reference#) 中列出。

### Supporting Pull Requests 支持拉取请求

Multibranch Pipelines can be used for validating pull/change requests with the appropriate plugin. This functionality is provided by the following plugins:
Multibranch Pipelines 可用于通过适当的插件验证 pull/change 请求。此功能由以下插件提供：

- [GitHub Branch Source GitHub 分支源](https://plugins.jenkins.io/github-branch-source)
- [Bitbucket Branch Source Bitbucket 分支源](https://plugins.jenkins.io/cloudbees-bitbucket-branch-source)
- [GitLab Branch Source GitLab 分支源](https://plugins.jenkins.io/gitlab-branch-source)
- [Gitea 吉蒂亚](https://plugins.jenkins.io/gitea)
- [Tuleap Git Branch Source Tuleap Git 分支源](https://plugins.jenkins.io/tuleap-git-branch-source)
- [AWS CodeCommit Jobs AWS CodeCommit 作业](https://plugins.jenkins.io/aws-codecommit-jobs)
- [DAGsHub Branch Source DAGsHub 分支源](https://plugins.jenkins.io/dagshub-branch-source)

Please consult their documentation for further information on how to use those plugins.
有关如何使用这些插件的更多信息，请参阅他们的文档。

## Using Organization Folders 使用组织文件夹

Organization Folders enable Jenkins to monitor an entire GitHub Organization, Bitbucket Team/Project, GitLab organization, or Gitea organization and automatically create new Multibranch Pipelines for repositories which contain branches and pull requests containing a `Jenkinsfile`.
组织文件夹使 Jenkins 能够监控整个 GitHub 组织、Bitbucket 团队/项目、GitLab 组织或 Gitea 组织，并自动为包含分支和拉取请求的存储库创建新的多分支`管道。`

Organization folders are implemented for:
组织文件夹的实施对象包括：

- GitHub in the [GitHub Branch Source](https://plugins.jenkins.io/github-branch-source) plugin
  [GitHub Branch Source](https://plugins.jenkins.io/github-branch-source) 插件中的 GitHub
- Bitbucket in the [Bitbucket Branch Source](https://plugins.jenkins.io/cloudbees-bitbucket-branch-source) plugin
  [Bitbucket Branch Source 插件中的 Bitbucket](https://plugins.jenkins.io/cloudbees-bitbucket-branch-source)
- GitLab in the [GitLab Branch Source](https://plugins.jenkins.io/gitlab-branch-source) plugin
  [GitLab 分支源](https://plugins.jenkins.io/gitlab-branch-source)插件中的 GitLab
- Gitea in the [Gitea](https://plugins.jenkins.io/gitea) plugin
  Gitea 插件中的 [Gitea](https://plugins.jenkins.io/gitea)

------

# Using Docker with Pipeline  将 Docker 与 Pipeline 结合使用

Table of Contents 目录

- Customizing the execution environment
  自定义执行环境
  - [Workspace synchronization
    工作区同步](https://www.jenkins.io/doc/book/pipeline/docker/#workspace-synchronization)
  - [Caching data for containers
    为容器缓存数据](https://www.jenkins.io/doc/book/pipeline/docker/#caching-data-for-containers)
  - [Using multiple containers
    使用多个容器](https://www.jenkins.io/doc/book/pipeline/docker/#using-multiple-containers)
  - [Using a Dockerfile 使用 Dockerfile](https://www.jenkins.io/doc/book/pipeline/docker/#dockerfile)
  - [Specifying a Docker Label
    指定 Docker 标签](https://www.jenkins.io/doc/book/pipeline/docker/#specifying-a-docker-label)
  - [Path setup for mac OS users
    mac OS 用户的路径设置](https://www.jenkins.io/doc/book/pipeline/docker/#path-setup-for-mac-os-users)
- Advanced Usage with Scripted Pipeline
  脚本化管道的高级用法
  - [Running "sidecar" containers
    运行 “sidecar” 容器](https://www.jenkins.io/doc/book/pipeline/docker/#running-sidecar-containers)
  - [Building containers 构建容器](https://www.jenkins.io/doc/book/pipeline/docker/#building-containers)
  - [Using a remote Docker server
    使用远程 Docker 服务器](https://www.jenkins.io/doc/book/pipeline/docker/#using-a-remote-docker-server)
  - [Using a custom registry 使用自定义注册表](https://www.jenkins.io/doc/book/pipeline/docker/#custom-registry)

Many organizations use [Docker](https://www.docker.com) to unify their build and test environments across machines, and to provide an efficient mechanism for deploying applications. Starting with Pipeline versions 2.5 and higher, Pipeline has built-in support for interacting with Docker from within a `Jenkinsfile`.
许多组织使用 [Docker](https://www.docker.com) 跨计算机统一其构建和测试环境，并提供一种高效的应用程序部署机制。从 Pipeline 版本 2.5 及更高版本开始，Pipeline 内置了对从 `Jenkinsfile` 中与 Docker 交互的支持。

While this page covers the basics of utilizing Docker from within a `Jenkinsfile`, it will not cover the fundamentals of Docker, which you can refer to in the [Docker Getting Started Guide](https://docs.docker.com/get-started/).
虽然本页介绍了在 `Jenkinsfile` 中使用 Docker 的基础知识，但不会涵盖 Docker 的基础知识，您可以在 [Docker 入门指南](https://docs.docker.com/get-started/)中参考。

## Customizing the execution environment 自定义执行环境

Pipeline is designed to easily use [Docker](https://docs.docker.com/) images as the execution environment for a single [Stage](https://www.jenkins.io/doc/book/glossary/#stage) or the entire Pipeline. Meaning that a user can define the tools required for their Pipeline, without having to manually configure agents. Any tool that can be [packaged in a Docker container](https://hub.docker.com) can be used with ease, by making only minor edits to a `Jenkinsfile`.
Pipeline 旨在轻松使用 [Docker](https://docs.docker.com/) 镜像作为单个 [Stage](https://www.jenkins.io/doc/book/glossary/#stage) 或整个 Pipeline 的执行环境。这意味着用户可以定义其 Pipeline 所需的工具，而无需手动配置代理。任何可以[打包在 Docker 容器中](https://hub.docker.com)的工具都可以轻松使用，只需对 `Jenkinsfile` 进行少量编辑即可。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        docker { image 'node:20.18.0-alpine3.20' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'node --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/docker/#)*（高级）*  

When the Pipeline executes, Jenkins will automatically start the specified container and execute the defined steps within:
当 Pipeline 执行时，Jenkins 将自动启动指定的容器并执行以下中定义的步骤：

```
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
[guided-tour] Running shell script
+ node --version
v16.13.1
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
```

### Workspace synchronization 工作区同步

If it is important to keep the workspace synchronized with other stages, use `reuseNode true`. Otherwise, a dockerized stage can be run on the same agent or any other agent, but in a temporary workspace.
如果保持工作区与其他阶段同步很重要，请使用 `reuseNode true`。否则，Docker 化阶段可以在同一代理或任何其他代理上运行，但在临时工作区中运行。

By default, for a containerized stage, Jenkins:
默认情况下，对于容器化阶段，Jenkins：

- Picks an agent. 选择代理。
- Creates a new empty workspace.
  创建新的空工作区。
- Clones pipeline code into it.
  将管道代码克隆到其中。
- Mounts this new workspace into the container.
  将此新工作区挂载到容器中。

If you have multiple Jenkins agents, your containerized stage can be started on any of them.
如果您有多个 Jenkins 代理，则可以在其中任何一个代理上启动容器化阶段。

When `reuseNode` is set to `true`, no new workspace will be created, and the current workspace from the current agent will be mounted into the container. After this, the container will be started on the same node, so all of the data will be synchronized.
当 `reuseNode` 设置为 `true` 时，不会创建新的工作区，当前代理中的当前工作区将挂载到容器中。在此之后，容器将在同一节点上启动，因此所有数据都将同步。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'gradle:8.2.0-jdk17-alpine'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                sh 'gradle --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/docker/#)*（高级）*  

### Caching data for containers 为容器缓存数据

Many build tools will download external dependencies and cache them locally  for future re-use. Since containers are initially created with "clean" file systems, this  can result in slower Pipelines, as they may not take advantage of  on-disk caches between subsequent Pipeline runs.
许多构建工具将下载外部依赖项并在本地缓存它们以备将来重用。由于容器最初是使用“干净”文件系统创建的，因此这可能会导致 Pipelines 速度变慢，因为它们在后续 Pipeline 运行之间可能无法利用磁盘上的缓存。

Pipeline supports adding custom arguments that are passed to Docker, allowing users to specify custom [Docker Volumes](https://docs.docker.com/engine/tutorials/dockervolumes/) to mount, which can be used for caching data on the [agent](https://www.jenkins.io/doc/book/glossary/#agent) between Pipeline runs. The following example will cache `~/.m2` between Pipeline runs utilizing the [`maven` container](https://hub.docker.com/_/maven/), avoiding the need to re-download dependencies for subsequent Pipeline runs.
Pipeline 支持添加传递给 Docker 的自定义参数，允许用户指定要挂载的自定义 [Docker 卷](https://docs.docker.com/engine/tutorials/dockervolumes/)，该卷可用于在 Pipeline 运行之间在[代理](https://www.jenkins.io/doc/book/glossary/#agent)上缓存数据。以下示例将在使用 [`maven` 容器](https://hub.docker.com/_/maven/)的 Pipeline 运行之间缓存 `~/.m2`，从而避免为后续 Pipeline 运行重新下载依赖项。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.9.3-eclipse-temurin-17'
            args '-v $HOME/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/docker/#)*（高级）*  

### Using multiple containers 使用多个容器

It has become increasingly common for code bases to rely on multiple different technologies. For example, a repository might have both a Java-based back-end API implementation *and* a JavaScript-based front-end implementation. Combining Docker and Pipeline allows a `Jenkinsfile` to use **multiple** types of technologies, by combining the `agent {}` directive with different stages.
代码库依赖于多种不同的技术已变得越来越普遍。例如，存储库可能同时具有基于 Java 的后端 API 实现*和*基于 JavaScript 的前端实现。通过将 Docker 和 Pipeline 结合使用，`Jenkinsfile` 可以通过将 `agent {}` 指令与不同的阶段结合使用来使用**多种**类型的技术。

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent none
    stages {
        stage('Back-end') {
            agent {
                docker { image 'maven:3.9.9-eclipse-temurin-21-alpine' }
            }
            steps {
                sh 'mvn --version'
            }
        }
        stage('Front-end') {
            agent {
                docker { image 'node:20.18.0-alpine3.20' }
            }
            steps {
                sh 'node --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/#)    *(Advanced)*
[Toggle 脚本化管道](https://www.jenkins.io/doc/book/pipeline/docker/#)*（高级）*  

### Using a Dockerfile 使用 Dockerfile

For projects requiring a more customized execution environment, Pipeline also supports building and running a container from a `Dockerfile` in the source repository. In contrast to the [previous approach](https://www.jenkins.io/doc/book/pipeline/docker/#execution-environment) of using an "off-the-shelf" container, using the `agent { dockerfile true }` syntax builds a new image from a `Dockerfile`, rather than pulling one from [Docker Hub](https://hub.docker.com).
对于需要更加自定义的执行环境的项目，Pipeline 还支持从源存储库中的 `Dockerfile` 构建和运行容器。与[之前](https://www.jenkins.io/doc/book/pipeline/docker/#execution-environment)使用“现成”容器的方法相比，使用 `agent { dockerfile true }` 语法从 `Dockerfile` 构建新映像，而不是从 [Docker Hub](https://hub.docker.com) 拉取一个。

Reusing an example from above, with a more custom `Dockerfile`:
使用更自定义的 `Dockerfile` 重用上面的示例：

Dockerfile Dockerfile 文件

```
FROM node:20.18.0-alpine3.20

RUN apk add -U subversion
```

By committing this to the root of the source repository, the `Jenkinsfile` can be changed to build a container based on this `Dockerfile`, and then run the defined steps using that container:
通过将其提交到源存储库的根目录，可以更改 `Jenkinsfile` 以基于此 `Dockerfile` 构建容器，然后使用该容器运行定义的步骤：

Jenkinsfile (Declarative Pipeline)
Jenkinsfile（声明式管道）

```groovy
pipeline {
    agent { dockerfile true }
    stages {
        stage('Test') {
            steps {
                sh 'node --version'
                sh 'svn --version'
            }
        }
    }
}
```

The `agent { dockerfile true }` syntax supports a number of other options, which are described in more detail in the [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax#agent) section.
`agent { dockerfile true }` 语法支持许多其他选项，管道[语法](https://www.jenkins.io/doc/book/pipeline/syntax#agent)部分将更详细地介绍这些选项。

Using a Dockerfile with Jenkins Pipeline
将 Dockerfile 与 Jenkins Pipeline 结合使用

<iframe width="852" height="480" src="https://www.youtube.com/embed/Pi2kJ2RJS50?rel=0" frameborder="0" allowfullscreen=""></iframe>

### Specifying a Docker Label 指定 Docker 标签

By default, Pipeline assumes that *any* configured [agent](https://www.jenkins.io/doc/book/glossary/#agent) is capable of running Docker-based Pipelines. For Jenkins environments that have macOS, Windows, or other agents that  are unable to run the Docker daemon, this default setting may be  problematic. Pipeline provides a global option on the **Manage Jenkins** page and on the [Folder](https://www.jenkins.io/doc/book/glossary/#folder) level, for specifying which agents (by [Label](https://www.jenkins.io/doc/book/glossary/#label)) to use for running Docker-based Pipelines.
默认情况下，Pipeline 假定*任何*配置的[代理](https://www.jenkins.io/doc/book/glossary/#agent)都能够运行基于 Docker 的 Pipelines。对于具有 macOS、Windows 或其他无法运行 Docker 守护程序的代理的 Jenkins 环境，此默认设置可能会出现问题。Pipeline 在 **Manage Jenkins （管理 Jenkins**） 页面和 [Folder](https://www.jenkins.io/doc/book/glossary/#folder) 级别提供了一个全局选项，用于指定哪些代理（按[标签](https://www.jenkins.io/doc/book/glossary/#label)）来运行基于 Docker 的管道。

![Configuring the Pipeline Docker Label](https://www.jenkins.io/doc/book/resources/pipeline/configure-docker-label.png)

### Path setup for mac OS users mac OS 用户的路径设置

The `/usr/local/bin` directory is not included in the macOS `PATH` for Docker images by default. If executables from `/usr/local/bin` need to be called from within Jenkins, the `PATH` needs to be extended to include `/usr/local/bin`. Add a path node in the file "/usr/local/Cellar/jenkins-lts/XXX/homebrew.mxcl.jenkins-lts.plist" like this:
默认情况下，`/usr/local/bin` 目录不包含在 Docker 映像的 macOS `PATH` 中。如果需要从 Jenkins 中调用 `/usr/local/bin` 中的可执行文件，则需要扩展 `PATH` 以包括 `/usr/local/bin`。在文件 “/usr/local/Cellar/jenkins-lts/XXX/homebrew.mxcl.jenkins-lts.plist” 中添加一个路径节点，如下所示：

Contents of homebrew.mxcl.jenkins-lts.plist
homebrew.mxcl.jenkins-lts.plist 的内容

```
<key>EnvironmentVariables</key>
<dict>
<key>PATH</key>
<string><!-- insert revised path here --></string>
</dict>
```

The revised `PATH` `string` should be a colon separated list of directories in the same format as the `PATH` environment variable and should include:
修改后的 `PATH``字符串`应为以冒号分隔的目录列表，格式与 `PATH` 环境变量相同，并且应包括：

- `/usr/local/bin` `/usr/local/bin` 中
- `/usr/bin` `/usr/bin` 中
- `/bin` `/站`
- `/usr/sbin` `/usr/sbin` 中
- `/sbin`
- `/Applications/Docker.app/Contents/Resources/bin/`
- `/Users/XXX/Library/Group\ Containers/group.com.docker/Applications/Docker.app/Contents/Resources/bin` (where `XXX` is replaced by your user name)
   `/Users/XXX/Library/Group\ Containers/group.com.docker/Applications/Docker.app/Contents/Resources/bin` （其中 `XXX` 替换为您的用户名）

Now, restart jenkins using `brew services restart jenkins-lts`.
现在，使用 `brew services restart jenkins-lts` 重新启动 jenkins。

## Advanced Usage with Scripted Pipeline 脚本化管道的高级用法

### Running "sidecar" containers 运行 “sidecar” 容器

Using Docker in Pipeline is an effective way to run a service on which the build, or a set of tests, may rely. Similar to the [sidecar pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar), Docker Pipeline can run one container "in the background", while performing work in another. Utilizing this sidecar approach, a Pipeline can have a "clean" container provisioned for each Pipeline run.
在 Pipeline 中使用 Docker 是运行构建或一组测试可能依赖的服务的有效方法。与 [sidecar 模式](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar)类似，Docker Pipeline 可以“在后台”运行一个容器，同时在另一个容器中执行工作。利用这种 sidecar 方法，Pipeline 可以为每个 Pipeline 运行预置一个 “干净” 的容器。

Consider a hypothetical integration test suite that relies on a local MySQL database to be running. Using the `withRun` method, implemented in the [Docker Pipeline](https://plugins.jenkins.io/docker-workflow) plugin’s support for Scripted Pipeline, a `Jenkinsfile` can run MySQL as a sidecar:
考虑一个假设的集成测试套件，它依赖于本地 MySQL 数据库来运行。使用 [Docker Pipeline](https://plugins.jenkins.io/docker-workflow) 插件对脚本化管道的支持中实现的 `withRun` 方法，`Jenkinsfile` 可以将 MySQL 作为 sidecar 运行：

```
node {
    checkout scm
    /*
     * In order to communicate with the MySQL server, this Pipeline explicitly
     * maps the port (`3306`) to a known port on the host machine.
     */
    docker.image('mysql:8-oracle').withRun('-e "MYSQL_ROOT_PASSWORD=my-secret-pw"' +
                                           ' -p 3306:3306') { c ->
        /* Wait until mysql service is up */
        sh 'while ! mysqladmin ping -h0.0.0.0 --silent; do sleep 1; done'
        /* Run some tests which require MySQL */
        sh 'make check'
    }
}
```

This example can be taken further, utilizing two containers simultaneously. One "sidecar" running MySQL, and another providing the [execution environment](https://www.jenkins.io/doc/book/pipeline/docker/#execution-environment) by using the Docker [container links](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/).
此示例可以进一步使用两个容器。一个运行 MySQL 的 “sidecar”，另一个使用 Docker [容器链接](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/)提供[执行环境](https://www.jenkins.io/doc/book/pipeline/docker/#execution-environment)。

```
node {
    checkout scm
    docker.image('mysql:8-oracle').withRun('-e "MYSQL_ROOT_PASSWORD=my-secret-pw"') { c ->
        docker.image('mysql:8-oracle').inside("--link ${c.id}:db") {
            /* Wait until mysql service is up */
            sh 'while ! mysqladmin ping -hdb --silent; do sleep 1; done'
        }
        docker.image('oraclelinux:9').inside("--link ${c.id}:db") {
            /*
             * Run some tests that require MySQL, and assume that it is
             * available on the host name `db`
             */
            sh 'make check'
        }
    }
}
```

The above example uses the object exposed by `withRun`, which has the running container’s ID available via the `id` property. Using the container’s ID, the Pipeline can create a link by passing custom Docker arguments to the `inside()` method.
上面的示例使用 `withRun` 公开的对象，该对象具有通过 `id` 属性提供的正在运行的容器的 ID。使用容器的 ID，Pipeline 可以通过将自定义 Docker 参数传递给 `inside（）` 方法来创建链接。

The `id` property can also be useful for inspecting logs from a running Docker container before the Pipeline exits:
`id` 属性还可用于在 Pipeline 退出之前检查正在运行的 Docker 容器的日志：

```
sh "docker logs ${c.id}"
```

### Building containers 构建容器

In order to create a Docker image, the [Docker Pipeline](https://plugins.jenkins.io/docker-workflow) plugin also provides a `build()` method for creating a new image from a `Dockerfile` in the repository during a Pipeline run.
为了创建 Docker 镜像，[Docker Pipeline](https://plugins.jenkins.io/docker-workflow) 插件还提供了一个 `build（）` 方法，用于在 Pipeline 运行期间从存储库中的 `Dockerfile` 创建新镜像。

One major benefit of using the syntax `docker.build("my-image-name")` is that a Scripted Pipeline can use the return value for subsequent Docker Pipeline calls, for example:
使用语法 `docker.build（“my-image-name”）` 的一个主要好处是，脚本化管道可以将返回值用于后续的 Docker 管道调用，例如：

```
node {
    checkout scm

    def customImage = docker.build("my-image:${env.BUILD_ID}")

    customImage.inside {
        sh 'make test'
    }
}
```

The return value can also be used to publish the Docker image to [Docker Hub](https://hub.docker.com) or a [custom Registry](https://www.jenkins.io/doc/book/pipeline/docker/#custom-registry), via the `push()` method, for example:
返回值还可用于通过 `push（）` 方法将 Docker 镜像发布到 [Docker Hub](https://hub.docker.com) 或[自定义注册表](https://www.jenkins.io/doc/book/pipeline/docker/#custom-registry)，例如：

```
node {
    checkout scm
    def customImage = docker.build("my-image:${env.BUILD_ID}")
    customImage.push()
}
```

One common usage of image "tags" is to specify a `latest` tag for the most recently validated version of a Docker image. The `push()` method accepts an optional `tag` parameter, allowing the Pipeline to push the `customImage` with different tags, for example:
映像 “标签” 的一个常见用法是为最近验证的 Docker 镜像版本指定`最新`标签。`push（）` 方法接受可选的 `tag` 参数，允许 Pipeline 推送具有不同标签的 `customImage`，例如：

```
node {
    checkout scm
    def customImage = docker.build("my-image:${env.BUILD_ID}")
    customImage.push()

    customImage.push('latest')
}
```

The `build()` method builds the `Dockerfile` in the current directory by default. This can be overridden by providing a directory path containing a `Dockerfile` as the second argument of the `build()` method, for example:
`默认情况下，build（）` 方法会在当前目录中构建 `Dockerfile`。这可以通过提供包含 `Dockerfile` 作为 `build（）` 方法的第二个参数的目录路径来覆盖，例如：

```
node {
    checkout scm
    def testImage = docker.build("test-image", "./dockerfiles/test") 

    testImage.inside {
        sh 'make test'
    }
}
```

|      | Builds `test-image` from the Dockerfile found at `./dockerfiles/test/Dockerfile`. 从 `./dockerfiles/test/Dockerfile` 中的 Dockerfile 构建 `test-image`。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

It is possible to pass other arguments to [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) by adding them to the second argument of the `build()` method. When passing arguments this way, the last value in the string must be  the path to the docker file, and should end with the folder to use as  the build context.
可以通过将其他参数添加到 `build（）` 方法的第二个参数来将其他参数传递给 [`docker build`](https://docs.docker.com/engine/reference/commandline/build/)。以这种方式传递参数时，字符串中的最后一个值必须是 docker 文件的路径，并且应以用作构建上下文的文件夹结尾。

This example overrides the default `Dockerfile` by passing the `-f` flag:
此示例通过传递 `-f` 标志来覆盖默认 `Dockerfile`：

```
node {
    checkout scm
    def dockerfile = 'Dockerfile.test'
    def customImage = docker.build("my-image:${env.BUILD_ID}",
                                   "-f ${dockerfile} ./dockerfiles") 
}
```

|      | Builds `my-image:${env.BUILD_ID}` from the Dockerfile found at `./dockerfiles/Dockerfile.test`. 构建 `my-image：${env.BUILD_ID}` 从 `./dockerfiles/Dockerfile.test` 中的 Dockerfile 中找到。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Using a remote Docker server 使用远程 Docker 服务器

By default, the [Docker Pipeline](https://plugins.jenkins.io/docker-workflow) plugin will communicate with a local Docker daemon, typically accessed through `/var/run/docker.sock`.
默认情况下，[Docker Pipeline](https://plugins.jenkins.io/docker-workflow) 插件将与本地 Docker 守护进程通信，通常通过 `/var/run/docker.sock` 访问。

To select a non-default Docker server, such as with [Docker Swarm](https://docs.docker.com/swarm/), use the `withServer()` method.
要选择非默认 Docker 服务器（例如使用 [Docker Swarm](https://docs.docker.com/swarm/)），请使用 `withServer（）` 方法。

You can pass a URI, and optionally the Credentials ID of a **Docker Server Certificate Authentication** pre-configured in Jenkins, to the method with:
您可以通过以下方式将 URI 和（可选）在 Jenkins 中预配置的 **Docker 服务器证书身份验证**的凭证 ID 传递给方法：

```
node {
    checkout scm

    docker.withServer('tcp://swarm.example.com:2376', 'swarm-certs') {
        docker.image('mysql:8-oracle').withRun('-p 3306:3306') {
            /* do things */
        }
    }
}
```

|      | `inside()` and `build()` will not work properly with a Docker Swarm server out of the box. `inside（）` 和 `build（）` 将无法在开箱即用的 Docker Swarm 服务器上正常工作。  For `inside()` to work, the Docker server and the Jenkins agent must use the same filesystem, so that the workspace can be mounted. 要使 `inside（）` 正常工作，Docker 服务器和 Jenkins 代理必须使用相同的文件系统，以便可以挂载工作区。  Currently, neither the Jenkins plugin nor the Docker CLI will automatically detect the case that the server is running remotely. A typical symptom of this would be errors from nested `sh` commands such as: 目前，Jenkins 插件和 Docker CLI 都不会自动检测服务器远程运行的情况。这种情况的一个典型症状是嵌套的 `sh` 命令中的错误，例如：  `cannot create /…@tmp/durable-…/pid: Directory nonexistent` |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

When Jenkins detects that the agent is itself running inside a Docker container, it will automatically pass the `--volumes-from` argument to the `inside` container, ensuring that it can share a workspace with the agent. 当 Jenkins 检测到代理本身在 Docker 容器内运行时，它会自动将 `--volumes-from` 参数传递给`内部`容器，确保它可以与代理共享工作区。  Additionally, some versions of Docker Swarm do not support custom Registries. 此外，某些版本的 Docker Swarm 不支持自定义 Registry。

### Using a custom registry 使用自定义注册表

By default, the [Docker Pipeline](https://plugins.jenkins.io/docker-workflow) plugin assumes the default Docker Registry of [Docker Hub](https://hub.docker.com).
默认情况下，[Docker Pipeline](https://plugins.jenkins.io/docker-workflow) 插件采用 [Docker Hub](https://hub.docker.com) 的默认 Docker 注册表。

In order to use a custom Docker Registry, users of Scripted Pipeline can wrap steps with the `withRegistry()` method, passing in the custom Registry URL, for example:
为了使用自定义 Docker Registry，脚本化管道的用户可以使用 `withRegistry（）` 方法包装步骤，传入自定义 Registry URL，例如：

```
node {
    checkout scm

    docker.withRegistry('https://registry.example.com') {

        docker.image('my-custom-image').inside {
            sh 'make test'
        }
    }
}
```

For a Docker Registry requiring authentication, add a "Username/Password"  Credentials item from the Jenkins home page and use the Credentials ID  as a second argument to `withRegistry()`:
对于需要身份验证的 Docker 注册表，请从 Jenkins 主页添加“用户名/密码”凭证项，并使用凭证 ID 作为 `withRegistry（）` 的第二个参数：

```
node {
    checkout scm

    docker.withRegistry('https://registry.example.com', 'credentials-id') {

        def customImage = docker.build("my-image:${env.BUILD_ID}")

        /* Push the container to the custom Registry */
        customImage.push()
    }
}
```

# Extending with Shared Libraries  使用共享库进行扩展

Table of Contents 目录

- Defining Shared Libraries
  定义共享库
  - [Directory structure 目录结构](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#directory-structure)
  - [Global Shared Libraries 全局共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#global-shared-libraries)
  - [Folder-level Shared Libraries
    文件夹级共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#folder-level-shared-libraries)
  - [Automatic Shared Libraries
    自动共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#automatic-shared-libraries)
- Using libraries 使用库
  - [Loading libraries dynamically
    动态加载库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#loading-libraries-dynamically)
  - [Library versions 库版本](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#library-versions)
  - [Retrieval Method 检索方法](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#retrieval-method)
- Writing libraries 编写库
  - [Accessing steps 访问步骤](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#accessing-steps)
  - [Defining global variables
    定义全局变量](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#defining-global-variables)
  - [Defining custom steps 定义自定义步骤](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#defining-custom-steps)
  - [Defining a more structured DSL
    定义更结构化的 DSL](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#defining-a-more-structured-dsl)
  - [Using third-party libraries
    使用第三方库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#using-third-party-libraries)
  - [Loading resources 加载资源](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#loading-resources)
  - [Pretesting library changes
    预测试库更改](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#pretesting-library-changes)
  - [Defining Declarative Pipelines
    定义声明性管道](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#defining-declarative-pipelines)
  - [Testing library pull request changes
    测试库拉取请求更改](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#testing-library-pull-request-changes)

As Pipeline is adopted for more and more projects in an organization, common patterns are likely to emerge. Oftentimes it is useful to share parts of Pipelines between various projects to reduce redundancies and keep code "DRY" [[1](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnotedef_1)].
随着组织中越来越多的项目采用 Pipeline，可能会出现常见模式。通常，在各种项目之间共享 Pipelines 的一部分以减少冗余并保持代码“DRY”是有用的 [[1](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnotedef_1)]。

Pipeline has support for creating "Shared Libraries" which can be defined in external source control repositories and loaded into existing Pipelines.
Pipeline 支持创建“共享库”，这些库可以在外部源代码控制存储库中定义并加载到现有 Pipelines 中。

<iframe width="800" height="420" src="https://www.youtube.com/embed/Wj-weFEsTb0?rel=0" frameborder="0" allowfullscreen=""></iframe>

## Defining Shared Libraries 定义共享库

A Shared Library is defined with a name, a source code retrieval method such as by SCM, and optionally a default version.  The name should be a short identifier as it will be used in scripts.
共享库使用名称、源代码检索方法（例如 SCM）和默认版本（可选）进行定义。名称应为短标识符，因为它将在脚本中使用。

The version could be anything understood by that SCM; for example, branches, tags, and commit hashes all work for Git.  You may also declare whether scripts need to explicitly request that library (detailed below), or if it is present by default.  Furthermore, if you specify a version in Jenkins configuration, you can block scripts from selecting a *different* version.
该版本可以是该 SCM 所理解的任何内容;例如，分支、标签和提交哈希都适用于 Git。您还可以声明脚本是否需要显式请求该库（详见下文），或者默认情况下它是否存在。此外，如果您在 Jenkins 配置中指定版本，则可以阻止脚本选择*其他*版本。

The best way to specify the SCM is using an SCM plugin which has been specifically updated to support a new API for checking out an arbitrary named version (*Modern SCM* option).  As of this writing, the latest versions of the Git and Subversion plugins support this mode; others should follow.
指定 SCM 的最佳方法是使用 SCM 插件，该插件已专门更新，以支持用于签出任意命名版本的新 API（*现代 SCM* 选项）。在撰写本文时，最新版本的 Git 和 Subversion 插件支持此模式;其他人应该效仿。

If your SCM plugin has not been integrated, you may select *Legacy SCM* and pick anything offered.  In this case, you need to include `${library.yourLibName.version}` somewhere in the configuration of the SCM, so that during checkout the plugin will expand this variable to select the desired version.  For example, for Subversion, you can set the *Repository URL* to `svnserver/project/${library.yourLibName.version}` and then use versions such as `trunk` or `branches/dev` or `tags/1.0`.
如果您的 SCM 插件尚未集成，您可以选择 *Legacy SCM* 并选择提供的任何内容。在这种情况下，您需要在 `${library.yourLibName.version}` SCM 的配置中包含某个位置，以便在结帐时插件将扩展此变量以选择所需的版本。例如，对于 Subversion，您可以将*存储库 URL* 设置为 `svnserver/project/${library.yourLibName.version}` 并使用 `trunk` 或 `branches/dev` 或 `tags/1.0` 等版本。

### Directory structure 目录结构

The directory structure of a Shared Library repository is as follows:
共享库仓库的目录结构如下：

```
(root)
+- src                     # Groovy source files
|   +- org
|       +- foo
|           +- Bar.groovy  # for org.foo.Bar class
+- vars
|   +- foo.groovy          # for global 'foo' variable
|   +- foo.txt             # help for 'foo' variable
+- resources               # resource files (external libraries only)
|   +- org
|       +- foo
|           +- bar.json    # static helper data for org.foo.Bar
```

The `src` directory should look like standard Java source directory structure. This directory is added to the classpath when executing Pipelines.
`src` 目录应类似于标准 Java 源目录结构。此目录在执行 Pipelines 时被添加到 Classpath 中。

The `vars` directory hosts script files that are exposed as a variable in  Pipelines. The name of the file is the name of the variable in the  Pipeline. So if you had a file called `vars/log.groovy` with a function like `def info(message)…` in it, you can access this function like `log.info "hello world"` in the Pipeline. You can put as many functions as you like inside this file. Read on below for more examples and options.
`vars` 目录包含作为 Pipelines 中的变量公开的脚本文件。文件名是 Pipeline 中变量的名称。因此，如果你有一个名为 `vars/log.groovy` 的文件，其中包含类似 `def info（message）...`的函数，那么你可以在 Pipeline 中像 `log.info “你好 world”` 一样访问这个函数。您可以在此文件中放置任意数量的函数。请继续阅读下文，了解更多示例和选项。

The basename of each `.groovy` file should be a Groovy (~ Java) identifier, conventionally `camelCased`. The matching `.txt`, if present, can contain documentation, processed through the system’s configured [markup formatter](https://wiki.jenkins.io/display/JENKINS/Markup+formatting) (so may really be HTML, Markdown, etc., though the `.txt` extension is required). This documentation will only be visible on the [Global Variable Reference](https://www.jenkins.io/doc/book/pipeline/getting-started/#global-variable-reference) pages that are accessed from the navigation sidebar of Pipeline jobs  that import the shared library. In addition, those jobs must run  successfully once before the shared library documentation will be  generated.
每个 `.groovy` 文件的 basename 都应该是 Groovy （~ Java） 标识符，通常采用`驼峰式大小写`。匹配的`.txt`（如果存在）可以包含文档，通过系统配置的[标记格式化程序](https://wiki.jenkins.io/display/JENKINS/Markup+formatting)进行处理（因此实际上可能是 HTML、Markdown 等，尽管需要 `.txt` 扩展）。此文档仅在 [Global Variable Reference](https://www.jenkins.io/doc/book/pipeline/getting-started/#global-variable-reference) 页面上可见，该页面可从导入共享库的 Pipeline 作业的导航侧边栏访问。此外，这些作业必须成功运行一次，然后才能生成共享库文档。

The Groovy source files in these directories get the same “CPS transformation” as in Scripted Pipeline.
这些目录中的 Groovy 源文件获得与 Scripted Pipeline 中相同的 “CPS 转换”。

A `resources` directory allows the `libraryResource` step to be used from an external library to load associated non-Groovy files. Currently this feature is not supported for internal libraries.
`资源`目录允许从外部库使用 `libraryResource` 步骤来加载关联的非 Groovy 文件。目前，内部库不支持此功能。

Other directories under the root are reserved for future enhancements.
根目录下的其他目录保留用于将来的增强。

### Global Shared Libraries 全局共享库

There are several places where Shared Libraries can be defined, depending on the use-case. *Manage Jenkins » System » Global Pipeline Libraries* as many libraries as necessary can be configured.
根据用例，可以在多个位置定义共享库。*管理 Jenkins » 系统 » 全局流水线库* 可以配置任意数量的库。

![Add a Global Pipeline Library](https://www.jenkins.io/doc/book/resources/pipeline/add-global-pipeline-libraries.png)

Since these libraries will be globally usable, any Pipeline in the system can utilize functionality implemented in these libraries.
由于这些库将全局可用，因此系统中的任何 Pipeline 都可以利用这些库中实现的功能。

These libraries are considered "trusted:" they can run any methods in Java, Groovy, Jenkins internal APIs, Jenkins plugins, or third-party libraries.  This allows you to define libraries which encapsulate individually unsafe APIs in a higher-level wrapper safe for use from any Pipeline.  Beware that **anyone able to push commits to this SCM repository could obtain unlimited access to Jenkins**. You need the *Overall/RunScripts* permission to configure these libraries (normally this will be granted to Jenkins administrators).
这些库被认为是“受信任的”：它们可以运行 Java、Groovy、Jenkins 内部 API、Jenkins 插件或第三方库中的任何方法。这允许您定义库，这些库将单个不安全的 API 封装在更高级别的包装器中，以便从任何 Pipeline 安全使用。请注意，**任何能够将提交推送到此 SCM 存储库的人都可以获得对 Jenkins 的无限制访问权限**。您需要 *Overall/RunScripts* 权限来配置这些库（通常将授予 Jenkins 管理员）。

### Folder-level Shared Libraries 文件夹级共享库

Any Folder created can have Shared Libraries associated with it. This mechanism allows scoping of specific libraries to all the Pipelines inside of the folder or subfolder.
创建的任何文件夹都可以具有与之关联的共享库。此机制允许将特定库的范围限定为文件夹或子文件夹内的所有 Pipelines。

Folder-based libraries are not considered "trusted:" they run in the Groovy sandbox just like typical Pipelines.
基于文件夹的库不被认为是“受信任的”：它们像典型的 Pipelines 一样在 Groovy 沙箱中运行。

### Automatic Shared Libraries 自动共享库

Other plugins may add ways of defining libraries on the fly.  For example, the [Pipeline: GitHub Groovy Libraries](https://plugins.jenkins.io/pipeline-github-lib) plugin allows a script to use an untrusted library named like `github.com/someorg/somerepo` without any additional configuration.  In this case, the specified GitHub repository would be loaded, from the `master` branch, using an anonymous checkout.
其他插件可能会添加动态定义库的方法。例如，[Pipeline： GitHub Groovy Libraries](https://plugins.jenkins.io/pipeline-github-lib) 插件允许脚本使用名为 `like github.com/someorg/somerepo` 的不受信任的库，而无需任何其他配置。在这种情况下，将使用匿名签出从 `master` 分支加载指定的 GitHub 存储库。

## Using libraries 使用库

Shared Libraries marked *Load implicitly* allows Pipelines to immediately use classes or global variables defined by any such libraries. To access other shared libraries, the `Jenkinsfile` needs to use the `@Library` annotation, specifying the library’s name:
标记为 *Load 的 Shared Libraries 隐式*允许 Pipelines 立即使用由任何此类库定义的类或全局变量。要访问其他共享库，`Jenkinsfile` 需要使用 `@Library` 注解，指定库的名称：

![Configuring a Global Pipeline Library](https://www.jenkins.io/doc/book/resources/pipeline/configure-global-pipeline-library.png)

```
@Library('my-shared-library') _
/* Using a version specifier, such as branch, tag, etc */
@Library('my-shared-library@1.0') _
/* Accessing multiple libraries with one statement */
@Library(['my-shared-library', 'otherlib@abc1234']) _
```

The annotation can be anywhere in the script where an annotation is permitted by Groovy.  When referring to class libraries (with `src/` directories), conventionally the annotation goes on an `import` statement:
Comments 可以位于 Groovy 允许 Comments 的脚本中任何位置。当引用类库（带有 `src/` 目录）时，通常 annotation 位于 `import` 语句中：

```
@Library('somelib')
import com.mycorp.pipeline.somelib.UsefulClass
```

|      | For Shared Libraries which only define Global Variables (`vars/`), or a `Jenkinsfile` which only needs a Global Variable, the [annotation](http://groovy-lang.org/objectorientation.html#_annotation) pattern `@Library('my-shared-library') _` may be useful for keeping code concise. In essence, instead of annotating an unnecessary `import` statement, the symbol `_` is annotated. 对于仅定义全局变量 （`vars/`） 的共享库，或只需要全局变量的 `Jenkinsfile`，[注释](http://groovy-lang.org/objectorientation.html#_annotation)模式 `@Library('my-shared-library') _` 可能有助于保持代码简洁。实质上，不是对不必要的 `import` 语句进行注释，而是对符号 `_` 进行注释。  It is not recommended to `import` a global variable/function, since this will force the compiler to interpret fields and methods as `static` even if they were intended to be customized. The Groovy compiler in this case can produce confusing error messages. 不建议`导入`全局变量/函数，因为这将强制编译器将字段和方法解释为 `static`，即使它们打算进行自定义。在这种情况下，Groovy 编译器可能会产生令人困惑的错误消息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Libraries are resolved and loaded during *compilation* of the script, before it starts executing.  This allows the Groovy compiler to understand the meaning of symbols used in static type checking, and permits them to be used in type declarations in the script, for example:
在脚本开始执行之前，在脚本*编译*期间解析并加载库。这允许 Groovy 编译器理解静态类型检查中使用的符号的含义，并允许它们在脚本的类型声明中使用，例如：

```
@Library('somelib')
import com.mycorp.pipeline.somelib.Helper

int useSomeLib(Helper helper) {
    helper.prepare()
    return helper.count()
}

echo useSomeLib(new Helper('some text'))
```



Global Variables however, are resolved at runtime.
但是，全局变量在运行时解析。

This video reviews using resource files from a Shared Library. A link to the example repository used is also provided in the [video description](https://youtu.be/eV7roTXrEqg).
此视频回顾了如何使用共享库中的资源文件。[视频说明](https://youtu.be/eV7roTXrEqg)中还提供了指向所用示例存储库的链接。

<iframe width="800" height="420" src="https://www.youtube.com/embed/eV7roTXrEqg?rel=0" frameborder="0" allowfullscreen=""></iframe>

### Loading libraries dynamically 动态加载库

As of version 2.7 of the *Pipeline: Shared Groovy Libraries* plugin, there is a new option for loading (non-implicit) libraries in a script: a `library` step that loads a library *dynamically*, at any time during the build.
从 *Pipeline： Shared Groovy Libraries* 插件的 2.7 版本开始，有一个用于在脚本中加载（非隐式）库的新选项：在构建过程中随时*动态*加载库的`库`步骤。

If you are only interested in using global variables/functions (from the `vars/` directory), the syntax is quite simple:
如果你只对使用全局变量/函数（来自 `vars/` 目录）感兴趣，语法非常简单：

```
library 'my-shared-library'
```

Thereafter, any global variables from that library will be accessible to the script.
此后，脚本将可以访问该库中的任何全局变量。

Using classes from the `src/` directory is also possible, but trickier. Whereas the `@Library` annotation prepares the “classpath” of the script prior to compilation, by the time a `library` step is encountered the script has already been compiled. Therefore you cannot `import` or otherwise “statically” refer to types from the library.
使用 `src/` 目录中的类也是可能的，但更棘手。虽然 `@Library` 注解在编译之前准备了脚本的 “classpath”，但当遇到`库`步骤时，脚本已经被编译了。因此，您不能`导入`或以其他方式“静态”引用库中的类型。

However you may use library classes dynamically (without type checking), accessing them by fully-qualified name from the return value of the `library` step. `static` methods can be invoked using a Java-like syntax:
但是，您可以动态地使用库类（无需类型检查），通过`库`步骤的返回值中的完全限定名称访问它们。可以使用类似 Java 的语法调用 `static` 方法：

```
library('my-shared-library').com.mycorp.pipeline.Utils.someStaticMethod()
```

You can also access `static` fields, and call constructors as if they were `static` methods named `new`:
您还可以访问`静态`字段，并调用构造函数，就像它们是名为 `new` 的`静态`方法一样：

```
def useSomeLib(helper) { // dynamic: cannot declare as Helper
    helper.prepare()
    return helper.count()
}

def lib = library('my-shared-library').com.mycorp.pipeline // preselect the package

echo useSomeLib(lib.Helper.new(lib.Constants.SOME_TEXT))
```

### Library versions 库版本

The "Default version" for a configured Shared Library is used when "Load implicitly" is checked, or if a Pipeline references the library only by name, for example `@Library('my-shared-library') _`. If a "Default version" is **not** defined, the Pipeline must specify a version, for example `@Library('my-shared-library@master') _`.
当选中“Load implicitly”时，或者如果 Pipeline 仅按名称引用库，则使用已配置共享库的“Default version”，例如 `@Library('my-shared-library') _` .如果未**定义 “**Default version”，则 Pipeline 必须指定一个版本，例如 `@Library('my-shared-library@master') _` .

If "Allow default version to be overridden" is enabled in the Shared Library’s configuration, a `@Library` annotation may also override a default version defined for the library. This also allows a library with "Load implicitly" to be loaded from a different version if necessary.
如果在共享库的配置中启用了“允许覆盖默认版本”，`则@Library`注释也可能覆盖为库定义的默认版本。这也允许在必要时从其他版本加载具有 “Load implicitly” 的库。

When using the `library` step you may also specify a version:
使用`库`步骤时，您还可以指定版本：

```
library 'my-shared-library@master'
```

Since this is a regular step, that version could be *computed* rather than a constant as with the annotation; for example:
由于这是一个常规步骤，因此可以*计算*该版本，而不是像 annotation 那样使用常量;例如：

```
library "my-shared-library@$BRANCH_NAME"
```

would load a library using the same SCM branch as the multibranch `Jenkinsfile`. As another example, you could pick a library by parameter:
将使用与多分支 `Jenkinsfile` 相同的 SCM 分支加载库。再举一个例子，你可以按参数选择一个库：

```
properties([parameters([string(name: 'LIB_VERSION', defaultValue: 'master')])])
library "my-shared-library@${params.LIB_VERSION}"
```

Note that the `library` step may not be used to override the version of an implicitly loaded library. It is already loaded by the time the script starts, and a library of a given name may not be loaded twice.
请注意，`库`步骤不能用于覆盖隐式加载的库的版本。在脚本启动时，它已经加载，并且给定的库可能不会加载两次。

### Retrieval Method 检索方法

The best way to specify the SCM is using an SCM plugin which has been specifically updated to support a new API for checking out an arbitrary named version (**Modern SCM** option). As of this writing, the latest versions of the Git and Subversion plugins support this mode.
指定 SCM 的最佳方法是使用 SCM 插件，该插件已专门更新，以支持用于签出任意命名版本的新 API（**现代 SCM** 选项）。在撰写本文时，最新版本的 Git 和 Subversion 插件支持此模式。

![Configuring a 'Modern SCM' for a Pipeline Library](https://www.jenkins.io/doc/book/resources/pipeline/global-pipeline-library-modern-scm.png)

#### Legacy SCM 旧版 SCM

SCM plugins which have not yet been updated to support the newer features required by Shared Libraries, may still be used via the **Legacy SCM** option. In this case, include `${library.yourlibrarynamehere.version}` wherever a branch/tag/ref may be configured for that particular SCM plugin.  This ensures that during checkout of the library’s source code, the SCM plugin will expand this variable to checkout the appropriate version of the library.
尚未更新以支持共享库所需的新功能的 SCM 插件仍可通过 **Legacy SCM** 选项使用。在这种情况下，请包括 `${library.yourlibrarynamehere.version}` 可以为该特定 SCM 插件配置的 branch/tag/ref 的任何位置。这可确保在签出库的源代码期间，SCM 插件将扩展此变量以签出库的相应版本。

![Configuring a 'Legacy SCM' for a Pipeline Library](https://www.jenkins.io/doc/book/resources/pipeline/global-pipeline-library-legacy-scm.png)

#### Dynamic retrieval 动态检索

If you only specify a library name (optionally with version after `@`) in the `library` step, Jenkins will look for a preconfigured library of that name. (Or in the case of a `github.com/owner/repo` automatic library it will load that.)
如果您在`库`步骤中仅指定库名称（可以选择在 `@` 后使用 version），Jenkins 将查找该名称的预配置库。（或者在 `github.com/owner/repo` 自动库的情况下，它将加载它。

But you may also specify the retrieval method dynamically, in which case there is no need for the library to have been predefined in Jenkins. Here is an example:
但您也可以动态指定检索方法，在这种情况下，无需在 Jenkins 中预定义库。下面是一个示例：

```
library identifier: 'custom-lib@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'git@git.mycorp.com:my-jenkins-utils.git',
   credentialsId: 'my-private-key'])
```

It is best to refer to **Pipeline Syntax** for the precise syntax for your SCM.
最好参考 **Pipeline Syntax** 来了解 SCM 的确切语法。

Note that the library version *must* be specified in these cases.
请注意，在这些情况下*，必须*指定库版本。

## Writing libraries 编写库

At the base level, any valid [Groovy code](http://groovy-lang.org/syntax.html) is okay for use. Different data structures, utility methods, etc, such as:
在基本级别，任何有效的 [Groovy 代码](http://groovy-lang.org/syntax.html)都可以使用。不同的数据结构、实用程序方法等，例如：

```
// src/org/foo/Point.groovy
package org.foo

// point in 3D space
class Point {
  float x,y,z
}
```

### Accessing steps 访问步骤

Library classes cannot directly call steps such as `sh` or `git`. They can however implement methods, outside of the scope of an enclosing class, which in turn invoke Pipeline steps, for example:
库类不能直接调用 `sh` 或 `git` 等步骤。但是，他们可以在封闭类的范围之外实现方法，这些方法反过来调用 Pipeline 步骤，例如：

```
// src/org/foo/Zot.groovy
package org.foo

def checkOutFrom(repo) {
  git url: "git@github.com:jenkinsci/${repo}"
}

return this
```



Which can then be called from a Scripted Pipeline:
然后可以从脚本化管道中调用它：

```
def z = new org.foo.Zot()
z.checkOutFrom(repo)
```

This approach has limitations; for example, it prevents the declaration of a superclass.
这种方法有局限性;例如，它阻止了 superclass 的声明。

Alternately, a set of `steps` can be passed explicitly using `this` to a library class, in a constructor, or just one method:
或者，可以使用 `this` 将一组`步骤`显式传递给库类、构造函数或仅一个方法：

```
package org.foo
class Utilities implements Serializable {
  def steps
  Utilities(steps) {this.steps = steps}
  def mvn(args) {
    steps.sh "${steps.tool 'Maven'}/bin/mvn -o ${args}"
  }
}
```

When saving state on classes, such as above, the class **must** implement the `Serializable` interface. This ensures that a Pipeline using the class, as seen in the example below, can properly suspend and resume in Jenkins.
在类上保存状态时（如上），该类**必须**实现 `Serializable` 接口。这可确保使用该类的 Pipeline （如下例所示）可以在 Jenkins 中正确挂起和恢复。

```
@Library('utils') import org.foo.Utilities
def utils = new Utilities(this)
node {
  utils.mvn 'clean package'
}
```

If the library needs to access global variables, such as `env`, those should be explicitly passed into the library classes, or methods, in a similar manner.
如果库需要访问全局变量，例如 `env`，则应以类似的方式将这些变量显式传递到库类或方法中。

Instead of passing numerous variables from the Scripted Pipeline into a library,
不是将大量变量从脚本化管道传递到库中，

```
package org.foo
class Utilities {
  static def mvn(script, args) {
    script.sh "${script.tool 'Maven'}/bin/mvn -s ${script.env.HOME}/jenkins.xml -o ${args}"
  }
}
```

The above example shows the script being passed in to one `static` method, invoked from a Scripted Pipeline as follows:
上面的示例显示了传入一个`静态`方法的脚本，该方法从 Scripted Pipeline 调用，如下所示：

```
@Library('utils') import static org.foo.Utilities.*
node {
  mvn this, 'clean package'
}
```

### Defining global variables 定义全局变量

Internally, scripts in the `vars` directory are instantiated on-demand  as singletons. This allows multiple methods to be defined in a single `.groovy` file for convenience.  For example:
在内部，`vars` 目录中的脚本按需实例化为单例。为了方便起见，这允许在单个 `.groovy` 文件中定义多个方法。例如：

vars/log.groovy

```
def info(message) {
    echo "INFO: ${message}"
}

def warning(message) {
    echo "WARNING: ${message}"
}
```

Jenkinsfile Jenkinsfile 文件

```
@Library('utils') _

log.info 'Starting'
log.warning 'Nothing to do!'
```

Declarative Pipeline does not allow method calls on objects outside "script" blocks. ([JENKINS-42360](https://issues.jenkins.io/browse/JENKINS-42360)). The method calls above would need to be put inside a `script` directive:
声明式管道不允许对 “script” 块之外的对象进行方法调用。（[JENKINS-42360 的 JENKINS](https://issues.jenkins.io/browse/JENKINS-42360) 版本）。上面的方法调用需要放在 `script` 指令中：

Jenkinsfile Jenkinsfile 文件

```
@Library('utils') _

pipeline {
    agent none
    stages {
        stage ('Example') {
            steps {
                // log.info 'Starting' 
                script { 
                    log.info 'Starting'
                    log.warning 'Nothing to do!'
                }
            }
        }
    }
}
```

|      | This method call would fail because it is outside a `script` directive. 此方法调用将失败，因为它位于 `script` 指令之外。 |
| ---- | ------------------------------------------------------------ |
|      | `script` directive required to access global variables in Declarative Pipeline. `script` 指令来访问声明式管道中的全局变量。 |

|      | A variable defined in a shared library will only show up in *Global Variables Reference* (under *Pipeline Syntax*) after Jenkins loads and uses that library as part of a successful Pipeline run. 在 Jenkins 加载并使用该库作为成功管道运行的一部分后，共享库中定义的变量才会显示在 *全局变量引用* （在 *管道语法* 下） 中。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

|      | Avoid preserving state in global variables 避免在全局变量中保留状态 All global variables defined in a Shared Library should be stateless, i.e. they should act as collections of functions. If your pipeline tried to store some state in global variables, this state would be lost in case of Jenkins controller restart. Use a static class or instantiate a local variable of a class instead. 共享库中定义的所有全局变量都应该是无状态的，即它们应该充当函数的集合。如果您的管道尝试在全局变量中存储某些状态，则在 Jenkins 控制器重新启动时，此状态将丢失。请改用 static 类或实例化类的局部变量。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Though using fields for global variables is discouraged as per above, it is possible to define fields and use them as read-only. To define a field you need to use an annotation:
尽管如上所述不鼓励对全局变量使用字段，但可以定义字段并将其用作只读字段。要定义字段，您需要使用注释：

```
@groovy.transform.Field
def yourField = "YourConstantValue"

def yourFunction....
```

### Defining custom steps 定义自定义步骤

Shared Libraries can also define global variables which behave similarly to built-in steps, such as `sh` or `git`. Global variables defined in Shared Libraries **must** be named with all lowercase or "camelCased" in order to be loaded properly by Pipeline. [[2](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnotedef_2)]
共享库还可以定义全局变量，其行为类似于内置步骤，例如 `sh` 或 `git`。在共享库中定义的全局变量**必须**以全小写或 “camelCased” 命名，以便 Pipeline 正确加载。[[2](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnotedef_2)]

For example, to define `sayHello`, the file `vars/sayHello.groovy` should be created and should implement a `call` method. The `call` method allows the global variable to be invoked in a manner similar to a step:
例如，要定义 `sayHello`，应创建文件 `vars/sayHello.groovy` 并实现 `call` 方法。`call` 方法允许以类似于 step 的方式调用全局变量：

```
// vars/sayHello.groovy
def call(String name = 'human') {
    // Any valid steps can be called from this code, just like in other
    // Scripted Pipeline
    echo "Hello, ${name}."
}
```

The Pipeline would then be able to reference and invoke this variable:
然后，管道将能够引用和调用此变量：

```
sayHello 'Joe'
sayHello() /* invoke with default arguments */
```

If called with a block, the `call` method will receive a [`Closure`](http://groovy-lang.org/closures.html). The type should be defined explicitly to clarify the intent of the step, for example:
如果使用区块调用，`则 call` 方法将收到 [`Closure`](http://groovy-lang.org/closures.html)。应显式定义类型以阐明步骤的意图，例如：

```
// vars/windows.groovy
def call(Closure body) {
    node('windows') {
        body()
    }
}
```

The Pipeline can then use this variable like any built-in step which accepts a block:
然后，Pipeline 可以像任何接受块的内置步骤一样使用此变量：

```
windows {
    bat "cmd /?"
}
```

### Defining a more structured DSL 定义更结构化的 DSL

If you have a lot of Pipelines that are mostly similar, the global variable mechanism provides a handy tool to build a higher-level DSL that captures the similarity. For example, all Jenkins plugins are built and tested in the same way, so we might write a step named `buildPlugin`:
如果你有很多大部分相似的 Pipelines，全局变量机制提供了一个方便的工具来构建一个更高级别的 DSL 来捕获相似性。例如，所有 Jenkins 插件都以相同的方式构建和测试，因此我们可以编写一个名为 `buildPlugin` 的步骤：

```
// vars/buildPlugin.groovy
def call(Map config) {
    node {
        git url: "https://github.com/jenkinsci/${config.name}-plugin.git"
        sh 'mvn install'
        mail to: '...', subject: "${config.name} plugin build", body: '...'
    }
}
```

Assuming the script has either been loaded as a [Global Shared Library](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#global-shared-libraries) or as a [Folder-level Shared Library](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#folder-level-shared-libraries) the resulting `Jenkinsfile` will be dramatically simpler:
假设脚本已加载为[全局共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#global-shared-libraries)或[文件夹级共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#folder-level-shared-libraries)，则生成的 `Jenkinsfile` 将大大简化：

Jenkinsfile (Scripted Pipeline)
Jenkinsfile（脚本化管道）

```groovy
buildPlugin name: 'git'
```

There is also a “builder pattern” trick using Groovy’s `Closure.DELEGATE_FIRST`, which permits `Jenkinsfile` to look slightly more like a configuration file than a program, but this is more complex and error-prone and is not recommended.
还有一个使用 Groovy `Closure.DELEGATE_FIRST`的 “builder pattern” 技巧，它允许 `Jenkinsfile` 看起来更像一个配置文件而不是一个程序，但这更复杂且容易出错，因此不建议这样做。

### Using third-party libraries 使用第三方库

|      | While possible, accessing third-party libraries using `@Grab` from trusted libraries has various issues and is not recommended. Instead of using `@Grab`, the recommended approach is to create a standalone executable in the  programming language of your choice (using whatever third-party  libraries you desire), install it on the Jenkins agents that your  Pipelines use, and then invoke that executable in your Pipelines using  the `bat` or `sh` step. 虽然可能，但使用来自受信任库的 `@Grab` 访问第三方库存在各种问题，因此不建议这样做。推荐的方法是，使用您选择的编程语言（使用您想要的任何第三方库）创建一个独立的可执行文件，而不是使用 `@Grab`，将其安装在管道使用的 Jenkins 代理上，然后使用 `bat` 或 `sh` 步骤在管道中调用该可执行文件。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

It is possible to use third-party Java libraries, typically found in [Maven Central](https://search.maven.org/), from **trusted** library code using the `@Grab` annotation.  Refer to the [Grape documentation](https://docs.groovy-lang.org/latest/html/documentation/grape.html#_quick_start) for details, but simply put:
可以使用 `@Grab` 注释从**受信任的**库代码中使用第三方 Java 库（通常在 [Maven Central](https://search.maven.org/) 中找到）。有关详细信息，请参阅 [Grape 文档](https://docs.groovy-lang.org/latest/html/documentation/grape.html#_quick_start)，但简单地说：

```
@Grab('org.apache.commons:commons-math3:3.4.1')
import org.apache.commons.math3.primes.Primes
void parallelize(int count) {
  if (!Primes.isPrime(count)) {
    error "${count} was not prime"
  }
  // …
}
```

Third-party libraries are cached by default in `~/.groovy/grapes/` on the Jenkins controller.
默认情况下，第三方库缓存在 Jenkins 控制器上的 `~/.groovy/grapes/` 中。

### Loading resources 加载资源

External libraries may load adjunct files from a `resources/` directory using the `libraryResource` step.  The argument is a relative pathname, akin to Java resource loading:
外部库可以使用 `libraryResource` 步骤从 `resources/` 目录加载附属文件。该参数是一个相对路径名，类似于 Java 资源加载：

```
def request = libraryResource 'com/mycorp/pipeline/somelib/request.json'
```

The file is loaded as a string, suitable for passing to certain APIs or saving to a workspace using `writeFile`.
该文件将作为字符串加载，适合传递给某些 API 或使用 `writeFile` 保存到工作区。

It is advisable to use an unique package structure so you do not accidentally conflict with another library.
建议使用唯一的包结构，这样就不会意外地与其他库冲突。

### Pretesting library changes 预测试库更改

If you notice a mistake in a build using an untrusted library, simply click the *Replay* link to try editing one or more of its source files, and see if the resulting build behaves as expected. Once you are satisfied with the result, follow the diff link from the build’s status page, and apply the diff to the library repository and commit.
如果您在使用不受信任的库的构建中发现错误，只需单击 *Replay* 链接即可尝试编辑其一个或多个源文件，并查看生成的构建是否按预期运行。对结果满意后，请按照内部版本状态页面中的 diff 链接，将 diff 应用于库存储库并提交。

(Even if the version requested for the library was a branch, rather than a fixed version like a tag, replayed builds will use the exact same revision as the original build: library sources will not be checked out again.)
（即使为库请求的版本是分支，而不是像标签这样的固定版本，重放的版本也将使用与原始版本完全相同的修订：库源将不会再次签出。

*Replay* is not currently supported for trusted libraries. Modifying resource files is also not currently supported during *Replay*.
受信任的库当前不支持*重播*。在 *Replay* 期间，当前也不支持修改资源文件。

### Defining Declarative Pipelines 定义声明性管道

Starting with Declarative 1.2, released in late September, 2017, you can define Declarative Pipelines in your shared libraries as well. Here’s an example, which will execute a different Declarative Pipeline depending on whether the build number is odd or even:
从 2017 年 9 月下旬发布的 Declarative 1.2 开始，您也可以在共享库中定义 Declarative Pipelines。下面是一个示例，它将根据内部版本号是奇数还是偶数来执行不同的声明式管道：

```
// vars/evenOrOdd.groovy
def call(int buildNumber) {
  if (buildNumber % 2 == 0) {
    pipeline {
      agent any
      stages {
        stage('Even Stage') {
          steps {
            echo "The build number is even"
          }
        }
      }
    }
  } else {
    pipeline {
      agent any
      stages {
        stage('Odd Stage') {
          steps {
            echo "The build number is odd"
          }
        }
      }
    }
  }
}
// Jenkinsfile
@Library('my-shared-library') _

evenOrOdd(currentBuild.getNumber())
```

Only entire `pipeline`s can be defined in shared libraries as of this time. This can only be done in `vars/*.groovy`, and only in a `call` method. Only one Declarative Pipeline can be executed in a single build, and if you attempt to execute a second one, your build will fail as a result.
目前，只能在共享库中定义整个`管道`。这只能在 `vars/*.groovy` 中完成，并且只能在 `call` 方法中完成。在单个构建中只能执行一个声明性管道，如果您尝试执行第二个声明性管道，您的构建将因此失败。

### Testing library pull request changes 测试库拉取请求更改

By adding `@Library('my-shared-library@pull/<your-pr-number>/head') _` at the top of a library consumer Jenkinsfile, you can test your pipeline library pull request changes *in situ* if your pipeline library is hosted on GitHub and the SCM configuration for the pipeline library uses GitHub.
通过在库使用者 Jenkinsfile 的顶部添加 `@Library('my-shared-library@pull/<your-pr-number>/head') _` ，如果您的管道库托管在 GitHub 上，并且管道库的 SCM 配置使用 GitHub，则可以*原位*测试管道库拉取请求更改。
 Refer to the pull request or merge request branch naming convention for  other providers like Assembla, Bitbucket, Gitea, GitLab, and Tuleap.
请参阅 Assembla、Bitbucket、Gitea、GitLab 和 Tuleap 等其他提供商的拉取请求或合并请求分支命名约定。

Take, for example, a change to the global ci.jenkins.io shared pipeline, which has its source code stored at [github.com/jenkins-infra/pipeline-library/](https://github.com/jenkins-infra/pipeline-library/).
例如，对全局 ci.jenkins.io 共享管道的更改，其源代码存储在 [github.com/jenkins-infra/pipeline-library/](https://github.com/jenkins-infra/pipeline-library/)。

Let’s say you’re writing a new feature and opened a pull request on the pipeline library, number `123`.
假设您正在编写一项新功能，并在管道库上打开了一个 `123` 号的拉取请求。

By opening a pull request on [the dedicated `jenkins-infra-test-plugin` test repository](https://github.com/jenkinsci/jenkins-infra-test-plugin/) with the following content, you’ll be able to check your changes on ci.jenkins.io:
通过在[专用的 `jenkins-infra-test-plugin` 测试存储库](https://github.com/jenkinsci/jenkins-infra-test-plugin/)上打开包含以下内容的拉取请求，您将能够在 ci.jenkins.io 上检查您的更改：

```
--- jenkins-infra-test-plugin/Jenkinsfile
+++ jenkins-infra-test-plugin/Jenkinsfile
@@ -1,3 +1,4 @@
+ @Library('pipeline-library@pull/123/head') _
  buildPlugin(
    useContainerAgent: true,
    configurations: [
      [platform: 'linux', jdk: 17],
      [platform: 'windows', jdk: 11],
  ])
```



------

[1](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnoteref_1). [en.wikipedia.org/wiki/Don't_repeat_yourself](https://en.wikipedia.org/wiki/Don't_repeat_yourself)

[2](https://www.jenkins.io/doc/book/pipeline/shared-libraries/#_footnoteref_2). [gist.github.com/rtyler/e5e57f075af381fce4ed3ae57aa1f0c2](https://gist.github.com/rtyler/e5e57f075af381fce4ed3ae57aa1f0c2)

------

# Pipeline Development Tools  管道开发工具

Table of Contents 目录

- Command-line Pipeline Linter
  命令行 Pipeline Linter
  - [Examples 例子](https://www.jenkins.io/doc/book/pipeline/development/#examples)
- [Blue Ocean Editor Blue Ocean 编辑器](https://www.jenkins.io/doc/book/pipeline/development/#blue-ocean-editor)
- "Replay" Pipeline Runs with Modifications
  “重放”修改后的管道运行
  - [Usage 用法](https://www.jenkins.io/doc/book/pipeline/development/#usage)
  - [Features 特征](https://www.jenkins.io/doc/book/pipeline/development/#features)
  - [Limitations 局限性](https://www.jenkins.io/doc/book/pipeline/development/#limitations)
- IDE Integrations IDE 集成
  - [Eclipse Jenkins Editor Eclipse Jenkins 编辑器](https://www.jenkins.io/doc/book/pipeline/development/#eclipse-jenkins-editor)
  - [VisualStudio Code Jenkins Pipeline Linter Connector
    VisualStudio Code Jenkins 管道 Linter 连接器](https://www.jenkins.io/doc/book/pipeline/development/#visualstudio-code-jenkins-pipeline-linter-connector)
  - [Neovim nvim-jenkinsfile-linter plugin
    Neovim nvim-jenkinsfile-linter 插件](https://www.jenkins.io/doc/book/pipeline/development/#neovim-nvim-jenkinsfile-linter-plugin)
  - [Atom linter-jenkins package
    Atom linter-jenkins 软件包](https://www.jenkins.io/doc/book/pipeline/development/#atom-linter-jenkins-package)
  - [Sublime Text Jenkinsfile package
    Sublime Text Jenkinsfile 软件包](https://www.jenkins.io/doc/book/pipeline/development/#sublime-text-jenkinsfile-package)
- [Pipeline Unit Testing Framework
  管道单元测试框架](https://www.jenkins.io/doc/book/pipeline/development/#unit-test)

Jenkins Pipeline includes [built-in documentation](https://www.jenkins.io/doc/book/pipeline/getting-started/#built-in-documentation) and the [Snippet Generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) which are key resources when developing Pipelines. They provide detailed help and information that is customized to the currently installed version of Jenkins and related plugins. In this section, we’ll discuss other tools and resources that may help with development of Jenkins Pipelines.
Jenkins Pipeline 包括[内置文档](https://www.jenkins.io/doc/book/pipeline/getting-started/#built-in-documentation)和[代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)，它们是开发 Pipelines 时的关键资源。它们提供针对当前安装的 Jenkins 版本和相关插件进行自定义的详细帮助和信息。在本节中，我们将讨论可能有助于 Jenkins Pipelines 开发的其他工具和资源。

## Command-line Pipeline Linter 命令行 Pipeline Linter

Jenkins can validate, or "[lint](https://en.wikipedia.org/wiki/Lint_(software))", a Declarative Pipeline from the command line before actually running it. This can be done using a Jenkins CLI command or by making an HTTP POST request with appropriate parameters. We recommended using the [SSH interface](https://www.jenkins.io/doc/book/managing/cli/#ssh) to run the linter. See the [Jenkins CLI documentation](https://www.jenkins.io/doc/book/managing/cli/) for details on how to properly configure Jenkins for secure command-line access.
Jenkins 可以在实际运行声明式管道之前从命令行验证或“[lint](https://en.wikipedia.org/wiki/Lint_(software))”声明式管道。这可以使用 Jenkins CLI 命令或通过使用适当参数发出 HTTP POST 请求来完成。我们建议使用 [SSH 接口](https://www.jenkins.io/doc/book/managing/cli/#ssh)来运行 linter。有关如何正确配置 Jenkins 以实现安全命令行访问的详细信息，请参阅 [Jenkins CLI 文档](https://www.jenkins.io/doc/book/managing/cli/)。

Linting via the CLI with SSH
使用 SSH 通过 CLI 进行 Linting

```
# ssh (Jenkins CLI)
# JENKINS_PORT=[sshd port on controller]
# JENKINS_HOST=[Jenkins controller hostname]
ssh -p $JENKINS_PORT $JENKINS_HOST declarative-linter < Jenkinsfile
```

Linting via HTTP POST using `curl`
使用 `curl` 通过 HTTP POST 进行 Linting

```
# curl (REST API)
# These instructions assume that the security realm of Jenkins is something other than "None" and you have an account.
# JENKINS_URL=[root URL of Jenkins controller]
# JENKINS_AUTH=[your Jenkins username and an API token in the following format: your_username:api_token]
curl -X POST --user "$JENKINS_AUTH" -F "jenkinsfile=<Jenkinsfile" "$JENKINS_URL/pipeline-model-converter/validate"
```

### Examples 例子

Below are two examples of the Pipeline Linter in action. This first example shows the output of the linter when it is passed an invalid `Jenkinsfile`, one that is missing part of the `agent` declaration.
以下是 Pipeline Linter 的两个示例。第一个示例显示了 linter 在传递无效的 `Jenkinsfile` 时的输出，该文件缺少`代理`声明的一部分。

Jenkinsfile Jenkinsfile 文件

```
pipeline {
  agent
  stages {
    stage ('Initialize') {
      steps {
        echo 'Placeholder.'
      }
    }
  }
}
```

Linter output for invalid Jenkinsfile
无效 Jenkinsfile 的 Linter 输出

```
# pass a Jenkinsfile that does not contain an "agent" section
ssh -p 8675 localhost declarative-linter < ./Jenkinsfile
Errors encountered validating Jenkinsfile:
WorkflowScript: 2: Not a valid section definition: "agent". Some extra configuration is required. @ line 2, column 3.
     agent
     ^

WorkflowScript: 1: Missing required section "agent" @ line 1, column 1.
   pipeline &#125;
   ^
```

In this second example, the `Jenkinsfile` has been updated to include the missing `any` on `agent`.  The linter now reports that the Pipeline is valid.
在第二个示例中，`Jenkinsfile` 已更新为包含缺少的 `any` on `agent`。Linter 现在报告 Pipeline 有效。

Jenkinsfile Jenkinsfile 文件

```
pipeline {
  agent any
  stages {
    stage ('Initialize') {
      steps {
        echo 'Placeholder.'
      }
    }
  }
}
```

Linter output for valid Jenkinsfile
有效 Jenkinsfile 的 Linter 输出

```
ssh -p 8675 localhost declarative-linter < ./Jenkinsfile
Jenkinsfile successfully validated.
```

## Blue Ocean Editor Blue Ocean 编辑器

The [Blue Ocean Pipeline Editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/) provides a [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) way to create Declarative Pipelines. The editor offers a structural view of all the stages, parallel branches, and steps in a Pipeline. The editor validates Pipeline changes as they are made, eliminating many errors before they are even committed. Behind the scenes it still generates Declarative Pipeline code.
[Blue Ocean Pipeline Editor](https://www.jenkins.io/doc/book/blueocean/pipeline-editor/) 提供了一种[所见即所得](https://en.wikipedia.org/wiki/WYSIWYG)的方式来创建声明式管道。编辑器提供了 Pipeline 中所有阶段、并行分支和步骤的结构视图。编辑器会在 Pipeline 更改时对其进行验证，从而在提交之前消除许多错误。在幕后，它仍然会生成声明性管道代码。

|      | Blue Ocean status 蓝海状态 Blue Ocean will not receive further functionality updates. Blue Ocean will continue to provide easy-to-use Pipeline visualization, but it will not be enhanced further. It will only receive selective updates for significant security issues or functional defects. Blue Ocean 将不会收到进一步的功能更新。Blue Ocean 将继续提供易于使用的 Pipeline 可视化，但不会进一步增强。它只会接收针对重大安全问题或功能缺陷的选择性更新。  The [Pipeline syntax snippet generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator) assists users as they define Pipeline steps with their arguments. It is the preferred tool for Jenkins Pipeline creation, as it provides  online help for the Pipeline steps available in your Jenkins controller. It uses the plugins installed on your Jenkins controller to generate the Pipeline syntax. Refer to the [Pipeline steps reference](https://www.jenkins.io/doc/pipeline/steps/) page for information on all available Pipeline steps. [Pipeline 语法代码段生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#snippet-generator)可帮助用户使用其参数定义 Pipeline 步骤。它是创建 Jenkins Pipeline 的首选工具，因为它为 Jenkins 控制器中可用的 Pipeline  步骤提供在线帮助。它使用安装在 Jenkins 控制器上的插件来生成 Pipeline 语法。请参阅 [Pipeline steps 参考](https://www.jenkins.io/doc/pipeline/steps/)页面 以了解有关所有可用 Pipeline 步骤的信息。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

## "Replay" Pipeline Runs with Modifications “重放”修改后的管道运行

Typically a Pipeline will be defined inside of the classic Jenkins web UI, or by committing to a `Jenkinsfile` in source control. Unfortunately, neither approach is ideal for rapid iteration, or prototyping, of a Pipeline. The "Replay" feature allows for quick modifications and execution of an existing Pipeline without changing the Pipeline configuration or creating a new commit.
通常，流水线将在经典 Jenkins Web UI 中定义，或者通过在源代码控制中提交到 `Jenkinsfile` 来定义。遗憾的是，这两种方法都不适合 Pipeline 的快速迭代或原型设计。“Replay” 功能允许快速修改和执行现有 Pipeline，而无需更改 Pipeline 配置或创建新提交。

### Usage 用法

To use the "Replay" feature:
要使用 “Replay” 功能：

1. Select a previously completed run in the build history.
   在构建历史记录中选择以前完成的运行。

   ![Previous Pipeline Run](https://www.jenkins.io/doc/book/resources/pipeline/replay-previous-run.png)

2. Click "Replay" in the left menu
   点击左侧菜单中的 “Replay”

   ![Replay Left-menu Button](https://www.jenkins.io/doc/book/resources/pipeline/replay-left-bar.png)

3. Make modifications and click "Run". In this example, we changed "ruby-2.3" to "ruby-2.4".
   进行修改并单击 “Run”。在此示例中，我们将 “ruby-2.3” 更改为 “ruby-2.4”。

   ![Replay Left-menu Button](https://www.jenkins.io/doc/book/resources/pipeline/replay-modified.png)

4. Check the results of changes
   检查更改的结果

Once you are satisfied with the changes, you can use Replay to view them again, copy them back to your Pipeline job or `Jenkinsfile`, and then commit them using your usual engineering processes.
对更改感到满意后，可以使用 Replay 再次查看它们，将它们复制回 Pipeline 作业或 `Jenkinsfile`，然后使用通常的工程流程提交它们。

### Features 特征

- **Can be called multiple times on the same run** - allows for easy parallel testing of different changes.
  **可以在同一运行中多次调用** - 允许对不同的更改进行轻松的并行测试。
- **Can also be called on Pipeline runs that are still in-progress** - As long as a Pipeline contained syntactically correct Groovy and was able to start, it can be Replayed.
  **也可以在仍在进行的 Pipeline 运行时调用** - 只要 Pipeline 包含语法正确的 Groovy 并且能够启动，就可以重放它。
- **Referenced Shared Library code is also modifiable** - If a Pipeline run references a [Shared Library](https://www.jenkins.io/doc/book/pipeline/shared-libraries/), the code from the shared library will also be shown and modifiable as part of the Replay page.
  **引用的共享库代码也是可修改**的 - 如果管道运行引用[共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)，则共享库中的代码也将作为 Replay 页面的一部分显示和修改。
- **Access Control via dedicated "Run / Replay" permission** - implied by "Job / Configure". If Pipeline is not configurable (e.g.  Branch Pipeline of a Multibranch) or "Job / Configure" is not granted,  users still can experiment with Pipeline Definition via Replay
  **通过专用的“运行/重放”权限进行访问控制** - “作业/配置”隐含。如果 Pipeline 不可配置（例如 Multibranch 的 Branch Pipeline）或未授予“Job / Configure”，用户仍然可以通过 Replay 试验 Pipeline Definition
- **Can be used for Re-run** - users lacking "Run / Replay" but who are granted "Job / Build" can still use Replay to run a build again with the same definition. **Note**: The label switches to "Rebuild" in that case. 

### Limitations 局限性

- **Pipeline runs with syntax errors cannot be replayed** - meaning their code cannot be viewed and any changes made in them cannot be retrieved. When using Replay for more significant modifications, save your changes to a file or editor outside of Jenkins before running them. See [JENKINS-37589](https://issues.jenkins.io/browse/JENKINS-37589) 
- **Replayed Pipeline behavior may differ from runs started by other methods** - For Pipelines that are not part of a Multi-branch Pipeline, the commit information may differ for the original run and the Replayed run. See [JENKINS-36453](https://issues.jenkins.io/browse/JENKINS-36453) 

## IDE Integrations IDE 集成

### Eclipse Jenkins Editor Eclipse Jenkins 编辑器

The `Jenkins Editor` Eclipse plugin can be found on [Eclipse Marketplace](https://marketplace.eclipse.org/content/jenkins-editor). This special text editor provides some features for defining pipelines e.g:
`Jenkins Editor` Eclipse 插件可以在 [Eclipse Marketplace](https://marketplace.eclipse.org/content/jenkins-editor) 上找到。这个特殊的文本编辑器提供了一些用于定义管道的功能，例如：

- Validate pipeline scripts by [Jenkins Linter Validation](https://www.jenkins.io/doc/book/pipeline/development/#linter). Failures are shown as eclipse markers
  通过 [Jenkins Linter 验证](https://www.jenkins.io/doc/book/pipeline/development/#linter)验证管道脚本。失败显示为日食标记
- An Outline with dedicated icons (for declarative Jenkins pipelines )
  带有专用图标的大纲（用于声明性 Jenkins 管道）
- Syntax / keyword highlighting
  语法/关键字高亮显示
- Groovy validation Groovy 验证

|      | The Jenkins Editor Plugin is a third-party tool that is not supported by the Jenkins Project.  Jenkins Editor Plugin 是 Jenkins 项目不支持的第三方工具。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### VisualStudio Code Jenkins Pipeline Linter Connector VisualStudio Code Jenkins 管道 Linter 连接器

The `Jenkins Pipeline Linter Connector` extension for [VisualStudio Code](https://code.visualstudio.com/) takes the file that you have currently opened, pushes it to your Jenkins Server and displays the validation result in VS Code.
[VisualStudio Code](https://code.visualstudio.com/) 的 `Jenkins Pipeline Linter Connector` 扩展采用您当前打开的文件，将其推送到 Jenkins 服务器，并在 VS Code 中显示验证结果。

You can find the extension from within the VS Code extension browser or at the following url: [marketplace.visualstudio.com/items?itemName=janjoerke.jenkins-pipeline-linter-connector](https://marketplace.visualstudio.com/items?itemName=janjoerke.jenkins-pipeline-linter-connector)
可以从 VS Code 扩展浏览器中或以下 URL 中找到扩展：[marketplace.visualstudio.com/items?itemName=janjoerke.jenkins-pipeline-linter-connector](https://marketplace.visualstudio.com/items?itemName=janjoerke.jenkins-pipeline-linter-connector)

The extension adds four settings entries to VS Code which select the Jenkins server you want to use for validation.
该扩展向 VS Code 添加了四个设置条目，用于选择要用于验证的 Jenkins 服务器。

- `jenkins.pipeline.linter.connector.url` is the endpoint at which your Jenkins Server expects the POST request,  containing your Jenkinsfile which you want to validate. Typically this  points to *[/pipeline-model-converter/validate](http:///pipeline-model-converter/validate)*.
   `jenkins.pipeline.linter.connector.url` 是 Jenkins 服务器需要 POST 请求的终端节点，其中包含要验证的 Jenkinsfile。通常，这指向 
- `jenkins.pipeline.linter.connector.user` allows you to specify your Jenkins username.
   `jenkins.pipeline.linter.connector.user` 允许您指定 Jenkins 用户名。
- `jenkins.pipeline.linter.connector.pass` allows you to specify your Jenkins password.
   `jenkins.pipeline.linter.connector.pass` 允许您指定 Jenkins 密码。
- `jenkins.pipeline.linter.connector.crumbUrl` has to be specified if your Jenkins Server has CRSF protection enabled. Typically this points to *[/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb](http:///crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb))*.
   `jenkins.pipeline.linter.connector.crumbUrl` 如果您的 Jenkins 服务器启用了 CRSF 保护，则必须指定。通常，这指向 

### Neovim nvim-jenkinsfile-linter plugin Neovim nvim-jenkinsfile-linter 插件

The [nvim-jenkinsfile-linter](https://github.com/ckipp01/nvim-jenkinsfile-linter) Neovim plugin allows you to validate a Jenkinsfile by using the Pipeline Linter API of your Jenkins controller and report any existing diagnostics in your editor.
[nvim-jenkinsfile-linter](https://github.com/ckipp01/nvim-jenkinsfile-linter) Neovim 插件允许您使用 Jenkins 控制器的 Pipeline Linter API 验证 Jenkinsfile，并在编辑器中报告任何现有诊断。

### Atom linter-jenkins package Atom linter-jenkins 软件包

The [linter-jenkins](https://atom.io/packages/linter-jenkins) Atom package allows you to validate a Jenkins file by using the Pipeline Linter API of a running Jenkins. You can install it directly from the Atom package manager. It needs also to install [Jenkinsfile language support in Atom](https://atom.io/packages/language-jenkinsfile)
[linter-jenkins](https://atom.io/packages/linter-jenkins) Atom 包允许您使用正在运行的 Jenkins 的 Pipeline Linter API 来验证 Jenkins 文件。您可以直接从 Atom 包管理器安装它。它还需要在 [Atom 中安装 Jenkinsfile 语言支持](https://atom.io/packages/language-jenkinsfile)

### Sublime Text Jenkinsfile package Sublime Text Jenkinsfile 软件包

The [Jenkinsfile](https://github.com/june07/sublime-Jenkinsfile) Sublime Text package allows you to validate a Jenkinsfile by using the Pipeline Linter API of a running Jenkins controller over a secure channel (SSH).  You can install it directly from the Sublime Text package manager.
[Jenkinsfile](https://github.com/june07/sublime-Jenkinsfile) Sublime Text 包允许您通过安全通道 （SSH） 使用正在运行的 Jenkins 控制器的 Pipeline Linter API 来验证 Jenkinsfile。您可以直接从 Sublime Text 包管理器安装它。

You can find the package from within the Sublime Text interface via the  Package Control package, at GitHub, or packagecontrol.io:
您可以通过 Package Control 包从 Sublime Text 界面中找到包，也可以在 GitHub 上找到 packagecontrol.io：

- https://github.com/june07/sublime-Jenkinsfile
- https://packagecontrol.io/packages/Jenkinsfile

## Pipeline Unit Testing Framework 管道单元测试框架

The [Pipeline Unit Testing Framework](https://github.com/jenkinsci/JenkinsPipelineUnit) allows you to [unit test](https://en.wikipedia.org/wiki/Unit_testing) Pipelines and [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) before running them in full. It provides a mock execution environment where real Pipeline steps are replaced with mock objects that you can use to check for expected behavior. New and rough around the edges, but promising. The [README](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/master/README.md) for that project contains examples and usage instructions.
[Pipeline Unit Testing Framework](https://github.com/jenkinsci/JenkinsPipelineUnit) 允许您在完全运行 Pipelines 和 [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) 之前对其进行[单元测试](https://en.wikipedia.org/wiki/Unit_testing)。它提供了一个模拟执行环境，其中实际的 Pipeline 步骤被替换为可用于检查预期行为的模拟对象。新的和粗糙的边缘，但很有希望。该项目的 [README](https://github.com/jenkinsci/JenkinsPipelineUnit/blob/master/README.md) 包含示例和使用说明。

# Pipeline Syntax 管道语法

Table of Contents 目录

- Declarative Pipeline 声明式管道
  - [Limitations 局限性](https://www.jenkins.io/doc/book/pipeline/syntax/#limitations)
  - Sections 部分
    - [agent 代理](https://www.jenkins.io/doc/book/pipeline/syntax/#agent)
    - [post 发布](https://www.jenkins.io/doc/book/pipeline/syntax/#post)
    - [stages 阶段](https://www.jenkins.io/doc/book/pipeline/syntax/#stages)
    - [steps 步骤](https://www.jenkins.io/doc/book/pipeline/syntax/#steps)
  - Directives 指令
    - [environment 环境](https://www.jenkins.io/doc/book/pipeline/syntax/#environment)
    - [options 选项](https://www.jenkins.io/doc/book/pipeline/syntax/#options)
    - [parameters 参数](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters)
    - [triggers 触发器](https://www.jenkins.io/doc/book/pipeline/syntax/#triggers)
    - [Jenkins cron syntax Jenkins cron 语法](https://www.jenkins.io/doc/book/pipeline/syntax/#cron-syntax)
    - [stage 阶段](https://www.jenkins.io/doc/book/pipeline/syntax/#stage)
    - [tools 工具](https://www.jenkins.io/doc/book/pipeline/syntax/#tools)
    - [input 输入](https://www.jenkins.io/doc/book/pipeline/syntax/#input)
    - [when 什么时候](https://www.jenkins.io/doc/book/pipeline/syntax/#when)
  - [Sequential Stages 顺序阶段](https://www.jenkins.io/doc/book/pipeline/syntax/#sequential-stages)
  - [Parallel 平行](https://www.jenkins.io/doc/book/pipeline/syntax/#parallel)
  - Matrix 矩阵
    - [axes 轴](https://www.jenkins.io/doc/book/pipeline/syntax/#matrix-axes)
    - [stages 阶段](https://www.jenkins.io/doc/book/pipeline/syntax/#matrix-stages)
    - [excludes (optional) excludes（可选）](https://www.jenkins.io/doc/book/pipeline/syntax/#matrix-excludes)
    - [Matrix cell-level directives (optional)
      矩阵单元格级指令（可选）](https://www.jenkins.io/doc/book/pipeline/syntax/#matrix-cell-directives)
  - Steps 步骤
    - [script 脚本](https://www.jenkins.io/doc/book/pipeline/syntax/#script)
- Scripted Pipeline 脚本化管道
  - [Flow Control 流控制](https://www.jenkins.io/doc/book/pipeline/syntax/#flow-control)
  - [Steps 步骤](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-steps)
  - [Differences from plain Groovy
    与普通 Groovy 的区别](https://www.jenkins.io/doc/book/pipeline/syntax/#differences-from-plain-groovy)
- [Syntax Comparison 语法比较](https://www.jenkins.io/doc/book/pipeline/syntax/#compare)

This section builds on the information introduced in [Getting started with Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started) and should be treated solely as a reference. For more information on how to use Pipeline syntax in practical examples, refer to the [Using a Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile) section of this chapter. As of version 2.5 of the Pipeline plugin, Pipeline supports two discrete syntaxes which are detailed below. For the pros and cons of each, refer to the [Syntax Comparison](https://www.jenkins.io/doc/book/pipeline/syntax/#compare).
本部分基于 [Pipeline 入门](https://www.jenkins.io/doc/book/pipeline/getting-started)中介绍的信息，应仅作为参考。有关如何在实际示例中使用 Pipeline 语法的更多信息，请参阅[本章的 使用 Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile) 部分。从 Pipeline 插件的 2.5 版本开始，Pipeline 支持两种离散的语法，详情如下。有关每种方法的优缺点，请参阅[语法比较](https://www.jenkins.io/doc/book/pipeline/syntax/#compare)。

As discussed at the [start of this chapter](https://www.jenkins.io/doc/book/pipeline/), the most fundamental part of a Pipeline is the "step". Basically, steps tell Jenkins *what* to do and serve as the basic building block for both Declarative and Scripted Pipeline syntax.
正如[本章开头](https://www.jenkins.io/doc/book/pipeline/)所讨论的，Pipeline 最基本的部分是 “step”。基本上，步骤告诉 *Jenkins 该做什么*，并作为声明式和脚本化管道语法的基本构建块。

For an overview of available steps, please refer to the [Pipeline Steps reference](https://www.jenkins.io/doc/pipeline/steps) which contains a comprehensive list of steps built into Pipeline as well as steps provided by plugins.
有关可用步骤的概述，请参阅 [Pipeline 步骤参考](https://www.jenkins.io/doc/pipeline/steps)，其中包含 Pipeline 中内置步骤的完整列表以及插件提供的步骤。

## Declarative Pipeline 声明式管道

Declarative Pipeline presents a more simplified and opinionated syntax on top of the Pipeline sub-systems. In order to use them, install the [Pipeline: Declarative Plugin](https://plugins.jenkins.io/pipeline-model-definition).
Declarative Pipeline 在 Pipeline 子系统之上提供了一种更加简化和固执己见的语法。为了使用它们，请安装 [Pipeline： Declarative Plugin](https://plugins.jenkins.io/pipeline-model-definition)。

All valid Declarative Pipelines must be enclosed within a `pipeline` block, for example:
所有有效的声明性 Pipelines 都必须包含在 `pipeline` 块中，例如：

```
pipeline {
    /* insert Declarative Pipeline here */
}
```

The basic statements and expressions which are valid in Declarative Pipeline follow the same rules as [Groovy’s syntax](http://groovy-lang.org/syntax.html) with the following exceptions:
在 Declarative Pipeline 中有效的基本语句和表达式遵循与 [Groovy 的语法](http://groovy-lang.org/syntax.html)相同的规则，但以下情况除外：

- The top-level of the Pipeline must be a *block*, specifically: `pipeline { }`.
  Pipeline 的顶层必须是一个*区块*，具体来说就是：`pipeline { }`。
- No semicolons as statement separators. Each statement has to be on its own line.
  没有分号作为语句分隔符。每个语句都必须在自己的行上。
- Blocks must only consist of [Sections](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-sections), [Directives](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-directives), [Steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps), or assignment statements.
  块只能由 [Sections](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-sections)、[Directives](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-directives)、[Steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps) 或 assignment 语句组成。
- A property reference statement is treated as a no-argument method invocation. So, for example, `input` is treated as `input()`.
  属性引用语句被视为无参数方法调用。因此，例如，`input` 被视为 `input（）。`

You can use the [Declarative Directive Generator](https://www.jenkins.io/doc/book/pipeline/getting-started/#directive-generator) to help you get started with configuring the directives and sections in your Declarative Pipeline.
您可以使用[声明性指令生成器](https://www.jenkins.io/doc/book/pipeline/getting-started/#directive-generator)来帮助您开始在声明性管道中配置指令和部分。

### Limitations 局限性

There is currently an [open issue](https://issues.jenkins.io/browse/JENKINS-37984)  which limits the maximum size of the code within the `pipeline{}` block. This limitation does not apply to Scripted Pipelines.
目前存在一个[未解决](https://issues.jenkins.io/browse/JENKINS-37984)的问题，该问题限制了 `pipeline{}` 块中代码的最大大小。此限制不适用于脚本化管道。

### Sections 部分

Sections in Declarative Pipeline typically contain one or more [Directives](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-directives) or [Steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps).
Declarative Pipeline 中的部分通常包含一个或多个 [Directives](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-directives) 或 [Step](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps)。

#### agent 代理

The `agent` section specifies where the entire Pipeline, or a specific stage, will  execute in the Jenkins environment depending on where the `agent` section is placed. The section must be defined at the top-level inside the `pipeline` block, but stage-level usage is optional.
`agent` 部分指定整个 Pipeline 或特定阶段在 Jenkins 环境中的执行位置，具体取决于 `agent` 部分的放置位置。该部分必须在 `pipeline` 块内的 top-level 定义，但 stage-level 用法是可选的。

| Required 必填   | Yes 是的                                                     |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | [Described below 如下所述](https://www.jenkins.io/doc/book/pipeline/syntax/#agent-parameters) |
| Allowed 允许    | In the top-level `pipeline` block and each `stage` block. 在 top-level `pipeline` 块和 each `stage` 块中。 |

##### Differences between top level agents and stage level agents 顶级代理和阶段级代理之间的差异

There are some nuances when adding an agent to the top level or a stage level when the `options` directive is applied. Check the section [options](https://www.jenkins.io/doc/book/pipeline/syntax/#options) for more information.
在应用 `options` 指令时，将代理添加到顶层或阶段级别时，存在一些细微差别。有关更多信息，请查看 [options](https://www.jenkins.io/doc/book/pipeline/syntax/#options) 部分。

###### Top Level Agents 顶级代理

In `agents` declared at the top level of a Pipeline, an agent is allocated and then the `timeout` option is applied. The time to allocate the agent **is not included** in the limit set by the `timeout` option.
在 Pipeline 顶层声明的`代理`中，分配一个代理，然后应用 `timeout` 选项。分配代理的时间**不包括**在 `timeout` 选项设置的限制中。

```
pipeline {
    agent any
    options {
        // Timeout counter starts AFTER agent is allocated
        timeout(time: 1, unit: 'SECONDS')
    }
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

###### Stage Agents 舞台代理

In `agents` declared within a stage, the options are invoked **before** allocating the `agent` and **before** checking any `when` conditions. In this case, when using `timeout`, it is applied **before** the `agent` is allocated. The time to allocate the agent **is included** in the limit set by the `timeout` option.
在阶段中声明的`代理`中，在分配`代理`**之前**和检查任何 `when` 条件**之前**调用选项。在这种情况下，使用 `timeout` 时，它会在分配`代理`**之前**应用。分配代理的时间**包含在** `timeout` 选项设置的限制中。

```
pipeline {
    agent none
    stages {
        stage('Example') {
            agent any
            options {
                // Timeout counter starts BEFORE agent is allocated
                timeout(time: 1, unit: 'SECONDS')
            }
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

This timeout will include the agent provisioning time. Because the timeout includes the agent provisioning time, the Pipeline may fail in cases where agent allocation is delayed.
此超时将包括代理预置时间。由于超时包括代理配置时间，因此在代理分配延迟的情况下，管道可能会失败。

##### Parameters 参数

In order to support the wide variety of use-cases Pipeline authors may have, the `agent` section supports a few different types of parameters. These parameters can be applied at the top-level of the `pipeline` block, or within each `stage` directive.
为了支持 Pipeline 作者可能具有的各种用例，`agent` 部分支持几种不同类型的参数。这些参数可以应用于 `pipeline` block 的顶层，也可以应用于每个 `stage` 指令中。

- any 任何

  Execute the Pipeline, or stage, on any available agent. For example: `agent any` 在任何可用的代理上执行 Pipeline 或 stage。例如：`agent any`

- none 没有

  When applied at the top-level of the `pipeline` block no global agent will be allocated for the entire Pipeline run and each `stage` section will need to contain its own `agent` section. For example: `agent none` 在`管道`块的顶层应用时，不会为整个管道运行分配全局代理，并且每个`阶段`部分都需要包含自己的`代理`部分。例如：`agent none`

- label 标签

  Execute the Pipeline, or stage, on an agent available in the Jenkins environment with the provided label. For example: `agent { label 'my-defined-label' }` 在 Jenkins 环境中可用的代理上执行管道或阶段，并提供标签。例如： `agent { label 'my-defined-label' }`  Label conditions can also be used: For example: `agent { label 'my-label1 && my-label2' }` or `agent { label 'my-label1 || my-label2' }` 也可以使用标签条件：例如： `agent { label 'my-label1 && my-label2' }` 或 `agent { label 'my-label1 || my-label2' }` 

- node 节点

  `agent { node { label 'labelName' } }` behaves the same as `agent { label 'labelName' }`, but `node` allows for additional options (such as `customWorkspace`).  `agent { node { label 'labelName' } }` 的行为与 `agent { label 'labelName' }` 相同，但 `node` 允许其他选项（例如 `customWorkspace`）。

- docker 码头工人

  Execute the Pipeline, or stage, with the given container which will be dynamically provisioned on a [node](https://www.jenkins.io/doc/book/glossary/#node) pre-configured to accept Docker-based Pipelines, or on a node matching the optionally defined `label` parameter. `docker` also optionally accepts an `args` parameter which may contain arguments to pass directly to a `docker run` invocation, and an `alwaysPull` option, which will force a `docker pull` even if the image name is already present. For example: `agent { docker 'maven:3.9.3-eclipse-temurin-17' }` or 使用给定的容器执行管道或阶段，该容器将在预先配置为接受基于 Docker 的管道的[节点上](https://www.jenkins.io/doc/book/glossary/#node)动态配置，或在与可选定义的 `label` 参数匹配的节点上动态配置。`docker` 还可以选择接受一个 `args` 参数，该参数可能包含直接传递给 `docker run` 调用的参数，以及一个 `alwaysPull` 选项，即使镜像名称已经存在，该选项也会强制 `docker pull`。例如： `agent { docker 'maven:3.9.3-eclipse-temurin-17' }` 或  `agent {    docker {        image 'maven:3.9.3-eclipse-temurin-17'        label 'my-defined-label'        args  '-v /tmp:/tmp'    } }`

`docker` also optionally accepts a `registryUrl` and `registryCredentialsId` parameters which will help to specify the Docker Registry to use and its credentials. The parameter `registryCredentialsId` could be used alone for private repositories within the docker hub. For example:
`docker` 还可以选择接受 `registryUrl` 和 `registryCredentialsId` 参数，这将有助于指定要使用的 Docker 注册表及其凭据。参数 `registryCredentialsId` 可以单独用于 Docker Hub 内的私有存储库。例如：

```
agent {
    docker {
        image 'myregistry.com/node'
        label 'my-defined-label'
        registryUrl 'https://myregistry.com/'
        registryCredentialsId 'myPredefinedCredentialsInJenkins'
    }
}
```

dockerfile

Execute the Pipeline, or stage, with a container built from a `Dockerfile` contained in the source repository. In order to use this option, the `Jenkinsfile` must be loaded from either a **Multibranch Pipeline** or a **Pipeline from SCM**. Conventionally this is the `Dockerfile` in the root of the source repository: `agent { dockerfile true }`. If building a `Dockerfile` in another directory, use the `dir` option: `agent { dockerfile { dir 'someSubDir' } }`. If your `Dockerfile` has another name, you can specify the file name with the `filename` option. You can pass additional arguments to the `docker build …` command with the `additionalBuildArgs` option, like `agent { dockerfile { additionalBuildArgs '--build-arg foo=bar' } }`. For example, a repository with the file `build/Dockerfile.build`, expecting a build argument `version`:
使用从源存储库中包含的 `Dockerfile` 构建的容器执行 Pipeline 或阶段。为了使用此选项，必须从 **Multibranch Pipeline** 或 **Pipeline from SCM** 加载 `Jenkinsfile`。通常，这是源存储库根目录中的 `Dockerfile`：`agent { dockerfile true }`。如果在另一个目录中构建 `Dockerfile`，请使用 `dir` 选项： `agent { dockerfile { dir 'someSubDir' } }` 。如果您的 `Dockerfile` 具有其他名称，则可以使用 `filename` 选项指定文件名。您可以使用 `additionalBuildArgs` 选项将其他参数传递给 `docker build ...` 命令，例如 `agent { dockerfile { additionalBuildArgs '--build-arg foo=bar' } }` .例如，具有文件 `build/Dockerfile.build` 的存储库，需要 build 参数`版本`：

```
agent {
    // Equivalent to "docker build -f Dockerfile.build --build-arg version=1.0.2 ./build/
    dockerfile {
        filename 'Dockerfile.build'
        dir 'build'
        label 'my-defined-label'
        additionalBuildArgs  '--build-arg version=1.0.2'
        args '-v /tmp:/tmp'
    }
}
```

`dockerfile` also optionally accepts a `registryUrl` and `registryCredentialsId` parameters which will help to specify the Docker Registry to use and its credentials. For example:
`dockerfile` 还可以选择接受 `registryUrl` 和 `registryCredentialsId` 参数，这将有助于指定要使用的 Docker 注册表及其凭据。例如：

```
agent {
    dockerfile {
        filename 'Dockerfile.build'
        dir 'build'
        label 'my-defined-label'
        registryUrl 'https://myregistry.com/'
        registryCredentialsId 'myPredefinedCredentialsInJenkins'
    }
}
```

kubernetes Kubernetes 的

Execute the Pipeline, or stage, inside a pod deployed on a Kubernetes cluster. In order to use this option, the `Jenkinsfile` must be loaded from either a **Multibranch Pipeline** or a **Pipeline from SCM**. The Pod template is defined inside the kubernetes { } block. For example, if you want a pod with a Kaniko container inside it, you would define it as follows:
在 Kubernetes 集群上部署的 Pod 中执行 Pipeline 或阶段。为了使用此选项，必须从 **Multibranch Pipeline** 或 **Pipeline from SCM** 加载 `Jenkinsfile`。Pod 模板定义在 kubernetes { } 块中。例如，如果你想要一个 Pod 中有一个 Kaniko 容器，你可以按如下方式定义它：

```
agent {
    kubernetes {
        defaultContainer 'kaniko'
        yaml '''
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
      - name: aws-secret
        mountPath: /root/.aws/
      - name: docker-registry-config
        mountPath: /kaniko/.docker
  volumes:
    - name: aws-secret
      secret:
        secretName: aws-secret
    - name: docker-registry-config
      configMap:
        name: docker-registry-config
'''
   }
```

You will need to create a secret `aws-secret` for Kaniko to be able to authenticate with ECR. This secret should contain the contents of `~/.aws/credentials`. The other volume is a ConfigMap which should contain the endpoint of your ECR registry. For example:
您需要为 Kaniko 创建一个密钥 `aws-secret` 才能使用 ECR 进行身份验证。此密钥应包含 `~/.aws/credentials` 的内容。另一个卷是 ConfigMap，它应该包含 ECR 注册表的终端节点。例如：

```
{
      "credHelpers": {
        "<your-aws-account-id>.dkr.ecr.eu-central-1.amazonaws.com": "ecr-login"
      }
}
```



##### Common Options 常用选项

These are a few options that can be applied to two or more `agent` implementations. They are not required unless explicitly stated.
这些是可应用于两个或多个 `agent` implementations 的几个选项。除非明确说明，否则它们不是必需的。

- label 标签

  A string. The label or label condition on which to run the Pipeline or individual `stage`. 一个字符串。运行 Pipeline 或单个`阶段`的标签或标签条件。 This option is valid for `node`, `docker`, and `dockerfile`, and is required for `node`. 此选项对 `node`、`docker` 和 `dockerfile` 有效，并且对于 `node` 是必需的。

- customWorkspace 自定义工作区

  A string. Run the Pipeline or individual `stage` this `agent` is applied to within this custom workspace, rather than the default. It can be either a relative path, in which case the custom workspace  will be under the workspace root on the node, or an absolute path. For example: 一个字符串。在此自定义工作区中运行 Pipeline 或此`代理`应用于的单个阶段，而不是默认`阶段`。它可以是相对路径（在这种情况下，自定义工作区将位于节点上的工作区根目录下），也可以是绝对路径。例如：  `agent {    node {        label 'my-defined-label'        customWorkspace '/some/other/path'    } }`

- reuseNode

  A boolean, false by default. If true, run the container on the node specified at the top-level of the Pipeline, in the same workspace, rather than on a new node entirely. 布尔值，默认为 false。如果为 true，则在同一工作区中，在 Pipeline 顶层指定的节点上运行容器，而不是完全在新节点上运行容器。 This option is valid for `docker` and `dockerfile`, and only has an effect when used on an `agent` for an individual `stage`. 此选项对 `docker` 和 `dockerfile` 有效，并且仅在用于单个`阶段`的`代理`时有效。

- args 参数

  A string. Runtime arguments to pass to `docker run`. 一个字符串。要传递给 `docker run` 的运行时参数。 This option is valid for `docker` and `dockerfile`. 此选项对 `docker` 和 `dockerfile` 有效。

Example 1. Docker Agent, Declarative Pipeline
示例 1.Docker 代理、声明式管道

```
pipeline {
    agent { docker 'maven:3.9.3-eclipse-temurin-17' } 
    stages {
        stage('Example Build') {
            steps {
                sh 'mvn -B clean verify'
            }
        }
    }
}
```

|      | Execute all the steps defined in this Pipeline within a newly created container of the given name and tag (`maven:3.9.3-eclipse-temurin-17`). 在新创建的具有给定名称和标记 （ ） 的容器中执行此管道中定义的所有步骤 `maven:3.9.3-eclipse-temurin-17` 。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Example 2. Stage-level Agent Section
示例 2.阶段级 Agent 部分

```
pipeline {
    agent none 
    stages {
        stage('Example Build') {
            agent { docker 'maven:3.9.3-eclipse-temurin-17' } 
            steps {
                echo 'Hello, Maven'
                sh 'mvn --version'
            }
        }
        stage('Example Test') {
            agent { docker 'openjdk:17-jre' } 
            steps {
                echo 'Hello, JDK'
                sh 'java -version'
            }
        }
    }
}
```

|      | Defining `agent none` at the top-level of the Pipeline ensures that [an Executor](https://www.jenkins.io/doc/book/glossary/#executor) will not be assigned unnecessarily. Using `agent none` also forces each `stage` section to contain its own `agent` section. 在 Pipeline 的顶层定义 `agent none` 可确保不会不必要地分配 [Executor](https://www.jenkins.io/doc/book/glossary/#executor)。使用 `agent none` 还会强制每个 `stage` 部分包含其自己的 `agent` 部分。 |
| ---- | ------------------------------------------------------------ |
|      | Execute the steps in this stage in a newly created container using this image. 使用此映像在新创建的容器中执行此阶段中的步骤。 |
|      | Execute the steps in this stage in a newly created container using a different image from the previous stage. 使用与上一阶段不同的映像在新创建的容器中执行此阶段中的步骤。 |

#### post 发布

The `post` section defines one or more additional [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps) that are run upon the completion of a Pipeline’s or stage’s run (depending on the location of the `post` section within the Pipeline). `post` can support any of the following [post-condition](https://www.jenkins.io/doc/book/pipeline/syntax/#post-conditions) blocks: `always`, `changed`, `fixed`, `regression`, `aborted`, `failure`, `success`, `unstable`, `unsuccessful`, and `cleanup`. These condition blocks allow the execution of steps inside each  condition depending on the completion status of the Pipeline or stage. The condition blocks are executed in the order shown below.
`post` 部分定义在管道或阶段的运行完成时运行的一个或多个附加[步骤](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps)（取决于 `post` 部分在管道中的位置）。`POST` 可以支持以下任何[后置条件](https://www.jenkins.io/doc/book/pipeline/syntax/#post-conditions)块：`always`、`changed`、`fixed`、`regression`、`aborted`、`failure`、`success`、`unstable`、`unsuccessful` 和 `cleanup`。这些条件块允许根据 Pipeline 或阶段的完成状态在每个条件中执行步骤。条件块按如下所示的顺序执行。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | In the top-level `pipeline` block and each `stage` block. 在 top-level `pipeline` 块和 each `stage` 块中。 |

##### Conditions 条件

- `always` `总是`

  Run the steps in the `post` section regardless of the completion status of the Pipeline’s or stage’s run. 运行 `post` 部分中的步骤，而不管管道或阶段的运行处于完成状态。

- `changed` `改变`

  Only run the steps in `post` if the current Pipeline’s run has a different completion status from its previous run. 仅当当前 Pipeline 的运行与其之前的运行具有不同的完成状态时，才在 `post` 中运行步骤。

- `fixed` `固定`

  Only run the steps in `post` if the current Pipeline’s run is successful and the previous run failed or was unstable. 仅当当前 Pipeline 的运行成功且上一次运行失败或不稳定时，才在 `post` 中运行步骤。

- `regression` `回归`

  Only run the steps in `post` if the current Pipeline’s or status is failure, unstable, or aborted and the previous run was successful. 仅当当前 Pipeline 的 or 状态为 failure、unstable 或 aborted 并且上一次运行成功时，才在 `post` 中运行步骤。

- `aborted` `中止`

  Only run the steps in `post` if the current Pipeline’s run has an "aborted" status, usually due to the Pipeline being manually aborted. This is typically denoted by gray in the web UI. 仅当当前 Pipeline 的运行处于 “aborted” 状态时（通常是由于 Pipeline 被手动中止），才在 `post` 中运行这些步骤。这在 Web UI 中通常用灰色表示。

- `failure` `失败`

  Only run the steps in `post` if the current Pipeline’s or stage’s run has a "failed" status, typically denoted by red in the web UI. 仅当当前管道或阶段的运行具有“失败”状态（在 Web UI 中通常用红色表示）时，才在`后期`运行步骤。

- `success` `成功`

  Only run the steps in `post` if the current Pipeline’s or stage’s run has a "success" status, typically denoted by blue or green in the web UI. 仅当当前管道或阶段的运行具有“成功”状态（在 Web UI 中通常用蓝色或绿色表示）时，才在`后期`运行步骤。

- `unstable` `稳定`

  Only run the steps in `post` if the current Pipeline’s run has an "unstable" status, usually caused by test failures, code violations, etc. This is typically denoted by yellow in the web UI. 仅当当前 Pipeline 的运行处于 “unstable” 状态（通常由测试失败、代码违规等引起）时，才在 `post` 中运行这些步骤。这在 Web UI 中通常用黄色表示。

- `unsuccessful` `不成功`

  Only run the steps in `post` if the current Pipeline’s or stage’s run has not a "success" status. This is typically denoted in the web UI depending on the status  previously mentioned (for stages this may fire if the build itself is  unstable). 仅当当前 Pipeline 或阶段的运行没有“成功”状态时，才在 `post` 中运行步骤。这通常在 Web UI 中表示，具体取决于前面提到的状态（对于阶段，如果构建本身不稳定，则可能会触发此状态）。

- `cleanup` `清理`

  Run the steps in this `post` condition after every other `post` condition has been evaluated, regardless of the Pipeline or stage’s status. 在评估所有其他 `POST` 条件后，运行此 `POST` 条件中的步骤，而不管 Pipeline 或 stage 的状态如何。

Example 3. Post Section, Declarative Pipeline
例 3.Post 部分，声明式管道

```
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
    post { 
        always { 
            echo 'I will always say Hello again!'
        }
    }
}
```

|      | Conventionally, the `post` section should be placed at the end of the Pipeline. 通常，`post` 部分应放置在 Pipeline 的末尾。 |
| ---- | ------------------------------------------------------------ |
|      | [Post-condition](https://www.jenkins.io/doc/book/pipeline/syntax/#post-conditions) blocks contain [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps) the same as the [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#steps) section. [后置条件](https://www.jenkins.io/doc/book/pipeline/syntax/#post-conditions)块包含与 [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#steps) 部分相同的[步骤](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps)。 |

#### stages 阶段

Containing a sequence of one or more [stage](https://www.jenkins.io/doc/book/pipeline/syntax/#stage) directives, the `stages` section is where the bulk of the "work" described by a Pipeline will be located. At a minimum, it is recommended that `stages` contain at least one [stage](https://www.jenkins.io/doc/book/pipeline/syntax/#stage) directive for each discrete part of the continuous delivery process, such as Build, Test, and Deploy.
`stages` 部分包含一个或多个 [stage](https://www.jenkins.io/doc/book/pipeline/syntax/#stage) 指令的序列，是 Pipeline 描述的大部分 “work” 所在的位置。对于持续交付过程的每个离散部分，建议 `stages` 至少包含一个 [stage](https://www.jenkins.io/doc/book/pipeline/syntax/#stage) 指令，例如 Build、Test 和 Deploy。

| Required 必填   | Yes 是的                                                     |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Inside the `pipeline` block, or within a `stage`. 在 `pipeline` block 内部，或在 `stage` 中。 |

Example 4. Stages, Declarative Pipeline
示例 4.阶段、声明式管道

```
pipeline {
    agent any
    stages { 
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

|      | The `stages` section will typically follow the directives such as `agent`, `options`, etc. `阶段`部分通常遵循 `agent`、`options` 等指令。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

#### steps 步骤

The `steps` section defines a series of one or more [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps) to be executed in a given `stage` directive.
`steps` 部分定义要在给定 `stage` 指令中执行的一系列一个或多个[步骤](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps)。

| Required        | Yes                                              |
| --------------- | ------------------------------------------------ |
| Parameters 参数 | *None 没有*                                      |
| Allowed 允许    | Inside each `stage` block. 在每个 `stage` 块内。 |

Example 5. Single Step, Declarative Pipeline
例 5.单步声明式管道

```
pipeline {
    agent any
    stages {
        stage('Example') {
            steps { 
                echo 'Hello World'
            }
        }
    }
}
```

|      | The `steps` section must contain one or more steps. `steps` 部分必须包含一个或多个步骤。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Directives 指令

#### environment 环境

The `environment` directive specifies a sequence of key-value pairs which will be defined as environment variables for all steps, or stage-specific steps,  depending on where the `environment` directive is located within the Pipeline.
`environment` 指令指定一系列键值对，这些键值对将被定义为所有步骤或特定于阶段的步骤的环境变量，具体取决于 `environment` 指令在 Pipeline 中的位置。

This directive supports a special helper method `credentials()` which can be used to access pre-defined Credentials by their identifier in the Jenkins environment.
该指令支持一个特殊的辅助方法 `credentials（），`该方法可用于在 Jenkins 环境中通过其标识符访问预定义的 Credentials。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Inside the `pipeline` block, or within `stage` directives. 在 `pipeline` 块中，或者在 `stage` 指令中。 |

##### Supported Credentials Type 支持的凭证类型

- Secret Text 秘密文本

  The environment variable specified will be set to the Secret Text content. 指定的环境变量将设置为 Secret Text 内容。

- Secret File Secret 文件

  The environment variable specified will be set to the location of the File file that is temporarily created. 指定的环境变量将设置为临时创建的 File 文件的位置。

- Username and password 用户名和密码

  The environment variable specified will be set to `username:password` and two additional environment variables will be automatically defined: `MYVARNAME_USR` and `MYVARNAME_PSW` respectively. 指定的环境变量将设置为 `username：password`，并将自动定义两个额外的环境变量：`分别为 MYVARNAME_USR` 和 `MYVARNAME_PSW`。

- SSH with Private Key 使用私钥的 SSH

  The environment variable specified will be set to the location of the SSH  key file that is temporarily created and two additional environment  variables will be automatically defined: `MYVARNAME_USR` and `MYVARNAME_PSW` (holding the passphrase). 指定的环境变量将设置为临时创建的 SSH 密钥文件的位置，并将自动定义两个额外的环境变量：`MYVARNAME_USR` 和 `MYVARNAME_PSW`（保存密码）。

|      | Unsupported credentials type causes the pipeline to fail with the message: `org.jenkinsci.plugins.credentialsbinding.impl.CredentialNotFoundException: No suitable binding handler could be found for type  <unsupportedType>.` 不支持的凭据类型会导致管道失败，并显示以下消息： `org.jenkinsci.plugins.credentialsbinding.impl.CredentialNotFoundException: No suitable binding handler could be found for type  <unsupportedType>.` |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Example 6. Secret Text Credentials, Declarative Pipeline
例 6.秘密文本凭据、声明性管道

```
pipeline {
    agent any
    environment { 
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment { 
                AN_ACCESS_KEY = credentials('my-predefined-secret-text') 
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```

|      | An `environment` directive used in the top-level `pipeline` block will apply to all steps within the Pipeline. 顶级 `pipeline` 块中使用的 `environment` 指令将应用于 Pipeline 中的所有步骤。 |
| ---- | ------------------------------------------------------------ |
|      | An `environment` directive defined within a `stage` will only apply the given environment variables to steps within the `stage`. `在阶段`中定义的`环境`指令将仅将给定的环境变量应用于`阶段`中的步骤。 |
|      | The `environment` block has a helper method `credentials()` defined which can be used to access pre-defined Credentials by their identifier in the Jenkins environment. `环境`块定义了一个辅助方法 `credentials（），`可用于在 Jenkins 环境中通过其标识符访问预定义的 Credentials。 |

Example 7. Username and Password Credentials
例 7.用户名和密码凭证

```
pipeline {
    agent any
    stages {
        stage('Example Username/Password') {
            environment {
                SERVICE_CREDS = credentials('my-predefined-username-password')
            }
            steps {
                sh 'echo "Service user is $SERVICE_CREDS_USR"'
                sh 'echo "Service password is $SERVICE_CREDS_PSW"'
                sh 'curl -u $SERVICE_CREDS https://myservice.example.com'
            }
        }
        stage('Example SSH Username with private key') {
            environment {
                SSH_CREDS = credentials('my-predefined-ssh-creds')
            }
            steps {
                sh 'echo "SSH private key is located at $SSH_CREDS"'
                sh 'echo "SSH user is $SSH_CREDS_USR"'
                sh 'echo "SSH passphrase is $SSH_CREDS_PSW"'
            }
        }
    }
}
```

#### options 选项

The `options` directive allows configuring Pipeline-specific options from within the Pipeline itself. Pipeline provides a number of these options, such as `buildDiscarder`, but they may also be provided by plugins, such as `timestamps`.
`options` 指令允许从 Pipeline 本身中配置特定于 Pipeline 的选项。Pipeline 提供了许多这样的选项，例如 `buildDiscarder`，但它们也可能由插件提供，例如`时间戳`。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Inside the `pipeline` block, or (with certain limitations) within `stage` directives. 在 `pipeline` 块中，或者 （有一定的限制） `在 stage` 指令中。 |

##### Available Options 可用选项

- buildDiscarder 构建丢弃器

  Persist artifacts and console output for the specific number of recent Pipeline runs. For example: `options { buildDiscarder(logRotator(numToKeepStr: '1')) }` 保留最近 Pipeline 运行的特定数量的构件和控制台输出。例如： `options { buildDiscarder(logRotator(numToKeepStr: '1')) }` 

- checkoutToSubdirectory

  Perform the automatic source control checkout in a subdirectory of the workspace. For example: `options { checkoutToSubdirectory('foo') }` 在工作区的子目录中执行自动源代码控制签出。例如： `options { checkoutToSubdirectory('foo') }` 

- disableConcurrentBuilds

  Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources, etc. For example: `options { disableConcurrentBuilds() }` to queue a build when there’s already an executing build of the Pipeline, or `options { disableConcurrentBuilds(abortPrevious: true) }` to abort the running one and start the new build. 不允许并发执行 Pipeline。可用于防止同时访问共享资源等。例如： `options { disableConcurrentBuilds() }` 当 Pipeline 已经有正在执行的构建时将构建排队，或者 `options { disableConcurrentBuilds(abortPrevious: true) }` 中止正在运行的构建并启动新的构建。

- disableResume 禁用恢复

  Do not allow the pipeline to resume if the controller restarts. For example: `options { disableResume() }` 如果控制器重新启动，则不允许管道恢复。例如： `options { disableResume（） }`

- newContainerPerStage newContainerPerStage 的

  Used with `docker` or `dockerfile` top-level agent. When specified, each stage will run in a new container deployed on the  same node, rather than all stages running in the same container  deployment. 与 `docker` 或 `dockerfile` 顶级代理一起使用。指定后，每个阶段都将在同一节点上部署的新容器中运行，而不是在同一容器部署中运行所有阶段。

- overrideIndexTriggers overrideIndex触发器

  Allows overriding default treatment of branch indexing triggers. If branch indexing triggers are disabled at the multibranch or organization label, `options { overrideIndexTriggers(true) }` will enable them for this job only. Otherwise, `options { overrideIndexTriggers(false) }` will disable branch indexing triggers for this job only. 允许覆盖分支索引触发器的默认处理方式。如果在 multibranch 或 organization 标签处禁用了分支索引触发器， `options { overrideIndexTriggers(true) }` 则将仅为此作业启用它们。否则， `options { overrideIndexTriggers(false) }` 将仅禁用此作业的分支索引触发器。

- preserveStashes preserve储藏处

  Preserve stashes from completed builds, for use with stage restarting. For example: `options { preserveStashes() }` to preserve the stashes from the most recent completed build, or `options { preserveStashes(buildCount: 5) }` to preserve the stashes from the five most recent completed builds. 保留已完成构建的储藏，以便与暂存重启一起使用。例如：`options { preserveStashes（） }` 来保留最近完成的构建的储藏，或 `options { preserveStashes(buildCount: 5) }` 保留最近完成的五个构建的储藏。

- quietPeriod quiet期间

  Set the quiet period, in seconds, for the Pipeline, overriding the global default. For example: `options { quietPeriod(30) }` 为 Pipeline 设置静默期（以秒为单位），覆盖全局默认值。例如：`options { quietPeriod（30） }`

- retry 重试

  On failure, retry the entire Pipeline the specified number of times. For example: `options { retry(3) }` 失败时，请重试整个 Pipeline 指定的次数。例如：`options { retry（3） }`

- skipDefaultCheckout

  Skip checking out code from source control by default in the `agent` directive. For example: `options { skipDefaultCheckout() }` 默认情况下，在 `agent` 指令中跳过从源代码管理中签出代码。例如： `options { skipDefaultCheckout() }` 

- skipStagesAfterUnstable

  Skip stages once the build status has gone to UNSTABLE. For example: `options { skipStagesAfterUnstable() }` 一旦构建状态变为 UNSTABLE，就跳过阶段。例如： `options { skipStagesAfterUnstable() }` 

- timeout 超时

  Set a timeout period for the Pipeline run, after which Jenkins should abort the Pipeline. For example: `options { timeout(time: 1, unit: 'HOURS') }` 为 Pipeline 运行设置超时时间，超过此时间 Jenkins 应中止 Pipeline。例如： `options { timeout(time: 1, unit: 'HOURS') }` 

Example 8. Global Timeout, Declarative Pipeline
例 8.全局超时、声明式管道

```
pipeline {
    agent any
    options {
        timeout(time: 1, unit: 'HOURS') 
    }
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

|      | Specifying a global execution timeout of one hour, after which Jenkins will abort the Pipeline run. 指定 1 小时的全局执行超时，超过此时间后，Jenkins 将中止 Pipeline 运行。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

- timestamps 时间 戳

  Prepend all console output generated by the Pipeline run with the time at which the line was emitted. For example: `options { timestamps() }` 在 Pipeline run 生成的所有控制台输出前面加上发出该行的时间。例如：`options { timestamps（） }`

- parallelsAlwaysFailFast

  Set failfast true for all subsequent parallel stages in the pipeline. For example: `options { parallelsAlwaysFailFast() }` 为管道中的所有后续并行阶段设置 failfast true。例如： `options { parallelsAlwaysFailFast() }` 

- disableRestartFromStage

  Completely disable option "Restart From Stage" visible in classic Jenkins UI and Blue Ocean as well. For example: `options { disableRestartFromStage() }`. This option can not be used inside of the stage. 完全禁用在经典 Jenkins UI 和 Blue Ocean 中可见的“Restart From Stage”选项。例如： `options { disableRestartFromStage() }` .此选项不能在舞台内部使用。

|      | A comprehensive list of available options is pending the completion of [help desk ticket 820](https://github.com/jenkins-infra/helpdesk/issues/820). 可用选项的完整列表正在等待[帮助台票证 820](https://github.com/jenkins-infra/helpdesk/issues/820) 完成。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

##### stage options 阶段选项

The `options` directive for a `stage` is similar to the `options` directive at the root of the Pipeline. However, the `stage`-level `options` can only contain steps like `retry`, `timeout`, or `timestamps`, or Declarative options that are relevant to a `stage`, like `skipDefaultCheckout`.
`stage` 的 `options` 指令类似于 Pipeline 根目录中的 `options` 指令。但是，`阶段`级`选项`只能包含`重试、``超时`或`时间戳`等步骤，或与`阶段`相关的声明性选项，如 `skipDefaultCheckout`。

Inside a `stage`, the steps in the `options` directive are invoked before entering the `agent` or checking any `when` conditions.
在`阶段`中，在进入`代理`或检查任何 `when` 条件之前调用 `options` 指令中的步骤。

###### Available Stage Options 可用的舞台选项

- skipDefaultCheckout

  Skip checking out code from source control by default in the `agent` directive. For example: `options { skipDefaultCheckout() }` 默认情况下，在 `agent` 指令中跳过从源代码管理中签出代码。例如： `options { skipDefaultCheckout() }` 

- timeout 超时

  Set a timeout period for this stage, after which Jenkins should abort the stage. For example: `options { timeout(time: 1, unit: 'HOURS') }` 为此阶段设置一个超时期限，超过此期限后 Jenkins 应中止该阶段。例如： `options { timeout(time: 1, unit: 'HOURS') }` 

Example 9. Stage Timeout, Declarative Pipeline
例 9.Stage Timeout、声明性管道

```
pipeline {
    agent any
    stages {
        stage('Example') {
            options {
                timeout(time: 1, unit: 'HOURS') 
            }
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

|      | Specifying an execution timeout of one hour for the `Example` stage, after which Jenkins will abort the Pipeline run. 为 `Example` 阶段指定 1 小时的执行超时，之后 Jenkins 将中止 Pipeline 运行。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

- retry 重试

  On failure, retry this stage the specified number of times. For example: `options { retry(3) }` 失败时，请重试此阶段指定的次数。例如：`options { retry（3） }`

- timestamps 时间 戳

  Prepend all console output generated during this stage with the time at which the line was emitted. For example: `options { timestamps() }` 在此阶段生成的所有控制台输出前面加上发出该行的时间。例如：`options { timestamps（） }`

#### parameters 参数

The `parameters` directive provides a list of parameters that a user should provide when triggering the Pipeline. The values for these user-specified parameters are made available to Pipeline steps via the `params` object, refer to the [Parameters, Declarative Pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters-example) for its specific usage.
`parameters` 指令提供用户在触发 Pipeline 时应提供的参数列表。这些用户指定的参数的值可通过 `params` 对象提供给 Pipeline 步骤，请参阅[参数、声明性管道](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters-example)了解其具体用法。

Each parameter has a *Name* and *Value*, depending on the parameter type. This information is exported as environment variables when the build  starts, allowing subsequent parts of the build configuration to access  those values. For example, use the `${PARAMETER_NAME}` syntax with POSIX shells like `bash` and `ksh`, the `${Env:PARAMETER_NAME}` syntax with PowerShell, or the `%PARAMETER_NAME%` syntax with Windows `cmd.exe`.
每个参数都有一个 *Name* 和 *Value*，具体取决于参数类型。当构建开始时，此信息将导出为环境变量，从而允许构建配置的后续部分访问这些值。例如，将 `${PARAMETER_NAME}` 语法用于 POSIX shell（如 `bash` 和 `ksh`），将 `${Env：PARAMETER_NAME}` 语法用于 PowerShell，或者将 `%PARAMETER_NAME%` 语法用于 Windows `cmd.exe`。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Only once, inside the `pipeline` block. 只有一次，在 `pipeline` 块内。 |

##### Available Parameters 可用参数

- string 字符串

  A parameter of a string type, for example: `parameters { string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '') }`. 字符串类型的参数，例如： `parameters { string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '') }` .

- text 发短信

  A text parameter, which can contain multiple lines, for example: `parameters { text(name: 'DEPLOY_TEXT', defaultValue: 'One\nTwo\nThree\n', description: '') }`. 文本参数，可以包含多行，例如： `parameters { text(name: 'DEPLOY_TEXT', defaultValue: 'One\nTwo\nThree\n', description: '') }` .

- booleanParam booleanParam 参数

  A boolean parameter, for example: `parameters { booleanParam(name: 'DEBUG_BUILD', defaultValue: true, description: '') }`. 布尔参数，例如： `parameters { booleanParam(name: 'DEBUG_BUILD', defaultValue: true, description: '') }` .

- choice 选择

  A choice parameter, for example: `parameters { choice(name: 'CHOICES', choices: ['one', 'two', 'three'], description: '') }`. The first value is the default. 选择参数，例如： `parameters { choice(name: 'CHOICES', choices: ['one', 'two', 'three'], description: '') }` .第一个值是默认值。

- password 密码

  A password parameter, for example: `parameters { password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'A secret password') }`. 密码参数，例如： `parameters { password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'A secret password') }` .

Example 10. Parameters, Declarative Pipeline
例 10.参数 （Parameters） > 声明性管道 （Declarative Pipeline）

```
pipeline {
    agent any
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    }
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"

                echo "Biography: ${params.BIOGRAPHY}"

                echo "Toggle: ${params.TOGGLE}"

                echo "Choice: ${params.CHOICE}"

                echo "Password: ${params.PASSWORD}"
            }
        }
    }
}
```



|      | A comprehensive list of available parameters is pending the completion of [help desk ticket 820](https://github.com/jenkins-infra/helpdesk/issues/820). 可用参数的完整列表正在等待[帮助台票证 820](https://github.com/jenkins-infra/helpdesk/issues/820) 的完成。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

#### triggers 触发器

The `triggers` directive defines the automated ways in which the Pipeline should be re-triggered. For Pipelines which are integrated with a source such as GitHub or BitBucket, `triggers` may not be necessary as webhooks-based integration will likely already be present. The triggers currently available are `cron`, `pollSCM` and `upstream`.
`triggers` 指令定义应重新触发 Pipeline 的自动化方式。对于与 GitHub 或 BitBucket 等源集成的管道，`触发器`可能不是必需的，因为基于 Webhook 的集成可能已经存在。当前可用的触发器包括 `cron`、`pollSCM` 和 `upstream`。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Only once, inside the `pipeline` block. 只有一次，在 `pipeline` 块内。 |

- cron cron （定时）

  Accepts a cron-style string to define a regular interval at which the Pipeline should be re-triggered, for example: `triggers { cron('H */4 * * 1-5') }`. 接受 cron 样式字符串以定义应重新触发 Pipeline 的固定间隔，例如： `triggers { cron('H */4 * * 1-5') }` 。

- pollSCM

  Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes. If new changes exist, the Pipeline will be re-triggered. For example: `triggers { pollSCM('H */4 * * 1-5') }` 接受 cron 样式的字符串，以定义 Jenkins 检查新源更改的定期间隔。如果存在新的更改，将重新触发 Pipeline。例如： `triggers { pollSCM('H */4 * * 1-5') }` 

- upstream 上游

  Accepts a comma-separated string of jobs and a threshold. When any job in the string finishes with the minimum threshold, the Pipeline will be re-triggered. For example: `triggers { upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS) }` 接受以逗号分隔的作业字符串和阈值。当字符串中的任何作业以最小阈值完成时，将重新触发 Pipeline。例如： `triggers { upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS) }` 

|      | The `pollSCM` trigger is only available in Jenkins 2.22 or later. `pollSCM` 触发器仅在 Jenkins 2.22 或更高版本中可用。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Example 11. Triggers, Declarative Pipeline
例 11.触发器、声明式管道

```
// Declarative //
pipeline {
    agent any
    triggers {
        cron('H */4 * * 1-5')
    }
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### Jenkins cron syntax Jenkins cron 语法

The Jenkins cron syntax follows the syntax of the [cron utility](https://en.wikipedia.org/wiki/Cron) (with minor differences). Specifically, each line consists of 5 fields separated by TAB or whitespace:
Jenkins cron 语法遵循 [cron 实用程序](https://en.wikipedia.org/wiki/Cron)的语法（略有不同）。具体来说，每行由 5 个字段组成，用 Tab 键或空格分隔：

| MINUTE                                                   | HOUR                                             | DOM                                             | MONTH                          | DOW                                                          |
| -------------------------------------------------------- | ------------------------------------------------ | ----------------------------------------------- | ------------------------------ | ------------------------------------------------------------ |
| Minutes within the hour (0–59) 一小时内的分钟数 （0–59） | The hour of the day (0–23) 一天中的小时 （0–23） | The day of the month (1–31) 该月的某天 （1–31） | The month (1–12) 月份 （1–12） | The day of the week (0–7) where 0 and 7 are Sunday. 星期几 （0–7），其中 0 和 7 是星期日。 |

To specify multiple values for one field, the following operators are available. In the order of precedence,
要为一个字段指定多个值，可以使用以下运算符。按优先顺序，

- `*` specifies all valid values
  `*` 指定所有有效值
- `M-N` specifies a range of values
  `M-N` 指定值范围
- `M-N/X` or `*/X` steps by intervals of `X` through the specified range or whole valid range
  `M-N/X` 或 `*/X` 步长为 `X`，间隔为指定范围或整个有效范围
- `A,B,…,Z` enumerates multiple values
  `A、B,...,Z` 枚举多个值

To allow periodically scheduled tasks to produce even load on the system, the symbol `H` (for “hash”) should be used wherever possible. For example, using `0 0 * * *` for a dozen daily jobs will cause a large spike at midnight. In contrast, using `H H * * *` would still execute each job once a day, but not all at the same time, better using limited resources.
为了允许定期计划的任务在系统上产生均匀的负载，应尽可能使用符号 `H`（表示“哈希”）。例如，对十几个日常作业使用 `0 0 * *` * 将导致午夜出现较大的峰值。相比之下，使用 `H H * * *` 仍会每天执行一次每个作业，但不会同时执行所有作业，从而更好地利用有限的资源。

The `H` symbol can be used with a range. For example, `H H(0-7) * * *` means some time between 12:00 AM (midnight) to 7:59 AM. You can also use step intervals with `H`, with or without ranges.
`H` 符号可以与范围一起使用。例如，`H H（0-7） * *` * 表示凌晨 12：00（午夜）到上午 7：59 之间的某个时间。您还可以将步长间隔与 `H` 一起使用，带或不带范围。

The `H` symbol can be thought of as a random value over a range, but it  actually is a hash of the job name, not a random function, so that the  value remains stable for any given project.
`H` 符号可以被认为是某个范围内的随机值，但它实际上是作业名称的哈希值，而不是随机函数，因此该值对于任何给定项目都保持稳定。

Beware that for the day of month field, short cycles such as `*/3` or `H/3` will not work consistently near the end of most months, due to variable month lengths. For example, `*/3` will run on the 1st, 4th, …31st days of a long month, then again the next day of the next month. Hashes are always chosen in the 1-28 range, so `H/3` will produce a gap between runs of between 3 and 6 days at the end of a month. Longer cycles will also have inconsistent lengths, but the effect may be relatively less noticeable.
请注意，对于日期字段，由于月份长度可变，诸如 `*/3` 或 `H/3` 之类的短周期在大多数月份结束时不会始终有效。例如，`*/3` 将在第 1 个、第 4 个、...一个漫长月份的第 31 天，然后又是下个月的第二天。哈希值总是在 1-28 范围内选择，因此 `H/3` 将在月底产生 3 到 6 天的运行间隔。较长的周期也会具有不一致的长度，但效果可能相对不那么明显。

Empty lines and lines that start with `#` will be ignored as comments.
空行和以 `#` 开头的行将作为注释忽略。

In addition, `@yearly`, `@annually`, `@monthly`, `@weekly`, `@daily`, `@midnight`, and `@hourly` are supported as convenient aliases. These use the hash system for automatic balancing. For example, `@hourly` is the same as `H * * * *` and could mean at any time during the hour. `@midnight` actually means some time between 12:00 AM and 2:59 AM.
此外，还支持将 `@yearly`、`@annually`、`@monthly`、`@weekly`、`@daily`、`@midnight` 和 `@hourly` 作为方便的别名。这些使用哈希系统进行自动平衡。例如，`@hourly` 与 `H * * * *` 相同，可能表示在一小时内的任何时间。`@midnight`实际上是指 12：00 AM 到 2：59 AM 之间的某个时间。

| every fifteen minutes (perhaps at :07, :22, :37, :52) 每 15 分钟（可能在 ：07， ：22， ：37， ：52） |
| ------------------------------------------------------------ |
| `triggers{ cron('H/15 * * * *') }`                           |
| every ten minutes in the first half of every hour (three times, perhaps at :04, :14, :24) 每小时前半段每 10 分钟一次（3 次，可能在 ：04、：14、：24） |
| `triggers{ cron('H(0-29)/10 * * * *') }`                     |
| once every two hours at 45 minutes past the hour starting at 9:45 AM and finishing at 3:45 PM every weekday. 每个工作日上午 9：45 开始，到下午 3：45 结束，每两小时一次，超过整点 45 分钟。 |
| `triggers{ cron('45 9-16/2 * * 1-5') }`                      |
| once in every two hours slot between 9 AM and 5 PM every weekday (perhaps at 10:38 AM, 12:38 PM, 2:38 PM, 4:38 PM) 每个工作日上午 9 点至下午 5 点之间每两小时一次（可能在上午 10：38、中午 12：38、下午 2：38、下午 4：38） |
| `triggers{ cron('H H(9-16)/2 * * 1-5') }`                    |
| once a day on the 1st and 15th of every month except December 每月 1 日和 15 日每天一次，12 月除外 |
| `triggers{ cron('H H 1,15 1-11 *') }`                        |

#### stage 阶段

The `stage` directive goes in the `stages` section and should contain a [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#steps) section, an optional `agent` section, or other stage-specific directives. Practically speaking, all of the real work done by a Pipeline will be wrapped in one or more `stage` directives.
`stage` 指令位于 `stages` 部分，应包含 [steps](https://www.jenkins.io/doc/book/pipeline/syntax/#steps) 部分、可选的 `agent` 部分或其他特定于 stage 的指令。实际上，Pipeline 完成的所有实际工作都将包装在一个或多个 `stage` 指令中。

| Required 必填   | At least one 至少一个                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | One mandatory parameter, a string for the name of the stage. 一个必需参数，即阶段名称的字符串。 |
| Allowed 允许    | Inside the `stages` section. 在 `stages` 部分内。            |

Example 12. Stage, Declarative Pipeline
例 12.暂存、声明式管道

```
// Declarative //
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### tools 工具

A section defining tools to auto-install and put on the `PATH`. This is ignored if `agent none` is specified.
定义用于自动安装和放入 `PATH` 的工具的部分。如果未指定 `agent none`，则忽略此项。

| Required 必填   | No 不                                                        |
| --------------- | ------------------------------------------------------------ |
| Parameters 参数 | *None 没有*                                                  |
| Allowed 允许    | Inside the `pipeline` block or a `stage` block. `在 pipeline` 块或 `stage` 块内。 |

##### Supported Tools 支持的工具

- maven
- jdk
- gradle 格拉德尔

Example 13. Tools, Declarative Pipeline
例 13.工具、声明式管道

```
pipeline {
    agent any
    tools {
        maven 'apache-maven-3.0.1' 
    }
    stages {
        stage('Example') {
            steps {
                sh 'mvn --version'
            }
        }
    }
}
```

|      | The tool name must be pre-configured in Jenkins under **Manage Jenkins** → **Tools**. 必须在 Jenkins 中的 Manage Jenkins → Tools （**管理 Jenkins** **工具**） 下预先配置工具名称。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

#### input 输入

The `input` directive on a `stage` allows you to prompt for input, using the [`input` step](https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/#input-wait-for-interactive-input). The `stage` will pause after any `options` have been applied, and before entering the `agent` block for that `stage` or evaluating the `when` condition of the `stage`. If the `input` is approved, the `stage` will then continue. Any parameters provided as part of the `input` submission will be available in the environment for the rest of the `stage`.
`阶段`上的 `input` 指令允许您使用 [`input` 步骤](https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/#input-wait-for-interactive-input)提示输入。在应用任何`选项`后，在进入该`阶段`的`代理`数据块或评估`该阶段`的 `when` 条件之前，`该阶段`将暂停。如果`输入`获得批准，`则阶段`将继续。作为`输入`提交的一部分提供的任何参数都将在`环境中可用于该阶段`的其余部分。

##### Configuration options 配置选项

- message 消息

  Required. This will be presented to the user when they go to submit the `input`. 必填。当用户提交`输入`时，这将呈现给用户。

- id 身份证

  An optional identifier for this `input`. The default value is based on the `stage` name. 此`输入`的可选标识符。默认值基于`阶段`名称。

- ok 还行

  Optional text for the "ok" button on the `input` form. `输入`表单上 “ok” 按钮的可选文本。

- submitter 提交者

  An optional comma-separated list of users or external group names who are allowed to submit this `input`. Defaults to allowing any user. 允许提交此`输入`的用户或外部组名称的可选逗号分隔列表。默认为允许任何用户。

- submitterParameter submitter参数

  An optional name of an environment variable to set with the `submitter` name, if present. 要使用`提交者`名称（如果存在）设置的环境变量的可选名称。

- parameters 参数

  An optional list of parameters to prompt the submitter to provide. Refer to [parameters](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters) for more information. 提示提交者提供的可选参数列表。有关更多信息，请参阅[参数](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters)。

Example 14. Input Step, Declarative Pipeline
例 14.Input Step（输入步骤）、Declarative Pipeline （声明式管道）

```
pipeline {
    agent any
    stages {
        stage('Example') {
            input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo "Hello, ${PERSON}, nice to meet you."
            }
        }
    }
}
```



#### when 什么时候

The `when` directive allows the Pipeline to determine whether the stage should be executed depending on the given condition. The `when` directive must contain at least one condition. If the `when` directive contains more than one condition, all the child conditions must return true for the stage to execute. This is the same as if the child conditions were nested in an `allOf` condition (refer to the [examples](https://www.jenkins.io/doc/book/pipeline/syntax/#when-example) below). If an `anyOf` condition is used, note that the condition skips remaining tests as soon as the first "true" condition is found.
`when` 指令允许 Pipeline 根据给定的条件确定是否应执行该阶段。`when` 指令必须至少包含一个条件。如果 `when` 指令包含多个条件，则所有子条件都必须返回 true，才能执行该阶段。这与子条件嵌套在 `allOf` 条件中相同（[请参阅以下示例）。](https://www.jenkins.io/doc/book/pipeline/syntax/#when-example)如果使用 `anyOf` 条件，请注意，一旦找到第一个 “true” 条件，该条件就会跳过其余测试。

More complex conditional structures can be built using the nesting conditions: `not`, `allOf`, or `anyOf`. Nesting conditions may be nested to any arbitrary depth.
可以使用嵌套条件构建更复杂的条件结构：`not`、`allOf` 或 `anyOf`。嵌套条件可以嵌套到任意深度。

| Required 必填   | No 不                                        |
| --------------- | -------------------------------------------- |
| Parameters 参数 | *None 没有*                                  |
| Allowed 允许    | Inside a `stage` directive 在 `stage` 指令中 |

##### Built-in Conditions 内置条件

- branch 分支

  Execute the stage when the branch being built matches the branch pattern (ANT style path glob) given, for example: `when { branch 'master' }`. Note that this only works on a multibranch Pipeline. 当正在构建的分支与给定的分支模式（ANT 样式路径 glob）匹配时执行 stage，例如：`when { branch 'master' }`。请注意，这仅适用于多分支 Pipeline。 The optional parameter `comparator` may be added after an attribute to specify how any patterns are evaluated for a match: 可以在属性后添加可选参数 `comparator` 以指定如何评估任何模式的匹配：   `EQUALS` for a simple string comparison `EQUALS` 进行简单的字符串比较  `GLOB` (the default) for an ANT style path glob (same as for example `changeset`) `GLOB`（默认值），用于 ANT 样式路径 glob（与示例 `changeset` 相同）  `REGEXP` for regular expression matching 用于正则表达式匹配的 `REGEXP`

For example: `when { branch pattern: "release-\\d+", comparator: "REGEXP"}` 例如： `when { branch pattern: "release-\\d+", comparator: "REGEXP"}` 

- buildingTag

  Execute the stage when the build is building a tag. For example: `when { buildingTag() }` 在构建构建标签时执行该阶段。例如：`当 { buildingTag（） }`

- changelog 更改日志

  Execute the stage if the build’s SCM changelog contains a given regular expression pattern, for example: `when { changelog '.*^\\[DEPENDENCY\\] .+$' }`. 如果构建的 SCM 更改日志包含给定的正则表达式模式，则执行该阶段，例如： `when { changelog '.*^\\[DEPENDENCY\\] .+$' }` 。

- changeset 变更集

  Execute the stage if the build’s SCM changeset contains one or more files matching the given pattern. Example: `when { changeset "**/*.js" }` 如果构建的 SCM 变更集包含一个或多个与给定模式匹配的文件，则执行该阶段。示例：`when { changeset “**/*.js” }` The optional parameter `comparator` may be added after an attribute to specify how any patterns are evaluated for a match: 可以在属性后添加可选参数 `comparator` 以指定如何评估任何模式的匹配：   `EQUALS` for a simple string comparison `EQUALS` 进行简单的字符串比较  `GLOB` (the default) for an ANT style path glob case insensitive (this can be turned off with the `caseSensitive` parameter). `GLOB`（默认值）对于 ANT 样式路径 glob 不区分大小写（可以使用 `caseSensitive` 参数关闭）。  `REGEXP` for regular expression matching 用于正则表达式匹配的 `REGEXP`

For example: `when { changeset pattern: ".**TEST\\.java", comparator: "REGEXP" }**` **or `when { changeset pattern: "`**`*/*TEST.java", caseSensitive: true }`
例如： `when { changeset pattern: ".**TEST\\.java", comparator: "REGEXP" }**`  **或者`当 { changeset pattern： ”`** `*/*TEST.java", caseSensitive: true }` 

- changeRequest 更改请求

  Executes the stage if the current build is for a "change request" (a.k.a. Pull  Request on GitHub and Bitbucket, Merge Request on GitLab, Change in  Gerrit, etc.). When no parameters are passed the stage runs on every change request,  for example: `when { changeRequest() }`. 如果当前构建是针对“更改请求”（又名 GitHub 和 Bitbucket 上的拉取请求、GitLab 上的合并请求、Gerrit 中的更改等），则执行该阶段。如果未传递任何参数，则阶段将在每个更改请求上运行，例如：`当 { changeRequest（） }` 时。 By adding a filter attribute with parameter to the change request, the  stage can be made to run only on matching change requests. Possible attributes are `id`, `target`, `branch`, `fork`, `url`, `title`, `author`, `authorDisplayName`, and `authorEmail`. Each of these corresponds to a `CHANGE_*` environment variable, for example: `when { changeRequest target: 'master' }`. 通过向更改请求添加带有参数的 filter 属性，可以使该阶段仅在匹配的更改请求上运行。可能的属性包括 `id`、`target`、`branch`、`fork`、`url`、`title`、`author``、authorDisplayName` 和 `authorEmail`。每个变量都对应于一个 `CHANGE_*` 环境变量，例如： `when { changeRequest target: 'master' }` 。  The optional parameter `comparator` may be added after an attribute to specify how any patterns are evaluated for a match: 可以在属性后添加可选参数 `comparator` 以指定如何评估任何模式的匹配：   `EQUALS` for a simple string comparison (the default) `EQUALS` 进行简单的字符串比较（默认值）  `GLOB` for an ANT style path glob (same as for example `changeset`) `GLOB` 表示 ANT 样式路径 glob（与例如 `changeset` 相同）  `REGEXP` for regular expression matching 用于正则表达式匹配的 `REGEXP`

Example: `when { changeRequest authorEmail: "[\\w_-.]+@example.com", comparator: 'REGEXP' }` 例： `when { changeRequest authorEmail: "[\\w_-.]+@example.com", comparator: 'REGEXP' }` 

- environment 环境

  Execute the stage when the specified environment variable is set to the given value, for example: `when { environment name: 'DEPLOY_TO', value: 'production' }`. 当指定的环境变量设置为给定值时执行阶段，例如： `when { environment name: 'DEPLOY_TO', value: 'production' }` 。

- equals 等于

  Execute the stage when the expected value is equal to the actual value, for example: `when { equals expected: 2, actual: currentBuild.number }`. 当预期值等于实际值时执行阶段，例如： `when { equals expected: 2, actual: currentBuild.number }` 。

- expression 表达

  Execute the stage when the specified Groovy expression evaluates to true, for example: `when { expression { return params.DEBUG_BUILD } }`. 当指定的 Groovy 表达式的计算结果为 true 时执行阶段，例如： `when { expression { return params.DEBUG_BUILD } }` 。

|      | When returning strings from your expressions they must be converted to booleans or return `null` to evaluate to false. Simply returning "0" or "false" will still evaluate to "true".  从表达式返回字符串时，必须将它们转换为布尔值或返回 `null` 以计算为 false。简单地返回 “0” 或 “false” 仍将计算为 “true”。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

- tag 标记

  Execute the stage if the `TAG_NAME` variable matches the given pattern. For example: `when { tag "release-*" }` If an empty pattern is provided the stage will execute if the `TAG_NAME` variable exists (same as `buildingTag()`). 如果 `TAG_NAME` 变量与给定模式匹配，则执行该阶段。例如：`当 { tag “release-*” }` 如果提供了一个空模式，则如果 `TAG_NAME` 变量存在（与 `buildingTag（）` 相同），则将执行 stage。 The optional parameter `comparator` may be added after an attribute to specify how any patterns are evaluated for a match: 可以在属性后添加可选参数 `comparator` 以指定如何评估任何模式的匹配：   `EQUALS` for a simple string comparison, `EQUALS` 进行简单的字符串比较，  `GLOB` (the default) for an ANT style path glob (same as for example `changeset`), or `GLOB`（默认值）表示 ANT 样式路径 glob（与示例 `changeset` 相同），或  `REGEXP` for regular expression matching. `REGEXP` 进行正则表达式匹配。

For example: `when { tag pattern: "release-\\d+", comparator: "REGEXP"}` 例如： `when { tag pattern: "release-\\d+", comparator: "REGEXP"}` 

- not 不

  Execute the stage when the nested condition is false. Must contain one condition. For example: `when { not { branch 'master' } }` 当嵌套条件为 false 时执行 stage。必须包含一个条件。例如： `when { not { branch 'master' } }` 

- allOf 所有

  Execute the stage when all of the nested conditions are true. Must contain at least one condition. For example: `when { allOf { branch 'master'; environment name: 'DEPLOY_TO', value: 'production' } }` 当所有嵌套条件都为 true 时执行阶段。必须至少包含一个条件。例如： `when { allOf { branch 'master'; environment name: 'DEPLOY_TO', value: 'production' } }` 

- anyOf anyOf 的

  Execute the stage when at least one of the nested conditions is true. Must contain at least one condition. For example: `when { anyOf { branch 'master'; branch 'staging' } }` 当至少有一个嵌套条件为 true 时执行阶段。必须至少包含一个条件。例如： `when { anyOf { branch 'master'; branch 'staging' } }` 

- triggeredBy triggeredBy 触发者

  Execute the stage when the current build has been triggered by the param given. For example: 当当前构建由给定的参数触发时执行 stage。例如：  `when { triggeredBy 'SCMTrigger' }`  `when { triggeredBy 'TimerTrigger' }`  `when { triggeredBy 'BuildUpstreamCause' }`  `when { triggeredBy  cause: "UserIdCause", detail: "vlinde" }`

##### Evaluating `when` before entering `agent` in a `stage` 在`阶段`中输入 `agent` 之前评估`时间`

By default, the `when` condition for a `stage` will be evaluated after entering the `agent` for that `stage`, if one is defined. However, this can be changed by specifying the `beforeAgent` option within the `when` block. If `beforeAgent` is set to `true`, the `when` condition will be evaluated first, and the `agent` will only be entered if the `when` condition evaluates to true.
默认情况下，在输入该`阶段`的`代理`程序（如果已定义）后，将评估`该阶段`的 `when` 条件。但是，可以通过在 `when` 块中指定 `beforeAgent` 选项来更改此设置。如果 `beforeAgent` 设置为 `true`，则将首先评估 `when` 条件，并且仅当 `when` 条件的计算结果为 true 时，才会输入`代理`。

##### Evaluating `when` before the `input` directive 在 `input` 指令之前评估 `when`

By default, the when condition for a stage will not be evaluated before the input, if one is defined. However, this can be changed by specifying the `beforeInput` option within the when block. If `beforeInput` is set to true, the when condition will be evaluated first, and the  input will only be entered if the when condition evaluates to true.
默认情况下，如果定义了 when，则不会在输入之前评估阶段的 when 条件。但是，可以通过在 when 块中指定 `beforeInput` 选项来更改此设置。如果 `beforeInput` 设置为 true，则将首先评估 when 条件，并且仅当 when 条件的计算结果为 true 时，才会输入输入。

`beforeInput true` takes precedence over `beforeAgent true`.
`beforeInput true` 优先于 `beforeAgent true`。

##### Evaluating `when` before the `options` directive 在 `options` 指令之前评估 `when`

By default, the `when` condition for a `stage` will be evaluated after entering the `options` for that `stage`, if any are defined. However, this can be changed by specifying the `beforeOptions` option within the `when` block. If `beforeOptions` is set to `true`, the `when` condition will be evaluated first, and the `options` will only be entered if the `when` condition evaluates to true.
默认情况下，在输入该`阶段``的选项`（如果定义了任何选项）后，将评估`该阶段`的 `when` 条件。但是，可以通过在 `when` 块中指定 `beforeOptions` 选项来更改此设置。如果 `beforeOptions` 设置为 `true`，则将首先评估 `when` 条件，并且仅当 `when` 条件的计算结果为 true 时，才会输入`选项`。

`beforeOptions true` takes precedence over `beforeInput true` and `beforeAgent true`.
`beforeOptions true` 优先于 `beforeInput true` 和 `beforeAgent true`。

Example 15. Single Condition, Declarative Pipeline
例 15.单条件、声明性管道

```
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                branch 'production'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 16. Multiple Condition, Declarative Pipeline
例 16.多条件、声明式管道

```
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                branch 'production'
                environment name: 'DEPLOY_TO', value: 'production'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 17. Nested condition (same behavior as previous example)
例 17.嵌套条件（与上一个示例的行为相同）

```
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                allOf {
                    branch 'production'
                    environment name: 'DEPLOY_TO', value: 'production'
                }
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 18. Multiple condition and nested condition
例 18.多个条件和嵌套条件

```
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                branch 'production'
                anyOf {
                    environment name: 'DEPLOY_TO', value: 'production'
                    environment name: 'DEPLOY_TO', value: 'staging'
                }
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 19. Expression condition and nested condition
例 19.表达式条件和嵌套条件

```
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                expression { BRANCH_NAME ==~ /(production|staging)/ }
                anyOf {
                    environment name: 'DEPLOY_TO', value: 'production'
                    environment name: 'DEPLOY_TO', value: 'staging'
                }
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 20. `beforeAgent`
例 20.`beforeAgent`

```
pipeline {
    agent none
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            agent {
                label "some-label"
            }
            when {
                beforeAgent true
                branch 'production'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 21. `beforeInput`
例 21.`beforeInput （输入）`

```
pipeline {
    agent none
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                beforeInput true
                branch 'production'
            }
            input {
                message "Deploy to production?"
                id "simple-input"
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

Example 22. `beforeOptions`
例 22.`beforeOptions`

```
pipeline {
    agent none
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                beforeOptions true
                branch 'testing'
            }
            options {
                lock label: 'testing-deploy-envs', quantity: 1, variable: 'deployEnv'
            }
            steps {
                echo "Deploying to ${deployEnv}"
            }
        }
    }
}
```



Example 23. `triggeredBy`
例 23.`triggeredBy 触发者`

```
pipeline {
    agent none
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                triggeredBy "TimerTrigger"
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```



### Sequential Stages 顺序阶段

Stages in Declarative Pipeline may have a `stages` section containing a list of nested stages to be run in sequential order.
声明式管道中的阶段可能有一个`阶段`部分，其中包含要按顺序运行的嵌套阶段列表。

|      | A stage must have one and only one of `steps`, `stages`, `parallel`, or `matrix`. It is not possible to nest a `parallel` or `matrix` block within a `stage` directive if that `stage` directive is nested within a `parallel` or `matrix` block itself. However, a `stage` directive within a `parallel` or `matrix` block can use all other functionality of a `stage`, including `agent`, `tools`, `when`, etc.  阶段必须有且只有 `steps`、`stages`、`parallel` 或 `matrix` 中的一个。如果 `parallel` 或 `matrix` 指令嵌套在 `parallel` 或 `matrix` 块本身中，则无法在 `stage` 指令中嵌套该 `stage` 块。但是，`parallel` 或 `matrix` 块中的 `stage` 指令可以使用 `stage` 的所有其他功能，包括 `agent`、`tools`、`when` 等。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

Example 24. Sequential Stages, Declarative Pipeline
例 24.顺序阶段，声明式管道

```
pipeline {
    agent none
    stages {
        stage('Non-Sequential Stage') {
            agent {
                label 'for-non-sequential'
            }
            steps {
                echo "On Non-Sequential Stage"
            }
        }
        stage('Sequential') {
            agent {
                label 'for-sequential'
            }
            environment {
                FOR_SEQUENTIAL = "some-value"
            }
            stages {
                stage('In Sequential 1') {
                    steps {
                        echo "In Sequential 1"
                    }
                }
                stage('In Sequential 2') {
                    steps {
                        echo "In Sequential 2"
                    }
                }
                stage('Parallel In Sequential') {
                    parallel {
                        stage('In Parallel 1') {
                            steps {
                                echo "In Parallel 1"
                            }
                        }
                        stage('In Parallel 2') {
                            steps {
                                echo "In Parallel 2"
                            }
                        }
                    }
                }
            }
        }
    }
}
```

### Parallel 平行

Stages in Declarative Pipeline may have a `parallel` section containing a list of nested stages to be run in parallel.
Declarative Pipeline 中的阶段可能有一个 `parallel` 部分，其中包含要并行运行的嵌套阶段列表。

|      | A stage must have one and only one of `steps`, `stages`, `parallel`, or `matrix`. It is not possible to nest a `parallel` or `matrix` block within a `stage` directive if that `stage` directive is nested within a `parallel` or `matrix` block itself. However, a `stage` directive within a `parallel` or `matrix` block can use all other functionality of a `stage`, including `agent`, `tools`, `when`, etc.  阶段必须有且只有 `steps`、`stages`、`parallel` 或 `matrix` 中的一个。如果 `parallel` 或 `matrix` 指令嵌套在 `parallel` 或 `matrix` 块本身中，则无法在 `stage` 指令中嵌套该 `stage` 块。但是，`parallel` 或 `matrix` 块中的 `stage` 指令可以使用 `stage` 的所有其他功能，包括 `agent`、`tools`、`when` 等。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

In addition, you can force your `parallel` stages to all be aborted when any one of them fails, by adding `failFast true` to the `stage` containing the `parallel`. Another option for adding `failfast` is adding an option to the pipeline definition: `parallelsAlwaysFailFast()`.
此外，您可以通过将 `failFast true` 添加到包含`并行`的`阶段`，强制在其中一个阶段失败时中止所有`并行`阶段。添加 `failfast` 的另一个选项是向管道定义添加一个选项：`parallelsAlwaysFailFast（）。`

Example 25. Parallel Stages, Declarative Pipeline
例 25.并行阶段，声明式管道

```
pipeline {
    agent any
    stages {
        stage('Non-Parallel Stage') {
            steps {
                echo 'This stage will be executed first.'
            }
        }
        stage('Parallel Stage') {
            when {
                branch 'master'
            }
            failFast true
            parallel {
                stage('Branch A') {
                    agent {
                        label "for-branch-a"
                    }
                    steps {
                        echo "On Branch A"
                    }
                }
                stage('Branch B') {
                    agent {
                        label "for-branch-b"
                    }
                    steps {
                        echo "On Branch B"
                    }
                }
                stage('Branch C') {
                    agent {
                        label "for-branch-c"
                    }
                    stages {
                        stage('Nested 1') {
                            steps {
                                echo "In stage Nested 1 within Branch C"
                            }
                        }
                        stage('Nested 2') {
                            steps {
                                echo "In stage Nested 2 within Branch C"
                            }
                        }
                    }
                }
            }
        }
    }
}
```

Example 26. `parallelsAlwaysFailFast`
例 26.`parallelsAlwaysFailFast`

```
pipeline {
    agent any
    options {
        parallelsAlwaysFailFast()
    }
    stages {
        stage('Non-Parallel Stage') {
            steps {
                echo 'This stage will be executed first.'
            }
        }
        stage('Parallel Stage') {
            when {
                branch 'master'
            }
            parallel {
                stage('Branch A') {
                    agent {
                        label "for-branch-a"
                    }
                    steps {
                        echo "On Branch A"
                    }
                }
                stage('Branch B') {
                    agent {
                        label "for-branch-b"
                    }
                    steps {
                        echo "On Branch B"
                    }
                }
                stage('Branch C') {
                    agent {
                        label "for-branch-c"
                    }
                    stages {
                        stage('Nested 1') {
                            steps {
                                echo "In stage Nested 1 within Branch C"
                            }
                        }
                        stage('Nested 2') {
                            steps {
                                echo "In stage Nested 2 within Branch C"
                            }
                        }
                    }
                }
            }
        }
    }
}
```



### Matrix 矩阵

Stages in Declarative Pipeline may have a `matrix` section defining a multi-dimensional matrix of name-value combinations to be run in parallel. We’ll refer these combinations as "cells" in a matrix. Each cell in a matrix can include one or more stages to be run sequentially using the configuration for that cell.
声明性管道中的阶段可能有一个 `matrix` 部分，用于定义要并行运行的名称-值组合的多维矩阵。我们将这些组合称为矩阵中的 “cells”。矩阵中的每个 cell 都可以包含一个或多个阶段，这些阶段要使用该 cell 的配置按顺序运行。

|      | A stage must have one and only one of `steps`, `stages`, `parallel`, or `matrix`. It is not possible to nest a `parallel` or `matrix` block within a `stage` directive if that `stage` directive is nested within a `parallel` or `matrix` block itself. However, a `stage` directive within a `parallel` or `matrix` block can use all other functionality of a `stage`, including `agent`, `tools`, `when`, etc.  阶段必须有且只有 `steps`、`stages`、`parallel` 或 `matrix` 中的一个。如果 `parallel` 或 `matrix` 指令嵌套在 `parallel` 或 `matrix` 块本身中，则无法在 `stage` 指令中嵌套该 `stage` 块。但是，`parallel` 或 `matrix` 块中的 `stage` 指令可以使用 `stage` 的所有其他功能，包括 `agent`、`tools`、`when` 等。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

In addition, you can force your `matrix` cells to all be aborted when any one of them fails, by adding `failFast true` to the `stage` containing the `matrix`. Another option for adding `failfast` is adding an option to the pipeline definition: `parallelsAlwaysFailFast()`.
此外，您可以通过将 `failFast true` 添加到包含`矩阵`的`阶段`，强制矩阵单元在其中任何一个失败时中止所有`矩阵`单元。添加 `failfast` 的另一个选项是向管道定义添加一个选项：`parallelsAlwaysFailFast（）。`

The `matrix` section must include an `axes` section and a `stages` section. The `axes` section defines the values for each `axis` in the matrix. The `stages` section defines a list of `stage`s to run sequentially in each cell. A `matrix` may have an `excludes` section to remove invalid cells from the matrix. Many of the directives available on  `stage`, including `agent`, `tools`, `when`, etc., can also be added to `matrix` to control the behavior of each cell.
`matrix` 部分必须包括 `axes` 部分和 `stages` 部分。`axes` 部分定义矩阵中每个`轴`的值。`部分 stages` 定义要在每个单元中按顺序运行的`阶段`列表。`矩阵`可能具有 `excludes` 部分，用于从矩阵中删除无效单元格。`舞台`上可用的许多指令，包括 `agent`、`tools`、`when` 等，也可以添加到 `matrix` 中以控制每个单元的行为。

#### axes 轴

The `axes` section specifies one or more `axis` directives. Each `axis` consists of a `name` and a list of `values`. All the values from each axis are combined with the others to produce the cells.
`axes` 部分指定一个或多个 `axis` 指令。每个`轴`都由一个`名称和`一个`值`列表组成。每个轴中的所有值都与其他值合并以生成单元格。

Example 27. One-axis with 3 cells
例 27.单轴 3 单元

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
    }
    // ...
}
```

Example 28. Two-axis with 12 cells (three by four)
例 28.双轴，带 12 个单元（3 x 4）

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
    }
    // ...
}
```

Example 29. Three-axis matrix with 24 cells (three by four by two)
例 29.具有 24 个单元的三轴矩阵（3 x 4 x 2）

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
        axis {
            name 'ARCHITECTURE'
            values '32-bit', '64-bit'
        }
    }
    // ...
}
```

#### stages 阶段

The `stages` section specifies one or more `stage`s to be executed sequentially in each cell. This section is identical to any other [`stages` section](https://www.jenkins.io/doc/book/pipeline/syntax/#sequential-stages).
部分 `stages` 指定要在每个单元中按顺序执行的一个或多个`阶段`。此部分与任何其他[`阶段`部分](https://www.jenkins.io/doc/book/pipeline/syntax/#sequential-stages)相同。

Example 30. One-axis with 3 cells, each cell runs three stages - "build", "test", and "deploy"
例 30.一个轴有 3 个单元，每个单元运行三个阶段 - “构建”、“测试”和“部署”

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
    }
    stages {
        stage('build') {
            // ...
        }
        stage('test') {
            // ...
        }
        stage('deploy') {
            // ...
        }
    }
}
```

Example 31. Two-axis with 12 cells (three by four)
例 31.双轴，带 12 个单元（3 x 4）

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
    }
    stages {
        stage('build-and-test') {
            // ...
        }
    }
}
```

#### excludes (optional) excludes（可选）

The optional `excludes` section lets authors specify one or more `exclude` filter expressions that select cells to be excluded from the expanded set of matrix cells (aka, sparsening). Filters are constructed using a basic directive structure of one or more of exclude `axis` directives each with a `name` and `values` list.
可选的 `excludes` 部分允许作者指定一个或多个`排除`过滤器表达式，用于选择要从扩展的矩阵单元格集（又名稀疏）中排除的单元格。过滤器是使用一个或多个 exclude `axis` 指令的基本指令结构构建的，每个指令都有一个 `name` 和 `values` 列表。

The `axis` directives inside an `exclude` generate a set of combinations (similar to generating the matrix cells). The matrix cells that match all the values from an `exclude` combination are removed from the matrix. If more than one `exclude` directive is supplied, each is evaluated separately to remove cells.
`exclude` 内的 `axis` 指令生成一组组合（类似于生成矩阵单元格）。与`排除`组合中的所有值匹配的矩阵单元格将从矩阵中删除。如果提供了多个 `exclude` 指令，则单独评估每个指令以删除单元格。

When dealing with a long list of values to exclude, exclude `axis` directives can use `notValues` instead of `values`. These will exclude cells that **do not** match one of the values passed to `notValues`.
在处理要排除的一长串值时，exclude `axis` 指令可以使用 `notValues` 而不是 `values`。这些将排除与传递给 `notValues` 的值**之一不匹配**的单元格。

Example 32. Three-axis matrix with 24 cells, exclude '32-bit, mac' (4 cells excluded)
例 32.具有 24 个单元格的三轴矩阵，不包括 '32-bit， mac' （不包括 4 个单元格）

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
        axis {
            name 'ARCHITECTURE'
            values '32-bit', '64-bit'
        }
    }
    excludes {
        exclude {
            axis {
                name 'PLATFORM'
                values 'mac'
            }
            axis {
                name 'ARCHITECTURE'
                values '32-bit'
            }
        }
    }
    // ...
}
```

Exclude the `linux, safari` combination and exclude any platform that is **not** `windows` with the `edge` browser.
排除 `linux、safari` 组合，并排除任何**不是**`Windows` 的 `edge` 浏览器平台。

Example 33. Three-axis matrix with 24 cells, exclude '32-bit, mac' and invalid browser combinations (9 cells excluded)
例 33.具有 24 个单元格的三轴矩阵，不包括“32 位，mac”和无效的浏览器组合（不包括 9 个单元格）

```
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
        axis {
            name 'ARCHITECTURE'
            values '32-bit', '64-bit'
        }
    }
    excludes {
        exclude {
            // 4 cells
            axis {
                name 'PLATFORM'
                values 'mac'
            }
            axis {
                name 'ARCHITECTURE'
                values '32-bit'
            }
        }
        exclude {
            // 2 cells
            axis {
                name 'PLATFORM'
                values 'linux'
            }
            axis {
                name 'BROWSER'
                values 'safari'
            }
        }
        exclude {
            // 3 more cells and '32-bit, mac' (already excluded)
            axis {
                name 'PLATFORM'
                notValues 'windows'
            }
            axis {
                name 'BROWSER'
                values 'edge'
            }
        }
    }
    // ...
}
```

#### Matrix cell-level directives (optional) 矩阵单元格级指令（可选）

Matrix lets users efficiently configure the overall environment for each cell, by adding stage-level directives under `matrix` itself. These directives behave the same as they would on a stage but they can also accept values provided by the matrix for each cell.
Matrix 允许用户通过在 `matrix` 本身下添加 stage 级指令来有效地配置每个 cell 的整体环境。这些指令的行为与它们在舞台上的行为相同，但它们也可以接受矩阵为每个单元格提供的值。

The `axis` and `exclude` directives define the static set of cells that make up the matrix. That set of combinations is generated before the start of the pipeline run. The "per-cell" directives, on the other hand, are evaluated at runtime.
`axis` 和 `exclude` 指令定义构成矩阵的静态单元格集。这组组合是在管道运行开始之前生成的。另一方面，“per-cell” 指令在运行时进行评估。

These directives include:
这些指令包括：

- [agent 代理](https://www.jenkins.io/doc/book/pipeline/syntax/#agent)
- [environment 环境](https://www.jenkins.io/doc/book/pipeline/syntax/#environment)
- [input 输入](https://www.jenkins.io/doc/book/pipeline/syntax/#input)
- [options 选项](https://www.jenkins.io/doc/book/pipeline/syntax/#options)
- [post 发布](https://www.jenkins.io/doc/book/pipeline/syntax/#post)
- [tools 工具](https://www.jenkins.io/doc/book/pipeline/syntax/#tools)
- [when 什么时候](https://www.jenkins.io/doc/book/pipeline/syntax/#when)

Example 34. Complete Matrix Example, Declarative Pipeline
例 34.完整矩阵示例，声明式管道

```
pipeline {
    parameters {
        choice(name: 'PLATFORM_FILTER', choices: ['all', 'linux', 'windows', 'mac'], description: 'Run on specific platform')
    }
    agent none
    stages {
        stage('BuildAndTest') {
            matrix {
                agent {
                    label "${PLATFORM}-agent"
                }
                when { anyOf {
                    expression { params.PLATFORM_FILTER == 'all' }
                    expression { params.PLATFORM_FILTER == env.PLATFORM }
                } }
                axes {
                    axis {
                        name 'PLATFORM'
                        values 'linux', 'windows', 'mac'
                    }
                    axis {
                        name 'BROWSER'
                        values 'firefox', 'chrome', 'safari', 'edge'
                    }
                }
                excludes {
                    exclude {
                        axis {
                            name 'PLATFORM'
                            values 'linux'
                        }
                        axis {
                            name 'BROWSER'
                            values 'safari'
                        }
                    }
                    exclude {
                        axis {
                            name 'PLATFORM'
                            notValues 'windows'
                        }
                        axis {
                            name 'BROWSER'
                            values 'edge'
                        }
                    }
                }
                stages {
                    stage('Build') {
                        steps {
                            echo "Do Build for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                    stage('Test') {
                        steps {
                            echo "Do Test for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                }
            }
        }
    }
}
```

### Steps 步骤

Declarative Pipelines may use all the available steps documented in the [Pipeline Steps reference](https://www.jenkins.io/doc/pipeline/steps), which contains a comprehensive list of steps, with the addition of the steps listed below which are **only supported** in Declarative Pipeline.
声明性管道可以使用[管道步骤参考](https://www.jenkins.io/doc/pipeline/steps)中记录的所有可用步骤，其中包含完整的步骤列表，并添加了下面列出的步骤，这些步骤仅在声明性管道中**受支持**。

#### script 脚本

The `script` step takes a block of [Scripted Pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline) and executes that in the Declarative Pipeline. For most use-cases, the `script` step should be unnecessary in Declarative Pipelines, but it can provide a useful "escape hatch". `script` blocks of non-trivial size and/or complexity should be moved into [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) instead.
`脚本`步骤采用一个[脚本化管道](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)块，并在声明式管道中执行该块。对于大多数用例，`脚本`步骤在 Declarative Pipelines 中应该是不必要的，但它可以提供一个有用的 “转义舱口”。应将大小和/或复杂性的`脚本`块移动到[共享库中](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)。

Example 35. Script Block in Declarative Pipeline
例 35.声明性管道中的脚本块

```
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'

                script {
                    def browsers = ['chrome', 'firefox']
                    for (int i = 0; i < browsers.size(); ++i) {
                        echo "Testing the ${browsers[i]} browser"
                    }
                }
            }
        }
    }
}
```



## Scripted Pipeline 脚本化管道

Scripted Pipeline, like [Declarative Pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline), is built on top of the underlying Pipeline sub-system. Unlike Declarative, Scripted Pipeline is effectively a general-purpose DSL [[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_1)] built with [Groovy](http://groovy-lang.org/syntax.html). Most functionality provided by the Groovy language is made available to  users of Scripted Pipeline, which means it can be a very expressive and  flexible tool with which one can author continuous delivery pipelines.
脚本化管道和[声明式管道](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)一样，是建立在底层管道子系统之上的。与声明式不同，脚本化管道实际上是用 [Groovy](http://groovy-lang.org/syntax.html) 构建的通用 DSL [[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_1)]。Groovy 语言提供的大部分功能都可供 Scripted Pipeline 的用户使用，这意味着它可以是一个非常富有表现力和灵活的工具，人们可以使用它来编写持续交付管道。

### Flow Control 流控制

Scripted Pipeline is serially executed from the top of a `Jenkinsfile` downwards, like most traditional scripts in Groovy or other languages. Providing flow control, therefore, rests on Groovy expressions, such as the `if/else` conditionals, for example:
脚本化流水线是从 `Jenkinsfile` 的顶部向下串行执行的，就像 Groovy 或其他语言中的大多数传统脚本一样。因此，提供流控制依赖于 Groovy 表达式，例如 `if/else` 条件，例如：

Example 36. Conditional Statement `if`, Scripted Pipeline
例 36.条件语句 `if`， 脚本化管道

```
node {
    stage('Example') {
        if (env.BRANCH_NAME == 'master') {
            echo 'I only execute on the master branch'
        } else {
            echo 'I execute elsewhere'
        }
    }
}
```

Another way Scripted Pipeline flow control can be managed is with Groovy’s exception handling support. When [Steps](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-steps) fail for whatever reason they throw an exception. Handling behaviors on-error must make use of the `try/catch/finally` blocks in Groovy, for example:
管理 Scripted Pipeline 流控制的另一种方法是使用 Groovy 的异常处理支持。当 [Steps](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-steps) 因任何原因失败时，它们会引发异常。处理错误时的行为必须使用 `Groovy 中的 try/catch/finally` 块，例如：

Example 37. Try-Catch Block, Scripted Pipeline
例 37.try-catch 块，脚本化管道

```
node {
    stage('Example') {
        try {
            sh 'exit 1'
        }
        catch (exc) {
            echo 'Something failed, I should sound the klaxons!'
            throw
        }
    }
}
```

### Steps 步骤

As discussed at the [start of this chapter](https://www.jenkins.io/doc/book/pipeline/), the most fundamental part of a Pipeline is the "step". Fundamentally, steps tell Jenkins *what* to do and serve as the basic building block for both Declarative and Scripted Pipeline syntax.
正如[本章开头](https://www.jenkins.io/doc/book/pipeline/)所讨论的，Pipeline 最基本的部分是 “step”。从根本上说，步骤告诉 *Jenkins 该做什么*，并作为声明式和脚本化管道语法的基本构建块。

Scripted Pipeline does **not** introduce any steps which are specific to its syntax; [Pipeline Steps reference](https://www.jenkins.io/doc/pipeline/steps) contains a comprehensive list of steps provided by Pipeline and plugins.
脚本化管道 **不会**引入任何特定于其语法的步骤;[Pipeline Steps 参考](https://www.jenkins.io/doc/pipeline/steps)包含 Pipeline 和插件提供的步骤的完整列表。

### Differences from plain Groovy 与普通 Groovy 的区别

In order to provide *durability*, which means that running Pipelines can survive a restart of the Jenkins [controller](https://www.jenkins.io/doc/book/glossary/#controller), Scripted Pipeline must serialize data back to the controller. Due to this design requirement, some Groovy idioms such as `collection.each { item → /* perform operation */ }` are not fully supported. Refer to [JENKINS-27421](https://issues.jenkins.io/browse/JENKINS-27421) and [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481) for more information.
为了提供*持久性*，这意味着正在运行的 Pipelines 可以在 Jenkins [控制器](https://www.jenkins.io/doc/book/glossary/#controller)重启后继续存在，脚本化管道必须将数据序列化回控制器。由于此设计要求，某些 Groovy 惯用语 `collection.each { item → /* perform operation */ }` （如 ）不完全受支持。有关更多信息，请参阅 [JENKINS-27421](https://issues.jenkins.io/browse/JENKINS-27421) 和 [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481)。

## Syntax Comparison 语法比较

<iframe width="800" height="420" src="https://www.youtube.com/embed/GJBlskiaRrI?rel=0" frameborder="0" allowfullscreen=""></iframe>

This video shares some differences between Scripted and Declarative Pipeline syntax.
此视频分享了脚本化管道语法和声明性管道语法之间的一些差异。

When Jenkins Pipeline was first created, Groovy was selected as the  foundation. Jenkins has long shipped with an embedded Groovy engine to provide  advanced scripting capabilities for admins and users alike. Additionally, the implementors of Jenkins Pipeline found Groovy to be a  solid foundation upon which to build what is now referred to as the  "Scripted Pipeline" DSL. [[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_1)].
当 Jenkins Pipeline 首次创建时，Groovy 被选为基础。Jenkins 长期以来一直提供嵌入式 Groovy  引擎，为管理员和用户提供高级脚本功能。此外，Jenkins Pipeline 的实现者发现 Groovy 是构建现在所谓的“脚本化管道”DSL  的坚实基础。[[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_1)] 中。

As it is a fully-featured programming environment, Scripted Pipeline  offers a tremendous amount of flexibility and extensibility to Jenkins  users. The Groovy learning-curve isn’t typically desirable for all members of a given team, so Declarative Pipeline was created to offer a simpler and  more opinionated syntax for authoring Jenkins Pipeline.
由于它是一个功能齐全的编程环境，Scripted Pipeline 为 Jenkins 用户提供了极大的灵活性和可扩展性。Groovy 学习曲线通常并不适合给定团队的所有成员，因此创建  Declarative Pipeline 是为了提供一种更简单、更有主见的语法来编写 Jenkins Pipeline。

Both are fundamentally the same Pipeline sub-system underneath. They are both durable implementations of "Pipeline as code". They are both able to use steps built into Pipeline or provided by plugins. Both are able to utilize [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)
两者本质上是相同的 Pipeline 子系统。它们都是“Pipeline as code”的持久实现。它们都能够使用 Pipeline 中内置或由插件提供的步骤。两者都能够使用[共享库](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)

Where they differ however is in syntax and flexibility. Declarative limits what is available to the user with a more strict and  pre-defined structure, making it an ideal choice for simpler continuous  delivery pipelines. Scripted provides very few limits, insofar that the only limits on  structure and syntax tend to be defined by Groovy itself, rather than  any Pipeline-specific systems, making it an ideal choice for power-users and those with more complex requirements. As the name implies, Declarative Pipeline encourages a declarative  programming model. [[2](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_2)] Whereas Scripted Pipelines follow a more imperative programming model. [[3](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_3)]
然而，它们的不同之处在于语法和灵活性。Declarative 通过更严格和预定义的结构限制用户可用的内容，使其成为更简单的持续交付管道的理想选择。Scripted  提供的限制非常少，因为结构和语法的唯一限制往往由 Groovy 本身定义，而不是任何特定于 Pipeline  的系统，使其成为高级用户和具有更复杂需求的用户的理想选择。顾名思义，Declarative Pipeline 鼓励使用声明式编程模型。[[2](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_2)] 而脚本化管道遵循更命令式的编程模型。[[3](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnotedef_3)]

------

[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_1). [Domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language)
[1](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_1). [域特定语言](https://en.wikipedia.org/wiki/Domain-specific_language)

[2](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_2). [Declarative Programming](https://en.wikipedia.org/wiki/Declarative_programming)
[2](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_2). [声明式编程](https://en.wikipedia.org/wiki/Declarative_programming)

[3](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_3). [Imperative Programming](https://en.wikipedia.org/wiki/Imperative_programming)
[3](https://www.jenkins.io/doc/book/pipeline/syntax/#_footnoteref_3). [命令式编程](https://en.wikipedia.org/wiki/Imperative_programming)

# Pipeline as Code 管道即代码

Table of Contents 目录

- [The Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#the-jenkinsfile)
- [Folder Computation 文件夹计算](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#folder-computation)
- Configuration 配置
  - [Multibranch Pipeline Projects
    多分支管道项目](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#multibranch-pipeline-projects)
  - [Organization Folders 组织文件夹](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#organization-folders)
  - [Orphaned Item Strategy 孤立项策略](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#orphaned-item-strategy)
  - [Icon and View Strategy 图标和视图策略](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#icon-and-view-strategy)
- [Example 例](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#example)
- Continuous Delivery with Pipeline
  使用 Pipeline 进行持续交付
  - [Pre-requisites 先决条件](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#pre-requisites)
  - [Concepts 概念](https://www.jenkins.io/doc/book/pipeline/pipeline-as-code/#concepts)

*Pipeline as Code* describes a set of features that allow Jenkins users to define pipelined job processes with code, stored and versioned in a source repository.  These features allow Jenkins to discover, manage, and run jobs for multiple source repositories and branches — eliminating the need for manual job creation and management.
*管道即代码* 描述了一组功能，这些功能允许 Jenkins 用户使用代码定义管道作业流程，并在源存储库中存储和版本控制。这些功能使 Jenkins 能够发现、管理和运行多个源存储库和分支的作业，无需手动创建和管理作业。

To use *Pipeline as Code*, projects must contain a file named `Jenkinsfile` in the repository root, which contains a "Pipeline script."
要使用 *Pipeline as Code*，项目必须在存储库根目录中包含一个名为 `Jenkinsfile` 的文件，其中包含一个“Pipeline script”。

Additionally, one of the enabling jobs needs to be configured in Jenkins:
此外，需要在 Jenkins 中配置其中一个启用作业：

- *Multibranch Pipeline*: build multiple branches of a *single* repository automatically
  *Multibranch Pipeline*：自动构建*单个*存储库的多个分支
- *Organization Folders*: scan a **GitHub Organization** or **Bitbucket Team** to discover an organization’s repositories, automatically creating managed *Multibranch Pipeline* jobs for them
  *组织文件夹*：扫描 **GitHub Organization** 或 **Bitbucket Team** 以发现组织的存储库，并自动为其创建托管*的 Multibranch Pipeline* 作业
- *Pipeline*: Regular Pipeline jobs have an option when specifying the pipeline to "Use SCM".
  *管道*：常规管道作业在将管道指定为“使用 SCM”时有一个选项。

Fundamentally, an organization’s repositories can be viewed as a hierarchy, where each repository may have child elements of branches and pull requests.
从根本上说，组织的仓库可以被视为一个层次结构，其中每个仓库都可能具有分支和拉取请求的子元素。

Example Repository Structure
示例存储库结构

```
+--- GitHub Organization
    +--- Project 1
        +--- master
        +--- feature-branch-a
        +--- feature-branch-b
    +--- Project 2
        +--- master
        +--- pull-request-1
        +--- etc...
Prior to _Multibranch Pipeline_ jobs and _Organization Folders_,
plugin:cloudbees-folder[Folders]
could be used to create this hierarchy in Jenkins by organizing repositories
into folders containing jobs for each individual branch.
```

*Multibranch Pipeline* and *Organization Folders* eliminate the manual process by detecting branches and repositories, respectively, and creating appropriate folders with jobs in Jenkins automatically.
*Multibranch Pipeline* 和 *Organization Folders* 通过分别检测分支和存储库，并在 Jenkins 中自动创建包含作业的适当文件夹，从而消除了手动过程。

## The Jenkinsfile

Presence of the `Jenkinsfile` in the root of a repository makes it eligible for Jenkins to automatically manage and execute jobs based on repository branches.
存储库根目录中的 `Jenkinsfile` 使 Jenkins 有资格根据存储库分支自动管理和执行作业。

The `Jenkinsfile` should contain a Pipeline script, specifying the steps to execute the job.  The script has all the power of Pipeline available, from something as simple as invoking a Maven builder, to a series of interdependent steps, which have coordinated parallel execution with deployment and validation phases.
`Jenkinsfile` 应包含一个 Pipeline 脚本，用于指定执行作业的步骤。该脚本具有 Pipeline 的所有可用功能，从调用 Maven 构建器这样简单的事情，到一系列相互依赖的步骤，这些步骤将并行执行与部署和验证阶段协调在一起。

A simple way to get started with Pipeline is to use the *Snippet Generator* available in the configuration screen for a Jenkins *Pipeline* job.  Using the *Snippet Generator*, you can create a Pipeline script as you might through the dropdowns in other Jenkins jobs.
开始使用 Pipeline 的一种简单方法是使用 Jenkins *Pipeline* 作业的配置屏幕中提供的 *Snippet Generator*。使用 *Snippet Generator*，您可以创建管道脚本，就像通过其他 Jenkins 作业中的下拉列表一样。

## Folder Computation 文件夹计算

*Multibranch Pipeline* projects and *Organization Folders* extend the existing folder functionality by introducing 'computed' folders.  Computed folders automatically run a process to manage the folder contents.  This computation, in the case of *Multibranch Pipeline* projects, creates child items for each eligible branch within the child.  For *Organization Folders*, computation populates child items for repositories as individual *Multibranch Pipelines*.
*Multibranch Pipeline* projects 和 *Organization Folders* 通过引入 “computed” 文件夹来扩展现有文件夹功能。计算文件夹会自动运行一个进程来管理文件夹内容。对于 *Multibranch Pipeline* 项目，此计算将为子项中的每个符合条件的分支创建子项。对于 *Organization Folders （组织文件夹*），计算将存储库的子项填充为单独的 *Multibranch Pipelines*。

Folder computation may happen automatically via webhook callbacks, as branches and repositories are created or removed.  Computation may also be triggered by the *Build Trigger* defined in the configuration, which will automatically run a computation task after a period of inactivity (this defaults to run after one day).
文件夹计算可以通过 webhook 回调自动进行，因为分支和仓库是创建或删除的。计算也可能由配置中定义的 *Build Trigger* 触发，它将在一段时间不活动后自动运行计算任务（默认为在一天后运行）。

![folder computation build trigger schedule](https://www.jenkins.io/doc/book/resources/pipeline-as-code/folder-computation-build-trigger-schedule.png)

Information about the last execution of the folder computation is available in the **Folder Computation** section.
有关上次执行文件夹计算的信息，请参阅 **Folder Computation** 部分。

![folder computation main](https://www.jenkins.io/doc/book/resources/pipeline-as-code/folder-computation-main.png)

The log from the last attempt to compute the folder is available from this page. If folder computation doesn’t result in an expected set of repositories, the log may have useful information to diagnose the problem.
此页面提供了上次尝试计算文件夹的日志。如果文件夹计算未产生预期的存储库集，则日志可能包含诊断问题的有用信息。

![folder computation log](https://www.jenkins.io/doc/book/resources/pipeline-as-code/folder-computation-log.png)

## Configuration 配置

Both *Multibranch Pipeline* projects and *Organization Folders* have configuration options to allow precise selection of repositories.  These features also allow selection of two types of credentials to use when connecting to the remote systems:
*Multibranch Pipeline* projects 和 *Organization Folders* 都具有配置选项，以允许精确选择存储库。这些功能还允许选择在连接到远程系统时使用的两种类型的凭证：

- *scan* credentials, which are used for accessing the GitHub or Bitbucket APIs
  *扫描*凭据，用于访问 GitHub 或 Bitbucket API
- *checkout* credentials, which are used when the repository is cloned from the remote system; it may be useful to choose an SSH key or *"- anonymous -"*, which uses the default credentials configured for the OS user
  *签出*凭证，从远程系统克隆存储库时使用;选择 SSH 密钥或*“- anonymous -”*可能很有用，它使用为 OS 用户配置的默认凭据

|      | If you are using a *GitHub Organization*, you should [create a GitHub access token](https://github.com/settings/tokens/new?scopes=repo,public_repo,admin:repo_hook,admin:org_hook&description=Jenkins+Access) to use to avoid storing your password in Jenkins and prevent any issues when using the GitHub API. When using a GitHub access token, you must use standard *Username with password* credentials, where the username is the same as your GitHub username and the password is your access token.  如果您使用的是 *GitHub 组织*，则应[创建一个 GitHub 访问令牌](https://github.com/settings/tokens/new?scopes=repo,public_repo,admin:repo_hook,admin:org_hook&description=Jenkins+Access)，以避免将密码存储在 Jenkins 中，并防止在使用 GitHub API 时出现任何问题。使用 GitHub 访问令牌时，您必须使用*带有密码*凭证的标准用户名，其中用户名与您的 GitHub 用户名相同，密码是您的访问令牌。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Multibranch Pipeline Projects 多分支管道项目

*Multibranch Pipeline* projects are one of the fundamental enabling features for *Pipeline as Code*.  Changes to the build or deployment procedure can evolve with project requirements and the job always reflects the current state of the project.  It also allows you to configure different jobs for different branches of the same project, or to forgo a job if appropriate.  The `Jenkinsfile` in the root directory of a branch or pull request identifies a multibranch project.
*多分支 Pipeline* 项目是 *Pipeline as Code* 的基本支持功能之一。对生成或部署过程的更改可能会随着项目要求而变化，并且作业始终反映项目的当前状态。它还允许您为同一项目的不同分支配置不同的作业，或者在适当的情况下放弃作业。分支或拉取请求根目录中的 `Jenkinsfile` 标识多分支项目。

|      | *Multibranch Pipeline* projects expose the name of the branch being built with the `BRANCH_NAME` environment variable and provide a special `checkout scm` Pipeline command, which is guaranteed to check out the specific commit that the Jenkinsfile originated.  If the Jenkinsfile needs to check out the repository for any reason, make sure to use `checkout scm`, as it also accounts for alternate origin repositories to handle things like pull requests.  *Multibranch Pipeline* 项目使用 `BRANCH_NAME` 环境变量公开正在构建的分支的名称，并提供特殊的 `checkout scm` Pipeline 命令，该命令保证签出 Jenkinsfile 发起的特定提交。如果 Jenkinsfile 出于任何原因需要签出存储库，请确保使用 `checkout scm`，因为它还考虑了备用源存储库来处理拉取请求等操作。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

To create a *Multibranch Pipeline*, go to: *New Item → Multibranch Pipeline*. Configure the SCM source as appropriate.  There are options for many different types of repositories and services including Git, Mercurial, Bitbucket, and GitHub.  If using GitHub, for example, click **Add source**, select GitHub and configure the appropriate owner, scan credentials, and repository.
要创建 *Multibranch Pipeline*，请转到：*New Item → Multibranch Pipeline*。根据需要配置 SCM 源。有许多不同类型的存储库和服务可供选择，包括 Git、Mercurial、Bitbucket 和 GitHub。例如，如果使用 GitHub，请单击 **Add source**，选择 GitHub 并配置相应的所有者、扫描凭证和存储库。

Other options available to *Multibranch Pipeline* projects are:
*Multibranch Pipeline* 项目可用的其他选项包括：

- **API endpoint** - an alternate API endpoint to use a self-hosted GitHub Enterprise
  **API 端点** - 使用自托管 GitHub Enterprise 的备用 API 端点
- **Checkout credentials** - alternate credentials to use when checking out the code (cloning)
  **Checkout credentials** - 签出代码（克隆）时使用的备用凭证
- **Include branches** - a regular expression to specify branches to include
  **Include branches** - 用于指定要包含的分支的正则表达式
- **Exclude branches** - a regular expression to specify branches to exclude; note that this will take precedence over includes
  **Exclude branches** - 用于指定要排除的分支的正则表达式;请注意，这将优先于 includes
- **Property strategy** - if necessary, define custom properties for each branch
  **属性策略** - 如有必要，为每个分支定义自定义属性

After configuring these items and saving the configuration, Jenkins will automatically scan the repository and import appropriate branches.
配置这些项目并保存配置后，Jenkins 将自动扫描存储库并导入相应的分支。

### Organization Folders 组织文件夹

Organization Folders offer a convenient way to allow Jenkins to automatically manage which repositories are automatically included in Jenkins. Particularly, if your organization utilizes *GitHub Organizations* or *Bitbucket Teams*, any time a developer creates a new repository with a `Jenkinsfile`, Jenkins will automatically detect it and create a *Multibranch Pipeline* project for it. This alleviates the need for administrators or developers to manually create projects for these new repositories.
组织文件夹提供了一种方便的方式，允许 Jenkins 自动管理哪些存储库自动包含在 Jenkins 中。特别是，如果您的组织使用 *GitHub Organizations* 或 *Bitbucket Teams*，则每当开发人员使用 `Jenkinsfile` 创建新存储库时，Jenkins 都会自动检测它并为其创建一个 *Multibranch Pipeline* 项目。这减轻了管理员或开发人员为这些新存储库手动创建项目的需要。

To create an *Organization Folder* in Jenkins, go to: **New Item → GitHub Organization** or **New Item → Bitbucket Team** and follow the configuration steps for each item, making sure to specify appropriate *Scan Credentials* and a specific **owner** for the GitHub Organization or Bitbucket Team name, respectively.
要在 Jenkins 中创建*组织文件夹*，请转到：**GitHub 组织→新项目**或 **Bitbucket 团队→新项目**，然后按照每个项目的配置步骤进行操作，确保分别为 GitHub 组织或 Bitbucket 团队名称指定适当的*扫描凭证*和特定**所有者**。

Other options available are:
其他可用选项包括：

- **Repository name pattern** - a regular expression to specify which repositories are **included**
  **仓库名称模式** - 用于指定**包含**哪些仓库的正则表达式
- **API endpoint** - an alternate API endpoint to use a self-hosted GitHub Enterprise
  **API 端点** - 使用自托管 GitHub Enterprise 的备用 API 端点
- **Checkout credentials** - alternate credentials to use when checking out the code (cloning)
  **Checkout credentials** - 签出代码（克隆）时使用的备用凭证

After configuring these items and saving the configuration, Jenkins will  automatically scan the organization and import appropriate repositories  and resulting branches.
配置这些项目并保存配置后，Jenkins 将自动扫描组织并导入相应的存储库和生成的分支。

### Orphaned Item Strategy 孤立项策略

Computed folders can remove items immediately or leave them based on a desired  retention strategy. By default, items will be removed as soon as the folder computation  determines they are no longer present. If your organization requires these items remain available for a longer  period of time, simply configure the Orphaned Item Strategy  appropriately. It may be useful to keep items in order to examine build results of a  branch after it’s been removed, for example.
计算文件夹可以立即删除项目，也可以根据所需的保留策略保留项目。默认情况下，一旦文件夹计算确定项目不再存在，就会立即删除这些项目。如果您的组织要求这些项目在较长时间内保持可用，则只需适当地配置 Orphaned Item Strategy（孤立项目策略）即可。例如，保留 items 以便在删除分支后检查分支的构建结果可能很有用。

![orphaned item strategy](https://www.jenkins.io/doc/book/resources/pipeline-as-code/orphaned-item-strategy.png)

### Icon and View Strategy 图标和视图策略

You may also configure an icon to use for the folder display. For example, it might be useful to display an aggregate health of the child builds. Alternately, you might reference the same icon you use in your GitHub organization account.
您还可以配置一个图标以用于文件夹显示。例如，显示子构建的聚合运行状况可能很有用。或者，您可以引用在 GitHub 组织帐户中使用的相同图标。

![folder icon](https://www.jenkins.io/doc/book/resources/pipeline-as-code/folder-icon.png)

## Example 例

To demonstrate using an Organization Folder to manage repositories, we’ll use the fictitious organization: CloudBeers, Inc..
为了演示如何使用组织文件夹来管理存储库，我们将使用虚构的组织：CloudBeers， Inc.。

Go to **New Item**. Enter 'cloudbeers' for the item name. Select **GitHub Organization** and click **OK**.
转到 **New Item（新建项目**）。输入 'cloudbeers' 作为项目名称。选择 **GitHub Organization （GitHub 组织**），然后单击 **OK （确定**）。

![screenshot1](https://www.jenkins.io/doc/book/resources/pipeline-as-code/screenshot1.png)

Optionally, enter a better descriptive name for the *Description*, such as 'CloudBeers GitHub'. In the *Repository Sources* section, complete the section for "GitHub Organization". Make sure the **owner** matches the GitHub Organization name exactly, in our case it must be: *cloudbeers*. This defaults to the same value that was entered for the item name in the first step. Next, select or add new "Scan credentials" - we’ll enter our GitHub username and access token as the password.
（可选）为 *Description （描述*） 输入更好的描述性名称，例如 'CloudBeers GitHub'。在 *Repository Sources （存储库源*） 部分中，完成 “GitHub Organization” 部分。确保**所有者**与 GitHub 组织名称完全匹配，在我们的例子中，它必须是：*cloudbeers*。默认值与第一步中为项名称输入的值相同。接下来，选择或添加新的 “Scan credentials” - 我们将输入我们的 GitHub 用户名和访问令牌作为密码。

![screenshot2](https://www.jenkins.io/doc/book/resources/pipeline-as-code/screenshot2.png)

After saving, the "Folder Computation" will run to scan for eligible repositories, followed by multibranch builds.
保存后，将运行“Folder Computation”以扫描符合条件的存储库，然后进行多分支构建。

![screenshot3](https://www.jenkins.io/doc/book/resources/pipeline-as-code/screenshot3.png)

Refresh the page after the job runs to ensure the view of repositories has been updated.
在作业运行后刷新页面，以确保存储库的视图已更新。

![screenshot4](https://www.jenkins.io/doc/book/resources/pipeline-as-code/screenshot4.png)

A this point, you’re finished with basic project configuration and can now explore your imported repositories. You can also investigate the results of the jobs run as part of the initial *Folder Computation*.
此时，您已完成基本项目配置，现在可以浏览导入的存储库。您还可以调查作为初始*文件夹计算*的一部分运行的作业的结果。

![screenshot5](https://www.jenkins.io/doc/book/resources/pipeline-as-code/screenshot5.png)

## Continuous Delivery with Pipeline 使用 Pipeline 进行持续交付

Continuous delivery allows organizations to deliver software with lower risk. The path to continuous delivery starts by modeling the software delivery pipeline used within the organization and then focusing on the automation of it all. Early, directed feedback, enabled by pipeline automation enables software delivery more quickly over traditional methods of delivery.
持续交付使组织能够以较低的风险交付软件。持续交付之路首先要对组织内使用的软件交付管道进行建模，然后专注于这一切的自动化。管道自动化支持的早期定向反馈使软件交付比传统交付方法更快。

Jenkins is the Swiss army knife in the software delivery toolchain. Developers and operations (DevOps) personnel have different mindsets and use different tools to get their respective jobs done. Since Jenkins integrates with a huge variety of toolsets, it serves as the intersection point between development and operations teams.
Jenkins 是软件交付工具链中的瑞士军刀。开发人员和运营 （DevOps） 人员有不同的思维方式，使用不同的工具来完成各自的工作。由于 Jenkins 集成了各种各样的工具集，因此它是开发和运营团队之间的交集点。

Many organizations have been orchestrating pipelines with existing Jenkins plugins for several years. As their automation sophistication and their own Jenkins experience increases, organizations inevitably want to move beyond simple pipelines and create complex flows specific to their delivery process.
多年来，许多组织一直在使用现有的 Jenkins 插件编排管道。随着自动化复杂性和自身 Jenkins 经验的提高，组织不可避免地希望超越简单的管道，创建特定于其交付流程的复杂流程。

These Jenkins users require a feature that treats complex pipelines as a first-class object, and so the [Pipeline plugin](https://plugins.jenkins.io/workflow-aggregator) was developed .
这些 Jenkins 用户需要一个将复杂管道视为第一类对象的功能，因此开发了 [Pipeline 插件](https://plugins.jenkins.io/workflow-aggregator)。

### Pre-requisites 先决条件

Continuous delivery is a process - rather than a tool - and requires a mindset and culture that must percolate from the top-down within an organization. Once the organization has bought into the philosophy, the next and most difficult part is mapping the flow of software as it makes its way from development to production.
持续交付是一个过程，而不是一个工具，需要一种必须自上而下的思维方式和文化，这种思维方式和文化必须渗透到组织内部。一旦组织接受了这一理念，下一个也是最困难的部分就是绘制软件从开发到生产的流程。

The root of such a pipeline will always be an orchestration tool like a Jenkins, but there are some key requirements that such an integral part of the pipeline must satisfy before it can be tasked with enterprise-critical processes:
这种管道的根始终是像 Jenkins 这样的编排工具，但是在将管道分配给企业关键流程之前，管道的这一组成部分必须满足一些关键要求：

- **Zero or low downtime disaster recovery**: A commit, just as a mythical hero, encounters harder and longer challenges as it makes its way down the pipeline. It is not unusual to see pipeline executions that last days. A hardware or a Jenkins failure on day six of a seven-day pipeline has serious consequences for on-time delivery of a product.
  **零或低停机时间灾难恢复**：提交就像神话中的英雄一样，在管道中会遇到更艰巨、更漫长的挑战。过去几天的管道执行情况并不罕见。在 7 天管道的第 6 天，硬件或 Jenkins 故障会对产品的按时交付造成严重后果。
- **Audit runs and debug ability**: Build managers like to see the exact execution flow through the pipeline, so they can easily debug issues.
  **审计运行和调试功能**：构建管理员喜欢查看通过管道的确切执行流程，以便他们可以轻松调试问题。

To ensure a tool can scale with an organization and suitably automate  existing delivery pipelines without changing them, the tool should also  support:
为了确保工具可以随组织扩展并在不更改现有交付管道的情况下适当地自动化现有交付管道，该工具还应支持：

- **Complex pipelines**: Delivery pipelines are typically more complex than canonical examples (linear process: Dev→Test→Deploy, with a couple of operations at each stage). Build managers want constructs that help parallelize parts of the flow, run loops, perform retries and so forth. Stated differently, build managers want programming constructs to define pipelines.
  **复杂管道**：交付管道通常比规范示例（线性过程：Dev→Test→Deploy，每个阶段都有几个操作）更复杂。构建管理器需要有助于并行化流的各个部分、运行循环、执行重试等的构造。换句话说，构建管理器希望编程结构来定义管道。
- **Manual interventions**: Pipelines cross intra-organizational boundaries necessitating manual handoffs and interventions. Build managers seek capabilities such as being able to pause a pipeline for a human to intervene and make manual decisions.
  **人工干预**：管道跨越组织内部边界，需要人工交接和干预。构建经理寻求的功能，例如能够暂停管道，以便人工干预并做出手动决策。

The Pipeline plugin allows users to create such a pipeline through a new job type called Pipeline. The flow definition is captured in a Groovy script, thus adding control flow capabilities such as loops, forks and retries. Pipeline allows for stages with the option to set concurrencies, preventing multiple builds of the same pipeline from trying to access the same resource at the same time.
Pipeline 插件允许用户通过名为 Pipeline 的新作业类型创建此类管道。流定义在 Groovy 脚本中捕获，从而添加控制流功能，例如循环、分叉和重试。Pipeline 允许阶段选择设置并发，从而防止同一管道的多个构建尝试同时访问同一资源。

### Concepts 概念

Pipeline Job Type 管道作业类型

There is just one job to capture the entire software delivery pipeline in an organization. Of course, you can still connect two Pipeline job types together if you want. A Pipeline job type uses a Groovy-based DSL for job definitions.    The DSL affords the advantage of defining jobs programmatically:
只需一个作业即可捕获组织中的整个软件交付管道。当然，如果需要，您仍然可以将两个 Pipeline 作业类型连接在一起。Pipeline 作业类型使用基于 Groovy 的 DSL 进行作业定义。DSL 提供了以编程方式定义作业的优势：

```
node('linux'){
  git url: 'https://github.com/jglick/simple-maven-project-with-tests.git'
  def mvnHome = tool 'M3'
  env.PATH = "${mvnHome}/bin:${env.PATH}"
  sh 'mvn -B clean verify'
}
```

Stages 阶段

Intra-organizational (or conceptual) boundaries are captured through a primitive called "stages." A deployment pipeline consists of various stages, where each subsequent stage builds on the previous one. The idea is to spend as few resources as possible early in the pipeline and find obvious issues, rather than spend a lot of computing resources for something that is ultimately discovered to be broken.
组织内部（或概念）边界是通过称为“阶段”的原语捕获的。部署管道由各个阶段组成，其中每个后续阶段都基于前一个阶段。这个想法是在管道的早期花费尽可能少的资源并发现明显的问题，而不是花费大量计算资源来最终发现有问题。

![stage concurrency](https://www.jenkins.io/doc/book/resources/pipeline-as-code/stage-concurrency.png)

Figure 1. Throttled stage concurrency with Pipeline
图 1.使用 Pipeline 的受限制阶段并发

Consider a simple pipeline with three stages. A naive implementation of this pipeline can sequentially trigger each stage on every commit. Thus, the deployment step is triggered immediately after the Selenium test steps are complete. However, this would mean that the deployment from commit two overrides the last deployment in motion from commit one. The right approach is for commits two and three to wait for the deployment from commit one to complete, consolidate all the changes that have happened since commit one and trigger the deployment. If there is an issue, developers can easily figure out if the issue was introduced in commit two or commit three.
考虑一个具有三个阶段的简单管道。此管道的天真实现可以在每次提交时按顺序触发每个阶段。因此，在 Selenium 测试步骤完成后，将立即触发部署步骤。但是，这意味着提交 2 中的部署将覆盖提交 1 中的最后一个动态部署。正确的方法是让提交 2 和 3 等待从提交 1 开始的部署完成，整合自提交 1 以来发生的所有更改并触发部署。如果存在问题，开发人员可以轻松确定问题是在提交 2  还是提交 3 中引入的。

Pipeline provides this functionality by enhancing the stage primitive.  For example, a stage can have a concurrency level of one defined to indicate that at any point only one thread should be running through the stage. This achieves the desired state of running a deployment as fast as it should run.
Pipeline 通过增强 stage 基元来提供此功能。例如，一个阶段可以定义一个并发级别 1，以指示在任何时候都应该只有一个线程通过该阶段。这将实现以应有的速度运行 Deployment 的理想状态。

```
 stage name: 'Production', concurrency: 1
 node {
     unarchive mapping: ['target/x.war' : 'x.war']
     deploy 'target/x.war', 'production'
     echo 'Deployed to http://localhost:8888/production/'
 }
```

Gates and Approvals 登机口和审批

Continuous delivery means having binaries in a release ready state whereas continuous deployment means pushing the binaries to production - or automated deployments. Although continuous deployment is a sexy term and a desired state, in reality organizations still want a human to give the final approval before bits are pushed to production.  This is captured through the "input" primitive in Pipeline. The input step can wait indefinitely for a human to intervene.
持续交付意味着使二进制文件处于发布就绪状态，而持续部署意味着将二进制文件推送到生产环境或自动化部署。尽管持续部署是一个性感的术语，也是一种理想的状态，但实际上，组织仍然希望在将 bits 推送到生产环境之前，由人工进行最终批准。这是通过 Pipeline 中的 “input”  基元捕获的。输入步骤可以无限期地等待人类干预。

```
input message: "Does http://localhost:8888/staging/ look good?"
```

Deployment of Artifacts to Staging/Production
将构件部署到暂存/生产环境

Deployment of binaries is the last mile in a pipeline. The numerous servers employed within the organization and available in the market make it difficult to employ a uniform deployment step. Today, these are solved by third-party deployer products whose job it is to focus on deployment of a particular stack to a data center. Teams can also write their own extensions to hook into the Pipeline job type and make the deployment easier.
部署二进制文件是管道中的最后一英里。组织内部使用和市场上可用的大量服务器使得采用统一的部署步骤变得困难。如今，这些问题由第三方部署程序产品解决，其工作是专注于将特定堆栈部署到数据中心。团队还可以编写自己的扩展以挂接到 Pipeline 作业类型，并使部署更容易。

Meanwhile, job creators can write a plain old Groovy function to define any custom steps that can deploy (or undeploy) artifacts from production.
同时，作业创建者可以编写一个普通的旧 Groovy 函数来定义任何可以从生产环境中部署（或取消部署）工件的自定义步骤。

```
def deploy(war, id) {
    sh "cp ${war} /tmp/webapps/${id}.war"
}
```

Restartable flows 可重启流

All Pipelines are resumable, so if Jenkins needs to be restarted while a flow is running, it should resume at the same point in its execution after Jenkins starts back up. Similarly, if a flow is running a lengthy sh or bat step when an agent unexpectedly disconnects, no progress should be lost when connectivity is restored.
所有管道都是可恢复的，因此，如果 Jenkins 需要在流运行时重新启动，则应在 Jenkins 重新启动后在其执行的同一点恢复。同样，如果流在代理意外断开连接时正在运行冗长的 sh 或 bat 步骤，则在恢复连接时不应丢失任何进度。

There are some cases when a flow build will have done a great deal of work and proceeded to a point where a transient error occurred: one which does not reflect the inputs to this build, such as source code changes. For example, after completing a lengthy build and test of a software component, final deployment to a server might fail because of network problems.
在某些情况构建将完成大量工作并继续进行到发生暂时性错误的点：该错误不反映此构建的输入，例如源代码更改。例如，在完成软件组件的冗长构建和测试后，到服务器的最终部署可能会因网络问题而失败。

Pipeline Stage View Pipeline Stage 视图

When you have complex builds pipelines, it is useful to see the progress of each stage and to see where build failures are occurring in the pipeline. This can enable users to debug which tests are failing at which stage or if there are other problems in their pipeline. Many organization also want to make their pipelines user-friendly for non-developers without having to develop a homegrown UI, which can prove to be a lengthy and ongoing development effort.
当您拥有复杂的构建管道时，查看每个阶段的进度以及查看管道中发生构建失败的位置非常有用。这使用户能够调试哪些测试在哪个阶段失败，或者他们的管道中是否存在其他问题。许多组织还希望使其管道对非开发人员用户友好，而无需开发自主开发的 UI，这可能被证明是一项漫长且持续的开发工作。

The Pipeline Stage View feature offers extended visualization of Pipeline build history on the index page of a flow project. This visualization also includes helpful metrics like average run time by stage and by build, and a user-friendly interface for interacting with input steps.
Pipeline Stage View 功能在流程项目的索引页面上提供 Pipeline 构建历史记录的扩展可视化。此可视化还包括有用的指标，例如按阶段和按构建的平均运行时间，以及用于与输入步骤交互的用户友好界面。

![workflow big responsive](https://www.jenkins.io/doc/book/resources/pipeline-as-code/workflow-big-responsive.png)

Figure 2. Pipeline Stage View plugin
图 2.Pipeline Stage View 插件

The only prerequisite for this plugin is a pipeline with defined stages in the flow. There can be as many stages as you desired and they can be in a linear sequence, and the stage names will be displayed as columns in the Stage View interface.
此插件的唯一先决条件是流程中具有已定义阶段的管道。您可以根据需要设置任意数量的阶段，并且它们可以按线性顺序排列，并且阶段名称将在 Stage View 界面中显示为列。

#### Artifact traceability with fingerprints 使用指纹进行工件可追溯性

Traceability is important for DevOps teams who need to be able to trace code from commit to deployment. It enables impact analysis by showing relationships between artifacts and allows for visibility into the full lifecycle of an artifact, from its code repository to where the artifact is eventually deployed in production.
对于需要能够跟踪代码从提交到部署的 DevOps 团队来说，可追溯性非常重要。它通过显示构件之间的关系来支持影响分析，并允许查看构件的整个生命周期，从其代码存储库到构件最终在生产中的部署位置。

Jenkins and the Pipeline feature support tracking versions of artifacts using file fingerprinting, which allows users to trace which downstream builds are using any given artifact. To fingerprint with Pipeline, simply add a "fingerprint: true" argument to any artifact archiving step. For example:
Jenkins 和 Pipeline 功能支持使用文件指纹跟踪构件的版本，这允许用户跟踪哪些下游构建正在使用任何给定构件。要使用 Pipeline 进行指纹识别，只需将 “fingerprint： true” 参数添加到任何工件存档步骤中即可。例如：

```
archiveArtifacts artifacts: '**', fingerprint: true
```

will archive any WAR artifacts created in the Pipeline and fingerprint them for traceability. This trace log of this artifact and a list of all fingerprinted artifacts in a build will then be available in the left-hand menu of Jenkins:
将存档在 Pipeline 中创建的任何 WAR 构件，并对其进行指纹识别以实现可追溯性。然后，此工件的跟踪日志和构建中所有指纹工件的列表将在 Jenkins 的左侧菜单中提供：

To find where an artifact is used and deployed to, simply follow the "more details" link through the artifact’s name and view the entries for the artifact in its "Usage" list.
要查找构件的使用和部署位置，只需点击构件名称中的“更多详细信息”链接，然后在其“Usage”列表中查看构件的条目即可。

![fingerprinting](https://www.jenkins.io/doc/book/resources/pipeline-as-code/fingerprinting.png)

Figure 3. Fingerprint of a WAR
图 3.战争的指纹

Visit the [fingerprint documentation](https://www.jenkins.io/doc/book/using/fingerprints/) to learn more.
访问 [指纹文档](https://www.jenkins.io/doc/book/using/fingerprints/) 了解更多信息。

# Pipeline Best Practices 管道最佳实践

Table of Contents 目录

- General 常规
  - [Making sure to use Groovy code in Pipelines as glue
    确保在 Pipelines 中使用 Groovy 代码作为胶水](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#making-sure-to-use-groovy-code-in-pipelines-as-glue)
  - [Running shell scripts in Jenkins Pipeline
    在 Jenkins Pipeline 中运行 shell 脚本](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#running-shell-scripts-in-jenkins-pipeline)
  - [Avoiding complex Groovy code in Pipelines
    避免在 Pipelines 中使用复杂的 Groovy 代码](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#avoiding-complex-groovy-code-in-pipelines)
  - [Reducing repetition of similar Pipeline steps
    减少类似 Pipeline 步骤的重复](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#reducing-repetition-of-similar-pipeline-steps)
  - [Avoiding calls to `Jenkins.getInstance`
    避免调用 `Jenkins.getInstance`](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#avoiding-calls-to-jenkins-getinstance)
  - [Cleaning up old Jenkins builds
    清理旧的 Jenkins 构建](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#cleaning-up-old-jenkins-builds)
- Using shared libraries 使用共享库
  - [Do not override built-in Pipeline steps
    不要覆盖内置 Pipeline 步骤](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#do-not-override-built-in-pipeline-steps)
  - [Avoiding large global variable declaration files
    避免使用大型全局变量声明文件](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#avoiding-large-global-variable-declaration-files)
  - [Avoiding very large shared libraries
    避免非常大的共享库](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#avoiding-very-large-shared-libraries)
- Answering additional FAQs
  回答其他常见问题
  - [Dealing with Concurrency in Pipelines
    处理管道中的并发](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#dealing-with-concurrency-in-pipelines)
  - [Avoiding `NotSerializableException`
    避免 `NotSerializableException`](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/#avoiding-notserializableexception)

This guide provides a small selection of best practices for pipelines and points out the most common mistakes.
本指南提供了一小部分管道最佳实践，并指出了最常见的错误。

The goal is to point pipeline authors and maintainers towards patterns that result in better Pipeline execution and away from pitfalls they might  otherwise not be aware of. This guide is not meant to be an exhaustive list of all possible  Pipeline best practices but instead to provide a number of specific  examples useful in tracking down common practices. Use it as a "do this" generally and not as an incredibly detailed  "how-to".
目标是将 Pipeline 作者和维护者指向能够更好地执行 Pipeline 并远离他们可能没有意识到的陷阱的模式。本指南并不是所有可能的  Pipeline 最佳实践的详尽列表，而是提供一些有助于跟踪常见实践的具体示例。通常将其用作 “do this” ，而不是作为非常详细的  “how-to”。

This guide is arranged by area, guideline, then listing specific examples.
本指南按领域、指南排列，然后列出具体示例。

## General 常规

### Making sure to use Groovy code in Pipelines as glue 确保在 Pipelines 中使用 Groovy 代码作为胶水

Use Groovy code to connect a set of actions rather than as the main  functionality of your Pipeline. In other words, instead of relying on Pipeline functionality (Groovy or  Pipeline steps) to drive the build process forward, use single steps  (such as `sh`) to accomplish multiple parts of the build. Pipelines, as their complexity increases (the amount of Groovy code,  number of steps used, etc.), require more resources (CPU, memory,  storage) on the controller. Think of Pipeline as a tool to accomplish a build rather than the core  of a build.
使用 Groovy 代码连接一组操作，而不是作为 Pipeline 的主要功能。换句话说，不要依赖 Pipeline 功能（Groovy 或 Pipeline 步骤）来推动构建过程向前发展，而是使用单个步骤（例如 `sh`）来完成构建的多个部分。管道，随着其复杂性的增加（Groovy 代码的数量、使用的步骤数等），需要在控制器上获得更多资源（CPU、内存、存储）。将 Pipeline 视为完成构建的工具，而不是构建的核心。

Example: Using a single Maven build step to drive the build through its build/test/deploy process.
示例：使用单个 Maven 构建步骤通过其构建/测试/部署过程来驱动构建。

### Running shell scripts in Jenkins Pipeline 在 Jenkins Pipeline 中运行 shell 脚本

Using a shell script within Jenkins Pipeline can help simplify builds by combining multiple steps into a single stage. The shell script also allows users to add or update commands without having to modify each step or stage separately.
在 Jenkins Pipeline 中使用 shell 脚本可以通过将多个步骤合并到一个阶段来帮助简化构建。shell 脚本还允许用户添加或更新命令，而不必单独修改每个步骤或阶段。

This video reviews using a shell script in Jenkins Pipeline and the benefits it provides.
此视频回顾了在 Jenkins Pipeline 中使用 shell 脚本及其提供的好处。

<iframe width="800" height="420" src="https://www.youtube.com/embed/mbeQWBNaNKQ?rel=0" frameborder="0" allowfullscreen=""></iframe>

### Avoiding complex Groovy code in Pipelines 避免在 Pipelines 中使用复杂的 Groovy 代码

For a Pipeline, Groovy code **always** executes on controller which means using controller resources(memory  and CPU). Therefore, it is critically important to reduce the amount of Groovy  code executed by Pipelines (this includes any methods called on classes  imported in Pipelines). The following are the most common example Groovy methods to avoid using:
对于 Pipeline，Groovy 代码**总是**在控制器上执行，这意味着使用控制器资源（内存和 CPU）。因此，减少 Pipelines 执行的 Groovy 代码量（这包括在 Pipelines 中导入的类上调用的任何方法）是至关重要的。以下是要避免使用的最常见示例 Groovy 方法：

1. **JsonSlurper:** This function (and some other similar ones like XmlSlurper or readFile) can be used to read from a file on disk, parse the data from that file  into a JSON object, and inject that object into a Pipeline using a  command like JsonSlurper().parseText(readFile("$LOCAL_FILE")). This  command loads the local file into memory on the controller twice and, if the file is very large or the command is executed frequently, will  require a lot of memory.
   **JsonSlurper 中：**此函数（以及其他一些类似的函数，如 XmlSlurper 或 readFile）可用于从磁盘上的文件中读取数据，将该文件中的数据解析为 JSON 对象，并使用类似  JsonSlurper（）.parseText（readFile（“$LOCAL_FILE”）） 的命令将该对象注入  Pipeline。此命令将本地文件加载到控制器的内存中两次，如果文件非常大或命令频繁执行，则需要大量内存。
   1. Solution: Instead of using JsonSlurper, use a shell step and return the standard  out. This shell would look something like this: `def JsonReturn = sh label: '', returnStdout: true, script: 'echo "$LOCAL_FILE"| jq "$PARSING_QUERY"'`. This will use agent resources to read the file and the $PARSING_QUERY will help parse down the file into a smaller size.
      解决方案：不要使用 JsonSlurper，而是使用 shell 步骤并返回标准输出。此 shell 将如下所示： `def JsonReturn = sh label: '', returnStdout: true, script: 'echo "$LOCAL_FILE"| jq "$PARSING_QUERY"'` .这将使用代理资源来读取文件，而 $PARSING_QUERY 将帮助将文件解析为更小的大小。
2. **HttpRequest:** Frequently this command is used to grab data from an external source  and store it in a variable. This practice is not ideal because not only  is that request coming directly from the controller (which could give  incorrect results for things like HTTPS requests if the controller does  not have certificates loaded), but also the response to that request is  stored twice.
   **HttpRequest 请求：**此命令通常用于从外部源获取数据并将其存储在变量中。这种做法并不理想，因为不仅该请求直接来自控制器（如果控制器未加载证书，则可能会对 HTTPS 请求等内容产生错误的结果），而且对该请求的响应会存储两次。
   1. Solution: Use a shell step to perform the HTTP request from the agent, for example using a tool like `curl` or `wget`, as appropriate. If the result must be later in the Pipeline, try to  filter the result on the agent side as much as possible so that only the minimum required information must be transmitted back to the Jenkins  controller.
      解决方案：使用 shell 步骤执行来自代理的 HTTP 请求，例如，根据需要使用 `curl` 或 `wget` 等工具。如果结果必须稍后在 Pipeline 中，请尝试尽可能多地过滤 agent 端的结果，以便只有最少的所需信息必须传回 Jenkins 控制器。

### Reducing repetition of similar Pipeline steps 减少类似 Pipeline 步骤的重复

Combine Pipeline steps into single steps as often as possible to reduce the  amount of overhead caused by the Pipeline execution engine itself. For  example, if you run three shell steps back-to-back, each of those steps  has to be started and stopped, requiring connections and resources on  the agent and controller to be created and cleaned up. However, if you  put all of the commands into a single shell step, then only a single  step needs to be started and stopped.
尽可能频繁地将 Pipeline 步骤合并为单个步骤，以减少 Pipeline 执行引擎本身造成的开销。例如，如果您背靠背运行三个 shell  步骤，则必须启动和停止每个步骤，这需要创建和清理代理和控制器上的连接和资源。但是，如果将所有命令放入单个 shell  步骤中，则只需启动和停止一个步骤。

Example: Instead of creating a series of  `echo` or `sh` steps, combine them into a single step or script.
示例：不要创建一系列 `echo` 或 `sh` 步骤，而是将它们合并到一个步骤或脚本中。

### Avoiding calls to `Jenkins.getInstance` 避免调用 `Jenkins.getInstance`

Using Jenkins.instance or its accessor methods in a Pipeline or shared  library indicates a code misuse within that Pipeline/shared library.  Using Jenkins APIs from an unsandboxed shared library means that the  shared library is both a shared library and a kind of Jenkins plugin.  You need to be very careful when interacting with Jenkins APIs from a  Pipeline to avoid severe security and performance issues. If you must  use Jenkins APIs in your build, the recommended approach is to create a  minimal plugin in Java that implements a safe wrapper around the Jenkins API you want to access using Pipeline’s Step API. Using Jenkins APIs  from a sandboxed Jenkinsfile directly means that you have probably had  to whitelist methods that allow sandbox protections to be bypassed by  anyone who can modify a Pipeline, which is a significant security risk.  The whitelisted method is run as the System user, having overall admin  permissions, which can lead to developers possessing higher permissions  than intended.
在 Pipeline 或共享库中使用 Jenkins.instance 或其访问器方法表示该  Pipeline/共享库中的代码滥用。从未沙盒化的共享库中使用 Jenkins API 意味着共享库既是共享库，又是一种 Jenkins  插件。从 Pipeline 与 Jenkins API 交互时，您需要非常小心，以避免严重的安全和性能问题。如果您必须在构建中使用  Jenkins API，建议的方法是在 Java 中创建一个最小的插件，该插件围绕要使用 Pipeline 的 Step API 访问的  Jenkins API 实施安全包装器。直接从沙箱化 Jenkinsfile 使用 Jenkins API  意味着您可能不得不将允许任何可以修改流水线的人绕过沙箱保护的方法列入白名单，这是一个重大的安全风险。列入白名单的方法以 System  用户身份运行，具有总体管理员权限，这可能导致开发人员拥有比预期更高的权限。

Solution: The best solution would be to work around the calls being made, but if  they must be done then it would be better to implement a Jenkins plugin  which is able to gather the data needed.
解决方案：最好的解决方案是解决正在进行的调用，但如果必须完成它们，那么最好实现一个能够收集所需数据的 Jenkins 插件。

### Cleaning up old Jenkins builds 清理旧的 Jenkins 构建

As a Jenkins administrator, removing old or unwanted builds keeps the Jenkins controller running efficiently. When you do not remove older builds, there are less resources for more current and relevant builds. This video reviews using the [`buildDiscarder`](https://www.jenkins.io/doc/book/pipeline/syntax/#options) directive in individual Pipeline jobs. The video also reviews the process to keep specific historical builds.
作为 Jenkins 管理员，删除旧的或不需要的构建可以使 Jenkins 控制器高效运行。如果不删除较旧的版本，则用于更新和相关版本的资源会减少。此视频回顾了在单个 Pipeline 作业中使用 [`buildDiscarder`](https://www.jenkins.io/doc/book/pipeline/syntax/#options) 指令。该视频还回顾了保留特定历史版本的过程。

How to clean up old Jenkins builds
如何清理旧的 Jenkins 构建

<iframe width="800" height="420" src="https://www.youtube.com/embed/_Z7BlaTTGlo?rel=0" frameborder="0" allowfullscreen=""></iframe>

## Using shared libraries 使用共享库

### Do not override built-in Pipeline steps 不要覆盖内置 Pipeline 步骤

Wherever possible stay away from customized/overwritten Pipeline steps. Overriding built-in Pipeline Steps is the process of using shared libraries to overwrite the standard Pipeline APIs like `sh` or `timeout`. This process is dangerous because the Pipeline APIs can change at any  time causing custom code to break or give different results than  expected. When custom code breaks because of Pipeline API changes, troubleshooting is difficult because even if the custom code has not changed, it may  not work the same after an API update. So even if custom code has not changed, that does not mean after an API  update it will keep working the same. Lastly, because of the ubiquitous use of these steps throughout  Pipelines, if something is coded incorrectly/inefficiently the results  can be catastrophic to Jenkins.
尽可能远离自定义/覆盖的 Pipeline 步骤。覆盖内置 Pipeline Steps 是使用共享库覆盖标准 Pipeline API（如 `sh` 或 `timeout`）的过程。此过程很危险，因为 Pipeline API 可能随时更改，从而导致自定义代码中断或给出与预期不同的结果。当自定义代码因 Pipeline API  更改而中断时，故障排除很困难，因为即使自定义代码未更改，它在 API 更新后也可能无法正常工作。因此，即使自定义代码没有更改，也不意味着在  API 更新后它会保持原样工作。最后，由于这些步骤在整个 Pipelines 中无处不在，如果某些内容编码错误/效率低下，结果可能会对  Jenkins 造成灾难性的影响。

### Avoiding large global variable declaration files 避免使用大型全局变量声明文件

Having large variable declaration files can require large amounts of memory  for little to no benefit, because the file is loaded for every Pipeline  whether the variables are needed or not. Creating small variable files  that contain only variables relevant to the current execution is  recommended.
拥有大型变量声明文件可能需要大量内存，但几乎没有好处，因为无论是否需要变量，都会为每个 Pipeline 加载该文件。建议创建仅包含与当前执行相关的变量的小变量文件。

### Avoiding very large shared libraries 避免非常大的共享库

Using large shared libraries in Pipelines requires checking out a very large  file before the Pipeline can start and loading the same shared library  per job that is currently executing, which can lead to increased memory  overhead and slower execution time.
在 Pipelines 中使用大型共享库需要在 Pipeline 启动之前签出一个非常大的文件，并为每个当前正在执行的作业加载相同的共享库，这可能会导致内存开销增加和执行时间变慢。

## Answering additional FAQs 回答其他常见问题

### Dealing with Concurrency in Pipelines 处理管道中的并发

Try not to share workspaces across multiple Pipeline executions or multiple distinct Pipelines. This practice can lead to either unexpected file modification within each Pipeline or workspace renaming.
尽量不要在多个 Pipeline 执行或多个不同的 Pipelines 之间共享工作区。这种做法可能会导致每个 Pipeline 中的意外文件修改或工作区重命名。

Ideally, shared volumes/disks are mounted in a separate place and the files are copied from that place to the current workspace. Then when the build is done the files can be copied back if there were updates done.
理想情况下，共享卷/磁盘安装在单独的位置，并将文件从该位置复制到当前工作区。然后，当构建完成时，如果完成了更新，则可以将文件复制回来。

Build in distinct containers which create needed resources from  scratch(cloud-type agents work great for this). Building these containers will ensure that the build process begins at  the start every time and is easily repeatable. If building containers will not work, disable concurrency on the  Pipeline or use the Lockable Resources Plugin to lock the workspace when it is running so that no other builds can use it while it is locked. **WARNING**: Disabling concurrency or locking the workspace when it is running can  cause Pipelines to become blocked when waiting on resources if those  resources are arbitrarily locked.
构建不同的容器，从头开始创建所需的资源（云类型的代理非常适合此）。构建这些容器将确保构建过程每次都从头开始，并且易于重复。如果构建容器不起作用，请在 Pipeline 上禁用并发，或使用 Lockable Resources Plugin  在工作区运行时锁定工作区，以便在工作区锁定时其他构建无法使用它。**警告**：如果工作区被任意锁定，则在工作区运行时禁用并发或锁定工作区可能会导致管道在等待资源时被阻止。

**Also, be aware that both of these methods have slower time to results of builds than using unique resources for each job
此外，请注意，与为每个作业使用唯一资源相比，这两种方法获得生成结果的时间都要慢**

### Avoiding `NotSerializableException` 避免 `NotSerializableException`

Pipeline code is CPS-transformed so that Pipelines are able to resume after a  Jenkins restart. That is, while the pipeline is running your script, you can shut down  Jenkins or lose connectivity to an agent. When it comes back, Jenkins remembers what it was doing and your  pipeline script resumes execution as if it were never interrupted. A technique known as "[continuation-passing style (CPS)](https://en.wikipedia.org/wiki/Continuation-passing_style)" execution plays a key role in resuming Pipelines. However, some Groovy expressions do not work correctly as a result of CPS transformation.
管道代码经过 CPS 转换，以便管道能够在 Jenkins 重启后恢复。也就是说，当管道正在运行您的脚本时，您可以关闭 Jenkins  或失去与代理的连接。当它返回时，Jenkins 会记住它正在做什么，并且您的管道脚本会恢复执行，就像它从未中断一样。一种称为“[延续传递样式 （CPS）”](https://en.wikipedia.org/wiki/Continuation-passing_style)执行的技术在恢复 Pipelines 中起着关键作用。但是，由于 CPS 转换，某些 Groovy 表达式无法正常工作。

Under the hood, CPS relies on being able to serialize the pipeline’s current  state along with the remainder of the pipeline to be executed. This means that using Objects in the pipeline that are not serializable  will trigger a `NotSerializableException` to be thrown when the pipeline attempts to persist its state.
在后台，CPS 依赖于能够序列化管道的当前状态以及要执行的管道的其余部分。这意味着，在管道中使用不可序列化的对象将在管道尝试保留其状态时触发 `NotSerializableException`。

See [Pipeline CPS method mismatches](https://www.jenkins.io/redirect/pipeline-cps-method-mismatches) for more details and some examples of things that may be problematic.
有关更多详细信息和可能存在问题的一些示例，请参阅[管道 CPS 方法不匹配](https://www.jenkins.io/redirect/pipeline-cps-method-mismatches)。

Below will cover techniques to ensure the pipeline can function as expected.
下面将介绍确保管道能够按预期运行的技术。

#### Ensure Persisted Variables Are Serializable 确保持久化变量是可序列化的

Local variables are captured as part of the pipeline’s state during serialization. This means that storing non-serializable objects in variables during pipeline execution will result in a `NotSerializableException` to be thrown.
在序列化期间，局部变量将作为管道状态的一部分进行捕获。这意味着在管道执行期间将不可序列化的对象存储在变量中将导致引发 `NotSerializableException`。

#### Do not assign non-serializable objects to variables 不要将不可序列化的对象分配给变量

One strategy to make use of non-serializable objects to always infer their  value "just-in-time" instead of calculating their value and storing that value in a variable.
一种策略是利用不可序列化的对象来始终“实时”推断它们的值，而不是计算它们的值并将该值存储在变量中。

#### Using `@NonCPS` 使用 `@NonCPS`

If necessary, you can use the `@NonCPS` annotation to disable the CPS transformation for a specific method  whose body would not execute correctly if it were CPS-transformed. Just be aware that this also means the Groovy function will have to  restart completely since it is not transformed.
如有必要，您可以使用 `@NonCPS` 注释来禁用特定方法的 CPS 转换，如果经过 CPS 转换，其主体将无法正确执行。请注意，这也意味着 Groovy 函数将不得不完全重新启动，因为它没有被转换。

|      | Asynchronous Pipeline steps (such as `sh` and `sleep`) are always CPS-transformed, and may not be used inside of a method annotated with `@NonCPS`. In general, you should avoid using pipeline steps inside of methods annotated with `@NonCPS` 异步管道步骤（例如 `sh` 和 `sleep`）始终是 CPS 转换的，不能在用 `@NonCPS` 注释的方法中使用。通常，应避免在使用 `@NonCPS` 注释的方法中使用管道步骤 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

#### Pipeline Durability 管道耐久性

It is noteworthy that changing the pipeline’s durability can result in `NotSerializableException` not being thrown where they otherwise would have been. This is because decreasing the pipeline’s durability through  PERFORMANCE_OPTIMIZED means that the pipeline’s current state is  persisted significantly less frequently. Therefore, the pipeline never attempts to serialize the non-serializable values and as such, no exception is thrown.
值得注意的是，更改管道的持久性可能会导致 `NotSerializableException` 不会在原本应引发的位置引发。这是因为通过PERFORMANCE_OPTIMIZED降低管道的持久性意味着管道的当前状态的保留频率要低得多。因此，管道从不尝试序列化不可序列化的值，因此不会引发异常。

|      | This note exists to inform users as to the root cause of this behavior. It is not recommended that the Pipeline’s durability setting be set to  Performance Optimized purely to avoid serializability issues. 此说明旨在告知用户此行为的根本原因。不建议将 Pipeline 的持久性设置设置为 Performance Optimized，以避免出现可序列化性问题。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

# Scaling Pipelines 扩展管道

Table of Contents 目录

- [How Do I Set Speed/Durability Settings?
  如何设置速度/耐久度设置？](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#how-do-i-set-speeddurability-settings)
- [Will Higher-Performance Durability Settings Help Me?
  更高性能的持久性设置对我有帮助吗？](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#will-higher-performance-durability-settings-help-me)
- [What Am I Giving Up With This Durability Setting "Trade-Off?"
  我放弃了什么耐久度设置“权衡”？](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#what-am-i-giving-up-with-this-durability-setting-trade-off)
- [Requirements To Use Durability Settings
  使用耐久性设置的要求](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#requirements-to-use-durability-settings)
- [What Are The Durability Settings?
  什么是耐久性设置？](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#what-are-the-durability-settings)
- [Suggested Best Practices And Tips for Durability Settings
  建议的耐久性设置最佳实践和提示](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#suggested-best-practices-and-tips-for-durability-settings)
- [Other Scaling Suggestions
  其他缩放建议](https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/#other-scaling-suggestions)

One of the main bottlenecks in Pipeline is that it writes transient data to disk **FREQUENTLY** so that running pipelines can handle an unexpected Jenkins restart or  system crash. This durability is useful for many users but its  performance cost can be a problem.
Pipeline 的主要瓶颈之一是它**频繁**地将瞬态数据写入磁盘，以便正在运行的管道可以处理意外的 Jenkins 重启或系统崩溃。这种持久性对许多用户很有用，但其性能成本可能是一个问题。

Pipeline now includes features to let users improve performance by reducing how  much data is written to disk and how often it is written — at a small  cost to durability.  In some special cases, users may not be able to  resume or visualize running Pipelines if Jenkins shuts down suddenly  without getting a chance to write data.
Pipeline 现在包含一些功能，允许用户通过减少写入磁盘的数据量和写入频率来提高性能，而持久性的成本很小。在某些特殊情况下，如果 Jenkins 突然关闭而没有机会写入数据，用户可能无法恢复或可视化正在运行的 Pipelines。

Because these settings include a trade-off of speed vs. durability, they are  initially opt-in.  To enable performance-optimized modes, users need to  explicitly set a *Speed/Durability Setting* for Pipelines.  If no explicit choice is made, pipelines currently  default to the "maximum durability" setting and write to disk as they  have in the past.  There are some I/O optimizations to this mode  included in the same plugin releases, but the benefits are much smaller.
由于这些设置包括速度与持久性的权衡，因此它们最初是可选的。要启用性能优化模式，用户需要为 Pipelines 显式设置 *Speed/Durability Setting*。如果未做出明确选择，则管道当前默认为“最大持久性”设置，并像过去一样写入磁盘。相同的插件版本中包含了此模式的一些 I/O 优化，但好处要小得多。

## How Do I Set Speed/Durability Settings? 如何设置速度/耐久度设置？

There are 3 ways to configure the durability setting:
有 3 种方法可以配置持续性设置：

1. **Globally**, you can choose a global default durability setting under "Manage  Jenkins" > "System", labelled "Pipeline Speed/Durability Settings".   You can override these with the more specific settings below.
   **在全局范围内**，您可以在“Manage Jenkins”> “System”下选择全局默认持久性设置，标记为“Pipeline Speed/Durability Settings”。您可以使用下面更具体的设置来覆盖这些设置。
2. **Per pipeline job:** at the top of the job configuration, labelled "Custom Pipeline  Speed/Durability Level" - this overrides the global setting.  Or, use a  "properties" step - the setting will apply to the NEXT run after the  step is executed (same result).
   **每个管道作业：**在作业配置的顶部，标记为“自定义管道速度/持久性级别”，这将覆盖全局设置。或者，使用“属性”步骤 - 该设置将在执行步骤后应用于 NEXT 运行（相同的结果）。
3. **Per-branch for a multibranch project:** configure a custom Branch Property Strategy (under the SCM) and add a  property for Custom Pipeline Speed/Durability Level.  This overrides the global setting. You can also use a "properties" step to override the  setting, but remember that you may have to run the step again to undo  this.
   **多分支项目的按分支：**配置自定义分支属性策略（在 SCM 下）并添加自定义管道速度/持久性级别的属性。这将覆盖全局设置。您还可以使用 “properties” 步骤来覆盖设置，但请记住，您可能需要再次运行该步骤才能撤消此操作。

Durability settings will take effect with the next applicable Pipeline run, not  immediately.  The setting will be displayed in the log.
持久性设置将在下一次适用的 Pipeline 运行时生效，而不是立即生效。该设置将显示在日志中。

## Will Higher-Performance Durability Settings Help Me? 更高性能的持久性设置对我有帮助吗？

- Yes, if your Jenkins controller uses NFS, magnetic storage, runs many Pipelines at once, or shows high iowait.
  是的，如果您的 Jenkins 控制器使用 NFS、磁性存储、同时运行多个 Pipelines 或显示高 iowait。
- Yes, if you are running Pipelines with many steps (more than several hundred).
  是的，如果你运行的 Pipelines 包含许多步骤（超过几百个）。
- Yes, if your Pipeline stores large files or complex data to variables in the script, keeps that variable in scope for future use, and then runs  steps.  This sounds oddly specific but happens more than you’d expect.
  是的，如果您的 Pipeline 将大型文件或复杂数据存储到脚本中的变量中，将该变量保留在范围内以备将来使用，然后运行步骤。这听起来很奇怪具体，但发生得比你预期的要多。
  - For example: `readFile` step with a large XML/JSON file, or using configuration information from parsing such a file with [One of the Utility Steps](https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/#code-readjson-code-read-json-from-files-in-the-workspace).
    例如：`readFile` 步骤，或者使用其中一个[实用程序步骤](https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/#code-readjson-code-read-json-from-files-in-the-workspace)解析此类文件时的配置信息。
  - Another common pattern is a "summary" object containing data from many branches (logs, results, or statistics). Often this is visible because you’ll be adding to it often via an add/append or `Map.put()` operations.
    另一种常见模式是包含来自许多分支（日志、结果或统计信息）的数据的 “summary” 对象。这通常是可见的，因为您通常会通过 add/append 或 `Map.put（）` 操作来添加它。
  - Large arrays of data or `Map`s of configuration information are another common example of this situation.
    大型数据数组或配置信息的 `Map`是这种情况的另一个常见示例。
- No, if your Pipelines spend almost all their time waiting for a few  shell/batch scripts to finish.  This ISN’T a magic "go fast" button for  everything!
  否，如果您的 Pipelines 几乎花费了所有时间等待几个 shell/batch 脚本完成。这不是一个神奇的“快速”按钮！
- No, if Pipelines are writing massive amounts of data to logs (logging is unchanged).
  否，如果 Pipelines 将大量数据写入日志（日志记录保持不变）。
- No, if you are not using Pipelines, or your system is loaded down by other factors.
  否，如果您未使用 Pipelines，或者您的系统被其他因素拖累。
- No, if you don’t enable higher-performance modes for pipelines.
  不，如果您不为管道启用更高性能的模式。

## What Am I Giving Up With This Durability Setting "Trade-Off?" 我放弃了什么耐久度设置“权衡”？

**Stability of Jenkins ITSELF is not changed regardless of this setting** - it only applies to Pipelines.  The worst-case behavior for Pipelines  reverts to something like Freestyle builds — running Pipelines that  cannot persist transient data may not be able to resume or be displayed  in Blue Ocean/Stage View/etc, but will show logs.  This impacts *only* running Pipelines and only when Jenkins is shut down abruptly and not gracefully before they get to complete.
**无论此设置如何，Jenkins 本身的稳定性都不会改变** - 它仅适用于 Pipelines。Pipelines 的最坏情况行为会恢复到 Freestyle 构建之类的行为——运行无法持久化瞬态数据的 Pipelines 可能无法恢复或显示在 Blue Ocean/Stage View/etc 中，但会显示日志。这*仅*影响正在运行的管道，并且仅影响 Jenkins 在完成之前突然关闭且不正常关闭的情况。

A **"graceful" shutdown** is where Jenkins goes through a full shutdown process, such as visiting http://[jenkins-server]/exit,  or using normal service shutdown scripts (if Jenkins is healthy).  Sending a SIGTERM/SIGINT to Jenkins will  trigger a graceful shutdown.  Note that running Pipelines do not need to complete (you do not need to use /safeExit to shut down).
**“正常”关闭**是 Jenkins 经历完全关闭过程的地方，例如访问 http://[jenkins-server]/exit，或使用正常的服务关闭脚本（如果  Jenkins 运行正常）。向 Jenkins 发送 SIGTERM/SIGINT 将触发正常关闭。请注意，运行 Pipelines  不需要完成（您无需使用 /safeExit 来关闭）。

A **"dirty" shutdown** is when Jenkins does not get to do normal shutdown processes. This can  occur if the process is forcibly terminated.  The most common causes are using SIGKILL to terminate the Jenkins process or killing the  container/VM running Jenkins.  Simply stopping or pausing the  container/VM will not cause this, as long as the Jenkins process is able to resume. A dirty shutdown can also happen due to catastrophic operating system  failures, including the Linux OOMKiller attacking the Jenkins java  process to free memory.
**“脏”关闭**是指 Jenkins 无法执行正常的关闭过程。如果进程被强制终止，则可能会发生这种情况。最常见的原因是使用 SIGKILL 终止 Jenkins  进程或杀死运行 Jenkins 的容器/VM。只要 Jenkins 进程能够恢复，简单地停止或暂停容器/VM  就不会导致这种情况。灾难性的操作系统故障也可能发生异常关闭，包括 Linux OOMKiller 攻击 Jenkins java  进程以释放内存。

**Atomic writes:** All settings **except** "maximum durability" currently avoid atomic writes — what this means is that if the operating system running Jenkins fails, data that is  buffered for writing to disk will not be flushed, it will be lost.  This is quite rare, but can happen as a result of container or  virtualization operations that halt the operating system or disconnect  storage.  Usually this data is flushed pretty quickly to disk, so the  window for data loss is brief.  On Linux this flush-to-disk can be  forced by running 'sync'.  In some rare cases this can also result in a  build that cannot be loaded.
**Atomic 写道：****目前，除了** “maximum durability” 之外的所有设置都避免了原子写入 — 这意味着，如果运行 Jenkins  的操作系统出现故障，为写入磁盘而缓冲的数据将不会被刷新，而是会丢失。这种情况非常罕见，但可能是由于容器或虚拟化操作会停止操作系统或断开存储连接而发生的。通常，这些数据会很快刷新到磁盘，因此数据丢失的窗口很短。在 Linux 上，可以通过运行 'sync' 来强制此 flush-to-disk。在极少数情况下，这也可能导致无法加载生成。

## Requirements To Use Durability Settings 使用耐久性设置的要求

- Jenkins LTS 2.73+ or higher (or a weekly 2.62+)
  Jenkins LTS 2.73+ 或更高版本（或每周 2.62+）
- For **all** the Pipeline plugins below, at least the specified minimum version must be installed
  对于下面的**所有** Pipeline 插件，必须至少安装指定的最低版本
  - Pipeline: API (workflow-api) v2.25
    管道：API （workflow-api） v2.25
  - Pipeline: Groovy (workflow-cps) v2.43
    管道：Groovy （workflow-cps） v2.43
  - Pipeline: Job (workflow-job) v2.17
    管道：作业 （workflow-job） v2.17
  - Pipeline: Supporting APIs (workflow-support) v2.17
    管道：支持 API （workflow-support） v2.17
  - Pipeline: Multibranch (workflow-multibranch) v2.17 - optional, only needed to enable this setting for multibranch pipelines.
    管道：多分支 （workflow-multibranch） v2.17 - 可选，只需为多分支管道启用此设置。
- Restart the controller to use the updated plugins - note: you need all of them to take advantage.
  重新启动控制器以使用更新的插件 - 注意：您需要所有这些插件才能利用。

## What Are The Durability Settings? 什么是耐久性设置？

- Performance-optimized mode ("PERFORMANCE_OPTIMIZED") - **Greatly** reduces disk I/O.  If Pipelines do not finish AND Jenkins is not shut  down gracefully, they may lose data and behave like Freestyle  projects — see details above.
  性能优化模式（“PERFORMANCE_OPTIMIZED”）- **大大**减少了磁盘 I/O。如果 Pipelines 没有完成并且 Jenkins 没有正常关闭，它们可能会丢失数据并表现得像 Freestyle 项目 — 请参阅上面的详细信息。
- Maximum survivability/durability ("MAX_SURVIVABILITY") - behaves just like  Pipeline did before, slowest option.  Use this for running your most  critical Pipelines.
  最大生存能力/耐久度 （“MAX_SURVIVABILITY”） - 就像 Pipeline 之前的行为一样，是最慢的选项。使用它来运行您最关键的 Pipelines。
- Less durable, a bit faster ("SURVIVABLE_NONATOMIC") - Writes data with every step but avoids atomic writes. This is faster than maximum durability  mode, especially on networked filesystems.  It carries a small extra  risk (details above under "What Am I Giving Up: Atomic Writes").
  持久性较差，速度稍快（“SURVIVABLE_NONATOMIC”） - 每一步都写入数据，但避免原子写入。这比 maximum durability 模式更快，尤其是在联网文件系统上。它有一个小的额外风险（详见上面的“我放弃了什么：原子写入”）。

## Suggested Best Practices And Tips for Durability Settings 建议的耐久性设置最佳实践和提示

- Use the "performance-optimized" mode for most pipelines and especially  basic build-test Pipelines or anything that can simply be run again if  needed.
  对大多数管道使用“性能优化”模式，尤其是基本的构建测试管道或任何可以在需要时再次运行的内容。
- Use either the "maximum durability" or "less durable" mode for pipelines  when you need a guaranteed record of their execution (auditing). These  two modes record every step run. For example, use one of these two modes when:
  当您需要管道的执行 （审计） 的保证记录时，请对管道使用“最大持久性”或“较不持久”模式。这两种模式记录每一步运行。例如，在以下情况下使用以下两种模式之一：
  - you have a pipeline that modifies the state of critical infrastructure
    您有一个修改关键基础设施状态的管道
  - you do a production deployment
    您执行生产部署
- Set a global default (see above) of "performance-optimized" for the  Durability Setting, and then where needed set "maximum durability" on  specific Pipeline jobs or Multibranch Pipeline branches ("master" or  release branches).
  为 Durability Setting （持久性设置） 设置全局默认值 （见上文）  “performance-optimized”，然后根据需要在特定 Pipeline 作业或 Multibranch Pipeline  分支（“master” 或 release branches）上设置“最大持久性”。
- You can force a Pipeline to persist data by pausing it.
  您可以通过暂停 Pipeline 来强制 Pipeline 保留数据。

## Other Scaling Suggestions 其他缩放建议

- Use @NonCPS-annotated functions for more complex work. This means more  involved processing, logic, and transformations. This lets you leverage  additional Groovy & functional features for more powerful, concise,  and performant code.
  使用@NonCPS注释的函数进行更复杂的工作。这意味着涉及更多处理、逻辑和转换。这使您可以利用额外的Groovy和功能特性来编写更强大、更简洁、更高性能的代码。
  - This still runs on controller so be aware of complexity of the work, but is  much faster than native Pipeline code because it doesn’t provide  durability and uses a faster execution model. Still, be mindful of the  CPU cost and offload to executors when the cost becomes too high.
    这仍然在控制器上运行，因此请注意工作的复杂性，但比原生 Pipeline 代码快得多，因为它不提供持久性并使用更快的执行模型。不过，请注意 CPU 成本，并在成本变得过高时卸载到执行程序。
  - @NonCPS functions can use a much broader subset of the Groovy language, such as iterators and functional features, which makes them more terse and fast to write.
    @NonCPS函数可以使用 Groovy 语言的更广泛的子集，例如迭代器和功能特性，这使得它们更简洁、更快速。
  - @NonCPS functions **should not use** Pipeline steps internally, however you can store the result of a  Pipeline step to a variable and use it that as the input to a @NonCPS  function.
    @NonCPS 函数不应在内部**使用** Pipeline 步骤，但是您可以将 Pipeline 步骤的结果存储到变量中，并将其用作 @NonCPS 函数的输入。
    - **Gotcha**: It’s not guaranteed that use of a step will generate an error (there is an open RFE to implement that), but you should not rely on that  behavior. You may see improper handling of exceptions.
      **Gotcha**：不能保证使用步骤会产生错误（有一个开放的 RFE 来实现它），但你不应该依赖该行为。您可能会看到异常处理不当。
  - While normal Pipeline is restricted to serializable local variables, @NonCPS  functions can use more complex, nonserializable types internally (for  example regex matchers, etc). Parameters and return types should still  be Serializable, however.
    虽然普通的 Pipeline 仅限于可序列化的局部变量，但@NonCPS函数可以在内部使用更复杂的、不可序列化的类型（例如正则表达式匹配器等）。但是，参数和返回类型仍应为 Serializable。
    - **Gotcha**: improper usages are not guaranteed to raise an error with normal  Pipeline (optimizations may mask the issue), but it is unsafe to rely on this behavior.
      **陷阱**：不保证不正确的使用会在正常 Pipeline 中引发错误（优化可能会掩盖问题），但依赖此行为是不安全的。
  - **General Gotcha**: when using running @NonCPS functions, the actual error can sometimes be swallowed by pipeline creating a confusing error message. Combat this  by using a `try/catch` block and potentially using an `echo` to plain text print the error message in the `catch`
    **一般问题**：当使用正在运行的 @NonCPS 函数时，实际错误有时会被管道吞噬，从而产生令人困惑的错误消息。通过使用 `try/catch` 块并可能使用 `echo` 在 `catch` 中以纯文本形式打印错误消息来解决此问题
- **Whenever possible, run Jenkins with fast SSD-backed storage and not hard drives.  This can make a \*huge\* difference.
  尽可能使用快速的 SSD 型存储而不是硬盘驱动器运行 Jenkins。这会产生\*巨大的\*影响。**
- In general try to fit the tool to the job.  Consider writing short  Shell/Batch/Groovy/Python scripts when running a complex process using a build agent.  Good examples include processing data, communicating  interactively with REST APIs, and parsing/templating larger XML or JSON  files.  The `sh` and `bat` steps are helpful to invoke these, especially with `returnStdout: true` to return the output from this script and save it as a variable (Scripted Pipeline).
  通常，请尝试使该工具适合工作。在使用构建代理运行复杂流程时，请考虑编写简短的 Shell/Batch/Groovy/Python 脚本。很好的示例包括处理数据、与 REST API 交互通信以及解析/模板化较大的 XML 或 JSON 文件。`sh` 和 `bat` 步骤有助于调用这些步骤，尤其是使用 `returnStdout： true` 返回此脚本的输出并将其保存为变量（脚本化管道）。
  - The Pipeline DSL is not designed for arbitrary networking and computation tasks - it is intended for CI/CD scripting.
    Pipeline DSL 不是为任意网络和计算任务而设计的，而是用于 CI/CD 脚本编写的。
- Use the latest versions of the Pipeline plugins and Script Security, if  applicable.  These include regular performance improvements.
  使用最新版本的 Pipeline 插件和 Script Security（如果适用）。其中包括定期的性能改进。
- Try to simplify Pipeline code by reducing the number of steps run and using simpler Groovy code for Scripted Pipelines.
  尝试通过减少运行的步骤数和对脚本化管道使用更简单的 Groovy 代码来简化 Pipeline 代码。
- Consolidate sequential steps of the same type if you can, for example by using one  Shell step to invoke a helper script rather than running many steps.
  如果可以，请合并相同类型的连续步骤，例如，使用一个 Shell 步骤调用帮助程序脚本，而不是运行多个步骤。
- Try to limit the amount of data written to logs by Pipelines.  If you are  writing several MB of log data, such as from a build tool, consider  instead writing this to an external file, compressing it, and archiving  it as a build artifact.
  尝试限制 Pipelines 写入日志的数据量。如果要写入数 MB 的日志数据（例如从构建工具写入），请考虑将其写入外部文件，对其进行压缩，并将其作为构建构件存档。
- When using Jenkins with more than 6 GB of heap use the [suggested garbage collection tuning options](https://www.jenkins.io/blog/2016/11/21/gc-tuning/) to minimize garbage collection pause times and overhead.
  当使用具有超过 6 GB 堆的 Jenkins 时，请使用[建议的垃圾回收优化选项](https://www.jenkins.io/blog/2016/11/21/gc-tuning/)来最大限度地减少垃圾回收暂停时间和开销。

# Pipeline CPS Method Mismatches  管道 CPS 方法不匹配

Table of Contents 目录

- Common problems and solutions
  常见问题和解决方案
  - [Use of Pipeline steps from `@NonCPS`
    使用 `@NonCPS` 中的 Pipeline 步骤](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#use-of-pipeline-steps-fromnoncps)
  - [Calling non-CPS-transformed methods with CPS-transformed arguments
    使用 CPS 转换的参数调用非 CPS 转换的方法](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#calling-non-cps-transformed-methods-with-cps-transformed-arguments)
  - [Constructors 建设者](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#constructors)
  - [Overrides of non-CPS-transformed methods
    非 CPS 转换方法的覆盖](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#overrides-of-non-cps-transformed-methods)
  - [Closures inside `GString`
    `GString` 内部的闭包 ](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#PipelineCPSmethodmismatches-ClosuresinsideGString)
- [False Positives 误报](https://www.jenkins.io/doc/book/pipeline/cps-method-mismatches/#false-positives)

Jenkins Pipeline uses a library called Groovy CPS to run Pipeline scripts. While Pipeline uses the Groovy parser and compiler, unlike a regular  Groovy environment it runs most of the program inside a special  interpreter. This uses a continuation-passing style (CPS) transform to turn your code into a version that can save its current state to disk (a file called `program.dat` inside your build directory) and continue running even after Jenkins has restarted. (You can get some more technical background on the [Pipeline: Groovy plugin page](https://plugins.jenkins.io/workflow-cps) and the [library page](https://github.com/cloudbees/groovy-cps/blob/master/README.md).)
Jenkins Pipeline 使用名为 Groovy CPS 的库来运行 Pipeline 脚本。虽然 Pipeline 使用 Groovy  解析器和编译器，但与常规 Groovy 环境不同，它在特殊的解释器中运行大部分程序。它使用延续传递样式 （CPS）  转换将代码转换为可以将其当前状态保存到磁盘的版本（生成目录中名为 `program.dat` 的文件），并在 Jenkins 重新启动后继续运行。（您可以在 [Pipeline： Groovy 插件页面](https://plugins.jenkins.io/workflow-cps)和[库页面上](https://github.com/cloudbees/groovy-cps/blob/master/README.md)获得更多技术背景。

While the CPS transform is usually transparent to users, there are  limitations to what Groovy language constructs can be supported, and in  some circumstances it can lead to counterintuitive behavior. [JENKINS-31314](https://issues.jenkins.io/browse/JENKINS-31314) makes the runtime try to detect the most common mistake: calling CPS-transformed code from non-CPS-transformed code. The following kinds of things are CPS-transformed:
虽然 CPS 转换通常对用户是透明的，但可以支持的 Groovy 语言结构存在限制，在某些情况下，它可能会导致违反直觉的行为。[JENKINS-31314](https://issues.jenkins.io/browse/JENKINS-31314) 使运行时尝试检测最常见的错误：从非 CPS 转换的代码调用 CPS 转换的代码。以下类型的事物是 CPS 转换的：

- Almost all of the Pipeline script you write (including in libraries)
  您编写的几乎所有 Pipeline 脚本（包括在库中）
- Most Pipeline steps, including all those which take a block
  大多数 Pipeline 步骤，包括所有采用 block 的步骤

The following kinds of things are *not* CPS-transformed:
以下类型的事物*不会*经过 CPS 转换：

- Compiled Java bytecode, including
  编译后的 Java 字节码，包括
  - the Java Platform Java 平台
  - Jenkins core and plugins Jenkins 核心和插件
  - the runtime for the Groovy language
    Groovy 语言的运行时
- Constructor bodies in your Pipeline script
  Pipeline 脚本中的构造函数主体
- Any method in your Pipeline script marked with the `@NonCPS` annotation
  Pipeline 脚本中标有 `@NonCPS` 注释的任何方法
- A few Pipeline steps which take no block and act instantaneously, such as `echo` or `properties`
  一些 Pipeline 步骤，它们不占用任何块并立即执行操作，例如 `echo` 或 `properties`

CPS-transformed code may call non-CPS-transformed code or other CPS-transformed code,  and non-CPS-transformed code may call other non-CPS-transformed code,  but non-CPS-transformed code **may not** call CPS-transformed code. If you try to call CPS-transformed code from non-CPS-transformed code,  the CPS interpreter is unable to operate correctly, resulting in  incorrect and often confusing results.
CPS 转换的代码可以调用非 CPS 转换的代码或其他 CPS 转换的代码，非 CPS 转换的代码可以调用其他非 CPS 转换的代码，但非 CPS 转换的代码**不能**调用 CPS 转换的代码。如果尝试从非 CPS 转换的代码调用 CPS 转换的代码，则 CPS 解释器无法正确操作，从而导致不正确且经常令人困惑的结果。

## Common problems and solutions 常见问题和解决方案

### Use of Pipeline steps from `@NonCPS` 使用 `@NonCPS` 中的 Pipeline 步骤

Sometimes users will apply the `@NonCPS`  annotation to a method definition in order to bypass the CPS transform  inside that method. This can be done to work around limitations in Groovy language coverage  (since the body of the method will execute using the native Groovy  semantics), or to get better performance (the interpreter imposes a  substantial overhead). However, such methods must not call CPS-transformed code such as  Pipeline steps. For example, the following will not work:
有时，用户会将 `@NonCPS` 注释应用于方法定义，以便绕过该方法中的 CPS 转换。这样做可以解决 Groovy 语言覆盖率的限制（因为方法的主体将使用本机 Groovy  语义执行），或者获得更好的性能（解释器会带来大量开销）。但是，此类方法不得调用 CPS 转换的代码，例如 Pipeline  步骤。例如，以下操作将不起作用：

```
@NonCPS
def compileOnPlatforms() {
  ['linux', 'windows'].each { arch ->
    node(arch) {
      sh 'make'
    }
  }
}
compileOnPlatforms()
```

Using the `node` or `sh` steps from this method is illegal, and the behavior will be anomalous. The warning in the logs from running this script looks like this:
使用此方法中的 `node` 或 `sh` 步骤是非法的，并且行为将是异常的。运行此脚本的日志中的警告如下所示：

> expected to call WorkflowScript.compileOnPlatforms but wound up catching node
> 预期调用 WorkflowScript.compileOnPlatforms，但最终捕获了节点

To fix this case, simply remove the annotation — it was not needed. (Longtime Pipeline users might have thought it was, prior to the fix of [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481).)
要修复这种情况，只需删除注释 — 它不需要。（在 [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481) 修复之前，Pipeline 的长期用户可能认为是这样。

### Calling non-CPS-transformed methods with CPS-transformed arguments 使用 CPS 转换的参数调用非 CPS 转换的方法

Some Groovy and Java methods take complex types as parameters to support dynamic behavior. A common case is sorting methods that allow callers to specify a method to use for comparing objects ([JENKINS-44924](https://issues.jenkins.io/browse/JENKINS-44924)). Many similar methods in the Groovy standard library work correctly after the fix for [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481), but some methods remain unfixed. For example, the following will not work:
某些 Groovy 和 Java 方法将复杂类型作为参数以支持动态行为。一种常见的情况是排序方法，它允许调用者指定用于比较对象的方法 （[JENKINS-44924](https://issues.jenkins.io/browse/JENKINS-44924)）。修复 [JENKINS-26481](https://issues.jenkins.io/browse/JENKINS-26481) 后，Groovy 标准库中的许多类似方法都可以正常工作，但有些方法仍未修复。例如，以下操作将不起作用：

```
def sortByLength(List<String> list) {
  list.toSorted { a, b -> Integer.valueOf(a.length()).compareTo(b.length()) }
}
def sorted = sortByLength(['333', '1', '4444', '22'])
echo(sorted.toString())
```

The closure passed to `Iterable.toSorted` is CPS-transformed, but `Iterable.toSorted` itself is not CPS-transformed internally, so this will not work as intended. The current behavior is that the return value of the call to `toSorted` will be the return value of the first call to the closure. In the example, this results in `sorted` being set to `-1`, and the warning in the logs looks like this:
传递给 `Iterable.toSorted` 的闭包是 CPS 转换的，但 `Iterable.toSorted` 本身内部没有 CPS 转换，因此这不会按预期工作。当前的行为是，对 `toSorted` 的调用的返回值将是对闭包的第一次调用的返回值。在示例中，这会导致 `sorted` 设置为 `-1`，日志中的警告如下所示：

> expected to call java.util.ArrayList.toSorted but wound up catching org.jenkinsci.plugins.workflow.cps.CpsClosure2.call
> 预期调用 java.util.ArrayList.toSorted，但最终捕获了 org.jenkinsci.plugins.workflow.cps.CpsClosure2.call

To fix this case, any argument passed to these methods must not be CPS-transformed. This can be accomplished by encapsulating the problematic method (`Iterable.toSorted` in the example) inside another method, and annotating the outer method with `@NonCPS`, or by creating an explicit class definition for the closure and annotating all methods on that class with `@NonCPS`.
若要解决此问题，传递给这些方法的任何参数都不得进行 CPS 转换。这可以通过将有问题的方法（示例中的 `Iterable.toSorted`）封装在另一个方法中，并用 `@NonCPS` 注释外部方法，或者通过为闭包创建一个显式的类定义并使用 `@NonCPS` 注释该类上的所有方法来实现。

### Constructors 建设者

Occasionally, users may attempt to use CPS-transformed code such as Pipeline steps inside of a constructor in a Pipeline script. Unfortunately, the construction of objects via the `new` operator in Groovy is not something that can be CPS-transformed ([JENKINS-26313](https://issues.jenkins.io/browse/JENKINS-26313)), and so this will not work. Here is an example that calls a CPS-transformed method in a constructor:
有时，用户可能会尝试在 Pipeline 脚本的构造函数中使用 CPS 转换的代码，例如 Pipeline 步骤。不幸的是，通过 Groovy 中的 `new` 运算符构造对象不是可以进行 CPS 转换 （[JENKINS-26313](https://issues.jenkins.io/browse/JENKINS-26313)） 的事情，因此这将不起作用。下面是一个在构造函数中调用 CPS 转换方法的示例：

```
class Test {
  def x
  public Test() {
    setX()
  }
  private void setX() {
    this.x = 1;
  }
}
def x = new Test().x
echo "${x}"
```

The construction of `Test` will fail when the constructor calls `Test.setX` because `setX` is a CPS-transformed method. The warning in the logs from running this script looks like this:
当构造函数调用 `Test.setX` 时，`Test` 的构造将失败，因为 `setX` 是 CPS 转换的方法。运行此脚本的日志中的警告如下所示：

> expected to call Test.<init> but wound up catching Test.setX
> 预期调用 Test.<init>，但最终捕获了 Test.setX

To fix this case, ensure that any methods defined in a Pipeline script  that are called from inside of a constructor are annotated with `@NonCPS` and that constructors do not call any Pipeline steps. If you must call CPS-transformed code such a Pipeline steps from the  constructor, you need move the logic related to the CPS-transformed  methods out of the constructor, for example into a static factory method that calls the CPS-transformed code and then passes the results to the  constructor.
要修复这种情况，请确保 Pipeline 脚本中定义的从构造函数内部调用的任何方法都使用 `@NonCPS` 进行批注，并且构造函数不调用任何 Pipeline 步骤。如果必须从构造函数调用 CPS 转换的代码（如 Pipeline 步骤），则需要将与 CPS 转换方法相关的逻辑移出构造函数，例如，移动到调用 CPS 转换代码然后将结果传递给构造函数的静态工厂方法中。

### Overrides of non-CPS-transformed methods 非 CPS 转换方法的覆盖

Users may create a class in a Pipeline Script that extends a preexisting  class defined outside of the Pipeline script, for example from the Java  or Groovy standard libraries. When doing so, the subclass must ensure that any overriding methods are  annotated with `@NonCPS` and do not use any CPS-transformed code internally. Otherwise, the overriding methods will fail if called from a non-CPS context. For example, the following will not work:
用户可以在 Pipeline Script 中创建一个类，该类扩展在 Pipeline 脚本外部定义的预先存在的类，例如从 Java 或 Groovy 标准库。执行此操作时，子类必须确保任何覆盖方法都使用 `@NonCPS` 进行注释，并且不在内部使用任何 CPS 转换的代码。否则，如果从非 CPS 上下文调用，则覆盖方法将失败。例如，以下操作将不起作用：

```
class Test {
  @Override
  public String toString() {
    return "Test"
  }
}
def builder = new StringBuilder()
builder.append(new Test())
echo(builder.toString())
```

Calling the CPS-transformed override of `toString` from non-CPS-transformed code such as `StringBuilder.append` is not permitted and will not work as expected in most cases. The warning in the logs from running this script looks like this:
不允许从非 CPS 转换的代码（如 `StringBuilder.append`）调用 `toString` 的 CPS 转换覆盖，并且在大多数情况下不会按预期工作。运行此脚本的日志中的警告如下所示：

> expected to call java.lang.StringBuilder.append but wound up catching Test.toString
> 预期调用 java.lang.StringBuilder.append，但最终捕获了 Test.toString

To fix this case, add the `@NonCPS` annotation to the overriding method, and remove any uses of CPS-transformed code such as Pipeline steps from the method.
要修复这种情况，请将 `@NonCPS` 注释添加到覆盖方法中，并从方法中删除对 CPS 转换代码（如 Pipeline steps）的任何使用。

### Closures inside `GString` `GString` 内部的闭包 

In Groovy, it is possible to use a closure in a `GString` so that the closure is evaluated every time the `GString` is used as a `String`. However, in Pipeline scripts, this will not work as expected, because the closure inside of the GString will be CPS-transformed. Here is an example:
在 Groovy 中，可以在 `GString` 中使用闭包，以便每次将 `GString` 用作 `String` 时都会评估闭包。但是，在 Pipeline 脚本中，这不会按预期工作，因为 GString 内部的闭包将进行 CPS 转换。下面是一个示例：

```
def x = 1
def s = "x = ${-> x}"
x = 2
echo(s)
```

Using a closure inside of a `GString` as in this example will not work. The warning from the logs when running this script looks like this:
像这个例子中那样在 `GString` 内部使用闭包是行不通的。运行此脚本时，日志中的警告如下所示：

> expected to call WorkflowScript.echo but wound up catching org.jenkinsci.plugins.workflow.cps.CpsClosure2.call
> 预期调用 WorkflowScript.echo，但最终捕获了 org.jenkinsci.plugins.workflow.cps.CpsClosure2.call

To fix this case, replace the original GString with a closure that returns a GString that uses a normal expression rather than a closure, and then call the closure where you would have used the original `GString` as follows:
要修复这种情况，请将原始 GString 替换为返回使用普通表达式而不是闭包的 GString 的闭包，然后在使用原始 `GString` 的位置调用闭包，如下所示：

```
def x = 1
def s = { -> "x = ${x}" }
x = 2
echo(s())
```

## False Positives 误报

Unfortunately, some expressions may incorrectly trigger this warning even though they execute correctly. If you run into such a case, please [file a new issue](https://www.jenkins.io/participate/report-issue/redirect/#21713) (after first checking for duplicates) for `workflow-cps-plugin`.
遗憾的是，某些表达式即使正确执行，也可能会错误地触发此警告。如果您遇到这种情况，请为 `workflow-cps-plugin` [提交新问题](https://www.jenkins.io/participate/report-issue/redirect/#21713)（在首先检查重复项后）。