# Install EKS-D with MicroK8s 使用 MicroK8s 安装 EKS-D

#### On this page 本页内容

​                                                [What is EKS-D 什么是 EKS-D](https://microk8s.io/docs/eks-d#what-is-eks-d)                                                      [Deploying EKS-D 部署 EKS-D](https://microk8s.io/docs/eks-d#deploying-eks-d)                                                      [Enable AWS specific addons
启用 AWS 特定的插件](https://microk8s.io/docs/eks-d#enable-aws-specific-addons)                                                                                            [Enabling IAM Authenticator
启用 IAM Authenticator](https://microk8s.io/docs/eks-d#enabling-iam-authenticator)                                                  [Enabling EBS CSI Driver 启用 EBS CSI 驱动程序](https://microk8s.io/docs/eks-d#enabling-ebs-csi-driver)                                                  [Enabling EFS CSI Driver 启用 EFS CSI 驱动程序](https://microk8s.io/docs/eks-d#enabling-efs-csi-driver)                                                                                                    [Links 链接](https://microk8s.io/docs/eks-d#links)                                                              

## [ What is EKS-D 什么是 EKS-D](https://microk8s.io/docs/eks-d#what-is-eks-d)

[Amazon EKS Distro (EKS-D)](https://distro.eks.amazonaws.com/) is a Kubernetes distribution based on and used by Amazon Elastic  Kubernetes Service (Amazon EKS). It provides latest upstream updates as  well as extended security patching support. EKS-D follows the same  Kubernetes version release cycle as Amazon EKS.
[Amazon EKS Distro （EKS-D）](https://distro.eks.amazonaws.com/) 是基于 Amazon Elastic Kubernetes Service （Amazon EKS） 并由 Amazon Elastic  Kubernetes Service （Amazon EKS） 使用的 Kubernetes  发行版。它提供最新的上游更新以及扩展的安全补丁支持。EKS-D 遵循与 Amazon EKS 相同的 Kubernetes 版本发布周期。

## [ Deploying EKS-D 部署 EKS-D](https://microk8s.io/docs/eks-d#deploying-eks-d)

We will need to install MicroK8s with a specific channel that contains the EKS distribution.
我们需要使用包含 EKS 发行版的特定通道安装 MicroK8s。

```auto
sudo snap install microk8s --classic --channel 1.22-eksd/stable
```

MicroK8s channels are frequently updated with the each release of EKS-D.  Channels are made up of a track and an expected level of MicroK8s’  stability. Try `snap info microk8s` to see what versions are currently published.
MicroK8s 通道会随着 EKS-D 的每个版本而频繁更新。通道由轨道和 MicroK8s 的预期稳定性级别组成。尝试 `snap info microk8s` 查看当前发布的版本。

## [ Enable AWS specific addons 启用 AWS 特定的插件](https://microk8s.io/docs/eks-d#enable-aws-specific-addons)

The EKS-D channels package and include addons for the specific AWS resources that integrate with Kubernetes. These addons are;
EKS-D 通道包并包含与 Kubernetes 集成的特定 AWS 资源的插件。这些插件是;

- IAM Authenticator IAM 身份验证器
- Elastic Block Storage CSI Driver
  Elastic Block Storage CSI 驱动程序
- Elastic File System CSI Driver
  Elastic File System CSI 驱动程序

### [ Enabling IAM Authenticator 启用 IAM Authenticator](https://microk8s.io/docs/eks-d#enabling-iam-authenticator)

First we need to create an IAM role that is going to be mapped to  users/groups in the Kubernetes cluster. The role can be created using  the cli:
首先，我们需要创建一个 IAM 角色，该角色将映射到 Kubernetes 集群中的用户/组。可以使用 cli 创建角色：

```bash
# get your account ID
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')

# define a role trust policy that opens the role to users in your account (limited by IAM policy)
POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':root"},"Action":"sts:AssumeRole","Condition":{}}]}')

# create a role named KubernetesAdmin (will print the new role's ARN)
aws iam create-role \
  --role-name KubernetesAdmin \
  --description "Kubernetes administrator role (for AWS IAM Authenticator for Kubernetes)." \
  --assume-role-policy-document "$POLICY" \
  --output text \
  --query 'Role.Arn'
```

We then enable the `aws-iam-authenticator` addon, which will install required workloads and configure the api-server as necessary.
然后，我们启用 `aws-iam-authenticator` 插件，它将安装所需的工作负载并根据需要配置 api-server。

```auto
sudo microk8s enable aws-iam-authenticator
```

As an example we can map the our role to a cluster admin by replacing the `<ROLE_ARN>` with the created ARN and updating the `aws-iam-authenticator` ConfigMap with the below file:
例如，我们可以将 `<ROLE_ARN>` 替换为创建的 ARN，并使用以下文件更新 `aws-iam-authenticator` ConfigMap，从而将我们的角色映射到集群管理员：

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: kube-system
  name: aws-iam-authenticator
  labels:
    k8s-app: aws-iam-authenticator
data:
  config.yaml: |
    # a unique-per-cluster identifier to prevent replay attacks
    # (good choices are a random token or a domain name that will be unique to your cluster)
    clusterID: aws-cluster-****
    server:
      # each mapRoles entry maps an IAM role to a username and set of groups
      # Each username and group can optionally contain template parameters:
      #  1) "{{AccountID}}" is the 12 digit AWS ID.
      #  2) "{{SessionName}}" is the role session name, with `@` characters
      #     transliterated to `-` characters.
      #  3) "{{SessionNameRaw}}" is the role session name, without character
      #     transliteration (available in version >= 0.5).
      mapRoles:
      # statically map arn:aws:iam::000000000000:role/KubernetesAdmin to a cluster admin
      - roleARN: <ROLE_ARN>
        username: kubernetes-admin
        groups:
        - system:masters
      # each mapUsers entry maps an IAM role to a static username and set of groups
      mapUsers:
      # map user IAM user Alice in 000000000000 to user "alice" in "system:masters"
      #- userARN: arn:aws:iam::000000000000:user/Alice
      #  username: alice
      #  groups:
      #  - system:masters
      # List of Account IDs to whitelist for authentication
      mapAccounts:
      # - <AWS_ACCOUNT_ID>
```

We need to restart the `aws-iam-authenticator` DaemonSet after updating the ConfigMap to propagate our changes.
在更新 ConfigMap 后，我们需要重新启动 `aws-iam-authenticator` DaemonSet 以传播我们的更改。

```bash
sudo microk8s kubectl rollout restart ds aws-iam-authenticator -n kube-system
```

We need to install the `aws-iam-authenticator` binary to any machine that will use IAM authentication to manage the  Kubernetes cluster. The AWS authenticator is called by kubectl and  produces a token. This token is used to map you to a Kubernetes user.  The installation steps depend on the workstation you are on. Please  follow the steps described in the [official docs](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).
我们需要将 `aws-iam-authenticator` 二进制文件安装到将使用 IAM 身份验证来管理 Kubernetes 集群的任何计算机上。AWS 身份验证器由 kubectl 调用并生成令牌。此令牌用于将您映射到 Kubernetes 用户。安装步骤取决于您所在的工作站。请按照[官方文档](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)中描述的步骤进行作。

Afterwards we can create a kubeconfig file and use it to authenticate to our MicroK8s cluster.
之后，我们可以创建一个 kubeconfig 文件，并使用它来对我们的 MicroK8s 集群进行身份验证。

```yaml
apiVersion: v1
clusters:
- cluster:
   server: <endpoint-url>
   certificate-authority-data: <base64-encoded-ca-cert>
  name: kubernetes
contexts:
- context:
   cluster: kubernetes
   user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "<cluster-id>"
        - "-r"
        - "<role-arn>"
```

1. Replace `<endpoint-url>` with the endpoint of your cluster. If you intend to access the cluster  from outside EC2 through the node’s public endpoints (IP/DNS) please see the [respective document](https://github.com/canonical/microk8s-aws-addons/blob/main/addons/aws-iam-authenticator/access.md). Note that the MicroK8s snap configures the API server to listen on all interfaces.
   将 `<endpoint-url>` 替换为集群的终端节点。如果您打算通过节点的公有终端节点 （IP/DNS） 从 EC2 外部访问集群，请参阅[相应的文档](https://github.com/canonical/microk8s-aws-addons/blob/main/addons/aws-iam-authenticator/access.md)。请注意，MicroK8s snap 将 API 服务器配置为侦听所有接口。
2. Replace `<base64-encoded-ca-cert>` with the base64 representation of the clusters CA. Copy this from the output of microk8s config.
   将 `<base64-encoded-ca-cert>` 替换为集群 CA 的 base64 表示形式。从 microk8s 配置的输出中复制此内容。
3. Replace `<aws-iam-authenticator>` with the full path of where the `aws-iam-authenticator` binary is installed.
   将 `<aws-iam-authenticator>` 替换为 `aws-iam-authenticator` 二进制文件的安装位置的完整路径。
4. Replace `<cluster-id>` with the cluster ID shown with `sudo microk8s kubectl describe -n kube-system cm/aws-iam-authenticator | grep clusterID`
   将 `<cluster-id>` 替换为显示的 `sudo microk8s kubectl describe -n kube-system cm/aws-iam-authenticator | grep clusterID` 群集 ID

You can install `kubectl` and have it use the just created kubeconfig file with the --kubeconfig parameter.
您可以安装 `kubectl` 并让它使用刚刚创建的带有 --kubeconfig 参数的 kubeconfig 文件。

### [ Enabling EBS CSI Driver 启用 EBS CSI 驱动程序](https://microk8s.io/docs/eks-d#enabling-ebs-csi-driver)

First we need to add required permissions with a policy to an AWS user we  will use for the driver. The driver requires IAM permission to talk to  Amazon EBS to manage the volume on user’s behalf. The [example policy here](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json) defines these permissions. AWS maintains a managed policy, available at ARN `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy`.
首先，我们需要使用策略将所需的权限添加到我们将用于驱动程序的 AWS 用户。驱动程序需要 IAM 权限才能与 Amazon EBS 通信以代表用户管理卷。[此处的示例策略](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json)定义了这些权限。AWS 维护一个托管策略，可在 ARN `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy` 上使用。

We can attach the policy to the user using the AWS CLI:
我们可以使用 AWS CLI 将策略附加到用户：

```bash
aws iam attach-user-policy \
  --user-name <user-name-here> \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy
```

We can supply the credentials of the user we attached the policy to and deploy the driver with:
我们可以提供我们附加策略的用户的凭证，并使用以下命令部署驱动程序：

```auto
sudo microk8s enable aws-ebs-csi-driver -k <access-key-id> -a <secret-access-key>"
```

To test the setup afterwards you can create a PVC:
要在之后测试设置，您可以创建一个 PVC：

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 4Gi
```

And use it in a pod:
并在 Pod 中使用它：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ebs-app
spec:
  containers:
  - name: ebs-app
    image: centos
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo $(date -u) >> /data/out.txt; sleep 5; done"]
    volumeMounts:
    - name: persistent-storage
      mountPath: /data
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: ebs-claim
```

To verify everything: 要验证所有内容：

```auto
sudo microk8s kubectl exec -ti ebs-app -- tail -f /data/out.txt
```

### [ Enabling EFS CSI Driver 启用 EFS CSI 驱动程序](https://microk8s.io/docs/eks-d#enabling-efs-csi-driver)

First we need to setup proper IAM permissions. The driver requires IAM  permission to talk to Amazon EFS to manage the volume on user’s behalf.  Use an IAM instance profile to grant all the worker nodes with [required permissions](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json) by attaching policy to the instance profile of the worker.
首先，我们需要设置适当的 IAM 权限。驱动程序需要 IAM 权限才能与 Amazon EFS 通信以代表用户管理卷。使用 IAM 实例配置文件通过将策略附加到 worker 的实例配置文件来授予所有 worker 节点[所需的权限](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json)。

You can create the instance profile using the AWS CLI:
您可以使用 AWS CLI 创建实例配置文件：

```bash
POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["elasticfilesystem:DescribeAccessPoints","elasticfilesystem:DescribeFileSystems","elasticfilesystem:DescribeMountTargets","ec2:DescribeAvailabilityZones"],"Resource":"*"},{"Effect":"Allow","Action":["elasticfilesystem:CreateAccessPoint"],"Resource":"*","Condition":{"StringLike":{"aws:RequestTag/efs.csi.aws.com/cluster":"true"}}},{"Effect":"Allow","Action":"elasticfilesystem:DeleteAccessPoint","Resource":"*","Condition":{"StringEquals":{"aws:ResourceTag/efs.csi.aws.com/cluster":"true"}}}]}')
ROLE_POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}')

POLICY_ARN=$(aws iam create-policy --policy-name mk8s-ec2-policy --policy-document "$POLICY" --query "Policy.Arn" --output text)

aws iam create-role --role-name mk8s-ec2-role --assume-role-policy-document "$ROLE_POLICY" --description "Kubernetes EFS role(for EFS CSI Driver for Kubernetes)."
aws iam attach-role-policy --role-name mk8s-ec2-role --policy-arn $POLICY_ARN

aws iam create-instance-profile --instance-profile-name mk8s-ec2-iprof
aws iam add-role-to-instance-profile --instance-profile-name mk8s-ec2-iprof --role-name mk8s-ec2-role
```

Attach the created instance profile to the instance using the AWS console.
使用 AWS 控制台将创建的实例配置文件附加到实例。

Afterwards we need to create the EFS that will be used by the driver for  provisioning volumes. We need to create the filesystem in the same  availability zone that our workers are in. We can setup the EFS using  the AWS CLI:
之后，我们需要创建驱动程序将用于预置卷的 EFS。我们需要在 worker 所在的同一可用区中创建文件系统。我们可以使用 AWS CLI 设置 EFS：

```bash
INSTANCE_ID="instance-id-here"

AVAILABILITY_ZONE=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations | [0].Instances | [0].Placement.AvailabilityZone" --output text)

SUBNET_ID=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations | [0].Instances | [0].SubnetId" --output text)

SG_ID=$(aws ec2 create-security-group --group-name mk8s-efs-sg --description "MicroK8s EFS testing security group" --query "GroupId" --output text)

aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 2049 --cidr 0.0.0.0/0

EFS_ID=$(aws efs create-file-system --encrypted --creation-token mk8s-efs --tags Key=Name,Value=mk8s-efs --availability-zone-name $AVAILABILITY_ZONE --query "FileSystemId" --output text)

aws efs create-mount-target --file-system-id $EFS_ID --subnet-id $SUBNET_ID --security-group $SG_ID
```

We also need to make sure the security groups used by the worker instances have the `2049` port open for inbound tcp connections.
我们还需要确保 worker 实例使用的安全组为 `2049` 端口打开，用于入站 tcp 连接。

```auto
aws ec2 authorize-security-group-ingress --group-id <sg-id-of-instance> --protocol tcp --port 2049 --cidr 0.0.0.0/0
```

Afterwards we can supply the id of the EFs we just created and enable the addon:
之后，我们可以提供刚刚创建的 EF 的 id 并启用插件：

```auto
sudo microk8s enable aws-efs-csi-driver -i <efs-id>
```

To test the setup you can create a PVC:
要测试设置，您可以创建一个 PVC：

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: efs-claim
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: efs-sc
  resources:
    requests:
      storage: 5Gi
```

And use it in a pod:
并在 Pod 中使用它：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: efs-app
spec:
  containers:
  - name: efs-app
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo $(date -u) >> /data/out.txt; sleep 5; done"]
    volumeMounts:
    - name: persistent-storage
      mountPath: /data
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: efs-claim
```

To verify everything: 要验证所有内容：

```auto
sudo microk8s kubectl exec -ti efs-app -- tail -f /data/out.txt
```

## [ Links 链接](https://microk8s.io/docs/eks-d#links)

##### IAM authenticator IAM 身份验证器

- [Configuration Format 配置格式](https://github.com/kubernetes-sigs/aws-iam-authenticator#full-configuration-format)
- [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [How to use aws-iam-authenticator
  如何使用 aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- [AWS cli AWS 命令行界面](https://aws.amazon.com/cli/)
- [Configuring AWS credentials
  配置 AWS 凭证](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [Install AWS authenticator
  安装 AWS 身份验证器](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- [Create a EKS kubeconfig file
  创建 EKS kubeconfig 文件](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)
- [Produce a kubeconfig 生成 kubeconfig](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

##### Storage 存储

- [EBS CSI driver EBS CSI 驱动程序](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
- [EFS CSI driver EFS CSI 驱动程序](https://github.com/kubernetes-sigs/aws-efs-csi-driver)
- [EFS create resources EFS 创建资源](https://docs.aws.amazon.com/efs/latest/ug/gs-step-two-create-efs-resources.html)