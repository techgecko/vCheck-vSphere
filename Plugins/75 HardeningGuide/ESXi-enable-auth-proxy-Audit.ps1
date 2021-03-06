# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, `
		@{N="HostProfile";E={$_ | Get-VMHostProfile}}, `
		@{N="JoinADEnabled";E={($_ | Get-VmHostProfile).ExtensionData.Config.ApplyProfile.Authentication.ActiveDirectory.Enabled}}, `
		@{N="JoinDomainMethod";E={(($_ | Get-VMHostProfile).ExtensionData.Config.ApplyProfile.Authentication.ActiveDirectory | Select -ExpandProperty Policy | where {$_.Id -eq "JoinDomainMethodPolicy"}).Policyoption.Id}}
	if($vminfo.name -ne $null){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name HostProfile -Value $vminfo.HostProfile -Membertype NoteProperty
		$Details | Add-Member -Name JoinADEnabled -Value $vminfo.JoinADEnabled -Membertype NoteProperty
		$Details | Add-Member -Name JoinDomainMethod -Value $vminfo.JoinDomainMethod -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-enable-auth-proxy"
$Header = "Harden ESXi: When adding ESXi hosts to Active Directory use the vSphere Authentication Proxy to protect passwords"
$Comments = "ESXi enable-auth-proxy: If you configure your host to join an Active Directory domain using Host Profiles the Active Directory credentials are saved in the host profile and are transmitted over the network. To avoid having to save Active Directory credentials in the Host Profile and to avoid transmitting Active Directory credentials over the network use the vSphere Authentication Proxy."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
