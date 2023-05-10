# systemd

[TOC]

## 概述

要管理服务，可以使用 `systemctl` 命令行工具来控制 `systemd` 系统和服务管理器，也可以使用 RHEL web 控制台。

## 启用、禁用、屏蔽服务

作为系统管理员，可以启用或禁用要在引导时启动的服务，这些更改将在下次重启时应用。

如果希望服务在引导时自动启动，必须启用此服务。

如果禁用某个服务，它不会在引导时启动，但可以手动启动。

可以屏蔽服务，使其无法手动启动。屏蔽是一种禁用服务的方法，使该服务能够永久不可用，直到再次屏蔽该服务。

1. 在引导时启用服务：

   ```bash
   systemctl enable service_name		
   ```

   还可以使用一个命令启用并启动服务：

   ```bash
   systemctl enable --now service_name
   ```

2. 禁用要在引导时启动的服务：

   ```bash
   systemctl disable service_name
   ```

3. 如果想使服务永久不可用，请屏蔽该服务： 

   ```bash
   systemctl mask service_name
   ```

   如果您有一个屏蔽的服务，取消屏蔽它： 											

   ```bash
   systemctl unmask service_name
   ```