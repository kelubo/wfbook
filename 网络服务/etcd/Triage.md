# Issue triage guidelines 问题会审准则



## Purpose 目的

Speed up issue management.
加快问题管理。

The `etcd` issues are listed at https://github.com/etcd-io/etcd/issues and are identified with labels. For example, an issue that is identified as a bug will eventually be set to label `area/bug `. New issues will start out without any labels, but typically `etcd` maintainers and active contributors add labels based on their findings. The detailed list of labels can be found at https://github.com/kubernetes/kubernetes/labels
这些问题 `etcd` 列在 https://github.com/etcd-io/etcd/issues，并用标签标识。例如，被标识为 bug 的问题最终将设置为 label `area/bug ` 。新问题开始时没有任何标签，但通常 `etcd` 维护者和活跃的贡献者会根据他们的发现添加标签。标签的详细列表可在以下位置找到 https://github.com/kubernetes/kubernetes/labels

Following are few predetermined searches on issues for convenience:
为方便起见，以下是对问题的一些预先确定的搜索：

- [Bugs 错误](https://github.com/etcd-io/etcd/labels/area%2Fbug)
- [Help Wanted 需要帮助](https://github.com/etcd-io/etcd/labels/Help Wanted)
- [Longest untriaged issues
  最长的未分类问题](https://github.com/etcd-io/etcd/issues?utf8=✓&q=is%3Aopen+sort%3Aupdated-asc+)
- [Issue Triage Meeting 问题分类会议](https://etcd.io/community/#community-meetings)

## Scope 范围

These guidelines serves as a primary document for triaging an incoming issues in `etcd`. Everyone is welcome to help manage issues and PRs but the work and  responsibilities discussed in this document are created with `etcd` maintainers and active contributors in mind.
这些准则可作为对 中 `etcd` 传入的问题进行分类的主要文档。欢迎每个人帮助管理问题和 PR，但本文档中讨论的工作和职责是在考虑维护者和积极贡献者的情况下 `etcd` 创建的。

## Validate if an issue is a bug 验证问题是否为 bug

Validate if the issue is indeed a bug. If not, add a comment with findings and  close trivial issue. For non-trivial issue, wait to hear back from issue reporter and see if there is any objection. If issue reporter does not  reply in 30 days, close the issue. If the problem can not be reproduced  or require more information, leave a comment for the issue reporter.
验证问题是否确实是 bug。如果没有，请添加带有调查结果的评论并关闭琐碎的问题。对于非平凡的问题，请等待问题报告者的回复，看看是否有任何异议。如果问题报告程序在 30 天内未回复，请关闭问题。如果问题无法重现或需要更多信息，请给问题报告者留下评论。

## Inactive issues 非活动问题

Issues that lack enough information from the issue reporter should be closed  if issue reporter do not provide information in 60 days.
如果问题报告者在 60 天内未提供信息，则应关闭问题报告者缺乏足够信息的问题。

## Duplicate issues 重复问题

If an issue is a duplicate, add a comment stating so along with a reference for the original issue and close it.
如果问题重复，请添加注释，说明问题以及原始问题的引用，然后将其关闭。

## Issues that don’t belong to etcd 不属于 etcd 的问题

Sometime issues are reported that actually belongs to other projects that `etcd` use. For example, `grpc` or `golang` issues. Such issues should be addressed by asking reporter to open  issues in appropriate other project. Close the issue unless a maintainer and issue reporter see a need to keep it open for tracking purpose.
有时报告的问题实际上属于 `etcd` 使用的其他项目。例如， `grpc` 或 `golang` 问题。此类问题应通过要求报告者在适当的其他项目中打开问题来解决。关闭问题，除非维护者和问题报告者认为有必要将其保持打开状态以进行跟踪。

## Verify important labels are in place 验证重要标签是否到位

Make sure that issue has label on areas it belongs to, proper assignees are  added and milestone is identified. If any of these labels are missing,  add one. If labels can not be assigned due to limited privilege or  correct label can not be decided, that’s fine, contact maintainers if  needed.
确保问题在其所属区域上有标签，添加适当的受让人并确定里程碑。如果缺少这些标签中的任何一个，请添加一个。如果由于权限有限而无法分配标签或无法确定正确的标签，那没关系，如果需要，请联系维护人员。

## Poke issue owner if needed 如果需要，戳问题所有者

If an issue owned by a developer has no PR created in 30 days, contact the issue owner and ask for a PR or to release ownership if needed.
如果开发者拥有的 Issue 在 30 天内没有创建 PR，请联系 Issue 所有者并请求 PR 或在需要时释放所有权。

# PR management 公关管理



## Purpose 目的

Speed up PR management.
加快公关管理。

The `etcd` PRs are listed at https://github.com/etcd-io/etcd/pulls A PR can have various labels, milestone, reviewer etc. The detailed list of labels can be found at https://github.com/kubernetes/kubernetes/labels
PR `etcd` 列在 https://github.com/etcd-io/etcd/pulls PR 可以有各种标签、里程碑、审阅者等。标签的详细列表可在以下位置找到 https://github.com/kubernetes/kubernetes/labels

Following are few example searches on PR for convenience:
为方便起见，以下是 PR 上的几个示例搜索：

- [Open PRS for milestone etcd-v3.4
  开启 vests 里程碑 etcd-v3.4](https://github.com/etcd-io/etcd/pulls?utf8=✓&q=is%3Apr+is%3Aopen+milestone%3Aetcd-v3.4)
- [PRs under investigation 正在调查的 PR](https://github.com/etcd-io/etcd/labels/Investigating)

## Scope 范围

These guidelines serves as a primary document for managing PRs in `etcd`. Everyone is welcome to help manage PRs but the work and responsibilities discussed in this document is created with `etcd` maintainers and active contributors in mind.
这些准则是管理 PR 的主要 `etcd` 文档。欢迎每个人帮助管理 PR，但本文档中讨论的工作和职责是在考虑维护者和活跃贡献者的情况下 `etcd` 创建的。

## Handle inactive PRs 处理非活动 PR

Poke PR owner if review comments are not addressed in 15 days. If PR owner  does not reply in 90 days, update the PR with a new commit if possible.  If not, inactive PR should be closed after 180 days.
如果 15 天内未解决评论评论，则戳 PR 所有者。如果 PR 所有者在 90 天内没有回复，请尽可能使用新提交更新 PR。否则，非活动 PR 应在 180 天后关闭。

## Poke reviewer if needed 如果需要，戳评论者

Reviewers are responsive in a timely fashion, but considering everyone is busy,  give them some time after requesting review if quick response is not  provided. If response is not provided in 10 days, feel free to contact  them via adding a comment in the PR or sending an email or message on  the Slack.
审稿人会及时做出响应，但考虑到每个人都很忙，如果没有提供快速回复，请在请求审稿后给他们一些时间。如果 10 天内没有提供回复，请随时通过在 PR 中添加评论或在 Slack 上发送电子邮件或消息与他们联系。

## Verify important labels are in place 验证重要标签是否到位

Make sure that appropriate reviewers are added to the PR. Also, make sure  that a milestone is identified. If any of these or other important  labels are missing, add them. If a correct label cannot be decided,  leave a comment for the maintainers to do so as needed.
确保将适当的审阅者添加到 PR 中。此外，请确保确定里程碑。如果缺少这些标签或其他重要标签中的任何一个，请添加它们。如果无法确定正确的标签，请发表评论，以便维护人员根据需要这样做。