extends CanvasLayer

@onready var dialogue: Control = $Dialogue
@onready var inventory: Control = $Inventory
@onready var confirm: Confirm = $Confirm
@onready var debug: Label = $debug


var tween : Tween


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

func cooldown(time : float, progress_bar : ProgressBar):
	progress_bar.value = 100
	
	tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, time)
	
	await tween.finished
