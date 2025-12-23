extends Resource
class_name page

#Página do bestiário btw

var scene #Cena que instancia quando abre
@export var is_visible = false

func turn_visible():
	is_visible = true
	on_turn_visible()

func turn_invisible():
	is_visible = false
	on_turn_invisible()


func on_turn_visible():
	pass

func on_turn_invisible():
	pass
