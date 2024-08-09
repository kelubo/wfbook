# Registry

[TOC]

## 部署

1. 启动 registry 容器。

   ```bash
   docker run -d -p 5000:5000 -v /myregistry:/var/lib/registry registry:2
   ```

2. 调整本地镜像的tag

   ```bash
   docker tag kkkk/httpd:v1 registry.example.net:5000/kkkk/httpd:v1
   ```

3. 上传镜像

   ```bash
   docker push registry.example.net:5000/kkkk/httpd:v1
   ```

4. 下载镜像

   ```bash
   docker pull registry.example.net:5000/kkkk/httpd:v1
   ```

   

