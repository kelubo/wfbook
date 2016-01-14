# Dell错误代码
| LCD显示代码 | 信息描述 | 现象分析 |
|---------|------|------|
| SYSTEM ID | SYSTEM NAME | 正常，显示系统信息。 |
| E0000 | OVRFLW CHECK LOG | 日志满，需要清除日志，用DSET工具进行清除 |
| E0119 | TEMP AMBIENTTEMP BMC | 环境温度，过高或者过低 |
| E0212 | VOLT PG n | 请检测电源模块是否正常 |
| E0212 | VOLT BATT ROMB | RAID卡电池问题，需要重新充放电或者更换电池 |
| E0212 | VOLT BATT CMOS | CMOS电池需要更换 |
| E0412 | RPM FAN n FAN REDUNDANCY LOST | 风扇问题，请根据显示的风扇编号查看风扇情况 |
| E0780 | PROC n PRESENCE | 编号位置没有安装CPU |
| E07F0 | PROC n IERR | CPU安装不正确 |
| E07FA | PROC n THERMTRIP | 编号所指位置的CPU温度高 |
| E0876 | PS n | 编号所指位置电源问题，检查电源模块安装以及接线情况 |
| E08F4 | POWER PS n | 电源线没有接好 |
| E0CF5 | LOG DISABLE SBE | 内存，单字节逻辑错误，需要重新插拔交换内存 |
| E0D76 | BP DRIVE n 1x2 DRIVE FAIL n SCSI CONNECTOR | 硬盘掉线，请先备份数据，然后进行硬盘的REBUILD |
