extends Item
class_name bestiary_item

func utilize():
	Ui.inventory.input()
	Ui.bestiary_node.open()
