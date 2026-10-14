@tool
extends Camera2D;
class_name ObjCameraOverworld;


@onready var _state_machine: StateMachine = %StateMachine;
@onready var _overworld_camera_follow_node: OverworldCameraFollowNode = %OverworldCameraFollowNode;



func set_follow_node( node_to_follow: Node2D ) -> void:
	
	_overworld_camera_follow_node.follow_node = node_to_follow;
	_state_machine.change_state( _overworld_camera_follow_node.name );
