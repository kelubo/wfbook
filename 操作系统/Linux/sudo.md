# sudo
## 配置文件

    username  host  =  command

### 别名
User_Alias  
Cmnd_Alias  
Host_Alias

%groupname  使用本机组名。  
！   排除  

### 邮件通知
mailto  "XXXX@XXX.XXXX"     设置邮件通知目的地址。  
mail_always  on     设置邮件发送的时间。  

| 选项 | 说明 |
|---|---|
| mail_always | 每次用户运行sudo时发送电子邮件。off |
| mail_badpass | 如果运行sudo的用户没有输入正确的密码就发送电子邮件。off |
| mail_no_user | 如果运行sudo的用户在sudoers文件里不存在，就发送电子邮件。on |
| mail_no_host | 如果运行sudo的用户存在于sudoers文件中，但没有被授权在本机运行命令，就发送电子邮件。off |
| mail_no_perms | 如果运行sudo的用户存在于sudoers中，但没有他试图运行的这个命令的授权，就发送电子邮件。off |

## 命令

| 选项 | 说明 |
|---|---|
| -l | 在当前主机上打印当前用户被允许（或被禁止）运行的命令列表 |
| -L | 列出在sudoers文件里所设置的全部默认选项 |
| -b | 在后台运行给定的命令 |
| -u | 以一个非root用户的身份运行指定的命令 |