# Ansible 调优

​        version 版本              



In this section we cover some options for tuning Ansible for performance and scale.
在本节中，我们将介绍一些用于优化 Ansible 以提高性能和规模的选项。

## SSH pipelining SSH 流水线 ¶

SSH pipelining is disabled in Ansible by default, but is generally safe to enable, and provides a reasonable performance improvement.
默认情况下，SSH 流水线在 Ansible 中处于禁用状态，但通常可以安全地启用，并提供合理的性能改进。

```
ansible.cfg
[ssh_connection]
pipelining = True
```

## Forks 分叉 ¶

By default Ansible executes tasks using a fairly conservative 5 process forks. This limits the parallelism that allows Ansible to scale. Most Ansible control hosts will be able to handle far more forks than this. You will need to experiment to find out the CPU, memory and IO limits of your machine.
默认情况下，Ansible 使用相当保守的 5 个进程分支执行任务。这限制了允许 Ansible 扩展的并行性。大多数 Ansible 控制主机将能够处理比这更多的 fork。您需要进行试验以找出计算机的 CPU、内存和 IO 限制。

For example, to increase the number of forks to 20:
例如，要将分叉数量增加到 20 个：

```
ansible.cfg
[defaults]
forks = 20
```

## Fact caching 事实缓存 ¶

By default, Ansible gathers facts for each host at the beginning of every play, unless `gather_facts` is set to `false`. With a large number of hosts this can result in a significant amount of time spent gathering facts.
默认情况下，Ansible 会在每次播放开始时收集每个主机的事实，除非 `gather_facts` 设置为 `false` 。对于大量主机，这可能会导致花费大量时间收集事实。

One way to improve this is through Ansible’s support for [fact caching](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#caching-facts). In order to make this work with Kolla Ansible, it is necessary to change Ansible’s [gathering](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-gathering) configuration option to `smart`.
改善这一点的一种方法是通过 Ansible 对事实缓存的支持。为了使此功能与 Kolla Ansible 配合使用，有必要将 Ansible 的收集配置选项更改为 `smart` 。

### Example 示例 ¶

In the following example we configure Kolla Ansible to use fact caching using the [jsonfile cache plugin](https://docs.ansible.com/ansible/latest/plugins/cache/jsonfile.html).
在以下示例中，我们将 Kolla Ansible 配置为使用 jsonfile 缓存插件使用事实缓存。

```
ansible.cfg
[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible-facts
```

You may also wish to set the expiration timeout for the cache via `[defaults] fact_caching_timeout`.
您可能还希望通过 设置 `[defaults] fact_caching_timeout` 缓存的过期超时。

### Populating the cache 填充缓存 ¶

In some situations it may be helpful to populate the fact cache on demand. The `kolla-ansible gather-facts` command may be used to do this.
在某些情况下，按需填充事实缓存可能会有所帮助。该 `kolla-ansible gather-facts` 命令可用于执行此操作。

One specific case where this may be helpful is when running `kolla-ansible` with a `--limit` argument, since in that case hosts that match the limit will gather facts for hosts that fall outside the limit. In the extreme case of a limit that matches only one host, it will serially gather facts for all other hosts. To avoid this issue, run `kolla-ansible gather-facts` without a limit to populate the fact cache in parallel before running the required command with a limit. For example:
这可能有用的一种特定情况是使用 `--limit` 参数运行 `kolla-ansible` 时，因为在这种情况下，与限制匹配的主机将收集超出限制的主机的事实。在限制仅匹配一台主机的极端情况下，它将串行收集所有其他主机的事实。若要避免此问题，请在运行有限制的所需命令之前，无限制地运行 `kolla-ansible gather-facts` 以并行填充事实缓存。例如：

```
kolla-ansible gather-facts
kolla-ansible deploy --limit control01
```

## Fact variable injection 事实变量注入 ¶

By default, Ansible injects a variable for every fact, prefixed with `ansible_`. This can result in a large number of variables for each host, which at scale can incur a performance penalty. Ansible provides a [configuration option](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#inject-facts-as-vars) that can be set to `False` to prevent this injection of facts. In this case, facts should be referenced via `ansible_facts.<fact>`. In recent releases of Kolla Ansible, facts are referenced via `ansible_facts`, allowing users to disable fact variable injection.
默认情况下，Ansible 会为每个事实注入一个变量，并以 `ansible_` 为前缀。这可能会导致每个主机都有大量变量，这在大规模上可能会造成性能损失。Ansible 提供了一个配置选项，可以将其设置为 `False` 防止这种事实注入。在这种情况下，应通过 `ansible_facts.<fact>` 引用事实。在 Kolla Ansible 的最新版本中，事实通过 `ansible_facts` 引用，允许用户禁用事实变量注入。

```
ansible.cfg
[defaults]
inject_facts_as_vars = False
```

## Fact filtering 事实过滤 ¶

Ansible facts filtering can be used to speed up Ansible.  Environments with many network interfaces on the network and compute nodes can experience very slow processing with Kolla Ansible. This happens due to the processing of the large per-interface facts with each task.  To avoid storing certain facts, we can use the `kolla_ansible_setup_filter` variable, which is used as the `filter` argument to the `setup` module. For example, to avoid collecting facts for virtual interfaces beginning with q or t:
Ansible 事实过滤可用于加速 Ansible。在网络和计算节点上具有许多网络接口的环境可能会遇到非常慢的处理速度，而使用 Kolla Ansible  时，处理速度会非常慢。发生这种情况是由于每个任务都处理了每个接口的大量事实。为了避免存储某些事实，我们可以使用变量 `kolla_ansible_setup_filter` ，它被用作 `setup` 模块 `filter` 的参数。例如，要避免收集以 q 或 t 开头的虚拟接口的事实，请执行以下操作：

```
kolla_ansible_setup_filter: "ansible_[!qt]*"
```

This causes Ansible to collect but not store facts matching that pattern, which includes the virtual interface facts. Currently we are not referencing other facts matching the pattern within Kolla Ansible.  Note that including the `ansible_` prefix causes meta facts `module_setup` and `gather_subset` to be filtered, but this seems to be the only way to get a good match on the interface facts.
这会导致 Ansible 收集但不存储与该模式匹配的事实，其中包括虚拟接口事实。目前，我们没有引用与 Kolla Ansible 中的模式相匹配的其他事实。请注意，包含 `ansible_` 前缀会导致元事实 `module_setup` 并被 `gather_subset` 过滤，但这似乎是获得接口事实良好匹配的唯一方法。

The exact improvement will vary, but has been reported to be as large as 18x on systems with many virtual interfaces.
确切的改进会有所不同，但据报道，在具有许多虚拟接口的系统上，改进高达 18 倍。

## Fact gathering subsets 事实收集子集 ¶

It is also possible to configure which subsets of facts are gathered, via `kolla_ansible_setup_gather_subset`, which is used as the `gather_subset` argument to the `setup` module. For example, if one wants to avoid collecting facts via facter:
还可以配置收集哪些事实子集，通过 `kolla_ansible_setup_gather_subset` 用作 `setup` 模块 `gather_subset` 的参数。例如，如果一个人想避免通过facter收集事实：

```
kolla_ansible_setup_gather_subset: "all,!facter"
```

## Max failure percentage 最大失败百分比 ¶

It is possible to specify a [maximum failure percentage](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html#setting-a-maximum-failure-percentage) using `kolla_max_fail_percentage`. By default this is undefined, which is equivalent to a value of 100, meaning that Ansible will continue execution until all hosts have failed or completed. For example:
可以使用 `kolla_max_fail_percentage` 指定最大故障百分比。默认情况下，这是未定义的，相当于值 100，这意味着 Ansible 将继续执行，直到所有主机都发生故障或完成。例如：

```
kolla_max_fail_percentage: 50
```

A max fail percentage may be set for specific services using `<service>_max_fail_percentage`. For example:
可以使用 `<service>_max_fail_percentage` 为特定服务设置最大失败百分比。例如：

```
kolla_max_fail_percentage: 50
nova_max_fail_percentage: 25
```