# Visual Studio Marketplace Publishing Guide — Dark Knight Theme

This guide provides instructions for publishing the **Dark Knight — Gotham Dark Theme** extension (`DarkKnightTheme.vsix`) to the official [Visual Studio Marketplace](https://marketplace.visualstudio.com/).

---

## 1. Prerequisites

1. **Microsoft Account:** A personal Microsoft account or Microsoft Entra ID (formerly Azure Active Directory).
2. **Visual Studio Marketplace Publisher:** A registered publisher profile on the Marketplace.
3. **Distributable VSIX Package:** The compiled package located at `dist/DarkKnightTheme.vsix` (v1.2.0).

---

## 2. Registering a Marketplace Publisher

If you haven't already registered a publisher on the Visual Studio Marketplace:

1. Navigate to the **[Visual Studio Marketplace Management Portal](https://marketplace.visualstudio.com/manage)**.
2. Sign in with your Microsoft account.
3. Click **Create Publisher**.
4. Fill in the publisher details:
   - **Publisher ID:** A unique alphanumeric identifier (e.g., `SkyDevLab` or `GothamExtensibility`).
     > [!IMPORTANT]
     > Note this Publisher ID. The `Publisher` attribute in `src/DarkKnightTheme/source.extension.vsixmanifest` must match your Publisher ID exactly.
   - **Publisher Name:** The public display name (e.g., `SkyDevLab` or `Gotham Extensibility`).
   - **Contact Email & Links:** Enter your support email and website / GitHub URL.
5. Click **Create**.

---

## 3. Verifying Manifest Publisher Match

Before uploading, ensure the Publisher in the VSIX manifest matches your registered Publisher ID:

1. Open `src/DarkKnightTheme/source.extension.vsixmanifest`.
2. Locate line 4:
   ```xml
   <Identity Id="DarkKnightTheme.GothamDark" Version="1.2.0" Language="en-US" Publisher="Gotham Extensibility" />
   ```
3. If your Publisher ID on the Marketplace portal is different (for example `SkyDevLab`):
   - Change `Publisher="Gotham Extensibility"` to `Publisher="SkyDevLab"`.
   - Rebuild the package by running:
     ```powershell
     .\build\build.ps1 -SkipGraphics
     ```
   - This re-packages `dist/DarkKnightTheme.vsix` with your exact publisher ID.

---

## 4. Publishing via Marketplace Web Portal (Easiest Method)

1. Open **[https://marketplace.visualstudio.com/manage](https://marketplace.visualstudio.com/manage)**.
2. Select your publisher from the dropdown or sidebar.
3. Click **New extension** > **Visual Studio**.
4. Drag and drop `dist/DarkKnightTheme.vsix` into the upload zone (or click **Browse** and select `dist\DarkKnightTheme.vsix`).
5. The portal will automatically inspect the manifest:
   - Validates **ID**, **Version**, **DisplayName**, and **Dependencies**.
   - Validates target: **Microsoft.VisualStudio.Community (17.0 to 18.0, amd64)**.
   - Extracts the 128x128 icon and hero preview image.
6. Click **Upload**.
7. The extension will undergo automated validation (typically takes 2–5 minutes). Once verified, its status changes to **Active**.
8. Your extension is now live on the public Visual Studio Marketplace and searchable inside Visual Studio under **Extensions > Manage Extensions**!

---

## 5. Publishing via Command Line (VSIXPublisher)

Visual Studio 2022 includes the native `VSIXPublisher.exe` CLI tool.

### Step 5.1: Create a Personal Access Token (PAT)
1. Go to [Azure DevOps](https://aex.dev.azure.com/me).
2. Click **Personal Access Tokens** (under Security).
3. Click **New Token**:
   - **Organization:** Select *All accessible organizations*.
   - **Scopes:** Select *Marketplace (Publish)*.
4. Copy the generated PAT token.

### Step 5.2: Publish using VSIXPublisher.exe
Locate `VSIXPublisher.exe` inside your Visual Studio 2022 installation:
```powershell
$vsixPub = "C:\Program Files\Microsoft Visual Studio\2022\Community\VSSDK\VisualStudioIntegration\Tools\Bin\VsixPublisher.exe"

& $vsixPub publish `
    -payload "dist\DarkKnightTheme.vsix" `
    -publishManifest "src\DarkKnightTheme\source.extension.vsixmanifest" `
    -personalAccessToken "<YOUR_PAT_TOKEN>"
```

---

## 6. Updating an Existing Extension

When releasing updates (e.g., v1.2.1):
1. Increment the version in:
   - `src/DarkKnightTheme/source.extension.vsixmanifest` (`Version="1.2.1"`)
   - `src/DarkKnightTheme/Properties/AssemblyInfo.cs` (`[assembly: AssemblyVersion("1.2.1.0")]`)
2. Rebuild:
   ```powershell
   .\build\build.ps1 -SkipGraphics
   ```
3. In the Marketplace portal:
   - Click the `...` menu next to **Dark Knight**.
   - Select **Edit** or **Update**.
   - Upload the new `dist/DarkKnightTheme.vsix`.
4. Visual Studio users will automatically receive update notifications via the IDE Extension Manager.
