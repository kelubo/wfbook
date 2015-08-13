---
title: Installation
---

This page provides directions on downloading and starting InfluxDB Version 0.9.2.

## Requirements
Installation of the pre-built InfluxDB package requires root privileges on the host machine.

### Networking
By default InfluxDB will use TCP ports `8083` and `8086` so these ports should be available on your system. Once installation is complete you can change those ports and other options in the configuration file, which is located by default in `/etc/opt/influxdb`.

## Ubuntu & Debian
Debian users can install 0.9.2 by downloading the package and installing it like this:

```bash
# 64-bit system install instructions
wget http://influxdb.s3.amazonaws.com/influxdb_0.9.2_amd64.deb
sudo dpkg -i influxdb_0.9.2_amd64.deb
```

Then start the daemon by running:

```sh
sudo /etc/init.d/influxdb start
```

## RedHat & CentOS
RedHat and CentOS users can install by downloading and installing the rpm like this:

```bash
# 64-bit system install instructions
wget http://influxdb.s3.amazonaws.com/influxdb-0.9.2-1.x86_64.rpm
sudo yum localinstall influxdb-0.9.2-1.x86_64.rpm
```

Then start the daemon by running:

```sh
sudo /etc/init.d/influxdb start
```

## OS X

Users of OS X 10.8 and higher can install using the [Homebrew](http://brew.sh/) package manager.

```sh
brew update
brew install influxdb
```

<a href="getting_started.html"><font size="6"><b>⇒ Now get started!</b></font></a>


## Hosted

For users who don't want to install any software and are ready to use InfluxDB, you may want to check out our [managed hosted InfluxDB offering](http://customers.influxdb.com). 

## Generate a configuration file

All InfluxDB packages ship with an example configuration file. In addition, a valid configuration file can be displayed at any time using the command `influxd config`. Redirect the output to a file to save a clean generated configuration file.

## Development Versions

Nightly packages are available and can be found on the [downloads page](/download/index.html)
