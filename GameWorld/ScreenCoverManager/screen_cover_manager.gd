extends Control;
class_name ObjScreenCoverManager;


## Wait for this signal after you request something.
signal finished();
## Emitted when this changes what cover its using.
signal cover_changed();

@onready var _absolute_cover: Control = $AbsoluteCover;

## Stored to prevent changing to a scene were already in.
@export var _current_cover: ObjScreenCover;


func _ready() -> void:
	
	_absolute_cover.hide();


## Hides the screen with an animation.
func cover_screen() -> void:
	
	_current_cover.cover_screen();
	await _current_cover.finished;
	_absolute_cover.show();
	finished.emit();

## Shows the screen with an animation.
func uncover_screen() -> void:
	
	_absolute_cover.hide();
	_current_cover.uncover_screen();
	await _current_cover.finished;
	finished.emit();


## Changes the screen cover immediatley.
## For when it cant be waited on.[br]
## [br]
## cover_path: [String] - Path to the cover to load.
func change_cover( cover_path: String ) -> void:
	
	var cover_scene: PackedScene = load( cover_path );
	
	if ( _current_cover ):
		_current_cover.queue_free();
	_current_cover = cover_scene.instantiate();
	add_child( _current_cover );
	
	cover_changed.emit();

## Changes the screen cover over a thread.
## This is awaitable.
## [br]
## cover_path: [String] - Path to the cover to load.
func change_cover_thread( cover_path: String ) -> void:
	
	var cover_scene: PackedScene = await Utils.load_resource_coroutine( cover_path, "PackedScene" );
	
	if ( _current_cover ):
		_current_cover.queue_free();
	_current_cover = cover_scene.instantiate();
	add_child( _current_cover );
	
	cover_changed.emit();
