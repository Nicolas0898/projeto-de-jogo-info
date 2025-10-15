extends BaseWeapon
const LEAF_CAGE = preload("res://Scenes/Player/Habilities/leaf_cage.tscn")

func _ready() -> void:
	read_from = "magic1"

func use():
	var dir = -1 if GameHandler.Player.sprite.flip_h else 1
	var instance = LEAF_CAGE.instantiate()
	instance.global_position = GameHandler.Player.global_position + Vector2(dir*100,10)
	get_tree().current_scene.add_child(instance)
