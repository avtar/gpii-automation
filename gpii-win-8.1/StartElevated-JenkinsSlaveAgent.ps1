Param (
    [Parameter(Mandatory=$True)] [String]$JenkinsJnlpUrl,
    [Parameter(Mandatory=$True)] [String]$JenkinsJnlpCredentials
)

Start-Process "C:\Program Files (x86)\Java\jre7\bin\java" -ArgumentList @("-jar", "slave.jar", "-jnlpUrl", $JenkinsJnlpUrl, "-jnlpCredentials", $JenkinsJnlpCredentials) -Verb RunAs
