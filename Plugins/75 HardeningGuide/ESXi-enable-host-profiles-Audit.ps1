# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, `
		@{N="HostProfile";E={$_ | Get-VMHostProfile}}
	if($vminfo.name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name HostProfile -Value $vminfo.HostProfile -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed and have applied host profiles ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-enable-host-profiles"
$Header = "Harden ESXi (Audit only): Configure Host Profiles to monitor and alert on configuration changes"
$Comments = "ESXi enable-host-profiles: Monitoring for configuration drift and unauthorized changes is critical to ensuring the security of an ESXi hosts. Host Profiles provide an automated method for monitoring host configurations against an established template and for providing notification in the event deviations are detected."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
