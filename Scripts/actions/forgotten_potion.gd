extends Node

static func act():
	var item = load("res://Resources/item/Poção_cura.tres")
	#var dialogue = Dialogue.new()
	#var message = Message.new()
	
	if GameHandler.total_coins < 15:
		Ui.dialogue.current_loaded_dialogue.messages[0].text = "*Você não possui 15 moedas"
		#message.text = "*Você não possui 15 moedas"
		#message.sprite_pos = Message.Posicoes.nenhum
		#dialogue.messages.append(message)
	else:
		#message.text = "*Poção de cura adicionada no inventário"
		#message.sprite_pos = Message.Posicoes.nenhum
		#dialogue.messages.append(message)
		 
		Ui.inventory.change_amount(item, 1)
		GameHandler.total_coins-=15
	
	Ui.dialogue.c = -1
	Ui.dialogue.loadNextMessage()
	#Ui.dialogue.start(dialogue)

#*Poção de cura adicionada no inventário
#*Você não possui 15 moedas
#Bem... estarei aqui, cuide-se
