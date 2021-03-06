# Start of Settings 
# Set the NTP (time servers) to use, surrounded by quotes and separated by a comma
$NTPServers = "0.north-america.pool.ntp.org,1.north-america.pool.ntp.org"
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="NTPSetting";E={$_ | Get-VMHostNtpServer}},@{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ |Where-Object {$_.key -eq "ntpd"}).Running}}
	if([string]$vminfo.NTPSetting -ne [string]$NTPServers -or $vminfo.ServiceRunning -eq $False){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name NTPSetting -Value $vminfo.NTPSetting -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | Add-VmHostNtpServer $NTPServers
			$null = Get-VmHostService -VMHost $vmtemp | Where-Object {$_.key -eq "ntpd"} | Restart-VMHostService -Confirm:$false | Out-Null
			$null = Set-VMHostService -HostService (Get-VMHostservice -VMHost $vmtemp | Where-Object {$_.key -eq "ntpd"}) -Policy "On"
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - NTP set to '$NTPServers' ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-config-ntp"
$Header = "Harden ESXi (Audit & Remediate): Configure NTP time synchronization"
$Comments = "ESXi config-ntp: By ensuring that all systems use the same relative time source (including the relevant localization offset), and that the relative time source can be correlated to an agreed-upon time standard (such as Coordinated Universal Time—UTC), you can make it simpler to track and correlate an intruder’s actions when reviewing the relevant log files. Incorrect time settings can make it difficult to inspect and correlate log files to detect attacks, and can make auditing inaccurate."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"

