##########################################################################################################################################################################
###
### Get_WorkspaceAccessInfo
### --- This script has been designed to dump the access list information for all workspaces, except for Personal Workspaces, because Admins do not have permission to them unless given
###
### Required:
### --- This script utilizes the PowerBIPS from the PowerShell Gallery / Github
### --- PowerBIPS: https://www.powershellgallery.com/packages/PowerBIPS/2.0.3.2
### ------ GITHUB: https://github.com/DevScope/powerbi-powershell-modules/tree/master/Modules/PowerBIPS
### --- Focused Scripts
### ----- Get-PBIAuthToken: https://github.com/DevScope/powerbi-powershell-modules/blob/master/Modules/PowerBIPS/doc/Get-PBIAuthToken.md
### ----- Get-PBIGroupUsers: https://github.com/DevScope/powerbi-powershell-modules/blob/master/Modules/PowerBIPS/doc/Get-PBIGroupUsers.md
###
### Notes
### --- If you have problems with the Get-PBIAuthToken, then close out of all PowerShell windows and re-open and try again
##########################################################################################################################################################################

Import-Module -Name PowerBIPS -Force

### Credential Information:
$User = "admin@M365x960617.onmicrosoft.com"
$PWord = ConvertTo-SecureString -String "6is2Gax6EK" -AsPlainText -Force
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord

#This will prompt the user for credential
#$UserCredential = Get-Credential

if($User -eq "")
{
    $GetMyAuth = Get-PBIAuthToken -forceAskCredentials
    Login-PowerBI 
}
else
{
    $GetMyAuth = Get-PBIAuthToken -credential $UserCredential
    Login-PowerBI -Credential $UserCredential
}
 
$Get_AllWorkspaces = Get-PowerBIWorkspace -Scope Organization -All

$Get_AllWorkspaces | ForEach-Object{

    $Get_AllWorkspaces = $_

    if ($Get_AllWorkspaces.Type.ToString() -eq "PersonalGroup"){}else{

        $GetWorkspaceID = $_.id
        $GetWorkspaceName = $_.Name
        $DisplayWorkspaceInfo = $GetWorkspaceName+": "+$GetWorkspaceID
    
        $DisplayWorkspaceInfo
        $GetWorkspaceUsers = Get-PBIGroupUsers -authToken $GetMyAuthToken -groupId $GetWorkspaceID

        foreach($UserItem in $GetWorkspaceUsers)
        {
            $WorkSpaceObject = New-Object PSObject
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $GetWorkspaceName
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $UserItem.groupId
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Type" -Value $_.Type
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $UserItem.displayName
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Email Address" -Value $UserItem.emailAddress
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Access Right" -Value $UserItem.groupUserAccessRight
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Object Type" -Value $UserItem.principalType
            $WorkSpaceObject | Export-Csv 'c:\Temp\MyFileDump57.CSV' -Append
            
        }
    }
}
