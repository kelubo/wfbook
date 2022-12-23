# Puppet code

# Using Puppet code

Define the desired state of your infrastructure using Puppet code. 

Puppet code is stored in modules. If you are new to                Puppet or want to save time, use the pre-built and tested modules on the [Puppet                     Forge](https://forge.puppet.com/) — a repository of thousands of modules made by Puppet developers and the Puppet community. 

Modules manage specific tasks in your infrastructure, such as installing                and configuring a piece of software. Modules contain both code and data. The data is                what allows you to customize your configuration. Using a tool called Hiera, you can separate the data from the code and                place it in a centralized location. This allows you to specify guardrails and define                known parameters and variations, so that your code is fully testable and you can                validate all the edge cases of your parameters.

If you are an advanced user and want to write your own Puppet code, refer to the                Puppet language and modules documentation. 

- **[Classifying nodes](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers)**
  You can classify nodes using an external node classifier (ENC), which is a script or         application that tells Puppet which classes a node must have.         It can replace or work in  concert with the node definitions in the main site manifest             (`site.pp`).
- **[Using content from Puppet Forge](https://www.puppet.com/docs/puppet/7/puppet_forge.html)**
  Puppet Forge is a collection of modules and how-to guides developed by             Puppet and its community. 
- **[Designing system configs (roles and profiles)](https://www.puppet.com/docs/puppet/7/designing_system_configs_roles_and_profiles.html)**
  Your typical goal with Puppet is to build complete system configurations, which manage all of the  software, services,         and configuration that you care about on a  given system. The roles and profiles method can         help keep  complexity under control and make your code more reusable,  reconfigurable, and         refactorable.
- **[Separating data (Hiera)](https://www.puppet.com/docs/puppet/7/hiera.html)**
           Hiera is a built-in key-value configuration data lookup         system, used for separating data from Puppet code. 
- **[Use case examples](https://www.puppet.com/docs/puppet/7/quick_start_essential_config.html)**
  Try out some common configuration tasks to see how you can use Puppet to manage your IT infrastructure. 

**Related information**

- [The Puppet language](https://www.puppet.com/docs/puppet/7/puppet_language.html)
- [Modules](https://www.puppet.com/docs/puppet/7/modules.html)

# Classifying nodes

### Sections

[External node classifiers](https://www.puppet.com/docs/puppet/7/nodes_external.html#external-node-classifiers)

[Merging classes from multiple sources](https://www.puppet.com/docs/puppet/7/nodes_external.html#merging-classes)

[Comparing ENCs and node definitions](https://www.puppet.com/docs/puppet/7/nodes_external.html#comparing_encs_and_node_definitions)

[Connect an ENC](https://www.puppet.com/docs/puppet/7/nodes_external.html#connect_a_new_enc)

[ENC output format](https://www.puppet.com/docs/puppet/7/nodes_external.html#enc_output_format)

- [Classes](https://www.puppet.com/docs/puppet/7/nodes_external.html#section_tvc_jlm_thb)
- [Parameters](https://www.puppet.com/docs/puppet/7/nodes_external.html#section_rbt_2vm_thb)
- [Environment](https://www.puppet.com/docs/puppet/7/nodes_external.html#section_bkt_3vm_thb)
- [Complete example](https://www.puppet.com/docs/puppet/7/nodes_external.html#section_oxs_qvm_thb)

You can classify nodes using an external node classifier (ENC), which is a script or        application that tells Puppet which classes a node must have.        It can replace or work in concert with the node definitions in the main site manifest            (`site.pp`).

The `external_nodes` script receives the name of the node            to classify as its first argument, which is usually the node's fully qualified domain            name. For more information, see the [configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html#external_nodes).

Depending on the external data sources you use in your infrastructure, building an            external node classifier can be a valuable way to extend Puppet.

Note: You can use an ENC instead of or in combination with [node definitions](https://www.puppet.com/docs/puppet/7/lang_node_definitions.html).

## External node classifiers

An external node classifier is an executable that Puppet Server or `puppet apply` can call; it                doesn’t have to be written in Ruby. Its only argument is the name of the node to be                classified, and it returns a YAML document describing the node.

Inside the ENC, you can reference any data source you want, including [PuppetDB](https://puppet.com/docs/puppetdb/latest/index.html). From Puppet’s perspective, the                ENC submits a node name and gets back a hash of information. 

External node classifiers can co-exist with standard node definitions in                    `site.pp`; the classes declared in each source are merged                together.

## Merging classes from multiple sources

Every node always gets a node object from the configured node terminus. The node                object might be empty, or it might contain classes, parameters, and an environment.                The [node terminus                     setting](https://www.puppet.com/docs/puppet/7/configuration.html), `node_terminus`, takes effect where the catalog                is compiled, on Puppet Server when using an agent-server                configuration, and on the node itself when using `puppet apply`. The                default node terminus is `plain`, which returns an empty node object,                leaving node configuration to the main manifest.                The `exec` terminus calls an ENC script to determine what                goes in the node object. Every node might also get a  [node definition](https://www.puppet.com/docs/puppet/7/lang_node_definitions.html) from                    the [main manifest](https://www.puppet.com/docs/puppet/7/dirs_manifest.html). 

When compiling a node's catalog, Puppet includes all                of the following: 

- Classes specified in the node object it received from the node                            terminus.
- Classes or resources that are in the site manifest but outside any node                            definitions.
- Classes or resources in the most specific node definition in                                `site.pp` that matches the current node (if                                `site.pp` contains any node definitions). The                            following notes apply:
  - If `site.pp` contains at least one node                                    definition, it must have a node definition that matches the                                    current node; compilation fails if a match can’t be found. 
  - If the node name resembles a dot-separated fully qualified domain                                    name, Puppet makes multiple                                    attempts to match a node definition, removing the right-most                                    part of the name each time. Thus, Puppet would first try                                        `agent1.example.com`, then                                        `agent1.example`, then                                        `agent1`. This behavior isn’t mimicked when                                    calling an ENC, which is invoked only once with the agent’s full                                    node name.
  - If no matching node definition can be found with the node’s name,                                        Puppet tries one last time                                    with a node name of `default`; most users include                                    a `node default {}` statement in their                                        `site.pp` file. This behavior isn’t mimicked                                    when calling an ENC.

## Comparing ENCs and node definitions

If you're trying to decide whether to use an ENC or main        manifest node definitions (or both), consider the following:

- The YAML returned by an ENC isn’t an                        exact equivalent of a node definition in `site.pp` — it can’t declare individual resources,                        declare relationships, or do conditional logic. An ENC can only declare                        classes, assign top-scope variables, and set an environment. So, an ENC is                        most effective if you’ve done a good job of separating your configurations                        out into classes and modules. 
- ENCs can set an environment for a                        node, overriding whatever environment the node requested. 
- Unlike regular node definitions, where                        a node can match a less specific definition if an exactly matching                        definition isn’t found (depending on Puppet’s `strict_hostname_checking` setting), an ENC is                        called only once, with the node’s full name.

## Connect an ENC

Configure two settings to have Puppet Server connect to an external node classifier. 

In the primary server's `puppet.conf` file:

1. ​                 Set the `node_terminus` setting to `exec`.             
2. ​                Set the `external_nodes` setting to the path to the ENC executable.            

Results

For            example:

```
[server]
  node_terminus = exec
  external_nodes = /usr/local/bin/puppet_node_classifierCopied!
```

## ENC output format

An ENC must return either nothing or a YAML hash to        standard out. The hash must contain at least one of `classes` or `parameters`, or it        can contain both. It can also optionally contain an `environment` key.

ENCs exit with an exit code of 0 when functioning normally, and                can exit with a non-zero exit code if you want Puppet                to behave as though the requested node was not found.

If an                ENC returns nothing or exits with a non-zero exit code, the catalog compilation                fails with a “could not find node” error, and the node is unable to retrieve                configurations.

For information about the YAML format, see                    [yaml.org](https://yaml.org). 

### Classes

If present, the value of `classes` must be either an array of class names or a hash whose keys                are class names. That is, the following are                equivalent:

```
classes:
  - common
  - puppet
  - dns
  - ntp

classes:
  common:
  puppet:
  dns:
  ntp:Copied!
```

If you're specifying parameterized classes, use the hash key                syntax, not the array syntax. The value for a parameterized class is a hash of the                class’s parameters and values. Each value can be a string, number, array, or hash.                Put string values in quotation marks, because YAML parsers sometimes treat certain                unquoted strings (such as `on`) as                Booleans. Non-parameterized classes can have empty                values.

```
classes:
    common:
    puppet:
    ntp:
        ntpserver: 0.pool.ntp.org
    aptsetup:
        additional_apt_repos:
            - deb localrepo.example.com/ubuntu lucid production
            - deb localrepo.example.com/ubuntu lucid vendorCopied!
```

### Parameters

If present, the value of the `parameters` key must be a hash of valid variable names and associated                values; these are exposed to the compiler as top-scope variables. Each value can be                a string, number, array, or                hash.

```
parameters:
    ntp_servers:
        - 0.pool.ntp.org
        - ntp.example.com
    mail_server: mail.example.com
    iburst: trueCopied!
```

### Environment

If present, the value of `environment` must be a string representing the desired environment for this node. This is the only environment used by the node                in its requests for catalogs and                files.

```
environment: productionCopied!
```

### Complete example

```
---
classes:
    common:
    puppet:
    ntp:
        ntpserver: 0.pool.ntp.org
    aptsetup:
        additional_apt_repos:
            - deb localrepo.example.com/ubuntu lucid production
            - deb localrepo.example.com/ubuntu lucid vendor
parameters:
    ntp_servers:
        - 0.pool.ntp.org
        - ntp.example.com
    mail_server: mail.example.com
    iburst: true
environment: production
```

# Using content from Puppet Forge

Puppet Forge is a collection of modules and how-to guides developed by            Puppet and its community. 

Modules manage a specific technology in your infrastructure and                serve as the basic building blocks of Puppet desired                state management. On the Puppet                Forge, there is a module to manage almost any part of                your infrastructure. Whether you want to manage packages or patch operating systems,                a module is already set up for you. See each module’s README for installation                instructions, usage, and code examples. 

When using an existing module from the Forge, most of the Puppet code is written for you. You just need to                install the module and its dependencies and write a small amount of code (known as a                profile) to tie things together. Take a look at our [Getting started with PE guide](https://puppet.com/docs/pe/latest/getting_started_pe_overview.html) to                see an example of writing a profile for an existing module. For more information                about existing modules, see the [module fundamentals documentation](https://puppet.com/docs/puppet/latest/modules_fundamentals.html)                and [Puppet                         Forge](https://forge.puppet.com/). 

# Designing system configs (roles and profiles)

Your typical goal with Puppet is to build complete system configurations, which manage all of the software, services,        and configuration that you care about on a given system. The roles and profiles method can        help keep complexity under control and make your code more reusable, reconfigurable, and        refactorable.

**[The roles and profiles method](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#the_roles_and_profiles_method)**
The *roles and profiles*         method is the most reliable way to build reusable, configurable, and refactorable system         configurations.  **[Roles and profiles example](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#roles_and_profiles_example)**
This example demonstrates a complete roles and profiles         workflow.  Use it to understand the roles and profiles method as a whole.  Additional examples         show how to design advanced configurations  by refactoring this example code to a higher         level of  complexity. **[Designing advanced profiles](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#designing_advanced_profiles)**
In this advanced example, we iteratively refactor our basic     roles and  profiles example to handle real-world concerns. The final result is —  with only minor     differences — the Jenkins profile we use in  production here at Puppet. **[Designing convenient roles](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#designing_convenient_roles)**
There are several approaches to building roles, and you must     decide which ones are most convenient for you and your team.

# The roles and profiles method 

### Sections

[Building configurations without roles and profiles                 ](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#building_configurations_without_roles_and_profiles)

[Configuring roles and profiles ](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#configuring_roles_and_profiles)

[Rules for profile classes ](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_profile_classes)

[Rules for role classes ](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_role_classes)

[Methods for data lookup ](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#methods_for_data_lookup)

The *roles and profiles*        method is the most reliable way to build reusable, configurable, and refactorable system        configurations. 

It's not a straightforward recipe: you must think hard about the            nature of your infrastructure and your team. It's also not a final state: expect to            refine your configurations over time. Instead, it's an approach to *designing your infrastructure's interface* — sealing away incidental            complexity, surfacing the significant complexity, and making sure your data behaves            predictably.

## Building configurations without roles and profiles                

Without roles and profiles, people typically build                system configurations in their node classifier or main manifest, using Hiera to handle tricky inheritance problems. A                standard approach is to create a group of similar nodes and assign classes to it,                then create child groups with extra classes for nodes that have additional needs.                Another common pattern is to put everything in Hiera,                using a very large hierarchy that reflects every variation in the                infrastructure.

If this works for you, then it works! You                might not need roles and profiles. But most people find direct building gets                difficult to understand and maintain over time.

## Configuring roles and profiles 

Roles and profiles are *two      extra layers of indirection* between your node classifier and your component modules. 

The roles and profiles method separates your code into three levels:

- Component modules — Normal modules that manage one particular technology, for example        puppetlabs/apache.
- Profiles — Wrapper classes that use multiple component modules to configure a layered        technology stack.
- Roles — Wrapper classes that use multiple profiles to build a complete system        configuration.

These extra layers of indirection might seem like they add complexity, but they give you a      space to build practical, business-specific interfaces to the configuration you care most      about. A better interface makes hierarchical data easier to use, makes system configurations      easier to read, and makes refactoring easier.

![img](https://www.puppet.com/docs/puppet/7/roles_and_profiles_overview_server.png)

In short, from top to bottom:

- Your node classifier assigns one role class to a group of nodes. The role        manages a whole system configuration, so no other classes are needed. The node classifier        does not configure the role in any way.

- That role class declares some 

  profile

   classes with 

  ```
  include
  ```

  ,        and does nothing else. For example:        

  ```
    class role::jenkins::controller {
      include profile::base
      include profile::server
      include profile::jenkins::controller
    }           Copied!
  ```

- Each profile configures a layered technology stack, using multiple component modules and        the built-in resource types. (In the diagram, `profile::jenkins::controller`        uses puppet/jenkins, puppetlabs/apt, a home-built backup module, and some          `package` and `file` resources.)
- Profiles can take configuration data from the console, Hiera, or Puppet lookup. (In the diagram, three different        hierarchy levels contribute data.)
- Classes from component modules are always declared via a profile, and never assigned        directly to a node. 
  - If a component class has parameters, you specify them in the profile*;* never use              Hiera or Puppet lookup            to override component class params. 

## Rules for profile classes 

There are rules for writing profile                              classes.

- Make sure you can safely                                                  `include` any profile multiple times —                                                  don't use resource-like declarations on them.

- Profiles can `include`                                                  other profiles.

- Profiles own all the class                                                  parameters for their component classes. If the                                                  profile omits one, that means you definitely want                                                  the default value; the component class shouldn't                                                  use a value from Hiera data. If you need                                                  to set a class parameter that was omitted                                                  previously, refactor the profile.

- There are three ways a                                                  profile can get the information it needs to                                                  configure component classes: 

  - If your business always                                                  uses the same value for a given parameter,                                                  hardcode it.
  - If you can't hardcode it,                                                  try to compute it based on information you already                                                  have.
  - Finally, if you can't                                                  compute it, look it up in your data. To reduce                                                  lookups, identify cases where multiple parameters                                                  can be derived from the answer to a single                                                  question.

  This is a game of                                                  trade-offs. Hardcoded parameters are the easiest                                                  to read, and also the least flexible. Putting                                                  values in your Hiera data is very flexible, but can be very                                                  difficult to read: you might have to look through                                                  a lot of files (or run a lot of lookup commands)                                                  to see what the profile is actually doing. Using                                                  conditional logic to derive a value is a                                                  middle-ground. Aim for the most readable option                                                  you can get away with.

## Rules for role classes 

There are rules for writing role classes.

- The only thing roles should do is declare profile classes                    with 

  ```
  include
  ```

  . Don't declare any                    component classes or normal resources in a role.

  Optionally, roles can use conditional logic to decide which profiles to                        use. 

- Roles should not have any class parameters of their                    own.

- Roles should not set class parameters for any profiles.                    (Those are all handled by data lookup.)

- The name of a role should be based on your business's 

  conversational name

  ​                    for the type of node it manages.

  This means that if you regularly call a                        machine a "Jenkins controller," it makes sense to write a role named                            `role::jenkins::controller`. But if you call it a "web                        server," you shouldn't use a name like `role::nginx` — go                        with something like `role::web` instead.

## Methods for data lookup 

Profiles usually require some amount of configuration, and        they must use data lookup to get it.

This profile uses the automatic class parameter lookup to request            data. 

```
# Example Hiera data
profile::jenkins::jenkins_port: 8000
profile::jenkins::java_dist: jre
profile::jenkins::java_version: '8'
 
# Example manifest
class profile::jenkins (
  Integer $jenkins_port,
  String  $java_dist,
  String  $java_version
) {
# ...Copied!
```

This profile omits the parameters and uses the `lookup`            function:

```
class profile::jenkins {
  $jenkins_port = lookup('profile::jenkins::jenkins_port', {value_type => String, default_value => '9091'})
  $java_dist    = lookup('profile::jenkins::java_dist',    {value_type => String, default_value => 'jdk'})
  $java_version = lookup('profile::jenkins::java_version', {value_type => String, default_value => 'latest'})
  # ...Copied!
```

In general, class parameters are preferable to lookups. They integrate            better with tools like Puppet strings, and they're a            reliable and well-known place to look for configuration. But using `lookup` is a fine approach if you aren't comfortable            with automatic parameter lookup. Some people prefer the full lookup key to be written in            the profile, so they can globally grep for it.

# Roles and profiles example 

### Sections

[Configure Jenkins controller servers with roles and profiles ](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#configure_jenkins_master_servers_with_roles_and_profiles)

- [Set up your prerequisites ](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#set_up_your_prerequisites)
- [Choose component modules ](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#choose_component_modules)
- [Write a profile ](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#write_a_profile)
- [Set data for the profile](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#set-data-for-profile)
- [Write a role](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#write_a_role)
- [Assign the role to nodes](https://www.puppet.com/docs/puppet/7/roles_and_profiles_example.html#assigning_the_role_to_nodes)

This example demonstrates a complete roles and profiles        workflow. Use it to understand the roles and profiles method as a whole. Additional examples        show how to design advanced configurations by refactoring this example code to a higher        level of complexity.

## Configure Jenkins controller servers with roles and profiles 

Jenkins is a continuous integration (CI) application that runs on the JVM. The        Jenkins controller server provides a web front-end, and also runs CI tasks at scheduled        times or in reaction to events. 

In this example, we manage the configuration of Jenkins controller servers.

### Set up your prerequisites 

If you're new to using roles and profiles, do some additional setup before writing any      new code.

1. Create two modules: one named `role`, and one named `profile`.

   If you deploy your code with Code Manager or r10k, put                  these two modules in your control repository instead of declaring them in your                  Puppetfile, because Code Manager and r10k reserve the `modules` directory for their own use. 

   1. Make a new directory in the repo named `site`. 
   2. Edit the `environment.conf` file to add                           `site` to the `modulepath`. (For example:                           `modulepath = site:modules:$basemodulepath`). 
   3. Put the `role` and `profile` modules in the                           `site` directory. 

2. ​            Make sure Hiera or Puppet lookup is set up and working, with a hierarchy               that works well for you.         

### Choose component modules 

For our example, we want to manage Jenkins itself using the      `puppet/jenkins` module.

Jenkins requires Java, and the `puppet/jenkins` module can manage it        automatically. But we want finer control over Java, so we're going to disable that. So, we        need a Java module, and `puppetlabs/java` is a good choice.

That's enough to start with. We                                                can refactor and expand when we have those                                                working.

Results

To learn more about these modules, see [puppet/jenkins](https://forge.puppet.com/puppet/jenkins) and [puppetlabs/java](https://forge.puppet.com/puppetlabs/java?_ga=2.126344074.623882382.1502209414-2028041969.1502209414). 

### Write a profile 

From a Puppet perspective, a    profile is just a normal class stored in the `profile` module.

Make a new class called `profile::jenkins::controller`, located at            ...`/profile/manifests/jenkins/controller.pp`, and fill it with Puppet code.

```
# /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
class profile::jenkins::controller (
  String $jenkins_port = '9091',
  String $java_dist    = 'jdk',
  String $java_version = 'latest',
) {

  class { 'jenkins':
    configure_firewall => true,
    install_java       => false,
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }

  class { 'java':
    distribution => $java_dist,
    version      => $java_version,
    before       => Class['jenkins'],
  }
}Copied!
```

This is pretty simple, but is already benefiting us: our interface for            configuring Jenkins has gone from 30 or so parameters on the Jenkins class (and many            more on the Java class) down to three. Notice that we’ve hardcoded the              `configure_firewall` and `install_java` parameters, and            have reused the value of `$jenkins_port` in three places.

**Related information**

- [Rules for profile classes](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_profile_classes)
- [Methods for data lookup](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#methods_for_data_lookup)

### Set data for the profile



Let’s assume the following:

- We use some custom facts: 
  - `group`: The group this node belongs to.                            (This is usually either a department of our business, or a large-scale                            function shared by many nodes.)
  - `stage`: The deployment stage of this node                            (dev, test, or prod).
- We have a five-layer hierarchy: 
  - console_data for data defined in the console.
  - `nodes/%{trusted.certname}` for per-node                            overrides.
  - `groups/%{facts.group}/%{facts.stage}` for                            setting stage-specific data within a group.
  - `groups/%{facts.group}` for setting                            group-specific data.
  - `common` for global fallback data.
- We have a few one-off Jenkins controllers, but most of them belong to the                        `ci` group.
- Our quality engineering department wants controllers in the `ci` group to use the Oracle JDK, but one-off machines                    can just use the platform’s default Java.
- QE also wants their prod controllers to listen on port 80.

Set appropriate values in the data, using either                        Hiera or configuration data in the                    console.

```
# /etc/puppetlabs/code/environments/production/data/nodes/ci-controller01.example.com.yaml
 # --Nothing. We don't need any per-node values right now.

 # /etc/puppetlabs/code/environments/production/data/groups/ci/prod.yaml
 profile::jenkins::controller::jenkins_port: '80'

 # /etc/puppetlabs/code/environments/production/data/groups/ci.yaml
 profile::jenkins::controller::java_dist: 'oracle-jdk8'
 profile::jenkins::controller::java_version: '8u92'

 # /etc/puppetlabs/code/environments/production/data/common.yaml
 # --Nothing. Just use the default parameter values.Copied!
```

### Write a role

To write roles, we consider the machines we’ll be managing  and decide what else they need in addition to that Jenkins profile.

Our Jenkins controllers don’t serve any other purpose. But we have some profiles (code not   shown) that we expect every machine in our fleet to have: 

- `profile::base` must be assigned to every machine, including      workstations. It manages basic policies, and uses some conditional logic to include      OS-specific profiles as needed.
- `profile::server` must be assigned to every machine that      provides a service over the network. It makes sure ops can log into the machine, and      configures things like timekeeping, firewalls, logging, and monitoring.

So a role to manage one of our Jenkins controllers should include those classes as well.

```
class role::jenkins::controller {
  include profile::base
  include profile::server
  include profile::jenkins::controller
}Copied!
```

**Related information**

- [Rules for role classes](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_role_classes)

### Assign the role to nodes

Finally, we assign `role::jenkins::controller` to every node that acts as a Jenkins controller. 

Puppet has several      ways to assign classes to nodes, so use whichever tool you feel best fits your team. Your main      choices are:

- The console node classifier, which lets you group nodes based on their facts and assign        classes to those groups.

- The main manifest which can use node statements or conditional logic to assign        classes.

- Hiera

   or 

  Puppet

   lookup — Use        the 

  ```
  lookup
  ```

   function to do a unique array merge on a special          

  ```
  classes
  ```

   key, and pass the resulting array to the 

  ```
  include
  ```

  ​        function.

  ```
  # /etc/puppetlabs/code/environments/production/manifests/site.pp
  lookup('classes', {merge => unique}).includeCopied!
  ```

To learn more about how to assign custom facts to individual nodes, visit https://puppet.com/docs/puppet/7/fact_overview.html.

​                          [                 Docs                 ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)               ](https://puppet.com/docs)                     [             Open Source Puppet             ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)           ](https://puppet.com/docs/puppet)                [           Using Puppet code                        ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                    ](https://www.puppet.com/docs/puppet/7/using-puppet-code.html)                    [                 Designing system configs (roles and profiles)                                    ![Grey arrow pointing right](https://puppet-docs-herrera.netlify.app/images/breadcrumbs-arrow-right.svg)                                ](https://www.puppet.com/docs/puppet/7/designing_system_configs_roles_and_profiles.html)                          [                 Designing advanced profiles                                ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#designing_advanced_profiles)            

# Designing advanced profiles 

### Sections

[First refactor: Split out Java ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#first_refactor_split_out_java)

- [Diff of first refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-first-refactor)

[Second refactor: Manage the heap ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#second_refactor_manage_the_heap)

- [Diff of second refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-second-refactor)

[Third refactor: Pin the version ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#third_refactor_pin_the_version)

- [Diff of third refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-third-refactor)

[Fourth refactor: Manually manage the user account ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#fourth_refactor_manually_manage_the_user_account)

- [Diff of fourth refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-fourth-refactor)

[Fifth refactor: Manage more dependencies ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#fifth_refactor_manage_more_dependencies)

- [Diff of fifth refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-fifth-refactor)

[Sixth refactor: Manage logging and backups ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#sixth_refactor_manage_logging_and_backups)

- [Diff of sixth refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-sixth-refactor)

[Seventh refactor: Use a reverse proxy for HTTPS ](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#seventh_refactor_use_a_reverse_proxy_for_https)

- [Diff of seventh refactor](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#diff-seventh-refactor)

[The final profile code](https://www.puppet.com/docs/puppet/7/designing_advanced_profiles.html#the_final_profile_code)

Expand

In this advanced example, we iteratively refactor our basic    roles and profiles example to handle real-world concerns. The final result is — with only minor    differences — the Jenkins profile we use in production here at Puppet.

Along the way, we explain our choices and point out some of the common      trade-offs you encounter as you design your own profiles.

Here's the basic Jenkins profile we're starting with:

```
# /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
class profile::jenkins::controller (
  String $jenkins_port = '9091',
  String $java_dist    = 'jdk',
  String $java_version = 'latest',
) {

  class { 'jenkins':
    configure_firewall => true,
    install_java       => false,
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }

  class { 'java':
    distribution => $java_dist,
    version      => $java_version,
    before       => Class['jenkins'],
  }
}
Copied!
```

**Related information**

- [Rules for profile classes](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_profile_classes)

## First refactor: Split out Java 

We want to manage Jenkins controllers *and* Jenkins agent nodes. We won't cover    agent profiles in detail, but the first issue we encountered is that they also need    Java.

We could copy and paste the Java class declaration; it's small, so keeping multiple copies      up-to-date might not be too burdensome. But instead, we decided to break Java out into a      separate profile. This way we can manage it one time, then include the Java profile in both      the agent and controller profiles.

Note: This is a common trade-off.        Keeping a chunk of code in only one place (often called the DRY — "don't repeat yourself" —        principle) makes it more maintainable and less vulnerable to rot. But it has a cost: your        individual profile classes become less readable, and you must view more files to see what a        profile actually does. To reduce that readability cost, try to break code out in units that        make inherent sense. In this case, the Java profile's job is simple enough to guess by its        name — your colleagues don't have to read its code to know that it manages Java 8. Comments        can also help.

First, decide how configurable Java needs to be on Jenkins machines. After      looking at our past usage, we realized that we use only two options: either we install      Oracle's Java 8 distribution, or we default to OpenJDK 7, which the Jenkins module manages.      This means we can:

- Make our new Java profile really simple: hardcode Java 8 and take no        configuration.
- Replace the two Java parameters from `profile::jenkins::controller` with        one Boolean parameter (whether to let Jenkins handle Java).

Note: This is rule 4 in action. We        reduce our profile's configuration surface by combining multiple questions into      one.

Here's the new parameter list:

```
class profile::jenkins::controller (
  String  $jenkins_port = '9091',
  Boolean $install_jenkins_java = true,
) { # ...Copied!
```

And here's how we choose which Java to use:

```
  class { 'jenkins':
    configure_firewall => true,
    install_java       => $install_jenkins_java,    # <--- here
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }

  # When not using the jenkins module's java version, install java8.
  unless $install_jenkins_java  { include profile::jenkins::usage::java8 }Copied!
```

And our new Java      profile:

```
::jenkins::usage::java8
# Sets up java8 for Jenkins on Debian
#
class profile::jenkins::usage::java8 {
  motd::register { 'Java usage profile (profile::jenkins::usage::java8)': }

  # OpenJDK 7 is already managed by the Jenkins module.
  # ::jenkins::install_java or ::jenkins::agent::install_java should be false to use this profile
  # this can be set through the class parameter $install_jenkins_java
  case $::osfamily {
    'debian': {
      class { 'java':
        distribution => 'oracle-jdk8',
        version      => '8u92',
      }

      package { 'tzdata-java':
        ensure => latest,
      }
    }
    default: {
      notify { "profile::jenkins::usage::java8 cannot set up JDK on ${::osfamily}": }Copied!
```

### Diff of first refactor

```
@@ -1,13 +1,12 @@
 # /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
 class profile::jenkins::controller (
-  String $jenkins_port = '9091',
-  String $java_dist    = 'jdk',
-  String $java_version = 'latest',
+  String  $jenkins_port = '9091',
+  Boolean $install_jenkins_java = true,
 ) {

   class { 'jenkins':
     configure_firewall => true,
-    install_java       => false,
+    install_java       => $install_jenkins_java,
     port               => $jenkins_port,
     config_hash        => {
       'HTTP_PORT'    => { 'value' => $jenkins_port },
@@ -15,9 +14,6 @@ class profile::jenkins::controller (
     },
   }

-  class { 'java':
-    distribution => $java_dist,
-    version      => $java_version,
-    before       => Class['jenkins'],
-  }
+  # When not using the jenkins module's java version, install java8.
+  unless $install_jenkins_java  { include profile::jenkins::usage::java8 }
 }Copied!
```

## Second refactor: Manage the heap 

At Puppet, we manage the Java    heap size for the Jenkins app. Production servers didn't have enough memory for heavy    use.

The Jenkins module has a `jenkins::sysconfig` defined type for managing system properties, so let's use      it:

```
  # Manage the heap size on the controller, in MB.
  if($::memorysize_mb =~ Number and $::memorysize_mb > 8192)
  {
    # anything over 8GB we should keep max 4GB for OS and others
    $heap = sprintf('%.0f', $::memorysize_mb - 4096)
  } else {
    # This is calculated as 50% of the total memory.
    $heap = sprintf('%.0f', $::memorysize_mb * 0.5)
  }
  # Set java params, like heap min and max sizes. See
  # https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
  jenkins::sysconfig { 'JAVA_ARGS':
    value => "-Xms${heap}m -Xmx${heap}m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dhudson.model.DirectoryBrowserSupport.CSP=\\\"default-src 'self'; img-src 'self'; style-src 'self';\\\"",
  }Copied!
```

Note: Rule 4 again — we couldn't hardcode this, because we have some smaller Jenkins        controllers that can't spare the extra memory. But because our production controllers are        always on more powerful machines, we can calculate the heap based on the machine's memory        size, which we can access as a fact. This lets us avoid extra configuration.

### Diff of second refactor

```
@@ -16,4 +16,20 @@ class profile::jenkins::controller (

   # When not using the jenkins module's java version, install java8.
   unless $install_jenkins_java  { include profile::jenkins::usage::java8 }
+
+  # Manage the heap size on the controller, in MB.
+  if($::memorysize_mb =~ Number and $::memorysize_mb > 8192)
+  {
+    # anything over 8GB we should keep max 4GB for OS and others
+    $heap = sprintf('%.0f', $::memorysize_mb - 4096)
+  } else {
+    # This is calculated as 50% of the total memory.
+    $heap = sprintf('%.0f', $::memorysize_mb * 0.5)
+  }
+  # Set java params, like heap min and max sizes. See
+  # https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
+  jenkins::sysconfig { 'JAVA_ARGS':
+    value => "-Xms${heap}m -Xmx${heap}m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dhudson.model.DirectoryBrowserSupport.CSP=\\\"default-src 'self'; img-src 'self'; style-src 'self';\\\"",
+  }
+
 }
Copied!
```

## Third refactor: Pin the version 

We dislike surprise upgrades, so we pin Jenkins to a    specific version. We do this with a direct package URL instead of by adding Jenkins to our    internal package repositories. Your organization might choose to do it differently.

First, we add a parameter to control upgrades. Now we can set a new value      in `.../data/groups/ci/dev.yaml` while leaving        `.../data/groups/ci.yaml` alone — our dev      machines get the new Jenkins version first, and we can ensure everything works as expected      before upgrading our prod machines.

```
class profile::jenkins::controller (
  Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
  # ...
) { # ...Copied!
```

Then, we set the necessary parameters in the Jenkins class:

```
  class { 'jenkins':
    lts                => true,                    # <-- here
    repo               => true,                    # <-- here
    direct_download    => $direct_download,        # <-- here
    version            => 'latest',                # <-- here
    service_enable     => true,
    service_ensure     => running,
    configure_firewall => true,
    install_java       => $install_jenkins_java,
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }Copied!
```

This was a good time to explicitly manage the Jenkins *service,* so we did that as well.

### Diff of third refactor

```
@@ -1,10 +1,17 @@
 # /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
 class profile::jenkins::controller (
-  String  $jenkins_port = '9091',
-  Boolean $install_jenkins_java = true,
+  String                      $jenkins_port = '9091',
+  Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
+  Boolean                     $install_jenkins_java = true,
 ) {

   class { 'jenkins':
+    lts                => true,
+    repo               => true,
+    direct_download    => $direct_download,
+    version            => 'latest',
+    service_enable     => true,
+    service_ensure     => running,
     configure_firewall => true,
     install_java       => $install_jenkins_java,
     port               => $jenkins_port,Copied!
```

## Fourth refactor: Manually manage the user account 

We manage a lot of user accounts in our infrastructure, so    we handle them in a unified way. The `profile::server` class pulls in `virtual::users`, which has a lot of virtual resources we can selectively realize    depending on who needs to log into a given machine.

Note: This has a cost — it's action at a        distance, and you need to read more files to see which users are enabled for a given        profile. But we decided the benefit was worth it: because all user accounts are written in        one or two files, it's easy to see all the users that might exist, and ensure that they're        managed consistently.

We're accepting difficulty in one place (where we          can comfortably handle it) to banish difficulty in another place (where we worry it would          get out of hand). Making this choice required that we know our colleagues and their          comfort zones, and that we know the limitations of our existing code base and supporting          services.

So, for this example, we change the Jenkins profile to work the same way;      we manage the `jenkins` user alongside the rest      of our user accounts. While we're doing that, we also manage a few directories that can be      problematic depending on how Jenkins is packaged.

Some values we need are used by Jenkins agents as well as controllers, so we're going to      store them in a params class, which is a class that sets shared variables and manages no      resources. This is a heavyweight solution, so wait until it provides real value before using      it. In our case, we had a lot of OS-specific agent profiles (not shown in these examples), and      they made a params class worthwhile.

Note: Just as before, "don't repeat        yourself" is in tension with "keep it readable." Find the balance that works for      you.

```
  # We rely on virtual resources that are ultimately declared by profile::server.
  include profile::server

  # Some default values that vary by OS:
  include profile::jenkins::params
  $jenkins_owner          = $profile::jenkins::params::jenkins_owner
  $jenkins_group          = $profile::jenkins::params::jenkins_group
  $controller_config_dir      = $profile::jenkins::params::controller_config_dir

  file { '/var/run/jenkins': ensure => 'directory' }

  # Because our account::user class manages the '${controller_config_dir}' directory
  # as the 'jenkins' user's homedir (as it should), we need to manage
  # `${controller_config_dir}/plugins` here to prevent the upstream
  # rtyler-jenkins module from trying to manage the homedir as the config
  # dir. For more info, see the upstream module's `manifests/plugin.pp`
  # manifest.
  file { "${controller_config_dir}/plugins":
    ensure  => directory,
    owner   => $jenkins_owner,
    group   => $jenkins_group,
    mode    => '0755',
    require => [Group[$jenkins_group], User[$jenkins_owner]],
  }

  Account::User <| tag == 'jenkins' |>

  class { 'jenkins':
    lts                => true,
    repo               => true,
    direct_download    => $direct_download,
    version            => 'latest',
    service_enable     => true,
    service_ensure     => running,
    configure_firewall => true,
    install_java       => $install_jenkins_java,
    manage_user        => false,                    # <-- here
    manage_group       => false,                    # <-- here
    manage_datadirs    => false,                    # <-- here
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }Copied!
```

Three things to notice in the code above:

- We manage users with a homegrown `account::user` defined type, which declares a `user` resource plus a few other things.
- We use an `Account::User` resource collector to realize the Jenkins user. This relies on          `profile::server` being declared.
- We set the Jenkins class's `manage_user`, `manage_group`, and          `manage_datadirs` parameters to false.
- We're now explicitly managing the `plugins` directory and the `run` directory.

### Diff of fourth refactor

```
@@ -5,6 +5,33 @@ class profile::jenkins::controller (
   Boolean                     $install_jenkins_java = true,
 ) {

+  # We rely on virtual resources that are ultimately declared by profile::server.
+  include profile::server
+
+  # Some default values that vary by OS:
+  include profile::jenkins::params
+  $jenkins_owner          = $profile::jenkins::params::jenkins_owner
+  $jenkins_group          = $profile::jenkins::params::jenkins_group
+  $controller_config_dir      = $profile::jenkins::params::controller_config_dir
+
+  file { '/var/run/jenkins': ensure => 'directory' }
+
+  # Because our account::user class manages the '${controller_config_dir}' directory
+  # as the 'jenkins' user's homedir (as it should), we need to manage
+  # `${controller_config_dir}/plugins` here to prevent the upstream
+  # rtyler-jenkins module from trying to manage the homedir as the config
+  # dir. For more info, see the upstream module's `manifests/plugin.pp`
+  # manifest.
+  file { "${controller_config_dir}/plugins":
+    ensure  => directory,
+    owner   => $jenkins_owner,
+    group   => $jenkins_group,
+    mode    => '0755',
+    require => [Group[$jenkins_group], User[$jenkins_owner]],
+  }
+
+  Account::User <| tag == 'jenkins' |>
+
   class { 'jenkins':
     lts                => true,
     repo               => true,
@@ -14,6 +41,9 @@ class profile::jenkins::controller (
     service_ensure     => running,
     configure_firewall => true,
     install_java       => $install_jenkins_java,
+    manage_user        => false,
+    manage_group       => false,
+    manage_datadirs    => false,
     port               => $jenkins_port,
     config_hash        => {
       'HTTP_PORT'    => { 'value' => $jenkins_port },Copied!
```

## Fifth refactor: Manage more dependencies 

Jenkins always needs Git    installed (because we use Git for source control at Puppet), and it needs SSH keys to access private Git repos and run commands on Jenkins agent nodes. We also have a    standard list of Jenkins plugins we use, so we manage those too.

Managing Git is pretty easy:

```
  package { 'git':
    ensure => present,
  }Copied!
```

SSH keys are less easy, because they are sensitive content. We can't check      them into version control with the rest of our Puppet code, so      we put them in a custom mount point on one specific Puppet      server.

Because this server is different from our normal Puppet servers, we made a rule about accessing it: you must look      up the hostname from data instead of hardcoding it. This lets us change it in only one place      if the secure server ever moves.

```
  $secure_server = lookup('puppetlabs::ssl::secure_server')

  file { "${controller_config_dir}/.ssh":
    ensure => directory,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0700',
  }

  file { "${controller_config_dir}/.ssh/id_rsa":
    ensure => file,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0600',
    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins",
  }

  file { "${controller_config_dir}/.ssh/id_rsa.pub":
    ensure => file,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0640',
    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins.pub",
  }Copied!
```

Plugins are also a bit tricky, because we have a few Jenkins controllers where we want to      manually configure plugins. So we put the base list in a separate profile, and use a parameter      to control whether we use it.

```
class profile::jenkins::controller (
  Boolean                     $manage_plugins = false,
  # ...
) {
  # ...
  if $manage_plugins {
    include profile::jenkins::controller::plugins
  }Copied!
```

In the plugins profile, we can use the `jenkins::plugin` resource type provided by the Jenkins module.

```
# /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller/plugins.pp
class profile::jenkins::controller::plugins {
  jenkins::plugin { 'audit2db':          }
  jenkins::plugin { 'credentials':       }
  jenkins::plugin { 'jquery':            }
  jenkins::plugin { 'job-import-plugin': }
  jenkins::plugin { 'ldap':              }
  jenkins::plugin { 'mailer':            }
  jenkins::plugin { 'metadata':          }
  # ... and so on.
}
Copied!
```

### Diff of fifth refactor

```
@@ -1,6 +1,7 @@
 # /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
 class profile::jenkins::controller (
   String                      $jenkins_port = '9091',
+  Boolean                     $manage_plugins = false,
   Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
   Boolean                     $install_jenkins_java = true,
 ) {
@@ -14,6 +15,20 @@ class profile::jenkins::controller (
   $jenkins_group          = $profile::jenkins::params::jenkins_group
   $controller_config_dir      = $profile::jenkins::params::controller_config_dir

+  if $manage_plugins {
+    # About 40 jenkins::plugin resources:
+    include profile::jenkins::controller::plugins
+  }
+
+  # Sensitive info (like SSH keys) isn't checked into version control like the
+  # rest of our modules; instead, it's served from a custom mount point on a
+  # designated server.
+  $secure_server = lookup('puppetlabs::ssl::secure_server')
+
+  package { 'git':
+    ensure => present,
+  }
+
   file { '/var/run/jenkins': ensure => 'directory' }

   # Because our account::user class manages the '${controller_config_dir}' directory
@@ -69,4 +84,29 @@ class profile::jenkins::controller (
     value => "-Xms${heap}m -Xmx${heap}m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dhudson.model.DirectoryBrowserSupport.CSP=\\\"default-src 'self'; img-src 'self'; style-src 'self';\\\"",
   }

+  # Deploy the SSH keys that Jenkins needs to manage its agent machines and
+  # access Git repos.
+  file { "${controller_config_dir}/.ssh":
+    ensure => directory,
+    owner  => $jenkins_owner,
+    group  => $jenkins_group,
+    mode   => '0700',
+  }
+
+  file { "${controller_config_dir}/.ssh/id_rsa":
+    ensure => file,
+    owner  => $jenkins_owner,
+    group  => $jenkins_group,
+    mode   => '0600',
+    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins",
+  }
+
+  file { "${controller_config_dir}/.ssh/id_rsa.pub":
+    ensure => file,
+    owner  => $jenkins_owner,
+    group  => $jenkins_group,
+    mode   => '0640',
+    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins.pub",
+  }
+
 }Copied!
```

## Sixth refactor: Manage logging and backups 

Backing up is usually a good idea. 

We can use our homegrown `backup` module, which provides a `backup::job` resource type (`profile::server` takes care of its prerequisites). But we should make backups      optional, so people don't accidentally post junk to our backup server if they're setting up an      ephemeral Jenkins instance to test something.

```
class profile::jenkins::controller (
  Boolean                     $backups_enabled = false,
  # ...
) {
  # ...
  if $backups_enabled {
    backup::job { "jenkins-data-${::hostname}":
      files => $controller_config_dir,
    }
  }
}Copied!
```

Also, our teams gave us some conflicting requests for Jenkins logs:

- Some people want it to use syslog, like most other services.
- Others want a distinct log file so syslog doesn't get spammed, and        they want the file to rotate more quickly than it does by default.

That implies a new parameter. We can make one called `$jenkins_logs_to_syslog` and default it to `undef`. If you set it to a standard syslog facility (like        `daemon.info`), Jenkins logs there instead of      its own file.

We use `jenkins::sysconfig`      and our homegrown `logrotate::job` to do the      work:

```
class profile::jenkins::controller (
  Optional[String[1]]         $jenkins_logs_to_syslog = undef,
  # ...
) {
  # ...
  if $jenkins_logs_to_syslog {
    jenkins::sysconfig { 'JENKINS_LOG':
      value => "$jenkins_logs_to_syslog",
    }
  }
  # ...
  logrotate::job { 'jenkins':
    log     => '/var/log/jenkins/jenkins.log',
    options => [
      'daily',
      'copytruncate',
      'missingok',
      'rotate 7',
      'compress',
      'delaycompress',
      'notifempty'
    ],
  }
}Copied!
```

### Diff of sixth refactor

```
@@ -1,8 +1,10 @@
 # /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
 class profile::jenkins::controller (
   String                      $jenkins_port = '9091',
+  Boolean                     $backups_enabled = false,
   Boolean                     $manage_plugins = false,
   Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
+  Optional[String[1]]         $jenkins_logs_to_syslog = undef,
   Boolean                     $install_jenkins_java = true,
 ) {

@@ -84,6 +86,15 @@ class profile::jenkins::controller (
     value => "-Xms${heap}m -Xmx${heap}m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dhudson.model.DirectoryBrowserSupport.CSP=\\\"default-src 'self'; img-src 'self'; style-src 'self';\\\"",
   }

+  # Forward jenkins controller logs to syslog.
+  # When set to facility.level the jenkins_log uses that value instead of a
+  # separate log file, for example daemon.info
+  if $jenkins_logs_to_syslog {
+    jenkins::sysconfig { 'JENKINS_LOG':
+      value => "$jenkins_logs_to_syslog",
+    }
+  }
+
   # Deploy the SSH keys that Jenkins needs to manage its agent machines and
   # access Git repos.
   file { "${controller_config_dir}/.ssh":
@@ -109,4 +120,29 @@ class profile::jenkins::controller (
     source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins.pub",
   }

+  # Back up Jenkins' data.
+  if $backups_enabled {
+    backup::job { "jenkins-data-${::hostname}":
+      files => $controller_config_dir,
+    }
+  }
+
+  # (QENG-1829) Logrotate rules:
+  # Jenkins' default logrotate config retains too much data: by default, it
+  # rotates jenkins.log weekly and retains the last 52 weeks of logs.
+  # Considering we almost never look at the logs, let's rotate them daily
+  # and discard after 7 days to reduce disk usage.
+  logrotate::job { 'jenkins':
+    log     => '/var/log/jenkins/jenkins.log',
+    options => [
+      'daily',
+      'copytruncate',
+      'missingok',
+      'rotate 7',
+      'compress',
+      'delaycompress',
+      'notifempty'
+    ],
+  }
+
 }
Copied!
```

## Seventh refactor: Use a reverse proxy for HTTPS 

We want the Jenkins web interface to use HTTPS, which we can    accomplish with an Nginx reverse proxy. We also want to standardize the ports: the Jenkins app    always binds to its default port, and the proxy always serves over 443 for HTTPS and 80 for    HTTP.

If we want to keep vanilla HTTP available, we can provide an `$ssl` parameter. If set to `false` (the default), you can access Jenkins via both HTTP and HTTPS.      We can also add a `$site_alias` parameter, so      the proxy can listen on a hostname other than the node's main FQDN.

```
class profile::jenkins::controller (
  Boolean                     $ssl = false,
  Optional[String[1]]         $site_alias = undef,
  # IMPORTANT: notice that $jenkins_port is removed.
  # ...Copied!
```

Set `configure_firewall =>        false` in the Jenkins class:

```
  class { 'jenkins':
    lts                => true,
    repo               => true,
    direct_download    => $direct_download,
    version            => 'latest',
    service_enable     => true,
    service_ensure     => running,
    configure_firewall => false,                # <-- here
    install_java       => $install_jenkins_java,
    manage_user        => false,
    manage_group       => false,
    manage_datadirs    => false,
    # IMPORTANT: notice that port and config_hash are removed.
  }Copied!
```

We need to deploy SSL certificates where Nginx can reach them. Because we      serve a lot of things over HTTPS, we already had a profile for that:

```
  # Deploy the SSL certificate/chain/key for sites on this domain.
  include profile::ssl::delivery_wildcardCopied!
```

This is also a good time to add some info for the message of the day,      handled by puppetlabs/motd:

```
  motd::register { 'Jenkins CI controller (profile::jenkins::controller)': }

  if $site_alias {
    motd::register { 'jenkins-site-alias':
      content => @("END"),
                 profile::jenkins::controller::proxy

                 Jenkins site alias: ${site_alias}
                 |-END
      order   => 25,
    }
  }Copied!
```

The bulk of the work is handled by a new profile called        `profile::jenkins::controller::proxy`. We're omitting the code for brevity;      in summary, what it does is:

- Include `profile::nginx`.
- Use resource types from the jfryman/nginx to set up a vhost, and to        force a redirect to HTTPS if we haven't enabled vanilla HTTP.
- Set up logstash forwarding for access and error logs.
- Include `profile::fw::https` to manage firewall rules, if necessary.

Then, we declare that profile in our main profile:

```
  class { 'profile::jenkins::controller::proxy':
    site_alias  => $site_alias,
    require_ssl => $ssl,
  }Copied!
```

Important:

We are          now breaking rule 1, the most important rule of the roles and profiles method. Why?

Because `profile::jenkins::controller::proxy` is a "private" profile that belongs          solely to `profile::jenkins::controller`. It will never be declared by any          role or any other profile.

This is the only          exception to rule 1: if you're separating out code *for the            sole purpose of readability* --- that is, if you could paste the private profile's          contents into the main profile for the exact same effect --- you can use a resource-like          declaration on the private profile. This lets you consolidate your data lookups and make          the private profile's inputs more visible, while keeping the main profile a little          cleaner. If you do this, you must make sure to document that the private profile is          private.

If there is any chance that this code might be reused by          another profile, obey rule 1.

### Diff of seventh refactor

```
@@ -1,8 +1,9 @@
 # /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
 class profile::jenkins::controller (
-  String                      $jenkins_port = '9091',
   Boolean                     $backups_enabled = false,
   Boolean                     $manage_plugins = false,
+  Boolean                     $ssl = false,
+  Optional[String[1]]         $site_alias = undef,
   Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
   Optional[String[1]]         $jenkins_logs_to_syslog = undef,
   Boolean                     $install_jenkins_java = true,
@@ -11,6 +12,9 @@ class profile::jenkins::controller (
   # We rely on virtual resources that are ultimately declared by profile::server.
   include profile::server

+  # Deploy the SSL certificate/chain/key for sites on this domain.
+  include profile::ssl::delivery_wildcard
+
   # Some default values that vary by OS:
   include profile::jenkins::params
   $jenkins_owner          = $profile::jenkins::params::jenkins_owner
@@ -22,6 +26,31 @@ class profile::jenkins::controller (
     include profile::jenkins::controller::plugins
   }

+  motd::register { 'Jenkins CI controller (profile::jenkins::controller)': }
+
+  # This adds the site_alias to the message of the day for convenience when
+  # logging into a server via FQDN. Because of the way motd::register works, we
+  # need a sort of funny formatting to put it at the end (order => 25) and to
+  # list a class so there isn't a random "--" at the end of the message.
+  if $site_alias {
+    motd::register { 'jenkins-site-alias':
+      content => @("END"),
+                 profile::jenkins::controller::proxy
+
+                 Jenkins site alias: ${site_alias}
+                 |-END
+      order   => 25,
+    }
+  }
+
+  # This is a "private" profile that sets up an Nginx proxy -- it's only ever
+  # declared in this class, and it would work identically pasted inline.
+  # But because it's long, this class reads more cleanly with it separated out.
+  class { 'profile::jenkins::controller::proxy':
+    site_alias  => $site_alias,
+    require_ssl => $ssl,
+  }
+
   # Sensitive info (like SSH keys) isn't checked into version control like the
   # rest of our modules; instead, it's served from a custom mount point on a
   # designated server.
@@ -56,16 +85,11 @@ class profile::jenkins::controller (
     version            => 'latest',
     service_enable     => true,
     service_ensure     => running,
-    configure_firewall => true,
+    configure_firewall => false,
     install_java       => $install_jenkins_java,
     manage_user        => false,
     manage_group       => false,
     manage_datadirs    => false,
-    port               => $jenkins_port,
-    config_hash        => {
-      'HTTP_PORT'    => { 'value' => $jenkins_port },
-      'JENKINS_PORT' => { 'value' => $jenkins_port },
-    },
   }

   # When not using the jenkins module's java version, install java8.
Copied!
```

## The final profile code

After all of this refactoring (and a few more minor adjustments), here’s the final code    for `profile::jenkins::controller`.

```
# /etc/puppetlabs/code/environments/production/site/profile/manifests/jenkins/controller.pp
# Class: profile::jenkins::controller
#
# Install a Jenkins controller that meets Puppet's internal needs.
#
class profile::jenkins::controller (
  Boolean                     $backups_enabled = false,
  Boolean                     $manage_plugins = false,
  Boolean                     $ssl = false,
  Optional[String[1]]         $site_alias = undef,
  Variant[String[1], Boolean] $direct_download = 'http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.642.2_all.deb',
  Optional[String[1]]         $jenkins_logs_to_syslog = undef,
  Boolean                     $install_jenkins_java = true,
) {

  # We rely on virtual resources that are ultimately declared by profile::server.
  include profile::server

  # Deploy the SSL certificate/chain/key for sites on this domain.
  include profile::ssl::delivery_wildcard

  # Some default values that vary by OS:
  include profile::jenkins::params
  $jenkins_owner          = $profile::jenkins::params::jenkins_owner
  $jenkins_group          = $profile::jenkins::params::jenkins_group
  $controller_config_dir      = $profile::jenkins::params::controller_config_dir

  if $manage_plugins {
    # About 40 jenkins::plugin resources:
    include profile::jenkins::controller::plugins
  }

  motd::register { 'Jenkins CI controller (profile::jenkins::controller)': }

  # This adds the site_alias to the message of the day for convenience when
  # logging into a server via FQDN. Because of the way motd::register works, we
  # need a sort of funny formatting to put it at the end (order => 25) and to
  # list a class so there isn't a random "--" at the end of the message.
  if $site_alias {
    motd::register { 'jenkins-site-alias':
      content => @("END"),
                 profile::jenkins::controller::proxy

                 Jenkins site alias: ${site_alias}
                 |-END
      order   => 25,
    }
  }

  # This is a "private" profile that sets up an Nginx proxy -- it's only ever
  # declared in this class, and it would work identically pasted inline.
  # But because it's long, this class reads more cleanly with it separated out.
  class { 'profile::jenkins::controller::proxy':
    site_alias  => $site_alias,
    require_ssl => $ssl,
  }

  # Sensitive info (like SSH keys) isn't checked into version control like the
  # rest of our modules; instead, it's served from a custom mount point on a
  # designated server.
  $secure_server = lookup('puppetlabs::ssl::secure_server')

  # Dependencies:
  #   - Pull in apt if we're on Debian.
  #   - Pull in the 'git' package, used by Jenkins for Git polling.
  #   - Manage the 'run' directory (fix for busted Jenkins packaging).
  if $::osfamily == 'Debian' { include apt }

  package { 'git':
    ensure => present,
  }

  file { '/var/run/jenkins': ensure => 'directory' }

  # Because our account::user class manages the '${controller_config_dir}' directory
  # as the 'jenkins' user's homedir (as it should), we need to manage
  # `${controller_config_dir}/plugins` here to prevent the upstream
  # rtyler-jenkins module from trying to manage the homedir as the config
  # dir. For more info, see the upstream module's `manifests/plugin.pp`
  # manifest.
  file { "${controller_config_dir}/plugins":
    ensure  => directory,
    owner   => $jenkins_owner,
    group   => $jenkins_group,
    mode    => '0755',
    require => [Group[$jenkins_group], User[$jenkins_owner]],
  }

  Account::User <| tag == 'jenkins' |>

  class { 'jenkins':
    lts                => true,
    repo               => true,
    direct_download    => $direct_download,
    version            => 'latest',
    service_enable     => true,
    service_ensure     => running,
    configure_firewall => false,
    install_java       => $install_jenkins_java,
    manage_user        => false,
    manage_group       => false,
    manage_datadirs    => false,
  }

  # When not using the jenkins module's java version, install java8.
  unless $install_jenkins_java  { include profile::jenkins::usage::java8 }

  # Manage the heap size on the controller, in MB.
  if($::memorysize_mb =~ Number and $::memorysize_mb > 8192)
  {
    # anything over 8GB we should keep max 4GB for OS and others
    $heap = sprintf('%.0f', $::memorysize_mb - 4096)
  } else {
    # This is calculated as 50% of the total memory.
    $heap = sprintf('%.0f', $::memorysize_mb * 0.5)
  }
  # Set java params, like heap min and max sizes. See
  # https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
  jenkins::sysconfig { 'JAVA_ARGS':
    value => "-Xms${heap}m -Xmx${heap}m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dhudson.model.DirectoryBrowserSupport.CSP=\\\"default-src 'self'; img-src 'self'; style-src 'self';\\\"",
  }

  # Forward jenkins controller logs to syslog.
  # When set to facility.level the jenkins_log uses that value instead of a
  # separate log file, for example daemon.info
  if $jenkins_logs_to_syslog {
    jenkins::sysconfig { 'JENKINS_LOG':
      value => "$jenkins_logs_to_syslog",
    }
  }

  # Deploy the SSH keys that Jenkins needs to manage its agent machines and
  # access Git repos.
  file { "${controller_config_dir}/.ssh":
    ensure => directory,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0700',
  }

  file { "${controller_config_dir}/.ssh/id_rsa":
    ensure => file,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0600',
    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins",
  }

  file { "${controller_config_dir}/.ssh/id_rsa.pub":
    ensure => file,
    owner  => $jenkins_owner,
    group  => $jenkins_group,
    mode   => '0640',
    source => "puppet://${secure_server}/secure/delivery/id_rsa-jenkins.pub",
  }

  # Back up Jenkins' data.
  if $backups_enabled {
    backup::job { "jenkins-data-${::hostname}":
      files => $controller_config_dir,
    }
  }

  # (QENG-1829) Logrotate rules:
  # Jenkins' default logrotate config retains too much data: by default, it
  # rotates jenkins.log weekly and retains the last 52 weeks of logs.
  # Considering we almost never look at the logs, let's rotate them daily
  # and discard after 7 days to reduce disk usage.
  logrotate::job { 'jenkins':
    log     => '/var/log/jenkins/jenkins.log',
    options => [
      'daily',
      'copytruncate',
      'missingok',
      'rotate 7',
      'compress',
      'delaycompress',
      'notifempty'
    ],
  }

}
```

# Designing convenient roles 

### Sections

[First approach: Granular roles ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#first_approach_granular_roles)

[Second approach: Conditional logic ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#second_approach_conditional_logic)

[Third approach: Nested roles ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#third_approach_nested_roles)

[Fourth approach: Multiple roles per node ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#fourth_approach_multiple_roles_per_node)

[Fifth approach: Super profiles ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#fifth_approach_super_profiles)

[Sixth approach: Building roles in the node classifier ](https://www.puppet.com/docs/puppet/7/designing_convenient_roles.html#sixth_approach_building_roles_in_the_node_classifier)

There are several approaches to building roles, and you must    decide which ones are most convenient for you and your team.

High-quality roles strike a balance between readability and      maintainability. For most people, the benefit of seeing the entire role in a single file      outweighs the maintenance cost of repetition. Later, if you find the repetition burdensome,      you can change your approach to reduce it. This might involve combining several similar roles      into a more complex role, creating sub-roles that other roles can include, or pushing more      complexity into your profiles.

So, begin with granular roles and deviate from them only in small,      carefully considered steps.

Here's the basic Jenkins role we're starting with:

```
class role::jenkins::controller {
  include profile::base
  include profile::server
  include profile::jenkins::controller
}Copied!
```

**Related information**

- [Rules for role classes](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html#rules_for_role_classes)

## First approach: Granular roles 

The simplest approach is to make one role per type of node, period. For example, the      Puppet Release Engineering (RE) team manages some additional    resources on their Jenkins controllers. 

With granular roles, we'd have at least two Jenkins controller roles. A basic one:

```
class role::jenkins::controller {
  include profile::base
  include profile::server
  include profile::jenkins::controller
}Copied!
```

...and an RE-specific one:

```
class role::jenkins::controller::release {
  include profile::base
  include profile::server
  include profile::jenkins::controller
  include profile::jenkins::controller::release
}Copied!
```

The benefits of this setup are:

- Readability — By looking at a single class, you can immediately see        which profiles make up each type of node.
- Simplicity — Each role is just a linear list of profiles.

Some drawbacks are:

- Role bloat — If you have a lot of only-slightly-different nodes, you        quickly have a large number of roles.
- Repetition — The two roles above are almost identical, with one        difference. If they're two separate roles, it's harder to see how they're related to each        other, and updating them can be more annoying.

## Second approach: Conditional logic 

Alternatively, you can use conditional logic to handle    differences between closely-related kinds of nodes.

```
class role::jenkins::controller::release {
  include profile::base
  include profile::server
  include profile::jenkins::controller

  if $facts['group'] == 'release' {
    include profile::jenkins::controller::release
  }
}Copied!
```

The benefits of this approach are:

- You have fewer roles, and they're easy to maintain.

The drawbacks are:

- Reduced readability...maybe. Conditional logic isn't usually hard to        read, especially in a simple case like this, but you might feel tempted to add a bunch of        new custom facts to accommodate complex roles. This can make roles much harder to read,        because a reader must also know what those facts mean.

  In short, be          careful of turning your node classification system inside-out. You might have a better          time if you separate the roles and assign them with your node classifier.

## Third approach: Nested roles 

Another way of reducing repetition is to let roles include    other roles. 

```
class role::jenkins::controller {
  # Parent role:
  include role::server
  # Unique classes:
  include profile::jenkins::controller
}

class role::jenkins::controller::release {
  # Parent role:
  include role::jenkins::controller
  # Unique classes:
  include profile::jenkins::controller::release
}Copied!
```

In this example, we reduce boilerplate by having `role::jenkins::controller`      include `role::server`. When        `role::jenkins::controller::release` includes        `role::jenkins::controller`, it automatically gets        `role::server` as well. With this approach, any given role only needs to:

- Include the "parent" role that it most resembles.
- Include the small handful of classes that differentiate it from its        parent.

The benefits of this approach are:

- You have fewer roles, and they're easy to maintain.
- Increased visibility in your node classifier.

The drawbacks are:

- Reduced readability: You have to open more files to see the real        content of a role. This isn't much of a problem if you go only one level deep, but it can        get cumbersome around three or four.

## Fourth approach: Multiple roles per node 

In general, we recommend that you assign only one role to        a node. In an infrastructure where nodes usually provide one primary service, that's the        best way to work.

However, if your nodes tend to provide more than one primary service,            it can make sense to assign multiple roles.

For example, say you have a large application that is usually composed            of an application server, a database server, and a web server. To enable lighter-weight            testing during development, you've decided to provide an "all-in-one" node type to your            developers. You could do this by creating a new `role::our_application::monolithic` class, which includes all of the            profiles that compose the three normal roles, but you might find it simpler to use your            node classifier to assign all three roles (`role::our_application::app`, `role::our_application::db`, and `role::our_application::web`) to those all-in-one machines.

The benefit of this approach are:

- You have fewer roles, and they're easy to maintain.

The drawbacks are:

- There's no actual "role" that describes your multi-purpose                nodes; instead, the source of truth for what's on them is spread out between your                roles and your node classifier, and you must cross-reference to understand their                configurations. This reduces readability.
- The normal and all-in-one versions of a complex application are                likely to have other subtle differences you need to account for, which might mean                making your "normal" roles more complex. It's possible that making a separate role                for this kind of node would *reduce* your overall                complexity, even though it increases the number of roles and adds repetition.

## Fifth approach: Super profiles 

Because profiles can already include other profiles, you        can decide to enforce an additional rule at your business: all profiles must include any        other profiles needed to manage a complete node that provides that service.

For example, our `profile::jenkins::controller` class could include both                `profile::server` and `profile::base`, and you could            manage a Jenkins controller server by directly assigning                `profile::jenkins::controller` in your node classifier. In other            words, a "main" profile would do all the work that a role usually does, and the roles            layer would no longer be necessary.

The benefits of this approach are:

- The chain of dependencies for a complex service can be more                clear this way.
- Depending on how you conceptualize code, this can be easier in a                lot of ways!

The drawbacks are:

- Loss of flexibility. This reduces the number of ways in which                your roles can be combined, and reduces your ability to use alternate                implementations of dependencies for nodes with different requirements.

- Reduced readability, on a much grander scale. Like with nested                roles, you lose the advantage of a clean, straightforward list of what a node                consists of. Unlike nested roles, you also lose the clear division between                "top-level" complete system configurations (roles) and "mid-level" groupings of                technologies (profiles). Not every profile makes sense as an entire system, so you                some way to keep track of which profiles are the top-level ones.

  Some people really find continuous hierarchies easier to reason about than                    sharply divided layers. If everyone in your organization is on the same page                    about this, a "profiles and profiles" approach might make sense. But we strongly                    caution you against it unless you're very sure; for most people, a true roles                    and profiles approach works better. Try the well-traveled path first.

## Sixth approach: Building roles in the node classifier 

Instead of building roles with the Puppet language and then assigning them to nodes with your        node classifier, you might find your classifier flexible enough to build roles        directly.

 For example, you might create a "Jenkins controllers" group in the console and assign it            the `profile::base`, `profile::server`, and                `profile::jenkins::controller` classes, doing much the same job as            our basic `role::jenkins::controller` class.

Important:

If                    you're doing this, make sure you don't set parameters for profiles in the                    classifier. Continue to use Hiera / Puppet lookup to configure profiles.

This is because profiles are allowed to include other                    profiles, which interacts badly with the resource-like behavior that node                    classifiers use to set class parameters.

The benefits of this approach are:

- Your node classifier becomes much more powerful, and can be a                central point of collaboration for managing nodes.
- Increased readability: A node's page in the console displays the                full content of its role, without having to cross-reference with manifests in your                    `role` module.

The drawbacks are:

- Loss of flexibility. The Puppet                language's conditional logic is often more flexible and convenient than most node                classifiers, including the console.
- Your roles are no longer in the same code repository as your                profiles, and it's more difficult to make them follow the same code promotion                processes.

# Separating data (Hiera)

​        Hiera is a built-in key-value configuration data lookup        system, used for separating data from Puppet code. 



**[About Hiera](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_intro)**
Puppet’s strength is in reusable code. Code that                         serves  many needs must be configurable: put site-specific information in                         external configuration data files, rather than in the  code                         itself. **[Getting started with Hiera](https://www.puppet.com/docs/puppet/7/hiera_quick.html#hiera_quick)**
This page introduces the basic concepts and tasks to get         you started with Hiera, including how to create a hiera.yaml         config file and write  data. It is the foundation for understanding the more advanced topics         described in the rest of the Hiera documentation. **[Configuring Hiera](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_config_yaml_5)**
The Hiera configuration         file is called `hiera.yaml`.         It configures the hierarchy for a given layer of data. **[Creating and editing data](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_merging)**
Important aspects of using Hiera are merge behavior and interpolation. **[Looking up data with Hiera](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#hiera_automatic)**
  **[Writing new data backends](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#hiera_custom_backends)**
You can extend Hiera to         look up values in data sources, for example, a PostgreSQL  database table, a custom web app,         or a new kind of structured  data file. **[Debugging Hiera](https://www.puppet.com/docs/puppet/7/debugging_hiera.html#debugging_hiera)**
When debugging Hiera, `puppet lookup`         can help identify exactly what Hiera was doing when it raised         an error, or how it decided to look up a key and where it got its value. **[Upgrading to Hiera 5](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#hiera_migrate)**
Upgrading to Hiera 5 offers         some major advantages. A real environment data layer  means changes to your hierarchy are now         routine and testable,  using multiple backends in your hierarchy is easier and you can make a         custom backend.

# About Hiera            

### Sections

[ Hiera hierarchies](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_hierarchies)

- [Hierarchies interpolate         variables ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hierarchies-interpolate)
- [         Hiera searches the hierarchy in order ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera-searches-the-hierarchy-in-order)
- [Layered hierarchies ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#layered-hierarchies)
- [Tips for making a good         hierarchy](https://www.puppet.com/docs/puppet/7/hiera_intro.html#tips-for-making-good-hiaerarchy)

[ Hiera configuration layers ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)

- [The global layer ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#global-layer)
- [The environment layer                 ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#environment-layer)
- [The module layer ](https://www.puppet.com/docs/puppet/7/hiera_intro.html#module-layer)

Puppet’s strength is in reusable code. Code that                        serves many needs must be configurable: put site-specific information in                        external configuration data files, rather than in the code                        itself.

​                                    Puppet uses Hiera to do two                                    things:

- Store the                                                  configuration data in key-value pairs
- Look up what data                                                  a particular module needs for a given node during                                                  catalog compilation

This is done via: 

- Automatic Parameter Lookup for classes included                                                  in the catalog
- Explicit lookup calls 

​                                    Hiera’s hierarchical lookups                                    follow a “defaults, with overrides” pattern, meaning you specify                                    common data one time, and override it in situations where the                                    default won’t work. Hiera uses                                                Puppet’s facts to                                    specify data sources, so you can structure your overrides to                                    suit your infrastructure. While using facts for this purpose is                                    common, data-sources can also be defined without the use of                                    facts.

​                                    Puppet 5 comes with support for                                    JSON, YAML, and EYAML files.

Related topics: [Automatic Parameter                                                 Lookup](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#hiera_automatic).

## Hiera hierarchies

​    Hiera looks up data by following a hierarchy — an ordered list of    data sources. 

Hierarchies are configured in a `hiera.yaml` configuration file. Each level of the hierarchy tells Hiera how to access some kind of data source. A hierarchy is      usually organized like      this:

```
---
version: 5
defaults:  # Used for any hierarchy level that omits these keys.
  datadir: data         # This path is relative to hiera.yaml's directory.
  data_hash: yaml_data  # Use the built-in YAML backend.

hierarchy:
  - name: "Per-node data"                   # Human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # File path, relative to datadir.
                                   # ^^^ IMPORTANT: include the file extension!

  - name: "Per-datacenter business group data" # Uses custom facts.
    path: "location/%{facts.whereami}/%{facts.group}.yaml"

  - name: "Global business group data"
    path: "groups/%{facts.group}.yaml"

  - name: "Per-datacenter secret data (encrypted)"
    lookup_key: eyaml_lookup_key   # Uses non-default backend.
    path: "secrets/%{facts.whereami}.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"Copied!
```

In      this example, every level configures the path to a YAML file on disk.

### Hierarchies interpolate        variables 

Most levels of a hierarchy interpolate variables        into their configuration:        

```
path: "os/%{facts.os.family}.yaml"Copied!
```

The percent-and-braces `%{variable}` syntax is a Hiera interpolation        token. It is similar to the Puppet language’s `${expression}` interpolation tokens. Wherever you        use an interpolation token, Hiera determines the variable’s        value and inserts it into the hierarchy.

The `facts.os.family` uses the Hiera special `key.subkey` notation for accessing elements of hashes and arrays. It is        equivalent to `$facts['os']['family']` in the          Puppet language but the 'dot' notation produces an empty        string instead of raising an error if parts of the data is missing. Make sure that an empty        interpolation does not end up matching an unintended path.

You can        only interpolate values into certain parts of the config file. For more info, see the          `hiera.yaml` format        reference.

With node-specific variables, each node gets a        customized set of paths to data. The hierarchy is always the same.

###         Hiera searches the hierarchy in order 

After Hiera replaces the variables to make a list        of concrete data sources, it checks those data sources in the order they were written.

Generally, if a data source doesn’t exist, or doesn’t specify a value for        the current key, Hiera skips it and moves on to the next        source, until it finds one that exists — then it uses it. Note that this is the default        merge strategy, but does not always apply, for example, Hiera        can use data from all data sources and merge the result.

Earlier        data sources have priority over later ones. In the example above, the node-specific data has        the highest priority, and can override data from any other level. Business group data is        separated into local and global sources, with the local one overriding the global one.        Common data used by all nodes always goes last.

That’s how Hiera’s “defaults, with overrides” approach to data works — you        specify common data at lower levels of the hierarchy, and override it at higher levels for        groups of nodes with special needs.

### Layered hierarchies 

​        Hiera uses layers of data with a `hiera.yaml` for each layer.

Each layer can        configure its own independent hierarchy. Before a lookup, Hiera combines them into a single super-hierarchy: global → environment → module.

Note: There is a fourth layer - `default_hierarchy` - that can be used in a module’s            `hiera.yaml.` It only          comes into effect when there is no data for a key in any of the other regular          hierarchies

Assume the example above is an environment hierarchy (in the production        environment). If we also had the following global hierarchy:        

```
---
version: 5
hierarchy:
  - name: "Data exported from our old self-service config tool"
    path: "selfserve/%{trusted.certname}.json"
    data_hash: json_data
    datadir: dataCopied!
```

And        the NTP module had the following hierarchy for default        data:

```
---
version: 5
hierarchy:
  - name: "OS values"
    path: "os/%{facts.os.name}.yaml"
  - name: "Common values"
    path: "common.yaml"
defaults:
  data_hash: yaml_data
  datadir: dataCopied!
```

Then in a lookup for the `ntp::servers` key, `thrush.example.com` would use the following combined hierarchy:

- ​          `<CODEDIR>/data/selfserve/thrush.example.com.json`        
- ​          `<CODEDIR>/environments/production/data/nodes/thrush.example.com.yaml`        
- ​          `<CODEDIR>/environments/production/data/location/belfast/ops.yaml`        
- ​          `<CODEDIR>/environments/production/data/groups/ops.yaml`        
- ​          `<CODEDIR>/environments/production/data/os/Debian.yaml`        
- ​          `<CODEDIR>/environments/production/data/common.yaml`        
- ​          `<CODEDIR>/environments/production/modules/ntp/data/os/Ubuntu.yaml`        
- ​          `<CODEDIR>/environments/production/modules/ntp/data/common.yaml`        

The combined hierarchy works the same way as a layer hierarchy. Hiera skips empty data sources, and either returns the first        found value or merges all found values. 

Note: By default, `datadir` refers to the directory named ‘data’ next to the `hiera.yaml`.

### Tips for making a good        hierarchy

- Make a short hierarchy. Data files are easier to work with.
- Use the roles and profiles method to manage less data in Hiera. Sorting hundreds of class parameters is easier              than sorting thousands.
- If the built-in facts don’t provide an easy way to represent              differences in your infrastructure, make custom facts. For example, create a custom              datacenter fact that is based on information particular to your network layout so that              each datacenter is uniquely identifiable.
- Give each environment – production, test, development – its own              hierarchy.

Related topics: [codedir](https://www.puppet.com/docs/puppet/7/dirs_codedir.html), [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html). 

## Hiera configuration layers 

​        Hiera uses three independent layers of configuration. Each        layer has its own hierarchy, and they’re linked into one super-hierarchy before doing a        lookup.

The three layers are searched in the following order: global →            environment → module. Hiera searches every data source in            the global layer’s hierarchy before checking any source in the environment layer.

### The global layer 

The configuration file for the global layer is located, by                default, in `$confdir/hiera.yaml`. You can change the location by changing the                    `hiera_config`                setting in `puppet.conf`.

​                Hiera has one global hierarchy. Because it goes                before the environment layer, it’s useful for temporary overrides, for example, when                your ops team needs to bypass its normal change processes.

The global layer is the only place where legacy Hiera 3 backends can be used - it’s an important piece of the transition period when                you migrate you backends to support Hiera 5. It                supports the following config formats: `hiera.yaml` v5, `hiera.yaml` v3 (deprecated).

Other than the above use cases, try to avoid the global layer. Specify all normal                data in the environment layer.

### The environment layer                

The configuration file for the environment layer is located, by default, in `<ENVIRONMENT DIR>/hiera.yaml`.

The                environment layer is where most of your Hiera data                hierarchy definition happens. Every Puppet                environment has its own hierarchy configuration, which applies to nodes in that                environment. Supported config formats include: v5, v3 (deprecated).

### The module layer 

The configuration file for a module layer is located, by default,                in a module's `<MODULE>/hiera.yaml`.

The module layer                sets default values and merge behavior for a module’s class parameters. It is a                convenient alternative to the `params.pp` pattern. 

Note: To get the exact same behaviour as `params.pp`, use the                        `default_hierarchy`, as those bindings are excluded from merges.                    When placed in the regular hierarchy in the module’s hierarchy the bindings are                    merged when a merge lookup is performed.

It comes last in Hiera’s lookup                order, so environment data set by a user overrides the default data set by the                module’s author.

Every module can have its own hierarchy                configuration. You can only bind data for keys in the module’s namespace. For                example: 

| Lookup key       | Relevant module hierarchy |
| ---------------- | ------------------------- |
| `ntp::servers `  | `ntp`                     |
| `jenkins::port`  | `jenkins`                 |
| `secure_server ` | `(none)`                  |

​                Hiera uses the `ntp` module’s hierarchy when looking up `ntp::servers`, but uses                the ` jenkins`                module’s hierarchy when looking up `jenkins::port`. Hiera                never checks the module for a key beginning with `jenkins::`.

When                you use the lookup function for keys that don’t have a namespace (for example,                    `secure_server`),                the module layer is not consulted.

The three-layer system                means that each environment has its own hierarchy, and so do modules. You can make                hierarchy changes on an environment-by-environment basis. Module data is also                customizable.

# Getting started with Hiera    

### Sections

[Create a `hiera.yaml` config file](https://www.puppet.com/docs/puppet/7/hiera_quick.html#create_hiera_yaml_config)

[The hierarchy ](https://www.puppet.com/docs/puppet/7/hiera_quick.html#hiera_hierarchy)

[Write data: Create a test class ](https://www.puppet.com/docs/puppet/7/hiera_quick.html#create_test_class)

[Write data: Set values in common data](https://www.puppet.com/docs/puppet/7/hiera_quick.html#values_common_data)

[Write data: Set per-operating system data ](https://www.puppet.com/docs/puppet/7/hiera_quick.html#set_per_operating_data)

[Write data: Set per-node data ](https://www.puppet.com/docs/puppet/7/hiera_quick.html#set_per_node_data)

[Testing Hiera data on the command         line ](https://www.puppet.com/docs/puppet/7/hiera_quick.html#testing_hiera_data)

This page introduces the basic concepts and tasks to get        you started with Hiera, including how to create a hiera.yaml        config file and write data. It is the foundation for understanding the more advanced topics        described in the rest of the Hiera documentation.

**Related information**

- [Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)
- [Merge behaviors](https://www.puppet.com/docs/puppet/7/hiera_merging.html#merge_behaviors)

## Create a `hiera.yaml` config file

The Hiera config file is    called `hiera.yaml`. Each    environment should have its own `hiera.yaml` file.

In the main directory of one of your environments, create          a new file called `hiera.yaml`. Paste the following contents into it:

```
# <ENVIRONMENT>/hiera.yaml
---
version: 5

hierarchy:
  - name: "Per-node data"                   # Human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # File path, relative to datadir.
                                   # ^^^ IMPORTANT: include the file extension!

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"
Copied!
```

Results

This file is in a format        called YAML, which is used extensively throughout Hiera.

For more information on YAML, see [YAML           Cookbook.](http://www.yaml.org/YAML_for_ruby.html)

**Related information**

- [Config file syntax](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config_syntax)

## The hierarchy 

The `hiera.yaml` file configures a hierarchy: an ordered list of data        sources.

Hiera searches these data sources in            the order they are written. Higher-priority sources override lower-priority ones. Most            hierarchy levels use variables to locate a data source, so that different nodes get            different data.

This is the core concept of Hiera: a            defaults-with-overrides pattern for data lookup, using a node-specific list of data            sources.

**Related information**

- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)
- [Hiera hierarchies](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_hierarchies)

## Write data: Create a test class 

A test class writes the data it receives to a temporary        file — on the agent when applying the catalog.

​                Hiera is used with Puppet code, so the first step is to create a Puppet class for testing.

1. ​                If you do not already use the roles and profiles method, create a module named                        `profile`. Profiles are wrapper classes that use multiple                    component modules to configure a layered technology stack. See [The roles and profile method](https://puppet.com/docs/pe/latest/the_roles_and_profiles_method.html) for more                    information.            

2. ​                Use Puppet Development Kit ( PDK) to create a class called hiera_test.pp in                    your `profile` module.            

3. Add the following code you your `hiera_test.pp` file: 

   ```
   # /etc/puppetlabs/code/environments/production/modules/profile/manifests/hiera_test.pp
   class profile::hiera_test (
     Boolean             $ssl,
     Boolean             $backups_enabled,
     Optional[String[1]] $site_alias = undef,
   ) {
     file { '/tmp/hiera_test.txt':
       ensure  => file,
       content => @("END"),
                  Data from profile::hiera_test
                  -----
                  profile::hiera_test::ssl: ${ssl}
                  profile::hiera_test::backups_enabled: ${backups_enabled}
                  profile::hiera_test::site_alias: ${site_alias}
                  |END
       owner   => root,
       mode    => '0644',
     }
   }Copied!
   ```

   The                        test class uses class parameters to request configuration data. Puppet looks up class parameters in Hiera, using `<CLASS NAME>::<PARAMETER                            NAME>` as the lookup key. 

4. Make a manifest that includes the class:

   ```
   # site.pp
   include profile::hiera_testCopied!
   ```

5. ​                Compile the catalog and observe that this fails                    because there are required values.            

6. To provide values for the missing class parameters, set these keys in your Hiera data. Depending on where in your hierarchy                    you want to set the parameters, you can add them to your [common data](https://www.puppet.com/docs/puppet/7/hiera_quick.html#values_common_data), [os data,](https://www.puppet.com/docs/puppet/7/hiera_quick.html#set_per_operating_data) or [per-node data](https://www.puppet.com/docs/puppet/7/hiera_quick.html#set_per_node_data).

   | Parameter          | Hiera key                              |
   | ------------------ | -------------------------------------- |
   | `$ssl`             | `profile::hiera_test::ssl`             |
   | `$backups_enabled` | `profile::hiera_test::backups_enabled` |
   | `$site_alias`      | `profile::hiera_test::site_alias`      |

7. ​                Compile again and observe that the parameters are                    now automatically looked up.            

**Related information**

- [The Puppet lookup function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)

## Write data: Set values in common data

Set values in your common data — the level at the bottom of      your hierarchy. 

This hierarchy level uses the YAML backend for data, which means the            data goes into a YAML file. To know where to put that file, combine the following pieces            of information: 

- The current environment’s directory.
- The data directory, which is a subdirectory of the                     environment. By default, it's `<ENVIRONMENT>/data`. 
- The file path specified by the hierarchy level.

In this case, `/etc/puppetlabs/code/environments/production/` + `data/` + `common.yaml`.

Open that YAML file in an editor, and set values for               two of the class’s parameters.

```
# /etc/puppetlabs/code/environments/production/data/common.yaml
---
profile::hiera_test::ssl: false
profile::hiera_test::backups_enabled: trueCopied!
```

The third parameter, `$site_alias`, has a default value defined in code, so                  you can omit it from the data.

## Write data: Set per-operating system data 

The second level of the hierarchy uses the `os` fact to locate its data file. This means it        can use different data files depending on the operating system of the current        node.

For this example,                suppose that your developers use MacBook laptops, which have an OS family of `Darwin`. If a developer is running an                app instance on their laptop, it should not send data to your production backup                server, so set `$backups_enabled` to                    `false`.

If you do not run Puppet on any Mac laptops, choose                an OS family that is meaningful to your infrastructure.

1. Locate the data file, by replacing `%{facts.os.family}`                    with the value you are targeting:

   `/etc/puppetlabs/code/environments/production/data/` + `os/` + `Darwin` + `.yaml`

2. Add the following contents:

   ```
   # /etc/puppetlabs/code/environments/production/data/os/Darwin.yaml
   ---
   profile::hiera_test::backups_enabled: falseCopied!
   ```

3. ​                Compile to observe that the override takes effect.                            

Results

Related topics: [the os fact.](https://puppet.com/docs/facter/3.9/core_facts.html#core_facts)

## Write data: Set per-node data 

The highest level of the example hierarchy uses the value        of `$trusted['certname']` to locate its data        file, so you can set data by name for each individual node.

This example supposes                you have a server named `jenkins-prod-03.example.com`, and configures it to use SSL and to serve                this application at the hostname `ci.example.com`. To try this out, choose the name of a real server that                you can run Puppet on.

1. To locate the data file, replace `%{trusted.certname}`with the                    node name you’re targeting:

   `/etc/puppetlabs/code/environments/production/data/` + `nodes/` + `jenkins-prod-03.example.com` + `.yaml`

2. Open that file in an editor and add the following                    contents:

   ```
   # /etc/puppetlabs/code/environments/production/data/nodes/jenkins-prod-03.example.com.yaml
   ---
   profile::hiera_test::ssl: true
   profile::hiera_test::site_alias: ci.example.com
   Copied!
   ```

3. ​                Compile to observe that the override takes                    effect.            

Results

Related topics: [$trusted[‘certname’\]](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html).

## Testing Hiera data on the command        line 

As you set Hiera data or        rearrange your hierarchy, it is important to double-check the data a node        receives.

The `puppet lookup` command helps test data interactively. For                example:

```
puppet lookup profile::hiera_test::backups_enabled --environment production --node jenkins-prod-03.example.comCopied!
```

This                returns the value `true`.

To use the `puppet                    lookup` command effectively:

- Run the command on a Puppet                    Server node, or on another node that has access to a full copy of your Puppet code and configuration.

- The node you are testing against should have contacted the                    server at least one time as this makes the facts for that node available to the                        `lookup`                    command (otherwise you need to supply the facts yourself on the command                    line).

- Make sure the command uses the global `confdir` and `codedir`, so it has access to your live data. If                    you’re not running `puppet                        lookup` as root user, specify `--codedir` and `--confdir` on the command line.

- If you use PuppetDB, you can                    use any node’s facts in a lookup by specifying `--node <NAME>`. Hiera can automatically get that node’s real                    facts and use them to resolve data.

- If you do not use 

  PuppetDB

  ,                    or if you want to test for a set of facts that don't exist, provide facts in a                    YAML or JSON file and specify that file as part of the command with 

  ```
  --facts <FILE>
  ```

  . To get a file                    full of facts, rather than creating one from scratch, run 

  ```
  facter -p --json > facts.json
  ```

   on a node                    that is similar to the node you want to examine, copy the 

  ```
  facts.json
  ```

   file to your 

  Puppet

   Server node, and edit it as needed.

  - ​                            Puppet Development Kit comes with predefined fact sets                            for a variety of platforms. You can use those if you want to test                            against platforms you do not have, or if you want "typical facts" for a                            kind of platform.

- If you are not getting the values you expect, try re-running                    the command with `--explain`. The                        `--explain` flag makes Hiera output a full explanation of which data                    sources it searched and what it found in them.

Related topics: [The puppet lookup                     command](https://www.puppet.com/docs/puppet/7/man/lookup.html), [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html), [codedir](https://www.puppet.com/docs/puppet/7/dirs_codedir.html).

# Configuring Hiera

### Sections

[Location of `hiera.yaml` files ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_config_yaml_location-title-1538585369054)

[Config file syntax ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config_syntax)

- [The default configuration](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config-syntax-default-configuration)
- [The defaults key](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config-syntax-defaults-key)
- [The hierarchy key](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config-syntax-hierachy-key)
- [The `default_hierarchy` key](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config-syntax-default-hierarchy-key)

[Configuring a hierarchy level: built-in backends ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#built-in-backends)

- [Specifying file paths ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#specifying_file_paths)

[Configuring a hierarchy level: `hiera-eyaml`   ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_eyaml)

[Configuring a hierarchy level: legacy Hiera 3 backends ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#legacy_hiera_3_backends)

[Configuring a hierarchy level: general format ](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hierarchy_general_format)

Expand

The Hiera configuration        file is called `hiera.yaml`.        It configures the hierarchy for a given layer of data.

**Related information**

- [Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)
- [Hiera hierarchies](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_hierarchies)

## Location of `hiera.yaml` files 

There are several `hiera.yaml` files in a typical deployment. Hiera uses three layers of configuration, and the module and        environment layers typically have multiple instances.

The                configuration file locations for each layer:

| Layer       | Location                   | Example                                                      |
| ----------- | -------------------------- | ------------------------------------------------------------ |
| Global      | `$confdir/hiera.yaml`      | `/etc/puppetlabs/puppet/hiera.yaml`                            `C:\ProgramData\PuppetLabs\puppet\etc\hiera.yaml` |
| Environment | `<ENVIRONMENT>/hiera.yaml` | `/etc/puppetlabs/code/environments/production/hiera.yaml`                            `C:\ProgramData\PuppetLabs\code\environments\production\hiera.yaml` |
| Module      | `<MODULE>/hiera.yaml`      | `/etc/puppetlabs/code/environments/production/modules/ntp/hiera.yaml`                            `C:\ProgramData\PuppetLabs\code\environments\production\modules\ntp\hiera.yaml` |

Note: To change the location for the global                    layer’s `hiera.yaml` set the `hiera_config` setting in your `puppet.conf` file.

​                Hiera searches for data in the following order:                global → environment → module. For more information, see [                     Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers).

Related topics: [codedir](https://www.puppet.com/docs/puppet/7/dirs_codedir.html), [Environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about), [Modules fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals).

## Config file syntax 

The `hiera.yaml` file is a YAML file, containing a hash with up to four top-level    keys.

The following keys are in a `hiera.yaml` file:

- `version` - Required.        Must be the number 5, with no quotes.
- `defaults` - A hash,        which can set a default `datadir`, `backend`, and `options` for hierarchy levels.
- `hierarchy` - An array        of hashes, which configures the levels of the hierarchy.
- `default_hierarchy` -        An array of hashes, which sets a default hierarchy to be used only if the normal hierarchy        entries do not result in a value. Only allowed in a module's `hiera.yaml.`

```
version: 5
defaults:  # Used for any hierarchy level that omits these keys.
  datadir: data         # This path is relative to hiera.yaml's directory.
  data_hash: yaml_data  # Use the built-in YAML backend.

hierarchy:
  - name: "Per-node data"                   # Human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # File path, relative to datadir.
                                   # ^^^ IMPORTANT: include the file extension!

  - name: "Per-datacenter business group data" # Uses custom facts.
    path: "location/%{facts.whereami}/%{facts.group}.yaml"

  - name: "Global business group data"
    path: "groups/%{facts.group}.yaml"

  - name: "Per-datacenter secret data (encrypted)"
    lookup_key: eyaml_lookup_key   # Uses non-default backend.
    path: "secrets/nodes/%{trusted.certname}.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"Copied!
```

Note: When writing in Hiera YAML files, do not use hard tabs for        indentation. 

### The default configuration

If you omit the `hierarchy` or `defaults` keys, Hiera uses the following default        values.

```
version: 5
hierarchy:
  - name: Common
    path: common.yaml
defaults:
  data_hash: yaml_data
  datadir: dataCopied!
```

These defaults are only used if the file is present and specifies          `version: 5`. If `hiera.yaml` is absent, it        disables Hiera for that layer. If it specifies a different        version, different defaults apply.

### The defaults key

The `defaults` key sets default values for the          `lookup function` and `datadir` keys, which lets you omit those keys in your hierarchy levels. The        value of defaults must be a hash, which can have up to three keys: `datadir`, `options`, and one of the        mutually exclusive `lookup function` keys.

datadir: a default value for `datadir`, used for any file-based hierarchy        level that doesn't specify its own. If not given, the `datadir` is the        directory `data` in the same directory as the `hiera.yaml`        configuration file.

options: a default value for `options`, used for any        hierarchy level that does not specify its own.

The lookup function keys: used for any hierarchy level that doesn't specify its own. This        must be one of:

- `data_hash` - produces a hash of key-value pairs (typically from a data          file)
- `lookup_key` - produces values key by key (typically for a custom data          provider)
- `data_dig` - produces values key by key (for a more advanced data          provider)
- `hiera3_backend` - a data provider that calls out to a legacy Hiera 3 backend (global layer only). 

For the built-in data providers — YAML, JSON, and HOCON — the key is always          `data_hash` and the value is one of `yaml_data`,          `json_data`, or `hocon_data`. To set a custom data provider        as the default, see the data provider documentation. Whichever key you use, the value must        be the name of the custom Puppet function that implements the        lookup function.

### The hierarchy key

The `hierarchy` key configures the levels of the hierarchy. The value of          `hierarchy` must be an array of hashes.

Indent the hash's keys by four spaces, so they line up with the first key. Put an empty        line between hashes, to visually distinguish them. For example:

```
hierarchy:
  - name: "Per-node data"
    path: "nodes/%{trusted.certname}.yaml"

  - name: "Per-datacenter business group data"
    path: "location/%{facts.whereami}/%{facts.group}.yaml"Copied!
```

### The `default_hierarchy` key

The `default_hierarchy` key is a top-level key. It        is initiated when, and only when, the lookup in the regular hierarchy does not        find a value. Within this default hierarchy, the normal merging rules apply.          The `default_hierarchy` is not permitted in environment        or global layers.

If `lookup_options` is used, the values found in the regular        hierarchy have no effect on the values found in the `default_hierarchy`, and vice versa. A merge parameter, given in a call to lookup,        is only used in the regular hierarchy. It does not affect how a value in the default        hierarchy is assembled. The only way to influence that, is to use `lookup_options`, found in the default hierarchy.

For more information about the YAML file, see [YAML](http://www.yaml.org/YAML_for_ruby.html).

**Related information**

- [Hiera hierarchies](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_hierarchies)

## Configuring a hierarchy level: built-in backends 

Hiera has three built-in backends: YAML,        JSON, and HOCON. All of these use files as data sources.

You can use any combination of these                backends in a hierarchy, and can also combine them with custom backends. But if most                of your data is in one file format, set default values for the `datadir` and `data_hash` keys.

Each                YAML/JSON/HOCON hierarchy level needs the following keys:

- `name` — A                    name for this level, shown in debug messages and `--explain` output.

- ```
  path
  ```

  ,                        

  ```
  paths
  ```

  , 

  ```
  glob
  ```

  , 

  ```
  globs
  ```

  , or 

  ```
  mapped_paths
  ```

   (choose one) — The data files to use for this                    hierarchy level.

  - These paths are relative to the `datadir`, they support                            variable interpolation, and they require a file extension. See                            “Specifying file paths” for more details.
  - `mapped_paths` does not support `glob`                            expansion.

- ```
  data_hash
  ```

   —                    Which backend to use. Can be omitted if you set a default. The value must be one                    of the following:

  - `yaml_data` for YAML.
  - `json_data` for JSON.
  - `hocon_data` for HOCON.

- ```
  datadir
  ```

   —                    The directory where data files are kept. Can be omitted if you set a default.

  - This path is relative to `hiera.yaml`'s directory: if the                            config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml`                            and the `datadir` is set to data, the full path to the data                            directory is `/etc/puppetlabs/code/environments/production/data`.
  - In the global layer, you can optionally set the                                `datadir` to an absolute path; in the other layers, it must                            always be relative.
  - `datadir` supports variable interpolation.

For more information on built-in backends, see [YAML](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/yaml_data.rb), [JSON](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/json_data.rb), [HOCON](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/hocon_data.rb).

**Related information**

- [Interpolate a Puppet variable](https://www.puppet.com/docs/puppet/7/hiera_merging.html#interpolate_puppet_variable)

### Specifying file paths 

Options for specifying a file path.

| Key            | Data type     | Expected value                                               |
| -------------- | ------------- | ------------------------------------------------------------ |
| `path`         | String        | One file path.                                               |
| `paths`        | Array         | Any number of file paths. This                            acts like a sub-hierarchy: if multiple files exist, Hiera searches all of them, in the order                            in which they're written. |
| `glob`         | String        | One shell-like glob pattern,                            which might match any number of files. If multiple files are found, Hiera searches all of them in                            alphanumerical order. |
| `globs`        | Array         | Any number of shell-like glob                            patterns. If multiple files are found, Hiera searches all of them in                            alphanumerical order (ignoring the order of the globs). |
| `mapped_paths` | Array or Hash | A fact that is a collection                            (array or hash) of values. Hiera expands                            these values to produce an array of paths. |

Note: You can only use one of these keys in a given                hierarchy level.

Explicit file extensions are required, for example, `common.yaml`, not `common`.

File paths are relative to the `datadir`: if the full `datadir` is `/etc/puppetlabs/code/environments/production/data` and the file path is set            to `"nodes/%{trusted.certname}.yaml"`,            the full path to the file is `/etc/puppetlabs/code/environments/production/data/nodes/<NODE                NAME>.yaml`.

Note: Hierarchy levels should interpolate variables                into the path.

Globs are implemented with Ruby's                `Dir.glob` method:

- One asterisk (`*`) matches a run of characters.
- Two asterisks (`**`) matches any depth of nested directories.
- A question mark (`?`) matches one character.
- Comma-separated lists in curly braces (`{one,two}`) match any option in the list.
- Sets of characters in square brackets (`[abcd]`) match any character in the set.
- A backslash (`\`)                escapes special characters.

Example:

```
- name: "Domain or network segment"
    glob: "network/**/{%{facts.networking.domain},%{facts.networking.interfaces.en0.bindings.0.network}}.yaml"Copied!
```

The `mapped_paths` key            must contain three string elements, in the following order:

- A scope variable that points to a collection of strings.
- The variable name that is mapped to each element of the                collection.
- A template where that variable can be used in interpolation                expressions.

For example, a fact named `$services` contains the array `["a",                "b", "c"]`. The following configuration has the same results as if paths had            been specified to be `[service/a/common.yaml,                service/b/common.yaml, service/c/common.yaml]`.

```
- name: Example
    mapped_paths: [services, tmp, "service/%{tmp}/common.yaml"]Copied!
```

**Related information**

- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)
- [The hierarchy](https://www.puppet.com/docs/puppet/7/hiera_quick.html#hiera_hierarchy)

## Configuring a hierarchy level: `hiera-eyaml`  

​    Hiera 5 ( Puppet 4.9.3 and later)    includes a native interface for the Hiera eyaml extension, which    keeps data encrypted on disk but lets Puppet read it during    catalog compilation.

To learn how to create keys and edit        encrypted files, see the [Hiera eyaml](https://github.com/voxpupuli/hiera-eyaml)        documentation.

Within `hiera.yaml`, the eyaml backend resembles the standard built-in backends, with a        few differences: it uses `lookup_key` instead        of `data_hash`, and requires an `options` key to locate decryption keys. Note that        the eyaml backend can read regular yaml files as well as yaml files with encrypted        data.

Important: To use the eyaml backend, you must have the            `hiera-eyaml` gem installed where Puppet can use it. It's included in Puppet Server since          version 5.2.0, so you just need to make it available for command line usage. To enable          eyaml on the command line and with `puppet            apply`, use `sudo            /opt/puppetlabs/puppet/bin/gem install hiera-eyaml`.

Each eyaml hierarchy        level needs the following keys:

- ​          `name` — A name for this level, shown in          debug messages and `--explain` output.

- ​          `lookup_key` — Which backend to use. The          value must be `eyaml_lookup_key`. Use this          instead of the `data_hash` setting.

- ​          `path`, `paths`, `mapped_paths`, `glob`, or            `globs` (choose one) — The data files to          use for this hierarchy level. These paths are relative to the datadir, they support          variable interpolation, and they require a file extension. In this case, you'll usually          use `.eyaml`. They work the same way they          do for the standard backends.

- ​          `datadir` — The directory where data files          are kept. Can be omitted if you set a default. Works the same way it does for the standard          backends.

- ```
  options
  ```

   — A hash of options specific to            

  ```
  hiera-eyaml
  ```

  , mostly used to configure          decryption. For the default encryption method, this hash must have the following keys: 

  - ​              `pkcs7_private_key` — The location of              the PKCS7 private key to use. 
  - ​              `pkcs7_public_key` — The location of              the PKCS7 public key to use. 
  - If you use an alternate encryption plugin, search the plugin's              docs for the encryption options. Set an `encrypt_method` option, plus some plugin-specific options to replace the                `pkcs7` ones. 
  - You can use normal strings as keys in this hash; you don't need              to use symbols.

The file path key and the options key both support variable        interpolation.

An example hierarchy      level:

```
hierarchy:
  - name: "Per-datacenter secret data (encrypted)"
    lookup_key: eyaml_lookup_key
    path: "secrets/%{facts.whereami}.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pemCopied!
```

**Related information**

- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)

## Configuring a hierarchy level: legacy Hiera 3 backends 

If you rely on custom data backends designed for Hiera 3, you can use them in your global hierarchy. They are not    supported at the environment or module layers.

Note: This feature is a temporary measure to let you start using new features while waiting for          backend updates.

Each legacy hierarchy level needs the following keys:

- `name` — A name for          this level, shown in debug messages and `--explain` output.

- ```
  path
  ```

   or 

  ```
  paths
  ```

   (choose one) — The data files to use for          this hierarchy level.

  - For file-based backends, include the file extension, even though              you would have omitted it in the v3 `hiera.yaml` file.
  - For non-file backends, don't use a file extension.

- `hiera3_backend` —          The legacy backend to use. This is the same name you'd use in the v3 config file's `:backends` key.

- ```
  datadir
  ```

   — The          directory where data files are kept. Set this only if your backend required a 

  ```
  :datadir
  ```

   setting in its backend-specific            options.

  - This path is relative to `hiera.yaml`'s directory: if the config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml` and the datadir is              set to `data`, the full path to the              data directory is `/etc/puppetlabs/code/environments/production/data`. Note that Hiera v3 uses 'hieradata' instead of 'data'.
  - In the global layer, you can optionally set the `datadir` to an absolute path.

- `options` — A hash,          with any backend-specific options (other than `datadir`) required by your backend. In the v3 config, this would have been in a          top-level key named after the backend. You can use normal strings as keys. Hiera converts them to symbols for the backend.

The following example shows roughly equivalent v3 and v5 `hiera.yaml` files using legacy        backends:

```
# hiera.yaml v3
---
:backends:
  - mongodb
  - xml

:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost

:xml:
  :datadir: /some/other/dir

:hierarchy:
  - "%{trusted.certname}"
  - "common"


# hiera.yaml v5
---
version: 5
hierarchy:
  - name: MongoDB
    hiera3_backend: mongodb
    paths:
      - "%{trusted.certname}"
      - common
    options:
      connections:
        dbname: hdata
        collection: config
        host: localhost

  - name: Data in XML
    hiera3_backend: xml
    datadir: /some/other/dir
    paths:
      - "%{trusted.certname}.xml"
      - common.xml
Copied!
```

## Configuring a hierarchy level: general format 

Hiera supports custom        backends.

Each hierarchy level is represented                by a hash which needs the following keys:

- `name` — A                    name for this level, shown in debug messages and `--explain` output.
- A backend key, which must be one of:
  - `data_hash`
  - `lookup_key`
  - `data_dig` — a more specialized form of `lookup_key`, suitable when the                            backend is for a database. `data_dig` resolves dot separated keys, whereas `lookup_key` does not.
  - `hiera3_backend` (global layer only)
- A path or URI key — only if required by the backend. These                    keys support variable interpolation. The following path/URI keys are                        available:
  - `path`
  - `paths`
  - `mapped_paths`
  - `glob`
  - `globs`
  - `uri`
  - `uris` - these paths or URIs work the same way they do for                            the built-in backends. Hiera handles the                            work of locating files, so any backend that supports `path` automatically supports `paths`, `glob`, and `globs`. `uri` (string) and `uris` (array) can represent any kind of data source. Hiera does not ensure URIs are resolvable                            before calling the backend, and does not need to understand any given                            URI schema. A backend can omit the path/URI key, and rely wholly on the                                `options` key to                            locate its data.
- `datadir` —                    The directory where data files are kept: the path is relative to hiera.yaml's                    directory. Only required if the backend uses the `path(s)` and `glob(s)` keys, and can be omitted if you set a default.
- `options` — A                    hash of extra options for the backend; for example, database credentials or the                    location of a decryption key. All values in the `options` hash support variable interpolation.

Whichever key you use, the value must be the name of a                function that implements the backend API. Note that the choice here is made by the                implementer of the particular backend, not the user.

For                more information, see [custom Puppet function.](https://www.puppet.com/docs/puppet/7/functions_basics.html#functions_basics)

**Related information**

- [Custom backends overview](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom_backends_overview)
- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)

# Creating and editing data 

### Sections

[Set the merge behavior for a lookup ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#set_merge_behavior)

[Merge behaviors ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#merge_behaviors)

- [First](https://www.puppet.com/docs/puppet/7/hiera_merging.html#first)
- [Unique](https://www.puppet.com/docs/puppet/7/hiera_merging.html#unique)
- [Hash](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hash)
- [Deep](https://www.puppet.com/docs/puppet/7/hiera_merging.html#deep)

[Set merge behavior at lookup time ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#merge_behavior_lookup_time)

[Set `lookup_options` to refine the result of a lookup](https://www.puppet.com/docs/puppet/7/hiera_merging.html#setting_lookup_options_to_refine_the_result_of_a_lookup)

- [**The `lookup_options` format**](https://www.puppet.com/docs/puppet/7/hiera_merging.html#lookup-options-format)
- [**Location for setting `lookup_options`**         ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#location-for-setting-lookup-options)
- [**Defining Merge Behavior with `lookup_options`**](https://www.puppet.com/docs/puppet/7/hiera_merging.html#defining-merge-behavior-with-lookup-options)
- [**Overriding merge behavior**](https://www.puppet.com/docs/puppet/7/hiera_merging.html#overriding-merge-behavior)
- [**Overriding merge behavior in a call to `lookup()`**](https://www.puppet.com/docs/puppet/7/hiera_merging.html#overriding-merge-behavior-in-call-to-lookup)
- [**Make Hiera return data by casting to a specific data           type**](https://www.puppet.com/docs/puppet/7/hiera_merging.html#make-hiera-return-data-by-casting)

[Use a regular expression in `lookup_options`     ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#regular_expression_lookup_options)

[Interpolation ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)

- [Interpolation token             syntax](https://www.puppet.com/docs/puppet/7/hiera_merging.html#interpolation-token)

[Interpolate a Puppet variable ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#interpolate_puppet_variable)

[Interpolation functions ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#interpolation_functions)

- [The `lookup` and `hiera`         function](https://www.puppet.com/docs/puppet/7/hiera_merging.html#lookup-and-hiera-function)
- [The `alias` function](https://www.puppet.com/docs/puppet/7/hiera_merging.html#alias-function)
- [The `literal` function](https://www.puppet.com/docs/puppet/7/hiera_merging.html#literal-function)
- [The `scope` function](https://www.puppet.com/docs/puppet/7/hiera_merging.html#scope-function)
- [Using interpolation functions ](https://www.puppet.com/docs/puppet/7/hiera_merging.html#using-interpolation-functions)

Expand

Important aspects of using Hiera are merge behavior and interpolation.

## Set the merge behavior for a lookup 

When you look up a key in Hiera, it is common for multiple data sources to have        different values for it. By default, Hiera returns the first        value it finds, but it can also continue searching and merge all the found values        together.

1. You can set the merge behavior for a lookup in two                    ways:
   - At lookup time. This works with the `lookup` function, but does not                            support automatic class parameter lookup.
   - In Hiera data, with                            the `lookup_options` key.                            This works for both manual and automatic lookups. It also lets module                            authors set default behavior that users can override.
2. ​                With both of these methods, specify a merge                    behavior as either a string, for example, `'first'` or a hash, for example `{'strategy' => 'first'}`. The hash syntax is useful                    for `deep` merges (where extra                    options are available), but it also works with the other merge types.            

**Related information**

- [The Puppet lookup function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)

## Merge behaviors 

There are four merge behaviors to choose from: `first`, `unique`, `hash`, and `deep`.

 When specifying a merge behavior, use one of the following      identifiers:

- ​        `'first'`, `{'strategy' => 'first'}`, or nothing.

- ​        `'unique'` or `{'strategy' => 'unique'}`.

- ​        `'hash'` or `{'strategy' => 'hash'}`.

- ```
  'deep'
  ```

   or 

  ```
  {'strategy' => 'deep', <OPTION> => <VALUE>, ...}
  ```

  .        Valid options:

  - ​            `'knockout_prefix'` - string or `undef`;              [disabled by default](https://www.puppet.com/docs/puppet/7/known_issues_puppet.html).
  - ​            `'sort_merged_arrays'` - Boolean; default            is `false`          
  - ​            `'merge_hash_arrays'` - Boolean; default            is `false`          

### First

A first-found lookup doesn’t merge anything: it returns the first value found for the key,        and ignores the rest. This is Hiera’s default behavior.

Specify this merge behavior with one of these: 

- ​              `'first'`            
- ​              `{'strategy' => 'first'}`            
- `lookup($key)`
- Nothing (because it’s the default)

### Unique

A unique merge (also called an array merge) combines any number of array and scalar        (string, number, boolean) values to return a merged, flattened array with all matching        values for a key. All duplicate values are removed. The lookup fails if any of the values        are hashes. The result is ordered from highest priority to lowest.

Specify this merge behavior with one of these: 

- ​              `'unique'`            
- `lookup($key, { 'merge' => 'unique' })`
- ​              `{'strategy' => 'unique'}`            

### Hash

A hash merge combines the keys and values of any number of hashes to return a merged hash        of all matching values for a key. Every match must be a hash and the lookup fails if any of        the values aren’t hashes.

If multiple source hashes have a given key, Hiera uses the        value from the highest priority data source: it won’t recursively merge the values.

Hashes in Puppet preserve the order in which their keys are        written. When merging hashes, Hiera starts with the lowest        priority data source. For each higher priority source, it appends new keys at the end of the        hash and updates existing keys in place.        

```
# web01.example.com.yaml
mykey:
  d: "per-node value"
  b: "per-node override"
# common.yaml
mykey:
  a: "common value"
  b: "default value"
  c: "other common value"


`lookup('mykey', {merge => 'hash'})Copied!
```

Returns the        following:

```
{
  a => "common value",
  b => "per-node override", # Using value from the higher-priority source, but
                            # preserving the order of the lower-priority source.
  c => "other common value",
  d => "per-node value",
}Copied!
```

Specify this merge behavior with one of these: 

- ​              `'hash'`            
- `lookup($key, { 'merge' => 'hash' })`
- ​              `{'strategy' => 'hash'}`            

### Deep

A deep merge combines the keys and values of any number of hashes to return a merged hash.        It contains an array of class names and can be used as a lightweight External Node        Classifier (ENC).

If the same key exists in multiple source hashes, Hiera        recursively merges them:

- Hash values are merged with another deep merge.
- Array values are merged. This differs from the unique merge. The result is ordered from          lowest priority to highest, which is the reverse of the unique merge’s ordering. The          result is not flattened, so it can contain nested arrays. The            `merge_hash_arrays` and `sort_merged_arrays` options can          make further changes to the result.
- Scalar (String, Number, Boolean) values use the highest priority value, like in a          first-found lookup.

Specify this merge behavior with one of these:

- ​          `'deep'`        

- `include(lookup($key, { 'merge' => 'deep' }))`

- ```
  {'strategy' => 'deep', <OPTION> => <VALUE>, ...}
  ```

   —          Adjust the merge behavior with these additional options:

  - ​              `'knockout_prefix'` (String or `undef`) -              Use with a string prefix to indicate a value to remove from the final result. Note              that this option is disabled by default due to a known issue that causes it to be              ineffective in hierarchies more than three levels deep. For more information, see                [Puppet known issues](https://www.puppet.com/docs/puppet/7/known_issues_puppet.html). 
  - ​              `'sort_merged_arrays'` (Boolean) - Whether to sort all arrays that are              merged together. Defaults to `false`.
  - ​              `'merge_hash_arrays'` (Boolean) - Whether to deep-merge hashes within              arrays, by position. For example, `[ {a => high}, {b => high} ]`              and `[ {c => low}, {d => low} ]` would be merged as `[ {c                => low, a => high}, {d => low, b => high} ]`. Defaults to                `false`.

Note: Unlike a hash merge, a deep merge can also accept arrays as the root          values. It merges them with its normal array merging behavior, which differs from a unique          merge as described above. This does not apply to the deprecated Hiera 3 `hiera_hash` function,          which can be configured to do deep merges but can’t accept arrays.

## Set merge behavior at lookup time 

Use merge behaviour at lookup time to override        preconfigured merge behavior for a key.

Use the `lookup` function or the `puppet lookup` command to provide a merge                behavior as an argument or flag.

Function example:

```
# Merge several arrays of class names into one array:
lookup('classes', {merge => 'unique'})Copied!
```

Command line example: 

```
$ puppet lookup classes --merge unique --environment production --explainCopied!
```

Note: Each of the deprecated                        `hiera_*`                    functions is locked to one particular merge behavior. (For example, Hiera only merges first-found, and `hiera_array` only                    performs a unique merge.)

## Set `lookup_options` to refine the result of a lookup

 You can set `lookup_options` to further refine the result of a lookup, including    defining merge behavior and using the `convert_to` key to get automatic type conversion.

### **The `lookup_options` format**

The value of `lookup_options` is a hash. It follows this        format: 

```
 lookup_options:
  <NAME or REGEXP>:
    merge: <MERGE BEHAVIOR>Copied!
```

Each key is either the full name of a lookup        key (like `ntp::servers`) or a regular expression (like          `'^profile::(.*)::users$'`). In a module’s data, you can        configure lookup keys only within that module’s namespace: the ntp module can set options        for `ntp::servers`, but the `apache` module can’t.

Each value is a hash with either a `merge` key, a `convert_to key`, or both. A merge behavior can be a string or a        hash, and the type for type conversion is either a Puppet        type, or an array with a type and additional arguments.

`lookup_options` is a reserved key in Hiera. You can’t put other kinds of data in it, and you can’t        look it up directly. 

### **Location for setting `lookup_options`**        

You can set `lookup_options` metadata keys in Hiera data sources, including module data, which controls the        default merge behavior for other keys in your data. Hiera        uses a key’s configured merge behavior in any lookup that doesn’t explicitly override        it.

Note: Set `lookup_options` in the data sources of          your backend;  **don’t put it in the `hiera.yaml`            file**. For example, you can set `lookup_options` in            `common.yaml`.

### **Defining Merge Behavior with `lookup_options`**

In your Hiera data source, set the `lookup_options` key to configure merge          behavior:

```
# <ENVIRONMENT>/data/common.yaml
lookup_options:
  ntp::servers:     # Name of key
    merge: unique   # Merge behavior as a string
  "^profile::(.*)::users$": # Regexp: `$users` parameter of any profile class
    merge:          # Merge behavior as a hash
      strategy: deep
      merge_hash_arrays: trueCopied!
```

Hiera uses the        configured merge behaviors for these keys. 

Note: The `lookup_options` settings have no effect          if you are using the deprecated `hiera_*` functions, which          define for themselves how they do the lookup. To take advantage of `lookup_options`, use the lookup function or Automatic Parameter Lookup (APL).        

### **Overriding merge behavior**

When Hiera is given lookup options, a hash merge is        performed. Higher priority sources override lower priority lookup options for individual        keys. You can configure a default merge behavior for a given key in a module and let users        of that module specify overrides in the environment layer. 

As an example, the following configuration defines `lookup_options` for several keys in a module. One of the keys is overridden at        the environment level – the others retain their        configuration:

```
# <MYMODULE>/data/common.yaml
lookup_options:
  mymodule::key1:
    merge:
      strategy: deep
      merge_hash_arrays: true
  mymodule::key2:
    merge: deep
  mymodule::key3:
    merge: deep

# <ENVIRONMENT>/data/common.yaml
lookup_options:
  mymodule::key1:
    merge: deep  # this overrides the merge_hash_arrays true
Copied!
```

### **Overriding merge behavior in a call to `lookup()`**

When you specify a merge behavior as an argument to the lookup function, it overrides the        configured merge behavior. For example, with the configuration above:        

```
lookup('mymodule::key1', 'strategy' => 'first')Copied!
```

The lookup of `'mymodule::key1'` uses strategy `'first'` instead of strategy `'deep'`        in the `lookup_options` configuration. 

### **Make Hiera return data by casting to a specific data          type**

To convert values from Hiera backends to rich data values,        not representable in YAML or JSON, use the  `lookup_options` key `convert_to`, which accepts        either a type name or an array of type name and arguments.

When you use `convert_to`, you get automatic type checking.        For example, if you specify a `convert_to` using type `"Enum['red', 'blue', 'green']"` and the looked-up value is not one        of those strings, it raises an error. You can use this to assert the type when there is not        enough type checking in the Puppet code that is doing the        lookup. 

For types that have a single-value constructor, such as Integer, String, Sensitive, or        Timestamp, specify the data type in string form.

For example, to turn a String value into an Integer:        

```
mymodule::mykey: "42"
lookup_options:
  mymodule::mykey:
    convert_to: "Integer"Copied!
```

To make a value Sensitive:        

```
mymodule::mykey: 42
lookup_options:
 mymodule::mykey:
   convert_to: "Sensitive"
Copied!
```

If the constructor requires arguments, specify type and the arguments in an array. You can        also specify it this way when a data type constructor takes optional arguments.

For example, to convert a string ("042") to an Integer with explicit decimal (base 10)        interpretation of the string:        

```
mymodule::mykey: "042"
lookup_options:
  mymodule::mykey:
    convert_to:
      - "Integer"
      - 10
Copied!
```

The default would interpret the leading 0 to mean an octal value (octal 042 is        decimal 34):

To turn a non-Array value into an Array:        

```
mymodule::mykey: 42
lookup_options:
 mymodule::mykey:
   convert_to:
     - "Array"
     - trueCopied!
```

**Related information**

- [Automatic lookup of class parameters](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#class_parameters)

## Use a regular expression in `lookup_options`    

You can use regular expressions in `lookup_options` to configure merge behavior for many        lookup keys at the same time.

A regular expression                key such as `'^profile::(.*)::users$'` sets the merge behavior for `profile::server::users,                    profile::postgresql::users`, `profile::jenkins::server::users`. Regular expression lookup options use                    Puppet’s regular expression support, which is                based on Ruby’s regular expressions.

To use a regular expression in `lookup_options`:

1. ​                Write the pattern as a quoted string. Do not use                    the Puppet language’s forward-slash `(/.../)` regular                    expression delimiters.            
2. ​                Begin the pattern with the start-of-line                    metacharacter (`^`, also called a carat). If ^ isn’t the first character, Hiera treats it as a literal key name instead of                    a regular expression.            
3. ​                If this data source is in a module, follow `^` with the module’s                    namespace: its full name, plus the `:: `namespace separator. For example, all regular                    expression lookup options in the `ntp` module must start with `^ntp::`. Starting with anything else                    results in an error.            

Results

The merge behavior you                set for that pattern applies to all lookup keys that match it. In cases where                multiple lookup options could apply to the same key, Hiera resolves the conflict. For example, if there’s                a literal (not regular expression) option available, Hiera uses it. Otherwise, Hiera uses the first regular expression that matches                the lookup key, using the order in which they appear in the module code.

Note:                     `lookup_options`                    are assembled with a hash merge, which puts keys from lower priority data                    sources before those from higher priority sources. To override a module’s                    regular expression configured merge behavior, use the exact same regular                    expression string in your environment data, so that it replaces the module’s                    value. A slightly different regular expression won’t work because the                    lower-priority regular expression goes first.

## Interpolation 

In Hiera you can insert, or      interpolate, the value of a variable into a string, using the syntax `%{variable}`.

​         Hiera uses interpolation in two places:

- Hierarchies: you can interpolate variables into the `path`, `paths`, `glob`, `globs`, `uri`, `uris`, `datadir`, `mapped_paths`, and `options` of a hierarchy level. This lets each node get a customized version            of the hierarchy.
- Data: you can use interpolation to avoid repetition. This takes one            of two forms: 
  - If some value always involves the value of a fact (for                  example, if you need to specify a mail server and you have one predictably-named                  mail server per domain), reference the fact directly instead of manually                  transcribing it.
  - If multiple keys need to share the same value, write it out                  for one of them and reuse it for the rest with the `lookup` or `alias` interpolation functions. This makes it easier to keep data up                  to date, as you only need to change a given value in one place. 

### Interpolation token            syntax

Interpolation tokens consist of the following:            

- A percent sign (`%`)
- An opening curly brace (`{`)
- One of: 
  - A variable name, optionally using key.subkey notation                           to access a specific member of a hash or array.
  - An interpolation function and its argument.
- A closing curly brace (`}`).

For example, `%{trusted.certname}` or `%{alias("users")}`.

​            Hiera interpolates values of Puppet data types and converts them to strings. Note that            the exception to this is when using an alias. If the alias is the only thing present,            then its value is not converted.

In YAML files, any string            containing an interpolation token must be enclosed in quotation marks.

Note: Unlike the Puppet interpolation tokens, you can’t interpolate an               arbitrary expression.

Related topics: [Puppet’s data types](https://www.puppet.com/docs/puppet/7/lang_data.html),               [Puppet’s rules for interpolating non-string          values](https://www.puppet.com/docs/puppet/7/lang_data_string.html#lang_data_string).

## Interpolate a Puppet variable 

The most common thing to interpolate is the value of a Puppet top scope variable.

The `facts` hash,               `trusted` hash, and `server_facts` hash are the most useful variables to               Hiera and behave predictably. 

Note:  If you have a hierarchy level that needs to               reference the name of a node, get the node’s name by using `trusted.certname`. To reference a node’s               environment, use `server_facts.environment`.

Avoid using local variables, namespaced variables from classes            (unless the class has already been evaluated), and Hiera-specific pseudo-variables (pseudo-variables are not supported in Hiera 5).

If you are using Hiera 3            pseudo-variables, see Puppet variables passed to Hiera.

Puppet makes facts available in two            ways: grouped together in the `facts`            hash ( `$facts['networking']`), and            individually as top-scope variables ( `$networking`).

When you use individual fact variables, specify the (empty) top-scope            namespace for them, like this:

- ​               `%{::networking}`            

Not like this:

- ​               `%{networking}`            

Note: The individual fact names               aren’t protected the way `$facts` is, and local scopes can set unrelated variables with the same               names. In most of Puppet, you don’t have to worry               about unknown scopes overriding your variables, but in Hiera you do.

To interpolate a Puppet variable:

​            Use the name of the variable, omitting the leading               dollar sign (`$`). Use               the Hiera key.subkey notation to access a member of a               data structure. For example, to interpolate the value of `$facts['networking']['domain']` write:                  `smtpserver:                  "mail.%{facts.networking.domain}"`         

Results

For more information, see [facts](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html),               [environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about).

**Related information**

- [Access hash and array elements using a key.subkey notation](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#access_hash_array-elements_keysubkey_notation)

## Interpolation functions 

In Hiera data sources, you    can use interpolation functions to insert non-variable values. These aren’t the same as Puppet functions; they’re only available in Hiera interpolation tokens.

Note: You cannot use interpolation functions in `hiera.yaml.` They’re only for use        in data sources.

There are five interpolation functions:

- ​            `lookup` - looks up a key            using Hiera, and interpolates the value into a          string
- ​            `hiera` - a synonym for              `lookup`          
- ​            `alias` - looks up a key            using Hiera, and uses the value as a replacement for the            enclosing string. The result has the same data type as what the aliased key has - no            conversion to string takes place if the value is exactly one alias
- ​            `literal` - a way to write            a literal percent sign (`%`) without accidentally interpolating something
- ​            `scope` - an alternate way            to interpolate a variable. Not generally useful

### The `lookup` and `hiera`        function

The `lookup` and `hiera` interpolation        functions look up a key and return the resulting value. The result of the lookup must be a        string; any other result causes an error. The `hiera`        interpolation functions look up a key and return the resulting value. The result of the        lookup must be a string; any other result causes an error.

This is useful in the Hiera data sources. If you need to use        the same value for multiple keys, you can assign the literal value to one key, then call        lookup to reuse the value elsewhere. You can edit the value in one place to change it        everywhere it’s used.

For example, suppose your WordPress profile needs a database server, and you’re already        configuring that hostname in data because the MySQL profile needs it. You could write:

```
# in location/pdx.yaml:
profile::mysql::public_hostname: db-server-01.pdx.example.com

# in location/bfs.yaml:
profile::mysql::public_hostname: db-server-06.belfast.example.com

# in common.yaml:
profile::wordpress::database_server: "%{lookup('profile::mysql::public_hostname')}"
Copied!
```

The value of `profile::wordpress::database_server`        is always the same as `profile::mysql::public_hostname`. Even        though you wrote the WordPress parameter in the `common.yaml`        data, it’s location-specific, as the value it references was set in your per-location data        files.

The value referenced by the lookup function can contain another call to lookup; if you        accidentally make an infinite loop, Hiera detects it and        fails.

Note: The `lookup` and `hiera` interpolation functions aren’t the same as the Puppet functions of the same names. They only take a single          argument.

### The `alias` function

The `alias` function lets you reuse Hash, Array, Boolean, Integer or String        values. 

When you interpolate `alias` in a string, Hiera replaces that entire string with the aliased value, using its original data type. For        example:

```
original:
  - 'one'
  - 'two'
aliased: "%{alias('original')}"Copied!
```

A lookup of original and a lookup of aliased would both return the value `['one',          'two']`.

When you use the `alias` function, its interpolation token must be the only        text in that string. For example, the following would be an        error:

```
aliased: "%{alias('original')} - 'three'"Copied!
```

Note: A lookup resulting in an interpolation of `alias` referencing a          non-existant key returns an empty string, not a Hiera "not          found" condition.

### The `literal` function

The `literal` interpolation function lets you escape a literal percent sign          (`%`) in Hiera data, to avoid triggering        interpolation where it isn’t wanted. 

This is useful when dealing with Apache config files, for example, which might include text        such as `%{SERVER_NAME}`. For        example:

```
server_name_string: "%{literal('%')}{SERVER_NAME}"Copied!
```

The value of `server_name_string` would be `%{SERVER_NAME}`,        and Hiera would not attempt to interpolate a variable named          `SERVER_NAME`.

The only legal argument for `literal` is a single `%`        sign.

### The `scope` function

The `scope` interpolation function interpolates variables.

It works identically to variable interpolation. The functions argument is the name of a        variable.

The following two values would be identical:

```
smtpserver: "mail.%{facts.domain}"
smtpserver: "mail.%{scope('facts.domain')}"Copied!
```

### Using interpolation functions 

To use an interpolation function to insert non-variable values, write: 

1. The name of the function.
2. An opening parenthesis.
3. One argument to the function, enclosed in single or double quotation marks.
4. Use the opposite of what the enclosing string uses: if it uses single quotation              marks, use double quotation marks.
5. A closing parenthesis.

For        example:

```
wordpress::database_server: "%{lookup('instances::mysql::public_hostname')}"Copied!
```

Note: There must be no spaces between these elements.

# Looking up data with Hiera    

### Sections

[Automatic lookup of class parameters](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#class_parameters)

[The Puppet `lookup` function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)

- [Arguments](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#arguments)
- [Merge behaviors ](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#merge-behaviors)

[The `puppet             lookup` command](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#using_puppet_lookup)

- [Examples](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#lookup-examples)
- [Options ](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#lookup-options)

[Access hash and array elements using a `key.subkey` notation](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#access_hash_array-elements_keysubkey_notation)

[ Hiera dotted notation ](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#hiera_dotted_notation)

## Automatic lookup of class parameters

Puppet looks up the values    for class parameters in Hiera, using the fully qualified name of    the parameter (`myclass::parameter_one`) as a    lookup key. 

Most classes need configuration, and you can specify them as parameters to      a class as this looks up the needed data if not directly given when the class is included in a      catalog. There are several ways Puppet sets values for class      parameters, in this order:

1. If you're doing a resource-like declaration, Puppet uses parameters that are explicitly set (if explicitly          setting undef, a looked up value or default is used).
2. Puppet uses Hiera, using `<CLASS NAME>::<PARAMETER NAME>` as the lookup key. For example, it          looks up `ntp::servers` for the `ntp` class's `$servers parameter`.
3. If a parameter still has no value, Puppet uses the default value from the parameter's default          value expression in the class's definition.
4. If any parameters have no value and no default,            Puppet fails compilation with an error.

For example, you can set servers for the `NTP` class like this:      

```
# /etc/puppetlabs/code/production/data/nodes/web01.example.com.yaml
---
ntp::servers:
  - time.example.com
  - 0.pool.ntp.orgCopied!
```

The best way to manage this is to use the [roles and profiles](https://puppet.com/docs/pe/latest/the_roles_and_profiles_method.html) method, which allows you to store a smaller      amount of more meaningful data in Hiera. 

Note: Automatic lookup of class        parameters uses the "first" merge method by default. You cannot change the default. If you        want to get deep merges on keys, use the [`lookup_options`](https://www.puppet.com/docs/puppet/7/hiera_merging.html#setting_lookup_options_to_refine_the_result_of_a_lookup) feature.

This      feature is often referred to as Automatic Parameter Lookup (APL).

## The Puppet `lookup` function

The `lookup` function uses Hiera to retrieve a value for      a given key.

By default, the `lookup` function returns the first value found and fails compilation if no         values are available. You can also configure the lookup function to merge multiple values         into one.

When looking up a key, Hiera searches up         to four hierarchy layers of data, in the following order:

1. Global hierarchy.
2. The current environment's hierarchy.
3. The indicated module's hierarchy, if the key is of the form `<MODULE               NAME>::<SOMETHING>`.
4. If not found and the module's hierarchy has a `default_hierarchy` entry in its `hiera.yaml` — the lookup is            repeated if steps 1-3 did not produce a value.

Note: Hiera checks the            global layer before the environment layer. If no global `hiera.yaml `file has been configured, Hiera defaults are used. If you do not want it to use the            defaults, you can create an empty `hiera.yaml` file in `/etc/puppetlabs/puppet/hiera.yaml.`

Default global hiera.yaml is installed at `/etc/puppetlabs/puppet/hiera.yaml`.

### Arguments

You must provide the key's name. The other arguments are optional.

You can combine these arguments in the following ways: 

- ​                     `lookup( <NAME>, [<VALUE TYPE>], [<MERGE                        BEHAVIOR>], [<DEFAULT VALUE>] )`                  
- ​                     `lookup( [<NAME>], <OPTIONS HASH> )`                  
- ​                     `lookup( as above ) |$key| { <VALUE> } # lambda                        returns a default value`                  

Arguments in `[square brackets]` are optional.

Note: Giving a hash of options containing `default_value` at the same time as giving a lambda means that the lambda               wins. The rationale for allowing this is that you might be using the same hash of               options multiple times, and you might want to override the production of the default               value. A `default_values_hash` wins over the lambda if               it has a value for the looked up key.

Arguments accepted by lookup: 

- `<NAME>` (String or Array) - The name of the                  key to look up. This can also be an array of keys. If Hiera doesn't find anything                  for the first key, it tries with the subsequent ones, only resorting to a default                  value if none of them succeed.

- `<VALUE TYPE>` (data Type) - A data type that                  must match the retrieved value; if not, the lookup (and catalog compilation)                  fails. Defaults to `Data` which accepts any normal                  value.

- `<MERGE BEHAVIOR>` (String or Hash; see [Merge behaviors](https://www.puppet.com/docs/puppet/7/hiera_merging.html#merge_behaviors)) - Whether and how to                  combine multiple values. If present, this overrides any merge behavior specified                  in the data sources. Defaults to no value; Hiera                  uses merge behavior from the data sources if present, otherwise it does a                  first-found lookup.

- `<DEFAULT VALUE>` (any normal value) - If                  present, lookup returns this when it can't find a normal value. Default values are                  never merged with found values. Like a normal value, the default must match the                  value type. Defaults to no value; if Hiera can't                  find a normal value, the lookup (and compilation) fails.

- ```
  <OPTIONS HASH>
  ```

   (Hash) - Alternate way to                  set the arguments above, plus some less common additional options. If you pass an                  options hash, you can't combine it with any regular arguments (except 

  ```
  <NAME>
  ```

  ). An options hash can have the following                  keys: 

  - `'name'` - Same as `<NAME>` (argument 1). You can pass this as an argument or                        in the hash, but not both. 
  - `'value_type'` - Same as `<VALUE TYPE>`. 
  - `'merge'` - Same as `<MERGE BEHAVIOR>`. 
  - `'default_value'` - Same as `<DEFAULT VALUE>` . 
  - `'default_values_hash'` (Hash) - A hash of                        lookup keys and default values. If Hiera                        can't find a normal value, it checks this hash for the requested key before                        giving up. You can combine this with `default_value` or a lambda, which is used if the key isn't                        present in this hash. Defaults to an empty hash. 
  - `'override'` (Hash) - A hash of lookup keys                        and override values. Puppet checks for the                        requested key in the overrides hash first. If found, it returns that value                        as the final value, ignoring merge behavior. Defaults to an empty hash. 
  - `lookup` - can take a lambda, which must                        accept a single parameter. This is yet another way to set a default value                        for the lookup; if no results are found, Puppet passes the requested key to the lambda and use its result as the default                        value. 

### Merge behaviors 

Hiera uses a hierarchy of data sources, and a given key            can have values in multiple sources. Hiera can either            return the first value it finds, or continue to search and merge all the values            together. When Hiera searches, it first searches the            global layer, then the environment layer, and finally the module layer — where it only            searches in modules that have a matching namespace. By default (unless you use one of            the merge strategies) it is priority/"first found wins", in which case the search ends            as soon as a value is found.

Note: Data sources can use the `lookup_options` metadata key to request a specific merge behavior for a               key. The lookup function uses that requested behavior unless you specify            one.

Examples:

Default values for a lookup: 

(Still works, but            deprecated)

```
hiera('some::key', 'the default value')Copied!
```

(Recommended) 

```
lookup('some::key', undef, undef, 'the default value')Copied!
```

Look up a key and returning the first value found:            

```
lookup('ntp::service_name')Copied!
```

A            unique merge lookup of class names, then adding all of those classes to the catalog:            

```
lookup('classes', Array[String], 'unique').includeCopied!
```

A            deep hash merge lookup of user data, but letting higher priority sources remove values            by prefixing them with:            

```
lookup( { 'name'  => 'users',
          'merge' => {
            'strategy'        => 'deep',
            'knockout_prefix' => '--',
          },
})Copied!
```

## The `puppet            lookup` command

The `puppet            lookup` command is the command line interface (CLI) for Puppet's lookup function.

The `puppet lookup`            command lets you do Hiera lookups from the command line.            You must run it on a node that has a copy of your Hiera            data. You can log into a Puppet Server node and run                `puppet lookup` with                `sudo`.

The most common version of this command is:

```
puppet lookup <KEY> --node <NAME> --environment <ENV> --explainCopied!
```

The `puppet lookup`            command searches your Hiera data and returns a value for            the requested lookup key, so you can test and explore your data. It replaces the `hiera` command. Hiera relies on a node's facts to locate the relevant            data sources. By default, `puppet                lookup` uses facts from the node you run the command on, but you can get            data for any other node with the `--node NAME` option. If possible, the lookup command uses the requested            node's real stored facts from PuppetDB. If PuppetDB is not configured or you want to provide other            fact values, pass facts from a JSON or YAML file with the `--facts FILE` option.

Note: The `puppet lookup` command replaces the `hiera` command.

### Examples

To look up `key_name` using the Puppet Server node’s facts:                

```
$ puppet lookup key_nameCopied!
```

To                look up `key_name` with `agent.local`'s                facts:

```
$ puppet lookup --node agent.local key_nameCopied!
```

To                get the first value found for `key_name_one` and                    `key_name_two` with `agent.local`'s facts while                merging values and knocking out the prefix 'example' while                merging:

```
puppet lookup --node agent.local --merge deep --knock-out-prefix example key_name_one key_name_twoCopied!
```

To                lookup `key_name` with `agent.local`'s facts, and                return a default value of `0` if nothing is                found:

```
puppet lookup --node agent.local --default 0 key_nameCopied!
```

To                see an explanation of how the value for `key_name` is                found, using `agent.local`                facts:

```
puppet lookup --node agent.local --explain key_nameCopied!
```

### Options 

The `puppet lookup` command has the following command options: 

- ​                            `--help`: Print a usage message.
- ​                            `--explain`: Explain the details of how the lookup was                            performed and where the final value came from, or the reason no value                            was found. Useful when debugging Hiera                            data. If `--explain` isn't specified, lookup exits with 0                            if a value was found and 1 if not. With `--explain`,                            lookup always exits with 0 unless there is a major error. You can                            provide multiple lookup keys to this command, but it only returns a                            value for the first found key, omitting the rest.
- ​                            `--node <NODE-NAME>`: Specify which node to look up                            data for; defaults to the node where the command is run. The purpose of                                Hiera is to provide different values                            for different nodes; use specific node facts to explore your data. If                            the node where you're running this command is configured to talk to PuppetDB, the command uses the requested                            node's most recent facts. Otherwise, override facts with the '--facts'                            option.
- ​                            `--facts <FILE>`: Specify a JSON or YAML file that                            contains key-value mappings to override the facts for this lookup. Any                            facts not specified in this file maintain their original value.
- ​                            `--environment <ENV>`: Specify an environment.                            Different environments can have different Hiera data.
- ​                            `--merge first/unique/hash/deep`: Specify the merge                            behavior, overriding any merge behavior from the data's                                `lookup_options`.
- ​                            `--knock-out-prefix <PREFIX-STRING>`: Used with                            'deep' merge. Specifies a prefix to indicate a value should be removed                            from the final result.
- ​                            `--sort-merged-arrays`: Used with 'deep' merge. When this                            flag is used, all merged arrays are sorted.
- ​                            `--merge-hash-arrays`: Used with the 'deep' merge                            strategy. When this flag is used, hashes within arrays are deep-merged                            with their counterparts by position.
- ​                            `--explain-options`: Explain whether a                                `lookup_options` hash affects this lookup, and how                            that hash was assembled. (`lookup_options` is how Hiera configures merge behavior in                            data.)
- ​                            `--default <VALUE>`: A value to return if Hiera can't find a value in data. Useful                            for emulating a call to the `lookup function that includes a                            default.
- ​                            `--type <TYPESTRING>`: Assert that the value has                            the specified type. Useful for emulating a call to the                                `lookup` function that includes a data type.
- ​                            `--compile`: Perform a full catalog compilation prior to                            the lookup. If your hierarchy and data only use the                                `$facts`, `$trusted`, and                                `$server_facts` variables, you don't need this                            option. If your Hiera configuration uses                            arbitrary variables set by a Puppet                            manifest, you need this to get accurate data. The `lookup` command doesn't cause catalog compilation unless                            this flag is given.
- ​                            `--render-as s/json/yaml/binary/msgpack`: Specify the                            output format of the results; `s` means plain text. The                            default when producing a value is `yaml` and the default                            when producing an explanation is `s`.

## Access hash and array elements using a `key.subkey` notation

Access hash and array members in Hiera using a `key.subkey` notation. 

You can access hash and array elements when doing the following things: 

- Interpolating variables into `hiera.yaml`                            or a data file. Many of the most commonly used variables, for example                                `facts` and `trusted`, are deeply nested data structures. 
- Using the `lookup` function or the `puppet lookup` command. If the value of                                `lookup('some_key')` is a hash or                            array, look up a single member of it by using `lookup('some_key.subkey')`. 
- Using interpolation functions that do Hiera lookups, for example `lookup` and                                `alias`. 

To access a single member of an array or hash:

Use the name of the value followed by a period                        (`.`) and a subkey. 

- If the value is an array,                                    the subkey must be an integer, for example: `users.0`                                    returns the first entry in the `users` array.
- If the value is a hash,                                    the subkey must be the name of a key in that hash, for example,                                        `facts.os`.
- To access values in nested                                    data structures, you can chain subkeys together. For example,                                    because the value of `facts.system_uptime` is a hash, you                                    can access its hours key with `facts.system_uptime.hours`.

Example:

To look up the value of `home` in this                        data:

```
accounts::users:
  ubuntu:
    home: '/var/local/home/ubuntu'Copied!
```

You would use the following `lookup` command:

```
lookup('accounts::users.ubuntu.home')Copied!
```

## Hiera dotted notation 

The Hiera dotted notation        does not support arbitrary expressions for subkeys; only literal keys are valid.

A hash can include literal dots in                the text of a key. For example, the value of `$trusted['extensions']` is a hash containing any certificate extensions                for a node, but some of its keys can be raw OID strings like `'1.3.6.1.4.1.34380.1.2.1'`. You                can access those values in Hiera with the `key.subkey` notation, but you must put                quotation marks — single or double — around the affected subkey. If the entire                compound key is quoted (for example, as required by the lookup interpolation                function), use the other kind of quote for the subkey, and escape quotes (as needed                by your data file format) to ensure that you don't prematurely terminate the whole                string.

For                    example:

```
aliased_key: "%{lookup('other_key.\"dotted.subkey\"')}"
# Or:
aliased_key: "%{lookup(\"other_key.'dotted.subkey'\")}"
Copied!
```

Note: Using extra quotes prevents digging into                    dotted keys. For example, if the lookup key contains a dot (`.`) then the entire key must                    be enclosed within single quotes within double quotes, for example,`                    lookup("'has.dot'")`.

# Writing new data backends 

### Sections

[Custom backends overview ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom_backends_overview)

- [                 `data_hash`             ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom-backends-data-hash)
- [                 `lookup_key`             ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom-backends-lookup-key)
- [                 `data_dig`             ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom-backends-data-dig)
- [The `RichDataKey` and `RichData` types](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom-backends-richdatakey-richdata-types)

[ `data_hash` backends ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data_hash_backends)

- [Arguments](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data-hash-backends-arguments)
- [Return type](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data-hash-backends-return-type)

[ `lookup_key` backends ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#lookup_key_backends)

- [Arguments](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#lookup-arguments)
- [Return type ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#lookup-return-type)

[ `data_dig` backends ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data_dig_backend)

- [Arguments](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data-dig-backend-arguments)
- [Return type ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data-dig-backend-return-type)

[ Hiera calling conventions for backend                         functions ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#calling_conventions)

[The options hash ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#options_hash)

[The `Puppet::LookupContext` object and methods ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#puppet_lookup_context)

- [         `not_found()`       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#not-found)
- [         `interpolate(value) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#interpolate)
- [         `environment_name() `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#environment-name)
- [         `module_name() `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#module-name)
- [         `cache(key, value) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cache)
- [         `cache_all(hash) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cache-all)
- [         `cached_value(key) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cached-value)
- [         `cache_has_key(key) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cache-has-key)
- [         `cached_entries() `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cached-entries)
- [         `cached_file_data(path) `       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#cached-file-data)
- [         `explain() { ‘message’ }`       ](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#explain)

Expand

You can extend Hiera to        look up values in data sources, for example, a PostgreSQL database table, a custom web app,        or a new kind of structured data file.

To teach Hiera how to talk to other            data sources, write a custom backend.

Important: Writing a custom backend                is an advanced topic. Before proceeding, make sure you really need it. It is also                worth asking the puppet-dev mailing list or Slack channel to see whether there is                one you can re-use, rather than starting from scratch.

## Custom backends overview 

A backend is a custom Puppet function that accepts a particular set of arguments and whose return value obeys a        particular format. The function can do whatever is necessary to locate its data.

A backend function uses the modern Ruby            functions API or the Puppet language. This means you can            use different versions of a Hiera backend in different            environments, and you can distribute Hiera backends in                Puppet modules.

Different types of data have different performance characteristics. To            make sure Hiera performs well with every type of data            source, it supports three types of backends: `data_hash`, `lookup_key`,            and `data_dig`.

###                 `data_hash`            

For data sources where it’s inexpensive, performance-wise, to read the entire                contents at one time, like simple files on disk. We suggest using the `data_hash` backend type if: 

- The cache is alive for the duration of one compilation
- The data is small
- The data can be retrieved all at one time
- Most of the data gets used
- The data is static

For more information, see [data_hash                     backends](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data_hash_backends).

###                 `lookup_key`            

For data sources where looking up a key is relatively expensive, performance-wise,                like an HTTPS API. We suggest using the `lookup_key`                backend type if:

- The data set is big, but only a small portion is used
- The result can vary during the compilation

The `hiera-eyaml` backend is a `lookup_key` function, because decryption tends to affect                performance; as a given node uses only a subset of the available secrets, it makes                sense to decrypt only on-demand.

For more information, see [lookup_key                     backends](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#lookup_key_backends).

###                 `data_dig`            

For data sources that can access arbitrary elements of hash or array values before                passing anything back to Hiera, like a database.

For more information, see [data_dig                 backends](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#data_dig_backend).

### The `RichDataKey` and `RichData` types

To simplify backend function signatures, you can use two extra data type aliases:                    `RichDataKey` and `RichData`. These are only available to backend functions called by Hiera; normal functions and Puppet code can not use them.

For more information, see [custom Puppet functions](https://www.puppet.com/docs/puppet/7/lang_write_functions_in_puppet.html#lang_write_functions_in_puppet), [the modern                     Ruby functions API](https://www.puppet.com/docs/puppet/7/functions_ruby_overview.html).

## `data_hash` backends 

A `data_hash`    backend function reads an entire data source at one time, and returns its contents as a    hash.

The built-in YAML, JSON, and HOCON        backends are all `data_hash` functions. You        can view their source on GitHub: 

- ​              [yaml_data.rb](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/yaml_data.rb)            
- ​              [json_data.rb](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/json_data.rb)            
- ​              [hocon_data.rb](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/hocon_data.rb)            

### Arguments

Hiera calls a `data_hash`        function with two arguments: 

- A hash of options 
  - The options hash contains a `path` when the entry                  in hiera.yaml is using `path`, `paths`, `glob`, `globs`, or `mapped_paths`,                  and the backend receives one call per path to an existing file. When the entry in                    `hiera.yaml` is using `uri` or `uris`, the options hash has a                    `uri` key, and the backend function is called one                  time per given uri. When `uri` or `uris` are used, Hiera does                  not perform an existence check. It is up to the function to type the options                  parameter as wanted. 
- A `Puppet::LookupContext` object 

### Return type

The function must either call the context object’s `not_found` method, or return a hash of lookup keys and their associated values.        The hash can be empty.

Puppet language example        signature:

```
function mymodule::hiera_backend(
  Hash                  $options,
  Puppet::LookupContext $context,
)Copied!
```

​        Ruby example signature:

```
dispatch :hiera_backend do
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
endCopied!
```

The returned hash can include the `lookup_options` key to        configure merge behavior for other keys. See Configuring merge behavior in Hiera data for more information. Values in the returned hash        can include Hiera interpolation tokens like `%{variable}` or `%{lookup('key')}`;          Hiera interpolates values as needed. This is a significant        difference between `data_hash` and the other two backend        types; `lookup_key` and `data_dig` functions have to explicitly handle interpolation.

**Related information**

- [Configure merge behavior in data](https://www.puppet.com/docs/puppet/7/configure_merge_behavior_hiera.html)

## `lookup_key` backends 

A `lookup_key` backend function looks up a single key and returns its value. For    example, the built-in `hiera_eyaml` backend is a      `lookup_key` function. 

You can view its source on Git at [eyaml_lookup_key.rb](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/functions/eyaml_lookup_key.rb).

### Arguments

Hiera calls a `lookup_key` function with        three arguments: 

- A key to look up.
- A hash of options.
- A `Puppet::LookupContext` object.

### Return type 

The function must either call the context object’s `not_found` method, or        return a value for the requested key. It can return undef as a value.

Puppet language example          signature:

```
function mymodule::hiera_backend(
  Variant[String, Numeric] $key,
  Hash                     $options,
  Puppet::LookupContext    $context,
)Copied!
```

Ruby example        signature:

```
dispatch :hiera_backend do
  param 'Variant[String, Numeric]', :key
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
endCopied!
```

A `lookup_key` function can return a hash for the the          `lookup_options` key to configure merge behavior for other keys. See        Configuring merge behavior in Hiera data for more        information. To support Hiera interpolation tokens, for        example, `%{variable}` or `%{lookup('key')}` in your data,        call `context.interpolate` on your values before returning them.

**Related information**

- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)
- [Hiera calling conventions for backend functions](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#calling_conventions)

## `data_dig` backends 

A `data_dig`    backend function is similar to a `lookup_key`    function, but instead of looking up a single key, it looks up a single sequence of keys and    subkeys.

Hiera        lets you look up individual members of hash and array values using `key.subkey` notation. Use `data_dig` types in cases where: 

- Lookups are relatively expensive.
- The data source knows how to extract              elements from hash and array values. 
- Users are likely to pass `key.subkey` requests to the `lookup` function to access subsets of large data              structures.

### Arguments

Hiera calls a `data_dig` function with three        arguments: 

- An array of lookup key segments, made by splitting the requested lookup key on the              dot (`.`) subkey separator. For example, a lookup for                `users.dbadmin.uid` results in `['users', 'dbadmin',                'uid']`. Positive base-10 integer subkeys (for accessing array members) are              converted to Integer objects, but other number subkeys remain as strings.
- A hash of options.
- A `Puppet::LookupContext` object.

### Return type 

The function must either call the context object’s `not_found` method, or        return a value for the requested sequence of key segments. Note that returning undef (nil in          Ruby) means that the key was found but that the value for        that key was specified to be undef. Puppet language example          signature:

```
function mymodule::hiera_backend(
  Array[Variant[String, Numeric]] $segments,
  Hash                            $options,
  Puppet::LookupContext           $context,
)Copied!
```

Ruby example        signature:

```
dispatch :hiera_backend do
  param 'Array[Variant[String, Numeric]]', :segments
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
endCopied!
```

A `data_dig` function can return a hash for the the          `lookup_options` key to configure merge behavior for other keys. See        Configuring merge behavior in Hiera data for more info.

To support Hiera interpolation tokens like          `%{variable}` or `%{lookup('key')}` in your data, call          `context.interpolate` on your values before returning them.

**Related information**

- [Configure merge behavior in data](https://www.puppet.com/docs/puppet/7/configure_merge_behavior_hiera.html)
- [Access hash and array elements using a key.subkey notation](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#access_hash_array-elements_keysubkey_notation)

## Hiera calling conventions for backend                        functions 

​                        Hiera uses the following conventions when                        calling backend functions.

​                                    Hiera calls `data_hash` one time                                    per data source, calls `lookup_key` functions one time per data                                    source for every unique key lookup, and calls `data_dig` functions                                    one time per data source for every unique sequence of key                                    segments.

However, a given hierarchy level can refer to multiple                                    data sources with the `path`, `paths`, `uri`, `uris`,                                                `glob`, and `globs` settings. Hiera handles each                                    hierarchy level as follows:

- If the `path`, `paths`, `glob`, or                                                  `globs` settings are used, Hiera determines which                                                files exist and calls the function one time for                                                each. If no files were found, the function is not be                                                called.
- If the `uri` or `uris` settings are                                                used, Hiera calls the                                                function one time per URI.
- If none of those settings are used, Hiera calls the                                                function one time.

​                                    Hiera can call a function again                                    for a given data source, if the inputs change. For example, if                                                `hiera.yaml` interpolates a local variable                                    in a file path, Hiera calls the                                    function again for scopes where that variable has a different                                    value. This has a significant performance impact, so you must                                    interpolate only facts, trusted facts, and server facts in the                                    hierarchy.

## The options hash 

Hierarchy levels are configured in the `hiera.yaml` file. When calling a backend    function, Hiera passes a modified version of that configuration    as a hash.

The options hash can contain (depending on whether `path`, `glob`, `uri`, or`mapped_paths` have been set) the following keys: 

- `path` - The absolute path to a file on disk. It is present only            if `path`, `paths`, `glob`, `globs`, or `mapped_paths` is present in the hierarchy. Hiera never calls the function unless the file is present.          
- `uri` - A uri that your function can use to locate a data            source. It is present only if `uri` or `uris`            is present in the hierarchy. Hiera does not verify the            URI before passing it to the function.
- Every key from the hierarchy level’s `options` setting. List any            options your backend requires or accepts. The `path` and `uri` keys are reserved.

Note: If your backend uses data files,        use the context object’s `cached_file_data` method to read them.

For example, the following hierarchy level in `hiera.yaml` results in several different options      hashes, depending on such things as the current node’s facts and whether the files exist:

```
- name: "Secret data: per-node, per-datacenter, common"
    lookup_key: eyaml_lookup_key # eyaml backend
    datadir: data
    paths:
      - "secrets/nodes/%{trusted.certname}.eyaml"
      - "secrets/location/%{facts.whereami}.eyaml"
      - "common.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pemCopied!
```

The various hashes would all be similar to this:

```
{
  'path' => '/etc/puppetlabs/code/environments/production/data/secrets/nodes/web01.example.com.eyaml',
  'pkcs7_private_key' => '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem',
  'pkcs7_public_key' => '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem'
}Copied!
```

In your function’s signature, you can validate the options hash by using      the Struct data type to restrict its contents. In particular, note you can disable all of the        `path`, `paths`, `glob`, and `globs` settings for your backend by disallowing the `path` key in the options hash.

For more information, see [the Struct data       type](https://www.puppet.com/docs/puppet/7/lang_data_abstract.html#lang_data_abstract).

**Related information**

- [Configure merge behavior in data](https://www.puppet.com/docs/puppet/7/configure_merge_behavior_hiera.html)
- [Configuring a hierarchy level: hiera-eyaml](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_eyaml)
- [Interpolation](https://www.puppet.com/docs/puppet/7/hiera_merging.html#hiera_interpolation)

## The `Puppet::LookupContext` object and methods 

To support caching and other backends needs, Hiera provides a `Puppet::LookupContext` object.

In Ruby        functions, the context object is a normal Ruby object of        class `Puppet::LookupContext`, and you can        call methods with standard Ruby syntax, for example `context.not_found`.

In          Puppet language functions, the context object appears as        the special data type `Puppet::LookupContext`, that has methods attached.You can call the context’s        methods using Puppet’s chained function call syntax with the        method name instead of a normal function call syntax, for example, `$context.not_found`. For methods that take a block, use Puppet’s lambda syntax (parameters outside block) instead of          Ruby’s block syntax (parameters inside      block).

###         `not_found()`      

Tells Hiera to halt this lookup and move on to the next data        source. Call this method when your function cannot find a matching key or a given lookup.        This method returns no value.

For `data_hash` backends, return an empty hash. The empty hash results in          `not_found`, and prevents further calls to the provider. Missing data        sources are not an issue when using `path`, `paths`, `glob`, or `globs`, but are important for backends that locate their own data sources.

For `lookup_key` and `data_dig` backends, use          `not_found` when a requested key is not present in the data source or the        data source does not exist. Do not return `undef` or `nil` for        missing keys, as these are legal values that can be set in data.

###         `interpolate(value) `      

Returns the provided value, but with any Hiera interpolation        tokens (`%{variable}` or `%{lookup('key')}`) replaced by their        value. This lets you opt-in to allowing Hiera-style        interpolation in your backend’s data sources. It works recursively on arrays and hashes.        Hashes can interpolate into both keys and values.

In `data_hash` backends, support for interpolation is built in, and you do        not need to call this method.

In `lookup_key` and `data_dig` backends, call this method if        you want to support interpolation.

###         `environment_name() `      

Returns the name of the environment, regardless of layer.

###         `module_name() `      

Returns the name of the module whose `hiera.yaml` called the function.        Returns `undef` (in Puppet) or          `nil` (in Ruby) if the function was called        by the global or environment layer.

###         `cache(key, value) `      

Caches a value, in a per-data-source private cache. It also returns the cached value.

On future lookups in this data source, you can retrieve values by calling          `cached_value(key)`. Cached values are immutable, but you can replace the        value for an existing key. Cache keys can be anything valid as a key for a Ruby hash, including `nil`.

For example, on its first invocation for a given YAML file, the built-in          `eyaml_lookup_key` backend reads the whole file and caches it, and then        decrypts only the specific value that was requested. On subsequent lookups into that file,        it gets the encrypted value from the cache instead of reading the file from disk again. It        also caches decrypted values so that it won’t have to decrypt again if the same key is        looked up repeatedly.

The cache is useful for storing session keys or connection objects for backends that access        a network service.

Each `Puppet::LookupContext` cache lasts for the duration of the current        catalog compilation. A node can’t access values cached for a previous node.

​        Hiera creates a separate cache for each combination of inputs        for a function call, including inputs like `name` that are configured in          `hiera.yaml` but not passed to the function. Each hierarchy level has its        own cache, and hierarchy levels that use multiple paths have a separate cache for each        path.

If any inputs to a function change, for example, a path interpolates a local variable whose        value changes between lookups, Hiera uses a fresh cache.

###         `cache_all(hash) `      

Caches all the key-value pairs from a given hash. Returns `undef` (in Puppet) or `nil` (in Ruby).

###         `cached_value(key) `      

Returns a previously cached value from the per-data-source private cache. Returns          `undef` or `nil` if no value with this name has been        cached.

###         `cache_has_key(key) `      

Checks whether the cache has a value for a given key yet. Returns `true` or          `false`.

###         `cached_entries() `      

Returns everything in the `per-data-source` cache as an iterable object. The        returned object is not a hash. If you want a hash, use          `Hash($context.all_cached())` in the Puppet        language or `Hash[context.all_cached()]` in Ruby.

###         `cached_file_data(path) `      

​        Puppet syntax:

​        `cached_file_data(path) |content| { ... }`      

​        Ruby syntax:

​        `cached_file_data(path) {|content| ...}`      

For best performance, use this method to read files in Hiera        backends.

`cached_file_data(path) {|content| ...}` returns the content of the specified        file as a string. If an optional block is provided, it passes the content to the block and        returns the block’s return value. For example, the built-in JSON backend uses a block to        parse JSON and return a hash:        

```
context.cached_file_data(path) do |content|
      begin
        JSON.parse(content)
      rescue JSON::ParserError => ex
        # Filename not included in message, so we add it here.
        raise Puppet::DataBinding::LookupError, "Unable to parse (#{path}): #{ex.message}"
      end
    endCopied!
```

On repeated access to a given file, Hiera checks whether the        file has changed on disk. If it hasn’t, Hiera uses cached        data instead of reading and parsing the file again.

This method does not use the same `per-data-source` caches as          `cache(key, value)` and similar methods. It uses a separate cache that        lasts across multiple catalog compilations, and is tied to Puppet Server’s environment cache.

Because the cache can outlive a given node’s catalog compilation, do not do any        node-specific pre-processing (like calling `context.interpolate`) in this        method’s block.

###         `explain() { ‘message’ }`      

​        Puppet syntax:

​        `explain() || { 'message' }`      

​        Ruby syntax:

​        `explain() { 'message' }`      

In both Puppet and Ruby, the        provided block must take zero arguments.

​        `explain() { 'message' }` adds a message, which appears in        debug messages or when using puppet lookup --explain. The block provided to this function        must return a string.

The explain method is useful for complex lookups where a function tries several different        things before arriving at the value. The built-in backends do not use the explain method,        and they still have relatively verbose explanations. This method is for when you need to        provide even more detail.

​        Hiera never executes the explain block unless explain is        enabled.

# Debugging Hiera

### Sections

[Syntax errors](https://www.puppet.com/docs/puppet/7/debugging_hiera.html#debug_hiera_syntax_error)

[Unexpected values](https://www.puppet.com/docs/puppet/7/debugging_hiera.html#debug_hiera_unexpected_value)

[Common errors](https://www.puppet.com/docs/puppet/7/debugging_hiera.html#debug_hiera_specific_errors)

When debugging Hiera, `puppet lookup`        can help identify exactly what Hiera was doing when it raised        an error, or how it decided to look up a key and where it got its value.

Use these examples to guide you in debugging Hiera with            the `puppet lookup` command.

## Syntax errors

Consider the following error message.

```
SERVER: Evaluation Error: Error while evaluating a Resource Statement, Lookup of key 'pe_console_prune::ensure_prune_cron' failed: DataBinding 'hiera': (<unknown>): mapping values are not allowed here at line 2 column 68 on node master.inf.puppetlabs.demo
Copied!
```

1. To debug this, run the following command on the primary node:  

   ```
   puppet lookup pe_console_prune::ensure_prune_cronCopied!
   ```

   Note that all the rest of the errors and logging around the error are cleared.

2. To get more information, add the `--debug` flag:

   ```
   puppet lookup --debug pe_console_prune::ensure_prune_cronCopied!
   ```

3. Look at the last few lines of output from the `puppet            lookup` command:

   ```
   ...
   Debug: hiera(): [eyaml_backend]: Hiera eYAML backend starting
   ...
   Debug: hiera(): Hiera YAML backend starting
   Debug: hiera(): Looking up lookup_options in YAML backend
   Debug: hiera(): Looking for data source     nodes/master.inf.puppetlabs.demo
   Debug: hiera(): Cannot find datafile /etc/puppetlabs/code/environments/production/hieradata/nodes/master.inf.puppetlabs.demo.yaml, skipping
   Debug: hiera(): Looking for data source environment/production
   Debug: hiera(): Looking for data source datacenter/infrastructure
   Debug: hiera(): Looking for data source virtual/virtualbox
   Debug: hiera(): Looking for data source common
   Error: Could not run: Evaluation Error: Error while evaluating a Resource Statement, Lookup of key 'pe_console_prune::ensure_prune_cron' failed: DataBinding 'hiera': (<unknown>): mapping values are not allowed in this context at line 2 column 68Copied!
   ```

Results

In this example, the last thing Hiera was doing when it        threw the error was looking for the `common` datasource in the YAML backend.        That is, it was reading `common.yaml`. Therefore, the syntax error must be in          `common.yaml`.

## Unexpected values

Sometimes Hiera does not throw an error, but still fails    to return the value you expect.

For example, if you think your node is configured to use `au.pool.ntp.org`        but it is actually configured with `us.pool.ntp.org`, there is no error        message but something is wrong.

The `lookup` command accepts a `--node` flag to set the node        context for performing the lookup. If `--node` isn’t passed, the default is        the context of the node on which the command runs.

1. To determine why one of your secondary nodes is getting a particular value for the            `ntp::servers` parameter, use lookup and the `--node` flag          to inspect the process:

   ```
   [root@master ~]# puppet lookup --node centos7a.pdx.puppetlabs.local --debug ntp::servers
   ...
   Debug: hiera(): Looking up ntp::servers in YAML backend
   Debug: hiera(): Looking for data source nodes/centos7a.pdx.puppetlabs.demo
   Debug: hiera(): Cannot find datafile /etc/puppetlabs/code/environments/production/hieradata/nodes/centos7a.pdx.puppetlabs.demo.yaml, skipping
   Debug: hiera(): Looking for data source environment/production
   Debug: hiera(): Looking for data source datacenter/portland
   Debug: hiera(): Found ntp::servers in datacenter/portland
   ---
   - 0.us.pool.ntp.org
   - 1.us.pool.ntp.org
   - 2.us.pool.ntp.org
   - 3.us.pool.ntp.orgCopied!
   ```

   Here you can see how Hiera walks through the fully            evaluated version of the hierarchy for the target node. The original hierarchy is full            of variables for interpolation: 

   ```
   :hierarchy:
     - nodes/%{clientcert}
     - environment/%{environment}
     - datacenter/%{datacenter}
     - virtual/%{virtual}
     - commonCopied!
   ```

2. ​        In the `lookup` debug output, you can see that for this          node, `environment/%{environment}` evaluates to `environment/production`, but Hiera          does not find any data there for `ntp:servers`. And so on,          down the hierarchy. This visibility gives you what you need to think through the lookup          process step by step, and confirm with each iteration whether or not everything is working          correctly.      

## Common errors

In addition to knowing how to use the `puppet lookup`    command, knowing some common errors can be useful in debugging Hiera.



1. Error: 

   ```
   Error: Could not run: (<unknown>): mapping values are not allowed in this context at line 2 column 8
   Error: Could not run: (<unknown>): did not find expected '-' indicator while parsing a block collection at line 1 column 1Copied!
   ```

   Cause:

   The opening `---` could be malformed. If it gets converted into a            unicode character, such as `—`, or if there is a space at the start of            the line `---`, or in between the three dashes `- --`, you            might get an error like this.

2. Error: 

   ```
   Error: Could not run: (<unknown>): mapping values are not allowed in this context at line 3 column 10
   Copied!
   ```

   Cause: 

   This can be caused by using tabs for indentation instead of spaces. In general, avoid            tab characters in yaml files.

3. Error: 

   ```
   Error: Could not run: Hiera type mismatch: expected Hash and got String
   Error: Could not run: Hiera type mismatch: expected Hash and got Array
   Error: Could not run: Hiera type mismatch: expected Array and got HashCopied!
   ```

   These types of errors often happen when you use `hiera_array()` or              `hiera_hash()`, but one or more of the found values are of a data type            incompatible with that lookup.

# Upgrading to Hiera 5 

### Sections

[Considerations for hiera-eyaml users](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#considerations-for-hiera-yaml-users)

[Considerations for custom backend users](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#considerations-for-custom-backend-users)

[Considerations for custom `data_binding_terminus` users](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#considerations-for-custom-data-binding-terminus-users)

[Enable the environment layer for existing Hiera data ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#enable_environment_layer)

[Convert a version 3 `hiera.yaml` to version 5](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#convert_hiera_yaml)

[Convert an experimental (version 4) `hiera.yaml` to version 5 ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#convert_experimental_hiera_yaml)

[Convert experimental data provider functions to a Hiera 5 `data_hash` backend](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#convert_data_provider_functions)

[Updated classic Hiera function calls ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#updated_classic_hiera_function_calls)

[Adding Hiera data to a         module ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#adding_hiera_data_module)

- [Module data with the `params.pp` pattern ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#module_data_params)
- [Module data with a one-off custom Hiera backend](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#module_data_custom_hiera_backend)
- [Module data with YAML data files ](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#module_data_yaml_data_files)

Expand

Upgrading to Hiera 5 offers        some major advantages. A real environment data layer means changes to your hierarchy are now        routine and testable, using multiple backends in your hierarchy is easier and you can make a        custom backend.

Note: If you’re already a Hiera user, you can use your current code with Hiera 5 without any changes to it. Hiera 5 is fully backward-compatible with Hiera 3. You can even start using some Hiera 5 features—like module data—without upgrading                anything.

​            Hiera 5 uses the same built-in data formats as Hiera 3. You don't need to do mass edits of any data            files.

Updating your code to take advantage of Hiera 5 features involves the following tasks:

| Task                                                         | Benefit                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Enable the environment layer,                            by giving each environment its own `hiera.yaml `file.  Note: Enabling the environment layer takes the most work,                                but yields the biggest benefits. Focus on that first, then do the                                rest at your own pace. | Future hierarchy changes are                            cheap and testable. The legacy Hiera functions (`hiera`, `hiera_array`,                                `hiera_hash`, and `hiera_include`) gain full Hiera 5 powers in any migrated                            environment, only if there is a `hiera.yaml` in the environment root. |
| Convert your global `hiera.yaml`                            file to the version 5 format. | You can use new Hiera 5 backends at the global                            layer. |
| Convert any experimental                            (version 4) `hiera.yaml` files to version 5. | Future-proof any environments                            or modules where you used the experimental version of Puppet lookup. |
| In Puppet code, replace legacy Hiera                            functions (`hiera`, `hiera_array`, `hiera_hash`, and `hiera_include`) with `lookup()`. | Future-proof your Puppet code.                               |
| Use Hiera for default data in modules.                       | Simplify your modules with an                            elegant alternative to the "`params.pp`" pattern. |

## Considerations for hiera-eyaml users

Upgrade now. In Puppet 4.9.3, we added a built-in                hiera-eyaml backend for Hiera 5. (It still requires that the `hiera-eyaml` gem be installed.) See the usage instructions in the                    `hiera.yaml` (v5) syntax reference. This means you                can move your existing encrypted YAML data into the environment layer at the same                time you move your other data.

## Considerations for custom backend users

Wait for updated backends. You can keep using custom Hiera 3 backends with Hiera 5, but they'll make upgrading more complex,                because you can't move legacy data to the environment layer until there's a Hiera 5 backend for it. If an updated version of the                backend is coming out soon, wait.

If you're using an off-the-shelf custom backend, check its website or contact its                developer. If you developed your backend in-house, read the documentation about                writing Hiera 5 backends.

## Considerations for custom `data_binding_terminus` users

Upgrade now, and replace it with a Hiera 5 backend as                soon as possible. There's a deprecated `data_binding_terminus`                setting in the `puppet.conf` file, which changes the behavior of                automatic class parameter lookup. It can be set to `hiera` (normal),                    `none` (deprecated; disables auto-lookup), or the name of a                custom plug-in.

With a custom `data_binding_terminus`, automatic lookup results are                different from function-based lookups for the same keys. If you're one of the few                who use this feature, you've already had to design your Puppet code to avoid that problem, so it's safe to                upgrade your configuration to Hiera 5. But because                we've deprecated that extension point, you have to replace your custom terminus with                a Hiera 5 backend.

If you're using an off-the-shelf plug-in, such as Jerakia, check its website or                contact its developer. If you developed your plug-in in-house, read the                documentation about writing Hiera 5 backends.

After you have a Hiera 5 backend, integrate it into                your hierarchies and delete the `data_binding_terminus` setting.

**Related information**

- [The Puppet lookup function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)
- [Config file syntax](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config_syntax)
- [Writing new data backends](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#hiera_custom_backends)
- [Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)

## Enable the environment layer for existing Hiera data 

A key feature in Hiera 5 is  per-environment hierarchy configuration. Because you probably store data in each environment,  local `hiera.yaml` files are more logical and  convenient than a single global hierarchy.

You can enable the    environment layer gradually. In migrated environments, the legacy Hiera functions switch to Hiera 5    mode — they can access environment and module data without requiring any code changes.

Note: Before migrating environment data to Hiera 5, read the introduction to migrating Hiera configurations. In particular, be aware that if you rely on     custom Hiera 3 backends, we recommend you upgrade them for Hiera 5 or prepare for some extra work during migration. If your     only custom backend is `hiera-eyaml`, continue upgrading — Puppet 4.9.3 and     higher include a Hiera 5 eyaml backend. See the usage     instructions in the `hiera.yaml`     (v5) syntax reference.

In each environment:

1. ​    Check your code for Hiera     function calls with "hierarchy override arguments" (as shown later), which cause errors.   

2. ​    Add a local `hiera.yaml` file.   

3. ​    Update your custom backends if you have them.   

4. Rename the data directory to exclude this environment from the     global layer. Unmigrated environments still rely on the global layer, which gets checked before     the environment layer. If you want to maintain both migrated and unmigrated environments during     the migration process, choose a different data directory name for migrated environments. The     new name 'data' is a good choice because it is also the new default (unless you are already     using 'data', in which case choose a different name and set `datadir` in `hiera.yaml`). This process has no particular time limit and doesn't     involve any downtime. After all of your environments are migrated, you can phase out or greatly     reduce the global hierarchy.

   Important: The environment layer does not support Hiera 3 backends. If any of your data uses a custom backend that       has not been ported to Hiera 5, omit those hierarchy levels       from the environment config and continue to use the global layer for that data. Because the       global layer is checked before the environment layer, it's possible to run into situations       where you cannot migrate data to the environment layer yet. For example, if your old `:backends` setting was `[custom_backend, yaml]`, you can do a partial       migration, because the custom data was all going before the YAML data anyway. But if `:backends` was `[yaml, custom_backend]`, and you frequently use YAML data to       override the custom data, you can't migrate until you have a Hiera 5 version of that custom backend. If you run into a       situation like this, get an upgraded backend before enabling the environment layer.

5. Check your Puppet code for     classic Hiera functions (`hiera`, `hiera_array`, `hiera_hash`, and `hiera_include`) that are passing the optional hierarchy override argument, and remove     the argument.

   In Hiera 5, the hierarchy override argument is an error.

   A quick way to find instances of using this argument is to search for calls      with two or more commas. Search your codebase using the following regular expression:      

   ```
   hiera(_array|_hash|_include)?\(([^,\)]*,){2,}[^\)]*\)Copied!
   ```

   This      results in some false positives, but helps find the errors before you run the code.

   Alternatively, continue to the next step and fix errors as they come up. If      you use environments for code testing and promotion, you’re probably migrating a temporary      branch of your control repo first, then pointing some canary nodes at it to make sure      everything works as expected. If you think you’ve never used hierarchy override arguments,      you’ll be verifying that assumption when you run your canary nodes. If you do find any errors,      you can fix them before merging your branch to production, the same way you would with any      work-in-progress code.

   Note: If your environments are similar to each other, you       might only need to check for the hierarchy override argument in function calls in one       environment. If you find none, likely the others won’t have many either.

6. ​    Choose a new data directory name to use in the next two steps.     The default data directory name in Hiera 3 was `<ENVIRONMENT>/hieradata`, and the default     in Hiera 5 is `<ENVIRONMENT>/data`. If you used the old default, use the new     default. If you were already using data, choose something different.   

7. Add a Hiera 5 `hiera.yaml` file to the environment.

   Each environment needs a Hiera config file that works with its existing data. If this is      the first environment you’re migrating, see converting a version 3 `hiera.yaml` to version 5. Make sure to reference the new       `datadir` name. If you’ve      already migrated at least one environment, copy the `hiera.yaml` file from a migrated environment and make changes to it if      necessary.

   Save the resulting file as `<ENVIRONMENT>/hiera.yaml`. For example, `/etc/puppetlabs/code/environments/production/hiera.yaml`.

8. ​    If any of your data relies on custom backends that have been     ported to Hiera 5, install them in the environment. Hiera 5 backends are distributed as Puppet modules, so each environment can use its own version of     them.   

9. If you use only file-based Hiera 5 backends, move the environment’s data directory by renaming it from its old name (`hieradata`) to its new name (`data`). If you use custom file-based      Hiera 3 backends, the global layer still needs access to their     data, so you need to sort the files: Hiera 5 data moves to the     new data directory, and Hiera 3 data stays in the old data     directory. When you have Hiera 5 versions of your custom     backends, you can move the remaining files to the new `datadir`. If you use non-file backends that don’t have a data     directory:

   1. ​      Decide that the global hierarchy is the right place for       configuring this data, and leave it there permanently.     
   2. ​      Do something equivalent to moving the `datadir`; for example, make a new database       table for migrated data and move values into place as you migrate environments.     
   3. ​      Allow the global and environment layers to use duplicated       configuration for this data until the migration is done.     

10. ​    Repeat these steps for each environment. If you manage your     code by mapping environments to branches in a control repo, you can migrate most of your     environments using your version control system’s merging tools.   

11. ​    After you have migrated the environments that have active node     populations, delete the parts of your global hierarchy that you transferred into environment     hierarchies.   

Results

For more information on mapping environments to branches, see [control repo](https://puppet.com/docs/pe/latest/cmgmt_control_repo.html).

**Related information**

- [Enable the environment layer for existing Hiera data](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#enable_environment_layer)
- [Configuring a hierarchy level: legacy Hiera 3 backends](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#legacy_hiera_3_backends)
- [Config file syntax](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config_syntax)
- [Custom backends overview](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom_backends_overview)

## Convert a version 3 `hiera.yaml` to version 5

​      Hiera 5 supports three versions of the `hiera.yaml` file: version 3, version 4, and version 5. If      you've been using Hiera 3, your existing configuration is a      version 3 `hiera.yaml` file at the global      layer.

There are two migration tasks that involve translating a version 3            config to a version 5: 

- Creating new v5 `hiera.yaml` files for environments. 
- Updating your global configuration to support Hiera 5 backends. 

These are essentially the same process, although the global hierarchy            has a few special capabilities.

Consider this example `hiera.yaml` version 3 file:            

```
:backends:
  - mongodb
  - eyaml
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost
:eyaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
  :pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
  :pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
:hierarchy:
  - "nodes/%{trusted.certname}"
  - "location/%{facts.whereami}/%{facts.group}"
  - "groups/%{facts.group}"
  - "os/%{facts.os.family}"
  - "common"
:logger: console
:merge_behavior: native
:deep_merge_options: {}Copied!
```

To            convert this version 3 file to version 5:

1. Use strings instead of symbols for keys.

   ​                  Hiera 3 required you to use Ruby symbols as keys. Symbols are short strings that                  start with a colon, for example, `:hierarchy`. The version 5 config format lets you use                  regular strings as keys, although symbols won’t (yet) cause errors. You can remove                  the leading colons on keys.

2. Remove settings that aren’t used anymore. In this               example, remove everything except the `:hierarchy` setting:

   1. Delete the following settings completely, which                     are no longer needed: 

      - ​                                 `:logger`                              
      - ​                                 `:merge_behavior`                              
      - ​                                 `:deep_merge_options`                              

      For information on how Hiera 5 supports deep hash                        merging, see Merging data from multiple sources.

   2. Delete the following settings, but paste them                     into a temporary file for later reference: 

      - ​                                 `:backends`                              
      - Any backend-specific setting sections, like                                    `:yaml` or `:mongodb`

3. Add a `version` key, with a value of `5`:

   ```
   version: 5
   hierarchy:
     # ...Copied!
   ```

4. Set a default backend and data directory.

   If you use one backend for the majority of your data, for                  example YAML or JSON, set a `defaults` key, with values for `datadir` and one of the backend keys.

   The names of the backends have changed for Hiera 5, and the `backend` setting itself has been split                  into three settings: 

   | Hiera 3 backend | Hiera 5 backend setting                                      |
   | --------------- | ------------------------------------------------------------ |
   | `yaml`          | `data_hash:                                    yaml_data`    |
   | `json`          | `data_hash:                                    json_data`    |
   | `eyaml`         | `lookup_key:                                    eyaml_lookup_key` |

5. Translate the hierarchy.

   The version 5 and version 3 hierarchies work differently: 

   - In version 3, hierarchy levels don’t have a backend                           assigned to them, and Hiera loops through                           the entire hierarchy for each backend. 
   - In version 5, each hierarchy level has one designated                           backend, as well as its own independent configuration for that                           backend.

   Consult the previous values for the `:backends` key and any backend-specific                  settings.

   In the example above, we used `yaml`, `eyaml`, and `mongodb` backends. Your business only uses                  Mongo for per-node data, and uses eyaml for per-group data. The rest of the                  hierarchy is irrelevant to these backends. You need one Mongo level and one eyaml                  level, but still want all five levels in YAML. This means Hiera consults multiple backends for per-node and                  per-group data. You want the YAML version of per-node data to be authoritative, so                  put it before the Mongo version. The eyaml data does not overlap with the                  unencrypted per-group data, so it doesn’t matter where you put it. Put it before                  the YAML levels. When you translate your hierarchy, you have to make the same                  kinds of investigations and decisions.

6. Remove hierarchy levels that use `calling_module`, `calling_class`, and `calling_class_path`, which were               allowed pseudo-variables in Hiera 3. Anything you were               doing with these variables is better accomplished by using the module data layer, or               by using the glob pattern (if the reason for using them was to enable splitting up               data into multiple files, and not knowing in advance what they names of those would               be)

   `Hiera.yaml` version 5 does not support these. Remove hierarchy levels                  that interpolate them.

7. Translate built-in backends to the version 5 config,               where the hierarchy is written as an array of hashes. For hierarchy levels that use               the built-in backends, for example YAML and JSON, use the `data_hash `key to set the backend. See               Configuring a hierarchy level in the `hiera.yaml` v5 reference for more information.

   Set the following keys: 

   - `name` - A human-readable name. 
   - `path` or `paths` - The path you used in your version 3                              `hiera.yaml` hierarchy, but with a file extension appended.                        
   - `data_hash` - The backend to use `yaml_data` for YAML, `json_data` for                           JSON. 
   - `datadir` - The data directory. In version 5, it’s relative to                           the `hiera.yaml` file’s directory. 

   If you have set default values for `data_hash` and `datadir`, you can omit                  them.

   ```
   version: 5
   defaults:
     datadir: data
     data_hash: yaml_data
   hierarchy:
     - name: "Per-node data (yaml version)"
       path: "nodes/%{trusted.certname}.yaml" # Add file extension.
       # Omitting datadir and data_hash to use defaults.
   
     - name: "Other YAML hierarchy levels"
       paths: # Can specify an array of paths instead of one.
         - "location/%{facts.whereami}/%{facts.group}.yaml"
         - "groups/%{facts.group}.yaml"
         - "os/%{facts.os.family}.yaml"
         - "common.yaml"Copied!
   ```

8. Translate `hiera-eyaml` backends, which work in a similar way to the               other built-in backends. 

   The differences are: 

   - The `hiera-eyaml `gem has to be installed, and you                           need a different backend setting. Instead of `data_hash: yaml,` use l`ookup_key:                              eyaml_lookup_key.` Each hierarchy level needs an `options` key                           with paths to the public and private keys. You cannot set a global                           default for                           this.

     ```
     - name: "Per-group secrets"
        path: "groups/%{facts.group}.eyaml"
        lookup_key: eyaml_lookup_key
        options:
          pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
          pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
     Copied!
     ```

9. Translate custom Hiera               3 backends.

   Check to see if the backend’s author has published a Hiera 5 update for it. If so, use that; see its                  documentation for details on how to configure hierarchy levels for it.

   If there is no update, use the version 3 backend in a version 5                  hierarchy at the global layer — it does not work in the environment layer. Find a                     Hiera 5 compatible replacement, or write Hiera 5 backends yourself.

   For details on how to configure a legacy backend, see                  Configuring a hierarchy level (legacy Hiera 3                  backends) in the `hiera.yaml` (version 5) reference.

   When configuring a legacy backend, use the previous value for                  its backend-specific settings. In the example, the version 3 config had the                  following settings for                  MongoDB:

   ```
   :mongodb:
     :connections:
       :dbname: hdata
       :collection: config
       :host: localhostCopied!
   ```

   So,                  write the following for a per-node MongoDB hierarchy                  level:

   ```
   - name: "Per-node data (MongoDB version)"
      path: "nodes/%{trusted.certname}"      # No file extension
      hiera3_backend: mongodb
      options:    # Use old backend-specific options, changing keys to plain strings
        connections:
          dbname: hdata
          collection: config
          host: localhost
   Copied!
   ```

Results

After following these steps, you’ve translated the example            configuration into the following v5            config:

```
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/%{trusted.certname}.yaml" # Add file extension
    # Omitting datadir and data_hash to use defaults.

  - name: "Per-node data (MongoDB version)"
    path: "nodes/%{trusted.certname}"      # No file extension
    hiera3_backend: mongodb
    options:    # Use old backend-specific options, changing keys to plain strings
      connections:
        dbname: hdata
        collection: config
        host: localhost

  - name: "Per-group secrets"
    path: "groups/%{facts.group}.eyaml"
    lookup_key: eyaml_lookup_key
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of a single one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"Copied!
```

**Related information**

- [Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)
- [Custom backends overview](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom_backends_overview)
- [Configuring a hierarchy level: general format](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hierarchy_general_format)
- [Configuring a hierarchy level: hiera-eyaml](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_eyaml)

## Convert an experimental (version 4) `hiera.yaml` to version 5 

If you used the experimental version of Puppet lookup ( Hiera 5's    predecessor), you might have some version 4 `hiera.yaml` files in your environments and modules. Hiera 5 can use these, but you need to convert them, especially if    you want to use any backends other than YAML or JSON. Version 4 and version 5 formats are    similar.

Consider this example of a version 4 `hiera.yaml`        file:

```
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Nodes"
    backend: yaml
    path: "nodes/%{trusted.certname}"

  - name: "Exported JSON nodes"
    backend: json
    paths:
      - "nodes/%{trusted.certname}"
      - "insecure_nodes/%{facts.networking.fqdn}"

  - name: "virtual/%{facts.virtual}"
    backend: yaml

  - name: "common"
    backend: yamlCopied!
```

To convert to version 5, make the following changes:

1. ​         Change the value of the `version` key to `5`.      

2. ​        Add a file extension to every file path — use `"common.yaml"`, not `"common"`.      

3. ​        If any hierarchy levels are missing a path, add one. In          version 5, path no longer defaults to the value of name      

4. If there is a top-level `datadir` key, change it to a `defaults` key. Set a default backend. For          example:

   ```
   defaults:
     datadir: data
     data_hash: yaml_dataCopied!
   ```

5. In each hierarchy level, delete the `backend` key and replace it with a `data_hash` key. (If you set a          default backend in the defaults key, you can omit it here.) 

   | v4 backend      | v5 equivalent                                 |
   | --------------- | --------------------------------------------- |
   | `backend: yaml` | `data_hash:                        yaml_data` |
   | `backend: json` | `data_hash:                        json_data` |

6. Delete the `environment_data_provider` and `data_provider` settings, which enabled Puppet lookup for an environment or module. 

   You’ll find these settings in the following locations: 

   - `environment_data_provider` in `puppet.conf`.
   - `environment_data_provider` in `environment.conf`.
   - `data_provider` in a module’s `metadata.json`.

Results

After being converted to version 5, the example looks like this:

```
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 5
defaults:
  datadir: data          # Datadir has moved into `defaults`.
  data_hash: yaml_data   # Default backend: New feature in v5.
hierarchy:
  - name: "Nodes"        # Can omit `backend` if using the default.
    path: "nodes/%{trusted.certname}.yaml"   # Add file extension!

  - name: "Exported JSON nodes"
    data_hash: json_data        # Specifying a non-default backend.
    paths:
      - "nodes/%{trusted.certname}.json"
      - "insecure_nodes/%{facts.networking.fqdn}.json"

  - name: "Virtualization platform"
    path: "virtual/%{facts.virtual}.yaml"   # Name and path are now separated.

  - name: "common"
    path: "common.yaml"Copied!
```

For full syntax details, see the `hiera.yaml` version 5 reference.

**Related information**

- [Config file syntax](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#config_syntax)
- [Custom backends overview](https://www.puppet.com/docs/puppet/7/hiera_custom_backends.html#custom_backends_overview)

## Convert experimental data provider functions to a Hiera 5 `data_hash` backend

Puppet lookup had experimental  custom backend support, where you could set `data_provider = function` and create a function with a name that returned a hash. If you  used that, you can convert your function to a Hiera 5 `data_hash` backend.

1. ​    Your original function took no arguments. Change its signature     to accept two arguments: a `Hash`     and a `Puppet::LookupContext`     object. You do not have to do anything with these - just add them. For more information, see     the documentation for data hash backends.   

2. ​    Delete the `data_provider` setting, which enabled Puppet lookup for a module. You can find this setting in a module’s      `metadata.json`.   

3. Create a version 5 `hiera.yaml` file for the affected environment or module, and add a     hierarchy level as follows:

   ```
   - name: <ARBITRARY NAME>
     data_hash: <NAME OF YOUR FUNCTION>Copied!
   ```

   It     does not need a `path`, `datadir`, or any other options. 

Results



## Updated classic Hiera function calls 

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are all deprecated. The `lookup` function is a complete replacement for all of        these.



| Hiera function                | Equivalent `lookup` call                                     |
| ----------------------------- | ------------------------------------------------------------ |
| `hiera('secure_server')`      | `lookup('secure_server')`                                    |
| `hiera_array('ntp::servers')` | `lookup('ntp::servers', {merge =>                            unique})` |
| `hiera_hash('users')`         | `lookup('users', {merge => hash})` or                                `lookup('users', {merge =>                                deep})` |
| `hiera_include('classes')`    | `lookup('classes', {merge =>                                unique}).include` |

To prepare for deprecations in future Puppet versions, it's best                to revise your Puppet modules to replace the                    `hiera_*` functions with `lookup`. However, you                can adopt all of Hiera 5's new features in other modules without updating these                function calls. While you're revising, consider refactoring code to use automatic                class parameter lookup instead of manual lookup calls. Because automatic lookups can                now do unique and hash merges, the use of manual lookup in the form of                    `hiera_array` and `hiera_hash` are not as                important as they used to be. Instead of changing those manual Hiera calls to be calls to the                    `lookup` function, use Automatic Parameter Lookup (API).

**Related information**

- [The Puppet lookup function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)
- [Merge behaviors](https://www.puppet.com/docs/puppet/7/hiera_merging.html#merge_behaviors)

## Adding Hiera data to a        module 

Modules need default values for their class parameters.        Before, the preferred way to do this was the “params.pp” pattern. With Hiera 5, you can use the “data in modules” approach instead.        The following example shows how to replace `params.pp` with the new approach.

Note: The `params.pp` pattern is still valid, and the                    features it relies on remain in Puppet. But if                    you want to use Hiera data instead, you now have                    that option.

Note: You must fully qualify Hiera variables for                    modules in your YAML file. See [Module data with YAML data files](https://www.puppet.com/docs/puppet/7/hiera_migrate.html#module_data_yaml_data_files).

### Module data with the `params.pp` pattern 

The `params.pp` pattern takes advantage of the Puppet class    inheritance behavior. 

One class in your module does nothing but set variables for the other      classes. This class is called `<MODULE>::params`. This class uses Puppet code      to construct values; it uses conditional logic based on the target operating system. The rest      of the classes in the module inherit from the params class. In their parameter lists, you can      use the params class's variables as default values.

When using `params.pp` pattern, the values set in the `params.pp` defined class cannot be used in lookup merges and      Automatic Parameter Lookup (APL) - when using this pattern these are only used for defaults      when there are no values found in Hiera.

An example params class:      

```
# ntp/manifests/params.pp
class ntp::params {
  $autoupdate = false,
  $default_service_name = 'ntpd',

  case $facts['os']['family'] {
    'Debian': {
      $service_name = 'ntp'
    }
    'RedHat': {
      $service_name = $default_service_name
    }
  }
}
Copied!
```

A class that inherits from the params class and uses it to set default      parameter values:      

```
class ntp (
  $autoupdate   = $ntp::params::autoupdate,
  $service_name = $ntp::params::service_name,
) inherits ntp::params {
 ...
}Copied!
```

### Module data with a one-off custom Hiera backend

With Hiera 5's custom backend    system, you can convert and existing params class to a hash-based Hiera backend. 

To create a Hiera backend, create a      function written in the Puppet language that returns a hash. 

Using the `params` class as a starting point:

```
# ntp/functions/params.pp
function ntp::params(
  Hash                  $options, # We ignore both of these arguments, but
  Puppet::LookupContext $context, # the function still needs to accept them.
) {
  $base_params = {
    'ntp::autoupdate'   => false,
      # Keys have to start with the module's namespace, which in this case is `ntp::`.
    'ntp::service_name' => 'ntpd',
      # Use key names that work with automatic class parameter lookup. This
      # key corresponds to the `ntp` class's `$service_name` parameter.
  }

  $os_params = case $facts['os']['family'] {
    'Debian': {
      { 'ntp::service_name' => 'ntp' }
    }
    default: {
      {}
    }
  }

  # Merge the hashes, overriding the service name if this platform uses a non-standard one:
  $base_params + $os_params
}Copied!
```

Note: The hash merge operator (+) is useful in these functions.

After you      have a function, tell Hiera to use it by adding it to the      module layer `hiera.yaml`. A simple backend like this one      doesn’t require `path`, `datadir`,      or `options` keys. You have a choice of adding it to the `default_hierarch` if you want the exact same behaviour as with the      earlier `params.pp` pattern, and use the regular `hierarchy` if you want the values to be merged with values of higher      priority when a merging lookup is specified. You can split up the key-values so that some are      in the `hierarchy`, and some in the `default_hierarchy`, depending on whether it makes sense to merge a value or      not.

Here we add it to the regular      hierarchy:

```
# ntp/hiera.yaml
---
version: 5
hierarchy:
  - name: "NTP class parameter defaults"
    data_hash: "ntp::params"
  # We only need one hierarchy level, because one function provides all the data.Copied!
```

With Hiera-based defaults, you can simplify      your module’s main classes:

- They do not need to inherit from any other            class.

- You do not need to explicitly set a default            value with the `=`            operator.

- Instead APL comes into effect for each            parameter without a given value. In the example, the function `ntp::params` is called to get the default params,            and those can then be either overridden or merged, just as with all values in Hiera.

  ```
  # ntp/manifests/init.pp
  class ntp (
    # default values are in ntp/functions/params.pp
    $autoupdate,
    $service_name,
  ) {
   ...
  }
  Copied!
  ```

### Module data with YAML data files 

You can also manage your module's default data with basic      Hiera YAML files, 

 Set up a hierarchy in your module layer `hiera.yaml` file:      

```
# ntp/hiera.yaml
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "OS family"
    path: "os/%{facts.os.family}.yaml"

  - name: "common"
    path: "common.yaml"Copied!
```

Then, put the necessary data files in the data directory:      

```
# ntp/data/common.yaml
---
ntp::autoupdate: false
ntp::service_name: ntpd

# ntp/data/os/Debian.yaml
ntp::service_name: ntp
Copied!
```

You can also use any other Hiera backend to      provide your module’s data. If you want to use a custom backend that is distributed as a      separate module, you can mark that module as a dependency.

For more information, see [class inheritance](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes), [conditional logic](https://www.puppet.com/docs/puppet/7/lang_conditional.html#lang_conditional), [write functions in the         Puppet language](https://www.puppet.com/docs/puppet/7/lang_write_functions_in_puppet.html#lang_write_functions_in_puppet), [hash merge operator.](https://www.puppet.com/docs/puppet/7/lang_expressions.html#lang_expressions)

**Related information**

- [The Puppet lookup function](https://www.puppet.com/docs/puppet/7/hiera_automatic.html#puppet_lookup)
- [Hiera configuration layers](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_config_layers)

# Use case examples

Try out some common configuration tasks to see how you can use Puppet to manage your IT infrastructure. 

**[Manage an NTP service](https://www.puppet.com/docs/puppet/7/quick_start_ntp.html)**
Network Time Protocol (NTP) is one of the most crucial, yet easiest, services to       configure and manage with Puppet, to properly synchronize time       across all your nodes. Follow this guide to get started managing a NTP service using the Puppet       `ntp` module. **[Manage sudo privileges](https://www.puppet.com/docs/puppet/7/quick_start_sudo.html)**
Managing sudo on your agents allows you to control which     system users have  access to elevated privileges. This guide helps you get started      managing sudo privileges across your nodes, using a module from the Puppet     Forge in conjunction with a simple module you write. **[Manage a DNS nameserver file](https://www.puppet.com/docs/puppet/7/quick_start_dns.html)**
A nameserver ensures that the human-readable URLs you type       in your browser (for example, `example.com`) resolve to IP addresses that computers can read. This guide helps       you get started managing a simple Domain Name System (DNS) nameserver  file with Puppet. **[Manage firewall rules](https://www.puppet.com/docs/puppet/7/quick_start_firewall.html)**
With a firewall, admins define firewall rules, which sets a     policy for  things like application ports (TCP/UDP), network ports, IP addresses,  and accept-deny     statements. This guide helps you get started  managing firewall rules with Puppet. **[Forge examples](https://www.puppet.com/docs/puppet/7/forge_examples.html)**
Puppet         Forge  is a collection of modules and how-to guides developed         by Puppet and its community.

# Manage an NTP service

Network Time Protocol (NTP) is one of the most crucial, yet easiest, services to      configure and manage with Puppet, to properly synchronize time      across all your nodes. Follow this guide to get started managing a NTP service using the Puppet      `ntp` module.

Before you begin

Ensure you’ve already [                     installed Puppet](https://www.puppet.com/docs/puppet/7/installing_and_upgrading.html), and at least one [ *nix agent](https://www.puppet.com/docs/puppet/7/install_agents.html#install_agents). Also, log in as                root or Administrator on your nodes.

The clocks on your servers are not inherently accurate. They need to            synchronize with something to let them know what the right time is. NTP is a protocol            that synchronizes the clocks of computers over a network. NTP uses Coordinated Universal            Time (UTC) to synchronize computer clock times to within a millisecond.

Your entire datacenter, from the network to the applications, depends            on accurate time for security services, certificate validation, and file sharing across               Puppet agents. If the time is wrong, your Puppet primary server might mistakenly issue agent certificates            from the distant past or future, which other agents treat as expired.

Using the Puppet NTP module, you can: 

- Ensure time is correctly synced across all the servers in your                  infrastructure.
- Ensure time is correctly synced across your configuration                  management tools.
- Roll out updates quickly if you need to change or specify your                  own internal NTP server pool.

This guide walks you through the following steps in setting up NTP            configuration management:

- Installing the `puppetlabs-ntp` module.
- Adding classes to the `default` node in your main                  manifest.
- Viewing the status of your NTP service.
- Using multiple nodes in the main manifest to configure NTP for                  different permissions.

Note: You can add the NTP service to as many agents as               needed. For simplicity, this guide describes adding it to only one.

1. The first step is installing the `puppetlabs-ntp`               module. The `puppetlabs-ntp` module is part of the                  [supported                   modules](http://forge.puppetlabs.com/supported) program; these modules are supported, tested, and maintained by Puppet. For more information on `puppetlabs-ntp`, see the [ README](https://forge.puppet.com/puppetlabs/ntp). To               install it, run:

   ```
   puppet module install puppetlabs-ntpCopied!
   ```

   The resulting output is similar to               this:

   ```
    Preparing to install into /etc/puppetlabs/puppet/modules ...
       Notice: Downloading from http://forgeapi.puppetlabs.com ...
       Notice: Installing -- do not interrupt ...
       /etc/puppetlabs/puppet/environments/production/modules
       └── puppetlabs-ntp (v3.1.2)Copied!
   ```

   That’s               it! You’ve just installed the `puppetlabs-ntp`               module.

2. The next step is adding classes from the NTP module to               the main manifest.

   The NTP module contains several classes. [Classes](https://www.puppet.com/docs/puppet/7/lang_classes.html#lang_classes) are named chunks of Puppet code and are the primary means by which Puppet configures nodes. The NTP module contains the                  following classes:

   - `ntp`: the main class, which includes all other NTP classes,                        including the classes in this list.
   - `ntp::install`: handles the installation packages.
   - `ntp::config`: handles the configuration file.
   - `ntp::service`: handles the service.

   You’re going to add the `ntp` class to the default                  node in your main manifest. Depending on your needs or infrastructure, you might                  have a different group that you’ll assign NTP to, but you would take similar                  steps.

   1. From the command line on the primary server, navigate to the directory that contains                     the main manifest: 

      ```
      cd /etc/puppetlabs/code/environments/production/manifestsCopied!
      ```

   2. ​                  Use your text editor to open `site.pp`.               

   3. Add the following Puppet code to `site.pp`:

      ```
      node default { 
        class { 'ntp':
              servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu']
        }
      }
      Copied!
      ```

      Note: If your `site.pp` file                           already has a default node in it, add just the `class` and `servers` lines                           to it. 

      Note: For additional time server options, see the list at https://www.ntppool.org/.

   4. On your agent, start a Puppet run: 

      ```
      puppet agent -tCopied!
      ```

      Your Puppet-managed node is now configured to use NTP. 

3. To check if the NTP service is running, run: 

   ```
   puppet resource service ntpdCopied!
   ```

   On Ubuntu operating systems, the service is `ntp`               instead of `ntpd`. 

   The result                  looks like this:                  

   ```
   service { 'ntpd':
     		  ensure => 'running',
    		  enable => 'true',
   	}Copied!
   ```

4. If you want to configure the NTP service to run differently on different nodes, you               can set up NTP on nodes other than `default` in the                  `site.pp` file. 

   In previous steps, you’ve been configuring the default node. 

   In the example below, two NTP servers (`kermit` and                     `grover`) are configured to talk to outside time                  servers. The other NTP servers (`snuffie`, `bigbird`, and `hooper`)                  use those two primary servers to sync their time. 

   One of the primary NTP servers, `kermit`, is very                  cautiously configured — it can’t afford outages, so it’s not allowed to                  automatically update its NTP server package without testing. The other servers are                  more permissively configured.

   The `site.pp` looks like this:                  

   ```
   node "kermit.example.com" { 
     class { "ntp":
           servers            => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
           autoupdate         => false,
           restrict           => [],
           service_enable     => true,
     }
   }
   
   node "grover.example.com" { 
     class { "ntp":
           servers            => [ 'kermit.example.com','0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst'],
           autoupdate         => true,
           restrict           => [],
           service_enable     => true,
     }
   }
   
   node "snuffie.example.com", "bigbird.example.com", "hooper.example.com" {
     class { "ntp":
           servers    => [ 'grover.example.com', 'kermit.example.com'],
           autoupdate => true,
           enable     => true,
     }
   }Copied!
   ```

   In this way, it is possible to configure NTP on multiple nodes to suit your                  needs.

Results

For more information about working with the `puppetlabs-ntp` module, check out our [How to Manage NTP](https://puppet.com/resources/webinar/how-manage-ntp) webinar.

Puppet offers many opportunities for learning and                training, from formal certification courses to guided online lessons. See the [Learning Puppet page](https://learn.puppet.com/) for more information.

# Manage sudo privileges

Managing sudo on your agents allows you to control which    system users have access to elevated privileges. This guide helps you get started    managing sudo privileges across your nodes, using a module from the Puppet    Forge in conjunction with a simple module you write.

Before you begin

Before starting this        walk-through, complete [the previous exercises](https://www.puppet.com/docs/puppet/7/quick_start_essential_config.html). 

Ensure you’ve already [                     installed Puppet](https://www.puppet.com/docs/puppet/7/installing_and_upgrading.html), and at least one [ *nix agent](https://www.puppet.com/docs/puppet/7/install_agents.html#install_agents). Also, log in as                root or Administrator on your nodes.

Using this guide, you learn        how to:

- Install the `saz-sudo` module as the foundation for managing sudo            privileges.
- Write a module that contains a class called `privileges` to manage a resource            that sets privileges for certain users.
- Add classes from the `privileges` and `sudo` modules to your agents.

Note: You can add the `sudo` and `privileges` classes to as many agents as needed. For simplicity,          this guide describes only one.

1. Start by installing the `saz-sudo` module. It's available on the Forge, and is one of many modules written by a member of the            Puppet user community. You can learn more about the          module at [forge.puppet.com/saz/sudo](http://forge.puppet.com/saz/sudo). To install the `saz-sudo` module, run the following          command on the primary server:

   ```
   puppet module install saz-sudoCopied!
   ```

   The resulting            output is similar to            this:

   ```
   Preparing to install into /etc/puppetlabs/code/environments/production/modules …
   Notice: Downloading from http://forgeapi.puppetlabs.com ...
       Notice: Installing -- do not interrupt ...
       /etc/puppetlabs/puppet/modules
       └── saz-sudo (v2.3.6)
             └── puppetlabs-stdlib (3.2.2) [/opt/puppet/share/puppet/modules]Copied!
   ```

   That’s            it! You’ve installed the `saz-sudo` module.

2. Next, you'll create a module that contains            the `privileges` class.

   Like in the DNS exercise,            this is a small module with just one class. You'll create the `privileges` module directory, its `manifests` subdirectory, and an              `init.pp` manifest file            that contains the `privileges` class. 

   1. From the command line on the primary server, navigate to the              modules directory: 

      ```
      cd /etc/puppetlabs/code/environments/production/modulesCopied!
      ```

   2. Create the module directory and its manifests              directory: 

      ```
      mkdir -p privileges/manifestsCopied!
      ```

   3. In the manifests directory, use your text              editor to create the `init.pp` file, and edit it so it contains the following Puppet code:

      ```
      class privileges {
      
         sudo::conf { 'admins':
         ensure  => present,
         content => '%admin ALL=(ALL) ALL',
         }
      
       }Copied!
      ```

      The `sudo::conf 'admins'` line creates a sudoers rule that                ensures that members of the `admins` group have the ability to run any command using                sudo. This resource creates a configuration fragment file to define this rule                  in `/etc/sudoers.d/`. It's called something like `10_admins`.

   4. Save and exit the file.

      That’s it!                You’ve created a module that contains a class that, after it's applied, ensures that                your agents have the correct sudo privileges set for the root user and the `admins` and wheel                groups.

3. Next, add the `privileges` and `sudo` classes to default nodes.

   1. From the command line on the primary server, navigate to the              main manifest: 

      ```
      cd /etc/puppetlabs/code/environments/production/manifestsCopied!
      ```

   2. Open `site.pp` with your text editor and add the following Puppet code to the default node:

      ```
      class { 'sudo': }
      sudo::conf { 'web':
        content  => "web ALL=(ALL) NOPASSWD: ALL",
      }
      class { 'privileges': }
      sudo::conf { 'jargyle':
        priority => 60,
        content  => "jargyle ALL=(ALL) NOPASSWD: ALL",
      }Copied!
      ```

      The `sudo::conf ‘web’` line creates a sudoers rule to ensure that                members of the `web` group can run any command using                sudo. This resource creates a configuration fragment file to define this rule                  in `/etc/sudoers.d/`.

      The `sudo::conf ‘jargyle’` line creates a sudoers                rule to ensure that the user `jargyle` can run any command using sudo. This resource                creates a configuration fragment to define this rule in `/etc/sudoers.d/`. It's called                something like `60_jargyle`.

   3. ​            Save and exit the file.          

   4. On your primary server, ensure that there are no errors: 

      ```
      puppet parser validate site.ppCopied!
      ```

      The parser                returns nothing if there are no errors.

   5. From the command line on your agent, run Puppet: `puppet agent -t`            

      That’s it! You have                successfully applied `sudo` and `privileges` classes to nodes.

   6. To confirm it worked, run the following command on an              agent: 

      ```
      sudo -l -U jargyleCopied!
      ```

      The results resemble the following:                

      ```
       Matching Defaults entries for jargyle on this host:
      !visiblepw, always_set_home, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE
      INPUTRC KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS
      LC_CTYPE", env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES",
      env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME
      LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
      secure_path=/usr/local/bin\:/sbin\:/bin\:/usr/sbin\:/usr/bin
      
       User jargyle may run the following commands on this host:
      (ALL) NOPASSWD: ALLCopied!
      ```

Results

For more information about        working with Puppet and sudo users, see our [Module of The Week: saz/sudo - Manage sudo configuration](https://puppet.com/blog/module-of-the-week-sazsudo-manage-sudo-configuration) blog        post.

Puppet offers many opportunities for learning and                training, from formal certification courses to guided online lessons. See the [Learning Puppet page](https://learn.puppet.com/) for more information.

# Manage a DNS nameserver file

A nameserver ensures that the human-readable URLs you type      in your browser (for example, `example.com`) resolve to IP addresses that computers can read. This guide helps      you get started managing a simple Domain Name System (DNS) nameserver file with Puppet.

Before you begin

Before starting this walk-through, complete [the previous exercise of setting up NTP                management](https://www.puppet.com/docs/puppet/7/quick_start_ntp.html).  Log in as root or Administrator on your nodes.

Sysadmins typically need to manage a nameserver file for internal            resources that aren’t published in public nameservers. For example, suppose you have            several employee-maintained servers in your infrastructure, and the DNS network assigned            to those servers use Google’s public nameserver located at `8.8.8.8`. However, there are several            resources behind your company’s firewall that your employees need to access on a regular            basis. In this case, you’d build a private nameserver (for example at `10.16.22.10`), and use Puppet to ensure all the servers in your infrastructure            have access to it.

In this exercise, you learn how to:

- Write a module that contains a class called `resolver` to manage                  a nameserver file called `/etc/resolv.conf`.
- Enforce the desired state of that class from the command line                  of your Puppet agent.

Note: You can add the DNS nameserver class to as many               agents as needed. For simplicity, this guide describes adding it to only one.

1. The first step is creating the `resolver` module and a               template.

   While some modules are large and complex, this module module                  contains just one class and one template

   By default, Puppet keeps modules                  in an environment’s [modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html), which for the production                  environment defaults to `/etc/puppetlabs/code/environments/production/modules`.                  This directory contains modules that Puppet                  installs, those that you download from the Forge,                  and those you write yourself. 

   Note: Puppet creates another module directory: `/opt/puppetlabs/puppet/modules`. Don’t modify or add anything in                     this directory.

   For thorough information about creating and using                  modules, see [Modules fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals), the [Beginner’s guide to modules](https://www.puppet.com/docs/puppet/7/bgtm.html#writing_modules_overview), and the  [                      Puppet                      Forge                   ](https://forge.puppet.com/).

   Modules are directory trees. For this task, you’ll create a                  directory for the `resolver` module, a subdirectory for its templates, and a template                  file that Puppet uses to create the `/etc/resolv.conf` file                  that manages DNS.

   1. From the command line on the Puppet primary server, navigate to the modules                     directory: 

      ```
      cd /etc/puppetlabs/code/environments/production/modulesCopied!
      ```

   2. Create the module directory and its templates                     directory:

      ```
      mkdir -p resolver/templatesCopied!
      ```

   3. ​                  Use your text editor to create a file                        called `resolv.conf.erb` inside the `resolver/templates` directory.               

   4. Edit the `resolv.conf.erb` file to add the                     following Ruby code: 

      ```
       # Resolv.conf generated by Puppet
      
       <% [@nameservers].flatten.each do |ns| -%>
       nameserver <%= ns %>
       <% end -%>
      Copied!
      ```

      This                           Ruby code is a template for                           populating `/etc/resolv.conf` correctly, no matter what changes are                        manually made to `/etc/resolv.conf`, as you see in a later step.

   5. Save and exit the file.

      That’s it! You’ve created a Ruby template to populate `/etc/resolv.conf`.

2. Add managing the `resolv.conf` file to your main               manifest.

   1. ​                  On the primary server, open `/etc/resolv.conf` with your text editor, and copy the IP address                     of your primary server’s nameserver. In this example, the nameserver is `10.0.2.3`.               

   2. Navigate to the main manifest: 

      ```
      cd /etc/puppetlabs/code/environments/production/manifestsCopied!
      ```

   3. Use your text editor to open the `site.pp` file and add the following Puppet code to the default node, making                     the `nameservers` value match the one you found                        in `/etc/resolv.conf`: 

      ```
       $nameservers = ['10.0.2.3']
      
       file { '/etc/resolv.conf':
         ensure  => file,
         owner   => 'root',
         group   => 'root',
         mode    => '0644',
         content => template('resolver/resolv.conf.erb'),
       }Copied!
      ```

   4. From the command line on your agent, run Puppet: `puppet agent -t`

      To see the results in the resolve.conf file,                        run:

      ```
      cat /etc/resolv.confCopied!
      ```

      The                        file contains the nameserver you added to your main manifest.

      That’s it! You’ve written and applied a module that contains a class that                        ensures your agents resolve to your internal nameserver.

      Note the following about your new class:

      - It ensures the creation of the file `/etc/resolv.conf`.
      - The content of `/etc/resolv.conf` is modified and managed by the                                 template, `resolv.conf.erb`.

3. Finally, let’s take a look at how Puppet ensures the desired state of the `resolver` class on               your agents. In the previous task, you set the nameserver IP address. Now, simulate a               scenario where a member of your team changes the contents of `/etc/resolv.conf` to use a               different nameserver and, as a result, can no longer access any internal               resources:

   1. ​                  On the agent to which you applied                        the `resolver` class, edit `/etc/resolv.conf` to contain any                     nameserver IP address other than the one you want to use.               

   2. ​                  Save and exit the file.               

   3. Now, fix the mistake you've introduced. From the                     command line on your agent, run: `puppet agent -t --onetime`

      To                        see the resulting contents of the managed file,                           run:

      ```
      cat /etc/resolv.confCopied!
      ```

      Puppet has enforced the desired state of the                        agent node by changing the `nameserver` value back to what you specified in                           `site.pp`                        on the primary server.

Results

For more information about working with Puppet and DNS, see our [Dealing with Name                Resolution Issues](http://puppet.com/blog/resolving-dns-issues) blog post.

Puppet offers many opportunities for learning and                training, from formal certification courses to guided online lessons. See the [Learning Puppet page](https://learn.puppet.com/) for more information.

# Manage firewall rules

With a firewall, admins define firewall rules, which sets a    policy for things like application ports (TCP/UDP), network ports, IP addresses, and accept-deny    statements. This guide helps you get started managing firewall rules with Puppet.

Before you begin

Before starting this        walk-through, complete the previous exercises in the [common configuration tasks](https://www.puppet.com/docs/puppet/7/quick_start_essential_config.html).

Ensure you’ve already [                     installed Puppet](https://www.puppet.com/docs/puppet/7/installing_and_upgrading.html), and at least one [ *nix agent](https://www.puppet.com/docs/puppet/7/install_agents.html#install_agents). Also, log in as                root or Administrator on your nodes.

 Firewall rules are applied        with a top-to-bottom approach. For example, when a service, say SSH, attempts to access        resources on the other side of a firewall, the firewall applies a list of rules to determine        if or how SSH communications are handled. If a rule allowing SSH access can’t be found, the        firewall denies access to that SSH attempt.

To best way to manage        firewall rules with Puppet is to divide them          into `pre` and `post` groups to ensure Puppet checks them in        the correct order.

Using this guide, you learn how to:

- Install the `puppetlabs-firewall` module.
- Write a module to define the firewall rules            for your Puppet managed infrastructure.
- Add the firewall module to the main            manifest.
- Enforce the desired state using              the `my_firewall` class.

1. The first step is installing the `puppetlabs-firewall` module from the            Puppet          Forge. The module introduces the `firewall` resource, which is used to manage and          configure firewall rules. For more information about the `            puppetlabs-firewall          ` module, see its [             README](https://forge.puppet.com/puppetlabs/firewall/readme). To install the module, on the primary server, run:

   ```
   puppet module install puppetlabs-firewallCopied!
   ```

   The resulting            output is similar to            this:

   ```
   Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
       Notice: Downloading from https://forgeapi.puppetlabs.com ...
       Notice: Installing -- do not interrupt ...
       /etc/puppetlabs/puppet/environments/production/modules
       └── puppetlabs-firewall (v1.6.0)Copied!
   ```

   That's            it! You’ve just installed the `firewall` module.

2. Next, you'll write the `my_firewall` module, which contains three          classes. You'll create the `my_firewall` module directory, its `manifests` subdirectory, a `pre.pp` manifest file and a `post.pp` manifest file.

   1. From the command line on the primary server, navigate to the              modules directory:

      ```
      cd /etc/puppetlabs/code/environments/production/modulesCopied!
      ```

   2. Create the module directory and its manifests              directory: 

      ```
      mkdir -p my_firewall/manifestsCopied!
      ```

   3. ​            From the `manifests` directory, use your text editor to                create `pre.pp`.          

   4. The pre rules are rules that the firewall applies when              a service requests access. It is run before any other rules. Edit `pre.pp` so it contains the              following Puppet code:

      ```
      class my_firewall::pre {
        Firewall {
          require => undef,
        }
           firewall { '000 accept all icmp':
             proto  => 'icmp',
             action => 'accept',
           }
           firewall { '001 accept all to lo interface':
             proto   => 'all',
             iniface => 'lo',
             action  => 'accept',
           }
           firewall { '002 reject local traffic not on loopback interface':
             iniface     => '! lo',
             proto       => 'all',
             destination => '127.0.0.1/8',
             action      => 'reject',
           }
           firewall { '003 accept related established rules':
             proto  => 'all',
             state  => ['RELATED', 'ESTABLISHED'],
             action => 'accept',
           }
         }Copied!
      ```

      These                default rules allow basic networking to ensure that existing connections are not                closed. 

   5. ​            Save and exit the file.          

   6. ​            From the `manifests` directory, use your text editor to                create `post.pp`.          

   7. The post rules tell the firewall to drop requests that              haven’t met the rules defined by `pre.pp` or in `site.pp`. Edit `post.pp` so it contains the following Puppet code: 

      ```
       class my_firewall::post {
           firewall { '999 drop all':
             proto  => 'all',
             action => 'drop',
             before => undef,
           }
         }Copied!
      ```

   8. Save and exit the file.

      That’s it! You’ve                written a module that contains a class that, after it's applied, ensures your                firewall has rules in it that are managed by Puppet.              

3. Now you'll add the `firewall` module to the main manifest so that Puppet is managing firewall configuration on nodes.

   1. On the primary server, navigate to the main manifest:

      ```
      cd /etc/puppetlabs/code/environments/production/manifestsCopied!
      ```

   2. ​            Use your text editor to open `site.pp`.          

   3. Add the following Puppet code to your `site.pp` file: 

      ```
        resources { 'firewall':
           purge => true,
         }Copied!
      ```

      This                clears any existing rules and make sure that only rules defined in Puppet exist on the machine.

   4. Add the following Puppet code to your `site.pp` file: 

      ```
       Firewall {
           before  => Class['my_firewall::post'],
           require => Class['my_firewall::pre'],
         }
      
         class { ['my_firewall::pre', 'my_firewall::post']: }Copied!
      ```

      These                settings ensure that the pre and post classes are run in                  the [correct order](https://www.puppet.com/docs/puppet/7/lang_relationships.html#lang_relationships) to avoid locking you out of your                node during the first Puppet run, and                  declaring `my_firewall::pre` and `my_firewall::post` satisfies the specified                dependencies.

   5. Add the `firewall` class to your `site.pp` to ensure the correct packages              are installed:

      ```
      class { 'firewall': }Copied!
      ```

   6. To apply the configuration, on the agent, run Puppet: `puppet agent -t`            

      That's it!                Puppet is now managing the firewall configuration on the agent. 

   7. To check your firewall configuration, on the agent,              run: `iptables --list`            

      The                resulting output is similar to                this:

      ```
      Chain INPUT (policy ACCEPT)
      target     prot opt source               destination
      ACCEPT     icmp --  anywhere             anywhere            /* 000 accept all icmp */
      ACCEPT     all  --  anywhere             anywhere            /* 001 accept all to lo interface */
      REJECT     all  --  anywhere             loopback/8          /* 002 reject local traffic not on loopback interface */ reject-with icmp-port-unreachable
      ACCEPT     all  --  anywhere             anywhere            /* 003 accept related established rules */ state RELATED,ESTABLISHED
      DROP       all  --  anywhere             anywhere            /* 999 drop all */
      
      Chain FORWARD (policy ACCEPT)
      target     prot opt source               destination
      
      Chain OUTPUT (policy ACCEPT)
      target     prot opt source               destinationCopied!
      ```

4. Finally, let’s take a look at how Puppet ensures the desired state of the `my_firewall` class on your agents. In          the previous step, you applied the firewall rules. Now, simulate a scenario where a member          of your team changes the contents the `iptables` to allow connections on a random port that was not          specified in `my_firewall`:

   1. On an agent where you applied the `my_firewall` class, run: 

      ```
      iptables --listCopied!
      ```

      Note                that the rules from the `my_firewall` class have been applied.

   2. From the command line, add a rule to allow connections              to port 8449 by running:

      ```
      iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8449 -j ACCEPTCopied!
      ```

   3. ​            Run `iptables --list` again and see that this new rule is now              listed.          

   4. Run Puppet on that              agent: 

      ```
      puppet agent -t --onetimeCopied!
      ```

   5. Run `iptables --list` on that node one more time, and notice              that Puppet has enforced the desired state you              specified for the firewall rules

      That’s it! Puppet has enforced the desired state of your                agent.

Results

You can learn more about the          Puppet firewall module by visiting the [           Forge         ](https://forge.puppet.com/puppetlabs/firewall/readme).

Puppet offers many opportunities for learning and                training, from formal certification courses to guided online lessons. See the [Learning Puppet page](https://learn.puppet.com/) for more information.

# Forge examples

Puppet        Forge  is a collection of modules and how-to guides developed        by Puppet and its community.

The [Forge](https://forge.puppet.com/)            has existing modules and code examples that assist with automating the following use            cases:

- Base system configuration
  - Including [registry](https://forge.puppet.com/puppetlabs/registry), [NTP](https://forge.puppet.com/puppetlabs/ntp), [firewalls](https://forge.puppet.com/puppetlabs/firewall), [services](https://forge.puppet.com/puppetlabs/service)
- Manage web servers
  - Including [apache](https://forge.puppet.com/puppetlabs/apache), [tomcat](https://forge.puppet.com/puppetlabs/tomcat), [IIS](https://forge.puppet.com/puppetlabs/iis), [nginx](https://forge.puppet.com/puppet/nginx)
- Manage database systems
  - Including [Oracle](https://forge.puppet.com/enterprisemodules/ora_config), [Microsoft SQL Server](https://forge.puppet.com/puppetlabs/sqlserver), [MySQL](https://forge.puppet.com/puppetlabs/mysql), [PostgreSQL](https://forge.puppet.com/puppetlabs/postgresql)
- Manage middleware/application systems
  - Including [Java](https://forge.puppet.com/puppetlabs/java), [WebLogic/Fusion](https://forge.puppet.com/enterprisemodules/wls_config), [IBM MQ](https://forge.puppet.com/enterprisemodules/mq_config), [IBM IIB](https://forge.puppet.com/enterprisemodules/iib_install), [RabbitMQ](https://forge.puppet.com/puppet/rabbitmq), [ActiveMQ](https://forge.puppet.com/puppetlabs/activemq), [Redis](https://forge.puppet.com/puppet/redis), [ElasticSearch](https://forge.puppet.com/elastic/elasticsearch)
- Source control
  - Including [Github](https://forge.puppet.com/enterprisemodules/github_config), [Gitlab](https://forge.puppet.com/puppet/gitlab)
- Monitoring
  - Including [Splunk](https://forge.puppet.com/puppetlabs/splunk_hec), [Nagios](https://forge.puppet.com/herculesteam/augeasproviders_nagios), [Zabbix](https://forge.puppet.com/puppet/zabbix), [Sensu](https://forge.puppet.com/sensu/sensu), [Prometheus](https://forge.puppet.com/puppet/prometheus), [NewRelic](https://forge.puppet.com/claranet/newrelic), [Icinga](https://forge.puppet.com/icinga/icinga2), [SNMP](https://forge.puppet.com/puppet/snmp)
- Patch management
  - [OS patching](https://forge.puppet.com/albatrossflavour/os_patching) on                            Enterprise Linux, Debian, SLES, Ubuntu, Windows
- Package management
  - Linux: Puppet integrates directly with native package managers
  - Windows: Use Puppet to install software directly on Windows, or                            integrate with [Chocolatey](https://forge.puppet.com/puppetlabs/chocolatey)
- Containers and cloud native
  - Including [Docker](https://forge.puppet.com/puppetlabs/docker), [Kubernetes](https://forge.puppet.com/puppetlabs/kubernetes), [Terraform](https://forge.puppet.com/puppetlabs/terraform), [OpenShift](https://forge.puppet.com/openshift/openshift_origin)
- Networking
  - Including [Cisco Catalyst](https://forge.puppet.com/puppetlabs/cisco_ios), [Cisco Nexus](https://forge.puppet.com/puppetlabs/ciscopuppet), [F5](https://forge.puppet.com/f5/f5), [Palo Alto](https://forge.puppet.com/puppetlabs/panos), [Barracuda](https://forge.puppet.com/barracuda/cudawaf)
- Secrets management
  - Including [Hashicorp Vault](https://forge.puppet.com/puppetlabs/vault), [CyberArk Conjur](https://forge.puppet.com/cyberark/conjur), [Azure Key Vault](https://forge.puppet.com/tragiccode/azure_key_vault), [Consul Data](https://forge.puppet.com/ploperations/consul_data/readme)

See each module’s README for installation, usage, and code examples. 