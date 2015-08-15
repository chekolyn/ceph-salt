# -*- mode: ruby -*-
# vi: set ft=ruby :

# Common configuration file for libvirt hypervisor
# this file was created to not repeat the configuration portion of libvirt in different scenarios
# the intent is not to use it on its own but to be imported in other Vagranfiles.

Vagrant.configure("2") do |config|

  # Testing for nugrant local file:
  unless File.exist?(File.expand_path("~/.vagrantuser"))
    puts "**** PLEASE install and configure the vagrant nugrant plugin *****"
    puts "**** File missing: looking for %s *****" % [ File.expand_path("~/.vagrantuser") ]
  end

  # NOTE: Using Vagrant nugrant plugin to abstract the hipervisor settings
  # Options for libvirt vagrant provider.
  config.vm.provider :libvirt do |libvirt|

    # VMs general settings
    # Memory:
    if config.user.libvirt.has_key?(:memory)
      libvirt.memory = config.user.libvirt.memory
    else
      libvirt.memory = 1024
    end
    # CPUs:
    if config.user.libvirt.has_key?(:cpus)
      libvirt.cpus = config.user.libvirt.cpus
    else
      libvirt.cpus = 1
    end
    # Video:
    if config.user.libvirt.has_key?(:video_type)
      libvirt.video_type = config.user.libvirt.video_type
    else
      libvirt.video_type = "vga"
    end

    # Diskbus:
    if config.user.libvirt.has_key?(:disk_bus)
      libvirt.disk_bus = config.user.disk_bus
    else
      libvirt.disk_bus = "virtio"
    end

    # A hypervisor name to access. Different drivers can be specified, but
    # this version of provider creates KVM machines only. Some examples of
    # drivers are kvm (qemu hardware accelerated), qemu (qemu emulated),
    # xen (Xen hypervisor), lxc (Linux Containers),
    # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
    # documentation for available drivers (http://libvirt.org/drivers.html).

    if config.user.libvirt.has_key?(:driver)
      libvirt.driver = config.user.libvirt.driver
    else
      libvirt.driver = "kvm"
    end

    # IMPORTANT support netsted virtualization:
    if config.user.libvirt.has_key?(:nested)
      libvirt.nested = config.user.libvirt.nested
    else
      libvirt.nested = "True"
    end

    # CPU Mode What cpu mode to use for nested virtualization. Defaults to 'host-model' if not set.
    if config.user.libvirt.has_key?(:cpu_mode)
      libvirt.cpu_mode = config.user.libvirt.cpu_mode
    end

    # The name of the server, where libvirtd is running.
    if config.user.libvirt.has_key?(:host)
      libvirt.host = config.user.libvirt.host
    end

    # Localhost change uri:
    # Will override most other settings
    if config.user.libvirt.has_key?(:uri)
      libvirt.uri = config.user.libvirt.uri
    end

    # If use ssh tunnel to connect to Libvirt.
    if config.user.libvirt.has_key?(:connect_via_ssh)
      libvirt.connect_via_ssh = config.user.libvirt.connect_via_ssh
    end

    # The username and password to access Libvirt. Password is not used when
    # connecting via ssh.
    if config.user.libvirt.has_key?(:username)
      libvirt.username = config.user.libvirt.username
    end

    if config.user.libvirt.has_key?(:password)
      libvirt.username = config.user.libvirt.password
    end

    # Libvirt storage pool name, where box image and instance snapshots will be stored.
    # Do you ramdisk? ;)
    if config.user.libvirt.has_key?(:storage_pool_name)
      libvirt.storage_pool_name = config.user.libvirt.storage_pool_name
    else
      libvirt.storage_pool_name = "default"
    end

    # Set a prefix for the machines that's different than the project dir name.
    if config.user.libvirt.has_key?(:default_prefix)
      libvirt.default_prefix = config.user.libvirt.default_prefix
    end
  end

end
