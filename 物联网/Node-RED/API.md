# API Reference API参考

#### Runtime APIs 运行时间api

- [Admin HTTP API 管理HTTP API](https://nodered.org/docs/api/admin)

  This HTTP-based API can be used to remotely administer the runtime. It is used by the Node-RED Editor and command-line admin tool.
  这个基于HTTP的API可用于远程管理运行时。它由Node-RED编辑器和命令行管理工具使用。

- [Hooks 钩](https://nodered.org/docs/api/hooks)

  The Hooks API provides a way to insert custom code into certain key points of the runtime operation.
  Hooks API提供了一种将自定义代码插入到运行时操作的某些关键点的方法。

- [Storage 存储](https://nodered.org/docs/api/storage)

  This API provides a pluggable way to configure where the Node-RED runtime stores data.
  此API提供了一种可插拔的方式来配置Node-RED运行时存储数据的位置。

- [Logging 测井](https://nodered.org/docs/user-guide/runtime/logging)

  A custom logger can be used to send log events to alternative locations, such as a database.
  自定义记录器可用于将日志事件发送到其他位置，如数据库。

- [Context Store 语境贮存](https://nodered.org/docs/api/context)

  This API provides a pluggable way to store context data outside of the runtime.
  这个API提供了一种可插入的方式来将上下文数据存储在运行时之外。

- [Library Store 程序库商店](https://nodered.org/docs/api/library)

  This API provides a pluggable way to add additional libraries to the Node-RED Import/Export dialog.
  该API提供了一种可插入的方式，可以将其他库添加到Node-RED导入/导出对话框中。

#### [Editor APIs 编辑器API](https://nodered.org/docs/api/ui)

The APIs available in the editor for nodes and plugins to use. This includes a set set of standard UI widgets that can be used within a node’s edit template.
编辑器中可供节点和插件使用的API。这包括一组可以在节点的编辑模板中使用的标准UI小部件。

#### [Module APIs 模块API](https://nodered.org/docs/api/modules)

The APIs provided by npm modules that Node-RED is built from. These can be used to embed Node-RED into existing Node.js applications.
Node-RED构建的npm模块提供的API。这些可以用于将Node-RED嵌入到现有的Node.js应用程序中。