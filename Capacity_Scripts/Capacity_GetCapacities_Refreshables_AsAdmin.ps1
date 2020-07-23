


function ListRefreshablesOnCapacity{
    ## Lists all refreshables for capacity
    $MyCapacityURL = "https://api.powerbi.com/v1.0/myorg/admin/capacities"
    $MyCapacities = Invoke-PowerBIRestMethod -Url $MyCapacityURL -Method Get | ConvertFrom-Json
    $MyCapacities.value | ForEach-Object{ 
        $CapacityObject = $_
        $MyCapacityID = $_.Id 
        $Get_CapacityURL = $MyCapacityURL + '/' + $MyCapacityID + '/refreshables?$top=10'
        $MyCapacityRefreshables = Invoke-PowerBIRestMethod -Url $Get_CapacityURL -Method Get | ConvertFrom-Json
        $MyCapacityRefreshables.value | ForEach-Object{
            $MyObject = New-Object PSObject
            $CapacityInfo = $CapacityObject.displayName + "( " + $CapacityObject.id + " )"

            BuildRefreshableObject `
            -TheCapcity $CapacityInfo `
            -TheCapacityAdmins $CapacityObject.admins `
            -TheCapacitySku $CapacityObject.sku `
            -TheCapacitystate $CapacityObject.state `
            -TheCapacityRegion $CapacityObject.region `
            -TheId $_.id `
            -TheName $_.name `
            -TheKind $_.kind `
            -TheRefreshCount $_.refreshCount `
            -TheRefreshFailures $_.refreshFailures `
            -TheAverageDuration $_.averageDuration `
            -TheMediaDuration $_.medianDuration `
            -TheRefreshesPerDay $_.refreshesPerDay `
            -TheLastRefresh $_.lastRefresh -TheLastRefreshType $_.lastRefresh.refreshType -TheLastRefreshStartTime $_.lastRefresh.startTime `
            -TheLastRefreshEndTime $_.lastRefresh.endTime -TheLastRefreshStatus $_.lastRefresh.status -TheLastRefreshRequestID $_.lastRefresh.requestId `
            -TheLastRefreshServiceException $_.lastRefresh.serviceExceptionJson `
            -TheRefreshSchedule $_.refreshSchedule `
            -TheRefreshScheduleDays $_.refreshSchedule.days -TheRefreshScheduleTimes $_.refreshSchedule.times `
            -TheRefreshScheduleEnabled $_.refreshSchedule.enabled -TheRefreshSchedulelocalTimeZoneId $_.refreshSchedule.localTimeZoneId `
            -TheRefreshScheduleNotifyOption $_.refreshSchedule.notifyOption `
            -TheConfiguredBy $_.configuredBy
            
            $MyObject | Export-Csv 'c:\Temp\Admin_GetCapacity_Refreshables_DumpFile.CSV' -Append
        }
    }
    
}


function BuildRefreshableObject{
    PARAM(
        [string]$TheCapcity,
        [string]$TheCapacityAdmins,
        [string]$TheCapacitySku,
        [string]$TheCapacitystate,
        [string]$TheCapacityRegion,
        [string]$TheId,
        [string]$TheName,
        [string]$TheKind,
        [string]$TheRefreshCount,
        [string]$TheRefreshFailures,
        [string]$TheAverageDuration,
        [string]$TheMediaDuration,
        [string]$TheRefreshesPerDay,
        [string]$TheLastRefresh,
        [string]$TheLastRefreshType,
        [string]$TheLastRefreshStartTime,
        [string]$TheLastRefreshEndTime,
        [string]$TheLastRefreshStatus,
        [string]$TheLastRefreshRequestID,
        [string]$TheLastRefreshServiceException,
        [string]$TheRefreshSchedule,
        [string]$TheRefreshScheduleDays,
        [string]$TheRefreshScheduleTimes,
        [string]$TheRefreshScheduleEnabled,
        [string]$TheRefreshSchedulelocalTimeZoneId,
        [string]$TheRefreshScheduleNotifyOption,
        [string]$TheConfiguredBy
    )
    PROCESS{
        $MyObject | Add-Member -MemberType NoteProperty -Name "Capacity Name (ID)" -Value $TheCapcity -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Capacity Admins" -Value $TheCapacityAdmins -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Capacity Sku" -Value $TheCapacitySku -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Capacity State" -Value $TheCapacitystate -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Capacity Region" -Value $TheCapacityRegion -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object ID" -Value $TheId -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Name" -Value $TheName -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Type" -Value $TheKind -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Refresh Count" -Value $TheRefreshCount -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Number of Refresh Failures" -Value $TheRefreshFailures -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Average Duration" -Value $TheAverageDuration -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Median Duration" -Value $TheMediaDuration -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Number of Refreshes Per Day" -Value $TheRefreshesPerDay -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh" -Value $TheLastRefresh -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh Type" -Value $TheLastRefreshType -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh StartTime" -Value $TheLastRefreshStartTime -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh End Time" -Value $TheLastRefreshEndTime -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh Status" -Value $TheLastRefreshStatus -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh Request ID" -Value $TheLastRefreshRequestID -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object LastRefresh Service Exception" -Value $TheLastRefreshServiceException -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule" -Value $TheRefreshSchedule -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule Days" -Value $TheRefreshScheduleDays -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule Times" -Value $TheRefreshScheduleTimes -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule Enabled" -Value $TheRefreshScheduleEnabled -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule localTimeZoneId" -Value $TheRefreshSchedulelocalTimeZoneId -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object RefreshSchedule NotifyOption" -Value $TheRefreshScheduleNotifyOption -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Refreshable Object Configured By" -Value $TheConfiguredBy -Force
    }
}


$User = "<username upn>"
$PWord = ConvertTo-SecureString -String "<user password>" -AsPlainText -Force
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord

Login-PowerBIServiceAccount -Environment USGovHigh -Credential $UserCredential

$MyObject = New-Object PSObject
ListRefreshablesOnCapacity
