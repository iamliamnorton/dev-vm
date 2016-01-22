# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # using official ubuntu 14.04 install as the docker host
  config.vm.box = "ubuntu/trusty64"

  # internal ip to avoid needing nat
  config.vm.network :private_network, ip: "192.168.21.11"

  # share a folder to hold projects into the vm
  config.vm.synced_folder "./", "/vagrant",
    type:          "nfs",
    create:        true,
    mount_options: ["vers=3", "udp", "nolock"]

  # dont  automatically insert an insecure keypair to use for SSH
  config.ssh.insert_key = false

  # use agent forwarding for ssh/git etc
  config.ssh.forward_agent = true

  # provisioner script, using skittle internally
  config.vm.provision :shell,
    privileged: false,
    inline:     "(cd /vagrant && ./provision.sh)"

  # give the vm 2 gigabytes of ram
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
