@tool
extends OverworldMovingCharacterState;
class_name PlayerStateFree;


@export var _camera_focus: Node2D;


func _enter_state() -> void:
	Radio.grab_camera( _camera_focus );

func _leave_state() -> void:
	_camera_focus.position = Vector2.ZERO;

func _process( _delta: float ) -> void:
	_camera_focus.position = _character.velocity * 0.1;

func _physics_process( delta: float ) -> void:
	
	var input_vector: Vector2 = InputNames.Move.get_vector();
	_character.routine_move_in_direction( delta, input_vector );
