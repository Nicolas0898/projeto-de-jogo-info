extends Control
@onready var label: Label = $Label

class option:
	var target_window:String
	var arc:arc_renderer
	var index = 0
	static var count = 0
	
	func _init(parent:Control,target):
		index = count
		count+=1
		target_window = target
		
		arc = arc_renderer.new()
		arc.set_anchors_preset(Control.PRESET_CENTER)
		parent.add_child(arc)
		
		update_render()
	
	func update_render():
		arc.radius = 80
		arc.width = 5
		arc.points = 8
		arc.arc_size = (2*PI)/count
		arc.arc_pos = (2*PI)/count * index
		if count==3:
			arc.arc_pos += PI/2
		elif count==4:
			arc.arc_pos += PI/4 
	

var options:Array[option] = []
var current_active:option

func _ready() -> void:
	add_option("Inventory")
	add_option("Map")
	add_option("Bestiary")


func _process(_delta: float) -> void:
	var mousedir = (get_local_mouse_position() - size/2).normalized()
	var angle = atan2(mousedir.y,mousedir.x)
	if angle<0: angle+=2*PI

	for i in options:
		var inside = i.arc.is_angle_inside_arc(angle)
		if inside:
			i.arc.modulate = Color(.8,1,.8)
			label.text = str(i.target_window)
			current_active = i
		else:
			i.arc.modulate = Color(0,0,0,0.5)

func add_option(window):
	var new_option = option.new(self,window)
	options.push_back(new_option)
	for i in options:
		i.update_render()

func trigger():
	Ui.set_current_active(current_active.target_window)

func on_active():
	pass
