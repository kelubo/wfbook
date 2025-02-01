# Command Line Interface

[TOC]

## placement-manage

**placement-manage** 用于执行 Placement 服务的管理任务。它专为操作员和部署人员而设计。

```bash
placement-manage  [-h] [--config-dir DIR] [--config-file PATH] <category> <command> [<args>]
```

不带参数运行以查看可用命令类别的列表：

```bash
placement-manage
```

You can also run with a category argument such as `db` to see a list of all commands in that category:
还可以使用 category 参数（例如 `db` ）运行，查看该类别中所有命令的列表：

```bash
placement-manage db
```

默认情况下，配置选项（例如 `[placement_database]/connection` URL）位于 `/etc/placement/placement.conf` 文件中。 `config-dir` 和 `config-file` 参数可用于选择其他文件。

### Placement 数据库

- `placement-manage db version`

  打印当前数据库版本。

- `placement-manage db sync`

  将数据库架构升级到最新版本。The local database connection is determined by `[placement_database]/connection` in the configuration file used by placement-manage. 本地数据库连接由 `[placement_database]/connection` placement-manage 使用的配置文件确定。如果未设置该 `connection` 选项，则命令将失败。定义的数据库必须已存在。

- `placement-manage db stamp <version>`

  Stamp the revision table with the given revision; don’t run any migrations. This can be used when the database already exists and you want to bring it under alembic control. 在修订表上盖上给定的修订版;不要运行任何迁移。当数据库已存在并且您希望将其置于 alembic 控制之下时，可以使用此功能。

- `placement-manage db online_data_migrations [--max-count]`

  执行数据迁移以更新所有实时数据。

   `--max-count` controls the maximum number of objects to migrate in a given call. If not specified, migration will occur in batches of 50 until fully complete.  `--max-count` 控制在给定调用中要迁移的最大对象数。如果未指定，迁移将分批进行，每批 50 个，直到完全完成。

  Returns exit code 0 if no (further) updates are possible, 1 if the `--max-count` option was used and some updates were completed successfully (even if others generated errors), 2 if some updates generated errors and no other migrations were able to take effect in the last batch attempted, or 127 if invalid input is provided (e.g. non-numeric max-count). 如果无法进行（进一步）更新，则返回退出代码 0，如果使用了该 `--max-count` 选项并且某些更新已成功完成（即使其他更新生成了错误），则返回退出代码 2，如果某些更新生成了错误，并且其他迁移在最后一次尝试的批次中无法生效，则返回退出代码 0，如果提供了无效的输入（例如，非数字 max-count），则返回退出代码 127。

  This command should be called after upgrading database schema and placement services on all controller nodes. If it exits with partial updates (exit status 1) it should be called again, even if some updates initially generated errors, because some updates may depend on others having completed. If it exits with status 2, intervention is required to resolve the issue causing remaining updates to fail. It should be considered successfully completed only when the exit status is 0. 在所有控制器节点上升级数据库模式和放置服务后，应调用此命令。如果它退出时出现部分更新（退出状态 1），则应再次调用它，即使某些更新最初生成了错误，因为某些更新可能依赖于其他更新是否已完成。如果它以状态 2  退出，则需要干预来解决导致剩余更新失败的问题。仅当退出状态为 0 时，才应视为成功完成。

  例如：

  ```bash
  placement-manage db online_data_migrations
  Running batches of 50 until complete
  2 rows matched query create_incomplete_consumers, 2 migrated
  +---------------------------------------------+-------------+-----------+
  |                  Migration                  | Total Found | Completed |
  +---------------------------------------------+-------------+-----------+
  |            set_root_provider_ids            |      0      |     0     |
  |         create_incomplete_consumers         |      2      |     2     |
  +---------------------------------------------+-------------+-----------+
  ```

  the `create_incomplete_consumers` migration found two candidate records which required a data migration. Since `--max-count` defaults to 50 and only two records were migrated with no more candidates remaining, the command completed successfully with exit code 0. 在上面的示例中， `create_incomplete_consumers` 迁移发现了两个需要数据迁移的候选记录。由于 `--max-count` 默认值为 50，并且只迁移了两条记录，没有更多的候选记录，因此该命令成功完成，退出代码为 0。

## placement-status

**placement-status** 是一种工具，它提供了用于检查 Placement 部署状态的例程。

```bash
placement-status <category> <command> [<args>]
```

不带参数运行以查看可用命令类别的列表：

```bash
placement-status
```

Categories are: 类别包括：

- `upgrade`

You can also run with a category argument such as `upgrade` to see a list of all commands in that category:
还可以使用 category 参数（例如 `upgrade` ）运行，查看该类别中所有命令的列表：

```bash
placement-status upgrade
```

### Upgrade

- `placement-status upgrade check`

  Performs a release-specific readiness check before restarting services with new code.在使用新代码重新启动服务之前执行特定于版本的就绪情况检查。此命令需要具有完整的配置以及对数据库和服务的访问权限。

  | 返回代码 | 描述                                                         |
  | -------- | ------------------------------------------------------------ |
  | 0        | 所有升级准备情况检查都已成功通过，无需执行任何操作。         |
  | 1        | At least one check encountered an issue and requires further investigation. This is considered a warning but the upgrade may be OK. 至少有一项检查遇到了问题，需要进一步调查。这被视为警告，但升级可能正常。 |
  | 2        | There was an upgrade status check failure that needs to be investigated. This should be considered something that stops an upgrade. 存在需要调查的升级状态检查失败。这应该被视为停止升级的事情。 |
  | 255      | 发生意外错误。                                               |

  **History of Checks 检查历史**

  **1.0.0 (Stein)** Checks were added for incomplete consumers and missing root provider ids both of which can be remedied by running the `placement-manage db online_data_migrations` command. 添加了对不完整使用者和缺少根提供程序 ID 的检查，这两者都可以通过运行命令 `placement-manage db online_data_migrations` 进行补救。 

  **2.0.0 (Train)** The `Missing Root Provider IDs` upgrade check will now result in a failure if there are still `resource_providers` records with a null `root_provider_id` value. 如果仍有 `resource_providers` 具有 null `root_provider_id` 值的记录， `Missing Root Provider IDs` 则升级检查现在将导致失败。