@tool
extends State;
class_name OverworldMovingCharacterState;
## Base class for states that run overworld characters.
##
## Ditto


## Refrence to the player in question.
@export var _character: OverworldMovingCharacter:
	set( new ):
		_character = new;
		update_configuration_warnings();


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _character ):
		warnings.append( "No character provided!" );
	
	return warnings;
