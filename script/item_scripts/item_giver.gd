extends Interactable
class_name ItemGiver

@export var i : Item
@export var quantity : int
@export var interaction_amount : int = 1
var c : int = 1

func activate():
	if i in Ui.inventory.inventario:
		Ui.inventory.inventario[Ui.inventory.inventario.find(i)].amount += quantity
		print("era p adicionar affs")
		print(Ui.inventory.inventario[Ui.inventory.inventario.find(i)].amount)
	else:
		Ui.inventory.inventario.append(i)
	Ui.inventory.refreshing()
	
	
	
	if interaction_amount == c:
		InteractionSystem.current_area.queue_free()
	else:
		c+=1
	
	
