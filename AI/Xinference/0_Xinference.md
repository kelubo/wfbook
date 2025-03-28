# Xinference

[TOC]

## 概述

Xorbits Inference (Xinference) 是一个开源平台，用于简化各种 AI 模型的运行和集成。借助 Xinference，可以使用任何开源 LLM、嵌入模型和多模态模型在云端或本地环境中运行推理，并创建强大的 AI 应用。

https://xorbits.cn/

最全面的企业级推理服务平台。Xinference 是针对生成式 AI 场景度身定制的能力全面的推理服务平台。功能覆盖算力、模型和高可用可观测的企业级能力    

满足你所有需求的高性能推理服务平台。模型全生命周期管理、多推理引擎、异构 GPU、高吞吐和高可用、高效调度策略。                              

* 支持的模型丰富

  提供 100+ 最新开源模型，从文本语音视频到 embedding/rerank 模型，始终保持最快适配。

* 广泛的硬件支持

  支持多种硬件平台，支持国产 GPU，包括华为昇腾、海光、天数等。可同时支持多种硬件共同服务。

* 生态丰富

  多种主流开发框架已经原生支持 Xinference，包括 Langchain、Dify、Ragflow、FastGPT 等。

* 多推理引擎支持

  优化支持多种主流推理引擎，包括 vLLM、SGLang、TensorRT、Transformers、MLX、LMDeploy 等。

* 分布式高性能

  原生分布式架构，可轻松水平扩展集群，支持多种调度策略适应低延迟、高上下文、高吞吐等不同场景。

* 更多企业级特性

  支持用户权限管理、单点登录、批处理、多租户隔离、模型微调、可观测等众多企业级特性                            

## 安装

Xinference 在 Linux, Windows, MacOS 上都可以通过 `pip` 来安装。如果需要使用 Xinference 进行模型推理，可以根据不同的模型指定不同的引擎。

如果希望能够推理所有支持的模型，可以用以下命令安装所有需要的依赖：

```bash
pip install "xinference[all]"
```

> 备注
>
> 如果想使用 GGUF 格式的模型，建议根据当前使用的硬件手动安装所需要的依赖，以充分利用硬件的加速能力。更多细节可以参考 [Llama.cpp 引擎](https://inference.readthedocs.io/zh-cn/latest/getting_started/installation.html#installation-gguf) 这一章节。

如果只想安装必要的依赖，接下来是如何操作的详细步骤。

### Transformers 引擎

PyTorch(transformers) 引擎支持几乎有所的最新模型，这是 Pytorch 模型默认使用的引擎：

```bash
pip install "xinference[transformers]"
```

### vLLM 引擎

vLLM 是一个支持高并发的高性能大模型推理引擎。当满足以下条件时，Xinference 会自动选择 vllm 作为引擎来达到更高的吞吐量：

- 模型格式为 `pytorch` ， `gptq` 或者 `awq` 。
- 当模型格式为 `pytorch` 时，量化选项需为 `none` 。
- 当模型格式为 `awq` 时，量化选项需为 `Int4` 。
- 当模型格式为 `gptq` 时，量化选项需为 `Int3` 、 `Int4` 或者 `Int8` 。
- 操作系统为 Linux 并且至少有一个支持 CUDA 的设备
- 自定义模型的 `model_family` 字段和内置模型的 `model_name` 字段在 vLLM 的支持列表中。

目前，支持的模型包括：

- `llama-2`, `llama-3`, `llama-3.1`, `llama-3.2-vision`, `llama-2-chat`, `llama-3-instruct`, `llama-3.1-instruct`, `llama-3.3-instruct`
- `mistral-v0.1`, `mistral-instruct-v0.1`, `mistral-instruct-v0.2`, `mistral-instruct-v0.3`, `mistral-nemo-instruct`, `mistral-large-instruct`
- `codestral-v0.1`
- `Yi`, `Yi-1.5`, `Yi-chat`, `Yi-1.5-chat`, `Yi-1.5-chat-16k`
- `code-llama`, `code-llama-python`, `code-llama-instruct`
- `deepseek`, `deepseek-coder`, `deepseek-chat`, `deepseek-coder-instruct`, `deepseek-r1-distill-qwen`, `deepseek-v2-chat`, `deepseek-v2-chat-0628`, `deepseek-v2.5`, `deepseek-v3`, `deepseek-r1`, `deepseek-r1-distill-llama`
- `yi-coder`, `yi-coder-chat`
- `codeqwen1.5`, `codeqwen1.5-chat`
- `qwen2.5`, `qwen2.5-coder`, `qwen2.5-instruct`, `qwen2.5-coder-instruct`
- `baichuan-2-chat`
- `internlm2-chat`
- `internlm2.5-chat`, `internlm2.5-chat-1m`
- `qwen-chat`
- `mixtral-instruct-v0.1`, `mixtral-8x22B-instruct-v0.1`
- `chatglm3`, `chatglm3-32k`, `chatglm3-128k`
- `glm4-chat`, `glm4-chat-1m`
- `codegeex4`
- `qwen1.5-chat`, `qwen1.5-moe-chat`
- `qwen2-instruct`, `qwen2-moe-instruct`
- `QwQ-32B-Preview`, `QwQ-32B`
- `marco-o1`
- `gemma-it`, `gemma-2-it`
- `gemma-3-it`, `gemma-3-27b-it`, `gemma-3-12b-it`, `gemma-3-4b-it`, `gemma-3-1b-it`
- `orion-chat`, `orion-chat-rag`
- `c4ai-command-r-v01`
- `minicpm3-4b`
- `internlm3-instruct`
- `moonlight-16b-a3b-instruct`

安装 xinference 和 vLLM：

```bash
pip install "xinference[vllm]"

# FlashInfer is optional but required for specific functionalities such as sliding window attention with Gemma 2.
# For CUDA 12.4 & torch 2.4 to support sliding window attention for gemma 2 and llama 3.1 style rope
pip install flashinfer -i https://flashinfer.ai/whl/cu124/torch2.4
# For other CUDA & torch versions, please check https://docs.flashinfer.ai/installation.html
```

### Llama.cpp 引擎

Xinference 通过 xllamacpp 或 llama-cpp-python 支持 gguf 格式的模型。[xllamacpp](https://github.com/xorbitsai/xllamacpp) 由 Xinference 团队开发，并将在未来成为 llama.cpp 的唯一后端。

> 备注
>
> `llama-cpp-python` 是 llama.cpp 后端的默认选项。要启用 xllamacpp，请添加环境变量 USE_XLLAMACPP=1。
>
> 例如，通过以下方式启动本地 Xinference
>
> ```bash
> USE_XLLAMACPP=1 xinference-local
> ```

> 警告
>
> 在即将发布的 Xinference v1.5.0 中，`xllamacpp` 将成为 llama.cpp 的默认选项，而 `llama-cpp-python` 将被弃用。在 Xinference v1.6.0 中，`llama-cpp-python` 将被移除。

初始步骤：

```bash
pip install xinference
```

`xllamacpp` 的安装说明：

- CPU 或 Mac Metal：

  ```bash
  pip install -U xllamacpp
  ```

- Cuda:

  ```bash
  pip install xllamacpp --force-reinstall --index-url https://xorbitsai.github.io/xllamacpp/whl/cu124
  ```

`llama-cpp-python` 不同硬件的安装方式：

- Apple M系列

  ```bash
  CMAKE_ARGS="-DLLAMA_METAL=on" pip install llama-cpp-python
  ```

- 英伟达显卡：

  ```bash
  CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python
  ```

- AMD 显卡：

  ```bash
  CMAKE_ARGS="-DLLAMA_HIPBLAS=on" pip install llama-cpp-python
  ```

### SGLang 引擎

SGLang 具有基于 RadixAttention 的高性能推理运行时。它通过在多个调用之间自动重用KV缓存，显著加速了复杂 LLM 程序的执行。它还支持其他常见推理技术，如连续批处理和张量并行处理。

初始步骤：

```bash
pip install "xinference[sglang]"

# For CUDA 12.4 & torch 2.4 to support sliding window attention for gemma 2 and llama 3.1 style rope
pip install flashinfer -i https://flashinfer.ai/whl/cu124/torch2.4
# For other CUDA & torch versions, please check https://docs.flashinfer.ai/installation.html
```

### MLX 引擎

MLX-lm 用来在苹果 silicon 芯片上提供高效的 LLM 推理。

初始步骤：

```bash
pip install "xinference[mlx]"
```

### Docker 镜像

Xinference 在 Dockerhub 和 阿里云容器镜像服务 中上传了官方镜像。

- Xinference 使用 GPU 加速推理，该镜像需要在有 GPU 显卡并且安装 CUDA 的机器上运行。
- 保证 CUDA 在机器上正确安装。可以使用 `nvidia-smi` 检查是否正确运行。
- 镜像中的 CUDA 版本为 `12.4` 。为了不出现预期之外的问题，请将宿主机的 CUDA 版本和 NVIDIA Driver 版本分别升级到 `12.4` 和 `550` 以上。

当前，可以通过两个渠道拉取 Xinference 的官方镜像。

1. 在 Dockerhub 的 `xprobe/xinference` 仓库里。

2. Dockerhub 中的镜像会同步上传一份到阿里云公共镜像仓库中，供访问 Dockerhub 有困难的用户拉取。

拉取命令：`docker pull registry.cn-hangzhou.aliyuncs.com/xprobe_xinference/xinference:<tag>` 。

目前可用的标签包括：

- `nightly-main`: 这个镜像会每天从 GitHub main 分支更新制作，不保证稳定可靠。
- `v<release version>`: 这个镜像会在 Xinference 每次发布的时候制作，通常可以认为是稳定可靠的。
- `latest`: 这个镜像会在 Xinference 发布时指向最新的发布版本
- 对于 CPU 版本，增加 `-cpu` 后缀，如 `nightly-main-cpu`。

#### 自定义镜像

如果需要安装额外的依赖，可以参考 [xinference/deploy/docker/Dockerfile](https://github.com/xorbitsai/inference/tree/main/xinference/deploy/docker/Dockerfile) 。请确保使用 Dockerfile 制作镜像时在 Xinference 项目的根目录下。比如：

```
git clone https://github.com/xorbitsai/inference.git
cd inference
docker build --progress=plain -t test -f xinference/deploy/docker/Dockerfile .
```

#### 使用镜像

可以使用如下方式在容器内启动 Xinference，同时将 9997 端口映射到宿主机的 9998 端口，并且指定日志级别为 DEBUG，也可以指定需要的环境变量。

```bash
docker run -e XINFERENCE_MODEL_SRC=modelscope -p 9998:9997 --gpus all xprobe/xinference:v<your_version> xinference-local -H 0.0.0.0 --log-level debug
```

> 警告
>
> `--gpus` 必须指定，正如前文描述，镜像必须运行在有 GPU 的机器上，否则会出现错误。
>
> `-H 0.0.0.0` 也是必须指定的，否则在容器外无法连接到 Xinference 服务。
>
> 可以指定多个 `-e` 选项赋值多个环境变量。

当然，也可以运行容器后，进入容器内手动拉起 Xinference。

#### 挂载模型目录

默认情况下，镜像中不包含任何模型文件，使用过程中会在容器内下载模型。如果需要使用已经下载好的模型，需要将宿主机的目录挂载到容器内。这种情况下，需要在运行容器时指定本地卷，并且为 Xinference 配置环境变量。

```bash
docker run -v </on/your/host>:</on/the/container> -e XINFERENCE_HOME=</on/the/container> -p 9998:9997 --gpus all xprobe/xinference:v<your_version> xinference-local -H 0.0.0.0
```

上述命令的原理是将主机上指定的目录挂载到容器中，并设置 `XINFERENCE_HOME` 环境变量指向容器内的该目录。这样，所有下载的模型文件将存储在您在主机上指定的目录中。您无需担心在 Docker 容器停止时丢失这些文件，下次运行容器时，您可以直接使用现有的模型，无需重复下载。

如果你在宿主机使用的默认路径下载的模型，由于 xinference cache  目录是用的软链的方式存储模型，需要将原文件所在的目录也挂载到容器内。例如你使用 huggingface 和 modelscope  作为模型仓库，那么需要将这两个对应的目录挂载到容器内，一般对应的 cache 目录分别在  <home_path>/.cache/huggingface 和  <home_path>/.cache/modelscope，使用的命令如下：

```bash
docker run \
  -v </your/home/path>/.xinference:/root/.xinference \
  -v </your/home/path>/.cache/huggingface:/root/.cache/huggingface \
  -v </your/home/path>/.cache/modelscope:/root/.cache/modelscope \
  -p 9997:9997 \
  --gpus all \
  xprobe/xinference:v<your_version> \
  xinference-local -H 0.0.0.0
```

### 在 Kubernetes 集群中安装

#### 基于原生 Helm 的方式

Xinference 提供基于原生 Helm 在 Kubernetes 集群中安装的方式。

- 一个可用的 Kubernetes 集群。
- 在 Kubernetes 中开启 GPU 支持，参考 [这里](https://kubernetes.io/zh-cn/docs/tasks/manage-gpus/scheduling-gpus/) 。
- 正确安装 `Helm` 。

##### 具体步骤

1. 新增 Xinference Helm 仓库

   ```bash
   helm repo add xinference https://xorbitsai.github.io/xinference-helm-charts
   ```

2. 更新仓库索引，查询可安装版本

   ```bash
   helm repo update xinference
   helm search repo xinference/xinference --devel --versions
   ```

3. 安装

   ```bash
   helm install xinference xinference/xinference -n xinference --version <helm_charts_version>
   ```

#### 自定义安装

上述安装方式安装了一个类似单机的 Xinference ，也就是只有一个节点，同时其他启动参数均保持默认。

下面展示了一些常见的自定义安装配置。

1. 我需要从 `ModelScope` 下载模型。

   ```bash
   helm install xinference xinference/xinference -n xinference --version <helm_charts_version> --set config.model_src="modelscope"
   ```

2. 我想使用 cpu 版本的 Xinference 镜像（或者其他版本的镜像）。

   ```bash
   helm install xinference xinference/xinference -n xinference --version <helm_charts_version> --set config.xinference_image="<xinference_docker_image>"
   ```

3. 我需要启动 4 个 Xinference worker 节点，每个 worker 管理 4 个 GPU。

   ```bash
   helm install xinference xinference/xinference -n xinference --version <helm_charts_version> --set config.worker_num=4 --set config.gpu_per_worker="4"
   ```

上面的安装方式基于 Helm `--set` 选项。对于更加复杂的自定义安装场景，例如多个 worker 共享存储，非常推荐使用你自己的 `values.yaml` 文件，然后通过 Helm `-f` 选项进行安装。

The default `values.yaml` file is located [here](https://github.com/xorbitsai/xinference-helm-charts/blob/main/charts/xinference/values.yaml). Some examples can be found [here](https://github.com/xorbitsai/xinference-helm-charts/tree/main/examples).

#### 基于第三方 KubeBlocks 的方式

你也可以通过第三方的 `KubeBlocks` 来在 K8s 集群中安装 Xinference 。这种方式不是 Xinference 官方维护的，因此无法严格保证实时更新和可用性。请参考 [文档](https://kubeblocks.io/docs/preview/user_docs/kubeblocks-for-xinference/manage-xinference) 。

### 其他平台

- [Ascend NPU](https://inference.readthedocs.io/zh-cn/latest/getting_started/installation_npu.html#installation-npu)

## 使用

### 本地运行 Xinference

以一个经典的大语言模型 `qwen2.5-instruct` 来展示如何在本地用 Xinference 运行大模型。

#### 拉起本地服务

使用以下命令拉起本地的 Xinference 服务：

```bash
xinference-local --host 0.0.0.0 --port 9997

INFO     Xinference supervisor 0.0.0.0:64570 started
INFO     Xinference worker 0.0.0.0:64570 started
INFO     Starting Xinference at endpoint: http://0.0.0.0:9997
INFO     Uvicorn running on http://0.0.0.0:9997 (Press CTRL+C to quit)
```

> 备注
>
> 默认情况下，Xinference 会使用 `<HOME>/.xinference` 作为主目录来存储一些必要的信息，比如日志文件和模型文件，其中 `<HOME>` 就是当前用户的主目录。
>
> 你可以通过配置环境变量 `XINFERENCE_HOME` 修改主目录， 比如：
>
> ```bash
> XINFERENCE_HOME=/tmp/xinference xinference-local --host 0.0.0.0 --port 9997
> ```

一旦 Xinference 服务运行起来，可以有多种方式来使用，包括使用网页、cURL 命令、命令行或者是 Xinference 的 Python SDK。

可以通过访问 http://127.0.0.1:9997/ui 来使用 UI，访问 http://127.0.0.1:9997/docs 来查看 API 文档。

可以通过以下命令安装后，利用 Xinference 命令行工具或者 Python 代码来使用：

```bash
pip install xinference
```

命令行工具是 `xinference`。可以通过以下命令查看有哪些可以使用的命令：

```bash
xinference --help

Usage: xinference [OPTIONS] COMMAND [ARGS]...

Options:
  -v, --version       Show the version and exit.
  --log-level TEXT
  -H, --host TEXT
  -p, --port INTEGER
  --help              Show this message and exit.

Commands:
  cached
  cal-model-mem
  chat
  engine
  generate
  launch
  list
  login
  register
  registrations
  remove-cache
  stop-cluster
  terminate
  unregister
  vllm-models
```

如果只需要安装 Xinference 的 Python SDK，可以使用以下命令安装最少依赖。需要注意的是版本必须和 Xinference 服务的版本保持匹配。

```bash
pip install xinference-client==${SERVER_VERSION}
```

#### 关于模型的推理引擎

自 `v0.11.0` 版本开始，在加载 LLM 模型之前，需要指定具体的推理引擎。当前，Xinference 支持以下推理引擎：

- `vllm`
- `sglang`
- `llama.cpp`
- `transformers`
- `MLX`

注意，当加载 LLM 模型时，所能运行的引擎与 `model_format` 和 `quantization` 参数息息相关。

Xinference 提供了 `xinference engine` 命令帮助你查询相关的参数组合。

例如：

1. 想查询与 `qwen-chat` 模型相关的参数组合，以决定它能够怎样跑在各种推理引擎上。

   ```bash
   xinference engine -e <xinference_endpoint> --model-name qwen-chat
   ```

2. 想将 `qwen-chat` 跑在 `VLLM` 推理引擎上，但是不知道什么样的其他参数符合这个要求。

   ```bash
   xinference engine -e <xinference_endpoint> --model-name qwen-chat --model-engine vllm
   ```

3. 想加载 `GGUF` 格式的 `qwen-chat` 模型，需要知道其余的参数组合。

   ```bash
   xinference engine -e <xinference_endpoint> --model-name qwen-chat -f ggufv2
   ```

总之，相比于之前的版本，当加载 LLM 模型时，需要额外传入 `model_engine` 参数。可以通过 `xinference engine` 命令查询想运行的推理引擎与其他参数组合的关系。

> 备注
>
> 关于何时使用什么引擎，以下是一些建议：
>
> * Linux
>   * 在能使用的情况下，优先使用 **vLLM** 或 **SGLang**，因为他们有更好的性能。
>   * 如果资源有限，可以考虑使用 **llama.cpp**，因为他提供了更多的量化选项。
>   * 其他使用考虑使用 **Transformers**，它几乎支持所有的模型。
> * Windows
>   * 推荐使用 **WSL**，这个时候选择和 Linux 一致。
>   * 其他时候推荐使用 **llama.cpp**，对于不支持的模型，选择使用 **Transformers**。
> * Mac
>   * 在模型支持的情况下，推荐使用 **MLX 引擎**，它有着最好的性能
>   * 其他时候推荐使用 **llama.cpp**，对于不支持的模型，选择使用 **Transformers**。

#### 运行 qwen2.5-instruct

运行一个内置的 `qwen2.5-instruct` 模型。当需要运行一个模型时，第一次运行是要从 HuggingFace 下载模型参数，一般来说需要根据模型大小下载10到30分钟不等。当下载完成后，Xinference本地会有缓存的处理，以后再运行相同的模型不需要重新下载。

> 备注
>
> Xinference 也允许从其他模型托管平台下载模型。可以通过在拉起 Xinference 时指定环境变量，比如，如果想要从 ModelScope 中下载模型，可以使用如下命令：
>
> ```bash
> XINFERENCE_MODEL_SRC=modelscope xinference-local --host 0.0.0.0 --port 9997
> ```

可以使用 `--model-uid` 或者 `-u` 参数指定模型的 UID，如果没有指定，Xinference 会随机生成一个 ID。默认的 ID 和模型名保持一致。

```bash
xinference launch --model-engine <inference_engine> -n qwen2.5-instruct -s 0_5 -f pytorch
```

```bash
curl -X 'POST' \
  'http://127.0.0.1:9997/v1/models' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "model_engine": "<inference_engine>",
  "model_name": "qwen2.5-instruct",
  "model_format": "pytorch",
  "size_in_billions": "0_5"
}'
```

```python
from xinference.client import RESTfulClient
client = RESTfulClient("http://127.0.0.1:9997")
model_uid = client.launch_model(
  model_engine="<inference_engine>",
  model_name="qwen2.5-instruct",
  model_format="pytorch",
  size_in_billions="0_5"
)
print('Model uid: ' + model_uid)
```

> 备注
>
> 对于一些推理引擎，比如 vllm，用户需要在运行模型时指定引擎相关的参数，这种情况下直接在命令行中指定对应的参数名和值即可，比如：
>
> ```bash
> xinference launch --model-engine vllm -n qwen2.5-instruct -s 0_5 -f pytorch --gpu_memory_utilization 0.9
> ```

在运行模型时，gpu_memory_utilization=0.9 会传到 vllm 后端。

到这一步，已经成功通过 Xinference 将 `qwen2.5-instruct` 运行起来了。一旦这个模型在运行中，可以通过命令行、cURL 或者是 Python 代码来预支交互：

```bash
curl -X 'POST' \
  'http://127.0.0.1:9997/v1/chat/completions' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "qwen2.5-instruct",
    "messages": [
        {
            "role": "system",
            "content": "You are a helpful assistant."
        },
        {
            "role": "user",
            "content": "What is the largest animal?"
        }
    ]
  }'
```

```python
from xinference.client import RESTfulClient
client = RESTfulClient("http://127.0.0.1:9997")
model = client.get_model("qwen2.5-instruct")
model.chat(
    messages=[
        {"role": "user", "content": "Who won the world series in 2020?"}
    ]
)
```

输出如下：

```json
{
  "id": "chatcmpl-8d76b65a-bad0-42ef-912d-4a0533d90d61",
  "model": "qwen2.5-instruct",
  "object": "chat.completion",
  "created": 1688919187,
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The largest animal that has been scientifically measured is the blue whale, which has a maximum length of around 23 meters (75 feet) for adult animals and can weigh up to 150,000 pounds (68,000 kg). However, it is important to note that this is just an estimate and that the largest animal known to science may be larger still. Some scientists believe that the largest animals may not have a clear \"size\" in the same way that humans do, as their size can vary depending on the environment and the stage of their life."
      },
      "finish_reason": "None"
    }
  ],
  "usage": {
    "prompt_tokens": -1,
    "completion_tokens": -1,
    "total_tokens": -1
  }
}
```

Xinference 提供了与 OpenAI 兼容的 API，所以可以将 Xinference 运行的模型当成 OpenAI 的本地替代。比如：

```bash
from openai import OpenAI
client = OpenAI(base_url="http://127.0.0.1:9997/v1", api_key="not used actually")

response = client.chat.completions.create(
    model="qwen2.5-instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is the largest animal?"}
    ]
)
print(response)
```

以下是支持的 OpenAI 的 API：

- 对话生成：https://platform.openai.com/docs/api-reference/chat
- 生成: https://platform.openai.com/docs/api-reference/completions
- 向量生成：https://platform.openai.com/docs/api-reference/embeddings

#### 管理模型

除了启动模型，Xinference 提供了管理模型整个生命周期的能力。同样的，可以使用命令行、cURL 以及 Python 代码来管理：

可以列出所有 Xinference 支持的指定类型的模型：

```bash
xinference registrations -t LLM
```

```bash
curl http://127.0.0.1:9997/v1/model_registrations/LLM
```

```python
from xinference.client import RESTfulClient
client = RESTfulClient("http://127.0.0.1:9997")
print(client.list_model_registrations(model_type='LLM'))
```

接下来的命令可以列出所有在运行的模型：

```bash
xinference list
```

```bash
curl http://127.0.0.1:9997/v1/models
```

```python
from xinference.client import RESTfulClient
client = RESTfulClient("http://127.0.0.1:9997")
print(client.list_models())
```

当不需要某个正在运行的模型，可以通过以下的方式来停止它并释放资源：

```bash
xinference terminate --model-uid "qwen2.5-instruct"
```

```bash
curl -X DELETE http://127.0.0.1:9997/v1/models/qwen2.5-instruct
```

```bash
from xinference.client import RESTfulClient
client = RESTfulClient("http://127.0.0.1:9997")
client.terminate_model(model_uid="qwen2.5-instruct")
```

### 集群中部署 Xinference

若要在集群环境中部署 Xinference，需要在一台机器中启动 supervisor 节点，并在当前或者其他节点启动 worker 节点。

#### 启动 Supervisor

在服务器上执行以下命令来启动 Supervisor 节点：

```bash
xinference-supervisor -H "${supervisor_host}"
```

用当前节点的 IP 来替换 `${supervisor_host}` 。

可以在 `http://${supervisor_host}:9997/ui` 访问 web UI，在 `http://${supervisor_host}:9997/docs` 访问 API 文档。

#### 启动 Worker

在需要启动 Xinference worker 的机器上执行以下命令：

```bash
xinference-worker -e "http://${supervisor_host}:9997" -H "${worker_host}"
```

> 备注
>
> 需要注意的是，必须使用当前 Worker 节点的 IP 来替换 `${worker_host}` 。

> 备注
>
> 需要注意的是，如果需要通过命令行与集群交互，应该通过 `-e` 或者 `--endpoint` 参数来指定 supervisor 的地址，比如：
>
> ```bash
> xinference launch -n qwen2.5-instruct -s 0_5 -f pytorch -e "http://${supervisor_host}:9997"
> ```

### 使用 Docker 部署 Xinference

用以下命令在容器中运行 Xinference：

#### 在拥有英伟达显卡的机器上运行

```bash
docker run -e XINFERENCE_MODEL_SRC=modelscope -p 9998:9997 --gpus all xprobe/xinference:<your_version> xinference-local -H 0.0.0.0 --log-level debug
```

#### 在只有 CPU 的机器上运行

```bash
docker run -e XINFERENCE_MODEL_SRC=modelscope -p 9998:9997 xprobe/xinference:<your_version>-cpu xinference-local -H 0.0.0.0 --log-level debug
```

将 `<your_version>` 替换为 Xinference 的版本，比如 `v0.10.3`，可以用 `latest` 来用于最新版本。

## 日志

### 日志等级

可以通过 `--log-level` 选项来配置 Xinference 集群的日志等级。例如，以 `DEBUG` 日志等级启动 Xinference 本地集群：

```bash
xinference-local --log-level debug
```

### 日志文件

Xinference 支持滚动日志文件。默认情况下，当单个日志文件达到 100MB 时会生成新的日志备份文件，系统会保留最近的30份日志备份。上述配置日志等级的方式会同时影响命令行日志和日志文件。

#### 日志目录结构

首先，所有的日志存储在 `<XINFERENCE_HOME>/logs` 目录中，其中 `<XINFERENCE_HOME>` 的配置方式请参考 [使用](https://inference.readthedocs.io/zh-cn/latest/getting_started/using_xinference.html#using-xinference) 。

其次，Xinference 在日志目录 `<XINFERENCE_HOME>/logs` 下创建一个子目录。子目录的名称对应于 Xinference 集群启动的时间（以毫秒为单位）。

#### 本地部署

在本地部署中，Xinference supervisor 和 Xinference workers 的日志被合并到一个文件中。日志目录结构如下所示：

```bash
<XINFERENCE_HOME>/logs
    └── local_1699503558105
        └── xinference.log
```

其中，`1699503558105` 是 Xinference 集群创建时的时间戳。因此，当你在本地多次创建集群时，可以根据此时间戳查找相应的日志。

#### 分布式部署

在分布式部署中，Xinference supervisor 和 Xinference workers 分别在日志目录下创建自己的子目录。子目录的名称以集群角色名称开头，然后是启动时间（以毫秒为单位）。如下所示：

```bash
<XINFERENCE_HOME>/logs
    └── supervisor_1699503558908
        └── xinference.log
        worker_1699503559105
        └── xinference.log
```

## 环境变量

* XINFERENCE_ENDPOINT

  Xinference 的服务地址，用来与 Xinference 连接。默认地址是 http://127.0.0.1:9997，可以在日志中获得这个地址。

* XINFERENCE_MODEL_SRC

  配置模型下载仓库。默认下载源是 “huggingface”，也可以设置为 “modelscope” 作为下载源。

* XINFERENCE_HOME

  Xinference 默认使用 `<HOME>/.xinference` 作为默认目录来存储模型以及日志等必要的文件。其中 `<HOME>` 是当前用户的主目录。可以通过配置这个环境变量来修改默认目录。

* XINFERENCE_HEALTH_CHECK_ATTEMPTS

  Xinference 启动时健康检查的次数，如果超过这个次数还未成功，启动会报错，默认值为 3。

* XINFERENCE_HEALTH_CHECK_INTERVAL

  Xinference 启动时健康检查的时间间隔，如果超过这个时间还未成功，启动会报错，默认值为 3。

* XINFERENCE_DISABLE_HEALTH_CHECK

  在满足条件时，Xinference 会自动汇报worker健康状况，设置改环境变量为 1可以禁用健康检查。

* XINFERENCE_DISABLE_METRICS

  Xinference 会默认在 supervisor 和 worker 上启用 metrics exporter。设置环境变量为 1可以在 supervisor 上禁用 /metrics 端点，并在  worker 上禁用 HTTP 服务（仅提供 /metrics 端点）

## 故障排除

### 没有 huggingface 仓库权限

获取模型时，有时候会遇到权限问题。比如在获取 `llama2` 模型时可能会有以下提示：

```
Cannot access gated repo for url https://huggingface.co/api/models/meta-llama/Llama-2-7b-hf.
Repo model meta-llama/Llama-2-7b-hf is gated. You must be authenticated to access it.
```

这种情况一般是缺少 huggingface 仓库的权限，或者是没有配置 huggingface token。可以按照接下来的方式解决这个问题。

#### 申请 huggingface 仓库权限

想要获取访问权限，打开对应的 huggingface 仓库，同意其条款和注意事项。以 `llama2` 为例，可以打开这个链接去申请：https://huggingface.co/meta-llama/Llama-2-7b-hf.

#### 设置访问 huggingface 凭证

可以在 huggingface 页面找到凭证，https://huggingface.co/settings/tokens.

可以通过设置环境变量设置访问凭证，`export HUGGING_FACE_HUB_TOKEN=your_token_here`。

### 英伟达驱动和 PyTorch 版本不匹配

如果你在使用英伟达显卡，你可能会遇到以下错误：

```
UserWarning: CUDA initialization: The NVIDIA driver on your system is too old
(found version 10010). Please update your GPU driver by downloading and installi
ng a new version from the URL: http://www.nvidia.com/Download/index.aspx Alterna
tively, go to: https://pytorch.org to install a PyTorch version that has been co
mpiled with your version of the CUDA driver. (Triggered internally at  ..\c10\cu
da\CUDAFunctions.cpp:112.)
```

这种情况一般是 CUDA 的版本和 Pytorch 版本不兼容导致的。

可以到 https://pytorch.org 官网安装和 CUDA 对应的预编译版本的 PyTorch。同时，**请检查安装的 CUDA 版本不要小于 11.8，最好版本在 11.8 到 12.1之间。**

比如你的 CUDA 版本是 11.8，可以使用以下命令安装对应的 PyTorch：

```
pip install torch==2.0.1+cu118
```

### 外部系统无法通过 `<IP>:9997` 访问 Xinference 服务

在启动 Xinference 时记得要加上 `-H 0.0.0.0` 参数:

```
xinference-local -H 0.0.0.0
```

那么 Xinference 服务将监听所有网络接口（而不仅限于 `127.0.0.1` 或 `localhost`）。

如果使用的是 [Docker 镜像](https://inference.readthedocs.io/zh-cn/latest/getting_started/using_docker_image.html#using-docker-image)，请在 Docker 运行命令中 加上 `-p <PORT>:9997` ，，你就可以通过本地机器的 `<IP>:<PORT>` 进行访问。

### 启动内置模型需要很长时间，模型有时下载失败

Xinference 默认使用 HuggingFace作为模型源。如果你的机器在中国大陆，使用内置模型可能会有访问问题。

要解决这个问题，可以在启动 Xinference 时添加环境变量 `XINFERENCE_MODEL_SRC=modelscope`，将模型源更改为 ModelScope，在中国大陆速度下载更快。

如果你用 Docker 启动 Xinference，可以在 Docker 命令中包含 `-e XINFERENCE_MODEL_SRC=modelscope` 选项。

### 使用官方 Docker 映像时，RayWorkerVllm 因 OOM 而死亡，导致模型无法加载

Docker 的 `--shm-size` 参数可以用来设置共享内存的大小。共享内存(/dev/shm)的默认大小是 64MB，对于 vLLM 后端来说可能不够。

你可以通过设置参数 `--shm-size` 来增加它的大小：

```
docker run --shm-size=128g ...
```

### 加载 LLM 模型时提示缺失 `model_engine` 参数

自 `v0.11.0` 版本开始，加载 LLM 模型时需要传入额外参数 `model_engine` 。具体信息请参考 [这里](https://inference.readthedocs.io/zh-cn/latest/getting_started/using_xinference.html#about-model-engine) 。

## 使用 Xinference 开发真实场景的 AI 应用

### LLM

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

# Chat to LLM
model.chat(
   messages=[{"role": "system", "content": "You are a helpful assistant"}, {"role": "user", "content": "What is the largest animal?"}],
   generate_config={"max_tokens": 1024}
)

# Chat to VL model
model.chat(
   messages=[
     {
        "role": "user",
        "content": [
           {"type": "text", "text": "What’s in this image?"},
           {
              "type": "image_url",
              "image_url": {
                 "url": "http://i.epochtimes.com/assets/uploads/2020/07/shutterstock_675595789-600x400.jpg",
              },
           },
        ],
     }
  ],
  generate_config={"max_tokens": 1024}
)
```

### Embedding

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

model.create_embedding("What is the capital of China?")
```



### Image

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

model.text_to_image("An astronaut walking on the mars")
```



### Audio

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

with open("speech.mp3", "rb") as audio_file:
    model.transcriptions(audio_file.read())
```



### Rerank

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

query = "A man is eating pasta."
corpus = [
  "A man is eating food.",
  "A man is eating a piece of bread.",
  "The girl is carrying a baby.",
  "A man is riding a horse.",
  "A woman is playing violin."
]
print(model.rerank(corpus, query))
```



### Video

```
from xinference.client import Client

client = Client("http://localhost:9997")
model = client.get_model("MODEL_UID")

model.text_to_video("")
```

## 企业版和开源版本的对比

| 功能           | 企业版本                           | 开源版本                       |
| -------------- | ---------------------------------- | ------------------------------ |
| 用户权限管理   | 用户权限、单点登录、加密认证       | tokens 授权                    |
| 集群能力       | SLA 调度、租户隔离、弹性伸缩       | 抢占调度                       |
| 引擎支持       | 优化过的 vLLM、SGLang、TensorRT    | vLLM、SGLang                   |
| 批处理         | 支持大量调用的定制批处理           | 无                             |
| 微调           | 支持上传数据集微调                 | 无                             |
| 国产 GPU 支持  | 昇腾、海光、天数、寒武纪、沐曦     | 无                             |
| 模型管理       | 可私有部署的模型下载和管理服务     | 依赖 modelscope 和 huggingface |
| 故障检测和恢复 | 自动检测节点故障并进行故障复位     | 无                             |
| 高可用         | 所有节点都是冗余部署支持服务高可用 | 无                             |
| 监控           | 监控指标 API 接口，和现有系统集成  | 页面显示                       |
| 运维           | 远程 cli 部署、不停机升级          | 无                             |
| 服务           | 远程技术支持和自动升级服务         | 社区支持                       |
