extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var t01 : GPUParticles2D = $"../../Particles/t01"
@onready var health_component: HealthComponent = $"../../HealthComponent"
var attacks = ["dash", "perfurar", "trail"]
var checkpoints = 0

var ignore = null
var next_attack = attacks.pick_random()

func onStateEntered(_oldState:State):
	sprite.play("idle")
	var dist = character.global_position.direction_to(GameHandler.Player.global_position)
	if dist.x>0:
		t01.position.x = 61
		sprite.flip_h = true
	else:
		t01.position.x = -61
		sprite.flip_h = false
	
	
	await get_tree().create_timer(0.9).timeout #Pausa entre ataques
	
	if stateMachine.currentState != self: return
	
	stateMachine.requestStateChange("idle")
	ignore = next_attack
	select_attack()

func select_attack(): #obs: nesse caso o ataque pode se repetir, menos o "atirar"
	if health_component.health < 200 and checkpoints == 0:
		checkpoints+=1
		next_attack = "atirar"
		return
	if health_component.health < 100 and checkpoints == 1:
		checkpoints+=1
		next_attack = "atirar"
		return
	
	while next_attack == ignore:
		next_attack = attacks.pick_random()
		
		
		#if next_attack == "atirar" and atirar_c >= 5: break
		#elif next_attack != "atirar" and next_attack != ignore:
		#	atirar_c += 1
		#elif atirar_c < 5:
		#	next_attack = ignore

#func _physics_process(delta: float) -> void:
	#print(next_attack)
