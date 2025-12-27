extends Node2D
class_name BaseWeapon

@onready var character: PlayerCharacter = $".."
@export var cooldown:float = 0.1
var image


var on_cooldown = false

@export var damage = 0
var read_from = "use_weapon"
var cd_timer:Timer
var active = false
func _ready() -> void:
	print(cooldown,damage)
	cd_timer = Timer.new()
	add_child(cd_timer)
	cd_timer.wait_time = cooldown
	cd_timer.one_shot = true
	cd_timer.timeout.connect(cd_timeout)
	character = $".."

func _input(event: InputEvent) -> void:
	if not(character.state_machine.currentState.name in\
	"FallingRunningIdleJumping"): return
	
	if event.is_action_pressed(read_from):
		use()
	if event.is_action_released(read_from):
		use_end()

func use():
	active = true
	pass

func use_end():
	active = false
	pass

func set_on_cooldown():
	on_cooldown = true
	cd_timer.start()
	Ui.player_ui.show_cooldown(cooldown,image)

func cd_timeout():
	on_cooldown = false
