# Long Term Support

- [List of LTS releases ](https://prometheus.io/docs/introduction/release-cycle/#list-of-lts-releases)
- [Limitations of LTS support ](https://prometheus.io/docs/introduction/release-cycle/#limitations-of-lts-support)

Prometheus LTS are selected releases of Prometheus that receive bugfixes for an extended period of time.

Every 6 weeks, a new Prometheus minor release cycle begins. After those 6 weeks, minor releases generally no longer receive bugfixes. If a user is impacted by a bug in a minor release, they often need to upgrade to the latest Prometheus release.

Upgrading Prometheus should be straightforward thanks to our [API stability guarantees](https://prometheus.io/docs/prometheus/latest/stability/). However, there is a risk that new features and enhancements could also bring regressions, requiring another upgrade.

Prometheus LTS only receive bug, security, and documentation fixes, but over a time window of one year. The build toolchain will also be kept up-to-date. This allows companies that rely on Prometheus to limit the upgrade risks while still having a Prometheus server maintained by the community.

## List of LTS releases

| Release         | Date       | End of support |
| --------------- | ---------- | -------------- |
| Prometheus 2.37 | 2022-07-14 | 2023-07-31     |

## Limitations of LTS support

Some features are excluded from LTS support:

- Things listed as unstable in our [API stability guarantees](https://prometheus.io/docs/prometheus/latest/stability/).
- [Experimental features](https://prometheus.io/docs/prometheus/latest/feature_flags/).
- OpenBSD support.