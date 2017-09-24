❯ cat Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

Vagrant.configure("2") do |config|
  config.vm.box = "kali-linux-2017-W39-amd64"
  config.ssh.username = "root"
  config.ssh.private_key_path = "/Users/user/.ssh/root-private"

  config.vm.provider "vmware_fusion" do |v|
    v.gui = true
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
    v.vmx["displayName"] = "kali-linux-2017-W39-amd64"
    v.vmx["ide1:0.filename"] = ""
    v.vmx["sharedfolder.maxnum"] = "1"

    # shared folders
    v.vmx["sharedFolder0.present"] = "true"
    v.vmx["sharedFolder0.enabled"] = "true"
    v.vmx["sharedFolder0.readAccess"] = "true"
    v.vmx["sharedFolder0.writeAccess"] = "true"
    v.vmx["sharedFolder0.hostPath"] = "#{current_dir}/data"
    v.vmx["sharedFolder0.guestName"] = "data"
    v.vmx["sharedFolder0.expiration"] = "never"

    # networking
    # NAT is enabled if bridged is commented out
    v.vmx["ethernet0.connectiontype"] = "bridged"
  end
end
