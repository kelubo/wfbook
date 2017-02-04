# .git 目录

.git 包含了所有 git 正常工作所需要的信息。

    ├── HEAD
    ├── branches
    ├── config
    ├── description
    ├── hooks
    │ ├── pre-commit.sample
    │ ├── pre-push.sample
    │ └── ...
    ├── info
    │ └── exclude
    ├── objects
    │ ├── info
    │ └── pack
    └── refs
    ├── heads
    └── tags

1. config  
    包含仓库的设置信息。每次在控制台使用“git config…”指令时，修改的就是这里。
2. description  
    gitweb(可以说是 github 的前身)用来显示仓库的描述。
3. hooks  
    可以在 git 每一个有实质意义的阶段让它们自动运行。
4. info — exclude  
    可以把不想让 git 处理的文件放到 .gitignore 文件里。那么，exclude 文件也有同样的作用，不同的地方是它不会被共享，比如当你不想跟踪你的自定义的 IDE 相关的配置文件时，即使通常情况下 .gitignore 就足够了。

commit 的真相

每一次创建一个文件并跟踪它，git 会对其进行压缩然后以 git 自己的数据结构形式来存储。这个压缩的对象会有一个唯一的名字，即一个哈希值，这个值存放在 object 目录下。

在探索 object 目录前，我们先要问自己 commit 到底是何方神圣。commit 大致可以视为你工作目录的快照，但是它又不仅仅只是一种快照。

实际上，当你提交的时候，为创建你工作目录的快照 git 只做了两件事：

    如果这个文件没有改变，git 仅仅只把压缩文件的名字（就是哈希值）放入快照。
    如果文件发生了变化，git 会压缩它，然后把压缩后的文件存入 object 目录。最后再把压缩文件的名字（哈希值）放入快照。

这里只是简单介绍，整个过程有一点复杂，以后的博客里会作说明的。

一旦快照创建好，其本身也会被压缩并且以一个哈希值命名。那么所有的压缩对象都放在哪里呢？答案是object 目录。

    ├── 4c
    │ └── f44f1e3fe4fb7f8aa42138c324f63f5ac85828 // hash
    ├── 86
    │ └── 550c31847e518e1927f95991c949fc14efc711 // hash
    ├── e6
    │ └── 9de29bb2d1d6434b8b29ae775ad8c2e48c5391 // hash
    ├── info // let's ignore that
    └── pack // let's ignore that too

这就是我创建一个空文件 file_1.txt 并提交后 object 目录看起来的样子。请注意如果你的文件的哈希值是“89faaee…”，git 会把这个文件存在 “89” 目录下然后命名这个文件为 “faaee…”。

你会看到3个哈希。一个对应 file_1.txt ，另一个对应在提交时所创建的快照。那么第三个是什么呢？其实是因为 commit 本身也是一个对象并且也被压缩存放在 object 目录下。

现在，你需要记住的是一个 commit 包含四个部分：

    工作目录快照的哈希
    提交的说明信息
    提交者的信息
    父提交的哈希值

如果我们解压缩一个提交，你自己可以看看到底是什么：

    // by looking at the history you can easily find your commit hash
    // you also don't have to paste the whole hash, only enough    
    // characters to make the hash unique
    git cat-file -p 4cf44f1e3fe4fb7f8aa42138c324f63f5ac85828

这是我看到的

    tree 86550c31847e518e1927f95991c949fc14efc711
    author Pierre De Wulf &amp;amp;lt;test@gmail.com&amp;amp;gt; 1455775173 -0500
    committer Pierre De Wulf &amp;amp;lt;test@gmail.com&amp;amp;gt; 1455775173 -0500
    commit A

如你所见我们得到了所期望看到的的：快照的哈希，作者，提交信息。这里有两样东西很重要：

    正如预料的一样，快照的哈希 “86550…” 也是一个对象并且能在object目录下找到。
    因为这是我的第一个提交，所以没有父提交。

那我的快照里面到底是些什么呢？

    git cat-file -p 86550c31847e518e1927f95991c949fc14efc711
    100644 blob e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 file_1.txt

到这里我们看到的最后一个对象是我们先前提到的唯一会存在于快照中的对象。它是一个 blob（二进制文件），这里就不作深究了。
分支，标签，HEAD 都是一家人

那么现在你知道 git 的每一个对象都有一个正确的哈希值。现在我们来看看 HEAD 吧！那么，在 HEAD 里又有什么呢？

    cat HEAD
    ref: refs/heads/master

这看起来 HEAD 不是一个hash，倒是容易理解，因为 HEAD 可以看作一个你目前所在分支的指针。如果我们看看 refs/heads/master，就会发现这些：

    cat refs/heads/master
    4cf44f1e3fe4fb7f8aa42138c324f63f5ac85828

是不是很熟悉？是的，这和我们第一个提交的哈希完全一样。由此表明分支和标签就是一个提交的指针。明白这一点你就可以删除所有你想删除的分支和标签，而他们指向的提交依然在那里。只是有点难以被访问到。如果你想对这部分了解更多，请参考git book。
尾声

到目前为止你应该了解到， git 所做的事就是当你提交的时候“压缩”当前的工作目录，同时将其和其他一些信息一并存入 objects 目录。但是如果你足够了解 git 的话，你就能完全控制提交时哪些文件应该放进去而哪些不应该放。

我的意思是，一个提交并非真正意义上是一个你当前工作目录的快照，而是一个你想提交的文件的快照。在提交之前 git 把你想提交的文件放在哪里？ git 把他们放在 index 文件里。我们现在不会去深入探究 index，同时如果你确实好奇你可以参考这里。
