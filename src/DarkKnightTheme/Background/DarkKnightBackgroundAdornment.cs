using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using DarkKnightTheme.Settings;
using Microsoft.VisualStudio.Text.Editor;

namespace DarkKnightTheme.Background
{
    internal sealed class DarkKnightBackgroundAdornment
    {
        private readonly IWpfTextView _textView;
        private readonly IAdornmentLayer _adornmentLayer;
        private readonly Grid _container;
        private readonly Image _image;
        private readonly Rectangle _overlay;
        private bool _isAdornmentAdded;

        public static void Create(IWpfTextView textView)
        {
            if (textView == null) return;
            new DarkKnightBackgroundAdornment(textView);
        }

        private DarkKnightBackgroundAdornment(IWpfTextView textView)
        {
            _textView = textView;
            _adornmentLayer = textView.GetAdornmentLayer(DarkKnightBackgroundAdornmentLayer.LayerName);

            _container = new Grid
            {
                IsHitTestVisible = false,
                ClipToBounds = true
            };

            _image = new Image
            {
                IsHitTestVisible = false
            };

            _overlay = new Rectangle
            {
                IsHitTestVisible = false,
                Fill = new SolidColorBrush(Color.FromRgb(16, 18, 22)) // Near-black Batcave Charcoal (#101216)
            };

            _container.Children.Add(_image);
            _container.Children.Add(_overlay);

            _textView.LayoutChanged += OnLayoutChanged;
            _textView.ViewportHeightChanged += OnViewportChanged;
            _textView.ViewportWidthChanged += OnViewportChanged;
            _textView.Closed += OnClosed;

            DarkKnightSettings.SettingsChanged += OnSettingsChanged;

            ApplySettings();
            UpdateLayoutBounds();
        }

        private void OnSettingsChanged(object sender, EventArgs e)
        {
            if (_textView.IsClosed) return;

            _textView.VisualElement.Dispatcher.BeginInvoke(new Action(() =>
            {
                ApplySettings();
                UpdateLayoutBounds();
            }));
        }

        private void OnViewportChanged(object sender, EventArgs e)
        {
            UpdateLayoutBounds();
        }

        private void OnLayoutChanged(object sender, TextViewLayoutChangedEventArgs e)
        {
            UpdateLayoutBounds();
        }

        private void UpdateLayoutBounds()
        {
            if (_textView.IsClosed || _adornmentLayer == null) return;

            var settings = DarkKnightSettings.Instance;
            if (!settings.IsEnabled)
            {
                if (_isAdornmentAdded)
                {
                    _adornmentLayer.RemoveAllAdornments();
                    _isAdornmentAdded = false;
                }
                return;
            }

            double width = Math.Max(0, _textView.ViewportWidth);
            double height = Math.Max(0, _textView.ViewportHeight);

            Canvas.SetLeft(_container, 0);
            Canvas.SetTop(_container, 0);
            _container.Width = width;
            _container.Height = height;

            if (_adornmentLayer.IsEmpty || !_isAdornmentAdded)
            {
                _adornmentLayer.RemoveAllAdornments();
                if (width > 0 && height > 0)
                {
                    _adornmentLayer.AddAdornment(
                        AdornmentPositioningBehavior.ViewportRelative,
                        null,
                        "DarkKnightBackgroundAdornment",
                        _container,
                        (tag, uiElement) => { _isAdornmentAdded = false; });
                    _isAdornmentAdded = true;
                }
            }
        }

        private void ApplySettings()
        {
            var settings = DarkKnightSettings.Instance;

            if (!settings.IsEnabled)
            {
                _container.Visibility = Visibility.Collapsed;
                if (_isAdornmentAdded)
                {
                    _adornmentLayer?.RemoveAllAdornments();
                    _isAdornmentAdded = false;
                }
                return;
            }

            _container.Visibility = Visibility.Visible;
            _image.Opacity = Math.Max(0.05, Math.Min(1.0, settings.Opacity));
            _overlay.Opacity = Math.Max(0.0, Math.Min(0.9, settings.OverlayOpacity));

            // Load Image
            _image.Source = ResolveImageSource(settings);

            // Positioning & Scaling
            switch (settings.Position)
            {
                case "Center":
                    _image.HorizontalAlignment = HorizontalAlignment.Center;
                    _image.VerticalAlignment = VerticalAlignment.Center;
                    _image.Stretch = Stretch.Uniform;
                    break;
                case "UniformToFill":
                    _image.HorizontalAlignment = HorizontalAlignment.Stretch;
                    _image.VerticalAlignment = VerticalAlignment.Stretch;
                    _image.Stretch = Stretch.UniformToFill;
                    break;
                case "TopRight":
                    _image.HorizontalAlignment = HorizontalAlignment.Right;
                    _image.VerticalAlignment = VerticalAlignment.Top;
                    _image.Stretch = Stretch.Uniform;
                    break;
                case "BottomRight":
                default:
                    _image.HorizontalAlignment = HorizontalAlignment.Right;
                    _image.VerticalAlignment = VerticalAlignment.Bottom;
                    _image.Stretch = Stretch.Uniform;
                    break;
            }
        }

        private ImageSource ResolveImageSource(DarkKnightSettings settings)
        {
            try
            {
                string imagePath = null;

                if (settings.SelectedPreset == "Custom" && !string.IsNullOrEmpty(settings.CustomImagePath) && File.Exists(settings.CustomImagePath))
                {
                    imagePath = settings.CustomImagePath;
                }
                else
                {
                    string filename = "batcave_mainframe.png";
                    switch (settings.SelectedPreset)
                    {
                        case "GothamSkyline":
                            filename = "gotham_skyline.png";
                            break;
                        case "GargoyleVigil":
                            filename = "gargoyle_vigil.png";
                            break;
                        case "BatmobileTechGrid":
                            filename = "batmobile_techgrid.png";
                            break;
                        case "BatcaveMainframe":
                        default:
                            filename = "batcave_mainframe.png";
                            break;
                    }

                    string assemblyLocation = typeof(DarkKnightBackgroundAdornment).Assembly.Location;
                    if (string.IsNullOrEmpty(assemblyLocation))
                    {
                        assemblyLocation = typeof(DarkKnightSettings).Assembly.Location;
                    }
                    if (string.IsNullOrEmpty(assemblyLocation) && !string.IsNullOrEmpty(typeof(DarkKnightSettings).Assembly.CodeBase))
                    {
                        var uri = new Uri(typeof(DarkKnightSettings).Assembly.CodeBase);
                        assemblyLocation = uri.LocalPath;
                    }

                    string assemblyDir = System.IO.Path.GetDirectoryName(assemblyLocation);
                    if (!string.IsNullOrEmpty(assemblyDir))
                    {
                        string candidate = System.IO.Path.Combine(assemblyDir, "Resources", "Backgrounds", filename);
                        if (File.Exists(candidate))
                        {
                            imagePath = candidate;
                        }
                    }
                }

                if (!string.IsNullOrEmpty(imagePath) && File.Exists(imagePath))
                {
                    var bitmap = new BitmapImage();
                    bitmap.BeginInit();
                    bitmap.UriSource = new Uri(imagePath, UriKind.Absolute);
                    bitmap.CacheOption = BitmapCacheOption.OnLoad;
                    bitmap.EndInit();
                    bitmap.Freeze();
                    return bitmap;
                }
            }
            catch
            {
                // Fallback to blank if load fails
            }

            return null;
        }

        private void OnClosed(object sender, EventArgs e)
        {
            _textView.LayoutChanged -= OnLayoutChanged;
            _textView.ViewportHeightChanged -= OnViewportChanged;
            _textView.ViewportWidthChanged -= OnViewportChanged;
            _textView.Closed -= OnClosed;

            DarkKnightSettings.SettingsChanged -= OnSettingsChanged;

            _adornmentLayer?.RemoveAllAdornments();
            _isAdornmentAdded = false;
        }
    }
}
