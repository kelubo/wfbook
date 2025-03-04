## CLI 参考



### Create a model 创建模型



`ollama create` is used to create a model from a Modelfile.
`ollama create` 用于从 Modelfile 创建模型。

```
ollama create mymodel -f ./Modelfile
```

​    

### Pull a model 拉取模型



```
ollama pull llama3.2
```

​    

> This command can also be used to update a local model. Only the diff will be pulled.
> 此命令还可用于更新本地模型。只会拉取 diff。

### Remove a model 删除模型



```
ollama rm llama3.2
```

​    

### Copy a model 复制模型



```
ollama cp llama3.2 my-model
```

​    

### Multiline input 多行输入



For multiline input, you can wrap text with `"""`:
对于多行输入，您可以使用 `“”“` 将文本括起来：

```
>>> """Hello,
... world!
... """
I'm a basic program that prints the famous "Hello, world!" message to the console.
```

​    

### Multimodal models 多模态模型



```
ollama run llava "What's in this image? /Users/jmorgan/Desktop/smile.png"
```

​    

> **Output**: The image features a yellow smiley face, which is likely the central focus of the picture.
> **输出**：图像具有黄色笑脸，这可能是图片的中心焦点。

### Pass the prompt as an argument 将提示作为参数传递



```
ollama run llama3.2 "Summarize this file: $(cat README.md)"
```

​    

> **Output**: Ollama is a lightweight, extensible framework for building and running  language models on the local machine. It provides a simple API for  creating, running, and managing models, as well as a library of  pre-built models that can be easily used in a variety of applications.
> **输出**：Ollama 是一个轻量级的可扩展框架，用于在本地计算机上构建和运行语言模型。它提供了一个用于创建、运行和管理模型的简单 API，以及一个可在各种应用程序中轻松使用的预构建模型库。

### Show model information 显示模型信息



```
ollama show llama3.2
```

​    

### List models on your computer 列出计算机上的模型



```
ollama list
```

​    

### List which models are currently loaded 列出当前加载的模型



```
ollama ps
```

​    

### Stop a model which is currently running 停止当前正在运行的模型



```
ollama stop llama3.2
```

​    

### Start Ollama 启动 Ollama



`ollama serve` is used when you want to start ollama without running the desktop application.
当您想在不运行桌面应用程序的情况下启动 OLLAMA 时，可以使用 `OLLAMA SERVE`。