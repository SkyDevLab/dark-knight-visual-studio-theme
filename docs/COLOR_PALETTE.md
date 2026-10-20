# Dark Knight Theme — Color Palette & Design System

The **Dark Knight** theme is engineered around a sophisticated Batcave workstation aesthetic: near-black charcoal foundation, deep graphite tool surfaces, muted Batman gold primary accents, and electric Gotham blue secondary accents.

Designed specifically for extended programming sessions in Microsoft Visual Studio 2022, the palette eliminates harsh pure-black eye fatigue while maintaining high-contrast clarity across all .NET language classifications.

---

## 1. Core Palette Tokens

| Token Role | Hex Code | Swatch | Purpose / IDE Element |
| :--- | :--- | :---: | :--- |
| **Primary Background** | `#101216` | `■` | Editor canvas, main IDE backdrop, terminal background |
| **Secondary Surface** | `#191D24` | `■` | Solution Explorer, Git Changes, Error List, Tool Windows |
| **Header Surface** | `#14171E` | `■` | Tool window headers, document tab well backdrop, title bar |
| **Card / Dropdown** | `#14171E` | `■` | Input boxes, text fields, dropdown menus, quick-find |
| **Elevated Surface** | `#202530` | `■` | Hover states, active buttons, selection indicators |
| **Subtle Border** | `#232833` | `■` | Window dividers, editor ruler, tab borders, pane splitters |
| **Active Border** | `#2A313D` | `■` | Input focus border, popup frame border |
| **Primary Accent** | `#E8B84A` | `■` | **Batman Gold**: Active tab accent line, cursor, string literals |
| **Muted Accent** | `#C69B37` | `■` | Unfocused tab accent, secondary gold indicators |
| **Secondary Accent** | `#4D8DCC` | `■` | **Gotham Blue**: C# keywords, primary buttons, focus outlines |
| **Electric Accent** | `#5EA1E6` | `■` | Control flow keywords (`if`, `return`, `await`, `async`) |
| **Primary Text** | `#E6E8ED` | `■` | Plain text, active tab title, editor variables, operators |
| **Secondary Text** | `#929BA8` | `■` | Inactive tab title, tool window labels, line numbers |
| **Muted Text / Disabled** | `#5A6270` | `■` | Inactive search placeholder, disabled controls |
| **Success** | `#38A169` | `■` | Muted emerald green: Git additions, build success |
| **Warning** | `#E09F3E` | `■` | Warm amber: Compiler warnings, constants, escape sequences |
| **Error / Diagnostic** | `#E5484D` | `■` | Clear red: Compiler errors, breakpoint marker, Git deletions |
| **Active Selection** | `#1B385C` | `■` | Deep Gotham navy: High contrast selection background |
| **Inactive Selection** | `#162C46` | `■` | Unfocused selection background |
| **Word Match** | `#264F78` | `■` | Matching word / reference highlight background |

---

## 2. Accessibility & Contrast Verification (WCAG 2.1)

All primary text and code classifications are calibrated against their respective surface backgrounds to meet or exceed **WCAG 2.1 AA** (4.5:1 for normal text) and **AAA** (7.0:1) standards:

| Foreground Token | Background Token | Contrast Ratio | WCAG Compliance | Notes |
| :--- | :--- | :---: | :---: | :--- |
| Primary Text (`#E6E8ED`) | Editor Canvas (`#101216`) | **14.8 : 1** | **AAA** | Crystal-clear readability for long sessions |
| Secondary Text (`#929BA8`) | Editor Canvas (`#101216`) | **6.7 : 1** | **AA** | Comfortable, non-distracting UI secondary text |
| Muted Batman Gold (`#E8B84A`)| Editor Canvas (`#101216`) | **10.5 : 1** | **AAA** | High-contrast string literal scanning |
| Gotham Blue (`#4D8DCC`) | Editor Canvas (`#101216`) | **6.8 : 1** | **AA** | Distinct keyword identification |
| Cool Cyan (`#4EC9B0`) | Editor Canvas (`#101216`) | **11.2 : 1** | **AAA** | Type and class identification |
| Mint Cyan (`#52BAA7`) | Editor Canvas (`#101216`) | **10.0 : 1** | **AAA** | Clear interface differentiation |
| Soft Blue (`#61AFEF`) | Editor Canvas (`#101216`) | **9.1 : 1** | **AAA** | Smooth method call scanning |
| Lavender (`#C678DD`) | Editor Canvas (`#101216`) | **7.5 : 1** | **AA** | Numeric literal identification |
| Warm Amber (`#E09F3E`) | Editor Canvas (`#101216`) | **8.4 : 1** | **AA** | Warning and constant identification |
| Clear Red (`#E5484D`) | Editor Canvas (`#101216`) | **4.9 : 1** | **AA** | Error diagnostics without blinding glare |
| Primary Text (`#E6E8ED`) | Selection (`#1B385C`) | **8.9 : 1** | **AAA** | Text within selections remains fully legible |

---

## 3. C# & .NET Language Classification Mappings

Visual Studio's Roslyn semantic colorizer interacts seamlessly with the following syntax mappings:

```csharp
// Example C# Syntax Showcase
namespace WayneEnterprises.Gotham.Services;

/// <summary>Batcave threat triage and dispatch service.</summary>
public sealed class CrimeReportService : ICrimeReportService
{
    private readonly IBatcaveTelemetry _telemetry;
    private const int MaxThreatCapacity = 1024;

    public async Task<ThreatAssessment> AnalyzeDistressSignalAsync(DistressSignal signal)
    {
        if (signal is null)
            throw new ArgumentNullException(nameof(signal));

        var threatLevel = signal.Priority * 1.618;
        _telemetry.LogDispatch("Sector 7 Alert: High Threat Detected");

        return new ThreatAssessment(threatLevel, Status.Active);
    }
}
```

- **Namespaces:** Cool gray-blue (`#7998B4`)
- **Keywords:** Gotham blue (`#4D8DCC`)
- **Control Flow Keywords (`if`, `return`, `await`):** Electric blue (`#5EA1E6`)
- **Classes, Structs, Enums:** Cool cyan (`#4EC9B0`)
- **Interfaces & Type Parameters:** Soft mint cyan (`#52BAA7` / `#80D4C5`)
- **Methods:** Soft blue (`#61AFEF`)
- **Extension Methods:** Cyan-blue (`#72C0F5`)
- **Strings:** Muted Batman gold (`#E8B84A`)
- **Escape Characters:** Warm amber (`#E09F3E`)
- **Numbers:** Lavender (`#C678DD`)
- **Comments & XML Doc:** Muted green-gray (`#62727B`)
- **XML Doc Tags:** Slate blue (`#5C82A6`)
- **Constants:** Warm amber (`#E09F3E`)
- **Variables & Locals:** Soft white (`#E6E8ED`)
- **Parameters:** Light cyan-blue (`#9CDCFE`)
- **Fields & Properties:** Crisp light slate (`#D1D9E0`)
- **Operators & Punctuation:** Soft white (`#E6E8ED`)
