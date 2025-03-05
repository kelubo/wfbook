# FAQ

[TOC]

## 如何升级 Ollama？

macOS 和 Windows 上的 Ollama 将自动下载更新。单击任务栏或菜单栏项，然后单击“重新启动以更新”以应用更新。也可以通过[手动](https://ollama.com/download/)下载最新版本来安装更新。

在 Linux 上，重新运行安装脚本：

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

## 如何查看日志？

查看[故障排除](https://github.com/ollama/ollama/blob/main/docs/troubleshooting.md)文档，了解有关使用日志的更多信息。

## 我的 GPU 与 Ollama 兼容吗？

请参阅 [GPU 文档](https://github.com/ollama/ollama/blob/main/docs/gpu.md)。

## 如何指定上下文窗口大小？

默认情况下，Ollama 使用的上下文窗口大小为 2048 个令牌。

要在使用 `ollama run` 时更改此设置，请使用 `/set parameter`：

```bash
/set parameter num_ctx 4096
```

使用 API 时，请指定 `num_ctx` 参数：

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Why is the sky blue?",
  "options": {
    "num_ctx": 4096
  }
}'
```

## 如何判断我的模型是否已加载到 GPU 上？

使用 `ollama ps` 命令查看当前加载到内存中的模型。

```bash
ollama ps
```

输出：

```bash
NAME      	ID          	SIZE 	PROCESSOR	UNTIL
llama3:70b	bcfb190ca3a7	42 GB	100% GPU 	4 minutes from now
```

`Processor` 列将显示模型加载到哪个内存：

- `100% GPU` 表示模型已完全加载到 GPU 中
- `100% CPU` 表示模型完全加载到系统内存中
- `48%/52% CPU/GPU` 意味着模型部分加载到 GPU 和系统内存中

## 如何配置 Ollama 服务器？

Ollama server can be configured with environment variables.
Ollama 服务器可以配置环境变量。

### 在 Mac 上设置环境变量

如果 Ollama 作为 macOS 应用程序运行，则应使用 `launchctl` 设置环境变量：

1. 对于每个环境变量，调用 `launchctl setenv`。
   
   ```bash
   launchctl setenv OLLAMA_HOST "0.0.0.0:11434"
   ```
   
1. 重新启动 Ollama 应用程序。

### 在 Linux 上设置环境变量

如果 Ollama 作为 systemd 服务运行，则应使用 `systemctl` 设置环境变量：

1. 通过调用 `systemctl edit ollama.service` 编辑 systemd 服务。这将打开一个编辑器。

2. 对于每个环境变量，在部分 `[Service]` 下添加一行 `Environment`：

   ```
   [Service]
   Environment="OLLAMA_HOST=0.0.0.0:11434"
   ```

3. 保存并退出。

4. 重新加载 `systemd` 并重启 Ollama：

   ```bash
   systemctl daemon-reload
   systemctl restart ollama    
   ```

### 在 Windows 上设置环境变量

在 Windows 上，Ollama 会继承您的用户和系统环境变量。

1. 首先，通过在任务栏中单击它来退出 Ollama。
2. 启动设置 （Windows 11） 或控制面板 （Windows 10） 应用程序并搜索*环境变量*。
3. 单击 *Edit environment variables（编辑您账户的环境变量*）。
4. Edit or create a new variable for your user account for `OLLAMA_HOST`, `OLLAMA_MODELS`, etc.
   为您的用户帐户编辑或创建一个新变量，用于 `OLLAMA_HOST`、`OLLAMA_MODELS` 等。
5. 单击 确定/应用 保存。
6. 从 Windows 开始菜单启动 Ollama 应用程序。

## 如何在代理后面使用 Ollama？

Ensure the proxy  certificate is installed as a system certificate. Refer to the section  above for how to use environment variables on your platform.
Ollama 从 Internet 中提取模型，并且可能需要代理服务器才能访问模型。使用 `HTTPS_PROXY` 通过代理重定向出站请求。确保代理证书作为系统证书安装。有关如何在您的平台上使用环境变量的信息，请参阅上面的部分。

> 注意
>
> 避免设置 `HTTP_PROXY` 。Ollama 不使用 HTTP 进行模型拉取，只使用 HTTPS。设置 `HTTP_PROXY` 可能会中断客户端与服务器的连接。

### 如何在 Docker 中的代理后面使用 Ollama？

The Ollama Docker container image can be configured to use a proxy by passing `-e HTTPS_PROXY=https://proxy.example.com` when starting the container.
Ollama Docker 容器镜像可以通过在启动容器时传递 `-e HTTPS_PROXY=https://proxy.example.com` 来配置为使用代理。

Alternatively, the Docker daemon can be configured to use a proxy. Instructions are available for Docker Desktop on [macOS](https://docs.docker.com/desktop/settings/mac/#proxies), [Windows](https://docs.docker.com/desktop/settings/windows/#proxies), and [Linux](https://docs.docker.com/desktop/settings/linux/#proxies), and Docker [daemon with systemd](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy).
或者，可以将 Docker 守护程序配置为使用代理。有关说明，请参阅 [macOS、](https://docs.docker.com/desktop/settings/mac/#proxies)[Windows](https://docs.docker.com/desktop/settings/windows/#proxies) 和 [Linux](https://docs.docker.com/desktop/settings/linux/#proxies) 上的 Docker Desktop，以及[带有 systemd 的 Docker 守护程序](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy)。

Ensure the certificate is installed as a system certificate when using HTTPS.  This may require a new Docker image when using a self-signed  certificate.
确保在使用 HTTPS 时将证书安装为系统证书。使用自签名证书时，这可能需要新的 Docker 映像。

```
FROM ollama/ollama
COPY my-ca.pem /usr/local/share/ca-certificates/my-ca.crt
RUN update-ca-certificates
```

构建并运行此镜像：

```
docker build -t ollama-with-ca .
docker run -d -e HTTPS_PROXY=https://my.proxy.example.com -p 11434:11434 ollama-with-ca
```

## Ollama 会将我的提示和答案发回给 ollama.com 吗？

不。Ollama 在本地运行，对话数据不会离开您的机器。

## 如何在我的网络上公开 Ollama？

Ollama binds 127.0.0.1 port 11434 by default. Change the bind address with the `OLLAMA_HOST` environment variable.
Ollama 默认绑定 127.0.0.1 端口 11434。使用 `OLLAMA_HOST` 环境变量更改绑定地址。

## 如何将 Ollama 与代理服务器一起使用？



Ollama runs an HTTP server and can be exposed using a proxy server such as  Nginx. To do so, configure the proxy to forward requests and optionally  set required headers (if not exposing Ollama on the network). For  example, with Nginx:
Ollama 运行 HTTP 服务器，可以使用 Nginx 等代理服务器进行公开。为此，请将代理配置为转发请求，并选择性地设置所需的标头（如果不在网络上公开 Ollama）。例如，使用 Nginx：

```
server {
    listen 80;
    server_name example.com;  # Replace with your domain or IP
    location / {
        proxy_pass http://localhost:11434;
        proxy_set_header Host localhost:11434;
    }
}
```

​    

## How can I use Ollama with ngrok? 如何将 Ollama 与 ngrok 一起使用？



Ollama can be accessed using a range of tools for tunneling tools. For example with Ngrok:
可以使用一系列隧道工具访问 Ollama。例如，使用 Ngrok：

```
ngrok http 11434 --host-header="localhost:11434"
```

​    

## How can I use Ollama with Cloudflare Tunnel? 如何将 Ollama 与 Cloudflare Tunnel 一起使用？



To use Ollama with Cloudflare Tunnel, use the `--url` and `--http-host-header` flags:
要将 Ollama 与 Cloudflare Tunnel 一起使用，请使用 `--url` 和 `--http-host-header` 标志：

```
cloudflared tunnel --url http://localhost:11434 --http-host-header="localhost:11434"
```

​    

## How can I allow additional web origins to access Ollama? 如何允许其他 Web 源访问 Ollama？



Ollama allows cross-origin requests from `127.0.0.1` and `0.0.0.0` by default. Additional origins can be configured with `OLLAMA_ORIGINS`.
默认情况下，Ollama 允许来自 `127.0.0.1` 和 `0.0.0.0` 的跨域请求。可以使用 `OLLAMA_ORIGINS` 配置其他源。

Refer to the section [above](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server) for how to set environment variables on your platform.
有关如何在平台上设置环境变量的信息，请参阅[上述](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server)部分。

## 模型存储在哪里？

- macOS：`~/.ollama/models`
- Linux: `/usr/share/ollama/.ollama/models`
- Windows: `C:\Users\%username%\.ollama\models`

### 如何将它们设置为其他位置？

如果需要使用其他目录，请将环境变量 `OLLAMA_MODELS` 设置为所选目录。

> Note: on Linux using the standard installer, the `ollama` user needs read and write access to the specified directory. To assign the directory to the `ollama` user run `sudo chown -R ollama:ollama <directory>`.
> 注意：在使用标准安装程序的 Linux 上，`ollama` 用户需要对指定目录的读写权限。要将目录分配给 `ollama` 用户，请运行 `sudo chown -R ollama:ollama <directory>` 。

## 如何在 Visual Studio Code 中使用 Ollama？

There is already a large collection of plugins available for VSCode as well  as other editors that leverage Ollama. See the list of [extensions & plugins](https://github.com/ollama/ollama#extensions--plugins) at the bottom of the main repository readme.
已经有大量插件可用于 VSCode 以及其他利用 Ollama 的编辑器。请参阅主存储库自述文件底部的[扩展和插件](https://github.com/ollama/ollama#extensions--plugins)列表。

## 如何在 Docker 中使用带有 GPU 加速的 Ollama？



The Ollama Docker container can be configured with GPU acceleration in Linux or Windows (with WSL2). This requires the [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit). See [ollama/ollama](https://hub.docker.com/r/ollama/ollama) for more details.
Ollama Docker 容器可以在 Linux 或 Windows 中配置 GPU 加速（使用 WSL2）。这需要 [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)。有关更多详细信息，请参阅 [ollama/ollama](https://hub.docker.com/r/ollama/ollama)。

GPU acceleration is not available for Docker Desktop in macOS due to the lack of GPU passthrough and emulation.
由于缺少 GPU 直通和仿真，macOS 中的 Docker Desktop 无法使用 GPU 加速。

## Why is networking slow in WSL2 on Windows 10? 为什么 Windows 2 上的 WSL10 中的网络速度很慢？



This can impact both installing Ollama, as well as downloading models.
这可能会影响安装 Ollama 和下载模型。

Open `Control Panel > Networking and Internet > View network status and tasks` and click on `Change adapter settings` on the left panel. Find the `vEthernel (WSL)` adapter, right click and select `Properties`. Click on `Configure` and open the `Advanced` tab. Search through each of the properties until you find `Large Send Offload Version 2 (IPv4)` and `Large Send Offload Version 2 (IPv6)`. *Disable* both of these properties.
打开 `Control Panel > Networking and Internet > View network status and tasks` 并单击左侧面板上的 `Change adapter settings（更改适配器设置`）。找到 `vEthernel （WSL）` 适配器，右键单击并选择 `Properties`。单击 `Configure` 并打开 `Advanced` 选项卡。搜索每个属性，直到找到 `Large Send Offload Version 2 (IPv4)` 和 `Large Send Offload Version 2 (IPv6)` 。*禁用*这两个属性。

## How can I preload a model into Ollama to get faster response times? 如何将模型预加载到 Ollama 中以获得更快的响应时间？



If you are using the API you can preload a model by sending the Ollama server an empty request. This works with both the `/api/generate` and `/api/chat` API endpoints.
如果您使用的是 API，则可以通过向 Ollama 服务器发送空请求来预加载模型。这适用于 `/api/generate` 和 `/api/chat` API 端点。

To preload the mistral model using the generate endpoint, use:
要使用 generate 端点预加载 mistral 模型，请使用：

```
curl http://localhost:11434/api/generate -d '{"model": "mistral"}'
```

​    

To use the chat completions endpoint, use:
要使用聊天完成端点，请使用：

```
curl http://localhost:11434/api/chat -d '{"model": "mistral"}'
```

​    

To preload a model using the CLI, use the command:
要使用 CLI 预加载模型，请使用以下命令：

```
ollama run llama3.2 ""
```

​    

## How do I keep a model loaded in memory or make it unload immediately? 如何将模型保持在内存中加载或使其立即卸载？



By default models are kept in memory for 5 minutes before being unloaded.  This allows for quicker response times if you're making numerous  requests to the LLM. If you want to immediately unload a model from  memory, use the `ollama stop` command:
默认情况下，模型在卸载之前会在内存中保留 5 分钟。如果您向 LLM.如果要立即从内存中卸载模型，请使用 `ollama stop` 命令：

```
ollama stop llama3.2
```

​    

If you're using the API, use the `keep_alive` parameter with the `/api/generate` and `/api/chat` endpoints to set the amount of time that a model stays in memory. The `keep_alive` parameter can be set to:
如果您使用的是 API，请将 `keep_alive` 参数与 `/api/generate` 和 `/api/chat` 终端节点结合使用，以设置模型在内存中保留的时间。`keep_alive` 参数可以设置为：

- a duration string (such as "10m" or "24h")
  持续时间字符串（例如“10m”或“24h”）
- a number in seconds (such as 3600)
  以秒为单位的数字（例如 3600）
- any negative number which will keep the model loaded in memory (e.g. -1 or "-1m")
  任何负数，它将使模型保持在内存中（例如 -1 或 “-1m”）
- '0' which will unload the model immediately after generating a response
  '0' 将在生成响应后立即卸载模型

For example, to preload a model and leave it in memory use:
例如，要预加载模型并将其保留在内存中，请使用：

```
curl http://localhost:11434/api/generate -d '{"model": "llama3.2", "keep_alive": -1}'
```

​    

To unload the model and free up memory use:
要卸载模型并释放内存，请使用：

```
curl http://localhost:11434/api/generate -d '{"model": "llama3.2", "keep_alive": 0}'
```

​    

Alternatively, you can change the amount of time all models are loaded into memory by setting the `OLLAMA_KEEP_ALIVE` environment variable when starting the Ollama server. The `OLLAMA_KEEP_ALIVE` variable uses the same parameter types as the `keep_alive` parameter types mentioned above. Refer to the section explaining [how to configure the Ollama server](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server) to correctly set the environment variable.
或者，您可以通过在启动 Ollama 服务器时设置 `OLLAMA_KEEP_ALIVE` 环境变量来更改所有模型加载到内存中的时间。`OLLAMA_KEEP_ALIVE` 变量使用与上述 `keep_alive` 参数类型相同的参数类型。请参阅说明[如何配置 Ollama 服务器](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server)以正确设置环境变量的部分。

The `keep_alive` API parameter with the `/api/generate` and `/api/chat` API endpoints will override the `OLLAMA_KEEP_ALIVE` setting.
具有 `/api/generate` 和 `/api/chat` API 端点的 `keep_alive` API 参数将覆盖 `OLLAMA_KEEP_ALIVE` 设置。

## How do I manage the maximum number of requests the Ollama server can queue? 如何管理 Ollama 服务器可以排队的最大请求数？



If too many requests are sent to the server, it will respond with a 503  error indicating the server is overloaded.  You can adjust how many  requests may be queue by setting `OLLAMA_MAX_QUEUE`.
如果向服务器发送的请求过多，它将响应 503 错误，指示服务器过载。可以通过设置 `OLLAMA_MAX_QUEUE` 来调整可以排队的请求数。

## Ollama 如何处理并发请求？

Ollama 支持两个级别的并发处理。如果系统有足够的可用内存（使用 CPU 推理时的系统内存，或用于 GPU 推理的 VRAM），则可以同时加载多个模型。对于给定模型，如果在加载模型时有足够的可用内存，则会将其配置为允许并行请求处理。

If there is insufficient available memory to load a new model request  while one or more models are already loaded, all new requests will be  queued until the new model can be loaded.  As prior models become idle,  one or more will be unloaded to make room for the new model.  Queued  requests will be processed in order.  When using GPU inference new  models must be able to completely fit in VRAM to allow concurrent model  loads.
如果在已加载一个或多个模型的情况下没有足够的可用内存来加载新模型请求，则所有新请求都将排队，直到可以加载新模型。当以前的模型变为空闲状态时，将卸载一个或多个模型，以便为新模型腾出空间。排队的请求将按顺序处理。使用 GPU 推理时，新模型必须能够完全适应 VRAM 以允许并发模型加载。

Parallel request processing for a given model results in increasing the context  size by the number of parallel requests.  For example, a 2K context with 4 parallel requests will result in an 8K context and additional memory  allocation.
给定模型的并行请求处理会导致上下文大小增加并行请求的数量。例如，具有 4 个并行请求的 2K 上下文将导致 8K 上下文和额外的内存分配。

以下服务器设置可用于调整 Ollama 在大多数平台上处理并发请求的方式：

- `OLLAMA_MAX_LOADED_MODELS` - The maximum number of models that can be loaded concurrently provided they fit in available memory.  The default is 3 * the number of GPUs or 3 for CPU inference.
  `OLLAMA_MAX_LOADED_MODELS` - 可以并发加载的最大模型数，前提是它们适合可用内存。默认值为 3 * GPU 数量或 3 用于 CPU 推理。
- `OLLAMA_NUM_PARALLEL` - The maximum number of parallel requests each model will process at  the same time.  The default will auto-select either 4 or 1 based on  available memory.
  `OLLAMA_NUM_PARALLEL` - 每个模型将同时处理的最大并行请求数。默认值将根据可用内存自动选择 4 或 1。
- `OLLAMA_MAX_QUEUE` - The maximum number of requests Ollama will queue when busy before rejecting additional requests. The default is 512
  `OLLAMA_MAX_QUEUE` - Ollama 在忙碌时在拒绝其他请求之前将排队的最大请求数。默认值为 512

Note: Windows with Radeon GPUs currently default to 1 model maximum due to  limitations in ROCm v5.7 for available VRAM reporting.  Once ROCm v6.2  is available, Windows Radeon will follow the defaults above.  You may  enable concurrent model loads on Radeon on Windows, but ensure you don't load more models than will fit into your GPUs VRAM.
注意：由于 ROCm v5.7 中对可用 VRAM 报告的限制，配备 Radeon GPU 的 Windows 目前默认为最多 1 个型号。ROCm  v6.2 可用后，Windows Radeon 将遵循上述默认值。您可以在 Windows 上的 Radeon  上启用并发模型加载，但请确保加载的模型数量不会超过 GPU VRAM 的容量。

## Ollama 如何在多个 GPU 上加载模型？

加载新模型时，Ollama 会根据当前可用的 VRAM 评估模型所需的 VRAM。如果模型完全适合任何单个 GPU，则 Ollama 将在该 GPU  上加载模型。这通常提供最佳性能，因为它减少了推理期间通过 PCI 总线传输的数据量。如果模型不能完全安装在一个 GPU  上，则它将分布在所有可用的 GPU 上。

## 如何启用 Flash Attention？



Flash Attention is a feature of most modern models that can significantly  reduce memory usage as the context size grows.  To enable Flash  Attention, set the `OLLAMA_FLASH_ATTENTION` environment variable to `1` when starting the Ollama server.
Flash Attention 是大多数现代模型的一项功能，随着上下文大小的增长，它可以显著减少内存使用量。要启用 Flash Attention，请在启动 Ollama 服务器时将 `OLLAMA_FLASH_ATTENTION` 环境变量设置为 `1`。

## How can I set the quantization type for the K/V cache? 如何设置 K/V 缓存的量化类型？

The K/V context cache can be quantized to significantly reduce memory usage when Flash Attention is enabled.
K/V 上下文缓存可以量化，以便在启用 Flash Attention 时显著减少内存使用。

To use quantized K/V cache with Ollama you can set the following environment variable:
要将量化 K/V 缓存与 Ollama 一起使用，您可以设置以下环境变量：

- `OLLAMA_KV_CACHE_TYPE` - The quantization type for the K/V cache.  Default is `f16`.
  `OLLAMA_KV_CACHE_TYPE` - K/V 缓存的量化类型。默认值为 `f16`。

> Note: Currently this is a global option - meaning all models will run with the specified quantization type.
> 注意：目前这是一个全局选项，这意味着所有模型都将以指定的量化类型运行。

The currently available K/V cache quantization types are:
当前可用的 K/V 缓存量化类型包括：

- `f16` - high precision and memory usage (default).
  `F16` - 高精度和内存使用率（默认）。
- `q8_0` - 8-bit quantization, uses approximately 1/2 the memory of `f16` with a very small loss in precision, this usually has no noticeable  impact on the model's quality (recommended if not using f16).
  `q8_0` - 8 位量化，使用大约 `f16` 的 1/2 内存，精度损失非常小，这通常对模型的质量没有明显影响（如果不使用 f16，建议使用）。
- `q4_0` - 4-bit quantization, uses approximately 1/4 the memory of `f16` with a small-medium loss in precision that may be more noticeable at higher context sizes.
  `q4_0` - 4 位量化，使用的内存大约是 `F16` 的 1/4，精度损失为中小，在较高的上下文大小下可能更明显。

How much the cache quantization impacts the model's response quality will  depend on the model and the task.  Models that have a high GQA count  (e.g. Qwen2) may see a larger impact on precision from quantization than models with a low GQA count.
缓存量化对模型响应质量的影响程度取决于模型和任务。与低 GQA 计数的模型相比，具有高 GQA 计数的模型（例如 Qwen2）可能对量化精度的影响更大。

You may need to experiment with different quantization types to find the best balance between memory usage and quality.
您可能需要尝试不同的量化类型，以在内存使用和质量之间找到最佳平衡。