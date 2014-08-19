GPII Automation
===============

Run the GPII automated tests in a virtual machine.

Tested against Windows 8.1 64-bit in VirtualBox running on a Windows 7 host with PowerShell 4.

Prepare a Vagrant VirtualBox base box
-------------------------------------

### Manual Steps

Set up a VirtualBox Windows VM:

* Create a vagrant user
  * An Administrator
  * username: vagrant
  * password: vagrant
* Disable UAC for the vagrant user
* `Enable-PSRemoting -Force`
* Install Git
* Install Nodejs
* Update npm to version 1.4
* Install grunt-cli
* Install MinGW
* Install the Microsoft Visual C++ Redistributable Package (x86)
* Install Java JRE 7

### Configure WinRM for Vagrant

```
winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
sc config WinRM start= auto
```

See https://github.com/WinRb/vagrant-windows

### Edit the firewall

* Edit Firewall rules to allow "Windows Remote Management" on Public networks

### Package the VM

```
vagrant package --base NAME --output GPIIWin8.box
vagrant box add GPIIWin8 GPIIWin8.box
```

Set Up Jenkins
--------------

### Add a WindowsVM node

Add a new "Dumb Slave" node:

* Name: WindowsVM
* Remote root directory: C:\Jenkins
* Usage: Leave this node for tied jobs only
* Launch method: Launce slave agents via Java Web Start

### Add a "Test GPII" job

Add a "Build a free-style software project" job to run the tests:

* Name: Test GPII
* Restrict where this project can be run: WindowsVM

For build, use a Windows batch command:

```
powershell.exe -ExecutionPolicy RemoteSigned -File C:\Users\GPIITestUser\gpii-automation\Test-GPII.ps1
```

Run the tests
-------------

### Configuration

Set the following environment variables:

* GPII_JENKINS_MASTER_URL
* GPII_JENKINS_SLAVE_NAME

### Start up the VM and prepare the test environment

```
vagrant up
vagrant reload
```

These commands will:

* Create the GPIITestUser
* Configure a logon script for GPIITestUser and set Windows to log in to that user on startup
* Restart the machine
* On startup, log in GPIITestUser, and start the Jenkins slave agent

### Run the tests

On the master Jenkins, run the "Test GPII" job.

TODO
----

* Move everything that we can move to the provisioning script -- minimize what needs to be installed by hand
* Use the Jenkins Job Builder to configure Jenkins
* Automate starting the Windows VM and running the Prepare-TestEnvWinVM.ps1 script from Jenkins so that running the tests is a single button push on Jenkins
* jqUnit-node.js.patch is a temporary hack -- the proper fix is to modify jqUnit-node.js to make color optional or only if running on a tty and hopefully https://github.com/joyent/node/issues/3584 is fixed on latest Nodejs
