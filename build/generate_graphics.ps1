# Generate original branding assets and preview screenshots for Dark Knight Theme
Add-Type -AssemblyName System.Drawing

$resDir = "src\DarkKnightTheme\Resources"
$screenDir = "assets\screenshots"
$assetsDir = "assets"

function Ensure-Directory($p) {
    if (-not (Test-Path $p)) {
        New-Item -ItemType Directory -Force -Path $p | Out-Null
    }
}

Ensure-Directory $resDir
Ensure-Directory $screenDir
Ensure-Directory $assetsDir

# 1. Generate Vector SVG Icon
$svgIcon = @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#191D24" />
      <stop offset="100%" stop-color="#101216" />
    </linearGradient>
    <linearGradient id="goldGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#F5D061" />
      <stop offset="100%" stop-color="#C69B37" />
    </linearGradient>
    <linearGradient id="blueGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#6DB3F2" />
      <stop offset="100%" stop-color="#3A6F9E" />
    </linearGradient>
    <filter id="shadow" x="-10%" y="-10%" width="120%" height="120%">
      <feDropShadow dx="0" dy="4" stdDeviation="6" flood-color="#000000" flood-opacity="0.6"/>
    </filter>
  </defs>

  <!-- Background Base -->
  <rect x="8" y="8" width="240" height="240" rx="36" fill="url(#bgGrad)" stroke="#232833" stroke-width="4"/>
  <rect x="16" y="16" width="224" height="224" rx="28" fill="none" stroke="#2A313D" stroke-width="1.5" opacity="0.6"/>

  <!-- Batcave Workstation Crest (Original Geometric Design) -->
  <g filter="url(#shadow)">
    <!-- Outer Wing Framing / Code Bracket Silhouettes -->
    <path d="M 36 90 
             Q 80 84 108 116 
             Q 120 72 128 52 
             Q 136 72 148 116 
             Q 176 84 220 90 
             Q 196 142 168 160 
             Q 180 192 128 214 
             Q 76 192 88 160 
             Q 60 142 36 90 Z" 
          fill="#14171E" stroke="url(#goldGrad)" stroke-width="3" />

    <!-- Inner Batman Gold Angular Core Accent -->
    <path d="M 52 102 
             Q 86 98 112 124 
             L 122 88 
             L 128 72 
             L 134 88 
             L 144 124 
             Q 170 98 204 102 
             Q 186 140 162 152 
             Q 166 178 128 196 
             Q 90 178 94 152 
             Q 70 140 52 102 Z" 
          fill="#191D24" stroke="url(#goldGrad)" stroke-width="2"/>

    <!-- Central Bat Terminal Emblem: Angular Bat Head & Code Bracket Motif -->
    <!-- Bat Ears & Forehead -->
    <polygon points="120,96 123,76 126,94 130,94 133,76 136,96 128,102" fill="url(#goldGrad)"/>

    <!-- Left Wing Terminal Chevron < -->
    <polyline points="96,120 78,136 96,152" fill="none" stroke="#4D8DCC" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    
    <!-- Right Wing Terminal Chevron > -->
    <polyline points="160,120 178,136 160,152" fill="none" stroke="#4D8DCC" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>

    <!-- Bat Slash / Core Terminal Prompt -->
    <line x1="124" y1="156" x2="132" y2="120" stroke="#E8B84A" stroke-width="3.5" stroke-linecap="round"/>
  </g>

  <!-- Accent Bottom Status Indicator -->
  <circle cx="128" cy="228" r="3.5" fill="#E8B84A"/>
  <circle cx="114" cy="228" r="2.5" fill="#4D8DCC" opacity="0.8"/>
  <circle cx="142" cy="228" r="2.5" fill="#4D8DCC" opacity="0.8"/>
</svg>
'@

Set-Content -Path "$assetsDir\icon.svg" -Value $svgIcon -Encoding UTF8
Set-Content -Path "$resDir\batcave-icon.svg" -Value $svgIcon -Encoding UTF8

# 2. Render Icon.png using System.Drawing
function Generate-IconPng([string]$outPath, [int]$size) {
    $bmp = [System.Drawing.Bitmap]::new($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    $scale = [float]($size / 256.0)

    # Draw rounded rectangle background
    $rect = [System.Drawing.RectangleF]::new([float](8 * $scale), [float](8 * $scale), [float](240 * $scale), [float](240 * $scale))
    $bgBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
        [System.Drawing.PointF]::new(0, 0),
        [System.Drawing.PointF]::new($size, $size),
        [System.Drawing.ColorTranslator]::FromHtml("#191D24"),
        [System.Drawing.ColorTranslator]::FromHtml("#101216")
    )
    
    $borderPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml("#232833"), [float](4 * $scale))
    $goldPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A"), [float](3 * $scale))
    $bluePen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml("#4D8DCC"), [float](4.5 * $scale))
    $bluePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $bluePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $bluePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    # Fill background rounded rect
    $cornerRadius = [float](36 * $scale)
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddArc($rect.X, $rect.Y, $cornerRadius, $cornerRadius, 180, 90)
    $path.AddArc($rect.Right - $cornerRadius, $rect.Y, $cornerRadius, $cornerRadius, 270, 90)
    $path.AddArc($rect.Right - $cornerRadius, $rect.Bottom - $cornerRadius, $cornerRadius, $cornerRadius, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $cornerRadius, $cornerRadius, $cornerRadius, 90, 90)
    $path.CloseFigure()

    $g.FillPath($bgBrush, $path)
    $g.DrawPath($borderPen, $path)

    # Inner Bat Silhouette Outer Wing
    $outerWing = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $pts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new([float](36 * $scale), [float](90 * $scale)),
        [System.Drawing.PointF]::new([float](76 * $scale), [float](84 * $scale)),
        [System.Drawing.PointF]::new([float](108 * $scale), [float](116 * $scale)),
        [System.Drawing.PointF]::new([float](122 * $scale), [float](78 * $scale)),
        [System.Drawing.PointF]::new([float](128 * $scale), [float](56 * $scale)),
        [System.Drawing.PointF]::new([float](134 * $scale), [float](78 * $scale)),
        [System.Drawing.PointF]::new([float](148 * $scale), [float](116 * $scale)),
        [System.Drawing.PointF]::new([float](180 * $scale), [float](84 * $scale)),
        [System.Drawing.PointF]::new([float](220 * $scale), [float](90 * $scale)),
        [System.Drawing.PointF]::new([float](192 * $scale), [float](142 * $scale)),
        [System.Drawing.PointF]::new([float](168 * $scale), [float](160 * $scale)),
        [System.Drawing.PointF]::new([float](180 * $scale), [float](192 * $scale)),
        [System.Drawing.PointF]::new([float](128 * $scale), [float](214 * $scale)),
        [System.Drawing.PointF]::new([float](76 * $scale), [float](192 * $scale)),
        [System.Drawing.PointF]::new([float](88 * $scale), [float](160 * $scale)),
        [System.Drawing.PointF]::new([float](64 * $scale), [float](142 * $scale))
    )
    $outerWing.AddPolygon($pts)
    $darkCrestBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#14171E"))
    $g.FillPath($darkCrestBrush, $outerWing)
    $g.DrawPath($goldPen, $outerWing)

    # Left bracket <
    $leftPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new([float](94 * $scale), [float](122 * $scale)),
        [System.Drawing.PointF]::new([float](78 * $scale), [float](136 * $scale)),
        [System.Drawing.PointF]::new([float](94 * $scale), [float](150 * $scale))
    )
    $g.DrawLines($bluePen, $leftPts)

    # Right bracket >
    $rightPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new([float](162 * $scale), [float](122 * $scale)),
        [System.Drawing.PointF]::new([float](178 * $scale), [float](136 * $scale)),
        [System.Drawing.PointF]::new([float](162 * $scale), [float](150 * $scale))
    )
    $g.DrawLines($bluePen, $rightPts)

    # Center slash /
    $slashPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A"), [float](3.5 * $scale))
    $slashPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $slashPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($slashPen, [float](124 * $scale), [float](154 * $scale), [float](132 * $scale), [float](120 * $scale))

    # Bat Ears at apex
    $earBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A"))
    $earPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new([float](121 * $scale), [float](94 * $scale)),
        [System.Drawing.PointF]::new([float](124 * $scale), [float](74 * $scale)),
        [System.Drawing.PointF]::new([float](127 * $scale), [float](92 * $scale)),
        [System.Drawing.PointF]::new([float](129 * $scale), [float](92 * $scale)),
        [System.Drawing.PointF]::new([float](132 * $scale), [float](74 * $scale)),
        [System.Drawing.PointF]::new([float](135 * $scale), [float](94 * $scale)),
        [System.Drawing.PointF]::new([float](128 * $scale), [float](100 * $scale))
    )
    $g.FillPolygon($earBrush, $earPts)

    # Accent dots at bottom
    $goldDotBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#E8B84A"))
    $blueDotBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#4D8DCC"))
    $g.FillEllipse($goldDotBrush, [float](125 * $scale), [float](225 * $scale), [float](6 * $scale), [float](6 * $scale))
    $g.FillEllipse($blueDotBrush, [float](111 * $scale), [float](226 * $scale), [float](4 * $scale), [float](4 * $scale))
    $g.FillEllipse($blueDotBrush, [float](141 * $scale), [float](226 * $scale), [float](4 * $scale), [float](4 * $scale))

    $g.Dispose()
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Generated icon: $outPath ($size x $size)"
}

Generate-IconPng "$resDir\Icon.png" 128
Generate-IconPng "$assetsDir\icon_256.png" 256

# 3. Generate Screenshots and Preview Assets
function Generate-IdePreviewScreenshot([string]$outPath, [string]$titleText, [string]$subtitleText, [string]$mode) {
    $width = 1200
    $height = 750
    $bmp = [System.Drawing.Bitmap]::new($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $cMainBg = [System.Drawing.ColorTranslator]::FromHtml("#101216")
    $cSurface = [System.Drawing.ColorTranslator]::FromHtml("#191D24")
    $cHeader = [System.Drawing.ColorTranslator]::FromHtml("#14171E")
    $cBorder = [System.Drawing.ColorTranslator]::FromHtml("#232833")
    $cGold = [System.Drawing.ColorTranslator]::FromHtml("#E8B84A")
    $cGothamBlue = [System.Drawing.ColorTranslator]::FromHtml("#4D8DCC")
    $cCyan = [System.Drawing.ColorTranslator]::FromHtml("#4EC9B0")
    $cMint = [System.Drawing.ColorTranslator]::FromHtml("#52BAA7")
    $cSoftBlue = [System.Drawing.ColorTranslator]::FromHtml("#61AFEF")
    $cLavender = [System.Drawing.ColorTranslator]::FromHtml("#C678DD")
    $cGreenGray = [System.Drawing.ColorTranslator]::FromHtml("#62727B")
    $cTextPrimary = [System.Drawing.ColorTranslator]::FromHtml("#E6E8ED")
    $cTextSecondary = [System.Drawing.ColorTranslator]::FromHtml("#929BA8")
    $cLineNum = [System.Drawing.ColorTranslator]::FromHtml("#4E5766")
    $cSelection = [System.Drawing.ColorTranslator]::FromHtml("#1B385C")
    $cActiveLine = [System.Drawing.ColorTranslator]::FromHtml("#161A22")
    $cRed = [System.Drawing.ColorTranslator]::FromHtml("#E5484D")
    $cAmber = [System.Drawing.ColorTranslator]::FromHtml("#E09F3E")
    $cDebugBar = [System.Drawing.ColorTranslator]::FromHtml("#1A365D")

    $fontCode = [System.Drawing.Font]::new("Consolas", [float]11.5, [System.Drawing.FontStyle]::Regular)
    $fontCodeBold = [System.Drawing.Font]::new("Consolas", [float]11.5, [System.Drawing.FontStyle]::Bold)
    $fontCodeItalic = [System.Drawing.Font]::new("Consolas", [float]11.5, [System.Drawing.FontStyle]::Italic)
    $fontUI = [System.Drawing.Font]::new("Segoe UI", [float]9.5, [System.Drawing.FontStyle]::Regular)
    $fontUIBold = [System.Drawing.Font]::new("Segoe UI", [float]9.5, [System.Drawing.FontStyle]::Bold)

    # Background
    $g.Clear($cMainBg)

    # 1. Title Bar
    $titleBarRect = [System.Drawing.Rectangle]::new(0, 0, $width, 36)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), $titleBarRect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, 36, $width, 36)

    # Bat icon in title bar
    $g.FillEllipse([System.Drawing.SolidBrush]::new($cGold), 14, 11, 14, 14)
    $g.DrawString("DarkKnight - Batcave Workstation - Microsoft Visual Studio (Community 2022) [Dark Knight Theme]", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 36, 9)

    # 2. Menu Bar
    $menuRect = [System.Drawing.Rectangle]::new(0, 37, $width, 28)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), $menuRect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, 65, $width, 65)

    $menus = @("File", "Edit", "View", "Git", "Project", "Build", "Debug", "Test", "Analyze", "Tools", "Extensions", "Window", "Help")
    $curX = 14
    foreach ($m in $menus) {
        $brush = if ($m -eq "Tools" -or $m -eq "Debug") { [System.Drawing.SolidBrush]::new($cTextPrimary) } else { [System.Drawing.SolidBrush]::new($cTextSecondary) }
        if ($m -eq "Tools") {
            $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#252B35")), ($curX - 4), 39, 44, 24)
        }
        $g.DrawString($m, $fontUI, $brush, $curX, 42)
        $curX += ($g.MeasureString($m, $fontUI).Width + 14)
    }

    # 3. Document Tabs Bar
    $tabBarRect = [System.Drawing.Rectangle]::new(0, 66, ($width - 320), 32)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), $tabBarRect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, 98, $width, 98)

    # Active Tab: CrimeReportService.cs
    $activeTabRect = [System.Drawing.Rectangle]::new(0, 66, 210, 32)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cMainBg), $activeTabRect)
    $g.DrawLine([System.Drawing.Pen]::new($cGold, [float]2.5), 0, 67, 210, 67)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 210, 66, 210, 98)
    $g.DrawString("CrimeReportService.cs", $fontUIBold, [System.Drawing.SolidBrush]::new($cTextPrimary), 16, 73)
    $g.DrawString("x", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 190, 72)

    # Inactive Tab 2: IBatcaveTelemetry.cs
    $tab2Rect = [System.Drawing.Rectangle]::new(211, 66, 190, 32)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), $tab2Rect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 401, 66, 401, 98)
    $g.DrawString("IBatcaveTelemetry.cs", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 224, 73)

    # Inactive Tab 3: GothamSecurityConfig.json
    $tab3Rect = [System.Drawing.Rectangle]::new(402, 66, 215, 32)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), $tab3Rect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 617, 66, 617, 98)
    $g.DrawString("GothamSecurityConfig.json", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 416, 73)

    # 4. Right Side: Solution Explorer
    $solWidth = 320
    $solLeft = $width - $solWidth
    $solRect = [System.Drawing.Rectangle]::new($solLeft, 66, $solWidth, ($height - 94))
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), $solRect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), $solLeft, 66, $solLeft, ($height - 28))

    # Solution Explorer Header
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), $solLeft, 66, $solWidth, 32)
    $g.DrawString("Solution Explorer", $fontUIBold, [System.Drawing.SolidBrush]::new($cTextPrimary), ($solLeft + 12), 73)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), $solLeft, 98, $width, 98)

    # Solution Explorer Tree Items
    $treeY = 108
    $treeItems = @(
        @{ Text = "Solution 'WayneEnterprises.Core' (3 projects)"; Indent = 12; Bold = $true; Selected = $false },
        @{ Text = "v Gotham.CrimeWatch.API"; Indent = 24; Bold = $true; Selected = $false },
        @{ Text = "  > Dependencies"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "  v Services"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "      CrimeReportService.cs"; Indent = 54; Bold = $true; Selected = $true },
        @{ Text = "      SurveillanceHub.cs"; Indent = 54; Bold = $false; Selected = $false },
        @{ Text = "  > Interfaces"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "  > Telemetry"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "    appsettings.json"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "    Program.cs"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "v Gotham.Batcave.Security"; Indent = 24; Bold = $true; Selected = $false },
        @{ Text = "  > BiometricScanner.cs"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "  > BatmobileLink.cs"; Indent = 38; Bold = $false; Selected = $false },
        @{ Text = "v Gotham.Diagnostics.Telemetry"; Indent = 24; Bold = $true; Selected = $false },
        @{ Text = "    TelemetryAgent.cs"; Indent = 38; Bold = $false; Selected = $false }
    )

    foreach ($item in $treeItems) {
        if ($item.Selected) {
            $g.FillRectangle([System.Drawing.SolidBrush]::new($cSelection), $solLeft, ($treeY - 2), $solWidth, 22)
            $g.DrawLine([System.Drawing.Pen]::new($cGothamBlue, [float]1.5), $solLeft, ($treeY - 2), $solLeft, ($treeY + 20))
        }
        $tb = if ($item.Selected) { [System.Drawing.SolidBrush]::new($cTextPrimary) } elseif ($item.Bold) { [System.Drawing.SolidBrush]::new($cTextPrimary) } else { [System.Drawing.SolidBrush]::new($cTextSecondary) }
        $f = if ($item.Bold) { $fontUIBold } else { $fontUI }
        $g.DrawString($item.Text, $f, $tb, [float]($solLeft + $item.Indent), [float]$treeY)
        $treeY += 24
    }

    # 5. Editor Area
    $editorLeft = 0
    $editorTop = 99
    $editorWidth = $solLeft
    $editorHeight = if ($mode -eq "errors") { 360 } else { 623 }

    $lineH = 22
    $activeLineY = $editorTop + (7 * $lineH)
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cActiveLine), 50, $activeLineY, ($editorWidth - 50), $lineH)
    if ($mode -eq "debug") {
        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#223322")), 50, $activeLineY, ($editorWidth - 50), $lineH)
    }

    # Gutter
    $g.FillRectangle([System.Drawing.SolidBrush]::new($cMainBg), 0, $editorTop, 50, $editorHeight)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 50, $editorTop, 50, ($editorTop + $editorHeight))

    if ($mode -eq "debug") {
        $g.FillEllipse([System.Drawing.SolidBrush]::new($cRed), 10, ($activeLineY + 3), 16, 16)
        $arrowPts = [System.Drawing.Point[]]@(
            [System.Drawing.Point]::new(14, ($activeLineY + 6)),
            [System.Drawing.Point]::new(22, ($activeLineY + 11)),
            [System.Drawing.Point]::new(14, ($activeLineY + 16))
        )
        $g.FillPolygon([System.Drawing.SolidBrush]::new($cGold), $arrowPts)
    }

    $codeLines = @(
        @{ Line = 1; Tokens = @(@{ T = "namespace "; C = $cGothamBlue }, @{ T = "WayneEnterprises.Gotham.Services;"; C = [System.Drawing.ColorTranslator]::FromHtml("#7998B4") }) },
        @{ Line = 2; Tokens = @(@{ T = "/// <summary>Batcave threat triage and dispatch service.</summary>"; C = $cGreenGray }) },
        @{ Line = 3; Tokens = @(@{ T = "public sealed class "; C = $cGothamBlue }, @{ T = "CrimeReportService "; C = $cCyan }, @{ T = ": "; C = $cTextPrimary }, @{ T = "ICrimeReportService"; C = $cMint }) },
        @{ Line = 4; Tokens = @(@{ T = "{"; C = $cTextPrimary }) },
        @{ Line = 5; Tokens = @(@{ T = "    private readonly "; C = $cGothamBlue }, @{ T = "IBatcaveTelemetry "; C = $cMint }, @{ T = "_telemetry;"; C = [System.Drawing.ColorTranslator]::FromHtml("#D1D9E0") }) },
        @{ Line = 6; Tokens = @(@{ T = "    private const int "; C = $cGothamBlue }, @{ T = "MaxThreatCapacity "; C = $cAmber }, @{ T = "= "; C = $cTextPrimary }, @{ T = "1024"; C = $cLavender }, @{ T = ";"; C = $cTextPrimary }) },
        @{ Line = 7; Tokens = @() },
        @{ Line = 8; Tokens = @(@{ T = "    public async "; C = $cGothamBlue }, @{ T = "Task<ThreatAssessment> "; C = $cCyan }, @{ T = "AnalyzeDistressSignalAsync"; C = $cSoftBlue }, @{ T = "("; C = $cTextPrimary }, @{ T = "DistressSignal "; C = $cCyan }, @{ T = "signal"; C = [System.Drawing.ColorTranslator]::FromHtml("#9CDCFE") }, @{ T = ")"; C = $cTextPrimary }) },
        @{ Line = 9; Tokens = @(@{ T = "    {"; C = $cTextPrimary }) },
        @{ Line = 10; Tokens = @(@{ T = "        if "; C = [System.Drawing.ColorTranslator]::FromHtml("#5EA1E6") }, @{ T = "(signal is null) "; C = $cTextPrimary }, @{ T = "throw new "; C = $cGothamBlue }, @{ T = "ArgumentNullException"; C = $cCyan }, @{ T = "('signal');"; C = $cGold }) },
        @{ Line = 11; Tokens = @(@{ T = "        var "; C = $cGothamBlue }, @{ T = "threatLevel "; C = [System.Drawing.ColorTranslator]::FromHtml("#D1D9E0") }, @{ T = "= "; C = $cTextPrimary }, @{ T = "signal.Priority "; C = $cTextPrimary }, @{ T = "* "; C = $cTextPrimary }, @{ T = "1.618"; C = $cLavender }, @{ T = ";"; C = $cTextPrimary }) },
        @{ Line = 12; Tokens = @(@{ T = "        _telemetry."; C = $cTextPrimary }, @{ T = "LogDispatch"; C = $cSoftBlue }, @{ T = "('Sector 7 Alert: High Threat Detected');"; C = $cGold }) },
        @{ Line = 13; Tokens = @(@{ T = "        return new "; C = [System.Drawing.ColorTranslator]::FromHtml("#5EA1E6") }, @{ T = "ThreatAssessment"; C = $cCyan }, @{ T = "(threatLevel, "; C = $cTextPrimary }, @{ T = "Status."; C = $cCyan }, @{ T = "Active"; C = $cAmber }, @{ T = ");"; C = $cTextPrimary }) },
        @{ Line = 14; Tokens = @(@{ T = "    }"; C = $cTextPrimary }) },
        @{ Line = 15; Tokens = @(@{ T = "}"; C = $cTextPrimary }) }
    )

    $codeY = $editorTop + 4
    for ($i = 0; $i -lt $codeLines.Count; $i++) {
        $ln = $codeLines[$i]
        $isCurrent = ($ln.Line -eq 8)
        $lnBrush = if ($isCurrent) { [System.Drawing.SolidBrush]::new($cGold) } else { [System.Drawing.SolidBrush]::new($cLineNum) }
        $g.DrawString($ln.Line.ToString().PadLeft(2), $fontCode, $lnBrush, [float]14, [float]$codeY)

        $codeX = 64
        foreach ($tok in $ln.Tokens) {
            $f = if ($tok.C -eq $cGreenGray) { $fontCodeItalic } else { $fontCode }
            $g.DrawString($tok.T, $f, [System.Drawing.SolidBrush]::new($tok.C), [float]$codeX, [float]$codeY)
            $codeX += ($g.MeasureString($tok.T, $f).Width - 3)
        }
        $codeY += $lineH
    }

    # 6. Mode Overlays
    if ($mode -eq "intellisense") {
        $popX = 280
        $popY = 280
        $popW = 340
        $popH = 170
        $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), $popX, $popY, $popW, $popH)
        $g.DrawRectangle([System.Drawing.Pen]::new($cGothamBlue, [float]1.5), $popX, $popY, $popW, $popH)

        $items = @(
            @{ Text = "LogDispatch(string message)"; Icon = "M"; Sel = $true },
            @{ Text = "LogThreatLevel(double level)"; Icon = "M"; Sel = $false },
            @{ Text = "LogVectorMetrics(Vector3 loc)"; Icon = "M"; Sel = $false },
            @{ Text = "MaxBufferCapacity"; Icon = "P"; Sel = $false },
            @{ Text = "OnAlertBroadcast"; Icon = "E"; Sel = $false }
        )
        $itemY = $popY + 6
        foreach ($it in $items) {
            if ($it.Sel) {
                $g.FillRectangle([System.Drawing.SolidBrush]::new($cSelection), ($popX + 2), ($itemY - 2), ($popW - 4), 24)
            }
            $iconColor = if ($it.Icon -eq "M") { $cSoftBlue } elseif ($it.Icon -eq "P") { $cCyan } else { $cAmber }
            $g.DrawString($it.Icon, $fontUIBold, [System.Drawing.SolidBrush]::new($iconColor), [float]($popX + 10), [float]($itemY + 1))
            $tb = if ($it.Sel) { [System.Drawing.SolidBrush]::new($cTextPrimary) } else { [System.Drawing.SolidBrush]::new($cTextSecondary) }
            $g.DrawString($it.Text, $fontUI, $tb, [float]($popX + 32), [float]($itemY + 1))
            $itemY += 26
        }

        # Parameter Info Tooltip
        $sigX = 280
        $sigY = 460
        $sigW = 440
        $sigH = 52
        $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), $sigX, $sigY, $sigW, $sigH)
        $g.DrawRectangle([System.Drawing.Pen]::new($cBorder, [float]1.5), $sigX, $sigY, $sigW, $sigH)
        $g.DrawString("void IBatcaveTelemetry.LogDispatch(string message)", $fontCode, [System.Drawing.SolidBrush]::new($cTextPrimary), [float]($sigX + 12), [float]($sigY + 8))
        $g.DrawString("Dispatches encrypted telemetry data packet to Batcave mainframe.", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), [float]($sigX + 12), [float]($sigY + 28))
    }
    elseif ($mode -eq "errors") {
        $errTop = 460
        $errH = $height - $errTop - 28
        $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), 0, $errTop, $solLeft, $errH)
        $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, $errTop, $solLeft, $errTop)

        $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), 0, $errTop, $solLeft, 28)
        $g.DrawString("Error List", $fontUIBold, [System.Drawing.SolidBrush]::new($cTextPrimary), 14, ($errTop + 5))
        $g.DrawString("Output", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 100, ($errTop + 5))
        $g.DrawString("Terminal", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 170, ($errTop + 5))

        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#28161A")), 260, ($errTop + 4), 90, 20)
        $g.DrawString("0 Errors", $fontUI, [System.Drawing.SolidBrush]::new($cRed), 274, ($errTop + 5))

        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#302414")), 360, ($errTop + 4), 105, 20)
        $g.DrawString("! 2 Warnings", $fontUI, [System.Drawing.SolidBrush]::new($cAmber), 374, ($errTop + 5))

        $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#162438")), 475, ($errTop + 4), 105, 20)
        $g.DrawString("i 1 Message", $fontUI, [System.Drawing.SolidBrush]::new($cGothamBlue), 488, ($errTop + 5))

        $rowY = $errTop + 36
        $rows = @(
            @{ Code = "CS1998"; Severity = "!"; Col = $cAmber; Msg = "This async method lacks 'await' operators and will run synchronously"; File = "CrimeReportService.cs"; Line = "8" },
            @{ Code = "CA1822"; Severity = "!"; Col = $cAmber; Msg = "Member 'MaxThreatCapacity' does not access instance data and can be marked as static"; File = "CrimeReportService.cs"; Line = "6" },
            @{ Code = "IDE0058"; Severity = "i"; Col = $cGothamBlue; Msg = "Expression value is never used; consider assigning or discarding"; File = "SurveillanceHub.cs"; Line = "42" }
        )
        foreach ($r in $rows) {
            $g.DrawString($r.Severity, $fontUIBold, [System.Drawing.SolidBrush]::new($r.Col), 16, $rowY)
            $g.DrawString($r.Code, $fontCode, [System.Drawing.SolidBrush]::new($cTextSecondary), 36, $rowY)
            $g.DrawString($r.Msg, $fontUI, [System.Drawing.SolidBrush]::new($cTextPrimary), 110, $rowY)
            $g.DrawString($r.File, $fontUI, [System.Drawing.SolidBrush]::new($cGothamBlue), 620, $rowY)
            $g.DrawString($r.Line, $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 780, $rowY)
            $rowY += 26
        }
    }
    elseif ($mode -eq "debug") {
        $dbgTop = 470
        $dbgH = $height - $dbgTop - 28
        $g.FillRectangle([System.Drawing.SolidBrush]::new($cSurface), 0, $dbgTop, $solLeft, $dbgH)
        $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, $dbgTop, $solLeft, $dbgTop)

        $g.FillRectangle([System.Drawing.SolidBrush]::new($cHeader), 0, $dbgTop, $solLeft, 28)
        $g.DrawString("Locals", $fontUIBold, [System.Drawing.SolidBrush]::new($cTextPrimary), 14, ($dbgTop + 5))
        $g.DrawString("Autos", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 76, ($dbgTop + 5))
        $g.DrawString("Watch 1", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 136, ($dbgTop + 5))
        $g.DrawString("Call Stack", $fontUI, [System.Drawing.SolidBrush]::new($cTextSecondary), 206, ($dbgTop + 5))

        $rowY = $dbgTop + 36
        $vars = @(
            @{ Name = "signal"; Value = "{WayneEnterprises.DistressSignal}"; Type = "DistressSignal" },
            @{ Name = "signal.Priority"; Value = "5 (Critical)"; Type = "int" },
            @{ Name = "threatLevel"; Value = "8.09"; Type = "double" },
            @{ Name = "this"; Value = "{WayneEnterprises.CrimeReportService}"; Type = "CrimeReportService" }
        )
        foreach ($v in $vars) {
            $g.DrawString($v.Name, $fontCode, [System.Drawing.SolidBrush]::new($cTextPrimary), 16, $rowY)
            $g.DrawString($v.Value, $fontCode, [System.Drawing.SolidBrush]::new($cGold), 250, $rowY)
            $g.DrawString($v.Type, $fontCode, [System.Drawing.SolidBrush]::new($cCyan), 580, $rowY)
            $rowY += 24
        }
    }

    # 7. Status Bar
    $statusRect = [System.Drawing.Rectangle]::new(0, ($height - 28), $width, 28)
    $statusColor = if ($mode -eq "debug") { $cDebugBar } else { [System.Drawing.ColorTranslator]::FromHtml("#12151B") }
    $g.FillRectangle([System.Drawing.SolidBrush]::new($statusColor), $statusRect)
    $g.DrawLine([System.Drawing.Pen]::new($cBorder, 1), 0, ($height - 28), $width, ($height - 28))

    $statusText = if ($mode -eq "debug") {
        "DEBUGGING - WayneEnterprises.Gotham.API.exe (Process 11404) | Thread [Main] | Ln 8, Col 1 | Ready"
    } else {
        "Ready | Gotham.CrimeWatch.API | master (Git Changes: 1 modified) | Ln 8, Col 1 | UTF-8 | CRLF"
    }
    $statusBrush = if ($mode -eq "debug") { [System.Drawing.SolidBrush]::new($cTextPrimary) } else { [System.Drawing.SolidBrush]::new($cTextSecondary) }
    $g.DrawString($statusText, $fontUI, $statusBrush, 14, ($height - 22))

    $g.Dispose()
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Generated screenshot: $outPath"
}

Write-Host "Rendering preview screenshots..."
Generate-IdePreviewScreenshot "$screenDir\01_editor_csharp.png" "Editor & C# Syntax" "Dark Knight Batcave Highlighting" "editor"
Generate-IdePreviewScreenshot "$screenDir\02_solution_explorer_tool_windows.png" "Solution Explorer & Tool Windows" "Batcave Surface Framing" "editor"
Generate-IdePreviewScreenshot "$screenDir\03_intellisense_signature_help.png" "IntelliSense & Signature Help" "Statement Completion & Quick Info" "intellisense"
Generate-IdePreviewScreenshot "$screenDir\04_debugger_breakpoints.png" "Debugging & Breakpoints" "Execution Highlight & Watch Panel" "debug"
Generate-IdePreviewScreenshot "$screenDir\05_error_list_output.png" "Error List & Diagnostics" "Crisp Contrast & Diagnostic Waves" "errors"

# Hero Marketplace Preview Image
Copy-Item "$screenDir\01_editor_csharp.png" "$resDir\Preview.png" -Force
Copy-Item "$screenDir\01_editor_csharp.png" "$assetsDir\preview_hero.png" -Force
Write-Host "Generated Marketplace Preview: $resDir\Preview.png"
