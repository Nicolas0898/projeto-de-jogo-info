extends Node2D
class_name BaseWeapon

@onready var character: PlayerCharacter = $".."
@export var cooldown:float = 0.1
var on_cooldown = false

var cd_timer:Timer
func _ready() -> void:
	cd_timer = Timer.new()
	add_child(cd_timer)
	cd_timer.wait_time = cooldown
	cd_timer.one_shot = true
	cd_timer.timeout.connect(cd_timeout)

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

func set_on_cooldown():
	on_cooldown = true
	cd_timer.start()

func cd_timeout():
	on_cooldown = false
