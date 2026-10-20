# Dark Knight Theme — Verification & Test Report

This document records the verification steps, environment validations, and runtime test results for **Dark Knight — Gotham Dark Theme for Visual Studio** (v1.1.0).

---

## 1. Environment Verification

- **Host Operating System:** Windows 11 / Windows Server x64
- **Visual Studio Version:** Visual Studio Community 2022 (Version `17.14.37301.10`, ProductLine `Dev17`)
- **Visual Studio SDK:** VSSDK v17.0 (`Microsoft.VsSDK.targets`, `VsixColorCompiler.exe`, `CreatePkgDef.exe`, `VsixUtil.exe`)
- **.NET SDK:** .NET SDK 9.0 (`9.0.1626.22923`)
- **MSBuild:** Microsoft (R) Build Engine version 17.14.40+3e7442088 for .NET Framework

---

## 2. Test Execution & Results

### Test Case 1: Automated End-to-End Build (`build\build.ps1`)
- **Objective:** Verify that the automated build pipeline runs all asset generators, compiles theme resources with `VsixColorCompiler`, compiles C# MEF/VSPackage assemblies with MSBuild, generates package pkgdefs with `CreatePkgDef`, and produces the distributable VSIX.
- **Command:** `powershell -ExecutionPolicy Bypass -File .\build\build.ps1`
- **Result:** **PASSED** (0 Warnings, 0 Errors).
- **Distributable VSIX:** `dist\DarkKnightTheme.vsix` (462.9 KB).

### Test Case 2: Verification of Package Registration & `CodeBase` Entry
- **Objective:** Verify that `CreatePkgDef.exe` outputs `"CodeBase"="$PackageFolder$\DarkKnightTheme.dll"` to fix the package loading error and Tools > Options property page crash.
- **Header in `DarkKnightTheme.pkgdef`:**
  ```ini
  [$RootKey$\Packages\{e87f2b1a-9653-4dc9-9817-21a48c9df17b}]
  @="DarkKnightPackage"
  "InprocServer32"="$WinDir$\SYSTEM32\MSCOREE.DLL"
  "Class"="DarkKnightTheme.DarkKnightPackage"
  "CodeBase"="$PackageFolder$\DarkKnightTheme.dll"
  "AllowsBackgroundLoad"=dword:00000001
  ```
- **Result:** **PASSED**. Codebase is explicitly registered, enabling the CLR to resolve `DarkKnightTheme.dll` from the extension directory without throwing `FileNotFoundException`.

### Test Case 3: Gold Panel Border Resource Tokens in `DarkKnight.vstheme` & `DarkKnight.pkgdef`
- **Objective:** Verify that official Visual Studio border and separator tokens are compiled with the specified gold palette:
  - Inactive Panel Border: `#69552B` (Muted antique gold)
  - Active Panel Border: `#E8B84A` (Primary gold)
  - Selected Elements & Keyboard Focus: `#FFC94A` (Bright gold)
- **Tokens Verified:**
  - `Environment.ToolWindowBorder`: `FF69552B`
  - `Environment.PanelBorder`: `FF69552B`
  - `Environment.PanelSeparator`: `FF69552B`
  - `Environment.ToolWindowTabBorder`: `FF69552B`
  - `Environment.ToolWindowTabSelectedBorder`: `FFFFC94A`
  - `Environment.FileTabBorder`: `FF69552B`
  - `Environment.FileTabSelectedBorder`: `FFFFC94A`
  - `Environment.FileTabDocumentBorderBackground`: `FF69552B`
  - `Environment.HorizontalResizeGrip`: `FF69552B`
  - `Environment.VerticalResizeGripBegin/Middle/End`: `FF69552B`
  - `Environment.CommandBarToolBarSeparator`: `FF69552B`
  - `Environment.CommandBarToolBarSeparatorHighlight`: `FFE8B84A`
  - `Environment.CommandBarSelectedBorder`: `FFFFC94A`
  - `Environment.StatusBarBorder`: `FF69552B`
  - `CommonControls.FocusVisual`: `FFFFC94A`
  - `CommonControls.TextBoxBorderFocused`: `FFFFC94A`
  - `CommonControls.ComboBoxBorderFocused`: `FFFFC94A`
- **Result:** **PASSED**. All tokens verified in `DarkKnight.vstheme` and compiled to 126,506-byte `DarkKnight.pkgdef`.

### Test Case 4: XML Schema Validation in `VsixColorCompiler`
- **Objective:** Verify that `<Color>` elements in `DarkKnight.vstheme` strictly adhere to the XSD sequence schema (`<Background>` preceding `<Foreground>`).
- **Compiler Output:**
  ```
  Microsoft(R) Visual Studio(R) Vsix Color Compiler version 17.0.0.4.
  (C) Microsoft Corporation. All rights reserved.
  Final pkgdef compiled successfully: 126506 bytes
  ```
- **Result:** **PASSED** (0 Errors, 0 XML schema violations).

---

## 3. Manual Testing & Verification in Visual Studio 2022

### A. Testing the Core Theme & Gold Panel Borders
1. **Launch Experimental Hive:**
   ```powershell
   & "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" /rootsuffix Exp
   ```
2. **Or Install Distributable VSIX:**
   - Double-click `dist\DarkKnightTheme.vsix`.
   - Complete the VSIX installer and start Visual Studio 2022.
3. **Select Theme:**
   - Open **Tools > Theme > Dark Knight**.
   - Verify that Solution Explorer, Properties, Git Changes, Error List, Output window, and Terminal display the subtle antique gold (`#69552B`) 1-pixel border.
   - Verify that the active document tab displays the bright gold (`#FFC94A`) accent bar.
   - Verify that toolbar separators display the gold divider accents.

### B. Testing Tools > Options Settings Page
1. Navigate to **Tools > Options**.
2. Expand the **Dark Knight Theme** category in the left tree view.
3. Click **Batcave Background**.
4. **Verify that the property page loads without errors:** The Batcave Workstation settings panel displays the preset cards, opacity sliders, and enable/disable toggle.
