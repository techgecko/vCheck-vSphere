# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name,@{N="Lockdown";E={$_.Extensiondata.Config.adminDisabled}}
	if($vminfo.Lockdown -ne $true){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name Lockdown -Value $vminfo.Lockdown -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-enable-lockdown-mode"
$Header = "Harden ESXi (Audit only): Enable lockdown mode to restrict remote access."
$Comments = "ESXi enable-lockdown-mode: Enabling lockdown mode disables direct access to an ESXi host requiring the host be managed remotely from vCenter Server. Lockdown limits ESXi host access to the vCenter server. This is done to ensure the roles and access controls implemented in vCenter are always enforced and users cannot bypass them by logging into a host directly. By forcing all interaction to occur through vCenter Server, the risk of someone inadvertently attaining elevated privileges or performing tasks that are not properly audited is greatly reduced. Note: Lockdown mode does not apply to users who log in using authorized keys. When you use an authorized key file for root user authentication, root users are not prevented from accessing a host with SSH even when the host is in lockdown mode. Note that users listed in the DCUI.Access list for each host are allowed to override lockdown mode and login to the DCUI. By default the root user is the only user listed in the DCUI.Access list."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
