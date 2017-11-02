# rht-vmctl

**Usage:**

     rht-vmctl [-q|--quiet] VMCMD VMNAME
     rht-vmctl -h|--help


**VMCMD:**

    reset      - poweroff, return to saved or original state, start VMNAME
    view       - launches console viewer of VMNAME
    start      - obtain and start up VMNAME
    stop       - stop a running VMNAME
    poweroff   - if running, force stop VMNAME
    save       - stop, backup image, start VMNAME
    restore    - poweroff, restore image, start VMNAME
    fullreset  - poweroff, reobtain from server, start VMNAME (bad save/image)
    get        - if not here, obtain VMNAME from server
    status     - display libvirt status of VMNAME
