$ErrorActionPreference = "Stop"

$OWNER    = "Scapy47"
$REPO     = "Shio"
$FILENAME = "shio-Windows-x86_64.exe"
$BASE_URL = "https://github.com/$OWNER/$REPO/releases/latest/download"

$INSTALL_DIR = "$env:LOCALAPPDATA\Programs\shio"
$FINAL_PATH  = "$INSTALL_DIR\shio.exe"

New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

Write-Host "Downloading to $FINAL_PATH"
try {
    Invoke-WebRequest -Uri "$BASE_URL/$FILENAME" -OutFile $FINAL_PATH -UseBasicParsing
} catch {
    Write-Host "Download failed: $_"
    exit 1
}

Write-Host "Installed to $FINAL_PATH"

$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$INSTALL_DIR*") {
    $answer = Read-Host "`nWarning: $INSTALL_DIR is not in your PATH. Add it now? (y/N)"
    if ($answer -match "^[Yy]$") {
        [Environment]::SetEnvironmentVariable("PATH", $userPath.TrimEnd(";") + ";$INSTALL_DIR", "User")
        $env:PATH += ";$INSTALL_DIR"
        Write-Host "PATH updated. Restart your terminal for changes to take effect."
    }
}

Write-Host "`nRun 'shio --version' to verify."
Write-Host 'To enable playback, add to your $PROFILE:'
Write-Host '  $env:SHIO_PLAYER_CMD = "mpv --user-agent={user_agent} --http-header-fields=""Referer: {referer}"" {url}"'
