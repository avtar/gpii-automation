GPII Automation
===============

Run the GPII automated tests in a virtual machine.

Tested against Windows 8.1 64-bit in VirtualBox running on a Windows 7 host with PowerShell 4.

Prepare a Windows VM
--------------------

### Install software

Install the following dependencies:

* Git
* Nodejs 0.8.25 32-bit
* MinGW
* Microsoft Visual C++ 2010 Redistributable Package (x86)
* Java JRE 7

### Update npm to version 1.4 or higher and install grunt-cli

With Nodejs 0.8.25 installed:

* Delete the npm that comes with that version of Node
    * C:\Program Files (x86)\nodejs\npm
    * C:\Program Files (x86)\nodejs\npm.cmd
    * C:\Program Files (x86)\nodejs\node_modules\npm
* Grab npm-1.4.9.zip from http://nodejs.org/dist/npm/
* Copy the npm 1.4.9 files into C:\Program Files (x86)\nodejs
* Now we have a working recent npm and we can use npm to update itself: npm install -g npm (need to run as an Administrator)
* npm install -g grunt-cli (run as an Administrator)

### Install and configure OpenSSH

The following configuration is based on the one used by https://github.com/joefitzgerald/packer-windows/blob/master/scripts/openssh.ps1

The OpenSSH service for Windows can be downloaded from:

* http://www.mls-software.com/opensshd.html

Configure OpenSSH:

* Publickey authentication will not work with the default setup of running the OpenSSH Server as a system user (seteuid error); the easiest fix is to change the OpenSSH Server service to run as the user we want to log in as -- see https://cygwin.com/cygwin-ug-net/ntsec.html section "Switching the user context without password" for a discussion of the issue
* To use publickey authentication, add the public key to ~/.ssh/authorized_keys
* Edit /etc/sshd_config:

```
StrictModes no
PubkeyAuthentication yes
PasswordAuthentication no
```

### Increase the disk space limit for Restore Points

Windows has a limit on the amount of disk space used by restore points. If the limit is exceeded, restore points will be deleted. Windows will sometimes create Restore Points automatically and if a new Restore Point pushes the disk space used over the limit, we will lose our manually created Restore Point (discussed below).

Through the GUI, this can be done with the following:

* System control panel
* Open System Protection
* Click Configure
* Adjust the Max Usage to 10 GB

### Make a Restore Point

Create a Restore Point and make a note of its number. We will use this Restore Point at the end of the build to reset the machine back to this known state. The Restore Point number can be retrieved using the following PowerShell command (run as Administrator):

```
Get-ComputerRestorePoint
```

Set Up Jenkins
--------------

### Install Plugins

* Git Plugin
* Multijob Plugin
* Groovy Plugin

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

### Configure publickey ssh login from the Jenkins machine to the Windows VM

On the Jenkins machine, add the Windows VM keypair to ~/.ssh directory of the user running the Jenkins service. And create a ~/.ssh/config file to specify that the keypair be used when connecting to the Windows VM.

### Configure Jenkins jobs with Jenkins Job Builder

Install the Jenkins Job Builder and upgrade six with pip:

```
sudo pip install jenkins-job-builder
sudo pip install --upgrade six
```

Create a Jenkins Job Builder configuration file at: `/etc/jenkins_jobs/jenkins_jobs.ini`:

```
[jenkins]
user=JENKINS_ADMIN_USER
password=JENKINS_ADMIN_API_TOKEN
url=http://localhost:8080/
```

The JENKINS_ADMIN_API_TOKEN can be retrieved through the Jenkins GUI: People page, click on the user, go to Configure, and click "Show API Token".

Run the Jenkins Job Builder in the gpii-automation directory:

```
jenkins-jobs update jenkins
```

Run the tests
-------------

* test-gpii-win-8.1
