# Start of Settings 
# End of Settings

$MyCollection = @()

$vs = Get-VirtualSwitch
$vsc = $vs.count

$vminfo = Get-VirtualSwitch | Select VMHost, Name, @{N="ForgedTransmits";E={if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } else { "Reject"} }} | where {$_.ForgedTransmits -ne "Reject"}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name VMHost -Value $vmtemp.VMHost -Membertype NoteProperty
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name ForgedTransmits -Value $vmtemp.ForgedTransmits -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vsc Switches Passed - Set to Reject ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-reject-forged-transmit"
$Header = "Harden vNetwork (Audit only): Ensure that the 'Forged Transmits' policy is set to reject."
$Comments = "vNetwork reject-forged-transmit: If the virtual machine operating system changes the MAC address, the operating system can send frames with an impersonated source MAC address at any time. This allows an operating system to stage malicious attacks on the devices in a network by impersonating a network adaptor authorized by the receiving network. Forged transmissions should be set to accept by default. This means the virtual switch does not compare the source and effective MAC addresses. To protect against MAC address impersonation, all virtual switches should have forged transmissions set to reject."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
