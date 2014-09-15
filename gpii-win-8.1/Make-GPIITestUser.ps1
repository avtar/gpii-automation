Param (
    [Parameter(Mandatory=$True)] [String]$JenkinsMasterUrl,
    [Parameter(Mandatory=$True)] [String]$JenkinsSlaveName,
    [Parameter(Mandatory=$True)] [String]$JenkinsJnlpCredentials
)

$testUserName = "GPIITestUser"
$testUserPassword = "password"

$logonScriptName = "OnLogon-${testUserName}.bat"

# *** NOTE ***
# We are running the Jenkins Slave Agent with elevated privileges. This is a
# workaround to enable the tests to run with elevated privileges. Elevated
# privileges are required to kill the Magnifier process on Windows 8 when
# using taskkill.exe. See:
# http://issues.gpii.net/browse/GPII-899 and
# http://issues.gpii.net/browse/GPII-12

$logonScriptContents = @"
%HOMEDRIVE%
cd %HOMEPATH%
git clone https://github.com/simonbates/gpii-automation
"C:\Program Files (x86)\Git\bin\curl.exe" -O ${JenkinsMasterUrl}jnlpJars/slave.jar
powershell.exe -ExecutionPolicy RemoteSigned -File gpii-automation\gpii-win-8.1\StartElevated-JenkinsSlaveAgent.ps1 ${JenkinsMasterUrl}computer/${JenkinsSlaveName}/slave-agent.jnlp ${JenkinsJnlpCredentials}
"@

# Create our test user

net user $testUserName $testUserPassword /add
net localgroup Administrators $testUserName /add

# Configure auto logon

reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d $testUserName /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d $testUserPassword /f

# Set up the logon script

New-Item -ItemType directory -Force C:\Windows\System32\Repl\Import\Scripts
Out-File -FilePath "C:\Windows\System32\Repl\Import\Scripts\$logonScriptName" -Encoding ASCII -InputObject $logonScriptContents
net user $testUserName /scriptpath:$logonScriptName
