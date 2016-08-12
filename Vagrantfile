
Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/xenial32"

	config.vm.provider "virtualbox" do |vb|
		vb.name = "Torrent Box"
		vb.gui = false
		vb.memory = "2048"
	end

	config.ssh.insert_key = true

	config.vm.synced_folder "./shared", "/shared"

	config.vm.provision "file", source: "scripts/whatismyip", destination: "/usr/local/bin/whatismyip"
	config.vm.provision "shell", path: "scripts/vagrant-setup.sh"
end
