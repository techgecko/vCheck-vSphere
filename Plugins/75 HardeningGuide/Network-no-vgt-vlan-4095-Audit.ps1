# Start of Settings 
# End of Settings

$MyCollection = @()

$vpg = Get-VirtualPortGroup | where {$_.Name -notlike "DVUplinks-*"}
$vpc = $vpg.count

$vminfo = Get-VirtualPortGroup | Select VirtualSwitch, Name, VlanID | where {$_.VlanID -eq 4095}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name -ne $null -and $vmtemp.Name.substring(0,10) -ne "DVUplinks-"){
		$Details = New-object PSObject
		$Details | Add-Member -Name VirtualSwitch -Value $vmtemp.VirtualSwitch -Membertype NoteProperty
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name VlanID -Value $vmtemp.VlanID -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vpc Port Groups Passed - VLAN ID 4095 unused ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-no-vgt-vlan-4095"
$Header = "Harden vNetwork (Audit only): Ensure that port groups are not configured to VLAN 4095 except for Virtual Guest Tagging (VGT)."
$Comments = "vNetwork no-vgt-vlan-4095: When a port group is set to VLAN 4095, this activates VGT mode. In this mode, the vSwitch passes all network frames to the guest VM without modifying the VLAN tags, leaving it up to the guest to deal with them. VLAN 4095 should be used only if the guest has been specifically configured to manage VLAN tags itself. If VGT is enabled inappropriately, it might cause denial of service or allow a guest VM to interact with traffic on an unauthorized VLAN."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
