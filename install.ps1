# install.ps1
# Installer for Loading (Windows PowerShell)

Write-Host "🚀 Installing Loading..."

# Where to install (user local folder)
$installDir = "$env:USERPROFILE\loading"

# Create folder if it doesn’t exist
if (!(Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Copy main script
Copy-Item ".\loading.ps1" "$installDir\loading.ps1" -Force

# Create a small wrapper batch file so user can run 'loading' in CMD or PowerShell
$batFile = "$installDir\loading.bat"
"@echo off
pwsh -ExecutionPolicy Bypass -File `"$installDir\loading.ps1`" %*" | Out-File $batFile -Encoding ascii -Force

# --- Dependency: yt-dlp ---
if (!(Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "📥 yt-dlp not found. Downloading..."
    $ytDlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    $ytDlpPath = Join-Path $installDir "yt-dlp.exe"
    Invoke-WebRequest -Uri $ytDlpUrl -OutFile $ytDlpPath
    Write-Host "✅ yt-dlp installed."
} else {
    Write-Host "✔ yt-dlp already installed."
}

# --- Dependency: ffmpeg ---
if (!(Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "📥 ffmpeg not found. Downloading..."
    $ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
    $ffmpegZip = Join-Path $installDir "ffmpeg.zip"
    $ffmpegDir = Join-Path $installDir "ffmpeg"

    Invoke-WebRequest -Uri $ffmpegUrl -OutFile $ffmpegZip
    Expand-Archive -Path $ffmpegZip -DestinationPath $ffmpegDir -Force

    # Find ffmpeg.exe inside extracted folder
    $exe = Get-ChildItem -Path $ffmpegDir -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
    if ($exe) {
        Copy-Item $exe.FullName $installDir -Force
        Write-Host "✅ ffmpeg installed."
    } else {
        Write-Host "⚠️ Failed to locate ffmpeg.exe in the archive."
    }

    Remove-Item $ffmpegZip -Force
} else {
    Write-Host "✔ ffmpeg already installed."
}

# Add install dir to PATH (only if not already there)
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$installDir*") {
    $newPath = "$oldPath;$installDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✅ PATH updated. Restart PowerShell or CMD to use 'loading' directly."
}

Write-Host ""
Write-Host "🎉 Installation complete!"
Write-Host "👉 Now you can just run: loading"
