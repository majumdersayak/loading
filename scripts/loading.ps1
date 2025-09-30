# loading.ps1
# PowerShell version of loading.sh

# Force UTF-8 encoding so ASCII art prints correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LC_ALL = "en_US.UTF-8"
$env:LANG = "en_US.UTF-8"
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$DownloadDir = "$env:USERPROFILE\Downloads"

while ($true) {
    Clear-Host
    Write-Host @"
.__                    .___.__                
|  |   _________     __| _/|__| ____    ____  
|  |  /  _ \__  \   / __ | |  |/    \  / ___\ 
|  |_(  <_> ) __ \_/ /_/ | |  |   |  \/ /_/  >
|____/\____(____  /\____ | |__|___|  /\___  / 
                \/      \/         \//_____/  

    [Download media files from Internet]
    - By Sayak
"@

    Write-Host ""
    Write-Host "1) Download media files from Internet"
    Write-Host "2) Exit"
    $option = Read-Host "Select option"

    switch ($option) {
        1 {
            Write-Host ""
            Write-Host "1) Download best Video (MP4)"
            Write-Host "2) Download best audio (MP3)"
            Write-Host "3) Choose format manually (Only available formats)"
            Write-Host "4) Back"
            $option1 = Read-Host "Select option"

            switch ($option1) {
                1 {
                    $url = Read-Host "Enter URL"
                    $savepath = Read-Host "Save to folder [default: $DownloadDir]"
                    if ([string]::IsNullOrWhiteSpace($savepath)) { $savepath = $DownloadDir }
                    New-Item -ItemType Directory -Path $savepath -Force | Out-Null
                    Write-Host "Downloading best video + audio as MP4..."
                    yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "$savepath/%(title)s.%(ext)s" $url
                }
                2 {
                    $url = Read-Host "Enter URL"
                    $savepath = Read-Host "Save to folder [default: $DownloadDir]"
                    if ([string]::IsNullOrWhiteSpace($savepath)) { $savepath = $DownloadDir }
                    New-Item -ItemType Directory -Path $savepath -Force | Out-Null
                    Write-Host "Downloading best audio as MP3..."
                    yt-dlp -x --audio-format mp3 -o "$savepath/%(title)s.%(ext)s" $url
                }
                3 {
                    $url = Read-Host "Enter URL"
                    Write-Host "Fetching available formats..."
                    yt-dlp -F $url
                    $fmt = Read-Host "Enter format code (e.g., 22)"
                    $savepath = Read-Host "Save to folder [default: $DownloadDir]"
                    if ([string]::IsNullOrWhiteSpace($savepath)) { $savepath = $DownloadDir }
                    New-Item -ItemType Directory -Path $savepath -Force | Out-Null
                    yt-dlp -f $fmt -o "$savepath/%(title)s.%(ext)s" $url
                }
                4 { continue }
                Default { Write-Host "Invalid choice. Try again." }
            }
        }
        2 {
            Write-Host "Goodbye!"
            exit
        }
        Default {
            Write-Host "Invalid choice. Try again."
        }
    }
    Read-Host "Press Enter to continue..."
}
