# Start of Settings 
# End of Settings

Get-VIRole | Select Name, Description, IsSystem | Sort IsSystem, Name

$Title = "vCenterServer-restrict-guest-control"
$Header = "Harden vCenterServer (Audit only): Restrict unauthorized vSphere users from being able to execute commands within the guest virtual machine."
$Comments = "vCenterServer restrict-guest-control: By default, vCenter Server Administrator role allows users to interact with files and programs inside a virtual machine's guest operating system, which can lessen Guest data confidentiality, availability or integrity. Least Privilege requires that this privilege should not be granted to any users who are not authorized. A non-guest access administrator role should be created with these privileges removed. This role would allow administrator privileges excluding those allowing file and program interaction within the guests."
$Author = "Greg Hatch"
$PluginVersion = 1.0
$PluginCategory = "vSphere"
$Display = "Table"
