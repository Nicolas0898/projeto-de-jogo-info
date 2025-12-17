extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
var attacks = ["atirar", "dash", "perfurar"]
var atirar_c = 0 #contador pra não repetir demais

var ignore = null
var next_attack = attacks.pick_random()

func onStateEntered(_oldState:State):
	sprite.play("idle")
	var dist = character.global_position.direction_to(GameHandler.Player.global_position)
	sprite.flip_h = true if dist.x>0 else false
	
	
	await get_tree().create_timer(0.9).timeout #Pausa entre ataques
	
	#APAGAR PQ É TESTE UWU >W<
	GameHandler.Player.add_child(preload("res://Scenes/Player/InstanciableHabilities/grappling_hook.tscn").instantiate())
	
	if stateMachine.currentState != self: return
	
	stateMachine.requestStateChange(next_attack)
	ignore = next_attack
	select_attack()

func select_attack(): #obs: nesse caso o ataque pode se repetir, menos o "atirar"
	#print("selecting...")
	while next_attack == ignore:
		#print("------")
		next_attack = attacks.pick_random()
		#print(next_attack)
		#print(ignore)
		
		if next_attack == "atirar" and atirar_c >= 5: break
		elif next_attack != "atirar" and next_attack != ignore:
			atirar_c += 1
		elif atirar_c < 5:
			next_attack = ignore

#func _physics_process(delta: float) -> void:
	#print(next_attack)
