
# default config values
aria2_port=6803

# read config values
open("shared/.cloakbox/cloakbox.conf") { |f| f.each_with_index do |line, i|
	line.strip!

	# strip comment
	if line =~ /^(.*)#/
		line=$1
	end

	if line =~ /^\s*(.*)\s*=\s*(.*)\s*$/
		config_key=$1
		config_value=$2
		if config_key == "aria2-port"
			if config_value =~ /^[0-9]+$/
				aria2_port=config_value
			else
				STDERR.puts "invalid config value for aria2-port"
			end
		end
	end
end }

Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/xenial32"

	config.vm.define "cloakbox" do |cloakbox|
	end

	config.vm.provider "virtualbox" do |vb|
		vb.name = "cloakbox"
		vb.gui = false
		vb.memory = "2048"
	end

	config.vm.network "forwarded_port", guest: 6800, host: aria2_port, protocol: "tcp"

	config.ssh.insert_key = true

	config.vm.synced_folder "./shared", "/shared", type: "sshfs", create: true

	config.vm.provision "file", source: "provision/tools", destination: "/tmp/tools"
	config.vm.provision "file", source: "provision/daemons", destination: "/tmp/daemons"

	config.vm.provision "shell", path: "provision/scripts/vagrant-setup.sh"
	config.vm.provision "shell", path: "provision/scripts/daemons-start.sh", run: "always"
end

