# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define "dc" do |dc|
    dc.vm.provision :shell, path: "dcpromo-repo.sh"
    dc.vm.network "private_network", ip: "192.168.33.2",
      autoconfig: false
  end

  config.vm.define "client" do |client|
    client.vm.provision :shell, path: "client.sh"
    client.vm.network "private_network", ip: "192.168.33.100",
      autoconfig: false
  end

end
