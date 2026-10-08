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


var _current_room: ObjRoom;


## Changes the current room to the one at the file path.
func change_room( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = load( room_path );
	
	if ( _current_room ):
		_current_room.queue_free();
	_current_room = new_room_scene.instantiate();
	add_child( _current_room );
	
	room_changed.emit( _current_room );

## Same as normal change room, except the file is loaded on a thread.
func change_room_thread( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = await XVIFuncs.load_resource_coroutine( room_path, "PackedScene" );
	
	if ( _current_room ):
		_current_room.queue_free();
	_current_room = new_room_scene.instantiate();
	add_child( _current_room );
	
	room_changed.emit( _current_room );
