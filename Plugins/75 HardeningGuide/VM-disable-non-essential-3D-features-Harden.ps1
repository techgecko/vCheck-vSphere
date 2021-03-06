# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "mks.enable3d" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq $true)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "mks.enable3d" -value $false -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed  - Feature disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-non-essential-3D-features"
$Header = "Harden VM (Audit & Remediate): Disable 3D features on Server and desktop virtual machines"
$Comments = "VM disable-non-essential-3D-features: It is suggested that 3D be disabled on virtual machines that do not require 3D functionality, (e.g. server or desktops not using 3D applications)."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
