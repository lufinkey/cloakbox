
Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/xenial32"

	config.vm.provider "virtualbox" do |vb|
		vb.name = "cloakbox"
		vb.gui = false
		vb.memory = "2048"
	end

	config.ssh.insert_key = true

	config.vm.synced_folder "./shared", "/shared"

	config.vm.provision "file", source: "tools", destination: "/tmp/tools"
	config.vm.provision "file", source: "daemons", destination: "/tmp/daemons"

	config.vm.provision "shell", path: "scripts/vagrant-setup.sh"
end

