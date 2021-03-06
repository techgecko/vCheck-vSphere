# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "log.rotateSize" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -ne "100000")){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "log.rotateSize" -value "100000" -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - 1MB log size set ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-limit-log-size"
$Header = "Harden VM (Audit & Remediate): Limit VM logging"
$Comments = "VM limit-log-size: You can use these settings to limit the total size and number of log files. Normally a new log file is created only when a host is rebooted, so the file can grow to be quite large. You can ensure that new log files are created more frequently by limiting the maximum size of the log files. if you want to restrict the total size of logging data, VMware recommends saving 10 log files, each one limited to 1,000KB. Datastores are likely to be formatted with a block size of 2MB or 4MB, so a size limit too far below this size would result in unnecessary storage utilization. Each time an entry is written to the log, the size of the log is checked; if it is over the limit, the next entry is written to a new log. if the maximum number of log files already exists, when a new one is created, the oldest log file is deleted. A denial-of-service attack that avoids these limits might be attempted by writing an enormous log entry. But each log entry is limited to 4KB, so no log files are ever more than 4KB larger than the configured limit. A second option is to disable logging for the virtual machine. Disabling logging for a virtual machine makes troubleshooting challenging and support difficult. You should not consider disabling logging unless the log file rotation approach proves insufficient. Uncontrolled logging can lead to denial of service due to the datastore's being filled."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
