# 版本控制系统

| 软件      | 语言                | 备注   |
|-----------|---------------------|--------|
| CVS       |                     |        |
| SVN       |                     |        |
| Git       | C Shell Perl Python | 分布式 |
| Mercurial | Python C            | 分布式 |

## CVS
![](../Image/a/r.png)
## SVN
![](../Image/a/s.png)

## 协同模式对比
**集中式**  
![](../Image/a/u.png)  
**分布式**  
![](../Image/a/v.png)  
**Github**  
![](../Image/a/w.png)

## 命令对照

| 比较项目 | Git命令 | Hg命令 |
|----------|---------|--------|
| URL      | git://host/path/to/repos.git <br> ssh://user@host/path/to/repos.git <br> user@host:path/to/repos.git <br> file:///path/to/repos.git <br> /path/to/repos.git | http://host/path/to/repos <br> ssh://user@host/path/to/repos <br> file:///path/to/repos <br> /path/to/repos |
| 配置 | [user] <br> name = Fristname Lastname <br> email = mail@addr | [ui] <br> username = Firstname Lastname <mail@addr> |
| 版本库初始化| git init [-bare] `<path>` | hg init `<path>` |
| 版本库克隆| git clone `<url>` `<path>` | hg clone `<url>` `<path>` |
||||
||||
||||
||||
||||
||||
||||
||||
