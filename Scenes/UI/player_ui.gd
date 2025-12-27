extends Control
@onready var health_bar: ProgressBar = $Panel/HealthBar
@onready var label: Label = $Panel/Label
const HABILITY_RENDER = preload("uid://skuxd5l3pjlr")
@onready var cdlist: HBoxContainer = $cdlist
@onready var vin_2: TextureRect = $vin2
@onready var vin_3: TextureRect = $vin3

func _process(delta: float) -> void:
	if GameHandler.Player:
		position = position.lerp(-GameHandler.Player.velocity/90,delta*10)

func update_health(newval):
	if health_bar.value>newval:
		var diff = health_bar.value-newval
		var factor = min(0.5,(diff*1.5/health_bar.max_value))
		vin_2.modulate = Color("#ff000044")
		vin_2.self_modulate = Color(1,1,1,factor)
		create_tween().tween_property(vin_2,"self_modulate",Color(1,1,1,0),0.2 + pow(factor,2))
	health_bar.value = newval
	label.text = str(newval)+"/100"

func register_hit():
	vin_3.modulate = Color("#ffffff44")
	vin_3.self_modulate = Color(1,1,1,0.005)
	create_tween().tween_property(vin_3,"self_modulate",Color(1,1,1,0),0.2)
	PlayerCamera.screen_shake(1.5,0.1)

func show_cooldown(s,image=null):
	var newcd = HABILITY_RENDER.instantiate()
	cdlist.add_child(newcd)
	if image:
		newcd.image.texture = image
	var t = create_tween()
	t.tween_property(newcd.bar,"value",0,s-0.1)
	t.finished.connect(func():
		var t2 = create_tween()
		t2.tween_property(newcd,"modulate",Color(1,1,1,0),0.1)
		await t2.finished
		newcd.queue_free()
		)
	
