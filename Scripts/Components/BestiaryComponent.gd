extends Node
class_name BestiaryComponent

@export var entry : bestiary_entry # Caso ele tenha uma página no bestiário


func bestiaryActivate(): #Exibe no bestiário
	entry.is_visible = true
	Ui.bestiary_node.refresh()


func bestiaryDeactivate(): #Exibe no bestiário
	pass


func _on_state_machine_bestiary_activate() -> void:
	print("bestiario foi ativado")
