Param (
    [Parameter(Mandatory=$True)] [String]$ComputerName,
    [Parameter(Mandatory=$True)] [PSCredential]$Credential
)

$s = New-PSSession -ComputerName $ComputerName -Credential $Credential
Invoke-Command -Session $s -FilePath Make-GPIITestUser.ps1
Invoke-Command -Session $s -ScriptBlock { Restart-Computer }
Remove-PSSession $s
