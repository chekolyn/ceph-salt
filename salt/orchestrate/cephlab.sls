# vi: set ft=yaml.jinja :

cephlab_test01:
  salt.state:
    - tgt: 'roles:ceph-mon'
    - tgt_type: grain
    #- highstate: True
    - sls:
      - common.bc
      - common.git
      - common.smartmontools

# osd_setup:
#  salt.state:
#    - tgt: 'roles:ceph-osd'
#    - tgt_type: grain
#    - sls: ceph.osd
#    - require:
#      - salt: mon_setup
