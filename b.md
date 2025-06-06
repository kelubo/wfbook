对于快速增长的公司，如 Google 和 Facebook，其对现有的开源项目提供的领导力仍然不足以满足业务的膨胀。面对激烈的增长和建立超大规模系统所带来的挑战，许多大型企业开始构建仅供内部使用的高度定制的软件栈。除非他们能说服别人在一些基础设施项目上达成合作。因此，虽然他们保持在诸如 Linux 内核，Apache 和其他现有项目领域的投资，他们也开始推出自己的大型项目。Facebook 发布了 Cassandra，Twitter 创造了 Mesos，并且甚至谷歌也创建了 Kubernetes 项目。这些项目已成为行业创新的主要平台，证实了该举措是相关公司引人注目的成功。（请注意，Facebook 在它需要创造一个新软件项目来解决更大规模的问题之后，已经在内部停止使用 Cassandra 了，但是，这时 Cassandra 已经变得流行，而 DataStax 公司接过了开发任务）。所有这些项目已经促使了开发商、相关的项目、以及最终用户构成的整个生态加速增长和发展。

没有与公司战略举措取得一致的开源项目部门不可能成功的。不这样做的话，这些公司依然会试图单独地解决这些问题，而且更慢。不仅拥有这些项目可以帮助内部解决业务问题，它们也帮助这些公司逐渐成为行业巨头。当然，谷歌成为行业巨头好多年了，但是 Kubernetes 的发展确保了软件的质量，并且在容器技术未来的发展方向上有着直接的话语权，并且远超之前就有的话语权。这些公司目前还是闻名于他们超大规模的基础设施和硅谷的中坚份子。鲜为人知，但是更为重要的是它们与技术生产人员的亲密度。开源项目部门凭借技术建议和与有影响力的开发者的关系，再加上在社区治理和人员管理方面深厚的专业知识来引领这些工作，并最大限度地发挥其影响力，
市场营销能力

与技术的影响齐头并进的是每个公司谈论他们在开源方面的努力。通过传播这些与项目和社区有关的消息，一个开源项目部门能够通过有针对性的营销活动来提供最大的影响。营销在开放源码领域一直是一个肮脏的词汇，因为每个人都有一个由企业营销造成的糟糕的经历。在开源社区中，营销呈现出一种与传统方法截然不同的形式，它会更注重于我们的社区已经在战略方向上做了什么。因此，一个开源项目部门不可能去宣传一些根本还没有发布任何代码的项目，但是他们会讨论他们创造什么软件和参与了其他什么举措。基本上，不会有“雾件（vaporware）”。

想想谷歌的开源项目部门作出的第一份工作。他们不只是简单的贡献代码给 Linux 内核或其他项目，他们更多的是谈论它，并经常在开源会议主题演讲。他们不仅仅是把钱给写开源代码的代码的学生，他们还创建了一个全球计划——“Google Summer of Code”，现在已经成为一种开源发展的文化试金石。这些市场营销的作用在 Kubernetes 开发完成之前就奠定了谷歌在开源世界巨头的地位。最终使得，谷歌在创建 GPLv3 授权协议期间拥有重要影响力，并且在科技活动中公司的发言人和开源项目部门的代表人成为了主要人物。开源项目部门是协调这些工作的最好的实体，并可以为母公司提供真正的价值。
改善内部流程

改善内部流程听起来不像一个大好处，但克服混乱的内部流程对于每一个开源项目部门都是一个挑战，不论是对软件供应商还是公司内的部门。而软件供应商必须确保他们的流程不与他们发布的产品重叠（例如，不小心开源了他们的商业售卖软件），用户更关心的是侵犯了知识产权（IP）法：专利、版权和商标。没有人想只是因为释放软件而被起诉。没有一个活跃的开源项目部门去管理和协调这些许可和其他法律问题的话，大公司在开源流程和管理上会面临着巨大的困难。为什么这个很重要呢？如果不同的团队释放的软件是在不兼容的许可证下，那么这不仅是一个坑爹的尴尬，它还将对实现最基本的目标改良协作产生巨大的障碍。

考虑到还有许多这样的公司仍在飞快的增长，如果无法建立基本流程规则的话，将可以预见到它们将会遇到阻力。我见过一个罗列着批准、未经批准的许可证的巨大的电子表格，以及指导如何（或如何不）创建开源社区而遵守法律限制。关键是当开发者需要做出决定时要有一个可以依据的东西，并且每次当开发人员想要为一个开源社区贡献代码时，可以不产生大量的法律开销，和效率低下的知识产权检查。

有一个活跃的开放源码项目部门，负责维护许可规则和源的贡献，以及建立培训项目工程师，有助于避免潜在的法律缺陷和昂贵的诉讼。毕竟，良好的开源项目合作可以减少由于某人没有看许可证而导致公司赔钱这样的事件。好消息是，公司已经可以较少的担心关于专有的知识产权与软件供应商冲突的事。坏消息是，它们的法律问题不够复杂，尤其是当他们需要直接面对软件供应商的阻力时。

你的组织是如何受益于拥有一个开源项目部门的？可以在评论中与我们分享。

本文作者 John Mark Walker 是 Dell EMC 的产品管理总监，负责管理 ViPR 控制器产品及 CoprHD 开源社区。他领导过包括 ManageIQ 在内的许多开源社区。



Hill：我要求每一位员工制定一个技术性的和非技术性的训练目标。这作为他们绩效评估的一部分。他们的技术性目标需要与他们的工作职能相符，非技术岗目标则随意，比如着重发展一项软技能，或是学一些专业领域之外的东西。我每年对职员进行一次评估，看看差距和不足之处，以使团队保持全面发展。

TEP：你的训练计划能够在多大程度上减轻招聘工作量, 保持职员的稳定性？

Hill：使我们的职员保持学习新技术的兴趣，可以让他们不断提高技能。让职员知道我们重视他们并且让他们在擅长的领域成长和发展，以此激励他们。

TEP：你们发现哪些培训是最有效的？

HILL：我们使用几种不同的培训方法，认为效果很好。对新的或特殊的项目，我们会由供应商提供培训课程，作为项目的一部分。要是这个方法不能实现，我们将进行脱产培训。我们也会购买一些在线的培训课程。我也鼓励职员每年参加至少一次会议，以了解行业的动向。

TEP：哪些技能需求，更适合雇佣新人而不是培训现有员工？

Hill：这和项目有关。最近有一个项目，需要使用 OpenStack，而我们根本没有这方面的专家。所以我们与一家从事这一领域的咨询公司合作。我们利用他们的专业人员运行该项目，并现场培训我们的内部团队成员。让内部员工学习他们需要的技能，同时还要完成他们的日常工作，是一项艰巨的任务。

顾问帮助我们确定我们需要的员工人数。这样我们就可以对员工进行评估，看是否存在缺口。如果存在人员上的缺口，我们还需要额外的培训或是员工招聘。我们也确实雇佣了一些合同工。另一个选择是对一些全职员工进行为期六至八周的培训，但我们的项目模式不容许这么做。

TEP：最近雇佣的员工，他们的那些技能特别能够吸引到你？

Hill：在最近的招聘中，我更看重软技能。除了扎实的技术能力外，他们需要能够在团队中进行有效的沟通和工作，要有说服他人，谈判和解决冲突的能力。

IT 人常常独来独往，不擅社交。然而如今IT 与整个组织结合越来越紧密，为其他业务部门提供有用的更新和状态报告的能力至关重要，可展示 IT 部门存在的重要性。
