@tool
extends ObjRoom;

@onready var interactable_area: InteractableArea = $InteractableArea;
@onready var interactable_area_2: InteractableArea = $InteractableArea2;


func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	interactable_area.interacted.connect( print.bind( "Interact 1" ) );
	interactable_area_2.interacted.connect( print.bind( "Interact 2" ) );
