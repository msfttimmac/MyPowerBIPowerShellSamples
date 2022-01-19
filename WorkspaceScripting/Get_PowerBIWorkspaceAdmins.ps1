


$UserObect = ""
$pwdstring = ""
$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force

$UserEnvironment = "Public"
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserObect, $UserPass
##Connect-PowerBIServiceAccount
Login-PowerBIServiceAccount -Credential $UserCredential -Environment $UserEnvironment

# This will filter down to all new - version 2 - power bi workspaces
#$myurl = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24filter=type eq 'Workspace'&%24top=5000"
# This will filter down to all old or legacy - version 1 - power bi workspaces
#$myurl = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24filter=type eq 'Group'&%24top=5000"
# This grabs all of the power bi workspaces
$myurl = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24top=5000"

$Get_PowerBIWorkspaces = (Invoke-PowerBIRestMethod -Url $myurl -Method Get | ConvertFrom-Json).value
$Get_PowerBIWorkspaces | ForEach-Object{
    $PBIWorkspaceID = $_.id
    $PBIWorkspaceName = $_.Name
    $PBIWorkspaceVersion = $_.type
    $PBIWorkspaceName + "-" + $PBIWorkspaceVersion
    #$PBIWorkspace_Users = "https://api.powerbi.com/v1.0/myorg/admin/groups/$PBIWorkspaceID/users"
    $PBIWorkspace_Users = "https://api.powerbi.com/v1.0/myorg/admin/groups/$PBIWorkspaceID/users?%24filter=groupUserAccessRight eq 'Admin'"
    $PBIWorkspace_Admins = (Invoke-PowerBIRestMethod -url $pbiworkspace_users -method get | ConvertFrom-Json).value | Where-Object {$_.groupUserAccessRight -eq 'Admin'}
    $PBIWorkspace_Admins
}
