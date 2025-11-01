extends page
class_name bestiary_entry

enum Dificulty{
	Nenhuma,
	Miniboss,
	Boss
}

@export var nome : String
@export var desc : String
@export var hp : float
@export var times_eliminated : int = 0
@export var indicator : Dificulty
@export var image : Texture
@export var border : Texture

func _init():
	scene = preload("res://Scenes/UI/bestiary_entry.tscn")
