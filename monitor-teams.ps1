$shelly = $env:ShellyWebCamLight
$nextShellyPoll = Get-Date

$profilePath = ($env:LOCALAPPDATA).Replace('\', '#')

while ($true) {
    $webcamOn = (Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\NonPackaged\$($profilePath)#Microsoft#Teams#current#Teams.exe" -Name 'LastUsedTimeStop') -eq 0
    
    if ((Get-Date) -gt $nextShellyPoll) { 
        $shellyOn = (((Invoke-WebRequest -Method GET "http://$($shelly)/rpc/Switch.GetStatus?id=0") | ConvertFrom-Json).output) -eq "True"
        Out-Default -InputObject "new light status: $($shellyOn)"
        $nextShellyPoll = (Get-Date).AddSeconds(60)        
    }

    if (!($webcamOn) -and $shellyOn) {
        Out-Default -InputObject "switching OFF"
        Invoke-WebRequest -Method GET "http://$($shelly)/rpc/Switch.Set?id=0&on=false"
        $nextShellyPoll = Get-Date
    }

    if ($webcamOn -and !($shellyOn)) {
        Out-Default -InputObject "switching ON"
        Invoke-WebRequest -Method GET "http://$($shelly)/rpc/Switch.Set?id=0&on=true"
        $nextShellyPoll = Get-Date
    }

    Start-Sleep -Seconds 1
}