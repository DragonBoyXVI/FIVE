@tool
extends Node2D;
class_name ObjRoom;
## Base class for any type of room.
##
## Super specific desc here


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;


func pause() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED;

func unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
