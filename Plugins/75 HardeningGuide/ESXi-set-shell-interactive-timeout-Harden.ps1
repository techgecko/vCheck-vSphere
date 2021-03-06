# Start of Settings
# Set a timeout to automatically terminate idle ESXi Shell and SSH sessions.
$ShellTimeOut = 900
# End of Settings

$MyCollection = @()

foreach ($vmtemp in $VMH) {
	$vminfo = Get-VMHost -Name $vmtemp | Select Name, @{N="ESXiShellInteractiveTimeOut";E={$_ | Get-AdvancedSetting UserVars.ESXiShellInteractiveTimeOut | Select -ExpandProperty Value}}
	if($vminfo.ESXiShellInteractiveTimeOut -ne $ShellTimeOut){
		$Details = New-object PSObject
		$Details | Add-Member -Name Name -Value $vmtemp.Name -Membertype NoteProperty
		$Details | Add-Member -Name ESXiShellInteractiveTimeOut -Value $vminfo.ESXiShellInteractiveTimeOut -Membertype NoteProperty
		$MyCollection += $Details
		if($ScriptType -eq "Remediate"){
			$null = Set-VMHostAdvancedConfiguration -VMHost $vmtemp -Name UserVars.ESXiShellInteractiveTimeOut -Value $ShellTimeOut
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

$Title = "ESXi-set-shell-interactive-timeout"
$Header = "Harden ESXi (Audit & Remediate): Set a timeout to automatically terminate idle ESXi Shell and SSH sessions."
$Comments = "ESXi set-shell-interactive-timeout: If a user forgets to logout of their SSH session the idle connection will remain indefinitely increasing the potential for someone to gain privileged access to the host. The ESXiShellInteractiveTimeOut allows you to automatically terminate idle shell sessions."
$Author = "Greg Hatch"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
