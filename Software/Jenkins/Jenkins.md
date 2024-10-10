# Jenkins

[TOC]

## 概述

Jenkins 是一个独立的开源自动化服务器，可用于自动执行与构建、测试和交付或部署软件相关的各种任务。

Jenkins 可以通过本机系统包、Docker 进行安装，甚至可以由任何安装了 Java 运行时环境 （JRE） 的计算机独立运行。

Jenkins 是一个扩展性非常强的软件，其功能主要通过插件来扩展。在 Jenkins 里面有非常多的插件。







# 创建您的第一个Pipeline

Table of Contents

- [什么是 Jenkins Pipeline?](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#什么是-jenkins-pipeline)
- 快速开始示例
  - [Java](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#java)
  - [Node.js / JavaScript](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#node-js-javascript)
  - [Ruby](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#ruby)
  - [Python](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#python)
  - [PHP](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#php)

### 什么是 Jenkins Pipeline?

Jenkins Pipeline（或简称为 "Pipeline"）是一套插件，将持续交付的实现和实施集成到 Jenkins 中。

持续交付 Pipeline 自动化的表达了这样一种流程：将基于版本控制管理的软件持续的交付到您的用户和消费者手中。

Jenkins Pipeline 提供了一套可扩展的工具，用于将“简单到复杂”的交付流程实现为“持续交付即代码”。Jenkins Pipeline 的定义通常被写入到一个文本文件（称为 `Jenkinsfile` ）中，该文件可以被放入项目的源代码控制库中。 [[1](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#_footnotedef_1)]]

Pipeline 和 `Jenkinsfile` 的更多相关信息，请参考用户手册中的相关链接 [Pipeline](https://www.jenkins.io/zh/doc/book/pipeline) 和 [使用 Jenkinsfile](https://www.jenkins.io/zh/doc/book/pipeline/jenkinsfile)

快速开始使用 Pipeline：

1. 将[以下示例](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#examples) 复制到您的仓库中并命名为 `Jenkinsfile`
2. 单击Jenkins中的 **New Item** 菜单 ![Classic UI left column](https://www.jenkins.io/zh/doc/book/resources/pipeline/classic-ui-left-column.png)
3. 为您的新工程起一个名字 (例如 **My Pipeline**) ，选择 **Multibranch Pipeline**
4. 单击 **Add Source** 按钮，选择您想要使用的仓库类型并填写详细信息.
5. 单击 **Save** 按钮，观察您的第一个Pipeline运行！

您可能需要修改 `Jenkinsfile` 以便应用在您自己的项目中。尝试修改 `sh` 命令，使其与您本地运行的命令相同。

在配置好 Pipeline 之后，Jenkins 会自动检测您仓库中创建的任何新的分支或合并请求， 并开始为它们运行 Pipelines。

**[继续学习 "执行多个步骤"](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps)**

## 快速开始示例

下面是一个简单的 Pipeline 各种语言的复制和粘贴示例。

### Java

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent { docker 'maven:3.3.3' }
    stages {
        stage('build') {
            steps {
                sh 'mvn --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#)    *(Advanced)*  

### Node.js / JavaScript

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent { docker 'node:6.3' }
    stages {
        stage('build') {
            steps {
                sh 'npm --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#)    *(Advanced)*  

### Ruby

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent { docker 'ruby' }
    stages {
        stage('build') {
            steps {
                sh 'ruby --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#)    *(Advanced)*  

### Python

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent { docker 'python:3.5.1' }
    stages {
        stage('build') {
            steps {
                sh 'python --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#)    *(Advanced)*  

### PHP

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent { docker 'php' }
    stages {
        stage('build') {
            steps {
                sh 'php --version'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/#)    *(Advanced)*  

# 执行多个步骤（step）

Table of Contents

- [Linux、BSD 和 Mac OS](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#linuxbsd-和-mac-os)
- [Windows](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#windows)
- [超时、重试和更多](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#超时重试和更多)
- [完成时动作](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#完成时动作)

Pipelines 由多个步骤（step）组成，允许你构建、测试和部署应用。 Jenkins Pipeline 允许您使用一种简单的方式组合多个步骤， 以帮助您实现多种类型的自动化构建过程。

可以把“步骤（step）”看作一个执行单一动作的单一的命令。 当一个步骤运行成功时继续运行下一个步骤。 当任何一个步骤执行失败时，Pipeline 的执行结果也为失败。

当所有的步骤都执行完成并且为成功时，Pipeline 的执行结果为成功。

### Linux、BSD 和 Mac OS

在 Linux、BSD 和 Mac OS（类 Unix ) 系统中的 shell 命令， 对应于 Pipeline 中的一个 `sh` 步骤（step）。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                '''
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#)    *(Advanced)*  

### Windows

基于 Windows 的系统使用 `bat` 步骤表示执行批处理命令。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat 'set'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#)    *(Advanced)*  

## 超时、重试和更多

Jenkins Pipeline 提供了很多的步骤（step），这些步骤可以相互组合嵌套，方便地解决像重复执行步骤直到成功（重试）和如果一个步骤执行花费的时间太长则退出（超时）等问题。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                retry(3) {
                    sh './flakey-deploy.sh'
                }

                timeout(time: 3, unit: 'MINUTES') {
                    sh './health-check.sh'
                }
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#)    *(Advanced)*  

“Deploy”阶段（stage）重复执行 `flakey-deploy.sh` 脚本3次，然后等待 `health-check.sh` 脚本最长执行3分钟。 如果 `health-check.sh` 脚本在 3 分钟内没有完成，Pipeline 将会标记在“Deploy”阶段失败。

内嵌类型的步骤，例如 `timeout` 和 `retry` 可以包含其他的步骤，包括 `timeout` 和 `retry` 。

我们也可以组合这些步骤。例如，如果我们想要重试部署任务 5 次，但是总共花费的时间不能超过 3 分钟。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(5) {
                        sh './flakey-deploy.sh'
                    }
                }
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#)    *(Advanced)*  

## 完成时动作

当 Pipeline 运行完成时，你可能需要做一些清理工作或者基于 Pipeline 的运行结果执行不同的操作， 这些操作可以放在 `post` 部分。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'echo "Fail!"; exit 1'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps/#)    *(Advanced)*  

# 定义执行环境

在 [上一小节](https://www.jenkins.io/zh/doc/pipeline/tour/running-multiple-steps) 您可能已经注意到每个示例中的 `agent` 指令。 `agent` 指令告诉Jenkins在哪里以及如何执行Pipeline或者Pipeline子集。 正如您所预料的，所有的Pipeline都需要 `agent` 指令。

在执行引擎中，`agent` 指令会引起以下操作的执行：

- 所有在块block中的步骤steps会被Jenkins保存在一个执行队列中。 一旦一个执行器 [executor](https://www.jenkins.io/zh/doc/pipeline/tour/agents/#../../book/glossary/#executor) 是可以利用的，这些步骤将会开始执行。
- 一个工作空间 [workspace](https://www.jenkins.io/zh/doc/pipeline/tour/agents/#../../book/glossary/#workspace) 将会被分配， 工作空间中会包含来自远程仓库的文件和一些用于Pipeline的工作文件

在Pipeline中可以使用这几种 [定义代理的方式](https://www.jenkins.io/doc/book/pipeline/syntax#agent) 在本导读中，我们仅使用Docker容器的代理方式。

在Pipeline中可以很容易的运行 [Docker](https://docs.docker.com/) 镜像和容器。 Pipeline可以定义命令或者应用运行需要的环境和工具， 不需要在执行代理中手动去配置各种各样的系统工具和依赖。 这种方式可以让你使用 [Docker容器工具包](http://hub.docker.com) 中的任何工具。

`agent` 指令更多选项和相关信息，可以查看 [语法参考](https://www.jenkins.io/doc/book/pipeline/syntax#agent) 。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent {
        docker { image 'node:7-alpine' }
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

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/agents/#)    *(Advanced)*  

当执行Pipeline时，Jenkins将会自动运行指定的容器，并执行Pipeline中已经定义好的步骤steps：

```
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
[guided-tour] Running shell script
+ node --version
v7.4.0
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
```

在Pipeline中，混合和搭配不同的容器或者其他代理可以获得更大的灵活性。 更多配置选项和信息，可以参考 **[继续“使用环境变量”](https://www.jenkins.io/zh/doc/pipeline/tour/environment)** 。

------

# 使用环境变量

Table of Contents

- [环境变量中的凭证信息](https://www.jenkins.io/zh/doc/pipeline/tour/environment/#环境变量中的凭证信息)

环境变量可以像下面的示例设置为全局的，也可以是阶段（stage）级别的。 如你所想，阶段（stage）级别的环境变量只能在定义变量的阶段（stage）使用。

Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any

    environment {
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }

    stages {
        stage('Build') {
            steps {
                sh 'printenv'
            }
        }
    }
}
```

​    [Toggle Scripted Pipeline](https://www.jenkins.io/zh/doc/pipeline/tour/environment/#)    *(Advanced)*  

这种在 `Jenkinsfile` 中定义环境变量的方法对于指令性的脚本定义非常有用方便， 比如 `Makefile` 文件，可以在 Pipeline 中配置构建或者测试的环境，然后在 Jenkins 中运行。

环境变量的另一个常见用途是设置或者覆盖构建或测试脚本中的凭证。 因为把凭证信息直接写入 `Jenkinsfile` 很显然是一个坏主意， Jenkins Pipeline 允许用户快速安全地访问在 `Jenkinsfile` 中预定义的凭证信息，并且无需知道它们的值。

### 环境变量中的凭证信息

更多信息参考 [用户手册](https://www.jenkins.io/doc/book) 中的 [凭证信息处理](https://www.jenkins.io/doc/book/pipeline/jenkinsfile#handling-credentials) 。

**[继续学习“记录测试和构建结果”](https://www.jenkins.io/zh/doc/pipeline/tour/tests-and-artifacts)**

------