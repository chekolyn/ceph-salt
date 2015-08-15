nodes:
  master:
    roles:
      - ceph-mon
  node01:
    roles:
      - ceph-osd
      - ceph-mon
    devs:
      vdc:
        journal: vdb
      vdd:
        journal: vdb
  node02:
    roles:
      - ceph-osd
      - ceph-mon
    devs:
      vdc:
        journal: vdb
      vdd:
        journal: vdb
