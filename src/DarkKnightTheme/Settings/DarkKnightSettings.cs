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
        public double Opacity { get; set; } = 0.40; // Default visible watermark opacity (40%)

        [DataMember]
        public double OverlayOpacity { get; set; } = 0.0; // 0% dark overlay by default to avoid obscuring artwork

        [DataMember]
        public string Position { get; set; } = "Center"; // Center, BottomRight, UniformToFill, TopRight

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
            Opacity = 0.40;
            OverlayOpacity = 0.0;
            Position = "Center";

            Save();
        }

        public void NotifySettingsChanged()
        {
            SettingsChanged?.Invoke(this, EventArgs.Empty);
        }

        public void ValidateAndClamp()
        {
            // Auto-heal any legacy or invalid <5% invisible opacity to 40%
            if (Opacity < 0.05) Opacity = 0.40;
            if (Opacity > 1.0) Opacity = 1.0;

            if (OverlayOpacity < 0.0) OverlayOpacity = 0.0;
            if (OverlayOpacity > 0.90) OverlayOpacity = 0.90;

            if (string.IsNullOrEmpty(Position)) Position = "Center";
            if (string.IsNullOrEmpty(SelectedPreset)) SelectedPreset = "BatcaveMainframe";
        }
    }
}
