# GlusterFS

Step 1 – 至少2个节点

    Fedora 22 (or later) on two nodes named "server1" and "server2"
    A working network connection
    At least two virtual disks, one for the OS installation, and one to be used to serve GlusterFS storage (sdb). This will emulate a real world deployment, where you would want to separate GlusterFS storage from the OS install.
    Note: GlusterFS stores its dynamically generated configuration files at /var/lib/glusterd. If at any point in time GlusterFS is unable to write to these files (for example, when the backing filesystem is full), it will at minimum cause erratic behavior for your system; or worse, take your system offline completely. It is advisable to create separate partitions for directories such as /var/log to ensure this does not happen.

Step 2 - Format and mount the bricks

(on both nodes): Note: These examples are going to assume the brick is going to reside on /dev/sdb1.

    mkfs.xfs -i size=512 /dev/sdb1
    mkdir -p /data/brick1
    echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
    mount -a && mount

You should now see sdb1 mounted at /data/brick1
Step 3 - Installing GlusterFS

(on both servers) Install the software

    yum install glusterfs-server

Start the GlusterFS management daemon:

    service glusterd start
    service glusterd status
    glusterd.service - LSB: glusterfs server
           Loaded: loaded (/etc/rc.d/init.d/glusterd)
       Active: active (running) since Mon, 13 Aug 2012 13:02:11 -0700; 2s ago
      Process: 19254 ExecStart=/etc/rc.d/init.d/glusterd start (code=exited, status=0/SUCCESS)
       CGroup: name=systemd:/system/glusterd.service
           ├ 19260 /usr/sbin/glusterd -p /run/glusterd.pid
           ├ 19304 /usr/sbin/glusterfsd --xlator-option georep-server.listen-port=24009 -s localhost...
           └ 19309 /usr/sbin/glusterfs -f /var/lib/glusterd/nfs/nfs-server.vol -p /var/lib/glusterd/...

Step 4 - Configure the trusted pool

From "server1"

    gluster peer probe server2

Note: When using hostnames, the first server needs to be probed from one other server to set its hostname.

From "server2"

    gluster peer probe server1

Note: Once this pool has been established, only trusted members may probe new servers into the pool. A new server cannot probe the pool, it must be probed from the pool.
Step 5 - Set up a GlusterFS volume

On both server1 and server2:

    mkdir -p /data/brick1/gv0

From any single server:

    gluster volume create gv0 replica 2 server1:/data/brick1/gv0 server2:/data/brick1/gv0
    gluster volume start gv0

Confirm that the volume shows "Started":

    gluster volume info

Note: If the volume is not started, clues as to what went wrong will be in log files under /var/log/glusterfs on one or both of the servers - usually in etc-glusterfs-glusterd.vol.log
Step 6 - Testing the GlusterFS volume

For this step, we will use one of the servers to mount the volume. Typically, you would do this from an external machine, known as a "client". Since using this method would require additional packages to be installed on the client machine, we will use one of the servers as a simple place to test first, as if it were that "client".

    mount -t glusterfs server1:/gv0 /mnt
      for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done

First, check the mount point:

    ls -lA /mnt | wc -l

You should see 100 files returned. Next, check the GlusterFS mount points on each server:

    ls -lA /data/brick1/gv0

You should see 100 files on each server using the method we listed here. Without replication, in a distribute only volume (not detailed here), you should see about 50 files on each one.
