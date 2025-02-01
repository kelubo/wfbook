# Checkpointing 检查点

Checkpoints currently work with root containers only. Therefore, you have to run the example container as root. Instead of prefixing each command with `sudo`, you can also switch to the root user beforehand via `sudo -i`.
检查点目前仅适用于根容器。因此，您必须以 root 身份运行示例容器。除了在每个命令前面加上 `sudo` ，您还可以通过 `sudo -i` 预先切换到 root 用户。

```console
$ sudo podman run -dt -p 8080:80/tcp docker.io/library/httpd
$ sudo podman ps
```

## Checkpointing the container

##  对容器进行检查点

Checkpointing a container stops the container while writing the state of all processes in the container to disk. With this a container can later be restored and continue running at exactly the same point in time as the checkpoint. This capability requires [CRIU 3.11](https://www.criu.org/) or later installed on the system.
对容器执行检查点操作会停止容器，同时将容器中所有进程的状态写入磁盘。这样，容器可以稍后恢复，并在与检查点完全相同的时间点继续运行。此功能要求在系统上安装 CRIU 3.11 或更高版本。

To checkpoint the container use:
要对容器执行检查点操作，请使用：

```console
$ sudo podman container checkpoint <container_id>
```

## Restoring the container

##  还原容器

Restoring a container is only possible from a previously checkpointed container. The restored container will continue to run at exactly the same point in time it was checkpointed.
只能从先前检查点的容器中还原容器。还原的容器将继续在它被检查点的同一时间点运行。

To restore the container use:
要还原容器，请使用：

```console
$ sudo podman container restore <container_id>
```

After being restored, the container will answer requests again as it did before checkpointing.
还原后，容器将再次响应请求，就像在检查点之前一样。

```console
$ curl http://<IP_address>:8080
```

## Migrating the container

##  迁移容器

To live migrate a container from one host to another the container is checkpointed on the source system of the migration, transferred to the destination system and then restored on the destination system. When transferring the checkpoint, it is possible to specify an output-file.
要将容器从一台主机实时迁移到另一台主机，请在迁移的源系统上检查容器，然后转移到目标系统，然后在目标系统上还原。传输检查点时，可以指定输出文件。

On the source system: 在源系统上：

```console
$ sudo podman container checkpoint <container_id> -e /tmp/checkpoint.tar.gz
$ scp /tmp/checkpoint.tar.gz <destination_system>:/tmp
```

On the destination system:
在目标系统上：

```console
$ sudo podman container restore -i /tmp/checkpoint.tar.gz
```

After being restored, the container will answer requests again as it did before checkpointing. This time the container will continue to run on the destination system.
还原后，容器将再次响应请求，就像在检查点之前一样。这一次，容器将继续在目标系统上运行。

```console
$ curl http://<IP_address>:8080
```