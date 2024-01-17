# HTTP API[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#http-api)

## 6.12.1. Error codes[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#error-codes)

| status code | status message | Description |
| ----------- | -------------- | ----------- |
| 200         | ok             |             |
| 404         | not found      |             |
| 500         | server error   |             |

## 6.12.2. Http endpoints[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#http-endpoints)

All Http endpoints are found at `http(s)://<fqdn>/cblr/svc/op/<endpoint>`

### 6.12.2.1. settings[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#settings)

Returns the currently loaded settings. For specific settings please see [the settings.yaml documentation](https://cobbler.readthedocs.io/en/latest/cobbler-conf/settings-yaml.html#settings-ref).

Example Call:

```
curl http://localhost/cblr/svc/op/setting
```

Example Output:

```
#{
    "allow_duplicate_hostnames": false,
    "allow_duplicate_ips": false,
    "allow_duplicate_macs": false,
    "allow_dynamic_settings": false
...
        "gcry_sha1",
        "gcry_sha256"
    ],
    "grub2_mod_dir": "/usr/share/grub2"
}
```

### 6.12.2.2. autoinstall[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#autoinstall)

Autoinstallation files for either a profile or a system.

#### 6.12.2.2.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#profile)

Example Call:

```
curl http://localhost/cblr/svc/op/autoinstall/profile/example_profile
```

Example Output:

```
# this file intentionally left blank
# admins:  edit it as you like, or leave it blank for non-interactive install
```

#### 6.12.2.2.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#system)

Example Call:

```
curl http://localhost/cblr/svc/op/autoinstall/system/example_system
```

Example Output:

```
# this file intentionally left blank
# admins:  edit it as you like, or leave it blank for non-interactive install
```

### 6.12.2.3. ks[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#ks)

Autoinstallation files for either a profile or a system. This is used only for backward compatibility with Cobbler 2.6.6 and lower, please use autoinstall if possible.

#### 6.12.2.3.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id1)

Example Call:

```
curl http://localhost/cblr/svc/op/ks/profile/example_profile
```

Example Output:

```
# this file intentionally left blank
# admins:  edit it as you like, or leave it blank for non-interactive install
```

#### 6.12.2.3.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id2)

Example Call:

```
curl http://localhost/cblr/svc/op/ks/system/example_system
```

Example Output:

```
# this file intentionally left blank
# admins:  edit it as you like, or leave it blank for non-interactive install
```

### 6.12.2.4. iPXE[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#ipxe)

The iPXE configuration for a profile, an image or a system.

#### 6.12.2.4.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id3)

Example Call:

```
curl http://localhost/cblr/svc/op/ipxe/profile/example_profile
```

Example Output:

```
:example_profile
kernel /images/example_distro/vmlinuz   initrd=initrd.magic
initrd /images/example_distro/initramfs
boot
```

Warning

If the specified profile doesn’t exist there is currently no output.

#### 6.12.2.4.2. Image[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#image)

Example Call:

```
curl http://localhost/cblr/svc/op/ipxe/image/example_image
```

Example Output:

Warning

This endpoint is currently broken and will probably have no output.

#### 6.12.2.4.3. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id4)

Example Call:

```
curl http://localhost/cblr/svc/op/ipxe/system/example_system
```

Example Output:

```
#!ipxe
iseq ${smbios/manufacturer} HP && exit ||
sanboot --no-describe --drive 0x80
```

Warning

If the specified system doesn’t exist there is currently no output.

### 6.12.2.5. bootcfg[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#bootcfg)

boot.cfg configuration file for either a profile or a system.

#### 6.12.2.5.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id5)

Example Call:

```
curl http://localhost/cblr/svc/op/bootcfg/profile/example_profile
```

Example Output:

```
bootstate=0
title=Loading ESXi installer
prefix=/images/example_distro
kernel=b.b00
kernelopt=runweasel ks=http://192.168.1.1:80/cblr/svc/op/ks/profile/example_profile
modules=$esx_modules
build=
updated=0
```

#### 6.12.2.5.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id6)

Example Call:

```
curl http://localhost/cblr/svc/op/bootcfg/system/example_system
```

Example Output:

```
bootstate=0
title=Loading ESXi installer
prefix=/images/example_distro
kernel=b.b00
kernelopt=runweasel ks=http://192.168.1.1:80/cblr/svc/op/ks/system/example_system
modules=$esx_modules
build=
updated=0
```

### 6.12.2.6. script[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#script)

A generated script based on snippets.

#### 6.12.2.6.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id7)

Example Call:

```
curl http://localhost/cblr/svc/op/script/profile/example_profile
```

Example Output:

Warning

This endpoint is currently broken and returns an Error 500.

#### 6.12.2.6.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id8)

Example Call:

```
curl http://localhost/cblr/svc/op/script/system/example_system
```

Example Output:

Warning

This endpoint is currently broken and returns an Error 500.

### 6.12.2.7. events[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#events)

Returns events associated with the specified user, if no user is given returns all events.

Example Call:

```
curl http://localhost/cblr/svc/op/events/user/example_user
```

Example Output:

```
[]
```

Warning

If the specified user doesn’t exist there is currently no output.

### 6.12.2.8. template[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#template)

A rendered template for a system, or for a system linked to a profile.

#### 6.12.2.8.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id9)

Example Call:

```
curl http://localhost/cblr/svc/op/template/profile/example_profile
```

Example Output:

Warning

This endpoint is currently broken.

#### 6.12.2.8.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id10)

Example Call:

```
curl http://localhost/cblr/svc/op/template/system/example_system
```

Example Output:

Warning

This endpoint is currently broken.

### 6.12.2.9. yum[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#yum)

Repository configuration for a profile or a system.

#### 6.12.2.9.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id11)

Example Call:

```
curl http://localhost/cblr/svc/op/yum/profile/example_profile
```

Example Output:

Warning

This endpoint is currently broken and will probably have no output.

#### 6.12.2.9.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id12)

Example Call:

```
curl http://localhost/cblr/svc/op/yum/system/example_system
```

Example Output:

Warning

This endpoint is currently broken and will probably have no output.

### 6.12.2.10. trig[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#trig)

Hook to install triggers.

Example Call:

```
curl http://localhost/cblr/svc/op/trig
```

Example Output:

```
False
```

#### 6.12.2.10.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id13)

Example Call:

```
curl http://localhost/cblr/svc/op/trig/profile/example_profile
```

Example Output:

```
False
```

#### 6.12.2.10.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id14)

Example Call:

```
curl http://localhost/cblr/svc/op/trig/system/example_system
```

Example Output:

```
False
```

### 6.12.2.11. noPXE[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#nopxe)

If network boot is enabled for specified system.

Example Call:

```
curl http://localhost/cblr/svc/op/nopxe/system/example_system
```

Example Output:

```
True
```

### 6.12.2.12. list[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#list)

Lists all instances of a specified type. Currently the valid options are: `systems, profiles, distros, images, repos, mgmtclasses, packages, files, menus` If no option is selected the endpoint will default to `systems`. If the selected option is not valid the endpoint will return `?`.

Example Call:

```
curl http://localhost/cblr/svc/op/list/what/profiles
```

Example Output:

```
example_profile
example_profile2
```

Warning

currently no output if parameter has no instances.

### 6.12.2.13. autodetect[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#autodetect)

Autodetects the system, returns an error if more than one system is found.

Example Call:

```
curl http://localhost/cblr/svc/op/autodetect
```

Example Output:

Warning

This endpoint is currently broken.

### 6.12.2.14. find autoinstall[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#find-autoinstall)

Find the autoinstallation file for a profile or system.

#### 6.12.2.14.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id15)

Example Call:

```
curl http://localhost/cblr/svc/op/find_autoinstall/profile/example_profile
```

Example Output:

Warning

This endpoint is currently broken.

#### 6.12.2.14.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id16)

Example Call:

```
curl http://localhost/cblr/svc/op/find_autoinstall/system/example_system
```

Example Output:

Warning

This endpoint is currently broken.

### 6.12.2.15. find ks[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#find-ks)

Find the autoinstallation files for either a profile or a system. This is used only for backward compatibility with Cobbler 2.6.6 and lower, please use `find autoinstall` if possible.

#### 6.12.2.15.1. Profile[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id17)

Example Call:

```
curl http://localhost/cblr/svc/op/findks/profile/example_profile
```

Example Output:

Warning

This endpoint is currently broken.

#### 6.12.2.15.2. System[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#id18)

Example Call:

```
curl http://localhost/cblr/svc/op/findks/system/example_system
```

Example Output:

Warning

This endpoint is currently broken.

### 6.12.2.16. puppet[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#puppet)

Dump puppet data for specified hostname, returns yaml file for host.

Example Call:

```
curl http://localhost/cblr/svc/op/puppet/hostname/example_hostname
```

Example Output:

Warning

This endpoint is currently broken.

### 6.12.2.17. Author[](https://cobbler.readthedocs.io/en/latest/user-guide/http-api.html#author)

[Nico Krapp](https://github.com/tiltingpenguin)