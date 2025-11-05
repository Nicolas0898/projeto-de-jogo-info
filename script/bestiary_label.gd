extends page
class_name bestiary_label

@export var text : String
@export var from : bestiary_entry

func _init():
	scene = preload("res://Scenes/UI/bestiary_label.tscn")
