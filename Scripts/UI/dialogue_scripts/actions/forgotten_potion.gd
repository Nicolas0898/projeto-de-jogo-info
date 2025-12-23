extends Node

static func act():
	var item = load("res://resource/item/Poção_cura.tres")
	if GameHandler.total_coins < 15:
		Ui.dialogue.create_message("*Você não possui 15 moedas")
	else:
		Ui.dialogue.create_message("*Poção de cura adicionada no inventário")
		Ui.inventory.change_amount(item, 1)
		GameHandler.total_coins-=15


#*Poção de cura adicionada no inventário
#*Você não possui 15 moedas
#Bem... estarei aqui, cuide-se
