# Troubleshooting Guide 疑难解答指南

​        version 版本              



## Failures 失败 ¶

If Kolla fails, often it is caused by a CTRL-C during the deployment process or a problem in the `globals.yml` configuration.
如果 Kolla 失败，通常是由部署过程中的 CTRL-C 或 `globals.yml` 配置中的问题引起的。

To correct the problem where Operators have a misconfigured environment, the Kolla community has added a precheck feature which ensures the deployment targets are in a state where Kolla may deploy to them. To run the prechecks:
为了纠正操作员的环境配置错误的问题，Kolla 社区添加了预检查功能，可确保部署目标处于 Kolla 可以部署到它们的状态。要运行预检查，请执行以下操作：

```
kolla-ansible prechecks
```

If a failure during deployment occurs it nearly always occurs during evaluation of the software. Once the Operator learns the few configuration options required, it is highly unlikely they will experience a failure in deployment.
如果在部署过程中发生故障，则几乎总是在软件评估期间发生。一旦操作员了解了所需的几个配置选项，他们就不太可能在部署中遇到失败。

Deployment may be run as many times as desired, but if a failure in a bootstrap task occurs, a further deploy action will not correct the problem. In this scenario, Kolla’s behavior is undefined.
部署可以根据需要运行多次，但如果引导任务失败，则进一步的部署操作将无法解决问题。在这种情况下，Kolla 的行为是未定义的。

The fastest way during to recover from a deployment failure is to remove the failed deployment:
从部署失败中恢复的最快方法是删除失败的部署：

```
kolla-ansible destroy -i <<inventory-file>>
```

Any time the tags of a release change, it is possible that the container implementation from older versions won’t match the Ansible playbooks in a new version. If running multinode from a registry, each node’s Docker image cache must be refreshed with the latest images before a new deployment can occur. To refresh the docker cache from the local Docker registry:
每当版本的标记发生更改时，旧版本中的容器实现都可能与新版本中的 Ansible playbook 不匹配。如果从注册表运行多节点，则必须先使用最新映像刷新每个节点的 Docker  映像缓存，然后才能进行新部署。要从本地 Docker 注册表刷新 docker 缓存，请执行以下操作：

```
kolla-ansible pull
```

## Debugging Kolla 调试检查 ¶

The status of containers after deployment can be determined on the deployment targets by executing:
部署后的容器状态可以通过执行以下命令在部署目标上确定：

```
docker ps -a
```

If any of the containers exited, this indicates a bug in the container. Please seek help by filing a [launchpad bug](https://bugs.launchpad.net/kolla-ansible/+filebug) or contacting the developers via IRC.
如果任何容器退出，则表示容器中存在错误。请通过提交启动板错误或通过 IRC 联系开发人员来寻求帮助。

The logs can be examined by executing:
可以通过执行以下命令来检查日志：

```
docker exec -it fluentd bash
```

The logs from all services in all containers may be read from `/var/log/kolla/SERVICE_NAME`
可以从中读取 `/var/log/kolla/SERVICE_NAME` 所有容器中所有服务的日志

If the stdout logs are needed, please run:
如果需要 stdout 日志，请运行：

```
docker logs <container-name>
```

Note that most of the containers don’t log to stdout so the above command will provide no information.
请注意，大多数容器不会记录到 stdout，因此上述命令不会提供任何信息。

To learn more about Docker command line operation please refer to [Docker documentation](https://docs.docker.com/reference/).
要了解有关 Docker 命令行操作的更多信息，请参阅 Docker 文档。

The log volume “kolla_logs” is linked to `/var/log/kolla` on the host. You can find all kolla logs in there.
日志卷“kolla_logs” `/var/log/kolla` 链接到主机上。你可以在那里找到所有的kolla日志。

```
readlink -f /var/log/kolla
/var/lib/docker/volumes/kolla_logs/_data
```

When `enable_central_logging` is enabled, to view the logs in a web browser using Kibana, go to `http://<kolla_internal_vip_address>:<kibana_server_port>` or `http://<kolla_external_vip_address>:<kibana_server_port>`. Authenticate using `<kibana_user>` and `<kibana_password>`.
启用后 `enable_central_logging` ，要使用 Kibana 在 Web 浏览器中查看日志，请转到 `http://<kolla_internal_vip_address>:<kibana_server_port>` 或 `http://<kolla_external_vip_address>:<kibana_server_port>` 。使用 `<kibana_user>` 和 `<kibana_password>` 进行身份验证。

The values `<kolla_internal_vip_address>`, `<kolla_external_vip_address>` `<kibana_server_port>` and `<kibana_user>` can be found in `<kolla_install_path>/kolla/ansible/group_vars/all.yml` or if the default values are overridden, in `/etc/kolla/globals.yml`. The value of `<kibana_password>` can be found in `/etc/kolla/passwords.yml`.
值 `<kolla_internal_vip_address>` 和 `<kolla_external_vip_address>` `<kibana_server_port>` `<kibana_user>` 可以在 中找到 `<kolla_install_path>/kolla/ansible/group_vars/all.yml` ，或者如果默认值被覆盖，则可以在 中找到 `/etc/kolla/globals.yml` 。的 `<kibana_password>` 值可以在 中找到 `/etc/kolla/passwords.yml` 。