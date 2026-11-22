$folder = "ruta carpeta de imagenes"
$logFile = "$env:APPDATA\last_wallpaper.txt"

$images = Get-ChildItem -Path $folder -File | Where-Object {
    $_.Extension -match "\.(jpg|jpeg|png)$"
}

if ($images.Count -eq 0) { exit }

$lastImage = ""
if (Test-Path $logFile) {
    $lastImage = Get-Content $logFile
}

$availableImages = $images | Where-Object {
    $_.FullName -ne $lastImage
}

if ($availableImages.Count -eq 0) {
    $availableImages = $images
}

$randomImage = Get-Random $availableImages
$randomImage.FullName | Out-File $logFile

# Estilo de fondo (10 = fill, 6 = fit, etc.)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "10"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"

# Aplicar fondo
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

[Wallpaper]::SystemParametersInfo(20, 0, $randomImage.FullName, 3)

# Forzar refresco más "suave"
Start-Sleep -Milliseconds 300
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters