# Vim

[TOC]

## 概述

Vim 是 UNIX 文本编辑器 Vi 的加强版本,加入了更多特性来帮助编辑源代码。

Vim  的部分增强功能包括文件比较（vimdiff），语法高亮，全面的帮助系统，本地脚本（Vimscript），和便于选择的可视化模式。 Vim  专注于键盘操作，并不是像 nano 或 pico 一样的简单编辑器。

## 安装

安装下面两个软件包中的一个：

- vim

  提供 Python 2/3, Lua, Ruby 和 Perl 解释器支持，但没有 GTK/X 支持

- gvim

  除了提供和 `vim` 一样的功能外，还提供了图像界面。

> **注意:**
>
> - vim 不包含 Xorg 支持。因此 Vim 缺失了 `+clipboard` 特性，Vim也就不能够同 X11 的 *primary* 和 *clipboard* 剪切板交互。
> - gvim 在全面支持图形界面的同时，提供了命令行版本带 `+clipboard `的 Vim 。
> - 非官方源 herecura 提供大量 Vim / gVim 变种版本: `vim-cli` `vim-gvim-common` `vim-gvim-gtk` `vim-gvim-qt` `vim-rt` 和 `vim-tiny`。

```bash
yum install vim       # Redhat
zypper install vim    # OpenSUSE
apt-get install vim   # Ubuntu
```



# 常用指令收集

- 系统时间（在光标之后追加当前的日期和时间） : map <F7> a<C-R>=strftime("%c")<CR><esc>
- 系统时间（将__date__替换成当前日期，使用strftime函数）:s/__date__/\=strftime("%c")/

# 基础命令

- ctrl+q       可以联合复制，粘贴，替换用 行操作
- ctrl+w+j ctrl+w+k (:bn :bp :bd)
- '.         它移动光标到上一次的修改行 
- `.         它移动光标到上一次的修改点
-  .          重复上次命令
-   <C-O> :       依次沿着你的跳转记录向回跳 (从最近的一次开始)
-  <C-I> :       依次沿着你的跳转记录向前跳
- ju(mps) :      列出你跳转的足迹
- :history :     列出历史命令记录
- :his c :      命令行命令历史
- :his s :      搜索命令历史
- q/ :        搜索命令历史的窗口
- q: :        命令行命令历史的窗口
- g ctrl+g      计算文件字符
- {,}         前进至上一段落前进至后一段落
- gg,G(2G)      文件首
- gd dw gf ga(进制转化)
- gg=G 全篇自动缩进 , =G 单行缩进
- \* ci[ 删除一对 [] 中的所有字符并进入插入模式
- \* ci( 删除一对 () 中的所有字符并进入插入模式
- \* ci< 删除一对 <> 中的所有字符并进入插入模式
- \* ci{ 删除一对 {} 中的所有字符并进入插入模式
- \* cit 删除一对 HTML/XML 的标签内部的所有字符并进入插入模式
- \* ci” ci’ ci` 删除一对引号字符 (” 或 ‘ 或 `) 中所有字符并进入插入模式
- \* vi[ 选择一对 [] 中的所有字符
- \* vi( 选择一对 () 中的所有字符
- \* vi< 选择一对 <> 中的所有字符
- \* vi{ 选择一对 {} 中的所有字符
- \* vit 选择一对 HTML/XML 的标签内部的所有字符
- \* vi” vi’ vi` 选择一对引号字符 (” 或 ‘ 或 `) 中所有字符
- crl+] 函数原型处 crl+t 回 ( ctags )
- ctl+p 自动补全( 编辑状态 )
- :X 加密保存( 要输入密码 )
- ? /     (N n)
- f(F,t) 查找字符
-  w(e) 移动光标到下一个单词.
- 5fx 表示查找光标后第 5 个 x 字符.
- 5w(e) 移动光标到下五个单词.
- b 移动光标到上一个单词.
- 0 移动光标到本行最开头.
- ^ 移动光标到本行最开头的字符处.
- $ 移动光标到本行结尾处.
- H 移动光标到屏幕的首行. 
- M 移动光标到屏幕的中间一行.
- L 移动光标到屏幕的尾行.
-  c-f (即 ctrl 键与 f 键一同按下)
- c-b (即 ctrl 键与 b 键一同按下) 翻页
- c-d (下半页) c-u(上半页) c-e (一行滚动)
- zz 让光标所在的行居屏幕中央
- zt 让光标所在的行居屏幕最上一行
- zb 让光标所在的行居屏幕最下一行
- 在 vi 中 y 表示拷贝, d 表示删除, p 表示粘贴. 其中拷贝与删除是与光标移动命令
- yw 表示拷贝从当前光标到光标所在单词结尾的内容.
-  dw 表示删除从当前光标到光标所在单词结尾的内容.
- y0 表示拷贝从当前光标到光标所在行首的内容.
- d0 表示删除从当前光标到光标所在行首的内容.
- y$(Y) 表示拷贝从当前光标到光标所在行尾的内容.
- d$(D) 表示删除从当前光标到光标所在行尾的内容.
- yfa 表示拷贝从当前光标到光标后面的第一个a字符之间的内容.
- dfa 表示删除从当前光标到光标后面的第一个a字符之间的内容.
- s(S),a(A),x(X),D
- yy 表示拷贝光标所在行.
- dd 表示删除光标所在行.
- 5yy 表示拷贝光标以下 5 行.
- 5dd 表示删除光标以下 5 行.
- y2fa 表示拷贝从当前光标到光标后面的第二个a字符之间的内容.
- :12,24y 表示拷贝第12行到第24行之间的内容.
- :12,y 表示拷贝第12行到光标所在行之间的内容.
- :,24y 表示拷贝光标所在行到第24行之间的内容. 删除类似.
- TAB 就是制表符, 单独拿出来做一节是因为这个东西确实很有用.
-  << 输入此命令则光标所在行向左移动一个 tab.
- \>> 输入此命令则光标所在行向右移动一个 tab.
- 5>> 输入此命令则光标后 5 行向右移动一个 tab.
-  :5>>(>>>) :>>(>>>)5
- :12,24> 此命令将12行到14行的数据都向右移动一个 tab.
- :12,24>> 此命令将12行到14行的数据都向右移动两个 tab.
- :set shiftwidth=4 设置自动缩进 4 个空格, 当然要设自动缩进先.
- :set sts=4 即设置 softtabstop 为 4. 输入 tab 后就跳了 4 格.
- :set tabstop=4 实际的 tab 即为 4 个空格, 而不是缺省的 8 个.
- :set expandtab 在输入 tab 后, vim 用恰当的空格来填充这个 tab.
- :g/^/exec 's/^/'.strpart(line('.').' ', 0, 4) 在行首插入行号
-  set ai 设置自动缩进
- 5ia<esc> 重复插入5个a字符

#  替换命令

-  替换文字 2009-02-34 ----> 2009-02-34 00:00:00   :%s/\(\d\{4\}-\d\{2\}-\d\{2\}\)/\1 00:00:00/g
- :%s/^/heaser/   在每一行头部添加header
- :%s/$/ender/   在每一行尾部添加ender
- :s/aa/bb/g       将光标所在行出现的所有包含 aa 的字符串中的 aa 替换为 bb
- :s/\/bb/g        将光标所在行出现的所有 aa 替换为 bb, 仅替换 aa 这个单词
- :%s/aa/bb/g       将文档中出现的所有包含 aa 的字符串中的 aa 替换为 bb
- :12,23s/aa/bb/g     将从12行到23行中出现的所有包含 aa 的字符串中的 aa 替换为 bb
- :12,23s/^/#/      将从12行到23行的行首加入 # 字符
- :%s/fred/joe/igc      一个常见的替换命令，修饰符igc和perl中一样意思
- s/dick/joe/igc则    对于这些满足条件的行进行替换
- :g/^\s*$/d       空行(空格也不包含)删除.
- :%s/\r//g        删除DOS方式的回车^M
- :%s/ *$//        删除行尾空白(%s/\s*$//g)
- :g!/^dd/d        删除不含字符串'dd'开头的行
- :v/^dd/d        同上,译释：v == g!，就是不匹配！
- :v/./.,/./-1join    压缩空行(多行空行合并为一行)
- :g/^$/,/./-j      压缩空行(多行空行合并为一行)
- :g/^/pu _        把文中空行扩增一倍 (pu = put),原来两行间有一个空行，现在变成2个
-  :g/^/m0         按行翻转文章 (m = move)
- :g/fred/,/joe/d     not line based (very powerfull)
- :g/<input\|<form/p   或者 要用\|
- :g/fred/t$       拷贝行，从fred到文件末尾(EOF)
- :%norm jdd       隔行删除,

译释：%指明是对所有行进行操作,norm指出后面是normal模式的指令,j是下移一行，dd是删除行

-  :'a,'bg/fred/s/dick/joe/igc  ('a,'b指定一个范围：mark a ~ mark b)
- g//用一个正则表达式指出了进行操作的行必须可以被fred匹配,g//是一个全局显示命令
-  /joe/e         光标停留在匹配单词最后一个字母处
- /joe/e+1        光标停留在匹配单词最后一个字母的下一个字母处
- /joe/s         光标停留在匹配单词第一个字母处
- /^joe.*fred.*bill/   标准正则表达式
- /^[A-J]\+/       找一个以A~J中一个字母重复两次或以上开头的行
- /forum\(\_.\)*pent   多行匹配
- /fred\_s*joe/i     中间可以有任何空白，包括换行符\n
- /fred\|joe       匹配FRED或JOE
- /\<fred\>/i       匹配fred,fred必须是一个独立的单词，而不是子串
- /\<\d\d\d\d\>      匹配4个数字 \<\d\{4}\>  列，
- 替换所有在第三列中的str1   :%s:\(\(\w\+\s\+\)\{2}\)str1:\1str2:
-  交换第一列和最后一列 (共4列)  :%s:\(\w\+\)\(.*\s\+\)\(\w\+\)$:\3\2\1:
- 全局(global)显示命令，就是用 :g＋正则表达式

译释： :g/{pattern}/{cmd} 就是全局找到匹配的,然后对这些行执行命令{cmd}

- :g/\<fred\>/                显示所有能够为单词fred所匹配的行
-  :g/<pattern>/z#.5              显示内容，还有行号
- :g/<pattern>/z#.5|echo '=========='     漂亮的显示

​    

# 多文档操作 (基础)

-  用 :ls! 可以显示出当前所有的buffer
- :bn         跳转到下一个buffer
- :bp         跳转到上一个buffer
- :wn         存盘当前文件并跳转到下一个
- :wp         存盘当前文件并跳转到上一个
- :bd         把这个文件从buffer列表中做掉
- :b 3        跳到第3个buffer
- :b main       跳到一个名字中包含main的buffer

# 列复制

- 译注：@#%&^#*^%#$!
- :%s= [^ ]\+$=&&= : 复制最后一列
-  :%s= \f\+$=&&= : 一样的功能
- :%s= \S\+$=&& : ft,还是一样反向引用，或称记忆
- :s/\(.*\):\(.*\)/\2 : \1/ : 颠倒用:分割的两个字段
- :%s/^\(.*\)\n\1/\1$/ : 删除重复行
- 非贪婪匹配，\{-}
- :%s/^.\{-}pdf/new.pdf/ : 只是删除第一个pdf 跨越可能的多行
-  :%s/<!--\_.\{-}-->// : 又是删除多行注释（咦？为什么要说「又」呢？）
- :help /\{-} : 看看关于 非贪婪数量符 的帮助
- :s/fred/<c-r>a/g : 替换fred成register a中的内容，呵呵，
- 写在一行里的复杂命令  :%s/\f\+\.gif\>/\r&\r/g | v/\.gif$/d | %s/gif/jpg/

译注：就是用 | 管道啦

# 大小写转换

- g~~ : 行翻转
- vEU : 字大写(广义字)
- vE~ : 字翻转(广义字)
-  ~  将光标下的字母改变大小写
-  3~ 将下3个字母改变其大小写
-  g~w 字翻转
-  U  将可视模式下的字母全改成大写字母
- gUU 将当前行的字母改成大写
-  u  将可视模式下的字母全改成小写
-  guu 将当前行的字母全改成小写
- gUw 将光标下的单词改成大写
- guw 将光标下的单词改成小写。

# 文件浏览

-  :Ex : 开启目录浏览器，注意首字母E是大写的
- :Sex : 在一个分割的窗口中开启目录浏览器
- :ls : 显示当前buffer的情况
- :cd .. : 进入父目录
-  :pwd
- :args : 显示目前打开的文件
- :lcd %:p:h : 更改到当前文件所在的目录

译释：lcd是仅仅改变当前窗口的工作路径，% 是代表当前文件的文件名，加上 :p扩展成全名（就是带了路径），加上 :h析取出路径 



#### 以下是一张vim常用命令速查表：![685007-20190219103431877-1441653557](https://atts.w3cschool.cn/attachments/image/20200807/1596764532593063.png)

​    ![img](https://atts.w3cschool.cn/attachments/day_220317/202203171026268453.gif)



## 配置

用户配置文件为`~/.vimrc`，相关的文件位于`~/.vim/`；全局配置文件为`/etc/vimrc`，相关的文件位于`/usr/share/vim/`。

如果需要常用的功能（如语法高亮、打开文件时回到上一次的光标位置等），将配置文件范例加到`/etc/vimrc`中：

```
/etc/vimrc/
...
runtime! vimrc_example.vim
```

### 语法高亮

启用语法高亮（Vim支持许多语言的语法高亮）：

```
:filetype plugin on
:syntax on
```

### 自动换行显示

`wrap`默认是开启的，这会使Vim在一行文本的长度超过窗口宽度时，自动将放不下的文本显示到下一行。`wrap`只会影响文本的显示，文本本身不会被改变。

自动换行显示一般在该行窗口能容纳下的最后一个字符发生，即使刚好是在一个单词的中间。更为智能的自动换行显示可以用`linebreak`来控制。当用`set linebreak`开启时，自动换行发生在字符串选项`breakat`中列出来的字符之后。默认情况下，`breakat`包含空格和一些标点符号（参考`:help breakat`）。

被换行的字符一般在下一行的开头开始显示，没有任何相应的缩进。[breakindent][13] 指示Vim在换行时将缩进考虑在内，因而新行将与原本要显示的文本有相同的缩进。`breakindent`行为可以用`breakindentopt`选项来调整，比如说在Python文件中，新行将在原本缩进的基础上再缩进4个空格（更多细节参考`:help breakindentopt`）：

```
autocmd FileType python set breakindentopt=shift:4
```

### 使用鼠标

Vim可以使用鼠标，但只在一些终端上起作用（Linux上的[xterm](https://wiki.archlinux.org/index.php/Xterm)和带有[gpm](https://www.archlinux.org/packages/?name=gpm)的Linux控制台，更多细节参阅[Console mouse support](https://wiki.archlinux.org/index.php/Console_mouse_support)）：

开启这个功能，将下面这行代码加入`~/.vimrc`中：

```
set mouse=a
```

> **注意:**
>
> - 这个方法在使用SSH的PuTTY中同样适用。
> - 在PuTTY中，通常的高亮/复制行为有所不同，因为在使用鼠标时，Vim会进入可视模式。为了用能鼠标选中文本，需要同时按住`Shift`键。

### 跨行移动光标

默认情况下，在行首按`←`或者在行尾按`→`不能将光标移动至上一行或下一行。

如要改变默认行为，将`set whichwrap=b,s,<,>,[,]`加至你的`~/.vimrc`文件中。

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

# vim配置.vimrc方案



```
"VIM配置件
"2016-07-11
"是否兼容VI，compatible为兼容，nocompatible为不完全兼容
"如果设置为compatible，则tab将不会变成空格
set nocompatible
"设置鼠标运行模式为WINDOWS模式
behave mswin

"设置菜单语言
set encoding=chinese 
set langmenu=zh_CN.UTF-8 

" =========
" 功能函数
" =========
" 获取当前目录
func GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" =====================
" 多语言环境
"    默认为 UTF-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    "language messages zh_CN.utf-8

    if has('win32')
        language english
        let &termencoding=&encoding
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" =========
" 环境配置
" =========

" 保留历史记录
set history=400

" 命令行于状态行
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]\ %l,%c\ %=\ %P 
set ls=2 " 始终显示状态行

" 制表符
set tabstop=4
"把tab转成空格
"set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" 状态栏显示目前所执行的指令
set showcmd 

" 行控制
set linebreak
set nocompatible
set textwidth=80
set wrap

" 行号和标尺
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" 控制台响铃
:set noerrorbells
:set novisualbell
:set t_vb= "close visual bell

" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start

" 标签页
set tabpagemax=20
set showtabline=2

" 缩进 智能对齐方式
set autoindent
set smartindent

" 自动重新读入
set autoread

"代码折叠
"设置折叠模式
set foldcolumn=4
"光标遇到折叠，折叠就打开
"set foldopen=all
"移开折叠时自动关闭折叠
"set foldclose=all
"zf zo zc zd zr zm zR zM zn zi zN
"依缩进折叠
"   manual  手工定义折叠
"   indent  更多的缩进表示更高级别的折叠
"   expr    用表达式来定义折叠
"   syntax  用语法高亮来定义折叠
"   diff    对没有更改的文本进行折叠
"   marker  对文中的标志折叠
set foldmethod=syntax
"启动时不要自动折叠代码
set foldlevel=100
"依标记折叠
set foldmethod=marker

"语法高亮
syntax enable
syntax on

"设置配色
set guifont=Courier\ New:h12
colorscheme desert

"设定文件浏览器目录为当前目录
set bsdir=buffer

" 自动切换到文件当前目录
set autochdir

"在查找时忽略大小写
set ignorecase
set incsearch
set hlsearch
 
"设置命令行的高度
set cmdheight=2

"显示匹配的括号
set showmatch

"增强模式中的命令行自动完成操作
set wildmenu

"使PHP识别EOT字符串
hi link phpheredoc string
"php语法折叠
let php_folding = 1
"允许在有未保存的修改时切换缓冲区
set hidden

"实现全能补全功能，需要打开文件类型检测
"filetype plugin indent on
"打开vim的文件类型自动检测功能
"filetype on

"保存文件的格式顺序
set fileformats=dos,unix
"置粘贴模式，这样粘贴过来的程序代码就不会错位了。
set paste

"在所有模式下都允许使用鼠标，还可以是n,v,i,c等
set mouse=a

" 恢复上次文件打开位置
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"取得光标处的匹配
function! GetPatternAtCursor(pat)
    let col = col('.') - 1
    let line = getline('.')
    let ebeg = -1
    let cont = match(line, a:pat, 0)
    while (ebeg >= 0 || (0 <= cont) && (cont <= col))
        let contn = matchend(line, a:pat, cont)
        if (cont <= col) && (col < contn)
            let ebeg = match(line, a:pat, cont)
            let elen = contn - ebeg
            break
        else
            let cont = match(line, a:pat, contn)
        endif
    endwh
    if ebeg >= 0
        return strpart(line, ebeg, elen)
    else
        return ""
    endif
endfunction

" =========
" 图形界面
" =========
if has('gui_running')
    " 只显示菜单
    set guioptions=mcr

    " 高亮光标所在的行
    set cursorline

    " 编辑器配色
	colorscheme desert
    "colorscheme zenburn
    "colorscheme dusk

    if has("win32")
        " Windows 兼容配置
        source $VIMRUNTIME/vimrc_example.vim
		source $VIMRUNTIME/mswin.vim

		"设置鼠标运行模式为WINDOWS模式
		behave mswin

        " f11 最大化
        map <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " 字体配置
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h12:cANSI'
        "exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h12'
    endif

    if has("unix") && !has('gui_macvim')
        set guifont=Courier\ 10\ Pitch\ 11
        set guifontwide=YaHei\ Consolas\ Hybrid\ 11
    endif

    if has("mac") || has("gui_macvim")
        set guifont=Courier\ New:h16.00
        "set guifontwide=YaHei\ Consolas\ Hybrid:h16.00
        "set guifont=Monaco:h16
        "set guifont=Droid\ Sans\ Mono:h14
        set guifontwide=YouYuan:h14
        if has("gui_macvim")
            "set transparency=4
            set lines=200 columns=142

            let s:lines=&lines
            let s:columns=&columns
            func! FullScreenEnter()
                set lines=999 columns=999
                set fu
            endf

            func! FullScreenLeave()
                let &lines=s:lines
                let &columns=s:columns
                set nofu
            endf

            func! FullScreenToggle()
                if &fullscreen
                    call FullScreenLeave()
                else
                    call FullScreenEnter()
                endif
            endf
        endif
    endif
endif

" Under the Mac(MacVim)
if has("gui_macvim")
    
    " Mac 下，按 \ff 切换全屏
    map <Leader><Leader>  :call FullScreenToggle()<cr>

    " Set input method off
    set imdisable

    " Set QuickTemplatePath
    let g:QuickTemplatePath = $HOME.'/.vim/templates/'

    lcd ~/Desktop/

    " 自动切换到文件当前目录
    set autochdir

    " Set QuickTemplatePath
    let g:QuickTemplatePath = $HOME.'/.vim/templates/'


endif

"设置VIM状态栏
set laststatus=2 "显示状态栏(默认值为1, 无法显示状态栏)
set statusline=  "[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set statusline+=%2*%-3.3n%0*\ " buffer number
set statusline+=%f\ " file name
set statusline+=%h%1*%m%r%w%0* " flag
set statusline+=[
if v:version >= 600
    set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
    set statusline+=%{&fileencoding}, " encoding
endif
set statusline+=%{&fileformat}] " file format
set statusline+=%= " right align
"set statusline+=%2*0x%-8B\ " current char
set statusline+=0x%-8B\ " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset
if filereadable(expand("~/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()} " vim buddy
endif

" =========
" 插件
" =========
filetype plugin indent on

"html自动输入匹配标签，输入>之后自动完成匹配标签
au FileType xhtml,xml so ~/.vim/plugin/html_autoclosetag.vim

"Auto completion using the TAB key " 自动补全括号，引号
"This function determines, wether we are on 
"the start of the line text(then tab indents) 
"or if we want to try auto completion 
function! InsertTabWrapper() 
     let col=col('.')-1 
     if !col || getline('.')[col-1] !~ '\k' 
         return "\<TAB>" 
     else 
         return "\<C-N>" 
     endif 
endfunction 
 
"Remap the tab key to select action with InsertTabWrapper 
inoremap <TAB> <C-R>=InsertTabWrapper()<CR>

:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap < <><ESC>i
:inoremap > <c-r>=ClosePair('>')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf
" =========
" AutoCmd
" =========
if has("autocmd")
    filetype plugin indent on

    " 括号自动补全
    func! AutoClose()
        :inoremap ( ()<ESC>i
        ":inoremap " ""<ESC>i
        ":inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END

    "auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,c,python,javascript exe AutoClose()

    " Auto Check Syntax
    au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)

    " JavaScript 语法高亮
    au FileType html,javascript let g:javascript_enable_domhtmlcss = 1

    " 给 Javascript 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
    else 
        au FileType javascript setlocal dict+=$VIM/vimfiles/dict/javascript.dict
    endif

    " 格式化 JavaScript 文件
    "au FileType javascript map <f12> :call g:Jsbeautify()<cr>
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS

    " 给 CSS 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType css setlocal dict+=~/.vim/dict/css.dict
    else
        au FileType css setlocal dict+=$VIM/vimfiles/dict/css.dict
    endif

    " 增加 ActionScript 语法支持
    au BufNewFile,BufRead *.as setf actionscript 

    " 自动最大化窗口
    if has('gui_running')
        if has("win32")
            au GUIEnter * simalt ~x
        "elseif has("unix")
            "au GUIEnter * winpos 0 0
            "set lines=999 columns=999
        endif
    endif
endif

let g:SuperTabDefaultCompletionType = '<c-x><c-u>'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabRetainCompletionType=2 
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'css' : '~/.vim/dist/css.dic',
    \ 'php' : '~/.vim/dict/php.dic',
    \ 'javascript' : '~/.vim/dict/javascript.dic',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }
let g:neocomplcache_snippets_dir="~/.vim/snippets"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_disable_auto_complete = 1
inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

""""""""""""""""""""""""""""""
" Tag list (ctags)
""""""""""""""""""""""""""""""
if has("win32")                "设定windows系统中ctags程序的位置
let Tlist_Ctags_Cmd = 'ctags'
elseif has("linux")              "设定linux系统中ctags程序的位置
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口 

" =========
" 快捷键
" =========
map cal :Calendar<cr>
map cse :ColorSchemeExplorer
"==== F3 NERDTree 切换 ====
let NERDTreeWinSize=22
"map ntree :NERDTree <cr>
"map nk :NERDTreeClose <cr>
"map <leader>n :NERDTreeToggle<cr>
map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC>:NERDTreeToggle<CR>
"==== F4 Tag list 切换 ====
map <silent> <F4> :TlistToggle<cr> 

" 标签相关的快捷键 Ctrl
map tn :tabnext<cr>
map tp :tabprevious<cr>
map tc :tabclose<cr>
map <C-t> :tabnew<cr>
map <C-p> :tabprevious<cr>
map <C-n> :tabnext<cr>
map <C-k> :tabclose<cr>
map <C-Tab> :tabnext<cr>

" 新建 XHTML 、PHP、Javascript 文件的快捷键
nmap <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
nmap <C-c><C-p> :NewQuickTemplateTab php<cr>
nmap <C-c><C-j> :NewQuickTemplateTab javascript<cr>
nmap <C-c><C-c> :NewQuickTemplateTab css<cr>

" 在文件名上按gf时，在新的tab中打开
map gf :tabnew <cfile><cr>


"jquery 配色
au BufRead,BufNewFile *.js set syntax=jquery

" jsLint for Vim
let g:jslint_highlight_color  = '#996600'
" 指定 jsLint 调用路径，通常不用更改
let g:jslint_command = $HOME . '\/.vim\/jsl\/jsl'
" 指定 jsLint 的启动参数，可以指定相应的配置文件
let g:jslint_command_options = '-nofilelisting -nocontext -nosummary -nologo -process'


" 返回当前时间
func! GetTimeInfo()
    "return strftime('%Y-%m-%d %A %H:%M:%S')
    return strftime('%Y-%m-%d %H:%M:%S')
endfunction

" 插入模式按 Ctrl + D(ate) 插入当前时间
imap <C-d> <C-r>=GetTimeInfo()<cr>

"缺省不产生备份文件
set nobackup
set nowritebackup

" autoload _vimrc
autocmd! bufwritepost _vimrc source %

" ==================
" plugin list
" ==================
"Color Scheme Explorer
"jsbeauty \ff
"NERDTree
"Calendar
"conquer_term
"nerd_commenter

"/*========================================*\
"               常用指令收集
"\*========================================*/
"   系统时间
"   :map <F7> a<C-R>=strftime("%c")<CR><esc>
"   :s/__date__/\=strftime("%c")/

"/*---------------------------------------*\
"               基础命令
"/*---------------------------------------*\
"   ctrl+q              可以联合复制，粘贴，替换用 行操作
"   ctrl+w+j ctrl+w+k (:bn :bp :bd)

"   '.                  它移动光标到上一次的修改行
"   `.                  它移动光标到上一次的修改点
"   .                   重复上次命令
"   <C-O> :             依次沿着你的跳转记录向回跳 (从最近的一次开始)
"   <C-I> :             依次沿着你的跳转记录向前跳
"   ju(mps) :           列出你跳转的足迹
"   :history :          列出历史命令记录
"   :his c :            命令行命令历史
"   :his s :            搜索命令历史
"   q/ :                搜索命令历史的窗口
"   q: :                命令行命令历史的窗口
"   g ctrl+g            计算文件字符
"   {,}                 前进至上一段落前进至后一段落
"   gg,G(2G)            文件首
"   gd dw gf ga(进制转化)
"   gg=G 全篇自动缩进 , =G 单行缩进

"* ci[ 删除一对 [] 中的所有字符并进入插入模式
"* ci( 删除一对 () 中的所有字符并进入插入模式
"* ci< 删除一对 <> 中的所有字符并进入插入模式
"* ci{ 删除一对 {} 中的所有字符并进入插入模式
"* cit 删除一对 HTML/XML 的标签内部的所有字符并进入插入模式
"* ci” ci’ ci` 删除一对引号字符 (” 或 ‘ 或 `) 中所有字符并进入插入模式
"
"* vi[ 选择一对 [] 中的所有字符
"* vi( 选择一对 () 中的所有字符
"* vi< 选择一对 <> 中的所有字符
"* vi{ 选择一对 {} 中的所有字符
"* vit 选择一对 HTML/XML 的标签内部的所有字符
"* vi” vi’ vi` 选择一对引号字符 (” 或 ‘ 或 `) 中所有字符

"   crl+] 函数原型处 crl+t 回 ( ctags )
"   ctl+p 自动补全( 编辑状态 )
"   :X 加密保存( 要输入密码 )
"   ? /         (N n)
"   f(F,t) 查找字符
"   w(e) 移动光标到下一个单词.
"   5fx 表示查找光标后第 5 个 x 字符.
"   5w(e) 移动光标到下五个单词.

"   b 移动光标到上一个单词.
"   0 移动光标到本行最开头.
"   ^ 移动光标到本行最开头的字符处.
"   $ 移动光标到本行结尾处.
"   H 移动光标到屏幕的首行.
"   M 移动光标到屏幕的中间一行.
"   L 移动光标到屏幕的尾行.

"   c-f (即 ctrl 键与 f 键一同按下)
"   c-b (即 ctrl 键与 b 键一同按下) 翻页
"   c-d (下半页) c-u(上半页) c-e (一行滚动)
"   zz 让光标所在的行居屏幕中央
"   zt 让光标所在的行居屏幕最上一行
"   zb 让光标所在的行居屏幕最下一行


"   在 vi 中 y 表示拷贝, d 表示删除, p 表示粘贴. 其中拷贝与删除是与光标移动命令
"   yw 表示拷贝从当前光标到光标所在单词结尾的内容.
"   dw 表示删除从当前光标到光标所在单词结尾的内容.
"   y0 表示拷贝从当前光标到光标所在行首的内容.
"   d0 表示删除从当前光标到光标所在行首的内容.
"   y$(Y) 表示拷贝从当前光标到光标所在行尾的内容.
"   d$(D) 表示删除从当前光标到光标所在行尾的内容.
"   yfa 表示拷贝从当前光标到光标后面的第一个a字符之间的内容.
"   dfa 表示删除从当前光标到光标后面的第一个a字符之间的内容.
"   s(S),a(A),x(X),D
"   yy 表示拷贝光标所在行.
"   dd 表示删除光标所在行.

"   5yy 表示拷贝光标以下 5 行.
"   5dd 表示删除光标以下 5 行.
"   y2fa 表示拷贝从当前光标到光标后面的第二个a字符之间的内容.
"   :12,24y 表示拷贝第12行到第24行之间的内容.
"   :12,y 表示拷贝第12行到光标所在行之间的内容.
"   :,24y 表示拷贝光标所在行到第24行之间的内容. 删除类似.
"   TAB 就是制表符, 单独拿出来做一节是因为这个东西确实很有用.
"   << 输入此命令则光标所在行向左移动一个 tab.
"   >> 输入此命令则光标所在行向右移动一个 tab.
"   5>> 输入此命令则光标后 5 行向右移动一个 tab.
"   :5>>(>>>) :>>(>>>)5
"   :12,24> 此命令将12行到14行的数据都向右移动一个 tab.
"   :12,24>> 此命令将12行到14行的数据都向右移动两个 tab.
"   :set shiftwidth=4 设置自动缩进 4 个空格, 当然要设自动缩进先.
"   :set sts=4 即设置 softtabstop 为 4. 输入 tab 后就跳了 4 格.
"   :set tabstop=4 实际的 tab 即为 4 个空格, 而不是缺省的 8 个.
"   :set expandtab 在输入 tab 后, vim 用恰当的空格来填充这个 tab.
"   :g/^/exec 's/^/'.strpart(line('.').' ', 0, 4) 在行首插入行号
"   set ai 设置自动缩进
"   5ia<esc> 重复插入5个a字符

"/*---------------------------------------*\
"               替换命令
"/*---------------------------------------*\
"   替换文字 2009-02-34 ----> 2009-02-34 00:00:00
"   :%s/\(\d\{4\}-\d\{2\}-\d\{2\}\)/\1 00:00:00/g

"   :s/aa/bb/g              将光标所在行出现的所有包含 aa 的字符串中的 aa 替换为 bb
"   :s/\/bb/g               将光标所在行出现的所有 aa 替换为 bb, 仅替换 aa 这个单词
"   :%s/aa/bb/g             将文档中出现的所有包含 aa 的字符串中的 aa 替换为 bb
"   :12,23s/aa/bb/g         将从12行到23行中出现的所有包含 aa 的字符串中的 aa 替换为 bb
"   :12,23s/^/#/            将从12行到23行的行首加入 # 字符
"   :%s/fred/joe/igc            一个常见的替换命令，修饰符igc和perl中一样意思
"   s/dick/joe/igc则        对于这些满足条件的行进行替换

"   :g/^\s*$/d              空行(空格也不包含)删除.
"   :%s/\r//g               删除DOS方式的回车^M
"   :%s/ *$//               删除行尾空白(%s/\s*$//g)
"   :g!/^dd/d               删除不含字符串'dd'开头的行
"   :v/^dd/d                同上,译释：v == g!，就是不匹配！
"   :v/./.,/./-1join        压缩空行(多行空行合并为一行)
"   :g/^$/,/./-j            压缩空行(多行空行合并为一行)
"   :g/^/pu _               把文中空行扩增一倍 (pu = put),原来两行间有一个空行，现在变成2个
"   :g/^/m0                 按行翻转文章 (m = move)
"   :g/fred/,/joe/d         not line based (very powerfull)
"   :g/<input\|<form/p      或者 要用\|
"   :g/fred/t$              拷贝行，从fred到文件末尾(EOF)

"   :%norm jdd              隔行删除,译释：%指明是对所有行进行操作,norm指出后面是normal模式的指令,j是下移一行，dd是删除行

"   :'a,'bg/fred/s/dick/joe/igc   ('a,'b指定一个范围：mark a ~ mark b)
"   g//用一个正则表达式指出了进行操作的行必须可以被fred匹配,g//是一个全局显示命令

"   /joe/e                  光标停留在匹配单词最后一个字母处
"   /joe/e+1                光标停留在匹配单词最后一个字母的下一个字母处
"   /joe/s                  光标停留在匹配单词第一个字母处
"   /^joe.*fred.*bill/      标准正则表达式
"   /^[A-J]\+/              找一个以A~J中一个字母重复两次或以上开头的行
"   /forum\(\_.\)*pent      多行匹配
"   /fred\_s*joe/i          中间可以有任何空白，包括换行符\n
"   /fred\|joe              匹配FRED或JOE
"   /\<fred\>/i             匹配fred,fred必须是一个独立的单词，而不是子串
"   /\<\d\d\d\d\>           匹配4个数字 \<\d\{4}\>

"   列，替换所有在第三列中的str1
"   :%s:\(\(\w\+\s\+\)\{2}\)str1:\1str2:
"   交换第一列和最后一列 (共4列)
"   :%s:\(\w\+\)\(.*\s\+\)\(\w\+\)$:\3\2\1:

"   全局(global)显示命令，就是用 :g＋正则表达式
"   译释： :g/{pattern}/{cmd} 就是全局找到匹配的,然后对这些行执行命令{cmd}
"   :g/\<fred\>/                                显示所有能够为单词fred所匹配的行
"   :g/<pattern>/z#.5                           显示内容，还有行号
"   :g/<pattern>/z#.5|echo '=========='         漂亮的显示

"/*---------------------------------------*\
"           多文档操作 (基础)
"/*---------------------------------------*\
"    用 :ls! 可以显示出当前所有的buffer
"   :bn                 跳转到下一个buffer
"   :bp                 跳转到上一个buffer
"   :wn                 存盘当前文件并跳转到下一个
"   :wp                 存盘当前文件并跳转到上一个
"   :bd                 把这个文件从buffer列表中做掉
"   :b 3                跳到第3个buffer
"   :b main             跳到一个名字中包含main的buffer

"/*---------------------------------------*\
"           列复制
"/*---------------------------------------*\
"   译注：@#%&^#*^%#$!
"   :%s= [^ ]\+$=&&= : 复制最后一列
"   :%s= \f\+$=&&= : 一样的功能
"   :%s= \S\+$=&& : ft,还是一样
"   反向引用，或称记忆
"   :s/\(.*\):\(.*\)/\2 : \1/ : 颠倒用:分割的两个字段
"   :%s/^\(.*\)\n\1/\1$/ : 删除重复行
"   非贪婪匹配，\{-}
"   :%s/^.\{-}pdf/new.pdf/ : 只是删除第一个pdf
"   跨越可能的多行
"   :%s/<!--\_.\{-}-->// : 又是删除多行注释（咦？为什么要说「又」呢？）
"   :help /\{-} : 看看关于 非贪婪数量符 的帮助
"   :s/fred/<c-r>a/g : 替换fred成register a中的内容，呵呵
"   写在一行里的复杂命令
"   :%s/\f\+\.gif\>/\r&\r/g | v/\.gif$/d | %s/gif/jpg/
"   译注：就是用 | 管道啦

"/*---------------------------------------*\
"           大小写转换
"/*---------------------------------------*\
"   g~~ : 行翻转
"   vEU : 字大写(广义字)
"   vE~ : 字翻转(广义字)
"   ~   将光标下的字母改变大小写
"   3~  将下3个字母改变其大小写
"   g~w 字翻转
"   U   将可视模式下的字母全改成大写字母
"   gUU 将当前行的字母改成大写
"   u   将可视模式下的字母全改成小写
"   guu 将当前行的字母全改成小写
"   gUw 将光标下的单词改成大写。
"   guw 将光标下的单词改成小写。


"   文件浏览
"   :Ex : 开启目录浏览器，注意首字母E是大写的
"   :Sex : 在一个分割的窗口中开启目录浏览器
"   :ls : 显示当前buffer的情况
"   :cd .. : 进入父目录
"   :pwd
"   :args : 显示目前打开的文件
"   :lcd %:p:h : 更改到当前文件所在的目录
"    译释：lcd是紧紧改变当前窗口的工作路径，% 是代表当前文件的文件名,
"    加上 :p扩展成全名（就是带了路径），加上 :h析取出路径

"/*========================================*\
"                   END
"\*========================================*/
```

## vim大牛配置1

来自github： https://github.com/humiaozuzu/dot-vimrc

```
Skip to content
This repository
Search
Pull requests
Issues
Gist
 @shuter
 Watch 154
  Star 1,351
  Fork 520 humiaozuzu/dot-vimrc
 Code  Issues 5  Pull requests 1  Wiki  Pulse  Graphs
Branch: master Find file Copy pathdot-vimrc/vimrc
9f843b9  on 9 Sep 2013
@humiaozuzu humiaozuzu Fix snipmate error
2 contributors @humiaozuzu @gracece
RawBlameHistory     269 lines (235 sloc)  8.19 KB
source ~/.vim/bundles.vim

" encoding dectection
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

" enable filetype dectection and ft specific plugin/indent
filetype plugin indent on

" enable syntax hightlight and completion
syntax on

"--------
" Vim UI
"--------
" color scheme
set background=dark
color solarized

" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" search
set incsearch
"set highlight  " conflict with highlight current line
set ignorecase
set smartcase

" editor settings
set history=1000
set nocompatible
set nofoldenable                                                  " disable folding"
set confirm                                                       " prompt when existing from an unsaved file
set backspace=indent,eol,start                                    " More powerful backspacing
set t_Co=256                                                      " Explicitly tell vim that the terminal has 256 colors "
set mouse=a                                                       " use mouse in all modes
set report=0                                                      " always report number of lines changed                "
set nowrap                                                        " dont wrap lines
set scrolloff=5                                                   " 5 lines above/below cursor when scrolling
set number                                                        " show line numbers
set showmatch                                                     " show matching bracket (briefly jump)
set showcmd                                                       " show typed command in status bar
set title                                                         " show file in titlebar
set laststatus=2                                                  " use 2 lines for the status bar
set matchtime=2                                                   " show matching bracket for 0.2 seconds
set matchpairs+=<:>                                               " specially for html
" set relativenumber

" Default Indentation
set autoindent
set smartindent     " indent when
set tabstop=4       " tab width
set softtabstop=4   " backspace
set shiftwidth=4    " indent width
" set textwidth=79
" set smarttab
set expandtab       " expand tab to space

autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120

" syntax support
autocmd Syntax javascript set syntax=jquery   " JQuery syntax support
" js
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"-----------------
" Plugin settings
"-----------------
" Rainbow parentheses for Lisp and variants
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
autocmd Syntax lisp,scheme,clojure,racket RainbowParenthesesToggle

" tabbar
let g:Tb_MaxSize = 2
let g:Tb_TabWrap = 1

hi Tb_Normal guifg=white ctermfg=white
hi Tb_Changed guifg=green ctermfg=green
hi Tb_VisibleNormal ctermbg=252 ctermfg=235
hi Tb_VisibleChanged guifg=green ctermbg=252 ctermfg=white

" easy-motion
let g:EasyMotion_leader_key = '<Leader>'

" Tagbar
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
" tag for coffee
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }

  let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'sort' : 0,
    \ 'kinds' : [
        \ 'h:sections'
    \ ]
    \ }
endif

" Nerd Tree
let NERDChristmasTree=0
let NERDTreeWinSize=30
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
" let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos = "right"

" nerdcommenter
let NERDSpaceDelims=1
" nmap <D-/> :NERDComToggleComment<cr>
let NERDCompactSexyComs=1

" ZenCoding
let g:user_emmet_expandabbr_key='<C-j>'

" powerline
"let g:Powerline_symbols = 'fancy'

" NeoComplCache
let g:neocomplcache_enable_at_startup=1
let g:neoComplcache_disableautocomplete=1
"let g:neocomplcache_enable_underbar_completion = 1
"let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case=1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
set completeopt-=preview

imap <C-k> <Plug>(neocomplcache_snippets_force_expand)
smap <C-k> <Plug>(neocomplcache_snippets_force_expand)
imap <C-l> <Plug>(neocomplcache_snippets_force_jump)
smap <C-l> <Plug>(neocomplcache_snippets_force_jump)

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType c setlocal omnifunc=ccomplete#Complete
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.erlang = '[a-zA-Z]\|:'

" SuperTab
" let g:SuperTabDefultCompletionType='context'
let g:SuperTabDefaultCompletionType = '<C-X><C-U>'
let g:SuperTabRetainCompletionType=2

" ctrlp
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" Keybindings for plugin toggle
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
nmap <F5> :TagbarToggle<cr>
nmap <F6> :NERDTreeToggle<cr>
nmap <F3> :GundoToggle<cr>
nmap <F4> :IndentGuidesToggle<cr>
nmap  <D-/> :
nnoremap <leader>a :Ack
nnoremap <leader>v V`]

"------------------
" Useful Functions
"------------------
" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
      \ if ! exists("g:leave_my_cursor_position_alone") |
      \     if line("'\"") > 0 && line ("'\"") <= line("$") |
      \         exe "normal g'\"" |
      \     endif |
      \ endif

" w!! to sudo & write a file
cmap w!! %!sudo tee >/dev/null %

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" sublime key bindings
nmap <D-]> >>
nmap <D-[> <<
vmap <D-[> <gv
vmap <D-]> >gv

" eggcache vim
nnoremap ; :
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa

" for macvim
if has("gui_running")
    set go=aAce  " remove toolbar
    "set transparency=30
    set guifont=Monaco:h13
    set showtabline=2
    set columns=140
    set lines=40
    noremap <D-M-Left> :tabprevious<cr>
    noremap <D-M-Right> :tabnext<cr>
    map <D-1> 1gt
    map <D-2> 2gt
    map <D-3> 3gt
    map <D-4> 4gt
    map <D-5> 5gt
    map <D-6> 6gt
    map <D-7> 7gt
    map <D-8> 8gt
    map <D-9> 9gt
    map <D-0> :tablast<CR>
endif
```

> ```bash
> set showmode
> ```

在底部显示，当前处于命令模式还是插入模式。

# vim配置.vimrc方案2

```
" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"                    __ _ _____              _
"         ___ _ __  / _/ |___ /      __   __(_)_ __ ___
"        / __| '_ \| |_| | |_ \ _____\ \ / /| | '_ ` _ \
"        \__ \ |_) |  _| |___) |_____|\ V / | | | | | | |
"        |___/ .__/|_| |_|____/        \_/  |_|_| |_| |_|
"            |_|
"
"   This is the personal .vimrc file of Steve Francia.
"   While much of it is beneficial for general use, I would
"   recommend picking out the parts you want and understand.
"
"   You can find me at http://spf13.com
"
"   Copyright 2014 Steve Francia
"
"   Licensed under the Apache License, Version 2.0 (the "License");
"   you may not use this file except in compliance with the License.
"   You may obtain a copy of the License at
"
"       http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"   See the License for the specific language governing permissions and
"   limitations under the License.
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
    
    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {

    set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {

    if !exists('g:override_spf13_bundles') && filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        color solarized             " Load a colorscheme
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:spf13_leader='\'
    if !exists('g:spf13_leader')
        let mapleader = ','
    else
        let mapleader=g:spf13_leader
    endif
    if !exists('g:spf13_localleader')
        let maplocalleader = '_'
    else
        let maplocalleader=g:spf13_localleader
    endif

    " The default mappings for editing and applying the spf13 configuration
    " are <leader>ev and <leader>sv respectively. Change them to your preference
    " by adding the following to your .vimrc.before.local file:
    "   let g:spf13_edit_config_mapping='<leader>ec'
    "   let g:spf13_apply_config_mapping='<leader>sc'
    if !exists('g:spf13_edit_config_mapping')
        let s:spf13_edit_config_mapping = '<leader>ev'
    else
        let s:spf13_edit_config_mapping = g:spf13_edit_config_mapping
    endif
    if !exists('g:spf13_apply_config_mapping')
        let s:spf13_apply_config_mapping = '<leader>sv'
    else
        let s:spf13_apply_config_mapping = g:spf13_apply_config_mapping
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_easyWindows = 1
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_wrapRelMotion = 1
    if !exists('g:spf13_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:spf13_clear_search_highlight = 1
    if exists('g:spf13_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Plugins {

    " GoLang {
        if count(g:spf13_bundle_groups, 'go')
            let g:go_highlight_functions = 1
            let g:go_highlight_methods = 1
            let g:go_highlight_structs = 1
            let g:go_highlight_operators = 1
            let g:go_highlight_build_constraints = 1
            let g:go_fmt_command = "goimports"
            let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
            let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
            au FileType go nmap <Leader>s <Plug>(go-implements)
            au FileType go nmap <Leader>i <Plug>(go-info)
            au FileType go nmap <Leader>e <Plug>(go-rename)
            au FileType go nmap <leader>r <Plug>(go-run)
            au FileType go nmap <leader>b <Plug>(go-build)
            au FileType go nmap <leader>t <Plug>(go-test)
            au FileType go nmap <Leader>gd <Plug>(go-doc)
            au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
            au FileType go nmap <leader>co <Plug>(go-coverage)
        endif
        " }


    " TextObj Sentence {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

    " TextObj Quote {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_quote
                autocmd!
                autocmd FileType markdown call textobj#quote#init()
                autocmd FileType textile call textobj#quote#init()
                autocmd FileType text call textobj#quote#init({'educate': 0})
            augroup END
        endif
    " }

    " PIV {
        if isdirectory(expand("~/.vim/bundle/PIV"))
            let g:DisableAutoPHPFolding = 0
            let g:PIVAutoClose = 0
        endif
    " }

    " Misc {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif
    " }

    " OmniComplete {
        " To disable omni complete, add the following to your .vimrc.before.local file:
        "   let g:spf13_no_omni_complete = 1
        if !exists('g:spf13_no_omni_complete')
            if has("autocmd") && exists("+omnifunc")
                autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
            endif

            hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
            hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
            hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

            " Some convenient mappings
            "inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
            if exists('g:spf13_map_cr_omni_complete')
                inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
            endif
            inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
            inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
            inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
            inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
            set completeopt=menu,preview,longest
        endif
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }

    " Tabularize {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " PyMode {
        " Disable if python support not present
        if !has('python') && !has('python3')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/bundle/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " TagBar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

    " YouCompleteMe {
        if count(g:spf13_bundle_groups, 'youcompleteme')
            let g:acp_enableAtStartup = 0

            " enable completion from tags
            let g:ycm_collect_identifiers_from_tags_files = 1

            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Haskell post write lint and check with ghcmod
            " $ `cabal install ghcmod` if missing and ensure
            " ~/.cabal/bin is in your $PATH.
            if !executable("ghcmod")
                autocmd BufWritePost *.hs GhcModCheckAndLintAsync
            endif

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " neocomplete {
        if count(g:spf13_bundle_groups, 'neocomplete')
            let g:acp_enableAtStartup = 0
            let g:neocomplete#enable_at_startup = 1
            let g:neocomplete#enable_smart_case = 1
            let g:neocomplete#enable_auto_delimiter = 1
            let g:neocomplete#max_list = 15
            let g:neocomplete#force_overwrite_completefunc = 1


            " Define dictionary.
            let g:neocomplete#sources#dictionary#dictionaries = {
                        \ 'default' : '',
                        \ 'vimshell' : $HOME.'/.vimshell_hist',
                        \ 'scheme' : $HOME.'/.gosh_completions'
                        \ }

            " Define keyword.
            if !exists('g:neocomplete#keyword_patterns')
                let g:neocomplete#keyword_patterns = {}
            endif
            let g:neocomplete#keyword_patterns['default'] = '\h\w*'

            " Plugin key-mappings {
                " These two lines conflict with the default digraph mapping of <C-K>
                if !exists('g:spf13_no_neosnippet_expand')
                    imap <C-k> <Plug>(neosnippet_expand_or_jump)
                    smap <C-k> <Plug>(neosnippet_expand_or_jump)
                endif
                if exists('g:spf13_noninvasive_completion')
                    inoremap <CR> <CR>
                    " <ESC> takes you out of insert mode
                    inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
                    " <CR> accepts first, then sends the <CR>
                    inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
                    " <Down> and <Up> cycle like <Tab> and <S-Tab>
                    inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
                    inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
                    " Jump up and down the list
                    inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
                    inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
                else
                    " <C-k> Complete Snippet
                    " <C-k> Jump to next snippet point
                    imap <silent><expr><C-k> neosnippet#expandable() ?
                                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
                    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

                    inoremap <expr><C-g> neocomplete#undo_completion()
                    inoremap <expr><C-l> neocomplete#complete_common_string()
                    "inoremap <expr><CR> neocomplete#complete_common_string()

                    " <CR>: close popup
                    " <s-CR>: close popup and save indent.
                    inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

                    function! CleverCr()
                        if pumvisible()
                            if neosnippet#expandable()
                                let exp = "\<Plug>(neosnippet_expand)"
                                return exp . neocomplete#smart_close_popup()
                            else
                                return neocomplete#smart_close_popup()
                            endif
                        else
                            return "\<CR>"
                        endif
                    endfunction

                    " <CR> close popup and save indent or expand snippet
                    imap <expr> <CR> CleverCr()
                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
                    inoremap <expr><C-y> neocomplete#smart_close_popup()
                endif
                " <TAB>: completion.
                inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

                " Courtesy of Matteo Cavalleri

                function! CleverTab()
                    if pumvisible()
                        return "\<C-n>"
                    endif
                    let substr = strpart(getline('.'), 0, col('.') - 1)
                    let substr = matchstr(substr, '[^ \t]*$')
                    if strlen(substr) == 0
                        " nothing to match on empty string
                        return "\<Tab>"
                    else
                        " existing text matching
                        if neosnippet#expandable_or_jumpable()
                            return "\<Plug>(neosnippet_expand_or_jump)"
                        else
                            return neocomplete#start_manual_complete()
                        endif
                    endif
                endfunction

                imap <expr> <Tab> CleverTab()
            " }

            " Enable heavy omni completion.
            if !exists('g:neocomplete#sources#omni#input_patterns')
                let g:neocomplete#sources#omni#input_patterns = {}
            endif
            let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
            let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " }
    " neocomplcache {
        elseif count(g:spf13_bundle_groups, 'neocomplcache')
            let g:acp_enableAtStartup = 0
            let g:neocomplcache_enable_at_startup = 1
            let g:neocomplcache_enable_camel_case_completion = 1
            let g:neocomplcache_enable_smart_case = 1
            let g:neocomplcache_enable_underbar_completion = 1
            let g:neocomplcache_enable_auto_delimiter = 1
            let g:neocomplcache_max_list = 15
            let g:neocomplcache_force_overwrite_completefunc = 1

            " Define dictionary.
            let g:neocomplcache_dictionary_filetype_lists = {
                        \ 'default' : '',
                        \ 'vimshell' : $HOME.'/.vimshell_hist',
                        \ 'scheme' : $HOME.'/.gosh_completions'
                        \ }

            " Define keyword.
            if !exists('g:neocomplcache_keyword_patterns')
                let g:neocomplcache_keyword_patterns = {}
            endif
            let g:neocomplcache_keyword_patterns._ = '\h\w*'

            " Plugin key-mappings {
                " These two lines conflict with the default digraph mapping of <C-K>
                imap <C-k> <Plug>(neosnippet_expand_or_jump)
                smap <C-k> <Plug>(neosnippet_expand_or_jump)
                if exists('g:spf13_noninvasive_completion')
                    inoremap <CR> <CR>
                    " <ESC> takes you out of insert mode
                    inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
                    " <CR> accepts first, then sends the <CR>
                    inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
                    " <Down> and <Up> cycle like <Tab> and <S-Tab>
                    inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
                    inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
                    " Jump up and down the list
                    inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
                    inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
                else
                    imap <silent><expr><C-k> neosnippet#expandable() ?
                                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
                    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

                    inoremap <expr><C-g> neocomplcache#undo_completion()
                    inoremap <expr><C-l> neocomplcache#complete_common_string()
                    "inoremap <expr><CR> neocomplcache#complete_common_string()

                    function! CleverCr()
                        if pumvisible()
                            if neosnippet#expandable()
                                let exp = "\<Plug>(neosnippet_expand)"
                                return exp . neocomplcache#close_popup()
                            else
                                return neocomplcache#close_popup()
                            endif
                        else
                            return "\<CR>"
                        endif
                    endfunction

                    " <CR> close popup and save indent or expand snippet
                    imap <expr> <CR> CleverCr()

                    " <CR>: close popup
                    " <s-CR>: close popup and save indent.
                    inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()."\<CR>" : "\<CR>"
                    "inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
                    inoremap <expr><C-y> neocomplcache#close_popup()
                endif
                " <TAB>: completion.
                inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
            " }

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Enable heavy omni completion.
            if !exists('g:neocomplcache_omni_patterns')
                let g:neocomplcache_omni_patterns = {}
            endif
            let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
            let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
            let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.go = '\h\w*\.\?'
    " }
    " Normal Vim omni-completion {
    " To disable omni complete, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_omni_complete = 1
        elseif !exists('g:spf13_no_omni_complete')
            " Enable omni-completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        endif
    " }

    " Snippets {
        if count(g:spf13_bundle_groups, 'neocomplcache') ||
                    \ count(g:spf13_bundle_groups, 'neocomplete')

            " Use honza's snippets.
            let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

            " Enable neosnippet snipmate compatibility mode
            let g:neosnippet#enable_snipmate_compatibility = 1

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Enable neosnippets when using go
            let g:go_snippet_engine = "neosnippet"

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " FIXME: Isn't this for Syntastic to handle?
    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " Wildfire {
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
            if !exists('g:airline_theme')
                let g:airline_theme = 'solarized'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }



" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

    function! s:IsSpf13Fork()
        let s:is_fork = 0
        let s:fork_files = ["~/.vimrc.fork", "~/.vimrc.before.fork", "~/.vimrc.bundles.fork"]
        for fork_file in s:fork_files
            if filereadable(expand(fork_file, ":p"))
                let s:is_fork = 1
                break
            endif
        endfor
        return s:is_fork
    endfunction
     
    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction
     
    function! s:EditSpf13Config()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.before")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.bundles")
     
        execute bufwinnr(".vimrc") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.local")
     
        if <SID>IsSpf13Fork()
            execute bufwinnr(".vimrc") . "wincmd w"
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.fork")
        endif
     
        execute bufwinnr(".vimrc.local") . "wincmd w"
    endfunction
     
    execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
    execute "noremap " . s:spf13_apply_config_mapping . " :source ~/.vimrc<CR>"
" }

" Use fork vimrc if available {
    if filereadable(expand("~/.vimrc.fork"))
        source ~/.vimrc.fork
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }
```

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

   

可以用现成的吖，https://github.com/amix/vimrc

​                   2018年9月16日 11:23 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393190) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         必填  说：                

习惯用vim的人一定不要错过chrome插件vimium：https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en

有了这个神器，我浏览网页都不大需要用鼠标了。

​                                                                    

​                                                         flw  说：                

阮老师， `==` 可不是「取消全部缩进」的意思，而是「自动缩进」的意思。

​                               

 vimer 分为3级
 1级 不用鼠标掌握基本操作
 2级 自定义默认配置和快捷键
 3级 摆弄各种插件

​                        

set softtabstop=2
 set tabstop=2 
 这两个有什么区别?

​                   2018年9月19日 21:29 | [#](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-393258) | [引用](https://www.ruanyifeng.com/blog/2018/09/vimrc.html#comment-text)

​                                                         [ahuigo](https://ahuigo.github.io)  说：                

iterm2 默认的 Profile - Terminal: Report Terminal Type = xterm , 导致nvim 乱码`:5:130m`. 

可将 Report Terminal Type 改成 `xterm-256color` 或则 vim `:let &t_Co=8`

​     

​                                                 

> 可以用现成的吖，https://github.com/amix/vimrc

貌似这个配置不能用了！

​               

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

## 文件合并

Vim自带了一个文件差异编辑器（一个用来显示多个文件之间的差异还可以方便的将其合并的程序）。用_vimdiff_来启动它——指定几对文件即可：`vimdiff _file1_ _file2_`。以下是*vimdiff*-specific命令的清单。

| 行为         | 快捷键        |
| ------------ | ------------- |
| 下一差异     | `]c`          |
| 上一差异     | [`c`          |
| 差异导入     | `do`          |
| 差异导出     | `dp`          |
| 打开折叠     | `zo`          |
| 关闭折叠     | `zc`          |
| 重新扫描文件 | `:diffupdate` |
| 窗口切换     | `Ctrl+w+w`    |

## 技巧和建议

### 显示行号

使用`:set number`来显示行号。默认显示绝对行号，可用`:set relativenumber`开启相对行号。

使用`:_行号_` or `_行号_gg`跳转到指定行号。跳转都记录在一个跳转列表中,更多细节参考`:h jump-motions`。

### 拼写检查

Vim有拼写检查的功能，用下面的命令开启：

```
set spell
```

Vim默认只安装了英语字典。其他的字典可在[官方软件仓库][17]通过搜索`vim-spell`而寻得。检查可用语言包：

```
# pacman -Ss vim-spell
```

额外的字典可以从[Vim's FTP archive][18]获取。把下载的字典文件存入`~/.vim/spell/`，并用 `:setlocal spell spelllang=_en_us_` (将`_en_us_` 换成所需的字典的名称)开启。

| 行为                     | 快捷键    |
| ------------------------ | --------- |
| 下一个拼写错误           | `]s`      |
| 上一个拼写错误           | [`s`      |
| 拼写纠正建议             | `z=`      |
| 将单词添加到用户正确字典 | `zg`      |
| 将单词添加到内部正确字典 | `zG`      |
| 将单词添加到用户错误字典 | `zw`      |
| 将单词添加到内部正确字典 | `zW`      |
| 重新进行拼写检查         | `:spellr` |

> **小贴士:**
>
> - 如果需要针对两种语言进行拼写检察（例如英语与德语），在`~/.vimrc`或`/etc/vimrc`中添加`set spelllang=_en,de_`并重启Vim即可。
> - 使用用于进行文件类型检测的FileType插件和自建规则，可以对任意文件类型开启拼写检查。例如，要开启对扩展名为`.txt`的文件的拼写检查，创建文件`/usr/share/vim/vimfiles/ftdetect/plaintext.vim`，添加内容`autocmd BufRead,BufNewFile *.txt setfiletype plaintext`，然后在`~/.vimrc`或`/etc/vimrc`添加`autocmd FileType plaintext setlocal spell spelllang=en_us`，重启vim即可。
> - 如果想只对LaTeX（或TeX）文档起用拼写检查，在`~/.vimrc`或`/etc/vimrc`添加`autocmd FileType **tex** setlocal spell spelllang=_en_us_`，重启Vim即可。至于非英语语言，替换上述语句中的`en_us`为相应语言代码即可。

### 记录光标位置

Vim可以记录上次打开某一文件时的光标位置，并在下次打开同一文件时将光标移动到该位置。要开启该功能，在配置文件`~/.vimrc`中加入以下内容：

```
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END
```

另见：[Vim Wiki上的相关内容][19]。

### 用 vim 替代 vi

创建一个[alias](http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session)，如下：

```
alias vi=vim
```

或者,如果你想输入`sudo vi`并得到`vim`, 安装[vi-vim-symlink](https://aur.archlinux.org/packages/vi-vim-symlink/)AUR，它将移除`vi`并用一个符号链接`vim`代替。

### DOS/Windows回车问题

打开MS-DOS或Windows下创建的文本文件时，经常会在每行行末出现一个`^M`。这是因为Linux使用Unix风格的换行，用一个换行符（LF）来表示一行的结束，但在Windows、MS-DOS中使用一个回车符（CR）接一个换行符（LF）来表示，因而回车符就显示为`^M`。

可使用下面的命令删除文件中的回车符：

```
:%s/^M//g
```

注意，`^`代表控制字符。输入`^M`的方法是按下`Ctrl+v,Ctrl+m`。

另一个解决方法是，安装 [dos2unix](https://www.archlinux.org/packages/?name=dos2unix)，然后执行 `dos2unix <文件名>`。

### gVim窗口底部的空格

如果[窗口管理器](https://wiki.archlinux.org/index.php/Window_manager_(简体中文))设置为忽略窗口大小渲染窗口，gVim会将空白区域填充为GTK主题背景色，看起来会比较难看。

解决方案是调整gVim在窗口底部保留的空间大小。将下面的代码加入 `~/.vimrc`中：

```
set guiheadroom=0
```

> **注意:**如果将其设为0，将无法看到底部的水平滚动条。

## 插件

使用插件来提高效率，它能改变Vim的界面，添加新命令，代码自动补全，整合其他程序和工具，添加其他编程语言等功能。

> 小贴士: 参阅[Vim Awesome](http://vimawesome.com/)获取一些热门插件

### 安装

#### 使用插件管理器

插件管理器使安装和管理插件有相似的方法，而与在何种平台上运行Vim无关。它是一个像包管理器一样的用来管理其它Vim插件的插件。

- [Vundle](https://github.com/gmarik/Vundle.vim)是现在最流行的Vim插件管理器。
- [Vim-plug](https://github.com/junegunn/vim-plug)是一个极简的Vim插件管理器，有许多的特性，比如按需插件加载和并行升级。
- [pathogen.vim](https://github.com/tpope/vim-pathogen)是一个简单的用于管理Vim的运行时路径的插件。

#### 从Arch软件库下载

[vim-plugins](https://www.archlinux.org/groups/x86_64/vim-plugins/)分类下有许多插件。 使用`pacman -Sg vim-plugins`来列出可用的插件，然后你可用pacman[安装](https://wiki.archlinux.org/index.php/安装)。

```
pacman -Ss vim-plugins
```

### cscope

[Cscope](http://cscope.sourceforge.net/)是一个工程浏览工具。通过导航到一个词/符号/函数并通过快捷键调用cscope，能快速找到：函数调用及函数定义等。

[安装](https://wiki.archlinux.org/index.php/安装) [cscope](https://www.archlinux.org/packages/?name=cscope)包。

拷贝cscope预设文件，该文件会被Vim自动读为:

```
mkdir -p ~/.vim/plugin
wget -P ~/.vim/plugin http://cscope.sourceforge.net/cscope_maps.vim
```

> **注意:**在Vim的7.x版本中，你可能需要在`~/.vim/plugin/cscope_maps.vim`中取消下列行的注释来启用cscope快捷键：

```
set timeoutlen=4000
set ttimeout
```

创建一个文件，该文件包含了你希望cscope索引的文件的清单（cscope可以操作很多语言，下面的例子用于寻找C++中的*.c*、_.cpp*和*.h_文件）：

```
cd /path/to/projectfolder/
find . -type f -print | grep -E '\.(c(pp)?|h)$' > cscope.files
```

创建cscope将读取的数据文件：

```
cscope -bq
```

> **注意:**必须从当前路径浏览工程文件，也可以设置`$CSCOPE_DB`变量指向`cscope.out`文件，并导出。

默认快捷键：

```
 Ctrl-\ and
      c: Find functions calling this function
      d: Find functions called by this function
      e: Find this egrep pattern
      f: Find this file
      g: Find this definition
      i: Find files #including this file
      s: Find this C symbol
      t: Find assignments to
```

可随意改变这些快捷键。

#### Taglist

[Taglist](http://vim-taglist.sourceforge.net/)提供源码文件的结构概览，使你能更高效的浏览不同语言的源文件。

[安装](https://wiki.archlinux.org/index.php/安装) [vim-taglist](https://www.archlinux.org/packages/?name=vim-taglist)包。

将下列设置添入文件`~/.vimrc`:

```
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-l> :TlistToggle<CR>
```

## 参阅

### 官方资源

- [Vim主页](http://www.vim.org/)
- [Vim文档](http://vimdoc.sourceforge.net/)
- [Vim Wiki](http://vim.wikia.com/)
- [Vim脚本](http://www.vim.org/scripts/)

### 教程

- [中文版《A Byte of Vim》](http://www.swaroopch.com/notes/Vim_zh-cn)
- [vi教程和参考指南](http://usalug.org/vi.html)
- [vim Tutorial and Primer](http://www.danielmiessler.com/study/vim/)
- [vi Tutorial and Reference Guide](http://usalug.org/vi.html)
- [Graphical vi-Vim Cheat Sheet and Tutorial](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)
- [Vim Introduction and Tutorial](http://blog.interlinked.org/tutorials/vim_tutorial.html)
- [Open Vim](http://www.openvim.com/) - Vim教学工具集合
- [Learn Vim Progressively](http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
- [Learning Vim in 2014](http://benmccormick.org/learning-vim-in-2014/)
- [Seven habits of effective text editing](http://www.moolenaar.net/habits.html)
- [Basic Vim Tips](http://bencrowder.net/files/vim-fu/)
- [HOWTO Vim](http://www.gentoo-wiki.info/HOWTO_VIM)

#### 视频

- [Vimcasts - ogg格式的视频教程。](http://vimcasts.org/)
- [Vim Tutorial Videos - 从入门到精通，各种视频教程](http://derekwyatt.org/vim/tutorials/)

#### 游戏

- [Vim Adventures](http://vim-adventures.com/)
- [VimGolf](http://vimgolf.com/)

### 配置范例

- [nion's](http://nion.modprobe.de/setup/vimrc)
- [A detailed configuration from Amir Salihefendic](http://amix.dk/vim/vimrc.html)
- [Bart Trojanowski](http://www.jukie.net/~bart/conf/vimrc)
- [Steve Francia's Vim Distribution](https://github.com/spf13/spf13-vim)
- [W4RH4WK's Vim configuration](https://github.com/W4RH4WK/dotVim)
- [Fast vimrc/colorscheme from askapache](http://www.askapache.com/linux/fast-vimrc.html)
- [Basic .vimrc](https://gist.github.com/anonymous/c966c0757f62b451bffa)
- [Usevim](http://www.usevim.com/)

#### 颜色方案

- [Vivify](http://bytefluent.com/vivify/)
- [Vim colorscheme customization](https://linuxtidbits.wordpress.com/2014/10/14/vim-customize-installed-colorschemes/)

## 其他

要学习一些基本的Vim使用操作，可以运行**vimtutor**（控制台版本）或**gvimtutor**（图形界面版本）阅读Vim教程。

Vim包含了一个广泛的帮助系统，可以用`:h _subject_`命令来访问。_subject_主题可以是命令，配置选项，热键绑定，插件等。使用`:h`命令（不带任何*subject*）来获取帮助系统的相关信息以及在不同的主题之间切换。