# Awaken your home

Open source home automation that puts local control and privacy first.  Powered by a worldwide community of tinkerers and DIY enthusiasts.  Perfect to run on a Raspberry Pi or a local server.

唤醒你的家

将本地控制和隐私放在首位的开源家庭自动化。由世界各地的修补工和DIY爱好者组成的社区提供支持。非常适合在树莓派或本地服务器上运行。

# Installation

------

The first step is to install Home Assistant. We recommend a dedicated system to run Home Assistant. If you are unsure of what to choose, follow [the Raspberry Pi guide](https://www.home-assistant.io/installation/raspberrypi) to install **Home Assistant Operating System**.

Home Assistant offers four different installation methods. We recommend using one of the following two methods:

- **Home Assistant Operating System**: Minimal Operating System optimized to power Home Assistant. It comes with Supervisor to manage Home Assistant Core and Add-ons. Recommended installation method.
- **Home Assistant Container**: Standalone container-based installation of Home Assistant Core (e.g. Docker).

There are two alternative installation methods available for experienced users:

- **Home Assistant Supervised**: Manual installation of the Supervisor.
- **Home Assistant Core**: Manual installation using Python virtual environment.

The list below shows the installation method available based on the device and platform being used.

If you are using the [Home Assistant Blue](https://www.home-assistant.io/blue), the Home Assistant Operating System is already installed. [Continue to onboarding.](https://www.home-assistant.io/getting-started/onboarding)

##  Raspberry Pi

[    ](https://www.home-assistant.io/installation/raspberrypi)

[ **Raspberry Pi**  Home Assistant Operating System Home Assistant Container Home Assistant Core    ](https://www.home-assistant.io/installation/raspberrypi)[ ](https://www.home-assistant.io/installation/raspberrypi)

# Raspberry Pi

------

Please remember to ensure you’re using an [appropriate power supply](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) with your Raspberry Pi. Mobile chargers may not be suitable, since some are designed to only provide the full power with that manufacturer’s  handsets. USB ports on your computer also will not supply enough power  and must not be used.

##  Install Home Assistant Operating System

Follow this guide if you want to get started with Home Assistant easily or if you have little to no Linux experience.

###  Suggested Hardware

We will need a few things to get started with installing Home  Assistant. Links below lead to Amazon US. If you’re not in the US, you  should be able to find these items in web stores in your country.

- [Raspberry Pi 4](https://amzn.to/2S0Gcl1) (Raspberry Pi 3 is ok too, if you have one laying around). Raspberry Pi are currently hard to come by, use [RPilocator](https://rpilocator.com/?cat=PI4) to find official distributors with stock.
- [Power Supply for Raspberry Pi 4](https://amzn.to/2ReZ2Vq) or [Power Supply for Raspberry Pi 3](https://amzn.to/2R8yG7h)
- [Micro SD Card](https://amzn.to/2X0Z2di). Ideally get one that is [Application Class 2](https://www.sdcard.org/developers/overview/application/index.html) as they handle small I/O much more consistently than cards not  optimized to host applications. A 32 GB or bigger card is recommended.
- SD Card reader. This is already part of most laptops, but you can purchase a [standalone USB adapter](https://amzn.to/2WWxntY) if you don’t have one. The brand doesn’t matter, just pick the cheapest.
- [Ethernet cable](https://amzn.com/dp/B00N2VISLW). Required for installation. After installation, Home Assistant can work  with Wi-Fi, but an Ethernet connection is more reliable and highly  recommended.

###  Write the image to your boot media

1. Attach the Home Assistant boot media (SD card) to your computer
2. Download and start [Balena Etcher](https://www.balena.io/etcher). (You may need to run it with administrator privileges on Windows).
3. Select “Flash from URL” ![Screenshot of the Etcher software showing flash from URL selected.](https://www.home-assistant.io/images/installation/etcher1.png)
4. Get the URL for your Raspberry Pi:

Raspberry Pi 4

Raspberry Pi 3

```text
https://github.com/home-assistant/operating-system/releases/download/9.5/haos_rpi4-64-9.5.img.xz
```

Text



*Select and copy the URL or use the “copy” button that appear when you hover it.*

1. Paste the URL for your Raspberry Pi into Balena Etcher and click “OK” ![Screenshot of the Etcher software showing the URL bar with a URL pasted in.](https://www.home-assistant.io/images/installation/etcher2.png)
2. Balena Etcher will now download the image, when that is done click “Select target” ![Screenshot of the Etcher software showing the select target button highlighted.](https://www.home-assistant.io/images/installation/etcher3.png)
3. Select the SD card you want to use for your Raspberry Pi ![Screenshot of the Etcher software showing teh targets available.](https://www.home-assistant.io/images/installation/etcher4.png)
4. Click on “Flash!” to start writing the image ![Screenshot of the Etcher software showing the Flash button highlighted.](https://www.home-assistant.io/images/installation/etcher5.png)
5. When Balena Etcher is finished writing the image you will get this confirmation ![Screenshot of the Etcher software showing that the installation has completed.](https://www.home-assistant.io/images/installation/etcher6.png)

###  Start up your Raspberry Pi

1. Insert the boot media (SD card) you just created.
2. Attach an Ethernet cable for network.
3. Attach the power cable.
4. In the browser of your Desktop system, within a few minutes you will be able to reach your new Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123).

- If you are running an older Windows version or have a stricter  network configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your Raspberry Pi’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

These below instructions are for an installation of Home Assistant  Container running in your own container environment, which you manage  yourself. Any [OCI](https://opencontainers.org/) compatible runtime can be used, however this guide will focus on installing it with Docker.

**Prerequisites**

This guide assumes that you already have an operating system setup and a container runtime installed (like Docker).

If you are using Docker then you need to be on at least version 19.03.9, ideally an even higher version, and `libseccomp` 2.4.2 or newer.

###  Platform Installation

Installation with Docker is straightforward. Adjust the following command so that:

- `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration and run it.

- `MY_TIME_ZONE` is a [tz database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), like `TZ=America/Los_Angeles`.

  Install

  Update

  ```bash
  docker run -d \
    --name homeassistant \
    --privileged \
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE \
    -v /PATH_TO_YOUR_CONFIG:/config \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
  ```

  Bash



Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory. The arguments `-G dialout,gpio,i2c` adds the user to the `dialout`, `gpio` and the `i2c` group. The first is required for using Z-Wave and Zigbee controllers, while the second is required to communicate with GPIO.

```bash
sudo useradd -rm homeassistant -G dialout,gpio,i2c
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster.

*We get commissions for purchases made through links in this post.* 

## ODROID

[    ![img](https://www.home-assistant.io/images/installation/odroid.png)   **ODROID**  Home Assistant Operating System Home Assistant Container Home Assistant Core     ](https://www.home-assistant.io/installation/odroid)[ ](https://www.home-assistant.io/installation/odroid)

# ODROID

------

##  Install Home Assistant Operating System

Follow this guide if you want to get started with Home Assistant easily or if you have little to no Linux experience.

###  Suggested Hardware

We will need a few things to get started with installing Home  Assistant. Links below lead to Ameridroid. If you’re not in the US, you  should be able to find these items in web stores in your country.

To get started we suggest the ODROID N2+, it’s the most powerful  ODROID. It’s fast and with built-in eMMC one of the best boards to run  Home Assistant. It’s also the board that powers our [Home Assistant Blue](https://www.home-assistant.io/blue/).

- [ODROID N2+](https://ameridroid.com/products/odroid-n2-plus?ref=eeb6nfw07e)
- [Power Supply](https://ameridroid.com/products/12v-2a-power-supply-plug?ref=eeb6nfw07e)
- [CR2032 Coin Cell](https://ameridroid.com/products/rtc-bios-battery?ref=eeb6nfw07e)
- [eMMC Module](https://ameridroid.com/products/emmc-module-n2-linux-red-dot?ref=eeb6nfw07e)
- [Case](https://ameridroid.com/products/odroid-n2-case?ref=eeb6nfw07e)

If unavailable, we also recommend the [ODROID C4](https://ameridroid.com/products/odroid-c4?ref=eeb6nfw07e) or [ODROID XU4](https://ameridroid.com/products/odroid-xu4?ref=eeb6nfw07e).

###  Write the image to your boot media

1. Attach the Home Assistant boot media (eMMC module/SD card) to your computer

   If you are using a [Home Assistant Blue](https://www.home-assistant.io/blue) or ODROID N2+, you can [attach your device directly](https://www.home-assistant.io/common-tasks/os/#flashing-an-odroid-n2).

2. Download and start [Balena Etcher](https://www.balena.io/etcher). (You may need to run it with administrator privileges on Windows).

3. Select “Flash from URL” ![Screenshot of the Etcher software showing flash from URL selected.](https://www.home-assistant.io/images/installation/etcher1.png)

4. Get the URL for your ODROID:

ODROID-N2

ODROID-N2+

ODROID-C2

ODROID-C4

ODROID-XU4

```text
https://github.com/home-assistant/operating-system/releases/download/9.5/haos_odroid-n2-9.5.img.xz
```

Text

[Guide: Flashing Odroid-N2 using OTG-USB](https://www.home-assistant.io/hassio/flashing_n2_otg/)

*Select and copy the URL or use the “copy” button that appear when you hover it.*

1. Paste the URL for your ODROID into Balena Etcher and click “OK” ![Screenshot of the Etcher software showing the URL bar with a URL pasted in.](https://www.home-assistant.io/images/installation/etcher2.png)
2. Balena Etcher will now download the image, when that is done click “Select target” ![Screenshot of the Etcher software showing the select target button highlighted.](https://www.home-assistant.io/images/installation/etcher3.png)
3. Select the eMMC module/SD card you want to use for your ODROID ![Screenshot of the Etcher software showing teh targets available.](https://www.home-assistant.io/images/installation/etcher4.png)
4. Click on “Flash!” to start writing the image ![Screenshot of the Etcher software showing the Flash button highlighted.](https://www.home-assistant.io/images/installation/etcher5.png)
5. When Balena Etcher is finished writing the image you will get this confirmation ![Screenshot of the Etcher software showing that the installation has completed.](https://www.home-assistant.io/images/installation/etcher6.png)

###  Start up your ODROID

1. Insert the boot media (eMMC module/SD card) you just created.
2. Attach an Ethernet cable for network.
3. Attach the power cable.
4. In the browser of your Desktop system, within a few minutes you will be able to reach your new Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123).

- If you are running an older Windows version or have a stricter  network configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ODROID’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

These below instructions are for an installation of Home Assistant  Container running in your own container environment, which you manage  yourself. Any [OCI](https://opencontainers.org/) compatible runtime can be used, however this guide will focus on installing it with Docker.

**Prerequisites**

This guide assumes that you already have an operating system setup and a container runtime installed (like Docker).

If you are using Docker then you need to be on at least version 19.03.9, ideally an even higher version, and `libseccomp` 2.4.2 or newer.

###  Platform Installation

Installation with Docker is straightforward. Adjust the following command so that:

- `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration and run it.

- `MY_TIME_ZONE` is a [tz database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), like `TZ=America/Los_Angeles`.

  Install

  Update

  ```bash
  docker run -d \
    --name homeassistant \
    --privileged \
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE \
    -v /PATH_TO_YOUR_CONFIG:/config \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
  ```

  Bash



Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory. The arguments `-G dialout,gpio,i2c` adds the user to the `dialout`, `gpio` and the `i2c` group. The first is required for using Z-Wave and Zigbee controllers, while the second is required to communicate with GPIO.

```bash
sudo useradd -rm homeassistant -G dialout,gpio,i2c
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster.

##  ASUS Tinkerboard

[    ![img](https://www.home-assistant.io/images/installation/tinkerboard.png)   **ASUS Tinkerboard**  Home Assistant Operating System Home Assistant Container Home Assistant Core     ](https://www.home-assistant.io/installation/tinkerboard)[ ](https://www.home-assistant.io/installation/tinkerboard)

# Asus Tinkerboard

------

##  Install Home Assistant Operating System

Follow this guide if you want to get started with Home Assistant easily or if you have little to no Linux experience.

###  Suggested Hardware

We will need a few things to get started with installing Home  Assistant. Links below lead to Amazon US. If you’re not in the US, you  should be able to find it in web stores in your country.

- [Asus Tinkerboard S](https://amzn.to/3fFIcbI)

###  Write the image to your boot media

1. Attach the Home Assistant boot media (eMMC module/SD card) to your computer
2. Download and start [Balena Etcher](https://www.balena.io/etcher). (You may need to run it with administrator privileges on Windows).
3. Select “Flash from URL” ![Screenshot of the Etcher software showing flash from URL selected.](https://www.home-assistant.io/images/installation/etcher1.png)
4. Get the URL for your ASUS Tinkerboard:

```text
https://github.com/home-assistant/operating-system/releases/download/9.5/haos_tinker-9.5.img.xz
```

Text

*Select and copy the URL or use the “copy” button that appear when you hover it.*

1. Paste the URL for your ASUS Tinkerboard into Balena Etcher and click “OK” ![Screenshot of the Etcher software showing the URL bar with a URL pasted in.](https://www.home-assistant.io/images/installation/etcher2.png)
2. Balena Etcher will now download the image, when that is done click “Select target” ![Screenshot of the Etcher software showing the select target button highlighted.](https://www.home-assistant.io/images/installation/etcher3.png)
3. Select the eMMC module/SD card you want to use for your ASUS Tinkerboard ![Screenshot of the Etcher software showing teh targets available.](https://www.home-assistant.io/images/installation/etcher4.png)
4. Click on “Flash!” to start writing the image ![Screenshot of the Etcher software showing the Flash button highlighted.](https://www.home-assistant.io/images/installation/etcher5.png)
5. When Balena Etcher is finished writing the image you will get this confirmation ![Screenshot of the Etcher software showing that the installation has completed.](https://www.home-assistant.io/images/installation/etcher6.png)

###  Start up your ASUS Tinkerboard

1. Insert the boot media (eMMC module/SD card) you just created.
2. Attach an Ethernet cable for network.
3. Attach the power cable.
4. In the browser of your Desktop system, within a few minutes you will be able to reach your new Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123).

- If you are running an older Windows version or have a stricter  network configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ASUS Tinkerboard’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

These below instructions are for an installation of Home Assistant  Container running in your own container environment, which you manage  yourself. Any [OCI](https://opencontainers.org/) compatible runtime can be used, however this guide will focus on installing it with Docker.

**Prerequisites**

This guide assumes that you already have an operating system setup and a container runtime installed (like Docker).

If you are using Docker then you need to be on at least version 19.03.9, ideally an even higher version, and `libseccomp` 2.4.2 or newer.

###  Platform Installation

Installation with Docker is straightforward. Adjust the following command so that:

- `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration and run it.

- `MY_TIME_ZONE` is a [tz database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), like `TZ=America/Los_Angeles`.

  Install

  Update

  ```bash
  docker run -d \
    --name homeassistant \
    --privileged \
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE \
    -v /PATH_TO_YOUR_CONFIG:/config \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
  ```

  Bash



Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory. The arguments `-G dialout,gpio,i2c` adds the user to the `dialout`, `gpio` and the `i2c` group. The first is required for using Z-Wave and Zigbee controllers, while the second is required to communicate with GPIO.

```bash
sudo useradd -rm homeassistant -G dialout,gpio,i2c
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster. 

## Generic x86-64

[    ![img](https://www.home-assistant.io/images/installation/generic-x86-64.svg)   **Generic x86-64 (e.g. Intel NUC)**  Home Assistant Operating System Home Assistant Container Home Assistant Core     ](https://www.home-assistant.io/installation/generic-x86-64)[ ](https://www.home-assistant.io/installation/generic-x86-64)

# Generic x86-64

------

##  Install Home Assistant Operating System

Follow this guide if you want to get started with Home Assistant easily or if you have little to no Linux experience.

**Prerequisites**

This guide assumes that you have a dedicated generic x86 PC  (typically an Intel or AMD-based system) available to exclusively run  Home Assistant Operating System. The system must be 64-bit capable and  able to boot using UEFI. Pretty much all systems produced in the last 10 years support the UEFI boot mode.

**Summary**

You will need to write the HAOS (Home Assistant OS) disk image  directly to your boot media, and configure your x86 to use UEFI boot  mode when booting from this media.

###  Configure the BIOS on your x86-64 hardware

To boot Home Assistant OS, the BIOS needs to have UEFI boot mode  enabled and Secure Boot disabled. The following screenshots are from a  7th generation Intel NUC system. The BIOS menu will likely look  different on your systems. However, the options should still be present  and named similarly.

1. To enter the BIOS, start up your x86-64 hardware and repeatedly press the `F2` key (on some systems this might be `Del`, `F1` or `F10`). ![Enter BIOS using F2, Del, F1 or F10 key](https://www.home-assistant.io/images/installation/intel-nuc-enter-bios.jpg)
2. Make sure the UEFI Boot mode is enabled. ![Enable UEFI Boot mode](https://www.home-assistant.io/images/installation/intel-nuc-uefi-boot.jpg)
3. Disable Secure Boot. ![Disable Secure Boot mode](https://www.home-assistant.io/images/installation/intel-nuc-disable-secure-boot.jpg)
4. Save the changes and exit.

- The BIOS configuration is complete.

As a next step, we need to write the Home Assistant Operating System  image to the target boot medium. The HAOS has no integrated installer.  This means the Operating System is not copied automatically to the  internal disk.

- The “boot medium” is the medium your x86-64 hardware will boot from when it is running Home Assistant.
- Typically, an internal medium is used for the x86-64 hardware.  Examples of internal media are S-ATA hard disk, S-ATA SSD, M.2 SSD, or a non-removable eMMC.
- Alternatively, an external medium can be used to boot HAOS such as a USB SDD (not recommended).

To install the HAOS internally on your x86-64 hardware, there are 2 methods:

1. Copying the HAOS disk image from your Desktop computer onto your  boot medium (e.g. by using a USB to S-ATA adapter). This is not an  option for a non-removable eMMC on your x86-64 hardware, of course. To use this method, follow the steps described in the procedure below: [Write the image to your boot media](https://www.home-assistant.io/installation/generic-x86-64#write-the-image-to-your-boot-media).
2. Copying a live operating system (e.g. Ubuntu) onto a USB device.  Then, insert this USB device into your x86-64 hardware and start the  Ubuntu.

- To use this method, follow the instructions of your Live distribution (e.g., [this Ubuntu guide](https://ubuntu.com/tutorials/try-ubuntu-before-you-install)). Once you booted the live operating system, follow the steps described in the procedure below: [Write the image to your boot media](https://www.home-assistant.io/installation/generic-x86-64#write-the-image-to-your-boot-media).





###  Write the image to your boot media

1. Attach the Home Assistant boot media (storage device) to your computer
2. Download and start [Balena Etcher](https://www.balena.io/etcher). (You may need to run it with administrator privileges on Windows).
3. Select “Flash from URL” ![Screenshot of the Etcher software showing flash from URL selected.](https://www.home-assistant.io/images/installation/etcher1.png)
4. Get the URL for your Generic x86-64:

```text
https://github.com/home-assistant/operating-system/releases/download/9.5/haos_generic-x86-64-9.5.img.xz
```

Text

*Select and copy the URL or use the “copy” button that appear when you hover it.*

1. Paste the URL for your Generic x86-64 into Balena Etcher and click “OK” ![Screenshot of the Etcher software showing the URL bar with a URL pasted in.](https://www.home-assistant.io/images/installation/etcher2.png)
2. Balena Etcher will now download the image, when that is done click “Select target” ![Screenshot of the Etcher software showing the select target button highlighted.](https://www.home-assistant.io/images/installation/etcher3.png)
3. Select the storage device you want to use for your Generic x86-64 ![Screenshot of the Etcher software showing teh targets available.](https://www.home-assistant.io/images/installation/etcher4.png)
4. Click on “Flash!” to start writing the image ![Screenshot of the Etcher software showing the Flash button highlighted.](https://www.home-assistant.io/images/installation/etcher5.png)
5. When Balena Etcher is finished writing the image you will get this confirmation ![Screenshot of the Etcher software showing that the installation has completed.](https://www.home-assistant.io/images/installation/etcher6.png)

###  Start up your Generic x86-64

1. If you used your desktop system to write the HAOS your boot media,  install the boot media (storage device) in the generic-x86-64 system.

- If you used a live operating system (e.g. Ubuntu), shut down the  live operating system and make sure to remove the USB flash drive you  used for the live system.

1. Make sure an Ethernet cable is plugged in for network.
2. Power the system on.
   - Wait for the Home Assistant welcome banner to show up in the console of the generic-x86-64 system.

If the machine complains about not being able to find a bootable medium, you might need to specify the EFI entry in your BIOS. This can be accomplished either by using a live operating system (e.g. Ubuntu) and running the following command (replace `<drivename>` with the appropriate drive name assigned by Linux, typically this will be `sda` or `nvme0n1` on NVMe SSDs):

```text
efibootmgr --create --disk /dev/<drivename> --part 1 --label "HAOS" \
   --loader '\EFI\BOOT\bootx64.efi'
```

Text

Or else, the BIOS might provide you with a tool to add boot options, there you can specify the path to the EFI file:

```text
\EFI\BOOT\bootx64.efi
```

Text

1. In the browser of your Desktop system, within a few minutes you will be able to reach your new Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123).

- If you are running an older Windows version or have a stricter  network configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your Generic x86-64’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

These below instructions are for an installation of Home Assistant  Container running in your own container environment, which you manage  yourself. Any [OCI](https://opencontainers.org/) compatible runtime can be used, however this guide will focus on installing it with Docker.

**Prerequisites**

This guide assumes that you already have an operating system setup and a container runtime installed (like Docker).

If you are using Docker then you need to be on at least version 19.03.9, ideally an even higher version, and `libseccomp` 2.4.2 or newer.

###  Platform Installation

Installation with Docker is straightforward. Adjust the following command so that:

- `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration and run it.

- `MY_TIME_ZONE` is a [tz database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), like `TZ=America/Los_Angeles`.

  Install

  Update

  ```bash
  docker run -d \
    --name homeassistant \
    --privileged \
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE \
    -v /PATH_TO_YOUR_CONFIG:/config \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
  ```

  Bash



Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory. The arguments `-G dialout,gpio,i2c` adds the user to the `dialout`, `gpio` and the `i2c` group. The first is required for using Z-Wave and Zigbee controllers, while the second is required to communicate with GPIO.

```bash
sudo useradd -rm homeassistant -G dialout,gpio,i2c
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster.

##  Windows

[     ](https://www.home-assistant.io/installation/windows)[ **Windows**  Home Assistant Operating System (VM) Home Assistant Core    ](https://www.home-assistant.io/installation/windows)[ ](https://www.home-assistant.io/installation/windows)

# Windows

------

##  Install Home Assistant Operating System

###  Download the appropriate image

- [VirtualBox](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vdi.zip) (.vdi)
- [KVM](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.qcow2.xz) (.qcow2)
- [Vmware Workstation](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vmdk.zip) (.vmdk)
- [Hyper-V](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vhdx.zip) (.vhdx)

Follow this guide if you already are running a supported virtual  machine hypervisor. If you are not familiar with virtual machines we  recommend installation Home Assistant OS directly on a [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi) or an [ODROID](https://www.home-assistant.io/installation/odroid).

###  Create the Virtual Machine

Load the appliance image into your virtual machine hypervisor. (Note: You are free to assign as much resources as you wish to the VM, please  assign enough based on your add-on needs).

Minimum recommended assignments:

- 2 GB RAM
- 32 GB Storage
- 2vCPU

*All these can be extended if your usage calls for more resources.*

###  Hypervisor specific configuration

VirtualBox

KVM (virt-manager)

KVM (virt-install)

Vmware Workstation

Hyper-V

1. Create a new virtual machine
2. Select Type “Linux” and Version “Linux 2.6 / 3.x / 4.x (64-bit)”
3. Select “Use an existing virtual hard disk file”, select the unzipped VDI file from above
4. Edit the “Settings” of the VM and go “System” then “Motherboard” and select “Enable EFI”
5. Then go to “Network” “Adapter 1” choose “Bridged Adapter” and choose your Network adapter

Please keep in mind that the bridged adapter only functions over a hardwired ethernet connection. Using Wi-Fi on your VirtualBox host is unsupported.

\6. Then go to "Audio" and choose "Intel HD Audio" as Audio Controller.

By default VirtualBox does not free up unused disk space. To automatically shrink the vdi disk image the `discard` option must be enabled:

```bash
VBoxManage storageattach <VM name> --storagectl "SATA" --port 0 --device 0 --nonrotational on --discard on
```

Bash



###  Start up your Virtual Machine

1. Start the Virtual Machine
2. Observe the boot process of Home Assistant Operating System
3. Once completed you will be able to reach Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123). If you are running an older Windows version or have a stricter network  configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Core

###  Install WSL

To install Home Assistant Core on Windows, you will need to use the Windows Subsystem for Linux (WSL). Follow the [WSL installation instructions](https://docs.microsoft.com/windows/wsl/install-win10) and install Ubuntu from the Windows Store.

As an alternative, Home Assistant OS can be installed in a Linux  guest VM. Running Home Assistant Core directly on Windows is not  supported.

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory.

```bash
sudo useradd -rm homeassistant
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster. 

## macOS

[     ](https://www.home-assistant.io/installation/macos)[ **macOS**  Home Assistant Operating System (VM) Home Assistant Core    ](https://www.home-assistant.io/installation/macos)[ ](https://www.home-assistant.io/installation/macos)

# MacOS

------

##  Install Home Assistant Operating System

###  Download the appropriate image

- [VirtualBox](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vdi.zip) (.vdi)
- [KVM](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.qcow2.xz) (.qcow2)

Follow this guide if you already are running a supported virtual  machine hypervisor. If you are not familiar with virtual machines we  recommend installation Home Assistant OS directly on a [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi) or an [ODROID](https://www.home-assistant.io/installation/odroid).

###  Create the Virtual Machine

Load the appliance image into your virtual machine hypervisor. (Note: You are free to assign as much resources as you wish to the VM, please  assign enough based on your add-on needs).

Minimum recommended assignments:

- 2 GB RAM
- 32 GB Storage
- 2vCPU

*All these can be extended if your usage calls for more resources.*

###  Hypervisor specific configuration

VirtualBox

KVM (virt-manager)

KVM (virt-install)

1. Create a new virtual machine
2. Select Type “Linux” and Version “Linux 2.6 / 3.x / 4.x (64-bit)”
3. Select “Use an existing virtual hard disk file”, select the unzipped VDI file from above
4. Edit the “Settings” of the VM and go “System” then “Motherboard” and select “Enable EFI”
5. Then go to “Network” “Adapter 1” choose “Bridged Adapter” and choose your Network adapter

Please keep in mind that the bridged adapter only functions over a hardwired ethernet connection. Using Wi-Fi on your VirtualBox host is unsupported.

\6. Then go to "Audio" and choose "Intel HD Audio" as Audio Controller.

By default VirtualBox does not free up unused disk space. To automatically shrink the vdi disk image the `discard` option must be enabled:

```bash
VBoxManage storageattach <VM name> --storagectl "SATA" --port 0 --device 0 --nonrotational on --discard on
```

Bash



###  Start up your Virtual Machine

1. Start the Virtual Machine
2. Observe the boot process of Home Assistant Operating System
3. Once completed you will be able to reach Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123). If you are running an older Windows version or have a stricter network  configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory.

```bash
sudo useradd -rm homeassistant
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster.

##  Linux

[    ![img](https://www.home-assistant.io/images/installation/linux.svg)   **Linux**  Home Assistant Operating System (VM) Home Assistant Container Home Assistant Core Home Assistant Supervised     ](https://www.home-assistant.io/installation/linux)[ ](https://www.home-assistant.io/installation/linux)

# Linux

------

##  Install Home Assistant Operating System

###  Download the appropriate image

- [VirtualBox](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vdi.zip) (.vdi)
- [KVM](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.qcow2.xz) (.qcow2)
- [Vmware Workstation](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vmdk.zip) (.vmdk)

Follow this guide if you already are running a supported virtual  machine hypervisor. If you are not familiar with virtual machines we  recommend installation Home Assistant OS directly on a [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi) or an [ODROID](https://www.home-assistant.io/installation/odroid).

###  Create the Virtual Machine

Load the appliance image into your virtual machine hypervisor. (Note: You are free to assign as much resources as you wish to the VM, please  assign enough based on your add-on needs).

Minimum recommended assignments:

- 2 GB RAM
- 32 GB Storage
- 2vCPU

*All these can be extended if your usage calls for more resources.*

###  Hypervisor specific configuration

VirtualBox

KVM (virt-manager)

KVM (virt-install)

Vmware Workstation

1. Create a new virtual machine
2. Select Type “Linux” and Version “Linux 2.6 / 3.x / 4.x (64-bit)”
3. Select “Use an existing virtual hard disk file”, select the unzipped VDI file from above
4. Edit the “Settings” of the VM and go “System” then “Motherboard” and select “Enable EFI”
5. Then go to “Network” “Adapter 1” choose “Bridged Adapter” and choose your Network adapter

Please keep in mind that the bridged adapter only functions over a hardwired ethernet connection. Using Wi-Fi on your VirtualBox host is unsupported.

\6. Then go to "Audio" and choose "Intel HD Audio" as Audio Controller.

By default VirtualBox does not free up unused disk space. To automatically shrink the vdi disk image the `discard` option must be enabled:

```bash
VBoxManage storageattach <VM name> --storagectl "SATA" --port 0 --device 0 --nonrotational on --discard on
```

Bash



###  Start up your Virtual Machine

1. Start the Virtual Machine
2. Observe the boot process of Home Assistant Operating System
3. Once completed you will be able to reach Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123). If you are running an older Windows version or have a stricter network  configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

These below instructions are for an installation of Home Assistant  Container running in your own container environment, which you manage  yourself. Any [OCI](https://opencontainers.org/) compatible runtime can be used, however this guide will focus on installing it with Docker.

**Prerequisites**

This guide assumes that you already have an operating system setup and a container runtime installed (like Docker).

If you are using Docker then you need to be on at least version 19.03.9, ideally an even higher version, and `libseccomp` 2.4.2 or newer.

###  Platform Installation

Installation with Docker is straightforward. Adjust the following command so that:

- `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration and run it.

- `MY_TIME_ZONE` is a [tz database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), like `TZ=America/Los_Angeles`.

  Install

  Update

  ```bash
  docker run -d \
    --name homeassistant \
    --privileged \
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE \
    -v /PATH_TO_YOUR_CONFIG:/config \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
  ```

  Bash



Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Install Home Assistant Core

This is an advanced installation process, and some steps might differ on your system. Considering the nature of this installation type, we  assume you can handle subtle differences between this document and the  system configuration you are using. When in doubt, please consider one  of the [other installation methods](https://www.home-assistant.io/installation/), as they might be a better fit instead.

**Prerequisites**

This guide assumes that you already have an operating system setup and have installed Python 3.10 (including the package `python3-dev`) or newer.

###  Install dependencies

Before you start, make sure your system is fully updated, all packages in this guide are installed with `apt`, if your OS does not have that, look for alternatives.

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Bash

Install the dependencies:

```bash
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Bash

The above-listed dependencies might differ or missing, depending on your system or personal use of Home Assistant.

###  Create an account

Add an account for Home Assistant Core called `homeassistant`. Since this account is only for running Home Assistant Core the extra arguments of `-rm` is added to create a system account and create a home directory.

```bash
sudo useradd -rm homeassistant
```

Bash

###  Create the virtual environment

First we will create a directory for the installation of Home Assistant Core and change the owner to the `homeassistant` account.

```bash
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
```

Bash

Next up is to create and change to a virtual environment for Home Assistant Core. This will be done as the `homeassistant` account.

```bash
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
```

Bash

Once you have activated the virtual environment (notice the prompt change to `(homeassistant) homeassistant@raspberrypi:/srv/homeassistant $`) you will need to run the following command to install a required Python package.

```bash
python3 -m pip install wheel
```

Bash

Once you have installed the required Python package, it is now time to install Home Assistant Core!

```bash
pip3 install homeassistant==2023.1.7
```

Bash

Start Home Assistant Core for the first time. This will complete the installation for you, automatically creating the `.homeassistant` configuration directory in the `/home/homeassistant` directory, and installing any basic dependencies.

```bash
hass
```

Bash

You can now reach your installation via the web interface on `http://homeassistant.local:8123`.

If this address doesn’t work you may also try `http://localhost:8123` or `http://X.X.X.X:8123` (replace X.X.X.X with your machines’ IP address).

When you run the `hass` command for the first time, it  will download, install and cache the necessary libraries/dependencies.  This procedure may take anywhere between 5 to 10 minutes. During that  time, you may get “site cannot be reached” error when accessing the web  interface. This will only happen for the first time, and subsequent  restarts will be much faster.

##  Install Home Assistant Supervised

This way of running Home Assistant will require the most of you. It also has strict requirements you need to follow.

Unless you really need this installation type, you should install Home Assistant OS (this can also be a [virtual machine](https://www.home-assistant.io/installation/linux#install-home-assistant-operating-system)), or [Home Assistant Container](https://www.home-assistant.io/installation/linux#install-home-assistant-container).

1. First make sure you understand the [requirements](https://github.com/home-assistant/architecture/blob/master/adr/0014-home-assistant-supervised.md).
2. This installation method has very strict requirements, for example, it only supports Debian (and Ubuntu, Armbian, Raspberry Pi OS are **not** supported). So, make sure you understand the requirements from step 1 above.
3. Then head over to [home-assistant/supervised-installer](https://github.com/home-assistant/supervised-installer) to set it up.

Once the Home Assistant Supervised installation is running and Home Assistant is accessible you can continue with onboarding.

##  Alternative

[     ](https://www.home-assistant.io/installation/alternative)[ **Alternative** VM's not covered by other categories, NAS installations and community guides   ](https://www.home-assistant.io/installation/alternative)

[ ](https://www.home-assistant.io/installation/alternative)

# Alternative

------

##  Install Home Assistant Operating System

###  Download the appropriate image

- [VirtualBox](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.vdi.zip) (.vdi)
- [KVM/Proxmox](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.qcow2.xz) (.qcow2)
- [VMware ESXi/vSphere](https://github.com/home-assistant/operating-system/releases/download/9.5/haos_ova-9.5.ova) (.ova)

Follow this guide if you already are running a supported virtual  machine hypervisor. If you are not familiar with virtual machines we  recommend installation Home Assistant OS directly on a [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi) or an [ODROID](https://www.home-assistant.io/installation/odroid).

###  Create the Virtual Machine

Load the appliance image into your virtual machine hypervisor. (Note: You are free to assign as much resources as you wish to the VM, please  assign enough based on your add-on needs).

Minimum recommended assignments:

- 2 GB RAM
- 32 GB Storage
- 2vCPU

*All these can be extended if your usage calls for more resources.*

###  Hypervisor specific configuration

VirtualBox

KVM (virt-manager)

KVM (virt-install)

VMware ESXi/vSphere

1. Create a new virtual machine
2. Select Type “Linux” and Version “Linux 2.6 / 3.x / 4.x (64-bit)”
3. Select “Use an existing virtual hard disk file”, select the unzipped VDI file from above
4. Edit the “Settings” of the VM and go “System” then “Motherboard” and select “Enable EFI”
5. Then go to “Network” “Adapter 1” choose “Bridged Adapter” and choose your Network adapter

Please keep in mind that the bridged adapter only functions over a hardwired ethernet connection. Using Wi-Fi on your VirtualBox host is unsupported.

\6. Then go to "Audio" and choose "Intel HD Audio" as Audio Controller.

By default VirtualBox does not free up unused disk space. To automatically shrink the vdi disk image the `discard` option must be enabled:

```bash
VBoxManage storageattach <VM name> --storagectl "SATA" --port 0 --device 0 --nonrotational on --discard on
```

Bash



###  Start up your Virtual Machine

1. Start the Virtual Machine
2. Observe the boot process of Home Assistant Operating System
3. Once completed you will be able to reach Home Assistant on [homeassistant.local:8123](http://homeassistant.local:8123). If you are running an older Windows version or have a stricter network  configuration, you might need to access Home Assistant at [homeassistant:8123](http://homeassistant:8123) or `http://X.X.X.X:8123` (replace X.X.X.X with your ’s IP address).

With the Home Assistant Operating System installed and accessible you can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

##  Install Home Assistant Container

###  Synology NAS

As Synology within DSM now supports Docker (with a neat UI), you can  simply install Home Assistant using Docker without the need for  command-line. For details about the package (including  compatibility-information, if your NAS is supported), see https://www.synology.com/en-us/dsm/packages/Docker

The steps would be:

- Install “Docker” package on your Synology NAS
- Launch Docker-app and move to “Registry”-section
- Find “homeassistant/home-assistant” within registry and click on “Download”. Choose the “stable” tag.
- Wait for some time until your NAS has pulled the image
- Move to the “Image”-section of the Docker-app
- Click on “Launch”
- Within “Network” select “Use same network as Docker Host” and click Next
- Choose a container-name you want (e.g., “homeassistant”)
- Set “Enable auto-restart” if you like
- Click on “Advanced Settings”. To ensure that Home Assistant displays the correct timezone go to the “Environment” tab and click the plus  sign then add `variable` = `TZ` & `value` = `Europe/London` choosing [your correct timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones). Click Save to exit Advanced Settings.
- Click Next
- Within “Volume Settings” click on “Add Folder” and choose either an  existing folder or add a new folder (e.g. in “docker” shared folder, add new folder named “homeassistant” and then within that new folder add  another new folder “config”), then click Select. Then edit the “mount  path” to be “/config”. This configures where Home Assistant will store  configs and logs.
- Ensure “Run this container after the wizard is finished” is checked and click Done
- Your Home Assistant within Docker should now run and will serve the  web interface from port 8123 on your Docker host (this will be your  Synology NAS IP address - for example `http://192.168.1.10:8123`)

If you are using the built-in firewall, you must also add the port  8123 to allowed list. This can be found in “Control Panel ->  Security” and then the Firewall tab. Click “Edit Rules” besides the  Firewall Profile dropdown box. Create a new rule and select “Custom” for Ports and add 8123. Edit Source IP if you like or leave it at default  “All”. Action should stay at “Allow”.

To use a Z-Wave USB stick for Z-Wave control, the HA Docker container needs extra configuration to access to the USB stick. While there are  multiple ways to do this, the least privileged way of granting access  can only be performed via the Terminal, at the time of writing. See this page for configuring Terminal access to your Synology NAS:

https://www.synology.com/en-global/knowledgebase/DSM/help/DSM/AdminCenter/system_terminal

[See this page for accessing the Terminal via SSH](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General_Setup/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)

Adjust the following Terminal command as follows :

- Replace `/PATH_TO_YOUR_CONFIG` points at the folder where you want to store your configuration
- Replace `/PATH_TO_YOUR_USB_STICK` matches the path for your USB stick (e.g., `/dev/ttyACM0` for most Synology users)
- Replace “Australia/Melbourne” with [your timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Run it in Terminal.

```bash
sudo docker run --restart always -d --name homeassistant -v /PATH_TO_YOUR_CONFIG:/config --device=/PATH_TO_YOUR_USB_STICK -e TZ=Australia/Melbourne --net=host ghcr.io/home-assistant/home-assistant:stable
```

Bash

Complete the remainder of the Z-Wave configuration by [following the instructions here.](https://www.home-assistant.io/integrations/zwave_js)

Remark: to update your Home Assistant on your Docker within Synology NAS, you just have to do the following:

- Go to the Docker-app and move to “Registry”-section
- Find “homeassistant/home-assistant” within registry and click on “Download”. Choose the “stable” tag.
- Wait until the system-message/-notification comes up, that the download is finished (there is no progress bar)
- Move to “Container”-section
- Stop your container if it’s running
- Right-click on it and select “Action”->“Reset”. You won’t lose  any data, as all files are stored in your configuration-directory
- Start the container again - it will then boot up with the new Home Assistant image

Remark: to restart your Home Assistant within Synology NAS, you just have to do the following:

- Go to the Docker-app and move to “Container”-section
- Right-click on it and select “Action”->“Restart”.

If you want to use a USB Bluetooth adapter or Z-Wave USB Stick with  Home Assistant on Synology Docker these instructions do not correctly  configure the container to access the USB devices. To configure these  devices on your Synology Docker Home Assistant you can follow the  instructions provided [here](https://philhawthorne.com/installing-home-assistant-io-on-a-synology-diskstation-nas/) by Phil Hawthorne.

###  QNAP NAS

As QNAP within QTS now supports Docker (with a neat UI), you can  simply install Home Assistant using Docker without the need for  command-line. For details about the package (including  compatibility-information, if your NAS is supported), see https://www.qnap.com/solution/container_station/en/index.php

The steps would be:

- Install “Container Station” package on your Qnap NAS
- Launch Container Station and move to “Create Container”-section
- Search image “homeassistant/home-assistant” with Docker Hub and click on “Install” Make attention to CPU architecture of your NAS. For ARM CPU types the correct image is “homeassistant/armhf-homeassistant”
- Choose “stable” version and click next
- Choose a container-name you want (e.g., “homeassistant”)
- Click on “Advanced Settings”
- Within “Shared Folders” click on “Volume from host” > “Add” and  choose either an existing folder or add a new folder. The “mount point  has to be `/config`, so that Home Assistant will use it for the configuration and logs.
- Within “Network” and select Network Mode to “Host”
- To ensure that Home Assistant displays the correct timezone go to the “Environment” tab and click the plus sign then add `variable` = `TZ` & `value` = `Europe/London` choosing [your correct timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
- Click on “Create”
- Wait for some time until your NAS has created the container
- Your Home Assistant within Docker should now run and will serve the  web interface from port 8123 on your Docker host (this will be your Qnap NAS IP address - for example `http://192.xxx.xxx.xxx:8123`)

Remark: To update your Home Assistant on your Docker within Qnap NAS, you just remove container and image and do steps again (Don’t remove  “config” folder).

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Restart Home Assistant

If you change the configuration you have to restart the server. To do that you have 3 options.

1. In your Home Assistant UI go to the **Settings** -> **System** and click the “Restart” button.
2. You can go to the **Developer Tools** -> **Services**, select the service `homeassistant.restart` and click “Call Service”.
3. Restart it from a terminal.

Docker CLI

Docker Compose

```bash
docker restart homeassistant
```

Bash



###  Docker Compose

`docker compose` should [already be installed](https://www.docker.com/blog/announcing-compose-v2-general-availability/) on your system. If not, you can [manually](https://docs.docker.com/compose/install/linux/) install it.

As the Docker command becomes more complex, switching to `docker compose` can be preferable and support automatically restarting on failure or system restart. Create a `compose.yml` file:

```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /PATH_TO_YOUR_CONFIG:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```

YAML

Start it by running:

```bash
docker compose up -d
```

Bash

Once the Home Assistant Container is running Home Assistant should be accessible using `http://<host>:8123` (replace  with the hostname or IP of the system). You can continue with onboarding.

[  Onboarding  ](https://www.home-assistant.io/getting-started/onboarding/)[ ](https://www.home-assistant.io/getting-started/onboarding/)

###  Exposing Devices

In order to use Zigbee or other integrations that require access to  devices, you need to map the appropriate device into the container.  Ensure the user that is running the container has the correct privileges to access the `/dev/tty*` file, then add the device mapping to your container instructions:

Docker CLI

Docker Compose

```bash
docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...
```

Bash



###  Optimizations

The Home Assistant Container is using an alternative memory allocation library [jemalloc](http://jemalloc.net/) for better memory management and Python runtime speedup.

As jemalloc can cause issues on certain hardware, it can be disabled by passing the environment variable `DISABLE_JEMALLOC` with any value, for example:

Docker CLI

Docker Compose

```bash
docker run ... -e "DISABLE_JEMALLOC=true" ...
```

Bash



The error message `<jemalloc>: Unsupported system page size` is one known indicator.

##  Community provided guides

Additional installation guides can be found on our [Community Forum](https://community.home-assistant.io/tags/c/community-guides/51/installation).

These Community Guides are provided as-is. Some of these install  methods are more limited than the methods above. Some integrations may  not work due to limitations of the platform.

##  Compare Installation Methods

|                                                              | OS   | Container | Core | Supervised |
| ------------------------------------------------------------ | ---- | --------- | ---- | ---------- |
| [Automations](https://www.home-assistant.io/docs/automation) | ✅    | ✅         | ✅    | ✅          |
| [Dashboards](https://www.home-assistant.io/dashboards)       | ✅    | ✅         | ✅    | ✅          |
| [Integrations](https://www.home-assistant.io/integrations)   | ✅    | ✅         | ✅    | ✅          |
| [Blueprints](https://www.home-assistant.io/docs/blueprint)   | ✅    | ✅         | ✅    | ✅          |
| Uses container                                               | ✅    | ✅         | ❌    | ✅          |
| [Supervisor](https://www.home-assistant.io/docs/glossary/#home-assistant-supervisor) | ✅    | ❌         | ❌    | ✅          |
| [Add-ons](https://www.home-assistant.io/addons)              | ✅    | ❌         | ❌    | ✅          |
| [Backups](https://www.home-assistant.io/common-tasks/os/#backups) | ✅    | ✅1        | ✅1   | ✅          |
| Managed OS                                                   | ✅    | ❌         | ❌    | ❌          |

1: Backups for Home Assistant Core and Home Assistant Container is provided by the [`backup` integration](https://www.home-assistant.io/integrations/backup).

# Onboarding Home Assistant

------

Alright, you made it here. The tough part is done.

With Home Assistant installed, it’s time to configure it. Here you  will create the owner account of Home Assistant. This account will be an administrator and will always be able to change everything. Enter a  name, username, password and click on “create account”.

![Set your username and password.](https://www.home-assistant.io/images/getting-started/username.png)

Next, you can enter a name for your home and set your location and  unit system. Click “DETECT” to find your location and set your time zone and unit system based on that location. If you’d rather not send your  location, you can set these values manually.

![Set your location, time zone, and unit system.](https://www.home-assistant.io/images/getting-started/location.png)

Once you are done, click Next. In this screen, Home Assistant will  show any devices that it has discovered on your network. Don’t be  alarmed if you see fewer items than what is shown below; you can always  manually add devices later.

![Discovery of devices on your network.](https://www.home-assistant.io/images/getting-started/devices.png)

Finally, click Finish. Now you’re brought to the Home Assistant web  interface. This screen will show all of your devices. So let’s get that  screen filled up!

![The Home Assistant user interface.](https://www.home-assistant.io/images/getting-started/lovelace.png)

From the side bar, click on [Settings -> Devices & Services](https://my.home-assistant.io/redirect/integrations). At this screen you will be able to set up integrations with Home  Assistant. You might notice a “discovered” section. This section  contains integrations that were found on your network and can easily be  added with a few clicks. If your integrations are not discovered, click  the **Add integration** button in the lower right and search for your integration in that list.

![The integrations page in the configurations panel shows you all your configured integrations.](https://www.home-assistant.io/images/getting-started/integrations.png)

When each integration is done setting up, it will ask you to put the  new devices in areas. Areas allow you to organize all the devices in  your home.

When you’re done, navigate back to the web interface and voila, your devices are ready for you to control.

# Automating Home Assistant

------

Once your devices are set up, it’s time to put the cherry on the pie: automation. In this guide we’re going to create a simple automation  rule to **turn on the lights when the sun sets**. Of course, this assumes that you have set up an integration that provides a light at this point.

In the user interface, click Settings in the sidebar, then click  Automations & Scenes. You will now see the automation screen from  which you can manage all the automations in Home Assistant.

![img](https://www.home-assistant.io/images/getting-started/automation-editor.png) The automation editor.

Click the blue button at the bottom right to create a new automation. A dialog will appear. Choose “Start with an empty automation”. You are  presented with a blank automation screen.

![img](https://www.home-assistant.io/images/getting-started/new-automation.png) The start of a new automation.

The first thing we will do is set a name. Enter “Turn Lights On at Sunset”.

The second step is defining what should trigger our automation to  run. In this case, we want to use the event of the sun setting to  trigger our automation. However, if we would turn on the lights when the sun actually sets, it would be too late as it already gets quite dark  while it’s setting. So we’re going to add an offset.

In the trigger section, click on the dropdown menu and change the  trigger type to “Sun.” It allows us to choose sunrise or sunset, so go  ahead and pick sunset. As we discussed, we want our automation to be  triggered a little before the sun actually sets, so let’s add `-00:30` as the offset. This indicates that the automation will be triggered 30 minutes before the sun actually sets. Neat!

![img](https://www.home-assistant.io/images/getting-started/new-trigger.png) A new automation with a sun trigger filled in.

Once we have defined our trigger, scroll down to the action section.  Make sure the action type is set to “Call service,” and change the  service to `light.turn_on`. For this automation we’re going to turn on all lights, so let’s change the service data to:

```yaml
entity_id: all
```

YAML

![img](https://www.home-assistant.io/images/getting-started/action.png) A new automation with the action set up to turn on the lights.

Click the orange button to save the automation. Now wait till it’s 30 minutes until the sun sets and see your automation magic!

[  Presence detection  ](https://www.home-assistant.io/getting-started/presence-detection/)[ ](https://www.home-assistant.io/getting-started/presence-detection/)

If after completing this getting started, you are interested in reading more about automations, we recommend the following page.

- [Triggers](https://www.home-assistant.io/docs/automation/trigger/)
- [Conditions](https://www.home-assistant.io/docs/automation/condition/)
- [Actions](https://www.home-assistant.io/docs/automation/action/)

Please note, these pages require a bit more experience with Home Assistant than you probably have at this point of this tutorial.

# Setting up presence detection

------

Presence detection detects if people are home, which can be valuable  input for automation. Knowing who is home or where they are, will open a whole range of other automation options:

- Send me a notification when my child arrives at school
- Turn on the AC when I leave work

![Screenshot of Home Assistant showing a school, work and home zone and two people.](https://www.home-assistant.io/images/screenshots/map.png)

###  Adding presence detection

There are different ways of setting up presence detection. Usually  the easiest way to detect presence is by checking which devices are  connected to the network. You can do that if you have one of our [supported routers](https://www.home-assistant.io/integrations/#presence-detection). By leveraging what your router already knows, you can easily detect if people are at home.

It’s also possible to run an app on your phone to provide detailed  location information to your Home Assistant instance. For iOS and  Android, we suggest using the [Home Assistant Companion app](https://companion.home-assistant.io/).

During the setup of Home Assistant Companion on your mobile device,  the app will ask for permission to allow the device’s location to be  provided to Home Assistant. Allowing this will create a `device_tracker` entity for that device which can be used in automations and conditions.

###  Zones

![Map with zones](https://www.home-assistant.io/images/screenshots/badges-zone.png)

Zones allow you to name areas on a map. These areas can then be used  to name the location a tracked user is, or use entering/leaving a zone  as an automation [trigger](https://www.home-assistant.io/getting-started/automation-trigger/#zone-trigger) or [condition](https://www.home-assistant.io/getting-started/automation-condition/#zone-condition). See [Zones integration](https://www.home-assistant.io/integrations/zone/) page for more details like creating zones.

The map view will hide all devices that are home.

# Join the Community

------

You made it here? Good job! You’ve been able to install Home  Assistant and get a small taste of all the things that are possible.

Now that you’ve got that going, let’s see what is next:

- Learn about [advanced configuration](https://www.home-assistant.io/getting-started/configuration/) using `configuration.yaml` in our bonus step of the getting started guide.
- Join the community in [our forums](https://community.home-assistant.io/) or [our chat](https://www.home-assistant.io/join-chat/).
- Check out [video tutorials](https://www.youtube.com/results?search_query=home+assistant) on a wide range of Home Assistant related topics

You’re now ready to be a part of our world-wide community of tinkerers. Welcome!

# Advanced Configuration

------

The onboarding process takes care of the initial setup for Home  Assistant, such as naming your home and selecting your location. After  initial onboarding, these options can be changed in the user interface  by clicking on Configuration in the sidebar and clicking on General, or  by manually editing them in the Home Assistant configuration file called `configuration.yaml`. This section will explain how to do the latter.

The steps below do not apply to Home Assistant Core & Container installations, for those types of installations, [see here](https://www.home-assistant.io/docs/configuration/).

We are going to help you make your first changes to `configuration.yaml`. To do this, we are going to install an add-on from the Home Assistant  add-on store: the File editor. To get to the add-on store, go to [Settings > Add-ons](https://my.home-assistant.io/redirect/supervisor). On the new page, open the add-on store tab.

![Add-on store.](https://www.home-assistant.io/images/hassio/screenshots/dashboard.png)

Under the “Official add-ons” section you will find the File editor add-on.

- Click on File Editor and click on **Install**. When installation is complete, the UI will go to the add-on details page for the file editor.
- Now start the add-on by clicking on **Start**.
- Open the user interface by clicking on **Open Web UI**.

Now let’s make a change using the file editor: we are going to change the name, location, unit system, and time zone of your Home Assistant  installation.

- Click the folder icon in the top left of the file editor window to open the file browser sidebar.
- Click the `configuration.yaml` file (in the `/config/` folder) to load it into the main file editor window.
- Add the following to this file (preferably at the very top, but it ultimately doesn’t matter):

```yaml
homeassistant:
  name: Home
  latitude: xx.xxxx
  longitude: xx.xxxx
  unit_system: us_customary
  time_zone: America/Chicago
```

YAML

Valid options for `unit_system` are `us_customary` or `metric`. See [here](https://timezonedb.com/time-zones) for a list of valid time zones. Enter the appropriate option found under the Time Zone column at that page.

- Click the save icon in the top right to commit changes.
- Most changes in `configuration.yaml` require Home  Assistant to be restarted to see the changes. You can verify that your  changes are acceptable by running a configuration check. Do this by  navigating to [Developer Tools -> YAML](https://my.home-assistant.io/redirect/server_controls) and and then clicking on the **Check configuration** button. When it’s valid, it will show the text “Configuration valid!”. In order for the **Check Configuration**” button to be visible, you must enable “Advanced Mode” on your user profile.
- Now Restart Home Assistant. You can do so by either using the **Restart** option in the ⚙ menu of the File Editor UI or by navigating to [Settings -> System](https://my.home-assistant.io/redirect/system_dashboard) and then clicking on the **Restart** button on the top right of the page.

![Screenshot of the “General” page in the configuration panel.](https://www.home-assistant.io/images/screenshots/configuration-validation.png)

If you have watched any videos about setting up Home Assistant using `configuration.yaml` (particularly ones that are old), you might notice your default  configuration file is much smaller than what the videos show. Don’t be  concerned, you haven’t done anything wrong. Many items in the default  configuration files shown in those old videos are now included in the `default_config:` line that you see in your configuration file. [See here](https://www.home-assistant.io/integrations/default_config/) for more information on what’s included in that line.

###  Editing configuration via Samba/Windows Networking

Maybe you are not a big fan of our web editor and want to use a text  editor on your computer instead. This is possible by sharing the  configuration over the network using the Samba add-on, which can also be installed from the Home Assistant add-on store. This will make your  configuration accessible via the network tab on your computer.

Go to the add-on store and look for Samba in the core section. After  you have installed the add-on, click on START. Home Assistant should now be available in the networking tab on your computer.

We suggest that to edit `configuration.yaml`, you use the free text editor [Visual Studio Code](https://code.visualstudio.com/) in combination with the [Home Assistant Configuration Helper extension](https://marketplace.visualstudio.com/items?itemName=keesschollaart.vscode-home-assistant).

# Configuration.yaml

------

While you can configure most of Home Assistant directly from the user interface under [Settings](https://my.home-assistant.io/redirect/config), some parts need you to edit `configuration.yaml`. This file contains integrations to be loaded along with their  configurations. Throughout the documentation you will find snippets that you can add to your configuration file to enable specific  functionality.

If you run into trouble while configuring Home Assistant, refer to the [configuration troubleshooting page](https://www.home-assistant.io/docs/configuration/troubleshooting/) and the [`configuration.yaml` examples](https://www.home-assistant.io/examples/#example-configurationyaml).

##  Editing configuration.yaml

The easiest option to edit `configuration.yaml` is to use the [Studio Code Server add-on](https://my.home-assistant.io/redirect/supervisor_addon?addon=a0d7b954_vscode). This add-on runs VS Code, which offers live syntax checking and  auto-fill of various Home Assistant entities (if unavailable on your  system, use [File Editor add-on](https://my.home-assistant.io/redirect/supervisor_addon?addon=core_configurator) instead).

If you prefer to use a file editor on your computer, use the [Samba add-on](https://my.home-assistant.io/redirect/supervisor_addon?addon=core_samba) to access the files as a network share.

The path to your configuration directory can be found in the Home Assistant frontend by going to [Settings > System > Repairs > System information from the top right menu](https://my.home-assistant.io/redirect/system_health)

![Show system menu option](https://www.home-assistant.io/images/screenshots/System_information_menu.png)

Right under the version you are running, you will find what path Home Assistant has loaded the configuration from. ![Screenshot showing the top of the system information panel](https://www.home-assistant.io/images/screenshots/System_information.png)

*If you use Home Assistant Container, you can find `configuration.yaml` in the config folder that you mounted in your container.*

*If you use Home Assistant Operating System, you can find `configuration.yaml` in the `/config` folder of the installation.*

*If you use Home Assistant Core, you can find `configuration.yaml` in the config folder passed to the `hass` command (default is `~/.homeassistant`).*

##  Reloading changes

Most integrations in Home Assistant that do not interact with devices or services can reload changes made to their configuration in `configuration.yaml`. To do this, go to [Developer Tools > YAML](https://my.home-assistant.io/redirect/server_controls) and scroll down to the YAML configuration reloading section (alternatively, hit “c” anywhere in the UI and search for it).

If you can’t see your integration listed there, you will need to restart Home Assistant for changes to take effect.

To test any changes to your configuration files from the command line, check out the common tasks for [operating system](https://www.home-assistant.io/common-tasks/os/#configuration-check), [supervised](https://www.home-assistant.io/common-tasks/supervised/#configuration-check), [container](https://www.home-assistant.io/common-tasks/container/#configuration-check), [core](https://www.home-assistant.io/common-tasks/core/#configuration-check) for how to do that. Configuration changes can also be tested using the UI by navigating to [Developer Tools > YAML](https://my.home-assistant.io/redirect/server_controls) and clicking “Check Configuration”. For the button to be visible, you must enable “Advanced Mode” on your [User Profile](https://my.home-assistant.io/redirect/profile).

##  Migrating to a new system

The preferred way of migrating to a new system is by [making a backup](https://my.home-assistant.io/redirect/supervisor_backups).

If you run the container or core installation methods, you will need  to manually make a backup of your configuration folder. Be aware that  some of the files you need start with `.`, which is hidden by default from both `ls` (in SSH), in Windows Explorer, and macOS Finder. You’ll need to ensure that you’re viewing all files before you copy them.

#### [ **Help us to improve our documentation**](https://www.home-assistant.io/docs/configuration/#feedback_section)

Suggest an edit to this page, or provide/view feedback for this page.

[ Edit](https://github.com/home-assistant/home-assistant.github.io/tree/current/source/_docs/configuration.markdown) [ Provide feedback](https://github.com/home-assistant/home-assistant.github.io/issues/new?template=feedback.yml&url=https%3A%2F%2Fwww.home-assistant.io%2Fdocs%2Fconfiguration%2F&version=2023.1.7&labels=current) [ View given feedback](https://github.com/home-assistant/home-assistant.github.io/issues?utf8=✓&q="%2Fdocs%2Fconfiguration%2F"&in=body)

# Topics

- **[FAQ ](https://www.home-assistant.io/faq/)** | **[Glossary ](https://www.home-assistant.io/docs/glossary/)**
- [Getting Started ](https://www.home-assistant.io/getting-started)
  - [Installation ](https://www.home-assistant.io/installation)
  - [Common Tasks ](https://www.home-assistant.io/common-tasks/os/)
  - [Troubleshooting ](https://www.home-assistant.io/docs/troubleshooting/)
- [Configuration.yaml ](https://www.home-assistant.io/docs/configuration/)
  - [YAML ](https://www.home-assistant.io/docs/configuration/yaml/)
  - [Basic information ](https://www.home-assistant.io/docs/configuration/basic/)
  - [Customizing entities ](https://www.home-assistant.io/docs/configuration/customizing-devices/)
  - [Troubleshooting ](https://www.home-assistant.io/docs/configuration/troubleshooting/)
  - [Security Check Points ](https://www.home-assistant.io/docs/configuration/securing/)
- Home Energy Management
  - [Introduction ](https://www.home-assistant.io/docs/energy/)
  - [Electricity Grid ](https://www.home-assistant.io/docs/energy/electricity-grid/)
  - [Solar Panels ](https://www.home-assistant.io/docs/energy/solar-panels/)
  - [Individual Devices ](https://www.home-assistant.io/docs/energy/individual-devices/)
  - [FAQ ](https://www.home-assistant.io/docs/energy/faq/)
- Advanced Configuration
  - [Remote access ](https://www.home-assistant.io/docs/configuration/remote/)
  - [Splitting up the configuration ](https://www.home-assistant.io/docs/configuration/splitting_configuration/)
  - [Packages ](https://www.home-assistant.io/docs/configuration/packages/)
  - [Storing Secrets ](https://www.home-assistant.io/docs/configuration/secrets/)
  - [Templating ](https://www.home-assistant.io/docs/configuration/templating/)
  - [Entity component platform options ](https://www.home-assistant.io/docs/configuration/platform_options/)
- [Authentication ](https://www.home-assistant.io/docs/authentication/)
  - [Auth Providers ](https://www.home-assistant.io/docs/authentication/providers/)
  - [Multi Factor Auth ](https://www.home-assistant.io/docs/authentication/multi-factor-auth/)
- Core objects
  - [Events ](https://www.home-assistant.io/docs/configuration/events/)
  - [State Objects ](https://www.home-assistant.io/docs/configuration/state_object/)
- [Automation ](https://www.home-assistant.io/docs/automation/)
  - [Using Automation Blueprints ](https://www.home-assistant.io/docs/automation/using_blueprints/)
  - [Automation Basics ](https://www.home-assistant.io/docs/automation/basics/)
  - [Editor ](https://www.home-assistant.io/docs/automation/editor/)
  - [Triggers ](https://www.home-assistant.io/docs/automation/trigger/)
  - [Conditions ](https://www.home-assistant.io/docs/automation/condition/)
  - [Actions ](https://www.home-assistant.io/docs/automation/action/)
  - [Run Modes ](https://www.home-assistant.io/docs/automation/modes/)
  - [Services ](https://www.home-assistant.io/docs/automation/services/)
  - [Templates ](https://www.home-assistant.io/docs/automation/templating/)
  - [YAML ](https://www.home-assistant.io/docs/automation/yaml/)
  - [Troubleshooting ](https://www.home-assistant.io/docs/automation/troubleshooting/)
- [Blueprints ](https://www.home-assistant.io/docs/blueprint/)
  - [Tutorial ](https://www.home-assistant.io/docs/blueprint/tutorial/)
  - [Schema ](https://www.home-assistant.io/docs/blueprint/schema/)
  - [Selectors ](https://www.home-assistant.io/docs/blueprint/selectors/)
- [Frontend ](https://www.home-assistant.io/docs/frontend/)
  - [Browser Compatibility List ](https://www.home-assistant.io/docs/frontend/browsers/)
  - [Dashboards ](https://www.home-assistant.io/dashboards)
  - [Icons](https://www.home-assistant.io/docs/frontend/icons/)
- [Backend ](https://www.home-assistant.io/docs/backend/)
  - [Database ](https://www.home-assistant.io/docs/backend/database/)
- [Scripts ](https://www.home-assistant.io/docs/scripts/)
  - [Service Calls ](https://www.home-assistant.io/docs/scripts/service-calls/)
  - [Conditions ](https://www.home-assistant.io/docs/scripts/conditions/)
- [Scenes ](https://www.home-assistant.io/docs/scene/)
  - [Editor ](https://www.home-assistant.io/docs/scene/editor/)
- [Tools and Helpers ](https://www.home-assistant.io/docs/tools/)
  - [Developer Tools ](https://www.home-assistant.io/docs/tools/dev-tools/)
  - [Quick Bar ](https://www.home-assistant.io/docs/tools/quick-bar/)
  - [hass ](https://www.home-assistant.io/docs/tools/hass/)
  - [check_config ](https://www.home-assistant.io/docs/tools/check_config/)
- [MQTT ](https://www.home-assistant.io/integrations/mqtt)
  - [Broker ](https://www.home-assistant.io/integrations/mqtt/#broker-configuration)
  - [Certificate ](https://www.home-assistant.io/integrations/mqtt/#advanced-broker-configuration)
  - [Discovery ](https://www.home-assistant.io/integrations/mqtt/#mqtt-discovery)
  - [Publish service ](https://www.home-assistant.io/integrations/mqtt/#publish--dump-services)
  - [Birth and last will messages ](https://www.home-assistant.io/integrations/mqtt/#birth-and-last-will-messages)
  - [Testing your setup ](https://www.home-assistant.io/integrations/mqtt/#testing-your-setup)
  - 

# MQTT

------

MQTT (aka MQ Telemetry Transport) is a machine-to-machine or  “Internet of Things” connectivity protocol on top of TCP/IP. It allows  extremely lightweight publish/subscribe messaging transport.

##  Configuration

Adding MQTT to your Home Assistant instance can be done via the user interface, by using this My button:

[![img](https://my.home-assistant.io/badges/config_flow_start.svg)](https://my.home-assistant.io/redirect/config_flow_start?domain=mqtt)





Your first step to get MQTT and Home Assistant working is to choose a broker.

##  Choose a MQTT broker

###  Run your own

The most private option is running your own MQTT broker.

The recommended setup method is to use the [Mosquitto MQTT broker add-on](https://github.com/home-assistant/hassio-addons/blob/master/mosquitto/DOCS.md).

Neither ActiveMQ MQTT broker nor the RabbitMQ MQTT Plugin are supported, use a known working broker like Mosquitto instead. There are [at least two](https://issues.apache.org/jira/browse/AMQ-6360) [issues](https://issues.apache.org/jira/browse/AMQ-6575) with the ActiveMQ MQTT broker which break MQTT message retention.

###  Use a public broker

The Mosquitto project runs a [public broker](https://test.mosquitto.org). This is the easiest to set up, but there is no privacy as all messages  are public. Use this only for testing purposes and not for real tracking of your devices or controlling your home. To use the public mosquitto  broker, configure the MQTT integration to connect to broker `test.mosquitto.org` on port 1883 or 8883.

##  Broker configuration

MQTT broker settings are configured when the MQTT integration is first set up and can be changed later if needed.

Add the MQTT integration, then provide your broker’s hostname (or IP  address) and port and (if required) the username and password that Home  Assistant should use. To change the settings later, click on “Configure” on the integration page in the UI, then “Re-configure MQTT”.

If you experience an error message like `Failed to connect due to exception: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed`, then turn on `Advanced options` and set [Broker certificate validation](https://www.home-assistant.io/integrations/mqtt/#broker-certificate-validation) to `Auto`.

###  Advanced broker configuration

Advanced broker configuration options include setting a custom client ID, setting a client certificate and key for authentication and  enabling TLS validation of the brokers certificate for. To access the  advanced settings, open the MQTT broker settings, switch on `Advanced options` and click `Next`. The advanced options will be shown by default if there are advanced settings active already.

####  Alternative client ID

You can set a custom MQTT client ID, this can help when debugging.  Mind that the client ID must be unique. Leave this settings default if  you want Home Assistant to generate a unique ID.

####  Keep alive

The time in seconds between sending keep alive messages for this  client. The default is 60 seconds. The keep alive setting should be  minimal 15 seconds.

####  Broker certificate validation

To enable a secure the broker certificate should be validated. If your broker uses a trusted certificate then choose `Auto`. This will allow validation against certifite CAs bundled certificates. If a self-signed certificate is used, select `Custom`. A custom PEM encoded CA-certificate can be uploaded. Click `NEXT` to show the control to upload the CA certificate. If the server certificate does not match the hostname then validation  will fail. To allow a connection without the verification of the  hostname, turn the `Ignore broker certificate validation` switch on.

####  MQTT Protocol

The MQTT protocol setting defaults to version `3.1.1`. If your MQTT broker supports MQTT version 5 you can set the protocol setting to `5`.

####  Securing the the connection

With a secure broker connection it is possible to use a client  certificate for authentication. To set the client certificate and  private key turn on the option `Use a client certificate` and click “Next” to show the controls to upload the files. Only a PEM  encoded client certificates together with a PEM encoded private key can  be uploaded. Make sure the private key has no password set.

####  Using WebSockets as transport

You can select `websockets` as transport method if your MQTT broker supports it. When you select `websockets` and click `NEXT` you will be able to add a WebSockets path (default = `/` and WebSockets headers (optional). The target WebSockets URI: `ws://{broker}:{port}{WebSockets path}` is built with `broker`, `port` and `ws_path` (WebSocket path) settings. To configure the WebSocketS headers supply a valid JSON dictionary string. E.g. `{ "Authorization": "token" , "x-header": "some header"}`. The default transport method is `tcp`. The WebSockets transport can be secured using TLS and optionally using user credentials or a client certificate.

A configured client certificate will only be active if broker certificate validation is enabled.

##  Configure MQTT options

To change the settings, click on “Configure” in the integration page in the UI, then “Re-configure MQTT”. Click `NEXT` to open the MQTT options page.

###  Discovery options

MQTT discovery is enabled by default. Discovery can be turned off. The prefix for the discovery topic (default `homeassistant`) can be changed here as well. See also [MQTT Discovery section](https://www.home-assistant.io/integrations/mqtt/#mqtt-discovery)

###  Birth and last will messages

Home Assistant’s MQTT integration supports so-called Birth and Last  Will and Testament (LWT) messages. The former is used to send a message  after the service has started, and the latter is used to notify other  clients about a disconnected client. Please note that the LWT message  will be sent both in case of a clean (e.g. Home Assistant shutting down) and in case of an unclean (e.g. Home Assistant crashing or losing its  network connection) disconnect.

By default, Home Assistant sends `online` and `offline` to `homeassistant/status`.

MQTT Birth and Last Will messages can be customized or disabled from  the UI. To do this, click on “Configure” in the integration page in the  UI, then “Re-configure MQTT” and then “Next”.

##  Testing your setup

The `mosquitto` broker package ships commandline tools (often as `*-clients` package) to send and receive MQTT messages. For sending test messages to a broker running on `localhost` check the example below:

```bash
mosquitto_pub -h 127.0.0.1 -t home-assistant/switch/1/on -m "Switch is ON"
```

Bash

Another way to send MQTT messages manually is to use the “MQTT” integration in  the frontend. Choose “Settings” on the left menu, click “Devices &  Services”, and choose “Configure” in the “Mosquitto broker” tile. Enter  something similar to the example below into the “topic” field under  “Publish a packet” and press “PUBLISH” .

```bash
home-assistant/switch/1/power
```

Bash

and in the Payload field

```bash
ON
```

Bash

In the “Listen to a topic” field, type `#` to see everything, or “home-assistant/switch/#” to just follow a  published topic, then press “START LISTENING”. The messages should  appear similar to the text below:

```bash
Message 23 received on home-assistant/switch/1/power/stat/POWER at 12:16 PM:
ON
QoS: 0 - Retain: false
Message 22 received on home-assistant/switch/1/power/stat/RESULT at 12:16 PM:
{
    "POWER": "ON"
}
QoS: 0 - Retain: false
```

Bash

For reading all messages sent on the topic `home-assistant` to a broker running on localhost:

```bash
mosquitto_sub -h 127.0.0.1 -v -t "home-assistant/#"
```

Bash

##  MQTT Discovery

The discovery of MQTT devices will enable one to use MQTT devices  with only minimal configuration effort on the side of Home Assistant.  The configuration is done on the device itself and the topic used by the device. Similar to the [HTTP binary sensor](https://www.home-assistant.io/integrations/http/#binary-sensor) and the [HTTP sensor](https://www.home-assistant.io/integrations/http/#sensor). To prevent multiple identical entries if a device reconnects, a unique  identifier is necessary. Two parts are required on the device side: The  configuration topic which contains the necessary device type and unique  identifier, and the remaining device configuration without the device  type.





MQTT discovery is enabled by default, but can be disabled. The prefix for the discovery topic (default `homeassistant`) can be changed. See the [MQTT Options sections](https://www.home-assistant.io/integrations/mqtt/#configure-mqtt-options)

###  Discovery messages

####  Discovery topic

The discovery topic needs to follow a specific format:

```text
<discovery_prefix>/<component>/[<node_id>/]<object_id>/config
```

Text

- `<component>`: One of the supported MQTT components, eg. `binary_sensor`.
- `<node_id>` (*Optional*): ID of the node  providing the topic, this is not used by Home Assistant but may be used  to structure the MQTT topic. The ID of the node must only consist of  characters from the character class `[a-zA-Z0-9_-]` (alphanumerics, underscore and hyphen).
- `<object_id>`: The ID of the device. This is only to allow for separate topics for each device and is not used for the `entity_id`. The ID of the device must only consist of characters from the character class `[a-zA-Z0-9_-]` (alphanumerics, underscore and hyphen).

The `<node_id>` level can be used by clients to only subscribe to their own (command) topics by using one wildcard topic like `<discovery_prefix>/+/<node_id>/+/set`.

Best practice for entities with a `unique_id` is to set `<object_id>` to `unique_id` and omit the `<node_id>`.

####  Discovery payload

The payload must be a serialized JSON dictionary and will be checked like an entry in your `configuration.yaml` file if a new device is added, with the exception that unknown  configuration keys are allowed but ignored. This means that missing  variables will be filled with the component’s default values. All  configuration variables which are *required* must be present in  the payload. The reason for allowing unknown documentation keys is allow some backwards compatibility, software generating MQTT discovery  messages can then be used with older Home Assistant versions which will  simply ignore new features.

Subsequent messages on a topic where a valid payload has been  received will be handled as a configuration update, and a configuration  update with an empty payload will cause a previously discovered device  to be deleted.

A base topic `~` may be defined in the payload to conserve memory when the same topic base is used multiple times. In the value of configuration variables ending with `_topic`, `~` will be replaced with the base topic, if the `~` occurs at the beginning or end of the value.

Configuration variable names in the discovery payload may be  abbreviated to conserve memory when sending a discovery message from  memory constrained devices.









###  Support by third-party tools

The following software has built-in support for MQTT discovery:

- [ArduinoHA](https://github.com/dawidchyrzynski/arduino-home-assistant)
- [Arilux AL-LC0X LED controllers](https://github.com/smrtnt/Arilux_AL-LC0X)
- [ebusd](https://github.com/john30/ebusd)
- [ecowitt2mqtt](https://github.com/bachya/ecowitt2mqtt)
- [ESPHome](https://esphome.io)
- [ESPurna](https://github.com/xoseperez/espurna)
- [HASS.Agent](https://github.com/LAB02-Research/HASS.Agent)
- [IOTLink](https://iotlink.gitlab.io) (starting with 2.0.0)
- [MiFlora MQTT Daemon](https://github.com/ThomDietrich/miflora-mqtt-daemon)
- [OpenMQTTGateway](https://github.com/1technophile/OpenMQTTGateway)
- [room-assistant](https://github.com/mKeRix/room-assistant) (starting with 1.1.0)
- [SmartHome](https://github.com/roncoa/SmartHome)
- [SpeedTest-CLI MQTT](https://github.com/adorobis/speedtest-CLI2mqtt)
- [Tasmota](https://github.com/arendst/Tasmota) (starting with 5.11.1e, development halted)
- [Teleinfo MQTT](https://fmartinou.github.io/teleinfo2mqtt) (starting with 3.0.0)
- [Tydom2MQTT](https://fmartinou.github.io/tydom2mqtt/)
- [What’s up Docker?](https://fmartinou.github.io/whats-up-docker/) (starting with 3.5.0)
- [WyzeSense2MQTT](https://github.com/raetha/wyzesense2mqtt)
- [Xiaomi DaFang Hacks](https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks)
- [Zehnder Comfoair RS232 MQTT](https://github.com/adorobis/hacomfoairmqtt)
- [Zigbee2mqtt](https://github.com/koenkk/zigbee2mqtt)
- [Zwave2Mqtt](https://github.com/OpenZWave/Zwave2Mqtt) (starting with 2.0.1)

###  Discovery examples

####  Motion detection (binary sensor)

A motion detection device which can be represented by a [binary sensor](https://www.home-assistant.io/integrations/binary_sensor.mqtt/) for your garden would send its configuration as JSON payload to the Configuration topic. After the first message to `config`, then the MQTT messages sent to the state topic will update the state in Home Assistant.

- Configuration topic: `homeassistant/binary_sensor/garden/config`
- State topic: `homeassistant/binary_sensor/garden/state`
- Payload: `{"name": "garden", "device_class": "motion", "state_topic": "homeassistant/binary_sensor/garden/state"}`
- Retain: The -r switch is added to retain the configuration topic in  the broker. Without this, the sensor will not be available after Home  Assistant restarts.

To create a new sensor manually.

```bash
mosquitto_pub -r -h 127.0.0.1 -p 1883 -t "homeassistant/binary_sensor/garden/config" -m '{"name": "garden", "device_class": "motion", "state_topic": "homeassistant/binary_sensor/garden/state"}'
```

Bash

Update the state.

```bash
mosquitto_pub -h 127.0.0.1 -p 1883 -t "homeassistant/binary_sensor/garden/state" -m ON
```

Bash

Delete the sensor by sending an empty message.

```bash
mosquitto_pub -h 127.0.0.1 -p 1883 -t "homeassistant/binary_sensor/garden/config" -m ''
```

Bash

For more details please refer to the [MQTT testing section](https://www.home-assistant.io/integrations/mqtt/#testing-your-setup).

####  Sensors

Setting up a sensor with multiple measurement values requires multiple consecutive configuration topic submissions.

- Configuration topic no1: `homeassistant/sensor/sensorBedroomT/config`
- Configuration payload no1: `{"device_class": "temperature",  "name": "Temperature", "state_topic":  "homeassistant/sensor/sensorBedroom/state", "unit_of_measurement": "°C", "value_template": "{{ value_json.temperature}}" }`
- Configuration topic no2: `homeassistant/sensor/sensorBedroomH/config`
- Configuration payload no2: `{"device_class": "humidity",  "name": "Humidity", "state_topic":  "homeassistant/sensor/sensorBedroom/state", "unit_of_measurement": "%",  "value_template": "{{ value_json.humidity}}" }`
- Common state payload: `{ "temperature": 23.20, "humidity": 43.70 }`

####  Entities with command topics

Setting up a light, switch etc. is similar but requires a `command_topic` as mentioned in the [MQTT switch documentation](https://www.home-assistant.io/integrations/switch.mqtt/).

- Configuration topic: `homeassistant/switch/irrigation/config`
- State topic: `homeassistant/switch/irrigation/state`
- Command topic: `homeassistant/switch/irrigation/set`
- Payload: `{"name": "garden", "command_topic":  "homeassistant/switch/irrigation/set", "state_topic":  "homeassistant/switch/irrigation/state"}`
- Retain: The -r switch is added to retain the configuration topic in  the broker. Without this, the sensor will not be available after Home  Assistant restarts.

```bash
mosquitto_pub -r -h 127.0.0.1 -p 1883 -t "homeassistant/switch/irrigation/config" \
  -m '{"name": "garden", "command_topic": "homeassistant/switch/irrigation/set", "state_topic": "homeassistant/switch/irrigation/state"}'
```

Bash

Set the state.

```bash
mosquitto_pub -h 127.0.0.1 -p 1883 -t "homeassistant/switch/irrigation/set" -m ON
```

Bash

####  Using abbreviations and base topic

Setting up a switch using topic prefix and abbreviated configuration variable names to reduce payload length.

- Configuration topic: `homeassistant/switch/irrigation/config`
- Command topic: `homeassistant/switch/irrigation/set`
- State topic: `homeassistant/switch/irrigation/state`
- Configuration payload: `{"~": "homeassistant/switch/irrigation", "name": "garden", "cmd_t": "~/set", "stat_t": "~/state"}`

####  Another example using abbreviations topic name and base topic

Setting up a [light that takes JSON payloads](https://www.home-assistant.io/integrations/light.mqtt/#json-schema), with abbreviated configuration variable names:

- Configuration topic: `homeassistant/light/kitchen/config`

- Command topic: `homeassistant/light/kitchen/set`

- State topic: `homeassistant/light/kitchen/state`

- Example state payload: `{"state": "ON", "brightness": 255}`

- Configuration payload:

  ```json
  {
    "~": "homeassistant/light/kitchen",
    "name": "Kitchen",
    "unique_id": "kitchen_light",
    "cmd_t": "~/set",
    "stat_t": "~/state",
    "schema": "json",
    "brightness": true
  }
  ```

  JSON

####  Use object_id to influence the entity id

The entity id is automatically generated from the entity’s name. All MQTT components optionally support providing an `object_id` which will be used instead if provided.

- Configuration topic: `homeassistant/sensor/device1/config`
- Example configuration payload:

```json
{
  "name":"My Super Device",
  "object_id":"my_super_device",
  "state_topic": "homeassistant/sensor/device1/state"
 }
```

JSON

In the example above, the entity_id will be `sensor.my_super_device` instead of `sensor.device1`.

##  Manual configured MQTT items

For most components it is also possible to manual set up MQTT items in `configuration.yaml`. Read more [about configuration in YAML](https://www.home-assistant.io/docs/configuration/yaml).





If you have a lot of manual configured items you might want to consider [splitting up the configuration](https://www.home-assistant.io/docs/configuration/splitting_configuration/).

##  Using Templates

The MQTT integration supports templating. Read more [about using templates with the MQTT integration](https://www.home-assistant.io/docs/configuration/templating/#using-templates-with-the-mqtt-integration).

##  MQTT Notifications

The MQTT notification support is different than for the other [notification](https://www.home-assistant.io/integrations/notify/) components. It is a service. This means you need to provide more details when calling the service.

**Call Service** section from **Developer Tools** -> **Services** allows you to send MQTT messages. Choose *mqtt.publish* from the list of **Available services:** and enter something like the sample below into the **Service Data** field and hit **CALL SERVICE**.

```json
{"payload": "Test message from HA", "topic": "home/notification", "qos": 0, "retain": 0}
```

JSON

![img](https://www.home-assistant.io/images/screenshots/mqtt-notify.png)

The same will work for automations.

![img](https://www.home-assistant.io/images/screenshots/mqtt-notify-action.png)

###  Examples

####  REST API

Using the [REST API](https://developers.home-assistant.io/docs/api/rest/) to send a message to a given topic.

```bash
$ curl -X POST \
    -H "Authorization: Bearer ABCDEFGH" \
    -H "Content-Type: application/json" \
    -d '{"payload": "Test message from HA", "topic": "home/notification"}' \
    http://IP_ADDRESS:8123/api/services/mqtt/publish
```

Bash

####  Automations

Use as [`script`](https://www.home-assistant.io/integrations/script/) in automations.

```yaml
automation:
  alias: "Send me a message when I get home"
  trigger:
    platform: state
    entity_id: device_tracker.me
    to: "home"
  action:
    service: script.notify_mqtt
    data:
      target: "me"
      message: "I'm home"

script:
  notify_mqtt:
    sequence:
      - service: mqtt.publish
        data:
          payload: "{{ message }}"
          topic: home/"{{ target }}"
          retain: true
```

YAML

##  Publish & Dump services

The MQTT integration will register the service `mqtt.publish` which allows publishing messages to MQTT topics. There are two ways of specifying your payload. You can either use `payload` to hard-code a payload or use `payload_template` to specify a [template](https://www.home-assistant.io/topics/templating/) that will be rendered to generate the payload.

###  Service mqtt.publish

| Service data attribute | Optional | Description                                                  |
| ---------------------- | -------- | ------------------------------------------------------------ |
| `topic`                | no       | Topic to publish payload to.                                 |
| `topic_template`       | no       | Template to render as topic to publish payload to.           |
| `payload`              | yes      | Payload to publish.                                          |
| `payload_template`     | yes      | Template to render as payload value.                         |
| `qos`                  | yes      | Quality of Service to use. (default: 0)                      |
| `retain`               | yes      | If message should have the retain flag set. (default: false) |

You must include either `topic` or `topic_template`, but not both. If  providing a payload, you need to include either `payload` or  `payload_template`, but not both.

```yaml
topic: home-assistant/light/1/command
payload: on
```

YAML

```yaml
topic: home-assistant/light/1/state
payload_template: "{{ states('device_tracker.paulus') }}"
```

YAML

```yaml
topic_template: "home-assistant/light/{{ states('sensor.light_active') }}/state"
payload_template: "{{ states('device_tracker.paulus') }}"
```

YAML

`payload` must be a string. If you want to send JSON using the YAML editor then you need to format/escape it properly. Like:

```yaml
topic: home-assistant/light/1/state
payload: "{\"Status\":\"off\", \"Data\":\"something\"}"`
```

YAML

When using Home Assistant’s YAML editor for formatting JSON you should take special care if `payload` contains template content. Home Assistant will force you in to the YAML editor and will treat your definition as a template. Make sure you escape the template blocks as like in the example below. Home Assistant will convert the result to a string and will pass it to the MQTT publish service.

```yaml
service: mqtt.publish
data:
  topic: homeassistant/sensor/Acurite-986-1R-51778/config
  payload: >-
    {"device_class": "temperature",
    "name": "Acurite-986-1R-51778-T",
    "unit_of_measurement": "\u00b0C",
    "value_template": "{% raw %}{{ value|float }}{% endraw %}",
    "state_topic": "rtl_433/rtl433/devices/Acurite-986/1R/51778/temperature_C",
    "unique_id": "Acurite-986-1R-51778-T",
    "device": {
    "identifiers": "Acurite-986-1R-51778",
    "name": "Acurite-986-1R-51778",
    "model": "Acurite-986",
    "manufacturer": "rtl_433" }
    }
```

YAML

Example of how to use `qos` and `retain`:

```yaml
topic: home-assistant/light/1/command
payload: on
qos: 2
retain: true
```

YAML

###  Service mqtt.dump

Listen to the specified topic matcher and dumps all received messages within a specific duration into the file `mqtt_dump.txt` in your configuration folder. This is useful when debugging a problem.

| Service data attribute | Optional | Description                                                  |
| ---------------------- | -------- | ------------------------------------------------------------ |
| `topic`                | no       | Topic to dump. Can contain a wildcard (`#` or `+`).          |
| `duration`             | yes      | Duration in seconds that we will listen for messages. Default is 5 seconds. |

```yaml
topic: openzwave/#
```

YAML

##  Logging

The [logger](https://www.home-assistant.io/integrations/logger/) integration allows the logging of received MQTT messages.

```yaml
# Example configuration.yaml entry
logger:
  default: warning
  logs:
    homeassistant.components.mqtt: debug
```

YAML

##  Event event_mqtt_reloaded

Event `event_mqtt_reloaded` is fired when Manually configured MQTT entities have been reloaded and entities thus might have changed.

This event has no additional data.

# Dashboards

------

Home Assistant dashboards are a fast, customizable and powerful way  for users to manage their home using their mobiles and desktops.

- 29 different cards to place and configure as you like.
- Dashboard Editor: Allows you to manage your dashboard by including a live preview when editing cards.
- Fast: Using a static configuration allows us to build up the dashboard once.
- Customizable:
  - Cards have a number of options which help to configure your data as required.
  - Themes (even at a per card basis).
  - Ability to override names and icons of entities.
  - Custom Cards from our amazing community are fully supported.

To start, go to the Home Assistant Overview page, click on the three  dots at the top right of the screen and select ‘Edit Dashboard’. Then  click on the blue ‘+ Add Card’ icon at the bottom right and select a  card to add.



To try it yourself, check out [the demo](https://demo.home-assistant.io).

##  Discuss dashboard

- Suggestions are welcome in the [frontend repository](https://github.com/home-assistant/frontend/)
- For help with dashboards, join the `#frontend` channel on [our chat](https://www.home-assistant.io/join-chat/) or [our forums](https://community.home-assistant.io/c/projects/frontend)

##  Additional Resources

- [Community Custom Cards](https://github.com/custom-cards)
- [Home Assistant Cards](https://home-assistant-cards.bessarabov.com/)
- [Material Design Icons](https://pictogrammers.com/library/mdi/)

# Script Syntax

------

Scripts are a sequence of actions that Home Assistant will execute. Scripts are available as an entity through the standalone [Script component](https://www.home-assistant.io/integrations/script/) but can also be embedded in [automations](https://www.home-assistant.io/getting-started/automation-action/) and [Alexa/Amazon Echo](https://www.home-assistant.io/integrations/alexa/) configurations.

When the script is executed within an automation the `trigger` variable is available. See [Available-Trigger-Data](https://www.home-assistant.io/docs/automation/templating/#available-trigger-data).

The script syntax basic structure is a list of key/value maps that  contain actions. If a script contains only 1 action, the wrapping list  can be omitted.

All actions support an optional `alias`.

```yaml
# Example script integration containing script syntax
script:
  example_script:
    sequence:
      # This is written using the Script Syntax
      - alias: "Turn on ceiling light"
        service: light.turn_on
        target:
          entity_id: light.ceiling
      - alias: "Notify that ceiling light is turned on"
        service: notify.notify
        data:
          message: "Turned on the ceiling light!"
```

YAML

- Call a Service
  - [Activate a Scene](https://www.home-assistant.io/docs/scripts/#activate-a-scene)
- Variables
  - [Scope of Variables](https://www.home-assistant.io/docs/scripts/#scope-of-variables)
- [Test a Condition](https://www.home-assistant.io/docs/scripts/#test-a-condition)
- [Wait for time to pass (delay)](https://www.home-assistant.io/docs/scripts/#wait-for-time-to-pass-delay)
- Wait
  - [Wait for a template](https://www.home-assistant.io/docs/scripts/#wait-for-a-template)
  - [Wait for a trigger](https://www.home-assistant.io/docs/scripts/#wait-for-a-trigger)
  - [Wait Timeout](https://www.home-assistant.io/docs/scripts/#wait-timeout)
  - [Wait Variable](https://www.home-assistant.io/docs/scripts/#wait-variable)
- Fire an Event
  - [Raise and Consume Custom Events](https://www.home-assistant.io/docs/scripts/#raise-and-consume-custom-events)
- Repeat a Group of Actions
  - [Counted Repeat](https://www.home-assistant.io/docs/scripts/#counted-repeat)
  - [For each](https://www.home-assistant.io/docs/scripts/#for-each)
  - [While Loop](https://www.home-assistant.io/docs/scripts/#while-loop)
  - [Repeat Until](https://www.home-assistant.io/docs/scripts/#repeat-until)
  - [Repeat Loop Variable](https://www.home-assistant.io/docs/scripts/#repeat-loop-variable)
- [If-then](https://www.home-assistant.io/docs/scripts/#if-then)
- [Choose a Group of Actions](https://www.home-assistant.io/docs/scripts/#choose-a-group-of-actions)
- [Parallelizing actions](https://www.home-assistant.io/docs/scripts/#parallelizing-actions)
- [Stopping a script sequence](https://www.home-assistant.io/docs/scripts/#stopping-a-script-sequence)
- [Continuing on error](https://www.home-assistant.io/docs/scripts/#continuing-on-error)
- [Disabling an action](https://www.home-assistant.io/docs/scripts/#disabling-an-action)

##  Call a Service

The most important one is the action to call a service. This can be  done in various ways. For all the different possibilities, have a look  at the [service calls page](https://www.home-assistant.io/getting-started/scripts-service-calls/).

```yaml
- alias: "Bedroom lights on"
  service: light.turn_on
  target:
    entity_id: group.bedroom
  data:
    brightness: 100
```

YAML

###  Activate a Scene

Scripts may also use a shortcut syntax for activating scenes instead of calling the `scene.turn_on` service.

```yaml
- scene: scene.morning_living_room
```

YAML

##  Variables

The variables action allows you to set/override variables that will be accessible by templates in actions after it. See also [script variables](https://www.home-assistant.io/integrations/script/#configuration-variables) for how to define variables accessible in the entire script.

```yaml
- alias: "Set variables"
  variables:
    entities:
      - light.kitchen
      - light.living_room
    brightness: 100
- alias: "Control lights"
  service: light.turn_on
  target:
    entity_id: "{{ entities }}"
  data:
    brightness: "{{ brightness }}"
```

YAML

Variables can be templated.

```yaml
- alias: "Set a templated variable"
  variables:
    blind_state_message: "The blind is {{ states('cover.blind') }}."
- alias: "Notify about the state of the blind"
  service: notify.mobile_app_iphone
  data:
    message: "{{ blind_state_message }}"
```

YAML

###  Scope of Variables

Variables have local scope. This means that if a variable is changed  in a nested sequence block, that change will not be visible in an outer  sequence block.

Inside the `if` sequence the `variables` action will only alter the `people` variable for that sequence.

```yaml
sequence:
  # Set the people variable to a default value
  - variables:
      people: 0
  # Try to increment people if Paulus is home
  - if:
      - condition: state
        entity_id: device_tracker.paulus
        state: "home"
    then:
      # At this scope and this point of the sequence, people == 0
      - variables:
          people: "{{ people + 1 }}"
      # At this scope, people will now be 1 ...
      - service: notify.notify
        data:
          message: "There are {{ people }} people home" # "There are 1 people home"
  # ... but at this scope it will still be 0
  - service: notify.notify
    data:
      message: "There are {{ people }} people home" # "There are 0 people home"
```

YAML

##  Test a Condition

While executing a script you can add a condition in the main sequence to stop further execution. When a condition does not return `true`, the script will stop executing. There are many different conditions which are documented at the [conditions page](https://www.home-assistant.io/getting-started/scripts-conditions/).

The `condition` action only stops executing the current sequence block. When it is used inside a [repeat](https://www.home-assistant.io/docs/scripts/#repeat-a-group-of-actions) action, only the current iteration of the `repeat` loop will stop. When it is used inside a [choose](https://www.home-assistant.io/docs/scripts/#choose-a-group-of-actions) action, only the actions within that `choose` will stop.

```yaml
# If paulus is home, continue to execute the script below these lines
- alias: "Check if Paulus is home"
  condition: state
  entity_id: device_tracker.paulus
  state: "home"
```

YAML

`condition` can also be a list of conditions and execution will then only continue if ALL conditions return `true`.

```yaml
- alias: "Check if Paulus ishome AND temperature is below 20"
  condition:
    - condition: state
      entity_id: "device_tracker.paulus"
      state: "home"
    - condition: numeric_state
      entity_id: "sensor.temperature"
      below: 20
```

YAML

##  Wait for time to pass (delay)

Delays are useful for temporarily suspending your script and start it at a later moment. We support different syntaxes for a delay as shown  below.

```yaml
# Seconds
# Waits 5 seconds
- alias: "Wait 5s"
  delay: 5
```

YAML

```yaml
# HH:MM
# Waits 1 hour
- delay: "01:00"
```

YAML

```yaml
# HH:MM:SS
# Waits 1.5 minutes
- delay: "00:01:30"
```

YAML

```yaml
# Supports milliseconds, seconds, minutes, hours, days
# Can be used in combination, at least one required
# Waits 1 minute
- delay:
    minutes: 1
```

YAML

All forms accept templates.

```yaml
# Waits however many minutes input_number.minute_delay is set to
- delay: "{{ states('input_number.minute_delay') | multiply(60) | int }}"
```

YAML

##  Wait

These actions allow a script to wait for entities in the system to be in a certain state as specified by a template, or some event to happen  as expressed by one or more triggers.

###  Wait for a template

This action evaluates the template, and if true, the script will continue. If not, then it will wait until it is true.

The template is re-evaluated whenever an entity ID that it references changes state. If you use non-deterministic functions like `now()` in the template it will not be continuously re-evaluated, but only when an entity ID that is referenced is changed. If you need to periodically re-evaluate the template, reference a sensor from the [Time and Date](https://www.home-assistant.io/integrations/time_date/) component that will update minutely or daily.

```yaml
# Wait until media player is stopped
- alias: "Wait until media player is stopped"
  wait_template: "{{ is_state('media_player.floor', 'stop') }}"
```

YAML

###  Wait for a trigger

This action can use the same triggers that are available in an automation’s `trigger` section. See [Automation Trigger](https://www.home-assistant.io/docs/automation/trigger). The script will continue whenever any of the triggers fires. All previously defined [trigger variables](https://www.home-assistant.io/docs/automation/trigger#trigger-variables), [variables](https://www.home-assistant.io/docs/scripts/#variables) and [script variables](https://www.home-assistant.io/integrations/script/#configuration-variables) are passed to the trigger.

```yaml
# Wait for a custom event or light to turn on and stay on for 10 sec
- alias: "Wait for MY_EVENT or light on"
  wait_for_trigger:
    - platform: event
      event_type: MY_EVENT
    - platform: state
      entity_id: light.LIGHT
      to: "on"
      for: 10
```

YAML

###  Wait Timeout

With both types of waits it is possible to set a timeout after which  the script will continue its execution if the condition/event is not  satisfied. Timeout has the same syntax as `delay`, and like `delay`, also accepts templates.

```yaml
# Wait for sensor to change to 'on' up to 1 minute before continuing to execute.
- wait_template: "{{ is_state('binary_sensor.entrance', 'on') }}"
  timeout: "00:01:00"
```

YAML

You can also get the script to abort after the timeout by using optional `continue_on_timeout: false`.

```yaml
# Wait for IFTTT event or abort after specified timeout.
- wait_for_trigger:
    - platform: event
      event_type: ifttt_webhook_received
      event_data:
        action: connected_to_network
  timeout:
    minutes: "{{ timeout_minutes }}"
  continue_on_timeout: false
```

YAML

Without `continue_on_timeout: false` the script will always continue since the default for `continue_on_timeout` is `true`.

###  Wait Variable

After each time a wait completes, either because the condition was  met, the event happened, or the timeout expired, the variable `wait` will be created/updated to indicate the result.

| Variable         | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| `wait.completed` | Exists only after `wait_template`. `true` if the condition was met, `false` otherwise |
| `wait.trigger`   | Exists only after `wait_for_trigger`. Contains information about which trigger fired. (See [Available-Trigger-Data](https://www.home-assistant.io/docs/automation/templating/#available-trigger-data).) Will be `none` if no trigger happened before timeout expired |
| `wait.remaining` | Timeout remaining, or `none` if a timeout was not specified  |

This can be used to take different actions based on whether or not  the condition was met, or to use more than one wait sequentially while  implementing a single timeout overall.

```yaml
# Take different actions depending on if condition was met.
- wait_template: "{{ is_state('binary_sensor.door', 'on') }}"
  timeout: 10
- if:
    - "{{ not wait.completed }}"
  then:
    - service: script.door_did_not_open
  else:
    - service: script.turn_on
      target:
        entity_id:
          - script.door_did_open
          - script.play_fanfare

# Wait a total of 10 seconds.
- wait_template: "{{ is_state('binary_sensor.door_1', 'on') }}"
  timeout: 10
  continue_on_timeout: false
- service: switch.turn_on
  target:
    entity_id: switch.some_light
- wait_for_trigger:
    - platform: state
      entity_id: binary_sensor.door_2
      to: "on"
      for: 2
  timeout: "{{ wait.remaining }}"
  continue_on_timeout: false
- service: switch.turn_off
  target:
    entity_id: switch.some_light
```

YAML

##  Fire an Event

This action allows you to fire an event. Events can be used for many  things. It could trigger an automation or indicate to another  integration that something is happening. For instance, in the below  example it is used to create an entry in the logbook.

```yaml
- alias: "Fire LOGBOOK_ENTRY event"
  event: LOGBOOK_ENTRY
  event_data:
    name: Paulus
    message: is waking up
    entity_id: device_tracker.paulus
    domain: light
```

YAML

You can also use event_data to fire an event with custom data. This could be used to pass data to another script awaiting an event trigger.

The `event_data` accepts templates.

```yaml
- event: MY_EVENT
  event_data:
    name: myEvent
    customData: "{{ myCustomVariable }}"
```

YAML

###  Raise and Consume Custom Events

The following automation example shows how to raise a custom event called `event_light_state_changed` with `entity_id` as the event data. The action part could be inside a script or an automation.

```yaml
- alias: "Fire Event"
  trigger:
    - platform: state
      entity_id: switch.kitchen
      to: "on"
  action:
    - event: event_light_state_changed
      event_data:
        state: "on"
```

YAML

The following automation example shows how to capture the custom event `event_light_state_changed` with an [Event Automation Trigger](https://www.home-assistant.io/docs/automation/trigger#event-trigger), and retrieve corresponding `entity_id` that was passed as the event trigger data, see [Available-Trigger-Data](https://www.home-assistant.io/docs/automation/templating/#available-trigger-data) for more details.

```yaml
- alias: "Capture Event"
  trigger:
    - platform: event
      event_type: event_light_state_changed
  action:
    - service: notify.notify
      data:
        message: "kitchen light is turned {{ trigger.event.data.state }}"
```

YAML

##  Repeat a Group of Actions

This action allows you to repeat a sequence of other actions. Nesting is fully supported. There are three ways to control how many times the sequence will be run.

###  Counted Repeat

This form accepts a count value. The value may be specified by a template, in which case the template is rendered when the repeat step is reached.

```yaml
script:
  flash_light:
    mode: restart
    sequence:
      - service: light.turn_on
        target:
          entity_id: "light.{{ light }}"
      - alias: "Cycle light 'count' times"
        repeat:
          count: "{{ count|int * 2 - 1 }}"
          sequence:
            - delay: 2
            - service: light.toggle
              target:
                entity_id: "light.{{ light }}"
  flash_hallway_light:
    sequence:
      - alias: "Flash hallway light 3 times"
        service: script.flash_light
        data:
          light: hallway
          count: 3
```

YAML

###  For each

This repeat form accepts a list of items to iterate over. The list of items can be a pre-defined list, or a list created by a template.

The sequence is ran for each item in the list, and current item in the iteration is available as `repeat.item`.

The following example will turn a list of lights:

```yaml
repeat:
  for_each:
    - "living_room"
    - "kitchen"
    - "office"
  sequence:
    - service: light.turn_off
      target:
        entity_id: "light.{{ repeat.item }}"
```

YAML

Other types are accepted as list items, for example, each item can be a template, or even an mapping of key/value pairs.

```yaml
repeat:
  for_each:
    - language: English
      message: Hello World
    - language: Dutch
      message: Hallo Wereld
  sequence:
    - service: notify.phone
      data:
        title: "Message in {{ repeat.item.language }}"
        message: "{{ repeat.item.message }}!"
```

YAML

###  While Loop

This form accepts a list of conditions (see [conditions page](https://www.home-assistant.io/getting-started/scripts-conditions/) for available options) that are evaluated *before* each time the sequence is run. The sequence will be run *as long as* the condition(s) evaluate to true.

```yaml
script:
  do_something:
    sequence:
      - service: script.get_ready_for_something
      - alias: "Repeat the sequence AS LONG AS the conditions are true"
        repeat:
          while:
            - condition: state
              entity_id: input_boolean.do_something
              state: "on"
            # Don't do it too many times
            - condition: template
              value_template: "{{ repeat.index <= 20 }}"
          sequence:
            - service: script.something
```

YAML

The `while` also accepts a [shorthand notation of a template condition](https://www.home-assistant.io/docs/scripts/conditions/#template-condition-shorthand-notation). For example:

```yaml
- repeat:
    while: "{{ is_state('sensor.mode', 'Home') and repeat.index < 10 }}"
    sequence:
    - ...
```

YAML

###  Repeat Until

This form accepts a list of conditions that are evaluated *after* each time the sequence is run. Therefore the sequence will always run at least once. The sequence will be run *until* the condition(s) evaluate to true.

```yaml
automation:
  - trigger:
      - platform: state
        entity_id: binary_sensor.xyz
        to: "on"
    condition:
      - condition: state
        entity_id: binary_sensor.something
        state: "off"
    mode: single
    action:
      - alias: "Repeat the sequence UNTIL the conditions are true"
        repeat:
          sequence:
            # Run command that for some reason doesn't always work
            - service: shell_command.turn_something_on
            # Give it time to complete
            - delay:
                milliseconds: 200
          until:
            # Did it work?
            - condition: state
              entity_id: binary_sensor.something
              state: "on"
```

YAML

`until` also accepts a [shorthand notation of a template condition](https://www.home-assistant.io/docs/scripts/conditions/#template-condition-shorthand-notation). For example:

```yaml
- repeat:
    until: "{{ is_state('device_tracker.iphone', 'home') }}"
    sequence:
    - ...
```

YAML

###  Repeat Loop Variable

A variable named `repeat` is defined within the repeat action (i.e., it is available inside `sequence`, `while` & `until`.) It contains the following fields:

| field   | description                                                  |
| ------- | ------------------------------------------------------------ |
| `first` | True during the first iteration of the repeat sequence       |
| `index` | The iteration number of the loop: 1, 2, 3, …                 |
| `last`  | True during the last iteration of the repeat sequence, which is only valid for counted loops |

##  If-then

This action allow you to conditionally (`if`) run a sequence of actions (`then`) and optionally supports running other sequence when the condition didn’t pass (`else`).

```yaml
script:
  - if:
      - alias: "If no one is home"
        condition: state
        entity_id: zone.home
        state: 0
    then:
      - alias: "Then start cleaning already!"
        service: vacuum.start
        target:
          area_id: living_room
    # The `else` is fully optional and can be omitted
    else:
      - service: notify.notify
        data:
          message: "Skipped cleaning, someone is home!"
```

YAML

This action supports nesting, however, if you find yourself using nested if-then actions in the `else` part, you may want to consider using [choose](https://www.home-assistant.io/docs/scripts/#choose-a-group-of-actions) instead.

##  Choose a Group of Actions

This action allows you to select a sequence of other actions from a list of sequences. Nesting is fully supported.

Each sequence is paired with a list of conditions. (See the [conditions page](https://www.home-assistant.io/getting-started/scripts-conditions/) for available options and how multiple conditions are handled.) The first sequence whose conditions are all true will be run. An *optional* `default` sequence can be included which will be run only if none of the sequences from the list are run.

An *optional* `alias` can be added to each of the sequences, excluding the `default` sequence.

The `choose` action can be used like an “if/then/elseif/then…/else” statement. The first `conditions`/`sequence` pair is like the “if/then”, and can be used just by itself. Or  additional pairs can be added, each of which is like an “elif/then”. And lastly, a `default` can be added, which would be like the “else.”

```yaml
# Example with "if", "elif" and "else"
automation:
  - trigger:
      - platform: state
        entity_id: input_boolean.simulate
        to: "on"
    mode: restart
    action:
      - choose:
          # IF morning
          - conditions:
              - condition: template
                value_template: "{{ now().hour < 9 }}"
            sequence:
              - service: script.sim_morning
          # ELIF day
          - conditions:
              - condition: template
                value_template: "{{ now().hour < 18 }}"
            sequence:
              - service: light.turn_off
                target:
                  entity_id: light.living_room
              - service: script.sim_day
        # ELSE night
        default:
          - service: light.turn_off
            target:
              entity_id: light.kitchen
          - delay:
              minutes: "{{ range(1, 11)|random }}"
          - service: light.turn_off
            target:
              entity_id: all
```

YAML

`conditions` also accepts a [shorthand notation of a template condition](https://www.home-assistant.io/docs/scripts/conditions/#template-condition-shorthand-notation). For example:

```yaml
automation:
  - trigger:
      - platform: state
        entity_id: input_select.home_mode
    action:
      - choose:
          - conditions: >
              {{ trigger.to_state.state == 'Home' and
                 is_state('binary_sensor.all_clear', 'on') }}
            sequence:
              - service: script.arrive_home
                data:
                  ok: true
          - conditions: >
              {{ trigger.to_state.state == 'Home' and
                 is_state('binary_sensor.all_clear', 'off') }}
            sequence:
              - service: script.turn_on
                target:
                  entity_id: script.flash_lights
              - service: script.arrive_home
                data:
                  ok: false
          - conditions: "{{ trigger.to_state.state == 'Away' }}"
            sequence:
              - service: script.left_home
```

YAML

More `choose` can be used together. This is the case of an IF-IF.

The following example shows how a single automation can control  entities that aren’t related to each other but have in common the same  trigger.

When the sun goes below the horizon, the `porch` and `garden` lights must turn on. If someone is watching the TV in the living room,  there is a high chance that someone is in that room, therefore the  living room lights have to turn on too. The same concept applies to the `studio` room.

```yaml
# Example with "if" and "if"
automation:
  - alias: "Turn lights on when the sun gets dim and if some room is occupied"
      trigger:
        - platform: numeric_state
          entity_id: sun.sun
          attribute: elevation
          below: 4
      action:
        # This must always apply
        - service: light.turn_on
          data:
            brightness: 255
            color_temp: 366
          target:
            entity_id:
              - light.porch
              - light.garden
        # IF a entity is ON
        - choose:
            - conditions:
                - condition: state
                  entity_id: binary_sensor.livingroom_tv
                  state: "on"
              sequence:
                - service: light.turn_on
                  data:
                    brightness: 255
                    color_temp: 366
                  target:
                    entity_id: light.livingroom
         # IF another entity not related to the previous, is ON
        - choose:
            - conditions:
                - condition: state
                  entity_id: binary_sensor.studio_pc
                  state: "on"
              sequence:
                - service: light.turn_on
                  data:
                    brightness: 255
                    color_temp: 366
                  target:
                    entity_id: light.studio
```

YAML

##  Parallelizing actions

By default, all sequences of actions in Home Assistant run sequentially. This means the next action is started after the current action has been completed.

This is not always needed, for example, if the sequence of actions doesn’t rely on each other and order doesn’t matter. For those cases, the `parallel` action can be used to run the actions in the sequence in parallel, meaning all the actions are started at the same time.

The following example shows sending messages out at the time (in parallel):

```yaml
automation:
  - trigger:
      - platform: state
        entity_id: binary_sensor.motion
        to: "on"
    action:
      - parallel:
          - service: notify.person1
            data:
              message: "These messages are sent at the same time!"
          - service: notify.person2
            data:
              message: "These messages are sent at the same time!"
```

YAML

It is also possible to run a group of actions sequantially inside the parallel actions. The example below demonstrates that:

```yaml
script:
  example_script:
    sequence:
      - parallel:
          - sequence:
              - wait_for_trigger:
                  - platform: state
                    entity_id: binary_sensor.motion
                    to: "on"
              - service: notify.person1
                data:
                  message: "This message awaited the motion trigger"
          - service: notify.person2
            data:
              message: "I am sent immediately and do not await the above action!"
```

YAML

Running actions in parallel can be helpful in many cases, but use it with caution and only if you need it.

There are some caveats (see below) when using parallel actions.

While it sounds attractive to parallelize, most of the time, just the regular sequential actions will work just fine.

Some of the caveats of running actions in parallel:

- There is no order guarantee. The actions will be started in parallel, but there is no guarantee that they will be completed in the same order.
- If one action fails or errors, the other actions will keep running until they too have finished or errored.
- Variables created/modified in one parallelized action are not available in another parallelized action. Each step in a parallelized has its own scope.

##  Stopping a script sequence

It is possible to halt a script sequence at any point. Using the `stop` action.

The `stop` action takes a text as input explaining the reason for halting the sequence. This text will be logged and shows up in the automations and script traces.

`stop` can be useful to halt a script halfway through a sequence when, for example, a condition is not met.

```yaml
- stop: "Stop running the rest of the sequence"
```

YAML

There is also an `error` option, to indicate we are stopping because of an unexpected error. It stops the sequence as well, but marks the automation or script as failed to run.

```yaml
- stop: "Well, that was unexpected!"
  error: true
```

YAML

##  Continuing on error

By default, a sequence of actions will be halted when one of the actions in that sequence encounters an error. The automation or script will be halted, an error is logged, and the automation or script run is marked as errored.

Sometimes these errors are expected, for example, because you know the service you call can be problematic at times, and it doesn’t matter if it fails. You can set `continue_on_error` for those cases on such an action.

The `continue_on_error` is available on all actions and is set to `false`. You can set it to `true` if you’d like to continue the action sequence, regardless of whether that action encounters an error.

The example below shows the `continue_on_error` set on the first action. If it encounters an error; it will continue to the next action.

```yaml
- alias: "If this one fails..."
  continue_on_error: true
  service: notify.super_unreliable_service_provider
  data:
    message: "I'm going to error out..."

- alias: "This one will still run!"
  service: persistent_notification.create
  data:
    title: "Hi there!"
    message: "I'm fine..."
```

YAML

Please note that `continue_on_error` will not suppress/ignore misconfiguration or errors that Home Assistant does not handle.

##  Disabling an action

Every individual action in a sequence can be disabled, without removing it. To do so, add `enabled: false` to the action. For example:

```yaml
# Example script with a disabled action
script:
  example_script:
    sequence:
      # This action will not run, as it is disabled.
      # The message will not be sent.
      - enabled: false
        alias: "Notify that ceiling light is being turned on"
        service: notify.notify
        data:
          message: "Turning on the ceiling light!"

      # This action will run, as it is not disabled
      - alias: "Turn on ceiling light"
        service: light.turn_on
        target:
          entity_id: light.ceiling
```

YAML

#### [ **Help us to improve our documentation**](https://www.home-assistant.io/docs/scripts/#feedback_section)

# Automating Home Assistant

------

Home Assistant contains information about all your devices and  services. This information is available for the user in the dashboard  and it can be used to trigger automations. And that’s fun!

Automations in Home Assistant allow you to automatically respond to  things that happen. You can turn the lights on at sunset or pause the  music when you receive a call.

If you are just starting out, we recommend that you start with  blueprint automations. These are ready-made automations by the community that you only need to configure.

### [Learn about automation blueprints »](https://www.home-assistant.io/docs/automation/using_blueprints/)

If you have got the hang of blueprints and would like to explore  more, it’s time for the next step. But before you start creating  automations, you will need to learn about the automation basics.

### [Learn about automation basics »](https://www.home-assistant.io/docs/automation/basics/)