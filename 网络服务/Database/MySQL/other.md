创建只读账号

```mysql
GRANT SELECT ON *.* TO dbro@'%' IDENTIFIED BY '1IbZpHnIdgb0iKTG';
# *.*                数据库.表
# dbro               用户名
# 1IbZpHnIdgb0iKTG   密码
flush privileges;
```

