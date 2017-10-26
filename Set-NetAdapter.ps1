function Set-NetAdapter {
    [Cmdletbinding()]
    param (
        [string]$choice
    )
    BEGIN {
        Write-Host "`n"
        Write-Host 'Key 1 enable LAN NIC '
        Write-Host 'Key 2 disable LAN NIC'
        Write-Host 'Key 3 enable DHCP on LAN NIC'
        Write-Host 'Key 4 set static IP adress on LAN NIC'
        Write-Host "`n"
        $choice = Read-Host 'Choose what you want to do!'
    }
    PROCESS {
        switch ($choice) {
            '1' { 
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*Gigabit*"}
                $ReturnValue = $adapter.enable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Enable network adapter successful' -ForegroundColor Green
                }
                else {
                    Write-Host 'Something went wrong, check network adapter manualy' -ForegroundColor red
                }
            }
            '2' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*Gigabit*"}
                $ReturnValue = $adapter.disable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Disable network adapter successful' -ForegroundColor Green
                }
                else {
                    Write-Host 'Something went wrong, check network adapter manualy' -ForegroundColor red
                }
            }
            '3' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object {$_.Description -like "*Gigabit*"}                
                if ($adapter.DHCPenabled -eq $true) {
                    Write-Host 'DHCP is on' -ForegroundColor Green
                }
                else {
                    $ReturnValue = $adapter.EnableDHCP() | Select-Object -ExpandProperty ReturnValue
                    if ($ReturnValue -eq 0) {
                        Write-Host 'Enable DHCP successful' -ForegroundColor Green
                    }
                    else {
                        Write-Host 'Something went wrong, check DHCP on network adapter manualy' -ForegroundColor red
                    }
                }
            }
            '4' {






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