@tool
@abstract
extends State;
class_name OverworldCameraState;
## Base state class for the overworld camera.
##
## ditto


@export var _camera: ObjCameraOverworld:
	set( new ):
		_camera = new;
		update_configuration_warnings();


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _camera ):
		warnings.append( "Please set the camera and any other parameters for this state!" );
	
	return warnings;
