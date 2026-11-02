@tool
extends Node;
class_name PlayerPlacer;


## Disabled this without needing to remove the node.
@export var _disabled: bool = false;
## Location where the player is placed is no good spot is defined.
## If not set the player is placed at global_position 0, 0.
@export var _failsafe_location: Node2D;

# pick a player scene based on gamestate
var _player_scene: PackedScene = preload( "res://GameWorld/Overworld/Player/obj_player.tscn" );


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return;
	
	if ( _disabled ):
		return;
	
	var parent: Node = get_parent();
	if ( not parent.is_node_ready() ):
		await parent.ready;
	
	_place_player();

func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_PARENTED ):
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( get_parent() is not ObjRoom ):
		warnings.append( "This is intended to be used for rooms. This may not work as expected outside of a room." );
	
	return warnings;


func _place_player() -> void:
	
	var room: ObjRoom = get_parent();
	assert( _player_scene.can_instantiate() );
	var player: OverworldMovingCharacter = _player_scene.instantiate();
	
	room.add_child( player );
	if ( _failsafe_location ):
		player.global_position = _failsafe_location.global_position;
	else:
		player.global_position = Vector2.ZERO;
	player.reset_physics_interpolation();
	
	pass;
