# Start of Settings 
# End of Settings

$MyCollection = @()

$MyCollection = $VM | Get-FloppyDrive | select Parent, Name, ConnectionState
if($ScriptType -eq "Remediate"){
	$null = $vmtemp | Get-FloppyDrive | Remove-FloppyDrive -Confirm:$False
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - No floppies present ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disconnect-devices-floppy"
$Header = "Harden VM (Audit & Remediate): Disconnect unauthorized devices"
$Comments = "VM disconnect-devices-floppy: Besides disabling unnecessary virtual devices from within the virtual machine, you should ensure that no device is connected to a virtual machine if it is not required to be there. for example, serial and parallel ports are rarely used for virtual machines in a datacenter environment, and CD/DVD drives are usually connected only temporarily during software installation. for less commonly used devices that are not required, either the parameter should not be present or its value must be FALSE.  NOTE: The parameters listed are not sufficient to ensure that a device is usable; other parameters are required to indicate specifically how each device is instantiated.  Any enabled or connected device represents another potential attack channel."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
