# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "pools.io"

  ## Standup scripts...
  config.vm.provision :shell, :path => "scripts/standup/mute_ssh.sh"
  config.vm.provision :shell, :path => "scripts/standup/bootstrap.sh"

  # Visit the site at http://192.168.50.66
  config.vm.network :private_network, ip: "192.168.50.31"

  # Requires: vagrant plugin install vagrant-vbguest
  config.vbguest.auto_update = false

  # Required for passing ssh keys
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.name = "FPMPools"
  end
end
