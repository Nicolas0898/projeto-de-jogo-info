extends Camera2D
class_name PlayerCamera

#Screenshake: https://www.youtube.com/watch?v=pG4KGyxQp40

var active = false
var shake_intensity : float = 0
var active_shake_time : float = 0

var shake_decay : float = 5 #O quão rápido ele para ou começa o screenshake
var shake_time : float = 0

var noise = FastNoiseLite.new() #Textura pra randomizar ainda mais o screenshake

func _physics_process(delta: float) -> void:
	#active = false if active_shake_time <= 0 else true
	if not active: return
	
	shake_time += delta
	active_shake_time -= delta
	
	offset = Vector2(
		noise.get_noise_2d(shake_time, 0) * shake_intensity,
		noise.get_noise_2d(0, shake_time) * shake_intensity
		)
	
	if active_shake_time <= 0:
		active = false
		
		var offset_tween = create_tween()
		offset_tween.set_trans(Tween.TRANS_QUAD) #sine / expo / quad (conforme a força da desaceleração)
		offset_tween.set_ease(Tween.EASE_OUT)
		offset_tween.tween_property(self, "offset", Vector2(0, -30), 0.5)
	

func screen_shake(intensity:int, time:float):
	randomize() #Evitar o "set seed" pra ele ficar aleatório 100% das vezes
	noise.seed = randi()
	noise.frequency = 2
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0
	
	active = true
