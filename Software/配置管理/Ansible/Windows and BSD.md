# Using Ansible on Windows and BSD[](https://docs.ansible.com/ansible/latest/os_guide/index.html#using-ansible-on-windows-and-bsd)

Note

**Making Open Source More Inclusive**

Red Hat is committed to replacing problematic language in our code,  documentation, and web properties. We are beginning with these four  terms: master, slave, blacklist, and whitelist. We ask that you open an  issue or pull request if you come upon a term that we have missed. For  more details, see [our CTO Chris Wright’s message](https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language).

Welcome to the Ansible guide for Microsoft Windows and BSD. Because Windows is not a POSIX-compliant operating system, Ansible interacts with Windows hosts differently to Linux/Unix hosts. Likewise managing hosts that run BSD is different to managing other Unix-like host operating systems. Find out everything you need to know about using Ansible on Windows and with BSD hosts.

- Setting up a Windows Host
  - [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#host-requirements)
  - [WinRM Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id1)
  - [Windows SSH Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-ssh-setup)
- Using Ansible and Windows
  - [Use Cases](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#use-cases)
  - [Path Formatting for Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#path-formatting-for-windows)
  - [Limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#limitations)
  - [Developing Windows Modules](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#developing-windows-modules)
- Windows Remote Management
  - [What is WinRM?](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#what-is-winrm)
  - [WinRM authentication options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-authentication-options)
  - [Non-Administrator Accounts](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#non-administrator-accounts)
  - [WinRM Encryption](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-encryption)
  - [Inventory Options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#inventory-options)
  - [IPv6 Addresses](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#ipv6-addresses)
  - [HTTPS Certificate Validation](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#https-certificate-validation)
  - [TLS 1.2 Support](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#tls-1-2-support)
  - [WinRM limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-limitations)
- Desired State Configuration
  - [What is Desired State Configuration?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#what-is-desired-state-configuration)
  - [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#host-requirements)
  - [Why Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#why-use-dsc)
  - [How to Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#how-to-use-dsc)
  - [Custom DSC Resources](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#custom-dsc-resources)
  - [Examples](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#examples)
- Windows performance
  - [Optimize PowerShell performance to reduce Ansible task overhead](https://docs.ansible.com/ansible/latest/os_guide/windows_performance.html#optimize-powershell-performance-to-reduce-ansible-task-overhead)
  - [Fix high-CPU-on-boot for VMs/cloud instances](https://docs.ansible.com/ansible/latest/os_guide/windows_performance.html#fix-high-cpu-on-boot-for-vms-cloud-instances)
- Windows Frequently Asked Questions
  - [Does Ansible work with Windows XP or Server 2003?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#does-ansible-work-with-windows-xp-or-server-2003)
  - [Are Server 2008, 2008 R2 and Windows 7 supported?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#are-server-2008-2008-r2-and-windows-7-supported)
  - [Can I manage Windows Nano Server with Ansible?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-manage-windows-nano-server-with-ansible)
  - [Can Ansible run on Windows?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-ansible-run-on-windows)
  - [Can I use SSH keys to authenticate to Windows hosts?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-use-ssh-keys-to-authenticate-to-windows-hosts)
  - [Why can I run a command locally that does not work under Ansible?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-can-i-run-a-command-locally-that-does-not-work-under-ansible)
  - [This program won’t install on Windows with Ansible](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#this-program-won-t-install-on-windows-with-ansible)
  - [What Windows modules are available?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#what-windows-modules-are-available)
  - [Can I run Python modules on Windows hosts?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-run-python-modules-on-windows-hosts)
  - [Can I connect to Windows hosts over SSH?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-connect-to-windows-hosts-over-ssh)
  - [Why is connecting to a Windows host through SSH failing?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-is-connecting-to-a-windows-host-through-ssh-failing)
  - [Why are my credentials being rejected?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-are-my-credentials-being-rejected)
  - [Why am I getting an error SSL CERTIFICATE_VERIFY_FAILED?](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-am-i-getting-an-error-ssl-certificate-verify-failed)
- Managing BSD hosts with Ansible
  - [Connecting to BSD nodes](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#connecting-to-bsd-nodes)
  - [Bootstrapping BSD](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bootstrapping-bsd)
  - [Setting the Python interpreter](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter)
  - [Which modules are available?](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#which-modules-are-available)
  - [Using BSD as the control node](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#using-bsd-as-the-control-node)
  - [BSD facts](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-facts)
  - [BSD efforts and contributions](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-efforts-and-contributions)

# Setting up a Windows Host[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#setting-up-a-windows-host)

This document discusses the setup that is required before Ansible can communicate with a Microsoft Windows host.

- [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#host-requirements)
  - [Upgrading PowerShell and .NET Framework](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#upgrading-powershell-and-net-framework)
  - [WinRM Memory Hotfix](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-memory-hotfix)
- [WinRM Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id1)
  - [WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-listener)
    - [Setup WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#setup-winrm-listener)
    - [Delete WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#delete-winrm-listener)
  - [WinRM Service Options](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-service-options)
  - [Common WinRM Issues](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#common-winrm-issues)
    - [HTTP 401/Credentials Rejected](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#http-401-credentials-rejected)
    - [HTTP 500 Error](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#http-500-error)
    - [Timeout Errors](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#timeout-errors)
    - [Connection Refused Errors](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#connection-refused-errors)
    - [Failure to Load Builtin Modules](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#failure-to-load-builtin-modules)
- [Windows SSH Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-ssh-setup)
  - [Installing OpenSSH using Windows Settings](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#installing-openssh-using-windows-settings)
  - [Installing Win32-OpenSSH](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#installing-win32-openssh)
  - [Configuring the Win32-OpenSSH shell](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#configuring-the-win32-openssh-shell)
  - [Win32-OpenSSH Authentication](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#win32-openssh-authentication)
  - [Configuring Ansible for SSH on Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#configuring-ansible-for-ssh-on-windows)
  - [Known issues with SSH on Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#known-issues-with-ssh-on-windows)

## [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id2)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#host-requirements)

For Ansible to communicate to a Windows host and use Windows modules, the Windows host must meet these base requirements for connectivity:

- With Ansible you can generally manage Windows versions under the  current and extended support from Microsoft. You can also manage desktop OSs including Windows 8.1, and 10, and server OSs including Windows  Server 2012, 2012 R2, 2016, 2019, and 2022.
- You need to install PowerShell 3.0 or newer and at least .NET 4.0 on the Windows host.
- You need to create and activate a WinRM listener. More details, see [WinRM Setup](https://docs.ansible.com/ansible/latest//user_guide/windows_setup.html#winrm-listener).

Note

Some Ansible modules have additional requirements, such as a newer OS or PowerShell version. Consult the module documentation page to  determine whether a host meets those requirements.

### [Upgrading PowerShell and .NET Framework](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id3)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#upgrading-powershell-and-net-framework)

Ansible requires PowerShell version 3.0 and .NET Framework 4.0 or  newer to function on older operating systems like Server 2008 and  Windows 7. The base image does not meet this requirement. You can use the [Upgrade-PowerShell.ps1](https://github.com/jborean93/ansible-windows/blob/master/scripts/Upgrade-PowerShell.ps1) script to update these.

This is an example of how to run this script from PowerShell:

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "Administrator"
$password = "Password"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

&$file -Version 5.1 -Username $username -Password $password -Verbose
```

In the script, the `file` value can be the PowerShell version 3.0, 4.0, or 5.1.

Once completed, you need to run the following PowerShell commands:

1. As an optional but good security practice, you can set the execution policy back to the default.

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
```

Use the `RemoteSigned` value for Windows servers, or `Restricted` for Windows clients.

1. Remove the auto logon.

```
$reg_winlogon_path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $reg_winlogon_path -Name AutoAdminLogon -Value 0
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultUserName -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultPassword -ErrorAction SilentlyContinue
```

The script determines what programs you need to install (such as .NET Framework 4.5.2) and what PowerShell version needs to be present. If a  reboot is needed and the `username` and `password` parameters are set, the script will automatically reboot the machine and then logon. If the `username` and `password` parameters are not set, the script will prompt the user to manually  reboot and logon when required. When the user is next logged in, the  script will continue where it left off and the process continues until  no more actions are required.

Note

If you run the script on Server 2008, then you need to install SP2. For Server 2008 R2 or Windows 7 you need SP1.

On Windows Server 2008 you can install only PowerShell 3.0. A newer version will result in the script failure.

The `username` and `password` parameters are stored in plain text in the registry. Run the cleanup  commands after the script finishes to ensure no credentials are stored  on the host.

### [WinRM Memory Hotfix](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id4)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-memory-hotfix)

On PowerShell v3.0, there is a bug that limits the amount of memory available to the WinRM service. Use the [Install-WMF3Hotfix.ps1](https://github.com/jborean93/ansible-windows/blob/master/scripts/Install-WMF3Hotfix.ps1) script to install a hotfix on affected hosts as part of the system  bootstrapping or imaging process. Without this hotfix, Ansible fails to  execute certain commands on the Windows host.

To install the hotfix:

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Install-WMF3Hotfix.ps1"
$file = "$env:temp\Install-WMF3Hotfix.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose
```

For more details, refer to the [“Out of memory” error on a computer that has a customized MaxMemoryPerShellMB quota set and has WMF 3.0 installed](https://support.microsoft.com/en-us/help/2842230/out-of-memory-error-on-a-computer-that-has-a-customized-maxmemorypersh) article.

## [WinRM Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id5)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id1)

You need to configure the WinRM service so that Ansible can connect  to it. There are two main components of the WinRM service that governs  how Ansible can interface with the Windows host: the `listener` and the `service` configuration settings.

### [WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id6)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-listener)

The WinRM services listen for requests on one or more ports. Each of these ports must have a listener created and configured.

To view the current listeners that are running on the WinRM service:

```
winrm enumerate winrm/config/Listener
```

This will output something like:

```
Listener
    Address = *
    Transport = HTTP
    Port = 5985
    Hostname
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint
    ListeningOn = 10.0.2.15, 127.0.0.1, 192.168.56.155, ::1, fe80::5efe:10.0.2.15%6, fe80::5efe:192.168.56.155%8, fe80::
ffff:ffff:fffe%2, fe80::203d:7d97:c2ed:ec78%3, fe80::e8ea:d765:2c69:7756%7

Listener
    Address = *
    Transport = HTTPS
    Port = 5986
    Hostname = SERVER2016
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint = E6CDAA82EEAF2ECE8546E05DB7F3E01AA47D76CE
    ListeningOn = 10.0.2.15, 127.0.0.1, 192.168.56.155, ::1, fe80::5efe:10.0.2.15%6, fe80::5efe:192.168.56.155%8, fe80::
ffff:ffff:fffe%2, fe80::203d:7d97:c2ed:ec78%3, fe80::e8ea:d765:2c69:7756%7
```

In the example above there are two listeners activated. One is  listening on port 5985 over HTTP and the other is listening on port 5986 over HTTPS. Some of the key options that are useful to understand are:

- `Transport`: Whether the listener is run over HTTP or HTTPS. We recommend you use a  listener over HTTPS because the data is encrypted without any further  changes required.
- `Port`: The port the listener runs on. By default it is `5985` for HTTP and `5986` for HTTPS. This port can be changed to whatever is required and corresponds to the host var `ansible_port`.
- `URLPrefix`: The URL prefix to listen on. By default it is `wsman`. If you change this option, you need to set the host var `ansible_winrm_path` to the same value.
- `CertificateThumbprint`: If you use an HTTPS listener, this is the thumbprint of the certificate in the Windows Certificate Store that is used in the connection. To get the details of the certificate itself, run this command with the  relevant certificate thumbprint in PowerShell:

```
$thumbprint = "E6CDAA82EEAF2ECE8546E05DB7F3E01AA47D76CE"
Get-ChildItem -Path cert:\LocalMachine\My -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object *
```

#### [Setup WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id7)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#setup-winrm-listener)

There are three ways to set up a WinRM listener:

- Using `winrm quickconfig` for HTTP or `winrm quickconfig -transport:https` for HTTPS. This is the easiest option to use when running outside of a  domain environment and a simple listener is required. Unlike the other  options, this process also has the added benefit of opening up the  firewall for the ports required and starts the WinRM service.

- Using Group Policy Objects (GPO). This is the best way to create a listener when the host is a member of a domain because the  configuration is done automatically without any user input. For more  information on group policy objects, see the [Group Policy Objects documentation](https://msdn.microsoft.com/en-us/library/aa374162(v=vs.85).aspx).

- Using PowerShell to create a listener with a specific  configuration. This can be done by running the following PowerShell  commands:

  ```
  $selector_set = @{
      Address = "*"
      Transport = "HTTPS"
  }
  $value_set = @{
      CertificateThumbprint = "E6CDAA82EEAF2ECE8546E05DB7F3E01AA47D76CE"
  }
  
  New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set
  ```

  To see the other options with this PowerShell command, refer to the [New-WSManInstance](https://docs.microsoft.com/en-us/powershell/module/microsoft.wsman.management/new-wsmaninstance?view=powershell-5.1) documentation.

Note

When creating an HTTPS listener, you must create and store a certificate in the `LocalMachine\My` certificate store.

#### [Delete WinRM Listener](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id8)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#delete-winrm-listener)

- To remove all WinRM listeners:

```
Remove-Item -Path WSMan:\localhost\Listener\* -Recurse -Force
```

- To remove only those listeners that run over HTTPS:

```
Get-ChildItem -Path WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTPS" } | Remove-Item -Recurse -Force
```

Note

The `Keys` object is an array of strings, so it can contain different values. By default, it contains a key for `Transport=` and `Address=` which correspond to the values from the `winrm enumerate winrm/config/Listeners` command.

### [WinRM Service Options](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id9)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#winrm-service-options)

You can control the behavior of the WinRM service component, including authentication options and memory settings.

To get an output of the current service configuration options, run the following command:

```
winrm get winrm/config/Service
winrm get winrm/config/Winrs
```

This will output something like:

```
Service
    RootSDDL = O:NSG:BAD:P(A;;GA;;;BA)(A;;GR;;;IU)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)
    MaxConcurrentOperations = 4294967295
    MaxConcurrentOperationsPerUser = 1500
    EnumerationTimeoutms = 240000
    MaxConnections = 300
    MaxPacketRetrievalTimeSeconds = 120
    AllowUnencrypted = false
    Auth
        Basic = true
        Kerberos = true
        Negotiate = true
        Certificate = true
        CredSSP = true
        CbtHardeningLevel = Relaxed
    DefaultPorts
        HTTP = 5985
        HTTPS = 5986
    IPv4Filter = *
    IPv6Filter = *
    EnableCompatibilityHttpListener = false
    EnableCompatibilityHttpsListener = false
    CertificateThumbprint
    AllowRemoteAccess = true

Winrs
    AllowRemoteShellAccess = true
    IdleTimeout = 7200000
    MaxConcurrentUsers = 2147483647
    MaxShellRunTime = 2147483647
    MaxProcessesPerShell = 2147483647
    MaxMemoryPerShellMB = 2147483647
    MaxShellsPerUser = 2147483647
```

You do not need to change the majority of these options. However, some of the important ones to know about are:

- `Service\AllowUnencrypted` - specifies whether WinRM will allow HTTP traffic without message  encryption. Message level encryption is only possible when the `ansible_winrm_transport` variable is `ntlm`, `kerberos` or `credssp`. By default, this is `false` and you should only set it to `true` when debugging WinRM messages.
- `Service\Auth\*` - defines what authentication options you can use with the WinRM service. By default, `Negotiate (NTLM)` and `Kerberos` are enabled.
- `Service\Auth\CbtHardeningLevel` - specifies whether channel binding tokens are not verified (None),  verified but not required (Relaxed), or verified and required (Strict).  CBT is only used when connecting with NT LAN Manager (NTLM) or Kerberos  over HTTPS.
- `Service\CertificateThumbprint` - thumbprint of the certificate for encrypting the TLS channel used  with CredSSP authentication. By default, this is empty. A self-signed  certificate is generated when the WinRM service starts and is used in  the TLS process.
- `Winrs\MaxShellRunTime` - maximum time, in milliseconds, that a remote command is allowed to execute.
- `Winrs\MaxMemoryPerShellMB` - maximum amount of memory allocated per shell, including its child processes.

To modify a setting under the `Service` key in PowerShell, you need to provide a path to the option after `winrm/config/Service`:

```
Set-Item -Path WSMan:\localhost\Service\{path} -Value {some_value}
```

For example, to change `Service\Auth\CbtHardeningLevel`:

```
Set-Item -Path WSMan:\localhost\Service\Auth\CbtHardeningLevel -Value Strict
```

To modify a setting under the `Winrs` key in PowerShell, you need to provide a path to the option after `winrm/config/Winrs`:

```
Set-Item -Path WSMan:\localhost\Shell\{path} -Value {some_value}
```

For example, to change `Winrs\MaxShellRunTime`:

```
Set-Item -Path WSMan:\localhost\Shell\MaxShellRunTime -Value 2147483647
```

Note

If you run the command in a domain environment, some of these options are set by GPO and cannot be changed on the host itself. When you configured a key with GPO, it contains the text `[Source="GPO"]` next to the value.

### [Common WinRM Issues](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id10)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#common-winrm-issues)

WinRM has a wide range of configuration options, which makes its  configuration complex. As a result, errors that Ansible displays could  in fact be problems with the host setup instead.

To identify a host issue, run the following command from another Windows host to connect to the target Windows host.

- To test HTTP:

```
winrs -r:http://server:5985/wsman -u:Username -p:Password ipconfig
```

- To test HTTPS:

```
winrs -r:https://server:5986/wsman -u:Username -p:Password -ssl ipconfig
```

The command will fail if the certificate is not verifiable.

- To test HTTPS ignoring certificate verification:

```
$username = "Username"
$password = ConvertTo-SecureString -String "Password" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password

$session_option = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
Invoke-Command -ComputerName server -UseSSL -ScriptBlock { ipconfig } -Credential $cred -SessionOption $session_option
```

If any of the above commands fail, the issue is probably related to the WinRM setup.

#### [HTTP 401/Credentials Rejected](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id11)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#http-401-credentials-rejected)

An HTTP 401 error indicates the authentication process failed during the initial connection. You can check the following to troubleshoot:

- The credentials are correct and set properly in your inventory with the `ansible_user` and `ansible_password` variables.
- The user is a member of the local Administrators group, or has  been explicitly granted access. You can perform a connection test with  the `winrs` command to rule this out.
- The authentication option set by the `ansible_winrm_transport` variable is enabled under `Service\Auth\*`.
- If running over HTTP and not HTTPS, use `ntlm`, `kerberos` or `credssp` with the `ansible_winrm_message_encryption: auto` custom inventory variable to enable message encryption. If you use  another authentication option, or if it is not possible to upgrade the  installed `pywinrm` package, you can set `Service\AllowUnencrypted` to `true`. This is recommended only for troubleshooting.
- The downstream packages `pywinrm`, `requests-ntlm`, `requests-kerberos`, and/or `requests-credssp` are up to date using `pip`.
- For Kerberos authentication, ensure that `Service\Auth\CbtHardeningLevel` is not set to `Strict`.
- For Basic or Certificate authentication, make sure that the user  is a local account. Domain accounts do not work with Basic and  Certificate authentication.

#### [HTTP 500 Error](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id12)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#http-500-error)

An HTTP 500 error indicates a problem with the WinRM service. You can check the following to troubleshoot:

- The number of your currently open shells has not exceeded either `WinRsMaxShellsPerUser`. Alternatively, you did not exceed any of the other Winrs quotas.

#### [Timeout Errors](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id13)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#timeout-errors)

Sometimes Ansible is unable to reach the host. These instances  usually indicate a problem with the network connection. You can check  the following to troubleshoot:

- The firewall is not set to block the configured WinRM listener ports.
- A WinRM listener is enabled on the port and path set by the host vars.
- The `winrm` service is running on the Windows host and is configured for the automatic start.

#### [Connection Refused Errors](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id14)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#connection-refused-errors)

When you communicate with the WinRM service on the host you can  encounter some problems. Check the following to help the  troubleshooting:

- The WinRM service is up and running on the host. Use the `(Get-Service -Name winrm).Status` command to get the status of the service.
- The host firewall is allowing traffic over the WinRM port. By default this is `5985` for HTTP and `5986` for HTTPS.

Sometimes an installer may restart the WinRM or HTTP service and cause this error. The best way to deal with this is to use the `win_psexec` module from another Windows host.

#### [Failure to Load Builtin Modules](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id15)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#failure-to-load-builtin-modules)

Sometimes PowerShell fails with an error message similar to:

```
The 'Out-String' command was found in the module 'Microsoft.PowerShell.Utility', but the module could not be loaded.
```

In that case, there could be a problem when trying to access all the paths specified by the `PSModulePath` environment variable.

A common cause of this issue is that `PSModulePath` contains a Universal Naming Convention (UNC) path to a file share.  Additionally, the double hop/credential delegation issue causes that the Ansible process cannot access these folders. To work around this  problem is to either:

- Remove the UNC path from `PSModulePath`.

or

- Use an authentication option that supports credential delegation like `credssp` or `kerberos`. You need to have the credential delegation enabled.

See [KB4076842](https://support.microsoft.com/en-us/help/4076842) for more information on this problem.

## [Windows SSH Setup](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id16)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-ssh-setup)

Ansible 2.8 has added an experimental SSH connection for Windows managed nodes.

Warning

Use this feature at your own risk! Using SSH with Windows is  experimental. This implementation may make backwards incompatible changes in future releases. The server-side  components can be unreliable depending on your installed version.

### [Installing OpenSSH using Windows Settings](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id17)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#installing-openssh-using-windows-settings)

You can use OpenSSH to connect Window 10 clients to Windows Server  2019. OpenSSH Client is available to install on Windows 10 build 1809  and later. OpenSSH Server is available to install on Windows Server 2019 and later.

For more information, refer to [Get started with OpenSSH for Windows](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse).

### [Installing Win32-OpenSSH](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id18)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#installing-win32-openssh)

To install the [Win32-OpenSSH](https://github.com/PowerShell/Win32-OpenSSH) service for use with Ansible, select one of these installation options:

- Manually install `Win32-OpenSSH`, following the [install instructions](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH) from Microsoft.
- Use Chocolatey:

```
choco install --package-parameters=/SSHServerFeature openssh
```

- Use the `win_chocolatey` Ansible module:

```
- name: install the Win32-OpenSSH service
  win_chocolatey:
    name: openssh
    package_params: /SSHServerFeature
    state: present
```

- Install an Ansible Galaxy role for example [jborean93.win_openssh](https://galaxy.ansible.com/jborean93/win_openssh):

```
ansible-galaxy install jborean93.win_openssh
```

- Use the role in your playbook:

```
- name: install Win32-OpenSSH service
  hosts: windows
  gather_facts: false
  roles:
  - role: jborean93.win_openssh
    opt_openssh_setup_service: True
```

Note

`Win32-OpenSSH` is still a beta product and is constantly being updated to include new  features and bugfixes. If you use SSH as a connection option for  Windows, we highly recommend you install the latest version.

### [Configuring the Win32-OpenSSH shell](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id19)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#configuring-the-win32-openssh-shell)

By default `Win32-OpenSSH` uses `cmd.exe` as a shell.

- To configure a different shell, use an Ansible playbook with a task to define the registry setting:

```
- name: set the default shell to PowerShell
  win_regedit:
    path: HKLM:\SOFTWARE\OpenSSH
    name: DefaultShell
    data: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    type: string
    state: present
```

- To revert the settings back to the default shell:

```
- name: set the default shell to cmd
  win_regedit:
    path: HKLM:\SOFTWARE\OpenSSH
    name: DefaultShell
    state: absent
```

### [Win32-OpenSSH Authentication](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id20)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#win32-openssh-authentication)

Win32-OpenSSH authentication with Windows is similar to SSH  authentication on Unix/Linux hosts. You can use a plaintext password or  SSH public key authentication.

For the key-based authentication:

- Add your public keys to an `authorized_key` file in the `.ssh` folder of the user’s profile directory.
- Configure the SSH service using the `sshd_config` file.

When using SSH key authentication with Ansible, the remote session  will not have access to user credentials and will fail when attempting  to access a network resource. This is also known as the double-hop or  credential delegation issue. To work around this problem:

- Use plaintext password authentication by setting the `ansible_password` variable.
- Use the `become` directive on the task with the credentials of the user that needs access to the remote resource.

### [Configuring Ansible for SSH on Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id21)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#configuring-ansible-for-ssh-on-windows)

To configure Ansible to use SSH for Windows hosts, you must set two connection variables:

- set `ansible_connection` to `ssh`
- set `ansible_shell_type` to `cmd` or `powershell`

The `ansible_shell_type` variable should reflect the `DefaultShell` configured on the Windows host. Set `ansible_shell_type` to `cmd` for the default shell. Alternatively, set `ansible_shell_type` to `powershell` if you changed `DefaultShell` to PowerShell.

### [Known issues with SSH on Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id22)[](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#known-issues-with-ssh-on-windows)

Using SSH with Windows is experimental. Currently existing issues are:

- Win32-OpenSSH versions older than `v7.9.0.0p1-Beta` do not work when `powershell` is the shell type.
- While Secure Copy Protocol (SCP) should work, SSH File Transfer  Protocol (SFTP) is the recommended mechanism to use when copying or  fetching a file.

# Using Ansible and Windows[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#using-ansible-and-windows)

When using Ansible to manage Windows, many of the syntax and rules that apply for Unix/Linux hosts also apply to Windows, but there are still some differences when it comes to components like path separators and OS-specific tasks. This document covers details specific to using Ansible for Windows.

Topics

- [Use Cases](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#use-cases)
  - [Installing Software](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#installing-software)
  - [Installing Updates](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#installing-updates)
  - [Set Up Users and Groups](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#set-up-users-and-groups)
    - [Local](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#local)
    - [Domain](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#domain)
  - [Running Commands](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#running-commands)
    - [Choosing Command or Shell](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#choosing-command-or-shell)
    - [Argument Rules](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#argument-rules)
  - [Creating and Running a Scheduled Task](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#creating-and-running-a-scheduled-task)
- [Path Formatting for Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#path-formatting-for-windows)
  - [YAML Style](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#yaml-style)
  - [Legacy key=value Style](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#legacy-key-value-style)
- [Limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#limitations)
- [Developing Windows Modules](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#developing-windows-modules)

## [Use Cases](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id1)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#use-cases)

Ansible can be used to orchestrate a multitude of tasks on Windows servers. Below are some examples and info about common tasks.

### [Installing Software](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id2)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#installing-software)

There are three main ways that Ansible can be used to install software:

- Using the `win_chocolatey` module. This sources the program data from the default public [Chocolatey](https://chocolatey.org/) repository. Internal repositories can be used instead by setting the `source` option.
- Using the `win_package` module. This installs software using an MSI or .exe installer from a local/network path or URL.
- Using the `win_command` or `win_shell` module to run an installer manually.

The `win_chocolatey` module is recommended since it has the most complete logic for checking to see if a package has already been installed and is up-to-date.

Below are some examples of using all three options to install 7-Zip:

```
# Install/uninstall with chocolatey
- name: Ensure 7-Zip is installed through Chocolatey
  win_chocolatey:
    name: 7zip
    state: present

- name: Ensure 7-Zip is not installed through Chocolatey
  win_chocolatey:
    name: 7zip
    state: absent

# Install/uninstall with win_package
- name: Download the 7-Zip package
  win_get_url:
    url: https://www.7-zip.org/a/7z1701-x64.msi
    dest: C:\temp\7z.msi

- name: Ensure 7-Zip is installed through win_package
  win_package:
    path: C:\temp\7z.msi
    state: present

- name: Ensure 7-Zip is not installed through win_package
  win_package:
    path: C:\temp\7z.msi
    state: absent

# Install/uninstall with win_command
- name: Download the 7-Zip package
  win_get_url:
    url: https://www.7-zip.org/a/7z1701-x64.msi
    dest: C:\temp\7z.msi

- name: Check if 7-Zip is already installed
  win_reg_stat:
    name: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{23170F69-40C1-2702-1701-000001000000}
  register: 7zip_installed

- name: Ensure 7-Zip is installed through win_command
  win_command: C:\Windows\System32\msiexec.exe /i C:\temp\7z.msi /qn /norestart
  when: 7zip_installed.exists == false

- name: Ensure 7-Zip is uninstalled through win_command
  win_command: C:\Windows\System32\msiexec.exe /x {23170F69-40C1-2702-1701-000001000000} /qn /norestart
  when: 7zip_installed.exists == true
```

Some installers like Microsoft Office or SQL Server require credential delegation or access to components restricted by WinRM. The best method to bypass these issues is to use `become` with the task. With `become`, Ansible will run the installer as if it were run interactively on the host.

Note

Many installers do not properly pass back error information over  WinRM. In these cases, if the install has been  verified to work locally the recommended method is to use become.

Note

Some installers restart the WinRM or HTTP services, or cause them to  become temporarily unavailable, making Ansible assume the system is  unreachable.

### [Installing Updates](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id3)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#installing-updates)

The `win_updates` and `win_hotfix` modules can be used to install updates or hotfixes on a host. The module `win_updates` is used to install multiple updates by category, while `win_hotfix` can be used to install a single update or hotfix file that has been downloaded locally.

Note

The `win_hotfix` module has a requirement that the DISM PowerShell cmdlets are present. These cmdlets were only added by default on Windows Server 2012 and newer and must be installed on older Windows hosts.

The following example shows how `win_updates` can be used:

```
- name: Install all critical and security updates
  win_updates:
    category_names:
    - CriticalUpdates
    - SecurityUpdates
    state: installed
  register: update_result

- name: Reboot host if required
  win_reboot:
  when: update_result.reboot_required
```

The following example show how `win_hotfix` can be used to install a single update or hotfix:

```
- name: Download KB3172729 for Server 2012 R2
  win_get_url:
    url: http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/07/windows8.1-kb3172729-x64_e8003822a7ef4705cbb65623b72fd3cec73fe222.msu
    dest: C:\temp\KB3172729.msu

- name: Install hotfix
  win_hotfix:
    hotfix_kb: KB3172729
    source: C:\temp\KB3172729.msu
    state: present
  register: hotfix_result

- name: Reboot host if required
  win_reboot:
  when: hotfix_result.reboot_required
```

### [Set Up Users and Groups](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id4)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#set-up-users-and-groups)

Ansible can be used to create Windows users and groups both locally and on a domain.

#### [Local](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id5)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#local)

The modules `win_user`, `win_group` and `win_group_membership` manage Windows users, groups and group memberships locally.

The following is an example of creating local accounts and groups that can access a folder on the same host:

```
- name: Create local group to contain new users
  win_group:
    name: LocalGroup
    description: Allow access to C:\Development folder

- name: Create local user
  win_user:
    name: '{{ item.name }}'
    password: '{{ item.password }}'
    groups: LocalGroup
    update_password: false
    password_never_expires: true
  loop:
  - name: User1
    password: Password1
  - name: User2
    password: Password2

- name: Create Development folder
  win_file:
    path: C:\Development
    state: directory

- name: Set ACL of Development folder
  win_acl:
    path: C:\Development
    rights: FullControl
    state: present
    type: allow
    user: LocalGroup

- name: Remove parent inheritance of Development folder
  win_acl_inheritance:
    path: C:\Development
    reorganize: true
    state: absent
```

#### [Domain](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id6)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#domain)

The modules `win_domain_user` and `win_domain_group` manages users and groups in a domain. The below is an example of ensuring a batch of domain users are created:

```
- name: Ensure each account is created
  win_domain_user:
    name: '{{ item.name }}'
    upn: '{{ item.name }}@MY.DOMAIN.COM'
    password: '{{ item.password }}'
    password_never_expires: false
    groups:
    - Test User
    - Application
    company: Ansible
    update_password: on_create
  loop:
  - name: Test User
    password: Password
  - name: Admin User
    password: SuperSecretPass01
  - name: Dev User
    password: '@fvr3IbFBujSRh!3hBg%wgFucD8^x8W5'
```

### [Running Commands](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id7)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#running-commands)

In cases where there is no appropriate module available for a task, a command or script can be run using the `win_shell`, `win_command`, `raw`, and `script` modules.

The `raw` module simply executes a Powershell command remotely. Since `raw` has none of the wrappers that Ansible typically uses, `become`, `async` and environment variables do not work.

The `script` module executes a script from the Ansible controller on one or more Windows hosts. Like `raw`, `script` currently does not support `become`, `async`, or environment variables.

The `win_command` module is used to execute a command which is either an executable or batch file, while the `win_shell` module is used to execute commands within a shell.

#### [Choosing Command or Shell](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id8)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#choosing-command-or-shell)

The `win_shell` and `win_command` modules can both be used to execute a command or commands. The `win_shell` module is run within a shell-like process like `PowerShell` or `cmd`, so it has access to shell operators like `<`, `>`, `|`, `;`, `&&`, and `||`. Multi-lined commands can also be run in `win_shell`.

The `win_command` module simply runs a process outside of a shell. It can still run a shell command like `mkdir` or `New-Item` by passing the shell commands to a shell executable like `cmd.exe` or `PowerShell.exe`.

Here are some examples of using `win_command` and `win_shell`:

```
- name: Run a command under PowerShell
  win_shell: Get-Service -Name service | Stop-Service

- name: Run a command under cmd
  win_shell: mkdir C:\temp
  args:
    executable: cmd.exe

- name: Run a multiple shell commands
  win_shell: |
    New-Item -Path C:\temp -ItemType Directory
    Remove-Item -Path C:\temp -Force -Recurse
    $path_info = Get-Item -Path C:\temp
    $path_info.FullName

- name: Run an executable using win_command
  win_command: whoami.exe

- name: Run a cmd command
  win_command: cmd.exe /c mkdir C:\temp

- name: Run a vbs script
  win_command: cscript.exe script.vbs
```

Note

Some commands like `mkdir`, `del`, and `copy` only exist in the CMD shell. To run them with `win_command` they must be prefixed with `cmd.exe /c`.

#### [Argument Rules](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id9)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#argument-rules)

When running a command through `win_command`, the standard Windows argument rules apply:

- Each argument is delimited by a white space, which can either be a space or a tab.
- An argument can be surrounded by double quotes `"`. Anything inside these quotes is interpreted as a single argument even if it contains whitespace.
- A double quote preceded by a backslash `\` is interpreted as just a double quote `"` and not as an argument delimiter.
- Backslashes are interpreted literally unless it immediately precedes double quotes; for example `\` == `\` and `\"` == `"`
- If an even number of backslashes is followed by a double quote, one backslash is used in the argument for every pair, and the double quote is used as a string delimiter for the argument.
- If an odd number of backslashes is followed by a double quote, one backslash is used in the argument for every pair, and the double quote is escaped and made a literal double quote in the argument.

With those rules in mind, here are some examples of quoting:

```
- win_command: C:\temp\executable.exe argument1 "argument 2" "C:\path\with space" "double \"quoted\""

argv[0] = C:\temp\executable.exe
argv[1] = argument1
argv[2] = argument 2
argv[3] = C:\path\with space
argv[4] = double "quoted"

- win_command: '"C:\Program Files\Program\program.exe" "escaped \\\" backslash" unquoted-end-backslash\'

argv[0] = C:\Program Files\Program\program.exe
argv[1] = escaped \" backslash
argv[2] = unquoted-end-backslash\

# Due to YAML and Ansible parsing '\"' must be written as '{% raw %}\\{% endraw %}"'
- win_command: C:\temp\executable.exe C:\no\space\path "arg with end \ before end quote{% raw %}\\{% endraw %}"

argv[0] = C:\temp\executable.exe
argv[1] = C:\no\space\path
argv[2] = arg with end \ before end quote\"
```

For more information, see [escaping arguments](https://msdn.microsoft.com/en-us/library/17w5ykft(v=vs.85).aspx).

### [Creating and Running a Scheduled Task](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id10)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#creating-and-running-a-scheduled-task)

WinRM has some restrictions in place that cause errors when running certain commands. One way to bypass these restrictions is to run a command through a scheduled task. A scheduled task is a Windows component that provides the ability to run an executable on a schedule and under a different account.

Ansible version 2.5 added modules that make it easier to work with scheduled tasks in Windows. The following is an example of running a script as a scheduled task that deletes itself after running:

```
- name: Create scheduled task to run a process
  win_scheduled_task:
    name: adhoc-task
    username: SYSTEM
    actions:
    - path: PowerShell.exe
      arguments: |
        Start-Sleep -Seconds 30  # This isn't required, just here as a demonstration
        New-Item -Path C:\temp\test -ItemType Directory
    # Remove this action if the task shouldn't be deleted on completion
    - path: cmd.exe
      arguments: /c schtasks.exe /Delete /TN "adhoc-task" /F
    triggers:
    - type: registration

- name: Wait for the scheduled task to complete
  win_scheduled_task_stat:
    name: adhoc-task
  register: task_stat
  until: (task_stat.state is defined and task_stat.state.status != "TASK_STATE_RUNNING") or (task_stat.task_exists == False)
  retries: 12
  delay: 10
```

Note

The modules used in the above example were updated/added in Ansible version 2.5.

## [Path Formatting for Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id11)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#path-formatting-for-windows)

Windows differs from a traditional POSIX operating system in many ways. One of the major changes is the shift from `/` as the path separator to `\`. This can cause major issues with how playbooks are written, since `\` is often used as an escape character on POSIX systems.

Ansible allows two different styles of syntax; each deals with path separators for Windows differently:

### [YAML Style](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id12)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#yaml-style)

When using the YAML syntax for tasks, the rules are well-defined by the YAML standard:

- When using a normal string (without quotes), YAML will not consider the backslash an escape character.
- When using single quotes `'`, YAML will not consider the backslash an escape character.
- When using double quotes `"`, the backslash is considered an escape character and needs to escaped with another backslash.

Note

You should only quote strings when it is absolutely necessary or required by YAML, and then use single quotes.

The YAML specification considers the following [escape sequences](https://yaml.org/spec/current.html#id2517668):

- `\0`, `\\`, `\"`, `\_`, `\a`, `\b`, `\e`, `\f`, `\n`, `\r`, `\t`, `\v`, `\L`, `\N` and `\P` – Single character escape
- `<TAB>`, `<SPACE>`, `<NBSP>`, `<LNSP>`, `<PSP>` – Special characters
- `\x..` – 2-digit hex escape
- `\u....` – 4-digit hex escape
- `\U........` – 8-digit hex escape

Here are some examples on how to write Windows paths:

```
# GOOD
tempdir: C:\Windows\Temp

# WORKS
tempdir: 'C:\Windows\Temp'
tempdir: "C:\\Windows\\Temp"

# BAD, BUT SOMETIMES WORKS
tempdir: C:\\Windows\\Temp
tempdir: 'C:\\Windows\\Temp'
tempdir: C:/Windows/Temp
```

This is an example which will fail:

```
# FAILS
tempdir: "C:\Windows\Temp"
```

This example shows the use of single quotes when they are required:

```
---
- name: Copy tomcat config
  win_copy:
    src: log4j.xml
    dest: '{{tc_home}}\lib\log4j.xml'
```

### [Legacy key=value Style](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id13)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#legacy-key-value-style)

The legacy `key=value` syntax is used on the command line for ad hoc commands, or inside playbooks. The use of this style is discouraged within playbooks because backslash characters need to be escaped, making playbooks harder to read. The legacy syntax depends on the specific implementation in Ansible, and quoting (both single and double) does not have any effect on how it is parsed by Ansible.

The Ansible key=value parser parse_kv() considers the following escape sequences:

- `\`, `'`, `"`, `\a`, `\b`, `\f`, `\n`, `\r`, `\t` and `\v` – Single character escape
- `\x..` – 2-digit hex escape
- `\u....` – 4-digit hex escape
- `\U........` – 8-digit hex escape
- `\N{...}` – Unicode character by name

This means that the backslash is an escape character for some sequences, and it is usually safer to escape a backslash when in this form.

Here are some examples of using Windows paths with the key=value style:

```
# GOOD
tempdir=C:\\Windows\\Temp

# WORKS
tempdir='C:\\Windows\\Temp'
tempdir="C:\\Windows\\Temp"

# BAD, BUT SOMETIMES WORKS
tempdir=C:\Windows\Temp
tempdir='C:\Windows\Temp'
tempdir="C:\Windows\Temp"
tempdir=C:/Windows/Temp

# FAILS
tempdir=C:\Windows\temp
tempdir='C:\Windows\temp'
tempdir="C:\Windows\temp"
```

The failing examples don’t fail outright but will substitute `\t` with the `<TAB>` character resulting in `tempdir` being `C:\Windows<TAB>emp`.

## [Limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id14)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#limitations)

Some things you cannot do with Ansible and Windows are:

- Upgrade PowerShell
- Interact with the WinRM listeners

Because WinRM is reliant on the services being online and running  during normal operations, you cannot upgrade PowerShell or interact with WinRM listeners with Ansible. Both of these actions will cause the  connection to fail. This can technically be avoided by using `async` or a scheduled task, but those methods are fragile if the process it  runs breaks the underlying connection Ansible uses, and are best left to the bootstrapping process or before an image is created.

## [Developing Windows Modules](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#id15)[](https://docs.ansible.com/ansible/latest/os_guide/windows_usage.html#developing-windows-modules)

Because Ansible modules for Windows are written in PowerShell, the development guides for Windows modules differ substantially from those for standard standard modules. Please see [Windows module development walkthrough](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general_windows.html#developing-modules-general-windows) for more information.

# Windows Remote Management[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#windows-remote-management)

Unlike Linux/Unix hosts, which use SSH by default, Windows hosts are configured with WinRM. This topic covers how to configure and use WinRM with Ansible.

- [What is WinRM?](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#what-is-winrm)
- [WinRM authentication options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-authentication-options)
  - [Basic](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#basic)
  - [Certificate](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#certificate)
  - [NTLM](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#ntlm)
  - [Kerberos](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#kerberos)
  - [CredSSP](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#credssp)
- [Non-Administrator Accounts](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#non-administrator-accounts)
- [WinRM Encryption](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-encryption)
- [Inventory Options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#inventory-options)
- [IPv6 Addresses](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#ipv6-addresses)
- [HTTPS Certificate Validation](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#https-certificate-validation)
- [TLS 1.2 Support](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#tls-1-2-support)
- [WinRM limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-limitations)

## [What is WinRM?](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id2)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#what-is-winrm)

WinRM is a management protocol used by Windows to remotely communicate with another server. It is a SOAP-based protocol that communicates over HTTP/HTTPS, and is included in all recent Windows operating systems. Since Windows Server 2012, WinRM has been enabled by default, but in most cases extra configuration is required to use WinRM with Ansible.

Ansible uses the [pywinrm](https://github.com/diyan/pywinrm) package to communicate with Windows servers over WinRM. It is not installed by default with the Ansible package, but can be installed by running the following:

```
pip install "pywinrm>=0.3.0"
```

Note

on distributions with multiple python versions, use pip2 or pip2.x, where x matches the python minor version Ansible is running under.

Warning

Using the `winrm` or `psrp` connection plugins in Ansible on MacOS in the latest releases typically fail. This is a known problem that occurs deep within the Python stack and cannot be changed by Ansible. The only workaround today is to set the environment variable `no_proxy=*` and avoid using Kerberos auth.



## [WinRM authentication options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id3)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-authentication-options)

When connecting to a Windows host, there are several different options that can be used when authenticating with an account. The authentication type may be set on inventory hosts or groups with the `ansible_winrm_transport` variable.

The following matrix is a high level overview of the options:

| Option      | Local Accounts | Active Directory Accounts | Credential Delegation | HTTP Encryption |
| ----------- | -------------- | ------------------------- | --------------------- | --------------- |
| Basic       | Yes            | No                        | No                    | No              |
| Certificate | Yes            | No                        | No                    | No              |
| Kerberos    | No             | Yes                       | Yes                   | Yes             |
| NTLM        | Yes            | Yes                       | No                    | Yes             |
| CredSSP     | Yes            | Yes                       | Yes                   | Yes             |



### [Basic](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id4)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#basic)

Basic authentication is one of the simplest authentication options to use, but is also the most insecure. This is because the username and password are simply base64 encoded, and if a secure channel is not in use (eg, HTTPS) then it can be decoded by anyone. Basic authentication can only be used for local accounts (not domain accounts).

The following example shows host vars configured for basic authentication:

```
ansible_user: LocalUsername
ansible_password: Password
ansible_connection: winrm
ansible_winrm_transport: basic
```

Basic authentication is not enabled by default on a Windows host but can be enabled by running the following in PowerShell:

```
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
```



### [Certificate](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id5)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#certificate)

Certificate authentication uses certificates as keys similar to SSH key pairs, but the file format and key generation process is different.

The following example shows host vars configured for certificate authentication:

```
ansible_connection: winrm
ansible_winrm_cert_pem: /path/to/certificate/public/key.pem
ansible_winrm_cert_key_pem: /path/to/certificate/private/key.pem
ansible_winrm_transport: certificate
```

Certificate authentication is not enabled by default on a Windows host but can be enabled by running the following in PowerShell:

```
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
```

Note

Encrypted private keys cannot be used as the urllib3 library that is used by Ansible for WinRM does not support this functionality.

Note

Certificate authentication does not work with a TLS 1.3 connection.

.._winrm_certificate_generate:

#### Generate a Certificate[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#generate-a-certificate)

A certificate must be generated before it can be mapped to a local user. This can be done using one of the following methods:

- OpenSSL
- PowerShell, using the `New-SelfSignedCertificate` cmdlet
- Active Directory Certificate Services

Active Directory Certificate Services is beyond of scope in this documentation but may be the best option to use when running in a domain environment. For more information, see the [Active Directory Certificate Services documentation](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc732625(v=ws.11)).

Note

Using the PowerShell cmdlet `New-SelfSignedCertificate` to generate a certificate for authentication only works when being generated from a Windows 10 or Windows Server 2012 R2 host or later. OpenSSL is still required to extract the private key from the PFX certificate to a PEM file for Ansible to use.

To generate a certificate with `OpenSSL`:

```
# Set the name of the local user that will have the key mapped to
USERNAME="username"

cat > openssl.conf << EOL
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$USERNAME@localhost
EOL

export OPENSSL_CONF=openssl.conf
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out cert.pem -outform PEM -keyout cert_key.pem -subj "/CN=$USERNAME" -extensions v3_req_client
rm openssl.conf
```

To generate a certificate with `New-SelfSignedCertificate`:

```
# Set the name of the local user that will have the key mapped
$username = "username"
$output_path = "C:\temp"

# Instead of generating a file, the cert will be added to the personal
# LocalComputer folder in the certificate store
$cert = New-SelfSignedCertificate -Type Custom `
    -Subject "CN=$username" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=$username@localhost") `
    -KeyUsage DigitalSignature,KeyEncipherment `
    -KeyAlgorithm RSA `
    -KeyLength 2048

# Export the public key
$pem_output = @()
$pem_output += "-----BEGIN CERTIFICATE-----"
$pem_output += [System.Convert]::ToBase64String($cert.RawData) -replace ".{64}", "$&`n"
$pem_output += "-----END CERTIFICATE-----"
[System.IO.File]::WriteAllLines("$output_path\cert.pem", $pem_output)

# Export the private key in a PFX file
[System.IO.File]::WriteAllBytes("$output_path\cert.pfx", $cert.Export("Pfx"))
```

Note

To convert the PFX file to a private key that pywinrm can use, run the following command with OpenSSL `openssl pkcs12 -in cert.pfx -nocerts -nodes -out cert_key.pem -passin pass: -passout pass:`



#### Import a Certificate to the Certificate Store[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#import-a-certificate-to-the-certificate-store)

Once a certificate has been generated, the issuing certificate needs to be imported into the `Trusted Root Certificate Authorities` of the `LocalMachine` store, and the client certificate public key must be present in the `Trusted People` folder of the `LocalMachine` store. For this example, both the issuing certificate and public key are the same.

Following example shows how to import the issuing certificate:

```
$cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 "cert.pem"

$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::Root
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($cert)
$store.Close()
```

Note

If using ADCS to generate the certificate, then the issuing certificate will already be imported and this step can be skipped.

The code to import the client certificate public key is:

```
$cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 "cert.pem"

$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPeople
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($cert)
$store.Close()
```



#### Mapping a Certificate to an Account[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#mapping-a-certificate-to-an-account)

Once the certificate has been imported, map it to the local user account:

```
$username = "username"
$password = ConvertTo-SecureString -String "password" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password

# This is the issuer thumbprint which in the case of a self generated cert
# is the public key thumbprint, additional logic may be required for other
# scenarios
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$username" }).Thumbprint

New-Item -Path WSMan:\localhost\ClientCertificate `
    -Subject "$username@localhost" `
    -URI * `
    -Issuer $thumbprint `
    -Credential $credential `
    -Force
```

Once this is complete, the hostvar `ansible_winrm_cert_pem` should be set to the path of the public key and the `ansible_winrm_cert_key_pem` variable should be set to the path of the private key.



### [NTLM](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id6)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#ntlm)

NTLM is an older authentication mechanism used by Microsoft that can support both local and domain accounts. NTLM is enabled by default on the WinRM service, so no setup is required before using it.

NTLM is the easiest authentication protocol to use and is more secure than `Basic` authentication. If running in a domain environment, `Kerberos` should be used instead of NTLM.

Kerberos has several advantages over using NTLM:

- NTLM is an older protocol and does not support newer encryption protocols.
- NTLM is slower to authenticate because it requires more round trips to the host in the authentication stage.
- Unlike Kerberos, NTLM does not allow credential delegation.

This example shows host variables configured to use NTLM authentication:

```
ansible_user: LocalUsername
ansible_password: Password
ansible_connection: winrm
ansible_winrm_transport: ntlm
```



### [Kerberos](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id7)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#kerberos)

Kerberos is the recommended authentication option to use when running in a domain environment. Kerberos supports features like credential delegation and message encryption over HTTP and is one of the more secure options that is available through WinRM.

Kerberos requires some additional setup work on the Ansible host before it can be used properly.

The following example shows host vars configured for Kerberos authentication:

```
ansible_user: username@MY.DOMAIN.COM
ansible_password: Password
ansible_connection: winrm
ansible_port: 5985
ansible_winrm_transport: kerberos
```

As of Ansible version 2.3, the Kerberos ticket will be created based on `ansible_user` and `ansible_password`. If running on an older version of Ansible or when `ansible_winrm_kinit_mode` is `manual`, a Kerberos ticket must already be obtained. See below for more details.

There are some extra host variables that can be set:

```
ansible_winrm_kinit_mode: managed/manual (manual means Ansible will not obtain a ticket)
ansible_winrm_kinit_cmd: the kinit binary to use to obtain a Kerberos ticket (default to kinit)
ansible_winrm_service: overrides the SPN prefix that is used, the default is ``HTTP`` and should rarely ever need changing
ansible_winrm_kerberos_delegation: allows the credentials to traverse multiple hops
ansible_winrm_kerberos_hostname_override: the hostname to be used for the kerberos exchange
```



#### Installing the Kerberos Library[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#installing-the-kerberos-library)

Some system dependencies that must be installed prior to using  Kerberos. The script below lists the dependencies based on the distro:

```
# Through Yum (RHEL/Centos/Fedora for the older version)
yum -y install gcc python-devel krb5-devel krb5-libs krb5-workstation

# Through DNF (RHEL/Centos/Fedora for the newer version)
dnf -y install gcc python3-devel krb5-devel krb5-libs krb5-workstation

# Through Apt (Ubuntu)
sudo apt-get install python-dev libkrb5-dev krb5-user

# Through Portage (Gentoo)
emerge -av app-crypt/mit-krb5
emerge -av dev-python/setuptools

# Through Pkg (FreeBSD)
sudo pkg install security/krb5

# Through OpenCSW (Solaris)
pkgadd -d http://get.opencsw.org/now
/opt/csw/bin/pkgutil -U
/opt/csw/bin/pkgutil -y -i libkrb5_3

# Through Pacman (Arch Linux)
pacman -S krb5
```

Once the dependencies have been installed, the `python-kerberos` wrapper can be install using `pip`:

```
pip install pywinrm[kerberos]
```

Note

While Ansible has supported Kerberos auth through `pywinrm` for some time, optional features or more secure options may only be available in newer versions of the `pywinrm` and/or `pykerberos` libraries. It is recommended you upgrade each version to the latest available to resolve any warnings or errors. This can be done through tools like `pip` or a system package manager like `dnf`, `yum`, `apt` but the package names and versions available may differ between tools.



#### Configuring Host Kerberos[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#configuring-host-kerberos)

Once the dependencies have been installed, Kerberos needs to be configured so that it can communicate with a domain. This configuration is done through the `/etc/krb5.conf` file, which is installed with the packages in the script above.

To configure Kerberos, in the section that starts with:

```
[realms]
```

Add the full domain name and the fully qualified domain names of the primary and secondary Active Directory domain controllers. It should look something like this:

```
[realms]
    MY.DOMAIN.COM = {
        kdc = domain-controller1.my.domain.com
        kdc = domain-controller2.my.domain.com
    }
```

In the section that starts with:

```
[domain_realm]
```

Add a line like the following for each domain that Ansible needs access for:

```
[domain_realm]
    .my.domain.com = MY.DOMAIN.COM
```

You can configure other settings in this file such as the default domain. See [krb5.conf](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html) for more details.



#### Automatic Kerberos Ticket Management[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#automatic-kerberos-ticket-management)

Ansible version 2.3 and later defaults to automatically managing Kerberos tickets when both `ansible_user` and `ansible_password` are specified for a host. In this process, a new ticket is created in a temporary credential cache for each host. This is done before each task executes to minimize the chance of ticket expiration. The temporary credential caches are deleted after each task completes and will not interfere with the default credential cache.

To disable automatic ticket management, set `ansible_winrm_kinit_mode=manual` through the inventory.

Automatic ticket management requires a standard `kinit` binary on the control host system path. To specify a different location or binary name, set the `ansible_winrm_kinit_cmd` hostvar to the fully qualified path to a MIT krbv5 `kinit`-compatible binary.



#### Manual Kerberos Ticket Management[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#manual-kerberos-ticket-management)

To manually manage Kerberos tickets, the `kinit` binary is used. To obtain a new ticket the following command is used:

```
kinit username@MY.DOMAIN.COM
```

Note

The domain must match the configured Kerberos realm exactly, and must be in upper case.

To see what tickets (if any) have been acquired, use the following command:

```
klist
```

To destroy all the tickets that have been acquired, use the following command:

```
kdestroy
```



#### Troubleshooting Kerberos[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#troubleshooting-kerberos)

Kerberos is reliant on a properly-configured environment to work. To troubleshoot Kerberos issues, ensure that:

- The hostname set for the Windows host is the FQDN and not an IP address. * If you connect using an IP address you will get the error message Server not found in Kerberos database. * To determine if you are connecting using an IP address or an FQDN run your playbook (or call the `win_ping` module) using the -vvv flag.

- The forward and reverse DNS lookups are working properly in the domain. To test this, ping the windows host by name and then use the ip address returned with `nslookup`. The same name should be returned when using `nslookup` on the IP address.

- The Ansible host’s clock is synchronized with the domain controller. Kerberos is time sensitive, and a little clock drift can cause the ticket generation process to fail.

- Ensure that the fully qualified domain name for the domain is configured in the `krb5.conf` file. To check this, run:

  ```
  kinit -C username@MY.DOMAIN.COM
  klist
  ```

  If the domain name returned by `klist` is different from the one requested, an alias is being used. The `krb5.conf` file needs to be updated so that the fully qualified domain name is used and not an alias.

- If the default kerberos tooling has been replaced or modified  (some IdM solutions may do this), this may cause issues when installing  or upgrading the Python Kerberos library. As of the time of this  writing, this library is called `pykerberos` and is known to work with both MIT and Heimdal Kerberos libraries. To resolve `pykerberos` installation issues, ensure the system dependencies for Kerberos have been met (see: [Installing the Kerberos Library](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#installing-the-kerberos-library)), remove any custom Kerberos tooling paths from the PATH environment  variable, and retry the installation of Python Kerberos library package.



### [CredSSP](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id8)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#credssp)

CredSSP authentication is a newer authentication protocol that allows credential delegation. This is achieved by encrypting the username and password after authentication has succeeded and sending that to the server using the CredSSP protocol.

Because the username and password are sent to the server to be used for double hop authentication, ensure that the hosts that the Windows host communicates with are not compromised and are trusted.

CredSSP can be used for both local and domain accounts and also supports message encryption over HTTP.

To use CredSSP authentication, the host vars are configured like so:

```
ansible_user: Username
ansible_password: Password
ansible_connection: winrm
ansible_winrm_transport: credssp
```

There are some extra host variables that can be set as shown below:

```
ansible_winrm_credssp_disable_tlsv1_2: when true, will not use TLS 1.2 in the CredSSP auth process
```

CredSSP authentication is not enabled by default on a Windows host, but can be enabled by running the following in PowerShell:

```
Enable-WSManCredSSP -Role Server -Force
```



#### Installing CredSSP Library[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#installing-credssp-library)

The `requests-credssp` wrapper can be installed using `pip`:

```
pip install pywinrm[credssp]
```



#### CredSSP and TLS 1.2[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#credssp-and-tls-1-2)

By default the `requests-credssp` library is configured to authenticate over the TLS 1.2 protocol. TLS 1.2 is installed and enabled by default for Windows Server 2012 and Windows 8 and more recent releases.

There are two ways that older hosts can be used with CredSSP:

- Install and enable a hotfix to enable TLS 1.2 support (recommended for Server 2008 R2 and Windows 7).
- Set `ansible_winrm_credssp_disable_tlsv1_2=True` in the inventory to run over TLS 1.0. This is the only option when connecting to Windows Server 2008, which has no way of supporting TLS 1.2

See [TLS 1.2 Support](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-tls12) for more information on how to enable TLS 1.2 on the Windows host.



#### Set CredSSP Certificate[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#set-credssp-certificate)

CredSSP works by encrypting the credentials through the TLS protocol and uses a self-signed certificate by default. The `CertificateThumbprint` option under the WinRM service configuration can be used to specify the thumbprint of another certificate.

Note

This certificate configuration is independent of the WinRM listener certificate. With CredSSP, message transport still occurs over the WinRM listener, but the TLS-encrypted messages inside the channel use the service-level certificate.

To explicitly set the certificate to use for CredSSP:

```
# Note the value $certificate_thumbprint will be different in each
# situation, this needs to be set based on the cert that is used.
$certificate_thumbprint = "7C8DCBD5427AFEE6560F4AF524E325915F51172C"

# Set the thumbprint value
Set-Item -Path WSMan:\localhost\Service\CertificateThumbprint -Value $certificate_thumbprint
```



## [Non-Administrator Accounts](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id9)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#non-administrator-accounts)

WinRM is configured by default to only allow connections from accounts in the local `Administrators` group. This can be changed by running:

```
winrm configSDDL default
```

This will display an ACL editor, where new users or groups may be added. To run commands over WinRM, users and groups must have at least the `Read` and `Execute` permissions enabled.

While non-administrative accounts can be used with WinRM, most typical server administration tasks require some level of administrative access, so the utility is usually limited.



## [WinRM Encryption](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id10)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-encryption)

By default WinRM will fail to work when running over an unencrypted channel. The WinRM protocol considers the channel to be encrypted if using TLS over HTTP (HTTPS) or using message level encryption. Using WinRM with TLS is the recommended option as it works with all authentication options, but requires a certificate to be created and used on the WinRM listener.

If in a domain environment, ADCS can create a certificate for the host that is issued by the domain itself.

If using HTTPS is not an option, then HTTP can be used when the authentication option is `NTLM`, `Kerberos` or `CredSSP`. These protocols will encrypt the WinRM payload with their own encryption method before sending it to the server. The message-level encryption is not used when running over HTTPS because the encryption uses the more secure TLS protocol instead. If both transport and message encryption is required, set `ansible_winrm_message_encryption=always` in the host vars.

Note

Message encryption over HTTP requires pywinrm>=0.3.0.

A last resort is to disable the encryption requirement on the Windows host. This should only be used for development and debugging purposes, as anything sent from Ansible can be viewed, manipulated and also the remote session can completely be taken over by anyone on the same network. To disable the encryption requirement:

```
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
```

Note

Do not disable the encryption check unless it is absolutely required. Doing so could allow sensitive information like credentials and files to be intercepted by others on the network.



## [Inventory Options](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id11)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#inventory-options)

Ansible’s Windows support relies on a few standard variables to indicate the username, password, and connection type of the remote hosts. These variables are most easily set up in the inventory, but can be set on the `host_vars`/ `group_vars` level.

When setting up the inventory, the following variables are required:

```
# It is suggested that these be encrypted with ansible-vault:
# ansible-vault edit group_vars/windows.yml
ansible_connection: winrm

# May also be passed on the command-line through --user
ansible_user: Administrator

# May also be supplied at runtime with --ask-pass
ansible_password: SecretPasswordGoesHere
```

Using the variables above, Ansible will connect to the Windows host with Basic authentication through HTTPS. If `ansible_user` has a UPN value like `username@MY.DOMAIN.COM` then the authentication option will automatically attempt to use Kerberos unless `ansible_winrm_transport` has been set to something other than `kerberos`.

The following custom inventory variables are also supported for additional configuration of WinRM connections:

- `ansible_port`: The port WinRM will run over, HTTPS is `5986` which is the default while HTTP is `5985`
- `ansible_winrm_scheme`: Specify the connection scheme (`http` or `https`) to use for the WinRM connection. Ansible uses `https` by default unless `ansible_port` is `5985`
- `ansible_winrm_path`: Specify an alternate path to the WinRM endpoint, Ansible uses `/wsman` by default
- `ansible_winrm_realm`: Specify the realm to use for Kerberos authentication. If `ansible_user` contains `@`, Ansible will use the part of the username after `@` by default
- `ansible_winrm_transport`: Specify one or more authentication transport options as a comma-separated list. By default, Ansible will use `kerberos, basic` if the `kerberos` module is installed and a realm is defined, otherwise it will be `plaintext`
- `ansible_winrm_server_cert_validation`: Specify the server certificate validation mode (`ignore` or `validate`). Ansible defaults to `validate` on Python 2.7.9 and higher, which will result in certificate validation errors against the Windows self-signed certificates. Unless verifiable certificates have been configured on the WinRM listeners, this should be set to `ignore`
- `ansible_winrm_operation_timeout_sec`: Increase the default timeout for WinRM operations, Ansible uses `20` by default
- `ansible_winrm_read_timeout_sec`: Increase the WinRM read timeout, Ansible uses `30` by default. Useful if there are intermittent network issues and read timeout errors keep occurring
- `ansible_winrm_message_encryption`: Specify the message encryption operation (`auto`, `always`, `never`) to use, Ansible uses `auto` by default. `auto` means message encryption is only used when `ansible_winrm_scheme` is `http` and `ansible_winrm_transport` supports message encryption. `always` means message encryption will always be used and `never` means message encryption will never be used
- `ansible_winrm_ca_trust_path`: Used to specify a different cacert container than the one used in the `certifi` module. See the HTTPS Certificate Validation section for more details.
- `ansible_winrm_send_cbt`: When using `ntlm` or `kerberos` over HTTPS, the authentication library will try to send channel binding tokens to mitigate against man in the middle attacks. This flag controls whether these bindings will be sent or not (default: `yes`).
- `ansible_winrm_*`: Any additional keyword arguments supported by `winrm.Protocol` may be provided in place of `*`

In addition, there are also specific variables that need to be set for each authentication option. See the section on authentication above for more information.

Note

Ansible 2.0 has deprecated the “ssh” from `ansible_ssh_user`, `ansible_ssh_pass`, `ansible_ssh_host`, and `ansible_ssh_port` to become `ansible_user`, `ansible_password`, `ansible_host`, and `ansible_port`. If using a version of Ansible prior to 2.0, the older style (`ansible_ssh_*`) should be used instead. The shorter variables are ignored, without warning, in older versions of Ansible.

Note

`ansible_winrm_message_encryption` is different from transport encryption done over TLS. The WinRM payload is still encrypted with TLS when run over HTTPS, even if `ansible_winrm_message_encryption=never`.



## [IPv6 Addresses](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id12)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#ipv6-addresses)

IPv6 addresses can be used instead of IPv4 addresses or hostnames. This option is normally set in an inventory. Ansible will attempt to parse the address using the [ipaddress](https://docs.python.org/3/library/ipaddress.html) package and pass to pywinrm correctly.

When defining a host using an IPv6 address, just add the IPv6 address as you would an IPv4 address or hostname:

```
[windows-server]
2001:db8::1

[windows-server:vars]
ansible_user=username
ansible_password=password
ansible_connection=winrm
```

Note

The ipaddress library is only included by default in Python 3.x. To use IPv6 addresses in Python 2.7, make sure to run `pip install ipaddress` which installs a backported package.



## [HTTPS Certificate Validation](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id13)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#https-certificate-validation)

As part of the TLS protocol, the certificate is validated to ensure the host matches the subject and the client trusts the issuer of the server certificate. When using a self-signed certificate or setting `ansible_winrm_server_cert_validation: ignore` these security mechanisms are bypassed. While self signed certificates will always need the `ignore` flag, certificates that have been issued from a certificate authority can still be validated.

One of the more common ways of setting up a HTTPS listener in a domain environment is to use Active Directory Certificate Service (AD CS). AD CS is used to generate signed certificates from a Certificate Signing Request (CSR). If the WinRM HTTPS listener is using a certificate that has been signed by another authority, like AD CS, then Ansible can be set up to trust that issuer as part of the TLS handshake.

To get Ansible to trust a Certificate Authority (CA) like AD CS, the issuer certificate of the CA can be exported as a PEM encoded certificate. This certificate can then be copied locally to the Ansible controller and used as a source of certificate validation, otherwise known as a CA chain.

The CA chain can contain a single or multiple issuer certificates and each entry is contained on a new line. To then use the custom CA chain as part of the validation process, set `ansible_winrm_ca_trust_path` to the path of the file. If this variable is not set, the default CA chain is used instead which is located in the install path of the Python package [certifi](https://github.com/certifi/python-certifi).

Note

Each HTTP call is done by the Python requests library which does not use the systems built-in certificate store as a trust authority. Certificate validation will fail if the server’s certificate issuer is only added to the system’s truststore.



## [TLS 1.2 Support](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id14)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#tls-1-2-support)

As WinRM runs over the HTTP protocol, using HTTPS means that the TLS protocol is used to encrypt the WinRM messages. TLS will automatically attempt to negotiate the best protocol and cipher suite that is available to both the client and the server. If a match cannot be found then Ansible will error out with a message similar to:

```
HTTPSConnectionPool(host='server', port=5986): Max retries exceeded with url: /wsman (Caused by SSLError(SSLError(1, '[SSL: UNSUPPORTED_PROTOCOL] unsupported protocol (_ssl.c:1056)')))
```

Commonly this is when the Windows host has not been configured to support TLS v1.2 but it could also mean the Ansible controller has an older OpenSSL version installed.

Windows 8 and Windows Server 2012 come with TLS v1.2 installed and enabled by default but older hosts, like Server 2008 R2 and Windows 7, have to be enabled manually.

Note

There is a bug with the TLS 1.2 patch for Server 2008 which will stop Ansible from connecting to the Windows host. This means that Server 2008 cannot be configured to use TLS 1.2. Server 2008 R2 and Windows 7 are not affected by this issue and can use TLS 1.2.

To verify what protocol the Windows host supports, you can run the following command on the Ansible controller:

```
openssl s_client -connect <hostname>:5986
```

The output will contain information about the TLS session and the `Protocol` line will display the version that was negotiated:

```
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-SHA
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1
    Cipher    : ECDHE-RSA-AES256-SHA
    Session-ID: 962A00001C95D2A601BE1CCFA7831B85A7EEE897AECDBF3D9ECD4A3BE4F6AC9B
    Session-ID-ctx:
    Master-Key: ....
    Start Time: 1552976474
    Timeout   : 7200 (sec)
    Verify return code: 21 (unable to verify the first certificate)
---

New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: AE16000050DA9FD44D03BB8839B64449805D9E43DBD670346D3D9E05D1AEEA84
    Session-ID-ctx:
    Master-Key: ....
    Start Time: 1552976538
    Timeout   : 7200 (sec)
    Verify return code: 21 (unable to verify the first certificate)
```

If the host is returning `TLSv1` then it should be configured so that TLS v1.2 is enable. You can do this by running the following PowerShell script:

```
Function Enable-TLS12 {
    param(
        [ValidateSet("Server", "Client")]
        [String]$Component = "Server"
    )

    $protocols_path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
    New-Item -Path "$protocols_path\TLS 1.2\$Component" -Force
    New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name Enabled -Value 1 -Type DWORD -Force
    New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name DisabledByDefault -Value 0 -Type DWORD -Force
}

Enable-TLS12 -Component Server

# Not required but highly recommended to enable the Client side TLS 1.2 components
Enable-TLS12 -Component Client

Restart-Computer
```

The below Ansible tasks can also be used to enable TLS v1.2:

```
- name: enable TLSv1.2 support
  win_regedit:
    path: HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\{{ item.type }}
    name: '{{ item.property }}'
    data: '{{ item.value }}'
    type: dword
    state: present
  register: enable_tls12
  loop:
  - type: Server
    property: Enabled
    value: 1
  - type: Server
    property: DisabledByDefault
    value: 0
  - type: Client
    property: Enabled
    value: 1
  - type: Client
    property: DisabledByDefault
    value: 0

- name: reboot if TLS config was applied
  win_reboot:
  when: enable_tls12 is changed
```

There are other ways to configure the TLS protocols as well as the cipher suites that are offered by the Windows host. One tool that can give you a GUI to manage these settings is [IIS Crypto](https://www.nartac.com/Products/IISCrypto/) from Nartac Software.



## [WinRM limitations](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#id15)[](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#winrm-limitations)

Due to the design of the WinRM protocol , there are a few limitations when using WinRM that can cause issues when creating playbooks for Ansible. These include:

- Credentials are not delegated for most authentication types, which causes authentication errors when accessing network resources or installing certain programs.
- Many calls to the Windows Update API are blocked when running over WinRM.
- Some programs fail to install with WinRM due to no credential delegation or because they access forbidden Windows API like WUA over WinRM.
- Commands under WinRM are done under a non-interactive session, which can prevent certain commands or executables from running.
- You cannot run a process that interacts with `DPAPI`, which is used by some installers (like Microsoft SQL Server).

Some of these limitations can be mitigated by doing one of the following:

- Set `ansible_winrm_transport` to `credssp` or `kerberos` (with `ansible_winrm_kerberos_delegation=true`) to bypass the double hop issue and access network resources
- Use `become` to bypass all WinRM restrictions and run a command as it would locally. Unlike using an authentication transport like `credssp`, this will also remove the non-interactive restriction and API restrictions like WUA and DPAPI
- Use a scheduled task to run a command which can be created with the `win_scheduled_task` module. Like `become`, this bypasses all WinRM restrictions but can only run a command and not modules.

# Desired State Configuration[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#desired-state-configuration)

Topics

- [What is Desired State Configuration?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#what-is-desired-state-configuration)
- [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#host-requirements)
- [Why Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#why-use-dsc)
- [How to Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#how-to-use-dsc)
  - [Property Types](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#property-types)
    - [PSCredential](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#pscredential)
    - [CimInstance Type](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#ciminstance-type)
    - [HashTable Type](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#hashtable-type)
    - [Arrays](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#arrays)
    - [DateTime](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#datetime)
  - [Run As Another User](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#run-as-another-user)
- [Custom DSC Resources](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#custom-dsc-resources)
  - [Finding Custom DSC Resources](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#finding-custom-dsc-resources)
  - [Installing a Custom Resource](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#installing-a-custom-resource)
- [Examples](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#examples)
  - [Extract a zip file](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#extract-a-zip-file)
  - [Create a directory](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#create-a-directory)
  - [Interact with Azure](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#interact-with-azure)
  - [Setup IIS Website](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#setup-iis-website)

## [What is Desired State Configuration?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id1)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#what-is-desired-state-configuration)

Desired State Configuration, or DSC, is a tool built into PowerShell that can be used to define a Windows host setup through code. The overall purpose of DSC is the same as Ansible, it is just executed in a different manner. Since Ansible 2.4, the `win_dsc` module has been added and can be used to take advantage of existing DSC resources when interacting with a Windows host.

More details on DSC can be viewed at [DSC Overview](https://docs.microsoft.com/en-us/powershell/scripting/dsc/overview?view=powershell-7.2).

## [Host Requirements](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id2)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#host-requirements)

To use the `win_dsc` module, a Windows host must have PowerShell v5.0 or newer installed. All supported hosts can be upgraded to PowerShell v5.

Once the PowerShell requirements have been met, using DSC is as simple as creating a task with the `win_dsc` module.

## [Why Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id3)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#why-use-dsc)

DSC and Ansible modules have a common goal which is to define and ensure the state of a resource. Because of this, resources like the DSC [File resource](https://docs.microsoft.com/en-us/powershell/scripting/dsc/reference/resources/windows/fileresource) and Ansible `win_file` can be used to achieve the same result. Deciding which to use depends on the scenario.

Reasons for using an Ansible module over a DSC resource:

- The host does not support PowerShell v5.0, or it cannot easily be upgraded
- The DSC resource does not offer a feature present in an Ansible module. For example, win_regedit can manage the `REG_NONE` property type, while the DSC `Registry` resource cannot
- DSC resources have limited check mode support, while some Ansible modules have better checks
- DSC resources do not support diff mode, while some Ansible modules do
- Custom resources require further installation steps to be run on the host beforehand, while Ansible modules are built-in to Ansible
- There are bugs in a DSC resource where an Ansible module works

Reasons for using a DSC resource over an Ansible module:

- The Ansible module does not support a feature present in a DSC resource
- There is no Ansible module available
- There are bugs in an existing Ansible module

In the end, it doesn’t matter whether the task is performed with DSC or an Ansible module; what matters is that the task is performed correctly and the playbooks are still readable. If you have more experience with DSC over Ansible and it does the job, just use DSC for that task.

## [How to Use DSC?](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id4)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#how-to-use-dsc)

The `win_dsc` module takes in a free-form of options so that it changes according to the resource it is managing. A list of built-in resources can be found at [resources](https://docs.microsoft.com/en-us/powershell/scripting/dsc/resources/resources).

Using the [Registry](https://docs.microsoft.com/en-us/powershell/scripting/dsc/reference/resources/windows/registryresource) resource as an example, this is the DSC definition as documented by Microsoft:

```
Registry [string] #ResourceName
{
    Key = [string]
    ValueName = [string]
    [ Ensure = [string] { Enable | Disable }  ]
    [ Force =  [bool]   ]
    [ Hex = [bool] ]
    [ DependsOn = [string[]] ]
    [ ValueData = [string[]] ]
    [ ValueType = [string] { Binary | Dword | ExpandString | MultiString | Qword | String }  ]
}
```

When defining the task, `resource_name` must be set to the DSC resource being used - in this case, the `resource_name` should be set to `Registry`. The `module_version` can refer to a specific version of the DSC resource installed; if left blank it will default to the latest version. The other options are parameters that are used to define the resource, such as `Key` and `ValueName`. While the options in the task are not case sensitive, keeping the case as-is is recommended because it makes it easier to distinguish DSC resource options from Ansible’s `win_dsc` options.

This is what the Ansible task version of the above DSC Registry resource would look like:

```
- name: Use win_dsc module with the Registry DSC resource
  win_dsc:
    resource_name: Registry
    Ensure: Present
    Key: HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey
    ValueName: TestValue
    ValueData: TestData
```

Starting in Ansible 2.8, the `win_dsc` module automatically validates the input options from Ansible with the DSC definition. This means Ansible will fail if the option name is incorrect, a mandatory option is not set, or the value is not a valid choice. When running Ansible with a verbosity level of 3 or more (`-vvv`), the return value will contain the possible invocation options based on the `resource_name` specified. Here is an example of the invocation output for the above `Registry` task:

```
changed: [2016] => {
    "changed": true,
    "invocation": {
        "module_args": {
            "DependsOn": null,
            "Ensure": "Present",
            "Force": null,
            "Hex": null,
            "Key": "HKEY_LOCAL_MACHINE\\SOFTWARE\\ExampleKey",
            "PsDscRunAsCredential_password": null,
            "PsDscRunAsCredential_username": null,
            "ValueData": [
                "TestData"
            ],
            "ValueName": "TestValue",
            "ValueType": null,
            "module_version": "latest",
            "resource_name": "Registry"
        }
    },
    "module_version": "1.1",
    "reboot_required": false,
    "verbose_set": [
        "Perform operation 'Invoke CimMethod' with following parameters, ''methodName' = ResourceSet,'className' = MSFT_DSCLocalConfigurationManager,'namespaceName' = root/Microsoft/Windows/DesiredStateConfiguration'.",
        "An LCM method call arrived from computer SERVER2016 with user sid S-1-5-21-3088887838-4058132883-1884671576-1105.",
        "[SERVER2016]: LCM:  [ Start  Set      ]  [[Registry]DirectResourceAccess]",
        "[SERVER2016]:                            [[Registry]DirectResourceAccess] (SET) Create registry key 'HKLM:\\SOFTWARE\\ExampleKey'",
        "[SERVER2016]:                            [[Registry]DirectResourceAccess] (SET) Set registry key value 'HKLM:\\SOFTWARE\\ExampleKey\\TestValue' to 'TestData' of type 'String'",
        "[SERVER2016]: LCM:  [ End    Set      ]  [[Registry]DirectResourceAccess]  in 0.1930 seconds.",
        "[SERVER2016]: LCM:  [ End    Set      ]    in  0.2720 seconds.",
        "Operation 'Invoke CimMethod' complete.",
        "Time taken for configuration job to complete is 0.402 seconds"
    ],
    "verbose_test": [
        "Perform operation 'Invoke CimMethod' with following parameters, ''methodName' = ResourceTest,'className' = MSFT_DSCLocalConfigurationManager,'namespaceName' = root/Microsoft/Windows/DesiredStateConfiguration'.",
        "An LCM method call arrived from computer SERVER2016 with user sid S-1-5-21-3088887838-4058132883-1884671576-1105.",
        "[SERVER2016]: LCM:  [ Start  Test     ]  [[Registry]DirectResourceAccess]",
        "[SERVER2016]:                            [[Registry]DirectResourceAccess] Registry key 'HKLM:\\SOFTWARE\\ExampleKey' does not exist",
        "[SERVER2016]: LCM:  [ End    Test     ]  [[Registry]DirectResourceAccess] False in 0.2510 seconds.",
        "[SERVER2016]: LCM:  [ End    Set      ]    in  0.3310 seconds.",
        "Operation 'Invoke CimMethod' complete.",
        "Time taken for configuration job to complete is 0.475 seconds"
    ]
}
```

The `invocation.module_args` key shows the actual values that were set as well as other possible values that were not set. Unfortunately, this will not show the default value for a DSC property, only what was set from the Ansible task. Any `*_password` option will be masked in the output for security reasons; if there are any other sensitive module options, set `no_log: True` on the task to stop all task output from being logged.

### [Property Types](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id5)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#property-types)

Each DSC resource property has a type that is associated with it. Ansible will try to convert the defined options to the correct type during execution. For simple types like `[string]` and `[bool]`, this is a simple operation, but complex types like `[PSCredential]` or arrays (like `[string[]]`) require certain rules.

#### [PSCredential](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id6)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#pscredential)

A `[PSCredential]` object is used to store credentials in a secure way, but Ansible has no way to serialize this over JSON. To set a DSC PSCredential property, the definition of that parameter should have two entries that are suffixed with `_username` and `_password` for the username and password, respectively. For example:

```
PsDscRunAsCredential_username: '{{ ansible_user }}'
PsDscRunAsCredential_password: '{{ ansible_password }}'

SourceCredential_username: AdminUser
SourceCredential_password: PasswordForAdminUser
```

Note

On versions of Ansible older than 2.8, you should set `no_log: true` on the task definition in Ansible to ensure any credentials used are not stored in any log file or console output.

A `[PSCredential]` is defined with `EmbeddedInstance("MSFT_Credential")` in a DSC resource MOF definition.

#### [CimInstance Type](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id7)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#ciminstance-type)

A `[CimInstance]` object is used by DSC to store a dictionary object based on a custom class defined by that resource. Defining a value that takes in a `[CimInstance]` in YAML is the same as defining a dictionary in YAML. For example, to define a `[CimInstance]` value in Ansible:

```
# [CimInstance]AuthenticationInfo == MSFT_xWebAuthenticationInformation
AuthenticationInfo:
  Anonymous: false
  Basic: true
  Digest: false
  Windows: true
```

In the above example, the CIM instance is a representation of the class [MSFT_xWebAuthenticationInformation](https://github.com/dsccommunity/xWebAdministration/blob/master/source/DSCResources/MSFT_xWebSite/MSFT_xWebSite.schema.mof). This class accepts four boolean variables, `Anonymous`, `Basic`, `Digest`, and `Windows`. The keys to use in a `[CimInstance]` depend on the class it represents. Please read through the documentation of the resource to determine the keys that can be used and the types of each key value. The class definition is typically located in the `<resource name>.schema.mof`.

#### [HashTable Type](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id8)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#hashtable-type)

A `[HashTable]` object is also a dictionary but does not have a strict set of keys that can/need to be defined. Like a `[CimInstance]`, define it as a normal dictionary value in YAML. A `[HashTable]]` is defined with `EmbeddedInstance("MSFT_KeyValuePair")` in a DSC resource MOF definition.

#### [Arrays](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id9)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#arrays)

Simple type arrays like `[string[]]` or `[UInt32[]]` are defined as a list or as a comma-separated string which is then cast to their type. Using a list is recommended because the values are not manually parsed by the `win_dsc` module before being passed to the DSC engine. For example, to define a simple type array in Ansible:

```
# [string[]]
ValueData: entry1, entry2, entry3
ValueData:
- entry1
- entry2
- entry3

# [UInt32[]]
ReturnCode: 0,3010
ReturnCode:
- 0
- 3010
```

Complex type arrays like `[CimInstance[]]` (array of dicts), can be defined like this example:

```
# [CimInstance[]]BindingInfo == MSFT_xWebBindingInformation
BindingInfo:
- Protocol: https
  Port: 443
  CertificateStoreName: My
  CertificateThumbprint: C676A89018C4D5902353545343634F35E6B3A659
  HostName: DSCTest
  IPAddress: '*'
  SSLFlags: 1
- Protocol: http
  Port: 80
  IPAddress: '*'
```

The above example is an array with two values of the class [MSFT_xWebBindingInformation](https://github.com/dsccommunity/xWebAdministration/blob/master/source/DSCResources/MSFT_xWebSite/MSFT_xWebSite.schema.mof). When defining a `[CimInstance[]]`, be sure to read the resource documentation to find out what keys to use in the definition.

#### [DateTime](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id10)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#datetime)

A `[DateTime]` object is a DateTime string representing the date and time in the [ISO 8601](https://www.w3.org/TR/NOTE-datetime) date time format. The value for a `[DateTime]` field should be quoted in YAML to ensure the string is properly serialized to the Windows host. Here is an example of how to define a `[DateTime]` value in Ansible:

```
# As UTC-0 (No timezone)
DateTime: '2019-02-22T13:57:31.2311892+00:00'

# As UTC+4
DateTime: '2019-02-22T17:57:31.2311892+04:00'

# As UTC-4
DateTime: '2019-02-22T09:57:31.2311892-04:00'
```

All the values above are equal to a UTC date time of February 22nd 2019 at 1:57pm with 31 seconds and 2311892 milliseconds.

### [Run As Another User](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id11)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#run-as-another-user)

By default, DSC runs each resource as the SYSTEM account and not the account that Ansible uses to run the module. This means that resources that are dynamically loaded based on a user profile, like the `HKEY_CURRENT_USER` registry hive, will be loaded under the `SYSTEM` profile. The parameter `PsDscRunAsCredential` is a parameter that can be set for every DSC resource, and force the DSC engine to run under a different account. As `PsDscRunAsCredential` has a type of `PSCredential`, it is defined with the `_username` and `_password` suffix.

Using the Registry resource type as an example, this is how to define a task to access the `HKEY_CURRENT_USER` hive of the Ansible user:

```
- name: Use win_dsc with PsDscRunAsCredential to run as a different user
  win_dsc:
    resource_name: Registry
    Ensure: Present
    Key: HKEY_CURRENT_USER\ExampleKey
    ValueName: TestValue
    ValueData: TestData
    PsDscRunAsCredential_username: '{{ ansible_user }}'
    PsDscRunAsCredential_password: '{{ ansible_password }}'
  no_log: true
```

## [Custom DSC Resources](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id12)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#custom-dsc-resources)

DSC resources are not limited to the built-in options from Microsoft. Custom modules can be installed to manage other resources that are not usually available.

### [Finding Custom DSC Resources](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id13)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#finding-custom-dsc-resources)

You can use the [PSGallery](https://www.powershellgallery.com/) to find custom resources, along with documentation on how to install them  on a Windows host.

The `Find-DscResource` cmdlet can also be used to find custom resources. For example:

```
# Find all DSC resources in the configured repositories
Find-DscResource

# Find all DSC resources that relate to SQL
Find-DscResource -ModuleName "*sql*"
```

Note

DSC resources developed by Microsoft that start with `x` means the resource is experimental and comes with no support.

### [Installing a Custom Resource](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id14)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#installing-a-custom-resource)

There are three ways that a DSC resource can be installed on a host:

- Manually with the `Install-Module` cmdlet
- Using the `win_psmodule` Ansible module
- Saving the module manually and copying it to another host

The following is an example of installing the `xWebAdministration` resources using `win_psmodule`:

```
- name: Install xWebAdministration DSC resource
  win_psmodule:
    name: xWebAdministration
    state: present
```

Once installed, the win_dsc module will be able to use the resource by referencing it with the `resource_name` option.

The first two methods above only work when the host has access to the internet. When a host does not have internet access, the module must first be installed using the methods above on another host with internet access and then copied across. To save a module to a local filepath, the following PowerShell cmdlet can be run:

```
Save-Module -Name xWebAdministration -Path C:\temp
```

This will create a folder called `xWebAdministration` in `C:\temp`, which can be copied to any host. For PowerShell to see this offline resource, it must be copied to a directory set in the `PSModulePath` environment variable. In most cases, the path `C:\Program Files\WindowsPowerShell\Module` is set through this variable, but the `win_path` module can be used to add different paths.

## [Examples](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id15)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#examples)

### [Extract a zip file](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id16)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#extract-a-zip-file)

```
- name: Extract a zip file
  win_dsc:
    resource_name: Archive
    Destination: C:\temp\output
    Path: C:\temp\zip.zip
    Ensure: Present
```

### [Create a directory](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id17)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#create-a-directory)

```
- name: Create file with some text
  win_dsc:
    resource_name: File
    DestinationPath: C:\temp\file
    Contents: |
        Hello
        World
    Ensure: Present
    Type: File

- name: Create directory that is hidden is set with the System attribute
  win_dsc:
    resource_name: File
    DestinationPath: C:\temp\hidden-directory
    Attributes: Hidden,System
    Ensure: Present
    Type: Directory
```

### [Interact with Azure](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id18)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#interact-with-azure)

```
- name: Install xAzure DSC resources
  win_psmodule:
    name: xAzure
    state: present

- name: Create virtual machine in Azure
  win_dsc:
    resource_name: xAzureVM
    ImageName: a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201409.01-en.us-127GB.vhd
    Name: DSCHOST01
    ServiceName: ServiceName
    StorageAccountName: StorageAccountName
    InstanceSize: Medium
    Windows: true
    Ensure: Present
    Credential_username: '{{ ansible_user }}'
    Credential_password: '{{ ansible_password }}'
```

### [Setup IIS Website](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#id19)[](https://docs.ansible.com/ansible/latest/os_guide/windows_dsc.html#setup-iis-website)

```
- name: Install xWebAdministration module
  win_psmodule:
    name: xWebAdministration
    state: present

- name: Install IIS features that are required
  win_dsc:
    resource_name: WindowsFeature
    Name: '{{ item }}'
    Ensure: Present
  loop:
  - Web-Server
  - Web-Asp-Net45

- name: Setup web content
  win_dsc:
    resource_name: File
    DestinationPath: C:\inetpub\IISSite\index.html
    Type: File
    Contents: |
      <html>
      <head><title>IIS Site</title></head>
      <body>This is the body</body>
      </html>
    Ensure: present

- name: Create new website
  win_dsc:
    resource_name: xWebsite
    Name: NewIISSite
    State: Started
    PhysicalPath: C:\inetpub\IISSite\index.html
    BindingInfo:
    - Protocol: https
      Port: 8443
      CertificateStoreName: My
      CertificateThumbprint: C676A89018C4D5902353545343634F35E6B3A659
      HostName: DSCTest
      IPAddress: '*'
      SSLFlags: 1
    - Protocol: http
      Port: 8080
      IPAddress: '*'
    AuthenticationInfo:
      Anonymous: false
      Basic: true
      Digest: false
      Windows: true
```

# Windows performance[](https://docs.ansible.com/ansible/latest/os_guide/windows_performance.html#windows-performance)

This document offers some performance optimizations you might like to apply to your Windows hosts to speed them up specifically in the context of using Ansible with them, and generally.

## Optimize PowerShell performance to reduce Ansible task overhead[](https://docs.ansible.com/ansible/latest/os_guide/windows_performance.html#optimize-powershell-performance-to-reduce-ansible-task-overhead)

To speed up the startup of PowerShell by around 10x, run the following PowerShell snippet in an Administrator session. Expect it to take tens of seconds.

Note

If native images have already been created by the ngen task or service, you will observe no difference in performance (but this snippet will at that point execute faster than otherwise).

```
function Optimize-PowershellAssemblies {
  # NGEN powershell assembly, improves startup time of powershell by 10x
  $old_path = $env:path
  try {
    $env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
    [AppDomain]::CurrentDomain.GetAssemblies() | % {
      if (! $_.location) {continue}
      $Name = Split-Path $_.location -leaf
      if ($Name.startswith("Microsoft.PowerShell.")) {
        Write-Progress -Activity "Native Image Installation" -Status "$name"
        ngen install $_.location | % {"`t$_"}
      }
    }
  } finally {
    $env:path = $old_path
  }
}
Optimize-PowershellAssemblies
```

PowerShell is used by every Windows Ansible module. This optimization reduces the time PowerShell takes to start up, removing that overhead from every invocation.

This snippet uses [the native image generator, ngen](https://docs.microsoft.com/en-us/dotnet/framework/tools/ngen-exe-native-image-generator#WhenToUse) to pre-emptively create native images for the assemblies that PowerShell relies on.

## Fix high-CPU-on-boot for VMs/cloud instances[](https://docs.ansible.com/ansible/latest/os_guide/windows_performance.html#fix-high-cpu-on-boot-for-vms-cloud-instances)

If you are creating golden images to spawn instances from, you can avoid a disruptive high CPU task near startup through [processing the ngen queue](https://docs.microsoft.com/en-us/dotnet/framework/tools/ngen-exe-native-image-generator#native-image-service) within your golden image creation, if you know the CPU types won’t change between golden image build process and runtime.

Place the following near the end of your playbook, bearing in mind the factors that can cause native images to be invalidated ([see MSDN](https://docs.microsoft.com/en-us/dotnet/framework/tools/ngen-exe-native-image-generator#native-images-and-jit-compilation)).

```
- name: generate native .NET images for CPU
  win_dotnet_ngen:
```

# Windows Frequently Asked Questions[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#windows-frequently-asked-questions)

Here are some commonly asked questions in regards to Ansible and Windows and their answers.

Note

This document covers questions about managing Microsoft Windows servers with Ansible. For questions about Ansible Core, please see the [general FAQ page](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#ansible-faq).

## Does Ansible work with Windows XP or Server 2003?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#does-ansible-work-with-windows-xp-or-server-2003)

Ansible does not work with Windows XP or Server 2003 hosts. Ansible does work with these Windows operating system versions:

- Windows Server 2008 1
- Windows Server 2008 R2 1
- Windows Server 2012
- Windows Server 2012 R2
- Windows Server 2016
- Windows Server 2019
- Windows 7 1
- Windows 8.1
- Windows 10

1 - See the [Server 2008 FAQ](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#windows-faq-server2008) entry for more details.

Ansible also has minimum PowerShell version requirements - please see [Setting up a Windows Host](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-setup) for the latest information.



## Are Server 2008, 2008 R2 and Windows 7 supported?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#are-server-2008-2008-r2-and-windows-7-supported)

Microsoft ended Extended Support for these versions of Windows on  January 14th, 2020, and Ansible deprecated official support in the 2.10  release. No new feature development will occur targeting these operating systems, and automated testing has ceased. However, existing modules  and features will likely continue to work, and simple pull requests to  resolve issues with these Windows versions may be accepted.

## Can I manage Windows Nano Server with Ansible?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-manage-windows-nano-server-with-ansible)

Ansible does not currently work with Windows Nano Server, since it does not have access to the full .NET Framework that is used by the majority of the modules and internal components.



## Can Ansible run on Windows?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-ansible-run-on-windows)

No, Ansible can only manage Windows hosts. Ansible cannot run on a Windows host natively, though it can run under the Windows Subsystem for Linux (WSL).

Note

The Windows Subsystem for Linux is not supported by Ansible and should not be used for production systems.

To install Ansible on WSL, the following commands can be run in the bash terminal:

```
sudo apt-get update
sudo apt-get install python3-pip git libffi-dev libssl-dev -y
pip install --user ansible pywinrm
```

To run Ansible from source instead of a release on the WSL, simply uninstall the pip installed version and then clone the git repo.

```
pip uninstall ansible -y
git clone https://github.com/ansible/ansible.git
source ansible/hacking/env-setup

# To enable Ansible on login, run the following
echo ". ~/ansible/hacking/env-setup -q' >> ~/.bashrc
```

If you encounter timeout errors when running Ansible on the WSL, this may be due to an issue with `sleep` not returning correctly. The following workaround may resolve the issue:

```
mv /usr/bin/sleep /usr/bin/sleep.orig
ln -s /bin/true /usr/bin/sleep
```

Another option is to use WSL 2 if running Windows 10 later than build 2004.

```
wsl --set-default-version 2
```

## Can I use SSH keys to authenticate to Windows hosts?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-use-ssh-keys-to-authenticate-to-windows-hosts)

You cannot use SSH keys with the WinRM or PSRP connection plugins. These connection plugins use X509 certificates for authentication instead of the SSH key pairs that SSH uses.

The way X509 certificates are generated and mapped to a user is different from the SSH implementation; consult the [Windows Remote Management](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#windows-winrm) documentation for more information.

Ansible 2.8 has added an experimental option to use the SSH connection plugin, which uses SSH keys for authentication, for Windows servers. See [this question](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#windows-faq-ssh) for more information.



## Why can I run a command locally that does not work under Ansible?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-can-i-run-a-command-locally-that-does-not-work-under-ansible)

Ansible executes commands through WinRM. These processes are different from running a command locally in these ways:

- Unless using an authentication option like CredSSP or Kerberos with credential delegation, the WinRM process does not have the ability to delegate the user’s credentials to a network resource, causing `Access is Denied` errors.
- All processes run under WinRM are in a non-interactive session. Applications that require an interactive session will not work.
- When running through WinRM, Windows restricts access to internal Windows APIs like the Windows Update API and DPAPI, which some installers and programs rely on.

Some ways to bypass these restrictions are to:

- Use `become`, which runs a command as it would when run locally. This will bypass most WinRM restrictions, as Windows is unaware the process is running under WinRM when `become` is used. See the [Understanding privilege escalation: become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become) documentation for more information.
- Use a scheduled task, which can be created with `win_scheduled_task`. Like `become`, it will bypass all WinRM restrictions, but it can only be used to run commands, not modules.
- Use `win_psexec` to run a command on the host. PSExec does not use WinRM and so will bypass any of the restrictions.
- To access network resources without any of these workarounds, you can use CredSSP or Kerberos with credential delegation enabled.

See [Understanding privilege escalation: become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become) more info on how to use become. The limitations section at [Windows Remote Management](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#windows-winrm) has more details around WinRM limitations.

## This program won’t install on Windows with Ansible[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#this-program-won-t-install-on-windows-with-ansible)

See [this question](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#windows-faq-winrm) for more information about WinRM limitations.

## What Windows modules are available?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#what-windows-modules-are-available)

Most of the Ansible modules in Ansible Core are written for a combination of Linux/Unix machines and arbitrary web services. These modules are written in Python and most of them do not work on Windows.

Because of this, there are dedicated Windows modules that are written in PowerShell and are meant to be run on Windows hosts. A list of these modules can be found [here](https://docs.ansible.com/ansible/2.9/modules/list_of_windows_modules.html#windows-modules).

In addition, the following Ansible Core modules/action-plugins work with Windows:

- add_host
- assert
- async_status
- debug
- fail
- fetch
- group_by
- include
- include_role
- include_vars
- meta
- pause
- raw
- script
- set_fact
- set_stats
- setup
- slurp
- template (also: win_template)
- wait_for_connection

Ansible Windows modules exist in the [Ansible.Windows](https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html#plugins-in-ansible-windows), [Community.Windows](https://docs.ansible.com/ansible/latest/collections/community/windows/index.html#plugins-in-community-windows), and [Chocolatey.Chocolatey](https://docs.ansible.com/ansible/latest/collections/chocolatey/chocolatey/index.html#plugins-in-chocolatey-chocolatey) collections.

## Can I run Python modules on Windows hosts?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-run-python-modules-on-windows-hosts)

No, the WinRM connection protocol is set to use PowerShell modules, so Python modules will not work. A way to bypass this issue to use `delegate_to: localhost` to run a Python module on the Ansible controller. This is useful if during a playbook, an external service needs to be contacted and there is no equivalent Windows module available.



## Can I connect to Windows hosts over SSH?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#can-i-connect-to-windows-hosts-over-ssh)

Ansible 2.8 has added an experimental option to use the SSH connection plugin to manage Windows hosts. To connect to Windows hosts over SSH, you must install and configure the [Win32-OpenSSH](https://github.com/PowerShell/Win32-OpenSSH) fork that is in development with Microsoft on the Windows host(s). While most of the basics should work with SSH, `Win32-OpenSSH` is rapidly changing, with new features added and bugs fixed in every release. It is highly recommend you [install](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH) the latest release of `Win32-OpenSSH` from the GitHub Releases page when using it with Ansible on Windows hosts.

To use SSH as the connection to a Windows host, set the following variables in the inventory:

```
ansible_connection=ssh

# Set either cmd or powershell not both
ansible_shell_type=cmd
# ansible_shell_type=powershell
```

The value for `ansible_shell_type` should either be `cmd` or `powershell`. Use `cmd` if the `DefaultShell` has not been configured on the SSH service and `powershell` if that has been set as the `DefaultShell`.

## Why is connecting to a Windows host through SSH failing?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-is-connecting-to-a-windows-host-through-ssh-failing)

Unless you are using `Win32-OpenSSH` as described above, you must connect to Windows hosts using [Windows Remote Management](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#windows-winrm). If your Ansible output indicates that SSH was used, either you did not set the connection vars properly or the host is not inheriting them correctly.

Make sure `ansible_connection: winrm` is set in the inventory for the Windows host(s).

## Why are my credentials being rejected?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-are-my-credentials-being-rejected)

This can be due to a myriad of reasons unrelated to incorrect credentials.

See HTTP 401/Credentials Rejected at [Setting up a Windows Host](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-setup) for a more detailed guide of this could mean.

## Why am I getting an error SSL CERTIFICATE_VERIFY_FAILED?[](https://docs.ansible.com/ansible/latest/os_guide/windows_faq.html#why-am-i-getting-an-error-ssl-certificate-verify-failed)

When the Ansible controller is running on Python 2.7.9+ or an older version of Python that has backported SSLContext (like Python 2.7.5 on RHEL 7), the controller will attempt to validate the certificate WinRM is using for an HTTPS connection. If the certificate cannot be validated (such as in the case of a self signed cert), it will fail the verification process.

To ignore certificate validation, add `ansible_winrm_server_cert_validation: ignore` to inventory for the Windows host.

# Managing BSD hosts with Ansible[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#managing-bsd-hosts-with-ansible)

Managing BSD machines is different from managing other Unix-like  machines. If you have managed nodes running BSD, review these topics.

- [Connecting to BSD nodes](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#connecting-to-bsd-nodes)
- [Bootstrapping BSD](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bootstrapping-bsd)
- [Setting the Python interpreter](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter)
  - [FreeBSD packages and ports](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#freebsd-packages-and-ports)
  - [INTERPRETER_PYTHON_FALLBACK](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#interpreter-python-fallback)
  - [Debug the discovery of Python](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#debug-the-discovery-of-python)
  - [Additional variables](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#additional-variables)
- [Which modules are available?](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#which-modules-are-available)
- [Using BSD as the control node](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#using-bsd-as-the-control-node)
- [BSD facts](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-facts)
- [BSD efforts and contributions](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-efforts-and-contributions)

## [Connecting to BSD nodes](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id2)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#connecting-to-bsd-nodes)

Ansible connects to managed nodes using OpenSSH by default. This  works on BSD if you use SSH keys for authentication. However, if you use SSH passwords for authentication, Ansible relies on sshpass. Most versions of sshpass do not deal well with BSD login prompts, so when  using SSH passwords against BSD machines, use `paramiko` to connect instead of OpenSSH. You can do this in ansible.cfg globally  or you can set it as an inventory/group/host variable. For example:

```
[freebsd]
mybsdhost1 ansible_connection=paramiko
```



## [Bootstrapping BSD](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id3)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bootstrapping-bsd)

Ansible is agentless by default, however, it requires Python on managed nodes. Only the [raw](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/raw_module.html#raw-module) module will operate without Python. Although this module can be used to bootstrap Ansible and install Python on BSD variants (see below), it is very limited and the use of Python is required to make full use of  Ansible’s features.

The following example installs Python which includes the json library required for full functionality of Ansible. On your control machine you can execute the following for most versions of FreeBSD:

```
ansible -m raw -a "pkg install -y python" mybsdhost1
```

Or for OpenBSD:

```
ansible -m raw -a "pkg_add python%3.8"
```

Once this is done you can now use other Ansible modules apart from the `raw` module.

Note

This example demonstrated using pkg on FreeBSD and pkg_add on  OpenBSD, however you should be able to substitute the appropriate  package tool for your BSD; the package name may also differ. Refer to  the package list or documentation of the BSD variant you are using for  the exact Python package name you intend to install.

## [Setting the Python interpreter](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id4)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter)

To support a variety of Unix-like operating systems and  distributions, Ansible cannot always rely on the existing environment or `env` variables to locate the correct Python binary. By default, modules point at `/usr/bin/python` as this is the most common location. On BSD variants, this path may  differ, so it is advised to inform Ansible of the binary’s location. See [INTERPRETER_PYTHON](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#interpreter-python). For example, set `ansible_python_interpreter` inventory variable:

```
[freebsd:vars]
ansible_python_interpreter=/usr/local/bin/python
[openbsd:vars]
ansible_python_interpreter=/usr/local/bin/python3.8
```

### [FreeBSD packages and ports](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id5)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#freebsd-packages-and-ports)

In FreeBSD, there is no guarantee that either `/usr/local/bin/python` executable file or a link to an executable file is installed by  default. The best practice for a remote host, with respect to Ansible,  is to install at least the Python version supported by Ansible, for  example, `lang/python38`, and both meta ports `lang/python3` and `lang/python`. Quoting from */usr/ports/lang/python3/pkg-descr*:

```
This is a meta port to the Python 3.x interpreter and provides symbolic links
to bin/python3, bin/pydoc3, bin/idle3 and so on to allow compatibility with
minor version agnostic python scripts.
```

Quoting from */usr/ports/lang/python/pkg-descr*:

```
This is a meta port to the Python interpreter and provides symbolic links
to bin/python, bin/pydoc, bin/idle and so on to allow compatibility with
version agnostic python scripts.
```

As a result, the following packages are installed:

```
shell> pkg info | grep python
python-3.8_3,2                 "meta-port" for the default version of Python interpreter
python3-3_3                    Meta-port for the Python interpreter 3.x
python38-3.8.12_1              Interpreted object-oriented programming language
```

and the following executables and links

```
shell> ll /usr/local/bin/ | grep python
lrwxr-xr-x  1 root  wheel       7 Jan 24 08:30 python@ -> python3
lrwxr-xr-x  1 root  wheel      14 Jan 24 08:30 python-config@ -> python3-config
lrwxr-xr-x  1 root  wheel       9 Jan 24 08:29 python3@ -> python3.8
lrwxr-xr-x  1 root  wheel      16 Jan 24 08:29 python3-config@ -> python3.8-config
-r-xr-xr-x  1 root  wheel    5248 Jan 13 01:12 python3.8*
-r-xr-xr-x  1 root  wheel    3153 Jan 13 01:12 python3.8-config*
```

### [INTERPRETER_PYTHON_FALLBACK](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id6)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#interpreter-python-fallback)

Since version 2.8 Ansible provides a useful variable `ansible_interpreter_python_fallback` to specify a list of paths to search for Python. See [INTERPRETER_PYTHON_FALLBACK](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#interpreter-python-fallback). This list will be searched and the first item found will be used. For  example, the configuration below would make the installation of the  meta-ports in the previous section redundant, that is, if you don’t  install the Python meta ports the first two items in the list will be  skipped and `/usr/local/bin/python3.8` will be discovered.

```
ansible_interpreter_python_fallback=['/usr/local/bin/python', '/usr/local/bin/python3', '/usr/local/bin/python3.8']
```

You can use this variable, prolonged by the lower versions of Python, and put it, for example, into the `group_vars/all`. Then, override it for specific groups in `group_vars/{group1, group2, ...}` and for specific hosts in `host_vars/{host1, host2, ...}` if needed. See [Variable precedence: Where should I put a variable?](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence).

### [Debug the discovery of Python](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id7)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#debug-the-discovery-of-python)

For example, given the inventory

```
shell> cat hosts
[test]
test_11
test_12
test_13

[test:vars]
ansible_connection=ssh
ansible_user=admin
ansible_become=true
ansible_become_user=root
ansible_become_method=sudo
ansible_interpreter_python_fallback=['/usr/local/bin/python', '/usr/local/bin/python3', '/usr/local/bin/python3.8']
ansible_perl_interpreter=/usr/local/bin/perl
```

The playbook below

```
shell> cat playbook.yml
- hosts: test_11
  gather_facts: false
  tasks:
    - command: which python
      register: result
    - debug:
        var: result.stdout
    - debug:
        msg: |-
          {% for i in _vars %}
          {{ i }}:
            {{ lookup('vars', i)|to_nice_yaml|indent(2) }}
          {% endfor %}
      vars:
        _vars: "{{ query('varnames', '.*python.*') }}"
```

displays the details

```
shell> ansible-playbook -i hosts playbook.yml

PLAY [test_11] *******************************************************************************

TASK [command] *******************************************************************************
[WARNING]: Platform freebsd on host test_11 is using the discovered Python interpreter at
/usr/local/bin/python, but future installation of another Python interpreter could change the
meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
changed: [test_11]

TASK [debug] *********************************************************************************
ok: [test_11] =>
  result.stdout: /usr/local/bin/python

TASK [debug] *********************************************************************************
ok: [test_11] =>
  msg: |-
    ansible_interpreter_python_fallback:
      - /usr/local/bin/python
      - /usr/local/bin/python3
      - /usr/local/bin/python3.8

    discovered_interpreter_python:
      /usr/local/bin/python

    ansible_playbook_python:
      /usr/bin/python3
```

You can see that the first item from the list `ansible_interpreter_python_fallback` was discovered at the FreeBSD remote host. The variable `ansible_playbook_python` keeps the path to Python at the Linux controller that ran the playbook.

Regarding the warning, quoting from [INTERPRETER_PYTHON](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#interpreter-python)

```
The fallback behavior will issue a warning that the interpreter
should be set explicitly (since interpreters installed later may
change which one is used). This warning behavior can be disabled by
setting auto_silent or auto_legacy_silent. ...
```

You can either ignore it or get rid of it by setting the variable `ansible_python_interpreter=auto_silent` because this is, actually, what you want by using `/usr/local/bin/python` (*“interpreters installed later may change which one is used”*). For example

```
shell> cat hosts
[test]
test_11
test_12
test_13

[test:vars]
ansible_connection=ssh
ansible_user=admin
ansible_become=true
ansible_become_user=root
ansible_become_method=sudo
ansible_interpreter_python_fallback=['/usr/local/bin/python', '/usr/local/bin/python3', '/usr/local/bin/python3.8']
ansible_python_interpreter=auto_silent
ansible_perl_interpreter=/usr/local/bin/perl
```

See also

- [Interpreter Discovery](https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html#interpreter-discovery)
- [FreeBSD Wiki: Ports/DEFAULT_VERSIONS](https://wiki.freebsd.org/Ports/DEFAULT_VERSIONS)

### [Additional variables](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id8)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#additional-variables)

If you use additional plugins beyond those bundled with Ansible, you can set similar variables for `bash`, `perl` or `ruby`, depending on how the plugin is written. For example:

```
[freebsd:vars]
ansible_python_interpreter=/usr/local/bin/python
ansible_perl_interpreter=/usr/local/bin/perl
```

## [Which modules are available?](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id9)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#which-modules-are-available)

The majority of the core Ansible modules are written for a  combination of Unix-like machines and other generic services, so most  should function well on the BSDs with the obvious exception of those  that are aimed at Linux-only technologies (such as LVG).

## [Using BSD as the control node](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id10)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#using-bsd-as-the-control-node)

Using BSD as the control machine is as simple as installing the Ansible package for your BSD variant or by following the `pip` or ‘from source’ instructions.



## [BSD facts](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id11)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-facts)

Ansible gathers facts from the BSDs in a similar manner to Linux  machines, but since the data, names and structures can vary for network, disks and other devices, one should expect the output to be slightly  different yet still familiar to a BSD administrator.



## [BSD efforts and contributions](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#id12)[](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-efforts-and-contributions)

BSD support is important to us at Ansible. Even though the majority  of our contributors use and target Linux we have an active BSD community and strive to be as BSD-friendly as possible. Please feel free to report any issues or incompatibilities you discover  with BSD; pull requests with an included fix are also welcome!