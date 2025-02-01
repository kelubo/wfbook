# chronyd

[TOC]

chronyd - chrony daemon

## 概要

```bash
chronyd [OPTION]... [DIRECTIVE]...
```

## 描述

如果命令行上没有指定配置指令，chronyd 将从配置文件中读取它们。文件的编译默认位置是 `/etc/chrony.conf` 。

信息性消息、警告和错误将记录到 syslog 中。

## 选项

- -4

  使用此选项，主机名将仅解析为 IPv4 地址，并且仅创建 IPv4 套接字。

- -6

  使用此选项，主机名将仅解析为 IPv6 地址，并且仅创建 IPv6 套接字。

- -f file

  此选项可用于指定配置文件的备用位置。编译的默认值为 `/etc/chrony.conf` 。

- -n

  the program will not detach itself from the terminal. 在此模式下运行时，程序不会自行与终端分离。

- -d

  the program will not detach itself from the terminal, and all messages will be written to the terminal instead of syslog. If chronyd was compiled with enabled support for debugging, this option can be used twice to enable debug messages. 在此模式下运行时，程序不会自行脱离终端，并且所有消息都将写入终端而不是系统日志。如果 chronyd 是在启用调试支持的情况下编译的，则可以使用此选项两次来启用调试消息。

- -l file

  此选项允许将日志消息写入文件，而不是 syslog 或终端。

- -L level

  This option specifies the minimum severity level of messages to be written to the log file, syslog, or terminal. The following levels can be specified: -1 (debug, if compiled with enabled support for debugging), 0 (informational), 1 (warning), 2 (non-fatal error), and 3 (fatal error). The default value is 0. 此选项指定要写入日志文件、系统日志或终端的消息的最低严重性级别。可以指定以下级别：-1（调试，如果编译时启用了调试支持）、0（信息）、1（警告）、2（非致命错误）和 3（致命错误）。默认值为 0。

- -p

  在此模式下运行时，chronyd 将打印配置并退出。It will not detach from the terminal.它不会从终端上分离。此选项可用于验证配置的语法并获取整个配置，即使它被拆分为多个文件并由 include 或 confdir 指令读取。

- -q

  It will not detach from the terminal. 在此模式下运行时，chronyd 将设置一次系统时钟并退出。它不会从终端上分离。

- -Q

  This option is similar to the -q option, except it only prints the offset without making any corrections of the clock and disables server ports to allow chronyd to be started without root privileges, assuming the configuration does not have any directives which would require them (e.g. refclock, hwtimestamp, rtcfile, etc). 此选项类似于 `-q` 选项，不同之处在于它只打印偏移量而不对时钟进行任何校正，并禁用服务器端口以允许在没有 root 权限的情况下启动 chronyd，假设配置没有任何需要它们的指令（例如 refclock、hwtimestamp、rtcfile 等）。

- -r

  This option will try to reload and then delete files containing sample histories for each of the servers and reference clocks being used. The files are expected to be in the directory specified by the [dumpdir](https://chrony-project.org/doc/4.5/chrony.conf.html#dumpdir) directive in the configuration file. This option is useful if you want to stop and restart chronyd briefly for any reason, e.g. to install a new version. However, it should be used only on systems where the kernel can maintain clock compensation whilst not under chronyd's control (i.e. Linux, FreeBSD, NetBSD, illumos, and macOS 10.13 or later). 此选项将尝试重新加载，然后删除包含每个服务器的示例历史记录的文件以及正在使用的参考时钟。这些文件应位于配置文件中 dumpdir  指令指定的目录中。如果您出于任何原因（例如安装新版本）想要短暂停止并重新启动chronyd，则此选项非常有用。但是，它应该只用于内核可以在不受  chronyd 控制的情况下保持时钟补偿的系统（即 Linux、FreeBSD、NetBSD、illumos 和 macOS 10.13  或更高版本）。

- -R

  the [initstepslew](https://chrony-project.org/doc/4.5/chrony.conf.html#initstepslew) directive and the [makestep](https://chrony-project.org/doc/4.5/chrony.conf.html#makestep) directive used with a positive limit will be ignored. This option is useful when restarting chronyd and can be used in conjunction with the -r option. 使用此选项时，将忽略 initstepslew 指令和与正限制一起使用的 makestep 指令。此选项在重新启动 chronyd 时很有用，可以与 -r 选项结合使用。

- -s

  This option will set the system clock from the computer’s real-time clock (RTC) or to the last modification time of the file specified by the [driftfile](https://chrony-project.org/doc/4.5/chrony.conf.html#driftfile) directive. Real-time clocks are supported only on Linux. 此选项将设置从计算机的实时时钟 （RTC） 或 driftfile 指令指定的文件的上次修改时间开始的系统时钟。实时时钟仅在 Linux 上受支持。 If used in conjunction with the -r flag, chronyd will attempt to preserve the old samples after setting the system clock from the RTC. This can be used to allow chronyd to perform long term averaging of the gain or loss rate across system reboots, and is useful for systems with intermittent access to network that are shut down when not in use. For this to work well, it relies on chronyd having been able to determine accurate statistics for the difference between the RTC and system clock last time the computer was on. 如果与 -r 标志结合使用，chronyd 将在从 RTC  设置系统时钟后尝试保留旧样本。这可用于允许chronyd在系统重新启动时对增益或丢失率进行长期平均，并且对于间歇性访问网络且在不使用时关闭的系统很有用。为了使其正常工作，它依赖于chronyd能够确定上次计算机打开时RTC和系统时钟之间差异的准确统计信息。  If the last modification time of the drift file is later than both the current time and the RTC time, the system time will be set to it to restore the time when chronyd was previously stopped. This is useful on computers that have no RTC or the RTC is broken (e.g. it has no battery). 如果漂移文件的最后一次修改时间晚于当前时间和 RTC 时间，则系统时间将设置为它以恢复 chronyd 之前停止的时间。这在没有 RTC 或 RTC 损坏（例如没有电池）的计算机上很有用。

- -t timeout

  This option sets a timeout (in seconds) after which chronyd will exit. If the clock is not synchronised, it will exit with a non-zero status. This is useful with the -q or -Q option to shorten the maximum time waiting for measurements, or with the -r option to limit the time when chronyd is running, but still allow it to adjust the frequency of the system clock. 此选项设置超时（以秒为单位），在此之后 chronyd 将退出。如果时钟不同步，它将以非零状态退出。这对于 -q 或 -Q 选项很有用，可以缩短等待测量的最长时间，或者使用 -r 选项来限制 chronyd 运行的时间，但仍允许它调整系统时钟的频率。

- -u user

  此选项设置系统用户的名称，chronyd 在启动后将切换到该用户以删除 root 权限。它覆盖 user 指令。编译的默认值为 `root` 。chronyd needs to be compiled with support for the libcap library. On macOS, FreeBSD, NetBSD, and illumos chronyd forks into two processes. The child process retains root privileges, but can only perform a very limited range of privileged system calls on behalf of the parent. 在 Linux 上，chronyd 需要编译时支持 libcap 库。在 macOS 上，FreeBSD、NetBSD 和 illumos chronyd 分叉为两个进程。子进程保留根权限，但只能代表父进程执行非常有限的特权系统调用。

- -U

  This option disables a check for root privileges to allow chronyd to be started under a non-root user, assuming the process will have all capabilities (e.g. provided by the service manager) and access to all files, directories, and devices, needed to operate correctly in the specified configuration. Note that different capabilities might be needed with different configurations and different Linux kernel versions. Starting chronyd under a non-root user is not recommended when the configuration is not known, or at least limited to specific directives. 此选项禁用 root 权限检查，以允许在非 root 用户下启动  chronyd，假设该进程将具有在指定配置中正常运行所需的所有功能（例如由服务管理器提供）和对所有文件、目录和设备的访问权限。请注意，不同的配置和不同的 Linux 内核版本可能需要不同的功能。当配置未知或至少仅限于特定指令时，不建议在非 root 用户下启动 chronyd。

- -F level

  This option configures system call filters loaded by chronyd processes if it was compiled with support for the Linux secure computing (seccomp) facility. Three levels are defined: 0, 1, 2. The filters are disabled at level 0. At levels 1 and 2, chronyd will be killed if it makes a system call which is blocked by the filters. The level can be specified as a negative number to trigger the SIGSYS signal instead of SIGKILL, which can be useful for debugging. The default value is 0. 如果 chronyd 进程是在支持 Linux 安全计算 （seccomp）  工具的情况下编译的，则此选项将配置系统调用过滤器。定义了三个级别：0、1、2。筛选器在级别 0 时被禁用。在第 1 级和第 2 级，如果  chronyd 进行系统调用并被过滤器阻止，它将被杀死。可以将电平指定为负数来触发 SIGSYS 信号，而不是  SIGKILL，这对于调试很有用。默认值为 0。 At level 1, the filters allow only selected system calls that are normally expected to be made by chronyd. Other system calls are blocked. This level is recommended only if it is known to work on the version of the system where chrony is installed. The filters need to allow also system calls made by libraries that chronyd is using (e.g. libc), but different versions or implementations of the libraries might make different system calls. If the filters are missing a system call, chronyd could be killed even in normal operation. 在第 1 级，过滤器仅允许通常预期由 chronyd 进行的选定系统调用。其他系统调用被阻止。仅当已知该级别适用于安装了 chrony  的系统版本时，才建议使用此级别。过滤器还需要允许 chronyd 正在使用的库（例如  libc）进行系统调用，但库的不同版本或实现可能会进行不同的系统调用。如果过滤器缺少系统调用，即使在正常操作中，chronyd 也可能被终止。  At level 2, the filters block only a small number of specific system calls (e.g. fork and exec). This approach should avoid false positives, but the protection of the system against a compromised chronyd process is much more limited. 在第 2 级，过滤器仅阻止少量特定的系统调用（例如 fork 和 exec）。这种方法应该可以避免误报，但对系统进行保护，使其免受受感染的 chronyd 进程的影响要有限得多。  The filters cannot be enabled with the mailonchange directive. 无法使用 mailonchange 指令启用筛选器。

- -P priority

  On Linux, FreeBSD, NetBSD, and illumos this option will select the SCHED_FIFO real-time scheduler at the specified priority (which must be between 0 and 100). On macOS, this option must have either a value of 0 to disable the thread time constraint policy or 1 for the policy to be enabled. Other systems do not support this option. The default value is 0. 在 Linux、FreeBSD、NetBSD 和 illumos 上，此选项将以指定的优先级（必须在 0 和 100  之间）选择SCHED_FIFO实时调度程序。在 macOS 上，此选项的值必须为 0 才能禁用线程时间约束策略，或者 1 的值必须设置为 1  才能启用该策略。其他系统不支持此选项。默认值为 0。

- -m

  This option will lock chronyd into RAM so that it will never be paged out.此选项会将 chronyd 锁定到 RAM 中，这样它就永远不会被分页。此模式仅在 Linux、FreeBSD、NetBSD 和 illumos 上受支持。

- -x

  This option disables the control of the system clock. chronyd will not try to make any adjustments of the clock. It will assume the clock is free running and still track its offset and frequency relative to the estimated true time. This option allows chronyd to be started without the capability to adjust or set the system clock (e.g. in some containers) to operate as an NTP server. 此选项禁用对系统时钟的控制。Chronyd不会尝试对时钟进行任何调整。它将假设时钟是自由运行的，并且仍然跟踪其相对于估计真实时间的偏移和频率。此选项允许启动chronyd，而无需调整或设置系统时钟（例如在某些容器中）以作为NTP服务器运行。

- -v, --version

  使用此选项，chronyd 会将版本号打印到终端并退出。

- -h, --help

  使用此选项，chronyd 将向终端打印帮助消息并退出。

## 环境变量

- LISTEN_FDS

  the systemd service manager may pass file descriptors for pre-initialised sockets to chronyd. The service manager allocates and binds the file descriptors, and passes a copy to each spawned instance of the service. This allows for zero-downtime service restarts as the sockets buffer client requests until the service is able to handle them. The service manager sets the LISTEN_FDS environment variable to the number of passed file descriptors. 
  
  在 Linux 系统上，systemd 服务管理器可能会将预初始化套接字的文件描述符传递给  chronyd。服务管理器分配并绑定文件描述符，并将副本传递给服务的每个生成实例。这允许在套接字缓冲客户端请求时重新启动零停机服务，直到服务能够处理它们。服务管理器将 LISTEN_FDS 环境变量设置为传递的文件描述符的数量。