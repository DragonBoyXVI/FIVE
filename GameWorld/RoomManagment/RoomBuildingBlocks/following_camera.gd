
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


func _process( delta: float ) -> void:
	if ( not is_instance_valid( node_to_follow ) ):
		return;
	
	var move_delta: float = speed * delta;
	global_position = global_position.move_toward( node_to_follow.global_position, move_delta );
