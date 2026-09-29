extends Control;


@onready var _sub_viewport_container: SubViewportContainer = $AspectRatioContainer/SubViewportContainer


var _is_window_custom_scaled: bool = false;
var _custom_window_scaling_factor: float = 1.0;
var _fullscreen_mode := SettingsData.FullscreenSetting.WINDOWED;


func _ready() -> void:
	
	get_window().size_changed.connect( _on_window_size_changed, CONNECT_DEFERRED );
	
	Settings.settings_updated.connect( _on_settings_updated, CONNECT_DEFERRED );
	_on_settings_updated( Settings.get_current_settings() );


func _set_window_scaling() -> void:
	
	if ( not _is_window_custom_scaled ):
		
		_sub_viewport_container.size_flags_horizontal = Control.SIZE_FILL;
		_sub_viewport_container.size_flags_vertical = Control.SIZE_FILL;
		custom_minimum_size = Vector2.ZERO;
		return;
	
	_sub_viewport_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER;
	_sub_viewport_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER;
	_sub_viewport_container.custom_minimum_size = Consts.SCREEN_SIZE * _custom_window_scaling_factor;

func _set_fullscreen() -> void:
	var window := get_window();
	var mode := Window.MODE_WINDOWED;
	
	match _fullscreen_mode:
		SettingsData.FullscreenSetting.WINDOWED:
			mode = Window.MODE_WINDOWED;
		SettingsData.FullscreenSetting.FULLSCREEN:
			mode = Window.MODE_FULLSCREEN;
		SettingsData.FullscreenSetting.EXCLUSIVE_FULLSCREEN:
			mode = Window.MODE_EXCLUSIVE_FULLSCREEN;
	
	window.mode = mode;


func _on_window_size_changed() -> void:
	_set_window_scaling();

func _on_settings_updated( settings: SettingsData ) -> void:
	
	if ( settings.is_window_custom_scaled != _is_window_custom_scaled or settings.custom_window_scaling_factor != _custom_window_scaling_factor ):
		_is_window_custom_scaled = settings.is_window_custom_scaled;
		_custom_window_scaling_factor = settings.custom_window_scaling_factor;
		_set_window_scaling();
	
	if ( settings.fullscreen_mode != _fullscreen_mode ):
		_fullscreen_mode = settings.fullscreen_mode;
		_set_fullscreen();
