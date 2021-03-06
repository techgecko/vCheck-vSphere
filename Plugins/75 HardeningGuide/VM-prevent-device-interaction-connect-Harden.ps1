# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VM) {
	$vminfo = Get-VM -Name $vmtemp | Get-AdvancedSetting "isolation.device.connectable.disable" | Select Entity, Value
	if(($vminfo.Value -eq $null) -or ($vminfo.Value -eq $false)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = $vmtemp | New-AdvancedSetting -Name "isolation.device.connectable.disable" -value $true -Confirm:$false -Force
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - Devices restricted ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-prevent-device-interaction-connect"
$Header = "Harden VM (Audit & Remediate): Prevent unauthorized removal, connection and modification of devices."
$Comments = "VM prevent-device-interaction-connect: Normal users and processes—that is, users and processes without root or administrator privileges—within virtual machines have the capability to connect or disconnect devices, such as network adaptors and CD-ROM drives, as well as the ability to modify device settings. in general, you should use the virtual machine settings editor or configuration editor to remove any unneeded or unused hardware devices. However, you might want to use the device again, so removing it is not always a good solution. in that case, you can prevent a user or running process in the virtual machine from connecting or disconnecting a device from within the guest operating system, as well as modifying devices, by adding the following parameters. By default, a rogue user with nonadministrator privileges in a virtual machine can: "
$Comments += "*Connect a disconnected CD-ROM drive and access sensitive information on the media left in the drive, *Disconnect a network adaptor to isolate the virtual machine from its network, which is a denial of service, *Modify settings on a device"
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
