# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="LogDir";E={$_ | Get-AdvancedSetting Syslog.global.logDir | Select -ExpandProperty Value}}
	if($vminfo.LogDir -ne "[] /scratch/log"){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name LogDir -Value $vminfo.LogDir -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name Syslog.global.logDir -Value "/scratch"
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - All point to /scratch/log ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-config-persistent-logs"
$Header = "Harden ESX (Audit & Remediate): Configure persistent logging for all ESXi host"
$Comments = "ESXi config-persistent-logs: ESXi can be configured to store log files on an in-memory file system. This occurs when the host's '/scratch' directory is linked to '/tmp/scratch'. When this is done only a single day's worth of logs are stored at any time, in addition log files will be reinitialized upon each reboot. This presents a security risk as user activity logged on the host is only stored temporarily and will not persist across reboots. This can also complicate auditing and make it harder to monitor events and diagnose issues. ESXi host logging should always be configured to a persistent datastore."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
