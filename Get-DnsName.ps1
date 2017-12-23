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
        [Parameter(Mandatory = $false)]
        [string]$path,
        [Parameter(Mandatory = $false)]
        [regex]$regex
    )
    begin {
        [string]$path = 'C:\log.txt'
        [regex]$regex = '\b(?:\d{1,3}\.){3}\d{1,3}\b'
    }
    process {
        
        $occurences = Select-String -Path $path -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | ForEach-Object {[System.Net.Dns]::GetHostEntry($_)} 

        foreach ($o in $occurences) {
            bierzesz plik, szukasz matchu i podmieniasz

        }
    }
    end {
        
    }
}