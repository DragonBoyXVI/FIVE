@tool
extends ObjRoom;


@onready var _moving_sprite: Sprite2D = %MovingSprite;
@onready var _obj_player_test: ObjPlayer = $ObjPlayerTest;


var thingy: bool = randi() % 2 == 0;


func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_echo(): return;
	
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_SPACE:
				thingy = not thingy;
				@warning_ignore("incompatible_ternary")
				Radio.grab_camera( _obj_player_test if thingy else _moving_sprite );
