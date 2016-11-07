# mke2fs

    mke2fs [-c|-l filename] [-b block-size] [-f fragment-size]
        [-i bytes-per-inode] [-I inode-size] [-J journal-options]
        [-G meta group size] [-N number-of-inodes]
        [-m reserved-blocks-percentage] [-o creator-os]
        [-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]
        [-O feature[,...]] [-r fs-revision] [-E extended-option[,...]]
        [-T fs-type] [-U UUID] [-jnqvFKSV] device [blocks-count]

-b:指定区块大小，单位为字节。  
-c:检查是否有损坏的区块。  
-f:指定不连续区段的大小，单位为字节。  
-F:不管指定的设备为何，强制执行mke2fs。  
-i:指定"字节/inode"的比例。  
-N:指定要建立的inode数目。  
-l:从指定的文件中，读取文件西中损坏区块的信息。  
-L:设置文件系统的标签名称。  
-m:指定给管理员保留区块的比例，预设为5%。  
-M:记录最后一次挂入的目录。  
-q:执行时不显示任何信息。  
-r:指定要建立的ext2文件系统版本。  
-R:设置磁盘阵列参数。  
-S:仅写入superblock与group descriptors，而不更改inode able inode bitmap以及block bitmap。  
-v:执行时显示详细信息。  
-V:显示版本信息。  
-T:指定文件系统类型  
