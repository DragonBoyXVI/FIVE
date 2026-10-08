extends Node2D;


@onready var _screen_cover_manager: ObjScreenCoverManager = %ScreenCoverManager;
@onready var _overworld_room_manager: RoomManager = %OverworldRoomManager


@export_file( "*.tscn" ) var _init_ow_room: String = "";


func _ready() -> void:
	print( 1 );
	
	_screen_cover_manager.cover_screen();
	await _screen_cover_manager.finished;
	print( 2 );
	
	_overworld_room_manager.change_room_thread( _init_ow_room );
	await _overworld_room_manager.room_changed;
	print( 3 );
	
	_screen_cover_manager.uncover_screen();
	await _screen_cover_manager.finished;
	print( 4 );
