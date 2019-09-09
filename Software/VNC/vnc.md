# VNC

Virtual Network Computing，由 AT&T 研发远程控制程序。

CentOS  tigervnc-manager

```bash
yum install tigervnc-server

cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:3.service
# port = 5903

vncserver

systemctl start vncserver@:3.service
systemctl enable vncserver@:3.service
```

