using System.Text.Json;
using DragonXVI.XVIGodot;
using Godot;

namespace DragonXVI.FIVE.SettingsSystem;

/// <summary>
/// An autoload node that handles saving/loading and holding settings data.
/// </summary>
[Tool]
public partial class SettingsNode : Node, IAutoload<SettingsNode>
{
    private const string SaveSettingsFilePath = "user://settings.json";
    
    public static SettingsNode Instance => instance;
    private static SettingsNode instance;
    
    [Signal]
    public delegate void SettingsChangedEventHandler( SettingsData settingsData );
    private void EmitSettingsChanged()
    {
        EmitSignal( SignalName.SettingsChanged, CurrentData );
    }
    
    public SettingsData CurrentData = GD.Load<SettingsData>( "res://SettingsSystem/default_settings.tres" );
    
    public override void _EnterTree()
    {
        instance = this;
    }
    
    /// <summary>
    /// Loads settings from a json file.
    /// </summary>
    /// <param name="filePath">Path to the file to load.</param>
    /// <returns>True if successful.</returns>
    public void LoadSettings( string filePath = SaveSettingsFilePath )
    {
        if ( !FileAccess.FileExists( filePath ) )
        {
            GD.PushWarning( $"Attempted to read non existant file ${filePath}" );
            return;
        }
        
        FileAccess file = FileAccess.Open( filePath, FileAccess.ModeFlags.Read );
        string fileText = file.GetAsText();
        file.Close();
        file.Dispose();
        
        SettingsData loadedSettings = JsonSerializer.Deserialize<SettingsData>( fileText );
        if ( loadedSettings is null )
        {
            GD.PushError( $"Settings loaded but could not be parsed: {filePath}" );
            return;
        }
        
        CurrentData = loadedSettings;
        EmitSettingsChanged();
        
        return;
    }
    /// <summary>
    /// Saves the current settings to a file location.
    /// </summary>
    /// <param name="filePath">Path to the file location.</param>
    public void SaveSettings( string filePath = SaveSettingsFilePath )
    {
        FileAccess file = FileAccess.Open( filePath, FileAccess.ModeFlags.Write );
        
        string jsonString = JsonSerializer.Serialize( CurrentData );
        file.StoreString( jsonString );
        
        file.Close();
        file.Dispose();
    }
}
