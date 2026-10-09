extends Node2D;
class_name RoomManager;
## Handles loading new rooms upon request.
##
## ditto


# order of ops
#
# cutscenes????
# game world is cutscene manager???
#
# Game world hides the screen
# Game world tells room manager to change rooms
# game world unhides room


signal room_changed( room: ObjRoom );


@export var _current_room: ObjRoom;


## used to preserve the pause state when changing rooms.
var _is_room_paused: bool = false;


## Changes the current room to the one at the file path.
func change_room( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = load( room_path );
	
	if ( _current_room ):
		_current_room.queue_free();
	_current_room = new_room_scene.instantiate();
	if ( _is_room_paused ):
		_current_room.pause.call_deferred();
	add_child( _current_room );
	
	room_changed.emit( _current_room );

## Same as normal change room, except the file is loaded on a thread.
func change_room_thread( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = await XVIFuncs.load_resource_coroutine( room_path, "PackedScene" );
	
	if ( _current_room ):
		_current_room.queue_free();
	_current_room = new_room_scene.instantiate();
	if ( _is_room_paused ):
		_current_room.pause.call_deferred();
	add_child( _current_room );
	
	room_changed.emit( _current_room );


func pause_rooms() -> void:
	
	_is_room_paused = true;
	if ( _current_room ):
		_current_room.pause.call_deferred();

func unpause_rooms() -> void:
	
	_is_room_paused = false;
	if ( _current_room ):
		_current_room.unpause.call_deferred();
