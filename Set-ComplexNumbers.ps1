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
    Wojtek 2020
#>
function Set-ComplexNumbers {
    [cmdletbinding()]
    param (

    )    

    begin {
        $i2 = -1

        [int]$AlphaReal = Read-Host -Prompt "Set Alpha Real Value"
        [int]$AlphaImaginery = Read-Host -Prompt "Set Alpha Imaginery Value"
        
        [int]$BetaReal = Read-Host -Prompt "Set Beta Real Value"
        [int]$BetaImaginery = Read-Host -Prompt "Set Beta Imaginery Value"

        Write-Host "Alpha: "$AlphaReal"+"$AlphaImaginery"i"
        Write-Host "Beta: "$BetaReal"+"$BetaImaginery"i"
        Write-Host "-----------------------------------------------------"
    }
    process {
        $Cases = "Add", "Minus", "Multiplication", "Division", "ComplexConjugate"
        foreach ($Case in $Cases) {

            switch ($case) {
                Add {         
                    $EqualReal = ($AlphaReal + $BetaReal)
                    $EqualImaginery = ($AlphaImaginery + $BetaImaginery)

                    if ($EqualImaginery -eq 0) {
                        "Add = " + $EqualReal.ToString()
                    } elseif ($EqualImaginery -lt 0) {
                        "Add = " + $EqualReal.ToString() + $EqualImaginery.ToString() + "i" 
                    } else {
                        "Add = " + $EqualReal.ToString() + "+" + $EqualImaginery.ToString() + "i" 
                    }
                }
                Minus { 
                    $EqualReal = ($AlphaReal - $BetaReal)
                    $EqualImaginery = ($AlphaImaginery - $BetaImaginery)
                    
                    if ($EqualImaginery -eq 0) {
                        "Minus = " + $EqualReal.ToString()
                    } elseif ($EqualImaginery -lt 0) {
                        "Minus = " + $EqualReal.ToString() + $EqualImaginery.ToString() + "i" 
                    } else {
                        "Minus = " + $EqualReal.ToString() + "+" + $EqualImaginery.ToString() + "i" 
                    }
                 }
                Multiplication { 
                    $MultiOne = ($AlphaReal * $BetaReal)
                    $MultiTwo = ($AlphaReal * $BetaImaginery)
                    $MultiThree = ($AlphaImaginery * $BetaReal)
                    $MultiFour = (($AlphaImaginery * $BetaImaginery)*$i2)

                    $MultiEqualReal = $MultiOne + $MultiFour
                    $MultiEqualImaginery = $MultiTwo + $MultiThree

                    if ($MultiEqualImaginery -eq 0) {
                        "Multiplication = " + $MultiEqualReal.ToString()
                    } elseif ($MultiEqualImaginery -lt 0) {
                        "Multiplication = " + $MultiEqualReal.ToString() + $MultiEqualImaginery.ToString() + "i"
                    } else {
                        "Multiplication = " + $MultiEqualReal.ToString() + "+" + $MultiEqualImaginery.ToString() + "i"
                    }
                 }
                Division {
                    # Counter section
                    $CounterOne = ($AlphaReal * $BetaReal)
                    $CounterTwo = ($AlphaReal * (-$BetaImaginery))
                    $CounterThree = ($AlphaImaginery * $BetaReal)
                    $CounterFour = (($AlphaImaginery *(-$BetaImaginery))*$i2)
                    
                    $CounterEqualReal = $CounterOne + $CounterFour
                    $CounterEqualImaginery = $CounterTwo + $CounterThree

                    if ($CounterEqualImaginery -lt 0) {
                        $CounterEqual = $CounterEqualReal.ToString() + $CounterEqualImaginery.ToString() + "i"
                    } else {
                        $CounterEqual = $CounterEqualReal.ToString() + "+" + $CounterEqualImaginery.ToString() + "i"
                    }
                    
                    # Denominator section
                    $DenominatorOne = ($BetaReal * $BetaReal)
                    $DenominatorTwo = ($BetaReal * (-$BetaImaginery))
                    $DenominatorThree = ($BetaImaginery * $BetaReal)
                    $DenominatorFour = (($BetaImaginery *(-$BetaImaginery))*$i2)

                    $DenominatorEqualReal = $DenominatorOne + $DenominatorFour
                    $DenominatorEqualImaginery = $DenominatorTwo + $DenominatorThree

                    if ($DenominatorEqualImaginery -eq 0) {
                        $DenominatorEqual = $DenominatorEqualReal.ToString()
                    } else {
                        $DenominatorEqual = $DenominatorEqualReal.ToString() + "+" + $DenominatorEqualImaginery.ToString() + "i"
                    }
                    
                    "Division = " + $CounterEqual + "/" + $DenominatorEqual
                  }
                ComplexConjugate {

                }
                Default {}
            }
        }
    }
    end {

    }
}