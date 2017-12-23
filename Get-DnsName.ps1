<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
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