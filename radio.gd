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

#region Camera

## grab_camera
signal grab_camera_requested( node: Node2D );
## Tells a camera to follow the provided node.
## Depends on how the reciving cameras are set up, but ideally a camera should only be able to follow a node in its world.[br]
## [br]
## node: [Node2D] - The node for the camera to follow.[br]
func grab_camera( node: Node2D ) -> void:
	grab_camera_requested.emit( node );

#endregion Camera
