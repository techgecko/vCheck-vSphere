# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "ethernetn.filtern.name*" | Select Entity, Value
	if($vminfo.Value -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Feature unused ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-verify-network-filter"
$Header = "Harden VM (Audit only): Control access to VMs through the dvfilter network APIs."
$Comments = "VM verify-network-filter: A VM must be configured explicitly to accept access by the dvfilter network API. This should be done only for VMs for which you want this to be done. An attacker might compromise the VM by making use of this introspection channel."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
