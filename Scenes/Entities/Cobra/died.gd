extends State
@onready var hitbox_2: Hitbox = $"../../Hitbox2"
@onready var hitbox_3: Hitbox = $"../../Hitbox3"
@onready var hitbox: Hitbox = $"../../Hitbox"

func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,5)
	hitbox.monitoring = false
	hitbox_2.monitoring = false
	hitbox_3.monitoring = false
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	sprite.play("die")
	await sprite.animation_finished
	print("morreu")
	character.queue_free()
