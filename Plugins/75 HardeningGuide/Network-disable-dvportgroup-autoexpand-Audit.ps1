# Start of Settings 
# End of Settings

$MyCollection = @()

$vpg = Get-VDPortgroup | where {$_.Name.substring(0,10) -ne "DVUplinks-"}
$vpc = $vpg.count

$vminfo = Get-VDPortGroup | Select Name, NumPorts, @{N="AutoExpand";E={$_.ExtensionData.Config.AutoExpand}} | where {$_.AutoExpand -ne $false}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name.substring(0,10) -ne "DVUplinks-"){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name NumPorts -Value $vmtemp.NumPorts -Membertype NoteProperty
		$Details | Add-Member -Name AutoExpand -Value $vmtemp.AutoExpand -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vpc DVS Port Groups Passed - Autoexpand disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-disable-dvportgroup-autoexpand"
$Header = "Harden vNetwork (Audit only): Verify that the autoexpand option for VDS dvPortgroups is disabled"
$Comments = "vNetwork disable-dvportgroup-autoexpand: If the 'no-unused-dvports' guideline is followed, there should be only the amount of ports on a VDS that are actually needed. The Autoexpand feature on VDS dvPortgroups can override that limit. The feature allows dvPortgroups to automatically add 10 virtual distributed switch ports to a dvPortgroup that has run out of available ports. The risk is that maliciously or inadvertently, a virtual machine that is not supposed to be part of that portgroup is able to affect confidentiality, integrity or authenticity of data of other virtual machines on that portgroup. To reduce the risk of inappropriate dvPortgroup access, the autoexpand option on VDS should be disabled. By default the option is disabled, but regular monitoring should be implemented to verify this has not been changed. ** Production PCI-compliant hosts should show 0 OpenPorts & AutoExpand disabled, but this section can be ignored in the QA/BCP environment. **"
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
