@tool
extends StrippedArea2D;
class_name InteractableArea;
## An area that allows the player to interact with the parent objects.
##
## ditto


enum _State {
	HIDDEN,
	IN_RANGE,
	TARGETED,
};
const _TWEEN_TIME := 0.125;


const INTERACT_HAND_MATERIAL = preload( "uid://c2ucj5tkrcvoa" );
const SPRITE: Texture2D = preload( "res://icon.svg" );


signal interacted();
func interact() -> void:
	interacted.emit();


var _state: _State = _State.HIDDEN:
	set( new ):
		_state = new;
		queue_redraw();

var _draw_rid: RID;
var _tween: Tween;
var _draw_transform: Transform2D = Transform2D.IDENTITY;
var _draw_color: Color = Color.WHEAT;


func _init() -> void:
	super();
	
	monitorable = true;
	collision_layer = Consts.CollisionLayer.INTERACTION;
	
	if ( Engine.is_editor_hint() ):
		_state = _State.IN_RANGE;

func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	Radio.interact_area_changed_range.connect( _on_radio_interact_area_changed_range, CONNECT_DEFERRED );
	Radio.interact_area_targeted.connect( _on_radio_interact_area_targeted, CONNECT_DEFERRED );
	
	#interacted.connect( print.bind( name ) );

func _enter_tree() -> void:
	_draw_rid = RenderingServer.canvas_item_create();
	RenderingServer.canvas_item_set_parent( _draw_rid, get_canvas_item() );
	var sprite_rect: Rect2 = Rect2( SPRITE.get_size() * 0.5 * -1, SPRITE.get_size() );
	RenderingServer.canvas_item_add_texture_rect( _draw_rid, sprite_rect, SPRITE.get_rid() );
	RenderingServer.canvas_item_set_material( _draw_rid, INTERACT_HAND_MATERIAL.get_rid() );

func _exit_tree() -> void:
	RenderingServer.free_rid( _draw_rid );
	_draw_rid = RID();
	
	if ( _tween and _tween.is_valid() ):
		_tween.kill();

func _process( _delta: float ) -> void:
	if ( !_draw_rid.is_valid() ): return;
	
	RenderingServer.canvas_item_set_transform( _draw_rid, _draw_transform );
	RenderingServer.canvas_item_set_modulate( _draw_rid, _draw_color )

func _draw() -> void:
	
	if ( _tween and _tween.is_valid() ):
		_tween.kill();
	_tween = create_tween();
	_tween.set_parallel();
	#_tween.set_ease( Tween.EASE_IN_OUT );
	# set based on character?
	_tween.set_trans( Tween.TRANS_SPRING );
	
	RenderingServer.canvas_item_set_visible( _draw_rid, true );
	match _state:
		
		_State.IN_RANGE:
			#RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY.scaled( Vector2.ONE * 0.5 ) );
			_tween.tween_property( self, ^"_draw_transform", Transform2D.IDENTITY.scaled( Vector2.ONE * 0.5 ), _TWEEN_TIME );
			#RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.625 ) );
			_tween.tween_property( self, ^"_draw_color", Color( 1.0, 1.0, 1.0, 0.625 ), _TWEEN_TIME );
		
		_State.TARGETED:
			#RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY );
			_tween.tween_property( self, ^"_draw_transform", Transform2D.IDENTITY, _TWEEN_TIME );
			#RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.9 ) );
			_tween.tween_property( self, ^"_draw_color", Color( 1.0, 1.0, 1.0, 0.9 ), _TWEEN_TIME );
		
		_:
			_tween.tween_property( self, ^"_draw_transform", Transform2D.IDENTITY.scaled( Vector2.ONE * 0.001 ), _TWEEN_TIME );
			_tween.tween_property( self, ^"_draw_color", Color.TRANSPARENT, _TWEEN_TIME );
			_tween.finished.connect( RenderingServer.canvas_item_set_visible.bind( _draw_rid, false ) );


func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED;


func _on_radio_interact_area_changed_range( area: InteractableArea, in_range: bool ) -> void:
	if ( area != self ): return;
	
	if ( in_range and _state == _State.HIDDEN ):
		_state = _State.IN_RANGE;
	else:
		_state = _State.HIDDEN;

func _on_radio_interact_area_targeted( area: InteractableArea ) -> void:
	if ( _state == _State.HIDDEN ):
		return;
	
	if ( area != self ):
		_state = _State.IN_RANGE;
		return;
	
	_state = _State.TARGETED;
