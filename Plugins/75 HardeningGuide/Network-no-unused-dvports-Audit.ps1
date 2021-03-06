# Start of Settings 
# End of Settings

$MyCollection = @()

$vpg = Get-VirtualPortGroup -distributed
$vpc = $vpg.count

function Get-FreeVDSPort {
	param (
		[parameter(Mandatory=$true,ValueFromPipeline=$true)]
		$VDSPG
 )
 process {
	$nicTypes = "VirtualE1000","VirtualE1000e","VirtualPCNet32","VirtualVmxnet","VirtualVmxnet2","VirtualVmxnet3" 
	$ports = @{}

	$VDSPG.ExtensionData.PortKeys | foreach {
	$ports.Add($_,$VDSPG.Name)
	}
 
	$VDSPG.ExtensionData.Vm | foreach {
		$VMView = Get-View $_
		$nic = $VMView.Config.Hardware.Device | where {$nicTypes -contains $_.GetType().Name -and $_.Backing.GetType().Name -match "Distributed"}
		$nic | where {$_.Backing.Port.PortKey} | foreach {$ports.Remove($_.Backing.Port.PortKey)}
	}

	($ports.Keys).Count
	}
}

$vminfo = Get-VirtualPortGroup -Distributed | Select Name, NumPorts, @{N="NumFreePorts";E={Get-FreeVDSPort -VDSPG $_}} | where {$_.NumFreePorts -ne 0}
foreach ($vmtemp in $vminfo) {
	if($vmtemp.Name.substring(0,10) -ne "DVUplinks-" -and $vmtemp.Name.substring(0,11) -ne "PCI_vMotion"){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name NumPorts -Value $vmtemp.NumPorts -Membertype NoteProperty
		$Details | Add-Member -Name NumFreePorts -Value $vmtemp.NumFreePorts -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All $vpc DVS Port Groups Passed ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-no-unused-dvports"
$Header = "Harden vNetwork (Audit only): Ensure that there are no unused ports on a distributed virtual port group."
$Comments = "vNetwork no-unused-dvports: The number of ports available on a vdSwitch distributed port group can be adjusted to exactly match the number of virtual machine vNICs that need to be assigned to that dvPortgroup. Limiting the number of ports to just what is needed limits the potential for an administrator, either accidentally or maliciously, to move a virtual machine to an unauthorized network. This is especially relevant if the management network is on a dvPortgroup, because it could help prevent someone from putting a rogue virtual machine on this network."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
