Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end
  config.vm.network "private_network", ip: "192.168.50.5"
  config.vm.provision "shell", path: "setup.sh"
end