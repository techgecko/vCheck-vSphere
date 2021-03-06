# Start of Settings 
# End of Settings

Get-Folder Datacenters | Get-VIPermission | Select Role, Principal, Propagate, IsGroup | Sort Role, Principal

$Title = "vCenterServer-monitor-admin-assignment"
$Header = "Harden vCenterServer (Audit only): Monitor that vCenter Server administrative users have the correct Roles assigned. Datacenter access below."
$Comments = "vCenterServer monitor-admin-assignment: Monitor that administrative users are only assigned privileges they require. Least Privilege requires that these privileges should only be assigned if needed, to reduce risk of confidentiality, availability or integrity loss. At an interval suitable to industry best practices or your organization's standards, verify in vCenter Server using the vSphere Client: 1. That a non-guest access role was created without these privileges. 2. This role is assigned to users who need administrator privileges excluding those allowing file and program interaction within the guests."
$Author = "Greg Hatch"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
$Display = "Table"
