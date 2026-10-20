@tool
extends StrippedCharacterBody2D;
class_name ObjPlayer;


static var is_controlable: bool = true;


#@export var _state_machine: StateMachine;
@onready var generic_camera_marker: Marker2D = %GenericCameraMarker;
@onready var sprite_2d: Sprite2D = $Sprite2D;


## Movement speed in pix/sec.
@export var walking_speed: float = 1200.0;


func _init() -> void:
	super();
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING;
	collision_mask = Consts.CollisionLayer.CHARACTER_WALL;

func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	Radio.grab_camera.call_deferred( generic_camera_marker );

func _process( _delta: float ) -> void:
	generic_camera_marker.position = velocity * 0.1;


func move_in_direction( _delta: float, direction: Vector2 ) -> void:
	
	velocity = walking_speed * direction;
	move_and_slide();
	global_position = global_position.round();
