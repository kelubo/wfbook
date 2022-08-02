# SELinux![img](../Image/s/selinux.png)

[TOC]

## 概述

http://www.nsa.gov/research/selinux/

Security Enhanced Linux (SELinux)，由美国国家安全局（NSA）贡献的，为 Linux 内核子系统引入了一个健壮的强制控制访问架构。SELinux 属于 MAC 强制访问控制（Mandatory Access Control）—— 即让系统中的各个服务进程都受到约束，即仅能访问到所需要的文件。

最初设计的目标：避免资源的误用。





- 傳統的檔案權限與帳號關係：自主式存取控制, DAC

我們[第十三章](https://linux.vbird.org/linux_basic/0410accountmanager.php)的內容，知道系統的帳號主要分為系統管理員  	(root) 與一般用戶，而這兩種身份能否使用系統上面的檔案資源則與 rwx 的權限設定有關。 	不過你要注意的是，各種權限設定對 root 是無效的。因此，當某個程序想要對檔案進行存取時， 	系統就會根據該程序的擁有者/群組，並比對檔案的權限，若通過權限檢查，就可以存取該檔案了。

這種存取檔案系統的方式被稱為『自主式存取控制 (Discretionary Access Control,  	DAC)』，基本上，就是依據程序的擁有者與檔案資源的 rwx 權限來決定有無存取的能力。 	不過這種 DAC 的存取控制有幾個困擾，那就是：

- root 具有最高的權限：如果不小心某支程序被有心人士取得， 	且該程序屬於 root 的權限，那麼這支程序就可以在系統上進行任何資源的存取！真是要命！

  

- 使用者可以取得程序來變更檔案資源的存取權限：如果你不小心將某個目錄的權限設定為  	777 ，由於對任何人的權限會變成 rwx ，因此該目錄就會被任何人所任意存取！

這些問題是非常嚴重的！尤其是當你的系統是被某些漫不經心的系統管理員所掌控時！她們甚至覺得目錄權限調為 777  	也沒有什麼了不起的危險哩...



- 以政策規則訂定特定程序讀取特定檔案：委任式存取控制, MAC

現在我們知道 DAC 的困擾就是當使用者取得程序後，他可以藉由這支程序與自己預設的權限來處理他自己的檔案資源。 	萬一這個使用者對 Linux 系統不熟，那就很可能會有資源誤用的問題產生。為了避免 DAC 容易發生的問題，因此  	SELinux 導入了委任式存取控制 (Mandatory Access Control, MAC) 的方法！

委任式存取控制 (MAC) 有趣啦！他可以針對特定的程序與特定的檔案資源來進行權限的控管！ 	也就是說，即使你是 root ，那麼在使用不同的程序時，你所能取得的權限並不一定是 root ， 	而得要看當時該程序的設定而定。如此一來，我們針對控制的『主體』變成了『程序』而不是使用者喔！ 	此外，這個主體程序也不能任意使用系統檔案資源，因為每個檔案資源也有針對該主體程序設定可取用的權限！ 	如此一來，控制項目就細的多了！但整個系統程序那麼多、檔案那麼多，一項一項控制可就沒完沒了！ 	所以 SELinux 也提供一些預設的政策 (Policy) ，並在該政策內提供多個規則 (rule) ，讓你可以選擇是否啟用該控制規則！

在委任式存取控制的設定下，我們的程序能夠活動的空間就變小了！舉例來說， WWW 伺服器軟體的達成程序為 httpd 這支程式， 	而預設情況下， httpd 僅能在 /var/www/ 這個目錄底下存取檔案，如果 httpd 這個程序想要到其他目錄去存取資料時， 	除了規則設定要開放外，目標目錄也得要設定成 httpd 可讀取的模式 (type) 才行喔！限制非常多！ 	所以，即使不小心 httpd 被 cracker 取得了控制權，他也無權瀏覽 /etc/shadow 等重要的設定檔喔！

簡單的來說，針對 Apache 這個 WWW 網路服務使用 DAC 或 MAC 的結果來說，兩者間的關係可以使用下圖來說明。 	底下這個圖示取自 Red Hat 訓練教材，真的是很不錯～所以被鳥哥借用來說明一下！



![使用 DAC/MAC 產生的不同結果，以 Apache 為例說明](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/dac_mac.jpg)

圖16.5.1、使用 DAC/MAC 產生的不同結果，以 Apache 為例說明

左圖是沒有 SELinux 的 DAC 存取結果，apache 這隻 root 所主導的程序，可以在這三個目錄內作任何檔案的新建與修改～ 	相當麻煩～右邊則是加上 SELinux 的 MAC 管理的結果，SELinux 僅會針對 Apache 這個『 process 』放行部份的目錄， 	其他的非正規目錄就不會放行給 Apache 使用！因此不管你是誰，就是不能穿透 MAC 的框框！這樣有比較了解乎？



### 16.5.2 SELinux 的運作模式

再次的重複說明一下，SELinux 是透過 MAC 的方式來控管程序，他控制的主體是程序， 	而目標則是該程序能否讀取的『檔案資源』！所以先來說明一下這些咚咚的相關性啦！([註4](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#ps4))



- 主體 (Subject)：
   	SELinux 主要想要管理的就是程序，因此你可以將『主體』跟本章談到的 process 劃上等號；

- 目標 (Object)：
   	主體程序能否存取的『目標資源』一般就是檔案系統。因此這個目標項目可以等檔案系統劃上等號；

- 政策 (Policy)：

  ​		由於程序與檔案數量龐大，因此 SELinux 會依據某些服務來制訂基本的存取安全性政策。這些政策內還會有詳細的規則 (rule) 	來指定不同的服務開放某些資源的存取與否。在目前的 CentOS 7.x 裡面僅有提供三個主要的政策，分別是： 	

  - targeted：針對網路服務限制較多，針對本機限制較少，是預設的政策；
  - minimum：由 target 修訂而來，僅針對選擇的程序來保護！
  - mls：完整的 SELinux 限制，限制方面較為嚴格。

  ​		建議使用預設的 targeted 政策即可。

- 安全性本文 (security context)：
   	我們剛剛談到了主體、目標與政策面，但是主體能不能存取目標除了政策指定之外，主體與目標的安全性本文必須一致才能夠順利存取。 	這個安全性本文 (security context) 有點類似檔案系統的 rwx 啦！安全性本文的內容與設定是非常重要的！ 	如果設定錯誤，你的某些服務(主體程序)就無法存取檔案系統(目標資源)，當然就會一直出現『權限不符』的錯誤訊息了！

由於 SELinux 重點在保護程序讀取檔案系統的權限，因此我們將上述的幾個說明搭配起來，繪製成底下的流程圖，比較好理解：



![SELinux 運作的各元件之相關性](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/selinux_1.gif)

圖16.5.2、SELinux 運作的各元件之相關性(本圖參考小州老師的上課講義)

上圖的重點在『主體』如何取得『目標』的資源存取權限！ 	由上圖我們可以發現，(1)主體程序必須要通過 SELinux 政策內的規則放行後，就可以與目標資源進行安全性本文的比對， 	(2)若比對失敗則無法存取目標，若比對成功則可以開始存取目標。問題是，最終能否存取目標還是與檔案系統的 rwx  	權限設定有關喔！如此一來，加入了 SELinux 之後，出現權限不符的情況時，你就得要一步一步的分析可能的問題了！



- 安全性本文 (Security Context)

CentOS 7.x 的 target 政策已經幫我們制訂好非常多的規則了，因此你只要知道如何開啟/關閉某項規則的放行與否即可。 	那個安全性本文比較麻煩！因為你可能需要自行設定檔案的安全性本文呢！為何需要自行設定啊？ 	舉例來說，你不也常常進行檔案的 rwx 的重新設定嗎？這個安全性本文你就將他想成  	SELinux 內必備的 rwx 就是了！這樣比較好理解啦。

安全性本文存在於主體程序中與目標檔案資源中。程序在記憶體內，所以安全性本文可以存入是沒問題。 	那檔案的安全性本文是記錄在哪裡呢？事實上，安全性本文是放置到檔案的 inode 	內的，因此主體程序想要讀取目標檔案資源時，同樣需要讀取 inode ， 	在 inode 內就可以比對安全性本文以及 rwx 等權限值是否正確，而給予適當的讀取權限依據。

那麼安全性本文到底是什麼樣的存在呢？我們先來看看 /root 底下的檔案的安全性本文好了。 	觀察安全性本文可使用『 ls -Z 』去觀察如下：(注意：你必須已經啟動了 SELinux  	才行！若尚未啟動，這部份請稍微看過一遍即可。底下會介紹如何啟動 SELinux 喔！)

```
# 先來觀察一下 root 家目錄底下的『檔案的 SELinux 相關資訊』
[root@study ~]# ls -Z
-rw-------. root root system_u:object_r:admin_home_t:s0     anaconda-ks.cfg
-rw-r--r--. root root system_u:object_r:admin_home_t:s0     initial-setup-ks.cfg
-rw-r--r--. root root unconfined_u:object_r:admin_home_t:s0 regular_express.txt
# 上述特殊字體的部分，就是安全性本文的內容！鳥哥僅列出數個預設的檔案而已，
# 本書學習過程中所寫下的檔案則沒有列在上頭喔！
```

如上所示，安全性本文主要用冒號分為三個欄位，這三個欄位的意義為：

```
Identify:role:type
身份識別:角色:類型
```

這三個欄位的意義仔細的說明一下吧：

- 身份識別 (Identify)：

相當於帳號方面的身份識別！主要的身份識別常見有底下幾種常見的類型：

- unconfined_u：不受限的用戶，也就是說，該檔案來自於不受限的程序所產生的！一般來說，我們使用可登入帳號來取得 bash 之後， 		預設的 bash 環境是不受 SELinux 管制的～因為 bash 並不是什麼特別的網路服務！因此，在這個不受 SELinux 所限制的 bash 程序所產生的檔案， 		其身份識別大多就是 unconfined_u 這個『不受限』用戶囉！
- system_u：系統用戶，大部分就是系統自己產生的檔案囉！

基本上，如果是系統或軟體本身所提供的檔案，大多就是 system_u 這個身份名稱，而如果是我們用戶透過 bash  		自己建立的檔案，大多則是不受限的 unconfined_u 身份～如果是網路服務所產生的檔案，或者是系統服務運作過程產生的檔案，則大部分的識別就會是 system_u 囉！

因為鳥哥這邊教大家使用文字界面來產生許多的資料，因此你看上面的三個檔案中，系統安裝主動產生的  		anaconda-ks.cfs 及 initial-setup-ks.cfg 就會是 system_u，而我們自己從網路上面抓下來的 regular_express.txt 就會是 unconfined_u 這個識別啊！

- 角色 (Role)：

透過角色欄位，我們可以知道這個資料是屬於程序、檔案資源還是代表使用者。一般的角色有：

- object_r：代表的是檔案或目錄等檔案資源，這應該是最常見的囉；
- system_r：代表的就是程序啦！不過，一般使用者也會被指定成為 system_r 喔！

你也會發現角色的欄位最後面使用『 _r 』來結尾！因為是 role 的意思嘛！

- 類型 (Type) (最重要！)：

在預設的 targeted 政策中， Identify 與 Role 欄位基本上是不重要的！重要的在於這個類型 (type) 欄位！ 		基本上，一個主體程序能不能讀取到這個檔案資源，與類型欄位有關！而類型欄位在檔案與程序的定義不太相同，分別是：

- type：在檔案資源 (Object) 上面稱為類型 (Type)；
- domain：在主體程序 (Subject) 則稱為領域 (domain) 了！

domain 需要與 type 搭配，則該程序才能夠順利的讀取檔案資源啦！



- 程序與檔案 SELinux type 欄位的相關性

那麼這三個欄位如何利用呢？首先我們來瞧瞧主體程序在這三個欄位的意義為何！透過身份識別與角色欄位的定義， 	我們可以約略知道某個程序所代表的意義喔！先來動手瞧一瞧目前系統中的程序在 SELinux 底下的安全本文為何？

```
# 再來觀察一下系統『程序的 SELinux 相關資訊』
[root@study ~]# ps -eZ
LABEL                             PID TTY          TIME CMD
system_u:system_r:init_t:s0         1 ?        00:00:03 systemd
system_u:system_r:kernel_t:s0       2 ?        00:00:00 kthreadd
system_u:system_r:kernel_t:s0       3 ?        00:00:00 ksoftirqd/0
.....(中間省略).....
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 31513 ? 00:00:00 sshd
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 31535 pts/0 00:00:00 bash
# 基本上程序主要就分為兩大類，一種是系統有受限的 system_u:system_r，另一種則可能是用戶自己的，
# 比較不受限的程序 (通常是本機用戶自己執行的程式)，亦即是 unconfined_u:unconfined_r 這兩種！
```

基本上，這些對應資料在 targeted 政策下的對應如下：

| 身份識別     | 角色         | 該對應在 targeted 的意義                                     |
| ------------ | ------------ | ------------------------------------------------------------ |
| unconfined_u | unconfined_r | 一般可登入使用者的程序囉！比較沒有受限的程序之意！大多數都是用戶已經順利登入系統 (不論是網路還是本機登入來取得可用的 shell) 後， 所用來操作系統的程序！如 bash, X window 相關軟體等。 |
| system_u     | system_r     | 由於為系統帳號，因此是非交談式的系統運作程序，大多數的系統程序均是這種類型！ |

但就如上所述，在預設的 target 政策下，其實最重要的欄位是類型欄位 (type)， 	主體與目標之間是否具有可以讀寫的權限，與程序的 domain 及檔案的 type 有關！這兩者的關係我們可以使用 crond 以及他的設定檔來說明！ 	亦即是 /usr/sbin/crond, /etc/crontab, /etc/cron.d 等檔案來說明。 	首先，看看這幾個咚咚的安全性本文內容先：

```
# 1. 先看看 crond 這個『程序』的安全本文內容：
[root@study ~]# ps -eZ | grep cron
system_u:system_r:crond_t:s0-s0:c0.c1023 1338 ? 00:00:01 crond
system_u:system_r:crond_t:s0-s0:c0.c1023 1340 ? 00:00:00 atd
# 這個安全本文的類型名稱為 crond_t 格式！

# 2. 再來瞧瞧執行檔、設定檔等等的安全本文內容為何！
[root@study ~]# ll -Zd /usr/sbin/crond /etc/crontab /etc/cron.d
drwxr-xr-x. root root system_u:object_r:system_cron_spool_t:s0 /etc/cron.d
-rw-r--r--. root root system_u:object_r:system_cron_spool_t:s0 /etc/crontab
-rwxr-xr-x. root root system_u:object_r:crond_exec_t:s0 /usr/sbin/crond
```

當我們執行 /usr/sbin/crond 之後，這個程式變成的程序的 domain 類型會是 crond_t 這一個～而這個 crond_t 能夠讀取的設定檔則為 system_cron_spool_t  	這種的類型。因此不論 /etc/crontab, /etc/cron.d 以及 /var/spool/cron 都會是相關的 SELinux 類型 (/var/spool/cron 為 user_cron_spool_t)。 	文字看起來不太容易了解，我們使用圖示來說明這幾個東西的關係！



![主體程序取得的 domain 與目標檔案資源的 type 相互關係](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/centos7_selinux_2.jpg)

圖16.5.3、主體程序取得的 domain 與目標檔案資源的 type 相互關係以 crond 為例

上圖的意義我們可以這樣看的：

1. 首先，我們觸發一個可執行的目標檔案，那就是具有 crond_exec_t 這個類型的 /usr/sbin/crond 檔案；
2. 該檔案的類型會讓這個檔案所造成的主體程序 (Subject) 具有 crond 這個領域 (domain)， 	我們的政策針對這個領域已經制定了許多規則，其中包括這個領域可以讀取的目標資源類型；
3. 由於 crond domain 被設定為可以讀取 system_cron_spool_t 這個類型的目標檔案 (Object)， 	因此你的設定檔放到 /etc/cron.d/ 目錄下，就能夠被 crond 那支程序所讀取了；
4. 但最終能不能讀到正確的資料，還得要看 rwx 是否符合 Linux 權限的規範！

上述的流程告訴我們幾個重點，第一個是政策內需要制訂詳細的 domain/type 相關性；第二個是若檔案的 type 設定錯誤， 	那麼即使權限設定為 rwx 全開的 777 ，該主體程序也無法讀取目標檔案資源的啦！不過如此一來， 	也就可以避免使用者將他的家目錄設定為 777 時所造成的權限困擾。

真的是這樣嗎？沒關係～讓我們來做個測試練習吧！就是，萬一你的 crond 設定檔的 SELinux 並不是 system_cron_spool_t 時， 	該設定檔真的可以順利的被讀取運作嗎？來看看底下的範例！

```
# 1. 先假設你因為不熟的緣故，因此是在『root 家目錄』建立一個如下的 cron 設定：
[root@study ~]# vim checktime
10 * * * * root sleep 60s

# 2. 檢查後才發現檔案放錯目錄了，又不想要保留副本，因此使用 mv 移動到正確目錄：
[root@study ~]# mv checktime /etc/cron.d
[root@study ~]# ll /etc/cron.d/checktime
-rw-r--r--. 1 root root 27 Aug  7 18:41 /etc/cron.d/checktime
# 仔細看喔，權限是 644 ，確定沒有問題！任何程序都能夠讀取喔！

# 3. 強制重新啟動 crond ，然後偷看一下登錄檔，看看有沒有問題發生！
[root@study ~]# systemctl restart crond
[root@study ~]# tail /var/log/cron
Aug  7 18:46:01 study crond[28174]: ((null)) Unauthorized SELinux context=system_u:system_r:
system_cronjob_t:s0-s0:c0.c1023 file_context=unconfined_u:object_r:admin_home_t:s0 
(/etc/cron.d/checktime)
Aug  7 18:46:01 study crond[28174]: (root) FAILED (loading cron table)
# 上面的意思是，有錯誤！因為原本的安全本文與檔案的實際安全本文無法搭配的緣故！
```

您瞧瞧～從上面的測試案例來看，我們的設定檔確實沒有辦法被 crond 這個服務所讀取喔！而原因在登錄檔內就有說明， 	主要就是來自 SELinux 安全本文 (context) type 的不同所致喔！沒辦法讀就沒辦法讀，先放著～後面再來學怎麼處理這問題吧！



### 16.5.3 SELinux 三種模式的啟動、關閉與觀察

並非所有的 Linux distributions 都支援 SELinux 的，所以你必須要先觀察一下你的系統版本為何！ 	鳥哥這裡介紹的 CentOS 7.x 本身就有支援 SELinux 啦！所以你不需要自行編譯 SELinux 到你的 Linux 核心中！ 	目前 SELinux 依據啟動與否，共有三種模式，分別如下：

- enforcing：強制模式，代表 SELinux 運作中，且已經正確的開始限制 domain/type 了；
- permissive：寬容模式：代表 SELinux 運作中，不過僅會有警告訊息並不會實際限制  	domain/type 的存取。這種模式可以運來作為 SELinux 的 debug 之用；
- disabled：關閉，SELinux 並沒有實際運作。

這三種模式跟[圖16.5.2](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#fig16.5.2)之間的關係如何呢？我們前面不是談過主體程序需要經過政策規則、安全本文比對之後，加上 rwx 的權限規範， 	若一切合理才會讓程序順利的讀取檔案嗎？那麼這個 SELinux 的三種模式與上面談到的政策規則、安全本文的關係為何呢？我們還是使用圖示加上流程來讓大家理解一下：



![SELinux 的三種類型與實際運作流程圖示意](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/selinux_3.jpg)

圖16.5.4、SELinux 的三種類型與實際運作流程圖示意

就如上圖所示，首先，你得要知道，並不是所有的程序都會被 SELinux 所管制，因此最左邊會出現一個所謂的『有受限的程序主體』！那如何觀察有沒有受限 (confined )呢？ 	很簡單啊！就透過 ps -eZ 去擷取！舉例來說，我們來找一找 crond 與 bash 這兩隻程序是否有被限制吧？

```
[root@study ~]# ps -eZ | grep -E 'cron|bash'
system_u:system_r:crond_t:s0-s0:c0.c1023 1340 ? 00:00:00 atd
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 13888 tty2 00:00:00 bash
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 28054 pts/0 00:00:00 bash
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 28094 pts/0 00:00:00 bash
system_u:system_r:crond_t:s0-s0:c0.c1023 28174 ? 00:00:00 crond
```

如前所述，因為在目前 target 這個政策底下，只有第三個類型 (type) 欄位會有影響，因此我們上表僅列出第三個欄位的資料而已。 	我們可以看到， crond 確實是有受限的主體程序，而 bash 因為是本機程序，因此就是不受限 (unconfined_t) 的類型！也就是說， 	bash 是不需要經過圖 16.5.4 的流程，而是直接去判斷 rwx 而已～。

了解了受限的主體程序的意義之後，再來了解一下，三種模式的運作吧！首先，如果是 Disabled 的模式，那麼 SELinux 將不會運作，當然受限的程序也不會經過 SELinux ， 	也是直接去判斷 rwx 而已。那如果是寬容 (permissive) 模式呢？這種模式也是不會將主體程序抵擋 (所以箭頭是可以直接穿透的喔！)，不過萬一沒有通過政策規則，或者是安全本文的比對時， 	那麼該讀寫動作將會被紀錄起來 (log)，可作為未來檢查問題的判斷依據。

至於最終那個 Enforcing 模式，就是實際將受限主體進入規則比對、安全本文比對的流程，若失敗，就直接抵擋主體程序的讀寫行為，並且將他記錄下來。 	如果通通沒問題，這才進入到 rwx 權限的判斷喔！這樣可以理解三種模式的行為了嗎？



那你怎麼知道目前的 SELinux 模式呢？就透過 getenforce 吧！

```
[root@study ~]# getenforce
Enforcing  <==諾！就顯示出目前的模式為 Enforcing 囉！
```



另外，我們又如何知道 SELinux 的政策 (Policy) 為何呢？這時可以使用 sestatus 來觀察：

```
[root@study ~]# sestatus [-vb]
選項與參數：
-v  ：檢查列於 /etc/sestatus.conf 內的檔案與程序的安全性本文內容；
-b  ：將目前政策的規則布林值列出，亦即某些規則 (rule) 是否要啟動 (0/1) 之意；

範例一：列出目前的 SELinux 使用哪個政策 (Policy)？
[root@study ~]# sestatus
SELinux status:                 enabled           <==是否啟動 SELinux
SELinuxfs mount:                /sys/fs/selinux   <==SELinux 的相關檔案資料掛載點
SELinux root directory:         /etc/selinux      <==SELinux 的根目錄所在
Loaded policy name:             targeted          <==目前的政策為何？
Current mode:                   enforcing         <==目前的模式
Mode from config file:          enforcing         <==目前設定檔內規範的 SELinux 模式
Policy MLS status:              enabled           <==是否含有 MLS 的模式機制
Policy deny_unknown status:     allowed           <==是否預設抵擋未知的主體程序
Max kernel policy version:      28 
```

如上所示，目前是啟動的，而且是 Enforcing 模式，而由設定檔查詢得知亦為 Enforcing 模式。 	此外，目前的預設政策為 targeted 這一個。你應該要有疑問的是， SELinux 的設定檔是哪個檔案啊？ 	其實就是 /etc/selinux/config 這個檔案喔！我們來看看內容：

```
[root@study ~]# vim /etc/selinux/config
SELINUX=enforcing     <==調整 enforcing|disabled|permissive
SELINUXTYPE=targeted  <==目前僅有 targeted, mls, minimum 三種政策
```

若有需要修改預設政策的話，就直接改 SELINUX=enforcing 那一行即可喔！



- SELinux 的啟動與關閉

上面是預設的政策與啟動的模式！你要注意的是，如果改變了政策則需要重新開機；如果由 enforcing 或 permissive 	改成 disabled ，或由 disabled 改成其他兩個，那也必須要重新開機。這是因為 SELinux 是整合到核心裡面去的， 	你只可以在 SELinux 運作下切換成為強制 (enforcing) 或寬容 (permissive) 模式，不能夠直接關閉 SELinux 的！ 	如果剛剛你發現 getenforce 出現 disabled 時，請到上述檔案修改成為 enforcing 然後重新開機吧！

不過你要注意的是，如果從 disable 轉到啟動 SELinux 的模式時， 	由於系統必須要針對檔案寫入安全性本文的資訊，因此開機過程會花費不少時間在等待重新寫入 SELinux 安全性本文  	(有時也稱為 SELinux Label) ，而且在寫完之後還得要再次的重新開機一次喔！你必須要等待粉長一段時間！ 	等到下次開機成功後，再使用 [getenforce](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#getenforce) 或 [sestatus](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#sestatus) 	來觀察看看有否成功的啟動到 Enforcing 的模式囉！



如果你已經在 Enforcing 的模式，但是可能由於一些設定的問題導致 SELinux 讓某些服務無法正常的運作， 	此時你可以將 Enforcing 的模式改為寬容 (permissive) 的模式，讓 SELinux 只會警告無法順利連線的訊息， 	而不是直接抵擋主體程序的讀取權限。讓 SELinux 模式在 enforcing 與 permissive 之間切換的方法為：

```
[root@study ~]# setenforce [0|1]
選項與參數：
0 ：轉成 permissive 寬容模式；
1 ：轉成 Enforcing 強制模式

範例一：將 SELinux 在 Enforcing 與 permissive 之間切換與觀察
[root@study ~]# setenforce 0
[root@study ~]# getenforce
Permissive
[root@study ~]# setenforce 1
[root@study ~]# getenforce
Enforcing
```

不過請注意， setenforce 無法在 Disabled 的模式底下進行模式的切換喔！

 Tips ![鳥哥](https://linux.vbird.org/include/vbird_face.gif)		在某些特殊的情況底下，你從 Disabled 切換成 Enforcing 之後，竟然有一堆服務無法順利啟動，都會跟你說在 /lib/xxx  	裡面的資料沒有權限讀取，所以啟動失敗。這大多是由於在重新寫入 SELinux type (Relabel) 出錯之故，使用 Permissive  	就沒有這個錯誤。那如何處理呢？最簡單的方法就是在 Permissive 的狀態下，使用『 restorecon -Rv / 』重新還原所有 SELinux 的類型，就能夠處理這個錯誤！ 	



### 16.5.4 SELinux 政策內的規則管理

從[圖 16.5.4](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#fig16.5.4) 裡面，我們知道 SELinux 的三種模式是會影響到主體程序的放行與否。 	如果是進入 Enforcing 模式，那麼接著下來會影響到主體程序的，當然就是第二關：『 target 政策內的各項規則 (rules) 』了！ 	好了，那麼我們怎麼知道目前這個政策裡面到底有多少會影響到主體程序的規則呢？很簡單，就透過 getsebool 來瞧一瞧即可。

- SELinux 各個規則的布林值查詢 getsebool

如果想要查詢系統上面全部規則的啟動與否 (on/off，亦即布林值)，很簡單的透過 sestatus -b 或 getsebool -a 均可！



```
[root@study ~]# getsebool [-a] [規則的名稱]
選項與參數：
-a  ：列出目前系統上面的所有 SELinux 規則的布林值為開啟或關閉值

範例一：查詢本系統內所有的布林值設定狀況
[root@study ~]# getsebool -a
abrt_anon_write --> off
abrt_handle_event --> off
....(中間省略)....
cron_can_relabel --> off                 # 這個跟 cornd 比較有關！
cron_userdomain_transition --> on
....(中間省略)....
httpd_enable_homedirs --> off            # 這當然就是跟網頁，亦即 http 有關的囉！
....(底下省略)....
# 這麼多的 SELinux 規則喔！每個規則後面都列出現在是允許放行還是不許放行的布林值喔！
```

- SELinux 各個規則規範的主體程序能夠讀取的檔案 SELinux type 查詢 seinfo, sesearch

我們現在知道有這麼多的 SELinux 規則，但是每個規則內到底是在限制什麼東西？如果你想要知道的話，那就得要使用 seinfo 等工具！ 	這些工具並沒有在我們安裝時就安裝了，因此請拿出原版光碟，放到光碟機，鳥哥假設你將原版光碟掛載到 /mnt 底下，那麼接下來這麼作， 	先安裝好我們所需要的軟體才行！

```
[root@study ~]# yum install /mnt/Packages/setools-console-*
```

很快的安裝完畢之後，我們就可以來使用 seinfo, sesearch 等指令了！



```
[root@study ~]# seinfo [-trub]
選項與參數：
--all ：列出 SELinux 的狀態、規則布林值、身份識別、角色、類別等所有資訊
-u    ：列出 SELinux 的所有身份識別 (user) 種類
-r    ：列出 SELinux 的所有角色 (role) 種類
-t    ：列出 SELinux 的所有類別 (type) 種類
-b    ：列出所有規則的種類 (布林值)

範例一：列出 SELinux 在此政策下的統計狀態
[root@study ~]# seinfo
Statistics for policy file: /sys/fs/selinux/policy
Policy Version & Type: v.28 (binary, mls)

   Classes:            83    Permissions:       255
   Sensitivities:       1    Categories:       1024
   Types:            4620    Attributes:        357
   Users:               8    Roles:              14
   Booleans:          295    Cond. Expr.:       346
   Allow:          102249    Neverallow:          0
   Auditallow:        160    Dontaudit:        8413
   Type_trans:      16863    Type_change:        74
   Type_member:        35    Role allow:         30
   Role_trans:        412    Range_trans:      5439
....(底下省略)....
# 從上面我們可以看到這個政策是 targeted ，此政策的安全本文類別有 4620 個；
# 而各種 SELinux 的規則 (Booleans) 共制訂了 295 條！
```

我們在 16.5.2 裡面簡單的談到了幾個身份識別 (user) 以及角色 (role) 而已，如果你想要查詢目前所有的身份識別與角色，就使用『 seinfo -u 』及『 	seinfo -r 』就可以知道了！至於簡單的統計資料，就直接輸入 seinfo 即可！但是上面還是沒有談到規則相關的東西耶～ 	沒關係～一個一個來～我們在 16.5.1 的最後面談到 /etc/cron.d/checktime 的 SELinux type 類型不太對～那我們也知道 crond 這個程序的 type 是 crond_t ， 	能不能找一下 crond_t 能夠讀取的檔案 SELinux type 有哪些呢？



```
[root@study ~]# sesearch [-A] [-s 主體類別] [-t 目標類別] [-b 布林值]
選項與參數：
-A  ：列出後面資料中，允許『讀取或放行』的相關資料
-t  ：後面還要接類別，例如 -t httpd_t
-b  ：後面還要接SELinux的規則，例如 -b httpd_enable_ftp_server

範例一：找出 crond_t 這個主體程序能夠讀取的檔案 SELinux type
[root@study ~]# sesearch -A -s crond_t | grep spool
   allow crond_t system_cron_spool_t : file { ioctl read write create getattr ..
   allow crond_t system_cron_spool_t : dir { ioctl read getattr lock search op..
   allow crond_t user_cron_spool_t : file { ioctl read write create getattr se..
   allow crond_t user_cron_spool_t : dir { ioctl read write getattr lock add_n..
   allow crond_t user_cron_spool_t : lnk_file { read getattr } ;
# allow 後面接主體程序以及檔案的 SELinux type，上面的資料是擷取出來的，
# 意思是說，crond_t 可以讀取 system_cron_spool_t 的檔案/目錄類型～等等！

範例二：找出 crond_t 是否能夠讀取 /etc/cron.d/checktime 這個我們自訂的設定檔？
[root@study ~]# ll -Z /etc/cron.d/checktime
-rw-r--r--. root root unconfined_u:object_r:admin_home_t:s0 /etc/cron.d/checktime
# 兩個重點，一個是 SELinux type 為 admin_home_t，一個是檔案 (file)

[root@study ~]# sesearch -A -s crond_t | grep admin_home_t
   allow domain admin_home_t : dir { getattr search open } ;
   allow domain admin_home_t : lnk_file { read getattr } ;
   allow crond_t admin_home_t : dir { ioctl read getattr lock search open } ;
   allow crond_t admin_home_t : lnk_file { read getattr } ;
# 仔細看！看仔細～雖然有 crond_t admin_home_t 存在，但是這是總體的資訊，
# 並沒有針對某些規則的尋找～所以還是不確定 checktime 能否被讀取。但是，基本上就是 SELinux
# type 出問題～因此才會無法讀取的！
```

所以，現在我們知道 /etc/cron.d/checktime 這個我們自己複製過去的檔案會沒有辦法被讀取的原因，就是因為 SELinux type 錯誤啦！ 	根本就無法被讀取～好～那現在我們來查一查，那 getsebool -a 裡面看到的 httpd_enable_homedirs 到底是什麼？又是規範了哪些主體程序能夠讀取的 SELinux type 呢？

```
[root@study ~]# semanage boolean -l | grep httpd_enable_homedirs
SELinux boolean                State  Default Description
httpd_enable_homedirs          (off  ,  off)  Allow httpd to enable homedirs
# httpd_enable_homedirs 的功能是允許 httpd 程序去讀取使用者家目錄的意思～

[root@study ~]# sesearch -A -b httpd_enable_homedirs
範例三：列出 httpd_enable_homedirs 這個規則當中，主體程序能夠讀取的檔案 SELinux type
Found 43 semantic av rules:
   allow httpd_t home_root_t : dir { ioctl read getattr lock search open } ;
   allow httpd_t home_root_t : lnk_file { read getattr } ;
   allow httpd_t user_home_type : dir { getattr search open } ;
   allow httpd_t user_home_type : lnk_file { read getattr } ;
....(後面省略)....
# 從上面的資料才可以理解，在這個規則中，主要是放行 httpd_t 能否讀取使用者家目錄的檔案！
# 所以，如果這個規則沒有啟動，基本上， httpd_t 這種程序就無法讀取使用者家目錄下的檔案！
```

- 修改 SELinux 規則的布林值 setsebool

那麼如果查詢到某個 SELinux rule，並且以 sesearch 知道該規則的用途後，想要關閉或啟動他，又該如何處置？



```
[root@study ~]# setsebool  [-P]  『規則名稱』 [0|1]
選項與參數：
-P  ：直接將設定值寫入設定檔，該設定資料未來會生效的！

範例一：查詢 httpd_enable_homedirs 這個規則的狀態，並且修改這個規則成為不同的布林值
[root@study ~]# getsebool httpd_enable_homedirs
httpd_enable_homedirs --> off  <==結果是 off ，依題意給他啟動看看！

[root@study ~]# setsebool -P httpd_enable_homedirs 1 # 會跑很久很久！請耐心等待！
[root@study ~]# getsebool httpd_enable_homedirs
httpd_enable_homedirs --> on
```

這個 setsebool 最好記得一定要加上 -P 的選項！因為這樣才能將此設定寫入設定檔！ 	這是非常棒的工具組！你一定要知道如何使用 getsebool 與 setsebool 才行！



### 16.5.5 SELinux 安全本文的修改

再次的回到[圖 16.5.4](https://linux.vbird.org/linux_basic/centos7/0440processcontrol.php#fig16.5.4) 上頭去，現在我們知道 SELinux 對受限的主體程序有沒有影響，第一關考慮 SELinux 的三種類型，第二關考慮 	SELinux 的政策規則是否放行，第三關則是開始比對 SELinux type 啦！從剛剛 16.5.4 小節我們也知道可以透過 sesearch 來找到主體程序與檔案的 SELinux type 關係！ 	好，現在總算要來修改檔案的 SELinux type，以讓主體程序能夠讀到正確的檔案啊！這時就得要幾個重要的小東西了～來瞧瞧～



- 使用 chcon 手動修改檔案的 SELinux type

```
[root@study ~]# chcon [-R] [-t type] [-u user] [-r role] 檔案
[root@study ~]# chcon [-R] --reference=範例檔 檔案
選項與參數：
-R  ：連同該目錄下的次目錄也同時修改；
-t  ：後面接安全性本文的類型欄位！例如 httpd_sys_content_t ；
-u  ：後面接身份識別，例如 system_u； (不重要)
-r  ：後面接角色，例如 system_r；     (不重要)
-v  ：若有變化成功，請將變動的結果列出來
--reference=範例檔：拿某個檔案當範例來修改後續接的檔案的類型！

範例一：查詢一下 /etc/hosts 的 SELinux type，並將該類型套用到 /etc/cron.d/checktime 上
[root@study ~]# ll -Z /etc/hosts
-rw-r--r--. root root system_u:object_r:net_conf_t:s0  /etc/hosts
[root@study ~]# chcon -v -t net_conf_t /etc/cron.d/checktime
changing security context of ‘/etc/cron.d/checktime’
[root@study ~]# ll -Z /etc/cron.d/checktime
-rw-r--r--. root root unconfined_u:object_r:net_conf_t:s0 /etc/cron.d/checktime

範例二：直接以 /etc/shadow SELinux type 套用到 /etc/cron.d/checktime 上！
[root@study ~]# chcon -v --reference=/etc/shadow /etc/cron.d/checktime
[root@study ~]# ll -Z /etc/shadow /etc/cron.d/checktime
-rw-r--r--. root root system_u:object_r:shadow_t:s0    /etc/cron.d/checktime
----------. root root system_u:object_r:shadow_t:s0    /etc/shadow
```

上面的練習『都沒有正確的解答！』因為正確的 SELinux type 應該就是要以 /etc/cron.d/ 底下的檔案為標準來處理才對啊～ 	好了～既然如此～能不能讓 SELinux 自己解決預設目錄下的 SELinux type 呢？可以！就用 restorecon 吧！



- 使用 restorecon 讓檔案恢復正確的 SELinux type

```
[root@study ~]# restorecon [-Rv] 檔案或目錄
選項與參數：
-R  ：連同次目錄一起修改；
-v  ：將過程顯示到螢幕上

範例三：將 /etc/cron.d/ 底下的檔案通通恢復成預設的 SELinux type！
[root@study ~]# restorecon -Rv /etc/cron.d
restorecon reset /etc/cron.d/checktime context system_u:object_r:shadow_t:s0->
system_u:object_r:system_cron_spool_t:s0
# 上面這兩行其實是同一行喔！表示將 checktime 由 shadow_t 改為 system_cron_spool_t

範例四：重新啟動 crond 看看有沒有正確啟動 checktime 囉！？
[root@study ~]# systemctl restart crond
[root@study ~]# tail /var/log/cron
# 再去瞧瞧這個 /var/log/cron 的內容，應該就沒有錯誤訊息了
```

其實，鳥哥幾乎已經忘了 chcon 這個指令了！因為 restorecon 主動的回復預設的 SELinux type 要簡單很多！而且可以一口氣恢復整個目錄下的檔案！ 	所以，鳥哥建議你幾乎只要記得 restorecon 搭配 -Rv 同時加上某個目錄這樣的指令串即可～修改 SELinux 的 type 就變得非常的輕鬆囉！



- semanage 預設目錄的安全性本文查詢與修改

你應該要覺得奇怪，為什麼 restorecon 可以『恢復』原本的 SELinux type 呢？那肯定就是有個地方在紀錄每個檔案/目錄的 SELinux 預設類型囉？ 	沒錯！是這樣～那要如何 (1)查詢預設的 SELinux type 以及 (2)如何增加/修改/刪除預設的 SELinux type 呢？很簡單～透過 semanage 即可！他是這樣使用的：

```
[root@study ~]# semanage {login|user|port|interface|fcontext|translation} -l
[root@study ~]# semanage fcontext -{a|d|m} [-frst] file_spec
選項與參數：
fcontext ：主要用在安全性本文方面的用途， -l 為查詢的意思；
-a ：增加的意思，你可以增加一些目錄的預設安全性本文類型設定；
-m ：修改的意思；
-d ：刪除的意思。

範例一：查詢一下 /etc /etc/cron.d 的預設 SELinux type 為何？
[root@study ~]# semanage fcontext -l | grep -E '^/etc |^/etc/cron'
SELinux fcontext         type               Context
/etc                     all files          system_u:object_r:etc_t:s0
/etc/cron\.d(/.*)?       all files          system_u:object_r:system_cron_spool_t:s0
```

看到上面輸出的最後一行，那也是為啥我們直接使用 vim 去 /etc/cron.d 底下建立新檔案時，預設的 SELinux type 就是正確的！ 	同時，我們也會知道使用 restorecon 回復正確的 SELinux type 時，系統會去判斷預設的類型為何的依據。現在讓我們來想一想， 	如果 (當然是假的！不可能這麼幹) 我們要建立一個 /srv/mycron 的目錄，這個目錄預設也是需要變成 system_cron_spool_t 時， 	我們應該要如何處理呢？基本上可以這樣作：

```
# 1. 先建立 /srv/mycron 同時在內部放入設定檔，同時觀察 SELinux type
[root@study ~]# mkdir /srv/mycron
[root@study ~]# cp /etc/cron.d/checktime /srv/mycron
[root@study ~]# ll -dZ /srv/mycron /srv/mycron/checktime
drwxr-xr-x. root root unconfined_u:object_r:var_t:s0   /srv/mycron
-rw-r--r--. root root unconfined_u:object_r:var_t:s0   /srv/mycron/checktime

# 2. 觀察一下上層 /srv 的 SELinux type
[root@study ~]# semanage fcontext -l | grep '^/srv'
SELinux fcontext         type               Context
/srv                     all files          system_u:object_r:var_t:s0
# 怪不得 mycron 會是 var_t 囉！

# 3. 將 mycron 預設值改為 system_cron_spool_t 囉！
[root@study ~]# semanage fcontext -a -t system_cron_spool_t "/srv/mycron(/.*)?"
[root@study ~]# semanage fcontext -l | grep '^/srv/mycron'
SELinux fcontext         type               Context
/srv/mycron(/.*)?        all files          system_u:object_r:system_cron_spool_t:s0

# 4. 恢復 /srv/mycron 以及子目錄相關的 SELinux type 喔！
[root@study ~]# restorecon -Rv /srv/mycron
[root@study ~]# ll -dZ /srv/mycron /srv/mycron/*
drwxr-xr-x. root root unconfined_u:object_r:system_cron_spool_t:s0 /srv/mycron
-rw-r--r--. root root unconfined_u:object_r:system_cron_spool_t:s0 /srv/mycron/checktime
# 有了預設值，未來就不會不小心被亂改了！這樣比較妥當些～
```

semanage 的功能很多，不過鳥哥主要用到的僅有 fcontext 這個項目的動作而已。如上所示， 	你可以使用 semanage 來查詢所有的目錄預設值，也能夠使用他來增加預設值的設定！如果您學會這些基礎的工具， 	那麼 SELinux 對你來說，也不是什麼太難的咚咚囉！



### 16.5.6 一個網路服務案例及登錄檔協助

本章在 SELinux 小節當中談到的各個指令中，尤其是 setsebool, chcon, restorecon 等，都是為了當你的某些網路服務無法正常提供相關功能時， 	才需要進行修改的一些指令動作。但是，我們怎麼知道哪個時候才需要進行這些指令的修改啊？我們怎麼知道系統因為 SELinux  	的問題導致網路服務不對勁啊？如果都要靠用戶端連線失敗才來哭訴，那也太沒有效率了！所以，我們的 CentOS 7.x 有提供幾支偵測的服務在登錄 SELinux  	產生的錯誤喔！那就是 auditd 與 setroubleshootd。



- setroubleshoot --> 錯誤訊息寫入 /var/log/messages

幾乎所有 SELinux 相關的程式都會以 se 為開頭，這個服務也是以 se 為開頭！而 troubleshoot 大家都知道是錯誤克服，因此這個  	setroubleshoot 自然就得要啟動他啦！這個服務會將關於 SELinux 的錯誤訊息與克服方法記錄到 /var/log/messages 與 /var/log/setroubleshoot/*  	裡頭，所以你一定得要啟動這個服務才好。啟動這個服務之前當然就是得要安裝它啦！ 這玩意兒總共需要兩個軟體，分別是 setroublshoot 與  	setroubleshoot-server，如果你沒有安裝，請自行使用 yum 安裝吧！

此外，原本的 SELinux 資訊本來是以兩個服務來記錄的，分別是 auditd 與 setroubleshootd。既然是同樣的資訊，因此 CentOS 6.x (含 7.x) 以後將兩者整合在  	auditd 當中啦！所以，並沒有 setroubleshootd 的服務存在了喔！因此，當你安裝好了 setroubleshoot-server 之後，請記得要重新啟動  	auditd，否則 setroubleshootd 的功能不會被啟動的。

 Tips ![鳥哥](https://linux.vbird.org/include/vbird_face.gif)		事實上，CentOS 7.x 對 setroubleshootd 的運作方式是： (1)先由 auditd 去呼叫 audispd 服務， (2)然後 audispd 服務去啟動 sedispatch 程式，  	(3)sedispatch 再將原本的 auditd 訊息轉成 setroubleshootd 的訊息，進一步儲存下來的！ 	

```
[root@study ~]# rpm -qa | grep setroubleshoot
setroubleshoot-plugins-3.0.59-1.el7.noarch
setroubleshoot-3.2.17-3.el7.x86_64
setroubleshoot-server-3.2.17-3.el7.x86_64
```

在預設的情況下，這個 setroubleshoot 應該都是會安裝的！是否正確安裝可以使用上述的表格指令去查詢。萬一沒有安裝，請使用 yum install 去安裝吧！ 	再說一遍，安裝完畢最好重新啟動 auditd 這個服務喔！不過，剛剛裝好且順利啟動後， setroubleshoot 還是不會有作用，為啥？ 	因為我們並沒有任何受限的網路服務主體程序在運作啊！所以，底下我們將使用一個簡單的 FTP 伺服器軟體為例，讓你了解到我們上頭講到的許多重點的應用！



- 實例狀況說明：透過 vsftpd 這個 FTP 伺服器來存取系統上的檔案

現在的年輕小伙子們傳資料都用 line, FB, dropbox, google 雲端磁碟等等，不過在網路早期傳送大容量的檔案，還是以 FTP 這個協定為主！ 	現在為了速度，經常有 p2p 的軟體提供大容量檔案的傳輸，但以鳥哥這個老人家來說，可能 FTP 傳送資料還是比較有保障... 	在 CentOS 7.x 的環境下，達成 FTP 的預設伺服器軟體主要是 vsftpd 這一支喔！

詳細的 FTP 協定我們在伺服器篇再來談，這裡只是簡單的利用 vsftpd 這個軟體與 FTP 的協定來講解 SELinux 的問題與錯誤克服而已。 	不過既然要使用到 FTP 協定，一些簡單的知識還是得要存在才好！否則等一下我們沒有辦法了解為啥要這麼做！ 	首先，你得要知道，用戶端需要使用『FTP 帳號登入 FTP 伺服器』才行！而有一個稱為『匿名 (anonymous) 』的帳號可以登入系統！ 	但是這個匿名的帳號登入後，只能存取某一個特定的目錄，而無法脫離該目錄～！

在 vsftpd 中，一般用戶與匿名者的家目錄說明如下：

- 匿名者：如果使用瀏覽器來連線到 FTP 伺服器的話，那預設就是使用匿名者登入系統。而匿名者的家目錄預設是在 /var/ftp 當中！ 	同時，匿名者在家目錄下只能下載資料，不能上傳資料到 FTP 伺服器。同時，匿名者無法離開 FTP 伺服器的 /var/ftp 目錄喔！
- 一般 FTP 帳號：在預設的情況下，所有 UID 大於 1000 的帳號，都可以使用 FTP 來登入系統！ 	而登入系統之後，所有的帳號都能夠取得自己家目錄底下的檔案資料！當然預設是可以上傳、下載檔案的！

為了避免跟之前章節的用戶產生誤解的情況，這裡我們先建立一個名為 ftptest 的帳號，且帳號密碼為 myftp123， 	先來建立一下吧！

```
[root@study ~]# useradd -s /sbin/nologin ftptest
[root@study ~]# echo "myftp123" | passwd --stdin ftptest
```

接下來當然就是安裝 vsftpd 這隻伺服器軟體，同時啟動這隻服務，另外，我們也希望未來開機都能夠啟動這隻服務！ 	因此需要這樣做 (鳥哥假設你的 CentOS 7.x 的原版光碟已經掛載於 /mnt 了喔！)：

```
[root@study ~]# yum install /mnt/Packages/vsftpd-3*
[root@study ~]# systemctl start vsftpd
[root@study ~]# systemctl enable vsftpd
[root@study ~]# netstat -tlnp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address   Foreign Address   State   PID/Program name
tcp        0      0 0.0.0.0:22      0.0.0.0:*         LISTEN  1326/sshd
tcp        0      0 127.0.0.1:25    0.0.0.0:*         LISTEN  2349/master
tcp6       0      0 :::21           :::*              LISTEN  6256/vsftpd
tcp6       0      0 :::22           :::*              LISTEN  1326/sshd
tcp6       0      0 ::1:25          :::*              LISTEN  2349/master
# 要注意看，上面的特殊字體那行有出現，才代表 vsftpd 這隻服務有啟動喔！！
```



- 匿名者無法下載的問題

現在讓我們來模擬一些 FTP 的常用狀態！假設你想要將 /etc/securetty 以及主要的 /etc/sysctl.conf 放置給所有人下載， 	那麼你可能會這樣做！

```
[root@study ~]# cp -a /etc/securetty /etc/sysctl.conf /var/ftp/pub
[root@study ~]# ll /var/ftp/pub
-rw-------. 1 root root 221 Oct 29  2014 securetty    # 先假設你沒有看到這個問題！
-rw-r--r--. 1 root root 225 Mar  6 11:05 sysctl.conf
```

一般來說，預設要給用戶下載的 FTP 檔案會放置到上面表格當中的 /var/ftp/pub 目錄喔！現在讓我們使用簡單的終端機瀏覽器 curl 來觀察看看！ 	看你能不能查詢到上述兩個檔案的內容呢？

```
# 1. 先看看 FTP 根目錄底下有什麼檔案存在？
[root@study ~]# curl ftp://localhost
drwxr-xr-x    2 0        0              40 Aug 08 00:51 pub
# 確實有存在一個名為 pub 的檔案喔！那就是在 /var/ftp 底下的 pub 囉！

# 2. 再往下看看，能不能看到 pub 內的檔案呢？
[root@study ~]# curl ftp://localhost/pub/  # 因為是目錄，要加上 / 才好！
-rw-------    1 0        0             221 Oct 29  2014 securetty
-rw-r--r--    1 0        0             225 Mar 06 03:05 sysctl.conf

# 3. 承上，繼續看一下 sysctl.conf 的內容好了！
[root@study ~]# curl ftp://localhost/pub/sysctl.conf
# System default settings live in /usr/lib/sysctl.d/00-system.conf.
# To override those settings, enter new settings here, or in an /etc/sysctl.d/<name>.conf file
#
# For more information, see sysctl.conf(5) and sysctl.d(5).
# 真的有看到這個檔案的內容喔！所以確定是可以讓 vsftpd 讀取到這檔案的！

# 4. 再來瞧瞧 securetty 好了！
[root@study ~]# curl ftp://localhost/pub/securetty
curl: (78) RETR response: 550
# 看不到耶！但是，基本的原因應該是權限問題喔！因為 vsftpd 預設放在 /var/ftp/pub 內的資料，
# 不論什麼 SELinux type 幾乎都可以被讀取的才對喔！所以要這樣處理！

# 5. 修訂權限之後再一次觀察 securetty 看看！
[root@study ~]# chmod a+r /var/ftp/pub/securetty
[root@study ~]# curl ftp://localhost/pub/securetty
# 此時你就可以看到實際的檔案內容囉！

# 6. 修訂 SELinux type 的內容 (非必備)
[root@study ~]# restorecon -Rv /var/ftp
```

上面這個例子在告訴你，要先從權限的角度來瞧一瞧，如果無法被讀取，可能就是因為沒有 r 或沒有 rx 囉！並不一定是由 SELinux 引起的！ 	了解乎？好～再來瞧瞧如果是一般帳號呢？如何登入？



- 無法從家目錄下載檔案的問題分析與解決

我們前面建立了 ftptest 帳號，那如何使用文字界面來登入呢？就使用如下的方式來處理。同時請注意，因為文字型的 FTP 用戶端軟體， 	預設會將用戶丟到根目錄而不是家目錄，因此，你的 URL 可能需要修訂一下如下！

```
# 0. 為了讓 curl 這個文字瀏覽器可以傳輸資料，我們先建立一些資料在 ftptest 家目錄
[root@study ~]# echo "testing" > ~ftptest/test.txt
[root@study ~]# cp -a /etc/hosts /etc/sysctl.conf ~ftptest/
[root@study ~]# ll ~ftptest/
-rw-r--r--. 1 root root 158 Jun  7  2013 hosts
-rw-r--r--. 1 root root 225 Mar  6 11:05 sysctl.conf
-rw-r--r--. 1 root root   8 Aug  9 01:05 test.txt

# 1. 一般帳號直接登入 FTP 伺服器，同時變換目錄到家目錄去！
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/
-rw-r--r--    1 0        0             158 Jun 07  2013 hosts
-rw-r--r--    1 0        0             225 Mar 06 03:05 sysctl.conf
-rw-r--r--    1 0        0               8 Aug 08 17:05 test.txt
# 真的有資料～看檔案最左邊的權限也是沒問題，所以，來讀一下 test.txt 的內容看看

# 2. 開始下載 test.txt, sysctl.conf 等有權限可以閱讀的檔案看看！
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/test.txt
curl: (78) RETR response: 550
# 竟然說沒有權限！明明我們的 rwx 是正常沒問題！那是否有可能是 SELinux 造成的？

# 3. 先將 SELinux 從 Enforce 轉成 Permissive 看看情況！同時觀察登錄檔
[root@study ~]# setenforce 0
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/test.txt
testing
[root@study ~]# setenforce 1  # 確定問題後，一定要轉成 Enforcing 啊！
# 確定有資料內容！所以，確定就是 SELinux 造成無法讀取的問題～那怎辦？要改規則？還是改 type？
# 因為都不知道，所以，就檢查一下登錄檔看看有沒有相關的資訊可以提供給我們處理！

[root@study ~]# vim /var/log/messages
Aug  9 02:55:58 station3-39 setroubleshoot: SELinux is preventing /usr/sbin/vsftpd 
 from lock access on the file /home/ftptest/test.txt. For complete SELinux messages. 
 run sealert -l 3a57aad3-a128-461b-966a-5bb2b0ffa0f9
Aug  9 02:55:58 station3-39 python: SELinux is preventing /usr/sbin/vsftpd from 
 lock access on the file /home/ftptest/test.txt.

*****  Plugin catchall_boolean (47.5 confidence) suggests   ******************

If you want to allow ftp to home dir
Then you must tell SELinux about this by enabling the 'ftp_home_dir' boolean.
You can read 'None' man page for more details.
Do
setsebool -P ftp_home_dir 1

*****  Plugin catchall_boolean (47.5 confidence) suggests   ******************

If you want to allow ftpd to full access
Then you must tell SELinux about this by enabling the 'ftpd_full_access' boolean.
You can read 'None' man page for more details.
Do
setsebool -P ftpd_full_access 1

*****  Plugin catchall (6.38 confidence) suggests   **************************
.....(底下省略).....
# 基本上，你會看到有個特殊字體的部份，就是 sealert 那一行。雖然底下已經列出可能的解決方案了，
# 就是一堆底線那些東西。至少就有三個解決方案 (最後一個沒列出來)，哪種才是正確的？
# 為了了解正確的解決方案，我們還是還執行一下 sealert 那行吧！看看情況再說！

# 4. 透過 sealert 的解決方案來處理問題
[root@study ~]# sealert -l 3a57aad3-a128-461b-966a-5bb2b0ffa0f9
SELinux is preventing /usr/sbin/vsftpd from lock access on the file /home/ftptest/test.txt.

# 底下說有 47.5% 的機率是由於這個原因所發生，並且可以使用 setsebool 去解決的意思！
*****  Plugin catchall_boolean (47.5 confidence) suggests   ******************

If you want to allow ftp to home dir
Then you must tell SELinux about this by enabling the 'ftp_home_dir' boolean.
You can read 'None' man page for more details.
Do
setsebool -P ftp_home_dir 1

# 底下說也是有 47.5% 的機率是由此產生的！
*****  Plugin catchall_boolean (47.5 confidence) suggests   ******************

If you want to allow ftpd to full access
Then you must tell SELinux about this by enabling the 'ftpd_full_access' boolean.
You can read 'None' man page for more details.
Do
setsebool -P ftpd_full_access 1

# 底下說，僅有 6.38% 的可信度是由這個情況產生的！
*****  Plugin catchall (6.38 confidence) suggests   **************************

If you believe that vsftpd should be allowed lock access on the test.txt file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# grep vsftpd /var/log/audit/audit.log | audit2allow -M mypol
# semodule -i mypol.pp

# 底下就重要了！是整個問題發生的主因～最好還是稍微瞧一瞧！
Additional Information:
Source Context                system_u:system_r:ftpd_t:s0-s0:c0.c1023
Target Context                unconfined_u:object_r:user_home_t:s0
Target Objects                /home/ftptest/test.txt [ file ]
Source                        vsftpd
Source Path                   /usr/sbin/vsftpd
Port                          <Unknown>
Host                          station3-39.gocloud.vm
Source RPM Packages           vsftpd-3.0.2-9.el7.x86_64
Target RPM Packages
Policy RPM                    selinux-policy-3.13.1-23.el7.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     station3-39.gocloud.vm
Platform                      Linux station3-39.gocloud.vm 3.10.0-229.el7.x86_64
                              #1 SMP Fri Mar 6 11:36:42 UTC 2015 x86_64 x86_64
Alert Count                   3
First Seen                    2015-08-09 01:00:12 CST
Last Seen                     2015-08-09 02:55:57 CST
Local ID                      3a57aad3-a128-461b-966a-5bb2b0ffa0f9

Raw Audit Messages
type=AVC msg=audit(1439060157.358:635): avc:  denied  { lock } for  pid=5029 comm="vsftpd" 
 path="/home/ftptest/test.txt" dev="dm-2" ino=141 scontext=system_u:system_r:ftpd_t:s0-s0:
 c0.c1023 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file

type=SYSCALL msg=audit(1439060157.358:635): arch=x86_64 syscall=fcntl success=yes exit=0 
 a0=4 a1=7 a2=7fffceb8cbb0 a3=0 items=0 ppid=5024 pid=5029 auid=4294967295 uid=1001 gid=1001
 euid=1001 suid=1001 fsuid=1001 egid=1001 sgid=1001 fsgid=1001 tty=(none) ses=4294967295
 comm=vsftpd exe=/usr/sbin/vsftpd subj=system_u:system_r:ftpd_t:s0-s0:c0.c1023 key=(null)

Hash: vsftpd,ftpd_t,user_home_t,file,lock
```

經過上面的測試，現在我們知道主要的問題發生在 SELinux 的 type 不是 vsftpd_t 所能讀取的原因～ 	經過仔細觀察 test.txt 檔案的類型，我們知道他原本就是家目錄，因此是 user_home_t 也沒啥了不起的啊！是正確的～ 	因此，分析兩個比較可信 (47.5%) 的解決方案後，可能是與 ftp_home_dir 比較有關啊！所以，我們應該不需要修改 SELinux type， 	修改的應該是 SELinux rules 才對！所以，這樣做看看：

```
# 1. 先確認一下 SELinux 的模式，然後再瞧一瞧能否下載 test.txt，最終使用處理方式來解決～
[root@study ~]# getenforce
Enforcing
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/test.txt
curl: (78) RETR response: 550
# 確定還是無法讀取的喔！
[root@study ~]# setsebool -P ftp_home_dir 1
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/test.txt
testing
# OK！太讚了！處理完畢！現在使用者可以在自己的家目錄上傳/下載檔案了！

# 2. 開始下載其他檔案試看看囉！
[root@study ~]# curl ftp://ftptest:myftp123@localhost/~/sysctl.conf
# System default settings live in /usr/lib/sysctl.d/00-system.conf.
# To override those settings, enter new settings here, or in an /etc/sysctl.d/<name>.conf file
#
# For more information, see sysctl.conf(5) and sysctl.d(5).
```

沒問題喔！透過修改 SELinux rule 的布林值，現在我們就可以使用一般帳號在 FTP 服務來上傳/下載資料囉！非常愉快吧！ 	那萬一我們還有其他的目錄也想要透過 FTP 來提供這個 ftptest 用戶上傳與下載呢？往下瞧瞧～



- 一般帳號用戶從非正規目錄上傳/下載檔案

假設我們還想要提供 /srv/gogogo 這個目錄給 ftptest 用戶使用，那又該如何處理呢？假設我們都沒有考慮 SELinux ， 	那就是這樣的情況：

```
# 1. 先處理好所需要的目錄資料
[root@study ~]# mkdir /srv/gogogo
[root@study ~]# chgrp ftptest /srv/gogogo
[root@study ~]# echo "test" > /srv/gogogo/test.txt

# 2. 開始直接使用 ftp 觀察一下資料！
[root@study ~]# curl ftp://ftptest:myftp123@localhost//srv/gogogo/test.txt
curl: (78) RETR response: 550
# 有問題喔！來瞧瞧登錄檔怎麼說！
[root@study ~]# grep sealert /var/log/messages | tail
Aug  9 04:23:12 station3-39 setroubleshoot: SELinux is preventing /usr/sbin/vsftpd from
 read access on the file test.txt. For complete SELinux messages. run sealert -l
 08d3c0a2-5160-49ab-b199-47a51a5fc8dd
[root@study ~]# sealert -l 08d3c0a2-5160-49ab-b199-47a51a5fc8dd
SELinux is preventing /usr/sbin/vsftpd from read access on the file test.txt.

# 雖然這個可信度比較高～不過，因為會全部放行 FTP ，所以不太考慮！
*****  Plugin catchall_boolean (57.6 confidence) suggests   ******************

If you want to allow ftpd to full access
Then you must tell SELinux about this by enabling the 'ftpd_full_access' boolean.
You can read 'None' man page for more details.
Do
setsebool -P ftpd_full_access 1

# 因為是非正規目錄的使用，所以這邊加上預設 SELinux type 恐怕會是比較正確的選擇！
*****  Plugin catchall_labels (36.2 confidence) suggests   *******************

If you want to allow vsftpd to have read access on the test.txt file
Then you need to change the label on test.txt
Do
# semanage fcontext -a -t FILE_TYPE 'test.txt'
where FILE_TYPE is one of the following: NetworkManager_tmp_t, abrt_helper_exec_t, abrt_tmp_t,
 abrt_upload_watch_tmp_t, abrt_var_cache_t, abrt_var_run_t, admin_crontab_tmp_t, afs_cache_t,
 alsa_home_t, alsa_tmp_t, amanda_tmp_t, antivirus_home_t, antivirus_tmp_t, apcupsd_tmp_t, ...
Then execute:
restorecon -v 'test.txt'

*****  Plugin catchall (7.64 confidence) suggests   **************************

If you believe that vsftpd should be allowed read access on the test.txt file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# grep vsftpd /var/log/audit/audit.log | audit2allow -M mypol
# semodule -i mypol.pp

Additional Information:
Source Context                system_u:system_r:ftpd_t:s0-s0:c0.c1023
Target Context                unconfined_u:object_r:var_t:s0
Target Objects                test.txt [ file ]
Source                        vsftpd
.....(底下省略).....
```

因為是非正規目錄啊，所以感覺上似乎與 semanage 那一行的解決方案比較相關～接下來就是要找到 FTP 的 SELinux type 來解決囉！ 	所以，讓我們查一下 FTP 相關的資料囉！

```
# 3. 先查看一下 /var/ftp 這個地方的 SELinux type 吧！
[root@study ~]# ll -Zd /var/ftp
drwxr-xr-x. root root system_u:object_r:public_content_t:s0 /var/ftp

# 4. 以 sealert 建議的方法來處理好 SELinux type 囉！
[root@study ~]# semanage fcontext -a -t public_content_t "/srv/gogogo(/.*)?"
[root@study ~]# restorecon -Rv /srv/gogogo
[root@study ~]# curl ftp://ftptest:myftp123@localhost//srv/gogogo/test.txt
test
# 喔耶！終於再次搞定喔！
```

在這個範例中，我們是修改了 SELinux type 喔！與前一個修改 SELinux rule 不太一樣！要理解理解喔！



- 無法變更 FTP 連線埠口問題分析與解決

在某些情況下，可能你的伺服器軟體需要開放在非正規的埠口，舉例來說，如果因為某些政策問題，導致 FTP 啟動的正常的 21 號埠口無法使用， 	因此你想要啟用在 555 號埠口時，該如何處理呢？基本上，既然 SELinux 的主體程序大多是被受限的網路服務，沒道理不限制放行的埠口啊！ 	所以，很可能會出問題～那就得要想想辦法才行！

```
# 1. 先處理 vsftpd 的設定檔，加入換 port 的參數才行！
[root@study ~]# vim /etc/vsftpd/vsftpd.conf
# 請按下大寫的 G 跑到最後一行，然後新增加底下這行設定！前面不可以留白！
listen_port=555

# 2. 重新啟動 vsftpd 並且觀察登錄檔的變化！
[root@study ~]# systemctl restart vsftpd
[root@study ~]# grep sealert /var/log/messages
Aug  9 06:34:46 station3-39 setroubleshoot: SELinux is preventing /usr/sbin/vsftpd from
 name_bind access on the tcp_socket port 555. For complete SELinux messages. run
 sealert -l 288118e7-c386-4086-9fed-2fe78865c704

[root@study ~]# sealert -l 288118e7-c386-4086-9fed-2fe78865c704
SELinux is preventing /usr/sbin/vsftpd from name_bind access on the tcp_socket port 555.

*****  Plugin bind_ports (92.2 confidence) suggests   ************************

If you want to allow /usr/sbin/vsftpd to bind to network port 555
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 555
    where PORT_TYPE is one of the following: certmaster_port_t, cluster_port_t,
 ephemeral_port_t, ftp_data_port_t, ftp_port_t, hadoop_datanode_port_t, hplip_port_t,
 port_t, postgrey_port_t, unreserved_port_t.
.....(後面省略).....
# 看一下信任度，高達 92.2% 耶！幾乎就是這傢伙～因此不必再看～就是他了！比較重要的是，
# 解決方案裡面，那個 PORT_TYPE 有很多選擇～但我們是要開啟 FTP 埠口嘛！所以，
# 就由後續資料找到 ftp_port_t 那個項目囉！帶入實驗看看！

# 3. 實際帶入 SELinux 埠口修訂後，在重新啟動 vsftpd 看看
[root@study ~]# semanage port -a -t ftp_port_t -p tcp 555
[root@study ~]# systemctl restart vsftpd
[root@study ~]# netstat -tlnp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address    Foreign Address   State    PID/Program name
tcp        0      0 0.0.0.0:22       0.0.0.0:*         LISTEN   1167/sshd
tcp        0      0 127.0.0.1:25     0.0.0.0:*         LISTEN   1598/master
tcp6       0      0 :::555           :::*              LISTEN   8436/vsftpd
tcp6       0      0 :::22            :::*              LISTEN   1167/sshd
tcp6       0      0 ::1:25           :::*              LISTEN   1598/master

# 4. 實驗看看這個 port 能不能用？
[root@study ~]# curl ftp://localhost:555/pub/
-rw-r--r--    1 0        0             221 Oct 29  2014 securetty
-rw-r--r--    1 0        0             225 Mar 06 03:05 sysctl.conf
```

透過上面的幾個小練習，你會知道在正規或非正規的環境下，如何處理你的 SELinux 問題哩！仔細研究看看囉！



### 16.6 重點回顧

- 程式 (program)：通常為 binary program ，放置在儲存媒體中 (如硬碟、光碟、軟碟、磁帶等)，為實體檔案的型態存在；
- 程序 (process)：程式被觸發後，執行者的權限與屬性、程式的程式碼與所需資料等都會被載入記憶體中， 	作業系統並給予這個記憶體內的單元一個識別碼 (PID)，可以說，程序就是一個正在運作中的程式。
- 程式彼此之間是有相關性的，故有父程序與子程序之分。而 Linux 系統所有程序的父程序就是 systemd 這個 PID 為 1 號的程序。
- 在 Linux 的程序呼叫通常稱為 fork-and-exec 的流程！程序都會藉由父程序以複製 (fork) 的方式產生一個一模一樣的子程序， 	然後被複製出來的子程序再以 exec 的方式來執行實際要進行的程式，最終就成為一個子程序的存在。
- 常駐在記憶體當中的程序通常都是負責一些系統所提供的功能以服務使用者各項任務，因此這些常駐程式就會被我們稱為：服務  	(daemon)。
- 在工作管理 (job control) 中，可以出現提示字元讓你操作的環境就稱為前景 (foreground)，至於其他工作就可以讓你放入背景  	(background) 去暫停或運作。
- 與 job control 有關的按鍵與關鍵字有： &, [ctrl]-z, jobs, fg, bg, kill %n 等；
- 程序管理的觀察指令有： ps, top, pstree 等等；
- 程序之間是可以互相控制的，傳遞的訊息 (signal) 主要透過 kill 這個指令在處理；
- 程序是有優先順序的，該項目為 Priority，但 PRI 是核心動態調整的，使用者只能使用 nice 值去微調 PRI
- nice 的給予可以有： nice, renice, top 等指令；
- vmstat 為相當好用的系統資源使用情況觀察指令；
- SELinux 當初的設計是為了避免使用者資源的誤用，而 SELinux 使用的是 MAC 委任式存取設定；
- SELinux 的運作中，重點在於主體程序 (Subject) 能否存取目標檔案資源 (Object) ，這中間牽涉到政策 (Policy) 內的規則， 	以及實際的安全性本文類別 (type)；
- 安全性本文的一般設定為：『Identify:role:type』其中又以 type 最重要；
- SELinux 的模式有： enforcing, permissive, disabled 三種，而啟動的政策 (Policy) 主要是 targeted 
- SELinux 啟動與關閉的設定檔在： /etc/selinux/config
- SELinux 的啟動與觀察： getenforce, sestatus 等指令
- 重設 SELinux 的安全性本文可使用 restorecon 與 chcon
- 在 SELinux 有啟動時，必備的服務至少要啟動 auditd 這個！
- 若要管理預設的 SELinux 布林值，可使用 getsebool, setsebool 來管理！



### 16.7 本章習題

( 要看答案請將滑鼠移動到『答：』底下的空白處，按下左鍵圈選空白處即可察看 )

- 簡單說明什麼是程式 (program) 而什麼是程序 (process)？ 

  ​		程式 (program) 是系統上面可以被執行的檔案，由於 Linux 的完整檔名 (由 / 寫起) 僅能有一個， 	所以 program 的檔名具有單一性。當程式被執行後，就會啟動成程序 (process)， 	一個 program 可以被不同的使用者或者相同的使用者重複的執行成為多個程序， 	且該程式所造成的程序還因為不同的使用者，而有不同的權限，且每個 process 幾乎都是獨立的。 

- 我今天想要查詢 /etc/crontab 與 crontab 這個程式的用法與寫法，請問我該如何線上查詢？ 

  ​		查詢 crontab 指令可以使用 man crontab 或 info 	crontab ，至於查詢 /etc/crontab ，則可以使用 man 5 crontab 囉！ 

- 

  我要如何查詢 crond 這個 daemon 的 PID 與他的 PRI 值呢？ 

  ​		ps -lA | grep crond 即可查到！ 

- 我要如何修改 crond 這個 PID 的優先執行序？ 

  ​		先以 ps aux 找到 crond  的 PID 後，再以： 	renice -n number PID 來調整！ 

- 我是一般身份使用者，我是否可以調整不屬於我的程序的 nice 值？此外，如果我調整了我自己的程序的 nice 值到 10 ，是否可以將他調回 5 呢？ 

  ​		不行！一般身份使用者僅能調整屬於自己的 PID 程序，並且，只能將 	nice 值一再地調高，並不能調低，所以調整為 10 之後，就不能降回 5 囉！ 

- 我要怎麼知道我的網路卡在開機的過程中有沒有被捉到？ 

  ​		可以使用 dmesg 來視察！ 



### 16.8 參考資料與延伸閱讀

- 註1：關於 fork-and-exec 的說明可以參考如下網頁與書籍：
   	吳賢明老師維護的網站：http://nmc.nchu.edu.tw/linux/process.htm
   	楊振和、作業系統導論、第三章、學貫出版社
- 註2：對 Linux 核心有興趣的話，可以先看看底下的連結：
   http://www.linux.org.tw/CLDP/OLD/INFO-SHEET-2.html
- 註3：來自 Linux Journal 的關於 /proc 的說明：http://www.linuxjournal.com/article/177
- 註4：關於 SELinux 相關的網站與文件資料：
   	美國國家安全局的 SELinux 簡介：http://www.nsa.gov/research/selinux/
   	陳永昇、『企業級Linux 系統管理寶典』、學貫行銷股份有限公司
   	Fedora SELinux 說明：http://fedoraproject.org/wiki/SELinux/SecurityContext
   	美國國家安全局對 SELinux 的白皮書：http://www.nsa.gov/research/_files/selinux/papers/module/t1.shtml





- 2016/10/24：感謝網友在討論區的回應，SELinux 的 seinfo 選項沒有 -A 了！使用 --all 來取代囉！



## DAC vs. MAC
Linux 上传统的访问控制标准是自主访问控制（DAC）。在这种形式下，一个软件或守护进程以 User ID（UID）或 Set owner User ID（SUID）的身份运行，并且拥有该用户的目标（文件、套接字、以及其它进程）权限。这使得恶意代码很容易运行在特定权限之下，从而取得访问关键的子系统的权限。
强制访问控制（MAC）基于保密性和完整性强制信息的隔离以限制破坏。该限制单元独立于传统的 Linux 安全机制运作，并且没有超级用户的概念。

## 概念

    主体
    目标
    策略
    模式

当一个主体（如一个程序）尝试访问一个目标（如一个文件），SELinux 安全服务器（在内核中）从策略数据库中运行一个检查。基于当前的模式，如果 SELinux 安全服务器授予权限，该主体就能够访问该目标。如果 SELinux 安全服务器拒绝了权限，就会在 /var/log/messages 中记录一条拒绝信息。


## 模式

SELinux 有三个模式。这些模式将规定 SELinux 在主体请求时如何应对。

* **Enforcing**     — SELinux 策略强制执行，基于 SELinux 策略规则授予或拒绝主体对目标的访问。计算机通常在该模式下运行。
* **Permissive**   — SELinux 策略不强制执行，不实际拒绝访问，但会有拒绝信息写入日志。主要用于测试和故障排除。
* **Disabled**      —  完全禁用 SELinux,对于越权的行为不警告，也不拦截。不建议。

查看系统当前模式：`getenforce` 。命令会返回 Enforcing、Permissive，或者 Disabled。

设置 SELinux 的模式:

* 修改 /etc/selinux/config 文件。

  ```bash
  # This file controls the state of SELinux on the system.
  # SELINUX= can take one of these three values:
  #		enforcing - SELinux security policy is enforced.
  #		permissive - SELinux prints warnings instead of enforcing.
  #		disabled - No SELinux policy is loaded.
  SELINUX=enforcing
  ```
  
* 从命令行设置模式，使用 `setenforce` 工具。

  ```bash
  setenforce [ Enforcing | Permissive | 1 | 0 ]
  ```

* 在启动时，通过将向内核传递参数来设置SELinux模式：

  ```bash
  enforcing=0		#将以许可模式启动系统
  enforcing=1		#设置强制模式
  selinux=0		#彻底禁用SELinux
  selinux=1		#启用SELinux
  ```

## 策略类型

策略有两种:

* Targeted — 只有目标网络进程（dhcpd，httpd，named，nscd，ntpd，portmap，snmpd，squid，以及 syslogd）受保护

* Strict — 对所有进程完全的 SELinux 保护

在 /etc/selinux/config 文件中修改策略类型。

```bash
# SELINUXTYPE= can take one of these two values:
#		targeted - Targeted processes are protected,
#		minimum - Modification of targeted policy. Only selected processes
#				  are protected.
#		mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

有个方便的 SELinux 工具，获取启用了 SELinux 的系统的详细状态报告。

```bash
sestatus -v
```









# SELinux security[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#selinux-security)

With the arrival of kernel version 2.6, a new security system was  introduced to provide a security mechanism to support access control  security policies.

This system is called **SELinux** (**S**ecurity **E**nhanced **Linux**) and was created by the **NSA** (**N**ational **S**ecurity **A**dministration) to implement a robust **M**andatory **A**ccess **C**ontrol (**MAC**) architecture in the Linux kernel subsystems.

If, throughout your career, you have either disabled or ignored  SELinux, this document will be a good introduction to this system.  SELinux works to limit privileges or remove the risks associated with  compromising a program or daemon.

Before starting, you should know that SELinux is mainly intended for  RHEL distributions, although it is possible to implement it on other  distributions like Debian (but good luck!). The distributions of the  Debian family generally integrate the AppArmor system, which works  differently from SELinux.

## Generalities[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#generalities)

**SELinux** (Security Enhanced Linux) is a Mandatory Access Control system.

Before the appearance of MAC systems, standard access management security was based on **DAC** (**D**iscretionary **A**ccess **C**ontrol) systems. An application, or a daemon, operated with **UID** or **SUID** (**S**et **O**wner **U**ser **I**d) rights, which made it possible to evaluate permissions (on files,  sockets, and other processes...) according to this user. This operation  does not sufficiently limit the rights of a program that is corrupted,  potentially allowing it to access the subsystems of the operating  system.

A MAC system reinforces the separation of confidentiality and  integrity information in the system to achieve a containment system. The containment system is independent of the traditional rights system and  there is no notion of a superuser.

With each system call, the kernel queries SELinux to see if it allows the action to be performed.

![SELinux](https://docs.rockylinux.org/guides/images/selinux_001.png)

SELinux uses a set of rules (policies) for this. A set of two standard rule sets (**targeted** and **strict**) is provided and each application usually provides its own rules.

### The SELinux context[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context)

The operation of SELinux is totally different from traditional Unix rights.

The SELinux security context is defined by the trio **identity**+**role**+**domain**.

The identity of a user depends directly on his Linux account. An  identity is assigned one or more roles, but to each role corresponds to  one domain, and only one.

It is according to the domain of the security context (and thus the role) that the rights of a user on a resource are evaluated.

![SELinux context](https://docs.rockylinux.org/guides/images/selinux_002.png)

The terms "domain" and "type" are similar. Typically "domain" is used when referring to a process, while "type" refers to an object.

The naming convention is: **user_u:role_r:type_t**.

The security context is assigned to a user at the time of his  connection, according to his roles. The security context of a file is  defined by the `chcon` (**ch**ange **con**text) command, which we will see later in this document.

Consider the following pieces of the SELinux puzzle:

- The subjects
- The objects
- The policies
- The mode

When a subject (an application for example) tries to access an object (a file for example), the SELinux part of the Linux kernel queries its  policy database. Depending on the mode of operation, SELinux authorizes  access to the object in case of success, otherwise it records the  failure in the file `/var/log/messages`.

#### The SELinux context of standard processes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context-of-standard-processes)

The rights of a process depend on its security context.

By default, the security context of the process is defined by the  context of the user (identity + role + domain) who launches it.

A domain being a specific type (in the SELinux sense) linked to a  process and inherited (normally) from the user who launched it, its  rights are expressed in terms of authorization or refusal on types  linked to objects:

A process whose context has security **domain D** can access objects of **type T**.

![The SELinux context of standard processes](https://docs.rockylinux.org/guides/images/selinux_003.png)

#### The SELinux context of important processes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-selinux-context-of-important-processes)

Most important programs are assigned a dedicated domain.

Each executable is tagged with a dedicated type (here **sshd_exec_t**) which automatically switches the associated process to the **sshd_t** context (instead of **user_t**).

This mechanism is essential since it restricts the rights of a process as much as possible.

![The SELinux context of an important process - example of sshd](https://docs.rockylinux.org/guides/images/selinux_004.png)

## Management[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#management)

The `semanage` command is used to manage SELinux rules.

```
semanage [object_type] [options]
```

Example:

```
$ semanage boolean -l
```

| Options | Observations     |
| ------- | ---------------- |
| -a      | Adds an object   |
| -d      | Delete an object |
| -m      | Modify an object |
| -l      | List the objects |

The `semanage` command may not be installed by default under Rocky Linux.

Without knowing the package that provides this command, you should search for its name with the command:

```
dnf provides */semanage
```

then install it:

```
sudo dnf install policycoreutils-python-utils
```

### Administering Boolean objects[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#administering-boolean-objects)

Booleans allow the containment of processes.

```
semanage boolean [options]
```

To list the available Booleans:

```
semanage boolean –l
SELinux boolean    State Default  Description
…
httpd_can_sendmail (off , off)  Allow httpd to send mail
…
```

Note

As you can see, there is a `default` state (eg. at startup) and a running state.

The `setsebool` command is used to change the state of a boolean object:

```
setsebool [-PV] boolean on|off
```

Example:

```
sudo setsebool -P httpd_can_sendmail on
```

| Options | Observations                                                 |
| ------- | ------------------------------------------------------------ |
| `-P`    | Changes the default value at startup (otherwise only until reboot) |
| `-V`    | Deletes an object                                            |

Warning

Don't forget the `-P` option to keep the state after the next startup.

### Administering Port objects[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#administering-port-objects)

The `semanage` command is used to manage objects of type port:

```
semanage port [options]
```

Example: allow port 81 for httpd domain processes

```
sudo semanage port -a -t http_port_t -p tcp 81
```

## Operating modes[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#operating-modes)

SELinux has three operating modes:

- Enforcing

Default mode for Rocky Linux. Access will be restricted according to the rules in force.

- Permissive

Rules are polled, access errors are logged, but access will not be blocked.

- Disabled

Nothing will be restricted, nothing will be logged.

By default, most operating systems are configured with SELinux in Enforcing mode.

The `getenforce` command returns the current operating mode

```
getenforce
```

Example:

```
$ getenforce
Enforcing
```

The `sestatus` command returns information about SELinux

```
sestatus
```

Example:

```
$ sestatus
SELinux status:                enabled
SELinuxfs mount:                 /sys/fs/selinux
SELinux root directory:    /etc/selinux
Loaded policy name:        targeted
Current mode:                enforcing
Mode from config file:     enforcing
...
Max kernel policy version: 33
```

The `setenforce` command changes the current operating mode:

```
setenforce 0|1
```

Switch SELinux to permissive mode:

```
sudo setenforce 0
```

### The `/etc/sysconfig/selinux` file[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-etcsysconfigselinux-file)

The `/etc/sysconfig/selinux` file allows you to change the operating mode of SELinux.

Warning

Disabling SELinux is done at your own risk! It is better to learn how SELinux works than to disable it systematically!

Edit the file `/etc/sysconfig/selinux`

```
SELINUX=disabled
```

Note

```
/etc/sysconfig/selinux` is a symlink to `/etc/selinux/config
```

Reboot the system:

```
sudo reboot
```

Warning

Beware of the SELinux mode change!

In permissive or disabled mode, newly created files will not have any labels.

To reactivate SELinux, you will have to reposition the labels on your entire system.

Labeling the entire system:

```
sudo touch /.autorelabel
sudo reboot
```

## The Policy Type[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#the-policy-type)

SELinux provides two standard types of rules:

- **Targeted**: only network daemons are protected (`dhcpd`, `httpd`, `named`, `nscd`, `ntpd`, `portmap`, `snmpd`, `squid` and `syslogd`)
- **Strict**: all daemons are protected

## Context[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#context)

The display of security contexts is done with the `-Z` option. It is associated with many commands:

Examples:

```
id -Z   # the user's context
ls -Z   # those of the current files
ps -eZ  # those of the processes
netstat –Z # for network connections
lsof -Z # for open files
```

The `matchpathcon` command returns the context of a directory.

```
matchpathcon directory
```

Example:

```
sudo matchpathcon /root
 /root  system_u:object_r:admin_home_t:s0

sudo matchpathcon /
 /      system_u:object_r:root_t:s0
```

The `chcon` command modifies a security context:

```
chcon [-vR] [-u USER] [–r ROLE] [-t TYPE] file
```

Example:

```
sudo chcon -vR -t httpd_sys_content_t /data/websites/
```

| Options        | Observations                    |
| -------------- | ------------------------------- |
| `-v`           | Switch into verbose mode        |
| `-R`           | Apply recursion                 |
| `-u`,`-r`,`-t` | Applies to a user, role or type |

The `restorecon` command restores the default security context (the one provided by the rules):

```
restorecon [-vR] directory
```

Example:

```
sudo restorecon -vR /home/
```

| Options | Observations             |
| ------- | ------------------------ |
| `-v`    | Switch into verbose mode |
| `-R`    | Apply recursion          |

To make a context change survive to a `restorecon`, you have to modify the default file contexts with the `semanage fcontext` command:

```
semanage fcontext -a options file
```

Note

If you are performing a context switch for a folder that is not  standard for the system, creating the rule and then applying the context is a good practice as in the example below!

Example:

```
$ sudo semanage fcontext -a -t httpd_sys_content_t "/data/websites(/.*)?"
$ sudo restorecon -vR /data/websites/
```

## `audit2why` command[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#audit2why-command)

The `audit2why` command indicates the cause of a SELinux rejection:

```
audit2why [-vw]
```

Example to get the cause of the last rejection by SELinux:

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2why
```

| Options | Observations                                                 |
| ------- | ------------------------------------------------------------ |
| `-v`    | Switch into verbose mode                                     |
| `-w`    | Translates the cause of a rejection by SELinux and proposes a solution to remedy it (default option) |

### Going further with SELinux[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#going-further-with-selinux)

The `audit2allow` command creates a module to allow a SELinux action (when no module exists) from a line in an "audit" file:

```
audit2allow [-mM]
```

Example:

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2allow -M mylocalmodule
```

| Options | Observations                                       |
| ------- | -------------------------------------------------- |
| `-m`    | Just create the module (`*.te`)                    |
| `-M`    | Create the module, compile and package it (`*.pp`) |

#### Example of configuration[¶](https://docs.rockylinux.org/zh/guides/security/learning_selinux/#example-of-configuration)

After the execution of a command, the system gives you back the  command prompt but the expected result is not visible: no error message  on the screen.

- **Step 1**: Read the log file knowing that the message  we are interested in is of type AVC (SELinux), refused (denied) and the  most recent one (therefore the last one).

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1
```

The message is correctly isolated but is of no help to us.

- **Step 2**: Read the isolated message with the `audit2why` command to get a more explicit message that may contain the solution to our problem (typically a boolean to be set).

```
sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2why
```

There are two cases: either we can place a context or fill in a boolean, or we must go to step 3 to create our own context.

- **Step 3**: Create your own module.

```
$ sudo cat /var/log/audit/audit.log | grep AVC | grep denied | tail -1 | audit2allow -M mylocalmodule
Generating type enforcement: mylocalmodule.te
Compiling policy: checkmodule -M -m -o mylocalmodule.mod mylocalmodule.te
Building package: semodule_package -o mylocalmodule.pp -m mylocalmodule.mod

$ sudo semodule -i mylocalmodule.pp
```
