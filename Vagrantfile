# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "Netbox-Demo"

  config.vm.provider :virtualbox do |vb|
    vb.name = "Netbox-Demo"
    vb.memory = 4096
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
  end

  config.vm.network :forwarded_port, guest: 80, host: 8080, id: 'http'
  config.vm.provision :shell, path: "bootstrap.sh"
end