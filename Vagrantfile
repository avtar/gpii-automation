VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "GPIIWin8"
  config.vm.guest = :windows

  config.vm.communicator = "winrm"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end

  config.vm.provision "shell", path: "Provision-WinVM.ps1"

  config.vm.provision "shell" do |s|
    s.path = "Make-GPIITestUser.ps1"
    s.args = "#{ENV['GPII_JENKINS_MASTER_URL']} #{ENV['GPII_JENKINS_SLAVE_NAME']}"
  end
end
