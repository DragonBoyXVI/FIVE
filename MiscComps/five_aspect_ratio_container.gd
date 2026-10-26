@tool
extends AspectRatioContainer;
class_name FiveAspectRatioContainer;


func _init() -> void:
	
	ratio = Consts.SCREEN_SIZE.aspect();

func _validate_property( property: Dictionary ) -> void:
	const DISABLED: PackedStringArray = [
		"ratio"
	];
	
	if ( property[ Property.NAME ] in DISABLED ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;
