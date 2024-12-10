# The Core Nodes 核心节点

The Node-RED palette includes a default set of nodes that are the basic building blocks for creating flows. This page highlights the core set you should know about.
Node-RED调色板包括一组默认的节点，它们是创建流的基本构建块。本页重点介绍了您应该了解的核心集合。

All nodes include documentation you can see in the Info sidebar tab when you select a node.
所有节点都包含文档，您可以在选择节点时在“信息”侧边栏选项卡中看到这些文档。

- [Inject 注入](https://nodered.org/docs/user-guide/nodes#inject)
- [Debug 调试](https://nodered.org/docs/user-guide/nodes#debug)
- [Function 功能](https://nodered.org/docs/user-guide/nodes#function)
- [Change 变化](https://nodered.org/docs/user-guide/nodes#change)
- [Switch 开关](https://nodered.org/docs/user-guide/nodes#switch)
- [Template 模板](https://nodered.org/docs/user-guide/nodes#template)

------

![Inject node](https://nodered.org/docs/user-guide/images/node_inject.png)

### Inject 注入

The Inject node can be used to manual trigger a flow by clicking the node’s button within the editor. It can also be used to automatically trigger flows at regular intervals.
通过单击编辑器中的节点按钮，Inject节点可用于手动触发流。它还可以用于定期自动触发流。

The message sent by the Inject node can have its `payload` and `topic` properties set.
Inject节点发送的消息可以设置其`有效负载`和`主题`属性。

The `payload` can be set to a variety of different types:
有效`负载`可以设置为各种不同的类型：

- a flow or global context property value
  流或全局上下文属性值
- a String, number, boolean, Buffer or Object
  a String、number、boolean、Buffer或Object
- a Timestamp in milliseconds since January 1st, 1970
  a自1970年1月1日以来的时间戳（毫秒）

The `interval` can be set up to a maximum of 596 hours (approximately 24 days). If you are looking at intervals greater than one day - consider using a  scheduler node that can cope with power outages and restarts.
`间隔`最长可设置为596小时（约24天）。如果您正在寻找大于一天的时间间隔-考虑使用可以科普断电和重新启动的调度程序节点。

The `interval between times` and `at a specific time` options use the standard cron system. This means that 20 minutes will  be at the next hour, 20 minutes past and 40 minutes past - not in 20  minutes time. If you want every 20 minutes from now - use the `interval` option.
时间`间隔`和`特定时间`选项使用标准cron系统。这意味着20分钟将在下一个小时，20分钟过去和40分钟过去-而不是在20分钟的时间。如果你想从现在开始每20分钟-使用`间隔`选项。

*Since Node-RED 1.1.0*, the Inject node can now set any property on the message.
*从Node-RED 1.1.0开始*，Inject节点现在可以设置消息上的任何属性。

------

![Debug node](https://nodered.org/docs/user-guide/images/node_debug.png)

### Debug 调试

The Debug node can be used to display messages in the Debug sidebar within the editor.
可以使用编辑器中的编辑器工具条来显示消息。

The sidebar provides a structured view of the messages it is sent, making it easier to explore the message.
侧边栏提供了它所发送的消息的结构化视图，使其更容易浏览消息。

Alongside each message, the debug sidebar includes information about the time the message was received and which Debug node sent it. Clicking on the source node id will reveal that node within the workspace.
在每条消息旁边，调试侧边栏包括有关消息接收时间和哪个源节点发送消息的信息。单击源节点ID将显示工作区中的该节点。

The button on the node can be used to enable or disable its output. It is recommended to disable or remove any Debug nodes that are not being used.
节点上的按钮可用于启用或禁用其输出。建议禁用或删除任何未使用的Kerberos节点。

The node can also be configured to send all messages to the runtime log, or to send short (32 characters) to the status text under the debug node.
该节点还可以配置为将所有消息发送到运行时日志，或发送简短（32个字符）到调试节点下的状态文本。

The page on [Working with messages](https://nodered.org/docs/user-guide/messages) gives more information about using the Debug sidebar.
[使用](https://nodered.org/docs/user-guide/messages)消息页面提供了有关使用消息侧边栏的更多信息。

------

![Function node](https://nodered.org/docs/user-guide/images/node_function.png)

### Function 功能

The Function node allows JavaScript code to be run against the messages that are passed through it.
Function节点允许针对通过它传递的消息运行JavaScript代码。

A complete guide for using the Function node is available [here](https://nodered.org/docs/user-guide/writing-functions).
[此处](https://nodered.org/docs/user-guide/writing-functions)提供了使用Function节点的完整指南。

------

![Change node](https://nodered.org/docs/user-guide/images/node_change.png)

### Change 变化

The Change node can be used to modify a message’s properties and set context properties without having to resort to a Function node.
Change节点可用于修改消息的属性和设置上下文属性，而不必求助于Function节点。

Each node can be configured with multiple operations that are applied in order. The available operations are:
每个节点都可以配置多个按顺序应用的操作。可用的操作包括：

- **Set** - set a property. The value can be a variety of different types, or can be taken from an existing message or context property.
  **Set**-设置属性。该值可以是各种不同的类型，也可以从现有消息或上下文属性中获取。
- **Change** - search and replace parts of a message property.
  **更改**-搜索和替换消息属性的部分内容。
- **Move** - move or rename a property.
  **移动**-移动或重命名属性。
- **Delete** - delete a property.
  **删除**-删除属性。

When setting a property, the value can also be the result of a [JSONata expression](https://jsonata.org). JSONata is a declarative query and transformation language for JSON data.
在设置属性时，值也可以是[JSONata表达式](https://jsonata.org)的结果。JSONata是JSON数据的声明性查询和转换语言。

------

![Switch node](https://nodered.org/docs/user-guide/images/node_switch.png)

### Switch 开关

The Switch node allows messages to be routed to different branches of a flow by evaluating a set of rules against each message.
Switch节点允许通过对每个消息评估一组规则来将消息路由到流的不同分支。

The name "switch" comes from the "switch statement" that is common to many programming languages. It is not a reference to a physical switch
“switch”这个名字来自于许多编程语言中常见的“switch语句”。它不是对物理交换机的引用

The node is configured with the property to test - which can be either a message property or a context property.
节点配置有要测试的属性-可以是消息属性或上下文属性。

There are four types of rule:
规则有四种类型：

- **Value** rules are evaluated against the configured property
  **值**规则根据配置的属性进行评估
- **Sequence** rules can be used on message sequences, such as those generated by the Split node
  **序列**规则可用于消息序列，例如由拆分节点生成的消息序列
- A JSONata **Expression** can be provided that will be evaluated against the whole message and will match if the expression returns a `true` value.
  可以提供一个JSONata**表达式**，它将针对整个消息进行评估，如果表达式返回`true`值，则将匹配。
- An **Otherwise** rule can be used to match if none of the preceding rules have matched.
  如果前面的规则都不匹配，则可以使用**Otherwise**规则进行匹配。

The node will route a message to all outputs corresponding to matching rules. But it can also be configured to stop evaluating rules when it finds one that matches.
该节点将消息路由到与匹配规则对应的所有输出。但它也可以配置为在找到匹配的规则时停止评估规则。

------

![Template node](https://nodered.org/docs/user-guide/images/node_template.png)

### Template 模板

The Template node can be used to generate text using a message’s properties to fill out a template.
模板节点可用于使用消息的属性生成文本，以填写模板。

It uses the [Mustache](https://mustache.github.io/mustache.5.html) templating language to generate the result.
它使用[Mustache](https://mustache.github.io/mustache.5.html)模板语言来生成结果。

For example, a template of:
例如，以下模板：

```
This is the payload: {{payload}} !
```

Will replace `{{payload}}` with the value of the message’s `payload` property.
将`{{payload}}`替换为消息的`payload`属性的值。

By default, Mustache will replace certain characters with their HTML escape codes. To stop that happening, you can use triple braces: `{{{payload}}}`.
默认情况下，Mustache将用HTML转义码替换某些字符。为了防止这种情况发生，您可以使用三个大括号：`{{{payload}}}`。

Mustache supports simple loops on lists. For example, if `msg.payload` contains an array of names, such as: `["Nick", "Dave", "Claire"]`, the following template will create an HTML list of the names:
Mustache支持列表上的简单循环。例如，如果`msg.payload`包含一个名称数组，例如：`[“Nick”，“Dave”，“Claire”]`，下面的模板将创建一个名称的HTML列表：

```
<ul>
{{#payload}}
  <li>{{.}}</li>
{{/payload}}
</ul>
<ul>
  <li>Nick</li>
  <li>Dave</li>
  <li>Claire</li>
</ul>
```

The node will set the configured message or context property with the result of the template. If the template generates valid JSON or YAML content, it can be configured to parse the result to the corresponding JavaScript Object.
节点将使用模板的结果设置配置的消息或上下文属性。如果模板生成有效的JSON或YAML内容，则可以将其配置为将结果解析为相应的JavaScript Object。

# Adding nodes to the palette 将节点添加到选项板

Node-RED comes with a core set of useful nodes, but there are many more available from both the Node-RED project as well as the wider community.
Node-RED附带了一组有用的核心节点，但Node-RED项目和更广泛的社区还有更多可用的节点。

You can search for available nodes in the [Node-RED library](http://flows.nodered.org).
您可以在[Node-RED库](http://flows.nodered.org)中搜索可用节点。

### Using the Editor 使用编辑器

You can install nodes directly within the editor by selecting the `Manage Palette` option from the main menu to open the [Palette Manager](https://nodered.org/docs/user-guide/editor/palette/manager).
您可以通过选择`管理节点`直接在编辑器中安装节点 从主菜单中选择“”选项，以打开[浏览器管理器](https://nodered.org/docs/user-guide/editor/palette/manager)。

The ‘Nodes’ tab lists all of the modules you have installed. It shows which you are using and whether updates are available for any of them.
“节点”选项卡列出了您已安装的所有模块。它会显示您正在使用的内容以及其中任何内容是否有更新。

The ‘Install’ tab lets you search the catalogue of available node modules and install them.
“安装”选项卡允许您搜索可用节点模块的目录并安装它们。

### Installing with npm 使用npm安装

To install a node module from the command-line, you can use the following command from within your user data directory (by default, `$HOME/.node-red`):
要从命令行安装节点模块，您可以在用户数据目录中使用以下命令（默认情况下，`$HOME/.node-red`）：

```
npm install <npm-package-name>
```

You will then need to restart Node-RED for it to pick-up the new nodes.
然后，您将需要重新启动Node-RED以获取新节点。

### The package.json file package.json文件

When first started, or a new project created, Node-RED will create an initial `package.json` file in your user directory, or project directory. This allows you to  manage your additional dependencies, and release versions of your  project, using standard npm practices. The initial version is 0.0.1 but  should be edited according to your project release requirements.
当第一次启动或创建新项目时，Node-RED将在用户目录或项目目录中创建初始`package.json`文件。这允许您使用标准的npm实践来管理您的附加依赖项，并发布项目的版本。初始版本为0.0.1，但应根据项目发布要求进行编辑。

`npm` will automatically add additional installed modules to the dependencies section of the `package.json` file in your user directory.
`npm`会自动将额外安装的模块添加到用户目录中`package.json`文件的dependencies部分。

### Upgrading nodes 升级节点

The easiest way to check for node updates is to open the [Palette Manager](https://nodered.org/docs/user-guide/editor/palette/manager) in the editor. You can then apply those updates as needed.
检查节点更新的最简单方法是在编辑器中打开[节点管理器](https://nodered.org/docs/user-guide/editor/palette/manager)。然后，您可以根据需要应用这些更新。

You can also check for updates from the command-line using `npm`. In your user directory, `~/.node-red` run the command:
您也可以使用`npm`从命令行检查更新。在你的用户目录中，`~/.node-red`运行命令：

```
npm outdated
```

That will highlight any modules that have updates available. To install the latest version of any module, run the command:
这将突出显示有可用更新的任何模块。要安装任何模块的最新版本，请运行以下命令：

```
npm install <name-of-module>@latest
```

Whichever approach you take, you will need to restart Node-RED to load the updates.
无论采用哪种方法，您都需要重新启动Node-RED以加载更新。

*Note* : the reason for using the `--unsafe-perm` option is that when node-gyp tries to recompile any native libraries it tries to do so as a "nobody" user and then fails to get access to certain directories. This causes the nodes in question (for example, serialport) not to be installed. Allowing it root access during install allows the nodes to be installed correctly during the upgrade.
*注*：使用 `--unsafe-perm`选项的另一个缺点是，当node-gyp试图重新编译任何本机库时，它会尝试以“nobody”用户的身份这样做，然后无法访问某些目录。这将导致不安装有问题的节点（例如serialport）。在安装过程中允许它进行root访问，可以在升级过程中正确安装节点。

# Creating Nodes 创建节点

The main way Node-RED can be extended is to add new nodes into its palette.
Node-RED扩展的主要方式是在其调色板中添加新节点。

Nodes can be published as npm modules to the [public npm repository](https://www.npmjs.com/) and added to the [Node-RED Flow Library](https://flows.nodered.org) to make them available to the community.
节点可以作为npm模块发布到[公共npm存储库](https://www.npmjs.com/) 并添加到[Node-RED流库](https://flows.nodered.org)中，使其可供社区使用。

- [Creating your first node 创建第一个节点](https://nodered.org/docs/creating-nodes/first-node)
- [JavaScript File JavaScript文件](https://nodered.org/docs/creating-nodes/node-js)
- [HTML File HTML文件](https://nodered.org/docs/creating-nodes/node-html)
- [Packaging 包装](https://nodered.org/docs/creating-nodes/packaging)
- [Node properties 节点属性](https://nodered.org/docs/creating-nodes/properties)
- [Node credentials 节点凭据](https://nodered.org/docs/creating-nodes/credentials)
- [Node appearance 节点外观](https://nodered.org/docs/creating-nodes/appearance)
- [Node edit dialog 节点编辑对话框](https://nodered.org/docs/creating-nodes/edit-dialog)
- [Storing context 存储上下文](https://nodered.org/docs/creating-nodes/context)
- [Node status 节点状态](https://nodered.org/docs/creating-nodes/status)
- [Configuration nodes 配置节点](https://nodered.org/docs/creating-nodes/config-nodes)
- [Help style guide 帮助风格指南](https://nodered.org/docs/creating-nodes/help-style-guide)
- [Adding examples 添加示例](https://nodered.org/docs/creating-nodes/examples)
- [Internationalisation 国际化](https://nodered.org/docs/creating-nodes/i18n)

*Since Node-RED 1.3 自Node-RED 1.3起*

- [Loading extra resources in the editor
  在编辑器中加载额外的资源](https://nodered.org/docs/creating-nodes/resources)
- [Packaging a Subflow as a module
  将子流打包为模块](https://nodered.org/docs/creating-nodes/subflow-modules)

### General guidance 一般指导

There are some general principles to follow when creating new nodes. These reflect the approach taken by the core nodes and help provided a consistent user-experience.
在创建新节点时，需要遵循一些一般原则。这些反映了核心节点所采取的方法，并有助于提供一致的用户体验。

Nodes should: 节点应：

- **be well-defined in their purpose.
  明确自己的目的。**

  A node that exposes every possible option of an API is potentially less useful that a group of nodes that each serve a single purpose.
  公开API的每个可能选项的节点可能不如一组各自服务于单一目的的节点有用。

- **be simple to use, regardless of the underlying functionality.
  简单易用，无论底层功能如何。**

  Hide complexity and avoid the use of jargon or domain-specific knowledge.
  隐藏复杂性，避免使用行话或特定领域的知识。

- **be forgiving in what types of message properties it accepts.
  在它接受的消息属性类型上是宽容的。**

  Message properties can be strings, numbers, booleans, Buffers, objects, arrays or nulls. A node should do The Right Thing when faced with any of these.
  消息属性可以是字符串、数字、布尔值、缓冲区、对象、数组或空值。一个节点应该做正确的事情时，面对任何这些。

- **be consistent in what they send.
  他们发送的内容要一致。**

  Nodes should document what properties they add to messages, and they should be consistent and predictable in their behaviour.
  节点应该记录它们添加到消息中的属性，并且它们的行为应该是一致的和可预测的。

- **sit at the beginning, middle or end of a flow - not all at once.
  位于流的开始、中间或结束处--而不是一次全部。**

- **catch errors. 捕获错误。**

  If a node throws an uncaught error, Node-RED will stop the entire flow as the state of the system is no longer known.
  如果一个节点抛出一个未捕获的错误，Node-RED将停止整个流，因为系统的状态不再是已知的。

  Wherever possible, nodes must catch errors or register error handlers for any asynchronous calls they make.
  只要有可能，节点必须捕获错误或为它们进行的任何异步调用注册错误处理程序。

# Creating your first node 创建第一个节点

Nodes get created when a flow is deployed, they may send and receive some messages whilst the flow is running and they get deleted when the next flow is deployed.
节点在部署流时被创建，它们可以在流运行时发送和接收一些消息，并且在部署下一个流时被删除。

They consist of a pair of files:
它们由一对文件组成：

- a JavaScript file that defines what the node does,
  一个定义节点功能的JavaScript文件，
- an html file that defines the node’s properties, edit dialog and help text.
  一个html文件，定义了节点的属性，编辑对话框和帮助文本。

A `package.json` file is used to package it all together as an npm module.
使用`package.json`文件将其打包为npm模块。

- Creating a simple node 创建简单节点
  - [package.json](https://nodered.org/docs/creating-nodes/first-node#package-json)
  - [lower-case.js](https://nodered.org/docs/creating-nodes/first-node#lower-casejs)
  - [lower-case.html](https://nodered.org/docs/creating-nodes/first-node#lower-casehtml)
- [Testing your node in Node-RED
  在Node-RED中测试您的节点](https://nodered.org/docs/creating-nodes/first-node#testing-your-node-in-node-red)

### Creating a simple node 创建简单节点

This example will show how to create a node that converts message payloads to all lower-case characters.
这个例子将展示如何创建一个节点，将消息有效负载转换为所有小写字符。

Ensure you have the current LTS version of Node.js installed on your system. At the time of writing this is 10.x.
确保您的系统上安装了当前LTS版本的Node.js。在写这篇文章的时候，它是10.x。

Create a directory where you will develop your code. Within that directory, create the following files:
创建一个目录，您将在其中开发代码。在该目录中，创建以下文件：

- `package.json`
- `lower-case.js`
- `lower-case.html`

####  package.json

This is a standard file used by Node.js modules to describe their contents.
这是Node.js模块用来描述其内容的标准文件。

To generate a standard `package.json` file you can use the command `npm init`. This will ask a series of questions to help create the initial content for the file, using sensible defaults where it can. When prompted, give it the name `node-red-contrib-example-lower-case`.
要生成标准`的package.json`文件，可以使用命令`npm init`。 这将提出一系列问题，以帮助创建 文件，在可能的情况下使用合理的默认值。出现提示时，将其命名为 `node-red-contrib-example-lower-case` .

Once generated, you must add a `node-red` section:
生成后，您必须添加一个`node-red`部分：

```
{
    "name" : "node-red-contrib-example-lower-case",
    ...
    "node-red" : {
        "nodes": {
            "lower-case": "lower-case.js"
        }
    }
}
```

This tells the runtime what node files the module contains.
这告诉运行时模块包含哪些节点文件。

For more information about how to package your node, including requirements on naming and other properties that should be set before publishing your node, refer to the [packaging guide](https://nodered.org/docs/creating-nodes/packaging).
有关如何打包节点的详细信息（包括在发布节点之前应设置的命名要求和其他属性），请参阅[打包指南](https://nodered.org/docs/creating-nodes/packaging)。

**Note**: Please do ***not\*** publish this example node to npm!
**注意**：请***不要\***将此示例节点发布到npm！

####  lower-case.js

```
module.exports = function(RED) {
    function LowerCaseNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.on('input', function(msg) {
            msg.payload = msg.payload.toLowerCase();
            node.send(msg);
        });
    }
    RED.nodes.registerType("lower-case",LowerCaseNode);
}
```

The node is wrapped as a Node.js module. The module exports a function that gets called when the runtime loads the node on start-up. The function is called with a single argument, `RED`, that provides the module access to the Node-RED runtime api.
节点被包装为Node.js模块。该模块导出一个函数，当运行库在启动时加载节点时调用该函数。使用单个参数`RED`调用该函数，该参数为模块提供对Node-RED运行时API的访问。

The node itself is defined by a function, `LowerCaseNode` that gets called whenever a new instance of the node is created. It is passed an object containing the node-specific properties set in the flow editor.
节点本身由一个函数`LowerCaseNode`定义，每当创建节点的新实例时都会调用该函数。它被传递一个对象，该对象包含在流编辑器中设置的节点特定属性。

The function calls the `RED.nodes.createNode` function to initialize the features shared by all nodes. After that, the node-specific code lives.
该函数调用`RED.nodes. nodeNode`函数来初始化所有节点共享的功能。在此之后，特定于节点的代码将继续存在。

In this instance, the node registers a listener to the `input` event which gets called whenever a message arrives at the node. Within this listener, it changes the payload to lower case, then calls the `send` function to pass the message on in the flow.
在这个实例中，节点注册了一个`输入`事件的侦听器，每当消息到达节点时就会调用该侦听器。在这个侦听器中，它将有效负载更改为小写，然后调用`send`函数在流中传递消息。

Finally, the `LowerCaseNode` function is registered with the runtime using the name for the node, `lower-case`.
最后，`LowerCaseNode`函数使用节点的名称（`小写）`向运行时注册。

If the node has any external module dependencies, they must be included in the `dependencies` section of its `package.json` file.
如果节点具有任何外部模块依赖项，则必须将它们包含在`依赖项`中 它`的package.json`文件。

For more information about the runtime part of the node, see [here](https://nodered.org/docs/creating-nodes/node-js).
有关节点的运行时部分的更多信息，请参见[此处](https://nodered.org/docs/creating-nodes/node-js)。

####  lower-case.html

```
<script type="text/javascript">
    RED.nodes.registerType('lower-case',{
        category: 'function',
        color: '#a6bbcf',
        defaults: {
            name: {value:""}
        },
        inputs: 1,
        outputs: 1,
        icon: "file.svg",
        label: function() {
            return this.name||"lower-case";
        }
    });
</script>

<script type="text/html" data-template-name="lower-case">
    <div class="form-row">
        <label for="node-input-name"><i class="fa fa-tag"></i> Name</label>
        <input type="text" id="node-input-name" placeholder="Name">
    </div>
</script>

<script type="text/html" data-help-name="lower-case">
    <p>A simple node that converts the message payloads into all lower-case characters</p>
</script>
```

A node’s HTML file provides the following things:
节点的HTML文件提供以下内容：

- the main node definition that is registered with the editor
  向编辑器注册的主节点定义
- the edit template 编辑模板
- the help text 帮助文本

In this example, the node has a single editable property, `name`. Whilst not required, there is a widely used convention to this property to help distinguish between multiple instances of a node in a single flow.
在本例中，节点只有一个可编辑属性`name`。虽然不是必需的，但这个属性有一个广泛使用的约定，可以帮助区分单个流中节点的多个实例。

For more information about the editor part of the node, see [here](https://nodered.org/docs/creating-nodes/node-html).
有关节点的编辑器部分的更多信息，请参见[此处](https://nodered.org/docs/creating-nodes/node-html)。

### Testing your node in Node-RED 在Node-RED中测试您的节点

Once you have created a basic node module as described above, you can install it into your Node-RED runtime.
创建了上述基本节点模块后，可以将其安装到Node-RED运行时中。

To test a node module locally the [`npm install `](https://docs.npmjs.com/cli/install) command can be used. This allows you to develop the node in a local directory and have it linked into a local node-red install during development.
要在本地测试节点模块，请安装[`npm `](https://docs.npmjs.com/cli/install) 命令可以使用。这允许您在本地目录中开发节点， 在开发过程中将其链接到本地node-red安装。

In your node-red user directory, typically `~/.node-red`, run:
在你的node-red用户目录中，通常是`~/.node-red`，运行：

```
npm install <location of node module>
```

For example, on Mac OS or Linux, if your node is located at `~/dev/node-red-contrib-example-lower-case` you would do the following:
例如，在Mac OS或Linux上，如果您的节点位于 `~/dev/node-red-contrib-example-lower-case` ，则应执行以下操作：

```
cd ~/.node-red
npm install ~/dev/node-red-contrib-example-lower-case
```

On Windows you would do:
在Windows上，您会执行以下操作：

```
cd C:\Users\my_name\.node_red
npm install C:\Users\my_name\Documents\GitHub\node-red-contrib-example-lower-case
```

This creates a symbolic link to your node module project directory in  `~/.node-red/node_modules` so that Node-RED will discover the node when it starts. Any changes to  the node’s file can be picked up by simply restarting Node-RED.  On  Windows, again, using npm 5.x or greater:
这将在`~/.node-red/node_modules`中创建一个指向节点模块项目目录的符号链接，以便Node-RED在启动时发现节点。对节点文件的任何更改都可以通过简单地重新启动Node-RED来获取。在Windows上，再次使用npm 5.x或更高版本：

*Note* :  `npm` will automatically add an entry for your module in the `package.json` file located in your user directory.  If you don't want it to do this, use the `--no-save` option to the `npm install` command. 
*注意*：`npm`会自动为你的模块添加一个条目， 位于用户目录中`的package.json`文件。如果你不想让它这样做，请在`npm安装`中使用`--no-save`选项 命令

### Unit Testing 单元测试

To support unit testing, an npm module called [`node-red-node-test-helper`](https://www.npmjs.com/package/node-red-node-test-helper) can be used.  The test-helper is a framework built on the Node-RED runtime to make it easier to test nodes.
为了支持单元测试，可以使用npm模块[`node-red-node-test-helper`](https://www.npmjs.com/package/node-red-node-test-helper)。test-helper是一个构建在Node-RED运行时上的框架，可以更轻松地测试节点。

Using this framework, you can create test flows, and then assert that your  node properties and output is working as expected.  For example, to add a unit test to the lower-case node you can add a `test` folder to your node module package containing a file called `_spec.js`
使用这个框架，您可以创建测试流，然后断言您的节点属性和输出按预期工作。例如，要将单元测试添加到小写节点，可以将`测试`文件夹添加到节点模块包中，其中包含名为`_spec.js`的文件

####  test/lower-case_spec.js

```
var helper = require("node-red-node-test-helper");
var lowerNode = require("../lower-case.js");

describe('lower-case Node', function () {

  afterEach(function () {
    helper.unload();
  });

  it('should be loaded', function (done) {
    var flow = [{ id: "n1", type: "lower-case", name: "test name" }];
    helper.load(lowerNode, flow, function () {
      var n1 = helper.getNode("n1");
      n1.should.have.property('name', 'test name');
      done();
    });
  });

  it('should make payload lower case', function (done) {
    var flow = [{ id: "n1", type: "lower-case", name: "test name",wires:[["n2"]] },
    { id: "n2", type: "helper" }];
    helper.load(lowerNode, flow, function () {
      var n2 = helper.getNode("n2");
      var n1 = helper.getNode("n1");
      n2.on("input", function (msg) {
        msg.should.have.property('payload', 'uppercase');
        done();
      });
      n1.receive({ payload: "UpperCase" });
    });
  });
});
```

These tests check to see that the node is loaded into the runtime correctly,  and that it correctly changes the payload to lower case as expected.
这些测试将检查节点是否正确加载到运行时中，以及它是否按预期将有效负载正确更改为小写。

Both tests load the node into the runtime using `helper.load` supplying the node under test and a test flow  The first checks that  the node in the runtime has the correct name property.  The second test  uses a helper node to check that the output from the node is, in fact,  lower case.
这两个测试都使用helper.load将节点加载到运行时`中，helper.load`提供了被测节点和一个测试流。第一个测试检查运行时中的节点是否具有正确的name属性。第二个测试使用一个helper节点来检查节点的输出实际上是小写的。

The helper module contains other examples of tests taken from the Node-RED  core nodes.  For more information on the helper module, see the  associated README.
helper模块包含从Node-RED核心节点获取的其他测试示例。有关helper模块的更多信息，请参见相关的README。

# JavaScript file JavaScript文件

The node `.js` file defines the runtime behavior of the node.
`js`文件定义节点的运行时行为。

- [Node constructor 节点构造器](https://nodered.org/docs/creating-nodes/node-js#node-constructor)
- [Receiving messages 接收消息](https://nodered.org/docs/creating-nodes/node-js#receiving-messages)
- Sending messages 发送消息
  - [Multiple outputs 多个输出](https://nodered.org/docs/creating-nodes/node-js#multiple-outputs)
  - [Multiple messages 多个消息](https://nodered.org/docs/creating-nodes/node-js#multiple-messages)
- Closing the node 关闭节点
  - [Timeout behaviour 抗氧化性能](https://nodered.org/docs/creating-nodes/node-js#timeout-behaviour)
- Logging events 日志记录事件
  - [Handling errors 处理错误](https://nodered.org/docs/creating-nodes/node-js#handling-errors)
- [Setting status 设置状态](https://nodered.org/docs/creating-nodes/node-js#setting-status)
- [Custom node settings 自定义节点设置](https://nodered.org/docs/creating-nodes/node-js#custom-node-settings)

### Node constructor 节点构造器

Nodes are defined by a constructor function that can be used to create new instances of the node. The function gets registered with the runtime so it can be called when nodes of the corresponding type are deployed in a flow.
节点由构造函数定义，该函数可用于创建节点的新实例。该函数向运行时注册，以便在流中部署相应类型的节点时可以调用该函数。

The function is passed an object containing the properties set in the flow editor.
该函数被传递一个包含流编辑器中设置的属性的对象。

The first thing it must do is call the `RED.nodes.createNode` function to initialize the features shared by all nodes. After that, the node-specific code lives.
它必须做的第一件事是调用`RED.nodes. nodes Node`函数来初始化所有节点共享的特性。在此之后，特定于节点的代码将继续存在。

```
function SampleNode(config) {
    RED.nodes.createNode(this,config);
    // node-specific code goes here

}

RED.nodes.registerType("sample",SampleNode);
```

### Receiving messages 接收消息

Nodes register a listener on the `input` event to receive messages from the up-stream nodes in a flow.
节点在`输入`事件上注册一个侦听器，以接收来自流中上游节点的消息。

With Node-RED 1.0, a new style of the listener was introduced to allow the node to notify the runtime when it has finished handling a message. This added two new parameters to the listener function. Some care is needed to ensure the node can still be installed in Node-RED 0.x which does not use this new style of the listener.
在Node-RED 1.0中，引入了一种新的侦听器样式，允许节点在完成处理消息时通知运行时。这为listener函数添加了两个新参数。需要注意确保节点仍然可以安装在Node-RED 0.x中，因为Node-RED 0.x不使用这种新样式的侦听器。

```
this.on('input', function(msg, send, done) {
    // do something with 'msg'

    // Once finished, call 'done'.
    // This call is wrapped in a check that 'done' exists
    // so the node will work in earlier versions of Node-RED (<1.0)
    if (done) {
        done();
    }
});
```

#### Handling errors 处理错误

If the node encounters an error whilst handling the message, it should pass the details of the error to the `done` function.
如果节点在处理消息时遇到错误，它应该将错误的详细信息传递给`done`函数。

This will trigger any Catch nodes present on the same tab, allowing the user to build flows to handle the error.
这将触发同一选项卡上的任何Catch节点，允许用户构建流来处理错误。

Again, some care is needed in the case the node is installed in Node-RED 0.x which does not provide the `done` function. In that case, it should use `node.error`:
同样，如果该节点安装在不提供`done`函数的Node-RED 0.x中，则需要格外小心。在这种情况下，它应该使用`node.error`：

```
let node = this;
this.on('input', function(msg, send, done) {
    // do something with 'msg'

    // If an error is hit, report it to the runtime
    if (err) {
        if (done) {
            // Node-RED 1.0 compatible
            done(err);
        } else {
            // Node-RED 0.x compatible
            node.error(err, msg);
        }
    }
});
```

### Sending messages 发送消息

If the node sits at the start of the flow and produces messages in response to external events, it should use the `send` function on the Node object:
如果节点位于流的开始并生成消息来响应外部事件，则它应该使用Node对象上的`send`函数：

```
var msg = { payload:"hi" }
this.send(msg);
```

If the node wants to send from inside the `input` event listener, in response to receiving a message, it should use the `send` function that is passed to the listener function:
如果节点想要从`输入`事件侦听器内部发送，响应于接收到消息，它应该使用传递给侦听器函数的`send`函数：

```
let node = this;
this.on('input', function(msg, send, done) {
    // For maximum backwards compatibility, check that send exists.
    // If this node is installed in Node-RED 0.x, it will need to
    // fallback to using `node.send`
    send = send || function() { node.send.apply(node,arguments) }

    msg.payload = "hi";
    send(msg);

    if (done) {
        done();
    }
});
```

If `msg` is null, no message is sent.
如果`msg`为null，则不发送任何消息。

If the node is sending a message in response to having received one, it should reuse the received message rather than create a new message object. This ensures existing properties on the message are preserved for the rest of the flow.
如果节点正在发送消息以响应已接收的消息，则它应该重用已接收的消息，而不是创建新的消息对象。这确保了消息上的现有属性在流的其余部分中得到保留。

#### Multiple outputs 多个输出

If the node has more than one output, an array of messages can be passed to `send`, with each one being sent to the corresponding output.
如果节点有多个输出，可以传递一个消息数组来`发送`，每个消息都被发送到相应的输出。

```
this.send([ msg1 , msg2 ]);
```

#### Multiple messages 多个消息

It is possible to send multiple messages to a particular output by passing an array of messages within this array:
可以通过在此数组中传递一个消息数组来向特定输出发送多个消息：

```
this.send([ [msgA1 , msgA2 , msgA3] , msg2 ]);
```

### Closing the node 关闭节点

Whenever a new flow is deployed, the existing nodes are deleted. If any of them need to tidy up state when this happens, such as disconnecting from a remote system, they should register a listener on the `close` event.
每当部署一个新的流时，现有的节点都会被删除。如果它们中的任何一个在这种情况下需要整理状态，比如从远程系统断开连接，它们应该在`close`事件上注册一个侦听器。

```
this.on('close', function() {
    // tidy up any state
});
```

If the node needs to do any asynchronous work to complete the tidy up, the registered listener should accept an argument which is a function to be called when all the work is complete.
如果节点需要执行任何异步工作来完成整理，则注册的侦听器应该接受一个参数，该参数是所有工作完成时要调用的函数。

```
this.on('close', function(done) {
    doSomethingWithACallback(function() {
        done();
    });
});
```

*Since Node-RED 0.17 自Node-RED 0.17起*

If the registered listener accepts two arguments, the first will be a boolean flag that indicates whether the node is being closed because it has been removed entirely, or that it is just being restarted. It will also be set to *true* if the node has been disabled.
如果已注册的侦听器接受两个参数，第一个参数将是一个布尔标志，指示节点是因为被完全删除而关闭，还是只是重新启动。如果节点已被禁用，它也将被设置为*true*。

```
this.on('close', function(removed, done) {
    if (removed) {
        // This node has been disabled/deleted
    } else {
        // This node is being restarted
    }
    done();
});
```

#### Timeout behaviour 抗氧化性能

*Since Node-RED 0.17 自Node-RED 0.17起*

Prior to Node-RED 0.17, the runtime would wait indefinitely for the `done` function to be called. This would cause the runtime to hang if a node failed to call it.
在Node-RED 0.17之前，运行时将无限期地等待调用`done`函数。如果节点调用运行库失败，这将导致运行库挂起。

In 0.17 and later, the runtime will timeout the node if it takes longer than 15 seconds. An error will be logged and the runtime will continue to operate.
在0.17及更高版本中，如果节点超时时间超过15秒，运行时将使节点超时。将记录错误，并且运行时将继续运行。

### Logging events 日志记录事件

If a node needs to log something to the console, it can use one of the following functions:
如果节点需要将某些内容记录到控制台，则可以使用以下函数之一：

```
this.log("Something happened");
this.warn("Something happened you should know about");
this.error("Oh no, something bad happened");

// Since Node-RED 0.17
this.trace("Log some internal detail not needed for normal operation");
this.debug("Log something more details for debugging the node's behaviour");
```

The `warn` and `error` messages also get sent to the flow editor debug tab.
`警告`和`错误`消息也会发送到流编辑器的调试选项卡。

### Setting status 设置状态

Whilst running, a node is able to share status information with the editor UI. This is done by calling the `status` function:
在运行时，节点能够与编辑器UI共享状态信息。这是通过调用`status`函数来实现的：

```
this.status({fill:"red",shape:"ring",text:"disconnected"});
```

The details of the status api can be found [here](https://nodered.org/docs/creating-nodes/status).
状态API的详细信息可以在[这里](https://nodered.org/docs/creating-nodes/status)找到。

### Custom node settings 自定义节点设置

A node may want to expose configuration options in a user’s `settings.js` file.
节点可能希望在用户的`settings.js`文件中公开配置选项。

The name of any setting must follow the following requirements:
任何设置的名称必须符合以下要求：

- the name must be prefixed with the corresponding node type.
  名称必须以相应的节点类型作为前缀。
- the setting must use camel-case - see below for more information.
  该设置必须使用camel-case -参见下面的更多信息。
- the node must not require the user to have set it - it should have a sensible default.
  节点不需要用户设置它它应该有一个合理的默认值。

For example, if the node type `sample-node` wanted to expose a setting called `colour`, the setting name should be `sampleNodeColour`.
例如，如果节点类型`sample-node`希望公开一个名为 `颜色`，设置名称应该是`sampleNodeColour`。

Within the runtime, the node can then reference the setting as `RED.settings.sampleNodeColour`.
在运行时内，节点然后可以将该设置引用为 `RED.settings.sampleNodeColour`.

#### Exposing settings to the editor 向编辑器公开设置

*Since Node-RED 0.17 自Node-RED 0.17起*

In some circumstances, a node may want to expose the value of the setting to the editor. If so, the node must register the setting as part of its call to `registerType`:
在某些情况下，节点可能希望向编辑器公开设置的值。如果是这样，节点必须将设置注册为其对`registerType`的调用的一部分：

```
RED.nodes.registerType("sample",SampleNode, {
    settings: {
        sampleNodeColour: {
            value: "red",
            exportable: true
        }
    }
});
```

- `value` field specifies the default value the setting should take.
  `value`字段指定设置应采用的默认值。
- `exportable` tells the runtime to make the setting available to the editor.
  `exportable`告诉运行库使编辑器可以使用该设置。

As with the runtime, the node can then reference the setting as `RED.settings.sampleNodeColour` within the editor.
与运行时一样，节点可以将设置引用为 编辑器中的`RED.settings.sampleNodeColour`。

If a node attempts to register a setting that does not meet the naming requirements an error will be logged.
如果节点尝试注册不符合命名要求的设置，则将记录错误。

# HTML File HTML文件

The node `.html` file defines how the node appears with the editor. It contains three distinct part, each wrapped in its own `<script>` tag:
`html`文件定义了节点在编辑器中的显示方式。它包含三个不同的部分，每个部分都包装在自己的`<script>`标记中：

1. the main node definition that is registered with the editor. This defines things such as the palette category, the editable properties (`defaults`) and what icon to use. It is within a regular javascript script tag
   在编辑器中注册的主节点定义。这定义了诸如调色板类别、可编辑属性（`默认值`）和要使用的图标。它位于一个常规的JavaScript脚本标记中
2. the edit template that defines the content of the edit dialog for the node. It is defined in a script of type `text/html` with `data-template-name` set to the [type of the node](https://nodered.org/docs/creating-nodes/node-html#node-type).
   定义节点的编辑对话框内容的编辑模板。它在`text/html`类型的脚本中定义，`data-template-name`设置为[节点的类型](https://nodered.org/docs/creating-nodes/node-html#node-type)。
3. the help text that gets displayed in the Info sidebar tab. It is defined in a script of type `text/html` with `data-help-name` set to the [type of the node](https://nodered.org/docs/creating-nodes/node-html#node-type).
   显示在“信息”侧边栏选项卡中的帮助文本。它在`text/html`类型的脚本中定义，`data-help-name`设置为 [节点的类型](https://nodered.org/docs/creating-nodes/node-html#node-type)。

### Defining a node 定义节点

A node must be registered with the editor using the `RED.nodes.registerType` function.
节点必须使用`RED.nodes.registerType`向编辑器注册 功能

This function takes two arguments; the type of the node and its definition:
这个函数有两个参数：节点的类型和它的定义：

```
<script type="text/javascript">
    RED.nodes.registerType('node-type',{
        // node definition
    });
</script>
```

#### Node type 节点类型

The node type is used throughout the editor to identify the node. It must match the value used by the call to `RED.nodes.registerType` in the corresponding `.js` file.
节点类型在整个编辑器中用于标识节点。它必须与对应的`` `.js`文件。

#### Node definition 节点定义

The node definition contains all of the information about the node needed by the editor. It is an object with the following properties:
节点定义包含编辑器所需的关于节点的所有信息。它是一个具有以下属性的对象：

- `category`: (string) the palette category the node appears in
  `category`：（字符串）节点出现的调色板类别
- `defaults`: (object) the [editable properties](https://nodered.org/docs/creating-nodes/properties) for the node.
  `defaults`：（对象）节点的[可编辑属性](https://nodered.org/docs/creating-nodes/properties)。
- `credentials`: (object) the [credential properties](https://nodered.org/docs/creating-nodes/credentials) for the node.
  `credentials`：（object）节点的[凭证属性](https://nodered.org/docs/creating-nodes/credentials)。
- `inputs`: (number) how many inputs the node has, either `0` or `1`.
  `inputs`：节点有多少个输入，`0`或`1`。
- `outputs`: (number) how many outputs the node has. Can be `0` or more.
  `outputs`：节点有多少个输出。可以是`0`或更多。
- `color`: (string) the [background colour](https://nodered.org/docs/creating-nodes/appearance#background-colour) to use.
  `color`：（string）要使用的[背景颜色](https://nodered.org/docs/creating-nodes/appearance#background-colour)。
- `paletteLabel`: (string|function) the [label](https://nodered.org/docs/creating-nodes/appearance#label) to use in the palette.
  `paletteLabel`：（string|函数）要在调色板中使用的标签。
- `label`: (string|function) the [label](https://nodered.org/docs/creating-nodes/appearance#label) to use in the workspace.
  `标签`：（字符串|函数）要在工作区中使用的标签。
- `labelStyle`: (string|function) the [style](https://nodered.org/docs/creating-nodes/appearance#label-style) to apply to the label.
  `labelStyle`：（string|函数）要应用于标签的样式。
- `inputLabels`: (string|function) optional [label](https://nodered.org/docs/creating-nodes/appearance#port-labels) to add on hover to the input port of a node.
  `inputLabels`：（string|函数）可选[标签](https://nodered.org/docs/creating-nodes/appearance#port-labels)，用于在悬停时添加到节点的输入端口。
- `outputLabels`: (string|function) optional [labels](https://nodered.org/docs/creating-nodes/appearance#port-labels) to add on hover to the output ports of a node.
  `outputLabels`：（string|函数）可选[标签](https://nodered.org/docs/creating-nodes/appearance#port-labels)，用于在悬停时添加到节点的输出端口。
- `icon`: (string) the [icon](https://nodered.org/docs/creating-nodes/appearance#icon) to use.
  `icon`：（字符串）要使用的[图标](https://nodered.org/docs/creating-nodes/appearance#icon)。
- `align`: (string) the [alignment](https://nodered.org/docs/creating-nodes/appearance#alignment) of the icon and label.
  `align`：（字符串）图标和标签的[对齐方式](https://nodered.org/docs/creating-nodes/appearance#alignment)。
- `button`: (object) adds a [button](https://nodered.org/docs/creating-nodes/appearance#buttons) to the edge of the node.
  `button`：（object）将[按钮](https://nodered.org/docs/creating-nodes/appearance#buttons)添加到节点的边缘。
- `oneditprepare`: (function) called when the edit dialog is being built. See [custom edit behaviour](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour).
  `oneditprepare`：（函数）在编辑对话框构建时调用。请参阅[自定义编辑行为](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour)。
- `oneditsave`: (function) called when the edit dialog is okayed. See [custom edit behaviour](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour).
  `oneditsave`：（函数）在编辑对话框被确认时调用。请参阅[自定义编辑行为](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour)。
- `oneditcancel`: (function) called when the edit dialog is canceled. See [custom edit behaviour](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour).
  `oneditcancel`：（函数）在编辑对话框取消时调用。请参阅[自定义编辑行为](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour)。
- `oneditdelete`: (function) called when the delete button in a configuration node’s edit dialog is pressed. See [custom edit behaviour](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour).
  `oneditdelete`：（函数）当按下配置节点的编辑对话框中的删除按钮时调用。请参阅[自定义编辑行为](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour)。
- `oneditresize`: (function) called when the edit dialog is resized. See [custom edit behaviour](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour).
  `oneditresize`：（函数）在调整编辑对话框大小时调用。请参阅[自定义编辑行为](https://nodered.org/docs/creating-nodes/properties#custom-edit-behaviour)。
- `onpaletteadd`: (function) called when the node type is added to the palette.
  `onpaletteadd`：（函数）在节点类型添加到调色板时调用。
- `onpaletteremove`: (function) called when the node type is removed from the palette.
  `onpaletteremove`：（函数）在节点类型从调色板中移除时调用。

### Edit dialog 编辑对话

The edit template for a node describes the content of its edit dialog.
节点的编辑模板描述其编辑对话框的内容。

```
<script type="text/html" data-template-name="node-type">
    <div class="form-row">
        <label for="node-input-name"><i class="fa fa-tag"></i> Name</label>
        <input type="text" id="node-input-name" placeholder="Name">
    </div>
    <div class="form-tips"><b>Tip:</b> This is here to help.</div>
</script>
```

More information about the edit dialog is available [here](https://nodered.org/docs/creating-nodes/edit-dialog).
有关编辑对话框的更多信息，请访问[此处](https://nodered.org/docs/creating-nodes/edit-dialog)。

### Help text 帮助文本

When a node is selected, its help text is displayed in the info tab. This should provide a meaningful description of what the node does. It should identify what properties it sets on outgoing messages and what properties can be set on incoming messages.
选定节点后，其帮助文本将显示在“信息”选项卡中。这应该对节点的作用提供有意义的描述。它应该标识它在传出消息上设置的属性以及可以在传入消息上设置的属性。

The content of the first `<p>` tag is used as the tooltip when hovering over nodes in the palette.
将鼠标悬停在选项板中的节点上时，第一个`<p>`标记的内容将用作工具提示。

```
<script type="text/html" data-help-name="node-type">
   <p>Some useful help text to introduce the node.</p>
   <h3>Outputs</h3>
       <dl class="message-properties">
       <dt>payload
           <span class="property-type">string | buffer</span>
       </dt>
   <h3>Details</h3>
   <p>Some more information about the node.</p>
</script>
```

A complete style guide for node help is [available here](https://nodered.org/docs/creating-nodes/help-style-guide).
[此处提供](https://nodered.org/docs/creating-nodes/help-style-guide)了节点帮助的完整样式指南。

# Packaging 包装

Nodes can be packaged as modules and published to the npm repository. This makes them easy to install along with any dependencies they may have.
节点可以打包为模块并发布到npm存储库。这使得它们很容易安装沿着它们可能具有的任何依赖项。

### Naming 命名

**We [updated our naming requirements](https://nodered.org/blog/2022/01/31/introducing-scorecard) on 31st January 2022. The following applies to modules first published after that date.
我们于2022年1月31日[更新了命名要求](https://nodered.org/blog/2022/01/31/introducing-scorecard)。以下内容适用于在该日期之后首次发布的模块。**

Packages should use a [scoped name](https://docs.npmjs.com/cli/v8/using-npm/scope) - such as `@myScope/node-red-sample`. That can be under a user scope or an organisation scope.
包应该使用一个[限定了作用域的名称](https://docs.npmjs.com/cli/v8/using-npm/scope)--比如`@myScope/node-red-sample`。它可以在用户范围或组织范围内。

Nodes published under a scoped name have no further requirements on their name. They could use `@myScope/node-red-sample` or just `@myScope/sample` - although having `node-red` in the name does help to associate the module with the project.
在作用域名称下发布的节点对其名称没有进一步的要求。他们可以使用`@myScope/node-red-sample`或者仅仅使用`@myScope/sample`--尽管在名称中使用`node-red`确实有助于将模块与项目关联起来。

If you are forking an existing package to provide a fix, you can keep the  same name but released under your own scope. But please keep in mind,  forking should always be a last resort if the original maintainer is not responsive to your contributions.
如果你正在派生一个现有的包来提供一个补丁，你可以保持相同的名称，但在你自己的范围内发布。但请记住，如果原始维护者不响应您的贡献，分叉应该始终是最后的手段。

### Directory structure 目录结构

Here is a typical directory structure for a node package:
下面是节点包的典型目录结构：

```
├── LICENSE
├── README.md
├── package.json
├── examples
    │   ├── example-1.json
    │   └── example-2.json
└── sample
    ├── icons
    │   └── my-icon.svg
    ├── sample.html
    └── sample.js
```

There are no strict requirements over the directory structure used within the package. If a package contains multiple nodes, they could all exist in the same directory, or they could each be placed in their own sub-directory. The examples folder must be in the root of the package.
对于包中使用的目录结构没有严格的要求。如果一个包包含多个节点，它们可以全部存在于同一个目录中，也可以分别放在各自的子目录中。examples文件夹必须位于包的根目录下。

### Testing a node module locally 在本地测试节点模块

To test a node module locally, the [`npm install `](https://docs.npmjs.com/cli/install) command can be used. This allows you to develop the node in a local directory and have it linked into a local node-red install during development.
要在本地测试节点模块，可以使用[`npm install `](https://docs.npmjs.com/cli/install)命令。这允许您在本地目录中开发节点，并在开发期间将其链接到本地node-red安装。

In your node-red user directory, typically `~/.node-red`, run:
在你的node-red用户目录中，通常是`~/.node-red`，运行：

```
npm install <path to location of node module>
```

This creates the appropriate symbolic link to the directory so that Node-RED will discover the node when it starts. Any changes to the node’s file can be picked up by simply restarting Node-RED.
这将创建到目录的适当符号链接，以便Node-RED在启动时发现节点。对节点文件的任何更改都可以通过简单地重新启动Node-RED来获取。

### package.json

Along with the usual entries, the `package.json` file must contain a `node-red` entry that lists the `.js` files that contain nodes for the runtime to load.
沿着通常的条目，`package.json`文件必须包含一个`node-red` 列出包含运行时要加载的节点的`.js`文件的条目。

If you have multiple nodes in a single file, you only have to list the file once.
如果在单个文件中有多个节点，则只需列出该文件一次。

If any of the nodes have dependencies on other npm modules, they must be included in the `dependencies` property.
如果任何节点依赖于其他npm模块，它们必须包含在dependencies属性中。``

To help make the nodes discoverable within the npm repository, the file should include `node-red` in its `keywords` property. This will ensure the package appears when [searching by keyword](https://www.npmjs.org/browse/keyword/node-red).
为了帮助使npm存储库中的节点可扩展，文件应该在其`keywords`属性中包含`node-red`。这将确保在[按关键字搜索](https://www.npmjs.org/browse/keyword/node-red)时显示软件包。

*Note* : Please do NOT add the `node-red` keyword until you are happy that the node is stable and working correctly, and documented sufficiently for others to be able to use it.
*注意事项*：请不要添加'node-red'关键字，直到你满意的节点是稳定的，工作正常，并充分记录其他人能够使用它。

```
{
    "name"         : "@myScope/node-red-sample",
    "version"      : "0.0.1",
    "description"  : "A sample node for node-red",
    "dependencies": {
    },
    "keywords": [ "node-red" ],
    "node-red"     : {
        "nodes": {
            "sample": "sample/sample.js"
        }
    }
}
```

You should specify what versions of Node-RED your nodes support with a `version` entry. For example, the following means the node requires Node-RED 2.0 or later.
您应该使用`版本`条目指定您的节点支持的Node-RED版本。例如，以下表示节点需要Node-RED 2.0或更高版本。

```
"node-red"     : {
    "version": ">=2.0.0",
    "nodes": {
        "sample": "sample/sample.js"
    }
}
```

### README.md

The README.md file should describe the capabilities of the node, and list any pre-requisites that are needed in order to make it function. It may also be useful to include any extra instructions not included in the *info* tab part of the node’s html file, and maybe even a small example flow demonstrating it’s use.
README.md文件应该描述节点的功能，并列出使其正常工作所需的任何预配置。在节点的html文件的*info*选项卡部分中包含任何未包含的额外说明，甚至是一个演示其使用的小示例流，也可能是有用的。

The file should be marked up using [GitHub flavoured markdown](https://help.github.com/articles/markdown-basics/).
该文件应使用 [GitHub的markdown](https://help.github.com/articles/markdown-basics/)。

### LICENSE 许可证

Please include a license file so that others may know what they can and cannot do with your code.
请包括一个许可证文件，以便其他人可以知道他们可以和不能使用您的代码做什么。

### Publishing to npm 发布到npm

There are lots of guides to publishing a package to the npm repository. A basic overview is available [here](https://docs.npmjs.com/misc/developers).
有很多关于将包发布到npm仓库的指南。基本的概述在[这里](https://docs.npmjs.com/misc/developers)。

### Adding to flows.nodered.org 添加到flows.nodered.org

As of April 2020, the [the Node-RED Flow Library](https://flows.nodered.org) is no longer able to automatically index and update nodes published on npm with the `node-red` keyword. Instead, a submission request has to be placed manually.
截至2020年4月，[Node-RED流库](https://flows.nodered.org) 不再能够自动索引和更新发布在 npm使用`node-red`关键字。相反，必须手动提交请求。

To do so, make sure all of the packaging requests are met. To add a new node to the library, click on the `+` button at the top of [the library’s page](https://flows.nodered.org), and select the ‘node’ option. This button takes you to [the Adding a Node page](https://flows.nodered.org/add/node). Here, the list of requirements is repeated and describes the steps to have it added to the library.
为此，请确保满足所有打包请求。要向库中添加新节点，请单击`` [打开库的页面](https://flows.nodered.org)，然后选择“节点”选项。 这个按钮带你到 [“添加节点”页](https://flows.nodered.org/add/node)。在这里，重复了需求列表，并描述了将其添加到库中的步骤。

To update an existing node, you can either resubmit it the same way as you would for a new node, or request a refresh from the node’s page on the flow library through the ‘request refresh’ link. This is only visible to logged in users.
要更新现有节点，您可以按照创建新节点的相同方式重新提交它，或者通过“请求刷新”链接从流库中的节点页面请求刷新。这仅对登录的用户可见。

If it does not appear after that time, you can ask for help on the [Node-RED forum](https://discourse.nodered.org) or [slack](https://nodered.org/slack).
如果在该时间之后没有出现，您可以在 [Node-RED论坛](https://discourse.nodered.org)或 [松弛](https://nodered.org/slack)。

# Node properties 节点属性

A node’s properties are defined by the `defaults` object in its html definition. These are the properties that get passed to the node constructor function when an instance of the node is created in the runtime.
节点的属性由其html定义中的`defaults`对象定义。这些属性是在运行时创建节点实例时传递给节点构造函数的属性。

In the example from the [creating your first node section](https://nodered.org/docs/creating-nodes/first-node), the node had a single property called `name`. In this section, we’ll add a new property called `prefix` to the node:
在[创建您的第一个节点部分](https://nodered.org/docs/creating-nodes/first-node)的示例中，节点有一个名为`name`的属性。在本节中，我们将向节点添加一个名为`prefix`的新属性：

1. Add a new entry to the 

   ```plaintext
   defaults
   ```

    object:    

   
   向`默认`对象添加新条目：

   ```
    defaults: {
        name: {value:""},
        prefix: {value:""}
    },
   ```

   The entry includes the default `value` to be used when a new node of this type is dragged onto the workspace.
   该条目包括将此类型的新节点拖到工作区上时使用的默认`值`。

2. Add an entry to the edit template for the node    

   
   向节点的编辑模板添加条目

   ```
    <div class="form-row">
        <label for="node-input-prefix"><i class="fa fa-tag"></i> Prefix</label>
        <input type="text" id="node-input-prefix">
    </div>
   ```

   The template should contain an `<input>` element with an `id` set to `node-input-<propertyname>`.
   模板应包含`ID`设置为的`<input>`元素 `node-input-<propertyname>`。

3. Use the property in the node    

   
   使用节点中的属性

   ```
    function LowerCaseNode(config) {
        RED.nodes.createNode(this,config);
        this.prefix = config.prefix;
        var node = this;
        this.on('input', function(msg) {
            msg.payload = node.prefix + msg.payload.toLowerCase();
            node.send(msg);
        });
    }
   ```

### Property definitions 特性定义

The entries in the `defaults` object must be objects and can have the following attributes:
`默认`对象中的条目必须是对象，并且可以具有以下属性：

- `value` : (any type) the default value the property takes
  `value`：（任何类型）属性采用的默认值
- `required` : (boolean) *optional* whether the property is required. If set to true, the property will be invalid if its value is null or an empty string.
  `required`：（boolean）*optional*属性是否是必需的。如果设置为true，则当属性值为null或空字符串时，该属性将无效。
- `validate` : (function) *optional* a function that can be used to validate the value of the property.
  `validate`：（function）*可选的*一个函数，可以用来验证属性的值。
- `type` : (string) *optional* if this property is a pointer to a [configuration node](https://nodered.org/docs/creating-nodes/config-nodes),  this identifies the type of the node.
  `type`：（string）*可选，*如果此属性是指向 [配置节点](https://nodered.org/docs/creating-nodes/config-nodes)，这标识了节点的类型。

### Reserved property names 保留属性名称

There are some reserved names for properties that **must not be used**. These are:
有一些属性的保留名称**不得使用**。这些是：

- Any single character - `x`, `y`, `z`, `d`, `g`, `l` are already used. Others are reserved for future use.
  任何单个字符-`x`，`y`，`z`，`d`，`g`，`l`都已使用。其他的保留供将来使用。
- `id`, `type`, `wires`, `inputs`, `outputs`
  `id`、`类型`、`导线`、`输入`、`输出`

If a node wants to allow the number of outputs it provides to be configurable then `outputs` may be included in the `defaults` array. The Function node is an example of how this works.
如果一个节点希望允许它提供的输出数量是可配置的，那么`输出`可以包括在`默认`数组中。Function节点是一个如何工作的例子。

### Property validation 属性验证

The editor attempts to validate all properties to warn the user if invalid values have been given.
编辑器尝试验证所有属性，以在给定无效值时警告用户。

The `required` attribute can be used to indicate a property must be non-null and non-blank.
`required`属性可用于指示属性必须为非null和非空。

If more specific validation is required, the `validate` attribute can be used to provide a function that will check the value is valid. The function is passed the value and should return either true or false. It is called within the context of the node which means `this` can be used to access other properties of the node. This allows the validation to depend on other property values. While editing a node the `this` object reflects the current configuration of the node and **not** the current form element value. The validator function should try to access the property configuration element and take the `this` object as a fallback to achieve the right user experience.
如果需要更具体的验证，`validate`属性可以用来提供一个函数来检查值是否有效。函数被传递了值，应该返回true或false。它在节点的上下文中被调用，这意味`着它`可以用来访问节点的其他属性。这允许验证依赖于其他属性值。编辑节点时，`此`对象反映节点的当前配置，而**不是**当前表单元素值。验证器函数应该尝试访问属性配置元素，并将`this`对象作为回退，以获得正确的用户体验。

There is a group of common validation functions provided.
提供了一组常见的验证函数。

- `RED.validators.number()` - check the value is a number
  `RED.validators.number（）`-检查值是否为数字
- `RED.validators.regex(re)` - check the value matches the provided regular expression
  `regex（re）`-检查值是否与提供的正则表达式匹配

Both methods - `required` attribute and `validate` attribute - are reflected by the UI in the same way. The missing configuration marker on the node is triggered and the corresponding input is red surrounded when a value is not valid or missing.
这两个方法--`required`属性和`validate`属性--都以相同的方式被UI反映。当某个值无效或缺失时，将触发节点上的缺失配置标记，并且相应的输入将被红色包围。

The following example shows how each of these validators can be applied.
下面的示例显示了如何应用这些验证器。

```
defaults: {
   minimumLength: { value:0, validate:RED.validators.number() },
   lowerCaseOnly: {value:"", validate:RED.validators.regex(/[a-z]+/) },
   custom: { value:"", validate:function(v) {
      var minimumLength=$("#node-input-minimumLength").length?$("#node-input-minimumLength").val():this.minimumLength;
      return v.length > minimumLength
   } }
},
```

Note how the `custom` property is only valid if its length is greater than the current value of the `minimumLength` property or the value of the minimumLength form element.
请注意，`自定义`属性只有在其长度大于`minimumLength`属性的当前值或minimumLength表单元素的值时才有效。

### Property edit dialog 属性编辑对话框

When the edit dialog is opened, the editor populates the dialog with the edit template for the node.
当编辑对话框打开时，编辑器将使用节点的编辑模板填充对话框。

For each of the properties in the `defaults` array, it looks for an `<input>` element with an `id` set to `node-input-<propertyname>`, or `node-config-input-<propertyname>` in the case of Configuration nodes. This input is then automatically populated with the current value of the property. When the edit dialog is closed, the property takes whatever value is in the input.
对于`defaults`数组中的每个属性，它都会查找`<input>` 元素，其`ID`设置为`node-input-<propertyname>`，或在配置节点的情况下设置为 `node-config-input-<propertyname>` 。然后，此输入将自动填充属性的当前值。当编辑对话框关闭时，该属性采用输入中的任何值。

More information about the edit dialog is available [here](https://nodered.org/docs/creating-nodes/edit-dialog).
有关编辑对话框的更多信息，请访问[此处](https://nodered.org/docs/creating-nodes/edit-dialog)。

#### Custom edit behavior 自定义编辑行为

The default behavior works in many cases, but sometimes it is necessary to define some node-specific behavior. For example, if a property cannot be properly edited as a simple `<input>` or `<select>`, or if the edit dialog content itself needs to have certain behaviors based on what options are selected.
默认行为在许多情况下都可以工作，但有时需要定义一些特定于节点的行为。例如，如果无法将属性正确编辑为简单的`<input>`或`<select>`，或者如果编辑对话框内容本身需要具有基于所选选项的某些行为。

A node definition can include two functions to customize the edit behavior.
节点定义可以包含两个函数来自定义编辑行为。

- `oneditprepare` is called immediately before the dialog is displayed.
  `oneditprepare`在显示对话框之前立即被调用。
- `oneditsave` is called when the edit dialog is okayed.
  `oneditsave`在编辑对话框被确认时被调用。
- `oneditcancel` is called when the edit dialog is canceled.
  `oneditcancel`在编辑对话框被取消时被调用。
- `oneditdelete` is called when the delete button in a configuration node’s edit dialog is pressed.
  当按下配置节点的编辑对话框中的删除按钮时，将调用`oneditdelete`。
- `oneditresize` is called when the edit dialog is resized.
  `oneditresize`在编辑对话框调整大小时被调用。

For example, when the Inject node is configured to repeat, it stores the configuration as a cron-like string: `1,2 * * * *`. The node defines an `oneditprepare` function that can parse that string and present a more user-friendly UI. It also has an `oneditsave` function that compiles the options chosen by the user back into the corresponding cron string.
例如，当Inject节点配置为重复时，它将配置存储为类似cron的字符串：`1，2 *`。该节点定义一个 `oneditprepare`函数，可以解析该字符串并呈现更用户友好的UI。它还有一个`oneditsave`函数，可以将用户选择的选项编译回相应的cron字符串。

# Node credentials 节点凭据

A node may define a number of properties as `credentials`. These are properties that are stored separately to the main flow file and do not get included when flows are exported from the editor.
节点可以将多个属性定义为`凭证`。这些属性单独存储在主流文件中，从编辑器中导出流时不会包含这些属性。

To add credentials to a node, the following steps are taken:
要向节点添加凭据，请执行以下步骤：

1. Add a new 

   ```plaintext
   credentials
   ```

    entry to the node’s definition:    

   
   向节点的定义中添加新`凭据`条目：

   ```
    credentials: {
       username: {type:"text"},
       password: {type:"password"}
    },
   ```

   The entries take a single option - their `type` which can be either `text` or `password`.
   这些条目只有一个选项--它们的`类型`可以是`文本`， `密码`.

2. Add suitable entries to the edit template for the node    

   
   向节点的编辑模板中添加合适的条目

   ```
    <div class="form-row">
        <label for="node-input-username"><i class="fa fa-tag"></i> Username</label>
        <input type="text" id="node-input-username">
    </div>
    <div class="form-row">
        <label for="node-input-password"><i class="fa fa-tag"></i> Password</label>
        <input type="password" id="node-input-password">
    </div>
   ```

   Note that the template uses the same element `id` conventions as regular node properties.
   请注意，模板使用与常规节点属性相同的元素`id`约定。

3. In the node’s 

   ```plaintext
   .js
   ```

    file, the call to 

   ```plaintext
   RED.nodes.registerType
   ```

    must be updated to include the credentials:    

   
   在节点的`.js`文件中，必须更新对`RED.nodes.registerType`的调用 列入全权证书：

   ```
    RED.nodes.registerType("my-node",MyNode,{
        credentials: {
            username: {type:"text"},
            password: {type:"password"}
        }
    });
   ```

### Accessing credentials 认证证书

#### Runtime use of credentials 全权证书的滥用

Within the runtime, a node can access its credentials using the `credentials` property:
在运行时内，节点可以使用`凭据`访问其凭据 性能：

```
function MyNode(config) {
    RED.nodes.createNode(this,config);
    var username = this.credentials.username;
    var password = this.credentials.password;
}
```

#### Credentials within the Editor 编辑器中的凭据

Within the editor, a node has restricted access to its credentials. Any that are of type `text` are available under the `credentials` property - just as they are in the runtime. But credentials of type `password` are not available. Instead, a corresponding boolean property called `has_<property-name>` is present to indicate whether the credential has a non-blank value assigned to it.
在编辑器中，节点对其凭据的访问受到限制。任何`文本`类型都可以在credentials属性下使用-就像它们在运行时中一样。``但`密码类型`的凭据不可用。相反，会出现一个名为`has_<property-name>的`相应布尔属性，以指示凭据是否分配了非空值。

```
oneditprepare: function() {
    // this.credentials.username is set to the appropriate value
    // this.credentials.password is not set
    // this.credentials.has_password indicates if the property is present in the runtime
    ...
}
```

### Advanced credential use 高级凭据使用

Whilst the credential system outlined above is sufficient for most cases, in some circumstances it is necessary to store more values in credentials than just those that get provided by the user.
虽然上面概述的凭证系统对于大多数情况是足够的，但在某些情况下，有必要在凭证中存储更多的值，而不仅仅是用户提供的值。

For example, for a node to support an OAuth workflow, it must retain server-assigned tokens that the user never sees. The Twitter node provides a good example of how this can be achieved.
例如，对于支持OAuth工作流的节点，它必须保留用户永远看不到的服务器分配的令牌。Twitter节点提供了如何实现这一点的一个很好的例子。

# Node appearance 节点外观

There are three aspects of a node’s appearance that can be customised; the icon, background colour and its label.
节点的外观有三个方面可以自定义：图标，背景颜色和标签。

### Icon 图标

The node’s icon is specified by the `icon` property in its definition.
节点的图标由其定义中的`icon`属性指定。

The value of the property can be either a string or a function.
属性的值可以是字符串或函数。

If the value is a string, that is used as the icon.
如果值是字符串，则将其用作图标。

If the value is a function, it will get evaluated when the node is first loaded, or after it has been edited. The function is expected to return the value to use as the icon.
如果该值是一个函数，则将在首次加载节点时或编辑节点后对其进行计算。该函数预计将返回用作图标的值。

The function will be called both for nodes in the workspace, where `this` references a node instance, as well as for the node’s entry in the palette. In this latter case, `this` will not refer to a particular node instance and the function *must* return a valid value.
将为工作区中的节点调用该函数，`` 一个节点实例，以及调色板中节点的条目。在后一种情况下， `这`将不会引用特定的节点实例，并且该函数*必须*返回有效值。

```
...
icon: "file.svg",
...
```

The icon can be either:
图标可以是：

- the name of a stock icon provided by Node-RED,
  Node-RED提供的股票图标的名称，
- the name of a custom icon provided by the module,
  由模块提供的自定义图标的名称，
- a Font Awesome 4.7 icon
  Font Awesome 4.7图标

#### Stock icons 股票图标

- ![img](https://nodered.org/docs/creating-nodes/images/alert.svg) alert.svg
- ![img](https://nodered.org/docs/creating-nodes/images/arrow-in.svg) arrow-in.svg
- ![img](https://nodered.org/docs/creating-nodes/images/bridge-dash.svg) bridge-dash.svg
- ![img](https://nodered.org/docs/creating-nodes/images/bridge.svg) bridge.svg
- ![img](https://nodered.org/docs/creating-nodes/images/db.svg) db.svg
- ![img](https://nodered.org/docs/creating-nodes/images/debug.svg) debug.svg
- ![img](https://nodered.org/docs/creating-nodes/images/envelope.svg) envelope.svg ![img](https://nodered.org/docs/creating-nodes/images/envelope.svg) 信封. svg
- ![img](https://nodered.org/docs/creating-nodes/images/feed.svg) feed.svg
- ![img](https://nodered.org/docs/creating-nodes/images/file.svg) file.svg
- ![img](https://nodered.org/docs/creating-nodes/images/function.svg) function.svg
- ![img](https://nodered.org/docs/creating-nodes/images/hash.svg) hash.svg
- ![img](https://nodered.org/docs/creating-nodes/images/inject.svg) inject.svg
- ![img](https://nodered.org/docs/creating-nodes/images/light.svg) light.svg
- ![img](https://nodered.org/docs/creating-nodes/images/serial.svg) serial.svg
- ![img](https://nodered.org/docs/creating-nodes/images/template.svg) template.svg
- ![img](https://nodered.org/docs/creating-nodes/images/white-globe.svg) white-globe.svg

**Note**: In Node-RED 1.0, all of these icons have been replaced with SVG alternatives for a better appearance. To ensure backward compatibility, the editor will automatically swap any request for the png version for the SVG version if it is available.
**注意**：在Node-RED 1.0中，所有这些图标都被SVG替代品取代，以获得更好的外观。为了确保向后兼容性，编辑器将自动将任何对png版本的请求交换为SVG版本（如果可用）。

#### Custom icon 定制图标

A node can provide its own icon in a directory called `icons` alongside its `.js` and `.html` files. These directories get added to the search path when the editor looks for a given icon filename. Because of this, the icon filename must be unique.
节点可以在名为`icons`的目录中提供自己的图标，并与其`.js放在一起` 和`.html`文件。当编辑器查找给定的图标文件名时，这些目录会被添加到搜索路径中。因此，图标文件名必须唯一。

The icon should be white on a transparent background, with a 2:3 aspect ratio, with a minimum of 40 x 60 in size.
图标应为透明背景上的白色，宽高比为2：3，大小至少为40 x 60。

#### Font Awesome icon Font Awesome图标

Node-RED includes the full set of [Font Awesome 4.7 icons](https://fontawesome.com/v4.7.0/icons/).
Node-RED包含一整套[Font Awesome 4.7图标](https://fontawesome.com/v4.7.0/icons/)。

To specify a FA icon, the property should take the form:
要指定FA图标，该属性应采用以下形式：

```
...
icon: "font-awesome/fa-automobile",
...
```

#### User defined icon 用户定义图标

Individual node icons can be customised by the user within the editor on the ‘appearance’ tab of the node’s edit dialog.
用户可以在编辑器中的节点编辑对话框的“外观”选项卡上自定义单个节点图标。

**Note**: If a node has an `icon` property in its `defaults` object, its icon cannot be customised. For example, the `ui_button` node of `node-red-dashboard`.
**注意**：如果节点在其`默认`对象中具有`图标`属性，则无法自定义其图标。例如，`node-red-dashboard`的`ui_button`节点。

### Background Colour 背景颜色

The node background colour is one of the main ways to quickly distinguish different node types. It is specified by the `color` property in the node definition.
节点背景颜色是快速区分不同节点类型的主要方法之一。它由节点定义中的`color`属性指定。

```
...
color: "#a6bbcf",
...
```

We have used a muted palette of colours. New nodes should try to find a colour that fits with this palette.
我们使用了柔和的色调。新节点应该尝试找到适合这个调色板的颜色。

Here are some of the commonly used colours:
以下是一些常用的颜色：

- \#3FADB5
- \#87A980
- \#A6BBCF
- \#AAAA66
- \#C0C0C0
- \#C0DEED
- \#C7E9C0
- \#D7D7A0
- \#D8BFD8
- \#DAC4B4
- \#DEB887
- \#DEBD5C
- \#E2D96E
- \#E6E0F8
- \#E7E7AE
- \#E9967A
- \#F3B567
- \#FDD0A2
- \#FDF0C2
- \#FFAAAA
- \#FFCC66
- \#FFF0F0
- \#FFFFFF

### Labels 标签

There are four label properties of a node; `label`, `paletteLabel`, `outputLabel` and `inputLabel`.
节点有四个标签属性：`label`、`paletteLabel`、`outputLabel`和`inputLabel`。

#### Node label 节点标签

The `label` of a node in the workspace can either be a static piece of text, or it can be set dynamically on a per-node basis according to the properties of the node.
工作区中节点的`标签`可以是一段静态文本，也可以根据节点的属性在每个节点的基础上动态设置。

The value of the property can be either a string or a function.
属性的值可以是字符串或函数。

If the value is a string, that is used as the label.
如果值是字符串，则将其用作标签。

If the value is a function, it will get evaluated when the node is first loaded, or after it has been edited. The function is expected to return the value to use as the label.
如果该值是一个函数，则将在首次加载节点时或编辑节点后对其进行计算。函数应该返回用作标签的值。

As mentioned in a previous section, there is a convention for nodes to have a `name` property to help distinguish between them. The following example shows how the `label` can be set to pick up the value of this property or default to something sensible.
如前一节所述，节点有一个约定， `命名`属性以帮助区分它们。下面的示例显示如何设置`标签`以获取此属性的值或将其默认为合理的值。

```
...
label: function() {
    return this.name||"lower-case";
},
...
```

Note that it is not possible to use [credential](https://nodered.org/docs/creating-nodes/credentials) properties in the label function.
注意，在label函数中不能使用[凭证](https://nodered.org/docs/creating-nodes/credentials)属性。

#### Palette label 电子标签

By default, the node’s type is used as its label within the palette. The `paletteLabel` property can be used to override this.
默认情况下，节点的类型用作调色板中的标签。的 `paletteLabel`属性可用于覆盖此属性。

As with `label`, this property can be either a string or a function. If it is a function, it is evaluated once when the node is added to the palette.
与`label`一样，此属性可以是字符串或函数。如果它是一个函数，则在将节点添加到调色板时对其进行一次计算。

#### Label style 标签样式

The css style of the label can also be set dynamically, using the `labelStyle` property. Currently, this property must identify the css class to apply. If not specified, it will use the default `node_label` class. The only other predefined class is `node_label_italic`.
还可以使用`labelStyle`动态设置标签的css样式 财产目前，此属性必须标识要应用的css类。如果 如果没有指定，它将使用默认的`node_label`类。唯一的另一个预定义类是`node_label_italic`。

​    ![node label style](https://nodered.org/docs/creating-nodes/images/node_label_style.png)

The following example shows how `labelStyle` can be set to `node_label_italic` if the `name` property has been set:
以下示例显示如何`将labelStyle`设置为`node_label_italic` 如果已设置`name`属性：

```
...
labelStyle: function() {
    return this.name?"node_label_italic":"";
},
...
```

#### Alignment 对准

By default, the icon and label are left-aligned in the node. For nodes that sit at the end of a flow, the convention is to right-align the content. This is done by setting the `align` property in the node definition to `right`:
默认情况下，图标和标签在节点中左对齐。对于位于流末尾的节点，约定是右对齐内容。这是通过将节点定义中的`align`属性设置为`right来`完成的：

```
...
align: 'right',
...
```

​    ![node label alignment](https://nodered.org/docs/creating-nodes/images/node_alignment.png)

#### Port labels 端口标签

Nodes can provide labels on their input and output ports that can be seen by hovering the mouse over the port.
节点可以在其输入和输出端口上提供标签，将鼠标悬停在端口上即可看到这些标签。

​    ![port labels](https://nodered.org/docs/creating-nodes/images/node-labels.png)

These can either be set statically by the node’s html file
这些可以由节点的html文件静态设置

```
...
inputLabels: "parameter for input",
outputLabels: ["stdout","stderr","rc"],
...
```

or generated by a function, that is passed an index to indicate the output pin (starting from 0).
或由函数生成，该函数传递索引以指示输出引脚（从0开始）。

```
...
outputLabels: function(index) {
    return "my port number "+index;
}
...
```

In both cases they can be overwritten by the user using the `node settings` section of the configuration editor.
在这两种情况下，用户都可以使用配置编辑器的`节点设置`部分覆盖它们。

​    ![port label editor](https://nodered.org/docs/creating-nodes/images/node-labels-override.png)

​    ![port custom labels](https://nodered.org/docs/creating-nodes/images/node-labels-custom.png)

**Note**: Labels are not generated dynamically, and cannot be set by `msg` properties.
**注意**：标签不是动态生成的，也不能由`msg`属性设置。

### Buttons 按钮

A node can have a button on its left or right hand edge, as seen with the core Inject and Debug nodes.
一个节点可以在其左侧或右侧边缘上有一个按钮，如核心Inject和Intro节点所示。

A key principle is the editor is not a dashboard for controlling your flows. So in general, nodes should not have buttons on them. The Inject and Debug nodes are special cases as the buttons play a role in the development of flows.
一个关键的原则是编辑器不是控制流程的仪表板。所以一般来说，节点上不应该有按钮。“注入”和“注入”节点是特殊情况，因为按钮在流的开发中起作用。

The `button` property in its definition is used to describe the behavior of the button. It must provide, as a minimum, an `onclick` function that will be called when the button is clicked.
其定义中的`button`属性用于描述按钮的行为。它必须至少提供一个`onclick`函数，在单击按钮时调用该函数。

```
...
button: {
    onclick: function() {
        // Called when the button is clicked
    }
},
...
```

The property can also define an `enabled` function to dynamically enable and disable the button based on the node’s current configuration. Similarly, it can define a `visible` function to determine whether the button should be shown at all.
该属性还可以定义一个`enabled`函数，以根据节点的当前配置动态启用和禁用按钮。同样，它可以定义一个`可见`函数来确定是否应该显示该按钮。

```
...
button: {
    enabled: function() {
        // return whether or not the button is enabled, based on the current
        // configuration of the node
        return !this.changed
    },
    visible: function() {
        // return whether or not the button is visible, based on the current
        // configuration of the node
        return this.hasButton
    },
    onclick: function() { }
},
...
```

The `button` can also be configured as a toggle button - as seen with the Debug node. This is done by added a property called `toggle` that identifies a property in the node’s `defaults` object that should be used to store a boolean value whose value is toggled whenever the button is pressed.
该`按钮`也可以配置为切换按钮-如图所示，使用“切换”节点。这是通过添加一个名为`toggle的`属性来完成的，该属性标识节点的`默认`对象中的一个属性，该属性应用于存储一个布尔值，该布尔值的值在按下按钮时切换。

```
...
defaults: {
    ...
    buttonState: {value: true}
    ...
},
button: {
    toggle: "buttonState",
    onclick: function() { }
}
...
```

# Node edit dialog 节点编辑对话框

The edit dialog for a node is the main way a user can configure the node to do what they want.
节点的编辑对话框是用户配置节点以执行所需操作的主要方式。

The dialog should be intuitive to use and be consistent in its design and appearance when compared to other nodes.
对话框应该使用起来很直观，并且与其他节点相比，其设计和外观应该一致。

The edit dialog is provided in the [node’s HTML file](https://nodered.org/docs/creating-nodes/node-html), inside a `<script>` tag:
编辑对话框在[节点的HTML文件](https://nodered.org/docs/creating-nodes/node-html)中提供，位于 `<script>`标记：

```
<script type="text/html" data-template-name="node-type">
    <!-- edit dialog content  -->
</script>
```

- The `<script>` tag should have a `type` of `text/html` - this will help most text editors to provide proper syntax highlighting. It also prevents the browser from treating it like normal HTML content when the node is loaded into the editor.
  `<script>`标记应该具有`text/html``类型`-这将有助于大多数文本编辑器提供正确的语法突出显示。当节点加载到编辑器中时，它还可以防止浏览器将其视为普通的HTML内容。
- The tag should have its `data-template-name` set to the type of the node its the edit dialog for. This is how the editor knows what content to show when editing a particular node.
  标签的`data-template-name`应该设置为编辑对话框的节点类型。这就是编辑器在编辑特定节点时知道要显示什么内容的方式。

The edit dialog will typically be made up from a series of rows - each containing a label and input for a different property
编辑对话框通常由一系列行组成，每行包含不同属性的标签和输入

```
<div class="form-row">
    <label for="node-input-name"><i class="fa fa-tag"></i> Name</label>
    <input type="text" id="node-input-name" placeholder="Name">
</div>
```

- Each row is created by a `<div>` with class `form-row`
  每一行都是由具有类`form-row`的`<div>`创建的
- A typical row will have a `<label>` that contains an icon and the name of the property followed by an `<input>`. The icon is created using an `<i>` element with a class taken from those available from [Font Awesome 4.7](https://fontawesome.com/v4.7.0/icons/).
  一个典型的行将有一个`<label>`，它包含一个图标和属性名称，后面跟着一个`<input>`。该图标是使用`<i>`元素创建的，其类取自[Font Awesome 4.7](https://fontawesome.com/v4.7.0/icons/)中的类。
- The form element containing the property must have an id of `node-input-<propertyname>`. In the case of Configuration nodes, the id must be `node-config-input-<property-name>`.
  包含属性的表单元素必须具有`node-input-<propertyname>`的ID。对于配置节点，id必须为 `node-config-input-<property-name>` 。
- The `<input>` type can be either `text` for string/number properties, or `checkbox` for boolean properties. Alternatively, a `<select>` element can be used if there is a restricted set of choices.
  对于字符串/数字属性，`<input>`类型可以是`文本`，或者 布尔属性的`复选框`。或者，如果存在一组受限的选项，则可以使用`<select>`元素。

Node-RED provides some standard UI widgets that can be used by nodes to create a richer and more consistent user experience.
Node-RED提供了一些标准的UI小部件，节点可以使用这些小部件来创建更丰富、更一致的用户体验。

### Buttons 按钮

To add a button to the edit dialog, use the standard `<button>` HTML element and give it the class `red-ui-button`.
要向编辑对话框中添加按钮，请使用标准的`<button>`HTML元素，并将类`red-ui-button`赋予它。

​    Plain button 普通钮扣    

| 按钮                | `<button type="button" class="red-ui-button">Button</button>` |
| ------------------- | ------------------------------------------------------------ |
| Small button 小按钮 |                                                              |

| 按钮                           | `<button type="button" class="red-ui-button red-ui-button-small">Button</button>` |
| ------------------------------ | ------------------------------------------------------------ |
| Toggle button group 切换按钮组 |                                                              |

|      | `<span class="button-group"> <button type="button" class="red-ui-button toggle selected my-button-group">b1</button><button type="button" class="red-ui-button toggle my-button-group">b2</button><button type="button" class="red-ui-button toggle my-button-group">b3</button> </span> ` HTML  `$(".my-button-group").on("click", function() {    $(".my-button-group").removeClass("selected");    $(this).addClass("selected"); })` oneditprepare 准备 To toggle the `selected` class on the active button, you will need to add code to the `oneditprepare` function to handle the events. 要在活动按钮上切换`选定`的类，需要向`oneditprepare`函数添加代码来处理事件。 *Note:* avoid whitespace between the `<button>` elements as the `button-group` span does not currently collapse whitespace properly. This will be addressed in the future. *注意：*避免`<button>`元素之间的空格，因为`按钮组`范围当前不能正确折叠空格。今后将处理这一问题。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Inputs 输入

For simple text entry, the standard `<input>` element can be used.
对于简单的文本输入，可以使用标准的`<input>`元素。

In some cases, Node-RED provides the `TypedInput` widget as an alternative. It allows the user a way to specify the type of the property as well as its value.
在某些情况下，Node-RED提供`TypedInput`小部件作为替代。它允许用户指定属性的类型及其值。

For example, if a property could be a String, number or boolean. Or if the property is being used to identify message, flow or global context property.
例如，如果一个属性可以是字符串、数字或布尔值。或者，如果属性用于标识消息、流或全局上下文属性。

It is a jQuery widget that requires code to be added to the node’s `oneditprepare` function in order to add it to the page.
它是一个jQuery小部件，需要将代码添加到节点的`oneditprepare`函数，以便将其添加到页面。

Full API documentation for the `TypedInput` widget, including a list of the available built-in types is available [here](https://nodered.org/docs/api/ui/typedInput/).
`TypedInput`小部件的完整API文档（包括可用内置类型的列表）可[在此处](https://nodered.org/docs/api/ui/typedInput/)获得。

| Plain HTML Input 纯HTML输入                       | `<input type="text" id="node-input-name">` |
| ------------------------------------------------- | ------------------------------------------ |
| TypedInput String/Number/Boolean 字符串/数字/布尔 |                                            |

|                 | `<input type="text" id="node-input-example1"> <input type="hidden" id="node-input-example1-type"> `            HTML                            `$("#node-input-example1").typedInput({    type:"str",    types:["str","num","bool"],    typeField: "#node-input-example1-type" })`            oneditprepare 准备             When the TypedInput can be set to multiple types, an extra node            property is required to store information about the type. This            is added to the edit dialog as a hidden `<input>`.          当TypedInput可以设置为多种类型时，            属性是存储有关类型的信息所必需的。这            作为隐藏的`<input>`添加到编辑对话框。 |
| --------------- | ------------------------------------------------------------ |
| TypedInput JSON |                                                              |

| `<input type="text" id="node-input-example2">`            HTML                            `$("#node-input-example2").typedInput({    type:"json",    types:["json"] })`            oneditprepare 准备        The JSON type includes a button that will open up a dedicated JSON Edit        Dialog (disabled in this demo).          JSON类型包括一个按钮，该按钮将打开一个专用的JSON编辑        对话框（在此演示中禁用）。 |
| ------------------------------------------------------------ |
| TypedInput msg/flow/global                                   |

|                              | `<input type="text" id="node-input-example3"> <input type="hidden" id="node-input-example3-type">`            HTML                            `$("#node-input-example3").typedInput({    type:"msg",    types:["msg", "flow","global"],    typeField: "#node-input-example3-type" })`            oneditprepare 准备 |
| ---------------------------- | ------------------------------------------------------------ |
| TypedInput Select box 选择框 |                                                              |

 苹果

|                                           | `<input type="text" id="node-input-example4">`            HTML                            `$("#node-input-example4").typedInput({    types: [        {            value: "fruit",            options: [                { value: "apple", label: "Apple"},                { value: "banana", label: "Banana"},                { value: "cherry", label: "Cherry"},            ]        }    ] })`            oneditprepare 准备 |
| ----------------------------------------- | ------------------------------------------------------------ |
| TypedInput Multiple Select box 多个选择框 |                                                              |

 已选择0个

|      | `<input type="text" id="node-input-example5">`            HTML                            `$("#node-input-example5").typedInput({    types: [        {            value: "fruit",            multiple: "true",            options: [                { value: "apple", label: "Apple"},                { value: "banana", label: "Banana"},                { value: "cherry", label: "Cherry"},            ]        }    ] })`            oneditprepare 准备                  The resulting value of the multiple select is a comma-separated list of the selected options. 多重选择的结果值是所选选项的逗号分隔列表。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

### Multi-line Text Editor 多行文字编辑器

Node-RED includes a multi-line text editor based on the [Ace code editor](https://ace.c9.io/), or if enabled via user settings, the [Monaco editor](https://microsoft.github.io/monaco-editor/)
Node-RED包括一个基于[Ace代码编辑器的](https://ace.c9.io/)多行文本编辑器，如果通过用户设置启用，则包括[Monaco编辑器](https://microsoft.github.io/monaco-editor/)

![Multi-line Text Editor](https://nodered.org/docs/creating-nodes/images/ace-editor.png)

Multi-line Text Editor 多行文字编辑器

In the following example, the node property that we will edit is called `exampleText`.
在下面的示例中，我们将编辑的节点属性称为`exampleText`。

In your HTML, add a `<div>` placeholder for the editor. This must have the css class `node-text-editor`. You will also need to set a `height` on the element.
在HTML中，为编辑器添加`<div>`占位符。这必须有css类 `node-text-editor`。您还需要设置元素的`高度`。

```
<div style="height: 250px; min-height:150px;" class="node-text-editor" id="node-input-example-editor"></div>
```

In the node’s `oneditprepare` function, the text editor is initialised using the `RED.editor.createEditor` function:
在节点的`oneditprepare`函数中，文本编辑器是使用`RED.editor. reader编辑器`初始化的 作用：

```
this.editor = RED.editor.createEditor({
   id: 'node-input-example-editor',
   mode: 'ace/mode/text',
   value: this.exampleText
});
```

The `oneditsave` and `oneditcancel` functions are also needed to get the value back from the editor when the dialog is closed, and ensure the editor is properly removed from the page.
还需要`oneditsave`和`oneditcancel`函数在对话框关闭时从编辑器中获取值，并确保编辑器从页面中正确删除。

```
oneditsave: function() {
    this.exampleText = this.editor.getValue();
    this.editor.destroy();
    delete this.editor;
},
oneditcancel: function() {
    this.editor.destroy();
    delete this.editor;
},
```

# Node context 节点上下文

A node can store data within its context object.
节点可以在其上下文对象中存储数据。

For more information about context, read the [Working with Context guide](https://nodered.org/docs/user-guide/context).
有关上下文的详细信息，请阅读[使用上下文指南](https://nodered.org/docs/user-guide/context)。

There are three scopes of context available to a node:
一个节点有三个上下文范围：

- Node - only visible to the node that set the value
  节点-仅对设置值的节点可见
- Flow - visible to all nodes on the same flow (or tab in the editor)
  流-对同一流（或编辑器中的选项卡）上的所有节点可见
- Global - visible to all nodes
  全局-对所有节点可见

Unlike the Function node which provides predefined variables to access each of these contexts, a custom node must access these contexts for itself:
与Function节点提供预定义变量来访问这些上下文不同，自定义节点必须自己访问这些上下文：

```
// Access the node's context object
var nodeContext = this.context();

var flowContext = this.context().flow;

var globalContext = this.context().global;
```

Each of these context objects has the same `get`/`set` functions described in the [Writing Functions guide](https://nodered.org/docs/writing-functions#storing-data).
这些上下文对象中的每一个都具有在[编写函数指南](https://nodered.org/docs/writing-functions#storing-data)中描述的相同的`get`/`set`函数。

Note: Configuration nodes that are used by and shared by other nodes are by default global, unless otherwise specified by the user of the node. As such it cannot be assumed that they have access to a Flow context.
注意：由其他节点使用和共享的配置节点默认为全局节点，除非节点的用户另有指定。因此，不能假定它们可以访问流上下文。

# Node status 节点状态

Whilst running, a node is able to share status information with the editor UI. For example, the MQTT nodes can indicate if they are currently connected or not.
运行时，节点能够与编辑器UI共享状态信息。例如，MQTT节点可以指示它们当前是否连接。

​    ![node status](https://nodered.org/docs/creating-nodes/images/node_status.png)

To set its current status, a node uses the `status` function. For example, the following two calls are used by the MQTT node to set the statuses seen in the image above:
要设置其当前状态，节点使用`status`函数。例如，MQTT节点使用以下两个调用来设置上图中所示的状态：

```
this.status({fill:"red",shape:"ring",text:"disconnected"});

this.status({fill:"green",shape:"dot",text:"connected"});
```

*By default, the node status information is displayed in the editor. It can be disabled and re-enabled by selecting the* Display Node Status *option in the drop-down menu.*
*默认情况下，节点状态信息显示在编辑器中。通过选择下拉菜单中的Display Node Status（显示节点状态）选项，可以禁用和重新启用该选项**。*

### Status object 状态对象

A status object consists of three properties: `fill`, `shape` and `text`.
状态对象由三个属性组成：`填充`、`形状`和`文本`。

The first two define the appearance of the status icon and the third is an optional short piece of text (under <20 characters) to display alongside the icon.
前两个定义状态图标的外观，第三个是可选的短文本（在<20字符下），显示在图标旁边。

The `shape` property can be: `ring` or `dot`.
`形状`属性可以是：`环`或`点`。

The `fill` property can be: `red`, `green`, `yellow`, `blue` or `grey`
`填充`属性可以是：`红色`、`绿色`、`黄色`、`蓝色`或`灰色`

This allows for the following icons to be used:
这允许使用以下图标：

​           

​    

If the status object is an empty object, `{}`, then the status entry is cleared from the node.
如果状态对象是空对象`{}`，则从节点中清除状态条目。

### Note : Status Node 注：状态节点

From Node-RED v0.12.x the Status node can be used to catch any node status updates, for example connect and disconnect messages, in order to trigger other flows.
在Node-RED v0.12.x中，Status节点可用于捕获任何节点状态更新，例如连接和断开消息，以触发其他流。

# Configuration nodes 配置节点

Some nodes need to share configuration. For example, the MQTT In and MQTT Out nodes share the configuration of the MQTT broker, allowing them to pool the connection. Configuration nodes are scoped globally by default, this means the state will be shared between flows.
某些节点需要共享配置。例如，MQTT In和MQTT Out节点共享MQTT代理的配置，允许它们池化连接。默认情况下，配置节点的作用域是全局的，这意味着状态将在流之间共享。

### Defining a config node 定义配置节点

A configuration node is defined in the same way as other nodes. There are two key differences:
配置节点的定义方式与其他节点相同。有两个关键区别：

1. its `category` property is set to `config`
   其`category`属性设置为`config`
2. the edit template `<input>` elements have ids of `node-config-input-<propertyname>`
   编辑模板`<input>`元素的ID为 `node-config-input-<propertyname>` 

#### remote-server.html

```
<script type="text/javascript">
    RED.nodes.registerType('remote-server',{
        category: 'config',
        defaults: {
            host: {value:"localhost",required:true},
            port: {value:1234,required:true,validate:RED.validators.number()},
        },
        label: function() {
            return this.host+":"+this.port;
        }
    });
</script>

<script type="text/html" data-template-name="remote-server">
    <div class="form-row">
        <label for="node-config-input-host"><i class="fa fa-bookmark"></i> Host</label>
        <input type="text" id="node-config-input-host">
    </div>
    <div class="form-row">
        <label for="node-config-input-port"><i class="fa fa-bookmark"></i> Port</label>
        <input type="text" id="node-config-input-port">
    </div>
</script>
```

#### remote-server.js

```
module.exports = function(RED) {
    function RemoteServerNode(n) {
        RED.nodes.createNode(this,n);
        this.host = n.host;
        this.port = n.port;
    }
    RED.nodes.registerType("remote-server",RemoteServerNode);
}
```

In this example, the node acts as a simple container for the configuration - it has no actual runtime behaviour.
在本例中，节点充当配置的简单容器-它没有实际的运行时行为。

A common use of config nodes is to represent a shared connection to a remote system. In that instance, the config node may also be responsible for creating the connection and making it available to the nodes that use the config node. In such cases, the config node should also handle the [`close` event](https://nodered.org/docs/creating-nodes/node-js#closing-the-node) to disconnect when the node is stopped.
配置节点的一个常见用途是表示到远程系统的共享连接。在这种情况下，配置节点还可以负责创建连接并使其对使用配置节点的节点可用。在这种情况下，配置节点还应处理[`关闭`事件](https://nodered.org/docs/creating-nodes/node-js#closing-the-node) 当节点停止时断开连接。

### Using a config node 使用配置节点

Nodes register their use of config nodes by adding a property to the `defaults` array with the `type` attribute set to the type of the config node.
节点通过向`默认值`添加属性来注册它们对配置节点的使用 数组的`type`属性设置为配置节点的类型。

```
defaults: {
   server: {value:"", type:"remote-server"},
},
```

As with other properties, the editor looks for an `<input>` in the edit template with an id of `node-input-<propertyname>`. Unlike other properties, the editor replaces this `<input>` element with a `<select>` element populated with the available instances of the config node, along with a button to open the config node edit dialog.
与其他属性一样，编辑器在编辑模板中查找ID为`node-input-<propertyname>`的`<input>`。与其他属性不同，编辑器将此`%3 Cinput%3 E`元素替换为`%3 Cselect%3 E`元素，该元素填充有配置节点的可用实例，沿着一个按钮以打开配置节点编辑对话框。

​    ![node config select](https://nodered.org/docs/creating-nodes/images/node_config_dialog.png)

The node can then use this property to access the config node within the runtime.
然后，节点可以使用此属性访问运行时中的配置节点。

```
module.exports = function(RED) {
    function MyNode(config) {
        RED.nodes.createNode(this,config);

        // Retrieve the config node
        this.server = RED.nodes.getNode(config.server);

        if (this.server) {
            // Do something with:
            //  this.server.host
            //  this.server.port
        } else {
            // No config node configured
        }
    }
    RED.nodes.registerType("my-node",MyNode);
}
```

# Node help style guide 节点帮助样式指南

When a node is selected, its help text is displayed in the info tab. This help should provide the user with all the information they need in order to use the node.
选定节点后，其帮助文本将显示在“信息”选项卡中。此帮助应向用户提供使用该节点所需的所有信息。

The following style guide describes how the help should be structured to ensure a consistent appearance between nodes.
下面的样式指南介绍了如何构造帮助以确保节点之间的外观一致。

*Since 2.1.0* : The help text can be provided as markdown rather than HTML. In this case the `type` attribute of the `<script>` tag must be `text/markdown`.
*自2.1.0起*：帮助文本可以以markdown而不是HTML的形式提供。在这种情况下，`<script>`标记的`type`属性必须是`text/markdown`。
 When creating markdown help text be careful with indentation, markdown  is whitespace sensitive so all lines should have no leading whitespace  inside the `<script>` tags.
创建markdown帮助文本时，请小心缩进，markdown对空格敏感，因此所有行在`<script>`标记内都不应有前导空格。

------

​        This section provides a high-level introduction to the node. It should be        no more than 2 or 3 lines long. The first line (`<p>`)        is used as the tooltip when hovering over the node in the palette.    
本节简要介绍节点。它不应该超过2或3行。第一行（`<p>`）        将鼠标悬停在选项板中的节点上时，将用作工具提示。

Connects to a MQTT broker and publishes messages.
连接到MQTT代理并发布消息。

​        If the node has an input, this section describes the properties of the        message the node will use. The expected type of each property can also        be provided. The description should be brief - if further description is        needed, it should be in the Details section.    
如果节点具有输入，则本节介绍        节点将使用的消息。每个属性的预期类型还可以        提供。描述应简短-如果进一步描述        如果需要，它应该在细节部分。

### Inputs 输入

- payload                   有效载荷string | buffer 字符串|缓冲              

   the payload of the message to publish.  要发布的消息的有效载荷。

- topic  话题string 字符串

   the MQTT topic to publish to. 要发布到的MQTT主题。

​         If the node has outputs, as with the Inputs section, this section         describes the properties of the messages the node will send. If the node         has multiple outputs, a separate property list can be provided for each.     
如果节点具有输出，则与Inputs部分一样，此部分         描述节点将发送的消息的属性。如果节点         具有多个输出，可以为每个输出提供单独的属性列表。

### Outputs 输出

1. Standard output                     

    标准输出

   - payload  有效载荷string 字符串

     the standard output of the command. 命令的标准输出。

2. Standard error                     

    标准误差

   - payload  有效载荷string 字符串

     the standard error of the command. 命令的标准错误。

This section provides more detailed information about the node. It should        explain how it should be used, providing more information on its inputs/outputs.
本节提供有关节点的更详细信息。它应解释如何使用它，提供更多关于其投入/产出的信息。



### Details 细节

`msg.payload` is used as the payload of the published message.        If it contains an Object it will be converted to a JSON string before being sent.        If it contains a binary Buffer the message will be published as-is.
`msg.payload`用作发布消息的有效载荷。如果它包含Object，则在发送之前将其转换为JSON字符串。如果它包含一个二进制缓冲区的消息将被发布。

The topic used can be configured in the node or, if left blank, can be set by `msg.topic`.
使用的主题可以在节点中配置，如果留空，则可以通过`msg.topic`设置。

Likewise the QoS and retain values can be configured in the node or, if left        blank, set by `msg.qos` and `msg.retain` respectively.
同样，QoS和retain值可以在节点中配置，如果留空，则分别由`msg.qos`和`msg.retain`设置。

This section can be used to provide links to external resources, such as:
此部分可用于提供指向外部资源的链接，例如：

- any relevant additional documentation. Such as how the Template node links          to the Mustache language guide.
  任何相关的附加文件。例如模板节点如何链接到Mustache语言指南。
- the node's git repository or npm page - where the user can get additional help
  节点的git仓库或npm页面-用户可以在其中获得额外的帮助

### References 引用

- Twitter API docs - full description of `msg.tweet` property
  Twitter API文档-`msg.tweet` 属性的完整描述
- GitHub - the node's github repository
  GitHub-节点的github存储库

------

The above example was created with the following:.
上面的示例是使用以下内容创建的：。

[HTML](https://nodered.org/docs/creating-nodes/help-style-guide#)[Markdown](https://nodered.org/docs/creating-nodes/help-style-guide#)

```
<script type="text/html" data-help-name="node-type">
<p>Connects to a MQTT broker and publishes messages.</p>

<h3>Inputs</h3>
    <dl class="message-properties">
        <dt>payload
            <span class="property-type">string | buffer</span>
        </dt>
        <dd> the payload of the message to publish. </dd>
        <dt class="optional">topic <span class="property-type">string</span></dt>
        <dd> the MQTT topic to publish to.</dd>
    </dl>

 <h3>Outputs</h3>
     <ol class="node-ports">
         <li>Standard output
             <dl class="message-properties">
                 <dt>payload <span class="property-type">string</span></dt>
                 <dd>the standard output of the command.</dd>
             </dl>
         </li>
         <li>Standard error
             <dl class="message-properties">
                 <dt>payload <span class="property-type">string</span></dt>
                 <dd>the standard error of the command.</dd>
             </dl>
         </li>
     </ol>

<h3>Details</h3>
    <p><code>msg.payload</code> is used as the payload of the published message.
    If it contains an Object it will be converted to a JSON string before being sent.
    If it contains a binary Buffer the message will be published as-is.</p>
    <p>The topic used can be configured in the node or, if left blank, can be set
    by <code>msg.topic</code>.</p>
    <p>Likewise the QoS and retain values can be configured in the node or, if left
    blank, set by <code>msg.qos</code> and <code>msg.retain</code> respectively.</p>

<h3>References</h3>
    <ul>
        <li><a>Twitter API docs</a> - full description of <code>msg.tweet</code> property</li>
        <li><a>GitHub</a> - the nodes github repository</li>
    </ul>
</script>
```

#### Section headers 分段标题

Each section must be marked up with an `<h3>` tag. If the `Details` section needs sub headings, they must use `<h4>` tags.
每个部分都必须用`<h3>`标记进行标记。如果`详细信息`部分需要子标题，则它们必须使用`<h4>`标记。

[HTML](https://nodered.org/docs/creating-nodes/help-style-guide#)[Markdown](https://nodered.org/docs/creating-nodes/help-style-guide#)

```
<h3>Inputs</h3>
...
<h3>Details</h3>
...
 <h4>A sub section</h4>
 ...
```

#### Message properties 消息属性

A list of message properties is marked up with a `<dl>` list. The list must have a class attribute of `message-properties`.
消息属性列表用`<dl>`列表标记。该列表必须具有`message-properties`的class属性。

Each item in the list consists of a pair of `<dt>` and `<dd>` tags.
列表中的每个项目都由一对`<dt>`和`<dd>`标记组成。

Each `<dt>` contains the property name and an optional `<span class="property-type">` that contains the expected type of the property. If the property is optional, the `<dt>` should have a class attribute of `optional`.
每个`<dt>都`包含属性名称和可选的`<span class=“property-type”>` 它包含属性的预期类型。如果属性是可选的， `<dt>`应该有一`个可选`的class属性。

Each `<dd>` contains a brief description of the property.
每个`<dd>都`包含属性的简要说明。

[HTML](https://nodered.org/docs/creating-nodes/help-style-guide#)[Markdown](https://nodered.org/docs/creating-nodes/help-style-guide#)

```
<dl class="message-properties">
    <dt>payload
        <span class="property-type">string | buffer</span>
    </dt>
    <dd> the payload of the message to publish. </dd>
    <dt class="optional">topic
        <span class="property-type">string</span>
    </dt>
    <dd> the MQTT topic to publish to.</dd>
</dl>
```

#### Multiple outputs 多个输出

If the node has multiple outputs, each output should have its own message property list, as described above. Those lists should be wrapped in a `<ol>` list with a class attribute of `node-ports`
如果节点有多个输出，每个输出都应该有自己的消息属性列表，如上所述。这些列表应包装在具有`node-ports`类属性的`<ol>`列表中

Each item in the list should consist of a brief description of the output followed by a `<dl>` message property list.
列表中的每一项都应包含输出的简要说明，后跟`<dl>`消息属性列表。

**Note**: if the node has a single output, it should not be wrapped in such a list and just the `<dl>` used.
**注意**：如果节点只有一个输出，则不应将其包装在这样的列表中，而应仅使用`<dl>`。

[HTML](https://nodered.org/docs/creating-nodes/help-style-guide#)[Markdown](https://nodered.org/docs/creating-nodes/help-style-guide#)

```
<ol class="node-ports">
    <li>Standard output
        <dl class="message-properties">
            <dt>payload <span class="property-type">string</span></dt>
            <dd>the standard output of the command.</dd>
        </dl>
    </li>
    <li>Standard error
        <dl class="message-properties">
            <dt>payload <span class="property-type">string</span></dt>
            <dd>the standard error of the command.</dd>
        </dl>
    </li>
</ol>
```

#### General guidance 一般指导

When referencing a message property outside of a message property list described above, they should be prefixed with `msg.` to make it clear to the reader what it is. They should be wrapped in `<code>` tags.
当引用上述消息属性列表之外的消息属性时，它们应该以msg为前缀`。`让读者明白它是什么。它们应该用`<code>`标记包装。

[HTML](https://nodered.org/docs/creating-nodes/help-style-guide#)[Markdown](https://nodered.org/docs/creating-nodes/help-style-guide#)

```
The interesting part is in <code>msg.payload</code>.
```

No other styling markup (e.g. `<b>`,`<i>`) should be used within the body of the help text.
在帮助文本的正文中不应使用其他样式标记（例如`<b>`、`<i>`）。

The help should not assume the reader is an experienced developer or deeply familiar with whatever the node exposes; above all, it needs to be helpful.
帮助不应该假设读者是有经验的开发人员或非常熟悉节点公开的任何内容;最重要的是，它需要有帮助。

# Example flows 示例流

A packaged node can provide simple example flows that demonstrate how it can be used.
打包的节点可以提供简单的示例流来演示如何使用它。

They will appear under the Examples section of the library import menu.
它们将出现在库导入菜单的“示例”部分下。

Ideally they should be short, have a comment node to describe the functionality, and not use any other 3rd party nodes that need to be installed.
理想情况下，它们应该很短，有一个注释节点来描述功能，并且不使用任何其他需要安装的第三方节点。

To create an example, add a flow file to an `examples` directory in your node package. See [Packaging](https://nodered.org/docs/creating-nodes/packaging) for more details.
要创建示例，请将流文件添加到节点包中的`examples`目录。请参阅[包装](https://nodered.org/docs/creating-nodes/packaging)了解更多详情。

The name of the flow file will be the menu entry displayed in the menu list. For example:
流文件的名称将是菜单列表中显示的菜单项。举例来说：

```
examples\My Great Example.json
```

will display as 将显示为

```
My Great Example
```

# Internationalisation 国际化

If a node is [packaged](https://nodered.org/docs/creating-nodes/packaging) as a proper module, it can include a message catalog in order to provide translated content in the editor and runtime.
如果一个节点被[打包](https://nodered.org/docs/creating-nodes/packaging)为一个适当的模块，它可以包含一个消息目录，以便在编辑器和运行时中提供翻译后的内容。

For each node identified in the module’s `package.json`, a corresponding set of message catalogs and help files can be included alongside the node’s `.js` file.
对于在模块的`package.json`中标识的每个节点，可以在节点的`.js`文件旁边包含一组相应的消息目录和帮助文件。

Given a node identified as:
给定一个节点，标识为：

```
"name": "my-node-module",
"node-red": {
    "myNode": "myNode/my-node.js"
}
```

The following message catalogs may exist:
可能存在以下消息目录：

```
myNode/locales/__language__/my-node.json
myNode/locales/__language__/my-node.html
```

The `locales` directory must be in the same directory as the node’s `.js` file.
`locales`目录必须与节点的`.js`文件位于同一目录中。

The `__language__` part of the path identifies the language the corresponding files provide. By default, Node-RED uses `en-US`.
路径的_`_language__`部分标识相应文件提供的语言。默认情况下，Node-RED使用`en-US`。

#### Message Catalog 消息目录

The message catalog is a JSON file containing any pieces of text that the node may display in the editor or log in the runtime.
消息目录是一个JSON文件，其中包含节点可能在编辑器中显示的任何文本片段或运行时中的日志。

For example: 举例来说：

```
{
    "myNode" : {
        "message1": "This is my first message",
        "message2": "This is my second message"
    }
}
```

The catalog is loaded under a namespace specific to the node. For the node defined above, this catalog would be available under the `my-node-module/myNode` namespace.
目录在特定于节点的命名空间下加载。对于上面定义的节点，这个目录将在`my-node-module/myNode`名称空间下可用。

The core nodes use the `node-red` namespace.
核心节点使用`node-red`命名空间。

#### Help Text 帮助文本

The help file provides translated versions of the node’s help text that gets displayed within the Info sidebar tab of the editor.
帮助文件提供节点帮助文本的翻译版本，这些文本显示在编辑器的Info侧边栏选项卡中。

### Using i18n messages 使用i18 n消息

In both the runtime and editor, functions are provided for nodes to look-up messages from the catalogs. These are pre-scoped to the nodes own namespace so it isn’t necessary to include the namespace in the message identifier.
在运行时和编辑器中，都为节点提供了从目录中查找消息的函数。这些名称空间预先限定在节点自己的名称空间内，因此没有必要在消息标识符中包含名称空间。

#### Runtime 运行时

The runtime part of a node can access messages using the `RED._()` function. For example:
节点的运行时部分可以使用RED访问消息`。（）`函数。举例来说：

```
console.log(RED._("myNode.message1"));
```

#### Status messages 状态消息

If a node sends [status messages](https://nodered.org/docs/creating-nodes/status) to the editor, it should set the `text` of the status as the message identifier.
如果节点向编辑器发送[状态消息](https://nodered.org/docs/creating-nodes/status)，则它应将 状态的`文本`作为消息标识符。

```
this.status({fill:"green",shape:"dot",text:"myNode.status.ready"});
```

There are a number of commonly used status messages in the core node-red catalog. These can be used by including the namespace in the message identified:
在核心node-red目录中有许多常用的状态消息。这些可以通过在标识的消息中包含名称空间来使用：

```
this.status({fill:"green",shape:"dot",text:"node-red:common.status.connected"});
```

#### Editor 编辑器

Any HTML element provided in the node template can specify a `data-i18n` attribute to provide the message identify to use. For example:
节点模板中提供的任何HTML元素都可以指定一个`data-i18 n`属性来提供要使用的消息标识。举例来说：

```
<span data-i18n="myNode.label.foo"></span>
```

By default, the text content of an element is replace by the message identified. It is also possible to set attributes of the element, such as the `placeholder` of an `<input>`:
默认情况下，元素的文本内容被标识的消息替换。还可以设置元素的属性，例如`占位符` 一个`<input>`：

```
<input type="text" data-i18n="[placeholder]myNode.placeholder.foo">
```

It is possible to combine these to specify multiple substitutions. For example, to set both the title attribute and the displayed text:
可以将这些联合收割机组合以指定多个替换。例如，要设置title属性和显示的文本：

```
<a href="#" data-i18n="[title]myNode.label.linkTitle;myNode.label.linkText"></a>
```

As well as the `data-i18n` attribute for html elements, all node definition functions (for example, `oneditprepare`) can use `this._()` to retrieve messages.
除了html元素的`data-i18 n`属性，所有节点定义函数（例如`oneditprepare`）都可以使用`它。（）`检索消息。

# Loading extra resources in the editor 在编辑器中加载额外的资源

*Since Node-RED 1.3 自Node-RED 1.3起*

A node may need to load extra resources in the editor. For example, to include images in its help or to use external JavaScript and CSS files.
节点可能需要在编辑器中加载额外的资源。例如，在帮助中包含图像或使用外部JavaScript和CSS文件。

In earlier versions of Node-RED, the node would have to create custom HTTP Admin end-points to serve up those resources.
在Node-RED的早期版本中，节点必须创建自定义的HTTP Admin端点来提供这些资源。

With Node-RED 1.3 or later, if a module has a directory called `resources` at the top level, the runtime will make anything in that directory available to the editor under the url `/resources/<name-of-module>/<path-to-resource>`.
对于Node-RED 1.3或更高版本，如果模块在顶层有一个名为`resources的`目录，则运行时将使该目录中的任何内容可用于url `/resources/<name-of-module>/<path-to-resource>` 下的编辑器。

For example, given the following module structure:
例如，给定以下模块结构：

```
node-red-node-example
 |- resources
 |   |- image.png
 |   \- library.js
 |- example-node.js
 |- example-node.html
 \- package.json
```

A default Node-RED configuration will expose those resource files as:
默认的Node-RED配置将这些资源文件公开为：

- `http://localhost:1880/resources/node-red-node-example/image.png`
- `http://localhost:1880/resources/node-red-node-example/library.js`

**Note**: If using scoped module names then the scope needs to be included in the path:
**注意**：如果使用有作用域的模块名，那么作用域需要包含在路径中：

- `http://localhost:1880/resources/@scope/node-red-contrib-your-package/somefile`

### Loading resources in the editor 在编辑器中加载资源

When loading resources in the editor, the node must use relative URLs rather than absolute URLs. This allows the browser to resolve the URL relative to the editor URL and removes the need for the node to know anything about how its root paths are configured.
在编辑器中加载资源时，节点必须使用相对URL而不是绝对URL。这允许浏览器解析相对于编辑器URL的URL，并消除了节点了解其根路径如何配置的需要。

Using the above example, the following HTML can be used to load those resources in the editor:
使用上面的示例，可以使用以下HTML在编辑器中加载这些资源：

- `<img src="resources/node-red-node-example/image.png" />`
- `<script src="resources/node-red-node-example/library.js">`

Note the URLs do not start with a `/`.
请注意，URL不以/开头。``

# Packaging a Subflow as a module 将子流打包为模块

**Subflow Modules were added in Node-RED 1.3.
Node-RED 1.3中添加了子流模块。**
 They should be considered experimental at this stage. If you chose to publish your own Subflow, please ensure it has been thoroughly tested. 
现阶段应将其视为试验性的。如果你选择出版 您自己的子流，请确保它已经过彻底测试。

Subflows can be packaged as npm modules and distributed like any other node.
子流可以打包为npm模块，并像任何其他节点一样分发。

When they are installed, they will appear in the palette as regular nodes.  Users are not able to see or modify the flow inside the subflow.
安装后，它们将作为常规节点出现在选项板中。用户无法查看或修改子流中的流。

At this stage, creating Subflow module is a manual process that requires  hand-editing the Subflow JSON. We will provide tooling in the future to  help automate this - but for now, these instructions should help you get started.
在这个阶段，创建Subflow模块是一个手动过程，需要手动编辑Subflow JSON。我们将在将来提供工具来帮助自动化这一点-但现在，这些说明应该可以帮助您开始。

### Creating a subflow 创建子流

Any subflow can be packaged as a module. Before you do so, you need to  think about how it will be used. The following checklist is a useful  reminder of the things to consider:
任何子流都可以打包为一个模块。在此之前，您需要考虑如何使用它。下面的清单是一个有用的提醒要考虑的事情：

- Configuration - what will the user need to configure in the subflow. You can define  subflow properties and what UI is provided to set those properties via  the [Subflow Properties edit dialog](https://nodered.org/docs/user-guide/editor/workspace/subflows#editing-subflow-properties).
  配置-用户需要在子流中配置什么。您可以定义子流属性，以及通过[子流属性编辑对话框](https://nodered.org/docs/user-guide/editor/workspace/subflows#editing-subflow-properties)设置这些属性所提供的UI。
- Error handling - does your subflow handle its errors properly? Some errors  might make sense to handle inside the subflow, some may need to be  passed out of the subflow to allow the end user to handle them.
  错误处理-你的子流是否正确地处理了它的错误？有些错误可能需要在子流内部处理，有些可能需要传递到子流之外，以允许最终用户处理它们。
- Status - you can add a custom status output to your Subflow that can be handled by the ‘Status’ node.
  状态-您可以将自定义状态输出添加到您的子流，该子流可以由“状态”节点处理。
- Appearance - make sure to give your subflow an icon, colour and category that makes sense for the function it provides.
  外观-确保给你的子流一个图标，颜色和类别，这对它提供的功能是有意义的。

### Adding subflow metadata 添加子流元数据

The Subflow can hold additional metadata that can be used to define the module it will be packaged in.
子流可以保存额外的元数据，这些元数据可用于定义它将被打包到其中的模块。

On the [Subflow Module Properties edit dialog](https://nodered.org/docs/user-guide/editor/workspace/subflows#editing-subflow-metadata) you can set the following properties:
在“[子流模块属性”编辑对话框](https://nodered.org/docs/user-guide/editor/workspace/subflows#editing-subflow-metadata)中，可以设置以下属性：

- `Module` - the npm package name
  `Module`-npm包名
- `Node Type` - this will default to the `id` property of the subflow. It is helpful to provide a better type value.  As with regular node types, it must be unique to avoid conflicts with  other nodes.
  `节点类型`-这将默认为子流的`id`属性。提供一个更好的类型值是有帮助的。与常规节点类型一样，它必须是唯一的，以避免与其他节点冲突。
- `Version`
  `版本`
- `Description`
  `描述`
- `License`
  `许可证`
- `Author` `作者`
- `Keywords`
  `关键词`

### Creating the module 创建模块

This is where the manual work outside of Node-RED comes in.
这就是Node-RED之外的手动工作的用武之地。

1. create a directory with the name you want to give the module. For this example, we’ll use `node-red-example-subflow`.
   创建一个目录，你想给这个模块命名。在本例中，我们将使用`node-red-example-subflow`。

   mkdir node-red-example-subflow   cd node-red-example-subflow

2. Use `npm init` to create a `package.json` file:
   使用`npm init`创建一个`package.json`文件：

   npm init

It will ask a series of questions - provide matching answers to the values you added to the subflow metadata.
它将提出一系列问题-为您添加到子流元数据的值提供匹配的答案。

1. Add a `README.md` file - as all good modules must have a README.
   添加一个`README.md`文件-因为所有好的模块都必须有一个README。

2. Create a JavaScript wrapper for your module. For this example, we’ll use `example.js`:
   为模块创建一个JavaScript包装器。在这个例子中，我们将使用`example.js`：

   ```
    const fs = require("fs");
    const path = require("path");
   
    module.exports = function(RED) {
        const subflowFile = path.join(__dirname,"subflow.json");
        const subflowContents = fs.readFileSync(subflowFile);
        const subflowJSON = JSON.parse(subflowContents);
        RED.nodes.registerSubflow(subflowJSON);
    }
   ```

   This reads the contents of a file called `subflow.json` - which we’ll create in a moment - parses it and then passes it to the `RED.nodes.registerSubflow` function.
   它读取一个名为`subflow.json的`文件的内容--我们稍后将创建这个文件--解析它，然后将它传递给`RED.nodes.registerSubflow`函数。

### Add your subflow json 添加子流json

With all of that in place, you can now add your subflow to the module. This requires some careful editing of the subflow json.
完成所有这些之后，您现在可以将子流添加到模块中。这需要仔细编辑json子流。

1. In the Node-RED editor, add a new instance of your subflow to the workspace.
   在Node-RED编辑器中，将子流的新实例添加到工作区。
2. With the instance selected, export the node (`Ctrl-E` or `Menu->Export`) and paste the JSON into a text editor. The next steps will be easier if you select the ‘formatted’ option on the JSON tab of the Export dialog.
   选择实例后，导出节点（`Ctrl-E`或`Menu->Export`）并将JSON粘贴到文本编辑器中。如果您在导出对话框的JSON选项卡上选择“格式化”选项，则接下来的步骤会更容易。

The JSON is structured as an Array of Node objects. The last-but-one entry  is the Subflow Definition and the last entry is the Subflow Instance you added to the workspace.
JSON的结构是Node对象的数组。倒数第二个条目是子流定义，最后一个条目是您添加到工作区的子流实例。

```
[
   { "id": "Node 1", ... },
   { "id": "Node 2", ... },
   ...
   { "id": "Node n", ... },
   { "id": "Subflow Definition Node", ... },
   { "id": "Subflow Instance Node", ... }
]
```

1. Delete the Subflow Instance Node - the last entry in the Array.
   删除子流实例节点-阵列中的最后一个条目。
2. Move the Subflow Definition Node to the top of the file - above the opening `[` of the Array
   将子流定义节点移动到文件的顶部-在[数组]``
3. Move the remaining Array of nodes *inside* the Subflow Definition Node as a new property called `"flow"`.
   将子流定义节点*中*剩余的节点数组作为名为`“flow”`的新属性移动。
4. Make sure you tidy up any trailing commas between the moved entries.
   请确保整理移动的条目之间的所有尾随逗号。
5. Save this file as `subflow.json`
   将此文件保存为`subflow.json`

```
{
    "id": "Subflow Definition Node",
    ...
    "flow": [
       { "id": "Node 1", ... },
       { "id": "Node 2", ... },
       ...
       { "id": "Node n", ... }
    ]
}
```

### Update your package.json 更新您的package.json

The final task is to update your `package.json` so that Node-RED knows what your module contains.
最后一项任务是更新`package.json`，以便Node-RED知道模块包含的内容。

Add a `"node-red"` section, with a `"nodes"` section containing an entry for your `.js` file:
添加一个`“node-red”`部分，其中`“nodes”`部分包含`.js`文件的条目：

```
{
    "name": "node-red-example-subflow",
    ...
    "node-red": {
        "nodes": {
            "example-node": "example.js"
        }
    }
}
```

### Adding dependencies 添加依赖项

If your subflow uses any non-default nodes, you must make sure your `package.json` file lists them as dependencies. This will ensure they will get installed alongside your module.
如果您的子流使用任何非默认节点，则必须确保`package.json`文件将它们列为依赖项。这将确保它们与您的模块一起安装。

The modules are listed in the standard top-level `"dependencies"` section *and* a `"dependencies"` section in the `"node-red"` section.
这些模块列在标准的顶层`“dependencies”`部分*和*`“node-red”`部分的`“dependencies”`

```
{
    "name": "node-red-example-subflow",
    ...
    "node-red": {
        "nodes": {
            "example-node": "example.js"
        },
        "dependencies": [
            "node-red-node-random"
        ]
    },
    "dependencies": {
        "node-red-node-random": "1.2.3"
    }
}
```