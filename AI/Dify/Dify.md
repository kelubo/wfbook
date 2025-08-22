# Dify

[TOC]

## 概述

**Dify** 是一款开源的大语言模型（LLM）应用开发平台。它融合了后端即服务（Backend as Service）和 [LLMOps](https://docs.dify.ai/zh-hans/learn-more/extended-reading/what-is-llmops) 的理念，使开发者可以快速搭建生产级的生成式 AI 应用。即使你是非技术人员，也能参与到 AI 应用的定义和数据运营过程中。

由于 Dify 内置了构建 LLM 应用所需的关键技术栈，包括对数百个模型的支持、直观的 Prompt 编排界面、高质量的 RAG 引擎、稳健的 Agent 框架、灵活的流程编排，并同时提供了一套易用的界面和 API 。这为开发者节省了许多重复造轮子的时间，使其可以专注在创新和业务需求上。

### 为什么使用 Dify？

你或许可以把 LangChain 这类的开发库（Library）想象为有着锤子、钉子的工具箱。与之相比，Dify 提供了更接近生产需要的完整方案，Dify 好比是一套脚手架，并且经过了精良的工程设计和软件测试。

重要的是，Dify 是**开源**的，它由一个专业的全职团队和社区共同打造。你可以基于任何模型自部署类似 Assistants API 和 GPTs 的能力，在灵活和安全的基础上，同时保持对数据的完全控制。

> 我们的社区用户对 Dify 的产品评价可以归结为简单、克制、迭代迅速。 ——路宇，Dify.AI CEO

希望以上信息和这份指南可以帮助你了解这款产品，我们相信 Dify 是为你而做的（Do It For You）。

### Dify 能做什么？

Dify 一词源自 Define + Modify，意指定义并且持续的改进你的 AI 应用，它是为你而做的（Do it for you）。

- **创业**，快速的将你的 AI 应用创意变成现实，无论成功和失败都需要加速。在真实世界，已经有几十个团队通过 Dify 构建 MVP（最小可用产品）获得投资，或通过 POC（概念验证）赢得了客户的订单。
- **将 LLM 集成至已有业务**，通过引入 LLM 增强现有应用的能力，接入 Dify 的 RESTful API 从而实现 Prompt 与业务代码的解耦，在 Dify 的管理界面是跟踪数据、成本和用量，持续改进应用效果。
- **作为企业级 LLM 基础设施**，一些银行和大型互联网公司正在将 Dify 部署为企业内的 LLM 网关，加速 GenAI 技术在企业内的推广，并实现中心化的监管。
- **探索 LLM 的能力边界**，即使你是一个技术爱好者，通过 Dify 也可以轻松的实践 Prompt 工程和 Agent 技术，在 GPTs 推出以前就已经有超过 60,000 开发者在 Dify 上创建了自己的第一个应用。

## 特性与技术规格

在 Dify ，我们采用透明化的产品特性和技术规格政策，确保你在全面了解我们产品的基础上做出决策。这种透明度不仅有利于你的技术选型，也促进了社区成员对产品的深入理解和积极贡献。

### 项目基础信息

* 项目设立	    2023 年 3 月
* 开源协议            [基于 Apache License 2.0 有限商业许可](https://docs.dify.ai/zh-hans/policies/open-source)
* 官方研发团队    超过 15 名全职员工
* 社区贡献者        [超过 290 人](https://ossinsight.io/analyze/langgenius/dify) （截止 2024 Q2）
* 后端技术            Python/Flask/PostgreSQL
* 前端技术            Next.js
* 代码行数            超过 13 万行
* 发版周期            平均每周一次

### 技术特性

* LLM 推理引擎

  Dify Runtime ( 自 v0.4 起移除了 LangChain)

* 商业模型支持

  **10+ 家**，包括 OpenAI 与 Anthropic

  新的主流模型通常在 48 小时内完成接入

* MaaS 供应商支持

  **7 家**，Hugging Face，Replicate，AWS Bedrock，NVIDIA，GroqCloud，together.ai，OpenRouter

* 本地模型推理 Runtime 支持

  6 **家**，Xoribits（推荐），OpenLLM，LocalAI，ChatGLM，Ollama，NVIDIA TIS

* OpenAI 接口标准模型接入支持

  **∞ 家**

* 多模态技术

  ASR 模型

  GPT-4o 规格的富文本模型

* 预置应用类型

  对话型应用

  文本生成应用

  Agent

  工作流

* Prompt 即服务编排

  广受好评的可视化的 Prompt 编排界面，在同一个界面中修改 Prompt 并预览效果

  **编排模式**

  * 简易模式编排
  * Assistant 模式编排
  * Flow 模式编排

  **Prompt 变量类型**

  * 字符串
  * 单选枚举
  * 外部 API
  * 文件（Q3 即将推出）

* Agentic Workflow 特性

  行业领先的可视化流程编排界面，所见即所得的节点调试，可插拔的 DSL，原生的代码运行时，构建更复杂、可靠、稳定的 LLM 应用。

  **支持节点**

  * LLM
  * 知识库检索
  * 问题分类
  * 条件分支
  * 代码执行
  * 模板转换
  * HTTP 请求
  * 工具

* RAG 特性

  首创的可视化的知识库管理界面，支持分段预览和召回效果测试。

  **索引方式**

  * 关键词
  * 文本向量
  * 由 LLM 辅助的问题-分段模式

  **检索方式**

  * 关键词
  * 文本相似度匹配
  * 混合检索
  * N 选 1 模式（即将下线）
  * 多路召回

  **召回优化技术**

  * 使用 ReRank 模型

* ETL 技术

  支持对 TXT、Markdown、PDF、HTML、DOC、CSV 等格式文件进行自动清洗，内置的 Unstructured 服务开启后可获得最大化支持。

  支持同步来自 Notion 的文档为知识库。 支持同步网页为知识库。

* 向量数据库支持

  Qdrant（推荐），Weaviate，Zilliz/Milvus，Pgvector，Pgvector-rs，Chroma，OpenSearch，TiDB，Tencent Vector，Oracle，Relyt，Analyticdb, Couchbase

* Agent 技术

  ReAct，Function Call

  **工具支持**

  * 可调用 OpenAI Plugin 标准的工具
  * 可直接加载 OpenAPI Specification 的 API 作为工具

  **内置工具**

  * 40+ 款（截止 2024 Q2）

* 日志

  支持，可基于日志进行标注

* 标注回复

  基于经人类标注的 Q&A 对，可用于相似度对比回复

  可导出为供模型微调环节使用的数据格式

* 内容审查机制

  OpenAI Moderation 或外部 API

* 团队协同

  工作空间与多成员管理支持

* API 规格

  RESTful，已覆盖大部分功能

* 部署方式

  Docker，Helm

## 模型供应商列表

Dify 为以下模型提供商提供原生支持：

| Provider                       | LLM     | Text Embedding | Rerank | Speech to text | TTS  |      |
| ------------------------------ | ------- | -------------- | ------ | -------------- | ---- | ---- |
| OpenAI                         | ✔️(🛠️)(👓) | ✔️              |        | ✔️              | ✔️    |      |
| Anthropic                      | ✔️(🛠️)    |                |        |                |      |      |
| Azure OpenAI                   | ✔️(🛠️)(👓) | ✔️              |        | ✔️              | ✔️    |      |
| Gemini                         | ✔️       |                |        |                |      |      |
| Google Cloud                   | ✔️(👓)    | ✔️              |        |                |      |      |
| Nvidia API Catalog             | ✔️       | ✔️              | ✔️      |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
| Nvidia NIM                     |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| Nvidia Triton Inference Server |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| AWS Bedrock                    |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| OpenRouter                     |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| Cohere                         |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| together.ai                    |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| Ollama                         |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
| ✔️                              |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |
|                                |         |                |        |                |      |      |







Mistral AI

✔️

groqcloud

✔️

Replicate

✔️

✔️

Hugging Face

✔️

✔️

Xorbits inference

✔️

✔️

✔️

✔️

✔️

智谱

✔️(🛠️)(👓)

✔️

百川

✔️

✔️

讯飞星火

✔️

Minimax

✔️(🛠️)

✔️

通义千问

✔️

✔️

✔️

文心一言

✔️

✔️

月之暗面

✔️(🛠️)

Tencent Cloud

✔️

阶跃星辰

✔️

火山引擎

✔️

✔️

零一万物

✔️

360 智脑

✔️

Azure AI Studio

✔️

✔️

deepseek

✔️(🛠️)

腾讯混元

✔️

SILICONFLOW

✔️

✔️

Jina AI

✔️

✔️

ChatGLM

✔️

Xinference

✔️(🛠️)(👓)

✔️

✔️

OpenLLM

✔️

✔️

LocalAI

✔️

✔️

✔️

✔️

OpenAI API-Compatible

✔️

✔️

✔️

PerfXCloud

✔️

✔️

Lepton AI

✔️

novita.ai

✔️

Amazon Sagemaker

✔️

✔️

✔️

Text Embedding Inference

✔️

✔️

其中 (🛠️) 代表支持 Function Calling，(👓) 代表视觉能力。

这张表格我们会一直保持更新。同时，我们也留意着社区成员们所提出的关于模型供应商的各种[请求](https://github.com/langgenius/dify/discussions/categories/ideas)。如果你有需要的模型供应商却没在上面找到，不妨动手参与进来，通过提交一个PR（Pull Request）来做出你的贡献。欢迎查阅我们的 [成为贡献者](https://docs.dify.ai/zh-hans/community/contribution)指南了解更多。