# Start of Settings 
# End of Settings

$MyCollection = @()

$vs = Get-VirtualSwitch
$vsc = $vs.count

$vminfo = Get-VirtualSwitch | Select VMHost, Name, @{N="PromiscuousMode";E={if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } else { "Reject"} }} | where {$_.PromiscuousMode -ne "Reject"}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name VMHost -Value $vmtemp.VMHost -Membertype NoteProperty
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name PromiscuousMode -Value $vmtemp.PromiscuousMode -Membertype NoteProperty
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

$Title = "vNetwork-reject-promiscuous-mode"
$Header = "Harden vNetwork (Audit only): Ensure that the 'Promiscuous Mode' policy is set to reject."
$Comments = "vNetwork reject-promiscuous-mode: When promiscuous mode is enabled for a virtual switch all virtual machines connected to the dvPortgroup have the potential of reading all packets across that network, meaning only the virtual machines connected to that dvPortgroup. Promiscuous mode is disabled by default on the ESXI Server, and this is the recommended setting. However, there might be a legitimate reason to enable it for debugging, monitoring or troubleshooting reasons. Security devices might require the ability to see all packets on a vSwitch. An exception should be made for the dvPortgroups that these applications are connected to, in order to allow for full-time visibility to the traffic on that dvPortgroup."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
