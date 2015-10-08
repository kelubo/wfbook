# Heka
Heka 是一个高可扩展的数据收集和处理工具。  
4种插件分别是：Input、Decoder、Filter、Output。  
**Input插件**是Heka的数据输入源。  
**Decoder插件**，各种Input插件负责将原始数据送入到Heka内部，这些数据一般来说都是具备一定的格式，比如：Nginx access日志、Syslog协议数据、自定义的数据格式等等，Decoder插件将Input插件输入的一个个的原始数据消息给解析一遍，最终得到一个结构化好的消息，不再是一个非结构化的原始数据消息。结构化的消息更利于编程进行处。每个Input插件得有一个Decoder插件负责对输入的数据进行解析到结构化的程度。  
**Filter插件**负责具体的数据分析、计算任务。  
**OutPut插件**将Heka内部的一个个消息输出到外部环境，比如：文件、数据库、消息队列等；也可以通过TcpOutput将消息输出到下一个Heka继续处理，这样就可以部署成多机分布式结构，只要有必要。  
Heka是基于Pipeline方式对数据进行实时处理。message matcher是应用在Filter和Output两种插件身上，主要是用来指定哪些消息由哪些插件(Filter/Output)处理。有了 message matcher机制就可以通过配置文件实现不同的数据由不同的Filter进行计算、不同的Output输出到不同的外部环境。