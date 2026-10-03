@tool
extends Control;
class_name ObjScreenCover;
## Base script for screen covers.
##
## Please be sure to call emit_finished() in your animation, or through some other means,
## otherwise this system will lock and never continue.


const ANIM_COVER := &"CoverScreen";
const ANIM_UNCOVER := &"UncoverScreen";


## Emitted when this finishes a thing.
signal finished();
## Call in in your animation or in some other way.
func emit_finished() -> void: finished.emit();


@export var _animation_player: AnimationPlayer:
	set( new ):
		_animation_player = new;
		update_configuration_warnings();


func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_EDITOR_POST_SAVE ):
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _animation_player ):
		warnings.append( "No animation player!! Add one or close and reopen this scene." );
	else:
		
		if ( not _animation_player.has_animation( ANIM_COVER ) ):
			warnings.append( "Need animation: %s" % ANIM_COVER );
		if ( not _animation_player.has_animation( ANIM_UNCOVER ) ):
			warnings.append( "Need animation: %s" % ANIM_UNCOVER );
	
	return warnings;

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		if ( not _animation_player ):
			
			_animation_player = AnimationPlayer.new();
			add_child( _animation_player, true );
			_animation_player.owner = self;
		
		Utils.set_node_processes( self, false );
		return;


func cover_screen() -> void:
	_animation_player.play( ANIM_COVER );

func uncover_screen() -> void:
	_animation_player.play( ANIM_UNCOVER );
