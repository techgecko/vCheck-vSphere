# Start of Settings 
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Get-VMHostService | where { $_.key -eq "TSM-SSH" } | Select VMHost, Key, Label, Policy, Running, Required
	if(($vminfo.Policy -ne "off") -or ($vminfo.Running -ne $false) -or ($vminfo.Required -ne $false)){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name Policy -Value $vminfo.Policy -Membertype NoteProperty
		$Details | Add-Member -Name Running -Value $vminfo.Running -Membertype NoteProperty
		$Details | Add-Member -Name Required -Value $vminfo.Required -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Get-VmHostService -VMHost $vmtemp | Where-Object {$_.key -eq "TSM-SSH"} | Stop-VMHostService -Confirm:$false | Out-Null
			$null = Get-VmHostService -VMHost $vmtemp | Where-Object {$_.key -eq "TSM-SSH"} | Set-VMHostService -Policy Off
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - SSH disabled ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-disable-ssh"
$Header = "Harden ESXi (Audit & Remediate): Disable SSH"
$Comments = "ESXi disable-ssh: The ESXi shell, when enabled, can be accessed directly from the host console through the DCUI or remotely using SSH. Remote access to the host should be limited to the vSphere Client, remote command-line tools (vCLI/PowerCLI), and through the published APIs. Under normal circumstances remote access to the host using SSH should be disabled."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
