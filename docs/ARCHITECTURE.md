# Dark Knight Theme — Architecture & Technical Implementation

This document details the internal architecture, Microsoft Visual Studio Extensibility SDK integration, and package definition mechanics used to build **Dark Knight — Gotham Dark Theme for Visual Studio** (v1.1.0).

---

## 1. Technical Investigation: Visual Studio Border & Separator Customization

### 1.1 Native VS Shell Theme Resource Mapping
Visual Studio 2022's WPF shell renders borders and separators around docked tool windows, document tab wells, and editor splitters through centralized color tokens in the **Environment Category** (`{624ed9c3-bdfd-41fa-96c3-7c824ea32e3d}`), **CommonControls** (`{c01072a1-a915-4abf-89b7-e2f9e8ec4c7f}`), and **CommonDocument** (`{72eb4027-f4ae-4b6c-9cc2-dfd5b49d9415}`):

| Visual Element | Theme Token Name | Category GUID | Applied Color | Visual Role |
| :--- | :--- | :--- | :--- | :--- |
| **Docked Tool Windows** | `ToolWindowBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px perimeter around Solution Explorer, Properties, Git Changes, etc. |
| **Docked Panel Container** | `PanelBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | Outer boundary of docked tool window groups |
| **Panel Separator Lines** | `PanelSeparator` | Environment (`{624ed9c3-...}`) | `#69552B` | Dividers between stacked/adjacent docked tool windows |
| **Subgroup Separators** | `PanelSubGroupSeparator` | Environment (`{624ed9c3-...}`) | `#69552B` | Secondary panel subgroup dividers |
| **Tool Window Tab Border** | `ToolWindowTabBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | Inactive tool window tab perimeter |
| **Tool Window Tab Divider**| `ToolWindowTabSeparator` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px vertical tick between tool window tabs |
| **Active Tool Window Tab** | `ToolWindowTabSelectedBorder`| Environment (`{624ed9c3-...}`) | `#FFC94A` | Bright gold border for the active tool window tab |
| **Tool Window Tab Hover** | `ToolWindowTabMouseOverBorder`| Environment (`{624ed9c3-...}`) | `#E8B84A` | Primary gold border when hovering tool window tabs |
| **Active Floating Frame** | `ToolWindowFloatingFrame` | Environment (`{624ed9c3-...}`) | `#E8B84A` | Primary gold border for un-docked/floating tool windows |
| **Inactive Floating Frame**| `ToolWindowFloatingFrameInactive`| Environment (`{624ed9c3-...}`) | `#69552B` | Antique gold border for inactive floating windows |
| **Document Tab Border** | `FileTabBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | Perimeter border around document tabs |
| **Inactive Document Tab** | `FileTabInactiveBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | Border around inactive document tabs |
| **Active Document Tab** | `FileTabSelectedBorder` | Environment (`{624ed9c3-...}`) | `#FFC94A` | Bright gold accent line on active code tab |
| **Editor/Tab Separator** | `FileTabDocumentBorderBackground` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px border separating document tabs from editor canvas |
| **Editor Splitter (Horiz)**| `HorizontalResizeGrip` | Environment (`{624ed9c3-...}`) | `#69552B` | Splitter bar between editor and bottom panels (Output, Error List) |
| **Editor Splitter (Vert)** | `VerticalResizeGripBegin/Mid/End` | Environment (`{624ed9c3-...}`) | `#69552B` | Splitter bar between editor and side panels (Solution Explorer) |
| **AutoHide Splitter** | `AutoHideResizeGrip` | Environment (`{624ed9c3-...}`) | `#69552B` | Splitter bar for auto-hidden panels |
| **Toolbar Border** | `CommandBarBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | Outer perimeter border of command bars |
| **Toolbar Separators** | `CommandBarToolBarSeparator` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px divider lines between command groups |
| **Toolbar Separator Glow** | `CommandBarToolBarSeparatorHighlight` | Environment (`{624ed9c3-...}`) | `#E8B84A` | Subtle gold highlight on command group dividers |
| **Menu Border** | `CommandBarMenuBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px border around dropdown context and menu bars |
| **Menu Item Hover** | `CommandBarMenuItemMouseOverBorder` | Environment (`{624ed9c3-...}`) | `#E8B84A` | Gold border on hovered menu items |
| **Selected Command Item** | `CommandBarSelectedBorder` | Environment (`{624ed9c3-...}`) | `#FFC94A` | Bright gold border on active/toggled command icons |
| **Status Bar Border** | `StatusBarBorder` | Environment (`{624ed9c3-...}`) | `#69552B` | 1px border between status bar and IDE workspace |
| **Keyboard Focus Visual** | `FocusVisual` | CommonControls (`{c01072a1-...}`) | `#FFC94A` | Native WPF focus rectangle for accessibility |
| **Focused Text Box** | `TextBoxBorderFocused` | CommonControls (`{c01072a1-...}`) | `#FFC94A` | Bright gold border on focused text inputs |
| **Focused Dropdown** | `ComboBoxBorderFocused` | CommonControls (`{c01072a1-...}`) | `#FFC94A` | Bright gold border on focused comboboxes |
| **Inner Tab Active Marker**| `InnerTabActiveIndicator` | CommonDocument (`{72eb4027-...}`) | `#FFC94A` | Active indicator for internal document tabs |

### 1.2 Platform Constraints & Non-Overridable Shell Elements
Visual Studio enforces strict architectural boundaries regarding shell border customization:

1. **Global Tool Window Inheritance:** Visual Studio **does not provide per-tool-window color GUIDs** for borders. There is no independent "Solution Explorer Border" vs "Output Window Border" token. Docked tool windows (Solution Explorer, Properties, Git Changes, GitHub Copilot Chat, Error List, Output, and Developer PowerShell) all share `Environment.ToolWindowBorder`, `Environment.PanelBorder`, and `Environment.PanelSeparator`.
   - *Impact:* Styling `ToolWindowBorder` with `#69552B` uniformly and cleanly outlines all tool windows without visual discrepancies.
2. **Native Win32 Frame Elements:** The outer OS window border (Aero glass / DWM border) and window caption buttons (Minimize, Maximize, Close) are governed by the Windows Desktop Window Manager, not Visual Studio theme resources.
3. **Internal Third-Party Extension Controls:** Non-standard third-party extensions that do not inherit from `VsBrushes.ToolWindowBorderKey` will render their hardcoded borders.

---

## 2. Package Loading & Options Page Registration Fix

### 2.1 The Root Cause Analysis
During initial deployment, attempting to open **Tools > Options > Dark Knight Theme > Batcave Background** resulted in:
```
An error occurred loading this property page.
ActivityLog.xml: CreateInstance failed for package [DarkKnightPackage] Source: 'mscorlib'
Description: Could not load file or assembly 'DarkKnightTheme, Version=1.0.0.0...' or one of its dependencies.
System.IO.FileNotFoundException: Could not load file or assembly 'DarkKnightTheme'...
```

**Underlying Cause:**
Visual Studio extensions installed via VSIX are deployed to user-scoped directories (`%LocalAppData%\Microsoft\VisualStudio\17.0_...\Extensions\...`).
When Visual Studio reads `DarkKnightTheme.pkgdef` without a `CodeBase` entry:
```ini
[$RootKey$\Packages\{e87f2b1a-9653-4dc9-9817-21a48c9df17b}]
@="DarkKnightPackage"
"Class"="DarkKnightTheme.DarkKnightPackage"
"Assembly"="DarkKnightTheme, Version=1.0.0.0..."
```
The CLR assembly loader looks only in the GAC and `devenv.exe` application directory. Because `DarkKnightTheme.dll` is not in either location, it throws a `FileNotFoundException`, preventing the package and its `DialogPage` from loading.

### 2.2 The Solution Implemented
1. **Enabled Codebase Registration in Project:**
   In `DarkKnightTheme.csproj`:
   ```xml
   <RegisterWithCodebase>true</RegisterWithCodebase>
   <UseCodebase>true</UseCodebase>
   ```
2. **Updated Package Attribute:**
   In `DarkKnightPackage.cs`:
   ```csharp
   [PackageRegistration(UseManagedResourcesOnly = true, AllowsBackgroundLoading = true, RegisterUsing = RegistrationMethod.CodeBase)]
   ```
   This instructs `CreatePkgDef.exe` to generate the exact codebase entry:
   ```ini
   [$RootKey$\Packages\{e87f2b1a-9653-4dc9-9817-21a48c9df17b}]
   @="DarkKnightPackage"
   "InprocServer32"="$WinDir$\SYSTEM32\MSCOREE.DLL"
   "Class"="DarkKnightTheme.DarkKnightPackage"
   "CodeBase"="$PackageFolder$\DarkKnightTheme.dll"
   "AllowsBackgroundLoad"=dword:00000001
   ```
3. **COM Visibility on DialogPage:**
   In `DarkKnightSettingsPage.cs`:
   ```csharp
   [ComVisible(true)]
   [ClassInterface(ClassInterfaceType.AutoDual)]
   public class DarkKnightSettingsPage : UIElementDialogPage
   ```
   Ensures that Visual Studio's legacy COM automation interfaces can seamlessly instantiate and communicate with the WPF options host.

---

## 3. Extensibility Architecture Diagram

```
[Dark Knight Extensibility Architecture]
           │
           ├──> DarkKnight.vstheme (Human-readable XML Source, 54 Categories)
           │          │
           │          └──> VsixColorCompiler.exe (VSSDK v17.0)
           │                     │
           ├──> DarkKnight.pkgdef (126.5 KB Binary theme stream with Gold Borders)
           │
[MEF Editor Background & Settings Subsystem]
           │
           ├──> DarkKnightBackgroundCreationListener (IWpfTextViewCreationListener)
           │          │
           │          └──> DarkKnightBackgroundAdornment (IAdornmentLayer)
           │                     │  [Z-Order: Before = PredefinedAdornmentLayers.Text]
           │                     │  [IsHitTestVisible = false]
           │                     └──> Dual Layer: Viewport Image + Dark Tint Overlay (#101216)
           │
           ├──> DarkKnightSettings (Singleton Model, LocalAppData JSON persistence)
           │          │
           │          ├──> DarkKnightSettingsControl (WPF UI with Preset Picker & Sliders)
           │          │          │
           │          │          ├──> DarkKnightSettingsPage (Tools > Options DialogPage)
           │          │          └──> DarkKnightSettingsToolWindow (View > Other Windows)
           │          └──> DarkKnightPackage (AsyncPackage with CodeBase registration)
           │
           └──> MSBuild + CreatePkgDef.exe
                      │
                      └──> DarkKnightTheme.vsix (462.9 KB)
                                 │
           ┌─────────────────────┴─────────────────────┐
           ▼                                           ▼
[Visual Studio Theme Registry]               [MEF Component Catalog]
$RootKey$\Themes\{c86dec58-...}              AdornmentLayerDefinition
FallbackId = {1ded0138-47ce-...}             DarkKnightBackgroundCreationListener
ToolWindowBorder = #69552B
ToolWindowTabSelectedBorder = #FFC94A
```

---

## 4. Stability & Isolation Guarantees

1. **Pure Theme Decoupling:** The `.vstheme` / `.pkgdef` color system is 100% independent from the C# code extension. If background adornments are turned off, the editor behaves identically to any native Visual Studio theme.
2. **Non-Intrusive MEF Adornments:** Watermark adornments run on a separate visual layer behind the text, with `IsHitTestVisible = false`, ensuring no interference with typing, carets, breakpoints, or IntelliSense.
3. **No Brittle UI Hacks:** The extension strictly avoids native Win32 window hooking (`SetWindowsHookEx`), reflection into internal VS types, or full-window overlays.
