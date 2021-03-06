# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "vmsafe.agentPort" | Select Entity, Value
	if($vminfo.Value -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Feature unused ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-verify-vmsafe-cpumem-agentport"
$Header = "Harden VM (Audit only): Control access to VMs through VMsafe CPU/memory APIs."
$Comments = "VM verify-vmsafe-cpumem-agentport: The VMsafe CPU/memory API allows a security virtual machine to inspect and modify the contents of the memory and CPU registers on other VMs, for the purpose of detecting and preventing malware attacks. However, an attacker might compromise the VM by making use of this introspection channel; therefore you should monitor for unauthorized usage of this API. A VM must be configured explicitly to accept access by the VMsafe CPU/memory API. This involves three parameters: one to enable the API, one to set the IP address used by the security virtual appliance on the introspection vSwitch, and one to set the port number for that IP address. If the VM is being protected by such a product, then make sure the latter two parameters are set correctly. This should be done only for specific VMs for which you want this protection."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
