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