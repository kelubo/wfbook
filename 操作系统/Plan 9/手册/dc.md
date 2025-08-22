# DC

dc – desk calculator 桌面计算器

```bash
dc [file]
```

描述


|      |                                                              |
| ---- | ------------------------------------------------------------ |
|      | *Dc* is an arbitrary precision desk calculator. Ordinarily it operates    on decimal integers, but one may specify an input base, output    base, and a number of fractional digits to be maintained. The    overall structure of *dc* is a stacking (reverse Polish) calculator.    If an argument is given, input is taken from that file until its    end, then from the standard input. The following constructions    are recognized: *Dc* 是一个任意精度的桌面计算器。通常它运行 在十进制整数上，但可以指定输入基数，output base 和要维护的小数位数。这 *DC* 的整体结构是一个堆叠（反向波兰语）计算器。 如果给出了参数，则从该文件中获取 input，直到其 end 结束，然后从 Standard input 开始。以下结构 得到认可：     number 数                  The value of the number is pushed on the stack. A number is an        unbroken string of the digits `0–9A–F` or `0–9a–f`. A hexadecimal number        beginning with a lower case letter must be preceded by a zero        to distinguish it from the command associated with the letter.        It may be preceded by an underscore `_` to        input a negative number. Numbers may contain decimal points. 数字的值被推送到堆栈上。数字是一个 数字 或 `0–9a–f` 的不间断字符串。 `0–9A–F` 十六进制数 以小写字母开头必须以零开头 将其与与字母关联的命令区分开来。 它可以前面有一个下划线 `_`  输入负数。数字可能包含小数点。                 `+   – /   *   %   ^    `             Add `+`, subtract –, multiply `*`, divide `/`, remainder `%`, or exponentiate        `^` the top two values on the stack. The two entries are popped        off the stack; the result is pushed on the stack in their place.        Any fractional part of an exponent is ignored. 加 `+` 、 减 –、 乘 `*` 、 除 `/` 、 余数 `%` 或 指数 `^` 堆栈上的前两个值。将弹出两个条目 离开堆栈;结果被推到堆栈上的位置。 指数的任何小数部分都将被忽略。                 `s`*x *    `S`*x*  Pop the top of the stack and store into a register named *x*,    where *x* may be any character. Under operation `S` register *x* is    treated as a stack and the value is pushed on it.  `S` *x*   弹出堆栈的顶部并存储到名为 *x* 的寄存器中， 其中 *x* 可以是任何字符。在作 `S` 下，寄存器 *x* 为 视为堆栈，并将值推送到其上。     `l`*x *    `L`*x*  Push the value in register *x* onto the stack. The register *x*    is not altered. All registers start with zero value. Under operation    `L` register *x* is treated as a stack and its top value is popped    onto the main stack.  `L` *x*   将寄存器 *x* 中的值压入堆栈。寄存器 *x* 未更改。所有 registers 都以零值开头。运行中 `L` 寄存器 *X* 被视为堆栈，其最高值被弹出 到 main 堆栈上。     `d   `Duplicate the top value on the stack.  `d   ` 复制堆栈上的 top 值。     `p   `Print the top value on the stack. The top value remains unchanged.    `P` interprets the top of the stack as an text string, removes it,    and prints it.  `p   ` 打印堆栈上的 top 值。top 值保持不变。 `P` 将堆栈的顶部解释为文本字符串，将其删除， 并打印它。     `f   `Print the values on the stack.  `f   ` 打印堆栈上的值。     `q    Q   `Exit the program. If executing a string, the recursion level    is popped by two. Under operation `Q` the top value on the stack    is popped and the string execution level is popped by that value.  `q    Q   ` 退出程序。如果执行字符串，则递归级别 被 2 弹出。在 operation `Q` 下，堆栈上的顶部值 被弹出，字符串执行级别被该值弹出。     `x   `Treat the top element of the stack as a character string and    execute it as a string of *dc* commands.  `x   ` 将堆栈的 top 元素视为字符串， 将其作为一串 *DC* 命令执行。     `X   `Replace the number on the top of the stack with its scale factor.  `X   ` 将堆栈顶部的数字替换为其比例因子。     `[ ... ]    `             Put the bracketed text string on the top of the stack. 将带括号的文本字符串放在堆栈的顶部。         <        *x     >x > *    `=`*x*  Pop and compare the top two elements of the stack. Register    *x* is executed if they obey the stated relation.  `=` *x*  Pop 并比较堆栈的前两个元素。注册 *如果他们*遵守规定的关系，则执行 x。     `v   `Replace the top element on the stack by its square root. Any    existing fractional part of the argument is taken into account,    but otherwise the scale factor is ignored.  `v   ` 将堆栈上的 top 元素替换为其平方根。任何 考虑参数的现有小数部分， 但否则将忽略比例因子。     `!   `Interpret the rest of the line as a shell command.  `!   ` 将该行的其余部分解释为 shell 命令。     `c   `Clear the stack.  `c   ` 清除堆栈。     `i   `The top value on the stack is popped and used as the number base    for further input.  `i   ` 堆栈上的顶部值被弹出并用作数字基数 以获取进一步的输入。     `I   `Push the input base on the top of the stack.  `I   ` 将输入底座推到堆栈顶部。     `o   `The top value on the stack is popped and used as the number base    for further output. In bases larger than 10, each `digit' prints    as a group of decimal digits.  `o   ` 堆栈上的顶部值被弹出并用作数字基数 以获取更多输出。在大于 10 的基数中，每个 'digit' 打印 作为一组十进制数字。     `O   `Push the output base on the top of the stack.  `O   ` 将输出基座推到堆栈顶部。     `k   `Pop the top of the stack, and use that value as a non–negative    scale factor: the appropriate number of places are printed on    output, and maintained during multiplication, division, and exponentiation.    The interaction of scale factor, input base, and output base will    be reasonable if all are changed together.    `z   `Push the stack level onto the stack.  `k   ` 弹出堆栈的顶部，并将该值用作非负值 比例因子：打印适当数量的位数 output 的 Output，并在乘法、除法和幂运算期间保持不变。 比例因子、输入基数和输出基数的交互将 如果所有内容一起更改，则要合理。 `z   ` 将堆栈级别推到堆栈上。     `Z   `Replace the number on the top of the stack with its length.  `Z   ` 将堆栈顶部的数字替换为其长度。     `?   `A line of input is taken from the input source (usually the terminal)    and executed.  `?   ` 一行 input 取自 input source （通常是 terminal） 并被处决。     `; :  `Used by *bc* for array operations.    `; :  ` 由 *bc* 用于数组作。    The scale factor set by `k` determines how many digits are kept    to the right of the decimal point. If *s* is the current scale factor,    *sa* is the scale of the first operand, *sb* is the scale of the second,    and *b* is the (integer) second operand, results are truncated to    the following scales. 设置的 `k` 比例因子 确定保留的位数 到小数点右侧。如果 *s* 是当前比例因子，则 *sa* 是第一个作数的小数位数，*sb* 是第二个作数的小数位数， *b* 是（整数）第二个作数，则结果将被截断为 以下比例。                  `+`,–`   `max(*sa,sb*)  `+` ，– `   ` 最大 （*SA，SB*）         `*    `min(*sa*+*sb* , max(*s,sa,sb*))  `*    ` 最小值 （*sa*+*sb* ， 最大值 （*s，sa，sb*））         `/    `*s *        `%    `so that dividend = divisor*quotient + remainder; remainder has        sign of dividend  `%    ` 因此，被除数 = 除数*商 + 余数;remainder 具有 股息标志         `^    `min(*sa×*|*b*|, max(*s,sa*))  `^    ` min（*sa×*|*b*|， max（*s，sa*））         `v    `max(*s,sa*)  `v    ` 最大值 （*s，sa*） |



**EXAMPLES      例子
** 



|      |                                                              |
| ---- | ------------------------------------------------------------ |
|      | Print the first ten values of *n*! 打印 *n* 的前十个值！                  `[la1+dsa*pla10>y]sy        0sa1        lyx        ` |



**SOURCE      源
**

|      |                         |
| ---- | ----------------------- |
|      | `/sys/src/cmd/dc.c    ` |



**SEE ALSO      另请参阅
**

|      |                                                              |
| ---- | ------------------------------------------------------------ |
|      | [*bc*(1)](https://plan9.io/magic/man2html/1/bc), [*hoc*(1) BC（1）、*HOC*（1） ](https://plan9.io/magic/man2html/1/hoc) |



**DIAGNOSTICS      诊断
**

|      |                                                              |
| ---- | ------------------------------------------------------------ |
|      | *x* `is unimplemented`, where *x* is an octal number: an internal error. *x* `is unimplemented` ，其中 *x* 是八进制数：内部错误。     `Out of headers' for too many numbers being kept around. 'Out of headers' 代表保留了太多数字。     `Nesting depth' for too many levels of nested execution. “嵌套深度”，用于过多级别的嵌套执行。 |



**BUGS      错误
**

|      |                                                              |
| ---- | ------------------------------------------------------------ |
|      | When the input base exceeds 16, there is no notation for digits    greater than `F`.   当输入基数超过 16 时，没有数字表示法 大于 `F` 。    Past its time. 已经过了它的时代。 |



[ Copyright](http://www.lucent.com/copyright.html) © 2025 Alcatel-Lucent.  All rig阿尔卡特朗讯。保留所有权利。