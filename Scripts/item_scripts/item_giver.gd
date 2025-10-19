extends Interactable
class_name ItemGiver

@export var i : Item
@export var quantity : int
@export var interaction_amount : int = 1
@export var message : String
var c : int = 1

func activate():
	print("GANHANDO ITEM "+i.name)
	print(i.hability_path)
	Ui.inventory.change_amount(i, quantity)
	if i.hability_path != null:
		if GameHandler.player_habilities.find(i.hability_path) == -1:
			GameHandler.player_habilities.push_back(i.hability_path)
			GameHandler.Player.add_hability(i.hability_path)

	
	if interaction_amount == c: InteractionSystem.current_area.queue_free()
	else: c+=1
	
	if message:
		var diag = Dialogue.new()
		var m = Message.new()
		
		m.text = message
		m.sprite_pos = Message.Posicoes.nenhum
		diag.messages.append(m)
		
		Ui.dialogue.start(diag)
	
