Vagrant Test Environment
==============

#### Targeting OS:
* CentOS 7
* Ubuntu 14.04

#### Vagrant Providers:
* VirtualBox
* Libvirt

Vagrant + Libvirt notes
==============

To make Vagrant and libvirt work together we need few plugins:

#### Install Vagrant Nugrant plugin
    vagrant plugin install nugrant

#### Install Vagrant libvirt plugin
    vagrant plugin install vagrant-libvirt

#### Snapshots via sahara (optional)
    vagrant plugin install sahara


Other useful commands
==============

#### Syncing vm clocks (on master):
    salt "*" pkg.install "ntpdate"
    salt "*" cmd.run "ntpdate -s time.nist.gov"

#### Vagrant rsync-auto
On Libvirt we have to do this to keep the folder in sync:

    vagrant rsync-auto
