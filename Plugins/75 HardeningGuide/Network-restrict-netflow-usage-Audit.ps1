# Start of Settings 
# End of Settings

$MyCollection = @()

$vpg = Get-VDPortgroup
$vpc = $vpg.count

$vminfo = Get-VDPortgroup | Select Name, VDSwitch, @{Name="NetflowEnabled";Expression={$_.Extensiondata.Config.defaultPortConfig.ipfixEnabled.Value}} | where {($_.NetflowEnabled -eq $True)}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name VDSwitch -Value $vmtemp.VDSwitch -Membertype NoteProperty
		$Details | Add-Member -Name NetflowEnabled -Value $vmtemp.NetflowEnabled -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vpc DVS Port Groups Passed - Netflow disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-restrict-netflow-usage"
$Header = "Harden vNetwork (Audit only): Ensure that VDS Netflow traffic is only being sent to authorized collector IP's."
$Comments = "vNetwork restrict-netflow-usage: The vSphere VDS can export Netflow information about traffic crossing the VDS. Netflow exports are not encrypted and can contain information about the virtual network making it easier for a MITM attack to be executed successfully. If Netflow export is required, verify that all VDS Netflow target IP's are correct."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
