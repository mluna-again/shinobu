# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.ssh.keep_alive = true
  config.vm.provider "libvirt" do |vb|
    vb.memory = "4096"
  end
  config.vm.hostname = "navi"
  config.vm.provision "shell", privileged: false, keep_color: true, path: "./init.sh", name: "navi"
end
