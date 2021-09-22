Vagrant.configure(2) do |config|
    config.vm.network "private_network", bridge: "Default Switch"
    config.vm.define :main do |main|
      main.vm.host_name = "main"
      main.vm.box = "hashicorp/bionic64"
  
      main.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 2
      end
      main.vm.provider :hyperv do |hv|
        hv.memory = 4096
        hv.cpus = 2
      end

      main.vm.synced_folder "./sync", "/var/sync", smb_username: ENV['SMB_USERNAME'], smb_password: ENV['SMB_PASSWORD']
     
      main.vm.provision :shell, privileged: true, path: "main.sh"
    end
  
    config.vm.define :linuxworker do |linuxworker|
      linuxworker.vm.host_name = "linuxworker"
      linuxworker.vm.box = "hashicorp/bionic64"
  
      linuxworker.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 2
      end
      linuxworker.vm.provider :hyperv do |hv|
        hv.linked_clone = true
        hv.memory = 4096        
        hv.cpus = 2
      end

      linuxworker.vm.synced_folder "./sync", "/var/sync", smb_username: ENV['SMB_USERNAME'], smb_password: ENV['SMB_PASSWORD']
      linuxworker.vm.provision :shell, privileged: true, path: "linuxworker.sh"
    end

    config.vm.define :winworker do |winworker|
      winworker.vm.host_name = "winworker"
      winworker.vm.box = "StefanScherer/windows_2019_docker"
      winworker.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 2
        vb.gui = true
      end 
      winworker.vm.provider :hyperv do |hv, override|  
        hv.linked_clone = true  
        hv.memory = 4096
        hv.cpus = 2
        override.vm.boot_timeout = 600
      end
     
      winworker.vm.synced_folder "./sync", "C:/sync", smb_username: ENV['SMB_USERNAME'], smb_password: ENV['SMB_PASSWORD']
      winworker.vm.provision :shell, privileged: true, path: "winworker.ps1"
    end
    
  end