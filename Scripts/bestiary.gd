extends Control
class_name bestiary


@onready var bestiary_left: Panel = $Panel/book/HBoxContainer/bestiary_left
@onready var bestiary_right: Panel = $Panel/book/HBoxContainer/bestiary_right

@export var entries : Array[bestiary_entry]

func pass_page(direction : String):
	# "right" / "left"
	
	pass

func open():
	pass
	
