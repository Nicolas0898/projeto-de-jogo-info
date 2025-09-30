extends Interactable
class_name ItemGiver

@export var i : Item
@export var quantity : int
@export var interaction_amount : int = 1
var c : int = 1

func activate():
	print("item")
	if i in Ui.inventory.inventario:
		Ui.inventory.inventario[Ui.inventory.inventario.find(i)].amount += quantity
	elif quantity > 0:
		Ui.inventory.inventario.append(i)
	else: return
	
	Ui.inventory.refreshing()
	
	if interaction_amount == c:
		InteractionSystem.current_area.queue_free()
	else:
		c+=1
	
	
