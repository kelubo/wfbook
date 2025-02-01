# 支持 QUIC 和 HTTP/3

[TOC]

从 1.25.0 开始支持 QUIC 和 HTTP/3 协议。此外，从 1.25.0 开始，QUIC 和 HTTP/3 支持在 Linux 二进制包中可用。

> Note:
> QUIC 和 HTTP/3 支持是实验性的，caveat emptor applies. 需要注意的是。

## 从源代码构建

使用 `configure` 命令进行配置。

当配置 nginx 时，可以使用 `--with-http_v3_module` 参数启用 QUIC 和 HTTP/3 。

推荐使用提供 QUIC 支持的 SSL 库来构建 nginx，例如 BoringSSL、LibreSSL 或 QuicTLS。否则，将使用不支持早期数据的 OpenSSL 兼容层。 the [OpenSSL](https://openssl.org) compatibility layer will be used that does not support [early data](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_early_data). 

通过以下命令使用 BoringSSL 配置 nginx：

```bash
./configure
    --with-debug
    --with-http_v3_module
    --with-cc-opt="-I../boringssl/include"
    --with-ld-opt="-L../boringssl/build/ssl
                   -L../boringssl/build/crypto"
```

或者，可以用 QuicTLS 配置 nginx ：

```bash
./configure
    --with-debug
    --with-http_v3_module
    --with-cc-opt="-I../quictls/build/include"
    --with-ld-opt="-L../quictls/build/lib"
```

或者，可以用现代版本的 LibreSSL 配置 nginx ：

```bash
./configure
    --with-debug
    --with-http_v3_module
    --with-cc-opt="-I../libressl/build/include"
    --with-ld-opt="-L../libressl/build/lib"
```

配置完成后，使用 `make` 进行编译和安装。

## 配置

ngx_http_core_module 模块中的 listen 指令获得了一个新参数 quic，该参数在指定端口上通过 QUIC 启用 HTTP/3。

除了参数 `quic` 之外，还可以指定 reuseport 参数，使其在多个 worker 线程中正常工作。

要启用地址验证，请执行以下操作：

```bash
quic_retry on;
```

要启用 0-RTT，请执行以下操作：

```bash
ssl_early_data on;
```

要启用 GSO（Generic Segmentation Offloading通用分段卸载），请执行以下操作：

```bash
quic_gso on;
```

To [set](http://nginx.org/en/docs/http/ngx_http_v3_module.html#quic_host_key) host key for various tokens: 
要为各种令牌设置主机密钥，请执行以下操作：

```bash
quic_host_key <filename>;
```

QUIC 需要 TLSv1.3 协议版本，默认情况下在 ssl_protocols 指令中启用该协议版本。

默认情况下，GSO Linux-specific optimization  Linux 特定的优化处于禁用状态。如果相应的网络接口配置为支持 GSO，请启用它。

配置示例

```bash
http {
    log_format quic '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" "$http3"';

    access_log logs/access.log quic;

    server {
        # for better compatibility it's recommended
        # to use the same port for quic and https
        listen 8443 quic reuseport;
        listen 8443 ssl;

        ssl_certificate     certs/example.com.crt;
        ssl_certificate_key certs/example.com.key;

        location / {
            # required for browsers to direct them to quic port
            add_header Alt-Svc 'h3=":8443"; ma=86400';
        }
    }
}
```

## 故障排除

可能有助于识别问题的提示：

- 确保 nginx 是使用正确的 SSL 库构建的。

- 确保 nginx 在运行时使用正确的 SSL 库（ `nginx -V` 显示它当前使用的内容）。

- 确保客户端确实通过 QUIC 发送请求。建议从简单的控制台客户端（如 ngtcp2）开始，以确保服务器配置正确，然后再尝试使用可能对证书非常挑剔的真实浏览器。

- 构建具有调试支持的 nginx 并检查调试日志。它应包含有关连接及其失败原因的所有详细信息。所有相关消息都包含“ `quic` ”前缀，可以很容易地过滤掉。

- 若要进行更深入的调查，可以使用以下宏，启用其他调试： `NGX_QUIC_DEBUG_PACKETS` 、`NGX_QUIC_DEBUG_FRAMES` 、 `NGX_QUIC_DEBUG_ALLOC`  、`NGX_QUIC_DEBUG_CRYPTO` 。

  ```bash
  ./configure
      --with-http_v3_module
      --with-debug
      --with-cc-opt="-DNGX_QUIC_DEBUG_PACKETS -DNGX_QUIC_DEBUG_CRYPTO"
  ```