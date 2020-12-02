#New-Variable -Name "EC2ID" -Value "i-055d051b1632c99a1"
#New-Variable -Name "RDSName" ""
#New-Variable -Name "DevStatus" -Value (Get-EC2Instance $EC2ID).Instances.State.Name

$EC2ID = "i-055d051b1632c99a1"
$RDSName = ""
$DevStatus = (Get-EC2Instance $EC2ID).Instances.State.Name

if ($DevStatus -eq "stopped") 
{ 
    Write-Output (-join("EC2 Instance ",  $EC2ID, "is stopped - starting it now"))
    Start-EC2Instance -InstanceId $EC2ID 
} 
else 
{
    Write-Output (-join("EC2Instnace:", $EC2ID, " is already running"))
}

$Timeout = 60
$timer = [Diagnostics.StopWatch]::StartNew()
while (($timer.elapsed.TotalSeconds -lt $Timeout) -and ((Get-EC2Instance $EC2ID).Instances.State.Name -ne "running"))
{
   Start-Sleep -Seconds 1
   Write-Output (-join("Wating for server:", $EC2ID, " to be in a running state"))
}
$timer.Stop()
Write-Output (-join("Server: ", $EC2ID, " is up and running!"))
Set-Variable -Name "RDSName" -Value (Get-EC2Instance $EC2ID).Instances | Select-Object PublicDnsName
$RDSName.PublicIpAddress
mstsc /v:($RDSName.PublicIpAddress)

#Stop-EC2Instance -InstanceId i-055d051b1632c99a1 
remove-variable DevStatus
remove-variable EC2ID
remove-variable RDSName