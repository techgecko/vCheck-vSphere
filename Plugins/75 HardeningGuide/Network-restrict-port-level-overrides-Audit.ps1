# Start of Settings 
# End of Settings

$MyCollection = @()

$vpg = Get-VDPortgroup
$vpc = $vpg.count

$vminfo = Get-VDPortgroup | Get-VDPortgroupOverridePolicy | Select VDPortgroup, BlockOverrideAllowed, SecurityOverrideAllowed, VlanOverrideAllowed, TrafficShapingOverrideAllowed, UplinkTeamingOverrideAllowed, ResetPortConfigAtDisconnect | where {(($_.TrafficShapingOverrideAllowed -eq $True) -or ($_.SecurityOverrideAllowed -eq $True) -or ($_.VlanOverrideAllowed -eq $True) -or ($_.UplinkTeamingOverrideAllowed -eq $True))}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.VDPortgroup -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name VDPortgroup -Value $vmtemp.VDPortgroup -Membertype NoteProperty
		$Details | Add-Member -Name TrafficShapingOverrideAllowed -Value $vmtemp.TrafficShapingOverrideAllowed -Membertype NoteProperty
		$Details | Add-Member -Name SecurityOverrideAllowed -Value $vmtemp.SecurityOverrideAllowed -Membertype NoteProperty
		$Details | Add-Member -Name VlanOverrideAllowed -Value $vmtemp.VlanOverrideAllowed -Membertype NoteProperty
		$Details | Add-Member -Name UplinkTeamingOverrideAllowed -Value $vmtemp.UplinkTeamingOverrideAllowed -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vpc DVS Port Groups Passed - No overrides set ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-restrict-port-level-overrides"
$Header = "Harden vNetwork (Audit only): Restrict port-level configuration overrides on VDS "
$Comments = "vNetwork restrict-port-level-overrides: Port-level configuration over-rides are disabled by default. Once enabled, this allows for different security settings to be set from what is established at the Port-Group level. There are cases where particular VM's require unique configurations, but this should be monitored so it is only used when authorized. If over-rides are not monitored, anyone who gains access to a VM with a less secure VDS configuration could surreptiously exploit that broader access."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
