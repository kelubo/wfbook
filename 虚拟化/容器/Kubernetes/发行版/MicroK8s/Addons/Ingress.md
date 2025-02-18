# 插件：Ingress

This addon adds an  [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx) for MicroK8s.  It is enabled by running the command:
此插件为 MicroK8s 添加了一个 [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx)。它通过运行以下命令来启用：

```bash
microk8s enable ingress
```

With the Ingress addon enabled, a HTTP/HTTPS ingress rule can be created with an Ingress resource. For example:
启用 Ingress 插件后，可以使用 Ingress 资源创建 HTTP/HTTPS Ingress 规则。例如：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: http-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: some-service
            port:
              number: 80
```

Additionally, the ingress addon can be configured to expose TCP and UDP services by editing the `nginx-ingress-tcp-microk8s-conf` and `nginx-ingress-udp-microk8s-conf` ConfigMaps respectively, and then exposing the port in the Ingress controller.
此外，Ingress 插件可以配置为公开 TCP 和 UDP 服务，方法是分别编辑 `nginx-ingress-tcp-microk8s-conf` 和 `nginx-ingress-udp-microk8s-conf` ConfigMap，然后在 Ingress 控制器中公开端口。

For example, here a Redis service is exposed via TCP:
例如，此处通过 TCP 公开了 Redis 服务：

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-ingress-tcp-microk8s-conf
  namespace: ingress
data:
  6379: "default/redis:6379"
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-ingress-microk8s-controller
  namespace: ingress
spec:
  template:
    spec:
      containers:
      - name: nginx-ingress-microk8s
        ports:
        - containerPort: 80
        - containerPort: 443
        - name: proxied-tcp-6379
          containerPort: 6379
          hostPort: 6379
          protocol: TCP
```