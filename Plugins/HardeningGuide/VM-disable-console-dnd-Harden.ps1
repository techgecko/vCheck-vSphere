# Start of Settings 
$Display = "Table"
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.tools.dnd.disable" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq $false)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "isolation.tools.dnd.disable" -value $true -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Copy/Paste explicitely disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}

$MyCollection

$Title = "VM-disable-console-dnd"
$Header = "Harden VM (Audit & Remediate): Explicitly disable copy/paste operations on these VMs"
$Comments = "VM disable-console-dnd: Copy and paste operations are disabled by default however by explicitly disabling this feature it will enable audit controls to check that this setting is correct."
$Author = "Greg Hatch"
$PluginVersion = 1.0
$PluginCategory = "vSphere"
