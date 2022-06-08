# OpenStack

[TOC]

## 介绍

RBD与OpenStack集成需要安装下面的软件。

```bash
apt-get install -y python-ceph
```

## Nova

修改nova.conf配置文件。

```bash
libvirt_images_type=rbd
libvirt_images_rbd_pool=volumes
libvirt_images_rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_user=cinder
rbd_secret_uuid=457eb676-33da-42ec-9a8c-9293d545c337

libvirt_inject_password=false
libvirt_inject_key=false
libvirt_inject_partition=-2
```

## Glance

修改glance-api.conf配置文件。

```bash
default_store=rbd
rbd_store_user=glance
rbd_store_pool=images
show_image_direct_url=True
```

## Cinder

修改cinder.conf配置文件。

```bash
volume_driver=cinder.volume.drivers.rbd.RBDDriver
rbd_pool=volumes
rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot=false
rbd_max_clone_depth=5
glance_api_version=2

backup_driver=cinder.backup.drivers.ceph
backup_ceph_conf=/etc/ceph/ceph.conf
backup_ceph_user=cinder-backup
backup_ceph_chunk_size=134217728
backup_ceph_pool=backups
backup_ceph_stripe_unit=0
backup_ceph_stripe_count=0
restore_discard_excess_bytes=true
```