extends Node

static func act():
	var item = load("res://resource/item/Poção_cura.tres")
	if GameHandler.total_coins < 15:pass
	else: 
		Ui.inventory.change_amount(item, 1)
		GameHandler.total_coins-=15
	Ui.dialogue.dialogueEnd()

#*Poção de cura adicionada no inventário
#*Você não possui 15 moedas
#Bem... estarei aqui, cuide-se
