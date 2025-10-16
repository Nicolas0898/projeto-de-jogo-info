extends BaseHurtbox
@onready var iframe: Timer = $Iframe

func _ready() -> void:
	set_collision_layer_value(3,true)

func onHit(other:Hitbox):
	if not iframe.is_stopped(): return
	super(other)
	iframe.start()
	
	if character.get_node("GrapplingHook"):
		character.get_node("GrapplingHook").reset_hooks()
		
	if other.stun:
		character.state_machine.requestStateChange("Stunned")
		get_tree().create_timer(0.12).timeout.connect(func():
			if character.state_machine.currentState.name == "Stunned":
				character.state_machine.requestStateChange("Falling"))
