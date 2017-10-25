function Set-NetAdapter {
    [Cmdletbinding()]
    param (
        [string]$choice
    )
    BEGIN {
        $choice = Read-Host 'Choose what you want!'
    }
    PROCESS {
        switch ($choice) {
            '1' { 
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*Gigabit*"}
                $ReturnValue = $adapter.enable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Disable network adapter successful' -ForegroundColor Green
                } else {
                    Write-Host 'Something went wrong, check network adapter manualy'
                }
            }
            '2' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*Gigabit*"}
                $ReturnValue = $adapter.disable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Disable network adapter successful' -ForegroundColor Green
                } else {
                    Write-Host 'Something went wrong, check network adapter manualy'
                }
            }
            
            
            
            Default { Write-Host 'Choose one more time!' -ForegroundColor Yellow}
        }
    }
    END {

    }
}



# switch 
# 1. enable adapter
# 2. disable adapter 
# 3. Set static IP
# 4. change adapter setting at DHCP 