# iscsid(8) - Linux man page iscsid（8） - Linux 手册页

## Name 名字

iscsid - Open-iSCSI daemon 
iscsid - Open-iSCSI 守护程序

## Synopsis 概要

**iscsid** [OPTION] iscsid [选项]

## Description 描述

The **iscsid** implements the control path of iSCSI protocol, plus some management  facilities. For example, the daemon could be configured to automatically re-start  discovery at startup, based on the contents of persistent iSCSI  database. 
iscsid 实现了 iSCSI 协议的控制路径，以及一些管理工具。例如，可以将守护程序配置为在启动时根据持久性 iSCSI 数据库的内容自动重新启动发现。

## Options 选项

<iframe id="aswift_0" name="aswift_0" style="left: 0px; top: 0px; border: 0px; width: 336px; height: 280px;" sandbox="allow-forms allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts allow-top-navigation-by-user-activation" width="336" height="280" frameborder="0" marginwidth="0" marginheight="0" vspace="0" hspace="0" allowtransparency="true" scrolling="no" src="https://googleads.g.doubleclick.net/pagead/ads?client=ca-pub-5823754184406795&amp;output=html&amp;h=280&amp;slotname=7130739364&amp;adk=1862536188&amp;adf=3894714692&amp;pi=t.ma~as.7130739364&amp;w=336&amp;abgtt=3&amp;lmt=1721184794&amp;format=336x280&amp;url=https%3A%2F%2Flinux.die.net%2Fman%2F8%2Fiscsid&amp;wgl=1&amp;dt=1721184793377&amp;bpp=3&amp;bdt=2329&amp;idt=1384&amp;shv=r20240715&amp;mjsv=m202407110101&amp;ptt=9&amp;saldr=aa&amp;abxe=1&amp;cookie_enabled=1&amp;eoidce=1&amp;correlator=3613057625671&amp;frm=20&amp;pv=2&amp;ga_vid=1748367714.1721184793&amp;ga_sid=1721184793&amp;ga_hid=921719146&amp;ga_fc=1&amp;ga_wpids=UA-50820-6&amp;u_tz=480&amp;u_his=2&amp;u_h=1080&amp;u_w=1920&amp;u_ah=1032&amp;u_aw=1920&amp;u_cd=24&amp;u_sd=1&amp;adx=546&amp;ady=389&amp;biw=1920&amp;bih=947&amp;scr_x=0&amp;scr_y=0&amp;eid=44759875%2C44759926%2C44759837%2C31085211%2C44798934%2C95332927%2C95334525%2C95334829%2C95337026%2C95337868%2C31085242%2C31084186%2C95336521%2C95336266%2C95337367&amp;oid=2&amp;pvsid=3124360703107284&amp;tmod=460061922&amp;uas=0&amp;nvt=1&amp;ref=https%3A%2F%2Flinux.die.net%2Fman%2F8%2Fiscsid%3F__cf_chl_tk%3DUmr_wHvx82oztADklCcq09e_kWLTYs7BQ1sPUhFu068-1721184778-0.0.1.1-3625&amp;fc=640&amp;brdim=-1928%2C-8%2C-1928%2C-8%2C1920%2C0%2C1936%2C1048%2C1920%2C947&amp;vis=2&amp;rsz=%7C%7CleEr%7C&amp;abl=CS&amp;pfx=0&amp;fu=0&amp;bc=31&amp;bz=1.01&amp;ifi=1&amp;uci=a!1&amp;fsb=1&amp;dtd=1396" data-google-container-id="a!1" tabindex="0" title="Advertisement" aria-label="Advertisement" data-google-query-id="CM-jsIGJrYcDFY3KFgUdrzQHsg" data-load-complete="true"></iframe>

- **[-c|--config=]\*config-file\* [-c|--config=]config-文件**

  Read configuration from *config-file* rather than the default */etc/iscsi/iscsid.conf* file.  从配置文件读取配置，而不是从默认的 /etc/iscsi/iscsid.conf 文件中读取配置。

- **[-i|--initiatorname=]\*iname-file\* [-i|--initiatorname=]iname-文件**

  Read initiator name from *iname-file* rather than the default */etc/iscsi/initiatorname.iscsi* file.  从 iname-file 读取启动器名称，而不是默认的 /etc/iscsi/initiatorname.iscsi 文件。

- **[-f|--foreground] [-f|--前景]**

  run **iscsid** in the foreground.  在前台运行 iSCSID。

- **[-d|--debug=]\*debug_level\***

  print debugging information. Valid values for debug_level are 0 to 8.  打印调试信息。debug_level 的有效值为 0 到 8。

- **[-u|--uid=]\*uid\***

  run under user ID *uid* (default is the current user ID)  在用户 ID uid 下运行（默认为当前用户 ID）

- **[-g|--gid=]\*gid\***

  run under user group ID *gid* (default is the current user group ID).  在用户组 ID gid 下运行（默认为当前用户组 ID）。

- **[-n|--no-pid-file] [-n|--no-pid-文件]**

  do not write a process ID file.  不要写入进程 ID 文件。

- **[-p|--pid=]\*pid-file\* [-p|--pid=]pid-文件**

  write process ID to *pid-file* rather than the default */var/run/iscsid.pid* 将进程 ID 写入 pid-file，而不是默认的 /var/run/iscsid.pid

- **[-h|--help] [-h|--帮助]**

  display this help and exit  显示此帮助并退出

- **[-v|--version] [-v|--版本]**

  display version and exit. 显示版本和退出。

## Files 文件

- /etc/iscsi/iscsid.conf

  The configuration file read by **iscsid** and **iscsiadm** on startup.  iscsid 和 iscsiadm 在启动时读取的配置文件。

- /etc/iscsi/initiatorname.iscsi

  The file containing the iSCSI initiatorname and initiatoralias read by **iscsid** and **iscsiadm** on startup.  包含 iscsid 和 iscsiadm 在启动时读取的 iSCSI 启动器名称和启动器别名的文件。

- /etc/iscsi/nodes /etc/iscsi/节点

  Open-iSCSI persistent configuration database Open-iSCSI 持久性配置数据库

## See Also 另见

***[iscsiadm](https://linux.die.net/man/8/iscsiadm)**(8) iscsiadm（8）*

## Authors 作者

Open-iSCSI project <http://www.open-iscsi.org/>
Open-iSCSI 项目< http://www.open-iscsi.org/>
 Alex Aizman <[itn780@yahoo.com](mailto:itn780@yahoo.com)>
亚历克斯·艾兹曼< itn780@yahoo.com>
 Dmitry Yusupov <[dmitry_yus@yahoo.com](mailto:dmitry_yus@yahoo.com)> 
德米特里·尤苏波夫< dmitry_yus@yahoo.com>

## Referenced By 引用者

**[iscsi.conf](https://linux.die.net/man/5/iscsi.conf)**(5), **[iscsid_selinux](https://linux.die.net/man/8/iscsid_selinux)**(8)