### YAML 语言

#### YAMl 语言介绍

YAML是一个可读性高的用来表达资料序列的格式。YAML参考了其他多种语言，包括：XML、C语言、Python、Perl以及电子邮件格式RFC2822等。Clark Evans在2001年在首次发表了这种语言，另外Ingy döt Net与Oren  Ben-Kiki也是这语言的共同设计者,目前很多软件中采有此格式的文件，如:ubuntu，anisble，docker，k8s等
 YAML：YAML Ain’t Markup Language，即YAML不是XML。不过，在开发的这种语言时，YAML的意思其实是："Yet Another Markup Language"（仍是一种标记语言）

YAML 官方网站：[http://www.yaml.org](http://www.yunweipai.com/go?_=f2fb54694baHR0cDovL3d3dy55YW1sLm9yZw==)

#### YAML 语言特性

- YAML的可读性好
- YAML和脚本语言的交互性好
- YAML使用实现语言的数据类型
- YAML有一个一致的信息模型
- YAML易于实现
- YAML可以基于流来处理
- YAML表达能力强，扩展性好

#### YAML语法简介

- 在单一文件第一行，用连续三个连字号“-” 开始，还有选择性的连续三个点号( … )用来表示文件的结尾
- 次行开始正常写Playbook的内容，一般建议写明该Playbook的功能
- 使用#号注释代码
- 缩进必须是统一的，不能空格和tab混用
- 缩进的级别也必须是一致的，同样的缩进代表同样的级别，程序判别配置的级别是通过缩进结合换行来实现的
  YAML文件内容是区别大小写的，key/value的值均需大小写敏感
- 多个key/value可同行写也可换行写，同行使用，分隔
- v可是个字符串，也可是另一个列表
- 一个完整的代码块功能需最少元素需包括 name 和 task
- 一个name只能包括一个task
- YAML文件扩展名通常为yml或yaml

YAML的语法和其他高阶语言类似，并且可以简单表达清单、散列表、标量等数据结构。其结构（Structure）通过空格来展示，序列（Sequence）里的项用"-"来代表，Map里的键值对用":"分隔，下面介绍常见的数据结构。

##### List列表

列表由多个元素组成，每个元素放在不同行，且元素前均使用“-”打头，或者将所有元素用 [  ] 括起来放在同一行
 范例：

```
# A list of tasty fruits
- Apple
- Orange
- Strawberry
- Mango

[Apple,Orange,Strawberry,Mango]
```

##### Dictionary字典

字典由多个key与value构成，key和value之间用 ：分隔，所有k/v可以放在一行，或者每个 k/v 分别放在不同行

范例：

```yaml
# An employee record
name: Example Developer
job: Developer
skill: Elite
也可以将key:value放置于{}中进行表示，用,分隔多个key:value

# An employee record
{name: “Example Developer”, job: “Developer”, skill: “Elite”}
```

YAML

范例：

```yaml
name: John Smith
age: 41
gender: Male
spouse:
  name: Jane Smith
  age: 37
  gender: Female
children:
  - name: Jimmy Smith
    age: 17
    gender: Male
  - name: Jenny Smith
    age 13
    gender: Female
```

YAML

#### 三种常见的数据格式

- XML：Extensible Markup Language，可扩展标记语言，可用于数据交换和配置
- JSON：JavaScript Object Notation, JavaScript 对象表记法，主要用来数据交换或配置，不支持注释
- YAML：YAML Ain’t Markup Language  YAML 不是一种标记语言， 主要用来配置，大小写敏感，不支持tab

![Ansible-list-Dictionary-数据格式插图](http://www.yunweipai.com/wp-content/uploads/2020/06/image-20191102190516045-780x255.png)

**可以用工具互相转换，参考网站：**

[https://www.json2yaml.com/](http://www.yunweipai.com/go?_=60bb30fe06aHR0cHM6Ly93d3cuanNvbjJ5YW1sLmNvbS8=)

[http://www.bejson.com/json/json2yaml/](http://www.yunweipai.com/go?_=07b1ecff68aHR0cDovL3d3dy5iZWpzb24uY29tL2pzb24vanNvbjJ5YW1sLw==)

