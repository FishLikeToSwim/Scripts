
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
<#
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
#>

$files = Get-ChildItem | Where-Object {(($_.Name -ne "azure-pipelines.yml") -and ($_.Name -ne "Build.Tests.ps1"))}

foreach ($file in $files) {
  $test = "$here/$file"

  Describe "Function $file is Testing" {
    Context 'Help Tests' {
      It 'Function has SYNOPSIS' {
        $test | Should -FileContentMatch '.SYNOPSIS'
      }
  
      It 'Function has DESCRIPTION' {
        $test | Should -FileContentMatch '.DESCRIPTION'
      }
  
      It 'Function has EXAMPLE' {
        $test | Should -FileContentMatch '.EXAMPLE'
      }
    }
    Context 'Function Behavior Tests' {
      It 'Function is Advanced Function' {
        $test | Should -FileContentMatch 'cmdletbinding'
        $test | Should -FileContentMatch 'param'
      }
    }
  }
}
