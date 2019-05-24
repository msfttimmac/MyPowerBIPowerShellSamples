#####################################################################################################
# Get_AllReportsInAllWorkspaces
#
# PURPOSE: 
#    The purpose of this script is to loop through all of the workspaces and retrieve all of the reports in those workspaces 
#    and place the information into a CSV file.
#
# RESOURCES:
#   Get-PowerBIWorkSpace: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps
#   Get-PowerBIReport: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.reports/get-powerbireport?view=powerbi-ps
#   Connect-PowerBIServiceAccount: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/connect-powerbiserviceaccount?view=powerbi-ps
#
# CREATION DATE: May 23, 2019
#####################################################################################################

# ENVIRONMENT VARIABLES
$Set_CSVFileLocation = 'C:\Temp\MyReports.CSV'


Connect-PowerBIServiceAccount


# Grab All of the Workspaces in the Organization and then loop through them
$Get_PBIWorkSpaces = Get-PowerBIWorkspace -Scope Organization -All
$Get_PBIWorkSpaces | ForEach-Object {

    $Get_CurrentWorkSpaceObject = $_
    
    #Now lets grab the reports that are in the workspace.  
    $Get_PBIReportsInCurrentWorkSpace = Get-PowerBIReport -WorkspaceId $Get_CurrentWorkSpaceObject.id -Scope Organization -ErrorAction SilentlyContinue
    $Get_CountPBIReportsInCurrentWorkSpace = $Get_PBIReportsInCurrentWorkSpace.Count  #grabbing the count of the reports in the workspace
    $Get_CountPBIReportsInCurrentWorkSpace = $Get_PBIReportsInCurrentWorkSpace.Count  #grabbing the count of the reports in the workspace
    #Write-Host "Report Count --->" $Get_CountPBIReportsInCurrentWorkSpace #Just a console dump for debugging

    #Added this If statement because I had some issues with duplicates.
    if( $Get_CountPBIReportsInCurrentWorkSpace -ge 1 ){ $EndCounter = $Get_CountPBIReportsInCurrentWorkSpace - 1 }else{ $EndCounter = $Get_CountPBIReportsInCurrentWorkSpace }

        for($ReportCounter=0; $ReportCounter -le $EndCounter; $ReportCounter++){

            #We create a new PSObject, so that we can add the information to attributes easily and then dump it to a csv file afterwards
            $ReportObject = New-Object PsObject
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace Capacity ID" -Value $Get_CurrentWorkSpaceObject.CapacityId
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace ID" -Value $Get_CurrentWorkSpaceObject.Id
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $Get_CurrentWorkSpaceObject.Name

            #I did this to help identify the V1 Workspace from the V2 Workspace
            $GetWorkspaceVersion = ""
            switch( $Get_CurrentWorkSpaceObject.Type.ToLower() )
            {
                'group' { $GetWorkspaceVersion = '(v1) ' + $Get_CurrentWorkSpaceObject.Type } #group signifies a v1 workspace
                'workspace' { $GetWorkspaceVersion = '(v2) ' + $Get_CurrentWorkSpaceObject.Type } #workspace signifies a v2 workspace
                default { $GetWorkspaceVersion = $Get_CurrentWorkSpaceObject.Type } #default will be the Personal Group
            }
                        
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace Type" -Value $GetWorkspaceVersion
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace State" -Value $Get_CurrentWorkSpaceObject.State
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Workspace Description" -Value $Get_CurrentWorkSpaceObject.Description
            $ReportObject | Add-Member -MemberType NoteProperty -Name "Number of Reports in Workspace" -Value $Get_CountPBIReportsInCurrentWorkSpace
            
            #What I noticed is that if we have 2 or more reports, then we end up with System.Object[] in the attributes instead of the actual data.  
            #So I had to get the information via the Item Property.
            if( $Get_CountPBIReportsInCurrentWorkSpace -ge 2 ){
                $GetReport = $Get_PBIReportsInCurrentWorkSpace.Item($ReportCounter)
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report ID" -Value $GetReport.Id
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report Name" -Value $GetReport.Name
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report DataSet ID" -Value $GetReport.DataSetId
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report WebUrl" -Value $GetReport.WebUrl
            }else{
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report ID" -Value $Get_PBIReportsInCurrentWorkSpace.Id
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report Name" -Value $Get_PBIReportsInCurrentWorkSpace.Name
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report DataSet ID" -Value $Get_PBIReportsInCurrentWorkSpace.DataSetId
                $ReportObject | Add-Member -MemberType NoteProperty -Name "Report WebUrl" -Value $Get_PBIReportsInCurrentWorkSpace.WebUrl
            }
            #$ReportObject #uncomment this if you want to dump the information to the console
            #Export Information to the CSV file
            $ReportObject | Export-Csv $Set_CSVFileLocation -NoTypeInformation -Append

            if( ($Get_CountPBIReportsInCurrentWorkSpace -ge 1) -and ($ReportCounter -eq $Get_CountPBIReportsInCurrentWorkSpace) ){ $ReportCounter+1 }

        }

    }
