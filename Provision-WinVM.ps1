Param (
    [Parameter(Mandatory=$True)] [String]$ComputerName,
    [Parameter(Mandatory=$True)] [PSCredential]$Credential
)

$s = New-PSSession -ComputerName $ComputerName -Credential $Credential

Invoke-Command -Session $s -ScriptBlock {
    # Add a Firewall exception for Nodejs
    netsh advfirewall firewall add rule name="Nodejs" dir=in action=allow program="C:\Program Files (x86)\nodejs\node.exe" enable=yes

    # Disable UAC
    # reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_SZ /d 0 /f
}

Remove-PSSession $s
