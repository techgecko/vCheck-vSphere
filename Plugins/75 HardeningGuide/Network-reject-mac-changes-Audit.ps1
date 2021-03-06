# Start of Settings 
# End of Settings

$MyCollection = @()

$vs = Get-VirtualSwitch
$vsc = $vs.count

$vminfo = Get-VirtualSwitch | Select VMHost, Name, @{N="MacChanges";E={if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } else { "Reject"} }} | where {$_.MacChanges -ne "Reject"}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name VMHost -Value $vmtemp.VMHost -Membertype NoteProperty
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name MacChanges -Value $vmtemp.MacChanges -Membertype NoteProperty
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

$Title = "vNetwork-reject-mac-changes"
$Header = "Harden vNetwork (Audit only): Ensure that the 'MAC Address Change' policy is set to reject."
$Comments = "vNetwork reject-mac-changes: If the virtual machine operating system changes the MAC address, it can send frames with an impersonated source MAC address at any time. This allows it to stage malicious attacks on the devices in a network by impersonating a network adapter authorized by the receiving network. This will prevent VMs from changing their effective MAC address. It will affect applications that require this functionality. An example of an application like this is Microsoft Clustering, which requires systems to effectively share a MAC address. This will also affect how a layer 2 bridge will operate. This will also affect applications that require a specific MAC address for licensing. An exception should be made for the port groups where these applications are connected."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
