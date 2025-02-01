# Ceph版本

[TOC]

## Understanding the release cycle[](https://docs.ceph.com/en/latest/releases/general/#understanding-the-release-cycle)

Starting with the Nautilus release (14.2.0), there is a new stable release cycle every year, targeting the month of March. Each stable release series will receive a name (e.g., ‘Mimic’) and a major release number (e.g., 13 for Mimic because ‘M’ is the 13th letter of the alphabet).

Releases are named after a species of cephalopod (usually the common name, since the latin names are harder to remember or pronounce).

Version numbers have three components, *x.y.z*.  *x* identifies the release cycle (e.g., 13 for Mimic).  *y* identifies the release type:

- x.0.z - development versions
- x.1.z - release candidates (for test clusters, brave users)
- x.2.z - stable/bugfix releases (for users)

### Release candidates (x.1.z)[](https://docs.ceph.com/en/latest/releases/general/#release-candidates-x-1-z)

There is a feature freeze roughly two months prior to the planned initial stable release, after which focus shifts to stabilization and bug fixes only.

- Release candidate release every 1-2 weeks
- Intended for final testing and validation of the upcoming stable release

### Stable releases (x.2.z)[](https://docs.ceph.com/en/latest/releases/general/#stable-releases-x-2-z)

Once the initial stable release is made (x.2.0), there are semi-regular bug-fix point releases with bug fixes and (occasionally) feature backports.  Bug fixes are accumulated and included in the next point release.

- Stable point release every 4 to 6 weeks
- Intended for production deployments
- Bug fix backports for 2 full release cycles (2 years).
- Online, rolling upgrade support and testing from the last two (2) stable release(s) (starting from Luminous).
- Online, rolling upgrade support and testing from prior stable point releases

For each stable release:

- [Integration and upgrade tests](https://github.com/ceph/ceph/tree/master/qa/suites/) are run on a regular basis and [their results](http://pulpito.ceph.com/) analyzed by Ceph developers.
- [Issues](http://tracker.ceph.com/projects/ceph/issues?query_id=27) fixed in the development branch (master) are scheduled to be backported.
- When an issue found in the stable release is [reported](http://tracker.ceph.com/projects/ceph/issues/new), it is triaged by Ceph developers.
- The [stable releases and backport team](http://tracker.ceph.com/projects/ceph-releases/wiki) publishes `point releases` including fixes that have been backported to the stable release.

## Lifetime of stable releases[](https://docs.ceph.com/en/latest/releases/general/#lifetime-of-stable-releases)

The lifetime of a stable release series is calculated to be approximately 24 months (i.e., two 12 month release cycles) after the month of the first release. For example, Mimic (13.2.z) will reach end of life (EOL) shortly after Octopus (15.2.0) is released. The lifetime of a release may vary because it depends on how quickly the stable releases are published.

Detailed information on all releases, past and present, can be found at [Ceph Releases (index)](https://docs.ceph.com/en/latest/releases/#ceph-releases-index)



| Ceph版本    | 版本号   | 最新版本号  | 发行日期    | End of life |
| ---------- | ------- | ---------- | ---------- | ----------- |
| Argonaut   | 0.48    |            | 2012-07-03 |             |
| Bobtail    | 0.56    |            | 2013-01-01 |             |
| Cuttlefish | 0.61    |            | 2013-05-07 |             |
| Dumpling   |         | 0.67.11    | 2013-08-01 | 2015-05-01  |
| Emperor    |         | 0.72.2     | 2013-11-01 | 2014-05-01  |
| Firefly    |         | 0.80.11    | 2014-05-01 | 2016-04-01  |
| Giant      |         | 0.87.2     | 2014-10-01 | 2015-04-01  |
| Hammer     |         | 0.94.10    | 2015-04-01 | 2017-08-01  |
| Infernalis |         | 9.2.1      | 2015-11-01 | 2016-04-01  |
| Jewel      |         | 10.2.11    | 2016-04-01 | 2018-07-01  |
| Kraken     |         | 11.2.1     | 2017-01-01 | 2017-08-01  |
| Luminous   |         | 12.2.13    | 2017-08-01 | 2020-03-01  |
| Mimic      |         | 13.2.10    | 2018-06-01 | 2020-07-22  |
| Nautilus   | 14.2.19 | 14.2.22    | 2019-03-19 | 2021-06-30  |
| Octopus    | 15.2.9  | 15.2.17    | 2020-03-23 | 2022-08-09  |
| Pacific    | 16.2.0  | 16.2.11    | 2021-03-31 | 2023-06-01  |
| Quincy     | 17.2.0  | 17.2.5     | 2022-04-19 | 2024-06-01  |

## Release timeline

| Date       | Quincy | Pacific| Octopus| Nautilus| Mimic  |Luminous |
| ---------- | ------ | ------ | ------ | ------- | ------ | ------- |
| 2023-01-26 |        | 16.2.11|        |         |        |         |
| 2022-10-19 | 17.2.5 |        |        |         |        |         |
| 2022-09-30 | 17.2.4 |        |        |         |        |         |
| 2022-07-29 | 17.2.3 |        |        |         |        |         |
| 2022-07-21 | 17.2.2 | 16.2.10|        |         |        |         |
| 2022-06-23 |        |        |        |         |        |         |
| 2022-05-19 |        | 16.2.9 |        |         |        |         |
| 2022-05-16 |        | 16.2.8 |        |         |        |         |
| 2022-04-19 | 17.2.0 |        |        |         |        |         |
| 2021-12-14 |        | 16.2.7 |        |         |        |         |
| 2021-09-16 |        | 16.2.6 |        |         |        |         |
| 2021-07-08 |        | 16.2.5 |        |         |        |         |
| 2021-05-13 |        | 16.2.4 |        |         |        |         |
| 2021-05-06 |        | 16.2.3 |        |         |        |         |
| 2021-05-05 |        | 16.2.2 |        |         |        |         |
| 2021-04-19 |        | 16.2.1 |        |         |        |         |
| 2021-03-31 |        | 16.2.0 | –      | –       | –      | –       |
| 2021-03-30 |        | –      | –      | 14.2.19 | –      | –       |
| 2021-03-15 |        | –      | –      | 14.2.18 | –      | –       |
| 2021-03-11 |        | –      | –      | 14.2.17 | –      | –       |
| 2021-02-23 |        | –      | 15.2.9 | –       | –      | –       |
| 2020-12-16 |        | –      | 15.2.8 | –       | –      | –       |
| 2020-12-16 |        | –      | –      | 14.2.16 | –      | –       |
| 2020-11-30 |        | –      | 15.2.7 | –       | –      | –       |
| 2020-11-23 |        | –      | –      | 14.2.15 | –      | –       |
| 2020-11-18 |        | –      | 15.2.6 | –       | –      | –       |
| 2020-11-18 |        | –      | –      | 14.2.14 | –      | –       |
| 2020-11-02 |        | –      | –      | 14.2.13 | –      | –       |
| 2020-09-21 |        | –      | –      | 14.2.12 | –      | –       |
| 2020-09-16 |        | –      | 15.2.5 | –       | –      | –       |
| 2020-08-11 |        | –      | –      | 14.2.11 | –      | –       |
| 2020-06-30 |        | –      | 15.2.4 | –       | –      | –       |
| 2020-06-26 |        | –      | –      | 14.2.10 | –      | –       |
| 2020-05-29 |        | –      | 15.2.3 | –       | –      | –       |
| 2020-05-18 |        | –      | 15.2.2 | –       | –      | –       |
| 2020-04-23 |        | –      | –      | –       | 13.2.10| –       |
| 2020-04-16 |        | –      | –      | –       | 13.2.9 | –       |
| 2020-04-15 |        | –      | –      | 14.2.9  | –      | –       |
| 2020-04-09 |        | –      | 15.2.1 | –       | –      | –       |
| 2020-03-23 |        | –      | 15.2.0 | –       | –      |  –      |
| 2020-03-03 |        | –      | –      | 14.2.8  | –      |  –      |
| 2020-01-31 |        | –      | –      | 14.2.7  | –      |  –      |
| 2020-01-31 |        | –      | –      | –       | –      | 12.2.13 |
| 2020-01-09 |        | –      | –      | 14.2.6  | –      |  –      |
| 2019-12-13 |        | –      | –      | –       | 13.2.8 |  –      |
| 2019-12-10 |        | –      | –      | 14.2.5  | –      |  –      |
| 2019-11-25 |        | –      | –      | –       | 13.2.7 |  –      |
| 2019-09-17 |        | –      | –      | 14.2.4  | –      |  –      |
| 2019-09-04 |        | –      | –      | 14.2.3  | –      | –       |
| 2019-07-17 |        | –      | –      | 14.2.2  | –      | –       |
| 2019-06-04 |        | –      | –      | –       | 13.2.6 | –       |
| 2019-04-29 |        | –      | –      | 14.2.1  | –      | –       |
| 2019-04-12 |        | –      | –      | –       | –      | 12.2.12 |
| 2019-03-19 |        | –      | –      | 14.2.0  | –      | –       |
| 2019-03-13 |        | –      | –      | –       | 13.2.5 | –       |
| 2019-01-31 |        | –      | –      | –       | –      | 12.2.11 |
| 2019-01-07 |        | –      | –      | –       | 13.2.4 | –       |
| 2019-01-07 |        | –      | –      | –       | 13.2.3 | –       |
| 2018-11-27 |        | –      | –      | –       | –      | 12.2.10 |
| 2018-11-01 |        | –      | –      | –       | –      | 12.2.9  |
| 2018-09-01 |        | –      | –      | –       | 13.2.2 | –       |
| 2018-09-01 |        | –      | –      | –       | –      | 12.2.8  |
| 2018-07-01 |        | –      | –      | –       | 13.2.1 | –       |
| 2018-07-01 |        | –      | –      | –       | –      | 12.2.7  |
| 2018-07-01 |        | –      | –      | –       | –      | 12.2.6  |
| 2018-06-01 |        | –      | –      | –       | 13.2.0 | –       |
| 2018-04-01 |        | –      | –      | –       | –      | 12.2.5  |
| 2018-02-01 |        | –      | –      | –       | –      | 12.2.4  |
| 2018-02-01 |        | –      | –      | –       | –      | 12.2.3  |
| 2017-12-01 |        | –      | –      | –       | –      | 12.2.2  |
| 2017-09-01 |        | –      | –      | –       | –      | 12.2.1  |
| 2017-08-01 |        | –      | –      | –       | –      | 12.2.0  |

| Date | Kraken | Jewel | Infernalis | Hammer | Giant | Firefly | Emperor | Dumpling | Cuttlefish | Bobtail | Argonaut |
| ---- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- |
| 2023-01-26 |    |   |   |    |   |     |         |         |         |         |         |
| 2022-10-19 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-09-30 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-07-29 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-07-21 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-06-23 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-05-19 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-05-16 |         |         |         |         |         |         |         |         |         |         |         |
| 2022-04-19 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-12-14 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-09-16 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-07-08 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-05-13 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-05-06 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-05-05 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-04-19 |         |         |         |         |         |         |         |         |         |         |         |
| 2021-03-31 |        |        |        |        |        |        |        |        |        |        |        |
| 2021-03-30 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2021-03-15 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2021-03-11 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2021-02-23 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-12-16 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-12-16 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-11-30 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-11-23 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-11-18 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-11-18 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-11-02 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-09-21 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-09-16 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-08-11 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-06-30 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-06-26 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-05-29 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-05-18 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-04-23 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-04-16 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-04-15 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-04-09 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-03-23 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-03-03 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-01-31 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2020-01-31 |  |  |  |  |  |  |  |  |  |  |  |
| 2020-01-09 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-12-13 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-12-10 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-11-25 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-09-17 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-09-04 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-07-17 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-06-04 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-04-29 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-04-12 |  |  |  |  |  |  |  |  |  |  |  |
| 2019-03-19 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-03-13 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-01-31 |  |  |  |  |  |  |  |  |  |  |  |
| 2019-01-07 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2019-01-07 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2018-11-27 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-11-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-09-01 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2018-09-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-07-01 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2018-07-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-07-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-06-01 |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |                                                             |
| 2018-04-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-02-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2018-02-01 |  |  |  |  |  |  |  |  |  |  |  |
| 2013-05-07 |  |  |  |  |  |  |  |  | 0.61 |  |  |
| 2013-01-01 |  |  |  |  |  |  |  |  |  | 0.56 |  |
| 2012-07-03 |  |  |  |  |  |  |  |  |  |  | 0.48 |