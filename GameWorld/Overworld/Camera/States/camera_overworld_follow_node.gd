@tool
extends OverworldCameraState;
class_name OverworldCameraFollowNode;
## State that makes the camera follow a specific node in the tree.
##
## Ditto


## Node this wants the camera to follow.
var follow_node: Node2D;

## Speed in pix/sec
@export var speed: float = 1200.0;


func _process( delta: float ) -> void:
	if ( not is_instance_valid( follow_node ) ):
		return;
	
	var pos_delta: float = speed * delta;
	_camera.global_position = _camera.global_position.move_toward( follow_node.global_position, pos_delta );
