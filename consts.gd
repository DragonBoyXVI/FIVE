@tool
@abstract
extends Object;
class_name Consts;
## Self explanitory
##
## Ditto


const SCREEN_SIZE := Vector2i( 1280, 720 );


enum ZLayer {
	
}

enum CollisionLayer {
	## Walls that characters cannot pass.
	CHARACTER_WALL = 1<<0,
}
static func _name_collision() -> void:
	const PATH := "layer_names/2d_physics/layer_%s";
	
	ProjectSettings.set_setting( PATH % 1, "Character Wall" )


static func _static_init() -> void:
	
	print( "Consts init" );
	_name_collision();
