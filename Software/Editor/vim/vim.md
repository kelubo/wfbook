# Vim

[TOC]

## 安装

```bash
apt-get install vim   # Ubuntu
yum install vim       # Redhat
zypper install vim    # OpenSUSE
```

## 配置

全局配置一般在 `/etc/vim/vimrc` 或者 `/etc/vimrc` ，对所有用户生效。用户个人的配置在 `~/.vimrc` 。

如果只对单次编辑启用某个配置项，可以在命令模式下，先输入一个冒号，再输入配置。

配置项一般都有"打开"和"关闭"两个设置。"关闭"就是在"打开"前面加上前缀"no"。

```bash
"打开
set number
"关闭
set nonumber
```

双引号开始的行表示注释。

查询某个配置项是打开还是关闭，可以在命令模式下，输入该配置，并在后面加上问号。

```bash
:set number?
```

上面的命令会返回`number`或者`nonumber`。

如果想查看帮助，可以使用`help`命令。

```bash
:help number
```

### 配置文件

```bash
set nocompatible
"不与 Vi 兼容（采用 Vim 自己的操作命令）。
syntax on
"打开语法高亮。自动识别代码，使用多种颜色显示。
```



> ```bash
> set showmode
> ```

在底部显示，当前处于命令模式还是插入模式。

（4）

> ```bash
> set showcmd
> ```

命令模式下，在底部显示，当前键入的指令。比如，键入的指令是`2y3d`，那么底部就会显示`2y3`，当键入`d`的时候，操作完成，显示消失。

（5）

> ```bash
> set mouse=a
> ```

支持使用鼠标。

（7）

> ```bash
> set t_Co=256
> ```

启用256色。

（8）

> ```bash
> filetype indent on
> ```

开启文件类型检查，并且载入与该类型对应的缩进规则。比如，如果编辑的是`.py`文件，Vim 就是会找 Python 的缩进规则`~/.vim/indent/python.vim`。

## 三、缩进

（10）

> ```bash
> set tabstop=2
> ```

按下 Tab 键时，Vim 显示的空格数。

（11）

> ```bash
> set shiftwidth=4
> ```

在文本上按下`>>`（增加一级缩进）、`<<`（取消一级缩进）或者`==`（取消全部缩进）时，每一级的字符数。

（12）

> ```bash
> set expandtab
> ```

由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格。

（13）

> ```bash
> set softtabstop=2
> ```

Tab 转为多少个空格。

## 四、外观

（15）

> ```bash
> set relativenumber
> ```

显示光标所在的当前行的行号，其他行都为相对于该行的相对行号。

（16）

> ```bash
> set cursorline
> ```

光标所在的当前行高亮。

（17）

> ```bash
> set textwidth=80
> ```

设置行宽，即一行显示多少个字符。

（18）

> ```bash
> set wrap
> ```

自动折行，即太长的行分成几行显示。

> ```bash
> set nowrap
> ```

关闭自动折行

（19）

> ```bash
> set linebreak
> ```

只有遇到指定的符号（比如空格、连词号和其他标点符号），才发生折行。也就是说，不会在单词内部折行。

（20）

> ```bash
> set wrapmargin=2
> ```

指定折行处与编辑窗口的右边缘之间空出的字符数。

（21）

> ```bash
> set scrolloff=5
> ```

垂直滚动时，光标距离顶部/底部的位置（单位：行）。

（22）

> ```bash
> set sidescrolloff=15
> ```

水平滚动时，光标距离行首或行尾的位置（单位：字符）。该配置在不折行时比较有用。

（23）

> ```bash
> set laststatus=2
> ```

是否显示状态栏。0 表示不显示，1 表示只在多窗口时显示，2 表示显示。

（24）

> ```bash
> set  ruler
> ```

在状态栏显示光标的当前位置（位于哪一行哪一列）。

## 五、搜索

（27）

> ```bash
> set incsearch
> ```

输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。

（28）

> ```bash
> set ignorecase
> ```

搜索时忽略大小写。

（29）

> ```bash
> set smartcase
> ```

如果同时打开了`ignorecase`，那么对于只有一个大写字母的搜索词，将大小写敏感；其他情况都是大小写不敏感。比如，搜索`Test`时，将不匹配`test`；搜索`test`时，将匹配`Test`。

## 六、编辑

（30）

> ```bash
> set spell spelllang=en_us
> ```

打开英语单词的拼写检查。

（31）

> ```bash
> set nobackup
> ```

不创建备份文件。默认情况下，文件保存时，会额外创建一个备份文件，它的文件名是在原文件名的末尾，再添加一个波浪号（〜）。

（32）

> ```bash
> set noswapfile
> ```

不创建交换文件。交换文件主要用于系统崩溃时恢复文件，文件名的开头是`.`、结尾是`.swp`。

（33）

> ```bash
> set undofile
> ```

保留撤销历史。

Vim 会在编辑时保存操作历史，用来供用户撤消更改。默认情况下，操作记录只在本次编辑时有效，一旦编辑结束、文件关闭，操作历史就消失了。

打开这个设置，可以在文件关闭后，操作记录保留在一个文件里面，继续存在。这意味着，重新打开一个文件，可以撤销上一次编辑时的操作。撤消文件是跟原文件保存在一起的隐藏文件，文件名以`.un~`开头。

（34）

> ```bash
> set backupdir=~/.vim/.backup//  
> set directory=~/.vim/.swp//
> set undodir=~/.vim/.undo// 
> ```

设置备份文件、交换文件、操作历史文件的保存位置。

结尾的`//`表示生成的文件名带有绝对路径，路径中用`%`替换目录分隔符，这样可以防止文件重名。

（35）

> ```bash
> set autochdir
> ```

自动切换工作目录。这主要用在一个 Vim 会话之中打开多个文件的情况，默认的工作目录是打开的第一个文件的目录。该配置可以将工作目录自动切换到，正在编辑的文件的目录。

（36）

> ```bash
> set noerrorbells
> ```

出错时，不要发出响声。

（37）

> ```bash
> set visualbell
> ```

出错时，发出视觉提示，通常是屏幕闪烁。

（38）

> ```bash
> set history=1000
> ```

Vim 需要记住多少次历史操作。

（39）

> ```bash
> set autoread
> ```

打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示。

（40）

> ```bash
> set listchars=tab:»■,trail:■
> set list
> ```

如果行尾有多余的空格（包括 Tab 键），该配置将让这些空格显示成可见的小方块。

（41）

> ```bash
> set wildmenu
> set wildmode=longest:list,full
> ```

命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单；第二次按下 Tab，会依次选择各个指令。                          

## 留言（34条）

​                                                         [libinx](https://www.libinx.com)  说：                

除了文章提到的设置，在我的 .vimrc 还添加了匹配 Python 开发的配置，每次新建一个 .py 的文件都可以自动添加脚本的头部信息，很方便。

func SetTitle()
 call setline(1, "\#!/usr/bin/python")
 call setline(2, "\# -*- coding=utf8 -*-")
 call setline(3, "\"\"\"")
 call setline(4, "\# @Author       : Li Bin")
 call setline(5, "\# @Created Time : ".strftime("%Y-%m-%d %H:%M:%S"))
 call setline(6, "\# @Description  : ")
 call setline(7, "\"\"\"")
 normal G
 normal o
 normal o
 endfunc 
 autocmd bufnewfile *.py call SetTitle()

​                   2018年9月16日 10:49 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393189) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         fuchao  说：                

可以用现成的吖，https://github.com/amix/vimrc

​                   2018年9月16日 11:23 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393190) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         必填  说：                

习惯用vim的人一定不要错过chrome插件vimium：https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en

有了这个神器，我浏览网页都不大需要用鼠标了。

​                   2018年9月16日 13:45 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393197) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                   

​                                                         flw  说：                

阮老师， `==` 可不是「取消全部缩进」的意思，而是「自动缩进」的意思。

​                   2018年9月16日 23:53 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393203) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         [ixx](https://jisuye.com)  说：                    

liunx等系统命令行界面默认已安装。这让VIM的使用率提高很多。
 大量的快捷键并不能提高多少效率，而快捷键的学习成本则过高。
 一般IT编码工，多数时候要在多套不同的工具间轮换使用，不同工具有相同功能但快捷键不同，即使移植与重定义快捷键也难保持完全一致，切换/记忆/学习/不混淆，的成本，大了点。
 WINDOWS的记事本这类的，最好不过。零学习成本。
 毕竟，大多数时候，编码工不是打字员，多数时候，是在思考。
 萝卜白菜各有所爱，说VIM好，也无不妥。

​                   2018年9月17日 15:17 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393209) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         吴星  说：                

vimer 分为3级
 1级 不用鼠标掌握基本操作
 2级 自定义默认配置和快捷键
 3级 摆弄各种插件

​                   2018年9月17日 21:09 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393216) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         foo  说：                 

> 
>
> ```
> 引用pengy的发言：
> ```
>
> 阮哥，我建议你弄个app，我们玩手机的直接上app看你的博客

小程序更方便，不用下app

​                   2018年9月19日 17:25 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393254) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         KingKong  说：                

set softtabstop=2
 set tabstop=2 
 这两个有什么区别?

​                   2018年9月19日 21:29 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393258) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         [ahuigo](https://ahuigo.github.io)  说：                

iterm2 默认的 Profile - Terminal: Report Terminal Type = xterm , 导致nvim 乱码`:5:130m`. 

可将 Report Terminal Type 改成 `xterm-256color` 或则 vim `:let &t_Co=8`

​                   2018年9月19日 23:01 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393259) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                      

看得我想要入门vim了

​                   2018年9月23日 10:31 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393375) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         xxxx  说：                

> ```
> 引用fuchao的发言：
> ```
>
> 可以用现成的吖，https://github.com/amix/vimrc

貌似这个配置不能用了！

​                   2018年9月28日 14:04 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393500) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         路人  说：                

请问macbook pro买了带bar的怎么办？实在是习惯不了没有esc的日子。

​                    

我的vim配置，欢迎star和fork
 https://github.com/Leptune/vim-for-coding


 我一直认为vim已经是被玩烂的了,虽然每次我都会点进去.它比emacs好入门

这些选项设置还是多翻翻:help 'option'就可以了

​                            

"结尾的//表示生成的文件名带有绝对路径，路径中用%替换目录分隔符，这样可以防止文件重名。", 这个不需要加结尾的//, 也是使用%替换目录分隔符来防止文件重名的.

​                   2020年7月27日 14:10 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-420716) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         [darnell](https://blog.csdn.net/darnell888)  说：                

有挺多一键配置的包，可以无脑配置的比较华丽，参考：https://blog.csdn.net/darnell888/article/details/108382660

​                   2020年9月10日 09:19 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-422151) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         forzew  说：                

> ```
> 引用路人的发言：
> ```
>
> 请问macbook pro买了带bar的怎么办？实在是习惯不了没有esc的日子。

inoremap jj <ESC>

​                   2021年6月 2日 16:45 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-427172) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         forzew  说：                

> ```
> 引用forzew的发言：
> ```
>
> 
>
> inoremap jj 

inoremap jj /
