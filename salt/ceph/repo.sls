# vi: set ft=yaml.jinja :

{% set oscodename = salt['config.get']('oscodename') -%}
{% set version = salt['pillar.get']('ceph:version') -%}


{% if grains['os_family'] == 'Debian' -%}

ceph_repo:
  pkgrepo.managed:
    - name: deb http://ceph.com/debian-{{ version }}/ {{ oscodename }} main
    - file: /etc/apt/sources.list.d/ceph.list
    - key_url: https://raw.github.com/ceph/ceph/master/keys/release.asc

{% elif grains['os_family'] == 'RedHat' -%}
  {% if grains['os'] == 'CentOS'  -%}
    {% set distro = "el" -%}
  {% elif grains['os'] == 'RedHat' -%}
    {% set distro = "rhel" -%}
  {% endif -%}

  {% set distro_version = salt['config.get']('osmajorrelease') -%}

ceph_repo:
  pkgrepo.managed:
    - name: ceph
    - humanname: Ceph packages for $basearch
    - baseurl: http://ceph.com/rpm-{{ version }}/{{distro}}{{distro_version}}/$basearch
    - gpgcheck: 1
    - priority: 2
    - type: rpm-md
    - gpgkey: "https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc"
  require:
    - pkgrepo: ceph_repo_noarch

ceph_repo_noarch:
  pkgrepo.managed:
    - name: ceph-noarch
    - humanname: Ceph noarch packages
    - baseurl: http://ceph.com/rpm-{{ version }}/{{distro}}{{distro_version}}/noarch
    - gpgcheck: 1
    - priority: 2
    - type: rpm-md
    - gpgkey: "https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc"

{% endif -%}
