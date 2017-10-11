# Linux 中的命令行别名

alias 工具可以创建或者重定义别名定义，或者把现有别名定义输出到标准输出。别名定义提供了输入一个命令时应该被替换的字符串值。一个别名定义会影响当前 shell 的执行环境以及当前 shell 的所有子 shell 的执行环境。按照 IEEE Std 1003.1-2001 规定，别名定义不应该影响当前 shell 的父进程以及任何 shell 调用的程序环境。

尽管当前我们在 shell 中用于定义别名的技术（通过使用 alias 命令）实现了效果，别名只存在于当前终端会话。很有可能你会希望你定义的别名能保存下来，使得此后你可以在任何新启动的命令行窗口/标签页中使用它们。

为此，你需要在 ~/.bash_aliases 文件中定义你的别名，你的 ~/.bashrc 文件默认会加载该文件（如果你使用更早版本的 Ubuntu，我没有验证过是否有效）。

下面是我的 .bashrc 文件中关于 .bash_aliases 文件的部分：

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.
    if [ -f ~/.bash_aliases ]; then
          . ~/.bash_aliases
    fi

一旦你把别名定义添加到你的 .bash_aliases 文件，该别名在任何新终端中都可用。但是，在任何其它你定义别名时已经启动的终端中，你还不能使用它们 - 解决办法是在这些终端中重新加载 .bashrc。下面就是你需要执行的具体命令：

    source ~/.bashrc

如果你觉得这要做的也太多了（是的，我期待你有更懒惰的办法），那么这里有一个快捷方式来做到这一切：

    "alias [the-alias]" >> ~/.bash_aliases && source ~/.bash_aliases

毫无疑问，你需要用实际的命令替换 [the-alias]。例如：

    "alias bk5='cd ../../../../..'" >> ~/.bash_aliases && source ~/.bash_aliases

接下来，假设你已经创建了一些别名，并时不时使用它们有一段时间了。突然有一天，你发现它们其中的一个并不像期望的那样。因此你觉得需要查看被赋予该别名的真正命令。你会怎么做呢？

当然，你可以打开你的 .bash_aliases 文件在那里看看，但这种方式可能有点费时，尤其是当文件中包括很多别名的时候。因此，如果你正在查找一种更简单的方式，这就有一个：你需要做的只是运行 alias 命令并把别名名称作为参数。

这里有个例子：

    $ alias bk6
    alias bk6='cd ../../../../../..'

你可以看到，上面提到的命令显示了被赋值给别名 bk6 的实际命令。这里还有另一种办法：使用 type 命令。下面是一个例子：

    $ type bk6
    bk6 is aliased to `cd ../../../../../..'

type 命令产生了一个易于人类理解的输出。

另一个值得分享的是你可以将别名用于常见的输入错误。例如：

    alias mroe='more'
