
extends Camera2D;
class_name FollowingCamera;
## Camera that follows nodes.
##
## Set the follow node property and this will follow that node.
# self managed? room managed?


## The node this will follow.
## If null this wont do anything.
var node_to_follow: Node2D;


@export var speed: float = 1200.0;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	Radio.grab_camera_requested.connect( _on_radio_grab_camera_requested, CONNECT_DEFERRED );

func _process( delta: float ) -> void:
	if ( not is_instance_valid( node_to_follow ) ):
		return;
	
	var move_delta: float = speed * delta;
	global_position = global_position.move_toward( node_to_follow.global_position, move_delta );


func _on_radio_grab_camera_requested( node: Node2D ) -> void:
	if ( get_world_2d() != node.get_world_2d() ):
		return;
	
	node_to_follow = node;
