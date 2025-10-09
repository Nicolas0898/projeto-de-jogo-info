extends Item
class_name hp_potion

@export var hp : float

func utilize():
	node_used.get_node("HealthComponent").heal(hp)
	
	if node_used is PlayerCharacter: Ui.inventory.change_amount(self, -1)
