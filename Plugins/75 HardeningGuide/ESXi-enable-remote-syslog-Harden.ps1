# Start of Settings
# Set your Syslog servers, separated by commas
$SyslogServers = "192.168.10.10,192.168.10.11"
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="SyslogSvr";E={$_ | Get-AdvancedSetting Syslog.global.logHost | Select -ExpandProperty Value}}
	if($vminfo.SyslogSvr -ne $SyslogServers){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name SyslogSvr -Value $vminfo.SyslogSvr -Membertype NoteProperty
		$MyCollection += $Details
#		if($ScriptType -eq "Remediate"){
#			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name Syslog.global.logHost -Value $SyslogServers
#		}
	}
}


if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - Syslog set to '$SyslogServers' ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-enable-remote-syslog"
$Header = "Harden ESX (Audit only): Configure remote logging for ESXi hosts"
$Comments = "ESXi enable-remote-syslog: Remote logging to a central log host provides a secure, centralized store for ESXi logs. By gathering host log files onto a central host you can more easily monitor all hosts with a single tool. You can also do aggregate analysis and searching to look for such things as coordinated attacks on multiple hosts. Logging to a secure, centralized log server also helps prevent log tampering and also provides a long-term audit record. To facilitate remote logging provides the vSphere Syslog Collector. The list of Syslog servers should be appropriate for each physical site."
$Author = "Greg Hatch"
$PluginVersion = 1.3
$PluginCategory = "vSphere"
