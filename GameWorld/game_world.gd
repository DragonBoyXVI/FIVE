extends Node2D;


@onready var _screen_cover_manager: ObjScreenCoverManager = %ScreenCoverManager;


func _ready() -> void:
	return;
	_screen_cover_manager.cover_screen();
	await _screen_cover_manager.finished;
	_screen_cover_manager.uncover_screen();
	await _screen_cover_manager.finished;
	_ready.call_deferred();
