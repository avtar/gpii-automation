GPII Automation
===============

Run the GPII automated tests in a virtual machine.

Tested against Windows 8.1 64-bit in VirtualBox running on a Windows 7 host with PowerShell 4.

Windows Image Requirements
--------------------------

Manually set up a Windows VM with:

* An Administrator user
* `Enable-PSRemoting -Force`
* Set WinRM service startup to Automatic
* Install Git
* Install Nodejs
* Install MinGW
* Install the Microsoft Visual C++ Redistributable Package (x86)
* Install Java JRE 7

Provision the VM
----------------

Start with a Windows image as described above. Then:

```
Provision-WinVM.ps1 <ComputerName> <Credential>
```

For example:

```
Provision-WinVM.ps1 1.2.3.4 $(Get-Credential AdminUser)
```

Run the tests
-------------

Start with a provisioned Windows image. Then:

```
Run-GPIITestsWinVM.ps1 <ComputerName> <Credential>
```

For example:

```
Run-GPIITestsWinVM.ps1 1.2.3.4 $(Get-Credential AdminUser)
```

This will:

* Create the GPIITestUser
* Configure a logon script for GPIITestUser and set Windows to log in to that user on startup
* Restart the machine
* On startup, log in GPIITestUser, grab GPII from GitHub, build, and run the tests

TODO
----

* Move everything that we can move to the provisioning script -- minimize what needs to be installed by hand
* Test result reporting
* jqUnit-node.js.patch is a temporary hack -- the proper fix is to modify jqUnit-node.js to make color optional or only if running on a tty and hopefully https://github.com/joyent/node/issues/3584 is fixed on latest Nodejs
