
$UserObject = ""
$pwdstring = ""
$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force

#$UserObect = ""
#$pwdstring = ""
#$UserPass = ConvertTo-SecureString -String $pwdstring -AsPlainText -Force
$UserEnvironment = "Public"
$UserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserObject, $UserPass
Connect-PowerBIServiceAccount -Credential $UserCredential -Environment $UserEnvironment
(Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/admin/groups?%24expand=users&%24top=5000" -Method Get | ConvertFrom-Json).value | ForEach-Object{
    $MyObject = New-Object PSObject
    if ($_.Users.PrincipalType -eq "App") {
        $MyObject | Add-Member -MemberType NoteProperty -Name "Workspace Name" -Value $_.Name -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Workspace Id" -Value $_.Id -Force
        $MyObject | Add-Member -MemberType NoteProperty -Name "Workspace Users" -Value $_.Users -Force
    }
    
    $MyObject
}
