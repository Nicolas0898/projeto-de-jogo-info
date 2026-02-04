extends Camera2D
class_name PlayerCamera

#Screenshake: https://www.youtube.com/watch?v=pG4KGyxQp40
class ScreenShake:
	var noise = FastNoiseLite.new()
	var shake_intensity : float = 0
	var active_shake_time : float = 0
	var active = false
	var shake_time : float = 0
	var offset = Vector2.ZERO
	var shake_roughness = 20
	var shake_decay = 0.2
	var current_decay = 1
	
	signal finished

	func _init(intensity:float,time:float,roughness:float=7,decay:float=0.1) -> void:
		randomize() #Evitar o "set seed" pra ele ficar aleatório 100% das vezes
		noise.seed = randi()
		noise.frequency = 2
		
		shake_intensity = intensity
		active_shake_time = time
		shake_roughness = roughness
		shake_time = 0
		shake_decay = decay
		
		active = true
	
	func tick(delta:float):
		shake_time += delta
		active_shake_time -= delta
		
		if shake_roughness > 0:
			offset = offset.lerp( Vector2(
				randf_range(-shake_intensity,shake_intensity),
				randf_range(-shake_intensity,shake_intensity)
			),shake_roughness*delta)
		else:
			offset = Vector2(
				randf_range(-shake_intensity,shake_intensity),
				randf_range(-shake_intensity,shake_intensity)
			)
		
		if active_shake_time-shake_decay <= 0:
			active = false
			
			var offset_tween = GameHandler.create_tween()
			offset_tween.set_trans(Tween.TRANS_LINEAR) #sine / expo / quad (conforme a força da desaceleração)
			offset_tween.set_ease(Tween.EASE_OUT)
			offset_tween.tween_property(self, "current_decay", 0, shake_decay)
			
			await offset_tween.finished
			
			finished.emit()
	
	
	func get_offset():
		return offset * current_decay
	
	func stop():
		active_shake_time = -1

var active = true
static var current:PlayerCamera
var array = []

 #Textura pra randomizar ainda mais o screenshake

func _ready() -> void:
	PlayerCamera.current = self

func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("camera_pos",global_position)
	if not active: return
	
	offset = Vector2.ZERO
	for shake:ScreenShake in array:
		shake.tick(delta)
		offset+=shake.get_offset()

static func screen_shake(intensity:float,time:float,roughness:float=20,decay:float=0.2)->ScreenShake:
	var new_shake = ScreenShake.new(intensity,time,roughness,decay)
	current.array.push_back(new_shake)
	
	new_shake.finished.connect(func():
		current.array.erase(new_shake)
		)
	
	return new_shake
