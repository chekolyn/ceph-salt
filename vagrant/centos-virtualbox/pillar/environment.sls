nodes:
  node01:
    roles:
      - ceph-osd
      - ceph-mon
    devs:
      sdb:
        journal: sdb
      sdc:
        journal: sdc
      sdd:
        journal: sdd
  node02:
    roles:
      - ceph-osd
      - ceph-mon
    devs:
      sdb:
        journal: sdb
      sdc:
        journal: sdc
      sdd:
        journal: sdd
  node03:
    roles:
      - ceph-osd
      - ceph-mon
    devs:
      sdb:
        journal: sdb
      sdc:
        journal: sdc
      sdd:
        journal: sdd
