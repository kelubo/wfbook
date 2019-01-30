# Review Board

代码审查工具

## 依赖

1. Python 2.7
2. MySQL 5.6或者PostgreSQL
3. Apache + mod_wsgi

## 安装

### CentOS

1. epel
2. yum install ReviewBoard



## Installing Review Board

Ready to get started with Review Board? We’ve made it pretty easy, depending on your platform.

Installation will happen in two steps:

- Step 1: Install the Review Board packages for:
  - [Linux](https://www.reviewboard.org/docs/manual/2.5/admin/installation/linux/)
  - [macOS](https://www.reviewboard.org/docs/manual/2.5/admin/installation/osx/)
  - [Windows](https://www.reviewboard.org/docs/manual/2.5/admin/installation/windows/)
- [Step 2: Create your site directory](https://www.reviewboard.org/docs/manual/2.5/admin/installation/creating-sites/)

## Upgrading Review Board

When you’re ready to upgrade to a new version of Review Board, simply follow these steps:

- [Step 1: Upgrade the Review Board packages](https://www.reviewboard.org/docs/manual/2.5/admin/upgrading/upgrading-reviewboard/)
- [Step 2: Upgrade your site directory](https://www.reviewboard.org/docs/manual/2.5/admin/upgrading/upgrading-sites/)

## Optimizing Your Server

Once you have things running, you’ll want to make sure things are working at peak performance by following our guides.

- [General optimization tips](https://www.reviewboard.org/docs/manual/2.5/admin/optimization/general/)
- [Optimizing Memcached](https://www.reviewboard.org/docs/manual/2.5/admin/optimization/memcached/)
- [Optimizing MySQL](https://www.reviewboard.org/docs/manual/2.5/admin/optimization/mysql/)

## The Administration UI

The Administration UI provides configuration options, database management, news updates and system information. This area is available to all users with [staff status](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/users/#staff-status) and can be reached by clicking Admin in your account navigation menu in the top-right of any page.

The Administration UI is composed of four main areas:

- [Admin Dashboard](https://www.reviewboard.org/docs/manual/2.5/admin/admin-ui/dashboard/)
- [Settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/settings/)
- [Database](https://www.reviewboard.org/docs/manual/2.5/admin/admin-ui/database/)
- [Extensions](https://www.reviewboard.org/docs/manual/2.5/admin/extensions/)

## Configuring Review Board

After your site is set up, you may want to go through settings and set up your authentication backend (if using LDAP, Active Directory, etc.), your e-mail server, and enable logging, at a minimum. There are multiple settings pages available through the Administration UI:

- [General settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/general-settings/)
- [Authentication settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/authentication-settings/)
- [E-mail settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/email-settings/)
- [Diff viewer settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/diffviewer-settings/)
- [Logging settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/logging-settings/)
- [SSH settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/ssh-settings/)
- [File storage settings](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/file-storage-settings/)

Next, you’ll want to configure your repositories, review groups, and default reviewers:

- [Managing repositories](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/)

  | [Bazaar](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/bazaar/#repository-scm-bazaar) [ClearCase](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/clearcase/#repository-scm-clearcase) [CVS](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/cvs/#repository-scm-cvs) [Git](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/git/#repository-scm-git) | [Mercurial](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/mercurial/#repository-scm-mercurial) [Perforce](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/perforce/#repository-scm-perforce) [Subversion](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/subversion/#repository-scm-subversion) |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  |                                                              |                                                              |

  | [Assembla](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/assembla/#repository-hosting-assembla) [Beanstalk](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/beanstalk/#repository-hosting-beanstalk) [Bitbucket](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/bitbucket/#repository-hosting-bitbucket) [Codebase](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/codebasehq/#repository-hosting-codebasehq) [Fedora Hosted](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/fedorahosted/#repository-hosting-fedorahosted) [GitHub](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/github/#repository-hosting-github) | [GitHub Enterprise](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/github-enterprise/#repository-hosting-github-enterprise) [GitLab](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/gitlab/#repository-hosting-gitlab) [Gitorious](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/gitorious/#repository-hosting-gitorious) [SourceForge](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/sourceforge/#repository-hosting-sourceforge) [Unfuddle STACK](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/unfuddle/#repository-hosting-unfuddle) [VisualStudio.com](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/repositories/visualstudio/#repository-hosting-visualstudio) |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  |                                                              |                                                              |

- [Managing review groups](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/review-groups/)

- [Managing default reviewers](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/default-reviewers/)

You can also configure tighter access control and give special permissions to users:

- [Learn about access control](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/access-control/)
- [Manage users and permissions](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/users/)
- [Set up permission groups](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/permission-groups/)

That’s not all you can set up.

- [Configure WebHooks](https://www.reviewboard.org/docs/manual/2.5/admin/configuration/webhooks/), which can notify in-house or external web services when things happen on Review Board
- [Manage extensions](https://www.reviewboard.org/docs/manual/2.5/admin/extensions/), which can add new features to Review Board or add new integrations with other services

## Site Maintenance

Review Board ships with some command line management tools for working with Review Board site directories, search indexes, handle password resets, and more.

- [Using the rb-site tool](https://www.reviewboard.org/docs/manual/2.5/admin/sites/rb-site/)
- [Set up periodic search indexing](https://www.reviewboard.org/docs/manual/2.5/admin/sites/search-indexing/)
- [Advanced management command line tools](https://www.reviewboard.org/docs/manual/2.5/admin/sites/management-commands/)