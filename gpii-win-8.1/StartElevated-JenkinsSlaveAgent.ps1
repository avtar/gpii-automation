Param (
    [Parameter(Mandatory=$True)] [String]$JenkinsJnlpUrl
)

Start-Process "C:\Program Files (x86)\Java\jre7\bin\java" -ArgumentList @("-jar", "slave.jar", "-jnlpUrl", $JenkinsJnlpUrl) -Verb RunAs
