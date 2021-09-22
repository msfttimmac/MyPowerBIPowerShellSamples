#### CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION ###
#### CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION - CAUTION ###
#### This script is designed to find Power BI V1 (Legacy) Workspaces with 0 objects in them.  
#### If you find workspaces, you can use the Delete Groups Rest API to delete the workspace: https://docs.microsoft.com/en-us/rest/api/power-bi/groups/delete-group
#### Remember, this is a sample illustration to illustrate how this is done! 

$UserObect = ""
$pwdstring = ""
$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force

$UserEnvironment = "Public"
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserObect, $UserPass

Login-PowerBIServiceAccount -Credential $UserCredential -Environment $UserEnvironment

$WorkspaceURL = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24filter=type eq 'Group'&%24top=5000&%24expand=datasets,dataflows,reports,dashboards,workbooks"
$GET_Workspaces = (Invoke-PowerBIRestMethod -Url $WorkspaceURL -Method Get | ConvertFrom-Json).value

$GET_Workspaces | ForEach-Object{
    $CurrentWorkspaceObject = $_
    
    $DatasetCount = $CurrentWorkspaceObject.Datasets.Count
    $ReportsCount = $CurrentWorkspaceObject.Reports.Count
    $DashboardsCount = $CurrentWorkspaceObject.Dashboards.Count
    $Dataflows = $CurrentWorkspaceObject.Dataflows.Count
    $WorkbooksCount = $CurrentWorkspaceObject.Workbooks.Count

    $WorkspaceObjectCount = $DatasetCount + $ReportsCount + $DashboardsCount + $Dataflows + $WorkbooksCount

    if($WorkspaceObjectCount -eq 0){
            $GetWorkspaceID = $CurrentWorkspaceObject.id
            $DeleteURL = "https://api.powerbi.com/v1.0/myorg/groups/" + $GetWorkspaceID
            #Here you would enter your delete code using the Delete RestAPI
        }
}
Disconnect-PowerBIServiceAccount
