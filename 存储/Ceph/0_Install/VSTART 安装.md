# vstart 集群安装和配置

1. 克隆 `ceph/ceph` 存储库：

   ```bash
   git clone git@github.com:ceph/ceph
   ```

2. 更新 `ceph/ceph` 存储库中的子模块：

   ```bash
   git submodule update --init --recursive --progress
   ```

3. 运行 `install-deps.sh` ：

   ```bash
   ./install-deps.sh
   ```

4. 安装 `python3-routes` 软件包：

   ```bash
   apt install python3-routes
   ```

5. 移动到 `ceph` 目录中。如果它包含 `do_cmake.sh` 文件，您将知道您位于正确的目录中：

   ```bash
   cd ceph
   ```

6. 运行 `do_cmake.sh` 脚本：

   ```bash
   ./do_cmake.sh
   ```

7. `do_cmake.sh` 脚本会创建一个 `build/` 目录。移动到 `build/` 目录下：

   ```bash
   cd build
   ```

8. 使用 `ninja` 构建开发环境：

   ```bash
   ninja -j3
   ```

   > Note 注意
   >
   > This step takes a long time to run. The `ninja -j3` command kicks off a process consisting of 2289 steps. This step took over three hours when I ran it on an Intel NUC with an i7 in September of 2024.
   > 此步骤需要很长时间才能运行。`ninja -j3` 命令启动一个由 2289 个步骤组成的过程。当我在 2024 年 9 月在配备 i7 的 Intel NUC 上运行它时，这一步花了三个多小时。

9. 安装 Ceph 开发环境：

   ```bash
   ninja install
   ```

   此步骤花费的时间不如上一步。

10. 构建 vstart 集群：

    ```bash
    ninja vstart
    ```

11. 启动 vstart 集群：

    ```bash
    ../src/vstart.sh --debug --new -x --localhost --bluestore
    ```

    > Note 注意
    >
    > 在 `ceph/build` 目录中运行此命令。