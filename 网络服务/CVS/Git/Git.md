# Git

## 安装Git
**Debian/Ubuntu:**  

    $ sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
      libz-dev libssl-dev
    $ sudo apt-get install git
**RHEL/CentOS**

    # yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
    # yum -y install git-core

**源码：**  

1 最新git源码下载地址：

https://github.com/git/git/releases  
https://www.kernel.org/pub/software/scm/git/

2 移除旧版本git

    # yum remove git

3 安装所需软件包

    # yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
    # yum install gcc-c++ perl-ExtUtils-MakeMaker

4 下载&安装

    # cd /usr/src
    # wget https://www.kernel.org/pub/software/scm/git/git-2.7.3.tar.gz

5 解压

    # tar xf git-2.7.3.tar.gz

6 配置编译安装

    # cd git-2.7.3
    # make configure
    # ./configure --prefix=/usr/git ##配置目录
    # make profix=/usr/git
    # make install

7 加入环境变量

    # echo "export PATH=$PATH:/usr/git/bin" >> /etc/profile
    # source /etc/profile

**Mac OS X：**  
一是安装homebrew，然后通过homebrew安装Git，具体方法请参考homebrew的文档：http://brew.sh/  
二是直接从AppStore安装Xcode，Xcode集成了Git，不过默认没有安装，你需要运行Xcode，选择菜单“Xcode”->“Preferences”，在弹出窗口中找到“Downloads”，选择“Command Line Tools”，点“Install”就可以完成安装了。

**Windows**

msysGit 项目：http://msysgit.github.io/

## 查看 Git 版本

    $ git --version
    git version 1.7.11.2

## 配置

变量可以存放在以下三个不同的地方：

**/etc/gitconfig** ：系统中对所有用户都普遍适用的配置。若使用 git config 时用 --system 选项，读写的就是这个文件。

**~/.gitconfig** ：用户目录下的配置文件只适用于该用户。若使用 git config 时用 --global 选项，读写的就是这个文件。

**.git/config** : 当前项目的 Git 目录中的配置文件。这里的配置仅仅针对当前项目有效。每一个级别的配置都会覆盖上层的相同配置，所以 .git/config 里的配置会覆盖 /etc/gitconfig 中的同名变量。

配置个人的用户名称和电子邮件地址：

    $ git config --global user.name "Your Name"
    $ git config --global user.email "email@example.com"

文本编辑器

设置Git默认使用的文本编辑器, 一般会是 Vi 或者 Vim。如果有其他偏好，比如 Emacs 的话，可以重新设置：

    $ git config --global core.editor emacs

差异分析工具

    $ git config --global merge.tool vimdiff

Git 可以理解 kdiff3，tkdiff，meld，xxdiff，emerge，vimdiff，gvimdiff，ecmerge，和 opendiff 等合并工具的输出信息。

查看配置信息

要检查已有的配置信息，可以使用 git config --list 命令：

    $ git config --list
    http.postbuffer=2M
    user.name=xxxx
    user.email=xxxx@xxxx.com

直接查阅某个环境变量的设定：

    $ git config user.name

## 工作流程
![](../../../Image/a/aa.png)
## 创建版本库
创建一个空目录：

    $ mkdir learngit
    $ cd learngit
通过git init命令把这个目录变成Git可以管理的仓库：

    $ git init
    Initialized empty Git repository in /Users/michael/learngit/.git/
查找一个仓库：

```
$ git grep "repository"
```

## 把文件添加到版本库

把文件添加到仓库：

    $ git add readme.txt
把文件提交到仓库：

    $ git commit -m "wrote a readme file"
    [master (root-commit) cb926e7] wrote a readme file
    1 file changed, 2 insertions(+)
    create mode 100644 readme.txt
## 其他
要随时掌握工作区的状态，使用git status命令。  
用git diff可以查看修改内容。  
![](../../../Image/a/t.png)

用git log命令查看历史记录：

    $ git log
    commit 3628164fb26d48395383f8f31179f24e0882e1e0
    Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Tue Aug 20 15:11:49 2013 +0800
    
    append GPL
    
    commit ea34578d5496d7dd233c827ed32a8cd576c5ee85
    Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Tue Aug 20 14:53:12 2013 +0800
    
    add distributed
    
    commit cb926e7ea50ad11b8f9e909c05226233bf755030
    Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Mon Aug 19 17:51:55 2013 +0800
    
    wrote a readme file
精简输出--pretty=oneline参数：

    $ git log --pretty=oneline
    3628164fb26d48395383f8f31179f24e0882e1e0 append GPL
    ea34578d5496d7dd233c827ed32a8cd576c5ee85 add distributed
    cb926e7ea50ad11b8f9e909c05226233bf755030 wrote a readme file
在Git中，用HEAD表示当前版本，上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100。  
回退到上一个版本，可以使用git reset命令：

    $ git reset --hard HEAD^
    HEAD is now at ea34578 add distributed
可以指定回到未来的某个版本：

    $ git reset --hard 3628164
    HEAD is now at 3628164 append GPL
Git的版本回退速度非常快，因为Git在内部有个指向当前版本的HEAD指针。  
恢复到新版本，查找新版本commit id，提供了一个命令git reflog用来记录每一次命令：

    $ git reflog
    ea34578 HEAD@{0}: reset: moving to HEAD^
    3628164 HEAD@{1}: commit: append GPL
    ea34578 HEAD@{2}: commit: add distributed
    cb926e7 HEAD@{3}: commit (initial): wrote a readme file
查看某次提交内容

```bash
git show commit_ID 
```

查看历史版本

```bash
git branch 新分支名 SHA值
git checkout 新分支名
```

## 工作区和暂存区

![](../../../Image/git_repository.jpg)
## 撤销修改
命令`git checkout -- readme.txt`意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：  
一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；  
一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。
总之，就是让这个文件回到最近一次git commit或git add时的状态。

用命令git reset HEAD file可以把暂存区的修改撤销掉（unstage），重新放回工作区：

    $ git reset HEAD readme.txt
    Unstaged changes after reset:
    M       readme.txt
git reset命令既可以回退版本，也可以把暂存区的修改回退到工作区。当我们用HEAD时，表示最新的版本。
## 删除文件
命令git rm用于删除一个文件。
## 添加远程库
关联一个远程库，使用命令`git remote add origin git@server-name:path/repo-name.git`。  
关联后，使用命令`git push -u origin master`第一次推送master分支的所有内容。  
每次本地提交后，只要有必要，就可以使用命令`git push origin master`推送最新修改。
## 从远程库克隆
是用命令git clone克隆一个本地库：

    $ git clone git@github.com:michaelliao/gitskills.git
    Cloning into 'gitskills'...
    remote: Counting objects: 3, done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (3/3), done.
## 分支管理
### 创建与合并分支
每次提交，Git都把它们串成一条时间线，这条时间线就是一个分支。在Git里，这个分支叫主分支，即master分支。HEAD严格来说不是指向提交，而是指向master，master才是指向提交的，所以，HEAD指向的就是当前分支。  
一开始的时候，master分支是一条线，Git用master指向最新的提交，再用HEAD指向master，就能确定当前分支，以及当前分支的提交点：

![](../../../Image/master1.png)

当创建新的分支，例如dev时，Git新建了一个指针叫dev，指向master相同的提交，再把HEAD指向dev，就表示当前分支在dev上：

![](../../../Image/master2.png)

    $ git checkout -b dev
    Switched to a new branch 'dev'
`-b`等同于：

    $ git branch dev
    $ git checkout dev
    Switched to branch 'dev'
用git branch命令查看当前分支：

    $ git branch
    * dev
      master

git branch命令会列出所有分支，当前分支前面会标一个\*号。

多次提交之后的状态：

![](../../../Image/master3.png)

进行分支合并：  

1.切换回master分支

    $ git checkout master
    Switched to branch 'master'

![](../../../Image/master4.png)

2.把dev分支的工作成果合并到master分支上：

    $ git merge dev
    Updating d17efd8..fec145a
    Fast-forward
     readme.txt |    1 +
     1 file changed, 1 insertion(+)

git merge命令用于合并指定分支到当前分支。  
合并之后：

![](../../../Image/master5.png)

删除dev分支了：

    $ git branch -d dev
    Deleted branch dev (was fec145a).
删除后，查看branch，就只剩下master分支了：

    $ git branch
    * master
### 解决冲突
![](../../../Image/master6.png)

![](../../../Image/master7.png)

Git用<<<<<<<，=======，>>>>>>>标记出不同分支的内容。  
用带参数的git log也可以看到分支的合并情况：

    $ git log --graph --pretty=oneline --abbrev-commit
    *   59bc1cb conflict fixed
    |\
    | * 75a857c AND simple
    * | 400b400 & simple
    |/
    * fec145a branch test
    ...
### 分支管理策略
通常，合并分支时，如果可能，Git会用Fast forward模式，但这种模式下，删除分支后，会丢掉分支信息。
如果要强制禁用Fast forward模式，Git就会在merge时生成一个新的commit，这样，从分支历史上就可以看出分支信息。使用--no-ff参数的git merge。

    $ git merge --no-ff -m "merge with no-ff" dev
    Merge made by the 'recursive' strategy.
     readme.txt |    1 +
     1 file changed, 1 insertion(+)
1.master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活。  
2.每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。

![](../../../Image/master8.png)

合并分支时，加上--no-ff参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，而fast forward合并就看不出来曾经做过合并。
### Bug分支
出现Bug需要立即修复，但当前工作内容尚不能提交，无法创建新的分支。Git还提供了一个stash功能，可以把当前工作现场“储藏”起来，等以后恢复现场后继续工作：

    $ git stash
    Saved working directory and index state WIP on dev: 6224937 add merge
    HEAD is now at 6224937 add merge

用git stash list命令查看保存的工作区：

    $ git stash list
    stash@{0}: WIP on dev: 6224937 add merge

工作现场还在，Git把stash内容存在某个地方了，但是需要恢复一下，有两个办法：

1.用`git stash apply`恢复，但是恢复后，stash内容并不删除，你需要用`git stash drop`来删除；  
2.用`git stash pop`，恢复的同时把stash内容也删了：

    $ git stash pop
    # On branch dev
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   hello.py
    #
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #       modified:   readme.txt
    #
    Dropped refs/stash@{0} (f624f8e5f082f2df2bed8a4e09c12fd2943bdd40)
再用`git stash list`查看，就看不到任何stash内容了：

    $ git stash list

以多次stash，恢复的时候，先用git stash list查看，然后恢复指定的stash，用命令：

    $ git stash apply stash@{0}
### Feature分支
分支尚未提交，但需要删除，只能强行删除：

    $ git branch -D feature-vulcan
    Deleted branch feature-vulcan (was 756d4af).
### 多人协作
要查看远程库的信息，用git remote：

    $ git remote
    origin
或者，用git remote -v显示更详细的信息：

    $ git remote -v
    origin  git@github.com:michaelliao/learngit.git (fetch)
    origin  git@github.com:michaelliao/learngit.git (push)
推送分支，就是把该分支上的所有本地提交推送到远程库。推送时，要指定本地分支，这样，Git就会把该分支推送到远程库对应的远程分支上：

    $ git push origin master
如果要推送其他分支，比如dev，就改成：

    $ git push origin dev
并不是一定要把本地分支往远程推送，那么，哪些分支需要推送，哪些不需要呢？

    master分支是主分支，因此要时刻与远程同步；
    dev分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；
    bug分支只用于在本地修复bug，就没必要推到远程了，除非老板要看看你每周到底修复了几个bug；
    feature分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。
抓取分支  
其他人要在dev分支上开发，就必须创建远程origin的dev分支到本地，于是用这个命令创建本地dev分支：

    $ git checkout -b dev origin/dev

设置dev和origin/dev的链接：

    $ git branch --set-upstream dev origin/dev
    Branch dev set up to track remote branch dev from origin.

再pull：

    $ git pull
    Auto-merging hello.py
    CONFLICT (content): Merge conflict in hello.py
    Automatic merge failed; fix conflicts and then commit the result.

多人协作的工作模式通常是这样：

    首先，可以试图用git push origin branch-name推送自己的修改；
    如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；
    如果合并有冲突，则解决冲突，并在本地提交；
    没有冲突或者解决掉冲突后，再用git push origin branch-name推送就能成功！

如果git pull提示“no tracking information”，则说明本地分支和远程分支的链接关系没有创建，用命令`git branch --set-upstream branch-name origin/branch-name`。
## 标签管理
### 创建标签
切换到需要打标签的分支上：

    $ git branch
    * dev
      master
    $ git checkout master
    Switched to branch 'master'

敲命令git tag <name>就可以打一个新标签：

    $ git tag v1.0

可以用命令git tag查看所有标签：

    $ git tag
    v1.0

默认标签是打在最新提交的commit上的。有时候，如果忘了打标签，比如，现在已经是周五了，但应该在周一打的标签没有打，怎么办？
方法是找到历史提交的commit id，然后打上就可以了：

    $ git log --pretty=oneline --abbrev-commit
    6a5819e merged bug fix 101
    cc17032 fix bug 101
    7825a50 merge with no-ff
    6224937 add merge
    59bc1cb conflict fixed
    400b400 & simple
    75a857c AND simple
    fec145a branch test
    d17efd8 remove test.txt
    ...

比方说要对add merge这次提交打标签，它对应的commit id是6224937，敲入命令：

    $ git tag v0.9 6224937

再用命令git tag查看标签：

    $ git tag
    v0.9
    v1.0

注意，标签不是按时间顺序列出，而是按字母排序的。可以用git show <tagname>查看标签信息：

    $ git show v0.9
    commit 622493706ab447b6bb37e4e2a2f276a20fed2ab4
     Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Thu Aug 22 11:22:08 2013 +0800
    
        add merge
    ...

可以创建带有说明的标签，用-a指定标签名，-m指定说明文字：

    $ git tag -a v0.1 -m "version 0.1 released" 3628164

用命令git show <tagname>可以看到说明文字：

    $ git show v0.1
    tag v0.1
    Tagger: Michael Liao <askxuefeng@gmail.com>
    Date:   Mon Aug 26 07:28:11 2013 +0800
    
    version 0.1 released
    
    commit 3628164fb26d48395383f8f31179f24e0882e1e0
    Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Tue Aug 20 15:11:49 2013 +0800
    
    append GPL

还可以通过-s用私钥签名一个标签：

    $ git tag -s v0.2 -m "signed version 0.2 released" fec145a

签名采用PGP签名，因此，必须首先安装gpg（GnuPG），如果没有找到gpg，或者没有gpg密钥对，就会报错：

    gpg: signing failed: secret key not available
    error: gpg failed to sign the data
    error: unable to sign the tag

用命令git show <tagname>可以看到PGP签名信息：

    $ git show v0.2
    tag v0.2
    Tagger: Michael Liao <askxuefeng@gmail.com>
    Date:   Mon Aug 26 07:28:33 2013 +0800
    
    signed version 0.2 released
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.12 (Darwin)
    
    iQEcBAABAgAGBQJSGpMhAAoJEPUxHyDAhBpT4QQIAKeHfR3bo...
    -----END PGP SIGNATURE-----
    
    commit fec145accd63cdc9ed95a2f557ea0658a2a6537f
    Author: Michael Liao <askxuefeng@gmail.com>
    Date:   Thu Aug 22 10:37:30 2013 +0800
    
    branch test

用PGP签名的标签是不可伪造的，因为可以验证PGP签名。验证签名的方法比较复杂，这里就不介绍了。
### 操作标签
如果标签打错了，也可以删除：

    $ git tag -d v0.1
    Deleted tag 'v0.1' (was e078af9)

因为创建的标签都只存储在本地，不会自动推送到远程。所以，打错的标签可以在本地安全删除。
如果要推送某个标签到远程，使用命令git push origin <tagname>：

    $ git push origin v1.0
    Total 0 (delta 0), reused 0 (delta 0)
    To git@github.com:michaelliao/learngit.git
     * [new tag]         v1.0 -> v1.0

或者，一次性推送全部尚未推送到远程的本地标签：

    $ git push origin --tags
    Counting objects: 1, done.
    Writing objects: 100% (1/1), 554 bytes, done.
    Total 1 (delta 0), reused 0 (delta 0)
    To git@github.com:michaelliao/learngit.git
     * [new tag]         v0.2 -> v0.2
     * [new tag]         v0.9 -> v0.9

如果标签已经推送到远程，要删除远程标签就麻烦一点，先从本地删除：

    $ git tag -d v0.9
    Deleted tag 'v0.9' (was 6224937)

然后，从远程删除。删除命令也是push，但是格式如下：

    $ git push origin :refs/tags/v0.9
    To git@github.com:michaelliao/learngit.git
     - [deleted]         v0.9
## 使用Github
访问项目主页，点“Fork”在自己的账号下克隆了一个仓库，然后，从自己的账号下clone：

![](../../../Image/master9.png)

一定要从自己的账号下clone仓库，这样才能推送修改。  
如果你希望官方库能接受你的修改，你就可以在GitHub上发起一个pull request。当然，对方是否接受你的pull request就不一定了。
## 自定义Git
让Git显示颜色，会让命令输出看起来更醒目：

    $ git config --global color.ui true
### 忽略特殊文件
在Git工作区的根目录下创建一个特殊的.gitignore文件，然后把要忽略的文件名填进去，Git就会自动忽略这些文件。  
不需要从头写.gitignore文件，GitHub已经为我们准备了各种配置文件，只需要组合一下就可以使用了。所有配置文件可以直接在线浏览：https://github.com/github/gitignore  
忽略文件的原则是：

    忽略操作系统自动生成的文件，比如缩略图等；
    忽略编译生成的中间文件、可执行文件等；
    忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。
### 配置别名
我们只需要敲一行命令，告诉Git，以后st就表示status：

    $ git config --global alias.st status

甚至还有人把lg配置成了：

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"  
配置文件
每个仓库的Git配置文件都放在.git/config文件中：

    $ cat .git/config
    [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
    [remote "origin"]
        url = git@github.com:michaelliao/learngit.git
        fetch = +refs/heads/*:refs/remotes/origin/*
    [branch "master"]
        remote = origin
        merge = refs/heads/master
    [alias]
        last = log -1
当前用户的Git配置文件放在用户主目录下的一个隐藏文件.gitconfig中：

    $ cat .gitconfig
    [alias]
        co = checkout
        ci = commit
        br = branch
        st = status
    [user]
        name = Your Name
        email = your@email.com
## 搭建Git服务器
第一步，安装git：

    $ sudo apt-get install git

第二步，创建一个git用户，用来运行git服务：

    $ sudo adduser git

第三步，创建证书登录：

收集所有需要登录的用户的公钥，就是他们自己的id_rsa.pub文件，把所有公钥导入到/home/git/.ssh/authorized_keys文件里，一行一个。

第四步，初始化Git仓库：

先选定一个目录作为Git仓库，假定是/srv/sample.git，在/srv目录下输入命令：

    $ sudo git init --bare sample.git

Git就会创建一个裸仓库，裸仓库没有工作区，因为服务器上的Git仓库纯粹是为了共享，所以不让用户直接登录到服务器上去改工作区，并且服务器上的Git仓库通常都以.git结尾。然后，把owner改为git：

    $ sudo chown -R git:git sample.git

第五步，禁用shell登录：

出于安全考虑，第二步创建的git用户不允许登录shell，这可以通过编辑/etc/passwd文件完成。找到类似下面的一行：

    git:x:1001:1001:,,,:/home/git:/bin/bash

改为：

    git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell

这样，git用户可以正常通过ssh使用git，但无法登录shell，因为我们为git用户指定的git-shell每次一登录就自动退出。

第六步，克隆远程仓库：

现在，可以通过git clone命令克隆远程仓库了，在各自的电脑上运行：

    $ git clone git@server:/srv/sample.git
    Cloning into 'sample'...
    warning: You appear to have cloned an empty repository.

管理公钥

如果团队很小，把每个人的公钥收集起来放到服务器的/home/git/.ssh/authorized_keys文件里就是可行的。如果团队有几百号人，就没法这么玩了，这时，可以用Gitosis来管理公钥。

管理权限

Gitolite就是这个工具。



#### 与远程仓库连接

为了与远程仓库连接，运行如下命令：

```
$ git remote add origin remote_server
```

然后检查所有配置的远程服务器，运行如下命令：

```
$ git remote -v
```

#### 克隆一个仓库

为了从本地服务器克隆一个仓库，运行如下代码：

```
$ git clone repository_path
```

如果我们想克隆远程服务器上的一个仓库，那克隆这个仓库的命令是：

```
$ git clone repository_path
```

#### 在仓库中列出分支

为了检查所有可用的和当前工作的分支列表，执行：

```
$ git branch
```

#### 创建新分支

创建并使用一个新分支，命令是：

```
$ git checkout -b 'branchname'
```

#### 删除一个分支

为了删除一个分支，执行：

```
$ git branch -d 'branchname'
```

为了删除远程仓库的一个分支，执行：

```
$ git push origin:'branchname'
```

#### 切换到另一个分支

从当前分支切换到另一个分支，使用

```
$ git checkout 'branchname'
```

#### 添加文件

添加文件到仓库，执行：

```
$ git add filename
```

#### 文件状态

检查文件状态 (那些将要提交或者添加的文件)，执行：

```
$ git status
```

#### 提交变更

在我们添加一个文件或者对一个文件作出变更之后，我们通过运行下面命令来提交代码：

```
$ git commit -a
```

提交变更到 head 但不提交到远程仓库，命令是：

```
$ git commit -m "message"
```

#### 推送变更

推送对该仓库 master 分支所做的变更，运行：

```
$ git push origin master
```

#### 推送分支到仓库

推送对单一分支做出的变更到远程仓库，运行：

```
$ git push origin 'branchname'
```

推送所有分支到远程仓库，运行：

```
$ git push -all origin
```

#### 合并两个分支

合并另一个分支到当前活动分支，使用命令：

```
$ git merge 'branchname'
```

#### 从远端服务器合并到本地服务器

从远端服务器下载/拉取变更到到本地服务器的工作目录，运行：

```
$ git pull 
```

#### 检查合并冲突

查看对库文件的合并冲突，运行：

```
$ git diff -base 'filename'
```

查看所有冲突，运行：

```
$ git diff
```

如果我们在合并之前想预览所有变更，运行：

```
$ git diff 'source-branch' 'target-branch' 
```

#### 创建标记

创建标记来标志任一重要的变更，运行：

```
$ git tag 'tag number' 'commit id' 
```

通过运行以下命令，我们可以查找 commit id ：

```
$ git log
```

#### 推送标记

推送所有创建的标记到远端服务器，运行：

```
$ git push -tags origin
```

#### 回复做出的变更

如果我们想用 head 中最后一次变更来替换对当前工作树的变更，运行：

```
$ git checkout -'filename'
```

我们也可以从远端服务器获取最新的历史，并且将它指向本地仓库的 master 分支,而不是丢弃掉所有本地所做所有变更。为了这么做，运行：

```
$ git fetch origin
$ git reset -hard master
```











带领读者在Git服务程序中提交数据、移除数据、移动数据、查询历史记录、还原数据及管理标签等实验，满足日常工作的需求。

同时还为包括了分支结构的创建与合并，遇到分支内容冲突的解决办法，动手部署Git服务器及使用Github托管服务等超实用内容。

 



我想大家还记得前面章节中谈到过Linus torvalds在1991年时发布了Linux操作系统吧，从那以后[Linux系统](https://www.linuxprobe.com/)便不断发展壮大，因为Linux系统开源的特性，所以一直接受着来自全球Linux技术爱好者的贡献，志愿者们通过邮件向Linus发送着自己编写的源代码文件，然后由Linus本人通过手工的方式将代码合并，但这样不仅没有效率，而且真的是太痛苦了。
 一直到2002年，Linux系统经过十余年的不断发展，代码库已经庞大到无法再通过手工的方式管理了，但是Linus真的很不喜欢类似于CVS或者Subversion的一些版本控制系统，于是商业公司BitMover决定将其公司的BitKeeper分布式版本控制系统授权给Linux开发社区来免费使用，当时的BitKeeper可以比较文件内容的不同，还能够将出错的文档还原到历史某个状态，Linus终于放下了心里的石头。

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git分布式版本控制流程图.jpg)

**分布式版本控制流程图，[原稿](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git分布式版本控制流程图.rar)。**

CVS和Subversion属于传统的版本控制系统，而分布式版本控制系统最大的特点是不需要每次提交都把文件推送到版本控制服务器，而是采用分布式版本库的机制，使得每个开发人员都够从服务器中克隆一份完整的版本库到自己计算机本地，不必再完全依赖于版本控制服务器，使得源代码的发布和合并更加方便，并且因为数据都在自己本地，不仅效率提高了，而且即便我们离开了网络依然可以执行提交文件、查看历史版本记录、创建分支等等操作，真的是开发者的福音啊。

就这样平静的度过了三年时间，但是Linux社区聚集着太多的黑客人物，2005年时，那位曾经开发Samba服务程序的Andrew因为试图破解BitKeeper软件协议而激怒了BitMover公司，当即决定不再向Linux社区提供免费的软件授权了，此时的Linus其实也早已有自己编写分布式版本控制系统的打算了，于是便用C语言创建了Git分布式版本控制系统，并上传了Linux系统的源代码。
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/git.jpg)Git不仅是一款开源的分布式版本控制系统，而且有其独特的功能特性，例如大多数的分布式版本控制系统只会记录每次文件的变化，说白了就是只会关心文件的内容变化差异，而Git则是关注于文件数据整体的变化，直接会将文件提交时的数据保存成快照，而非仅记录差异内容，并且使用SHA-1加密算法保证数据的完整性。

> Git为了提高效率，对于没有被修改的文件，则不会重复存储，而是创建一个链接指向之前存储过的文件。

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git提交流程图.jpg)

Git提交流程图，[原稿](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git提交流程图.rar)。

其实从发明计算机至今，编写文档工作早已融入到每个人的生活之中，但为了完成一篇好文章，一定免不了反复的修改，许多人习惯用复制整个文件的方式来保存不同的版本，或许还会改名加上备份时间以示区别，这样做的好处就是简单，但人们的思维如此活跃，一不小心就变成了这个样子：
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/文档编写的问题.png)
 无意中就创建出了这么多乱七八糟的文档，但是那个才是我想要的版本呢？而且又担心要删除的文档中可能保留有某个不错的想法，删除后就不能找回了。更要命的是，有些章节还需要团队一起编写，于是需要把文件传输给他们，等到编写后再传回来，最后由我逐条对照差别后将新的内容添加进去，这样真的是太麻烦了，我们更希望看到这样的记录吧：

| 版本 | 用户  | 说明                                          | 日期        |
| ---- | ----- | --------------------------------------------- | ----------- |
| 1    | Ronny | 创建Git章节文档                               | 10/12 13:48 |
| 2    | Dave  | 新增Git[命令](https://www.linuxcool.com/)介绍 | 10/15 12:19 |
| 3    | Aaron | 新增Github使用方法                            | 10/20 8:32  |
| 4    | Kim   | 改正文章中的错别字                            | 10/30 15:17 |



##### **21.2 使用Git服务程序**

在正式使用前，我们还需要弄清楚Git的三种重要模式，分别是已提交、已修改和已暂存：

> 已提交(committed):表示数据文件已经顺利提交到Git数据库中。
>
> 已修改(modified):表示数据文件已经被修改，但未被保存到Git数据库中。
>
> 已暂存(staged):表示数据文件已经被修改，并会在下次提交时提交到Git数据库中。

提交前的数据文件可能会被随意修改或丢失，但只要把文件快照顺利提交到Git数据库中，那就可以完全放心了，流程为：

> 1.在工作目录中修改数据文件。
>
> 2.将文件的快照放入暂存区域。
>
> 3.将暂存区域的文件快照提交到Git仓库中。

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git的三种工作状态.jpg)

Git的工作流程图，[原稿](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git的三种工作状态.rar)。

执行yum[命令](https://www.linuxcool.com/)来安装Git服务程序：

```
[root@linuxprobe ~]# yum install -y git
Loaded plugins: langpacks, product-id, subscription-manager
………………省略部分安装过程………………
Installing:
 git                    x86_64       1.8.3.1-4.el7            rhel7       4.3 M
Installing for dependencies:
 perl-Error             noarch       1:0.17020-2.el7          rhel7        32 k
 perl-Git               noarch       1.8.3.1-4.el7            rhel7        52 k
 perl-TermReadKey       x86_64       2.30-20.el7              rhel7        31 k
………………省略部分安装过程………………
Complete!
```

首次安装Git服务程序后需要设置下用户名称、邮件信息和编辑器，这些信息会随着文件每次都提交到Git数据库中，用于记录提交者的信息，而Git服务程序的配置文档通常会有三份，针对当前用户和指定仓库的配置文件优先级最高：

| 配置文件                           | 作用                                     |
| ---------------------------------- | ---------------------------------------- |
| /etc/gitconfig                     | 保存着系统中每个用户及仓库通用配置信息。 |
| ~/.gitconfig  ~/.config/git/config | 针对于当前用户的配置信息。               |
| 工作目录/.git/config               | 针对于当前仓库数据的配置信息。           |


 第一个要配置的是你个人的用户名称和电子邮件地址，这两条配置很重要，每次 Git 提交时都会引用这两条信息，记录是谁提交了文件，并且会随更新内容一起被永久纳入历史记录：

```
[root@linuxprobe ~]# git config --global user.name "Liu Chuan"
[root@linuxprobe ~]# git config --global user.email "root@linuxprobe.com"
```

设置vim为默认的文本编辑器：

```
[root@linuxprobe ~]# git config --global core.editor vim
```

嗯，此时查看下刚刚配置的Git工作环境信息吧：

```
[root@linuxprobe ~]# git config --list
user.name=Liu Chuan
user.email=root@linuxprobe.com
core.editor=vim
```

###### **21.2.1 提交数据**

我们可以简单的把工作目录理解成是一个被Git服务程序管理的目录，Git会时刻的追踪目录内文件的改动，另外在安装好了Git服务程序后，默认就会创建好了一个叫做master的分支，我们直接可以提交数据到主线了。
 创建本地的工作目录：

```
[root@linuxprobe ~]# mkdir linuxprobe
[root@linuxprobe ~]# cd linuxprobe/
```

将该目录初始化转成Git的工作目录：

```
[root@linuxprobe linuxprobe]# git init
Initialized empty Git repository in /root/linuxprobe/.git/
```

Git只能追踪类似于txt文件、网页、程序源码等文本文件的内容变化，而不能判断图片、视频、可执行命令等这些二进制文件的内容变化，所以先来尝试往里面写入一个新文件吧。

```
[root@linuxprobe linuxprobe]# echo "Initialization Git repository" > readme.txt
```

**将该文件添加到暂存区：**

```
[root@linuxprobe linuxprobe]# git add readme.txt
```

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/将文件上传到Git暂存区.jpg)
 添加到暂存区后再次修改文件的内容：

```
[root@linuxprobe linuxprobe]# echo "Something not important" >> readme.txt
```

将暂存区的文件提交到Git版本仓库，命令格式为“git commit -m "提交说明”：

```
[root@linuxprobe linuxprobe]# git commit -m "add the readme file"
[master (root-commit) 0b7e029] add the readme file
 1 file changed, 1 insertion(+)
 create mode 100644 readme.txt
```

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/将文件提交到Git版本仓库.jpg)

查看当前工作目录的状态（咦，为什么文件还是提示被修改了？）：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
# Changes not staged for commit:
#   (use "git add ..." to update what will be committed)
#   (use "git checkout -- ..." to discard changes in working directory)
#
#	modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
```

因为提交操作只是将文件在暂存区中的快照版本提交到Git版本数据库，所以当你将文件添加到暂存区后，如果又对文件做了修改，请一定要再将文件添加到暂存区后提交到Git版本数据库：

> 第一次修改 -> git add -> 第二次修改 -> git add -> git commit

查看当前文件内容与Git版本数据库中的差别：

```
[root@linuxprobe linuxprobe]# git diff readme.txt
diff --git a/readme.txt b/readme.txt
index cb06697..33d16d0 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1 +1,2 @@
 Initialization Git repository
+Something not important
```

那么现在把文件提交到Git版本数据库吧：

```
[root@linuxprobe linuxprobe]# git add readme.txt 
[root@linuxprobe linuxprobe]# git commit -m "added a line of words"
[master f7814dc] added a line of words
 1 file changed, 1 insertion(+)
```

再来查看下当前Git版本仓库的状态：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
nothing to commit, working directory clean
```

有些时候工作目录内的文件会比较多，懒的把文件一个个提交到暂存区，可以先设置下要忽略上传的文件（写入到"工作目录/.gitignore"文件中），然后使用"git add ."命令来将当前工作目录内的所有文件都一起添加到暂存区域。

```
//忽略所有以.a为后缀的文件。
*.a
//但是lib.a这个文件除外，依然会被提交。
!lib.a
//忽略build目录内的所有文件。
build/
//忽略build目录内以txt为后缀的文件。
build/*.txt
//指定忽略名字为git.c的文件。
git.c
```

先在工作目录中创建一个名字为git.c的文件：

```
[root@linuxprobe linuxprobe]# touch git.c
```

然后创建忽略文件列表：

```
[root@linuxprobe linuxprobe]# vim .gitignore
git.c
```

添加将当前工作目录中的所有文件快照上传到暂存区：

```
[root@linuxprobe linuxprobe]# git add .
[root@linuxprobe linuxprobe]# git commit -m "add the .gitignore file"
[master c2cce40] add the .gitignore file
 1 file changed, 1 insertion(+)
 create mode 100644 .gitignore
```

经过刚刚的实验，大家一定发现“添加到暂存区”真是个很麻烦的步骤，虽然使用暂存区的方式可以让提交文件更加的准确，但有时却略显繁琐，如果对要提交的文件完全有把握，我们完全可以追加-a参数，这样Git会将以前所有追踪过的文件添加到暂存区后自动的提交，从而跳过了上传暂存区的步骤，再来修改下文件：

```
[root@linuxprobe linuxprobe]# echo "Modified again" >> readme.txt
```

文件被直接提交到Git数据库：

```
[root@linuxprobe linuxprobe]# git commit -a -m "Modified again"
[master f587f3d] Modified again
 1 file changed, 1 insertion(+)
[root@linuxprobe linuxprobe]# git status
# On branch master
nothing to commit, working directory clean
```

比如想把git.c也提交上去，便可以这样强制添加文件：

```
[root@linuxprobe linuxprobe]# git add -f git.c
```

然后重新提交一次（即修改上次的提交操作）：

```
[root@linuxprobe linuxprobe]# git commit --amend
Modified again
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
#   (use "git reset HEAD^1 ..." to unstage)
#
#       new file:   git.c
#       modified:   readme.txt
#
//我们简单浏览下提交描述，然后输入:wq!保存并退出。
[master c6f4adf] Modified again
 2 files changed, 1 insertion(+)
 create mode 100644 git.c
```

**出现问题?大胆提问!**

> 因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~
>
> Linux技术交流请加A群：560843(**满**)，B群：340829(**推荐**)，[点此查看全国群](https://www.linuxprobe.com/club)。
>
> *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

###### **21.2.2 移除数据**

有些时候会想把已经添加到暂存区的文件移除，但仍然希望文件在工作目录中不丢失，换句话说，就是把文件从追踪清单中删除。
 先添加一个新文件，并上传到暂存区：

```
[root@linuxprobe linuxprobe]# touch database
[root@linuxprobe linuxprobe]# git add database
```

查看当前的Git状态：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD ..." to unstage)
#
#	new file:   database
#
```

将该文件从Git暂存区域的追踪列表中移除（并不会删除当前工作目录内的数据文件）：

```
[root@linuxprobe linuxprobe]# git rm --cached database
rm 'database'
[root@linuxprobe linuxprobe]# ls
database  git.c  readme.txt
```

此时文件已经是未追踪状态了：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
# Untracked files:
#   (use "git add ..." to include in what will be committed)
#
#	database
nothing added to commit but untracked files present (use "git add" to track)
```

而如果我们想将文件数据从Git暂存区和工作目录中一起删除，可以这样操作：
 再将database文件提交到Git暂存区：

```
[root@linuxprobe linuxprobe]# git add .
```

使用git rm命令可以直接删除暂存区内的追踪信息及工作目录内的数据文件：
 但如果在删除之前数据文件已经被放入到暂存区域的话，Git会担心你勿删未提交的文件而提示报错信息，此时可追加强制删除-f参数。

```
[root@linuxprobe linuxprobe]# git rm -f database 
rm 'database'
[root@linuxprobe linuxprobe]# ls
git.c  readme.txt
```

查看当前Git的状态：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
nothing to commit, working directory clean
```

###### **21.2.3 移动数据**

Git不像其他版本控制系统那样跟踪文件的移动操作，如果要修改文件名称，则需要使用git mv命令：

```
[root@linuxprobe linuxprobe]# git mv readme.txt introduction.txt
```

发现下次提交时会有一个改名操作：

```
[root@linuxprobe linuxprobe]# git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD ..." to unstage)
#
#	renamed:    readme.txt -> introduction.txt
#
```

提交文件到Git版本仓库：

```
[root@linuxprobe linuxprobe]# git commit -m "changed name"
[master c2674b7] changed name
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename readme.txt => introduction.txt (100%)
```

其实我们还可以这样来修改文件名，首先将工作目录下的数据文件改名：

```
[root@linuxprobe linuxprobe]# mv introduction.txt readme.txt
```

然后删除Git版本仓库内的文件快照：

```
[root@linuxprobe linuxprobe]# git rm introduction.txt
rm 'introduction.txt'
```

最后再将新的文件添加进入：

```
[root@linuxprobe linuxprobe]# git add readme.txt 
[root@linuxprobe linuxprobe]# git commit -m "changed the file name again"
[master d97dd0b] changed the file name again
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename introduction.txt => readme.txt (100%)
```

###### **21.2.4 历史记录**

在完成上面的实验后，我们已经不知不觉有了很多次的提交操作了，可以用git log命令来查看提交历史记录：

```
[root@linuxprobe linuxprobe]# git log
commit d97dd0beafa082933e044f9213809564ce2bc617
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:30:52 2016 -0500

 changed the file name again

commit c2674b7194f1f794dbb980e5d68137dec658672b
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:14:56 2016 -0500

 changed name

commit c6f4adf87e2d16e39335b621e8a14f58217fcbc4
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:12:06 2016 -0500

 Modified again

commit c2cce402ca019f4cbbf5f0bb5eb41a7e2fe277c3
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:11:21 2016 -0500

 add the .gitignore file

commit f7814dc9297799fa000159b0e291142024f0a11a
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:10:25 2016 -0500

 added a line of words

commit 0b7e02927d36e82eaa2ef7353d6910a30bf16119
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:08:38 2016 -0500

 add the readme file 
```

像上面直接执行git log命令后会看到所有的更新记录（按时间排序，最近更新的会在上面），历史记录会除了保存文件快照，还会详细的记录着文件SHA-1校验和，作者的姓名，邮箱及更新时间，如果只想看最近几条记录，可以直接这样操作：

```
[root@linuxprobe linuxprobe]# git log -2
commit d97dd0beafa082933e044f9213809564ce2bc617
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:30:52 2016 -0500

 changed the file name again

commit c2674b7194f1f794dbb980e5d68137dec658672b
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:14:56 2016 -0500

 changed name
```

我也常用-p参数来展开显示每次提交的内容差异，例如仅查看最近一次的差异：

```
[root@linuxprobe linuxprobe]# git log -p -1
commit d97dd0beafa082933e044f9213809564ce2bc617
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:30:52 2016 -0500

 changed the file name again

diff --git a/introduction.txt b/introduction.txt
deleted file mode 100644
index f3c8232..0000000
--- a/introduction.txt
+++ /dev/null
@@ -1,3 +0,0 @@
-Initialization Git repository
-Something not important
-Modified again
diff --git a/readme.txt b/readme.txt
new file mode 100644
index 0000000..f3c8232
--- /dev/null
+++ b/readme.txt
@@ -0,0 +1,3 @@
+Initialization Git repository
+Something not important
+Modified again
(END)
```

我们还可以使用--stat参数来简要的显示数据增改行数，这样就能够看到提交中修改过的内容、对文件添加或移除的行数，并在最后列出所有增减行的概要信息（仅看最近两次的提交历史）：

```
[root@linuxprobe linuxprobe]# git log --stat -2 
commit d97dd0beafa082933e044f9213809564ce2bc617
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:30:52 2016 -0500

 changed the file name again

 introduction.txt | 3 ---
 readme.txt | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

commit c2674b7194f1f794dbb980e5d68137dec658672b
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:14:56 2016 -0500

 changed name

 introduction.txt | 3 +++
 readme.txt | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)
```

还有一个超级常用的--pretty参数，它可以根据不同的格式为我们展示提交的历史信息，比如每行显示一条提交记录：

```
[root@linuxprobe linuxprobe]# git log --pretty=oneline
d97dd0beafa082933e044f9213809564ce2bc617 changed the file name again
c2674b7194f1f794dbb980e5d68137dec658672b changed name
c6f4adf87e2d16e39335b621e8a14f58217fcbc4 Modified again
c2cce402ca019f4cbbf5f0bb5eb41a7e2fe277c3 add the .gitignore file
f7814dc9297799fa000159b0e291142024f0a11a added a line of words
0b7e02927d36e82eaa2ef7353d6910a30bf16119 add the readme file
```

以更详细的模式输出最近两次的历史记录：

```
[root@linuxprobe linuxprobe]# git log --pretty=fuller -2
commit d97dd0beafa082933e044f9213809564ce2bc617
Author: Liu Chuan <root@linuxprobe.com>
AuthorDate: Mon Jan 18 01:30:52 2016 -0500
Commit: Liu Chuan <root@linuxprobe.com>
CommitDate: Mon Jan 18 01:30:52 2016 -0500

 changed the file name again

commit c2674b7194f1f794dbb980e5d68137dec658672b
Author: Liu Chuan <root@linuxprobe.com>
AuthorDate: Mon Jan 18 01:14:56 2016 -0500
Commit: Liu Chuan <root@linuxprobe.com>
CommitDate: Mon Jan 18 01:14:56 2016 -0500

 changed name
```

还可以使用format参数来指定具体的输出格式，这样非常便于后期编程的提取分析哦，常用的格式有：

| %s   | 提交说明。                    |
| ---- | ----------------------------- |
| %cd  | 提交日期。                    |
| %an  | 作者的名字。                  |
| %cn  | 提交者的姓名。                |
| %ce  | 提交者的电子邮件。            |
| %H   | 提交对象的完整SHA-1哈希字串。 |
| %h   | 提交对象的简短SHA-1哈希字串。 |
| %T   | 树对象的完整SHA-1哈希字串。   |
| %t   | 树对象的简短SHA-1哈希字串。   |
| %P   | 父对象的完整SHA-1哈希字串。   |
| %p   | 父对象的简短SHA-1哈希字串。   |
| %ad  | 作者的修订时间。              |


 另外作者和提交者是不同的，作者才是对文件作出实际修改的人，而提交者只是最后将此文件提交到Git版本数据库的人。
 查看当前所有提交记录的简短SHA-1哈希字串与提交者的姓名：

```
[root@linuxprobe linuxprobe]# git log --pretty=format:"%h %cn"d97dd0b Liu Chuan
c2674b7 Liu Chuan
c6f4adf Liu Chuan
c2cce40 Liu Chuan
f7814dc Liu Chuan
0b7e029 Liu Chuan
```

###### **21.2.5 还原数据**

还原数据是每一个版本控制的基本功能，先来随意修改下文件吧：

```
[root@linuxprobe linuxprobe]# echo "Git is a version control system" >> readme.txt
```

然后将文件提交到Git版本数据库：

```
[root@linuxprobe linuxprobe]# git add readme.txt
[root@linuxprobe linuxprobe]# git commit -m "Introduction software"
[master a41441f] Introduction software
 1 file changed, 1 insertion(+)
```

此时觉得写的不妥，想要还原某一次提交的文件快照：

```
[root@linuxprobe linuxprobe]# git log --pretty=oneline
a41441f985549a0b91f22f535ebc611c530b5b27 Introduction software
d97dd0beafa082933e044f9213809564ce2bc617 changed the file name again
c2674b7194f1f794dbb980e5d68137dec658672b changed name
c6f4adf87e2d16e39335b621e8a14f58217fcbc4 Modified again
c2cce402ca019f4cbbf5f0bb5eb41a7e2fe277c3 add the .gitignore file
f7814dc9297799fa000159b0e291142024f0a11a added a line of words
0b7e02927d36e82eaa2ef7353d6910a30bf16119 add the readme file
```

Git服务程序中有一个叫做HEAD的版本指针，当用户申请还原数据时，其实就是将HEAD指针指向到某个特定的提交版本而已，但是因为Git是分布式版本控制系统，所以不可能像SVN那样使用1、2、3、4来定义每个历史的提交版本号，为了避免历史记录冲突，故使用了SHA-1计算出十六进制的哈希字串来区分每个提交版本，像刚刚最上面最新的提交版本号就是5cee15b32d78259985bac4e0cbb0cdad72ab68ad，另外默认的HEAD版本指针会指向到最近的一次提交版本记录哦，而上一个提交版本会叫HEAD^，上上一个版本则会叫做HEAD^^，当然一般会用HEAD~5来表示往上数第五个提交版本哦~。

好啦，既然我们已经锁定了要还原的历史提交版本，就可以使用git reset命令来还原数据了：

```
[root@linuxprobe linuxprobe]# git reset --hard HEAD^
HEAD is now at d97dd0b changed the file name again
```

再来看下文件的内容吧（怎么样，内容果然已经还原了吧~）：

```
[root@linuxprobe linuxprobe]# cat readme.txt
Initialization Git repository
Something not important
Modified again
```

刚刚的操作实际上就是改变了一下HEAD版本指针的位置，说白了就是你将HEAD指针放在那里，那么你的当前工作版本就会定位在那里，要想把内容再还原到最新提交的版本，先查看下提交版本号吧：

```
[root@linuxprobe linuxprobe]# git log --pretty=oneline
d97dd0beafa082933e044f9213809564ce2bc617 changed the file name again
c2674b7194f1f794dbb980e5d68137dec658672b changed name
c6f4adf87e2d16e39335b621e8a14f58217fcbc4 Modified again
c2cce402ca019f4cbbf5f0bb5eb41a7e2fe277c3 add the .gitignore file
f7814dc9297799fa000159b0e291142024f0a11a added a line of words
0b7e02927d36e82eaa2ef7353d6910a30bf16119 add the readme file
```

怎么搞得？竟然没有了Introduction software这个提交版本记录？？
 原因很简单，因为我们当前的工作版本是历史的一个提交点，这个历史提交点还没有发生过Introduction software更新记录，所以当然就看不到了，要是想“还原到未来”的历史更新点，可以用git reflog命令来查看所有的历史记录：

```
[root@linuxprobe linuxprobe]# git reflog
d97dd0b HEAD@{0}: reset: moving to HEAD^
a41441f HEAD@{1}: commit: Introduction software
d97dd0b HEAD@{2}: commit: changed the file name again
c2674b7 HEAD@{3}: commit: changed name
c6f4adf HEAD@{4}: commit (amend): Modified again
f587f3d HEAD@{5}: commit: Modified again
c2cce40 HEAD@{6}: commit: add the .gitignore file
f7814dc HEAD@{7}: commit: added a line of words
0b7e029 HEAD@{8}: commit (initial): add the readme file
```

找到历史还原点的SHA-1值后，就可以还原文件了，另外SHA-1值没有必要写全，Git会自动去匹配：x

```
[root@linuxprobe linuxprobe]# git reset --hard 5cee15b 
HEAD is now at 5cee15b Introduction software
[root@localhost linuxprobe]# cat readme.txt 
Initialization Git repository
Something not important
Modified again
Git is a version control system
```

如是只是想把某个文件内容还原，就不必这么麻烦，直接用git checkout命令就可以的，先随便写入一段话：

```
[root@linuxprobe linuxprobe]# echo "Some mistakes words" >> readme.txt
[root@linuxprobe linuxprobe]# cat readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
Some mistakes words
```

哎呀，我们突然发现不应该写一句话的，可以手工删除（当内容比较多的时候会很麻烦），还可以将文件内容从暂存区中恢复：

```
[root@linuxprobe linuxprobe]# git checkout -- readme.txt
[root@linuxprobe linuxprobe]# cat readme.txt 
Initialization Git repository
Something not important
Modified again
Git is a version control system
```

checkou规则是如果暂存区中有该文件，则直接从暂存区恢复，如果暂存区没有该文件，则将还原成最近一次文件提交时的快照。
 **出现问题?大胆提问!**

> 因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~
>
> Linux技术交流请加A群：560843(**满**)，B群：340829(**推荐**)，[点此查看全国群](https://www.linuxprobe.com/club)。
>
> *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

###### **21.2.6 管理标签**

当版本仓库内的数据有个大的改善或者功能更新，我们经常会打一个类似于软件版本号的标签，这样通过标签就可以将版本库中的某个历史版本给记录下来，方便我们随时将特定历史时期的数据取出来用，另外打标签其实只是向某个历史版本做了一个指针，所以一般都是瞬间完成的，感觉很方便吧。
 在Git中打标签非常简单，给最近一次提交的记录打个标签：

```
[root@linuxprobe linuxprobe]# git tag v1.0
```

查看所有的已有标签：

```
[root@linuxprobe linuxprobe]# git tag
v1.0
```

查看此标签的详细信息：

```
[root@linuxprobe linuxprobe]# git show v1.0
commit a41441f985549a0b91f22f535ebc611c530b5b27
Author: Liu Chuan <root@linuxprobe.com>
Date: Mon Jan 18 01:37:45 2016 -0500

 Introduction software

diff --git a/readme.txt b/readme.txt
index f3c8232..955efba 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,3 +1,4 @@
 Initialization Git repository
 Something not important
 Modified again
+Git is a version control system
```

还可以创建带有说明的标签，用-a指定标签名，-m指定说明文字：

```
[root@linuxprobe linuxprobe]# git tag v1.1 -m "version 1.1 released" d316fb
```

我们为同一个提交版本设置了两次标签，来把之前的标签删除吧：

```
[root@linuxprobe linuxprobe]# git tag -d v1.0
Deleted tag 'v1.0' (was d316fb2)
[root@localhost linuxprobe]# git tag
v1.1
```

##### **21.3 管理分支结构**

分支即是平行空间，假设你在为某个手机系统研发拍照功能，代码已经完成了80%，但如果将这不完整的代码直接提交到git仓库中，又有可能影响到其他人的工作，此时我们便可以在该软件的项目之上创建一个名叫“拍照功能”的分支，这种分支只会属于你自己，而其他人看不到，等代码编写完成后再与原来的项目主分支合并下即可，这样即能保证代码不丢失，又不影响其他人的工作。
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git团队合作流程图.png)
 一般在实际的项目开发中，我们要尽量保证master分支是非常稳定的，仅用于发布新版本，平时不要随便直接修改里面的数据文件，而工作的时候则可以新建不同的工作分支，等到工作完成后在合并到master分支上面，所以团队的合作分支看起来会像上面图那样。

![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git分支示意图.png)

另外如前面所讲，git会将每次的提交操作串成一个时间线，而在前面的实验中实际都是在对master分支进行操作，Git会在创建分支后默认创建一个叫做Photograph的指针，所以我们还需要再将HEAD指针切换到“Photograph”的位置才正式使用上了新分支哦，这么说起来可能比较抽象，赶紧学习下面的实验吧。

###### **21.3.1 创建分支**

首先创建分支：

```
[root@linuxprobe linuxprobe]# git branch linuxprobe
```

切换至分支：

```
[root@linuxprobe linuxprobe]# git checkout linuxprobe
Switched to branch 'linuxprobe'
```

查看当前分支的情况（会列出该仓库中所有的分支，当前的分支前有＊号）：

```
[root@linuxprobe linuxprobe]# git branch
* linuxprobe
 master
```

我们对文件再追加一行字符串吧：

```
[root@linuxprobe linuxprobe]# echo "Creating a new branch is quick." >> readme.txt
```

将文件提交到git仓库：

```
[root@linuxprobe linuxprobe]# git add readme.txt
[root@linuxprobe linuxprobe]# git commit -m "new branch"
[linuxprobe 2457d98] new branch
 1 file changed, 1 insertion(+)
```

为了让大家更好理解分支的作用，我们在提交文件后再切换回master分支：

```
[root@linuxprobe linuxprobe]# git checkout master
Switched to branch 'master'
```

然后查看下文件内容，发现并没有新追加的字符串哦：

```
[root@linuxprobe linuxprobe]# cat readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
```

###### **21.3.2 合并分支**

现在，我们想把linuxprobe的工作成果合并到master分支上了，则可以使用"git merge"命令来将指定的的分支与当前分支合并：
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/合并分支.png)

```
[root@linuxprobe linuxprobe]# git merge linuxprobe
Updating a41441f..2457d98
Fast-forward
 readme.txt | 1 +
 1 file changed, 1 insertion(+)
```

查看合并后的readme.txt文件：

```
[root@linuxprobe linuxprobe]# cat readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
Creating a new branch is quick.
```

确认合并完成后，就可以放心地删除linuxprobe分支了：

```
[root@linuxprobe linuxprobe]# git branch -d linuxprobe
Deleted branch linuxprobe (was 2457d98).
```

删除后，查看branch，就只剩下master分支了：

```
[root@linuxprobe linuxprobe]# git branch
* master
```

###### **21.3.3 内容冲突**

但是Git并不能每次都为我们自动的合并分支，当遇到了内容冲突比较复杂的情况，则必须手工将差异内容处理掉，比如这样的情况：
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/冲突分支合并.png)

> 创建分支并切换到该分支命令：git checkout -b 分支名称

创建一个新分支并切换到该分支命令：

```
[root@linuxprobe linuxprobe]# git checkout -b linuxprobe
Switched to a new branch 'linuxprobe'
```

修改readme.txt文件内容：

```
[root@linuxprobe linuxprobe]# vim readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
Creating a new branch is quick.
Creating a new branch is quick & simple.
```

在linuxprobe分支上提交：

```
[root@linuxprobe linuxprobe]# git add readme.txt
[root@linuxprobe linuxprobe]# git commit -m "Creating a new branch is quick & simple. " 
[linuxprobe 882a128] Creating a new branch is quick & simple.
 1 file changed, 1 insertion(+)
```

切换到master分支：

```
[root@linuxprobe linuxprobe]# git checkout master
Switched to branch 'master'
```

在在master分支上修改readme.txt文件同一行的内容：

```
[root@linuxprobe linuxprobe]# vim readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
Creating a new branch is quick.
Creating a new branch is quick AND simple.
```

提交至Git版本仓库：

```
[root@linuxprobe linuxprobe]# git add readme.txt
Creating a new branch is quick AND simple.
[root@linuxprobe linuxprobe]# git commit -m "Creating a new branch is quick AND simple. "
[master c21741c] Creating a new branch is quick AND simple.
 1 file changed, 1 insertion(+)
```

那么此时，我们在master与linuxprobe分支上都分别对中readme.txt文件进行了修改并提交了，那这种情况下Git就没法再为我们自动的快速合并了，它只能告诉我们readme.txt文件的内容有冲突，需要手工处理冲突的内容后才能继续合并：

```
[root@linuxprobe linuxprobe]# git merge linuxprobe
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.
```

冲突的内容为：

```
[root@localhost linuxprobe]# vim readme.txt
Initialization Git repository
Something not important
Modified again
Git is a version control system
Creating a new branch is quick.
<<<<<<< HEAD
Creating a new branch is quick AND simple.
=======
Creating a new branch is quick & simple.
>>>>>>> linuxprobe
```

Git用< <<<<<<，=======，>>>>>>>分割开了各个分支冲突的内容，我们需要手工的删除这些符号，并将内容修改为：

> Initialization Git repository
>  Something not important
>  Modified again
>  Git is a version control system
>  Creating a new branch is quick.
>  **Creating a new branch is quick and simple.**

解决冲突内容后则可顺利的提交：

```
[root@linuxprobe linuxprobe]# git add readme.txt 
[root@linuxprobe linuxprobe]# git commit -m "conflict fixed" 
[master 90c607a] conflict fixed
```

查看Git历史提交记录(可以看到分支的变化)：

```
[root@linuxprobe linuxprobe]# git log --graph --pretty=oneline --abbrev-commit
* 90c607a conflict fixed
|\ 
| * 882a128 Creating a new branch is quick & simple.
* | c21741c Creating a new branch is quick AND simple.
|/ 
* 2457d98 new branch
* a41441f Introduction software
* d97dd0b changed the file name again
* c2674b7 changed name
* c6f4adf Modified again
* c2cce40 add the .gitignore file
* f7814dc added a line of words
* 0b7e029 add the readme file
```

最后，放心的删除linuxprobe分支吧：

```
[root@linuxprobe linuxprobe]# git branch -d linuxprobe
Deleted branch linuxprobe (was 882a128).
[root@linuxprobe linuxprobe]# git branch
* master
```

##### **21.4 部署Git服务器**

Git是分布式的版本控制系统，我们只要有了一个原始Git版本仓库，就可以让其他主机克隆走这个原始版本仓库，从而使得一个Git版本仓库可以被同时分布到不同的主机之上，并且每台主机的版本库都是一样的，没有主次之分，极大的保证了数据安全性，并使得用户能够自主选择向那个Git服务器推送文件了，其实部署一个git服务器是非常简单的事情，我们需要用到两台主机，分别是：

| 主机名称  | 操作系统                                         | IP地址        |
| --------- | ------------------------------------------------ | ------------- |
| Git服务器 | [红帽](https://www.linuxprobe.com/)RHEL7操作系统 | 192.168.10.10 |
| Git客户端 | [红帽](https://www.linuxprobe.com/)RHEL7操作系统 | 192.168.10.20 |


 首先我们分别在Git服务器和客户机中安装Git服务程序(刚刚实验安装过就不用安装了)：

```
[root@linuxprobe ~]# yum install git 
Loaded plugins: langpacks, product-id, subscription-manager
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Package git-1.8.3.1-4.el7.x86_64 already installed and latest version
Nothing to do
```

然后创建Git版本仓库，一般规范的方式要以.git为后缀：

```
[root@linuxprobe ~]# mkdir linuxprobe.git
```

修改Git版本仓库的所有者与所有组：

```
[root@linuxprobe ~]# chown -Rf git:git linuxprobe.git/
```

初始化Git版本仓库：

```
[root@linuxprobe ~]# cd linuxprobe.git/
[root@linuxprobe linuxprobe.git]# git --bare init
Initialized empty Git repository in /root/linuxprobe.git/
```

其实此时你的Git服务器就已经部署好了，但用户还不能向你推送数据，也不能克隆你的Git版本仓库，因为我们要在服务器上开放至少一种支持Git的协议，比如HTTP/HTTPS/SSH等，现在用的最多的就是HTTPS和SSH，我们切换至Git客户机来生成SSH密钥：

```
[root@linuxprobe ~]# ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
65:4a:53:0d:4f:ee:49:4f:94:24:82:16:7a:dd:1f:28 root@linuxprobe.com
The key's randomart image is:
+--[ RSA 2048]----+
|        .o+oo.o. |
|       .oo *.+.  |
|      ..+ E * o  |
|       o = + = . |
|        S   o o  |
|                 |
|                 |
|                 |
|                 |
+-----------------+
```

将客户机的公钥传递给Git服务器：

```
[root@linuxprobe ~]# ssh-copy-id 192.168.10.10
root@192.168.10.10's password: 
Number of key(s) added: 1
Now try logging into the machine, with: "ssh '192.168.10.10'"
and check to make sure that only the key(s) you wanted were added.
```

此时就已经可以从Git服务器中克隆版本仓库了（此时目录内没有文件是正常的）：

```
[root@linuxprobe ~]# git clone root@192.168.10.10:/root/linuxprobe.git
Cloning into 'linuxprobe'...
warning: You appear to have cloned an empty repository.
[root@linuxprobe ~]# cd linuxprobe
[root@linuxprobe linuxprobe]# 
```

初始化下Git工作环境：

```
[root@linuxprobe ~]# git config --global user.name "Liu Chuan"
[root@linuxprobe ~]# git config --global user.email "root@linuxprobe.com"
[root@linuxprobe ~]# git config --global core.editor vim
```

向Git版本仓库中提交一个新文件：

```
[root@linuxprobe linuxprobe]# echo "I successfully cloned the Git repository" > readme.txt
[root@linuxprobe linuxprobe]# git add readme.txt 
[root@linuxprobe linuxprobe]# git status
# On branch master
#
# Initial commit
#
# Changes to be committed:
#   (use "git rm --cached ..." to unstage)
#
#	new file:   readme.txt
#
[root@linuxprobe linuxprobe]# git commit -m "Clone the Git repository"
[master (root-commit) c3961c9] Clone the Git repository
 Committer: root 
1 file changed, 1 insertion(+)
 create mode 100644 readme.txt
[root@linuxprobe linuxprobe]# git status
# On branch master
nothing to commit, working directory clean
```

但是这次的操作还是只将文件提交到了本地的Git版本仓库，并没有推送到远程Git服务器，所以我们来定义下远程的Git服务器吧：

```
[root@linuxprobe linuxprobe]# git remote add server root@192.168.10.10:/root/linuxprobe.git
```

将文件提交到远程Git服务器吧：

```
[root@linuxprobe linuxprobe]# git push -u server master
Counting objects: 3, done.
Writing objects: 100% (3/3), 261 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To root@192.168.10.10:/root/linuxprobe.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from server.
```

为了验证真的是推送到了远程的Git服务，你可以换个目录再克隆一份版本仓库（虽然在工作中毫无意义）：

```
[root@linuxprobe linuxprobe]# cd ../Desktop
[root@linuxprobe Desktop]# git clone root@192.168.10.10:/root/linuxprobe.git
Cloning into 'linuxprobe'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.
[root@linuxprobe Desktop]# cd linuxprobe/
[root@linuxprobe linuxprobe]# cat readme.txt 
I successfully cloned the Git repository
```

##### **21.5 Github托管服务**

其实自己部署一台Git服务器或许很有意思，但想到你要保证这台主机能够7*24小时稳定运行，还要保证各种权限及版本库的安全就觉得很累吧，
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/github.jpg)
 Github顾名思义是一个Git版本库的托管服务，是目前全球最大的软件仓库，拥有上百万的开发者用户，也是软件开发和寻找资源的最佳途径，Github不仅可以托管各种Git版本仓库，还拥有了更美观的Web界面，您的代码文件可以被任何人克隆，使得开发者为开源项贡献代码变得更加容易，当然也可以付费购买私有库，这样高性价比的私有库真的是帮助到了很多团队和企业。
 **大多数用户都是为了寻找资源而爱上Github的，首先进入网站，点击注册(Sign up)：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/github注册帐户.png)
 **填写注册信息：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/填写注册信息.png)
 **选择仓库类型：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/选择仓库类型.png)
 **好棒，我们的GitHub帐号注册完成了：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git注册成功.png)
 **我们在向Github推送文件时，可以选择SSH协议模式，在本机生成密钥文件（上面实验已经做过，就不需要再生成了）：**

```
[root@linuxprobe ~]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
88:91:4c:db:85:b6:b4:69:ba:44:4d:b1:89:da:48:78 root@linuxprobe.com
The key's randomart image is:
+--[ RSA 2048]----+
|    . .o.        |
| . o ==+         |
|. E *=++         |
| o +.o*.         |
|  o.oo. S        |
|    o            |
|   . .           |
|    .            |
|                 |
+-----------------+
[root@linuxprobe ~]# ssh-add
```

**点击进入Github的帐户配置页面：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/点击进入Github的帐户配置页面.png)
 **点击添加SSH公钥：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/点击添加SSH公钥.png)
 将本机中的ssh公钥(.ssh/id_rsa.pub)复制到页面中，填写ssh公钥信息：![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/填写ssh公钥信息.png)
 **查看ssh公钥信息：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/查看ssh公钥信息.png)
 **好的，现在我们的准备工作已经妥当，让我们在Github上创建自己第一个Git版本仓库吧，点击创建一个新的版本仓库：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/点击创建一个新的版本仓库.png)
 **填写版本仓库的信息：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/Git创建仓库.png)
 **创建成功后会自动跳转到该仓库的页面：**
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/查看Git版本仓库信息.png)
 复制版本仓库的克隆地址：
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/复制版本仓库的克隆地址.png)
 尝试把版本仓库克隆到本地(这个版本库我会一直保留，大家可以动手克隆下试试。)：

```
[root@linuxprobe ~]# git clone  https://github.com/K130/linuxprobe.git
Cloning into 'linuxprobe'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
[root@linuxprobe ~]# cat linuxprobe/
.git/      README.md  
[root@linuxprobe ~]# cat linuxprobe/README.md 
# linuxprobe
The highest quality Linux materials
```

将该Github版本仓库添加到本机的远程列表中：

```
[root@linuxprobe linuxprobe]# git remote add linuxprobe git@github.com:K130/linuxprobe.git
[root@linuxprobe linuxprobe]# git remote
linuxprobe
origin
```

编写一个新文件：

```
[root@linuxprobe ~]# cd linuxprobe/
[root@linuxprobe linuxprobe]# echo "Based on the RHEL&Centos system" > features
```

将该文件提交到本地的Git版本仓库：

```
[root@linuxprobe linuxprobe]# git add features 
[root@linuxprobe linuxprobe]# git commit -m "add features"
```

然后将本地的Git仓库同步到远程Git服务器上(第一次请加上参数-u，代表关联本地与远程)：

```
[root@linuxprobe linuxprobe]# git push -u linuxprobe  masterCounting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 303 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:K130/linuxprobe.git
   8a5455a..f1bc411  master -> master
Branch master set up to track remote branch master from linuxprobe.
```

刷新一下Web页面，果然看到版本仓库已经同步了：
 ![第21章 使用Git分布式版本控制系统。第21章 使用Git分布式版本控制系统。](https://www.linuxprobe.com/wp-content/uploads/2015/11/查看Git版本仓库.png)
 **出现问题?大胆提问!**

> 因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~
>
> Linux技术交流请加A群：560843(**满**)，B群：340829(**推荐**)，[点此查看全国群](https://www.linuxprobe.com/club)。
>
> *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

**本章节的复习作业(答案就在问题的下一行哦，用鼠标选中即可看到的~)**

1:分布式版本控制系统对比传统版本控制系统有那些优势？

**答案：**去中心化设计让数据更加安全，管理文件数据更加的有效率。

2:将Git工作目录中的文件提交到暂存区的命令是？

**答案：**git add 

3:将Git暂存区的文件上传到版本仓库的命令是？

**答案：**git commit

4:Git是一种非常智能的程序，它能够为我们自动解决任何分支的内容冲突情况？

**答案：**错误，很多时候内容冲突后需要由人来解决合并冲突。

5：为什么我们要将ssh公钥上传到Github资料中？

**答案：**为了让Github能够验证用户身份，从而才能顺利的管理文件数据。