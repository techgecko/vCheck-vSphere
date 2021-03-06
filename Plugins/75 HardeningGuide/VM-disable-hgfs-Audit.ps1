# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.tools.hgfsServerSet.disable" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq "false")){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name hgfsServerSet -Value $vminfo.Value -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - HGFS disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-hgfs"
$Header = "Harden VM: Disable HGFS file transfers"
$Comments = "VM disable-hgfs: Certain automated operations such as automated tools upgrades use a component into the hypervisor called 'Host Guest File System' and an attacker could potentially use this to transfer files inside the guest OS"
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
