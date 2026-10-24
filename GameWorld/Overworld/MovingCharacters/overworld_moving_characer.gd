@tool
extends StrippedCharacterBody2D;
class_name OverworldMovingCharacter;
## Base for any object that needs to move like a character in the overworld.
##
## gwuh


@export_group( "Movement" )
## Top speed this moves at.
@export_range( 100.0, 2000.0, 1.0, "or_greater" ) var _movement_speed: float = 500.0;
## How quickly this gains speed.
@export_range( 100.0, 5000.0, 1.0, "or_greater" ) var _acceleration: float = 2000.0;
## How quickly this loses speed.
@export_range( 100.0, 5000.0, 1.0, "or_greater" ) var _deceleration: float = 2500.0;


func _init() -> void:
	super();
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING;
	collision_mask = Consts.CollisionLayer.CHARACTER_WALL;


func routine_move_in_direction( delta: float, direction_vector: Vector2 ) -> void:
	
	var is_stopping: bool = direction_vector.is_zero_approx();
	if ( !is_stopping ):
		const STOPPING_POINT := PI * 0.5;
		is_stopping = velocity.angle_to( direction_vector ) > STOPPING_POINT;
	
	if ( is_stopping ):
		
		var stopping_delta: float = delta * _deceleration;
		velocity = velocity.move_toward( Vector2.ZERO, stopping_delta );
	else:
		
		var moving_delta: float = delta * _acceleration;
		var moving_target: Vector2 = direction_vector * _movement_speed;
		velocity = velocity.move_toward( moving_target, moving_delta );
	
	move_and_slide();
