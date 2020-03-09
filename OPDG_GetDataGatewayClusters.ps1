###############################################################################################
### GET_MYGATEWAYCLUSTERS
### Documentation
### -> Connect-DataGatewayServiceAccount: https://docs.microsoft.com/en-us/powershell/module/datagateway.profile/connect-datagatewayserviceaccount?view=datagateway-ps
### -> Get-DataGatewayCluster: https://docs.microsoft.com/en-us/powershell/module/datagateway/get-datagatewaycluster?view=datagateway-ps
### -> Get-DataGatewayClusterDataSource: https://docs.microsoft.com/en-us/powershell/module/datagateway/get-datagatewayclusterdatasource?view=datagateway-ps
###############################################################################################

###############################################################################################
### Credential Information:
### ---> Utilize the information to set the User and Password so you don't have to enter each time.
###### My Test Credentials
####### Demo Credential Information
###$User = "admin@M365x960617.onmicrosoft.com"
###$PWord = ConvertTo-SecureString -String "6is2Gax6EK" -AsPlainText -Force
####### Premium Capacity Information
  $User = "WabiAdminTest@biatipdfmsitscus.onmicrosoft.com"
  $PWord = ConvertTo-SecureString -String "sGusD5)349IbGr3z" -AsPlainText -Force
### $User = "<user upn to log in to the powerbi environment>"
### $PWord = ConvertTo-SecureString -String "<password>" -AsPlainText -Force
###############################################################################################

###############################################################################################
### Setting up some initial Environment Variables to use
$TempFileLocation = 'C:\Temp\MyDataGatewayClusterList.csv'

###############################################################################################
### Credential Information -> this is to help so you don't have to login each time.
### --> However, the Connect-DataGatewayServiceAccount does not have a credential parameter to pass, so you will have to login each time you call the script.
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
Login-PowerBIServiceAccount -Credential $UserCredential
Connect-DataGatewayServiceAccount 
###############################################################################################
### Now let's get the cluster information
$GetDataGatewayCluster = Get-DataGatewayCluster -Scope Organization
$GetDataGatewayCluster | ForEach-Object{
    $GetClusterStatus = ""
    $GetClusterDataSource = ""
    $GetClusterDataSourceString = ""

    $OPDGCurrentObject = $_
    $ClusterObject = New-Object psobject
    [System.Guid]$ClusterID = $_.Id
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster ID" -Value $OPDGCurrentObject.Id
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Name" -Value $OPDGCurrentObject.Name
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Description" -Value $OPDGCurrentObject.Description
    if( !(Get-DataGatewayClusterStatus -Scope Organization -GatewayClusterId $ClusterId -ErrorAction SilentlyContinue  ) ){($GetClusterStatus = Get-DataGatewayClusterStatus -GatewayClusterId $ClusterID )}else{ $GetClusterStatus =  (Get-DataGatewayClusterStatus -Scope Organization -GatewayClusterId $_.id -ErrorAction SilentlyContinue  )}
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Status" -Value $GetClusterStatus.ClusterStatus
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Upgrade State" -Value $GetClusterStatus.GatewayUpgradeState
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Region" -Value $OPDGCurrentObject.Region
    $OPDGCurrentObject.Permissions | ForEach-Object{ $GetClusterPermissionString = $GetClusterPermissionString + '(' + $_.Id + '=Role:' + $_.Role + ':Type:' + $_.PrincipalType  + '); ' }
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Permissions" -Value $GetClusterPermissionString
    if( !(Get-DataGatewayClusterDataSource -Scope Organization -GatewayClusterId $_.id -ErrorAction SilentlyContinue  ) ){( $GetClusterDataSource = Get-DataGatewayClusterDataSource -GatewayClusterID $_.ID)}else{(Get-DataGatewayClusterDataSource -Scope Organization -GatewayClusterId $_.id -ErrorAction SilentlyContinue  )}
    $GetClusterDataSource | ForEach-Object{ 
        [System.Guid]$DataSourceId = $_.Id
        $GetDataSourceStatus = Get-DataGatewayClusterDataSourceStatus -GatewayClusterId $ClusterId -GatewayClusterDatasourceId $DataSourceId -ErrorAction SilentlyContinue
        $GetClusterDataSourceString = $GetClusterDataSourceString + '( Datasource Name [Id]: ' + $_.DatasourceName+ '[' + $_.Id + '] = DataSourceType: ' + $_.DatasourceType + ' - DataSource Status:' + $GetDataSourceStatus + ' - ConnectionDetails:' + $_.ConnectionDetails+ ' - CredentialType:' + $_.CredentialType  + '); ' }
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Count of Datasources" -Value $GetClusterDataSource.Count
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster DataSourceIds" -Value $GetClusterDataSourceString
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster Type" -Value $OPDGCurrentObject.Type
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster MemberGateways" -Value $OPDGCurrentObject.MemberGateways
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster MemberGateways-GatewayMachine" -Value ($OPDGCurrentObject.MemberGateways.Annotation | ConvertFrom-Json).gatewayMachine
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster MemberGateways-GatewayMachine-Version" -Value ($OPDGCurrentObject.MemberGateways.Annotation | ConvertFrom-Json).gatewayVersion
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster MemberGateways-ContactInformation-Count" -Value ($OPDGCurrentObject.MemberGateways.Annotation | ConvertFrom-Json).gatewayContactInformation.Count
    $GetContactInformationString = ($OPDGCurrentObject.MemberGateways.Annotation | ConvertFrom-Json).gatewayContactInformation
    $ClusterObject | Add-Member -MemberType NoteProperty -Name "Gateway Cluster MemberGateways-ContactInformation" -Value ($GetContactInformationString | ConvertTo-Json).ToString()
    $ClusterObject | Export-Csv $TempFileLocation -Append



}
