## PURPOSE OF WRITE-UP
Recently, I engaged on an issue where the goal was to capture the result from Get-DataGatewayClusterDataSourceStatus if it errors out.  The way that the error is returned doesn't allow for us to capture the error message in the result variable being used to capture the status and/or the catch statement of the try catch block.  

| NOTE | I have spoken to the product engingeering team and they are aware of the issue. |

In light of the challenges, I was able to utilize the finally statement of the try...catch..finally statement to be able to capture the error, if an error has been generated. 


## SCRIPT (Get-DataGatewayClusterDatasourceStatus)
Connect-PowerBIServiceAccount
Connect-DataGatewayServiceAccount 

$ClusterID = "<enter your gateway cluster id>"
$DataSourceID = "<enter your gateway data source id>"
$GetGWStatus

try{   
    $GetGWStatus = Get-DataGatewayClusterDatasourceStatus -GatewayClusterId $ClusterID -GatewayClusterDatasourceId $DataSourceID -ErrorAction SilentlyContinue
 } 
finally{
 if($GetGWStatus -eq "")
    {
        $GetGWStatus = Resolve-PowerBIError -Last     
    }   
}

$GetGWStatus

Disconnect-DataGatewayServiceAccount
Disconnect-PowerBIServiceAccount
Exit-PSSession

## DOCUMENTATION
  [Get-DataGatewayClusterDatasourceStatus](https://docs.microsoft.com/en-us/powershell/module/datagateway/get-datagatewayclusterdatasourcestatus?view=datagateway-ps)
  
##Tags
  #pbitimmac #pbiGateway #pbipowershell #gatewaypowershell
