#Add your connection information here. 
#$ExportLocation is going to be the folder location that you desire to export too. 

#Power BI URL Information
IF( $Environment -eq "USGov" ){
    $PowerBI_URL = "https://api.powerbigov.us/v1.0/myorg/admin"}
Else{
    $PowerBI_URL = "https://api.powerbi.com/v1.0/myorg/admin"}

$GetWorkspaceInformation_URL = $PowerBI_URL + "/groups?%24top=5000&%24expand=users"
$Workspace_Information = (Invoke-PowerBIRestMethod -Url $GetWorkspaceInformation_URL  -Method Get | ConvertFrom-Json).value

$Workspace_Information | ForEach-Object{

    $Current_Workspace_Object = New-Object PSObject

    $Current_Workspace_Object | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $_.Name
    $Current_Workspace_Object | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $_.ID
    $Current_Workspace_Object | Add-Member -MemberType NoteProperty -Name "Workspace Type" -Value $_.Type
    $Current_Workspace_Object | Add-Member -MemberType NoteProperty -Name "Workspace Admins" -Value ($_.Users | ConvertTo-Json) | Where-Object {$_.groupUserAccessRight -eq 'Admin'}

    $Current_Workspace_Object | Export-CSV "$ExportLocation\WorkspaceAdmins.csv" -Append
}
