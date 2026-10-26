@tool
extends ObjRoom;

@onready var interactable_area: InteractableArea = $InteractableArea;
@onready var interactable_area_2: InteractableArea = $InteractableArea2;
@onready var interactable_area_3: InteractableArea = $InteractableArea3
@onready var interactable_area_4: InteractableArea = $InteractableArea4


func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	interactable_area.interacted.connect( print.bind( "Interact 1" ) );
	interactable_area_2.interacted.connect( print.bind( "Interact 2" ) );
	interactable_area_3.interacted.connect( print.bind( "Interact 3" ) );
	interactable_area_4.interacted.connect( print.bind( "Interact 4" ) );
