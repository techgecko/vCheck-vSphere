# Start of Settings 
# End of Settings

$diskformat = "IndependentNonPersistent"

$MyCollection = @()

$MyCollection = $VM | Get-HardDisk | where {$_.Persistence -eq $diskformat} | select @{N="VM";E={$_.parent.name}}, @{N="DiskName";E={$_.name}}, @{N="Format";E={$_.Persistence}}, @{N="FileName";E={$_.filename}}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - No disks are IndependentNonPersistent ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disable-independent-nonpersistent"
$Header = "Harden VM (Audit only): Avoid using independent nonpersistent disks on these VMs"
$Comments = "VM disable-independent-nonpersistent: The security issue with nonpersistent disk mode is that successful attackers, with a simple shutdown or reboot, might undo or remove any traces that they were ever on the machine. To safeguard against this risk, you should set production virtual machines to use either persistent disk mode or nonpersistent disk mode; additionally, make sure that activity within the VM is logged remotely on a separate server, such as a syslog server or equivalent Windows-based event collector. Without a persistent record of activity on a VM, administrators might never know whether they have been attacked or hacked."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
