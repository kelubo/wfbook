# bconsole

[TOC]

## 使用查询和开始 Job

bconsole是一个用于连接到Bareos控制器的Bareos控制台程序。由于Bareos是一个网络程序，您可以在网络上的任何地方运行控制台程序。然而，最常见的情况是，它与Bareos控制器在同一台机器上运行。通常，控制台程序将打印类似于以下内容的内容：

```bash
bconsole
Connecting to Director bareos:9101
Enter a period to cancel a command.
*
```

Type **help** to see a list of available commands:

```
*help
  Command       Description
  =======       ===========
  add           Add media to a pool
  autodisplay   Autodisplay console messages
  automount     Automount after label
  cancel        Cancel a job
  create        Create DB Pool from resource
  delete        Delete volume, pool or job
  disable       Disable a job
  enable        Enable a job
  estimate      Performs FileSet estimate, listing gives full listing
  exit          Terminate Bconsole session
  export        Export volumes from normal slots to import/export slots
  gui           Non-interactive gui mode
  help          Print help on specific command
  import        Import volumes from import/export slots to normal slots
  label         Label a tape
  list          List objects from catalog
  llist         Full or long list like list command
  messages      Display pending messages
  memory        Print current memory usage
  mount         Mount storage
  move          Move slots in an autochanger
  prune         Prune expired records from catalog
  purge         Purge records from catalog
  quit          Terminate Bconsole session
  query         Query catalog
  restore       Restore files
  relabel       Relabel a tape
  release       Release storage
  reload        Reload conf file
  rerun         Rerun a job
  run           Run a job
  status        Report status
  setbandwidth  Sets bandwidth
  setdebug      Sets debug level
  setip         Sets new client address -- if authorized
  show          Show resource records
  sqlquery      Use SQL to query catalog
  time          Print current time
  trace         Turn on/off trace to file
  unmount       Unmount storage
  umount        Umount - for old-time Unix guys, see unmount
  update        Update volume, pool or stats
  use           Use specific catalog
  var           Does variable expansion
  version       Print Director version
  wait          Wait until no jobs are running
```



