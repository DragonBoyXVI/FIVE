@tool
extends Sprite2D;
class_name DebugMovingSprite;


@export var _move_dist: float = 256.0:
	set( new ):
		_move_dist = maxf( 1.0, new );
		queue_redraw();
@export var _is_physics: bool = false;
@export var _time_scale: float = 1.0:
	set( new ):
		_time_scale = maxf( 0.01, new );


var _initial_pos: Vector2 = Vector2.ZERO;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	_initial_pos = position;

func _process(delta: float) -> void:
	if ( !_is_physics ): _position( delta );

func _physics_process(delta: float) -> void:
	if ( _is_physics ): _position( delta );

func _draw() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		draw_circle( Vector2.ZERO, _move_dist, Color.RED, false );
		return;

var _internal_time: float = 0.0;
func _position( delta: float ) -> void:
	_internal_time += delta * _time_scale;
	
	position = _initial_pos + ( _move_dist * Vector2( sin( _internal_time ), cos( _internal_time) ) );
	#position = position.round();
