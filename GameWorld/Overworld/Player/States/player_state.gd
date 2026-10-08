@tool
@abstract
extends State;
class_name PlayerState;
## Base class for states that run the player object(s).
##
## Ditto


## Refrence to the player in question.
@export var _player: ObjPlayer:
	set( new ):
		_player = new;
		update_configuration_warnings();


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _player ):
		warnings.append( "No player provided!" );
	
	return warnings;
