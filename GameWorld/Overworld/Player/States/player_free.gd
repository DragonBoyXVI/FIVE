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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if ( event.pressed ):
			if event.keycode == KEY_SPACE:
				Radio.request_overworld_room_change( "uid://cp4kb0quo3vol" );
