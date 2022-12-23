# Puppet agent on *nix systems

### Sections

[Puppet agent's run environment](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#nix_agent_run_env)

- [Ports](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#agent-run-environment-ports)
- [User](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#agent-run-environment-user)

[Manage systems with Puppet agent](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#manage_nix_systems_with_agent)

- [Run Puppet agent as a service](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#nix_agent_as_service)
- [Run Puppet agent as a cron         job](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#nix_agent_as_cron)
- [Run Puppet agent on demand](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#nix_agent_on_demand)

[Disable and re-enable Puppet                 runs](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#disable_nix_puppet_runs)

[Configuring Puppet                 agent](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#configuring_nix_agent)

- [Logging for Puppet agent on *nix systems](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#logging-puppet-agent-nix)
- [Reporting for Puppet agent on *nix systems](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#reporting-puppet-agent-nix)

Expand

Puppet agent is the        application that manages the configurations on your nodes. It requires a Puppet primary server to fetch configuration catalogs        from.

Depending on your infrastructure and needs, you can manage systems            with Puppet agent as a service, as a cron job, or on            demand.

For more information about running the `puppet agent` command, see the [puppet agent man page](https://www.puppet.com/docs/puppet/7/man/agent.html).

## Puppet agent's run environment

​        Puppet agent runs as a specific user, (usually `root`) and initiates outbound connections on port        8140.

### Ports

​                Puppet’s HTTPS traffic uses port 8140. Your operating                system and firewall must allow Puppet agent to                initiate outbound connections on this port.

If you want to use a non-default port, you have to change the [serverport](https://www.puppet.com/docs/puppet/7/configuration.html) setting on all agent nodes, and ensure                that you change your primary Puppet server’s port as                well.

### User

​                Puppet agent runs as `root`, which lets it manage the                configuration of the entire system.

​                Puppet agent can also run as a non-root user, as long                as it is started by that user. However, this restricts the resources that Puppet agent can manage, and requires you to run Puppet agent as a cron job instead of a                service.

If you need to install packages into a directory                controlled by a non-root user, use an `exec` to unzip a tarball or use a                    recursive `file` resource to copy a directory into place.

When running without root permissions, most of Puppet’s resource providers cannot use `sudo` to elevate                permissions. This means Puppet can only manage                resources that its user can modify without using `sudo`.

Out of the                core resource types listed in the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html), only the                following types are available to non-root agents: 

| Resource type        | Details                                                      |
| -------------------- | ------------------------------------------------------------ |
| `augeas`             |                                                              |
| `cron`               | Only non-root cron jobs can be viewed                                    or set. |
| `exec`               | Cannot run as another user or                                    group. |
| `file`               | Only if the non-root user has                                    read/write privileges. |
| `notify`             |                                                              |
| `schedule`           |                                                              |
| `service`            | For services that don’t require root.                                    You can also use the `start`, `stop`,                                        and `status` attributes to specify                                    how non-root users can control the service. |
| `ssh_authorized_key` |                                                              |
| `ssh_key`            |                                                              |

## Manage systems with Puppet agent

In a standard Puppet        configuration, each node periodically does configuration runs to revert unwanted changes and        to pick up recent updates.

On *nix nodes, there are three main ways            to do this:

- Run Puppet agent as a                        service.

  The easiest method. The Puppet agent daemon does configuration runs                        at a set interval, which can be configured.

- Make a cron job that runs Puppet agent.

  Requires more manual configuration, but a good choice if                        you want to reduce the number of persistent processes on your systems.

- Only run Puppet agent on                        demand.

  You can also deploy [MCollective](https://puppet.com/docs/mcollective) to run on demand on many nodes.

Choose whichever one works best for your infrastructure and            culture.

### Run Puppet agent as a service

The `puppet agent` command can start a long-lived daemon process that does      configuration runs at a set interval.

Note: If you are running Puppet agent as a non-root user, use a cron job               instead.

1. Start the service.

   The best method is with Puppet                  agent’s init script / service configuration. When you install Puppet with packages, included is an init script or                  service configuration for controlling Puppet agent,                  usually with the service name `puppet` (for both open source and Puppet Enterprise).

   In open source Puppet, enable                  the service by running this                  command:

   ```
   sudo puppet resource service puppet ensure=running enable=trueCopied!
   ```

   You can also run the `sudo puppet agent` command with no additional                  options which causes the Puppet agent to start                  running and daemonize, however you won’t have an interface for restarting or                  stopping it. To stop the daemon, use the process ID from the agent’s  [                      `pidfile`                   ](https://www.puppet.com/docs/puppet/7/configuration.html):

   ```
   sudo kill $(puppet config print pidfile --section agent)Copied!
   ```

2. (Optional) Configure the run interval.

   The Puppet agent service                  defaults to doing a configuration run every 30 minutes. You can configure this                  with the [                      `runinterval`                   ](https://www.puppet.com/docs/puppet/7/configuration.html) setting in  [                      `                         `](https://puppet.com/docs/puppet/5.5/config_file_main.html)`puppet.conf                     `                  :

   ```
   # /etc/puppetlabs/puppet/puppet.conf
   [agent]
     runinterval = 2hCopied!
   ```

   If you don’t need frequent configuration runs, a longer run interval lets your                  primary Puppet server handle many more agent                  nodes.

### Run Puppet agent as a cron        job

Run Puppet agent as a cron        job when running as a non-root user. 

If the `            onetime                ` setting is set to `true`, the Puppet agent                command does one configuration run and then quits. If the `daemonize` setting is set                    to `false`,                the command stays in the foreground until the run is finished. If set                    to `true`, it                does the run in the background.

This behavior is good for                building a cron job that does configuration runs. You can use the `splay` and `splaylimit` settings to keep the primaryPuppet server from getting overwhelmed, because the                system time is probably synchronized across all of your agent nodes.

To set up a cron job, run the `puppet resource`                    command:

```
sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60'Copied!
```

The                        above example runs Puppet one time every                        hour.  

### Run Puppet agent on demand

Some sites prefer to run Puppet agent on-demand, and others use scheduled runs along        with the occasional on-demand run.

You can start Puppet agent                runs while logged in to the target system, or remotely with Bolt or MCollective.

Run Puppet agent on                    one machine, using SSH to log into it:

```
ssh ops@magpie.example.com sudo puppet agent --testCopied!
```

Results

To run remotely                on multiple machines, you need some form of orchestration or parallel                execution tool, such as [Bolt](https://puppet.com/docs/bolt/) or [MCollective](https://puppet.com/docs/mcollective/)                with the [puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent).

Note: As of Puppet agent 5.5.4, MCollective is deprecated and will be removed in a future                    version of Puppet agent. If you use open source                        Puppet, migrate MCollective agents and filters using tools like [Bolt](https://puppet.com/docs/bolt/) and PuppetDB’s [Puppet Query Language](https://puppet.com/docs/puppetdb/).

## Disable and re-enable Puppet                runs

Whether you’re troubleshooting errors, working in a                maintenance window, or developing in a sandbox environment, you might need to                temporarily disable the Puppet agent from                running.

1. To disable the agent, run:

   ```
   sudo puppet agent --disable "<MESSAGE>"Copied!
   ```

2. To enable the agent, run:

   ```
   sudo puppet agent --enableCopied!
   ```

## Configuring Puppet                agent

The Puppet agent comes                with a default configuration that you might want to change.

Configure Puppet agent with [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html) using the `[agent]` section, the `[main]` section, or both. For information on settings                        relevant to Puppet agent, see [important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings).

### Logging for Puppet agent on *nix systems

When running as a service, Puppet agent                                logs messages to syslog. Your syslog configuration determines where                                these messages are saved, but the default location is `/var/log/messages` on Linux, and `/var/log/system.log` on Mac OS X.

You can adjust how verbose the logs are with the [`log_level`](https://www.puppet.com/docs/puppet/7/configuration.html) setting, which defaults                                        to `notice`.

When running in the foreground with the `--verbose`, `--debug`, or `--test` options, Puppet agent logs directly to the                                terminal instead of to syslog.

When started with the `--logdest                                        <FILE>` option, Puppet agent logs to the file                                specified by `<FILE>`.

### Reporting for Puppet agent on *nix systems

In addition to local logging, Puppet agent                                submits a [report](https://www.puppet.com/docs/puppet/7/reporting_about.html) to the primary Puppet server after each run.                                This can be disabled by setting `report =                                        false` in [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html).)

# Puppet agent on Windows

### Sections

[ Puppet agent's run         environment](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#win_agent_run_env)

- [Ports](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#windows-run-environment-ports)
- [User](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#windows-run-environment-user)

[Managing systems with Puppet         agent](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#managing_win_systems_with_agent)

- [Running Puppet agent as a     service](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#win_agent_as_service)
- [Running Puppet agent on         demand](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#win_agent_on_demand)

[Disabling and re-enabling Puppet       runs](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#disable_win_puppet_runs)

[Configuring Puppet agent on Windows ](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#configuring_win_agent)

- [Logging for Puppet agent on Windows systems](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#logging-puppet-agent-windows-systems)
- [Reporting for Puppet agent on Windows systems](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#reporting-puppet-agent-windows)
- [Setting Puppet agent CPU priority](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#setting-puppet-agent-cpu)

Expand

Puppet agent is the application that manages        configurations on your nodes. It requires a Puppet primary        server to fetch configuration catalogs.

For more information about invoking the Puppet agent command, see the [>puppet agent man page](https://www.puppet.com/docs/puppet/7/man/agent.html).

## Puppet agent's run        environment

Puppet agent runs as a        specific user, by default `LocalSystem`, and initiates outbound connections on port 8140.

### Ports

By default, Puppet’s HTTPS traffic uses port 8140. Your operating                system and firewall must allow Puppet agent to                initiate outbound connections on this port.

If you want to use a non-default port, change the `serverport`                setting on all agent nodes, and ensure that you change your Puppet primary server’s port as well.

### User

Puppet agent runs as the `LocalSystem` user, which lets it manage the configuration of the entire                system, but prevents it from accessing files on UNC shares.

Puppet agent can also run as a different user. You                can change the user in the Service Control Manager (SCM). To start the SCM, click                    Start -> Run… and then enter Services.msc.

You can also specify a different user when installing Puppet. To                do this, install using the CLI and specify the required MSI properties: `PUPPET_AGENT_ACCOUNT_USER`,`PUPPET_AGENT_ACCOUNT_PASSWORD`, and `PUPPET_AGENT_ACCOUNT_DOMAIN`.

Puppet agent’s user can be a local or domain user. If this user                isn’t already a local administrator, the Puppet                installer adds it to the `Administrators` group. The                installer also grants [Logon as Service ](http://msdn.microsoft.com/en-us/library/ms813948.aspx)to the user.

## Managing systems with Puppet        agent

In a normal Puppet        configuration, every node periodically does configuration runs to revert unwanted changes        and to pick up recent updates.

On Windows nodes, there are two main            ways to do this:

- Run Puppet as a service.

  The easiest method. The Puppet agent service does configuration runs                        at a set interval, which can be configured.

- Run Puppet agent on                        demand.

  You can also use [Bolt](https://www.puppet.com/docs/bolt/) or deploy[MCollective](https://puppet.com/docs/mcollective/) to run on demand on many nodes.

Because the Windows version of the Puppet agent service is much simpler than the *nix version, there’s no real performance to be gained by            running Puppet as a scheduled task. If you want scheduled            configuration runs, use the Windows service.

### Running Puppet agent as a    service

The Puppet installer    configures Puppet agent to run as a Windows service and starts it. No further action is needed. Puppet agent does configuration runs at a set interval.

#### Configuring the run        interval

The Puppet agent        service defaults to doing a configuration run every 30 minutes. If you don’t need frequent        configuration runs, a longer run interval lets your Puppet          primary servers handle many more agent nodes.

You can configure this with the `runinterval` setting in `puppet.conf`:

```
# C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf
[agent]
  runinterval = 2hCopied!
```

After you change the run interval, the next run happens on the previous schedule, and subsequent        runs happen on the new schedule.

#### Configuring the service start up        type

The Puppet agent service        defaults to starting automatically. If you want to start it manually or disable it, you can        configure this during installation.

To do this, install using the CLI and specify the `PUPPET_AGENT_STARTUP_MODE` MSI        property.

You can also configure this after installation with the Service Control Manager (SCM). To start        the SCM, click Start -> Run... and enter          Services.msc.

You can also configure agent service with the `sc.exe` command. To        prevent the service from starting on boot, run the following command from the Command Prompt          (`cmd.exe`):

```
sc config puppet start= demandCopied!
```

Important: The space after `start=` is mandatory and          must be run in cmd.exe. This command won’t work from PowerShell.

To stop        and restart the service, run the following        commands:

```
sc stop puppet
sc start puppetCopied!
```

To change the arguments used when triggering a Puppet agent run, add flags to the        command:

```
sc start puppet --debug --logdest eventlogCopied!
```

This        example changes the level of detail that gets written to the Event Log.

### Running Puppet agent on        demand

Some sites prefer to run Puppet agent on demand, and others occasionally need to do an        on-demand run. 

You can start Puppet agent runs while logged in to the            target system, or remotely with Bolt or MCollective.

#### While logged in to the target system

On Windows, log in as an                administrator, and start the configuration run by selecting Start -> Run Puppet Agent. If Windows prompts for User Account Control                confirmation, click Yes.                The status result of the run is shown in a command prompt window.

#### Running other Puppet                commands

To run other Puppet-related commands, start a command                prompt with administrative privileges. You can do so by right-clicking the                    Command Prompt or Start Command Prompts with                    Puppet program and clicking Run as                    administrator. Click Yes if the system asks for UAC                confirmation.

#### Remotely

Open source Puppet users can use                    [Bolt](https://puppet.com/docs/bolt) to run tasks and commands on remote systems. 

Alternatively, you can install MCollective and the [puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent) to get similar capabilities, but Puppet doesn't provide standalone MCollective packages for Windows. 

Important: As of Puppet agent 5.5.4,                        MCollective is deprecated and will be removed in a                    future version of Puppet agent. If you use Puppet Enterprise, consider migrating from [MCollective to Puppet orchestrator](https://puppet.com/docs/pe/latest/orchestrating_puppet_and_tasks.html). If                    you use open source Puppet, migrate MCollective agents and filters using tools like [Bolt](https://puppet.com/docs/bolt) and the [PuppetDB Puppet Query Language.](https://puppet.com/docs/puppetdb)

## Disabling and re-enabling Puppet      runs

Whether you’re troubleshooting errors, working in a      maintenance window, or developing in a sandbox environment, you might need to temporarily      disable the Puppet agent from running. 

1. ​            Start a command prompt with Run as administrator.         

2. To disable the agent, run:

   ```
   puppet agent --disable "<MESSAGE>"Copied!
   ```

3. To enable the agent, run:

   ```
   puppet agent --enableCopied!
   ```

## Configuring Puppet agent on Windows

The Puppet agent comes with        a default configuration that you might want to change.

Configure Puppet agent with [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html), using the `[agent]` section, the `[main]`            section, or both. For more information on which settings are relevant to Puppet agent, see [important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings). 

### Logging for Puppet agent on Windows systems

When running as a service, Puppet agent logs messages                to the Windows Event Log. You can view its logs by                browsing the Event Viewer. Click Control                    Panel -> System and Security ->                    Administrative Tools -> Event                    Viewer.

By default, Puppet logs to the `Application` event log. However, you can configure Puppet to log to a separate Puppet log instead. 

To enable the Puppet log, create the requisite                registry key by opening a command prompt and running one of the following                commands:

Bash:

```
reg add HKLM\System\CurrentControlSet\Services\EventLog\Puppet\Puppet /v EventMessageFile /t REG_EXPAND_SZ /d "%SystemRoot%\System32\EventCreate.exe"Copied!
```

PowerShell and the `New-EventLog`                cmdlet:

```
if ([System.Diagnostics.Eventlog]::SourceExists("puppet")) { Remove-EventLog -Source 'puppet' } & New-EventLog -Source puppet -LogName PuppetCopied!
```

Note that for agents older than 5.5.17 on the 5.5.x stream, 6.4.4 on the 6.4.x stream                and 6.8.0 on the primary server stream, use the same Bash command listed above, but                the following PowerShell command                instead:

```
if ([System.Diagnostics.Eventlog]::SourceExists("puppet")) { Remove-EventLog -Source 'puppet' } & New-EventLog -Source puppet -LogName Puppet  -MessageResource "%SystemRoot%\System32\EventCreate.exe" Copied!
```

After you add the registry key, you need to reboot your machine for the logging to be                redirected.

Note: If you are using an older version of Puppet,                    double check that you have the most up to date path to                        `EventCreate.exe`.

For existing agents, these commands can be placed in an exec resource to configure                agents going forward.

Note: Any previously recorded event log messages are not moved; only new messages                    are recorded in the newly created Puppet log.

You can adjust how verbose the logs are with the [`log_level`](https://www.puppet.com/docs/puppet/7/configuration.html) setting, which                defaults to `notice`.

When running in the foreground with the `--verbose`,                    `--debug`, or `--test` options, Puppet agent logs                directly to the terminal.

When started with the `--logdest <FILE>` option,                    Puppet agent logs to the file specified by                    `<FILE>`. Note that there are no file size                checks for the `--logdest <FILE>` option.

### Reporting for Puppet agent on Windows systems

In addition to local logging, Puppet agent submits a                report to the primary server after each run. This can be disabled by setting `report = false` in [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html).

### Setting Puppet agent CPU priority

When CPU usage is high, lower the priority of the Puppet agent service by using the [process                     priority](https://www.puppet.com/docs/puppet/7/configuration.html) setting, a cross platform configuration option. Process priority                can also be set in the primary server configuration.