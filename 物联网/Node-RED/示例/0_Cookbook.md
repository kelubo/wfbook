# Node-RED Cookbook Node-RED食谱

This is a collection of recipes for how to use Node-RED to solve many common programming tasks.
这是一个如何使用Node-RED解决许多常见编程任务的食谱集合。

Each recipe addresses a specific problem and shows by example how it can be solved using the capabilities of the platform.
每个配方都解决了一个特定的问题，并通过示例展示了如何使用平台的功能来解决这个问题。

If you’re interested in contributing to the cookbook you are more than welcome. Join the `#docs` channel on [slack](https://nodered.org/slack) and get involved.
如果你有兴趣为这本烹饪书做贡献，欢迎你。加入[Slack](https://nodered.org/slack)上的`#Docs`频道并参与进来。

## Table of Contents 目录

#### Messages 消息

- [Set a message property to a fixed value
  将消息属性设置为固定值](https://cookbook.nodered.org/basic/set-message-property-fixed)
- [Delete a message property
  删除消息属性](https://cookbook.nodered.org/basic/delete-message-property)
- [Move a message property 移动消息属性](https://cookbook.nodered.org/basic/move-message-property)
- [Map a property between different numeric ranges
  在不同的数值范围之间映射属性](https://cookbook.nodered.org/basic/map-between-different-number-ranges)

#### Flow control 流量控制

- [Trigger a flow whenever Node-RED starts
  Node-RED启动时触发流](https://cookbook.nodered.org/basic/trigger-on-start)
- [Trigger a flow at regular intervals
  定期触发流](https://cookbook.nodered.org/basic/trigger-at-interval)
- [Trigger a flow at a specific time
  在特定时间触发流](https://cookbook.nodered.org/basic/trigger-at-time)
- [Route a message based on one of its properties
  根据邮件的某个属性路由邮件](https://cookbook.nodered.org/basic/route-on-property)
- [Route a message based on a context value
  基于上下文值路由消息](https://cookbook.nodered.org/basic/route-on-context)
- [Perform an operation on each element in an array
  对数组中的每个元素执行操作](https://cookbook.nodered.org/basic/operate-on-array)
- [Trigger a flow if a message isn’t received after a defined time
  如果在定义的时间后未收到消息，则触发流](https://cookbook.nodered.org/basic/trigger-timeout)
- [Send placeholder messages when a stream stops sending
  当流停止发送时发送占位符消息](https://cookbook.nodered.org/basic/trigger-placeholder)
- [Slow down messages passing through a flow
  减慢消息通过流的速度](https://cookbook.nodered.org/basic/rate-limit-messages)
- [Handle messages at a regular rate
  以常规速率处理消息](https://cookbook.nodered.org/basic/rate-limit-message-stream)
- [Drop messages that have not changed value
  删除未更改值的邮件](https://cookbook.nodered.org/basic/report-by-exception)
- [Create a single message from separate streams of messages
  从不同的消息流创建单个消息](https://cookbook.nodered.org/basic/join-streams)

#### Error handling 错误处理

- [Trigger a flow when a node throws an error
  当节点抛出错误时触发流](https://cookbook.nodered.org/basic/trigger-on-error)
- [Automatically retry an action after an error
  出现错误后自动重试操作](https://cookbook.nodered.org/basic/retry-on-error)

#### Working with data formats 使用数据格式

- [Convert to/from JSON 转换为/从JSON](https://cookbook.nodered.org/basic/convert-json)
- [Convert to/from XML 转换为/从XML](https://cookbook.nodered.org/basic/convert-xml)
- [Convert to/from YAML 转换为/从YAML](https://cookbook.nodered.org/basic/convert-yaml)
- [Generate CSV output 生成CSV输出](https://cookbook.nodered.org/basic/generate-csv)
- [Parse CSV input 解析CSV输入](https://cookbook.nodered.org/basic/parse-csv)
- [Extracting data from an HTML page
  从HTML页面提取数据](https://cookbook.nodered.org/http/simple-get-request)
- [Split text into one message per line
  将文本拆分为每行一条消息](https://cookbook.nodered.org/basic/split-text)

#### HTTP endpoints HTTP端点

- [Create an HTTP Endpoint 创建HTTP端点](https://cookbook.nodered.org/http/create-an-http-endpoint)
- [Handle query parameters passed to an HTTP endpoint
  处理传递给HTTP端点的查询参数](https://cookbook.nodered.org/http/handle-query-parameters)
- [Handle url parameters in an HTTP endpoint
  处理HTTP端点中的url参数](https://cookbook.nodered.org/http/handle-url-parameters)
- [Access HTTP request headers
  访问HTTP请求标头](https://cookbook.nodered.org/http/access-http-request-headers)
- [Include data captured in another flow
  包括在另一个流中捕获的数据](https://cookbook.nodered.org/http/include-data-from-another-flow)
- [Serve JSON content 提供JSON内容](https://cookbook.nodered.org/http/serve-json-content)
- [Serve a local file 提供本地文件](https://cookbook.nodered.org/http/serve-a-local-file)
- [Post raw data to a flow
  将原始数据发布到流](https://cookbook.nodered.org/http/post-raw-data-to-a-flow)
- [Post form data to a flow
  将表单数据提交到流](https://cookbook.nodered.org/http/post-form-data-to-a-flow)
- [Post JSON data to a flow
  将JSON数据发布到流](https://cookbook.nodered.org/http/post-json-data-to-a-flow)
- [Work with cookies 使用Cookie](https://cookbook.nodered.org/http/work-with-cookies)

#### HTTP requests HTTP请求

- [Simple GET request 简单GET请求](https://cookbook.nodered.org/http/simple-get-request)
- [Set the url of a request
  设置请求的URL](https://cookbook.nodered.org/http/set-request-url)
- [Set the url of a request using a template
  使用模板设置请求的URL](https://cookbook.nodered.org/http/set-request-url-template)
- [Set query string parameters
  设置查询字符串参数](https://cookbook.nodered.org/http/set-query-string)
- [Get a parsed JSON response
  获取解析后的JSON响应](https://cookbook.nodered.org/http/parse-json-response)
- [Get a binary response 得到二进制响应](https://cookbook.nodered.org/http/get-binary-response)
- [Set a request header 设置请求标头](https://cookbook.nodered.org/http/set-request-header)

#### MQTT

- [Connect to an MQTT broker
  连接到MQTT代理](https://cookbook.nodered.org/mqtt/connect-to-broker)
- [Publish messages to a topic
  将消息发布到主题](https://cookbook.nodered.org/mqtt/publish-to-topic)
- [Set the topic of a published message
  设置已发布消息的主题](https://cookbook.nodered.org/mqtt/set-publish-topic)
- [Publish a retained message to a topic
  将保留的消息发布到主题](https://cookbook.nodered.org/mqtt/publish-retained-message)
- [Subscribe to a topic 订阅主题](https://cookbook.nodered.org/mqtt/subscribe-to-topic)
- [Receive a parsed JSON message
  接收解析后的JSON消息](https://cookbook.nodered.org/mqtt/receive-json)