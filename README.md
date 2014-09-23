GPII Automation
===============

Run the GPII automated tests in a virtual machine.

Tested against Windows 8.1 64-bit in VirtualBox running on a Windows 7 host with PowerShell 4.

Prepare a Windows VM
--------------------

### Manual Steps

Set up a Windows VM:

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

### Edit the Firewall

* Edit the Firewall rules to allow "Windows Remote Management" on Public networks

### Configure OpenSSH

* Configure OpenSSH

Set Up Jenkins
--------------

### Running Jenkins

Jenkins needs to be run as a user that can start VirtualBox with a GUI. On Windows, I'm running Jenkins from the command line as a logged-in user, rather than as a service.

### Install Plugins

* Git Plugin
* Multijob Plugin

### Add a gpii-win-8.1 node

Add a new "Dumb Slave" node:

* Name: gpii-win-8.1
* # of executors: 1
* Remote root directory: C:\Jenkins
* Usage: Leave this node for tied jobs only
* Launch method: Launce slave agents via Java Web Start

### Configure security

Enable security and configure:

* An admin user
* Anonymous users get a read only view

### Environment variables

Set the following environment variables:

* GPII_WIN81_COMPUTER_NAME
* GPII_WIN81_ADMIN_USER
* GPII_WIN81_RESTORE_POINT
* GPII_JENKINS_MASTER_URL (such as http://1.2.3.4:8080/)
* GPII_JENKINS_SLAVE_NAME = "gpii-win-8.1"
* GPII_JENKINS_JNLP_CREDENTIALS = credentials for a user with access to connect from the slave

### Configure Jenkins jobs with Jenkins Job Builder

From the gpii-automation directory:

```
jenkins-jobs update jenkins
```

Run the tests
-------------

* test-gpii-win-8.1
