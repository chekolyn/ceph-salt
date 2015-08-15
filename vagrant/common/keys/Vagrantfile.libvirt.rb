# vi: set ft=ruby :

# This will configure the libvirt hypervisor settings
# NOTE: Using Vagrant nugrant plugin to abstract the hipervisor settings
# Load common config.libvirt.rb
begin
  load '../common/config.libvirt.rb'
rescue LoadError
  # ignore
end

Vagrant.configure("2") do |config|
  
  config.vm.box = "uvsmtid/centos-7.0-minimal"
  config.vm.box_url = "https://atlas.hashicorp.com/uvsmtid/boxes/centos-7.0-minimal/versions/1.0.0/providers/libvirt.box"
  
  # Centos7 Disable Firewall
  config.vm.provision "shell", inline: "systemctl disable firewalld",
    run: "always"
  config.vm.provision "shell", inline: "systemctl stop firewalld",
    run: "always"
  
  # Configure eth0 via script, will disable NetworkManager and enable legacy network daemon:
  config.vm.provision "shell", path: "../common/disable_network_manager.sh"
    
  ### NOTE:Hypervisor configuration abstracted at: "config.libvirt.rb" ###
  ########################################################################

  ### VMs definitions START ####
  config.vm.define "master" do |node|

    node.vm.hostname = "master"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, type: "static", ip: "192.168.33.10",
      libvirt__network_name: "salt-os-public",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: true

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.10",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Configure SALT info from local gitrepo:
    node.vm.synced_folder "../../file_root/", "/srv/salt", type: "rsync"
    node.vm.synced_folder "pillar_root/", "/srv/pillar", type: "rsync"

    # salt-master provisioning
    node.vm.provision :salt do |salt|
      salt.install_master = true
      salt.always_install = true
      salt.master_config = "configs/master"
      salt.run_highstate = false
      salt.master_key = 'keys/master.pem'
      salt.master_pub = 'keys/master.pub'

      salt.minion_config = "configs/minion"
      salt.minion_key = 'keys/master.pem'
      salt.minion_pub = 'keys/master.pub'

      salt.seed_master = {
        'master' => 'keys/master.pub',
        'control01' => 'keys/control01.pub',
        'node01' => 'keys/node01.pub',
        'node02' => 'keys/node02.pub',
        'node03' => 'keys/node03.pub'
      }
    end
  end

  ## CONTROLLER ##
  config.vm.define "control01" do |node|
    node.vm.hostname = "control01"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.21",
      libvirt__network_name: "salt-os-public"
      
    # Vagrant forward web port:
    node.vm.network "forwarded_port", guest: 80, host: 8080,
      auto_correct: true

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.21",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Fix vagrant libvirt dhcp network issue:
    node.vm.provision "shell", inline: "ip addr flush eth1 && ifup eth1"
    node.vm.provision "shell", inline: "ip addr flush eth2"

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = 'keys/control01.pem'
      salt.minion_pub = 'keys/control01.pub'
      salt.run_highstate = false
    end
  end

  ## NODES ##
  config.vm.define "node01" do |node|
    node.vm.hostname = "node01"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.31"

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.31",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    config.vm.provider :libvirt do |libvirt|
      libvirt.memory = 4096
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "../common/keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "../common/keys/#{node.vm.hostname}.pub"
    end
  end

  config.vm.define "node02" do |node|
    node.vm.hostname = "node02"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.32"

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.32",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    config.vm.provider :libvirt do |libvirt|
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "../common/keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "../common/keys/#{node.vm.hostname}.pub"
    end
  end

  config.vm.define "node03" do |node|
    node.vm.hostname = "node03"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.33"

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.33",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    config.vm.provider :libvirt do |libvirt|
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
      libvirt.storage :file, :size => '4G'
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "../common/keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "../common/keys/#{node.vm.hostname}.pub"
    end
  end
  ### VMs definitions END ####  

end
