using System;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;

namespace DarkKnightTheme.Settings
{
    [DataContract]
    public class DarkKnightSettings
    {
        private static readonly string SettingsDirectory = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "Microsoft", "VisualStudio", "DarkKnight");

        private static readonly string SettingsFilePath = Path.Combine(SettingsDirectory, "settings.json");

        private static DarkKnightSettings _instance;
        private static readonly object _syncLock = new object();

        public static event EventHandler SettingsChanged;

        [DataMember]
        public bool IsEnabled { get; set; } = false;

        [DataMember]
        public string SelectedPreset { get; set; } = "BatcaveMainframe";

        [DataMember]
        public string CustomImagePath { get; set; } = string.Empty;

        [DataMember]
        public double Opacity { get; set; } = 0.08; // Default subtle opacity (8%) for high readability

        [DataMember]
        public double OverlayOpacity { get; set; } = 0.70; // 70% dark translucent overlay tint

        [DataMember]
        public string Position { get; set; } = "BottomRight"; // BottomRight, Center, UniformToFill, TopRight

        public static DarkKnightSettings Instance
        {
            get
            {
                if (_instance == null)
                {
                    lock (_syncLock)
                    {
                        if (_instance == null)
                        {
                            _instance = LoadInternal();
                        }
                    }
                }
                return _instance;
            }
        }

        public static DarkKnightSettings LoadInternal()
        {
            try
            {
                if (File.Exists(SettingsFilePath))
                {
                    using (var stream = File.OpenRead(SettingsFilePath))
                    {
                        var serializer = new DataContractJsonSerializer(typeof(DarkKnightSettings));
                        var settings = (DarkKnightSettings)serializer.ReadObject(stream);
                        if (settings != null)
                        {
                            settings.ValidateAndClamp();
                            return settings;
                        }
                    }
                }
            }
            catch
            {
                // Fallback to defaults on corrupt or locked file
            }

            var defaultSettings = new DarkKnightSettings();
            defaultSettings.ValidateAndClamp();
            return defaultSettings;
        }

        public void Save()
        {
            try
            {
                ValidateAndClamp();
                if (!Directory.Exists(SettingsDirectory))
                {
                    Directory.CreateDirectory(SettingsDirectory);
                }

                using (var stream = File.Create(SettingsFilePath))
                {
                    var serializer = new DataContractJsonSerializer(typeof(DarkKnightSettings));
                    serializer.WriteObject(stream, this);
                }
            }
            catch
            {
                // Silent catch during IDE shutdown or read-only settings directory
            }

            NotifySettingsChanged();
        }

        public void ResetToDefaults()
        {
            IsEnabled = false;
            SelectedPreset = "BatcaveMainframe";
            CustomImagePath = string.Empty;
            Opacity = 0.08;
            OverlayOpacity = 0.70;
            Position = "BottomRight";

            Save();
        }

        public void NotifySettingsChanged()
        {
            SettingsChanged?.Invoke(this, EventArgs.Empty);
        }

        public void ValidateAndClamp()
        {
            if (Opacity < 0.01) Opacity = 0.01;
            if (Opacity > 0.60) Opacity = 0.60;

            if (OverlayOpacity < 0.0) OverlayOpacity = 0.0;
            if (OverlayOpacity > 0.95) OverlayOpacity = 0.95;

            if (string.IsNullOrEmpty(Position)) Position = "BottomRight";
            if (string.IsNullOrEmpty(SelectedPreset)) SelectedPreset = "BatcaveMainframe";
        }
    }
}
