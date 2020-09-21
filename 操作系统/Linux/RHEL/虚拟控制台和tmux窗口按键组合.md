# 虚拟控制台和tmux窗口按键组合

| 按键顺序        | 内容                                                         |
| --------------- | ------------------------------------------------------------ |
| Ctrl + Alt + F1 | 访问 tmux 终端多路复用器                                     |
| Ctrl + b 1      | 在 tmux 中时，访问安装过程的主要信息页面                     |
| Ctrl + b 2      | 在 tmux 中时，提供 root shell。Anaconda会将安装日志文件存储到/tmp文件中 |
| Ctrl + b 3      | 在 tmux 中时，显示 /tmp/anaconda.log文件的内容               |
| Ctrl + b 4      | 在 tmux 中时，显示 /tmp/storage.log文件的内容                |
| Ctrl + b 5      | 在 tmux 中时，显示 /tmp/program.log文件的内容                |
| Ctrl + Alt + F6 | 访问 Anaconda 图形界面                                       |

> 对于 tmux，键盘快捷键通过两个操作执行：按下和释放 Ctrl + b，然后按下要访问的窗口所对应的数字键。可以使用 Alt + Tab 在窗口之间轮换当前焦点。
>
> 为了与早期的 RHEL 版本兼容，通过 Ctrl + Alt + F2 ~ F5 访问的虚拟控制台还会在安装过程中显示root shell。

