extends Node2D
class_name BaseWeapon

@onready var character: PlayerCharacter = $".."

func _input(event: InputEvent) -> void:
	if not(character.state_machine.currentState.name in\
	"FallingRunningIdleJumping"): return
	
	if event.is_action_pressed("use_weapon"):
		use()
	if event.is_action_released("use_weapon"):
		use_end()

func use():
	pass

func use_end():
	pass
