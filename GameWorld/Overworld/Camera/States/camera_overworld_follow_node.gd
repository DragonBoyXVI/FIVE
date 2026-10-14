@tool
extends OverworldCameraState;
class_name OverworldCameraFollowNode;
## State that makes the camera follow a specific node in the tree.
##
## Ditto


## Node this wants the camera to follow.
var follow_node: Node2D;

var is_physics: bool = false;

## Speed in pix/sec
@export var speed: float = 1200.0;


func _process( delta: float ) -> void:
	if ( not is_physics ):
		print( "proc" );
		_do_follow_step( delta );

# to kill jitter when following a physics object, we have to move in the physics step
func _physics_process( delta: float ) -> void:
	if ( is_physics ):
		print( "phys" );
		_do_follow_step( delta );


func _do_follow_step( delta: float ) -> void:
	if ( not is_instance_valid( follow_node ) ):
		return;
	
	var pos_delta: float = speed * delta;
	_camera.global_position = _camera.global_position.move_toward( follow_node.global_position.round(), pos_delta );
