extends Control;


func _ready() -> void:
	
	Settings.settings_updated.connect( _on_settings_updated, CONNECT_DEFERRED );
	_on_settings_updated( Settings.get_current_settings() );


func _on_settings_updated( settings: SettingsData ) -> void:
	if ( settings.is_green ):
		modulate = Color.GREEN;
	else:
		modulate = Color.WHITE;
