# Facter   

Facter is Puppet’s      cross-platform system profiling library. It discovers and reports per-node facts, which are      available in your Puppet manifests as variables. 

Facter is published as a gem to https://rubygems.org/. If you've already got Ruby installed, you can install Facter by running: 

```
gem install facterCopied!
```

**[Facter: CLI](https://www.puppet.com/docs/puppet/7/cli.html)**
  **[Facter: Core Facts](https://www.puppet.com/docs/puppet/7/core_facts.html)**
  **[Custom facts overview](https://www.puppet.com/docs/puppet/7/custom_facts.html#custom_facts)**
You can add custom facts by writing snippets of Ruby         code on the primary Puppet server. Puppet then uses plug-ins in modules to distribute the         facts to the client. **[Writing custom facts](https://www.puppet.com/docs/puppet/7/fact_overview.html#fact_overview)**
A typical fact in Facter is an collection of several         elements, and is written either as a simple value (“flat” fact) or as structured data         (“structured”  fact). This page shows you how to write and format facts          correctly. **[External facts](https://www.puppet.com/docs/puppet/7/external_facts.html#external_facts)**
External facts provide a way to use arbitrary executables or     scripts as  facts, or set facts statically with structured data. With this  information, you can     write a custom fact in Perl, C, or a one-line  text file. **[Configuring Facter with facter.conf](https://www.puppet.com/docs/puppet/7/configuring_facter.html#configuring_facter)**
The `facter.conf` file is a configuration file       that allows you to cache and block fact groups and facts, and manage how Facter interacts with your system. There are four sections:          `facts`, `global`, `cli` and `fact-groups`. All sections       are optional and can be listed in any order within the file.

# Facter: CLI

### Sections

[SYNOPSIS](https://www.puppet.com/docs/puppet/7/cli.html#synopsis)

[DESCRIPTION](https://www.puppet.com/docs/puppet/7/cli.html#description)

[OPTIONS](https://www.puppet.com/docs/puppet/7/cli.html#options)

[FILES](https://www.puppet.com/docs/puppet/7/cli.html#files)

[EXAMPLES](https://www.puppet.com/docs/puppet/7/cli.html#examples)

> **NOTE:** This page was generated from the Puppet source code on 2022-02-07 10:06:49 -0800

## SYNOPSIS

```
facter [options] [query] [query] [...]Copied!
```

## DESCRIPTION

Collect and display facts about the current system. The  library behind Facter is easy to extend, making Facter an easy way to  collect information about a system.

If no queries are given, then all facts will be returned.

Many of the command line options can also be set via the  HOCON config file. This file can also be used to block or cache certain  fact groups.

## OPTIONS

- `--color`:

  Enable color output.

- `--no-color`:

  Disable color output.

- `-c`, `--config`:

  The location of the config file.

- `--custom-dir`:

  A directory to use for custom facts.

- `-d`, `--debug`:

  Enable debug output.

- `--external-dir`:

  A directory to use for external facts.

- `--hocon`:

  Output in Hocon format.

- `-j`, `--json`:

  Output in JSON format.

- `-l`, `--log-level`:

  Set logging level. Supported levels are: none, trace, debug, info, warn, error, and fatal.

- `--no-block`:

  Disable fact blocking.

- `--no-cache`:

  Disable loading and refreshing facts from the cache

- `--no-custom-facts`:

  Disable custom facts.

- `--no-external-facts`:

  Disable external facts.

- `--no-ruby`:

  Disable loading Ruby, facts requiring Ruby, and custom facts.

- `--trace`:

  Enable backtraces for custom facts.

- `--verbose`:

  Enable verbose (info) output.

- `--show-legacy`:

  Show legacy facts when querying all facts.

- `-y`, `--yaml`:

  Output in YAML format.

- `--strict`:

  Enable more aggressive error reporting.

- `-t`, `--timing`:

  Show how much time it took to resolve each fact

- `--sequential`:

  Resolve facts sequentially

- `--http-debug`:

  Whether to write HTTP request and responses to stderr. This should never be used in production.

- `-p`, `--puppet`:

  Load the Puppet libraries, thus allowing Facter to load Puppet-specific facts.

- `--version, -v`:

  Print the version

- `--list-block-groups`:

  List block groups

- `--list-cache-groups`:

  List cache groups

- `--help, -h`:

  Help for all arguments

## FILES

*/etc/puppetlabs/facter/facter.conf*

A HOCON config file that can be used to specify directories for custom and external facts, set various command line options, and  specify facts to block. See example below for details, or visit the [GitHub README](https://github.com/puppetlabs/puppetlabs-hocon#overview).

## EXAMPLES

Display all facts:

```
$ facter
disks => {
  sda => {
    model => "Virtual disk",
    size => "8.00 GiB",
    size_bytes => 8589934592,
    vendor => "ExampleVendor"
  }
}
dmi => {
  bios => {
    release_date => "06/23/2013",
    vendor => "Example Vendor",
    version => "6.00"
  }
}
[...]Copied!
```

Display a single structured fact:

```
$ facter processors
{
  count => 2,
  isa => "x86_64",
  models => [
    "Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz",
    "Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz"
  ],
  physicalcount => 2
}Copied!
```

Display a single fact nested within a structured fact:

```
$ facter processors.isa
x86_64Copied!
```

Display a single legacy fact. Note that non-structured facts existing in previous versions of Facter are still available, but are not displayed by default due to redundancy with newer structured facts:

```
$ facter processorcount
2Copied!
```

Format facts as JSON:

```
$ facter --json os.name os.release.major processors.isa
{
  "os.name": "Ubuntu",
  "os.release.major": "14.04",
  "processors.isa": "x86_64"
}Copied!
```

An example config file.

```
# always loaded (CLI and as Ruby module)
global : {
    external-dir : "~/external/facts",
    custom-dir   :  [
       "~/custom/facts",
       "~/custom/facts/more-facts"
    ],
    no-external-facts : false,
    no-custom-facts   : false,
    no-ruby           : false
}
# loaded when running from the command line
cli : {
    debug     : false,
    trace     : true,
    verbose   : false,
    log-level : "info"
}
# always loaded, fact-specific configuration
facts : {
    # for valid blocklist entries, use --list-block-groups
    blocklist : [ "file system", "EC2" ],
    # for valid time-to-live entries, use --list-cache-groups
    ttls : [ { "timezone" : 30 days } ]
}
```

# Facter: Core Facts

### Sections

[Modern Facts](https://www.puppet.com/docs/puppet/7/core_facts.html#modern-facts)

- [`aio_agent_version`](https://www.puppet.com/docs/puppet/7/core_facts.html#aio-agent-version)
- [`augeas`](https://www.puppet.com/docs/puppet/7/core_facts.html#augeas)
- [`az_metadata`](https://www.puppet.com/docs/puppet/7/core_facts.html#az-metadata)
- [`cloud`](https://www.puppet.com/docs/puppet/7/core_facts.html#cloud)
- [`disks`](https://www.puppet.com/docs/puppet/7/core_facts.html#disks)
- [`dmi`](https://www.puppet.com/docs/puppet/7/core_facts.html#dmi)
- [`ec2_metadata`](https://www.puppet.com/docs/puppet/7/core_facts.html#ec2-metadata)
- [`ec2_userdata`](https://www.puppet.com/docs/puppet/7/core_facts.html#ec2-userdata)
- [`env_windows_installdir`](https://www.puppet.com/docs/puppet/7/core_facts.html#env-windows-installdir)
- [`facterversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#facterversion)
- [`filesystems`](https://www.puppet.com/docs/puppet/7/core_facts.html#filesystems)
- [`fips_enabled`](https://www.puppet.com/docs/puppet/7/core_facts.html#fips-enabled)
- [`gce`](https://www.puppet.com/docs/puppet/7/core_facts.html#gce)
- [`hypervisors`](https://www.puppet.com/docs/puppet/7/core_facts.html#hypervisors)
- [`identity`](https://www.puppet.com/docs/puppet/7/core_facts.html#identity)
- [`is_virtual`](https://www.puppet.com/docs/puppet/7/core_facts.html#is-virtual)
- [`kernel`](https://www.puppet.com/docs/puppet/7/core_facts.html#kernel)
- [`kernelmajversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#kernelmajversion)
- [`kernelrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#kernelrelease)
- [`kernelversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#kernelversion)
- [`ldom`](https://www.puppet.com/docs/puppet/7/core_facts.html#ldom)
- [`load_averages`](https://www.puppet.com/docs/puppet/7/core_facts.html#load-averages)
- [`memory`](https://www.puppet.com/docs/puppet/7/core_facts.html#memory)
- [`mountpoints`](https://www.puppet.com/docs/puppet/7/core_facts.html#mountpoints)
- [`networking`](https://www.puppet.com/docs/puppet/7/core_facts.html#networking)
- [`os`](https://www.puppet.com/docs/puppet/7/core_facts.html#os)
- [`partitions`](https://www.puppet.com/docs/puppet/7/core_facts.html#partitions)
- [`path`](https://www.puppet.com/docs/puppet/7/core_facts.html#path)
- [`processors`](https://www.puppet.com/docs/puppet/7/core_facts.html#processors)
- [`ruby`](https://www.puppet.com/docs/puppet/7/core_facts.html#ruby)
- [`solaris_zones`](https://www.puppet.com/docs/puppet/7/core_facts.html#solaris-zones)
- [`ssh`](https://www.puppet.com/docs/puppet/7/core_facts.html#ssh)
- [`system_profiler`](https://www.puppet.com/docs/puppet/7/core_facts.html#system-profiler)
- [`system_uptime`](https://www.puppet.com/docs/puppet/7/core_facts.html#system-uptime)
- [`timezone`](https://www.puppet.com/docs/puppet/7/core_facts.html#timezone)
- [`virtual`](https://www.puppet.com/docs/puppet/7/core_facts.html#virtual)
- [`xen`](https://www.puppet.com/docs/puppet/7/core_facts.html#xen)
- [`zfs_featurenumbers`](https://www.puppet.com/docs/puppet/7/core_facts.html#zfs-featurenumbers)
- [`zfs_version`](https://www.puppet.com/docs/puppet/7/core_facts.html#zfs-version)
- [`zpool_featureflags`](https://www.puppet.com/docs/puppet/7/core_facts.html#zpool-featureflags)
- [`zpool_featurenumbers`](https://www.puppet.com/docs/puppet/7/core_facts.html#zpool-featurenumbers)
- [`zpool_version`](https://www.puppet.com/docs/puppet/7/core_facts.html#zpool-version)
- [`nim_type`](https://www.puppet.com/docs/puppet/7/core_facts.html#nim-type)

[Legacy Facts](https://www.puppet.com/docs/puppet/7/core_facts.html#legacy-facts)

- [`architecture`](https://www.puppet.com/docs/puppet/7/core_facts.html#architecture)
- [`augeasversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#augeasversion)
- [`blockdevices`](https://www.puppet.com/docs/puppet/7/core_facts.html#blockdevices)
- [`blockdevice__model`](https://www.puppet.com/docs/puppet/7/core_facts.html#blockdevice-devicename-model)
- [`blockdevice__size`](https://www.puppet.com/docs/puppet/7/core_facts.html#blockdevice-devicename-size)
- [`blockdevice__vendor`](https://www.puppet.com/docs/puppet/7/core_facts.html#blockdevice-devicename-vendor)
- [`bios_release_date`](https://www.puppet.com/docs/puppet/7/core_facts.html#bios-release-date)
- [`bios_vendor`](https://www.puppet.com/docs/puppet/7/core_facts.html#bios-vendor)
- [`bios_version`](https://www.puppet.com/docs/puppet/7/core_facts.html#bios-version)
- [`boardassettag`](https://www.puppet.com/docs/puppet/7/core_facts.html#boardassettag)
- [`boardmanufacturer`](https://www.puppet.com/docs/puppet/7/core_facts.html#boardmanufacturer)
- [`boardproductname`](https://www.puppet.com/docs/puppet/7/core_facts.html#boardproductname)
- [`boardserialnumber`](https://www.puppet.com/docs/puppet/7/core_facts.html#boardserialnumber)
- [`chassisassettag`](https://www.puppet.com/docs/puppet/7/core_facts.html#chassisassettag)
- [`chassistype`](https://www.puppet.com/docs/puppet/7/core_facts.html#chassistype)
- [`dhcp_servers`](https://www.puppet.com/docs/puppet/7/core_facts.html#dhcp-servers)
- [`domain`](https://www.puppet.com/docs/puppet/7/core_facts.html#domain)
- [`fqdn`](https://www.puppet.com/docs/puppet/7/core_facts.html#fqdn)
- [`gid`](https://www.puppet.com/docs/puppet/7/core_facts.html#gid)
- [`hardwareisa`](https://www.puppet.com/docs/puppet/7/core_facts.html#hardwareisa)
- [`hardwaremodel`](https://www.puppet.com/docs/puppet/7/core_facts.html#hardwaremodel)
- [`hostname`](https://www.puppet.com/docs/puppet/7/core_facts.html#hostname)
- [`id`](https://www.puppet.com/docs/puppet/7/core_facts.html#id)
- [`interfaces`](https://www.puppet.com/docs/puppet/7/core_facts.html#interfaces)
- [`ipaddress`](https://www.puppet.com/docs/puppet/7/core_facts.html#ipaddress)
- [`ipaddress6`](https://www.puppet.com/docs/puppet/7/core_facts.html#ipaddress6)
- [`ipaddress6_`](https://www.puppet.com/docs/puppet/7/core_facts.html#ipaddress6-interface)
- [`ipaddress_`](https://www.puppet.com/docs/puppet/7/core_facts.html#ipaddress-interface)
- [`ldom_`](https://www.puppet.com/docs/puppet/7/core_facts.html#ldom-name)
- [`lsbdistcodename`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbdistcodename)
- [`lsbdistdescription`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbdistdescription)
- [`lsbdistid`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbdistid)
- [`lsbdistrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbdistrelease)
- [`lsbmajdistrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbmajdistrelease)
- [`lsbminordistrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbminordistrelease)
- [`lsbrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#lsbrelease)
- [`macaddress`](https://www.puppet.com/docs/puppet/7/core_facts.html#macaddress)
- [`macaddress_`](https://www.puppet.com/docs/puppet/7/core_facts.html#macaddress-interface)
- [`macosx_buildversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-buildversion)
- [`macosx_productname`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-productname)
- [`macosx_productversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-productversion)
- [`macosx_productversion_major`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-productversion-major)
- [`macosx_productversion_minor`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-productversion-minor)
- [`macosx_productversion_patch`](https://www.puppet.com/docs/puppet/7/core_facts.html#macosx-productversion-patch)
- [`manufacturer`](https://www.puppet.com/docs/puppet/7/core_facts.html#manufacturer)
- [`memoryfree`](https://www.puppet.com/docs/puppet/7/core_facts.html#memoryfree)
- [`memoryfree_mb`](https://www.puppet.com/docs/puppet/7/core_facts.html#memoryfree-mb)
- [`memorysize`](https://www.puppet.com/docs/puppet/7/core_facts.html#memorysize)
- [`memorysize_mb`](https://www.puppet.com/docs/puppet/7/core_facts.html#memorysize-mb)
- [`mtu_`](https://www.puppet.com/docs/puppet/7/core_facts.html#mtu-interface)
- [`netmask`](https://www.puppet.com/docs/puppet/7/core_facts.html#netmask)
- [`netmask6`](https://www.puppet.com/docs/puppet/7/core_facts.html#netmask6)
- [`netmask6_`](https://www.puppet.com/docs/puppet/7/core_facts.html#netmask6-interface)
- [`netmask_`](https://www.puppet.com/docs/puppet/7/core_facts.html#netmask-interface)
- [`network`](https://www.puppet.com/docs/puppet/7/core_facts.html#network)
- [`network6`](https://www.puppet.com/docs/puppet/7/core_facts.html#network6)
- [`network6_`](https://www.puppet.com/docs/puppet/7/core_facts.html#network6-interface)
- [`network_`](https://www.puppet.com/docs/puppet/7/core_facts.html#network-interface)
- [`operatingsystem`](https://www.puppet.com/docs/puppet/7/core_facts.html#operatingsystem)
- [`operatingsystemmajrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#operatingsystemmajrelease)
- [`operatingsystemrelease`](https://www.puppet.com/docs/puppet/7/core_facts.html#operatingsystemrelease)
- [`osfamily`](https://www.puppet.com/docs/puppet/7/core_facts.html#osfamily)
- [`physicalprocessorcount`](https://www.puppet.com/docs/puppet/7/core_facts.html#physicalprocessorcount)
- [`processor`](https://www.puppet.com/docs/puppet/7/core_facts.html#processorn)
- [`processorcount`](https://www.puppet.com/docs/puppet/7/core_facts.html#processorcount)
- [`productname`](https://www.puppet.com/docs/puppet/7/core_facts.html#productname)
- [`rubyplatform`](https://www.puppet.com/docs/puppet/7/core_facts.html#rubyplatform)
- [`rubysitedir`](https://www.puppet.com/docs/puppet/7/core_facts.html#rubysitedir)
- [`rubyversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#rubyversion)
- [`scope6`](https://www.puppet.com/docs/puppet/7/core_facts.html#scope6)
- [`scope6_`](https://www.puppet.com/docs/puppet/7/core_facts.html#scope6-interface)
- [`selinux`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux)
- [`selinux_config_mode`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux-config-mode)
- [`selinux_config_policy`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux-config-policy)
- [`selinux_current_mode`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux-current-mode)
- [`selinux_enforced`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux-enforced)
- [`selinux_policyversion`](https://www.puppet.com/docs/puppet/7/core_facts.html#selinux-policyversion)
- [`serialnumber`](https://www.puppet.com/docs/puppet/7/core_facts.html#serialnumber)
- [`sp_`](https://www.puppet.com/docs/puppet/7/core_facts.html#sp-name)
- [`sshkey`](https://www.puppet.com/docs/puppet/7/core_facts.html#sshalgorithmkey)
- [`sshfp_`](https://www.puppet.com/docs/puppet/7/core_facts.html#sshfp-algorithm)
- [`swapencrypted`](https://www.puppet.com/docs/puppet/7/core_facts.html#swapencrypted)
- [`swapfree`](https://www.puppet.com/docs/puppet/7/core_facts.html#swapfree)
- [`swapfree_mb`](https://www.puppet.com/docs/puppet/7/core_facts.html#swapfree-mb)
- [`swapsize`](https://www.puppet.com/docs/puppet/7/core_facts.html#swapsize)
- [`swapsize_mb`](https://www.puppet.com/docs/puppet/7/core_facts.html#swapsize-mb)
- [`windows_edition_id`](https://www.puppet.com/docs/puppet/7/core_facts.html#windows-edition-id)
- [`windows_installation_type`](https://www.puppet.com/docs/puppet/7/core_facts.html#windows-installation-type)
- [`windows_product_name`](https://www.puppet.com/docs/puppet/7/core_facts.html#windows-product-name)
- [`windows_release_id`](https://www.puppet.com/docs/puppet/7/core_facts.html#windows-release-id)
- [`system32`](https://www.puppet.com/docs/puppet/7/core_facts.html#system32)
- [`uptime`](https://www.puppet.com/docs/puppet/7/core_facts.html#uptime)
- [`uptime_days`](https://www.puppet.com/docs/puppet/7/core_facts.html#uptime-days)
- [`uptime_hours`](https://www.puppet.com/docs/puppet/7/core_facts.html#uptime-hours)
- [`uptime_seconds`](https://www.puppet.com/docs/puppet/7/core_facts.html#uptime-seconds)
- [`uuid`](https://www.puppet.com/docs/puppet/7/core_facts.html#uuid)
- [`xendomains`](https://www.puppet.com/docs/puppet/7/core_facts.html#xendomains)
- [`zone__brand`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-brand)
- [`zone__iptype`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-iptype)
- [`zone__name`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-name)
- [`zone__uuid`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-uuid)
- [`zone__id`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-id)
- [`zone__path`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-path)
- [`zone__status`](https://www.puppet.com/docs/puppet/7/core_facts.html#zone-name-status)
- [`zonename`](https://www.puppet.com/docs/puppet/7/core_facts.html#zonename)
- [`zones`](https://www.puppet.com/docs/puppet/7/core_facts.html#zones)

Expand

> **NOTE:** This page was generated from the Puppet source code on 2022-02-07 10:06:14 -0800

This is a list of all of the built-in facts that ship with Facter, which includes both legacy facts and newer structured facts.

Not all of them apply to every system, and your site might also use [custom facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#custom_facts) delivered via Puppet modules. To see the full list of structured facts  and values on a given system (including plugin facts), run `puppet facts` at the command line. If you are using Puppet Enterprise, you can view  all of the facts for any node on the node's page in the console.

You can access facts in your Puppet manifests as `$fact_name` or `$facts[fact_name]`. For more information, see [the Puppet docs on facts and built-in variables.](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html)

> **Legacy Facts Note:** As of Facter 3, legacy facts such as `architecture` are hidden by default to reduce noise in Facter's default command-line  output. These older facts are now part of more useful structured facts;  for example, `architecture` is now part of the `os` fact and accessible as `os.architecture`. You can still use these legacy facts in Puppet manifests (`$architecture`), request them on the command line (`facter architecture`), and view them alongside structured facts (`facter --show-legacy`).

## Modern Facts

### `aio_agent_version`

**Type:** string

**Purpose:**

Return the version of the puppet-agent package that installed facter.

### `augeas`

**Type:** map

**Purpose:**

Return information about augeas.

**Elements:**

- `version` (string) --- The version of augparse.

### `az_metadata`

**Type:** map

**Purpose:**

Return the Microsoft Azure instance metadata. Please see the [Microsoft Azure instance metadata documentation](http://https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service) for the contents of this fact.

### `cloud`

**Type:** map

**Purpose:**

Information about the cloud instance of the node. This is currently only populated on nodes running in Microsoft Azure.

**Elements:**

- `provider` (string) --- The cloud provider for the node.

### `disks`

**Type:** map

**Purpose:**

Return the disk (block) devices attached to the system.

**Elements:**

- `<devicename>` (map) --- Represents a disk or block device.
  - `model` (string) --- The model of the disk or block device.
  - `product` (string) --- The product name of the disk or block device.
  - `serial_number` (string) --- The serial number of the disk or block device.
  - `size` (string) --- The display size of the disk or block device, such as "1 GiB".
  - `size_bytes` (integer) --- The size of the disk or block device, in bytes.
  - `vendor` (string) --- The vendor of the disk or block device.
  - `type` (string) --- The type of disk or block device (sshd or hdd). This fact is available only on Linux.

### `dmi`

**Type:** map

**Purpose:**

Return the system management information.

**Elements:**

- `bios` (map) --- The system BIOS information.
  - `release_date` (string) --- The release date of the system BIOS.
  - `vendor` (string) --- The vendor of the system BIOS.
  - `version` (string) --- The version of the system BIOS.
- `board` (map) --- The system board information.
  - `asset_tag` (string) --- The asset tag of the system board.
  - `manufacturer` (string) --- The manufacturer of the system board.
  - `product` (string) --- The product name of the system board.
  - `serial_number` (string) --- The serial number of the system board.
- `chassis` (map) --- The system chassis information.
  - `asset_tag` (string) --- The asset tag of the system chassis.
  - `type` (string) --- The type of the system chassis.
- `manufacturer` (string) --- The system manufacturer.
- `product` (map) --- The system product information.
  - `name` (string) --- The product name of the system.
  - `serial_number` (string) --- The product serial number of the system.
  - `uuid` (string) --- The product unique identifier of the system.

### `ec2_metadata`

**Type:** map

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance metadata. Please see the [EC2 instance metadata documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.

### `ec2_userdata`

**Type:** string

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance user data. Please see the [EC2 instance user data documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.

### `env_windows_installdir`

**Type:** string

**Purpose:**

Return the path of the directory in which Puppet was installed.

### `facterversion`

**Type:** string

**Purpose:**

Return the version of facter.

### `filesystems`

**Type:** string

**Purpose:**

Return the usable file systems for block or disk devices.

### `fips_enabled`

**Type:** boolean

**Purpose:**

Return whether the platform is in FIPS mode

**Details:**

Only available on Windows and Redhat linux family

### `gce`

**Type:** map

**Purpose:**

Return the Google Compute Engine (GCE) metadata. Please see the [GCE metadata documentation](https://cloud.google.com/compute/docs/metadata) for the contents of this fact.

### `hypervisors`

**Type:** map

**Purpose:**

Experimental fact: Return the names of any detected hypervisors and any collected metadata about them.

### `identity`

**Type:** map

**Purpose:**

Return the identity information of the user running facter.

**Elements:**

- `gid` (integer) --- The group identifier of the user running facter.
- `group` (string) --- The group name of the user running facter.
- `uid` (integer) --- The user identifier of the user running facter.
- `user` (string) --- The user name of the user running facter.
- `privileged` (boolean) --- True if facter is running as a privileged process or false if not.

### `is_virtual`

**Type:** boolean

**Purpose:**

Return whether or not the host is a virtual machine.

### `kernel`

**Type:** string

**Purpose:**

Return the kernel's name.

### `kernelmajversion`

**Type:** string

**Purpose:**

Return the kernel's major version.

### `kernelrelease`

**Type:** string

**Purpose:**

Return the kernel's release.

### `kernelversion`

**Type:** string

**Purpose:**

Return the kernel's version.

### `ldom`

**Type:** map

**Purpose:**

Return Solaris LDom information from the `virtinfo` utility.

### `load_averages`

**Type:** map

**Purpose:**

Return the load average over the last 1, 5 and 15 minutes.

**Elements:**

- `1m` (double) --- The system load average over the last minute.
- `5m` (double) --- The system load average over the last 5 minutes.
- `15m` (double) --- The system load average over the last 15 minutes.

### `memory`

**Type:** map

**Purpose:**

Return the system memory information.

**Elements:**

- `swap` (map) --- Represents information about swap memory.
  - `available` (string) --- The display size of the available amount of swap memory, such as "1 GiB".
  - `available_bytes` (integer) --- The size of the available amount of swap memory, in bytes.
  - `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
  - `encrypted` (boolean) --- True if the swap is encrypted or false if not.
  - `total` (string) --- The display size of the total amount of swap memory, such as "1 GiB".
  - `total_bytes` (integer) --- The size of the total amount of swap memory, in bytes.
  - `used` (string) --- The display size of the used amount of swap memory, such as "1 GiB".
  - `used_bytes` (integer) --- The size of the used amount of swap memory, in bytes.
- `system` (map) --- Represents information about system memory.
  - `available` (string) --- The display size of the available amount of system memory, such as "1 GiB".
  - `available_bytes` (integer) --- The size of the available amount of system memory, in bytes.
  - `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
  - `total` (string) --- The display size of the total amount of system memory, such as "1 GiB".
  - `total_bytes` (integer) --- The size of the total amount of system memory, in bytes.
  - `used` (string) --- The display size of the used amount of system memory, such as "1 GiB".
  - `used_bytes` (integer) --- The size of the used amount of system memory, in bytes.

### `mountpoints`

**Type:** map

**Purpose:**

Return the current mount points of the system.

**Elements:**

- `<mountpoint>` (map) --- Represents a mount point.
  - `available` (string) --- The display size of the available space, such as "1 GiB".
  - `available_bytes` (integer) --- The size of the available space, in bytes.
  - `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
  - `device` (string) --- The name of the mounted device.
  - `filesystem` (string) --- The file system of the mounted device.
  - `options` (array) --- The mount options.
  - `size` (string) --- The display size of the total space, such as "1 GiB".
  - `size_bytes` (integer) --- The size of the total space, in bytes.
  - `used` (string) --- The display size of the used space, such as "1 GiB".
  - `used_bytes` (integer) --- The size of the used space, in bytes.

### `networking`

**Type:** map

**Purpose:**

Return the networking information for the system.

**Elements:**

- `dhcp` (ip) --- The address of the DHCP server for the default interface.
- `domain` (string) --- The domain name of the system.
- `fqdn` (string) --- The fully-qualified domain name of the system.
- `hostname` (string) --- The host name of the system.
- `interfaces` (map) --- The network interfaces of the system.
  - `<interface>` (map) --- Represents a network interface.
    - `bindings` (array) --- The array of IPv4 address bindings for the interface.
    - `bindings6` (array) --- The array of IPv6 address bindings for the interface.
    - `dhcp` (ip) --- The DHCP server for the network interface.
    - `ip` (ip) --- The IPv4 address for the network interface.
    - `ip6` (ip6) --- The IPv6 address for the network interface.
    - `mac` (mac) --- The MAC address for the network interface.
    - `mtu` (integer) --- The Maximum Transmission Unit (MTU) for the network interface.
    - `netmask` (ip) --- The IPv4 netmask for the network interface.
    - `netmask6` (ip6) --- The IPv6 netmask for the network interface.
    - `network` (ip) --- The IPv4 network for the network interface.
    - `network6` (ip6) --- The IPv6 network for the network interface.
    - `scope6` (string) --- The IPv6 scope for the network interface.
- `ip` (ip) --- The IPv4 address of the default network interface.
- `ip6` (ip6) --- The IPv6 address of the default network interface.
- `mac` (mac) --- The MAC address of the default network interface.
- `mtu` (integer) --- The Maximum Transmission Unit (MTU) of the default network interface.
- `netmask` (ip) --- The IPv4 netmask of the default network interface.
- `netmask6` (ip6) --- The IPv6 netmask of the default network interface.
- `network` (ip) --- The IPv4 network of the default network interface.
- `network6` (ip6) --- The IPv6 network of the default network interface.
- `primary` (string) --- The name of the primary interface.
- `scope6` (string) --- The IPv6 scope of the default network interface.

### `os`

**Type:** map

**Purpose:**

Return information about the host operating system.

**Elements:**

- `architecture` (string) --- The operating system's hardware architecture.
- `distro` (map) --- Represents information about a Linux distribution.
  - `codename` (string) --- The code name of the Linux distribution.
  - `description` (string) --- The description of the Linux distribution.
  - `id` (string) --- The identifier of the Linux distribution.
  - `release` (map) --- Represents information about a Linux distribution release.
    - `full` (string) --- The full release of the Linux distribution.
    - `major` (string) --- The major release of the Linux distribution.
    - `minor` (string) --- The minor release of the Linux distribution.
  - `specification` (string) --- The Linux Standard Base (LSB) release specification.
- `family` (string) --- The operating system family.
- `hardware` (string) --- The operating system's hardware model.
- `macosx` (map) --- Represents information about Mac OSX.
  - `build` (string) --- The Mac OSX build version.
  - `product` (string) --- The Mac OSX product name.
  - `version` (map) --- Represents information about the Mac OSX version.
    - `full` (string) --- The full Mac OSX version number.
    - `major` (string) --- The major Mac OSX version number.
    - `minor` (string) --- The minor Mac OSX version number.
    - `patch` (string) --- The patch Mac OSX version number.
- `name` (string) --- The operating system's name.
- `release` (map) --- Represents the operating system's release.
  - `full` (string) --- The full operating system release.
  - `major` (string) --- The major release of the operating system.
  - `minor` (string) --- The minor release of the operating system.
  - `patchlevel` (string) --- The patchlevel of the operating system.
  - `branch` (string) --- The branch the operating system was cut from.
- `selinux` (map) --- Represents information about Security-Enhanced Linux (SELinux).
  - `config_mode` (string) --- The configured SELinux mode.
  - `config_policy` (string) --- The configured SELinux policy.
  - `current_mode` (string) --- The current SELinux mode.
  - `enabled` (boolean) --- True if SELinux is enabled or false if not.
  - `enforced` (boolean) --- True if SELinux policy is enforced or false if not.
  - `policy_version` (string) --- The version of the SELinux policy.
- `windows` (map) --- Represents information about Windows.
  - `edition_id` (string) --- Specify the edition variant. (ServerStandard|Professional|Enterprise)
  - `installation_type` (string) --- Specify the installation type. (Server|Server Core|Client)
  - `product_name` (string) --- Specify the textual product name.
  - `release_id` (string) --- Windows Build Version of the form YYMM.
  - `system32` (string) --- The path to the System32 directory.

### `partitions`

**Type:** map

**Purpose:**

Return the disk partitions of the system.

**Elements:**

- `<partition>` (map) --- Represents a disk partition.
  - `filesystem` (string) --- The file system of the partition.
  - `label` (string) --- The label of the partition.
  - `mount` (string) --- The mount point of the partition (if mounted).
  - `partlabel` (string) --- The label of a GPT partition.
  - `partuuid` (string) --- The unique identifier of a GPT partition.
  - `size` (string) --- The display size of the partition, such as "1 GiB".
  - `size_bytes` (integer) --- The size of the partition, in bytes.
  - `uuid` (string) --- The unique identifier of a partition.
  - `backing_file` (string) --- The path to the file backing the partition.

### `path`

**Type:** string

**Purpose:**

Return the PATH environment variable.

### `processors`

**Type:** map

**Purpose:**

Return information about the system's processors.

**Elements:**

- `count` (integer) --- The count of logical processors.
- `isa` (string) --- The processor instruction set architecture.
- `models` (array) --- The processor model strings (one for each logical processor).
- `physicalcount` (integer) --- The count of physical processors.
- `speed` (string) --- The speed of the processors, such as "2.0 GHz".
- `cores` (integer) --- The number of cores per processor socket.
- `threads` (integer) --- The number of threads per processor core.

### `ruby`

**Type:** map

**Purpose:**

Return information about the Ruby loaded by facter.

**Elements:**

- `platform` (string) --- The platform Ruby was built for.
- `sitedir` (string) --- The path to Ruby's site library directory.
- `version` (string) --- The version of Ruby.

### `solaris_zones`

**Type:** map

**Purpose:**

Return information about Solaris zones.

**Elements:**

- `current` (string) --- The name of the current Solaris zone.
- `zones` (map) --- Represents the Solaris zones.
  - `<zonename>` (map) --- Represents a Solaris zone.
    - `brand` (string) --- The brand of the Solaris zone.
    - `id` (string) --- The id of the Solaris zone.
    - `ip_type` (string) --- The IP type of the Solaris zone.
    - `path` (string) --- The path of the Solaris zone.
    - `status` (string) --- The status of the Solaris zone.
    - `uuid` (string) --- The unique identifier of the Solaris zone.

### `ssh`

**Type:** map

**Purpose:**

Return SSH public keys and fingerprints.

**Elements:**

- `dsa` (map) --- Represents the public key and fingerprints for the DSA algorithm.
  - `fingerprints` (map) --- Represents fingerprint information.
    - `sha1` (string) --- The SHA1 fingerprint of the public key.
    - `sha256` (string) --- The SHA256 fingerprint of the public key.
  - `key` (string) --- The DSA public key.
  - `type` (string) --- The exact type of the key, i.e. "ssh-dss".
- `ecdsa` (map) --- Represents the public key and fingerprints for the ECDSA algorithm.
  - `fingerprints` (map) --- Represents fingerprint information.
    - `sha1` (string) --- The SHA1 fingerprint of the public key.
    - `sha256` (string) --- The SHA256 fingerprint of the public key.
  - `key` (string) --- The ECDSA public key.
  - `type` (string) --- The exact type of the key, e.g. "ecdsa-sha2-nistp256".
- `ed25519` (map) --- Represents the public key and fingerprints for the Ed25519 algorithm.
  - `fingerprints` (map) --- Represents fingerprint information.
    - `sha1` (string) --- The SHA1 fingerprint of the public key.
    - `sha256` (string) --- The SHA256 fingerprint of the public key.
  - `key` (string) --- The Ed25519 public key.
  - `type` (string) --- The exact type of the key, i.e. "ssh-ed25519".
- `rsa` (map) --- Represents the public key and fingerprints for the RSA algorithm.
  - `fingerprints` (map) --- Represents fingerprint information.
    - `sha1` (string) --- The SHA1 fingerprint of the public key.
    - `sha256` (string) --- The SHA256 fingerprint of the public key.
  - `key` (string) --- The RSA public key.
  - `type` (string) --- The exact type of the key, i.e. "ssh-rsa".

### `system_profiler`

**Type:** map

**Purpose:**

Return information from the Mac OSX system profiler.

**Elements:**

- `boot_mode` (string) --- The boot mode.
- `boot_rom_version` (string) --- The boot ROM version.
- `boot_volume` (string) --- The boot volume.
- `computer_name` (string) --- The name of the computer.
- `cores` (string) --- The total number of processor cores.
- `hardware_uuid` (string) --- The hardware unique identifier.
- `kernel_version` (string) --- The version of the kernel.
- `l2_cache_per_core` (string) --- The size of the processor per-core L2 cache.
- `l3_cache` (string) --- The size of the processor L3 cache.
- `memory` (string) --- The size of the system memory.
- `model_identifier` (string) --- The identifier of the computer model.
- `model_name` (string) --- The name of the computer model.
- `processor_name` (string) --- The model name of the processor.
- `processor_speed` (string) --- The speed of the processor.
- `processors` (string) --- The total number of processors.
- `secure_virtual_memory` (string) --- Whether or not secure virtual memory is enabled.
- `serial_number` (string) --- The serial number of the computer.
- `smc_version` (string) --- The System Management Controller (SMC) version.
- `system_version` (string) --- The operating system version.
- `uptime` (string) --- The uptime of the system.
- `username` (string) --- The name of the user running facter.

### `system_uptime`

**Type:** map

**Purpose:**

Return the system uptime information.

**Elements:**

- `days` (integer) --- The number of complete days the system has been up.
- `hours` (integer) --- The number of complete hours the system has been up.
- `seconds` (integer) --- The number of total seconds the system has been up.
- `uptime` (string) --- The full uptime string.

### `timezone`

**Type:** string

**Purpose:**

Return the system timezone.

### `virtual`

**Type:** string

**Purpose:**

Return the hypervisor name for virtual machines or "physical" for physical machines.

### `xen`

**Type:** map

**Purpose:**

Return metadata for the Xen hypervisor.

**Elements:**

- `domains` (array) --- list of strings identifying active Xen domains.

### `zfs_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS.

### `zfs_version`

**Type:** string

**Purpose:**

Return the version for ZFS.

### `zpool_featureflags`

**Type:** string

**Purpose:**

Return the comma-delimited feature flags for ZFS storage pools.

### `zpool_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS storage pools.

### `zpool_version`

**Type:** string

**Purpose:**

Return the version for ZFS storage pools.

### `nim_type`

**Type:** string

**Purpose:**

Tells if the node is master or standalone inside an AIX Nim environment.

**Details:**

Is Available only on AIX.

## Legacy Facts

### `architecture`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware architecture.

### `augeasversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of augeas.

### `blockdevices`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a comma-separated list of block devices.

### `blockdevice_<devicename>_model`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model name of block devices attached to the system.

### `blockdevice_<devicename>_size`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the size of a block device in bytes.

### `blockdevice_<devicename>_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor name of block devices attached to the system.

### `bios_release_date`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release date of the system BIOS.

### `bios_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor of the system BIOS.

### `bios_version`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of the system BIOS.

### `boardassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board asset tag.

### `boardmanufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board manufacturer.

### `boardproductname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board product name.

### `boardserialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board serial number.

### `chassisassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis asset tag.

### `chassistype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis type.

### `dhcp_servers`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** map

**Purpose:**

Return the DHCP servers for the system.

**Elements:**

- `<interface>` (ip) --- The DHCP server for the interface.
- `system` (ip) --- The DHCP server for the default interface.

### `domain`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the network domain of the system.

### `fqdn`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the fully qualified domain name (FQDN) of the system.

### `gid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the group identifier (GID) of the user running facter.

### `hardwareisa`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the hardware instruction set architecture (ISA).

### `hardwaremodel`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware model.

### `hostname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the host name of the system.

### `id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the user identifier (UID) of the user running facter.

### `interfaces`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the comma-separated list of network interface names.

### `ipaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for the default network interface.

### `ipaddress6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for the default network interface.

### `ipaddress6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for a network interface.

### `ipaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for a network interface.

### `ldom_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Solaris LDom information.

### `lsbdistcodename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution code name.

### `lsbdistdescription`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution description.

### `lsbdistid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution identifier.

### `lsbdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution release.

### `lsbmajdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) major distribution release.

### `lsbminordistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) minor distribution release.

### `lsbrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) release.

### `macaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for the default network interface.

### `macaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for a network interface.

### `macosx_buildversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX build version.

### `macosx_productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product name.

### `macosx_productversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product version.

### `macosx_productversion_major`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product major version.

### `macosx_productversion_minor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product minor version.

### `macosx_productversion_patch`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product patch version.

### `manufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system manufacturer.

### `memoryfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free system memory, such as "1 GiB".

### `memoryfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free system memory, in mebibytes.

### `memorysize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total system memory, such as "1 GiB".

### `memorysize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total system memory, in mebibytes.

### `mtu_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the Maximum Transmission Unit (MTU) for a network interface.

### `netmask`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for the default network interface.

### `netmask6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for the default network interface.

### `netmask6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for a network interface.

### `netmask_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for a network interface.

### `network`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for the default network interface.

### `network6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for the default network interface.

### `network6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for a network interface.

### `network_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for a network interface.

### `operatingsystem`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the operating system.

### `operatingsystemmajrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the major release of the operating system.

### `operatingsystemrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release of the operating system.

### `osfamily`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the family of the operating system.

### `physicalprocessorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of physical processors.

### `processor<N>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model string of processor N.

### `processorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of logical processors.

### `productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product name.

### `rubyplatform`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the platform Ruby was built for.

### `rubysitedir`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to Ruby's site library directory.

### `rubyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of Ruby.

### `scope6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IPv6 scope for the default network interface.

### `scope6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IPv6 scope for the default network interface.

### `selinux`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enabled.

### `selinux_config_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) mode.

### `selinux_config_policy`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) policy.

### `selinux_current_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the current Security-Enhanced Linux (SELinux) mode.

### `selinux_enforced`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enforced.

### `selinux_policyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Security-Enhanced Linux (SELinux) policy version.

### `serialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product serial number.

### `sp_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Mac OSX system profiler information.

### `ssh<algorithm>key`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH public key for the algorithm.

### `sshfp_<algorithm>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH fingerprints for the algorithm's public key.

### `swapencrypted`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether or not the swap is encrypted.

### `swapfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free swap memory, such as "1 GiB".

### `swapfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free swap memory, in mebibytes.

### `swapsize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total swap memory, such as "1 GiB".

### `swapsize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total swap memory, in mebibytes.

### `windows_edition_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the type of Windows edition, Server or Desktop Edition variant.

### `windows_installation_type`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows installation type (Server|Server Core|Client).

### `windows_product_name`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows textual product name.

### `windows_release_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows Build Version of the form YYMM.

### `system32`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to the System32 directory on Windows.

### `uptime`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system uptime.

### `uptime_days`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime days.

### `uptime_hours`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime hours.

### `uptime_seconds`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime seconds.

### `uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product unique identifier.

### `xendomains`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a list of comma-separated active Xen domain names.

### `zone_<name>_brand`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the brand for the Solaris zone.

### `zone_<name>_iptype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IP type for the Solaris zone.

### `zone_<name>_name`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name for the Solaris zone.

### `zone_<name>_uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the unique identifier for the Solaris zone.

### `zone_<name>_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone identifier for the Solaris zone.

### `zone_<name>_path`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone path for the Solaris zone.

### `zone_<name>_status`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone state for the Solaris zone.

### `zonename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the current Solaris zone.

### `zones`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of Solaris zones.

# Custom facts overview

### Sections

[Adding custom facts to Facter ](https://www.puppet.com/docs/puppet/7/custom_facts.html#adding_custom_facts)

- [Structured and flat facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#structured-and-flat-facts)

[Loading custom facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#loading_custom_facts)

- [Using the Ruby load path](https://www.puppet.com/docs/puppet/7/custom_facts.html#using-ruby-load-path)
- [Using the `--custom-dir` command line option](https://www.puppet.com/docs/puppet/7/custom_facts.html#using-custom-dir-command-line-option)
- [Using the `FACTERLIB` environment variable](https://www.puppet.com/docs/puppet/7/custom_facts.html#using-facterlib-environment-variable)

[Two parts of every fact](https://www.puppet.com/docs/puppet/7/custom_facts.html#two_parts_of_every_fact)

[Executing shell commands in facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#executing_shell_commands_in_facts)

- [Example ](https://www.puppet.com/docs/puppet/7/custom_facts.html#executing-shell-commands-facts-example)

[Using other facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#using_other_facts)

[Configuring facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#configuring_facts)

- [Confining facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#confining-facts)
- [Fact precedence](https://www.puppet.com/docs/puppet/7/custom_facts.html#fact-precedence)
- [Execution timeouts](https://www.puppet.com/docs/puppet/7/custom_facts.html#execution-timeouts)

[Structured facts](https://www.puppet.com/docs/puppet/7/custom_facts.html#structured_facts)

[Aggregate resolutions](https://www.puppet.com/docs/puppet/7/custom_facts.html#aggregate_resolutions)

[Viewing fact values](https://www.puppet.com/docs/puppet/7/custom_facts.html#viewing_fact_values)

[Environment facts ](https://www.puppet.com/docs/puppet/7/custom_facts.html#environment_facts)

Expand

You can add custom facts by writing snippets of Ruby        code on the primary Puppet server. Puppet then uses plug-ins in modules to distribute the        facts to the client.

For information on how to add custom facts to modules, see [Module plug-in types](https://www.puppet.com/docs/puppet/7/plugins_in_modules.html#plugins_in_modules).        

**Related information**

- [External facts](https://www.puppet.com/docs/puppet/7/external_facts.html#external_facts)
- [Plug-ins in modules](https://www.puppet.com/docs/puppet/7/plugins_in_modules.html#plugins_in_modules)

## Adding custom facts to Facter

Sometimes you need to be able to write conditional        expressions based on site-specific data that just isn’t available via Facter, or perhaps you’d like to include it in a        template.

Because you can’t include arbitrary Ruby code in your manifests, the best solution is to add a new fact to Facter. These additional facts can then be distributed to                Puppet clients and are available for use in manifests            and templates, just like any other fact is.

Note: Facter 4 implements the same [custom facts API](https://github.com/puppetlabs/facter/blob/master/Extensibility.md#Extensibility) as Facter 3. Any custom fact that requires one of the Ruby                files previously stored in `lib/facter/util` fails                with an error.

### Structured and flat facts

A typical fact extracts a piece of information about a system and returns it as                either as a simple value (“flat” fact) or data organized as a hash or array                (“structured” fact). There are several types of facts classified by how they collect                information, including:

- Core facts, which are built into Facter and                        are common to almost all systems.
- Custom facts, which run Ruby code to produce a                        value.
- External facts, which return values from pre-defined static data, or the                        result of an executable script or program.

All fact types can produce flat or structured values.

**Related information**

- [Facter release notes](https://www.puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter)
- [External facts](https://www.puppet.com/docs/puppet/7/external_facts.html#external_facts)

## Loading custom facts

Facter offers multiple      methods of loading facts.

These include:

- `$LOAD\_PATH`, or the Ruby library load                  path.
- The `--custom-dir` command line option.
- The environment variable `FACTERLIB`.

You can use these methods to do things like test files locally before         distributing them, or you can arrange to have a specific set of facts available on certain         machines. 

### Using the Ruby load path

Facter searches all directories in the Ruby`$LOAD_PATH` variable for subdirectories               named Facter, and loads all Ruby files in those directories. If you had a directory in               your `$LOAD_PATH` like `~/lib/ruby`, set up like this:            

```
#~/lib/ruby
└── facter
    ├── rackspace.rb
    ├── system_load.rb
    └── users.rbCopied!
```

Facter loads `facter/system_load.rb`, `facter/users.rb`, and `facter/rackspace.rb`.

### Using the `--custom-dir` command line option

Facter can take multiple `--custom-dir` options on the command line that specifies a single            directory to search for custom facts. Facter attempts to            load all Ruby files in the specified directories. This            allows you to do something like this:            

```
$ ls my_facts
system_load.rb
$ ls my_other_facts
users.rb
$ facter --custom-dir=./my_facts --custom-dir=./my_other_facts system_load users
system_load => 0.25
users => thomas,patCopied!
```

### Using the `FACTERLIB` environment variable

Facter also checks the environment variable `FACTERLIB` for a delimited (semicolon for Windows and colon for all other platforms) set of            directories, and tries to load all Ruby files in those            directories. This allows you to do something like            this:

```
$ ls my_facts
system_load.rb
$ ls my_other_facts
users.rb
$ export FACTERLIB="./my_facts:./my_other_facts"
$ facter system_load users
system_load => 0.25
users => thomas,patCopied!
```

Note: Facter 4 replaces `facter               -p` with `puppet facts show`. The `puppet facts show` command is the default action for Puppet facts. Facter also            accepts `puppet facts`.

## Two parts of every fact

Most facts have at least two elements. 

1. A call to `Facter.add('fact_name')`, which determines the name of                        the fact.
2. A `setcode` statement for simple resolutions, which is evaluated to                        determine the fact’s value.

Facts can get a lot more complicated than that, but those two together            are the most common implementation of a custom fact.

## Executing shell commands in facts

​      Puppet gets information about a system from Facter, and the most common way for Facter to get that information is by executing shell      commands.

You can then parse and manipulate the output from those commands using standard Ruby code. The Facter API         gives you a few ways to execute shell commands: 

- To run a command and use the output verbatim, as your fact’s value, you can pass                  the command into `setcode` directly. For example:                     `setcode 'uname --hardware-platform'`               
- If your fact is more complicated than that, you can call `Facter::Core::Execution.execute('uname --hardware-platform')` from                  within the `setcode do ... end` block. Whatever the                     `setcode` statement returns is used as the fact’s                  value. 
- Your shell command is also a Ruby string, so you                  need to escape special characters if you want to pass them through. 

Note: Not everything that works in the terminal works in a fact. You can use            the pipe (`|`) and similar operators as you normally            would, but Bash-specific syntax like `if` statements do            not work. The best way to handle this limitation is to write your conditional logic in               Ruby.

### Example 

To get the output of `uname --hardware-platform` to single            out a specific type of workstation, you create a custom fact. 

1. Start by giving the fact a name, in this case, `hardware_platform`. 

2. Create the fact in a file called `hardware_platform.rb` on the primary Puppet                     server:

   ```
   # hardware_platform.rb
   
   Facter.add('hardware_platform') do
     setcode do
       Facter::Core::Execution.execute('/bin/uname --hardware-platform')
     end
   endCopied!
   ```

3. Use the instructions in the [Plug-ins in modules docs](https://www.puppet.com/docs/puppet/7/plugins_in_modules.html#plugins_in_modules) to copy the new fact to a module and                     distribute it. During your next Puppet run, the                     value of the new fact is available to use in your manifests and templates. 

## Using other facts

You can write a fact that uses other facts by accessing `Facter.value('somefact')`. If the fact fails to resolve or is not present, Facter returns `nil`.

For example: 

```
Facter.add('osfamily') do
  setcode do
    distid = Facter.value('lsbdistid')
    case distid
    when /RedHatEnterprise|CentOS|Fedora/
      'redhat'
    when 'ubuntu'
      'debian'
    else
      distid
    end
  end
endCopied!
```

Note: Facter does not support case-sensitive facts. Queries are always downcased in calls to        `Facter.value` or `Facter.fact`, for example,        `Facter.value('OS')` and `Facter.value('os')` return the same      value. Facter also downcases custom or external facts with uppercase or mixed-case      names.

## Configuring facts

Facts have properties that you can use to customize how they    are evaluated.

### Confining facts

One of the more commonly used properties is the `confine`        statement, which restricts the fact to run only on systems that match another given        fact.

For example: 

```
Facter.add('powerstates') do
  confine kernel: 'Linux'
  setcode do
    Facter::Core::Execution.execute('cat /sys/power/states')
  end
endCopied!
```

This fact uses `sysfs` on Linux to get a list of the power states that are available on        the given system. Because this is available only on Linux        systems, we use the `confine` statement to ensure that this        fact isn’t needlessly run on systems that don’t support this type of enumeration.

To confine structured facts like `['os']['family']`, you can use          `Facter.value`: You can also use a Ruby        block: 

```
confine 'os' do |os|
  os['family'] == 'RedHat'
endCopied!
```

### Fact precedence

A single fact can have multiple *resolutions*, each of which is a different way of        determining the value of the fact. It’s common to have different resolutions for different        operating systems, for example. To add a new resolution to a fact, you add the fact again        with a different `setcode` statement.

When a fact has more than one resolution, the first resolution that returns a value other        than `nil` sets the fact’s value. The way that Facter decides the issue of resolution precedence is the weight        property. After Facter rules out any resolutions that are        excluded because of `confine` statements, the resolution with        the highest weight is evaluated first. If that resolution returns `nil`, Facter moves on to the next resolution (by        descending weight) until it gets a value for the fact.

By default, the weight of a resolution is the number of `confine` statements it has, so that more specific resolutions take priority over        less specific resolutions. External facts have a weight of 1000 — to override them, set a        weight above 1000.        

```
# Check to see if this server has been marked as a postgres server
Facter.add('role') do
  has_weight 100
  setcode do
    if File.exist? '/etc/postgres_server'
      'postgres_server'
    end
  end
end

# Guess if this is a server by the presence of the pg_create binary
Facter.add('role') do
  has_weight 50
  setcode do
    if File.exist? '/usr/sbin/pg_create'
      'postgres_server'
    end
  end
end

# If this server doesn't look like a server, it must be a desktop
Facter.add('role') do
  setcode do
    'desktop'
  end
endCopied!
```

### Execution timeouts

Facter 4 supports timeouts on resolutions. If the timeout is        exceeded, Facter prints an error message.

```
Facter.add('foo', {timeout: 0.2}) do
 setcode do
   Facter::Core::Execution.execute("sleep 1")
 end
EndCopied!
```

You can also pass a timeout to `Facter::Core::Execution#execute`:.

```
Facter.add('sleep') do
  setcode do
    begin
      Facter::Core::Execution.execute('sleep 10', options = {:timeout => 5})
      'did not timeout!'
    rescue Facter::Core::Execution::ExecutionFailure
      Facter.warn("Sleep fact timed out!")
    end
  end
end
Copied!
```

When Facter runs as standalone, using          `Facter.warn` ensures that the message is printed to          `STDERR`. When Facter is called as part of a        catalog application, using `Facter.warn` prints the message to Puppet’s log. If an exception is not caught, Facter automatically logs it as an error.

## Structured facts

Structured facts take the form of either a hash or an        array.

To create a structured fact, return a hash or an array from                the `setcode` statement.

You can see some relevant examples in the Writing structured facts section of            the Custom facts overview. 

Facter 4 introduced a new way to aggregate facts using dot            notation. For more information, see [Writing aggregate             resolutions](https://www.puppet.com/docs/puppet/7/fact_overview.html#writing_facts_aggregate_resolutions).

**Related information**

- [Writing custom facts](https://www.puppet.com/docs/puppet/7/fact_overview.html#fact_overview)

## Aggregate resolutions

If your fact combines the output of multiple commands, use        aggregate resolutions. An aggregate resolution is split into chunks, each one responsible        for resolving one piece of the fact. After all of the chunks have been resolved separately,        they’re combined into a single flat or structured fact and returned.

Aggregate resolutions have several key differences compared to simple resolutions,            beginning with the fact declaration. To introduce an aggregate resolution, add the                `:type => :aggregate`            parameter:

```
Facter.add('fact_name', :type => :aggregate) do
    #chunks go here
    #aggregate block goes here
endCopied!
```

Each step in the resolution then gets its own named `chunk` statement:            

```
chunk('one') do
    'Chunk one returns this. '
end

chunk('two') do
    'Chunk two returns this.'
endCopied!
```

Aggregate resolutions never have a `setcode` statement. Instead, they have an optional `aggregate` block that combines the chunks. Whatever value the `aggregate` block returns is the fact’s value. Here’s an            example that just combines the strings from the two chunks above:            

```
aggregate do |chunks|
  result = ''

  chunks.each_value do |str|
    result += str
  end

  # Result: "Chunk one returns this. Chunk two returns this."
  result
endCopied!
```

 If the `chunk` blocks all return arrays or            hashes, you can omit the `aggregate` block. If you do, Facter merges all of your data into one array or hash and            uses that as the fact’s value.

For more examples of aggregate resolutions, see the Aggregate            resolutions section of the Custom facts overview page.

**Related information**

- [Writing custom facts](https://www.puppet.com/docs/puppet/7/fact_overview.html#fact_overview)

## Viewing fact values

If your Puppet primary servers are        configured to use PuppetDB, you can view and        search all of the facts for any node, including custom facts.

See [the PuppetDB                 docs](https://puppet.com/docs/puppetdb/latest) for more info.

## Environment facts 

Environment facts allow you to override core facts and add custom facts.

To access a fact set with environment variables, you can use the CLI or the Ruby API                (`Facter.value` or `Facter.fact` methods). Use the            environment variable prefixed with `FACTER_`, for example:

```
$ facter virtual
physical
$ FACTER_virtual=virtualbox facter virtual 
virtualboxCopied!
```

Note that environment facts are downcased before they are added to the fact collection,            for example, `FACTER_EXAMPLE` and `FACTER_example` resolve            to a single fact named `example`.

# Writing custom facts

### Sections

[Writing facts with simple resolutions](https://www.puppet.com/docs/puppet/7/fact_overview.html#writing_facts_simple_resolutions)

- [Main components of simple resolutions](https://www.puppet.com/docs/puppet/7/fact_overview.html#main-components-simple-resolutions)
- [How to format facts](https://www.puppet.com/docs/puppet/7/fact_overview.html#how-to-format-facts)
- [Examples](https://www.puppet.com/docs/puppet/7/fact_overview.html#examples)

[Writing structured facts](https://www.puppet.com/docs/puppet/7/fact_overview.html#writing_structured_facts)

- [Example: Returning an array of network interfaces](https://www.puppet.com/docs/puppet/7/fact_overview.html#example-returning-array-network-interfaces)
- [Example: Returning a hash of network interfaces to IP addresses](https://www.puppet.com/docs/puppet/7/fact_overview.html#example-returning-hash-network-interfaces-to-ip-addresses)

[Writing facts with aggregate resolutions](https://www.puppet.com/docs/puppet/7/fact_overview.html#writing_facts_aggregate_resolutions)

- [Main components of aggregate resolutions](https://www.puppet.com/docs/puppet/7/fact_overview.html#main-components-aggregate-resolutions)
- [Example: Building a structured fact progressively](https://www.puppet.com/docs/puppet/7/fact_overview.html#building-structured-fact-progressively)
- [Example: Building a flat fact progressively with addition](https://www.puppet.com/docs/puppet/7/fact_overview.html#building-flat-fact-progressively-with-addition)

Expand

A typical fact in Facter is an collection of several        elements, and is written either as a simple value (“flat” fact) or as structured data        (“structured” fact). This page shows you how to write and format facts        correctly.

Important: You must be able to distinguish **facts** from **resolutions**.            A fact is a piece of information about a given node, while a resolution is a way of            determining the value of an applicable fact. The following is a structure of a            fact:

```
Facter.add(:my_custom_fact) do
   <resolution>
end
 Copied!
```

A single fact can have multiple resolutions. A resolution details how, when            and in which order to obtain the value for a fact. It is common to have different            resolutions for different operating systems. To add a new resolution to a fact, you add            the fact again but with a different `setcode` statement.

You need some familiarity with Ruby to understand most of            these examples. For an introduction, see out the [Custom                 facts overview](https://www.puppet.com/docs/puppet/7/custom_facts.html#custom_facts). For information on how to add custom facts to modules, see                [Module plug-in types](https://www.puppet.com/docs/puppet/7/plugins_in_modules.html#plugins_in_modules). 

## Writing facts with simple resolutions

Most facts are resolved all at the same time, without any    need to merge data from different sources. In that case, the resolution is simple. Both flat and    structured facts can have simple resolutions.

### Main components of simple resolutions

Simple facts are typically made up of the following parts: 

1. A call to `Facter.add(:fact_name)`:

   - This introduces a new fact *or* a new resolution for an existing fact with                the same name.
   - The name can be either a symbol or a string.
   - The rest of the fact is wrapped in the `add` call’s                    `do ... end` block.

2. Zero or more `confine` statements:

   - Determine whether the resolution is suitable (and therefore is evaluated).
   - Can either match against the value of another fact or evaluate a Ruby block.
   - If given a symbol or string representing a fact name, a block is required and the                  block receives the fact’s value as an argument.
   - If given a hash, the keys are expected to be fact names. The values of the hash                  are either the expected fact values or an array of values to compare against.
   - If given a block, the confine is suitable if the block returns a value other than                    `nil` or `false`.

3. An optional `has_weight` statement:

   - When multiple resolutions are available for a fact, resolutions are evaluated                  from highest weight value to lowest.
   - Must be an integer greater than 0.
   - Defaults to the number of `confine` statements for                  the resolution.

4. A `setcode` statement that determines the value of the              fact:

   - Can take either a string or a block.
   - If given a string, Facter executes it as a shell                  command. If the command succeeds, the output of the command is the value of the                  fact. If the command fails, the next suitable resolution is evaluated.
   - If given a block, the block’s return value is the value of the fact unless the                  block returns `nil`. If `nil` is returned, the next suitable resolution is evaluated.
   - Can execute shell commands within a `setcode`                  block, using the `Facter::Core::Execution.exec`                  function.
   - If multiple `setcode` statements are evaluated for                  a single resolution, only the last `setcode` block                  is used.

   Note: Set all code inside the sections outlined above ⁠— there must not be any code                outside `setcode`and `confine` blocks other than an                optional `has_weight` statement in a custom fact.

### How to format facts

The format of a fact is important because of the way that Facter evaluates them — by        reading *all* the fact definitions. If formatted incorrectly, Facter can execute code        too early. You need to use the `setcode` correctly. Below is a *good*        example and a *bad* example of a fact, showing you where to place the          `setcode`.

Good:

```
Facter.add('phi') do
  confine owner: "BTO"
  confine :kernel do |value|
    value == "Linux"
  end
 
  setcode do
    bar=Facter.value('theta')
    bar + 1
  end
endCopied!
```

In this example, the `bar=Facter.value('theta')` call is guarded by          `setcode`, which means it is not executed unless or until it is appropriate        to do so. Facter loads all `Facter.add` blocks first, use any OS or        confine/weight information to decide which facts to evaluate, and once it chooses, it        selectively executes `setcode` blocks for each fact that it needs.

Bad:

```
Facter.add('phi') do
  confine owner: "BTO"
  confine :kernel do |value|
    value == "Linux"
  end
  
  bar = Facter.value('theta')
 
  setcode do
    bar + 1
  end
endCopied!
```

In this example, the `Facter.value('theta')` call is outside of the guarded          `setcode` block and in the unguarded part of the          `Facter.add` block. This means that the statement always executes, on every        system, regardless of confine, weight, or which resolution of `phi` is        appropriate. Any code with possible side-effects, or code pertaining to figuring out the        value of a fact, must be kept inside the `setcode` block. The        only code left outside `setcode` is code that helps Facter choose which        resolution of a fact to use.

### Examples

The following example shows a minimal fact that relies on a single shell command:

```
Facter.add(:rubypath) do
  setcode 'which ruby'
endCopied!
```

The following example shows different resolutions for different operating systems:

```
Facter.add(:rubypath) do
  setcode 'which ruby'
end

Facter.add(:rubypath) do
  confine osfamily: "Windows"
  # Windows uses 'where' instead of 'which'
  setcode 'where ruby'
endCopied!
```

The following example shows a more complex fact, confined to Linux with a        block:

```
Facter.add(:jruby_installed) do
  confine :kernel do |value|
    value == "Linux"
  end

  setcode do
    # If jruby is present, return true. Otherwise, return false.
    Facter::Core::Execution.which('jruby') != nil
  end
end
Copied!
```

## Writing structured facts

Structured facts can take the form of hashes or arrays. 

You don’t have to do anything special to mark the fact as structured — if your fact returns a      hash or array, Facter recognizes it as a structured fact.      Structured facts can have simple or aggregate resolutions. 

### Example: Returning an array of network interfaces

```
Facter.add(:interfaces_array) do
  setcode do
   interfaces = Facter.value(:interfaces)
   # the 'interfaces' fact returns a single comma-delimited string, such as "lo0,eth0,eth1"
   # this splits the value into an array of interface names
   interfaces.split(',')
  end
endCopied!
```

### Example: Returning a hash of network interfaces to IP addresses

```
Facter.add(:interfaces_hash) do
  setcode do
    interfaces_hash = {}

    Facter.value(:interfaces_array).each do |interface|
      ipaddress = Facter.value("ipaddress_#{interface}")
      if ipaddress
        interfaces_hash[interface] = ipaddress
      end
    end

    interfaces_hash
  end
endCopied!
```

## Writing facts with aggregate resolutions

Aggregate resolutions allow you to split up the resolution    of a fact into separate chunks.

By default, Facter merges hashes with      hashes or arrays with arrays, resulting in a structured fact, but you can also aggregate      the chunks into a flat fact using concatenation, addition, or any other function that you can      express in Ruby code.

### Main components of aggregate resolutions

Aggregate resolutions have two key differences compared to simple resolutions: the presence          of `chunk` statements and the lack of          a `setcode` statement. The `aggregate` block is optional, and without it Facter merges hashes with hashes or arrays with arrays.

1. A call to `Facter.add(:fact_name, :type =>                :aggregate)`:
   - Introduces a new fact or a new resolution for an existing fact with the                  same name.
   - The name can be either a symbol or a string.
   - The `:type => :aggregate` parameter is                  required for aggregate resolutions.
   - The rest of the fact is wrapped in the `add` call’s `do ...                  end` block.
2. Zero or more `confine` statements:
   - Determine whether the resolution is suitable and (therefore is evaluated).
   - They can either match against the value of another fact or evaluate a Ruby block.
   - If given a symbol or string representing a fact name, a block is required and the                  block receives the fact’s value as an argument.
   - If given a hash, the keys are expected to be fact names. The values of the hash                  are either the expected fact values or an array of values to compare against.
   - If given a block, the confine is suitable if the block returns a value other                    than `nil` or `false`.
3. An optional `has_weight` statement:
   - Evaluates multiple resolutions for a fact from highest weight value to                  lowest.
   - Must be an integer greater than 0.
   - Defaults to the number of `confine` statements for the resolution.
4. One or more calls to `chunk`, each containing:
   - A name (as the argument to `chunk`).
   - A block of code, which is responsible for resolving the chunk to a value. The                  block’s return value is the value of the chunk; it can be any type, but is                  typically a hash or array.
5. An optional `aggregate` block:
   - If absent, Facter automatically merges hashes with                  hashes or arrays with arrays.
   - To merge the chunks in any other way, you need to make a call to `aggregate`, which takes a block of code.
   - The block is passed one argument (`chunks`, in                  the example), which is a hash of chunk name to chunk value for all the chunks in                  the resolution.

### Example: Building a structured fact progressively

This example builds a new fact, `networking_primary_sha`, by progressively merging two chunks. One chunk encodes        each networking interface’s MAC address as an encoded base64 value, and the other determines        if each interface is the system’s primary interface.        

```
require 'digest'
require 'base64'

Facter.add(:networking_primary_sha, :type => :aggregate) do

  chunk(:sha256) do
    interfaces = {}

    Facter.value(:networking)['interfaces'].each do |interface, values|
      if values['mac']
        hash = Digest::SHA256.digest(values['mac'])
        encoded = Base64.encode64(hash)
        interfaces[interface] = {:mac_sha256 => encoded.strip}
      end
    end

    interfaces
  end

  chunk(:primary?) do
    interfaces = {}

    Facter.value(:networking)['interfaces'].each do |interface, values|
      interfaces[interface] = {:primary? => (interface == Facter.value(:networking)['primary'])}
    end

    interfaces
  end
  # Facter merges the return values for the two chunks
  # automatically, so there's no aggregate statement.
endCopied!
```

The fact’s output is organized by network interface into hashes, each        containing the two chunks:

```
{
  bridge0 => {
    mac_sha256 => "bfgEFV7m1V04HYU6UqzoNoVmnPIEKWRSUOU650j0Wkk=",
    primary?   => false
  },
  en0 => {
    mac_sha256 => "6Fd3Ws2z+aIl8vNmClCbzxiO2TddyFBChMlIU+QB28c=",
    primary?   => true
  },
  ...
}Copied!
```

### Example: Building a flat fact progressively with addition

```
Facter.add(:total_free_memory_mb, :type => :aggregate) do
  chunk(:physical_memory) do
    Facter.value(:memoryfree_mb)
  end

  chunk(:virtual_memory) do
    Facter.value(:swapfree_mb)
  end

  aggregate do |chunks|
    # The return value for this block determines the value of the fact.
    sum = 0
    chunks.each_value do |i|
      sum += i
    end

    sum
  end
endCopied!
```

**Related information**

- [Facter 4 known issues](https://www.puppet.com/docs/puppet/7/facter-known-issues.html)

# External facts

### Sections

[Executable facts on Unix       ](https://www.puppet.com/docs/puppet/7/external_facts.html#executable-facts-unix)

[Executable facts on Windows       ](https://www.puppet.com/docs/puppet/7/external_facts.html#executable-facts-windows)

[ Executable fact locations](https://www.puppet.com/docs/puppet/7/external_facts.html#executable-fact-locations)

[Structured data facts ](https://www.puppet.com/docs/puppet/7/external_facts.html#structured-data-facts)

[Structured data facts on Windows       ](https://www.puppet.com/docs/puppet/7/external_facts.html#structured-data-facts-windows)

[Troubleshooting](https://www.puppet.com/docs/puppet/7/external_facts.html#external-facts-troubleshooting)

[Drawbacks](https://www.puppet.com/docs/puppet/7/external_facts.html#drawbacks)

External facts provide a way to use arbitrary executables or    scripts as facts, or set facts statically with structured data. With this information, you can    write a custom fact in Perl, C, or a one-line text file.

## Executable facts on Unix      

Executable facts on Unix work by dropping an executable file        into the standard external fact path. A shebang (`#!`) is        always required for executable facts on Unix. If the shebang        is missing, the execution of the fact fails.

An example external fact written in Python:        

```
#!/usr/bin/env python
data = {"key1" : "value1", "key2" : "value2" }

for k in data:
    print "%s=%s" % (k,data[k])Copied!
```

You must ensure that the script has its execute        bit        set:

```
chmod +x /etc/facter/facts.d/my_fact_script.pyCopied!
```

For Facter to parse the output, the script should return        key-value pairs, JSON, or YAML.

Custom executable external facts can return data in YAML or JSON format, and Facter parses it into a structured fact. If the returned value        is not YAML, Facter falls back to parsing it as a key-value        pair.

By using the key-value pairs on STDOUT format, a single script can return multiple        facts:

```
key1=value1
key2=value2
key3=value3Copied!
```

## Executable facts on Windows      

Executable facts on Windows work by dropping an executable        file into the external fact path. The external facts interface expects Windows scripts to end with a known extension. Line endings can        be either `LF` or `CRLF`. The        following extensions are supported: 

- ​              `.com` and `.exe`: binary              executables 
- ​              `.bat` and `.cmd`: batch              scripts 
- ​              `.ps1`: PowerShell              scripts 

The script should return key-value pairs, JSON, or YAML.

Custom executable external facts can return data in YAML or JSON format, and Facter parses it into a structured fact. If the returned value        is not YAML, Facter falls back to parsing it as a key-value        pair.

By using the key-value pairs on STDOUT format, a single script can return multiple        facts:

```
key1=value1
key2=value2
key3=value3Copied!
```

Using this format, a single script can return multiple facts in one        return.

For batch scripts, the file encoding for the `.bat` or          `.cmd` files must be ANSI or UTF8 without BOM.

Here is a sample batch script which outputs facts using the required        format:

```
@echo off
echo key1=val1
echo key2=val2
echo key3=val3
REM Invalid - echo 'key4=val4'
REM Invalid - echo "key5=val5"Copied!
```

For PowerShell scripts, the encoding used with `.ps1` files is flexible. PowerShell        determines the encoding of the file at run time.

Here is a sample PowerShell script which outputs facts using        the required format:

```
Write-Host "key1=val1"
Write-Host 'key2=val2'
Write-Host key3=val3Copied!
```

Save and execute this PowerShell script on the command line.

##  Executable fact locations

Distribute external executable facts with pluginsync. To add external executable facts to        your Puppet modules, place them in `<MODULEPATH>/<MODULE>/facts.d/`.

If you’re not using pluginsync, then external facts must go in a standard directory. The        location of this directory varies depending on your operating system, whether your        deployment uses Puppet Enterprise or open source releases, and whether        you are running as root or Administrator. When calling Facter        from the command line, you can specify the external facts directory with the `--external-dir` option. 

Note: These directories don’t necessarily exist by default; you might need to          create them. If you create the directory, make sure to restrict access so that only          administrators can write to the directory.

In a module (recommended):        

```
<MODULEPATH>/<MODULE>/facts.d/Copied!
```

On Unix, Linux, or Mac OS X, there are three directories:        

```
/opt/puppetlabs/facter/facts.d/
/etc/puppetlabs/facter/facts.d/
/etc/facter/facts.d/Copied!
```

On Windows:        

```
C:\ProgramData\PuppetLabs\facter\facts.d\Copied!
```

When running        as a non-root or non-Administrator user: 

```
<HOME DIRECTORY>/.facter/facts.d/Copied!
```

Note: You can use custom facts as a non-root user only if you have first [configured non-root user access](https://puppet.com/docs/pe/latest/installing/installing_agents.html#installing_agents) and previously run Puppet agent as that same user.

## Structured data facts 

​        Facter can parse structured data files stored in the external        facts directory and set facts based on their contents.

Structured data files must use one of the supported data types and must have the correct        file extension. Facter supports the following extensions and        data types:

- `.yaml`: YAML data, in the following format:

  ```
  ---
  key1: val1
  key2: val2
  key3: val3Copied!
  ```

- `.json`: JSON data, in the following              format:

  ```
  { "key1": "val1", "key2": "val2", "key3": "val3" }Copied!
  ```

- `.txt`: Key-value pairs, of the `String` data type, in              the following format:

  ```
  key1=value1
  key2=value2
  key3=value3 Copied!
  ```

As with executable facts, structured data files can set multiple facts at one        time.

```
{
  "datacenter":
  {
    "location": "bfs",
    "workload": "Web Development Pipeline",
    "contact": "Blackbird"
  },
  "provision":
  {
    "birth": "2017-01-01 14:23:34",
    "user": "alex"
  }
}Copied!
```

You can also compose multiple external facts in a structured fact using the `dot` notation. For example:

```
my_org.my_group.my_fact1 = fact1_value
my_org.my_group.my_fact2 = fact2_valueCopied!
```

## Structured data facts on Windows      

All of the above types are supported on Windows with the        following notes:

- The line endings can be either `LF` or `CRLF`.
- The file encoding must be either ANSI or UTF8 without BOM.

## Troubleshooting

If your external fact is not appearing in Facter’s output,        running Facter in debug mode can reveal why and tell you        which file is causing the problem:        

```
# puppet facts --debugCopied!
```

One        possible cause is a fact that returns invalid characters. For example if you used a hyphen        instead of an equals sign in your script `test.sh`:        

```
#!/bin/bash

echo "key1-value1"Copied!
```

Running `puppet facts --debug`        yields the following message:

```
...
Debug: Facter: resolving facts from executable file "/tmp/test.sh".
Debug: Facter: executing command: /tmp/test.sh
Debug: Facter: key1-value1
Debug: Facter: ignoring line in output: key1-value1
Debug: Facter: process exited with status code 0.
Debug: Facter: completed resolving facts from executable file "/tmp/test.sh".
...Copied!
```

If you find that an external fact does not match what you have configured in your `facts.d` directory, make sure you have not defined the same fact        using the external facts capabilities found in the `stdlib`        module.

## Drawbacks

While external facts provide a mostly-equal way to create variables for Puppet, they have a few drawbacks: 

- An external fact cannot internally reference another fact. However, due to parse              order, you can reference an external fact from a Ruby              fact.
- External executable facts are forked instead of executed within the same process.

**Related information**

- [Custom facts overview](https://www.puppet.com/docs/puppet/7/custom_facts.html#custom_facts)

# Configuring Facter with      facter.conf

### Sections

[Location](https://www.puppet.com/docs/puppet/7/configuring_facter.html#facter-conf-location)

[             `facts`          ](https://www.puppet.com/docs/puppet/7/configuring_facter.html#facter-conf-facts)

[             `global`          ](https://www.puppet.com/docs/puppet/7/configuring_facter.html#facter-conf-global)

[             `cli`          ](https://www.puppet.com/docs/puppet/7/configuring_facter.html#facter-conf-cli)

[`fact-groups`](https://www.puppet.com/docs/puppet/7/configuring_facter.html#facter-conf-fact-groups)

The `facter.conf` file is a configuration file      that allows you to cache and block fact groups and facts, and manage how Facter interacts with your system. There are four sections:         `facts`, `global`, `cli` and `fact-groups`. All sections      are optional and can be listed in any order within the file.

When you run Facter from the Ruby API, only the `facts` section and limited `global` settings are loaded.

Example `facter.conf`         file:

```
facts : {
    blocklist : [ "file system", "EC2", "os.architecture" ],
    ttls : [
        { "timezone" : 30 days },
    ]
}
global : {
    external-dir     : [ "path1", "path2" ],
    custom-dir       : [ "custom/path" ],
    no-exernal-facts : false,
    no-custom-facts  : false,
    no-ruby          : false
}
cli : {
    debug     : false,
    trace     : true,
    verbose   : false,
    log-level : "warn"
}
fact-groups : {
 custom-group-name : ["os.name", "ssh"],
}Copied!
```

Note: The `facter.conf` file is in `hocon` format. Use `//` or `#` for comments.         

## Location

Facter does not create the `facter.conf` file automatically, so you must create it manually, or use            a module to manage it. Facter loads the file by default               from `/etc/puppetlabs/facter/facter.conf `on               *nix systems and `C:\ProgramData\PuppetLabs\facter\etc\facter.conf` on Windows. Or you can specify a different default with               the `--config` command line option:            

```
facter --config path/to/my/config/file/facter.confCopied!
```

##             `facts`         

This section of `facter.conf` contains settings that            affect fact groups. A fact group contains one or more individual facts. When you block            or cache a fact group, all the facts from that group are affected. You can cache any            type of fact, including custom and external.

The settings in this section are: 

- `blocklist` — Prevents all facts within the listed                  groups from being resolved when Facter runs. Use                     the `--list-block-group` command line                  option to list valid groups.
- `ttls` — Caches the key-value pairs of groups                  and their duration to be cached. Use the `--list-cache-group` command line option to list valid groups.
  - Cached facts are stored as JSON in `/opt/puppetlabs/facter/cache/cached_facts` on *nix and `C:\ProgramData\PuppetLabs\facter\cache\cached_facts` on Windows.

Caching and blocking facts is useful when Facter is            taking a long time and slowing down your code. When a system has a lot of something —            for example, mount points or disks — Facter can take a            long time to collect the facts from each one. When this is a problem, you can speed up               Facter’s collection by either blocking facts you’re            uninterested in (`blocklist`), or caching ones you don’t            need retrieved frequently (`ttls`).

To see a list of valid group names, from the command line, run `facter --list-block-groups` or `facter --list-cache-groups`. The output shows the fact group            at the top level, with all facts in that group nested            below:

```
$ facter --list-block-groups
EC2
  - ec2_metadata
  - ec2_userdata
file system
  - mountpoints
  - filesystems
  - partitionsCopied!
```

If you want to block any of these groups, add the group name            to the `facts` section of `facter.conf`, with the `blocklist` setting:

```
facts : {
    blocklist : [ "file system" ],
}Copied!
```

Here, the `file system` group has been            added, so the `mountpoints`, `filesystems`, and `partitions` facts are now prevented from loading.

You can also specify fact names with the `blocklist` and               `ttls` settings. For example:

```
facts : {
   blocklist : [ “my_external_fact.txt”, “my_executable_fact.sh” ],
}Copied!
ttls : [
   { "timezone" : 30 days },
   { "networking.hostname" : 6 hours },
]Copied!
```

##             `global`         

The `global` section of `facter.conf` contains settings to control how Facter interacts with its external elements on your            system. 

| Setting        | Effect                                                       | Default |
| -------------- | ------------------------------------------------------------ | ------- |
| `external-dir` | A list of directories to search for external facts.          |         |
| `custom-dir`   | A list of directories to search for custom facts.            |         |
| `no-external`* | If `true`, prevents Facter from searching for external facts. | `false` |
| `no-custom`*   | If `true`, prevents Facter from searching for custom facts.  | `false` |
| `no-ruby`*     | If `true`, prevents Facter from loading its Ruby functionality. | `false` |

 *Not available when you run Facter from the Ruby API.

##             `cli`         

The `cli` section of `facter.conf` contains settings that affect Facter’s command line output. All of these settings are            ignored when you run Facter from the Ruby API. 

| Setting     | Effect                                                       | Default  |
| ----------- | ------------------------------------------------------------ | -------- |
| `debug`     | If `true`, Facter outputs debug messages.                    | `false`  |
| `trace`     | If `true`, Facter prints stacktraces from errors                           arising in your custom facts. | `false`  |
| `verbose`   | If `true`, Facter outputs its most detailed messages.        | `false`  |
| `log-level` | Sets the minimum level of message severity that gets logged. Valid                           options: `"none"`, `"fatal"`, `"error"`, `"warn"`, `"info"`, `"debug"`, `"trace"`. | `"warn"` |

## `fact-groups`

The `fact-groups` group lets you define your own custom groups in               `facter.conf`. A group can contain any type of fact, except external            facts. For aggregated facts, you can specify the root fact using the dot notation. You            can use these defined groups for blocking (`blocklist`) or            caching (`ttls`).

```
fact-groups : {
 custom-group-name : ["networking.hostname", "ssh"],
}
```