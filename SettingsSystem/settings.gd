extends Node;


const DEFAULT_SETTINGS_PATH: String = "uid://b1io746fysx3c";
const EXTERNAL_SAVE_PATH := "user://settings.json";


## Emitted when settings are changed.
signal settings_updated( settings: SettingsData );


var _current_settings: SettingsData;
func get_current_settings() -> SettingsData:
	return _current_settings;


func _ready() -> void:
	
	if ( FileAccess.file_exists( EXTERNAL_SAVE_PATH ) ):
		load_settings_from_file();
	else:
		_current_settings = load( DEFAULT_SETTINGS_PATH );

func _exit_tree() -> void:
	save_settings_to_file();


## Saves the current settings to an external file.
func save_settings_to_file() -> void:
	
	var settings_json_string: String = _current_settings.as_json_string();
	var file := FileAccess.open( EXTERNAL_SAVE_PATH, FileAccess.WRITE );
	if ( file == null ):
		push_error( "SettingsNode: File open error - %s" % FileAccess.get_open_error() );
		return;
	
	file.store_line( settings_json_string );
	file.close();

## Loads settings saved to an external file.
## If the file isnt found, this does nothing.
func load_settings_from_file() -> void:
	if ( not FileAccess.file_exists( EXTERNAL_SAVE_PATH ) ):
		return;
	
	var file := FileAccess.open( EXTERNAL_SAVE_PATH, FileAccess.READ );
	if ( file == null ):
		push_error( "SettingsNode: File open error - %s" % FileAccess.get_open_error() );
		return;
	
	var file_text := file.get_as_text();
	file.close();
	
	var new_settings := SettingsData.from_json_string( file_text );
	if ( new_settings != null ):
		_current_settings = new_settings;
		settings_updated.emit( new_settings );
