# Technical Details

- [Notation](https://veracrypt.fr/en/Notation.html)
- [Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html)
- [Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)
- [Header Key Derivation, Salt, and Iteration Count](https://veracrypt.fr/en/Header Key Derivation.html)
- [Random Number Generator](https://veracrypt.fr/en/Random Number Generator.html)
- [Keyfiles](https://veracrypt.fr/en/Keyfiles.html)
- [PIM](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)
- [VeraCrypt Volume Format Specification](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)
- [Compliance with Standards and Specifications](https://veracrypt.fr/en/Standard Compliance.html)
- [Source Code](https://veracrypt.fr/en/Source Code.html)
- Building VeraCrypt From Source
  - [Windows Build Guide](https://veracrypt.fr/en/CompilingGuidelineWin.html)
  - [Linux Build Guide](https://veracrypt.fr/en/CompilingGuidelineLinux.html)

# Notation 符号

 

| *C*           | Ciphertext block 密文块                                      |
| ------------- | ------------------------------------------------------------ |
| *DK() DK（）* | Decryption algorithm using encryption/decryption key *K* 使用加密/解密密钥*K的*解密算法 |
| *EK() EK（）* | Encryption algorithm using encryption/decryption key *K* 使用加密/解密密钥*K的*加密算法 |
| *H() H（）个* | Hash function 散列函数                                       |
| *i*           | Block index for n-bit blocks; n is context-dependent n位块的块索引; n与上下文相关 |
| *K*           | Cryptographic key 密码密钥                                   |
| *^*           | Bitwise exclusive-OR operation (XOR) 按位异或运算            |
| *⊕*           | Modulo 2n addition, where n is the bit size of the left-most operand and of  the resultant value (e.g., if the left operand is a 1-bit value, and the right operand is a 2-bit value, then: 1 ⊕ 0 = 1; 1 ⊕ 1 = 0; 1 ⊕ 2 = 1; 1 ⊕ 3 = 0; 0 ⊕ 0 = 0; 0 ⊕ 1 = 1; 0 ⊕ 2 = 0; 0 ⊕ 3 = 1) 模2n加法，其中n是最左边的操作数和结果值的位大小（例如，如果左操作数是1位值，右操作数是2位值，则：1 0 = 1; 1 1 = 0; 1 2 = 1; 1 3 = 0; 0 0 = 0; 0 1 = 1; 0 2 = 0; 0 3 = 1） |
| *⊗*           | Modular multiplication of two polynomials over the binary field GF(2) modulo x128+x7+x2+x+1 (GF stands for Galois Field) 二进制域GF（2）上两个多项式的模乘，模为x128+x7+x2+x+1（GF代表伽罗瓦域） |
| *\|\|*        | Concatenation 级联                                           |

 Encryption Scheme 加密方案

When mounting a VeraCrypt volume (assume there are no cached  passwords/keyfiles) or when performing pre-boot authentication, the  following steps are performed:
当安装VeraCrypt卷（假设没有缓存的密码/密钥文件）或执行预启动身份验证时，将执行以下步骤：

1. The first 512 bytes of the volume (i.e., the standard volume header) are  read into RAM, out of which the first 64 bytes are the salt (see [ *VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)). For system encryption (see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)), the last 512 bytes of the first logical drive track are read into RAM  (the VeraCrypt Boot Loader is stored in the first track of the system  drive and/or on the VeraCrypt Rescue Disk). 
   卷的前512个字节（即，标准卷标题）读入RAM，其中前64个字节是盐（请参见 [*VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)）。对于系统加密（请参见 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)），第一个逻辑驱动器磁道的最后512字节被读入RAM（VeraCrypt靴子加载程序存储在系统驱动器的第一个磁道和/或VeraCrypt救援盘上）。

2. Bytes 65536–66047 of the volume are read into RAM (see the section [ *VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)). For system encryption, bytes 65536–66047 of the first partition located behind the active partition* are read (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html)). If there is a hidden volume within this  volume (or within the partition behind the boot partition), we have read its header at this point; otherwise, we have just read random data  (whether or not there is a hidden volume within it has to be determined by attempting to decrypt this data; for more  information see the section [*Hidden Volume*](https://veracrypt.fr/en/Hidden Volume.html)). 
   加密卷的1065536 -66047被读入RAM（参见[*VeraCrypt加密卷格式规范*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)）。对于系统加密，读取位于活动分区 * 后面的第一个分区的65536-66047字节（请参见 [隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)）。如果在这个卷中（或者在靴子分区后面的分区中）有一个隐藏卷，那么我们在这一点上已经读取了它的头;否则，我们只是读取了随机数据（无论其中是否有一个隐藏卷）。 必须通过尝试解密此数据来确定;有关详细信息，请参阅 [*隐藏卷*](https://veracrypt.fr/en/Hidden Volume.html)）。

3. Now VeraCrypt attempts to decrypt the standard volume header read in (1).  All data used and generated in the course of the process of decryption  are kept in RAM (VeraCrypt never saves them to disk). The following  parameters are unknown† and have to be determined through the process of trial and error (i.e., by  testing all possible combinations of the following):

   
   现在VeraCrypt尝试解密（1）中读取的标准卷头。在解密过程中使用和生成的所有数据都保存在RAM中（VeraCrypt从不将它们保存到磁盘）。以下参数是未知的， 将通过试错过程来确定（即，通过测试以下所有可能的组合）：

   1. PRF used by the header key derivation function (as specified in PKCS #5 v2.0; see the section

      *Header Key Derivation, Salt, and Iteration Count*

      ), which can be one of the following:

      
      由头密钥派生函数使用的PRF（如PKCS #5 v2.0中所指定;请参见 [*头密钥推导、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)），其可以是以下之一：

      HMAC-SHA-512, HMAC-SHA-256, HMAC-BLAKE2S-256, HMAC-Whirlpool. If a PRF is explicitly  specified by the user, it will be used directly without trying the other possibilities.
      HMAC-SHA-512、HMAC-SHA-256、HMAC-BLAKE2S-256、HMAC-Whirlpool。如果用户明确指定了一个PRF，它将被直接使用，而不尝试其他可能性。

      A password entered by the user (to which one or more keyfiles may have been applied – see the section [ *Keyfiles*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html)), a PIM value (if specified) and the salt read in (1) are passed to the  header key derivation function, which produces a sequence of values (see the section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)) from which the header encryption key and secondary header key (XTS  mode) are formed. (These keys are used to decrypt the volume header.)
      用户输入的密码（可能已应用了一个或多个密钥文件-请参见 [*密钥文件*](https://veracrypt.fr/en/Keyfiles in VeraCrypt.html)）、PIM值（如果指定）和在（1）中读取的盐被传递给头密钥派生函数，该函数生成一个值序列（请参见 [*头密钥导出、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)），从该头密钥导出头加密密钥和第二头密钥（XTS模式）。（这些密钥用于解密卷标头。）

   2. Encryption algorithm: AES-256, Serpent, Twofish, AES-Serpent, AES-Twofish- Serpent, etc. 
      加密算法：AES-256、Serpent、Twofish、AES-Serpent、AES-Twofish- Serpent等

   3. Mode of operation: only XTS is supported 
      操作模式：仅支持XTS

   4. Key size(s)  密钥大小

4. Decryption is considered successful if the first 4 bytes of the decrypted data  contain the ASCII string “VERA”, and if the CRC-32 checksum of the last  256 bytes of the decrypted data (volume header) matches the value  located at byte #8 of the decrypted data (this value is unknown to an adversary because it is  encrypted – see the section [ *VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)). If these conditions are not met, the process continues from (3) again,  but this time, instead of the data read in (1), the data read in (2) are used (i.e., possible hidden volume header). If the conditions are not met again, mounting is terminated (wrong password, corrupted  volume, or not a VeraCrypt volume). 
   如果解密数据的前4个字节包含ASCII字符串“VERA”，并且如果解密数据（卷报头）的最后256个字节的CRC-32校验和与位于数据的字节#8的值匹配，则认为解密成功。 解密数据（此值对攻击者来说是未知的，因为它是加密的-请参见 [*VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)）。如果不满足这些条件，则过程再次从（3）继续，但是这次，使用（2）中读取的数据而不是（1）中读取的数据（即，可能隐藏的卷头）。如果再次不满足条件，挂载将终止（密码错误，加密卷损坏，或者不是VeraCrypt加密卷）。

5. Now we know (or assume with very high probability) that we have the correct password, the correct encryption algorithm, mode, key size, and the  correct header key derivation algorithm. If we successfully decrypted  the data read in (2), we also know that we are mounting a hidden volume and its size is retrieved from data  read in (2) decrypted in (3). 
   现在我们知道（或假设有很高的概率）我们有正确的密码、正确的加密算法、模式、密钥大小和正确的头密钥推导算法。如果我们成功地解密了（2）中读取的数据，我们也知道我们正在安装一个隐藏卷，并且它的大小是从（3）中解密的（2）中读取的数据中检索的。

6. The encryption routine is reinitialized with the primary master key** and the secondary master key (XTS mode – see the section [*Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html)), which are retrieved from the decrypted volume header (see the section [ *VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)). These keys can be used to decrypt any sector of the volume, except the  volume header area (or the key data area, for system encryption), which  has been encrypted using the header keys. The volume is mounted. 
   加密例程将使用主密钥 ** 和辅助主密钥（XTS模式-请参见 [*操作模式*](https://veracrypt.fr/en/Modes of Operation.html)），从解密的卷标头中检索（请参见 [*VeraCrypt Volume Format Specification*](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)）。这些密钥可用于解密卷的任何扇区，但卷标题区（或用于系统加密的密钥数据区）除外，它已使用标题密钥加密。卷已装入。

See also section [ *Modes of Operation*](https://veracrypt.fr/en/Modes of Operation.html) and section [ *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html) and also the chapter [*Security Model*](https://veracrypt.fr/en/Security Model.html).
另请参见[*操作模式一*](https://veracrypt.fr/en/Modes of Operation.html)节、[*头键派生、盐和迭代计数*](https://veracrypt.fr/en/Header Key Derivation.html)一节以及 [*安全模型*](https://veracrypt.fr/en/Security Model.html)。

\* If the size of the active partition is less than 256 MB, then the data is read from the *second* partition behind the active one (Windows 7 and later, by default, do not boot from the partition on which they are installed).
\* 如果活动分区的大小小于256 MB，则从 活动分区后面*的第二个*分区（默认情况下，Windows 7和更高版本不会从安装它们的分区进行靴子）。

† These parameters are kept secret *not* in order to increase the complexity of an attack, but primarily to make VeraCrypt volumes unidentifiable (indistinguishable from random data),  which would be difficult to achieve if these parameters were stored unencrypted within the volume header. Also note that in the case of legacy MBR boot mode, if a non-cascaded encryption algorithm is used for system encryption, the algorithm *is* known (it can be determined by analyzing the contents of the  unencrypted VeraCrypt Boot Loader stored in the first logical drive  track or on the VeraCrypt Rescue Disk).
†这些参数被保密*并不是*为了增加攻击的复杂性，而是主要为了使VeraCrypt加密卷无法识别（与随机数据无法区分），如果这些参数被加密，这将很难实现。 未加密地存储在卷头中。还要注意，在传统MBR靴子模式的情况下，如果非级联加密算法用于系统加密，则该算法 *是*已知的（可以通过分析存储在第一个逻辑驱动器磁道或VeraCrypt救援盘上的未加密VeraCrypt靴子加载程序的内容来确定）。

** The master keys were generated during the volume creation and cannot be changed later. Volume password change is accomplished by re-encrypting  the volume header using a new header key (derived from a new password).
** 主密钥是在创建卷时生成的，以后无法更改。卷密码更改是通过使用新的头密钥（从新密码派生）重新加密卷头来完成的。

[文档](https://veracrypt.fr/en/Documentation.html) ![>>](https://veracrypt.fr/en/arrow_right.gif) [技术细节](https://veracrypt.fr/en/Technical Details.html) ![>>](https://veracrypt.fr/en/arrow_right.gif) [操作模式](https://veracrypt.fr/en/Modes of Operation.html)

# Modes of Operation 操作模式


 The mode of operation used by VeraCrypt for encrypted partitions, drives, and virtual volumes is XTS. 
VeraCrypt对加密分区、驱动器和虚拟卷使用的操作模式是XTS。
 
 XTS mode is in fact XEX mode [ [12\]](http://www.cs.ucdavis.edu/~rogaway/papers/offsets.pdf), which was designed by Phillip Rogaway in 2003, with a minor  modification (XEX mode uses a single key for two different purposes,  whereas XTS mode uses two independent keys).
XTS模式实际上是XEX模式[[12\]](http://www.cs.ucdavis.edu/~rogaway/papers/offsets.pdf)，由菲利普罗加维在2003年设计，并进行了微小的修改（XEX模式使用一个键用于两个不同的目的，而XTS模式使用两个独立的键）。
 
 In 2010, XTS mode was approved by NIST for protecting the  confidentiality of data on storage devices [24]. In 2007, it was also  approved by the IEEE for cryptographic protection of data on  block-oriented storage devices (IEEE 1619).
2010年，XTS模式被NIST批准用于保护存储设备上数据的机密性[24]。2007年，它还被IEEE批准用于面向块存储设备（IEEE 1619）的数据加密保护。

 

## **Description of XTS mode**: **XTS模式说明**：

*Ci* = *E**K*1(*Pi* ^ (*E**K*2(*n*) ![img](https://veracrypt.fr/en/gf2_mul.gif) *ai*)) ^ (*E**K*2(*n*) ![img](https://veracrypt.fr/en/gf2_mul.gif) *ai*)
C = *E**K*1（P ^（*E**K*2（*n*） ![img](https://veracrypt.fr/en/gf2_mul.gif) a））^（*E**K*2（*n*） ![img](https://veracrypt.fr/en/gf2_mul.gif) a）

Where: 其中：

| ![img](https://veracrypt.fr/en/gf2_mul.gif)                  | denotes multiplication of two polynomials over the binary field GF(2) modulo  *x*128+*x*7+*x*2+*x*+1 表示二进制域GF（2）上的两个多项式的乘法，模为*x*128+*x*7+*x*2+*x*+1 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| *K*1                                                         | is the encryption key (256-bit for each supported cipher; i.e, AES, Serpent, and Twofish) 是加密密钥（256位用于每个支持的密码;即AES，Serpent和Twofish） |
| *K*2                                                         | is the secondary key (256-bit for each supported cipher; i.e, AES, Serpent, and Twofish) 是二级密钥（每个支持的密码都是256位;即AES、Serpent和Twofish） |
| *i*                                                          | is the cipher block index within a data unit;  for the first cipher block within a data unit, *i* = 0 是数据单元内的密码块索引;   对于数据单元内的第一密码块， = 0 |
| *n*                                                          | is the data unit index within the scope of *K*1;  for the first data unit, *n* = 0 是*K1*范围内的数据单元索引;   对于第一数据单元， *n*= 0个 |
| *a*                                                          | is a primitive element of Galois Field (2128) that corresponds to polynomial *x* (i.e., 2) 是伽罗瓦域（2128）的本原元，对应于多项式 *x*（即，（二） |
| Note: The remaining symbols are defined in the section [ Notation](https://veracrypt.fr/en/Notation.html).  注：其余符号的定义见 [记法](https://veracrypt.fr/en/Notation.html)。 |                                                              |


 The size of each data unit is always 512 bytes (regardless of the sector size).
每个数据单元的大小始终为512字节（与扇区大小无关）。

For further information pertaining to XTS mode, see e.g. [ [12\]](http://www.cs.ucdavis.edu/~rogaway/papers/offsets.pdf) and [ [24\]](http://csrc.nist.gov/publications/nistpubs/800-38E/nist-sp-800-38E.pdf).
有关XTS模式的更多信息，请参见例如[[12\]](http://www.cs.ucdavis.edu/~rogaway/papers/offsets.pdf)和[[24\]](http://csrc.nist.gov/publications/nistpubs/800-38E/nist-sp-800-38E.pdf)。

# Header Key Derivation, Salt, and Iteration Count 头键派生、盐和迭代计数

Header key is used to encrypt and decrypt the encrypted area of the VeraCrypt volume header (for [ system encryption](https://veracrypt.fr/en/System Encryption.html), of the keydata area), which contains the master key and other data (see the sections [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) and [ VeraCrypt Volume Format Specification](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)). In volumes created by VeraCrypt (and for [ system encryption](https://veracrypt.fr/en/System Encryption.html)), the area is encrypted in XTS mode (see the section [ Modes of Operation](https://veracrypt.fr/en/Modes of Operation.html)). The method that VeraCrypt uses to generate the  header key and the secondary header key (XTS mode) is PBKDF2, specified  in PKCS #5 v2.0; see [ [7\]](https://veracrypt.fr/en/References.html).
头密钥用于加密和解密VeraCrypt卷头的加密区域（对于 keydata区域的[系统加密](https://veracrypt.fr/en/System Encryption.html)），其中包含主密钥和其他数据（请参见 [加密方案](https://veracrypt.fr/en/Encryption Scheme.html)和[VeraCrypt卷格式规范](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)）。在VeraCrypt创建的加密卷中（以及 [系统加密](https://veracrypt.fr/en/System Encryption.html)），则该区域以XTS模式加密（请参阅[操作模式](https://veracrypt.fr/en/Modes of Operation.html)部分）。VeraCrypt用来生成头密钥和第二头密钥（XTS模式）的方法是PBKDF 2，在PKCS #5 v2.0中指定;参见 [[7\]的](https://veracrypt.fr/en/References.html)第14段。

512-bit salt is used, which means there are 2512 keys for each password. This significantly decreases vulnerability to  'off-line' dictionary/'rainbow table' attacks (pre-computing all the  keys for a dictionary of passwords is very difficult when a salt is used) [7]. The salt  consists of random values generated by the [ VeraCrypt random number generator](https://veracrypt.fr/en/Random Number Generator.html) during the volume creation  process. The header key derivation function is based on HMAC-SHA-512,  HMAC-SHA-256, HMAC-BLAKE2S-256, HMAC-Whirlpool or HMAC-Streebog (see [8, 9, 20, 22]) – the user selects which. The length of the derived key does not depend on the size of the output of the underlying hash  function. For example, a header key for the AES-256 cipher is always 256 bits long even if HMAC-SHA-512 is used (in XTS mode, an additional  256-bit secondary header key is used; hence, two 256-bit keys are used for AES-256 in total). For more information,  refer to [7]. A large number of iterations of the key derivation  function have to be performed to derive a header key, which increases  the time necessary to perform an exhaustive search for passwords (i.e., brute force attack) [7].
512-使用比特盐，这意味着每个密码有2512个密钥。这大大降低了对“离线”字典/“彩虹表”攻击的脆弱性（预先计算字典的所有键 当使用盐时，密码是非常困难的）[7]。盐由随机值组成，这些随机值由 [VeraCrypt在](https://veracrypt.fr/en/Random Number Generator.html)加密卷创建过程中的随机数生成器。头密钥推导函数基于HMAC-SHA-512、HMAC-SHA-256、HMAC-BLAKE  2S-256、HMAC-Whirlpool或HMAC-Streebog（参见[8，9，20，22]）-用户选择。派生键的长度不取决于底层哈希函数输出的大小。例如，即使使用HMAC-SHA-512，AES-256密码的头密钥也总是256位长（在XTS模式下，使用额外的256位辅助头密钥;因此，AES-256总共使用两个256位密钥）。有关更多信息，请参阅[7]。必须执行密钥导出函数的大量迭代以导出报头密钥，这增加了执行对密码的穷举搜索所需的时间（即，暴力攻击）[7]。

Prior to version 1.12, VeraCrypt always used a fixed number of iterations  That depended only on the volume type and the derivation algorithm used. Starting from version 1.12, the [ PIM ](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)field ([Personal Iterations Multiplier](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)) enables users to have more control over the number of iterations used by the key derivation function.
在1.12版本之前，VeraCrypt总是使用固定的迭代次数，这仅取决于加密卷类型和使用的派生算法。从版本1.12开始，[PIM](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)字段（[个人迭代乘数](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)）使用户能够对密钥派生函数使用的迭代次数进行更多控制。



When a [ PIM ](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)value is not specified or if it is equal to zero, VeraCrypt uses the default values expressed below:
当[PIM](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)值未指定或等于零时，VeraCrypt使用以下默认值：

- For system partition encryption (boot encryption) that uses SHA-256, BLAKE2s-256 or Streebog, **200000** iterations are used.
  对于使用SHA-256、BLAKE 2 -256或Streebog的系统分区加密（靴子加密），使用**200000**次迭代。
- For system encryption that uses SHA-512 or Whirlpool, **500000** iterations are used.
  对于使用SHA-512或Whirlpool的系统加密，使用**500000**次迭代。
- For non-system encryption and file containers, all derivation algorithms will use **500000** iterations. 
  对于非系统加密和文件容器，所有派生算法将使用**500000**次迭代。



When a [ PIM ](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)value is given by the user, the number of iterations of the key derivation function is calculated as follows:
当用户给出[PIM](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM).html)值时，密钥导出函数的迭代次数计算如下：

- For system encryption that doesn't use SHA-512 or Whirlpool: Iterations = **PIM x 2048**
  对于不使用SHA-512或Whirlpool的系统加密：迭代次数=**PIM x 2048**
- For system encryption that uses SHA-512 or Whirlpool: Iterations = **15000 + (PIM x 1000)**
  对于使用SHA-512或Whirlpool的系统加密：迭代次数=**15000 +（PIM x 1000）**
- For non-system encryption and file containers: Iterations = **15000 + (PIM x 1000)**
  对于非系统加密和文件容器：迭代次数=**15000 +（PIM x 1000）**

Header keys used by ciphers in a cascade are mutually independent, even  though they are derived from a single password (to which keyfiles may  have been applied). For example, for the AES-Twofish-Serpent cascade,  the header key derivation function is instructed to derive a 768-bit encryption key from a given password (and, for XTS  mode, in addition, a 768-bit *secondary* header key from the given password). The generated 768-bit header key is then split into three 256-bit keys (for XTS mode, the *secondary* header key is split into three 256-bit keys too, so the cascade  actually uses six 256-bit keys in total), out of which the first key is  used by Serpent, the second key is used by Twofish, and the third by AES (in addition, for XTS mode, the first secondary key is used by Serpent, the second  secondary key is used by Twofish, and the third secondary key by AES).  Hence, even when an adversary has one of the keys, he cannot use it to  derive the other keys, as there is no feasible method to determine the password from which the key was derived (except for brute force attack mounted on a weak password).
级联中的密码使用的头密钥是相互独立的，即使它们是从单个密码（可能已经应用了密钥文件）派生的。例如，对于AES-Twofish-Serpent级联，指示报头密钥导出函数 从给定的密码导出768位加密密钥（对于XTS模式，还需要768位加密密钥）。 来自给定密码的*第二*标头密钥）。然后，生成的768位头密钥被分成三个256位密钥（对于XTS模式， *第一*个密钥由Serpent使用，第二个密钥由Twofish使用，第三个密钥由AES使用（此外，对于XTS模式，第一个二级密钥由Serpent使用，第二个二级密钥由Twofish使用，第三个二级密钥由AES使用）。因此，即使对手拥有其中一个密钥，他也不能使用它来导出其他密钥，因为没有可行的方法来确定导出密钥的密码（除了对弱密码的蛮力攻击）。

# Random Number Generator 随机数生成器

The VeraCrypt random number generator (RNG) is used to generate the master  encryption key, the secondary key (XTS mode), salt, and keyfiles. It  creates a pool of random values in RAM (memory). The pool, which is 320  bytes long, is filled with data from the following sources:
VeraCrypt随机数生成器（RNG）用于生成主加密密钥、辅助密钥（XTS模式）、salt和密钥文件。它在RAM（内存）中创建一个随机值池。该池长320字节，填充有来自以下来源的数据：

- Mouse movements  鼠标移动
- Keystrokes  击键
- *Mac OS X and Linux*: Values generated by the built-in RNG (both */dev/random* and*/dev/urandom*) 
  *Mac OS X和Linux*：由内置RNG生成的值（*/dev/random*和*/dev/urandom*）
- *MS Windows only*: MS Windows CryptoAPI (collected regularly at 500-ms interval) 
  *仅限MS Windows*：MS Windows CryptoAPI（以500 ms的间隔定期收集）
- *MS Windows only*: Network interface statistics (NETAPI32) 
  *仅MS Windows*：网络接口统计（NETAPI 32）
- *MS Windows only*: Various Win32 handles, time variables, and counters (collected regularly at 500-ms interval) 
  *仅限MS Windows*：各种Win32句柄、时间变量和计数器（以500 ms的间隔定期收集）

Before a value obtained from any of the above-mentioned sources is written to  the pool, it is divided into individual bytes (e.g., a 32-bit number is  divided into four bytes). These bytes are then individually written to  the pool with the modulo 28 addition operation (not by replacing the old values in the pool) at the position of the pool cursor. After a byte is written, the pool cursor  position is advanced by one byte. When the cursor reaches the end of the pool, its position is set to the beginning of the pool. After every 16th byte written to the pool, the pool mixing function is automatically applied to the entire pool (see below).
在将从任何上述源获得的值写入池之前，将其划分为单独的字节（例如，32位数被分成四个字节）。然后，这些字节被分别写入到具有模28的池中 添加操作（不是通过替换池中的旧值）。写入一个字节后，池游标位置将前进一个字节。当光标到达池的末尾时，其位置将设置为开始 游泳池的。每将第16个字节写入池后，池混合功能将自动应用于整个池（见下文）。

## Pool Mixing Function 合并液混合功能

The purpose of this function is to perform diffusion [2]. Diffusion spreads the influence of individual “raw” input bits over as much of the pool  state as possible, which also hides statistical relationships. After  every 16th byte written to the pool, this function is applied to the entire pool.
该函数的目的是执行扩散[2]。扩散将单个"原始"输入位的影响尽可能多地传播到池状态，这也隐藏了统计关系。每将第16个字节写入池后，此函数将应用于整个池。

Description of the pool mixing function:
池混合功能说明：

1. Let *R* be the randomness pool. 
   设R为随机池。

2. Let *H* be the hash function selected by the user (SHA-512, BLAKE2S-256, or Whirlpool). 
   设H为用户选择的散列函数（SHA-512、BLAKE2S-256或Whirlpool）。

3. *l* = byte size of the output of the hash function *H* (i.e., if *H* is BLAKE2S-256, then *l* = 20; if *H* is SHA-512, *l* = 64) 
   *l =散列函数H的输出的字节大小（即，*如果 *H是BLAKE2S-256，则l = 20;如果H是SHA-512，则l = 64）*

4. *z* = byte size of the randomness pool *R* (320 bytes) 
   *z =随机池R的字节大小（320字节）*

5. *q* = *z* / *l* – 1 (e.g., if *H* is Whirlpool, then *q* = 4) 
   *q = z/l-1（例如，*如果H是Whirlpool，则 *q = 4）*

6. Ris divided intol-byte blocksB0...Bq.

   
   R是以1字节块划分的B0. Bq.

   For 0 ≤ i ≤ q (i.e., for each block B) the following steps are performed:
   对于0 ≤ i ≤ q（即，对于每个块B），执行以下步骤：

   1. *M = H* (*B*0 || *B*1 || ... || *B*q) [i.e., the randomness pool is hashed using the hash function H, which produces a hash M] 
      *M = H*（*B* 0||*B* 1|| ... || *B* q）[即，使用散列函数H对随机性池进行散列，这产生散列M]
   2. Bi = Bi ^ M 

7. *R = B*0 || *B*1 || ... || *B*q 
   *R = B* 0||*B* 1|| ... || *B* q

For example, if *q* = 1, the randomness pool would be mixed as follows:
例如，如果*q*= 1，随机池将混合如下：

1. (*B*0 || *B*1) = *R*
   （*B* 0||*B* 1）= *R* 
2. *B*0 = *B*0 ^ *H*(*B*0 || *B*1) 
   *B* 0 = *B* 0 ^*H*（*B* 0||*B* 1）
3. *B*1 = *B*1 ^ *H*(*B*0 || *B*1) 
   *B* 1 = *B* 1 ^*H*（*B* 0||*B* 1）
4. *R* = *B*0 || *B*1 
   *R* = *B* 0||*B* 1

## Generated Values 生成的值

The content of the RNG pool is never directly exported (even when VeraCrypt instructs the RNG to generate and export a value). Thus, even if the  attacker obtains a value generated by the RNG, it is infeasible for him  to determine or predict (using the obtained value) any other values generated by the RNG during the session (it is  infeasible to determine the content of the pool from a value generated  by the RNG).
RNG池的内容不会被直接导出（即使VeraCrypt指示RNG生成并导出一个值）。因此，即使攻击者获得由RNG生成的值，他也不可能（使用所获得的值）确定或预测由RNG在会话期间生成的任何其他值（从由RNG生成的值确定池的内容是不可行的）。

The RNG ensures this by performing the following steps whenever VeraCrypt instructs it to generate and export a value:
当VeraCrypt要求RNG生成和导出一个值时，RNG会执行以下步骤来确保这一点：

1. Data obtained from the sources listed above is added to the pool as described above. 
   如上所述，从上述来源获得的数据被添加到数据库中。

2. The requested number of bytes is copied from the pool to the output buffer  (the copying starts from the position of the pool cursor; when the end  of the pool is reached, the copying continues from the beginning of the  pool; if the requested number of bytes is greater than the size of the pool, no value is generated and an  error is returned). 
   请求的字节数从池复制到输出缓冲区（复制从池游标的位置开始;当到达池的末尾时，复制从池的开头继续;如果请求的字节数大于池的大小，则不生成值并返回错误）。

3. The state of each bit in the pool is inverted (i.e., 0 is changed to 1, and 1 is changed to 0). 
   池中每个位的状态被反转（即，0变为1，1变为0）。

4. Data obtained from some of the sources listed above is added to the pool as described above. 
   如上所述，从上述一些来源获得的数据被添加到数据库中。

5. The content of the pool is transformed using the pool mixing function.  Note: The function uses a cryptographically secure one-way hash function selected by the user (for more information, see the section *Pool Mixing Function* above). 
   使用池混合函数转换池的内容。注意：该函数使用用户选择的加密安全单向哈希函数（有关详细信息，请参阅 *上述合并液混合功能*）。

6. The transformed content of the pool is XORed into the output buffer as follows:

   
   转换后的池内容按如下方式异或到输出缓冲区：

   1. The output buffer write cursor is set to 0 (the first byte of the buffer). 
      输出缓冲区写入光标设置为0（缓冲区的第一个字节）。
   2. The byte at the position of the pool cursor is read from the pool and XORed into the byte in the output buffer at the position of the output buffer write cursor. 
      从池中读取位于池游标位置的字节，并将其异或为输出缓冲区中位于输出缓冲区写入游标位置的字节。
   3. The pool cursor position is advanced by one byte. If the end of the pool is reached, the cursor position is set to 0 (the first byte of the pool). 
      池游标位置前进一个字节。如果到达池的末尾，则游标位置设置为0（池的第一个字节）。
   4. The position of the output buffer write cursor is advanced by one byte. 
      输出缓冲区写入光标的位置提前一个字节。
   5. Steps b–d are repeated for each remaining byte of the output buffer (whose length is equal to the requested number of bytes). 
      对于输出缓冲区的每个剩余字节（其长度等于所请求的字节数）重复步骤b-d。
   6. The content of the output buffer, which is the final value generated by the RNG, is exported. 
      输出缓冲区的内容（RNG生成的最终值）将被导出。

## Design Origins 设计起源

The design and implementation of the random number generator are based on the following works:
随机数发生器的设计与实现基于以下工作：

- Software Generation of Practically Strong Random Numbers by Peter Gutmann [10] 
  软件生成实际强随机数Peter Gutmann [10]
- Cryptographic Random Numbers by Carl Ellison [11] 
  《Cryptographic Random Numbers》卡尔·埃里森[11]

# Keyfiles 密钥文件

​          VeraCrypt keyfile is a file whose content is combined with a password.          The user can use any kind of file as a VeraCrypt keyfile. The user can          also generate a keyfile using the built-in keyfile generator, which          utilizes the VeraCrypt RNG to generate a file with random content (for          more information, see the section          [             *Random Number Generator*](https://veracrypt.fr/en/Random Number Generator.html)).        
VeraCrypt keyfile是一个包含密码的文件。          用户可以使用任何类型的文件作为VeraCrypt密钥文件。用户可以          还可以使用内置的密钥文件生成器生成密钥文件，          利用VeraCrypt RNG生成一个包含随机内容的文件（用于          更多信息，请参见          [*随机数生成器*](https://veracrypt.fr/en/Random Number Generator.html)）。

​          The maximum size of a keyfile is not limited; however, only its first          1,048,576 bytes (1 MiB) are processed (all remaining bytes are ignored          due to performance issues connected with processing extremely large          files). The user can supply one or more keyfiles (the number of          keyfiles is not limited).        
密钥文件的最大大小没有限制;但是，          已处理1，048，576字节（1 MiB）（忽略所有剩余字节          由于与处理极大的数据有关的性能问题，          文件）。用户可以提供一个或多个密钥文件（          密钥文件不受限制）。

​          Keyfiles can be stored on PKCS-11-compliant [23] security tokens and          smart cards protected by multiple PIN codes (which can be entered          either using a hardware PIN pad or via the VeraCrypt GUI).        
密钥文件可以存储在符合PKCS-11标准的安全令牌上，          受多个PIN码保护的智能卡（可输入          使用硬件密码键盘或通过VeraCrypt GUI）。

​          EMV-compliant smart cards' data can be used as keyfile, see chapter          [             *EMV Smart Cards*](https://veracrypt.fr/en/EMV Smart Cards.html).        
符合EMV标准的智能卡数据可用作密钥文件，请参见第          [*EMV智能卡*](https://veracrypt.fr/en/EMV Smart Cards.html)

​          Keyfiles are processed and applied to a password using the following          method:        
使用以下方法处理密钥文件并将其应用于密码          方法：

1. ​            Let *P* be a VeraCrypt volume password supplied by user (may            be empty)          
   设*P为*用户提供的VeraCrypt加密卷密码（可以            为空）

2. Let *KP* be the keyfile pool
   设*KP*为密钥文件池

3. ​            Let 

   kpl

    be the size of the keyfile pool 

   KP

   , in            bytes (64, i.e., 512 bits);            

   
   令*kpl*为密钥文件池*KP*的大小，            字节（64，即，512位）;

   ​              kpl must be a multiple of the output size of a hash function H            
   kpl必须是散列函数H的输出大小的倍数

4. ​            Let *pl* be the length of the password *P*, in bytes            (in the current version: 0 ≤ *pl* ≤ 64)          
   设*pl*为密码*P*的长度，单位为字节（当前版本：0 ≤*pl* ≤ 64）

5. ​            if *kpl > pl*, append (*kpl – pl*) zero bytes            to the password *P* (thus *pl = kpl*)          
   如果*kpl > pl*，将（*kpl - pl*）零字节附加到密码*P*（因此*pl = kpl*）

6. ​            Fill the keyfile pool *KP* with *kpl* zero bytes.          
   用*kpl*零字节填充密钥文件池*KP*。

7. ​            For each keyfile perform the following steps:            

   
   对于每个密钥文件，请执行以下步骤：

   1. ​                Set the position of the keyfile pool cursor to the beginning of                the pool              
      将密钥文件池游标的位置设置为                泳池

   2. Initialize the hash function *H*
      初始化哈希函数*H*

   3. ​                Load all bytes of the keyfile one by one, and for each loaded                byte perform the following steps:                

      
      逐个加载密钥文件的所有字节，对于每个加载的                字节执行以下步骤：

      1. ​                    Hash the loaded byte using the hash function                    *H* without initializing the hash, to obtain an                    intermediate hash (state) *M.* Do not finalize the                    hash (the state is retained for next round).                  
         使用散列函数对加载的字节进行散列                    *H*，而不初始化散列，以获得中间散列（状态）*M。*不要最终确定                    hash（状态保留到下一轮）。
      2. ​                    Divide the state *M* into individual bytes.
         将状态*M*划分为单个字节。
         ​                    For example, if the hash output size is 4 bytes, (*T*0 || *T*1 || *T*2 || *T*3) = *M*
         例如，如果散列输出大小为4个字节，则（T||*T*1||*T*2||*T*3）= *M*                  
      3. ​                    Write these bytes (obtained in step 7.c.ii) individually to                    the keyfile pool with the modulo 28 addition                    operation (not by replacing the old values in the pool) at                    the position of the pool cursor. After a byte is written,                    the pool cursor position is advanced by one byte. When the                    cursor reaches the end of the pool, its position is set to                    the beginning of the pool.                  
         将这些字节（在步骤7.c.ii中获得）分别写入具有模28加法的密钥文件池                    操作（不是通过替换池中的旧值），                    池光标的位置。在写入一个字节之后，                    池游标位置前进一个字节。当                    游标到达池的末尾时，其位置设置为                    游泳池的开始。

8. ​            Apply the content of the keyfile pool to the password            

   P

    using the following method:            

   
   将密钥文件池的内容应用于密码            *P*使用以下方法：

   1. ​                Divide the password *P* into individual bytes *B*0...*B*pl-1.
      将密码*P*分成单个字节*B*0. *B*pl-1。
      ​                Note that if the password was shorter than the keyfile pool,                then the password was padded with zero bytes to the length of                the pool in Step 5 (hence, at this point the length of the                password is always greater than or equal to the length of the                keyfile pool).              
      请注意，如果密码比密钥文件池短，                然后密码用零字节填充到                步骤5中的池（因此，在这一点上，                密码的长度始终大于或等于                密钥文件池）。
   2. ​                Divide the keyfile pool *KP* into individual bytes                *G*0...*G*kpl-1
      将密钥文件池*KP*划分为单个字节                *去*... *G*kpl-1              
   3. For 0 ≤ i < kpl perform: Bi = Bi ⊕ Gi
      对于0 ≤ i < kpl，执行：Bi = Bi gi
   4. ​                *P* = *B*0 || *B*1 ||                ... || *B*pl-2 || *B*pl-1
      *P = B 0* B 1*...*|||| || *B pl-2*B pl-1||              

9. ​            The password *P* (after the keyfile pool content has been            applied to it) is now passed to the header key derivation function            PBKDF2 (PKCS #5 v2), which processes it (along with salt and other            data) using a cryptographically secure hash algorithm selected by            the user (e.g., SHA-512). See the section            [               *Header Key Derivation, Salt, and Iteration Count*](https://veracrypt.fr/en/Header Key Derivation.html)            for more information.          
   密码P（在密钥文件池内容已            应用于它）现在被传递给头密钥派生函数            PBKDF 2（PKCS #5 v2），它处理它（沿着盐和其他            数据）使用通过以下方式选择的加密安全散列算法            用户（例如，SHA-512）。见the section            [头键派生、盐和迭代计数](https://veracrypt.fr/en/Header Key Derivation.html)            for more information.

​          The role of the hash function *H* is merely to perform          diffusion [2]. CRC-32 is used as the hash function *H*. Note          that the output of CRC-32 is subsequently processed using a          cryptographically secure hash algorithm: The keyfile pool content (in          addition to being hashed using CRC-32) is applied to the password,          which is then passed to the header key derivation function PBKDF2          (PKCS #5 v2), which processes it (along with salt and other data)          using a cryptographically secure hash algorithm selected by the user          (e.g., SHA-512). The resultant values are used to form the header key          and the secondary header key (XTS mode).        
哈希函数H的作用只是执行扩散[2]。CRC-32被用作散列函数H。注意          CRC-32的输出随后使用          加密安全哈希算法：密钥文件池内容（在          除了使用CRC-32进行散列之外）被应用于密码，          然后将其传递给报头密钥导出函数PBKDF 2          (PKCS#5 v2），处理它（连同盐和其他数据一起沿着）          使用用户选择的加密安全哈希算法          (e.g., SHA-512）。结果值用于形成头键          和第二报头密钥（XTS模式）。

# PIM

PIM stands for "Personal Iterations Multiplier". It is a parameter that was introduced in VeraCrypt 1.12 and whose value controls the number of  iterations used by the header key derivation function. This value can be specified through the password dialog or in the command line.
PIM是Personal Iterations Multiplier的缩写。它是VeraCrypt 1.12中引入的一个参数，其值控制头密钥导出函数使用的迭代次数。可以通过密码对话框或命令行指定此值。

When a PIM value is specified, the number of iterations is calculated as follows:
当指定PIM值时，迭代次数计算如下：

- For system encryption that doesn't use SHA-512 or Whirlpool: Iterations = **PIM x 2048**
  对于不使用SHA-512或Whirlpool的系统加密：迭代次数=**PIM x 2048**
- For system encryption that uses SHA-512 or Whirlpool: Iterations = **15000 + (PIM x 1000)**
  对于使用SHA-512或Whirlpool的系统加密：迭代次数=**15000 +（PIM x 1000）**
- For non-system encryption and file containers: Iterations = **15000 + (PIM x 1000)**
  对于非系统加密和文件容器：迭代次数=**15000 +（PIM x 1000）**

If no PIM value is specified, VeraCrypt will use the default number of iterations used in versions prior to 1.12 (see [ 	Header Key Derivation](https://veracrypt.fr/en/Header Key Derivation.html)). This can be summarized as follows:
如果没有指定PIM值，VeraCrypt将使用1.12之前版本的默认迭代次数（参见 [头密钥导出](https://veracrypt.fr/en/Header Key Derivation.html)）。这可以概括如下：
 	

- For system partition encryption (boot encryption) that uses SHA-256, BLAKE2s-256 or Streebog, **200000** iterations are used which is equivalent to a PIM value of **98**.
  对于使用SHA-256、BLAKE 2 -256或Streebog的系统分区加密（靴子加密），使用**200000**次迭代，这相当于PIM值**98**。
- For system encryption that uses SHA-512 or Whirlpool, **500000** iterations are used which is equivalent to a PIM value of **485**.
  对于使用SHA-512或Whirlpool的系统加密，使用**500000**次迭代，这相当于PIM值**485**。
- For non-system encryption and file containers, all derivation algorithms will use **500000** iterations which is equivalent to a PIM value of **485**.
  对于非系统加密和文件容器，所有派生算法将使用**500000次**迭代，这相当于PIM值**485**。



Prior to version 1.12, the security of a VeraCrypt volume was only based on  the password strength because VeraCrypt was using a fixed number of  iterations.
在1.12版本之前，VeraCrypt加密卷的安全性仅基于密码强度，因为VeraCrypt使用固定的迭代次数。
 With the introduction of PIM, VeraCrypt has a 2-dimensional security  space for volumes based on the couple (Password, PIM). This provides  more flexibility for adjusting the desired security level while also  controlling the performance of the mount/boot operation.
随着PIM的引入，VeraCrypt拥有了一个基于密码对（Password，PIM）的二维安全空间。这为调整所需的安全级别提供了更大的灵活性，同时还控制了安装/靴子操作的性能。

### PIM Usage PIM使用

It is not mandatory to specify a PIM.
不强制指定PIM。


 When creating a volume or when changing the password, the user has the  possibility to specify a PIM value by checking the "Use PIM" checkbox  which in turn will make a PIM field available in the GUI so a PIM value  can be entered.
当创建卷或更改密码时，用户可以通过选中“使用PIM”复选框来指定PIM值，这反过来将在GUI中提供PIM字段，以便输入PIM值。

 

The PIM is treated like a secret value that must be entered by the user  each time alongside the password. If the incorrect PIM value is  specified, the mount/boot operation will fail.
PIM被视为一个秘密值，必须由用户每次与密码一起输入。如果指定的PIM值不正确，则装载/靴子操作将失败。

 

Using high PIM values leads to better security thanks to the increased number of iterations but it comes with slower mounting/booting times.
使用高PIM值可以提高安全性，这要归功于迭代次数的增加，但它会带来更慢的安装/引导时间。

With small PIM values, mounting/booting is quicker but this could decrease security if a weak password is used.
对于较小的PIM值，挂载/引导会更快，但如果使用弱密码，则会降低安全性。

 

During the creation of a volume or the encryption of the system, VeraCrypt  forces the PIM value to be greater than or equal to a certain minimal  value when the password is less than 20 characters. This check is done  in order to ensure that, for short passwords, the security level is at least equal to the default level provided by  an empty PIM.
在创建卷或加密系统时，当密码小于20个字符时，VeraCrypt会强制PIM值大于或等于某个最小值。执行此检查是为了确保对于短密码，安全级别至少等于空PIM提供的默认级别。

 

The PIM minimal value for short passwords is **98** for system encryption that doesn't use SHA-512 or Whirlpool and **485** for the other cases. For password with 20 characters and more, the PIM minimal value is **1**. In all cases, leaving the PIM empty or setting its value to 0 will make VeraCrypt use the default high number of iterations as explained in  section [ Header Key Derivation](https://veracrypt.fr/en/Header Key Derivation.html).
对于不使用SHA-512或Whirlpool的系统加密，短密码的PIM最小值为**98**， **第485章**其他的案子对于20个字符及以上的密码，PIM最小值为 **1**.一、在所有情况下，将PIM留空或将其值设置为0将使VeraCrypt使用默认的高迭代次数，如第 [头密钥推导](https://veracrypt.fr/en/Header Key Derivation.html)。

Motivations behind using a custom PIM value can be:
使用自定义PIM值的动机可能是：

- Add an extra secret parameter (PIM) that an attacker will have to guess 
  添加攻击者必须猜测的额外秘密参数（PIM）
- Increase security level by using large PIM values to thwart future development of brute force attacks. 
  通过使用较大的PIM值来阻止未来暴力攻击的发展，从而提高安全级别。
- Speeding up booting or mounting through the use of a small PIM value (less than  98 for system encryption that doesn't use SHA-512 or Whirlpool and less  than 485 for the other cases) 
  通过使用较小的PIM值（对于不使用SHA-512或Whirlpool的系统加密，小于98，对于其他情况，小于485）来加速引导或挂载

The screenshots below show the step to mount a volume using a PIM equal to 231:
下面的屏幕截图显示了使用等于231的PIM装载卷的步骤：

| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_UsePIM_Step1.png) |
| ------------------------------------------------------------ |
| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_UsePIM_Step2.png) |

 

### Changing/clearing the PIM 更改/清除PIM

The PIM of a volume or for system encryption can be changed or cleared  using the change password functionality. The screenshots below shows an  example of changing the PIM from the empty default value to a value  equal to 3 (this is possible since the password has more than 20 characters). In order to do so, the user must first  tick "Use PIM" checkbox in the "New" section to reveal the PIM field.
可以使用更改密码功能更改或清除卷或系统加密的PIM。下面的屏幕截图显示了将PIM从空默认值更改为等于3的值的示例（这是可能的，因为密码超过20个字符）。为此，用户必须首先勾选“新建”部分中的“使用PIM”复选框以显示PIM字段。

| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_ChangePIM_Step1.png) |
| ------------------------------------------------------------ |
| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_ChangePIM_Step2.png) |

#####  

| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_ChangePIM_System_Step1.png) |
| ------------------------------------------------------------ |
| ![img](https://veracrypt.fr/en/Personal Iterations Multiplier (PIM)_VeraCrypt_ChangePIM_System_Step2.png) |

# VeraCrypt Volume Format Specification VeraCrypt加密卷格式规范

The format of file-hosted volumes is identical to the format of  partition/device-hosted volumes (however, the "volume header", or key  data, for a system partition/drive is stored in the last 512 bytes of  the first logical drive track). VeraCrypt volumes have no "signature" or ID strings. Until decrypted, they appear to consist  solely of random data.
文件托管卷的格式与分区/设备托管卷的格式相同（但是，系统分区/驱动器的“卷头”或关键数据存储在第一个逻辑驱动器磁道的最后512字节中）。VeraCrypt加密卷没有“签名”或ID字符串。在解密之前，它们似乎完全由随机数据组成。

Free space on each VeraCrypt volume is filled with random data when the  volume is created.* The random data is generated as follows: Right  before VeraCrypt volume formatting begins, a temporary encryption key  and a temporary secondary key (XTS mode) are generated by the random number generator (see the section [ Random Number Generator](https://veracrypt.fr/en/Random Number Generator.html)). The encryption algorithm that the user  selected is initialized with the temporary keys. The encryption  algorithm is then used to encrypt plaintext blocks consisting of random  bytes generated by the random number generator. The encryption algorithm operates in XTS mode (see the section [ Hidden Volume](https://veracrypt.fr/en/Hidden Volume.html)). The resulting ciphertext blocks are used to fill  (overwrite) the free space on the volume. The temporary keys are stored  in RAM and are erased after formatting finishes.
每个VeraCrypt加密卷上的可用空间在创建加密卷时会被随机数据填充。*随机数据的生成过程如下：在VeraCrypt加密卷格式化开始之前，随机数生成器会生成一个临时加密密钥和一个临时辅助密钥（XTS模式）（参见[随机数生成器一](https://veracrypt.fr/en/Random Number Generator.html)节）。使用临时密钥初始化用户选择的加密算法。然后，加密算法用于加密由随机数生成器生成的随机字节组成的明文块。加密算法在XTS模式下运行（参见[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)一节）。生成的密文块用于填充（覆盖）卷上的可用空间。临时密钥存储在RAM中，并在格式化完成后擦除。


 VeraCrypt Volume Format Specification:
VeraCrypt加密卷格式规格：

| Offset (bytes) 偏移量（字节） | Size (bytes) 大小（字节） | Encryption 加密  Status† 状态† |                       Description 描述                       |
| :---------------------------: | :-----------------------: | :----------------------------: | :----------------------------------------------------------: |
|                               |                           |                                |                                                              |
|               0               |            64             |      Unencrypted§ 未加密§      |                           Salt 盐                            |
|                               |                           |                                |                                                              |
|              64               |             4             |         Encrypted 加密         |            ASCII string "VERA" ASCII字符串“VERA”             |
|                               |                           |                                |                                                              |
|              68               |             2             |         Encrypted 加密         |      Volume header format version (2) 卷头格式版本（2）      |
|                               |                           |                                |                                                              |
|              70               |             2             |         Encrypted 加密         | Minimum program version required to open the volume 打开卷所需的最低程序版本 |
|                               |                           |                                |                                                              |
|              72               |             4             |         Encrypted 加密         | CRC-32 checksum of the (decrypted) bytes 256-511 （解密）字节256-511的CRC-32校验和 |
|                               |                           |                                |                                                              |
|              76               |            16             |         Encrypted 加密         |      Reserved (must contain zeroes) 保留（必须包含零）       |
|                               |                           |                                |                                                              |
|              92               |             8             |         Encrypted 加密         | Size of hidden volume (set to zero in non-hidden volumes) 隐藏卷的大小（在非隐藏卷中设置为零） |
|                               |                           |                                |                                                              |
|              100              |             8             |         Encrypted 加密         |                   Size of volume 体积大小                    |
|                               |                           |                                |                                                              |
|              108              |             8             |         Encrypted 加密         | Byte offset of the start of the master key scope 主密钥范围开始的字节偏移量 |
|                               |                           |                                |                                                              |
|              116              |             8             |         Encrypted 加密         | Size of the encrypted area within the master key scope 主密钥范围内加密区域的大小 |
|                               |                           |                                |                                                              |
|              124              |             4             |         Encrypted 加密         | Flag bits (bit 0 set: system encryption; bit 1 set: non-system 标志位（位0设置：系统加密;位1设置：非系统 |
|                               |                           |                                | in-place-encrypted/decrypted volume; bits 2–31 are reserved) 就地加密/解密卷;保留位2-31） |
|                               |                           |                                |                                                              |
|              128              |             4             |         Encrypted 加密         |           Sector size (in bytes) 扇区大小（字节）            |
|                               |                           |                                |                                                              |
|              132              |            120            |         Encrypted 加密         |      Reserved (must contain zeroes) 保留（必须包含零）       |
|                               |                           |                                |                                                              |
|              252              |             4             |         Encrypted 加密         | CRC-32 checksum of the (decrypted) bytes 64-251 （解密）字节64-251的CRC-32校验和 |
|                               |                           |                                |                                                              |
|              256              |       *Var.* *变种*       |         Encrypted 加密         | Concatenated primary and secondary master keys** 主密钥和次密钥的级联 ** |
|                               |                           |                                |                                                              |
|              512              |           65024           |         Encrypted 加密         | Reserved (for system encryption, this item is omitted‡‡) 保留（用于系统加密，此项目省略） |
|                               |                           |                                |                                                              |
|             65536             |           65536           |       Encrypted / 加密/        | Area for hidden volume header (if there is no hidden volume 隐藏卷标题区域（如果没有隐藏卷 |
|                               |                           |      Unencrypted§ 未加密§      | within the volume, this area contains random data††). For 在该体积内，该区域包含随机数据。为 |
|                               |                           |                                | system encryption, this item is omitted.‡‡ See bytes 0–65535. 系统加密，省略此项。请参阅字节0-65535。 |
|                               |                           |                                |                                                              |
|            131072             |       *Var.* *变种*       |         Encrypted 加密         | Data area (master key scope). For system encryption, offset 数据区（主密钥范围）。对于系统加密，偏移 |
|                               |                           |                                | may be different (depending on offset of system partition). 可能不同（取决于系统分区的偏移量）。 |
|                               |                           |                                |                                                              |
|          *S*-131072‡          |           65536           |       Encrypted / 加密/        | Backup header (encrypted with a different header key derived 备份标头（使用派生的不同标头密钥加密 |
|                               |                           |      Unencrypted§ 未加密§      | using a different salt). For system encryption, this item is 使用不同的盐）。对于系统加密，此项为 |
|                               |                           |                                |   omitted.‡‡ See bytes 0–65535. 省略。请参见字节0-65535。    |
|                               |                           |                                |                                                              |
|     *S*-65536‡ *S*-65536      |           65536           |       Encrypted / 加密/        | Backup header for hidden volume (encrypted with a different 隐藏卷的备份标头（使用不同的 |
|                               |                           |      Unencrypted§ 未加密§      | header key derived using a different salt). If there is no hidden 使用不同的盐导出的头密钥）。如果没有隐藏的 |
|                               |                           |                                | volume within the volume, this area contains random data.†† 卷内的卷，此区域包含随机数据。 |
|                               |                           |                                | For system encryption, this item is omitted.‡‡ See bytes 对于系统加密，此项目被省略。 |
|                               |                           |                                |                      0–65535. 0-65535.                       |
|                               |                           |                                |                                                              |

The fields located at byte #0 (salt) and #256 (master keys) contain  random values generated by the random number generator (see the section [ Random Number Generator](https://veracrypt.fr/en/Random Number Generator.html)) during the volume creation process.
位于字节#0（salt）和#256（主密钥）的字段包含由随机数生成器生成的随机值（参见 [随机数生成器](https://veracrypt.fr/en/Random Number Generator.html)）在卷创建过程中。

If a VeraCrypt volume hosts a hidden volume (within its free space), the header of the hidden volume is located at byte #65536 of the host  volume (the header of the host/outer volume is located at byte #0 of the host volume – see the section [ Hidden Volume](https://veracrypt.fr/en/Hidden Volume.html)). If there is no hidden volume within a VeraCrypt  volume, bytes 65536–131071 of the volume (i.e., the area where the  header of a hidden volume can reside) contain random data (see above for information on the method used to fill free volume space with random data when the volume is created). The layout  of the header of a hidden volume is the same as the one of a standard  volume (bytes 0–65535).
如果一个VeraCrypt加密卷拥有一个隐藏加密卷（在它的空闲空间内），隐藏加密卷的头位于主机加密卷的字节#65536（主机/外部加密卷的头位于主机加密卷的字节#0-参见 [隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)）。如果VeraCrypt加密卷中没有隐藏加密卷，则加密卷的65536-131071字节（即，隐藏卷的头部可以驻留的区域）包含随机数据（参见上面关于在创建卷时用随机数据填充空闲卷空间的方法的信息）。隐藏卷的标题布局与标准卷的标题布局相同（字节0-65535）。

The maximum possible VeraCrypt volume size is 263 bytes (8,589,934,592 GB). However, due to security reasons (with respect to the 128-bit block size used by the [ encryption algorithms](https://veracrypt.fr/en/Encryption Algorithms.html)), the maximum allowed volume size is 1 PB (1,048,576 GB).
VeraCrypt加密卷的最大容量为263字节（8，589，934，592 GB）。然而，由于安全性原因（相对于 [加密算法](https://veracrypt.fr/en/Encryption Algorithms.html)），允许的最大卷大小为1 PB（1，048，576 GB）。

#### Embedded Backup Headers 嵌入式备份标头

Each VeraCrypt volume contains an embedded backup header, located at the end of the volume (see above). The header backup is *not* a copy of the volume header because it is encrypted with a different header key derived using a different salt (see the section [ Header Key Derivation, Salt, and Iteration Count](https://veracrypt.fr/en/Header Key Derivation.html)).
每个VeraCrypt加密卷都包含一个内嵌的备份头，位于卷的末尾（见上文）。头备份是 *不是*卷标头的副本，因为它是用不同的标头密钥加密的，而该标头密钥是使用不同的salt导出的（请参见 [头密钥推导、盐和迭代计数](https://veracrypt.fr/en/Header Key Derivation.html)）。

When the volume password and/or PIM and/or keyfiles are changed, or when the header is restored from the embedded (or an external) header  backup, both the volume header and the backup header (embedded in the  volume) are re-encrypted with different header keys (derived using newly generated salts – the salt for the volume header  is different from the salt for the backup header). Each salt is  generated by the VeraCrypt random number generator (see the section [ Random Number Generator](https://veracrypt.fr/en/Random Number Generator.html)).
当卷密码和/或PIM和/或密钥文件被更改时，或者当从嵌入式（或外部）标头备份恢复标头时，卷标头和备份标头（嵌入在卷中）都用不同的标头密钥重新加密 （使用新生成的盐导出-卷报头的盐与备份报头的盐不同）。每个salt由VeraCrypt随机数生成器生成（参见 [随机数生成器](https://veracrypt.fr/en/Random Number Generator.html)）。

For more information about header backups, see the subsection [ Tools > Restore Volume Header](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header) in the chapter [ Main Program Window](https://veracrypt.fr/en/Main Program Window.html).
有关标头备份的详细信息，请参阅[主程序窗口](https://veracrypt.fr/en/Main Program Window.html)一章中的[工具%3 E还原卷标头小节](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header)。

[Next Section >> 下一节>>](https://veracrypt.fr/en/Standard Compliance.html)

------

\* Provided that the options *Quick Format* and *Dynamic* are disabled and provided that the volume does not contain a filesystem that has been encrypted in place (note that VeraCrypt does not allow  the user to create a hidden volume within such a volume).
\* 惟购股权 *快速格式化*和*动态加密被*禁用，前提是加密卷不包含已加密的文件系统（注意VeraCrypt不允许用户在这样的加密卷中创建隐藏加密卷）。
 † The encrypted areas of the volume header are encrypted in XTS mode  using the primary and secondary header keys. For more information, see  the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) and the section [ Header Key Derivation, Salt, and Iteration Count](https://veracrypt.fr/en/Header Key Derivation.html).
†在XTS模式下，使用主标头密钥和次标头密钥对卷标头的加密区域进行加密。有关详细信息，请参阅 [加密方案](https://veracrypt.fr/en/Encryption Scheme.html)和部分[头密钥推导，盐，迭代计数](https://veracrypt.fr/en/Header Key Derivation.html)。
 ‡  *S* denotes the size of the volume host (in bytes).
**** 表示卷主机的大小（以字节为单位）。
 § Note that the salt does not need to be encrypted, as it does not have  to be kept secret [7] (salt is a sequence of random values).
§注意，盐不需要加密，因为它不需要保密[7]（盐是一个随机值序列）。
 ** Multiple concatenated master keys are stored here when the volume is  encrypted using a cascade of ciphers (secondary master keys are used for XTS mode).
** 当使用密码级联对卷进行加密时，多个级联主密钥存储在此处（辅助主密钥用于XTS模式）。
 †† See above in this section for information on the method used to fill  free volume space with random data when the volume is created.
††有关在创建卷时使用随机数据填充空闲卷空间的方法的信息，请参见本节上文。
 ‡‡ Here, the meaning of "system encryption" does not include a hidden volume containing a hidden operating system.
在这里，“系统加密”的含义不包括包含隐藏操作系统的隐藏卷。

# Compliance with Standards and Specifications 符合标准和规范

To our best knowledge, VeraCrypt complies with the following standards, specifications, and recommendations:
据我们所知，VeraCrypt符合以下标准、规范和建议：

- ISO/IEC 10118-3:2004 [21] 
  ISO/IEC 10118-3：2004 [21]
- FIPS 197 [3] 
- FIPS 198 [22]  [22]第二十二话
- FIPS 180-2 [14] 
- FIPS 140-2 (XTS-AES, SHA-256, SHA-512, HMAC) [25] 
  FIPS 140-2（XTS-AES，SHA-256，SHA-512，HMAC）[25]
- NIST SP 800-38E [24] 
- PKCS #5 v2.0 [7] 
- PKCS #11 v2.20 [23]  [23]第二十三话

The correctness of the implementations of the encryption algorithms can be verified using test vectors (select *Tools* > *Test Vectors*) or by examining the source code of VeraCrypt.
加密算法实现的正确性可以使用测试向量（选择 *工具*>*测试向量*）或检查VeraCrypt的源代码。

# Source Code 源代码

VeraCrypt is open-source and free software. The complete source code of VeraCrypt (written in C, C++, and assembly) is freely available for peer review  at the following Git repositories:
VeraCrypt是开源和免费软件。VeraCrypt的完整源代码（用C、C++和汇编编写）可在以下Git仓库免费获取，以供同行评审：



- https://www.veracrypt.fr/code/
-   
- https://sourceforge.net/p/veracrypt/code/ci/master/tree/
-   
- https://github.com/veracrypt/VeraCrypt
-   
- https://bitbucket.org/veracrypt/veracrypt/src



The source code of each release can be downloaded from the same location as the release binaries.
每个发行版的源代码都可以从与发行版二进制文件相同的位置下载。

# Building VeraCrypt From Source 从源代码构建VeraCrypt

In order to build VeraCrypt from the source code, you can follow these step-by-step guidelines: 
为了从源代码构建VeraCrypt，您可以遵循以下分步指南：

- [Windows Build Guide Windows构建指南](https://veracrypt.fr/en/CompilingGuidelineWin.html)
- [Linux Build Guide Linux构建指南](https://veracrypt.fr/en/CompilingGuidelineLinux.html)

This guide describes how to set up a Windows system that can compile the VeraCrypt. Further it is described how VeraCrypt is going to be  compiled. 
本指南介绍如何设置一个可以编译VeraCrypt的Windows系统。此外，它还描述了如何编译VeraCrypt。
 The procedure for a Windows 10 system is described here as an example, but the procedure for other Windows systems is analogous. 
这里以Windows 10系统的过程为例进行描述，但其他Windows系统的过程类似。

The following components are required for compiling VeraCrypt: 
编译VeraCrypt需要以下组件：

1. Microsoft Visual Studio 2010
2. Microsoft Visual Studio 2010 Service Pack 1
3. NASM
4. YASM
5. Visual C++ 1.52
6. Windows SDK 7.1
7. Windows Driver Kit 7.1 Windows驱动程序工具包7.1
8. Windows 8.1 SDK
9. gzip
10. upx
11. 7zip
12. Wix3
13. Microsoft Visual Studio 2019
    微软Visual Studio 2019
14. Windows 10 SDK
15. Windows Driver Kit 1903 Windows驱动程序套件1903
16. Visual Studio build tools
    Visual Studio生成工具

Below are the procedure steps. Clicking on any of the link takes directly to the related step: 
以下是程序步骤。点击任何一个链接都可以直接进入相关步骤：

- **[Installation of Microsoft Visual Studio 2010
  安装Microsoft Visual Studio 2010](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfMicrosoftVisualStudio2010)**
- **[Installation of Microsoft Visual Studio 2010 Service Pack 1
  安装Microsoft Visual Studio 2010 Service Pack 1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfMicrosoftVisualStudio2010ServicePack1)**
- **[Installation of NASM NASM的安装](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfNASM)**
- **[Installation of YASM 安装YASM](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfYASM)**
- **[Installation of Microsoft Visual C++ 1.52
  安装Microsoft Visual C++ 1.52](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVisualCPP)**
- **[Installation of the Windows SDK 7.1
  安装Windows SDK 7.1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWindowsSDK71PP)**
- **[Installation of the Windows Driver Kit 7.1
  安装Windows Driver Kit 7.1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWDK71PP)**
- **[Installation of the Windows 8.1 SDK
  安装Windows 8.1 SDK](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfSDK81PP)**
- **[Installation of gzip 安装gzip](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfGzip)**
- **[Installation of upx 安装upx](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfUpx)**
- **[Installation of 7zip 安装7zip](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOf7zip)**
- **[Installation of Wix3 安装Wix3](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWix3)**
- **[Installation of Microsoft Visual Studio 2019
  安装Microsoft Visual Studio 2019](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVS2019)**
- **[Installation of the Windows Driver Kit 2004
  安装Windows Driver Kit 2004](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWDK10)**
- **[Installation of the Visual Studio build tools
  安装Visual Studio构建工具](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVisualBuildTools)**
- **[Download VeraCrypt Source Files
  下载VeraCrypt源文件](https://veracrypt.fr/en/CompilingGuidelineWin.html#DownloadVeraCrypt)**
- **[Compile the Win32/x64 Versions of VeraCrypt
  编译Win32/x64版本的VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineWin.html#CompileWin32X64)**
- **[Compile the ARM64 Version of VeraCrypt
  编译VeraCrypt的ARM 64版本](https://veracrypt.fr/en/CompilingGuidelineWin.html#CompileARM64)**
- **[Build the VeraCrypt Executables
  构建VeraCrypt可执行文件](https://veracrypt.fr/en/CompilingGuidelineWin.html#BuildVeraCryptExecutables)**
- **[Import the Certificates 导入证书](https://veracrypt.fr/en/CompilingGuidelineWin.html#ImportCertificates)**
- **[Known Issues 已知问题](https://veracrypt.fr/en/CompilingGuidelineWin.html#KnownIssues)**

[Installation of Microsoft Visual Studio 2010
安装Microsoft Visual Studio 2010](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfMicrosoftVisualStudio2010)

​		

1. ​				Visit the following Microsoft website and log in with a free Microsoft account: 
   访问以下Microsoft网站并使用免费Microsoft帐户登录：
    			[https://my.visualstudio.com/Downloads?q=Visual%20Studio%202010%20Professional&pgroup=](https://my.visualstudio.com/Downloads?q=Visual Studio 2010 Professional&pgroup=) 		
2. ​				Please download a (trial) version of “Visual Studio Professional 2010” 
   请下载Visual Studio Professional 2010（试用版）
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/DownloadVS2010.jpg) 		
3. ​				Mount the downloaded ISO file by doubleclicking it 		
   通过双击安装下载的ISO文件
4. ​				Run the file "autorun.exe" as administrator 		
   以管理员身份运行文件“autorun.exe”
5. ​				Install Microsoft Visual Studio 2010 with the default settings 		
   使用默认设置安装Microsoft Visual Studio 2010

​		The installation of the Microsoft SQL Server 2008 Express Service Pack 1 (x64) may fail, but it is not required for compiling VeraCrypt. 
Microsoft SQL Server 2008 Express Service Pack 1（x64）的安装可能会失败，但编译VeraCrypt并不需要安装。



[Installation of Microsoft Visual Studio 2010 Service Pack 1
安装Microsoft Visual Studio 2010 Service Pack 1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfMicrosoftVisualStudio2010ServicePack1)

​		Note: The content the official installer from Microsoft tries to  download is no longer available. Therefore, it is necessary to use an  offline installer. 	
注意：Microsoft官方安装程序尝试下载的内容不再可用。因此，有必要使用离线安装程序。

1. ​				Visit the website of the internet archive and download the iso image of the Microsoft Visual Studio 2010 Service Pack 1:
   访问互联网存档的网站并下载Microsoft Visual Studio 2010 Service Pack 1的ISO映像：
    			https://archive.org/details/vs-2010-sp-1dvd-1 		
2. ​				Mount the downloaded ISO file by doubleclicking it 		
   通过双击安装下载的ISO文件
3. ​				Run the file "Setup.exe" as administrator 		
   以管理员身份运行文件“Setup.exe”
4. ​				Install Microsoft Visual Studio 2010 Service Pack 1 with the default settings 		
   使用默认设置安装Microsoft Visual Studio 2010 Service Pack 1



[Installation of NASM 安装NASM](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfNASM)

​		

1. ​				Download “nasm-2.08-installer.exe” at: 
   下载“nasm-2.08-installer.exe”：
    			https://www.nasm.us/pub/nasm/releasebuilds/2.08/win32/ 		

2. ​				Run the file as administrator 		
   以管理员身份运行文件

3. ​				Install NASM with the default settings 		
   使用默认设置安装NASM

4. ​				Add NASM to the path Variable. This will make the command globally available on the command line. 

   
   将NASM添加到路径Variable。这将使命令在命令行上全局可用。

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please select the "Path" variable and click on "Edit..." 
      在系统变量区域内，请选择“Path”变量，然后单击“Edit. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectPathVariable.jpg) 				

   6. ​						Click on "New" and add the following value: 

      
      点击“新建”并添加以下值：

      C:\Program Files (x86)\nasm
      C：\Program Files（x86）\nasm

   7. ​						Close the windows by clicking on "OK" 				
      点击“确定”关闭窗口

5. ​				To check if the configuration is working correctly, please open a  command prompt and watch the output of the following command: 

   
   要检查配置是否正常工作，请打开命令提示符并查看以下命令的输出：

   nasm

   



[Installation of YASM 安装YASM](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfYASM)

​		

1. ​				Please create the following folder: 
   请创建以下文件夹：
    			C:\Program Files\YASM 		 C：\Program Files\YASM

2. ​				Please download the file "Win64 VS2010 .zip" at: 
   请从以下地址下载文件“Win64 VS2010 .zip”：
    			https://yasm.tortall.net/Download.html 		

3. ​				Your browser might inform you that the file might be a security risk due to the low download rate or the unencrypted connection.  Nevertheless, the official website is the most reliable source for this  file, so we recommend to allow the download 		
   您的浏览器可能会通知您，由于下载率低或连接未加密，该文件可能存在安全风险。尽管如此，官方网站是此文件最可靠的来源，因此我们建议允许下载

4. ​				Unzip the zip file and copy the files to “C:\Program Files\YASM” 		
   解压缩zip文件并将文件复制到“C：\Program Files\YASM”

5. ​				Please download the file "Win64 .exe" at: 
   请从以下网址下载“Win64.exe”文件：
    			https://yasm.tortall.net/Download.html 		

6. ​				Your browser might inform you that the file might be a security risk due to the low download rate or the unencrypted connection.  Nevertheless, the official website is the most reliable source for this  file, so we recommend to allow the download 		
   您的浏览器可能会通知您，由于下载速率低或连接未加密，该文件可能存在安全风险。尽管如此，官方网站是此文件最可靠的来源，因此我们建议允许下载

7. ​				Rename the file to “yasm.exe” and copy it to “C:\Program Files\YASM” 		
   将文件复制到“yasm.exe”并将其复制到“C：\Program Files\YASM”

8. ​				Add YASM to the path Variable and create a new system variable for  YASM. This will make the command globally available on the command line. 

   
   将YASM添加到路径Variable中，并为YASM创建新的系统变量。这将使命令在命令行上全局可用。

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please select the "Path" variable and click on "Edit..." 
      在系统变量区域内，请选择“Path”变量，然后单击“Edit. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectPathVariable.jpg) 				

   6. ​						Click on "New" and add the following value: 

      
      点击“新建”并添加以下值：

      C:\Program Files\YASM C：\Program Files\YASM

   7. ​						Close the top window by clicking on "OK" 				
      点击“确定”关闭顶部窗口

   8. ​						Within the area of the system variables, please click on "New..." 
      在系统变量区域内，请单击“New. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/AddNewSystemVar.jpg) 				

   9. ​						Fill out the form with the following values: 

      
      使用以下值填写表单：

      Variable name: YASMPATH 变量名：YASMPATH
       Variable value: C:\Program Files\YASM
      变量值：C：\Program Files\YASM

   10. ​						Close the windows by clicking on "OK" 				
       点击“确定”关闭窗口

9. ​				To check if the configuration is working correctly, please open a  command prompt and watch the output of the following command: 

   
   要检查配置是否正常工作，请打开命令提示符并查看以下命令的输出：

   yasm 亚什姆

   ​				and 

    和

   vsyasm 弗夏什姆

   



[Installation of Microsoft Visual C++ 1.52
安装Microsoft Visual C++ 1.52](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVisualCPP)

​		

1. ​				Visual C++ 1.52 is available via the paid Microsoft MSDN  subscription. If you do not have a subscription, you download the ISO  image via the internet archive: 
   Visual C++ 1.52可通过Microsoft MSDN付费订阅获得。如果您没有订阅，您可以通过互联网存档下载ISO映像：
    			https://archive.org/details/ms-vc152 		

2. ​				Create the folder “C:\MSVC15” 		
   创建文件夹“C：\MSVC15”

3. ​				Mount the ISO file and copy the content of the folder “MSVC” to “C:\MSVC15” 		
   挂载ISO文件并将文件夹“MSVC”的内容复制到“C：\MSVC15”

4. ​				Create a system variable for Microsoft Visual C++ 1.52 

   
   为Microsoft Visual C++ 1.52创建系统变量

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please click on "New..." 
      在系统变量区域内，请单击“New. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/AddNewSystemVar.jpg) 				

   6. ​						Fill out the form with the following values: 

      
      使用以下值填写表单：

      Variable name: MSVC16_ROOT
      变量名：MSVC16_ROOT
       Variable value: C:\MSVC15
      变量值：C：\MSVC15

   7. ​						Close the windows by clicking on "OK" 				
      点击“确定”关闭窗口



[Installation of the Windows SDK 7.1
安装Windows SDK 7.1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWindowsSDK71PP)

​		The installer requires .Net Framework 4 (Not a newer one like .Net  Framework 4.8!). Since a newer version is already preinstalled with  Windows 10, the installer has to be tricked: 	
安装程序需要.Net Framework 4（不是像.Net Framework 4.8这样的更新版本！）。由于Windows 10已经预装了较新的版本，因此安装程序必须被欺骗：

1. ​				Click on the start button and search for: "regedit.msc". Start the first finding. 		
   点击开始按钮并搜索：“regedit. xml”。开始第一个发现。

2. ​				Navigate to "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v4\" 		
   导航至“HKEY_LOCAL_INE_NETWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v4\”

3. ​				Change the permissions for the "Client" folder, so you can edit the keys: 

   
   更改“客户端”文件夹的权限，以便您可以编辑密钥：

   1. ​						Right click on the subfolder "Client" and select "Permissions..." 				
      右键单击子文件夹“Client”并选择“Client. "
   2. ​						Click on "Advanced"  点击“高级”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-1.jpg) 				
   3. ​						Change the owner to your user and click on "Add" 
      将所有者更改为您的用户，然后单击“添加”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-2.jpg) 				
   4. ​						Set the principal to your user, select "Full Control" and click on "OK" 
      将主体设置为您的用户，选择“完全控制”，然后单击“确定”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-3.jpg) 				
   5. ​						Within the folder "Client" note down the value of the entry "Version" 				
      在文件夹“客户端”中记下条目“版本”的值
   6. ​						Doubleclick on the entry "Version" and change the value to "4.0.30319" 
      双击条目“Version”并将值更改为“4.0.30319”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-4.jpg) 				

4. ​				Change the permissions for the "Full" folder, so you can edit the keys: 

   
   更改“Full”文件夹的权限，以便您可以编辑密钥：

   1. ​						Right click on the subfolder "Full" and select "Permissions..." 				
      右键单击子文件夹“完整”并选择“保存... "
   2. ​						Click on "Advanced"  点击“高级”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-1.jpg) 				
   3. ​						Change the owner to your user and click on "Add" 
      将所有者更改为您的用户，然后单击“添加”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-2.jpg) 				
   4. ​						Set the principal to your user, select "Full Control" and click on "OK" 
      将主体设置为您的用户，选择“完全控制”，然后单击“确定”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-3.jpg) 				
   5. ​						Within the folder "Full" note down the value of the entry "Version" 				
      在文件夹“完整”中记下条目“版本”的值
   6. ​						Doubleclick on the entry "Version" and change the value to "4.0.30319" 
      双击条目“Version”并将值更改为“4.0.30319”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/RegeditPermissions-4.jpg) 				

5. ​				Download the Windows SDK 7.1 at: 
   下载Windows SDK 7.1：
    			https://www.microsoft.com/en-us/download/details.aspx?id=8279 		

6. ​				Run the downloaded file as administrator and install the application with default settings 		
   以管理员身份运行下载的文件，并使用默认设置安装应用程序

7. ​				After the installation, revert the changes done in the registry editor. 
   安装完成后，恢复在注册表编辑器中所做的更改。
    			**Note:** The owner "TrustedInstaller" can be restored by searching for: "NT Service\TrustedInstaller" 		
   **注意：可以通过搜索"NT Service\TrustedAccount"来恢复所有者"TrustedAccount"**



[Installation of the Windows Driver Kit 7.1
安装Windows Driver Kit 7.1](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWDK71PP)

​		

1. ​				Please download the ISO of the Windows Diver Kit 7.1 at: 
   请从以下网址下载Windows Diver Kit 7.1的ISO：
    			https://www.microsoft.com/en-us/download/details.aspx?id=11800 		
2. ​				Mount the downloaded ISO file by doubleclicking it 		
   通过双击安装下载的ISO文件
3. ​				Run the file "KitSetup.exe" as administrator. Within the installation select all features to be installed. 
   以管理员身份运行文件"KitSetup.exe"。在安装中选择要安装的所有功能。
    			**Note:** It might be that during the installed you are requested to install the  .NET Framework 3.5. In this case click on "Download and install this  feature". 		
   **注意：在安装过程中，可能会要求您安装. NET Framework 3.5。**在这种情况下，单击“下载并安装此功能”。
4. ​				Install the Driver Kit to the default location 		
   将驱动程序套件安装到默认位置



[Installation of the Windows 8.1 SDK
安装Windows 8.1 SDK](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfSDK81PP)

​		

1. ​				Please download the ISO of the Windows 8.1 SDK at: 
   请从以下网址下载Windows 8.1 SDK的ISO：
    			https://developer.microsoft.com/de-de/windows/downloads/sdk-archive/ 		

2. ​				Run the downloaded file as administrator and install the Windows 8.1 SDK with default settings 		
   以管理员身份运行下载的文件，并使用默认设置安装Windows 8.1 SDK

3. ​				Create a system variable for the Windows 8.1 SDK 

   
   为Windows 8.1 SDK创建系统变量

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please click on "New..." 
      在系统变量区域内，请单击“New. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/AddNewSystemVar.jpg) 				

   6. ​						Fill out the form with the following values: 

      
      使用以下值填写表单：

      Variable name: WSDK81 变量名称：WSDK81
       Variable value: C:\Program Files (x86)\Windows Kits\8.1\
      变量值：C：\Program Files（x86）\Windows Kits\8.1\

   7. ​						Close the windows by clicking on "OK" 				
      点击“确定”关闭窗口



[Installation of gzip 安装gzip](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfGzip)

​		

1. ​				Please create the following folder: 
   请创建以下文件夹：
    			C:\Program Files (x86)\gzip 		
   C：\Program Files（x86）\gzip

2. ​				Please download gzip version at: 
   请下载gzip版本：
    			https://sourceforge.net/projects/gnuwin32/files/gzip/1.3.12-1/gzip-1.3.12-1-bin.zip/download?use-mirror=netix&download= 		

3. ​				Copy the content of the downloaded zip to “C:\Program Files (x86)\gzip” 		
   将下载的zip文件的内容复制到“C：\Program Files（x86）\gzip”

4. ​				Add gzip to the path Variable. This will make the command globally available on the command line. 

   
   将gzip添加到路径Variable中。这将使命令在命令行上全局可用。

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please select the "Path" variable and click on "Edit..." 
      在系统变量区域内，请选择“Path”变量，然后单击“Edit. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectPathVariable.jpg) 				

   6. ​						Click on "New" and add the following value: 

      
      点击“新建”并添加以下值：

      C:\Program Files (x86)\gzip\bin
      C：\Program Files（x86）\gzip\bin

   7. ​						Close the windows by clicking on "OK" 				
      点击“确定”关闭窗口

5. ​				To check if the configuration is working correctly, please open a  command prompt and watch the output of the following command: 

   
   要检查配置是否正常工作，请打开命令提示符并查看以下命令的输出：

   gzip

   



[Installation of upx 安装upx](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfUpx)

​		

1. ​				Please create the following folder: 
   请创建以下文件夹：
    			C:\Program Files (x86)\upx 		
   C：\Program Files（x86）\upx

2. ​				Please download the latest upx-X-XX-win64.zip version at: 
   请从以下网址下载最新版本：upx-X-XX-win64.zip：
    			https://github.com/upx/upx/releases/tag/v3.96 		

3. ​				Copy the content of the downloaded zip to “C:\Program Files (x86)\upx” 		
   将下载的zip文件的内容复制到“C：\Program Files（x86）\upx”

4. ​				Add gzip to the path Variable. This will make the command globally available on the command line. 

   
   将gzip添加到路径Variable中。这将使命令在命令行上全局可用。

   1. ​						Open a file explorer 				 打开文件资源管理器

   2. ​						Within the left file tree, please make a right click on "This PC" and select "Properties" 
      在左边的文件树中，请右键单击“此PC”并选择“属性”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectThisPC.jpg) 				

   3. ​						Within the right menu, please click on "Advanced system settings" 
      在右侧菜单中，请单击“高级系统设置”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectAdvancedSystemSettings.jpg) 				

   4. ​						Please click on "Environment Variables" 
      请点击“环境变量”
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectEnvironmentVariables.jpg) 				

   5. ​						Within the area of the system variables, please select the "Path" variable and click on "Edit..." 
      在系统变量区域内，请选择“Path”变量，然后单击“Edit. "
       					![img](https://veracrypt.fr/en/CompilingGuidelineWin/SelectPathVariable.jpg) 				

   6. ​						Click on "New" and add the following value: 

      
      点击“新建”并添加以下值：

      C:\Program Files (x86)\upx
      C：\Program Files（x86）\upx

   7. ​						Close the windows by clicking on "OK" 				
      点击“确定”关闭窗口

5. ​				To check if the configuration is working correctly, please open a  command prompt and watch the output of the following command: 

   
   要检查配置是否正常工作，请打开命令提示符并查看以下命令的输出：

   upx

   



[Installation of 7zip 安装7zip](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOf7zip)

​		

1. ​				Please download the latest version of 7zip at: 
   请在以下网址下载最新版本的7zip：
    			https://www.7-zip.de/ 		
2. ​				Run the downloaded file as administrator and install 7zip with default settings 		
   以管理员身份运行下载的文件，并使用默认设置安装7zip



[Installation of Wix3 安装Wix3](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWix3)

​		

1. ​				Please download wix311.exe at: 
   下载wix311.exe：
    			https://github.com/wixtoolset/wix3/releases 		
2. ​				Run the downloaded file as administrator and install WiX Toolset with default settings 		
   以管理员身份运行下载的文件，并使用默认设置安装WiX Toolset



[Installation of Microsoft Visual Studio 2019
安装Microsoft Visual Studio 2019](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVS2019)

​		

1. ​				Visit the following Microsoft website and log in with a free Microsoft account: 
   访问以下Microsoft网站并使用免费Microsoft帐户登录：
    			[https://my.visualstudio.com/Downloads?q=visual%20studio%202019%20Professional](https://my.visualstudio.com/Downloads?q=visual studio 2019 Professional) 		

2. ​				Please download the latest (trial) version of “Visual Studio Professional 2019” 
   请下载最新（试用）版本的“Visual Studio Professional 2019”
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/DownloadVS2019.jpg) 		

3. ​				Run the downloaded file as administrator and go through the wizard. 

   
   以管理员身份运行下载的文件并完成向导。

   ​				Select the following Workloads for installation: 

   
   选择以下工作负载进行安装：

   1. ​						Desktop development with C++ 				
      用C++进行桌面开发
   2. ​						.NET desktop development 				 .NET桌面开发

   ​				Select the following individual components for installation: 			

   
   选择以下单个组件进行安装：

   1. ​						.NET 					

       .NET技术

      1. ​								.NET 6.0 Runtime 						 .NET 6.0系统
      2. ​								.NET Core 3.1 Runtime (LTS) 						
         .NET Core 3.1（LTS）
      3. ​								.NET Framework 4 targeting pack 						
         .NET Framework 4目标包
      4. ​								.NET Framework 4.5 targeting pack 						
         .NET Framework 4.5目标包
      5. ​								.NET Framework 4.5.1 targeting pack 						
         .NET Framework 4.5.1目标包
      6. ​								.NET Framework 4.5.2 targeting pack 						
         .NET Framework 4.5.2目标包
      7. ​								.NET Framework 4.6 targeting pack 						
         .NET Framework 4.6目标包
      8. ​								.NET Framework 4.6.1 targeting pack 						
         .NET Framework 4.6.1目标包
      9. ​								.NET Framework 4.7.2 targeting pack 						
         .NET Framework 4.7.2目标包
      10. ​								.NET Framework 4.8 SDK 						
      11. ​								.NET Framework 4.8 targeting pack 						
          .NET Framework 4.8目标包
      12. ​								.NET SDK 						
      13. ​								ML.NET Model Builder (Preview) 						
          ML.NET模型生成器（预览版）

   2. ​						Cloud, database, and server 					

      
      云、数据库和服务器

      1. ​								CLR data types for SQL Server 						
         SQL Server数据类型
      2. ​								Connectivity and publishing tools 						
         连接和发布工具

   3. ​						Code tools 					

       代码工具

      1. ​								NuGet package manager 						 NuGet包管理器
      2. ​								Text Template Transformation 						
         文本模板转换

   4. ​						Compilers, build tools, and runtimes 					

      
      编译器、构建工具和运行时

      1. ​								.NET Compiler Platform SDK 						
         .NET嵌入式平台SDK
      2. ​								C# and Visual Basic Roslyn compilers 						
         C#和Visual Basic Roslyn编译器
      3. ​								C++ 2019 Redistributable Update 						
         C++ 2019可再发行更新
      4. ​								C++ CMake tools for Windows 						
      5. ​								C++/CLI support for v142 build tools (Latest) 						
         v142构建工具的C++/CLI支持（最新）
      6. ​								MSBuild 						
      7. ​								MSVC v142 - VS 2019 C++ ARM64 build tools (Latest) 						
         MSVC v142 - VS 2019 C++ ARM 64构建工具（最新）
      8. ​								MSVC v142 - VS 2019 C++ ARM64 Spectre-mitigated libs (Latest) 						
         MSVC v142 - VS 2019 C++ ARM 64 Spectre-mitigated libs（最新）
      9. ​								MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest) 						
         MSVC v142 - VS 2019 C++ x64/x86构建工具（最新）
      10. ​								MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs (Latest) 						
          MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs（最新）

   5. ​						Debugging and testing 					

       调试和测试

      1. ​								.NET profiling tools 						 .NET分析工具
      2. ​								C++ AddressSanatizer 						 C++地址Sanatizer
      3. ​								C++ profiling tools 						 C++ profiling工具
      4. ​								Just-In-Time debugger 						 即时调试器
      5. ​								Test Adapter for Boost.Test 						
         升压测试适配器
      6. ​								Test Adapter for Google Test 						
         用于Google Test的测试适配器

   6. ​						Development activities 					

       发展活动

      1. ​								C# and Visual Basic 						 C#和Visual Basic
      2. ​								C++ core features 						 C++核心特性
      3. ​								F# language support 						 F#语言支持
      4. ​								IntelliCode 						
      5. ​								JavaScript and TypeScript language support 						
         JavaScript和TypeScript语言支持
      6. ​								Live Share 						

   7. ​						Emulators 					

       仿真器

   8. ​						Games and Graphics 					

       游戏和图形

      1. ​								Graphics debugger and GPU profiler for DirectX 						
         用于DirectX的图形调试器和GPU分析器

   9. ​						SDKs, libraries, and frameworks 					

      
      SDK、库和框架

      1. ​								C++ ATL for latest v142 build tools (ARM64) 						
         用于最新v142构建工具的C++ ATL（ARM64）
      2. ​								C++ ATL for latest v142 build tools (x86 & x64) 						
         用于最新v142构建工具的C++ ATL（x86和x64）
      3. ​								C++ ATL for latest v142 build tools with Spectre Mitigations (ARM64) 						
         用于最新v142构建工具的C++ ATL，带有Spectre缓解措施（ARM64）
      4. ​								C++ ATL for latest v142 build tools with Spectre Mitigations (x86 & x64) 						
         用于最新v142构建工具的C++ ATL，带有Spectre缓解措施（x86和x64）
      5. ​								C++ MFC for latest v142 build tools (ARM64) 						
         用于最新v142构建工具的C++ MFC（ARM64）
      6. ​								C++ MFC for latest v142 build tools (x86 & x64) 						
         用于最新版本142构建工具的C++ MFC（x86和x64）
      7. ​								C++ MFC for latest v142 build tools with Spectre Mitigations (ARM64) 						
         C++ MFC，用于最新的v142构建工具，带有Spectre Mitigations（ARM64）
      8. ​								C++ MFC for latest v142 build tools with Spectre Mitigations (x86 & x64) 						
         用于最新版本142构建工具的C++ MFC，带有Spectre缓解措施（x86和x64）
      9. ​								Entity Framework 6 tools 						 Entity Framework 6工具
      10. ​								TypeScript 4.3 SDK 						
      11. ​								Windows 10 SDK (10.0.19041.0) 						
          Windows 10 SDK（10.0.19041.0）
      12. ​								Windows Universal C Runtime 						
          Windows通用C语言



[Installation of the Windows Driver Kit version 2004
安装Windows驱动程序工具包2004版](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfWDK10)

​		

1. ​				Please download the Windows Driver Kit (WDK) version 2004 at: 
   请从以下网址下载Windows驱动程序工具包（WDK）2004版：
    			https://docs.microsoft.com/en-us/windows-hardware/drivers/other-wdk-downloads 		
2. ​				Run the downloaded file as administrator and install the WDK with default settings 		
   以管理员身份运行下载的文件，并使用默认设置安装WDK
3. ​				At the end of the installation you will be asked if you want to "install Windows Driver Kit Visual Studio extension". 
   在安装结束时，系统会询问您是否要“安装Windows Driver Kit Visual Studio扩展”。
    			Please make sure, that this option is selected before closing the dialog. 		
   请确保在关闭对话框之前选中此选项。
4. ​				A different setup will start automatically and will detect Visual  Studio Professional 2019 as possible target for the extension. 
   不同的安装程序将自动启动，并将检测Visual Studio Professional 2019作为扩展的可能目标。
    			Please select it and proceed with the installation. 		
   请选择它并继续安装。



[Installation of the Visual Studio build tools
安装Visual Studio构建工具](https://veracrypt.fr/en/CompilingGuidelineWin.html#InstallationOfVisualBuildTools)

​		

1. ​				Visit the following Microsoft website and log in with a free Microsoft account: 
   访问以下Microsoft网站并使用免费Microsoft帐户登录：
    			[https://my.visualstudio.com/Downloads?q=visual%20studio%202019%20build%20tools](https://my.visualstudio.com/Downloads?q=visual studio 2019 build tools) 		

2. ​				Please download the latest version of “Build Tools for Visual Studio 2019” 
   请下载最新版本的“Build Tools for Visual Studio 2019”
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/DownloadVSBuildTools.jpg) 		

3. ​				Run the downloaded file as administrator and go through the wizard.  Select the following individual components for installation: 			

   
   以管理员身份运行下载的文件并完成向导。选择以下单个组件进行安装：

   1. ​						.NET 					

       .NET技术

   2. ​						Cloud, database, and server 					

      
      云、数据库和服务器

   3. ​						Code tools 					

       代码工具

   4. ​						Compilers, build tools, and runtimes 					

      
      编译器、构建工具和运行时

      1. ​								C++/CLI support for v142 build tools (Latest) 						
         v142构建工具的C++/CLI支持（最新）
      2. ​								MSVC v142 - VS 2019 C++ ARM64 build tools (Latest) 						
         MSVC v142 - VS 2019 C++ ARM 64构建工具（最新）
      3. ​								MSVC v142 - VS 2019 C++ ARM64 Spectre-mitigated libs (Latest) 						
         MSVC v142 - VS 2019 C++ ARM 64 Spectre-mitigated libs（最新）
      4. ​								MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest) 						
         MSVC v142 - VS 2019 C++ x64/x86构建工具（最新）
      5. ​								MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs (Latest) 						
         MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs（最新）

   5. ​						Debugging and testing 					

       调试和测试

   6. ​						Development activities 					

       发展活动

   7. ​						SDKs, libraries, and frameworks 					

      
      SDK、库和框架

      1. ​								C++ ATL for latest v142 build tools (ARM64) 						
         用于最新v142构建工具的C++ ATL（ARM64）
      2. ​								C++ ATL for latest v142 build tools (x86 & x64) 						
         用于最新v142构建工具的C++ ATL（x86和x64）
      3. ​								C++ ATL for latest v142 build tools with Spectre Mitigations (ARM64) 						
         用于最新v142构建工具的C++ ATL，带有Spectre缓解措施（ARM64）
      4. ​								C++ ATL for latest v142 build tools with Spectre Mitigations (x86 & x64) 						
         用于最新v142构建工具的C++ ATL，带有Spectre缓解措施（x86和x64）



[Download VeraCrypt Source Files
下载VeraCrypt源文件](https://veracrypt.fr/en/CompilingGuidelineWin.html#DownloadVeraCrypt)

​		

1. ​				Visit the VeraCrypt Github repository at: 
   访问VeraCrypt Github仓库：
    			https://github.com/veracrypt/VeraCrypt 		
2. ​				Please click on the green button with the label "Code" and download the code. 
   请点击带有“代码”标签的绿色按钮并下载代码。
    			You can download the repository as zip file, but you may consider to use the git protocol in order to track changes. 		
   你可以下载zip文件的仓库，但你可以考虑使用git协议来跟踪更改。



[Compile the Win32/x64 Versions of VeraCrypt
编译Win32/x64版本的VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineWin.html#CompileWin32X64)

​		

1. ​				Please open the file "src/VeraCrypt.sln" in Visual Studio **2010**
   请在Visual Studio**2010**中打开文件“src/VeraCrypt.sln” 		
2. ​				Please select "All|Win32" as active configuration 
   请选择“全部”|Win32”作为活动配置
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2010Win32Config.jpg) 		
3. ​				Please click on "Build -> Build Solution" 
   请单击“生成->生成解决方案”
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2010BuildSolution.jpg) 		
4. ​				The compiling process should end with warnings, but without errors. Some projects should be skipped. 		
   编译过程应该以警告结束，但没有错误。有些项目应该跳过。
5. ​				Please select "All|x64" as active configuration 
   请选择“全部”|x64”作为活动配置
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2010X64Config.jpg) 		
6. ​				Please click on "Build -> Build Solution" 
   请单击“生成->生成解决方案”
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2010BuildSolution.jpg) 		
7. ​				The compiling process should end with warnings, but without errors. Some projects should be skipped. 
   编译过程应该以警告结束，但没有错误。有些项目应该跳过。
    			Please close Visual Studio 2010 after the compiling process finished 		
   请在编译过程完成后关闭Visual Studio 2010



[Compile the ARM64 Version of VeraCrypt
编译VeraCrypt的ARM 64版本](https://veracrypt.fr/en/CompilingGuidelineWin.html#CompileARM64)

​		

1. ​				Please open the file "src/VeraCrypt_vs2019.sln" in Visual Studio **2019**
   请在Visual Studio**2019**中打开文件“src/VeraCrypt_vs2019.sln” 		
2. ​				Please select "All|ARM64" as active configuration 
   请选择“全部”|ARM64”作为活动配置
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2019ARM64Config.jpg) 		
3. ​				Please click on "Build -> Build Solution" 
   请单击“生成->生成解决方案”
    			![img](https://veracrypt.fr/en/CompilingGuidelineWin/VS2019BuildSolution.jpg) 		
4. ​				The compiling process should end with warnings, but without errors. One project should be skipped. 
   编译过程应该以警告结束，但没有错误。一个项目应该被跳过。
    			Please close Visual Studio 2019 after the compiling process finished 		
   请在编译过程完成后关闭Visual Studio 2019



[Build the VeraCrypt Executables
构建VeraCrypt可执行文件](https://veracrypt.fr/en/CompilingGuidelineWin.html#BuildVeraCryptExecutables)

​		

1. ​				Please open a command line as administrator 		
   请以管理员身份打开命令行
2. ​				Go into the folder "src/Signing/" 		
   进入文件夹“src/Signing/”
3. ​				Run the script "sign_test.bat" 		
   运行脚本“sign_test.bat”
4. ​				You will find the generated exectuables within the folder "src/Release/Setup Files" 		
   您将在文件夹“src/Release/Setup Files”中找到生成的可执行文件



[Import the Certificates 导入证书](https://veracrypt.fr/en/CompilingGuidelineWin.html#ImportCertificates)

 With the sign_test.bat script you just signed the VeraCrypt  executables. This is necessary, since Windows only accepts drivers,  which are trusted by a signed Certificate Authority. 
使用sign_test.bat脚本，您可以对VeraCrypt可执行文件进行签名。这是必要的，因为Windows只接受由签名的证书颁发机构信任的驱动程序。
 Since you did not use the official VeraCrypt signing certificate to  sign your code, but a public development version, you have to import and therefore trust the certificates used. 	
由于您没有使用VeraCrypt官方签名证书来签名您的代码，而是使用公共开发版本，因此您必须导入并信任所使用的证书。

1. ​				Open the folder "src/Signing" 		
   打开文件夹“src/Signing”

2. ​				Import the following certificates to your Local Machine Certificate storage, by double clicking them: 			

   
   通过双击以下证书将其导入本地计算机证书存储：

   - GlobalSign_R3Cross.cer
   - GlobalSign_SHA256_EV_CodeSigning_CA.cer
   - TestCertificates/idrix_codeSign.pfx
     测试证书/idrix_codeSign.pfx
   - TestCertificates/idrix_Sha256CodeSign.pfx
   - TestCertificates/idrix_SHA256TestRootCA.crt
   - TestCertificates/idrix_TestRootCA.crt

   ​				Note: If prompted, the password for .pfx certificates is 

   idrix

   . 		

   
   注意：如果出现提示，.pfx证书的密码为**idrix**。



[Known Issues 已知问题](https://veracrypt.fr/en/CompilingGuidelineWin.html#KnownIssues)

​		

- This distribution package is damaged
  这个分发包损坏了

  

  ​				On Windows 10 or higher you might get the error message above. In order to avoid this, you will need to:

  
  在Windows 10或更高版本上，您可能会收到上面的错误消息。为了避免这种情况，您需要：

  - Double-check the installation of the root certificate that issued the test code  signing certificate in the "Local Machine Trusted Root Certification  Authorities" store.
    在“本地计算机受信任的根证书颁发机构”存储区中仔细检查颁发测试代码签名证书的根证书的安装。
  - Compute SHA512 fingerprint of the test code signing certificate and update the  gpbSha512CodeSignCertFingerprint array in the file  "src/Common/Dlgcode.c" accordingly.
    计算测试代码签名证书的SHA 512指纹，并相应更新文件“src/Common/Dlgcode. c”中的gpbSha 512 CodeSignCertFingerprint数组。

  ​				Please see 

  https://sourceforge.net/p/veracrypt/discussion/technical/thread/83d5a2d6e8/#db12

   for further details.

  
  请访问https://sourceforge.net/p/veracrypt/discussion/technical/thread/83d5a2d6e8/#db12了解更多详情。

  ​				Another approach is to disable the signature verification in the  VeraCrypt code. This should be done only for testing purposes and not  for production use: 			

  
  另一种方法是在VeraCrypt代码中禁用签名验证。这只能用于测试目的，不能用于生产用途：

  1. ​						Open the file "src/Common/Dlgcode.c" 				
     打开文件“src/Common/Dlgcode. c”

  2. ​						Look for the function "VerifyModuleSignature" 				
     查找函数“VerifyModuleSignature”

  3. ​						Replace the following lines: 

     
     替换以下行：

     ​						Find:

      寻找：

     ​						if (!IsOSAtLeast (WIN_10)) 
     如果（！IsOSAtLeast（WIN_10））
      					return TRUE; 					

     ​						Replace:

      替换：

     ​						return TRUE; 					

  4. ​						Compile the VeraCrypt code again 				
     再次编译VeraCrypt代码

- Driver Installation Failure during VeraCrypt Setup from Custom Builds
  从自定义版本安装VeraCrypt时驱动程序安装失败

  

  ​				Windows validates the signature for every driver which is going to be installed.

  
  Windows验证将要安装的每个驱动程序的签名。

  ​				For security reasons, Windows allows only drivers signed by Microsoft to load.

  
  出于安全原因，Windows只允许加载Microsoft签名的驱动程序。

  ​				So, when using a custom build:

  
  因此，当使用自定义构建时：

  - If you have not modified the VeraCrypt driver source code, you can use the Microsoft-signed drivers included in the VeraCrypt source code (under  "src\Release\Setup Files").
    如果您还没有修改VeraCrypt驱动程序源代码，您可以使用VeraCrypt源代码中包含的Microsoft签名驱动程序（在“src\Release\Setup Files”下）。
  - If you have made modifications, **you will need to boot Windows into "Test Mode"**. This mode allows Windows to load drivers that aren't signed by  Microsoft. However, even in "Test Mode", there are certain requirements  for signatures, and failures can still occur due to reasons discussed  below.
    如果您进行了修改，**您将需要靴子Windows进入“测试模式”**.此模式允许Windows加载未经Microsoft签名的驱动程序。然而，即使在“测试模式”下，对签名也有一定的要求，由于下面讨论的原因，仍然可能发生故障。

  ​				Potential Causes for Installation Failure under "Test Mode": 			

  
  “测试模式”下安装失败的潜在原因：

  1. The certificate used for signing is not trusted by Windows
     Windows不信任用于签名的证书

     ​						You can verify if you are affected by checking the properties of the executable: 					

     
     您可以通过检查可执行文件的属性来验证您是否受到影响：

     1. ​								Make a right click on the VeraCrypt Setup executable: "src/Release/Setup Files/VeraCrypt Setup 1.XX.exe" 						
        右键单击VeraCrypt安装程序可执行文件：“src/Release/Setup Files/VeraCrypt Setup 1.XX.exe”
     2. ​								Click on properties 						 单击属性
     3. ​	 							Go to the top menu "Digital Signatures". Her you will find two signatures in the Signature list 						
        进入顶部菜单“数字签名”。您将在签名列表中找到两个签名
     4. 
        如果标题显示“无法验证签名中的证书”，则表示没有正确导入相应的签名证书。
     5. 
     6. 
        点击“查看证书”，然后点击“安装证书.“将证书导入本地计算机证书存储。对于根证书，您可能需要选择“将所有证书放入以下存储”，然后选择“受信任的根证书颁发机构”存储。
     7. 
     8. 
     9. 
     10. ​						

  2. ​						**The driver was modified after the signing process.
     签名过程后修改了驱动程序。** 
      					In this case, please use the script "src/Signing/sign_test.bat" to sign your code again with the test certificates 				
     在这种情况下，请使用脚本“src/Signing/sign_test.bat”使用测试证书再次对代码进行签名

This guide describes how to set up a Linux System to build VeraCrypt from source and how to perform compilation. 
本指南介绍如何设置Linux系统从源代码构建VeraCrypt以及如何执行编译。
 The procedure for a Ubuntu 22.04 LTS system is described here as an example, the procedure for other Linux systems is analogous. 
这里以Ubuntu 22.04 LTS系统为例进行描述，其他Linux系统的过程类似。

The following components are required for compiling VeraCrypt: 
编译VeraCrypt需要以下组件：

1. GNU Make
2. GNU C/C++ Compiler GNU C/C++编译器
3. YASM 1.3.0 简体中文
4. pkg-config
5. wxWidgets 3.x shared library and header files installed by the system or wxWidgets 3.x library source code 
   wxWidgets 3.x共享库和头文件系统安装或wxWidgets 3.x库源代码
6. FUSE library and header files
   FUSE库和头文件
7. PCSC-lite library and header files
   PCSC-lite库和头文件

Below are the procedure steps. Clicking on any of the link takes directly to the related step: 
以下是程序步骤。点击任何一个链接都可以直接进入相关步骤：

- **[Installation of GNU Make 安装GNU Make](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfGNUMake)**
- **[Installation of GNU C/C++ Compiler
  安装GNU C/C++编译器](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfGNUCompiler)**
- **[Installation of YASM 安装YASM](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfYASM)**
- **[Installation of pkg-config
  安装pkg-config](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfPKGConfig)**
- **[Installation of wxWidgets 3.2
  安装wxWidgets 3.2](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfwxWidgets)**
- **[Installation of libfuse 安装libfuse](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfFuse)**
- **[Installation of libpcsclite
  安装libpcsclite](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfPCSCLite)**
- **[Download VeraCrypt 下载VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineLinux.html#DownloadVeraCrypt)**
- **[Compile VeraCrypt 编译VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineLinux.html#CompileVeraCrypt)**



They can also be performed by running the below list of commands in a terminal or by copying them to a script:
它们也可以通过在终端中运行下面的命令列表或将它们复制到脚本中来执行：
 ` sudo apt update  sudo apt install -y build-essential yasm pkg-config libwxgtk3.0-gtk3-dev  sudo apt install -y libfuse-dev git libpcsclite-dev  git clone https://github.com/veracrypt/VeraCrypt.git  cd ~/VeraCrypt/src  make `

[Installation of GNU Make 安装GNU Make](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfGNUMake)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install build-essential 			` 		



[Installation of GNU C/C++ Compiler
安装GNU C/C++编译器](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfGNUCompiler)

 If the build-essential were already installed in the step before, this step can be skipped. 	
如果在之前的步骤中已经安装了基本构建，则可以跳过此步骤。

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install build-essential 			` 		



[Installation of YASM 安装YASM](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfYASM)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install yasm 			` 		



[Installation of pkg-config
安装pkg-config](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfPKGConfig)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install pkg-config 			` 		



[Installation of wxWidgets 3.2
安装wxWidgets 3.2](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfwxWidgets)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			`		 			sudo apt update  			sudo apt install libwxgtk3.0-gtk3-dev  			` 		



[Installation of libfuse 安装libfuse](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfFuse)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install libfuse-dev 			` 		



[Installation of libpcsclite
安装libpcsclite](https://veracrypt.fr/en/CompilingGuidelineLinux.html#InstallationOfPCSCLite)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 				sudo apt update  				sudo apt install libpcsclite-dev 			` 		



[Download VeraCrypt 下载VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineLinux.html#DownloadVeraCrypt)

​		

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			` 			sudo apt update  			sudo apt install git  			git clone https://github.com/veracrypt/VeraCrypt.git 			` 		



[Compile VeraCrypt 编译VeraCrypt](https://veracrypt.fr/en/CompilingGuidelineLinux.html#CompileVeraCrypt)

 Remarks:  备注：
 

- ​			By default, a universal executable supporting both graphical and text user interface (through the switch --text) is built. 
  默认情况下，构建一个支持图形和文本用户界面（通过开关--text）的通用可执行文件。
   		On Linux, a console-only executable, which requires no GUI library, can be built using the 'NOGUI' parameter. 
  在Linux上，可以使用“NOGUI”参数构建仅控制台可执行文件，该文件不需要GUI库。
   		For that, you need to dowload wxWidgets sources, extract them to a  location of your choice and then run the following commands: 
  为此，您需要下载wxWidgets源代码，将它们提取到您选择的位置，然后运行以下命令：
   		` 		make NOGUI=1 WXSTATIC=1 WX_ROOT=/path/to/wxWidgetsSources wxbuild  		make NOGUI=1 WXSTATIC=1 WX_ROOT=/path/to/wxWidgetsSources 		` 	
- ​			If you are not using the system wxWidgets library, you will have to  download and use wxWidgets sources like the remark above but this time  the following commands should be run to build GUI version of VeraCrypt  (NOGUI is not specified): 
  如果你没有使用系统wxWidgets库，你需要下载并使用wxWidgets源代码，就像上面的注释一样，但是这次应该运行以下命令来构建GUI版本的VeraCrypt（没有指定NOGUI）：
   		` 		make WXSTATIC=1 WX_ROOT=/path/to/wxWidgetsSources wxbuild  		make WXSTATIC=1 WX_ROOT=/path/to/wxWidgetsSources 		` 	

​	Steps: 	 步骤：

1. ​				Open a terminal 		 打开一个终端
2. ​				Execute the following commands: 
   执行以下命令：
    			`		 			cd ~/VeraCrypt/src  			make 			` 		
3. ​				If successful, the VeraCrypt executable should be located in the directory 'Main'. 		
   如果成功，VeraCrypt可执行文件应该位于'Main'目录。