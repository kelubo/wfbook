# MicroK8s on NVIDIA DGX NVIDIA DGX 上的 MicroK8s

#### On this page 本页内容

​                                                [Verify the installation 验证安装](https://microk8s.io/docs/nvidia-dgx#verify-the-installation)                                                      [Multi-Instance GPU (MIG) 多实例 GPU （MIG）](https://microk8s.io/docs/nvidia-dgx#multi-instance-gpu-mig)                                                              

On DGX systems you will need to enable GPU support right after you install MicroK8s:
在 DGX 系统上，您需要在安装 MicroK8s 后立即启用 GPU 支持：

```bash
sudo snap install microk8s --classic
sudo microk8s enable gpu
```

MicroK8s installs the NVIDIA operator which allows you to take advantage of the GPU hardware available.
MicroK8s 安装了 NVIDIA 运算符，允许您利用可用的 GPU 硬件。

### [Verify the installation 验证安装](https://microk8s.io/docs/nvidia-dgx#verify-the-installation)

To verify the installation works as expected you can try to perform a CUDA vector addition by applying the following manifest (save this file and  use [kubectl apply](https://kubectl.docs.kubernetes.io/references/kubectl/apply/)):
要验证安装是否按预期工作，您可以尝试通过应用以下清单来执行 CUDA 向量添加（保存此文件并使用 [kubectl apply](https://kubectl.docs.kubernetes.io/references/kubectl/apply/)）：

```auto
apiVersion: v1
kind: Pod
metadata:
  name: cuda-vector-add
spec:
  restartPolicy: OnFailure
  containers:
    - name: cuda-vector-add
      image: "k8s.gcr.io/cuda-vector-add:v0.1"
      resources:
        limits:
          nvidia.com/gpu: 1
```

After the addition completes, check the logs of the `cuda-vector-add` pod to see if it succeeded.
添加完成后，检查 `cuda-vector-add` pod 的日志，看看它是否成功。

### [Multi-Instance GPU (MIG) 多实例 GPU （MIG）](https://microk8s.io/docs/nvidia-dgx#multi-instance-gpu-mig)

Multi-Instance GPU (MIG) allows GPU partitioning so they can be safely used by CUDA  applications. Starting from MicroK8s v1.23 MIG can be configured via  configMaps, please see the [NVIDIA operator docs](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/gpu-operator-mig.html) on this topic.
多实例 GPU （MIG） 允许 GPU 分区，以便 CUDA 应用程序可以安全地使用它们。从 MicroK8s v1.23 开始，可以通过 configMaps 配置 MIG，请参阅有关此主题的 [NVIDIA作员文档](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/gpu-operator-mig.html)。