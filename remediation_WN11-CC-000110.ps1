<#
.SYNOPSIS
    This PowerShell script prevents printing over HTTP by disabling the feature.
.NOTES
    Author          : Symone-Marie Priester
    LinkedIn        : linkedin.com/in/symone-mariepriester
    GitHub          : github.com/Symone-Marie
    Date Created    : 2025-02-09
    Last Modified   : 2025-02-09
    Version         : Microsoft Windows [Version 10.0.26200.7623]
    CVEs            : N/A
    Vuln-ID         : V-253376
    STIG-ID         : WN11-CC-000110
.TESTED ON
    Date(s) Tested  : 2025-02-09
    Tested By       : Symone-Marie Priester
    Systems Tested  : Windows 11 Pro OS
    PowerShell Ver. : 5.1
    Manual Test     : Yes, remediated via Local Group Policy Editor (gpedit.msc) with screenshot documentation
.USAGE
    Disables printing over HTTP to prevent unencrypted transmission of data.
    Example syntax:
    PS C:\> .\remediation_WN11-CC-000110.ps1 
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$regName = "DisableHTTPPrinting"
$regValue = 1  # 1 = Enabled (Turn off printing over HTTP)

Write-Host "Configuring printer settings - Disabling printing over HTTP..."

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord
Write-Host "Set $regName to $regValue (Enabled - Turn off printing over HTTP)"

# Verify the change
Write-Host "`nVerifying configuration..."
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

if ($currentValue.$regName -eq $regValue) {
    Write-Host "SUCCESS: WN11-CC-000110 remediated - Printing over HTTP is disabled" -ForegroundColor Green
    Write-Host "`nCurrent registry value:"
    Get-ItemProperty -Path $regPath -Name $regName | Select-Object DisableHTTPPrinting
} else {
    Write-Host "ERROR: Failed to set registry value" -ForegroundColor Red
}
