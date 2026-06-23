# ==========================================
# Forge V2 Windows Installer (PowerShell)
# ==========================================

Write-Host "🚀 Installing Forge V2 for Windows..."
Write-Host "This will download and install the Forge V2 agent locally."
Write-Host "=========================================="

$InstallDir = "$env:USERPROFILE\.memoryverse-forge"
$BinDir = "$InstallDir\bin"
$ZipPath = "$env:TEMP\forge_v2.zip"
$DownloadUrl = "https://github.com/john2639/memoryverse/releases/latest/download/forge_v2-windows.zip"

# Create directories
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

Write-Host "⬇️  Downloading Forge V2 from GitHub Releases..."
Write-Host "URL: $DownloadUrl"

# Download the zip file
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath
    Write-Host "✅ Download successful!"
} catch {
    Write-Host "❌ Download failed! Please check your internet connection or if the GitHub Release is published."
    exit 1
}

Write-Host "📦 Extracting binary to $BinDir..."
# Extract the zip
Expand-Archive -Path $ZipPath -DestinationPath $BinDir -Force
Remove-Item -Path $ZipPath -Force

# Rename forge_v2.exe to forge.exe for CLI usage
$ExePath = "$BinDir\forge_v2.exe"
$NewExePath = "$BinDir\forge.exe"
if (Test-Path $ExePath) {
    Rename-Item -Path $ExePath -NewName "forge.exe" -Force
}

# Add to User PATH
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if (-not $UserPath.Contains($BinDir)) {
    $NewPath = "$UserPath;$BinDir"
    [Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
    # Also update current session path so it works immediately in this window
    $env:PATH = "$env:PATH;$BinDir"
    Write-Host "✨ Added 'forge' command to User PATH."
}

Write-Host "=========================================="
Write-Host "✅ Installation complete!"
Write-Host "⚠️  You may need to restart your terminal for the 'forge' command to be globally available."
Write-Host "=========================================="
Write-Host "🚀 To start the server, run:"
Write-Host "   forge start"
Write-Host ""
Write-Host "⚙️  To install as a 24/7 background service, run:"
Write-Host "   forge install-daemon"
Write-Host "=========================================="
