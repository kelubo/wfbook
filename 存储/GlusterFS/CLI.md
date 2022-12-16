## Gluster Command Line Interface

### Overview

Use the Gluster CLI to setup and manage your Gluster cluster from a terminal. You can run the Gluster CLI on any Gluster server either by invoking the commands or by running the Gluster CLI in interactive mode. You can also use the gluster command remotely using SSH.

The gluster CLI syntax is `gluster <command>`.

To run a command directly:

```

gluster <command>
```

For example, to view the status of all peers:

```

gluster peer status
```

To run a command in interactive mode, start a gluster shell by typing:

```

gluster
```

This will open a gluster command prompt. You now run the command at the prompt.

```

gluster> <command>
```

For example, to view the status of all peers,

```

gluster> peer status
```

#### Peer Commands

The peer commands are used to manage the Trusted Server Pool (TSP).

| Command     | Syntax               | Description                                |
| ----------- | -------------------- | ------------------------------------------ |
| peer probe  | peer probe *server*  | Add *server* to the TSP                    |
| peer detach | peer detach *server* | Remove *server* from the TSP               |
| peer status | peer status          | Display the status of all nodes in the TSP |
| pool list   | pool list            | List all nodes in the TSP                  |

#### Volume Commands

The volume commands are used to setup and manage Gluster volumes.

| Command              | Syntax                                                       | Description                                                  |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| volume create        | volume create *volname*  [options] *bricks*                  | Create a volume called *volname* using the specified bricks with the configuration specified by options |
| volume start         | volume start *volname*  [force]                              | Start volume *volname*                                       |
| volume stop          | volume stop *volname*                                        | Stop volume *volname*                                        |
| volume info          | volume info [*volname*]                                      | Display volume info for *volname* if provided, else for all volumes on the TSP |
| volume status        | volumes status[*volname*]                                    | Display volume status for *volname* if provided, else for all volumes on the TSP |
| volume list          | volume list                                                  | List all volumes in the TSP                                  |
| volume set           | volume set *volname* *option* *value*                        | Set *option* to *value* for *volname*                        |
| volume get           | volume get *volname* <*option*\|all>                         | Display the value of *option* (if specified)for *volname* , or all options otherwise |
| volume add-brick     | volume add-brick *brick-1* ... *brick-n*                     | Expand *volname* to include the bricks *brick-1* to *brick-n* |
| volume remove-brick  | volume remove-brick *brick-1* ... *brick-n* \<start\|stop\|status\|commit\|force> | Shrink *volname* by removing the bricks *brick-1* to *brick-n* . *start* will trigger a rebalance to migrate data from the removed bricks. *stop* will stop an ongoing remove-brick operation. *force* will remove the bricks immediately and any data on them will no longer be accessible from Gluster clients. |
| volume replace-brick | volume replace-brick *volname* *old-brick* *new-brick*       | Replace *old-brick* of *volname* with *new-brick*            |
| volume delete        | volume delete *volname*                                      | Delete *volname*                                             |

For additional detail of all the available CLI commands, please refer to `man gluster` output.