using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using DarkKnightTheme.Settings;
using Microsoft.Win32;

namespace DarkKnightTheme.UI
{
    public partial class DarkKnightSettingsControl : UserControl
    {
        private bool _isInitializing = true;
        private readonly SolidColorBrush _activeBrush = new SolidColorBrush(Color.FromRgb(232, 184, 74)); // #E8B84A
        private readonly SolidColorBrush _inactiveBrush = new SolidColorBrush(Color.FromRgb(42, 52, 69)); // #2A3445

        public DarkKnightSettingsControl()
        {
            try
            {
                InitializeComponent();
                LoadThumbnails();
                LoadSettingsToUI();
            }
            catch
            {
            }
            finally
            {
                _isInitializing = false;
            }
        }

        private void LoadThumbnails()
        {
            try
            {
                string assemblyDir = Path.GetDirectoryName(typeof(DarkKnightSettings).Assembly.Location);
                if (string.IsNullOrEmpty(assemblyDir)) return;

                string bgDir = Path.Combine(assemblyDir, "Resources", "Backgrounds");
                SetThumbnail(ImgThumb1, Path.Combine(bgDir, "thumb_batcave_mainframe.png"));
                SetThumbnail(ImgThumb2, Path.Combine(bgDir, "thumb_gotham_skyline.png"));
                SetThumbnail(ImgThumb3, Path.Combine(bgDir, "thumb_gargoyle_vigil.png"));
                SetThumbnail(ImgThumb4, Path.Combine(bgDir, "thumb_batmobile_techgrid.png"));
            }
            catch
            {
                // Silently skip preview load errors in design mode
            }
        }

        private void SetThumbnail(Image img, string path)
        {
            if (File.Exists(path))
            {
                var bmp = new BitmapImage();
                bmp.BeginInit();
                bmp.UriSource = new Uri(path, UriKind.Absolute);
                bmp.CacheOption = BitmapCacheOption.OnLoad;
                bmp.EndInit();
                bmp.Freeze();
                img.Source = bmp;
            }
        }

        private void LoadSettingsToUI()
        {
            var s = DarkKnightSettings.Instance;

            ChkEnableBackground.IsChecked = s.IsEnabled;
            SliderOpacity.Value = Math.Round(s.Opacity * 100);
            LblOpacity.Text = $"{SliderOpacity.Value}%";

            SliderOverlay.Value = Math.Round(s.OverlayOpacity * 100);
            LblOverlay.Text = $"{SliderOverlay.Value}%";

            TxtCustomImage.Text = s.CustomImagePath ?? string.Empty;

            UpdatePresetCardSelection(s.SelectedPreset);

            for (int i = 0; i < CmbPosition.Items.Count; i++)
            {
                if (CmbPosition.Items[i] is ComboBoxItem item && (string)item.Tag == s.Position)
                {
                    CmbPosition.SelectedIndex = i;
                    break;
                }
            }
            if (CmbPosition.SelectedIndex < 0) CmbPosition.SelectedIndex = 0;
        }

        private void UpdatePresetCardSelection(string preset)
        {
            CardPreset1.BorderBrush = preset == "BatcaveMainframe" ? _activeBrush : _inactiveBrush;
            CardPreset1.BorderThickness = new Thickness(preset == "BatcaveMainframe" ? 2 : 1);

            CardPreset2.BorderBrush = preset == "GothamSkyline" ? _activeBrush : _inactiveBrush;
            CardPreset2.BorderThickness = new Thickness(preset == "GothamSkyline" ? 2 : 1);

            CardPreset3.BorderBrush = preset == "GargoyleVigil" ? _activeBrush : _inactiveBrush;
            CardPreset3.BorderThickness = new Thickness(preset == "GargoyleVigil" ? 2 : 1);

            CardPreset4.BorderBrush = preset == "BatmobileTechGrid" ? _activeBrush : _inactiveBrush;
            CardPreset4.BorderThickness = new Thickness(preset == "BatmobileTechGrid" ? 2 : 1);
        }

        private void SelectPreset1(object sender, MouseButtonEventArgs e)
        {
            DarkKnightSettings.Instance.SelectedPreset = "BatcaveMainframe";
            UpdatePresetCardSelection("BatcaveMainframe");
            ApplyCurrentSettings();
        }

        private void SelectPreset2(object sender, MouseButtonEventArgs e)
        {
            DarkKnightSettings.Instance.SelectedPreset = "GothamSkyline";
            UpdatePresetCardSelection("GothamSkyline");
            ApplyCurrentSettings();
        }

        private void SelectPreset3(object sender, MouseButtonEventArgs e)
        {
            DarkKnightSettings.Instance.SelectedPreset = "GargoyleVigil";
            UpdatePresetCardSelection("GargoyleVigil");
            ApplyCurrentSettings();
        }

        private void SelectPreset4(object sender, MouseButtonEventArgs e)
        {
            DarkKnightSettings.Instance.SelectedPreset = "BatmobileTechGrid";
            UpdatePresetCardSelection("BatmobileTechGrid");
            ApplyCurrentSettings();
        }

        private void BrowseCustomImage_Click(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog
            {
                Filter = "Image Files (*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp|All Files (*.*)|*.*",
                Title = "Select Custom Batcave Workstation Background"
            };

            if (dlg.ShowDialog() == true)
            {
                TxtCustomImage.Text = dlg.FileName;
                DarkKnightSettings.Instance.SelectedPreset = "Custom";
                DarkKnightSettings.Instance.CustomImagePath = dlg.FileName;
                UpdatePresetCardSelection("Custom");
                ApplyCurrentSettings();
            }
        }

        private void TxtCustomImage_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (_isInitializing) return;
            if (!string.IsNullOrEmpty(TxtCustomImage.Text) && File.Exists(TxtCustomImage.Text))
            {
                DarkKnightSettings.Instance.CustomImagePath = TxtCustomImage.Text;
            }
        }

        private void OnSettingChanged(object sender, RoutedEventArgs e)
        {
            if (_isInitializing) return;
            DarkKnightSettings.Instance.IsEnabled = ChkEnableBackground.IsChecked == true;
            ApplyCurrentSettings();
        }

        private void SliderOpacity_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            if (LblOpacity != null)
            {
                LblOpacity.Text = $"{Math.Round(SliderOpacity.Value)}%";
            }
            if (_isInitializing) return;
            DarkKnightSettings.Instance.Opacity = SliderOpacity.Value / 100.0;
            ApplyCurrentSettings();
        }

        private void SliderOverlay_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            if (LblOverlay != null)
            {
                LblOverlay.Text = $"{Math.Round(SliderOverlay.Value)}%";
            }
            if (_isInitializing) return;
            DarkKnightSettings.Instance.OverlayOpacity = SliderOverlay.Value / 100.0;
            ApplyCurrentSettings();
        }

        private void CmbPosition_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (_isInitializing) return;
            if (CmbPosition.SelectedItem is ComboBoxItem item && item.Tag is string tag)
            {
                DarkKnightSettings.Instance.Position = tag;
                ApplyCurrentSettings();
            }
        }

        private void ApplyCurrentSettings()
        {
            DarkKnightSettings.Instance.Save();
            if (TxtStatus != null)
            {
                TxtStatus.Text = $"Settings applied at {DateTime.Now:HH:mm:ss}. Active editors updated.";
            }
        }

        private void BtnApply_Click(object sender, RoutedEventArgs e)
        {
            DarkKnightSettings.Instance.IsEnabled = ChkEnableBackground.IsChecked == true;
            DarkKnightSettings.Instance.Opacity = SliderOpacity.Value / 100.0;
            DarkKnightSettings.Instance.OverlayOpacity = SliderOverlay.Value / 100.0;
            if (CmbPosition.SelectedItem is ComboBoxItem item && item.Tag is string tag)
            {
                DarkKnightSettings.Instance.Position = tag;
            }
            DarkKnightSettings.Instance.CustomImagePath = TxtCustomImage.Text;
            ApplyCurrentSettings();
        }

        private void BtnReset_Click(object sender, RoutedEventArgs e)
        {
            _isInitializing = true;
            DarkKnightSettings.Instance.ResetToDefaults();
            LoadSettingsToUI();
            _isInitializing = false;

            if (TxtStatus != null)
            {
                TxtStatus.Text = "Settings reset to defaults (Background disabled, 40% opacity).";
            }
        }
    }
}
