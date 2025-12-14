extends RigidBody2D

var cand = false
func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	cand = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if cand:
		queue_free()
