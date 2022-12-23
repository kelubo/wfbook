# Puppet reports

  Puppet creates a report about its actions and your infrastructure  each time it applies a catalog during a Puppet run. You can create  and use report processors to generate insightful information or alerts from those  reports.



**[Reporting](https://www.puppet.com/docs/puppet/7/reporting_about.html)**
In a client-server configuration, an agent sends its         report to the primary server for processing. In a standalone configuration, the `puppet apply` command processes the node’s         own reports. In both  configurations, report processor plugins handle received reports. If         you enable multiple report processors, Puppet runs all of         them for each report. **[Report reference](https://www.puppet.com/docs/puppet/7/report.html)**
Puppet has a set of built-in report processors, which     you can configure. **[Writing custom report processors](https://www.puppet.com/docs/puppet/7/reporting_write_processors.html)**
Create and use report processors to generate insightful     information or alerts from Puppet reports. You can write your own     report processor in Ruby and include it in a Puppet module. Puppet uses the     processor to send report data to the service in the format you defined. **[Report format](https://www.puppet.com/docs/puppet/7/format_report.html)**
     Puppet 7 generates report format 12.

# Reporting

### Sections

[Report data](https://www.puppet.com/docs/puppet/7/reporting_about.html#report-data)

[Configuring             reporting](https://www.puppet.com/docs/puppet/7/reporting_about.html#configure-reporting)

[Accessing reports](https://www.puppet.com/docs/puppet/7/reporting_about.html#access-reports)

In a client-server configuration, an agent sends its        report to the primary server for processing. In a standalone configuration, the `puppet apply` command processes the node’s        own reports. In both configurations, report processor plugins handle received reports. If        you enable multiple report processors, Puppet runs all of        them for each report.

Each processor typically does one of two things with the report:

- It sends some of the report data to                        another service, such as PuppetDB, that can collate it.
- It triggers alerts on another service                        if the data matches a specified condition, such as a failed run.

That external service can then provide a way to view the processed            report.

## Report data

Puppet report processors handle these points of data:

- Metadata about the node, its                            environment and Puppet version, and the catalog used in the                        run.
- The status of every                        resource.
- Actions, also called events, taken                            during the run.
- Log messages generated during the                            run.
- Metrics about the run, such as its                            duration and how many resources were in a given state.

That external service can then provide a way to view                the processed report.

## Configuring            reporting

An agent sends reports to the primary server by                default. You can turn off reporting by changing the `report` setting in an                    agent’s `puppet.conf` file.

On primary servers and on nodes                running Puppet apply, you can configure enabled report processors as a                comma-separated list in the `reports` setting. The default `reports` value is `'store'`, which stores                reports in the configured `reportdir`. 

To turn off reports                entirely, set `reports` to `'none'`.

For details about configuration                        settings in Puppet, see the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html).

## Accessing reports

There are multiple ways to access Puppet report                    data:

- In Puppet Enterprise (PE), view run logs and event                            reports on the Reports page. See [Infrastructure reports](https://puppet.com/docs/pe/latest/infrastructure_reports.html).
- In PuppetDB, with its [report processor enabled](https://puppet.com/docs/puppetdb/7/connect_puppet_server.html), interface with                            third-party tools such as [Puppetboard](https://github.com/voxpupuli/puppetboard) or [PuppetExplorer](https://github.com/dalen/puppetexplorer). 
- Use one of the [built-in report processors](https://www.puppet.com/docs/puppet/7/report.html). For example,                            the `http`                            processor sends YAML dumps of reports through POST requests to a                            designated URL; the log processor saves received logs to a local `log`                            file.
- Use a report processor from a                            module, such as `tagmail`.
- Query PuppetDB for stored report data and build                            your own tools to display it. For details about the types of data that                                PuppetDB collects and the API                            endpoints it uses, see the [API documentation](https://puppet.com/docs/puppetdb/latest/api/index.html) for the endpoints `events`,                                `event-counts`, and `aggregate-event-counts`.
- Write a custom report                            processor.

**Related information**

- [puppet.conf: The main config file](https://www.puppet.com/docs/puppet/7/config_file_main.html)
- [Writing custom report processors](https://www.puppet.com/docs/puppet/7/reporting_write_processors.html)
- [Report format](https://www.puppet.com/docs/puppet/7/format_report.html)

# Report reference

### Sections

[`http`](https://www.puppet.com/docs/puppet/7/report.html#report-http)

[`log`](https://www.puppet.com/docs/puppet/7/report.html#report-log)

[`store`](https://www.puppet.com/docs/puppet/7/report.html#report-store)

Puppet has a set of built-in report processors, which    you can configure.

By default, after applying a catalog, Puppet generates a        report that includes information about the run: events, log messages, resource statuses,        metrics, and metadata. Each host sends its report as a YAML dump.

The agent sends its report to the primary server for processing, whereas agents running          `puppet apply` process their own reports. Either way, Puppet handles every report with a set of report processors,        which are specified in the `reports` setting in the agent's          `puppet.conf` file.

By default, Puppet uses the `store` report processor. You can enable other report processors or disable        reporting in the `reports` setting.

## `http`

Sends reports via HTTP or HTTPS. This report processor submits reports as POST requests to        the address in the `reporturl` setting. When you specify an        HTTPS URL, the remote server must present a certificate issued by the Puppet CA or the connection fails validation. The body of each        POST request is the YAML dump of a `Puppet::Transaction::Report` object, and the content type is set as `application/x-yaml`. 

## `log`

Sends all received logs to the local log destinations. The usual log        destination is `syslog`.

## `store`

Stores the `yaml` report in the configured          `reportdir`. By default, this is the report processor Puppet uses. These files collect quickly — one every half hour        — so be sure to perform maintenance on them if you use this report. 

# Writing custom report processors

### Sections

[Example         report processor](https://www.puppet.com/docs/puppet/7/reporting_write_processors.html#section_amz_sjj_qgb)

Create and use report processors to generate insightful    information or alerts from Puppet reports. You can write your own    report processor in Ruby and include it in a Puppet module. Puppet uses the    processor to send report data to the service in the format you defined.

A report processor must follow these rules:

- The processor name must be a valid Ruby        symbol that starts with a letter and contains only alphanumeric characters.

- The processor must be in its own Ruby        file, `<PROCESSOR_NAME>.rb`, and stored        inside the Puppet module directory `lib/puppet/reports/`

- The processor code must start with `require 'puppet'`

- The processor code must call the method 

  ```
   Puppet::Reports.register_report(:NAME)
  ```

   This method takes the name        of the report as a symbol, and a mandatory block of code with no arguments that contains:          

  - A Markdown-formatted string describing the processor, passed to            the `desc(<DESCRIPTION>)` method. 
  - An implementation of a method named `process` that contains the report processor's main            functionality. 

Puppet lets the `process` method access a `self` object, which will be a `Puppet::Transaction::Report` object describing a Puppet run.

The processor can access report data by calling accessor methods on        `self`, and it can forward that data to any      service you configure in the report processor. It can also call `self.to_yaml` to dump the entire report to YAML. Note that the YAML      output isn't a safe, well-defined data format — it's a serialized object.

## Example        report processor

To use this report processor, include it in          the comma-separated list of processors in the Puppet primary server's          `reports` setting in `puppet.conf`: `reports =        store,myreport`.

```
# Located in /etc/puppetlabs/puppet/modules/myreport/lib/puppet/reports/myreport.rb.
require 'puppet'
# If necessary, require any other Ruby libraries for this report here.

Puppet::Reports.register_report(:myreport) do
  desc "Process reports via the fictional my_cool_cmdb API."

  # Declare and configure any settings here. We'll pretend this connects to our API.
  my_api = MY_COOL_CMD

  # Define and configure the report processor.
  def process
    # Do something that sets up the API we're sending the report to here.
    # For instance, let's check on the node's status using the report object (self):
    if self.status != nil then
      status = self.status
    else
      status = 'undefined'
    end

    # Next, let's do something if the status equals 'failed'.
    if status == 'failed' then
      # Finally, dump the report object to YAML and post it using the API object:
      my_api.post(self.to_yaml)
    end
  end
endCopied!
```

To use this report processor, include it in the comma-separated list of  processors in the Puppet primary server's `reports` setting in `puppet.conf`:

```
reports = store,myreportCopied!
```

For more examples using this API, see [the built-in reports' source code](https://github.com/puppetlabs/puppet/tree/main/lib/puppet/reports) or one of these custom reports created by a        member of the Puppet community:

- ​          [Report failed runs to Jabber/XMPP](https://github.com/jamtur01/puppet-xmpp)        
- ​          [Send metrics to a             Ganglia server via gmetric](https://github.com/jamtur01/puppet-ganglia)        

These community reports aren't provided or supported by Puppet, Inc.

**Related information**

- [Report format](https://www.puppet.com/docs/puppet/7/format_report.html)

# Report format

### Sections

[`Puppet::Transaction::Report`](https://www.puppet.com/docs/puppet/7/format_report.html#puppet-transaction-report)

[`Puppet::Util::Log`](https://www.puppet.com/docs/puppet/7/format_report.html#puppet-util-log)

[`Puppet::Util::Metric`](https://www.puppet.com/docs/puppet/7/format_report.html#puppet-util-metric)

[`Puppet::Resource::Status`](https://www.puppet.com/docs/puppet/7/format_report.html#puppet-resource-status)

[`Puppet::Transaction::Event`](https://www.puppet.com/docs/puppet/7/format_report.html#puppet-transaction-event)

[Changes since report format 8](https://www.puppet.com/docs/puppet/7/format_report.html#format-9-differences)

​    Puppet 7 generates report format 12.

## `Puppet::Transaction::Report`

| Property                | Type              | Description                                                  |
| ----------------------- | ----------------- | ------------------------------------------------------------ |
| `host`                  | string            | The host that generated this report.                         |
| `time`                  | datetime          | When the Puppet run began.                                   |
| `logs`                  | array             | Zero or more `Puppet::Util::Log` objects.                    |
| `metrics`               | hash              | Maps from string (metric category) to                `Puppet::Util::Metric`. |
| `resource_statuses`     | hash              | Maps from resource name to `Puppet::Resource::Status`        |
| `configuration_version` | string or integer | The configuration version of the Puppet run.                This is a string for user-specified versioning schemes. Otherwise it is an integer                representing seconds since the Unix epoch. |
| `transaction_uuid`      | string            | A UUID covering the transaction. The query parameters for the catalog retrieval                include the same UUID. |
| `code_id`               | string            | The ID of the code input to the compiler.                    |
| `job_id`                | string, or null   | The ID of the job in which this transaction occurred.        |
| `catalog_uuid`          | string            | A primary server generated catalog UUID, useful for connecting a single catalog                to multiple reports. |
| `server_used`           | string            | The name of the primary server used to compile the catalog. If failover                occurred, this holds the first primary server successfully contacted. If this run                had no primary server (for example, a `puppet apply` run), this field                is blank. |
| `report_format`         | string or integer | `"12"` or `12`                                               |
| `puppet_version`        | string            | The version of the Puppet agent.                             |
| `status`                | string            | The transaction status: `failed`, `changed`, or `unchanged`. |
| `transaction_completed` | Boolean           | Whether the transaction completed. For instance, if the transaction had an                unrescued exception, `transaction_completed = false`. |
| `noop`                  | Boolean           | Whether the Puppet run was in no-operation mode                when it ran. |
| `noop_pending`          | Boolean           | Whether there are changes that were not applied because of no-operation                mode. |
| `environment`           | string            | The environment that was used for the Puppet                run. |
| `corrective_change`     | Boolean           | True if a change or no-operation event in this report was caused by an                unexpected change to the system between Puppet                runs. |
| `cached_catalog_status` | string            | The status of the cached catalog used in the run: `not_used`,                  `explicitly_requested`, or `on_failure`. |

## `Puppet::Util::Log`

| Property  | Type     | Description                                                  |
| --------- | -------- | ------------------------------------------------------------ |
| `file`    | string   | The path and filename of the manifest file that triggered the log message. This                property is not always present. |
| `line`    | integer  | The manifest file's line number that triggered the log message. This property                is not always present. |
| `level`   | symbol   | The severity level of the message `:debug`,                  `:info`, `:notice`, `:warning`,                  `:err`, `:alert`, `:emerg`,                  `:crit`. |
| `message` | string   | The text of the message.                                     |
| `source`  | string   | The origin of the log message. This could be a resource, a property of a                resource, or the string "Puppet". |
| `tags`    | array    | Each array element is a string.                              |
| `time`    | datetime | The time at which the message was sent.                      |

## `Puppet::Util::Metric`

A `Puppet::Util::Metric` object represents all the metrics in a single        category.

| Property | Type   | Description                                                  |
| -------- | ------ | ------------------------------------------------------------ |
| `name`   | string | Specifies the name of the metric category. This is the same as the key                associated with this metric in the metrics hash of the                  `Puppet::Transaction::Report`. |
| `label`  | string | The name of the metric formatted as a title. Underscores are replaced with                spaces and the first word is capitalized. |
| `values` | array  | All the metric values within this category. Each value is in the form                  `[name, label, value]`, where `name` is the                particular metric as a string, `label` is the metric name formatted                as a title, and `value` is the metric quantity as an integer or a                float. |

The metrics that appear in a report are part of a fixed set and arranged in the following categories:

- `time`

  Includes a metric for every resource type for which there is at least one resource              in the catalog, plus two additional metrics: `config_retrieval` and                `total`. Each value in the `time` category is a                float.In an inspect report, there is an additional `inspect`                metric.

- `resources`

  Includes the metrics `failed`, `out_of_sync`,                `changed`, and `total`. Each value in the                `resources` category is an integer.

- `events`

  Includes up to five metrics: `success`, `failure`,                `audit`, `noop`, and `total`.                `total` is always present; the others are present when their values              are non-zero. Each value in the `events` category is an integer.

- `changes`

  Includes one metric, `total`. Its value is an integer.

Note: Failed reports contain no metrics.

## `Puppet::Resource::Status`

A `Puppet::Resource::Status` object represents the status of a single        resource.

| Property            | Type     | Description                                                  |
| ------------------- | -------- | ------------------------------------------------------------ |
| `resource_type`     | string   | The resource type, capitalized.                              |
| `title`             | title    | The resource title.                                          |
| `resource`          | string   | The resource name, in the form `Type[title]`. This is always the                same as the key that corresponds to this `Puppet::Resource::Status`                object in the` resource_statuses` hash. Deprecated. |
| `provider_used`     | string   | The name of the provider used by the resource.               |
| `file`              | string   | The path and filename of the manifest file that declared the resource. |
| `line`              | integer  | The line number in the manifest file that declared the resource. |
| `evaluation_time`   | float    | The amount of time, in seconds, taken to evaluate the resource. Not present in                inspect reports. |
| `change_count`      | integer  | The number of properties that changed. Always `0`                in inspect reports. |
| `out_of_sync_count` | integer  | The number of properties that were out of sync. Always `0` in inspect reports. |
| `tags`              | array    | The strings with which the resource is tagged.               |
| `time`              | datetime | The time at which the resource was evaluated.                |
| `events`            | array    | The `Puppet::Transaction::Event` objects for the                resource. |
| `out_of_sync`       | Boolean  | True when `out_of_sync_count > 0`, otherwise false.                Deprecated. |
| `changed`           | Boolean  | True when `change_count > 0`, otherwise false.                Deprecated. |
| `skipped`           | Boolean  | True when the resource was skipped, otherwise false.         |
| `failed`            | Boolean  | True when Puppet experienced an error while                evaluating this resource, otherwise false. Deprecated. |
| `failed_to_restart` | Boolean  | True when Puppet experienced an error while                trying to restart this resource, for example, when a Service resource has been                notified from another resource. |
| `containment_path`  | array    | An array of strings; each element represents a container (type or class) that,                together, make up the path of the resource in the catalog. |

## `Puppet::Transaction::Event`

A `Puppet::Transaction::Event` object represents a single event for a single        resource.

| Property            | Type                   | Description                                                  |
| ------------------- | ---------------------- | ------------------------------------------------------------ |
| `audited`           | Boolean                | True when this property is being audited, otherwise false. True in inspect                reports. |
| `property`          | string                 | The property for which the event occurred. This value is missing if the                provider errored out before it could be determined. |
| `previous_value`    | string, array, or hash | The value of the property before the change (if any) was applied. This value is                missing if the provider errored out before it could be determined. |
| `desired_value`     | string, array, or hash | The value specified in the manifest. Absent in inspect reports. This value is                missing if the provider errored out before it could be determined. |
| `historical_value`  | string, array, or hash | The audited value from a previous run of Puppet,                if known. Otherwise nil. Absent in inspect reports. This value is missing if the                provider errored out before it could be determined. |
| `message`           | string                 | The log message generated by this event.                     |
| `name`              | symbol                 | The name of the event. Absent in inspect reports.            |
| `status`            | string                 | The event status:                   `success`: Property was out of sync and was successfully                    changed to be in sync.                   `failure`: Property was out of sync and couldn’t be changed to                    be in sync due to an error.                   `noop`: Property was out of sync but wasn’t changed because the                    run was in no-operation mode.                    `audit`: Property was in sync and was being audited. Inspect                    reports are always in `audit` status. |
| `redacted`          | Boolean                | Whether this event has been redacted.                        |
| `time`              | datetime               | The time at which the property was evaluated.                |
| `corrective_change` | Boolean                | True if this event was caused by an unexpected change to the system between Puppet runs. |

## Changes since report format 8

Most of report format 12 is backwards compatible with formats 9-11, but includes the        following changes:

- Version 8: `transaction_completed` was added to `Puppet::Transaction::Report`
- Version 9: `provider_used` was added to `Puppet::Resource::Status`
- Version 10: `failed_to_restart` was added to `Puppet::Resource::Status`
- Version 11: `server_used` was added to `Puppet::Transaction::Report`
- Version 12: `master_used` was removed from `Puppet::Transaction::Report`

Note that version 12 only exists in Puppet 7. For more        information, see the [report schema](https://github.com/puppetlabs/puppet/blob/main/api/schemas/report.json). 

​          