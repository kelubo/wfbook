# RabbitMQ

是一个遵守高级消息队列协议（Advanced Message Queuing Protocol，AMQP）的队列系统，允许在大规模分布式系统中保证消息的传递和顺序。

## 安装

Ubuntu

```bash
sudo apt-get -y install rabbitmq-server
```

## 配置

配置guest的密码

```bash
rabbitmqctl change_password guest xxxxxxxx
```

验证运行状态

```bash
rabbitmqctl status
```

