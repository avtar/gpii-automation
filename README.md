GPII Automation
===============

Run the GPII automated tests in a virtual machine.

Tested against Windows 8.1 64-bit in VirtualBox running on a Windows 7 host with PowerShell 4.

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

Provision a Windows VM
----------------------

### Manual Steps

Set up a Windows VM with:

* An Administrator user
* `Enable-PSRemoting -Force`
* Set WinRM service startup to Automatic
* Install Git
* Install Nodejs
* Install MinGW
* Install the Microsoft Visual C++ Redistributable Package (x86)
* Install Java JRE 7

### Take a snapshot

Take a snapshot here, so that you can revert to this point to re-run the provisioning script.

### Run the provisioning script

```
Provision-WinVM.ps1 <ComputerName> <Credential>
```

For example:

```
Provision-WinVM.ps1 1.1.1.1 $(Get-Credential AdminUser)
```

### Take a snapshot

This will be the starting point for each test run.

Run the tests
-------------

### Start up the VM

Start up a Windows VM, provisioned as described above.

### Prepare the test environment

```
Prepare-TestEnvWinVM.ps1 <ComputerName> <Credential> <JenkinsMasterUrl> <JenkinsSlaveName>
```

For example:

```
Prepare-TestEnvWinVM.ps1 1.1.1.1 $(Get-Credential AdminUser) http://2.2.2.2:8080/ WindowsVM
```

This will:

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
