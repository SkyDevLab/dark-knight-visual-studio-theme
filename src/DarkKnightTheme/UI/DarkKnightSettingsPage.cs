using System.Runtime.InteropServices;
using System.Windows;
using Microsoft.VisualStudio.Shell;

namespace DarkKnightTheme.UI
{
    [Guid("6e927c3f-df43-4b47-b845-6435c24b611e")]
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    public class DarkKnightSettingsPage : UIElementDialogPage
    {
        private DarkKnightSettingsControl _control;

        protected override UIElement Child
        {
            get
            {
                if (_control == null)
                {
                    _control = new DarkKnightSettingsControl();
                }
                return _control;
            }
        }
    }
}
