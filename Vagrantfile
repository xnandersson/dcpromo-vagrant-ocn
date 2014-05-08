# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define "dc" do |dc|
    dc.vm.provision :shell, path: "provisioning-dc.sh"
    dc.vm.network "private_network", ip: "192.168.33.2",
      autoconfig: false
  end

  config.vm.define "realmd" do |realmd|
    realmd.vm.provision :shell, path: "provisioning-realmd.sh"
    realmd.vm.network "private_network", ip: "192.168.33.100",
      autoconfig: false
  end

  config.vm.define "ldap" do |ldap|
    ldap.vm.provision :shell, path: "provisioning-ldap.sh"
    ldap.vm.network "private_network", ip: "192.168.33.3",
      autoconfig: false
  end 

  config.vm.define "realmd_build" do |realmd_build|
    realmd_build.vm.provision :shell, path: "provisioning-realmd_build.sh"
    realmd_build.vm.network "private_network", ip: "192.168.33.4",
      autoconfig:true 
  end

end
