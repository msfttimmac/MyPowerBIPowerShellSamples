
# AddUserToWorkspace Script
## Script Purpose
The purpose of this script is to allow for someone to pass several workspaces, a single email address and permissions for this email to update the permissions to the workspace.
Script: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/WorkspaceScripting/AddUserToWorkspace.ps1

## DISCLAIMER
This is nothing more than a sample illustration to illustrate how someone could update more than one workspace permissions using PowerShell and Rest API.


## DOCUMENTATION
[Groups_AddUserAsAdmin](https://docs.microsoft.com/en-us/rest/api/power-bi/admin/groups_adduserasadmin)


# PBIPS_ReportInfo Script
Script Location: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/WorkspaceScripting/PBIPS_ReportInfo.ps1
## Script Purpose
I put this together based on a request from a colleague on the ability to grab just the Workspace ID and the Report ID.  This is a very simple script and does not dump to a location, but rather just prints to the screen.  You can very easily dump the information to a file and/or some other storage location. In this script, I am utilizing the Power BI Rest API Admin Scripts to capture the information. 

## DISCLAIMER
This is nothing more than a sample illustration to illustrate how to grab the Workspace ID and Report ID information. 

## DOCUMENTATION
Admin - Groups - Get Groups As Admin: https://docs.microsoft.com/en-us/rest/api/power-bi/admin/groups-get-groups-as-admin

