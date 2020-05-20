# MyPowerBIPowerShellSamples
Using the Get-PowerBIWorkspace PowerShell cmdlet to aquire information from workspaces.

All scripts found here are illustrations.  There is a possibility that it will work, but you may have to make changes to adhere to your business rules and needs.


## Reports_Get_ReportsPerWorkspaceWithCreatedAndModified
**Script**: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/Reports_Get_ReportsPerWorkspaceWithCreatedAndModified <br>
**Required**: Power BI Admin Role and possibly Global Admin<br>
**Purpose**:
Loops through all workspaces and lists out all reports with 
 - the created date/time and the modified date/time
 - the user (currently only supplies the user object id - you can use the objectid and the Azure AD modules to pull the actual user info)
This does dump to a CSV file in the C:\Temp Directory, so you will need to ensure that you have the C:\Temp directory
It adds each record through the loop via Append.

I am using the following Rest APIs with this script through the Invoke-PowerBIRestMethod call.
 - **Admin - Reports GetReportsInGroupAsAdmin**: https://docs.microsoft.com/en-us/rest/api/power-bi/admin/reports_getreportsingroupasadmin
 
Now I am also using the Get-PowerBIWorkspace PowerShell cmdlet: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps.








