extends Button

var i : Item
@onready var sprite: TextureRect = $sprite
@onready var amount : Label = $Panel/amount

func _on_focus_entered() -> void:
	Ui.inventory.refresh_desc(i)
	Ui.inventory.selected = self
