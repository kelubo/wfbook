# sudo

# 第 22 章 管理 sudo 访问

​			系统管理员可以授予 `sudo` 权限，以允许非 root 用户执行通常为 `root` 用户保留的管理命令。因此，非 root 用户可以在不登录 `root` 用户帐户的情况下输入这样的命令。 	

## 22.1. sudoers 中的用户授权

​				`/etc/sudoers` 文件指定哪些用户可以使用 `sudo` 命令运行哪些命令。规则可应用到单个用户和用户组。您还可以使用别名简化为主机组、命令甚至用户定义的规则。默认别名定义在 `/etc/sudoers` 文件的第一部分中。 		

​				当用户尝试使用 `sudo` 特权来运行 `/etc/sudoers` 文件中不允许的命令时，系统会在日志中记录一条消息，其中包含 `*username* : user not in sudoers` 。 		

​				默认的 `/etc/sudoers` 文件提供授权信息和示例。您可以通过删除行开头的 `#` 注释字符来激活特定的示例规则。与用户相关的授权部分标有以下介绍： 		



```none
## Next comes the main part: which users can run what software on
## which machines  (the sudoers file can be shared between multiple
## systems).
```

​				您可以使用以下格式来创建新的 `sudoers` 授权,并修改现有的授权： 		



```none
username hostname=path/to/command
```

​				其中： 		

- ​						*username* 是用户或组的名称，如 `user1` 或 `%group1`。 				
- ​						*hostname* 是应用该规则的主机的名称。 				
- ​						*path/to/command* 是命令的完整的绝对路径。您还可以通过在命令路径后面添加这些选项，将用户限制为仅使用特定的选项和参数执行命令。如果没有指定任何选项，用户可以使用带有所有选项的命令。 				

​				您可以将任何这些变量替换为 `ALL`，以将规则应用到所有用户、主机或命令。 		

警告

​					规则过于宽松（如 `ALL ALL=(ALL)ALL）`，所有用户都可以以所有主机上的所有用户的身份运行所有的命令。这可能导致安全风险。 			

​				您可以使用 `!` 操作符，来用否定的方式指定参数。例如，使用 `!root` 来指定除 `root` 用户以外的所有用户。请注意，使用允许列表来允许特定的用户、组和命令比使用阻止列表来禁止特定的用户、组和命令更安全。通过使用允许列表，您还可以阻止新的未授权的用户或组。 		

警告

​					避免使用命令的负规则，因为用户可以通过使用 `alias` 命令重命名命令来克服此类规则。 			

​				系统会从头到尾读取 `/etc/sudoers` 文件。因此，如果文件中包含用户的多个条目，则按顺序应用条目。如果值冲突，系统将使用最后匹配的项，即使它不是最具体的匹配。 		

​				向 `sudoers` 中添加新规则的首选方法是在 `/etc/sudoers.d/` 目录中创建一个新文件，而不是将规则直接输入到 `/etc/sudoers` 文件中。这是因为此目录的内容在系统更新期间被保留了。此外，修复单独文件中的任何错误要比修复 `/etc/sudoers` 文件中的错误更容易。当系统在 `/etc/sudoers` 文件中达到以下行时，会读取 `/etc/sudoers.d` 目录中的文件： 		



```none
#includedir /etc/sudoers.d
```

​				请注意，此行开头的数字符号 `#` 是语法的一部分，并不意味着该行是一个注释。该目录中文件的名称不得包含句点 `.`，且不得以波形符 `~` 结尾。 		

**其他资源**

- ​						`sudo (8)` 和 `sudoers (5)` 手册页 				

## 22.2. 为用户授予 sudo 访问权限

​				系统管理员可以授予 `sudo` 访问权限来允许非 root 用户执行管理命令。`sudo` 命令在不使用 `root` 用户密码的情况下为用户提供管理访问。 		

​				当用户需要执行管理命令时，您可以在使用 `sudo` 命令前执行该命令。然后会像 `root` 用户一样执行该命令。 		

​				请注意以下限制： 		

- ​						只有 `/etc/sudoers` 配置文件中列出的用户才能使用 `sudo` 命令。 				
- ​						该命令在用户的 shell 中执行，而不是在 `root` shell 中执行。 				

**先决条件**

- ​						`root` 访问权限 				

**流程**

1. ​						以 root 身份，打开 `/etc/sudoers` 文件。 				

   

   ```none
   # visudo
   ```

   ​						`/etc/sudoers` 文件定义 `sudo` 命令应用的策略。 				

2. ​						在 `/etc/sudoers` 文件中，找到为 `wheel` 管理组中用户授予 `sudo` 访问权限的行。 				

   

   ```none
   ## Allows people in group wheel to run all commands
   %wheel        ALL=(ALL)       ALL
   ```

3. ​						确保以 `%wheel` 开头的行前面没有 `#` 注释符。 				

4. ​						保存所有更改并退出编辑器。 				

5. ​						将您要授予 `sudo` 访问权限的用户添加到 `wheel` 管理组中。 				

   

   ```none
    # usermod --append -G wheel <username>
   ```

   ​						将 *<username* > 替换为用户的名称。 				

**验证步骤**

- ​						验证该用户是否已被添加到 `wheel` 管理组中： 				

  

  ```none
  # id <username>
  uid=5000(<username>) gid=5000(<username>) groups=5000(<username>),10(wheel)
  ```

**其他资源**

- ​						`sudo (` 8)、`visudo (8)` 和 `sudoers (5)` 手册页 				

## 22.3. 使非特权用户运行某些命令

​				作为管理员，您可以通过在 `/etc/sudoers.d/` 目录中配置策略来允许非特权用户在特定工作站上输入某些命令。 		

​				例如，您可以使用 `dnf` 命令以及 `sudo` 特权来允许用户在 *<example.user>* `host.example.com` 工作站上安装程序。 		

**先决条件**

- ​						您必须有系统的 `root` 访问权限。 				

**流程**

1. ​						以 `root` 用户身份，在 `/etc/` 下创建一个新的 `sudoers.d` 目录： 				

   

   ```none
   # mkdir -p /etc/sudoers.d/
   ```

2. ​						在 `/etc/sudoers.d` 目录中创建一个新文件： 				

   

   ```none
   # visudo -f /etc/sudoers.d/<example.user>
   ```

   ​						文件会自动打开。 				

3. ​						在 `/etc/sudoers.d/*<example.user>*` 文件中添加以下行： 				

   

   ```none
   <example.user> <host.example.com> = /usr/bin/dnf
   ```

   ​						要在一行中在同一主机上允许两个或多个命令，您可以用逗号分隔来列出这些命令 `，` 后跟一个空格。 				

4. ​						可选：要在用户每次 *<example.user>* 尝试使用 `sudo` 权限时收到电子邮件通知，请在文件中添加以下行： 				

   

   ```none
   Defaults    mail_always
   Defaults    mailto="<email@example.com>"
   ```

5. ​						保存更改，再退出编辑器。 				

**验证**

1. ​						要验证用户是否 *<example.user>* 可以使用 `sudo` 权限运行 `dnf` 命令，请切换帐户： 				

   

   ```none
   # su <example.user> -
   ```

2. ​						输入 `sudo dnf` 命令： 				

   

   ```none
   $ sudo dnf
   [sudo] password for <example.user>:
   ```

   ​						输入用户 *<example.user>* 的 `sudo` 密码。 				

3. ​						系统显示 `dnf` 命令和选项列表： 				

   

   ```none
   ...
   usage: dnf [options] COMMAND
   ...
   ```

   ​						如果系统返回 `*<example.user>* 不在 sudoers 文件中。将报告此事件` 错误信息，您没有 *<example.user>* 在 `/etc/sudoers.d/` 中创建文件。 				

   ​						如果您收到，`*<example.user>* 不允许在 < *host.example.com>*` 错误消息上运行 sudo，则您尚未正确完成配置。确保您已以 `root` 身份登录，并且您遵循了这些步骤。 				

**其他资源**

- ​						`sudo (` 8)、`visudo (8)` 和 `sudoers (5)` 手册页 				

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