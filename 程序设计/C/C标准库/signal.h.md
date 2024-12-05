#  <signal.h>

## 简介

`<signal.h>` 是 C 标准库中的一个头文件，用于处理信号。



**signal.h** 头文件定义了一个变量类型 **sig_atomic_t**、两个函数调用和一些宏来处理程序执行期间报告的不同信号。

信号是一种异步通知机制，允许进程在特定事件发生时执行预定义的处理函数。

下面是一个简单的示例程序，演示如何使用 signal 函数来捕捉 SIGINT 信号（通常由 Ctrl+C 产生）。

## 实例

\#include <stdio.h>
 \#include <signal.h>
 \#include <unistd.h>
 
 *// 全局变量，指示程序是否应退出*
 volatile sig_atomic_t stop = 0;
 
 void handle_sigint(int sig) {
   printf("Caught signal %d**\n**", sig);
   stop = 1; *// 设置退出标志*
 }
 
 int main() {
   *// 将 SIGINT 信号的处理程序设置为 handle_sigint 函数*
   signal(SIGINT, handle_sigint);
 
   while (!stop) { *// 检查是否应退出*
     printf("Running...**\n**");
     sleep(1);
   }
 
   printf("Exiting...**\n**");
 
   return 0;
 }

以上代码中，当程序运行时，如果用户按下 Ctrl+C，会捕捉到 SIGINT 信号并调用 handle_sigint 函数，打印出信号编号。

编译执行以上代码，输出结果如下：

```
Running...
Running...
Running...
^CCaught signal 2
Exiting...
```

代码解析：

- `volatile sig_atomic_t stop = 0;`：定义一个全局变量 `stop`，用于指示程序是否应退出。使用 `volatile` 关键字确保编译器不会优化掉对该变量的访问，因为它可能在信号处理程序中被修改。`sig_atomic_t` 类型保证了对该变量的访问是原子的。
- 在 `handle_sigint` 信号处理函数中，将 `stop` 设置为 1，指示程序应退出。
- 在主循环中，检查 `stop` 变量的值，如果它被设置为 1，则跳出循环，结束程序。

## 库变量

下面是头文件 signal.h 中定义的变量类型：

| 序号 | 变量 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | **sig_atomic_t**  这是 **int** 类型，在信号处理程序中作为变量使用。它是一个对象的整数类型，该对象可以作为一个原子实体访问，即使存在异步信号时，该对象可以作为一个原子实体访问。 |
| 2    | **sigset_t**  一种数据类型，用于表示信号集。                 |

## 库宏

<

在 C 标准库中，`SIG_` 前缀的宏与 `signal` 函数一起使用，用于定义和处理信号的行为。下面是常见的 `SIG_` 宏及其用途：

| 序号 | 宏 & 描述                                                    |
| ---- | ------------------------------------------------------------ |
| 1    | **SIG_DFL** 表示信号的默认处理程序。使用此宏将信号恢复到其默认行为。 |
| 2    | **SIG_ERR** 表示信号处理函数设置出错的返回值。               |
| 3    | **SIG_IGN** 忽略信号。                                       |

信号类型：

| 常量        | 描述                                                    |
| ----------- | ------------------------------------------------------- |
| `SIGABRT`   | 由 `abort` 函数产生的信号，表示异常终止                 |
| `SIGALRM`   | 由 `alarm` 函数设定的定时器到期信号                     |
| `SIGBUS`    | 非法内存访问（例如，访问未对齐的内存地址）              |
| `SIGCHLD`   | 子进程状态改变（退出或停止）                            |
| `SIGCONT`   | 继续执行被暂停的进程                                    |
| `SIGFPE`    | 算术错误（例如，除零错误、浮点异常）                    |
| `SIGHUP`    | 挂起信号（通常用于检测终端断开）                        |
| `SIGILL`    | 非法指令                                                |
| `SIGINT`    | 中断信号（通常由 Ctrl+C 产生）                          |
| `SIGKILL`   | 立即终止信号（不能被捕捉或忽略）                        |
| `SIGPIPE`   | 向无读进程的管道写数据                                  |
| `SIGQUIT`   | 终端退出信号（通常由 Ctrl+\ 产生），生成核心转储        |
| `SIGSEGV`   | 段错误（非法内存访问）                                  |
| `SIGSTOP`   | 停止进程的执行（不能被捕捉或忽略）                      |
| `SIGTERM`   | 终止信号                                                |
| `SIGTSTP`   | 暂停进程（通常由 Ctrl+Z 产生）                          |
| `SIGTTIN`   | 后台进程从终端读数据时产生的信号                        |
| `SIGTTOU`   | 后台进程向终端写数据时产生的信号                        |
| `SIGUSR1`   | 用户自定义信号 1                                        |
| `SIGUSR2`   | 用户自定义信号 2                                        |
| `SIGPOLL`   | I/O 事件（取代 SIGIO）                                  |
| `SIGPROF`   | 定时器到期信号（由 `setitimer` 设置的 profiling timer） |
| `SIGSYS`    | 非法系统调用                                            |
| `SIGTRAP`   | 断点或陷阱指令                                          |
| `SIGURG`    | 套接字紧急条件信号                                      |
| `SIGVTALRM` | 虚拟时钟定时器到期信号                                  |
| `SIGXCPU`   | 超过 CPU 时间限制                                       |
| `SIGXFSZ`   | 超过文件大小限制                                        |

## 库函数

下面是头文件 signal.h 中定义的函数：

| 函数                                                         | 描述                                             |
| ------------------------------------------------------------ | ------------------------------------------------ |
| `void (*signal(int sig, void (*func)(int)))(int);`           | 设置信号处理程序。                               |
| `int raise(int sig);`                                        | 向当前进程发送信号。                             |
| `int kill(pid_t pid, int sig);`                              | 向指定进程发送信号。                             |
| `int sigprocmask(int how, const sigset_t *set, sigset_t *oldset);` | 检查或更改阻塞信号集。                           |
| `int sigaction(int sig, const struct sigaction *act, struct sigaction *oldact);` | 检查或更改信号处理程序。                         |
| `int sigsuspend(const sigset_t *mask);`                      | 暂时替换当前信号屏蔽字并挂起进程直到捕捉到信号。 |
| `int sigpending(sigset_t *set);`                             | 检查未决信号集。                                 |
| `int sigemptyset(sigset_t *set);`                            | 初始化信号集为空集。                             |
| `int sigfillset(sigset_t *set);`                             | 初始化信号集为全信号集。                         |
| `int sigaddset(sigset_t *set, int signum);`                  | 向信号集中添加指定信号。                         |
| `int sigdelset(sigset_t *set, int signum);`                  | 从信号集中删除指定信号。                         |
| `int sigismember(const sigset_t *set, int signum);`          | 检查指定信号是否在信号集中。                     |
| `void abort(void);`                                          | 产生 `SIGABRT` 信号，导致进程异常终止。          |
| `unsigned int alarm(unsigned int seconds);`                  | 在指定秒数后发送 `SIGALRM` 信号给调用进程。      |
| `int pause(void);`                                           | 挂起进程直到捕捉到信号。                         |
| `void psignal(int sig, const char *s);`                      | 打印信号描述信息。                               |
| `char *strsignal(int sig);`                                  | 返回信号描述字符串。                             |
| `int sigwait(const sigset_t *set, int *sig);`                | 阻塞等待信号并处理。                             |