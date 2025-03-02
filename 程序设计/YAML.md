# YAML

[TOC]

## 简介



```
YAML Frameworks and Tools:
  C/C++:
  - libfyaml      # "C" YAML 1.2 processor (YTS)
  - libyaml       # "C" Fast YAML 1.1 (YTS)
  - libcyaml      # YAML de/serialization of C data (using libyaml)
  - yaml-cpp      # C++ YAML 1.2 implementationYAML 测试矩阵：matrix.yaml.io

YAML 框架和工具：
C/C++：
- libfyaml # “C” YAML 1.2 处理器 （YTS）
- libyaml # “C” 快速 YAML 1.1 （YTS）
- libcyaml # C 数据的 YAML 去/序列化（使用 libyaml）
- yaml-cpp # C++ YAML 1.2 实现  Crystal:
  - YAML          # YAML 1.1 from the standard library水晶：
- 来自标准库的 YAML # YAML 1.1  C#/.NET:
  - YamlDotNet    # YAML 1.1/(1.2) library + serialization (YTS)
  - yaml-net      # YAML 1.1 libraryC#/.NET：
- YamlDotNet # YAML 1.1/（1.2） 库 + 序列化 （YTS）
- yaml-net # YAML 1.1 库  D:
  - D-YAML        # YAML 1.1 library w/ official community support (YTS)D：
- D-YAML # YAML 1.1 库，带官方社区支持 （YTS）  Dart:
  - yaml          # YAML package for Dart飞镖：
- yaml # Dart 的 YAML 包  Delphi:
  - Neslib.Yaml   # YAML 1.1 Delphi binding to libyaml (YTS)德尔菲：
- Neslib.Yaml # YAML 1.1 Delphi 绑定到 libyaml （YTS）  Elixir:
  - yaml-elixir   # YAML support for the Elixir language长生不老药：
- yaml-elixir # YAML 对 Elixir 语言的支持  Erlang:
  - yamerl        # YAML support for the Erlang languageErlang：
- yamerl # YAML 对 Erlang 语言的支持  Golang:
  - Go-yaml       # YAML support for the Go language
  - Go-gypsy      # Simplified YAML parser written in Go
  - goccy/go-yaml # YAML 1.2 implementation in pure GoGolang 的：
- Go-yaml # YAML 对 Go 语言的支持
- Go-gypsy # 用 Go 编写的简化 YAML 解析器
- goccy/go-yaml # 纯 Go 中的 YAML 1.2 实现  Haskell:
  - HsYAML         # YAML 1.2 implementation in pure Haskell (YTS)
  - YamlReference  # Haskell 1.2 reference parser
  - yaml           # YAML 1.1 Haskell framework (based on libyaml)哈斯克尔：
- HsYAML # 纯 Haskell （YTS） 中的 YAML 1.2 实现
- YamlReference # Haskell 1.2 参考解析器
- yaml # YAML 1.1 Haskell 框架（基于 libyaml）  Java:
  - SnakeYAML Engine  # Java 8+ / YAML 1.2
  - SnakeYAML         # Java 5 / YAML 1.1
  - YamlBeans         # To/from JavaBeans. YAML 1.0/1.1
  - eo-yaml           # YAML 1.2 for Java 8. Packaged as a Module (Java 9+)
  - Chronicle-Wire    # Java Implementation爪哇：
- SnakeYAML 引擎 # Java 8+ / YAML 1.2
- SnakeYAML # Java 5 / YAML 1.1
- YamlBeans # 到 JavaBeans 或从 JavaBeans 返回。YAML 1.0/1.1 版本
- eo-yaml # 适用于 Java 8 的 YAML 1.2。打包为模块 （Java 9+）
- Chronicle-Wire # Java 实现  JavaScript:
  - yaml          # JavaScript parser/stringifier (YAML 1.2, 1.1) (YTS)
  - js-yaml       # Native PyYAML port to JavaScript (Demo)JavaScript的 JavaScript：
- yaml # JavaScript 解析器/字符串生成器 （YAML 1.2， 1.1） （YTS）
- js-yaml # 将 PyYAML 原生移植到 JavaScript（演示）  Nim:
  - NimYAML       # YAML 1.2 implementation in pure Nim (YTS)尼姆：
- 纯 Nim 中的 NimYAML # YAML 1.2 实现 （YTS）  OCaml:
  - ocaml-yaml    # YAML 1.1/1.2 via libyaml bindings
  - ocaml-syck    # YAML 1.0 via syck bindingsOCaml：
- ocaml-yaml # YAML 1.1/1.2 通过 libyaml 绑定
- ocaml-syck # YAML 1.0 通过 syck 绑定  Perl Modules:
  - YAML          # Pure Perl YAML 1.0 Module
  - YAML::XS      # Binding to libyaml
  - YAML::Syck    # Binding to libsyck
  - YAML::Tiny    # A small YAML subset module
  - YAML::PP      # A YAML 1.2/1.1 processor (YTS)Perl 模块：
- YAML # 纯 Perl YAML 1.0 模块
- YAML：：XS # 绑定到 libyaml
- YAML：：Syck # 绑定到 libsyck
- YAML：：Tiny # 一个小的 YAML 子集模块
- YAML：:P P # 一个 YAML 1.2/1.1 处理器 （YTS）  PHP:
  - The Yaml Component  # Symfony Yaml Component (YAML 1.2)
  - php-yaml      # libyaml bindings (YAML 1.1)
  - syck          # syck bindings (YAML 1.0)
  - spyc          # yaml loader/dumper (YAML 1.?)PHP的：
- Yaml 组件 # Symfony Yaml 组件 （YAML 1.2）
- php-yaml # libyaml 绑定 （YAML 1.1）
- syck # syck 绑定 （YAML 1.0）
- spyc # yaml 加载器/转储器 （YAML 1.？）  Python:
  - PyYAML        # YAML 1.1, pure python and libyaml binding
  - ruamel.yaml   # YAML 1.2, update of PyYAML; comments round-trip
  - PySyck        # YAML 1.0, syck binding
  - strictyaml    # Restricted YAML subset蟒蛇：
- PyYAML # YAML 1.1，纯 python 和 libyaml 绑定
- ruamel.yaml # YAML 1.2，PyYAML 更新;评论往返
- PySyck # YAML 1.0，syck 绑定
- strictyaml # 受限 YAML 子集  R:
  - R YAML        # libyaml wrapperR：
- R YAML # libyaml 包装器  Raku:
  - YAMLish       # Port of YAMLish to Raku
  - YAML::Parser::LibYAML  # LibYAML wrapper乐：
- YAMLish # YAMLish 到 Raku 的港口
- YAML：:P arser：：LibYAML # LibYAML 包装器  Ruby:
  - psych         # libyaml wrapper (in Ruby core for 1.9.2)
  - RbYaml        # YAML 1.1 (PyYAML Port)
  - yaml4r        # YAML 1.0, standard library syck binding红宝石：
- psych # libyaml 包装器（在 1.9.2 的 Ruby 核心中）
- RbYaml # YAML 1.1（PyYAML 移植）
- yaml4r # YAML 1.0，标准库 syck 绑定  Rust:
  - yaml-rust     # YAML 1.2 implementation in pure Rust
  - serde-yaml    # YAML de/serialization of structs锈：
- yaml-rust # 纯 Rust 中的 YAML 1.2 实现
- serde-yaml # 结构体的 YAML 去/序列化  Shell:
  - parse_yaml    # Simple YAML parser for Bash using sed and awk
  - shyaml        # Read YAML files - jq style壳：
- parse_yaml # 使用 sed 和 awk 的 Bash 的简单 YAML 解析器
- shyaml # 读取 YAML 文件 - jq 样式  Swift:
  - Yams          # libyaml wrapper斯威夫特：
- Yams # libyaml 包装器  Others:
  - yamlvim       # YAML dumper/emitter in pure vimscript其他：
- yamlvim # 纯 vimscript 中的 YAML dumper/emitterRelated Projects:
  - Rx            # Multi-Language Schemata Tool for JSON/YAML
  - Kwalify       # Ruby Schemata Tool for JSON/YAML 
  - pyKwalify     # Python Schemata Tool for JSON/YAML
  - yatools.net   # Visual Studio editor for YAML
  - JSON          # Official JSON Website
  - Pygments      # Python language Syntax Colorizer /w YAML support
  - yamllint      # YAML Linter based on PyYAML
  - YAML Diff     # Semantically compare two YAML documents
  - JSON Schema   # YAML-compliant JSON standard for data validation

# Edit This Website
...
相关项目：
- rx # 用于 JSON/YAML 的多语言 schemata 工具
- kwalify # 用于 JSON/YAML 的 Ruby Schemata 工具
- pyKwalify # 用于 JSON/YAML 的 Python Schemata 工具
- yatools.net # 用于 YAML 的 Visual Studio 编辑器
- JSON # JSON 官方网站
- Pygments # Python 语言语法着色器 /w YAML 支持
- yamllint # 基于 PyYAML 的 YAML Linter
- YAML Diff # 语义上比较两个 YAML 文档
- JSON 架构 # 符合 YAML 标准的 JSON 标准，用于数据验证
```

YAML™（与 “camel” 押韵）是一种人类友好的、跨语言的、基于 Unicode 的数据序列化语言，围绕动态编程语言的常见原生数据类型设计。它广泛适用于从配置文件到 Internet 消息收发、对象持久性、数据审计和可视化等编程需求。

YAML 是一种适用于所有编程语言的人性化数据序列化语言。

YAML 是一个可读性高的用来表达资料序列的格式。YAML 参考了其他多种语言，包括：XML、C、Python、Perl 以及电子邮件格式 RFC2822 等。Clark Evans 在2001 年在首次发表了这种语言，另外 Ingy döt Net 与 Oren  Ben-Kiki 也是这语言的共同设计者。目前很多软件中采有此格式的文件，如 ubuntu，anisble，docker，k8s 等。

YAML：YAML Ain’t Markup Language，即 YAML 不是 XML 。不过，在开发的这种语言时，YAML 的意思其实是："Yet Another Markup Language"（仍是一种标记语言）

官方网站：[http://www.yaml.org](http://www.yunweipai.com/go?_=f2fb54694baHR0cDovL3d3dy55YW1sLm9yZw==)

### 语言特性

- YAML 的可读性好。
- YAML 和脚本语言的交互性好
- YAML 使用实现语言的数据类型
- YAML 有一个一致的模型支持通用工具。
- YAML 易于实现和使用。
- YAML 可以基于流来处理
- YAML 表达能力强，扩展性好。
- YAML 数据应该可以在编程语言之间移植。
- YAML should match the [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) of dynamic languages.
  YAML 应与动态语言的[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)匹配。
- YAML should support one-pass processing.
  YAML 支持一次性处理。

### 语法简介

- 在单一文件第一行，用连续三个连字号“-” 开始，还有选择性的连续三个点号( … )用来表示文件的结尾
- 次行开始正常写Playbook的内容，一般建议写明该Playbook的功能
- 使用 # 号注释代码
- 缩进必须是统一的，不能空格和tab混用
- 缩进的级别也必须是一致的，同样的缩进代表同样的级别，程序判别配置的级别是通过缩进结合换行来实现的
- YAML文件内容是区别大小写的，key/value的值均需大小写敏感
- 多个key/value可同行写也可换行写，同行使用，分隔
- v可是个字符串，也可是另一个列表
- 一个完整的代码块功能需最少元素需包括 name 和 task
- 一个name只能包括一个task
- YAML文件扩展名通常为yml或yaml

YAML的语法和其他高阶语言类似，并且可以简单表达清单、散列表、标量等数据结构。其结构（Structure）通过空格来展示，序列（Sequence）里的项用"-"来代表，Map里的键值对用":"分隔。

#### List列表

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

#### Dictionary字典

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

## 三种常见的数据格式

- XML：Extensible Markup Language，可扩展标记语言，可用于数据交换和配置。
- JSON：JavaScript Object Notation, JavaScript 对象表记法，主要用来数据交换或配置，不支持注释。
- YAML：YAML Ain’t Markup Language  YAML 不是一种标记语言， 主要用来配置，大小写敏感，不支持 tab 。

 ![](http://www.yunweipai.com/wp-content/uploads/2020/06/image-20191102190516045-780x255.png)

**可以用工具互相转换，参考网站：**

[https://www.json2yaml.com/](http://www.yunweipai.com/go?_=60bb30fe06aHR0cHM6Ly93d3cuanNvbjJ5YW1sLmNvbS8=)

[http://www.bejson.com/json/json2yaml/](http://www.yunweipai.com/go?_=07b1ecff68aHR0cDovL3d3dy5iZWpzb24uY29tL2pzb24vanNvbjJ5YW1sLw==)





- Chapter 1. Introduction to YAML
  第 1 章.YAML 简介
  - [1.1. Goals 1.1. 目标](https://yaml.org/spec/1.2.2/#11-goals)
  - [1.2. YAML History 1.2. YAML 历史](https://yaml.org/spec/1.2.2/#12-yaml-history)
  - [1.3. Terminology 1.3. 术语](https://yaml.org/spec/1.2.2/#13-terminology)
- Chapter 2. Language Overview
  第 2 章.语言概述
  - [2.1. Collections 2.1. 集合](https://yaml.org/spec/1.2.2/#21-collections)
  - [2.2. Structures 2.2. 结构](https://yaml.org/spec/1.2.2/#22-structures)
  - [2.3. Scalars 2.3. 标量](https://yaml.org/spec/1.2.2/#23-scalars)
  - [2.4. Tags 2.4. 标签](https://yaml.org/spec/1.2.2/#24-tags)
  - [2.5. Full Length Example 2.5. 全长示例](https://yaml.org/spec/1.2.2/#25-full-length-example)
- Chapter 3. Processes and Models
  第 3 章.流程和模型
  - 3.1. Processes 3.1. 进程
    - [3.1.1. Dump 3.1.1. 转储](https://yaml.org/spec/1.2.2/#311-dump)
    - [3.1.2. Load 3.1.2. 加载](https://yaml.org/spec/1.2.2/#312-load)
  - 3.2. Information Models 3.2. 信息模型
    - 3.2.1. Representation Graph
      3.2.1. 表示图
      - [3.2.1.1. Nodes 3.2.1.1. 节点](https://yaml.org/spec/1.2.2/#3211-nodes)
      - [3.2.1.2. Tags 3.2.1.2. 标签](https://yaml.org/spec/1.2.2/#3212-tags)
      - [3.2.1.3. Node Comparison 3.2.1.3. 节点比较](https://yaml.org/spec/1.2.2/#3213-node-comparison)
    - 3.2.2. Serialization Tree
      3.2.2. 序列化树
      - [3.2.2.1. Mapping Key Order
        3.2.2.1. 映射键顺序](https://yaml.org/spec/1.2.2/#3221-mapping-key-order)
      - [3.2.2.2. Anchors and Aliases
        3.2.2.2. 锚点和别名](https://yaml.org/spec/1.2.2/#3222-anchors-and-aliases)
    - 3.2.3. Presentation Stream
      3.2.3. 演示流
      - [3.2.3.1. Node Styles 3.2.3.1. 节点样式](https://yaml.org/spec/1.2.2/#3231-node-styles)
      - [3.2.3.2. Scalar Formats 3.2.3.2. 标量格式](https://yaml.org/spec/1.2.2/#3232-scalar-formats)
      - [3.2.3.3. Comments 3.2.3.3. 注释](https://yaml.org/spec/1.2.2/#3233-comments)
      - [3.2.3.4. Directives 3.2.3.4. 指令](https://yaml.org/spec/1.2.2/#3234-directives)
  - 3.3. Loading Failure Points
    3.3. 加载故障点
    - [3.3.1. Well-Formed Streams and Identified Aliases
      3.3.1. 格式正确的流和已识别的别名](https://yaml.org/spec/1.2.2/#331-well-formed-streams-and-identified-aliases)
    - [3.3.2. Resolved Tags 3.3.2. 已解析的标签](https://yaml.org/spec/1.2.2/#332-resolved-tags)
    - [3.3.3. Recognized and Valid Tags
      3.3.3. 已识别和有效的标签](https://yaml.org/spec/1.2.2/#333-recognized-and-valid-tags)
    - [3.3.4. Available Tags 3.3.4. 可用标签](https://yaml.org/spec/1.2.2/#334-available-tags)
- Chapter 4. Syntax Conventions
  第 4 章.语法约定
  - [4.1. Production Syntax 4.1. 生产语法](https://yaml.org/spec/1.2.2/#41-production-syntax)
  - [4.2. Production Parameters
    4.2. 生产参数](https://yaml.org/spec/1.2.2/#42-production-parameters)
  - [4.3. Production Naming Conventions
    4.3. 生产命名约定](https://yaml.org/spec/1.2.2/#43-production-naming-conventions)
- Chapter 5. Character Productions
  第 5 章.角色制作
  - [5.1. Character Set 5.1. 字符集](https://yaml.org/spec/1.2.2/#51-character-set)
  - [5.2. Character Encodings 5.2. 字符编码](https://yaml.org/spec/1.2.2/#52-character-encodings)
  - [5.3. Indicator Characters
    5.3. 指示符字符](https://yaml.org/spec/1.2.2/#53-indicator-characters)
  - [5.4. Line Break Characters
    5.4. 换行符](https://yaml.org/spec/1.2.2/#54-line-break-characters)
  - [5.5. White Space Characters
    5.5. 空白字符](https://yaml.org/spec/1.2.2/#55-white-space-characters)
  - [5.6. Miscellaneous Characters
    5.6. 其他字符](https://yaml.org/spec/1.2.2/#56-miscellaneous-characters)
  - [5.7. Escaped Characters 5.7. 转义字符](https://yaml.org/spec/1.2.2/#57-escaped-characters)
- Chapter 6. Structural Productions
  第 6 章.结构产品
  - [6.1. Indentation Spaces 6.1. 缩进空格](https://yaml.org/spec/1.2.2/#61-indentation-spaces)
  - [6.2. Separation Spaces 6.2. 分隔空间](https://yaml.org/spec/1.2.2/#62-separation-spaces)
  - [6.3. Line Prefixes 6.3. 行前缀](https://yaml.org/spec/1.2.2/#63-line-prefixes)
  - [6.4. Empty Lines 6.4. 空行](https://yaml.org/spec/1.2.2/#64-empty-lines)
  - [6.5. Line Folding 6.5. 折线](https://yaml.org/spec/1.2.2/#65-line-folding)
  - [6.6. Comments 6.6. 注释](https://yaml.org/spec/1.2.2/#66-comments)
  - [6.7. Separation Lines 6.7. 分隔线](https://yaml.org/spec/1.2.2/#67-separation-lines)
  - 6.8. Directives 6.8. 指令
    - [6.8.1. “`YAML`” Directives
      6.8.1. “`YAML`” 指令](https://yaml.org/spec/1.2.2/#681-yaml-directives)
    - 6.8.2. “`TAG`” Directives
      6.8.2. “`TAG`” 指令
      - [6.8.2.1. Tag Handles 6.8.2.1. 标签句柄](https://yaml.org/spec/1.2.2/#6821-tag-handles)
      - [6.8.2.2. Tag Prefixes 6.8.2.2. 标签前缀](https://yaml.org/spec/1.2.2/#6822-tag-prefixes)
  - 6.9. Node Properties 6.9. 节点属性
    - [6.9.1. Node Tags 6.9.1. 节点标签](https://yaml.org/spec/1.2.2/#691-node-tags)
    - [6.9.2. Node Anchors 6.9.2. 节点锚点](https://yaml.org/spec/1.2.2/#692-node-anchors)
- Chapter 7. Flow Style Productions
  第 7 章.Flow Style 制作
  - [7.1. Alias Nodes 7.1. 别名节点](https://yaml.org/spec/1.2.2/#71-alias-nodes)
  - [7.2. Empty Nodes 7.2. 空节点](https://yaml.org/spec/1.2.2/#72-empty-nodes)
  - 7.3. Flow Scalar Styles 7.3. 流标量样式
    - [7.3.1. Double-Quoted Style
      7.3.1. 双引号样式](https://yaml.org/spec/1.2.2/#731-double-quoted-style)
    - [7.3.2. Single-Quoted Style
      7.3.2. 单引号样式](https://yaml.org/spec/1.2.2/#732-single-quoted-style)
    - [7.3.3. Plain Style 7.3.3. 纯色样式](https://yaml.org/spec/1.2.2/#733-plain-style)
  - 7.4. Flow Collection Styles
    7.4. 流式集合样式
    - [7.4.1. Flow Sequences 7.4.1. 流序列](https://yaml.org/spec/1.2.2/#741-flow-sequences)
    - [7.4.2. Flow Mappings 7.4.2. 流映射](https://yaml.org/spec/1.2.2/#742-flow-mappings)
  - [7.5. Flow Nodes 7.5. 流节点](https://yaml.org/spec/1.2.2/#75-flow-nodes)
- Chapter 8. Block Style Productions
  第 8 章.块式制作
  - 8.1. Block Scalar Styles 8.1. 块标量样式
    - 8.1.1. Block Scalar Headers
      8.1.1. 块标量头文件
      - [8.1.1.1. Block Indentation Indicator
        8.1.1.1. 块缩进指示器](https://yaml.org/spec/1.2.2/#8111-block-indentation-indicator)
      - [8.1.1.2. Block Chomping Indicator
        8.1.1.2. 块阻塞指示器](https://yaml.org/spec/1.2.2/#8112-block-chomping-indicator)
    - [8.1.2. Literal Style 8.1.2. 字面量样式](https://yaml.org/spec/1.2.2/#812-literal-style)
    - [8.1.3. Folded Style 8.1.3. 折叠样式](https://yaml.org/spec/1.2.2/#813-folded-style)
  - 8.2. Block Collection Styles
    8.2. 块集合样式
    - [8.2.1. Block Sequences 8.2.1. 块序列](https://yaml.org/spec/1.2.2/#821-block-sequences)
    - [8.2.2. Block Mappings 8.2.2. 块映射](https://yaml.org/spec/1.2.2/#822-block-mappings)
    - [8.2.3. Block Nodes 8.2.3. 块节点](https://yaml.org/spec/1.2.2/#823-block-nodes)
- Chapter 9. Document Stream Productions
  第 9 章.文档流制作
  - 9.1. Documents 9.1. 文档
    - [9.1.1. Document Prefix 9.1.1. 文档前缀](https://yaml.org/spec/1.2.2/#911-document-prefix)
    - [9.1.2. Document Markers 9.1.2. 文档标记](https://yaml.org/spec/1.2.2/#912-document-markers)
    - [9.1.3. Bare Documents 9.1.3. 裸文档](https://yaml.org/spec/1.2.2/#913-bare-documents)
    - [9.1.4. Explicit Documents
      9.1.4. 显式文档](https://yaml.org/spec/1.2.2/#914-explicit-documents)
    - [9.1.5. Directives Documents
      9.1.5. 指令文档](https://yaml.org/spec/1.2.2/#915-directives-documents)
  - [9.2. Streams 9.2. 流](https://yaml.org/spec/1.2.2/#92-streams)
- Chapter 10. Recommended Schemas
  第 10 章.建议的架构
  - 10.1. Failsafe Schema 10.1. 故障安全模式
    - 10.1.1. Tags 10.1.1. 标签
      - [10.1.1.1. Generic Mapping
        10.1.1.1. 泛型映射](https://yaml.org/spec/1.2.2/#10111-generic-mapping)
      - [10.1.1.2. Generic Sequence
        10.1.1.2. 泛型序列](https://yaml.org/spec/1.2.2/#10112-generic-sequence)
      - [10.1.1.3. Generic String 10.1.1.3. 泛型字符串](https://yaml.org/spec/1.2.2/#10113-generic-string)
    - [10.1.2. Tag Resolution 10.1.2. 标签解析](https://yaml.org/spec/1.2.2/#1012-tag-resolution)
  - 10.2. JSON Schema 10.2. JSON 架构
    - 10.2.1. Tags 10.2.1. 标签
      - [10.2.1.1. Null 10.2.1.1. 空](https://yaml.org/spec/1.2.2/#10211-null)
      - [10.2.1.2. Boolean 10.2.1.2. 布尔值](https://yaml.org/spec/1.2.2/#10212-boolean)
      - [10.2.1.3. Integer 10.2.1.3. 整数](https://yaml.org/spec/1.2.2/#10213-integer)
      - [10.2.1.4. Floating Point 10.2.1.4. 浮点数](https://yaml.org/spec/1.2.2/#10214-floating-point)
    - [10.2.2. Tag Resolution 10.2.2. 标签解析](https://yaml.org/spec/1.2.2/#1022-tag-resolution)
  - 10.3. Core Schema 10.3. 核心模式
    - [10.3.1. Tags 10.3.1. 标签](https://yaml.org/spec/1.2.2/#1031-tags)
    - [10.3.2. Tag Resolution 10.3.2. 标签解析](https://yaml.org/spec/1.2.2/#1032-tag-resolution)
  - [10.4. Other Schemas 10.4. 其他模式](https://yaml.org/spec/1.2.2/#104-other-schemas)
- [Reference Links 参考链接](https://yaml.org/spec/1.2.2/#reference-links)



YAML (a recursive acronym for “YAML Ain’t Markup Language”) is a data serialization language designed to be human-friendly and work well with modern programming languages for common everyday tasks. This specification is both an introduction to the YAML language and the concepts supporting it. It is also a complete specification of the information needed to develop [applications](https://yaml.org/spec/1.2.2/#processes-and-models) for processing YAML.
YAML（“YAML Ain't Markup Language” 的递归首字母缩写词）是一种数据序列化语言旨在对人类友好并与现代语言配合使用 用于常见日常任务的编程语言。 此规范既是对 YAML 语言的介绍，也是 概念。 它也是开发所需信息的完整规范 [处理](https://yaml.org/spec/1.2.2/#processes-and-models) YAML 的应用程序。

Open, interoperable and readily understandable tools have advanced computing immensely. YAML was designed from the start to be useful and friendly to people working with data. It uses Unicode [printable](https://yaml.org/spec/1.2.2/#character-set) characters, [some](https://yaml.org/spec/1.2.2/#indicator-characters) of which provide structural information and the rest containing the data itself. YAML achieves a unique cleanness by minimizing the amount of structural characters and allowing the data to show itself in a natural and meaningful way. For example, [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) may be used for structure, [colons](https://yaml.org/spec/1.2.2/#flow-mappings) separate [key/value pairs](https://yaml.org/spec/1.2.2/#mapping) and [dashes](https://yaml.org/spec/1.2.2/#block-sequences) are used to create “bulleted” [lists](https://yaml.org/spec/1.2.2/#sequence).
开放、可互作且易于理解的工具具有极高的计算能力。YAML 从一开始就设计为对处理数据的人有用和友好。它使用 Unicode [可打印](https://yaml.org/spec/1.2.2/#character-set)字符，[其中一些](https://yaml.org/spec/1.2.2/#indicator-characters)字符提供结构信息，其余字符包含数据本身。YAML 通过最大限度地减少结构特征的数量并允许数据以自然和有意义的方式显示自身，实现了独特的干净度。例如，[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)可用于结构，[冒号](https://yaml.org/spec/1.2.2/#flow-mappings)分隔 [键/值对](https://yaml.org/spec/1.2.2/#mapping)和[破折号](https://yaml.org/spec/1.2.2/#block-sequences)用于创建“项目符号”[列表](https://yaml.org/spec/1.2.2/#sequence)。

There are many kinds of [data structures](https://yaml.org/spec/1.2.2/#dump), but they can all be adequately [represented](https://yaml.org/spec/1.2.2/#representation-graph) with three basic primitives: [mappings](https://yaml.org/spec/1.2.2/#mapping) (hashes/dictionaries), [sequences](https://yaml.org/spec/1.2.2/#sequence) (arrays/lists) and [scalars](https://yaml.org/spec/1.2.2/#scalars) (strings/numbers). YAML leverages these primitives and adds a simple typing system and [aliasing](https://yaml.org/spec/1.2.2/#anchors-and-aliases) mechanism to form a complete language for [serializing](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) any [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures). While most programming languages can use YAML for data serialization, YAML excels in working with those languages that are fundamentally built around the three basic primitives. These include common dynamic languages such as JavaScript, Perl, PHP, Python and Ruby.
[数据结构](https://yaml.org/spec/1.2.2/#dump)有很多种，但它们都可以足够 用三个基本基元[表示](https://yaml.org/spec/1.2.2/#representation-graph)：[映射](https://yaml.org/spec/1.2.2/#mapping)（哈希/字典）、 [序列](https://yaml.org/spec/1.2.2/#sequence) （数组/列表） 和[标量](https://yaml.org/spec/1.2.2/#scalars) （字符串/数字）。YAML 利用这些原语并添加了一个简单的类型系统和[别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases) 机制来形成一种完整的语言来[序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)任何[原生数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)。虽然大多数编程语言都可以使用 YAML 进行数据序列化，但 YAML 擅长使用那些基本上围绕三个基本基元构建的语言。这些语言包括常见的动态语言，如 JavaScript、Perl、PHP、Python 和 Ruby。

There are hundreds of different languages for programming, but only a handful of languages for storing and transferring data. Even though its potential is virtually boundless, YAML was specifically created to work well for common use cases such as: configuration files, log files, interprocess messaging, cross-language data sharing, object persistence and debugging of complex data structures. When data is easy to view and understand, programming becomes a simpler task.
有数百种不同的编程语言，但只有少数几种语言用于存储和传输数据。尽管 YAML  的潜力几乎是无限的，但它是专门为常见使用案例而创建的，例如：配置文件、日志文件、进程间消息传递、跨语言数据共享、对象持久性和复杂数据结构的调试。当数据易于查看和理解时，编程就变得简单了。

## YAML 历史

The YAML 1.0 specification was published in early 2004 by by Clark Evans, Oren Ben-Kiki, and Ingy döt Net after 3 years of collaborative design work through the yaml-core mailing list[5](https://yaml.org/spec/1.2.2/#fn:yaml-core). The project was initially rooted in Clark and Oren’s work on the SML-DEV[6](https://yaml.org/spec/1.2.2/#fn:sml-dev) mailing list (for simplifying XML) and Ingy’s plain text serialization module[7](https://yaml.org/spec/1.2.2/#fn:denter) for Perl.
YAML 1.0 规范由 Clark Evans、Oren Ben-Kiki 和 Ingy döt Net 于 2004 年初发布，经过 3 年的 yaml-core 邮件列表[5](https://yaml.org/spec/1.2.2/#fn:yaml-core) 的协作设计工作。该项目最初植根于 Clark 和 Oren 在 SML-DEV[6](https://yaml.org/spec/1.2.2/#fn:sml-dev) 邮件列表（用于简化 XML）和 Ingy 的 Perl 纯文本序列化模块[7](https://yaml.org/spec/1.2.2/#fn:denter) 上的工作。该语言从之前的许多其他技术和格式中汲取了很多灵感。

Ruby was the first language to ship a YAML framework as part of its core language distribution in 2003.
第一个 YAML 框架是在 2001 年用 Perl 编写的，Ruby 是第一个在 2003 年将 YAML 框架作为其核心语言发行版的一部分提供的语言。

Around this time, the developers became aware of JSON[9](https://yaml.org/spec/1.2.2/#fn:json). By sheer coincidence, JSON was almost a complete subset of YAML (both syntactically and semantically).
YAML 1.1[8](https://yaml.org/spec/1.2.2/#fn:1-1-spec) 规范于 2005 年发布。大约在这个时候，开发人员开始注意到 JSON[9](https://yaml.org/spec/1.2.2/#fn:json)。纯属巧合，JSON 几乎是 YAML 的一个完整子集（在语法和语义上）。

A lot of the YAML frameworks in various programming languages are built over LibYAML and many others have looked to PyYAML as a solid reference for their implementations.
2006 年，Kyrylo Simonov 开发了 PyYAML10 和 LibYAML11 。各种编程语言中的许多 YAML 框架都是基于 LibYAML 构建的，许多其他框架将 PyYAML 视为其实现的可靠参考。

primary focus was making YAML a strict superset of JSON. It also removed many of the problematic implicit typing recommendations.
YAML 1.2[3](https://yaml.org/spec/1.2.2/#fn:1-2-spec) 规范于 2009 年发布。它的主要重点是使 YAML 成为 JSON 的严格超集。它还删除了许多有问题的隐式类型化建议。

Since the release of the 1.2 specification, YAML adoption has continued to grow, and many large-scale projects use it as their primary interface language. In 2020, the new [YAML language design team](https://yaml.org/spec/1.2.2/ext/team) began meeting regularly to discuss improvements to the YAML language and specification; to better meet the needs and expectations of its users and use cases.
自 1.2 规范发布以来，YAML 的采用率持续增长，许多大型项目将其用作主要接口语言。2020 年，新的 [YAML 语言设计团队](https://yaml.org/spec/1.2.2/ext/team)开始定期开会，讨论对 YAML 语言和规范的改进;以更好地满足其用户和使用案例的需求和期望。

is the first step in YAML’s rejuvenated development journey. YAML is now more popular than it has ever been, but there is a long list of things that need to be addressed for it to reach its full potential. 
此 YAML 1.2.2 规范于 2021 年 10 月发布，是 YAML 焕然一新的开发之旅的第一步。YAML 现在比以往任何时候都更受欢迎，但要充分发挥其潜力，需要解决的问题有很多问题需要解决。YAML 设计团队专注于使 YAML 尽可能更好。

## 集合

YAML’s [block collections](https://yaml.org/spec/1.2.2/#block-collection-styles) use [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) for scope and begin each entry on its own line. [Block sequences](https://yaml.org/spec/1.2.2/#block-sequences) indicate each entry with a dash and space (“`- `”). [Mappings](https://yaml.org/spec/1.2.2/#mapping) use a colon and space (“`: `”) to mark each [key/value pair](https://yaml.org/spec/1.2.2/#mapping). [Comments](https://yaml.org/spec/1.2.2/#comments) begin with an octothorpe (also called a “hash”, “sharp”, “pound” or “number sign” - “`#`”).
YAML 的[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)使用[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)作为范围，并将每个条目从 它自己的行。 [块序列](https://yaml.org/spec/1.2.2/#block-sequences)用破折号和空格 （“`- `”） 表示每个条目。 [映射](https://yaml.org/spec/1.2.2/#mapping)使用冒号和空格 （“`： `”） 来标记每个[键/值对](https://yaml.org/spec/1.2.2/#mapping)。 [注释](https://yaml.org/spec/1.2.2/#comments)以 octothorpe（也称为 “hash”、“sharp”、“pound” 或 “number sign” - “`#`”） 开头。

**Example 2.1 Sequence of Scalars (ball players)
例 2.1 标量序列（球手）**

```
- Mark McGwire
- Sammy Sosa
- Ken Griffey
```

**Example 2.2 Mapping Scalars to Scalars (player statistics)
例 2.2 将标量映射到标量（玩家统计信息）**

```
hr:  65    # Home runs
avg: 0.278 # Batting average
rbi: 147   # Runs Batted In
```

**Example 2.3 Mapping Scalars to Sequences (ball clubs in each league)
例 2.3 将标量映射到序列（每个联赛中的球杆）**

```
american:
- Boston Red Sox
- Detroit Tigers
- New York Yankees
national:
- New York Mets
- Chicago Cubs
- Atlanta Braves
```

**Example 2.4 Sequence of Mappings (players’ statistics)
例 2.4 映射序列（玩家的统计数据）**

```
-
  name: Mark McGwire
  hr:   65
  avg:  0.278
-
  name: Sammy Sosa
  hr:   63
  avg:  0.288
```

YAML also has [flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions), using explicit [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) rather than [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) to denote scope. The [flow sequence](https://yaml.org/spec/1.2.2/#flow-sequences) is written as a [comma](https://yaml.org/spec/1.2.2/#flow-collection-styles) separated list within [square](https://yaml.org/spec/1.2.2/#flow-sequences) [brackets](https://yaml.org/spec/1.2.2/#flow-sequences). In a similar manner, the [flow mapping](https://yaml.org/spec/1.2.2/#flow-mappings) uses [curly](https://yaml.org/spec/1.2.2/#flow-mappings) [braces](https://yaml.org/spec/1.2.2/#flow-mappings).
YAML 也有[流样式](https://yaml.org/spec/1.2.2/#flow-style-productions)，使用显式[指示器](https://yaml.org/spec/1.2.2/#indicator-characters)而不是 [缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)表示范围。[流序列](https://yaml.org/spec/1.2.2/#flow-sequences)将写入[方](https://yaml.org/spec/1.2.2/#flow-sequences)[括号](https://yaml.org/spec/1.2.2/#flow-sequences)内的[逗号](https://yaml.org/spec/1.2.2/#flow-collection-styles)分隔列表。以类似的方式，[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)使用[大](https://yaml.org/spec/1.2.2/#flow-mappings)[括号](https://yaml.org/spec/1.2.2/#flow-mappings)。

**Example 2.5 Sequence of Sequences
例 2.5 序列序列**

```
- [name        , hr, avg  ]
- [Mark McGwire, 65, 0.278]
- [Sammy Sosa  , 63, 0.288]
```

**Example 2.6 Mapping of Mappings
例 2.6 映射的映射**

```
Mark McGwire: {hr: 65, avg: 0.278}
Sammy Sosa: {
    hr: 63,
    avg: 0.288,
 }
```

## 2.2. Structures 2.2. 结构

YAML uses three dashes (“`---`”) to separate [directives](https://yaml.org/spec/1.2.2/#directives) from [document](https://yaml.org/spec/1.2.2/#documents) [content](https://yaml.org/spec/1.2.2/#nodes). This also serves to signal the start of a document if no [directives](https://yaml.org/spec/1.2.2/#directives) are present. Three dots ( “`...`”) indicate the end of a document without starting a new one, for use in communication channels.
YAML 使用三个短划线 （“`---`”） 将[指令](https://yaml.org/spec/1.2.2/#directives)与[文档](https://yaml.org/spec/1.2.2/#documents)[内容](https://yaml.org/spec/1.2.2/#nodes)分开。如果不存在[指令](https://yaml.org/spec/1.2.2/#directives)，这也用于指示文档的开始。三个点 （ “`...`”） 表示文档的结尾，而不开始新的文档，以便在通信渠道中使用。

**Example 2.7 Two Documents in a Stream (each with a leading comment)
例 2.7 Stream 中的两个文档（每个文档都有一个前导注释）**

```
# Ranking of 1998 home runs
---
- Mark McGwire
- Sammy Sosa
- Ken Griffey

# Team ranking
---
- Chicago Cubs
- St Louis Cardinals
```

**Example 2.8 Play by Play Feed from a Game
示例 2.8 游戏中的 Play by Play Feed**

```
---
time: 20:03:20
player: Sammy Sosa
action: strike (miss)
...
---
time: 20:03:47
player: Sammy Sosa
action: grand slam
...
```

Repeated [nodes](https://yaml.org/spec/1.2.2/#nodes) (objects) are first [identified](https://yaml.org/spec/1.2.2/#anchors-and-aliases) by an [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) (marked with the ampersand - “`&`”) and are then [aliased](https://yaml.org/spec/1.2.2/#anchors-and-aliases) (referenced with an asterisk - “`*`”) thereafter.
重复的[节点](https://yaml.org/spec/1.2.2/#nodes)（对象）首先由[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)（标有 & 符号 `- “&”）`[标识](https://yaml.org/spec/1.2.2/#anchors-and-aliases)，然后[是别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases)（用星号 - “`*`”引用”）。

**Example 2.9 Single Document with Two Comments
例 2.9 包含两个注释的单个文档**

```
---
hr: # 1998 hr ranking
- Mark McGwire
- Sammy Sosa
# 1998 rbi ranking
rbi:
- Sammy Sosa
- Ken Griffey
```

**Example 2.10 Node for “`Sammy Sosa`” appears twice in this document
例 2.10 “`Sammy Sosa`” 的节点在本文档中出现了两次**

```
---
hr:
- Mark McGwire
# Following node labeled SS
- &SS Sammy Sosa
rbi:
- *SS # Subsequent occurrence
- Ken Griffey
```

A question mark and space (“`? `”) indicate a complex [mapping](https://yaml.org/spec/1.2.2/#mapping) [key](https://yaml.org/spec/1.2.2/#nodes). Within a [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles), [key/value pairs](https://yaml.org/spec/1.2.2/#mapping) can start immediately following the [dash](https://yaml.org/spec/1.2.2/#block-sequences), [colon](https://yaml.org/spec/1.2.2/#flow-mappings) or [question mark](https://yaml.org/spec/1.2.2/#flow-mappings).
问号和空格 （“`？ `”） 表示复杂的[映射](https://yaml.org/spec/1.2.2/#mapping)[键](https://yaml.org/spec/1.2.2/#nodes)。在[数据块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)中，[键/值对](https://yaml.org/spec/1.2.2/#mapping)可以在[破折号](https://yaml.org/spec/1.2.2/#block-sequences)、[冒号](https://yaml.org/spec/1.2.2/#flow-mappings)或[问号](https://yaml.org/spec/1.2.2/#flow-mappings)之后立即开始。

**Example 2.11 Mapping between Sequences
例 2.11 序列之间的映射**

```
? - Detroit Tigers
  - Chicago cubs
: - 2001-07-23

? [ New York Yankees,
    Atlanta Braves ]
: [ 2001-07-02, 2001-08-12,
    2001-08-14 ]
```

**Example 2.12 Compact Nested Mapping
例 2.12 紧凑嵌套映射**

```
---
# Products purchased
- item    : Super Hoop
  quantity: 1
- item    : Basketball
  quantity: 4
- item    : Big Shoes
  quantity: 1
```

## 2.3. Scalars 2.3. 标量

[Scalar content](https://yaml.org/spec/1.2.2/#scalar) can be written in [block](https://yaml.org/spec/1.2.2/#scalars) notation, using a [literal style](https://yaml.org/spec/1.2.2/#literal-style) (indicated by “`|`”) where all [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) are significant. Alternatively, they can be written with the [folded style](https://yaml.org/spec/1.2.2/#folded-style) (denoted by “`>`”) where each [line break](https://yaml.org/spec/1.2.2/#line-break-characters) is [folded](https://yaml.org/spec/1.2.2/#line-folding) to a [space](https://yaml.org/spec/1.2.2/#white-space-characters) unless it ends an [empty](https://yaml.org/spec/1.2.2/#empty-lines) or a [more-indented](https://yaml.org/spec/1.2.2/#example-more-indented-lines) line.
[标量内容](https://yaml.org/spec/1.2.2/#scalar)可以使用[文字样式](https://yaml.org/spec/1.2.2/#literal-style)以[块](https://yaml.org/spec/1.2.2/#scalars)表示法编写 （用 “`|`” 表示）其中所有[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)都很重要。或者，它们可以用[折叠样式](https://yaml.org/spec/1.2.2/#folded-style)（用 “`>`” 表示）来书写，其中每个[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)都[折叠](https://yaml.org/spec/1.2.2/#line-folding)成一个[空格](https://yaml.org/spec/1.2.2/#white-space-characters)，除非它以[空](https://yaml.org/spec/1.2.2/#empty-lines)或 [更多缩进](https://yaml.org/spec/1.2.2/#example-more-indented-lines)的行。

**Example 2.13 In literals, newlines are preserved
例 2.13 在文字中，保留换行符**

```
# ASCII Art
--- |
  \//||\/||
  // ||  ||__
```

**Example 2.14 In the folded scalars, newlines become spaces
例 2.14 在折叠标量中，换行符变为空格**

```
--- >
  Mark McGwire's
  year was crippled
  by a knee injury.
```

**Example 2.15 Folded newlines are preserved for “more indented” and blank lines
例 2.15 为“更多缩进”和空行保留折叠的换行符**

```
--- >
 Sammy Sosa completed another
 fine season with great stats.

   63 Home Runs
   0.288 Batting Average

 What a year!
```

**Example 2.16 Indentation determines scope
例 2.16 缩进决定范围**

```
name: Mark McGwire
accomplishment: >
  Mark set a major league
  home run record in 1998.
stats: |
  65 Home Runs
  0.278 Batting Average
```

YAML’s [flow scalars](https://yaml.org/spec/1.2.2/#flow-scalar-styles) include the [plain style](https://yaml.org/spec/1.2.2/#plain-style) (most examples thus far) and two quoted styles. The [double-quoted style](https://yaml.org/spec/1.2.2/#double-quoted-style) provides [escape sequences](https://yaml.org/spec/1.2.2/#escaped-characters). The [single-quoted style](https://yaml.org/spec/1.2.2/#single-quoted-style) is useful when [escaping](https://yaml.org/spec/1.2.2/#escaped-characters) is not needed. All [flow scalars](https://yaml.org/spec/1.2.2/#flow-scalar-styles) can span multiple lines; [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) are always [folded](https://yaml.org/spec/1.2.2/#line-folding).
YAML 的[流标量](https://yaml.org/spec/1.2.2/#flow-scalar-styles)包括 [plain 样式](https://yaml.org/spec/1.2.2/#plain-style)（到目前为止大多数示例）和两种带引号的样式。[双引号样式](https://yaml.org/spec/1.2.2/#double-quoted-style)提供[转义序列](https://yaml.org/spec/1.2.2/#escaped-characters)。当不需要[转义](https://yaml.org/spec/1.2.2/#escaped-characters)时，[单引号样式](https://yaml.org/spec/1.2.2/#single-quoted-style)很有用。所有[流标量](https://yaml.org/spec/1.2.2/#flow-scalar-styles)都可以跨越多行;[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)始终[折叠](https://yaml.org/spec/1.2.2/#line-folding)。

**Example 2.17 Quoted Scalars
例 2.17 带引号的标量**

```
unicode: "Sosa did fine.\u263A"
control: "\b1998\t1999\t2000\n"
hex esc: "\x0d\x0a is \r\n"

single: '"Howdy!" he cried.'
quoted: ' # Not a ''comment''.'
tie-fighter: '|\-*-/|'
```

**Example 2.18 Multi-line Flow Scalars
示例 2.18 多线流标量**

```
plain:
  This unquoted scalar
  spans many lines.

quoted: "So does this
  quoted scalar.\n"
```

## 2.4. Tags 2.4. 标签

In YAML, [untagged nodes](https://yaml.org/spec/1.2.2/#resolved-tags) are given a type depending on the [application](https://yaml.org/spec/1.2.2/#processes-and-models). The examples in this specification generally use the `seq`, `map` and `str` types from the [fail safe schema](https://yaml.org/spec/1.2.2/#failsafe-schema). A few examples also use the `int`, `float` and `null` types from the [JSON schema](https://yaml.org/spec/1.2.2/#json-schema).
在 YAML 中，[未标记的节点](https://yaml.org/spec/1.2.2/#resolved-tags)根据[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)被赋予类型。本规范中的示例通常使用 `seq`、`map` 和 `str` 类型[。](https://yaml.org/spec/1.2.2/#failsafe-schema)一些示例还使用 [JSON 架构](https://yaml.org/spec/1.2.2/#json-schema)中的 `int`、`float` 和 `null` 类型。

**Example 2.19 Integers 例 2.19 整数**

```
canonical: 12345
decimal: +12345
octal: 0o14
hexadecimal: 0xC
```

**Example 2.20 Floating Point
例 2.20 浮点数**

```
canonical: 1.23015e+3
exponential: 12.3015e+02
fixed: 1230.15
negative infinity: -.inf
not a number: .nan
```

**Example 2.21 Miscellaneous
例 2.21 其他**

```
null:
booleans: [ true, false ]
string: '012345'
```

**Example 2.22 Timestamps 例 2.22 时间戳**

```
canonical: 2001-12-15T02:59:43.1Z
iso8601: 2001-12-14t21:59:43.10-05:00
spaced: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
```

Explicit typing is denoted with a [tag](https://yaml.org/spec/1.2.2/#tags) using the exclamation point (“`!`”) symbol. [Global tags](https://yaml.org/spec/1.2.2/#tags) are URIs and may be specified in a [tag shorthand](https://yaml.org/spec/1.2.2/#tag-shorthands) notation using a [handle](https://yaml.org/spec/1.2.2/#tag-handles). [Application](https://yaml.org/spec/1.2.2/#processes-and-models)-specific [local tags](https://yaml.org/spec/1.2.2/#tags) may also be used.
显式键入用使用感叹号 （“`！`”） 的[标记](https://yaml.org/spec/1.2.2/#tags)表示 象征。 [全局标记](https://yaml.org/spec/1.2.2/#tags)是 URI，可以使用[句柄](https://yaml.org/spec/1.2.2/#tag-handles)以[标记速记](https://yaml.org/spec/1.2.2/#tag-shorthands)表示法指定。 也可以使用[特定于应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)[的本地标记](https://yaml.org/spec/1.2.2/#tags)。

**Example 2.23 Various Explicit Tags
例 2.23 各种显式标记**

```
---
not-date: !!str 2002-04-28

picture: !!binary |
 R0lGODlhDAAMAIQAAP//9/X
 17unp5WZmZgAAAOfn515eXv
 Pz7Y6OjuDg4J+fn5OTk6enp
 56enmleECcgggoBADs=

application specific tag: !something |
 The semantics of the tag
 above may be different for
 different documents.
```

**Example 2.24 Global Tags 例 2.24 全局标记**

```
%TAG ! tag:clarkevans.com,2002:
--- !shape
  # Use the ! handle for presenting
  # tag:clarkevans.com,2002:circle
- !circle
  center: &ORIGIN {x: 73, y: 129}
  radius: 7
- !line
  start: *ORIGIN
  finish: { x: 89, y: 102 }
- !label
  start: *ORIGIN
  color: 0xFFEEBB
  text: Pretty vector drawing.
```

**Example 2.25 Unordered Sets
例 2.25 无序集**

```
# Sets are represented as a
# Mapping where each key is
# associated with a null value
--- !!set
? Mark McGwire
? Sammy Sosa
? Ken Griffey
```

**Example 2.26 Ordered Mappings
例 2.26 有序映射**

```
# Ordered maps are represented as
# A sequence of mappings, with
# each mapping having one key
--- !!omap
- Mark McGwire: 65
- Sammy Sosa: 63
- Ken Griffey: 58
```

## 2.5. Full Length Example 2.5. 全长示例

Below are two full-length examples of YAML. The first is a sample invoice; the second is a sample log file.
以下是 YAML 的两个完整示例。第一个是样本发票;第二个是示例日志文件。

**Example 2.27 Invoice 示例 2.27 发票**

```
--- !<tag:clarkevans.com,2002:invoice>
invoice: 34843
date   : 2001-01-23
bill-to: &id001
  given  : Chris
  family : Dumars
  address:
    lines: |
      458 Walkman Dr.
      Suite #292
    city    : Royal Oak
    state   : MI
    postal  : 48046
ship-to: *id001
product:
- sku         : BL394D
  quantity    : 4
  description : Basketball
  price       : 450.00
- sku         : BL4438H
  quantity    : 1
  description : Super Hoop
  price       : 2392.00
tax  : 251.42
total: 4443.52
comments:
  Late afternoon is best.
  Backup contact is Nancy
  Billsmer @ 338-4338.
```

**Example 2.28 Log File 示例 2.28 日志文件**

```
---
Time: 2001-11-23 15:01:42 -5
User: ed
Warning:
  This is an error message
  for the log file
---
Time: 2001-11-23 15:02:31 -5
User: ed
Warning:
  A slightly different error
  message.
---
Date: 2001-11-23 15:03:17 -5
User: ed
Fatal:
  Unknown variable "bar"
Stack:
- file: TopClass.py
  line: 23
  code: |
    x = MoreObject("345\n")
- file: MoreClass.py
  line: 58
  code: |-
    foo = bar
```

# Chapter 3. Processes and Models 第 3 章.流程和模型

YAML is both a text format and a method for [presenting](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) any [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures) in this format. Therefore, this specification defines two concepts: a class of data objects called YAML [representations](https://yaml.org/spec/1.2.2/#representation-graph) and a syntax for [presenting](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) YAML [representations](https://yaml.org/spec/1.2.2/#representation-graph) as a series of characters, called a YAML [stream](https://yaml.org/spec/1.2.2/#streams).
YAML 既是一种文本格式，也是一种以这种格式[呈现](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)任何[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)的方法。因此，本规范定义了两个概念：一类称为 YAML [表示的数据](https://yaml.org/spec/1.2.2/#representation-graph)对象和用于[表示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) YAML 的语法 [表示](https://yaml.org/spec/1.2.2/#representation-graph)形式为一系列字符，称为 YAML [流](https://yaml.org/spec/1.2.2/#streams)。

A YAML *processor* is a tool for converting information between these complementary views. It is assumed that a YAML processor does its work on behalf of another module, called an *application*. This chapter describes the information structures a YAML processor must provide to or obtain from the application.
YAML *处理器*是用于在这些互补视图之间转换信息的工具。假定 YAML 处理器代表另一个模块（称为*应用程序*）执行其工作。本章介绍 YAML 处理器必须提供给应用程序或从应用程序获取的信息结构。

YAML information is used in two ways: for machine processing and for human consumption. The challenge of reconciling these two perspectives is best done in three distinct translation stages: [representation](https://yaml.org/spec/1.2.2/#representation-graph), [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) and [presentation](https://yaml.org/spec/1.2.2/#presentation-stream). [Representation](https://yaml.org/spec/1.2.2/#representation-graph) addresses how YAML views [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) to achieve portability between programming environments. [Serialization](https://yaml.org/spec/1.2.2/#serialization-tree) concerns itself with turning a YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph) into a serial form, that is, a form with sequential access constraints. [Presentation](https://yaml.org/spec/1.2.2/#presentation-stream) deals with the formatting of a YAML [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) as a series of characters in a human-friendly manner.
YAML 信息以两种方式使用：用于机器处理和供人类使用。调和这两个观点的挑战最好在三个不同的翻译阶段完成：[表示](https://yaml.org/spec/1.2.2/#representation-graph)、[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)和 [演示文稿](https://yaml.org/spec/1.2.2/#presentation-stream)。 [表示形式](https://yaml.org/spec/1.2.2/#representation-graph)解决了 YAML 如何查看[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)以实现 编程环境之间的可移植性。 [序列化](https://yaml.org/spec/1.2.2/#serialization-tree)本身关心的是将 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)转换为 serial 表单，即具有 Sequential Access Constraints 的表单。 [Presentation](https://yaml.org/spec/1.2.2/#presentation-stream) 以用户友好的方式将 YAML [序列化](https://yaml.org/spec/1.2.2/#serialization-tree)格式化为一系列字符。

## 3.1. Processes 3.1. 进程

Translating between [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) and a character [stream](https://yaml.org/spec/1.2.2/#streams) is done in several logically distinct stages, each with a well defined input and output data model, as shown in the following diagram:
[本机数据结构和](https://yaml.org/spec/1.2.2/#representing-native-data-structures)字符[流](https://yaml.org/spec/1.2.2/#streams)之间的转换在几个逻辑上不同的阶段中完成，每个阶段都有定义明确的输入和输出数据模型，如下图所示：

**Figure 3.1. Processing Overview
图 3.1.加工概述**

![Processing Overview](https://yaml.org/spec/1.2.2/img/overview2.svg)

A YAML processor need not expose the [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) or [representation](https://yaml.org/spec/1.2.2/#representation-graph) stages. It may translate directly between [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) and a character [stream](https://yaml.org/spec/1.2.2/#streams) ([dump](https://yaml.org/spec/1.2.2/#dump) and [load](https://yaml.org/spec/1.2.2/#load) in the diagram above). However, such a direct translation should take place so that the [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) are [constructed](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) only from information available in the [representation](https://yaml.org/spec/1.2.2/#representation-graph). In particular, [mapping key order](https://yaml.org/spec/1.2.2/#mapping), [comments](https://yaml.org/spec/1.2.2/#comments) and [tag handles](https://yaml.org/spec/1.2.2/#tag-handles) should not be referenced during [construction](https://yaml.org/spec/1.2.2/#constructing-native-data-structures).
YAML 处理器不需要公开[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)或[表示](https://yaml.org/spec/1.2.2/#representation-graph) 阶段。 它可以直接在[本机数据结构和](https://yaml.org/spec/1.2.2/#representing-native-data-structures)字符之间进行转换 [stream](https://yaml.org/spec/1.2.2/#streams) （上图中的 [dump](https://yaml.org/spec/1.2.2/#dump) 和 [load](https://yaml.org/spec/1.2.2/#load)）。但是，应该进行这种直接转换，[以便仅根据](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)  [表示](https://yaml.org/spec/1.2.2/#representation-graph)。特别是，在[构造](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)过程中不应引用[映射键顺序](https://yaml.org/spec/1.2.2/#mapping)、[注释](https://yaml.org/spec/1.2.2/#comments)和[标记句柄](https://yaml.org/spec/1.2.2/#tag-handles)。

### 3.1.1. Dump 3.1.1. 转储

*Dumping* native data structures to a character [stream](https://yaml.org/spec/1.2.2/#streams) is done using the following three stages:
*将*本机数据结构转储到字符[流](https://yaml.org/spec/1.2.2/#streams)使用以下三个阶段完成：

- Representing Native Data Structures 表示本机数据结构

  ​    YAML *represents* any *native data structure* using three [node kinds](https://yaml.org/spec/1.2.2/#nodes): [sequence](https://yaml.org/spec/1.2.2/#sequence) - an ordered series of entries; [mapping](https://yaml.org/spec/1.2.2/#mapping) - an unordered association of [unique](https://yaml.org/spec/1.2.2/#node-comparison) [keys](https://yaml.org/spec/1.2.2/#nodes) to [values](https://yaml.org/spec/1.2.2/#nodes); and [scalar](https://yaml.org/spec/1.2.2/#scalar) - any datum with opaque structure presentable as a series of Unicode characters. YAML 使用三种[节点类型](https://yaml.org/spec/1.2.2/#nodes)*表示*任何*本机数据结构*： [sequence](https://yaml.org/spec/1.2.2/#sequence) - 一系列有序的条目;[mapping](https://yaml.org/spec/1.2.2/#mapping) - [唯一](https://yaml.org/spec/1.2.2/#node-comparison)[键](https://yaml.org/spec/1.2.2/#nodes)与[值的](https://yaml.org/spec/1.2.2/#nodes)无序关联;标[量](https://yaml.org/spec/1.2.2/#scalar) - 任何具有不透明结构的数据，可表示为一系列 Unicode 字符。  

  ​    Combined, these primitives generate directed graph structures. These primitives were chosen because they are both powerful and familiar: the [sequence](https://yaml.org/spec/1.2.2/#sequence) corresponds to a Perl array and a Python list, the [mapping](https://yaml.org/spec/1.2.2/#mapping) corresponds to a Perl hash table and a Python dictionary. The [scalar](https://yaml.org/spec/1.2.2/#scalar) represents strings, integers, dates and other atomic data types. 这些基元组合在一起，生成有向图形结构。 选择这些原语是因为它们既强大又熟悉： [sequence](https://yaml.org/spec/1.2.2/#sequence) 对应一个 Perl 数组和一个 Python 列表，[映射](https://yaml.org/spec/1.2.2/#mapping) 对应一个 Perl 哈希表和一个 Python 字典。 [标量](https://yaml.org/spec/1.2.2/#scalar)表示字符串、整数、日期和其他原子数据类型。  

  ​    Each YAML [node](https://yaml.org/spec/1.2.2/#nodes) requires, in addition to its [kind](https://yaml.org/spec/1.2.2/#nodes) and [content](https://yaml.org/spec/1.2.2/#nodes), a [tag](https://yaml.org/spec/1.2.2/#tags) specifying its data type. Type specifiers are either [global](https://yaml.org/spec/1.2.2/#tags) URIs or are [local](https://yaml.org/spec/1.2.2/#tags) in scope to a single [application](https://yaml.org/spec/1.2.2/#processes-and-models). For example, an integer is represented in YAML with a [scalar](https://yaml.org/spec/1.2.2/#scalar) plus the [global tag](https://yaml.org/spec/1.2.2/#tags) “`tag:yaml.org,2002:int`”. Similarly, an invoice object, particular to a given organization, could be represented as a [mapping](https://yaml.org/spec/1.2.2/#mapping) together with the [local tag](https://yaml.org/spec/1.2.2/#tags) “`!invoice`”. This simple model can represent any data structure independent of programming language. 每个 YAML [节点](https://yaml.org/spec/1.2.2/#nodes)除了其[类型和](https://yaml.org/spec/1.2.2/#nodes)[内容](https://yaml.org/spec/1.2.2/#nodes)之外，还需要一个[标签](https://yaml.org/spec/1.2.2/#tags) 指定其数据类型。 类型说明符可以是[全局](https://yaml.org/spec/1.2.2/#tags) URI，也可以是单个 URI 的本地 [应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)。例如，在 YAML 中，整数由[标量](https://yaml.org/spec/1.2.2/#scalar)加上[全局标记](https://yaml.org/spec/1.2.2/#tags) “`tag：yaml.org，2002：int`” 表示。同样，特定于给定组织的 invoice 对象可以[表示为映射](https://yaml.org/spec/1.2.2/#mapping)以及[本地标记](https://yaml.org/spec/1.2.2/#tags) “`！invoice`”。这个简单的模型可以表示独立于编程语言的任何数据结构。  

- Serializing the Representation Graph 序列化表示图

  ​    For sequential access mediums, such as an event callback API, a YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph) must be *serialized* to an ordered tree. Since in a YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph), [mapping keys](https://yaml.org/spec/1.2.2/#nodes) are unordered and [nodes](https://yaml.org/spec/1.2.2/#nodes) may be referenced more than once (have more than one incoming “arrow”), the serialization process is required to impose an [ordering](https://yaml.org/spec/1.2.2/#mapping-key-order) on the [mapping keys](https://yaml.org/spec/1.2.2/#nodes) and to replace the second and subsequent references to a given [node](https://yaml.org/spec/1.2.2/#nodes) with place holders called [aliases](https://yaml.org/spec/1.2.2/#anchors-and-aliases). YAML does not specify how these *serialization details* are chosen. It is up to the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) to come up with human-friendly [key order](https://yaml.org/spec/1.2.2/#mapping-key-order) and [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) names, possibly with the help of the [application](https://yaml.org/spec/1.2.2/#processes-and-models). The result of this process, a YAML [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree), can then be traversed to produce a series of event calls for one-pass processing of YAML data. 对于顺序访问媒介，例如事件回调 API，YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)*必须序列化到*有序树。由于在 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)中，[映射键](https://yaml.org/spec/1.2.2/#nodes)是无序的，并且[节点](https://yaml.org/spec/1.2.2/#nodes)可以被多次引用（具有多个传入的“箭头”），因此需要序列化过程对[映射键](https://yaml.org/spec/1.2.2/#nodes)施加[排序](https://yaml.org/spec/1.2.2/#mapping-key-order) 以及将对给定[节点](https://yaml.org/spec/1.2.2/#nodes)的第二个和后续引用替换为称为[别名的](https://yaml.org/spec/1.2.2/#anchors-and-aliases)占位符。YAML 没有指定如何选择这些*序列化详细信息*。由 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)提出对人类友好的[密钥顺序](https://yaml.org/spec/1.2.2/#mapping-key-order)和 [锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)名称，可能在[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)的帮助下。然后，可以遍历此过程的结果，即 YAML [序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)，以生成一系列事件调用，以便对 YAML 数据进行一次性处理。  

- Presenting the Serialization Tree 显示序列化树

  ​    The final output process is *presenting* the YAML [serializations](https://yaml.org/spec/1.2.2/#serialization-tree) as a character [stream](https://yaml.org/spec/1.2.2/#streams) in a human-friendly manner. To maximize human readability, YAML offers a rich set of stylistic options which go far beyond the minimal functional needs of simple data storage. Therefore the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) is required to introduce various *presentation details* when creating the [stream](https://yaml.org/spec/1.2.2/#streams), such as the choice of [node styles](https://yaml.org/spec/1.2.2/#node-styles), how to [format scalar content](https://yaml.org/spec/1.2.2/#scalar-formats), the amount of [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces), which [tag handles](https://yaml.org/spec/1.2.2/#tag-handles) to use, the [node tags](https://yaml.org/spec/1.2.2/#node-tags) to leave [unspecified](https://yaml.org/spec/1.2.2/#resolved-tags), the set of [directives](https://yaml.org/spec/1.2.2/#directives) to provide and possibly even what [comments](https://yaml.org/spec/1.2.2/#comments) to add. While some of this can be done with the help of the [application](https://yaml.org/spec/1.2.2/#processes-and-models), in general this process should be guided by the preferences of the user. 最终的输出过程以用户友好的方式将 YAML [序列化](https://yaml.org/spec/1.2.2/#serialization-tree)*呈现*为字符[流](https://yaml.org/spec/1.2.2/#streams)。为了最大限度地提高人类可读性，YAML 提供了一组丰富的样式选项，这些选项远远超出了简单数据存储的最低功能需求。因此，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)在创建[流](https://yaml.org/spec/1.2.2/#streams)时需要引入各种*表示细节*，例如[节点样式](https://yaml.org/spec/1.2.2/#node-styles)的选择、如何[格式化标量](https://yaml.org/spec/1.2.2/#scalar-formats)内容、缩[进](https://yaml.org/spec/1.2.2/#indentation-spaces)量、要使用的[标签句柄](https://yaml.org/spec/1.2.2/#tag-handles)、[要保持未指定的](https://yaml.org/spec/1.2.2/#resolved-tags)[节点标签](https://yaml.org/spec/1.2.2/#node-tags)、要提供的[指令](https://yaml.org/spec/1.2.2/#directives)集，甚至可能要添加的[注释](https://yaml.org/spec/1.2.2/#comments)。虽然其中一些可以在[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)的帮助下完成，但一般来说，此过程应根据用户的偏好进行指导。  

### 3.1.2. Load 3.1.2. 加载

*Loading* [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) from a character [stream](https://yaml.org/spec/1.2.2/#streams) is done using the following three stages:
从字符[流](https://yaml.org/spec/1.2.2/#streams)*加载*[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)使用以下三个阶段完成：

- Parsing the Presentation Stream 解析 Presentation Stream

  ​    *Parsing* is the inverse process of [presentation](https://yaml.org/spec/1.2.2/#presentation-stream), it takes a [stream](https://yaml.org/spec/1.2.2/#streams) of characters and produces a [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree). Parsing discards all the [details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) introduced in the [presentation](https://yaml.org/spec/1.2.2/#presentation-stream) process, reporting only the [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree). Parsing can fail due to [ill-formed](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases) input. *解析*是[表示](https://yaml.org/spec/1.2.2/#presentation-stream)的逆过程，它采用字符[流](https://yaml.org/spec/1.2.2/#streams)并生成序列化[树](https://yaml.org/spec/1.2.2/#serialization-tree)。解析会丢弃[表示](https://yaml.org/spec/1.2.2/#presentation-stream)过程中引入的所有[详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，仅报告[序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)。解析可能会因[输入格式错误](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases)而失败。  

- Composing the Representation Graph 编写表示图

  ​    *Composing* takes a [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree) and produces a [representation graph](https://yaml.org/spec/1.2.2/#representation-graph). Composing discards all the [details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) introduced in the [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) process, producing only the [representation graph](https://yaml.org/spec/1.2.2/#representation-graph). Composing can fail due to any of several reasons, detailed [below](https://yaml.org/spec/1.2.2/#loading-failure-points). *Composing* 采用序列化[树](https://yaml.org/spec/1.2.2/#serialization-tree)并生成[表示图](https://yaml.org/spec/1.2.2/#representation-graph)。Composing 会丢弃[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)过程中引入的所有[详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，只生成[表示图](https://yaml.org/spec/1.2.2/#representation-graph)。撰写失败的原因可能有多种，[如下](https://yaml.org/spec/1.2.2/#loading-failure-points)所述。  

- Constructing Native Data Structures 构造本机数据结构

  ​    The final input process is *constructing* [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) from the YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph). Construction must be based only on the information available in the [representation](https://yaml.org/spec/1.2.2/#representation-graph) and not on additional [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) or [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) such as [comments](https://yaml.org/spec/1.2.2/#comments), [directives](https://yaml.org/spec/1.2.2/#directives), [mapping key order](https://yaml.org/spec/1.2.2/#mapping), [node styles](https://yaml.org/spec/1.2.2/#node-styles), [scalar content format](https://yaml.org/spec/1.2.2/#scalar-formats), [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) levels etc. Construction can fail due to the [unavailability](https://yaml.org/spec/1.2.2/#available-tags) of the required [native data types](https://yaml.org/spec/1.2.2/#representing-native-data-structures). 最终的输入过程是从 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)*形式构造*[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)。 构造必须仅基于 [表示](https://yaml.org/spec/1.2.2/#representation-graph)[形式，](https://yaml.org/spec/1.2.2/#directives)而不是其他[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)或[表示详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，例如[注释](https://yaml.org/spec/1.2.2/#comments)、指令、[映射键顺序](https://yaml.org/spec/1.2.2/#mapping)、[节点样式](https://yaml.org/spec/1.2.2/#node-styles)、 [标量内容格式](https://yaml.org/spec/1.2.2/#scalar-formats)、[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)级别等。由于所需的[本机数据类型](https://yaml.org/spec/1.2.2/#representing-native-data-structures)[不可用](https://yaml.org/spec/1.2.2/#available-tags)，构造可能会失败。  

## 3.2. Information Models 3.2. 信息模型

This section specifies the formal details of the results of the above processes. To maximize data portability between programming languages and implementations, users of YAML should be mindful of the distinction between [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) or [presentation](https://yaml.org/spec/1.2.2/#presentation-stream) properties and those which are part of the YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph). Thus, while imposing a [order](https://yaml.org/spec/1.2.2/#mapping-key-order) on [mapping keys](https://yaml.org/spec/1.2.2/#nodes) is necessary for flattening YAML [representations](https://yaml.org/spec/1.2.2/#representation-graph) to a sequential access medium, this [serialization detail](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) must not be used to convey [application](https://yaml.org/spec/1.2.2/#processes-and-models) level information. In a similar manner, while [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) technique and a choice of a [node style](https://yaml.org/spec/1.2.2/#node-styles) are needed for the human readability, these [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) are neither part of the YAML [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) nor the YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph). By carefully separating properties needed for [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) and [presentation](https://yaml.org/spec/1.2.2/#presentation-stream), YAML [representations](https://yaml.org/spec/1.2.2/#representation-graph) of [application](https://yaml.org/spec/1.2.2/#processes-and-models) information will be consistent and portable between various programming environments.
本节指定了上述过程结果的正式详细信息。为了最大限度地提高编程语言和实现之间的数据可移植性，YAML 的用户应注意[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)或 [presentation](https://yaml.org/spec/1.2.2/#presentation-stream) 属性以及属于 YAML 的属性 [表示](https://yaml.org/spec/1.2.2/#representation-graph)。因此，虽然在[将 YAML](https://yaml.org/spec/1.2.2/#nodes) [表示](https://yaml.org/spec/1.2.2/#representation-graph)形式扁平化到顺序访问介质时必须对 Map 键施加 [Sequences](https://yaml.org/spec/1.2.2/#mapping-key-order)，但此[序列化详细信息](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)不得用于传达[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)级别信息。以类似的方式，虽然为了人类可读性需要[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)技术和节点[样式](https://yaml.org/spec/1.2.2/#node-styles)的选择，但这些[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)既不是 YAML [序列化](https://yaml.org/spec/1.2.2/#serialization-tree)的一部分，也不是 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)的一部分。通过仔细分离[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)所需的属性，以及 [表示](https://yaml.org/spec/1.2.2/#presentation-stream)时，[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)信息的 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)将在各种编程环境之间保持一致和可移植。

The following diagram summarizes the three *information models*. Full arrows denote composition, hollow arrows denote inheritance, “`1`” and “`*`” denote “one” and “many” relationships. A single “`+`” denotes [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) details, a double “`++`” denotes [presentation](https://yaml.org/spec/1.2.2/#presentation-stream) details.
下图总结了这三种*信息模型*。全箭头表示组合，空心箭头表示继承，“`1`” 和 “`*`” 表示“一”和“多”关系。单个“`+`”表示序列化详细信息，双“`++`”表示[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)详细信息 [演示文稿](https://yaml.org/spec/1.2.2/#presentation-stream)详细信息。

**Figure 3.2. Information Models
图 3.2.信息模型**

![Information Models](https://yaml.org/spec/1.2.2/img/model2.svg)

### 3.2.1. Representation Graph 3.2.1. 表示图

YAML’s *representation* of [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures) is a rooted, connected, directed graph of [tagged](https://yaml.org/spec/1.2.2/#tags) [nodes](https://yaml.org/spec/1.2.2/#nodes). By “directed graph” we mean a set of [nodes](https://yaml.org/spec/1.2.2/#nodes) and directed edges (“arrows”), where each edge connects one [node](https://yaml.org/spec/1.2.2/#nodes) to another (see a formal directed graph definition[13](https://yaml.org/spec/1.2.2/#fn:digraph)). All the [nodes](https://yaml.org/spec/1.2.2/#nodes) must be reachable from the *root node* via such edges. Note that the YAML graph may include cycles and a [node](https://yaml.org/spec/1.2.2/#nodes) may have more than one incoming edge.
YAML *的*[原生数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)表示是[标记](https://yaml.org/spec/1.2.2/#tags)[节点](https://yaml.org/spec/1.2.2/#nodes)的有根、连接、有向图。“有向图”是指一组[节点](https://yaml.org/spec/1.2.2/#nodes)和有向边（“箭头”），其中每条边将一个节点连接到另一个[节点](https://yaml.org/spec/1.2.2/#nodes)（参见正式的有向图定义[13](https://yaml.org/spec/1.2.2/#fn:digraph)）。所有[节点](https://yaml.org/spec/1.2.2/#nodes)都必须可以通过此类 edge 从*根节点*访问。请注意，YAML 图可能包括 cycles，并且[一个节点](https://yaml.org/spec/1.2.2/#nodes)可能有多个 incoming edge。

[Nodes](https://yaml.org/spec/1.2.2/#nodes) that are defined in terms of other [nodes](https://yaml.org/spec/1.2.2/#nodes) are [collections](https://yaml.org/spec/1.2.2/#collections); [nodes](https://yaml.org/spec/1.2.2/#nodes) that are independent of any other [nodes](https://yaml.org/spec/1.2.2/#nodes) are [scalars](https://yaml.org/spec/1.2.2/#scalars). YAML supports two [kinds](https://yaml.org/spec/1.2.2/#nodes) of [collection nodes](https://yaml.org/spec/1.2.2/#mapping): [sequences](https://yaml.org/spec/1.2.2/#sequence) and [mappings](https://yaml.org/spec/1.2.2/#mapping). [Mapping nodes](https://yaml.org/spec/1.2.2/#mapping) are somewhat tricky because their [keys](https://yaml.org/spec/1.2.2/#nodes) are unordered and must be [unique](https://yaml.org/spec/1.2.2/#node-comparison).
根据其他[节点](https://yaml.org/spec/1.2.2/#nodes)定义的[节点](https://yaml.org/spec/1.2.2/#nodes)是[集合](https://yaml.org/spec/1.2.2/#collections);[节点](https://yaml.org/spec/1.2.2/#nodes) 独立于任何其他[节点](https://yaml.org/spec/1.2.2/#nodes)的节点都是[标量](https://yaml.org/spec/1.2.2/#scalars)。YAML 支持[两种](https://yaml.org/spec/1.2.2/#nodes)[集合节点](https://yaml.org/spec/1.2.2/#mapping)：[序列](https://yaml.org/spec/1.2.2/#sequence)和[映射](https://yaml.org/spec/1.2.2/#mapping)。 [映射节点](https://yaml.org/spec/1.2.2/#mapping)有点棘手，因为它们的[键](https://yaml.org/spec/1.2.2/#nodes)是无序的，并且必须[是唯一的](https://yaml.org/spec/1.2.2/#node-comparison)。

**Figure 3.3. Representation Model
图 3.3.表示模型**

![Representation Model](https://yaml.org/spec/1.2.2/img/represent2.svg)

#### 3.2.1.1. Nodes 3.2.1.1. 节点

A YAML *node* [represents](https://yaml.org/spec/1.2.2/#representation-graph) a single [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures). Such nodes have *content* of one of three *kinds*: scalar, sequence or mapping. In addition, each node has a [tag](https://yaml.org/spec/1.2.2/#tags) which serves to restrict the set of possible values the content can have.
YAML *节点*[表示](https://yaml.org/spec/1.2.2/#representation-graph)单个[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)。此类节点*具有以下三种**类型之一的内容*：标量、序列或映射。此外，每个节点都有一个 [tag](https://yaml.org/spec/1.2.2/#tags) 用于限制内容可以具有的可能值集。

- Scalar 标量

  ​    The content of a *scalar* node is an opaque datum that can be [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) as a series of zero or more Unicode characters. *标量*节点的内容是一个不透明的数据，可以[表示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)为一系列零个或多个 Unicode 字符。  

- Sequence 序列

  ​    The content of a *sequence* node is an ordered series of zero or more nodes. In particular, a sequence may contain the same node more than once. It could even contain itself. *序列*节点的内容是零个或多个节点的有序序列。特别是，一个序列可以多次包含同一节点。它甚至可以控制自己。  

- Mapping 映射

  ​    The content of a *mapping* node is an unordered set of *key/value* node *pairs*, with the restriction that each of the keys is [unique](https://yaml.org/spec/1.2.2/#node-comparison). YAML places no further restrictions on the nodes. In particular, keys may be arbitrary nodes, the same node may be used as the value of several key/value pairs and a mapping could even contain itself as a key or a value. *映射*节点的内容是一组无序的*键/值*节点 *对*，但限制每个键都是[唯一的](https://yaml.org/spec/1.2.2/#node-comparison)。YAML 对节点没有进一步的限制。特别是，键可以是任意节点，同一节点可以用作多个键/值对的值，并且映射甚至可以将自身包含为键或值。  

#### 3.2.1.2. Tags 3.2.1.2. 标签

YAML [represents](https://yaml.org/spec/1.2.2/#representation-graph) type information of [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) with a simple identifier, called a *tag*. *Global tags* are URIs and hence globally unique across all [applications](https://yaml.org/spec/1.2.2/#processes-and-models). The “`tag:`” URI scheme[14](https://yaml.org/spec/1.2.2/#fn:tag-uri) is recommended for all global YAML tags. In contrast, *local tags* are specific to a single [application](https://yaml.org/spec/1.2.2/#processes-and-models). Local tags start with “`!`”, are not URIs and are not expected to be globally unique. YAML provides a “`TAG`” directive to make tag notation less verbose; it also offers easy migration from local to global tags. To ensure this, local tags are restricted to the URI character set and use URI character [escaping](https://yaml.org/spec/1.2.2/#escaped-characters).
YAML 使用称为*标签*的简单标识符[表示](https://yaml.org/spec/1.2.2/#representation-graph)[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)的类型信息。 *全局标签*是 URI，因此在所有[应用程序中](https://yaml.org/spec/1.2.2/#processes-and-models)都是全局唯一的。建议对所有全局 YAML 标记使用 “`tag：”`URI 方案[14](https://yaml.org/spec/1.2.2/#fn:tag-uri)。相比之下，*本地标记*特定于单个[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)。本地标签以 “`！`” 开头，不是 URI，并且不需要全局唯一。YAML 提供了一个 “`TAG`” 指令，使标签表示法不那么冗长;它还提供从本地到全局标记的轻松迁移。为了确保这一点，本地标记被限制为 URI 字符集并使用 URI 字符[转义](https://yaml.org/spec/1.2.2/#escaped-characters)。

YAML does not mandate any special relationship between different tags that begin with the same substring. Tags ending with URI fragments (containing “`#`”) are no exception; tags that share the same base URI but differ in their fragment part are considered to be different, independent tags. By convention, fragments are used to identify different “variants” of a tag, while “`/`” is used to define nested tag “namespace” hierarchies. However, this is merely a convention and each tag may employ its own rules. For example, Perl tags may use “`::`” to express namespace hierarchies, Java tags may use “`.`”, etc.
YAML 不要求以同一子字符串开头的不同标签之间有任何特殊关系。以 URI 片段结尾的标记（包含 “`#`”）也不例外;共享相同基本 URI 但片段部分不同的标记被视为不同的独立标记。按照惯例，片段用于标识标记的不同“变体”，而“`/`”用于定义嵌套标记“命名空间”层次结构。但是，这只是一个约定，每个标签都可以使用自己的规则。例如，Perl 标签可能使用 “`：：`” 来表示命名空间层次结构，Java 标签可能使用 “`.`” 等。

YAML tags are used to associate meta information with each [node](https://yaml.org/spec/1.2.2/#nodes). In particular, each tag must specify the expected [node kind](https://yaml.org/spec/1.2.2/#nodes) ([scalar](https://yaml.org/spec/1.2.2/#scalar), [sequence](https://yaml.org/spec/1.2.2/#sequence) or [mapping](https://yaml.org/spec/1.2.2/#mapping)). [Scalar](https://yaml.org/spec/1.2.2/#scalar) tags must also provide a mechanism for converting [formatted content](https://yaml.org/spec/1.2.2/#scalar-formats) to a [canonical form](https://yaml.org/spec/1.2.2/#canonical-form) for supporting [equality](https://yaml.org/spec/1.2.2/#equality) testing. Furthermore, a tag may provide additional information such as the set of allowed [content](https://yaml.org/spec/1.2.2/#nodes) values for validation, a mechanism for [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution) or any other data that is applicable to all of the tag’s [nodes](https://yaml.org/spec/1.2.2/#nodes).
YAML 标签用于将元信息与每个[节点](https://yaml.org/spec/1.2.2/#nodes)相关联。具体而言，每个标签都必须指定预期的[节点类型](https://yaml.org/spec/1.2.2/#nodes)（[标量](https://yaml.org/spec/1.2.2/#scalar)、 [sequence](https://yaml.org/spec/1.2.2/#sequence) 或 [mapping](https://yaml.org/spec/1.2.2/#mapping)）。 [标量](https://yaml.org/spec/1.2.2/#scalar)标签还必须提供一种转换[格式化内容的](https://yaml.org/spec/1.2.2/#scalar-formats)机制 转换为支持[相等](https://yaml.org/spec/1.2.2/#equality)性测试的[规范形式](https://yaml.org/spec/1.2.2/#canonical-form)。此外，标签还可以提供其他信息，例如允许用于验证[的内容](https://yaml.org/spec/1.2.2/#nodes)值集、[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)机制或适用于标签所有[节点](https://yaml.org/spec/1.2.2/#nodes)的任何其他数据。

#### 3.2.1.3. Node Comparison 3.2.1.3. 节点比较

Since YAML [mappings](https://yaml.org/spec/1.2.2/#mapping) require [key](https://yaml.org/spec/1.2.2/#nodes) uniqueness, [representations](https://yaml.org/spec/1.2.2/#representation-graph) must include a mechanism for testing the equality of [nodes](https://yaml.org/spec/1.2.2/#nodes). This is non-trivial since YAML allows various ways to [format scalar content](https://yaml.org/spec/1.2.2/#scalar-formats). For example, the integer eleven can be written as “`0o13`” (octal) or “`0xB`” (hexadecimal). If both notations are used as [keys](https://yaml.org/spec/1.2.2/#nodes) in the same [mapping](https://yaml.org/spec/1.2.2/#mapping), only a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) which recognizes integer [formats](https://yaml.org/spec/1.2.2/#scalar-formats) would correctly flag the duplicate [key](https://yaml.org/spec/1.2.2/#nodes) as an error.
由于 YAML [映射](https://yaml.org/spec/1.2.2/#mapping)需要[键](https://yaml.org/spec/1.2.2/#nodes)唯一性，因此[表示](https://yaml.org/spec/1.2.2/#representation-graph)必须包含用于测试[节点](https://yaml.org/spec/1.2.2/#nodes)相等性的机制。这并非易事，因为 YAML 允许以各种方式[格式化标量内容](https://yaml.org/spec/1.2.2/#scalar-formats)。例如，整数 11 可以写为 “`0o13`” （八进制） 或 “`0xB`” （十六进制）。如果两种表示法都用作同一 [Map](https://yaml.org/spec/1.2.2/#mapping) 中的[键](https://yaml.org/spec/1.2.2/#nodes)，则只有 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)[会正确](https://yaml.org/spec/1.2.2/#scalar-formats)地将重复[的键](https://yaml.org/spec/1.2.2/#nodes)标记为错误。

- Canonical Form 规范形式

  ​    YAML supports the need for [scalar](https://yaml.org/spec/1.2.2/#scalar) equality by requiring that every [scalar](https://yaml.org/spec/1.2.2/#scalar) [tag](https://yaml.org/spec/1.2.2/#tags) must specify a mechanism for producing the *canonical form* of any [formatted content](https://yaml.org/spec/1.2.2/#scalar-formats). This form is a Unicode character string which also [presents](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) the same [content](https://yaml.org/spec/1.2.2/#nodes) and can be used for equality testing. YAML 支持[标量](https://yaml.org/spec/1.2.2/#scalar)相等性的需求，它要求每个[标量](https://yaml.org/spec/1.2.2/#scalar)[标签](https://yaml.org/spec/1.2.2/#tags)必须指定一种机制来生成任何 [格式化内容](https://yaml.org/spec/1.2.2/#scalar-formats)。此格式是一个 Unicode 字符串，它也[表示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)相同的 [内容](https://yaml.org/spec/1.2.2/#nodes)，可用于相等性测试。  

- Equality 平等

  ​    Two [nodes](https://yaml.org/spec/1.2.2/#nodes) must have the same [tag](https://yaml.org/spec/1.2.2/#tags) and [content](https://yaml.org/spec/1.2.2/#nodes) to be *equal*. Since each [tag](https://yaml.org/spec/1.2.2/#tags) applies to exactly one [kind](https://yaml.org/spec/1.2.2/#nodes), this implies that the two [nodes](https://yaml.org/spec/1.2.2/#nodes) must have the same [kind](https://yaml.org/spec/1.2.2/#nodes) to be equal. 两个[节点](https://yaml.org/spec/1.2.2/#nodes)必须具有相同的 [tag](https://yaml.org/spec/1.2.2/#tags) 和 [content](https://yaml.org/spec/1.2.2/#nodes) 才能*相等*。由于每个[标签](https://yaml.org/spec/1.2.2/#tags)只适用于一种[类型](https://yaml.org/spec/1.2.2/#nodes)，这意味着两个 [节点](https://yaml.org/spec/1.2.2/#nodes)必须具有相同的[类型](https://yaml.org/spec/1.2.2/#nodes)才能相等。  

  ​    Two [scalars](https://yaml.org/spec/1.2.2/#scalars) are equal only when their [tags](https://yaml.org/spec/1.2.2/#tags) and canonical forms are equal character-by-character. Equality of [collections](https://yaml.org/spec/1.2.2/#collections) is defined recursively. 仅当两个标量的[标签](https://yaml.org/spec/1.2.2/#tags)和规范形式逐个字符相等时，这两个[标量](https://yaml.org/spec/1.2.2/#scalars)才相等。[集合](https://yaml.org/spec/1.2.2/#collections)的相等性是递归定义的。  

  ​    Two [sequences](https://yaml.org/spec/1.2.2/#sequence) are equal only when they have the same [tag](https://yaml.org/spec/1.2.2/#tags) and length and each [node](https://yaml.org/spec/1.2.2/#nodes) in one [sequence](https://yaml.org/spec/1.2.2/#sequence) is equal to the corresponding [node](https://yaml.org/spec/1.2.2/#nodes) in the other [sequence](https://yaml.org/spec/1.2.2/#sequence). 只有当两个[序列](https://yaml.org/spec/1.2.2/#sequence)具有相同的 [tag](https://yaml.org/spec/1.2.2/#tags) 和 length 并且一个序列中的每个[节点](https://yaml.org/spec/1.2.2/#nodes)都等于另一个[序列](https://yaml.org/spec/1.2.2/#sequence)中的相应[节点](https://yaml.org/spec/1.2.2/#nodes)时，它们才相等 [序列](https://yaml.org/spec/1.2.2/#sequence)。  

  ​    Two [mappings](https://yaml.org/spec/1.2.2/#mapping) are equal only when they have the same [tag](https://yaml.org/spec/1.2.2/#tags) and an equal set of [keys](https://yaml.org/spec/1.2.2/#nodes) and each [key](https://yaml.org/spec/1.2.2/#nodes) in this set is associated with equal [values](https://yaml.org/spec/1.2.2/#nodes) in both [mappings](https://yaml.org/spec/1.2.2/#mapping). 只有当两个[映射](https://yaml.org/spec/1.2.2/#mapping)具有相同的[标签](https://yaml.org/spec/1.2.2/#tags)和相等的 [键](https://yaml.org/spec/1.2.2/#nodes)，并且此集中的每个[键](https://yaml.org/spec/1.2.2/#nodes)都与两者中的相等[值](https://yaml.org/spec/1.2.2/#nodes)相关联 [mappings](https://yaml.org/spec/1.2.2/#mapping) 映射。  

  ​    Different URI schemes may define different rules for testing the equality of URIs. Since a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) cannot be reasonably expected to be aware of them all, it must resort to a simple character-by-character comparison of [tags](https://yaml.org/spec/1.2.2/#tags) to ensure consistency. This also happens to be the comparison method defined by the “`tag:`” URI scheme. [Tags](https://yaml.org/spec/1.2.2/#tags) in a YAML stream must therefore be [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) in a canonical way so that such comparison would yield the correct results. 不同的 URI 方案可能定义不同的规则来测试 URI 的相等性。由于不能合理地期望 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)知道所有这些情况，因此它必须采用简单的逐字符标记[比较以确保一致性](https://yaml.org/spec/1.2.2/#tags)。这也恰好是由 “`tag：`” URI 定义的比较方法 方案。 因此，YAML 流中的[标签](https://yaml.org/spec/1.2.2/#tags)必须以规范方式[呈现](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，以便这种比较会产生正确的结果。  

  ​    If a node has itself as a descendant (via an alias), then determining the equality of that node is implementation-defined. 如果节点将自身作为后代（通过别名），则确定该节点的相等性是 implementation 定义的。  

  ​    A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may treat equal [scalars](https://yaml.org/spec/1.2.2/#scalars) as if they were identical. YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以将相等[的标量](https://yaml.org/spec/1.2.2/#scalars)视为相同。  

- Uniqueness 唯一性

  ​    A [mapping’s](https://yaml.org/spec/1.2.2/#mapping) [keys](https://yaml.org/spec/1.2.2/#nodes) are *unique* if no two keys are equal to each other. Obviously, identical nodes are always considered equal. *如果没有两个*键彼此相等，[则映射的](https://yaml.org/spec/1.2.2/#mapping)[键](https://yaml.org/spec/1.2.2/#nodes)是唯一的。显然，相同的节点始终被认为是相等的。  

### 3.2.2. Serialization Tree 3.2.2. 序列化树

To express a YAML [representation](https://yaml.org/spec/1.2.2/#representation-graph) using a serial API, it is necessary to impose an [order](https://yaml.org/spec/1.2.2/#mapping-key-order) on [mapping keys](https://yaml.org/spec/1.2.2/#nodes) and employ [alias nodes](https://yaml.org/spec/1.2.2/#alias-nodes) to indicate a subsequent occurrence of a previously encountered [node](https://yaml.org/spec/1.2.2/#nodes). The result of this process is a *serialization tree*, where each [node](https://yaml.org/spec/1.2.2/#nodes) has an ordered set of children. This tree can be traversed for a serial event-based API. [Construction](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) of [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) from the serial interface should not use [key order](https://yaml.org/spec/1.2.2/#mapping-key-order) or [anchor names](https://yaml.org/spec/1.2.2/#anchors-and-aliases) for the preservation of [application](https://yaml.org/spec/1.2.2/#processes-and-models) data.
要使用串行 API 表示 YAML [表示](https://yaml.org/spec/1.2.2/#representation-graph)，有必要对 [Map 键](https://yaml.org/spec/1.2.2/#nodes)施加[顺序](https://yaml.org/spec/1.2.2/#mapping-key-order)并使用[别名节点](https://yaml.org/spec/1.2.2/#alias-nodes)来指示先前遇到的[节点](https://yaml.org/spec/1.2.2/#nodes)的后续出现。此过程的结果是一个*序列化树*，其中每个[节点](https://yaml.org/spec/1.2.2/#nodes)都有一个 有序的子项集。 对于基于串行事件的 API，可以遍历此树。 从串行接口[构造](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)时，不应使用[键 order](https://yaml.org/spec/1.2.2/#mapping-key-order) 或 [anchor 名称](https://yaml.org/spec/1.2.2/#anchors-and-aliases)来保存[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)数据。

**Figure 3.4. Serialization Model
图 3.4.序列化模型**

![Serialization Model](https://yaml.org/spec/1.2.2/img/serialize2.svg)

#### 3.2.2.1. Mapping Key Order 3.2.2.1. 映射键顺序

In the [representation](https://yaml.org/spec/1.2.2/#representation-graph) model, [mapping keys](https://yaml.org/spec/1.2.2/#nodes) do not have an order. To [serialize](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) a [mapping](https://yaml.org/spec/1.2.2/#mapping), it is necessary to impose an *ordering* on its [keys](https://yaml.org/spec/1.2.2/#nodes). This order is a [serialization detail](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) and should not be used when [composing](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) the [representation graph](https://yaml.org/spec/1.2.2/#representation-graph) (and hence for the preservation of [application](https://yaml.org/spec/1.2.2/#processes-and-models) data). In every case where [node](https://yaml.org/spec/1.2.2/#nodes) order is significant, a [sequence](https://yaml.org/spec/1.2.2/#sequence) must be used. For example, an ordered [mapping](https://yaml.org/spec/1.2.2/#mapping) can be [represented](https://yaml.org/spec/1.2.2/#representation-graph) as a [sequence](https://yaml.org/spec/1.2.2/#sequence) of [mappings](https://yaml.org/spec/1.2.2/#mapping), where each [mapping](https://yaml.org/spec/1.2.2/#mapping) is a single [key/value pair](https://yaml.org/spec/1.2.2/#mapping). YAML provides convenient [compact notation](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values) for this case.
在[制图表达](https://yaml.org/spec/1.2.2/#representation-graph)模型中，[映射键](https://yaml.org/spec/1.2.2/#nodes)没有顺序。要[序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)[映射](https://yaml.org/spec/1.2.2/#mapping)，*必须对其* [键](https://yaml.org/spec/1.2.2/#nodes)。此顺序是[序列化详细信息](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)，在[撰写](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)时不应使用 [表示图](https://yaml.org/spec/1.2.2/#representation-graph)（因此为了保留[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models) 数据）。 在[节点](https://yaml.org/spec/1.2.2/#nodes)顺序很重要的每种情况下，都必须使用[序列](https://yaml.org/spec/1.2.2/#sequence)。例如，有序[映射](https://yaml.org/spec/1.2.2/#mapping)可以[表示](https://yaml.org/spec/1.2.2/#representation-graph)为 [mappings](https://yaml.org/spec/1.2.2/#mapping)，其中每个 [mapping](https://yaml.org/spec/1.2.2/#mapping) 都是一个[键/值对](https://yaml.org/spec/1.2.2/#mapping)。YAML 为这种情况提供了方便的 [compact 表示法](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values)。

#### 3.2.2.2. Anchors and Aliases 3.2.2.2. 锚点和别名

In the [representation graph](https://yaml.org/spec/1.2.2/#representation-graph), a [node](https://yaml.org/spec/1.2.2/#nodes) may appear in more than one [collection](https://yaml.org/spec/1.2.2/#collections). When [serializing](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) such data, the first occurrence of the [node](https://yaml.org/spec/1.2.2/#nodes) is *identified* by an *anchor*. Each subsequent occurrence is [serialized](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) as an [alias node](https://yaml.org/spec/1.2.2/#alias-nodes) which refers back to this anchor. Otherwise, anchor names are a [serialization detail](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) and are discarded once [composing](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) is completed. When [composing](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) a [representation graph](https://yaml.org/spec/1.2.2/#representation-graph) from [serialized](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) events, an alias event refers to the most recent event in the [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) having the specified anchor. Therefore, anchors need not be unique within a [serialization](https://yaml.org/spec/1.2.2/#serialization-tree). In addition, an anchor need not have an alias node referring to it.
在[表示图](https://yaml.org/spec/1.2.2/#representation-graph)中，一个[节点](https://yaml.org/spec/1.2.2/#nodes)可能会出现在多个节点中 [集合](https://yaml.org/spec/1.2.2/#collections)。[在序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)此类数据时，[节点](https://yaml.org/spec/1.2.2/#nodes)的第一个匹配项是 由*锚点**标识*。每个后续匹配项都[序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)为一个[别名节点](https://yaml.org/spec/1.2.2/#alias-nodes)，该节点引用回此锚点。否则，锚点名称是[序列化详细信息](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)，将被丢弃一次 [composing](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) 完成。从[序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)事件[组成](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[表示图](https://yaml.org/spec/1.2.2/#representation-graph)时，别名事件是指[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)中具有指定锚点的最新事件。因此，锚点在[序列化](https://yaml.org/spec/1.2.2/#serialization-tree)中不需要是唯一的。此外，锚点不需要具有引用它的别名节点。

### 3.2.3. Presentation Stream 3.2.3. 演示流

A YAML *presentation* is a [stream](https://yaml.org/spec/1.2.2/#streams) of Unicode characters making use of [styles](https://yaml.org/spec/1.2.2/#node-styles), [scalar content formats](https://yaml.org/spec/1.2.2/#scalar-formats), [comments](https://yaml.org/spec/1.2.2/#comments), [directives](https://yaml.org/spec/1.2.2/#directives) and other [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) to [present](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) a YAML [serialization](https://yaml.org/spec/1.2.2/#serialization-tree) in a human readable way. YAML allows several [serialization trees](https://yaml.org/spec/1.2.2/#serialization-tree) to be contained in the same YAML presentation stream, as a series of [documents](https://yaml.org/spec/1.2.2/#documents) separated by [markers](https://yaml.org/spec/1.2.2/#document-markers).
YAML *表示*是 Unicode 字符[流](https://yaml.org/spec/1.2.2/#streams)，它使用 [样式](https://yaml.org/spec/1.2.2/#node-styles)、[标量内容格式](https://yaml.org/spec/1.2.2/#scalar-formats)、[注释](https://yaml.org/spec/1.2.2/#comments)、[指令](https://yaml.org/spec/1.2.2/#directives)和其他 [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) 以人类可读的方式[呈现](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) YAML [序列化](https://yaml.org/spec/1.2.2/#serialization-tree)。YAML 允许将多个[序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)包含在同一个 YAML 表示流中，作为由[标记](https://yaml.org/spec/1.2.2/#document-markers)分隔的一系列[文档](https://yaml.org/spec/1.2.2/#documents)。

**Figure 3.5. Presentation Model
图 3.5.演示模型**

![Presentation Model](https://yaml.org/spec/1.2.2/img/present2.svg)

#### 3.2.3.1. Node Styles 3.2.3.1. 节点样式

Each [node](https://yaml.org/spec/1.2.2/#nodes) is presented in some *style*, depending on its [kind](https://yaml.org/spec/1.2.2/#nodes). The node style is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and is not reflected in the [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree) or [representation graph](https://yaml.org/spec/1.2.2/#representation-graph). There are two groups of styles. [Block styles](https://yaml.org/spec/1.2.2/#block-style-productions) use [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) to denote structure. In contrast, [flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions) rely on explicit [indicators](https://yaml.org/spec/1.2.2/#indicator-characters).
每个[节点](https://yaml.org/spec/1.2.2/#nodes)都以某种*样式*显示，具体取决于其[类型](https://yaml.org/spec/1.2.2/#nodes)。节点样式是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不会反映在 [序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)或[表示图](https://yaml.org/spec/1.2.2/#representation-graph)。 样式分为两组。 [块样式](https://yaml.org/spec/1.2.2/#block-style-productions)使用[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)来表示结构。相比之下，[流式样式](https://yaml.org/spec/1.2.2/#flow-style-productions)依赖于显式[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)。

YAML provides a rich set of *scalar styles*. [Block scalar](https://yaml.org/spec/1.2.2/#block-scalar-styles) styles include the [literal style](https://yaml.org/spec/1.2.2/#literal-style) and the [folded style](https://yaml.org/spec/1.2.2/#folded-style). [Flow scalar](https://yaml.org/spec/1.2.2/#flow-scalar-styles) styles include the [plain style](https://yaml.org/spec/1.2.2/#plain-style) and two quoted styles, the [single-quoted style](https://yaml.org/spec/1.2.2/#single-quoted-style) and the [double-quoted style](https://yaml.org/spec/1.2.2/#double-quoted-style). These styles offer a range of trade-offs between expressive power and readability.
YAML 提供了一组丰富的*标量样式*。 [块标量](https://yaml.org/spec/1.2.2/#block-scalar-styles)样式包括 [Literal 样式](https://yaml.org/spec/1.2.2/#literal-style)和 [folded 样式](https://yaml.org/spec/1.2.2/#folded-style)。 [流标量](https://yaml.org/spec/1.2.2/#flow-scalar-styles)样式包括 [plain 样式](https://yaml.org/spec/1.2.2/#plain-style)和两种带引号的样式，即 [单引号样式](https://yaml.org/spec/1.2.2/#single-quoted-style)和[双引号样式](https://yaml.org/spec/1.2.2/#double-quoted-style)。这些样式在表现力和可读性之间提供了一系列权衡。

Normally, [block sequences](https://yaml.org/spec/1.2.2/#block-sequences) and [mappings](https://yaml.org/spec/1.2.2/#mapping) begin on the next line. In some cases, YAML also allows nested [block](https://yaml.org/spec/1.2.2/#scalars) [collections](https://yaml.org/spec/1.2.2/#collections) to start in-line for a more [compact notation](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values). In addition, YAML provides a [compact notation](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values) for [flow mappings](https://yaml.org/spec/1.2.2/#flow-mappings) with a single [key/value pair](https://yaml.org/spec/1.2.2/#mapping), nested inside a [flow sequence](https://yaml.org/spec/1.2.2/#flow-sequences). These allow for a natural “ordered mapping” notation.
通常，[块序列](https://yaml.org/spec/1.2.2/#block-sequences)和[映射](https://yaml.org/spec/1.2.2/#mapping)从下一行开始。在某些情况下，YAML 还允许嵌套[块](https://yaml.org/spec/1.2.2/#scalars)[集合](https://yaml.org/spec/1.2.2/#collections)内联启动，以获得更[紧凑的表示法](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values)。此外，YAML 还为[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)提供了[紧凑的表示法](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values)，其中包含嵌套在[流序列](https://yaml.org/spec/1.2.2/#flow-sequences)中的单个[键/值对](https://yaml.org/spec/1.2.2/#mapping)。这些允许自然的 “有序映射” 表示法。

**Figure 3.6. Kind/Style Combinations
图 3.6.种类/样式组合**

![Kind/Style Combinations](https://yaml.org/spec/1.2.2/img/styles2.svg)

#### 3.2.3.2. Scalar Formats 3.2.3.2. 标量格式

YAML allows [scalars](https://yaml.org/spec/1.2.2/#scalars) to be [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) in several *formats*. For example, the integer “`11`” might also be written as “`0xB`”. [Tags](https://yaml.org/spec/1.2.2/#tags) must specify a mechanism for converting the formatted content to a [canonical form](https://yaml.org/spec/1.2.2/#canonical-form) for use in [equality](https://yaml.org/spec/1.2.2/#equality) testing. Like [node style](https://yaml.org/spec/1.2.2/#node-styles), the format is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and is not reflected in the [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree) and [representation graph](https://yaml.org/spec/1.2.2/#representation-graph).
YAML 允许以多种*格式*[呈现](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)[标量](https://yaml.org/spec/1.2.2/#scalars)。例如，整数 “`11`” 也可以写为 “`0xB`”。 [标记](https://yaml.org/spec/1.2.2/#tags)必须指定一种机制，用于将格式化内容转换为 用于[相等](https://yaml.org/spec/1.2.2/#equality)性测试的[规范形式](https://yaml.org/spec/1.2.2/#canonical-form)。与[节点样式](https://yaml.org/spec/1.2.2/#node-styles)一样，格式是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不会反映在[序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)和[表示图](https://yaml.org/spec/1.2.2/#representation-graph)中。

#### 3.2.3.3. Comments 3.2.3.3. 注释

[Comments](https://yaml.org/spec/1.2.2/#comments) are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not have any effect on the [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree) or [representation graph](https://yaml.org/spec/1.2.2/#representation-graph). In particular, comments are not associated with a particular [node](https://yaml.org/spec/1.2.2/#nodes). The usual purpose of a comment is to communicate between the human maintainers of a file. A typical example is comments in a configuration file. Comments must not appear inside [scalars](https://yaml.org/spec/1.2.2/#scalars), but may be interleaved with such [scalars](https://yaml.org/spec/1.2.2/#scalars) inside [collections](https://yaml.org/spec/1.2.2/#collections).
[注释](https://yaml.org/spec/1.2.2/#comments)是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得对 [序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)或[表示图](https://yaml.org/spec/1.2.2/#representation-graph)。特别是，注释不与特定[节点](https://yaml.org/spec/1.2.2/#nodes)关联。注释的通常目的是在文件的人类维护者之间进行交流。一个典型的示例是配置文件中的 comments。注释不得出现在[标量](https://yaml.org/spec/1.2.2/#scalars)内，但可以与此类 [标量](https://yaml.org/spec/1.2.2/#scalars)。

#### 3.2.3.4. Directives 3.2.3.4. 指令

Each [document](https://yaml.org/spec/1.2.2/#documents) may be associated with a set of [directives](https://yaml.org/spec/1.2.2/#directives). A directive has a name and an optional sequence of parameters. Directives are instructions to the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) and like all other [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) are not reflected in the YAML [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree) or [representation graph](https://yaml.org/spec/1.2.2/#representation-graph). This version of YAML defines two directives, “`YAML`” and “`TAG`”. All other directives are [reserved](https://yaml.org/spec/1.2.2/#directives) for future versions of YAML.
每个[文档](https://yaml.org/spec/1.2.2/#documents)都可以与一组[指令](https://yaml.org/spec/1.2.2/#directives)相关联。指令具有 name 和可选的参数序列。指令是 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)的指令，与所有其他指令一样 [表示详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)未反映在 YAML [序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)中，或者 [表示图](https://yaml.org/spec/1.2.2/#representation-graph)。此版本的 YAML 定义了两个指令，“`YAML`”和“`TAG`”。所有其他指令都[保留](https://yaml.org/spec/1.2.2/#directives)给 YAML 的未来版本。

## 3.3. Loading Failure Points 3.3. 加载故障点

The process of [loading](https://yaml.org/spec/1.2.2/#load) [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) from a YAML [stream](https://yaml.org/spec/1.2.2/#streams) has several potential *failure points*. The character [stream](https://yaml.org/spec/1.2.2/#streams) may be [ill-formed](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases), [aliases](https://yaml.org/spec/1.2.2/#anchors-and-aliases) may be [unidentified](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases), [unspecified tags](https://yaml.org/spec/1.2.2/#resolved-tags) may be [unresolvable](https://yaml.org/spec/1.2.2/#resolved-tags), [tags](https://yaml.org/spec/1.2.2/#tags) may be [unrecognized](https://yaml.org/spec/1.2.2/#recognized-and-valid-tags), the [content](https://yaml.org/spec/1.2.2/#nodes) may be [invalid](https://yaml.org/spec/1.2.2/#recognized-and-valid-tags), [mapping](https://yaml.org/spec/1.2.2/#mapping) [keys](https://yaml.org/spec/1.2.2/#nodes) may not be [unique](https://yaml.org/spec/1.2.2/#node-comparison) and a native type may be [unavailable](https://yaml.org/spec/1.2.2/#available-tags). Each of these failures results with an incomplete loading.
从 YAML [流](https://yaml.org/spec/1.2.2/#streams)[加载](https://yaml.org/spec/1.2.2/#load)[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)的过程有几个潜在的*故障点*。字符[流](https://yaml.org/spec/1.2.2/#streams)可能[格式不正确](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases)，[别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases)可能[未识别](https://yaml.org/spec/1.2.2/#well-formed-streams-and-identified-aliases)， [未指定的标签](https://yaml.org/spec/1.2.2/#resolved-tags)可能无法[解析](https://yaml.org/spec/1.2.2/#resolved-tags)，[标签](https://yaml.org/spec/1.2.2/#tags)可能无法[识别](https://yaml.org/spec/1.2.2/#recognized-and-valid-tags)，则 [内容](https://yaml.org/spec/1.2.2/#nodes)可能[无效](https://yaml.org/spec/1.2.2/#recognized-and-valid-tags)，[映射](https://yaml.org/spec/1.2.2/#mapping)[键](https://yaml.org/spec/1.2.2/#nodes)可能不[唯一](https://yaml.org/spec/1.2.2/#node-comparison)，并且本机类型[可能不可用](https://yaml.org/spec/1.2.2/#available-tags)。这些失败中的每一个都会导致加载不完整。

A *partial representation* need not [resolve](https://yaml.org/spec/1.2.2/#resolved-tags) the [tag](https://yaml.org/spec/1.2.2/#tags) of each [node](https://yaml.org/spec/1.2.2/#nodes) and the [canonical form](https://yaml.org/spec/1.2.2/#canonical-form) of [formatted scalar content](https://yaml.org/spec/1.2.2/#scalar-formats) need not be available. This weaker representation is useful for cases of incomplete knowledge of the types used in the [document](https://yaml.org/spec/1.2.2/#documents).
*部分表示*不需要[解析](https://yaml.org/spec/1.2.2/#resolved-tags)每个[节点](https://yaml.org/spec/1.2.2/#nodes)的 [tag](https://yaml.org/spec/1.2.2/#tags) 和 [格式化标量内容的](https://yaml.org/spec/1.2.2/#scalar-formats)[规范形式](https://yaml.org/spec/1.2.2/#canonical-form)不需要可用。这种较弱的表示形式对于文档中使用的类型不完全了解的情况[很有用。](https://yaml.org/spec/1.2.2/#documents)

In contrast, a *complete representation* specifies the [tag](https://yaml.org/spec/1.2.2/#tags) of each [node](https://yaml.org/spec/1.2.2/#nodes) and provides the [canonical form](https://yaml.org/spec/1.2.2/#canonical-form) of [formatted scalar content](https://yaml.org/spec/1.2.2/#scalar-formats), allowing for [equality](https://yaml.org/spec/1.2.2/#equality) testing. A complete representation is required in order to [construct](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures).
相反，*完整的表示*指定了每个[节点](https://yaml.org/spec/1.2.2/#nodes)的[标签](https://yaml.org/spec/1.2.2/#tags)，并提供了[格式化标量内容的](https://yaml.org/spec/1.2.2/#scalar-formats)[规范形式](https://yaml.org/spec/1.2.2/#canonical-form)，允许 [相等](https://yaml.org/spec/1.2.2/#equality)性测试。为了[构建](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)[原生数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)，需要一个完整的表示。

**Figure 3.7. Loading Failure Points
图 3.7.加载故障点**

![Loading Failure Points](https://yaml.org/spec/1.2.2/img/validity2.svg)

### 3.3.1. Well-Formed Streams and Identified Aliases 3.3.1. 格式正确的流和已识别的别名

A [well-formed](https://yaml.org/spec/1.2.2/#example-stream) character [stream](https://yaml.org/spec/1.2.2/#streams) must match the BNF productions specified in the following chapters. Successful loading also requires that each [alias](https://yaml.org/spec/1.2.2/#anchors-and-aliases) shall refer to a previous [node](https://yaml.org/spec/1.2.2/#nodes) [identified](https://yaml.org/spec/1.2.2/#anchors-and-aliases) by the [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases). A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should reject *ill-formed streams* and *unidentified aliases*. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may recover from syntax errors, possibly by ignoring certain parts of the input, but it must provide a mechanism for reporting such errors.
[格式正确的](https://yaml.org/spec/1.2.2/#example-stream)字符[流](https://yaml.org/spec/1.2.2/#streams)必须与以下章节中指定的 BNF 产品匹配。成功加载还要求每个[别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases)都应引用上一个 [由](https://yaml.org/spec/1.2.2/#nodes)[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)[标识](https://yaml.org/spec/1.2.2/#anchors-and-aliases)的节点。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应拒绝*格式错误的流*和*未识别的别名*。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以通过忽略 Importing 的某些部分从语法错误中恢复，但它必须提供一种报告此类错误的机制。

### 3.3.2. Resolved Tags 3.3.2. 已解析的标签

Typically, most [tags](https://yaml.org/spec/1.2.2/#tags) are not explicitly specified in the character [stream](https://yaml.org/spec/1.2.2/#streams). During [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream), [nodes](https://yaml.org/spec/1.2.2/#nodes) lacking an explicit [tag](https://yaml.org/spec/1.2.2/#tags) are given a *non-specific tag*: “`!`” for non-[plain scalars](https://yaml.org/spec/1.2.2/#plain-style) and “`?`” for all other [nodes](https://yaml.org/spec/1.2.2/#nodes). [Composing](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) a [complete representation](https://yaml.org/spec/1.2.2/#loading-failure-points) requires each such non-specific tag to be *resolved* to a *specific tag*, be it a [global tag](https://yaml.org/spec/1.2.2/#tags) or a [local tag](https://yaml.org/spec/1.2.2/#tags).
通常，大多数[标签](https://yaml.org/spec/1.2.2/#tags)不会在字符[流](https://yaml.org/spec/1.2.2/#streams)中显式指定。在[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)过程中，缺少显式[标签](https://yaml.org/spec/1.2.2/#tags)的[节点](https://yaml.org/spec/1.2.2/#nodes)将被赋予*一个非特定标签*：“`！`”（对于非[纯标量](https://yaml.org/spec/1.2.2/#plain-style)），“`？`”（对于所有其他[节点](https://yaml.org/spec/1.2.2/#nodes)）。 [编写](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[完整的表示](https://yaml.org/spec/1.2.2/#loading-failure-points)需要将每个此类非特定标记*解析*为*特定标记*，无论是[全局标记](https://yaml.org/spec/1.2.2/#tags)还是[本地标记](https://yaml.org/spec/1.2.2/#tags)。

Resolving the [tag](https://yaml.org/spec/1.2.2/#tags) of a [node](https://yaml.org/spec/1.2.2/#nodes) must only depend on the following three parameters: (1) the non-specific tag of the [node](https://yaml.org/spec/1.2.2/#nodes), (2) the path leading from the [root](https://yaml.org/spec/1.2.2/#representation-graph) to the [node](https://yaml.org/spec/1.2.2/#nodes) and (3) the [content](https://yaml.org/spec/1.2.2/#nodes) (and hence the [kind](https://yaml.org/spec/1.2.2/#nodes)) of the [node](https://yaml.org/spec/1.2.2/#nodes). When a [node](https://yaml.org/spec/1.2.2/#nodes) has more than one occurrence (using [aliases](https://yaml.org/spec/1.2.2/#anchors-and-aliases)), tag resolution must depend only on the path to the first ([anchored](https://yaml.org/spec/1.2.2/#anchors-and-aliases)) occurrence of the [node](https://yaml.org/spec/1.2.2/#nodes).
解析[节点](https://yaml.org/spec/1.2.2/#nodes)的[标签](https://yaml.org/spec/1.2.2/#tags)必须仅取决于以下三个参数：（1） [节点](https://yaml.org/spec/1.2.2/#nodes)的非特定标签，（2） 从[根](https://yaml.org/spec/1.2.2/#representation-graph)到[节点](https://yaml.org/spec/1.2.2/#nodes)的路径，以及 （3） [内容（以及](https://yaml.org/spec/1.2.2/#nodes)  [节点](https://yaml.org/spec/1.2.2/#nodes)。当[节点](https://yaml.org/spec/1.2.2/#nodes)有多个匹配项（使用[别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases)）时，标记解析必须仅取决于 [节点](https://yaml.org/spec/1.2.2/#nodes)。

Note that resolution must not consider [presentation details](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) such as [comments](https://yaml.org/spec/1.2.2/#comments), [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) and [node style](https://yaml.org/spec/1.2.2/#node-styles). Also, resolution must not consider the [content](https://yaml.org/spec/1.2.2/#nodes) of any other [node](https://yaml.org/spec/1.2.2/#nodes), except for the [content](https://yaml.org/spec/1.2.2/#nodes) of the [key nodes](https://yaml.org/spec/1.2.2/#mapping) directly along the path leading from the [root](https://yaml.org/spec/1.2.2/#representation-graph) to the resolved [node](https://yaml.org/spec/1.2.2/#nodes). Finally, resolution must not consider the [content](https://yaml.org/spec/1.2.2/#nodes) of a sibling [node](https://yaml.org/spec/1.2.2/#nodes) in a [collection](https://yaml.org/spec/1.2.2/#collections) or the [content](https://yaml.org/spec/1.2.2/#nodes) of the [value node](https://yaml.org/spec/1.2.2/#nodes) associated with a [key node](https://yaml.org/spec/1.2.2/#mapping) being resolved.
请注意，分辨率不得考虑[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，例如 [注释](https://yaml.org/spec/1.2.2/#comments)、[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)和[节点样式](https://yaml.org/spec/1.2.2/#node-styles)。此外，解析不得考虑任何其他[节点](https://yaml.org/spec/1.2.2/#nodes)[的内容](https://yaml.org/spec/1.2.2/#nodes)，但直接沿路径的关键[节点](https://yaml.org/spec/1.2.2/#mapping)[的内容](https://yaml.org/spec/1.2.2/#nodes)除外 [root](https://yaml.org/spec/1.2.2/#representation-graph) 设置为已解析[的节点](https://yaml.org/spec/1.2.2/#nodes)。最后，解析不得考虑  [集合](https://yaml.org/spec/1.2.2/#collections)或与[键节点](https://yaml.org/spec/1.2.2/#mapping)关联的[值节点](https://yaml.org/spec/1.2.2/#nodes)[的内容](https://yaml.org/spec/1.2.2/#nodes) 正在解决。

These rules ensure that tag resolution can be performed as soon as a [node](https://yaml.org/spec/1.2.2/#nodes) is first encountered in the [stream](https://yaml.org/spec/1.2.2/#streams), typically before its [content](https://yaml.org/spec/1.2.2/#nodes) is [parsed](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream). Also, tag resolution only requires referring to a relatively small number of previously parsed [nodes](https://yaml.org/spec/1.2.2/#nodes). Thus, in most cases, tag resolution in one-pass [processors](https://yaml.org/spec/1.2.2/#processes-and-models) is both possible and practical.
这些规则可确保在[流](https://yaml.org/spec/1.2.2/#streams)中首次遇到[节点](https://yaml.org/spec/1.2.2/#nodes)时（通常在[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)其[内容](https://yaml.org/spec/1.2.2/#nodes)之前）可以执行标记解析。此外，标签解析只需要引用相对较少的先前解析[的节点](https://yaml.org/spec/1.2.2/#nodes)。因此，在大多数情况下，one-pass [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)中的标签解析既可能又实用。

YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) should resolve [nodes](https://yaml.org/spec/1.2.2/#nodes) having the “`!`” non-specific tag as “`tag:yaml.org,2002:seq`”, “`tag:yaml.org,2002:map`” or “`tag:yaml.org,2002:str`” depending on their [kind](https://yaml.org/spec/1.2.2/#nodes). This *tag resolution convention* allows the author of a YAML character [stream](https://yaml.org/spec/1.2.2/#streams) to effectively “disable” the tag resolution process. By explicitly specifying a “`!`” non-specific [tag property](https://yaml.org/spec/1.2.2/#node-tags), the [node](https://yaml.org/spec/1.2.2/#nodes) would then be resolved to a “vanilla” [sequence](https://yaml.org/spec/1.2.2/#sequence), [mapping](https://yaml.org/spec/1.2.2/#mapping) or string, according to its [kind](https://yaml.org/spec/1.2.2/#nodes).
YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应根据[其类型](https://yaml.org/spec/1.2.2/#nodes)将具有 “`！`” 非特定标签的[节点](https://yaml.org/spec/1.2.2/#nodes)解析为 “`tag：yaml.org，2002：seq`”、“`tag：yaml.org，2002：map`” 或 “`tag：yaml.org，2002：str`”。此*标记解析约定*允许 YAML 字符[流](https://yaml.org/spec/1.2.2/#streams)的作者 以有效地“禁用”标签解析过程。 通过显式指定 “`！`” 非特定[标签属性](https://yaml.org/spec/1.2.2/#node-tags)，[节点将根据其](https://yaml.org/spec/1.2.2/#nodes)[类型](https://yaml.org/spec/1.2.2/#nodes)解析为 “vanilla” [序列](https://yaml.org/spec/1.2.2/#sequence)、[映射](https://yaml.org/spec/1.2.2/#mapping)或字符串。

[Application](https://yaml.org/spec/1.2.2/#processes-and-models) specific tag resolution rules should be restricted to resolving the “`?`” non-specific tag, most commonly to resolving [plain scalars](https://yaml.org/spec/1.2.2/#plain-style). These may be matched against a set of regular expressions to provide automatic resolution of integers, floats, timestamps and similar types. An [application](https://yaml.org/spec/1.2.2/#processes-and-models) may also match the [content](https://yaml.org/spec/1.2.2/#nodes) of [mapping nodes](https://yaml.org/spec/1.2.2/#mapping) against sets of expected [keys](https://yaml.org/spec/1.2.2/#nodes) to automatically resolve points, complex numbers and similar types. Resolved [sequence node](https://yaml.org/spec/1.2.2/#sequence) types such as the “ordered mapping” are also possible.
[应用程序特定的](https://yaml.org/spec/1.2.2/#processes-and-models)标签解析规则应仅限于解析 “`？”` 非特定标签，最常见的是解析[普通标量](https://yaml.org/spec/1.2.2/#plain-style)。这些可以与一组正则表达式进行匹配，以提供整数、浮点数、时间戳和类似类型的自动解析。[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)还可以将[映射节点](https://yaml.org/spec/1.2.2/#mapping)[的内容](https://yaml.org/spec/1.2.2/#nodes)与预期的[键](https://yaml.org/spec/1.2.2/#nodes)集进行匹配，以自动解析点、复数和类似类型。解析的[序列节点](https://yaml.org/spec/1.2.2/#sequence)类型（例如 “ordered mapping”）也是可能的。

That said, tag resolution is specific to the [application](https://yaml.org/spec/1.2.2/#processes-and-models). YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) should therefore provide a mechanism allowing the [application](https://yaml.org/spec/1.2.2/#processes-and-models) to override and expand these default tag resolution rules.
也就是说，标签解析特定于[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)。因此，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应提供一种机制，允许 [应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)来覆盖和扩展这些默认标签解析规则。

If a [document](https://yaml.org/spec/1.2.2/#documents) contains *unresolved tags*, the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) is unable to [compose](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) a [complete representation](https://yaml.org/spec/1.2.2/#loading-failure-points) graph. In such a case, the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may [compose](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) a [partial representation](https://yaml.org/spec/1.2.2/#loading-failure-points), based on each [node’s kind](https://yaml.org/spec/1.2.2/#nodes) and allowing for non-specific tags.
如果[文档](https://yaml.org/spec/1.2.2/#documents)包含*未解析的标记*，则 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)无法 [组成](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[一个完整的表示](https://yaml.org/spec/1.2.2/#loading-failure-points)图。在这种情况下， YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以根据每个[节点的种类](https://yaml.org/spec/1.2.2/#nodes)[组成](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[部分表示](https://yaml.org/spec/1.2.2/#loading-failure-points)形式，并允许非特定标签。

### 3.3.3. Recognized and Valid Tags 3.3.3. 已识别和有效的标签

To be *valid*, a [node](https://yaml.org/spec/1.2.2/#nodes) must have a [tag](https://yaml.org/spec/1.2.2/#tags) which is *recognized* by the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) and its [content](https://yaml.org/spec/1.2.2/#nodes) must satisfy the constraints imposed by this [tag](https://yaml.org/spec/1.2.2/#tags). If a [document](https://yaml.org/spec/1.2.2/#documents) contains a [scalar node](https://yaml.org/spec/1.2.2/#nodes) with an *unrecognized tag* or *invalid content*, only a [partial representation](https://yaml.org/spec/1.2.2/#loading-failure-points) may be [composed](https://yaml.org/spec/1.2.2/#composing-the-representation-graph). In contrast, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) can always [compose](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) a [complete representation](https://yaml.org/spec/1.2.2/#loading-failure-points) for an unrecognized or an invalid [collection](https://yaml.org/spec/1.2.2/#collections), since [collection](https://yaml.org/spec/1.2.2/#collections) [equality](https://yaml.org/spec/1.2.2/#equality) does not depend upon knowledge of the [collection’s](https://yaml.org/spec/1.2.2/#mapping) data type. However, such a [complete representation](https://yaml.org/spec/1.2.2/#loading-failure-points) cannot be used to [construct](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) a [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures).
要*有效*，[节点](https://yaml.org/spec/1.2.2/#nodes)必须具有 YAML *可识别*的[标签](https://yaml.org/spec/1.2.2/#tags) [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)及其[内容](https://yaml.org/spec/1.2.2/#nodes)必须满足此 [标签](https://yaml.org/spec/1.2.2/#tags)。如果[文档](https://yaml.org/spec/1.2.2/#documents)包含具有*无法识别的标记*或*无效内容的*[标量节点](https://yaml.org/spec/1.2.2/#nodes)，则只能[组成](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[部分表示](https://yaml.org/spec/1.2.2/#loading-failure-points)。相比之下，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)始终可以为无法识别或无效的[集合](https://yaml.org/spec/1.2.2/#collections)[编写](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[完整的表示](https://yaml.org/spec/1.2.2/#loading-failure-points)形式，因为 [集合](https://yaml.org/spec/1.2.2/#collections)[相等](https://yaml.org/spec/1.2.2/#equality)性不依赖于对[集合的](https://yaml.org/spec/1.2.2/#mapping) 数据类型。 但是，这种[完整的表示](https://yaml.org/spec/1.2.2/#loading-failure-points)不能用于[构造](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) [本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)。

### 3.3.4. Available Tags 3.3.4. 可用标签

In a given processing environment, there need not be an *available* native type corresponding to a given [tag](https://yaml.org/spec/1.2.2/#tags). If a [node’s tag](https://yaml.org/spec/1.2.2/#tags) is *unavailable*, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) will not be able to [construct](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) a [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures) for it. In this case, a [complete representation](https://yaml.org/spec/1.2.2/#loading-failure-points) may still be [composed](https://yaml.org/spec/1.2.2/#composing-the-representation-graph) and an [application](https://yaml.org/spec/1.2.2/#processes-and-models) may wish to use this [representation](https://yaml.org/spec/1.2.2/#representation-graph) directly.
在给定的处理环境中，不需要有与给定[标签](https://yaml.org/spec/1.2.2/#tags)对应的*可用*本机类型。如果[节点的标签](https://yaml.org/spec/1.2.2/#tags)*不可用*，则 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)将无法 [为其构建](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)。在这种情况下，可能仍会[组成](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)[一个完整的表示](https://yaml.org/spec/1.2.2/#loading-failure-points)，并且 [应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)可能希望直接使用此[表示](https://yaml.org/spec/1.2.2/#representation-graph)形式。

# Chapter 4. Syntax Conventions 第 4 章.语法约定

The following chapters formally define the syntax of YAML character [streams](https://yaml.org/spec/1.2.2/#streams), using parameterized BNF productions. Each BNF production is both named and numbered for easy reference. Whenever possible, basic structures are specified before the more complex structures using them in a “bottom up” fashion.
以下章节使用参数化 BNF 生产正式定义 YAML 字符[流](https://yaml.org/spec/1.2.2/#streams)的语法。每部 BNF 作品都有命名和编号，以便于参考。只要有可能，在更复杂的结构之前，以 “自下而上” 的方式指定基本结构。

The productions are accompanied by examples which are presented in a two-pane side-by-side format. The left-hand side is the YAML example and the right-hand side is an alternate YAML view of the example. The right-hand view uses JSON when possible. Otherwise it uses a YAML form that is as close to JSON as possible.
这些作品附有示例，这些示例以两窗格并排格式呈现。左侧是 YAML 示例，右侧是该示例的备用 YAML 视图。右侧视图尽可能使用 JSON。否则，它使用尽可能接近 JSON 的 YAML 表单。

## 4.1. Production Syntax 4.1. 生产语法

Productions are defined using the syntax `production-name ::= term`, where a term is either:
使用语法 `production-name ：：= 术语`定义作品，其中术语是：

- An atomic term 原子项

  ​          A quoted string (`"abc"`), which matches that concatenation of characters. A single character is usually written with single quotes (`'a'`). 带引号的字符串 （`“abc”`），它与字符的串联匹配。单个字符通常用单引号 （`'a'`） 书写。      A hexadecimal number (`x0A`), which matches the character at that Unicode code point. 一个十六进制数 （`x0A`），它与该 Unicode 码位处的字符匹配。      A range of hexadecimal numbers (`[x20-x7E]`), which matches any character whose Unicode code point is within that range. 十六进制数字范围 （`[x20-x7E]`），它与 Unicode 码位在该范围内的任何字符匹配。      The name of a production (`c-printable`), which matches that production. 作品的名称 （`c-printable`），与该作品匹配。      

- A lookaround 回顾

  ​          `[ lookahead = term ]`, which matches the empty string if `term` would match. `[ lookahead = term ]`，如果 `term` 匹配，则匹配空字符串。      `[ lookahead ≠ term ]`, which matches the empty string if `term` would not match. `[ lookahead ≠ term ]`，如果 `term` 不匹配，则匹配空字符串。      `[ lookbehind = term ]`, which matches the empty string if `term` would match beginning at any prior point on the line and ending at the current position. `[ lookbehind = term ]`，如果 `term` 匹配从行上的任何先前点开始到当前位置结束，则匹配空字符串。      

- A special production 特殊生产

  ​          `<start-of-line>`, which matches the empty string at the beginning of a line. `<linestart-of-line>`，它与行首的空字符串匹配。      `<end-of-input>`, matches the empty string at the end of the input. `<end-of-input>`，匹配输入末尾的空字符串。      `<empty>`, which (always) matches the empty string. `<empty>`，它（始终）匹配空字符串。      

- A parenthesized term 带括号的术语

  ​    Matches its contents. 匹配其内容。  

- A concatenation 串联

  ​    Is `term-one term-two`, which matches `term-one` followed by `term-two`. 是 `term-one term-two`，它与 `term-one` 后跟 `term-two` 匹配。  

- A alternation 交替

  ​    Is `term-one | term-two`, which matches the `term-one` if possible, or `term-two` otherwise. 是 `term-one | term-two`，如果可能，则与`术语 1` 匹配，或者 `否则为 term-two`。  

- A quantified term: 量化术语：

  ​          `term?`, which matches `(term | <empty>)`. `term？`，它与 `（term | <empty>）` 匹配。      `term*`, which matches `(term term* | <empty>)`. `term*` 匹配 `（term term* | <empty>）。`      `term+`, which matches `(term term*)`. `term+`，它与 `（term term*）` 匹配。      

> Note: Quantified terms are always greedy.
> 注意：量化的项总是贪婪的。

The order of precedence is parenthesization, then quantification, then concatenation, then alternation.
优先顺序是括号化，然后是量化，然后是串联，最后是交替。

Some lines in a production definition might have a comment like:
生产定义中的某些行可能具有如下注释：

```
production-a ::=
  production-b      # clarifying comment
```

These comments are meant to be informative only. For instance a comment that says `# not followed by non-ws char` just means that you should be aware that actual production rules will behave as described even though it might not be obvious from the content of that particular production alone.
这些评论仅供参考。例如，如果注释说 `# not 后跟 non-ws char`，则表示您应该意识到实际生产规则的行为将与描述的行为相同，即使仅从该特定生产的内容中可能不明显。

## 4.2. Production Parameters 4.2. 生产参数

Some productions have parameters in parentheses after the name, such as [`s-line-prefix(n,c)`](https://yaml.org/spec/1.2.2/#rule-s-line-prefix). A parameterized production is shorthand for a (infinite) series of productions, each with a fixed value for each parameter.
某些作品的名称后面有括号中的参数，例如 [`s-line-prefix（n，c） 的 s-line-prefix （n，c）`](https://yaml.org/spec/1.2.2/#rule-s-line-prefix) 来获取。参数化生产是（无限）系列生产的简写，每个生产的每个参数都有一个固定的值。

For instance, this production:
例如，这部作品：

```
production-a(n) ::= production-b(n)
```

Is shorthand for: 是以下各项的简写：

```
production-a(0) ::= production-b(0)
production-a(1) ::= production-b(1)
…
```

And this production: 而这部作品：

```
production-a(n) ::=
  ( production-b(n+m) production-c(n+m) )+
```

Is shorthand for: 是以下各项的简写：

```
production-a(0) ::=
    ( production-b(0) production-c(0) )+
  | ( production-b(1) production-c(1) )+
  | …
production-a(1) ::=
    ( production-b(1) production-c(1) )+
  | ( production-b(2) production-c(2) )+
  | …
…
```

The parameters are as follows:
参数如下：

- Indentation: `n` or `m` 缩进：`n` 或 `m`

  ​    May be any natural number, including zero. `n` may also be -1. 可以是任何自然数，包括 0。`n` 也可以是 -1。  

- Context: `c` 上下文：`c`

  ​    This parameter allows productions to tweak their behavior according to their surrounding. YAML supports two groups of *contexts*, distinguishing between [block styles](https://yaml.org/spec/1.2.2/#block-style-productions) and [flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions). 此参数允许制作根据周围环境调整其行为。YAML 支持两组*上下文*，区分[块样式](https://yaml.org/spec/1.2.2/#block-style-productions) 和[流式。](https://yaml.org/spec/1.2.2/#flow-style-productions)  

  ​    May be any of the following values: 可以是以下任何值：  

  ​          `BLOCK-IN` – inside block context `BLOCK-IN` – 块上下文中      `BLOCK-OUT` – outside block context `BLOCK-OUT` – 块上下文之外      `BLOCK-KEY` – inside block key context `BLOCK-KEY` – 块键上下文中      `FLOW-IN` – inside flow context `FLOW-IN` – 流上下文内部      `FLOW-OUT` – outside flow context `FLOW-OUT` – 流上下文外      `FLOW-KEY` – inside flow key context `FLOW-KEY` – 流键上下文中      

- (Block) Chomping: `t` （阻止）咀嚼：`t`

  ​    The [line break](https://yaml.org/spec/1.2.2/#line-break-characters) chomping behavior for flow scalars. May be any of the following values: 流标量的[换行](https://yaml.org/spec/1.2.2/#line-break-characters)截断行为。可以是以下任何值：  

- `STRIP` – remove all trailing newlines
  `STRIP` – 删除所有尾随换行符
- `CLIP` – remove all trailing newlines except the first
  `CLIP` – 删除除第一个
- `KEEP` – retain all trailing newlines
  `KEEP` – 保留所有尾随换行符

## 4.3. Production Naming Conventions 4.3. 生产命名约定

To make it easier to follow production combinations, production names use a prefix-style naming convention. Each production is given a prefix based on the type of characters it begins and ends with.
为了更容易地遵循作品组合，作品名称使用前缀样式命名约定。每个作品都会根据其开头和结尾的角色类型获得一个前缀。

- `e-`

  ​    A production matching no characters. 没有角色匹配的作品。  

- `c-`

  ​    A production starting and ending with a special character. 以特殊角色开始和结束的作品。  

- `b-` `乙-`

  ​    A production matching a single [line break](https://yaml.org/spec/1.2.2/#line-break-characters). 与单个[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)匹配的生产。  

- `nb-` `铌-`

  ​    A production starting and ending with a non-[break](https://yaml.org/spec/1.2.2/#line-break-characters) character. 以[不间断字符开始](https://yaml.org/spec/1.2.2/#line-break-characters)和结束的作品。  

- `s-`

  ​    A production starting and ending with a [white space](https://yaml.org/spec/1.2.2/#white-space-characters) character. 以[空白](https://yaml.org/spec/1.2.2/#white-space-characters)字符开始和结束的作品。  

- `ns-`

  ​    A production starting and ending with a non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) character. 以非[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符开始和结束的作品。  

- `l-`

  ​    A production matching complete line(s). 与完整生产线匹配的生产。  

- `X-Y-`

  ​    A production starting with an `X-` character and ending with a `Y-` character, where `X-` and `Y-` are any of the above prefixes. 以 `X-` 字符开头，以 `Y-` 字符结尾的作品，其中 `X-` 和 `Y-` 是上述任何前缀。  

- `X+`, `X-Y+` `X+`、`X-Y+`

  ​    A production as above, with the additional property that the matched content [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) level is greater than the specified `n` parameter. Production 的 Production，具有匹配内容 [缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)级别大于指定的 `n` 参数。  

# Chapter 5. Character Productions 第 5 章.角色制作

## 5.1. Character Set 5.1. 字符集

To ensure readability, YAML [streams](https://yaml.org/spec/1.2.2/#streams) use only the *printable* subset of the Unicode character set. The allowed character range explicitly excludes the C0 control block[15](https://yaml.org/spec/1.2.2/#fn:c0-block) `x00-x1F` (except for TAB `x09`, LF `x0A` and CR `x0D` which are allowed), DEL `x7F`, the C1 control block `x80-x9F` (except for NEL `x85` which is allowed), the surrogate block[16](https://yaml.org/spec/1.2.2/#fn:surrogates) `xD800-xDFFF`, `xFFFE` and `xFFFF`.
为了确保可读性，YAML [流](https://yaml.org/spec/1.2.2/#streams)仅使用 Unicode 字符集的*可打印*子集。允许的字符范围明确排除 C0 控制块[15](https://yaml.org/spec/1.2.2/#fn:c0-block)`x00-x1F`（允许的 TAB `x09`、LF `x0A` 和 CR `x0D` 除外）、DEL `x7F`、C1 控制块 `x80-x9F`（允许的 NEL `x85` 除外）、代理块[16](https://yaml.org/spec/1.2.2/#fn:surrogates)`xD800-xDFFF`、`xFFFE` 和 `xFFFF。`

On input, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must accept all characters in this printable subset.
在输入时，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)必须接受此可打印子集中的所有字符。

On output, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must only produce only characters in this printable subset. Characters outside this set must be [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) using [escape](https://yaml.org/spec/1.2.2/#escaped-characters) sequences. In addition, any allowed characters known to be non-printable should also be [escaped](https://yaml.org/spec/1.2.2/#escaped-characters).
在输出时，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)只能生成此可打印子集中的字符。此集合之外的字符必须使用[转义](https://yaml.org/spec/1.2.2/#escaped-characters)序列[表示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)。 此外，任何已知不可打印的允许字符也应为 [逃脱](https://yaml.org/spec/1.2.2/#escaped-characters)了。

> Note: This isn’t mandatory since a full implementation would require extensive character property tables.
> 注意：这不是强制性的，因为完整实现需要大量的字符属性表。

```
[1] c-printable ::=
                         # 8 bit
    x09                  # Tab (\t)
  | x0A                  # Line feed (LF \n)
  | x0D                  # Carriage Return (CR \r)
  | [x20-x7E]            # Printable ASCII
                         # 16 bit
  | x85                  # Next Line (NEL)
  | [xA0-xD7FF]          # Basic Multilingual Plane (BMP)
  | [xE000-xFFFD]        # Additional Unicode Areas
  | [x010000-x10FFFF]    # 32 bit
```

To ensure [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) must allow all non-C0 characters inside [quoted scalars](https://yaml.org/spec/1.2.2/#double-quoted-style). To ensure readability, non-printable characters should be [escaped](https://yaml.org/spec/1.2.2/#escaped-characters) on output, even inside such [scalars](https://yaml.org/spec/1.2.2/#scalars).
为了确保 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)必须允许引号标[量](https://yaml.org/spec/1.2.2/#double-quoted-style)内的所有非 C0 字符。为了确保可读性，应在输出时[转义](https://yaml.org/spec/1.2.2/#escaped-characters)不可打印的字符，即使在此类[标量](https://yaml.org/spec/1.2.2/#scalars)内也是如此。

> Note: JSON [quoted scalars](https://yaml.org/spec/1.2.2/#double-quoted-style) cannot span multiple lines or contain [tabs](https://yaml.org/spec/1.2.2/#white-space-characters), but YAML [quoted scalars](https://yaml.org/spec/1.2.2/#double-quoted-style) can.
> 注意：[JSON 引用的标量](https://yaml.org/spec/1.2.2/#double-quoted-style)不能跨越多行或包含[制表符](https://yaml.org/spec/1.2.2/#white-space-characters)，但 YAML [引用的标量](https://yaml.org/spec/1.2.2/#double-quoted-style)可以。

```
[2] nb-json ::=
    x09              # Tab character
  | [x20-x10FFFF]    # Non-C0-control characters
```

> Note: The production name `nb-json` means “non-break JSON compatible” here.
> 注意：产品名称 `nb-json` 在这里表示“不间断 JSON 兼容”。

## 5.2. Character Encodings 5.2. 字符编码

All characters mentioned in this specification are Unicode code points. Each such code point is written as one or more bytes depending on the *character encoding* used. Note that in UTF-16, characters above `xFFFF` are written as four bytes, using a surrogate pair.
本规范中提到的所有字符都是 Unicode 码位。 每个这样的代码点都写入为一个或多个字节，具体取决于 使用的*字符编码*。请注意，在 UTF-16 中，`xFFFF` 以上的字符使用代理项对写入 4 个字节。

The character encoding is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
字符编码是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。

On input, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must support the UTF-8 and UTF-16 character encodings. For [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), the UTF-32 encodings must also be supported.
在输入时，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)必须支持 UTF-8 和 UTF-16 字符编码。为了实现 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，还必须支持 UTF-32 编码。

If a character [stream](https://yaml.org/spec/1.2.2/#streams) begins with a *byte order mark*, the character encoding will be taken to be as indicated by the byte order mark. Otherwise, the [stream](https://yaml.org/spec/1.2.2/#streams) must begin with an ASCII character. This allows the encoding to be deduced by the pattern of null (`x00`) characters.
如果字符[流](https://yaml.org/spec/1.2.2/#streams)以*字节顺序标记*开头，则字符编码将被视为字节顺序标记所指示。否则，[流](https://yaml.org/spec/1.2.2/#streams)必须以 ASCII 字符开头。这允许通过 null （`x00`） 字符的模式推断编码。

Byte order marks may appear at the start of any [document](https://yaml.org/spec/1.2.2/#documents), however all [documents](https://yaml.org/spec/1.2.2/#documents) in the same [stream](https://yaml.org/spec/1.2.2/#streams) must use the same character encoding.
字节顺序标记可能出现在任何[文档](https://yaml.org/spec/1.2.2/#documents)的开头，但是所有 同一[流](https://yaml.org/spec/1.2.2/#streams)中的[文档](https://yaml.org/spec/1.2.2/#documents)必须使用相同的字符编码。

To allow for [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), byte order marks are also allowed inside [quoted scalars](https://yaml.org/spec/1.2.2/#double-quoted-style). For readability, such [content](https://yaml.org/spec/1.2.2/#nodes) byte order marks should be [escaped](https://yaml.org/spec/1.2.2/#escaped-characters) on output.
为了实现 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，内部也允许使用字节顺序标记 [引用标量](https://yaml.org/spec/1.2.2/#double-quoted-style)。为了提高可读性，应在输出时对[此类内容](https://yaml.org/spec/1.2.2/#nodes)字节顺序标记[进行转义](https://yaml.org/spec/1.2.2/#escaped-characters)。

The encoding can therefore be deduced by matching the first few bytes of the [stream](https://yaml.org/spec/1.2.2/#streams) with the following table rows (in order):
因此，可以通过匹配 [Stream](https://yaml.org/spec/1.2.2/#streams) 替换为下表行（按顺序）：

|                                        | Byte0 字节 0 | Byte1 字节 1 | Byte2 字节2  | Byte3 字节3 | Encoding 编码 |
| -------------------------------------- | ------------ | ------------ | ------------ | ----------- | ------------- |
| Explicit BOM 显式 BOM                  | x00          | x00          | xFE xFE 系列 | xFF         | UTF-32BE      |
| ASCII first character ASCII 第一个字符 | x00          | x00          | x00          | any 任何    | UTF-32BE      |
| Explicit BOM 显式 BOM                  | xFF          | xFE xFE 系列 | x00          | x00         | UTF-32LE      |
| ASCII first character ASCII 第一个字符 | any 任何     | x00          | x00          | x00         | UTF-32LE      |
| Explicit BOM 显式 BOM                  | xFE xFE 系列 | xFF          |              |             | UTF-16BE      |
| ASCII first character ASCII 第一个字符 | x00          | any 任何     |              |             | UTF-16BE      |
| Explicit BOM 显式 BOM                  | xFF          | xFE xFE 系列 |              |             | UTF-16LE      |
| ASCII first character ASCII 第一个字符 | any 任何     | x00          |              |             | UTF-16LE      |
| Explicit BOM 显式 BOM                  | xEF          | xBB          | xBF          |             | UTF-8         |
| Default 违约                           |              |              |              |             | UTF-8         |

The recommended output encoding is UTF-8. If another encoding is used, it is recommended that an explicit byte order mark be used, even if the first [stream](https://yaml.org/spec/1.2.2/#streams) character is ASCII.
建议的输出编码为 UTF-8。如果使用其他编码，建议使用显式字节顺序标记，即使第一个[流](https://yaml.org/spec/1.2.2/#streams)字符是 ASCII。

For more information about the byte order mark and the Unicode character encoding schemes see the Unicode FAQ[17](https://yaml.org/spec/1.2.2/#fn:uni-faq).
有关字节顺序标记和 Unicode 字符编码方案的更多信息，请参阅 Unicode 常见问题解答[17](https://yaml.org/spec/1.2.2/#fn:uni-faq)。

```
[3] c-byte-order-mark ::= xFEFF
```

In the examples, byte order mark characters are displayed as “`⇔`”.
在示例中，字节顺序标记字符显示为 “`⇔`”。

**Example 5.1 Byte Order Mark
例 5.1 字节顺序标记**

| `⇔# Comment only. ` | `# This stream contains no # documents, only comments. ` |
| ------------------- | -------------------------------------------------------- |
|                     |                                                          |

**Legend: 传说：**

- `c-byte-order-mark`
  `c 字节顺序标记`

**Example 5.2 Invalid Byte Order Mark
例 5.2 无效的字节顺序标记**

| `- Invalid use of BOM ⇔ - Inside a document. ` | `ERROR: A BOM must not appear inside a document. ` |
| ---------------------------------------------- | -------------------------------------------------- |
|                                                |                                                    |

## 5.3. Indicator Characters 5.3. 指示符字符

*Indicators* are characters that have special semantics.
*指示符*是具有特殊语义的字符。

”`-`” (`x2D`, hyphen) denotes a [block sequence](https://yaml.org/spec/1.2.2/#block-sequences) entry.
“`-`” （`x2D`， 连字符） 表示[块序列](https://yaml.org/spec/1.2.2/#block-sequences)条目。

```
[4] c-sequence-entry ::= '-'
```

”`?`” (`x3F`, question mark) denotes a [mapping key](https://yaml.org/spec/1.2.2/#nodes).
“`？”`（`x3F`，问号）表示[映射键](https://yaml.org/spec/1.2.2/#nodes)。

```
[5] c-mapping-key ::= '?'
```

”`:`” (`x3A`, colon) denotes a [mapping value](https://yaml.org/spec/1.2.2/#mapping).
“`：”`“（`x3A`，冒号）表示[映射值](https://yaml.org/spec/1.2.2/#mapping)。

```
[6] c-mapping-value ::= ':'
```

**Example 5.3 Block Structure Indicators
例 5.3 块结构指示符**

| `sequence: - one - two mapping:  ? sky  : blue  sea : green ` | `{ "sequence": [    "one",    "two" ],  "mapping": {    "sky": "blue",    "sea": "green" } } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-sequence-entry`
  `c 序列入口`
- `c-mapping-key`
  `C 映射键`
- `c-mapping-value`
  `c 映射值`

”`,`” (`x2C`, comma) ends a [flow collection](https://yaml.org/spec/1.2.2/#flow-collection-styles) entry.
“`，`”（`x2C`，逗号）结束[流集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)条目。

```
[7] c-collect-entry ::= ','
```

”`[`” (`x5B`, left bracket) starts a [flow sequence](https://yaml.org/spec/1.2.2/#flow-sequences).
“`[`”（`x5B`，左括号）启动[流序列](https://yaml.org/spec/1.2.2/#flow-sequences)。

```
[8] c-sequence-start ::= '['
```

”`]`” (`x5D`, right bracket) ends a [flow sequence](https://yaml.org/spec/1.2.2/#flow-sequences).
“`]`”（`x5D`，右括号）结束[流序列](https://yaml.org/spec/1.2.2/#flow-sequences)。

```
[9] c-sequence-end ::= ']'
```

”`{`” (`x7B`, left brace) starts a [flow mapping](https://yaml.org/spec/1.2.2/#flow-mappings).
“`{`”（`x7B`，左大括号）启动[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)。

```
[10] c-mapping-start ::= '{'
```

”`}`” (`x7D`, right brace) ends a [flow mapping](https://yaml.org/spec/1.2.2/#flow-mappings).
“`}`”（`x7D`，右大括号）结束[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)。

```
[11] c-mapping-end ::= '}'
```

**Example 5.4 Flow Collection Indicators
示例 5.4 流量收集指示器**

| `sequence: [ one, two, ] mapping: { sky: blue, sea: green } ` | `{ "sequence": [ "one", "two" ],  "mapping":    { "sky": "blue", "sea": "green" } } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-sequence-start c-sequence-end`
- `c-mapping-start c-mapping-end`
  `c-映射开始 c-映射结束`
- `c-collect-entry`
  `c-collect-条目`

”`#`” (`x23`, octothorpe, hash, sharp, pound, number sign) denotes a [comment](https://yaml.org/spec/1.2.2/#comments).
“`#`” （`x23`， octothorpe， hash， sharp， pound， number sign） 表示[注释](https://yaml.org/spec/1.2.2/#comments)。

```
[12] c-comment ::= '#'
```

**Example 5.5 Comment Indicator
示例 5.5 注释指示符**

| `# Comment only. ` | `# This stream contains no # documents, only comments. ` |
| ------------------ | -------------------------------------------------------- |
|                    |                                                          |

**Legend: 传说：**

- `c-comment`
  `C 评论`

”`&`” (`x26`, ampersand) denotes a [node’s anchor property](https://yaml.org/spec/1.2.2/#anchors-and-aliases).
“&`&`”（`x26`，&符号）表示[节点的锚点属性](https://yaml.org/spec/1.2.2/#anchors-and-aliases)。

```
[13] c-anchor ::= '&'
```

”`*`” (`x2A`, asterisk) denotes an [alias node](https://yaml.org/spec/1.2.2/#alias-nodes).
“`*`”（`x2A`，星号）表示[别名节点](https://yaml.org/spec/1.2.2/#alias-nodes)。

```
[14] c-alias ::= '*'
```

The “`!`” (`x21`, exclamation) is used for specifying [node tags](https://yaml.org/spec/1.2.2/#node-tags). It is used to denote [tag handles](https://yaml.org/spec/1.2.2/#tag-handles) used in [tag directives](https://yaml.org/spec/1.2.2/#tag-directives) and [tag properties](https://yaml.org/spec/1.2.2/#node-tags); to denote [local tags](https://yaml.org/spec/1.2.2/#tags); and as the [non-specific tag](https://yaml.org/spec/1.2.2/#resolved-tags) for non-[plain scalars](https://yaml.org/spec/1.2.2/#plain-style).
“`！`”（`x21`，感叹号）用于指定[节点标签](https://yaml.org/spec/1.2.2/#node-tags)。它用于表示[标记指令](https://yaml.org/spec/1.2.2/#tag-directives)和[标记属性](https://yaml.org/spec/1.2.2/#node-tags)中使用的[标记句柄](https://yaml.org/spec/1.2.2/#tag-handles);表示[本地标签](https://yaml.org/spec/1.2.2/#tags);以及作为非[纯标量](https://yaml.org/spec/1.2.2/#plain-style)的非[特定标签](https://yaml.org/spec/1.2.2/#resolved-tags)。

```
[15] c-tag ::= '!'
```

**Example 5.6 Node Property Indicators
示例 5.6 节点属性指示器**

| `anchored: !local &anchor value alias: *anchor ` | `{ "anchored": !local &A1 "value",  "alias": *A1 } ` |
| ------------------------------------------------ | ---------------------------------------------------- |
|                                                  |                                                      |

**Legend: 传说：**

- `c-tag` `C 标签`
- `c-anchor`
  `C 锚`
- `c-alias`
  `c 别名`

”`|`” (`7C`, vertical bar) denotes a [literal block scalar](https://yaml.org/spec/1.2.2/#literal-style).
“`|`”（`7C`，竖线）表示[文字块标量](https://yaml.org/spec/1.2.2/#literal-style)。

```
[16] c-literal ::= '|'
```

”`>`” (`x3E`, greater than) denotes a [folded block scalar](https://yaml.org/spec/1.2.2/#block-folding).
“`>`” （`x3E`， greater than） 表示[折叠块标量](https://yaml.org/spec/1.2.2/#block-folding)。

```
[17] c-folded ::= '>'
```

**Example 5.7 Block Scalar Indicators
例 5.7 块标量指标**

| `literal: |  some  text folded: >  some  text ` | `{ "literal": "some\ntext\n",  "folded": "some text\n" } ` |
| ----------------------------------------------- | ---------------------------------------------------------- |
|                                                 |                                                            |

**Legend: 传说：**

- `c-literal`
  `C 字面量`
- `c-folded`
  `C 形折叠`

”`'`” (`x27`, apostrophe, single quote) surrounds a [single-quoted flow scalar](https://yaml.org/spec/1.2.2/#single-quoted-style).
“`'`”（`x27`，撇号，单引号）括起[单引号流标量](https://yaml.org/spec/1.2.2/#single-quoted-style)。

```
[18] c-single-quote ::= "'"
```

”`"`” (`x22`, double quote) surrounds a [double-quoted flow scalar](https://yaml.org/spec/1.2.2/#double-quoted-style).
“`”`“ （`x22`， 双引号） 括起[双引号流标量](https://yaml.org/spec/1.2.2/#double-quoted-style)。

```
[19] c-double-quote ::= '"'
```

**Example 5.8 Quoted Scalar Indicators
示例 5.8 引用的标量指标**

| `single: 'text' double: "text" ` | `{ "single": "text",  "double": "text" } ` |
| -------------------------------- | ------------------------------------------ |
|                                  |                                            |

**Legend: 传说：**

- `c-single-quote`
  `c-单引号`
- `c-double-quote`
  `c-双引号`

”`%`” (`x25`, percent) denotes a [directive](https://yaml.org/spec/1.2.2/#directives) line.
“`%`” （`x25`， percent） 表示[指令](https://yaml.org/spec/1.2.2/#directives)行。

```
[20] c-directive ::= '%'
```

**Example 5.9 Directive Indicator
示例 5.9 指令指示符**

| `%YAML 1.2 --- text ` | `"text" ` |
| --------------------- | --------- |
|                       |           |

**Legend: 传说：**

- `c-directive`
  `C 指令`

The “`@`” (`x40`, at) and “```” (`x60`, grave accent) are *reserved* for future use.
“`@`”（`x40，at`）和 “`'`”（`x60`，重音符）是 *保留*供将来使用。

```
[21] c-reserved ::=
    '@' | '`'
```

**Example 5.10 Invalid use of Reserved Indicators
例 5.10 保留指示符的无效使用**

| `commercial-at: @text grave-accent: `text ` | `ERROR: Reserved indicators can't start a plain scalar. ` |
| ------------------------------------------- | --------------------------------------------------------- |
|                                             |                                                           |

Any indicator character: 任何指示符字符：

```
[22] c-indicator ::=
    c-sequence-entry    # '-'
  | c-mapping-key       # '?'
  | c-mapping-value     # ':'
  | c-collect-entry     # ','
  | c-sequence-start    # '['
  | c-sequence-end      # ']'
  | c-mapping-start     # '{'
  | c-mapping-end       # '}'
  | c-comment           # '#'
  | c-anchor            # '&'
  | c-alias             # '*'
  | c-tag               # '!'
  | c-literal           # '|'
  | c-folded            # '>'
  | c-single-quote      # "'"
  | c-double-quote      # '"'
  | c-directive         # '%'
  | c-reserved          # '@' '`'
```

The “`[`”, “`]`”, “`{`”, “`}`” and “`,`” indicators denote structure in [flow collections](https://yaml.org/spec/1.2.2/#flow-collection-styles). They are therefore forbidden in some cases, to avoid ambiguity in several constructs. This is handled on a case-by-case basis by the relevant productions.
“`[`”、“`]`”、“`{`”、“`}`”和“`，`”指示符表示[流集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)中的结构。因此，在某些情况下禁止使用它们，以避免在几种结构中产生歧义。这是由相关制作根据具体情况处理的。

```
[23] c-flow-indicator ::=
    c-collect-entry     # ','
  | c-sequence-start    # '['
  | c-sequence-end      # ']'
  | c-mapping-start     # '{'
  | c-mapping-end       # '}'
```

## 5.4. Line Break Characters 5.4. 换行符

YAML recognizes the following ASCII *line break* characters.
YAML 可识别以下 ASCII *换行*符。

```
[24] b-line-feed ::= x0A
[25] b-carriage-return ::= x0D
[26] b-char ::=
    b-line-feed          # x0A
  | b-carriage-return    # X0D
```

All other characters, including the form feed (`x0C`), are considered to be non-break characters. Note that these include the *non-ASCII line breaks*: next line (`x85`), line separator (`x2028`) and paragraph separator (`x2029`).
所有其他字符，包括换页符 （`x0C`），都被视为非换行符。请注意，这些*换行符包括非 ASCII 换行*符：下一行 （`x85`）、行分隔符 （`x2028`） 和段落分隔符 （`x2029`）。

[YAML version 1.1](https://yaml.org/spec/1.2.2/#yaml-directives) did support the above non-ASCII line break characters; however, JSON does not. Hence, to ensure [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), YAML treats them as non-break characters as of version 1.2. YAML 1.2 [processors](https://yaml.org/spec/1.2.2/#processes-and-models) [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) a [version 1.1](https://yaml.org/spec/1.2.2/#yaml-directives) [document](https://yaml.org/spec/1.2.2/#documents) should therefore treat these line breaks as non-break characters, with an appropriate warning.
[YAML 版本 1.1](https://yaml.org/spec/1.2.2/#yaml-directives) 确实支持上述非 ASCII 换行符;但是，JSON 不会。因此，为了确保 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，YAML 从 1.2 版本开始将它们视为不间断字符。因此，解析[版本 1.1](https://yaml.org/spec/1.2.2/#yaml-directives)[文档](https://yaml.org/spec/1.2.2/#documents)[的](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) YAML 1.2 [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应将这些换行符视为非换行符，并带有适当的警告。

```
[27] nb-char ::=
  c-printable - b-char - c-byte-order-mark
```

Line breaks are interpreted differently by different systems and have multiple widely used formats.
换行符由不同的系统以不同的方式解释，并且具有多种广泛使用的格式。

```
[28] b-break ::=
    (
      b-carriage-return  # x0A
      b-line-feed
    )                    # x0D
  | b-carriage-return
  | b-line-feed
```

Line breaks inside [scalar content](https://yaml.org/spec/1.2.2/#scalar) must be *normalized* by the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models). Each such line break must be [parsed](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) into a single line feed character. The original line break format is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
[标量内容](https://yaml.org/spec/1.2.2/#scalar)中的换行符必须由 YAML *规范化* [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)。每个这样的换行符都必须[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)为单个换行字符。原始换行符格式是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。

```
[29] b-as-line-feed ::=
  b-break
```

Outside [scalar content](https://yaml.org/spec/1.2.2/#scalar), YAML allows any line break to be used to terminate lines.
在[标量内容](https://yaml.org/spec/1.2.2/#scalar)之外，YAML 允许使用任何换行符来终止行。

```
[30] b-non-content ::=
  b-break
```

On output, a YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) is free to emit line breaks using whatever convention is most appropriate.
在输出时，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以使用最合适的约定自由发出换行符。

In the examples, line breaks are sometimes displayed using the “`↓`” glyph for clarity.
在示例中，为了清楚起见，有时会使用 “`↓`” 字形显示换行符。

**Example 5.11 Line Break Characters
例 5.11 换行符**

| `|  Line break (no glyph)  Line break (glyphed)↓ ` | `"Line break (no glyph)\nLine break (glyphed)\n" ` |
| -------------------------------------------------- | -------------------------------------------------- |
|                                                    |                                                    |

**Legend: 传说：**

- `b-break`
  `B 断裂`

## 5.5. White Space Characters 5.5. 空白字符

YAML recognizes two *white space* characters: *space* and *tab*.
YAML 识别两个*空白*字符：*space* 和 *tab*。

```
[31] s-space ::= x20
[32] s-tab ::= x09
[33] s-white ::=
  s-space | s-tab
```

The rest of the ([printable](https://yaml.org/spec/1.2.2/#character-set)) non-[break](https://yaml.org/spec/1.2.2/#line-break-characters) characters are considered to be non-space characters.
其余的（[可打印](https://yaml.org/spec/1.2.2/#character-set)的）非[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符被视为非空格字符。

```
[34] ns-char ::=
  nb-char - s-white
```

In the examples, tab characters are displayed as the glyph “`→`”. Space characters are sometimes displayed as the glyph “`·`” for clarity.
在示例中，制表符显示为字形 “`→`”。为清楚起见，空格字符有时会显示为字形 “`·`”。

**Example 5.12 Tabs and Spaces
例 5.12 制表符和空格**

| `# Tabs and spaces quoted:·"Quoted →" block:→| ··void main() { ··→printf("Hello, world!\n"); ··} ` | `{ "quoted": "Quoted \t",  "block": "void main()    {\n\tprintf(\"Hello, world!\\n\");\n}\n" } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-space`
  `S 空间`
- `s-tab` `S 标签`

## 5.6. Miscellaneous Characters 5.6. 其他字符

The YAML syntax productions make use of the following additional character classes:
YAML 语法产品使用以下附加字符类：

A decimal digit for numbers:
数字的十进制数字：

```
[35] ns-dec-digit ::=
  [x30-x39]             # 0-9
```

A hexadecimal digit for [escape sequences](https://yaml.org/spec/1.2.2/#escaped-characters):
[转义序列](https://yaml.org/spec/1.2.2/#escaped-characters)的十六进制数字：

```
[36] ns-hex-digit ::=
    ns-dec-digit        # 0-9
  | [x41-x46]           # A-F
  | [x61-x66]           # a-f
```

ASCII letter (alphabetic) characters:
ASCII 字母（字母）字符：

```
[37] ns-ascii-letter ::=
    [x41-x5A]           # A-Z
  | [x61-x7A]           # a-z
```

Word (alphanumeric) characters for identifiers:
标识符的单词（字母数字）字符：

```
[38] ns-word-char ::=
    ns-dec-digit        # 0-9
  | ns-ascii-letter     # A-Z a-z
  | '-'                 # '-'
```

URI characters for [tags](https://yaml.org/spec/1.2.2/#tags), as defined in the URI specification[18](https://yaml.org/spec/1.2.2/#fn:uri).
[标记](https://yaml.org/spec/1.2.2/#tags)的 URI 字符，如 URI 规范[18](https://yaml.org/spec/1.2.2/#fn:uri) 中所定义。

By convention, any URI characters other than the allowed printable ASCII characters are first *encoded* in UTF-8 and then each byte is *escaped* using the “`%`” character. The YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must not expand such escaped characters. [Tag](https://yaml.org/spec/1.2.2/#tags) characters must be preserved and compared exactly as [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) in the YAML [stream](https://yaml.org/spec/1.2.2/#streams), without any processing.
按照惯例，除允许的可打印 ASCII 字符之外的任何 URI 字符都首先以 UTF-8 *编码*，然后使用 “`%`” 字符对每个字节*进行转义*。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)不得扩展此类转义字符。 必须完全按照 YAML [流](https://yaml.org/spec/1.2.2/#streams)中的[显示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)方式保留和比较[标记](https://yaml.org/spec/1.2.2/#tags)字符，而无需任何处理。

```
[39] ns-uri-char ::=
    (
      '%'
      ns-hex-digit{2}
    )
  | ns-word-char
  | '#'
  | ';'
  | '/'
  | '?'
  | ':'
  | '@'
  | '&'
  | '='
  | '+'
  | '$'
  | ','
  | '_'
  | '.'
  | '!'
  | '~'
  | '*'
  | "'"
  | '('
  | ')'
  | '['
  | ']'
```

The “`!`” character is used to indicate the end of a [named tag handle](https://yaml.org/spec/1.2.2/#tag-handles); hence its use in [tag shorthands](https://yaml.org/spec/1.2.2/#tag-shorthands) is restricted. In addition, such [shorthands](https://yaml.org/spec/1.2.2/#tag-shorthands) must not contain the “`[`”, “`]`”, “`{`”, “`}`” and “`,`” characters. These characters would cause ambiguity with [flow collection](https://yaml.org/spec/1.2.2/#flow-collection-styles) structures.
“`！`”字符用于指示[命名标签句柄](https://yaml.org/spec/1.2.2/#tag-handles)的结尾;因此，它在[标签简写](https://yaml.org/spec/1.2.2/#tag-shorthands)中的使用受到限制。此外，此类[简写](https://yaml.org/spec/1.2.2/#tag-shorthands)不得包含 “`[`”、“`]`”、“`{`”、“`}`” 和 “`，`” 字符。这些字符会导致[流式集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)结构产生歧义。

```
[40] ns-tag-char ::=
    ns-uri-char
  - c-tag               # '!'
  - c-flow-indicator
```

## 5.7. Escaped Characters 5.7. 转义字符

All non-[printable](https://yaml.org/spec/1.2.2/#character-set) characters must be *escaped*. YAML escape sequences use the “`\`” notation common to most modern computer languages. Each escape sequence must be [parsed](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) into the appropriate Unicode character. The original escape sequence is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
所有[不可打印](https://yaml.org/spec/1.2.2/#character-set)的字符都必须*转义*。YAML 转义序列使用大多数现代计算机语言通用的 “`\`” 表示法。每个转义序列都必须[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)为适当的 Unicode 字符。原始转义序列是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。

Note that escape sequences are only interpreted in [double-quoted scalars](https://yaml.org/spec/1.2.2/#double-quoted-style). In all other [scalar styles](https://yaml.org/spec/1.2.2/#node-styles), the “`\`” character has no special meaning and non-[printable](https://yaml.org/spec/1.2.2/#character-set) characters are not available.
请注意，转义序列仅在[双引号标量](https://yaml.org/spec/1.2.2/#double-quoted-style)中解释。在所有其他[标量样式](https://yaml.org/spec/1.2.2/#node-styles)中，“`\`” 字符没有特殊含义，并且不可[打印](https://yaml.org/spec/1.2.2/#character-set)的字符不可用。

```
[41] c-escape ::= '\'
```

YAML escape sequences are a superset of C’s escape sequences:
YAML 转义序列是 C 的转义序列的超集：

Escaped ASCII null (`x00`) character.
转义的 ASCII 空 （`x00`） 字符。

```
[42] ns-esc-null ::= '0'
```

Escaped ASCII bell (`x07`) character.
转义的 ASCII 铃铛 （`x07`） 字符。

```
[43] ns-esc-bell ::= 'a'
```

Escaped ASCII backspace (`x08`) character.
转义的 ASCII 退格 （`x08`） 字符。

```
[44] ns-esc-backspace ::= 'b'
```

Escaped ASCII horizontal tab (`x09`) character. This is useful at the start or the end of a line to force a leading or trailing tab to become part of the [content](https://yaml.org/spec/1.2.2/#nodes).
转义的 ASCII 水平制表符 （`x09`） 字符。这在行的开头或结尾非常有用，可以强制前导或尾随制表符成为[内容](https://yaml.org/spec/1.2.2/#nodes)的一部分。

```
[45] ns-esc-horizontal-tab ::=
  't' | x09
```

Escaped ASCII line feed (`x0A`) character.
转义的 ASCII 换行符 （`x0A`） 字符。

```
[46] ns-esc-line-feed ::= 'n'
```

Escaped ASCII vertical tab (`x0B`) character.
转义的 ASCII 垂直制表符 （`x0B`） 字符。

```
[47] ns-esc-vertical-tab ::= 'v'
```

Escaped ASCII form feed (`x0C`) character.
转义的 ASCII 换表 （`x0C`） 字符。

```
[48] ns-esc-form-feed ::= 'f'
```

Escaped ASCII carriage return (`x0D`) character.
转义的 ASCII 回车符 （`x0D`） 字符。

```
[49] ns-esc-carriage-return ::= 'r'
```

Escaped ASCII escape (`x1B`) character.
转义的 ASCII 转义 （`x1B`） 字符。

```
[50] ns-esc-escape ::= 'e'
```

Escaped ASCII space (`x20`) character. This is useful at the start or the end of a line to force a leading or trailing space to become part of the [content](https://yaml.org/spec/1.2.2/#nodes).
转义的 ASCII 空格 （`x20`） 字符。这在行的开头或结尾非常有用，可以强制前导或尾随空格成为[内容](https://yaml.org/spec/1.2.2/#nodes)的一部分。

```
[51] ns-esc-space ::= x20
```

Escaped ASCII double quote (`x22`).
转义的 ASCII 双引号 （`x22`）。

```
[52] ns-esc-double-quote ::= '"'
```

Escaped ASCII slash (`x2F`), for [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives).
转义的 ASCII 斜杠 （`x2F`），以实现 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)。

```
[53] ns-esc-slash ::= '/'
```

Escaped ASCII back slash (`x5C`).
转义的 ASCII 反斜杠 （`x5C`）。

```
[54] ns-esc-backslash ::= '\'
```

Escaped Unicode next line (`x85`) character.
转义的 Unicode 下一行 （`x85`） 字符。

```
[55] ns-esc-next-line ::= 'N'
```

Escaped Unicode non-breaking space (`xA0`) character.
转义的 Unicode 不间断空格 （`xA0`） 字符。

```
[56] ns-esc-non-breaking-space ::= '_'
```

Escaped Unicode line separator (`x2028`) character.
转义的 Unicode 行分隔符 （`x2028`） 字符。

```
[57] ns-esc-line-separator ::= 'L'
```

Escaped Unicode paragraph separator (`x2029`) character.
转义的 Unicode 段落分隔符 （`x2029`） 字符。

```
[58] ns-esc-paragraph-separator ::= 'P'
```

Escaped 8-bit Unicode character.
转义的 8 位 Unicode 字符。

```
[59] ns-esc-8-bit ::=
  'x'
  ns-hex-digit{2}
```

Escaped 16-bit Unicode character.
转义的 16 位 Unicode 字符。

```
[60] ns-esc-16-bit ::=
  'u'
  ns-hex-digit{4}
```

Escaped 32-bit Unicode character.
转义的 32 位 Unicode 字符。

```
[61] ns-esc-32-bit ::=
  'U'
  ns-hex-digit{8}
```

Any escaped character: 任何转义字符：

```
[62] c-ns-esc-char ::=
  c-escape         # '\'
  (
      ns-esc-null
    | ns-esc-bell
    | ns-esc-backspace
    | ns-esc-horizontal-tab
    | ns-esc-line-feed
    | ns-esc-vertical-tab
    | ns-esc-form-feed
    | ns-esc-carriage-return
    | ns-esc-escape
    | ns-esc-space
    | ns-esc-double-quote
    | ns-esc-slash
    | ns-esc-backslash
    | ns-esc-next-line
    | ns-esc-non-breaking-space
    | ns-esc-line-separator
    | ns-esc-paragraph-separator
    | ns-esc-8-bit
    | ns-esc-16-bit
    | ns-esc-32-bit
  )
```

**Example 5.13 Escaped Characters
例 5.13 转义字符**

| `- "Fun with \\" - "\" \a \b \e \f" - "\n \r \t \v \0" - "\  \_ \N \L \P \  \x41 \u0041 \U00000041" ` | `[ "Fun with \\",  "\" \u0007 \b \u001b \f",  "\n \r \t \u000b \u0000",  "\u0020 \u00a0 \u0085 \u2028 \u2029 A A A" ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-ns-esc-char`
  `C-NS-ESC-CHAR` 格式

**Example 5.14 Invalid Escaped Characters
例 5.14 无效的转义字符**

| `Bad escapes:  "\c  \xq-" ` | `ERROR: - c is an invalid escaped character. - q and - are invalid hex digits. ` |
| --------------------------- | ------------------------------------------------------------ |
|                             |                                                              |

# Chapter 6. Structural Productions 第 6 章.结构产品

## 6.1. Indentation Spaces 6.1. 缩进空格

In YAML [block styles](https://yaml.org/spec/1.2.2/#block-style-productions), structure is determined by *indentation*. In general, indentation is defined as a zero or more [space](https://yaml.org/spec/1.2.2/#white-space-characters) characters at the start of a line.
在 YAML [块样式](https://yaml.org/spec/1.2.2/#block-style-productions)中，结构由*缩进*决定。通常，缩进定义为行首出现零个或多个[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符。

To maintain portability, [tab](https://yaml.org/spec/1.2.2/#white-space-characters) characters must not be used in indentation, since different systems treat [tabs](https://yaml.org/spec/1.2.2/#white-space-characters) differently. Note that most modern editors may be configured so that pressing the [tab](https://yaml.org/spec/1.2.2/#white-space-characters) key results in the insertion of an appropriate number of [spaces](https://yaml.org/spec/1.2.2/#white-space-characters).
为了保持可移植性，不能在缩进中使用[制表符](https://yaml.org/spec/1.2.2/#white-space-characters)，因为不同的系统对[制表符](https://yaml.org/spec/1.2.2/#white-space-characters)的处理方式不同。请注意，大多数现代编辑器都可以配置为按 [Tab](https://yaml.org/spec/1.2.2/#white-space-characters) 键会导致插入适当数量的[空格](https://yaml.org/spec/1.2.2/#white-space-characters)。

The amount of indentation is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
缩进量是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。

```
[63]
s-indent(0) ::=
  <empty>

# When n≥0
s-indent(n+1) ::=
  s-space s-indent(n)
```

A [block style](https://yaml.org/spec/1.2.2/#block-style-productions) construct is terminated when encountering a line which is less indented than the construct. The productions use the notation “`s-indent-less-than(n)`” and “`s-indent-less-or-equal(n)`” to express this.
当遇到缩进量小于构造的行时，[块样式](https://yaml.org/spec/1.2.2/#block-style-productions)构造将终止。这些作品使用符号 “`s-indent-less-than（n）`” 和 “`s-indent-less-or-equal（n）`” 来表达这一点。

```
[64]
s-indent-less-than(1) ::=
  <empty>

# When n≥1
s-indent-less-than(n+1) ::=
  s-space s-indent-less-than(n)
  | <empty>
[65]
s-indent-less-or-equal(0) ::=
  <empty>

# When n≥0
s-indent-less-or-equal(n+1) ::=
  s-space s-indent-less-or-equal(n)
  | <empty>
```

Each [node](https://yaml.org/spec/1.2.2/#nodes) must be indented further than its parent [node](https://yaml.org/spec/1.2.2/#nodes). All sibling [nodes](https://yaml.org/spec/1.2.2/#nodes) must use the exact same indentation level. However the [content](https://yaml.org/spec/1.2.2/#nodes) of each sibling [node](https://yaml.org/spec/1.2.2/#nodes) may be further indented independently.
每个[节点](https://yaml.org/spec/1.2.2/#nodes)的缩进速度必须比其父[节点](https://yaml.org/spec/1.2.2/#nodes)更远。所有同级[节点](https://yaml.org/spec/1.2.2/#nodes)必须使用完全相同的缩进级别。但是，每个同级[节点](https://yaml.org/spec/1.2.2/#nodes)[的内容](https://yaml.org/spec/1.2.2/#nodes)可以进一步独立缩进。

**Example 6.1 Indentation Spaces
例 6.1 缩进空格**

| `··# Leading comment line spaces are ···# neither content nor indentation. ···· Not indented: ·By one space: | ····By four ······spaces ·Flow style: [    # Leading spaces ···By two,        # in flow style ··Also by two,    # are neither ··→Still by two   # content nor ····]             # indentation. ` | `{ "Not indented": {    "By one space": "By four\n  spaces\n",    "Flow style": [      "By two",      "Also by two",      "Still by two" ] } } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-indent(n)`
  `s 缩进 （n）`
- `Content` `内容`
- `Neither content nor indentation`

The “`-`”, “`?`” and “`:`” characters used to denote [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles) entries are perceived by people to be part of the indentation. This is handled on a case-by-case basis by the relevant productions.
用于表示[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)条目的 “`-`”、“`？`” 和 “`：`” 字符被人们认为是缩进的一部分。这是由相关制作根据具体情况处理的。

**Example 6.2 Indentation Indicators
例 6.2 缩进指示符**

| `?·a :·-→b ··-··-→c ·····-·d ` | `{ "a":  [ "b",    [ "c",      "d" ] ] } ` |
| ------------------------------ | ------------------------------------------ |
|                                |                                            |

**Legend: 传说：**

- `Total Indentation`
  `总缩进`
- `s-indent(n)`
  `s 缩进 （n）`
- `Indicator as indentation`
  `指示符作为缩进`

## 6.2. Separation Spaces 6.2. 分隔空间

Outside [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) and [scalar content](https://yaml.org/spec/1.2.2/#scalar), YAML uses [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters for *separation* between tokens within a line. Note that such [white space](https://yaml.org/spec/1.2.2/#white-space-characters) may safely include [tab](https://yaml.org/spec/1.2.2/#white-space-characters) characters.
在[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)和[标量内容](https://yaml.org/spec/1.2.2/#scalar)之外，YAML 使用[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符来*分隔*行内的标记。请注意，此类[空格](https://yaml.org/spec/1.2.2/#white-space-characters)可以安全地包含 [Tab](https://yaml.org/spec/1.2.2/#white-space-characters) 字符。

Separation spaces are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
分隔空间是[演示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达 [内容](https://yaml.org/spec/1.2.2/#nodes)信息。

```
[66] s-separate-in-line ::=
    s-white+
  | <start-of-line>
```

**Example 6.3 Separation Spaces
例 6.3 分隔空格**

| `-·foo:→·bar - -·baz  -→baz ` | `[ { "foo": "bar" },  [ "baz",    "baz" ] ] ` |
| ----------------------------- | --------------------------------------------- |
|                               |                                               |

**Legend: 传说：**

- `s-separate-in-line`
  `S 在线分离`

## 6.3. Line Prefixes 6.3. 行前缀

Inside [scalar content](https://yaml.org/spec/1.2.2/#scalar), each line begins with a non-[content](https://yaml.org/spec/1.2.2/#nodes) *line prefix*. This prefix always includes the [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces). For [flow scalar styles](https://yaml.org/spec/1.2.2/#flow-scalar-styles) it additionally includes all leading [white space](https://yaml.org/spec/1.2.2/#white-space-characters), which may contain [tab](https://yaml.org/spec/1.2.2/#white-space-characters) characters.
在[标量内容](https://yaml.org/spec/1.2.2/#scalar)中，每行都以非[内容](https://yaml.org/spec/1.2.2/#nodes)*行前缀*开头。此前缀始终包含[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)。对于[流标量样式](https://yaml.org/spec/1.2.2/#flow-scalar-styles)，它还包括所有前导[空格](https://yaml.org/spec/1.2.2/#white-space-characters)，其中可能包含[制表符](https://yaml.org/spec/1.2.2/#white-space-characters)。

Line prefixes are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
行前缀是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达 [内容](https://yaml.org/spec/1.2.2/#nodes)信息。

```
[67]
s-line-prefix(n,BLOCK-OUT) ::= s-block-line-prefix(n)
s-line-prefix(n,BLOCK-IN)  ::= s-block-line-prefix(n)
s-line-prefix(n,FLOW-OUT)  ::= s-flow-line-prefix(n)
s-line-prefix(n,FLOW-IN)   ::= s-flow-line-prefix(n)
[68] s-block-line-prefix(n) ::=
  s-indent(n)
[69] s-flow-line-prefix(n) ::=
  s-indent(n)
  s-separate-in-line?
```

**Example 6.4 Line Prefixes
例 6.4 行前缀**

| `plain: text ··lines quoted: "text ··→lines" block: | ··text ···→lines ` | `{ "plain": "text lines",  "quoted": "text lines",  "block": "text\n \tlines\n" } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-flow-line-prefix(n)`
  `s-流线前缀 （n）`
- `s-block-line-prefix(n)`
  `s-块行前缀 （n）`
- `s-indent(n)`
  `s 缩进 （n）`

## 6.4. Empty Lines 6.4. 空行

An *empty line* line consists of the non-[content](https://yaml.org/spec/1.2.2/#nodes) [prefix](https://yaml.org/spec/1.2.2/#tag-prefixes) followed by a [line break](https://yaml.org/spec/1.2.2/#line-break-characters).
*空行*由非[内容](https://yaml.org/spec/1.2.2/#nodes)[前缀](https://yaml.org/spec/1.2.2/#tag-prefixes)和[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)组成。

```
[70] l-empty(n,c) ::=
  (
      s-line-prefix(n,c)
    | s-indent-less-than(n)
  )
  b-as-line-feed
```

The semantics of empty lines depend on the [scalar style](https://yaml.org/spec/1.2.2/#node-styles) they appear in. This is handled on a case-by-case basis by the relevant productions.
空行的语义取决于它们出现的[标量样式](https://yaml.org/spec/1.2.2/#node-styles)。这是由相关制作根据具体情况处理的。

**Example 6.5 Empty Lines 例 6.5 空行**

| `Folding:  "Empty line ···→  as a line feed" Chomping: |  Clipped empty lines · ` | `{ "Folding": "Empty line\nas a line feed",  "Chomping": "Clipped empty lines\n" } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `l-empty(n,c)`
  `L-空 （n，c）`

## 6.5. Line Folding 6.5. 折线

*Line folding* allows long lines to be broken for readability, while retaining the semantics of the original long line. If a [line break](https://yaml.org/spec/1.2.2/#line-break-characters) is followed by an [empty line](https://yaml.org/spec/1.2.2/#empty-lines), it is *trimmed*; the first [line break](https://yaml.org/spec/1.2.2/#line-break-characters) is discarded and the rest are retained as [content](https://yaml.org/spec/1.2.2/#nodes).
*行折叠*允许断开长行以提高可读性，同时保留原始长行的语义。如果[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)后跟空[行](https://yaml.org/spec/1.2.2/#empty-lines)，则*对其进行剪裁*;第一个 换[行符](https://yaml.org/spec/1.2.2/#line-break-characters)将被丢弃，其余部分将保留为[内容](https://yaml.org/spec/1.2.2/#nodes)。

```
[71] b-l-trimmed(n,c) ::=
  b-non-content
  l-empty(n,c)+
```

Otherwise (the following line is not [empty](https://yaml.org/spec/1.2.2/#empty-lines)), the [line break](https://yaml.org/spec/1.2.2/#line-break-characters) is converted to a single [space](https://yaml.org/spec/1.2.2/#white-space-characters) (`x20`).
否则（以下行不[为空](https://yaml.org/spec/1.2.2/#empty-lines)），[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)将转换为单个[空格](https://yaml.org/spec/1.2.2/#white-space-characters) （`x20`）。

```
[72] b-as-space ::=
  b-break
```

A folded non-[empty line](https://yaml.org/spec/1.2.2/#empty-lines) may end with either of the above [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters).
折叠的非[空行](https://yaml.org/spec/1.2.2/#empty-lines)可以以上述任一[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)结尾。

```
[73] b-l-folded(n,c) ::=
  b-l-trimmed(n,c) | b-as-space
```

**Example 6.6 Line Folding 例 6.6 折线**

| `>-  trimmed↓ ··↓ ·↓ ↓  as↓  space ` | `"trimmed\n\n\nas space" ` |
| ------------------------------------ | -------------------------- |
|                                      |                            |

**Legend: 传说：**

- `b-l-trimmed(n,c)`
  `b-l-修剪 （n，c）`
- `b-as-space`

The above rules are common to both the [folded block style](https://yaml.org/spec/1.2.2/#block-folding) and the [scalar flow styles](https://yaml.org/spec/1.2.2/#flow-scalar-styles). Folding does distinguish between these cases in the following way:
上述规则对于[折叠块样式](https://yaml.org/spec/1.2.2/#block-folding)和[标量流样式](https://yaml.org/spec/1.2.2/#flow-scalar-styles)都是通用的。折叠确实通过以下方式区分这些情况：

- Block Folding 块折叠

  ​    In the [folded block style](https://yaml.org/spec/1.2.2/#block-folding), the final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) and trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are subject to [chomping](https://yaml.org/spec/1.2.2/#block-chomping-indicator) and are never folded. In addition, folding does not apply to [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) surrounding text lines that contain leading [white space](https://yaml.org/spec/1.2.2/#white-space-characters). Note that such a [more-indented](https://yaml.org/spec/1.2.2/#example-more-indented-lines) line may consist only of such leading [white space](https://yaml.org/spec/1.2.2/#white-space-characters). 在[折叠块样式](https://yaml.org/spec/1.2.2/#block-folding)中，最后一个[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)和尾随[空行](https://yaml.org/spec/1.2.2/#empty-lines) 容易被[咀嚼](https://yaml.org/spec/1.2.2/#block-chomping-indicator)，永远不会折叠。此外，折叠不适用于包含前导[空格](https://yaml.org/spec/1.2.2/#white-space-characters)的文本行周围的[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符。请注意，此类[缩进较多](https://yaml.org/spec/1.2.2/#example-more-indented-lines)的行可能仅包含此类前导[空格](https://yaml.org/spec/1.2.2/#white-space-characters)。  

  ​    The combined effect of the *block line folding* rules is that each “paragraph” is interpreted as a line, [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are interpreted as a line feed and the formatting of [more-indented](https://yaml.org/spec/1.2.2/#example-more-indented-lines) lines is preserved. *块行折叠*规则的综合效果是，每个 “段落” 被解释为一行，[空行](https://yaml.org/spec/1.2.2/#empty-lines)被解释为换行，并且保留[更多缩进](https://yaml.org/spec/1.2.2/#example-more-indented-lines)行的格式。  

**Example 6.7 Block Folding
例 6.7 块折叠**

| `> ··foo·↓ ·↓ ··→·bar↓ ↓ ··baz↓ ` | `"foo \n\n\t bar\n\nbaz\n" ` |
| --------------------------------- | ---------------------------- |
|                                   |                              |

**Legend: 传说：**

- `b-l-folded(n,c)`
  `b-l-折叠 （n，c）`
- `Non-content spaces`
  `非内容空间`
- `Content spaces` `内容空间`

- Flow Folding 流式折叠

  ​    Folding in [flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions) provides more relaxed semantics. [Flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions) typically depend on explicit [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) rather than [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) to convey structure. Hence spaces preceding or following the text in a line are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information. Once all such spaces have been discarded, all [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) are folded without exception. 流[式样式](https://yaml.org/spec/1.2.2/#flow-style-productions)中的折叠提供了更轻松的语义。 [流式样式](https://yaml.org/spec/1.2.2/#flow-style-productions)通常依赖于显式[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)，而不是 [缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)来传达结构。因此，一行中文本前后的空格是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。丢弃所有此类空格后，所有[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)都将无一例外地折叠。  

  ​    The combined effect of the *flow line folding* rules is that each “paragraph” is interpreted as a line, [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are interpreted as line feeds and text can be freely [more-indented](https://yaml.org/spec/1.2.2/#example-more-indented-lines) without affecting the [content](https://yaml.org/spec/1.2.2/#nodes) information. *流线折叠*规则的综合效果是，每个“段落”被解释为一行，[空行](https://yaml.org/spec/1.2.2/#empty-lines)被解释为换行，文本可以自由[地多缩进](https://yaml.org/spec/1.2.2/#example-more-indented-lines)，而不会影响[内容](https://yaml.org/spec/1.2.2/#nodes)信息。  

```
[74] s-flow-folded(n) ::=
  s-separate-in-line?
  b-l-folded(n,FLOW-IN)
  s-flow-line-prefix(n)
```

**Example 6.8 Flow Folding 例 6.8 流式折叠**

| `"↓ ··foo·↓ ·↓ ··→·bar↓ ↓ ··baz↓ " ` | `" foo\nbar\nbaz " ` |
| ------------------------------------ | -------------------- |
|                                      |                      |

**Legend: 传说：**

- `s-flow-folded(n)`
  `S 流折叠 （N）`
- `Non-content spaces`
  `非内容空间`

## 6.6. Comments 6.6. 注释

An explicit *comment* is marked by a “`#`” indicator. Comments are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
显式*注释*由 “`#`” 指示符标记。注释是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes) 信息。

Comments must be [separated](https://yaml.org/spec/1.2.2/#separation-spaces) from other tokens by [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters.
注释必须用[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符[与其他标记分隔](https://yaml.org/spec/1.2.2/#separation-spaces)。

> Note: To ensure [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) must allow for the omission of the final comment [line break](https://yaml.org/spec/1.2.2/#line-break-characters) of the input [stream](https://yaml.org/spec/1.2.2/#streams). However, as this confuses many tools, YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) should terminate the [stream](https://yaml.org/spec/1.2.2/#streams) with an explicit [line break](https://yaml.org/spec/1.2.2/#line-break-characters) on output.
> 注意：为了确保 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)必须允许省略 input [流](https://yaml.org/spec/1.2.2/#streams)的最终注释[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)。但是，由于这会混淆许多工具，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应终止 [在](https://yaml.org/spec/1.2.2/#streams)输出时带有显式[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)的 stream。

```
[75] c-nb-comment-text ::=
  c-comment    # '#'
  nb-char*
[76] b-comment ::=
    b-non-content
  | <end-of-input>
[77] s-b-comment ::=
  (
    s-separate-in-line
    c-nb-comment-text?
  )?
  b-comment
```

**Example 6.9 Separated Comment
例 6.9 分隔的注释**

| `key:····# Comment↓  value*eof* ` | `{ "key": "value" } ` |
| --------------------------------- | --------------------- |
|                                   |                       |

**Legend: 传说：**

- `c-nb-comment-text`
  `c-nb-注释文本`
- `b-comment`
  `B 评论`
- `s-b-comment`
  `S-B-注释`

Outside [scalar content](https://yaml.org/spec/1.2.2/#scalar), comments may appear on a line of their own, independent of the [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) level. Note that outside [scalar content](https://yaml.org/spec/1.2.2/#scalar), a line containing only [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters is taken to be a comment line.
在[标量内容](https://yaml.org/spec/1.2.2/#scalar)之外，注释可能显示在自己的一行上，与[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)级别无关。请注意，在[标量内容](https://yaml.org/spec/1.2.2/#scalar)之外，仅包含[空格](https://yaml.org/spec/1.2.2/#white-space-characters)的行 characters 被视为注释行。

```
[78] l-comment ::=
  s-separate-in-line
  c-nb-comment-text?
  b-comment
```

**Example 6.10 Comment Lines
例 6.10 注释行**

| `··# Comment↓ ···↓ ↓ ` | `# This stream contains no # documents, only comments. ` |
| ---------------------- | -------------------------------------------------------- |
|                        |                                                          |

**Legend: 传说：**

- `s-b-comment`
  `S-B-注释`
- `l-comment`
  `L 注释`

In most cases, when a line may end with a comment, YAML allows it to be followed by additional comment lines. The only exception is a comment ending a [block scalar header](https://yaml.org/spec/1.2.2/#block-scalar-headers).
在大多数情况下，当一行可能以 comment 结尾时，YAML 允许它后跟其他 comment 行。唯一的例外是结束[块标量标头](https://yaml.org/spec/1.2.2/#block-scalar-headers)的注释。

```
[79] s-l-comments ::=
  (
      s-b-comment
    | <start-of-line>
  )
  l-comment*
```

**Example 6.11 Multi-Line Comments
例 6.11 多行注释**

| `key:····# Comment↓ ········# lines↓  value↓ ↓ ` | `{ "key": "value" } ` |
| ------------------------------------------------ | --------------------- |
|                                                  |                       |

**Legend: 传说：**

- `s-b-comment`
  `S-B-注释`
- `l-comment`
  `L 注释`
- `s-l-comments`
  `S-L-注释`

## 6.7. Separation Lines 6.7. 分隔线

[Implicit keys](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) are restricted to a single line. In all other cases, YAML allows tokens to be separated by multi-line (possibly empty) [comments](https://yaml.org/spec/1.2.2/#comments).
[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)仅限于一行。在所有其他情况下，YAML 允许用多行（可能为空）[注释](https://yaml.org/spec/1.2.2/#comments)分隔令牌。

Note that structures following multi-line comment separation must be properly [indented](https://yaml.org/spec/1.2.2/#indentation-spaces), even though there is no such restriction on the separation [comment](https://yaml.org/spec/1.2.2/#comments) lines themselves.
请注意，多行注释分隔后面的结构必须正确 [缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)，即使对分隔没有这样的限制 [注释](https://yaml.org/spec/1.2.2/#comments)行本身。

```
[80]
s-separate(n,BLOCK-OUT) ::= s-separate-lines(n)
s-separate(n,BLOCK-IN)  ::= s-separate-lines(n)
s-separate(n,FLOW-OUT)  ::= s-separate-lines(n)
s-separate(n,FLOW-IN)   ::= s-separate-lines(n)
s-separate(n,BLOCK-KEY) ::= s-separate-in-line
s-separate(n,FLOW-KEY)  ::= s-separate-in-line
[81] s-separate-lines(n) ::=
    (
      s-l-comments
      s-flow-line-prefix(n)
    )
  | s-separate-in-line
```

**Example 6.12 Separation Spaces
例 6.12 分隔空格**

| `{·first:·Sammy,·last:·Sosa·}:↓ # Statistics: ··hr:··# Home runs ·····65 ··avg:·# Average ···0.278 ` | `{ { "first": "Sammy",    "last": "Sosa" }: {    "hr": 65,    "avg": 0.278 } } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-separate-in-line`
  `S 在线分离`
- `s-separate-lines(n)`
  `S 分隔行 （n）`
- `s-indent(n)`
  `s 缩进 （n）`

## 6.8. Directives 6.8. 指令

*Directives* are instructions to the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models). This specification defines two directives, “`YAML`” and “`TAG`”, and *reserves* all other directives for future use. There is no way to define private directives. This is intentional.
*指令*是 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)的指令。本规范定义了两个指令，“`YAML`”和“`TAG`”*，以及* 所有其他指令以供将来使用。 无法定义 private 指令。 这是有意为之的。

Directives are a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
指令是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes) 信息。

```
[82] l-directive ::=
  c-directive            # '%'
  (
      ns-yaml-directive
    | ns-tag-directive
    | ns-reserved-directive
  )
  s-l-comments
```

Each directive is specified on a separate non-[indented](https://yaml.org/spec/1.2.2/#indentation-spaces) line starting with the “`%`” indicator, followed by the directive name and a list of parameters. The semantics of these parameters depends on the specific directive. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should ignore unknown directives with an appropriate warning.
每个指令都在一个单独的非[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)行行上指定，该行以 “`%`” 指示符开头，后跟指令名称和参数列表。这些参数的语义取决于特定的指令。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应忽略未知指令，并显示适当的警告。

```
[83] ns-reserved-directive ::=
  ns-directive-name
  (
    s-separate-in-line
    ns-directive-parameter
  )*
[84] ns-directive-name ::=
  ns-char+
[85] ns-directive-parameter ::=
  ns-char+
```

**Example 6.13 Reserved Directives
例 6.13 保留指令**

| `%FOO  bar baz # Should be ignored               # with a warning. --- "foo" ` | `"foo" ` |
| ------------------------------------------------------------ | -------- |
|                                                              |          |

**Legend: 传说：**

- `ns-reserved-directive`
- `ns-directive-name`
  `ns-directive-name （ns-指令名称）`
- `ns-directive-parameter`

### 6.8.1. “`YAML`” Directives 6.8.1. “`YAML`” 指令

The “`YAML`” directive specifies the version of YAML the [document](https://yaml.org/spec/1.2.2/#documents) conforms to. This specification defines version “`1.2`”, including recommendations for *YAML 1.1 processing*.
“`YAML`” 指令指定[文档](https://yaml.org/spec/1.2.2/#documents)符合的 YAML 版本。本规范定义了版本 “`1.2`”，包括对 *YAML 1.1 处理*的建议。

A version 1.2 YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must accept [documents](https://yaml.org/spec/1.2.2/#documents) with an explicit “`%YAML 1.2`” directive, as well as [documents](https://yaml.org/spec/1.2.2/#documents) lacking a “`YAML`” directive. Such [documents](https://yaml.org/spec/1.2.2/#documents) are assumed to conform to the 1.2 version specification. [Documents](https://yaml.org/spec/1.2.2/#documents) with a “`YAML`” directive specifying a higher minor version (e.g. “`%YAML 1.3`”) should be processed with an appropriate warning. [Documents](https://yaml.org/spec/1.2.2/#documents) with a “`YAML`” directive specifying a higher major version (e.g. “`%YAML 2.0`”) should be rejected with an appropriate error message.
版本 1.2 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)[必须接受具有](https://yaml.org/spec/1.2.2/#documents)显式“`%YAML 1.2`”指令的文档，以及缺少“`YAML`”指令[的文档](https://yaml.org/spec/1.2.2/#documents)。此类[文档](https://yaml.org/spec/1.2.2/#documents)假定符合 1.2 版本规范。 如果[文档](https://yaml.org/spec/1.2.2/#documents)的 “`YAML`” 指令指定了更高的次要版本（例如 “`%YAML 1.3`”） ，则应使用适当的警告进行处理。 带有 “`YAML`” 指令指定更高主要版本（例如 “`%YAML 2.0`”）[的文档](https://yaml.org/spec/1.2.2/#documents)应被拒绝，并显示相应的错误消息。

A version 1.2 YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must also accept [documents](https://yaml.org/spec/1.2.2/#documents) with an explicit “`%YAML 1.1`” directive. Note that version 1.2 is mostly a superset of version 1.1, defined for the purpose of ensuring *JSON compatibility*. Hence a version 1.2 [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should process version 1.1 [documents](https://yaml.org/spec/1.2.2/#documents) as if they were version 1.2, giving a warning on points of incompatibility (handling of [non-ASCII line breaks](https://yaml.org/spec/1.2.2/#line-break-characters), as described [above](https://yaml.org/spec/1.2.2/#line-break-characters)).
版本 1.2 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)还必须接受具有显式“`%YAML 1.1`”指令[的文档](https://yaml.org/spec/1.2.2/#documents)。请注意，版本 1.2 主要是版本 1.1 的超集，定义目的是确保 *JSON 兼容性*。因此，1.2 版[处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应该像处理 1.2 版一样处理 1.1 [版文档](https://yaml.org/spec/1.2.2/#documents)，并在不兼容点上发出警告（如上所述，处理[非 ASCII 换行](https://yaml.org/spec/1.2.2/#line-break-characters)[符）。](https://yaml.org/spec/1.2.2/#line-break-characters)

```
[86] ns-yaml-directive ::=
  "YAML"
  s-separate-in-line
  ns-yaml-version
[87] ns-yaml-version ::=
  ns-dec-digit+
  '.'
  ns-dec-digit+
```

**Example 6.14 “`YAML`” directive
例 6.14 “`YAML`” 指令**

| `%YAML 1.3 # Attempt parsing           # with a warning --- "foo" ` | `"foo" ` |
| ------------------------------------------------------------ | -------- |
|                                                              |          |

**Legend: 传说：**

- `ns-yaml-directive`
  `ns-yaml 指令`
- `ns-yaml-version`
  `ns-yaml 版本`

It is an error to specify more than one “`YAML`” directive for the same document, even if both occurrences give the same version number.
为同一文档指定多个 “`YAML`” 指令是错误的，即使两次出现都给出相同的版本号。

**Example 6.15 Invalid Repeated YAML directive
例 6.15 无效的重复 YAML 指令**

| `%YAML 1.2 %YAML 1.1 foo ` | `ERROR: The YAML directive must only be given at most once per document. ` |
| -------------------------- | ------------------------------------------------------------ |
|                            |                                                              |

### 6.8.2. “`TAG`” Directives 6.8.2. “`TAG`” 指令

The “`TAG`” directive establishes a [tag shorthand](https://yaml.org/spec/1.2.2/#tag-shorthands) notation for specifying [node tags](https://yaml.org/spec/1.2.2/#node-tags). Each “`TAG`” directive associates a [handle](https://yaml.org/spec/1.2.2/#tag-handles) with a [prefix](https://yaml.org/spec/1.2.2/#tag-prefixes). This allows for compact and readable [tag](https://yaml.org/spec/1.2.2/#tags) notation.
“`TAG`” 指令建立了一个[标签速记](https://yaml.org/spec/1.2.2/#tag-shorthands)法，用于指定 [node 标签](https://yaml.org/spec/1.2.2/#node-tags)。每个 “`TAG`” 指令将 [handle](https://yaml.org/spec/1.2.2/#tag-handles) 与[前缀](https://yaml.org/spec/1.2.2/#tag-prefixes)相关联。这允许使用紧凑且可读的[标记](https://yaml.org/spec/1.2.2/#tags)表示法。

```
[88] ns-tag-directive ::=
  "TAG"
  s-separate-in-line
  c-tag-handle
  s-separate-in-line
  ns-tag-prefix
```

**Example 6.16 “`TAG`” directive
例 6.16 “`TAG`” 指令**

| `%TAG !yaml! tag:yaml.org,2002: --- !yaml!str "foo" ` | `"foo" ` |
| ----------------------------------------------------- | -------- |
|                                                       |          |

**Legend: 传说：**

- `ns-tag-directive`
  `ns-tag 指令`
- `c-tag-handle`
  `C 标签句柄`
- `ns-tag-prefix`

It is an error to specify more than one “`TAG`” directive for the same [handle](https://yaml.org/spec/1.2.2/#tag-handles) in the same document, even if both occurrences give the same [prefix](https://yaml.org/spec/1.2.2/#tag-prefixes).
为同一[句柄](https://yaml.org/spec/1.2.2/#tag-handles)指定多个 “`TAG`” 指令是错误的 ，即使两个匹配项都给出相同的[前缀](https://yaml.org/spec/1.2.2/#tag-prefixes)。

**Example 6.17 Invalid Repeated TAG directive
例 6.17 无效的重复 TAG 指令**

| `%TAG ! !foo %TAG ! !foo bar ` | `ERROR: The TAG directive must only be given at most once per handle in the same document. ` |
| ------------------------------ | ------------------------------------------------------------ |
|                                |                                                              |

#### 6.8.2.1. Tag Handles 6.8.2.1. 标签句柄

The *tag handle* exactly matches the prefix of the affected [tag shorthand](https://yaml.org/spec/1.2.2/#tag-shorthands). There are three tag handle variants:
*标签句柄*与受影响的[标签简写](https://yaml.org/spec/1.2.2/#tag-shorthands)的前缀完全匹配。有三种标签句柄变体：

```
[89] c-tag-handle ::=
    c-named-tag-handle
  | c-secondary-tag-handle
  | c-primary-tag-handle
```

- Primary Handle 主手柄

  ​    The *primary tag handle* is a single “`!`” character. This allows using the most compact possible notation for a single “primary” name space. By default, the prefix associated with this handle is “`!`”. Thus, by default, [shorthands](https://yaml.org/spec/1.2.2/#tag-shorthands) using this handle are interpreted as [local tags](https://yaml.org/spec/1.2.2/#tags). *主标签句柄*是一个 “`！`” 字符。这允许对单个 “primary” 名称空间使用最紧凑的表示法。默认情况下，与此句柄关联的前缀为 “`！`”。因此，默认情况下，使用此句柄的[简写](https://yaml.org/spec/1.2.2/#tag-shorthands)被解释为[本地标记](https://yaml.org/spec/1.2.2/#tags)。  

  ​    It is possible to override the default behavior by providing an explicit “`TAG`” directive, associating a different prefix for this handle. This provides smooth migration from using [local tags](https://yaml.org/spec/1.2.2/#tags) to using [global tags](https://yaml.org/spec/1.2.2/#tags) by the simple addition of a single “`TAG`” directive. 可以通过提供显式 “`TAG`” 指令来覆盖默认行为，为此句柄关联不同的前缀。这提供了从使用[本地标签](https://yaml.org/spec/1.2.2/#tags)到使用[全局标签](https://yaml.org/spec/1.2.2/#tags)的平滑迁移 通过简单地添加单个 “`TAG`” 指令。  

```
[90] c-primary-tag-handle ::= '!'
```

**Example 6.18 Primary Tag Handle
例 6.18 主标记句柄**

| `# Private !foo "bar" ... # Global %TAG ! tag:example.com,2000:app/ --- !foo "bar" ` | `!<!foo> "bar" --- !<tag:example.com,2000:app/foo> "bar" ` |
| ------------------------------------------------------------ | ---------------------------------------------------------- |
|                                                              |                                                            |

**Legend: 传说：**

- `c-primary-tag-handle`
  `c 主标签句柄`

- Secondary Handle 辅助手柄

  ​    The *secondary tag handle* is written as “`!!`”. This allows using a compact notation for a single “secondary” name space. By default, the prefix associated with this handle is “`tag:yaml.org,2002:`”. *辅助标签句柄*写为 “`！！`”。这允许对单个 “secondary” 名称空间使用紧凑的表示法。默认情况下，与此句柄关联的前缀为“`tag：yaml.org，2002：`”。  

  ​    It is possible to override this default behavior by providing an explicit “`TAG`” directive associating a different prefix for this handle. 可以通过提供显式 “`TAG`” 指令来覆盖此默认行为，该指令为此句柄关联不同的前缀。  

```
[91] c-secondary-tag-handle ::= "!!"
```

**Example 6.19 Secondary Tag Handle
示例 6.19 辅助标记句柄**

| `%TAG !! tag:example.com,2000:app/ --- !!int 1 - 3 # Interval, not integer ` | `!<tag:example.com,2000:app/int> "1 - 3" ` |
| ------------------------------------------------------------ | ------------------------------------------ |
|                                                              |                                            |

**Legend: 传说：**

- `c-secondary-tag-handle`
  `c 辅助标签句柄`

- Named Handles 命名手柄

  ​    A *named tag handle* surrounds a non-empty name with “`!`” characters. A handle name must not be used in a [tag shorthand](https://yaml.org/spec/1.2.2/#tag-shorthands) unless an explicit “`TAG`” directive has associated some prefix with it. *命名标记句柄*用 “`！`” 字符将非空名称括起来。不得在[标签简写](https://yaml.org/spec/1.2.2/#tag-shorthands)中使用句柄名称，除非显式的 “`TAG`” 指令已将某个前缀与其关联。  

  ​    The name of the handle is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information. In particular, the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) need not preserve the handle name once [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) is completed. 句柄的名称是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。特别是，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)不需要保留句柄名称一次 [解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)已完成。  

```
[92] c-named-tag-handle ::=
  c-tag            # '!'
  ns-word-char+
  c-tag            # '!'
```

**Example 6.20 Tag Handles 示例 6.20 标记句柄**

| `%TAG !e! tag:example.com,2000:app/ --- !e!foo "bar" ` | `!<tag:example.com,2000:app/foo> "bar" ` |
| ------------------------------------------------------ | ---------------------------------------- |
|                                                        |                                          |

**Legend: 传说：**

- `c-named-tag-handle`
  `C 命名标签句柄`

#### 6.8.2.2. Tag Prefixes 6.8.2.2. 标签前缀

There are two *tag prefix* variants:
有两种*标签前缀*变体：

```
[93] ns-tag-prefix ::=
  c-ns-local-tag-prefix | ns-global-tag-prefix
```

- Local Tag Prefix 本地标签前缀

  ​    If the prefix begins with a “`!`” character, [shorthands](https://yaml.org/spec/1.2.2/#tag-shorthands) using the [handle](https://yaml.org/spec/1.2.2/#tag-handles) are expanded to a [local tag](https://yaml.org/spec/1.2.2/#tags). Note that such a [tag](https://yaml.org/spec/1.2.2/#tags) is intentionally not a valid URI and its semantics are specific to the [application](https://yaml.org/spec/1.2.2/#processes-and-models). In particular, two [documents](https://yaml.org/spec/1.2.2/#documents) in the same [stream](https://yaml.org/spec/1.2.2/#streams) may assign different semantics to the same [local tag](https://yaml.org/spec/1.2.2/#tags). 如果前缀以 “`！`” 字符开头，则使用[句柄](https://yaml.org/spec/1.2.2/#tag-handles)的[简写](https://yaml.org/spec/1.2.2/#tag-shorthands) 扩展为[本地标签](https://yaml.org/spec/1.2.2/#tags)。请注意，此类[标记](https://yaml.org/spec/1.2.2/#tags)故意不是有效的 URI，并且其语义特定于[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)。特别是，同一[流](https://yaml.org/spec/1.2.2/#streams)中的两个[文档](https://yaml.org/spec/1.2.2/#documents)可能会为同一本地[标记](https://yaml.org/spec/1.2.2/#tags)分配不同的语义。  

```
[94] c-ns-local-tag-prefix ::=
  c-tag           # '!'
  ns-uri-char*
```

**Example 6.21 Local Tag Prefix
示例 6.21 本地标记前缀**

| `%TAG !m! !my- --- # Bulb here !m!light fluorescent ... %TAG !m! !my- --- # Color here !m!light green ` | `!<!my-light> "fluorescent" --- !<!my-light> "green" ` |
| ------------------------------------------------------------ | ------------------------------------------------------ |
|                                                              |                                                        |

**Legend: 传说：**

- `c-ns-local-tag-prefix`
  `c-ns-local-tag-前缀`

- Global Tag Prefix 全局标签前缀

  ​    If the prefix begins with a character other than “`!`”, it must be a valid URI prefix, and should contain at least the scheme. [Shorthands](https://yaml.org/spec/1.2.2/#tag-shorthands) using the associated [handle](https://yaml.org/spec/1.2.2/#tag-handles) are expanded to globally unique URI tags and their semantics is consistent across [applications](https://yaml.org/spec/1.2.2/#processes-and-models). In particular, every [document](https://yaml.org/spec/1.2.2/#documents) in every [stream](https://yaml.org/spec/1.2.2/#streams) must assign the same semantics to the same [global tag](https://yaml.org/spec/1.2.2/#tags). 如果前缀以 “`！`” 以外的字符开头，则它必须是有效的 URI prefix 的 intent 前缀，并且至少应包含 scheme。 使用关联[句柄](https://yaml.org/spec/1.2.2/#tag-handles)的[速记](https://yaml.org/spec/1.2.2/#tag-shorthands)扩展为全局唯一的 URI 标记，并且它们的语义在[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)之间是一致的。特别是，每个[流](https://yaml.org/spec/1.2.2/#streams)中的每个[文档](https://yaml.org/spec/1.2.2/#documents)都必须将相同的语义分配给相同的[全局标记](https://yaml.org/spec/1.2.2/#tags)。  

```
[95] ns-global-tag-prefix ::=
  ns-tag-char
  ns-uri-char*
```

**Example 6.22 Global Tag Prefix
示例 6.22 全局标签前缀**

| `%TAG !e! tag:example.com,2000:app/ --- - !e!foo "bar" ` | `- !<tag:example.com,2000:app/foo> "bar" ` |
| -------------------------------------------------------- | ------------------------------------------ |
|                                                          |                                            |

**Legend: 传说：**

- `ns-global-tag-prefix`

## 6.9. Node Properties 6.9. 节点属性

Each [node](https://yaml.org/spec/1.2.2/#nodes) may have two optional *properties*, [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) and [tag](https://yaml.org/spec/1.2.2/#tags), in addition to its [content](https://yaml.org/spec/1.2.2/#nodes). Node properties may be specified in any order before the [node’s content](https://yaml.org/spec/1.2.2/#nodes). Either or both may be omitted.
除了[其内容](https://yaml.org/spec/1.2.2/#nodes)之外，每个[节点](https://yaml.org/spec/1.2.2/#nodes)还可以具有两个可选*属性*，[即 anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) 和 [tag](https://yaml.org/spec/1.2.2/#tags)。节点属性可以在[节点内容](https://yaml.org/spec/1.2.2/#nodes)之前按任意顺序指定。可以省略其中之一或两者。

```
[96] c-ns-properties(n,c) ::=
    (
      c-ns-tag-property
      (
        s-separate(n,c)
        c-ns-anchor-property
      )?
    )
  | (
      c-ns-anchor-property
      (
        s-separate(n,c)
        c-ns-tag-property
      )?
    )
```

**Example 6.23 Node Properties
示例 6.23 节点属性**

| `!!str &a1 "foo":  !!str bar &a2 baz : *a1 ` | `{ &B1 "foo": "bar",  "baz": *B1 } ` |
| -------------------------------------------- | ------------------------------------ |
|                                              |                                      |

**Legend: 传说：**

- `c-ns-properties(n,c)`
  `c-ns-属性 （n，c）`
- `c-ns-anchor-property`
  `c-ns-anchor 属性`
- `c-ns-tag-property`
  `c-ns-标签属性`

### 6.9.1. Node Tags 6.9.1. 节点标签

The *tag property* identifies the type of the [native data structure](https://yaml.org/spec/1.2.2/#representing-native-data-structures) [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) by the [node](https://yaml.org/spec/1.2.2/#nodes). A tag is denoted by the “`!`” indicator.
*tag 属性*标识[节点](https://yaml.org/spec/1.2.2/#nodes)[提供的](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)的类型。标签由 “`！`” 指示符表示。

```
[97] c-ns-tag-property ::=
    c-verbatim-tag
  | c-ns-shorthand-tag
  | c-non-specific-tag
```

- Verbatim Tags 逐字标记

  ​    A tag may be written *verbatim* by surrounding it with the “`<`” and “`>`” characters. In this case, the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) must deliver the verbatim tag as-is to the [application](https://yaml.org/spec/1.2.2/#processes-and-models). In particular, verbatim tags are not subject to [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution). A verbatim tag must either begin with a “`!`” (a [local tag](https://yaml.org/spec/1.2.2/#tags)) or be a valid URI (a [global tag](https://yaml.org/spec/1.2.2/#tags)). 可以通过用 “`<`” 和 “`>`” 字符将标签括起来逐*字*编写。在这种情况下，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)必须将逐字标记按原样交付给 [应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)。具体而言，逐字标记不受[标记解析](https://yaml.org/spec/1.2.2/#tag-resolution)的约束。逐字标记必须以 “`！`” 开头（[本地标签](https://yaml.org/spec/1.2.2/#tags)）或有效的 URI（[全局标签](https://yaml.org/spec/1.2.2/#tags)）。  

```
[98] c-verbatim-tag ::=
  "!<"
  ns-uri-char+
  '>'
```

**Example 6.24 Verbatim Tags
例 6.24 逐字标记**

| `!<tag:yaml.org,2002:str> foo :  !<!bar> baz ` | `{ "foo": !<!bar> "baz" } ` |
| ---------------------------------------------- | --------------------------- |
|                                                |                             |

**Legend: 传说：**

- `c-verbatim-tag`
  `C 逐字标记`

**Example 6.25 Invalid Verbatim Tags
示例 6.25 无效的逐字标记**

| `- !<!> foo - !<$:?> bar ` | `ERROR: - Verbatim tags aren't resolved,  so ! is invalid. - The $:? tag is neither a global  URI tag nor a local tag starting  with '!'. ` |
| -------------------------- | ------------------------------------------------------------ |
|                            |                                                              |

- Tag Shorthands 标记 Shorthands

  ​    A *tag shorthand* consists of a valid [tag handle](https://yaml.org/spec/1.2.2/#tag-handles) followed by a non-empty suffix. The [tag handle](https://yaml.org/spec/1.2.2/#tag-handles) must be associated with a [prefix](https://yaml.org/spec/1.2.2/#tag-prefixes), either by default or by using a “`TAG`” directive. The resulting [parsed](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) [tag](https://yaml.org/spec/1.2.2/#tags) is the concatenation of the [prefix](https://yaml.org/spec/1.2.2/#tag-prefixes) and the suffix and must either begin with “`!`” (a [local tag](https://yaml.org/spec/1.2.2/#tags)) or be a valid URI (a [global tag](https://yaml.org/spec/1.2.2/#tags)). *标签速记*由一个有效的[标签句柄](https://yaml.org/spec/1.2.2/#tag-handles)和一个非空后缀组成。[标签句柄](https://yaml.org/spec/1.2.2/#tag-handles)必须与[前缀](https://yaml.org/spec/1.2.2/#tag-prefixes)关联，默认情况下或使用 “`TAG`” 指令。生成的[解析标签](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)是[前缀](https://yaml.org/spec/1.2.2/#tag-prefixes)和后缀的串联，并且必须以 “`！`” 开头（[本地标记](https://yaml.org/spec/1.2.2/#tags)）或有效的 URI （一个 [global 标签](https://yaml.org/spec/1.2.2/#tags)）。  

  ​    The choice of [tag handle](https://yaml.org/spec/1.2.2/#tag-handles) is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information. In particular, the [tag handle](https://yaml.org/spec/1.2.2/#tag-handles) may be discarded once [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) is completed. [标记句柄](https://yaml.org/spec/1.2.2/#tag-handles)的选择是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。特别是，[一旦](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)解析完成，[标记句柄](https://yaml.org/spec/1.2.2/#tag-handles)可能会被丢弃。  

  ​    The suffix must not contain any “`!`” character. This would cause the tag shorthand to be interpreted as having a [named tag handle](https://yaml.org/spec/1.2.2/#tag-handles). In addition, the suffix must not contain the “`[`”, “`]`”, “`{`”, “`}`” and “`,`” characters. These characters would cause ambiguity with [flow collection](https://yaml.org/spec/1.2.2/#flow-collection-styles) structures. If the suffix needs to specify any of the above restricted characters, they must be [escaped](https://yaml.org/spec/1.2.2/#escaped-characters) using the “`%`” character. This behavior is consistent with the URI character escaping rules (specifically, section 2.3 of URI RFC). 后缀不得包含任何 “`！`” 字符。这将导致标签速记被解释为具有[命名标签句柄](https://yaml.org/spec/1.2.2/#tag-handles)。此外，后缀不得包含“`[`”、“`]`”、“`{`”、“`}`”和“`，`”字符。这些字符会导致[流式集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)结构产生歧义。如果后缀需要指定上述任何受限制的字符，则必须使用 “`%`” 字符[对其进行转义](https://yaml.org/spec/1.2.2/#escaped-characters)。此行为与 URI 字符转义规则（特别是 URI RFC 的第 2.3 节）一致。  

```
[99] c-ns-shorthand-tag ::=
  c-tag-handle
  ns-tag-char+
```

**Example 6.26 Tag Shorthands
例 6.26 标记简写**

| `%TAG !e! tag:example.com,2000:app/ --- - !local foo - !!str bar - !e!tag%21 baz ` | `[ !<!local> "foo",  !<tag:yaml.org,2002:str> "bar",  !<tag:example.com,2000:app/tag!> "baz" ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-ns-shorthand-tag`
  `c-ns-速记标签`

**Example 6.27 Invalid Tag Shorthands
例 6.27 无效的标记简写**

| `%TAG !e! tag:example,2000:app/ --- - !e! foo - !h!bar baz ` | `ERROR: - The !e! handle has no suffix. - The !h! handle wasn't declared. ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

- Non-Specific Tags 非特异性标签

  ​    If a [node](https://yaml.org/spec/1.2.2/#nodes) has no tag property, it is assigned a [non-specific tag](https://yaml.org/spec/1.2.2/#resolved-tags) that needs to be [resolved](https://yaml.org/spec/1.2.2/#resolved-tags) to a [specific](https://yaml.org/spec/1.2.2/#resolved-tags) one. This [non-specific tag](https://yaml.org/spec/1.2.2/#resolved-tags) is “`!`” for non-[plain scalars](https://yaml.org/spec/1.2.2/#plain-style) and “`?`” for all other [nodes](https://yaml.org/spec/1.2.2/#nodes). This is the only case where the [node style](https://yaml.org/spec/1.2.2/#node-styles) has any effect on the [content](https://yaml.org/spec/1.2.2/#nodes) information. 如果[节点](https://yaml.org/spec/1.2.2/#nodes)没有 tag 属性，则会为其分配一个[非特定标签](https://yaml.org/spec/1.2.2/#resolved-tags)，该标签需要[解析](https://yaml.org/spec/1.2.2/#resolved-tags)为[特定](https://yaml.org/spec/1.2.2/#resolved-tags)标签。此[非特定标签](https://yaml.org/spec/1.2.2/#resolved-tags)是 “`！`” 表示非[纯标量](https://yaml.org/spec/1.2.2/#plain-style)，“`？`” 表示所有其他[节点](https://yaml.org/spec/1.2.2/#nodes)。这是[节点样式](https://yaml.org/spec/1.2.2/#node-styles)对[内容](https://yaml.org/spec/1.2.2/#nodes)产生任何影响的唯一情况 信息。  

  ​    It is possible for the tag property to be explicitly set to the “`!`” non-specific tag. By [convention](https://yaml.org/spec/1.2.2/#resolved-tags), this “disables” [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution), forcing the [node](https://yaml.org/spec/1.2.2/#nodes) to be interpreted as “`tag:yaml.org,2002:seq`”, “`tag:yaml.org,2002:map`” or “`tag:yaml.org,2002:str`”, according to its [kind](https://yaml.org/spec/1.2.2/#nodes). 可以将 tag 属性显式设置为 “`！`” 非特定标记。[按照惯例](https://yaml.org/spec/1.2.2/#resolved-tags)，这将“禁用”[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)，强制[节点](https://yaml.org/spec/1.2.2/#nodes)根据其[类型](https://yaml.org/spec/1.2.2/#nodes)被解释为 “`tag：yaml.org，2002：seq`”、“`tag：yaml.org，2002：map`” 或 “`tag：yaml.org，2002：str`”。  

  ​    There is no way to explicitly specify the “`?`” non-specific tag. This is intentional. 无法显式指定 “`？”` 非特定标记。这是有意为之的。  

```
[100] c-non-specific-tag ::= '!'
```

**Example 6.28 Non-Specific Tags
例 6.28 非特定标记**

| `# Assuming conventional resolution: - "12" - 12 - ! 12 ` | `[ "12",  12,  "12" ] ` |
| --------------------------------------------------------- | ----------------------- |
|                                                           |                         |

**Legend: 传说：**

- `c-non-specific-tag`
  `c-非特异性标签`

### 6.9.2. Node Anchors 6.9.2. 节点锚点

An anchor is denoted by the “`&`” indicator. It marks a [node](https://yaml.org/spec/1.2.2/#nodes) for future reference. An [alias node](https://yaml.org/spec/1.2.2/#alias-nodes) can then be used to indicate additional inclusions of the anchored [node](https://yaml.org/spec/1.2.2/#nodes). An anchored [node](https://yaml.org/spec/1.2.2/#nodes) need not be referenced by any [alias nodes](https://yaml.org/spec/1.2.2/#alias-nodes); in particular, it is valid for all [nodes](https://yaml.org/spec/1.2.2/#nodes) to be anchored.
锚点由 “`&`” 指示符表示。它标记一个[节点](https://yaml.org/spec/1.2.2/#nodes)以供将来参考。然后，别名[节点](https://yaml.org/spec/1.2.2/#alias-nodes)可用于指示锚定[节点](https://yaml.org/spec/1.2.2/#nodes)的其他包含。锚定[节点](https://yaml.org/spec/1.2.2/#nodes)不需要由任何[别名节点](https://yaml.org/spec/1.2.2/#alias-nodes)引用;特别是，它对所有要锚定的[节点](https://yaml.org/spec/1.2.2/#nodes)都有效。

```
[101] c-ns-anchor-property ::=
  c-anchor          # '&'
  ns-anchor-name
```

Note that as a [serialization detail](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph), the anchor name is preserved in the [serialization tree](https://yaml.org/spec/1.2.2/#serialization-tree). However, it is not reflected in the [representation](https://yaml.org/spec/1.2.2/#representation-graph) graph and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information. In particular, the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) need not preserve the anchor name once the [representation](https://yaml.org/spec/1.2.2/#representation-graph) is [composed](https://yaml.org/spec/1.2.2/#composing-the-representation-graph).
请注意，作为[序列化详细信息](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)，锚点名称保留在 [序列化树](https://yaml.org/spec/1.2.2/#serialization-tree)。但是，它不会反映在[表示](https://yaml.org/spec/1.2.2/#representation-graph)图中，并且不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。特别是，一旦 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models) [表示](https://yaml.org/spec/1.2.2/#representation-graph)是 [composed 的](https://yaml.org/spec/1.2.2/#composing-the-representation-graph)。

Anchor names must not contain the “`[`”, “`]`”, “`{`”, “`}`” and “`,`” characters. These characters would cause ambiguity with [flow collection](https://yaml.org/spec/1.2.2/#flow-collection-styles) structures.
定位点名称不得包含“`[`”、“`]`”、“`{`”、“`}`”和“`，`”字符。这些字符会导致[流式集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)结构产生歧义。

```
[102] ns-anchor-char ::=
    ns-char - c-flow-indicator
[103] ns-anchor-name ::=
  ns-anchor-char+
```

**Example 6.29 Node Anchors
示例 6.29 节点锚点**

| `First occurrence: &anchor Value Second occurrence: *anchor ` | `{ "First occurrence": &A "Value",  "Second occurrence": *A } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-ns-anchor-property`
  `c-ns-anchor 属性`
- `ns-anchor-name`
  `ns-anchor 名称`

# Chapter 7. Flow Style Productions 第 7 章.Flow Style 制作

YAML’s *flow styles* can be thought of as the natural extension of JSON to cover [folding](https://yaml.org/spec/1.2.2/#line-folding) long content lines for readability, [tagging](https://yaml.org/spec/1.2.2/#tags) nodes to control [construction](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) of [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) and using [anchors](https://yaml.org/spec/1.2.2/#anchors-and-aliases) and [aliases](https://yaml.org/spec/1.2.2/#anchors-and-aliases) to reuse [constructed](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) object instances.
YAML 的*流样式*可以被认为是 JSON 的自然扩展，它涵盖了[折叠](https://yaml.org/spec/1.2.2/#line-folding)长内容行以提高可读性，[标记](https://yaml.org/spec/1.2.2/#tags)节点以控制 [构建](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)[原生数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)，并使用[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)和[别名](https://yaml.org/spec/1.2.2/#anchors-and-aliases)来重用[构建的](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)对象实例。

## 7.1. Alias Nodes 7.1. 别名节点

Subsequent occurrences of a previously [serialized](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph) node are [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) as *alias nodes*. The first occurrence of the [node](https://yaml.org/spec/1.2.2/#nodes) must be marked by an [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) to allow subsequent occurrences to be [presented](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) as alias nodes.
先前[序列化](https://yaml.org/spec/1.2.2/#serializing-the-representation-graph)的节点的后续[出现表示为](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) *alias 节点*。节点的第一个[匹配项必须由](https://yaml.org/spec/1.2.2/#nodes)[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)标记，以允许后续匹配项[显示为](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)别名节点。

An alias node is denoted by the “`*`” indicator. The alias refers to the most recent preceding [node](https://yaml.org/spec/1.2.2/#nodes) having the same [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases). It is an error for an alias node to use an [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) that does not previously occur in the [document](https://yaml.org/spec/1.2.2/#documents). It is not an error to specify an [anchor](https://yaml.org/spec/1.2.2/#anchors-and-aliases) that is not used by any alias node.
别名节点由 “`*`” 指示符表示。别名是指具有相同[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)的最新前[一个节点](https://yaml.org/spec/1.2.2/#nodes)。别名节点使用以前未出现在[文档中](https://yaml.org/spec/1.2.2/#documents)的[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)是错误的。指定任何别名节点未使用的[锚点](https://yaml.org/spec/1.2.2/#anchors-and-aliases)都不是错误。

Note that an alias node must not specify any [properties](https://yaml.org/spec/1.2.2/#node-properties) or [content](https://yaml.org/spec/1.2.2/#nodes), as these were already specified at the first occurrence of the [node](https://yaml.org/spec/1.2.2/#nodes).
请注意，别名节点不得指定任何属性或内容，因为这些[属性](https://yaml.org/spec/1.2.2/#node-properties)或[内容](https://yaml.org/spec/1.2.2/#nodes)已在节点首次出现时[指定。](https://yaml.org/spec/1.2.2/#nodes)

```
[104] c-ns-alias-node ::=
  c-alias           # '*'
  ns-anchor-name
```

**Example 7.1 Alias Nodes 示例 7.1 别名节点**

| `First occurrence: &anchor Foo Second occurrence: *anchor Override anchor: &anchor Bar Reuse anchor: *anchor ` | `{ "First occurrence": &A "Foo",  "Override anchor": &B "Bar",  "Second occurrence": *A,  "Reuse anchor": *B } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-ns-alias-node`
  `c-ns-别名节点`
- `ns-anchor-name`
  `ns-anchor 名称`

## 7.2. Empty Nodes 7.2. 空节点

YAML allows the [node content](https://yaml.org/spec/1.2.2/#nodes) to be omitted in many cases. [Nodes](https://yaml.org/spec/1.2.2/#nodes) with empty [content](https://yaml.org/spec/1.2.2/#nodes) are interpreted as if they were [plain scalars](https://yaml.org/spec/1.2.2/#plain-style) with an empty value. Such [nodes](https://yaml.org/spec/1.2.2/#nodes) are commonly resolved to a “`null`” value.
在许多情况下，YAML 允许省略[节点内容](https://yaml.org/spec/1.2.2/#nodes)。 具有空[内容的](https://yaml.org/spec/1.2.2/#nodes)[节点](https://yaml.org/spec/1.2.2/#nodes)将被解释为[普通标量](https://yaml.org/spec/1.2.2/#plain-style) 替换为空值。 此类[节点](https://yaml.org/spec/1.2.2/#nodes)通常解析为 “`null`” 值。

```
[105] e-scalar ::= ""
```

In the examples, empty [scalars](https://yaml.org/spec/1.2.2/#scalars) are sometimes displayed as the glyph “`°`” for clarity. Note that this glyph corresponds to a position in the characters [stream](https://yaml.org/spec/1.2.2/#streams) rather than to an actual character.
在示例中，为清楚起见，空[标](https://yaml.org/spec/1.2.2/#scalars)量有时显示为字形 “`°`”。请注意，此字形对应于字符[流](https://yaml.org/spec/1.2.2/#streams)中的位置 而不是一个实际的角色。

**Example 7.2 Empty Content
例 7.2 空内容**

| `{  foo : !!str°,  !!str° : bar, } ` | `{ "foo": "",  "": "bar" } ` |
| ------------------------------------ | ---------------------------- |
|                                      |                              |

**Legend: 传说：**

- `e-scalar`

Both the [node’s properties](https://yaml.org/spec/1.2.2/#node-properties) and [node content](https://yaml.org/spec/1.2.2/#nodes) are optional. This allows for a *completely empty node*. Completely empty nodes are only valid when following some explicit indication for their existence.
[节点的属性](https://yaml.org/spec/1.2.2/#node-properties)和[节点内容](https://yaml.org/spec/1.2.2/#nodes)都是可选的。这允许一个*完全空的节点*。完全空的节点仅在遵循其存在的某些明确指示时才有效。

```
[106] e-node ::=
  e-scalar    # ""
```

**Example 7.3 Completely Empty Flow Nodes
示例 7.3 完全空的流节点**

| `{  ? foo :°,  °: bar, } ` | `{ "foo": null,  null : "bar" } ` |
| -------------------------- | --------------------------------- |
|                            |                                   |

**Legend: 传说：**

- `e-node` `E-node 节点`

## 7.3. Flow Scalar Styles 7.3. 流标量样式

YAML provides three *flow scalar styles*: [double-quoted](https://yaml.org/spec/1.2.2/#double-quoted-style), [single-quoted](https://yaml.org/spec/1.2.2/#single-quoted-style) and [plain](https://yaml.org/spec/1.2.2/#plain-style) (unquoted). Each provides a different trade-off between readability and expressive power.
YAML 提供三种*流标量样式*：[双引号](https://yaml.org/spec/1.2.2/#double-quoted-style)、[单引号](https://yaml.org/spec/1.2.2/#single-quoted-style)和 [plain](https://yaml.org/spec/1.2.2/#plain-style) （未引用）。每个版本在可读性和表现力之间提供了不同的权衡。

The [scalar style](https://yaml.org/spec/1.2.2/#node-styles) is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information, with the exception that [plain scalars](https://yaml.org/spec/1.2.2/#plain-style) are distinguished for the purpose of [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution).
[标量样式](https://yaml.org/spec/1.2.2/#node-styles)是[表示细节](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达 [内容](https://yaml.org/spec/1.2.2/#nodes)信息，但为了进行[标记解析](https://yaml.org/spec/1.2.2/#tag-resolution)而区分[普通标量](https://yaml.org/spec/1.2.2/#plain-style)。

### 7.3.1. Double-Quoted Style 7.3.1. 双引号样式

The *double-quoted style* is specified by surrounding “`"`” indicators. This is the only [style](https://yaml.org/spec/1.2.2/#node-styles) capable of expressing arbitrary strings, by using “`\`” [escape sequences](https://yaml.org/spec/1.2.2/#escaped-characters). This comes at the cost of having to escape the “`\`” and “`"`” characters.
*双引号样式*由周围的 “`”`“ 指示符指定。这是唯一能够通过使用 “`\`” [转义序列](https://yaml.org/spec/1.2.2/#escaped-characters)来表示任意字符串的[样式](https://yaml.org/spec/1.2.2/#node-styles)。这是以必须转义 “`\`” 和 “`”`“ 字符为代价的。

```
[107] nb-double-char ::=
    c-ns-esc-char
  | (
        nb-json
      - c-escape          # '\'
      - c-double-quote    # '"'
    )
[108] ns-double-char ::=
  nb-double-char - s-white
```

Double-quoted scalars are restricted to a single line when contained inside an [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry).
双引号标量包含在 [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) 的 intent 中。

```
[109] c-double-quoted(n,c) ::=
  c-double-quote         # '"'
  nb-double-text(n,c)
  c-double-quote         # '"'
[110]
nb-double-text(n,FLOW-OUT)  ::= nb-double-multi-line(n)
nb-double-text(n,FLOW-IN)   ::= nb-double-multi-line(n)
nb-double-text(n,BLOCK-KEY) ::= nb-double-one-line
nb-double-text(n,FLOW-KEY)  ::= nb-double-one-line
[111] nb-double-one-line ::=
  nb-double-char*
```

**Example 7.4 Double Quoted Implicit Keys
例 7.4 双引号隐式键**

| `"implicit block key" : [  "implicit flow key" : value, ] ` | `{ "implicit block key":  [ { "implicit flow key": "value" } ] } ` |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
|                                                             |                                                              |

**Legend: 传说：**

- `nb-double-one-line`
  `NB-双单线`
- `c-double-quoted(n,c)`
  `c-双引号 （n，c）`

In a multi-line double-quoted scalar, [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) are subject to [flow line folding](https://yaml.org/spec/1.2.2/#flow-folding), which discards any trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters. It is also possible to *escape* the [line break](https://yaml.org/spec/1.2.2/#line-break-characters) character. In this case, the escaped [line break](https://yaml.org/spec/1.2.2/#line-break-characters) is excluded from the [content](https://yaml.org/spec/1.2.2/#nodes) and any trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters that precede the escaped line break are preserved. Combined with the ability to [escape](https://yaml.org/spec/1.2.2/#escaped-characters) [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters, this allows double-quoted lines to be broken at arbitrary positions.
在多行双引号标量中，[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)会受到[流线折叠](https://yaml.org/spec/1.2.2/#flow-folding)的影响，这会丢弃任何尾随[的空白](https://yaml.org/spec/1.2.2/#white-space-characters)字符。也可以*转义*[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符。在这种情况下，将从[内容](https://yaml.org/spec/1.2.2/#nodes)中排除转义的[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)，并保留转义换行符之前的任何尾随[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符。结合[转义](https://yaml.org/spec/1.2.2/#escaped-characters)[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符的能力，这允许在任意位置断开双引号行。

```
[112] s-double-escaped(n) ::=
  s-white*
  c-escape         # '\'
  b-non-content
  l-empty(n,FLOW-IN)*
  s-flow-line-prefix(n)
[113] s-double-break(n) ::=
    s-double-escaped(n)
  | s-flow-folded(n)
```

**Example 7.5 Double Quoted Line Breaks
示例 7.5 双引号换行符**

| `"folded·↓ to a space,→↓ ·↓ to a line feed, or·→\↓ ·\·→non-content" ` | `"folded to a space,\nto a line feed, or \t \tnon-content" ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-flow-folded(n)`
  `S 流折叠 （N）`
- `s-double-escaped(n)`
  `s-双转义 （n）`

All leading and trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters on each line are excluded from the [content](https://yaml.org/spec/1.2.2/#nodes). Each continuation line must therefore contain at least one non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) character. Empty lines, if any, are consumed as part of the [line folding](https://yaml.org/spec/1.2.2/#line-folding).
每行上的所有前导和尾随[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符都从[内容](https://yaml.org/spec/1.2.2/#nodes)中排除。因此，每个 continuation line 必须至少包含一个非[空格](https://yaml.org/spec/1.2.2/#white-space-characters) 字符。 空行（如果有）将作为[行折叠](https://yaml.org/spec/1.2.2/#line-folding)的一部分使用。

```
[114] nb-ns-double-in-line ::=
  (
    s-white*
    ns-double-char
  )*
[115] s-double-next-line(n) ::=
  s-double-break(n)
  (
    ns-double-char nb-ns-double-in-line
    (
        s-double-next-line(n)
      | s-white*
    )
  )?
[116] nb-double-multi-line(n) ::=
  nb-ns-double-in-line
  (
      s-double-next-line(n)
    | s-white*
  )
```

**Example 7.6 Double Quoted Lines
例 7.6 双引号行**

| `"·1st non-empty↓ ↓ ·2nd non-empty· →3rd non-empty·" ` | `" 1st non-empty\n2nd non-empty 3rd non-empty " ` |
| ------------------------------------------------------ | ------------------------------------------------- |
|                                                        |                                                   |

**Legend: 传说：**

- `nb-ns-double-in-line`
  `NB-NS-双列式`
- `s-double-next-line(n)`
  `s-double-next-line（n）`

### 7.3.2. Single-Quoted Style 7.3.2. 单引号样式

The *single-quoted style* is specified by surrounding “`'`” indicators. Therefore, within a single-quoted scalar, such characters need to be repeated. This is the only form of *escaping* performed in single-quoted scalars. In particular, the “`\`” and “`"`” characters may be freely used. This restricts single-quoted scalars to [printable](https://yaml.org/spec/1.2.2/#character-set) characters. In addition, it is only possible to break a long single-quoted line where a [space](https://yaml.org/spec/1.2.2/#white-space-characters) character is surrounded by non-[spaces](https://yaml.org/spec/1.2.2/#white-space-characters).
*单引号样式*由周围的 “`'`” 指示符指定。因此，在单引号标量中，需要重复此类字符。这是在单引号标量中执行的唯一*转义*形式。特别是，“`\`” 和 “`”`“ 字符可以自由使用。这会将单引号标量限制为[可打印](https://yaml.org/spec/1.2.2/#character-set)字符。 此外，只有在 [空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符被非[空格](https://yaml.org/spec/1.2.2/#white-space-characters)包围。

```
[117] c-quoted-quote ::= "''"
[118] nb-single-char ::=
    c-quoted-quote
  | (
        nb-json
      - c-single-quote    # "'"
    )
[119] ns-single-char ::=
  nb-single-char - s-white
```

**Example 7.7 Single Quoted Characters
例 7.7 单引号字符**

| `'here''s to "quotes"' ` | `"here's to \"quotes\"" ` |
| ------------------------ | ------------------------- |
|                          |                           |

**Legend: 传说：**

- `c-quoted-quote`
  `c 引用`

Single-quoted scalars are restricted to a single line when contained inside a [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry).
单引号标量包含在 [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) 的 intent 中。

```
[120] c-single-quoted(n,c) ::=
  c-single-quote    # "'"
  nb-single-text(n,c)
  c-single-quote    # "'"
[121]
nb-single-text(FLOW-OUT)  ::= nb-single-multi-line(n)
nb-single-text(FLOW-IN)   ::= nb-single-multi-line(n)
nb-single-text(BLOCK-KEY) ::= nb-single-one-line
nb-single-text(FLOW-KEY)  ::= nb-single-one-line
[122] nb-single-one-line ::=
  nb-single-char*
```

**Example 7.8 Single Quoted Implicit Keys
例 7.8 单引号隐式键**

| `'implicit block key' : [  'implicit flow key' : value, ] ` | `{ "implicit block key":  [ { "implicit flow key": "value" } ] } ` |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
|                                                             |                                                              |

**Legend: 传说：**

- `nb-single-one-line`
  `NB-单线`
- `c-single-quoted(n,c)`
  `c-单引号 （n，c）`

All leading and trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters are excluded from the [content](https://yaml.org/spec/1.2.2/#nodes). Each continuation line must therefore contain at least one non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) character. Empty lines, if any, are consumed as part of the [line folding](https://yaml.org/spec/1.2.2/#line-folding).
所有前导和尾随[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符都从 [内容](https://yaml.org/spec/1.2.2/#nodes)。因此，每个 continuation line 必须至少包含一个非[空格](https://yaml.org/spec/1.2.2/#white-space-characters) 字符。 空行（如果有）将作为[行折叠](https://yaml.org/spec/1.2.2/#line-folding)的一部分使用。

```
[123] nb-ns-single-in-line ::=
  (
    s-white*
    ns-single-char
  )*
[124] s-single-next-line(n) ::=
  s-flow-folded(n)
  (
    ns-single-char
    nb-ns-single-in-line
    (
        s-single-next-line(n)
      | s-white*
    )
  )?
[125] nb-single-multi-line(n) ::=
  nb-ns-single-in-line
  (
      s-single-next-line(n)
    | s-white*
  )
```

**Example 7.9 Single Quoted Lines
例 7.9 单引号行**

| `'·1st non-empty↓ ↓ ·2nd non-empty· →3rd non-empty·' ` | `" 1st non-empty\n2nd non-empty 3rd non-empty " ` |
| ------------------------------------------------------ | ------------------------------------------------- |
|                                                        |                                                   |

**Legend: 传说：**

- `nb-ns-single-in-line(n)`
  `NB-NS-单列 （n）`
- `s-single-next-line(n)`
  `s-single-next-line（n） （s-single-next-line（n） （s-single-next-line） （n`

### 7.3.3. Plain Style 7.3.3. 纯色样式

The *plain* (unquoted) style has no identifying [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) and provides no form of escaping. It is therefore the most readable, most limited and most [context](https://yaml.org/spec/1.2.2/#context-c) sensitive [style](https://yaml.org/spec/1.2.2/#node-styles). In addition to a restricted character set, a plain scalar must not be empty or contain leading or trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters. It is only possible to break a long plain line where a [space](https://yaml.org/spec/1.2.2/#white-space-characters) character is surrounded by non-[spaces](https://yaml.org/spec/1.2.2/#white-space-characters).
*普通* （未引用） 样式没有标识[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)，也不提供任何形式的转义。因此，它是可读性最强、限制性最强[且上下文最](https://yaml.org/spec/1.2.2/#context-c)敏感的 [样式](https://yaml.org/spec/1.2.2/#node-styles)。除了受限字符集之外，普通标量也不得为空或包含前导或尾随[空白字符](https://yaml.org/spec/1.2.2/#white-space-characters)。只有在[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符被非[空格](https://yaml.org/spec/1.2.2/#white-space-characters)包围的情况下，才能换行长长的普通行。

Plain scalars must not begin with most [indicators](https://yaml.org/spec/1.2.2/#indicator-characters), as this would cause ambiguity with other YAML constructs. However, the “`:`”, “`?`” and “`-`” [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) may be used as the first character if followed by a non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) “safe” character, as this causes no ambiguity.
普通标量不能以大多数[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)开头，因为这会导致与其他 YAML 构造产生歧义。但是，如果后跟非[空格](https://yaml.org/spec/1.2.2/#white-space-characters)的 “safe” 字符，则可以将 “`：`”、“`？`” 和 “`-`” [指示符](https://yaml.org/spec/1.2.2/#indicator-characters)用作第一个字符，因为这不会产生歧义。

```
[126] ns-plain-first(c) ::=
    (
        ns-char
      - c-indicator
    )
  | (
      (
          c-mapping-key       # '?'
        | c-mapping-value     # ':'
        | c-sequence-entry    # '-'
      )
      [ lookahead = ns-plain-safe(c) ]
    )
```

Plain scalars must never contain the “`: `” and “` #`” character combinations. Such combinations would cause ambiguity with [mapping](https://yaml.org/spec/1.2.2/#mapping) [key/value pairs](https://yaml.org/spec/1.2.2/#mapping) and [comments](https://yaml.org/spec/1.2.2/#comments). In addition, inside [flow collections](https://yaml.org/spec/1.2.2/#flow-collection-styles), or when used as [implicit keys](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry), plain scalars must not contain the “`[`”, “`]`”, “`{`”, “`}`” and “`,`” characters. These characters would cause ambiguity with [flow collection](https://yaml.org/spec/1.2.2/#flow-collection-styles) structures.
普通标量绝不能包含 “`： `” 和 “` #`” 字符组合。此类组合会导致[映射](https://yaml.org/spec/1.2.2/#mapping)[键/值对](https://yaml.org/spec/1.2.2/#mapping)的歧义，并且 [评论](https://yaml.org/spec/1.2.2/#comments)。此外，在[流集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)中或用作[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)时，纯标量不得包含“`[`”、“`]`”、“`{`”、“`}`”和“`，`”字符。这些字符会导致[流式集合](https://yaml.org/spec/1.2.2/#flow-collection-styles)结构产生歧义。

```
[127]
ns-plain-safe(FLOW-OUT)  ::= ns-plain-safe-out
ns-plain-safe(FLOW-IN)   ::= ns-plain-safe-in
ns-plain-safe(BLOCK-KEY) ::= ns-plain-safe-out
ns-plain-safe(FLOW-KEY)  ::= ns-plain-safe-in
[128] ns-plain-safe-out ::=
  ns-char
[129] ns-plain-safe-in ::=
  ns-char - c-flow-indicator
[130] ns-plain-char(c) ::=
    (
        ns-plain-safe(c)
      - c-mapping-value    # ':'
      - c-comment          # '#'
    )
  | (
      [ lookbehind = ns-char ]
      c-comment          # '#'
    )
  | (
      c-mapping-value    # ':'
      [ lookahead = ns-plain-safe(c) ]
    )
```

**Example 7.10 Plain Characters
例 7.10 纯字符**

| `# Outside flow collection: - ::vector - ": - ()" - Up, up, and away! - -123 - https://example.com/foo#bar # Inside flow collection: - [ ::vector,  ": - ()",  "Up, up and away!",  -123,  https://example.com/foo#bar ] ` | `[ "::vector",  ": - ()",  "Up, up, and away!",  -123,  "http://example.com/foo#bar",  [ "::vector",    ": - ()",    "Up, up, and away!",    -123,    "http://example.com/foo#bar" ] ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `ns-plain-first(c)`
  `ns-plain-first（c）`
- `ns-plain-char(c)`
  `ns-plain-char （c） （英语）`
- `Not ns-plain-first(c)`
  `不是 ns-plain-first（c）`
- `Not ns-plain-char(c)`
  `不是 ns-plain-char（c）`

Plain scalars are further restricted to a single line when contained inside an [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry).
当普通标量包含在 [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) 的 intent 中。

```
[131]
ns-plain(n,FLOW-OUT)  ::= ns-plain-multi-line(n,FLOW-OUT)
ns-plain(n,FLOW-IN)   ::= ns-plain-multi-line(n,FLOW-IN)
ns-plain(n,BLOCK-KEY) ::= ns-plain-one-line(BLOCK-KEY)
ns-plain(n,FLOW-KEY)  ::= ns-plain-one-line(FLOW-KEY)
[132] nb-ns-plain-in-line(c) ::=
  (
    s-white*
    ns-plain-char(c)
  )*
[133] ns-plain-one-line(c) ::=
  ns-plain-first(c)
  nb-ns-plain-in-line(c)
```

**Example 7.11 Plain Implicit Keys
例 7.11 普通隐式键**

| `implicit block key : [  implicit flow key : value, ] ` | `{ "implicit block key":  [ { "implicit flow key": "value" } ] } ` |
| ------------------------------------------------------- | ------------------------------------------------------------ |
|                                                         |                                                              |

**Legend: 传说：**

- `ns-plain-one-line(c)`
  `ns-plain-one-line （c） （英语）`

All leading and trailing [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters are excluded from the [content](https://yaml.org/spec/1.2.2/#nodes). Each continuation line must therefore contain at least one non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) character. Empty lines, if any, are consumed as part of the [line folding](https://yaml.org/spec/1.2.2/#line-folding).
所有前导和尾随[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符都从 [内容](https://yaml.org/spec/1.2.2/#nodes)。因此，每个 continuation line 必须至少包含一个非[空格](https://yaml.org/spec/1.2.2/#white-space-characters) 字符。 空行（如果有）将作为[行折叠](https://yaml.org/spec/1.2.2/#line-folding)的一部分使用。

```
[134] s-ns-plain-next-line(n,c) ::=
  s-flow-folded(n)
  ns-plain-char(c)
  nb-ns-plain-in-line(c)
[135] ns-plain-multi-line(n,c) ::=
  ns-plain-one-line(c)
  s-ns-plain-next-line(n,c)*
```

**Example 7.12 Plain Lines 例 7.12 普通线条**

| `1st non-empty↓ ↓ ·2nd non-empty· →3rd non-empty ` | `"1st non-empty\n2nd non-empty 3rd non-empty" ` |
| -------------------------------------------------- | ----------------------------------------------- |
|                                                    |                                                 |

**Legend: 传说：**

- `nb-ns-plain-in-line(c)`
  `NB-NS 直线直列式 （c）`
- `s-ns-plain-next-line(n,c)`
  `s-ns-plain-next-line（n，c）`

## 7.4. Flow Collection Styles 7.4. 流式集合样式

A *flow collection* may be nested within a [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles) ([`FLOW-OUT` context]), nested within another flow collection ([`FLOW-IN` context]) or be a part of an [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) ([`FLOW-KEY` context] or [`BLOCK-KEY` context]). Flow collection entries are terminated by the “`,`” indicator. The final “`,`” may be omitted. This does not cause ambiguity because flow collection entries can never be [completely empty](https://yaml.org/spec/1.2.2/#example-empty-content).
*流集合*可以嵌套在[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)中 （[`FLOW-OUT` context]），嵌套在另一个流集合中 （[`FLOW-IN` context]） 或成为[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)的一部分 （[`FLOW-KEY` context] 或 [`BLOCK-KEY` context]）。流收集条目由 “`，`” 指示符终止。可以省略最后的 “`，`”。 这不会导致歧义，因为流收集条目永远不能是 [完全空](https://yaml.org/spec/1.2.2/#example-empty-content)。

```
[136]
in-flow(n,FLOW-OUT)  ::= ns-s-flow-seq-entries(n,FLOW-IN)
in-flow(n,FLOW-IN)   ::= ns-s-flow-seq-entries(n,FLOW-IN)
in-flow(n,BLOCK-KEY) ::= ns-s-flow-seq-entries(n,FLOW-KEY)
in-flow(n,FLOW-KEY)  ::= ns-s-flow-seq-entries(n,FLOW-KEY)
```

### 7.4.1. Flow Sequences 7.4.1. 流序列

*Flow sequence content* is denoted by surrounding “`[`” and “`]`” characters.
*流序列内容*由两边的 “`[`” 和 “`]`” 字符表示。

```
[137] c-flow-sequence(n,c) ::=
  c-sequence-start    # '['
  s-separate(n,c)?
  in-flow(n,c)?
  c-sequence-end      # ']'
```

Sequence entries are separated by a “`,`” character.
序列条目由 “`，`” 字符分隔。

```
[138] ns-s-flow-seq-entries(n,c) ::=
  ns-flow-seq-entry(n,c)
  s-separate(n,c)?
  (
    c-collect-entry     # ','
    s-separate(n,c)?
    ns-s-flow-seq-entries(n,c)?
  )?
```

**Example 7.13 Flow Sequence
示例 7.13 流序列**

| `- [ one, two, ] - [three ,four] ` | `[ [ "one",    "two" ],  [ "three",    "four" ] ] ` |
| ---------------------------------- | --------------------------------------------------- |
|                                    |                                                     |

**Legend: 传说：**

- `c-sequence-start c-sequence-end`
- `ns-flow-seq-entry(n,c)`
  `ns-flow-seq-entry（n，c） （ NS-流 seq 条目 （n，c） ）`

Any [flow node](https://yaml.org/spec/1.2.2/#flow-nodes) may be used as a flow sequence entry. In addition, YAML provides a [compact notation](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values) for the case where a flow sequence entry is a [mapping](https://yaml.org/spec/1.2.2/#mapping) with a [single key/value pair](https://yaml.org/spec/1.2.2/#mapping).
任何[流节点](https://yaml.org/spec/1.2.2/#flow-nodes)都可以用作流序列条目。此外，YAML 还为流序列条目是具有[单个键/值对](https://yaml.org/spec/1.2.2/#mapping)的[映射](https://yaml.org/spec/1.2.2/#mapping)的情况提供了[紧凑的表示法](https://yaml.org/spec/1.2.2/#example-flow-mapping-adjacent-values)。

```
[139] ns-flow-seq-entry(n,c) ::=
  ns-flow-pair(n,c) | ns-flow-node(n,c)
```

**Example 7.14 Flow Sequence Entries
示例 7.14 流序列条目**

| `[ "double quoted", 'single           quoted', plain text, [ nested ], single: pair, ] ` | `[ "double quoted",  "single quoted",  "plain text",  [ "nested" ],  { "single": "pair" } ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `ns-flow-node(n,c)`
  `ns-flow-node （n，c） （` 非 ）
- `ns-flow-pair(n,c)`
  `ns-流对 （n，c）`

### 7.4.2. Flow Mappings 7.4.2. 流映射

*Flow mappings* are denoted by surrounding “`{`” and “`}`” characters.
*流映射*由两边的 “`{`” 和 “`}`” 字符表示。

```
[140] c-flow-mapping(n,c) ::=
  c-mapping-start       # '{'
  s-separate(n,c)?
  ns-s-flow-map-entries(n,in-flow(c))?
  c-mapping-end         # '}'
```

Mapping entries are separated by a “`,`” character.
映射条目由 “`，`” 字符分隔。

```
[141] ns-s-flow-map-entries(n,c) ::=
  ns-flow-map-entry(n,c)
  s-separate(n,c)?
  (
    c-collect-entry     # ','
    s-separate(n,c)?
    ns-s-flow-map-entries(n,c)?
  )?
```

**Example 7.15 Flow Mappings
示例 7.15 流映射**

| `- { one : two , three: four , } - {five: six,seven : eight} ` | `[ { "one": "two",    "three": "four" },  { "five": "six",    "seven": "eight" } ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-mapping-start c-mapping-end`
  `c-映射开始 c-映射结束`
- `ns-flow-map-entry(n,c)`
  `ns-flow-map-entry（n，c） （ n，c）`

If the optional “`?`” mapping key indicator is specified, the rest of the entry may be [completely empty](https://yaml.org/spec/1.2.2/#example-empty-content).
如果指定了可选的 “`？`” 映射键指示符，则条目的其余部分可能[完全为空](https://yaml.org/spec/1.2.2/#example-empty-content)。

```
[142] ns-flow-map-entry(n,c) ::=
    (
      c-mapping-key    # '?' (not followed by non-ws char)
      s-separate(n,c)
      ns-flow-map-explicit-entry(n,c)
    )
  | ns-flow-map-implicit-entry(n,c)
[143] ns-flow-map-explicit-entry(n,c) ::=
    ns-flow-map-implicit-entry(n,c)
  | (
      e-node    # ""
      e-node    # ""
    )
```

**Example 7.16 Flow Mapping Entries
示例 7.16 流映射条目**

| `{ ? explicit: entry, implicit: entry, ?°° } ` | `{ "explicit": "entry",  "implicit": "entry",  null: null } ` |
| ---------------------------------------------- | ------------------------------------------------------------ |
|                                                |                                                              |

**Legend: 传说：**

- `ns-flow-map-explicit-entry(n,c)`
- `ns-flow-map-implicit-entry(n,c)`
- `e-node` `E-node 节点`

Normally, YAML insists the “`:`” mapping value indicator be [separated](https://yaml.org/spec/1.2.2/#separation-spaces) from the [value](https://yaml.org/spec/1.2.2/#nodes) by [white space](https://yaml.org/spec/1.2.2/#white-space-characters). A benefit of this restriction is that the “`:`” character can be used inside [plain scalars](https://yaml.org/spec/1.2.2/#plain-style), as long as it is not followed by [white space](https://yaml.org/spec/1.2.2/#white-space-characters). This allows for unquoted URLs and timestamps. It is also a potential source for confusion as “`a:1`” is a [plain scalar](https://yaml.org/spec/1.2.2/#plain-style) and not a [key/value pair](https://yaml.org/spec/1.2.2/#mapping).
通常，YAML 坚持将 “`：`” 映射值指示符与[值](https://yaml.org/spec/1.2.2/#nodes)[之间用](https://yaml.org/spec/1.2.2/#separation-spaces)[空格](https://yaml.org/spec/1.2.2/#white-space-characters)分隔。此限制的一个好处是可以在`` [plain scalars](https://yaml.org/spec/1.2.2/#plain-style)，只要它后面没有[空格](https://yaml.org/spec/1.2.2/#white-space-characters)。这允许使用不带引号的 URL 和时间戳。这也是一个潜在的混淆来源，因为 “`a：1`” 是一个[普通标量](https://yaml.org/spec/1.2.2/#plain-style)，而不是[键/值对](https://yaml.org/spec/1.2.2/#mapping)。

Note that the [value](https://yaml.org/spec/1.2.2/#nodes) may be [completely empty](https://yaml.org/spec/1.2.2/#example-empty-content) since its existence is indicated by the “`:`”.
请注意，[该值](https://yaml.org/spec/1.2.2/#nodes)可能[完全为空](https://yaml.org/spec/1.2.2/#example-empty-content)，因为它的存在由 “`：`” 表示。

```
[144] ns-flow-map-implicit-entry(n,c) ::=
    ns-flow-map-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-map-json-key-entry(n,c)
[145] ns-flow-map-yaml-key-entry(n,c) ::=
  ns-flow-yaml-node(n,c)
  (
      (
        s-separate(n,c)?
        c-ns-flow-map-separate-value(n,c)
      )
    | e-node    # ""
  )
[146] c-ns-flow-map-empty-key-entry(n,c) ::=
  e-node    # ""
  c-ns-flow-map-separate-value(n,c)
[147] c-ns-flow-map-separate-value(n,c) ::=
  c-mapping-value    # ':'
  [ lookahead ≠ ns-plain-safe(c) ]
  (
      (
        s-separate(n,c)
        ns-flow-node(n,c)
      )
    | e-node    # ""
  )
```

**Example 7.17 Flow Mapping Separate Values
例 7.17 流映射单独的值**

| `{ unquoted·:·"separate", https://foo.com, omitted value:°, °:·omitted key, } ` | `{ "unquoted": "separate",  "http://foo.com": null,  "omitted value": null,  null: "omitted key" } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `ns-flow-yaml-node(n,c)`
  `ns-flow-yaml-node（n，c）`
- `e-node` `E-node 节点`
- `c-ns-flow-map-separate-value(n,c)`

To ensure [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives), if a [key](https://yaml.org/spec/1.2.2/#nodes) inside a flow mapping is [JSON-like](https://yaml.org/spec/1.2.2/#flow-nodes), YAML allows the following [value](https://yaml.org/spec/1.2.2/#nodes) to be specified adjacent to the “`:`”. This causes no ambiguity, as all [JSON-like](https://yaml.org/spec/1.2.2/#flow-nodes) [keys](https://yaml.org/spec/1.2.2/#nodes) are surrounded by [indicators](https://yaml.org/spec/1.2.2/#indicator-characters). However, as this greatly reduces readability, YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) should [separate](https://yaml.org/spec/1.2.2/#separation-spaces) the [value](https://yaml.org/spec/1.2.2/#nodes) from the “`:`” on output, even in this case.
为了确保 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)，如果流映射中的[键](https://yaml.org/spec/1.2.2/#nodes)是 [与 JSON 类似](https://yaml.org/spec/1.2.2/#flow-nodes)，YAML 允许在 “`：”` 旁边指定以下[值](https://yaml.org/spec/1.2.2/#nodes)。这不会产生歧义，因为所有[类似 JSON 的](https://yaml.org/spec/1.2.2/#flow-nodes)[键](https://yaml.org/spec/1.2.2/#nodes)都用 [指标](https://yaml.org/spec/1.2.2/#indicator-characters)。但是，由于这会大大降低可读性，因此 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应该 [即使](https://yaml.org/spec/1.2.2/#separation-spaces)在这种情况下，也将[值](https://yaml.org/spec/1.2.2/#nodes)与 output 上的 “`：`” 分开。

```
[148] c-ns-flow-map-json-key-entry(n,c) ::=
  c-flow-json-node(n,c)
  (
      (
        s-separate(n,c)?
        c-ns-flow-map-adjacent-value(n,c)
      )
    | e-node    # ""
  )
[149] c-ns-flow-map-adjacent-value(n,c) ::=
  c-mapping-value          # ':'
  (
      (
        s-separate(n,c)?
        ns-flow-node(n,c)
      )
    | e-node    # ""
  )
```

**Example 7.18 Flow Mapping Adjacent Values
示例 7.18 流映射相邻值**

| `{ "adjacent":value, "readable":·value, "empty":° } ` | `{ "adjacent": "value",  "readable": "value",  "empty": null } ` |
| ----------------------------------------------------- | ------------------------------------------------------------ |
|                                                       |                                                              |

**Legend: 传说：**

- `c-flow-json-node(n,c)`
  `c-flow-json-node（n，c）`
- `e-node` `E-node 节点`
- `c-ns-flow-map-adjacent-value(n,c)`

A more compact notation is usable inside [flow sequences](https://yaml.org/spec/1.2.2/#flow-sequences), if the [mapping](https://yaml.org/spec/1.2.2/#mapping) contains a *single key/value pair*. This notation does not require the surrounding “`{`” and “`}`” characters. Note that it is not possible to specify any [node properties](https://yaml.org/spec/1.2.2/#node-properties) for the [mapping](https://yaml.org/spec/1.2.2/#mapping) in this case.
在[流序列](https://yaml.org/spec/1.2.2/#flow-sequences)中可以使用更紧凑的表示法，如果[映射](https://yaml.org/spec/1.2.2/#mapping) 包含*单个键/值对*。此表示法不需要周围的 “`{`” 和 “`}`” 字符。请注意，无法为[映射](https://yaml.org/spec/1.2.2/#mapping)指定任何[节点属性](https://yaml.org/spec/1.2.2/#node-properties) 在这种情况下。

**Example 7.19 Single Pair Flow Mappings
示例 7.19 单对流映射**

| `[ foo: bar ] ` | `[ { "foo": "bar" } ] ` |
| --------------- | ----------------------- |
|                 |                         |

**Legend: 传说：**

- `ns-flow-pair(n,c)`
  `ns-流对 （n，c）`

If the “`?`” indicator is explicitly specified, [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) is unambiguous and the syntax is identical to the general case.
如果显式指定了 “`？`” 指示符，则[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)是明确的，并且语法与一般情况相同。

```
[150] ns-flow-pair(n,c) ::=
    (
      c-mapping-key     # '?' (not followed by non-ws char)
      s-separate(n,c)
      ns-flow-map-explicit-entry(n,c)
    )
  | ns-flow-pair-entry(n,c)
```

**Example 7.20 Single Pair Explicit Entry
示例 7.20 单对显式条目**

| `[ ? foo bar : baz ] ` | `[ { "foo bar": "baz" } ] ` |
| ---------------------- | --------------------------- |
|                        |                             |

**Legend: 传说：**

- `ns-flow-map-explicit-entry(n,c)`

If the “`?`” indicator is omitted, [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) needs to see past the *implicit key* to recognize it as such. To limit the amount of lookahead required, the “`:`” indicator must appear at most 1024 Unicode characters beyond the start of the [key](https://yaml.org/spec/1.2.2/#nodes). In addition, the [key](https://yaml.org/spec/1.2.2/#nodes) is restricted to a single line.
如果省略 “`？”` 指示符，[则解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)需要越过*隐式键*才能识别它。要限制所需的先行量，“`：”`指示符必须在[键](https://yaml.org/spec/1.2.2/#nodes)开头之外最多出现 1024 个 Unicode 字符。此外，[该键](https://yaml.org/spec/1.2.2/#nodes)仅限于一行。

Note that YAML allows arbitrary [nodes](https://yaml.org/spec/1.2.2/#nodes) to be used as [keys](https://yaml.org/spec/1.2.2/#nodes). In particular, a [key](https://yaml.org/spec/1.2.2/#nodes) may be a [sequence](https://yaml.org/spec/1.2.2/#sequence) or a [mapping](https://yaml.org/spec/1.2.2/#mapping). Thus, without the above restrictions, practical one-pass [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) would have been impossible to implement.
请注意，YAML 允许将任意[节点](https://yaml.org/spec/1.2.2/#nodes)用作[键](https://yaml.org/spec/1.2.2/#nodes)。具体而言，[键](https://yaml.org/spec/1.2.2/#nodes)可以是[序列](https://yaml.org/spec/1.2.2/#sequence)或[映射](https://yaml.org/spec/1.2.2/#mapping)。因此，如果没有上述限制，实际的 one-pass [解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)将不可能实现。

```
[151] ns-flow-pair-entry(n,c) ::=
    ns-flow-pair-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-pair-json-key-entry(n,c)
[152] ns-flow-pair-yaml-key-entry(n,c) ::=
  ns-s-implicit-yaml-key(FLOW-KEY)
  c-ns-flow-map-separate-value(n,c)
[153] c-ns-flow-pair-json-key-entry(n,c) ::=
  c-s-implicit-json-key(FLOW-KEY)
  c-ns-flow-map-adjacent-value(n,c)
[154] ns-s-implicit-yaml-key(c) ::=
  ns-flow-yaml-node(0,c)
  s-separate-in-line?
  /* At most 1024 characters altogether */
[155] c-s-implicit-json-key(c) ::=
  c-flow-json-node(0,c)
  s-separate-in-line?
  /* At most 1024 characters altogether */
```

**Example 7.21 Single Pair Implicit Entries
例 7.21 单对隐式条目**

| `- [ YAML·: separate ] - [ °: empty key entry ] - [ {JSON: like}:adjacent ] ` | `[ [ { "YAML": "separate" } ],  [ { null: "empty key entry" } ],  [ { { "JSON": "like" }: "adjacent" } ] ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `ns-s-implicit-yaml-key`
- `e-node` `E-node 节点`
- `c-s-implicit-json-key`
- `Value` `价值`

**Example 7.22 Invalid Implicit Keys
例 7.22 无效的隐式键**

| `[ foo bar: invalid, "foo_...>1K characters..._bar": invalid ] ` | `ERROR: - The foo bar key spans multiple lines - The foo...bar key is too long ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

## 7.5. Flow Nodes

*JSON-like* [flow styles](https://yaml.org/spec/1.2.2/#flow-style-productions) all have explicit start and end [indicators](https://yaml.org/spec/1.2.2/#indicator-characters). The only [flow style](https://yaml.org/spec/1.2.2/#flow-style-productions) that does not have this property is the [plain scalar](https://yaml.org/spec/1.2.2/#plain-style). Note that none of the “JSON-like” styles is actually acceptable by JSON. Even the [double-quoted style](https://yaml.org/spec/1.2.2/#double-quoted-style) is a superset of the JSON string format.
*类似 JSON 的*[流样式](https://yaml.org/spec/1.2.2/#flow-style-productions)都有明确的开始和结束[指示器](https://yaml.org/spec/1.2.2/#indicator-characters)。唯一不具有此属性的[流样式](https://yaml.org/spec/1.2.2/#flow-style-productions)是 [plain scalar](https://yaml.org/spec/1.2.2/#plain-style)。请注意，JSON 实际上不接受任何“类似 JSON”的样式。即使是[双引号样式](https://yaml.org/spec/1.2.2/#double-quoted-style)也是 JSON 字符串格式的超集。

```
[156] ns-flow-yaml-content(n,c) ::=
  ns-plain(n,c)
[157] c-flow-json-content(n,c) ::=
    c-flow-sequence(n,c)
  | c-flow-mapping(n,c)
  | c-single-quoted(n,c)
  | c-double-quoted(n,c)
[158] ns-flow-content(n,c) ::=
    ns-flow-yaml-content(n,c)
  | c-flow-json-content(n,c)
```

**Example 7.23 Flow Content
示例 7.23 流内容**

| `- [ a, b ] - { a: b } - "a" - 'b' - c ` | `[ [ "a", "b" ],  { "a": "b" },  "a",  "b",  "c" ] ` |
| ---------------------------------------- | ---------------------------------------------------- |
|                                          |                                                      |

**Legend: 传说：**

- `c-flow-json-content(n,c)`
  `c-flow-json-content（n，c）`
- `ns-flow-yaml-content(n,c)`
  `ns-flow-yaml-content（n，c）`

A complete [flow](https://yaml.org/spec/1.2.2/#flow-style-productions) [node](https://yaml.org/spec/1.2.2/#nodes) also has optional [node properties](https://yaml.org/spec/1.2.2/#node-properties), except for [alias nodes](https://yaml.org/spec/1.2.2/#alias-nodes) which refer to the [anchored](https://yaml.org/spec/1.2.2/#anchors-and-aliases) [node properties](https://yaml.org/spec/1.2.2/#node-properties).
完整[流](https://yaml.org/spec/1.2.2/#flow-style-productions)[节点](https://yaml.org/spec/1.2.2/#nodes)还具有可选的[节点属性](https://yaml.org/spec/1.2.2/#node-properties)，但引用[锚定](https://yaml.org/spec/1.2.2/#anchors-and-aliases)[节点属性](https://yaml.org/spec/1.2.2/#node-properties)的[别名节点](https://yaml.org/spec/1.2.2/#alias-nodes)除外。

```
[159] ns-flow-yaml-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-yaml-content(n,c)
  | (
      c-ns-properties(n,c)
      (
          (
            s-separate(n,c)
            ns-flow-yaml-content(n,c)
          )
        | e-scalar
      )
    )
[160] c-flow-json-node(n,c) ::=
  (
    c-ns-properties(n,c)
    s-separate(n,c)
  )?
  c-flow-json-content(n,c)
[161] ns-flow-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-content(n,c)
  | (
      c-ns-properties(n,c)
      (
        (
          s-separate(n,c)
          ns-flow-content(n,c)
        )
        | e-scalar
      )
    )
```

**Example 7.24 Flow Nodes 示例 7.24 流节点**

| `- !!str "a" - 'b' - &anchor "c" - *anchor - !!str° ` | `[ "a",  "b",  "c",  "c",  "" ] ` |
| ----------------------------------------------------- | --------------------------------- |
|                                                       |                                   |

**Legend: 传说：**

- `c-flow-json-node(n,c)`
  `c-flow-json-node（n，c）`
- `ns-flow-yaml-node(n,c)`
  `ns-flow-yaml-node（n，c）`

# Chapter 8. Block Style Productions 第 8 章.块式制作

YAML’s *block styles* employ [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) rather than [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) to denote structure. This results in a more human readable (though less compact) notation.
YAML 的*块样式*使用[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)而不是[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)来表示结构。这会产生更易读（尽管不太紧凑）的表示法。

## 8.1. Block Scalar Styles 8.1. 块标量样式

YAML provides two *block scalar styles*, [literal](https://yaml.org/spec/1.2.2/#literal-style) and [folded](https://yaml.org/spec/1.2.2/#line-folding). Each provides a different trade-off between readability and expressive power.
YAML 提供两种*块标量样式*，[Literal](https://yaml.org/spec/1.2.2/#literal-style) 和 [folded](https://yaml.org/spec/1.2.2/#line-folding)。每个版本在可读性和表现力之间提供了不同的权衡。

### 8.1.1. Block Scalar Headers 8.1.1. 块标量头文件

[Block scalars](https://yaml.org/spec/1.2.2/#block-scalar-styles) are controlled by a few [indicators](https://yaml.org/spec/1.2.2/#indicator-characters) given in a *header* preceding the [content](https://yaml.org/spec/1.2.2/#nodes) itself. This header is followed by a non-content [line break](https://yaml.org/spec/1.2.2/#line-break-characters) with an optional [comment](https://yaml.org/spec/1.2.2/#comments). This is the only case where a [comment](https://yaml.org/spec/1.2.2/#comments) must not be followed by additional [comment](https://yaml.org/spec/1.2.2/#comments) lines.
[区块标量](https://yaml.org/spec/1.2.2/#block-scalar-styles)由*标头*中给出的几个[指标](https://yaml.org/spec/1.2.2/#indicator-characters)控制 在[内容](https://yaml.org/spec/1.2.2/#nodes)本身之前。此标头后跟一个非内容[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)，其中包含可选的 [评论](https://yaml.org/spec/1.2.2/#comments)。这是唯一一种情况下，注释后不得在[注释](https://yaml.org/spec/1.2.2/#comments)后附加 [注释](https://yaml.org/spec/1.2.2/#comments)行。

> Note: See [Production Parameters](https://yaml.org/spec/1.2.2/#production-parameters) for the definition of the `t` variable.
> 注： 有关 `t` 变量的定义，请参阅[生产参数](https://yaml.org/spec/1.2.2/#production-parameters)。

```
[162] c-b-block-header(t) ::=
  (
      (
        c-indentation-indicator
        c-chomping-indicator(t)
      )
    | (
        c-chomping-indicator(t)
        c-indentation-indicator
      )
  )
  s-b-comment
```

**Example 8.1 Block Scalar Header
示例 8.1 块标量标头**

| `- | # Empty header↓ literal - >1 # Indentation indicator↓ ·folded - |+ # Chomping indicator↓ keep - >1- # Both indicators↓ ·strip ` | `[ "literal\n",  " folded\n",  "keep\n\n",  " strip" ] ` |
| ------------------------------------------------------------ | -------------------------------------------------------- |
|                                                              |                                                          |

**Legend: 传说：**

- `c-b-block-header(t)`
  `C-B-区块头 （T）`

#### 8.1.1.1. Block Indentation Indicator 8.1.1.1. 块缩进指示器

Every block scalar has a *content indentation level*. The content of the block scalar excludes a number of leading [spaces](https://yaml.org/spec/1.2.2/#white-space-characters) on each line up to the content indentation level.
每个块标量都有一个*内容缩进级别*。块标量的内容不包括每行上的一些前导[空格](https://yaml.org/spec/1.2.2/#white-space-characters)，直到内容缩进级别。

If a block scalar has an *indentation indicator*, then the content indentation level of the block scalar is equal to the indentation level of the block scalar plus the integer value of the indentation indicator character.
如果块标量具有*缩进指示符*，则块标量的内容缩进级别等于块标量的缩进级别加上缩进指示符的整数值。

If no indentation indicator is given, then the content indentation level is equal to the number of leading [spaces](https://yaml.org/spec/1.2.2/#white-space-characters) on the first non-[empty line](https://yaml.org/spec/1.2.2/#empty-lines) of the contents. If there is no non-[empty line](https://yaml.org/spec/1.2.2/#empty-lines) then the content indentation level is equal to the number of spaces on the longest line.
如果未给出缩进指示符，则内容缩进级别等于内容第一个非[空行](https://yaml.org/spec/1.2.2/#empty-lines)上的前导[空格](https://yaml.org/spec/1.2.2/#white-space-characters)数。如果没有非[空行](https://yaml.org/spec/1.2.2/#empty-lines)，则内容缩进级别等于最长行上的空格数。

It is an error if any non-[empty line](https://yaml.org/spec/1.2.2/#empty-lines) does not begin with a number of spaces greater than or equal to the content indentation level.
如果任何非[空行](https://yaml.org/spec/1.2.2/#empty-lines)不以大于或等于内容缩进级别的空格数开头，则会出现错误。

It is an error for any of the leading [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) to contain more [spaces](https://yaml.org/spec/1.2.2/#white-space-characters) than the first non-[empty line](https://yaml.org/spec/1.2.2/#empty-lines).
任何前导[空行](https://yaml.org/spec/1.2.2/#empty-lines)包含更多[空格](https://yaml.org/spec/1.2.2/#white-space-characters)都是错误的 而不是第一个非[空行](https://yaml.org/spec/1.2.2/#empty-lines)。

A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should only emit an explicit indentation indicator for cases where detection will fail.
YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应仅在检测失败的情况下发出显式缩进指示器。

```
[163] c-indentation-indicator ::=
  [x31-x39]    # 1-9
```

**Example 8.2 Block Indentation Indicator
例 8.2 块缩进指示符**

| `- |° ·detected - >° · ·· ··# detected - |1 ··explicit - >° ·→ ·detected ` | `[ "detected\n",  "\n\n# detected\n",  " explicit\n",  "\t\ndetected\n" ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-indentation-indicator`
  `c-压痕指示符`
- `s-indent(n)`
  `s 缩进 （n）`

**Example 8.3 Invalid Block Scalar Indentation Indicators
例 8.3 无效的块标量缩进指示符**

| `- | ·· ·text - > ··text ·text - |2 ·text ` | `ERROR: - A leading all-space line must  not have too many spaces. - A following text line must  not be less indented. - The text is less indented  than the indicated level. ` |
| ------------------------------------------- | ------------------------------------------------------------ |
|                                             |                                                              |

#### 8.1.1.2. Block Chomping Indicator 8.1.1.2. 块阻塞指示器

*Chomping* controls how final [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) and trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are interpreted. YAML provides three chomping methods:
*Chomping* 控制如何解释最后[的换行符](https://yaml.org/spec/1.2.2/#line-break-characters)和尾随[的空行](https://yaml.org/spec/1.2.2/#empty-lines)。YAML 提供了三种 chomping 方法：

- Strip 带

  ​    *Stripping* is specified by the “`-`” chomping indicator. In this case, the final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) and any trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are excluded from the [scalar’s content](https://yaml.org/spec/1.2.2/#scalar). *剥离*由 “`-`” 阻塞指示器指定。在这种情况下，最后一个[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符和任何尾随[空行](https://yaml.org/spec/1.2.2/#empty-lines)都从[标量的内容](https://yaml.org/spec/1.2.2/#scalar)中排除。  

- Clip 夹

  ​    *Clipping* is the default behavior used if no explicit chomping indicator is specified. In this case, the final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) character is preserved in the [scalar’s content](https://yaml.org/spec/1.2.2/#scalar). However, any trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are excluded from the [scalar’s content](https://yaml.org/spec/1.2.2/#scalar). 如果未指定显式 chomping 指示符，*则 Clipping* 将使用的默认行为。在这种情况下，最后的[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符将保留在[标量的内容](https://yaml.org/spec/1.2.2/#scalar)中。但是，任何尾随[空行](https://yaml.org/spec/1.2.2/#empty-lines)都将从[标量的内容](https://yaml.org/spec/1.2.2/#scalar)中排除。  

- Keep 保持

  ​    *Keeping* is specified by the “`+`” chomping indicator. In this case, the final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) and any trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are considered to be part of the [scalar’s content](https://yaml.org/spec/1.2.2/#scalar). These additional lines are not subject to [folding](https://yaml.org/spec/1.2.2/#line-folding). *保持*由 “`+`” 咀嚼指示器指定。在这种情况下，最后一个[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符和任何尾随[空行](https://yaml.org/spec/1.2.2/#empty-lines)都被视为[标量内容](https://yaml.org/spec/1.2.2/#scalar)的一部分。这些额外的行不受[折叠](https://yaml.org/spec/1.2.2/#line-folding)的影响。  

The chomping method used is a [presentation detail](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) and must not be used to convey [content](https://yaml.org/spec/1.2.2/#nodes) information.
使用的咀嚼方法是[演示文稿详细信息](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)，不得用于传达[内容](https://yaml.org/spec/1.2.2/#nodes)信息。

```
[164]
c-chomping-indicator(STRIP) ::= '-'
c-chomping-indicator(KEEP)  ::= '+'
c-chomping-indicator(CLIP)  ::= ""
```

The interpretation of the final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) of a [block scalar](https://yaml.org/spec/1.2.2/#block-scalar-styles) is controlled by the chomping indicator specified in the [block scalar header](https://yaml.org/spec/1.2.2/#block-scalar-headers).
[块标量](https://yaml.org/spec/1.2.2/#block-scalar-styles)的最后一个[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符的解释由[块标量标头](https://yaml.org/spec/1.2.2/#block-scalar-headers)中指定的 chomping 指示符控制。

```
[165]
b-chomped-last(STRIP) ::= b-non-content  | <end-of-input>
b-chomped-last(CLIP)  ::= b-as-line-feed | <end-of-input>
b-chomped-last(KEEP)  ::= b-as-line-feed | <end-of-input>
```

**Example 8.4 Chomping Final Line Break
例 8.4 截断最终换行符**

| `strip: |-  text↓ clip: |  text↓ keep: |+  text↓ ` | `{ "strip": "text",  "clip": "text\n",  "keep": "text\n" } ` |
| -------------------------------------------------- | ------------------------------------------------------------ |
|                                                    |                                                              |

**Legend: 传说：**

- `b-non-content`
  `b-非含量`
- `b-as-line-feed`
  `B 作为换行符`

The interpretation of the trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) following a [block scalar](https://yaml.org/spec/1.2.2/#block-scalar-styles) is also controlled by the chomping indicator specified in the [block scalar header](https://yaml.org/spec/1.2.2/#block-scalar-headers).
[块标量](https://yaml.org/spec/1.2.2/#block-scalar-styles)后面的尾随[空行](https://yaml.org/spec/1.2.2/#empty-lines)的解释也由[块标量标头](https://yaml.org/spec/1.2.2/#block-scalar-headers)中指定的 chomping 指示符控制。

```
[166]
l-chomped-empty(n,STRIP) ::= l-strip-empty(n)
l-chomped-empty(n,CLIP)  ::= l-strip-empty(n)
l-chomped-empty(n,KEEP)  ::= l-keep-empty(n)
[167] l-strip-empty(n) ::=
  (
    s-indent-less-or-equal(n)
    b-non-content
  )*
  l-trail-comments(n)?
[168] l-keep-empty(n) ::=
  l-empty(n,BLOCK-IN)*
  l-trail-comments(n)?
```

Explicit [comment](https://yaml.org/spec/1.2.2/#comments) lines may follow the trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines). To prevent ambiguity, the first such [comment](https://yaml.org/spec/1.2.2/#comments) line must be less [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) than the [block scalar content](https://yaml.org/spec/1.2.2/#block-scalar-styles). Additional [comment](https://yaml.org/spec/1.2.2/#comments) lines, if any, are not so restricted. This is the only case where the [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) of [comment](https://yaml.org/spec/1.2.2/#comments) lines is constrained.
显式[注释](https://yaml.org/spec/1.2.2/#comments)行可以跟在尾随[的空行](https://yaml.org/spec/1.2.2/#empty-lines)后面。为防止歧义，第一个此类[注释](https://yaml.org/spec/1.2.2/#comments)行必须缩[进](https://yaml.org/spec/1.2.2/#indentation-spaces)较少 比[块标量内容](https://yaml.org/spec/1.2.2/#block-scalar-styles)。其他[注释](https://yaml.org/spec/1.2.2/#comments)行 （如果有） 不受此类限制。这是 [Comments](https://yaml.org/spec/1.2.2/#comments) 行缩[进](https://yaml.org/spec/1.2.2/#indentation-spaces)受到限制的唯一情况。

```
[169] l-trail-comments(n) ::=
  s-indent-less-than(n)
  c-nb-comment-text
  b-comment
  l-comment*
```

**Example 8.5 Chomping Trailing Lines
例 8.5 切碎尾随线**

| `# Strip  # Comments: strip: |-  # text↓ ··⇓ ·# Clip ··# comments: ↓ clip: |  # text↓ ·↓ ·# Keep ··# comments: ↓ keep: |+  # text↓ ↓ ·# Trail ··# comments. ` | `{ "strip": "# text",  "clip": "# text\n",  "keep": "# text\n\n" } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `l-strip-empty(n)`
  `L-条带-空 （n）`
- `l-keep-empty(n)`
  `l-保持空 （n）`
- `l-trail-comments(n)`
  `左尾条注释 （n）`

If a [block scalar](https://yaml.org/spec/1.2.2/#block-scalar-styles) consists only of [empty lines](https://yaml.org/spec/1.2.2/#empty-lines), then these lines are considered as trailing lines and hence are affected by chomping.
如果[块标量](https://yaml.org/spec/1.2.2/#block-scalar-styles)仅由[空行](https://yaml.org/spec/1.2.2/#empty-lines)组成，则这些行被视为尾随行，因此会受到 chomping 的影响。

**Example 8.6 Empty Scalar Chomping
例 8.6 空标量 Chomping**

| `strip: >- ↓ clip: > ↓ keep: |+ ↓ ` | `{ "strip": "",  "clip": "",  "keep": "\n" } ` |
| ----------------------------------- | ---------------------------------------------- |
|                                     |                                                |

**Legend: 传说：**

- `l-strip-empty(n)`
  `L-条带-空 （n）`
- `l-keep-empty(n)`
  `l-保持空 （n）`

### 8.1.2. Literal Style 8.1.2. 字面量样式

The *literal style* is denoted by the “`|`” indicator. It is the simplest, most restricted and most readable [scalar style](https://yaml.org/spec/1.2.2/#node-styles).
*文字样式*由 “`|`” 指示符表示。它是最简单、最受限和最具可读性的[标量样式](https://yaml.org/spec/1.2.2/#node-styles)。

```
[170] c-l+literal(n) ::=
  c-literal                # '|'
  c-b-block-header(t)
  l-literal-content(n+m,t)
```

**Example 8.7 Literal Scalar
例 8.7 文本标量**

| `|↓ ·literal↓ ·→text↓ ↓ ` | `"literal\n\ttext\n" ` |
| ------------------------- | ---------------------- |
|                           |                        |

**Legend: 传说：**

- `c-l+literal(n)`
  `c-l+文字 （n）`

Inside literal scalars, all ([indented](https://yaml.org/spec/1.2.2/#indentation-spaces)) characters are considered to be [content](https://yaml.org/spec/1.2.2/#nodes), including [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters. Note that all [line break](https://yaml.org/spec/1.2.2/#line-break-characters) characters are [normalized](https://yaml.org/spec/1.2.2/#line-break-characters). In addition, [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are not [folded](https://yaml.org/spec/1.2.2/#line-folding), though final [line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) and trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) are [chomped](https://yaml.org/spec/1.2.2/#block-chomping-indicator).
在文本标量中，所有（[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)的）字符都被视为 [内容](https://yaml.org/spec/1.2.2/#nodes)，包括[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符。请注意，所有[换行](https://yaml.org/spec/1.2.2/#line-break-characters)符都[已规范化](https://yaml.org/spec/1.2.2/#line-break-characters)。此外，[空行](https://yaml.org/spec/1.2.2/#empty-lines)不会[折叠](https://yaml.org/spec/1.2.2/#line-folding)，但最后的[换行符](https://yaml.org/spec/1.2.2/#line-break-characters)和尾随[的空行](https://yaml.org/spec/1.2.2/#empty-lines)会被[截断](https://yaml.org/spec/1.2.2/#block-chomping-indicator)。

There is no way to escape characters inside literal scalars. This restricts them to [printable](https://yaml.org/spec/1.2.2/#character-set) characters. In addition, there is no way to break a long literal line.
无法对文本标量中的字符进行转义。这会将它们限制为[可打印](https://yaml.org/spec/1.2.2/#character-set)字符。此外，无法断开较长的 Literal 行。

```
[171] l-nb-literal-text(n) ::=
  l-empty(n,BLOCK-IN)*
  s-indent(n) nb-char+
[172] b-nb-literal-next(n) ::=
  b-as-line-feed
  l-nb-literal-text(n)
[173] l-literal-content(n,t) ::=
  (
    l-nb-literal-text(n)
    b-nb-literal-next(n)*
    b-chomped-last(t)
  )?
  l-chomped-empty(n,t)
```

**Example 8.8 Literal Content
例 8.8 文字内容**

| `| · ·· ··literal↓ ···↓ ·· ··text↓ ↓ ·# Comment ` | `"\n\nliteral\n·\n\ntext\n" ` |
| ------------------------------------------------- | ----------------------------- |
|                                                   |                               |

**Legend: 传说：**

- `l-nb-literal-text(n)`
  `l-nb-文字文本 （n）`
- `b-nb-literal-next(n)`
  `b-nb-文字下一个 （n）`
- `b-chomped-last(t)`
  `b-最后被切碎 （t）`
- `l-chomped-empty(n,t)`
  `L-空 （n，t）`

### 8.1.3. Folded Style 8.1.3. 折叠样式

The *folded style* is denoted by the “`>`” indicator. It is similar to the [literal style](https://yaml.org/spec/1.2.2/#literal-style); however, folded scalars are subject to [line folding](https://yaml.org/spec/1.2.2/#line-folding).
*折叠样式*由 “`>`” 指示符表示。它类似于 [Literal 样式](https://yaml.org/spec/1.2.2/#literal-style);但是，折叠标量受 [折线](https://yaml.org/spec/1.2.2/#line-folding)。

```
[174] c-l+folded(n) ::=
  c-folded                 # '>'
  c-b-block-header(t)
  l-folded-content(n+m,t)
```

**Example 8.9 Folded Scalar
例 8.9 折叠标量**

| `>↓ ·folded↓ ·text↓ ↓ ` | `"folded text\n" ` |
| ----------------------- | ------------------ |
|                         |                    |

**Legend: 传说：**

- `c-l+folded(n)`
  `C-L+折叠 （N）`

[Folding](https://yaml.org/spec/1.2.2/#line-folding) allows long lines to be broken anywhere a single [space](https://yaml.org/spec/1.2.2/#white-space-characters) character separates two non-[space](https://yaml.org/spec/1.2.2/#white-space-characters) characters.
[折叠](https://yaml.org/spec/1.2.2/#line-folding)允许在单个[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符分隔两个非[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符的任何位置断开长行。

```
[175] s-nb-folded-text(n) ::=
  s-indent(n)
  ns-char
  nb-char*
[176] l-nb-folded-lines(n) ::=
  s-nb-folded-text(n)
  (
    b-l-folded(n,BLOCK-IN)
    s-nb-folded-text(n)
  )*
```

**Example 8.10 Folded Lines
例 8.10 折叠的线条**

| `> ·folded↓ ·line↓ ↓ ·next ·line↓   * bullet    * list   * lines ·last↓ ·line↓ # Comment ` | `"\nfolded line\nnext line\n  \ * bullet\n \n  * list\n  \ * lines\n\nlast line\n" ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `l-nb-folded-lines(n)`
  `L-NB 折叠线 （N）`
- `s-nb-folded-text(n)`
  `s-nb-折叠文本 （n）`

(The following three examples duplicate this example, each highlighting different productions.)
（以下三个示例与此示例相同，每个示例都突出显示了不同的作品。

Lines starting with [white space](https://yaml.org/spec/1.2.2/#white-space-characters) characters (*more-indented* lines) are not [folded](https://yaml.org/spec/1.2.2/#line-folding).
以[空格](https://yaml.org/spec/1.2.2/#white-space-characters)字符开头的行（*缩进更多的*行）不是 [折叠](https://yaml.org/spec/1.2.2/#line-folding)。

```
[177] s-nb-spaced-text(n) ::=
  s-indent(n)
  s-white
  nb-char*
[178] b-l-spaced(n) ::=
  b-as-line-feed
  l-empty(n,BLOCK-IN)*
[179] l-nb-spaced-lines(n) ::=
  s-nb-spaced-text(n)
  (
    b-l-spaced(n)
    s-nb-spaced-text(n)
  )*
```

**Example 8.11 More Indented Lines
例 8.11 更多缩进行**

| `>  folded line  next line ···* bullet↓ ↓ ···* list↓ ···* lines↓  last line # Comment ` | `"\nfolded line\nnext line\n  \ * bullet\n \n  * list\n  \ * lines\n\nlast line\n" ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `l-nb-spaced-lines(n)`
  `L-NB-间隔线 （n）`
- `s-nb-spaced-text(n)`
  `s-nb-空格文本 （n）`

[Line breaks](https://yaml.org/spec/1.2.2/#line-break-characters) and [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) separating folded and more-indented lines are also not [folded](https://yaml.org/spec/1.2.2/#line-folding).
分隔折叠行和缩进较多行的换[行](https://yaml.org/spec/1.2.2/#line-break-characters)符和[空行](https://yaml.org/spec/1.2.2/#empty-lines)也不会[折叠](https://yaml.org/spec/1.2.2/#line-folding)。

```
[180] l-nb-same-lines(n) ::=
  l-empty(n,BLOCK-IN)*
  (
      l-nb-folded-lines(n)
    | l-nb-spaced-lines(n)
  )
[181] l-nb-diff-lines(n) ::=
  l-nb-same-lines(n)
  (
    b-as-line-feed
    l-nb-same-lines(n)
  )*
```

**Example 8.12 Empty Separation Lines
例 8.12 空分隔线**

| `> ↓ folded line↓ ↓ next line↓   * bullet    * list   * lines↓ ↓ last line # Comment ` | `"\nfolded line\nnext line\n  \ * bullet\n \n  * list\n  \ * lines\n\nlast line\n" ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `b-as-line-feed`
  `B 作为换行符`
- `(separation) l-empty(n,c)`
  `（分隔） L-空 （n，c）`

The final [line break](https://yaml.org/spec/1.2.2/#line-break-characters) and trailing [empty lines](https://yaml.org/spec/1.2.2/#empty-lines) if any, are subject to [chomping](https://yaml.org/spec/1.2.2/#block-chomping-indicator) and are never [folded](https://yaml.org/spec/1.2.2/#line-folding).
最后[的换行符](https://yaml.org/spec/1.2.2/#line-break-characters)和尾随[的空行](https://yaml.org/spec/1.2.2/#empty-lines)（如果有）受 [咀嚼](https://yaml.org/spec/1.2.2/#block-chomping-indicator)，永远不会[折叠](https://yaml.org/spec/1.2.2/#line-folding)。

```
[182] l-folded-content(n,t) ::=
  (
    l-nb-diff-lines(n)
    b-chomped-last(t)
  )?
  l-chomped-empty(n,t)
```

**Example 8.13 Final Empty Lines
例 8.13 最终空行**

| `>  folded line  next line   * bullet    * list   * lines  last line↓ ↓ # Comment ` | `"\nfolded line\nnext line\n  \ * bullet\n \n  * list\n  \ * lines\n\nlast line\n" ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `b-chomped-last(t)`
  `b-最后被切碎 （t）`
- `l-chomped-empty(n,t)`
  `L-空 （n，t）`

## 8.2. Block Collection Styles 8.2. 块集合样式

For readability, *block collections styles* are not denoted by any [indicator](https://yaml.org/spec/1.2.2/#indicator-characters). Instead, YAML uses a lookahead method, where a block collection is distinguished from a [plain scalar](https://yaml.org/spec/1.2.2/#plain-style) only when a [key/value pair](https://yaml.org/spec/1.2.2/#mapping) or a [sequence entry](https://yaml.org/spec/1.2.2/#block-sequences) is seen.
为了便于阅读，*块集合样式*不由任何[指示符](https://yaml.org/spec/1.2.2/#indicator-characters)表示。相反，YAML 使用先行方法，其中仅当看到[键/值对](https://yaml.org/spec/1.2.2/#mapping)或[序列条目](https://yaml.org/spec/1.2.2/#block-sequences)时，才会将块集合与[普通标量](https://yaml.org/spec/1.2.2/#plain-style)区分开来。

### 8.2.1. Block Sequences 8.2.1. 块序列

A *block sequence* is simply a series of [nodes](https://yaml.org/spec/1.2.2/#nodes), each denoted by a leading “`-`” indicator. The “`-`” indicator must be [separated](https://yaml.org/spec/1.2.2/#separation-spaces) from the [node](https://yaml.org/spec/1.2.2/#nodes) by [white space](https://yaml.org/spec/1.2.2/#white-space-characters). This allows “`-`” to be used as the first character in a [plain scalar](https://yaml.org/spec/1.2.2/#plain-style) if followed by a non-space character (e.g. “`-42`”).
*区块序列*只是一系列节点，每个[节点](https://yaml.org/spec/1.2.2/#nodes)都由一个前导 “`-`” 指示符表示。“`-`” 指示符必须与[节点](https://yaml.org/spec/1.2.2/#nodes)[之间用](https://yaml.org/spec/1.2.2/#separation-spaces)[空格](https://yaml.org/spec/1.2.2/#white-space-characters)分隔。这允许将 “`-`” 用作[纯标量](https://yaml.org/spec/1.2.2/#plain-style)中的第一个字符，如果后跟非空格字符（例如 “`-42`”）。

```
[183] l+block-sequence(n) ::=
  (
    s-indent(n+1+m)
    c-l-block-seq-entry(n+1+m)
  )+
[184] c-l-block-seq-entry(n) ::=
  c-sequence-entry    # '-'
  [ lookahead ≠ ns-char ]
  s-l+block-indented(n,BLOCK-IN)
```

**Example 8.14 Block Sequence
例 8.14 块序列**

| `block sequence: ··- one↓  - two : three↓ ` | `{ "block sequence": [    "one",    { "two": "three" } ] } ` |
| ------------------------------------------- | ------------------------------------------------------------ |
|                                             |                                                              |

**Legend: 传说：**

- `c-l-block-seq-entry(n)`
  `c-l-块-seq-条目 （n）`
- `auto-detected s-indent(n)`
  `自动检测到的 s 缩进 （n）`

The entry [node](https://yaml.org/spec/1.2.2/#nodes) may be either [completely empty](https://yaml.org/spec/1.2.2/#example-empty-content), be a nested [block node](https://yaml.org/spec/1.2.2/#block-nodes) or use a *compact in-line notation*. The compact notation may be used when the entry is itself a nested [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles). In this case, both the “`-`” indicator and the following [spaces](https://yaml.org/spec/1.2.2/#white-space-characters) are considered to be part of the [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) of the nested [collection](https://yaml.org/spec/1.2.2/#collections). Note that it is not possible to specify [node properties](https://yaml.org/spec/1.2.2/#node-properties) for such a [collection](https://yaml.org/spec/1.2.2/#collections).
入口[节点](https://yaml.org/spec/1.2.2/#nodes)可以是[完全空](https://yaml.org/spec/1.2.2/#example-empty-content)的，可以是嵌套[的块节点](https://yaml.org/spec/1.2.2/#block-nodes)，也可以使用*紧凑的内联表示法*。当条目本身是嵌套[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)时，可以使用紧凑表示法。在这种情况下，“`-`” 指示符和后面的[空格](https://yaml.org/spec/1.2.2/#white-space-characters)都被视为嵌套[集合](https://yaml.org/spec/1.2.2/#collections)缩[进](https://yaml.org/spec/1.2.2/#indentation-spaces)的一部分。请注意，[无法为此类](https://yaml.org/spec/1.2.2/#node-properties) [集合](https://yaml.org/spec/1.2.2/#collections)。

```
[185] s-l+block-indented(n,c) ::=
    (
      s-indent(m)
      (
          ns-l-compact-sequence(n+1+m)
        | ns-l-compact-mapping(n+1+m)
      )
    )
  | s-l+block-node(n,c)
  | (
      e-node    # ""
      s-l-comments
    )
[186] ns-l-compact-sequence(n) ::=
  c-l-block-seq-entry(n)
  (
    s-indent(n)
    c-l-block-seq-entry(n)
  )*
```

**Example 8.15 Block Sequence Entry Types
例 8.15 块序列条目类型**

| `-° # Empty - | block node -·- one # Compact ··- two # sequence - one: two # Compact mapping ` | `[ null,  "block node\n",  [ "one", "two" ],  { "one": "two" } ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `Empty` `空`
- `s-l+block-node(n,c)`
  `S-L+块节点 （n，c）`
- `ns-l-compact-sequence(n)`
  `ns-l-紧凑序列 （n）`
- `ns-l-compact-mapping(n)`
  `ns-l-压缩映射 （n）`

### 8.2.2. Block Mappings 8.2.2. 块映射

A *Block mapping* is a series of entries, each [presenting](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree) a [key/value pair](https://yaml.org/spec/1.2.2/#mapping).
*块映射*是一系列条目，每个条目[都表示](https://yaml.org/spec/1.2.2/#presenting-the-serialization-tree)一个[键/值对](https://yaml.org/spec/1.2.2/#mapping)。

```
[187] l+block-mapping(n) ::=
  (
    s-indent(n+1+m)
    ns-l-block-map-entry(n+1+m)
  )+
```

**Example 8.16 Block Mappings
例 8.16 块映射**

| `block mapping: ·key: value↓ ` | `{ "block mapping": {    "key": "value" } } ` |
| ------------------------------ | --------------------------------------------- |
|                                |                                               |

**Legend: 传说：**

- `ns-l-block-map-entry(n)`
  `ns-l-块映射条目 （n）`
- `auto-detected s-indent(n)`
  `自动检测到的 s 缩进 （n）`

If the “`?`” indicator is specified, the optional value node must be specified on a separate line, denoted by the “`:`” indicator. Note that YAML allows here the same [compact in-line notation](https://yaml.org/spec/1.2.2/#example-block-sequence) described above for [block sequence](https://yaml.org/spec/1.2.2/#block-sequences) entries.
如果指定了 “`？`” 指示符，则必须在单独的行上指定可选值节点，由 “`：”` 指示符表示。请注意，YAML 在此处允许对 [block sequence](https://yaml.org/spec/1.2.2/#block-sequences) 条目使用上述相同的[紧凑内联表示法](https://yaml.org/spec/1.2.2/#example-block-sequence)。

```
[188] ns-l-block-map-entry(n) ::=
    c-l-block-map-explicit-entry(n)
  | ns-l-block-map-implicit-entry(n)
[189] c-l-block-map-explicit-entry(n) ::=
  c-l-block-map-explicit-key(n)
  (
      l-block-map-explicit-value(n)
    | e-node                        # ""
  )
[190] c-l-block-map-explicit-key(n) ::=
  c-mapping-key                     # '?' (not followed by non-ws char)
  s-l+block-indented(n,BLOCK-OUT)
[191] l-block-map-explicit-value(n) ::=
  s-indent(n)
  c-mapping-value                   # ':' (not followed by non-ws char)
  s-l+block-indented(n,BLOCK-OUT)
```

**Example 8.17 Explicit Block Mapping Entries
例 8.17 显式块映射条目**

| `? explicit key # Empty value↓° ? |  block key↓ :·- one # Explicit compact ··- two # block value↓ ` | `{ "explicit key": null,  "block key\n": [    "one",    "two" ] } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `c-l-block-map-explicit-key(n)`
  `c-l-块映射显式密钥 （n）`
- `l-block-map-explicit-value(n)`
  `l-block-map-explicit-value（n） 块映射显式值 （n）`
- `e-node` `E-node 节点`

If the “`?`” indicator is omitted, [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) needs to see past the [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry), in the same way as in the [single key/value pair](https://yaml.org/spec/1.2.2/#mapping) [flow mapping](https://yaml.org/spec/1.2.2/#flow-mappings). Hence, such [keys](https://yaml.org/spec/1.2.2/#nodes) are subject to the same restrictions; they are limited to a single line and must not span more than 1024 Unicode characters.
如果省略了 “`？”` 指示符，[则解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)需要查看 [隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)，与[单个键/值对](https://yaml.org/spec/1.2.2/#mapping)[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)中的方式相同。因此，此类[密钥](https://yaml.org/spec/1.2.2/#nodes)受相同的限制;它们仅限于一行，并且不得超过 1024 个 Unicode 字符。

```
[192] ns-l-block-map-implicit-entry(n) ::=
  (
      ns-s-block-map-implicit-key
    | e-node    # ""
  )
  c-l-block-map-implicit-value(n)
[193] ns-s-block-map-implicit-key ::=
    c-s-implicit-json-key(BLOCK-KEY)
  | ns-s-implicit-yaml-key(BLOCK-KEY)
```

In this case, the [value](https://yaml.org/spec/1.2.2/#nodes) may be specified on the same line as the [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry). Note however that in block mappings the [value](https://yaml.org/spec/1.2.2/#nodes) must never be adjacent to the “`:`”, as this greatly reduces readability and is not required for [JSON compatibility](https://yaml.org/spec/1.2.2/#yaml-directives) (unlike the case in [flow mappings](https://yaml.org/spec/1.2.2/#flow-mappings)).
在这种情况下，可以在与[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)相同的行上指定[该值](https://yaml.org/spec/1.2.2/#nodes)。但请注意，在数据块映射中，[该值](https://yaml.org/spec/1.2.2/#nodes)不得与 “`：`” 相邻，因为这会大大降低可读性，并且不是 [JSON 兼容性](https://yaml.org/spec/1.2.2/#yaml-directives)所必需的（与[流映射](https://yaml.org/spec/1.2.2/#flow-mappings)中的情况不同）。

There is no compact notation for in-line [values](https://yaml.org/spec/1.2.2/#nodes). Also, while both the [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) and the [value](https://yaml.org/spec/1.2.2/#nodes) following it may be empty, the “`:`” indicator is mandatory. This prevents a potential ambiguity with multi-line [plain scalars](https://yaml.org/spec/1.2.2/#plain-style).
内联[值](https://yaml.org/spec/1.2.2/#nodes)没有紧凑的表示法。此外，虽然[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)及其后面[的值](https://yaml.org/spec/1.2.2/#nodes)都可能为空，但 “`：`” 指示符是必需的。这可以防止多行[纯标量](https://yaml.org/spec/1.2.2/#plain-style)产生潜在的歧义。

```
[194] c-l-block-map-implicit-value(n) ::=
  c-mapping-value           # ':' (not followed by non-ws char)
  (
      s-l+block-node(n,BLOCK-OUT)
    | (
        e-node    # ""
        s-l-comments
      )
  )
```

**Example 8.18 Implicit Block Mapping Entries
例 8.18 隐式块映射条目**

| `plain key: in-line value °:° # Both empty "quoted key": - entry ` | `{ "plain key": "in-line value",  null: null,  "quoted key": [ "entry" ] } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `ns-s-block-map-implicit-key`
  `ns-s-块映射隐式密钥`
- `c-l-block-map-implicit-value(n)`

A [compact in-line notation](https://yaml.org/spec/1.2.2/#example-block-sequence) is also available. This compact notation may be nested inside [block sequences](https://yaml.org/spec/1.2.2/#block-sequences) and explicit block mapping entries. Note that it is not possible to specify [node properties](https://yaml.org/spec/1.2.2/#node-properties) for such a nested mapping.
还提供[紧凑的内联符号](https://yaml.org/spec/1.2.2/#example-block-sequence)。这种紧凑的表示法可以嵌套在 [block sequence](https://yaml.org/spec/1.2.2/#block-sequences) 和显式 block mapping 条目中。请注意，无法为此类嵌套映射指定[节点属性](https://yaml.org/spec/1.2.2/#node-properties)。

```
[195] ns-l-compact-mapping(n) ::=
  ns-l-block-map-entry(n)
  (
    s-indent(n)
    ns-l-block-map-entry(n)
  )*
```

**Example 8.19 Compact Block Mappings
例 8.19 压缩块映射**

| `- sun: yellow↓ - ? earth: blue↓  : moon: white↓ ` | `[ { "sun": "yellow" },  { { "earth": "blue" }:      { "moon": "white" } } ] ` |
| -------------------------------------------------- | ------------------------------------------------------------ |
|                                                    |                                                              |

**Legend: 传说：**

- `ns-l-compact-mapping(n)`
  `ns-l-压缩映射 （n）`

### 8.2.3. Block Nodes 8.2.3. 块节点

YAML allows [flow nodes](https://yaml.org/spec/1.2.2/#flow-nodes) to be embedded inside [block collections](https://yaml.org/spec/1.2.2/#block-collection-styles) (but not vice-versa). [Flow nodes](https://yaml.org/spec/1.2.2/#flow-nodes) must be [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) by at least one more [space](https://yaml.org/spec/1.2.2/#white-space-characters) than the parent [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles). Note that [flow nodes](https://yaml.org/spec/1.2.2/#flow-nodes) may begin on a following line.
YAML 允许将[流节点](https://yaml.org/spec/1.2.2/#flow-nodes)嵌入到[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)中（但不允许 反之亦然）。 [流节点](https://yaml.org/spec/1.2.2/#flow-nodes)的[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)必须至少比父节点多一个[空格](https://yaml.org/spec/1.2.2/#white-space-characters) [block 集合](https://yaml.org/spec/1.2.2/#block-collection-styles)。请注意，[流节点](https://yaml.org/spec/1.2.2/#flow-nodes)可能从以下行开始。

It is at this point that [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) needs to distinguish between a [plain scalar](https://yaml.org/spec/1.2.2/#plain-style) and an [implicit key](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry) starting a nested [block mapping](https://yaml.org/spec/1.2.2/#block-mappings).
正是在这一点上，[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream)需要区分[普通标量](https://yaml.org/spec/1.2.2/#plain-style)和启动嵌套[块映射](https://yaml.org/spec/1.2.2/#block-mappings)的[隐式键](https://yaml.org/spec/1.2.2/#example-single-pair-explicit-entry)。

```
[196] s-l+block-node(n,c) ::=
    s-l+block-in-block(n,c)
  | s-l+flow-in-block(n)
[197] s-l+flow-in-block(n) ::=
  s-separate(n+1,FLOW-OUT)
  ns-flow-node(n+1,FLOW-OUT)
  s-l-comments
```

**Example 8.20 Block Node Types
示例 8.20 块节点类型**

| `-↓ ··"flow in block"↓ -·> Block scalar↓ -·!!map # Block collection  foo : bar↓ ` | `[ "flow in block",  "Block scalar\n",  { "foo": "bar" } ] ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-l+flow-in-block(n)`
  `S-L+流入区 （N）`
- `s-l+block-in-block(n,c)`
  `S-L+块中块 （n，c）`

The block [node’s properties](https://yaml.org/spec/1.2.2/#node-properties) may span across several lines. In this case, they must be [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) by at least one more [space](https://yaml.org/spec/1.2.2/#white-space-characters) than the [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles), regardless of the [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces) of the [block collection](https://yaml.org/spec/1.2.2/#block-collection-styles) entries.
块[节点的属性](https://yaml.org/spec/1.2.2/#node-properties)可以跨越多行。在这种情况下，它们必须比  [块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)，无论[块集合](https://yaml.org/spec/1.2.2/#block-collection-styles)的[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)如何 条目。

```
[198] s-l+block-in-block(n,c) ::=
    s-l+block-scalar(n,c)
  | s-l+block-collection(n,c)
[199] s-l+block-scalar(n,c) ::=
  s-separate(n+1,c)
  (
    c-ns-properties(n+1,c)
    s-separate(n+1,c)
  )?
  (
      c-l+literal(n)
    | c-l+folded(n)
  )
```

**Example 8.21 Block Scalar Nodes
例 8.21 块标量节点**

| `literal: |2 ··value folded:↓ ···!foo ··>1 ·value ` | `{ "literal": "value",  "folded": !<!foo> "value" } ` |
| --------------------------------------------------- | ----------------------------------------------------- |
|                                                     |                                                       |

**Legend: 传说：**

- `c-l+literal(n)`
  `c-l+文字 （n）`
- `c-l+folded(n)`
  `C-L+折叠 （N）`

Since people perceive the “`-`” indicator as [indentation](https://yaml.org/spec/1.2.2/#indentation-spaces), nested [block sequences](https://yaml.org/spec/1.2.2/#block-sequences) may be [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) by one less [space](https://yaml.org/spec/1.2.2/#white-space-characters) to compensate, except, of course, if nested inside another [block sequence](https://yaml.org/spec/1.2.2/#block-sequences) ([`BLOCK-OUT` context] versus [`BLOCK-IN` context]).
由于人们将 “`-`” 指示符视为[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)，因此嵌套[的块序列](https://yaml.org/spec/1.2.2/#block-sequences)可以缩[进](https://yaml.org/spec/1.2.2/#indentation-spaces)一个[空格](https://yaml.org/spec/1.2.2/#white-space-characters)以进行补偿，当然，除非嵌套在另一个[块序列](https://yaml.org/spec/1.2.2/#block-sequences)中（[`BLOCK-OUT` 上下文] 与 [`BLOCK-IN` 上下文]）。

```
[200] s-l+block-collection(n,c) ::=
  (
    s-separate(n+1,c)
    c-ns-properties(n+1,c)
  )?
  s-l-comments
  (
      seq-space(n,c)
    | l+block-mapping(n)
  )
[201] seq-space(n,BLOCK-OUT) ::= l+block-sequence(n-1)
    seq-space(n,BLOCK-IN)  ::= l+block-sequence(n)
```

**Example 8.22 Block Collection Nodes
示例 8.22 块收集节点**

| `sequence: !!seq - entry - !!seq - nested mapping: !!map foo: bar ` | `{ "sequence": [    "entry",    [ "nested" ] ],  "mapping": { "foo": "bar" } } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

**Legend: 传说：**

- `s-l+block-collection(n,c)`
  `S-L+块集合 （n，c）`
- `l+block-sequence(n)`
  `l+块序列 （n）`
- `l+block-mapping(n)`
  `l+块映射 （n）`

# Chapter 9. Document Stream Productions 第 9 章.文档流制作

## 9.1. Documents 9.1. 文档

A YAML character [stream](https://yaml.org/spec/1.2.2/#streams) may contain several *documents*. Each document is completely independent from the rest.
一个 YAML 字符[流](https://yaml.org/spec/1.2.2/#streams)可能包含多个*文档*。每个文档都完全独立于其他文档。

### 9.1.1. Document Prefix 9.1.1. 文档前缀

A document may be preceded by a *prefix* specifying the [character encoding](https://yaml.org/spec/1.2.2/#character-encodings) and optional [comment](https://yaml.org/spec/1.2.2/#comments) lines. Note that all [documents](https://yaml.org/spec/1.2.2/#documents) in a stream must use the same [character encoding](https://yaml.org/spec/1.2.2/#character-encodings). However it is valid to re-specify the [encoding](https://yaml.org/spec/1.2.2/#character-encodings) using a [byte order mark](https://yaml.org/spec/1.2.2/#character-encodings) for each [document](https://yaml.org/spec/1.2.2/#documents) in the stream.
文档前面可以有一个指定[字符编码](https://yaml.org/spec/1.2.2/#character-encodings)的*前缀* 和可选的[注释](https://yaml.org/spec/1.2.2/#comments)行。请注意，流中的所有[文档](https://yaml.org/spec/1.2.2/#documents)都必须使用相同的[字符编码](https://yaml.org/spec/1.2.2/#character-encodings)。但是，使用[字节顺序标记](https://yaml.org/spec/1.2.2/#character-encodings)为流中的每个[文档](https://yaml.org/spec/1.2.2/#documents)重新指定[编码](https://yaml.org/spec/1.2.2/#character-encodings)是有效的。

The existence of the optional prefix does not necessarily indicate the existence of an actual [document](https://yaml.org/spec/1.2.2/#documents).
可选前缀的存在并不一定表示存在实际[文档](https://yaml.org/spec/1.2.2/#documents)。

```
[202] l-document-prefix ::=
  c-byte-order-mark?
  l-comment*
```

**Example 9.1 Document Prefix
例 9.1 文档前缀**

| `⇔# Comment # lines Document ` | `"Document" ` |
| ------------------------------ | ------------- |
|                                |               |

**Legend: 传说：**

- `l-document-prefix`
  `l 文档前缀`

### 9.1.2. Document Markers 9.1.2. 文档标记

Using [directives](https://yaml.org/spec/1.2.2/#directives) creates a potential ambiguity. It is valid to have a “`%`” character at the start of a line (e.g. as the first character of the second line of a [plain scalar](https://yaml.org/spec/1.2.2/#plain-style)). How, then, to distinguish between an actual [directive](https://yaml.org/spec/1.2.2/#directives) and a [content](https://yaml.org/spec/1.2.2/#nodes) line that happens to start with a “`%`” character?
Using [指令](https://yaml.org/spec/1.2.2/#directives)会产生潜在的歧义。在行的开头有 “`%`” 字符是有效的（例如，作为[纯标量](https://yaml.org/spec/1.2.2/#plain-style)第二行的第一个字符）。那么，如何区分实际[的指令](https://yaml.org/spec/1.2.2/#directives)和恰好以 “`%`” 字符开头[的内容](https://yaml.org/spec/1.2.2/#nodes)行呢？

The solution is the use of two special *marker* lines to control the processing of [directives](https://yaml.org/spec/1.2.2/#directives), one at the start of a [document](https://yaml.org/spec/1.2.2/#documents) and one at the end.
解决方案是使用两条特殊的*标记*线来控制[指令](https://yaml.org/spec/1.2.2/#directives)的处理，一条在文档的开头，一条在[结尾](https://yaml.org/spec/1.2.2/#documents)。

At the start of a [document](https://yaml.org/spec/1.2.2/#documents), lines beginning with a “`%`” character are assumed to be [directives](https://yaml.org/spec/1.2.2/#directives). The (possibly empty) list of [directives](https://yaml.org/spec/1.2.2/#directives) is terminated by a *directives end marker* line. Lines following this marker can safely use “`%`” as the first character.
在[文档](https://yaml.org/spec/1.2.2/#documents)的开头，以 “`%`” 字符开头的行被假定为[指令](https://yaml.org/spec/1.2.2/#directives)。[指令](https://yaml.org/spec/1.2.2/#directives)列表（可能为空）以 *directives 结束标记*线终止。此标记后面的行可以安全地使用 “`%`” 作为第一个字符。

At the end of a [document](https://yaml.org/spec/1.2.2/#documents), a *document end marker* line is used to signal the [parser](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) to begin scanning for [directives](https://yaml.org/spec/1.2.2/#directives) again.
在[文档](https://yaml.org/spec/1.2.2/#documents)的末尾，*文档结束标记*线用于表示 [parser](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) 再次开始扫描[指令](https://yaml.org/spec/1.2.2/#directives)。

The existence of this optional *document suffix* does not necessarily indicate the existence of an actual following [document](https://yaml.org/spec/1.2.2/#documents).
此可选*文档后缀*的存在并不一定表示存在实际的后续[文档](https://yaml.org/spec/1.2.2/#documents)。

Obviously, the actual [content](https://yaml.org/spec/1.2.2/#nodes) lines are therefore forbidden to begin with either of these markers.
显然，因此禁止实际[内容](https://yaml.org/spec/1.2.2/#nodes)行以这些标记中的任何一个开头。

```
[203] c-directives-end ::= "---"
[204] c-document-end ::=
  "..."    # (not followed by non-ws char)
[205] l-document-suffix ::=
  c-document-end
  s-l-comments
[206] c-forbidden ::=
  <start-of-line>
  (
      c-directives-end
    | c-document-end
  )
  (
      b-char
    | s-white
    | <end-of-input>
  )
```

**Example 9.2 Document Markers
例 9.2 文档标记**

| `%YAML 1.2 --- Document ... # Suffix ` | `"Document" ` |
| -------------------------------------- | ------------- |
|                                        |               |

**Legend: 传说：**

- `c-directives-end`
  `c 指令结束`
- `l-document-suffix`
  `左文档后缀`
- `c-document-end`
  `c-文档结束`

### 9.1.3. Bare Documents 9.1.3. 裸文档

A *bare document* does not begin with any [directives](https://yaml.org/spec/1.2.2/#directives) or [marker](https://yaml.org/spec/1.2.2/#document-markers) lines. Such documents are very “clean” as they contain nothing other than the [content](https://yaml.org/spec/1.2.2/#nodes). In this case, the first non-comment line may not start with a “`%`” first character.
*裸文档*不以任何[指令](https://yaml.org/spec/1.2.2/#directives)或[标记](https://yaml.org/spec/1.2.2/#document-markers)行开头。 此类文档非常“干净”，因为它们只包含 [内容](https://yaml.org/spec/1.2.2/#nodes)。在这种情况下，第一个非注释行不能以 “`%`” 第一个字符开头。

Document [nodes](https://yaml.org/spec/1.2.2/#nodes) are [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) as if they have a parent [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) at -1 [spaces](https://yaml.org/spec/1.2.2/#white-space-characters). Since a [node](https://yaml.org/spec/1.2.2/#nodes) must be more [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) than its parent [node](https://yaml.org/spec/1.2.2/#nodes), this allows the document’s [node](https://yaml.org/spec/1.2.2/#nodes) to be [indented](https://yaml.org/spec/1.2.2/#indentation-spaces) at zero or more [spaces](https://yaml.org/spec/1.2.2/#white-space-characters).
文档[节点](https://yaml.org/spec/1.2.2/#nodes)[缩进，](https://yaml.org/spec/1.2.2/#indentation-spaces)就好像它们的父节点[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)为 -1 一样 [空格](https://yaml.org/spec/1.2.2/#white-space-characters)。由于[节点](https://yaml.org/spec/1.2.2/#nodes)的[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)量必须比其父[节点](https://yaml.org/spec/1.2.2/#nodes)大，因此允许文档的[节点](https://yaml.org/spec/1.2.2/#nodes)[缩进](https://yaml.org/spec/1.2.2/#indentation-spaces)零个[或多个空格](https://yaml.org/spec/1.2.2/#white-space-characters)。

```
[207] l-bare-document ::=
  s-l+block-node(-1,BLOCK-IN)
  /* Excluding c-forbidden content */
```

**Example 9.3 Bare Documents
例 9.3 裸文档**

| `Bare document ... # No document ... | %!PS-Adobe-2.0 # Not the first line ` | `"Bare document" --- "%!PS-Adobe-2.0\n" ` |
| ------------------------------------------------------------ | ----------------------------------------- |
|                                                              |                                           |

**Legend: 传说：**

- `l-bare-document`
  `L-裸文档`

### 9.1.4. Explicit Documents 9.1.4. 显式文档

An *explicit document* begins with an explicit [directives end marker](https://yaml.org/spec/1.2.2/#document-markers) line but no [directives](https://yaml.org/spec/1.2.2/#directives). Since the existence of the [document](https://yaml.org/spec/1.2.2/#documents) is indicated by this [marker](https://yaml.org/spec/1.2.2/#document-markers), the [document](https://yaml.org/spec/1.2.2/#documents) itself may be [completely empty](https://yaml.org/spec/1.2.2/#example-empty-content).
*显式文档*以显式[指令结束标记](https://yaml.org/spec/1.2.2/#document-markers)行开头，但没有[指令](https://yaml.org/spec/1.2.2/#directives)。由于此[标记](https://yaml.org/spec/1.2.2/#document-markers)指示[文档](https://yaml.org/spec/1.2.2/#documents)的存在，因此 [文档](https://yaml.org/spec/1.2.2/#documents)本身可能[完全为空](https://yaml.org/spec/1.2.2/#example-empty-content)。

```
[208] l-explicit-document ::=
  c-directives-end
  (
      l-bare-document
    | (
        e-node    # ""
        s-l-comments
      )
  )
```

**Example 9.4 Explicit Documents
例 9.4 显式文档**

| `--- { matches % : 20 } ... --- # Empty ... ` | `{ "matches %": 20 } --- null ` |
| --------------------------------------------- | ------------------------------- |
|                                               |                                 |

**Legend: 传说：**

- `l-explicit-document`
  `L-显式文档`

### 9.1.5. Directives Documents 9.1.5. 指令文档

A *directives document* begins with some [directives](https://yaml.org/spec/1.2.2/#directives) followed by an explicit [directives end marker](https://yaml.org/spec/1.2.2/#document-markers) line.
*directives 文档*以一些 directive 开头，后跟一个显式[的](https://yaml.org/spec/1.2.2/#directives) [指令结束标记](https://yaml.org/spec/1.2.2/#document-markers)行。

```
[209] l-directive-document ::=
  l-directive+
  l-explicit-document
```

**Example 9.5 Directives Documents
例 9.5 指令文档**

| `%YAML 1.2 --- | %!PS-Adobe-2.0 ... %YAML 1.2 --- # Empty ... ` | `"%!PS-Adobe-2.0\n" --- null ` |
| ------------------------------------------------------------ | ------------------------------ |
|                                                              |                                |

**Legend: 传说：**

- `l-explicit-document`
  `L-显式文档`

## 9.2. Streams 9.2. 流

A YAML *stream* consists of zero or more [documents](https://yaml.org/spec/1.2.2/#documents). Subsequent [documents](https://yaml.org/spec/1.2.2/#documents) require some sort of separation [marker](https://yaml.org/spec/1.2.2/#document-markers) line. If a [document](https://yaml.org/spec/1.2.2/#documents) is not terminated by a [document end marker](https://yaml.org/spec/1.2.2/#document-markers) line, then the following [document](https://yaml.org/spec/1.2.2/#documents) must begin with a [directives end marker](https://yaml.org/spec/1.2.2/#document-markers) line.
YAML *流*由零个或多个[文档](https://yaml.org/spec/1.2.2/#documents)组成。后续[文件](https://yaml.org/spec/1.2.2/#documents)需要某种分隔[标记](https://yaml.org/spec/1.2.2/#document-markers)线。如果[文档](https://yaml.org/spec/1.2.2/#documents)未以[文档结束标记](https://yaml.org/spec/1.2.2/#document-markers)线终止，则以下[文档](https://yaml.org/spec/1.2.2/#documents)必须以 [directives 结束标记](https://yaml.org/spec/1.2.2/#document-markers)行开头。

```
[210] l-any-document ::=
    l-directive-document
  | l-explicit-document
  | l-bare-document
[211] l-yaml-stream ::=
  l-document-prefix*
  l-any-document?
  (
      (
        l-document-suffix+
        l-document-prefix*
        l-any-document?
      )
    | c-byte-order-mark
    | l-comment
    | l-explicit-document
  )*
```

**Example 9.6 Stream 例 9.6 流**

| `Document --- # Empty ... %YAML 1.2 --- matches %: 20 ` | `"Document" --- null --- { "matches %": 20 } ` |
| ------------------------------------------------------- | ---------------------------------------------- |
|                                                         |                                                |

**Legend: 传说：**

- `l-any-document`
  `l-任何文档`
- `l-document-suffix`
  `左文档后缀`
- `l-explicit-document`
  `L-显式文档`

A sequence of bytes is a *well-formed stream* if, taken as a whole, it complies with the above `l-yaml-stream` production.
如果一个字节序列作为一个整体，它符合上述 `l-yaml-stream` 生产，则它是一个*格式正确的流*。

# Chapter 10. Recommended Schemas 第 10 章.建议的架构

A YAML *schema* is a combination of a set of [tags](https://yaml.org/spec/1.2.2/#tags) and a mechanism for [resolving](https://yaml.org/spec/1.2.2/#resolved-tags) [non-specific tags](https://yaml.org/spec/1.2.2/#resolved-tags).
YAML *架构*是一组[标记](https://yaml.org/spec/1.2.2/#tags)和一种机制的组合 [解析](https://yaml.org/spec/1.2.2/#resolved-tags)[非特定标记](https://yaml.org/spec/1.2.2/#resolved-tags)。

## 10.1. Failsafe Schema 10.1. 故障安全模式

The *failsafe schema* is guaranteed to work with any YAML [document](https://yaml.org/spec/1.2.2/#documents). It is therefore the recommended [schema](https://yaml.org/spec/1.2.2/#recommended-schemas) for generic YAML tools. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should therefore support this [schema](https://yaml.org/spec/1.2.2/#recommended-schemas), at least as an option.
保证*故障安全架构*适用于任何 YAML [文档](https://yaml.org/spec/1.2.2/#documents)。因此，它是通用 YAML 工具的推荐[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)。因此，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应该支持此[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)，至少作为一个选项。

### 10.1.1. Tags 10.1.1. 标签

#### 10.1.1.1. Generic Mapping 10.1.1.1. 泛型映射

- URI

  ​    `tag:yaml.org,2002:map` `标签：yaml.org，2002：地图`  

- Kind 类

  ​    [Mapping](https://yaml.org/spec/1.2.2/#mapping). [映射](https://yaml.org/spec/1.2.2/#mapping)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) an associative container, where each [key](https://yaml.org/spec/1.2.2/#nodes) is unique in the association and mapped to exactly one [value](https://yaml.org/spec/1.2.2/#nodes). YAML places no restrictions on the type of [keys](https://yaml.org/spec/1.2.2/#nodes); in particular, they are not restricted to being [scalars](https://yaml.org/spec/1.2.2/#scalars). Example [bindings](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) to [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) types include Perl’s hash, Python’s dictionary and Java’s Hashtable. [表示](https://yaml.org/spec/1.2.2/#representation-graph)一个关联容器，其中每个[键](https://yaml.org/spec/1.2.2/#nodes)在关联中都是唯一的，并且只映射到一个[值](https://yaml.org/spec/1.2.2/#nodes)。YAML 对[键](https://yaml.org/spec/1.2.2/#nodes)的类型没有限制;特别是，它们不限于作为[标量](https://yaml.org/spec/1.2.2/#scalars)。与[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)类型的[示例绑定](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)包括 Perl 的哈希、Python 的字典和 Java 的 Hashtable。  

**Example 10.1 `!!map` Examples
例 10.1 `！！map` 示例**

```
Block style: !!map
  Clark : Evans
  Ingy  : döt Net
  Oren  : Ben-Kiki

Flow style: !!map { Clark: Evans, Ingy: döt Net, Oren: Ben-Kiki }
```

#### 10.1.1.2. Generic Sequence 10.1.1.2. 泛型序列

- URI

  ​    `tag:yaml.org,2002:seq` `标签：yaml.org，2002：seq`  

- Kind 类

  ​    [Sequence](https://yaml.org/spec/1.2.2/#sequence). [序列](https://yaml.org/spec/1.2.2/#sequence)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) a collection indexed by sequential integers starting with zero. Example [bindings](https://yaml.org/spec/1.2.2/#constructing-native-data-structures) to [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) types include Perl’s array, Python’s list or tuple and Java’s array or Vector. [表示](https://yaml.org/spec/1.2.2/#representation-graph)由从零开始的连续整数编制索引的集合。与[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)类型的[示例绑定](https://yaml.org/spec/1.2.2/#constructing-native-data-structures)包括 Perl 的数组、Python 的列表或元组以及 Java 的数组或 Vector。  

**Example 10.2 `!!seq` Examples
例 10.2 `！！Seq` 示例**

```
Block style: !!seq
- Clark Evans
- Ingy döt Net
- Oren Ben-Kiki

Flow style: !!seq [ Clark Evans, Ingy döt Net, Oren Ben-Kiki ]
```

#### 10.1.1.3. Generic String 10.1.1.3. 泛型字符串

- URI

  ​    `tag:yaml.org,2002:str` `标签：yaml.org，2002：str`  

- Kind 类

  ​    [Scalar](https://yaml.org/spec/1.2.2/#scalar). [标量](https://yaml.org/spec/1.2.2/#scalar)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) a Unicode string, a sequence of zero or more Unicode characters. This type is usually [bound](https://yaml.org/spec/1.2.2/#representing-native-data-structures) to the [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) language’s string type or, for languages lacking one (such as C), to a character array. [表示](https://yaml.org/spec/1.2.2/#representation-graph) Unicode 字符串，即零个或多个 Unicode 字符的序列。此类型通常[绑定到](https://yaml.org/spec/1.2.2/#representing-native-data-structures)[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)语言的字符串类型，或者对于缺少字符串类型的语言（例如 C），绑定到字符数组。  

- Canonical Form: 规范形式：

  ​    The obvious. 显而易见的。  

**Example 10.3 `!!str` Examples
例 10.3 `！！str` 示例**

```
Block style: !!str |-
  String: just a theory.

Flow style: !!str "String: just a theory."
```

### 10.1.2. Tag Resolution 10.1.2. 标签解析

All [nodes](https://yaml.org/spec/1.2.2/#nodes) with the “`!`” non-specific tag are [resolved](https://yaml.org/spec/1.2.2/#resolved-tags), by the standard [convention](https://yaml.org/spec/1.2.2/#resolved-tags), to “`tag:yaml.org,2002:seq`”, “`tag:yaml.org,2002:map`” or “`tag:yaml.org,2002:str`”, according to their [kind](https://yaml.org/spec/1.2.2/#nodes).
所有带有 “`！`” 非特定标记的[节点](https://yaml.org/spec/1.2.2/#nodes)[都由](https://yaml.org/spec/1.2.2/#resolved-tags)标准 [约定](https://yaml.org/spec/1.2.2/#resolved-tags)，根据其[类型](https://yaml.org/spec/1.2.2/#nodes)更改为“`tag：yaml.org，2002：seq`”、“`tag：yaml.org，2002：map`”或“`tag：yaml.org，2002：str`”。

All [nodes](https://yaml.org/spec/1.2.2/#nodes) with the “`?`” non-specific tag are left [unresolved](https://yaml.org/spec/1.2.2/#resolved-tags). This constrains the [application](https://yaml.org/spec/1.2.2/#processes-and-models) to deal with a [partial representation](https://yaml.org/spec/1.2.2/#loading-failure-points).
所有带有 “`？”` 非特定标签的[节点](https://yaml.org/spec/1.2.2/#nodes)都[未解析](https://yaml.org/spec/1.2.2/#resolved-tags)。这会限制[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)处理[部分表示](https://yaml.org/spec/1.2.2/#loading-failure-points)。

## 10.2. JSON Schema 10.2. JSON 架构

The *JSON schema* is the lowest common denominator of most modern computer languages and allows [parsing](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) JSON files. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should therefore support this [schema](https://yaml.org/spec/1.2.2/#recommended-schemas), at least as an option. It is also strongly recommended that other [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) should be based on it.
*JSON 架构*是大多数现代计算机语言的最低公分母，允许[解析](https://yaml.org/spec/1.2.2/#parsing-the-presentation-stream) JSON 文件。因此，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应该支持此[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)，至少作为一个选项。此外，强烈建议其他[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)应基于它。

### 10.2.1. Tags 10.2.1. 标签

The JSON [schema](https://yaml.org/spec/1.2.2/#recommended-schemas) uses the following [tags](https://yaml.org/spec/1.2.2/#tags) in addition to those defined by the [failsafe](https://yaml.org/spec/1.2.2/#failsafe-schema) schema:
JSON [架构](https://yaml.org/spec/1.2.2/#recommended-schemas)除了使用 [failsafe](https://yaml.org/spec/1.2.2/#failsafe-schema) 架构：

#### 10.2.1.1. Null 10.2.1.1. 空

- URI

  ​    `tag:yaml.org,2002:null` `标签：yaml.org，2002：null`  

- Kind 类

  ​    [Scalar](https://yaml.org/spec/1.2.2/#scalar). [标量](https://yaml.org/spec/1.2.2/#scalar)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) the lack of a value. This is typically [bound](https://yaml.org/spec/1.2.2/#representing-native-data-structures) to a [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) null-like value (e.g., `undef` in Perl, `None` in Python). Note that a null is different from an empty string. Also, a [mapping](https://yaml.org/spec/1.2.2/#mapping) entry with some [key](https://yaml.org/spec/1.2.2/#nodes) and a null [value](https://yaml.org/spec/1.2.2/#nodes) is valid and different from not having that [key](https://yaml.org/spec/1.2.2/#nodes) in the [mapping](https://yaml.org/spec/1.2.2/#mapping). [表示](https://yaml.org/spec/1.2.2/#representation-graph)缺少值。这通常[绑定到](https://yaml.org/spec/1.2.2/#representing-native-data-structures)[一个原生](https://yaml.org/spec/1.2.2/#representing-native-data-structures)的类似 null 的值（例如，Perl 中的 `undef`， `在` Python 中没有）。请注意，null 与空字符串不同。此外，具有某个[键](https://yaml.org/spec/1.2.2/#nodes)和 null [值的](https://yaml.org/spec/1.2.2/#nodes)[映射](https://yaml.org/spec/1.2.2/#mapping)条目是有效的，与[映射](https://yaml.org/spec/1.2.2/#mapping)中没有该[键](https://yaml.org/spec/1.2.2/#nodes)不同。  

- Canonical Form 规范形式

  ​    `null`. `null` 的  

**Example 10.4 `!!null` Examples
例 10.4 `！！null` 示例**

```
!!null null: value for null key
key with null value: !!null null
```

#### 10.2.1.2. Boolean 10.2.1.2. 布尔值

- URI

  ​    `tag:yaml.org,2002:bool` `标签：yaml.org，2002：bool`  

- Kind 类

  ​    [Scalar](https://yaml.org/spec/1.2.2/#scalar). [标量](https://yaml.org/spec/1.2.2/#scalar)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) a true/false value. In languages without a [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) Boolean type (such as C), they are usually [bound](https://yaml.org/spec/1.2.2/#representing-native-data-structures) to a native integer type, using one for true and zero for false. [表示](https://yaml.org/spec/1.2.2/#representation-graph) true/false 值。在没有[原生](https://yaml.org/spec/1.2.2/#representing-native-data-structures)布尔类型的语言（如 C）中，它们通常是 [绑定到](https://yaml.org/spec/1.2.2/#representing-native-data-structures)本机整数类型，使用 1 表示 true，使用 0 表示 false。  

- Canonical Form 规范形式

  ​    Either `true` or `false`. `true` 或 `false`。  

**Example 10.5 `!!bool` Examples
例 10.5 `！！bool` 示例**

```
YAML is a superset of JSON: !!bool true
Pluto is a planet: !!bool false
```

#### 10.2.1.3. Integer 10.2.1.3. 整数

- URI

  ​    `tag:yaml.org,2002:int` `标签：yaml.org，2002：int`  

- Kind 类

  ​    [Scalar](https://yaml.org/spec/1.2.2/#scalar). [标量](https://yaml.org/spec/1.2.2/#scalar)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) arbitrary sized finite mathematical integers. Scalars of this type should be [bound](https://yaml.org/spec/1.2.2/#representing-native-data-structures) to a [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) integer data type, if possible. [表示](https://yaml.org/spec/1.2.2/#representation-graph)任意大小的有限数学整数。如果可能，这种类型的标量应[绑定到](https://yaml.org/spec/1.2.2/#representing-native-data-structures)[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)整数数据类型。  

  ​    Some languages (such as Perl) provide only a “number” type that allows for both integer and floating-point values. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may use such a type for integers as long as they round-trip properly. 某些语言（例如 Perl）仅提供允许整数和浮点值的 “number” 类型。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以对整数使用这种类型，只要它们正确往返即可。  

  ​    In some languages (such as C), an integer may overflow the [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) type’s storage capability. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may reject such a value as an error, truncate it with a warning or find some other manner to round-trip it. In general, integers representable using 32 binary digits should safely round-trip through most systems. 在某些语言（比如 C）中，整数可能会溢出[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)类型的存储能力。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可能会拒绝此类值作为错误，用警告截断它或找到其他方式来往返它。通常，可使用 32 个二进制数字表示的整数应该安全地在大多数系统中往返。  

- Canonical Form 规范形式

  ​    Decimal integer notation, with a leading “`-`” character for negative values, matching the regular expression `0 | -? [1-9] [0-9]*` 十进制整数表示法，负值用前导“`-`”字符表示，与正则表达式 `0 | -？[1-9] [0-9]*`  

**Example 10.6 `!!int` Examples
例 10.6 `！！int` 示例**

```
negative: !!int -12
zero: !!int 0
positive: !!int 34
```

#### 10.2.1.4. Floating Point 10.2.1.4. 浮点数

- URI

  ​    `tag:yaml.org,2002:float` `标签：yaml.org，2002：float`  

- Kind 类

  ​    [Scalar](https://yaml.org/spec/1.2.2/#scalar). [标量](https://yaml.org/spec/1.2.2/#scalar)。  

- Definition 定义

  ​    [Represents](https://yaml.org/spec/1.2.2/#representation-graph) an approximation to real numbers, including three special values (positive and negative infinity and “not a number”). [表示](https://yaml.org/spec/1.2.2/#representation-graph)实数的近似值，包括三个特殊值（正无穷大和负无穷大以及“非数字”）。  

  ​    Some languages (such as Perl) provide only a “number” type that allows for both integer and floating-point values. A YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) may use such a type for floating-point numbers, as long as they round-trip properly. 某些语言（例如 Perl）仅提供允许整数和浮点值的 “number” 类型。YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)可以将此类类型用于浮点数，只要它们正确往返即可。  

  ​    Not all floating-point values can be stored exactly in any given [native](https://yaml.org/spec/1.2.2/#representing-native-data-structures) type. Hence a float value may change by “a small amount” when round-tripped. The supported range and accuracy depends on the implementation, though 32 bit IEEE floats should be safe. Since YAML does not specify a particular accuracy, using floating-point [mapping keys](https://yaml.org/spec/1.2.2/#nodes) requires great care and is not recommended. 并非所有浮点值都可以完全存储在任何给定的[本机](https://yaml.org/spec/1.2.2/#representing-native-data-structures)类型中。 因此，浮点值在往返时可能会发生“少量”变化。 支持的范围和精度取决于实现，但 32 位 IEEE 浮点数应该是安全的。 由于 YAML 没有指定特定的精度，因此使用浮点 [映射键](https://yaml.org/spec/1.2.2/#nodes)需要非常小心，因此不建议这样做。  

- Canonical Form 规范形式

  ​    Either `0`, `.inf`, `-.inf`, `.nan` or scientific notation matching the regular expression `0`、`.inf`、`-.inf`、`.nan` 或与正则表达式匹配的科学记数法  `-? [1-9] ( \. [0-9]* [1-9] )? ( e [-+] [1-9] [0-9]* )?`.  

**Example 10.7 `!!float` Examples
例 10.7 `！！float` 示例**

```
negative: !!float -1
zero: !!float 0
positive: !!float 2.3e4
infinity: !!float .inf
not a number: !!float .nan
```

### 10.2.2. Tag Resolution 10.2.2. 标签解析

The [JSON schema](https://yaml.org/spec/1.2.2/#json-schema) [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution) is an extension of the [failsafe schema](https://yaml.org/spec/1.2.2/#failsafe-schema) [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution).
[JSON 架构](https://yaml.org/spec/1.2.2/#json-schema)[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)是[故障安全架构](https://yaml.org/spec/1.2.2/#failsafe-schema)[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)的扩展。

All [nodes](https://yaml.org/spec/1.2.2/#nodes) with the “`!`” non-specific tag are [resolved](https://yaml.org/spec/1.2.2/#resolved-tags), by the standard [convention](https://yaml.org/spec/1.2.2/#resolved-tags), to “`tag:yaml.org,2002:seq`”, “`tag:yaml.org,2002:map`” or “`tag:yaml.org,2002:str`”, according to their [kind](https://yaml.org/spec/1.2.2/#nodes).
所有带有 “`！`” 非特定标记的[节点](https://yaml.org/spec/1.2.2/#nodes)[都由](https://yaml.org/spec/1.2.2/#resolved-tags)标准 [约定](https://yaml.org/spec/1.2.2/#resolved-tags)，根据其[类型](https://yaml.org/spec/1.2.2/#nodes)更改为“`tag：yaml.org，2002：seq`”、“`tag：yaml.org，2002：map`”或“`tag：yaml.org，2002：str`”。

[Collections](https://yaml.org/spec/1.2.2/#collections) with the “`?`” non-specific tag (that is, [untagged](https://yaml.org/spec/1.2.2/#resolved-tags) [collections](https://yaml.org/spec/1.2.2/#collections)) are [resolved](https://yaml.org/spec/1.2.2/#resolved-tags) to “`tag:yaml.org,2002:seq`” or “`tag:yaml.org,2002:map`” according to their [kind](https://yaml.org/spec/1.2.2/#nodes).
带有 “`？`” 非特定标签的[集合](https://yaml.org/spec/1.2.2/#collections)（即[未标记](https://yaml.org/spec/1.2.2/#resolved-tags)的[集合](https://yaml.org/spec/1.2.2/#collections)[）根据其](https://yaml.org/spec/1.2.2/#resolved-tags)[种类](https://yaml.org/spec/1.2.2/#nodes)解析为 “`tag：yaml.org，2002：seq`” 或 “`tag：yaml.org，2002：map`”。

[Scalars](https://yaml.org/spec/1.2.2/#scalars) with the “`?`” non-specific tag (that is, [plain scalars](https://yaml.org/spec/1.2.2/#plain-style)) are matched with a list of regular expressions (first match wins, e.g. `0` is resolved as `!!int`). In principle, JSON files should not contain any [scalars](https://yaml.org/spec/1.2.2/#scalars) that do not match at least one of these. Hence the YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should consider them to be an error.
带有 “`？`” 非特定标签的[标量](https://yaml.org/spec/1.2.2/#scalars)（即[普通标量](https://yaml.org/spec/1.2.2/#plain-style)）与正则表达式列表匹配（第一个匹配项获胜，例如 `0` 解析为 `！！int` 的 API 中）。原则上，JSON 文件不应包含任何与其中至少一个不匹配的[标量](https://yaml.org/spec/1.2.2/#scalars)。因此，YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应将它们视为错误。

| Regular expression 正则表达式                                | Resolved to tag 已解决为标记                        |
| ------------------------------------------------------------ | --------------------------------------------------- |
| `null` `零`                                                  | tag:yaml.org,2002:null 标签：yaml.org，2002：null   |
| `true | false` `真 | 假`                                     | tag:yaml.org,2002:bool 标签：yaml.org，2002：bool   |
| `-? ( 0 | [1-9] [0-9]* )` `-？（ 0 |[1-9] [0-9]* ）`         | tag:yaml.org,2002:int 标签：yaml.org，2002：int     |
| `-? ( 0 | [1-9] [0-9]* ) ( \. [0-9]* )? ( [eE] [-+]? [0-9]+ )?` | tag:yaml.org,2002:float 标签：yaml.org，2002：float |
| `*`                                                          | Error 错误                                          |

> Note: The regular expression for `float` does not exactly match the one in the JSON specification, where at least one digit is required after the dot: `( \.  [0-9]+ )`.  The YAML 1.2 specification intended to match JSON behavior, but this cannot be addressed in the 1.2.2 specification.
> 注意：`float` 的正则表达式与 JSON 规范中的正则表达式不完全匹配，其中点后至少需要一个数字：`（ \.[0-9]+ ） 的 S` S TYAML 1.2 规范旨在匹配 JSON 行为，但这无法在 1.2.2 规范中解决。

**Example 10.8 JSON Tag Resolution
示例 10.8 JSON 标签解析**

| `A null: null Booleans: [ true, false ] Integers: [ 0, -0, 3, -19 ] Floats: [ 0., -0.0, 12e03, -2E+05 ] Invalid: [ True, Null,  0o7, 0x3A, +12.3 ] ` | `{ "A null": null,  "Booleans": [ true, false ],  "Integers": [ 0, 0, 3, -19 ],  "Floats": [ 0.0, -0.0, 12000, -200000 ],  "Invalid": [ "True", "Null",    "0o7", "0x3A", "+12.3" ] } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

## 10.3. Core Schema 10.3. 核心模式

The *Core schema* is an extension of the [JSON schema](https://yaml.org/spec/1.2.2/#json-schema), allowing for more human-readable [presentation](https://yaml.org/spec/1.2.2/#presentation-stream) of the same types. This is the recommended default [schema](https://yaml.org/spec/1.2.2/#recommended-schemas) that YAML [processor](https://yaml.org/spec/1.2.2/#processes-and-models) should use unless instructed otherwise. It is also strongly recommended that other [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) should be based on it.
*Core 架构*是 [JSON 架构](https://yaml.org/spec/1.2.2/#json-schema)的扩展，允许对相同类型进行更易读的[表示](https://yaml.org/spec/1.2.2/#presentation-stream)。这是 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)应使用的推荐默认[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)，除非另有说明。此外，强烈建议其他[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)应基于它。

### 10.3.1. Tags 10.3.1. 标签

The core [schema](https://yaml.org/spec/1.2.2/#recommended-schemas) uses the same [tags](https://yaml.org/spec/1.2.2/#tags) as the [JSON schema](https://yaml.org/spec/1.2.2/#json-schema).
核心[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)使用与 [JSON 架构](https://yaml.org/spec/1.2.2/#json-schema)相同的[标签](https://yaml.org/spec/1.2.2/#tags)。

### 10.3.2. Tag Resolution 10.3.2. 标签解析

The [core schema](https://yaml.org/spec/1.2.2/#core-schema) [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution) is an extension of the [JSON schema](https://yaml.org/spec/1.2.2/#json-schema) [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution).
[核心架构](https://yaml.org/spec/1.2.2/#core-schema)[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)是 [JSON 架构](https://yaml.org/spec/1.2.2/#json-schema)[标签解析](https://yaml.org/spec/1.2.2/#tag-resolution)的扩展。

All [nodes](https://yaml.org/spec/1.2.2/#nodes) with the “`!`” non-specific tag are [resolved](https://yaml.org/spec/1.2.2/#resolved-tags), by the standard [convention](https://yaml.org/spec/1.2.2/#resolved-tags), to “`tag:yaml.org,2002:seq`”, “`tag:yaml.org,2002:map`” or “`tag:yaml.org,2002:str`”, according to their [kind](https://yaml.org/spec/1.2.2/#nodes).
所有带有 “`！`” 非特定标记的[节点](https://yaml.org/spec/1.2.2/#nodes)[都由](https://yaml.org/spec/1.2.2/#resolved-tags)标准 [约定](https://yaml.org/spec/1.2.2/#resolved-tags)，根据其[类型](https://yaml.org/spec/1.2.2/#nodes)更改为“`tag：yaml.org，2002：seq`”、“`tag：yaml.org，2002：map`”或“`tag：yaml.org，2002：str`”。

[Collections](https://yaml.org/spec/1.2.2/#collections) with the “`?`” non-specific tag (that is, [untagged](https://yaml.org/spec/1.2.2/#resolved-tags) [collections](https://yaml.org/spec/1.2.2/#collections)) are [resolved](https://yaml.org/spec/1.2.2/#resolved-tags) to “`tag:yaml.org,2002:seq`” or “`tag:yaml.org,2002:map`” according to their [kind](https://yaml.org/spec/1.2.2/#nodes).
带有 “`？`” 非特定标签的[集合](https://yaml.org/spec/1.2.2/#collections)（即[未标记](https://yaml.org/spec/1.2.2/#resolved-tags)的[集合](https://yaml.org/spec/1.2.2/#collections)[）根据其](https://yaml.org/spec/1.2.2/#resolved-tags)[种类](https://yaml.org/spec/1.2.2/#nodes)解析为 “`tag：yaml.org，2002：seq`” 或 “`tag：yaml.org，2002：map`”。

[Scalars](https://yaml.org/spec/1.2.2/#scalars) with the “`?`” non-specific tag (that is, [plain scalars](https://yaml.org/spec/1.2.2/#plain-style)) are matched with an extended list of regular expressions. However, in this case, if none of the regular expressions matches, the [scalar](https://yaml.org/spec/1.2.2/#scalar) is [resolved](https://yaml.org/spec/1.2.2/#resolved-tags) to `tag:yaml.org,2002:str` (that is, considered to be a string).
带有 “`？`” 非特定标签的[标量](https://yaml.org/spec/1.2.2/#scalars)（即[普通标量](https://yaml.org/spec/1.2.2/#plain-style)）将与正则表达式的扩展列表匹配。但是，在这种情况下，如果没有任何正则表达式匹配，则[标量](https://yaml.org/spec/1.2.2/#scalar) [解析](https://yaml.org/spec/1.2.2/#resolved-tags)为 `tag：yaml.org，2002：str`（即视为字符串）。

| Regular expression 正则表达式                                | Resolved to tag 已解决为标记                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `null | Null | NULL | ~` `空 |空 |空 |~`                     | tag:yaml.org,2002:null 标签：yaml.org，2002：null            |
| `/* Empty */` `/*空*/`                                       | tag:yaml.org,2002:null 标签：yaml.org，2002：null            |
| `true | True | TRUE | false | False | FALSE`                 | tag:yaml.org,2002:bool 标签：yaml.org，2002：bool            |
| `[-+]? [0-9]+` `[-+]？[0-9]+`                                | tag:yaml.org,2002:int (Base 10) tag：yaml.org，2002：int （以 10 为基数） |
| `0o [0-7]+`                                                  | tag:yaml.org,2002:int (Base 8) tag：yaml.org，2002：int （基数 8） |
| `0x [0-9a-fA-F]+`                                            | tag:yaml.org,2002:int (Base 16) 标签：yaml.org，2002：int （Base 16） |
| `[-+]? ( \. [0-9]+ | [0-9]+ ( \. [0-9]* )? ) ( [eE] [-+]? [0-9]+ )?` | tag:yaml.org,2002:float (Number) tag：yaml.org，2002：float （数字） |
| `[-+]? ( \.inf | \.Inf | \.INF )`                            | tag:yaml.org,2002:float (Infinity) 标签：yaml.org，2002：float （Infinity） |
| `\.nan | \.NaN | \.NAN` `\.nan | \.NaN 系列 |\.南`           | tag:yaml.org,2002:float (Not a number) tag：yaml.org，2002：float （非数字） |
| `*`                                                          | tag:yaml.org,2002:str (Default) tag：yaml.org，2002：str （默认） |

**Example 10.9 Core Tag Resolution
示例 10.9 核心标记解析**

| `A null: null Also a null: # Empty Not a null: "" Booleans: [ true, True, false, FALSE ] Integers: [ 0, 0o7, 0x3A, -19 ] Floats: [  0., -0.0, .5, +12e03, -2E+05 ] Also floats: [  .inf, -.Inf, +.INF, .NAN ] ` | `{ "A null": null,  "Also a null": null,  "Not a null": "",  "Booleans": [ true, true, false, false ],  "Integers": [ 0, 7, 58, -19 ],  "Floats": [    0.0, -0.0, 0.5, 12000, -200000 ],  "Also floats": [    Infinity, -Infinity, Infinity, NaN ] } ` |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

## 10.4. Other Schemas 10.4. 其他模式

None of the above recommended [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) preclude the use of arbitrary explicit [tags](https://yaml.org/spec/1.2.2/#tags). Hence YAML [processors](https://yaml.org/spec/1.2.2/#processes-and-models) for a particular programming language typically provide some form of [local tags](https://yaml.org/spec/1.2.2/#tags) that map directly to the language’s [native data structures](https://yaml.org/spec/1.2.2/#representing-native-data-structures) (e.g., `!ruby/object:Set`).
上述建议的[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)均不排除使用任意显式 [标签](https://yaml.org/spec/1.2.2/#tags)中。因此，特定编程语言的 YAML [处理器](https://yaml.org/spec/1.2.2/#processes-and-models)通常提供某种形式的[本地标记](https://yaml.org/spec/1.2.2/#tags)，这些标记直接映射到该语言的[本机数据结构](https://yaml.org/spec/1.2.2/#representing-native-data-structures)（例如，`！ruby/object：Set`）。

While such [local tags](https://yaml.org/spec/1.2.2/#tags) are useful for ad hoc [applications](https://yaml.org/spec/1.2.2/#processes-and-models), they do not suffice for stable, interoperable cross-[application](https://yaml.org/spec/1.2.2/#processes-and-models) or cross-platform data exchange.
虽然此类[本地标记](https://yaml.org/spec/1.2.2/#tags)对 Ad Hoc [应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)很有用，但它们不足以实现稳定、可互作的跨[应用程序](https://yaml.org/spec/1.2.2/#processes-and-models)或跨平台数据交换。

Interoperable [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) make use of [global tags](https://yaml.org/spec/1.2.2/#tags) (URIs) that [represent](https://yaml.org/spec/1.2.2/#representation-graph) the same data across different programming languages. In addition, an interoperable [schema](https://yaml.org/spec/1.2.2/#recommended-schemas) may provide additional [tag resolution](https://yaml.org/spec/1.2.2/#tag-resolution) rules. Such rules may provide additional regular expressions, as well as consider the path to the [node](https://yaml.org/spec/1.2.2/#nodes). This allows interoperable [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) to use [untagged](https://yaml.org/spec/1.2.2/#resolved-tags) [nodes](https://yaml.org/spec/1.2.2/#nodes).
可互作[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)使用[全局标记](https://yaml.org/spec/1.2.2/#tags) （URI），这些标记在不同编程语言中[表示](https://yaml.org/spec/1.2.2/#representation-graph)相同的数据。此外，可互作[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)还可以提供额外的[标记解析](https://yaml.org/spec/1.2.2/#tag-resolution) 规则。 此类规则可以提供额外的正则表达式，并考虑 路径[。](https://yaml.org/spec/1.2.2/#nodes)这允许可互作[的架构](https://yaml.org/spec/1.2.2/#recommended-schemas)使用[未标记](https://yaml.org/spec/1.2.2/#resolved-tags)[的节点](https://yaml.org/spec/1.2.2/#nodes)。

It is strongly recommended that such [schemas](https://yaml.org/spec/1.2.2/#recommended-schemas) be based on the [core schema](https://yaml.org/spec/1.2.2/#core-schema) defined above.
强烈建议此类[架构](https://yaml.org/spec/1.2.2/#recommended-schemas)基于[核心架构](https://yaml.org/spec/1.2.2/#core-schema) 定义在上面。

## 参考链接

1. [YAML Language Development Team](https://yaml.org/spec/1.2.2/ext/team) [↩](https://yaml.org/spec/1.2.2/#fnref:team)
   [YAML 语言开发团队](https://yaml.org/spec/1.2.2/ext/team) [↩](https://yaml.org/spec/1.2.2/#fnref:team)
2. [YAML Specification on GitHub](https://github.com/yaml/yaml-spec) [↩](https://yaml.org/spec/1.2.2/#fnref:spec-repo)
   GitHub [↩](https://yaml.org/spec/1.2.2/#fnref:spec-repo) [上的 YAML 规范](https://github.com/yaml/yaml-spec)
3. [YAML Ain’t Markup Language (YAML™) version 1.2](https://yaml.org/spec/1.2/) [↩](https://yaml.org/spec/1.2.2/#fnref:1-2-spec) [↩2](https://yaml.org/spec/1.2.2/#fnref:1-2-spec:1)
   [YAML Ain't Markup Language （YAML™） 版本 1.2](https://yaml.org/spec/1.2/) [↩](https://yaml.org/spec/1.2.2/#fnref:1-2-spec) [↩2](https://yaml.org/spec/1.2.2/#fnref:1-2-spec:1)
4. [Unicode – The World Standard for Text and Emoji](https://home.unicode.org) [↩](https://yaml.org/spec/1.2.2/#fnref:unicode)
   [Unicode – 文本和表情符号](https://home.unicode.org)[↩](https://yaml.org/spec/1.2.2/#fnref:unicode)的世界标准
5. [YAML Core Mailing List](https://sourceforge.net/projects/yaml/lists/yaml-core) [↩](https://yaml.org/spec/1.2.2/#fnref:yaml-core)
   [YAML 核心邮件列表](https://sourceforge.net/projects/yaml/lists/yaml-core) [↩](https://yaml.org/spec/1.2.2/#fnref:yaml-core)
6. [SML-DEV Mailing List Archive](https://github.com/yaml/sml-dev-archive) [↩](https://yaml.org/spec/1.2.2/#fnref:sml-dev)
   [SML-DEV 邮件列表存档](https://github.com/yaml/sml-dev-archive) [↩](https://yaml.org/spec/1.2.2/#fnref:sml-dev)
7. [Data::Denter - An (deprecated) alternative to Data::Dumper and Storable](https://metacpan.org/dist/Data-Denter/view/Denter.pod) [↩](https://yaml.org/spec/1.2.2/#fnref:denter)
   [Data：:D enter - Data：:D umper 和 Storable](https://metacpan.org/dist/Data-Denter/view/Denter.pod) [↩](https://yaml.org/spec/1.2.2/#fnref:denter) 的（已弃用的）替代方案
8. [YAML Ain’t Markup Language (YAML™) version 1.1](https://yaml.org/spec/1.1/) [↩](https://yaml.org/spec/1.2.2/#fnref:1-1-spec)
   [YAML Ain't Markup Language （YAML™） 版本 1.1](https://yaml.org/spec/1.1/) [↩](https://yaml.org/spec/1.2.2/#fnref:1-1-spec)
9. [The JSON data interchange syntax](https://www.ecma-international.org/publications-and-standards/standards/ecma-404/) [↩](https://yaml.org/spec/1.2.2/#fnref:json)
   [JSON 数据交换语法](https://www.ecma-international.org/publications-and-standards/standards/ecma-404/) [↩](https://yaml.org/spec/1.2.2/#fnref:json)
10. [PyYAML - YAML parser and emitter for Python](https://github.com/yaml/pyyaml) [↩](https://yaml.org/spec/1.2.2/#fnref:pyyaml)
    [PyYAML - Python](https://github.com/yaml/pyyaml) [↩](https://yaml.org/spec/1.2.2/#fnref:pyyaml) 的 YAML 解析器和发射器
11. [LibYAML - A C library for parsing and emitting YAML](https://github.com/yaml/libyaml) [↩](https://yaml.org/spec/1.2.2/#fnref:libyaml)
    [LibYAML - 用于解析和发出 YAML](https://github.com/yaml/libyaml) [↩](https://yaml.org/spec/1.2.2/#fnref:libyaml) 的 C 库
12. [Request for Comments Summary](https://datatracker.ietf.org/doc/html/rfc2119) [↩](https://yaml.org/spec/1.2.2/#fnref:rfc-2119)
    [征求意见摘要](https://datatracker.ietf.org/doc/html/rfc2119) [↩](https://yaml.org/spec/1.2.2/#fnref:rfc-2119)
13. [directed graph](https://xlinux.nist.gov/dads/HTML/directedGraph.html) [↩](https://yaml.org/spec/1.2.2/#fnref:digraph)
    [有向图](https://xlinux.nist.gov/dads/HTML/directedGraph.html) [↩](https://yaml.org/spec/1.2.2/#fnref:digraph)
14. [The ‘tag’ URI Scheme](https://datatracker.ietf.org/doc/html/rfc4151) [↩](https://yaml.org/spec/1.2.2/#fnref:tag-uri)
    ['tag' URI 方案](https://datatracker.ietf.org/doc/html/rfc4151) [↩](https://yaml.org/spec/1.2.2/#fnref:tag-uri)
15. [Wikipedia - C0 and C1 control codes](https://en.wikipedia.org/wiki/C0_and_C1_control_codes) [↩](https://yaml.org/spec/1.2.2/#fnref:c0-block)
    [维基百科 - C0 和 C1 控制代码](https://en.wikipedia.org/wiki/C0_and_C1_control_codes) [↩](https://yaml.org/spec/1.2.2/#fnref:c0-block)
16. [Wikipedia - Universal Character Set characters #Surrogates](https://en.wikipedia.org/wiki/Universal_Character_Set_characters#Surrogates) [↩](https://yaml.org/spec/1.2.2/#fnref:surrogates)
    [维基百科 - 通用字符集字符 #Surrogates](https://en.wikipedia.org/wiki/Universal_Character_Set_characters#Surrogates) [↩](https://yaml.org/spec/1.2.2/#fnref:surrogates)
17. [UTF-8, UTF-16, UTF-32 & BOM](https://www.unicode.org/faq/utf_bom.html) [↩](https://yaml.org/spec/1.2.2/#fnref:uni-faq)
    [UTF-8， UTF-16， UTF-32 & BOM](https://www.unicode.org/faq/utf_bom.html) [↩](https://yaml.org/spec/1.2.2/#fnref:uni-faq)
18. [Uniform Resource Identifiers (URI)](https://datatracker.ietf.org/doc/html/rfc3986) [↩](https://yaml.org/spec/1.2.2/#fnref:uri)
    [统一资源标识符 （URI）](https://datatracker.ietf.org/doc/html/rfc3986) [↩](https://yaml.org/spec/1.2.2/#fnref:uri)



## 版本

  - YAML 1.2
    - Revision 1.2.2      # 2021-10-1 *New*
    - Revision 1.2.1      # 2009-10-1
    - Revision 1.2.0      # 2009-7-21
  - YAML 1.1
  - YAML 1.0 
