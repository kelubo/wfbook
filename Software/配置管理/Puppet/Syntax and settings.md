# Syntax and settings

When using Puppet, refer to Puppet syntax and references, including configuration        settings, functions, and metaparameters. 

**[The Puppet language](https://www.puppet.com/docs/puppet/7/puppet_language.html)**
You'll use Puppet's declarative language to describe         the desired state of your system.  **[Metaparameter reference](https://www.puppet.com/docs/puppet/7/metaparameter.html)**
Metaparameters are attributes that work with any resource type, including custom         types and defined types. They change the way Puppet handles         resources. **[Configuration Reference](https://www.puppet.com/docs/puppet/7/configuration.html)**
  **[Built-in function reference](https://www.puppet.com/docs/puppet/7/function.html)**
  **[Puppet Man Pages](https://www.puppet.com/docs/puppet/7/man/overview.html)**

# The Puppet language

You'll use Puppet's declarative language to describe        the desired state of your system. 

You'll  describe the desired state of your system in files called manifests. Manifests            describe how your network and operating system resources, such as files, packages, and            services, should be configured. Puppet then compiles            those manifests into catalogs, and applies each catalog to its corresponding node to            ensure the node is configured correctly, across your infrastructure.

Several parts of the Puppet language depend on evaluation            order. For example, variables must be set before they are referenced. Throughout the            language reference, we call out areas where the order of statements matters.

If you are new to Puppet, start with the Puppet language overview. 

- **[Puppet language overview](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#intro_puppet_language_and_code)**
  The following overview covers some of the key components of the Puppet  language,         including catalogs, resources, classes and manifests. 
- **[Puppet language syntax examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_visual_index)**
  A quick reference of syntax examples for the Puppet         language. 
- **[The Puppet language style guide](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide)**
  This style guide promotes consistent formatting in the Puppet language, giving you a common pattern, design, and         style to  follow when developing modules. This consistency in code and module  structure makes         it easier to update and maintain the code.
- **[Files and paths on Windows](https://www.puppet.com/docs/puppet/7/lang_windows_file_paths.html#lang_windows_file_paths)**
           Puppet and Windows handle         directory separators and line endings in files somewhat  differently, so you must be aware of         the differences when you  are writing manifests to manage Windows systems.
- **[Code comments](https://www.puppet.com/docs/puppet/7/lang_comments.html)**
  To add comments to your Puppet code, use shell-style or hash comments. 
- **[Variables](https://www.puppet.com/docs/puppet/7/lang_variables.html#lang_variables)**
  Variables store values so that those values can be accessed     in code later.
- **[Resources](https://www.puppet.com/docs/puppet/7/lang_resources.html#lang_resources)**
  Resources are the fundamental unit for modeling system configurations. Each  resource     describes the desired state for some aspect of a system,  like a specific service or package.     When Puppet applies a catalog to the target system, it manages     every resource  in the catalog, ensuring the actual state matches the desired state.
- **[Resource types](https://www.puppet.com/docs/puppet/7/resource_types.html)**
  Every resource (file, user, service, package, and so on)         is associated with a resource type within the Puppet         language. The resource type defines the kind of configuration  it manages. This section         provides information about the resource types that are built into Puppet. 
- **[Relationships and ordering](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships)**
   Resources are included and applied in the order they are defined in  their manifest,       but only if the resource has no implicit  relationship with another resource, as this can       affect the  declared order. To manage a group of resources in a specific order,  explicitly       declare such relationships with relationship  metaparameters, chaining arrows, and the `require` function.
- **[Classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes)**
  Classes are                                 named blocks of Puppet code that are                                 stored in modules and  applied later when they are invoked by name.                                 You can add classes to a node’s catalog by either declaring them in                                 your manifests or assigning them from  an external node classifier                                 (ENC).  Classes generally configure large or medium-sized chunks of                                 functionality, such as all of the packages,  configuration files, and                                 services needed to run an application. 
- **[Defined resource types](https://www.puppet.com/docs/puppet/7/lang_defined_types.html)**
  Defined resource types,     sometimes called defined types or defines, are blocks of Puppet     code that can be evaluated multiple times with different parameters.
- **[Bolt tasks](https://www.puppet.com/docs/puppet/7/bolt_tasks.html)**
  Bolt tasks are single         actions that you can run on target nodes in  your infrastructure, allowing you to make         as-needed changes to  remote systems. You can run tasks with the Puppet Enterprise (PE) orchestrator or with Puppet’s standalone task runner, Bolt. 
- **[Expressions and operators](https://www.puppet.com/docs/puppet/7/lang_expressions.html#lang_expressions)**
  Expressions are statements   that resolve to values. You can use expressions almost anywhere a value is required. Expressions   can be compounded with  other expressions, and the entire combined expression resolves to a  single   value.
- **[Conditional statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional)**
  Conditional statements let your Puppet code behave     differently in different situations. They are most  helpful when combined with facts or with data     retrieved from an  external source. Puppet supports       if and unless statements, case statements, and       selectors. 
- **[Function calls](https://www.puppet.com/docs/puppet/7/lang_functions.html#lang_functions)**
  Functions are plug-ins, written in Ruby, that you can call during catalog compilation. A call to         any  function is an expression that resolves to a value. Most functions  accept one or more         values as arguments, and return a resulting  value.
- **[Built-in function reference](https://www.puppet.com/docs/puppet/7/function.html)**
- **[Node definitions](https://www.puppet.com/docs/puppet/7/lang_node_definitions.html)**
  A node definition, also known as a node statement, is a         block of Puppet code that is included only in matching nodes'         catalogs. This  allows you to assign specific configurations to specific nodes.
- **[Facts and built-in variables](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html)**
  Before requesting a catalog for a managed node, or         compiling one with `puppet apply`, Puppet collects system information, called facts, by using the Facter tool. The         facts are assigned as values to variables that you can use anywhere in your manifests. Puppet also sets some additional special variables, called             built-in variables, which behave a lot like facts. 
- **[Reserved words and acceptable names](https://www.puppet.com/docs/puppet/7/lang_reserved.html#lang_reserved)**
  You can use only certain characters for naming variables,         modules,  classes, defined types, and other custom constructs. Additionally, some  words in         the Puppet language are reserved and cannot be used as bare         word strings or names.
- **[Custom resources](https://www.puppet.com/docs/puppet/7/custom_resources.html)**
  A *resource* is the basic unit that is managed by Puppet. Each resource has a set of attributes describing its         state.  Some attributes can be changed throughout the lifetime of the resource,  whereas         others are only reported back but cannot be changed, and some can only be set one time         during initial creation. 
- **[Custom functions](https://www.puppet.com/docs/puppet/7/writing_custom_functions.html)**
  Use the Puppet language, or         the Ruby API to create custom functions.
- **[Values, data types, and aliases](https://www.puppet.com/docs/puppet/7/lang_data.html)**
  Most of the things you can do with the Puppet language         involve some form of data. An individual piece of data is called         a *value*, and every value has a *data type*, which determines         what kind of information that value can contain and how you can interact with         it.
- **[Templates](https://www.puppet.com/docs/puppet/7/lang_template.html)**
  Templates are written in a specialized templating       language that generates  text from data. Use templates to manage the content of your Puppet configuration files via the `content` attribute of the `file` resource type. 
- **[Advanced constructs](https://www.puppet.com/docs/puppet/7/lang_constructs.html)**
  Advanced Puppet language constructs help you write simpler         and more effective Puppet code by reducing complexity.
- **[Details of complex behaviors](https://www.puppet.com/docs/puppet/7/lang_complex_behaviors.html)**
  Within Puppet language there are complex behavior patterns         regarding  classes, defined types, and specific areas of code called scopes. 
- **[Securing sensitive data in Puppet](https://www.puppet.com/docs/puppet/7/securing-sensitive-data.html)**
  Puppet’s catalog contains sensitive information in         clear text. Puppet uses the `Sensitive` data type to mark your sensitive data — for example secrets,          passwords and private keys — with a flag that hides the value from  certain parts of Puppet, such as reports.  However, you can still see this         information in plain text files  in the cached catalog and other administrative         functions.

**Related information**

- [Puppet language overview](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#intro_puppet_language_and_code)
- [Puppet language syntax examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_visual_index)
- [The Puppet language style guide](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide)

# Puppet language overview

### Sections

[Catalogs](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#intro_catalogs)

[Resources and classes](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#lang_resources_classes)

[Manifests](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#lang_manifests)

- [Manifest example](https://www.puppet.com/docs/puppet/7/intro_puppet_language_and_code.html#manifest-example)

The following overview covers some of the key components of the Puppet language,        including catalogs, resources, classes and manifests. 

The following video gives you an overview of the Puppet language:

​                            

## Catalogs

To configure nodes, the primary Puppet server        compiles configuration information into a catalog, which describes the desired state of        a specific agent node. Each agent requests and receives its own individual        catalog.

The catalog describes the desired state for every resource managed on            a single given node. Whereas a manifest can contain conditional logic to describe            specific resource configuration for multiple nodes, a catalog is a static document that            describes all of the resources and and dependencies for only one node. 

To create a catalog for a given agent, the primary server compiles:

- Data from the agent, such as facts or certificates.
- External data, such as values from functions or classification information                        from the PE console.
- Manifests, which can contain conditional logic to describe the desired state                        of resources for many nodes.

The primary server resolves all of these elements and compiles a specific catalog for            each individual agent. After the agent receives its catalog, it applies any changes            needed to bring the agent to the state described in the catalog.

Tip: When you run the `puppet apply` command on a node, it                compiles the catalog locally and applies it immediately on the node where you ran                the command.

Agents cache their most recent catalog. If they request a catalog and the primary server            fails to compile one, they fall back to their cached catalog. For detailed information            on the catalog compilation process, see the [catalog                 compilation system](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#subsystem_catalog_compilation) page. 

## Resources and classes

A resource describes some aspect of a system, such as a        specific service or package. You can group resources together in classes, which generally        configure larger chunks of functionality, such as all of the packages, configuration files,        and services needed to run an application.

The Puppet language is structured            around resource declaration. When you declare a resource, you tell Puppet the desired state for that resource, so that Puppet can add it to the catalog and manage it. Every            other part of the Puppet language exists to add            flexibility and convenience to the way you declare resources.

Just as you declare a single resource, you can declare a class to            manage many resources at once. Whereas a resource declaration might manage the state of            a single file or package, a class declaration can manage everything needed to configure            an entire service or application, including packages, configuration files, service            daemons, and maintenance tasks. In turn, small classes that manage a few resources can            be combined into larger classes that describe entire custom system roles, such as            "database server" or "web application worker."

To add a class's resources to the catalog, either declare the class in            a manifest or classify your nodes. Node classification allows you to assign a different            set of classes to each node, based on the node's role in your infrastructure. You can            classify nodes with node definitions or by using node-specific data from outside your            manifests, such as that from an [external node classifier](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers) or [Hiera](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_intro).

The following video gives you an overview of resources:

​                            

The following video gives you an overview of classes:

​                                    

## Manifests

Resources are declared in manifests, Puppet language    files that describe how the resources must be configured. Manifests are a basic building block    of Puppet and are kept in a specific file structure called a    module. You can write your own manifests and modules or download them from Puppet or other Puppet users. 

Manifests can contain conditional logic and declare resources for multiple      agents. The primary server evaluates the contents of all the relevant manifests, resolves any logic,      and compiles catalogs. Each catalog defines state for one specific node.

Manifests:

- Are text files with a `.pp` extension.
- Must use UTF-8 encoding.
- Can use Unix            (LF) or Windows (CRLF) line breaks.

When compiling the catalog, the primary server always evaluates the main manifest first. This      manifest, also known as the site manifest, defines global system configurations, such as LDAP      configuration, DNS servers, or other configurations that apply to every node. The main      manifest can be either a single manifest, usually named `site.pp`, or a directory containing several manifests, which Puppet treats as a single file. For more details about the main      manifest, see the [main manifest](https://www.puppet.com/docs/puppet/7/dirs_manifest.html) page.

The simplest Puppet deployment consists of      a single main manifest file with a few resources. As you're ready, you can add complexity      progressively, by grouping resources into modules and classifying your nodes more granularly. 

### Manifest example

This short manifest manages NTP. It includes:

- A case statement that sets the name of the NTP service, depending on which operating              system is installed on the agent.
- A `package` resource that installs the NTP package on              the agent.
- A `service` resource that enables and runs the NTP              service. This resource also applies the NTP configuration settings from `ntp.conf` to the service.
- A `file` resource that creates the `ntp.conf` file on the agent in `/etc/ntp.conf`. This resource also requires that the `ntp` package is installed on the agent. The contents of the `ntp.conf` file will be taken from the specified source file,              which is contained in the `ntp` module.

```
case $operatingsystem {
  centos, redhat: { $service_name = 'ntpd' }
  debian, ubuntu: { $service_name = 'ntp' }
}

package { 'ntp':
  ensure => installed,
}

service { 'ntp':
  name      => $service_name,
  ensure    => running,
  enable    => true,
  subscribe => File['ntp.conf'],
}

file { 'ntp.conf':
  path    => '/etc/ntp.conf',
  ensure  => file,
  require => Package['ntp'],
  source  => "puppet:///modules/ntp/ntp.conf",
  # This source file would be located on the primary Puppet server at
  # /etc/puppetlabs/code/modules/ntp/files/ntp.conf
}
```

# Puppet language syntax        examples

### Sections

[Resource examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_resource)

- [Resource declaration](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#resource-declaration)
- [Resource relationship metaparameters](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#resource-relationship-metaparameters)
- [Resource relationship chaining arrows](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#resource-relationship-chaining-arrows)
- [Exported resource declaration](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#exported-resource-declaration)
- [Resource collector](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#resource-collector)
- [Exported resource collector](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#exported-resource-collector)
- [Resource default for the `exec` type](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#resource-default-exec-type)
- [Virtual resource](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#virtual-resource)

[Defined resource type examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_drt)

- [Defined resource type definition](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#defined-resource-type-definition)
- [Defined type resource declaration](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#defined-type-resource-declaration)
- [Defined type resource reference](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#defined-type-resource-reference)

[Class examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_class)

- [Class definition](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#class-definition)
- [Class declaration](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#class-declaration)

[Variable examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_variables)

- [Variable assigned an array value](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#variable-assigned-array-value)
- [Variable assigned a hash value](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#variable-assigned-hash-value)
- [Interpolated variable](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#interpolated-variable)

[Conditional statement examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_conditionals)

- [                 `if` statement, using expressions and facts](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#if-using-expressions-and-facts)
- [                 `if` statement, with `in`                 expression](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#if-with-in-expression)
- [Case statement](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#case-statement)
- [Selector statement](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#selector-statement)

[Node examples](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#lang_examples_node)

- [Node definition](https://www.puppet.com/docs/puppet/7/lang_visual_index.html#node-definition)

Expand

A quick reference of syntax examples for the Puppet        language. 

## Resource examples



### Resource declaration

This example resource declaration includes: 

- ​                            `file`: The resource type.                        
- ​                            `ntp.conf`: The resource                                title. 
- ​                            `path`: An attribute. 
- ​                            `'/etc/ntp.conf'`: The value of an                            attribute; in this case, a string. 
- ​                            `template('ntp/ntp.conf')`: A                                function call that returns a value; in this case, the                                `template` function, with the name of a template in a                                module as its argument. 

```
file { 'ntp.conf':
  path    => '/etc/ntp.conf',
  ensure  => file,
  content => template('ntp/ntp.conf'),
  owner   => 'root',
  mode    => '0644',
}Copied!
```

For details about resources and resource declaration syntax, see [Resources](https://www.puppet.com/docs/puppet/7/lang_resources.html#lang_resources).

### Resource relationship metaparameters

Two resource declarations establishing relationships with the `before` and `subscribe`                 metaparameters, which accept resource references. 

The first declaration ensures that the `ntp` package is installed                before the `ntp.conf` file is created. The second declaration ensures                that the `ntpd` service is notified of any changes to the                    `ntp.conf` file.                

```
package { 'ntp':
  ensure => installed,
  before => File['ntp.conf'],
}
service { 'ntpd':
  ensure    => running,
  subscribe => File['ntp.conf'],
}Copied!
```

For details about relationships usage and syntax, see [Relationships and ordering](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships). For details about resource references, see                    [Resource and class references](https://www.puppet.com/docs/puppet/7/lang_data_resource_reference.html). 

### Resource relationship chaining arrows

Chaining arrows forming relationships between three resources, using resource                references.In this example, the `ntp` package must be installed                before the `ntp.conf` file is created; after the file is created, the                    `ntpd` service is notified.

```
Package['ntp'] -> File['ntp.conf'] ~> Service['ntpd']Copied!
```

For details about relationships usage and syntax, see [Relationships and ordering](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships). For details about resource references, see                    [Resource and class references](https://www.puppet.com/docs/puppet/7/lang_data_resource_reference.html). 

### Exported resource declaration

An exported resource declaration.                

```
@@nagios_service { "check_zfs${hostname}":
  use                 => 'generic-service',
  host_name           => "$fqdn",
  check_command       => 'check_nrpe_1arg!check_zfs',
  service_description => "check_zfs${hostname}",
  target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  notify              => Service[$nagios::params::nagios_service],
}Copied!
```

For information about declaring and collecting exported resources, see [Exported resources](https://www.puppet.com/docs/puppet/7/lang_exported.html). 

### Resource collector

A resource collector, sometimes called the "spaceship operator."                Resource collectors select a group of resources by searching the attributes of each                resource in the catalog.                

```
User <| groups == 'admin' |>Copied!
```

For details about resource collector usage and syntax, see [Resource collectors](https://www.puppet.com/docs/puppet/7/lang_collectors.html). 

### Exported resource collector

An exported resource collector, which works with exported resources,                which are available for use by other nodes.                

```
Concat::Fragment <<| tag == "bacula-storage-dir-${bacula_director}" |>>Copied!
```

For details about resource collector usage and syntax, see [Resource collectors](https://www.puppet.com/docs/puppet/7/lang_collectors.html). For                information about declaring and collecting exported resources, see [Exported resources](https://www.puppet.com/docs/puppet/7/lang_exported.html). 

### Resource default for the `exec` type

A resource default statement set default attribute values for a given resource type.                This example specifies defaults for the `exec`                resource type attributes `path`, `environment`,                    `logoutput`, and `timeout`.                

```
Exec {
  path        => '/usr/bin:/bin:/usr/sbin:/sbin',
  environment => 'RUBYLIB=/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.1.0/',
  logoutput   => true,
  timeout     => 180,
}Copied!
```

For details about default statement usage and syntax, see [Resource defaults](https://www.puppet.com/docs/puppet/7/lang_defaults.html). 

### Virtual resource

A virtual resource, which is declared in the catalog but isn't applied                to a system unless it is explicitly realized.                

```
@user { 'deploy':
  uid     => 2004,
  comment => 'Deployment User',
  group   => www-data,
  groups  => ["enterprise"],
  tag     => [deploy, web],
}Copied!
```

For details about virtual resource usage and syntax, see [Virtual resources](https://www.puppet.com/docs/puppet/7/lang_virtual.html). 

## Defined resource type examples



### Defined resource type definition

Defining a type creates a new defined resource type. The name of this defined                    type has two namespace segments, comprising the name of the module                containing the defined type, `apache`, and the name of the defined                type itself, `vhost`. 

```
define apache::vhost ($port, $docroot, $servername = $title, $vhost_name = '*') {
  include apache
  include apache::params
  $vhost_dir = $apache::params::vhost_dir
  file { "${vhost_dir}/${servername}.conf":
    content => template('apache/vhost-default.conf.erb'),
    owner   => 'www',
    group   => 'www',
    mode    => '644',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
Copied!
```

For details about defined type usage and syntax, see [Defined resource types](https://www.puppet.com/docs/puppet/7/lang_defined_types.html). 

### Defined type resource declaration

Declarations of an instance, or resource, of a defined type are similar to other                resource declarations. This example declares a instance of the                    `apache::vhost` defined type, with a title of "homepages" and the                    `port` and `docroot` attributes specified.

```
apache::vhost { 'homepages':
  port       => 8081,
  docroot => '/var/www-testhost',
} Copied!
```

For details about defined type usage and syntax, see [Defined resource types](https://www.puppet.com/docs/puppet/7/lang_defined_types.html). 

### Defined type resource reference

A resource reference to an instance of the `apache::vhost` defined                resource. Every namespace segment in a resource reference must be capitalized.

```
Apache::Vhost['homepages']Copied!
```

For details about defined type usage and syntax, see [Defined resource types](https://www.puppet.com/docs/puppet/7/lang_defined_types.html). For details about resource references, see                    [Resource and class references](https://www.puppet.com/docs/puppet/7/lang_data_resource_reference.html). 

## Class examples



### Class definition

A class definition, which makes a class available for later use.

```
class ntp {
  package {'ntp':
    ...
  }
  ...
}Copied!
```

For details about class usage and syntax, see [Classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes). 

### Class declaration

Declaring the `ntp` class in three different ways: 

- the `include` function 
- the `require` function 
- the resource-like syntax

Declaring a class causes the resources in it to be managed. 

The ` include` function is the standard way to declare classes:                

```
include ntpCopied!
```

The `require` function declares the class and makes it a dependency of                the code container where it is declared: 

```
require ntpCopied!
```

The resource-like syntax declares the class and applies resource-like behavior.                Resource-like class declarations require that you declare a given class only one                time. 

```
class {'ntp':}Copied!
```

For details about class usage and syntax, see [Classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes). 

## Variable examples



### Variable assigned an array value

A variable being assigned a set of values as an array. 

```
$package_list = ['ntp', 'apache2', 'vim-nox', 'wget']Copied!
```

For details about assigning values to variables, see [Variables](https://www.puppet.com/docs/puppet/7/lang_variables.html#lang_variables). 

### Variable assigned a hash value

A variable being assigned a set of values as a hash.

```
$myhash = { key => { subkey => 'b' } }Copied!
```

For details about assigning values to variables, see [Variables](https://www.puppet.com/docs/puppet/7/lang_variables.html#lang_variables). 

### Interpolated variable

A built-in variable provided by the primary server being interpolated into a                double-quoted string.

```
...
content => "Managed by puppet server version ${serverversion}"Copied!
```

For details about built-in variables usage and syntax, see [Facts and built-in variables](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html). For information about strings and                interpolation, see [Strings](https://www.puppet.com/docs/puppet/7/lang_data_string.html#lang_data_string). 

## Conditional statement examples



###                 `if` statement, using expressions and facts

An `if` statement, whose conditions are expressions that use facts                provided by the agent.                

```
if $is_virtual {
  warning( 'Tried to include class ntp on virtual machine; this node might be misclassified.' )
}
elsif $operatingsystem == 'Darwin' {
  warning( 'This NTP module does not yet work on our Mac laptops.' )
else {
  include ntp
}Copied!
```

For details about `if` statements, see [Conditional statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional). 

###                 `if` statement, with `in`                expression

An `if` statement using an `in` expression.                

```
if 'www' in $hostname {
  ...
}Copied!
```

For details about `if` statements, see [Conditional statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional). 

### Case statement

A case statement.                

```
case $operatingsystem {
  'RedHat', 'CentOS': { include role::redhat  }
  /^(Debian|Ubuntu)$/:{ include role::debian  }
  default:            { include role::generic }
}Copied!
```

For details about case statements, see [Conditional statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional). 

### Selector statement

A selector statement being used to set the value of the `$rootgroup`                variable. 

```
$rootgroup = $osfamily ? {
    'RedHat'          => 'wheel',
    /(Debian|Ubuntu)/ => 'wheel',
    default            => 'root',
}Copied!
```

For details about selector statements, see [Conditional statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional). 

## Node examples



### Node definition

A node definition or node statement is a block of Puppet code that is included only in matching nodes’ catalogs. This allows you to assign                specific configurations to specific nodes.

```
node 'www1.example.com' {
  include common
  include apache
  include squid
}Copied!
```

Node names in node definitions can also be given as regular expressions.

```
node /^www\d+$/ {
  include common
}Copied!
```

For details about node definition usage and syntax, see [Node definitions](https://www.puppet.com/docs/puppet/7/lang_node_definitions.html). 

​                          [                 Docs                 ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)               ](https://puppet.com/docs)                     [             Open Source Puppet             ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)           ](https://puppet.com/docs/puppet)                [           Syntax and settings                        ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                    ](https://www.puppet.com/docs/puppet/7/language-and-concepts.html)                    [                 The Puppet language                                    ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                                ](https://www.puppet.com/docs/puppet/7/puppet_language.html)                          [                 The Puppet language style guide                                ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide)            

# The Puppet language style guide 

### Sections

[Module design practices ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_module_design)

- [Spacing, indentation, and whitespace](https://www.puppet.com/docs/puppet/7/style_guide.html#spacing)
- [Arrays and hashes](https://www.puppet.com/docs/puppet/7/style_guide.html#arrays-hashes)
- [Quoting](https://www.puppet.com/docs/puppet/7/style_guide.html#quoting)
- [Escape characters](https://www.puppet.com/docs/puppet/7/style_guide.html#escape-chars)
- [Comments](https://www.puppet.com/docs/puppet/7/style_guide.html#comments)
- [Functions](https://www.puppet.com/docs/puppet/7/style_guide.html#functions)
- [Improving readability when chaining functions](https://www.puppet.com/docs/puppet/7/style_guide.html#improve-readability)

[Resources ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_resources)

- [Resource names](https://www.puppet.com/docs/puppet/7/style_guide.html#resource-names)
- [Arrow alignment](https://www.puppet.com/docs/puppet/7/style_guide.html#arrow-alignment)
- [Attribute ordering](https://www.puppet.com/docs/puppet/7/style_guide.html#attribute-ordering)
- [Resource arrangement](https://www.puppet.com/docs/puppet/7/style_guide.html#resource-arrangement)
- [Symbolic links](https://www.puppet.com/docs/puppet/7/style_guide.html#symbolic-links)
- [File modes](https://www.puppet.com/docs/puppet/7/style_guide.html#file-modes)
- [Multiple resources](https://www.puppet.com/docs/puppet/7/style_guide.html#multiple-resources)
- [Legacy style defaults](https://www.puppet.com/docs/puppet/7/style_guide.html#legacy-style-defaults)
- [Attribute alignment](https://www.puppet.com/docs/puppet/7/style_guide.html#attribute-alignment)
- [Defined resource types](https://www.puppet.com/docs/puppet/7/style_guide.html#defined-resource-types)

[Classes and defined types ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_classes)

- [Separate files](https://www.puppet.com/docs/puppet/7/style_guide.html#separate-files)
- [Internal organization of classes and defined types](https://www.puppet.com/docs/puppet/7/style_guide.html#internal-organization-classes-defined-types)
- [Public and private](https://www.puppet.com/docs/puppet/7/style_guide.html#public-private)
- [Chaining arrow syntax](https://www.puppet.com/docs/puppet/7/style_guide.html#chaining-arrow-syntax)
- [Nested classes or defined types](https://www.puppet.com/docs/puppet/7/style_guide.html#nested-classes-defined-types)
- [Display order of parameters](https://www.puppet.com/docs/puppet/7/style_guide.html#params-display-order)
- [Parameter defaults](https://www.puppet.com/docs/puppet/7/style_guide.html#param-defaults)
- [Exported resources](https://www.puppet.com/docs/puppet/7/style_guide.html#exported-resources)
- [Parameter indentation and alignment](https://www.puppet.com/docs/puppet/7/style_guide.html#param-indentation-alignment)
- [Class inheritance](https://www.puppet.com/docs/puppet/7/style_guide.html#class-inheritance)
- [Public modules](https://www.puppet.com/docs/puppet/7/style_guide.html#public-modules)
- [Type signatures ](https://www.puppet.com/docs/puppet/7/style_guide.html#type-signatures)

[Variables ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_variables)

- [Referencing facts](https://www.puppet.com/docs/puppet/7/style_guide.html#referencing-facts)
- [Namespacing variables](https://www.puppet.com/docs/puppet/7/style_guide.html#namespacing-variables)
- [Variable format](https://www.puppet.com/docs/puppet/7/style_guide.html#variable-format)

[Conditionals ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_conditionals)

- [Simple resource declarations](https://www.puppet.com/docs/puppet/7/style_guide.html#simple-resource-declarations)
- [Defaults for case statements and selectors](https://www.puppet.com/docs/puppet/7/style_guide.html#case-selector-defaults)
- [Conditional statement alignment ](https://www.puppet.com/docs/puppet/7/style_guide.html#conditional-statement-alignment)

[Modules ](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_modules)

- [Versioning](https://www.puppet.com/docs/puppet/7/style_guide.html#versioning)
- [Module metadata](https://www.puppet.com/docs/puppet/7/style_guide.html#module-metadata)
- [Dependencies](https://www.puppet.com/docs/puppet/7/style_guide.html#dependencies)
- [README](https://www.puppet.com/docs/puppet/7/style_guide.html#readme)
- [Documenting Puppet code](https://www.puppet.com/docs/puppet/7/style_guide.html#documenting-code)
- [CHANGELOG](https://www.puppet.com/docs/puppet/7/style_guide.html#changelog)
- [Examples](https://www.puppet.com/docs/puppet/7/style_guide.html#examples)
- [Testing](https://www.puppet.com/docs/puppet/7/style_guide.html#testing)

Expand

This style guide promotes consistent formatting in the Puppet language, giving you a common pattern, design, and        style to follow when developing modules. This consistency in code and module structure makes        it easier to update and maintain the code.

This style guide applies to Puppet 4            and later. Puppet 3 is no longer supported, but we            include some Puppet 3 guidelines in case you're            maintaining older code.

Tip: Use [puppet-lint](http://puppet-lint.com/) and [metadata-json-lint](https://github.com/voxpupuli/metadata-json-lint) to check your module for compliance with the style                guide.

No style guide can cover every circumstance you might run into when            developing Puppet code. When you need to make a judgement            call, keep in mind a few general principles.

- Readability matters

  If you have to choose between two equal alternatives,                        pick the more readable one. This is subjective, but if you can read your own                        code three months from now, it's a great start. In particular, code that                        generates readable diffs is highly preferred.

- Scoping and simplicity are key

  When in doubt, err on the side of simplicity. A module                        should contain related resources that enable it to accomplish a task. If you                        describe the function of your module and you find yourself using the word                        "and," consider splitting the module. Have one goal, with all your classes                        and parameters focused on achieving it.

- Your module is a piece of software

  At least, we recommend that you treat it that way. When                        it comes to making decisions, choose the option that is easier to maintain                        in the long term.

These guidelines apply to Puppet code,            for example, code in Puppet modules or classes. To reduce            repetitive phrasing, we don't include the word 'Puppet'            in every description, but you can assume it.

For information about the specific meaning of terms like 'must,' 'must            not,' 'required,' 'should,' 'should not,' 'recommend,' 'may,' and 'optional,' see [RFC 2119](http://www.faqs.org/rfcs/rfc2119.html).

## Module design practices 

Consistent module design practices makes module    contributions easier. 

### Spacing, indentation, and whitespace

Module manifests should follow best practices for spacing, indentation, and whitespace.

Manifests:

- Must use two-space soft tabs.

- Must not use literal tab characters.

- Must not contain trailing whitespace.

- Must include trailing commas after all resource attributes and parameter          definitions.

- Must end the last line with a new line.

- Must use one space between the resource type and opening brace, one space between the          opening brace and the title, and no spaces between the title and            colon.

  Good:

  ```
  file { '/tmp/sample':Copied!
  ```

  Bad:            Space between title and            colon:

  ```
  file { '/tmp/sample' :Copied!
  ```

  Bad:            No            spaces:

  ```
  file{'/tmp/sample':Copied!
  ```

  Bad:            Too many            spaces:

  ```
  file     { '/tmp/sample':Copied!
  ```

- Should not exceed a 140-character line width, except where such a limit would be              impractical.
- Should leave one empty line between resources, except when using dependency              chains.
- May align hash rockets (`=>`) within blocks of              attributes, one space after the longest resource key, arranging hashes for maximum              readability first. 

### Arrays and hashes

To increase readability of arrays and hashes, it is almost always beneficial to break up        the elements on separate lines.

Use a single line only if that results in overall better readability of the construct where        it appears, such as when it is very short. When breaking arrays and hashes, they should        have: 

- Each element on its own line.
- Each new element line indented one level.
- First and last lines used only for the syntax of that data type.

Good: Array with multiple elements on multiple        lines:

```
service { 'sshd':
  require => [
    Package['openssh-server'],
    File['/etc/ssh/sshd_config'],
  ],
}Copied!
```

Good: Hash with multiple elements on multiple        lines:

```
$myhash = {
  key       => 'some value',
  other_key => 'some other value',
}Copied!
```

Bad: Array with multiple elements on same        line:

```
service { 'sshd':
  require => [ Package['openssh-server'], File['/etc/ssh/sshd_config'], ],
}Copied!
```

Bad: Hash with multiple elements on same        line:

```
$myhash = { key => 'some value', other_key => 'some other value', }Copied!
```

Bad:        Array with multiple elements on different lines, but syntax and element share a        line:

```
service { 'sshd':
  require => [ Package['openssh-server'],
    File['/etc/ssh/sshd_config'],
  ],
}Copied!
```

Bad: Hash with multiple elements on different lines, but syntax and element        share a        line:

```
$myhash = { key => 'some value',
  other_key     => 'some other value',
}Copied!
```

Bad: Array with an indention of elements past two        spaces: 

```
service { 'sshd':
  require => [
              Package['openssh-server'],
              File['/etc/ssh/sshd_config'],
  ],
}Copied!
```

### Quoting

As long you are consistent, strings may be enclosed in single or double quotes, depending        on your preference.

Regardless of your preferred quoting style, all variables MUST be enclosed in braces when        interpolated in a string.

For example: 

Good: 

```
"/etc/${file}.conf"Copied!
"${facts['operatingsystem']} is not supported by ${module_name}"Copied!
```

Bad:

```
"/etc/$file.conf"Copied!
```



**Option 1: Prefer single quotes**

Modules that adopt this string quoting style MUST enclose all strings in single quotes,        except as listed below.

For example: 

Good:        

```
owner => 'root'Copied!
```

Bad:

```
owner => "root"Copied!
```

A string MUST be enclosed in double quotes if it: 

- Contains variable interpolations.

  - Good:

    ```
    "/etc/${file}.conf"Copied!
    ```

  - Bad: 

    ```
    '/etc/${file}.conf'Copied!
    ```

- Contains escaped characters not supported by single-quoted strings.

  - Good:

    ```
    content => "nameserver 8.8.8.8\n"Copied!
    ```

  - Bad:

    ```
    content => 'nameserver 8.8.8.8\n'Copied!
    ```

A string SHOULD be enclosed in double quotes if it:

- Contains single quotes.

  - Good:

    ```
    warning("Class['apache'] parameter purge_vdir is deprecated in favor of purge_configs")Copied!
    ```

  - Bad:                

    ```
    warning('Class[\'apache\'] parameter purge_vdir is deprecated in favor of purge_configs')Copied!
    ```



**Option 2: Prefer double quotes**

Modules that adopt this string quoting style MUST enclose all strings in double quotes,        except as listed below.

For example:

Good:

```
owner => "root"Copied!
```

Bad: 

```
owner => 'root'Copied!
```

A string SHOULD be enclosed in single quotes if it does not contain variable interpolations        AND it:

- Contains double quotes.

  - Good:                

    ```
    warning('Class["apache"] parameter purge_vdir is deprecated in favor of purge_configs')Copied!
    ```

  - Bad:                

    ```
    warning("Class[\"apache\"] parameter purge_vdir is deprecated in favor of purge_configs") Copied!
    ```

- Contains literal backslash characters that are not intended to be part of an escape            sequence.

  - Good:                

    ```
    path => 'c:\windows\system32'Copied!
    ```

  - Bad:                

    ```
    path => "c:\\windows\\system32"Copied!
    ```

If a string is a value from an enumerable set of options, such as `present` and `absent`, it SHOULD NOT be enclosed in        quotes at all.

For example:

Good:        

```
ensure => presentCopied!
```

Bad:

```
ensure => "present"Copied!
```

### Escape characters

Use backslash (`\`) as an escape character.

For both single- and double-quoted strings, escape the backslash to remove this special          meaning: `\\` This means that for every backslash        you want to include in the resulting string, use two backslashes. As an example, to include        two literal backslashes in the string, you would use four backslashes in total.

Do not rely on unrecognized escaped characters as a method for including the backslash and        the character following it.

Unicode character escapes using fewer than 4 hex digits, as in `\u040`, results in a backslash followed by the string `u040`. (This also causes a warning for the unrecognized escape.) To use a number        of hex digits not equal to 4, use the longer `u{digits}` format.

### Comments

Comments must be hash comments (`# This is a comment`).        Comments should explain the why, not the how, of your code.

Do not use `/* */` comments in Puppet code.

Good:  

```
# Configures NTP
file { '/etc/ntp.conf': ... }Copied!
```

Bad:

```
/* Creates file /etc/ntp.conf */
file { '/etc/ntp.conf': ... }Copied!
```

Note: Include documentation comments for Puppet          Strings for each of your classes, defined types, functions, and resource types and          providers. If used, documentation comments precede the name of the element. For          documentation recommendations, see the Modules section of this guide.

### Functions

Avoid the `inline_template()` and `inline_epp()` functions for templates of more than one line,        because these functions don’t permit template validation. Instead, use the `template()` and `epp()` functions to read a template from the module. This method allows for        syntax validation.

You should avoid using calls to Hiera functions in modules meant for public consumption,        because not all users have implemented Hiera. Instead, we recommend using parameters that        can be overridden with Hiera.

### Improving readability when chaining functions

In most cases, especially if blocks are short, we recommend keeping functions on the same        line. If you have a particularly long chain of operations or block that you find difficult        to read, you can break it up on multiples lines to improve readability. As long as your        formatting is consistent throughout the chain, it is up to your own judgment. 

For example, this:        

```
$foodgroups.fruit.vegetablesCopied!
```

Is        better than this:

```
   $foodgroups
           .fruit
           .vegetablesCopied!
```

But, this:        

```
$foods = {
 "avocado"    => "fruit",
 "eggplant"   => "vegetable",
 "strawberry" => "fruit",
 "raspberry"  => "fruit",
}
 
$berries = $foods.filter |$name, $kind| {
 # Choose only fruits
 $kind == "fruit"
}.map |$name, $kind| {
 # Return array of capitalized fruits
 String($name, "%c")
}.filter |$fruit| {
 # Only keep fruits named "berry"
 $fruit =~ /berry$/
}Copied!
```

Is better than this:        

```
$foods = {
 "avocado"    => "fruit",
 "eggplant"   => "vegetable",
 "strawberry" => "fruit",
 "raspberry"  => "fruit",
}
 
$berries = $foods.filter |$name, $kind| { $kind == "fruit" }.map |$name, $kind| { String($name, "%c") }.filter |$fruit| { $fruit =~ /berry$/ }Copied!
```

**Related information**

- [Modules](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_modules)

## Resources 

Resources are the fundamental unit for modeling system    configurations. Resource declarations have a lot of possible features, so your code's    readability is crucial.

### Resource names

All resource names or titles must be quoted. If you are using an array of titles you must        quote each title in the array, but cannot quote the array itself.

 Good: 

```
package { 'openssh': ensure => present }Copied!
```

 Bad: 

```
package { openssh: ensure => present }Copied!
```

These quoting requirements do not apply to expressions that evaluate to strings.

### Arrow alignment

To align hash rockets (`=>`) in a resource's attribute/value list or in a        nested block, place the hash rocket one space ahead of the longest attribute name. Indent        the nested block by two spaces, and place each attribute on a separate line. Declare very        short or single purpose resource declarations on a single line.

 Good: 

```
exec { 'hambone':
  path => '/usr/bin',
  cwd  => '/tmp',
}

exec { 'test':
  subscribe   => File['/etc/test'],
  refreshonly => true,
}

myresource { 'test':
  ensure => present,
  myhash => {
    'myhash_key1' => 'value1',
    'key2'        => 'value2',
  },
}

notify { 'warning': message => 'This is an example warning' }Copied!
```

 Bad: 

```
exec { 'hambone':
path  => '/usr/bin',
cwd => '/tmp',
}

file { "/path/to/my-filename.txt":
  ensure => file, mode => $mode, owner => $owner, group => $group,
  source => 'puppet:///modules/my-module/productions/my-filename.txt'
}Copied!
```

### Attribute ordering

If a resource declaration includes an `ensure` attribute, it should be the        first attribute specified so that a user can quickly see if the resource is being created or        deleted.

 Good: 

```
file { '/tmp/readme.txt':
  ensure => file,
  owner  => '0',
  group  => '0',
  mode   => '0644',
}Copied!
```

When using the special attribute `*` (asterisk or splat character) in        addition to other attributes, splat should be ordered last so that it is easy to see. You        may not include multiple splats in the same body.

Good:

```
$file_ownership = {
  'owner' => 'root',
  'group' => 'wheel',
  'mode'  => '0644',
}

file { '/etc/passwd':
  ensure => file,
  *      => $file_ownership,
}Copied!
```

### Resource arrangement

Within a manifest, resources should be grouped by logical relationship to each other,        rather than by resource type.

 Good: 

```
file { '/tmp/dir':
  ensure => directory,
}

file { '/tmp/dir/a':
  content => 'a',
}

file { '/tmp/dir2':
  ensure => directory,
}

file { '/tmp/dir2/b':
  content => 'b',
}Copied!
```

 Bad: 

```
file { '/tmp/dir':
  ensure => directory,
}

file { '/tmp/dir2':
  ensure => directory,
}

file { '/tmp/dir/a':
  content => 'a',
}

file { '/tmp/dir2/b':
  content => 'b',
}Copied!
```

Use semicolon-separated multiple resource bodies only in conjunction with a local default        body.

 Good: 

```
$defaults = { < hash of defaults > }

file {
  default: 
    * => $defaults,;

  '/tmp/testfile':
    content => 'content of the test file',
}Copied!
```

 Good: Repeated pattern with defaults: 

```
$defaults = { < hash of defaults > }

file {
  default: 
    * => $defaults,;

  '/tmp/motd':
    content => 'message of the day',;

  '/tmp/motd_tomorrow':
    content => 'tomorrows message of the day',;
}Copied!
```

 Bad: Unrelated resources grouped: 

```
file {
  '/tmp/testfile':
    owner    => 'admin',
    mode     => '0644',
    contents => 'this is the content',;

  '/opt/myapp':
    owner  => 'myapp-admin',
    mode   => '0644',
    source => 'puppet://<someurl>',;

  # etc
}Copied!
```

You cannot set any attribute more than one time for a given resource; if you try, Puppet raises a compilation error. This means:

- If you use a hash to set attributes for a resource, you cannot set a different, explicit          value for any of those attributes. For example, if mode is present in the hash, you can’t          also set `mode => "0644"` in that resource body.
- You can’t use the `*` attribute multiple times in one resource body,          because `*` itself acts like an attribute.
- To use some attributes from a hash and override others, either use a hash to set          per-expression defaults, or use the `+` (merging) operator to combine          attributes from two hashes (with the right-hand hash overriding the left-hand one).

### Symbolic links

Declare symbolic links with an ensure value of `ensure => link`. To        inform the user that you are creating a link, specify a value for the          `target` attribute.

 Good: 

```
file { '/var/log/syslog':
  ensure => link,
  target => '/var/log/messages',
}Copied!
```

 Bad: 

```
file { '/var/log/syslog':
  ensure => '/var/log/messages',
}Copied!
```

### File modes

- POSIX numeric notation must be represented as 4 digits.
- POSIX symbolic notation must be a string.
- You should not use file mode with Windows; instead use            the [acl module](https://forge.puppet.com/puppetlabs/acl).
- You should use numeric notation whenever possible.
- The file mode attribute should always be a quoted string or (unquoted) variable, never            an integer.

 Good: 

```
file { '/var/log/syslog':
  ensure => file,
  mode   => '0644',
}Copied!
```

 Bad: 

```
file { '/var/log/syslog':
  ensure => present,
  mode   => 644,
}Copied!
```

### Multiple resources

Multiple resources declared in a single block should be used only when there is also a        default set of options for the resource type.

Good:

```
file {
  default:
    ensure => 'file',
    mode   => '0666',;

  '/owner':
    user => 'owner',;

  '/staff':
    user => 'staff',;
}Copied!
```

Good: Give the defaults a name if used several        times: 

```
$our_default_file_attributes = { 
  'ensure' => 'file', 
  'mode'   => '0666', 
}
 
file {
  default:
    * => $our_default_file_attributes,;

  '/owner':
    user => 'owner',;

  '/staff':
    user => 'staff',;
}Copied!
```

Good: Spell out 'magic'        iteration:

```
['/owner', '/staff'].each |$path| {
  file { $path:
    ensure => 'file',
  }
}Copied!
```

Good: Spell out 'magic'        iteration: 

```
$array_of_paths.each |$path| {
  file { $path:
    ensure => 'file',
  }
}Copied!
```

Bad:

```
file {
  '/owner':
    ensure => 'file',
    user   => owner,
    mode   => '0666',;

  '/staff':
    ensure => 'file',
    user   => staff,
    mode   => '0774',;
}

file { ['/owner', '/staff']:
  ensure => 'file',
}
 
file { $array_of_paths:
  ensure => 'file',
}Copied!
```

### Legacy style defaults

Avoid legacy style defaults. If you do use them, they should occur only at top scope in        your site manifest. This is because resource defaults propagate through dynamic scope, which        can have unpredictable effects far away from where the default was declared.

Acceptable: `site.pp`:

```
Package {
  provider => 'zypper',
}Copied!
```

Bad: `/etc/puppetlabs/puppet/modules/apache/manifests/init.pp`:

```
File {
  owner => 'nobody',
  group => 'nogroup',
  mode  => '0600',
}

concat { $config_file_path:
  notify  => Class['Apache::Service'],
  require => Package['httpd'],
}Copied!
```

### Attribute alignment

Resource attributes must be uniformly indented in two spaces from the title.

Good:

```
file { '/owner':
  ensure => 'file',
  owner  => 'root',
}Copied!
```

Bad: Too many levels of        indentation:

```
file { '/owner':
    ensure => 'file',
    owner  => 'root',
}Copied!
```

Bad: No        indentation:

```
file { '/owner':
ensure => 'file',
owner  => 'root',
}
Copied!
```

Bad: Improper and non-uniform        indentation:

```
file { '/owner':
  ensure => 'file',
   owner => 'root',
}Copied!
```

Bad: Indented the wrong        direction:

```
  file { '/owner':
ensure => 'file',
owner  => 'root',
  }Copied!
```

For multiple bodies, each title should be on its own line, and be indented.        You may align all arrows across the bodies, but arrow alignment is not required if alignment        per body is more readable.

```
file {
  default:
    * => $local_defaults,;
 
  '/owner':
    ensure => 'file',
    owner  => 'root',
}Copied!
```

### Defined resource types

Because defined resource types can have multiple instances, resource names must have a        unique variable to avoid duplicate declarations.

Good: Template uses `$listen_addr_port`:

```
define apache::listen {
  $listen_addr_port = $name

  concat::fragment { "Listen ${listen_addr_port}":
    ensure  => present,
    target  => $::apache::ports_file,
    content => template('apache/listen.erb'),
  }
}Copied!
```

Bad: Template uses `$name`:

```
define apache::listen {

  concat::fragment { 'Listen port':
    ensure  => present,
    target  => $::apache::ports_file,
    content => template('apache/listen.erb'),
  }
}Copied!
```

## Classes and defined types 

Classes and defined types should follow scope and    organization guidelines.

### Separate files

Put all classes and resource type definitions (defined types) as separate files in the          `manifests` directory of the module. Each file in the manifest directory        should contain nothing other than the class or resource type definition.

Good: `etc/puppetlabs/puppet/modules/apache/manifests/init.pp`:

```
class apache { }Copied!
```

Good:          `etc/puppetlabs/puppet/modules/apache/manifests/ssl.pp`:

```
class apache::ssl { }Copied!
```

Good:          `etc/puppetlabs/puppet/modules/apache/manifests/virtual_host.pp`:

```
define apache::virtual_host () { }Copied!
```

Separating classes and defined types into separate files is functionally identical to        declaring them in `init.pp`, but has the benefit of        highlighting the structure of the module and making the function and structure more        legible.

When a resource or include statement is placed outside of a class, node definition, or        defined type, it is included in all catalogs. This can have undesired effects and is not        always easy to detect.

Good: `manifests/init.pp`:

```
# class ntp
class ntp {
  ntp::install
}
# end of fileCopied!
```

Bad: `manifests/init.pp`:

```
class ntp {
  #...
}
ntp::installCopied!
```

### Internal organization of classes and defined types

Structure classes and defined types to accomplish one task.

Documentation comments for Puppet Strings should be included        for each class or defined type. If used, documentation comments must precede the name of the        element. For complete documentation recommendations, see the Modules section. 

Put the lines of code in the following order:

1. First line: Name of class or type.
2. Following lines, if applicable: Define parameters. Parameters should be [typed](https://www.puppet.com/docs/puppet/7/lang_data_type.html#lang_data_type).
3. Next lines: Includes and validation come after parameters are defined. Includes may              come before or after validation, but should be grouped separately, with all includes              and requires in one group and all validations in another. Validations should validate              any parameters and fail catalog compilation if any parameters are invalid. See [puppetlabs-ntp](https://github.com/puppetlabs/puppetlabs-ntp/blob/3.3.0/manifests/init.pp#init) for an example.
4. Next lines, if applicable: Should declare local variables and perform variable              munging.
5. Next lines: Should declare resource defaults.
6. Next lines: Should override resources if necessary.

The following example follows the recommended style.

In `init.pp`: 

- The `myservice` class installs packages, ensures the              state of `myservice`, and creates a tempfile with given              content. If the tempfile contains digits, they are filtered out. 

- ​              `@param service_ensure` the wanted state of services.            

- ​              `@param package_list` the list of packages to install,              at least one must be given, or an error of unsupported OS is raised. 

- `@param tempfile_contents` the text to be included in              the tempfile, all digits are filtered out if              present.

  ```
  class myservice (
    Enum['running', 'stopped'] $service_ensure,
    String                     $tempfile_contents,
    Optional[Array[String[1]]] $package_list = undef,
  ) {Copied!
  ```

- Rather than just saying that there was a type mismatch for `$package_list`, this example includes an additional assertion with an              improved error message. The list can be "not given", or have an empty list of packages              to install. An assertion is made that the list is an array of at least one String, and              that the String is at least one character              long.

  ```
    assert_type(Array[String[1], 1], $package_list) |$expected, $actual| {
      fail("Module ${module_name} does not support ${facts['os']['name']} as the list of packages is of type ${actual}")
    }
  
    package { $package_list:
      ensure => present,
    }
  
    file { "/tmp/${variable}":
      ensure   => present,
      contents => regsubst($tempfile_contents, '\d', '', 'G'),
      owner    => '0',
      group    => '0',
      mode     => '0644',
    }
  
    service { 'myservice':
      ensure    => $service_ensure,
      hasstatus => true,
    }
   
    Package[$package_list] -> Service['myservice']
  }Copied!
  ```

In `hiera.yaml`: The default values can be merged if you want        to extend with additional packages. If not, use `default_hierarchy` instead of `hierarchy`.

```
---
version: 5
defaults:
  data_hash: yaml_data
 
hierarchy:
- name: 'Per Operating System'
  path: "os/%{os.name}.yaml"
- name: 'Common'
  path: 'common.yaml'Copied!
```

In `data/common.yaml`:

```
myservice::service_ensure: runningCopied!
```

In          `data/os/centos.yaml`:

```
myservice::package_list:
- 'myservice-centos-package'Copied!
```

### Public and private

Split your module into public and private classes and defined types where possible. Public        classes or defined types should contain the parts of the module meant to be configured or        customized by the user, while private classes should contain things you do not expect the        user to change via parameters. Separating into public and private classes or defined types        helps build reusable and readable code.

Help indicate to the user which classes are which by making sure all public classes have        complete comments and denoting public and private classes in your documentation. Use the        documentation tags “@api private” and “@api public” to make this clear. For complete        documentation recommendations, see the Modules section. 

### Chaining arrow syntax

Most of the time, use [relationship metaparameters](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships) rather than [chaining           arrows](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships). When you have many [interdependent or order-specific items](https://github.com/puppetlabs/puppetlabs-mysql/blob/3.1.0/manifests/server.pp#server), chaining syntax may be        used. A chain operator should appear on the same line as its right-hand operand. Chaining        arrows must be used left to right.

Good: Points left to        right:

```
Package['httpd'] -> Service['httpd']Copied!
```

Good:        On the line of the right-hand        operand:

```
Package['httpd']
-> Service['httpd']Copied!
```

Bad: Arrows are not all pointing to the        right:

```
Service['httpd'] <- Package['httpd']Copied!
```

Bad:        Must be on the right-hand operand's        line:

```
Package['httpd'] ->
Service['httpd']Copied!
```

### Nested classes or defined types

Don't define classes and defined resource types within other classes or defined types.        Declare them as close to node scope as possible. If you have a class or defined type which        requires another class or defined type, put graceful failures in place if those required        classes or defined types are not declared elsewhere.

Bad:

```
class apache {
  class ssl { ... }
}Copied!
```

Bad:

```
class apache {
  define config() { ... }
}Copied!
```

### Display order of parameters

In parameterized class and defined resource type definitions, you can list required        parameters before optional parameters (that is, parameters with defaults). Required        parameters are parameters that are not set to anything, including undef. For example,        parameters such as passwords or IP addresses might not have reasonable default values.

You can also group related parameters, order them alphabetically, or in the order you        encounter them in the code. How you order parameters is personal preference.

Note that treating a parameter like a namevar and defaulting it to `$title` or `$name` does not make it a required        parameter. It should still be listed following the order recommended here.

Good:

```
class dhcp (
  $dnsdomain,
  $nameservers,
  $default_lease_time = 3600,
  $max_lease_time     = 86400,
) {}Copied!
```

Bad:

```
class ntp (
  $options   = "iburst",
  $servers,
  $multicast = false,
) {}Copied!
```

### Parameter defaults

Adding default values to the parameters in classes and defined types makes your module        easier to use. Use Hiera data in your module to set parameter        defaults. See [Defining classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_class_define) for details about setting parameter        defaults with Hiera data. In simple cases, you can also        specify the default values directly in the class or defined type. 

Be sure to declare the data type of parameters, as this provides automatic type        assertions.

Good: Parameter defaults set in the class with references to Hiera        data:

```
class my_module (
  String $source,
  String $config,
) {
  # body of class
}Copied!
```

A `hiera.yaml` in the root of the module sets the        hierarchy for assigning defaults:

```
---
version: 5
default_hierarchy: 
- name: 'defaults'
  path: 'defaults.yaml'
  data_hash: yaml_dataCopied!
```

And the file `data/defaults.yaml` specifies the actual default        values:

```
my_module::source: 'default source value'
my_module::config: 'default config value'Copied!
```

This example places the values in the defaults hierarchy, which means that the defaults are        not merged into overriding values. To merge the defaults into those values, change the          `default_hierarchy` to `hierarchy`.

If you are maintaining old code created prior to Puppet 4.9,        you might encounter the use of a `params.pp` pattern. This        pattern makes maintenance and troubleshooting difficult — refactor such code to use the Hiera data-in-modules pattern instead. See [Adding Hiera data to a module](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#adding_hiera_data_module) for a detailed example showing how to replace          `params.pp` with data.

Bad: `params.pp`      

```
class my_module ( 
  String $source = $my_module::params::source,
  String $config = $my_module::params::config,
) inherits my_module::params {
  # body of class
}Copied!
```

### Exported resources

Exported resources should be opt-in rather than opt-out. Your module should not be written        to use exported resources to function by default unless it is expressly required.

When using exported resources, name the property `collect_exported`.

Exported resources should be exported and collected selectively using a [search expression](https://www.puppet.com/docs/puppet/7/lang_collectors.html), ideally allowing user-defined tags        as parameters so tags can be used to selectively collect by environment or custom fact.

Good:

```
define haproxy::frontend (
  $ports            = undef,
  $ipaddress        = [$::ipaddress],
  $bind             = undef,
  $mode             = undef,
  $collect_exported = false,
  $options          = {
    'option' => [
      'tcplog',
    ],
  },
) {
  # body of define
}Copied!
```

### Parameter indentation and alignment

Parameters to classes or defined types must be uniformly indented in two spaces from the        title. The equals sign should be aligned.

Good:

```
class profile::myclass (
  $var1    = 'default',
  $var2    = 'something else',
  $another = 'another default value',
) {

}Copied!
```

Good: 

```
class ntp (
  Boolean                        $broadcastclient = false,
  Optional[Stdlib::Absolutepath] $config_dir      = undef,
  Enum['running', 'stopped']     $service_ensure  = 'running',
  String                         $package_ensure  = 'present',
  # ...
) {
# ...
}Copied!
```

Bad: Too many level of        indentation:

```
class profile::myclass (
      $var1    = 'default',
      $var2    = 'something else',
      $another = 'another default value',
) {

}Copied!
```

Bad: No        indentation:

```
class profile::myclass (
$var1    = 'default',
$var2    = 'something else',
$another = 'another default value',
) {

}Copied!
```

Bad: Misaligned equals        sign: 

```
class profile::myclass (
  $var1 = 'default',
  $var2  = 'something else',
  $another = 'another default value',
) {

}Copied!
```

### Class inheritance

In addition to scope and organization, there are some additional guidelines for handling        classes in your module.

Don't use class inheritance; use data binding instead of `params.pp` pattern. Inheritance is used only for `params.pp`, which is not recommended in Puppet        4.

If you use inheritance for maintaining older modules, do not use it across module        namespaces. To satisfy cross-module dependencies in a more portable way, include statements        or relationship declarations. Only use class inheritance for `myclass::params` parameter defaults. Accomplish other use cases by adding        parameters or conditional logic.

Good:

```
class ssh { ... }

class ssh::client inherits ssh { ... }

class ssh::server inherits ssh { ... }Copied!
```

Bad:

```
class ssh inherits server { ... }

class ssh::client inherits workstation { ... }

class wordpress inherits apache { ... }Copied!
```

### Public modules

When declaring classes in publicly available modules, use `include`, `contain`, or `require` rather than class resource declaration. This avoids        duplicate class declarations and vendor lock-in.

### Type signatures 

We recommend always using type signatures for class and defined type parameters. Keep the        parameters and `=` signs aligned. 

When dealing with very long type signatures, you can define type aliases and use short        definitions. Good naming of aliases can also serve as documentation, making your code easier        to read and understand. Or, if necessary, you can turn the 140 line character limit off. For        more information on type signatures, see [the `Type` data         type](https://www.puppet.com/docs/puppet/7/lang_data_type.html#lang_data_type).

**Related information**

- [Modules](https://www.puppet.com/docs/puppet/7/style_guide.html#style_guide_modules)

## Variables 

Reference variables in a clear, unambiguous                                way that is consistent with the Puppet style.

### Referencing facts

When referencing facts, prefer the `$facts` hash to plain                                                  top-scope variables (such as `$::operatingsystem`).

Although plain top-scope variables are easier to                                                  write, the `$facts` hash is clearer, easier to                                                  read, and distinguishes facts from other top-scope                                                  variables.

### Namespacing variables

When referencing top-scope variables other than                                                  facts, explicitly specify absolute namespaces for                                                  clarity and improved readability. This includes                                                  top-scope variables set by the node classifier and                                                  in the main manifest.

This is not necessary for:

- the `$facts`                                                  hash.
- the `$trusted`                                                  hash.
- the `$server_facts` hash.

These special variable names are protected;                                                  because you cannot create local variables with                                                  these names, they always refer to top-scope                                                  variables.

Good:

```
$facts['operatingsystem']Copied!
```

Bad:

```
$::operatingsystemCopied!
```

Very                                                  bad:

```
$operatingsystemCopied!
```

### Variable format

When defining variables you must only use                                                  numbers, lowercase letters, and underscores. Do                                                  not use upper-case letters within a word, such as                                                  “CamelCase”, as it introduces inconsistency in                                                  style. You must not use dashes, as they are not                                                  syntactically valid.

Good:

```
$server_facts
$total_number_of_entries
$error_count123Copied!
```

Bad:

```
$serverFacts
$totalNumberOfEntries
$error-count123Copied!
```

## Conditionals 

Conditional statements should follow Puppet code guidelines.

### Simple resource declarations

Avoid mixing conditionals with resource declarations. When you use conditionals for data        assignment, separate conditional code from the resource declarations.

​        **Good:**      

```
$file_mode = $facts['operatingsystem'] ? {
  'debian' => '0007',
  'redhat' => '0776',
   default => '0700',
}

file { '/tmp/readme.txt':
  ensure  => file,
  content => "Hello World\n",
  mode    => $file_mode,
}Copied!
```

​        **Bad:**      

```
file { '/tmp/readme.txt':
  ensure  => file,
  content => "Hello World\n",
  mode    => $facts['operatingsystem'] ? {
    'debian' => '0777',
    'redhat' => '0776',
    default  => '0700',
  }
}Copied!
```

### Defaults for case statements and selectors

Case statements must have default cases. If you want the default case to be "do nothing,"        you must include it as an explicit `default: {}` for clarity's sake.

Case and selector values must be enclosed in quotation marks.

Selectors should omit default selections only if you explicitly want catalog compilation to        fail when no value matches.

​        **Good:**      

```
case $facts['operatingsystem'] {
  'centos': {
    $version = '1.2.3'
  }
  'ubuntu': {
    $version = '3.2.1'
  }
  default: {
    fail("Module ${module_name} is not supported on ${::operatingsystem}")
  }
}Copied!
```

When setting the default case, keep in mind that the default case should cause the catalog        compilation to fail if the resulting behavior cannot be predicted on the platforms the        module was built to be used on.

### Conditional statement alignment 

When using if/else statements, align in the following way:        

```
if $something {
  $var = 'hour'
} elsif $something_else {
  $var = 'minute'
} else {
  $var = 'second'
}Copied!
```

For more information on if/else statements, see [Conditional           statements and expressions](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional). 

## Modules 

Develop your module using consistent code and module      structures to make it easier to update and maintain. 

### Versioning

Your module must be versioned, and have metadata defined in the `metadata.json` file. 

We recommend semantic versioning.

Semantic versioning, or [SemVer](http://semver.org/), means that in a version number given as x.y.z: 

- An increase in 'x' indicates major changes: backwards incompatible changes or a                     complete rewrite.
- An increase in 'y' indicates minor changes: the non-breaking addition of new                     features.
- An increase in 'z' indicates a patch: non-breaking bug fixes.

### Module metadata

Every module must have metadata defined in the `metadata.json` file.

Your metadata should follow the following            format:

```
{
  "name": "examplecorp-mymodule",
  "version": "0.1.0",
  "author": "Pat",
  "license": "Apache-2.0",
  "summary": "A module for a thing",
  "source": "https://github.com/examplecorp/examplecorp-mymodule",
  "project_page": "https://github.com/examplecorp/examplecorp-mymodule",
  "issues_url": "https://github.com/examplecorp/examplecorp-mymodules/issues",
  "tags": ["things", "stuff"],
  "operatingsystem_support": [
    {
      "operatingsystem":"RedHat",
      "operatingsystemrelease": [
        "5.0",
        "6.0"
      ]
    },
    {
      "operatingsystem": "Ubuntu",
      "operatingsystemrelease": [ 
        "12.04",
        "10.04"
     ]
    }
  ],
  "dependencies": [
    { "name": "puppetlabs/stdlib", "version_requirement": ">= 3.2.0 <5.0.0" },
    { "name": "puppetlabs/firewall", "version_requirement": ">= 0.4.0 <5.0.0" },
  ]
}Copied!
```

For additional information regarding the `metadata.json` format, see [Adding module metadata in metadata.json](https://www.puppet.com/docs/puppet/7/modules_publishing.html#modules_publishing). 

### Dependencies

Hard dependencies must be declared explicitly in your module’s metadata.json file.

Soft dependencies should be called out in the README.md, and must not be enforced as a            hard requirement in your metadata.json. A soft dependency is a dependency that is only            required in a specific set of use cases. For an example, see the [rabbitmq module](https://forge.puppet.com/puppetlabs/rabbitmq#module-dependencies).

Your hard dependency declarations should not be unbounded.

### README

Your module should have a README in `.md` (or `.markdown`) format. READMEs help users of your module get the            full benefit of your work. 

The [Puppet README template ](https://github.com/puppetlabs/pdk-templates/blob/master/moduleroot_init/README.md.erb)offers a basic format you can use. If            you create modules with Puppet Development Kit or the `puppet module generate` command, the generated README            includes the template. Using the .md/.markdown format allows your README to be parsed            and displayed by Puppet Strings, GitHub, and the Puppet Forge. 

You can find thorough, detailed information on writing a great README in [Documenting modules](https://www.puppet.com/docs/puppet/7/modules_documentation.html#modules_documentation), but in general your README should:

- Summarize what your module does.
- Note any setup requirements or limitations, such as "This module requires the                        `puppetlabs-apache` module and only works on                        Ubuntu."
- Note any part of a user’s system the module might impact (for example, “This                     module overwrites everything in `animportantfile.conf`.”).
- Describe  how to customize and configure the module.
- Include usage examples and code samples for the common use cases for your                     module.

### Documenting Puppet code

Use [Puppet Strings](https://github.com/puppetlabs/puppet-strings) code comments to document            your Puppet classes, defined types, functions, and            resource types and providers. Strings processes the README and comments from your code            into HTML or JSON format documentation. This allows you and your users to generate            detailed documentation for your module.

Include comments for each element (classes, functions, defined types, parameters, and so            on) in your module. If used, comments must precede the code for that element. Comments            should contain the following information, arranged in this order: 

- A description giving an overview of what the element does.
- Any additional information about valid values that is not clear from the data                     type. For example, if the data type is `[String]`, but the value must specifically be a path. 
- The default value, if any, for that element,

Multiline descriptions must be uniformly indented by at least one            space:

```
# @param config_epp Specifies a file to act as a EPP template for the config file.
#  Valid options: a path (absolute, or relative to the module path). Example value: 
#  'ntp/ntp.conf.epp'. A validation error is thrown if you supply both this param **and**
#  the `config_template` param.Copied!
```

If you use Strings to document your module, include information about Strings in the            Reference section of your README so that your users know how to generate the            documentation. See [Puppet             Strings](https://github.com/puppetlabs/puppet-strings) documentation for details on usage, installation, and correctly            writing documentation comments.

If you do not include Strings code comments, you should include a Reference section in            your README with a complete list of all classes, types, providers, defined types, and            parameters that the user can configure. Include a brief description, the valid options,            and the default values (if any). 

For example, this is a parameter for the `ntp` module’s `ntp` class:               `package_ensure`:            

```
Data type: String.

Whether to install the NTP package, and what version to install. Values: 'present', 'latest', or a specific version number.

Default value: 'present'.Copied!
```

For more details and examples, see the [module                documentation guide](https://www.puppet.com/docs/puppet/7/modules_documentation.html#modules_documentation).

### CHANGELOG

Your module should include a change log file called `CHANGELOG.md` or `.markdown`. Your change log            should: 

- Have entries for each release.
- List bugfixes and features included in the release.
- Specifically call out backwards-incompatible changes.

### Examples

In the `/examples` directory, include example            manifests that demonstrate major use cases for your module.            

```
modulepath/apache/examples/{usecase}.ppCopied!
```

The            example manifest should provide a clear example of how to declare the class or defined            resource type. It should also declare any classes required by the corresponding class to               ensure `puppet apply` works in a limited,            standalone manner.

### Testing

You can use these community tools to test your code and style: 

- [puppet-lint](http://puppet-lint.com/) tests your code for adherence to the style guidelines.
- [metadata-json-lint](https://github.com/voxpupuli/metadata-json-lint) tests your `metadata.json` for adherence to the style guidelines.
- [voxpupuli-puppet-lint-plugins](https://github.com/voxpupuli/voxpupuli-puppet-lint-plugins/) tests your                  code against linter configurations that the Puppet                  community, Vox Pupuli, uses. Vox Pupuli also maintains a [list of                      notable plugins](https://voxpupuli.org/plugins/); however, we have not tested or reviewed all of these                  plugins.
- For testing your module, we recommend the [Puppet Development Kit (PDK)](https://puppet.com/docs/pdk/latest/pdk.html),                  which can help you generate basic spec tests. Use [rspec-puppet](https://github.com/rodjek/rspec-puppet/#rspec-tests-for-your-puppet-manifests--modules) for more advanced                  testing.

# Files and paths on Windows    

### Sections

[Directory separators in file paths](https://www.puppet.com/docs/puppet/7/lang_windows_file_paths.html#dir-separators-file-paths)

[Line endings in files](https://www.puppet.com/docs/puppet/7/lang_windows_file_paths.html#file-line-endings)

​        Puppet and Windows handle        directory separators and line endings in files somewhat differently, so you must be aware of        the differences when you are writing manifests to manage Windows systems.

## Directory separators in file paths

Several resource types (including `file`, `exec`, and `package`) take                file paths as values for various attributes. The Puppet language uses the backslash (`\`) as an escape                character in quoted strings. However, Windows also                uses the backslash to separate directories in file paths, such as `C:\Program Files\PuppetLabs`. Additionally, Windows file system APIs accept both backslashes and                forward slashes in file paths, but some Windows                programs accept only backslashes.

Generally, if Puppet itself is interpreting the file                path, or if the file path is meant for the primary server, use forward slashes. If                the file path is being passed directly to a Windows                program, use backslashes. The following table lists common directory path uses and                what kind of slashes are required by each. 

| File path usage                                              | Slash type                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Template paths, such as `template('my_module/content.erb')`. | Forward slash (`/`)                                          |
| `puppet:///` URLs.                                           | Forward slash (`/`)                                          |
| The `path` attribute or title of a                                `file` resource. | Forward slash (`/`) or backslash                                (`\`) |
| The `source` attribute of a `package` resource.              | Forward slash (`/`) or backslash                                (`\`) |
| Local paths in a `file` resource's                                `source` attribute. | Forward slash (`/`) or backslash                                (`\`) |
| The `command` of an `exec` resource. However, some executables,                            such as `cmd.exe`, require backslashes. | Forward slash (`/`) or backslash                                (`\`) |
| Any file paths included in the `command` of a `scheduled_task` resource. | Backslash (`\`)                                              |
| Any file paths included in the `install_options` of a `package` resource. | Backslash (`\`)                                              |
| Any file paths used for Windows                            PowerShell DSC resources. For these                            resources, single quote strings whenever possible. | Backslash (`\`)                                              |

## Line endings in files

Windows uses CRLF line endings instead of *nix's LF line endings. Be aware of the following                issues: 

- If you specify the contents of a file with the `content`                            attribute, Puppet writes the content in                            binary mode. To create files with CRLF line endings, specify the                                `\r\n` escape sequence as part of the content.

- When downloading a file to a Windows node                            with the `source` attribute, Puppet transfers the file in binary mode,                            leaving the original newlines untouched.

- If you are using version control, such as Git, ensure that it is configured to use CRLF line endings.

- Non-`file` resource types that make partial edits to a                            system file, such as the [                                 `host` resource type](https://forge.puppet.com/puppetlabs/host_core), which manages the                                `%windir%\system32\drivers\etc\hosts` file, manage                            their files in text mode and automatically translate between Windows and *nix line endings. 

  Note:  When writing                                your own resource types, you can get this behavior by using the                                    `flat` file type. 

**Related information**

- [Templates](https://www.puppet.com/docs/puppet/7/lang_template.html)
- [Strings](https://www.puppet.com/docs/puppet/7/lang_data_string.html#lang_data_string)

# Code comments 

To add comments to your Puppet code, use shell-style or hash comments. 

Hash comments begin with a hash symbol (`#`) and continue to the end of a line. You can start      comments either at the beginning of a line or partway through a line that began with code.      

```
# This is a comment
file {'/etc/ntp.conf': # This is another comment
  ensure => file,
  owner  => root,
}
```

# Variables

### Sections

[Assigning variables](https://www.puppet.com/docs/puppet/7/lang_variables.html#assigning-variables)

[Resolution](https://www.puppet.com/docs/puppet/7/lang_variables.html#variables-resolution)

[Interpolation](https://www.puppet.com/docs/puppet/7/lang_variables.html#variable-interpolation)

[Scope](https://www.puppet.com/docs/puppet/7/lang_variables.html#variables-scope)

[Unassigned variables and strict mode](https://www.puppet.com/docs/puppet/7/lang_variables.html#unassigned-variables-and-strict-mode)

[Naming variables](https://www.puppet.com/docs/puppet/7/lang_variables.html#lang_var_naming)

- [Variable names](https://www.puppet.com/docs/puppet/7/lang_variables.html#variable-names)

Variables store values so that those values can be accessed    in code later.

After        you've assigned a variable a value, you cannot reassign it. Variables depend on order of        evaluation: you must assign a variable a value before it can be resolved.

The following video gives you an overview of variables:

​                  

Note:           Puppet contains built-in variables that you can use in your          manifests. For a list of these, see the page on [facts and built-in           variables](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html). 

## Assigning variables

Prefix variable names with a dollar sign (`$`). Assign values        to variables with the equal sign (`=`) assignment        operator.

Variables accept values of any data type. You can assign literal values, or you can assign        any statement that resolves to a normal value, including expressions, functions, and other        variables. The variable then contains the value that the statement resolves to, rather than        a reference to the statement.        

```
$content = "some content\n"Copied!
```

Assign variables using their short name within their own scope. You cannot assign values in        one scope from another scope. For example, you can assign a value to the          `apache::params` class's `$vhostdir`        variable only from within the `apache::params` class.

You can assign multiple variables at the same time from an array or hash.

To assign multiple variables from an array, you must specify an equal number of variables        and values. If the number of variables and values do not match, the operation fails. You can        also use nested arrays. For example, all of the variable assignments shown below are valid.        

```
[$a, $b, $c] = [1,2,3]      # $a = 1, $b = 2, $c = 3
[$a, [$b, $c]] = [1,[2,3]]  # $a = 1, $b = 2, $c = 3
[$a, $b] = [1, [2]]            # $a = 1, $b = [2]
[$a, [$b]] = [1, [2]]          # $a = 1, $b = 2Copied!
```

When you assign multiple variables with a hash, list the variables in an array on the left        side of the assignment operator, and list the hash on the right. Hash keys must match their        corresponding variable name. This example assigns a value of 10 to the `$a`        variable and a value of 20 to the `$b`        variable.

```
[$a, $b] = {a => 10, b => 20}  # $a = 10, $b = 20Copied!
```

You can include extra key-value pairs in the hash, but all variables to the left of the        operator must have a corresponding key in the        hash:

```
[$a, $c] = {a => 5, b => 10, c => 15, d => 22}  # $a = 5, $c = 15Copied!
```

Puppet allows a given variable to be assigned a value only        one time within a given scope. This is a little different from most programming languages.        You cannot change the value of a variable, but you can assign a different value to the same        variable name in a new scope:        

```
# scope-example.pp
# Run with puppet apply --certname www1.example.com scope-example.pp
$myvar = "Top scope value"
node 'www1.example.com' {
  $myvar = "Node scope value"
  notice( "from www1: $myvar" )
  include myclass
}
node 'db1.example.com' {
  notice( "from db1: $myvar" )
  include myclass
}
class myclass {
  $myvar = "Local scope value"
  notice( "from myclass: $myvar" )
}Copied!
```

## Resolution

You can use the name of a variable in any place where a value of the variable's data type        would be accepted, including expressions, functions, and resource attributes. Puppet replaces the name of the variable with its value. By        default, unassigned variables have a value of `undef`. See the section about        unassigned variables and strict mode for more details.

In these examples, the `content` parameter value resolves to whatever value        has been assigned to the `$content` variable. The          `$address_array` variable resolves to an array of the values assigned to        the `$address1`, `$address2`, and `$address3`        variables:

```
file {'/tmp/testing':
  ensure  => file,
  content => $content,
}

$address_array = [$address1, $address2, $address3]Copied!
```

## Interpolation

​        Puppet can resolve variables that are included in        double-quoted strings; this is called interpolation. Inside a double-quoted        string, surround the name of the variable (the portion after the `$`) with curly braces, such as `${var_name}`. This        syntax is optional, but it helps to avoid ambiguity and allows variables to be placed        directly next to non-whitespace characters. These optional curly braces are permitted only        inside strings.

For example, the curly braces make it easier to quickly identify the variable          `$homedir`.

```
$rule = "Allow * from $ipaddress"
file { "${homedir}/.vim":
  ensure => directory,
  ...
}
            Copied!
```

## Scope

The area of code where a given variable is visible is dictated by its scope.        Variables in a given scope are available only within that scope and its child scopes, and        any local scope can locally override the variables it receives from its parents. See the        section on [scope](https://www.puppet.com/docs/puppet/7/lang_scope.html#lang_scope) for complete details. 

You can access out-of-scope variables from named scopes by using their qualified names,        which include namespaces representing the variable's scope. The scope is where the variable        is defined and assigned a value. For example, the qualified name of this          `$vhost` variable shows that the variable is found and assigned a value in        the `apache::params` class:        

```
$vhostdir = $apache::params::vhostdirCopied!
```

Variables can be assigned outside of any class, type, or node definition. These top          scope variables have an empty string as their first namespace segment, so that the        qualified name of a top scope variable begins with a double colon, such as          `$::osfamily`. 

## Unassigned variables and strict mode

By default, you can access variables that have never had values assigned to them. If you        do, their value is `undef`. This can be a problem, because an unassigned        variable is often an accident or a typo. To make unassigned variable usage return an error,        so that you can find and fix the problem, enable strict mode by setting          `strict_variables = true` strict_variables in the          `puppet.conf` file on your primary server and on any nodes that run          `puppet apply`. For details about this setting, see the [configuration](https://www.puppet.com/docs/puppet/7/configuration.html) page.

**Related information**

- [Expressions and operators](https://www.puppet.com/docs/puppet/7/lang_expressions.html#lang_expressions)
- [Function calls](https://www.puppet.com/docs/puppet/7/lang_functions.html#lang_functions)

## Naming variables



Some variable names are reserved; for detailed information, see                the [reserved                     name](https://www.puppet.com/docs/puppet/7/lang_reserved.html#lang_reserved) page.

### Variable names

 Variable names are case-sensitive and must begin with a dollar                sign (`$`). Most                variable names must start with a lowercase letter or an underscore. The exception is                regex capture variables, which are named with only numbers.

 Variable names can include: 

- Uppercase and lowercase letters
- Numbers
- Underscores ( `_` ). If the first character is an                            underscore, access that variable only from its own local scope.

Qualified variable names are prefixed with the name of their scope                and the double colon (`::`) namespace                separator. For example, the `$vhostdir` variable from the `apache::params` class would be `$apache::params::vhostdir`. 

 Optionally, the name of the very first namespace can be empty,                representing the top namespace. The main reason to namespace this way is to indicate                to anyone reading your code that you're accessing a top-scope variable, such as                    `$::is_virtual`.

You can also use a regular expression for variable names. Short                variable names match the following regular expression:                

```
\A\$[a-z0-9_][a-zA-Z0-9_]*\ZCopied!
```

​                Qualified variable names match the following regular expression:                

```
\A\$([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*::[a-z0-9_][a-zA-Z0-9_]*\Z
```

​                          [                 Docs                 ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)               ](https://puppet.com/docs)                     [             Open Source Puppet             ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)           ](https://puppet.com/docs/puppet)                [           Syntax and settings                        ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                    ](https://www.puppet.com/docs/puppet/7/language-and-concepts.html)                    [                 The Puppet language                                    ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                                ](https://www.puppet.com/docs/puppet/7/puppet_language.html)                          [                 Resources                                ](https://www.puppet.com/docs/puppet/7/lang_resources.html#lang_resources)            

# Resources

### Sections

[Resource declarations](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-declarations)

[Resource uniqueness](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-uniqueness)

[Relationships and ordering](https://www.puppet.com/docs/puppet/7/lang_resources.html#relationships-and-ordering)

[Resource types](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-types)

[Title](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-title)

[Attributes](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-attributes)

[Namevars and `name`       ](https://www.puppet.com/docs/puppet/7/lang_resources.html#namevars-and-name)

[Metaparameters](https://www.puppet.com/docs/puppet/7/lang_resources.html#metaparameters)

[Resource syntax](https://www.puppet.com/docs/puppet/7/lang_resources.html#lang_resource_syntax)

- [Basic syntax](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-basic-syntax)
- [Complete syntax](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-complete-syntax)
- [Resource declaration default attributes](https://www.puppet.com/docs/puppet/7/lang_resources.html#resource-declaration-default-attributes)
- [Setting attributes from a hash](https://www.puppet.com/docs/puppet/7/lang_resources.html#setting-attributes-from-hash)
- [Abstract resource types](https://www.puppet.com/docs/puppet/7/lang_resources.html#abstract-resource-types)
- [Arrays of titles](https://www.puppet.com/docs/puppet/7/lang_resources.html#arrays-of-titles)
- [Adding or modifying attributes](https://www.puppet.com/docs/puppet/7/lang_resources.html#adding-or-modifying-attributes)
- [Local resource defaults](https://www.puppet.com/docs/puppet/7/lang_resources.html#local-resource-defaults)

Expand

Resources are the fundamental unit for modeling system configurations. Each resource    describes the desired state for some aspect of a system, like a specific service or package.    When Puppet applies a catalog to the target system, it manages    every resource in the catalog, ensuring the actual state matches the desired state.

The following video gives you an overview of resources:

​                  

Resources        contained in classes and defined types share the relationships of those classes and defined        types. Resources are not subject to scope: a resource in any area of code can be referenced        from any other area of code.

A resource          declaration adds a resource to the catalog and tells Puppet to manage that resource's state. 

When Puppet applies the compiled catalog, it: 

1. Reads the actual state of the resource on              the target system.
2. Compares the actual state to the desired              state.
3. If necessary, changes the system to enforce              the desired state.
4. Logs any changes made to the resource. These              changes appear in Puppet agent's log and in the run              report, which is sent to the primary server and forwarded to any specified report              processors.

If the catalog doesn't contain a particular resource, Puppet does nothing with whatever that resource described. If        you remove a package resource from your manifests, Puppet        doesn't uninstall the package; instead, it just ignores it. To remove a package, manage it        as a resource and set `ensure => absent`.        

You can delay adding resources to the catalog. For example,        classes and defined types can contain groups of resources. These resources are managed only        if you add that class or defined resource to the catalog. Virtual resources are added to the        catalog only after they are realized.

## Resource declarations

At minimum, every resource declaration has a resource type, a          title, and a set of attributes:        

```
<TYPE> { '<TITLE>': <ATTRIBUTE> => <VALUE>, }Copied!
```

The resource title and attributes are called the resource body. A resource declaration can        have one resource body or multiple resource bodies of the same resource type.

Resource declarations are expressions in the Puppet language        — they always have a side effect of adding a resource to the catalog, but they also resolve        to a value. The value of a resource declaration is an array of resource          references, with one reference for each resource the expression describes. 

A resource declaration has extremely low precedence; in fact, it's even lower than the        variable assignment operator (`=`). This means that if you use a resource        declaration for its value, you must surround it with parentheses to associate it with the        expression that uses the value.

If a resource declaration includes more than one resource body, it declares multiple        resources of that resource type. The resource body is a title and a set of attributes; each        body must be separated from the next one with a semicolon. Each resource in a declaration is        almost completely independent of the others, and they can have completely different values        for their attributes. The only connections between resources that share an expression are: 

- They all have the same resource type.
- They can all draw from the same pool of default values, if a resource body with the              title `default` is present.

## Resource uniqueness

Each resource must be unique; Puppet does not allow you to        declare the same resource twice. This is to prevent multiple conflicting values from being        declared for the same attribute. Puppet uses the resource          `title` and the `name` attribute or namevar to        identify duplicate resources — if either the title or the name is duplicated within a given        resource type, catalog compilation fails. See the page about [resource syntax](https://www.puppet.com/docs/puppet/7/lang_resources.html#lang_resource_syntax) for details about resource titles        and namevars. To provide the same resource for multiple classes, use a class or a virtual        resource to add it to the catalog in multiple places without duplicating it. See [classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes) and [virtual resources](https://www.puppet.com/docs/puppet/7/lang_virtual.html) for more information. 

## Relationships and ordering

By default, Puppet applies unrelated resources in the order        in which they're written in the manifest. If a resource must be applied before or after some        other resource, declare a relationship between them to show that their order isn't        coincidental. You can also make changes in one resource cause a refresh of some other        resource. See the [Relationships and ordering](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships)        page for more information. 

Otherwise, you can customize the default order in which Puppet applies resources with the ordering setting. See the [configuration page](https://www.puppet.com/docs/puppet/7/configuration.html) for details about this setting. 

## Resource types

Every resource is associated with a resource type, which determines the kind        of configuration it manages. Puppet has built-in resource        types such as `file`, `service`, and `package`.        See the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html) for a complete        list and information about the built-in resource types. 

You can also add new resource types to Puppet: 

- Defined types are lightweight resource types written in the Puppet language. 
- Custom resource types are written in Ruby and have the              same capabilities as Puppet's built-in types.

## Title

A resource's title is a string that uniquely identifies the resource to Puppet. In a resource declaration, the title is the identifier        after the first curly brace and before the colon. For example, in this file resource        declaration, the title is `/etc/passwd`: 

```
file  { '/etc/passwd':
  owner => 'root',
  group => 'root',
}Copied!
```

Titles must be unique per resource type. You can have both a package and a service titled        "ntp," but you can only have one service titled "ntp." Duplicate titles cause compilation to        fail.

The title of a resource differs from the namevar of the resource. Whereas the        title identifies the resource to Puppet itself, the namevar        identifies the resource to the target system and is usually specified by the resource's          `name` attribute. The resource title doesn't have to match the namevar, but        you'll often want it to: the value of the namevar attribute defaults to the title, so using        the name in the title can save you some typing. 

If a resource type has multiple namevars, the type specifies whether and how the title maps        to those namevars. For example, the `package` type uses the          `provider` attribute to help determine uniqueness, but that attribute has        no special relationship with the title. See each type's documentation for details about how        it maps title to namevars.

## Attributes

Attributes describe the desired state of the resource; each attribute handles some aspect        of the resource. For example, the `file` type has a `mode`        attribute that specifies the permissions for the file.

Each resource type has its own set of available attributes; see the resource type reference for a complete list. Most        resource types have a handful of crucial attributes and a larger number of optional ones.        Attributes accept certain data types, such as strings, numbers, hashes, or arrays. Each        attribute that you declare must have a value. Most attributes are optional, which means they        have a default value, so you do not have to assign a value. If an attribute has no default,        it is considered required, and you must assign it a value. 

Most resource types contain an `ensure` attribute. This attribute generally        manages the most basic state of the resource on the target system, such as whether a file        exists, whether a service is running or stopped, or whether a package is installed or        uninstalled. The values accepted for the `ensure` attribute vary by resource        type. Most accept `present` and `absent`, but there are        variations. Check the reference for each resource type you are working with.

Tip:  Resource and type attributes are sometimes referred to as parameters. Puppet also has properties, which are slightly different from          parameters: properties correspond to something measurable on the target system, whereas          parameters change how Puppet manages a resource. A property          always represents a concrete state on the target system. When talking about resource          declarations in Puppet, parameter is a synonym for          attribute.

## Namevars and `name`      

Every resource on a target system must have a unique identity; you cannot        have two services, for example, with the same name. This identifying attribute in Puppet is known as the namevar. 

Each resource type has an attribute that is designated to serve as the namevar. For most        resource types, this is the `name` attribute, but some types use other        attributes, such as the `file` type, which uses `path`, the        file's location on disk, for its namevar. If a type's namevar is an attribute other than          `name`, this is listed in the type reference        documentation.

Most types have only one namevar. With a single namevar, the value must be unique per        resource type. There are a few rare exceptions to this rule, such as the          `exec` type, where the namevar is a command. However, some resource types,        such as `package`, have multiple namevar attributes that create a composite        namevar. For example, both the `yum` provider and the `gem`        provider have `mysql` packages, so both the `name` and the          `command` attributes are namevars, and Puppet uses both to identify the resource.

The namevar differs from the resource's title, which identifies a resource to          Puppet's compiler rather than to the target system. In        practice, however, a resource's namevar and the title are often the same, because the        namevar usually defaults to the title. If you don't specify a value for a resource's namevar        when you declare the resource, Puppet uses the resource's        title. 

You might want to specify different a namevar that is different from the title when you        want a consistently titled resource to manage something that has different names on        different platforms. For example, the NTP service might be `ntpd` on Red Hat systems, but `ntp` on Debian and Ubuntu. You might        title the service "ntp," but set its namevar --- the `name` attribute ---        according to the operating system. Other resources can then form relationships to the        resource without the title changing.

## Metaparameters

Some attributes in Puppet can be used with every resource        type. These are called metaparameters. These don't map directly to system        state. Instead, metaparameters affect Puppet's behavior,        usually specifying the way in which resources relate to each other. 

The most commonly used metaparameters are for specifying order relationships between        resources. See the documentation on [relationships and           ordering](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships) for details about those metaparameters. See the full list of available        metaparameters in the [metaparameter reference](https://www.puppet.com/docs/puppet/7/metaparameter.html). 

## Resource syntax

You can accomplish a lot with just a few resource    declaration features, or you can create more complex declarations that do more.

### Basic syntax

The simplified form of a resource declaration includes: 

- The resource type, which is a lowercase word with no quotes, such as                `file`.
- An opening curly brace `{`. 
- The title, which is a string.
- A colon (`:`). 
- Optionally, any number of attribute and value pairs, each of which consists of:
  -  An attribute name, which is a lowercase word with no quotes.
  - A `=>` (called an arrow, "fat comma," or "hash rocket"). 
  - A value, which can have any [data type][datatype].
  - A trailing comma.
-  A closing curly brace (`}`). 

You can use any amount of whitespace in the Puppet        language. 

This example declares a file resource with the title `/etc/passwd`. This        declaration's `ensure` attribute ensures that the specified file is created,        if it does not already exist on the node. The rest of the declaration sets values for the        file's `owner`, `group`, and `mode` attributes.        

```
file { '/etc/passwd':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}Copied!
```

### Complete syntax

By creating more complex resource declarations, you can: 

- Describe many resources at once.
- Set a group of attributes from a hash with the `*` attribute. 
- Set default attributes.
- Specify an abstract resource type.
- Amend or override attributes after a resource is already declared.

The complete generalized form of a resource declaration expression is: 

- The resource type, which can be one of:
  - A lowercase word with no quotes, such as `file`.
  -  A resource type data type, such as `File`,                    `Resource[File]`, or `Resource['file']`. It must                  have a type but not a resource reference.
- An opening curly brace (`{`).
- One or more resource bodies, separated with semicolons (`;`). Each              resource body consists of: 
  - A title, which can be one of: 
    - A string.
    -  An array of strings, which declares multiple resources. 
    - The special value `default`, which sets default attribute                      values for other resource bodies in the same expression. 
  - A colon (`:`). 
  - Optionally, any number of attribute and value pairs, separated with commas                    (`,`). Each attribute/value pair consists of: 
    - An attribute name, which can be one of: 
      - A lowercase word with no quotes. 
      - The special attribute `*`, called a "splat," which takes a                          hash and sets other attributes. 
      - A `=>`, called an arrow, a "fat comma," or a "hash                          rocket". 
      - A value, which can have any data type. 
    - Optionally, a trailing comma after the last attribute/value pair.
- Optionally, a trailing semicolon after the last resource body.
- A closing curly brace (`}`)

```
<TYPE> 
      { default: * => <HASH OF ATTRIBUTE/VALUE PAIRS>, <ATTRIBUTE> => <VALUE>, ; 
                      '<TITLE>': * => <HASH OF ATTRIBUTE/VALUE PAIRS>, <ATTRIBUTE> => <VALUE>, ; 
                      '<NEXT TITLE>': ... ; 
                      ['<TITLE'>, '<TITLE>', '<TITLE>']: ... ; 
      } Copied!
```

### Resource declaration default attributes

If a resource declaration includes a resource body with a title of        `default`, Puppet doesn't create a new        resource named "default." Instead, every other resource in that declaration uses attribute        values from the `default` body if it doesn't have an explicit value for one        of those attributes. This is also known as "per-expression defaults."

Resource declaration defaults are useful because it lets you set many attributes at once,        but you can still override some of them.

This example declares several different files, all using the default values set in the          `default` resource body. However, the `mode` value for the        the files in the last array (`['ssh_config', 'ssh_host_dsa_key.pub'....`) is        set explicitly instead of using the default. 

```
file {
  default:
    ensure => file,
    owner  => "root",
    group  => "wheel",
    mode   => "0600",
  ;
  ['ssh_host_dsa_key', 'ssh_host_key', 'ssh_host_rsa_key']:
    # use all defaults
  ;
  ['ssh_config', 'ssh_host_dsa_key.pub', 'ssh_host_key.pub', 'ssh_host_rsa_key.pub', 'sshd_config']:
    # override mode
    mode => "0644",
  ;
}Copied!
```

The position of the `default` body in a resource declaration doesn't matter;        resources above and below it all use the default attributes if applicable.You can only have        one `default` resource body per resource declaration.

### Setting attributes from a hash

You can set attributes for a resource by using the splat attribute, which uses the splat or        asterisk character `*`, in the resource body.

The value of the splat (`*`) attribute must be a hash where: 

- Each key is the name of a valid attribute for that resource type, as a string.
- Each value is a valid value for the attribute it's assigned to.

This sets values for that resource's attributes, using every attribute and value listed        in the hash. 

For example, the splat attribute in this declaration sets the `owner`,          `group`, and `mode` settings for the file        resource.

```
$file_ownership = {
  "owner" => "root",
  "group" => "wheel",
  "mode"  => "0644",
}

file { "/etc/passwd":
  ensure => file,
  *      => $file_ownership,
}Copied!
```

You cannot set any attribute more than once for a given resource; if you try, Puppet raises a compilation error. This means that: 

- If you use a hash to set attributes for a resource, you cannot set a different,              explicit value for any of those attributes. For example, if ` mode` is              present in the hash, you can't also set `mode => "0644"` in that              resource body.
- You can't use the `*` attribute multiple times in one resource body,              since the splat itself is an attribute.

To use some attributes from a hash and override others, either use a hash to set        per-expression defaults, as described in the **Resource declaration default attributes**        section (above), or use the merging operator, `+` to combine attributes from        two hashes, with the right-hand hash overriding the left-hand one.

### Abstract resource types

Because a resource declaration can accept a resource type data type as its resource type ,        you can use a `Resource[<TYPE>]` value to specify a non-literal        resource type, where the `<TYPE>` portion can be read from a variable.        That is, the following three examples are equivalent to each other: 

```
file { "/tmp/foo": ensure => file, } 
File { "/tmp/foo": ensure => file, } 
Resource[File] { "/tmp/foo": ensure => file, }Copied!
$mytype = File
Resource[$mytype] { "/tmp/foo": ensure => file, }Copied!
$mytypename = "file"
Resource[$mytypename] { "/tmp/foo": ensure => file, }Copied!
```

This lets you declare        resources without knowing in advance what type of resources they'll be, which can enable        transformations of data into resources.

### Arrays of titles

If you specify an array of strings as the title of a resource body, Puppet creates multiple resources with the same set of        attributes. This is useful when you have many resources that are nearly identical.

For example: 

```
$rc_dirs = [
  '/etc/rc.d',       '/etc/rc.d/init.d','/etc/rc.d/rc0.d',
  '/etc/rc.d/rc1.d', '/etc/rc.d/rc2.d', '/etc/rc.d/rc3.d',
  '/etc/rc.d/rc4.d', '/etc/rc.d/rc5.d', '/etc/rc.d/rc6.d',
]

file { $rc_dirs:
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}Copied!
```

If you do this, you must let the namevar attributes of these resources default to        their titles. You can't specify an explicit value for the namevar, because it applies to all        of the resources. 

### Adding or modifying attributes

Although you cannot declare the same resource twice, you can add attributes to a resource        that has already been declared. In certain circumstances, you can also override attributes.        You can amend attributes with either a resource reference, a collector, or from a hash using        the splat (`*`) attribute.

To amend attributes with the splat attribute, see the **Setting attributes from a hash**        section (above).

To amend attributes with a resource reference, add a resource reference attribute block to        the resource that's already declared. Normally, you can only use resource reference blocks        to add previously unmanaged attributes to a resource; it cannot override already-specified        attributes. The general form of a resource reference attribute block is: 

- A resource reference to the resource in question
- An opening curly brace
- Any number of attribute `=>` value pairs
- A closing curly brace

For example, this resource reference attribute block amends values for the          `owner`, `group`, and `mode` attributes:        

```
file {'/etc/passwd':
  ensure => file,
}

File['/etc/passwd'] {
  owner => 'root',
  group => 'root',
  mode  => '0640',
}Copied!
```

You can also amend attributes with a collector.

The general form of a collector attribute block is:

- A [resource collector](https://www.puppet.com/docs/puppet/7/lang_collectors.html) that              matches any number of resources
- An opening curly brace
- Any number of attribute => value (or attribute +> value) pairs
- A closing curly brace

 For resource attributes that accept multiple values in an array, such as the        relationship metaparameters, you can add to the existing values instead of replacing them by        using the "plusignment" (`+>`) keyword instead of the usual hash rocket          (`=>`). For details, see appending to attributes in the [classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes) documentation.

This example amends the `owner`, `group`, and          `mode` attributes of any resources that match the        collector:

```
class base::linux { 
  file {'/etc/passwd':
    ensure => file,
  } 
  ...}

include base::linux

File <| tag == 'base::linux' |> {
 owner => 'root',
 group => 'root',
 mode => '0640',
}Copied!
```

CAUTION:  Be very careful when amending attributes with a collector. Test with            `--noop` to see what changes your code would make. 

- It can override other attributes you've already specified, regardless of class                inheritance.
- It can affect large numbers of resources at one time.
- It implicitly realizes any virtual resources the collector matches.
- Because it ignores class inheritance, it can override the same attribute more than                one time, which results in an evaluation order race where the last override                wins.

### Local resource defaults

Because resource default statements are subject to dynamic scope, you can't always tell        what areas of code will be affected. Generally, do not include classic resource default        statements anywhere other than in your site manifest (`site.pp`). See the          [resource defaults documentation](https://www.puppet.com/docs/puppet/7/lang_defaults.html) for        details. Whenever possible, use resource declaration defaults, also known as per-expression        defaults.

However, resource default statements can be powerful, allowing you to set important        defaults, such as file permissions, across resources. Setting local resource defaults is a        way to protect your classes and defined types from accidentally inheriting defaults from        classic resource default statements. 

To set local resource defaults, define your defaults in a variable and re-use them in        multiple places, by combining resource declaration defaults and setting attributes from a        hash.

This example defines defaults in a `$file_defaults` variable, and then        includes the variable in a resource declaration default with a hash.        

```
class mymodule::params {
  $file_defaults = {
    mode  => "0644",
    owner => "root",
    group => "root",
  }
  # ...
}

class mymodule inherits mymodule::params {
  file { default: *=> $mymodule::params::file_defaults;
    "/etc/myconfig":
      ensure => file,
    ;
  }
}
```

# Resource types

Every resource (file, user, service, package, and so on)        is associated with a resource type within the Puppet        language. The resource type defines the kind of configuration it manages. This section        provides information about the resource types that are built into Puppet. 



**[Resource Type Reference (Single-Page)](https://www.puppet.com/docs/puppet/7/type.html)**
  **[Built-in types](https://www.puppet.com/docs/puppet/7/cheatsheet_core_types.html#cheatsheet_core_types)**
This page provides a reference guide for Puppet's         built-in types: `package`, `file`, `service`,             `notify`, `exec`, `user`, and             `group`.  **[Optional resource types for Windows](https://www.puppet.com/docs/puppet/7/resources_windows_optional.html)**
In addition to the resource types included with Puppet, you can install custom resource types as modules       from the Forge. This is especially useful when managing          Windows systems, because there are several important Windows-specific resource types that are developed as modules       rather than as part of core Puppet.  **[Resource Type: exec](https://www.puppet.com/docs/puppet/7/types/exec.html)**
  **[Using exec on Windows](https://www.puppet.com/docs/puppet/7/resources_exec_windows.html)**
     Puppet uses the same `exec` resource type on both *nix and       Windows systems, and there are a few Windows-specific best practices and tips to keep in     mind. **[Resource Type: file](https://www.puppet.com/docs/puppet/7/types/file.html)**
  **[Using file on Windows](https://www.puppet.com/docs/puppet/7/resources_file_windows.html)**
Use Puppet's          built-in `file` resource type to manage files and directories on Windows, including ownership, group, permissions, and content,       with the following Windows-specific notes and       tips.  **[Resource Type: filebucket](https://www.puppet.com/docs/puppet/7/types/filebucket.html)**
  **[Resource Type: group](https://www.puppet.com/docs/puppet/7/types/group.html)**
  **[Using user and group on Windows](https://www.puppet.com/docs/puppet/7/resources_user_group_windows.html)**
Use the built-in `user` and `group` resource types to manage user and group accounts on Windows. **[Resource types overview](https://www.puppet.com/docs/puppet/7/types/overview.html)**
  **[Resource Type: notify](https://www.puppet.com/docs/puppet/7/types/notify.html)**
  **[Resource Type: package](https://www.puppet.com/docs/puppet/7/types/package.html)**
  **[Using package on Windows](https://www.puppet.com/docs/puppet/7/resources_package_windows.html#resources_package_windows)**
The built-in `package` resource type handles many different packaging systems on many      operating systems, so not all features are relevant everywhere. This  page offers guidance and     tips for working with `package` on Windows. **[Resource Type: resources](https://www.puppet.com/docs/puppet/7/types/resources.html)**
  **[Resource Type: schedule](https://www.puppet.com/docs/puppet/7/types/schedule.html)**
  **[Resource Type: service](https://www.puppet.com/docs/puppet/7/types/service.html)**
  **[Using service](https://www.puppet.com/docs/puppet/7/resources_service.html#resources_service)**
Puppet can manage services on nearly all         operating systems.This page  offers operating system-specific advice and best practices for          working with `service`. **[Resource Type: stage](https://www.puppet.com/docs/puppet/7/types/stage.html)**
  **[Resource Type: tidy](https://www.puppet.com/docs/puppet/7/types/tidy.html)**
  **[Resource Type: user](https://www.puppet.com/docs/puppet/7/types/user.html)**