# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-EsxCli -VMHost $vmtemp
	$Details = New-object PSObject
	if(($vminfo.software.acceptance.get() -ne "VMwareCertified") -and ($vminfo.software.acceptance.get() -ne "VMwareAccepted") -and ($vminfo.software.acceptance.get() -ne "PartnerSupported")) {
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name AcceptanceLevel -Value $vminfo.software.acceptance.get() -Membertype NoteProperty
		$Details | Add-Member -Name CreationDate -Value $vminfo.CreationDate -Membertype NoteProperty
		$Details | Add-Member -Name ID -Value $vminfo.ID -Membertype NoteProperty
		$Details | Add-Member -Name InstallDate -Value $vminfo.InstallDate -Membertype NoteProperty
		$Details | Add-Member -Name Version -Value $vminfo.Version -Membertype NoteProperty
		$MyCollection += $Details
	}
}

# List only the vibs which are not at "VMwareCertified", "VMwareAccepted" or "PartnerSupported" acceptance level 
foreach ($vmtemp in $VMH ) {
	$vminfo = Get-EsxCli -VMHost $vmtemp
	$vmvibs = $vminfo.software.vib.list()
	foreach ($vmvibstemp in $vmvibs)  {
		$Details = New-object PSObject
		if(($vmvibstemp.AcceptanceLevel -ne "VMwareCertified") -and ($vmvibstemp.AcceptanceLevel -ne "VMwareAccepted") -and ($vmvibstemp.AcceptanceLevel -ne "PartnerSupported")){
			$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
			$Details | Add-Member -Name AcceptanceLevel -Value $vmvibstemp.AcceptanceLevel -Membertype NoteProperty
			$Details | Add-Member -Name CreationDate -Value $vmvibstemp.CreationDate -Membertype NoteProperty
			$Details | Add-Member -Name ID -Value $vmvibstemp.ID -Membertype NoteProperty
			$Details | Add-Member -Name InstallDate -Value $vmvibstemp.InstallDate -Membertype NoteProperty
			$Details | Add-Member -Name Version -Value $vmvibstemp.Version -Membertype NoteProperty
			$MyCollection += $Details
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - All run at least 'PartnerSupported' code ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-verify-acceptance-level-accepted"
$Header = "Harden ESXi (Audit only): Verify Image Profile and VIB Acceptance Levels."
$Comments = "ESXi verify-acceptance-level-accepted: Verify the ESXi Image Profile to only allow signed VIBs. An unsigned VIB represents untested code installed on an ESXi host. The ESXi Image profile supports four acceptance levels: (1) VMwareCertified - VIBs created, tested and signed by VMware, (2) VMwareAccepted - VIBs created by a VMware partner but tested and signed by VMware, (3) PartnerSupported - VIBs created, tested and signed by a certified VMware partner, and (4) CommunitySupported - VIBs that have not been tested by VMware or a VMware partner. Community Supported VIBs are not supported and do not have a digital signature. To protect the security and integrity of your ESXi hosts do not allow unsigned (CommunitySupported) VIBs to be installed on your hosts."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"

