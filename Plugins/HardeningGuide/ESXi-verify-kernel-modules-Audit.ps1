# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH ) {
	$vminfo = Get-EsxCli -VMHost $vmtemp
	$vminfo2 = $vminfo.system.module.list() | sort Modulefile | foreach {
		$vminfo3 = $vminfo.system.module.get($_.Name) | Select Module, Modulefile, License, Version, SignedStatus
		if($vminfo3.SignedStatus -ne "VMware Signed" -and $vminfo3.Module -ne "be2net" -and $vminfo3.Module -ne "bnx2" -and $vminfo3.Module -ne "bnx2fc" -and $vminfo3.Module -ne "bnx2i" -and $vminfo3.Module -ne "bnx2x" -and $vminfo3.Module -ne "chardevs" -and $vminfo3.Module -ne "cnic" -and $vminfo3.Module -ne "cnic_register" -and $vminfo3.Module -ne "hpcru" -and $vminfo3.Module -ne "hpilo" -and $vminfo3.Module -ne "hpnmi" -and $vminfo3.Module -ne "hpsa" -and $vminfo3.Module -ne "lpfc820" -and $vminfo3.Module -ne "user" -and $vminfo3.Module -ne "vmkapei"){
			$Details = New-object PSObject
			$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
			$Details | Add-Member -Name Module -Value $vminfo3.Module -Membertype NoteProperty
			$Details | Add-Member -Name Modulefile -Value $vminfo3.Modulefile -Membertype NoteProperty
			$Details | Add-Member -Name License -Value $vminfo3.License -Membertype NoteProperty
			$Details | Add-Member -Name Version -Value $vminfo3.Version -Membertype NoteProperty
			$Details | Add-Member -Name SignedStatus -Value $vminfo3.SignedStatus -Membertype NoteProperty
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

$MyCollection

$Title = "ESXi-verify-kernel-modules"
$Header = "Harden ESXi (Audit only): Verify no unauthorized kernel modules are loaded on the host. "
$Comments = "ESXi verify-kernel-modules: VMware provides digital signatures for kernel modules. By default the ESXi host does not permit loading of kernel modules that lack a valid digital signature. However, this behavior can be overridden allowing unauthorized kernel modules to be loaded. Untested or malicious kernel modules loaded on the ESXi host can put the host at risk for instability and/or exploitation."
$Author = "Greg Hatch"
$PluginVersion = 1.0
$PluginCategory = "vSphere"
$Display = "Table"
