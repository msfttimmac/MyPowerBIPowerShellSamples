# MyPowerBIPowerShellSamples
Using the Get-PowerBIWorkspace PowerShell cmdlet to aquire information from workspaces.


| **Disclaimer Note** |
| --- |
| All scripts found here are illustrations and have been based on my labs.  The overall concept of the script should work for you; however, you will most likely have to make small changes to adhere to the business rules for your specific business need. |
| **Disclaimer Note** |

# Information on the different environments
Working within the different environments, there are some small items that we need to be aware of here.  I am trying to list them out as I become aware of them.

## Login-PowerBIServiceAccount
Here is the product documentation for these items:
- [Connect-PowerBIServiceAccount](https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.profile/connect-powerbiserviceaccount?view=powerbi-ps)


| Environment | Command |
| --- | --- |
| GCC | Login-PowerBIServiceAccount -Environment USGOV |
| GCC HIGH | Login-PowerBIServiceAccount -Environment USGOVHIGH |
| GCC MIL | Login-PowerBIServiceAccount -Environment USGOVMIL |
| Commercial | Login-PowerBIServiceAccount |
| Using the Credential Parameter | Login-PowerBIServiceAccount -Credential $CredParam |

## API
| Environment | Command |
| --- | --- |
| GCC | https://api.powerbigov.us |
| GCC HIGH | https://api.high.powerbigov.us |
| Commercial | https://api.powerbi.com |

## The "Try It" Button on Microsoft Documentation Page
If your Power BI environment resides in a Government space, then the "Try It" button on the Microsoft Documentation page will not work for you.  It will always either throw a 404 or 403 type error message.  The reason is that the "Try It" button is focused on the Public (Commercial) Cloud. 

If you need to test a Rest API and in the Government Space then you will need to utilize another method, such as PowerShell and/or Postman.



# DATASET SCRIPTS / INFORMATION
## Refreshing Dataset using Rest API
- Documentation: [Datasets - Refresh Dataset](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/refreshdataset)

I did not write a script for this one, this is just an illustration of how to execute this in the different environments.  I hope that this helps you.

| **Environment** | **Command** |
| --- | --- |
| GCC |  Invoke-PowerBIRestMethod -Url "https://api.powerbigov.us/v1.0/myorg/datasets/{enter the datasetid}/refreshes" -Method Post  -Body '{"notifyOption": "MailOnFailure"}' |
| GCC HIGH | Invoke-PowerBIRestMethod -Url "https://api.high.powerbigov.us/v1.0/myorg/datasets/{enter the datasetid}/refreshes" -Method Post  -Body '{"notifyOption": "MailOnFailure"}'|
| Commercial |  Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets/{enter the datasetid}/refreshes" -Method Post  -Body '{"notifyOption": "MailOnFailure"}' |


## Datasets_GetDataset_DataSource_GWInfo
**Script**: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/Datasets_GetDataset_DataSource_GWInfo
<br>
**Required**: Power BI Admin Role and possibly Global Admin<br>
**Purpose**:
This has been designed with the intention to loop through all of the Power BI Workspaces and grab all of the dataset related information.  Additionally, it will take the Dataset ID to get the DataSoruce Information.  Inside of the DataSource Information is the Gateway ID.  I utilize the Gateway ID and the Gateway PowerShell cmdlets to get the Name of the Gateway Cluster.

**NOTE**: This has been coded based on a single datasource to a single dataset.  If you have a scenario where there are multiple datasources to a single dataset, you will need to update/modify the code.

**Rest API and PowerShell cmdlets involved here**
* Admin - Datasets GetDatasourcesAsAdmin: https://docs.microsoft.com/en-us/rest/api/power-bi/admin/datasets_getdatasourcesasadmin
* Admin - Datasets GetDatasetsInGroupAsAdmin: https://docs.microsoft.com/en-us/rest/api/power-bi/admin/datasets_getdatasetsingroupasadmin
* Get-DataGatewayCluster: https://docs.microsoft.com/en-us/powershell/module/datagateway/get-datagatewaycluster?view=datagateway-ps
* Get-PowerBIWorkspace: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps

<br><br><br><br>


## Reports_ReportInformation
**Script**: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/ReportScripts/Get_ReportInformation <br>
**Required**: Power BI Admin Role and possibly Global Admin<br>
**Purpose**:
Loops through all workspaces and lists out all reports with 
 - the created date/time and the modified date/time
 - the user: (Read Note Below)
 
 | NOTE | Currently, this script only supplies the ObjectID of the user object that created the Power BI Report.  If you desire to know more about the User in the Created BY, you will need to build more to the script utilizing the Azure AD PowerShell Modules |
 | --- | --- |
 
 
This does dump to a CSV file in the C:\Temp Directory, so you will need to ensure that you have the C:\Temp directory
It adds each record through the loop via Append.

I am using the following Rest APIs with this script through the Invoke-PowerBIRestMethod call.
 - **Admin - Reports GetReportsInGroupAsAdmin**: https://docs.microsoft.com/en-us/rest/api/power-bi/admin/reports_getreportsingroupasadmin
 
Now I am also using the Get-PowerBIWorkspace PowerShell cmdlet: https://docs.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.workspaces/get-powerbiworkspace?view=powerbi-ps.


# PREMIUM CAPACITY SCRIPTS
## ListRefreshablesOnCapacity

*Script*: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/Capacity_Scripts/ListRefreshablesOnCapacity

| Column Reference | Description |
| --- | --- |
|Capacity Name	| The name of the capacity along with the capacity id |
|Capacity Admins	|The listed admins of that capacity |
|Capacity Sku	| The Sku (P1, P2, P3) |
|Capacity State	| Is it Active or not |
|Capacity Region	| The region the capacity is located |
|Object ID	| The ID of the object - like a Dataset or Dataflow |
|Object Name	| The name of the object |
|Object Kind	| The kind of object (Dataset, Dataflow, Paginated Report) |
|Object Last Refresh	| Long string holding information about the last refresh of the object |
|Object Last Refresh Type | 	The Type of Refresh (Scheduled, On Demand, etc) |
|Object Last Refresh StartTime | When the Last Refresh Started |
|Object Last Refresh EndTime | When the Last Refresh Ended |
|Object Last Refresh Status	| Completed, Failed, Disabled, etc |
|Object Last Refresh Request ID | If the refresh fails and supplies a Request ID, it will be captured here |
|Object Last Refresh Service Exception | If the refresh fails and supplies an exception, you will see it here |
|Object Refresh Schedule	| Long string holding infromation about the schedule of refreshes |
|Object Refresh Schedule Days | The Days the Refresh is scheduled (Monday, Tuesday, Wednesday, etc) |
|Object Refresh Schedule Times | The Times the Refresh is scheduled |
|Object Refresh Schedule localTimeZoneID | The Timezone for the Refresh Schedule |
|Object Refresh Schedule NotifyOption | Notification of the Refresh |
|Configured By	| Who configured the refresh (UPN) |


## Capacity_GetCapacities_Refreshables_AsAdmin
**Script**: https://github.com/msfttimmac/MyPowerBIPowerShellSamples/blob/master/Capacity_Scripts/Capacity_GetCapacities_Refreshables_AsAdmin.ps1
**Purpose**: The goal of the script is to help Power BI Admins and/or Office 365 Global Admins pull data about their capacities and the refreshes that are occurring on the capacities. This script will loop through all capacities on a Power BI Tenant and grab the information about the refreshables and the last refresh. 

**Schema**: The schema is similar to above, but does have a few extra columns.  I will add that later on as time permits.


