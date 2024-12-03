<#
    .SYNOPSIS
        Decode a JWT Access Token and convert to a PowerShell Object.

    .DESCRIPTION
        Decode a JWT Access Token and convert to a PowerShell Object.

    .PARAMETER token
        The JWT Access Token to decode and udpate with expiry time and time to expiry

    .EXAMPLE
        Get-JWTDetails -token $myAccessToken

    .INPUTS
        System.String

    .OUTPUTS
        System.Object

    .LINK
        https://blog.darrenjrobinson.com

    .LINK
        https://blog.darrenjrobinson.com/jwtdetails-powershell-module-for-decoding-jwt-access-tokens-with-readable-token-expiry-time/
#>

function Get-IDNWTokenDetail {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Token
    )

    if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { throw "Invalid token" }

    # Token
    foreach ($i in 0..1) {
        $data = $token.Split('.')[$i].Replace('-', '+').Replace('_', '/')
        switch ($data.Length % 4) {
            0 { break }
            2 { $data += '==' }
            3 { $data += '=' }
        }
    }

    $decodedToken = [System.Text.Encoding]::UTF8.GetString([convert]::FromBase64String($data)) | ConvertFrom-Json
    Write-Debug "JWT Token:"
    Write-Debug $decodedToken

    # Signature
    foreach ($i in 0..2) {
        $sig = $token.Split('.')[$i].Replace('-', '+').Replace('_', '/')
        switch ($sig.Length % 4) {
            0 { break }
            2 { $sig += '==' }
            3 { $sig += '=' }
        }
    }
    Write-Debug "JWT Signature:"
    Write-Debug $sig
    $decodedToken | Add-Member -Type NoteProperty -Name "sig" -Value $sig

    # Convert Expiry time to PowerShell DateTime
    $orig = (Get-Date -Year 1970 -Month 1 -Day 1 -hour 0 -Minute 0 -Second 0 -Millisecond 0)
    $timeZone = Get-TimeZone
    $utcTime = $orig.AddSeconds($decodedToken.exp)
    $offset = $timeZone.GetUtcOffset($(Get-Date)).TotalMinutes #Daylight saving needs to be calculated
    $localTime = $utcTime.AddMinutes($offset)     # Return local time,

    $decodedToken | Add-Member -Type NoteProperty -Name "expiryDateTime" -Value $localTime

    # Time to Expiry
    $timeToExpiry = ($localTime - (get-date))
    $decodedToken | Add-Member -Type NoteProperty -Name "timeToExpiry" -Value $timeToExpiry

    return $decodedToken
}