Param (
    [Parameter(Mandatory=$True)] [String]$ComputerName,
    [Parameter(Mandatory=$True)] [PSCredential]$Credential,
    [Parameter(Mandatory=$True)] [String]$JenkinsMasterUrl,
    [Parameter(Mandatory=$True)] [String]$JenkinsSlaveName
)

$s = New-PSSession -ComputerName $ComputerName -Credential $Credential
Invoke-Command -Session $s -FilePath Make-GPIITestUser.ps1 -ArgumentList $JenkinsMasterUrl,$JenkinsSlaveName
Invoke-Command -Session $s -ScriptBlock { Restart-Computer }
Remove-PSSession $s
