@tool
@abstract
extends XVIFuncs;
class_name Utils;


#TODO: Error logging utils

#region JSON

##TODO: add these to dragonxvi godot.

const _DEFAULT_PROPERTY_BLACKLIST: PackedStringArray = [
	"script",
	"resource_local_to_scene",
	"resource_path",
	"resource_name",
];
## Turns a [Resource] into a [JSON] string, ready to be stored externally.[br]
## resource: [Resource] - The resource to convert.[br]
## include_metadata: [bool] - If true, object metadata is included. This included custom script uids.[br]
## blacklist: [PackedStringArray] - Specific properties to be ignored. By default this included the script and all "resource_*" properties.
static func resource_to_json( resource: Resource, include_metadata: bool = false, blacklist: PackedStringArray = _DEFAULT_PROPERTY_BLACKLIST ) -> String:
	
	var json_dict : Dictionary[ String, Variant ] = {};
	
	var property_list := resource.get_property_list();
	for property in property_list:
		var property_name : String = property[ Property.NAME ];
		
		if ( property_name in blacklist ):
			continue;
		
		if ( property_name.begins_with( "metadata" ) ):
			if ( !include_metadata ):
				continue;
		
		if ( not property[ Property.USAGE ] & PROPERTY_USAGE_STORAGE ):
			continue;
		
		var prop_value: Variant = resource.get( property_name );
		if ( prop_value == null ):
			continue;
		json_dict[ property_name ] = prop_value;
	
	return JSON.stringify( json_dict, "\t" );

## Takes a [JSON] string and fills out the provided [Resource].[br]
## This doesnt check for values defined in the json not existing in the resource,
## if that happens, theyre parsed but ignored, unless Godot changes how "set" works.[br]
##NOTE: This returns the same resource you put in, it doesnt duplicate it.[br]
## resource: [Resource] - The resource to get filled out.[br]
## json_string: [String] - The json string to parse.[br]
static func fill_resource_from_json( resource: Resource, json_string: String ) -> Resource:
	
	var property_dict: Dictionary = {};
	
	var json_parsed_data: Variant = JSON.parse_string( json_string );
	if ( json_parsed_data == null ):
		push_error( "XVIFuncs: JSON string not parsable!" );
		return null;
	if ( typeof( json_parsed_data ) != TYPE_DICTIONARY ):
		push_error( "XVIFuncs: JSON is not of correct type! Expected string got %s" % type_string( typeof( json_parsed_data ) ) );
		return null;
	property_dict = Dictionary( json_parsed_data );
	
	for key: Variant in property_dict:
		
		var key_type : int = typeof( key );
		if ( key_type != TYPE_STRING and key_type != TYPE_STRING_NAME ):
			continue;
		
		resource.set( key, property_dict[ key ] );
	
	return resource;

#endregion JSON
