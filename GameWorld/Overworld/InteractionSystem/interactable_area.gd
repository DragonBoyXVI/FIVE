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

func _draw() -> void:
	
	RenderingServer.canvas_item_set_visible( _draw_rid, true );
	match _state:
		
		_State.IN_RANGE:
			RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY.scaled( Vector2.ONE * 0.5 ) );
			RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.625 ) );
		
		_State.TARGETED:
			RenderingServer.canvas_item_set_transform( _draw_rid, Transform2D.IDENTITY );
			RenderingServer.canvas_item_set_modulate( _draw_rid, Color( 1.0, 1.0, 1.0, 0.9 ) );
		
		_:
			RenderingServer.canvas_item_set_visible( _draw_rid, false );


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
