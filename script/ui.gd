extends CanvasLayer

@onready var dialogue: Control = $Dialogue

var tween : Tween


func _ready() -> void:
	dialogue.modulate = Color(1, 1, 1, 0)



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
