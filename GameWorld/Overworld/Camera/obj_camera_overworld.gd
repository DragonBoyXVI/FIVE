@tool
extends Camera2D;
class_name ObjCameraOverworld;


@onready var _state_machine: StateMachine = %StateMachine;
@onready var _overworld_camera_follow_node: OverworldCameraFollowNode = %OverworldCameraFollowNode;



func set_follow_node( node_to_follow: Node2D ) -> void:
	
	_overworld_camera_follow_node.follow_node = node_to_follow;
	_state_machine.change_state( _overworld_camera_follow_node.name );
	
	if ( node_to_follow is CollisionObject2D ):
		_become_physics.call_deferred();
	else:
		_become_nonphysics.call_deferred();


func _become_physics() -> void:
	
	process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS;
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON;
	
	_overworld_camera_follow_node.set_deferred( &"is_physics", true );

func _become_nonphysics() -> void:
	
	process_callback = Camera2D.CAMERA2D_PROCESS_IDLE;
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF;
	
	_overworld_camera_follow_node.set_deferred( &"is_physics", false );
