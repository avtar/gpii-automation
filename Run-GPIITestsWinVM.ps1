Param (
    [Parameter(Mandatory=$True)] [String]$ComputerName,
    [Parameter(Mandatory=$True)] [PSCredential]$Credential
)

$s = New-PSSession -ComputerName $ComputerName -Credential $Credential
Invoke-Command -Session $s -FilePath Make-GPIITestUser.ps1
New-PSDrive -Name R -PSProvider filesystem -Root "\\${ComputerName}\c`$" -Credential $Credential
Copy-Item OnLogon-GPIITestUser.ps1 R:\Windows\System32\Repl\Import\Scripts\
Remove-PSDrive -Name R
Invoke-Command -Session $s -ScriptBlock { Restart-Computer }
Remove-PSSession $s
