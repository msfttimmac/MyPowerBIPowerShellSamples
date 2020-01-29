###########################################################################################################
### Get_RefreshHistoryForDataSets
### PURPOSE:
### -- The purpose of this script is to provide an illustration of how to loop through workspaces to get the Refresh History of the datasets.
### -- My goal is to provide an illustration on the basic construct to get you started.  I hope that this helps. Please feel free to leave any feedback and/or possible improvements to the script.
### 
### LIMITATIONS
### -- Even though we can identify Personal Workspaces (PersonalGroup) or (My Workspace), we will not have permission to the Dataset, so we cannot get that information
### -- For Personal Workspaces, I would take a peak at: https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getrefreshhistory
### -- There may be datasets that are not accessible by the Admin because of RLS or some other permission issue. 
### ---- In thos situations, you may need to have the owner of those datasets run the script or one that you have for them.
###
### DOCUMENT REFRENCES
### -- Invoke-PowerBiRestMethod: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/invoke-powerbirestmethod?view=powerbi-ps 
### -- Get-PowerBIWorkspace: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps 
### -- Get-PowerBIDataSet: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.data/get-powerbidataset?view=powerbi-ps 
### -- Login-PowerBIServiceAccount: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/connect-powerbiserviceaccount?view=powerbi-ps 
### -- Datasets - Get Refresh History in Groups: https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getrefreshhistoryingroup 
### 
###########################################################################################################
Login-PowerBIServiceAccount
Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.Type -ne 'PersonalGroup' -and $_.State -eq 'Active' }

$GetWorkspaces | ForEach-Object{

    $CurrentWorkspaceObj = $_.Id
    $DataSetObject = Get-PowerBIDataset -WorkspaceId $CurrentWorkspaceObj.Guid -ErrorAction Ignore -ErrorVariable $DataSetError
    
    if($DataSetObject){
    $DataSetObject | ForEach-Object{

        try
        {
            $GetDataSetID = $_.Id
            $RefreshHistoryURL = 'groups/' + $CurrentWorkspaceObj + '/datasets/' + $GetDataSetID + '/refreshes'

            Invoke-PowerBIRestMethod -Url $RefreshHistoryURL -Method Get | ConvertTo-Json
        }
        catch
        {
            ##Do Nothing
        }
    }
    }
}
