# Open vSwitch (OVS)

## 安装

```bash
# Ubuntu
sudo apt-get install openvswitch-switch

# 验证OVS内核模块
lsmod | grep openvswitch

Module			Size		Used by
openvswitch		66901	0
gre				13796	1	openvswitch
vxlan			37619	1	openvswitch
libcrc32c		12644	1	openvswitch
```

