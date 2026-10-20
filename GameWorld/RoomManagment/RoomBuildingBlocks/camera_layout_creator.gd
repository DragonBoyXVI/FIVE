@tool
extends Node;
class_name CameraLayoutCreator;
## This node takes a camera and a tilemap, and creates a camera layout for it.
## Either limiting the camera to the tilemap or if its small enough placing it to look in the center of the room.
##
## If you exlcude this node, you can set up the camera yourself.


## Set this to true for this to skip its setup without removing the node.
@export var _disabled: bool = false;

## Used to determine the kayout of the room in question.
@export var _layout_tilemap: TileMapLayer:
	set( new ):
		_layout_tilemap = new;
		update_configuration_warnings();
## The camera we are setting settings for.
@export var _camera: Camera2D:
	set( new ):
		_camera = new;
		update_configuration_warnings();


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	if ( _disabled ):
		return;
	
	var parent: Node = get_parent();
	if ( not parent.is_node_ready() ):
		await parent.ready;
	
	_perform_layout_creation();

func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_PARENTED ):
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( get_parent() is not ObjRoom ):
		warnings.append( "This is intended to be used for rooms. This may not work as expected outside of a room." );
	
	if ( not _camera ):
		warnings.append( "This needs a camera to configure." );
	
	if ( not _layout_tilemap ):
		warnings.append( "This needs a tilemap to use as room bounds." );
	
	return warnings;


func _perform_layout_creation() -> void:
	
	var tile_map_rect: Rect2i = _layout_tilemap.get_used_rect();
	var top_left_tile_coords: Vector2i = tile_map_rect.position;
	var bottom_right_tile_coords: Vector2i = tile_map_rect.position + tile_map_rect.size - Vector2i.ONE;
	
	var tile_size: Vector2i = _layout_tilemap.tile_set.tile_size;
	var half_tile: Vector2 = tile_size * 0.5;
	var top_left_global_pos: Vector2 = _layout_tilemap.to_global( _layout_tilemap.map_to_local( top_left_tile_coords ) );
	top_left_global_pos -= half_tile;
	var bottom_right_global_pos: Vector2 = _layout_tilemap.to_global( _layout_tilemap.map_to_local( bottom_right_tile_coords ) );
	bottom_right_global_pos += half_tile;
	
	#var room_rect: Rect2 = Rect2(
		#top_left_global_pos, 
		#bottom_right_global_pos - top_left_global_pos
	#);
	
	#var is_room_small_x: bool = ( room_rect.size.x < Consts.SCREEN_SIZE.x );
	#var is_room_small_y: bool = ( room_rect.size.y < Consts.SCREEN_SIZE.y );
	
	# target center of the room and exit early.
	# dont set limits in this case to prevent weird camera behaviour XXXX
	# WRONG limits smaller than the camera lems make it focus on the center of its limit
	#if ( is_room_small_x and is_room_small_y ): # this is unneeded then?
		#var room_center: Vector2i = room_rect.get_center().round();
		#_camera.limit_left = room_center.x;
		#_camera.limit_right = room_center.x;
		#_camera.limit_top = room_center.y;
		#_camera.limit_bottom = room_center.y;
		#return;
	
	_camera.limit_left = floori( top_left_global_pos.x );
	_camera.limit_top = floori( top_left_global_pos.y );
	_camera.limit_right = ceili( bottom_right_global_pos.x );
	_camera.limit_bottom = ceili( bottom_right_global_pos.y );
	pass;
