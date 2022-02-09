
#$UserObect = ""
#$pwdstring = ""
#$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force

$UserEnvironment = "Public"
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserObject, $UserPass
Connect-PowerBIServiceAccount -Credential $UserCredential -Environment $UserEnvironment
# This grabs all of the power bi workspaces
$List_AllWorkspaces_Url = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24expand=reports&%24top=5000"

$Get_PowerBIWorkspaces = (Invoke-PowerBIRestMethod -Url $List_AllWorkspaces_Url -Method Get | ConvertFrom-Json).value
$Get_PowerBIWorkspaces | ForEach-Object{

    $PBI_WorkspaceID = $_.id
    $PBI_ReportsID = $_.reports.id

    $MyObject = New-Object PSObject
    $MyObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $PBI_WorkspaceID -Force
    $MyObject | Add-Member -MemberType NoteProperty -Name "Reports ID" -Value $PBI_ReportsID -Force

    $MyObject
    
    

}
