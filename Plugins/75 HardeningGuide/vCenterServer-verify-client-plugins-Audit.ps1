# Start of Settings 
# End of Settings

$ServiceInstance = get-view ServiceInstance
$vmtemp = Get-View $ServiceInstance.Content.ExtensionManager
$EM.ExtensionList | Select @{N="Name";E={$_.Description.Label}}, Company, Version, @{N="Summary";E={$_.Description.Summary}}

$Title = "vCenterServer-verify-client-plugins"
$Header = "Harden vCenterServer (Audit only): Verify vSphere Client plugins"
$Comments = "vCenterServer verify-client-plugins: vCenter Server includes a vSphere Client extensibility framework, which provides the ability to extend the vSphere Client with menu selections or toolbar icons that provide access to vCenter Server add-on components or external, Web-based functionality. vSphere Client plugins or extensions run at the same privilege level as the user logged in. A malicious extension might masquerade as something useful but then do harmful things such as stealing credentials or misconfiguring the system."
$Author = "Greg Hatch"
$PluginVersion = 1.0
$PluginCategory = "vSphere"
$Display = "Table"
