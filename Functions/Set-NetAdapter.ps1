<#
.SYNOPSIS
    Configure network adapter
.DESCRIPTION
    Script configure LAN adapter
    Copy and Paste name of device which you want to use
    Fill variables before you use script 
        [string]$IP = ''
        [string]$Mask = ''
        [string]$Gate = ''
        [string]$DNS = ''
.EXAMPLE
    PS C:\Users\Wojtek\Documents\WindowsPowerShell\Scripts> .\Set-NetAdapter.ps1
    ------------------------------------------------------------------------
    WAN Miniport (SSTP)
    WAN Miniport (IKEv2)
    WAN Miniport (L2TP)
    WAN Miniport (PPTP)
    WAN Miniport (PPPOE)
    WAN Miniport (IPv6)
    WAN Miniport (Network Monitor)
    Intel(R) 82579LM Gigabit Network Connection
    WAN Miniport (IP)
    Karta Microsoft 6to4
    RAS Async Adapter
    Intel(R) Centrino(R) Advanced-N 6205
    Karta Microsoft ISATAP #2
    VMware Virtual Ethernet Adapter for VMnet1
    Karta Microsoft ISATAP
    VMware Virtual Ethernet Adapter for VMnet8
    Karta Microsoft ISATAP #3
    Urządzenie Bluetooth (sieć osobista)
    Karta Microsoft ISATAP #4
    Teredo Tunneling Pseudo-Interface
    Karta Microsoft ISATAP #5
    ------------------------------------------------------------------------
    Copy and Paste device which you want to use: Intel(R) 82579LM Gigabit Network Connection
    ------------------------------------------------------------------------


    Key 1 enable LAN NIC
    Key 2 disable LAN NIC
    Key 3 enable DHCP on LAN NIC
    Key 4 set static IP adress on LAN NIC


    Choose what you want to do!: 1
    Enable network adapter successful
.NOTES
    Author: Wojtek 
    v1 | 1o.2o17
    v2 | 12.2o17
    v3 | o2.2o2o
#>



    [Cmdletbinding()]
    param (

    )
    BEGIN {
        [string]$IP = ''
        [string]$Mask = ''
        [string]$Gate = ''
        [string]$DNS = ''
        Write-Host '------------------------------------------------------------------------'
        Get-WmiObject -ClassName Win32_NetworkAdapter | Select-Object -ExpandProperty Name
        Write-Host '------------------------------------------------------------------------'
        $Device = Read-Host 'Copy and Paste device which you want to use'
        Write-Host '------------------------------------------------------------------------'
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