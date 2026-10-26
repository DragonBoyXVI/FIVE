@tool
@abstract
extends Object;
class_name Consts;
## Self explanitory
##
## Ditto


const SCREEN_SIZE := Vector2i( 960, 540 );


enum ZLayer {
	
}

enum CollisionLayer {
	## Walls that characters cannot pass.
	CHARACTER_WALL = 1<<0,
	
	## Collision layer for the interaction system.
	INTERACTION = 1<<4,
}
static func _name_collision() -> void:
	const PATH := "layer_names/2d_physics/layer_%s";
	
	ProjectSettings.set_setting( PATH % 1, "Character Wall" );
	
	ProjectSettings.set_setting( PATH % 5, "Interaction" );


static func _static_init() -> void:
	
	print( "Consts init" );
	_name_collision();
