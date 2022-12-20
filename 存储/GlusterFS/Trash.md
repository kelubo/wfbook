# Trash Translator

[TOC]

## 概述

Trash translator will allow users to access deleted or truncated  files.垃圾箱转换器将允许用户访问删除或截断的文件。每个 brick 都将维护一个隐藏的 .trashcan 目录，用于存储从相应 brick 中删除或截断的文件。The aggregate of all those .trashcan directories can be accessed from the mount point.所有这些 .trashcan 目录的集合都可以从装载点访问。为了避免名称冲突，在将原始文件移动到 .trashcan 目录时，会在原始文件名后面附加一个时间戳。

## 含义和用法

Apart from the primary use-case of accessing files deleted or  truncated by the user, the trash translator can be helpful for internal  operations such as self-heal and rebalance. During self-heal and  rebalance it is possible to lose crucial data. In those circumstances,  the trash translator can assist in the recovery of the lost data. The  trash translator is designed to intercept unlink, truncate and ftruncate fops, store a copy of the current file in the trash directory, and then perform the fop on the original file. For the internal operations, the  files are stored under the 'internal_op' folder inside the trash  directory.

除了访问用户删除或截断的文件的主要用例外，垃圾桶转换器还可以帮助内部操作，例如自我修复和重新平衡。在自我修复和重新平衡过程中，可能会丢失关键数据。在这种情况下，垃圾转换器可以帮助恢复丢失的数据。垃圾桶转换器设计用于拦截取消链接、截断和ftruncate fop，将当前文件的副本存储在垃圾桶目录中，然后对原始文件执行fop。对于内部操作，文件存储在垃圾箱目录中的“internal  op”文件夹下。

## 选项

```bash
gluster volume set <VOLNAME> features.trash <on/off>
```

This command can be used to enable a trash translator in a volume. 此命令可用于启用卷中的垃圾桶转换器。如果设置为 on，则在 volume start 命令期间，将在卷内的每个 brick 中创建 .trashcan 目录。By default, a translator is  loaded during volume start but remains non-functional.默认情况下，在卷启动期间加载转换器，但仍不起作用。 Disabling trash  with the help of this option will not remove the trash directory or even its contents from the volume.借助此选项禁用垃圾箱不会从卷中删除垃圾箱目录甚至其内容。

```bash
gluster volume set <VOLNAME> features.trash-dir <name>
```

This command is used to reconfigure the trash directory to a  user-specified name. The argument is a valid directory name. The  directory will be created inside every brick under this name. If not  specified by the user, the trash translator will create the trash  directory with the default name “.trashcan”. This can be used only when  the trash-translator is on.此命令用于将垃圾目录重新配置为用户指定的名称。参数是有效的目录名。该目录将在该名称下的每个砖中创建。如果用户未指定，垃圾桶转换器将使用默认名称“.tashcan”创建垃圾桶目录。这只能在垃圾转换器打开时使用。

```bash
gluster volume set <VOLNAME> features.trash-max-filesize <size>
```

This command can be used to filter files entering the trash directory based on their size. Files above trash_max_filesize are  deleted/truncated directly. Value for size may be followed by  multiplicative suffixes as KB(=1024 bytes), MB(=1024*1024 bytes) ,and  GB(=1024*1024*1024 bytes). The default size is set to 5MB.*

此命令可用于根据文件大小过滤进入垃圾箱目录的文件。超过垃圾箱最大文件大小的文件将被直接删除/截断。大小值后面可以是KB（=1024字节）、MB（=1024*1024字节）和GB（=1022*1024*104字节）等乘法后缀。默认大小设置为5MB。

```bash
gluster volume set <VOLNAME> features.trash-eliminate-path <path1> [ , <path2> , . . . ]
```

This command can be used to set the eliminate pattern for the trash  translator. Files residing under this pattern will not be moved to the  trash directory during deletion/truncation. The path must be a valid one present in the volume.

此命令可用于设置垃圾转换器的消除模式。在删除/截断期间，在此模式下驻留的文件不会被移动到垃圾箱目录。路径必须是卷中存在的有效路径。

```bash
gluster volume set <VOLNAME> features.trash-internal-op <on/off>
```

This command can be used to enable trash for internal operations like self-heal and re-balance. By default set to off.

此命令可用于启用内部操作（如自我修复和重新平衡）的垃圾桶。默认设置为禁用。

## 示例用法

创建一个简单的分布式卷并启动它。

```bash
gluster volume create test rhs:/home/brick
gluster volume start test
```

Enable trash translator启用垃圾桶转换器

```bash
gluster volume set test features.trash on
```

Mount glusterfs volume via native client as follows.通过本机客户端安装 glusterfs 卷，如下所示。

```bash
mount -t glusterfs  rhs:test /mnt
```

Create a directory and file in the mount.在装载中创建目录和文件。

```bash
mkdir mnt/dir
echo abc > mnt/dir/file
```

从装载中删除文件。

```bash
rm mnt/dir/file -rf
```

Checkout inside the trash directory.在垃圾箱目录中签出。

```bash
ls mnt/.trashcan
```

We can find the deleted file inside the trash directory with a timestamp appending on its filename.我们可以在垃圾目录中找到删除的文件，并在其文件名上附加时间戳。

#### 需要记住的要点

- As soon as the volume is started, the trash directory will be  created inside the volume and will be visible through the mount.  Disabling the trash will not have any impact on its visibility from the  mount.
- 一旦启动卷，将在卷内创建垃圾目录，并通过装载可见。禁用垃圾箱不会对其在底座上的可见性产生任何影响。
- 即使不允许删除垃圾箱目录，当前驻留的垃圾箱内容也会在发出删除命令时被删除，并且只存在一个空的垃圾箱目录。
- Even though deletion of trash-directory is not permitted, currently  residing trash contents will be removed on issuing delete on it and only an empty trash-directory exists.

#### 已知的问题

Since trash translator resides on the server side higher translators  like AFR, DHT are unaware of rename and truncate operations being done  by this translator which eventually moves the files to trash directory.  Unless and until a complete-path-based lookup comes on trashed files,  those may not be visible from the mount.

由于垃圾转换器驻留在服务器端的高级转换器（如AFR）上，DHT不知道该转换器正在执行重命名和截断操作，这些操作最终会将文件移动到垃圾目录。除非并且直到基于路径的完整查找出现在垃圾文件上，否则这些文件可能无法从装载中看到。