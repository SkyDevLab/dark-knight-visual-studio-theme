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
    "activityBar.foreground": "#E6EAF0",
    "activityBar.inactiveForeground": "#929BA8",
    "activityBar.activeBorder": "#FFC94A",
    "activityBarBadge.background": "#E8B84A",
    "activityBarBadge.foreground": "#101216",
    "sideBar.background": "#171C25",
    "sideBar.foreground": "#E6EAF0",
    "sideBar.border": "#69552B",
    "sideBarTitle.foreground": "#E6EAF0",
    "sideBarSectionHeader.background": "#1C2330",
    "sideBarSectionHeader.foreground": "#E6EAF0",
    "sideBarSectionHeader.border": "#69552B",
    "editorGroupHeader.tabsBackground": "#171C25",
    "editorGroupHeader.tabsBorder": "#69552B",
    "tab.activeBackground": "#101216",
    "tab.activeForeground": "#E6EAF0",
    "tab.activeBorder": "#FFC94A",
    "tab.activeBorderTop": "#FFC94A",
    "tab.inactiveBackground": "#171C25",
    "tab.inactiveForeground": "#929BA8",
    "tab.border": "#69552B",
    "tab.unfocusedActiveBackground": "#101216",
    "tab.unfocusedActiveForeground": "#C5CBD4",
    "tab.unfocusedActiveBorderTop": "#E8B84A",
    "tab.unfocusedInactiveBackground": "#171C25",
    "tab.unfocusedInactiveForeground": "#707A8A",
    "editor.background": "#101216",
    "editor.foreground": "#E6EAF0",
    "editor.lineHighlightBackground": "#161B23",
    "editor.lineHighlightBorder": "#00000000",
    "editor.selectionBackground": "#1B385C",
    "editor.selectionHighlightBackground": "#264F78",
    "editor.inactiveSelectionBackground": "#162C46",
    "editorCursor.foreground": "#FFC94A",
    "editorLineNumber.foreground": "#4E5766",
    "editorLineNumber.activeForeground": "#E8B84A",
    "editorWhitespace.foreground": "#2A323E",
    "editorIndentGuide.background": "#1C2330",
    "editorIndentGuide.activeBackground": "#69552B",
    "editorRuler.foreground": "#69552B40",
    "editorBracketMatch.background": "#253545",
    "editorBracketMatch.border": "#FFC94A",
    "editorOverviewRuler.border": "#69552B",
    "editorGutter.background": "#101216",
    "editorGutter.modifiedBackground": "#E8B84A",
    "editorGutter.addedBackground": "#55D6A0",
    "editorGutter.deletedBackground": "#FF626B",
    "editorError.foreground": "#FF626B",
    "editorWarning.foreground": "#E8B84A",
    "editorInfo.foreground": "#4D8DCC",
    "statusBar.background": "#12151B",
    "statusBar.foreground": "#929BA8",
    "statusBar.border": "#69552B",
    "statusBar.debuggingBackground": "#1A365D",
    "statusBar.debuggingForeground": "#E6EAF0",
    "statusBar.noFolderBackground": "#101216",
    "statusBarItem.remoteBackground": "#4D8DCC",
    "statusBarItem.remoteForeground": "#101216",
    "statusBarItem.prominentBackground": "#FFC94A",
    "statusBarItem.prominentForeground": "#101216",
    "titleBar.activeBackground": "#171C25",
    "titleBar.activeForeground": "#E6EAF0",
    "titleBar.inactiveBackground": "#101216",
    "titleBar.inactiveForeground": "#929BA8",
    "titleBar.border": "#69552B",
    "menu.background": "#171C25",
    "menu.foreground": "#E6EAF0",
    "menu.selectionBackground": "#1C2330",
    "menu.selectionForeground": "#E6EAF0",
    "menu.selectionBorder": "#E8B84A",
    "menu.separatorBackground": "#69552B",
    "menu.border": "#69552B",
    "menubar.selectionBackground": "#1C2330",
    "menubar.selectionForeground": "#E6EAF0",
    "menubar.selectionBorder": "#E8B84A",
    "list.activeSelectionBackground": "#1B385C",
    "list.activeSelectionForeground": "#E6EAF0",
    "list.inactiveSelectionBackground": "#162C46",
    "list.inactiveSelectionForeground": "#929BA8",
    "list.hoverBackground": "#1C2330",
    "list.hoverForeground": "#E6EAF0",
    "list.dropBackground": "#252B35",
    "list.highlightForeground": "#FFC94A",
    "tree.indentGuidesStroke": "#69552B80",
    "button.background": "#4D8DCC",
    "button.foreground": "#FFFFFF",
    "button.hoverBackground": "#3A6F9E",
    "button.secondaryBackground": "#1C2330",
    "button.secondaryForeground": "#E6EAF0",
    "button.secondaryHoverBackground": "#252E3F",
    "input.background": "#1C2330",
    "input.foreground": "#E6EAF0",
    "input.border": "#69552B",
    "input.placeholderForeground": "#5A6270",
    "inputOption.activeBorder": "#FFC94A",
    "inputOption.activeBackground": "#1B385C",
    "inputOption.activeForeground": "#E6EAF0",
    "inputValidation.errorBackground": "#3B1D22",
    "inputValidation.errorBorder": "#FF626B",
    "inputValidation.errorForeground": "#E6EAF0",
    "inputValidation.warningBackground": "#382F18",
    "inputValidation.warningBorder": "#E8B84A",
    "inputValidation.warningForeground": "#E6EAF0",
    "inputValidation.infoBackground": "#16283D",
    "inputValidation.infoBorder": "#4D8DCC",
    "inputValidation.infoForeground": "#E6EAF0",
    "dropdown.background": "#1C2330",
    "dropdown.foreground": "#E6EAF0",
    "dropdown.border": "#69552B",
    "dropdown.listBackground": "#171C25",
    "scrollbarSlider.background": "#2E374480",
    "scrollbarSlider.hoverBackground": "#3E4A5CB0",
    "scrollbarSlider.activeBackground": "#E8B84ACC",
    "badge.background": "#E8B84A",
    "badge.foreground": "#101216",
    "progressBar.background": "#FFC94A",
    "notificationCenterHeader.background": "#1C2330",
    "notificationCenterHeader.foreground": "#E6EAF0",
    "notifications.background": "#171C25",
    "notifications.foreground": "#E6EAF0",
    "notifications.border": "#69552B",
    "notificationLink.foreground": "#4D8DCC",
    "peekView.border": "#FFC94A",
    "peekViewEditor.background": "#14171E",
    "peekViewEditorGutter.background": "#14171E",
    "peekViewEditor.matchHighlightBackground": "#264F78",
    "peekViewResult.background": "#171C25",
    "peekViewResult.fileForeground": "#E6EAF0",
    "peekViewResult.lineForeground": "#929BA8",
    "peekViewResult.matchHighlightBackground": "#264F78",
    "peekViewResult.selectionBackground": "#1B385C",
    "peekViewResult.selectionForeground": "#E6EAF0",
    "peekViewTitle.background": "#1C2330",
    "peekViewTitleDescription.foreground": "#929BA8",
    "peekViewTitleLabel.foreground": "#E6EAF0",
    "panel.background": "#171C25",
    "panel.border": "#69552B",
    "panelTitle.activeBorder": "#FFC94A",
    "panelTitle.activeForeground": "#E6EAF0",
    "panelTitle.inactiveForeground": "#929BA8",
    "terminal.background": "#101216",
    "terminal.foreground": "#E6EAF0",
    "terminal.ansiBlack": "#101216",
    "terminal.ansiRed": "#FF626B",
    "terminal.ansiGreen": "#55D6A0",
    "terminal.ansiYellow": "#E8B84A",
    "terminal.ansiBlue": "#4D8DCC",
    "terminal.ansiMagenta": "#C678DD",
    "terminal.ansiCyan": "#42D9D0",
    "terminal.ansiWhite": "#E6EAF0",
    "terminal.ansiBrightBlack": "#4E5766",
    "terminal.ansiBrightRed": "#FF757E",
    "terminal.ansiBrightGreen": "#68E4B0",
    "terminal.ansiBrightYellow": "#F5D061",
    "terminal.ansiBrightBlue": "#6DB3F2",
    "terminal.ansiBrightMagenta": "#D48EEC",
    "terminal.ansiBrightCyan": "#61E8DF",
    "terminal.ansiBrightWhite": "#FFFFFF",
    "gitDecoration.modifiedResourceForeground": "#E8B84A",
    "gitDecoration.untrackedResourceForeground": "#55D6A0",
    "gitDecoration.ignoredResourceForeground": "#5A6270",
    "gitDecoration.deletedResourceForeground": "#FF626B",
    "gitDecoration.conflictingResourceForeground": "#E8B84A",
    "gitDecoration.stageModifiedResourceForeground": "#E8B84A",
    "gitDecoration.stageDeletedResourceForeground": "#FF626B",
    "debugToolBar.background": "#171C25",
    "debugToolBar.border": "#69552B",
    "editorWidget.background": "#171C25",
    "editorWidget.foreground": "#E6EAF0",
    "editorWidget.border": "#69552B",
    "editorSuggestWidget.background": "#171C25",
    "editorSuggestWidget.border": "#E8B84A",
    "editorSuggestWidget.foreground": "#E6EAF0",
    "editorSuggestWidget.selectedBackground": "#1B385C",
    "editorSuggestWidget.highlightForeground": "#FFC94A",
    "editorHoverWidget.background": "#171C25",
    "editorHoverWidget.border": "#E8B84A",
    "editorHoverWidget.foreground": "#E6EAF0",
    "focusBorder": "#FFC94A"
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
        "foreground": "#7F9B8A",
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
        "foreground": "#42D9D0"
      }
    },
    {
      "name": "Interfaces",
      "scope": [
        "entity.name.type.interface",
        "entity.name.type.type-parameter"
      ],
      "settings": {
        "foreground": "#52E3DA"
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
        "foreground": "#E7B45A"
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
        "foreground": "#E6EAF0"
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
        "foreground": "#E6EAF0"
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
        "foreground": "#42D9D0"
      }
    },
    {
      "name": "JSON Property Names",
      "scope": [
        "support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#42D9D0"
      }
    },
    {
      "name": "CSS Properties",
      "scope": [
        "support.type.property-name.css"
      ],
      "settings": {
        "foreground": "#42D9D0"
      }
    },
    {
      "name": "CSS Values",
      "scope": [
        "support.constant.property-value.css"
      ],
      "settings": {
        "foreground": "#E7B45A"
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
            $existingFg = $colorNode.SelectSingleNode("Foreground")
            if ($existingFg) {
                $colorNode.InsertBefore($bgNode, $existingFg) | Out-Null
            } else {
                $colorNode.AppendChild($bgNode) | Out-Null
            }
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

# -------------------------------------------------------------
# 1. Environment Category ({624ed9c3-bdfd-41fa-96c3-7c824ea32e3d})
# -------------------------------------------------------------
$envCat = Get-OrCreateCategory $themeElement "Environment" "{624ed9c3-bdfd-41fa-96c3-7c824ea32e3d}"

# Window Chrome & Toolbars
Set-ThemeColor $envCat "MainWindowActive" "FF101216" "FFE6EAF0"
Set-ThemeColor $envCat "MainWindowInactive" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "TitleBarActive" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "TitleBarInactive" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "TitleBarBorder" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarGradientBegin" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "CommandBarGradientEnd" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "CommandBarBorder" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarToolBarBorder" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarToolBarSeparator" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarToolBarSeparatorHighlight" "FFE8B84A" $null
Set-ThemeColor $envCat "CommandBarMenuBackgroundGradientBegin" "FF171C25" $null
Set-ThemeColor $envCat "CommandBarMenuBackgroundGradientEnd" "FF171C25" $null
Set-ThemeColor $envCat "CommandBarMenuBorder" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarMenuSeparator" "FF69552B" $null
Set-ThemeColor $envCat "CommandBarMenuItemMouseOver" "FF1C2330" "FFE6EAF0"
Set-ThemeColor $envCat "CommandBarMenuItemMouseOverBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "CommandBarSelectedBorder" "FFFFC94A" $null
Set-ThemeColor $envCat "CommandBarHoverOverSelectedIconBorder" "FFFFC94A" $null

# Status Bar
Set-ThemeColor $envCat "StatusBarDefault" "FF12151B" "FF929BA8"
Set-ThemeColor $envCat "StatusBarDebugging" "FF1A365D" "FFE6EAF0"
Set-ThemeColor $envCat "StatusBarBuilding" "FF171C25" "FFE8B84A"
Set-ThemeColor $envCat "StatusBarNoSolution" "FF101216" "FF929BA8"
Set-ThemeColor $envCat "StatusBarText" $null "FF929BA8"
Set-ThemeColor $envCat "StatusBarHighlight" "FF1C2330" "FFFFC94A"
Set-ThemeColor $envCat "StatusBarBorder" "FF69552B" $null

# Tool Windows & Golden Panel Borders
Set-ThemeColor $envCat "ToolWindowBackground" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "ToolWindowBorder" "FF69552B" $null
Set-ThemeColor $envCat "ToolWindowText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "WindowText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ControlText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ControlLightText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ControlDarkText" "FF929BA8" "FF929BA8"
Set-ThemeColor $envCat "PanelText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "SideBarText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "CaptionText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "HighlightText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "InfoText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "MenuText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ButtonText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ComboBoxText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ComboBoxItemText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "DropDownText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "PanelTitle" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "PanelTitleActive" "FF1C2330" "FFFFC94A"
Set-ThemeColor $envCat "PanelBorder" "FF69552B" $null
Set-ThemeColor $envCat "PanelSeparator" "FF69552B" $null
Set-ThemeColor $envCat "PanelSubGroupSeparator" "FF69552B" $null
Set-ThemeColor $envCat "ToolWindowTabBorder" "FF69552B" $null
Set-ThemeColor $envCat "ToolWindowTabSeparator" "FF69552B" $null
Set-ThemeColor $envCat "ToolWindowTabSelectedTab" "FF171C25" "FFE6EAF0"
Set-ThemeColor $envCat "ToolWindowTabSelectedActiveText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ToolWindowTabSelectedText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $envCat "ToolWindowTabText" "FF929BA8" "FF929BA8"
Set-ThemeColor $envCat "ToolWindowTabMouseOverText" "FFFFC94A" "FFFFC94A"
Set-ThemeColor $envCat "ToolWindowTabSelectedBorder" "FFFFC94A" $null
Set-ThemeColor $envCat "ToolWindowTabMouseOverBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "ToolWindowFloatingFrame" "FFE8B84A" $null
Set-ThemeColor $envCat "ToolWindowFloatingFrameInactive" "FF69552B" $null
Set-ThemeColor $envCat "ToolWindowButtonHoverActiveBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "ControlOutline" "FF69552B" $null

# Document Tabs & Group Separators
Set-ThemeColor $envCat "FileTabBackground" "FF171C25" "FF929BA8"
Set-ThemeColor $envCat "FileTabBorder" "FF69552B" $null
Set-ThemeColor $envCat "FileTabInactiveBorder" "FF69552B" $null
Set-ThemeColor $envCat "FileTabSelectedBorder" "FFFFC94A" $null
Set-ThemeColor $envCat "FileTabDocumentBorderBackground" "FF69552B" $null
Set-ThemeColor $envCat "FileTabInactiveDocumentBorderEdge" "FF69552B" $null
Set-ThemeColor $envCat "FileTabActiveGroupBackground" "FF101216" $null
Set-ThemeColor $envCat "EditorAdditionalContentBorder" "FF69552B" $null

# Splitters & Resize Grips (Separators between editor and docked panels)
Set-ThemeColor $envCat "HorizontalResizeGrip" "FF69552B" $null
Set-ThemeColor $envCat "VerticalResizeGripBegin" "FF69552B" $null
Set-ThemeColor $envCat "VerticalResizeGripMiddle" "FF69552B" $null
Set-ThemeColor $envCat "VerticalResizeGripEnd" "FF69552B" $null
Set-ThemeColor $envCat "AutoHideResizeGrip" "FF69552B" $null

# Scrollbars
Set-ThemeColor $envCat "ScrollBar" "FF101216" $null
Set-ThemeColor $envCat "ScrollBarArrowBackground" "FF101216" $null
Set-ThemeColor $envCat "ScrollBarThumb" "FF2E3744" $null
Set-ThemeColor $envCat "ScrollBarThumbHover" "FF3E4A5C" $null
Set-ThemeColor $envCat "ScrollBarThumbPressed" "FFE8B84A" $null

# Controls & Focus States
Set-ThemeColor $envCat "SearchBoxBorder" "FF69552B" $null
Set-ThemeColor $envCat "SearchBoxMouseOverBorder" "FFE8B84A" $null
Set-ThemeColor $envCat "SearchBoxPressedBorder" "FFFFC94A" $null
Set-ThemeColor $envCat "ComboBoxBorder" "FF69552B" $null
Set-ThemeColor $envCat "ComboBoxFocusedBorder" "FFFFC94A" $null
Set-ThemeColor $envCat "ComboBoxFocusBox" "FFFFC94A" $null
Set-ThemeColor $envCat "ToolTipBorder" "FFE8B84A" $null

# -------------------------------------------------------------
# 2. Text Editor Category ({a27b4e24-a735-4d1d-b8e7-9716e1e3d8e0})
# -------------------------------------------------------------
$textEditorCat = Get-OrCreateCategory $themeElement "Text Editor" "{a27b4e24-a735-4d1d-b8e7-9716e1e3d8e0}"
Set-ThemeColor $textEditorCat "Plain Text" "FF101216" "FFE6EAF0"
Set-ThemeColor $textEditorCat "Selected Text" "FF1B385C" "FFE6EAF0"
Set-ThemeColor $textEditorCat "Inactive Selected Text" "FF162C46" "FFC5CBD4"
Set-ThemeColor $textEditorCat "Line Number" "FF101216" "FF4E5766"
Set-ThemeColor $textEditorCat "CurrentLineActiveFormat" "FF161B23" $null
Set-ThemeColor $textEditorCat "Visible White Space" $null "FF2A323E"
Set-ThemeColor $textEditorCat "Indicator Margin" "FF101216" $null
Set-ThemeColor $textEditorCat "Collapsible Text" $null "FFE8B84A"
Set-ThemeColor $textEditorCat "Breakpoint (Enabled)" "FF3B1D22" "FFE6EAF0"
Set-ThemeColor $textEditorCat "Current Statement" "FF1E382B" "FFE6EAF0"
Set-ThemeColor $textEditorCat "Syntax Error" $null "FFFF626B"
Set-ThemeColor $textEditorCat "Compiler Error" $null "FFFF626B"
Set-ThemeColor $textEditorCat "Warning" $null "FFE8B84A"

# -------------------------------------------------------------
# 3. Roslyn Text Editor MEF Items Category
# -------------------------------------------------------------
$roslynCat = Get-OrCreateCategory $themeElement "Roslyn Text Editor MEF Items" "{75a05685-00a8-4ded-bae5-e7a50bfa929a}"
Set-ThemeColor $roslynCat "keyword" $null "FF4D8DCC"
Set-ThemeColor $roslynCat "keyword - control" $null "FF5EA1E6"
Set-ThemeColor $roslynCat "class name" $null "FF42D9D0"
Set-ThemeColor $roslynCat "struct name" $null "FF42D9D0"
Set-ThemeColor $roslynCat "interface name" $null "FF52E3DA"
Set-ThemeColor $roslynCat "enum name" $null "FF42D9D0"
Set-ThemeColor $roslynCat "delegate name" $null "FF42D9D0"
Set-ThemeColor $roslynCat "type parameter name" $null "FF80E8DE"
Set-ThemeColor $roslynCat "method name" $null "FF61AFEF"
Set-ThemeColor $roslynCat "extension method name" $null "FF72C0F5"
Set-ThemeColor $roslynCat "string - verbatim" $null "FFE7B45A"
Set-ThemeColor $roslynCat "string - escape character" $null "FFE09F3E"
Set-ThemeColor $roslynCat "number" $null "FFC678DD"
Set-ThemeColor $roslynCat "constant name" $null "FFE09F3E"
Set-ThemeColor $roslynCat "enum member name" $null "FFE09F3E"
Set-ThemeColor $roslynCat "namespace name" $null "FF7998B4"
Set-ThemeColor $roslynCat "property name" $null "FFD1D9E0"
Set-ThemeColor $roslynCat "field name" $null "FFD1D9E0"
Set-ThemeColor $roslynCat "local name" $null "FFE6EAF0"
Set-ThemeColor $roslynCat "parameter name" $null "FF9CDCFE"
Set-ThemeColor $roslynCat "operator" $null "FFE6EAF0"
Set-ThemeColor $roslynCat "punctuation" $null "FFE6EAF0"
Set-ThemeColor $roslynCat "xml doc comment - delimiter" $null "FF7F9B8A"
Set-ThemeColor $roslynCat "xml doc comment - text" $null "FF7F9B8A"
Set-ThemeColor $roslynCat "xml doc comment - name" $null "FF5C82A6"
Set-ThemeColor $roslynCat "xml doc comment - attribute name" $null "FF42D9D0"
Set-ThemeColor $roslynCat "xml doc comment - attribute value" $null "FFE7B45A"

# -------------------------------------------------------------
# 4. CommonControls Category ({c01072a1-a915-4abf-89b7-e2f9e8ec4c7f})
# -------------------------------------------------------------
$commonControlsCat = Get-OrCreateCategory $themeElement "CommonControls" "{c01072a1-a915-4abf-89b7-e2f9e8ec4c7f}"
Set-ThemeColor $commonControlsCat "FocusVisual" "FFFFC94A" $null
Set-ThemeColor $commonControlsCat "ButtonBorderHover" "FFE8B84A" $null
Set-ThemeColor $commonControlsCat "ButtonFocused" "FFFFC94A" $null
Set-ThemeColor $commonControlsCat "TextBoxBorder" "FF69552B" $null
Set-ThemeColor $commonControlsCat "TextBoxBorderFocused" "FFFFC94A" $null
Set-ThemeColor $commonControlsCat "ComboBoxBorder" "FF69552B" $null
Set-ThemeColor $commonControlsCat "ComboBoxBorderFocused" "FFFFC94A" $null
Set-ThemeColor $commonControlsCat "InnerTabActiveIndicator" "FFFFC94A" $null
Set-ThemeColor $commonControlsCat "InnerTabSelectedIndicator" "FFFFC94A" $null

# -------------------------------------------------------------
# 5. CommonDocument Category ({72eb4027-f4ae-4b6c-9cc2-dfd5b49d9415})
# -------------------------------------------------------------
$commonDocCat = Get-OrCreateCategory $themeElement "CommonDocument" "{72eb4027-f4ae-4b6c-9cc2-dfd5b49d9415}"
Set-ThemeColor $commonDocCat "InnerTabActiveIndicator" "FFFFC94A" $null
Set-ThemeColor $commonDocCat "InnerTabSelectedIndicator" "FFFFC94A" $null
Set-ThemeColor $commonDocCat "ListItemBorderFocused" "FFFFC94A" $null
Set-ThemeColor $commonDocCat "ListItemBorderSelected" "FFE8B84A" $null
Set-ThemeColor $commonDocCat "ListItemBorderHover" "FF69552B" $null
Set-ThemeColor $commonDocCat "ListItemText" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $commonDocCat "ListItemTextFocused" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $commonDocCat "ListItemTextSelected" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $commonDocCat "ListItemTextHover" "FFE6EAF0" "FFE6EAF0"
Set-ThemeColor $commonDocCat "ListItemTextUnfocused" "FFE6EAF0" "FFE6EAF0"

# -------------------------------------------------------------
# 6. TreeView Category ({92ecf08e-8b13-4cf4-99e9-ae2692382185})
# -------------------------------------------------------------
$treeViewCat = Get-OrCreateCategory $themeElement "TreeView" "{92ecf08e-8b13-4cf4-99e9-ae2692382185}"
Set-ThemeColor $treeViewCat "Background" "FF171C25" "FFE6EAF0"
Set-ThemeColor $treeViewCat "SelectedItemActive" "FF1B385C" "FFE6EAF0"
Set-ThemeColor $treeViewCat "SelectedItemInactive" "FF162C46" "FFE6EAF0"
Set-ThemeColor $treeViewCat "SelectedItemActiveGlyph" "FFFFC94A" "FFFFC94A"
Set-ThemeColor $treeViewCat "Glyph" "FF929BA8" "FF929BA8"
Set-ThemeColor $treeViewCat "FocusVisualBorder" "FFFFC94A" "FFFFC94A"
Set-ThemeColor $treeViewCat "DragOverItem" "FFE8B84A" "FFE6EAF0"
Set-ThemeColor $treeViewCat "HighlightedSpan" "FF1B385C" "FFFFC94A"

# -------------------------------------------------------------
# 7. Statement Completion Category
# -------------------------------------------------------------
$stmtCompCat = Get-OrCreateCategory $themeElement "Statement Completion" "{C1614BB1-734F-4A31-BD42-5AE6275E16D2}"
Set-ThemeColor $stmtCompCat "Plain Text" "FF171C25" "FFE6EAF0"
Set-ThemeColor $stmtCompCat "Selected Text" "FF1B385C" "FFE6EAF0"

# -------------------------------------------------------------
# 8. ToolTips Category
# -------------------------------------------------------------
$tooltipsCat = Get-OrCreateCategory $themeElement "Editor Tooltip" "{A9A5637F-B2A8-422E-8FB5-DFB4625F0111}"
Set-ThemeColor $tooltipsCat "Plain Text" "FF171C25" "FFE6EAF0"

# -------------------------------------------------------------
# 9. Find Results Category
# -------------------------------------------------------------
$findResCat = Get-OrCreateCategory $themeElement "Find Results" "{5C48B2CB-0366-4FBF-9786-0BB37E945687}"
Set-ThemeColor $findResCat "Plain Text" "FF101216" "FFE6EAF0"
Set-ThemeColor $findResCat "Selected Text" "FF1B385C" "FFE6EAF0"

# -------------------------------------------------------------
# 10. Output Window Category
# -------------------------------------------------------------
$outputCat = Get-OrCreateCategory $themeElement "Output Window" "{9973EFDF-317D-431C-8BC1-5E88CBFD4F7F}"
Set-ThemeColor $outputCat "Plain Text" "FF101216" "FFE6EAF0"
Set-ThemeColor $outputCat "Selected Text" "FF1B385C" "FFE6EAF0"

# -------------------------------------------------------------
# 11. Command Window & Package Manager Console
# -------------------------------------------------------------
$cmdCat = Get-OrCreateCategory $themeElement "Command Window" "{ee1be240-4e81-4beb-8eea-54322b6b1bf5}"
Set-ThemeColor $cmdCat "Plain Text" "FF101216" "FFE6EAF0"
Set-ThemeColor $cmdCat "Selected Text" "FF1B385C" "FFE6EAF0"

$pmcCat = Get-OrCreateCategory $themeElement "Package Manager Console" "{f9d6bce6-c669-41db-8ee7-dd953828685b}"
Set-ThemeColor $pmcCat "Plain Text" "FF101216" "FFE6EAF0"
Set-ThemeColor $pmcCat "Selected Text" "FF1B385C" "FFE6EAF0"

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
