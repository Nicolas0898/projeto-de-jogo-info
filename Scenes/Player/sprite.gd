extends AnimatedSprite2D
class_name PriorityAnimatedSprite2D

var currentPriority = 0

func animstopped():
	currentPriority = 0

func _ready() -> void:
	animation_finished.connect(animstopped)
	

func playAnimation(anim:StringName,priority:int=0,speed:=1.0,reverses:=false):
	if priority<currentPriority:return
	currentPriority = priority
	play(anim,speed,reverses)
	
func stopAnimation(priority:=0):
	if priority<currentPriority:return
	priority = 0
	stop()
