<#
.SYNOPSIS
    Resolve ip adresses in file
.DESCRIPTION
    This script help you to resolve ip adresses and replace them in file with their dns names
.EXAMPLE
PS C:\Users\Wojtek\Documents\WindowsPowerShell\Scripts> . .\Get-DnsName.ps1
PS C:\Users\Wojtek\Documents\WindowsPowerShell\Scripts> Get-DnsName
.INPUTS
    $path - path to file
.OUTPUTS
    Output (if any)
.NOTES
    Author: Wojtek 02|2020
#>


function Get-DnsName {
    param (

    )
    begin {
        [string]$path = 'C:\log.txt'
        [regex]$regex = '\b(?:\d{1,3}\.){3}\d{1,3}\b'
    }
    process {
        $occurences = Select-String -Path $path -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
        foreach ($o in $occurences) {
            try {
            $hostname = [System.Net.Dns]::GetHostEntry($o) 
            } catch {
                $hostname = "Host $o is unreachable"
                (Get-Content -Path $path).replace("$o", "$hostname") | Set-Content -Path $path
            }
            $hostname = $hostname.HostName
            (Get-Content -Path $path).replace("$o", "$hostname") | Set-Content -Path $path
        }   
    }
    end {
        
    }
}