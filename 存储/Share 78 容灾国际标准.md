# Share 78 容灾国际标准

[TOC]

Share78 容灾国际标准，也称 SHARE 78 定义的七级业务恢复级别，恢复时间也可以从几天到小时级到分钟级、秒级或零数据丢失等。

## 分级原则

1. 备份/恢复的范围
2. 灾难恢复计划的状态
3. 应用地点与备份地点之间的距离
4. 应用地点与备份地点如何相互连接
5. 数据是怎样在两个地点之间传送的
6. 允许有多少数据丢失
7. 怎样保证备份地点数据的更新
8. 备份地点可以开始备份工作的能力

根据以上8条原则，国际标准SHARE 78 对容灾系统的定义有七个层次：从最简单的仅在本地进行磁带备份，到将备份的磁带存储在异地，再到建立应用系统实时切换的异地备份系统，恢复时间也可以从几天到小时级到分钟级、秒级或零数据丢失等。

目前针对这七个层次，都有相应的容灾方案。

## 层次说明

### 0级：无异地备份

0等级容灾方案数据仅在本地进行备份，没有在异地备份数据，未制定灾难恢复计划。这种方式是成本最低的灾难恢复解决方案，但不具备真正灾难恢复能力。

在这种容灾方案中，最常用的是备份管理软件加上磁带机，可以是手工加载磁带机或自动加载磁带机。它是所有容灾方案的基础，从个人用户到企业级用户都广泛采用了这种方案。其特点是用户投资较少，技术实现简单。缺点是一旦本地发生毁灭性灾难，将丢失全部的本地备份数据，业务无法恢复。

### 1级：实现异地备份

第1级容灾方案是将关键数据备份到本地磁带介质上，然后送往异地保存，但异地没有可用的备份中心、备份数据处理系统和备份网络通信系统，未制定灾难恢复计划。灾难发生后，使用新的主机，利用异地数据备份介质（磁带）将数据恢复起来。

这种方案成本较低，运用本地备份管理软件，可以在本地发生毁灭性灾难后，恢复从异地运送过来的备份数据到本地，进行业务恢复。但难以管理，即很难知道什么数据在什么地方，恢复时间长短依赖于何时硬件平台能够被提供和准备好。以前被许多进行关键业务生产的大企业所广泛采用，作为异地容灾的手段。目前，这一等级方案在许多中小网站和中小企业用户中采用较多。对于要求快速进行业务恢复和海量数据恢复的用户，这种方案是不能够被接受的。

### 2级：热备份站点备份

第2级容灾方案是将关键数据进行备份并存放到异地，制定有相应灾难恢复计划，具有热备份能力的站点灾难恢复。一旦发生灾难，利用热备份主机系统将数据恢复。它与第1级容灾方案的区别在于异地有一个热备份站点，该站点有主机系统，平时利用异地的备份管理软件将运送到异地的数据备份介质（磁带）上的数据备份到主机系统。当灾难发生时可以快速接管应用，恢复生产。

由于有了热备中心，用户投资会增加，相应的管理人员要增加。技术实现简单，利用异地的热备份系统，可以在本地发生毁灭性灾难后，快速进行业务恢复。但这种容灾方案由于备份介质是采用交通运输方式送往异地，异地热备中心保存的数据是上一次备份的数据，可能会有几天甚至几周的数据丢失。这对于关键数据的容灾是不能容忍的。

### 3级：在线数据恢复

第3级容灾方案是通过网络将关键数据进行备份并存放至异地，制定有相应灾难恢复计划，有备份中心，并配备部分数据处理系统及网络通信系统。该等级方案特点是用电子数据传输取代交通工具传输备份数据，从而提高了灾难恢复的速度。利用异地的备份管理软件将通过网络传送到异地的数据备份到主机系统。一旦灾难发生，需要的关键数据通过网络可迅速恢复，通过网络切换，关键应用恢复时间可降低到一天或小时级。这一等级方案由于备份站点要保持持续运行，对网络的要求较高，因此成本相应有所增加。

### 4级：定时数据备份

第4级容灾方案是在第3级容灾方案的基础上，利用备份管理软件自动通过通信网络将部分关键数据定时备份至异地，并制定相应的灾难恢复计划。一旦灾难发生，利用备份中心已有资源及异地备份数据恢复关键业务系统运行。

这一等级方案特点是备份数据是采用自动化的备份管理软件备份到异地，异地热备中心保存的数据是定时备份的数据，根据备份策略的不同，数据的丢失与恢复时间达到天或小时级。由于对备份管理软件设备和网络设备的要求较高，因此投入成本也会增加。但由于该级别备份的特点，业务恢复时间和数据的丢失量还不能满足关键行业对关键数据容灾的要求。

### 5级：实时数据备份

第5级容灾方案在前面几个级别的基础上使用了硬件的镜像技术和软件的数据复制技术，也就是说，可以实现在应用站点与备份站点的数据都被更新。数据在两个站点之间相互镜像，由远程异步提交来同步，因为关键应用使用了双重在线存储，所以在灾难发生时，仅仅很小部分的数据被丢失，恢复的时间被降低到了分钟级或秒级。由于对存储系统和数据复制软件的要求较高，所需成本也大大增加。

这一等级的方案由于既能保证不影响当前交易的进行，又能实时复制交易产生的数据到异地，所以这一层次的方案是目前应用最广泛的一类，正因为如此，许多厂商都有基于自己产品的容灾解决方案。如存储厂商EMC等推出的基于智能存储服务器的数据远程拷贝；系统复制软件提供商VERITAS等提供的基于系统软件的数据远程复制；数据库厂商Oracle和Sybase提供的数据库复制方案等。但这些方案有一个不足之处就是异地的备份数据是处于备用（Standby）备份状态而不是实时可用的数据，这样灾难发生后需要一定时间来进行业务恢复。更为理想的应该是备份站点不仅仅是一个分离的备份系统，而且还处于活动状态，能够提供生产应用服务，所以可以提供快速的业务接管，而备份数据则可以双向传输，数据的丢失与恢复时间达到分钟甚至秒级。据了解，目前DSG公司的RealSync全局复制软件能够提供这一功能。

### 6级：零数据丢失

第6级容灾方案是灾难恢复中最昂贵的方式，也是速度最快的恢复方式，它是灾难恢复的最高级别，利用专用的存储网络将关键数据同步镜像至备份中心，数据不仅在本地进行确认，而且需要在异地（备份）进行确认。因为，数据是镜像地写到两个站点，所以灾难发生时异地容灾系统保留了全部的数据，实现零数据丢失。

这一方案在本地和远程的所有数据被更新的同时，利用了双重在线存储和完全的网络切换能力，不仅保证数据的完全一致性，而且存储和网络等环境具备了应用的自动切换能力。一旦发生灾难，备份站点不仅有全部的数据，而且应用可以自动接管，实现零数据丢失的备份。通常在这两个系统中的光纤设备连接中还提供冗余通道，以备工作通道出现故障时及时接替工作，当然由于对存储系统和存储系统专用网络的要求很高，用户的投资巨大。采取这种容灾方式的用户主要是资金实力较为雄厚的大型企业和电信级企业。但在实际应用过程中，由于完全同步的方式对生产系统的运行效率会产生很大影响，所以适用于生产交易较少或非实时交易的关键数据系统，目前采用该级别容灾方案的用户还很少。

## Share 简介

是一个计算机技术研究组织，成立于1955年，合作伙伴包括IBM等众多公司，有上千志愿者，目前提供各种IT科技类的培训、咨询等服务。

Share78是该组织1992年3月在Anaheim举行的一次盛会的编号。（SHARE78, Anaheim, 1992, in session M028, the Automated Remote Site Recovery Task Force presented seven tiers of recoverability），在这次会议上，制定了一个有关远程自动恢复解决方案的标准，后来业界一直沿用此标准，作为容灾标准，称为Share78容灾国际标准。
