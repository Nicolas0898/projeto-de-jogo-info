extends Control
class_name Map

@onready var map_texture := $map_texture

func activate(texture : Texture):
	Ui.fade_in(self)
	InteractionSystem.action = self
	map_texture.texture = texture

func deactivate():
	Ui.fade_out(self)
	InteractionSystem.action = null
