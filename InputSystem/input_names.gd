@tool
@abstract
extends Object;
class_name InputNames;
## Helper class that contains input names and methods to gather inputs.
##
## ditto


# Arrows
# hold ctrl for look?
@abstract class Move:
	extends Object;
	
	const RIGHT := &"Move Right";
	const DOWN := &"Move Down";
	const LEFT := &"Move Left";
	const UP := &"Move Up";
	
	static func get_vector() -> Vector2:
		return Input.get_vector( LEFT, RIGHT, UP, DOWN );

# VB?
@abstract class Shoulder:
	extends Object;
	
	const LEFT := &"Shoulder Left";
	const RIGHT := &"Shoulder Right";
	
	static func get_axis() -> float:
		return Input.get_axis( LEFT, RIGHT );

# Z
const ACCEPT := &"Accept";
# X
const BACK := &"Back";
# C
const SPECIAL := &"Special";
