 Autochanger Support

Bareos provides autochanger support for reading and writing tapes. In order to work with an autochanger, Bareos requires a number of things,  each of which is explained in more detail after this list:

\- The package ***\*bareos-storage-tape\**** must be installed.

\- A script that actually controls the autochanger according to commands sent by Bareos. Bareos contains the script ***\*mtx-changer\****, that utilize the command ***\*mtx\****. It’s config file is normally located at `/etc/bareos/mtx-changer.conf`

\- That each Volume (tape) to be used must be defined in the Catalog  and have a Slot number assigned to it so that Bareos knows where the  Volume is in the autochanger. This is generally done with the ***\*label\**** command, but can also done after the tape is labeled using the ***\*update slots\**** command. See below for more details. You must pre-label the tapes manually before using them.

\- Modifications to your Storage daemon’s Device configuration resource to identify that the device is a changer, as well as a few other  parameters.

\- You need to ensure that your Storage daemon has access permissions  to both the tape drive and the control device. On Linux, the system user ***\*bareos\**** is added to the groups ***\*disk\**** and ***\*tape\****, so that it should have the permission to access the library.

\- Set [`Auto Changer (Dir->Storage) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger).

Bareos uses its own ***\*mtx-changer\**** script to interface with a program that actually does the tape changing. Thus in principle, ***\*mtx-changer\**** can be adapted to function with any autochanger program, or you can call any other script or program. The current version of ***\*mtx-changer\**** works with the ***\*mtx\**** program. FreeBSD users might need to adapt this script to use ***\*chio\****. For more details, refer to the [Testing Autochanger](https://docs.bareos.org/Appendix/Troubleshooting.html#autochangertesting) chapter.

Bareos also supports autochangers with barcode readers. This support includes two Console commands: ***\*label barcodes\**** and ***\*update slots\****. For more details on these commands, see the chapter about [Barcode Support](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#barcodes).

Current Bareos autochanger support does not include cleaning,  stackers, or silos. Stackers and silos are not supported because Bareos  expects to be able to access the Slots randomly. However, if you are  very careful to setup Bareos to access the Volumes in the autochanger  sequentially, you may be able to make Bareos work with stackers (gravity feed and such).

In principle, if ***\*mtx\**** will operate your changer correctly, then it is just a question of adapting the ***\*mtx-changer\**** script (or selecting one already adapted) for proper interfacing.

If you are having troubles, please use the auto command in the ***\*btape\**** program to test the functioning of your autochanger with Bareos. Please remember, that on most distributions, the Bareos Storage Daemon runs as user ***\*bareos\**** and not as ***\*root\****. You will need to ensure that the Storage daemon has sufficient permissions to access the autochanger.

Some users have reported that the the Storage daemon blocks under  certain circumstances in trying to mount a volume on a drive that has a  different volume loaded. As best we can determine, this is simply a  matter of waiting a bit. The drive was previously in use writing a  Volume, and sometimes the drive will remain BLOCKED for a good deal of  time (up to 7 minutes on a slow drive) waiting for the cassette to  rewind and to unload before the drive can be used with a different  Volume.


## Knowing What SCSI Devices You Have



### Linux

Under Linux, you can

```
cat /proc/scsi/scsi
```

to see what SCSI devices you have available. You can also:

```
cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices
```

to find out how to specify their control address (/dev/sg0 for the first, /dev/sg1 for the second, …) on the [`Changer Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice) Bareos directive.

You can also use the excellent lsscsi tool.

```
$ lsscsi -g
 [1:0:2:0]    tape    SEAGATE  ULTRIUM06242-XXX 1619  /dev/st0  /dev/sg9
 [1:0:14:0]   mediumx STK      L180             0315  /dev/sch0 /dev/sg10
 [2:0:3:0]    tape    HP       Ultrium 3-SCSI   G24S  /dev/st1  /dev/sg11
 [3:0:0:0]    enclosu HP       A6255A           HP04  -         /dev/sg3
 [3:0:1:0]    disk    HP 36.4G ST336753FC       HP00  /dev/sdd  /dev/sg4
```

### FreeBSD

Under FreeBSD, use the following command to list the SCSI devices as well as the `/dev/passN` that you will use on the Bareos [`Changer Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice) directive:

```
camcontrol devlist
```

Please check that your Storage daemon has permission to access this device.

The following tip for FreeBSD users comes from Danny Butroyd: on reboot Bareos will NOT have permission to control the device `/dev/pass0` (assuming this is your changer device). To get around this just edit the `/etc/devfs.conf` file and add the following to the bottom:

```
own     pass0   root:bareos
perm    pass0   0666
own     nsa0.0  root:bareos
perm    nsa0.0    0666
```

This gives the bareos group permission to write to the nsa0.0 device  too just to be on the safe side. To bring these changes into effect just run:-

```
/etc/rc.d/devfs restart
```

Basically this will stop you having to manually change permissions on these devices to make Bareos work when operating the AutoChanger after a reboot.

### Solaris

On Solaris, the changer device will typically be some file under `/dev/rdsk`.

## Slots



To properly address autochangers, Bareos must know which  Volume is in each slot of the autochanger. Slots are where the changer  cartridges reside when not loaded into the drive. Bareos numbers these  slots from one to the number of cartridges contained in the autochanger.

Bareos will not automatically use a Volume in your autochanger unless it is labeled and the slot number is stored in the catalog and the  Volume is marked as InChanger. This is because it must know where each  volume is to be able to load the volume. For each Volume in your  changer, you will, using the Console program, assign a slot. This  information is kept in Bareos’s catalog database along with the other  data for the volume. If no slot is given, or the slot is set to zero,  Bareos will not attempt to use the autochanger even if all the necessary configuration  records are present. When doing a **mount** command on an autochanger, you must specify which slot you want  mounted. If the drive is loaded with a tape from another slot, it will  unload it and load the correct tape, but normally, no tape will be  loaded because an **unmount** command causes Bareos to unload the tape in the drive.

You can check if the Slot number and InChanger flag by:

list volumes

```
*list volumes
```



## Multiple Devices



Some autochangers have more than one read/write device (drive). The [Autochanger resource](https://docs.bareos.org/Configuration/StorageDaemon.html#autochangerres) permits you to group Device resources, where each device represents a  drive. The Director may still reference the Devices (drives) directly,  but doing so, bypasses the proper functioning of the drives together.  Instead, the Director (in the Storage resource) should reference the  Autochanger resource name. Doing so permits the Storage daemon to ensure that only one drive uses the mtx-changer script at a time, and also that two drives don’t  reference the same Volume.

Multi-drive requires the use of the [`Drive Index (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveIndex) directive. Drive numbers or the Device Index are numbered beginning at  zero, which is the default. To use the second Drive in an autochanger,  you need to define a second Device resource, set the [`Drive Index (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveIndex) and set the [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice).

As a default, Bareos jobs will prefer to write to a Volume that is  already mounted. If you have a multiple drive autochanger and you want  Bareos to write to more than one Volume in the same Pool at the same  time, you will need to set [`Prefer Mounted Volumes (Dir->Job) = no`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_PreferMountedVolumes). This will cause the Storage daemon to maximize the use of drives.

## Device Configuration Records



Configuration of autochangers within Bareos is done in the Device resource of the Storage daemon.

Following records control how Bareos uses the autochanger:

- [`Autochanger (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger)

  Specifies if the current device belongs to an autochanger resource.

[`Changer Command (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerCommand) ([`Changer Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerCommand))

[`Changer Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice) ([`Changer Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice))

- [`Drive Index (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveIndex)

  Individual driver number, starting at 0.

[`Maximum Changer Wait (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumChangerWait)

## Specifying Slots When Labeling



If you add an Autochanger = yes record to the  Storage resource in your Director’s configuration file, the Bareos  Console will automatically prompt you for the slot number when the  Volume is in the changer when you add or label tapes for that Storage  device. If your mtx-changer script is properly installed, Bareos will  automatically load the correct tape during the label command.

You must also set Autochanger = yes in the Storage daemon’s Device  resource as we have described above in order for the autochanger to be  used. Please see [`Auto Changer (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger) and [`Autochanger (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger) for more details on these records.

Thus all stages of dealing with tapes can be totally automated. It is also possible to set or change the Slot using the update command in the Console and selecting Volume Parameters to update.

Even though all the above configuration statements are specified and  correct, Bareos will attempt to access the autochanger only if a slot is non-zero in the catalog Volume record (with the Volume name).

If your autochanger has barcode labels, you can label all the Volumes in your autochanger one after another by using the **label barcodes** command. For each tape in the changer containing a barcode, Bareos will mount the tape and then label it with the same name as the barcode. An  appropriate Media record will also be created in the catalog. Any  barcode that begins with the same characters as specified on the  “CleaningPrefix=xxx” command, will be treated as a cleaning tape, and will not be labeled. For example with:

```
Pool {
  Name ...
  Cleaning Prefix = "CLN"
}
```

Any slot containing a barcode of CLNxxxx will be treated as a cleaning tape and will not be mounted.

## Changing Cartridges

 If you wish to insert or  remove cartridges in your autochanger or you manually run the mtx  program, you must first tell Bareos to release the autochanger by doing:

```
unmount
(change cartridges and/or run mtx)
mount
```

If you do not do the unmount before making such a change, Bareos will become completely confused about what is in the autochanger and may  stop function because it expects to have exclusive use of the  autochanger while it has the drive mounted.

## Dealing with Multiple Magazines



If you have several magazines or if you insert or remove cartridges  from a magazine, you should notify Bareos of this. By doing so, Bareos  will as a preference, use Volumes that it knows to be in the autochanger before accessing Volumes that are not in the autochanger. This prevents unneeded operator intervention.

If your autochanger has barcodes (machine readable tape labels), the  task of informing Bareos is simple. Every time, you change a magazine,  or add or remove a cartridge from the magazine, simply use following  commands in the Console program:

```
unmount
(remove magazine)
(insert new magazine)
update slots
mount
```

This will cause Bareos to request the autochanger to return the  current Volume names in the magazine. This will be done without actually accessing or reading the Volumes because the barcode reader does this  during inventory when the autochanger is first turned on. Bareos will  ensure that any Volumes that are currently marked as being in the  magazine are marked as no longer in the magazine, and the new list of  Volumes will be marked as being in the magazine. In addition, the Slot  numbers of the Volumes will be corrected in Bareos’s catalog if they are incorrect  (added or moved).

If you do not have a barcode reader on your autochanger, you have several alternatives.

1. You can manually set the Slot and InChanger flag using the update volume command in the Console (quite painful).

2. You can issue a

   ```
   update slots scan
   ```

   command that will cause Bareos to read the label on each of the  cartridges in the magazine in turn and update the information (Slot,  InChanger flag) in the catalog. This is quite effective but does take  time to load each cartridge into the drive in turn and read the Volume  label.

## Update Slots Command



If you change only one cartridge in the magazine,  you may not want to scan all Volumes, so the update slots command (as  well as the update slots scan command) has the additional form:

```
update slots=n1,n2,n3-n4, ...
```

where the keyword scan can be appended or not. The n1,n2, … represent Slot numbers to be updated and the form n3-n4 represents a range of  Slot numbers to be updated (e.g. 4-7 will update Slots 4,5,6, and 7).

This form is particularly useful if you want to do a scan (time expensive) and restrict the update to one or two slots.

For example, the command:

```
update slots=1,6 scan
```

will cause Bareos to load the Volume in Slot 1, read its Volume label and update the Catalog. It will do the same for the Volume in Slot 6.  The command:

```
update slots=1-3,6
```

will read the barcoded Volume names for slots 1,2,3 and 6 and make  the appropriate updates in the Catalog. If you don’t have a barcode  reader the above command will not find any Volume names so will do  nothing.

## Using the Autochanger



Let’s assume that you have properly defined the necessary  Storage daemon Device records, and you have added the Autochanger = yes  record to the Storage resource in your Director’s configuration file.

Now you fill your autochanger with say six blank tapes.

What do you do to make Bareos access those tapes?

One strategy is to prelabel each of the tapes. Do so by starting Bareos, then with the Console program, enter the label command:

```
./bconsole
Connecting to Director rufus:8101
1000 OK: rufus-dir Version: 1.26 (4 October 2002)
*label
```

it will then print something like:

```
Using default Catalog name=BackupDB DB=bareos
The defined Storage resources are:
     1: Autochanger
     2: File
Select Storage resource (1-2): 1
```

I select the autochanger (1), and it prints:

```
Enter new Volume name: TestVolume1
Enter slot (0 for none): 1
```

where I entered TestVolume1 for the tape name, and slot 1 for the slot. It then asks:

```
Defined Pools:
     1: Default
     2: File
Select the Pool (1-2): 1
```

I select the Default pool. This will be automatically done if you  only have a single pool, then Bareos will proceed to unload any loaded  volume, load the volume in slot 1 and label it. In this example, nothing was in the drive, so it printed:

```
Connecting to Storage daemon Autochanger at localhost:9103 ...
Sending label command ...
3903 Issuing autochanger "load slot 1" command.
3000 OK label. Volume=TestVolume1 Device=/dev/nst0
Media record for Volume=TestVolume1 successfully created.
Requesting mount Autochanger ...
3001 Device /dev/nst0 is mounted with Volume TestVolume1
You have messages.
*
```

You may then proceed to label the other volumes. The messages will  change slightly because Bareos will unload the volume (just labeled  TestVolume1) before loading the next volume to be labeled.

Once all your Volumes are labeled, Bareos will automatically load them as they are needed.

To “see” how you have labeled your Volumes, simply enter the list  volumes command from the Console program, which should print something  like the following:

```
*:strong:`list volumes`
Using default Catalog name=BackupDB DB=bareos
Defined Pools:
     1: Default
     2: File
Select the Pool (1-2): 1
+-------+----------+--------+---------+-------+--------+----------+-------+------+
| MedId | VolName  | MedTyp | VolStat | Bites | LstWrt | VolReten | Recyc | Slot |
+-------+----------+--------+---------+-------+--------+----------+-------+------+
| 1     | TestVol1 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 1    |
| 2     | TestVol2 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 2    |
| 3     | TestVol3 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 3    |
| ...                                                                            |
+-------+----------+--------+---------+-------+--------+----------+-------+------+
```



## Barcode Support



Bareos provides barcode support with two Console commands, label barcodes and update slots.

The label barcodes will cause Bareos to read the barcodes of all the  cassettes that are currently installed in the magazine (cassette holder) using the mtx-changer list command. Each cassette is mounted in turn  and labeled with the same Volume name as the barcode.

The update slots command will first obtain the list of cassettes and  their barcodes from mtx-changer. Then it will find each volume in turn  in the catalog database corresponding to the barcodes and set its Slot  to correspond to the value just read. If the Volume is not in the  catalog, then nothing will be done. This command is useful for  synchronizing Bareos with the current magazine in case you have changed  magazines or in case you have moved cassettes from one slot to another.  If the autochanger is empty, nothing will be done.

The Cleaning Prefix statement can be used in the Pool resource to  define a Volume name prefix, which if it matches that of the Volume  (barcode) will cause that Volume to be marked with a VolStatus of  Cleaning. This will prevent Bareos from attempting to write on the  Volume.

## Use bconsole to display Autochanger content

The status slots storage=xxx command displays autochanger content.

```
 Slot |  Volume Name    |  Status  |      Type         |    Pool        |  Loaded |
------+-----------------+----------+-------------------+----------------+---------|
    1 |           00001 |   Append |  DiskChangerMedia |        Default |    0    |
    2 |           00002 |   Append |  DiskChangerMedia |        Default |    0    |
    3*|           00003 |   Append |  DiskChangerMedia |        Scratch |    0    |
    4 |                 |          |                   |                |    0    |
```

If you see a near the slot number, you have to run update slots command to synchronize autochanger content with your catalog.

## Bareos Autochanger Interface



Bareos calls the autochanger script that  you specify on the Changer Command statement. Normally this script will  be the mtx-changer script that we provide, but it can in fact be any  program. The only requirement for the script is that it must understand  the commands that Bareos uses, which are loaded, load, unload, list, and slots. In addition, each of those commands must return the information  in the precise format as specified below:

```
- Currently the changer commands used are:
    loaded -- returns number of the slot that is loaded, base 1,
              in the drive or 0 if the drive is empty.
    load   -- loads a specified slot (note, some autochangers
              require a 30 second pause after this command) into
              the drive.
    unload -- unloads the device (returns cassette to its slot).
    list   -- returns one line for each cassette in the autochanger
              in the format <slot>:<barcode>. Where
              the :strong:`slot` is the non-zero integer representing
              the slot number, and :strong:`barcode` is the barcode
              associated with the cassette if it exists and if you
              autoloader supports barcodes. Otherwise the barcode
              field is blank.
    slots  -- returns total number of slots in the autochanger.
```

Bareos checks the exit status of the program called, and if it is  zero, the data is accepted. If the exit status is non-zero, Bareos will  print an error message and request the tape be manually mounted on the  drive.



## Tapespeed and blocksizes



The [Bareos Whitepaper Tape Speed Tuning](http://www.bareos.org/en/Whitepapers/articles/Speed_Tuning_of_Tape_Drives.html) shows that the two parameters **Maximum File Size** and **Maximum Block Size** of the device have significant influence on the tape speed.

While it is no problem to change the [`Maximum File Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumFileSize) parameter, unfortunately it is not possible to change the [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize) parameter, because the previously written tapes would become unreadable in the new setup. It would require that the [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize) parameter is switched back to the old value to be able to read the old volumes, but of course then the new volumes would be unreadable.

Why is that the case?

The problem is that Bareos writes the label block (header) in the same block size that is configured in the [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize) parameter in the device. Per default, this value is 63k, so usually a tape written by Bareos looks like this:

```
|-------------------
|label block  (63k)|
|-------------------
|data block  1(63k)|
|data block  2(63k)|
|...               |
|data block  n(63k)|
--------------------
```

Setting the maximum block size to e.g. 512k, would lead to the following:

```
|-------------------
|label block (512k)|
|-------------------
|data block 1(512k)|
|data block 2(512k)|
|...               |
|data block n(512k)|
--------------------
```

As you can see, every block is written with the maximum block size, also the label block.

The problem that arises here is that reading a block header with a  wrong block size causes a read error which is interpreted as an  non-existent label by Bareos.

This is a potential source of data loss, because in normal operation, Bareos refuses to relabel an already labeled volume to be sure to not  overwrite data that is still needed. If Bareos cannot read the volume  label, this security mechanism does not work and you might label tapes  already labeled accidentally.

To solve this problem, the block size handling was changed in Bareos *Version >= 14.2.0* in the following way:

- The tape label block is always written in the standard 63k (64512) block size.
- The following blocks are then written in the block size configured in the **Maximum Block Size** directive.
- To be able to change the block size in an existing environment, it is now possible to set the [`Maximum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumBlockSize) and [`Minimum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MinimumBlockSize) in the pool resource. This setting is automatically promoted to each  medium in that pool as usual (i.e. when a medium is labeled for that  pool or if a volume is transferred to that pool from the scratch pool).  When a volume is mounted, the volume’s block size is used to write and read the data blocks that follow the header block.

The following picture shows the result:

```
|--------------------------------|
|label block (label block size)  |
|--------------------------------|
|data block 1(maximum block size)|
|data block 2(maximum block size)|
|...                             |
|data block n(maximum block size)|
---------------------------------|
```

We have a label block with a certain size (63k per default to be  compatible to old installations), and the following data blocks are  written with another blocksize.

This approach has the following advantages:

- If nothing is configured, existing installations keep on working without problems.
- If you want to switch an existing installation that uses the default block size and move to a new (usually bigger) block size, you can do  that easily by creating a new pool, where [`Maximum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumBlockSize) is set to the new value that you wish to use in the future:

Pool Resource: setting Maximum Block Size

```
Pool {
   Name = LTO-4-1M
      Pool Type = Backup
      Recycle = yes                       # Bareos can automatically recycle Volumes
      AutoPrune = yes                     # Prune expired volumes
      Volume Retention = 1 Month          # How long should the Full Backups be kept? (#06)
      Maximum Block Size = 1048576
      Recycle Pool = Scratch
}
```

Now configure your backups that they will write into the newly  defined pool in the future, and your backups will be written with the  new block size.

Your existing tapes can be automatically transferred to the new pool when they expire via the [Scratch Pool](https://docs.bareos.org/Configuration/Director.html#thescratchpool) mechanism. When a tape in your old pool expires, it is transferred to  the scratch pool if you set Recycle Pool = Scratch. When your new pool  needs a new volume, it will get it from the scratch pool and apply the  new pool’s properties to that tape which also include [`Maximum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumBlockSize) and [`Minimum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MinimumBlockSize).

This way you can smoothly switch your tapes to a new block size while you can still restore the data on your old tapes at any time.

### Possible Problems

There is only one case where the new block handling will cause  problems, and this is if you have used bigger block sizes already in  your setup. As we now defined the label block to always be 63k, all  labels will not be readable.

To also solve this problem, the directive [`Label Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelBlockSize) can be used to define a different label block size. That way,  everything should work smoothly as all label blocks will be readable  again.

### How can I find out which block size was used when the tape was written?

At least on Linux, you can see if Bareos tries to read the blocks  with the wrong block size. In that case, you get a kernel message like  the following in your system’s messages:

```
[542132.410170] st1: Failed to read 1048576 byte block with 64512 byte transfer.
```

Here, the block was written with 1M block size but we only read 64k.



### Direct access to Volumes with with non-default block sizes



**bls** and **bextract** can directly access Bareos volumes without catalog database. This means that these programs don’t have information about the used block size.

To be able to read a volume written with an arbitrary block size, you need to set the [`Label Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelBlockSize) (to be able to to read the label block) and the [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize) (to be able to read the data blocks) setting in the device definition used by those tools to be able to open the medium.

Example using **bls** with a tape that was written with a different blocksize than the `DEFAULT_BLOCK_SIZE` (63k), but with the default label block size of 63k:

bls with non-default block size

```
 bls FC-Drive-1 -V A00007L4
bls: butil.c:289-0 Using device: "FC-Drive-1" for reading.
25-Feb 12:47 bls JobId 0: No slot defined in catalog (slot=0) for Volume "A00007L4" on "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:47 bls JobId 0: Cartridge change or "update slots" may be required.
25-Feb 12:47 bls JobId 0: Ready to read from volume "A00007L4" on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:47 bls JobId 0: Error: block.c:1004 Read error on fd=3 at file:blk 0:1 on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst). ERR=Cannot allocate memory.
 Bareos status: file=0 block=1
 Device status: ONLINE IM_REP_EN file=0 block=2
0 files found.
```

As can be seen, **bls** manages to read the label block as it knows what volume is mounted (Ready to read from volume **A00007L4**), but fails to read the data blocks.

dmesg

```
 dmesg
[...]
st2: Failed to read 131072 byte block with 64512 byte transfer.
[...]
```

This shows that the block size for the data blocks that we need is 131072.

Now we have to set this block size in the `bareos-sd.conf`, device resource as [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize):

Storage Device Resource: setting Maximum Block Size

```
Device {
  Name = FC-Drive-1
  Drive Index = 0
  Media Type = LTO-4
  Archive Device = /dev/tape/by-id/scsi-350011d00018a5f03-nst
  AutomaticMount = yes
  AlwaysOpen = yes
  RemovableMedia = yes
  RandomAccess = no
  AutoChanger = yes
  Maximum Block Size = 131072
}
```

Now we can call bls again, and everything works as expected:

bls with non-default block size

```
 bls FC-Drive-1 -V A00007L4
bls: butil.c:289-0 Using device: "FC-Drive-1" for reading.
25-Feb 12:49 bls JobId 0: No slot defined in catalog (slot=0) for Volume "A00007L4" on "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:49 bls JobId 0: Cartridge change or "update slots" may be required.
25-Feb 12:49 bls JobId 0: Ready to read from volume "A00007L4" on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
bls JobId 203: [...]
```

### How to configure the block sizes in your environment

The following chart shows how to set the directives for maximum block size and label block size depending on how your current setup is:

![../_images/blocksize-decisionchart.png](https://docs.bareos.org/_images/blocksize-decisionchart.png)

## Tape Drive Cleaning

Bareos has no build-in functionality for tape drive cleaning.  Fortunately this is not required as most modern tape libraries have  build in auto-cleaning functionality. This functionality might require  an empty tape drive, so the tape library gets aware, that it is  currently not used. However, by default Bareos keeps tapes in the  drives, in case the same tape is required again.

The directive [`Cleaning Prefix (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_CleaningPrefix) is only used for making sure that Bareos does not try to write backups on a cleaning tape.

If your tape libraries auto-cleaning won’t work when there are tapes  in the drives, it’s probably best to set up an admin job that removes  the tapes from the drives. This job has to run, when no other backups do run. A job definition for an admin job to do that may look like this:

bareos-dir.d/job/ReleaseAllTapeDrives.conf

```
Job {
    Name = ReleaseAllTapeDrives
    JobDefs = DefaultJob
    Schedule = "WeeklyCycleAfterBackup"
    Type = Admin
    Priority = 200

    RunScript {
        Runs When = Before
        Runs On Client = no
        Console = "release storage=Tape alldrives"
    }
}
```

Replace `Tape (Dir->Storage)` by the storage name of your tape library. Use the highest [`Priority (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Priority) value to make sure no other jobs are running. In the default configuration for example, the `CatalogBackup (Dir->Job)` job has Priority = 100. The higher the number, the lower the job priority.

 Using Tape Drives without Autochanger



Although Recycling and Backing Up to Disk Volume have been discussed  in previous chapters, this chapter is meant to give you an overall view  of possible backup strategies and to explain their advantages and  disadvantages.



## Simple One Tape Backup



Probably the simplest strategy is to back everything up to a single  tape and insert a new (or recycled) tape when it fills and Bareos  requests a new one.

### Advantages

- The operator intervenes only when a tape change is needed (e.g. once a month).
- There is little chance of operator error because the tape is not changed daily.
- A minimum number of tapes will be needed for a full restore. Typically the best case will be one tape and worst two.
- You can easily arrange for the Full backup to occur a different  night of the month for each system, thus load balancing and shortening  the backup time.

### Disadvantages

- If your site burns down, you will lose your current backups
- After a tape fills and you have put in a blank tape, the backup will continue, and this will generally happen during working hours.

### Practical Details

This system is very simple. When the tape fills and Bareos requests a new tape, you unmount the tape from the Console program, insert a new  tape and label it. In most cases after the label, Bareos will  automatically mount the tape and resume the backup. Otherwise, you  simply mount the tape.

Using this strategy, one typically does a Full backup once a week  followed by daily Incremental backups. To minimize the amount of data  written to the tape, one can do a Full backup once a month on the first  Sunday of the month, a Differential backup on the 2nd-5th Sunday of the  month, and incremental backups the rest of the week.



## Manually Changing Tapes



If you use the strategy presented above, Bareos will ask you to  change the tape, and you will unmount it and then remount it when you  have inserted the new tape.

If you do not wish to interact with Bareos to change each tape, there are several ways to get Bareos to release the tape:

- In your Storage daemon’s Device resource, set **AlwaysOpen = no**. In this case, Bareos will release the tape after every job. If you run  several jobs, the tape will be rewound and repositioned to the end at  the beginning of every job. This is not very efficient, but does let you change the tape whenever you want.

- Use a RunAfterJob statement to run a script after  your last job. This could also be an Admin job that runs after all your  backup jobs. The script could be something like:

  ```
  #!/bin/sh
  bconsole <<END_OF_DATA
  release storage=your-storage-name
  END_OF_DATA
  ```

  In this example, you would have AlwaysOpen=yes, but the release  command would tell Bareos to rewind the tape and on the next job assume  the tape has changed. This strategy may not work on some systems, or on  autochangers because Bareos will still keep the drive open.

- The final strategy is similar to the previous case  except that you would use the unmount command to force Bareos to release the drive. Then you would eject the tape, and remount it as follows:

  ```
  #!/bin/sh
  bconsole <<END_OF_DATA
  unmount storage=your-storage-name
  END_OF_DATA
  
  # the following is a shell command
  mt eject
  
  bconsole <<END_OF_DATA
  mount storage=your-storage-name
  END_OF_DATA
  ```



## Daily Tape Rotation



This scheme is quite different from the one mentioned above in that a Full backup is done to a different tape every day of the week.  Generally, the backup will cycle continuously through five or six tapes  each week. Variations are to use a different tape each Friday, and  possibly at the beginning of the month. Thus if backups are done Monday  through Friday only, you need only five tapes, and by having two Friday  tapes, you need a total of six tapes. Many sites run this way, or using modifications of it based on two week cycles or longer.



### Advantages

- All the data is stored on a single tape, so recoveries are simple and faster.
- Assuming the previous day’s tape is taken offsite each day, a maximum of one days data will be lost if the site burns down.



### Disadvantages

- The tape must be changed every day requiring a lot of operator intervention.
- More errors will occur because of human mistakes.
- If the wrong tape is inadvertently mounted, the Backup for that day will not occur exposing the system to data loss.
- There is much more movement of the tape each day (rewinds) leading to shorter tape drive life time.
- Initial setup of Bareos to run in this mode is more complicated than the Single tape system described above.
- Depending on the number of systems you have and their data capacity, it may not be possible to do a Full backup every night for time reasons or reasons of tape capacity.



### Practical Details

The simplest way to “force” Bareos to use a different tape each day  is to define a different Pool for each day of the the week a backup is  done. In addition, you will need to specify appropriate Job and File  retention periods so that Bareos will relabel and overwrite the tape  each week rather than appending to it. Nic Bellamy has supplied an  actual working model of this which we include here.

What is important is to create a different Pool for each day of the  week, and on the run statement in the Schedule, to specify which Pool is to be used. He has one Schedule that accomplishes this, and a second  Schedule that does the same thing for the Catalog backup run each day  after the main backup (Priorities were not available when this script  was written). In addition, he uses a Max Start Delay of 22 hours so that if the wrong tape is premounted by the operator, the job will be automatically canceled, and the backup cycle will re-synchronize the  next day. He has named his Friday Pool WeeklyPool because in that Pool,  he wishes to have several tapes to be able to restore to a time older  than one week.

And finally, in his Storage daemon’s Device resource, he has  Automatic Mount = yes and Always Open = No. This is necessary for the  tape ejection to work in his end_of_backup.sh script below.

For example, his bareos-dir.conf file looks like the following:

```
# /etc/bareos/bareos-dir.conf
#
# Bareos Director Configuration file
#
Director {
  Name = ServerName
  DIRport = 9101
  QueryFile = "/etc/bareos/query.sql"
  Maximum Concurrent Jobs = 1
  Password = "console-pass"
  Messages = Standard
}
#
# Define the main nightly save backup job
#
Job {
  Name = "NightlySave"
  Type = Backup
  Client = ServerName
  FileSet = "Full Set"
  Schedule = "WeeklyCycle"
  Storage = Tape
  Messages = Standard
  Pool = Default
  Write Bootstrap = "/var/lib/bareos/NightlySave.bsr"
  Max Start Delay = 22h
}
# Backup the catalog database (after the nightly save)
Job {
  Name = "BackupCatalog"
  Type = Backup
  Client = ServerName
  FileSet = "Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  Storage = Tape
  Messages = Standard
  Pool = Default
  # This creates an ASCII copy of the catalog
  # WARNING!!! Passing the password via the command line is insecure.
  # see comments in make_catalog_backup for details.
  RunBeforeJob = "/usr/lib/bareos/make_catalog_backup -u bareos"
  # This deletes the copy of the catalog, and ejects the tape
  RunAfterJob  = "/etc/bareos/end_of_backup.sh"
  Write Bootstrap = "/var/lib/bareos/BackupCatalog.bsr"
  Max Start Delay = 22h
}
# Standard Restore template, changed by Console program
Job {
  Name = "RestoreFiles"
  Type = Restore
  Client = ServerName
  FileSet = "Full Set"
  Storage = Tape
  Messages = Standard
  Pool = Default
  Where = /tmp/bareos-restores
}
# List of files to be backed up
FileSet {
  Name = "Full Set"
  Include = signature=MD5 {
    /
    /data
  }
  Exclude = { /proc /tmp /.journal }
}
#
# When to do the backups
#
Schedule {
  Name = "WeeklyCycle"
  Run = Level=Full Pool=MondayPool Monday at 8:00pm
  Run = Level=Full Pool=TuesdayPool Tuesday at 8:00pm
  Run = Level=Full Pool=WednesdayPool Wednesday at 8:00pm
  Run = Level=Full Pool=ThursdayPool Thursday at 8:00pm
  Run = Level=Full Pool=WeeklyPool Friday at 8:00pm
}
# This does the catalog. It starts after the WeeklyCycle
Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Level=Full Pool=MondayPool Monday at 8:15pm
  Run = Level=Full Pool=TuesdayPool Tuesday at 8:15pm
  Run = Level=Full Pool=WednesdayPool Wednesday at 8:15pm
  Run = Level=Full Pool=ThursdayPool Thursday at 8:15pm
  Run = Level=Full Pool=WeeklyPool Friday at 8:15pm
}
# This is the backup of the catalog
FileSet {
  Name = "Catalog"
  Include = signature=MD5 {
     /var/lib/bareos/bareos.sql
  }
}
# Client (File Services) to backup
Client {
  Name = ServerName
  Address = dionysus
  FDPort = 9102
  Password = "client-pass"
  File Retention = 30d
  Job Retention = 30d
  AutoPrune = yes
}
# Definition of file storage device
Storage {
  Name = Tape
  Address = dionysus
  SDPort = 9103
  Password = "storage-pass"
  Device = Tandberg
  Media Type = MLR1
}
# Generic catalog service
Catalog {
  Name = MyCatalog
  dbname = bareos; user = bareos; password = ""
}
# Reasonable message delivery -- send almost all to email address
#  and to the console
Messages {
  Name = Standard
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bareos\) %r\" -s \"Bareos: %t %e of %c %l\" %r"
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bareos\) %r\" -s \"Bareos: Intervention needed for %j\" %r"
  mail = root@localhost = all, !skipped
  operator = root@localhost = mount
  console = all, !skipped, !saved
  append = "/var/lib/bareos/log" = all, !skipped
}

# Pool definitions
#
# Default Pool for jobs, but will hold no actual volumes
Pool {
  Name = Default
  Pool Type = Backup
}
Pool {
  Name = MondayPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 6d
  Maximum Volume Jobs = 2
}
Pool {
  Name = TuesdayPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 6d
  Maximum Volume Jobs = 2
}
Pool {
  Name = WednesdayPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 6d
  Maximum Volume Jobs = 2
}
Pool {
  Name = ThursdayPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 6d
  Maximum Volume Jobs = 2
}
Pool {
  Name = WeeklyPool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 12d
  Maximum Volume Jobs = 2
}
# EOF
```

In order to get Bareos to release the tape after the nightly backup,  this setup uses a RunAfterJob script that deletes the database dump and  then rewinds and ejects the tape. The following is a copy of  end_of_backup.sh

```
#! /bin/sh
/usr/lib/bareos/delete_catalog_backup
mt rewind
mt eject
exit 0
```

Finally, if you list his Volumes, you get something like the following:

```
*list media
Using default Catalog name=MyCatalog DB=bareos
Pool: WeeklyPool
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| 5   | Friday_1  | MLR1  | Used   | 2157171998| 2003-07-11 20:20| 103680| 1    |
| 6   | Friday_2  | MLR1  | Append | 0         | 0               | 103680| 1    |
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
Pool: MondayPool
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| 2   | Monday    | MLR1  | Used   | 2260942092| 2003-07-14 20:20| 518400| 1    |
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
Pool: TuesdayPool
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| 3   | Tuesday   | MLR1  | Used   | 2268180300| 2003-07-15 20:20| 518400| 1    |
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
Pool: WednesdayPool
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| 4   | Wednesday | MLR1  | Used   | 2138871127| 2003-07-09 20:2 | 518400| 1    |
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
Pool: ThursdayPool
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
| 1   | Thursday  | MLR1  | Used   | 2146276461| 2003-07-10 20:50| 518400| 1    |
+-----+-----------+-------+--------+-----------+-----------------+-------+------+
Pool: Default
No results to list.
```