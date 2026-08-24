### Sample script I put together years ago.  Utilize it as a model to build a script for your environment.  Stricty an example. 

$UserObect = "username"
$pwdstring = "password"
$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force


$UserEnvironment = "Public"
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserObect, $UserPass
Login-PowerBIServiceAccount -Credential $UserCredential -Environment $UserEnvironment
$myurl = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24top=5000&"
$infoUrl = "https://api.powerbi.com/v1.0/myorg/admin/workspaces/getInfo"

$GetWorkspaces = (Invoke-PowerBIRestMethod -Url $myurl -Method Get | ConvertFrom-Json).value

$GetWorkspaces | ForEach-Object{

    $TheWorkspaceObject = $_
    $CurrentWorkspaceObject = New-Object PSObject

    # WORKSPACE: Gathering the Workspace Information
    $GETWorkspaceID = $TheWorkspaceObject.Id
    $GETWorkspaceDashboards = $TheWorkspaceObject.dashboards
    $GETWorkspaceReports = $TheWorkspaceObject.reports
    $GETWorkspaceDatasets = $TheWorkspaceObject.datasets

    $GETWorkspaceDatasets | ForEach-Object{ 
        $DatasetObject = $_ 
        $Dataset_ID = $DatasetObject.id
        $CurrentDatasetObject = New-Object PSObject
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset ID" -Value $DatasetObject.id
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Name" -Value $DatasetObject.name
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Add Rows Via API" -Value $DatasetObject.addRowsAPIEnabled
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Configured By" -Value $DatasetObject.configuredBy
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Is Refreshable" -Value $DatasetObject.isRefreshable
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Is Effective Identity Required" -Value $DatasetObject.isEffectiveIdentityRequired
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Is Effective Identity Roles Required" -Value $DatasetObject.isEffectiveIdentityRolesRequired
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Target Storage Mode" -Value $DatasetObject.targetStorageMode
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Created Date" -Value $DatasetObject.createdDate
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Content Provider Type" -Value $DatasetObject.contentProviderType
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Upstream Datasets" -Value $DatasetObject.upstreamDatasets
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Schema May Not be Up to Date " -Value $DatasetObject.schemaMayNotBeUpToDate
        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Dataset Users" -Value $DatasetObject.users

        #Master Dataset Object Info around, count of properties and user count - more for troubleshooting purposes than data collection
        $MasterDatasetObject = $_ | Get-Member
        $DatasetMasterObject = New-Object PSObject
        $DatasetMasterObject | Add-Member -MemberType NoteProperty -Name "Dataset Id" -Value $DatasetObject.id
        $DatasetMasterObject | Add-Member -MemberType NoteProperty -Name "Dataset Property Count" -Value $MasterDatasetObject.Count
        $DatasetMasterObject | Add-Member -MemberType NoteProperty -Name "Dataset User Count" -Value $DatasetObject.Users.Count

        $CurrentDatasetObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $GETWorkspaceID


        #Refresh URL
        $DatasetRefreshURL =  "https://api.powerbi.com/v1.0/myorg/groups/$GetWorkspaceID/datasets/$Dataset_ID/refreshes"
        try{$Get_Dataset_RefreshHistory = Invoke-PowerBIRestMethod -Url $DatasetRefreshURL -Method Get}
        catch{
            $geterror = Resolve-PowerBIError -Last
            $geterror
        }

        $CurrentDataSetObject | Export-Csv -Append -Path "C:\PBIWorkspaceDataProject\DatasetData.csv" 
        $DatasetMasterObject | Export-Csv -Append -Path "C:\PBIWorkspaceDataProject\Master_DatasetData.csv" 
    }

    $GETWorkspaceReports | ForEach-Object{ 
        $ReportObject = $_ 
        $CurrentReportObject = New-Object PSObject
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report ID" -Value $ReportObject.id
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report Name" -Value $ReportObject.name
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "AppID" -Value $ReportObject.appid
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Dataset ID" -Value $ReportObject.datasetId
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report Type" -Value $ReportObject.reportType
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report Created Date" -Value $ReportObject.createdDateTime
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report Last Modified Date" -Value $ReportObject.modifiedDateTime
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Report Users" -Value $ReportObject.users
        $CurrentReportObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $GETWorkspaceID
        $CurrentReportObject | Export-Csv -Append -Path "C:\PBIWorkspaceDataProject\ReportData.csv" 
    }

    $GETWorkspaceDashboards | ForEach-Object{ 
        
        $DashboardObject = $_ 
        $CurrentDashboardObject = New-Object PSObject
        $CurrentDashboardObject | Add-Member -MemberType NoteProperty -Name "Dashboard ID" -Value $DashboardObject.id
        $CurrentDashboardObject | Add-Member -MemberType NoteProperty -Name "Dashboard Name" -Value $DashboardObject.displayname
        $CurrentDashboardObject | Add-Member -MemberType NoteProperty -Name "Is Read Only" -Value $DashboardObject.IsReadOnly
        $CurrentDashboardObject | Add-Member -MemberType NoteProperty -Name "Dashboard Users" -Value $DashboardObject.Users
        $CurrentDashboardObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $GETWorkspaceID
        $CurrentDashboardObject | Export-Csv -Append -Path "C:\PBIWorkspaceDataProject\DashboardData.csv" 
    }
    
    
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $TheWorkspaceObject.id
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $TheWorkspaceObject.Name
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Description" -Value $TheWorkspaceObject.description
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "IsReadOnly" -Value $TheWorkspaceObject.IsReadOnly
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Is Workspace On Capacity" -Value $TheWorkspaceObject.IsOnDedicatedCapacity
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Capacity Migration Status" -Value $TheWorkspaceObject.CapacityMigrationStatus
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Capacity Id" -Value $TheWorkspaceObject.CapacityId
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Type" -Value $TheWorkspaceObject.type
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace State" -Value $TheWorkspaceObject.State
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace - Datasets" -Value $TheWorkspaceObject.datasets
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace - Reports" -Value $TheWorkspaceObject.reports
    $CurrentWorkspaceObject | Add-Member -MemberType NoteProperty -Name "Workspace - Dashboards" -Value $TheWorkspaceObject.dashboards
    Write-Information "Updating Workspace Data ... "    
    $CurrentWorkspaceObject | Export-Csv -Append -Path "c:\PBIWorkspaceDataProject\WorkspaceData.csv"

}


