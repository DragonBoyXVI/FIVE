using Godot;

namespace DragonXVI.FIVE.SettingsSystem;

/// <summary>
/// Blob of data that represents user settings.
/// </summary>
[Tool, GlobalClass]
public partial class SettingsData : Resource
{
    /// <summary>
    /// If true, the internal game window is only scaled by integer amounts.
    /// </summary>
    [Export]
    public bool IsGameWindowIntScaled = false;
    /// <summary>
    /// If "IsGameWindowIntScaled" is true, this is the scaling factor.
    /// Set to 0 for automatic scaling.
    /// </summary>
    [Export]
    public uint GameWindowIntScalingFactor = 0;

}