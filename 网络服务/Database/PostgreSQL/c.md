# PostgreSQL 时间/日期函数和操作符

### 日期/时间操作符

下表演示了基本算术操作符的行为(+,*, 等)：

| 操作符 | 例子                                                         | 结果                              |
| ------ | ------------------------------------------------------------ | --------------------------------- |
| `+`    | `date '2001-09-28' + integer '7'`                            | `date '2001-10-05'`               |
| `+`    | `date '2001-09-28' + interval '1 hour'`                      | `timestamp '2001-09-28 01:00:00'` |
| `+`    | `date '2001-09-28' + time '03:00'`                           | `timestamp '2001-09-28 03:00:00'` |
| `+`    | `interval '1 day' + interval '1 hour'`                       | `interval '1 day 01:00:00'`       |
| `+`    | `timestamp '2001-09-28 01:00' + interval '23 hours'`         | `timestamp '2001-09-29 00:00:00'` |
| `+`    | `time '01:00' + interval '3 hours'`                          | `time '04:00:00'`                 |
| `-`    | `- interval '23 hours'`                                      | `interval '-23:00:00'`            |
| `-`    | `date '2001-10-01' - date '2001-09-28'`                      | `integer '3'` (days)              |
| `-`    | `date '2001-10-01' - integer '7'`                            | `date '2001-09-24'`               |
| `-`    | `date '2001-09-28' - interval '1 hour'`                      | `timestamp '2001-09-27 23:00:00'` |
| `-`    | `time '05:00' - time '03:00'`                                | `interval '02:00:00'`             |
| `-`    | `time '05:00' - interval '2 hours'`                          | `time '03:00:00'`                 |
| `-`    | `timestamp '2001-09-28 23:00' - interval '23 hours'`         | `timestamp '2001-09-28 00:00:00'` |
| `-`    | `interval '1 day' - interval '1 hour'`                       | `interval '1 day -01:00:00'`      |
| `-`    | `timestamp '2001-09-29 03:00' - timestamp '2001-09-27 12:00'` | `interval '1 day 15:00:00'`       |
| `*`    | `900 * interval '1 second'`                                  | `interval '00:15:00'`             |
| `*`    | `21 * interval '1 day'`                                      | `interval '21 days'`              |
| `*`    | `double precision '3.5' * interval '1 hour'`                 | `interval '03:30:00'`             |
| `/`    | `interval '1 hour' / double precision '1.5'`                 | `interval '00:40:00'`             |

### 日期/时间函数

| 函数                                                         | 返回类型                   | 描述                                                         | 例子                                                       | 结果                       |
| ------------------------------------------------------------ | -------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------- | -------------------------- |
| `age(timestamp, timestamp)`                                  | `interval`                 | 减去参数后的"符号化"结果，使用年和月，不只是使用天           | `age(timestamp '2001-04-10', timestamp '1957-06-13')`      | `43 years 9 mons 27 days`  |
| `age(timestamp)`                                             | `interval`                 | 从`current_date`减去参数后的结果（在午夜）                   | `age(timestamp '1957-06-13')`                              | `43 years 8 mons 3 days`   |
| `clock_timestamp()`                                          | `timestamp with time zone` | 实时时钟的当前时间戳（在语句执行时变化）                     |                                                            |                            |
| `current_date`                                               | `date`                     | 当前的日期；                                                 |                                                            |                            |
| `current_time`                                               | `time with time zone`      | 当日时间；                                                   |                                                            |                            |
| `current_timestamp`                                          | `timestamp with time zone` | 当前事务开始时的时间戳；                                     |                                                            |                            |
| `date_part(text, timestamp)`                                 | `double precision`         | 获取子域(等效于`extract`)；                                  | `date_part('hour', timestamp '2001-02-16 20:38:40')`       | `20`                       |
| `date_part(text, interval)`                                  | `double precision`         | 获取子域(等效于`extract`)；                                  | `date_part('month', interval '2 years 3 months')`          | `3`                        |
| `date_trunc(text, timestamp)`                                | `timestamp`                | 截断成指定的精度；                                           | `date_trunc('hour', timestamp '2001-02-16 20:38:40')`      | `2001-02-16 20:00:00`      |
| `date_trunc(text, interval)`                                 | `interval`                 | 截取指定的精度，                                             | `date_trunc('hour', interval '2 days 3 hours 40 minutes')` | `2 days 03:00:00`          |
| `extract(field from         timestamp)`                      | `double precision`         | 获取子域；                                                   | `extract(hour from timestamp '2001-02-16 20:38:40')`       | `20`                       |
| `extract(field from         interval)`                       | `double precision`         | 获取子域；                                                   | `extract(month from interval '2 years 3 months')`          | `3`                        |
| `isfinite(date)`                                             | `boolean`                  | 测试是否为有穷日期(不是 +/-无穷)                             | `isfinite(date '2001-02-16')`                              | `true`                     |
| `isfinite(timestamp)`                                        | `boolean`                  | 测试是否为有穷时间戳(不是 +/-无穷)                           | `isfinite(timestamp '2001-02-16 21:28:30')`                | `true`                     |
| `isfinite(interval)`                                         | `boolean`                  | 测试是否为有穷时间间隔                                       | `isfinite(interval '4 hours')`                             | `true`                     |
| `justify_days(interval)`                                     | `interval`                 | 按照每月 30 天调整时间间隔                                   | `justify_days(interval '35 days')`                         | `1 mon 5 days`             |
| `justify_hours(interval)`                                    | `interval`                 | 按照每天 24 小时调整时间间隔                                 | `justify_hours(interval '27 hours')`                       | `1 day 03:00:00`           |
| `justify_interval(interval)`                                 | `interval`                 | 使用`justify_days`和`justify_hours`调整时间间隔的同时进行正负号调整 | `justify_interval(interval '1 mon -1 hour')`               | `29 days 23:00:00`         |
| `localtime`                                                  | `time`                     | 当日时间；                                                   |                                                            |                            |
| `localtimestamp`                                             | `timestamp`                | 当前事务开始时的时间戳；                                     |                                                            |                            |
| `                         make_date(year int,             month int,             day int)                     ` | `date`                     | 为年、月和日字段创建日期                                     | `make_date(2013, 7, 15)`                                   | `2013-07-15`               |
| `                     make_interval(years int DEFAULT 0,           months int DEFAULT 0,           weeks int DEFAULT 0,           days int DEFAULT 0,           hours int DEFAULT 0,           mins int DEFAULT 0,           secs double precision DEFAULT 0.0)                   ` | `interval`                 | 从年、月、周、天、小时、分钟和秒字段中创建间隔               | `make_interval(days := 10)`                                | `10 days`                  |
| `                     make_time(hour int,           min int,           sec double precision)                   ` | `time`                     | 从小时、分钟和秒字段中创建时间                               | `make_time(8, 15, 23.5)`                                   | `08:15:23.5`               |
| `                     make_timestamp(year int,           month int,           day int,           hour int,           min int,           sec double precision)                   ` | `timestamp`                | 从年、月、日、小时、分钟和秒字段中创建时间戳                 | `make_timestamp(2013, 7, 15, 8, 15, 23.5)`                 | `2013-07-15 08:15:23.5`    |
| `                     make_timestamptz(year int,           month int,           day int,           hour int,           min int,           sec double precision,           [ timezone text ])                   ` | `timestamp with time zone` | 从年、月、日、小时、分钟和秒字段中创建带有时区的时间戳。         没有指定`timezone`时，使用当前的时区。 | `make_timestamptz(2013, 7, 15, 8, 15, 23.5)`               | `2013-07-15 08:15:23.5+01` |
| `now()`                                                      | `timestamp with time zone` | 当前事务开始时的时间戳；                                     |                                                            |                            |
| `statement_timestamp()`                                      | `timestamp with time zone` | 实时时钟的当前时间戳；                                       |                                                            |                            |
| `timeofday()`                                                | `text`                     | 与`clock_timestamp`相同，但结果是一个`text` 字符串；         |                                                            |                            |
| `transaction_timestamp()`                                    | `timestamp with time zone` | 当前事务开始时的时间戳；                                     |                                                            |                            |

# PostgreSQL  常用函数

PostgreSQL 内置函数也称为聚合函数，用于对字符串或数字数据执行处理。

下面是所有通用 PostgreSQL 内置函数的列表：

- COUNT 函数：用于计算数据库表中的行数。
- MAX 函数：用于查询某一特定列中最大值。
- MIN 函数：用于查询某一特定列中最小值。
- AVG 函数：用于计算某一特定列中平均值。
- SUM 函数：用于计算数字列所有值的总和。
- ARRAY 函数：用于输入值(包括null)添加到数组中。
- Numeric 函数：完整列出一个 SQL 中所需的操作数的函数。
- String 函数：完整列出一个 SQL 中所需的操作字符的函数。

------

## 数学函数

下面是PostgreSQL中提供的数学函数列表，需要说明的是，这些函数中有许多都存在多种形式，区别只是参数类型不同。除非特别指明，任何特定形式的函数都返回和它的参数相同的数据类型。

| 函数                        | 返回类型 | 描述                   | 例子            | 结果              |
| --------------------------- | -------- | ---------------------- | --------------- | ----------------- |
| abs(x)                      |          | 绝对值                 | abs(-17.4)      | 17.4              |
| cbrt(double)                |          | 立方根                 | cbrt(27.0)      | 3                 |
| ceil(double/numeric)        |          | 不小于参数的最小的整数 | ceil(-42.8)     | -42               |
| degrees(double)             |          | 把弧度转为角度         | degrees(0.5)    | 28.6478897565412  |
| exp(double/numeric)         |          | 自然指数               | exp(1.0)        | 2.71828182845905  |
| floor(double/numeric)       |          | 不大于参数的最大整数   | floor(-42.8)    | -43               |
| ln(double/numeric)          |          | 自然对数               | ln(2.0)         | 0.693147180559945 |
| log(double/numeric)         |          | 10为底的对数           | log(100.0)      | 2                 |
| log(b numeric,x numeric)    | numeric  | 指定底数的对数         | log(2.0, 64.0)  | 6.0000000000      |
| mod(y, x)                   |          | 取余数                 | mod(9,4)        | 1                 |
| pi()                        | double   | "π"常量                | pi()            | 3.14159265358979  |
| power(a double, b double)   | double   | 求a的b次幂             | power(9.0, 3.0) | 729               |
| power(a numeric, b numeric) | numeric  | 求a的b次幂             | power(9.0, 3.0) | 729               |
| radians(double)             | double   | 把角度转为弧度         | radians(45.0)   | 0.785398163397448 |
| random()                    | double   | 0.0到1.0之间的随机数值 | random()        |                   |
| round(double/numeric)       |          | 圆整为最接近的整数     | round(42.4)     | 42                |
| round(v numeric, s int)     | numeric  | 圆整为s位小数数字      | round(42.438,2) | 42.44             |
| sign(double/numeric)        |          | 参数的符号(-1,0,+1)    | sign(-8.4)      | -1                |
| sqrt(double/numeric)        |          | 平方根                 | sqrt(2.0)       | 1.4142135623731   |
| trunc(double/numeric)       |          | 截断(向零靠近)         | trunc(42.8)     | 42                |
| trunc(v numeric, s int)     | numeric  | 截断为s小数位置的数字  | trunc(42.438,2) | 42.43             |

### 三角函数列表

| 函数        | 描述              |
| ----------- | ----------------- |
| acos(x)     | 反余弦            |
| asin(x)     | 反正弦            |
| atan(x)     | 反正切            |
| atan2(x, y) | 正切 y/x 的反函数 |
| cos(x)      | 余弦              |
| cot(x)      | 余切              |
| sin(x)      | 正弦              |
| tan(x)      | 正切              |

------

## 字符串函数和操作符

下面是 PostgreSQL 中提供的字符串操作符列表：

| 函数                                                         | 返回类型 | 描述                                                         | 例子                                           | 结果                               |
| ------------------------------------------------------------ | -------- | ------------------------------------------------------------ | ---------------------------------------------- | ---------------------------------- |
| string \|\| string                                           | text     | 字串连接                                                     | 'Post' 丨丨 'greSQL'                           | PostgreSQL                         |
| bit_length(string)                                           | int      | 字串里二进制位的个数                                         | bit_length('jose')                             | 32                                 |
| char_length(string)                                          | int      | 字串中的字符个数                                             | char_length('jose')                            | 4                                  |
| convert(string using conversion_name)                        | text     | 使用指定的转换名字改变编码。                                 | convert('PostgreSQL' using iso_8859_1_to_utf8) | 'PostgreSQL'                       |
| lower(string)                                                | text     | 把字串转化为小写                                             | lower('TOM')                                   | tom                                |
| octet_length(string)                                         | int      | 字串中的字节数                                               | octet_length('jose')                           | 4                                  |
| overlay(string placing string from int [for int])            | text     | 替换子字串                                                   | overlay('Txxxxas' placing 'hom' from 2 for 4)  | Thomas                             |
| position(substring in string)                                | int      | 指定的子字串的位置                                           | position('om' in 'Thomas')                     | 3                                  |
| substring(string [from int] [for int])                       | text     | 抽取子字串                                                   | substring('Thomas' from 2 for 3)               | hom                                |
| substring(string from pattern)                               | text     | 抽取匹配 POSIX 正则表达式的子字串                            | substring('Thomas' from '…$')                  | mas                                |
| substring(string from pattern for escape)                    | text     | 抽取匹配SQL正则表达式的子字串                                | substring('Thomas' from '%#"o_a#"_' for '#')   | oma                                |
| trim([leading丨trailing 丨 both] [characters] from string)   | text     | 从字串string的开头/结尾/两边/ 删除只包含characters(默认是一个空白)的最长的字串 | trim(both 'x' from 'xTomxx')                   | Tom                                |
| upper(string)                                                | text     | 把字串转化为大写。                                           | upper('tom')                                   | TOM                                |
| ascii(text)                                                  | int      | 参数第一个字符的ASCII码                                      | ascii('x')                                     | 120                                |
| btrim(string text [, characters text])                       | text     | 从string开头和结尾删除只包含在characters里(默认是空白)的字符的最长字串 | btrim('xyxtrimyyx','xy')                       | trim                               |
| chr(int)                                                     | text     | 给出ASCII码的字符                                            | chr(65)                                        | A                                  |
| convert(string text, [src_encoding name,] dest_encoding name) | text     | 把字串转换为dest_encoding                                    | convert( 'text_in_utf8', 'UTF8', 'LATIN1')     | 以ISO 8859-1编码表示的text_in_utf8 |
| initcap(text)                                                | text     | 把每个单词的第一个子母转为大写，其它的保留小写。单词是一系列字母数字组成的字符，用非字母数字分隔。 | initcap('hi thomas')                           | Hi Thomas                          |
| length(string text)                                          | int      | string中字符的数目                                           | length('jose')                                 | 4                                  |
| lpad(string text, length int [, fill text])                  | text     | 通过填充字符fill(默认为空白)，把string填充为长度length。 如果string已经比length长则将其截断(在右边)。 | lpad('hi', 5, 'xy')                            | xyxhi                              |
| ltrim(string text [, characters text])                       | text     | 从字串string的开头删除只包含characters(默认是一个空白)的最长的字串。 | ltrim('zzzytrim','xyz')                        | trim                               |
| md5(string text)                                             | text     | 计算给出string的MD5散列，以十六进制返回结果。                | md5('abc')                                     |                                    |
| repeat(string text, number int)                              | text     | 重复string number次。                                        | repeat('Pg', 4)                                | PgPgPgPg                           |
| replace(string text, from text, to text)                     | text     | 把字串string里出现地所有子字串from替换成子字串to。           | replace('abcdefabcdef', 'cd', 'XX')            | abXXefabXXef                       |
| rpad(string text, length int [, fill text])                  | text     | 通过填充字符fill(默认为空白)，把string填充为长度length。如果string已经比length长则将其截断。 | rpad('hi', 5, 'xy')                            | hixyx                              |
| rtrim(string text [, character text])                        | text     | 从字串string的结尾删除只包含character(默认是个空白)的最长的字 | rtrim('trimxxxx','x')                          | trim                               |
| split_part(string text, delimiter text, field int)           | text     | 根据delimiter分隔string返回生成的第field个子字串(1 Base)。   | split_part('abc~@~def~@~ghi', '~@~', 2)        | def                                |
| strpos(string, substring)                                    | text     | 声明的子字串的位置。                                         | strpos('high','ig')                            | 2                                  |
| substr(string, from [, count])                               | text     | 抽取子字串。                                                 | substr('alphabet', 3, 2)                       | ph                                 |
| to_ascii(text [, encoding])                                  | text     | 把text从其它编码转换为ASCII。                                | to_ascii('Karel')                              | Karel                              |
| to_hex(number int/bigint)                                    | text     | 把number转换成其对应地十六进制表现形式。                     | to_hex(9223372036854775807)                    | 7fffffffffffffff                   |
| translate(string text, from text, to text)                   | text     | 把在string中包含的任何匹配from中的字符的字符转化为对应的在to中的字符。 | translate('12345', '14', 'ax')                 | a23x5                              |

------

## 类型转换相关函数

| 函数                            | 返回类型  | 描述                                                         | 实例                                         |
| ------------------------------- | --------- | ------------------------------------------------------------ | -------------------------------------------- |
| to_char(timestamp, text)        | text      | 将时间戳转换为字符串                                         | to_char(current_timestamp, 'HH12:MI:SS')     |
| to_char(interval, text)         | text      | 将时间间隔转换为字符串                                       | to_char(interval '15h 2m 12s', 'HH24:MI:SS') |
| to_char(int, text)              | text      | 整型转换为字符串                                             | to_char(125, '999')                          |
| to_char(double precision, text) | text      | 双精度转换为字符串                                           | to_char(125.8::real, '999D9')                |
| to_char(numeric, text)          | text      | 数字转换为字符串                                             | to_char(-125.8, '999D99S')                   |
| to_date(text, text)             | date      | 字符串转换为日期                                             | to_date('05 Dec 2000', 'DD Mon YYYY')        |
| to_number(text, text)           | numeric   | 转换字符串为数字                                             | to_number('12,454.8-', '99G999D9S')          |
| to_timestamp(text, text)        | timestamp | 转换为指定的时间格式 time zone  convert string to time stamp | to_timestamp('05 Dec 2000', 'DD Mon YYYY')   |
| to_timestamp(double precision)  | timestamp | 把UNIX纪元转换成时间戳                                       | to_timestamp(1284352323)                     |

> 参考文章：https://blog.csdn.net/sun5769675/article/details/50628979

​														

## SQL 语言

PostgreSQL支持标准的SQL类型`int`、`smallint`、`real`、`double precision`、`char(*`N`*)`、`varchar(*`N`*)`、`date`、`time`、`timestamp`和`interval`，还支持其他的通用功能的类型和丰富的几何类型。PostgreSQL中可以定制任意数量的用户定义数据类型。因而类型名并不是语法关键字，除了SQL标准要求支持的特例外。

​    这部份描述在PostgreSQL中SQL语言的使用。我们从描述SQL的一般语法开始，然后解释如何创建保存数据的结构、如何填充数据库以及如何查询它。中间的部分列出了在SQL命令中可用的数据类型和函数。剩余的部分则留给对于调优数据性能的重要方面。   

​    这部份的信息被组织成让一个新用户可以从头到尾跟随它来全面理解主题，而不需要多次参考后面的内容。这些章都是自包含的，这样高级用户可以根据他们的选择阅读单独的章。这一部分的信息被以一种叙事的风格展现。需要查看一个特定命令的完整描述的读者应该去看看[第 VI 部分](http://www.postgres.cn/docs/13/reference.html)。   

​    这一部分的阅读者应该知道如何连接到一个PostgreSQL数据库并且发出SQL命令。我们鼓励不熟悉这些问题的读者先去阅读[第 I 部分](http://www.postgres.cn/docs/13/tutorial.html)。SQL通常使用PostgreSQL的交互式终端psql输入，但是其他具有相似功能的程序也可以被使用。   

## 4.1. 词法结构

- [4.1.1. 标识符和关键词](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS)
- [4.1.2. 常量](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS)
- [4.1.3. 操作符](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-OPERATORS)
- [4.1.4. 特殊字符](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-SPECIAL-CHARS)
- [4.1.5. 注释](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-COMMENTS)
- [4.1.6. 操作符优先级](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-PRECEDENCE)



   SQL输入由一个*命令*序列组成。一个命令由一个*记号*的序列构成，并由一个分号（“;”）终结。输入流的末端也会标志一个命令的结束。具体哪些记号是合法的与具体命令的语法有关。  

   一个记号可以是一个*关键词*、一个*标识符*、一个*带引号的标识符*、一个*literal*（或常量）或者一个特殊字符符号。记号通常以空白（空格、制表符、新行）来分隔，但在无歧义时并不强制要求如此（唯一的例子是一个特殊字符紧挨着其他记号）。  

​    例如，下面是一个（语法上）合法的SQL输入：

```
SELECT * FROM MY_TABLE;
UPDATE MY_TABLE SET A = 5;
INSERT INTO MY_TABLE VALUES (3, 'hi there');
```

​    这是一个由三个命令组成的序列，每一行一个命令（尽管这不是必须地，在同一行中可以有超过一个命令，而且命令还可以被跨行分割）。   

   另外，*注释*也可以出现在SQL输入中。它们不是记号，它们和空白完全一样。  

   根据标识命令、操作符、参数的记号不同，SQL的语法不很一致。最前面的一些记号通常是命令名，因此在上面的例子中我们通常会说一个“SELECT”、一个“UPDATE”和一个“INSERT”命令。但是例如`UPDATE`命令总是要求一个`SET`记号出现在一个特定位置，而`INSERT`则要求一个`VALUES`来完成命令。每个命令的精确语法规则在[第 VI 部分](http://www.postgres.cn/docs/13/reference.html)中介绍。  

### 4.1.1. 标识符和关键词



​    上例中的`SELECT`、`UPDATE`或`VALUES`记号是*关键词*的例子，即SQL语言中具有特定意义的词。记号`MY_TABLE`和`A`则是*标识符*的例子。它们标识表、列或者其他数据库对象的名字，取决于使用它们的命令。因此它们有时也被简称为“名字”。关键词和标识符具有相同的词法结构，这意味着我们无法在没有语言知识的前提下区分一个标识符和关键词。一个关键词的完整列表可以在[附录 C](http://www.postgres.cn/docs/13/sql-keywords-appendix.html)中找到。   

​    SQL标识符和关键词必须以一个字母（`a`-`z`，也可以是带变音符的字母和非拉丁字母）或一个下划线（_）开始。后续字符可以是字母、下划线（`_`）、数字（`0`-`9`）或美元符号（`$`）。注意根据SQL标准的字母规定，美元符号是不允许出现在标识符中的，因此它们的使用可能会降低应用的可移植性。SQL标准不会定义包含数字或者以下划线开头或结尾的关键词，因此这种形式的标识符不会与未来可能的标准扩展冲突 。   

​        系统中一个标识符的长度不能超过 `NAMEDATALEN`-1 字节，在命令中可以写超过此长度的标识符，但是它们会被截断。默认情况下，`NAMEDATALEN` 的值为64，因此标识符的长度上限为63字节。如果这个限制有问题，可以在`src/include/pg_config_manual.h`中修改 `NAMEDATALEN` 常量。   

​        关键词和不被引号修饰的标识符是大小写不敏感的。因此：

```
UPDATE MY_TABLE SET A = 5;
```

​    可以等价地写成：

```
uPDaTE my_TabLE SeT a = 5;
```

​    一个常见的习惯是将关键词写成大写，而名称写成小写，例如：

```
UPDATE my_table SET a = 5;
```

   

​        这里还有第二种形式的标识符：*受限标识符*或*被引号修饰的标识符*。它是由双引号（`"`）包围的一个任意字符序列。一个受限标识符总是一个标识符而不会是一个关键字。因此`"select"`可以用于引用一个名为“select”的列或者表，而一个没有引号修饰的`select`则会被当作一个关键词，从而在本应使用表或列名的地方引起解析错误。在上例中使用受限标识符的例子如下：

```
UPDATE "my_table" SET "a" = 5;
```

   

​    受限标识符可以包含任何字符，除了代码为0的字符（如果要包含一个双引号，则写两个双引号）。这使得可以构建原本不被允许的表或列的名称，例如包含空格或花号的名字。但是长度限制依然有效。   



​    一种受限标识符的变体允许包括转义的用代码点标识的Unicode字符。这种变体以`U&`（大写或小写U跟上一个花号）开始，后面紧跟双引号修饰的名称，两者之间没有任何空白，如`U&"foo"`（注意这里与操作符`&`似乎有一些混淆，但是在`&`操作符周围使用空白避免了这个问题） 。在引号内，Unicode字符可以以转义的形式指定：反斜线接上4位16进制代码点号码或者反斜线和加号接上6位16进制代码点号码。例如，标识符`"data"`可以写成：

```
U&"d\0061t\+000061"
```

​    下面的例子用斯拉夫语字母写出了俄语单词 “slon”（大象）：

```
U&"\0441\043B\043E\043D"
```

   

​    如果希望使用其他转义字符来代替反斜线，可以在字符串后使用`UESCAPE`子句，例如：

```
U&"d!0061t!+000061" UESCAPE '!'
```

​    转义字符可以是除了16进制位、加号、单引号、双引号、空白字符之外的任意单个字符。注意转义字符是被写在单引号而不是双引号内。   

​    为了在标识符中包括转义字符本身，将其写两次即可。   

​    Unicode转义语法只有在服务器编码为`UTF8`时才起效。当使用其他服务器编码时，只有在ASCII范围内（最高到`\007F`）的编码点才能被使用。4位和6位形式都可以被用来定义UTF-16代理对来组成代码点大于U+FFFF的字符，尽管6位形式的存在使得这种做法变得不必要（代理对并不被直接存储，而是被被绑定到一个单独的代码点然后被编码到UTF-8）。   

​    将一个标识符变得受限同时也使它变成大小写敏感的，反之非受限名称总是被转换成小写形 式。例如，标识符`FOO`、`foo`和`"foo"`在PostgreSQL中被认为是相同的，而`"Foo"`和`"FOO"`则互 不相同且也不同于前面三个标识符（PostgreSQL将非受限名字转换为小写形式与SQL标准是不兼容  的，SQL标准中要求将非受限名称转换为大写形式。这样根据标准， `foo`应该和 `"FOO"`而不是`"foo"`相同。如果希望写一个可移植的应用，我们应该总是用引号修饰一个特定名字或者 从不使用 引号修饰）。   

### 4.1.2. 常量



​    在PostgreSQL中有三种*隐式类型常量*：字符串、位串和数字。常量也可以被指定显示类型，这可以使得它被更精确地展示以及更有效地处理。这些选择将会在后续小节中讨论。   

#### 4.1.2.1. 字符串常量



​               在SQL中，一个字符串常量是一个由单引号（`'`）包围的任意字符序列，例如`'This is a string'`。为了在一个字符串中包括一个单引号，可以写两个相连的单引号，例如`'Dianne''s horse'`。注意这和一个双引号（`"`）*不*同。    

​     两个只由空白及*至少一个新行*分隔的字符串常量会被连接在一起，并且将作为一个写在一起的字符串常量来对待。例如：

```
SELECT 'foo'
'bar';
```

​     等同于：

```
SELECT 'foobar';
```

​     但是：

```
SELECT 'foo'      'bar';
```

​     则不是合法的语法（这种有些奇怪的行为是SQL指定的，PostgreSQL遵循了该标准）。    

#### 4.1.2.2. C风格转义的字符串常量



​     PostgreSQL也接受“转义”字符串常量，这也是SQL标准的一个扩展。一个转义字符串常量可以通过在开单引号前面写一个字母`E`（大写或小写形式）来指定，例如`E'foo'`（当一个转义字符串常量跨行时，只在第一个开引号之前写`E`）。在一个转义字符串内部，一个反斜线字符（`\`）会开始一个 C 风格的*反斜线转义*序列，在其中反斜线和后续字符的组合表示一个特殊的字节值（如[表 4.1](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-BACKSLASH-TABLE)中所示）。    

**表 4.1. 反斜线转义序列**

| 反斜线转义序列                                               | 解释                               |
| ------------------------------------------------------------ | ---------------------------------- |
| `\b`                                                         | 退格                               |
| `\f`                                                         | 换页                               |
| `\n`                                                         | 换行                               |
| `\r`                                                         | 回车                               |
| `\t`                                                         | 制表符                             |
| `\*`o`*`,         `\*`oo`*`,         `\*`ooo`*`         (*`o`* = 0 - 7) | 八进制字节值                       |
| `\x*`h`*`,         `\x*`hh`*`         (*`h`* = 0 - 9, A - F) | 十六进制字节值                     |
| `\u*`xxxx`*`,         `\U*`xxxxxxxx`*`         (*`x`* = 0 - 9, A - F) | 16 或 32-位十六进制 Unicode 字符值 |



​     跟随在一个反斜线后面的任何其他字符被当做其字面意思。因此，要包括一个反斜线字符，请写两个反斜线（`\\`）。在一个转义字符串中包括一个单引号除了普通方法`''`之外，还可以写成`\'`。    

​     你要负责保证你创建的字节序列由服务器字符集编码中合法的字符组成，特别是在使用八进制或十六进制转义时。如果服务器编码为 UTF-8，那么应该使用 Unicode 转义或替代的 Unicode 转义语法（在[第 4.1.2.3 节](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-STRINGS-UESCAPE)中解释）。替代方案可能是手工写出 UTF-8 编码字节，这可能会非常麻烦。    

​     只有当服务器编码是`UTF8`时，Unicode 转义语法才能完全工作。当使用其他服务器编码时，只有在 ASCII 范围（低于`\u007F`）内的代码点能够被指定。4 位和 8 位形式都能被用来指定 UTF-16 代理对，用来组成代码点超过 U+FFFF 的字符，不过 8 位形式的可用从技术上使得这种做法不再是必须的（当服务器编码为`UTF8`并使用代理对时，它们首先被结合到一个单一代码点，然后会被用 UTF-8 编码）。    

### 小心

​     如果配置参数[standard_conforming_strings](http://www.postgres.cn/docs/13/runtime-config-compatible.html#GUC-STANDARD-CONFORMING-STRINGS)为`off`，那么PostgreSQL对常规字符串常量和转义字符串常量中的反斜线转义都识别。不过，从PostgreSQL 9.1 开始，该参数的默认值为`on`，意味着只在转义字符串常量中识别反斜线转义。这种行为更兼容标准，但是可能打断依赖于历史行为（反斜线转义总是会被识别）的应用。作为一种变通，你可以设置该参数为`off`，但是最好迁移到符合新的行为。如果你需要使用一个反斜线转义来表示一个特殊字符，为该字符串常量写上一个`E`。    

​     在`standard_conforming_strings`之外，配置参数[escape_string_warning](http://www.postgres.cn/docs/13/runtime-config-compatible.html#GUC-ESCAPE-STRING-WARNING)和[backslash_quote](http://www.postgres.cn/docs/13/runtime-config-compatible.html#GUC-BACKSLASH-QUOTE)也决定了如何对待字符串常量中的反斜线。    

​     代码零的字符不能出现在一个字符串常量中。    

#### 4.1.2.3. 带有 Unicode 转义的字符串常量



​     PostgreSQL也支持另一种类型的字符串转义语法，它允许用代码点指定任意 Unicode 字符。一个 Unicode 转义字符串常量开始于`U&`（大写或小写形式的字母 U，后跟花号），后面紧跟着开引号，之间没有任何空白，例如`U&'foo'`（注意这产生了与操作符`&`的混淆。在操作符周围使用空白来避免这个问题）。在引号内，Unicode 字符可以通过写一个后跟 4 位十六进制代码点编号或者一个前面有加号的 6 位十六进制代码点编号的反斜线来指定。例如，字符串`'data'`可以被写为

```
U&'d\0061t\+000061'
```

​     下面的例子用斯拉夫字母写出了俄语的单词“slon”（大象）：

```
U&'\0441\043B\043E\043D'
```

​    

​     如果想要一个不是反斜线的转义字符，可以在字符串之后使用`UESCAPE`子句来指定，例如：

```
U&'d!0061t!+000061' UESCAPE '!'
```

​     转义字符可以是出一个十六进制位、加号、单引号、双引号或空白字符之外的任何单一字符。    

​     只有当服务器编码是`UTF8`时，Unicode 转义语法才能完全工作。当使用其他服务器编码时，只有在 ASCII 范围（低于`\u007F`）内的代码点能够被指定。4 位和 8 位形式都能被用来指定 UTF-16 代理对，用来组成代码点超过 U+FFFF 的字符，不过 8 位形式的可用从技术上使得这种做法不再是必须的（当服务器编码为`UTF8`并使用代理对时，它们首先被结合到一个单一代码点，然后会被用 UTF-8 编码）。    

​     还有，只有当配置参数[standard_conforming_strings](http://www.postgres.cn/docs/13/runtime-config-compatible.html#GUC-STANDARD-CONFORMING-STRINGS)被打开时，用于字符串常量的 Unicode 转义语法才能工作。这是因为否则这种语法将迷惑客户端中肯地解析 SQL 语句，进而会导致 SQL 注入以及类似的安全性问题。如果这个参数被设置为关闭，这种语法将被拒绝并且报告一个错误消息。    

​     要在一个字符串中包括一个表示其字面意思的转义字符，把它写两次。    

#### 4.1.2.4. 美元引用的字符串常量



​     虽然用于指定字符串常量的标准语法通常都很方便，但是当字符串中包含了很多单引号或反斜线时很难理解它，因为每一个都需要被双写。要在这种情形下允许可读性更好的查询，PostgreSQL提供了另一种被称为“美元引用”的方式来书写字符串常量。一个美元引用的字符串常量由一个美元符号（`$`）、一个可选的另个或更多字符的“标签”、另一个美元符号、一个构成字符串内容的任意字符序列、一个美元符号、开始这个美元引用的相同标签和一个美元符号组成。例如，这里有两种不同的方法使用美元引用指定字符串“Dianne's horse”：

```
$$Dianne's horse$$
$SomeTag$Dianne's horse$SomeTag$
```

​     注意在美元引用字符串中，单引号可以在不被转义的情况下使用。事实上，在一个美元引用字符串中不需要对字符进行转义：字符串内容总是按其字面意思写出。反斜线不是特殊的，并且美元符号也不是特殊的，除非它们是匹配开标签的一个序列的一部分。    

​     可以通过在每一个嵌套级别上选择不同的标签来嵌套美元引用字符串常量。这最常被用在编写函数定义上。例如：

```
$function$
BEGIN
    RETURN ($1 ~ $q$[\t\r\n\v\\]$q$);
END;
$function$
```

​     这里，序列`$q$[\t\r\n\v\\]$q$`表示一个美元引用的文字串`[\t\r\n\v\\]`，当该函数体被PostgreSQL执行时它将被识别。但是因为该序列不匹配外层的美元引用的定界符`$function$`，它只是一些在外层字符串所关注的常量中的字符而已。    

​     一个美元引用字符串的标签（如果有）遵循一个未被引用标识符的相同规则，除了它不能包含一个美元符号之外。标签是大小写敏感的，因此`$tag$String content$tag$`是正确的，但是`$TAG$String content$tag$`不正确。    

​     一个跟着一个关键词或标识符的美元引用字符串必须用空白与之分隔开，否则美元引用定界符可能会被作为前面标识符的一部分。    

​     美元引用不是 SQL  标准的一部分，但是在书写复杂字符串文字方面，它常常是一种比兼容标准的单引号语法更方便的方法。当要表示的字符串常量位于其他常量中时它特别有用，这种情况常常在过程函数定义中出现。如果用单引号语法，上一个例子中的每个反斜线将必须被写成四个反斜线，这在解析原始字符串常量时会被缩减到两个反斜线，并且接着在函数执行期间重新解析内层字符串常量时变成一个。    

#### 4.1.2.5. 位串常量



​     位串常量看起来像常规字符串常量在开引号之前（中间无空白）加了一个`B`（大写或小写形式），例如`B'1001'`。位串常量中允许的字符只有`0`和`1`。    

​     作为一种选择，位串常量可以用十六进制记号法指定，使用一个前导`X`（大写或小写形式）,例如`X'1FF'`。这种记号法等价于一个用四个二进制位取代每个十六进制位的位串常量。    

​     两种形式的位串常量可以以常规字符串常量相同的方式跨行继续。美元引用不能被用在位串常量中。    

#### 4.1.2.6. 数字常量



​     在这些一般形式中可以接受数字常量：

```
digits
digits.[digits][e[+-]digits]
[digits].digits[e[+-]digits]
digitse[+-]digits
```

​     其中*`digits`*是一个或多个十进制数字（0 到 9）。如果使用了小数点，在小数点前面或后面必须至少有一个数字。如果存在一个指数标记（`e`），在其后必须跟着至少一个数字。在该常量中不能嵌入任何空白或其他字符。注意任何前导的加号或减号并不实际被考虑为常量的一部分，它是一个应用到该常量的操作符。    

​     这些是合法数字常量的例子：


 42
 3.5
 4.
 .001
 5e2
 1.925e-3

​    

​                    如果一个不包含小数点和指数的数字常量的值适合类型`integer`（32 位），它首先被假定为类型`integer`。否则如果它的值适合类型`bigint`（64 位），它被假定为类型`bigint`。再否则它会被取做类型`numeric`。包含小数点和/或指数的常量总是首先被假定为类型`numeric`。    

​     一个数字常量初始指派的数据类型只是类型转换算法的一个开始点。在大部分情况中，常量将被根据上下文自动被强制到最合适的类型。必要时，你可以通过造型它来强制一个数字值被解释为一种指定数据类型。例如，你可以这样强制一个数字值被当做类型`real`（`float4`）：

```
REAL '1.23'  -- string style
1.23::REAL   -- PostgreSQL (historical) style
```

​     这些实际上只是接下来要讨论的一般造型记号的特例。    

#### 4.1.2.7. 其他类型的常量



​      一种*任意*类型的一个常量可以使用下列记号中的任意一种输入：

```
type 'string'
'string'::type
CAST ( 'string' AS type )
```

​     字符串常量的文本被传递到名为*`type`*的类型的输入转换例程中。其结果是指定类型的一个常量。如果对该常量的类型没有歧义（例如，当它被直接指派给一个表列时），显式类型造型可以被忽略，在那种情况下它会被自动强制。    

​     字符串常量可以使用常规 SQL 记号或美元引用书写。    

​     也可以使用一个类似函数的语法来指定一个类型强制：

```
typename ( 'string' )
```

​     但是并非所有类型名都可以用在这种方法中，详见[第 4.2.9 节](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-TYPE-CASTS)。    

​     如[第 4.2.9 节](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-TYPE-CASTS)中讨论的，`::`、`CAST()`以及函数调用语法也可以被用来指定任意表达式的运行时类型转换。要避免语法歧义，`*`type`* '*`string`*'`语法只能被用来指定简单文字常量的类型。`*`type`* '*`string`*'`语法上的另一个限制是它无法对数组类型工作，指定一个数组常量的类型可使用`::`或`CAST()`。    

​     `CAST()`语法符合 SQL。`*`type`* '*`string`*'`语法是该标准的一般化：SQL 指定这种语法只用于一些数据类型，但是PostgreSQL允许它用于所有类型。带有`::`的语法是PostgreSQL的历史用法，就像函数调用语法一样。    

### 4.1.3. 操作符



​    一个操作符名是最多`NAMEDATALEN`-1（默认为 63）的一个字符序列，其中的字符来自下面的列表：


 \+ - * / < > = ~ ! @ # % ^ & | ` ?

​    不过，在操作符名上有一些限制：    

- ​       `--` and `/*`不能在一个操作符名的任何地方出现，因为它们将被作为一段注释的开始。      

- ​       一个多字符操作符名不能以`+`或`-`结尾，除非该名称也至少包含这些字符中的一个：


  ~ ! @ # % ^ & | ` ?

  ​       例如，`@-`是一个被允许的操作符名，但`*-`不是。这些限制允许PostgreSQL解析 SQL 兼容的查询而不需要在记号之间有空格。      

   

​    当使用非 SQL 标准的操作符名时，你通常需要用空格分隔相邻的操作符来避免歧义。例如，如果你定义了一个名为`@`的左一元操作符，你不能写`X*@Y`，你必须写`X* @Y`来确保PostgreSQL把它读作两个操作符名而不是一个。   

### 4.1.4. 特殊字符

   一些不是数字字母的字符有一种不同于作为操作符的特殊含义。这些字符的详细用法可以在描述相应语法元素的地方找到。这一节只是为了告知它们的存在以及总结这些字符的目的。    

- ​      跟随在一个美元符号（`$`）后面的数字被用来表示在一个函数定义或一个预备语句中的位置参数。在其他上下文中该美元符号可以作为一个标识符或者一个美元引用字符串常量的一部分。     

- ​      圆括号（`()`）具有它们通常的含义，用来分组表达式并且强制优先。在某些情况中，圆括号被要求作为一个特定 SQL 命令的固定语法的一部分。     

- ​      方括号（`[]`）被用来选择一个数组中的元素。更多关于数组的信息见[第 8.15 节](http://www.postgres.cn/docs/13/arrays.html)。     

- ​      逗号（`,`）被用在某些语法结构中来分割一个列表的元素。     

- ​      分号（`;`）结束一个 SQL 命令。它不能出现在一个命令中间的任何位置，除了在一个字符串常量中或者一个被引用的标识符中。     

- ​      冒号（`:`）被用来从数组中选择“切片”（见[第 8.15 节](http://www.postgres.cn/docs/13/arrays.html)）。在某些 SQL 的“方言”（例如嵌入式 SQL）中，冒号被用来作为变量名的前缀。     

- ​      星号（`*`）被用在某些上下文中标记一个表的所有域或者组合值。当它被用作一个聚集函数的参数时，它还有一种特殊的含义，即该聚集不要求任何显式参数。     

- ​      句点（`.`）被用在数字常量中，并且被用来分割模式、表和列名。     

   

### 4.1.5. 注释



​    一段注释是以双横杠开始并且延伸到行结尾的一个字符序列，例如：

```
-- This is a standard SQL comment
```

   

​    另外，也可以使用 C 风格注释块：

```
/* multiline comment
 * with nesting: /* nested block comment */
 */
```

​    这里该注释开始于`/*`并且延伸到匹配出现的`*/`。这些注释块可按照 SQL 标准中指定的方式嵌套，但和 C 中不同。这样我们可以注释掉一大段可能包含注释块的代码。   

​    在进一步的语法分析前，注释会被从输入流中被移除并且实际被替换为空白。   

### 4.1.6. 操作符优先级



​    [表 4.2](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-PRECEDENCE-TABLE)显示了PostgreSQL中操作符的优先级和结合性。大部分操作符具有相同的优先并且是左结合的。操作符的优先级和结合性被硬写在解析器中。

​      此外，当使用二元和一元操作符的组合时，有时你将需要增加圆括号。例如：

```
SELECT 5 ! - 6;
```

   将被解析为：

```
SELECT 5 ! (- 6);
```

​    因为解析器不知道 — 知道时就为时已晚 — `!`被定义为一个后缀操作符而不是一个中缀操作符。在这种情况下要得到想要的行为，你必须写成：

```
SELECT (5 !) - 6;
```

​    只是为了扩展性必须付出的代价。   

**表 4.2. 操作符优先级（从高到低）**

| 操作符/元素                             | 结合性 | 描述                                                         |
| --------------------------------------- | ------ | ------------------------------------------------------------ |
| `.`                                     | 左     | 表/列名分隔符                                                |
| `::`                                    | 左     | PostgreSQL-风格的类型转换                                    |
| `[` `]`                                 | 左     | 数组元素选择                                                 |
| `+` `-`                                 | 右     | 一元加、一元减                                               |
| `^`                                     | 左     | 指数                                                         |
| `*` `/` `%`                             | 左     | 乘、除、模                                                   |
| `+` `-`                                 | 左     | 加、减                                                       |
| （任意其他操作符）                      | 左     | 所有其他本地以及用户定义的操作符                             |
| `BETWEEN` `IN` `LIKE` `ILIKE` `SIMILAR` |        | 范围包含、集合成员关系、字符串匹配                           |
| `<` `>` `=` `<=` `>=` `<>`              |        | 比较操作符                                                   |
| `IS` `ISNULL` `NOTNULL`                 |        | `IS TRUE`、`IS FALSE`、`IS       NULL`、`IS DISTINCT FROM`等 |
| `NOT`                                   | 右     | 逻辑否定                                                     |
| `AND`                                   | 左     | 逻辑合取                                                     |
| `OR`                                    | 左     | 逻辑析取                                                     |



​    注意该操作符有限规则也适用于与上述内建操作符具有相同名称的用户定义的操作符。例如，如果你为某种自定义数据类型定义了一个“+”操作符，它将具有和内建的“+”操作符相同的优先级，不管你的操作符要做什么。   

​    当一个模式限定的操作符名被用在`OPERATOR`语法中时，如下面的例子：

```
SELECT 3 OPERATOR(pg_catalog.+) 4;
```

​    `OPERATOR`结构被用来为“任意其他操作符”获得[表 4.2](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-PRECEDENCE-TABLE)中默认的优先级。不管出现在`OPERATOR()`中的是哪个指定操作符，这都是真的。   

### 注意

​     版本 9.5 之前的PostgreSQL使用的操作符优先级     规则略有不同。特别是，`<=`、`>=`     和`<>`习惯于被当作普通操作符，`IS`     测试习惯于具有较高的优先级。并且在一些认为`NOT`比     `BETWEEN`优先级高的情况下，`NOT BETWEEN`     和相关的结构的行为不一致。为了更好地兼容 SQL 标准并且减少对     逻辑上等价的结构不一致的处理，这些规则也得到了修改。在大部分情况下，     这些变化不会导致行为上的变化，或者可能会产生“no such operator”     错误，但可以通过增加圆括号解决。不过在一些极端情况中，查询可能在     没有被报告解析错误的情况下发生行为的改变。如果你发觉这些改变悄悄地     破坏了一些事情，可以打开[operator_precedence_warning](http://www.postgres.cn/docs/13/runtime-config-compatible.html#GUC-OPERATOR-PRECEDENCE-WARNING)     配置参数，然后测试你的应用看看有没有一些警告被记录。    

## 4.2. 值表达式

- [4.2.1. 列引用](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-EXPRESSIONS-COLUMN-REFS)
- [4.2.2. 位置参数](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-EXPRESSIONS-PARAMETERS-POSITIONAL)
- [4.2.3. 下标](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-EXPRESSIONS-SUBSCRIPTS)
- [4.2.4. 域选择](http://www.postgres.cn/docs/13/sql-expressions.html#FIELD-SELECTION)
- [4.2.5. 操作符调用](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-EXPRESSIONS-OPERATOR-CALLS)
- [4.2.6. 函数调用](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-EXPRESSIONS-FUNCTION-CALLS)
- [4.2.7. 聚集表达式](http://www.postgres.cn/docs/13/sql-expressions.html#SYNTAX-AGGREGATES)
- [4.2.8. 窗口函数调用](http://www.postgres.cn/docs/13/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)
- [4.2.9. 类型转换](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-TYPE-CASTS)
- [4.2.10. 排序规则表达式](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-COLLATE-EXPRS)
- [4.2.11. 标量子查询](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-SCALAR-SUBQUERIES)
- [4.2.12. 数组构造器](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-ARRAY-CONSTRUCTORS)
- [4.2.13. 行构造器](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-ROW-CONSTRUCTORS)
- [4.2.14. 表达式计算规则](http://www.postgres.cn/docs/13/sql-expressions.html#SYNTAX-EXPRESS-EVAL)



   值表达式被用于各种各样的环境中，例如在`SELECT`命令的目标列表中、作为`INSERT`或`UPDATE`中的新列值或者若干命令中的搜索条件。为了区别于一个表表达式（是一个表）的结果，一个值表达式的结果有时候被称为一个*标量*。值表达式因此也被称为*标量表达式*（或者甚至简称为*表达式*）。表达式语法允许使用算数、逻辑、集合和其他操作从原始部分计算值。  

   一个值表达式是下列之一：    

- ​      一个常量或文字值     

- ​      一个列引用     

- ​      在一个函数定义体或预备语句中的一个位置参数引用     

- ​      一个下标表达式     

- ​      一个域选择表达式     

- ​      一个操作符调用     

- ​      一个函数调用     

- ​      一个聚集表达式     

- ​      一个窗口函数调用     

- ​      一个类型转换     

- ​      一个排序规则表达式     

- ​      一个标量子查询     

- ​      一个数组构造器     

- ​      一个行构造器     

- ​      另一个在圆括号（用来分组子表达式以及重载优先级）中的值表达式     

  

  在这个列表之外，还有一些结构可以被分类为一个表达式，但是它们不遵循任何一般语法规则。这些通常具有一个函数或操作符的语义并且在[第 9 章](http://www.postgres.cn/docs/13/functions.html)中的合适位置解释。一个例子是`IS NULL`子句。  

  我们已经在[第 4.1.2 节](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS)中讨论过常量。下面的小节会讨论剩下的选项。  

### 4.2.1. 列引用



​    一个列可以以下面的形式被引用：

```
correlation.columnname
```

   

​    *`correlation`*是一个表（有可能以一个模式名限定）的名字，或者是在`FROM`子句中为一个表定义的别名。如果列名在当前索引所使用的表中都是唯一的，关联名称和分隔用的句点可以被忽略（另见[第 7 章](http://www.postgres.cn/docs/13/queries.html)）。   

### 4.2.2. 位置参数



​    一个位置参数引用被用来指示一个由 SQL 语句外部提供的值。参数被用于 SQL 函数定义和预备查询中。某些客户端库还支持独立于 SQL 命令字符串来指定数据值，在这种情况中参数被用来引用那些线外数据值。一个参数引用的形式是：

```
$number
```

   

​    例如，考虑一个函数`dept`的定义：

```
CREATE FUNCTION dept(text) RETURNS dept
    AS $$ SELECT * FROM dept WHERE name = $1 $$
    LANGUAGE SQL;
```

​    这里`$1`引用函数被调用时第一个函数参数的值。   

### 4.2.3. 下标



​    如果一个表达式得到了一个数组类型的值，那么可以抽取出该数组值的一个特定元素：

```
expression[subscript]
```

​    或者抽取出多个相邻元素（一个“数组切片”）：

```
expression[lower_subscript:upper_subscript]
```

​    （这里，方括号`[ ]`表示其字面意思）。每一个*`下标`*自身是一个表达式，它必须得到一个整数值。   

​    通常，数组*`表达式`*必须被加上括号，但是当要被加下标的表达式只是一个列引用或位置参数时，括号可以被忽略。还有，当原始数组是多维时，多个下标可以被连接起来。例如：

```
mytable.arraycolumn[4]
mytable.two_d_column[17][34]
$1[10:42]
(arrayfunction(a,b))[42]
```

​    最后一个例子中的圆括号是必需的。详见[第 8.15 节](http://www.postgres.cn/docs/13/arrays.html)。   

### 4.2.4. 域选择



​    如果一个表达式得到一个组合类型（行类型）的值，那么可以抽取该行的指定域

```
expression.fieldname
```

   

​    通常行*`表达式`*必须被加上括号，但是当该表达式是仅从一个表引用或位置参数选择时，圆括号可以被忽略。例如：

```
mytable.mycolumn
$1.somecolumn
(rowfunction(a,b)).col3
```

​    （因此，一个被限定的列引用实际上只是域选择语法的一种特例）。一种重要的特例是从一个组合类型的表列中抽取一个域：

```
(compositecol).somefield
(mytable.compositecol).somefield
```

​    这里需要圆括号来显示`compositecol`是一个列名而不是一个表名，在第二种情况中则是显示`mytable`是一个表名而不是一个模式名。   

​    你可以通过书写`.*`来请求一个组合值的所有域：

```
(compositecol).*
```

​    这种记法的行为根据上下文会有不同，详见[第 8.16.5 节](http://www.postgres.cn/docs/13/rowtypes.html#ROWTYPES-USAGE)。   

### 4.2.5. 操作符调用



​    对于一次操作符调用，有三种可能的语法：    

| *`expression`* *`operator`* *`expression`*（二元中缀操作符） |
| ------------------------------------------------------------ |
| *`operator`* *`expression`*（一元前缀操作符）                |
| *`expression`* *`operator`*（一元后缀操作符）                |

​    其中*`operator`*记号遵循[第 4.1.3 节](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-OPERATORS)的语法规则，或者是关键词`AND`、`OR`和`NOT`之一，或者是一个如下形式的受限定操作符名：

```
OPERATOR(schema.operatorname)
```

​    哪个特定操作符存在以及它们是一元的还是二元的取决于由系统或用户定义的那些操作符。[第 9 章](http://www.postgres.cn/docs/13/functions.html)描述了内建操作符。   

### 4.2.6. 函数调用



​    一个函数调用的语法是一个函数的名称（可能受限于一个模式名）后面跟上封闭于圆括号中的参数列表：

```
function_name ([expression [, expression ... ]] )
```

   

​    例如，下面会计算 2 的平方根：

```
sqrt(2)
```

   

​    当在一个某些用户不信任其他用户的数据库中发出查询时，在编写函数调用时应遵守[第 10.3 节](http://www.postgres.cn/docs/13/typeconv-func.html)中的安全防范措施。   

​    内建函数的列表在[第 9 章](http://www.postgres.cn/docs/13/functions.html)中。其他函数可以由用户增加。   

​    参数可以有选择地被附加名称。详见[第 4.3 节](http://www.postgres.cn/docs/13/sql-syntax-calling-funcs.html)。   

### 注意

​     一个采用单一组合类型参数的函数可以被有选择地称为域选择语法，并且反过来域选择可以被写成函数的风格。也就是说，记号`col(table)`和`table.col`是可以互换的。这种行为是非 SQL 标准的但是在PostgreSQL中被提供，因为它允许函数的使用来模拟“计算域”。详见[第 8.16.5 节](http://www.postgres.cn/docs/13/rowtypes.html#ROWTYPES-USAGE)。    

### 4.2.7. 聚集表达式



​    一个*聚集表达式*表示在由一个查询选择的行上应用一个聚集函数。一个聚集函数将多个输入减少到一个单一输出值，例如对输入的求和或平均。一个聚集表达式的语法是下列之一：

```
aggregate_name (expression [ , ... ] [ order_by_clause ] ) [ FILTER ( WHERE filter_clause ) ]
aggregate_name (ALL expression [ , ... ] [ order_by_clause ] ) [ FILTER ( WHERE filter_clause ) ]
aggregate_name (DISTINCT expression [ , ... ] [ order_by_clause ] ) [ FILTER ( WHERE filter_clause ) ]
aggregate_name ( * ) [ FILTER ( WHERE filter_clause ) ]
aggregate_name ( [ expression [ , ... ] ] ) WITHIN GROUP ( order_by_clause ) [ FILTER ( WHERE filter_clause ) ]
```

​    这里*`aggregate_name`*是一个之前定义的聚集（可能带有一个模式名限定），并且*`expression`*是任意自身不包含聚集表达式的值表达式或一个窗口函数调用。可选的*`order_by_clause`*和*`filter_clause`*描述如下。   

​    第一种形式的聚集表达式为每一个输入行调用一次聚集。第二种形式和第一种相同，因为`ALL`是默认选项。第三种形式为输入行中表达式的每一个可区分值（或者对于多个表达式是值的可区分集合）调用一次聚集。第四种形式为每一个输入行调用一次聚集，因为没有特定的输入值被指定，它通常只对于`count(*)`聚集函数有用。最后一种形式被用于*有序集*聚集函数，其描述如下。   

​    大部分聚集函数忽略空输入，这样其中一个或多个表达式得到空值的行将被丢弃。除非另有说明，对于所有内建聚集都是这样。   

​    例如，`count(*)`得到输入行的总数。`count(f1)`得到输入行中`f1`为非空的数量，因为`count`忽略空值。而`count(distinct f1)`得到`f1`的非空可区分值的数量。   

​    一般地，交给聚集函数的输入行是未排序的。在很多情况中这没有关系，例如不管接收到什么样的输入，`min`总是产生相同的结果。但是，某些聚集函数（例如`array_agg` 和`string_agg`）依据输入行的排序产生结果。当使用这类聚集时，可选的*`order_by_clause`*可以被用来指定想要的顺序。*`order_by_clause`*与查询级别的`ORDER BY`子句（如[第 7.5 节](http://www.postgres.cn/docs/13/queries-order.html)所述）具有相同的语法，除非它的表达式总是仅有表达式并且不能是输出列名称或编号。例如：

```
SELECT array_agg(a ORDER BY b DESC) FROM table;
```

   

​    在处理多参数聚集函数时，注意`ORDER BY`出现在所有聚集参数之后。例如，要这样写：

```
SELECT string_agg(a, ',' ORDER BY a) FROM table;
```

​    而不能这样写：

```
SELECT string_agg(a ORDER BY a, ',') FROM table;  -- 不正确
```

​    后者在语法上是合法的，但是它表示用两个`ORDER BY`键来调用一个单一参数聚集函数（第二个是无用的，因为它是一个常量）。   

​    如果在*`order_by_clause`*之外指定了`DISTINCT`，那么所有的`ORDER BY`表达式必须匹配聚集的常规参数。也就是说，你不能在`DISTINCT`列表没有包括的表达式上排序。   

### 注意

​     在一个聚集函数中指定`DISTINCT`以及`ORDER BY`的能力是一种PostgreSQL扩展。    

​    按照到目前为止的描述，如果一般目的和统计性聚集中    排序是可选的，在要为它排序输入行时可以在该聚集的常规参数    列表中放置`ORDER BY`。有一个聚集函数的子集叫    做*有序集聚集*，它*要求*一个    *`order_by_clause`*，通常是因为    该聚集的计算只对其输入行的特定顺序有意义。有序集聚集的典    型例子包括排名和百分位计算。按照上文的最后一种语法，对于    一个有序集聚集，    *`order_by_clause`*被写在    `WITHIN GROUP (...)`中。     *`order_by_clause`*中的表达式     会像普通聚集参数一样对每一个输入行计算一次，按照每个     *`order_by_clause`*的要求排序并     且交给该聚集函数作为输入参数（这和非     `WITHIN GROUP`      *`order_by_clause`*的情况不同，在其中表达     式的结果不会被作为聚集函数的参数）。如果有在     `WITHIN GROUP`之前的参数表达式，会把它们称     为*直接参数*以便与列在     *`order_by_clause`*中的     *聚集参数*相区分。与普通聚集参数不同，针对     每次聚集调用只会计算一次直接参数，而不是为每一个输入行     计算一次。这意味着只有那些变量被`GROUP BY`     分组时，它们才能包含这些变量。这个限制同样适用于根本不在     一个聚集表达式内部的直接参数。直接参数通常被用于百分数     之类的东西，它们只有作为每次聚集计算用一次的单一值才有意     义。直接参数列表可以为空，在这种情况下，写成`()`     而不是`(*)`（实际上     PostgreSQL接受两种拼写，但是只有第一     种符合 SQL 标准）。   

​         有序集聚集的调用例子：

```
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY income) FROM households;
 percentile_cont
-----------------
           50489
```

   这会从表`households`的   `income`列得到第 50 个百分位或者中位的值。   这里`0.5`是一个直接参数，对于百分位部分是一个   在不同行之间变化的值的情况它没有意义。   

​    如果指定了`FILTER`，那么只有对*`filter_clause`*计算为真的输入行会被交给该聚集函数，其他行会被丢弃。例如：

```
SELECT
    count(*) AS unfiltered,
    count(*) FILTER (WHERE i < 5) AS filtered
FROM generate_series(1,10) AS s(i);
 unfiltered | filtered
------------+----------
         10 |        4
(1 row)
```

   

​    预定义的聚集函数在[第 9.20 节](http://www.postgres.cn/docs/13/functions-aggregate.html)中描述。其他聚集函数可以由用户增加。   

​    一个聚集表达式只能出现在`SELECT`命令的结果列表或是`HAVING`子句中。在其他子句（如`WHERE`）中禁止使用它，因为那些子句的计算在逻辑上是在聚集的结果被形成之前。   

​    当一个聚集表达式出现在一个子查询中（见[第 4.2.11 节](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-SCALAR-SUBQUERIES)和[第 9.22 节](http://www.postgres.cn/docs/13/functions-subquery.html)），聚集通常在该子查询的行上被计算。但是如果该聚集的参数（以及*`filter_clause`*，如果有）只包含外层变量则会产生一个异常：该聚集则属于最近的那个外层，并且会在那个查询的行上被计算。该聚集表达式从整体上则是对其所出现于的子查询的一种外层引用，并且在那个子查询的任意一次计算中都作为一个常量。只出现在结果列表或`HAVING`子句的限制适用于该聚集所属的查询层次。   

### 4.2.8. 窗口函数调用



​    一个*窗口函数调用*表示在一个查询选择的行的某个部分上应用一个聚集类的函数。和非窗口聚集函数调用不同，这不会被约束为将被选择的行分组为一个单一的输出行 — 在查询输出中每一个行仍保持独立。不过，窗口函数能够根据窗口函数调用的分组声明（`PARTITION BY`列表）访问属于当前行所在分组中的所有行。一个窗口函数调用的语法是下列之一：

```
function_name ([expression [, expression ... ]]) [ FILTER ( WHERE filter_clause ) ] OVER window_name
function_name ([expression [, expression ... ]]) [ FILTER ( WHERE filter_clause ) ] OVER ( window_definition )
function_name ( * ) [ FILTER ( WHERE filter_clause ) ] OVER window_name
function_name ( * ) [ FILTER ( WHERE filter_clause ) ] OVER ( window_definition )
```

​    其中*`window_definition`*的语法是

```
[ existing_window_name ]
[ PARTITION BY expression [, ...] ]
[ ORDER BY expression [ ASC | DESC | USING operator ] [ NULLS { FIRST | LAST } ] [, ...] ]
[ frame_clause ]
```

​    可选的*`frame_clause`*是下列之一

```
{ RANGE | ROWS | GROUPS } frame_start [ frame_exclusion ]
{ RANGE | ROWS | GROUPS } BETWEEN frame_start AND frame_end [ frame_exclusion ]
```

​    其中*`frame_start`*和*`frame_end`*可以是下面形式中的一种

```
UNBOUNDED PRECEDING
offset PRECEDING
CURRENT ROW
offset FOLLOWING
UNBOUNDED FOLLOWING
```

​    而*`frame_exclusion`*可以是下列之一

```
EXCLUDE CURRENT ROW
EXCLUDE GROUP
EXCLUDE TIES
EXCLUDE NO OTHERS
```

   

​    这里，*`expression`*表示任何自身不含有窗口函数调用的值表达式。   

​    *`window_name`*是对定义在查询的`WINDOW`子句中的一个命名窗口声明的引用。还可以使用在`WINDOW`子句中定义命名窗口的相同语法在圆括号内给定一个完整的*`window_definition`*，详见[SELECT](http://www.postgres.cn/docs/13/sql-select.html)参考页。值得指出的是，`OVER wname`并不严格地等价于`OVER (wname ...)`，后者表示复制并修改窗口定义，并且在被引用窗口声明包括一个帧子句时会被拒绝。   

​    `PARTITION BY`选项将查询的行分组成为*分区*，窗口函数会独立地处理它们。`PARTITION BY`工作起来类似于一个查询级别的`GROUP BY`子句，不过它的表达式总是只是表达式并且不能是输出列的名称或编号。如果没有`PARTITION BY`，该查询产生的所有行被当作一个单一分区来处理。`ORDER BY`选项决定被窗口函数处理的一个分区中的行的顺序。它工作起来类似于一个查询级别的`ORDER BY`子句，但是同样不能使用输出列的名称或编号。如果没有`ORDER BY`，行将被以未指定的顺序被处理。   

​    *`frame_clause`*指定构成*窗口帧*的行集合，它是当前分区的一个子集，窗口函数将作用在该帧而不是整个分区。帧中的行集合会随着哪一行是当前行而变化。在`RANGE`、`ROWS`或者`GROUPS`模式中可以指定帧，在每一种情况下，帧的范围都是从*`frame_start`*到*`frame_end`*。如果*`frame_end`*被省略，则末尾默认为`CURRENT ROW`。   

​    `UNBOUNDED PRECEDING`的一个*`frame_start`*表示该帧开始于分区的第一行，类似地`UNBOUNDED FOLLOWING`的一个*`frame_end`*表示该帧结束于分区的最后一行。   

​    在`RANGE`或`GROUPS`模式中，`CURRENT ROW`的一个*`frame_start`*表示帧开始于当前行的第一个*平级*行（被窗口的`ORDER BY`子句排序为与当前行等效的行），而`CURRENT ROW`的一个*`frame_end`*表示帧结束于当前行的最后一个平级行。在`ROWS`模式中，`CURRENT ROW`就表示当前行。   

​    在*`offset`* `PRECEDING`以及*`offset`* `FOLLOWING`帧选项中，*`offset`*必须是一个不包含任何变量、聚集函数或者窗口函数的表达式。*`offset`*的含义取决于帧模式：    

- ​       在`ROWS`模式中，*`offset`*必须得到一个非空、非负的整数，并且该选项表示帧开始于当前行之前或者之后指定数量的行。      
- ​       在`GROUPS`模式中，*`offset`*也必须得到一个非空、非负的整数，并且该选项表示帧开始于当前行的平级组之前或者之后指定数量的*平级组*，这里平级组是在`ORDER BY`顺序中等效的行集合（要使用`GROUPS`模式，在窗口定义中就必须有一个`ORDER BY`子句）。      
- ​       在`RANGE`模式中，这些选项要求`ORDER BY`子句正好指定一列。*`offset`*指定当前行中那一列的值与它在该帧中前面或后面的行中的列值的最大差值。*`offset`*表达式的数据类型会随着排序列的数据类型而变化。对于数字的排序列，它通常是与排序列相同的类型，但对于日期时间排序列它是一个`interval`。例如，如果排序列是类型`date`或者`timestamp`，我们可以写`RANGE BETWEEN '1 day' PRECEDING AND '10 days' FOLLOWING`。*`offset`*仍然要求是非空且非负，不过“非负”的含义取决于它的数据类型。      

​    在任何一种情况下，到帧末尾的距离都受限于到分区末尾的距离，因此对于离分区末尾比较近的行来说，帧可能会包含比较少的行。   

​    注意在`ROWS`以及`GROUPS`模式中，`0 PRECEDING`和`0 FOLLOWING`与`CURRENT ROW`等效。通常在`RANGE`模式中，这个结论也成立（只要有一种合适的、与数据类型相关的“零”的含义）。   

​    *`frame_exclusion`*选项允许当前行周围的行被排除在帧之外，即便根据帧的开始和结束选项应该把它们包括在帧中。`EXCLUDE CURRENT ROW`会把当前行排除在帧之外。`EXCLUDE GROUP`会把当前行以及它在顺序上的平级行都排除在帧之外。`EXCLUDE TIES`把当前行的任何平级行都从帧中排除，但不排除当前行本身。`EXCLUDE NO OTHERS`只是明确地指定不排除当前行或其平级行的这种默认行为。   

​    默认的帧选项是`RANGE UNBOUNDED PRECEDING`，它和`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`相同。如果使用`ORDER BY`，这会把该帧设置为从分区开始一直到当前行的最后一个`ORDER BY`平级行的所有行。如果不使用`ORDER BY`，就意味着分区中所有的行都被包括在窗口帧中，因为所有行都成为了当前行的平级行。   

​    限制是*`frame_start`*不能是`UNBOUNDED FOLLOWING`、*`frame_end`*不能是`UNBOUNDED PRECEDING`，并且在上述*`frame_start`*和*`frame_end`*选项的列表中*`frame_end`*选择不能早于*`frame_start`*选择出现 — 例如不允许`RANGE BETWEEN CURRENT ROW AND *`offset`* PRECEDING`，但允许`ROWS BETWEEN 7 PRECEDING AND 8 PRECEDING`，虽然它不会选择任何行。   

​    如果指定了`FILTER`，那么只有对*`filter_clause`*计算为真的输入行会被交给该窗口函数，其他行会被丢弃。只有是聚集的窗口函数才接受`FILTER` 。   

​    内建的窗口函数在[表 9.60](http://www.postgres.cn/docs/13/functions-window.html#FUNCTIONS-WINDOW-TABLE)中介绍。用户可以加入其他窗口函数。此外，任何内建的或者用户定义的通用聚集或者统计性聚集都可以被用作窗口函数（有序集和假想集聚集当前不能被用作窗口函数）。   

​    使用`*`的语法被用来把参数较少的聚集函数当作窗口函数调用，例如`count(*) OVER (PARTITION BY x ORDER BY y)`。星号（`*`）通常不被用于窗口相关的函数。窗口相关的函数不允许在函数参数列表中使用`DISTINCT`或`ORDER BY`。   

​    只有在`SELECT`列表和查询的`ORDER BY`子句中才允许窗口函数调用。   

​    更多关于窗口函数的信息可以在[第 3.5 节](http://www.postgres.cn/docs/13/tutorial-window.html)、[第 9.21 节](http://www.postgres.cn/docs/13/functions-window.html)以及[第 7.2.5 节](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-WINDOW)中找到。   

### 4.2.9. 类型转换



​    一个类型造型指定从一种数据类型到另一种数据类型的转换。PostgreSQL接受两种等价的类型造型语法：

```
CAST ( expression AS type )
expression::type
```

​    `CAST`语法遵从 SQL，而用`::`的语法是PostgreSQL的历史用法。   

​    当一个造型被应用到一种未知类型的值表达式上时，它表示一种运行时类型转换。只有已经定义了一种合适的类型转换操作时，该造型才会成功。注意这和常量的造型（如[第 4.1.2.7 节](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS-GENERIC)中所示）使用不同。应用于一个未修饰串文字的造型表示一种类型到一个文字常量值的初始赋值，并且因此它将对任意类型都成功（如果该串文字的内容对于该数据类型的输入语法是可接受的）。   

​    如果一个值表达式必须产生的类型没有歧义（例如当它被指派给一个表列），通常可以省略显式类型造型，在这种情况下系统会自动应用一个类型造型。但是，只有对在系统目录中被标记为“OK to apply implicitly”的造型才会执行自动造型。其他造型必须使用显式造型语法调用。这种限制是为了防止出人意料的转换被无声无息地应用。   

​    还可以用像函数的语法来指定一次类型造型：

```
typename ( expression )
```

​    不过，这只对那些名字也作为函数名可用的类型有效。例如，`double precision`不能以这种方式使用，但是等效的`float8`可以。还有，如果名称`interval`、`time`和`timestamp`被用双引号引用，那么由于语法冲突的原因，它们只能以这种风格使用。因此，函数风格的造型语法的使用会导致不一致性并且应该尽可能被避免。   

### 注意

​     函数风格的语法事实上只是一次函数调用。当两种标准造型语法之一被用来做一次运行时转换时，它将在内部调用一个已注册的函数来执行该转换。简而言之，这些转换函数具有和它们的输出类型相同的名字，并且因此“函数风格的语法”无非是对底层转换函数的一次直接调用。显然，一个可移植的应用不应当依赖于它。详见[CREATE CAST](http://www.postgres.cn/docs/13/sql-createcast.html)。    

### 4.2.10. 排序规则表达式



​    `COLLATE`子句会重载一个表达式的排序规则。它被追加到它适用的表达式：

```
expr COLLATE collation
```

​    这里*`collation`*可能是一个受模式限定的标识符。`COLLATE`子句比操作符绑得更紧，需要时可以使用圆括号。   

​    如果没有显式指定排序规则，数据库系统会从表达式所涉及的列中得到一个排序规则，如果该表达式没有涉及列，则会默认采用数据库的默认排序规则。   

​    `COLLATE`子句的两种常见使用是重载`ORDER BY`子句中的排序顺序，例如：

```
SELECT a, b, c FROM tbl WHERE ... ORDER BY a COLLATE "C";
```

​    以及重载具有区域敏感结果的函数或操作符调用的排序规则，例如：

```
SELECT * FROM tbl WHERE a > 'foo' COLLATE "C";
```

​    注意在后一种情况中，`COLLATE`子句被附加到我们希望影响的操作符的一个输入参数上。`COLLATE`子句被附加到该操作符或函数调用的哪个参数上无关紧要，因为被操作符或函数应用的排序规则是考虑所有参数得来的，并且一个显式的`COLLATE`子句将重载所有其他参数的排序规则（不过，附加非匹配`COLLATE`子句到多于一个参数是一种错误。详见[第 23.2 节](http://www.postgres.cn/docs/13/collation.html)）。因此，这会给出和前一个例子相同的结果：

```
SELECT * FROM tbl WHERE a COLLATE "C" > 'foo';
```

​    但是这是一个错误：

```
SELECT * FROM tbl WHERE (a > 'foo') COLLATE "C";
```

​    因为它尝试把一个排序规则应用到`>`操作符的结果，而它的数据类型是非可排序数据类型`boolean`。   

### 4.2.11. 标量子查询



​    一个标量子查询是一种圆括号内的普通`SELECT`查询，它刚好返回一行一列（关于书写查询可见[第 7 章](http://www.postgres.cn/docs/13/queries.html)）。`SELECT`查询被执行并且该单一返回值被使用在周围的值表达式中。将一个返回超过一行或一列的查询作为一个标量子查询使用是一种错误（但是如果在一次特定执行期间该子查询没有返回行则不是错误，该标量结果被当做为空）。该子查询可以从周围的查询中引用变量，这些变量在该子查询的任何一次计算中都将作为常量。对于其他涉及子查询的表达式还可见[第 9.22 节](http://www.postgres.cn/docs/13/functions-subquery.html)。   

​    例如，下列语句会寻找每个州中最大的城市人口：

```
SELECT name, (SELECT max(pop) FROM cities WHERE cities.state = states.name)
    FROM states;
```

   

### 4.2.12. 数组构造器



​    一个数组构造器是一个能构建一个数组值并且将值用于它的成员元素的表达式。一个简单的数组构造器由关键词`ARRAY`、一个左方括号`[`、一个用于数组元素值的表达式列表（用逗号分隔）以及最后的一个右方括号`]`组成。例如：

```
SELECT ARRAY[1,2,3+4];
  array
---------
 {1,2,7}
(1 row)
```

​    默认情况下，数组元素类型是成员表达式的公共类型，使用和`UNION`或`CASE`结构（见[第 10.5 节](http://www.postgres.cn/docs/13/typeconv-union-case.html)）相同的规则决定。你可以通过显式将数组构造器造型为想要的类型来重载，例如：

```
SELECT ARRAY[1,2,22.7]::integer[];
  array
----------
 {1,2,23}
(1 row)
```

​    这和把每一个表达式单独地造型为数组元素类型的效果相同。关于造型的更多信息请见[第 4.2.9 节](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-TYPE-CASTS)。   

​    多维数组值可以通过嵌套数组构造器来构建。在内层的构造器中，关键词`ARRAY`可以被忽略。例如，这些语句产生相同的结果：

```
SELECT ARRAY[ARRAY[1,2], ARRAY[3,4]];
     array
---------------
 {{1,2},{3,4}}
(1 row)

SELECT ARRAY[[1,2],[3,4]];
     array
---------------
 {{1,2},{3,4}}
(1 row)
```

​    因为多维数组必须是矩形的，处于同一层次的内层构造器必须产生相同维度的子数组。任何被应用于外层`ARRAY`构造器的造型会自动传播到所有的内层构造器。  

​    多维数组构造器元素可以是任何得到一个正确种类数组的任何东西，而不仅仅是一个子-`ARRAY`结构。例如：

```
CREATE TABLE arr(f1 int[], f2 int[]);

INSERT INTO arr VALUES (ARRAY[[1,2],[3,4]], ARRAY[[5,6],[7,8]]);

SELECT ARRAY[f1, f2, '{{9,10},{11,12}}'::int[]] FROM arr;
                     array
------------------------------------------------
 {{{1,2},{3,4}},{{5,6},{7,8}},{{9,10},{11,12}}}
(1 row)
```

  

   你可以构造一个空数组，但是因为无法得到一个无类型的数组，你必须显式地把你的空数组造型成想要的类型。例如：

```
SELECT ARRAY[]::integer[];
 array
-------
 {}
(1 row)
```

  

   也可以从一个子查询的结果构建一个数组。在这种形式中，数组构造器被写为关键词`ARRAY`后跟着一个加了圆括号（不是方括号）的子查询。例如：

```
SELECT ARRAY(SELECT oid FROM pg_proc WHERE proname LIKE 'bytea%');
                                 array
-----------------------------------------------------------------------
 {2011,1954,1948,1952,1951,1244,1950,2005,1949,1953,2006,31,2412,2413}
(1 row)

SELECT ARRAY(SELECT ARRAY[i, i*2] FROM generate_series(1,5) AS a(i));
              array
----------------------------------
 {{1,2},{2,4},{3,6},{4,8},{5,10}}
(1 row)
```

   子查询必须返回一个单一列。如果子查询的输出列是非数组类型，   结果的一维数组将为该子查询结果中的每一行有一个元素，   并且有一个与子查询的输出列匹配的元素类型。如果子查询的输出列   是一种数组类型，结果将是同类型的一个数组，但是要高一个维度。   在这种情况下，该子查询的所有行必须产生同样维度的数组，否则结果   就不会是矩形形式。  

   用`ARRAY`构建的一个数组值的下标总是从一开始。更多关于数组的信息，请见[第 8.15 节](http://www.postgres.cn/docs/13/arrays.html)。  

### 4.2.13. 行构造器



​    一个行构造器是能够构建一个行值（也称作一个组合类型）并用值作为其成员域的表达式。一个行构造器由关键词`ROW`、一个左圆括号、用于行的域值的零个或多个表达式（用逗号分隔）以及最后的一个右圆括号组成。例如：

```
SELECT ROW(1,2.5,'this is a test');
```

​    当在列表中有超过一个表达式时，关键词`ROW`是可选的。   

​    一个行构造器可以包括语法*`rowvalue`*`.*`，它将被扩展为该行值的元素的一个列表，就像在一个顶层`SELECT`列表（见[第 8.16.5 节](http://www.postgres.cn/docs/13/rowtypes.html#ROWTYPES-USAGE)）中使用`.*`时发生的事情一样。例如，如果表`t`有列`f1`和`f2`，那么这些是相同的：

```
SELECT ROW(t.*, 42) FROM t;
SELECT ROW(t.f1, t.f2, 42) FROM t;
```

   

### 注意

​     在PostgreSQL 8.2 以前，`.*`语法不会在行构造器中被扩展，这样写`ROW(t.*, 42)`会创建一个有两个域的行，其第一个域是另一个行值。新的行为通常更有用。如果你需要嵌套行值的旧行为，写内层行值时不要用`.*`，例如`ROW(t, 42)`。    

​    默认情况下，由一个`ROW`表达式创建的值是一种匿名记录类型。如果必要，它可以被造型为一种命名的组合类型 — 或者是一个表的行类型，或者是一种用`CREATE TYPE AS`创建的组合类型。为了避免歧义，可能需要一个显式造型。例如：

```
CREATE TABLE mytable(f1 int, f2 float, f3 text);

CREATE FUNCTION getf1(mytable) RETURNS int AS 'SELECT $1.f1' LANGUAGE SQL;

-- 不需要造型因为只有一个 getf1() 存在
SELECT getf1(ROW(1,2.5,'this is a test'));
 getf1
-------
     1
(1 row)

CREATE TYPE myrowtype AS (f1 int, f2 text, f3 numeric);

CREATE FUNCTION getf1(myrowtype) RETURNS int AS 'SELECT $1.f1' LANGUAGE SQL;

-- 现在我们需要一个造型来指示要调用哪个函数：
SELECT getf1(ROW(1,2.5,'this is a test'));
ERROR:  function getf1(record) is not unique

SELECT getf1(ROW(1,2.5,'this is a test')::mytable);
 getf1
-------
     1
(1 row)

SELECT getf1(CAST(ROW(11,'this is a test',2.5) AS myrowtype));
 getf1
-------
    11
(1 row)
```

  

   行构造器可以被用来构建存储在一个组合类型表列中的组合值，或者被传递给一个接受组合参数的函数。还有，可以比较两个行值，或者用`IS NULL`或`IS NOT NULL`测试一个行，例如：

```
SELECT ROW(1,2.5,'this is a test') = ROW(1, 3, 'not the same');

SELECT ROW(table.*) IS NULL FROM table;  -- detect all-null rows
```

   详见[第 9.23 节](http://www.postgres.cn/docs/13/functions-comparisons.html)。如[第 9.22 节](http://www.postgres.cn/docs/13/functions-subquery.html)中所讨论的，行构造器也可以被用来与子查询相连接。  

### 4.2.14. 表达式计算规则



​    子表达式的计算顺序没有被定义。特别地，一个操作符或函数的输入不必按照从左至右或其他任何固定顺序进行计算。   

​    此外，如果一个表达式的结果可以通过只计算其一部分来决定，那么其他子表达式可能完全不需要被计算。例如，如果我们写：

```
SELECT true OR somefunc();
```

​    那么`somefunc()`将（可能）完全不被调用。如果我们写成下面这样也是一样：

```
SELECT somefunc() OR true;
```

​    注意这和一些编程语言中布尔操作符从左至右的“短路”不同。   

​    因此，在复杂表达式中使用带有副作用的函数是不明智的。在`WHERE`和`HAVING`子句中依赖副作用或计算顺序尤其危险，因为在建立一个执行计划时这些子句会被广泛地重新处理。这些子句中布尔表达式（`AND`/`OR`/`NOT`的组合）可能会以布尔代数定律所允许的任何方式被重组。   

​    当有必要强制计算顺序时，可以使用一个`CASE`结构（见[第 9.17 节](http://www.postgres.cn/docs/13/functions-conditional.html)）。例如，在一个`WHERE`子句中使用下面的方法尝试避免除零是不可靠的：

```
SELECT ... WHERE x > 0 AND y/x > 1.5;
```

​    但是这是安全的：

```
SELECT ... WHERE CASE WHEN x > 0 THEN y/x > 1.5 ELSE false END;
```

​    一个以这种风格使用的`CASE`结构将使得优化尝试失败，因此只有必要时才这样做（在这个特别的例子中，最好通过写`y > 1.5*x`来回避这个问题）。   

​    不过，`CASE`不是这类问题的万灵药。上述技术的一个限制是，    它无法阻止常量子表达式的提早计算。如[第 37.7 节](http://www.postgres.cn/docs/13/xfunc-volatility.html)    中所述，当查询被规划而不是被执行时，被标记成    `IMMUTABLE`的函数和操作符可以被计算。因此

```
SELECT CASE WHEN x > 0 THEN x ELSE 1/0 END FROM tab;
```

​    很可能会导致一次除零失败，因为规划器尝试简化常量子表达式。即便是    表中的每一行都有`x > 0`（这样运行时永远不会进入到    `ELSE`分支）也是这样。   

​    虽然这个特别的例子可能看起来愚蠢，没有明显涉及常量的情况可能会发生    在函数内执行的查询中，因为因为函数参数的值和本地变量可以作为常量    被插入到查询中用于规划目的。例如，在PL/pgSQL函数    中，使用一个`IF`-`THEN`-`ELSE`语句来    保护一种有风险的计算比把它嵌在一个`CASE`表达式中要安全得多。   

​    另一个同类型的限制是，一个`CASE`无法阻止其所包含的聚集表达式    的计算，因为在考虑`SELECT`列表或`HAVING`子句中的    其他表达式之前，会先计算聚集表达式。例如，下面的查询会导致一个除零错误，    虽然看起来好像已经这种情况加以了保护：

```
SELECT CASE WHEN min(employees) > 0
            THEN avg(expenses / employees)
       END
    FROM departments;
```

​    `min()`和`avg()`聚集会在所有输入行上并行地计算，    因此如果任何行有`employees`等于零，在有机会测试    `min()`的结果之前，就会发生除零错误。取而代之的是，可以使用    一个`WHERE`或`FILTER`子句来首先阻止有问题的输入行到达    一个聚集函数。   

## 4.3. 调用函数

- [4.3.1. 使用位置记号](http://www.postgres.cn/docs/13/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-POSITIONAL)
- [4.3.2. 使用命名记号](http://www.postgres.cn/docs/13/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED)
- [4.3.3. 使用混合记号](http://www.postgres.cn/docs/13/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-MIXED)



​    PostgreSQL允许带有命名参数的函数被使用*位置*或*命名*记号法调用。命名记号法对于有大量参数的函数特别有用，因为它让参数和实际参数之间的关联更明显和可靠。在位置记号法中，书写一个函数调用时，其参数值要按照它们在函数声明中被定义的顺序书写。在命名记号法中，参数根据名称匹配函数参数，并且可以以任何顺序书写。对于每一种记法，还要考虑函数参数类型的效果，这些在[第 10.3 节](http://www.postgres.cn/docs/13/typeconv-func.html)有介绍。   

​    在任意一种记号法中，在函数声明中给出了默认值的参数根本不需要在调用中写出。但是这在命名记号法中特别有用，因为任何参数的组合都可以被忽略。而在位置记号法中参数只能从右往左忽略。   

​    PostgreSQL也支持*混合*记号法，它组合了位置和命名记号法。在这种情况中，位置参数被首先写出并且命名参数出现在其后。   

​    下列例子将展示所有三种记号法的用法：

```
CREATE FUNCTION concat_lower_or_upper(a text, b text, uppercase boolean DEFAULT false)
RETURNS text
AS
$$
 SELECT CASE
        WHEN $3 THEN UPPER($1 || ' ' || $2)
        ELSE LOWER($1 || ' ' || $2)
        END;
$$
LANGUAGE SQL IMMUTABLE STRICT;
```

​    函数`concat_lower_or_upper`有两个强制参数，`a`和`b`。此外，有一个可选的参数`uppercase`，其默认值为`false`。`a`和`b`输入将被串接，并且根据`uppercase`参数被强制为大写或小写形式。这个函数的剩余细节对这里并不重要（详见[第 37 章](http://www.postgres.cn/docs/13/extend.html)）。   

### 4.3.1. 使用位置记号



​     在PostgreSQL中，位置记号法是给函数传递参数的传统机制。一个例子：

```
SELECT concat_lower_or_upper('Hello', 'World', true);
 concat_lower_or_upper 
-----------------------
 HELLO WORLD
(1 row)
```

​     所有参数被按照顺序指定。结果是大写形式，因为`uppercase`被指定为`true`。另一个例子：

```
SELECT concat_lower_or_upper('Hello', 'World');
 concat_lower_or_upper 
-----------------------
 hello world
(1 row)
```

​     这里，`uppercase`参数被忽略，因此它接收它的默认值`false`，并导致小写形式的输出。在位置记号法中，参数可以按照从右往左被忽略并且因此而得到默认值。    

### 4.3.2. 使用命名记号



​     在命名记号法中，每一个参数名都用`=>`     指定来把它与参数表达式分隔开。例如：

```
SELECT concat_lower_or_upper(a => 'Hello', b => 'World');
 concat_lower_or_upper 
-----------------------
 hello world
(1 row)
```

​     再次，参数`uppercase`被忽略，因此它被隐式地设置为`false`。使用命名记号法的一个优点是参数可以用任何顺序指定，例如：

```
SELECT concat_lower_or_upper(a => 'Hello', b => 'World', uppercase => true);
 concat_lower_or_upper 
-----------------------
 HELLO WORLD
(1 row)

SELECT concat_lower_or_upper(a => 'Hello', uppercase => true, b => 'World');
 concat_lower_or_upper 
-----------------------
 HELLO WORLD
(1 row)
```

​    

​      为了向后兼容性，基于 ":=" 的旧语法仍被支持：

```
SELECT concat_lower_or_upper(a := 'Hello', uppercase := true, b := 'World');
 concat_lower_or_upper 
-----------------------
 HELLO WORLD
(1 row)
```

​    

### 4.3.3. 使用混合记号



​    混合记号法组合了位置和命名记号法。不过，正如已经提到过的，命名参数不能超越位置参数。例如：

```
SELECT concat_lower_or_upper('Hello', 'World', uppercase => true);
 concat_lower_or_upper 
-----------------------
 HELLO WORLD
(1 row)
```

​    在上述查询中，参数`a`和`b`被以位置指定，而`uppercase`通过名字指定。在这个例子中，这只增加了一点文档。在一个具有大量带默认值参数的复杂函数中，命名的或混合的记号法可以节省大量的书写并且减少出错的机会。   

### 注意

​     命名的和混合的调用记号法当前不能在调用聚集函数时使用（但是当聚集函数被用作窗口函数时它们可以被使用）。    

## 第 5 章 数据定义

**目录**

- [5.1. 表基础](http://www.postgres.cn/docs/13/ddl-basics.html)

- [5.2. 默认值](http://www.postgres.cn/docs/13/ddl-default.html)

- [5.3. 生成列](http://www.postgres.cn/docs/13/ddl-generated-columns.html)

- [5.4. 约束](http://www.postgres.cn/docs/13/ddl-constraints.html)

  [5.4.1. 检查约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-CHECK-CONSTRAINTS)[5.4.2. 非空约束](http://www.postgres.cn/docs/13/ddl-constraints.html#id-1.5.4.6.6)[5.4.3. 唯一约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS)[5.4.4. 主键](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-PRIMARY-KEYS)[5.4.5. 外键](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-FK)[5.4.6. 排他约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-EXCLUSION)

- [5.5. 系统列](http://www.postgres.cn/docs/13/ddl-system-columns.html)

- [5.6. 修改表](http://www.postgres.cn/docs/13/ddl-alter.html)

  [5.6.1. 增加列](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-ADDING-A-COLUMN)[5.6.2. 移除列](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-REMOVING-A-COLUMN)[5.6.3. 增加约束](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-ADDING-A-CONSTRAINT)[5.6.4. 移除约束](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-REMOVING-A-CONSTRAINT)[5.6.5. 更改列的默认值](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.9)[5.6.6. 修改列的数据类型](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.10)[5.6.7. 重命名列](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.11)[5.6.8. 重命名表](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.12)

- [5.7. 权限](http://www.postgres.cn/docs/13/ddl-priv.html)

- [5.8. 行安全性策略](http://www.postgres.cn/docs/13/ddl-rowsecurity.html)

- [5.9. 模式](http://www.postgres.cn/docs/13/ddl-schemas.html)

  [5.9.1. 创建模式](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-CREATE)[5.9.2. 公共模式](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-PUBLIC)[5.9.3. 模式搜索路径](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-PATH)[5.9.4. 模式和权限](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-PRIV)[5.9.5. 系统目录模式](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-CATALOG)[5.9.6. 使用模式](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-PATTERNS)[5.9.7. 可移植性](http://www.postgres.cn/docs/13/ddl-schemas.html#DDL-SCHEMAS-PORTABILITY)

- [5.10. 继承](http://www.postgres.cn/docs/13/ddl-inherit.html)

  [5.10.1. 警告](http://www.postgres.cn/docs/13/ddl-inherit.html#DDL-INHERIT-CAVEATS)

- [5.11. 表分区](http://www.postgres.cn/docs/13/ddl-partitioning.html)

  [5.11.1. 概述](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITIONING-OVERVIEW)[5.11.2. 声明式划分](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITIONING-DECLARATIVE)[5.11.3. 使用继承实现](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITIONING-IMPLEMENTATION-INHERITANCE)[5.11.4. 分区剪枝](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITION-PRUNING)[5.11.5. 分区和约束排除](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITIONING-CONSTRAINT-EXCLUSION)[5.11.6. 声明分区最佳实践](http://www.postgres.cn/docs/13/ddl-partitioning.html#DDL-PARTITIONING-DECLARATIVE-BEST-PRACTICES)

- [5.12. 外部数据](http://www.postgres.cn/docs/13/ddl-foreign-data.html)

- [5.13. 其他数据库对象](http://www.postgres.cn/docs/13/ddl-others.html)

- [5.14. 依赖跟踪](http://www.postgres.cn/docs/13/ddl-depend.html)

  本章包含了如何创建用来保存数据的数据库结构。在一个关系型数据库中，原始数据被存储在表中，因此本章的主要工作就是解释如何创建和修改表，以及哪些特性可以控制何种数据会被存储在表中。接着，我们讨论表如何被组织成模式，以及如何将权限分配给表。最后，我们将将简短地介绍其他一些影响数据存储的特性，例如继承、表分区、视图、函数和触发器。 