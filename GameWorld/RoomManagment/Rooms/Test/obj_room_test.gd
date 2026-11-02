@tool
extends ObjRoom;

@onready var interactable_area: InteractableArea = $Interacts/InteractableArea;
@onready var interactable_area_2: InteractableArea = $Interacts/InteractableArea2;
@onready var interactable_area_3: InteractableArea = $Interacts/InteractableArea3
@onready var interactable_area_4: InteractableArea = $Interacts/InteractableArea4


func _ready() -> void:
	super();
	
	if ( Engine.is_editor_hint() ):
		return;
	
	interactable_area.interacted.connect( print.bind( "Interact 1" ) );
	interactable_area_2.interacted.connect( print.bind( "Interact 2" ) );
	interactable_area_3.interacted.connect( print.bind( "Interact 3" ) );
	interactable_area_4.interacted.connect( _goto_room );


func _goto_room() -> void:
	Radio.request_overworld_room_change("res://GameWorld/RoomManagment/Rooms/Test/obj_other_room.tscn");
