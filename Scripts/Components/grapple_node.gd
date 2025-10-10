@tool
extends Node2D
class_name GrappleNode

enum {SWING,PULL}
const swing_color = "#feffa8"
const pull_color = "#bffdff"

@export_range(1,500,1) var range := 300.0:
	set(n):
		range = n
		queue_redraw()
@export_enum("Swing","Pull") var type = 0:
	set(_n):
		type = _n
		if _n == SWING: modulate = Color.from_string(swing_color,Color.WHITE)
		if _n == PULL : modulate = Color.from_string(pull_color,Color.WHITE)
@export var enabled := true


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO,range/scale.x,Color.AQUAMARINE,false,2,true)
