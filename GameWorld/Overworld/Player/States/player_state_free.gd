@tool
extends OverworldMovingCharacterState;
class_name PlayerStateFree;


@export var _camera_focus: Node2D;
@export var _interactor: InteractionArea;


func _enter_state() -> void:
	Radio.grab_camera( _camera_focus );

func _leave_state() -> void:
	_camera_focus.position = Vector2.ZERO;

func _process( _delta: float ) -> void:
	_camera_focus.position = _character.velocity * 0.1;

func _physics_process( delta: float ) -> void:
	
	var input_vector: Vector2 = InputNames.Move.get_vector();
	_character.routine_move_in_direction( delta, input_vector );

func _unhandled_input( event: InputEvent ) -> void:
	
	if ( event.is_echo() ):
		return;
	
	if ( event.is_action_pressed( InputNames.ACCEPT ) ):
		
		var interactable: InteractableArea = _interactor.get_targeted_interact_area();
		if ( interactable ):
			interactable.interact();
		
		get_window().set_input_as_handled();
		return;
	
	if ( event.is_action_pressed( InputNames.Shoulder.LEFT ) ):
		
		_interactor.tick_target_index( -1 );
		
		get_window().set_input_as_handled();
		return;
	
	if ( event.is_action_pressed( InputNames.Shoulder.RIGHT ) ):
		
		_interactor.tick_target_index( 1 );
		
		get_window().set_input_as_handled();
		return;
