# Example Call:  ./AddingUsertoWorkspace.ps1 -Workspace_List "workspace id 1" ,"workspace id 2" -EmailToUpdateWorkspace "myemail@myemail.somewhere.com" -WorkspacePermission "Viewer"

Param(
     [Parameter(Mandatory=$true)]
     [String[]]$Workspace_List #Wrap each Workspace ID in quotes and seperate each one by a comma,
     [Parameter(Mandatory=$true)]
     [String[]]$EmailToUpdateWorkspace,
     [Parameter(Mandatory=$true)]
     [String[]]$WorkspacePermission
 )
 

Process{
    [String[]]$WorkspaceList = $Workspace_List
    $EmailToUPdateWorkspace = "'" + $EmailToUpdateWorkspace + "'" 
    $WorkspacePermission = "'" + $WorkspacePermission + "'" 

    Connect-PowerBIServiceAccount

    $WorkspaceList
    $EmailToUPdateWorkSpace
    $WorkspacePermission

    For($iCounter=0; $iCounter -le $WorkspaceList.Count-1; $iCounter++){

        $GetWorkspaceID = $WorkspaceList[$iCounter]
        $url = "https://api.powerbi.com/v1.0/myorg/admin/groups/$GetWorkspaceID/users"
        $body = "{ 'emailAddress': $EmailToUpdateWorkspace, 'groupUserAccessRight': $WorkspacePermission}"

        Invoke-PowerBIRestMethod -url $url -method post -body $body
    }
    
}



