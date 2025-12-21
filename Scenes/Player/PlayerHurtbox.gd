extends BaseHurtbox
@onready var iframe: Timer = $Iframe
signal on_hit(other:Hitbox)

func _ready() -> void:
	set_collision_layer_value(3,true)

func onHit(other:Hitbox):
	if not iframe.is_stopped(): return
	on_hit.emit(other)
	super(other)
	iframe.start()
	
	Ui.player_ui.update_health(GameHandler.Player.health_component.health)
	
	if character.has_node("GrapplingHook"):
		character.get_node("GrapplingHook").reset_hooks()
		
	if other.stun:
		character.state_machine.requestStateChange("Stunned")
		get_tree().create_timer(0.12).timeout.connect(func():
			if character.state_machine.currentState.name == "Stunned":
				character.state_machine.requestStateChange("Falling"))
