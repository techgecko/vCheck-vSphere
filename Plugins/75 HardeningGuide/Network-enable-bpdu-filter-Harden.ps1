# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select @{N="BlockGuestBPDU";E={$_ | Get-AdvancedSetting net.blockguestbpdu | Select -ExpandProperty Value}}
	if($vminfo.BlockGuestBPDU -ne 1){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name BlockGuestBPDU -Value $vminfo.BlockGuestBPDU -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name Net.BlockGuestBPDU -Value 1
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - BPDU disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vNetwork-enable-bpdu-filter"
$Header = "Harden vNetwork (Audit & Remediate): Enable BPDU filter on the ESXi host to prevent being locked out of physical switch ports with Portfast and BPDU Guard enabled"
$Comments = "vNetwork enable-bpdu-filter: BPDU Guard and Portfast are commonly enabled on the physical switch the ESXi host is directly connected to reduce the STP convergence delay. If a BPDU packet is sent from a virtual machine on the ESXi host to the physical switch so configured, a cascading lockout of all the uplink interfaces from the ESXi host can occur. To prevent this type of lockout, BPDU filter can be enabled on the ESXi host to drop any BPDU packets being sent to the physical switch. The caveat is that certain SSL VPN which use Windows bridging capability can legitimately generate BPDU packets. The administrator should verify that there are no legitimate BPDU packets generated by virtual machines on the ESXi host prior to enabling BPDU filter. If BPDU filter is enabled in this situation, enabling Reject Forged Transmits on the virtual switch port group adds protection against Spanning Tree loops."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
