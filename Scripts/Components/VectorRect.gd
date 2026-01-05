extends TextureRect
class_name VectorRect
const font = preload("res://Images/ARIAL.TTF")

var target = Vector2.ZERO:
	set(_newval):
		target = _newval
		queue_redraw()
	
func _draw() -> void:
	size = Vector2(100,100)
	if target == null : return
	var draw_target = target
	if draw_target.length()>50:
		draw_target = draw_target.normalized()*50
	draw_line(size/2,draw_target + size/2,Color.WHITE,2)
	draw_circle(Vector2(size.x/2,size.y/2),50,Color.WHITE,false)
	draw_rect(Rect2(0,0,size.x,size.y),Color.WHITE,false)
	draw_string(font,Vector2(0,size.y+16),name,HORIZONTAL_ALIGNMENT_CENTER,100)
	draw_string(font,Vector2(0,size.y+32),str(target),HORIZONTAL_ALIGNMENT_CENTER,100)
