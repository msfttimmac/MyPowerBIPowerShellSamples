### To make this work, this will need a Power BI Admin and/or a Global Admin Accouunt


#Logging in to the Power BI Service
$User = "<user name>"
$PWord = ConvertTo-SecureString -String "<password for user>" -AsPlainText -Force
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
Login-PowerBIServiceAccount -Credential $UserCredential

Function UpdateDataFile{
    Param(
        [psobject]$Get_UpdateDataObject
    )
    Process{
        $Get_UpdateDataObject | Export-Csv 'c:\Temp\ReportDump.CSV' -Append    
    }
}

Write-Output "Obtaining List of Workspaces..."
$GetWorkspaces = Get-PowerBIWorkspace -Scope Organization -All ##| Where-Object {$_.Type -ne 'PersonalGroup' -and $_.State -eq 'Active' }

Write-Output "Looping through workspaces..."
$GetWorkspaces | ForEach-Object{

    #Build Out Some Workspace Variables to use
    $Get_WorkspaceId = $_.Id
    $Get_WorkspaceName = $_.Name
    $Get_WorkspaceType = $_.Type
    $Get_DedicatedCapacity = $_.IsOnDedicatedCapacity
    $Get_CapcityID = $_.CapacityId

    #Obtain a list of objects in the workspace
    $Get_ReportURL = "https://api.powerbi.com/v1.0/myorg/admin/groups/" + $Get_WorkspaceId + "/reports"
    $Get_DatasetsURL = "https://api.powerbi.com/v1.0/myorg/admin/groups/" + $Get_WorkspaceId + "/datasets"
    Write-Output "Obtaining List of Reports"
    $Get_ReportsInWorkSpace = Invoke-PowerBIRestMethod -Url $Get_ReportURL -Method Get
    

    $daWName = "WORKSPACE: " + $_.Name + "(" + $_.id + ")"
    Write-Output $daWName

    foreach($ReportItem in $Get_ReportsInWorkSpace)
    {
        $WorkSpaceObject = New-Object PSObject
        # Power BI Workspace Information
        $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $Get_WorkspaceName
        $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $Get_WorkspaceId
        $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace Type" -Value $Get_WorkspaceType
        $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Workspace On Dedicated" -Value $Get_DedicatedCapacity
        $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Capacity ID" -Value $Get_CapcityID
        
        $ReportItem_Names = ($ReportItem | ConvertFrom-Json).value

        if($ReportItem_Names.Count -gt 1){
            foreach($ItemName in $ReportItem_Names)
            {
                #Report Information                
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Name" -Value $ItemName.name -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report ID" -Value $ItemName.id -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report WebUrl" -Value $ItemName.webUrl -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report EmbedUrl" -Value $ItemName.embedUrl -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Created DateTime" -Value $ItemName.createdDateTime -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Created By" -Value $ItemName.createdBy -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Modified DateTime" -Value $ItemName.modifiedDateTime -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Modified By" -Value $ItemName.modifiedBy -Force
                $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Dataset ID" -Value $ItemName.datasetId -Force
                UpdateDataFile($WorkSpaceObject)
            }
        }
        else{
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Name" -Value ($ReportItem | ConvertFrom-Json).value.name
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report ID" -Value ($ReportItem | ConvertFrom-Json).value.id
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report WebUrl" -Value ($ReportItem | ConvertFrom-Json).value.webUrl
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report EmbedUrl" -Value ($ReportItem | ConvertFrom-Json).value.embedUrl
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Created DateTime" -Value ($ReportItem | ConvertFrom-Json).value.createdDateTime
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Created By" -Value ($ReportItem | ConvertFrom-Json).value.createdBy
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Modified DateTime" -Value ($ReportItem | ConvertFrom-Json).value.modifiedDateTime
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Modified By" -Value ($ReportItem | ConvertFrom-Json).value.modifiedBy
            $WorkSpaceObject | Add-Member -MemberType NoteProperty -Name "Report Dataset ID" -Value ($ReportItem | ConvertFrom-Json).value.datasetId
            UpdateDataFile($WorkSpaceObject)
            
        }
    }
    }
