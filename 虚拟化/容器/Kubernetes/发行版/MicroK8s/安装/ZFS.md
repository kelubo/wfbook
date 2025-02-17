# [                 Installing on ZFS 在 ZFS 上安装               ](https://discuss.kubernetes.io/t/installing-on-zfs/21543)                       

[General Discussions](https://discuss.kubernetes.io/c/general-discussions/6)[microk8s](https://discuss.kubernetes.io/c/general-discussions/microk8s/26)

[docs](https://discuss.kubernetes.io/tag/docs)

  

​                                                                                   

​        [           ![Nick Veitch](https://sea2.discourse-cdn.com/flex016/user_avatar/discuss.kubernetes.io/evilnick/48/3481_2.png)                                 ](https://discuss.kubernetes.io/u/evilnick)      

​        [           ![Michael Utech](https://avatars.discourse-cdn.com/v4/letter/m/e9a140/48.png)                    ](https://discuss.kubernetes.io/u/mutech)      

​        [           ![atlas](https://avatars.discourse-cdn.com/v4/letter/a/58956e/48.png)                    ](https://discuss.kubernetes.io/u/atlas7019)      

​      

​                

​          [                            Oct 2022                        ](https://discuss.kubernetes.io/t/installing-on-zfs/21543/1)        

​          [                            Oct 2023                        ](https://discuss.kubernetes.io/t/installing-on-zfs/21543/4)        

​              

​            

​                          

[![img](https://sea2.discourse-cdn.com/flex016/user_avatar/discuss.kubernetes.io/evilnick/48/3481_2.png)](https://discuss.kubernetes.io/u/evilnick)

[evilnick](https://discuss.kubernetes.io/u/evilnick)

[Feb 2023](https://discuss.kubernetes.io/t/installing-on-zfs/21543)



There is currently an issue surrounding using MicroK8s on a ZFS filesystem due
目前在 ZFS 文件系统上使用 MicroK8s 存在问题
 to the way containerd is configured. If you have installed MicroK8s on ZFS
到 containerd 的配置方式。如果您在 ZFS 上安装了 MicroK8s
 you can fix this: 你可以解决这个问题：

1. Stop microk8s: 停止 microk8s：

   ```
   
   ```

```css
microk8s stop
```

Remove the old state of containerd:
删除 containerd 的旧状态：

```


sudo rm -rf /var/snap/microk8s/common/var/lib/containerd
```

Configure containerd to use ZFS:
将 containerd 配置为使用 ZFS：
 Edit the file `/var/snap/microk8s/current/args/containerd-template.toml` 编辑文件 `/var/snap/microk8s/current/args/containerd-template.toml` 
 replacing `snapshotter = "overlayfs"` with `snapshotter = "zfs"`
将 `snapshotter = “overlayfs”` 替换为 `snapshotter = “zfs”`

Create new zfs dataset for containerd to use:
为 containerd 创建新的 zfs 数据集以供使用：

```


zfs create -o 
mountpoint=/var/snap/microk8s/common/var/lib/containerd/io.containerd.snapshotter.v1.zfs 
$POOL/containerd
```

Restart microk8s: 重新启动 microk8s：

```


```

1. ```sql
   microk8s start
   ```

 1 条回复

[Feb 2023](https://discuss.kubernetes.io/t/installing-on-zfs/21543/3)



Thanks [@mutech](https://discuss.kubernetes.io/u/mutech). I believe it comes from the zfs extension for containerd - the source is [on github](https://github.com/containerd/zfs)
谢谢[@mutech](https://discuss.kubernetes.io/u/mutech)。我相信它来自 containerd 的 zfs 扩展 - 源代码[在 github 上](https://github.com/containerd/zfs)
 Oh, i think you mean why your config includes ${SNAPSHOTTER}? I expect  it is a change in the defaults for containerd - I will look into it and  hopefully provide some more reassuring guidance. Thanks for taking the  time to comment.
哦，我想你的意思是为什么你的配置包括 ${SNAPSHOTTER}？我预计这是对 containerd 默认值的更改 - 我将对其进行研究，并希望提供更令人放心的指导。感谢您花时间发表评论。

  ![img](https://sea2.discourse-cdn.com/flex016/user_avatar/discuss.kubernetes.io/evilnick/48/3481_2.png) 邪恶的尼克：

> /var/snap/microk8s/current/args/containerd-template.toml

As [@mutech](https://discuss.kubernetes.io/u/mutech) mentioned, appreciate the concise steps to do this. It looks like this is what solved the `overlayfs: filesystem on '/var/lib/docker/check-overlayfs-support<random number>/upper' not supported as upperdir` (and similar) errors I was experiencing; which is what I was trying to get rid of.
如前所述[，@mutech](https://discuss.kubernetes.io/u/mutech)欣赏执行此作的简洁步骤。看起来这就是解决我遇到的 `overlayfs: filesystem on '/var/lib/docker/check-overlayfs-support<random number>/upper' not supported as upperdir` （和类似的）错误的方法;这就是我试图摆脱的。

Again, thank you very much! ![:pray:](https://emoji.discourse-cdn.com/google/pray.png?v=12)
再次非常感谢！ ![:pray:](https://emoji.discourse-cdn.com/google/pray.png?v=12) 

PS: did you every find out what the variable was for?
PS：你都知道这个变量是做什么用的吗？