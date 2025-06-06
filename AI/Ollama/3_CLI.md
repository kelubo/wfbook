# CLI 参考

[TOC]

## 创建模型

`ollama create` 用于从 Modelfile 创建模型。

```bash
ollama create mymodel -f ./Modelfile
```

## 拉取模型

```bash
ollama pull llama3.2
```

> This command can also be used to update a local model. Only the diff will be pulled.
> 此命令还可用于更新本地模型。只会拉取 diff 。

## 删除模型

```bash
ollama rm llama3.2
```

## 复制模型

```bash
ollama cp llama3.2 my-model
```

## 多行输入

对于多行输入，您可以使用 `"""` 将文本括起来：

```bash
>>> """Hello,
... world!
... """
I'm a basic program that prints the famous "Hello, world!" message to the console.
```

## 多模态模型

```bash
ollama run llava "What's in this image? /Users/jmorgan/Desktop/smile.png"
```

> **Output**: The image features a yellow smiley face, which is likely the central focus of the picture.
> **输出**：图像具有黄色笑脸，这可能是图片的中心焦点。

## 将提示作为参数传递

```bash
ollama run llama3.2 "Summarize this file: $(cat README.md)"
```

> **输出**：Ollama 是一个轻量级的可扩展框架，用于在本地计算机上构建和运行语言模型。它提供了一个用于创建、运行和管理模型的简单 API，以及一个可在各种应用程序中轻松使用的预构建模型库。

## 显示模型信息

```bash
ollama show llama3.2
```

## 列出计算机上的模型

```bash
ollama list
```

## 列出当前加载的模型

```bash
ollama ps
```

## 停止当前正在运行的模型

```bash
ollama stop llama3.2
```

## 启动 Ollama

当想在不运行桌面应用程序的情况下启动 ollama 时，可以使用 `ollama serve` 。