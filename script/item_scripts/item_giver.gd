extends Interactable
class_name ItemGiver

@export var i : Item
@export var quantity : int
@export var interaction_amount : int = 1
var c : int = 1

func activate():
	Ui.inventory.change_amount(i, quantity)
	
	if interaction_amount == c: InteractionSystem.current_area.queue_free()
	else: c+=1
	
	
