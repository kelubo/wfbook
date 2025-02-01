# Frequently Asked Questions 常见问题

#### General 一般

- [Why is the project called Node-RED?
  为什么这个项目叫Node-RED？](https://nodered.org/about/#history)
- [What is the history of the project?
  该项目的历史是什么？](https://nodered.org/about/#history)
- [What is ‘Flow-based Programming’
  什么是“基于流程的编程”](https://nodered.org/about/#flow-based-programming)

#### Node.js

- [What versions of Node.js are supported?
  支持哪些版本的Node.js？](https://nodered.org/docs/faq/node-versions)

# Supported Node versions 支持的节点版本

*Updated: 2024-01-03 2024-01-03 -03 - 04*

Node-RED currently recommends **Node 20.x**.
Node-RED目前推荐使用**Node 20.x**。

We try to stay up to date with Node.js releases. Our goal is to support the [Maintenance and Active LTS releases](https://nodejs.org/en/about/releases/).
我们试图保持与Node.js版本同步。我们的目标是支持[维护和活动LTS版本](https://nodejs.org/en/about/releases/)。

We do not recommend using the odd numbered Node.js versions - we do not routinely test against them.
我们不建议使用奇数编号的Node.js版本-我们不会对它们进行常规测试。

| Node-RED Version Node-RED版本 | Minimum Node.js Version 最低Node.js版本 |
| ----------------------------- | --------------------------------------- |
| 4.x                           | 18                                      |
| 3.x                           | 14                                      |
| 2.x                           | 12                                      |

With such a large community of 3rd party nodes available to install, we cannot provide any guarantees on what they support. We rely on the community to keep up to date.
由于有如此庞大的第三方节点社区可供安装，我们无法保证它们支持什么。我们依靠社区来跟上时代。

### Installing Node.js 安装Node.js

Node [provides guides](https://nodejs.org/en/download/package-manager/) for installing Node.js across a wide range of Operating Systems.
Node[提供](https://nodejs.org/en/download/package-manager/)了在各种操作系统上安装Node.js的指南。

If you are running on a [Raspberry Pi](https://nodered.org/docs/hardware/raspberrypi) or [BeagleBone Black](https://nodered.org/docs/hardware/beagleboneblack), please read the guides we provide for those devices.
如果您运行的是[Raspberry Pi](https://nodered.org/docs/hardware/raspberrypi)或 [BeagleBone Black](https://nodered.org/docs/hardware/beagleboneblack)，请阅读我们为这些设备提供的指南。

### Using `nvm` 使用`nvm`

[nvm](https://github.com/nvm-sh/nvm/blob/master/README.md) is a tool that can help manage Node.js installations.
[nvm](https://github.com/nvm-sh/nvm/blob/master/README.md)是一个可以帮助管理Node.js安装的工具。

It is convenient when running Node-RED as an individual user, but it is *not* recommended if you want to run Node-RED as a system-level service. This is because `nvm` uses scripts in a user’s profile to setup its environment. When running as a service, those scripts do not get used.
当作为个人用户运行Node-RED时，这很方便，但事实*并非如此* 如果要将Node-RED作为系统级服务运行，建议使用。这是因为 `NVM`使用用户配置文件中的脚本来设置其环境。当作为服务运行时，这些脚本不会被使用。

### Upgrading Node.js 升级Node.js

If you change the version of Node.js you are using, you may need to rebuild Node-RED’s dependencies as well as any nodes you have installed. This is because some of them contain binary components that must be rebuilt to be compatible with the new Node.js version.
如果您更改了正在使用的Node.js版本，则可能需要重新构建Node-RED的依赖项以及已安装的任何节点。这是因为它们中的一些包含二进制组件，必须重新构建才能与新的Node.js版本兼容。

This can be done using the command `npm rebuild` - but it must be run in the right directory.
这可以使用命令`npm rebuild来`完成-但它必须在正确的目录中运行。

There are two places it should be run:
有两个地方应该运行：

1. In your Node-RED user directory, `~/.node-red` - this is where any additional nodes you have installed are.
   在您的Node-RED用户目录中，`~/.node-red`-这是您安装的任何其他节点所在的位置。
2. In the directory you installed Node-RED
   在安装Node-RED的目录中

If you installed Node-RED as a global module and are not sure where that put it, you can use the command `npm list -g --depth 0` to find where your global modules are installed.
如果您将Node-RED安装为全局模块，并且不确定将其放置在何处，则可以使用命令`npm list -g --depth`0查找全局模块的安装位置。

#### Node-RED

- [How can I start Node-RED on boot?
  如何在靴子时启动Node-RED？](https://nodered.org/docs/faq/starting-node-red-on-boot)

# Starting Node-RED on boot 在靴子时启动Node-RED

There are many methods of starting, stopping and monitoring applications at boot time. This guide highlights some of the possible ways of doing it.
有许多方法可以在靴子时启动、停止和监视应用程序。本指南强调了一些可能的方法。

### Raspberry Pi, Debian, Ubuntu 树莓派，Debian，Ubuntu

The [Raspberry Pi install script](https://nodered.org/docs/getting-started/raspberrypi) we provide can be used on any Debian-like operating system.
我们提供的[Raspberry Pi安装脚本](https://nodered.org/docs/getting-started/raspberrypi)可以在任何类似Debian的操作系统上使用。

This script installs Node-RED as a [systemd](https://wiki.debian.org/systemd) service. For more information, read the [Running on Raspberry Pi](https://nodered.org/docs/getting-started/raspberrypi#autostart-on-boot) guide.
此脚本将Node-RED安装为[systemd](https://wiki.debian.org/systemd)服务。有关更多信息，请阅读[在Raspberry Pi上运行](https://nodered.org/docs/getting-started/raspberrypi#autostart-on-boot) 为着力

If you are not using Raspberry Pi OS, you may need to edit the service file to suit your local user id and environment. Details for how to do that are available [here](https://nodered.org/docs/faq/customising-systemd-on-pi).
如果您没有使用Raspberry Pi OS，则可能需要编辑服务文件以适应 本地用户ID和环境。有关如何做到这一点的详细信息， [这里](https://nodered.org/docs/faq/customising-systemd-on-pi).

### RPM based Linux, RedHat, Fedora, CentOS 基于RPM的Linux、RedHat、Fedora、CentOS

We also provide an install script for RPM based linux [available here](https://github.com/node-red/linux-installers), that also sets up systemd.
我们还提供了一个基于RPM的Linux的安装脚本，它也设置了systemd。

### Other Linux, OSX 其他Linux、OSX

The guide below sets out what we believe to be the most straight-forward for the majority of users. For Windows, PM2 does not autorun as a service - you may prefer the [NSSM option](https://nodered.org/docs/faq/starting-node-red-on-boot#alternative-options) below.
下面的指南列出了我们认为对大多数用户来说最简单的方法。对于Windows，PM2不会作为服务自动运行-您可能更喜欢下面的[NSSM选项](https://nodered.org/docs/faq/starting-node-red-on-boot#alternative-options)。

#### Using PM2 使用PM2

[PM2](https://github.com/Unitech/pm2) is a process manager for Node.js. It makes it easy to run applications on boot and ensure they are restarted if necessary.
[PM2](https://github.com/Unitech/pm2)是Node.js的进程管理器。它可以很容易地在靴子时运行应用程序，并确保在必要时重新启动它们。

#### 1. Install PM2 1.安装PM2

```
sudo npm install -g pm2
```

*Note* : `sudo` is required if running as a non-root user on Linux or OS X. If running on Windows, you will need to run in a [command shell as Administrator](https://technet.microsoft.com/en-gb/library/cc947813(v=ws.10).aspx), without the `sudo` command. 
*注意*：如果在Linux或OS X上以非root用户身份运行，则需要`sudo`。如果在Windows上运行，则需要[以管理员身份在命令shell](https://technet.microsoft.com/en-gb/library/cc947813(v=ws.10).aspx)中运行，而不使用`sudo`命令。

If running on Windows, you should also ensure `tail.exe` is on your path, as described [here](https://github.com/Unitech/PM2/blob/development/ADVANCED_README.md#windows). 
如果在Windows上运行，您还应该确保`tail.exe`在您的路径上，如[此处所](https://github.com/Unitech/PM2/blob/development/ADVANCED_README.md#windows)述。

#### 2. Determine the exact location of the `node-red` command. 2.确定`node-red`命令的确切位置。

If you have done a global install of node-red, then on Linux/OS X the `node-red` command will probably be either: `/usr/bin/node-red` or `/usr/local/bin/node-red`. The command `which node-red` can be used to confirm the location.
如果您已经完成了node-red的全局安装，那么在Linux/OS X上`，` 命令可能是：`/usr/bin/node-red`或`/usr/local/bin/node-red`。`node-red`可以用来确认位置的命令。

If you have done a local install, it will be `node_modules/node-red/bin/node-red`, relative to where you ran `npm install` from.
如果你已经完成了本地安装，它将是 `node_modules/node-red/bin/node-red` ，相对于你运行`npm install`的位置。

#### 3. Tell PM2 to run Node-RED 3.告诉PM2运行Node-RED

The following command tells PM2 to run Node-RED, assuming `/usr/bin/node-red` as the location of the `node-red` command.
下面的命令告诉PM2运行Node-RED，假设`/usr/bin/node-red`是`node-red`命令的位置。

The `--` argument must appear before any arguments you want to pass to node-red.
-`-` 参数必须出现在任何要传递给node-red的参数之前。

```
pm2 start /usr/bin/node-red -- -v
```

*Note* : if you are running on a device like the Raspberry Pi or BeagleBone Black that have a constrained amount of memory, you must pass an additional argument: 
*注意*：如果您在Raspberry Pi或BeagleBone等设备上运行 黑色的，内存量有限，你必须传递一个额外的参数：

```
pm2 start /usr/bin/node-red --node-args="--max-old-space-size=128" -- -v
```

*Note* : if you want to run as the root user, you must use the `--userDir` option to specify where Node-RED should store your data. 
*注意*：如果你想以root用户的身份运行，你必须使用`--userDir`选项来指定Node-RED应该在哪里存储你的数据。

This will start Node-RED in the background. You can view information about the process and access the log output using the commands:
这将在后台启动Node-RED。您可以使用以下命令查看有关进程的信息并访问日志输出：

```
pm2 info node-red
pm2 logs node-red
```

More information about managing processes under PM2 is available [here](https://github.com/Unitech/pm2#process-management).
有关在PM2下管理流程的更多信息，请访问[此处](https://github.com/Unitech/pm2#process-management)。

#### 4. Tell PM2 to run on boot 4.告诉PM 2在靴子时运行

PM2 is able to generate and configure a startup script suitable for the platform it is being run on.
PM2能够生成和配置适合于其运行平台的启动脚本。

Run these commands and follow the instructions it provides:
运行这些命令并按照它提供的说明进行操作：

```
pm2 save
pm2 startup
```

for newer Linux systems that use **systemd** use
对于使用**systemd**的较新Linux系统，请使用

```
pm2 startup systemd
```

*Temporary Note:* There's an [ open issue](https://github.com/Unitech/PM2/issues/1321) on PM2 on GitHub which highlights an issue that has been introduced recently. Linux users need to manually edit the generated `/etc/init.d/pm2-init.sh` file and replace

```
export PM2_HOME="/root/.pm2"
```

to point at the correct directory, which would be like: 
*临时说明：*GitHub上有一个关于PM2[的公开问题](https://github.com/Unitech/PM2/issues/1321)，它突出了最近引入的一个问题。 Linux用户需要手动编辑生成的`/etc/init.d/pm2-init.sh`文件并替换  指向正确的目录，如下所示：

```
export PM2_HOME="/home/{youruser}/.pm2"
```

#### 5. Reboot 5.重新启动

Finally, reboot and check everything starts as expected.
最后，重新启动并检查一切是否按预期启动。

### Windows

PM2 does not autorun as a service on Windows. An alternative option is to use NSSM, an example of which is available from the community link below.
PM2不会在Windows上作为服务自动运行。另一种选择是使用NSSM，下面的社区链接提供了一个示例。

### Alternative options 替代选项

There are many alternative approaches. The following are some of those created by members of the community.
有许多替代方法。下面是一些由社区成员创建的。

- [A systemd script (used by the Pi pre-install)](https://raw.githubusercontent.com/node-red/linux-installers/master/resources/nodered.service) by @NodeRED (linux)
  @NodeRED（Linux）提供[的systemd脚本（由Pi预安装使用）](https://raw.githubusercontent.com/node-red/linux-installers/master/resources/nodered.service)
- [A systemd script](https://gist.github.com/Belphemur/3f6d3bf211b0e8a18d93) by Belphemur (linux)
  由Belphemur（Linux）开发[的systemd脚本](https://gist.github.com/Belphemur/3f6d3bf211b0e8a18d93)
- [An init.d script](https://gist.github.com/bigmonkeyboy/9962293)  by dceejay (linux)
  由dceejay编写[的init.d脚本](https://gist.github.com/bigmonkeyboy/9962293)（Linux）
- [An init.d script](https://gist.github.com/Belphemur/cf91100f81f2b37b3e94) by Belphemur (linux)
  [一个由Belphemur编写的init.d脚本](https://gist.github.com/Belphemur/cf91100f81f2b37b3e94)（Linux）
- [A Launchd script](https://gist.github.com/natcl/4688162920f368707613) by natcl (OS X)
  由natcl（OS X）[提供的Launchd脚本](https://gist.github.com/natcl/4688162920f368707613)
- [Running as a Windows service using NSSM](https://gist.github.com/dceejay/576b4847f0a17dc066db) by dceejay
  通过dceejay[使用NSSM作为Windows服务运行](https://gist.github.com/dceejay/576b4847f0a17dc066db)
- [Running as Windows/OS X service](http://www.hardill.me.uk/wordpress/2014/05/30/running-node-red-as-a-windows-or-osx-service/)  by Ben Hardill
  [作为Windows/OS X服务运行](http://www.hardill.me.uk/wordpress/2014/05/30/running-node-red-as-a-windows-or-osx-service/)，由Ben Hardill提供
- [An rc.d script](https://gist.github.com/apearson/56a2cd137099dbeaf6683ef99aa43ce0) by apearson (freebsd)
  由apearson编写[的rc.d脚本](https://gist.github.com/apearson/56a2cd137099dbeaf6683ef99aa43ce0)（freebsd）。

#### Raspberry Pi

- [How do I interact with Raspberry Pi GPIO?
  如何与Raspberry Pi GPIO交互？](https://nodered.org/docs/faq/interacting-with-pi-gpio)
- [How can I customise the Raspberry Pi service?
  如何定制Raspberry Pi服务？](https://nodered.org/docs/faq/customising-systemd-on-pi)

# Interacting with Raspberry Pi GPIO 与Raspberry Pi GPIO交互

There are a few node modules available for interacting with the Pi’s GPIO pins.
有几个节点模块可用于与Pi的GPIO引脚进行交互。

### node-red-node-pi-gpio

This module is preinstalled with Node-RED when using our install script. It provides a simple way to monitor and control the GPIO pins.
在使用我们的安装脚本时，此模块会与Node-RED一起预安装。它提供了一种简单的方法来监视和控制GPIO引脚。

Raspberry Pi OS comes preconfigured for this node to work. If you are running a different distribution, such as Ubuntu, some additional install steps may be needed. The node's README [has the details](https://github.com/node-red/node-red-nodes/tree/master/hardware/PiGpio#install). 
Raspberry Pi OS已预先配置此节点才能工作。如果您运行的是不同的发行版，例如Ubuntu，则可能需要一些额外的安装步骤。节点的README[中有详细信息](https://github.com/node-red/node-red-nodes/tree/master/hardware/PiGpio#install)。

### node-red-node-pi-gpiod

This module uses the [PiGPIOd](http://abyz.me.uk/rpi/pigpio/pigpiod.html) daemon which offers some more features over the default nodes. For example, the node can be easily configured to do PWM output or drive a Servo.
此模块使用[PiGPIOd](http://abyz.me.uk/rpi/pigpio/pigpiod.html)守护进程，该守护进程提供了比默认节点更多的功能。例如，该节点可以很容易地配置为PWM输出或驱动伺服。

The module is available [here](https://flows.nodered.org/node/node-red-node-pi-gpiod).
该模块在[这里](https://flows.nodered.org/node/node-red-node-pi-gpiod)可用。

### node-red-contrib-gpio

This modules supports GPIO across a wide range of device types, using the [Johnny-Five](https://github.com/rwaldron/johnny-five) library.
此模块支持各种设备类型的GPIO，使用 [强尼五](https://github.com/rwaldron/johnny-five)号图书馆

The module is available [here](https://flows.nodered.org/node/node-red-contrib-gpio).
该模块在[这里](https://flows.nodered.org/node/node-red-contrib-gpio)可用。

# Customising the Raspberry Pi service 自定义Raspberry Pi服务

When running on the Raspberry Pi or other Debian-based Linux system, our [install script](https://nodered.org/docs/hardware/raspberrypi) can be used to setup a systemd service to autostart Node-RED on boot.
在Raspberry Pi或其他基于Debian的Linux系统上运行时， [安装脚本](https://nodered.org/docs/hardware/raspberrypi)可用于设置systemd服务，以便在靴子时自动启动Node-RED。

This guide shows how the service can be customised for some common scenarios.
本指南展示了如何针对一些常见场景定制服务。

### Changing the user 改变用户

The service comes configured for the `pi` user. To change which user it runs as, edit the service definition `/lib/systemd/system/nodered.service` and change the `User`, `Group` and `WorkingDirectory` lines as appropriate. You can also set the  amount of memory space to use in MB.
该服务是为`pi`用户配置的。要更改它作为哪个用户运行，请编辑服务定义 `/lib/systemd/system/nodered.service` 并更改 `用户`、`组`和`工作目录`行（如果适用）。您还可以设置要使用的内存空间量（MB）。

```
[Service]
Type=simple
# Run as normal pi user - change to the user name you wish to run Node-RED as
User=<your_user>
Group=<your_user>
WorkingDirectory=/home/<your_user>

Environment="NODE_OPTIONS=--max_old_space_size=256"
...
```

After editing the file, run the following commands to reload the systemd daemon and then restart the Node-RED service.
编辑文件后，运行以下命令以重新加载systemd守护程序，然后重新启动Node-RED服务。

```
sudo systemctl daemon-reload
node-red-stop
node-red-start
```

### Configuring an HTTP proxy 配置HTTP代理

If you need to use a proxy for http requests within your Node-RED flows, you need to set the `HTTP_PROXY` environment variable.
如果您需要在Node-RED流中为http请求使用代理，则需要设置`HTTP_PROXY`环境变量。

Edit the service definition `/lib/systemd/system/nodered.service` and add another `Environment=...` line. For example:
编辑服务定义 `/lib/systemd/system/nodered.service` 并添加另一个`Environment=... `线举例来说：

```
...
Nice=5
Environment="NODE_OPTIONS=--max-old-space-size=256"
Environment="HTTP_PROXY=my-proxy-server-address"
...
```

After editing the file, run the following commands to reload the systemd daemon and then restart the Node-RED service.
编辑文件后，运行以下命令以重新加载systemd守护程序，然后重新启动Node-RED服务。

```
sudo systemctl daemon-reload
node-red-stop
node-red-start
```

#### Hardware 硬件

- [How can I interact with Arduino devices?
  如何与Arduino设备交互？](https://nodered.org/docs/faq/interacting-with-arduino)

# Interacting with Arduino 与Arduino互动

There are several ways to interact with an Arduino using Node-RED. They all assume the Arduino is connected to the host computer via a USB serial connection.
有几种方法可以使用Node-RED与Arduino进行交互。他们都假设Arduino通过USB串行连接连接到主机。

*Note:* you can’t use both the Arduino IDE and the Arduino nodes at the same time as they will conflict. You will need to stop Node-RED running if you wish re-program the Arduino from the IDE.
*注意：*您不能同时使用Arduino IDE和Arduino节点，因为它们会发生冲突。如果您希望从IDE重新编程Arduino，则需要停止Node-RED运行。

### Arduino Cloud Arduino云

[Arduino Cloud](https://cloud.arduino.cc) allows to interact with Arduino boards registered as Internet-Of-Things devices.  Nodes are available to be installed in the palette to easily poll data  from IoT devices, or receive real-time notifications (see  https://flows.nodered.org/node/@arduino/node-red-contrib-arduino-iot-cloud for details and installation).
[Arduino Cloud](https://cloud.arduino.cc)允许与注册为物联网设备的Arduino板进行交互。节点可安装在调色板中，以轻松轮询来自物联网设备的数据，或接收实时通知（有关详细信息和安装，请参阅https://flows.nodered.org/node/@arduino/node-red-contrib-arduino-iot-cloud）。

### Serial 串行

As the Arduino appears as a Serial device, the Serial in/out nodes can be used to communicate with it.
由于Arduino显示为串行设备，因此可以使用串行输入/输出节点与它通信。

This is normally the case if you program the Arduino with the IDE, as you can then send and receive input over the serial port to interact with your creation. Just make sure you set the serial port speed (baud rate) to be the same at both ends.
如果您使用IDE对Arduino进行编程，则通常会出现这种情况，因为您可以通过串行端口发送和接收输入以与您的创作进行交互。只要确保您设置的串行端口速度（波特率）在两端相同。

### Firmata 菲尔马塔

[Firmata](http://firmata.org/) is a protocol for communicating between an Arduino (as well as other microcontrollers) and the host computer, providing direct access to the IO pins.
[Firmata](http://firmata.org/)是一种用于Arduino（以及其他微控制器）和主机之间通信的协议，提供对IO引脚的直接访问。

#### Installation 安装

First you need to load the default Firmata sketch onto the Arduino using the standard Arduino software download tools. This is usually found in the Arduino IDE under the menu:
首先，您需要使用标准的Arduino软件下载工具将默认的Firmata草图加载到Arduino上。这通常可以在Arduino IDE的菜单下找到：

```
    Files - Examples - Firmata - Standard Firmata
```

You then need to install the Node-RED Arduino nodes into the palette.
然后，您需要将Node-RED Arduino节点安装到调色板中。

Please check that `npm -v` is at least version 2.x - if not - update it using         sudo npm i -g npm@latest        hash -r 
请检查`npm -v`是否至少是2.x版本-如果不是-使用sudo npm i -g npm@latest hash -r更新它

Change directory to your Node-RED user directory, this is normally `~/.node-red`
将目录更改为Node-RED用户目录，通常为`~/.node-red`

```
    cd ~/.node-red
```

Then install the Arduino nodes
然后安装Arduino节点

```
    npm install node-red-node-arduino
```

Finally restart Node-RED, and reload the editor in the browser. There should now be two new Arduino nodes in the palette.
最后重启Node-RED，并在浏览器中重新加载编辑器。调色板中现在应该有两个新的Arduino节点。

#### Blink 眨眼

To run a “blink” flow that uses LED 13, copy the following flow and paste it into the Import Nodes dialog (*Import From - Clipboard* in the dropdown menu, or Ctrl-i, Ctrl-v). After clicking okay, click in the workspace to place the new nodes.
要运行使用LED 13的“闪烁”流，请复制以下流并将其粘贴到“导入节点”对话框中（*“导入自*”菜单中的-“从”，或Ctrl-i、Ctrl-v）。单击OK后，在工作区中单击以放置新节点。

```
[{"id":"d7663aaf.47194","type":"arduino-board","device":""},{"id":"dae8234f.2517e","type":"inject","name":"0.5s tick","topic":"","payload":"","payloadType":"date","repeat":"0.5","crontab":"","once":false,"x":150,"y":100,"z":"359a4b52.ca65b4","wires":[["56a6f8f2.a95908"]]},{"id":"2db61802.d249e8","type":"arduino out","name":"","pin":"13","state":"OUTPUT","arduino":"d7663aaf.47194","x":570.5,"y":100,"z":"359a4b52.ca65b4","wires":[]},{"id":"56a6f8f2.a95908","type":"function","name":"Toggle output on input","func":"\n// If it does exist make it the inverse of what it was or else initialise it to false\n// (context variables persist between calls to the function)\ncontext.level = !context.level || false;\n\n// set the payload to the level and return\nmsg.payload = context.level;\nreturn msg;","outputs":1,"noerr":0,"x":358,"y":100,"z":"359a4b52.ca65b4","wires":[["2db61802.d249e8"]]}]
```

This flow is set to automatically try to detect the board on a a serial port. If you need to change that, double click the node labelled `Pin 13` - the Arduino node. Click the pencil icon and change the port definition as needed.
此流程设置为自动尝试检测串行端口上的板。如果需要更改，请双击标记为`Pin 13`的节点-Arduino节点。单击铅笔图标并根据需要更改端口定义。

Click the deploy button and the flow should start running. LED 13 should start toggling on and off once a second.
单击deploy按钮，流应该开始运行。LED 13应开始每秒切换一次。

#### Capabilities 能力

The Arduino output node currently supports three modes of operation:
Arduino输出节点目前支持三种操作模式：

- Digital - 0 or 1
  数字- 0或1
- Analogue - 0 to 255
  安东- 0至255
- Servo - 0 to 180
  伺服- 0至180

The Arduino input node, available in the palette but not used in this example, can support both Digital and Analog pins. The input will send a message whenever it detects a change. This may be okay for digital inputs as they tend to be fairly stable, but analog readings often end up being at the full sample rate (default: 40 times a second…). This can be changed in the configuration of the serial port to reduce it to a more manageable rate.
Arduino输入节点，在调色板中可用，但在本示例中未使用，可以支持数字和模拟引脚。每当检测到更改时，输入将发送一条消息。这对于数字输入可能没问题，因为它们往往相当稳定，但模拟读数通常最终以全采样率（默认值：每秒40次）结束。这可以在串行端口的配置中进行更改，以将其降低到更易于管理的速率。

Details of the Node.js arduino-firmata library can be found [here](https://www.npmjs.com/package/arduino-firmata).
Node.js Arduino-firmata库的详细信息可以在[这里](https://www.npmjs.com/package/arduino-firmata)找到。

------

### Johnny-Five

You may also use the popular [Johnny-Five](https://www.npmjs.com/package/johnny-five) library as this adds capabilities like I2C.
你也可以使用流行的[约翰尼五](https://www.npmjs.com/package/johnny-five) 库，因为这增加了像I2C这样的功能。

One way to use it is via Luis Montes’ [node-red-contrib-gpio](https://www.npmjs.com/package/node-red-contrib-gpio) node, which also adds support for a number of other boards, such as Raspberry Pi, BeagleBone Black, Galileo/Edison, Blend Micro, LightBlue Bean, Electric Imp and Spark Core, in a consistent manner.
一种使用方法是通过路易斯·蒙特斯的 [node-red-contrib-gpio](https://www.npmjs.com/package/node-red-contrib-gpio) 节点，它还增加了对许多其他板的支持，例如 树莓派，BeagleBone Black，Galileo/Edison，Blend Micro，LightBlue Bean， 电脉冲和火花核心，在一个一致的方式。

Another way is to make it available within functions. This can be achieved by editing the globalContextSettings sections of settings.js to be
另一种方法是使其在函数中可用。这可以通过将settings.js的globalContextSettings部分编辑为

```
functionGlobalContext: {
   jfive:require("johnny-five"),                        // this is the reference to the library
   j5board:require("johnny-five").Board({repl:false})   // this actually starts the board link...
},
```

We start the board link here so that multiple functions within the workspace can use it, though you should be careful to only access each pin once.
我们在这里启动电路板链接，以便工作区中的多个函数可以使用它，但您应该注意每个引脚只访问一次。

Finally install the npm from within your Node-RED home directory
最后，从Node-RED主目录中安装npm

```
cd ~/.node-red
npm install johnny-five
```

and then you may access all the [richness](https://github.com/rwaldron/johnny-five/wiki) of Johnny-Five from within functions…
然后你就可以接触[到](https://github.com/rwaldron/johnny-five/wiki) 约翰尼五号的内部信息

```
var five = context.global.jfive;    // create a shorter alias
var led = new five.Led(13);         // instantiate the led
led.blink(500);                     // blink it every 500 ms
```

*Note:* this is a simple, but poor example as the led pin is created each time the function is called… so only ok if you only deploy it and call it once.
*注意：*这是一个简单但不好的例子，因为每次调用函数时都会创建led引脚.

#### Blink 2 眨眼2

The flow below shows a more advanced example that turns on and off a flashing led, and shows the use of context to hold the state and a single instance of the led pin.
下面的流程显示了一个更高级的示例，它打开和关闭闪烁的led，并显示了使用上下文来保存状态和led引脚的单个实例。

It can be imported to the workspace by using `ctrl-c (copy) / ctrl-i (import) / ctrl-v (paste)`.
可以使用 `ctrl-c (copy) / ctrl-i (import) / ctrl-v (paste)` 将其导入到工作区。

```
[{"id":"62f58834.9d0a78","type":"inject","name":"","topic":"","payload":"1","payloadType":"string","repeat":"","crontab":"","once":false,"x":226,"y":326,"z":"359a4b52.ca65b4","wires":[["ae84ad08.517b5"]]},{"id":"ae84ad08.517b5","type":"function","name":"1 = start flash, 0 = stop","func":"var five = context.global.jfive;\ncontext.led = context.led || new five.Led(13);\ncontext.switch = context.switch || 0;\ncontext.switch = msg.payload;\nconsole.log(typeof(context.switch));\nif (context.switch == 1) {\n    context.led.blink(500);\n}\nif (context.switch == 0) {\n    context.led.stop().off();\n}\nreturn msg;","outputs":1,"noerr":0,"x":447,"y":349,"z":"359a4b52.ca65b4","wires":[["df638a80.209c78"]]},{"id":"df638a80.209c78","type":"debug","name":"","active":true,"console":"false","complete":"false","x":645,"y":349,"z":"359a4b52.ca65b4","wires":[]},{"id":"d79bc51d.286438","type":"inject","name":"","topic":"","payload":"0","payloadType":"string","repeat":"","crontab":"","once":false,"x":224.4000244140625,"y":364.60003662109375,"z":"359a4b52.ca65b4","wires":[["ae84ad08.517b5"]]}]
```