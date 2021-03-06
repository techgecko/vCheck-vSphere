# Start of Settings
# Set a timeout to limit how long the ESXi Shell and SSH services are allowed to run
$ShellTimeOut = 900
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="ESXiShellTimeOut";E={$_ | Get-AdvancedSetting UserVars.ESXiShellTimeOut | Select -ExpandProperty Value}}
	if($vminfo.ESXiShellTimeOut -ne $ShellTimeOut){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name ESXiShellTimeOut -Value $vminfo.ESXiShellTimeOut -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name UserVars.ESXiShellTimeOut -Value $ShellTimeOut
		}
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$ShellMinutes = $ShellTimeOut / 60
	$detail = "**************** All " + (@($VMH).Count) + " hosts Passed - Timeout = $ShellMinutes minutes ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "ESXi-set-shell-timeout"
$Header = "Harden ESXi (Audit & Remediate): Set a timeout to limit how long the ESXi Shell and SSH services are allowed to run"
$Comments = "ESXi set-shell-timeout: When the ESXi Shell or SSH services are enabled on a host they will run indefinitely. To avoid having these services left running set the ESXiShellTimeOut. The ESXiShellTimeOut defines a window of time after which the ESXi Shell and SSH services will automatically be terminated."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
