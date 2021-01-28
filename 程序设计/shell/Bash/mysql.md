# 读写MySQL数据库

示例问题：
有一个包含多个系的学生详细信息的CSV文件。要将文件的内容插入到一个数据表中。要保证为每一个系生成一个单独的排名列表。

要处理MySQL数据库，系统中必须安装mysql-server和mysql-client软件包。Linux发行版并没有默认包含这些工具。由于MySQL要使用用户名和密码进行认证，因此你得有用户名和密码才能运行脚本。

前面提出的问题可以用sort、awk等Bash工具解决，或者用一个SQL数据库的数据表也可以搞定。我们接下来要编写3个脚本，分别用于创建数据库及数据表、向数据表中插入学生数据、从

数据表中读取并显示处理过的数据。
创建数据库及数据表的脚本如下

```bash
#!/bin/bash
#文件名: create_db.sh
#用途:创建MySQL数据库和数据表
USER="user"
PASS="user"
mysql -u $USER -p $PASS ＜＜EOF 2＞ /dev/null
CREATE DATABASE students;
EOF
[ $? -eq 0 ] && echo Created DB || echo DB already exist
mysql -u $USER -p $PASS students ＜＜EOF 2＞ /dev/null
CREATE TABLE students(
id int,
name varchar(100),
mark int,
dept varchar(4)
);
EOF
[ $? -eq 0 ] && echo Created table students || echo Table students
already exist
mysql -u $USER -p $PASS students ＜＜EOF
DELETE FROM students;
EOF
```

将数据插入数据表的脚本

```bash
#!/bin/bash
#文件名: write_to_db.sh
#用途: 从CSV中读取数据并写入MySQLdb
USER="user"
PASS="user"
if [ $# -ne 1 ];
then
echo $0 DATAFILE
echo
exit 2
fi
data= $1
while read line;
do
oldIFS= $IFS
IFS=,
values=( $line)
values[1]="\"`echo ${values[1]} | tr ' ' '#' `\""
values[3]="\"`echo ${values[3]}`\""
query=`echo ${values[@]} | tr ' #' ', ' `
IFS= $oldIFS
mysql -u $USER -p $PASS students ＜＜EOF
INSERT INTO students VALUES( $query);
EOF
done＜ $data
echo Wrote data into DB
```

查询数据库的脚本

```bash
#!/bin/bash
#文件名: read_db.sh
#用途:从数据库中读取数据
USER="user"
PASS="user"
depts=`mysql -u $USER -p $PASS students ＜＜EOF | tail -n +2
SELECT DISTINCT dept FROM students;
EOF`

for d in $depts;
do
echo Department : $d
result="`mysql -u $USER -p $PASS students ＜＜EOF
set @i:=0;
SELECT @i:=@i+1 as rank,name,mark FROM students WHERE dept=" $d" ORDERBY mark DESC;
EOF`"
echo " $result"
echo
done
```

作为输入的CSV文件（studentdata.csv）中的数据如下：

```bash
1,Navin M,98,CS
2,Kavya N,70,CS
3,Nawaz O,80,CS
4,Hari S,80,EC
5,Alex M,50,EC
6,Neenu J,70,EC
7,Bob A,30,EC
8,Anu M,90,AE
9,Sruthi,89,AE
10,Andrew,89,AE
```

按照以下顺序执行脚本

```bash
./create_db.sh
Created DB
Created table students

./write_to_db.sh studentdat.csv
Wrote data into DB

./read_db.sh
Department : CS
rank name mark
1 Navin M 98
2 Nawaz O 80
3 Kavya N 70
Department : EC
rank name mark
1 Hari S 80
2 Neenu J 70
3 Alex M 50
4 Bob A 30
Department : AE
rank name mark
1 Anu M 90
2 Sruthi 89
3 Andrew 89
```


我们现在来逐个讲解上面的脚本。第一个脚本create_db.sh用来创建数据库students，并在其中创建数据表students。我们需要MySQL的用户名和密码来访问或修改数据库中的内容。变量USER和PASS用来存储用户名和密码。mysql命令用于对MySQL进行操作。mysql命令可以用-u指定用户名，用-pPASSWORD指定密码，其他命令参数是数据库名。如果将数据库名作为mysql命令的参数，那么就将使用该数据库，否则我们必须用use database_name明确地指定SQL查询语句使用哪一个数据库进行查询。mysqla命令通过标准输入（stdin）接受查询。通过stdin提供多行输入的简便方法是使用＜＜EOF。出现在＜＜EOF和EOF之间的文本被作

为mysql的标准输入。在CREATE DATABASE语句中，为了避免显示错误信息，我们将stderr重定向到 /dev/null。同样，在创建数据表时，我们也将stderr重定向到 /dev/null，以忽略可能出现的任何错误。然后我们用退出状态变量  $?来检查mysql命令的退出状态，以获知是否已经存在同名的数据库或数据表。如果已经存在，则会显示出一条提示信息；否则，就进行创建。
接下来的脚本write_to_db.sh接受包含学生数据的CSV文件名。我们用while循环读取CSV文件的每一行，所以在每次迭代中都会接收到一行以逗号分隔的数值。然后我们需要将行内的数值放入SQL查询语句中。要实现这个目的，最简单的方法是用数组存储CSV文件行中的数据项。我们知道数组赋值的形式为array=(val1 val2 val3)，其中内部字段分隔符（IFS）是空格。我们的文本行用逗号分隔数值，因此只需要将IFS修改成逗号（IFS=,），我们就可以轻松地赋值给数组。文本行中以逗号分隔的数据项分别是id、name、mark和department。id和mark是整数，而name和department是字符串（字符串必须进行引用）。name中也可以包含空格。这样一来就和IFS产生了冲突。因此我们应该将name中的空格替换成其他字符（#），在构建查询语句时再替换回来。为了引用字符串，数组中的值要加上 \" 作为前缀和后缀。tr用来将name中的空格替换成#。最后通过将空格替换成逗号，将#替换成空格来构造出查询语句并进行查询。
第三个脚本read_db.sh用来查找各系并打印出每个系的学生排名列表。第一个查询用来找出各系的名称。我们用一个while循环对每个系进行迭代，然后进行查询并按照成绩从高到低的顺序显示学生的详细信息。set@i:=0是一个SQL构件（SQL construct），用来设置变量i=0。在每一行中，变量i都会进行增加并作为学生排名来显示。