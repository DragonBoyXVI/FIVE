@tool
extends StrippedCharacterBody2D;
class_name ObjPlayer;


#@export var _state_machine: StateMachine;


## Movement speed in pix/sec.
@export var walking_speed: float = 1200.0;


func _init() -> void:
	super();
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING;
	collision_mask = Consts.CollisionLayer.CHARACTER_WALL;


func move_in_direction( _delta: float, direction: Vector2 ) -> void:
	
	velocity = walking_speed * direction;
	move_and_slide();
