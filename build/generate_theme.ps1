# Build script to generate Dark Knight theme resources for Visual Studio 2022
$ErrorActionPreference = "Stop"

$vsSDKColorCompiler = "C:\Program Files\Microsoft Visual Studio\2022\Community\VSSDK\VisualStudioIntegration\Tools\Bin\VsixColorCompiler.exe"
$themeConverterBin = "$env:TEMP\theme-converter-for-vs\ThemeConverter\ThemeConverter\bin\Debug\net6.0"

if (-not (Test-Path $themeConverterBin)) {
    Write-Host "Building ThemeConverter..."
    & dotnet build "$env:TEMP\theme-converter-for-vs\ThemeConverter\ThemeConverter\ThemeConverter.csproj"
}

$themeGuid = "{c86dec58-e31f-483a-af04-90c711aa3ba5}"
$themeName = "Dark Knight"
$fallbackId = "{1ded0138-47ce-435e-84ef-9ec1f439b749}"

Write-Host "Generating DarkKnight token definition JSON..."
$jsonContent = @'
{
  "$schema": "vscode://schemas/color-theme",
  "name": "Dark Knight",
  "type": "dark",
  "colors": {
    "activityBar.background": "#101216",
    "activityBar.foreground": "#E6E8ED",
    "activityBar.inactiveForeground": "#929BA8",
    "activityBar.activeBorder": "#E8B84A",
    "activityBarBadge.background": "#E8B84A",
    "activityBarBadge.foreground": "#101216",
    "sideBar.background": "#191D24",
    "sideBar.foreground": "#E6E8ED",
    "sideBar.border": "#232833",
    "sideBarTitle.foreground": "#E6E8ED",
    "sideBarSectionHeader.background": "#14171E",
    "sideBarSectionHeader.foreground": "#E6E8ED",
    "sideBarSectionHeader.border": "#232833",
    "editorGroupHeader.tabsBackground": "#14171E",
    "editorGroupHeader.tabsBorder": "#232833",
    "tab.activeBackground": "#101216",
    "tab.activeForeground": "#E6E8ED",
    "tab.activeBorder": "#E8B84A",
    "tab.activeBorderTop": "#E8B84A",
    "tab.inactiveBackground": "#191D24",
    "tab.inactiveForeground": "#929BA8",
    "tab.border": "#232833",
    "tab.unfocusedActiveBackground": "#101216",
    "tab.unfocusedActiveForeground": "#C5CBD4",
    "tab.unfocusedActiveBorderTop": "#C69B37",
    "tab.unfocusedInactiveBackground": "#161920",
    "tab.unfocusedInactiveForeground": "#707A8A",
    "editor.background": "#101216",
    "editor.foreground": "#E6E8ED",
    "editor.lineHighlightBackground": "#161A22",
    "editor.lineHighlightBorder": "#00000000",
    "editor.selectionBackground": "#1B385C",
    "editor.selectionHighlightBackground": "#264F78",
    "editor.inactiveSelectionBackground": "#162C46",
    "editorCursor.foreground": "#E8B84A",
    "editorLineNumber.foreground": "#4E5766",
    "editorLineNumber.activeForeground": "#E8B84A",
    "editorWhitespace.foreground": "#2A323E",
    "editorIndentGuide.background": "#232833",
    "editorIndentGuide.activeBackground": "#4D8DCC",
    "editorRuler.foreground": "#232833",
    "editorBracketMatch.background": "#253545",
    "editorBracketMatch.border": "#4D8DCC",
    "editorOverviewRuler.border": "#232833",
    "editorGutter.background": "#101216",
    "editorGutter.modifiedBackground": "#E8B84A",
    "editorGutter.addedBackground": "#38A169",
    "editorGutter.deletedBackground": "#E5484D",
    "editorError.foreground": "#E5484D",
    "editorWarning.foreground": "#E09F3E",
    "editorInfo.foreground": "#4D8DCC",
    "statusBar.background": "#12151B",
    "statusBar.foreground": "#929BA8",
    "statusBar.border": "#232833",
    "statusBar.debuggingBackground": "#1A365D",
    "statusBar.debuggingForeground": "#E6E8ED",
    "statusBar.noFolderBackground": "#101216",
    "statusBarItem.remoteBackground": "#4D8DCC",
    "statusBarItem.remoteForeground": "#101216",
    "statusBarItem.prominentBackground": "#E8B84A",
    "statusBarItem.prominentForeground": "#101216",
    "titleBar.activeBackground": "#12151C",
    "titleBar.activeForeground": "#E6E8ED",
    "titleBar.inactiveBackground": "#101216",
    "titleBar.inactiveForeground": "#929BA8",
    "titleBar.border": "#232833",
    "menu.background": "#191D24",
    "menu.foreground": "#E6E8ED",
    "menu.selectionBackground": "#252B35",
    "menu.selectionForeground": "#E6E8ED",
    "menu.selectionBorder": "#4D8DCC",
    "menu.separatorBackground": "#232833",
    "menu.border": "#232833",
    "menubar.selectionBackground": "#252B35",
    "menubar.selectionForeground": "#E6E8ED",
    "menubar.selectionBorder": "#4D8DCC",
    "list.activeSelectionBackground": "#1B385C",
    "list.activeSelectionForeground": "#E6E8ED",
    "list.inactiveSelectionBackground": "#162C46",
    "list.inactiveSelectionForeground": "#929BA8",
    "list.hoverBackground": "#202530",
    "list.hoverForeground": "#E6E8ED",
    "list.dropBackground": "#252B35",
    "list.highlightForeground": "#E8B84A",
    "tree.indentGuidesStroke": "#232833",
    "button.background": "#4D8DCC",
    "button.foreground": "#FFFFFF",
    "button.hoverBackground": "#3A6F9E",
    "button.secondaryBackground": "#252B35",
    "button.secondaryForeground": "#E6E8ED",
    "button.secondaryHoverBackground": "#2F3642",
    "input.background": "#14171E",
    "input.foreground": "#E6E8ED",
    "input.border": "#2A313D",
    "input.placeholderForeground": "#5A6270",
    "inputOption.activeBorder": "#4D8DCC",
    "inputOption.activeBackground": "#1B385C",
    "inputOption.activeForeground": "#E6E8ED",
    "inputValidation.errorBackground": "#3B1D22",
    "inputValidation.errorBorder": "#E5484D",
    "inputValidation.errorForeground": "#E6E8ED",
    "inputValidation.warningBackground": "#382F18",
    "inputValidation.warningBorder": "#E09F3E",
    "inputValidation.warningForeground": "#E6E8ED",
    "inputValidation.infoBackground": "#16283D",
    "inputValidation.infoBorder": "#4D8DCC",
    "inputValidation.infoForeground": "#E6E8ED",
    "dropdown.background": "#14171E",
    "dropdown.foreground": "#E6E8ED",
    "dropdown.border": "#2A313D",
    "dropdown.listBackground": "#191D24",
    "scrollbarSlider.background": "#2E374480",
    "scrollbarSlider.hoverBackground": "#3E4A5CB0",
    "scrollbarSlider.activeBackground": "#E8B84ACC",
    "badge.background": "#E8B84A",
    "badge.foreground": "#101216",
    "progressBar.background": "#E8B84A",
    "notificationCenterHeader.background": "#14171E",
    "notificationCenterHeader.foreground": "#E6E8ED",
    "notifications.background": "#191D24",
    "notifications.foreground": "#E6E8ED",
    "notifications.border": "#232833",
    "notificationLink.foreground": "#4D8DCC",
    "peekView.border": "#4D8DCC",
    "peekViewEditor.background": "#151820",
    "peekViewEditorGutter.background": "#151820",
    "peekViewEditor.matchHighlightBackground": "#264F78",
    "peekViewResult.background": "#191D24",
    "peekViewResult.fileForeground": "#E6E8ED",
    "peekViewResult.lineForeground": "#929BA8",
    "peekViewResult.matchHighlightBackground": "#264F78",
    "peekViewResult.selectionBackground": "#1B385C",
    "peekViewResult.selectionForeground": "#E6E8ED",
    "peekViewTitle.background": "#14171E",
    "peekViewTitleDescription.foreground": "#929BA8",
    "peekViewTitleLabel.foreground": "#E6E8ED",
    "panel.background": "#191D24",
    "panel.border": "#232833",
    "panelTitle.activeBorder": "#E8B84A",
    "panelTitle.activeForeground": "#E6E8ED",
    "panelTitle.inactiveForeground": "#929BA8",
    "terminal.background": "#101216",
    "terminal.foreground": "#E6E8ED",
    "terminal.ansiBlack": "#101216",
    "terminal.ansiRed": "#E5484D",
    "terminal.ansiGreen": "#38A169",
    "terminal.ansiYellow": "#E8B84A",
    "terminal.ansiBlue": "#4D8DCC",
    "terminal.ansiMagenta": "#C678DD",
    "terminal.ansiCyan": "#56B6C2",
    "terminal.ansiWhite": "#E6E8ED",
    "terminal.ansiBrightBlack": "#4E5766",
    "terminal.ansiBrightRed": "#F85149",
    "terminal.ansiBrightGreen": "#48BB78",
    "terminal.ansiBrightYellow": "#F5D061",
    "terminal.ansiBrightBlue": "#6DB3F2",
    "terminal.ansiBrightMagenta": "#D48EEC",
    "terminal.ansiBrightCyan": "#70C9D4",
    "terminal.ansiBrightWhite": "#FFFFFF",
    "gitDecoration.modifiedResourceForeground": "#E8B84A",
    "gitDecoration.untrackedResourceForeground": "#38A169",
    "gitDecoration.ignoredResourceForeground": "#5A6270",
    "gitDecoration.deletedResourceForeground": "#E5484D",
    "gitDecoration.conflictingResourceForeground": "#E09F3E",
    "gitDecoration.stageModifiedResourceForeground": "#E8B84A",
    "gitDecoration.stageDeletedResourceForeground": "#E5484D",
    "debugToolBar.background": "#191D24",
    "debugToolBar.border": "#232833",
    "editorWidget.background": "#191D24",
    "editorWidget.foreground": "#E6E8ED",
    "editorWidget.border": "#232833",
    "editorSuggestWidget.background": "#191D24",
    "editorSuggestWidget.border": "#4D8DCC",
    "editorSuggestWidget.foreground": "#E6E8ED",
    "editorSuggestWidget.selectedBackground": "#1B385C",
    "editorSuggestWidget.highlightForeground": "#E8B84A",
    "editorHoverWidget.background": "#191D24",
    "editorHoverWidget.border": "#4D8DCC",
    "editorHoverWidget.foreground": "#E6E8ED"
  },
  "tokenColors": [
    {
      "name": "Comments",
      "scope": [
        "comment",
        "comment.line",
        "comment.block",
        "comment.block.documentation",
        "punctuation.definition.comment"
      ],
      "settings": {
        "foreground": "#62727B",
        "fontStyle": "italic"
      }
    },
    {
      "name": "Keywords",
      "scope": [
        "keyword",
        "keyword.control",
        "keyword.operator.new",
        "keyword.operator.expression",
        "keyword.operator.logical",
        "keyword.operator.delete",
        "keyword.type"
      ],
      "settings": {
        "foreground": "#4D8DCC"
      }
    },
    {
      "name": "Control Keywords",
      "scope": [
        "keyword.control",
        "keyword.control.conditional",
        "keyword.control.loop",
        "keyword.control.flow",
        "keyword.control.trycatch",
        "keyword.control.async",
        "keyword.control.await"
      ],
      "settings": {
        "foreground": "#5EA1E6"
      }
    },
    {
      "name": "Types and Classes",
      "scope": [
        "entity.name.type",
        "entity.name.type.class",
        "entity.name.type.struct",
        "entity.name.type.enum",
        "entity.name.class",
        "support.class",
        "support.type"
      ],
      "settings": {
        "foreground": "#4EC9B0"
      }
    },
    {
      "name": "Interfaces",
      "scope": [
        "entity.name.type.interface",
        "entity.name.type.type-parameter"
      ],
      "settings": {
        "foreground": "#52BAA7"
      }
    },
    {
      "name": "Methods and Functions",
      "scope": [
        "entity.name.function",
        "entity.name.function.member",
        "support.function",
        "support.function.member",
        "meta.function-call"
      ],
      "settings": {
        "foreground": "#61AFEF"
      }
    },
    {
      "name": "Strings",
      "scope": [
        "string",
        "string.quoted",
        "string.quoted.single",
        "string.quoted.double",
        "string.quoted.triple",
        "string.template",
        "string.interpolated"
      ],
      "settings": {
        "foreground": "#E8B84A"
      }
    },
    {
      "name": "String Escape Sequences",
      "scope": [
        "constant.character.escape",
        "string.regexp"
      ],
      "settings": {
        "foreground": "#E09F3E"
      }
    },
    {
      "name": "Numeric and Boolean Literals",
      "scope": [
        "constant.numeric",
        "constant.language.boolean",
        "constant.language.null"
      ],
      "settings": {
        "foreground": "#C678DD"
      }
    },
    {
      "name": "Constants and Enum Members",
      "scope": [
        "variable.other.constant",
        "variable.other.enummember",
        "constant.other"
      ],
      "settings": {
        "foreground": "#E09F3E"
      }
    },
    {
      "name": "Variables and Fields",
      "scope": [
        "variable",
        "variable.other",
        "variable.other.readwrite",
        "variable.other.member",
        "variable.other.property",
        "meta.definition.variable"
      ],
      "settings": {
        "foreground": "#E6E8ED"
      }
    },
    {
      "name": "Parameters",
      "scope": [
        "variable.parameter"
      ],
      "settings": {
        "foreground": "#9CDCFE"
      }
    },
    {
      "name": "Namespaces",
      "scope": [
        "entity.name.namespace",
        "entity.name.module",
        "support.module"
      ],
      "settings": {
        "foreground": "#7998B4"
      }
    },
    {
      "name": "Operators and Punctuation",
      "scope": [
        "keyword.operator",
        "punctuation",
        "punctuation.separator",
        "punctuation.terminator",
        "punctuation.accessor",
        "punctuation.definition.parameters"
      ],
      "settings": {
        "foreground": "#E6E8ED"
      }
    },
    {
      "name": "HTML & XML Elements and Tags",
      "scope": [
        "entity.name.tag",
        "punctuation.definition.tag"
      ],
      "settings": {
        "foreground": "#4D8DCC"
      }
    },
    {
      "name": "HTML & XML Attributes",
      "scope": [
        "entity.other.attribute-name"
      ],
      "settings": {
        "foreground": "#56B6C2"
      }
    },
    {
      "name": "JSON Property Names",
      "scope": [
        "support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#56B6C2"
      }
    },
    {
      "name": "CSS Properties",
      "scope": [
        "support.type.property-name.css"
      ],
      "settings": {
        "foreground": "#56B6C2"
      }
    },
    {
      "name": "CSS Values",
      "scope": [
        "support.constant.property-value.css"
      ],
      "settings": {
        "foreground": "#E8B84A"
      }
    },
    {
      "name": "Preprocessor Directives",
      "scope": [
        "meta.preprocessor",
        "keyword.preprocessor"
      ],
      "settings": {
        "foreground": "#6E8299"
      }
    }
  ]
}
'@

$tempJsonPath = "$env:TEMP\DarkKnight_Base.json"
Set-Content -Path $tempJsonPath -Value $jsonContent -Encoding UTF8

$tempOutDir = "$env:TEMP\tc_build_out"
New-Item -ItemType Directory -Force -Path $tempOutDir | Out-Null

Write-Host "Running ThemeConverter..."
Push-Location $themeConverterBin
.\ThemeConverter.exe -i $tempJsonPath -o $tempOutDir
Pop-Location

$rawPkgdef = "$tempOutDir\DarkKnight_Base.pkgdef"
Write-Host "Raw pkgdef generated at: $rawPkgdef"

Write-Host "Decompiling pkgdef to vstheme XML..."
$asm = [System.Reflection.Assembly]::LoadFrom($vsSDKColorCompiler)
$readerType = $asm.GetType("Microsoft.VisualStudio.Shared.ColorCompiler.IO.FileInput.PkgDef.PkgDefReader")
$writerType = $asm.GetType("Microsoft.VisualStudio.Shared.ColorCompiler.IO.FileOutput.Xml.XmlFileWriter")

$reader = [Activator]::CreateInstance($readerType, $rawPkgdef)
$writer = [Activator]::CreateInstance($writerType, $reader.ColorManager)

$tempXml = "$tempOutDir\DarkKnight.vstheme"
$writer.SaveToFile($tempXml)

Write-Host "Reading vstheme XML and applying Dark Knight metadata and customizations..."
[xml]$vsthemeXml = Get-Content $tempXml

# Set theme metadata
$themeElement = $vsthemeXml.Themes.Theme
$themeElement.SetAttribute("Name", $themeName)
$themeElement.SetAttribute("GUID", $themeGuid)
$themeElement.SetAttribute("FallbackId", $fallbackId)

# Helper function to set or add color in category
function Set-ThemeColor {
    param(
        [System.Xml.XmlElement]$category,
        [string]$colorName,
        [string]$bgHex,
        [string]$fgHex
    )
    $colorNode = $category.SelectSingleNode("Color[@Name='$colorName']")
    if (-not $colorNode) {
        $colorNode = $category.OwnerDocument.CreateElement("Color")
        $colorNode.SetAttribute("Name", $colorName)
        $category.AppendChild($colorNode) | Out-Null
    }

    if ($bgHex) {
        $bgNode = $colorNode.SelectSingleNode("Background")
        if (-not $bgNode) {
            $bgNode = $category.OwnerDocument.CreateElement("Background")
            $colorNode.AppendChild($bgNode) | Out-Null
        }
        $bgNode.SetAttribute("Type", "CT_RAW")
        $bgNode.SetAttribute("Source", $bgHex.TrimStart('#').ToUpper())
    }

    if ($fgHex) {
        $fgNode = $colorNode.SelectSingleNode("Foreground")
        if (-not $fgNode) {
            $fgNode = $category.OwnerDocument.CreateElement("Foreground")
            $colorNode.AppendChild($fgNode) | Out-Null
        }
        $fgNode.SetAttribute("Type", "CT_RAW")
        $fgNode.SetAttribute("Source", $fgHex.TrimStart('#').ToUpper())
    }
}

function Get-OrCreateCategory {
    param(
        [System.Xml.XmlElement]$themeElem,
        [string]$catName,
        [string]$catGuid
    )
    $cat = $themeElem.SelectSingleNode("Category[@Name='$catName']")
    if (-not $cat) {
        $cat = $themeElem.OwnerDocument.CreateElement("Category")
        $cat.SetAttribute("Name", $catName)
        $cat.SetAttribute("GUID", $catGuid)
        $themeElem.AppendChild($cat) | Out-Null
    }
    return $cat
}

# 1. Enhance Environment Category
$envCat = Get-OrCreateCategory $themeElement "Environment" "{624ed9c3-bdfd-41fa-96c3-7c824ea32e3d}"
Set-ThemeColor $envCat "MainWindowActive" "FF101216" "FFE6E8ED"
Set-ThemeColor $envCat "MainWindowInactive" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "TitleBarActive" "FF12151C" "FFE6E8ED"
Set-ThemeColor $envCat "TitleBarInactive" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "CommandBarGradientBegin" "FF191D24" "FFE6E8ED"
Set-ThemeColor $envCat "CommandBarGradientEnd" "FF191D24" "FFE6E8ED"
Set-ThemeColor $envCat "CommandBarBorder" "FF232833" $null
Set-ThemeColor $envCat "CommandBarMenuBackgroundGradientBegin" "FF191D24" $null
Set-ThemeColor $envCat "CommandBarMenuBackgroundGradientEnd" "FF191D24" $null
Set-ThemeColor $envCat "CommandBarMenuBorder" "FF232833" $null
Set-ThemeColor $envCat "CommandBarMenuItemMouseOver" "FF252B35" "FFE6E8ED"
Set-ThemeColor $envCat "CommandBarMenuItemMouseOverBorder" "FF4D8DCC" $null
Set-ThemeColor $envCat "StatusBarDefault" "FF12151B" "FF929BA8"
Set-ThemeColor $envCat "StatusBarDebugging" "FF1A365D" "FFE6E8ED"
Set-ThemeColor $envCat "StatusBarBuilding" "FF191D24" "FFE8B84A"
Set-ThemeColor $envCat "StatusBarNoSolution" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "StatusBarText" $null "FF929BA8"
Set-ThemeColor $envCat "StatusBarHighlight" "FF252B35" "FFE8B84A"
Set-ThemeColor $envCat "ToolWindowBackground" "FF191D24" "FFE6E8ED"
Set-ThemeColor $envCat "ToolWindowBorder" "FF232833" $null
Set-ThemeColor $envCat "ToolWindowTabSelectedTab" "FF191D24" "FFE6E8ED"
Set-ThemeColor $envCat "ToolWindowTabSelectedBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "FileTabBackground" "FF191D24" "FF929BA8"
Set-ThemeColor $envCat "FileTabBorder" "FF232833" $null
Set-ThemeColor $envCat "FileTabSelectedBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "ScrollBar" "FF101216" $null
Set-ThemeColor $envCat "ScrollBarArrowBackground" "FF101216" $null
Set-ThemeColor $envCat "ScrollBarThumb" "FF2E3744" $null
Set-ThemeColor $envCat "ScrollBarThumbHover" "FF3E4A5C" $null
Set-ThemeColor $envCat "ScrollBarThumbPressed" "FFE8B84A" $null

# 2. Text Editor Category (Fonts & Colors Text Editor Category: {a27b4e24-a735-4d1d-b8e7-9716e1e3d8e0})
$textEditorCat = Get-OrCreateCategory $themeElement "Text Editor" "{a27b4e24-a735-4d1d-b8e7-9716e1e3d8e0}"
Set-ThemeColor $textEditorCat "Plain Text" "FF101216" "FFE6E8ED"
Set-ThemeColor $textEditorCat "Selected Text" "FF1B385C" "FFE6E8ED"
Set-ThemeColor $textEditorCat "Inactive Selected Text" "FF162C46" "FFC5CBD4"
Set-ThemeColor $textEditorCat "Line Number" "FF101216" "FF4E5766"
Set-ThemeColor $textEditorCat "CurrentLineActiveFormat" "FF161A22" $null
Set-ThemeColor $textEditorCat "Visible White Space" $null "FF2A323E"
Set-ThemeColor $textEditorCat "Indicator Margin" "FF101216" $null
Set-ThemeColor $textEditorCat "Collapsible Text" $null "FFE8B84A"
Set-ThemeColor $textEditorCat "Breakpoint (Enabled)" "FF3B1D22" "FFE6E8ED"
Set-ThemeColor $textEditorCat "Current Statement" "FF2E3A1F" "FFE6E8ED"
Set-ThemeColor $textEditorCat "Syntax Error" $null "FFE5484D"
Set-ThemeColor $textEditorCat "Compiler Error" $null "FFE5484D"
Set-ThemeColor $textEditorCat "Warning" $null "FFE09F3E"

# 3. Roslyn Text Editor MEF Items Category
$roslynCat = Get-OrCreateCategory $themeElement "Roslyn Text Editor MEF Items" "{75a05685-00a8-4ded-bae5-e7a50bfa929a}"
Set-ThemeColor $roslynCat "keyword" $null "FF4D8DCC"
Set-ThemeColor $roslynCat "keyword - control" $null "FF5EA1E6"
Set-ThemeColor $roslynCat "class name" $null "FF4EC9B0"
Set-ThemeColor $roslynCat "struct name" $null "FF4EC9B0"
Set-ThemeColor $roslynCat "interface name" $null "FF52BAA7"
Set-ThemeColor $roslynCat "enum name" $null "FF4EC9B0"
Set-ThemeColor $roslynCat "delegate name" $null "FF4EC9B0"
Set-ThemeColor $roslynCat "type parameter name" $null "FF80D4C5"
Set-ThemeColor $roslynCat "method name" $null "FF61AFEF"
Set-ThemeColor $roslynCat "extension method name" $null "FF72C0F5"
Set-ThemeColor $roslynCat "string - verbatim" $null "FFE8B84A"
Set-ThemeColor $roslynCat "string - escape character" $null "FFE09F3E"
Set-ThemeColor $roslynCat "number" $null "FFC678DD"
Set-ThemeColor $roslynCat "constant name" $null "FFE09F3E"
Set-ThemeColor $roslynCat "enum member name" $null "FFE09F3E"
Set-ThemeColor $roslynCat "namespace name" $null "FF7998B4"
Set-ThemeColor $roslynCat "property name" $null "FFD1D9E0"
Set-ThemeColor $roslynCat "field name" $null "FFD1D9E0"
Set-ThemeColor $roslynCat "local name" $null "FFE6E8ED"
Set-ThemeColor $roslynCat "parameter name" $null "FF9CDCFE"
Set-ThemeColor $roslynCat "operator" $null "FFE6E8ED"
Set-ThemeColor $roslynCat "punctuation" $null "FFE6E8ED"
Set-ThemeColor $roslynCat "xml doc comment - delimiter" $null "FF62727B"
Set-ThemeColor $roslynCat "xml doc comment - text" $null "FF62727B"
Set-ThemeColor $roslynCat "xml doc comment - name" $null "FF5C82A6"
Set-ThemeColor $roslynCat "xml doc comment - attribute name" $null "FF56B6C2"
Set-ThemeColor $roslynCat "xml doc comment - attribute value" $null "FFE8B84A"

# 4. Statement Completion Category
$stmtCompCat = Get-OrCreateCategory $themeElement "Statement Completion" "{C1614BB1-734F-4A31-BD42-5AE6275E16D2}"
Set-ThemeColor $stmtCompCat "Plain Text" "FF191D24" "FFE6E8ED"
Set-ThemeColor $stmtCompCat "Selected Text" "FF1B385C" "FFE6E8ED"

# 5. ToolTips Category
$tooltipsCat = Get-OrCreateCategory $themeElement "Editor Tooltip" "{A9A5637F-B2A8-422E-8FB5-DFB4625F0111}"
Set-ThemeColor $tooltipsCat "Plain Text" "FF191D24" "FFE6E8ED"

# 6. Find Results Category
$findResCat = Get-OrCreateCategory $themeElement "Find Results" "{5C48B2CB-0366-4FBF-9786-0BB37E945687}"
Set-ThemeColor $findResCat "Plain Text" "FF101216" "FFE6E8ED"
Set-ThemeColor $findResCat "Selected Text" "FF1B385C" "FFE6E8ED"

# 7. Output Window Category
$outputCat = Get-OrCreateCategory $themeElement "Output Window" "{9973EFDF-317D-431C-8BC1-5E88CBFD4F7F}"
Set-ThemeColor $outputCat "Plain Text" "FF101216" "FFE6E8ED"
Set-ThemeColor $outputCat "Selected Text" "FF1B385C" "FFE6E8ED"

# Save customized vstheme XML
$finalVsthemePath = "src\DarkKnightTheme\DarkKnight.vstheme"
$vsthemeXml.Save((Resolve-Path -Path "src\DarkKnightTheme").Path + "\DarkKnight.vstheme")
Write-Host "Saved final vstheme to: $finalVsthemePath"

# Compile final pkgdef with VsixColorCompiler
$finalPkgdefPath = "src\DarkKnightTheme\DarkKnight.pkgdef"
Write-Host "Compiling final pkgdef using VsixColorCompiler..."
& $vsSDKColorCompiler $finalVsthemePath $finalPkgdefPath /registerTheme

if (Test-Path $finalPkgdefPath) {
    Write-Host "Final pkgdef compiled successfully: $((Get-Item $finalPkgdefPath).Length) bytes"
} else {
    throw "Failed to compile pkgdef"
}
