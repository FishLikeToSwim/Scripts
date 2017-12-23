<#
.SYNOPSIS
    Configure network adapter
.DESCRIPTION
    Script configure LAN adapter
    Remember! You must check the name of Ethernet or WiFi card and replace names at:
    $Device = Read-Host 'Choose network device: Adapter or Gigabit'
.EXAMPLE
    Choose network device: Adapter or Gigabit: Gigabit
    Key 1 enable LAN NIC
    Key 2 disable LAN NIC
    Key 3 enable DHCP on LAN NIC
    Key 4 set static IP adress on LAN NIC
    Choose what you want to do!: 1
.NOTES
    Author: Wojtek | 1o.2o17
#>



function Set-NetAdapter {
    [Cmdletbinding()]
    param (

    )
    BEGIN {
        [string]$IP = ''
        [string]$Mask = ''
        [string]$Gate = ''
        [string]$DNS = ''
        $Device = Read-Host 'Choose network device: Adapter or Gigabit'
        Write-Host "`n"
        Write-Host 'Key 1 enable LAN NIC '
        Write-Host 'Key 2 disable LAN NIC'
        Write-Host 'Key 3 enable DHCP on LAN NIC'
        Write-Host 'Key 4 set static IP adress on LAN NIC'
        Write-Host "`n"
        [string]$choice = Read-Host 'Choose what you want to do!'
    }
    PROCESS {
        switch ($choice) {
            '1' { 
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*$Device*"}
                $ReturnValue = $adapter.enable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Enable network adapter successful' -ForegroundColor Green
                }
                else {
                    Write-Host 'Something went wrong, check network adapter manualy' -ForegroundColor red
                }
            }
            '2' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapter | Where-Object {$_.Name -like "*$Device*"}
                $ReturnValue = $adapter.disable() | Select-Object -ExpandProperty ReturnValue
                if ($ReturnValue -eq 0) {
                    Write-Host 'Disable network adapter successful' -ForegroundColor Green
                }
                else {
                    Write-Host 'Something went wrong, check network adapter manualy' -ForegroundColor red
                }
            }
            '3' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object {$_.Description -like "*$Device*"}                
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
                $DNSAvailable = $adapter.SetDNSServerSearchOrder() | Select-Object -ExpandProperty ReturnValue
                if ($DNSAvailable -eq 0) {
                    Write-Host 'DNS is on ' -ForegroundColor Green
                }
                else {
                    Write-Host 'Something went wrong, check DNS on network adapter manualy' -ForegroundColor red
                }
            }
            '4' {
                $adapter = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object {$_.Description -like "*$Device*"}
                $ReturnIP = $adapter.EnableStatic($IP, $Mask) | Select-Object -ExpandProperty ReturnValue
                if ($ReturnIP -eq 0) {
                    Write-Host 'Set IP successful ' -ForegroundColor Green
                } else {
                    Write-Host 'Something went wrong with IP set ' -ForegroundColor Green
                }
                $ReturnGate = $adapter.SetGateways($Gate) | Select-Object -ExpandProperty ReturnValue
                if ($ReturnGate -eq 0) {
                    Write-Host 'Set Gate successful ' -ForegroundColor Green
                } else {
                    Write-Host 'Something went wrong with Gate set ' -ForegroundColor Green
                }
                $ReturnDNS = $adapter.SetDNSServerSearchOrder($DNS) | Select-Object -ExpandProperty ReturnValue
                if ($ReturnDNS -eq 0) {
                    Write-Host 'Set DNS successful ' -ForegroundColor Green
                } else {
                    Write-Host 'Something went wrong with DNS set ' -ForegroundColor Green
                }
            }   
            
            Default { Write-Host 'Choose one more time!' -ForegroundColor Yellow}
        }
    }
    END {

    }
}