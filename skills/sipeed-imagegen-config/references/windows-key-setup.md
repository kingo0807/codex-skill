# Windows User 作用域凭据设置

仅当 Windows User 作用域中不存在 `OPENAI_API_KEY` 时读取本文件。

不要要求用户把密钥粘贴到聊天中。请用户在自己的本机 PowerShell 窗口运行：

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

用户只应返回最后的 `OK` 或 `MISSING` 状态，绝不能返回密钥本身。已经运行的进程通常不会继承刚写入的 User 作用域环境变量。继续配置时不要回显该值；在新的验证子进程中显式加载它，最后提醒用户完全重启 Codex。
