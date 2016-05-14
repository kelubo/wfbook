PlatformIO is an open source ecosystem for IoT development

Cross-platform build system and library manager. Continuous and IDE integration. Arduino and MBED compatible. Ready for Cloud compiling.

PlatformIO IDE - The next-generation integrated development environment for IoT. C/C++ Intelligent Code Completion and Smart Code Linter for the super-fast coding. Multi-projects workflow with Multiple Panes. Themes Support with dark and light colors. Built-in Terminal with PlatformIO CLI tool and support for the powerful Serial Port Monitor. All advanced instruments without leaving your favourite development environment.
Development Platforms - Embedded and Desktop development platforms with pre-built toolchains, debuggers, uploaders and frameworks which work under popular host OS: Mac, Windows, Linux (+ARM)
Embedded Boards - Rapid Embedded Programming, IDE and Continuous Integration in a few steps with PlatformIO thanks to built-in project generator for the most popular embedded boards and IDE
Library Manager - Hundreds Popular Libraries are organized into single Web 2.0 platform: list by categories, keywords, authors, compatible platforms and frameworks; learn via examples; be up-to-date with the latest version
Atmel AVR & SAM, Espressif, Freescale Kinetis, Nordic nRF51, NXP LPC, Silicon Labs EFM32, ST STM32, TI MSP430 & Tiva, Teensy, Arduino, mbed, libOpenCM3, etc.

Website
PlatformIO IDE for Atom
Web 2.0 Library Search | Embedded Boards Explorer
Project Examples
Source Code | Issues
Blog | Twitter | Facebook | Hackaday | Forums
Embedded Development. Easier Than Ever.
Colourful command-line output
IDE Integration with Arduino, Atom, CLion, Eclipse, Emacs, Energia, Qt Creator, Sublime Text, Vim, Visual Studio
Cloud compiling and Continuous Integration with AppVeyor, Circle CI, Drone, Shippable, Travis CI
Built-in Serial Port Monitor and configurable build -flags/-options
Pre-built toolchains, Frameworks for the Development Platforms
Smart Build System. Fast and Reliable.
Reliable, automatic dependency analysis and detection of build changes
Improved support for parallel builds
Ability to share built files in a cache
Lookup for external libraries which are installed via Library Manager
The Missing Library Manager. It’s here!
Friendly Command-Line Interface
Modern Web 2.0 Library Search
Library dependency management
Automatic library updating
It runs on Windows, Mac OS X, and Linux (+ARM).
For further details, please refer to What is PlatformIO? How does it work?

Contents
What is PlatformIO?
Press about PlatformIO
Awards
Problematic
Overview
User SHOULD have a choice
How does it work?
Demo & Projects
Project Examples
“Blink Project”
Platform Manager
Library Manager
Over-the-Air update for ESP8266
Getting Started
Installation
System requirements
Installation Methods
Troubleshooting
Quick Start
Setting Up the Project
Board Identifier
Initialize Project
Process Project
Further Reading
User Guide
Usage
Options
Commands
Configuration
Project Configuration File platformio.ini
Section [platformio]
Section [env:NAME]
Examples
Environment variables
General
Building
Uploading
Settings
Instruments
Platforms & Boards
Embedded
Platform atmelavr
Platform atmelsam
Platform espressif
Platform freescalekinetis
Platform intel_arc32
Platform lattice_ice40
Platform microchippic32
Platform nordicnrf51
Platform nxplpc
Platform siliconlabsefm32
Platform ststm32
Platform teensy
Platform timsp430
Platform titiva
Desktop
Platform native
Platform linux_arm
Platform linux_i686
Platform linux_x86_64
Platform windows_x86
Custom Platform & Board
Custom Platform
Custom Board
Frameworks
Framework arduino
Platforms
Boards
Framework cmsis
Platforms
Boards
Articles
Examples
Framework energia
Platforms
Boards
Framework libopencm3
Platforms
Boards
Examples
Framework mbed
Platforms
Boards
Articles
Examples
Framework simba
Platforms
Boards
Examples
Framework spl
Platforms
Boards
Examples
Framework wiringpi
Platforms
Boards
Examples
Library Manager
Quickstart
User Guide
platformio lib install
platformio lib list
platformio lib register
platformio lib search
platformio lib show
platformio lib uninstall
platformio lib update
library.json
name
description
keywords
authors
repository
version
downloadUrl
url
include
exclude
frameworks
platforms
dependencies
examples
Creating Library
Source Code Location
Register
Examples
Integration
Continuous Integration
AppVeyor
Circle CI
Drone
Shippable
Travis CI
IDE Integration
PlatformIO IDE for Atom
CLion
CodeBlocks
Eclipse
Emacs
NetBeans
Qt Creator
Sublime Text
VIM
Visual Studio
Miscellaneous
Articles about us
2016
2015
2014
FAQ
General
PlatformIO IDE
Troubleshooting
Release Notes
PlatformIO 2.0
PlatformIO 1.0
PlatformIO 0.0

What is PlatformIO?
Contents

What is PlatformIO?
Press about PlatformIO
Awards
Problematic
Overview
User SHOULD have a choice
How does it work?
Press about PlatformIO
“Different microcontrollers normally have different developing tools . For instance Arduino rely on Arduino IDE. Few more advanced users set up different graphical interfaces like Eclipse for better project management. Sometimes it may be hard to keep up with different microcontrollers and tools. You probably thought that single unified development tool could be great. Well this is what PlatformIO open source ecosystem is for.

This is cross platform code builder and library manager with platforms like Arduino or MBED support. They took care of toolchains, debuggers, frameworks that work on most popular platforms like Windows, Mac and Linux. It supports more than 200 development boards along with more than 15 development platforms and 10 frameworks. So most of popular boards are covered. They’ve done hard work in organizing and managing hundreds of libraries that can be included in to your project. Also lots of examples allow you to start developing quickly. PlatformIO initially was developed with Command line philosophy. It’s been successfully used with other IDE’s like Eclipse or Visual Studio. Recently they’ve released a version with built in IDE based on Atom text editor”, - [Embedds].

Awards
PlatformIO was nominated for the year’s best Software and Tools in the 2015/16 IoT Awards.

Problematic
The main problem which repulses people from embedded world is a complicated process to setup development software for a specific MCU/board: toolchains, proprietary vendor’s IDE (which sometimes isn’t free) and what is more, to get a computer with OS where that software is supported.
Multiple hardware platforms (MCUs, boards) require different toolchains, IDEs, etc, and, respectively, spending time on learning new development environments.
Finding proper libraries and code samples showing how to use popular sensors, actuators, etc.
Sharing embedded projects between team members, regardless of operating system they prefer to work with.
Overview
PlatformIO is independent from the platform, in which it is running. In fact, the only requirement is Python, which exists pretty much everywhere. What this means is that PlatformIO projects can be easily moved from one computer to another, as well as that PlatformIO allows for the easy sharing of projects between team members, regardless of operating system they prefer to work with. Beyond that, PlatformIO can be run not only on commonly used desktops/laptops but also on the servers without X Window System. While PlatformIO itself is a console application, it can be used in combination with one’s favorite IDE Integration or text editor such as PlatformIO IDE for Atom, CLion, Eclipse, Emacs, NetBeans, Qt Creator, Sublime Text, VIM, Visual Studio, etc.

Alright, so PlatformIO can run on different operating systems. But more importantly, from development perspective at least, is a list of supported boards and MCUs. To keep things short: PlatformIO supports approximately 200 Embedded Boards and all major Development Platforms.

User SHOULD have a choice
Decide which operation system they want to run development process on. You can even use one OS at home and another at work.
Choose which editor to use for writing the code. It can be pretty simple editor or powerful favorite IDE Integration.
Focus on the code development, significantly simplifying support for the Platforms & Embedded Boards and MCUs.
How does it work?
Without going too deep into PlatformIO implementation details, work cycle of the project developed using PlatformIO is as follows:

Users choose board(s) interested in Project Configuration File platformio.ini
Based on this list of boards, PlatformIO downloads required toolchains and installs them automatically.
Users develop code and PlatformIO makes sure that it is compiled, prepared and uploaded to all the boards of interest.
[Embedds]	Embedds.com: Develop easier with PlatformIO ecosystem

