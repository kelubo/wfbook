# gRPC概述

gRPC（Google Remote Procedure Call，Google远程过程调用）是Google发布的基于HTTP 2.0传输层协议承载的高性能开源软件框架，提供了支持多种编程语言的、对网络设备进行配置和管理的方法。通信双方可以基于该软件框架进行二次开发。

## 1.1 gRPC协议分层

图1 gRPC协议栈分层

![img](https://resource.h3c.com/cn/201910/25/20191025_4562697_x_Img_x_png_0_1238939_30005_0.png)

 

gRPC协议栈分层如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref17467844)所示。各层的含义为：

·   TCP传输层：TCP提供面向连接的、可靠的数据链路。

·   TLS（Transport Layer Security，传输层安全）传输层：该层是可选的，设备和采集器可以基于TLS协议进行通道加密和双向证书认证，实现安全通信。

·   HTTP 2.0应用层：gRPC承载在HTTP 2.0协议上，利用了该协议的首部数据压缩、单TCP连接支持多路请求、流量控制等性能增强特性。

·   gRPC层：定义了RPC（Remote Procedure Call，远程过程调用）的协议交互格式。公共RPC方法定义在公共proto文件中，例如grpc_dialout.proto。

·   内容层：用于承载编码后的业务数据。业务数据的编码格式包括：

¡   GPB（Google Protocol Buffer）：高效的二进制编码格式，通过proto文件描述编码使用的数据结构。在设备和采集器之间传输数据时，该编码格式的数据比其他格式（如JSON）的数据具有更高的信息负载能力。

业务数据使用Protocol Buffer格式编码时，需要配合对应的业务模块proto文件才能解码。

目前，设备暂不支持业务数据使用GPB编码格式。

¡   JSON（JavaScript Object Notation）：轻量级的数据交换格式，采用独立于编程语言的文本格式来存储和表示数据，易于阅读和编写。

业务数据使用JSON格式编码时，通过公共proto文件即可解码，无需对应的业务模块proto文件。

设备和采集器通信时，双方的proto文件必须保持一致才能解码。

## 1.2 gRPC网络架构

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515530039)所示，gRPC网络采用客户端/服务器模型，使用HTTP 2.0协议传输报文。

图2 gRPC网络架构

![img](https://resource.h3c.com/cn/201910/25/20191025_4562698_x_Img_x_png_1_1238939_30005_0.png)

 

gRPC网络的工作机制如下：

(1)   服务器通过监听指定服务端口来等待客户端的连接请求。

(2)   用户通过执行客户端程序登录到服务器。

(3)   客户端调用proto文件提供的gRPC方法发送请求消息。

(4)   服务器回复应答消息。

H3C设备支持作为gRPC服务器或者gRPC客户端。

## 1.3 基于gRPC的Telemetry技术

Telemetry是一项监控设备性能和故障的远程数据采集技术。H3C的Telemetry技术采用gRPC协议将数据从设备推送给网管的采集器。如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515542082)所示，网络设备和网管系统建立gRPC连接后，网管可以订阅设备上指定模块的数据信息。

图3 基于gRPC的Telemetry技术

![img](https://resource.h3c.com/cn/201910/25/20191025_4562699_x_Img_x_png_2_1238939_30005_0.png)

 

## 1.4 Dial-in模式和Dial-out模式

[1.3 图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515542082)中，设备支持以下两种gRPC对接模式：

·   Dial-in模式：设备作为gRPC服务器，采集器作为gRPC客户端。由采集器主动向设备发起gRPC连接并订阅需要采集的数据信息。

Dial-in模式适用于小规模网络和采集器需要向设备下发配置的场景。

·   Dial-out模式：设备作为gRPC客户端，采集器作为gRPC服务器。设备主动和采集器建立gRPC连接，将设备上配置的订阅数据推送给采集器。

Dial-out模式适用于网络设备较多的情况下向采集器提供设备数据信息。

# 2 Protocol Buffers编码介绍

## 2.1 Protocol Buffers编码格式

Protocol Buffers编码提供了一种灵活、高效、自动序列化结构数据的机制。Protocol Buffers与XML、JSON编码类似，不同之处在于Protocol Buffers是一种二进制编码，性能更高。

[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515525683)对比了Protocol Buffers和对应的JSON编码格式。

表1 Protocol Buffers和对应的JSON编码格式示例

| Protocol Buffers编码                                         | 对应的JSON编码                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| {  1:“H3C”  2:“H3C”  3:“H3C Simware”  4:“Syslog/LogBuffer”  5:"notification": {  "Syslog": {  "LogBuffer": {  "BufferSize": 512,  "BufferSizeLimit": 1024,  "DroppedLogsCount": 0,  "LogsCount": 100,  "LogsCountPerSeverity": {  "Alert": 0,  "Critical": 1,  "Debug": 0,  "Emergency": 0,  "Error": 3,  "Informational": 80,  "Notice": 15,  "Warning": 1  },  "OverwrittenLogsCount": 0,  "State": "enable"  }  },  "Timestamp": "1527206160022"  }  } | {  "producerName": "H3C",  "deviceName": "H3C",  "deviceModel": "H3C Simware",  "sensorPath": "Syslog/LogBuffer",  "jsonData": {  "notification": {  "Syslog": {  "LogBuffer": {  "BufferSize": 512,  "BufferSizeLimit": 1024,  "DroppedLogsCount": 0,  "LogsCount": 100,  "LogsCountPerSeverity": {  "Alert": 0,  "Critical": 1,  "Debug": 0,  "Emergency": 0,  "Error": 3,  "Informational": 80,  "Notice": 15,  "Warning": 1  },  "OverwrittenLogsCount": 0,  "State": "enable"  }  },  "Timestamp": "1527206160022"  }  }  } |

 

## 2.2 proto文件

Protocol Buffers编码通过proto文件描述数据结构，用户可以利用Protoc等工具软件根据proto文件自动生成其他编程语言（例如Java、C++）代码，然后基于这些生成的代码进行二次开发，以实现gRPC设备对接。

H3C为Dial-in模式和Dial-out模式分别提供了proto文件。

### 2.2.1 Dial-in模式的proto文件

#### 1. 公共proto文件

grpc_service.proto文件定义了Dial-in模式下的公共RPC方法（例如Login、Logout），其内容和含义如下：

syntax = "proto2";

package grpc_service;

message GetJsonReply { //Get方法应答结果

  required string result = 1;

}

message SubscribeReply { //订阅结果

  required string result = 1;

}

message ConfigReply { //配置结果

  required string result = 1;

}

message ReportEvent { //订阅事件结果定义

  required string token_id = 1; //登录token_id

  required string stream_name = 2; //订阅的事件流名称

  required string event_name = 3; //订阅的事件名

  required string json_text = 4; //订阅结果json字符串

}

message GetReportRequest{ //获取事件订阅结果请求

  required string token_id = 1; //登录成功后的token_id

}

message LoginRequest { //登录请求参数定义

  required string user_name = 1; //登录请求用户名

  required string password = 2; //登录请求密码

} 

message LoginReply { //登录请求应答定义

  required string token_id = 1; //登录成功后返回的token_id

}

message LogoutRequest { //退出登录请求参数定义

  required string token_id = 1; //token_id

}

message LogoutReply { //退出登录返回结果定义

  required string result = 1; //退出登录结果

}

message SubscribeRequest { //定义事件流名称

  required string stream_name = 1;

}

service GrpcService { //定义gRPC方法

  rpc Login (LoginRequest) returns (LoginReply) {} //登录方法

  rpc Logout (LogoutRequest) returns (LogoutReply) {} //退出登录方法

  rpc SubscribeByStreamName (SubscribeRequest) returns (SubscribeReply) {} //订阅事件流

  rpc GetEventReport (GetReportRequest) returns (stream ReportEvent) {} //获取事件结果

}

#### 2. 业务模块proto文件

Dial-in模式支持Device、Ifmgr、IPFW、LLDP、Syslog等多个业务模块的proto文件，描述具体的业务数据格式。

以Device.proto文件为例，该文件定义了Device模块数据的RPC方法，其内容和含义如下：

syntax = "proto2";

import "grpc_service.proto";

package device;

message DeviceBase { //获取设备基本信息结构定义

  optional string HostName = 1; //设备的名称

  optional string HostOid = 2; //sysoid

  optional uint32 MaxChassisNum = 3; //最大框数

  optional uint32 MaxSlotNum = 4; //最大slot数

  optional string HostDescription = 5; //设备描述信息

}

message DevicePhysicalEntities { //设备物理实体信息

  message Entity {

​    optional uint32 PhysicalIndex = 1; //实体索引

​    optional string VendorType = 2; //vendor类型

​    optional uint32 EntityClass = 3;//实体类型

​    optional string SoftwareRev = 4; //软件版本

​    optional string SerialNumber = 5; //序列号

​    optional string Model = 6; //模式

  }

  repeated Entity entity = 1;

}

service DeviceService { //定义的RPC方法

  rpc GetJsonDeviceBase(DeviceBase) returns (grpc_service.GetJsonReply) {} //获取设备基本信息

  rpc GetJsonDevicePhysicalEntities(DevicePhysicalEntities) returns (grpc_service.GetJsonReply) {}

} //获取设备实体信息

### 2.2.2 Dial-out模式的proto文件

grpc_dialout.proto文件定义了Dial-out模式下的公共RPC方法，其内容和含义如下：

syntax = "proto2";

package grpc_dialout;

message DeviceInfo{ //推送的设备信息

  required string producerName = 1; //厂商名

  required string deviceName = 2; //设备的名称

  required string deviceModel = 3; //设备型号

}

message DialoutMsg{  //推送的消息格式描述

  required DeviceInfo deviceMsg = 1; //DeviceInfo所描述的设备信息

  required string sensorPath = 2; //采样路径，对应netconf表的xpath路径

  required string jsonData = 3; //采样结果数据（JSON格式字符串）

}

message DialoutResponse{ //采集器（gRPC服务器）返回信息，预留（暂不处理返回值，可填充任意值）

  required string response = 1;

}

service gRPCDialout { //推送方法

  rpc Dialout(stream DialoutMsg) returns (DialoutResponse);

}

### 2.2.3 获取proto文件的方法

请联系H3C技术支持。

# 3 gRPC支持采集的业务数据类型

Dial-in模式下，设备支持提供设备管理、接口管理、IP转发、LLDP、系统日志等多个业务模块的数据。具体以H3C技术支持提供的业务proto文件为准。

Dial-out模式下，设备支持采集以下两种类型的业务数据：

·   事件触发类型：该类数据的采样没有固定周期，仅由事件触发。相关事件列表请参见对应模块的《NETCONF XML API Event Reference》手册。

·   周期采样类型：该类数据的采样有固定时间间隔。相关数据列表请参见对应模块的除了《NETCONF XML API Event Reference》之外的其他NETCONF XML API手册。

当同一时刻采样的数据较多时，可能因为瞬时CPU负荷过大，导致采样间隔暂时变长。

可以通过sensor path命令的相关提示来查看设备在Dial-out模式下支持采样的所有业务数据。

# 4 gRPC典型配置举例

本章节主要描述设备上的命令行配置。采集器上的gRPC对接软件需要另外开发，请参考“[5 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515547678)[gRPC对接软件二次开发举例](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515547678)”

## 4.1 Dial-in模式配置举例

#### 1. 组网需求

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515547751)所示，设备作为gRPC服务器与采集器相连。采集器为gRPC客户端。

通过在设备上配置gRPC Dial-in模式，使客户端可以订阅设备上的LLDP事件。

图4 Dial-in模式配置组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562700_x_Img_x_png_3_1238939_30005_0.png)

 

#### 2. 配置步骤

在开始下面的配置之前，假设gRPC服务器与gRPC客户端的IP地址都已配置完毕，并且它们之间路由可达。

(1)   配置gRPC服务器

\# 开启gRPC功能。

<gRPC-server> system-view

[gRPC-server] grpc enable

\# 创建本地用户test，配置该用户的密码为test，可以使用的服务类型为HTTPS服务。

[gRPC-server] local-user test

[gRPC-server-luser-manage-test] password simple test

[gRPC-server-luser-manage-test] service-type https

[gRPC-server-luser-manage-test] quit

(2)   配置gRPC客户端

a.   在gRPC客户端安装gRPC环境，具体安装方式请参考相关文档。

b.   获取H3C提供的proto文件（该文件中已写入订阅LLDP事件的配置），并通过Protocol Buffers编译器生成特定语言（例如Java、Python、C/C++、Go）的执行代码。

c.   编写客户端程序，调用上一步生成的代码。

d.   执行客户端程序，登录到gRPC服务器。

## 4.2 Dial-out模式配置举例

#### 1. 组网需求

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/gRPC_White_Paper-6W100/?CHID=949051#_Ref515547767)所示，设备作为gRPC客户端与采集器相连。采集器为gRPC服务器，接收数据的端口号为50050。

通过在设备上配置Dial-out模式，使设备以10秒的周期向采集器推送接口模块的设备能力信息。

图5 Dial-out模式配置组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562701_x_Img_x_png_4_1238939_30005_0.png)

 

#### 2. 配置步骤

在开始下面的配置之前，假设设备与采集器的IP地址都已配置完毕，并且它们之间路由可达。

\# 开启gRPC功能。

<Device> system-view

[Device] grpc enable

\# 创建传感器组test，并配置采样路径为ifmgr/devicecapabilities。

[Device] telemetry

[Device-telemetry] sensor-group test

[Device-telemetry-sensor-group-test] sensor path ifmgr/devicecapabilities

[Device-telemetry-sensor-group-test] quit

\# 创建目标组collector1，并添加IP地址为192.168.2.1、端口号为50050的采集器。

[Device-telemetry] destination-group collector1

[Device-telemetry-destination-group-collector1] ipv4-address 192.168.2.1 port 50050

[Device-telemetry-destination-group-collector1] quit

\# 创建订阅A，配置关联传感器组为test，数据采样和推送周期为10秒，关联目标组为collector1。

[Device-telemetry] subscription A

[Device-telemetry-subscription-A] sensor-group test sample-interval 10

[Device-telemetry-subscription-A] destination-group collector1

[Device-telemetry-subscription-A] quit

# 5 gRPC对接软件二次开发举例

本举例开发的软件用于实现采集器获取设备数据。开发环境为Linux，编程语言以C++为例。

## 5.1 准备工作

(1)   获取H3C提供的proto文件：

¡   对于Dial-in模式，需要grpc_service.proto文件和具体业务模块对应的proto文件。

¡   对于Dial-out模式，需要grpc_dialout.proto文件。

(2)   获取处理proto文件的工具软件protoc。

下载地址：https://github.com/google/protobuf/releases

(3)   获取对应开发语言的protobuf插件，例如C++插件protobuf-cpp。

下载地址：https://github.com/google/protobuf/releases

## 5.2 生成代码

生成proto文件对应的C++代码。

### 5.2.1 Dial-in模式

将需要的proto文件收集到当前目录下，例如grpc_service.proto和BufferMonitor.proto。

$protoc --plugin=./grpc_cpp_plugin --grpc_out=. --cpp_out=. *.proto

### 5.2.2 Dial-out模式

将grpc_dialout.proto文件收集到当前目录下。

$ protoc --plugin=./grpc_cpp_plugin --grpc_out=. --cpp_out=. *.proto

## 5.3 开发代码

### 5.3.1 Dial-in模式

对于Dial-in模式，主要是实现gRPC客户端代码（采集器上使用）。

由于生成的proto代码已经封装好了对应的服务类（这里以GrpcService和BufferMonitorService为例），只要在编写的客户端代码中调用其RPC方法，客户端就能够向设备（gRPC服务器）发起对应的RPC请求。

客户端代码主要包括以下3部分：

·   进行登录操作，获取token_id。

·   为要发起的RPC方法准备参数，用proto生成的服务类发起RPC调用并解析返回结果。

·   退出登录。

编码步骤如下：

(1)   编写一个GrpcServiceTest类。

在这个类中使用由grpc_service.proto生成的GrpcService::Stub类，通过grpc_service.proto自动生成的Login和Logout方法分别完成登录和退出。

class GrpcServiceTest

{

public:

  /* 构造函数 */

 GrpcServiceTest(std::shared_ptr<Channel> channel): GrpcServiceStub(GrpcService::NewStub(channel)) {}

 

  /* 成员函数 */

  int Login(const std::string& username, const std::string& password);

 void Logout();

 void listen();

 

  /* 成员变量 */

 std::string token;

  

private: 

 std::unique_ptr<GrpcService::Stub> GrpcServiceStub; //使用grpc_service.proto生成的GrpcService::Stub类

};

(2)   实现自定义的Login方法。

通过用户输入的用户名，密码调用GrpcService::Stub类的Login方法完成登录。

int GrpcServiceTest::Login(const std::string& username, const std::string& password)

{

  LoginRequest request;  //设置用户名密码

  request.set_user_name(username);

  request.set_password(password);

 

LoginReply reply;    

ClientContext context;

 

 //调用登录方法

 Status status = GrpcServiceStub->Login(&context, request, &reply);

 if (status.ok())

  {

   std::cout << "login ok!" << std::endl;

​    std::cout <<"token id is :" << reply.token_id() << std::endl;

   token = reply.token_id(); //登录成功，获取到token.

​    return 0;

  }

  else{                    

   std::cout << status.error_code() << ": " << status.error_message() 

​         << ". Login failed!" << std::endl;

​    return -1;

  }

}

(3)   发起对设备的RPC方法请求。

这里以订阅接口丢包事件举例：

rpc SubscribePortQueDropEvent(PortQueDropEvent) returns (grpc_service.SubscribeReply) {}

(4)   编写一个BufMon_GrpcClient类来封装发起的RPC方法。

使用BufferMonitor.proto自动生成的BufferMonitorService::Stub类完成RPC方法的调用。

class BufMon_GrpcClient

{

public:

  BufMon_GrpcClient(std::shared_ptr<Channel> channel): mStub(BufferMonitorService::NewStub(channel))

  {

  }

  

  std::string BufMon_Sub_AllEvent(std::string token);

  std::string BufMon_Sub_BoardEvent(std::string token);

  std::string BufMon_Sub_PortOverrunEvent(std::string token);

  std::string BufMon_Sub_PortDropEvent(std::string token);

 

  /* get 表项 */

  std::string BufMon_Sub_GetStatistics(std::string token);

  std::string BufMon_Sub_GetGlobalCfg(std::string token);

  std::string BufMon_Sub_GetBoardCfg(std::string token);

  std::string BufMon_Sub_GetNodeQueCfg(std::string token);

  std::string BufMon_Sub_GetPortQueCfg(std::string token);

 

private:

 std::unique_ptr<BufferMonitorService::Stub> mStub; //使用BufferMonitor.proto自动生成的类

};

(5)   实现自定义的std::string BufMon_Sub_PortDropEvent(std::string token)方法完成接口丢包事件订阅。

std::string BufMon_GrpcClient::BufMon_Sub_PortDropEvent(std::string token)

{

  std::cout << "-------BufMon_Sub_PortDropEvent-------- " << std::endl;

 

 PortQueDropEvent stNodeEvent;

 PortQueDropEvent_PortQueDrop* pstParam = stNodeEvent.add_portquedrop();

 

  UINT uiIfIndex = 0;

  UINT uiQueIdx = 0;

  UINT uiAlarmType = 0;

 

  std::cout<<"Please input interface queue info : ifIndex queIdx alarmtype " << std::endl;

  cout<<"alarmtype : 1 for ingress; 2 for egress; 3 for port headroom"<<endl;

 

  std::cin>>uiIfIndex>>uiQueIdx>>uiAlarmType; //设置订阅参数，接口索引等。

 pstParam->set_ifindex(uiIfIndex);

  pstParam->set_queindex(uiQueIdx);

  pstParam->set_alarmtype(uiAlarmType);

 

  ClientContext context;

 

 /* token need add to context */ //设置登录成功后返回的token_id

 std::string key = "token_id";

 std::string value = token;

 context.AddMetadata(key, value);

 

 SubscribeReply reply;

 Status status = mStub->SubscribePortQueDropEvent(&context,stNodeEvent,&reply); //调用RPC方法

 

 return reply.result(); 

}

(6)   循环等待事件上报。

在之前的GrpcServiceTest类中实现此方法，代码如下：

void GrpcServiceTest::listen()

{

  GetReportRequest reportRequest;

  ClientContext context; 

  ReportEvent reportedEvent;

 

 /* add token to request */

 reportRequest.set_token_id(token);

 

  std::unique_ptr< ClientReader< ReportEvent>> reader(GrpcServiceStub->GetEventReport(&context, reportRequest)); //通过grpc_service.proto自动生成的类的GetEventReport来获取事件信息

 

  std::string streamName;   

  std::string eventName;

  std::string jsonText;

 std::string token;

 

  JsonFormatTool jsonTool;

 

 std::cout << "Listen to server for Event" << std::endl;

 

  while(reader->Read(&reportedEvent) ) //读取收到的上报事件

  {

​    streamName = reportedEvent.stream_name();

​    eventName = reportedEvent.event_name();

   jsonText = reportedEvent.json_text();

   token = reportedEvent.token_id();

 

   std::cout << "/**********************EVENT COME************************/" << std::endl;

   std::cout << "TOKEN: " << token << std::endl; 

   std::cout << "StreamName: "<< streamName << std::endl;

   std::cout << "EventName: " << eventName << std::endl;

   std::cout << "JsonText without format: " << std::endl << jsonText << std::endl;

​    std::cout << std::endl;

   std::cout << "JsonText Formated: " << jsonTool.formatJson(jsonText) << std::endl;

​    std::cout << std::endl;

  }

 

  Status status = reader->Finish();

  std::cout << "Status Message:" << status.error_message() << "ERROR code :" << status.error_code();

}

(7)   这样就完成了Dial-in模式的登录和RPC请求调用，最后调用Logout退出即可。

### 5.3.2 Dial-out模式

对于Dial-out模式，主要是实现服务端代码，使采集器（gRPC服务器）接收从设备上获取到的数据并进行解析。

服务端代码主要包括以下2部分：

·   继承自动生成的GRPCDialout::Service类，重载自动生成的RPC服务Dialout，并完成解析，获得相应字段内容。

·   将RPC服务注册到指定监听端口上。

编码步骤如下：

(1)   继承并重载RPC服务Dailout。

新建一个类DialoutTest并继承GRPCDialout::Service。

class DialoutTest final : public GRPCDialout::Service { //重载自动生成的抽象类

  Status Dialout(ServerContext* context, ServerReader< DialoutMsg>* reader, DialoutResponse* response) override; //实现Dialout RPC方法

};

(2)   将DialoutTest服务注册为gRPC服务，并指定监听端口。

using grpc::Server;

using grpc::ServerBuilder;

std::string server_address("0.0.0.0:60057"); //指定要监听的地址和端口

DialoutTest dialout_test; //定义（1）中声明的对象

ServerBuilder builder;

builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());//添加监听

builder.RegisterService(&dialout_test); //注册服务

std::unique_ptr<Server> server(builder.BuildAndStart()); //启动服务

server->Wait();

(3)   实现Dialout方法，实现数据解析。

Status DialoutTest::Dialout(ServerContext* context, ServerReader< DialoutMsg>* reader, DialoutResponse* response)

{

​    DialoutMsg msg;

 

​    while( reader->Read(&msg))

​    {

​      const DeviceInfo &device_msg = msg.devicemsg();

​      std::cout<< "Producer-Name: " << device_msg.producername() << std::endl;

​      std::cout<< "Device-Name: " << device_msg.devicename() << std::endl;

​      std::cout<< "Device-Model: " << device_msg.devicemodel() << std::endl;

​      std::cout<<"Sensor-Path: " << msg.sensorpath()<<std::endl;

​       std::cout<<"Json-Data: " << msg.jsondata()<<std::endl;

​      std::cout<<std::endl;

​    }

​    response->set_response("test");

 

​    return Status::OK;

}

(4)   通过Read方法获取到proto文件生成的DailoutMsg对象后，可以调用对应的方法获取相应的字段值。

 