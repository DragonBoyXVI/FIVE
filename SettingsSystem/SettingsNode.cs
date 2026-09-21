using DragonXVI.XVIGodot;
using Godot;

namespace DragonXVI.FIVE.SettingsSystem;

/// <summary>
/// An autoload node that handles saving/loading and holding settings data.
/// </summary>
[Tool]
public partial class SettingsNode : Node, IAutoload<SettingsNode>
{
    private const string DefaultSettingsFilePath = "res://SettingsSystem/default_settings.json";
    private const string SaveSettingsFilePath = "user://settings.json";
    
    public static SettingsNode Instance => (instance is null) ? throw new System.Exception("Null autoload") : instance;
    private static SettingsNode? instance;
    
    public override void _EnterTree()
    {
        instance = this;
    }
    
    #region Setting Properties
    
    public bool IsGameWindowIntScaled = false;
    public uint GameWindowIntScalingFactor = 0;
    
    #endregion Setting Properties
}
