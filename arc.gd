extends Control
class_name arc_renderer

@export var radius := 10.0
@export var arc_size := PI
@export var width := 5.0
@export var arc_pos := 0.0
@export var points := 3
@export var redraw:bool:
	set(n):
		queue_redraw()
		redraw = false
var start = arc_pos
var end = start + arc_size

func _draw() -> void:
	start = arc_pos
	end = start + arc_size
	
	draw_arc(size/2,radius,start,end,points,Color(1,1,1),width)

func is_angle_inside_arc(angle):
	var f = angle > start and angle < end
	if f:
		return true
	if end > 2*PI and angle > 0 and angle < end-(2*PI):
		return true
	return false
