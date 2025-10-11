extends RigidBody2D

func _ready() -> void:
	create_tween().tween_property(self,"modulate",Color(1,1,1,0),20)
	get_tree().create_timer(20).timeout.connect(func():
		if is_instance_valid(self):
			self.queue_free())
