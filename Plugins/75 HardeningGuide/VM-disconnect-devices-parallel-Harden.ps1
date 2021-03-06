# Start of Settings 
# End of Settings

#http://blogs.vmware.com/vipowershell/2012/05/working-with-vm-devices-in-powercli.html
function Get-ParallelPort { 
    param ( 
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] 
        $VM 
    ) 
    process { 
        foreach ($VMachine in $VM) { 
            foreach ($Device in $VMachine.ExtensionData.Config.Hardware.Device) { 
                if ($Device.gettype().Name -eq "VirtualParallelPort"){ 
                    $Details = New-Object PsObject 
                    $Details | Add-Member Noteproperty VM -Value $VMachine 
                    $Details | Add-Member Noteproperty Name -Value $Device.DeviceInfo.Label 
                    if ($Device.Backing.FileName) { $Details | Add-Member Noteproperty Filename -Value $Device.Backing.FileName } 
                    if ($Device.Backing.Datastore) { $Details | Add-Member Noteproperty Datastore -Value $Device.Backing.Datastore } 
                    if ($Device.Backing.DeviceName) { $Details | Add-Member Noteproperty DeviceName -Value $Device.Backing.DeviceName } 
                    $Details | Add-Member Noteproperty Connected -Value $Device.Connectable.Connected 
                    $Details | Add-Member Noteproperty StartConnected -Value $Device.Connectable.StartConnected 
                    $Details 
                } 
            } 
        } 
    } 
}

function Remove-ParallelPort { 
    param ( 
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)] 
        $VM, 
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)] 
        $Name 
    ) 
    process { 
        $VMSpec = New-Object VMware.Vim.VirtualMachineConfigSpec 
        $VMSpec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec 
        $VMSpec.deviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec 
        $VMSpec.deviceChange[0].operation = "remove" 
        $Device = $VM.ExtensionData.Config.Hardware.Device | foreach { 
            $_ | where {$_.gettype().Name -eq "VirtualParallelPort"} | where { $_.DeviceInfo.Label -eq $Name } 
        } 
        $VMSpec.deviceChange[0].device = $Device 
        $VM.ExtensionData.ReconfigVM_Task($VMSpec) 
    } 
}


$MyCollection = @()

$MyCollection = $VM | Get-ParallelPort | select VM, Name, Connected, StartConnected
if($ScriptType -eq "Remediate"){
	$null = $vmtemp | Get-ParallelPort | Remove-ParallelPort
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VM).Count) + " VMs Passed - No parallel ports present ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "VM-disconnect-devices-parallel"
$Header = "Harden VM (Audit & Remediate): Disconnect unauthorized devices"
$Comments = "VM disconnect-devices-parallel: Besides disabling unnecessary virtual devices from within the virtual machine, you should ensure that no device is connected to a virtual machine if it is not required to be there. for example, serial and parallel ports are rarely used for virtual machines in a datacenter environment, and CD/DVD drives are usually connected only temporarily during software installation. for less commonly used devices that are not required, either the parameter should not be present or its value must be FALSE.  NOTE: The parameters listed are not sufficient to ensure that a device is usable; other parameters are required to indicate specifically how each device is instantiated.  Any enabled or connected device represents another potential attack channel."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
