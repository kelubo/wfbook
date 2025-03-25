# 自定义容器服务

[TOC]

## 概述

编排器允许使用 YAML 文件部署自定义容器。相应的服务规范必须如下所示：

```yaml
service_type: container
service_id: foo
placement:
    ...
spec:
  image: docker.io/library/foo:latest
  entrypoint: /usr/bin/foo
  uid: 1000
  gid: 1000
  args:
    - "--net=host"
    - "--cpus=2"
  ports:
    - 8080
    - 8443
  envs:
    - SECRET=mypassword
    - PORT=8080
    - PUID=1000
    - PGID=1000
  volume_mounts:
    CONFIG_DIR: /etc/foo
  bind_mounts:
    - ['type=bind', 'source=lib/modules', 'destination=/lib/modules', 'ro=true']
  dirs:
    - CONFIG_DIR
  files:
    CONFIG_DIR/foo.conf:
      - refresh=true
      - username=xyz
      - "port: 1234"
```

其中，服务规范的属性为：

- `service_id`

  服务的唯一名称。

- `image`

  Docker 镜像的名称。

- `uid`

  The UID to use when creating directories and files in the host system.在主机系统中创建目录和文件时要使用的 UID。

- `gid`

  The GID to use when creating directories and files in the host system.在主机系统中创建目录和文件时要使用的 GID。

- `entrypoint`

  覆盖映像的默认 ENTRYPOINT。

- `args`

  A list of additional Podman/Docker command line arguments.其他 Podman/Docker 命令行参数的列表。

- `ports`

  要在主机防火墙中打开的 TCP 端口列表。

- `envs`

  环境变量列表。

- `bind_mounts`

  When you use a bind mount, a file or directory on the host machine is mounted into the container. Relative source=… paths will be located below /var/lib/ceph/<cluster-fsid>/<daemon-name>.

  使用绑定挂载时，主机上的文件或目录将挂载到容器中。相对源=...路径将位于 /var/lib/ceph/<cluster-fsid>/<daemon-name> 下。

- `volume_mounts`

  When you use a volume mount, a new directory is created within Docker’s storage directory on the host machine, and Docker manages that directory’s contents. Relative source paths will be located below /var/lib/ceph/<cluster-fsid>/<daemon-name>.

  当您使用卷挂载时，将在 Docker 在主机上的存储目录，Docker 管理 该目录的内容。相对源路径将位于下方 /var/lib/ceph/<cluster-fsid>/<daemon-name>。

- `dirs`

  A list of directories that are created below /var/lib/ceph/<cluster-fsid>/<daemon-name>.

  在下面创建的目录列表 /var/lib/ceph/<cluster-fsid>/<daemon-name>。

- `files`

  A dictionary, where the key is the relative path of the file and the value the file content. The content must be double quoted when using a string. Use ‘\n’ for line breaks in that case. Otherwise define multi-line content as list of strings. The given files will be created below the directory /var/lib/ceph/<cluster-fsid>/<daemon-name>. The absolute path of the directory where the file will be created must exist. Use the dirs property to create them if necessary.
  
  一个字典，其中 key 是文件的相对路径，值是文件内容。使用字符串时，内容必须用双引号引起来。在这种情况下，使用 '\n' 作为换行符。否则，将多行内容定义为字符串列表。给定的文件将在目录 /var/lib/ceph/<cluster-fsid>/<daemon-name> 下创建。将创建文件的目录的绝对路径必须存在。如有必要，请使用 dirs 属性创建它们。
  
- `init_containers`

  A list of “init container” definitions. An init container exists to run prepratory steps before the primary container starts. Init containers are optional. One or more container can be defined. Each definition can contain the following fields: “init container” 定义列表。存在一个 init 容器，用于在主容器启动之前运行准备步骤。Init 容器是可选的。可以定义一个或多个容器。每个定义可以包含以下字段：

  * `image`

    If left unspecified, the init container will inherit the image value from the top level spec. 容器镜像的名称。如果未指定，init 容器将从顶级规范继承 image 值。

  * `entrypoint`

    自定义映像的默认入口点。

  * `entrypoint_args`

    Arguments that will be passed to the entrypoint. Behaves the same as the generic `extra_entrypoint_args` field. 将传递给入口点的参数。的行为与泛型 `extra_entrypoint_args` 字段相同。

  * `volume_mounts`

    Same as the Custom Container spec’s `volume_mounts` - selects what volumes will be mounted into the init container. If left unspecified, the init container will inherit the primary container’s value(s). 与 Custom Container 规范的 `volume_mounts` 相同 - 选择将挂载到 init 容器中的卷。如果未指定，则 init 容器将继承主容器的值。

  * `envs`

    环境变量列表。

  * `privileged`

    A boolean indicate if the container should run with privileges or not. If left unspecified, the init container will inherit the primary container’s value. 布尔值指示容器是否应使用权限运行。如果未指定，则 init 容器将继承主容器的值。

init 容器示例：

```yaml
service_type: container
service_id: foo
placement:
    ...
spec:
  image: quay.io/example/foosystem:latest
  entrypoint: /usr/bin/foo
  uid: 1000
  gid: 1000
  ports:
    - 8889
  dirs:
    - CONFIG_DIR
    - DATA_DIR
  volume_mounts:
    CONFIG_DIR: /etc/foo
    DATA_DIR: /var/lib/foo
  files:
    CONFIG_DIR/foo.conf:
      - db_path=/var/lib/foo/db
  init_containers:
    - image: quay.io/example/curly:howard
      entrypoint: bash
      entrypoint_args:
        - argument: "-c"
        - argument: "[ -f /var/lib/foo/db ] || curl -o /var/lib/foo/sample.dat https://foo.example.com/samples/1.dat"
      volume_mounts:
        DATA_DIR: /var/lib/foo
    - entrypoint: /usr/bin/foo-initialize-db
      entrypoint_args:
        - "--option=threads=8"
    - entrypoint: /usr/local/bin/import-sample-datasets.sh
      entrypoint_args:
        - "/var/lib/foo/sample.dat"
      envs:
        - FOO_SOURCE_MISSING=ignore
        - FOO_CLEANUP=yes
```

> Note 注意
>
> Init containers are currently implemented as a step that runs before the service is started and is subject to start-up timeouts. The total run time of all init containers can not exceed 200 seconds or the service will fail to start.
> Init 容器当前作为在服务启动之前运行的步骤实现，并且会受到启动超时的影响。所有 init 容器的总运行时间不能超过 200 秒，否则服务将无法启动。
