@tool
extends Resource;
class_name SettingsData;
## Blob of data kepy by the settings node.
##
## Saving and loading externally is done using json.


## Test, turns the game green.
@export var is_green: bool = false;


## Values not allowed to be read from/written to json files.
const BLACK_LIST: PackedStringArray = [
		"resource_local_to_scene",
		"resource_local_to_scene",
		"resource_name",
		"script",
	];

## Takes a json string and returns a new instance of this, filling out values with those described in the json.
static func from_json_string( json_string: String ) -> SettingsData:
	var ns := SettingsData.new();
	var property_dict: Dictionary = {};
	
	var json_parsed_data: Variant = JSON.parse_string( json_string );
	if ( json_parsed_data == null ):
		push_error( "SettingsData: JSON string not parsable!" );
		return null;
	if ( typeof( json_parsed_data ) != TYPE_DICTIONARY ):
		push_error( "SettingsData: JSON is not of correct type!" );
		return null;
	property_dict = Dictionary( json_parsed_data );
	
	for key: Variant in property_dict:
		
		var key_type : int = typeof( key );
		if ( key_type != TYPE_STRING and key_type != TYPE_STRING_NAME ):
			continue;
		
		ns.set( key, property_dict[ key ] );
	
	return ns;

## Turns this into a json string, ready to be stored externally.
func as_json_string() -> String:
	
	var json_dict : Dictionary[ String, Variant ] = {};
	
	var property_list := get_property_list();
	for property in property_list:
		var property_name : String = property[ Property.NAME ];
		
		if ( property_name in BLACK_LIST ):
			continue;
		
		if ( property_name.begins_with( "metadata" ) ):
			continue;
		
		if ( not property[ Property.USAGE ] & PROPERTY_USAGE_STORAGE ):
			continue;
		
		var prop_value: Variant = get( property_name );
		if ( prop_value == null ):
			continue;
		json_dict[ property_name ] = prop_value;
	
	return JSON.stringify( json_dict, "\t" );
