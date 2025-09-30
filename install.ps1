# install.ps1
# Installation script for Loading (Windows PowerShell)

$installDir = "$HOME\loading"
$binDir = Join-Path $installDir "bin"

Write-Host "Installing Loading..."

# Ensure installation directories exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

# Copy main script
Copy-Item ".\scripts\loading.ps1" "$installDir\loading.ps1" -Force

# Add alias to PowerShell profile
$profileScript = "$PROFILE"
$profileDir = Split-Path $profileScript
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir | Out-Null
}
if (-not (Test-Path $profileScript)) {
    New-Item -ItemType File -Path $profileScript | Out-Null
}

if (-not (Select-String -Path $profileScript -Pattern "function loading" -Quiet)) {
    Add-Content $profileScript @"
function loading {
    & "$installDir\loading.ps1" @Args
}
"@
    Write-Host "Alias 'loading' added to PowerShell profile."
} else {
    Write-Host "Alias 'loading' already exists in profile."
}

# Paths for tools
$ytDlpPath = Join-Path $binDir "yt-dlp.exe"
$ffmpegPath = Join-Path $binDir "ffmpeg.exe"

# Install yt-dlp
if (-not (Test-Path $ytDlpPath)) {
    Write-Host "yt-dlp not found. Downloading..."
    Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile $ytDlpPath
    Write-Host "yt-dlp installed."
} else {
    Write-Host "yt-dlp already installed."
}

# Install ffmpeg
if (-not (Test-Path $ffmpegPath)) {
    Write-Host "ffmpeg not found. Downloading..."
    $ffmpegZip = Join-Path $binDir "ffmpeg.zip"
    $ffmpegExtract = Join-Path $binDir "ffmpeg_tmp"

    Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $ffmpegZip
    Expand-Archive -Path $ffmpegZip -DestinationPath $ffmpegExtract -Force

    $ffmpegExe = Get-ChildItem -Path $ffmpegExtract -Recurse -Filter ffmpeg.exe | Select-Object -First 1
    if ($ffmpegExe) {
        Copy-Item $ffmpegExe.FullName $ffmpegPath -Force
        Write-Host "ffmpeg installed."
    } else {
        Write-Host "Failed to locate ffmpeg.exe in the archive."
    }

    Remove-Item $ffmpegZip -Force
    Remove-Item $ffmpegExtract -Recurse -Force
} else {
    Write-Host "ffmpeg already installed."
}

Write-Host ""
Write-Host "Installation complete!"
Write-Host 'Please restart your terminal (or log out & in) then just run: loading'
