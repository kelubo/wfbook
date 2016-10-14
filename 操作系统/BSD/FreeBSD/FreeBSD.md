# FreeBSD

## 更新与升级

### 配置文件

路径为：`/etc/freebsd-update.conf`

    # Components of the base system which should be kept updated.
    Components src world kernel

控制 FreeBSD 的哪一部分将被保持更新。 默认的是更新源代码，整个基本系统还有内核。

    # Paths which start with anything matching an entry in an IgnorePaths
    # statement will be ignored.
    IgnorePaths

添加路径，比如 /bin 或者 /sbin 让这些指定的目录在更新过程中不被修改。

    # Paths which start with anything matching an entry in an UpdateIfUnmodified
    # statement will only be updated if the contents of the file have not been
    # modified by the user (unless changes are merged; see below).
    UpdateIfUnmodified /etc/ /var/ /root/ /.cshrc /.profile

更新指定目录中的未被修改的配置文件。 用户的任何修改都会使这些文件的自动更新失效。 还有另外一个选项， KeepModifiedMetadata， 这个能让 freebsd-update 在合并时保存修改。

    # When upgrading to a new FreeBSD release, files which match MergeChanges
    # will have any local changes merged into the version from the new release.
    MergeChanges /etc/ /var/named/etc/

一个 freebsd-update 应该尝试合并的配置文件的列表。

    # Directory in which to store downloaded updates and temporary
    # files used by FreeBSD Update.
    # WorkDir /var/db/freebsd-update

这个目录是放置所有补丁和临时文件的。 确认此处至少有 1 GB 的可用磁盘空间。

    # When upgrading between releases, should the list of Components be
    # read strictly (StrictComponents yes) or merely as a list of components
    # which *might* be installed of which FreeBSD Update should figure out
    # which actually are installed and upgrade those (StrictComponents no)?
    # StrictComponents no

当设置成 yes 时， freebsd-update 将假设这个 Components 列表时完整的， 并且对此列表以外的项目不会修改。实际上就是 freebsd-update 会尝试更新 Componets 列表里的每一个文件。
25.2.2. 安全补丁

安全补丁存储在远程的机器上， 可以使用如下的命令下载并安装：

# freebsd-update fetch
# freebsd-update install

如果给内核打了补丁，那么系统需要重新启动。 如果一切都进展顺利，系统就应该被打好了补丁而且 freebsd-update 可由夜间 cron(8) 执行。在 /etc/crontab 中加入以下条目足以完成这项任务：

@daily                                  root    freebsd-update cron

这条记录是说明每天运行一次 freebsd-update 工具。 用这种方法， 使用了 cron 参数， freebsd-update 仅检查是否存在更新。 如果有了新的补丁，就会自动下载到本地的磁盘， 但不会自动给系统打上。root 会收到一封电子邮件告知需手动安装补丁。

如果出现了错误，可以使用下面的 freebsd-update 命令回退到上一次的修改：

# freebsd-update rollback

完成以后如果内核或任何的内核模块被修改的话， 就需要重新启动系统。这将使 FreeBSD 装载新的二进制程序进内存。

freebsd-update 工具只能自动更新 GENERIC 内核。 如果您使用自行联编的内核， 则在 freebsd-update 安装完更新的其余部分之后需要手工重新联编和安装内核。 不过， freebsd-update 会检测并更新位于 /boot/GENERIC (如果存在) 中的 GENERIC 内核， 即使它不是当前 (正在运行的) 系统的内核。
注意:

保存一份 GENERIC 内核的副本到 /boot/GENERIC 是一个明智的主意。 在诊断许多问题， 以及在 第 25.2.3 节 “重大和次要的更新” 中介绍的使用 freebsd-update 更新系统时会很有用。

除非修改位于 /etc/freebsd-update.conf 中的配置， freebsd-update 会随其他安装一起对内核的源代码进行更新。 重新联编并安装定制的内核可以以通常的方式来进行。
注意:

通过 freebsd-update 发布的更新有时并不会涉及内核。 如果在执行 freebsd-update install 的过程中内核代码没有进行变动， 就没有必要重新联编内核了。 不过， 由于 freebsd-update 每次都会更新 /usr/src/sys/conf/newvers.sh 文件， 而修订版本 (uname -r 报告的 -p 数字) 来自这个文件， 因此， 即使内核没有发生变化， 重新联编内核也可以让 uname(1) 报告准确的修订版本。 在维护许多系统时这样做会比较有帮助， 因为这一信息可以迅速反映机器上安装的软件更新情况。
25.2.3. 重大和次要的更新

这个过程会删除旧的目标文件和库， 这将使大部分的第三方应用程序无法删除。 建议将所有安装的 ports 先删除然后重新安装，或者稍后使用 ports-mgmt/portupgrade 工具升级。 大多数用户将会使用如下命令尝试编译：

# portupgrade -af

这将确保所有的东西都会被正确的重新安装。 请注意环境变量 BATCH 设置成 yes 的话将在整个过程中对所有询问回答 yes，这会帮助在编译过程中免去人工的介入。

如果正在使用的是定制的内核， 则升级操作会复杂一些。 您会需要将一份 GENERIC 内核的副本放到 /boot/GENERIC。 如果系统中没有 GENERIC 内核， 可以用以下两种方法之一来安装：

    如果只联编过一次内核， 则位于 /boot/kernel.old 中的内核， 就是 GENERIC 的那一个。 只需将这个目录改名为 /boot/GENERIC 即可。

    假如能够直接接触机器， 则可以通过 CD-ROM 介质来安装 GENERIC 内核。 将安装盘插入光驱， 并执行下列命令：

    # mount /cdrom
    # cd /cdrom/X.Y-RELEASE/kernels
    # ./install.sh GENERIC

    您需要将 X.Y-RELEASE 替换为您正在使用的版本。 GENERIC 内核默认情况下会安装到 /boot/GENERIC。

    如果前面的方法都不可用， 还可以使用源代码来重新联编和安装 GENERIC 内核：

    # cd /usr/src
    # env DESTDIR=/boot/GENERIC make kernel
    # mv /boot/GENERIC/boot/kernel/* /boot/GENERIC
    # rm -rf /boot/GENERIC/boot

    如果希望 freebsd-update 能够正确地将内核识别为 GENERIC， 您必须确保没有对 GENERIC 配置文件进行过任何变动。 此外， 建议您取消任何其他特殊的编译选项 (例如使用空的 /etc/make.conf)。

上述步骤并不需要使用这个 GENERIC 内核来引导系统。

重大和次要的更新可以由 freebsd-update 命令后指定一个发行版本来执行， 举例来说，下面的命令将帮助你升级到 FreeBSD 8.1：

# freebsd-update -r 8.1-RELEASE upgrade

在执行这个命令之后，freebsd-update 将会先解析配置文件和评估当前的系统以获得更新系统所需的必要信息。 然后便会显示出一个包含了已检测到与未检测到的组件列表。 例如：

Looking up update.FreeBSD.org mirrors... 1 mirrors found.
Fetching metadata signature for 8.0-RELEASE from update1.FreeBSD.org... done.
Fetching metadata index... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/smp src/base src/bin src/contrib src/crypto src/etc src/games
src/gnu src/include src/krb5 src/lib src/libexec src/release src/rescue
src/sbin src/secure src/share src/sys src/tools src/ubin src/usbin
world/base world/info world/lib32 world/manpages

The following components of FreeBSD do not seem to be installed:
kernel/generic world/catpages world/dict world/doc world/games
world/proflibs

Does this look reasonable (y/n)? y

此时，freebsd-update 将会尝试下载所有升级所需的文件。在某些情况下， 用户可能被问及需安装些什么和如何进行之类的问题。

当使用定制内核时， 前面的步骤会产生类似下面的警告：

WARNING: This system is running a "MYKERNEL" kernel, which is not a
kernel configuration distributed as part of FreeBSD 8.0-RELEASE.
This kernel will not be updated: you MUST update the kernel manually
before running "/usr/sbin/freebsd-update install"

此时您可以暂时安全地无视这个警告。 更新的 GENERIC 内核将在升级过程的中间步骤中使用。

在下载完针对本地系统的补丁之后， 这些补丁会被应用到系统上。 这个过程需要消耗的时间取决于机器的速度和其负载。 这个过程中将会对配置文件所做的变动进行合并 ── 这一部分需要用户的参与， 文件可能会自动合并， 屏幕上也可能会给出一个编辑器， 用于手工完成合并操作。 在处理过程中， 合并成功的结果会显示给用户。 失败或被忽略的合并， 则会导致这一过程的终止。 用户可能会希望备份一份 /etc 并在这之后手工合并重要的文件， 例如 master.passwd 和 group。
注意:

系统至此还没有被修改，所有的补丁和合并都在另外一个目录中进行。 当所有的补丁都被成功的打上了以后，所有的配置文件都被合并后， 我们就已经完成了整个升级过程中最困难的部分， 下面就需要用户来安装这些变更了。

一旦这个步骤完成后，使用如下的命令将升级后的文件安装到磁盘上。

# freebsd-update install

内核和内核模块会首先被打上补丁。 此时必须重新启动计算机。 如果您使用的是定制的内核， 请使用 nextboot(8) 命令来将下一次用于引导系统的内核 /boot/GENERIC (它会被更新)：

# nextboot -k GENERIC

警告:

在使用 GENERIC 内核启动之前， 请确信它包含了用于引导系统所需的全部驱动程序 (如果您是在远程进行升级操作， 还应确信网卡驱动也是存在的)。 特别要注意的情形是， 如果之前的内核中静态联编了通常以内核模块形式存在的驱动程序， 一定要通过 /boot/loader.conf 机制来将这些模块加载到 GENERIC 内核的基础上。 此外， 您可能也希望临时取消不重要的服务、 磁盘和网络挂载等等， 直到升级过程完成为止。

现在可以用更新后的内核引导系统了：

# shutdown -r now

在系统重新上线后，需要再次运行 freebsd-update。 升级的状态被保存着，这样 freebsd-update 就无需重头开始，但是会删除所有旧的共享库和目标文件。 执行如下命令继续这个阶段的升级：

# freebsd-update install

注意:

取决与是否有库的版本更新，通常只有 2 个而不是 3 个安装阶段。

现在需要重新编译和安装第三方软件。 这么做的原因是某些已安装的软件可能依赖于在升级过程中已删除的库。 可使用 ports-mgmt/portupgrade 自动化这个步骤，以如下的命令开始：

# portupgrade -f ruby
# rm /var/db/pkg/pkgdb.db
# portupgrade -f ruby18-bdb
# rm /var/db/pkg/pkgdb.db /usr/ports/INDEX-*.db
# portupgrade -af

一旦这个完成了以后，再最后一次运行 freebsd-update 来结束升级过程。 执行如下命令处理升级中的所有细节：

# freebsd-update install

如果您临时用过 GENERIC 内核来引导系统， 现在是按照通常的方法重新联编并安装新的定制内核的时候了。

重新启动机器进入新版本的 FreeBSD 升级过程至此就完成了。
25.2.4. 系统状态对照

freebsd-update 工具也可被用来对着一个已知完好的 FreeBSD 拷贝测试当前的版本。 这个选项评估当前的系统工具，库和配置文件。 使用以下的命令开始对照：

# freebsd-update IDS >> outfile.ids

警告:

这个命令的名称是 IDS， 它并不是一个像 security/snort 这样的入侵检测系统的替代品。因为 freebsd-update 在磁盘上存储数据， 很显然它们有被篡改的可能。 当然也可以使用一些方法来降低被篡改的可能性，比如设置 kern.securelevel 和不使用时把 freebsd-update 数据放在只读文件系统上，例如 DVD 或 安全存放的外置 USB 磁盘上。

现在系统将会被检查，生成一份包含了文件和它们的 sha256(1) 哈希值的清单，已知发行版中的值与当前系统中安装的值将会被打印到屏幕上。 这就是为什么输出被送到了 outfile.ids 文件。 它滚动的太块无法用肉眼对照，而且会很快填满控制台的缓冲区。

这个文件中有非常长的行，但输出的格式很容易分析。 举例来说，要获得一份与发行版中不同哈希值的文件列表， 已可使用如下的命令：

# cat outfile.ids | awk '{ print $1 }' | more
/etc/master.passwd
/etc/motd
/etc/passwd
/etc/pf.conf

这份输出时删节缩短后的，其实是有更多的文件。 其中有些文件并非人为修改，比如 /etc/passwd 被修改是因为添加了用户进系统。在某些情况下， 还有另外的一些文件，诸如内核模块与 freebsd-update 的不同是因为它们被更新过了。 为了指定的文件或目录排除在外，把它们加到 /etc/freebsd-update.conf 的 IDSIgnorePaths 选项中。

除了前面讨论过的部分之外， 这也能被当作是对升级方法的详细补充。
上一页 	
