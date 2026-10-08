@tool
extends PlayerState;
class_name PlayerFree;
## Player is idle/not doing anything specific.
##
## Default state


func _physics_process( delta: float ) -> void:
	
	if ( not ObjPlayer.is_controlable ):
		return;
	
	var input_vector := InputNames.Move.get_vector();
	_player.move_in_direction( delta, input_vector );
