# Script to process user image and update icon and emblem assets
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$srcPath = "C:/Users/suraj/.gemini/antigravity/brain/a47a8c33-8f81-4b3b-8faa-80ffcb4c3ac6/.user_uploaded/media_1792525580949_03292b55.jpg"
if (-not (Test-Path $srcPath)) {
    throw "Source image not found at $srcPath"
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Clean sparkle watermark in bottom-right corner (930..1010, 930..1010) using symmetrical pixels from bottom-left (1023 - x, y)
for ($y = 930; $y -lt 1010; $y++) {
    for ($x = 930; $x -lt 1010; $x++) {
        $orig = $bmp.GetPixel($x, $y)
        if ($orig.R -gt 45 -or $orig.G -gt 45 -or $orig.B -gt 45) {
            $symX = 1023 - $x
            $replacement = $bmp.GetPixel($symX, $y)
            $bmp.SetPixel($x, $y, $replacement)
        }
    }
}

# 1. Save 1024x1024 master
$icon1024 = Join-Path $rootDir "assets\icon_1024.png"
$bgEmblem = Join-Path $rootDir "src\DarkKnightTheme\Resources\Backgrounds\bat_emblem.png"
$bmp.Save($icon1024, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Save($bgEmblem, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved master icon_1024.png and bat_emblem.png"

# Helper to scale bitmap with high quality
function Save-Scaled([System.Drawing.Bitmap]$source, [string]$destPath, [int]$dim) {
    $target = [System.Drawing.Bitmap]::new($dim, $dim)
    $g = [System.Drawing.Graphics]::FromImage($target)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.DrawImage($source, 0, 0, $dim, $dim)
    $g.Dispose()
    $target.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $target.Dispose()
    Write-Host "Saved $destPath ($dim x $dim)"
}

# 2. Save emblem.png (512x512)
Save-Scaled $bmp (Join-Path $rootDir "assets\emblem.png") 512

# 3. Save icon_256.png (256x256)
Save-Scaled $bmp (Join-Path $rootDir "assets\icon_256.png") 256

# 4. Save src\DarkKnightTheme\Resources\Icon.png (128x128)
Save-Scaled $bmp (Join-Path $rootDir "src\DarkKnightTheme\Resources\Icon.png") 128

$bmp.Dispose()
Write-Host "All icons generated successfully!" -ForegroundColor Green

# 5. Regenerate Marketplace Banner
Write-Host "Rendering Marketplace Banner with updated emblem..." -ForegroundColor Cyan
$assetsDir = Join-Path $rootDir "assets"
$bannerBmp = [System.Drawing.Bitmap]::new(1280, 640)
$bg = [System.Drawing.Graphics]::FromImage($bannerBmp)
$bg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$bg.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rectB = [System.Drawing.Rectangle]::new(0, 0, 1280, 640)
$brushB = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rectB,
    [System.Drawing.ColorTranslator]::FromHtml("#171C25"),
    [System.Drawing.ColorTranslator]::FromHtml("#101216"),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$bg.FillRectangle($brushB, $rectB)

$penGrid = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(20, 77, 141, 204), 1)
for ($x = 0; $x -lt 1280; $x += 40) { $bg.DrawLine($penGrid, $x, 0, $x, 640) }
for ($y = 0; $y -lt 640; $y += 40) { $bg.DrawLine($penGrid, 0, $y, 1280, $y) }

$bg.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A")), 0, 0, 1280, 4)

$emblemPath = Join-Path $assetsDir "emblem.png"
if (Test-Path $emblemPath) {
    $emblemImg = [System.Drawing.Image]::FromFile($emblemPath)
    $bg.DrawImage($emblemImg, 80, 190, 240, 240)
    $emblemImg.Dispose()
}

$fontTitle = [System.Drawing.Font]::new("Segoe UI", 42, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$fontTagline = [System.Drawing.Font]::new("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fontBadge = [System.Drawing.Font]::new("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)

$brushGold = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A"))
$brushBlue = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#4D8DCC"))
$brushWhite = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#E6EAF0"))

$bg.DrawString("DARK KNIGHT", $fontTitle, $brushGold, 360, 190)
$bg.DrawString("BATCAVE THEME FOR MICROSOFT VISUAL STUDIO 2022", $fontSub, $brushBlue, 364, 260)
$bg.DrawString("Cinematic nocturnal aesthetic engineered for professional C# and .NET workstations.", $fontTagline, $brushWhite, 366, 305)

$badges = @("C# & .NET Roslyn", "Gold Panel Borders", "54 Categories Themed", "MEF Watermarks & Settings")
$bx = 366
foreach ($badge in $badges) {
    $sizeB = $bg.MeasureString($badge, $fontBadge)
    $bRect = [System.Drawing.RectangleF]::new($bx, 360, ($sizeB.Width + 20), 32)
    $bg.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#1C2330")), $bRect)
    $bg.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml("#69552B"), 1), $bRect.X, $bRect.Y, $bRect.Width, $bRect.Height)
    $bg.DrawString($badge, $fontBadge, $brushWhite, ($bx + 10), 366)
    $bx += [int]($sizeB.Width + 24)
}

$bg.Dispose()
$bannerPath = Join-Path $assetsDir "marketplace_banner.png"
$bannerBmp.Save($bannerPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bannerBmp.Dispose()
Write-Host "Generated Marketplace Banner: $bannerPath" -ForegroundColor Green
