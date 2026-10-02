@tool
extends Resource;
class_name SettingsData;
## Blob of data kepy by the settings node.
##
## Saving and loading externally is done using json.


## Test, turns the game green.
#@export var is_green: bool = false;


#region Game Window

## If true, the window is scaled by a user set factor.
@export var is_window_custom_scaled: bool = false;
## If custom scaling is enabled, this is the scaling factor.
@export var custom_window_scaling_factor: float = 1.0:
	set( new ):
		custom_window_scaling_factor = maxf( 0.5, new );

## Enum for fullscreen settings.
enum FullscreenSetting {
	## Game is windowed.
	WINDOWED,
	## Game is in windowed fullscreen.
	FULLSCREEN,
	## Game is in exclusive fullscreen.
	EXCLUSIVE_FULLSCREEN,
}
## Changes what window setting the game uses.
## Windowed - Game is a standard monitor window.
## Fullscreen - Game is window fullscreened.
## Exclusive Fullscreen - Game is exclusive fullscreened.
@export var fullscreen_mode: FullscreenSetting = FullscreenSetting.WINDOWED;

#endregion Game Window
