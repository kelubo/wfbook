# Puppet platform lifecycle

[TOC]

## Sections

The open source Puppet platform is made up of several        packages: `puppet-agent`, `puppetserver`, and, optionally, `puppetdb`.        Understanding what versions are maintained and which versions go together is important when        upgrading and troubleshooting.

## Puppet releases and lifecycle

Open source Puppet has two release tracks: 

- Update track: Puppet versions that are not                        associated with any PE version get updated                        minor (or "y") releases about once a month. Releases in this track include                        fixes and new features, but typically do not get patch (or "z") releases.                        Each update in this track supersedes the previous minor release.                        Documentation for the current release is available at [puppet.com/docs/puppet/latest](https://puppet.com/docs/puppet/latest). The latest [Release notes](https://puppet.com/docs/puppet/7/release_notes_osp.html) contain a history of all updates to this                        release track.
- Long-term releases: Puppet versions                        associated with Puppet Enterprise LTS (long-term                        support) releases get patch (or "z") releases about quarterly. Each release                        contains bug and security fixes from several developmental releases, but                        does not get new features. Versioned documentation for long-term releases is                        available at puppet.com/docs/puppet/<X.Y> (for example,                        puppet.com/docs/puppet/6.4). 

Important: To ensure that you have the most recent features, fixes, and                security patches, update your Puppet version whenever                there is a new version in your release track.

The following table lists the maintained Puppet, Puppet Server, and PuppetDB                versions, with links to their respective documentation. Developmental releases                ('latest') are superseded by new versions about once a month. Open source releases                that are associated with PE versions have projected                End of Life (EOL) dates. 

| Puppet version                                               | Puppet Server version                                        | PuppetDB version                                             | Associated PE version                                        | Projected EOL date                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------------- |
| [7.21.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet) | [7.9.3](https://puppet.com/docs/puppet/7/server/release_notes.html) | [7.12.0](https://puppet.com/docs/puppetdb/7/release_notes.html) |                                                              | Superseded by next developmental release. |
| [6.28.0](https://puppet.com/docs/puppet/6/release_notes_puppet.html) | [6.20.0](https://puppet.com/docs/puppet/6/server/release_notes.html) | [6.22](https://puppet.com/docs/puppetdb/6/release_notes.html) | [2019.8.x](https://puppet.com/docs/pe/2019.8/release_notes_pe.html#release_notes_pe) | July 2023                                 |

Note: To access docs for unmaintained Puppet versions,                visit our [Archived documentation](https://puppet.com/docs/puppet/7/archived_osp_docs.html) page. 

For information about Puppet's operating system                support, see the [platform support lifecycle](https://puppet.com/misc/platform-support-lifecycle) page.

##                 Puppet platform packages

The Puppet platform bundles the components needed for                a successful deployment. We distribute open source Puppet in the following packages: 

| Package            | Contents                                                     |
| ------------------ | ------------------------------------------------------------ |
| `puppet-agent`     | This package contains Puppet’s                                        main code and all of the dependencies needed to run it,                                        including Facter, Hiera, the PXP agent, root certificates,                                        and bundled versions of Ruby                                        and OpenSSL. After it’s installed, you have everything you                                        need to run the [                                             Puppet agent service                                         ](https://puppet.com/docs/puppet/7/services_agent_unix.html#services_agent_unix) and the [                                             `puppet apply`                                             command](https://puppet.com/docs/puppet/7/services_apply.html#services_apply). |
| `puppetserver`     | [                                         Puppet Server                                     ](https://puppet.com/docs/puppetserver/latest/) is a JVM-based application that, among other things,                                    runs instances of the primary Puppet server application and                                    serves catalogs to nodes running the agent service. It has its                                    own version number and might be compatible with more than one                                        Puppet version. This package                                    depends on `puppet-agent`. After                                    it’s installed, Puppet Server can serve                                    catalogs to nodes running the agent service. |
| `puppetdb`         | PuppetDB (optional) collects data                                    generated by Puppet. It enables                                    additional features such as [exported resources](https://puppet.com/docs/puppet/6.7/lang_exported.html), advanced                                    queries, and reports about your infrastructure. |
| `puppetdb-termini` | Plugins to connect your primary server to PuppetDB           |

The `puppetserver` component of the Puppet platform is                available only for Linux. The `puppet-agent` component is available independently for over 30                platforms and architectures, including Windows and                    macOS. 

Note: As of Puppet agent 5.5.4,                    MCollective was deprecated. It was removed in Puppet 6.0. If you use Puppet Enterprise, consider [                         Puppet orchestrator](https://puppet.com/docs/pe/latest/orchestrating_puppet_and_tasks.html). If you                    use open source Puppet, migrate MCollective                    agents and filters using tools such as [Bolt](https://puppet.com/docs/bolt/) and PuppetDB’s [Puppet Query                         Language](https://puppet.com/docs/puppetdb/).

##                 `puppet-agent` component version numbers

Each `puppet-agent` package contains several                components. This table shows the components shipped in this release track, and                contains links to available component release notes. Agent release notes are                included on the same page as Puppet release                notes.

Note:                     [Hiera 5](https://puppet.com/docs/puppet/7/hiera_intro.html#hiera_intro) is a backward-compatible evolution                    of Hiera, which is built into Puppet. To provide some backward-compatible                    features, it uses the classic Hiera 3 codebase.                    This means that Hiera is still shown as version                    3.x in the table above, even though this Puppet                    version uses Hiera 5.

| `puppet-agent` | Puppet                                                       | Facter                                                       | Hiera  | Resource API | Ruby  | OpenSSL |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------ | ------------ | ----- | ------- |
| 7.21.0         | [7.21.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-21-0) | [4.2.14](https://puppet.com/docs/puppet/7/release_notes_facter_4-2-14.html) | 3.11.0 | 1.8.16       | 2.7.7 | 1.1.1q  |
| 7.20.0         | [7.20.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-20-0) | [4.2.13](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-13) | 3.10.0 | 1.8.16       | 2.7.6 | 1.1.1q  |
| 7.19.0         | [7.19.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-19-0) | [4.2.12](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-12) | 3.10.0 | 1.8.14       | 2.7.6 | 1.1.1q  |
| 7.18.0         | [7.18.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-18-0) | [4.2.11](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-11) | 3.10.0 | 1.8.14       | 2.7.6 | 1.1.1q  |
| 7.17.0         | [7.17.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-17-0) | [4.2.10](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-10) | 3.9.0  | 1.8.14       | 2.7.6 | 1.1.1n  |
| 7.16.0         | [7.16.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-16-0) | [4.2.8](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-8) | 3.8.1  | 1.8.14       | 2.7.6 | 1.1.1n  |
| 7.15.0         | [7.15.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-15-0) | [4.2.8](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-8) | 3.8.1  | 1.8.14       | 2.7.5 | 1.1.1l  |
| 7.14.0         | [7.14.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-14-0) | [4.2.7](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-7) | 3.8.0  | 1.8.14       | 2.7.5 | 1.1.1l  |
| 7.13.1         | [7.13.1](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_x-7-13-1) | [4.2.6](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-6) | 3.8.0  | 1.8.14       | 2.7.3 | 1.1.1l  |
| 7.21.1         | [7.21.1](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-12-1) | [4.2.5](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-4) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1l  |
| 7.12.0         | [7.12.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#resolved_issues_puppet_7-12-0) | [4.2.5](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-4) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1l  |
| 7.11.0         | [7.11.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-11-0) | [4.2.4](https://puppet.com/docs/puppet/7/release_notes_facter.html#unique_863860599) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1l  |
| 7.10.0         | [7.10.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#resolved_issues_puppet_7-10-0) | [4.2.3](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-3) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1k  |
| 7.9.0          | [7.9.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-9-0) | [4.2.2](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-2) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1k  |
| 7.8.0          | [7.8.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-8-0) | [4.2.1](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-1) | 3.7.0  | 1.8.14       | 2.7.3 | 1.1.1k  |
| 7.7.0          | [7.7.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-7-0) | [4.2.0](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-2-0) | 3.7.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.6.1          | [7.6.1](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-5-0) | [4.1.1](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-1-0) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.5.0          | [7.5.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#unique_2131244170) | [4.0.52](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-0-50) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.4.1          | [7.4.1](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-4-1) | [4.0.51](https://puppet.com/docs/puppet/7/release_notes_facter.html#unique_856040609) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.4.0          | [7.4.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-4-0) | [4.0.50](https://puppet.com/docs/puppet/7/release_notes_facter.html#unique_1931817772) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.3.0          | [7.3.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-3-0) | [4.0.49](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-0-49) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.1.0          | [7.1.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-1-0) | [4.0.47](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-0-47) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1i  |
| 7.0.0          | [7.0.0](https://puppet.com/docs/puppet/7/release_notes_puppet.html#release_notes_puppet_7-0-0) | [4.0.46](https://puppet.com/docs/puppet/7/release_notes_facter.html#release_notes_facter_4-0-46) | 3.6.0  | 1.8.13       | 2.7.0 | 1.1.1g  |

## Primary server and agent compatibility

Use this table to verify that you're using a compatible version of the agent for          your PE or Puppet server. 

|       | Server                                                       |                                                              |                                                              |
| ----- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Agent | PE 2017.3 through 2018.1                                   Puppet 5.x | PE 2019.1 through 2019.8                                   Puppet 6.x | PE 2021.0 and later                                        Puppet 7.x |
| 5.x   | ✓                                                            | ✓                                                            |                                                              |
| 6.x   |                                                              | ✓                                                            | ✓                                                            |
| 7.x   |                                                              |                                                              | ✓                                                            |

Note:                     Puppet 5.x has reached end of life and is                    not actively developed or tested. We retain agent 5.x compatibility with                    later versions of the server only to enable upgrades. 