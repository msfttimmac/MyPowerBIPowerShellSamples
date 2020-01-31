###########################################################################################################
### Get_CapacityInfoFromWorkspace
### PURPOSE:
### -- The purpose of this script is to provide an illustration of how to loop through workspaces and grab the Capacity Related information for that workspace
### -- My goal is to provide an illustration on the basic construct to get you started.  I hope that this helps. Please feel free to leave any feedback and/or possible improvements to the script.
### 
### LIMITATIONS
### -- This script will be utilizing Login-PowerBIServiceAccount without a Service Prinicpal so the person running this will need Admin access
### -- Even though we can identify Personal Workspaces (PersonalGroup) or (My Workspace), we will not have permission to the Dataset, so we cannot get that information
###
### DOCUMENT REFRENCES
### -- Invoke-PowerBiRestMethod: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/invoke-powerbirestmethod?view=powerbi-ps 
### -- Capacity GroupAssignmentStatus: https://docs.microsoft.com/en-us/rest/api/power-bi/capacities/groups_capacityassignmentstatus
### -- Get-PowerBIWorkspace: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps 
### -- Login-PowerBIServiceAccount: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/connect-powerbiserviceaccount?view=powerbi-ps 
### 
###########################################################################################################
Login-PowerBIServiceAccount
$GetWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.Type -ne 'PersonalGroup' -and $_.State -eq 'Active' }

$GetWorkspaces | ForEach-Object{

    $MyWorkSpaceID = $_.Id
    $CapacityAssignmentURL = 'groups/' + $MyWorkSpaceID + '/CapacityAssignmentStatus'
    $Get_CapactiyForWorkspace = Invoke-PowerBIRestMethod -Url $CapacityAssignmentURL -Method Get | ConvertFrom-Json
    $Get_CapactiyForWorkspace | Export-Csv 'C:\Temp\MyCapacityAssignment.csv' -Append
}
