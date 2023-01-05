# Puppet services and tools

Puppet provides a number of core services and        administrative tools to manage systems with or without  a primary Puppet server, and to compile configurations for Puppet agents. 



**[Puppet commands](https://www.puppet.com/docs/puppet/7/services_commands.html#services_commands)**
Puppet’s command line         interface (CLI) consists of a single `puppet` command with many subcommands. **[Running Puppet commands on Windows](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#services_commands_windows)**
         Puppet was originally designed to run on *nix systems, so its commands generally act the way *nix admins expect. Because Windows systems work differently, there are a few extra         things to keep in mind when using Puppet         commands. **[Puppet agent on \*nix systems](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#services_agent_unix)**
Puppet agent is the         application that manages the configurations on your nodes. It requires a Puppet primary server to fetch configuration catalogs         from. **[Puppet agent on Windows](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows)**
Puppet agent is the application that manages         configurations on your nodes. It requires a Puppet primary         server to fetch configuration catalogs. **[Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#services_apply)**
Puppet apply is an         application that compiles and manages  configurations on nodes. It acts like a self-contained          combination of the Puppet primary server and Puppet agent applications.  **[Puppet device](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device)**
With Puppet device, you can         manage network devices, such as routers,  switches, firewalls, and Internet of Things (IOT)         devices,  without installing a Puppet agent on them. Devices         that cannot run Puppet applications require a Puppet agent to act as a proxy. The proxy manages         certificates,  collects facts, retrieves and applies catalogs, and stores reports on  behalf         of a device.

# Puppet commands

### Sections

[ Puppet agent](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-agent)

[                 Puppet Server             ](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-server)

[ Puppet apply](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-apply)

[ Puppet ssl](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-ssl)

[ Puppet module](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-module)

[ Puppet resource](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-resource)

[ Puppet config](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-config)

[ Puppet parser](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-parser)

[ Puppet help and Puppet man](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-help)

[Full list of subcommands](https://www.puppet.com/docs/puppet/7/services_commands.html#full-list-subcommands)

Puppet’s command line        interface (CLI) consists of a single `puppet` command with many subcommands.

Puppet Server and Puppet’s companion utilities  [                 Facter             ](https://puppet.com/docs/facter/3.11/index.html) and  [                 Hiera             ](https://www.puppet.com/docs/puppet/7/hiera.html), have their own CLI.

## Puppet agent

Puppet agent is a core service that                manages systems, with the help of a Puppet primary server. It                requests a configuration catalog from a Puppet primary server                server, then ensures that all resources in that catalog are in their desired                state.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            Puppet                            [ Agent on                                     *nix systems ](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#services_agent_unix)                        
- ​                            Puppet                            [ Agent on                                     Windows systems ](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows)                        
- ​                            Puppet                            [ Agent’s man page](https://www.puppet.com/docs/puppet/7/man/agent.html)                        

##                 Puppet Server            

Using Puppet code and various other                data sources, Puppet Server compiles configurations for any                number of Puppet agents.

Puppet Server is a core service and has                its own subcommand, `puppetserver`, which isn’t prefaced by the usual `puppet` subcommand.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            [                                 Puppet Server                             ](https://puppet.com/docs/puppetserver/latest/services_master_puppetserver.html)                        
- ​                            [Puppet Server subcommands                             ](https://puppet.com/docs/puppetserver/latest/subcommands.html)                        

## Puppet apply

Puppet apply is a core command that                manages systems without contacting a Puppet primary                server. Using Puppet modules and various other data                sources, it compiles its own configuration catalog, and then immediately applies the                catalog.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            [Puppet                                 apply](https://www.puppet.com/docs/puppet/7/services_apply.html#services_apply)                        
- ​                            [Puppet apply’s man page](https://www.puppet.com/docs/puppet/7/man/apply.html)                        

## Puppet ssl

Puppet ssl is a command for                managing SSL keys and certificates for Puppet SSL                clients needing to communicate with your Puppetinfrastructure. 

Puppet ssl usage: `puppet ssl <action> [--certname <name>]`

Possible actions:

- `submit request`: Generate a certificate signing request                            (CSR) and submit it to the CA. If a private and public key pair already                            exist, they are used to generate the CSR. Otherwise, a new key pair is                            generated. If a CSR has already been submitted with the given `certname,`                            then the operation fails.
- `download_cert`: Download a certificate for this host. If                            the current private key matches the downloaded certificate, then the                            certificate is saved and used for subsequent requests. If there is                            already an existing certificate, it is overwritten.
- `verify`: Verify that the private key and                            certificate are present and match. Verify the certificate is issued                            by a trusted CA, and check the revocation status
- `bootstrap`: Perform all of the steps necessary to request and                        download a client certificate. If autosigning is disabled, then puppet will                        wait every `waitforcert`                        seconds for its certificate to be signed. To only attempt once and never                        wait, specify a time of 0. Since `waitforcert` is a Puppet setting, it can be specified as a time                        interval, such as 30s, 5m, 1h.

For more information, see the [SSL man page](https://www.puppet.com/docs/puppet/7/man/ssl.html). 

## Puppet module

Puppet module is a multi-purpose                administrative tool for working with Puppet modules.                It can install and upgrade new modules from the Puppet[ Forge](https://forge.puppetlabs.com/), help generate new modules, and package modules                for public release.

For more information, see: 

- ​                            [                                 Module fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals)                        
- ​                            [                                 Installing modules](https://www.puppet.com/docs/puppet/7/modules_installing.html#modules_installing)                        
- ​                            [                                 Publishing modules on the Puppet Forge ](https://www.puppet.com/docs/puppet/7/modules_publishing.html#modules_publishing)                        
- ​                            Puppet                            [                                 Module’s man page](https://www.puppet.com/docs/puppet/7/man/module.html)                        

## Puppet resource

Puppet resource is an                administrative tool that lets you inspect and manipulate resources on a system. It                can work with any resource type Puppet knows about.                For more information, see Puppet[ Resource’s man page](https://www.puppet.com/docs/puppet/7/man/resource.html).

## Puppet config

Puppet config is an administrative                tool that lets you view and change Puppet                settings.

For more information, see: 

- ​                            [                                 About Puppet’s                                 settings ](https://www.puppet.com/docs/puppet/7/config_about_settings.html#config_about_settings)                        
- ​                            [                                 Checking values of settings](https://www.puppet.com/docs/puppet/7/config_print.html)                        
- ​                            [                                 Editing settings on the command line](https://www.puppet.com/docs/puppet/7/config_set.html)                        
- ​                            [                                 Short list of important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings)                        
- ​                            Puppet                            [ Config’s man page](https://www.puppet.com/docs/puppet/7/man/config.html)                        

## Puppet parser

Puppet parser lets you validate Puppet code to make sure it contains no syntax                errors. It can be a useful part of your continuous integration toolchain. For more                information, see Puppet[ Parser’s man page](https://www.puppet.com/docs/puppet/7/man/parser.html).

## Puppet help and Puppet man

Puppet help and Puppet man can display online help for Puppet’s other subcommands.

For more information, see: 

- ​                            [Puppet help’s man                                 page ](https://www.puppet.com/docs/puppet/7/man/help.html)                        

## Full list of subcommands

For a full list of Puppet subcommands, see [Puppet’s                     subcommands](https://www.puppet.com/docs/puppet/7/man/overview.html).

# Running Puppet commands on Windows    

### Sections

[Supported commands](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#supported-commands)

[Running Puppet's commands](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#running-commands)

[Running with administrator                 privileges](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#running-administrator-privileges)

[The Puppet Start menu items](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#start_menu_items)

[Configuration settings](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#config_settings)

​        Puppet was originally designed to run on *nix systems, so its commands generally act the way *nix admins expect. Because Windows systems work differently, there are a few extra        things to keep in mind when using Puppet        commands.

## Supported commands

Not all Puppet commands work on Windows. Notably, Windows nodes can’t run the `puppet server` or `puppetserver ca`                commands.

The following commands are designed for use on Windows: 

- ​                        [                                 `puppet                                     agent`                             ](https://www.puppet.com/docs/puppet/7/man/agent.html)                        
- ​                        [                                 `puppet                                     apply`                             ](https://www.puppet.com/docs/puppet/7/man/apply.html)                        
- ​                        [                                 `puppet                                     module`                             ](https://www.puppet.com/docs/puppet/7/man/module.html)                        
- ​                        [                                 `puppet                                     resource`                             ](https://www.puppet.com/docs/puppet/7/man/resource.html)                        
- ​                        [                                 `puppet                                     config`                             ](https://www.puppet.com/docs/puppet/7/man/config.html)                        
- ​                        [                                 `puppet                                     lookup`                             ](https://www.puppet.com/docs/puppet/7/man/lookup.html)                        
- ​                        [                                 `puppet                                     help`                             ](https://www.puppet.com/docs/puppet/7/man/help.html)                        

## Running Puppet's commands

The                installer adds Puppet commands to the PATH. After                installing, you can run them from any command prompt                (cmd.exe) or PowerShell prompt.

Open a new                command prompt after installing. Any processes that were already running before you                ran the installer do not pick up the changed PATH value.

## Running with administrator                privileges

You usually want to run Puppet’s commands with administrator                privileges.

Puppet has two privilege modes: 

- Run with limited privileges, only                            manage certain resource types, and use a user-specific  [                                 `confdir`                             ](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and  [ codedir ](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)                        
- Run with administrator privileges,                            manage the whole system, and use the system  [                                 `confdir`                             ](https://www.puppet.com/docs/puppet/7/dirs_confdir.html)and  [                                 codedir ](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)                        

On *nix systems, Puppet defaults to running with limited privileges,                when not run by `root`, but can have its privileges raised with the                standard sudo command.

​                Windows systems don’t use sudo, so escalating                privileges works differently.

Newer versions of Windows manage security with User Account Control                (UAC), which was added in Windows 2008 and Windows Vista. With UAC, most programs run by                administrators still have limited privileges. To get administrator privileges, the                process has to request those privileges when it starts.

To                run Puppet's commands in adminstrator mode, you must                first start a Powershell command prompt with administrator privileges.

Right-click the Start (or apps screen tile) -> Run as administrator: 
![img](https://www.puppet.com/docs/puppet/7/run_as_admin.png)
            

Click Yes to allow the command prompt to run with elevated privaleges:                    
![img](https://www.puppet.com/docs/puppet/7/uac.png)
            

The title bar on the comand prompt window begins with                    Administrator. This                means Puppet commands that run from that window can                manage the whole system. 
![img](https://www.puppet.com/docs/puppet/7/windows_administrator_prompt.png)
            

## The Puppet Start menu items

​        Puppet’s installer adds a folder of shortcut items to the            Start Menu.

​            
![img](https://www.puppet.com/docs/puppet/7/start_menu.png)
​        

These items aren’t necessary for working with Puppet, because Puppet            agent runs a normal  [Windows service](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows) and the Puppet commands            work from any command or PowerShell prompt. They’re provided solely as conveniences. 

The Start            menu items do the following: 

- Run Facter                    

  This shortcut requests UAC elevation and, using the CLI,                        runs  [Facter](https://puppet.com/docs/facter/) with administrator privileges. 

- Run Puppet agent

  This shortcut requests UAC elevation and, using the CLI,                        performs a single Puppet agent command with                        administrator privileges.

- Start Command Prompt with Puppet                    

  This shortcut starts a normal command prompt with the                        working directory set to Puppet's program                        directory. The CLI window icon is also set to the Puppet logo. This shortcut was particularly                        useful in previous versions of Puppet, before                            Puppet's commands were added to the PATH                        at installation time.  Note: This                            shortcut does not automatically request UAC elevation; just                            like with a normal command prompt, you'll need to right-click the icon                            and choose Run as                                administrator.                    

## Configuration settings

Configuration settings can be viewed and modified using        the CLI.

To get configuration settings, run: `puppet agent --configprint <SETTING>`

To set configuration settings, run: `puppet config set <SETTING VALUE> --section                <SECTION`>

When running Puppet commands on Windows, note the following:

- The location of `puppet.conf` depends                        on whether the process is running as an administrator or not.
- Specifying file owner, group, or mode                        for file-based settings is not supported on Windows.
- The `puppet.conf` configuration                        file supports Windows-style CRLF line endings                        as well as *nix-style LF line endings. It does                        not support Byte Order Mark (BOM). The file encoding must either be UTF-8 or                        the current Windows encoding, for example,                            Windows-1252 code page.
- Common configuration settings                            are `certname`, `server`, and `runinterval`.
- You must restart the Puppet agent service after making any changes                        to Puppet’s `runinterval` config file                        setting.

# Puppet apply

### Sections

[Supported                 platforms](https://www.puppet.com/docs/puppet/7/services_apply.html#supported-platforms)

[ Puppet apply's run environment](https://www.puppet.com/docs/puppet/7/services_apply.html#puppet_apply_run_env)

- [Main manifest](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-manifest)
- [User](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-user)
- [Network access](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-network-access)
- [Logging](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-logging)
- [Reporting](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-reporting)

[Managing systems with Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#manage_systems_with_puppet_apply)

[Configuring Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#configure_puppet_apply)

Puppet apply is an        application that compiles and manages configurations on nodes. It acts like a self-contained        combination of the Puppet primary server and Puppet agent applications. 

For details about invoking the `puppet apply` command, see the [puppet apply man page](https://www.puppet.com/docs/puppet/7/man/apply.html).

## Supported                platforms

Puppet apply                runs similarly on *nix and Windows systems. Not all operating systems can manage                the same resources with Puppet; some resource types                are OS-specific, and others have OS-specific features. For more information, see                    the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html).

## Puppet apply's run environment

Unlike Puppet agent, Puppet apply never runs as a daemon or service. It runs as a        single task in the foreground, which compiles a catalog, applies it, files a report, and        exits.

By default, it never initiates outbound network connections, although it can be            configured to do so, and it never accepts inbound network connections.

### Main manifest

Like the primary                    Puppet server application, Puppet apply uses its [settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings) (such as `basemodulepath`) and the configured [environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about) to locate the Puppet code and configuration data it uses when                compiling a catalog.

The one exception is the [main manifest](https://www.puppet.com/docs/puppet/7/dirs_manifest.html). Puppet apply always requires a single command line                argument, which acts as its main manifest. It ignores the main manifest from                its environment.

Alternatively, you can write a main manifest directly                using the command line, with the `-e` option. For more information, see the [puppet apply man page](https://www.puppet.com/docs/puppet/7/man/apply.html).

### User

​                Puppet apply runs as whichever user executed the Puppet apply command.

To manage a complete                system, run Puppet apply as:

- ​                            `root` on *nix systems.
- Either `LocalService` or a member of                                the `Administrators` group                            on Windows systems.

​                Puppet apply can also run as a non-root user. When                running without root permissions, most of Puppet’s                resource providers cannot use `sudo` to                elevate permissions. This means Puppet can only                manage resources that its user can modify without using `sudo`.

Of the core resource types listed in the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html), the following                are available to non-root agents:

| Resource type        | Details                                                      |
| -------------------- | ------------------------------------------------------------ |
| `augeas`             |                                                              |
| `cron`               | Only non-root cron jobs can be viewed or set.                |
| `exec`               | Cannot run as another user or group.                         |
| `file`               | Only if the non-root user has read/write privileges.         |
| `notify`             |                                                              |
| `schedule`           |                                                              |
| `service`            | For services that don’t require root. You can also use                                        the `start`, `stop`, and `status` attributes to specify                                    how non-root users can control the service. For more                                    information, see tips and examples for the [                                         `service`                                     ](https://www.puppet.com/docs/puppet/7/resources_service.html#resources_service) type. |
| `ssh_authorized_key` |                                                              |
| `ssh_key`            |                                                              |

To install packages into a directory controlled by a non-root user, you can                either use an `exec` to unzip a tarball or                use a recursive `file` resource to copy a                directory into place.

### Network access

By                default, Puppet apply does not communicate over the                network. It uses its local collection of modules for any file sources, and                does not submit reports to a central server.

Depending on your system and the                resources you are managing, it might download packages from your configured package                repositories or access files on UNC shares.

If you have configured                    an [external node classifier (ENC)](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers), your ENC script might                create an outbound HTTP connection. Additionally, if you’ve configured                    the [HTTP report                     processor](https://www.puppet.com/docs/puppet/7/report.html), Puppet agent sends reports via                HTTP or HTTPS.

If you have configured PuppetDB, Puppet apply                creates outbound HTTPS connections to PuppetDB.

### Logging

​                Puppet apply logs directly to the terminal, which is                good for interactive use, but less so when running as a scheduled task or cron job. 

You can adjust how verbose the logs are with the [                     `log_level`](https://www.puppet.com/docs/puppet/7/configuration.html) setting, which defaults to                    `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You                can also make logs quieter by setting it to `warning`                or lower. 

When started with the `--logdest                syslog` option, Puppet apply logs to the                    *nix syslog service. Your syslog configuration                dictates where these messages are saved, but the default location is `/var/log/messages` on Linux, and `/var/log/system.logon`                Mac OS X.

When started with the `--logdest eventlog` option, it logs to the Windows Event Log. You can view its logs by browsing                the Event Viewer. Click Control Panel                -> System and Security -> Administrative                    Tools -> Event Viewer.

When started                with the `--logdest <FILE>` option, it                logs to the file specified by `<FILE>`.

### Reporting

In addition to                local logging, Puppet apply processes a report using                its configured [report                     handlers](https://www.puppet.com/docs/puppet/7/report.html), like a primary Puppet server                does. Using the [`reports`                 ](https://www.puppet.com/docs/puppet/7/configuration.html) setting, you can enable different reports. For more information, see the                list of available [reports](https://www.puppet.com/docs/puppet/7/report.html). For information about reporting, see the                    [reporting](https://www.puppet.com/docs/puppet/7/reporting_about.html) documentation.

To disable reporting                and avoid taking up disk space with the `store` report handler, you can set [                     `report = false`                 ](https://www.puppet.com/docs/puppet/7/configuration.html) in [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html).

## Managing systems with Puppet apply

In a typical site, every node periodically does a Puppet run, to revert unwanted changes and to pick up recent        updates.

​            Puppet apply doesn’t run as a service, so you must            manually create a scheduled task or cron job if you want it to run on a regular basis,            instead of using Puppet agent.

On *nix, you can use the `puppet resource` command to            set up a cron job. 

This example runs Puppet one time per            hour, with Puppet Enterprise            paths:

```
sudo puppet resource cron puppet-apply ensure=present user=root minute=60 command='/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/puppet/manifests --logdest syslog'Copied!
```

## Configuring Puppet apply

Configure Puppet apply in            the `puppet.conf`        file, using the `[user]` section, the `[main]` section, or both.

For information on which settings are relevant to `puppet apply`, see [important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings).

# Puppet device

### Sections

[The Puppet device model ](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device_model_)

[ Puppet device’s run         environment](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_devices_run_environment)

- [User](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-user)
- [Logging ](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-logging)
- [Network access](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-network-access)

[Installing device modules](https://www.puppet.com/docs/puppet/7/puppet_device.html#installing_device_modules)

[Configuring Puppet device on the         proxy Puppet agent](https://www.puppet.com/docs/puppet/7/puppet_device.html#configuring_puppet_device_on_the_proxy_puppet_agent)

[Classify the proxy Puppet agent for         the device](https://www.puppet.com/docs/puppet/7/puppet_device.html#classify_proxy_puppet_agent)

[Classify the device ](https://www.puppet.com/docs/puppet/7/puppet_device.html#classify_device_to_manage_resources)

[Get and set data using Puppet       device](https://www.puppet.com/docs/puppet/7/puppet_device.html#get_and_set_data_using_puppet_device)

- [ **Get device data with the `resource` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#resource-parameter)
- [ **Set device data with the `apply` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#apply-parameter)
- [ **View device facts with the `facts` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#facts-parameter)

[Managing devices using Puppet     device](https://www.puppet.com/docs/puppet/7/puppet_device.html#managing_devices_using_puppet_device)

- [Example](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet-device-example)

[Automating device management using the puppetlabs device_manager         module](https://www.puppet.com/docs/puppet/7/puppet_device.html#device_manager_module)

[Troubleshooting Puppet         device](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device_troubleshooting)

Expand

With Puppet device, you can        manage network devices, such as routers, switches, firewalls, and Internet of Things (IOT)        devices, without installing a Puppet agent on them. Devices        that cannot run Puppet applications require a Puppet agent to act as a proxy. The proxy manages        certificates, collects facts, retrieves and applies catalogs, and stores reports on behalf        of a device.

​            Puppet device runs on both *nix and Windows. The Puppet device application combines some of the            functionality of the Puppet apply and Puppet resource applications. For details about running            the Puppet device application, see the [                 `puppet device` man                 page](https://www.puppet.com/docs/puppet/7/man/device.html).

Note: If you are writing a module for a remote                resource, we recommend using transports instead of devices. Transports have extended                functionality and can be used with other workflows, such as with [                     Bolt                 ](https://puppet.com/docs/bolt/latest/bolt.html). For more information on transports and how to port your existing code, see                    [Resource API                     Transports](https://www.puppet.com/docs/puppet/7/about_the_resource_api.html#resource_api_transports).

## The Puppet device model 

In a typical deployment model, a Puppet agent is installed on each system managed by Puppet. However, not all systems can have agents installed on        them.

For these devices, you can configure a Puppet agent on            another system which connects to the API or CLI of the device, and acts as a proxy            between the device and the primaryPuppet server.

In the diagram below, Puppet device is on a proxy Puppet agent (agent.example.com) and is being used to            manage an F5 load balancer (f5.example.com) and a Cisco switch (cisco.example.com).

![img](https://www.puppet.com/docs/puppet/7/devices_diagram.png)

## Puppet device’s run        environment

Puppet device runs as a        single process in the foreground that manages devices, rather than as a daemon or service        like a Puppet agent.

### User

The `puppet                    device` command runs with the privileges of the user who runs it. 

Run Puppet device as:

- Root on *nix
- Either LocalService or a member of the                        Administrators group on Windows

### Logging 

By default, Puppet device outputs directly                to the terminal, which is valuable for interactive use. When you run it as a cron                job or scheduled task, use the `logdest` option to direct the output to a file.

On *nix, run Puppet device with the `--logdest syslog` option to log to the *nix syslog service:                

```
puppet device --verbose --logdest syslogCopied!
```

Your syslog configuration determines where these messages are saved, but the default location is                    `/var/log/messages` on Linux, and `/var/log/system.log` on Mac OS X. For                example, to view these logs on Linux,                run:

```
tail /var/log/messagesCopied!
```

On Windows, run Puppet device with the `--logdest eventlog` option, which logs to                the Windows Event Log, for example:                

```
puppet device --verbose --logdest eventlogCopied!
```

To view these logs on Windows, click Control                    Panel → System and                    Security → Administrative Tools → Event Viewer.

To specify a                particular file to send Puppet device log messages                to, use the `--logdest                    <FILE> option`, which logs to the file specified by `<FILE>`, for                example:                

```
puppet device --verbose --logdest /var/log/puppetlabs/puppet/device.log
Copied!
```

You can increase the logging level with the `--debug` and `--verbose` options. 

In addition to local logging, Puppet device submits reports to the                primary Puppet server after each run. These reports                contain standard data from the Puppet run, including                any corrective changes. 

### Network access

Puppet device creates outbound                network connections to the devices it manages. It requires network connectivity to                the devices via their API or CLI. It never accepts inbound network            connections.

## Installing device modules

You need to install the device module for each device you want to manage on the        primary Puppet server.

For example, to install the [f5](https://forge.puppet.com/puppetlabs/f5) and                [cisco_ios](https://github.com/puppetlabs/cisco_ios) device modules on the primary server, run the following            commands:

```
$ sudo puppet module install f5-f5Copied!
$ sudo puppet module install puppetlabs-cisco_iosCopied!
```

## Configuring Puppet device on the        proxy Puppet agent

You can specify multiple devices in `device.conf`, which is configurable with        the `deviceconfig` setting on        the proxy agent. 

For example, to configure an F5 and a Cisco IOS device, add the            following lines to the `device.conf` file:

```
[f5.example.com]
type f5
url https://username:password@f5.example.com

[cisco.example.com]
type cisco_ios
url file:///etc/puppetlabs/puppet/devices/cisco.example.com.yamlCopied!
```

The            string in the square brackets is the device’s certificate name — usually the hostname or            FQDN. The certificate name is how Puppet identifies the            device. 

For the `url`, specify the device’s connection string. The connection string varies            by device module. In the first example above, the F5 device connection credentials are            included in the `url`            `device.conf` file,            because that is how the F5 module stores credentials. However, the Cisco IOS module uses            the Puppet Resource API, which stores that information in            a separate credentials file. So, Cisco IOS devices would also have a `/etc/puppetlabs/puppet/devices/<device cert                name>.conf` file similar to the following content:

```
{
"address": "cisco.example.com"
"port": 22
"username": "username"
"password": "password"
"enable_password": "password"
}
}
Copied!
```

For more information, see `device.conf`. 

## Classify the proxy Puppet agent for        the device

Some device modules require the proxy Puppet agent to be classified with the base class of the        device module to install or configure resources required by the module. Refer to the        specific device module README for details.

To classify proxy Puppet agent:

1. Classify the agent with the base class of the                    device module, for each device it manages in the manifest. For example: 

   ```
   node 'agent.example.com' {
     include cisco_ios
     include f5
   }Copied!
   ```

2. ​                Apply the classification by running `puppet agent -t` on                    the proxy Puppet agent.            

## Classify the device 

Classify the device with resources to manage its  configuration.

The examples below manage DNS settings on an F5 and a Cisco IOS device.   

1. In the `site.pp` manifest, declare DNS resources for the devices. For example:

   ```
   node 'f5.example.com' {
    f5_dns{ '/Common/dns':
     name_servers => ['4.2.2.2.', '8.8.8.8"],
     same     => ['localhost",' example.com'],
    }
   }
   
   node 'cisco.example.com' {
    network_dns { 'default':
     servers => [4.2.2.2', '8.8.8.8'],
     search => ['localhost",'example.com'],
    }
   }
   Copied!
   ```

2. ​    Apply the manifest by running `puppet device -v` on the proxy Puppet agent.   

Results

Note: Resources vary by device module. Refer to the specific device module README for     details. 

## Get and set data using Puppet      device

The traditional Puppet apply      and Puppet resource applications cannot target device      resources: running `puppet resource         --target <DEVICE>` does not return data from the target device. Instead, use         Puppet device to get data from devices, and to set data on      devices. The following are optional parameters. 

### **Get device data with the `resource` parameter**         

Syntax:

```
puppet device --resource <RESOURCE> --target <DEVICE>Copied!
```

Use            the `resource` parameter            to retrieve resources from the target device. For example, to return the DNS values for            example F5 and Cisco IOS            devices:

```
sudo puppet device --resource f5_dns --target f5.example.com
sudo puppet device --resource network_dns --target cisco.example.comCopied!
```

### **Set device data with the `apply` parameter**         

Syntax:

```
puppet device --verbose --apply <FILE> --target <DEVICE>Copied!
```

Use            the `--apply` parameter to            set a local manifest to manage resources on a remote device. For example, to apply a Puppet manifest to the F5 and Cisco devices:            

```
sudo puppet device --verbose --apply manifest.pp --target f5.example.com
sudo puppet device --verbose --apply manifest.pp --target cisco.example.comCopied!
```

### **View device facts with the `facts` parameter**         

Syntax:

```
puppet device --verbose --facts --target <DEVICE>Copied!
```

Use            the `--facts` parameter to            display the facts of a remote target. For example, to display facts on a device:            

```
sudo puppet device --verbose --facts --target f5.example.comCopied!
```

## Managing devices using Puppet    device

Running the `puppet device` or `puppet-device` command (without `--resource` or `--apply` options) tells the proxy agent to retrieve catalogs from the primary server and    apply them to the remote devices listed in the `device.conf` file.

To run Puppet device on demand and for all      of the devices in `device.conf`      , run: 

```
sudo puppet device --verboseCopied!
```

To run Puppet device for only one of the      multiple devices in the `device.conf` file, specify a `--target` option: 

```
$ sudo puppet device -verbose --target f5.example.comCopied!
```

To run Puppet device on a      specific group of devices, as opposed to all devices in the `device.conf` file, create a separate configuration file      containing the devices you want to manage, and specify the file with the `--deviceconfig`      option:

```
$ sudo puppet device --verbose --deviceconfig /path/to/custom-device.confCopied!
```

To set up a cron job to run Puppet device      on a recurring schedule, run: 

```
$ sudo puppet resource cron puppet-device ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet device --verbose --logdest syslog'Copied!
```

### Example

Follow the steps below to run Puppet device in a        production environment, using `cisco_ios` as an example.

1. Install the module on the primary Puppet server: `sudo puppet module install puppetlabs-cisco_ios`.

2. Include the module on the proxy Puppet agent by adding the              following line to the primary server’s `site.pp`              file:

   ```
   include cisco_iosCopied!
   ```

3. Edit `device.conf` on the proxy Puppet agent:              

   ```
   [cisco.example.com]
   type cisco_ios
   url file:///etc/puppetlabs/puppet/devices/cisco.example.com.yamlCopied!
   ```

4. Create the `cisco.example.com` credentials file required by              modules that use the Puppet Resource              API:

   ```
   {
     "address": "cisco.example.com"
     "port": 22
     "username": "username"
     "password": "password"
     "enable_password": "password"
   }Copied!
   ```

5. Request a certificate on the proxy Puppet agent: `sudo puppet device --verbose --waitforcert 0 --target                cisco.example.com`            

6. Sign the certificate on the primary server: `sudo puppetserver ca sign                cisco.example.com`            

7. Run `puppet device` on the proxy Puppet agent to test the credentials: `sudo puppet device --target                cisco.example.com`            

## Automating device management using the puppetlabs device_manager        module

The `puppetlabs-device_manager` module manages the configuration files used by the            Puppet device application, applies the base class of        configured device modules, and provides additional resources for scheduling and        orchestrating Puppet device runs on proxy Puppet agents. 

For more information, see the module [README](https://forge.puppet.com/puppetlabs/device_manager).

## Troubleshooting Puppet        device

These options are useful for troubleshooting Puppet device command results.

| `--debug` or `-d`   | Enables debugging                   |
| ------------------- | ----------------------------------- |
| `--trace` or `-t`   | Enables stack tracing if Ruby fails |
| `--verbose` or `-v` | Enables detailed reporting          |

# 