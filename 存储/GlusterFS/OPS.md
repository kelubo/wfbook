# Overview

Over the years the infrastructure and services consumed by the Gluster.org community have grown organically. There have been instances of design and planning but the growth has mostly been ad-hoc and need-based.

Central to the plan of revitalizing the Gluster.org community is the ability to provide well-maintained infrastructure services with predictable uptimes and resilience. We're migrating the existing services into the Community Cage. The implied objective is that the transition would open up ways and means of the formation of a loose coalition among Infrastructure Administrators who provide expertise and guidance to the community projects within the OSAS team.

A small group of Gluster.org community members was asked to assess the current utilization and propose a planned growth. The ad-hoc nature of the existing infrastructure impedes the development of a proposal based on standardized methods of extrapolation. A part of the projection is based on a combination of patterns and heuristics - problems that have been observed and how mitigation strategies have enabled the community to continue to consume the services available.

The guiding principle for the assessment has been the need to migrate services to "Software-as-a-Service" models and providers wherever applicable and deemed fit. To illustrate this specific directive - the documentation/docs aspect of Gluster.org has been continuously migrating artifacts to readthedocs.org while focusing on simple integration with the website. The website itself has been put within the Gluster.org Github.com account to enable ease of maintenance and sustainability.

For more details look at the full [Tools List](https://docs.gluster.org/en/latest/Ops-Guide/Tools/).

# Tools

## Tools We Use

| Service/Tool         | Purpose                                | Hosted At       |
| -------------------- | -------------------------------------- | --------------- |
| Github               | Code Review                            | Github          |
| Jenkins              | CI, build-verification-test            | Temporary Racks |
| Backups              | Website, Gerrit and Jenkins backup     | Rackspace       |
| Docs                 | Documentation content                  | mkdocs.org      |
| download.gluster.org | Official download site of the binaries | Rackspace       |
| Mailman              | Lists mailman                          | Rackspace       |
| www.gluster.org      | Web asset                              | Rackspace       |

## Notes

- download.gluster.org: Resiliency is important for availability and metrics.  Since it's official download, access need to restricted as much as possible.  Few developers building the community packages have access. If anyone requires  access can raise an issue at [gluster/project-infrastructure](https://github.com/gluster/project-infrastructure/issues/new)  with valid reason
- Mailman: Should be migrated to a separate host. Should be made more redundant  (ie, more than 1 MX).
- www.gluster.org: Framework, Artifacts now exist under gluster.github.com. Has  various legacy installation of software (mediawiki, etc ), being cleaned as  we find them.