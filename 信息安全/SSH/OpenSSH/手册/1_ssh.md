# ssh

[TOC]

## 概述

`ssh` — OpenSSH 远程登录客户端

```bash
ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address] [-c cipher_spec]   \
    [-D [bind_address:]port] [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11] \
    [-i identity_file] [-J destination] [-L address] [-l login_name] [-m mac_spec]      \ 
    [-O ctl_cmd] [-o option] [-P tag] [-p port] [-R address] [-S ctl_path]     \
    [-W host:port] [-w local_tun[:remote_tun]] destination [command [argument ...]]

ssh [-Q query_option]
```

`ssh`（SSH 客户端）是一个用于登录远程计算机和在远程计算机上执行命令的程序。它旨在通过不安全的网络在两个不受信任的主机之间提供安全的加密通信。X11 连接、任意 TCP 端口和 UNIX 域套接字也可以通过安全通道转发。

`ssh` 连接并登录到指定的目标，该目标可以指定为 `[user@]hostname` 或形式为 `ssh://[user@]hostname[:port]` 的  URI 。用户必须使用以下几种方法之一向远程计算机证明其身份（见下文）。

如果指定了命令，它将在远程主机上执行，it will be    executed on the remote host instead of a login shell. 而不是在登录shell上执行。A complete command    line may be specified as command, or it may have    additional arguments. If supplied, the arguments will be appended to the    command, separated by spaces, before it is sent to the server to be    executed.完整的命令行可以指定为命令，也可以具有其他参数。如果提供了参数，则在将命令发送到要执行的服务器之前，参数将附加到命令中，并用空格分隔。

选项如下：

- `-4`

  强制 `ssh` 仅使用 IPv4 地址。

- `-6`

  强制 `ssh` 仅使用 IPv6 地址。

- `-A`

  允许转发来自身份验证代理（如 ssh-agent ）的连接。This can also be specified on a per-host basis in a configuration file.    这也可以在配置文件中按主机指定。应谨慎启用代理转发。Users with        the ability to bypass file permissions on the remote host (for the        agent's UNIX-domain socket) can access the local        agent through the forwarded connection. 能够绕过远程主机上的文件权限（对于代理的UNIX域套接字）的用户可以通过转发连接访问本地代理。An attacker cannot obtain key        material from the agent, however they can perform operations on the keys        that enable them to authenticate using the identities loaded into the        agent. 攻击者无法从代理获取密钥材料，但他们可以对密钥执行操作，使其能够使用加载到代理中的身份进行身份验证。更安全的选择可能是使用跳转主机（参见 `-J` ）。

  Users with        the ability to bypass file permissions on the remote host (for the        agent's UNIX-domain socket) can access the local        agent through the forwarded connection. An attacker cannot obtain key        material from the agent, however they can perform operations on the keys        that enable them to authenticate using the identities loaded into the        agent. A safer alternative may be to use a jump host (see        `-J`). 应谨慎启用代理转发。能够绕过远程主机上的文件权限（对于代理的 UNIX 域套接字）的用户可以访问本地 agent 的代理。攻击者无法获取密钥 材料，但是他们可以对 keys 执行作 ，使他们能够使用加载到 代理。

- `-a`

    Disables forwarding of the authentication agent connection. 禁用身份验证代理连接的转发。

- `-B`    bind_interface

    Bind to the address of bind_interface before      attempting to connect to the destination host. 在尝试连接到目标主机之前，绑定到绑定接口的地址。这仅适用于具有多个地址的系统。

    绑定到 bind_interface 之前的地址 尝试连接到目标主机

- `-b`    bind_address

    Use bind_address on the local machine as the source      address of the connection. 使用本地计算机上的绑定地址作为连接的源地址。仅适用于具有多个地址的系统。

    使用本地计算机上的 bind_address 作为源 连接的地址。

- `-C`

    Requests compression of all data (including stdin, stdout, stderr, and      data for forwarded X11, TCP and UNIX-domain      connections). 请求压缩所有数据（包括stdin、stdout、stderr和转发X11、TCP和UNIX域连接的数据）。压缩算法与 gzip 使用的压缩算法相同。压缩在调制解调器线路和其他慢速连接上是可取的，但只会减慢快速网络上的速度。The default value can be set      on a host-by-host basis in the configuration files; 默认值可以在配置文件中逐个主机设置；请参阅 ssh-config（5）中的 `Compression` 选项。

    Requests compression of all data (including stdin, stdout, stderr, and      data for forwarded X11, TCP and UNIX-domain      connections). The compression algorithm is the same used by      [gzip(1)](https://man.openbsd.org/gzip.1).      Compression is desirable on modem lines and other slow connections, but      will only slow down things on fast networks. The default value can be set      on a host-by-host basis in the configuration files; see the      `Compression` option in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5).     请求压缩所有数据（包括 stdin、stdout、stderr 以及转发的 X11、TCP 和 UNIX 域的数据 connections） 的 Connections）。压缩算法与 [gzip（1）](https://man.openbsd.org/gzip.1) 的 在调制解调器线路和其他慢速连接上需要压缩，但 只会减慢快速网络上的速度。可以设置默认值 在配置文件中逐个主机进行分配;请参阅 `压缩`选项 [ssh_config（5）](https://man.openbsd.org/ssh_config.5).  

- `-c`   cipher_spec

    选择加密会话的密码规范。cipher_spec is a comma-separated list of ciphers      listed in order of preference. 密码规范是按优先顺序列出的密码的逗号分隔列表。有关更多信息，请参阅  ssh-config（5）中的 `Ciphers` 关键字。

    Selects the cipher specification for encrypting the session.      cipher_spec is a comma-separated list of ciphers      listed in order of preference. See the `Ciphers`      keyword in [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.     选择用于加密会话的密码规范。 cipher_spec 是按优先顺序列出的密码的逗号分隔列表。查看`密码` 关键字 [ssh_config](https://man.openbsd.org/ssh_config.5) 以获取更多信息。  

- `-D`    [bind_address:]port

    Specifies a local “dynamic” application-level port      forwarding.指定本地“动态”应用程序级端口转发。 This works by allocating a socket to listen to      port on the local side, optionally bound to the      specified bind_address. 这是通过分配一个套接字来侦听本地端的端口（可选地绑定到指定的绑定地址）来实现的。Whenever a connection is      made to this port, the connection is forwarded over the secure channel,      and the application protocol is then used to determine where to connect to      from the remote machine. 每当连接到此端口时，该连接都会通过安全通道转发，然后使用应用程序协议确定从远程计算机连接到何处。目前支持 SOCKS4 和 SOCKS5 协议，`ssh` 将充当 SOCKS 服务器。只有 root 用户才能转发特权端口。还可以在配置文件中指定动态端口转发。 IPv6 addresses can be specified by enclosing the address in        square brackets. 只有超级用户才能转发特权端口。By        default, the local port is bound in accordance with the        `GatewayPorts` setting. However, an explicit        bind_address may be used to bind the connection to        a specific address. The bind_address of        “localhost” indicates that the listening port be bound for        local use only, while an empty address or ‘*’ indicates        that the port should be available from all interfaces.   

    IPv6地址可以通过将地址括在方括号中来指定。默认情况下，根据网关端口设置绑定本地端口。然而，可以使用显式绑定地址将连接绑定到特定地址。绑定地址“localhost”表示侦听端口仅为本地使用而绑定，而空地址或“*”表示该端口应可从所有接口使用。  

    Specifies a local “dynamic” application-level port      forwarding. This works by allocating a socket to listen to      port on the local side, optionally bound to the      specified bind_address. Whenever a connection is      made to this port, the connection is forwarded over the secure channel,      and the application protocol is then used to determine where to connect to      from the remote machine. Currently the SOCKS4 and SOCKS5 protocols are      supported, and `ssh` will act as a SOCKS server.      Only root can forward privileged ports. Dynamic port forwardings can also      be specified in the configuration file.     指定本地 “动态” 应用程序级端口 转发。这是通过分配一个套接字来监听 port 的 port 中，可以选择绑定到 指定 bind_address。每当连接为 连接到此端口，则连接将通过安全通道转发， 然后使用应用程序协议来确定连接到的位置 从远程计算机。目前，SOCKS4 和 SOCKS5 协议是 `supported，ssh` 将充当 SOCKS 服务器。 只有 root 可以转发特权端口。动态端口转发还可以 在配置文件中指定。IPv6 addresses can be specified by enclosing the address in        square brackets. Only the superuser can forward privileged ports. By        default, the local port is bound in accordance with the        `GatewayPorts` setting. However, an explicit        bind_address may be used to bind the connection to        a specific address. The bind_address of        “localhost” indicates that the listening port be bound for        local use only, while an empty address or ‘*’ indicates        that the port should be available from all interfaces. IPv6 地址可以通过将地址括在 方括号。只有超级用户才能转发特权端口。由 default，则本地端口会按照 `GatewayPorts` 设置。但是，显式的 bind_address 可用于将连接绑定到特定地址。bind_address “localhost” 表示侦听端口仅供本地使用，而空地址或 '*' 表示该端口应可从所有接口访问。

- `-E`    log_file

  将调试日志附加到日志文件而不是标准错误。

- `-e`   escape_char

  Sets the escape character for sessions with a pty (default:      ‘`~`’). The escape character is only      recognized at the beginning of a line. The escape character followed by a      dot (‘`.`’) closes the connection;      followed by control-Z suspends the connection; and followed by itself      sends the escape character once. Setting the character to      “none” disables any escapes and makes the session fully      transparent.      

  为带有pty的会话设置转义符（默认值：“~”）。转义字符只能在行的开头识别。转义字符后跟点（'.'）关闭连接；随后control-Z暂停连接；然后它自己发送一次转义字符。将字符设置为“none”将禁用任何转义，并使会话完全透明。

  设置带有 pty 的会话的转义字符（默认值：'`~`'）。转义字符仅在行首被识别。转义字符后跟一个点 （'`.`'） 关闭连接; 后跟 control-Z 暂停连接;和 后跟 发送一次转义字符。将字符设置为 “none” 禁用任何转义并使 Session 完全 透明。  

- `-F`    configfile

  Specifies an alternative per-user configuration file. 指定每个用户的备用配置文件。如果在命令行上提供了配置文件，则系统范围的配置文件（/etc/ssh/ssh-config）将被忽略。每个用户配置文件的默认值为 `~/.ssh/config` 。如果设置为 “none” ，则不会读取任何配置文件。

  Specifies an alternative per-user configuration file. If a configuration      file is given on the command line, the system-wide configuration file      (/etc/ssh/ssh_config) will be ignored. The default      for the per-user configuration file is      ~/.ssh/config. If set to “none”, no      configuration files will be read.     指定备用的每用户配置文件。如果在命令行上提供了配置文件，则系统范围的配置文件 （/etc/ssh/ssh_config） 将被忽略。默认的 对于每用户配置文件为 ~/.ssh/config 中。如果设置为 “none”，则为 no 配置文件。  

- 

- [`-f`](https://man.openbsd.org/ssh#f)

  Requests `ssh` to go to background just before      command execution. This is useful if `ssh` is going      to ask for passwords or passphrases, but the user wants it in the      background. This implies `-n`. The recommended way      to start X11 programs at a remote site is with something like      `ssh -f host xterm`.     请求 `ssh` 在刚开始之前进入后台 命令执行。如果 `ssh` 要去 来请求密码或密码，但用户希望在 背景。这意味着 `-n`。推荐方法 在远程站点启动 X11 程序是这样的 `ssh -f 主机 xterm`。If the `ExitOnForwardFailure`        configuration option is set to “yes”, then a client        started with `-f` will wait for all remote port        forwards to be successfully established before placing itself in the        background. Refer to the description of        `ForkAfterAuthentication` in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details. 如果 `ExitOnForwardFailure` configuration 选项设置为 “Yes”，则客户端 以 `-f` 开头将等待所有远程端口 forwards 成功建立，然后再将自身放入 背景。请参阅 `ForkAfterAuthentication` 中的 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。      

- [`-G`](https://man.openbsd.org/ssh#G)

  Causes `ssh` to print its configuration after      evaluating `Host` and `Match`      blocks and exit.     使 `ssh` 在评估 `Host` 和 `Match` 后打印其配置 阻止并退出。  

- [`-g` `-克`](https://man.openbsd.org/ssh#g)

  Allows remote hosts to connect to local forwarded ports. If used on a      multiplexed connection, then this option must be specified on the master      process.     允许远程主机连接到本地转发端口。如果在 multiplexed connection 的 Multiplexed 连接，则必须在 master 上指定此选项 过程。  

- [`-I`](https://man.openbsd.org/ssh#I)    pkcs11 [`-我 `](https://man.openbsd.org/ssh#I)pkcs11

  Specify the PKCS#11 shared library `ssh` should use      to communicate with a PKCS#11 token providing keys for user      authentication.     指定 `ssh` 应使用的 PKCS#11 共享库 与为用户提供密钥的 PKCS#11 令牌通信 认证。  

- [`-i`](https://man.openbsd.org/ssh#i)    identity_file [`-我 `](https://man.openbsd.org/ssh#i)identity_file

  Selects a file from which the identity (private key) for public key      authentication is read. You can also specify a public key file to use the      corresponding private key that is loaded in      [ssh-agent(1)](https://man.openbsd.org/ssh-agent.1) when the private key file is not present locally. The      default is ~/.ssh/id_rsa,      ~/.ssh/id_ecdsa,      ~/.ssh/id_ecdsa_sk,      ~/.ssh/id_ed25519 and      ~/.ssh/id_ed25519_sk. Identity files may also be      specified on a per-host basis in the configuration file. It is possible to      have multiple `-i` options (and multiple identities      specified in configuration files). If no certificates have been explicitly      specified by the `CertificateFile` directive,      `ssh` will also try to load certificate information      from the filename obtained by appending -cert.pub      to identity filenames.     选择公钥的身份（私钥）从中获取的文件 authentication is 读取。您还可以指定一个公有密钥文件以使用 加载在 [ssh-agent（1）](https://man.openbsd.org/ssh-agent.1) 来获取。默认值为 ~/.ssh/id_rsa， ~/.ssh/id_ecdsa 中， ~/.ssh/id_ecdsa_sk 中， ~/.ssh/id_ed25519 和 ~/.ssh/id_ed25519_sk 的身份文件也可以在配置文件中按主机指定。可以有多个 `-i` 选项（并在配置文件中指定多个身份）。如果 `CertificateFile` 指令未显式指定任何证书，则 `SSH` 还将尝试从通过附加 -cert.pub 获取的文件名加载证书信息 标识文件名。  

- [`-J`](https://man.openbsd.org/ssh#J)    destination [`-J`](https://man.openbsd.org/ssh#J) 目标

  Connect to the target host by first making an `ssh`      connection to the jump host described by destination      and then establishing a TCP forwarding to the ultimate destination from      there. Multiple jump hops may be specified separated by comma characters.      IPv6 addresses can be specified by enclosing the address in square      brackets. This is a shortcut to specify a      `ProxyJump` configuration directive. Note that      configuration directives supplied on the command-line generally apply to      the destination host and not any specified jump hosts. Use      ~/.ssh/config to specify configuration for jump      hosts.     首先通过 `ssh` 连接到目标主机 连接到 destination 描述的 jump host 然后建立到最终目的地的 TCP 转发 那里。可以指定多个跳转跃点，以逗号字符分隔。 可以通过将地址括在正方形中来指定 IPv6 地址 括弧。这是指定 `ProxyJump` 配置指令。请注意， 命令行上提供的配置指令通常适用于 目标主机，而不是任何指定的跳转主机。用 ~/.ssh/config 指定跳转的配置 主机。  

- [`-K`](https://man.openbsd.org/ssh#K)

  Enables GSSAPI-based authentication and forwarding (delegation) of GSSAPI      credentials to the server.     启用基于 GSSAPI 的身份验证和转发（委派） 凭据添加到服务器。  

- [`-k`](https://man.openbsd.org/ssh#k)

  Disables forwarding (delegation) of GSSAPI credentials to the server.     禁用将 GSSAPI 凭证转发（委派）到服务器。  

- [`-L`](https://man.openbsd.org/ssh#L)    [bind_address:]port:host:hostport [`-L`](https://man.openbsd.org/ssh#L) [bind_address：]port：host：hostport

     

- [`-L`](https://man.openbsd.org/ssh#L~2)    [bind_address:]port:remote_socket [`-L`](https://man.openbsd.org/ssh#L~2) [bind_address：] 端口 ：remote_socket

     

- [`-L`](https://man.openbsd.org/ssh#L~3)    local_socket:host:hostport [`-L`](https://man.openbsd.org/ssh#L~3)local_socket：host：hostport

     

- [`-L`](https://man.openbsd.org/ssh#L~4)    local_socket:remote_socket [`-L`](https://man.openbsd.org/ssh#L~4)local_socket：remote_socket

  Specifies that connections to the given TCP port or Unix socket on the      local (client) host are to be forwarded to the given host and port, or      Unix socket, on the remote side. This works by allocating a socket to      listen to either a TCP port on the local side,      optionally bound to the specified bind_address, or      to a Unix socket. Whenever a connection is made to the local port or      socket, the connection is forwarded over the secure channel, and a      connection is made to either host port      hostport, or the Unix socket      remote_socket, from the remote machine.     指定连接到给定的 TCP 端口或 Unix 套接字的 本地（客户端）主机将转发到给定的主机和端口，或者 Unix 套接字，位于远程端。这是通过将套接字分配给 监听本地端的 TCP  端口 ， （可选）绑定到指定的 bind_address，或者 添加到 Unix 套接字。每当连接到本地端口或 socket，则连接通过安全通道转发，并且 连接到任一主机端口 hostport 或 Unix 套接字 remote_socket，从远程计算机。Port forwardings can also be specified in the configuration        file. Only the superuser can forward privileged ports. IPv6 addresses        can be specified by enclosing the address in square brackets. 也可以在配置文件中指定端口转发。只有超级用户才能转发特权端口。可以通过将地址括在方括号中来指定 IPv6 地址。    By default, the local port is bound in accordance with the        `GatewayPorts` setting. However, an explicit        bind_address may be used to bind the connection to        a specific address. The bind_address of        “localhost” indicates that the listening port be bound for        local use only, while an empty address or ‘*’ indicates        that the port should be available from all interfaces. 默认情况下，本地端口按照 `GatewayPorts` 设置。但是，显式的 bind_address 可用于将连接绑定到特定地址。bind_address “localhost” 表示侦听端口仅供本地使用，而空地址或 '*' 表示该端口应可从所有接口访问。      

- [`-l`](https://man.openbsd.org/ssh#l)    login_name

  Specifies the user to log in as on the remote machine. This also may be      specified on a per-host basis in the configuration file.     指定要在远程计算机上登录的用户。这也可能是 在配置文件中按主机指定。  

- [`-M` `-米`](https://man.openbsd.org/ssh#M)

  Places the `ssh` client into “master”      mode for connection sharing. Multiple `-M` options      places `ssh` into “master” mode but      with confirmation required using      [ssh-askpass(1)](https://man.openbsd.org/ssh-askpass.1) before each operation that changes the multiplexing      state (e.g. opening a new session). Refer to the description of      `ControlMaster` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     将 `ssh` 客户端置于 “master” 模式以进行连接共享。多个 `-M` 选项将 `ssh` 置于 “master” 模式，但 需要确认 [ssh-askpass（1）](https://man.openbsd.org/ssh-askpass.1) 在每次更改多路复用的作之前 state（例如，打开一个新会话）。请参阅 `ControlMaster` 在 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。  

- [`-m`](https://man.openbsd.org/ssh#m)    mac_spec

  A comma-separated list of MAC (message authentication code) algorithms,      specified in order of preference. See the `MACs`      keyword in [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.     以逗号分隔的 MAC（消息身份验证代码）算法列表，按优先顺序指定。查看 `MAC` 关键字在 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 中。  

- [`-N`](https://man.openbsd.org/ssh#N)

  Do not execute a remote command. This is useful for just forwarding ports.      Refer to the description of `SessionType` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     不要执行远程命令。这对于仅转发端口很有用。请参考 ` 中的 SessionType` 的描述 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。  

- [`-n`](https://man.openbsd.org/ssh#n)

  Redirects stdin from /dev/null (actually, prevents      reading from stdin). This must be used when `ssh` is      run in the background. A common trick is to use this to run X11 programs      on a remote machine. For example, `ssh -n      shadows.cs.hut.fi emacs &` will start an emacs on      shadows.cs.hut.fi, and the X11 connection will be automatically forwarded      over an encrypted channel. The `ssh` program will be      put in the background. (This does not work if `ssh`      needs to ask for a password or passphrase; see also the      `-f` option.) Refer to the description of      `StdinNull` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     从 /dev/null 重定向 stdin（实际上，阻止从 stdin 读取）。当 `ssh` 在后台运行时，必须使用此选项。一个常见的技巧是使用它来在远程机器上运行 X11 程序。例如， `ssh -n      shadows.cs.hut.fi emacs &` 将在 shadows.cs.hut.fi 上启动一个 emacs，并且 X11 连接将通过加密通道自动转发。`ssh` 程序将置于后台。（如果 `ssh` 需要询问密码或密码;另请参阅 `-f` 选项。请参阅 `StdinNull` 在 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。  

- [`-O`](https://man.openbsd.org/ssh#O)    ctl_cmd

  Control an active connection multiplexing master process. When the      `-O` option is specified, the      ctl_cmd argument is interpreted and passed to the      master process. Valid commands are: “check” (check that the      master process is running), “forward” (request forwardings      without command execution), “cancel” (cancel forwardings),      “proxy” (connect to a running multiplexing master in proxy      mode), “exit” (request the master to exit), and      “stop” (request the master to stop accepting further      multiplexing requests).     控制活动连接多路复用主进程。当 `-O` 选项，则 ctl_cmd 参数被解释并传递给 master 进程。有效命令为：“check”（检查是否有 主进程正在运行）、“forward”（请求转发 没有命令执行）、“cancel”（取消转发）、 “proxy” （连接到 proxy 中正在运行的多路复用主机 mode）、“exit”（请求 Master 退出）和 “stop” （请求 Master 停止进一步接受 多路复用请求）。  

- [`-o`](https://man.openbsd.org/ssh#o)    option [`-o`](https://man.openbsd.org/ssh#o) 选项

  Can be used to give options in the format used in the configuration file.      This is useful for specifying options for which there is no separate      command-line flag. For full details of the options listed below, and their      possible values, see      [ssh_config(5)](https://man.openbsd.org/ssh_config.5).     可用于以配置文件中使用的格式提供选项。 这对于指定没有单独 command-line 标志。有关下面列出的选项及其 可能的值，请参阅 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5)              AddKeysToAgent             AddressFamily 地址 Family             BatchMode             BindAddress BindAddress （绑定地址）             BindInterface BindInterface 接口             CASignatureAlgorithms CASignature 算法             CanonicalDomains             CanonicalizeFallbackLocal             CanonicalizeHostname CanonicalizeHostname 的             CanonicalizeMaxDots 规范化 MaxDots             CanonicalizePermittedCNAMEs CanonicalizePermittedCNAME             CertificateFile 证书文件             ChannelTimeout ChannelTimeout （通道超时）             CheckHostIP 检查主机 IP             Ciphers 密码             ClearAllForwardings ClearAllForwardings （清除所有转发）             Compression 压缩             ConnectTimeout ConnectTimeout 连接超时             ConnectionAttempts             ControlMaster 控制大师             ControlPath 控制路径             ControlPersist             DynamicForward 动态转发             EnableEscapeCommandline EnableEscape 命令行             EnableSSHKeysign 启用 SSHKeysign             EscapeChar EscapeChar 函数             ExitOnForwardFailure             FingerprintHash 指纹哈希             ForkAfterAuthentication             ForwardAgent 转发代理             ForwardX11 前进 X11             ForwardX11Timeout 转发 X11 超时             ForwardX11Trusted ForwardX11 受信任             GSSAPIAuthentication             GSSAPIDelegateCredentials             GatewayPorts 网关端口             GlobalKnownHostsFile GlobalKnownHostsFile 文件             HashKnownHosts 哈希已知主机             Host 主机             HostKeyAlgorithms HostKey 算法             HostKeyAlias HostKey 别名             HostbasedAcceptedAlgorithms             HostbasedAuthentication Hostbased 身份验证             Hostname 主机名             IPQoS             IdentitiesOnly 仅身份             IdentityAgent 身份代理             IdentityFile             IgnoreUnknown 忽略未知             Include 包括             KbdInteractiveAuthentication KbdInteractive 身份验证             KbdInteractiveDevices Kbd 交互设备             KexAlgorithms 凯克斯算法             KnownHostsCommand             LocalCommand LocalCommand （本地命令）             LocalForward 本地转发             LogLevel 对数级别             LogVerbose             MACs MAC             NoHostAuthenticationForLocalhost             NumberOfPasswordPrompts             ObscureKeystrokeTiming             PKCS11Provider PKCS11 提供程序             PasswordAuthentication 密码身份验证             PermitLocalCommand PermitLocal 命令             PermitRemoteOpen PermitRemoteOpen 许可证             Port 港口             PreferredAuthentications 首选身份验证             ProxyCommand 代理命令             ProxyJump 代理跳             ProxyUseFdpass ProxyUseFd 传递             PubkeyAcceptedAlgorithms PubkeyAccepted 算法             PubkeyAuthentication 公钥身份验证             RekeyLimit RekeyLimit 协议             RemoteCommand 远程命令             RemoteForward 远程转发             RequestTTY 请求 TTY             RequiredRSASize 必需的 RSASize             RevokedHostKeys 已撤销主机密钥             SecurityKeyProvider             SendEnv             ServerAliveCountMax ServerAliveCountMax 服务器存活计数 Max             ServerAliveInterval ServerAliveInterval 服务器存活间隔             SessionType 会话类型             SetEnv SetEnv （设置环境）             StdinNull             StreamLocalBindMask StreamLocalBindMask （流本地绑定掩码）             StreamLocalBindUnlink             StrictHostKeyChecking             SyslogFacility SyslogFacility （系统日志工具）             TCPKeepAlive             Tag 日             Tunnel 隧道             TunnelDevice 隧道设备             UpdateHostKeys             User 用户             UserKnownHostsFile             VerifyHostKeyDNS 验证 HostKeyDNS             VisualHostKey             XAuthLocation                     

- [`-P`](https://man.openbsd.org/ssh#P)    tag [`-P`](https://man.openbsd.org/ssh#P) 标签

  Specify a tag name that may be used to select configuration in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5). Refer to the `Tag` and      `Match` keywords in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information. 指定可用于在 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5) 请参阅 `Tag` 和 `匹配`关键字 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解更多信息。

- [`-p`](https://man.openbsd.org/ssh#p)    port [`-p`](https://man.openbsd.org/ssh#p) 端口

  Port to connect to on the remote host. This can be specified on a per-host      basis in the configuration file.     要在远程主机上连接到的端口。这可以在每个主机上指定 basis 的 intent 文件。  

- [`-Q`](https://man.openbsd.org/ssh#Q)    query_option

  Queries for the algorithms supported by one of the following features:      cipher (supported symmetric ciphers),      cipher-auth (supported symmetric ciphers that      support authenticated encryption), help (supported      query terms for use with the `-Q` flag),      mac (supported message integrity codes),      kex (key exchange algorithms),      key (key types), key-ca-sign      (valid CA signature algorithms for certificates),      key-cert (certificate key types),      key-plain (non-certificate key types),      key-sig (all key types and signature algorithms),      protocol-version (supported SSH protocol versions),      and sig (supported signature algorithms).      Alternatively, any keyword from      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) or      [sshd_config(5)](https://man.openbsd.org/sshd_config.5) that takes an algorithm list may be used as an alias      for the corresponding query_option.     查询以下功能之一支持的算法： cipher （支持的对称密码）， cipher-auth （支持经过身份验证的加密的对称密码）， help （支持与 `-Q` 标志一起使用的查询词）， Mac（支持的消息完整性代码）、 kex（密钥交换算法）， key（密钥类型）、key-ca-sign （证书的有效 CA 签名算法）、 key-cert （证书密钥类型）， key-plain（非证书密钥类型）、 key-sig（所有密钥类型和签名算法）， protocol-version（支持的 SSH 协议版本）和 sig（支持的签名算法）。 或者，来自 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 或 [sshd_config（5）](https://man.openbsd.org/sshd_config.5) 可以用作别名 以获取相应的 query_option。  

- [`-q`](https://man.openbsd.org/ssh#q)

  Quiet mode. Causes most warning and diagnostic messages to be suppressed.     安静模式。导致禁止显示大多数警告和诊断消息。  

- [`-R`](https://man.openbsd.org/ssh#R)    [bind_address:]port:host:hostport [`-R`](https://man.openbsd.org/ssh#R) [bind_address：]port：host：hostport

     

- [`-R`](https://man.openbsd.org/ssh#R~2)    [bind_address:]port:local_socket [`-R`](https://man.openbsd.org/ssh#R~2) [bind_address：] 端口 ：local_socket

     

- [`-R`](https://man.openbsd.org/ssh#R~3)    remote_socket:host:hostport [`-R`](https://man.openbsd.org/ssh#R~3)remote_socket： 主机 ：主机端口

     

- [`-R`](https://man.openbsd.org/ssh#R~4)    remote_socket:local_socket [`-R`](https://man.openbsd.org/ssh#R~4)remote_socket：local_socket

     

- [`-R`](https://man.openbsd.org/ssh#R~5)    [bind_address:]port [`-R`](https://man.openbsd.org/ssh#R~5) [bind_address：] 港口

  Specifies that connections to the given TCP port or Unix socket on the      remote (server) host are to be forwarded to the local side.     指定连接到给定的 TCP 端口或 Unix 套接字的 远程 （服务器） 主机将转发到本地端。This works by allocating a socket to listen to either a TCP        port or to a Unix socket on the remote side.        Whenever a connection is made to this port or Unix socket, the        connection is forwarded over the secure channel, and a connection is        made from the local machine to either an explicit destination specified        by host port hostport, or        local_socket, or, if no explicit destination was        specified, `ssh` will act as a SOCKS 4/5 proxy and        forward connections to the destinations requested by the remote SOCKS        client. 这是通过分配一个套接字来侦听 TCP 来实现的 端口或远程端的 Unix 套接字。每当连接到此端口或 Unix 套接字时，都会通过安全通道转发连接，并且从本地计算机连接到主机端口 hostport 指定的显式目标，或者 local_socket，或者，如果未指定明确的目的地，`ssh` 将充当 SOCKS 4/5 代理，并将连接转发到远程 SOCKS 客户端请求的目的地。    Port forwardings can also be specified in the configuration        file. Privileged ports can be forwarded only when logging in as root on        the remote machine. IPv6 addresses can be specified by enclosing the        address in square brackets. 也可以在配置文件中指定端口转发。只有在远程计算机上以 root 用户身份登录时，才能转发特权端口。可以通过将地址括在方括号中来指定 IPv6 地址。    By default, TCP listening sockets on the server will be bound        to the loopback interface only. This may be overridden by specifying a        bind_address. An empty        bind_address, or the address        ‘`*`’, indicates that the remote        socket should listen on all interfaces. Specifying a remote        bind_address will only succeed if the server's        `GatewayPorts` option is enabled (see        [sshd_config(5)](https://man.openbsd.org/sshd_config.5)). 默认情况下，服务器上的 TCP 侦听套接字将被绑定 仅连接到环路接口。这可以通过指定 bind_address。空的 bind_address 或地址 '`*`' 表示远程 socket 应该监听所有接口。指定远程 bind_address 只有当服务器的 `GatewayPorts` 选项（请参阅 [sshd_config（5）](https://man.openbsd.org/sshd_config.5)）。    If the port argument is        ‘`0`’, the listen port will be        dynamically allocated on the server and reported to the client at run        time. When used together with `-O forward`, the        allocated port will be printed to the standard output. 如果 port 参数为 '`0`'，则侦听端口将在服务器上动态分配，并在运行时报告给客户端。当与 `-O forward` 一起使用时，分配的端口将被打印到标准输出。      

- [`-S`](https://man.openbsd.org/ssh#S)    ctl_path

  Specifies the location of a control socket for connection sharing, or the      string “none” to disable connection sharing. Refer to the      description of `ControlPath` and      `ControlMaster` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     指定用于连接共享的控制套接字的位置，或指定字符串 “none” 以禁用连接共享。请参阅 `ControlPath` 和 `ControlMaster` 在 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。  

- [`-s`](https://man.openbsd.org/ssh#s)

  May be used to request invocation of a subsystem on the remote system.      Subsystems facilitate the use of SSH as a secure transport for other      applications (e.g. [sftp(1)](https://man.openbsd.org/sftp.1)). The subsystem is specified as the remote command. Refer      to the description of `SessionType` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     可用于请求调用远程系统上的子系统。子系统有助于将 SSH 用作其他应用程序（例如 [sftp（1）](https://man.openbsd.org/sftp.1)）的安全传输。子系统指定为 remote 命令。请参考 ` 中的 SessionType` 的描述 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解详情。  

- [`-T` `-吨`](https://man.openbsd.org/ssh#T)

  Disable pseudo-terminal allocation.     禁用伪终端分配。  

- [`-t` `-吨`](https://man.openbsd.org/ssh#t)

  Force pseudo-terminal allocation. This can be used to execute arbitrary      screen-based programs on a remote machine, which can be very useful, e.g.      when implementing menu services. Multiple `-t`      options force tty allocation, even if `ssh` has no      local tty.     强制伪终端分配。这可用于在远程机器上执行任意基于屏幕的程序，这可能非常有用，例如在实现菜单服务时。多个 `-t` 选项 force tty 分配，即使 `SSH` 没有 本地 tty.  

- [`-V`](https://man.openbsd.org/ssh#V)

  Display the version number and exit.     显示版本号并退出。  

- [`-v`](https://man.openbsd.org/ssh#v)

  Verbose mode. Causes `ssh` to print debugging      messages about its progress. This is helpful in debugging connection,      authentication, and configuration problems. Multiple      `-v` options increase the verbosity. The maximum is      3.     详细模式。使 `ssh` 打印调试 有关其进度的消息。这有助于调试连接， 身份验证和配置问题。倍数 `-v` 选项会增加详细程度。最大值为      3.  

- [`-W`](https://man.openbsd.org/ssh#W)    host:port [`-W`](https://man.openbsd.org/ssh#W) 主机 ： 端口

  Requests that standard input and output on the client be forwarded to      host on port over the secure      channel. Implies `-N`, `-T`,      `ExitOnForwardFailure` and      `ClearAllForwardings`, though these can be      overridden in the configuration file or using `-o`      command line options.     请求将客户端上的标准输入和输出转发到 Host on  端口 。隐含 `-n`、 `-t`、 `ExitOnForwardFailure` 和 `ClearAllForwardings`，但可以在配置文件中或使用 `-o` 覆盖这些 命令行选项。  

- [`-w`](https://man.openbsd.org/ssh#w)    local_tun[:remote_tun] [`-w`](https://man.openbsd.org/ssh#w)local_tun[：remote_tun]

  Requests tunnel device forwarding with the specified      [tun(4)](https://man.openbsd.org/tun.4) devices      between the client (local_tun) and the server      (remote_tun).     请求使用指定的 [tun（4）](https://man.openbsd.org/tun.4) 设备 在客户端 （local_tun） 和服务器之间 （remote_tun）。The devices may be specified by numerical ID or the keyword        “any”, which uses the next available tunnel device. If        remote_tun is not specified, it defaults to        “any”. See also the `Tunnel` and        `TunnelDevice` directives in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5). 设备可以通过数字 ID 或关键字 “any”，它使用下一个可用的 tunnel 设备。如果 remote_tun 未指定，则默认为 “any”。另请参阅 `Tunnel` 和 `TunnelDevice` 指令 [ssh_config（5）](https://man.openbsd.org/ssh_config.5).    If the `Tunnel` directive is unset, it        will be set to the default tunnel mode, which is        “point-to-point”. If a different        `Tunnel` forwarding mode it desired, then it        should be specified before `-w`. 如果未设置 `Tunnel` 指令，则 将设置为默认的 tunnel 模式，即 “点对点”。如果 `Tunnel` 转发模式，则应在 `-w` 之前指定。      

- [`-X`](https://man.openbsd.org/ssh#X)

  Enables X11 forwarding. This can also be specified on a per-host basis in      a configuration file.     启用 X11 转发。这也可以在 配置文件。X11 forwarding should be enabled with caution. Users with the        ability to bypass file permissions on the remote host (for the user's X        authorization database) can access the local X11 display through the        forwarded connection. An attacker may then be able to perform activities        such as keystroke monitoring. 应谨慎启用 X11 转发。能够绕过远程主机上的文件权限（对于用户的 X 授权数据库）的用户可以通过转发连接访问本地 X11 显示器。然后，攻击者可能能够执行击键监控等活动。    For this reason, X11 forwarding is subjected to X11 SECURITY        extension restrictions by default. Refer to the        `ssh` `-Y` option and the        `ForwardX11Trusted` directive in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information. 因此，X11 转发受 X11 SECURITY 的约束 扩展限制。请参阅 `ssh-Y``` 选项和 `ForwardX11Trusted` 指令 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解更多信息。      

- [`-x`](https://man.openbsd.org/ssh#x)

  Disables X11 forwarding.     禁用 X11 转发。  

- [`-Y` `-和`](https://man.openbsd.org/ssh#Y)

  Enables trusted X11 forwarding. Trusted X11 forwardings are not subjected      to the X11 SECURITY extension controls.     启用可信 X11 转发。受信任的 X11 转发不受约束 添加到 X11 SECURITY 扩展控件。  

- [`-y` `-和`](https://man.openbsd.org/ssh#y)

  Send log information using the      [syslog(3)](https://man.openbsd.org/syslog.3) system module. By default this information is sent to      stderr. 使用 [syslog（3）](https://man.openbsd.org/syslog.3) 系统模块。默认情况下，此信息将发送到 stderr。

`ssh` may additionally obtain configuration    data from a per-user configuration file and a system-wide configuration    file. The file format and configuration options are described in    [ssh_config(5)](https://man.openbsd.org/ssh_config.5).
`SSH` 还可以获取配置 来自每用户配置文件和系统范围配置的数据 文件。文件格式和配置选项在 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5)

## [AUTHENTICATION 认证](https://man.openbsd.org/ssh#AUTHENTICATION)

The OpenSSH SSH client supports SSH protocol 2.
OpenSSH SSH 客户端支持 SSH 协议 2。

The methods available for authentication are: GSSAPI-based    authentication, host-based authentication, public key authentication,    keyboard-interactive authentication, and password authentication.    Authentication methods are tried in the order specified above, though    `PreferredAuthentications` can be used to change the    default order.
可用于身份验证的方法包括：基于 GSSAPI 身份验证、基于主机的身份验证、公钥身份验证、 键盘交互式身份验证和密码身份验证。 不过，将按照上面指定的顺序尝试身份验证方法 `PreferredAuthentications` 可用于更改默认顺序。

Host-based authentication works as follows: If the    machine the user logs in from is listed in    /etc/hosts.equiv or    /etc/shosts.equiv on the remote machine, the user is    non-root and the user names are the same on both sides, or if the files    ~/.rhosts or ~/.shosts exist    in the user's home directory on the remote machine and contain a line    containing the name of the client machine and the name of the user on that    machine, the user is considered for login. Additionally, the server    [*must*](https://man.openbsd.org/ssh#must) be able to    verify the client's host key (see the description of    /etc/ssh/ssh_known_hosts and    ~/.ssh/known_hosts, below) for login to be    permitted. This authentication method closes security holes due to IP    spoofing, DNS spoofing, and routing spoofing. [Note to the administrator:    /etc/hosts.equiv, ~/.rhosts,    and the rlogin/rsh protocol in general, are inherently insecure and should    be disabled if security is desired.]
基于主机的身份验证的工作原理如下：如果 用户登录时所用的计算机列在 /etc/hosts.equiv 或 /etc/shosts.equiv 时，用户为 non-root 和用户名在两边相同，或者如果文件 存在 ~/.rhosts 或 ~/.shosts 在远程计算机上的用户主目录中，并包含一行 包含客户端计算机的名称和该计算机上的用户名称 machine 时，系统会考虑该用户进行登录。此外，服务器 [*必须*](https://man.openbsd.org/ssh#must)能够 验证客户端的 Host Key （请参阅 /etc/ssh/ssh_known_hosts 和 ~/.ssh/known_hosts，如下所示），以便将登录名设为 允许。此身份验证方法可消除 IP 造成的安全漏洞 欺骗、DNS 欺骗和路由欺骗。[管理员注意： /etc/hosts.equiv、~/.rhosts 和一般的 rlogin/rsh 协议本质上是不安全的，如果需要安全性，应该禁用它们。

Public key authentication works as follows: The scheme is based on    public-key cryptography, using cryptosystems where encryption and decryption    are done using separate keys, and it is unfeasible to derive the decryption    key from the encryption key. The idea is that each user creates a    public/private key pair for authentication purposes. The server knows the    public key, and only the user knows the private key.    `ssh` implements public key authentication protocol    automatically, using one of the ECDSA, Ed25519 or RSA algorithms.
公钥身份验证的工作原理如下：该方案基于 公钥加密，使用加密系统和解密 使用单独的密钥完成，并且无法获得解密 key 从加密密钥中获取。这个想法是每个用户创建一个 用于身份验证目的的公钥/私钥对。服务器知道 public key，并且只有用户知道私钥。 `ssh` 使用 ECDSA、Ed25519 或 RSA 算法之一自动实现公钥身份验证协议。

The file ~/.ssh/authorized_keys lists the    public keys that are permitted for logging in. When the user logs in, the    `ssh` program tells the server which key pair it would    like to use for authentication. The client proves that it has access to the    private key and the server checks that the corresponding public key is    authorized to accept the account.
文件 ~/.ssh/authorized_keys 列出了 允许登录的公钥。当用户登录时， `SSH` 程序告诉服务器它想要使用哪个密钥对进行身份验证。客户端证明它有权访问私钥，服务器检查相应的公钥是否有权接受该账户。

The server may inform the client of errors that prevented public    key authentication from succeeding after authentication completes using a    different method. These may be viewed by increasing the    `LogLevel` to `DEBUG` or higher    (e.g. by using the `-v` flag).
服务器可能会通知客户端阻止公开的错误 密钥身份验证成功 不同的方法。这些可以通过增加 `LogLevel` 设置为 `DEBUG` 或更高级别（例如，通过使用 `-v` 标志）。

The user creates their key pair by running    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1). This stores the private key in    ~/.ssh/id_ecdsa (ECDSA),    ~/.ssh/id_ecdsa_sk (authenticator-hosted ECDSA),    ~/.ssh/id_ed25519 (Ed25519),    ~/.ssh/id_ed25519_sk (authenticator-hosted Ed25519),    or ~/.ssh/id_rsa (RSA) and stores the public key in    ~/.ssh/id_ecdsa.pub (ECDSA),    ~/.ssh/id_ecdsa_sk.pub (authenticator-hosted ECDSA),    ~/.ssh/id_ed25519.pub (Ed25519),    ~/.ssh/id_ed25519_sk.pub (authenticator-hosted    Ed25519), or ~/.ssh/id_rsa.pub (RSA) in the user's    home directory. The user should then copy the public key to    ~/.ssh/authorized_keys in their home directory on    the remote machine. The authorized_keys file    corresponds to the conventional ~/.rhosts file, and    has one key per line, though the lines can be very long. After this, the    user can log in without giving the password.
用户通过运行 [ssh-keygen（1）](https://man.openbsd.org/ssh-keygen.1) 的这会将私钥存储在 ~/.ssh/id_ecdsa （ECDSA）、 ~/.ssh/id_ecdsa_sk（验证器托管的 ECDSA）、 ~/.ssh/id_ed25519 （Ed25519）、 ~/.ssh/id_ed25519_sk（身份验证器托管的 Ed25519）或 ~/.ssh/id_rsa （RSA），并将公钥存储在 ~/.ssh/id_ecdsa.pub （ECDSA）、 ~/.ssh/id_ecdsa_sk.pub（验证器托管的 ECDSA）、 ~/.ssh/id_ed25519.pub （Ed25519）、 ~/.ssh/id_ed25519_sk.pub（身份验证器托管的 Ed25519）或 ~/.ssh/id_rsa.pub （RSA） home 目录。然后，用户应将公钥复制到 ~/.ssh/authorized_keys 在远程计算机上的主目录中。authorized_keys 文件对应于传统的 ~/.rhosts 文件，每行有一个键，尽管行可以很长。在此之后，用户无需提供密码即可登录。

A variation on public key authentication is available in the form    of certificate authentication: instead of a set of public/private keys,    signed certificates are used. This has the advantage that a single trusted    certification authority can be used in place of many public/private keys.    See the CERTIFICATES section of    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1) for more information.
公钥身份验证的变体在以下表单中提供 证书身份验证：而不是一组公钥/私钥， 使用签名证书。这样做的好处是，单个受信任的 可以使用证书颁发机构代替许多公钥/私钥。 请参阅 CERTIFICATES 部分 [ssh-keygen（1）](https://man.openbsd.org/ssh-keygen.1) 了解更多信息。

The most convenient way to use public key or certificate    authentication may be with an authentication agent. See    [ssh-agent(1)](https://man.openbsd.org/ssh-agent.1) and (optionally) the    `AddKeysToAgent` directive in    [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.
使用公钥或证书的最便捷方式 可以使用身份验证代理进行身份验证。看 [ssh-agent（1）](https://man.openbsd.org/ssh-agent.1) 和（可选）的 `AddKeysToAgent` 指令 [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解更多信息。

Keyboard-interactive authentication works as follows: The server    sends an arbitrary "challenge" text and prompts for a response,    possibly multiple times. Examples of keyboard-interactive authentication    include BSD Authentication (see    [login.conf(5)](https://man.openbsd.org/login.conf.5)) and PAM (some non-OpenBSD    systems).
键盘交互身份验证的工作原理如下：服务器发送任意的 “质询” 文本并提示响应，可能会多次。键盘交互式身份验证的示例包括 BSD 身份验证（请参阅 [login.conf（5）](https://man.openbsd.org/login.conf.5)）和 PAM（一些非 OpenBSD 系统）。

Finally, if other authentication methods fail,    `ssh` prompts the user for a password. The password is    sent to the remote host for checking; however, since all communications are    encrypted, the password cannot be seen by someone listening on the  network.
最后，如果其他身份验证方法失败， `SSH` 提示用户输入密码。密码将发送到远程主机进行检查;但是，由于所有通信都已加密，因此在网络上侦听的人无法看到密码。

`ssh` automatically maintains and checks a    database containing identification for all hosts it has ever been used with.    Host keys are stored in ~/.ssh/known_hosts in the    user's home directory. Additionally, the file    /etc/ssh/ssh_known_hosts is automatically checked    for known hosts. Any new hosts are automatically added to the user's file.    If a host's identification ever changes, `ssh` warns    about this and disables password authentication to prevent server spoofing    or man-in-the-middle attacks, which could otherwise be used to circumvent    the encryption. The `StrictHostKeyChecking` option can    be used to control logins to machines whose host key is not known or has    changed.
`SSH` 会自动维护和检查一个数据库，其中包含它曾经使用过的所有主机的标识。主机密钥存储在 ~/.ssh/known_hosts 中的 用户的主目录。此外，文件 /etc/ssh/ssh_known_hosts 会自动检查已知主机。任何新主机都会自动添加到用户的文件中。如果主机的标识发生更改，`ssh` 会发出警告并禁用密码身份验证，以防止服务器欺骗或中间人攻击，否则这些攻击可能会被用来规避加密。`StrictHostKeyChecking` 选项可用于控制对主机密钥未知或已更改的计算机的登录。

When the user's identity has been accepted by the server, the    server either executes the given command in a non-interactive session or, if    no command has been specified, logs into the machine and gives the user a    normal shell as an interactive session. All communication with the remote    command or shell will be automatically encrypted.
当服务器接受用户的身份时，服务器要么在非交互式会话中执行给定的命令，要么如果未指定命令，则登录到计算机并为用户提供一个普通的 shell 作为交互式会话。与远程命令或 shell 的所有通信都将自动加密。

If an interactive session is requested,    `ssh` by default will only request a pseudo-terminal    (pty) for interactive sessions when the client has one. The flags    `-T` and `-t` can be used to    override this behaviour.
如果请求交互式会话， `默认情况下，SSH` 只会请求一个伪终端 （pty） 进行交互式会话。标志 `-T` 和 `-t` 可用于覆盖此行为。

If a pseudo-terminal has been allocated, the user may use the    escape characters noted below.
如果已分配伪终端，则用户可以使用下面所述的转义字符。

If no pseudo-terminal has been allocated, the session is    transparent and can be used to reliably transfer binary data. On most    systems, setting the escape character to “none” will also make    the session transparent even if a tty is used.
如果未分配伪终端，则会话是透明的，可用于可靠地传输二进制数据。在大多数系统上，将转义字符设置为 “none” 也会使会话透明，即使使用 tty 也是如此。

The session terminates when the command or shell on the remote    machine exits and all X11 and TCP connections have been closed.
当远程计算机上的命令或 shell 退出并且所有 X11 和 TCP 连接都已关闭时，会话将终止。

## 转义字符

When a pseudo-terminal has been requested,    `ssh` supports a number of functions through the use    of an escape character.
请求伪终端时， `SSH` 通过使用转义字符支持许多函数。

当请求了伪终端时，ssh通过使用转义符支持许多功能。

A single tilde character can be sent as `~~`    or by following the tilde by a character other than those described below.    The escape character must always follow a newline to be interpreted as    special. The escape character can be changed in configuration files using    the `EscapeChar` configuration directive or on the    command line by the `-e` option.
单个波浪号字符可以作为 `~~` 发送 或者通过跟随波浪号加上下面描述的字符以外的字符。 转义字符必须始终跟在换行符后面才能解释为 特殊。在配置文件中，可以使用 `EscapeChar` 配置指令或在命令行上通过 `-e` 选项。

一个波浪号字符可以作为~~发送，也可以通过在波浪号后面加上以下描述以外的字符来发送。转义符必须始终跟在换行符之后才能解释为特殊字符。可以在配置文件中使用escape Char配置指令或在命令行上使用-e选项更改转义符。

The supported escapes (assuming the default    ‘`~`’) are:
支持的转义（假设默认为 '`~`'）为：

- `~.`

  断开。

- `~^Z`

  Background `ssh`. 后台 `ssh`.

- `~#`

  List forwarded connections. 列出转发的连接。

- `~&`

  Background `ssh` at logout when waiting for      forwarded connection / X11 sessions to terminate. 在等待转发的连接/X11 会话终止时注销时的后台 `ssh`。

- `~?`

  Display a list of escape characters. 显示转义字符列表。

- `~B`

  Send a BREAK to the remote system (only useful if the peer supports    it). 向远程系统发送 BREAK （仅在对等体支持时有用）。

- `~C`

  Open command line. Currently this allows the addition of port forwardings      using the `-L`, `-R` and      `-D` options (see above). It also allows the      cancellation of existing port-forwardings with      `-KL`[bind_address:]port      for local,      `-KR`[bind_address:]port      for remote and      `-KD`[bind_address:]port      for dynamic port-forwardings.      `!`command allows the user to      execute a local command if the `PermitLocalCommand`      option is enabled in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5). Basic help is available, using the      `-h` option. 打开命令行。目前，这允许使用 `-L`、`-R` 和 `-D` 选项（见上文）。它还允许 取消现有端口转发 `-KL`[bind_address：] 端口 对于本地， `-KR`[bind_address：] 端口 用于远程和 `-KD`[bind_address：] 端口 用于动态端口转发。 `！` 命令允许用户执行本地命令，如果 `PermitLocalCommand` 选项在 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5) 提供基本帮助，使用 `-h` 选项。

- `~R`

  Request rekeying of the connection (only useful if the peer supports    it). 请求重新生成连接的密钥（仅在对等体支持时有用）。

- `~V`

  Decrease the verbosity (`LogLevel`) when errors are      being written to stderr. 在将错误写入 stderr 时降低详细程度 （`LogLevel`）。

- `~v`

  Increase the verbosity (`LogLevel`) when errors are      being written to stderr. 在将错误写入 stderr 时增加详细程度 （`LogLevel`）。

## TCP 转发

Forwarding of arbitrary TCP connections over a secure channel can    be specified either on the command line or in a configuration file. One    possible application of TCP forwarding is a secure connection to a mail    server; another is going through firewalls.
可以在命令行或配置文件中指定通过安全通道转发任意 TCP 连接。TCP 转发的一个可能应用是与邮件服务器建立安全连接;另一个是通过防火墙。

In the example below, we look at encrypting communication for an    IRC client, even though the IRC server it connects to does not directly    support encrypted communication. This works as follows: the user connects to    the remote host using `ssh`, specifying the ports to    be used to forward the connection. After that it is possible to start the    program locally, and `ssh` will encrypt and forward    the connection to the remote server.
在下面的示例中，我们查看了 IRC 客户端的加密通信，即使它连接到的 IRC 服务器不直接支持加密通信。其工作原理如下：用户使用 `ssh` 连接到远程主机，并指定要用于转发连接的端口。之后可以在本地启动程序，`ssh` 将加密并将连接转发到远程服务器。

The following example tunnels an IRC session from the client to an    IRC server at “server.example.com”, joining channel    “#users”, nickname “pinky”, using the standard    IRC port, 6667:
以下示例使用标准 IRC 端口 6667 将 IRC 会话从客户端隧道传输到位于 “server.example.com” 的 IRC 服务器，加入频道 “#users”，昵称 “pinky”：

```
$ ssh -f -L 6667:localhost:6667 server.example.com sleep 10
$ irc -c '#users' pinky IRC/127.0.0.1
```

The `-f` option backgrounds    `ssh` and the remote command “sleep 10”    is specified to allow an amount of time (10 seconds, in the example) to    start the program which is going to use the tunnel. If no connections are    made within the time specified, `ssh` will exit.
`-f` 选项 backgrounds `ssh` 并指定远程命令 “sleep 10” 以允许一定时间（在本例中为 10 秒）来启动将使用隧道的程序。如果在指定的时间内未建立任何连接，` 则 ssh` 将退出。

## X11 转发

If the `ForwardX11` variable is set to    “yes” (or see the description of the    `-X`, `-x`, and    `-Y` options above) and the user is using X11 (the    `DISPLAY` environment variable is set), the connection    to the X11 display is automatically forwarded to the remote side in such a    way that any X11 programs started from the shell (or command) will go    through the encrypted channel, and the connection to the real X server will    be made from the local machine. The user should not manually set    `DISPLAY`. Forwarding of X11 connections can be    configured on the command line or in configuration files.
如果 `ForwardX11` 变量设置为 “yes” （或查看 `-X`、`-x` 和 `-Y` 选项），并且用户使用的是 X11（ `DISPLAY` 环境变量），则连接 到 X11 显示器会自动转发到远程端，这样 方式，任何从 shell（或命令）启动的 X11 程序都将 通过加密通道，连接到真正的 X 服务器将 从本地计算机创建。用户不应手动设置 `显示 `。可以在命令行或配置文件中配置 X11 连接的转发。

The `DISPLAY` value set by    `ssh` will point to the server machine, but with a    display number greater than zero. This is normal, and happens because    `ssh` creates a “proxy” X server on the    server machine for forwarding the connections over the encrypted  channel.
`由` `SSH` 将指向服务器计算机，但使用 显示大于零的 DISPLAY NUMBER。这是正常的，发生的原因 `ssh` 在服务器机器上创建一个 “proxy” X 服务器，用于通过加密通道转发连接。

`ssh` will also automatically set up    Xauthority data on the server machine. For this purpose, it will generate a    random authorization cookie, store it in Xauthority on the server, and    verify that any forwarded connections carry this cookie and replace it by    the real cookie when the connection is opened. The real authentication    cookie is never sent to the server machine (and no cookies are sent in the    plain).
`ssh` 还将在服务器计算机上自动设置 Xauthority 数据。为此，它会生成一个随机的授权 cookie，将其存储在服务器上的  Xauthority 中，并验证任何转发的连接是否携带了这个 cookie，并在连接打开时将其替换为真实的 cookie。真正的身份验证  cookie 永远不会发送到服务器计算机（并且不会在普通环境中发送任何 cookie）。

If the `ForwardAgent` variable is set to    “yes” (or see the description of the    `-A` and `-a` options above) and    the user is using an authentication agent, the connection to the agent is    automatically forwarded to the remote side.
如果 `ForwardAgent` 变量设置为 “yes” （或查看 `-A` 和 `-a` 选项），并且用户正在使用身份验证代理，则与代理的连接会自动转发到远程端。

## 验证主机密钥

When connecting to a server for the first time, a fingerprint of    the server's public key is presented to the user (unless the option    `StrictHostKeyChecking` has been disabled).    Fingerprints can be determined using    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1):
首次连接服务器时，指纹 服务器的公钥将呈现给用户（除非 `StrictHostKeyChecking` 已被禁用）。 指纹可以使用 [ssh-keygen（1）](https://man.openbsd.org/ssh-keygen.1) 的

```bash
$ ssh-keygen -l -f  /etc/ssh/ssh_host_rsa_key
```

If the fingerprint is already known, it can be matched and the key    can be accepted or rejected. If only legacy (MD5) fingerprints for the    server are available, the    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1) `-E` option may be used to    downgrade the fingerprint algorithm to match.
如果指纹已知，则可以匹配它，密钥 可以接受或拒绝。如果只有 服务器可用，则 [ssh-keygen（1）](https://man.openbsd.org/ssh-keygen.1)`-E` 选项可用于降级指纹算法以进行匹配。

Because of the difficulty of comparing host keys just    by looking at fingerprint strings, there is also support to compare host    keys visually, using    [*random art*](https://man.openbsd.org/ssh#random). By    setting the `VisualHostKey` option to    “yes”, a small ASCII graphic gets displayed on every login to    a server, no matter if the session itself is interactive or not. By learning    the pattern a known server produces, a user can easily find out that the    host key has changed when a completely different pattern is displayed.    Because these patterns are not unambiguous however, a pattern that looks    similar to the pattern remembered only gives a good probability that the    host key is the same, not guaranteed proof.
因为比较主机密钥的难度 通过查看指纹字符串，还支持比较主机 键，使用 [*随机艺术* ](https://man.openbsd.org/ssh#random)。通过将 `VisualHostKey` 选项设置为 “yes”，无论会话本身是否为交互式，每次登录服务器时都会显示一个小的 ASCII  图形。通过学习已知服务器生成的模式，当显示完全不同的模式时，用户可以很容易地发现主机密钥已更改。但是，由于这些模式并非明确，因此看起来与记住的模式相似的模式只能提供主机密钥相同的良好可能性，而不能保证证明。

To get a listing of the fingerprints along with their random art    for all known hosts, the following command line can be used:
要获取所有已知主机的指纹列表及其随机图，可以使用以下命令行：

```bash
$ ssh-keygen -lv -f  ~/.ssh/known_hosts
```

If the fingerprint is unknown, an alternative method of    verification is available: SSH fingerprints verified by DNS. An additional    resource record (RR), SSHFP, is added to a zonefile and the connecting    client is able to match the fingerprint with that of the key presented.
如果指纹未知，则可以使用另一种验证方法：由 DNS 验证的 SSH 指纹。将附加资源记录 （RR） SSHFP 添加到区域文件中，连接客户端能够将指纹与提供的密钥的指纹进行匹配。

In this example, we are connecting a client to a server,    “host.example.com”. The SSHFP resource records should first be    added to the zonefile for host.example.com:
在此示例中，我们将客户端连接到服务器 “host.example.com”。SSHFP 资源记录应首先添加到 zonefile 中，以便进行 host.example.com：

```bash
$ ssh-keygen -r host.example.com.
```

The output lines will have to be added to the zonefile. To check    that the zone is answering fingerprint queries:
必须将输出行添加到 zonefile 中。要检查区域是否正在回答指纹查询，请执行以下作：

```bash
$ dig -t SSHFP  host.example.com
```

Finally the client connects:
最后，客户端连接：

```bash
$ ssh -o "VerifyHostKeyDNS ask" host.example.com
[...]
Matching host key fingerprint found in DNS.
Are you sure you want to continue connecting (yes/no)?
```

See the `VerifyHostKeyDNS` option in    [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.
请参阅`` [ssh_config（5）](https://man.openbsd.org/ssh_config.5) 了解更多信息。

## 基于 SSH 的虚拟专用网络

`ssh` contains support for Virtual Private    Network (VPN) tunnelling using the    [tun(4)](https://man.openbsd.org/tun.4) network    pseudo-device, allowing two networks to be joined securely. The    [sshd_config(5)](https://man.openbsd.org/sshd_config.5) configuration option    `PermitTunnel` controls whether the server supports    this, and at what level (layer 2 or 3 traffic).
`ssh` 包含对虚拟专用的支持 使用 [tun（4）](https://man.openbsd.org/tun.4) 网络 pseudo-device，允许安全地加入两个网络。这 [sshd_config（5）](https://man.openbsd.org/sshd_config.5) 配置选项 `PermitTunnel` 控制服务器是否支持此功能，以及支持哪个级别（第 2 层或第 3 层流量）。

The following example would connect client network 10.0.50.0/24    with remote network 10.0.99.0/24 using a point-to-point connection from    10.1.1.1 to 10.1.1.2, provided that the SSH server running on the gateway to    the remote network, at 192.168.1.15, allows it.
以下示例将使用从 10.1.1.1 到 10.1.1.2 的点对点连接将客户端网络 10.0.50.0/24 与远程网络 10.0.99.0/24 连接起来，前提是在远程网络网关 192.168.1.15 上运行的 SSH 服务器允许这样做。

在客户端上：

```bash
ssh -f -w 0:1 192.168.1.15 true
ifconfig tun0 10.1.1.1 10.1.1.2 netmask 255.255.255.252
route add 10.0.99.0/24 10.1.1.2
```

在服务器上：

```bash
ifconfig tun1 10.1.1.2 10.1.1.1 netmask 255.255.255.252
route add 10.0.50.0/24 10.1.1.1
```

Client access may be more finely tuned via the    /root/.ssh/authorized_keys file (see below) and the    `PermitRootLogin` server option. The following entry    would permit connections on [tun(4)](https://man.openbsd.org/tun.4) device 1 from user “jane” and on tun    device 2 from user “john”, if    `PermitRootLogin` is set to    “forced-commands-only”:
客户端访问可以通过 /root/.ssh/authorized_keys 文件（见下文）和 `PermitRootLogin` 服务器选项。以下条目将允许用户 “jane” 在 [tun（4）](https://man.openbsd.org/tun.4) 设备 1 上与 tun 进行连接 来自用户 “john” 的设备 2，如果 `PermitRootLogin` 设置为 “forced-commands-only”：

```bash
tunnel="1",command="sh /etc/netstart tun1" ssh-rsa ... jane
tunnel="2",command="sh /etc/netstart tun2" ssh-rsa ... john
```

Since an SSH-based setup entails a fair amount of overhead, it may    be more suited to temporary setups, such as for wireless VPNs. More    permanent VPNs are better provided by tools such as    [ipsecctl(8)](https://man.openbsd.org/ipsecctl.8) and [isakmpd(8)](https://man.openbsd.org/isakmpd.8).
由于基于 SSH 的设置会产生相当大的开销，因此它可能会 更适合临时设置，例如无线 VPN。更多 永久 VPN 最好由以下工具提供 [ipsecctl（8）](https://man.openbsd.org/ipsecctl.8) 和 [isakmpd（8）](https://man.openbsd.org/isakmpd.8) 来获取。

## 环境

`ssh` 通常会设置以下环境变量：

- `DISPLAY`

  The `DISPLAY` variable indicates the location of the      X11 server. It is automatically set by `ssh` to      point to a value of the form “hostname:n”, where      “hostname” indicates the host where the shell runs, and      ‘n’ is an integer ≥ 1. `ssh`      uses this special value to forward X11 connections over the secure      channel. The user should normally not set `DISPLAY`      explicitly, as that will render the X11 connection insecure (and will      require the user to manually copy any required authorization    cookies). `DISPLAY` 变量指示 X11 服务器的位置。它由 `ssh` 自动设置为指向 “hostname：n” 形式的值，其中 “hostname” 表示运行 shell 的主机，而 'n' 是 1 ≥整数。`ssh` 使用此特殊值通过安全的 渠道。用户通常不应设置 `DISPLAY` 显式地，因为这将使 X11 连接不安全（并且会 要求用户手动复制任何所需的授权 饼干）。

- `HOME`

  设置为用户主目录的路径。

- `LOGNAME`

  Synonym for `USER`; set for compatibility with      systems that use this variable. `USER` 的同义词;设置为与使用此变量的系统兼容。

- `MAIL`

  Set to the path of the user's mailbox. 设置为用户邮箱的路径。

- `PATH`

  Set to the default `PATH`, as specified when      compiling `ssh`. 设置为默认 `PATH，` 如编译 `ssh` 时指定的那样。

- `SSH_ASKPASS`

  If `ssh` needs a passphrase, it will read the      passphrase from the current terminal if it was run from a terminal. If      `ssh` does not have a terminal associated with it      but `DISPLAY` and      `SSH_ASKPASS` are set, it will execute the program      specified by `SSH_ASKPASS` and open an X11 window to      read the passphrase. This is particularly useful when calling      `ssh` from a .xsession or      related script. (Note that on some machines it may be necessary to      redirect the input from /dev/null to make this      work.) 如果 `ssh` 需要密码，它将读取 passphrase （如果它是从终端运行的）。如果 `ssh` 没有与之关联的终端，但 `DISPLAY` 和 `设置 SSH_ASKPASS`，它将执行 `SSH_ASKPASS` 指定的程序，并打开一个 X11 窗口 阅读密码。这在调用 `ssh` 从 .xsession 或相关脚本。（请注意，在某些计算机上，可能需要重定向来自 /dev/null 的输入才能实现此目的。

- `SSH_ASKPASS_REQUIRE`

  Allows further control over the use of an askpass program. If this      variable is set to “never” then `ssh`      will never attempt to use one. If it is set to “prefer”,      then `ssh` will prefer to use the askpass program      instead of the TTY when requesting passwords. Finally, if the variable is      set to “force”, then the askpass program will be used for      all passphrase input regardless of whether `DISPLAY`      is set. 允许进一步控制 askpass 程序的使用。如果此变量设置为 “never” ，则 `ssh` 永远不会尝试使用。如果设置为 “prefer”， 那么 `ssh` 在请求密码时将更喜欢使用 askpass 程序而不是 TTY。最后，如果变量设置为 “force”，则 askpass 程序将用于所有密码输入，无论 `DISPLAY` 是否 已设置。

- `SSH_AUTH_SOCK`

  Identifies the path of a UNIX-domain socket used      to communicate with the agent. 标识用于与代理通信的 UNIX 域套接字的路径。

- `SSH_CONNECTION`

  Identifies the client and server ends of the connection. The variable      contains four space-separated values: client IP address, client port      number, server IP address, and server port number. 标识连接的客户端端和服务器端。该变量包含四个以空格分隔的值：客户端 IP 地址、客户端端口号、服务器 IP 地址和服务器端口号。

- `SSH_ORIGINAL_COMMAND`

  This variable contains the original command line if a forced command is      executed. It can be used to extract the original arguments. 如果执行强制命令，则此变量包含原始命令行。它可用于提取原始参数。

- `SSH_TTY`

  This is set to the name of the tty (path to the device) associated with      the current shell or command. If the current session has no tty, this      variable is not set. 此字段设置为与当前 shell 或命令关联的 tty（设备路径）的名称。如果当前会话没有 tty，则不设置此变量。

- `SSH_TUNNEL`

  Optionally set by [sshd(8)](https://man.openbsd.org/sshd.8) to contain the interface names assigned if tunnel      forwarding was requested by the client. 可选地由 [sshd（8）](https://man.openbsd.org/sshd.8) 设置，以包含在客户端请求隧道转发时分配的接口名称。

- `SSH_USER_AUTH`

  Optionally set by [sshd(8)](https://man.openbsd.org/sshd.8), this variable may contain a pathname to a file that lists      the authentication methods successfully used when the session was      established, including any public keys that were used. 可选地由 [sshd（8）](https://man.openbsd.org/sshd.8) 设置，这个变量可以包含一个文件的路径名，该文件列出了在建立会话时成功使用的身份验证方法，包括任何使用的公钥。

- `TZ`

  This variable is set to indicate the present time zone if it was set when      the daemon was started (i.e. the daemon passes the value on to new      connections). 如果在启动守护进程时设置了此变量，则此变量设置为指示当前时区（即守护进程将值传递给新连接）。

- `USER`

  Set to the name of the user logging in. 设置为登录用户的名称。

Additionally, `ssh` reads    ~/.ssh/environment, and adds lines of the format    “VARNAME=value” to the environment if the file exists and    users are allowed to change their environment. For more information, see the    `PermitUserEnvironment` option in    [sshd_config(5)](https://man.openbsd.org/sshd_config.5).
此外，`ssh` 读取 ~/.ssh/environment，并添加格式为 “VARNAME=value” 添加到环境中（如果文件存在），并且 允许用户更改其环境。有关更多信息，请参阅 `PermitUserEnvironment` 选项中的 [sshd_config（5）](https://man.openbsd.org/sshd_config.5).

## 文件

- ~/.rhosts

  On some      machines this file may need to be world-readable if the user's home      directory is on an NFS partition, because      [sshd(8)](https://man.openbsd.org/sshd.8)      reads it as root. Additionally, this file must be owned by the user, and      must not have write permissions for anyone else. The recommended      permission for most machines is read/write for the user, and not      accessible by others.     此文件用于基于主机的身份验证（见上文）。在某些 machines 如果用户的家 目录位于 NFS 分区上，因为 [固态硬盘（8）](https://man.openbsd.org/sshd.8) 将其读取为 root。此外，此文件必须由用户拥有，并且 不得具有其他任何人的写入权限。推荐的 大多数计算机的权限是用户的读/写权限，而不是 其他人可以访问。  

  On some      machines this file may need to be world-readable if the user's home      directory is on an NFS partition, because      [sshd(8)](https://man.openbsd.org/sshd.8)      reads it as root. Additionally, this file must be owned by the user, and      must not have write permissions for anyone else. The recommended      permission for most machines is read/write for the user, and not      accessible by others.      

- ~/.shosts

  This file is used in exactly the same way as      .rhosts, but allows host-based authentication      without permitting login with rlogin/rsh.     此文件的使用方式与 .rhosts，但允许基于主机的身份验证 不允许使用 rlogin/rsh 登录。

- ~/.ssh/

  This directory is the default location for all user-specific configuration      and authentication information. There is no general requirement to keep      the entire contents of this directory secret, but the recommended      permissions are read/write/execute for the user, and not accessible by      others.     此目录是所有用户特定配置的默认位置 和身份验证信息。没有一般要求保留 此目录 secret 的全部内容，但建议使用 权限是用户的读/写/执行权限，并且不能由 别人。  

- ~/.ssh/authorized_keys

  Lists the public keys (DSA, ECDSA, Ed25519, RSA) that can be used for logging      in as this user. The format of this file is described in the      [sshd(8)](https://man.openbsd.org/sshd.8)      manual page. This file is not highly sensitive, but the recommended      permissions are read/write for the user, and not accessible by others.     列出可用于日志记录的公钥（ECDSA、Ed25519、RSA） in 作为此用户。此文件的格式在 [固态硬盘（8）](https://man.openbsd.org/sshd.8) 手册页。此文件不是高度敏感的，但建议使用 权限是用户的读/写权限，其他人无法访问。    

- ~/.ssh/config

  This is the per-user configuration file. The file format and configuration      options are described in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5). Because of the potential for abuse, this file must      have strict permissions: read/write for the user, and not writable by      others.     这是每用户的配置文件。文件格式和配置 选项在 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5) 由于存在滥用的可能性，此文件必须 具有严格的权限：用户读/写，并且不能被 别人。  

- ~/.ssh/environment

  Contains additional definitions for environment variables; see      [ENVIRONMENT](https://man.openbsd.org/ssh#ENVIRONMENT), above.     包含环境变量的其他定义;看 [ENVIRONMENT，](https://man.openbsd.org/ssh#ENVIRONMENT) 如上。        

- ~/.ssh/id_dsa

- ~/.ssh/id_ecdsa

- ~/.ssh/id_ecdsa_sk

- ~/.ssh/id_ed25519

- ~/.ssh/id_ed25519_sk

- ~/.ssh/id_rsa

  Contains the private key for authentication. These files contain sensitive      data and should be readable by the user but not accessible by others      (read/write/execute). `ssh` will simply ignore a      private key file if it is accessible by others. It is possible to specify      a passphrase when generating the key which will be used to encrypt the      sensitive part of this file using AES-128.     包含用于身份验证的私钥。这些文件包含敏感数据，用户应可读，但其他人无法访问（读/写/执行）。`ssh` 将简单地忽略 private key 文件（如果其他人可以访问）。可以指定 生成密钥时的密码短语，用于加密 此文件的敏感部分使用 AES-128 。

- ~/.ssh/id_dsa.pub

- ~/.ssh/id_ecdsa.pub

- ~/.ssh/id_ecdsa_sk.pub

- ~/.ssh/id_ed25519.pub 

- ~/.ssh/id_ed25519_sk.pub

- ~/.ssh/id_rsa.pub

  Contains the public key for authentication. These files are not sensitive      and can (but need not) be readable by anyone.     包含用于身份验证的公钥。这些文件不敏感 并且可以（但不需要）被任何人读取。

- ~/.ssh/known_hosts

  Contains a list of host keys for all hosts the user has logged into that      are not already in the systemwide list of known host keys. See      [sshd(8)](https://man.openbsd.org/sshd.8) for      further details of the format of this file.    

  包含用户已登录的所有主机的主机密钥列表 尚未在系统范围的已知主机密钥列表中。看 [sshd（8）](https://man.openbsd.org/sshd.8) 用于 此文件格式的更多详细信息。   

- ~/.ssh/rc

  Commands in this file are executed by `ssh` when the      user logs in, just before the user's shell (or command) is started. See      the [sshd(8)](https://man.openbsd.org/sshd.8)      manual page for more information.     此文件中的命令在用户登录时由 `ssh` 执行，就在用户的 shell（或命令）启动之前。请参阅 [sshd（8）](https://man.openbsd.org/sshd.8) 手册页了解更多信息。  

- /etc/hosts.equiv

  This file is for host-based authentication (see above). It should only be      writable by root.     此文件用于基于主机的身份验证（请参阅上文）。它应该只是 可由 root 写入。  

- /etc/shosts.equiv

  This file is used in exactly the same way as      hosts.equiv, but allows host-based authentication      without permitting login with rlogin/rsh.     此文件的使用方式与 hosts.equiv，但允许基于主机的身份验证 不允许使用 rlogin/rsh 登录。  

- /etc/ssh/ssh_config

  Systemwide configuration file. The file format and configuration options      are described in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5).     系统范围的配置文件。文件格式和配置选项 在 [ssh_config（5）。](https://man.openbsd.org/ssh_config.5)  

- /etc/ssh/ssh_host_key

- /etc/ssh/ssh_host_dsa_key

- /etc/ssh/ssh_host_ecdsa_key 

- /etc/ssh/ssh_host_ed25519_key 

- /etc/ssh/ssh_host_rsa_key

  These files contain the private parts of the host keys and are used for      host-based authentication.     这些文件包含主机密钥的私有部分，用于 基于主机的身份验证。

- /etc/ssh/ssh_known_hosts

  Systemwide list of known host keys. This file should be prepared by the      system administrator to contain the public host keys of all machines in      the organization. It should be world-readable. See      [sshd(8)](https://man.openbsd.org/sshd.8) for      further details of the format of this file.     系统范围的已知主机密钥列表。此文件应由 系统管理员，以包含 组织。它应该是世界可读的。看 [sshd（8）](https://man.openbsd.org/sshd.8) 用于 此文件格式的更多详细信息。  

- /etc/ssh/sshrc

  Commands in this file are executed by `ssh` when the      user logs in, just before the user's shell (or command) is started. See      the [sshd(8)](https://man.openbsd.org/sshd.8)      manual page for more information. 此文件中的命令在用户登录时由 `ssh` 执行，就在用户的 shell（或命令）启动之前。请参阅 [sshd（8）](https://man.openbsd.org/sshd.8) 手册页了解更多信息。

## 退出状态

`ssh` exits with the exit status of the    remote command or with 255 if an error occurred.
`ssh` 以 remote 命令的 exit 状态退出，如果发生错误，则以 255 退出。

## 标准

S. Lehtinen and    C. Lonvick, The Secure Shell    (SSH) Protocol Assigned Numbers, RFC 4250,    January 2006.

S. Lehtinen 和 C. Lonvick， 安全外壳 （SSH） 协议分配编号， [RFC 4250,2006](https://www.rfc-editor.org/rfc/rfc4250.html)  年 1 月 。

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Protocol Architecture,    [RFC     4251](https://www.rfc-editor.org/rfc/rfc4251.html), January 2006.
T. Ylonen 和 C. Lonvick， 安全外壳 （SSH） 协议架构 ， [RFC 4251,2006](https://www.rfc-editor.org/rfc/rfc4251.html)  年 1 月 。

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Authentication Protocol,    [RFC     4252](https://www.rfc-editor.org/rfc/rfc4252.html), January 2006.
T. Ylonen 和 C. Lonvick， 安全外壳 （SSH） 身份验证协议 ， [RFC 4252,2006](https://www.rfc-editor.org/rfc/rfc4252.html)  年 1 月 。

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Transport Layer Protocol,    [RFC     4253](https://www.rfc-editor.org/rfc/rfc4253.html), January 2006.
T. Ylonen 和 C. Lonvick， 安全外壳 （SSH） 传输层协议 ， [RFC 4253,2006](https://www.rfc-editor.org/rfc/rfc4253.html)  年 1 月 。

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Connection Protocol,    [RFC     4254](https://www.rfc-editor.org/rfc/rfc4254.html), January 2006.
T. Ylonen 和 C. Lonvick， 安全外壳 （SSH） 连接协议 ， [RFC 4254,2006](https://www.rfc-editor.org/rfc/rfc4254.html)  年 1 月 。



T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Protocol Architecture, RFC 4251,    January 2006.

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Authentication Protocol, RFC 4252,    January 2006.

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Transport Layer Protocol, RFC 4253,    January 2006.

T. Ylonen and    C. Lonvick, The Secure Shell    (SSH) Connection Protocol, RFC 4254,    January 2006.

J. Schlyter and    W. Griffin, Using DNS to Securely    Publish Secure Shell (SSH) Key Fingerprints,    [RFC     4255](https://www.rfc-editor.org/rfc/rfc4255.html), January 2006.
J. Schlyter 和 W. Griffin， 使用 DNS 安全地发布安全外壳 （SSH） 密钥指纹 ， [RFC 4255,2006](https://www.rfc-editor.org/rfc/rfc4255.html)  年 1 月 。

F. Cusack and    M. Forssen, Generic Message    Exchange Authentication for the Secure Shell Protocol (SSH),    [RFC     4256](https://www.rfc-editor.org/rfc/rfc4256.html), January 2006.
F. Cusack 和 M. Forssen， 安全外壳协议 （SSH） 的通用消息交换身份验证 ， [RFC 4256,2006](https://www.rfc-editor.org/rfc/rfc4256.html)  年 1 月 。

J. Galbraith and    P. Remaker, The Secure Shell    (SSH) Session Channel Break Extension,    [RFC     4335](https://www.rfc-editor.org/rfc/rfc4335.html), January 2006.
J. Galbraith 和 P. Remaker， 安全外壳 （SSH） 会话通道中断扩展 ， [RFC 4335,2006](https://www.rfc-editor.org/rfc/rfc4335.html)  年 1 月 。

M. Bellare,    T. Kohno, and C.    Namprempre, The Secure Shell (SSH) Transport Layer    Encryption Modes,    [RFC     4344](https://www.rfc-editor.org/rfc/rfc4344.html), January 2006.
M. 贝拉雷 ， T. Kohno 和 C. Namprempre， 安全外壳 （SSH） 传输层加密模式 ， [RFC 4344,2006](https://www.rfc-editor.org/rfc/rfc4344.html)  年 1 月 。

B. Harris,    Improved Arcfour Modes for the Secure Shell (SSH)    Transport Layer Protocol,    [RFC     4345](https://www.rfc-editor.org/rfc/rfc4345.html), January 2006.
B. 哈里斯 ， 改进了安全外壳 （SSH） 传输层协议的 Arcfour 模式 ， [RFC 4345,2006](https://www.rfc-editor.org/rfc/rfc4345.html)  年 1 月 。

M. Friedl,    N. Provos, and W. Simpson,    Diffie-Hellman Group Exchange for the Secure Shell (SSH)    Transport Layer Protocol,    [RFC     4419](https://www.rfc-editor.org/rfc/rfc4419.html), March 2006.
M. 弗里德尔 ， N. Provos 和 W. Simpson Diffie-Hellman Group Exchange for the Secure Shell （SSH） 传输层协议 ， [RFC 4419,2006](https://www.rfc-editor.org/rfc/rfc4419.html)  年 3 月 。

J. Galbraith and    R. Thayer, The Secure Shell (SSH)    Public Key File Format,    [RFC     4716](https://www.rfc-editor.org/rfc/rfc4716.html), November 2006.
J. Galbraith 和 R. Thayer， 安全外壳 （SSH） 公钥文件格式 ， [RFC 4716,2006](https://www.rfc-editor.org/rfc/rfc4716.html)  年 11 月 。

D. Stebila and    J. Green, Elliptic Curve    Algorithm Integration in the Secure Shell Transport Layer,    [RFC     5656](https://www.rfc-editor.org/rfc/rfc5656.html), December 2009.
D. Stebila 和 J. Green， 安全 Shell 传输层中的椭圆曲线算法集成 ， [RFC 5656,2009](https://www.rfc-editor.org/rfc/rfc5656.html)  年 12 月 。

A. Perrig and    D. Song, Hash Visualization: a    New Technique to improve Real-World Security,    1999, International Workshop on    Cryptographic Techniques and E-Commerce (CrypTEC '99).
A. Perrig 和 D. Song， 哈希可视化：提高现实世界安全性的新技术 ， 1999 年， 密码技术和电子商务国际研讨会 （CrypTEC '99）。





J. Schlyter and    W. Griffin, Using DNS to Securely    Publish Secure Shell (SSH) Key Fingerprints, RFC    4255, January 2006.

F. Cusack and    M. Forssen, Generic Message    Exchange Authentication for the Secure Shell Protocol (SSH),    RFC 4256, January    2006.

J. Galbraith and    P. Remaker, The Secure Shell    (SSH) Session Channel Break Extension, RFC    4335, January 2006.

M. Bellare,    T. Kohno, and C.    Namprempre, The Secure Shell (SSH) Transport Layer    Encryption Modes, RFC 4344,    January 2006.

B. Harris,    Improved Arcfour Modes for the Secure Shell (SSH)    Transport Layer Protocol, RFC 4345,    January 2006.

M. Friedl,    N. Provos, and W. Simpson,    Diffie-Hellman Group Exchange for the Secure Shell (SSH)    Transport Layer Protocol, RFC 4419,    March 2006.

J. Galbraith and    R. Thayer, The Secure Shell (SSH)    Public Key File Format, RFC 4716,    November 2006.

D. Stebila and    J. Green, Elliptic Curve    Algorithm Integration in the Secure Shell Transport Layer,    RFC 5656, December    2009.

A. Perrig and    D. Song, Hash Visualization: a    New Technique to improve Real-World Security,    1999, International Workshop on    Cryptographic Techniques and E-Commerce (CrypTEC '99).



## 说明



- `-f`

  Requests `ssh` to go to background just before      command execution. This is useful if `ssh` is going      to ask for passwords or passphrases, but the user wants it in the      background. This implies `-n`. The recommended way      to start X11 programs at a remote site is with something like      `ssh -f host xterm`.    If the `ExitOnForwardFailure`        configuration option is set to “yes”, then a client        started with `-f` will wait for all remote port        forwards to be successfully established before placing itself in the        background. Refer to the description of        `ForkAfterAuthentication` in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.      

  请求ssh在命令执行之前转到后台。如果ssh要询问密码或口令，但用户希望在后台输入，那么这很有用。这意味着-n。在远程站点启动X11程序的推荐方法是使用ssh-f host xterm之类的工具。

  如果“转发失败时退出”配置选项设置为“是”，则使用-f启动的客户端将等待所有远程端口转发成功建立，然后再将其置于后台。有关详细信息，请参阅ssh-config（5）中Fork After Authentication的描述。

- `-G`

  Causes `ssh` to print its configuration after      evaluating `Host` and `Match`      blocks and exit.      使ssh在评估Host和Match块后打印其配置并退出。

- `-g`

  Allows remote hosts to connect to local forwarded ports. If used on a      multiplexed connection, then this option must be specified on the master      process.      允许远程主机连接到本地转发端口。如果在多路复用连接上使用，则必须在主进程上指定此选项。

- `-I`    pkcs11

  Specify the PKCS#11 shared library `ssh` should use      to communicate with a PKCS#11 token providing keys for user      authentication.     指定ssh应用于与PKCS#11令牌通信的PKCS#111共享库，该令牌为用户身份验证提供密钥。 

- `-i`    identity_file

  Selects a file from which the identity (private key) for public key      authentication is read. You can also specify a public key file to use the      corresponding private key that is loaded in      [ssh-agent(1)](https://man.openbsd.org/ssh-agent.1) when the private key file is not present locally. The      default is ~/.ssh/id_rsa,      ~/.ssh/id_ecdsa,      ~/.ssh/id_ecdsa_sk,      ~/.ssh/id_ed25519,      ~/.ssh/id_ed25519_sk and      ~/.ssh/id_dsa. Identity files may also be      specified on a per-host basis in the configuration file. It is possible to      have multiple `-i` options (and multiple identities      specified in configuration files). If no certificates have been explicitly      specified by the `CertificateFile` directive,      `ssh` will also try to load certificate information      from the filename obtained by appending -cert.pub      to identity filenames.      选择从中读取公钥身份验证标识（私钥）的文件。您还可以指定一个公钥文件，以在本地不存在私钥文件时使用ssh代理（1）中加载的相应私钥。默认值为~/.ssh/id-rsa、~/.sss/id-ecdsa、~/.ssh/id-ecdesa-sk、~//ssh/id-ed25519、~/.sesh/id-d25519  sk和~/.ssh/id-dsa。还可以在配置文件中按主机指定标识文件。可以有多个-i选项（以及配置文件中指定的多个标识）。如果证书文件指令没有明确指定证书，ssh还将尝试从通过将-cert.pub附加到标识文件名而获得的文件名加载证书信息。    

- `-J`    destination

  Connect to the target host by first making a `ssh`      connection to the jump host described by destination      and then establishing a TCP forwarding to the ultimate destination from      there. Multiple jump hops may be specified separated by comma characters.      This is a shortcut to specify a `ProxyJump`      configuration directive. Note that configuration directives supplied on      the command-line generally apply to the destination host and not any      specified jump hosts. Use ~/.ssh/config to specify      configuration for jump hosts.      连接到目标主机，首先通过ssh连接到目标描述的跳转主机，然后从那里建立到最终目标的TCP转发。可以指定多个跳转，用逗号分隔。这是指定代理跳转配置指令的快捷方式。请注意，命令行上提供的配置指令通常适用于目标主机，而不是任何指定的跳转主机。使用~/.ssh/config指定跳转主机的配置。

- `-K`

  Enables GSSAPI-based authentication and forwarding (delegation) of GSSAPI      credentials to the server.      启用基于GSSAPI的身份验证并将GSSAPI凭据转发（委派）到服务器。

- `-k`

  Disables forwarding (delegation) of GSSAPI credentials to the server.      禁用向服务器转发（委派）GSSAPI凭据。

- `-L`    [bind_address:]port:host:hostport

- `-L`    [bind_address:]port:remote_socket

- `-L`   local_socket:host:hostport

- `-L`    local_socket:remote_socket

  Specifies that connections to the given TCP port or Unix socket on the      local (client) host are to be forwarded to the given host and port, or      Unix socket, on the remote side. This works by allocating a socket to      listen to either a TCP port on the local side,      optionally bound to the specified bind_address, or      to a Unix socket. Whenever a connection is made to the local port or      socket, the connection is forwarded over the secure channel, and a      connection is made to either host port      hostport, or the Unix socket      remote_socket, from the remote machine.    Port forwardings can also be specified in the configuration        file. Only the superuser can forward privileged ports. IPv6 addresses        can be specified by enclosing the address in square brackets.    By default, the local port is bound in accordance with the        `GatewayPorts` setting. However, an explicit        bind_address may be used to bind the connection to        a specific address. The bind_address of        “localhost” indicates that the listening port be bound for        local use only, while an empty address or ‘*’ indicates        that the port should be available from all interfaces.      

  指定到本地（客户端）主机上的给定TCP端口或Unix套接字的连接将转发到远程端的给定主机和端口或Unix套接字。这通过分配一个套接字来侦听本地端的TCP端口（可选地绑定到指定的绑定地址）或Unix套接字来实现。无论何时连接到本地端口或套接字，都会通过安全通道转发连接，并从远程计算机连接到主机端口hostport或Unix套接字远程套接字。

  也可以在配置文件中指定端口转发。只有超级用户才能转发特权端口。IPv6地址可以通过将地址括在方括号中来指定。

  默认情况下，根据网关端口设置绑定本地端口。然而，可以使用显式绑定地址将连接绑定到特定地址。绑定地址“localhost”表示侦听端口仅为本地使用而绑定，而空地址或“*”表示该端口应可从所有接口使用。

- `-l`    login_name

  Specifies the user to log in as on the remote machine. This also may be      specified on a per-host basis in the configuration file.      指定要以远程计算机身份登录的用户。这也可以在配置文件中按主机指定。

- `-M`

  Places the `ssh` client into “master”      mode for connection sharing. Multiple `-M` options      places `ssh` into “master” mode but      with confirmation required using      [ssh-askpass(1)](https://man.openbsd.org/ssh-askpass.1) before each operation that changes the multiplexing      state (e.g. opening a new session). Refer to the description of      `ControlMaster` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.      将ssh客户端置于“主”模式以进行连接共享。多个-M选项将ssh置于“主”模式，但在每次更改复用状态的操作（例如打开新会话）之前，都需要使用ssh-askpass（1）进行确认。有关详细信息，请参阅ssh-config（5）中对Control Master的描述。

- `-m`    mac_spec

  A comma-separated list of MAC (message authentication code) algorithms,      specified in order of preference. See the `MACs`      keyword in [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.      以逗号分隔的MAC（消息验证码）算法列表，按优先顺序指定。有关更多信息，请参阅ssh-config（5）中的MACs关键字。

- `-N`

  Do not execute a remote command. This is useful for just forwarding ports.      Refer to the description of `SessionType` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.     不要执行远程命令。这对于转发端口很有用。有关详细信息，请参阅ssh-config（5）中的会话类型描述。 

- `-n`

  Redirects stdin from /dev/null (actually, prevents      reading from stdin). This must be used when `ssh` is      run in the background. A common trick is to use this to run X11 programs      on a remote machine. For example, `ssh -n      shadows.cs.hut.fi emacs &` will start an emacs on      shadows.cs.hut.fi, and the X11 connection will be automatically forwarded      over an encrypted channel. The `ssh` program will be      put in the background. (This does not work if `ssh`      needs to ask for a password or passphrase; see also the      `-f` option.) Refer to the description of      `StdinNull` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.      将stdin从/dev/null重定向（实际上，阻止从stdin读取）。当ssh在后台运行时，必须使用此选项。一个常见的技巧是使用它在远程机器上运行X11程序。例如，ssh-n shadows.cs.hut.fi  emacs&将在shadows.cs.hut.fi上启动emacs，X11连接将通过加密通道自动转发。ssh程序将置于后台。（如果ssh需要请求密码或口令，这不起作用；另请参阅-f选项。）有关详细信息，请参阅ssh-config（5）中Stdin Null的描述。

- `-O`    ctl_cmd

  Control an active connection multiplexing master process. When the      `-O` option is specified, the      ctl_cmd argument is interpreted and passed to the      master process. Valid commands are: “check” (check that the      master process is running), “forward” (request forwardings      without command execution), “cancel” (cancel forwardings),      “exit” (request the master to exit), and      “stop” (request the master to stop accepting further      multiplexing requests).      

  控制活动连接多路复用主进程。如果指定了-O选项，则会解释ctl-cmd参数并将其传递给主进程。有效命令包括：“check”（检查主进程是否正在运行）、“forward”（请求转发而不执行命令）、“cancel”（取消转发）、“exit”（请求主进程退出）和“stop”（请求主机停止接受更多的多路复用请求）。

- `-o`    option

  Can be used to give options in the format used in the configuration file.      This is useful for specifying options for which there is no separate      command-line flag. For full details of the options listed below, and their      possible values, see      [ssh_config(5)](https://man.openbsd.org/ssh_config.5).   

  可用于以配置文件中使用的格式提供选项。这对于指定没有单独命令行标志的选项非常有用。有关下面列出的选项及其可能值的详细信息，请参阅ssh-config（5）。

  * AddKeysToAgent
  * AddressFamily
  * BatchMode
  * BindAddress
  * CanonicalDomains
  * CanonicalizeFallbackLocal
  * CanonicalizeHostname
  * CanonicalizeMaxDots
  * CanonicalizePermittedCNAMEs
  * CASignatureAlgorithms
  * CertificateFile
  * CheckHostIP
  * Ciphers
  * ClearAllForwardings
  * Compression
  * ConnectionAttempts
  * ConnectTimeout
  * ControlMaster
  * ControlPath
  * ControlPersist
  * DynamicForward
  * EnableEscapeCommandline
  * EscapeChar
  * ExitOnForwardFailure
  * FingerprintHash
  * ForkAfterAuthentication
  * ForwardAgent
  * ForwardX11
  * ForwardX11Timeout
  * ForwardX11Trusted
  * GatewayPorts
  * GlobalKnownHostsFile
  * GSSAPIAuthentication
  * GSSAPIDelegateCredentials
  * HashKnownHosts
  * Host
  * HostbasedAcceptedAlgorithms
  * HostbasedAuthentication
  * HostKeyAlgorithms
  * HostKeyAlias
  * Hostname
  * IdentitiesOnly
  * IdentityAgent
  * IdentityFile
  * IPQoS
  * KbdInteractiveAuthentication
  * KbdInteractiveDevices
  * KexAlgorithms
  * KnownHostsCommand
  * LocalCommand
  * LocalForward
  * LogLevel
  * MACs
  * Match
  * NoHostAuthenticationForLocalhost
  * NumberOfPasswordPrompts
  * PasswordAuthentication
  * PermitLocalCommand
  * PermitRemoteOpen
  * PKCS11Provider
  * Port
  * PreferredAuthentications
  * ProxyCommand
  * ProxyJump
  * ProxyUseFdpass
  * PubkeyAcceptedAlgorithms
  * PubkeyAuthentication
  * RekeyLimit
  * RemoteCommand
  * RemoteForward
  * RequestTTY
  * RequiredRSASize
  * SendEnv
  * ServerAliveInterval
  * ServerAliveCountMax
  * SessionType
  * SetEnv
  * StdinNull
  * StreamLocalBindMask
  * StreamLocalBindUnlink
  * StrictHostKeyChecking
  * TCPKeepAlive
  * Tunnel
  * TunnelDevice
  * UpdateHostKeys
  * User
  * UserKnownHostsFile
  * VerifyHostKeyDNS
  * VisualHostKey
  * XAuthLocation                     

- `-p`    port

  Port to connect to on the remote host. This can be specified on a per-host      basis in the configuration file.    远程主机上要连接的端口。这可以在配置文件中按主机指定。  

- `-Q`    query_option

  Queries for the algorithms supported by one of the following features:      cipher (supported symmetric ciphers),      cipher-auth (supported symmetric ciphers that      support authenticated encryption), help (supported      query terms for use with the `-Q` flag),      mac (supported message integrity codes),      kex (key exchange algorithms),      key (key types), key-cert      (certificate key types), key-plain (non-certificate      key types), key-sig (all key types and signature      algorithms), protocol-version (supported SSH      protocol versions), and sig (supported signature      algorithms). Alternatively, any keyword from      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) or      [sshd_config(5)](https://man.openbsd.org/sshd_config.5) that takes an algorithm list may be used as an alias      for the corresponding query_option.      

  查询以下功能之一支持的算法：cipher（支持的对称密码）、cipher  auth（支持经过身份验证的加密的支持的对称加密）、help（支持与-Q标志一起使用的查询项）、mac（支持的消息完整性代码）、kex（密钥交换算法）、key（密钥类型）、key  cert（证书密钥类型），密钥平原（非证书密钥类型）、密钥sig（所有密钥类型和签名算法）、协议版本（支持的SSH协议版本）和sig（支持的签名算法）。或者，ssh-config（5）或sshd-config（5）中采用算法列表的任何关键字都可以用作相应查询选项的别名。

- `-q`

  Quiet mode. Causes most warning and diagnostic messages to be suppressed.      安静模式。导致大多数警告和诊断消息被抑制。

- `-R`    [bind_address:]port:host:hostport 

- `-R`    [bind_address:]port:local_socket

- `-R`    remote_socket:host:hostport

- `-R`    remote_socket:local_socket

- `-R`    [bind_address:]port

  Specifies that connections to the given TCP port or Unix socket on the      remote (server) host are to be forwarded to the local side.    This works by allocating a socket to listen to either a TCP        port or to a Unix socket on the remote side.        Whenever a connection is made to this port or Unix socket, the        connection is forwarded over the secure channel, and a connection is        made from the local machine to either an explicit destination specified        by host port hostport, or        local_socket, or, if no explicit destination was        specified, `ssh` will act as a SOCKS 4/5 proxy and        forward connections to the destinations requested by the remote SOCKS        client.    Port forwardings can also be specified in the configuration        file. Privileged ports can be forwarded only when logging in as root on        the remote machine. IPv6 addresses can be specified by enclosing the        address in square brackets.    By default, TCP listening sockets on the server will be bound        to the loopback interface only. This may be overridden by specifying a        bind_address. An empty        bind_address, or the address        ‘`*`’, indicates that the remote        socket should listen on all interfaces. Specifying a remote        bind_address will only succeed if the server's        `GatewayPorts` option is enabled (see        [sshd_config(5)](https://man.openbsd.org/sshd_config.5)).    If the port argument is        ‘`0`’, the listen port will be        dynamically allocated on the server and reported to the client at run        time. When used together with `-O forward`, the        allocated port will be printed to the standard output.     

  指定要将到远程（服务器）主机上给定TCP端口或Unix套接字的连接转发到本地端。

  这是通过分配一个套接字来监听远程端的TCP端口或Unix套接字来实现的。每当连接到此端口或Unix套接字时，该连接都会通过安全通道转发，并且从本地计算机连接到主机端口hostport或本地套接字指定的显式目标，或者如果未指定显式目标，ssh将充当SOCKS 4/5代理，并将连接转发到远程SOCKS客户端请求的目的地。

  也可以在配置文件中指定端口转发。只有以root用户身份登录远程计算机时，才能转发特权端口。IPv6地址可以通过将地址括在方括号中来指定。

  默认情况下，服务器上的TCP侦听套接字将仅绑定到环回接口。这可以通过指定绑定地址来覆盖。空绑定地址或地址“*”表示远程套接字应侦听所有接口。只有在启用服务器的网关端口选项时，指定远程绑定地址才会成功（请参阅sshd-config（5））。

  如果端口参数为“0”，则侦听端口将在服务器上动态分配，并在运行时报告给客户端。与-O forward一起使用时，分配的端口将打印到标准输出。

- `-S`    ctl_path

  Specifies the location of a control socket for connection sharing, or the      string “none” to disable connection sharing. Refer to the      description of `ControlPath` and      `ControlMaster` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.      指定用于连接共享的控制套接字的位置，或指定字符串“none”以禁用连接共享。有关详细信息，请参阅ssh-config（5）中对控制路径和控制主机的描述。

- `-s`

  May be used to request invocation of a subsystem on the remote system.      Subsystems facilitate the use of SSH as a secure transport for other      applications (e.g. [sftp(1)](https://man.openbsd.org/sftp.1)). The subsystem is specified as the remote command. Refer      to the description of `SessionType` in      [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for details.    可用于请求调用远程系统上的子系统。子系统便于将SSH用作其他应用程序（例如sftp（1））的安全传输。子系统被指定为远程命令。有关详细信息，请参阅ssh-config（5）中的会话类型描述。  

- `-T`

  Disable pseudo-terminal allocation.      禁用伪终端分配。

- `-t`

  Force pseudo-terminal allocation. This can be used to execute arbitrary      screen-based programs on a remote machine, which can be very useful, e.g.      when implementing menu services. Multiple `-t`      options force tty allocation, even if `ssh` has no      local tty.      强制伪终端分配。这可用于在远程机器上执行任意基于屏幕的程序，这非常有用，例如在实现菜单服务时。多个-t选项强制tty分配，即使ssh没有本地tty。

- `-V`

  Display the version number and exit.      显示版本号并退出。

- `-v`

  Verbose mode. Causes `ssh` to print debugging      messages about its progress. This is helpful in debugging connection,      authentication, and configuration problems. Multiple      `-v` options increase the verbosity. The maximum is      3.      详细模式。使ssh打印有关其进度的调试消息。这有助于调试连接、身份验证和配置问题。多个-v选项增加了冗长。最大值为3。

- `-W`    host:port

  Requests that standard input and output on the client be forwarded to      host on port over the secure      channel. Implies `-N`, `-T`,      `ExitOnForwardFailure` and      `ClearAllForwardings`, though these can be      overridden in the configuration file or using `-o`      command line options.      请求通过安全通道将客户端上的标准输入和输出转发到端口上的主机。意味着-N、-T、“转发失败时退出”和“清除所有转发”，尽管可以在配置文件中或使用-o命令行选项覆盖这些选项。

- `-w`    local_tun[:remote_tun]

  Requests tunnel device forwarding with the specified      [tun(4)](https://man.openbsd.org/tun.4) devices      between the client (local_tun) and the server      (remote_tun).    The devices may be specified by numerical ID or the keyword        “any”, which uses the next available tunnel device. If        remote_tun is not specified, it defaults to        “any”. See also the `Tunnel` and        `TunnelDevice` directives in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5).    If the `Tunnel` directive is unset, it        will be set to the default tunnel mode, which is        “point-to-point”. If a different        `Tunnel` forwarding mode it desired, then it        should be specified before `-w`.      

  请求在客户端（本地tun）和服务器（远程tun）之间使用指定的tun（4）个设备进行隧道设备转发。

  设备可以由数字ID或关键字“any”指定，该关键字使用下一个可用的隧道设备。如果未指定远程tun，则默认为“any”。另请参阅ssh-config（5）中的Tunnel和Tunnel Device指令。

  如果未设置Tunnel指令，它将设置为默认的隧道模式，即“点对点”。如果需要不同的隧道转发模式，则应在-w之前指定。

- `-X`

  Enables X11 forwarding. This can also be specified on a per-host basis in      a configuration file.    X11 forwarding should be enabled with caution. Users with the        ability to bypass file permissions on the remote host (for the user's X        authorization database) can access the local X11 display through the        forwarded connection. An attacker may then be able to perform activities        such as keystroke monitoring.    For this reason, X11 forwarding is subjected to X11 SECURITY        extension restrictions by default. Refer to the        `ssh` `-Y` option and the        `ForwardX11Trusted` directive in        [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.      

  启用X11转发。这也可以在配置文件中按主机指定。

  X11转发应谨慎启用。能够绕过远程主机（用户的X授权数据库）上的文件权限的用户可以通过转发的连接访问本地X11显示。然后，攻击者可以执行诸如击键监视之类的活动。

  因此，默认情况下，X11转发受到X11安全扩展限制。有关更多信息，请参阅ssh-Y选项和ssh-config（5）中的Forward X11Trusted指令。

- `-x`

  禁用 X11 转发。

- `-Y`

  Enables trusted X11 forwarding. Trusted X11 forwardings are not subjected      to the X11 SECURITY extension controls.      启用受信任的X11转发。受信任的X11转发不受X11安全扩展控制。

- `-y`

  Send log information using the      [syslog(3)](https://man.openbsd.org/syslog.3) system module. By default this information is sent to      stderr.使用syslog（3）系统模块发送日志信息。默认情况下，此信息将发送到stderr。

`ssh` may additionally obtain configuration    data from a per-user configuration file and a system-wide configuration    file. The file format and configuration options are described in    [ssh_config(5)](https://man.openbsd.org/ssh_config.5).

ssh还可以从每个用户的配置文件和系统范围的配置文件中获取配置数据。ssh-config（5）中描述了文件格式和配置选项。

## 身份验证

OpenSSH SSH 客户端支持 SSH 协议 2 。

可用于认证的方法有：基于 GSSAPI 的认证、基于主机的认证、公钥认证、键盘交互认证和密码认证。Authentication methods are tried in the order specified above, though    `PreferredAuthentications` can be used to change the    default order.虽然可以使用“首选身份验证”更改默认顺序，但可以按照上面指定的顺序尝试身份验证方法。

Host-based authentication works as follows: If the    machine the user logs in from is listed in    /etc/hosts.equiv or    /etc/shosts.equiv on the remote machine, the user is    non-root and the user names are the same on both sides, or if the files    ~/.rhosts or ~/.shosts exist    in the user's home directory on the remote machine and contain a line    containing the name of the client machine and the name of the user on that    machine, the user is considered for login. Additionally, the server    [*must*](https://man.openbsd.org/ssh#must) be able to    verify the client's host key (see the description of    /etc/ssh/ssh_known_hosts and    ~/.ssh/known_hosts, below) for login to be    permitted. This authentication method closes security holes due to IP    spoofing, DNS spoofing, and routing spoofing. [Note to the administrator:    /etc/hosts.equiv, ~/.rhosts,    and the rlogin/rsh protocol in general, are inherently insecure and should    be disabled if security is desired.]基于主机的身份验证工作方式如下：如果用户登录的计算机列在远程计算机上的/etc/hosts.equiv或/etc/shosts.equiv中，则该用户是非root用户，并且两侧的用户名相同，或者，如果文件~/.rhosts或~/.shosts存在于远程计算机上用户的主目录中，并且包含包含客户端计算机名称和该计算机上用户名称的行，则考虑用户登录。此外，服务器必须能够验证客户端的主机密钥（请参阅下面/etc/ssh/ssh已知主机和~/.ssh/已知主机的描述），才能允许登录。这种身份验证方法可以弥补IP欺骗、DNS欺骗和路由欺骗造成的安全漏洞。[管理员注意：/etc/hosts.equiv、~/.rhosts和rlogin/rsh协议一般都是不安全的，如果需要安全性，应该禁用。]

Public key authentication works as follows: The scheme is based on    public-key cryptography, using cryptosystems where encryption and decryption    are done using separate keys, and it is unfeasible to derive the decryption    key from the encryption key. The idea is that each user creates a    public/private key pair for authentication purposes. The server knows the    public key, and only the user knows the private key.    `ssh` implements public key authentication protocol    automatically, using one of the DSA, ECDSA, Ed25519 or RSA algorithms. The    HISTORY section of [ssl(8)](https://man.openbsd.org/ssl.8) contains a brief discussion of the DSA and RSA algorithms.

公钥认证的工作原理如下：该方案基于公钥密码学，使用使用单独密钥进行加密和解密的密码系统，从加密密钥导出解密密钥是不可行的。其思想是每个用户创建一个用于身份验证的公钥/私钥对。服务器知道公钥，只有用户知道私钥。ssh使用DSA、ECDSA、Ed25519或RSA算法之一自动实现公钥认证协议。ssl（8）的HISTORY部分简要讨论了DSA和RSA算法。

The file ~/.ssh/authorized_keys lists the    public keys that are permitted for logging in. When the user logs in, the    `ssh` program tells the server which key pair it would    like to use for authentication. The client proves that it has access to the    private key and the server checks that the corresponding public key is    authorized to accept the account.文件~/.ssh/authorized keys列出了允许登录的公钥。当用户登录时，ssh程序告诉服务器要使用哪个密钥对进行身份验证。客户端证明它可以访问私钥，服务器检查相应的公钥是否被授权接受帐户。

The server may inform the client of errors that prevented public    key authentication from succeeding after authentication completes using a    different method. These may be viewed by increasing the    `LogLevel` to `DEBUG` or higher    (e.g. by using the `-v` flag).在使用不同的方法完成认证之后，服务器可以向客户端通知阻止公钥认证成功的错误。可以通过将日志级别增加到DEBUG或更高（例如，使用-v标志）来查看这些日志。

The user creates their key pair by running    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1). This stores the private key in    ~/.ssh/id_dsa (DSA),    ~/.ssh/id_ecdsa (ECDSA),    ~/.ssh/id_ecdsa_sk (authenticator-hosted ECDSA),    ~/.ssh/id_ed25519 (Ed25519),    ~/.ssh/id_ed25519_sk (authenticator-hosted Ed25519),    or ~/.ssh/id_rsa (RSA) and stores the public key in    ~/.ssh/id_dsa.pub (DSA),    ~/.ssh/id_ecdsa.pub (ECDSA),    ~/.ssh/id_ecdsa_sk.pub (authenticator-hosted ECDSA),    ~/.ssh/id_ed25519.pub (Ed25519),    ~/.ssh/id_ed25519_sk.pub (authenticator-hosted    Ed25519), or ~/.ssh/id_rsa.pub (RSA) in the user's    home directory. The user should then copy the public key to    ~/.ssh/authorized_keys in their home directory on    the remote machine. The authorized_keys file    corresponds to the conventional ~/.rhosts file, and    has one key per line, though the lines can be very long. After this, the    user can log in without giving the password.用户通过运行ssh-keygen（1）创建密钥对。它将私钥存储在~/.ssh/id-dsa（dsa）、~/.sss/id-ecdsa（ecdsa）、~//.ssh/id ecdsa-sk（身份验证器托管ecdsa），~/.ssh/id ed25519（ed25519）、~/\.ssh/ided25519  sk（身份验证器托管ed25519）或~/.sssh/id rsa（rsa）中，并将公钥存储在~//.sss/id  dsa.pub（dsa），~//.ssh/id-ecdasa.pub/id ed25519.pub（ed25519），~/.ssh/id  ed25519 sk.pub（身份验证程序托管的ed25519）或~/.sss/id  rsa.pub（rsa），位于用户的主目录中。然后，用户应该将公钥复制到远程计算机上其主目录中的~/.ssh/授权密钥。授权密钥文件对应于传统的~/.rhosts文件，每行有一个密钥，尽管行可能很长。之后，用户可以登录，而不需要输入密码。

A variation on public key authentication is available in the form    of certificate authentication: instead of a set of public/private keys,    signed certificates are used. This has the advantage that a single trusted    certification authority can be used in place of many public/private keys.    See the CERTIFICATES section of    [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen.1) for more information.公钥身份验证的一种变体是证书身份验证：使用签名证书而不是一组公钥/私钥。这有一个优点，即可以使用单个可信证书颁发机构来代替许多公钥/私钥。有关更多信息，请参阅ssh-keygen（1）的CERTIFICATES部分。

The most convenient way to use public key or certificate    authentication may be with an authentication agent. See    [ssh-agent(1)](https://man.openbsd.org/ssh-agent.1) and (optionally) the    `AddKeysToAgent` directive in    [ssh_config(5)](https://man.openbsd.org/ssh_config.5) for more information.使用公钥或证书身份验证最方便的方法可能是使用身份验证代理。有关详细信息，请参阅ssh-agent（1）和（可选）ssh-config（5）中的AddKeysToAgent指令。

Keyboard-interactive authentication works as follows: The server    sends an arbitrary "challenge" text and prompts for a response,    possibly multiple times. Examples of keyboard-interactive authentication    include BSD Authentication (see    [login.conf(5)](https://man.openbsd.org/login.conf.5)) and PAM (some non-OpenBSD    systems).键盘交互身份验证的工作原理如下：服务器发送任意“挑战”文本并提示响应，可能多次。键盘交互身份验证的示例包括BSD身份验证（参见login.conf（5））和PAM（一些非开放BSD系统）。

Finally, if other authentication methods fail,    `ssh` prompts the user for a password. The password is    sent to the remote host for checking; however, since all communications are    encrypted, the password cannot be seen by someone listening on the  network.最后，如果其他身份验证方法失败，ssh会提示用户输入密码。密码被发送到远程主机进行检查；然而，由于所有通信都是加密的，所以在网络上收听的人无法看到密码。



`ssh` automatically maintains and checks a    database containing identification for all hosts it has ever been used with.    Host keys are stored in ~/.ssh/known_hosts in the    user's home directory. Additionally, the file    /etc/ssh/ssh_known_hosts is automatically checked    for known hosts. Any new hosts are automatically added to the user's file.    If a host's identification ever changes, `ssh` warns    about this and disables password authentication to prevent server spoofing    or man-in-the-middle attacks, which could otherwise be used to circumvent    the encryption. The `StrictHostKeyChecking` option can    be used to control logins to machines whose host key is not known or has    changed.

ssh会自动维护和检查一个数据库，该数据库包含它曾经使用过的所有主机的标识。主机密钥存储在用户主目录中的~/.ssh/已知主机中。此外，文件/etc/ssh/ssh已知主机会自动检查已知主机。任何新主机都会自动添加到用户的文件中。如果主机的标识发生变化，ssh会对此发出警告，并禁用密码验证，以防止服务器欺骗或中间人攻击，否则这些攻击可能被用来绕过加密。“严格主机密钥检查”选项可用于控制主机密钥未知或已更改的计算机的登录。

When the user's identity has been accepted by the server, the    server either executes the given command in a non-interactive session or, if    no command has been specified, logs into the machine and gives the user a    normal shell as an interactive session. All communication with the remote    command or shell will be automatically encrypted.当服务器接受了用户的身份时，服务器要么在非交互式会话中执行给定的命令，要么在未指定命令的情况下登录计算机，并向用户提供一个作为交互式会话的普通shell。与远程命令或shell的所有通信都将自动加密。

If an interactive session is requested,    `ssh` by default will only request a pseudo-terminal    (pty) for interactive sessions when the client has one. The flags    `-T` and `-t` can be used to    override this behaviour.如果请求了交互式会话，则默认情况下，ssh只会在客户端有一个虚拟终端（pty）时请求一个用于交互式会话的虚拟终端。标志-T和-T可用于覆盖此行为。

If a pseudo-terminal has been allocated, the user may use the    escape characters noted below.如果分配了伪终端，则用户可以使用以下转义字符。

If no pseudo-terminal has been allocated, the session is    transparent and can be used to reliably transfer binary data. On most    systems, setting the escape character to “none” will also make    the session transparent even if a tty is used.如果没有分配伪终端，则会话是透明的，可以用于可靠地传输二进制数据。在大多数系统上，将转义字符设置为“none”也会使会话透明，即使使用tty。

The session terminates when the command or shell on the remote    machine exits and all X11 and TCP connections have been closed.

当远程计算机上的命令或shell退出并且所有X11和TCP连接都已关闭时，会话终止。

## 作者

OpenSSH 是 Tatu Ylonen 的原始免费 ssh 1.2.12 版本的衍生产品。

Aaron Campbell、Bob Beck、Markus  Friedl、Niels Provos、Theo de Raadt 和 Dug Song 删除了许多错误，重新添加了新功能并创建了  OpenSSH 。Markus Friedl 为 SSH 协议版本 1.5 和 2.0 提供了支持。