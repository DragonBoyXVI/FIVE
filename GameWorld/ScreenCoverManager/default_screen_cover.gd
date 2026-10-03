@tool
extends ObjScreenCover;


func _randomize_speed() -> void:
	_animation_player.speed_scale = randfn( 1.2, 0.1 );
