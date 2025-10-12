extends CanvasLayer

@onready var dialogue: Control = $Dialogue
@onready var inventory: Control = $Inventory
@onready var confirm: Confirm = $Confirm
@onready var debug: Label = $debug


var tween : Tween

func _physics_process(_delta: float) -> void:
	debug.text = str(InteractionSystem.action)

func _ready() -> void:
	dialogue.modulate = Color(1, 1, 1, 0)
	inventory.modulate = Color(1, 1, 1, 0)
	confirm.modulate = Color(1, 1, 1, 0)

func fade_in(p):
	tween = create_tween()
	tween.tween_property(p,"modulate",Color(1,1,1,1),0.2)
	#print("fadein")
	await tween.finished

func fade_out(p):
	tween = create_tween()
	tween.tween_property(p,"modulate",Color(1,1,1,0),0.2)
	#print("fadeout")
	await tween.finished

func new_tween(object : Object, property : String, new_value, time : float):
	tween = create_tween()
	tween.tween_property(object, property, new_value, time)
	await tween.finished

func cooldown(time : float, progress_bar : ProgressBar):
	progress_bar.value = 100
	
	tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, time)
	
	await tween.finished
