extends Item
class_name swamp_map

@export var map_sprite : Texture

func utilize():
	#Ui.inventory.input()
	#Ui.map_node.activate(map_sprite)
	Ui.set_current_active("Map")
