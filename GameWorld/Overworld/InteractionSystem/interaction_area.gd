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


func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED;


func _on_area_entered( area: Area2D ) -> void:
	
	if ( area is InteractableArea ):
		
		_interact_areas_in_range.append( area );
		Radio.notify_interact_area_changed_range( area, true );
		
		print( _interact_areas_in_range );

func _on_area_exited( area: Area2D ) -> void:
	
	if ( area is InteractableArea ):
		if ( area in _interact_areas_in_range ):
			
			_interact_areas_in_range.erase( area );
			Radio.notify_interact_area_changed_range( area, false );
	
	print( _interact_areas_in_range );
