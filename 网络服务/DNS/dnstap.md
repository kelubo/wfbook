# 在 RHEL 中使用 dnstap 记录 DNS 查询

​			作为网络管理员，您可以记录域名系统(DNS)详情来分析 DNS 流量模式、监控 DNS 服务器性能，并对 DNS 问题进行故障排除。如果您希望一个高级方法来监控和记录传入名称查询的详细信息，请使用 `dnstap` 接口记录从 `named` 服务发送的消息。您可以捕获并记录 DNS 查询来收集网站或 IP 地址的信息。 	

**先决条件**

- ​					将 `BIND` 软件包升级到 `bind-9.16.15-3` 或更高版本，其中包含 `dnstap` 接口。 			

警告

​				如果您已安装并运行了 `BIND` 版本，添加新版本的 `BIND` 将覆盖现有的版本。 		

**流程**

1. ​					通过编辑 `options` 块中的 `/etc/named.conf` 文件来启用 `dnstap` 和目标文件： 			

   

   ```none
   options
   {
   # …
   
   dnstap { all; }; # Configure filter
   dnstap-output file "/var/named/data/dnstap.bin" versions 2;
   
   # …
   };
   # end of options
   ```

2. ​					要指定您要记录的 DNS 流量类型，请将 `dnstap` 过滤器添加到 `/etc/named.conf` 文件中的 `dnstap` 块中。您可以使用以下过滤器： 			

   - ​							`auth` - 权威区域响应或回答。 					
   - ​							`client` - 内部客户端查询或回答。 					
   - ​							`forwarder` - 转发的查询或来自它的响应。 					
   - ​							`resolver` - 迭代的解析查询或响应。 					
   - ​							`update` - 动态区域更新请求。 					
   - ​							`all` - 以上选项中的任何一个。 					
   - ​							` query ` 或 `response` - 如果您没有指定查询或 `响应` 关键字，则 `dnstap` 记录。 					

   注意

   ​						`dnstap` 过滤器包含多个由 `;` 分隔的定义，其语法如下： `dnstap {(all | auth | client | forwarder | resolver | update)[(query | response)]; …  };` 				

3. ​					要在记录的数据包中自定义 `dnstap` 工具的行为，请通过提供额外的参数来修改 `dnstap-output` 选项，如下所示： 			

   - ​							`size` (unlimited | <size>)- 在其大小达到指定限制时启用自动滚动 `dnstap` 文件。 					

   - ​							`version` (unlimited | <integer>)- 指定要保留的自动滚动文件数量。 					

   - ​							`后缀` (increment | timestamp )- 为推出文件选择命名约定。默认情况下，递增以 `.0` 开头。或者，您可以通过设置时间戳值来使用 UNIX `时间戳`。 					

     ​							以下示例仅请求 `auth` 响应、`客户端查询` 以及动态更新的查询和响应： `` 					

     

     ```none
     Example:
     
     dnstap {auth response; client query; update;};
     ```

4. ​					要应用您的更改，重启 `named` 服务： 			

   

   ```none
   # systemctl restart named.service
   ```

5. ​					为活跃日志配置定期推出部署 			

   ​					在以下示例中，`cron` 调度程序每天运行一次后运行用户编辑脚本的内容。值 `3` 的 `roll` 选项指定 `dnstap` 最多可以创建三个备份日志文件。值 `3` 覆盖 `dnstap-output` 变量的 `version` 参数，并将备份日志文件数量限制为三个。此外，二进制日志文件被移到另一个目录并重命名，并且永远不会达到 `.2` 后缀，即使三个备份文件已存在。如果根据大小限制自动滚动二进制日志，您可以跳过这一步。 			

   

   ```none
   Example:
   
   sudoedit /etc/cron.daily/dnstap
   
   #!/bin/sh
   rndc dnstap -roll 3
   mv /var/named/data/dnstap.bin.1 \ /var/log/named/dnstap/dnstap-$(date -I).bin
   
   # use dnstap-read to analyze saved logs
   sudo chmod a+x /etc/cron.daily/dnstap
   ```

6. ​					使用 `dnstap-read` 工具以人类可读格式处理和分析日志： 			

   ​					在以下示例中，dns `tap-read` 工具以 `YAML` 文件格式打印输出。 			

   

   ```none
   Example:
   
   dnstap-read -y [file-name]
   ```