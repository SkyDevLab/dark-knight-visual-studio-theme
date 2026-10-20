using System;
using System.Runtime.InteropServices;
using System.Threading;
using DarkKnightTheme.UI;
using Microsoft.VisualStudio.Shell;
using Task = System.Threading.Tasks.Task;

namespace DarkKnightTheme
{
    [PackageRegistration(UseManagedResourcesOnly = true, AllowsBackgroundLoading = true)]
    [InstalledProductRegistration("#110", "#112", "1.0", IconResourceID = 400)]
    [ProvideToolWindow(typeof(DarkKnightSettingsToolWindow), Style = VsDockStyle.Tabbed, Window = "3ae79031-e1bc-11d0-8f78-00a0c9110057")]
    [ProvideOptionPage(typeof(DarkKnightSettingsPage), "Dark Knight Theme", "Batcave Background", 0, 0, true)]
    [Guid(DarkKnightPackage.PackageGuidString)]
    public sealed class DarkKnightPackage : AsyncPackage
    {
        public const string PackageGuidString = "e87f2b1a-9653-4dc9-9817-21a48c9df17b";

        protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
        {
            await this.JoinableTaskFactory.SwitchToMainThreadAsync(cancellationToken);
        }
    }
}
