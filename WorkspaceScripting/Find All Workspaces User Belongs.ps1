$EmailToCheck = "<email address of user>"

Connect-PowerBIServiceAccount
$url = "https://api.powerbi.com/v1.0/myorg/admin/groups?%24top=5000&%24expand=users"
$GetAllPowerBIWorkspaces = (Invoke-PowerBIRestMethod -Url $url -Method Get -TimeoutSec 50000 | ConvertFrom-Json).value
$GetAllPowerBIWorkspaces | ForEach-Object{
    $CurrentObject = $_
    $GetUsersEmailAddress = ($CurrentObject.users).emailAddress
    if($GetUsersEmailAddress -eq $EmailToCheck){
        $WorkSpaceObject = $CurrentObject.name + "( " + $CurrentObject.id + " )"
        $WorkSpaceObject
    }

}
