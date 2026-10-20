using System;
using System.Runtime.InteropServices;
using Microsoft.VisualStudio.Shell;

namespace DarkKnightTheme.UI
{
    [Guid("476b7e0d-136b-4e11-94df-658a5da1f11c")]
    public class DarkKnightSettingsToolWindow : ToolWindowPane
    {
        public DarkKnightSettingsToolWindow() : base(null)
        {
            this.Caption = "Dark Knight — Batcave Background Settings";
            this.Content = new DarkKnightSettingsControl();
        }
    }
}
