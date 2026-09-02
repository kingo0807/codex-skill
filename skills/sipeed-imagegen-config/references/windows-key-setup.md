# Windows User-scope credential setup

Read this file only when `OPENAI_API_KEY` is absent from Windows User scope.

Do not ask the user to paste a key into chat. Ask them to run this in their own local PowerShell window:

```powershell
$secret = Read-Host "请输入中转 API Key" -AsSecureString
[IntPtr]$ptr = [IntPtr]::Zero
try {
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $plain, "User")
}
finally {
    if ($ptr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    }
    Remove-Variable plain, secret -ErrorAction SilentlyContinue
}

if ([Environment]::GetEnvironmentVariable("OPENAI_API_KEY", "User")) {
    "OPENAI_API_KEY(User)=OK"
} else {
    "OPENAI_API_KEY(User)=MISSING"
}
```

The user should return only the final `OK` or `MISSING` status, never the key. A process that was already running normally will not inherit a newly written User-scope environment variable. Continue configuration without echoing the value; load it explicitly into the fresh validation child process, then remind the user to restart Codex completely.
