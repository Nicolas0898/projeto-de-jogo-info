extends Control
class_name Map

#@onready var map_texture := $map_texture
@onready var is_open : bool = false

func activate(texture : Texture):
	is_open = true
	Ui.fade_in(self)
	InteractionSystem.action = self
	#map_texture.texture = texture

func deactivate():
	if is_open:
		Ui.fade_out(self)
		InteractionSystem.action = null
		is_open = false
