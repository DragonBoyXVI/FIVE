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
const _TWEEN_TIME := 0.125 * 2;


const INTERACT_HAND_MATERIAL = preload( "uid://c2ucj5tkrcvoa" );
const SPRITE: Texture2D = preload( "uid://b2sjh4tricp6" );


signal interacted();
func interact() -> void:
	interacted.emit();


var _state: _State = _State.HIDDEN:
	set( new ):
		_state = new;
		queue_redraw();

# i wanna use draw rid to reduce node count, but it would take more more to do that with atlases than just using a node
var _sprite: Sprite2D;
var _tween: Tween;


func _init() -> void:
	super();
	
	monitorable = true;
	collision_layer = Consts.CollisionLayer.INTERACTION;

func _ready() -> void:
	super();
	
	if ( not _sprite ):
		_sprite = Sprite2D.new();
		_sprite.texture = SPRITE;
		_sprite.material = INTERACT_HAND_MATERIAL;
		add_child( _sprite, false, Node.INTERNAL_MODE_BACK );
	
	if ( Engine.is_editor_hint() ):
		_state = _State.IN_RANGE;
		return;
	
	Radio.interact_area_changed_range.connect( _on_radio_interact_area_changed_range, CONNECT_DEFERRED );
	Radio.interact_area_targeted.connect( _on_radio_interact_area_targeted, CONNECT_DEFERRED );
	
	#interacted.connect( print.bind( name ) );

func _draw() -> void:
	
	if ( _tween and _tween.is_valid() ):
		_tween.kill();
	_tween = create_tween();
	_tween.set_parallel();
	#_tween.set_ease( Tween.EASE_IN_OUT );
	# set based on character?
	_tween.set_trans( Tween.TRANS_SPRING );
	
	_sprite.show();
	match _state:
		
		_State.IN_RANGE:
			#RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY.scaled( Vector2.ONE * 0.5 ) );
			_tween.tween_property( _sprite, ^"scale", Vector2.ONE * 0.5, _TWEEN_TIME );
			#RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.625 ) );
			_tween.tween_property( _sprite, ^"modulate", Color( 1.0, 1.0, 1.0, 0.625 ), _TWEEN_TIME );
		
		_State.TARGETED:
			#RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY );
			_tween.tween_property( _sprite, ^"scale", Vector2.ONE, _TWEEN_TIME );
			#RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.9 ) );
			_tween.tween_property( _sprite, ^"modulate", Color( 1.0, 1.0, 1.0, 0.9 ), _TWEEN_TIME );
		
		_:
			_tween.tween_property( _sprite, ^"scale", Vector2.ONE * 0.001, _TWEEN_TIME );
			_tween.tween_property( _sprite, ^"modulate", Color.TRANSPARENT, _TWEEN_TIME );
			_tween.finished.connect( _sprite.hide );


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
