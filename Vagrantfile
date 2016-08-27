
Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/xenial32"

	config.vm.define "cloakbox" do |cloakbox|
	end

	config.vm.provider "virtualbox" do |vb|
		vb.name = "cloakbox"
		vb.gui = false
		vb.memory = "2048"
	end

	config.ssh.insert_key = true

	config.vm.synced_folder "./shared", "/shared", type: "sshfs", create: true

	config.vm.provision "file", source: "provision/tools", destination: "/tmp/tools"
	config.vm.provision "file", source: "provision/daemons", destination: "/tmp/daemons"

	config.vm.provision "shell", path: "provision/scripts/vagrant-setup.sh"
end

