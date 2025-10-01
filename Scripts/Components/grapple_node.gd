@tool
extends Node2D
class_name GrappleNode

enum {SWING,PULL}
const swing_color = "#feffa8"
const pull_color = "#bffdff"

@export var range := 300.0
@export_enum("Swing","Pull") var type = 0:
	set(_n):
		type = _n
		print(_n)
		if _n == SWING: modulate = Color.from_string(swing_color,Color.WHITE)
		if _n == PULL : modulate = Color.from_string(pull_color,Color.WHITE)
@export var enabled := true
