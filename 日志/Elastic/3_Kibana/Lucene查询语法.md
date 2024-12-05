# Lucene query syntax Lucene 查询语法

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/lucene.asciidoc)

Lucene query syntax is available to Kibana users who opt out of the [Kibana Query Language](https://www.elastic.co/guide/en/kibana/current/kuery-query.html). Full documentation for this syntax is available as part of Elasticsearch [query string syntax](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/query-dsl-query-string-query.html#query-string-syntax).
Lucene 查询语法可供选择退出 [Kibana 查询语言](https://www.elastic.co/guide/en/kibana/current/kuery-query.html)的 Kibana 用户使用。此语法的完整文档作为 Elasticsearch [查询字符串语法](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/query-dsl-query-string-query.html#query-string-syntax)的一部分提供。

The main reason to use the Lucene query syntax in Kibana is for advanced Lucene features, such as regular expressions or fuzzy term matching. However, Lucene syntax is not able to search nested objects or scripted fields.
在 Kibana 中使用 Lucene 查询语法的主要原因是高级 Lucene 功能，例如正则表达式或模糊术语匹配。但是，Lucene 语法无法搜索嵌套对象或脚本字段。

To use the Lucene syntax, open the **Saved query** menu, and then select **Language: KQL** > **Lucene**.
若要使用 Lucene 语法，请打开 **Saved query** 菜单，然后选择 **Language： KQL** > **Lucene**。

![Click the circle icon for the saved query menu](https://www.elastic.co/guide/en/kibana/current/concepts/images/lucene.png)

To perform a free text search, simply enter a text string. For example, if you’re searching web server logs, you could enter `safari` to search all fields:
要执行自由文本搜索，只需输入文本字符串即可。例如，如果您正在搜索 Web 服务器日志，则可以输入 `safari` 来搜索所有字段：

```yaml
safari
```

To search for a value in a specific field, prefix the value with the name of the field:
要在特定字段中搜索值，请在值前加上字段名称：

```yaml
status:200
```

To search for a range of values, use the bracketed range syntax, `[START_VALUE TO END_VALUE]`. For example, to find entries that have 4xx status codes, you could enter `status:[400 TO 499]`.
要搜索值范围，请使用带括号的范围语法 `[START_VALUE TO END_VALUE]。`例如，要查找具有 4xx 状态代码的条目，您可以输入 `status：[400 TO 499]。`

```yaml
status:[400 TO 499]
```

For an open range, use a wildcard:
对于开放范围，请使用通配符：

```yaml
status:[400 TO *]
```

To specify more complex search criteria, use the boolean operators `AND`, `OR`, and `NOT`. For example, to find entries that have 4xx status codes and have an extension of `php` or `html`:
要指定更复杂的搜索条件，请使用布尔运算符 `AND`、`OR` 和 `NOT`。例如，要查找具有 4xx 状态代码且扩展名为 `php` 或 `html` 的条目：

```yaml
status:[400 TO 499] AND (extension:php OR extension:html)
```