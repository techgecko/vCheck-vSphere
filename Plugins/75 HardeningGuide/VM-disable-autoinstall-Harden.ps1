# Start of Settings 
# End of Settings

$MyCollection = @()
$null = New-VIProperty -Name ToolsUpgradePolicy -ObjectType VirtualMachine -ValueFromExtensionProperty 'Config.tools.ToolsUpgradePolicy' -Force 

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Select Name, ToolsUpgradePolicy
	if($vminfo.ToolsUpgradePolicy -ne "manual"){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name ToolsUpgradePolicy -Value $vminfo.ToolsUpgradePolicy -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
			$spec.changeVersion = $vmtemp.ExtensionData.Config.ChangeVersion
			$spec.tools = New-Object VMware.Vim.ToolsConfigInfo
			$spec.tools.toolsUpgradePolicy = "manual"
			$_this = Get-View -Id $vmtemp.Id
			$null = $_this.ReconfigVM_Task($spec)
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - No tools auto-upgrade ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-autoinstall"
$Header = "Harden VM (Audit & Remediate): Disable tools auto install on these VMs"
$Comments = "VM disable-autoinstall: Tools auto install can initiate an automatic reboot, disabling this option will prevent tools from being installed automatically and prevent automatic machine reboots"
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
