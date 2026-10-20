# Script to generate original background art and UI assets for Dark Knight Visual Studio Theme
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir
$bgDir = Join-Path $rootDir "src\DarkKnightTheme\Resources\Backgrounds"
$assetsDir = Join-Path $rootDir "assets"
$resDir = Join-Path $rootDir "src\DarkKnightTheme\Resources"

foreach ($dir in @($bgDir, $assetsDir, $resDir)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

Write-Host "Rendering original Dark Knight background artwork and UI assets..." -ForegroundColor Cyan

# Color Palette
$cBg = [System.Drawing.Color]::FromArgb(255, 16, 18, 22)        # #101216
$cGraphite = [System.Drawing.Color]::FromArgb(255, 23, 28, 37)  # #171C25
$cSurface = [System.Drawing.Color]::FromArgb(255, 28, 35, 48)   # #1C2330
$cGold = [System.Drawing.Color]::FromArgb(255, 232, 184, 74)    # #E8B84A
$cGoldMuted = [System.Drawing.Color]::FromArgb(180, 232, 184, 74)
$cGoldSoft = [System.Drawing.Color]::FromArgb(60, 232, 184, 74)
$cBlue = [System.Drawing.Color]::FromArgb(255, 77, 141, 204)    # #4D8DCC
$cBlueMuted = [System.Drawing.Color]::FromArgb(140, 77, 141, 204)
$cBlueSoft = [System.Drawing.Color]::FromArgb(40, 77, 141, 204)
$cCyan = [System.Drawing.Color]::FromArgb(255, 66, 217, 208)    # #42D9D0
$cText = [System.Drawing.Color]::FromArgb(255, 230, 234, 240)   # #E6EAF0
$cTextMuted = [System.Drawing.Color]::FromArgb(255, 146, 155, 168) # #929BA8

# -------------------------------------------------------------
# 1. Background 1: Batcave Mainframe (1920x1080)
# Terminal diagnostics, holographic HUD, radar, telemetry, hex grid
# -------------------------------------------------------------
Write-Host "  -> Generating 1: Batcave Mainframe..."
$bmp1 = [System.Drawing.Bitmap]::new(1920, 1080)
$g1 = [System.Drawing.Graphics]::FromImage($bmp1)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Base fill
$g1.Clear($cBg)

# Subtle radial gradient glow centered at right workstation
$rectHUD = [System.Drawing.Rectangle]::new(800, 100, 1000, 900)
$brushGlow = [System.Drawing.Drawing2D.PathGradientBrush]::new(@(
    [System.Drawing.PointF]::new(800, 100),
    [System.Drawing.PointF]::new(1800, 100),
    [System.Drawing.PointF]::new(1800, 1000),
    [System.Drawing.PointF]::new(800, 1000)
))
$brushGlow.CenterPoint = [System.Drawing.PointF]::new(1350, 550)
$brushGlow.CenterColor = [System.Drawing.Color]::FromArgb(35, 77, 141, 204)
$brushGlow.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 16, 18, 22))
$g1.FillRectangle($brushGlow, 0, 0, 1920, 1080)

# Hexagonal grid pattern
$penHex = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(25, 77, 141, 204), 1)
$r = 40
$h = [math]::Round($r * [math]::Sqrt(3))
for ($y = 0; $y -lt 1100; $y += $h) {
    for ($x = 700; $x -lt 1950; $x += ($r * 3)) {
        $pts1 = @(
            [System.Drawing.PointF]::new($x, $y),
            [System.Drawing.PointF]::new($x + $r, $y),
            [System.Drawing.PointF]::new($x + 1.5 * $r, $y + $h / 2),
            [System.Drawing.PointF]::new($x + $r, $y + $h),
            [System.Drawing.PointF]::new($x, $y + $h),
            [System.Drawing.PointF]::new($x - 0.5 * $r, $y + $h / 2)
        )
        $g1.DrawPolygon($penHex, $pts1)
        
        $xOffset = $x + 1.5 * $r
        $yOffset = $y + $h / 2
        $pts2 = @(
            [System.Drawing.PointF]::new($xOffset, $yOffset),
            [System.Drawing.PointF]::new($xOffset + $r, $yOffset),
            [System.Drawing.PointF]::new($xOffset + 1.5 * $r, $yOffset + $h / 2),
            [System.Drawing.PointF]::new($xOffset + $r, $yOffset + $h),
            [System.Drawing.PointF]::new($xOffset, $yOffset + $h),
            [System.Drawing.PointF]::new($xOffset - 0.5 * $r, $yOffset + $h / 2)
        )
        $g1.DrawPolygon($penHex, $pts2)
    }
}

# Main Tactical HUD Ring (Right Side)
$hudCenterX = 1450
$hudCenterY = 540
$penRingGold = [System.Drawing.Pen]::new($cGoldMuted, 2)
$penRingBlue = [System.Drawing.Pen]::new($cBlueMuted, 1.5)
$penRingThin = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(40, 77, 141, 204), 1)

$g1.DrawEllipse($penRingGold, ($hudCenterX - 320), ($hudCenterY - 320), 640, 640)
$g1.DrawEllipse($penRingBlue, ($hudCenterX - 280), ($hudCenterY - 280), 560, 560)
$g1.DrawEllipse($penRingThin, ($hudCenterX - 200), ($hudCenterY - 200), 400, 400)
$g1.DrawEllipse($penRingGold, ($hudCenterX - 80), ($hudCenterY - 80), 160, 160)

# Arc ticks on the HUD
for ($ang = 0; $ang -lt 360; $ang += 10) {
    $rad = $ang * [math]::PI / 180.0
    $len = if ($ang % 30 -eq 0) { 18 } else { 8 }
    $p1x = $hudCenterX + 280 * [math]::Cos($rad)
    $p1y = $hudCenterY + 280 * [math]::Sin($rad)
    $p2x = $hudCenterX + (280 + $len) * [math]::Cos($rad)
    $p2y = $hudCenterY + (280 + $len) * [math]::Sin($rad)
    $penTick = if ($ang % 30 -eq 0) { $penRingGold } else { $penRingThin }
    $g1.DrawLine($penTick, [float]$p1x, [float]$p1y, [float]$p2x, [float]$p2y)
}

# Radar Crosshairs
$penCross = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 77, 141, 204), 1)
$penCross.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g1.DrawLine($penCross, ($hudCenterX - 360), $hudCenterY, ($hudCenterX + 360), $hudCenterY)
$g1.DrawLine($penCross, $hudCenterX, ($hudCenterY - 360), $hudCenterX, ($hudCenterY + 360))

# Tactical Telemetry Lines & Box Callouts
$penBox = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(90, 77, 141, 204), 1)
$fontHud = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Bold)
$brushHudGold = [System.Drawing.SolidBrush]::new($cGoldMuted)
$brushHudBlue = [System.Drawing.SolidBrush]::new($cBlueMuted)

$g1.DrawRectangle($penBox, 1150, 140, 280, 85)
$g1.DrawString("BATCAVE MAINFRAME // SEC-01", $fontHud, $brushHudGold, 1160, 150)
$g1.DrawString("SYS_STATUS: OPTIMAL", $fontHud, $brushHudBlue, 1160, 172)
$g1.DrawString("ENCRYPTION: QUANTUM-256", $fontHud, $brushHudBlue, 1160, 194)

$g1.DrawRectangle($penBox, 1150, 850, 320, 85)
$g1.DrawString("GOTHAM GRID MONITOR", $fontHud, $brushHudGold, 1160, 860)
$g1.DrawString("NETWORK NODE: WAYNE_TOWER_NORTH", $fontHud, $brushHudBlue, 1160, 882)
$g1.DrawString("SURVEILLANCE FEED: ONLINE", $fontHud, $brushHudBlue, 1160, 904)

# Diagonal connection traces
$penTrace = [System.Drawing.Pen]::new($cGoldSoft, 1.5)
$g1.DrawLines($penTrace, @(
    [System.Drawing.PointF]::new(1150, 180),
    [System.Drawing.PointF]::new(1080, 180),
    [System.Drawing.PointF]::new(1020, 260),
    [System.Drawing.PointF]::new(900, 260)
))
$g1.DrawLines($penTrace, @(
    [System.Drawing.PointF]::new(1150, 890),
    [System.Drawing.PointF]::new(1050, 890),
    [System.Drawing.PointF]::new(980, 820),
    [System.Drawing.PointF]::new(880, 820)
))

# Save full image and thumbnail
$bg1Path = Join-Path $bgDir "batcave_mainframe.png"
$bmp1.Save($bg1Path, [System.Drawing.Imaging.ImageFormat]::Png)
$thumb1 = $bmp1.GetThumbnailImage(240, 135, $null, [IntPtr]::Zero)
$thumb1.Save((Join-Path $bgDir "thumb_batcave_mainframe.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$thumb1.Dispose()
$g1.Dispose()
$bmp1.Dispose()

# -------------------------------------------------------------
# 2. Background 2: Gotham Skyline (1920x1080)
# Nocturnal skyline silhouette, Gotham spires, dual searchlights
# -------------------------------------------------------------
Write-Host "  -> Generating 2: Gotham Skyline..."
$bmp2 = [System.Drawing.Bitmap]::new(1920, 1080)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Night sky gradient (deep navy charcoal to near-black)
$rectSky = [System.Drawing.Rectangle]::new(0, 0, 1920, 1080)
$brushSky = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rectSky,
    [System.Drawing.Color]::FromArgb(255, 12, 16, 24),
    [System.Drawing.Color]::FromArgb(255, 16, 18, 22),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$g2.FillRectangle($brushSky, $rectSky)

# Dual Vigilante Searchlights sweeping the nocturnal clouds
$polySearch1 = @(
    [System.Drawing.PointF]::new(500, 1080),
    [System.Drawing.PointF]::new(1100, -100),
    [System.Drawing.PointF]::new(1350, -100),
    [System.Drawing.PointF]::new(560, 1080)
)
$brushSearch1 = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.PointF]::new(530, 1080),
    [System.Drawing.PointF]::new(1225, 0),
    [System.Drawing.Color]::FromArgb(45, 232, 184, 74),
    [System.Drawing.Color]::FromArgb(5, 77, 141, 204)
)
$g2.FillPolygon($brushSearch1, $polySearch1)

$polySearch2 = @(
    [System.Drawing.PointF]::new(1500, 1080),
    [System.Drawing.PointF]::new(850, -100),
    [System.Drawing.PointF]::new(1050, -100),
    [System.Drawing.PointF]::new(1550, 1080)
)
$brushSearch2 = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.PointF]::new(1525, 1080),
    [System.Drawing.PointF]::new(950, 0),
    [System.Drawing.Color]::FromArgb(35, 77, 141, 204),
    [System.Drawing.Color]::FromArgb(5, 232, 184, 74)
)
$g2.FillPolygon($brushSearch2, $polySearch2)

# Abstract Nocturnal Vigilante Signal Beam intersection in the sky
$g2.FillEllipse([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(30, 232, 184, 74)), 1050, 140, 220, 130)
$g2.DrawEllipse([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 232, 184, 74), 2), 1050, 140, 220, 130)

# Distant Layer of Gotham Skyline (Deepest silhouette)
$brushDistant = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 19, 24, 33))
$distantBuildings = @(
    @{ X = 50; W = 90; H = 450 },
    @{ X = 160; W = 110; H = 550 },
    @{ X = 290; W = 70; H = 380 },
    @{ X = 380; W = 140; H = 600; Spire = $true },
    @{ X = 540; W = 100; H = 490 },
    @{ X = 660; W = 130; H = 420 },
    @{ X = 810; W = 110; H = 680; Spire = $true },
    @{ X = 940; W = 90; H = 510 },
    @{ X = 1050; W = 150; H = 720; Tower = $true }, # Wayne Tower style central
    @{ X = 1220; W = 80; H = 480 },
    @{ X = 1320; W = 120; H = 630; Spire = $true },
    @{ X = 1460; W = 100; H = 430 },
    @{ X = 1580; W = 130; H = 580 },
    @{ X = 1730; W = 140; H = 490 }
)
foreach ($b in $distantBuildings) {
    $y = 1080 - $b.H
    $g2.FillRectangle($brushDistant, $b.X, $y, $b.W, $b.H)
    if ($b.Spire) {
        $spirePts = @(
            [System.Drawing.PointF]::new($b.X + $b.W / 2 - 6, $y),
            [System.Drawing.PointF]::new($b.X + $b.W / 2, $y - 70),
            [System.Drawing.PointF]::new($b.X + $b.W / 2 + 6, $y)
        )
        $g2.FillPolygon($brushDistant, $spirePts)
    }
}

# Foreground Layer of Gotham Skyline (Gothic architectural ledges & monolithic high-rises)
$brushForeground = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 13, 15, 19))
$fgBuildings = @(
    @{ X = 0; W = 140; H = 350 },
    @{ X = 150; W = 120; H = 420; Spire = $true },
    @{ X = 320; W = 160; H = 480 },
    @{ X = 510; W = 110; H = 370 },
    @{ X = 650; W = 180; H = 530; Spire = $true },
    @{ X = 850; W = 130; H = 410 },
    @{ X = 1000; W = 210; H = 590; Deco = $true },
    @{ X = 1240; W = 150; H = 470 },
    @{ X = 1410; W = 170; H = 520; Spire = $true },
    @{ X = 1600; W = 190; H = 410 },
    @{ X = 1810; W = 120; H = 360 }
)
foreach ($b in $fgBuildings) {
    $y = 1080 - $b.H
    $g2.FillRectangle($brushForeground, $b.X, $y, $b.W, $b.H)
    if ($b.Spire) {
        $spirePts = @(
            [System.Drawing.PointF]::new($b.X + $b.W / 2 - 10, $y),
            [System.Drawing.PointF]::new($b.X + $b.W / 2, $y - 110),
            [System.Drawing.PointF]::new($b.X + $b.W / 2 + 10, $y)
        )
        $g2.FillPolygon($brushForeground, $spirePts)
        # Gold beacon tip
        $g2.FillEllipse([System.Drawing.SolidBrush]::new($cGoldMuted), ($b.X + $b.W / 2 - 3), ($y - 113), 6, 6)
    }
}

# Subtle window glow pinpoints in gold and cyan
$rand = [System.Random]::new(42)
$penWinGold = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 232, 184, 74), 2)
$penWinBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(45, 66, 217, 208), 2)
for ($i = 0; $i -lt 180; $i++) {
    $wx = $rand.Next(30, 1890)
    $wy = $rand.Next(650, 1040)
    $p = if ($rand.Next(2) -eq 0) { $penWinGold } else { $penWinBlue }
    $g2.DrawLine($p, $wx, $wy, ($wx + 4), $wy)
}

# Save full image and thumbnail
$bg2Path = Join-Path $bgDir "gotham_skyline.png"
$bmp2.Save($bg2Path, [System.Drawing.Imaging.ImageFormat]::Png)
$thumb2 = $bmp2.GetThumbnailImage(240, 135, $null, [IntPtr]::Zero)
$thumb2.Save((Join-Path $bgDir "thumb_gotham_skyline.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$thumb2.Dispose()
$g2.Dispose()
$bmp2.Dispose()

# -------------------------------------------------------------
# 3. Background 3: Gargoyle Vigil (1920x1080)
# Gothic stone gargoyle perched high above a misty dark Gotham
# -------------------------------------------------------------
Write-Host "  -> Generating 3: Gargoyle Vigil..."
$bmp3 = [System.Drawing.Bitmap]::new(1920, 1080)
$g3 = [System.Drawing.Graphics]::FromImage($bmp3)
$g3.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Background dark gradient
$g3.Clear($cBg)
$rectMisty = [System.Drawing.Rectangle]::new(0, 0, 1920, 1080)
$brushMisty = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rectMisty,
    [System.Drawing.Color]::FromArgb(255, 14, 18, 25),
    [System.Drawing.Color]::FromArgb(255, 16, 18, 22),
    [System.Drawing.Drawing2D.LinearGradientMode]::BackwardDiagonal
)
$g3.FillRectangle($brushMisty, $rectMisty)

# Gotham city glow far below (left to center)
$brushAbyss = [System.Drawing.Drawing2D.PathGradientBrush]::new(@(
    [System.Drawing.PointF]::new(0, 700),
    [System.Drawing.PointF]::new(1200, 700),
    [System.Drawing.PointF]::new(1200, 1080),
    [System.Drawing.PointF]::new(0, 1080)
))
$brushAbyss.CenterPoint = [System.Drawing.PointF]::new(500, 950)
$brushAbyss.CenterColor = [System.Drawing.Color]::FromArgb(35, 77, 141, 204)
$brushAbyss.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 16, 18, 22))
$g3.FillRectangle($brushAbyss, 0, 600, 1200, 480)

# Distant Gothic Cathedral spires in the mist (left)
$penGoth = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(40, 77, 141, 204), 1.5)
for ($sx = 100; $sx -lt 900; $sx += 180) {
    $sy = 650
    $g3.DrawLine($penGoth, $sx, 1080, $sx, $sy)
    $g3.DrawLine($penGoth, $sx, $sy, ($sx + 15), ($sy - 90))
    $g3.DrawLine($penGoth, ($sx + 15), ($sy - 90), ($sx + 30), $sy)
    $g3.DrawLine($penGoth, ($sx + 30), $sy, ($sx + 30), 1080)
}

# The Gothic Stone Ledge & Gargoyle (Dominating bottom-right corner)
# Sculpted stone ledge
$brushStone = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 12, 14, 18))
$penStoneEdge = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(70, 232, 184, 74), 1.5)

# Ledge polygon jutting out from right
$ledgePts = @(
    [System.Drawing.PointF]::new(1150, 620),
    [System.Drawing.PointF]::new(1320, 620),
    [System.Drawing.PointF]::new(1480, 560),
    [System.Drawing.PointF]::new(1920, 560),
    [System.Drawing.PointF]::new(1920, 1080),
    [System.Drawing.PointF]::new(1050, 1080),
    [System.Drawing.PointF]::new(1050, 750),
    [System.Drawing.PointF]::new(1150, 620)
)
$g3.FillPolygon($brushStone, $ledgePts)
$g3.DrawLines($penStoneEdge, @(
    [System.Drawing.PointF]::new(1150, 620),
    [System.Drawing.PointF]::new(1320, 620),
    [System.Drawing.PointF]::new(1480, 560),
    [System.Drawing.PointF]::new(1920, 560)
))

# The Gargoyle Figurine (Crouched vigilante / stone beast silhouette)
$gargoylePts = @(
    # Claw / Perch at front of ledge
    [System.Drawing.PointF]::new(1180, 620),
    [System.Drawing.PointF]::new(1160, 610),
    [System.Drawing.PointF]::new(1150, 580),
    # Forelimbs
    [System.Drawing.PointF]::new(1170, 540),
    [System.Drawing.PointF]::new(1210, 500),
    # Chest / Torso
    [System.Drawing.PointF]::new(1230, 460),
    # Horned Vigilante Head / Snout
    [System.Drawing.PointF]::new(1200, 420),
    [System.Drawing.PointF]::new(1170, 410),
    [System.Drawing.PointF]::new(1190, 370), # Ear / Horn tip
    [System.Drawing.PointF]::new(1220, 390),
    [System.Drawing.PointF]::new(1250, 360), # Second horn tip
    [System.Drawing.PointF]::new(1265, 410),
    # Arching Bat Wings (Rising sharply behind)
    [System.Drawing.PointF]::new(1320, 340),
    [System.Drawing.PointF]::new(1390, 240), # High wing apex 1
    [System.Drawing.PointF]::new(1380, 290),
    [System.Drawing.PointF]::new(1440, 210), # High wing apex 2
    [System.Drawing.PointF]::new(1420, 280),
    [System.Drawing.PointF]::new(1470, 240), # High wing apex 3
    [System.Drawing.PointF]::new(1430, 340),
    [System.Drawing.PointF]::new(1410, 410),
    # Back & Haunches
    [System.Drawing.PointF]::new(1440, 480),
    [System.Drawing.PointF]::new(1490, 530),
    [System.Drawing.PointF]::new(1480, 560),
    [System.Drawing.PointF]::new(1320, 620),
    [System.Drawing.PointF]::new(1180, 620)
)
$g3.FillPolygon($brushStone, $gargoylePts)
$g3.DrawLines($penStoneEdge, $gargoylePts)

# Subtle vigilante eye glint (Gold dot)
$g3.FillEllipse([System.Drawing.SolidBrush]::new($cGold), 1205, 400, 5, 5)

# Save full image and thumbnail
$bg3Path = Join-Path $bgDir "gargoyle_vigil.png"
$bmp3.Save($bg3Path, [System.Drawing.Imaging.ImageFormat]::Png)
$thumb3 = $bmp3.GetThumbnailImage(240, 135, $null, [IntPtr]::Zero)
$thumb3.Save((Join-Path $bgDir "thumb_gargoyle_vigil.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$thumb3.Dispose()
$g3.Dispose()
$bmp3.Dispose()

# -------------------------------------------------------------
# 4. Background 4: Batmobile Tech Grid (1920x1080)
# Tactical vehicle wireframe blueprint schematic with telemetry
# -------------------------------------------------------------
Write-Host "  -> Generating 4: Batmobile Tech Grid..."
$bmp4 = [System.Drawing.Bitmap]::new(1920, 1080)
$g4 = [System.Drawing.Graphics]::FromImage($bmp4)
$g4.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g4.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

$g4.Clear($cBg)

# Engineering Blueprint Orthogonal Grid Lines
$penCadGrid = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(18, 77, 141, 204), 1)
for ($x = 0; $x -lt 1920; $x += 60) {
    $g4.DrawLine($penCadGrid, $x, 0, $x, 1080)
}
for ($y = 0; $y -lt 1080; $y += 60) {
    $g4.DrawLine($penCadGrid, 0, $y, 1920, $y)
}

# Major Coordinate Axes
$penCadAxis = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(45, 77, 141, 204), 1.5)
$penCadAxis.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g4.DrawLine($penCadAxis, 0, 540, 1920, 540)
$g4.DrawLine($penCadAxis, 1200, 0, 1200, 1080)

# Wireframe Schematics of the Tactical Interceptor (Center-Right)
$penCarBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(130, 77, 141, 204), 2)
$penCarGold = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 232, 184, 74), 2)
$penCarThin = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 66, 217, 208), 1)

# Main chassis top-down / 3/4 isometric tactical wireframe
$chassisPts = @(
    # Nose & Armor wedge
    [System.Drawing.PointF]::new(700, 540),
    [System.Drawing.PointF]::new(780, 480),
    [System.Drawing.PointF]::new(940, 470),
    # Front Wheels & Suspension Pods
    [System.Drawing.PointF]::new(980, 410),
    [System.Drawing.PointF]::new(1120, 410),
    [System.Drawing.PointF]::new(1150, 470),
    # Cockpit Armor Canopy
    [System.Drawing.PointF]::new(1300, 460),
    # Rear Afterburner & Fenders
    [System.Drawing.PointF]::new(1450, 390),
    [System.Drawing.PointF]::new(1650, 380),
    [System.Drawing.PointF]::new(1720, 470),
    # Jet Turbine exhaust
    [System.Drawing.PointF]::new(1680, 540),
    # Lower symmetry half
    [System.Drawing.PointF]::new(1720, 610),
    [System.Drawing.PointF]::new(1650, 700),
    [System.Drawing.PointF]::new(1450, 690),
    [System.Drawing.PointF]::new(1300, 620),
    [System.Drawing.PointF]::new(1150, 610),
    [System.Drawing.PointF]::new(1120, 670),
    [System.Drawing.PointF]::new(980, 670),
    [System.Drawing.PointF]::new(940, 610),
    [System.Drawing.PointF]::new(780, 600),
    [System.Drawing.PointF]::new(700, 540)
)
$g4.DrawPolygon($penCarBlue, $chassisPts)

# Reinforced Cockpit Canopy
$canopyPts = @(
    [System.Drawing.PointF]::new(1080, 540),
    [System.Drawing.PointF]::new(1170, 490),
    [System.Drawing.PointF]::new(1320, 490),
    [System.Drawing.PointF]::new(1370, 540),
    [System.Drawing.PointF]::new(1320, 590),
    [System.Drawing.PointF]::new(1170, 590),
    [System.Drawing.PointF]::new(1080, 540)
)
$g4.DrawPolygon($penCarGold, $canopyPts)

# Turbine Rings at Exhaust
$g4.DrawEllipse($penCarGold, 1630, 510, 60, 60)
$g4.DrawEllipse($penCarBlue, 1610, 490, 100, 100)
$g4.DrawEllipse($penCarThin, 1580, 460, 160, 160)

# Front Wheel Hubs
$g4.DrawEllipse($penCarGold, 990, 420, 110, 45)
$g4.DrawEllipse($penCarGold, 990, 615, 110, 45)

# Rear Massive Dual Wheels
$g4.DrawEllipse($penCarGold, 1470, 395, 150, 55)
$g4.DrawEllipse($penCarGold, 1470, 630, 150, 55)

# Blueprint Dimension Lines & Callouts
$penDim = [System.Drawing.Pen]::new($cGoldSoft, 1)
$penDim.DashStyle = [System.Drawing.Drawing2D.DashStyle]::DashDot

# Length dimension
$g4.DrawLine($penDim, 700, 320, 1720, 320)
$g4.DrawLine($penDim, 700, 310, 700, 330)
$g4.DrawLine($penDim, 1720, 310, 1720, 330)
$g4.DrawLine($penDim, 700, 330, 700, 540)
$g4.DrawLine($penDim, 1720, 330, 1720, 540)

# Telemetry Text Callouts
$fontCad = [System.Drawing.Font]::new("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$brushCadGold = [System.Drawing.SolidBrush]::new($cGoldMuted)
$brushCadBlue = [System.Drawing.SolidBrush]::new($cBlueMuted)

$g4.DrawString("<--- DIM_L: 5480 mm --->", $fontCad, $brushCadGold, 1130, 302)
$g4.DrawString("WAYNE ENTERPRISES // ADVANCED TECH DIV", $fontCad, $brushCadGold, 80, 80)
$g4.DrawString("PROJECT: TACTICAL INTERCEPTOR (MK-VII)", $fontCad, $brushCadBlue, 80, 102)
$g4.DrawString("PROPULSION: HYBRID GAS TURBINE + DUAL AFTERBURNER", $fontCad, $brushCadBlue, 80, 124)
$g4.DrawString("ARMOR: COMPOSITE GRAPHENE-TITANIUM MONOCOQUE", $fontCad, $brushCadBlue, 80, 146)
$g4.DrawString("MAX VELOCITY: 330 MPH // DRY WEIGHT: 2.4 TONNES", $fontCad, $brushCadBlue, 80, 168)

$g4.DrawRectangle($penCadAxis, 70, 70, 460, 130)

# Save full image and thumbnail
$bg4Path = Join-Path $bgDir "batmobile_techgrid.png"
$bmp4.Save($bg4Path, [System.Drawing.Imaging.ImageFormat]::Png)
$thumb4 = $bmp4.GetThumbnailImage(240, 135, $null, [IntPtr]::Zero)
$thumb4.Save((Join-Path $bgDir "thumb_batmobile_techgrid.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$thumb4.Dispose()
$g4.Dispose()
$bmp4.Dispose()

# -------------------------------------------------------------
# 5. Status Bar Icon (16x16)
# Subtle Batcave nocturnal vigilante cowl silhouette
# -------------------------------------------------------------
Write-Host "  -> Generating Status Bar Icon (16x16)..."
$bmpStatus = [System.Drawing.Bitmap]::new(16, 16)
$gStatus = [System.Drawing.Graphics]::FromImage($bmpStatus)
$gStatus.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gStatus.Clear([System.Drawing.Color]::Transparent)

# 16x16 subtle cowl polygon
$ptsStatus = @(
    [System.Drawing.PointF]::new(8, 14),   # Chin
    [System.Drawing.PointF]::new(3, 8),    # Left cheek
    [System.Drawing.PointF]::new(2, 3),    # Left ear tip
    [System.Drawing.PointF]::new(5, 5),    # Left ear inner
    [System.Drawing.PointF]::new(8, 6),    # Brow dip
    [System.Drawing.PointF]::new(11, 5),   # Right ear inner
    [System.Drawing.PointF]::new(14, 3),   # Right ear tip
    [System.Drawing.PointF]::new(13, 8),   # Right cheek
    [System.Drawing.PointF]::new(8, 14)
)
$gStatus.FillPolygon([System.Drawing.SolidBrush]::new($cGold), $ptsStatus)
$bmpStatus.Save((Join-Path $resDir "statusbar_icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$gStatus.Dispose()
$bmpStatus.Dispose()

# -------------------------------------------------------------
# 6. Tool Window Icon (16x16)
# Batcave workstation console / cowl in Gotham Blue & Gold
# -------------------------------------------------------------
Write-Host "  -> Generating Tool Window Icon (16x16)..."
$bmpTool = [System.Drawing.Bitmap]::new(16, 16)
$gTool = [System.Drawing.Graphics]::FromImage($bmpTool)
$gTool.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gTool.Clear([System.Drawing.Color]::Transparent)

$gTool.FillPolygon([System.Drawing.SolidBrush]::new($cBlue), $ptsStatus)
# Small gold core eye dots
$gTool.FillRectangle([System.Drawing.SolidBrush]::new($cGold), 5, 8, 2, 2)
$gTool.FillRectangle([System.Drawing.SolidBrush]::new($cGold), 9, 8, 2, 2)
$bmpTool.Save((Join-Path $resDir "toolwindow_icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$gTool.Dispose()
$bmpTool.Dispose()

# -------------------------------------------------------------
# 7. Dark Surface Pattern Texture (64x64 Seamless)
# Subtle Batcave carbon-fiber / hex weave for UI surfaces
# -------------------------------------------------------------
Write-Host "  -> Generating Dark Surface Pattern Texture (64x64)..."
$bmpTex = [System.Drawing.Bitmap]::new(64, 64)
$gTex = [System.Drawing.Graphics]::FromImage($bmpTex)
$gTex.Clear($cGraphite)

$penWeave1 = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 24, 30, 40), 1)
$penWeave2 = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 20, 24, 33), 1)
for ($x = 0; $x -lt 64; $x += 4) {
    for ($y = 0; $y -lt 64; $y += 4) {
        if (($x + $y) % 8 -eq 0) {
            $bmpTex.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, 29, 36, 49))
        }
    }
}
$bmpTex.Save((Join-Path $resDir "dark_texture.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$gTex.Dispose()
$bmpTex.Dispose()

# -------------------------------------------------------------
# 8. Gold and Blue Abstract Emblem (assets/emblem.png, 256x256)
# -------------------------------------------------------------
Write-Host "  -> Generating Abstract Emblem (256x256)..."
$bmpEmblem = [System.Drawing.Bitmap]::new(256, 256)
$gEmblem = [System.Drawing.Graphics]::FromImage($bmpEmblem)
$gEmblem.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gEmblem.Clear([System.Drawing.Color]::Transparent)

# Outer circle
$gEmblem.DrawEllipse([System.Drawing.Pen]::new($cGold, 4), 16, 16, 224, 224)
$gEmblem.DrawEllipse([System.Drawing.Pen]::new($cBlue, 2), 26, 26, 204, 204)

# Angular Nocturnal Vigilante Emblem
$emblemPts = @(
    [System.Drawing.PointF]::new(128, 200),
    [System.Drawing.PointF]::new(50, 120),
    [System.Drawing.PointF]::new(36, 60),
    [System.Drawing.PointF]::new(80, 88),
    [System.Drawing.PointF]::new(128, 105),
    [System.Drawing.PointF]::new(176, 88),
    [System.Drawing.PointF]::new(220, 60),
    [System.Drawing.PointF]::new(206, 120),
    [System.Drawing.PointF]::new(128, 200)
)
$gEmblem.FillPolygon([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(220, 23, 28, 37)), $emblemPts)
$gEmblem.DrawPolygon([System.Drawing.Pen]::new($cGold, 3), $emblemPts)

# Inner Blue Core Wings
$innerPts = @(
    [System.Drawing.PointF]::new(128, 175),
    [System.Drawing.PointF]::new(75, 122),
    [System.Drawing.PointF]::new(65, 85),
    [System.Drawing.PointF]::new(98, 102),
    [System.Drawing.PointF]::new(128, 114),
    [System.Drawing.PointF]::new(158, 102),
    [System.Drawing.PointF]::new(191, 85),
    [System.Drawing.PointF]::new(181, 122),
    [System.Drawing.PointF]::new(128, 175)
)
$gEmblem.FillPolygon([System.Drawing.SolidBrush]::new($cBlue), $innerPts)
$bmpEmblem.Save((Join-Path $assetsDir "emblem.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$gEmblem.Dispose()
$bmpEmblem.Dispose()

Write-Host "All backgrounds and UI assets generated successfully!" -ForegroundColor Green
