# Grafana

[TOC]

## 概述

## 安装

###  dnf

```bash
dnf install grafana
```

YUM Repository

`/etc/yum.repos.d/grafana.repo`

```ini
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/6/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
```

## Package details

- Installs binary to `/usr/sbin/grafana-server`
- Copies init.d script to `/etc/init.d/grafana-server`
- Installs default file (environment vars) to `/etc/sysconfig/grafana-server`
- Copies configuration file to `/etc/grafana/grafana.ini`
- Installs systemd service (if systemd is available) name `grafana-server.service`
- The default configuration uses a log file at `/var/log/grafana/grafana.log`
- The default configuration specifies an sqlite3 database at `/var/lib/grafana/grafana.db`

## 启动服务

```bash
systemctl start grafana-server
systemctl enable grafana-server
```

，Grafana 是一个开源的可视化平台，并且提供了对 Prometheus 的完整支持。

```bash
docker run -d -p 3000:3000 grafana/grafana
```

访问 http://localhost:3000 就可以进入到 Grafana 的界面中，默认情况下使用账户 admin/admin 进行登录。在 Grafana 首页中显示默认的使用向导，包括：安装、添加数据源、创建 Dashboard 、邀请成员、以及安装应用和插件等主要流程:

![Grafana向导](../Image/g/get_start_with_grafana2.png)

## Environment file

The systemd service file and init.d script both use the file located at `/etc/sysconfig/grafana-server` for environment variables used when starting the back-end. Here you can override log directory, data directory and other variables.

### Logging

By default Grafana will log to `/var/log/grafana`

### Database

The default configuration specifies a sqlite3 database located at `/var/lib/grafana/grafana.db`. Please backup this database before upgrades. You can also use MySQL or Postgres as the Grafana database, as detailed on [the configuration page](http://docs.grafana.org/installation/configuration/#database).

## Configuration

The configuration file is located at `/etc/grafana/grafana.ini`. Go the [Configuration](http://docs.grafana.org/installation/configuration/) page for details on all those options.

### Adding data sources

- [Graphite](http://docs.grafana.org/features/datasources/graphite/)
- [InfluxDB](http://docs.grafana.org/features/datasources/influxdb/)
- [OpenTSDB](http://docs.grafana.org/features/datasources/opentsdb/)
- [Prometheus](http://docs.grafana.org/features/datasources/prometheus/)

### Server side image rendering

Server side image (png) rendering is a feature that is optional but very useful when sharing visualizations, for example in alert notifications.

If the image is missing text make sure you have font packages installed.

```
yum install fontconfig
yum install freetype*
yum install urw-fonts

```

## Installing from binary tar file

Download [the latest `.tar.gz` file](https://grafana.com/get) and extract it. This will extract into a folder named after the version you downloaded. This folder contains all files required to run Grafana. There are no init scripts or install scripts in this package.

To configure Grafana add a configuration file named `custom.ini` to the `conf` folder and override any of the settings defined in `conf/defaults.ini`.

Start Grafana by executing `./bin/grafana-server web`. The `grafana-server` binary needs the working directory to be the root install directory (where the binary and the `public` folder is located).