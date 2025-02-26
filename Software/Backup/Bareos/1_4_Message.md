# Messages Configuration[](https://docs.bareos.org/Configuration/Messages.html#messages-configuration)

>  

## Messages Resource[](https://docs.bareos.org/Configuration/Messages.html#messages-resource)

The Messages resource defines how messages are to be handled and destinations to which they should be sent.

Even though each daemon has a full message handler, within the Bareos File Daemon and the Bareos Storage Daemon, you will normally choose to  send all the appropriate messages back to the Bareos Director. This  permits all the messages associated with a single Job to be combined in  the Director and sent as a single email message to the user, or logged  together in a single file.

Each message that Bareos generates (i.e. that each daemon generates)  has an associated type such as INFO, WARNING, ERROR, FATAL, etc. Using  the message resource, you can specify which message types you wish to  see and where they should be sent. In addition, a message may be sent to multiple destinations. For example, you may want all error messages  both logged as well as sent to you in an email. By defining multiple  messages resources, you can have different message handling for each  type of Job (e.g. Full backups versus Incremental backups).

In general, messages are attached to a Job and are included in the  Job report. There are some rare cases, where this is not possible, e.g.  when no job is running, or if a communications error occurs between a  daemon and the director. In those cases, the message may remain in the  system, and should be flushed at the end of the next Job.

The records contained in a Messages resource consist of a destination specification followed by a list of message-types in the format: 

destination = message-type1, message-type2, message-type3, …

or for those destinations that need and address specification (e.g. email):

- destination = address = message-type1, message-type2, message-type3, …

    where  destinationis one of a predefined set of keywords that define where the message is to be sent ([`Append (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Append), [`Console (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Console), [`File (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_File), [`Mail (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Mail), …), addressvaries according to the destination keyword, but is typically an email address or a filename, [message-type](https://docs.bareos.org/Configuration/Messages.html#messagetypes)is one of a predefined set of keywords that define the type of message generated by Bareos: ERROR, WARNING, FATAL, …

| configuration directive name                                 | type of data                                                 | default value | remark |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------ |
| [`Append (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Append) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Catalog (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Catalog) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Console (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Console) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Description (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Director (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Director) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`File (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_File) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Mail) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Mail On Error (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnError) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail On Success (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnSuccess) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Name (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               |        |
| [`Operator (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Operator) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Operator Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_OperatorCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Stderr (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Stderr) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Stdout (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Stdout) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Syslog (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Syslog) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Timestamp Format (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_TimestampFormat) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |

- Append[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Append)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Append the message to the filename given in the address field. If the file already exists, it will be appended to. If the file does not  exist, it will be created.

- Catalog[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Catalog)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the Catalog database. The message will be written to the table named Log and a timestamp field will also be added. This  permits Job Reports and other messages to be recorded in the Catalog so  that they can be accessed by reporting software. Bareos will prune the  Log records associated with a Job when the Job records are pruned.  Otherwise, Bareos never uses these records internally, so this  destination is only used for special purpose programs (e.g. frontend  programs).

- Console[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Console)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the Bareos console. These messages are held until the console program connects to the Director.

- Description[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Director[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Director)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the Director whose name is given in the address  field. Note, in the current implementation, the Director Name is  ignored, and the message is sent to the Director that started the Job.

- File[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_File)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the filename given in the address field. If the file already exists, it will be overwritten.

- Mail[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Mail)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the email addresses that are given as a comma  separated list (without any space) in the address field. Mail messages  are grouped together during a job and then sent as a single email  message when the job terminates. The advantage of this destination is  that you are notified about every Job that runs. However, if you backup  mutliple machines every night, the number of email messages can be  annoying. Some users use filter programs such as **procmail** to automatically file this email based on the Job termination code (see [`Mail Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand)).

- Mail Command[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  In the absence of this resource, Bareos will send all mail using the following command: /usr/lib/sendmail -F BAREOS <recipients> In many cases, depending on your machine, this command may not work. However, by using the **Mail Command**, you can specify exactly how to send the mail. During the processing of  the command part, normally specified as a quoted string, the following  substitutions will be used: %% = % %c = Client’s name %d = Director’s name %e = Job Exit code (OK, Error, …) %h = Client address %i = Job Id %j = Unique Job name %l = Job level %n = Job name %r = Recipients %s = Since time %t = Job type (e.g. Backup, …) %v = Read Volume name (Only on director side) %V = Write Volume name (Only on director side) Please note: any **Mail Command** directive must be specified in the Messages resource before the desired [`Mail (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Mail), [`Mail On Success (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnSuccess) or [`Mail On Error (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnError) directive. In fact, each of those directives may be preceded by a different **Mail Command**. A default installation will use the program bsmtp as **Mail Command**. The program **bsmtp** is provided by Bareos and unifies the usage of a mail client to a certain degree: `Mail Command = "/usr/sbin/bsmtp -h mail.example.com -f \"\(Bareos\) \%r\" -s \"Bareos: \%t \%e of \%c \%l\" \%r" `



- Mail On Error[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnError)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the email addresses that are given as a comma  separated list (without any space) in the address field if the Job  terminates with an error condition. **Mail On Error**  messages are grouped together during a job and then sent as a single  email message when the job terminates. This destination differs from the mail destination in that if the Job terminates normally, the message is totally discarded (for this destination). If the Job terminates in  error, it is emailed. By using other destinations such as append you can ensure that even if the  Job terminates normally, the output information is saved.

- Mail On Success[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailOnSuccess)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the email addresses that are given as a comma  separated list (without any space) in the address field if the Job  terminates normally (no error condition). **Mail On Success** messages are grouped together during a job and then sent as a single  email message when the job terminates. This destination differs from the mail destination in that if the Job terminates abnormally, the message  is totally discarded (for this destination). If the Job terminates  normally, it is emailed.

- Name[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Name)

  Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the Messages resource. The name you specify here will be  used to tie this Messages resource to a Job and/or to the daemon.

- Operator[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Operator)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the email addresses that are specified as a comma separated list (without any space) in the address field. This is  similar to mail above, except that each message is sent as received.  Thus there is one email per message. This is most useful for mount  messages (see below).

- Operator Command[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_OperatorCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  This resource specification is similar to the [`Mail Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand) except that it is used for Operator messages. The substitutions performed for the [`Mail Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand) are also done for this command. Normally, you will set this command to the same value as specified for the [`Mail Command (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_MailCommand). The **Operator Command** directive must appear in the Messages resource before the [`Operator (Dir->Messages)`](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Operator) directive.

- Stderr[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Stderr)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the standard error output (normally not used).

- Stdout[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Stdout)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the standard output (normally not used).

- Syslog[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_Syslog)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)  Send the message to the system log (syslog). Since *Version >= 14.4.0* the facility can be specified in the address field and the loglevel correspond to the Bareos [Message Types](https://docs.bareos.org/Configuration/Messages.html#messagetypes). The defaults are **DAEMON** and **LOG_ERR**. Although the syslog destination is not used in the default Bareos  config files, in certain cases where Bareos encounters errors in trying  to deliver a message, as a last resort, it will send it to the system  syslog to prevent loss of the message, so you might occassionally check  the syslog for Bareos output.

- Timestamp Format[](https://docs.bareos.org/Configuration/Messages.html#config-Dir_Messages_TimestampFormat)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)



## Message Types[](https://docs.bareos.org/Configuration/Messages.html#message-types)

For any destination, the message-type field is a comma separated list of the following types or classes of messages:

- info

    General information messages.

- warning

    Warning messages. Generally this is some unusual condition but not expected to be serious.

- error

    Non-fatal  error messages. The job continues running. Any error message should be  investigated as it means that something went wrong.

- fatal

    Fatal error messages. Fatal errors cause the job to terminate.

- terminate

    Message generated when the daemon shuts down.

- notsaved

    Files not saved because of some error. Usually because the file cannot be accessed (i.e. it does not exist or is not mounted).

- skipped

    Files that  were skipped because of a user supplied option such as an incremental  backup or a file that matches an exclusion pattern. This is not  considered an error condition such as the files listed for the notsaved  type because the configuration file explicitly requests these types of  files to be skipped. For example, any unchanged file during an  incremental backup, or any subdirectory if the no recursion option is  specified.

- mount

    Volume  mount or intervention requests from the Storage daemon. These requests  require a specific operator intervention for the job to continue.

- restored

    The ls style listing generated for each file restored is sent to this message class.

- all

    All message types.

- security

    Security info/warning messages principally from unauthorized connection attempts.

- alert

    Alert messages. These are messages generated by tape alerts.

- volmgmt

    Volume management messages. Currently there are no volume management messages generated.

- audit

     Audit messages. Interacting with the Bareos Director will be audited. Can be configured with in resource [`Auditing (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Auditing).

The following is an example of a valid Messages resource definition,  where all messages except files explicitly skipped or daemon termination messages are sent by email to [backupoperator@example.com](mailto:backupoperator@example.com). In addition all mount messages are sent to the operator (i.e. emailed to [backupoperator@example.com](mailto:backupoperator@example.com)). Finally all messages other than explicitly skipped files and files saved are sent to the console:

Message resource[](https://docs.bareos.org/Configuration/Messages.html#id1)

```
Messages {
  Name = Standard
  Mail = backupoperator@example.com = all, !skipped, !terminate
  Operator = backupoperator@example.com = mount
  Console = all, !skipped, !saved
}
```

With the exception of the email address, an example Director’s Messages resource is as follows:

Message resource[](https://docs.bareos.org/Configuration/Messages.html#id2)

```
Messages {
  Name = Standard
  Mail Command = "/usr/sbin/bsmtp -h mail.example.com  -f \"\(Bareos\) %r\" -s \"Bareos: %t %e of %c %l\" %r"
  Operator Command = "/usr/sbin/bsmtp -h mail.example.com -f \"\(Bareos\) %r\" -s \"Bareos: Intervention needed for %j\" %r"
  Mail On Error = backupoperator@example.com = all, !skipped, !terminate
  Append = "/var/log/bareos/bareos.log" = all, !skipped, !terminate
  Operator = backupoperator@example.com = mount
  Console = all, !skipped, !saved
}
```