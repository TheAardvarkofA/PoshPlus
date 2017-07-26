function Send-TwilioSMS
{
<#
.Synopsis
   Robert Allen - @TheMasterPrawn 15/06/2016
   Uses the twilio SMS api to send an SMS, you need a twilio account on twilio.com
   Useful for texting someone as part of some PowerShell automation.
.EXAMPLE
.\Send-TwilioSMS.ps1 -AccountSid "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" -authToken "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    -fromNumber "+353861111111" -toNumber "+353832222222" `
    -message "Error events made better by Twilio"
.INPUTS
   AccountSid : From API Credentials at https://www.twilio.com/console/account/settings
   authToken  : From API Credentials at https://www.twilio.com/console/account/settings
   fromNumber : Must be a valid purchased twilio number from https://www.twilio.com/console/phone-numbers/dashboard
   toNumber   : Where you want to send the message to
   message    : The message
.OUTPUTS
   Twilio will return information relating to the transaction. Might be prudent to write this to event logs.
.FUNCTIONALITY
   Uses the twilio SMS api to send an SMS
   Uses Invoke-RestMethod so dll's for service interaction are not needed
   Ensure your firewall allows you use api.twilio.com
#>


Param(
  [Parameter(Mandatory=$true)][string]$AccountSid,
  [Parameter(Mandatory=$true)][string]$authToken,
  [Parameter(Mandatory=$true)][string]$fromNumber,
  [Parameter(Mandatory=$true)][string]$toNumber,
  [Parameter(Mandatory=$true)][ValidateLength(1,160)][string]$message)

$secureAuthToken = ConvertTo-SecureString $authToken -AsPlainText -force
$cred = New-Object System.Management.Automation.PSCredential($AccountSid,$secureAuthToken) 

$Body = @{
    From = $fromNumber
    To = $toNumber
    Body = $message
}

$apiEndpoint= "https://api.twilio.com/2010-04-01/Accounts/$AccountSid/Messages.json"
Invoke-RestMethod -Uri $apiEndpoint -Body $Body  -Credential $cred -Method "POST" -ContentType "application/x-www-form-urlencoded" 

}
function Get-Plus500 {
    param($index,$target)

    $url = "https://www.plus500.co.uk/Instruments/$index"
    $result = Invoke-WebRequest $url
    $output = $result.AllElements | 
        Where Class -eq "inst-rate" |
        Select -First 1 -ExpandProperty innerText

    #Write-Host $index $output

    $outputasdouble = [double]$output
    
     
    Write-Host $index $outputasdouble Target is $target

    If($outputasdouble -gt $target)
      { $a = New-Object -COM SAPI.SpVoice
        $a.speak("Success.")


#Send-TwilioSMS -AccountSid "blah" -authToken "blah" -fromNumber "+447492881500" -toNumber "+447971280692" ` -message "Target Reached"

        #[console]::beep(900,400) 
        #[console]::beep(1000,400) 
        #[console]::beep(800,400) 
        #[console]::beep(400,400) 
        #[console]::beep(600,1600)
        Exit
       }



<# $url = "https://www.plus500.co.uk/Instruments/NQ"
    $result = Invoke-WebRequest $url
    $TECH100 = $result.AllElements | 
        Where Class -eq "inst-rate" |
        Select -First 1 -ExpandProperty innerText    
    Write-Host "TECH 100" $TECH100 #>


}

#Import-Module Send-TwilioSMS

while ($true) {

#Get-PLUS500 UK100 #UK100
#Get-PLUS500 NQ #Tech100
Get-PLUS500 -Index FCE -Target 5187 #France40
#Get-PLUS500 YM #USA30
#Get-PLUS500 FDAX #GERMANY30
#Get-PLUS500 ES #USA500
#Get-PLUS500 FESX #Europe50
    #Start-Sleep -Seconds 0.1  
} 


