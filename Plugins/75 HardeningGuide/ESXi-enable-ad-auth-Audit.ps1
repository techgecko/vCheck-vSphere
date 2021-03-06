# Start of Settings
# Set the name of your Active Directory domain where the hosts should be joined
$Domain = "yourdomain.com"
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Get-VMHostAuthentication | Select VmHost, Domain, DomainMembershipStatus
	if(($vminfo.Domain -ne $Domain) -or ($vminfo.DomainMembershipStatus -ne "OK")){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name Domain -Value $vminfo.Domain -Membertype NoteProperty
		$Details | Add-Member -Name DomainMembershipStatus -Value $vminfo.DomainMembershipStatus -Membertype NoteProperty
		$MyCollection += $Details
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - All domain-joined ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-enable-ad-auth"
$Header = "Harden ESXi (Audit only): Use Active Directory for local user authentication."
$Comments = "ESXi enable-ad-auth: Join ESXi hosts to an Active Directory (AD) domain to eliminate the need to create and maintain multiple local user accounts. Using AD for user authentication simplifies the ESXi host configuration, ensures password complexity and reuse policies are enforced and reduces the risk of security breaches and unauthorized access. Note: if the AD group 'ESX Admins' (default) is created all users and groups that are assigned as members to this group will have full administrative access to all ESXi hosts the domain."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
