# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.tools.setGUIOptions.enable" | Select Entity, Value
	$Details = New-object PSObject
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -ne $false)){
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "isolation.tools.setGUIOptions.enable" -value $false -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Copy/Paste explicitly disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-console-gui-options"
$Header = "Harden VM (Audit & Remediate): Explicitly disable copy/paste operations on these VMs"
$Comments = "VM disable-console-gui-options: Copy and paste operations are disabled by default however by explicitly disabling this feature it will enable audit controls to check that this setting is correct."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
