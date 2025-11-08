extends Node
class_name BestiaryComponent

@export var entry : bestiary_entry # Caso ele tenha uma página no bestiário

func bestiaryActivate(): #Exibe no bestiário
	entry.turn_visible()
	entry.times_eliminated+=1
	Ui.bestiary_node.refresh()


func bestiaryDeactivate(): #Retira do bestiário
	entry.turn_invisible()
	Ui.bestiary_node.refresh()
