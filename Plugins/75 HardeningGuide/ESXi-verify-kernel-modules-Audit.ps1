# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH ) {
	$vminfo = Get-EsxCli -VMHost $vmtemp
	$vminfo2 = $vminfo.system.module.list() | where {$_.IsLoaded -eq $true} | sort Name,Modulefile
	foreach ($vminfotemp in $vminfo2) {
		#Write-Host $vminfo.system.module.get($vminfotemp.Name).Module
		$vminfo3 = $vminfo.system.module.get($vminfotemp.Name) | Select Module, Modulefile, License, Version, SignedStatus, VIBAcceptanceLevel, ContainingVIB | sort Module
		if($vminfo3.SignedStatus -ne "VMware Signed" -and $vminfo3.VIBAcceptanceLevel -ne "certified" -and $vminfo3.Module -ne "be2net" -and $vminfo3.Module -ne "bnx2" -and $vminfo3.Module -ne "bnx2fc" -and $vminfo3.Module -ne "bnx2i" -and $vminfo3.Module -ne "bnx2x" -and $vminfo3.Module -ne "chardevs" -and $vminfo3.Module -ne "cnic" -and $vminfo3.Module -ne "cnic_register" -and $vminfo3.Module -ne "hpcru" -and $vminfo3.Module -ne "hpilo" -and $vminfo3.Module -ne "hpnmi" -and $vminfo3.Module -ne "hpsa" -and $vminfo3.Module -ne "lpfc820" -and $vminfo3.Module -ne "user" -and $vminfo3.Module -ne "vmkapei"){
			$Details = New-object PSObject
			$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
			$Details | Add-Member -Name Module -Value $vminfo3.Module -Membertype NoteProperty
			$Details | Add-Member -Name Modulefile -Value $vminfo3.Modulefile -Membertype NoteProperty
			$Details | Add-Member -Name License -Value $vminfo3.License -Membertype NoteProperty
			$Details | Add-Member -Name Version -Value $vminfo3.Version -Membertype NoteProperty
			$Details | Add-Member -Name SignedStatus -Value $vminfo3.SignedStatus -Membertype NoteProperty
			#only ESXi v6+ has the next 2 properties
			if([version]$vmtemp.version -ge [version]"6.0") {
				$Details | Add-Member -Name VIBAcceptanceLevel -Value $vminfo3.VIBAcceptanceLevel -Membertype NoteProperty
				$Details | Add-Member -Name ContainingVIB -Value $vminfo3.ContainingVIB -Membertype NoteProperty
			}
			$MyCollection += $Details
		}
	}
}

 if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - All kernel modules trusted ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-verify-kernel-modules"
$Header = "Harden ESXi (Audit only): Verify no unauthorized kernel modules are loaded on the host. "
$Comments = "ESXi verify-kernel-modules: VMware provides digital signatures for kernel modules. By default the ESXi host does not permit loading of kernel modules that lack a valid digital signature. However, this behavior can be overridden allowing unauthorized kernel modules to be loaded. Untested or malicious kernel modules loaded on the ESXi host can put the host at risk for instability and/or exploitation."
$Author = "Greg Hatch"
$PluginVersion = 1.4
$PluginCategory = "vSphere"

# 1.4 : 09/11/2015 vSphere 6 modules all return "unsigned", so added VIBAcceptanceLevel and ContainingVIB columns for ESXi v6 to sort out owner -Greg Hatch