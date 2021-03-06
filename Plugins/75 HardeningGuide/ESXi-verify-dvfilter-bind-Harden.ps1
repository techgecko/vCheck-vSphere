# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="DVFilterBindIpAddress";E={$_ | Get-AdvancedSetting Net.DVFilterBindIpAddress | Select -ExpandProperty Value}}
	if($vminfo.DVFilterBindIpAddress.length -ne 0){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name DVFilterBindIpAddress -Value $vminfo.DVFilterBindIpAddress -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name Net.DVFilterBindIpAddress -Value ""
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - None use this feature ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-verify-dvfilter-bind"
$Header = "Harden ESXi (Audit & Remediate): Prevent unintended use of dvfilter network APIs"
$Comments = "ESXi verify-dvfilter-bind: if you are not using products that make use of the dvfilter network API (e.g. VMSafe), the host should not be configured to send network information to a VM. If the API is enabled, an attacker might attempt to connect a VM to it, thereby potentially providing access to the network of other VMs on the host. If you are using a product that makes use of this API then verify that the host has been configured correctly."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
