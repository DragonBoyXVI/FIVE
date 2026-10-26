@tool
extends SubViewport;
class_name FiveSubViewport;


func _init() -> void:
	
	size_2d_override = Consts.SCREEN_SIZE;
	size_2d_override_stretch = true;

func _validate_property( property: Dictionary ) -> void:
	const DISABLED: PackedStringArray = [
		"size",
		"size_2d_override",
		"size_2d_override_stretch",
	];
	
	if ( property[ Property.NAME ] in DISABLED ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;
