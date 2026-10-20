using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Text.Editor;
using Microsoft.VisualStudio.Utilities;

namespace DarkKnightTheme.Background
{
    internal static class DarkKnightBackgroundAdornmentLayer
    {
        public const string LayerName = "DarkKnightBackgroundAdornmentLayer";

#pragma warning disable 649
        [Export(typeof(AdornmentLayerDefinition))]
        [Name(LayerName)]
        [Order(Before = PredefinedAdornmentLayers.Text)]
        [TextViewRole(PredefinedTextViewRoles.Document)]
        internal static AdornmentLayerDefinition LayerDefinition;
#pragma warning restore 649
    }
}
