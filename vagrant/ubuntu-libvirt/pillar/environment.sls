nodes:
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
  node03:
    roles:
      - ceph-mon
      - ceph-osd
    devs:
      vdc:
        journal: vdb
      vdd:
        journal: vdb
