extends Button

var i : Item
@onready var sprite: TextureRect = $sprite
@onready var amount : Label = $Panel/amount
@onready var progress_bar : ProgressBar = $ProgressBar

func _on_focus_entered() -> void:
	Ui.inventory.refresh_desc(i)
	Ui.inventory.selected = self
