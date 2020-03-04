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
    Wojtek | 10.2018
#>
[cmdletbinding(DefaultParameterSetName = "Computer")]
param (
    [parameter(Mandatory=$false,
        ParameterSetName="Computer",
        Position = 0,
        ValueFromPipeline=$true)]
    [parameter(Mandatory=$false,
        ParameterSetName="User",
        Position = 1,
        ValueFromPipeline=$true)]    
    [alias("cn")]
    [String[]]
    $ComputerName = "localhost",
    [parameter(Mandatory=$false,
        ParameterSetName="User",
        Position = 0,
        ValueFromPipeline=$true)]
    [alias("User")]
    [String[]]
    $UserName
)
begin {
    # Array initiation, Array store object 
    $SessionArray = @()

    # Variable to store ParameterSetName
    $UsedParamSetName = $PSCmdlet.ParameterSetName

} #end Begin
process {
    foreach ($Name in $ComputerName) {
        $ValidationCompConnect = $true
        try {
            Get-Service -ComputerName $Name -DisplayName "Printer Spooler" -ErrorAction SilentlyContinue
        } catch {
            $ValidationCompConnect = $false
        } # end Validation Try

        if ($ValidationCompConnect -eq $true) {
            $Query = query user /server:$Name
            $ActiveTable = $Query | Select-Object -Skip 1

            foreach ($Active in $ActiveTable) {
                $AddActive = $Active.trimStart() -replace "\s+"," "

                if ($AddActive -like "*Disc*") {
                    $SplitAddActive = $AddActive -split " "
                    $object = New-Object -TypeName PSCustomObject
                    $object | Add-Member -Name 'Server' -MemberType NoteProperty -Value $Name
                    $object | Add-Member -Name 'User' -MemberType NoteProperty -Value $SplitAddActive[0]
                    $object | Add-Member -Name 'Session' -MemberType NoteProperty -Value "-"
                    $object | Add-Member -Name 'State' -MemberType NoteProperty -Value $SplitAddActive[2]
                    $object | Add-Member -Name 'LogOnDate' -MemberType NoteProperty -Value $SplitAddActive[4]
                    $SessionArray += $object
                } else {
                    $SplitAddActive = $AddActive -split " "
                    $object = New-Object -TypeName PSCustomObject
                    $object | Add-Member -Name 'Server' -MemberType NoteProperty -Value $Name
                    $object | Add-Member -Name 'User' -MemberType NoteProperty -Value $SplitAddActive[0]
                    $object | Add-Member -Name 'Session' -MemberType NoteProperty -Value $SplitAddActive[1]
                    $object | Add-Member -Name 'State' -MemberType NoteProperty -Value $SplitAddActive[3]
                    $object | Add-Member -Name 'LogOnDate' -MemberType NoteProperty -Value $SplitAddActive[5]
                    $SessionArray += $object
                } # end Disc If statement
            } # end Active Foreach
        } else {
            $SessionArray += "Can't establish connection to $Name"
        } # end Validation If
    } # end Name Foreach
} # end Process
end {
    switch ($UsedParamSetName) {
        User {
            $SessionArray | Where-Object { $PSItem.User -eq $UserName }
        } # end User in Switch
        Computer {
            $SessionArray
        } # end Computer in Switch
        Default {

        } # end Default in Switch
    } # end Switch statement
 } # end End