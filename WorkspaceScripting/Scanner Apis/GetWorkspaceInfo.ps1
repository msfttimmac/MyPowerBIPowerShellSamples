#====================================================
# Power BI Tenant Scanner
# Requires:
#   Power BI Service Administrator or Fabric Admin
#   MicrosoftPowerBIMgmt module
#====================================================

Import-Module MicrosoftPowerBIMgmt

Connect-PowerBIServiceAccount

#----------------------------------------------------
# Configuration
#----------------------------------------------------

$BatchSize = 100

$OutputFolder = "C:\PowerBIScanner"

if (!(Test-Path $OutputFolder))
{
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

#----------------------------------------------------
# Get all workspaces
#----------------------------------------------------

Write-Host "Retrieving workspaces..."

$allWorkspaces = @()
$uri = "admin/groups?`$top=5000"

do
{
    $response = Invoke-PowerBIRestMethod `
        -Method Get `
        -Url $uri

    $responseObj = $response | ConvertFrom-Json

    $allWorkspaces += $responseObj.value

    if($responseObj.'@odata.nextLink')
    {
        $uri = $responseObj.'@odata.nextLink'.Replace(
            "https://api.powerbi.com/v1.0/myorg/",
            ""
        )
    }
    else
    {
        $uri = $null
    }

} while($uri)

Write-Host "Found $($allWorkspaces.Count) workspaces"

#----------------------------------------------------
# Create batches
#----------------------------------------------------

$WorkspaceIds = $allWorkspaces.id

$Batches = @()

for($i=0; $i -lt $WorkspaceIds.Count; $i += $BatchSize)
{
    $EndIndex = [Math\]::Min(
        ($i + $BatchSize - 1),
        ($WorkspaceIds.Count - 1)
    )

    $Batches += ,($WorkspaceIds[$i..$EndIndex])
}

Write-Host "Created $($Batches.Count) scan batches"

#----------------------------------------------------
# Submit scan requests
#----------------------------------------------------

$ScanIds = @()

foreach($Batch in $Batches)
{
    $Body = @{
        workspaces = $Batch
    } | ConvertTo-Json -Depth 10

    Write-Host "Submitting batch..."

    $ScanResponse = Invoke-PowerBIRestMethod `
        -Method Post `
        -Url "admin/workspaces/getInfo?lineage=True&datasourceDetails=True&datasetSchema=True&datasetExpressions=True" `
        -Body $Body

    $ScanObject = $ScanResponse | ConvertFrom-Json

    $ScanIds += $ScanObject.id
}

Write-Host "Submitted $($ScanIds.Count) scans"

#----------------------------------------------------
# Wait for completion
#----------------------------------------------------

foreach($ScanId in $ScanIds)
{
    Write-Host "Waiting for ScanID: $ScanId"

    do
    {
        Start-Sleep -Seconds 10

        $StatusResponse = Invoke-PowerBIRestMethod `
            -Method Get `
            -Url "admin/workspaces/scanStatus/$ScanId"

        $Status = ($StatusResponse | ConvertFrom-Json).status

        Write-Host "Status = $Status"

    }
    while($Status -ne "Succeeded")
}

#----------------------------------------------------
# Download results
#----------------------------------------------------

$AllResults = @()

foreach($ScanId in $ScanIds)
{
    Write-Host "Downloading results for $ScanId"

    $Result = Invoke-PowerBIRestMethod `
        -Method Get `
        -Url "admin/workspaces/scanResult/$ScanId"

    $ResultObject = $Result | ConvertFrom-Json

    $AllResults += $ResultObject.workspaces
}

#----------------------------------------------------
# Save JSON
#----------------------------------------------------

$JsonFile = Join-Path $OutputFolder "PowerBI_TenantScan.json"

$AllResults |
    ConvertTo-Json -Depth 100 |
    Set-Content $JsonFile

Write-Host ""
Write-Host "Completed"
Write-Host "Workspace Count: $($AllResults.Count)"
Write-Host "Output: $JsonFile"
