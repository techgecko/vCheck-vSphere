# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "tools.setInfo.sizeLimit" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -ne "1048576")){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "tools.setInfo.sizeLimit" -value 1048576 -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Size limit set to 1MB****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-limit-setinfo-size"
$Header = "Harden VM (Audit & Remediate): Limit informational messages from the VM to the VMX file."
$Comments = "VM limit-setinfo-size: The configuration file containing these name-value pairs is limited to a size of 1MB. This 1MB capacity should be sufficient for most cases, but you can change this value if necessary. You might increase this value if large amounts of custom information are being stored in the configuration file."
$Comments += "The default limit is 1MB; this limit is applied even when the sizeLimit parameter is not listed in the .vmx file. Uncontrolled size for the VMX file can lead to denial of service if the datastore is filled."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
