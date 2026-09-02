#!/usr/bin/env pwsh

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$variableName = "OPENAI_API_KEY"

try {
    $existing = [Environment]::GetEnvironmentVariable($variableName, "User")
    if (-not [string]::IsNullOrWhiteSpace($existing)) {
        Write-Output "$variableName(User)=OK"
        exit 0
    }

    $secure = Read-Host "请输入 Sipeed API Key（输入时不会显示字符）" -AsSecureString
    $bstr = [IntPtr]::Zero
    $plain = $null
    try {
        $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        if ([string]::IsNullOrWhiteSpace($plain)) {
            Write-Output "$variableName(User)=MISSING"
            exit 2
        }
        [Environment]::SetEnvironmentVariable($variableName, $plain, "User")
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
        if ($null -ne $plain) {
            $plain = $null
        }
        if ($null -ne $secure) {
            $secure.Dispose()
        }
    }

    $saved = [Environment]::GetEnvironmentVariable($variableName, "User")
    if ([string]::IsNullOrWhiteSpace($saved)) {
        Write-Output "$variableName(User)=MISSING"
        exit 2
    }
    Write-Output "$variableName(User)=OK"
    exit 0
}
catch {
    Write-Output "$variableName(User)=MISSING"
    exit 1
}
