extends State

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var can_attack = false

const attacks = ["Smash","Roll","Throw"] # "Throw"
var next_attack = attacks[1]
var ignore = null

@onready var nextlabel: Label = $"../../DEBUGINFO/next"
@onready var ignorelabel: Label = $"../../DEBUGINFO/ignore"

func onStateEntered(old:State):
	if sprite.is_playing() and old != self and old.name != "Stunned":
		print("WAITING FOR ANIMATION FINISH : " + str(old.name))
		await sprite.animation_finished
	print("WAITING FINISHED")
	can_attack = true
	
	sprite.play("idle")
	
	await get_tree().create_timer(0.5).timeout
	if stateMachine.currentState != self: return
	
	
	stateMachine.requestStateChange(next_attack)
	ignore = next_attack
	select_next()
	
	nextlabel.text = "next_attack: "+next_attack
	ignorelabel.text = "ignore: "+ignore
	
func select_next():
	while next_attack==ignore:
		next_attack = attacks.pick_random() 
	
