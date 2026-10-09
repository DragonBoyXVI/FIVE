extends Node;

#region Game World Commands

## request_overworld_room_change
signal game_world_change_ow_room_requested( room_path: String );
## Tells the game world to change the overworld room.[br]
## [br]
## room_path: [String] - path to the scene file to change to.[br]
func request_overworld_room_change( room_path: String ) -> void:
	game_world_change_ow_room_requested.emit( room_path );

#endregion Game World Commands
