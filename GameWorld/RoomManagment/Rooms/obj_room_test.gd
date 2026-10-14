@tool
extends ObjRoom;


@onready var _moving_sprite: Sprite2D = %MovingSprite;
@onready var _obj_player_test: ObjPlayer = $ObjPlayerTest;


var thingy: bool = randi() % 2 == 0;


func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	@warning_ignore("incompatible_ternary")
	$ObjCameraOverworld.set_follow_node( _moving_sprite if thingy else _obj_player_test );

func _process( _delta: float ) -> void:
	
	const MOV := Consts.SCREEN_SIZE.x * 0.5;
	_moving_sprite.position.x = MOV + ( sin( Time.get_ticks_msec() / 1_000.0 ) * MOV );

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_echo(): return;
	
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_SPACE:
				thingy = not thingy;
				
				@warning_ignore("incompatible_ternary")
				$ObjCameraOverworld.set_follow_node( _moving_sprite if thingy else _obj_player_test );
