# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.tools.ghi.launchmenu.change" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq $false)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "isolation.tools.ghi.launchmenu.change" -value $true -Confirm:$false -Force
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

$Title = "VM-disable-unexposed-features-launchmenu"
$Header = "Harden VM (Audit & Remediate): Disable certain unexposed features on these VMs"
$Comments = "VM disable-unexposed-features-launchmenu: Because VMware virtual machines are designed to work on both vSphere as well as hosted virtualization platforms such as Workstation and Fusion, there are some VMX parameters that don’t apply when running on vSphere. Although the functionality governed by these parameters is not exposed on ESX, explicitly disabling them will reduce the potential for vulnerabilities. Disabling these features reduces the number of vectors through which a guest can attempt to influence the host, and thus may help prevent successful exploits."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
