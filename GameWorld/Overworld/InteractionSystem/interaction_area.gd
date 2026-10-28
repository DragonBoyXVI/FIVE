@tool
extends StrippedArea2D;
class_name InteractionArea;
## Allows the parent node to detect interaction spots and interact with them.
##
## Tracks what areas are in range.[br]
## Notifies them if they are in/out of range.[br]
## notifies them if they are/arent the current interaction target.


var _interact_areas_in_range: Array[ InteractableArea ] = [];
var _target_index: int = -1;


func _init() -> void:
	super();
	
	monitoring = true;
	collision_mask = Consts.CollisionLayer.INTERACTION;

func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	area_entered.connect( _on_area_entered );
	area_exited.connect( _on_area_exited );


func add_interact_area( area: InteractableArea ) -> void:
	
	_interact_areas_in_range.append( area );
	Radio.notify_interact_area_changed_range( area, true );
	
	if ( _target_index == -1 ):
		tick_target_index( 1 );

func remove_interact_area( area: InteractableArea ) -> void:
	
	var current_area_target: InteractableArea = _interact_areas_in_range[ _target_index ];
	if ( current_area_target == area ):
		current_area_target = null;
	
	_interact_areas_in_range.erase( area );
	Radio.notify_interact_area_changed_range( area, false );
	
	# this just makes it so that passing an area doesnt change the interact target if the target never
	# leaves interaction range
	if ( current_area_target ):
		var target_index: int = _interact_areas_in_range.find( current_area_target );
		var tick_amount: int = target_index - _target_index;
		if ( tick_amount != 0 ):
			tick_target_index( target_index - _target_index );
	else:
		tick_target_index( -1 );

func tick_target_index( amt: int ) -> void:
	
	if ( _interact_areas_in_range.is_empty() ):
		_target_index = -1;
		Radio.notify_interact_area_targeted( null );
		return;
	
	_target_index = wrapi( _target_index + amt, 0, _interact_areas_in_range.size() );
	Radio.notify_interact_area_targeted( _interact_areas_in_range[ _target_index ] );

func get_targeted_interact_area() -> InteractableArea:
	if ( _target_index > -1 ):
		return _interact_areas_in_range[ _target_index ];
	else:
		return null;


func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED;


func _on_area_entered( area: Area2D ) -> void:
	
	if ( area is InteractableArea ):
		add_interact_area( area );

func _on_area_exited( area: Area2D ) -> void:
	
	if ( area is InteractableArea ):
		if ( area in _interact_areas_in_range ):
			remove_interact_area( area );
