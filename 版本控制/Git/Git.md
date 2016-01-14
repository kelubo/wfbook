# Git
## 安装Git
**Debian/Ubuntu:**  

    sudo apt-get install git
**源码：**  

    ./config
    make
    sudo make install
**Mac OS X：**  
一是安装homebrew，然后通过homebrew安装Git，具体方法请参考homebrew的文档：http://brew.sh/  
二是直接从AppStore安装Xcode，Xcode集成了Git，不过默认没有安装，你需要运行Xcode，选择菜单“Xcode”->“Preferences”，在弹出窗口中找到“Downloads”，选择“Command Line Tools”，点“Install”就可以完成安装了。
## 配置
在命令行输入：

    $ git config --global user.name "Your Name"
    $ git config --global user.email "email@example.com"
## 创建版本库
创建一个空目录：

    $ mkdir learngit
    $ cd learngit
    $ pwd
    /Users/michael/learngit
通过git init命令把这个目录变成Git可以管理的仓库：

    $ git init
    Initialized empty Git repository in /Users/michael/learngit/.git/
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
## 工作区和暂存区
![](../../Image/git_repository.jpg)
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

![](../../Image/master1.png)

当创建新的分支，例如dev时，Git新建了一个指针叫dev，指向master相同的提交，再把HEAD指向dev，就表示当前分支在dev上：

![](../../Image/master2.png)

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

git branch命令会列出所有分支，当前分支前面会标一个*号。

多次提交之后的状态：

![](../../Image/master3.png)

进行分支合并：  

1.切换回master分支

    $ git checkout master
    Switched to branch 'master'

![](../../Image/master4.png)

2.把dev分支的工作成果合并到master分支上：

    $ git merge dev
    Updating d17efd8..fec145a
    Fast-forward
     readme.txt |    1 +
     1 file changed, 1 insertion(+)

git merge命令用于合并指定分支到当前分支。  
合并之后：

![](../../Image/master5.png)

删除dev分支了：

    $ git branch -d dev
    Deleted branch dev (was fec145a).
删除后，查看branch，就只剩下master分支了：

    $ git branch
    * master
### 解决冲突
![](../../Image/master6.png)

![](../../Image/master7.png)

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

![](../../Image/master8.png)

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

![](../../Image/master9.png)

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