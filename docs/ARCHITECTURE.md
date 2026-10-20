# Dark Knight Theme — Architecture & Technical Implementation

This document details the internal architecture, Microsoft Visual Studio Extensibility SDK integration, and package definition mechanics used to build **Dark Knight — Gotham Dark Theme for Visual Studio**.

The project delivers a hybrid extensibility package combining:
1. **Core Visual Studio Theme Subsystem:** Native `.vstheme` XML and pre-compiled `.pkgdef` binary color stream targeting the VS shell and Roslyn semantic classifier.
2. **Editor Background Watermark Subsystem:** WPF-based MEF editor extension rendering non-intrusive viewport watermarks behind text and selection.
3. **Settings & Configuration Subsystem:** WPF options page (`UIElementDialogPage`) and tool window pane (`ToolWindowPane`) for real-time background customization.

---

## 1. Architectural Overview

Visual Studio's theming pipeline differs significantly from text-editor-only systems (such as VS Code themes). Visual Studio 2022's shell is built on WPF, MEF (Managed Extensibility Framework), and native Win32/COM packages, requiring a multi-layered registration architecture:

```
[Dark Knight Theme Definition]
           │
           ├──> DarkKnight.vstheme (Human-readable XML Source, 54 Categories)
           │          │
           │          └──> VsixColorCompiler.exe (VS 2022 VSSDK)
           │                     │
           ├──> DarkKnight.pkgdef (Binary-encoded theme registry stream)
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
           │          └──> DarkKnightPackage (AsyncPackage Registration)
           │
           └──> MSBuild + CreatePkgDef.exe
                      │
                      └──> DarkKnightTheme.vsix
                                 │
           ┌─────────────────────┴─────────────────────┐
           ▼                                           ▼
[Visual Studio Theme Registry]               [MEF Component Catalog]
$RootKey$\Themes\{c86dec58-...}              AdornmentLayerDefinition
FallbackId = {1ded0138-47ce-...}             DarkKnightBackgroundCreationListener
```

---

## 2. Core Extensibility Components

### 2.1 The `.vstheme` XML File
The `.vstheme` file is the master XML definition containing categories, tokens, foreground/background definitions, and color types (`CT_RAW` with `AARRGGBB` hex encoding).

Key attributes:
- `Name="Dark Knight"`: The display name populated in Visual Studio's theme selection interfaces (**Tools > Theme > Dark Knight**).
- `GUID="{c86dec58-e31f-483a-af04-90c711aa3ba5}"`: The unique theme identifier.
- `FallbackId="{1ded0138-47ce-435e-84ef-9ec1f439b749}"`: Points directly to the built-in **Visual Studio Dark Theme**. Any token not explicitly styled by Dark Knight automatically inherits from Visual Studio's Dark theme, guaranteeing 100% stability, zero unreadable text in third-party extensions, and no missing UI resources.

### 2.2 The `.pkgdef` Registry Packages
Visual Studio does not parse raw XML at runtime for shell performance. Instead:
- Theme files are compiled into `.pkgdef` format using `VsixColorCompiler.exe`.
- Extension package attributes are compiled into `DarkKnightTheme.pkgdef` using `CreatePkgDef.exe`.

Inside `DarkKnight.pkgdef`, colors are encoded into binary `Data=hex:...` streams under their category subkeys:
```ini
[$RootKey$\Themes\{c86dec58-e31f-483a-af04-90c711aa3ba5}]
@="Dark Knight"
"Name"="Dark Knight"
"FallbackId"="{1ded0138-47ce-435e-84ef-9ec1f439b749}"

[$RootKey$\Themes\{c86dec58-e31f-483a-af04-90c711aa3ba5}\Environment]
"Data"=hex:e9,38,00,00,0b,...
```

Inside `DarkKnightTheme.pkgdef`, package and settings registrations are declared:
```ini
[$RootKey$\ToolsOptionsPages\Dark Knight Theme\Batcave Background]
"Package"="{e87f2b1a-9653-4dc9-9817-21a48c9df17b}"
"Page"="{6e927c3f-df43-4b47-b845-6435c24b611e}"

[$RootKey$\ToolWindows\{476b7e0d-136b-4e11-94df-658a5da1f11c}]
@="{e87f2b1a-9653-4dc9-9817-21a48c9df17b}"
"Name"="DarkKnightTheme.UI.DarkKnightSettingsToolWindow"
```

### 2.3 `source.extension.vsixmanifest`
The extension manifest declares the extension identity, installation target, and assets:
- **Target:** Visual Studio 2022 (`[17.0, 18.0)`) with `ProductArchitecture = amd64`.
- **Assets:**
  - `Microsoft.VisualStudio.VsPackage`: Points to `DarkKnight.pkgdef` (Theme registry).
  - `Microsoft.VisualStudio.VsPackage`: Points to `DarkKnightTheme.pkgdef` (Package & Settings registry).
  - `Microsoft.VisualStudio.ColorTheme`: Points to `DarkKnight.vstheme`.
  - `Microsoft.VisualStudio.MefComponent`: Points to `DarkKnightTheme.dll` (MEF background layer).

---

## 3. Editor Background Subsystem Architecture

The background watermark implementation is engineered strictly using official Visual Studio MEF extensibility APIs, avoiding dangerous hook libraries or unstable low-level Win32 window-subclassing hacks.

### 3.1 Non-Intrusive Z-Ordering (`Before = PredefinedAdornmentLayers.Text`)
```csharp
[Export(typeof(AdornmentLayerDefinition))]
[Name(LayerName)]
[Order(Before = PredefinedAdornmentLayers.Text)]
[TextViewRole(PredefinedTextViewRoles.Document)]
internal static AdornmentLayerDefinition LayerDefinition;
```
By placing the adornment layer physically before `PredefinedAdornmentLayers.Text` in the WPF visual tree:
- Text characters, syntax tokens, and glyphs render on top.
- Selection geometry and word highlights render on top.
- Squiggles, breakpoints, margin glyphs, and IntelliSense popups render completely unobstructed.

### 3.2 Viewport Tracking & Hit-Test Transparency
In `DarkKnightBackgroundAdornment`:
- The container `Grid`, watermark `Image`, and tint `Rectangle` have `IsHitTestVisible = false`.
- The editor receives 100% of mouse and keyboard events (caret clicks, drag-to-select, breakpoint toggles, context menus).
- In `_textView.LayoutChanged` and viewport size events, the container coordinates are synced to `_textView.ViewportLeft` and `_textView.ViewportTop`, locking the watermark to the visible window frame without jitter.

### 3.3 Dual-Layer Contrast Shield
- The watermark image has adjustable opacity (default `0.08`, max `0.35`).
- A dark translucent overlay rectangle (`#101216`) sits directly above the image with adjustable opacity (default `0.70`).
- This guarantees that even detailed architectural schematics never interfere with code readability.

---

## 4. Settings & Real-Time Sync Subsystem

- **Model:** `DarkKnightSettings` manages persistence via `DataContractJsonSerializer` to `%LocalAppData%\Microsoft\VisualStudio\DarkKnight\settings.json`.
- **Event Bus:** `DarkKnightSettings.SettingsChanged` alerts all active `IWpfTextView` instances to re-render in real-time without requiring IDE restart.
- **UI Hosts:**
  1. **Options Page:** `DarkKnightSettingsPage` inherits `UIElementDialogPage` to embed the WPF settings control directly into **Tools > Options > Dark Knight Theme > Batcave Background**.
  2. **Tool Window:** `DarkKnightSettingsToolWindow` provides a dockable panel accessible under **View > Other Windows > Dark Knight — Batcave Background Settings**.

---

## 5. Visual Studio Categories Covered

The Dark Knight theme defines explicit styling across **54 Visual Studio Categories**, including:

1. **Environment (`{624ed9c3-bdfd-41fa-96c3-7c824ea32e3d}`):** Main IDE frame, title bar, menus, command bars, status bar (default, debugging, building), document tabs, scrollbars.
2. **Roslyn Text Editor MEF Items (`{75a05685-00a8-4ded-bae5-e7a50bfa929a}`):** C# and VB.NET syntax tokens, control keywords, types, interfaces, methods, constants, properties, locals, parameters.
3. **Text Editor Language Service Items (`{e0187991-b458-4f7e-8ca9-42c9a573b56c}`):** Core language service syntax elements, strings, numbers, comments, keywords.
4. **Text Editor (`{a27b4e24-a735-4d1d-b8e7-9716e1e3d8e0}`):** Fonts & Colors core editor settings, selection highlights, line numbers, cursor, breakpoints, execution statement pointers, visible whitespace.
5. **CommonControls (`{c01072a1-a915-4abf-89b7-e2f9e8ec4c7f}`):** Buttons, checkboxes, text boxes, comboboxes, tree nodes.
6. **CommonDocument (`{72eb4027-f4ae-4b6c-9cc2-dfd5b49d9415}`):** Document containers, splitters, tab headers.
7. **TreeView (`{92ecf08e-8b13-4cf4-99e9-ae2692382185}`):** Solution Explorer and tool window tree nodes, hover states, selection states.
8. **ThemedDialog & ThemedUtilityDialog:** Visual Studio options dialogs, project properties.
9. **Diagnostics & DiagnosticsHub:** Error List, warnings, informational messages, profiling tools.
10. **Find, Find Results & SearchControl:** Quick Find, Find in Files, search inputs, result grids.
11. **Output Window & Terminal:** Build output, debug output, integrated terminal colors.
12. **TeamExplorer & VersionControl:** Git Changes, commit interface, branch manager, diff colors.
13. **Statement Completion & Editor Tooltip:** IntelliSense completion list, signature help, parameter info, Quick Info tooltips.
14. **CodeSenseControls (CodeLens):** Reference counts, author indicators, test status.
