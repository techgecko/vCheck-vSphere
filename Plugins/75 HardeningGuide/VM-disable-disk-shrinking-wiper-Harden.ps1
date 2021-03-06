# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.tools.diskWiper.disable" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq "false")){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "isolation.tools.diskWiper.disable" -value $true -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Disk shrinking disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-disk-shrinking-wiper"
$Header = "Harden VM (Audit & Remediate): Disable virtual disk shrinking."
$Comments = "VM disable-disk-shrinking-wiper: Shrinking a virtual disk reclaims unused space in it. If there is empty space in the disk, this process reduces the amount of space the virtual disk occupies on the host drive. Normal users and processes—that is, users and processes without root or administrator privileges—within virtual machines have the capability to invoke this procedure. However, if this is done repeatedly, the virtual disk can become unavailable while this shrinking is being performed, effectively causing a denial of service. in most datacenter environments, disk shrinking is not done, so you should disable this feature. Repeated disk shrinking can make a virtual disk unavailable. Capability is available to nonadministrative users in the guest."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
