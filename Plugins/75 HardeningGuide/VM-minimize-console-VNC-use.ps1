# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "RemoteDisplay.vnc.enabled" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq $true)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "RemoteDisplay.vnc.enabled" -value $false -Confirm:$false -Force
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

$Title = "VM-minimize-console-VNC-use"
$Header = "Harden VM (Audit & Remediate): Control access to VM console via VNC protocol"
$Comments = "VM minimize-console-VNC-use: The VM console enables you to connect to the console of a virtual machine, in effect seeing what a monitor on a physical server would show. This console is also availabe via the VNC protocol. Setting up this access also involves setting up firewall rules on each ESXi server the virtual machine will run on."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
