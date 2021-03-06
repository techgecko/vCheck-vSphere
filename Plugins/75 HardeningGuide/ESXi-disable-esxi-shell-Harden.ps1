# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Get-VMHostService | where { $_.key -eq "TSM" } | Select VMHost, Key, Label, Policy, Running, Required
	if(($vminfo.Policy -ne "off") -or ($vminfo.Running -ne $false) -or ($vminfo.Required -ne $false)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name Policy -Value $vminfo.Policy -Membertype NoteProperty
		$Details | Add-Member -Name Running -Value $vminfo.Running -Membertype NoteProperty
		$Details | Add-Member -Name Required -Value $vminfo.Required -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Get-VmHostService -VMHost $vmtemp | Where-Object {$_.key -eq "TSM"} | Stop-VMHostService -Confirm:$false | Out-Null
			$null = Get-VmHostService -VMHost $vmtemp | Where-Object {$_.key -eq "TSM"} | Set-VMHostService -Policy Off
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - Shell disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-disable-esxi-shell"
$Header = "Harden ESXi (Audit & Remediate): Disable ESXi Shell unless needed for diagnostics or troubleshooting."
$Comments = "ESXi disable-esxi-shell: ESXi Shell is an interactive command line environment available from the DCUI or remotely via SSH. Access to this mode requires the root password of the server. The ESXi Shell can be turned on and off for individual hosts. Activities performed from the ESXi Shell bypass vCenter RBAC and audit controls. The ESXi shell should only be turned on when needed to troubleshoot/resolve problems that cannot be fixed through the vSphere client or vCLI/PowerCLI."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
