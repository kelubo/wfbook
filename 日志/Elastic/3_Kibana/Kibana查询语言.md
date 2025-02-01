# Kibana Query Language Kibana 查询语言

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

The Kibana Query Language (KQL) is a simple text-based query language for filtering data.
Kibana 查询语言 （KQL） 是一种简单的基于文本的查询语言，用于筛选数据。

- KQL only filters data, and has no role in aggregating, transforming, or sorting data. 
  KQL 仅筛选数据，在聚合、转换或排序数据方面没有任何作用。
- KQL is not to be confused with the [Lucene query language](https://www.elastic.co/guide/en/kibana/current/lucene-query.html), which has a different feature set. 
  不要将 KQL 与 [Lucene 查询语言](https://www.elastic.co/guide/en/kibana/current/lucene-query.html)混淆，后者具有不同的功能集。

Use KQL to filter documents where a value for a field exists, matches a given value, or is within a given range.
使用 KQL 筛选字段值存在、与给定值匹配或位于给定范围内的文档。

## Filter for documents where a field exists 筛选存在字段的文档

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

To filter documents for which an indexed value exists for a given field, use the `*` operator. For example, to filter for documents where the `http.request.method` field exists, use the following syntax:
要筛选给定字段存在索引值的文档，请使用 `*` 运算符。例如，要筛选存在 `http.request.method` 字段的文档，请使用以下语法：

```yaml
http.request.method: *
```

This checks for any indexed value, including an empty string.
这将检查任何索引值，包括空字符串。

## Filter for documents that match  a value 筛选与值匹配的文档

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

Use KQL to filter for documents that match a specific number, text, date, or boolean value. For example, to filter for documents where the `http.request.method` is GET, use the following query:
使用 KQL 筛选与特定数字、文本、日期或布尔值匹配的文档。例如，要筛选 `http.request.method` 为 GET 的文档，请使用以下查询：

```yaml
http.request.method: GET
```

The field parameter is optional. If not provided, all fields are searched for the given value. For example, to search all fields for “Hello”, use the following:
field 参数是可选的。如果未提供，则搜索所有字段以获取给定值。例如，要在所有字段中搜索 “Hello” ，请使用以下命令：

```yaml
Hello
```

When querying keyword, numeric, date, or boolean fields, the value must be an exact match, including punctuation and case. However, when querying text fields, Elasticsearch analyzes the value provided according to the [field’s mapping settings](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/analysis.html). For example, to search for documents where `http.request.body.content` (a `text` field) contains the text “null pointer”:
查询关键字、数字、日期或布尔字段时，该值必须完全匹配，包括标点符号和大小写。但是，在查询文本字段时，Elasticsearch 会根据[字段的映射设置](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/analysis.html)分析提供的值。例如，要搜索 `http.request.body.content`（`文本`字段）包含文本 “null pointer” 的文档：

```yaml
http.request.body.content: null pointer
```

Because this is a `text` field, the order of these search terms does not matter, and even documents containing “pointer null” are returned. To search `text` fields where the terms are in the order provided, surround the value in quotation marks, as follows:
因为这是一个`文本`字段，所以这些搜索词的顺序无关紧要，甚至会返回包含“pointer null”的文档。要搜索术语按提供的顺序排列`的文本`字段，请用引号将值括起来，如下所示：

```yaml
http.request.body.content: "null pointer"
```

Certain characters must be escaped by a backslash (unless surrounded by quotes). For example, to search for documents where `http.request.referrer` is https://example.com, use either of the following queries:
某些字符必须用反斜杠转义（除非用引号括起来）。例如，要搜索 https://example.com `http.request.referrer` 的文档，请使用以下任一查询：

```yaml
http.request.referrer: "https://example.com"
http.request.referrer: https\://example.com
```

You must escape following characters:
您必须转义以下字符：

```yaml
\():<>"*
```

## Filter for documents within a range 筛选范围内的文档

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

To search documents that contain terms within a provided range, use KQL’s range syntax. For example, to search for all documents for which `http.response.bytes` is less than 10000, use the following syntax:
若要搜索包含所提供范围内的术语的文档，请使用 KQL 的范围语法。例如，要搜索 `http.response.bytes` 小于 10000 的所有文档，请使用以下语法：

```yaml
http.response.bytes < 10000
```

To search for an inclusive range, combine multiple range queries. For example, to search for documents where `http.response.bytes` is greater than 10000 but less than or equal to 20000, use the following syntax:
要搜索非独占范围，请组合多个范围查询。例如，要搜索 `http.response.bytes` 大于 10000 但小于或等于 20000 的文档，请使用以下语法：

```yaml
http.response.bytes > 10000 and http.response.bytes <= 20000
```

You can also use range syntax for string values, IP addresses, and timestamps. For example, to search for documents earlier than two weeks ago, use the following syntax:
您还可以对字符串值、IP 地址和时间戳使用范围语法。例如，要搜索两周前之前的文档，请使用以下语法：

```yaml
@timestamp < now-2w
```

For more examples on acceptable date formats, refer to [Date Math](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/common-options.html#date-math).
有关可接受日期格式的更多示例，请参阅 [Date Math](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/common-options.html#date-math)。

## Filter for documents using wildcards 使用通配符筛选文档

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

To search for documents matching a pattern, use the wildcard syntax. For example, to find documents where `http.response.status_code` begins with a 4, use the following syntax:
要搜索与模式匹配的文档，请使用通配符语法。例如，要查找 `http.response.status_code` 以 4 开头的文档，请使用以下语法：

```yaml
http.response.status_code: 4*
```

By default, leading wildcards are not allowed for performance reasons. You can modify this with the [`query:allowLeadingWildcards`](https://www.elastic.co/guide/en/kibana/current/advanced-options.html#query-allowleadingwildcards) advanced setting.
默认情况下，出于性能原因，不允许使用前导通配符。您可以使用 [`query：allowLeadingWildcards`](https://www.elastic.co/guide/en/kibana/current/advanced-options.html#query-allowleadingwildcards) 高级设置对其进行修改。

Only `*` is currently supported. This matches zero or more characters.
目前仅支持 `*`。这将匹配零个或多个字符。

## Negating a query 否定查询

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

To negate or exclude a set of documents, use the `not` keyword (not case-sensitive). For example, to filter documents where the `http.request.method` is **not** GET, use the following query:
要否定或排除一组文档，请使用 `not` 关键字（不区分大小写）。例如，要筛选 `http.request.method` **不是** GET 的文档，请使用以下查询：

```yaml
NOT http.request.method: GET
```

## Combining multiple queries 组合多个查询

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

To combine multiple queries, use the `and`/`or` keywords (not case-sensitive). For example, to find documents where the `http.request.method` is GET **or** the `http.response.status_code` is 400, use the following query:
要组合多个查询，请使用 `and`/`or` 关键字（不区分大小写）。例如，要查找 `http.request.method` 为 GET **或** `http.response.status_code` 为 400 的文档，请使用以下查询：

```yaml
http.request.method: GET OR http.response.status_code: 400
```

Similarly, to find documents where the `http.request.method` is GET **and** the `http.response.status_code` is 400, use this query:
同样，要查找 `http.request.method` 为 GET **且** `http.response.status_code` 为 400 的文档，请使用以下查询：

```yaml
http.request.method: GET AND http.response.status_code: 400
```

To specify precedence when combining multiple queries, use parentheses. For example, to find documents where the `http.request.method` is GET **and** the `http.response.status_code` is 200, **or** the `http.request.method` is POST **and** `http.response.status_code` is 400, use the following:
要在组合多个查询时指定优先级，请使用括号。例如，要查找 `http.request.method` 为 GET **且** `http.response.status_code`为 200，**或者** `http.request.method` 为 POST **且**`http.response.status_code` 为 400 的文档，请使用以下命令：

```yaml
(http.request.method: GET AND http.response.status_code: 200) OR
(http.request.method: POST AND http.response.status_code: 400)
```

You can also use parentheses for shorthand syntax when querying multiple values for the same field. For example, to find documents where the `http.request.method` is GET, POST, **or** DELETE, use the following:
在查询同一字段的多个值时，您还可以使用括号表示速记语法。例如，要查找 `http.request.method` 为 GET、POST **或** DELETE 的文档，请使用以下命令：

```yaml
http.request.method: (GET OR POST OR DELETE)
```

## Matching multiple fields 匹配多个字段

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

Wildcards can also be used to query multiple fields. For example, to search for documents where any sub-field of `datastream` contains “logs”, use the following:
通配符还可用于查询多个字段。例如，要搜索 `datastream` 的任何子字段都包含 “logs” 的文档，请使用以下内容：

```yaml
datastream.*: logs
```

When using wildcards to query multiple fields, errors might occur if the fields are of different types. For example, if `datastream.*` matches both numeric and string fields, the above query will result in an error because numeric fields cannot be queried for string values.
使用通配符查询多个字段时，如果字段类型不同，则可能会发生错误。例如，如果 `datastream.*` 同时匹配数字和字符串字段，则上述查询将导致错误，因为无法在数字字段中查询字符串值。

## Querying nested fields 查询嵌套字段

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/kuery.asciidoc)

Querying [nested fields](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/nested.html) requires a special syntax. Consider the following document, where `user` is a nested field:
查询[嵌套字段](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/nested.html)需要特殊的语法。请考虑以下文档，其中 `user` 是一个嵌套字段：

```yaml
{
  "user" : [
    {
      "first" : "John",
      "last" :  "Smith"
    },
    {
      "first" : "Alice",
      "last" :  "White"
    }
  ]
}
```

To find documents where a single value inside the `user` array contains a first name of “Alice” and last name of “White”, use the following:
要查找 `user` 数组中的单个值包含名字 “Alice” 和姓氏 “White” 的文档，请使用以下命令：

```yaml
user:{ first: "Alice" and last: "White" }
```

Because nested fields can be inside other nested fields, you must specify the full path of the nested field you want to query. For example, consider the following document where `user` and `names` are both nested fields:
由于嵌套字段可以位于其他嵌套字段内，因此您必须指定要查询的嵌套字段的完整路径。例如，请考虑以下文档，其中 `user` 和 `names` 都是嵌套字段：

```yaml
{
  "user": [
    {
      "names": [
        {
          "first": "John",
          "last": "Smith"
        },
        {
          "first": "Alice",
          "last": "White"
        }
      ]
    }
  ]
}
```

To find documents where a single value inside the `user.names` array contains a first name of “Alice” **and** last name of “White”, use the following:
要查找 `user.names` 数组中的单个值包含名字 “Alice” **和**姓氏 “White” 的文档，请使用以下命令：

```yaml
user.names:{ first: "Alice" and last: "White" }
```