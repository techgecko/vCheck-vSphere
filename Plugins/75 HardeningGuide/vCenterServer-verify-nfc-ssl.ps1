# Start of Settings 
# End of Settings

$MyCollection = @()


$vminfo = $VIConnection | Get-AdvancedSetting "config.nfc.useSSL" | Select Entity, Value
if(($vminfo.Value -eq $false)){
	$Details = New-object PSObject
	$Details | Add-Member -Name Name -Value $VIConnection.Name -Membertype NoteProperty
	$MyCollection += $Details
	if($ScriptType -eq "Remediate"){
		#Setting the value to nothing is the same as setting it to True.
		$null = $VIConnection | New-AdvancedSetting -Name "config.nfc.useSSL" -value "" -Confirm:$false -Force
	}
}

if($MyCollection.count -eq 0){
	$MyCollection = New-object PSObject
	$detail = "**************** vCenter $VIConnection Passed ****************"
	$MyCollection | Add-Member -Name PASSED -Value $detail -Membertype NoteProperty
	$Display = "List"
}
else{$Display = "Table"}

$MyCollection

$Title = "vCenter-verify-nfc-ssl"
$Header = "Harden vCenter (Audit & Remediate): Ensure SSL for Network File copy (NFC) is enabled"
$Comments = "vCenter verify-nfc-ssl: NFC (Network File Copy) is the name of the mechanism used to migrate or clone a VM between two ESXi hosts over the network. By default, SSL is enabled for provisioning (clone and migrate) NFC data traffic."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
