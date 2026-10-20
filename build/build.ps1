[CmdletBinding()]
param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    [switch]$SkipGraphics
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Dark Knight - Gotham Dark Theme for Visual Studio (Build) " -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Locate MSBuild
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) {
    throw "vswhere.exe not found at $vswhere. Please ensure Visual Studio 2022 is installed."
}

$vsPath = & $vswhere -latest -requires Microsoft.Component.MSBuild -property installationPath
if (-not $vsPath) {
    throw "Visual Studio 2022 installation with MSBuild not detected."
}
Write-Host "Found Visual Studio at: $vsPath" -ForegroundColor Green

$msBuildPath = Join-Path $vsPath "MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msBuildPath)) {
    throw "MSBuild.exe not found at $msBuildPath."
}
Write-Host "Found MSBuild: $msBuildPath" -ForegroundColor Green

$colorCompiler = Join-Path $vsPath "VSSDK\VisualStudioIntegration\Tools\Bin\VsixColorCompiler.exe"
if (-not (Test-Path $colorCompiler)) {
    throw "VsixColorCompiler.exe not found at $colorCompiler. Ensure the Visual Studio Extension Development workload is installed."
}
Write-Host "Found VSSDK Color Compiler: $colorCompiler" -ForegroundColor Green

# 2. Build Graphics
if (-not $SkipGraphics) {
    Write-Host ""
    Write-Host "--- Step 1: Generating Branding Graphics and Previews ---" -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "generate_graphics.ps1")
}

# 3. Generate Theme Resources
Write-Host ""
Write-Host "--- Step 2: Generating and Compiling Theme Resources ---" -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "generate_theme.ps1")

# 4. Build VSIX with MSBuild
Write-Host ""
Write-Host "--- Step 3: Compiling Extension Project ($Configuration) ---" -ForegroundColor Cyan
$slnPath = Join-Path $rootDir "DarkKnightTheme.sln"
& $msBuildPath $slnPath "/p:Configuration=$Configuration" "/v:m"

if ($LASTEXITCODE -ne 0) {
    throw "MSBuild failed with exit code $LASTEXITCODE"
}

# 5. Copy distributable VSIX to dist/
$distDir = Join-Path $rootDir "dist"
if (-not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null
}

$vsixSource = Join-Path $rootDir "src\DarkKnightTheme\bin\$Configuration\DarkKnightTheme.vsix"
$vsixDest = Join-Path $distDir "DarkKnightTheme.vsix"

Copy-Item $vsixSource $vsixDest -Force

$vsixSize = (Get-Item $vsixDest).Length
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  BUILD SUCCEEDED!" -ForegroundColor Green
Write-Host "  Distributable VSIX: $vsixDest" -ForegroundColor Yellow
Write-Host "  Package Size: $([math]::Round($vsixSize / 1KB, 2)) KB" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Green
