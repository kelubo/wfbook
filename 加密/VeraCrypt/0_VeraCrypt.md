# VeraCrypt

[TOC]

## 概述

VeraCrypt 是一个免费的开源磁盘加密软件，适用于 Windows，Mac OSX 和 Linux 。由 **IDRIX**（https://www.idrix.fr）提供并基于 TrueCrypt 7.1a 。

VeraCrypt 主要特点：

- 在文件中创建**虚拟加密磁盘**并将其作为真实的磁盘挂载。
- 加密**整个分区或存储设备，**如 USB 闪存驱动器或硬盘驱动器。
- 加密**安装 Windows 的分区或驱动器**（[预引导身份验证](https://veracrypt.fr/en/System Encryption.html)）。
- 加密是[**自动**的、**实时的**（即时的）和**透明**](https://veracrypt.fr/en/Documentation.html)的。
- [并行化](https://veracrypt.fr/en/Parallelization.html)和[流水线](https://veracrypt.fr/en/Pipelining.html)允许数据的读写速度与驱动器未加密时一样快。
- 加密可以在现代处理器上进行[硬件加速](https://veracrypt.fr/en/Hardware Acceleration.html)。
- Provides **[plausible deniability](https://veracrypt.fr/en/Plausible Deniability.html)**, in case an adversary forces you to reveal the password: **[Hidden volume](https://veracrypt.fr/en/Hidden Volume.html)** (steganography) and **[hidden operating system](https://veracrypt.fr/en/Hidden Operating System.html)**.
  提供**[合理的可否认性](https://veracrypt.fr/en/Plausible Deniability.html)**，以防对手强迫您透露密码：**[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)**（隐写术）和**[隐藏操作系统](https://veracrypt.fr/en/Hidden Operating System.html)**。

### VeraCrypt 能给你带来什么？

VeraCrypt adds enhanced security to the algorithms used for system and partitions encryption making it immune to new developments in brute-force attacks.VeraCrypt 增强了用于系统和分区加密的算法的安全性，使其免受暴力破解攻击的新发展。

VeraCrypt 还解决了 TrueCrypt 中发现的许多漏洞和安全问题。

例如，当系统分区被加密时，TrueCrypt 使用 PBKDF2-RIPEMD160 进行 1000 次迭代，而在 VeraCrypt 中使用默认 200000 次迭代（可以使用自定义 PIM 增加）。对于标准容器和其他分区，TrueCrypt 最多使用 2000 次迭代，而 VeraCrypt 使用默认为 500000 次迭代（也可以使用自定义 PIM 增加）。

这种增强的安全性只会在打开加密分区时增加一些延迟，而不会对应用程序使用阶段产生任何性能影响。这对合法所有者来说是可以接受的，但这使得攻击者更难访问加密的数据。

所有发布的文件都使用以下链接上的 PGP 密钥进行签名： https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key.asc 。它也可以在 ID=0x680D16DE 的主要密钥服务器上使用。

请检查其指纹是 5069A233D55A0EEB174A5FC3821ACD02680D16DE 。

SHA256 and SHA512 sums for all released files are available in the Downloads section.
下载部分提供了所有已发布文件的 SHA256 和 SHA512 总和。

VeraCrypt is a software for establishing and maintaining an  on-the-fly-encrypted volume (data storage device). On-the-fly encryption means that data is automatically encrypted right before it is saved and decrypted right after it is loaded.
VeraCrypt 是一款用于创建和维护动态加密卷（数据存储设备）的软件。即时加密意味着数据在保存之前自动加密，并在加载之后立即解密，无需任何用户干预。如果不使用正确的密码/密钥文件或正确的加密密钥，则无法读取（解密）存储在加密卷上的任何数据。整个文件系统被加密（例如，文件名、文件夹名、每个文件的内容、空闲空间、Meta数据等）。

Files are automatically being decrypted on  the fly (in memory/RAM) while they are being read or copied from an encrypted VeraCrypt volume. Similarly, files that are being  written or copied to the VeraCrypt volume are automatically being  encrypted on the fly (right before they are written to the disk) in RAM. Note that this does *not* mean that the  *whole* file that is to be encrypted/decrypted must be stored in  RAM before it can be encrypted/decrypted. There are no extra memory  (RAM) requirements for VeraCrypt. For an illustration of how this is  accomplished, see the following paragraph.
可以将文件复制到已安装的 VeraCrypt 卷或从已安装的 VeraCrypt 卷复制文件，就像将文件复制到任何普通磁盘或从任何普通磁盘复制文件一样（例如，通过简单的拖放操作）。在读取或复制文件时，文件会自动在运行中（在内存/RAM中）解密 加密的VeraCrypt加密卷同样，写入或复制到VeraCrypt加密卷的文件也会在RAM中自动加密（就在它们写入磁盘之前）。请注意， *这并不*意味着要被加密/解密的*整个*文件在其可以被加密/解密之前必须被存储在RAM中。VeraCrypt没有额外的内存（RAM）要求。有关如何实现这一点的说明，请参阅以下段落。

假设有一个 .avi 视频文件存储在 VeraCrypt 加密卷上（因此，视频文件是完全加密的）。用户提供正确的密码（和/或密钥文件）并挂载（打开）VeraCrypt 加密卷。当用户双击图标时，操作系统启动与文件类型相关联的应用程序——通常是媒体播放器。然后，媒体播放器开始从 VeraCrypt 加密卷加载视频文件的一小部分到 RAM（内存）。在加载的过程中，VeraCrypt 会自动对其进行解密（在 RAM 中）。视频的解密部分（存储在 RAM 中）然后由媒体播放器播放。播放此部分时，媒体播放器开始将视频文件的另一小部分从 VeraCrypt 加密卷加载传输到 RAM（内存），然后重复此过程。这个过程被称为动态加密/解密，它适用于所有文件类型（不仅适用于视频文件）。

请注意，VeraCrypt 不会将任何解密后的数据保存到磁盘上——它只是将它们临时存储在 RAM（内存）中。即使卷已装入，存储在卷中的数据仍然是加密的。当重新启动 Windows 或关闭计算机时，卷将被删除，存储在其中的文件将无法访问（并加密）。即使电源突然中断（没有适当的系统关闭），存储在卷中的文件也无法访问（并加密）。要再次访问它们，必须挂载卷（并提供正确的密码和/或密钥文件）。

## 创建和使用 VeraCrypt 容器

下载并安装 VeraCrypt 。然后双击 VeraCrypt.exe 文件或在 Windows 开始菜单中点击 VeraCrypt 快捷方式来启动 VeraCrypt 。

出现 VeraCrypt 主窗口。单击“**创建卷”（Create Volume）**（为清楚起见，用红色矩形标记）。

 ![](../../Image/b/Beginner's Tutorial_Image_001.jpg)

出现 VeraCrypt 加密卷创建向导窗口。

 ![img](../../Image/b/Beginner's Tutorial_Image_002.jpg)

在这一步中，需要选择创建 VeraCrypt 加密卷的位置。VeraCrypt 加密卷可以驻留在分区或驱动器中的文件（也称为容器）中。在本教程中，将选择第一个选项并在文件中创建一个 VeraCrypt 加密卷。

由于默认情况下选择了该选项，因此只需单击**“下一步**”即可。

> 注意：
>
> 在以下步骤中，屏幕截图将仅显示向导窗口的右侧部分。

 ![img](../../Image/b/Beginner's Tutorial_Image_003.jpg)

在此步骤中，需要选择创建一个标准加密卷还是隐藏加密卷。在本教程中，将选择前者并创建一个标准的 VeraCrypt 加密卷。

由于默认情况下选择了该选项，因此只需单击**“下一步**”即可。

 ![](../../Image/b/Beginner's Tutorial_Image_004.jpg)

在这一步中，需要指定希望在哪里创建 VeraCrypt 加密卷（文件容器）。请注意，VeraCrypt 容器就像任何普通文件一样。例如，它可以像任何普通文件一样移动或删除。它还需要一个文件名，将在下一步中选择。

单击**选择文件**。

 ![](../../Image/b/Beginner's Tutorial_Image_005.jpg)

出现标准的 Windows 文件选择器（同时 VeraCrypt 加密卷创建向导的窗口在后台保持打开状态）。

在本教程中，将在文件夹 ` F:\Data\ ` 中创建 VeraCrypt 加密卷，加密卷（容器）的文件名为 `MyVolume.hc`（如上面的截图所示）。当然，可以选择任何其他文件名和位置（例如，在 USB 记忆棒上）。注意，文件 `MyVolume.hc` 不存在—— VeraCrypt 将创建它。

> 注意：
>
> VeraCrypt **不会**加密任何现有的文件（当创建一个 VeraCrypt 文件容器时）。如果在此步骤中选择了现有文件，则它将被新创建的卷覆盖并替换（因此覆盖的文件将**丢失**，而**不是**加密）。加密现有文件，方法是将它们移动到正在创建的 VeraCrypt 加密卷。

在文件选择器中选择所需的路径（希望在其中创建容器）。

单击**保存**。

文件选择器窗口应该消失。

在下面的步骤中，将返回到 VeraCrypt 加密卷创建向导。

 ![](../../Image/b/Beginner's Tutorial_Image_007.jpg)

在“卷创建向导”窗口中，单击**“下一步**”。

 ![](../../Image/b/Beginner's Tutorial_Image_008.jpg)

在这里，可以为卷选择加密算法和哈希算法。如果不确定在此选择什么，可以使用默认设置，然后单击 **下一步**。

 ![img](../../Image/b/Beginner's Tutorial_Image_009.jpg)

这里指定 VeraCrypt 容器的大小为 250 MB。当然，可以指定不同的大小。在输入字段（用红色矩形标记）中键入所需大小后，单击 **下一个**。

 ![](../../Image/b/Beginner's Tutorial_Image_010.jpg)

这是最重要的步骤之一。在这里必须选择一个好的卷密码。

选择好密码后，在第一个输入框中输入密码。然后在第一个输入框下面的输入框中重新输入，然后单击 **下一个**。

注：按钮**下一步**将被禁用，直到两个输入字段中的密码相同。

 ![](../../Image/b/Beginner's Tutorial_Image_011.jpg)

在 “Volume Creation Wizard”（卷创建向导）窗口中尽可能随机地移动鼠标，至少直到随机性指示器变为绿色。移动鼠标的时间越长越好（建议至少移动 30 秒）。这显著地增加了加密密钥的加密强度（这增加了安全性）。

单击**格式化**。

卷创建应开始。VeraCrypt 现在将在文件夹 `F：\Data\` 中创建一个名为 `MyVolume.hc` 的文件。这个文件将是一个 VeraCrypt 容器（它将包含加密的 VeraCrypt 卷）。根据卷的大小，创建卷可能需要很长时间。完成后，将出现以下对话框：

 ![](../../Image/b/Beginner's Tutorial_Image_012.jpg)

单击**“确定**”关闭对话框。

 ![](../../Image/b/Beginner's Tutorial_Image_013.jpg)

刚刚成功创建了一个 VeraCrypt 加密卷（文件容器）。在 VeraCrypt 加密卷创建向导窗口中，点击 **退出**.

向导窗口将消失。

在剩下的步骤中，将挂载刚刚创建的卷。返回到 VeraCrypt 主窗口。

 ![](../../Image/b/Beginner's Tutorial_Image_014.jpg)

从列表中选择一个驱动器号（用红色矩形标记）。这将是 VeraCrypt 容器将被挂载到的驱动器号。

 ![](../../Image/b/Beginner's Tutorial_Image_015.jpg)

单击**选择文件**。

应该出现标准文件选择器窗口。

 ![](../../Image/b/Beginner's Tutorial_Image_016.jpg)

在文件选择器中，浏览到容器文件并选择它。 点击**打开**（在文件选择器窗口中）。

文件选择器窗口应该消失。

在下面的步骤中，将返回 VeraCrypt 主窗口。

 ![](../../Image/b/Beginner's Tutorial_Image_017.jpg)

在 VeraCrypt 主窗口中，点击**Mount**。应出现密码提示对话框窗口。

 ![](../../Image/b/Beginner's Tutorial_Image_018.jpg)

在密码输入字段（用红色矩形标记）中键入密码。

 ![](../../Image/b/Beginner's Tutorial_Image_019.jpg)

选择创建加密卷时使用的 PRF 算法（SHA-512 是 VeraCrypt 默认使用的 PRF）。如果不记得使用的是哪个 PRF，只需将其设置为“自动检测”，但安装过程将需要更多时间。输入密码后单击**确定**。

VeraCrypt 将尝试挂载加密卷。如果密码不正确（例如，输入的密码不正确），VeraCrypt 会通知您，需要重复上一步（再次输入密码并点击 **OK**）。如果密码正确，卷将被装入。

 ![](../../Image/b/Beginner's Tutorial_Image_020.jpg)

刚刚成功地将容器挂载为虚拟磁盘 M 。

虚拟磁盘完全加密（包括文件名、分配表、可用空间等）并且表现得像一个真实的磁盘。可以保存（或复制、移动等）文件到这个虚拟磁盘，它们将在写入时被动态加密。

如果打开一个存储在 VeraCrypt 加密卷上的文件，例如，在媒体播放器中，该文件将在读取过程中被自动解密到 RAM（内存）中。

> 重要提示：
>
> 当打开存储在 VeraCrypt 加密卷上的文件时（或者当向 VeraCrypt 加密卷写入/从 VeraCrypt 加密卷复制文件时），系统不会要求再次输入密码。只有在装入卷时才需要输入正确的密码。

可以打开挂载的卷，例如，通过在上面的屏幕截图中所示的列表中选择它（蓝色选择），然后双击所选项目。

还可以像通常浏览任何其他类型的卷一样浏览到已装入的卷。例如，打开“*计算机*”（或“*我的计算机*”）列表，然后双击相应的驱动器号 (示例中就是字母 M ）。

 ![](../../Image/b/Beginner's Tutorial_Image_021.jpg)

可以将文件（或文件夹）复制到 VeraCrypt 加密卷或从 VeraCrypt 加密卷复制文件（或文件夹），就像将它们复制到任何普通磁盘一样（例如，通过简单的拖放操作）。从加密的 VeraCrypt 加密卷中读取或复制的文件会自动解密在 RAM（内存）中运行。同样，写入或复制到 VeraCrypt 加密卷的文件也会在 RAM 中自动加密（就在它们写入磁盘之前）。

> rypt never saves any decrypted data to a disk – it only  stores them temporarily in RAM (memory). Even when the volume is  mounted, data stored in the volume is still encrypted. When you restart  Windows or turn off your computer, the volume will be dismounted and all files stored on it will be inaccessible (and encrypted). Even when power supply is suddenly interrupted (without  proper system shut down), all files stored on the volume will be  inaccessible (and encrypted). To make them accessible again, you have to mount the volume.
> 请注意，VeraCrypt 不会将任何解密后的数据保存到磁盘上——它只是将它们临时存储在 RAM（内存）中。即使卷已装入，存储在卷中的数据仍然是加密的。当重新启动 Windows 或关闭计算机时，将被删除，存储在其中的所有文件将无法访问（并加密）。即使电源突然中断（没有适当的系统关闭），存储在卷上的所有文件将无法访问（和加密）。让他们变得容易接近，同样，必须挂载卷。

如果要关闭卷并使其上存储的文件无法访问，请重新启动操作系统或卸载卷。为此，请按照下列步骤操作：

 ![](../../Image/b/Beginner's Tutorial_Image_022.jpg)

在 VeraCrypt 主窗口的挂载加密卷列表中选择加密卷（在上面的截图中用红色矩形标记），然后点击 **卸载**（在上面的截图中也用红色矩形标记）。要使存储在卷上的文件再次可访问，必须装入卷。

## How to Create and Use a VeraCrypt-Encrypted Partition/Device 如何创建和使用VeraCrypt加密的分区/设备

Instead of creating file containers, you can also encrypt physical partitions  or drives (i.e., create VeraCrypt device-hosted volumes). To do so,  repeat the steps 1-3 but in the step 3 select the second or third  option. Then follow the remaining instructions in the wizard. When you create a device-hosted VeraCrypt volume within a *non-system* partition/drive, you can mount it by clicking *Auto-Mount Devices* in the main VeraCrypt window. For information pertaining to encrypted *system* partition/drives, see the chapter [ *System Encryption*](https://veracrypt.fr/en/System Encryption.html).
除了创建文件容器，您还可以加密物理分区或驱动器（即，创建VeraCrypt设备托管的加密卷）。要执行此操作，请重复步骤1-3，但在步骤3中选择第二个或第三个选项。然后按照向导中的其余说明进行操作。当您在*非系统*分区/驱动器中创建设备托管的VeraCrypt加密卷时，您可以在VeraCrypt主窗口中点击*自动挂载设备来*挂载它。有关加密的 *系统*分区/驱动器，请参阅“[*系统加密”*](https://veracrypt.fr/en/System Encryption.html)一章。

Important: *We strongly recommend that you also read the other chapters of this  manual, as they contain important information that has been omitted in  this tutorial for simplicity.*
重要：*我们强烈建议您也阅读本手册的其他章节，因为它们包含本教程中为简单起见省略的重要信息。*

# VeraCrypt Volume VeraCrypt加密卷

There are two types of VeraCrypt volumes:
VeraCrypt加密卷有两种类型：

- File-hosted (container)  文件托管（容器）
- Partition/device-hosted (non-system) 
  分区/设备托管（非系统）

Note: In addition to creating the above types of virtual volumes, VeraCrypt  can encrypt a physical partition/drive where Windows is installed (for  more information, see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)).
注意事项：除了创建上述类型的虚拟卷，VeraCrypt还可以加密安装Windows的物理分区/驱动器（更多信息，请参阅 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)）。

 A VeraCrypt file-hosted volume is a normal file, which can reside on any type of storage device. It contains (hosts) a completely independent  encrypted virtual disk device.
VeraCrypt文件托管卷是一个普通的文件，它可以驻留在任何类型的存储设备上。它包含（主机）一个完全独立的加密虚拟磁盘设备。

 A VeraCrypt partition is a hard disk partition encrypted using  VeraCrypt. You can also encrypt entire hard disks, USB hard disks, USB  memory sticks, and other types of storage devices.
VeraCrypt分区是使用VeraCrypt加密的硬盘分区。您还可以加密整个硬盘，USB硬盘，USB记忆棒和其他类型的存储设备。

# Creating a New VeraCrypt Volume 创建新的VeraCrypt加密卷

To create a new VeraCrypt file-hosted volume or to encrypt a  partition/device (requires administrator privileges), click on ‘Create  Volume’ in the main program window. VeraCrypt Volume Creation Wizard  should appear. As soon as the Wizard appears, it starts collecting data that will be used in generating the master  key, secondary key (XTS mode), and salt, for the new volume. The  collected data, which should be as random as possible, include your  mouse movements, key presses, and other values obtained from the system (for more information, please see the section [ *Random Number Generator*](https://veracrypt.fr/en/Random Number Generator.html)). The Wizard provides help and information necessary to successfully  create a new VeraCrypt volume. However, several items deserve further  explanation:
要创建一个新的VeraCrypt文件托管加密卷或加密分区/设备（需要管理员权限），点击主程序窗口中的“创建加密卷”。VeraCrypt加密卷创建向导应该出现。一旦向导出现，它就开始收集数据，这些数据将用于为新卷生成主密钥、辅助密钥（XTS模式）和salt。收集的数据应尽可能随机，包括您的鼠标移动，按键和从系统获得的其他值（有关更多信息，请参阅[*随机数生成器*](https://veracrypt.fr/en/Random Number Generator.html)部分）。向导提供成功创建新VeraCrypt加密卷所需的帮助和信息。然而，有几个项目值得进一步解释：

### Hash Algorithm 哈希算法

Allows you to select which hash algorithm VeraCrypt will use. The selected  hash algorithm is used by the random number generator (as a pseudorandom mixing function), which generates the master key, secondary key (XTS  mode), and salt (for more information, please see the section [ *Random Number Generator*](https://veracrypt.fr/en/Random Number Generator.html)). It is also used in deriving the new volume header key and secondary header key (see the section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)).
允许您选择VeraCrypt将使用的哈希算法。随机数生成器（作为伪随机混合函数）使用选定的哈希算法，生成主密钥、辅助密钥（XTS模式）和salt（更多信息， 请参见[*随机数生成器*](https://veracrypt.fr/en/Random Number Generator.html)部分）。它还用于派生新的卷标头键和辅助标头键（请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。

 For information about the implemented hash algorithms, see the chapter [ *Hash Algorithms.*](https://veracrypt.fr/en/Hash Algorithms.html)
有关实现的哈希算法的信息，请参阅哈希算法一章[*。*](https://veracrypt.fr/en/Hash Algorithms.html)

 Note that the output of a hash function is *never* used directly as an encryption key. For more information, please refer to the chapter [*Technical Details*](https://veracrypt.fr/en/Technical Details.html).
请注意，散列函数的输出*永远不会*直接用作加密密钥。有关详细信息，请参阅 [*技术细节*](https://veracrypt.fr/en/Technical Details.html)。

### Encryption Algorithm 加密算法

This allows you to select the encryption algorithm with which your new  volume will be encrypted. Note that the encryption algorithm cannot be  changed after the volume is created. For more information, please see  the chapter [*Encryption Algorithms*](https://veracrypt.fr/en/Encryption Algorithms.html).
这使您可以选择加密算法，您的新卷将使用该加密算法进行加密。请注意，创建卷后无法更改加密算法。有关详细信息，请参阅 [*加密算法*](https://veracrypt.fr/en/Encryption Algorithms.html)。

### Quick Format 快速格式化

If unchecked, each sector of the new volume will be formatted. This means that the new volume will be *entirely* filled with random data. Quick format is much faster but may be less secure  because until the whole volume has been filled with files, it may be  possible to tell how much data it contains (if the space was not filled  with random data beforehand). If you are not sure whether to enable or disable Quick Format, we  recommend that you leave this option unchecked. Note that Quick Format  can only be enabled when encrypting partitions/devices, except on  Windows where it is also available when creating file containers.
如果未选中，新卷的每个扇区都将被格式化。这意味着新的卷将是 *充满*了随机数据快速格式化要快得多，但可能不太安全，因为直到整个卷都装满了文件，才有可能知道它包含多少数据（如果空间事先没有装满随机数据）。如果您不确定是启用还是禁用快速格式化，我们建议您将此选项保留为未选中状态。请注意，快速格式化只能在加密分区/设备时启用，但在Windows上除外，在Windows上，创建文件容器时也可以使用该功能。

Important: When encrypting a partition/device within which you intend to create a  hidden volume afterwards, leave this option unchecked.
重要：当加密分区/设备，您打算创建一个隐藏卷后，离开这个选项取消选中。

### Dynamic 动态

Dynamic VeraCrypt container is a pre-allocated NTFS sparse file whose physical  size (actual disk space used) grows as new data is added to it. Note  that the physical size of the container (actual disk space that the  container uses) will not decrease when files are deleted on the VeraCrypt volume. The physical size of the  container can only *increase* up to the maximum value that is specified by the user during the volume  creation process. After the maximum specified size is reached, the  physical size of the container will remain constant.
动态VeraCrypt容器是一个预先分配的加密稀疏文件，其物理大小（实际使用的磁盘空间）会随着新数据的添加而增加。请注意，容器的物理大小（容器使用的实际磁盘空间）不会随着新数据的添加而减少。 VeraCrypt加密卷上的文件被删除。容器的物理尺寸只能 *增加*到用户在卷创建过程中指定的最大值。在达到指定的最大大小后，容器的物理大小将保持不变。

 Note that sparse files can only be created in the NTFS file system. If  you are creating a container in the FAT file system, the option *Dynamic* will be disabled (“grayed out”).
请注意，稀疏文件只能在NTFS文件系统中创建。如果在FAT文件系统中创建容器， *动态*将被禁用（“灰显”）。

 Note that the size of a dynamic (sparse-file-hosted) VeraCrypt volume  reported by Windows and by VeraCrypt will always be equal to its maximum size (which you specify when creating the volume). To find out current  physical size of the container (actual disk space it uses), right-click the container file (in a Windows Explorer  window, not in VeraCrypt), then select *Properties* and see the Size on disk value.
请注意，Windows和VeraCrypt报告的动态（稀疏文件托管）VeraCrypt加密卷的大小将始终等于其最大大小（您在创建加密卷时指定）。要了解容器的当前物理大小（实际磁盘 空间），右键单击容器文件（在Windows资源管理器窗口中，而不是在VeraCrypt中），然后选择 *属性*，并查看“磁盘大小”值。

WARNING: Performance of dynamic (sparse-file-hosted) VeraCrypt volumes is  significantly worse than performance of regular volumes. Dynamic  (sparse-file-hosted) VeraCrypt volumes are also less secure, because it  is possible to tell which volume sectors are unused. Furthermore, if data is written to a dynamic volume when there  is not enough free space in its host file system, the encrypted file  system may get corrupted.
：动态（稀疏文件托管）VeraCrypt加密卷的性能明显比普通加密卷差。动态（稀疏文件托管）VeraCrypt加密卷的安全性也较低，因为它可以分辨出哪些加密卷扇区未使用。此外，如果在动态卷的主机文件系统中没有足够的可用空间时将数据写入动态卷，则加密的文件系统可能会损坏。

### Cluster Size 簇大小

Cluster is an allocation unit. For example, one cluster is allocated on a FAT  file system for a one- byte file. When the file grows beyond the cluster boundary, another cluster is allocated. Theoretically, this means that  the bigger the cluster size, the more disk space is wasted; however, the better the performance. If you  do not know which value to use, use the default.
集群是一个分配单元。例如，在FAT文件系统上为一个单字节文件分配一个簇.当文件超出群集边界时，将分配另一个群集。从理论上讲，这意味着集群大小越大，浪费的磁盘空间越多;然而，性能越好。如果不知道要使用哪个值，请使用默认值。

### VeraCrypt Volumes on CDs and DVDs VeraCrypt加密盘CD和DVD

If you want a VeraCrypt volume to be stored on a CD or a DVD, first create a file-hosted VeraCrypt container on a hard drive and then burn it onto a CD/DVD using any CD/DVD burning software (or, under Windows XP or  later, using the CD burning tool provided with the operating system). Remember that if you need to mount a  VeraCrypt volume that is stored on a read-only medium (such as a CD/DVD) under Windows 2000, you must format the VeraCrypt volume as FAT. The  reason is that Windows 2000 cannot mount NTFS file system on read-only media (Windows XP and later versions of Windows  can).
如果您想将VeraCrypt加密卷存储在CD或DVD上，请先在硬盘上创建一个文件托管的VeraCrypt容器，然后使用任何CD/DVD刻录软件将其刻录到CD/DVD上（或者，在Windows XP或更高版本下，使用操作系统提供的CD刻录工具）。请记住，如果您需要在Windows  2000下挂载存储在只读介质（如CD/DVD）上的VeraCrypt加密卷，您必须将VeraCrypt加密卷格式化为FAT。原因是Windows 2000不能在只读介质上挂载NTFS文件系统（Windows XP和更高版本的Windows可以）。

### Hardware/Software RAID, Windows Dynamic Volumes 硬件/软件RAID、Windows动态卷

VeraCrypt supports hardware/software RAID as well as Windows dynamic volumes.
VeraCrypt支持硬件/软件RAID以及Windows动态卷。

Windows Vista or later: Dynamic volumes are displayed in the ‘Select Device’ dialog window as \Device\HarddiskVolumeN.
Windows Vista或更高版本：动态卷在“选择设备”对话框窗口中显示为\Device\HarddiskVolumeN。

Windows XP/2000/2003: If you intend to format a Windows dynamic volume as a  VeraCrypt volume, keep in mind that after you create the Windows dynamic volume (using the Windows Disk Management tool), you must restart the  operating system in order for the volume to be available/displayed in the ‘Select Device’ dialog window of the  VeraCrypt Volume Creation Wizard. Also note that, in the ‘Select Device’ dialog window, a Windows dynamic volume is not displayed as a single  device (item). Instead, all volumes that the Windows dynamic volume consists of are displayed  and you can select any of them in order to format the entire Windows  dynamic volume.
Windows  XP/2000/2003：如果您打算将Windows动态加密卷格式化为VeraCrypt加密卷，请记住，在您创建Windows动态加密卷（使用Windows磁盘管理工具）之后，您必须重新启动操作系统，以使该加密卷可用/显示在VeraCrypt加密卷创建向导的“选择设备”对话框窗口中。另请注意，在“选择设备”对话框窗口中，Windows动态卷不会显示为单个设备（项目）。相反，将显示Windows动态卷所包含的所有卷，您可以选择其中任何一个来格式化整个Windows动态卷。

### Additional Notes on Volume Creation 关于卷创建的附加说明

After you click the ‘Format’ button in the Volume Creation Wizard window (the last step), there will be a short delay while your system is being  polled for additional random data. Afterwards, the master key, header  key, secondary key (XTS mode), and salt, for the new volume will be generated, and the master key and  header key contents will be displayed.
单击卷创建向导窗口中的“格式化”按钮（最后一步）后，将有一个短暂的延迟，而您的系统正在被轮询以获取其他随机数据。之后，主密钥、头密钥、辅助密钥（XTS模式）， 和salt，并显示主密钥和头密钥内容。

 For extra security, the portions of the randomness pool, master key, and header key can be prevented from being displayed by unchecking the  checkbox in the upper right corner of the corresponding field:
为了提高安全性，可以通过取消选中相应字段右上角的复选框来防止随机池、主密钥和标头密钥的部分显示：

 ![img](https://veracrypt.fr/en/Beginner's Tutorial_Image_023.gif)

 Note that only the first 128 bits of the pool/keys are displayed (not the entire contents).
请注意，仅显示池/键的前128位（而不是全部内容）。

 You can create FAT (whether it will be FAT12, FAT16, or FAT32, is  automatically determined from the number of clusters) or NTFS volumes  (however, NTFS volumes can only be created by users with administrator  privileges). Mounted VeraCrypt volumes can be reformatted as FAT12, FAT16, FAT32, or NTFS anytime. They behave as standard disk  devices so you can right-click the drive letter of the mounted VeraCrypt volume (for example in the ‘*Computer*’ or ‘*My Computer*’ list) and select ‘Format’.
您可以创建FAT（无论是FAT 12、FAT 16还是FAT 32，都是根据群集的数量自动确定的）或NTFS卷（但是，NTFS卷只能由具有管理员权限的用户创建）。安装的VeraCrypt加密卷可以重新格式化 FAT12、FAT16、FAT32或FAT32。它们就像标准的磁盘设备一样，所以你可以右键点击安装的VeraCrypt加密卷的驱动器号（例如在“*计算机*”或“*我的电脑*”列表中），然后选择 “不”。

 For more information about creating VeraCrypt volumes, see also the section [ *Hidden Volume*](https://veracrypt.fr/en/Hidden Volume.html).
有关创建VeraCrypt加密卷的更多信息，请参见[*隐藏加密卷*](https://veracrypt.fr/en/Hidden Volume.html)部分.

## Favorite Volumes 最喜欢的游戏

Favorite volumes are useful, for example, in any the following cases:
例如，在以下任何情况下，收藏卷都很有用：

- You have a volume that always needs to be **mounted to a particular drive letter**. 
  您有一个始终需要**挂载到特定驱动器号的**卷。
- You have a volume that needs to be **automatically mounted when its host device gets connected to the computer** (for example, a container located on a USB flash drive or external USB hard drive). 
  您有一个卷，**当其主机设备连接到计算机时需要自动装入**（例如，位于USB闪存驱动器或外部USB硬盘驱动器上的容器）。
- You have a volume that needs to be **automatically mounted when you log on** to the operating system. 
  您有一个卷需要**在登录**到操作系统时自动装入。
- You have a volume that always needs to be **mounted as read-only**  or removable medium. 
  您有一个始终需要**以只读方式挂载的**卷 或可移动介质。

**Note:** Please refer to [Known Issues and Limitations](https://veracrypt.fr/en/Issues and Limitations.html) section for issues that may affect favorite volumes when Windows "Fast Startup" feature is enabled. 
**注意：**请参阅[已知问题和限制](https://veracrypt.fr/en/Issues and Limitations.html)部分，了解启用Windows“快速启动”功能时可能影响收藏卷的问题。

### To configure a VeraCrypt volume as a favorite volume, follow these steps: 要将VeraCrypt加密卷配置为收藏加密卷，请按照以下步骤操作：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select ‘*Add to Favorites*’. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到收藏夹*”。
3. The Favorite Volumes Organizer window should appear now. In this window, you can set various options for the volume (see below). 
   现在应该会出现“收藏夹管理器”窗口。在此窗口中，您可以设置音量的各种选项（见下文）。
4. Click *OK*.  单击“*确定”（*OK）。

**Favorite volumes can be mounted in several ways:** To mount all favorite volumes, select *Favorites* > *Mount Favorite Volumes* or press the ‘*Mount Favorite Volumes*’ hot key (*Settings* > *Hot Keys*). To mount only one of the favorite volumes, select it from the list contained in the *Favorites* menu. When you do so, you are asked for its password (and/or keyfiles)  (unless it is cached) and if it is correct, the volume is mounted. If it is already mounted, an Explorer window is opened for it. 
**可以通过多种方式挂载收藏卷：**要挂载所有收藏卷，请选择 *Favorites*>*Mount Favorite选项卡*或按“*Mount Favorite选项卡*”热键（*Settings*>*Hot Keys*）。要仅装入一个常用卷，请从 *收藏夹*菜单。当你这样做时，你会被要求提供它的密码（和/或密钥文件）（除非它被缓存），如果它是正确的，卷就会被挂载。如果它已经被挂载，一个资源管理器窗口将为它打开。

### Selected or all favorite volumes can be mounted automatically whenever you log on to Windows 选定的或所有收藏的卷可以在您登录到Windows时自动挂载

To set this up, follow these steps:
要进行设置，请执行以下步骤：

1. Mount the volume you want to have mounted automatically when you log on  (mount it to the drive letter to which you want it to be mounted every  time). 
   挂载您希望在登录时自动挂载的卷（每次挂载到您希望挂载的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select ‘*Add to Favorites*’. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到收藏夹*”。
3. The Favorites Organizer window should appear now. In this window, enable the option ‘*Mount selected volume upon logon*’ and click *OK*. 
   现在应该出现“收藏夹管理器”窗口。在此窗口中，启用“*登录时装入选定卷”*选项，然后单击 *好*的.

Then, when you log on to Windows, you will be asked for the volume password  (and/or keyfiles) and if it is correct, the volume will be mounted.
然后，当您登录到Windows时，您将被要求输入卷密码（和/或密钥文件），如果正确，则将挂载卷。

 Note: VeraCrypt will not prompt you for a password if you have enabled caching of the pre-boot authentication password (*Settings* > ‘*System Encryption*’) and the volumes use the same password as the system partition/drive.
注意：如果您启用了预启动验证密码缓存（*设置*>“*系统加密*”），并且卷与系统分区/驱动器使用相同的密码，VeraCrypt将不会提示您输入密码。

Selected or all favorite volumes can be mounted automatically whenever its host  device gets connected to the computer. To set this up, follow these  steps:
选定的或所有收藏的卷可以自动安装时，其主机设备得到连接到计算机。要进行设置，请执行以下步骤：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select ‘*Add to Favorites*’. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到收藏夹*”。
3. The Favorites Organizer window should appear now. In this window, enable the option ‘*Mount selected volume when its host device gets connected*’ and click *OK*. 
   现在应该会出现“收藏夹管理器”窗口。在此窗口中，启用选项“*Mount selected volume when its host device gets connected*”，然后单击 *好*的.

Then, when you insert e.g. a USB flash drive on which a VeraCrypt volume is  located into the USB port, you will be asked for the volume password  (and/or keyfiles) (unless it is cached) and if it is correct, the volume will be mounted.
然后，当您将VeraCrypt加密卷所在的U盘插入USB端口时，系统会要求您输入加密卷密码（和/或密钥文件）（除非已缓存），如果正确，加密卷将被挂载。

 Note: VeraCrypt will not prompt you for a password if you have enabled caching of the pre-boot authentication password (*Settings* > ‘*System Encryption*’) and the volume uses the same password as the system partition/drive.
注意：如果您启用了预启动验证密码缓存（*设置*>“*系统加密*”），并且加密卷使用与系统分区/驱动器相同的密码，VeraCrypt将不会提示您输入密码。

A special label can be assigned to each favorite volume. This label is  not the same as the filesystem label and it is shown within the  VeraCrypt user interface instead of the volume path. To assign such a  label, follow these steps:
一个特殊的标签可以分配给每个收藏卷。该标签与文件系统标签不同，它显示在VeraCrypt用户界面中，而不是卷路径中。要分配这样的标签，请执行以下步骤：

1. Select *Favorites* > ‘*Organize Favorite Volumes*’. 
   选择“*收藏夹*”>“*组织收藏夹*”。
2. The Favorite Volumes Organizer window should appear now. In this window, select the volume whose label you want to edit. 
   现在应该会出现“收藏夹管理器”窗口。在此窗口中，选择要编辑其标签的卷。
3. Enter the label in the ‘*Label of selected favorite volume*’ input field and click OK. 
   在“*选定收藏卷的标签*”输入字段中输入标签，然后单击确定。

Note that the Favorite Volumes Organizer window (*Favorites* > ‘*Organize Favorite Volumes*’) allows you to **set various other options for each favorite volume**. For example, any of them can be mounted as read-only or as removable medium. To set any of these options, follow these steps:
请注意，"收藏夹目录管理器“窗口（*收藏夹*>”*组织收藏夹目录*“）允许您 **为每个收藏卷设置各种其他选项**。例如，它们中的任何一个都可以安装为只读或可移动介质。要设置这些选项中的任何一个，请执行以下步骤：

1. Select *Favorites* > ‘*Organize Favorite Volumes*’. 
   选择“*收藏夹*”>“*组织收藏夹*”。
2. The Favorite Volumes Organizer window should appear now. In this window, select the volume whose options you want to set. 
   现在应该会出现“收藏夹管理器”窗口。在此窗口中，选择要设置其选项的卷。
3. Set the options and click OK. 
   设置选项并单击“确定”。

The order in which system favorite volumes are displayed in the Favorites Organizer window (*Favorites* > ‘*Organize Favorite Volumes*’) is **the order in which the volumes are mounted** when you select *Favorites* > *Mount Favorite Volumes*  or when you press the ‘*Mount Favorite Volumes*’ hotkey (*Settings* > *Hot Keys*). You can use the *Move Up* and *Move Down*  buttons to change the order of the volumes.
系统收藏夹卷在"收藏夹管理器“窗口（*收藏夹*>”*组织收藏夹*“）中的显示顺序与选择*”收藏夹*>*装入收藏夹“时***卷的装入顺序相同** 或当您按下“*装载收藏夹*”热键（*设置*>*热键*）时。您可以使用*上移*和*下移* 按钮来更改卷的顺序。

 Note that a favorite volume can also be a **partition that is within the key scope of system encryption mounted without pre-boot authentication** (for example, a partition located on the encrypted system drive of another operating system that is not running). When you mount such a volume and add it to favorites, you will no longer have to select *System* > *Mount Without Pre-Boot Authentication* or to enable the mount option ‘*Mount partition using system encryption without pre- boot authentication*’. You can simply mount the favorite volume (as explained above) without setting any options, as the mode in which the volume is mounted is saved in the configuration file containing the list of your favorite volumes.
请注意，收藏夹卷也可以是在**没有预引导身份验证的情况下安装的系统加密的密钥范围内的分区**（例如，位于未运行的另一个操作系统的加密系统驱动器上的分区）。当您挂载此类卷并将其添加到收藏夹时， *系统*>*挂载无预启动身份验证*或启用挂载选项“*挂载分区使用系统加密无预靴子身份*验证”。您可以简单地挂载最喜欢的卷（如上所述） 无需设置任何选项，因为卷的挂载模式保存在包含收藏卷列表的配置文件中。

Warning: When the drive letter assigned to a favorite volume (saved in the  configuration file) is not free, the volume is not mounted and no error  message is displayed.
警告：当分配给收藏卷（保存在配置文件中）的驱动器号不可用时，将不会装入该卷，也不会显示任何错误消息。

 **To remove a volume form the list of favorite volumes**, select  *Favorites* > *Organize Favorite Volumes*, select the volume, click  *Remove*, and click OK.
**要从收藏夹卷列表中删除卷**，请选择*收藏夹*>*整理收藏夹卷*，选择卷，单击*删除*，然后单击确定。

# System Favorite Volumes 系统收藏夹

System favorites are useful, for example, in the following cases:
例如，在以下情况下，系统收藏夹非常有用：

- You have volumes that need to be **mounted before system and application services start and before users start logging on**. 
  您有一些卷需要**在系统和应用程序服务启动之前以及用户开始登录之前装入**。
- There are network-shared folders located on VeraCrypt volumes. If you  configure these volumes as system favorites, you will ensure that the **network shares will be automatically restored** by the operating system each time it is restarted. 
  VeraCrypt加密卷上有网络共享文件夹。如果将这些卷配置为系统收藏夹， **网络共享将在**每次重新启动时由操作系统自动恢复。
- You need each such volume to be mounted as **the same drive letter**  each time the operating system starts. 
  您需要将每个这样的卷挂载为**相同的驱动器号** 每次操作系统启动时。

Note that, unlike the regular (non-system) favorites, **system favorite volumes use the pre-boot authentication password** and, therefore, require your system partition/drive to be  encrypted (also note it is not required to enable caching of the  pre-boot authentication password). Moreover, since the pre-boot password is typed using **US keyboard layout** (BIOS requirement), the password of the system favorite volume must be entered during its creation process using the **US keyboard layout** by typing the same keyboard keys you type when you enter the pre-boot  authentication password. If the password of the system favorite volume  is not identical to the pre-boot authentication password under the US  keyboard layout, then **it will fail to mount**.
请注意，与常规（非系统）收藏夹不同，**系统收藏夹卷使用预引导身份验证密码**，因此需要加密系统分区/驱动器（还请注意，不需要启用预引导身份验证密码的缓存）。此外，由于预引导密码是使用 **US键盘布局**（BIOS要求），必须在创建过程中使用 **美国键盘布局**通过键入与输入预引导身份验证密码时键入的键盘键相同的键盘键。如果系统收藏夹卷的密码与美国键盘布局下的预引导身份验证密码不相同，则**它将无法挂载**。

When creating a volume that you want to make a system favorite later, you  must explicitly set the keyboard layout associated with VeraCrypt to US  layout and you have to type the same keyboard keys you type when you  enter the pre-boot authentication password.
当您创建一个加密卷并希望它成为您的系统收藏夹时，您必须将VeraCrypt的键盘布局设置为US布局，并且您必须输入与您输入预启动验证密码时相同的键盘键。

 System favorite volumes **can be configured to be available within VeraCrypt only to users with administrator privileges** (select *Settings* > ‘*System Favorite Volumes*’ > ‘*Allow only administrators to view and dismount system favorite volumes in VeraCrypt*’). This option should be enabled on servers to ensure that system favorite volumes cannot be dismounted by users without  administrator privileges. On non-server systems, this option can be used to prevent normal VeraCrypt volume actions (such as ‘*Dismount All*’, auto-dismount, etc.) from affecting system favorite volumes. In addition, when VeraCrypt is run without  administrator privileges (the default on Windows Vista and later),  system favorite volumes will not be displayed in the drive letter list  in the main VeraCrypt application window.
系统收藏夹加密卷**可以设置为仅对拥有管理员权限的用户可用**（选择*设置*>“*系统收藏夹加密*”>“*仅允许管理员在VeraCrypt中查看和加密系统收藏夹加密*卷”）。应在服务器上启用此选项，以确保 没有管理员权限的用户无法删除系统收藏夹卷。在非服务器系统上，这个选项可以用来阻止正常的VeraCrypt加密卷操作（例如“*全部卸载*”，自动删除等）影响到 系统收藏夹卷。此外，当VeraCrypt在没有管理员权限的情况下运行时（Windows Vista及更高版本的默认设置），系统收藏夹卷将不会显示在VeraCrypt应用程序主窗口的驱动器号列表中。

### To configure a VeraCrypt volume as a system favorite volume, follow these steps: 要将VeraCrypt加密卷配置为系统收藏夹加密卷，请按照以下步骤操作：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select ‘*Add to System Favorites*’. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到系统收藏夹*”。
3. The System Favorites Organizer window should appear now. In this window, enable the option ‘*Mount system favorite volumes when Windows starts*’ and click *OK*. 
   现在应该出现“系统收藏夹管理器”窗口。在此窗口中，启用选项“*Mount system favorite volumes when Windows starts*”并单击 *好*的.

The order in which system favorite volumes are displayed in the System Favorites Organizer window (*Favorites* > ‘*Organize System Favorite Volumes*’) is **the order in which the volumes are mounted**. You can use the *Move Up* and *Move Down* buttons to change the order of the volumes.
系统收藏夹卷在“系统收藏夹管理器”窗口（*收藏夹*>“*组织系统收藏夹*"）中的显示顺序是**卷的装入顺序**。您可以使用 *上移*和*下移*按钮可更改卷的顺序。

A special label can be assigned to each system favorite volume. This  label is not the same as the filesystem label and it is shown within the VeraCrypt user interface instead of the volume path. To assign such a  label, follow these steps:
可以为每个系统收藏夹卷分配一个特殊标签。该标签与文件系统标签不同，它显示在VeraCrypt用户界面中，而不是卷路径中。要分配这样的标签，请执行以下步骤：

1. Select *Favorites* > ‘*Organize System Favorite Volumes*’. 
   选择“*收藏夹*”>“*组织系统收藏夹*”。
2. The System Favorites Organizer window should appear now. In this window, select the volume whose label you want to edit. 
   现在应该出现“系统收藏夹管理器”窗口。在此窗口中，选择要编辑其标签的卷。
3. Enter the label in the ‘*Label of selected favorite volume*’ input field and click OK. 
   在“*选定收藏卷的标签*”输入字段中输入标签，然后单击确定。

Note that the System Favorites Organizer window (*Favorites* > ‘*Organize System Favorite Volumes*’) allows you to **set various options for each system favorite volume**. For example, any of them can be mounted as read-only or as removable medium.
请注意，“系统收藏夹管理器”窗口（*收藏夹*>“*组织系统收藏夹管理器*”）允许您 **为每个系统收藏卷设置各种选项**。例如，它们中的任何一个都可以安装为只读或可移动介质。

 Warning: When the drive letter assigned to a system favorite volume  (saved in the configuration file) is not free, the volume is not mounted and no error message is displayed.
警告：当分配给系统收藏夹卷（保存在配置文件中）的驱动器号不可用时，将不会装入该卷，也不会显示任何错误消息。

 Note that Windows needs to use some files (e.g. paging files, Active  Directory files, etc.) before system favorite volumes are mounted.  Therefore, such files cannot be stored on system favorite volumes. Note, however, that they *can* be stored on any partition that is within the key scope of system  encryption (e.g. on the system partition or on any partition of a system drive that is entirely encrypted by VeraCrypt).
请注意，Windows需要使用某些文件（例如，分页文件，Active Directory文件等）。安装系统收藏夹卷之前。因此，此类文件不能存储在系统收藏夹卷上。但是，请注意， *可以*存储在系统加密密钥范围内的任何分区上（例如，在系统分区上或在完全由VeraCrypt加密的系统驱动器的任何分区上）。

 **To remove a volume from the list of system favorite volumes**, select *Favorites* > *Organize System Favorite Volumes*, select the volume, click *Remove*, and click OK.
**要从系统收藏夹卷列表中删除卷**，请选择 *收藏夹*>*组织系统收藏夹“*，选择卷，单击 *删除*，然后单击“确定”。

# System Encryption 系统加密

VeraCrypt can on-the-fly encrypt a system partition or entire system  drive, i.e. a partition or drive where Windows is installed and from  which it boots.
VeraCrypt可以动态加密系统分区或整个系统驱动器，即安装Windows并从中引导的分区或驱动器。

System encryption provides the highest level of security and privacy,  because all files, including any temporary files that Windows and  applications create on the system partition (typically, without your  knowledge or consent), hibernation files, swap files, etc., are always permanently encrypted (even when power supply is  suddenly interrupted). Windows also records large amounts of potentially sensitive data, such as the names and locations of files you open,  applications you run, etc. All such log files and registry entries are always permanently encrypted as well.
系统加密提供了最高级别的安全性和隐私性，因为所有文件，包括Windows和应用程序在系统分区上创建的任何临时文件（通常在您不知情或未经同意的情况下），休眠文件，交换文件等，始终永久加密（即使电源突然中断）。Windows还记录大量潜在的敏感数据，例如您打开的文件的名称和位置，您运行的应用程序等。所有此类日志文件和注册表项也始终被永久加密。

**Note on SSDs and TRIM:** When using system encryption on SSDs, it's important to consider the  implications of the TRIM operation, which can potentially reveal  information about which sectors on the drive are not in use. For  detailed guidance on how TRIM operates with VeraCrypt and how to manage  its settings for enhanced security, please refer to the [TRIM Operation](https://veracrypt.fr/en/Trim Operation.html) documentation. 
**关于SSD和TRIM的说明：** 在SSD上使用系统加密时，重要的是要考虑TRIM操作的影响，这可能会泄露有关驱动器上哪些扇区未使用的信息。有关TRIM如何与VeraCrypt一起操作以及如何管理其设置以增强安全性的详细指南，请参阅[TRIM操作](https://veracrypt.fr/en/Trim Operation.html)文档。

System encryption involves pre-boot authentication, which means that  anyone who wants to gain access and use the encrypted system, read and  write files stored on the system drive, etc., will need to enter the  correct password each time before Windows boots (starts). Pre-boot authentication is handled by the VeraCrypt Boot  Loader, which resides in the first track of the boot drive and on the [ VeraCrypt Rescue Disk (see below)](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html).
系统加密涉及预启动身份验证，这意味着任何想要访问和使用加密系统，读取和写入存储在系统驱动器上的文件等的人，每次启动Windows之前都需要输入正确的密码 （开始）。预靴子认证由VeraCrypt靴子加载程序处理，它位于靴子驱动器的第一个磁道和 [VeraCrypt救援盘（见下文）](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html).

Note that VeraCrypt can encrypt an existing unencrypted system  partition/drive in-place while the operating system is running (while  the system is being encrypted, you can use your computer as usual  without any restrictions). Likewise, a VeraCrypt-encrypted system partition/drive can be decrypted in-place while the operating  system is running. You can interrupt the process of encryption or  decryption anytime, leave the partition/drive partially unencrypted,  restart or shut down the computer, and then resume the process, which will continue from the point it was stopped.
请注意，VeraCrypt可以在操作系统运行时对现有的未加密系统分区/驱动器进行加密（当系统被加密时，您可以像往常一样使用您的计算机，没有任何限制）。同样，VeraCrypt加密的系统分区/驱动器可以在操作系统运行时就地解密。您可以随时中断加密或解密过程，保留部分未加密的分区/驱动器，重新启动或关闭计算机，然后恢复该过程，该过程将从停止点继续。

The mode of operation used for system encryption is [ XTS](https://veracrypt.fr/en/Modes of Operation.html) (see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)). For further technical details of system encryption, see the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) in the chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html).
用于系统加密的操作模式是[XTS](https://veracrypt.fr/en/Modes of Operation.html)（参见[操作模式](https://veracrypt.fr/en/Modes of Operation.html)一节）。有关系统加密的更多技术细节，请参见 [技术细节](https://veracrypt.fr/en/Technical Details.html)一章中[的加密方案](https://veracrypt.fr/en/Encryption Scheme.html)。

To encrypt a system partition or entire system drive, select  *System* > *Encrypt System Partition/Drive* and then follow the instructions in the wizard. To decrypt a system partition/drive, select *System* > *Permanently Decrypt System Partition/Drive*.
要加密系统分区或整个系统驱动器，请选择*系统*>*加密系统分区/驱动器*，然后按照向导中的说明进行操作。要解密系统分区/驱动器，请选择 *系统*>*永久解密系统分区/驱动器*。

Because of BIOS requirement, the pre-boot password is typed using **US keyboard layout.** During the system encryption process, VeraCrypt automatically  and transparently switches the keyboard to US layout in order to ensure  that the password value typed will match the one typed in pre-boot mode.  However, pasting the password from the clipboard can override this  protective measure. To prevent any issues arising from this discrepancy, VeraCrypt disables the option to paste passwords from the clipboard in  the system encryption wizard.  Thus, when setting or entering your password, it's crucial to type it  manually using the same keys as when creating the system encryption,  ensuring consistent access to your encrypted system.
由于BIOS的要求，预启动密码是使用**美国键盘布局键入的。**在系统加密过程中，VeraCrypt会自动透明地将键盘切换为美式键盘，以确保输入的密码值与预启动模式下输入的密码值一致。但是，从剪贴板粘贴密码可以覆盖此保护措施。为了防止这种差异引起的任何问题，VeraCrypt在系统加密向导中禁用了从剪贴板粘贴密码的选项。因此，在设置或输入密码时，使用与创建系统加密时相同的密钥手动输入密码至关重要，以确保对加密系统的一致访问。

Note: By default, Windows 7 and later boot from a special small partition.  The partition contains files that are required to boot the system.  Windows allows only applications that have administrator privileges to  write to the partition (when the system is running). In EFI boot mode, which is the default on modern PCs,  VeraCrypt can not encrypt this partition since it must remain  unencrypted so that the BIOS can load the EFI bootloader from it. This  in turn implies that in EFI boot mode, VeraCrypt offers only to encrypt  the system partition where Windows is installed (the user can later  manually encrypt other data partitions using VeraCrypt). In MBR legacy boot mode, VeraCrypt encrypts the partition only if you  choose to encrypt the whole system drive (as opposed to choosing to  encrypt only the partition where Windows is installed).
注意：默认情况下，Windows  7和更高版本从一个特殊的小分区靴子引导。分区包含靴子引导系统所需的文件。Windows只允许具有管理员权限的应用程序写入分区（当系统运行时）。在Windows靴子引导模式下（这是现代电脑的默认模式），VeraCrypt不能加密这个分区，因为它必须保持未加密状态，以便BIOS可以从它加载Windows引导加载程序。这反过来意味着在Windows靴子模式下，VeraCrypt只提供加密安装Windows的系统分区（用户可以稍后使用VeraCrypt手动加密其他数据分区）。在MBR传统靴子模式下，VeraCrypt仅在您选择加密整个系统驱动器时才加密分区（而不是选择只加密安装Windows的分区）。

# Hidden Operating System 隐藏操作系统

It may happen that you are forced by somebody to decrypt the operating  system. There are many situations where you cannot refuse to do so (for  example, due to extortion). VeraCrypt allows you to create a hidden  operating system whose existence should be impossible to prove (provided that certain guidelines are followed). Thus, you  will not have to decrypt or reveal the password for the hidden operating system. For more information, see the section [ Hidden Operating System](https://veracrypt.fr/en/VeraCrypt Hidden Operating System.html) in the chapter [ Plausible Deniability](https://veracrypt.fr/en/Plausible Deniability.html).
它可能发生，你被迫由某人解密操作系统.在很多情况下，你不能拒绝这样做（例如，由于勒索）。VeraCrypt允许您创建一个隐藏的操作系统，它的存在应该是不可能的 证明（只要遵循一定的准则）。因此，您不必解密或透露隐藏操作系统的密码。有关更多信息，请参阅部分 [隐藏的操作系统](https://veracrypt.fr/en/VeraCrypt Hidden Operating System.html)在章节[合理的否认](https://veracrypt.fr/en/Plausible Deniability.html)。

# Operating Systems Supported for System Encryption 支持系统加密的操作系统


 VeraCrypt can currently encrypt the following operating systems:
VeraCrypt目前可以加密以下操作系统：

- Windows 11 
- Windows 10 

Note: The following operating systems (among others) are not supported:  Windows RT, Windows 2003 IA-64, Windows 2008 IA-64, Windows XP IA-64,  and the Embedded/Tablet versions of Windows. 
注意事项：不支持以下操作系统：Windows RT、Windows 2003 IA-64、Windows 2008 IA-64、Windows XP IA-64和Windows的嵌入式/平板电脑版本。

Also see the section [ Supported Operating Systems](https://veracrypt.fr/en/Supported Operating Systems.html)
另请参阅[支持的操作系统](https://veracrypt.fr/en/Supported Operating Systems.html)部分

# VeraCrypt Rescue Disk VeraCrypt救援盘

During the process of preparing the encryption of a system  partition/drive, VeraCrypt requires that you create a so-called  VeraCrypt Rescue Disk (USB disk in EFI boot mode, CD/DVD in MBR legacy  boot mode), which serves the following purposes:
在准备加密系统分区/驱动器的过程中，VeraCrypt要求您创建一个所谓的VeraCrypt救援盘（USB盘在备份靴子引导模式，CD/DVD在MBR传统靴子模式），用于以下目的：

- If the VeraCrypt Boot Loader screen does not appear after you start your computer (or if Windows does not boot), the **VeraCrypt Boot Loader may be damaged**. The VeraCrypt Rescue Disk allows you restore it and thus to regain  access to your encrypted system and data (however, note that you will  still have to enter the correct password then). For EFI boot mode, select *Restore VeraCrypt loader binaries to system disk* in the Rescue Disk screen. For MBR legacy boot mode, select instead *Repair Options* > *Restore VeraCrypt Boot Loader*. Then press 'Y' to confirm the action, remove the Rescue Disk from your USB port or CD/DVD drive and restart your computer. 
  如果VeraCrypt靴子Loader屏幕在您启动计算机后没有出现（或者如果Windows没有靴子引导）， **VeraCrypt靴子Loader可能损坏**。VeraCrypt救援盘允许您恢复它，从而重新访问您的加密系统和数据（但是，请注意，您仍然需要输入正确的密码）。在恢复靴子模式下，在救援盘屏幕中选择*将VeraCrypt加载程序二进制文件恢复到系统盘*。对于MBR传统靴子模式，选择*修复选项*> *恢复VeraCrypt靴子加载程序*。然后按“Y”确认操作，从USB端口或CD/DVD驱动器中取出救援盘，然后重新启动计算机。
- If the **VeraCrypt Boot Loader is frequently damaged** (for example, by inappropriately designed activation software) or if  **you do not want the VeraCrypt boot loader** **to reside on the hard drive** (for example, if you want to use an alternative boot  loader/manager for other operating systems), you can boot directly from  the VeraCrypt Rescue Disk (as it contains the VeraCrypt boot loader too) without restoring the boot loader to the hard drive. For EFI boot mode, just insert your Rescue Disk into a USB port, boot  your computer on it and then select *Boot VeraCrypt loader from rescue disk* on the Rescue Disk screen. For MBR legacy boot mode, you need to insert the Rescue Disk in your CD/DVD drive and then enter your password in  the Rescue Disk screen. 
  如果**VeraCrypt靴子加载程序经常损坏**（例如，被设计不当的激活软件损坏）或者**您不希望VeraCrypt靴子加载****程序驻留在硬盘上**（例如，您想使用其他操作系统的替代靴子加载程序/管理器），您可以直接从VeraCrypt救援盘（因为它也包含VeraCrypt靴子加载程序）进行靴子，而无需将靴子加载程序恢复到硬盘。在安全靴子模式下，只需将救援盘插入USB端口，靴子电脑，然后在救援盘屏幕上选择*从救援盘靴子VeraCrypt加载程序*。对于MBR传统靴子模式，您需要将修复盘插入CD/DVD驱动器，然后在修复盘屏幕中输入密码。
- If you repeatedly enter the correct password but VeraCrypt says that the password is incorrect, it is possible that the **master key or other critical data are damaged**. The VeraCrypt Rescue Disk allows you to restore them and thus to regain access to your encrypted system and data (however, note that you will  still have to enter the correct password then). For EFI boot mode, select *Restore OS header keys* in the Rescue Disk screen. For MBR legacy boot mode, select instead *Repair Options* > *Restore VeraCrypt Boot Loader*. Then enter your password, press 'Y' to confirm the action, remove the  Rescue Disk from the USB port or CD/DVD drive, and restart your  computer.
  如果您反复输入正确的密码，但VeraCrypt说密码不正确，那么有可能 **主密钥或其他关键数据被损坏**。VeraCrypt救援盘允许您恢复它们，从而重新获得对加密系统和数据的访问权限（但是，请注意，您仍然需要输入正确的 密码）。对于恢复靴子模式，请在“修复盘”屏幕中选择*“恢复操作系统头密钥”*。对于MBR传统靴子模式，选择*修复选项*> *恢复VeraCrypt靴子加载程序*。然后输入密码，按“Y”确认操作，从USB端口或CD/DVD驱动器中取出救援盘，然后重新启动计算机。
  
   Note: This feature cannot be used to restore the header of a hidden volume within which a [ hidden operating system](https://veracrypt.fr/en/Hidden Operating System.html) resides (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)). To restore such a volume header, click  *Select Device*, select the partition behind the decoy system partition, click *OK*, select *Tools* > *Restore Volume Header* and then follow the instructions.
  注意：此功能不能用于恢复隐藏卷的标题，其中 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)驻留（请参阅[隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)部分）。要恢复这样的卷头，请单击*选择设备*，选择诱饵系统分区后面的分区，单击 *确定*，选择*工具*> *恢复卷头*，然后按照说明进行操作。
  
   WARNING: By restoring key data using a VeraCrypt Rescue Disk, you also  restore the password that was valid when the VeraCrypt Rescue Disk was  created. Therefore, whenever you change the password, you should destroy your VeraCrypt Rescue Disk and create a new one (select *System* ->  *Create Rescue Disk*). Otherwise, if an attacker knows your old  password (for example, captured by a keystroke logger) and if he then  finds your old VeraCrypt Rescue Disk, he could use it to restore the key data (the master key encrypted with the old password) and thus decrypt your system partition/drive 
  恢复：通过使用VeraCrypt救援盘恢复密钥数据，您还可以恢复创建VeraCrypt救援盘时有效的密码。因此，每当您更改密码时，您应该销毁您的VeraCrypt救援盘并创建一个新的 一（选择*系统*->*创建救援盘*）。否则，如果攻击者知道您的旧密码（例如，被黑客记录器捕获），然后他发现了您的旧VeraCrypt救援盘，他可以使用它来恢复密钥数据（使用旧密码加密的主密钥） 从而解密您的系统分区/驱动器
- If **Windows is damaged and cannot start** after typing the correct password on VeraCrypt password prompt, the  VeraCrypt Rescue Disk allows you to permanently decrypt the  partition/drive before Windows starts. For EFI boot, select *Decrypt OS* in the Rescue Disk screen. For MBR legacy boot mode, select instead *Repair Options* >  *Permanently decrypt system partition/drive*. Enter the correct  password and wait until decryption is complete. Then you can e.g. boot  your MS Windows setup CD/DVD to repair your Windows installation. Note  that this feature cannot be used to decrypt a hidden volume within which a [ hidden operating system](https://veracrypt.fr/en/Hidden Operating System.html) resides (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)).
  如果**Windows损坏，在**VeraCrypt密码提示符输入正确密码后无法启动，VeraCrypt救援盘允许您在Windows启动前永久解密分区/驱动器。对于“启动靴子”，选择 在救援盘屏幕中*解密操作系统*。对于MBR传统靴子模式，选择*修复选项*>*永久解密系统分区/驱动器*。输入正确的密码并等待解密完成。然后，您可以例如靴子您的MS Windows安装CD/DVD修复您的Windows安装。请注意，此功能不能用于解密隐藏的 一个[隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)所在的卷（参见[隐藏的操作系统一](https://veracrypt.fr/en/Hidden Operating System.html)节）。
  
   Note: Alternatively, if Windows is damaged (cannot start) and you need  to repair it (or access files on it), you can avoid decrypting the  system partition/drive by following these steps: If you have multiple  operating systems installed on your computer, boot the one that does not require pre-boot authentication. If you do  not have multiple operating systems installed on your computer, you can  boot a WinPE or BartPE CD/DVD or a Linux Live CD/DVD/USB. You can also  connect your system drive as a secondary or external drive to another  computer and then boot the operating system installed on the computer. After you boot a system, run VeraCrypt, click Select Device, select the affected  system partition, click OK , select System > Mount Without Pre-Boot  Authentication, enter your pre-boot-authentication password and click OK. The partition will be mounted as a regular  VeraCrypt volume (data will be on-the-fly decrypted/encrypted in RAM on  access, as usual). 
  注意事项：或者，如果Windows损坏（无法启动），您需要修复它（或访问其上的文件），您可以通过以下步骤避免解密系统分区/驱动器：如果您的计算机上安装了多个操作系统， 靴子不需要预靴子身份验证的方法。如果您的计算机上没有安装多个操作系统，则可以靴子引导WinPE或BartPE CD/DVD或Linux Live CD/DVD/USB。您还可以将系统驱动器作为辅助或外部驱动器连接到另一台计算机 然后靴子启动计算机上安装的操作系统。靴子系统后，运行VeraCrypt，点击选择设备，选择受影响的系统分区，点击确定，选择系统%3 E挂载无预靴子身份验证，输入预靴子身份验证 密码，然后单击“确定”。该分区将被安装为常规VeraCrypt卷（数据将像往常一样在访问时在RAM中进行动态解密/加密）。
- In case of MBR legacy boot mode, your VeraCrypt Rescue Disk contains a **backup of the original content of the first drive track** (made before the VeraCrypt Boot Loader was written to it) and allows you to restore it if necessary. The first track typically contains a system loader or boot manager. In the Rescue Disk screen, select Repair Options > Restore original system loader. 
  在MBR遗留靴子模式下，您的VeraCrypt救援盘包含**第一个驱动器磁道的原始内容的备份**（在VeraCrypt靴子加载程序写入之前制作的），并允许您在必要时恢复它。第一轨道通常包含系统加载程序或靴子管理器。在“修复盘”屏幕中，选择“修复选项%3 E还原原始系统加载程序”。

 

*Note that even if you lose your VeraCrypt Rescue Disk and an attacker finds it, he or she will **not** be able to decrypt the system partition or drive without the correct password.
请注意，即使您丢失了VeraCrypt救援盘并且被攻击者找到，他或她也会 **无法**解密系统分区或驱动器没有正确的密码.*

To boot a VeraCrypt Rescue Disk, insert it into a USB port or your  CD/DVD drive depending on its type and restart your computer. If the  VeraCrypt Rescue Disk screen does not appear (or in case of MBR legacy  boot mode if you do not see the 'Repair Options' item in the 'Keyboard  Controls' section of the screen), it is possible that your BIOS is configured to attempt to boot from hard drives before USB drivers and CD/DVD drives. If that is the case, restart your  computer, press F2 or Delete (as soon as you see a BIOS start-up  screen), and wait until a BIOS configuration screen appears. If no BIOS configuration screen appears, restart (reset) the computer again and  start pressing F2 or Delete repeatedly as soon as you restart (reset)  the computer. When a BIOS configuration screen appears, configure your  BIOS to boot from the USB drive and CD/DVD drive first (for information on how to do so, please refer to the documentation for your BIOS/motherboard or contact your computer vendor's technical support  team for assistance). Then restart your computer. The VeraCrypt Rescue  Disk screen should appear now. Note: In the case of MBR legacy boot mode, you can select 'Repair Options' on the  VeraCrypt Rescue Disk screen by pressing F8 on your keyboard.
要靴子VeraCrypt救援盘，请根据其类型将其插入USB端口或CD/DVD驱动器，然后重新启动计算机。如果VeraCrypt救援盘屏幕没有出现（或者在MBR传统靴子模式下，如果您在屏幕的“键盘控制”部分没有看到“修复选项”项），可能是您的BIOS被配置为尝试从硬盘启动，然后再从USB驱动器和CD/DVD驱动器启动。如果是这种情况，请重新启动计算机，按F2或Delete（一旦看到BIOS启动屏幕），然后等待BIOS配置屏幕出现。如果没有出现BIOS配置屏幕，请重新启动（重置）计算机，并在重新启动（重置）计算机后立即开始重复按F2或Delete。  出现BIOS配置屏幕时，请将BIOS配置为首先从USB驱动器和CD/DVD驱动器进行靴子引导（有关如何执行此操作的信息，请参阅BIOS/主板的文档或联系计算机供应商的技术支持团队以获得帮助）。然后重新启动计算机。VeraCrypt救援盘屏幕应该会出现。注意：在MBR遗留靴子模式下，您可以在VeraCrypt救援盘屏幕上按F8键选择“修复选项”。

If your VeraCrypt Rescue Disk is damaged, you can create a new one by selecting *System* > *Create Rescue Disk*. To find out whether your VeraCrypt Rescue Disk is damaged, insert it  into a USB port (or into your CD/DVD drive in case of MBR legacy boot  mode) and select *System* > *Verify Rescue Disk*.
如果您的VeraCrypt救援盘已损坏，您可以选择创建一个新的 *系统*>*创建修复盘*。要查看您的VeraCrypt救援盘是否损坏，请将其插入USB端口（或者在MBR传统靴子引导模式下插入CD/DVD驱动器），然后选择 *系统*>*验证修复盘*。

## VeraCrypt Rescue Disk for MBR legacy boot mode on USB Stick VeraCrypt USB记忆棒MBR旧靴子模式救援盘

It is also possible to create a VeraCrypt Rescue Disk for MBR legacy  boot mode on a USB drive, in case your machine does not have a CD/DVD  drive. **Please note that you must ensure that the data on the USB stick is not  overwritten! If you lose the USB drive or your data is damaged, you will not be able to recover your system in case of a problem!**
如果您的机器没有CD/DVD驱动器，也可以在USB驱动器上创建MBR传统靴子引导模式的VeraCrypt救援盘。**请注意，您必须确保USB记忆棒上的数据不会被覆盖！如果您丢失了USB驱动器或您的数据损坏，您将无法在出现问题时恢复系统！**

To create a bootable VeraCrypt Rescue USB drive you have to create a  bootable USB drive which bootloader runs up the iso image. Solutions  like Unetbootin, which try to copy the data inside the iso image to the  usb drive do not work yet. On Windows please follow the steps below: 
要创建一个可引导的VeraCrypt Rescue U盘，您必须创建一个可引导的U盘，引导程序运行iso镜像。像Unetbootin这样的解决方案，试图将iso映像中的数据复制到usb驱动器中，但还不起作用。在Windows上，请按照以下步骤操作：

- ​		Download the required files from the official SourceForge repository of VeraCrypt: [ 		https://sourceforge.net/projects/veracrypt/files/Contributions/VeraCryptUsbRescueDisk.zip](https://sourceforge.net/projects/veracrypt/files/Contributions/VeraCryptUsbRescueDisk.zip)
  从VeraCrypt官方SourceForge资源库下载所需文件：https://sourceforge.net/projects/veracrypt/files/Contributions/VeraCryptUsbRescueDisk.zip 

- ​		Insert a USB drive.  插入USB驱动器。

- ​		Format the USB drive with FAT16 oder FAT32: 	

  
  格式化USB驱动器与FAT 16或FAT32：

  - ​				Launch usb_format.exe as an administrator (right click "Run as Administrator"). 		
    以管理员身份启动usb_format.exe（右键单击“以管理员身份运行”）。
  - ​				Select your USB drive in the Device list. 		
    在设备列表中选择您的USB驱动器。
  - ​				Choose FAT as filesystem and check "Quick Format". Click Start. 		
    选择FAT作为文件系统，并勾选“快速格式化”。单击开始。

- ​		Create a bootloader which can start up an iso image: 	

  
  创建一个可以启动iso镜像的bootloader：

  - ​				Launch grubinst_gui.exe. 		 启动grubinst_gui. exe。
  - ​				Check "Disk" and then select your USB drive in the list. 		
    勾选“磁盘”，然后在列表中选择您的USB驱动器。
  - ​				Click the "Refresh" button in front of "Part List" and then choose "Whole disk (MBR)". 		
    点击“部件列表”前面的“刷新”按钮，然后选择“整个磁盘（MBR）"。
  - ​				Leave all other options unchanged and then click "Install". 		
    保持所有其他选项不变，然后单击“安装”。
  - ​				You should see an console window that reads "The MBR/BS has been  successfully installed. Press <ENTER> to continue ..." 		
    您应该看到一个控制台窗口，显示“MBR/BS已成功安装。按<ENTER>继续... "
  - ​				Close the tool. 		 关闭工具。

- ​		Copy the file "grldr" to your USB drive at the root (e.g. if the drive letter is I:, you should have I:\grldr). This file loads Grub4Dos. 
  将文件“grldr”复制到USB驱动器的根目录下（例如，如果驱动器号为I：，则应该为I：\grldr）。此文件加载Grub 4Dos。

- ​		Copy the file "menu.lst" to your USB drive at the root (e.g. if the  drive letter is I:, you should have I:\menu.lst). This file configures  the shown menu and its options. 
  将文件“menu.lst”复制到U盘的根目录下（例如，如果驱动器号为I：，则应该为I：\menu.lst）。此文件配置显示的菜单及其选项。

- ​		Copy the rescue disk file "VeraCrypt Rescue Disk.iso" to the USB drive at the root and rename it "veracrypt.iso". Another possibility is to  change the link in the "menu.lst" file. 
  将救援盘文件“VeraCrypt Rescue. iso”复制到U盘的根目录下，并将其重命名为“veracrypt.iso”。另一种可能性是更改“menu.lst”文件中的链接。

# Plausible Deniability 合理推诿

In case an adversary forces you to reveal your password, VeraCrypt provides and supports two kinds of plausible deniability:
如果攻击者强迫您透露密码，VeraCrypt提供并支持两种合理的可否认性：

1. Hidden volumes (see the section [ Hidden Volume](https://veracrypt.fr/en/Hidden Volume.html)) and hidden operating systems (see the section [ **Hidden Operating System**](https://veracrypt.fr/en/Hidden Operating System.html)). 
   隐藏卷（参见[隐藏卷一](https://veracrypt.fr/en/Hidden Volume.html)节）和隐藏操作系统（参见[**隐藏操作系统**](https://veracrypt.fr/en/Hidden Operating System.html)一节）。
2. Until decrypted, a VeraCrypt partition/device appears to consist of  nothing more than random data (it does not contain any kind of  "signature"). Therefore, it should be impossible to prove that a  partition or a device is a VeraCrypt volume or that it has been encrypted (provided that the security requirements and precautions  listed in the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html) are followed). A possible  plausible explanation for the existence of a partition/device containing solely random data is that you have wiped (securely erased) the content of the partition/device using one of the tools that erase data by overwriting it with random data (in fact, VeraCrypt  can be used to securely erase a partition/device too, by creating an  empty encrypted partition/device-hosted volume within it). However, you  need to prevent data leaks (see the section [ Data Leaks](https://veracrypt.fr/en/Data Leaks.html)) and also note that, for [ system encryption](https://veracrypt.fr/en/System Encryption.html), the first drive track contains the (unencrypted)  VeraCrypt Boot Loader, which can be easily identified as such (for more  information, see the chapter [ System Encryption](https://veracrypt.fr/en/System Encryption.html)). When using [ system encryption](https://veracrypt.fr/en/System Encryption.html), plausible deniability can be achieved by creating a hidden operating system (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)).
   在解密之前，VeraCrypt分区/设备看起来只不过是由随机数据组成（它不包含任何类型的“签名”）。因此，要证明一个分区或设备是VeraCrypt加密卷或已经被加密是不可能的 加密（前提是本章中列出的安全要求和预防措施 遵守[安全要求和注意事项](https://veracrypt.fr/en/Security Requirements and Precautions.html)）。对于存在只包含随机数据的分区/设备，一个可能的合理解释是，您已使用其中一种工具擦除（安全擦除）分区/设备的内容 通过随机加密来擦除数据（事实上，VeraCrypt也可以用来安全地擦除分区/设备，通过在其中创建一个空的加密分区/设备托管卷）。但是，您需要防止数据泄漏（请参见 [数据泄露](https://veracrypt.fr/en/Data Leaks.html)），同时也要注意，对于[系统加密](https://veracrypt.fr/en/System Encryption.html)，第一个驱动器磁道包含（未加密的）VeraCrypt靴子Loader，它可以很容易地被识别出来（更多信息，请参阅 [系统加密](https://veracrypt.fr/en/System Encryption.html)）。使用[系统加密](https://veracrypt.fr/en/System Encryption.html)时，可以通过创建隐藏的操作系统来实现合理的可否认性（请参见 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)）。
   
    Although file-hosted VeraCrypt volumes (containers) do not contain any  kind of "signature" either (until decrypted, they appear to consist  solely of random data), they cannot provide this kind of plausible  deniability, because there is practically no plausible explanation for the existence of a file containing solely random data.  However, plausible deniability can still be achieved with a file-hosted  VeraCrypt volume (container) by creating a hidden volume within it (see  above). 
   虽然文件托管的VeraCrypt加密卷（容器）也不包含任何类型的“签名”（直到解密，它们似乎只包含随机数据），但它们不能提供这种合理的可否认性，因为实际上没有合理的可否认性。 一个文件只包含随机数据的存在的解释。然而，通过在文件托管的VeraCrypt加密卷（容器）中创建一个隐藏加密卷（见上文），仍然可以实现合理的否认。

####   Notes 注意到

- When formatting a hard disk partition as a VeraCrypt volume (or  encrypting a partition in place), the partition table (including the  partition type) is *never* modified (no VeraCrypt "signature" or "ID" is written to the partition table). 
  当将硬盘分区格式化为VeraCrypt加密卷（或就地加密分区）时，分区表（包括分区类型） *从未*修改（没有VeraCrypt的“签名”或“ID”被写入分区表）。
- There are methods to find files or devices containing random data (such as VeraCrypt volumes). Note, however, that this should *not* affect plausible deniability in any way. The adversary still should not be able to *prove* that the partition/device is a VeraCrypt volume or that the file,  partition, or device, contains a hidden VeraCrypt volume (provided that  you follow the security requirements and precautions listed in the  chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html) and in the subsection [ Security Requirements and Precautions Pertaining to Hidden Volumes](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)). 
  有一些方法可以找到包含随机数据的文件或设备（例如VeraCrypt加密卷）。但是，请注意，这应该 *不会*影响合理的否认对手应该还不能 *证明*分区/设备是VeraCrypt加密卷，或者文件、分区或设备包含隐藏的VeraCrypt加密卷（前提是您遵守本章中列出的安全要求和注意事项 [安全要求和预防措施](https://veracrypt.fr/en/Security Requirements and Precautions.html)以及[与隐藏危险有关的安全要求和预防措施](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)）。

 Hidden Volume 隐藏加密卷

It may happen that you are forced by somebody to reveal the password to  an encrypted volume. There are many situations where you cannot refuse  to reveal the password (for example, due to extortion). Using a  so-called hidden volume allows you to solve such situations without revealing the password to your volume.
它可能发生，你被迫由某人透露密码加密卷.在许多情况下，您无法拒绝透露密码（例如，由于勒索）。使用所谓的隐藏卷可以让您解决这种情况，而不会泄露卷的密码。

![The layout of a standard VeraCrypt volume before and after a hidden volume was created within it.](https://veracrypt.fr/en/Beginner's Tutorial_Image_024.gif)

*The layout of a standard VeraCrypt volume before and after a hidden volume was created within it.
标准VeraCrypt加密卷在创建隐藏加密卷之前和之后的布局。*


 The principle is that a VeraCrypt volume is created within another  VeraCrypt volume (within the free space on the volume). Even when the  outer volume is mounted, it should be impossible to prove whether there  is a hidden volume within it or not*, because free space on *any* VeraCrypt volume is always filled with random data when the volume is created**  and no part of the (dismounted) hidden volume can be distinguished from  random data. Note that VeraCrypt does not modify the file system (information about free space, etc.) within the outer volume in  any way.
其原理是在另一个VeraCrypt加密卷中创建一个VeraCrypt加密卷（在加密卷的空闲空间内）。即使外部加密卷被挂载，也不可能证明其中是否有隐藏加密卷 *，因为*任何*VeraCrypt加密卷上的空闲空间在创建加密卷时总是被随机数据填充 **，并且隐藏加密卷的任何部分都无法与随机数据区分开来。注意VeraCrypt不会修改文件系统（关于可用空间的信息等）在外部空间里


 The password for the hidden volume must be substantially different from  the password for the outer volume. To the outer volume, (before creating the hidden volume within it) you should copy some sensitive-looking  files that you actually do NOT want to hide. These files will be there for anyone who would force you to hand over  the password. You will reveal only the password for the outer volume,  not for the hidden one. Files that really are sensitive will be stored  on the hidden volume.
隐藏卷的密码必须与外部卷的密码完全不同。到外部卷，（在创建隐藏卷之前）你应该复制一些你实际上不想隐藏的敏感文件。这些文件将在那里的任何人谁会强迫你交出密码。您将仅显示外部卷的密码，而不是隐藏卷的密码。真正敏感的文件将存储在隐藏卷上。

A hidden volume can be mounted the same way as a standard VeraCrypt volume: Click *Select File* or *Select Device* to select the outer/host volume (important: make sure the volume is  *not* mounted). Then click *Mount*, and enter the password for the hidden volume. Whether the hidden or the outer volume will be mounted is determined by the entered password  (i.e., when you enter the password for the outer volume, then the outer volume will be mounted; when you enter the  password for the hidden volume, the hidden volume will be mounted).
隐藏加密卷的安装方式与标准VeraCrypt加密卷相同：单击 *选择文件*或*选择设备*以选择外部/主机卷（重要信息：确保卷*未*装入）。然后单击*装载*，并输入隐藏卷的密码。是否安装隐藏卷或外部卷由输入的密码确定（即，当你输入外部卷的密码时，外部卷将被挂载;当你输入隐藏卷的密码时，隐藏卷将被挂载）。

VeraCrypt first attempts to decrypt the standard volume header using the entered password. If it fails, it loads the area of the volume where a  hidden volume header can be stored (i.e. bytes 65536–131071, which  contain solely random data when there is no hidden volume within the volume) to RAM and attempts to decrypt it  using the entered password. Note that hidden volume headers cannot be  identified, as they appear to consist entirely of random data. If the  header is successfully decrypted (for information on how VeraCrypt determines that it was successfully decrypted, see the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html)), the information about the size of the hidden  volume is retrieved from the decrypted header (which is still stored in  RAM), and the hidden volume is mounted (its size also determines its  offset).
VeraCrypt首先尝试使用输入的密码解密标准卷标头。如果失败，它会将可以存储隐藏卷标题的卷区域（即字节65536-131071，当卷内没有隐藏卷时，仅包含随机数据）加载到RAM，并尝试使用输入的密码对其进行解密。请注意，隐藏的卷头无法识别，因为它们似乎完全由随机数据组成。如果头文件被成功解密（关于VeraCrypt如何确定它被成功解密的信息，请参阅[加密方案一](https://veracrypt.fr/en/Encryption Scheme.html)节），隐藏卷的大小信息将从解密的头文件中获取（仍然存储在RAM中），隐藏卷将被挂载（它的大小也决定了它的偏移量）。

A hidden volume can be created within any type of VeraCrypt volume,  i.e., within a file-hosted volume or partition/device-hosted volume  (requires administrator privileges). To create a hidden VeraCrypt  volume, click on *Create Volume* in the main program window and select *Create a hidden VeraCrypt volume*. The Wizard will provide help and all information necessary to successfully create a hidden VeraCrypt volume.
隐藏加密卷可以在任何类型的VeraCrypt加密卷中创建，例如，在文件托管卷或分区/设备托管卷中（需要管理员权限）。要创建一个隐藏的VeraCrypt加密卷，点击 在主程序窗口中*创建卷*，然后选择 *创建一个隐藏的VeraCrypt加密卷*。向导将提供帮助和所有必要的信息来成功创建一个隐藏的VeraCrypt加密卷。

When creating a hidden volume, it may be very difficult or even  impossible for an inexperienced user to set the size of the hidden  volume such that the hidden volume does not overwrite data on the outer  volume. Therefore, the Volume Creation Wizard automatically scans the cluster bitmap of the outer volume (before the hidden volume  is created within it) and determines the maximum possible size of the  hidden volume.***
当创建隐藏卷时，对于没有经验的用户来说，设置隐藏卷的大小以使得隐藏卷不覆盖外部卷上的数据可能是非常困难的或者甚至是不可能的。因此，卷创建向导会自动扫描外部卷的群集位图（在其中创建隐藏卷之前），并确定隐藏卷的最大可能大小。*

If there are any problems when creating a hidden volume, refer to the chapter [ Troubleshooting](https://veracrypt.fr/en/Troubleshooting.html) for possible solutions.
如果在创建隐藏卷时出现任何问题，请参阅故障排除一章以获取可能的解决方案。


 Note that it is also possible to create and boot an operating system residing in a hidden volume (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html) in the chapter [ Plausible Deniability](https://veracrypt.fr/en/Plausible Deniability.html)).
请注意，也可以创建并靴子驻留在隐藏卷中的操作系统（请参见 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)在章节[似是而非的否认](https://veracrypt.fr/en/Plausible Deniability.html)）。

------

\* Provided that all the instructions in the VeraCrypt Volume Creation  Wizard have been followed and provided that the requirements and  precautions listed in the subsection [ Security Requirements and Precautions Pertaining to Hidden Volumes](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) are followed
\* 前提是遵循VeraCrypt加密卷创建向导中的所有说明，并满足以下小节中列出的要求和注意事项 遵循[与隐藏的恶意软件有关的安全要求和预防措施](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)*.*
 ** Provided that the options *Quick Format* and *Dynamic* are disabled and provided that the volume does not contain a filesystem that has been encrypted in place (VeraCrypt does not allow the user to  create a hidden volume within such a volume). For information on the method used to fill free  volume space with random data, see chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html), section [ VeraCrypt Volume Format Specification](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)
** 前提是快速格式化和动态选项被禁用，并且卷中不包含已加密的文件系统（VeraCrypt不允许用户在这样的卷中创建隐藏卷）。关于用随机数据填充加密卷空间的方法，请参阅VeraCrypt加密卷格式规范技术细节一章*.*
 *** The wizard scans the cluster bitmap to determine the size of the  uninterrupted area of free space (if there is any) whose end is aligned  with the end of the outer volume. This area accommodates the hidden volume and therefore the size of this area limits the  maximum possible size of the hidden volume. On Linux and Mac OS X, the  wizard actually does not scan the cluster bitmap, but the driver detects any data written to the outer volume and uses their position as previously described.
\*  向导将扫描群集位图，以确定末端与外部卷末端对齐的未中断可用空间区域（如果有）的大小。该区域容纳隐藏卷，因此该区域的大小限制了隐藏卷的最大可能大小。在Linux和Mac OS X上，向导实际上不扫描群集位图，但驱动程序会检测写入外部卷的任何数据，并使用它们的位置，如前所述。

# Protection of Hidden Volumes Against Damage 保护隐藏的设备免受损坏

If you mount a VeraCrypt volume within which there is a [ hidden volume](https://veracrypt.fr/en/Hidden Volume.html), you may *read* data stored on the (outer) volume without any risk. However, if you (or the operating system) need to *save* data to the outer volume, there is a risk that the hidden volume will  get damaged (overwritten). To prevent this, you should protect the  hidden volume in a way described in this section.
如果您挂载的VeraCrypt加密卷内有一个[隐藏加密卷](https://veracrypt.fr/en/Hidden Volume.html)，您可以*读取*存储在（外部）加密卷上的数据而不会有任何风险。但是，如果您（或操作系统）需要 *将数据保存*到外部卷，隐藏卷就有损坏（覆盖）的风险。为了防止这种情况，您应该按照本节中描述的方式保护隐藏卷。

When mounting an outer volume, type in its password and before clicking  *OK,* click *Mount Options*:
挂载外部卷时，请键入其密码，然后在单击*确定之前，*单击*挂载选项*：

![VeraCrypt GUI](https://veracrypt.fr/en/Protection of Hidden Volumes_Image_027.jpg)

 

In the *Mount Options* dialog window, enable the option '*Protect hidden volume against damage caused by writing to outer volume* '. In the '*Password to hidden volume*' input field, type the password for the hidden volume. Click  *OK* and, in the main password entry dialog, click  *OK*.
在*挂载选项*对话框窗口中，启用选项“*保护隐藏卷免受写入外部卷造成的损坏*”。在“*隐藏卷密码*”输入字段中，键入隐藏卷的密码。单击*确定*，然后在主密码输入对话框中单击*确定*。

![Mounting with hidden protection](https://veracrypt.fr/en/Protection of Hidden Volumes_Image_028.jpg)



 Both passwords must be correct; otherwise, the outer volume will not be  mounted. When hidden volume protection is enabled, VeraCrypt does *not* actually mount the hidden volume. It only decrypts its header (in RAM)  and retrieves information about the size of the hidden volume (from the  decrypted header). Then, the outer volume is mounted and any attempt to  save data to the area of the hidden volume will be rejected (until the outer volume is dismounted). **Note that VeraCrypt never modifies the filesystem (e.g., information about  allocated clusters, amount of free space, etc.) within the outer volume  in any way. As soon as the volume is dismounted, the protection is lost. When the volume is mounted again, it is not possible to determine whether  the volume has used hidden volume protection or not. The hidden volume  protection can be activated only by users who supply the correct  password (and/or keyfiles) for the hidden volume (each time they mount the outer volume). 
两个密码都必须正确;否则，外部卷将无法装入。当隐藏加密卷保护被启用时，VeraCrypt \*而不是\*实际挂载隐藏卷。它只解密它的头（在RAM中），并检索有关隐藏卷大小的信息（从解密的头）。然后，外部卷被挂载，任何试图保存 数据到隐藏体积的区域将被拒绝（直到外部体积被删除）。 注意VeraCrypt从不修改文件系统（例如，有关分配的群集、空闲空间量等的信息）在外部空间里一旦卷被删除，保护就会丢失。当 卷再次安装，则无法确定卷是否使用了隐藏卷保护。只有为隐藏卷（每个）提供正确密码（和/或密钥文件）的用户才能激活隐藏卷保护 安装外部卷的时间）。
** 
 As soon as a write operation to the hidden volume area is  denied/prevented (to protect the hidden volume), the entire host volume  (both the outer and the hidden volume) becomes write-protected until  dismounted (the VeraCrypt driver reports the 'invalid parameter' error to the system upon each attempt to write data to the volume).  This preserves plausible deniability (otherwise certain kinds of  inconsistency within the file system could indicate that this volume has used hidden volume protection). When damage to hidden volume is prevented, a warning is displayed (provided that the  VeraCrypt Background Task is enabled – see the chapter [ VeraCrypt Background Task](https://veracrypt.fr/en/VeraCrypt Background Task.html)). Furthermore, the type of the mounted outer volume displayed in the main window changes to '*Outer(!)* ':
一旦对隐藏卷区域的写操作被拒绝/阻止（以保护隐藏卷），整个主机卷（包括外部卷和隐藏卷）将被写保护，直到删除（VeraCrypt驱动程序报告“无效参数”） 每次尝试将数据写入卷时系统出错）。这保留了合理的可否认性（否则文件系统中的某些类型的不一致可能表明此卷使用了隐藏卷保护）。当损害隐藏 阻止加密量时，会显示一个警告（前提是启用了VeraCrypt后台任务-参见章节 [VeraCrypt后台任务](https://veracrypt.fr/en/VeraCrypt Background Task.html)）。此外，主窗口中显示的已安装外部体积的类型更改为“*外部（！）* ':

![VeraCrypt GUI](https://veracrypt.fr/en/Protection of Hidden Volumes_Image_029.jpg)



 Moreover, the field *Hidden Volume Protected* in the *Volume Properties* dialog window says:
此外， *卷属性*对话框窗口显示：
 '*Yes (damage prevented!)*'*.*
“*是的（防止损坏！）*'*.* 

 Note that when damage to hidden volume is prevented,  *no* information about the event is written to the volume. When the  outer volume is dismounted and mounted again, the volume properties will *not* display the string "*damage prevented*".
请注意，当防止损坏隐藏卷时，*不会*将有关事件的信息写入卷。当外部卷被重新加载并再次装入时，卷属性将 *不*显示字符串“*防止损坏*“。*
*


 There are several ways to check that a hidden volume is being protected against damage:
有几种方法可以检查隐藏卷是否受到保护，以防止损坏：

1. A confirmation message box saying that hidden volume is being protected  is displayed after the outer volume is mounted (if it is not displayed,  the hidden volume is not protected!). 
   安装外部卷后，会显示一个确认消息框，说明隐藏卷正在受到保护（如果未显示，则表示隐藏卷未受到保护！）。
2. In the *Volume Properties* dialog, the field  *Hidden Volume Protected* says '*Yes*': 
   在“*卷属性”*对话框中，“*隐藏卷受保护*”字段显示“*是*”：
3. The type of the mounted outer volume is *Outer*: 
   安装的外部体积的类型为*外部*：

![VeraCrypt GUI](https://veracrypt.fr/en/Protection of Hidden Volumes_Image_030.jpg)

*
 **Important: You are the only person who can mount your outer volume with the hidden volume protection enabled (since nobody else knows your hidden volume  password). When an adversary asks you to mount an outer volume, you of  course must*** **not** ***mount it with the hidden volume protection enabled. You must mount it  as a normal volume (and then VeraCrypt will not show the volume type "Outer" but "Normal"). The reason is that, during the time when an outer volume is mounted with the hidden volume protection enabled, the  adversary*** **can** ***find out that a hidden volume exists within the outer volume (he/she  will be able to find it out until the volume is dismounted and possibly even some time after the computer has been powered off - see [ Unencrypted Data in RAM](https://veracrypt.fr/en/Unencrypted Data in RAM.html)).***
重要提示：您是唯一可以在启用隐藏卷保护的情况下挂载外部卷的人（因为没有其他人知道您的隐藏卷密码）。当对手要求你挂载一个外部卷时，你当然 必须**不*****挂载它与隐藏卷保护启用.您必须将其挂载为一个普通加密卷（这样VeraCrypt将不会显示“Outer”加密卷类型而是“Normal”加密卷类型）。原因是，在外部卷安装时启用了隐藏卷保护，攻击者*****可以*****发现外部卷中存在隐藏卷（他/她将能够找到它，直到卷被删除，甚至可能在计算机断电后一段时间-参见[RAM中的未加密数据](https://veracrypt.fr/en/Unencrypted Data in RAM.html)）。*** 

 

 *Warning*: Note that the option '*Protect hidden volume against damage caused by writing to outer volume*' in the *Mount Options* dialog window is automatically disabled after a mount attempt is completed, no matter whether it is successful or not (all hidden volumes that are  already being protected will, of course, continue to be protected). Therefore, you need to check that option *each* time you attempt to mount the outer volume (if you wish the hidden volume to be protected):
*警告*：请注意，选项“*保护隐藏卷免受损坏所造成的写入外部卷*”中 装载尝试完成后，无论装载成功与否*，装载选项*对话框窗口都会自动禁用（当然，所有已受保护的隐藏卷将继续受到保护）。因此，您需要*在每次*尝试挂载外部卷时检查该选项（如果您希望保护隐藏卷）：

 ![VeraCrypt GUI](https://veracrypt.fr/en/Protection of Hidden Volumes_Image_031.jpg)


 If you want to mount an outer volume and protect a hidden volume within  using cached passwords, then follow these steps: Hold down the *Control* (*Ctrl*) key when clicking *Mount* (or select *Mount with Options* from the *Volumes* menu). This will open the  *Mount Options* dialog. Enable the option '*Protect hidden volume against damage caused by writing to outer volume*' and leave the password box empty. Then click *OK*.
如果您要挂载外部卷并使用缓存密码保护中的隐藏卷，请执行以下步骤：按住 单击时按*Ctrl*键 *装载*（或从“*选项*”菜单中选择*“使用选项装载”*）。这将打开“*装载选项”*对话框。启用选项“*保护隐藏卷免受写入外部卷造成的损害*”，并保留密码框为空。然后单击 *好*的.

If you need to mount an outer volume and you know that you will not need  to save any data to it, then the most comfortable way of protecting the  hidden volume against damage is mounting the outer volume as read-only  (see the section [ Mount Options](https://veracrypt.fr/en/Mounting VeraCrypt Volumes.html)).
如果您需要挂载外部卷，并且您知道不需要将任何数据保存到其中，那么保护隐藏卷免受损坏的最佳方法是将外部卷挂载为只读（请参见 [安装选项](https://veracrypt.fr/en/Mounting VeraCrypt Volumes.html)）。

# Security Requirements and Precautions Pertaining to Hidden Volumes 与隐藏式网络有关的安全要求和预防措施

If you use a [ hidden VeraCrypt volume](https://veracrypt.fr/en/Hidden Volume.html), you must follow the security requirements  and precautions listed below in this section. Disclaimer: This section  is not guaranteed to contain a list of *all* security issues and attacks that might adversely affect or limit the  ability of VeraCrypt to secure data stored in a hidden VeraCrypt volume  and the ability to provide plausible deniability.
如果您使用[隐藏的VeraCrypt加密卷](https://veracrypt.fr/en/Hidden Volume.html)，您必须遵守本节中列出的安全要求和注意事项。免责声明：本节不保证包含以下列表： *所有*可能对VeraCrypt保护存储在隐藏的VeraCrypt加密卷中的数据的能力以及提供合理否认的能力产生不利影响或限制的安全问题和攻击。

- If an adversary has access to a (dismounted) VeraCrypt volume at several points over time, he may be able to determine which sectors of the  volume are changing. If you change the contents of a

  hidden volume

   (e.g., create/copy new files to the hidden volume or  modify/delete/rename/move files stored on the hidden volume, etc.), the  contents of sectors (ciphertext) in the hidden volume area will change.  After being given the password to the outer volume, the adversary might demand an explanation why these sectors  changed. Your failure to provide a plausible explanation might indicate  the existence of a hidden volume within the outer volume.

  
  如果攻击者在一段时间内的多个时间点访问了VeraCrypt加密卷，他可能能够确定加密卷的哪些扇区正在发生变化。如果更改 [隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)（例如，创建/复制新文件到隐藏卷或修改/删除/重命名/移动存储在隐藏卷上的文件等），隐藏卷区域中扇区（密文）的内容将改变。在被告知外部的密码后 如果你的对手要求解释为什么这些部门发生了变化。如果你不能给出合理的解释，那就说明在外层空间中有一个隐藏的空间。

  Note that issues similar to the one described above may also arise, for example, in the following cases:

  
  请注意，例如在以下情况下，也可能出现与上述问题类似的问题：

  - The file system in which you store a file-hosted VeraCrypt container has been defragmented and a copy of the VeraCrypt container (or of its  fragment) remains in the free space on the host volume (in the  defragmented file system). To prevent this, do one of the following:

    
    存储文件托管的VeraCrypt容器的文件系统已被碎片整理，并且VeraCrypt容器（或其碎片）的副本仍保留在主机卷（碎片整理文件系统）的可用空间中。要防止这种情况，请执行以下操作之一： 如下所示：

    - Use a partition/device-hosted VeraCrypt volume instead of file-hosted. 
      使用分区/设备托管的VeraCrypt加密卷，而不是文件托管的加密卷。
    - Securely erase free space on the host volume (in the defragmented file  system) after defragmenting. On Windows, this can be done using the  Microsoft [free utility SDelete](https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx). On Linux, the *shred* utility from GNU coreutils package can be used for this purpose. 
      在碎片整理后，安全擦除主机卷（在碎片整理文件系统中）上的可用空间。在Windows上，可以使用Microsoft [免费实用程序SDelete](https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx)。在Linux上， GNU coreutils包中*shred*实用程序可用于此目的。
    - Do not defragment file systems in which you store VeraCrypt volumes. 
      不要对存储VeraCrypt加密卷的文件系统进行碎片整理。

  - A file-hosted VeraCrypt container is stored in a journaling file system  (such as NTFS). A copy of the VeraCrypt container (or of its fragment)  may remain on the host volume. To prevent this, do one the following:

    
    文件托管的VeraCrypt容器存储在日志文件系统中（例如SSL）。VeraCrypt容器（或其片段）的副本可能会保留在主机卷上。为了防止这种情况，请执行以下操作之一：

    - Use a partition/device-hosted VeraCrypt volume instead of file-hosted. 
      使用分区/设备托管的VeraCrypt加密卷，而不是文件托管的加密卷。
    - Store the container in a non-journaling file system (for example, FAT32). 
      将容器存储在非日志文件系统（例如，FAT32）中。

  - A VeraCrypt volume resides on a device/filesystem that utilizes a  wear-leveling mechanism (e.g. a flash-memory SSD or USB flash drive). A  copy of (a fragment of) the VeraCrypt volume may remain on the device.  Therefore, do not store hidden volumes on such devices/filesystems. For more information on wear-leveling, see the section [ Wear-Leveling](https://veracrypt.fr/en/Wear-Leveling.html) in the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html). 
    VeraCrypt卷驻留在使用损耗均衡机制的设备/文件系统上（例如闪存SSD或USB闪存驱动器）。VeraCrypt加密卷的副本（碎片）可能会保留在设备上。因此，不要在此类设备/文件系统上存储隐藏卷。有关磨损均衡的详细信息，请参阅“[安全要求和注意事项”](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章中的[“磨损均衡”](https://veracrypt.fr/en/Wear-Leveling.html)部分。

  - A VeraCrypt volume resides on a device/filesystem that saves data (or on a device/filesystem that is controlled or monitored by a system/device  that saves data) (e.g. the value of a timer or counter) that can be used to determine that a block had been written earlier than another block and/or to determine how many times a block  has been written/read. Therefore, do not store hidden volumes on such  devices/filesystems. To find out whether a device/system saves such  data, please refer to documentation supplied with the device/system or contact the vendor/manufacturer. 
    VeraCrypt加密卷驻留在保存数据的设备/文件系统上（或由保存数据的系统/设备控制或监控的设备/文件系统上）（例如计时器或计数器的值），可以用来确定一个区块比另一个区块早被写入和/或确定一个区块被写入/读取了多少次。因此，不要在此类设备/文件系统上存储隐藏卷。要了解设备/系统是否保存此类数据，请参阅设备/系统随附的文档或联系供应商/制造商。

  - A VeraCrypt volume resides on a device that is prone to wear (it is  possible to determine that a block has been written/read more times than another block). Therefore, do not store hidden volumes on such  devices/filesystems. To find out whether a device is prone to such wear, please refer to documentation supplied with the  device or contact the vendor/manufacturer. 
    VeraCrypt加密卷驻留在易于磨损的设备上（可以确定一个区块比另一个区块被写入/读取的次数更多）。因此，不要在此类设备/文件系统上存储隐藏卷。要了解器械是否容易发生此类磨损，请参阅器械随附的文档或联系供应商/制造商。

  - You back up content of a hidden volume by cloning its host volume or  create a new hidden volume by cloning its host volume. Therefore, you  must not do so. Follow the instructions in the chapter [ How to Back Up Securely](https://veracrypt.fr/en/How to Back Up Securely.html) and in the section [ Volume Clones](https://veracrypt.fr/en/Volume Clones.html). 
    您可以通过克隆隐藏卷的主机卷来备份隐藏卷的内容，或者通过克隆隐藏卷的主机卷来创建新的隐藏卷。因此，你不能这样做。按照本章的说明进行操作 [如何秘密备份](https://veracrypt.fr/en/How to Back Up Securely.html)[卷克隆一](https://veracrypt.fr/en/Volume Clones.html)节中的和。

- Make sure that *Quick Format* is disabled when encrypting a partition/device within which you intend to create a hidden volume. 
  加密要在其中创建隐藏卷的分区/设备时，请确保禁用*快速格式化*。

- On Windows, make sure you have not deleted any files within a volume  within which you intend to create a hidden volume (the cluster bitmap  scanner does not detect deleted files). 
  在Windows上，请确保未删除要在其中创建隐藏卷的卷中的任何文件（群集位图扫描程序不会检测到已删除的文件）。

- On Linux or Mac OS X, if you intend to create a hidden volume within a  file-hosted VeraCrypt volume, make sure that the volume is not  sparse-file-hosted (the Windows version of VeraCrypt verifies this and  disallows creation of hidden volumes within sparse files). 
  在Linux或Mac OS X上，如果您打算在文件托管的VeraCrypt加密卷中创建隐藏加密卷，请确保该加密卷不是稀疏文件托管的（Windows版本的VeraCrypt会验证这一点，并禁止在稀疏文件中创建隐藏加密卷）。

- When a hidden volume is mounted, the operating system and third-party  applications may write to non-hidden volumes (typically, to the  unencrypted system volume) unencrypted information about the data stored in the hidden volume (e.g. filenames and locations of recently accessed files, databases created by file indexing tools,  etc.), the data itself in an unencrypted form (temporary files, etc.),  unencrypted information about the filesystem residing in the hidden  volume (which might be used e.g. to identify the filesystem and to determine whether it is the filesystem residing in  the outer volume), the password/key for the hidden volume, or other  types of sensitive data. Therefore, the following security requirements  and precautions must be followed:

  
  当安装隐藏卷时，操作系统和第三方应用程序可以将关于存储在隐藏卷中的数据的未加密信息（例如，文件名和位置）写入非隐藏卷（通常，写入未加密系统卷 最近访问的文件、由文件索引工具创建的数据库等），未加密形式的数据本身（临时文件等），关于驻留在隐藏卷中的文件系统的未加密信息（其可以用于例如识别 文件系统并确定它是否是驻留在外部卷中的文件系统）、隐藏卷的密码/密钥或其他类型的敏感数据。因此，必须遵循以下安全要求和预防措施：

  - *Windows*: Create a hidden operating system (for information on how to do so, see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)) and mount hidden volumes only when the hidden operating system is running. Note: When a hidden operating system is running, VeraCrypt ensures that all  local unencrypted filesystems and non-hidden VeraCrypt volumes are  read-only (i.e. no files can be written to such filesystems or VeraCrypt volumes).[*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html#hidden_os_exception) Data is allowed to be written to filesystems within [ hidden VeraCrypt volumes](https://veracrypt.fr/en/Hidden Volume.html). Alternatively, if a hidden  operating system cannot be used, use a "live-CD" Windows PE system  (entirely stored on and booted from a CD/DVD) that ensures that any data written to the system volume is written to a RAM disk. Mount hidden volumes only when such a "live-CD" system is running (if a hidden operating system cannot be used). In addition, during such a  "live-CD" session, only filesystems that reside in hidden VeraCrypt  volumes may be mounted in read-write mode (outer or unencrypted volumes/filesystems must be mounted as read-only or must not be mounted/accessible at all); otherwise, you must ensure that  applications and the operating system do not write any sensitive data  (see above) to non-hidden volumes/filesystems during the "live-CD" session. 
    *Windows*：创建隐藏操作系统（有关如何执行此操作的信息，请参阅 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)），并仅在隐藏的操作系统运行时装入隐藏的卷。 注意事项：当隐藏操作系统运行时，VeraCrypt会确保所有本地未加密的文件系统和非隐藏的VeraCrypt加密卷都是只读的（即没有文件可以写入这些文件系统或VeraCrypt加密卷）。[*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html#hidden_os_exception)允许将数据写入[隐藏的VeraCrypt加密卷](https://veracrypt.fr/en/Hidden Volume.html)中的文件系统。或者，如果无法使用隐藏的操作系统，请使用“live-CD”Windows  PE系统（完全存储在CD/DVD上并从CD/DVD引导），以确保写入系统卷的任何数据都写入RAM磁盘。只有当这种“live-CD”系统运行时才挂载隐藏卷（如果无法使用隐藏操作系统）。  此外，在这种“live-CD”会话中，只有位于隐藏VeraCrypt卷中的文件系统可以以读写模式挂载（外部或未加密的卷/文件系统必须以只读方式挂载，或者根本不能挂载/访问）;否则，您必须确保应用程序和操作系统在“live-CD”会话期间不会将任何敏感数据（参见上文）写入非隐藏卷/文件系统。
  - *Linux*: Download or create a "live-CD" version of your operating system (i.e. a "live" Linux system entirely stored on and booted from a CD/DVD) that  ensures that any data written to the system volume is written to a RAM  disk. Mount hidden volumes only when such a "live-CD" system is running.  During the session, only filesystems that reside in hidden VeraCrypt  volumes may be mounted in read-write mode (outer or unencrypted  volumes/filesystems must be mounted as read-only or must not be mounted/accessible at all). If you cannot comply with this  requirement and you are not able to ensure that applications and the  operating system do not write any sensitive data (see above) to  non-hidden volumes/filesystems, you must not mount or create hidden VeraCrypt volumes under Linux. 
    *Linux*：下载或创建一个“live-CD”版本的操作系统（即完全存储在CD/DVD上并从CD/DVD引导的“live”Linux系统），以确保写入系统卷的任何数据都写入RAM磁盘。只有当这种“live-CD”系统运行时才挂载隐藏卷。在会话期间，只有隐藏的VeraCrypt加密卷中的文件系统才能以读写模式挂载（外部或未加密的加密卷/文件系统必须以只读方式挂载，或者根本不能挂载/访问）。如果您不能遵守这一要求，并且您不能确保应用程序和操作系统不会将任何敏感数据（见上文）写入非隐藏卷/文件系统，则您不能在Linux下挂载或创建隐藏的VeraCrypt卷。
  - *Mac OS X*: If you are not able to ensure that applications and the operating  system do not write any sensitive data (see above) to non-hidden  volumes/filesystems, you must not mount or create hidden VeraCrypt  volumes under Mac OS X. 
    *Mac OS X*：如果您无法确保应用程序和操作系统不会将任何敏感数据（见上文）写入非隐藏卷/文件系统，则不能在Mac OS X下挂载或创建隐藏的VeraCrypt卷。

- When an outer volume is mounted with [ hidden volume protection](https://veracrypt.fr/en/Protection of Hidden Volumes.html) enabled (see section [ Protection of Hidden Volumes Against Damage](https://veracrypt.fr/en/Protection of Hidden Volumes.html)), you must follow the  same security requirements and precautions that you are required to  follow when a hidden volume is mounted (see above). The reason is that  the operating system might leak the password/key for the hidden volume to a non-hidden or unencrypted volume. 
  当一个外部卷在[隐藏卷保护被](https://veracrypt.fr/en/Protection of Hidden Volumes.html)启用的情况下挂载时（请参阅[保护隐藏卷免受损坏一](https://veracrypt.fr/en/Protection of Hidden Volumes.html)节），您必须遵循与挂载隐藏卷时所需遵循的安全要求和预防措施相同的安全要求和预防措施（请参阅上文）。原因是操作系统可能会将隐藏卷的密码/密钥泄露给非隐藏或未加密的卷。

- If you use an 

  operating system residing within a hidden volume

   (see the section

  Hidden Operating System

  ), then, in addition to the above, you must follow these security requirements and precautions:

  
  如果您使用的**操作系统驻留在隐藏卷中**（请参阅 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)），那么，除了以上所述，您还必须遵循这些安全要求和预防措施：

  - You should use the decoy operating system as frequently as you use your  computer. Ideally, you should use it for all activities that do not  involve sensitive data. Otherwise, plausible deniability of the hidden  operating system might be adversely affected (if you revealed the password for the decoy operating system to an  adversary, he could find out that the system is not used very often,  which might indicate the existence of a hidden operating system on your  computer). Note that you can save data to the decoy system partition anytime without any risk that the hidden volume will  get damaged (because the decoy system is *not* installed in the outer volume). 
    您应该像使用计算机一样频繁地使用诱饵操作系统。理想情况下，您应该将其用于不涉及敏感数据的所有活动。否则，隐藏操作系统的合理可否认性可能会受到不利影响（如果 如果您向对手透露了诱饵操作系统的密码，他可能会发现该系统并不经常使用，这可能表明您的计算机上存在隐藏的操作系统）。请注意，您可以将数据保存到诱饵 系统分区任何时候都没有任何风险，隐藏卷将被损坏（因为诱饵系统是 *未*安装在外部体积中）。
  - If the operating system requires activation, it must be activated before it is cloned (cloning is part of the process of creation of a hidden  operating system — see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)) and the hidden operating system (i.e. the  clone) must never be reactivated. The reason is that the hidden  operating system is created by copying the content of the system  partition to a hidden volume (so if the operating system is not activated, the hidden operating system will not be activated  either). If you activated or reactivated a hidden operating system, the  date and time of the activation (and other data) might be logged on a  Microsoft server (and on the hidden operating system) but not on the [ decoy operating system](https://veracrypt.fr/en/Hidden Operating System.html). Therefore, if an adversary had access to the data stored on the server or intercepted your request to the server  (and if you revealed the password for the decoy operating system to  him), he might find out that the decoy operating system was activated (or reactivated) at a different time, which might  indicate the existence of a hidden operating system on your computer.
    如果操作系统需要激活，则必须在克隆之前激活它（克隆是创建隐藏操作系统过程的一部分-请参见 [隐藏操作系统](https://veracrypt.fr/en/Hidden Operating System.html)）和隐藏操作系统（即克隆）绝不能重新激活。原因是隐藏的操作系统是通过将系统分区的内容复制到隐藏卷来创建的（因此，如果操作系统 未激活，隐藏的操作系统也不会被激活）。如果您激活或重新激活了隐藏的操作系统，则激活的日期和时间（以及其他数据）可能会记录在Microsoft服务器上（以及隐藏的操作系统上）。 系统），但不是在[诱饵操作系统](https://veracrypt.fr/en/Hidden Operating System.html)。因此，如果对手可以访问存储在服务器上的数据或拦截您对服务器的请求（如果您向他透露了诱饵操作系统的密码），他可能会发现诱饵操作系统正在运行。 系统在不同的时间被激活（或重新激活），这可能表明计算机上存在隐藏的操作系统。
    
     For similar reasons, any software that requires activation must be  installed and activated before you start creating the hidden operating  system. 
    出于类似的原因，在开始创建隐藏的操作系统之前，必须安装并激活任何需要激活的软件。
  - When you need to shut down the hidden system and start the decoy system, do  *not* restart the computer. Instead, shut it down or hibernate it and then leave it powered off for at least several minutes (the longer, the better) before turning the computer on and booting the decoy system.  This is required to clear the memory, which may contain sensitive data. For more information, see the section [ Unencrypted Data in RAM](https://veracrypt.fr/en/Unencrypted Data in RAM.html) in the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html). 
    当您需要关闭隐藏系统并启动诱饵系统时，请*不要*重新启动计算机。相反，关闭它或休眠它，然后让它断电至少几分钟（越长越好），然后再打开计算机并启动诱饵系统。这是清除可能包含敏感数据的内存所必需的。有关详细信息，请参阅[安全要求和注意事项](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章中的[RAM中的未加密数据](https://veracrypt.fr/en/Unencrypted Data in RAM.html)一节。
  - The computer may be connected to a network (including the internet) only when the decoy operating system is running. When the hidden operating  system is running, the computer should not be connected to any network,  including the internet (one of the most reliable ways to ensure it is to unplug the network cable, if there is one).  Note that if data is downloaded from or uploaded to a remote server, the date and time of the connection, and other data, are typically logged  on the server. Various kinds of data are also logged on the operating system (e.g. Windows auto-update data,  application logs, error logs, etc.) Therefore, if an adversary had  access to the data stored on the server or intercepted your request to  the server (and if you revealed the password for the decoy operating system to him), he might find out that the connection was not made from within the decoy operating system, which might indicate the  existence of a hidden operating system on your computer. 
    只有当诱饵操作系统运行时，计算机才可以连接到网络（包括互联网）。当隐藏的操作系统运行时，计算机不应连接到任何网络，包括互联网（最可靠的网络之一）。 确保它是拔掉网络电缆的方法，如果有的话）。请注意，如果从远程服务器下载数据或将数据上传到远程服务器，则连接的日期和时间以及其他数据通常会记录在服务器上。各种数据也 登录在操作系统上（例如，Windows自动更新数据、应用程序日志、错误日志等）因此，如果对手可以访问存储在服务器上的数据或拦截您对服务器的请求（如果您泄露了诱饵的密码 操作系统），他可能会发现连接不是从诱饵操作系统中建立的，这可能表明您的计算机上存在隐藏的操作系统。
    
     Also note that similar issues would affect you if there were any  filesystem shared over a network under the hidden operating system  (regardless of whether the filesystem is remote or local). Therefore,  when the hidden operating system is running, there must be no filesystem shared over a network (in any direction). 
    还要注意，如果在隐藏操作系统下有任何通过网络共享的文件系统（无论文件系统是远程的还是本地的），类似的问题也会影响您。因此，当隐藏的操作系统运行时， 没有文件系统在网络上共享（在任何方向上）。
  - Any actions that can be detected by an adversary (or any actions that  modify any data outside mounted hidden volumes) must be performed only  when the decoy operating system is running (unless you have a plausible  alternative explanation, such as using a "live-CD" system to perform such actions). For example, the option '*Auto-adjust for daylight saving time*' option may be enabled only on the decoy system. 
    任何可以被攻击者检测到的操作（或修改隐藏卷外部数据的操作）都必须仅在诱饵操作系统运行时执行（除非您有合理的替代解释，例如使用“live-CD”系统来执行此类操作）。例如，“*自动调整夏令时*”选项可能仅在诱饵系统上启用。
  - If the BIOS, EFI, or any other component logs power-down events or any  other events that could indicate a hidden volume/system is used (e.g. by comparing such events with the events in the Windows event log), you  must either disable such logging or ensure that the log is securely erased after each session (or otherwise avoid such  an issue in an appropriate way). 
    如果BIOS、BIOS或任何其他组件记录掉电事件或任何其他可能表明使用了隐藏卷/系统的事件（例如，通过将此类事件与Windows事件日志中的事件进行比较），则必须禁用此类记录或确保在每次会话后安全地擦除日志（或以其他适当的方式避免此类问题）。


 In addition to the above, you must follow the security requirements and precautions listed in the following chapters:
除上述内容外，您还必须遵守以下章节中列出的安全要求和预防措施：

- [Security Requirements and Precautions
  安全要求和预防措施](https://veracrypt.fr/en/Security Requirements and Precautions.html)
- **[How to Back Up Securely
  如何备份Secret](https://veracrypt.fr/en/How to Back Up Securely.html)**

# Hidden Operating System 隐藏操作系统

If your system partition or system drive is encrypted using VeraCrypt, you need to enter your [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) password in the VeraCrypt Boot Loader screen after you turn on or restart your computer. It may happen that you are  forced by somebody to decrypt the operating system or to reveal the  pre-boot authentication password. There are many situations where you cannot refuse to do so (for example, due to  extortion). VeraCrypt allows you to create a hidden operating system  whose existence should be impossible to prove (provided that certain  guidelines are followed — see below). Thus, you will not have to decrypt or reveal the password for the hidden  operating system.
如果您的系统分区或系统驱动器使用VeraCrypt加密，您需要输入您的 打开或重启计算机后，VeraCrypt靴子加载程序屏幕中[的预靴子验证](https://veracrypt.fr/en/System Encryption.html)密码。它可能发生，你被迫由某人解密操作系统或透露预启动身份验证密码.在很多情况下，你不能拒绝这样做（例如，由于勒索）。VeraCrypt允许您创建一个隐藏的操作系统，其存在应该是不可能证明的（前提是遵循某些指导原则-见下文）。因此，您不必解密或透露隐藏操作系统的密码。

Before you continue reading this section, make sure you have read the section [ **Hidden Volume**](https://veracrypt.fr/en/Hidden Volume.html) and that you understand what a [ hidden VeraCrypt volume](https://veracrypt.fr/en/Hidden Volume.html) is.
在继续阅读本节之前，请确保您已阅读[**隐藏卷**](https://veracrypt.fr/en/Hidden Volume.html)一节并且了解 [隐藏的VeraCrypt加密卷](https://veracrypt.fr/en/Hidden Volume.html)是.

A **hidden operating system** is a system (for example, Windows 7 or Windows XP) that is installed in a [ hidden VeraCrypt volume](https://veracrypt.fr/en/Hidden Volume.html). It should be impossible to prove that a [ hidden VeraCrypt volume](https://veracrypt.fr/en/Hidden Volume.html) exists (provided that certain guidelines are followed; for more information, see the section [ Hidden Volume](https://veracrypt.fr/en/Hidden Volume.html)) and, therefore, it should be impossible to prove that a hidden operating system exists.
**隐藏操作系统**是安装在 [隐藏的VeraCrypt加密卷](https://veracrypt.fr/en/Hidden Volume.html)。要证明隐藏的[VeraCrypt加密卷存在](https://veracrypt.fr/en/Hidden Volume.html)是不可能的（只要遵循某些准则;更多信息，请参阅 [隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)），因此，不可能证明隐藏操作系统的存在。

However, in order to boot a system encrypted by VeraCrypt, an unencrypted copy of the [ VeraCrypt Boot Loader](https://veracrypt.fr/en/System Encryption.html) has to be stored on the system drive or on a [ VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html). Hence, the mere presence of the VeraCrypt  Boot Loader can indicate that there is a system encrypted by VeraCrypt  on the computer. Therefore, to provide a plausible explanation for the  presence of the VeraCrypt Boot Loader, the VeraCrypt wizard helps you create a second encrypted operating system, so-called  **decoy operating system**, during the process of creation of a  hidden operating system. A decoy operating system must not contain any  sensitive files. Its existence is not secret (it is *not* installed in a [ hidden volume](https://veracrypt.fr/en/Hidden Volume.html)). The password for the decoy operating system can be  safely revealed to anyone forcing you to disclose your pre-boot  authentication password.*
然而，为了靴子一个由VeraCrypt加密的系统，需要一个未加密的 [VeraCrypt靴子加载程序](https://veracrypt.fr/en/System Encryption.html)必须存储在系统驱动器或[VeraCrypt救援盘](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)上。因此，只要VeraCrypt靴子Loader的存在就可以表明计算机上有一个由VeraCrypt加密的系统。因此，为了给VeraCrypt靴子Loader的存在提供一个合理的解释，VeraCrypt向导会帮助您在创建隐藏操作系统的过程中创建第二个加密操作系统，即所谓的**诱饵操作系统**。诱饵操作系统不能包含任何敏感文件。它的存在不是秘密（它是 *未*安装在[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)中）。诱饵操作系统的密码可以安全地透露给任何迫使您透露预引导身份验证密码的人。*

You should use the decoy operating system as frequently as you use your  computer. Ideally, you should use it for all activities that do not  involve sensitive data. Otherwise, plausible deniability of the hidden  operating system might be adversely affected (if you revealed the password for the decoy operating system to an  adversary, he could find out that the system is not used very often,  which might indicate the existence of a hidden operating system on your  computer). Note that you can save data to the decoy system partition anytime without any risk that the hidden volume will  get damaged (because the decoy system is *not* installed in the outer volume — see below).
您应该像使用计算机一样频繁地使用诱饵操作系统。理想情况下，您应该将其用于不涉及敏感数据的所有活动。否则，隐藏操作系统的合理可否认性可能会受到不利影响（如果 如果您向对手透露了诱饵操作系统的密码，他可能会发现该系统并不经常使用，这可能表明您的计算机上存在隐藏的操作系统）。请注意，您可以将数据保存到诱饵 系统分区任何时候都没有任何风险，隐藏卷将被损坏（因为诱饵系统是 *未*安装在外部容积中-见下文）。

There will be two pre-boot authentication passwords — one for the hidden system and the other for the decoy system. If you want to start the  hidden system, you simply enter the password for the hidden system in  the VeraCrypt Boot Loader screen (which appears after you turn on or restart your computer). Likewise, if you  want to start the decoy system (for example, when asked to do so by an  adversary), you just enter the password for the decoy system in the  VeraCrypt Boot Loader screen.
将有两个预引导身份验证密码-一个用于隐藏系统，另一个用于诱饵系统。如果您想启动隐藏系统，只需在VeraCrypt靴子Loader界面（打开或重启计算机后出现）输入隐藏系统的密码即可。同样，如果您想启动诱饵系统（例如，当对手要求您这样做时），您只需在VeraCrypt靴子Loader界面中输入诱饵系统的密码。

Note: When you enter a pre-boot authentication password, the VeraCrypt  Boot Loader first attempts to decrypt (using the entered password) the  last 512 bytes of the first logical track of the system drive (where  encrypted master key data for non-hidden encrypted system partitions/drives are normally stored). If it fails and if there is a partition behind the active partition, the VeraCrypt Boot Loader  (even if there is actually no hidden volume on the drive) automatically  tries to decrypt (using the same entered password again) the area of the first partition behind the active partition  where the encrypted header of a possible hidden volume might be stored  (however, if the size of the active partition is less than 256 MB, then  the data is read from the *second* partition behind the active one, because Windows 7 and later, by  default, do not boot from the partition on which they are installed).  Note that VeraCrypt never knows if there is a hidden volume in advance  (the hidden volume header cannot be identified, as it appears to consist entirely  of random data). If the header is successfully decrypted (for  information on how VeraCrypt determines that it was successfully  decrypted, see the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html)), the information about the size of the hidden  volume is retrieved from the decrypted header (which is still stored in  RAM), and the hidden volume is mounted (its size also determines its  offset). For further technical details, see the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) in the chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html).
注意事项：当您输入预靴子验证密码时，VeraCrypt靴子加载程序首先尝试解密（使用输入的密码）系统驱动器第一个逻辑磁道的最后512字节（其中用于非隐藏加密的加密主密钥数据 系统分区/驱动器通常被存储）。如果失败并且在活动分区后面有一个分区，VeraCrypt靴子Loader（即使驱动器上实际上没有隐藏卷）会自动尝试解密（使用相同的输入密码 再次）活动分区后面的第一分区的区域，其中可能存储可能的隐藏卷的加密报头（然而，如果活动分区的大小小于256 MB，则从 活动分区后面*的第二个*分区，因为默认情况下，Windows 7和更高版本不会从安装它们的分区靴子引导）。请注意，VeraCrypt永远不会提前知道是否存在隐藏加密卷（隐藏加密卷 无法识别卷标题，因为它似乎完全由随机数据组成）。如果报头被成功解密（有关VeraCrypt如何确定它被成功解密的信息，请参阅 [加密方案](https://veracrypt.fr/en/Encryption Scheme.html)），从解密的标头（仍存储在RAM中）中检索有关隐藏卷大小的信息，并安装隐藏卷（其大小也决定其偏移量）。有关更多技术细节，请参阅[技术细节](https://veracrypt.fr/en/Technical Details.html)一章中的[加密方案一](https://veracrypt.fr/en/Encryption Scheme.html)节。

When running, the hidden operating system appears to be installed on the same partition as the original operating system (the decoy system).  However, in reality, it is installed within the partition behind it (in a hidden volume). All read/write operations are transparently redirected from the system partition to the hidden  volume. Neither the operating system nor applications will know that  data written to and read from the system partition is actually written  to and read from the partition behind it (from/to a hidden volume). Any such data is encrypted and decrypted on the fly  as usual (with an encryption key different from the one that is used for the decoy operating system).
运行时，隐藏的操作系统似乎与原始操作系统（诱饵系统）安装在同一个分区上。然而，实际上，它安装在它后面的分区中（在隐藏卷中）。所有读/写操作都透明地从系统分区重定向到隐藏卷。操作系统和应用程序都不知道写入和读取系统分区的数据实际上是写入和读取它后面的分区（从/到隐藏卷）。任何这样的数据都像往常一样在运行中加密和解密（加密密钥与用于诱饵操作系统的密钥不同）。

Note that there will also be a third password — the one for the [ **outer volume**](https://veracrypt.fr/en/Hidden Volume.html). It is not a pre-boot authentication password, but a regular VeraCrypt  volume password. It can be safely disclosed to anyone forcing you to  reveal the password for the encrypted partition where the hidden volume (containing the hidden operating system) resides. Thus, the  existence of the hidden volume (and of the hidden operating system) will remain secret. If you are not sure you understand how this is possible, or what an outer volume is, please read the section [ Hidden Volume](https://veracrypt.fr/en/Hidden Volume.html). The outer volume should contain some sensitive-looking files that you actually do *not* want to hide.
请注意，还会有第三个密码-[**外部卷**](https://veracrypt.fr/en/Hidden Volume.html)的密码。它不是预启动身份验证密码，而是常规的VeraCrypt卷密码。它可以安全地透露给任何人，迫使您透露隐藏卷（包含隐藏的操作系统）所在的加密分区的密码。因此，隐藏卷（和隐藏操作系统）的存在将保持秘密。如果你不确定你是否理解这是怎么可能的，或者什么是外部卷，请阅读[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)部分。外部卷应该包含一些敏感的前瞻性文件，你实际上做 *不*想隐藏。

To summarize, there will be three passwords in total. Two of them can be revealed to an attacker (for the decoy system and for the outer  volume). The third password, for the hidden system, must remain secret.
总而言之，总共有三个密码。其中两个可以暴露给攻击者（诱饵系统和外部体积）。第三个密码是隐藏系统的密码，必须保密。

![Example Layout of System Drive Containing Hidden Operating System](https://veracrypt.fr/en/Beginner's Tutorial_Image_034.png)

*Example Layout of System Drive Containing Hidden Operating System
包含隐藏操作系统的系统驱动器的示例布局*

 

#### Process of Creation of Hidden Operating System 创建隐藏操作系统的过程

To start the process of creation of a hidden operating system, select  *System* > *Create Hidden Operating System* and then follow the instructions in the wizard.
要开始创建隐藏的操作系统，请选择*系统*>*创建隐藏的操作系统*，然后按照向导中的说明进行操作。

Initially, the wizard verifies that there is a suitable partition for a  hidden operating system on the system drive. Note that before you can  create a hidden operating system, you need to create a partition for it  on the system drive. It must be the first partition behind the system partition and it must be at least 5% larger than the  system partition (the system partition is the one where the currently  running operating system is installed). However, if the outer volume  (not to be confused with the system partition) is formatted as NTFS, the partition for the hidden operating system  must be at least 110% (2.1 times) larger than the system partition (the  reason is that the NTFS file system always stores internal data exactly  in the middle of the volume and, therefore, the hidden volume, which is to contain a clone of the system partition, can reside only in the second half of the partition).
最初，向导会验证系统驱动器上是否有适合隐藏操作系统的分区。请注意，在创建隐藏的操作系统之前，您需要在系统驱动器上为其创建一个分区。它必须是系统分区后面的第一个分区，并且必须比系统分区大至少5%（系统分区是安装当前运行的操作系统的分区）。然而，如果外部体积（不要与系统分区混淆）格式化为NTFS，则隐藏操作系统的分区必须至少为110%比系统分区大（2.1倍）（原因在于，NTFS文件系统总是将内部数据准确地存储在卷的中间，因此，隐藏卷将包含系统分区的克隆，只能驻留在分区的后半部分）。

In the next steps, the wizard will create two VeraCrypt volumes ([outer and hidden](https://veracrypt.fr/en/Hidden Volume.html)) within the first partition behind the system partition. The [ hidden volume](https://veracrypt.fr/en/Hidden Volume.html) will contain the hidden operating system. The size of  the hidden volume is always the same as the size of the system  partition. The reason is that the hidden volume will need to contain a  clone of the content of the system partition (see below). Note that the clone will be encrypted using a different encryption key  than the original. Before you start copying some sensitive-looking files to the outer volume, the wizard tells you the maximum recommended size  of space that the files should occupy, so that there is enough free space on the outer volume for the hidden  volume.
在接下来的步骤中，向导将在系统分区后面的第一个分区中创建两个VeraCrypt卷（[外部卷和隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)）。[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)将包含隐藏的操作系统。隐藏卷的大小始终与系统分区的大小相同。原因是隐藏卷需要包含系统分区内容的克隆（见下文）。请注意，将使用与原始密钥不同的加密密钥对克隆进行加密。在开始将某些看起来敏感的文件复制到外部卷之前，向导会告诉您文件应该占用的最大建议空间大小，以便外部卷上有足够的可用空间供隐藏卷使用。

Remark: After you copy some sensitive-looking files to the outer volume, the cluster bitmap of the volume will be scanned in order to determine  the size of uninterrupted area of free space whose end is aligned with  the end of the outer volume. This area will accommodate the hidden volume, so it limits its maximum possible size.  The maximum possible size of the hidden volume will be determined and it will be verified that it is greater than the size of the system  partition (which is required, because the entire content of the system partition will need to be copied to the hidden  volume — see below). This ensures that no data stored on the outer  volume will be overwritten by data written to the area of the hidden  volume (e.g. when the system is being copied to it). The size of the hidden volume is always the same as the size of the system partition.
备注：将某些看起来敏感的文件复制到外部卷后，将扫描卷的群集位图，以确定末端与外部卷末端对齐的可用空间的不间断区域的大小。此区域将容纳隐藏卷，因此它限制了其最大可能大小。将确定隐藏卷的最大可能大小，并验证它是否大于系统分区的大小（这是必需的，因为系统分区的整个内容将需要复制到隐藏卷-见下文）。这确保了外部卷上存储的数据不会被写入隐藏卷区域的数据覆盖（例如，当系统被复制到它时）。隐藏卷的大小始终与系统分区的大小相同。

Then, VeraCrypt will create the hidden operating system by copying the  content of the system partition to the hidden volume. Data being copied  will be encrypted on the fly with an encryption key different from the  one that will be used for the decoy operating system. The process of copying the system is performed in the pre-boot  environment (before Windows starts) and it may take a long time to  complete; several hours or even several days (depending on the size of  the system partition and on the performance of the computer). You will be able to interrupt the process, shut down  your computer, start the operating system and then resume the process.  However, if you interrupt it, the entire process of copying the system  will have to start from the beginning (because the content of the system partition must not change during cloning).  The hidden operating system will initially be a clone of the operating  system under which you started the wizard.
然后，VeraCrypt将通过将系统分区的内容复制到隐藏卷来创建隐藏操作系统。被复制的数据将使用与诱饵操作系统所用的加密密钥不同的加密密钥进行动态加密。复制系统的过程是在预引导环境中（Windows启动之前）执行的，可能需要很长时间才能完成;几个小时甚至几天（取决于系统分区的大小和计算机的性能）。您将能够中断该过程，关闭计算机，启动操作系统，然后恢复该过程。但是，如果您中断它，则复制系统的整个过程将不得不从头开始（因为在克隆期间系统分区的内容不得更改）。隐藏的操作系统最初将是启动向导时所使用的操作系统的克隆。

Windows creates (typically, without your knowledge or consent) various  log files, temporary files, etc., on the system partition. It also saves the content of RAM to hibernation and paging files located on the  system partition. Therefore, if an adversary analyzed files stored on the partition where the original system (of which the  hidden system is a clone) resides, he might find out, for example, that  you used the VeraCrypt wizard in the hidden-system-creation mode (which  might indicate the existence of a hidden operating system on your computer). To prevent such issues, VeraCrypt will  securely erase the entire content of the partition where the original  system resides after the hidden system has been created. Afterwards, in  order to achieve plausible deniability, VeraCrypt will prompt you to install a new system on the partition and encrypt it using VeraCrypt. Thus, you will create the decoy system and the whole  process of creation of the hidden operating system will be completed.
Windows创建（通常在您不知情或未经您同意的情况下）各种日志文件、临时文件等，在系统分区上。它还将RAM的内容保存到位于系统分区上的休眠和分页文件中。因此，如果攻击者分析存储在原始系统（隐藏系统是其克隆）所在分区上的文件，他可能会发现，例如，您在隐藏系统创建模式下使用了VeraCrypt向导（这可能表明您的计算机上存在隐藏的操作系统）。为了防止此类问题，VeraCrypt会在创建隐藏系统后安全地删除原系统所在分区的全部内容。之后，为了达到合理的可否认性，VeraCrypt会提示您在分区上安装一个新的系统，并使用VeraCrypt对其进行加密。这样，您就可以创建诱饵系统，并完成创建隐藏操作系统的整个过程。

Note: VeraCrypt will erase the content of the partition where the  original system resides by filling it with random data entirely. If you  revealed the password for the decoy system to an adversary and he asked  you why the free space of the (decoy) system partition contains random data, you could answer, for example: "The partition  previously contained a system encrypted by VeraCrypt, but I forgot the  pre-boot authentication password (or the system was damaged and stopped  booting), so I had to reinstall Windows and encrypt the partition again."
注意：VeraCrypt会将原始系统所在分区的内容全部填充随机数据，从而清除该分区的内容。如果您向攻击者透露了诱饵系统的密码，他问您为什么诱饵系统分区的空闲空间包含随机数据，您可以回答，例如：“该分区以前包含一个由VeraCrypt加密的系统，但我忘记了预启动身份验证密码（或系统损坏并停止启动），所以我必须重新安装Windows并重新加密该分区。"

#### Plausible Deniability and Data Leak Protection 合理否认和数据泄漏保护

For security reasons, when a hidden operating system is running,  VeraCrypt ensures that all local unencrypted filesystems and non-hidden  VeraCrypt volumes are read-only (i.e. no files can be written to such  filesystems or VeraCrypt volumes).† Data is allowed to be written to any filesystem that resides within a [ hidden VeraCrypt volume](https://veracrypt.fr/en/Hidden Volume.html) (provided that the hidden volume is not  located in a container stored on an unencrypted filesystem or on any  other read-only filesystem).
出于安全考虑，当隐藏操作系统运行时，VeraCrypt会确保所有本地未加密的文件系统和非隐藏的VeraCrypt加密卷都是只读的（即没有文件可以被写入这些文件系统或VeraCrypt加密卷）。†数据可以被写入[隐藏的VeraCrypt加密卷](https://veracrypt.fr/en/Hidden Volume.html)中的任何文件系统（前提是隐藏的加密卷不位于未加密文件系统或任何其他只读文件系统的容器中）。

There are three main reasons why such countermeasures have been implemented:
采取这种反措施的主要原因有三：

1. It enables the creation of a secure platform for mounting of hidden  VeraCrypt volumes. Note that we officially recommend that hidden volumes are mounted only when a hidden operating system is running. For more  information, see the subsection [ Security Requirements and Precautions Pertaining to Hidden Volumes](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html). 
   它可以创建一个安全的平台来挂载隐藏的VeraCrypt加密卷。请注意，我们正式建议仅在隐藏操作系统运行时才挂载隐藏卷。有关详细信息，请参阅 [与隐藏的恶意软件有关的安全要求和预防措施](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)。
2. In some cases, it is possible to determine that, at a certain time, a  particular filesystem was not mounted under (or that a particular file  on the filesystem was not saved or accessed from within) a particular  instance of an operating system (e.g. by analyzing and comparing filesystem journals, file timestamps, application logs,  error logs, etc). This might indicate that a hidden operating system is  installed on the computer. The countermeasures prevent these issues. 
   在某些情况下，可以确定在某个时间，特定文件系统没有被安装在操作系统的特定实例下（或者文件系统上的特定文件没有被保存或从内部访问）（例如，通过分析和比较文件系统日志、文件时间戳、应用日志、错误日志等）。这可能表明计算机上安装了隐藏的操作系统。对策可以防止这些问题。
3. It prevents data corruption and allows safe hibernation. When Windows  resumes from hibernation, it assumes that all mounted filesystems are in the same state as when the system entered hibernation. VeraCrypt  ensures this by write-protecting any filesystem accessible both from within the decoy and hidden systems. Without such protection, the filesystem could become corrupted when mounted by one system while  the other system is hibernated. 
   它可以防止数据损坏并允许安全休眠。当Windows从休眠状态恢复时，它假定所有装入的文件系统都处于与系统进入休眠时相同的状态。VeraCrypt通过写保护可从诱饵系统和隐藏系统内访问的任何文件系统来确保这一点。如果没有这样的保护，当一个系统挂载文件系统而另一个系统处于休眠状态时，文件系统可能会被损坏。

If you need to securely transfer files from the decoy system to the hidden system, follow these steps:
如果您需要安全地将文件从诱饵系统传输到隐藏系统，请按照以下步骤操作：

1. Start the decoy system.  启动诱饵系统。
2. Save the files to an unencrypted volume or to an outer/normal VeraCrypt volume. 
   将文件保存到未加密的加密卷或外部/普通VeraCrypt加密卷。
3. Start the hidden system  启动隐藏系统
4. If you saved the files to a VeraCrypt volume, mount it (it will be automatically mounted as read-only). 
   如果您将文件保存到VeraCrypt加密卷，请挂载它（它将自动挂载为只读）。
5. Copy the files to the hidden system partition or to another hidden volume. 
   将文件复制到隐藏的系统分区或另一个隐藏卷。

 

#### Possible Explanations for Existence of Two VeraCrypt Partitions on Single Drive 单个驱动器上存在两个VeraCrypt分区的可能解释

An adversary might ask why you created two VeraCrypt-encrypted  partitions on a single drive (a system partition and a non-system  partition) rather than encrypting the entire disk with a single  encryption key. There are many possible reasons to do that. However, if you do not know any (other than creating a hidden operating system), you can provide, for example, one of the following explanations:
攻击者可能会问，为什么在一个硬盘上创建两个VeraCrypt加密分区（一个系统分区和一个非系统分区），而不是用一个加密密钥加密整个硬盘。有很多可能的原因这样做。但是，如果你不知道任何（除了创建一个隐藏的操作系统），你可以提供，例如，以下解释之一：

- If there are more than two partitions on a system drive and you want to  encrypt only two of them (the system partition and the one behind it)  and to leave the other partitions unencrypted (for example, to achieve  the best possible performance when reading and writing data, which is not sensitive, to such unencrypted partitions),  the only way to do that is to encrypt both partitions separately (note  that, with a single encryption key, VeraCrypt could encrypt the entire  system drive and

  all

   partitions on it, but it cannot encrypt only two of them — only one or  all of the partitions can be encrypted with a single key). As a result,  there will be two adjacent VeraCrypt partitions on the system drive (the first will be a system partition, the second will be a non-system one), each encrypted with a different key (which is also the case when you  create a hidden operating system, and therefore it can be explained this way).

  
  如果系统驱动器上有两个以上的分区，并且您只想加密其中的两个分区（系统分区及其后面的分区），而不加密其他分区（例如，为了在阅读和 写入数据，这是不敏感的，这样的未加密分区），唯一的方法是分别加密两个分区（请注意，用一个加密密钥，VeraCrypt可以加密整个系统驱动器， *所有*分区，但它不能只加密其中的两个-只有一个或所有分区可以用单个密钥加密）。因此，系统驱动器上会有两个相邻的VeraCrypt分区（ 第一个是系统分区，第二个是非系统分区），每个分区都用不同的密钥加密（创建隐藏的操作系统时也是如此，因此可以这样解释）。

  If you do not know any good reason why there should be more than one partition on a system drive at all:

  
  如果您不知道为什么系统驱动器上应该有多个分区的任何好理由：

  It is generally recommended to separate non-system files (documents)  from system files. One of the easiest and most reliable ways to do that  is to create two partitions on the system drive; one for the operating  system and the other for documents (non-system files). The reasons why this practice is recommended include:

  
  通常建议将非系统文件（文档）与系统文件分开。最简单和最可靠的方法之一是在系统驱动器上创建两个分区;一个用于操作系统，另一个用于文档（非系统 文件）。建议采用这种做法的理由包括：

  - If the filesystem on one of the partitions is damaged, files on the  partition may get corrupted or lost, whereas files on the other  partition are not affected. 
    如果其中一个分区上的文件系统损坏，则该分区上的文件可能会损坏或丢失，而另一个分区上的文件则不会受到影响。
  - It is easier to reinstall the system without losing your documents  (reinstallation of an operating system involves formatting the system  partition, after which all files stored on it are lost). If the system  is damaged, full reinstallation is often the only option. 
    在不丢失文档的情况下重新安装系统更容易（重新安装操作系统涉及格式化系统分区，之后存储在系统分区上的所有文件都会丢失）。如果系统损坏，完全重新安装通常是唯一的选择。

- A [ cascade encryption algorithm](https://veracrypt.fr/en/Cascades.html) (e.g. AES-Twofish-Serpent) can be many times slower than a non-cascade one (e.g. [ AES](https://veracrypt.fr/en/AES.html)). However, a cascade encryption algorithm may be more secure  than a non-cascade one (for example, the probability that three distinct encryption algorithms will be broken, e.g. due to advances in  cryptanalysis, is significantly lower than the probability that only one of them will be broken). Therefore, if you encrypt the  outer volume with a cascade encryption algorithm and the decoy system  with a non-cascade encryption algorithm, you can answer that you wanted  the best performance (and adequate security) for the system partition, and the highest possible security (but worse  performance) for the non-system partition (i.e. the outer volume), where you store the most sensitive data, which you do not need to access very often (unlike the operating system, which you use very often, and therefore you need it to have the best possible performance). On the system partition, you store data that is less  sensitive (but which you need to access very often) than data you store  on the non-system partition (i.e. on the outer volume). 
  [级联加密算法](https://veracrypt.fr/en/Cascades.html)（例如AES-Twofish-Serpent）可能比非级联加密算法（例如 [AES](https://veracrypt.fr/en/AES.html)）。然而，级联加密算法可能比非级联加密算法更安全（例如，由于密码分析的进步，三个不同的加密算法将被破坏的概率显著低于仅其中一个将被破坏的概率）。因此，如果您使用级联加密算法加密外部卷，使用非级联加密算法加密诱饵系统，则可以回答您希望获得最佳性能（和足够的安全性），以及尽可能高的安全性（但性能更差）（即外部卷），您在其中存储最敏感的数据，您不需要经常访问这些数据（与您经常使用的操作系统不同，因此您需要它具有最佳性能）。 在系统分区上，您存储的数据比存储在非系统分区（即外部卷）上的数据敏感性低（但您需要经常访问）。

- Provided that you encrypt the outer volume with a cascade encryption  algorithm (e.g. AES-Twofish-Serpent) and the decoy system with a  non-cascade encryption algorithm (e.g. AES), you can also answer that  you wanted to prevent the problems about which VeraCrypt warns when the user attempts to choose a cascade encryption algorithm  for system encryption (see below for a list of the problems). Therefore, to prevent those problems, you decided to encrypt the system partition  with a non-cascade encryption algorithm. However, you still wanted to use a cascade encryption algorithm (because it is  more secure than a non-cascade encryption algorithm) for the most  sensitive data, so you decided to create a second partition, which those problems do

  not

   affect (because it is non-system) and to encrypt it with a cascade  encryption algorithm. On the system partition, you store data that is  less sensitive than data you store on the non-system partition (i.e. on  the outer volume).

  
  假设您使用级联加密算法（例如AES-Twofish-Serpent）加密外部卷，使用非级联加密算法（例如AES）加密诱饵系统，您也可以回答您希望防止VeraCrypt 当用户尝试为系统加密选择级联加密算法时会发出警告（请参阅下面的问题列表）。因此，为了防止这些问题，您决定使用非级联加密算法加密系统分区。然而，在这方面， 您仍然希望对最敏感的数据使用级联加密算法（因为它比非级联加密算法更安全），因此您决定创建第二个分区，这是这些问题所做的 *不受*影响（因为它是非系统的），并使用级联加密算法对其进行加密。在系统分区上，存储的数据比存储在非系统分区（即外部卷）上的数据敏感性低。

  Note: When the user attempts to encrypt the system partition with a  cascade encryption algorithm, VeraCrypt warns him or her that it can  cause the following problems (and implicitly recommends to choose a  non-cascade encryption algorithm instead):

  
  注意事项：当用户尝试使用级联加密算法对系统分区进行加密时，VeraCrypt会警告用户这可能会导致以下问题（并建议用户选择非级联加密算法）：

  - For cascade encryption algorithms, the VeraCrypt Boot Loader is larger  than normal and, therefore, there is not enough space in the first drive track for a backup of the VeraCrypt Boot Loader. Hence, *whenever* it gets damaged (which often happens, for example, during  inappropriately designed anti-piracy activation procedures of certain  programs), the user must use the VeraCrypt Rescue Disk to repair the  VeraCrypt Boot Loader or to boot. 
    对于级联加密算法，VeraCrypt靴子Loader比正常情况下的要大，因此第一个磁盘磁道中没有足够的空间来备份VeraCrypt靴子Loader。因此，我们认为， *当*它被损坏时（这经常发生，例如，在某些程序的反盗版激活程序设计不当时），用户必须使用VeraCrypt修复盘来修复VeraCrypt靴子加载程序或进行靴子。
  - On some computers, resuming from hibernation takes longer. 
    在某些计算机上，从休眠状态恢复需要更长的时间。

- In contrast to a password for a non-system VeraCrypt volume, a pre-boot  authentication password needs to be typed each time the computer is  turned on or restarted. Therefore, if the pre-boot authentication  password is long (which is required for security purposes), it may be very tiresome to type it so frequently. Hence, you can answer that it was more convenient for you to use a short (and therefore  weaker) password for the system partition (i.e. the decoy system) and  that it is more convenient for you to store the most sensitive data (which you do not need to access as often) in the  non-system VeraCrypt partition (i.e. in the outer volume) for which you  chose a very long password. 
  与非系统VeraCrypt加密卷的密码不同，每次打开或重启计算机时都需要输入预启动验证密码。因此，如果预引导身份验证密码很长（出于安全目的，这是必需的）， 那么频繁地打它可能很烦人。因此，您可以回答说，为系统分区（即诱饵系统）使用简短（因此较弱）的密码更方便，并且将 在非系统VeraCrypt分区（即外部卷）中的最敏感的数据（您不需要经常访问），您为其选择了一个很长的密码。
  
   As the password for the system partition is not very strong (because it  is short), you do not intentionally store sensitive data on the system  partition. However, you still prefer the system partition to be  encrypted, because potentially sensitive or mildly sensitive data is stored on it as a result of your everyday use of the  computer (for example, passwords to online forums you visit, which can  be automatically remembered by your browser, browsing history,  applications you run, etc.) 
  由于系统分区的密码不是很强（因为它很短），所以不要故意将敏感数据存储在系统分区上。但是，您仍然希望对系统分区进行加密，因为它可能是敏感的或轻度的。 由于您日常使用计算机，敏感数据存储在其中（例如，您访问的在线论坛的密码，浏览器可以自动记住，浏览历史记录，您运行的应用程序等）。

- When an attacker gets hold of your computer when a VeraCrypt volume is  mounted (for example, when you use a laptop outside), he can, in most  cases, read any data stored on the volume (data is decrypted on the fly  as he reads it). Therefore, it may be wise to limit the time the volume is mounted to a minimum. Obviously, this may  be impossible or difficult if the sensitive data is stored on an  encrypted system partition or on an entirely encrypted system drive  (because you would also have to limit the time you work with the computer to a minimum). Hence, you can answer that you created a separate partition (encrypted with a different key than your system  partition) for your most sensitive data and that you mount it only when  necessary and dismount it as soon as possible (so as to limit the time the volume is mounted to a minimum). On the  system partition, you store data that is less sensitive (but which you  need to access often) than data you store on the non-system partition  (i.e. on the outer volume). 
  当攻击者在安装VeraCrypt加密卷时（例如，当您在室外使用笔记本电脑时）控制您的计算机时，在大多数情况下，他可以读取存储在该加密卷上的任何数据（数据在他读取时被动态解密）。因此，明智的做法是将卷的挂载时间限制在最小值。显然，如果敏感数据存储在加密的系统分区或完全加密的系统驱动器上，这可能是不可能或困难的（因为您还必须将使用计算机的时间限制在最低限度）。因此，您可以回答说，您为最敏感的数据创建了一个单独的分区（使用与系统分区不同的密钥加密），并且仅在必要时才挂载它，并尽快将其重新加载（以便将卷挂载的时间限制在最低限度）。在系统分区上，存储的数据比存储在非系统分区上的数据敏感性低（但需要经常访问）。 在外部体积上）。

 

#### Safety/Security Precautions and Requirements Pertaining to Hidden Operating Systems 与隐藏操作系统相关的安全/安保预防措施和要求

As a hidden operating system resides in a hidden VeraCrypt volume, a  user of a hidden operating system must follow all of the security  requirements and precautions that apply to normal hidden VeraCrypt  volumes. These requirements and precautions, as well as additional requirements and precautions pertaining specifically to  hidden operating systems, are listed in the subsection [ Security Requirements and Precautions Pertaining to Hidden Volumes](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html).
由于隐藏操作系统位于隐藏的VeraCrypt加密卷中，因此隐藏操作系统的用户必须遵守适用于普通隐藏VeraCrypt加密卷的所有安全要求和预防措施。这些要求和注意事项，以及 与隐藏操作系统相关的附加要求和预防措施，在小节中列出 [与隐藏的恶意软件有关的安全要求和预防措施](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)。

WARNING: If you do not protect the hidden volume (for information on how to do so, refer to the section [ Protection of Hidden Volumes Against Damage](https://veracrypt.fr/en/Protection of Hidden Volumes.html)), do  *not* write to the outer volume (note that the decoy operating system is  *not* installed in the outer volume). Otherwise, you may overwrite  and damage the hidden volume (and the hidden operating system within  it)!
加密：如果您不保护隐藏卷（有关如何保护的信息，请参阅 [保护隐藏的磁盘免受损害](https://veracrypt.fr/en/Protection of Hidden Volumes.html)），*不要*写入外部卷（注意诱饵操作系统*没有*安装在外部卷中）。否则，您可能会覆盖并损坏隐藏卷（以及其中隐藏的操作系统）！

If all the instructions in the wizard have been followed and if the  security requirements and precautions listed in the subsection [ Security Requirements and Precautions Pertaining to Hidden Volumes](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)  are followed, it should be impossible to prove that the hidden volume  and hidden operating system exist, even when the outer volume is mounted or when the decoy operating system is decrypted or started.
如果已遵循向导中的所有说明，并且子部分中列出的安全要求和注意事项 遵循[与隐藏卷相关的安全要求和注意事项](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)，即使安装了外部卷或解密或启动了诱饵操作系统，也不可能证明隐藏卷和隐藏操作系统的存在。

 

------

\* It is not practical (and therefore is not supported) to install  operating systems in two VeraCrypt volumes that are embedded within a  single partition, because using the outer operating system would often require data to be written to the area of the hidden  operating system (and if such write operations were prevented using the [ hidden volume protection](https://veracrypt.fr/en/Protection of Hidden Volumes.html) feature, it would inherently cause system crashes, i.e. 'Blue Screen' errors).
\* 在两个VeraCrypt卷中安装操作系统并嵌入在一个分区中是不实际的（因此不支持），因为使用外部操作系统 通常需要将数据写入隐藏操作系统的区域（并且如果使用 [隐藏卷保护](https://veracrypt.fr/en/Protection of Hidden Volumes.html)功能，它会固有地导致系统崩溃，即'蓝屏'错误）。
 † This does not apply to filesystems on CD/DVD-like media and on custom, atypical, or non-standard devices/media.
†这不适用于类似CD/DVD的介质以及自定义、非典型或非标准设备/介质上的文件系统。

# Main Program Window 主程序窗口

### Select File 选择文件

Allows you to select a file-hosted VeraCrypt volume. After you select it, you  can perform various operations on it (e.g., mount it by clicking  ‘Mount’). It is also possible to select a volume by dragging its icon to the ‘VeraCrypt.exe’ icon (VeraCrypt will be automatically launched then) or to the main  program window.
允许您选择一个文件托管的VeraCrypt加密卷。选择它之后，您可以对其执行各种操作（例如，通过单击“安装”来安装它）。您也可以通过将加密卷的图标拖到“VeraCrypt.exe”图标（VeraCrypt将自动启动）或主程序窗口来选择加密卷。

### Select Device 选择装置

Allows you to select a VeraCrypt partition or a storage device (such as a USB  memory stick). After it is selected, you can perform various operations  with it (e.g., mount it by clicking ‘Mount’).
允许您选择VeraCrypt分区或存储设备（如U盘）。选中后，您可以对其执行各种操作（例如，通过单击“安装”来安装它）。

 Note: There is a more comfortable way of mounting VeraCrypt partitions/devices – see the section *Auto-Mount Devices* for more information.
注意：有一种更方便的方法来安装VeraCrypt分区/设备-请参阅 有关详细信息，请*参阅“自动安装设备”*。

### Mount 山

After you click ‘Mount’, VeraCrypt will try to mount the selected volume  using cached passwords (if there are any) and if none of them works, it  prompts you for a password. If you enter the correct password (and/or  provide correct keyfiles), the volume will be mounted.
点击“挂载”后，VeraCrypt会尝试使用缓存的密码（如果有的话）挂载选定的加密卷，如果没有一个密码可以使用，它会提示您输入密码。如果您输入正确的密码（和/或提供正确的密钥文件），卷将被挂载。

Important: Note that when you exit the VeraCrypt application, the VeraCrypt driver continues working and no VeraCrypt volume is dismounted.
重要提示：请注意，当您退出VeraCrypt应用程序时，VeraCrypt驱动程序会继续工作，并且没有VeraCrypt加密卷会被删除。

### Auto-Mount Devices 自动安装器件

This function allows you to mount VeraCrypt partitions/devices without  having to select them manually (by clicking ‘Select Device’). VeraCrypt  scans headers of all available partitions/devices on your system (except DVD drives and similar devices) one by one and tries to mount each of them as a VeraCrypt volume. Note  that a VeraCrypt partition/device cannot be identified, nor the cipher  it has been encrypted with. Therefore, the program cannot directly  “find” VeraCrypt partitions. Instead, it has to try mounting each (even unencrypted) partition/device using  all encryption algorithms and all cached passwords (if there are any).  Therefore, be prepared that this process may take a long time on slow  computers.
此功能允许您挂载VeraCrypt分区/设备，而无需手动选择（点击“选择设备”）。VeraCrypt扫描系统上所有可用分区/设备的头文件（DVD驱动器和类似设备除外） 并尝试将每个加密卷挂载为VeraCrypt加密卷。请注意，无法识别VeraCrypt分区/设备，也无法识别其加密的密码。因此，程序不能直接“找到”VeraCrypt分区。相反地， 它必须尝试使用所有加密算法和所有缓存的密码（如果有的话）来挂载每个（甚至是未加密的）分区/设备。因此，请准备好，在慢速计算机上此过程可能需要很长时间。

 If the password you enter is wrong, mounting is attempted using cached  passwords (if there are any). If you enter an empty password and if *Use keyfiles* is unchecked, only the cached passwords will be used when attempting to auto-mount partitions/devices. If you do not need to set mount options, you can bypass the password prompt by holding down the *Shift* key when clicking *Auto- Mount Devices* (only cached passwords will be used, if there are any).
如果您输入的密码错误，则尝试使用缓存密码（如果有）进行挂载。如果输入空密码，并且 *如果未选中使用密钥文件*，则在尝试自动挂载分区/设备时将只使用缓存的密码。如果不需要设置装载选项，则可以通过按住 *Shift*键时，单击*自动挂载设备*（只有缓存的密码将被使用，如果有的话）.

 Drive letters will be assigned starting from the one that is selected in the drive list in the main window.
驱动器号将从主窗口驱动器列表中选择的驱动器号开始分配。

### Dismount 下马

This function allows you to dismount the VeraCrypt volume selected in the  drive list in the main window. To dismount a VeraCrypt volume means to  close it and make it impossible to read/write from/to the volume.
这个功能允许您在主窗口的驱动器列表中选择VeraCrypt加密卷。关闭一个VeraCrypt加密卷意味着关闭它并使其无法读写。

### Dismount All 卸装所有

Note: The information in this section applies to all menu items and buttons  with the same or similar caption (for example, it also applies to the  system tray menu item *Dismount All*).
注意事项：本节中的信息适用于具有相同或相似标题的所有菜单项和按钮（例如，它也适用于系统托盘菜单项 *全部卸载*）。

 This function allows you to dismount multiple VeraCrypt volumes. To  dismount a VeraCrypt volume means to close it and make it impossible to  read/write from/to the volume. This function dismounts all mounted  VeraCrypt volumes except the following:
这个函数允许你加密多个VeraCrypt加密卷。关闭一个VeraCrypt加密卷意味着关闭它并使其无法读写。此函数卸载所有已挂载的VeraCrypt加密卷，以下加密卷除外：

- Partitions/drives within the key scope of active system encryption (e.g., a system  partition encrypted by VeraCrypt, or a non-system partition located on a system drive encrypted by VeraCrypt, mounted when the encrypted  operating system is running). 
  主动系统加密的密钥范围内的分区/驱动器（例如，由VeraCrypt加密的系统分区，或位于由VeraCrypt加密的系统驱动器上的非系统分区，在加密操作系统运行时挂载）。
- VeraCrypt volumes that are not fully accessible to the user account (e.g. a volume mounted from within another user account). 
  用户帐户不能完全访问的VeraCrypt加密卷（例如，从另一个用户帐户中挂载的加密卷）。
- VeraCrypt volumes that are not displayed in the VeraCrypt application window. For example, system favorite volumes attempted to be dismounted by an  instance of VeraCrypt without administrator privileges when the option '*Allow only administrators to view and dismount system favorite volumes in VeraCrypt*' is enabled. 
  VeraCrypt加密卷不会显示在VeraCrypt应用程序窗口中。例如，当“*仅允许管理员在VeraCrypt中查看和删除系统收藏*夹”选项被启用时，系统收藏夹试图被没有管理员权限的VeraCrypt实例删除。

### Wipe Cache 擦除缓存

Clears all passwords (which may also contain processed keyfile contents)  cached in driver memory. When there are no passwords in the cache, this  button is disabled. For information on password cache, see the section [ *Cache Password in Driver Memory*](https://veracrypt.fr/en/Mounting VeraCrypt Volumes.html).
清除驱动程序内存中缓存的所有密码（也可能包含已处理的密钥文件内容）。当该高速缓存中没有密码时，此按钮将被禁用。有关密码缓存的信息，请参阅 [*在驱动程序内存中缓存密码*](https://veracrypt.fr/en/Mounting VeraCrypt Volumes.html)。

### Never Save History 从不保存历史记录

If this option disabled, the file names and/or paths of the last twenty  files/devices that were attempted to be mounted as VeraCrypt volumes  will be saved in the History file (whose content can be displayed by  clicking on the Volume combo-box in the main window).
如果此选项被禁用，最近20个试图挂载为VeraCrypt加密卷的文件/设备的文件名和/或路径将保存在历史文件中（其内容可以通过点击主目录中的"加密卷“组合框来显示）。 窗口）。

 When this option is enabled, VeraCrypt clears the registry entries  created by the Windows file selector for VeraCrypt, and sets the  “current directory” to the user’s home directory (in portable mode, to  the directory from which VeraCrypt was launched) whenever a container or keyfile is selected via the Windows  file selector. Therefore, the Windows file selector will not remember  the path of the last mounted container (or the last selected keyfile).  However, note that the operations described in this paragraph are *not* guaranteed to be performed reliably and securely (see e.g. [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html)) so we strongly recommend that you encrypt the system partition/drive instead of relying on them (see [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)).
启用此选项后，VeraCrypt会清除Windows文件选择器为VeraCrypt创建的注册表项，并将“当前目录”设置为用户的主目录（在可移植模式下，为VeraCrypt运行的目录）。 启动）时，通过Windows文件选择器选择容器或密钥文件。因此，Windows文件选择器不会记住最后一个挂载的容器（或最后一个选择的密钥文件）的路径。但是，请注意， 本段*不*保证可靠和安全地执行（参见例如， [*安全要求和注意事项*](https://veracrypt.fr/en/Security Requirements and Precautions.html)），因此我们强烈建议您加密系统分区/驱动器，而不是依赖它们（请参阅 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)）。

 Furthermore, if this option is enabled, the volume path input field in  the main VeraCrypt window is cleared whenever you hide VeraCrypt.
此外，如果启用了这个选项，当您隐藏VeraCrypt时，VeraCrypt主窗口中的加密卷路径输入字段将被清除。

 Note: You can clear the volume history by selecting *Tools* -> *Clear Volume History*.
注意：您可以通过选择*工具*->*清除卷历史记录来*清除卷历史记录。

### Exit 出口

Terminates the VeraCrypt application. The driver continues working and no  VeraCrypt volumes are dismounted. When running in ‘portable’ mode, the  VeraCrypt driver is unloaded when it is no longer needed (e.g., when all instances of the main application and/or of the Volume Creation Wizard are closed and no VeraCrypt  volumes are mounted). However, if you force dismount on a
终止VeraCrypt应用程序。驱动程序继续工作，没有VeraCrypt加密卷被删除。当运行在“可移植”模式下时，VeraCrypt驱动程序在不再需要时被卸载（例如，当主应用程序和/或加密卷创建向导的所有实例都关闭并且没有挂载VeraCrypt加密卷时）。但是，如果您在

VeraCrypt volume when VeraCrypt runs in portable mode, or mount a writable  NTFS-formatted volume on Windows Vista or later, the VeraCrypt driver  may *not* be unloaded when you exit VeraCrypt (it will be unloaded only when you  shut down or restart the system). This prevents various problems caused  by a bug in Windows (for instance, it would be impossible to start  VeraCrypt again as long as there are applications using the dismounted volume).
VeraCrypt卷当VeraCrypt运行在便携模式下，或在Windows Vista或更高版本上挂载可写NTFS格式的卷时，VeraCrypt驱动程序可能 退出VeraCrypt时*不会*卸载（仅当您关闭或重新启动系统时才会卸载）。这可以防止Windows中的漏洞导致的各种问题（例如，只要有应用程序使用加密卷，就不可能再次启动VeraCrypt）。

### Volume Tools 体积工具

#### Change Volume Password 更改卷密码

See the section [ *Volumes -> Change Volume Password*](https://veracrypt.fr/en/Program Menu.html).
请参阅“[*更改卷密码”部分*](https://veracrypt.fr/en/Program Menu.html)。

#### Set Header Key Derivation Algorithm 集合头密钥推导算法

See the section [ *Volumes -> Set Header Key Derivation Algorithm*](https://veracrypt.fr/en/Program Menu.html).
请参阅“[*设置头密钥派生算法*](https://veracrypt.fr/en/Program Menu.html)”部分。

#### Backup Volume Header 支持Volume Header

See the section [ *Tools -> Backup Volume Header*](https://veracrypt.fr/en/Program Menu.html#tools-backup-volume-header).
请参阅[*工具->备份卷标题一*](https://veracrypt.fr/en/Program Menu.html#tools-backup-volume-header)节。

#### Restore Volume Header 还原卷标题

See the section [ *Tools -> Restore Volume Header*](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header).
请参阅[*工具-%3 E恢复卷标题部分*](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header)。

 

## Program Menu 程序菜单

Note: To save space, only the menu items that are not self-explanatory are described in this documentation.
注意：为了节省空间，本文档中只描述了不不言自明的菜单项。

### Volumes -> Auto-Mount All Device-Hosted Volumes 主机->自动装载所有设备托管主机

See the section [ *Auto-Mount Devices.*](https://veracrypt.fr/en/Main Program Window.html)
请参阅[*自动装载设备一节。*](https://veracrypt.fr/en/Main Program Window.html)

### Volumes -> Dismount All Mounted Volumes ->卸载所有已安装的

See the section [ *Dismount All.*](https://veracrypt.fr/en/Main Program Window.html)
请参见全部[*卸载一节。*](https://veracrypt.fr/en/Main Program Window.html)

### Volumes -> Change Volume Password 删除->更改卷密码

Allows changing the password of the currently selected VeraCrypt volume (no  matter whether the volume is hidden or standard). Only the header key  and the secondary header key (XTS mode) are changed – the master key  remains unchanged. This function re-encrypts the volume header using
允许更改当前选定VeraCrypt加密卷的密码（无论加密卷是隐藏加密卷还是标准加密卷）。仅更改标头密钥和辅助标头密钥（XTS模式）-主密钥保持不变。此函数 重新加密卷标头，使用

 a header encryption key derived from a new password. Note that the  volume header contains the master encryption key with which the volume  is encrypted. Therefore, the data stored on the volume will *not* be lost after you use this function (password change will only take a few seconds).
从新密码导出的报头加密密钥。请注意，卷标头包含用于加密卷的主加密密钥。因此，存储在卷上的数据将 使用此功能后*不会*丢失密码（更改密码只需几秒钟）。

 To change a VeraCrypt volume password, click on *Select File* or *Select Device*, then select the volume, and from the *Volumes* menu select *Change Volume Password*.
要更改VeraCrypt加密卷密码，点击*选择文件*或*选择设备*，然后选择加密卷，从 *在“更改**卷密码”*菜单中选择“更改卷密码”。

 Note: For information on how to change a password used for pre-boot authentication, please see the section *System -> Change Password*.
注意：有关如何更改用于预引导身份验证的密码的信息，请参阅 *系统->更改密码*。

 See also the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html).
另请参阅“[*安全要求和注意事项”*](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章。

#### PKCS-5 PRF

In this field you can select the algorithm that will be used in deriving  new volume header keys (for more information, see the section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)) and in generating the new salt (for more information, see the section [ *Random Number Generator*](https://veracrypt.fr/en/Random Number Generator.html)).
在此字段中，您可以选择将用于派生新卷标题键的算法（有关详细信息，请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）以及生成新盐（有关更多信息，请参阅部分 [*随机数生成器*](https://veracrypt.fr/en/Random Number Generator.html)）。

 Note: When VeraCrypt re-encrypts a volume header, the original volume  header is first overwritten many times (3, 7, 35 or 256 depending on the user choice) with random data to prevent adversaries from using  techniques such as magnetic force microscopy or magnetic force scanning tunneling microscopy [17] to recover the overwritten  header (however, see also the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html)).
注意事项：当VeraCrypt重新加密卷标头时，原始卷标头首先会被随机数据覆盖多次（3次、7次、35次或256次，取决于用户的选择），以防止攻击者使用磁力显微镜或磁 强制扫描隧道显微镜[17]恢复被覆盖的报头（但是，也请参见本章 [*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)）。

### Volumes -> Set Header Key Derivation Algorithm EST->集标头密钥派生算法

This function allows you to re-encrypt a volume header with a header key  derived using a different PRF function (for example, instead of  HMAC-BLAKE2S-256 you could use HMAC-Whirlpool). Note that the volume  header contains the master encryption key with which the volume is encrypted. Therefore, the data stored on the volume will *not* be lost after you use this function. For more information, see the section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html).
此函数允许您使用不同的PRF函数（例如，您可以使用HMAC-Whirlpool而不是HMAC-BLAKE 2S-256）导出的头密钥重新加密卷头。请注意，卷标头包含主加密密钥， 该卷被加密。因此，使用此功能后，存储在卷上的数据*不会*丢失。有关更多信息，请参阅部分 [*Header Key Derivation、Salt和Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)。

 Note: When VeraCrypt re-encrypts a volume header, the original volume  header is first overwritten many times (3, 7, 35 or 256 depending on the user choice) with random data to prevent adversaries from using  techniques such as magnetic force microscopy or magnetic force scanning tunneling microscopy [17] to recover the overwritten  header (however, see also the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html)).
注意事项：当VeraCrypt重新加密卷标头时，原始卷标头首先会被随机数据覆盖多次（3次、7次、35次或256次，取决于用户的选择），以防止攻击者使用磁力显微镜或磁 强制扫描隧道显微镜[17]恢复被覆盖的报头（但是，也请参见本章 [*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)）。

### Volumes -> Add/Remove Keyfiles to/from Volume 目录->将密钥文件添加到卷/从卷中删除密钥文件

### Volumes -> Remove All Keyfiles from Volume 删除->从卷中删除所有密钥文件

See the chapter [ *Keyfiles.*](https://veracrypt.fr/en/Keyfiles.html)
参见[*密钥文件一章。*](https://veracrypt.fr/en/Keyfiles.html)

### Favorites -> Add Mounted Volume to Favorites Favorites -> Organize Favorite Volumes Favorites -> Mount Favorites Volumes 收藏夹->将装入的卷添加到收藏夹收藏夹->组织收藏夹收藏夹->装入收藏夹收藏夹

See the chapter [ *Favorite Volumes*](https://veracrypt.fr/en/Favorite Volumes.html).
请参阅[*最喜爱的章节*](https://veracrypt.fr/en/Favorite Volumes.html)。

### Favorites -> Add Mounted Volume to System Favorites 收藏夹->将装入的卷添加到系统收藏夹

### Favorites -> Organize System Favorite Volumes 收藏夹->组织系统收藏夹

See the chapter [ *System Favorite Volumes*](https://veracrypt.fr/en/System Favorite Volumes.html).
请参阅“[*系统收藏夹”一章*](https://veracrypt.fr/en/System Favorite Volumes.html)。

### System -> Change Password 系统->更改密码

Changes the password used for pre-boot authentication (see the chapter *System Encryption*). WARNING: Your VeraCrypt Rescue Disk allows you to restore key data if  it is damaged. By doing so, you also restore the password that was valid when the VeraCrypt Rescue Disk was created. Therefore, whenever you change the password,  you should destroy your VeraCrypt Rescue Disk and create a new one  (select *System* -> *Create Rescue Disk*). Otherwise, an attacker could decrypt your system partition/drive using  the old password (if he finds the old VeraCrypt Rescue Disk and uses it  to restore the key data). See also the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html).
更改用于预引导身份验证的密码（请参阅"*系统加密“*一章）。密码：如果密钥数据损坏，VeraCrypt救援盘允许您恢复密钥数据。通过这样做，您还可以恢复当VeraCrypt 已创建救援磁盘。因此，每当您更改密码时，您应该销毁您的VeraCrypt救援盘并创建一个新的（选择 *系统*->*创建救援盘*）。否则，攻击者可以使用旧密码解密您的系统分区/驱动器（如果他找到旧的VeraCrypt救援盘并使用它来恢复密钥数据）。另见本章 [*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)。

 For more information on changing a password, please see the section *Volumes -> Change Volume Password* above.
有关更改密码的详细信息，请参阅上面的“*更改卷密码”部分*。

### System -> Mount Without Pre-Boot Authentication 系统->在没有预引导身份验证的情况下装载

Check this option, if you need to mount a partition that is within the key  scope of system encryption without pre-boot authentication. For example, if you need to mount a partition located on the encrypted system drive  of another operating system that is not running. This can be useful e.g. when you need to back up or repair an operating system encrypted by VeraCrypt (from within another  operating system).
如果您需要挂载系统加密密钥范围内的分区而无需预引导身份验证，请选中此选项。例如，如果您需要挂载位于另一个未运行的操作系统的加密系统驱动器上的分区。例如，当您需要备份或修复由VeraCrypt加密的操作系统（从另一个操作系统）时，这可能很有用。

Note 1: If you need to mount multiple partitions at once, click *‘Auto-Mount Devices*’, then click ‘*Mount Options*’ and enable the option ‘*Mount partition using system encryption without pre-boot authentication*’.
注1：如果您需要一次挂载多个分区，请单击*“自动挂载设备*”，然后单击“*挂载选项*”并启用“*使用系统加密挂载分区而无需预引导身份验证*”选项。

 Please note you cannot use this function to mount extended (logical)  partitions that are located on an entirely encrypted system drive.
请注意，您不能使用此功能来挂载位于完全加密的系统驱动器上的扩展（逻辑）分区。

### Tools -> Clear Volume History 工具->清除卷历史记录

Clears the list containing the file names (if file-hosted) and paths of the last twenty successfully mounted volumes.
清除包含最近二十个成功装入的卷的文件名（如果是文件托管的）和路径的列表。

### Tools -> Traveler Disk Setup 工具->旅行盘设置

See the chapter [ *Portable Mode.*](https://veracrypt.fr/en/Portable Mode.html)
请参阅便携模式一章[*。*](https://veracrypt.fr/en/Portable Mode.html)

### Tools -> Keyfile Generator 工具->密钥文件生成器

See section *Tools -> Keyfile Generator* in the chapter [ *Keyfiles.*](https://veracrypt.fr/en/Keyfiles.html)
请参阅密钥文件一章中的*工具->密钥文件生成器*[*一节。*](https://veracrypt.fr/en/Keyfiles.html)

### Tools -> Backup Volume Header 工具->备份卷标题

### Tools -> Restore Volume Header 工具->还原卷标题

If the header of a VeraCrypt volume is damaged, the volume is, in most  cases, impossible to mount. Therefore, each volume created by VeraCrypt  (except system partitions) contains an embedded backup header, located  at the end of the volume. For extra safety, you can also create external volume header backup files. To do so,  click *Select Device* or *Select File*, select the volume, select *Tools* -> *Backup Volume Header*, and then follow the instructions.
如果VeraCrypt加密卷的头部被损坏，在大多数情况下，该加密卷将无法挂载。因此，VeraCrypt创建的每个卷（系统分区除外）都包含一个嵌入的备份头，位于卷的末尾。为了额外的安全，您还可以创建外部卷头备份文件。为此，请单击*选择设备*或 *选择文件*，选择卷，选择*工具*->*备份卷头*，然后按照说明操作。

Note: For system encryption, there is no backup header at the end of the  volume. For non-system volumes, a shrink operation is done first to  ensure that all data are put at the beginning of the volume, leaving all free space at the end so that we have a place to put the backup header. For system partitions, we can't perform this needed shrink operation while Windows is running and so the backup header can't be created at the end of the partition. The alternative  way in the case of system encryption is the use of the [ Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html).
注意：对于系统加密，卷的末尾没有备份头。对于非系统卷，首先执行收缩操作，以确保所有数据都放在卷的开头，并在末尾留下所有可用空间，以便我们有地方放置备份头。对于系统分区，我们不能在Windows运行时执行此必要的收缩操作，因此无法在分区的末尾创建备份头。在系统加密的情况下，另一种方法是使用[救援磁盘](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)。

Note: A backup header (embedded or external) is *not* a copy of the original volume header because it is encrypted with a  different header key derived using a different salt (see the section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). When the volume password and/or keyfiles are changed, or when the  header is restored from the embedded (or an external) header backup,  both the volume header and the backup header (embedded in the volume) are re-encrypted with header keys derived using newly  generated salts (the salt for the volume header is different from the  salt for the backup header). Each salt is generated by the VeraCrypt  random number generator (see the section [ *Random Number Generator*](https://veracrypt.fr/en/Random Number Generator.html)).
注意：备份标头（嵌入式或外部）*不是*原始卷标头的副本，因为它是用不同的标头密钥加密的，该标头密钥使用不同的salt派生（请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。当卷密码和/或密钥文件被更改时，或者当从嵌入式（或外部）头备份恢复头时，卷头和备份头（嵌入在 卷）用使用新生成的盐（salt）导出的报头密钥重新加密（卷报头的盐不同于备份报头的盐）。每个salt由VeraCrypt随机数生成器生成（参见 [*随机数生成器*](https://veracrypt.fr/en/Random Number Generator.html)）。

Both types of header backups (embedded and external) can be used to repair a damaged volume header. To do so, click *Select Device* or *Select File*, select the volume, select *Tools* -> *Restore Volume Header*, and then follow the instructions.
两种类型的头备份（嵌入式和外部）都可以用于修复损坏的卷头。为此，请单击 *选择设备*或*选择文件*，选择卷，选择*工具*-> *恢复卷头*，然后按照说明进行操作。

 WARNING: Restoring a volume header also restores the volume password and PIM that were valid when the backup was created. Moreover, if  keyfile(s) are/is necessary to mount a volume when the backup is  created, the same keyfile(s) will be necessary to mount the volume again after the volume header is restored. For more information, see  the section [*Encryption Scheme*](https://veracrypt.fr/en/Encryption Scheme.html) in the chapter [*Technical Details*](https://veracrypt.fr/en/Technical Details.html).
恢复：恢复卷标头也会恢复创建备份时有效的卷密码和PIM。此外，如果在创建备份时需要密钥文件来装载卷，则装载卷也需要相同的密钥文件 在恢复卷标题之后再次。有关更多信息，请参阅部分 本章中[*的加密方案*](https://veracrypt.fr/en/Encryption Scheme.html) [*技术细节*](https://veracrypt.fr/en/Technical Details.html)。

 After you create a volume header backup, you might need to create a new  one only when you change the volume password and/or keyfiles, or when  you change the PIM value. Otherwise, the volume header remains  unmodified so the volume header backup remains up-to-date.
创建卷标头备份后，可能仅在更改卷密码和/或密钥文件或更改PIM值时才需要创建新的卷标头备份。否则，卷标头保持不变，因此卷标头备份保持最新。

Note: Apart from salt (which is a sequence of random numbers), external  header backup files do not contain any unencrypted information and they  cannot be decrypted without knowing the correct password and/or  supplying the correct keyfile(s). For more information, see the chapter [ *Technical Details*](https://veracrypt.fr/en/Technical Details.html).
注意事项：除了salt（一个随机数序列）之外，外部头备份文件不包含任何未加密的信息，如果不知道正确的密码和/或提供正确的密钥文件，它们就无法解密。有关详细信息，请参阅“[*技术细节”*](https://veracrypt.fr/en/Technical Details.html)一章。

When you create an external header backup, both the standard volume header  and the area where a hidden volume header can be stored is backed up,  even if there is no hidden volume within the volume (to preserve  plausible deniability of hidden volumes). If there is no hidden volume within the volume, the area reserved for the  hidden volume header in the backup file will be filled with random data  (to preserve plausible deniability).
当您创建外部标头备份时，标准卷标头和可存储隐藏卷标头的区域都将备份，即使卷中没有隐藏卷（以保留隐藏卷的合理可否认性）。如果 卷内没有隐藏卷，备份文件中为隐藏卷标题保留的区域将填充随机数据（以保留合理的可否认性）。

 When *restoring* a volume header, you need to choose the type of volume whose header you wish to restore (a standard or hidden volume). Only one volume header  can be restored at a time. To restore both headers, you need to use the  function twice (*Tools* -> *Restore Volume Header*). You will need to enter the correct password (and/or to supply the  correct keyfiles) and the non-default PIM value, if applicable, that  were valid when the volume header backup was created. The password  (and/or keyfiles) and PIM will also automatically determine the type of the volume header to restore, i.e. standard or hidden (note that  VeraCrypt determines the type through the process of trial and error).
*恢复*卷头时，您需要选择要恢复其卷头的卷类型（标准卷或隐藏卷）。一次只能还原一个卷标题。要恢复这两个标头，需要使用函数两次（*工具* ->*还原卷标题*）。您需要输入正确的密码（和/或提供正确的密钥文件）和非默认PIM值（如果适用），这些值在创建卷头备份时是有效的。密码（和/或密钥文件）和PIM也将自动确定类型 要恢复的卷头的类型，即标准或隐藏（注意VeraCrypt通过反复试验来确定类型）。

 Note: If the user fails to supply the correct password (and/or keyfiles) and/or the correct non-default PIM value twice in a row when trying to  mount a volume, VeraCrypt will automatically try to mount the volume  using the embedded backup header (in addition to trying to mount it  using the primary header) each subsequent time that the user attempts to mount the volume (until he or she clicks *Cancel*). If VeraCrypt fails to decrypt the primary header but it successfully  decrypts the embedded backup header at the same time, the volume is  mounted and the user is warned that the volume header is damaged (and  informed as to how to repair it).
注意事项：如果用户在尝试挂载一个加密卷时连续两次未能提供正确的密码（和/或密钥文件）和/或正确的非默认PIM值，VeraCrypt将自动尝试使用嵌入的备份头挂载该加密卷（除了尝试使用主加密卷挂载它之外 头），直到他或她单击 *取消）。*如果VeraCrypt未能解密主标头，但同时成功解密了嵌入的备份标头，则卷将被挂载，并警告用户卷标头已损坏（并告知如何修复）。

### Settings -> Performance and Driver Options 设置->性能和驱动程序选项

Invokes the Performance dialog window, where you can change enable or disable  AES Hardware acceleration and thread based parallelization. You can also change the following driver option:
打开“性能”对话框窗口，您可以在其中更改启用或禁用AES硬件加速和基于线程的并行化。您还可以更改以下驱动程序选项：

#### Enable extended disk control codes support 启用扩展磁盘控制代码支持

If enabled, VeraCrypt driver will support returning extended technical  information about mounted volumes through IOCTL_STORAGE_QUERY_PROPERTY  control code. This control code is always supported by physical drives  and it can be required by some applications to get technical information about a drive (e.g. the Windows fsutil  program uses this control code to get the physical sector size of a  drive.).
如果启用，VeraCrypt驱动程序将支持通过IOCTL_QUERY_PROPERTY控制代码返回有关挂载卷的扩展技术信息。物理驱动器始终支持此控制代码，某些应用程序可能需要此代码 获取有关驱动器的技术信息（例如，Windows fsutil程序使用此控制代码来获取驱动器的物理扇区大小）。
 Enabling this option brings VeraCrypt volumes behavior much closer to  that of physical disks and if it is disabled, applications can easily  distinguish between physical disks and VeraCrypt volumes since sending  this control code to a VeraCrypt volume will result in an error.
启用此选项会使VeraCrypt加密卷的行为更接近物理磁盘，如果禁用此选项，应用程序可以很容易地区分物理磁盘和VeraCrypt加密卷，因为将此控制代码发送到VeraCrypt加密卷将导致 在一个错误。
 Disable this option if you experience stability issues (like volume  access issues or system BSOD) which can be caused by poorly written  software and drivers.
如果您遇到稳定性问题（如卷访问问题或系统BSOD），这可能是由编写不好的软件和驱动程序引起的，请禁用此选项。

### Settings -> Preferences 设置->首选项

Invokes the Preferences dialog window, where you can change, among others, the following options:
打开“首选项”对话框窗口，您可以在其中更改以下选项：

#### Wipe cached passwords on exit 在退出时擦除缓存的密码

If enabled, passwords (which may also contain processed keyfile contents)  and PIM values cached in driver memory will be cleared when VeraCrypt  exits.
如果启用，当VeraCrypt退出时，缓存在驱动程序内存中的密码（也可能包含已处理的密钥文件内容）和PIM值将被清除。

#### Cache passwords in driver memory 在驱动程序内存中缓存密码

When checked, passwords and/or processed keyfile contents for up to last  four successfully mounted VeraCrypt volumes are cached. If the 'Include  PIM when caching a password' option is enabled in the Preferences,  non-default PIM values are cached alongside the passwords. This allows  mounting volumes without having to type their passwords (and selecting  keyfiles) repeatedly. VeraCrypt never saves any password or PIM values to a disk (however, see the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html)). Password caching can be enabled/disabled in the Preferences (*Settings* -> *Preferences*) and in the password prompt window. If the system partition/drive is  encrypted, caching of the pre-boot authentication password can be  enabled or disabled in the system encryption settings (*Settings* > ‘*System Encryption*’).
选中此选项后，将缓存最多最后四个成功挂载的VeraCrypt加密卷的密码和/或已处理的密钥文件内容。如果在首选项中启用了“缓存密码时包含PIM”选项，则非默认PIM值将与密码一起缓存。这允许挂载卷，而无需重复键入它们的密码（和选择密钥文件）。VeraCrypt从不将任何密码或PIM值保存到磁盘（但是，请参阅[*安全要求和注意事项*](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章）。密码缓存可以在首选项（*设置*-> *首选项*）和密码提示窗口中。如果系统分区/驱动器已加密，则可以在系统加密设置（*设置*>“*系统加密*”）中启用或禁用预启动身份验证密码的缓存。

#### Temporary Cache password during "Mount Favorite Volumes" operations “装载收藏夹”操作期间的临时缓存密码

When this option is unchecked (this is the default), VeraCrypt will display  the password prompt window for every favorite volume during the  execution of the "Mount Favorite Volumes" operation and each password is erased once the volume is mounted (unless password caching is enabled).
当此选项未选中时（默认设置），VeraCrypt将在执行“挂载收藏加密卷”操作时显示每个收藏加密卷的密码提示窗口，并且一旦该加密卷被挂载，每个密码将被删除（除非 启用密码缓存）。

 If this option is checked and if there are two or more favorite volumes, then during the operation "Mount Favorite Volumes", VeraCrypt will  first try the password of the previous favorite and if it doesn't work,  it will display password prompt window. This logic applies starting from the second favorite volume onwards. Once  all favorite volumes are processed, the password is erased from memory.
如果勾选了这个选项，并且有两个或两个以上的收藏卷，那么在“挂载收藏卷”操作中，VeraCrypt会先尝试前一个收藏卷的密码，如果不行，会显示密码提示窗口。这 逻辑从第二喜爱的卷开始向前应用。处理完所有收藏卷后，密码将从内存中删除。

This option is useful when favorite volumes share the same password since  the password prompt window will only be displayed once for the first  favorite and VeraCrypt will automatically mount all subsequent  favorites.
当收藏夹共享相同的密码时，此选项非常有用，因为密码提示窗口只会在第一个收藏夹中显示一次，VeraCrypt会自动挂载所有后续的收藏夹。

Please note that since we can't assume that all favorites use the same PRF  (hash) nor the same TrueCrypt mode, VeraCrypt uses Autodetection for the PRF of subsequent favorite volumes and it tries both TrueCryptMode  values (false, true) which means that the total mounting time will be slower compared to the individual mounting  of each volume with the manual selection of the correct PRF and the  correct TrueCryptMode.
请注意，由于我们不能假设所有收藏夹都使用相同的PRF（哈希）或TrueCrypt模式，VeraCrypt会自动检测后续收藏夹加密卷的PRF，并尝试两个TrueCryptMode值（false，true），这意味着与手动选择正确的PRF和TrueCryptMode单独安装每个加密卷相比，总安装时间会更慢。

#### Open Explorer window for successfully mounted volume 打开资源管理器窗口，查看已成功装入的卷

If this option is checked, then after a VeraCrypt volume has been  successfully mounted, an Explorer window showing the root directory of  the volume (e.g., T:\) will be automatically opened.
如果选中此选项，则在VeraCrypt加密卷成功挂载后，会出现一个资源管理器窗口，显示该加密卷的根目录（例如，T：\）将自动打开。

#### Use a different taskbar icon when there are mounted volumes 当存在已装载的卷时，请使用不同的NTFS图标

If enabled, the appearance of the VeraCrypt taskbar icon (shown within the system tray notification area) is different while a VeraCrypt volume is mounted, except the following:
如果启用，当安装VeraCrypt卷时，VeraCrypt任务栏图标（显示在系统托盘通知区域内）的外观会有所不同，但以下内容除外：

- Partitions/drives within the key scope of active system encryption (e.g., a system  partition encrypted by VeraCrypt, or a non-system partition located on a system drive encrypted by VeraCrypt, mounted when the encrypted  operating system is running). 
  主动系统加密的密钥范围内的分区/驱动器（例如，由VeraCrypt加密的系统分区，或位于由VeraCrypt加密的系统驱动器上的非系统分区，在加密操作系统运行时挂载）。
- VeraCrypt volumes that are not fully accessible to the user account (e.g. a volume mounted from within another user account). 
  用户帐户不能完全访问的VeraCrypt加密卷（例如，从另一个用户帐户中挂载的加密卷）。
- VeraCrypt volumes that are not displayed in the VeraCrypt application window. For example, system favorite volumes attempted to be dismounted by an  instance of VeraCrypt without administrator privileges when the option '*Allow only administrators to view and dismount system favorite volumes in VeraCrypt*' is enabled. 
  VeraCrypt加密卷不会显示在VeraCrypt应用程序窗口中。例如，当“*仅允许管理员在VeraCrypt中查看和删除系统收藏*夹”选项被启用时，系统收藏夹试图被没有管理员权限的VeraCrypt实例删除。

#### VeraCrypt Background Task – Enabled VeraCrypt后台任务-已启用

See the chapter [ *VeraCrypt Background Task*](https://veracrypt.fr/en/VeraCrypt Background Task.html).
请参阅[*VeraCrypt后台任务一*](https://veracrypt.fr/en/VeraCrypt Background Task.html)章。

#### VeraCrypt Background Task – Exit when there are no mounted volumes VeraCrypt后台任务-没有挂载卷时退出

If this option is checked, the VeraCrypt background task automatically and silently exits as soon as there are no mounted VeraCrypt volumes. For  more information, see the chapter [ *VeraCrypt Background Task*](https://veracrypt.fr/en/VeraCrypt Background Task.html). Note that this option cannot be disabled when VeraCrypt runs in portable mode.
如果选中此选项，VeraCrypt后台任务会在没有挂载VeraCrypt加密卷时自动退出。有关详细信息，请参阅 [*VeraCrypt后台任务*](https://veracrypt.fr/en/VeraCrypt Background Task.html).请注意，当VeraCrypt运行在便携模式下时，此选项不能被禁用。

#### Auto-dismount volume after no data has been read/written to it for 在以下时间内未向卷读取/写入数据后，将自动对卷进行重命名

After no data has been written/read to/from a VeraCrypt volume for *n* minutes, the volume is automatically dismounted.
当*n*分钟内没有数据被写入/读取VeraCrypt加密卷时，加密卷将自动关闭。

#### Force auto-dismount even if volume contains open files or directories 即使卷包含打开的文件或目录，也强制自动删除

This option applies only to auto-dismount (not to regular dismount). It  forces dismount (without prompting) on the volume being auto-dismounted  in case it contains open files or directories (i.e., file/directories  that are in use by the system or applications).
此选项仅适用于自动重定向（不适用于常规重定向）。如果卷包含打开的文件或目录（即，由系统或应用程序使用的文件/目录）。

# Mounting VeraCrypt Volumes 安装VeraCrypt加密货币

If you have not done so yet, please read the sections ‘*Mount*‘ and ‘*Auto-Mount Devices*‘ in the chapter [*Main Program Window*](https://veracrypt.fr/en/Main Program Window.html).
如果您还没有这样做，请阅读本章中的“*挂载*”和“*自动挂载设备*”部分 [*主程序窗口*](https://veracrypt.fr/en/Main Program Window.html)。

### Cache Password in Driver Memory 在驱动程序内存中缓存密码

This option can be set in the password entry dialog so that it will apply  only to that particular mount attempt. It can also be set as default in  the Preferences. For more information, please see the section [*Settings -> Preferences*, subsection *Cache passwords in driver memory*](https://veracrypt.fr/en/Program Menu.html).
可以在密码输入对话框中设置此选项，使其仅应用于特定的装载尝试。它也可以在首选项中设置为默认值。欲了解更多信息，请参阅 [*设置->首选项*，子部分*在驱动程序内存中缓存密码*](https://veracrypt.fr/en/Program Menu.html)。

### Mount Options 装载选项

Mount options affect the parameters of the volume being mounted. The *Mount Options* dialog can be opened by clicking on the *Mount Options* button in the password entry dialog. When a correct password is cached, volumes are automatically mounted after you click *Mount*. If you need to change mount options for a volume being mounted using a cached password, hold down the *Control* (*Ctrl*) key while clicking *Mount* or a favorite volume in the *Favorites* menu*,* or select *Mount with Options* from the  *Volumes* menu.
装载选项会影响正在装载的卷的参数。可以通过单击 密码输入对话框中*的“装载选项”*按钮。当缓存了正确的密码时，单击 *靴式*.如果需要更改使用缓存密码装载的卷的装载选项，请按住 *Control*（*Ctrl*）键，同时单击 *“收藏夹*”菜单*，*或从“*选项*”菜单中选择*“使用选项装载”*。

 Default mount options can be configured in the main program preferences (*Settings -> Preferences).*
可以在主程序首选项（*设置->首选项）中配置默认装载选项。*

#### Mount volume as read-only 将卷装载为只读

When checked, it will not be possible to write any data to the mounted volume.
选中此选项后，将无法将任何数据写入已装入的卷。

#### Mount volume as removable medium 将卷装载为可移动介质

See section [ *Volume Mounted as Removable Medium*](https://veracrypt.fr/en/Removable Medium Volume.html).
请参见“[*卷安装为介质”一*](https://veracrypt.fr/en/Removable Medium Volume.html)节。

#### Use backup header embedded in volume if available 如果可用，使用嵌入卷中的备份标头

All volumes created by VeraCrypt contain an embedded backup header (located at the end of the volume). If you check this option, VeraCrypt will  attempt to mount the volume using the embedded backup header. Note that  if the volume header is damaged, you do not have to use this option. Instead, you can repair the header by  selecting  *Tools* > *Restore Volume Header*.
VeraCrypt创建的所有加密卷都包含一个内嵌的备份头（位于卷的末尾）。如果您选中此选项，VeraCrypt将尝试使用嵌入的备份标头挂载卷。请注意，如果卷头损坏，则不必使用此选项。相反，您可以通过选择*工具*>*恢复卷头来*修复标题。

#### Mount partition using system encryption without pre-boot authentication 使用系统加密挂载分区，无需预引导身份验证

Check this option, if you need to mount a partition that is within the key  scope of system encryption without pre-boot authentication. For example, if you need to mount a partition located on the encrypted system drive  of another operating system that is not running. This can be useful e.g. when you need to back up or repair an operating system encrypted by VeraCrypt (from within another  operating system). Note that this option can be enabled also when using  the ‘*Auto-Mount Devices*’ or ‘*Auto-Mount All Device-Hosted Volumes*’ functions.
如果您需要挂载系统加密密钥范围内的分区而无需预引导身份验证，请选中此选项。例如，如果您需要挂载位于另一个未运行的操作系统的加密系统驱动器上的分区。例如，当您需要备份或修复由VeraCrypt加密的操作系统（从另一个操作系统）时，这可能很有用。请注意，在使用“*自动装载设备*”或“*自动装载所有设备托管磁盘*”功能时，也可以启用此选项。

#### Hidden Volume Protection 隐藏卷保护

Please see the section [ *Protection of Hidden Volumes Against Damage*](https://veracrypt.fr/en/Protection of Hidden Volumes.html).
请参阅“[*保护隐藏物品免受损坏”*](https://veracrypt.fr/en/Protection of Hidden Volumes.html)一节。

# Normal Dismount vs Force Dismount 正常拆卸与强制拆卸

Understanding the distinction between "Normal Dismount" and "Force Dismount"  operation is important due to the potential impact on user data.
了解“正常卸载”和“强制卸载”操作之间的区别非常重要，因为这可能会对用户数据产生影响。

## Normal Dismount Process 正常拆卸过程

During a normal dismount process, VeraCrypt performs the following steps:
在正常的加密过程中，VeraCrypt会执行以下步骤：

1. Requests the Windows operating system to lock the volume, prohibiting further I/O operations.
   请求Windows操作系统锁定卷，禁止进一步的I/O操作。
2. Requests Windows to gracefully eject the volume from the system. This step is  analogous to user-initiated device ejection via the system tray.
   请求Windows从系统中正常弹出卷。此步骤类似于用户通过系统托盘启动的器械弹出。
3. Instructs the Windows Mount Manager to unmount the volume.
   指示Windows装载管理器卸载卷。
4. Deletes the link between the drive letter and the volume's virtual device.
   断开驱动器号和卷的虚拟设备之间的链接。
5. Deletes the volume's virtual device, which includes erasing the encryption keys from RAM.
   重新配置卷的虚拟设备，包括从RAM中擦除加密密钥。

In this flow, steps 1 and 2 may fail if there are open files on the  volume. Notably, even if all user applications accessing files on the  volume are closed, Windows might still keep the files open until the I/O cache is completely flushed.
在此流程中，如果卷上有打开的文件，则步骤1和2可能会失败。值得注意的是，即使所有访问卷上文件的用户应用程序都已关闭，Windows仍可能保持文件打开，直到I/O缓存完全刷新。

## Force Dismount Process 强制拆卸过程

The Force Dismount process is distinct but largely similar to the Normal  Dismount. It essentially follows the same steps but disregards any  failures that might occur during steps 1 and 2, and carries on with the  rest of the procedure. However, if there are files open by the user or  if the volume I/O cache has not yet been flushed, this could result in  potential data loss. This situation parallels forcibly removing a USB  device from your computer while Windows is still indicating its active  usage.
强制卸载过程是不同的，但在很大程度上类似于正常卸载。它基本上遵循相同的步骤，但忽略在步骤1和2期间可能发生的任何故障，并继续执行该过程的其余部分。但是，如果用户打开了文件，或者卷I/O缓存尚未刷新，则可能会导致潜在的数据丢失。这种情况类似于强制从计算机中删除USB设备，而Windows仍然指示其活动使用。

Provided all applications using files on the mounted volume have been  successfully closed and the I/O cache is fully flushed, neither data  loss nor data/filesystem corruption should occur when executing a 'force dismount'. As in a normal dismount, the encryption keys are erased from RAM upon successful completion of a 'Force Dismount'.
如果使用装载卷上文件的所有应用程序都已成功关闭，并且I/O缓存已完全刷新，则在执行“强制卸载”时不会发生数据丢失或数据/文件系统损坏。与正常的卸载一样，在成功完成“强制卸载”后，加密密钥将从RAM中删除。

## How to Trigger Force Dismount 如何吸引男人

There are three approaches to trigger a force dismount in VeraCrypt:
在VeraCrypt中有三种方法可以触发强制加密：

1. Through the popup window that appears if a normal dismount attempt is unsuccessful.
   通过弹出窗口显示，如果一个正常的尝试是不成功的。
2. Via Preferences, by checking the "force auto-dismount" option in the "Auto-Dismount" section.
   通过首选项，通过选中“自动卸载”部分中的“强制自动卸载”选项。
3. Using the command line, by incorporating the /force or /f switch along with the /d or /dismount switch.
   使用命令行，将/force或/f开关沿着与/d或/f开关合并。

In order to avoid inadvertent data loss or corruption, always ensure to  follow suitable precautions when dismounting a VeraCrypt volume. This  includes
为了避免无意中的数据丢失或损坏，在加密VeraCrypt加密卷时，请始终确保遵循适当的预防措施。这包括

1. Ensuring all files on the volume are closed before initiating a dismount.
   确保在启动卷恢复之前关闭卷上的所有文件。
2. Allowing some time after closing all files to ensure Windows has completely flushed the I/O cache.
   在关闭所有文件后留出一段时间，以确保Windows已完全刷新I/O缓存。
3. Take note that some antivirus software may keep file handles open on the  volume after performing a scan, hindering a successful Normal Dismount.  If you experience this issue, you might consider excluding the VeraCrypt volume from your antivirus scans. Alternatively, consult with your  antivirus software provider to understand how their product interacts  with VeraCrypt volumes and how to ensure it doesn't retain open file  handles.
   请注意，某些防病毒软件可能会在执行扫描后保持卷上的文件句柄打开，从而阻碍正常卸载成功。如果您遇到此问题，您可以考虑从防病毒扫描中排除VeraCrypt加密卷。或者，咨询您的防病毒软件提供商，了解他们的产品如何与VeraCrypt加密卷交互，以及如何确保它不会保留打开的文件句柄。

[档](https://veracrypt.fr/en/Documentation.html) ![>>](https://veracrypt.fr/en/arrow_right.gif) [避免使用第三方文件扩展名](https://veracrypt.fr/en/Avoid Third-Party File Extensions.html)

# Understanding the Risks of Using Third-Party File Extensions with VeraCrypt 了解在VeraCrypt中使用第三方文件扩展名的风险

While VeraCrypt provides robust encryption capabilities to secure your data,  using third-party file extensions for File Containers or Keyfiles could  risk making the encrypted data inaccessible.
虽然VeraCrypt提供强大的加密功能来保护您的数据，但使用第三方文件扩展名的文件容器或密钥文件可能会导致加密数据无法访问。
   This guide provides an in-depth explanation of the associated risks,  and it outlines recommendations for best practices to mitigate these  risks.
本指南深入解释了相关风险，并概述了减轻这些风险的最佳做法建议。

## Risks Associated with File Containers 与文件容器相关的风险

Using a third-party file extension for File Containers exposes you to several risks:
为File Containers使用第三方文件扩展名会使您面临以下几种风险：

- Overwritten Metadata: Third-party applications may update their metadata, which  could overwrite crucial parts of the File Container.
  覆盖的元数据：第三方应用程序可能会更新其元数据，这可能会覆盖文件容器的关键部分。
- Unintentional Changes: Accidentally launching a File Container with a third-party  application could modify its metadata without your consent.
  意外更改：意外启动带有第三方应用程序的文件容器可能会在未经您同意的情况下修改其元数据。
- Container Corruption: These actions could render the container unreadable or unusable.
  容器损坏：这些操作可能会导致容器不可读或不可用。
- Data Loss: The data within the container might be permanently lost if the container becomes corrupted.
  数据丢失：如果容器损坏，容器中的数据可能会永久丢失。

## Risks Associated with Keyfiles 与密钥文件相关的风险

Similar risks are associated with Keyfiles:
类似的风险与密钥文件相关：

- Keyfile Corruption: Inadvertently modifying a Keyfile with a third-party application can make it unusable for decryption.
  密钥文件损坏：无意中使用第三方应用程序修改密钥文件可能会使其无法用于解密。
- Overwritten Data: Third-party applications may overwrite the portion of the Keyfile that VeraCrypt uses for decryption.
  覆盖数据：第三方应用程序可能会覆盖VeraCrypt用于解密的部分密钥文件。
- Unintentional Changes: Accidental changes can make it impossible to mount the volume  unless you have an unaltered backup of the Keyfile.
  意外更改：意外更改可能导致无法挂载卷，除非您有未更改的密钥文件备份。

## Examples of Extensions to Avoid 应避免的扩展示例

Avoid using the following types of third-party file extensions:
避免使用以下类型的第三方文件扩展名：

- Media Files: Picture, audio, and video files are subject to metadata changes by their respective software.
  媒体文件：图片、音频和视频文件会受到其各自软件的元数据更改。
- Archive Files: Zip files can be easily modified, which could disrupt the encrypted volume.
  归档文件：Zip文件可以很容易地修改，这可能会破坏加密卷。
- Executable Files: Software updates can modify these files, making them unreliable as File Containers or Keyfiles.
  可执行文件：软件更新可能会修改这些文件，使其作为文件容器或密钥文件不可靠。
- Document Files: Office and PDF files can be automatically updated by productivity software, making them risky to use.
  文档文件：Office和PDF文件可以通过生产力软件自动更新，这使得它们的使用具有风险。

## Recommendations 建议

For secure usage, consider the following best practices:
为了安全使用，请考虑以下最佳做法：

- Use neutral file extensions for File Containers and Keyfiles to minimize the risk of automatic file association.
  为文件容器和密钥文件使用中性文件扩展名，以最大限度地降低自动文件关联的风险。
- Keep secure backups of your File Containers and Keyfiles in locations isolated from network access.
  将文件容器和密钥文件的安全备份保存在与网络访问隔离的位置。
- Disable auto-open settings for the specific file extensions you use for VeraCrypt File Containers and Keyfiles.
  禁用用于VeraCrypt文件容器和密钥文件的特定文件扩展名的自动打开设置。
- Always double-check file associations and be cautious when using a new device or third-party application.
  始终仔细检查文件关联，并在使用新设备或第三方应用程序时保持谨慎。

# Parallelization 并行化

When your computer has a multi-core processor (or multiple processors),  VeraCrypt uses all of the cores (or processors) in parallel for  encryption and decryption. For example, when VeraCrypt is to decrypt a  chunk of data, it first splits the chunk into several smaller pieces. The number of the pieces is equal to the number of the  cores (or processors). Then, all of the pieces are decrypted in parallel (piece 1 is decrypted by thread 1, piece 2 is decrypted by thread 2,  etc). The same method is used for encryption.
当您的计算机具有多核处理器（或多个处理器）时，VeraCrypt会并行使用所有内核（或处理器）进行加密和解密。例如，当VeraCrypt要解密一个数据块时，它首先会将该数据块分割成几个较小的块。块的数量等于核心（或处理器）的数量。然后，并行地解密所有片段（片段1由线程1解密，片段2由线程2解密，等等）。同样的方法也用于加密。

So if your computer has, for example, a quad-core processor, then  encryption and decryption are four times faster than on a single-core  processor with equivalent specifications (likewise, they are twice  faster on dual-core processors, etc).
因此，如果您的计算机具有例如四核处理器，则加密和解密的速度比具有相同规格的单核处理器快四倍（同样，它们在双核处理器上的速度要快两倍）。

Increase in encryption/decryption speed is directly proportional to the number of cores and/or processors.
加密/解密速度的增加与核和/或处理器的数量成正比。

Note: Processors with the Hyper-Threading technology provide multiple  logical cores per one physical core (or multiple logical processors per  one physical processor). When Hyper Threading is enabled in the computer firmware (e.g. BIOS) settings, VeraCrypt creates one thread for each logical core/processor. For example, on a 6-core  processor that provides two logical cores per one physical core,  VeraCrypt uses 12 threads.
注意事项：采用超线程技术的处理器为每个物理内核提供多个逻辑内核（或为每个物理处理器提供多个逻辑处理器）。当在计算机固件（例如BIOS）设置中启用超线程时，VeraCrypt会为每个逻辑内核/处理器创建一个线程。例如，在每个物理内核提供两个逻辑内核的6核处理器上，VeraCrypt使用12个线程。


 When your computer has a multi-core processor/CPU (or multiple processors/CPUs), [ header key derivation](https://veracrypt.fr/en/Header Key Derivation.html) is parallelized too. As a result, mounting of a volume is several times faster on a multi-core processor (or  multi-processor computer) than on a single-core processor (or a  single-processor computer) with equivalent specifications.
当您的计算机具有多核处理器/CPU（或多个处理器/CPU）时，[头密钥派生](https://veracrypt.fr/en/Header Key Derivation.html)也是并行的。因此，在多核处理器（或多处理器计算机）上挂载卷的速度要比在具有同等规格的单核处理器（或单处理器计算机）上快几倍。

# Pipelining 流水线

When encrypting or decrypting data, VeraCrypt uses so-called pipelining  (asynchronous processing). While an application is loading a portion of a file from a VeraCrypt-encrypted volume/drive, VeraCrypt is  automatically decrypting it (in RAM). Thanks to pipelining, the application does not have wait for any portion of the file to be  decrypted and it can start loading other portions of the file right  away. The same applies to encryption when writing data to an encrypted  volume/drive.
在加密或解密数据时，VeraCrypt使用所谓的流水线（异步处理）。当应用程序从VeraCrypt加密的卷/驱动器加载文件的一部分时，VeraCrypt会自动解密（在RAM中）。由于流水线，应用程序不必等待文件的任何部分被解密，它可以立即开始加载文件的其他部分。这同样适用于将数据写入加密卷/驱动器时的加密。

Pipelining allows data to be read from and written to an encrypted drive as fast as if the drive was not encrypted (the same applies to  file-hosted and partition-hosted VeraCrypt [ volumes](https://veracrypt.fr/en/VeraCrypt Volume.html)).*
流水线允许从加密驱动器读取数据和向加密驱动器写入数据的速度与驱动器未加密时一样快（这同样适用于文件托管和分区托管的VeraCrypt [卷](https://veracrypt.fr/en/VeraCrypt Volume.html)）。*

Note: Pipelining is implemented only in the Windows versions of VeraCrypt.
注意：流水线只在Windows版本的VeraCrypt中实现。

 

------

\* Some solid-state drives compress data internally, which appears to  increase the actual read/write speed when the data is compressible (for  example, text files). However, encrypted data cannot be compressed (as it appears to consist solely of random "noise"  without any compressible patterns). This may have various implications.  For example, benchmarking software that reads or writes compressible  data (such as sequences of zeroes) will report lower speeds on encrypted volumes than on unencrypted volumes (to avoid this, use benchmarking software that reads/writes random or other kinds of  uncompressible data)
\*  某些固态驱动器在内部压缩数据，当数据可压缩时（例如文本文件），这似乎会提高实际读/写速度。然而，加密的数据不能被压缩（因为它看起来仅仅由随机的“噪声”组成，没有任何可压缩的模式）。这可能会产生各种影响。例如，读取或写入可压缩数据（如零序列）的基准测试软件将报告加密卷上的速度低于未加密卷上的速度（为避免这种情况，请使用读取/写入随机或其他类型的不可压缩数据的基准测试软件）.

# Hardware Acceleration 硬件加速

Some processors (CPUs) support hardware-accelerated [ AES](https://veracrypt.fr/en/AES.html) encryption,* which is typically 4-8 times faster than encryption performed by the purely software implementation on the same processors.
某些处理器（CPU）支持硬件加速的[AES](https://veracrypt.fr/en/AES.html)加密，* 通常比相同处理器上纯软件实现执行的加密快4-8倍。

By default, VeraCrypt uses hardware-accelerated AES on computers that  have a processor where the Intel AES-NI instructions are available.  Specifically, VeraCrypt uses the AES-NI instructions that perform  so-called AES rounds (i.e. the main portions of the AES algorithm).** VeraCrypt does not use any of the AES-NI instructions  that perform key generation.
默认情况下，VeraCrypt在具有英特尔AES-NI指令可用的处理器的计算机上使用硬件加速AES。具体来说，VeraCrypt使用AES-NI指令来执行所谓的AES轮（即AES算法的主要部分）。** VeraCrypt不使用任何AES-NI指令来执行密钥生成。

Note: By default, VeraCrypt uses hardware-accelerated AES also when an  encrypted Windows system is booting or resuming from hibernation  (provided that the processor supports the Intel AES-NI instructions).
注意事项：默认情况下，当加密的Windows系统启动或从休眠状态恢复时，VeraCrypt也使用硬件加速的AES（前提是处理器支持英特尔AES-NI指令）。

To find out whether VeraCrypt can use hardware-accelerated AES on your computer, select *Settings* > *Performance/**Driver Configuration* and check the field labeled '*Processor (CPU) in this computer supports hardware acceleration for AES*'.
要了解VeraCrypt是否可以在您的计算机上使用硬件加速AES，请选择 *设置*>*性能/**驱动程序配置*并检查标记为“*此计算机中的处理器（CPU）支持AES的硬件加速*”的字段。

To find out whether a processor you want to purchase supports the Intel  AES-NI instructions (also called "AES New Instructions"), which  VeraCrypt uses for hardware-accelerated AES, please check the  documentation for the processor or contact the vendor/manufacturer. Alternatively, click [ here](http://ark.intel.com/search/advanced/?AESTech=true) to view an official list of Intel processors that support the  AES-NI instructions. However, note that some Intel processors, which the Intel website lists as AES-NI-supporting, actually support the AES-NI  instructions only with a Processor Configuration update (for example, i7-2630/2635QM, i7-2670/2675QM, i5-2430/2435M,  i5-2410/2415M). In such cases, you should contact the manufacturer of  the motherboard/computer for a BIOS update that includes the latest  Processor Configuration update for the processor.
要了解您想要购买的处理器是否支持VeraCrypt用于硬件加速AES的Intel AES-NI指令（也称为“AES新指令”），请查看处理器的文档或联系供应商/制造商。或者，单击[此处](http://ark.intel.com/search/advanced/?AESTech=true)查看支持AES-NI指令的英特尔处理器的官方列表。但是，请注意，英特尔网站列出的某些支持AES-NI的英特尔处理器实际上仅通过处理器配置更新支持AES-NI指令（例如，i7-2630/2635 QM，i7-2670/2675 QM，i5-2430/2435 M，i5-2410/2415  M）。在这种情况下，您应该联系主板/计算机的制造商，以获取包含处理器最新处理器配置更新的BIOS更新。

If you want to disable hardware acceleration of AES (e.g. because you  want VeraCrypt to use only a fully open-source implementation of AES),  you can do so by selecting *Settings* > *Performance and Driver Options* and disabling the option '*Accelerate AES encryption/decryption by using the AES instructions of the processor*'. Note that when this setting is changed, the operating system needs to be restarted to ensure that all VeraCrypt components  internally perform the requested change of mode. Also note that when you create a VeraCrypt Rescue Disk, the state of this option is written to  the Rescue Disk and used whenever you boot from it (affecting the pre-boot and initial boot phase). To create a  new VeraCrypt Rescue Disk, select *System* > *Create Rescue Disk*.
如果您想禁用AES的硬件加速（例如，因为您想让VeraCrypt只使用完全开源的AES实现），您可以通过选择*设置*> *性能和驱动程序选项*，并禁用选项“*通过使用处理器的AES指令加速AES加密/解密*”。请注意，当此设置更改时， 需要重启系统以确保所有VeraCrypt组件内部执行请求的模式更改。另外请注意，当您创建VeraCrypt救援盘时，此选项的状态将写入救援盘，并在您靴子启动时使用 （影响预靴子和初始靴子阶段）。要创建新的VeraCrypt救援盘，选择 *系统*>*创建修复盘*。

 

------

\* In this chapter, the word 'encryption' also refers to decryption.
\* 在本章中，“加密”一词也指解密。
 ** Those instructions are *AESENC*, *AESENCLAST*, *AESDEC*, and *AESDECLAST* and they perform the following AES transformations: *ShiftRows*, *SubBytes*, *MixColumns*, *InvShiftRows*, *InvSubBytes*, *InvMixColumns*, and *AddRoundKey* (for more details about these transformations, see [3])
** 这些指示是 *AESENC*，*AESENCLAST*， *AESDEC*和*AESDECLAST*，它们执行以下AES转换： *移**形换位*， *MixColumns*、*InvShiftList*、 *InvSubversion*、*InvMixColumns*和 *AddRoundKey*（有关这些转换的更多细节，请参见[3]）.

# Hot Keys 热键


 To set system-wide VeraCrypt hot keys, click Settings -> Hot Keys.  Note that hot keys work only when VeraCrypt or the VeraCrypt Background  Task is running.
要设置VeraCrypt系统范围的热键，请点击设置->热键。请注意，热键仅在VeraCrypt或VeraCrypt后台任务运行时才有效。

# Keyfiles 密钥文件


 Keyfile is a file whose content is combined with a password (for  information on the method used to combine a keyfile with password, see  the section [ Keyfiles](https://veracrypt.fr/en/Keyfiles.html) in the chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html)). Until the correct keyfile is provided, no volume that uses the keyfile can be mounted.
密钥文件是其内容与密码相结合的文件（有关将密钥文件与密码联合收割机相结合的方法的信息，请参见 [技术细节](https://veracrypt.fr/en/Technical Details.html)一章中[的密钥文件](https://veracrypt.fr/en/Keyfiles.html)）。在提供正确的密钥文件之前，无法装入使用该密钥文件的卷。

You do not have to use keyfiles. However, using keyfiles has some advantages:
您不必使用密钥文件。但是，使用密钥文件有一些优点：

- May improve protection against brute force attacks (significant particularly if the volume password is not very strong). 
  可以提高对蛮力攻击的保护（特别是在卷密码不是很强的情况下）。
- Allows the use of security tokens and smart cards (see below). 
  允许使用安全令牌和智能卡（见下文）。
- Allows multiple users to mount a single volume using different user  passwords or PINs. Just give each user a security token or smart card  containing the same VeraCrypt keyfile and let them choose their personal password or PIN that will protect their security token or smart card. 
  允许多个用户使用不同的用户密码或PIN装载单个卷。只需给每个用户一个包含相同VeraCrypt密钥文件的安全令牌或智能卡，让他们选择个人密码或PIN来保护他们的安全令牌或智能卡。
- Allows managing multi-user *shared* access (all keyfile holders must present their keyfiles before a volume can be mounted). 
  允许管理多用户共享访问（所有密钥文件持有者必须在挂载卷之前提供其密钥文件）。



 Note that VeraCrypt never modifies the keyfile contents. You can select  more than one keyfile; the order does not matter. You can also let  VeraCrypt generate a file with random content and use it as a keyfile.  To do so, select *Tools > Keyfile Generator*.
注意VeraCrypt不会修改密钥文件的内容。您可以选择多个密钥文件;顺序无关紧要。您也可以让VeraCrypt生成一个包含随机内容的文件，并将其用作密钥文件。为此，请选择 *工具>密钥文件生成器。*

Note: Keyfiles are currently not supported for system encryption.
注意：系统加密目前不支持密钥文件。

WARNING: If you lose a keyfile or if any bit of its first 1024 kilobytes changes, it will be impossible to mount volumes that use the keyfile!
如果你丢失了一个密钥文件，或者它的前1024个字节中的任何一个发生了变化，那么就不可能挂载使用该密钥文件的卷!

***WARNING: If password caching is enabled, the password cache also contains the  processed contents of keyfiles used to successfully mount a volume. Then it is possible to remount the volume even if the keyfile is not available/accessible.** To prevent this, click '*Wipe Cache*' or disable password caching (for more information, please see the subsection* 'Settings -> Preferences'*, item* 'Cache passwords in driver memory' *in the section* [Program Menu](https://veracrypt.fr/en/Program Menu.html)).
***如果启用了密码缓存，则密码缓存还包含用于成功挂载卷的密钥文件的处理内容。然后，即使密钥文件不可用/不可访问，也可以重新装入卷。**要防止这种情况，请单击“*擦除缓存*”或禁用密码缓存（有关详细信息，请参阅"程序菜单“部分中的*”设置->首选项“*小节，*”在驱动程序内存中缓存密码“[项](https://veracrypt.fr/en/Program Menu.html)）。

See also the section [ Choosing Passwords and Keyfiles](https://veracrypt.fr/en/Choosing Passwords and Keyfiles.html) in the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html).
另请参阅[安全要求和注意事项](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章中的[选择密码和密钥文件一](https://veracrypt.fr/en/Choosing Passwords and Keyfiles.html)节。

 

### Keyfiles Dialog Window 密钥文件对话框窗口

If you want to use keyfiles (i.e. "apply" them) when creating or mounting volumes, or changing passwords, look for the '*Use keyfiles*' option and the *Keyfiles* button below a password input field.
如果您想在创建或挂载卷或更改密码时使用密钥文件（即“应用”它们），请查找“*使用密钥文件*”选项和 密码输入字段下面的*密钥文件*按钮。

![VeraCrypt Keyfiles dialog](https://veracrypt.fr/en/Keyfiles in VeraCrypt_Image_040.gif)

These control elements appear in various dialog windows and always have the same functions. Check the *Use keyfiles* option and click  *Keyfiles.* The keyfile dialog window should appear where you can specify keyfiles (to do so, click *Add File*s or *Add Token Files*) *or* keyfile search paths (click *Add Path*).
这些控制元素出现在各种对话框窗口中，并且始终具有相同的功能。检查 *使用密钥文件*选项并单击*密钥文件。*应该会出现keyfile对话框窗口，您可以在其中指定keyfiles（为此，请单击 *添加*文件或*添加令牌文件*）*或*密钥文件搜索路径（单击 *添加路径*）。

 

### Security Tokens and Smart Cards 安全令牌和智能卡

VeraCrypt can directly use keyfiles stored on a security token or smart  card that complies with the PKCS #11 (2.0 or later) standard [23] and  that allows the user to store a file (data object) on the token/card. To use such files as VeraCrypt keyfiles, click *Add Token Files* (in the keyfile dialog window).
VeraCrypt可以直接使用存储在符合PKCS #11（2.0或更高版本）标准的安全令牌或智能卡上的密钥文件，并允许用户在令牌/卡上存储文件（数据对象）。要使用这些文件作为VeraCrypt密钥文件，点击*添加令牌文件*（在密钥文件对话框窗口中）。

Access to a keyfile stored on a security token or smart card is  typically protected by PIN codes, which can be entered either using a  hardware PIN pad or via the VeraCrypt GUI. It can also be protected by  other means, such as fingerprint readers.
对存储在安全令牌或智能卡上的密钥文件的访问通常受到PIN代码的保护，可以使用硬件PIN键盘或通过VeraCrypt GUI输入PIN代码。它也可以通过其他方式保护，例如指纹识别器。

In order to allow VeraCrypt to access a security token or smart card,  you need to install a PKCS #11 (2.0 or later) software library for the  token or smart card first. Such a library may be supplied with the  device or it may be available for download from the website of the vendor or other third parties.
为了允许VeraCrypt访问安全令牌或智能卡，您需要首先为令牌或智能卡安装PKCS #11（2.0或更高版本）软件库。这种库可以与设备一起提供，或者可以从供应商或其他第三方的网站下载。

If your security token or smart card does not contain any file (data  object) that you could use as a VeraCrypt keyfile, you can use VeraCrypt to import any file to the token or smart card (if it is supported by  the device). To do so, follow these steps:
如果您的安全令牌或智能卡不包含任何可用作VeraCrypt密钥文件的文件（数据对象），您可以使用VeraCrypt将任何文件导入令牌或智能卡（如果设备支持）。为此，请按照下列步骤操作：

1. In the keyfile dialog window, click *Add Token Files*. 
   在密钥文件对话框窗口中，单击*添加令牌文件*。
2. If the token or smart card is protected by a PIN, password, or other  means (such as a fingerprint reader), authenticate yourself (for  example, by entering the PIN using a hardware PIN pad). 
   如果令牌或智能卡受PIN、密码或其他方式（如指纹读取器）保护，请进行身份验证（例如，通过使用硬件PIN键盘输入PIN）。
3. The 'Security Token Keyfile' dialog window should appear. In it, click  *Import Keyfile to Token* and then select the file you want to import to the token or smart card. 
   应出现“Security Token Keyfile”对话框窗口。在其中，单击*将密钥文件导入令牌*，然后选择要导入到令牌或智能卡的文件。

Note that you can import for example 512-bit keyfiles with random content generated by VeraCrypt (see *Tools > Keyfile Generator* below).
请注意，您可以导入例如VeraCrypt生成的带有随机内容的512位密钥文件（请参见 下面的*工具>密钥文件生成器*）。

To close all opened security token sessions, either select  *Tools* > *Close All Security Token Sessions* or define and use a hotkey combination (*Settings* > *Hot Keys > Close All Security Token Sessions*).
要关闭所有打开的安全令牌会话，请选择*工具*>*关闭所有安全令牌会话，*或定义并使用热键组合（*设置*> *热键>关闭所有安全令牌会话*）。

 

### EMV Smart Cards EMV智能卡

Windows and Linux versions of VeraCrypt can use directly as keyfiles  data extracted from EMV compliant smart cards, supporting Visa,  Mastecard or Maestro applications. As with PKCS-11 compliant smart  cards, to use such data as VeraCrypt keyfiles,  click *Add Token Files* (in the keyfile dialog window). The last four digits of the card's  Primary Account Number will be displayed, allowing the selection of the  card as a keyfile source. 
Windows和Linux版本的VeraCrypt可以直接使用从EMV兼容智能卡中提取的数据作为密钥文件，支持Visa，Mastecard或Maestro应用程序。与PKCS-11兼容的智能卡一样，要使用VeraCrypt密钥文件等数据，  单击*添加令牌文件*（在密钥文件对话框窗口中）。将显示卡的主帐号的最后四位数字，允许选择卡作为密钥文件源。

The data extracted and concatenated into a single keyfile are as follow : ICC Public Key Certificate, Issuer Public Key Certificate and Card  Production Life  Cycle (CPLC) data. They are respectively identified by the tags '9F46',  '90' and '9F7F' in the card's data management system. These two  certificates are specific to an application deployed on the EMV card and used for the Dynamic Data Authentication of the card  during banking transactions. CPLC data are specific to the card and not  to any of its applications. They contain information on the production  process of the smart card. Therefore both certificates and data are  unique and static on any EMV compliant smart card.
提取并连接到单个密钥文件中的数据如下：ICC公钥证书、发行方公钥证书和卡生产生命周期（CPLC）数据。它们在卡的数据管理系统中分别由标签“9F46”、“90”和“9F7F”标识。这两个证书特定于部署在EMV卡上的应用程序，并在银行交易期间用于卡的动态数据身份验证。CPLC数据特定于卡，而不是其任何应用程序。它们包含有关智能卡生产过程的信息。因此，证书和数据在任何符合EMV的智能卡上都是唯一的和静态的。

According to the ISO/IEC 7816 standard on which the EMV standard is  based, communication with an EMV smart card is done through structured  commands called APDUs, allowing to extract the data from the smart card. These data are encoded in the BER-TLV format,  defined by the ASN.1 standard, and therefore need to be parsed before  being concatenated into a keyfile. No PIN is required to access and  retrieve data from the card. To cope with the diversity of smart cards  readers on the market, librairies compliant with the Microsoft Personal  Computer/Smart Card communication standard are used. The Winscard  library is used. Natively available on Windows in System32, it then  doesn't require any installation on this operating system. However, the  libpcsclite1 package has to be installed on Linux.
根据EMV标准所基于的ISO/IEC  7816标准，与EMV智能卡的通信是通过称为APDU的结构化命令完成的，从而允许从智能卡中提取数据。这些数据以ASN.1标准定义的BER-TLV格式编码，因此在连接到密钥文件之前需要进行解析。无需PIN即可访问和检索卡中的数据。为了科普市场上智能卡阅读器的多样性，使用了符合微软个人计算机/智能卡通信标准的库。使用Winscard库。在System32中的Windows上本地可用，因此不需要在此操作系统上进行任何安装。但是，libpcsclite 1包必须安装在Linux上。

Since the card is read-only, it is not possible to import or delete  data. However, data used as keyfiles can be exported locally in any  binary file. During the entire cryptographic process of mounting or  creating a volume, the certificates and CPLC data are never stored  anywhere  other than in the user's machine RAM. Once the process is complete,  these RAM memory areas are rigorously erased.
由于该卡是只读的，因此无法导入或删除数据。但是，用作密钥文件的数据可以在任何二进制文件中本地导出。在安装或创建卷的整个加密过程中，证书和CPLC数据永远不会存储在用户计算机RAM之外的任何地方。一旦这个过程完成，这些RAM内存区域被严格擦除。

It important to note that this feature is optional and disabled by default. It can be enabled in the *Security Token Preferences* parameters by checking the box provided.
重要的是要注意，此功能是可选的，默认情况下禁用。可以通过选中提供的框在*Security Token Preferences*参数中启用它。

 

### Keyfile Search Path 密钥文件搜索路径

By adding a folder in the keyfile dialog window (click  *Add Path*), you specify a *keyfile search path*. All files found in the keyfile search path* will be used as keyfiles except files that have the Hidden file attribute set.
通过在密钥文件对话框窗口中添加文件夹（单击*Add Path*），可以指定*密钥文件搜索路径*。在keyfile搜索路径 * 中找到的所有文件都将用作keyfile，但设置了Hidden file属性的文件除外。

***Important: Note that folders (and files they contain) and hidden files found in a keyfile search path are ignored.
重要：请注意，在keyfile搜索路径中找到的文件夹（及其包含的文件）和隐藏文件将被忽略。\***

Keyfile search paths are especially useful if you, for example, store  keyfiles on a USB memory stick that you carry with you. You can set the  drive letter of the USB memory stick as a default keyfile search path.  To do so, select *Settings* -> *Default Keyfiles*. Then click 
例如，如果您将密钥文件存储在随身携带的USB记忆棒上，则密钥文件搜索路径特别有用。您可以将USB记忆棒的驱动器号设置为默认密钥文件搜索路径。 *设置*->*默认密钥文件*。然后单击
 *Add Path*, browse to the drive letter assigned to the USB memory stick, and click *OK*. Now each time you mount a volume (and if the option *Use keyfiles* is checked in the password dialog window), VeraCrypt will scan the path and use all files that it finds on the USB memory stick as keyfiles.
*添加路径*，浏览到分配给USB记忆棒的驱动器号，然后单击 *好*的.现在，每次装载卷时（如果选项 在密码对话框窗口中选中*“使用密钥文件*”），VeraCrypt将扫描路径并使用在USB记忆棒上找到的所有文件作为密钥文件。

***WARNING: When you add a folder (as opposed to a file) to the list of keyfiles,  only the path is remembered, not the filenames! This means e.g. that if  you create a new file in the folder or if you copy an additional file to the folder, then all volumes that used  keyfiles from the folder will be impossible to mount (until you remove  the newly added file from the folder). 
当你添加一个文件夹（而不是一个文件）到密钥文件列表中时，只会记住路径，而不会记住文件名！这意味着，例如，如果您在文件夹中创建一个新文件，或者如果您将其他文件复制到该文件夹中，则使用该文件夹中的密钥文件的所有卷将无法挂载（直到您从文件夹中删除新添加的文件）。\***

 

### Empty Password & Keyfile 空密码和密钥文件

When a keyfile is used, the password may be empty, so the keyfile may  become the only item necessary to mount the volume (which we do not  recommend). If default keyfiles are set and enabled when mounting a  volume, then before prompting for a password, VeraCrypt first automatically attempts to mount using an empty password plus  default keyfiles (however, this does not apply to the '*Auto-Mount Devices*' function). If you need to set Mount Options (e.g., mount as read-only, protect hidden volume etc.) for a volume being mounted this way, hold down the  *Control* (*Ctrl*) key while clicking  *Mount* (or select *Mount with Options* from the *Volumes* menu). This will open the  *Mount Options* dialog.
当使用密钥文件时，密码可能为空，因此密钥文件可能成为挂载卷所需的唯一项目（我们不建议这样做）。如果在挂载卷时设置并启用了默认密钥文件，那么在提示输入密码之前，VeraCrypt会首先尝试使用空密码和默认密钥文件挂载卷（但是，这不适用于“*自动挂载设备*”功能）。如果需要设置装载选项（例如，挂载为只读，保护隐藏卷等）对于以这种方式装载的卷，请在按住*Ctrl*键的同时单击*装载*（或从 菜单）。这将打开“*装载选项”*对话框。

 

### Quick Selection 快速选择

Keyfiles and keyfile search paths can be quickly selected in the following ways:
可以通过以下方式快速选择密钥文件和密钥文件搜索路径：

- Right-click the *Keyfiles* button in the password entry dialog window and select one of the menu items. 
  右键单击密码输入对话框窗口中的*密钥文件*按钮，然后选择其中一个菜单项。
- Drag the corresponding file/folder icons to the keyfile dialog window or to the password entry dialog. 
  将相应的文件/文件夹图标拖到密钥文件对话框窗口或密码输入对话框。

 

### Volumes -> Add/Remove Keyfiles to/from Volume 目录->将密钥文件添加到卷/从卷中删除密钥文件

This function allows you to re-encrypt a volume header with a header  encryption key derived from any number of keyfiles (with or without a  password), or no keyfiles at all. Thus, a volume which is possible to  mount using only a password can be converted to a volume that require keyfiles (in addition to the password) in order  to be possible to mount. Note that the volume header contains the master encryption key with which the volume is encrypted. Therefore, the data  stored on the volume will *not* be lost after you use this function.
此函数允许您使用从任意数量的密钥文件（带或不带密码）派生的头加密密钥重新加密卷头，或者根本不使用密钥文件。因此，可以将仅使用密码安装的卷转换为 一个需要密钥文件（除了密码）才能挂载的卷。请注意，卷标头包含用于加密卷的主加密密钥。因此，存储在卷上的数据将 使用此功能后*不会*丢失。

This function can also be used to change/set volume keyfiles (i.e., to remove some or all keyfiles, and to apply new ones).
此功能还可用于更改/设置卷密钥文件（即，删除部分或全部密钥文件，并应用新的密钥文件）。

Remark: This function is internally equal to the Password Change function.
备注：此功能在内部等同于密码更改功能。

 When VeraCrypt re-encrypts a volume header, the original volume header  is first overwritten 256 times with random data to prevent adversaries  from using techniques such as magnetic force microscopy or magnetic  force scanning tunneling microscopy [17] to recover the overwritten header (however, see also the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html)).
当VeraCrypt重新加密卷头时，原始卷头首先被随机数据覆盖256次，以防止对手使用磁力显微镜或磁力扫描隧道显微镜等技术进行恢复 覆盖的报头（但是，另请参见[“安全要求和注意事项”](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章）。

 

### Volumes -> Remove All Keyfiles from Volume 删除->从卷中删除所有密钥文件

This function allows you to re-encrypt a volume header with a header  encryption key derived from a password and no keyfiles (so that it can  be mounted using only a password, without any keyfiles). Note that the  volume header contains the master encryption key with which the volume is encrypted. Therefore, the data stored on the  volume will *not* be lost after you use this function.
此函数允许您使用从密码派生的头加密密钥重新加密卷头，而不使用密钥文件（因此可以仅使用密码而不使用任何密钥文件挂载卷头）。请注意，卷标头包含主加密密钥 用它加密卷。因此，存储在卷上的数据将 使用此功能后*不会*丢失。

Remark: This function is internally equal to the Password Change function.
备注：此功能在内部等同于密码更改功能。

 When VeraCrypt re-encrypts a volume header, the original volume header  is first overwritten 256 times with random data to prevent adversaries  from using techniques such as magnetic force microscopy or magnetic  force scanning tunneling microscopy [17] to recover the overwritten header (however, see also the chapter [ Security Requirements and Precautions](https://veracrypt.fr/en/Security Requirements and Precautions.html)).
当VeraCrypt重新加密卷头时，原始卷头首先被随机数据覆盖256次，以防止对手使用磁力显微镜或磁力扫描隧道显微镜等技术进行恢复 覆盖的报头（但是，另请参见[“安全要求和注意事项”](https://veracrypt.fr/en/Security Requirements and Precautions.html)一章）。

 

### Tools > Keyfile Generator 工具>密钥文件生成器

You can use this function to generate a file or more with random  content, which you can use as a keyfile(s) (recommended). This function  uses the VeraCrypt Random Number Generator. Note that, by default, only  one key file is generated and the resulting file size is 64 bytes (i.e., 512 bits), which is also the maximum possible  VeraCrypt password length. It is also possible to generate multiple  files and specify their size (either a fixed value for all of them or  let VeraCrypt choose file sizes randomly). In all cases, the file size must be comprised between 64 bytes and 1048576  bytes (which is equal to 1MB, the maximum number of a key file bytes  processed by VeraCrypt).
您可以使用此函数生成一个或多个具有随机内容的文件，您可以将其用作密钥文件（推荐）。这个函数使用VeraCrypt随机数生成器。请注意，默认情况下，只生成一个密钥文件，生成的文件大小为64字节（即，512  bits），这也是VeraCrypt密码的最大长度。还可以生成多个文件并指定它们的大小（可以为所有文件指定固定值，也可以让VeraCrypt随机选择文件大小）。在所有情况下，文件大小必须介于64字节和1048576字节之间（等于1 MB，VeraCrypt处理的密钥文件的最大字节数）。

### Settings -> Default Keyfiles 设置->默认密钥文件

Use this function to set default keyfiles and/or default keyfile search  paths. This function is particularly useful if you, for example, store  keyfiles on a USB memory stick that you carry with you. You can add its  drive letter to the default keyfile configuration. To do so, click *Add Path*, browse to the drive letter assigned to the USB memory stick, and click *OK*. Now each time you mount a volume (and if  *Use keyfiles* is checked in the password dialog), VeraCrypt will scan the path and use all files that it finds there as keyfiles.
使用此函数设置默认密钥文件和/或默认密钥文件搜索路径。例如，如果您将密钥文件存储在随身携带的USB记忆棒上，则此功能特别有用。您可以将其驱动器号添加到默认的密钥文件配置中。 要执行此操作，请单击*“添加路径”*，浏览至分配给USB记忆棒的驱动器号，然后单击 *好*的.现在每次你挂载一个加密卷时（如果在密码对话框中勾选*了使用密钥文件*），VeraCrypt会扫描路径并使用所有找到的文件作为密钥文件。

 ***WARNING: When you add a folder (as opposed to a file) to your default keyfile  list, only the path is remembered, not the filenames! This means e.g.  that if you create a new file in the folder or if you copy an additional file to the folder, then all volumes that used  keyfiles from the folder will be impossible to mount (until you remove  the newly added file from the folder). 
当你添加一个文件夹（而不是一个文件）到你的默认密钥文件列表中时，只会记住路径，而不会记住文件名！这意味着，例如，如果您在文件夹中创建一个新文件，或者 你复制一个额外的文件到文件夹，那么所有使用该文件夹中的密钥文件的卷将无法挂载（直到你从文件夹中删除新添加的文件）。

\*** *IMPORTANT: Note that when you set default keyfiles and/or default keyfile search  paths, the filenames and paths are saved unencrypted in the file* Default Keyfiles.xml*. For more information, please see the chapter* [VeraCrypt System Files & Application Data](https://veracrypt.fr/en/VeraCrypt System Files.html). 
*重要提示：请注意，当您设置默认密钥文件和/或默认密钥文件搜索路径时，文件名和路径以未加密的方式保存在文件*Default Keyfiles.xml中*。有关更多信息，请参阅*[VeraCrypt系统文件&应用程序数据一章](https://veracrypt.fr/en/VeraCrypt System Files.html)。

*
*

------

\* Found at the time when you are mounting the volume, changing its  password, or performing any other operation that involves re-encryption  of the volume header.
\* 在您装入卷、更改其密码或执行涉及重新加密卷头的任何其他操作时找到。
 ** However, if you use an MP3 file as a keyfile, you must ensure that no program modifies the ID3 tags within the MP3 file (e.g. song title,  name of artist, etc.). Otherwise, it will be impossible to mount volumes that use the keyfile.
** 但是，如果您使用MP3文件作为密钥文件，则必须确保没有程序修改MP3文件中的ID3标记（例如歌曲标题，艺术家姓名等）。否则，将无法挂载使用密钥文件的卷。

# Security Tokens & Smart Cards 安全令牌和智能卡

VeraCrypt supports security (or cryptographic) tokens and smart cards  that can be accessed using the PKCS #11 (2.0 or later) protocol [23].  For more information, please see the section *Security Tokens and Smart Cards* in the chapter [ *Keyfiles*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html).
VeraCrypt支持使用PKCS #11（2.0或更高版本）协议访问的安全（或加密）令牌和智能卡。欲了解更多信息，请参阅 [*密钥文件*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html)一章中的*安全令牌和智能卡*。

Please note that security tokens and smart cards are currently not supported for Pre-Boot authentication of system encryption.
请注意，安全令牌和智能卡目前不支持系统加密的预引导身份验证。

# EMV Smart Cards EMV智能卡

​          Windows and Linux versions of VeraCrypt offer to use EMV compliant          smart cards as a feature. Indeed, the use of PKCS#11 compliant smart          cards is dedicated to users with more or less cybersecurity skills.          However, in some situations, having such a card strongly reduces the          plausible deniability of the user.        
Windows和Linux版本的VeraCrypt支持EMV兼容          智能卡作为一种功能。事实上，使用PKCS#11兼容的智能          cards是专门为具有或多或少网络安全技能的用户提供的。          然而，在某些情况下，拥有这样一张卡会大大减少          用户的合理否认。

​          To overcome this problem, the idea is to allow the use of a type of          smart card owned by anyone: EMV compliant smart cards. According to          the standard of the same name, these cards spread all over the world          are used to carry out banking operations. Using internal data of the          user's EMV card as keyfiles will strengthen the security of his volume          while keeping his denial plausible.        
为了克服这个问题，我们的想法是允许使用一种类型的          任何人拥有的智能卡：符合EMV的智能卡。根据          同名的标准，这些卡遍布世界各地          用于开展银行业务。使用的内部数据          用户的EMV卡作为密钥文件将加强他的卷的安全性          同时保持他的否认合理。

​          For more technical information, please see the section          *EMV Smart Cards* in the chapter          [             *Keyfiles*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html).        
有关更多技术信息，请参阅          *EMV智能卡*一章          [*密钥文件*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html)。

# Portable Mode 便携模式

VeraCrypt can run in so-called portable mode, which means that it does not have  to be installed on the operating system under which it is run. However,  there are two things to keep in mind:
VeraCrypt可以在所谓的便携模式下运行，这意味着它不必安装在运行它的操作系统上。但是，有两件事要记住：

1. You need administrator privileges in order to be able to run VeraCrypt in portable mode (for the reasons, see the chapter

   *Using VeraCrypt Without Administrator Privileges*

   ).

   
   您需要管理员权限才能在便携模式下运行VeraCrypt（原因请参阅 [*在没有管理员权限的情况下使用VeraCrypt*](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html)）。

   Note: No matter what kind of software you use, as regards personal privacy in most cases, it is *not* safe to work with sensitive data under systems where you do not have  administrator privileges, as the administrator can easily capture and  copy your sensitive data, including passwords and keys. 注：无论您使用哪种软件，在大多数情况下， 在您没有管理员权限的系统下使用敏感数据*并不*安全，因为管理员可以轻松捕获和复制您的敏感数据，包括密码和密钥。

2. After examining the registry file, it may be possible to tell that VeraCrypt  was run (and that a VeraCrypt volume was mounted) on a Windows system  even if it had been run in portable mode. 
   检查注册表文件后，即使VeraCrypt是在可移植模式下运行的，也可以判断出VeraCrypt是在Windows系统上运行的（并且VeraCrypt卷被挂载）。

**Note**: If that is a problem, see [ this question](https://veracrypt.fr/en/FAQ.html#notraces) in the FAQ for a possible solution.
**注意**：如果这是一个问题，请参阅FAQ中[的此问题](https://veracrypt.fr/en/FAQ.html#notraces)以获得可能的解决方案。

 There are two ways to run VeraCrypt in portable mode:
有两种方法可以在便携模式下运行VeraCrypt：

1. After you extract files from the VeraCrypt self-extracting package, you can directly run *VeraCrypt.exe*.
   从VeraCrypt自解压包中解压文件后，您可以直接运行 *VeraCrypt.exe*。
   
    Note: To extract files from the VeraCrypt self-extracting package, run it, and then select *Extract* (instead of *Install*) on the second page of the VeraCrypt Setup wizard. 
   注意：要从VeraCrypt自解压包中解压文件，运行它，然后选择 在VeraCrypt安装向导的第二页*进行解压*（而不是*安装*）。
2. You can use the *Traveler Disk Setup* facility to prepare a special traveler disk and launch VeraCrypt from there. 
   您可以使用*旅行盘设置*工具来准备一个特殊的旅行盘，并从那里启动VeraCrypt。

The second option has several advantages, which are described in the following sections in this chapter.
第二种选择有几个优点，本章以下各节将介绍这些优点。

Note: When running in ‘portable’ mode, the VeraCrypt driver is unloaded when  it is no longer needed (e.g., when all instances of the main application and/or of the Volume Creation Wizard are closed and no VeraCrypt  volumes are mounted). However, if you force dismount on a VeraCrypt volume when VeraCrypt runs in  portable mode, or mount a writable NTFS-formatted volume on Windows  Vista or later, the VeraCrypt driver may *not* be unloaded when you exit VeraCrypt (it will be unloaded only when you  shut down or restart the system). This prevents various problems caused  by a bug in Windows (for instance, it would be impossible to start  VeraCrypt again as long as there are applications using the dismounted volume).
注意：在“便携”模式下运行时，VeraCrypt驱动程序在不再需要时会被卸载（例如，当主应用程序和/或加密卷创建向导的所有实例都关闭并且没有挂载VeraCrypt加密卷时）。然而，在这方面， 如果您在VeraCrypt运行在便携模式下时对VeraCrypt卷强制解密，或者在Windows Vista或更高版本上挂载可写NTFS格式的卷，VeraCrypt驱动程序可能 退出VeraCrypt时*不会*被卸载（只有在关闭或重启系统时才会被卸载）。这可以防止Windows中的漏洞导致的各种问题（例如，只要有应用程序使用加密卷，就不可能再次启动VeraCrypt）。

### Tools -> Traveler Disk Setup 工具->旅行盘设置

You can use this facility to prepare a special traveler disk and launch  VeraCrypt from there. Note that VeraCrypt ‘traveler disk’ is *not* a VeraCrypt volume but an *unencrypted* volume. A ‘traveler disk’ contains VeraCrypt executable files and optionally the ‘autorun.inf’ script (see the section *AutoRun Configuration* below). After you select *Tools -> Traveler Disk Setup*, the *Traveler Disk Setup* dialog box should appear. Some of the parameters that can be set within the dialog deserve further explanation:
您可以使用此工具准备一个特殊的旅行者磁盘并从那里启动VeraCrypt。请注意，VeraCrypt的“旅行者磁盘”是 *不是*VeraCrypt加密卷，而是*未加密*的加密卷。一个'traveler disk'包含VeraCrypt可执行文件和可选的'autorun.inf'脚本（参见 下面的*自动运行配置*）。选择*工具->旅行盘设置*后， 应出现“*Traveler Disk Setup（旅行盘设置）”*对话框。一些可以在对话框中设置的参数值得进一步解释：

#### Include VeraCrypt Volume Creation Wizard 包含VeraCrypt加密卷创建向导

Check this option, if you need to create new VeraCrypt volumes using  VeraCrypt run from the traveler disk you will create. Unchecking this  option saves space on the traveler disk.
如果您需要使用从您创建的旅行者磁盘运行的VeraCrypt创建新的VeraCrypt加密卷，请选中此选项。取消选中此选项可节省旅行者磁盘上的空间。

#### AutoRun Configuration (autorun.inf) 自动运行配置（autorun.inf）

In this section, you can configure the ‘traveler disk’ to automatically  start VeraCrypt or mount a specified VeraCrypt volume when the ‘traveler disk’ is inserted. This is accomplished by creating a special script  file called ‘*autorun.inf*’ on the traveler disk. This file is automatically executed by the operating system each time the ‘traveler disk’ is inserted.
在本节中，您可以配置“traveler disk”以在插入“traveler disk”时自动启动VeraCrypt或装入指定的VeraCrypt卷。这是通过创建一个名为'*autorun.inf*'的特殊脚本文件来完成的 在旅行者磁盘上。每次插入“旅行者磁盘”时，操作系统都会自动执行此文件。

 Note, however, that this feature only works for removable storage  devices such as CD/DVD (Windows XP SP2, Windows Vista, or a later  version of Windows is required for this feature to work on USB memory  sticks) and only when it is enabled in the operating system. Depending on the operating system configuration, these auto-run and  auto-mount features may work only when the traveler disk files are  created on a non-writable CD/DVD-like medium (which is not a bug in  VeraCrypt but a limitation of Windows).
但是请注意，此功能仅适用于CD/DVD等可移动存储设备（此功能需要Windows XP SP2、Windows Vista或更高版本的Windows才能在USB记忆棒上工作），并且仅在操作系统中启用时才有效。 根据操作系统的配置，这些自动运行和自动挂载功能可能仅在旅行者磁盘文件创建在不可写的CD/DVD类介质上时才有效（这不是VeraCrypt的bug，而是Windows的限制）。

 Also note that the ‘*autorun.inf*’ file must be in the root directory (i.e., for example *G:\*, *X:\*, or *Y:\* etc.) of an **unencrypted**  disk in order for this feature to work.
还要注意，“*autorun.inf*”文件必须位于根目录中（即，例如 *G：\*、*X：\*或*Y：\*等）一个**未加密的**磁盘，以便此功能工作。

# TrueCrypt Support TrueCrypt支持

**Note: TrueCrypt support was dropped starting from version 1.26
注：TrueCrypt支持从版本1.26开始被删除**

Starting from version 1.0f, VeraCrypt supports loading TrueCrypt volumes and  partitions, both normal and hidden. In order to activate this, you have  to check “TrueCrypt Mode” in the password prompt dialog as shown below.
从VeraCrypt 1.0f版开始，VeraCrypt支持加载TrueCrypt加密卷和分区，包括普通和隐藏的。为了激活这个，你必须在密码提示对话框中选中“TrueCrypt模式”，如下所示。

![TrueCrypt mode](https://veracrypt.fr/en/TrueCrypt Support_truecrypt_mode_gui.jpg)

**Note:** Only volumes and partitions created using TrueCrypt versions **6.x** and **7.x** are supported.
**注意：**只有使用TrueCrypt版本创建的卷和分区 支持**6.x**和**7.x**。

# Converting TrueCrypt volumes and partitions 转换TrueCrypt卷和分区

**⚠️ Warning:** After conversion, ensure that the "TrueCrypt Mode" checkbox is not selected  during the mount of the converted volume. Since it is no longer a  TrueCrypt volume, mounting it with this option will lead to a mount  failure.
**警告️：**转换后，请确保在挂载转换后的加密卷时未选中“TrueCrypt Mode”复选框。由于它不再是TrueCrypt卷，因此使用此选项挂载它将导致挂载失败。

**⚠️ Important Notice:** As of version 1.26, VeraCrypt has removed support for "TrueCrypt Mode." Consequently, the conversion of TrueCrypt volumes and partitions using  this method is no longer possible. Please refer to [this documentation page](https://veracrypt.fr/en/Conversion_Guide_VeraCrypt_1.26_and_Later.html) for guidance on how to proceed with TrueCrypt volumes in VeraCrypt versions 1.26 and later.
**️重要提示：**从1.26版本开始，VeraCrypt已经移除了对“TrueCrypt模式”的支持。“因此，使用此方法转换TrueCrypt卷和分区不再可能。请参考[此文档页面](https://veracrypt.fr/en/Conversion_Guide_VeraCrypt_1.26_and_Later.html)，了解如何在VeraCrypt 1.26及更高版本中使用TrueCrypt加密卷。

From version 1.0f up to and including version 1.25.9, TrueCrypt volumes and **non-system** partitions created with TrueCrypt versions 6.x and 7.x, starting with  version 6.0 released on July 4th 2008, can be converted to VeraCrypt  format using any of the following actions:
从版本1.0f到版本1.25.9，使用TrueCrypt版本6.x和7.x创建的TrueCrypt卷和**非系统**分区，从2008年7月4日发布的版本6.0开始，可以使用以下任何操作转换为VeraCrypt格式：

- Change Volume Password  更改卷密码
- Set Header Key Derivation Algorithm 
  集合头密钥推导算法
- Add/Remove key files  添加/删除密钥文件
- Remove all key files  删除所有关键文件

If the TrueCrypt volume contains a hidden volume, it should also be  converted using the same approach, by specifying the hidden volume  password and/or keyfiles.
如果TrueCrypt加密卷包含一个隐藏加密卷，也应该使用相同的方法进行转换，通过指定隐藏加密卷密码和/或密钥文件。

🚨 After conversion of a file container, the file extension will remain as .tc. Manually change it to .hc if you want VeraCrypt 1.26 or newer to  automatically recognize it.
🚨转换文件容器后，文件扩展名将保留为. tc。如果您希望VeraCrypt 1.26或更新版本自动识别它，请手动将其更改为.hc。

“TrueCrypt Mode” must be checked in the dialog as shown below:
必须在对话框中选中“TrueCrypt Mode”，如下所示：

 ![img](https://veracrypt.fr/en/Converting TrueCrypt volumes and partitions_truecrypt_convertion.jpg)

**Note:** Converting system partitions encrypted with TrueCrypt is not supported.
**注意：**不支持转换使用TrueCrypt加密的系统分区。

# Conversion Guide for VeraCrypt 1.26 and Later VeraCrypt 1.26及更新版本转换指南

## 1. Introduction 1.介绍

Version 1.26 and newer of VeraCrypt have introduced significant changes by  removing support for certain features. If you encounter issues while  mounting volumes, this guide will help you understand and resolve them.
VeraCrypt 1.26及更新版本通过移除对某些功能的支持而引入了重大变化。如果您在挂载卷时遇到问题，本指南将帮助您了解并解决这些问题。

## 2. Deprecated Features in VeraCrypt 1.26 and Later 2. VeraCrypt 1.26及更新版本中不推荐使用的功能

The following features have been deprecated:
以下功能已弃用：

- TrueCrypt Mode TrueCrypt模式
- HMAC-RIPEMD-160 Hash Algorithm
  HMAC-RIPEMD-160哈希算法
- GOST89 Encryption Algorithm
  GOST 89加密算法

If you experience mounting errors with volumes created in VeraCrypt 1.25.9 or older, use VeraCrypt 1.25.9 to check if these deprecated features  are in use. Highlight the volume and click on "Volume Properties" in the GUI to check.
如果您在安装VeraCrypt 1.25.9或更早版本的加密卷时遇到错误，请使用VeraCrypt 1.25.9检查这些不推荐使用的功能是否在使用中。突出显示卷并单击GUI中的“卷属性”进行检查。

## 3. Remediation Procedures Based on Version 3.基于版本的修正程序

### 3.1 Scenario 1: Using VeraCrypt 1.25.9 or Older 3.1场景1：使用VeraCrypt 1.25.9或更早版本

If you are using or can upgrade to VeraCrypt 1.25.9, follow these steps:
如果您正在使用或者可以升级到VeraCrypt 1.25.9，请按照以下步骤操作：

- Convert TrueCrypt Volumes to VeraCrypt Volumes
  将TrueCrypt转换为VeraCrypt加密货币
- Change from Deprecated HMAC-RIPEMD-160 Hash Algorithm
  从已弃用的HMAC-RIPEMD-160哈希算法进行更改
- Recreate VeraCrypt Volume if Using GOST89 Encryption Algorithm
  使用GOST 89加密算法重新创建VeraCrypt加密卷

Download the 1.25.9 version [here](https://veracrypt.fr/en/Downloads_1.25.9.html).
下载1.25.9版本

### 3.2 Scenario 2: Upgraded to VeraCrypt 1.26 or Newer 3.2场景2：升级到VeraCrypt 1.26或更新版本

If you have already upgraded to VeraCrypt 1.26 or newer, follow these steps:
如果您已经升级到VeraCrypt 1.26或更新版本，请按照以下步骤操作：

- Convert TrueCrypt Volumes to VeraCrypt Volumes
  将TrueCrypt转换为VeraCrypt加密货币
- Change from Deprecated HMAC-RIPEMD-160 Hash Algorithm
  从已弃用的HMAC-RIPEMD-160哈希算法进行更改

If you are on Linux or Mac, temporarily downgrade to VeraCrypt 1.25.9. Windows users can use the VCPassChanger tool [that can be downloaded from here](https://launchpad.net/veracrypt/trunk/1.25.9/+download/VCPassChanger_(TrueCrypt_Convertion).zip).
如果您使用的是Linux或Mac，请暂时降级到VeraCrypt 1.25.9。Windows用户可以使用[可以从此处下载的](https://launchpad.net/veracrypt/trunk/1.25.9/+download/VCPassChanger_(TrueCrypt_Convertion).zip)VCPassChanger工具。

- Recreate VeraCrypt Volume if Using GOST89 Encryption Algorithm
  使用GOST 89加密算法重新创建VeraCrypt加密卷

All OSes temporarily downgrade to 1.25.9 version. 
所有操作系统暂时降级到1.25.9版本。

## 4. Conversion and Remediation Procedures 4.转换和补救程序

### 4.1 Converting TrueCrypt Volumes to VeraCrypt 4.1将TrueCrypt转换为VeraCrypt

TrueCrypt file containers and partitions created with TrueCrypt versions 6.x or  7.x can be converted to VeraCrypt using VeraCrypt 1.25.9 or the  VCPassChanger tool on Windows. For more details, refer to the [documentation](https://veracrypt.fr/en/Converting TrueCrypt volumes and partitions.html).
使用TrueCrypt 6.x或7.x版本创建的TrueCrypt文件容器和分区可以使用VeraCrypt 1.25.9或Windows上的VCPassChanger工具转换为VeraCrypt。有关详细信息，请参阅[文档](https://veracrypt.fr/en/Converting TrueCrypt volumes and partitions.html)。

After conversion, the file extension will remain as `.tc`. Manually change it to `.hc` if you want VeraCrypt 1.26 or newer to automatically recognize it.
转换后，文件扩展名将保持为`.tc`。如果您希望VeraCrypt 1.26或更新版本自动识别它，请手动将其更改为`.hc`。

### 4.2 Changing Deprecated HMAC-RIPEMD-160 Hash Algorithm 4.2 HMAC-RIPEMD-160哈希算法的改进

Use the "Set Header Key Derivation Algorithm" feature to change the  HMAC-RIPEMD-160 hash algorithm to one supported in VeraCrypt 1.26. Refer to the [documentation](https://veracrypt.fr/en/Hash Algorithms.html) for more details.
使用“设置头密钥推导算法”功能将HMAC-RIPEMD-160哈希算法更改为VeraCrypt 1.26支持的算法。有关详细信息，请参阅[文档](https://veracrypt.fr/en/Hash Algorithms.html)。

### 4.3 Recreating VeraCrypt Volume if Using GOST89 Encryption Algorithm 4.3使用GOST 89加密算法重建VeraCrypt加密卷

If your volume uses the GOST89 encryption algorithm, you will need to copy your data elsewhere and recreate the volume using a supported  encryption algorithm. More details are available in the [encryption algorithm documentation](https://veracrypt.fr/en/Encryption Algorithms.html).
如果您的卷使用GOST 89加密算法，则需要将数据复制到其他位置，然后使用支持的加密算法重新创建卷。更多详细信息请参见[加密算法文档](https://veracrypt.fr/en/Encryption Algorithms.html)。

## 5. Important Notes 5.重要提示

**Note to users who created volumes with VeraCrypt 1.17 or earlier:
使用VeraCrypt 1.17或更早版本创建加密卷的用户请注意：**

> To avoid revealing whether your volumes contain a hidden volume or not, or if you rely on plausible deniability, you must recreate both the outer  and hidden volumes, including system encryption and hidden OS. Discard  existing volumes created prior to VeraCrypt 1.18a.
> 为了避免泄露您的加密卷是否包含隐藏加密卷，或者如果您依赖合理的否认，您必须重新创建外部加密卷和隐藏加密卷，包括系统加密和隐藏操作系统。丢弃在VeraCrypt 1.18a之前创建的现有加密卷。

For more information, visit:
有关更多信息，请访问：

- [TrueCrypt Support TrueCrypt支持](https://veracrypt.fr/en/TrueCrypt Support.html)
- [Converting TrueCrypt Volumes and Partitions
  转换TrueCrypt加密和分区](https://veracrypt.fr/en/Converting TrueCrypt volumes and partitions.html)

## Default Mount Parameters 默认装载参数

Starting from version 1.0f-2, it is possible to specify the PRF algorithm and  the TrueCrypt mode that will be selected by default in the password  dialog.
从版本1.0f-2开始，可以在密码对话框中指定默认选择的PRF算法和TrueCrypt模式。

As show below, select the entry "Default Mount Parameters" under the menu "Settings":
如下图所示，选择菜单“设置”下的条目“默认安装参数”：

![Menu Default Mount Parameters](https://veracrypt.fr/en/Home_VeraCrypt_menu_Default_Mount_Parameters.png)

 

The following dialog will be displayed:
将显示以下对话框：

![Default Mount Parameters Dialog](https://veracrypt.fr/en/Home_VeraCrypt_Default_Mount_Parameters.png)

Make your modifications and then click OK.
进行修改，然后单击“确定”。

The chosen values are then written to VeraCrypt main configuration file (Configuration.xml) making them persistent.
所选的值会被写入VeraCrypt主配置文件（configuration. xml），使其持久化。

All subsequent password request dialogs will use the default values chosen  previously. For example, if in the Default Mount Parameters dialog you  check TrueCrypt Mode and you select SHA-512 as a PRF, then subsequent  password dialogs will look like:
所有后续的密码请求对话框将使用先前选择的默认值。例如，如果在默认安装参数对话框中选中TrueCrypt模式并选择SHA-512作为PRF，则随后的密码对话框将如下所示：
 ![Mount Password Dialog using default values](https://veracrypt.fr/en/Default Mount Parameters_VeraCrypt_password_using_default_parameters.png)

 

**Note:** The default mount parameters can be overridden by the [Command Line](https://veracrypt.fr/en/Command Line Usage.html) switches **/tc** and **/hash** which always take precedence.
**注意：**默认的挂载参数可以被[命令行](https://veracrypt.fr/en/Command Line Usage.html)开关覆盖 **/tc**和**/hash**始终优先。

# Language Packs 语言包


 Language packs contain third-party translations of the VeraCrypt user  interface texts. Note that language packs are currently supported only  by the Windows version of VeraCrypt.
语言包包含VeraCrypt用户界面文本的第三方翻译。请注意，目前只有Windows版本的VeraCrypt支持语言包。

### Installation 安装

Since version 1.0e, all language packs are included in the VeraCrypt  Windows installer and they can be found in VeraCrypt installation  directory. To select a new language, run VeraCrypt, select *Settings* -> *Language*, then select your language and click *OK*.
从1.0e版开始，所有的语言包都包含在VeraCrypt Windows安装程序中，可以在VeraCrypt安装目录中找到。要选择新语言，运行VeraCrypt，选择 *设置*->*语言*，然后选择您的语言并单击 *好*的.

To revert to English, select *Settings* ->  *Language*. Then select *English* and click  *OK*.
要恢复为英语，请选择*设置*->*语言*。然后选择*英语*并单击*确定*。

You can still download an archive containing all language packs for the latest version (1.26.15) from [ the following link](https://launchpad.net/veracrypt/trunk/1.26.15/+download/VeraCrypt_1.26.15_Language_Files.zip).
您仍然可以从以下地址下载包含最新版本（1.26.15）的所有语言包的存档文件： [以下链接](https://launchpad.net/veracrypt/trunk/1.26.15/+download/VeraCrypt_1.26.15_Language_Files.zip)。 

# Encryption Algorithms 加密算法

VeraCrypt volumes can be encrypted using the following algorithms:
VeraCrypt加密卷可以使用以下算法进行加密：

|                        Algorithm 算法                        |                     Designer(s) 设计人员                     | Key Size 密钥大小  (Bits) （位） | Block Size (Bits) 数据块大小（位） | [Mode of Operation 操作模式](https://veracrypt.fr/en/Modes of Operation.html) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :------------------------------: | :--------------------------------: | :----------------------------------------------------------: |
|                                                              |                                                              |                                  |                                    |                                                              |
|           [AES](https://veracrypt.fr/en/AES.html)            |          J. Daemen, V. Rijmen J. Daemen，V. Rijmen           |               256                |                128                 |    [XTS](https://veracrypt.fr/en/Modes of Operation.html)    |
|    [Camellia 山茶](https://veracrypt.fr/en/Camellia.html)    |    Mitsubishi Electric and NTT of Japan 日本三菱电机和NTT    |               256                |                128                 |                             XTS                              |
| [Kuznyechik 库兹涅奇克](https://veracrypt.fr/en/Kuznyechik.html) | National Standard of the Russian Federation 俄罗斯联邦国家标准  GOST R 34.12-2015 |               256                |                128                 |                             XTS                              |
|      [Serpent 蛇](https://veracrypt.fr/en/Serpent.html)      | R. Anderson, E. Biham, L. Knudsen R.安德森，E.比昂湖Knudsen  |               256                |                128                 |                             XTS                              |
|       [Twofish](https://veracrypt.fr/en/Twofish.html)        | B. Schneier, J. Kelsey, D. Whiting, B。作者：凯尔西，D.怀汀，  D. Wagner, C. Hall, N. Ferguson D.瓦格纳，C.霍尔，N。弗格森 |               256                |                128                 |                             XTS                              |
| [AES-Twofish AES-双鱼](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
| [AES-Twofish-Serpent AES-双鱼-蛇](https://veracrypt.fr/en/Cascades.html) |                                                              |          256; 256; 256           |                128                 |                             XTS                              |
| [Camellia-Kuznyechik 山茶花-库兹涅奇克](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
| [Camellia-Serpent 山茶属蛇](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
| [Kuznyechik-AES 库兹涅奇克-AES](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
| [Kuznyechik-Serpent-Camellia 库兹涅奇克蛇山茶](https://veracrypt.fr/en/Cascades.html) |                                                              |          256; 256; 256           |                128                 |                             XTS                              |
| [Kuznyechik-Twofish 库兹涅奇克-特沃菲什](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
|     [Serpent-AES](https://veracrypt.fr/en/Cascades.html)     |                                                              |             256; 256             |                128                 |                             XTS                              |
| [Serpent-Twofish-AES 双尾蛇](https://veracrypt.fr/en/Cascades.html) |                                                              |          256; 256; 256           |                128                 |                             XTS                              |
| [Twofish-Serpent 双鱼蛇](https://veracrypt.fr/en/Cascades.html) |                                                              |             256; 256             |                128                 |                             XTS                              |
|                                                              |                                                              |                                  |                                    |                                                              |

For information about XTS mode, please see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html).
有关XTS模式的信息，请参见[“操作模式”](https://veracrypt.fr/en/Modes of Operation.html)一节。

# AES

The Advanced Encryption Standard (AES) specifies a FIPS-approved  cryptographic algorithm (Rijndael, designed by Joan Daemen and Vincent  Rijmen, published in 1998) that may be used by US federal departments  and agencies to cryptographically protect sensitive information [3]. VeraCrypt uses AES with 14 rounds and a 256-bit key  (i.e., AES-256, published in 2001) operating in [ XTS mode](https://veracrypt.fr/en/Modes of Operation.html) (see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)).
高级加密标准（AES）规定了一种FIPS批准的加密算法（Rijndael，由Joan Daemen和Vincent Rijmen设计，1998年出版），可由美国联邦部门和机构使用，以加密方式保护敏感信息。 信息[3]。VeraCrypt使用14轮AES和256位密钥（即，AES-256，2001年出版）， [XTS模式](https://veracrypt.fr/en/Modes of Operation.html)（参见“[操作模式”](https://veracrypt.fr/en/Modes of Operation.html)一节）。

In June 2003, after the NSA (US National Security Agency) conducted a  review and analysis of AES, the U.S. CNSS (Committee on National  Security Systems) announced in [1] that the design and strength of  AES-256 (and AES-192) are sufficient to protect classified information up to the Top Secret level. This is applicable to all U.S.  Government Departments or Agencies that are considering the acquisition  or use of products incorporating the Advanced Encryption Standard (AES)  to satisfy Information Assurance requirements associated with the protection of national security systems and/or  national security information [1].
2003年6月，在NSA（美国国家安全局）对AES进行审查和分析后，美国国家安全系统委员会（CNSS）在[1]中宣布AES-256（和AES-192）的设计和强度足以保护最高机密级别的机密信息。这适用于正在考虑购买或使用包含高级加密标准（AES）的产品以满足与保护国家安全系统和/或国家安全信息相关的信息保证要求的所有美国政府部门或机构。

# Camellia 山茶

Jointly developed by Mitsubishi Electric and NTT of Japan, Camellia is a 128-bit block cipher that was first published on 2000. It has been  approved for use by the ISO/IEC, the European Union's NESSIE project and the Japanese CRYPTREC project.
Camellia是由三菱电机和日本NTT联合开发的128位分组密码，于2000年首次发布。它已被ISO/IEC、欧盟的NESSIE项目和日本的ESPREC项目批准使用。

VeraCrypt uses Camellia with 24 rounds and a 256-bit key operating in [ XTS mode](https://veracrypt.fr/en/Modes of Operation.html) (see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)).
VeraCrypt使用Camellia，24轮，256位密钥，在[XTS模式](https://veracrypt.fr/en/Modes of Operation.html)下运行（参见[运行模式一](https://veracrypt.fr/en/Modes of Operation.html)节）。

# Kuznyechik 库兹涅奇克

Kuznyechik is a 128-bit block cipher first published in 2015 and defined in the National Standard of the Russian Federation [GOST R 34.12-2015](http://tc26.ru/en/standard/gost/GOST_R_34_12_2015_ENG.pdf) and also in [RFC 7801](https://tools.ietf.org/html/rfc7801). It supersedes the old GOST-89 block cipher although it doesn't obsolete it.
Kuznyechik是一种128位分组密码，于2015年首次发布，并在俄罗斯联邦国家标准[GOST R 34.12-2015中](http://tc26.ru/en/standard/gost/GOST_R_34_12_2015_ENG.pdf)定义。 [RFC 7801](https://tools.ietf.org/html/rfc7801)。它取代了旧的GOST-89分组密码，尽管它没有过时。

VeraCrypt uses Kuznyechik with 10 rounds and a 256-bit key operating in [ XTS mode](https://veracrypt.fr/en/Modes of Operation.html) (see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)).
VeraCrypt使用Kuznyechik，10轮256位密钥，在[XTS模式](https://veracrypt.fr/en/Modes of Operation.html)下运行（参见[运行模式一](https://veracrypt.fr/en/Modes of Operation.html)节）。

[Next Section >> 下一节>>](https://veracrypt.fr/en/Serpent.html)

# Serpent 蛇

Designed by Ross Anderson, Eli Biham, and Lars Knudsen; published in 1998. It  uses a 256-bit key, 128-bit block, and operates in XTS mode (see the  section [*Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Serpent was one of the AES finalists. It was not selected as the  proposed AES algorithm even though it appeared to have a higher security margin than the winning Rijndael [4]. More concretely, Serpent appeared to  have a *high* security margin, while Rijndael appeared to have only an *adequate* security margin [4]. Rijndael has also received some criticism  suggesting that its mathematical structure might lead to attacks in the  future [4].
由Ross安德森、Eli Biham和Lars Knudsen设计; 1998年出版。它使用256位密钥、128位数据块，并在XTS模式下运行（请参见 [*操作模式*](https://veracrypt.fr/en/Modes of Operation.html)）。蛇是AES决赛选手之一。它没有被选为拟议的AES算法，即使它似乎有一个更高的安全裕度 [4]《易经》中的易经。更具体地说，Serpent似乎有很*高*的安全边际，而Rijndael似乎只有 *足够的*安全裕度[4]。Rijndael也受到了一些批评，认为它的数学结构可能会导致未来的攻击[4]。

 In [5], the Twofish team presents a table of safety factors for the AES  finalists. Safety factor is defined as: number of rounds of the full  cipher divided by the largest number of rounds that has been broken.  Hence, a broken cipher has the lowest safety factor 1. Serpent had the highest safety factor of the AES finalists: 3.56  (for all supported key sizes). Rijndael-256 had a safety factor of 1.56.
在[5]中，Twofish团队为AES决赛选手提供了一个安全系数表。安全系数定义为：完整密码的轮数除以已被破解的最大轮数。因此，被破解的密码的安全系数最低 1. Serpent在AES决赛中拥有最高的安全系数：3.56（对于所有支持的密钥大小）。Rijndael-256的安全系数为1.56。

 In spite of these facts, Rijndael was considered an appropriate  selection for the AES for its combination of security, performance,  efficiency, implementability, and flexibility [4]. At the last AES  Candidate Conference, Rijndael got 86 votes, Serpent got 59 votes, Twofish got 31 votes, RC6 got 23 votes, and MARS got 13 votes  [18, 19].*
尽管如此，Rijndael被认为是AES的合适选择，因为它结合了安全性，性能，效率，可实现性和灵活性[4]。在上一次AES候选人会议上，Rijndael获得86票，Serpent获得59票 其中，Twofish获得31票，RC 6获得23票，MARS获得13票[18，19]。

\* These are positive votes. If negative votes are subtracted from the  positive votes, the following results are obtained: Rijndael: 76 votes,  Serpent: 52 votes, Twofish: 10 votes, RC6: -14 votes, MARS: -70 votes  [19].
\* 这些都是积极的投票。如果从赞成票中减去反对票，则得到以下结果：Rijndael：76票，Serpent：52票，Twofish：10票，RC 6：-14票，MARS：-70票[19]。

# Twofish

Designed by Bruce Schneier, John Kelsey, Doug Whiting, David Wagner, Chris Hall, and Niels Ferguson; published in 1998. It uses a 256-bit key and  128-bit block and operates in XTS mode (see the section [*Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Twofish was one of the AES finalists. This cipher uses key- dependent  S-boxes. Twofish may be viewed as a collection of 2128 different  cryptosystems, where 128 bits derived from a 256-bit key control the selection of the  cryptosystem [4]. In [13], the Twofish team asserts that key-dependent  S-boxes constitute a form of security margin against unknown attacks  [4].
由布鲁斯施奈尔、约翰凯尔西、道格·怀汀、大卫瓦格纳、克里斯·霍尔和尼尔斯·弗格森设计; 1998年出版。它使用256位密钥和128位块，并在XTS模式下运行（请参见 [*操作模式*](https://veracrypt.fr/en/Modes of Operation.html)）。Twofish是AES决赛选手之一。这个密码使用密钥相关的S盒。Twofish可以被看作是2128种不同密码系统的集合，其中从256位密钥导出的128位控制密码系统的选择[4]。在[13]中，Twofish团队声称密钥相关的S盒构成了一种针对未知攻击的安全裕度[4]。

# Cascades of ciphers 密码级联

 

## AES-Twofish AES-双鱼

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Twofish (256-bit key) in XTS mode and then with AES (256-bit key) in XTS mode. Each of the cascaded  ciphers uses its own key. All encryption keys are mutually independent  (note that header keys are independent too, even though they are derived from a  single password – see [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Twofish（256位密钥）加密，然后在XTS模式下使用AES（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都是相互独立的（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## AES-Twofish-Serpent AES-双鱼-蛇

Three ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Serpent (256-bit key) in XTS mode, then with Twofish (256-bit key) in XTS mode, and finally with AES (256-bit key) in XTS mode. Each of the cascaded ciphers uses its own  key. All encryption keys are mutually independent (note that header keys are independent  too, even though they are derived from a single password – see the  section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
级联的三个密码[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Serpent（256位密钥）加密，然后在XTS模式下使用Twofish（256位密钥）加密，最后在XTS模式下使用AES（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密 键是相互独立的（请注意，标头键也是独立的，即使它们是从单个密码派生的-请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Camellia-Kuznyechik 山茶花-库兹涅奇克

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Kuznyechik (256-bit key) in  XTS mode and then with Camellia (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a  single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Kuznyechik（256位密钥）加密，然后在XTS模式下使用Camellia（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都相互独立（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Camellia-Serpent 山茶属蛇

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Serpent (256-bit key) in XTS mode and then with Camellia (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a  single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Serpent（256位密钥）加密，然后在XTS模式下使用Camellia（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都相互独立（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Kuznyechik-AES 库兹涅奇克-AES

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with AES (256-bit key) in XTS  mode and then with Kuznyechik (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a  single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用AES（256位密钥）加密，然后在XTS模式下使用Kuznyechik（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都是相互独立的（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Kuznyechik-Serpent-Camellia 库兹涅奇克蛇山茶

Three ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Camellia (256-bit key) in  XTS mode, then with Serpent (256- bit key) in XTS mode, and finally with Kuznyechik (256-bit key) in XTS mode. Each of the cascaded ciphers uses its own key. All encryption keys are mutually independent (note that header keys are  independent too, even though they are derived from a single password –  see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
级联的三个密码[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Camellia（256位密钥）加密，然后在XTS模式下使用Serpent（256位密钥）加密，最后在XTS模式下使用Kuznyechik（256位密钥）加密。每个级联密码都使用自己的密钥。所有 加密密钥是相互独立的（请注意，标头密钥也是独立的，即使它们是从单个密码派生的-请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Kuznyechik-Twofish 库兹涅奇克-特沃菲什

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Twofish (256-bit key) in XTS mode and then with Kuznyechik (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a  single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Twofish（256位密钥）加密，然后在XTS模式下使用Kuznyechik（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都相互独立（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Serpent-AES

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with AES (256-bit key) in XTS  mode and then with Serpent (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a  single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用AES（256位密钥）加密，然后在XTS模式下使用Serpent（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都相互独立（请注意， 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Serpent-Twofish-AES 双尾蛇

Three ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with AES (256-bit key) in XTS  mode, then with Twofish (256- bit key) in XTS mode, and finally with  Serpent (256-bit key) in XTS mode. Each of the cascaded ciphers uses its own key. All encryption keys are mutually independent (note that header keys are  independent too, even though they are derived from a single password –  see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
级联的三个密码[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用AES（256位密钥）加密，然后在XTS模式下使用Twofish（256位密钥）加密，最后在XTS模式下使用Serpent（256位密钥）加密。每个级联密码都使用自己的密钥。所有 加密密钥是相互独立的（请注意，标头密钥也是独立的，即使它们是从单个密码派生的-请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

## Twofish-Serpent 双鱼蛇

Two ciphers in a cascade [15, 16] operating in XTS mode (see the section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)). Each 128-bit block is first encrypted with Serpent (256-bit key) in XTS mode and then with Twofish (256-bit key) in XTS mode. Each of the  cascaded ciphers uses its own key. All encryption keys are mutually  independent (note that header keys are independent too, even though they are derived from a single password – see the section [*Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)). See above for information on the individual cascaded ciphers.
两个密码级联[15，16]在XTS模式下运行（参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节）。每个128位块首先在XTS模式下使用Serpent（256位密钥）加密，然后在XTS模式下使用Twofish（256位密钥）加密。每个级联密码都使用自己的密钥。所有加密密钥都是相互独立的（注意 头密钥也是独立的，即使它们是从单个密码派生的-请参阅 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)）。有关各个级联密码的信息，请参见上文。

# Hash Algorithms 散列算法

In the Volume Creation Wizard, in the password change dialog window, and in the Keyfile Generator dialog window, you can select a hash  algorithm. A user-selected hash algorithm is used by the VeraCrypt  Random Number Generator as a pseudorandom "mixing" function, and by the header key derivation function (HMAC based on a hash  function, as specified in PKCS #5 v2.0) as a pseudorandom function. When creating a new volume, the Random Number Generator generates the master key, secondary key (XTS mode), and salt. For more information, please see the section [ Random Number Generator](https://veracrypt.fr/en/Random Number Generator.html) and section [ Header Key Derivation, Salt, and Iteration Count](https://veracrypt.fr/en/Header Key Derivation.html).
在“卷创建向导”、"密码更改“对话框窗口和”密钥文件生成器“对话框窗口中，可以选择哈希算法。用户选择的哈希算法被VeraCrypt随机数生成器用作伪随机“混合”函数，并被头密钥导出函数（基于哈希函数的HMAC，如PKCS #5 v2.0中所指定）用作伪随机函数。创建新卷时，随机数生成器会生成主密钥、辅助密钥（XTS模式）和salt。有关更多信息，请参阅[随机数生成器](https://veracrypt.fr/en/Random Number Generator.html)部分和[头密钥推导，盐和迭代计数部分](https://veracrypt.fr/en/Header Key Derivation.html)。

VeraCrypt currently supports the following hash algorithms:
VeraCrypt目前支持以下哈希算法：

- [**BLAKE2s-256**](https://veracrypt.fr/en/BLAKE2s-256.html)
- [**SHA-256**](https://veracrypt.fr/en/SHA-256.html)
- [**SHA-512**](https://veracrypt.fr/en/SHA-512.html)
- [**Whirlpool 漩涡**](https://veracrypt.fr/en/Whirlpool.html)
- **[Streebog 斯特雷博格](https://veracrypt.fr/en/Streebog.html)**

# BLAKE2s-256

BLAKE2 is a cryptographic hash function based on BLAKE, created by  Jean-Philippe Aumasson, Samuel Neves, Zooko Wilcox-O'Hearn, and  Christian Winnerlein. It was announced on December 21, 2012. The design  goal was to replace the widely used, but broken, MD5 and SHA-1  algorithms in applications requiring high performance in software.  BLAKE2 provides better security than SHA-2 and similar to that of SHA-3  (e.g. immunity to length extension, indifferentiability from a random  oracle, etc...).
BLAKE 2是一个基于BLAKE的加密哈希函数，由Jean-Philippe Aumasson，Samuel Neves，Zooko Wilcox-O  'Hearn和Christian  Winnerlein创建。2012年12月21日宣布。设计目标是在需要高性能软件的应用中取代广泛使用但已损坏的MD5和SHA-1算法。BLAKE 2提供了比SHA-2更好的安全性，并且与SHA-3相似（例如，对长度扩展的免疫性，与随机预言的不可区分性等）。
 BLAKE2 removes addition of constants to message words from BLAKE round  function, changes two rotation constants, simplifies padding, adds  parameter block that is XOR'ed with initialization vectors, and reduces  the number of rounds from 16 to 12 for BLAKE2b (successor of BLAKE-512), and from 14 to 10 for BLAKE2s (successor of BLAKE-256).
BLAKE 2从BLAKE轮函数中去除了对消息字的常数添加，改变了两个旋转常数，简化了填充，添加了与初始化向量进行了“异或”艾德的参数块，并且将BLAKE 2b（BLAKE-512的后继者）的轮数从16减少到12，并且将BLAKE 2 s（BLAKE-256的后继者）的轮数从14减少到10。
 BLAKE2b and BLAKE2s are specified in RFC 7693. 
BLAKE 2b和BLAKE 2s在RFC 7693中指定。

VeraCrypt uses only BLAKE2s with its maximum output size of 32-bytes (256 bits). 
VeraCrypt只使用BLAKE2，其最大输出大小为32字节（256位）。

[文档](https://veracrypt.fr/en/Documentation.html) ![>>](https://veracrypt.fr/en/arrow_right.gif) [哈希算法](https://veracrypt.fr/en/Hash Algorithms.html) ![>>](https://veracrypt.fr/en/arrow_right.gif) [SHA-256](https://veracrypt.fr/en/SHA-256.html)

# SHA-256

SHA-256 is a hash algorithm designed by the NSA and published by NIST in FIPS PUB 180-2 [14] in 2002 (the first draft was published in 2001).  The size of the output of this algorithm is 256 bits.
SHA-256是一种由NSA设计的哈希算法，由NIST于2002年在FIPS PUB 180-2 [14]中发布（第一稿于2001年发布）。该算法的输出大小为256位。

# SHA-512

SHA-512 is a hash algorithm designed by the NSA and published by NIST in FIPS PUB 180-2 [14] in 2002 (the first draft was published in 2001).  The size of the output of this algorithm is 512 bits.
SHA-512是一种由NSA设计的哈希算法，由NIST于2002年在FIPS PUB 180-2 [14]中发布（第一稿于2001年发布）。该算法的输出大小为512位。

# Whirlpool 漩涡

The Whirlpool hash algorithm was designed by Vincent Rijmen (co-designer of the AES encryption algorithm) and Paulo S. L. M. Barreto. The size  of the output of this algorithm is 512 bits. The first version of  Whirlpool, now called Whirlpool-0, was published in November 2000. The second version, now called Whirlpool-T, was  selected for the NESSIE (*New European Schemes for Signatures, Integrity and Encryption*) portfolio of cryptographic primitives (a project organized by the  European Union, similar to the AES competition). VeraCrypt uses the third  (final) version of Whirlpool, which was adopted by the International  Organization for Standardization (ISO) and the IEC in the ISO/IEC  10118-3:2004 international standard [21].
Whirlpool哈希算法是由Vincent Rijmen（AES加密算法的共同设计者）和Paulo S。L.  M.巴雷托该算法的输出大小为512位。Whirlpool的第一个版本，现在称为Whirlpool-0，于2000年11月出版。第二个版本，现在称为Whirlpool-T，被选为NESSIE（*新欧洲签名，完整性和加密方案*）的密码原语组合（由欧盟组织的一个项目，类似于AES竞赛）。VeraCrypt使用Whirlpool的第三（最终）版本，该版本被国际标准化组织（ISO）和IEC在ISO/IEC 10118-3：2004国际标准中采用[21]。

# Streebog 斯特雷博格

Streebog is a family of two hash algorithms, Streebog-256 and Streebog-512, defined in the Russian national standard [GOST R 34.11-2012](https://www.tc26.ru/research/polozhenie/GOST_R_34_11-2012_eng.pdf) Information Technology - Cryptographic Information Security - Hash Function. It is also described in [ RFC 6986](https://tools.ietf.org/html/rfc6986). It is the competitor of NIST SHA-3 standard.
Streebog是俄罗斯国家标准[GOST R 34.11-2012《](https://www.tc26.ru/research/polozhenie/GOST_R_34_11-2012_eng.pdf)信息技术-密码信息安全-哈希函数》中定义的两种哈希算法Streebog-256和Streebog-512。[RFC 6986](https://tools.ietf.org/html/rfc6986)中也有描述。它是NIST SHA-3标准的竞争者。

VeraCrypt uses only Streebog-512 which has an output size of 512 bits.
VeraCrypt只使用Streebog-512，其输出大小为512位。

# Supported Operating Systems 支持的操作系统

VeraCrypt currently supports the following operating systems:
VeraCrypt目前支持以下操作系统：

- Windows 11 
- Windows 10 
- Windows Server 2016 
- Mac OS X 14 Sonoma 
  Mac OS X 14索诺马
- Mac OS X 13 Ventura 
  Mac OS X 13
- Mac OS X 12 Monterey 
- Linux x86, x86-64, ARM64 (Starting from Debian 10, Ubuntu 20.04, CentOS 7, OpenSUSE 15.1)  
  Linux x86，x86-64，ARM 64（从Debian 10，Ubuntu 20.04，CentOS 7，OpenSUSE 15.1开始）
- FreeBSD x86-64 (starting from version 12) 
  FreeBSD x86-64（从版本12开始）
- Raspberry Pi OS (32-bit and 64-bit) 
  Raspberry Pi OS（32位和64位）

Note:  注意事项：
 VeraCrypt 1.25.9 is the last version that supports Windows XP, Windows Vista, Windows 7, Windows 8, and Windows 8.1.
VeraCrypt 1.25.9是支持Windows XP，Windows Vista，Windows 7，Windows 8和Windows 8.1的最后一个版本。
 VeraCrypt 1.25.9 is the last version the supports Mac OS X versions from 10.9 Mavericks to 11 Big Sur
VeraCrypt 1.25.9是最后一个支持Mac OS X 10.9 Mavericks到11 Big Sur的版本
 VeraCrypt 1.24-Update8 is the last version that supports Mac OS X 10.7 Lion and Mac OS X 10.8 Mountain Lion.
VeraCrypt 1.24-Update 8是最后一个支持Mac OS X 10.7 Lion和Mac OS X 10.8 Mountain Lion的版本。


 Note: The following operating systems (among others) are not supported:  Windows RT, Windows 2003 IA-64, Windows 2008 IA-64, Windows XP IA-64,  and the Embedded/Tablet versions of Windows.
注意事项：不支持以下操作系统：Windows RT、Windows 2003 IA-64、Windows 2008 IA-64、Windows XP IA-64和Windows的嵌入式/平板电脑版本。



 Also see the section **[Operating Systems Supported for System  Encryption](https://veracrypt.fr/en/Supported Systems for System Encryption.html)**
另请参阅**[系统加密支持的操作系统](https://veracrypt.fr/en/Supported Systems for System Encryption.html)**部分

# Command Line Usage 命令行用法

Note that this section applies to the Windows version of VeraCrypt. For information on command line usage applying to the **Linux and Mac OS X versions**, please run: veracrypt –h
请注意，本节适用于Windows版本的VeraCrypt。有关应用于 **Linux和Mac OS X版本**，请运行：veracrypt -h

| */help* or */?* */help*还是*/？*            | Display command line help. 显示命令行帮助。                  |
| ------------------------------------------- | ------------------------------------------------------------ |
| */truecrypt or /tc /truecrypt或/tc*         | Activate TrueCrypt compatibility mode which enables mounting volumes created with TrueCrypt 6.x and 7.x series. 激活TrueCrypt兼容模式，允许挂载使用TrueCrypt 6.x和7.x系列创建的卷。 |
| */hash*                                     | It must be followed by a parameter indicating the PRF hash algorithm to  use when mounting the volume. Possible values for /hash parameter are:  sha256, sha-256, sha512, sha-512, whirlpool, blake2s and blake2s-256.  When /hash is omitted, VeraCrypt will try all possible PRF algorithms thus lengthening the mount operation time. 它后面必须跟一个参数，指示装入卷时要使用的PRF哈希算法。/hash参数的可能值为：sha 256、sha-256、sha 512、sha-512、whirlpool、blake 2s和blake  2s-256。当/hash被忽略时，VeraCrypt会尝试所有可能的PRF算法，从而延长挂载操作的时间。 |
| */volume* or */v* */体积*或*/v*             | It must be followed by a parameter indicating the file and path name of a  VeraCrypt volume to mount (do not use when dismounting) or the Volume ID of the disk/partition to mount. 它后面必须跟一个参数，指明要挂载的VeraCrypt卷的文件名和路径名（挂载时不要使用），或者要挂载的磁盘/分区的卷ID。  The syntax of the volume ID is **ID:XXXXXX...XX** where the XX part is a 64 hexadecimal characters string that represent the 32-Bytes ID of the desired volume to mount. 卷ID的语法为**ID：XXXX... XX**，其中XX部分是一个64个十六进制字符的字符串，表示要装载的所需卷的32字节ID。    To mount a partition/device-hosted volume, use, for example, /v  \Device\Harddisk1\Partition3 (to determine the path to a  partition/device, run VeraCrypt and click *Select Device*). You can also mount a partition or dynamic volume using its volume name  (for example, /v \\?\Volume{5cceb196-48bf-46ab-ad00-70965512253a}\). To  determine the volume name use e.g. mountvol.exe. Also note that device  paths are case-sensitive. 要挂载一个分区/设备托管的卷，例如，使用/v \Device\Harddisk1\Partition3（要确定分区/设备的路径，运行VeraCrypt并点击 *选择设备*）。还可以使用分区或动态卷的卷名（例如，/v \\？\卷{5cceb 196 - 48 bf-46 ab-ad 00 - 70965512253 a}\）。要确定卷名，请使用例如mountvol.exe。另请注意，设备路径区分大小写。    You can also specify the Volume ID of the partition/device-hosted volume to mount, for example: /v  ID:53B9A8D59CC84264004DA8728FC8F3E2EE6C130145ABD3835695C29FD601EDCA. The Volume ID value can be retrieved using the volume properties dialog. 您还可以指定要装载的分区/设备托管卷的卷ID，例如：/v ID：53 B 9A 8D 59 CC 84264004 DA 8728 FC 8 F3 E2 EE 6C 130145 ABD  3835695 C29 FD 601 EDCA。可以使用卷属性对话框检索卷ID值。 |
| */letter* or */l* */letter*或*/l*           | It must be followed by a parameter indicating the driver letter to mount  the volume as. When /l is omitted and when /a is used, the first free  drive letter is used. 它后面必须跟一个参数，指示要将卷装载为的驱动程序号。如果省略/l而使用/a，则使用第一个空闲驱动器号。 |
| */explore* or */e* */explore*或*/e*         | Open an Explorer window after a volume has been mounted. 在卷装入后打开资源管理器窗口。 |
| */beep* or */b* */beep*或*/B*               | Beep after a volume has been successfully mounted or dismounted. 成功装入或卸载卷后发出蜂鸣音。 |
| */auto* or */a* */auto*或*/a*               | If no parameter is specified, automatically mount the volume. If devices  is specified as the parameter (e.g., /a devices), auto-mount all  currently accessible device/partition-hosted VeraCrypt volumes. If  favorites is specified as the parameter, auto-mount favorite volumes. Note that /auto is implicit if /quit and /volume are  specified. If you need to prevent the application window from appearing, use /quit. 如果未指定参数，则自动装入卷。如果设备被指定为参数（例如，/a设备），自动挂载所有当前可访问的设备/分区托管的VeraCrypt加密卷。如果将收藏夹指定为参数，则自动装载收藏夹卷。请注意，如果指定了/quit和/volume，则/auto是隐式的。如果您需要阻止应用程序窗口出现，请使用/quit。 |
| */dismount* or */d* 或*/**d*                | Dismount volume specified by drive letter (e.g., /d x). When no drive letter is  specified, dismounts all currently mounted VeraCrypt volumes. 卸载由驱动器号指定的卷（例如，/d x）。当没有指定驱动器号时，卸载所有当前挂载的VeraCrypt加密卷。 |
| */force* or */f* */force*或*/f*             | Forces dismount (if the volume to be dismounted contains files being used by  the system or an application) and forces mounting in shared mode (i.e.,  without exclusive access). 强制挂载（如果要挂载的卷包含系统或应用程序正在使用的文件）并强制以共享模式挂载（即，没有独占访问）。 |
| */keyfile* or */k* */keyfile*或*/k*         | It must be followed by a parameter specifying a keyfile or a keyfile  search path. For multiple keyfiles, specify e.g.: /k c:\keyfile1.dat /k  d:\KeyfileFolder /k c:\kf2 To specify a keyfile stored on a security  token or smart card, use the following syntax: token://slot/SLOT_NUMBER/file/FILE_NAME 它后面必须跟一个参数，指定一个密钥文件或密钥文件搜索路径。对于多个密钥文件，请指定例如：/k c：\keyfile1.dat/k d：\KeyfileFolder /k  c：\kf2若要指定存储在安全令牌或智能卡上的密钥文件，请使用以下语法：token：//slot/SLOT_NUMBER/file/FILE_NAME |
| */tryemptypass*                             | ONLY when default keyfile configured or when a keyfile is specified in the command line. 仅当配置了默认密钥文件或在命令行中指定了密钥文件时。  If it is followed by **y** or **yes** or if no parameter is specified: try to mount using an empty password and the keyfile before displaying password prompt. 如果后面跟着**y**或**yes**，或者没有指定参数：在显示密码提示符之前，尝试使用空密码和密钥文件挂载。  if it is followed by **n** or **no**: don't try to mount using an empty password and the keyfile, and display password prompt right away. 如果后面是**n**或**no**：不要尝试使用空密码和密钥文件挂载，并立即显示密码提示。 |
| */nowaitdlg*                                | If it is followed by **y** or **yes** or if no parameter is specified: don’t display the waiting dialog while performing operations like mounting volumes. 如果后跟**y**或**yes**或未指定参数：执行挂载卷等操作时不显示等待对话框。  If it is followed by **n** or **no**: force the display waiting dialog is displayed while performing operations. 如果后跟**n**或**no**：force，则在执行操作时显示等待对话框。 |
| */secureDesktop*                            | If it is followed by **y** or **yes** or if no parameter is specified: display password dialog and token PIN  dialog in a dedicated secure desktop to protect against certain types of attacks. 如果后跟**y**或**yes**或未指定参数：在专用安全桌面中显示密码对话框和令牌PIN对话框，以防止某些类型的攻击。  If it is followed by **n** or **no**: the password dialog and token PIN dialog are displayed in the normal desktop. 如果后跟**n**或**no**：密码对话框和令牌PIN对话框将显示在正常桌面中。 |
| */tokenlib*                                 | It must be followed by a parameter indicating the PKCS #11 library to use  for security tokens and smart cards. (e.g.: /tokenlib c:\pkcs11lib.dll) 它必须后跟一个参数，指示用于安全令牌和智能卡的PKCS #11库。(e.g.: /tokenlib c：\pkcs11lib.dll） |
| */tokenpin*                                 | It must be followed by a parameter indicating the PIN to use in order to  authenticate to the security token or smart card (e.g.: /tokenpin 0000). Warning: This method of entering a smart card PIN may be insecure, for  example, when an unencrypted command prompt history log is being saved to unencrypted disk. 它后面必须有一个参数，指示要使用的PIN，以便对安全令牌或智能卡进行身份验证（例如：/tokenpin 0000）。警告：这种输入智能卡PIN的方法可能不安全，例如，当将未加密的命令提示符历史记录保存到未加密的磁盘时。 |
| */cache* or */c* */cache*或*/c*             | If it is followed by **y** or **yes** or if no parameter is specified: enable password cache;  如果后跟**y**或**yes**或者没有指定参数：启用密码缓存;  If it is followed by **p** or **pim**: enable both password and PIM cache (e.g., /c p). 如果后面跟有**p**或**pim**：启用密码和PIM缓存（例如，/c p）。  If it is followed by **n** or **no**: disable password cache (e.g., /c n). 如果后跟**n**或**no**：禁用密码缓存（例如，/c n）。  If it is followed by **f** or **favorites**: temporary cache password when mounting multiple favorites (e.g., /c f). 如果后面跟有**f**或**favorites**：挂载多个收藏夹时的临时缓存密码（例如，/c f）。  Note that turning the password cache off will not clear it (use /w to clear the password cache). 请注意，关闭密码缓存不会将其清除（使用/w清除密码缓存）。 |
| */history* or */h* */history*或*/h*         | If it is followed by **y** or no parameter: enables saving history of mounted volumes; if it is followed by **n**: disables saving history of mounted volumes (e.g., /h n). 如果后跟**y**或no参数：启用保存已装载卷的历史记录;如果后跟 **N**：禁止保存已安装卷的历史（例如，/h n）。 |
| */wipecache* or */w* */wipecache*或*/w*     | Wipes any passwords cached in the driver memory. 擦除缓存在驱动程序内存中的所有密码。 |
| */password* or */p* */password*或*/p*       | It must be followed by a parameter indicating the volume password. If the  password contains spaces, it must be enclosed in quotation marks (e.g.,  /p ”My Password”). Use /p ”” to specify an empty password. *Warning: This method of entering a volume password may be insecure, for example, when an unencrypted command prompt history log is being saved to  unencrypted disk.* 它必须后跟一个指示卷密码的参数。如果密码包含空格，则必须用引号引起来（例如，/p“我的密码”）。使用/p“”指定空密码。 *警告：这种输入卷密码的方法可能不安全，例如，当将未加密的命令提示符历史记录保存到未加密的磁盘时。* |
| */pim*                                      | It must be followed by a positive integer indicating the PIM (Personal Iterations Multiplier) to use for the volume. 它后面必须跟一个正整数，表示要用于卷的PIM（个人迭代乘法器）。 |
| */quit* or */q* */quit*或*/q*               | Automatically perform requested actions and exit (main VeraCrypt window will not be  displayed). If preferences is specified as the parameter (e.g., /q  preferences), then program settings are loaded/saved and they override  settings specified on the command line. /q background launches the VeraCrypt Background Task (tray icon)  unless it is disabled in the Preferences. 自动执行请求的操作并退出（VeraCrypt主窗口将不显示）。如果将偏好指定为参数（例如，/q首选项），然后加载/保存程序设置，并且它们会覆盖命令行上指定的设置。/q background启动VeraCrypt后台任务（托盘图标），除非在首选项中被禁用。 |
| */silent* or */s* */silent*或*/s*           | If /q is specified, suppresses interaction with the user (prompts, error  messages, warnings, etc.). If /q is not specified, this option has no  effect. 如果指定了/q，则禁止与用户的交互（提示、错误消息、警告等）。如果未指定/q，则此选项无效。 |
| */mountoption* or */m* */mountoption*或*/m* | It must be followed by a parameter which can have one of the values indicated below. 它必须后跟一个参数，该参数可以具有以下所示的值之一。 **ro** or **readonly**: Mount volume as read-only. **ro**或**readonly**：将卷装载为只读。 **rm** or **removable**: Mount volume as removable medium (see section [ *Volume Mounted as Removable Medium*](https://veracrypt.fr/en/Removable Medium Volume.html)). **rm**或**可移动**：将卷装载为可移动介质（请参见 [*卷装为中号*](https://veracrypt.fr/en/Removable Medium Volume.html)）。 **ts** or **timestamp**: Do not preserve container modification timestamp. **ts**或**时间戳**：不保留容器修改时间戳。 **sm** or **system**: Without pre-boot authentication, mount a partition that is within the  key scope of system encryption (for example, a partition located on the  encrypted system drive of another operating system that is not running). Useful e.g. for backup or repair operations. Note: If you supply a  password as a parameter of /p, make sure that the password has been  typed using the standard US keyboard layout (in contrast, the GUI  ensures this automatically). This is required due to the fact that the password needs to be typed in the pre-boot environment  (before Windows starts) where non-US Windows keyboard layouts are not  available. **sm**或**system**：在没有预引导身份验证的情况下，挂载系统加密密钥范围内的分区（例如，位于另一个未运行的操作系统的加密系统驱动器上的分区）。例如，用于备份或修复操作。注意事项：如果您将密码作为/p的参数提供，请确保已使用标准US键盘布局键入密码（相反，GUI会自动确保这一点）。这是必需的，因为密码需要在预引导环境（Windows启动之前）中键入，而非美国Windows键盘布局不可用。 **bk** or **headerbak**: Mount volume using embedded backup header. Note: All volumes created by VeraCrypt contain an embedded backup header (located at the end of the  volume). **bk**或**headerbak**：使用嵌入的备份头装载卷。注意：VeraCrypt创建的所有加密卷都包含一个内嵌的备份头（位于卷的末尾）。 **recovery**: Do not verify any checksums stored in the volume header. This option  should be used only when the volume header is damaged and the volume  cannot be mounted even with the mount option headerbak. Example: /m ro **recovery**：不验证存储在卷头中的任何校验和。仅当卷头损坏并且即使使用挂载选项headerbak也无法挂载卷时，才应使用此选项。示例：/m ro **label=LabelValue**: Use the given string value **LabelValue** as a label of the mounted volume in Windows Explorer. The maximum length for **LabelValue** is 32 characters for NTFS volumes and 11 characters for FAT volumes. For example, */m label=MyDrive* will set the label of the drive in Explorer to *MyDrive*. **label=LabelValue**：使用给定的字符串值**LabelValue**作为Windows资源管理器中已装入卷的标签。的最大长度 **LabelValue** 对于NTFS卷为32个字符，对于FAT卷为11个字符。比如说， */m label=MyDrive*将在资源管理器中将驱动器的标签设置为*MyDrive*。 **noattach**: Only create virtual device without actually attaching the mounted volume to the selected drive letter. **noattach**：仅创建虚拟设备，而不实际将挂载的卷附加到选定的驱动器号。 Please note that this switch may be present several times in the command line  in order to specify multiple mount options (e.g.: /m rm /m ts) 请注意，此开关可能会在命令行中出现多次，以便指定多个挂载选项（例如：/m rm /m ts） |
| */DisableDeviceUpdate*                      | Disables periodic internel check on devices connected to the system that is used for handling favorites identified with VolumeID and replace it with  on-demande checks. 对连接到系统的设备禁用定期内部检查，该系统用于处理使用VolumeID标识的收藏夹，并将其替换为按需检查。 |
| */protectMemory*                            | Activates a mechanism that protects VeraCrypt process memory from being accessed by other non-admin processes. 激活一种机制，保护VeraCrypt进程内存不被其他非管理进程访问。 |
| */signalExit*                               | It must be followed by a parameter specifying the name of the signal to send to unblock a waiting [WAITFOR.EXE](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/waitfor) command when VeraCrypt exists. 它后面必须跟一个参数，指定当VeraCrypt存在时要发送的信号的名称，以解除等待[WAITFOR.EXE](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/waitfor)命令的阻塞。  The name of signal must be the same as the one specified to WAITFOR.EXE  command (e.g."veracrypt.exe /q /v test.hc /l Z /signal SigName" followed by "waitfor.exe SigName" 信号的名称必须与WAITFOR.EXE命令中指定的名称相同（例如：“veracrypt. exe/q /v test.hc /l Z /signal SignName”后跟“waitfor.exe SignName”  This switch is ignored if /q is not specified 如果未指定/q，则忽略此开关 |

#### VeraCrypt Format.exe (VeraCrypt Volume Creation Wizard): VeraCrypt加密卷创建向导（VeraCrypt Volume Creation Wizard）：

| /create                                   | Create a container based volume in command line mode. It must be followed by the file name of the container to be created. 在命令行模式下创建基于容器的卷。它后面必须跟有要创建的容器的文件名。 |
| ----------------------------------------- | ------------------------------------------------------------ |
| /size                                     | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the size of the container  file that will be created. This parameter is a number indicating the  size in Bytes. It can have a suffixe 'K', 'M', 'G' or 'T' to indicate  that the value is in Kilobytes, Megabytes, Gigabytes or Terabytes respectively. For example: 它必须后跟一个参数，指示将创建的容器文件的大小。此参数是一个数字，表示大小（单位：mm）。它可以有一个后缀'K'，'M'，'G'或'T'，以表明该值是在千字节，兆字节，千字节 或TB。举例来说： /size 5000000: the container size will be 5000000 bytes  /size 5000000：容器大小为5000000字节/size 25K: the container size will be 25 KiloBytes.  /size 25 K：容器大小为25 Kilocum。/size 100M: the container size will be 100 MegaBytes.  /size 100 M：容器大小为100 MegaBase。/size 2G: the container size will be 2 GigaBytes.  /size 2G：容器大小为2 GigaBytes。/size 1T: the container size will be 1 TeraBytes.  /size 1 T：容器大小为1 Tera。 |
| /password                                 | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the password of the container that will be created. 它必须后跟一个参数，指示将创建的容器的密码。 |
| /keyfile or /k /keyfile或/k               | (Only with /create) (Only创建/Create）  It must be followed by a parameter specifying a keyfile or a keyfile  search path. For multiple keyfiles, specify e.g.: /k c:\keyfile1.dat /k  d:\KeyfileFolder /k c:\kf2 To specify a keyfile stored on a security  token or smart card, use the following syntax: token://slot/SLOT_NUMBER/file/FILE_NAME 它后面必须跟一个参数，指定一个密钥文件或密钥文件搜索路径。对于多个密钥文件，请指定例如：/k c：\keyfile1.dat/k d：\KeyfileFolder /k c：\kf2若要指定存储在安全令牌或智能卡上的密钥文件，请使用以下语法： token://slot/SLOT_NUMBER/file/FILE_NAME |
| */tokenlib*                               | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the PKCS #11 library to  use for security tokens and smart cards. (e.g.: /tokenlib  c:\pkcs11lib.dll) 它必须后跟一个参数，指示用于安全令牌和智能卡的PKCS #11库。(e.g.: /tokenlib c：\pkcs11lib.dll） |
| */tokenpin*                               | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the PIN to use in order to authenticate to the security token or smart card (e.g.: /tokenpin  0000). Warning: This method of entering a smart card PIN may be  insecure, for example, when an unencrypted command prompt history log is being saved to unencrypted disk. 它后面必须有一个参数，指示要使用的PIN，以便对安全令牌或智能卡进行身份验证（例如：/tokenpin 0000）。警告：这种输入智能卡PIN的方法可能不安全，例如，当未加密的命令 提示历史记录正在保存到未加密的磁盘。 |
| */hash*                                   | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the PRF hash algorithm to  use when creating the volume. It has the same syntax as VeraCrypt.exe. 它后面必须跟一个参数，指示创建卷时要使用的PRF哈希算法。它的语法与VeraCrypt.exe相同。 |
| /encryption                               | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the encryption algorithm  to use. The default is AES if this switch is not specified. The  parameter can have the following values (case insensitive):  它必须后跟一个指示要使用的加密算法的参数。如果未指定此开关，则默认值为AES。该参数可以具有以下值（不区分大小写）： AES Serpent  蛇Twofish Camellia  山茶Kuznyechik  库兹涅奇克AES(Twofish)  AES（Twofish）AES(Twofish(Serpent))  AES（Twofish（Serpent））Serpent(AES)  蛇（AES）Serpent(Twofish(AES))  蛇（Twofish（AES））Twofish(Serpent)  蛇（Serpent） Camellia(Kuznyechik)  山茶属（Kuznyechik） Kuznyechik(Twofish)  Kuznyechik（Twofish） Camellia(Serpent)  山茶花（蛇） Kuznyechik(AES)  库兹涅奇克（AES） Kuznyechik(Serpent(Camellia))  Kuznyechik（蛇（山茶）） |
| /filesystem                               | (Only with /create) (Only创建/Create）  It must be followed by a parameter indicating the file system to use for the volume. The parameter can have the following values:  它后面必须跟一个参数，指示要用于卷的文件系统。该参数可以具有以下值： None: don't use any filesystem  无：不使用任何文件系统FAT: format using FAT/FAT32  FAT：使用FAT/FAT32格式NTFS: format using NTFS. Please note that in this case a UAC prompt will be  displayed unless the process is run with full administrative privileges.  ：使用请注意，在这种情况下，将显示UAC提示，除非该进程以完全管理权限运行。 ExFAT: format using ExFAT. This switch is available starting from Windows Vista SP1  ExFAT：使用ExFAT格式化。此开关从Windows Vista SP1开始提供 ReFS: format using ReFS. This switch is available starting from Windows 10  ReFS：使用ReFS格式化。此开关从Windows 10开始可用 |
| /dynamic                                  | (Only with /create) (Only创建/Create）  It has no parameters and it indicates that the volume will be created as a dynamic volume. 它没有参数，并且表示将作为动态卷创建卷。 |
| /force                                    | (Only with /create) (Only创建/Create）  It has no parameters and it indicates that overwrite will be forced without requiring user confirmation. 它没有参数，并且表示将在不需要用户确认的情况下强制覆盖。 |
| /silent                                   | (Only with /create) (Only创建/Create）  It has no parameters and it indicates that no message box or dialog will be displayed to the user. If there is any error, the operation will  fail silently. 它没有参数，并且表示不会向用户显示任何消息框或对话框。如果有任何错误，操作将默默失败。 |
| */noisocheck* or */n* */noisocheck*或*/n* | Do not verify that VeraCrypt Rescue Disks are correctly burned. **WARNING**: Never attempt to use this option to facilitate the reuse of a  previously created VeraCrypt Rescue Disk. Note that every time you  encrypt a system partition/drive, you must create a new VeraCrypt Rescue Disk even if you use the same  password. A previously created VeraCrypt Rescue Disk cannot be reused as it was created for a different master key. 不要验证VeraCrypt Rescue加密货币是否正确烧录。**警告**：不要尝试使用此选项来重复使用之前创建的VeraCrypt救援盘。请注意，每次加密系统分区/驱动器时，即使使用相同的密码，也必须创建一个新的VeraCrypt救援盘。以前创建的VeraCrypt救援盘不能重复使用，因为它是为不同的主密钥创建的。 |
| /nosizecheck                              | Don't check that the given size of the file container is smaller than the  available disk free. This applies to both UI and command line. 不要检查给定的文件容器大小是否小于可用磁盘空间。这适用于UI和命令行。 |
| /quick                                    | Perform quick formatting of volumes instead of full formatting. This applies to both UI and command line. 执行卷的快速格式化，而不是完全格式化。这适用于UI和命令行。 |
| /FastCreateFile                           | Enables a faster, albeit potentially insecure, method for creating file  containers. This option carries security risks as it can embed existing  disk content into the file container, possibly exposing sensitive data  if an attacker gains access to it. Note that this switch affects all  file container creation methods, whether initiated from the command  line, using the /create switch, or through the UI wizard. 启用一种更快的创建文件容器的方法，尽管这种方法可能不安全。此选项存在安全风险，因为它可以将现有磁盘内容嵌入到文件容器中，如果攻击者获得访问权限，可能会暴露敏感数据。请注意，此开关会影响所有文件容器创建方法，无论是从命令行启动、使用/Create开关还是通过UI向导。 |
| */protectMemory*                          | Activates a mechanism that protects VeraCrypt Format process memory from being accessed by other non-admin processes. 激活一种机制，保护VeraCrypt Format进程内存不被其他非管理进程访问。 |
| */secureDesktop*                          | If it is followed by **y** or **yes** or if no parameter is specified: display password dialog and token PIN  dialog in a dedicated secure desktop to protect against certain types of attacks. 如果后跟**y**或**yes**或未指定参数：在专用安全桌面中显示密码对话框和令牌PIN对话框，以防止某些类型的攻击。  If it is followed by **n** or **no**: the password dialog and token PIN dialog are displayed in the normal desktop. 如果后跟**n**或**no**：密码对话框和令牌PIN对话框将显示在正常桌面中。 |

#### Syntax 语法

VeraCrypt.exe [/tc] [/hash {sha256|sha-256|sha512|sha-512|whirlpool  |blake2s|blake2s-256}][/a [devices|favorites]] [/b] [/c [y|n|f]] [/d  [drive letter]] [/e] [/f] [/h [y|n]] [/k keyfile or search path]  [tryemptypass [y|n]] [/l drive letter] [/m  {bk|rm|recovery|ro|sm|ts|noattach}] [/p password] [/pim pimvalue] [/q [background|preferences]] [/s]  [/tokenlib path] [/v volume] [/w]
VeraCrypt.exe [/tc] [/hash {sha256| Sha-256| sha512| Sha-512|漩涡|blake2s| blake  2s-256}][/a [设备|收藏夹]] [/B] [/c [y| n| [/d [驱动器号]] [/e] [/f] [/h [y| n]]  [/k密钥文件或搜索路径] [tryemptypass [y| [/l驱动器号] [/m {bk| RM|恢复|ro| SM| ts|  noattach}] [/p password] [/pim pimvalue] [/q [background| preferences]]  [/s] [/tokenlib path] [/v volume] [/w]

"VeraCrypt Format.exe" [/n] [/create] [/size number[{K|M|G|T}]] [/p password]  [/encryption {AES | Serpent | Twofish | Camellia | Kuznyechik |  AES(Twofish) | AES(Twofish(Serpent)) | Serpent(AES) |  Serpent(Twofish(AES)) | Twofish(Serpent) | Camellia(Kuznyechik) |  Kuznyechik(Twofish) | Camellia(Serpent) | Kuznyechik(AES) |  Kuznyechik(Serpent(Camellia))}] [/hash  {sha256|sha-256|sha512|sha-512|whirlpool|blake2s|blake2s-256}] [/filesystem {None|FAT|NTFS|ExFAT|ReFS}] [/dynamic] [/force] [/silent]  [/noisocheck] [FastCreateFile] [/quick]
“VeraCrypt Crypt.exe”[/n] [/create] [/size number[{K| M| G| T}]] [/p密码]  [/加密{AES|蛇|Twofish|山茶|库兹涅奇克|AES（Twofish）|AES（Twofish（Serpent））|蛇（AES）|蛇（Twofish（AES））|蛇（Serpent）|山茶属（Kuznyechik）|库兹涅奇克（两鱼）|山茶花（蛇）|库兹涅奇克（AES）|Kuznyechik（Serpent（Camellia））}] [/hash {sha256| Sha-256| sha512| Sha-512|漩涡|blake2s| blake 2s-256}]  [/filesystem {无|脂肪|NTFS| exFAT| ReFS}] [/dynamic] [/force] [/silent]  [/noisocheck] [FastData File] [/quick]

Note that the order in which options are specified does not matter.
请注意，指定选项的顺序无关紧要。

#### Examples 示例

Mount the volume *d:\myvolume* as the first free drive letter, using the password prompt (the main program window will not be displayed):
使用密码提示符将卷*d：\myvolume*挂载为第一个可用驱动器号（主程序窗口将不显示）：

veracrypt /q /v d:\myvolume
veracrypt /q /v d：\myvolume

Dismount a volume mounted as the drive letter *X* (the main program window will not be displayed):
卸载作为驱动器号*X*装载的卷（将不显示主程序窗口）：

veracrypt /q /d x

Mount a volume called *myvolume.tc* using the password *MyPassword*, as the drive letter *X*. VeraCrypt will open an explorer window and beep; mounting will be automatic:
使用密码*MyPassword*作为驱动器号装载名为*myvolume.tc*的卷 *X*. VeraCrypt将打开一个浏览器窗口并发出哔哔声;挂载将自动进行：

veracrypt /v myvolume.tc /l x /a /p MyPassword /e /b
veracrypt /v myvolume.tc x /a /p MyPassword /e /B

Create a 10 MB file container using the password *test* and formatted using FAT:
使用密码*测试*创建一个10 MB的文件容器，并使用FAT进行格式化：

```
"C:\Program Files\VeraCrypt\VeraCrypt Format.exe" /create c:\Data\test.hc /password test /hash sha512 /encryption serpent /filesystem FAT /size 10M /force
```

# Security Model 安全模型

#### Note to security researchers: If you intend to report a security issue or  publish an attack on VeraCrypt, please make sure it does not disregard  the security model of VeraCrypt described below. If it does, the attack  (or security issue report) will be considered invalid/bogus. 安全研究人员注意：如果您打算报告安全问题或发布对VeraCrypt的攻击，请确保它没有忽略下面描述的VeraCrypt的安全模型。如果是，攻击（或安全问题报告）将被视为无效/伪造。

VeraCrypt is a computer software program whose primary purposes are to:
VeraCrypt是一个计算机软件程序，其主要目的是：

- Secure data by encrypting it before it is written to a disk. 
  通过在将数据写入磁盘之前对其进行加密来保护数据。
- Decrypt encrypted data after it is read from the disk. 
  从磁盘读取加密数据后对其进行解密。

VeraCrypt does **not**:
VeraCrypt**不会**：

- Encrypt or secure any portion of RAM (the main memory of a computer). 
  加密或保护RAM（计算机的主存储器）的任何部分。
- Secure any data on a computer* if an attacker has administrator privileges† under an operating system installed on the computer. 
  保护计算机上的任何数据 * 如果攻击者在计算机上安装的操作系统下具有管理员权限。
- Secure any data on a computer if the computer contains any malware (e.g. a  virus, Trojan horse, spyware) or any other piece of software (including  VeraCrypt or an operating system component) that has been altered,  created, or can be controlled, by an attacker. 
  保护计算机上的任何数据，如果计算机包含任何恶意软件（例如病毒、特洛伊木马、间谍软件）或任何其他软件（包括VeraCrypt或操作系统组件），这些软件已被攻击者更改、创建或控制。
- Secure any data on a computer if an attacker has physical access to the computer before or while VeraCrypt is running on it. 
  如果攻击者在VeraCrypt运行之前或运行期间对计算机进行物理访问，则保护计算机上的任何数据。
- Secure any data on a computer if an attacker has physical access to the  computer between the time when VeraCrypt is shut down and the time when  the entire contents of all volatile memory modules connected to the  computer (including memory modules in peripheral devices) have been permanently and irreversibly erased/lost. 
  如果攻击者在VeraCrypt关闭后至连接到计算机的所有易失性内存模块（包括外围设备中的内存模块）的全部内容被永久且不可逆地擦除/丢失之间，对计算机进行物理访问，则保护计算机上的任何数据。
- Secure any data on a computer if an attacker can remotely intercept emanations from the computer hardware (e.g. the monitor or cables) while VeraCrypt is running on it (or otherwise remotely monitor the hardware and its  use, directly or indirectly, while VeraCrypt is running on it). 
  当VeraCrypt在计算机上运行时，如果攻击者可以远程拦截计算机硬件（例如监视器或电缆）的辐射（或在VeraCrypt运行时，直接或间接地远程监视硬件及其使用），则保护计算机上的任何数据。
- Secure any data stored in a VeraCrypt volume‡ if an attacker without  administrator privileges can access the contents of the mounted volume  (e.g. if file/folder/volume permissions do not prevent such an attacker  from accessing it). 
  如果没有管理员权限的攻击者可以访问安装的卷的内容（例如，如果文件/文件夹/卷权限不能阻止攻击者访问它），则保护存储在VeraCrypt卷加密器中的任何数据。
- Preserve/verify the integrity or authenticity of encrypted or decrypted data. 
  保护/验证加密或解密数据的完整性或真实性。
- Prevent traffic analysis when encrypted data is transmitted over a network. 
  在通过网络传输加密数据时阻止流量分析。
- Prevent an attacker from determining in which sectors of the volume the content changed (and when and how many times) if he or she can observe the  volume (dismounted or mounted) before and after data is written to it,  or if the storage medium/device allows the attacker to determine such information (for example, the volume  resides on a device that saves metadata that can be used to determine  when data was written to a particular sector). 
  防止攻击者确定内容在卷的哪些扇区中发生了更改（以及何时和多少次）如果他或她能观察到音量在数据写入之前和之后，或者如果存储介质/设备允许攻击者确定此类信息，（例如，卷驻留在保存元数据的设备上，元数据可用于确定数据何时写入特定扇区）。
- Encrypt any existing unencrypted data in place (or re-encrypt or erase data) on devices/filesystems that use wear-leveling or otherwise relocate data  internally. 
  在使用损耗均衡或以其他方式在内部重新定位数据的设备/文件系统上，对任何现有的未加密数据进行加密（或重新加密或擦除数据）。
- Ensure that users choose cryptographically strong passwords or keyfiles. 
  确保用户选择加密强度高的密码或密钥文件。
- Secure any computer hardware component or a whole computer. 
  保护任何计算机硬件组件或整个计算机。
- Secure any data on a computer where the security requirements or precautions listed in the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html) are not followed. 
  保护计算机上的任何数据， 未遵守[*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)。
- Do anything listed in the section [ Limitations ](https://veracrypt.fr/en/Issues and Limitations.html#limitations)(chapter [ Known Issues & Limitations](https://veracrypt.fr/en/Issues and Limitations.html)). 
  执行限制部分（[已知问题限制一](https://veracrypt.fr/en/Issues and Limitations.html)章）中列出的任何操作。

Under **Windows**, a user without administrator privileges can (assuming the default VeraCrypt and operating system configurations):
在**Windows**下，没有管理员权限的用户可以（假设是默认的VeraCrypt和操作系统配置）：

- Mount any file-hosted VeraCrypt volume provided that the file permissions of the container allow it. 
  挂载任何文件托管的VeraCrypt加密卷，前提是容器的文件权限允许。
- Mount any partition/device-hosted VeraCrypt volume. 
  挂载任何分区/设备托管的VeraCrypt加密卷。
- Complete the pre-boot authentication process and, thus, gain access to data on  an encrypted system partition/drive (and start the encrypted operating  system). 
  完成预引导身份验证过程，从而获得对加密系统分区/驱动器上数据的访问权限（并启动加密操作系统）。
- Skip the pre-boot authentication process (this can be prevented by disabling the option *Settings* > ‘*System Encryption*’ > ‘*Allow pre-boot authentication to be bypassed by pressing the Esc key*’; note that this option can be enabled or disabled only by an administrator). 
  跳过预引导身份验证过程（这可以通过禁用选项来防止 *设置*>“*系统加密*”>“*允许通过按ESC键绕过预引导身份验证*”;请注意，此选项只能由管理员启用或禁用）。
- Dismount, using VeraCrypt, (and, in the VeraCrypt application window, see the  path to and properties of) any VeraCrypt volume mounted by him or her.  However, this does not apply to ‘system favorite volumes’, which he or  she can dismount (etc.) regardless of who mounted them (this can be prevented by enabling the  option  *Settings* > ‘*System Favorite Volumes*’ > ‘*Allow* only administrators to view and dismount system favorite volumes in  VeraCrypt’; note that this option can be enabled or disabled only by an  administrator). 
  使用VeraCrypt卸载他/她挂载的任何VeraCrypt加密卷（在VeraCrypt应用程序窗口中查看其路径和属性）。但是，这不适用于“系统收藏夹加密卷”，他/她可以删除（等等）。无论是谁安装的（这可以通过启用选项*设置*> '*系统收藏夹删除*' > '仅*允许*管理员在VeraCrypt中查看和删除系统收藏夹卷'来防止;注意，此选项只能由管理员启用或禁用）。
- Create a file-hosted VeraCrypt volume containing a FAT or no file system  (provided that the relevant folder permissions allow it). 
  创建一个包含FAT或不包含文件系统的文件托管VeraCrypt卷（前提是相关文件夹权限允许）。
- Change the password, keyfiles, and header key derivation algorithm for, and  restore or back up the header of, a file-hosted VeraCrypt volume  (provided that the file permissions allow it). 
  更改VeraCrypt卷的密码、密钥文件和头密钥导出算法，并恢复或备份文件托管的VeraCrypt卷的头（前提是文件权限允许）。
- Access the filesystem residing within a VeraCrypt volume mounted by another  user on the system (however, file/folder/volume permissions can be set  to prevent this). 
  访问系统上其他用户挂载的VeraCrypt加密卷中的文件系统（但是，可以设置文件/文件夹/加密卷权限来防止这种情况）。
- Use passwords (and processed keyfiles) stored in the password cache (note  that caching can be disabled; for more information see the section *Settings -> Preferences*, subsection *Cache passwords in* driver memory). 
  使用存储在密码缓存中的密码（和已处理的密钥文件）（请注意，可以禁用缓存;有关详细信息，请参阅 *设置->首选项*，子部分*在驱动程序内存中缓存密码*）。
- View the basic properties (e.g. the size of the encrypted area, encryption  and hash algorithms used, etc.) of the encrypted system partition/drive  when the encrypted system is running. 
  查看基本属性（例如加密区域的大小、使用的加密和哈希算法等）当加密的系统运行时，加密的系统分区/驱动器。
- Run and use the VeraCrypt application (including the VeraCrypt Volume  Creation Wizard) provided that the VeraCrypt device driver is running  and that the file permissions allow it. 
  运行并使用VeraCrypt应用程序（包括VeraCrypt加密卷创建向导），前提是VeraCrypt设备驱动程序正在运行并且文件权限允许。

Under **Linux**, a user without administrator privileges can (assuming the default VeraCrypt and operating system configurations):
在**Linux**下，没有管理员权限的用户可以（假设默认的VeraCrypt和操作系统配置）：

- Create a file-hosted or partition/device-hosted VeraCrypt volume containing a  FAT or no file system provided that the relevant folder/device  permissions allow it. 
  创建一个包含FAT或不包含文件系统的文件托管或分区/设备托管的VeraCrypt卷，前提是相关文件夹/设备权限允许。
- Change the password, keyfiles, and header key derivation algorithm for, and  restore or back up the header of, a file-hosted or  partition/device-hosted VeraCrypt volume provided that the file/device  permissions allow it. 
  在文件/设备权限允许的情况下，更改文件托管或分区/设备托管的VeraCrypt加密卷的密码、密钥文件和头密钥推导算法，并恢复或备份其头。
- Access the filesystem residing within a VeraCrypt volume mounted by another  user on the system (however, file/folder/volume permissions can be set  to prevent this). 
  访问系统上其他用户挂载的VeraCrypt加密卷中的文件系统（但是，可以设置文件/文件夹/加密卷权限来防止这种情况）。
- Run and use the VeraCrypt application (including the VeraCrypt Volume Creation Wizard) provided that file permissions allow it. 
  运行并使用VeraCrypt应用程序（包括VeraCrypt加密卷创建向导），前提是文件权限允许。
- In the VeraCrypt application window, see the path to and properties of any VeraCrypt volume mounted by him or her. 
  在VeraCrypt应用程序窗口中，查看他或她挂载的任何VeraCrypt加密卷的路径和属性。

Under **Mac OS X**, a user without administrator privileges can (assuming the default VeraCrypt and operating system configurations):
在**Mac OS X**下，没有管理员权限的用户可以（假设默认的VeraCrypt和操作系统配置）：

- Mount any file-hosted or partition/device-hosted VeraCrypt volume provided that the file/device permissions allow it. 
  挂载任何文件托管或分区/设备托管的VeraCrypt加密卷，前提是文件/设备权限允许。
- Dismount, using VeraCrypt, (and, in the VeraCrypt application window, see the  path to and properties of) any VeraCrypt volume mounted by him or her. 
  卸载，使用VeraCrypt，（在VeraCrypt应用程序窗口中，查看其路径和属性）他或她挂载的任何VeraCrypt加密卷。
- Create a file-hosted or partition/device-hosted VeraCrypt volume provided that the relevant folder/device permissions allow it. 
  创建一个文件托管或分区/设备托管的VeraCrypt加密卷，前提是相关的文件夹/设备权限允许。
- Change the password, keyfiles, and header key derivation algorithm for, and  restore or back up the header of, a file-hosted or  partition/device-hosted VeraCrypt volume (provided that the file/device  permissions allow it). 
  更改文件托管或分区/设备托管的VeraCrypt加密卷的密码、密钥文件和头密钥推导算法，并恢复或备份其头（前提是文件/设备权限允许）。
- Access the filesystem residing within a VeraCrypt volume mounted by another  user on the system (however, file/folder/volume permissions can be set  to prevent this). 
  访问系统上其他用户挂载的VeraCrypt加密卷中的文件系统（但是，可以设置文件/文件夹/加密卷权限来防止这种情况）。
- Run and use the VeraCrypt application (including the VeraCrypt Volume  Creation Wizard) provided that the file permissions allow it. 
  运行并使用VeraCrypt应用程序（包括VeraCrypt加密卷创建向导），前提是文件权限允许。

VeraCrypt does not support the set-euid root mode of execution.
VeraCrypt不支持set-euid root模式。

 Additional information and details regarding the security model are contained in the chapter [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html).
有关安全模型的其他信息和详细信息，请参阅 [*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)。

\* In this section (*Security Model*), the phrase “data on a computer” means data on internal and external  storage devices/media (including removable devices and network drives)  connected to the computer.
\* 在本节（*安全模式*）中，短语“计算机上的数据”是指连接到计算机的内部和外部存储设备/介质（包括可移动设备和网络驱动器）上的数据。

† In this section (*Security Model*), the phrase “administrator privileges” does not necessarily refer to a  valid administrator account. It may also refer to an attacker who does  not have a valid administrator account but who is able (for example, due to improper configuration of the system or by  exploiting a vulnerability in the operating system or a third-party  application) to perform any action that only a user with a valid  administrator account is normally allowed to perform (for example, to read or modify an arbitrary part of a drive or the RAM,  etc.)
†在本节（*安全模型*）中，短语“管理员权限”不一定指有效的管理员帐户。它也可以指攻击者没有有效的管理员帐户，但能够（例如，由于系统配置不当或利用操作系统或第三方应用程序中的漏洞）执行通常仅允许具有有效管理员帐户的用户执行的任何操作（例如，读取或修改驱动器或RAM的任意部分等）。

‡ “VeraCrypt volume” also means a VeraCrypt-encrypted system partition/drive (see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)).
“VeraCrypt加密卷”也指VeraCrypt加密的系统分区/驱动器（参见章节 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)）。