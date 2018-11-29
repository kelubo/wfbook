# RhodeCode

## 安装

1. 从 [rhodecode.com/download](https://rhodecode.com/download/) 下载最新的 RhodeCode Control installer。

2.  运行 RhodeCode Control installer 并且接受 User Licence ：

```
$ chmod 755 RhodeCode-installer-linux-*
$ ./RhodeCode-installer-linux-*
```

3. 安装一个 VCS Server，配置开机启动。

```
$ rccontrol install VCSServer

Agree to the licence agreement? [y/N]: y
IP to start the server on [127.0.0.1]:
Port for the server to start [10005]:
Creating new instance: vcsserver-1
Installing RhodeCode VCSServer
Configuring RhodeCode VCS Server ...
Supervisord state is: RUNNING
Added process group vcsserver-1
```

4. 安装 RhodeCode Enterprise 或者 RhodeCode Community 。需要确保 Mysql or Postgres 正在运行，且有一个新建的数据库。

```
 $ rccontrol install Community

 or

 $ rccontrol install Enterprise

 Username [admin]: username
 Password (min 6 chars):
 Repeat for confirmation:
 Email: your@mail.com
 Respositories location [/home/brian/repos]:
 IP to start the Enterprise server on [127.0.0.1]:
 Port for the Enterprise server to use [10004]:
 Database type - [s]qlite, [m]ysql, [p]ostresql:
 PostgreSQL selected
 Database host [127.0.0.1]:
 Database port [5432]:
 Database username: db-user-name
 Database password: somepassword
 Database name: example-db-name
```

5. 检查状态。

```
$ rccontrol status

- NAME: enterprise-1
- STATUS: RUNNING
- TYPE: Enterprise
- VERSION: 4.1.0
- URL: http://127.0.0.1:10003

- NAME: vcsserver-1
- STATUS: RUNNING
- TYPE: VCSServer
- VERSION: 4.1.0
- URL: http://127.0.0.1:10001
```

