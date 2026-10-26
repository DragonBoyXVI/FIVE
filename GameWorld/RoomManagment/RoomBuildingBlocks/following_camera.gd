
extends Camera2D;
class_name FollowingCamera;
## Camera that follows nodes.
##
## Set the follow node property and this will follow that node.
# self managed? room managed?


## The node this will follow.
## If null this wont do anything.
var node_to_follow: Node2D;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	Radio.grab_camera_requested.connect( _on_radio_grab_camera_requested, CONNECT_DEFERRED );

func _process( _delta: float ) -> void:
	if ( not is_instance_valid( node_to_follow ) ):
		return;
	if ( process_callback != CAMERA2D_PROCESS_IDLE ): return;
	
	#var move_delta: float = speed * delta;
	#global_position = global_position.move_toward( node_to_follow.global_position, move_delta );
	#global_position = node_to_follow.global_position;
	global_position = global_position.lerp( node_to_follow.global_position, 0.25 );

func _physics_process( _delta: float ) -> void:
	if ( not is_instance_valid( node_to_follow ) ):
		return;
	if ( process_callback != CAMERA2D_PROCESS_PHYSICS ): return;
	
	global_position = node_to_follow.global_position.round();


func _on_radio_grab_camera_requested( node: Node2D ) -> void:
	if ( !is_instance_valid( node ) ):
		node = null;
	
	if ( get_world_2d() != node.get_world_2d() ):
		return;
	
	#if ( node is CollisionObject2D ):
		#process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS;
	#else:
		#process_callback = Camera2D.CAMERA2D_PROCESS_IDLE;
	
	node_to_follow = node;
	global_position = get_screen_center_position();
