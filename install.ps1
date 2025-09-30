Write-Host "Installing Loading..."

# Where to install
$installDir = "$env:USERPROFILE\loading"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Copy script only if needed
$sourceScript = Join-Path (Get-Location) "loading.ps1"
$destScript   = Join-Path $installDir "loading.ps1"
if ($sourceScript -ne $destScript) {
    Copy-Item $sourceScript $destScript -Force
}

# Add installDir to PATH if not already there
if (-not ($env:Path -split ";" | Where-Object { $_ -eq $installDir })) {
    [Environment]::SetEnvironmentVariable(
        "Path",
        $env:Path + ";$installDir",
        "User"
    )
    Write-Host "Added $installDir to PATH (restart required)."
}

# Install yt-dlp if not found
$ytDlpExe = Join-Path $installDir "yt-dlp.exe"
if (-not (Test-Path $ytDlpExe)) {
    Write-Host "yt-dlp not found. Downloading..."
    Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile $ytDlpExe
    Write-Host "yt-dlp installed."
} else {
    Write-Host "✔ yt-dlp already installed."
}

# Install ffmpeg if not found
$ffmpegExe = Join-Path $installDir "ffmpeg.exe"
if (-not (Test-Path $ffmpegExe)) {
    Write-Host "ffmpeg not found. Downloading..."
    $ffZip = Join-Path $installDir "ffmpeg.zip"
    $ffExtract = Join-Path $installDir "ffmpeg"

    Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $ffZip
    Expand-Archive -Path $ffZip -DestinationPath $ffExtract -Force

    $found = Get-ChildItem -Path $ffExtract -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
    if ($found) {
        Copy-Item $found.FullName $ffmpegExe -Force
        Write-Host "ffmpeg installed."
    } else {
        Write-Host "Failed to locate ffmpeg.exe in the archive."
    }
    Remove-Item $ffZip -Force
} else {
    Write-Host " ffmpeg already installed."
}

Write-Host "Installation complete!"
Write-Host "Please restart your terminal (or log out & in) then just run: loading"
