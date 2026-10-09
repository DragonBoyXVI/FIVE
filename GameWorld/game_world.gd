extends Node2D;


@onready var _screen_cover_manager: ObjScreenCoverManager = %ScreenCoverManager;
@onready var _overworld_room_manager: RoomManager = %OverworldRoomManager
#@onready var battle_room_manager: RoomManager = %BattleRoomManager


@export_file( "*.tscn" ) var _init_ow_room: String = "";


func _ready() -> void:
	
	Radio.game_world_change_ow_room_requested.connect( _on_radio_game_world_change_ow_room_requested, CONNECT_DEFERRED );
	
	await get_tree().create_timer( 1.0 ).timeout;
	Radio.request_overworld_room_change( _init_ow_room );

func _exit_tree() -> void:
	print_orphan_nodes();


## Hides the screen and changes out the overworld room.
func _change_ow_room( room_path: String ) -> void:
	
	_screen_cover_manager.cover_screen();
	await _screen_cover_manager.finished;
	
	_overworld_room_manager.change_room_thread( room_path );
	await _overworld_room_manager.room_changed;
	
	_screen_cover_manager.uncover_screen();
	await _screen_cover_manager.finished;


func _on_radio_game_world_change_ow_room_requested( room_path: String ) -> void:
	_change_ow_room( room_path );
