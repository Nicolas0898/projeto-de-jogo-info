extends BaseWeapon
const LEAFSPAWN = preload("uid://biu2r6yljqxur")

class thornshield extends Node:
	func _ready() -> void:
		name = "thornshield"
	
	func emit_parry(hitbox):
		parry.emit(hitbox)
	
	signal parry(Hitbox)

var active_timer:SceneTreeTimer
var shield

func use():
	if on_cooldown: return
	character.set_core(1)
	character.sprite.playAnimation("parry",1,1,false)

	set_on_cooldown()
	shield = thornshield.new()
	character.add_child(shield)
	
	character.blink(0.5,"#ffffff",0.2)
	active_timer = get_tree().create_timer(0.5)
	active_timer.timeout.connect(end)
	shield.parry.connect(parry)
	

func parry(origin:Hitbox):
	Engine.time_scale = 0.5
	get_tree().create_tween().tween_property(Engine,"time_scale",1,0.2)
	
	var hitbox = Hitbox.new()
	hitbox.damage = origin.damage
	hitbox.global_position = character.global_position
	hitbox.one_hit = true
	hitbox.knockback=1.3*Vector2.ONE
	
	for i in origin.get_parent().get_children():
		if i is Hurtbox:
			i.onHit(hitbox)

			break
	
	
	var part2 = LEAFSPAWN.instantiate()
	character.add_child(part2)
	character.sprite.stopAnimation(1)
	part2.position = Vector2(0,-16)
	part2.emitting = true
	part2.get_node("a").finished.connect(func():
		part2.queue_free()
		)
	GameHandler.play_particle_one(part2.get_node("a"))
	
	
	Ui.player_ui.register_hit(0.15)
	character.blink(0.3,"#00ff88")
	active_timer.time_left = 0


func end():
	shield.queue_free()
	character.remove_core(1)
