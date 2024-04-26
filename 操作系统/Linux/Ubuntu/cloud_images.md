# Cloud images 云图 

Canonical produces a variety of cloud-specific images, which are available directly via the clouds themselves, as well as on https://cloud-images.ubuntu.com.
Canonical生成了各种特定于云的图像，这些图像可以直接通过云本身获得，也可以在https://cloud-images.ubuntu.com上获得。

## Public clouds 公共云 

### Compute offerings 计算产品 

Users can find Ubuntu images for virtual machines and bare-metal offerings published directly to the following clouds:
用户可以找到直接发布到以下云的虚拟机和裸机产品的Ubuntu映像： 

- [Amazon Elastic Compute Cloud (EC2)
   Amazon Elastic Compute Cloud（EC2）](https://canonical-aws.readthedocs-hosted.com/en/latest/aws-how-to/instances/find-ubuntu-images/)
- [Google Cloud Engine (GCE)
   Google Cloud Engine（GCE）](https://canonical-gcp.readthedocs-hosted.com/en/latest/google-how-to/gce/find-ubuntu-images/)
- IBM Cloud
- [Microsoft Azure](https://canonical-azure.readthedocs-hosted.com/en/latest/azure-how-to/instances/find-ubuntu-images/)
- Oracle Cloud Oracle云 

### Container offerings 容器产品 

Ubuntu images are also produced for a number of container offerings:
Ubuntu映像也为许多容器产品生成： 

- [Amazon Elastic Kubernetes Service (EKS)
   Amazon Elastic Kubernetes Service（EKS）](https://cloud-images.ubuntu.com/docs/aws/eks/)
- Google Kubernetes Engine (GKE)
  Google Kubernetes Engine（GKE） 

## Private clouds 私有云 

On [cloud-images.ubuntu.com](https://cloud-images.ubuntu.com), users can find standard and minimal images for the following:
在cloud-images.ubuntu.com上，用户可以找到以下标准和最小图像：

- Hyper-V
- KVM
- OpenStack
- Vagrant 流浪 
- VMware

## Release support 释放支承 

Cloud images are published and supported throughout the [lifecycle of an Ubuntu release](https://ubuntu.com/about/release-cycle). During this time images can receive all published security updates and bug fixes.
云映像在Ubuntu发行版的整个生命周期中都得到发布和支持。在此期间，映像可以接收所有已发布的安全更新和错误修复。

For users wanting to upgrade from one release to the next, the recommended  path is to launch a new image with the desired release and then migrate  any workload or data to the new image.
对于希望从一个版本升级到下一个版本的用户，推荐的方法是使用所需版本启动新映像，然后将任何工作负载或数据迁移到新映像。 

Some cloud image customisation must be applied during image creation, which  would be missing if an in-place upgrade were performed. For that reason, in-place upgrades of cloud images are not recommended.
在映像创建期间必须应用一些云映像自定义，如果执行就地升级，则会丢失这些自定义。因此，不建议对云映像进行就地升级。 

------