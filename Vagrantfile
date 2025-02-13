Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
  #config.vm.box_version = "8.11.1"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 4
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt update && apt upgrade -y

    apt-get install -y wget gnupg2 curl lsb-release

    echo "deb http://download.proxmox.com/debian/pve jessie pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
    curl -fsSL https://enterprise.proxmox.com/debian/proxmox-ve-release-6.x.gpg | tee /etc/apt/trusted.gpg.d/proxmox.asc

    apt-get update -y
    apt-get install -y proxmox-ve postfix open-iscsi

    systemctl enable pvedaemon
    systemctl start pvedaemon
    systemctl enable pve-cluster
    systemctl start pve-cluster

    reboot
  SHELL
end
