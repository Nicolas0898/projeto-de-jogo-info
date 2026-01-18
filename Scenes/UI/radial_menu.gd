extends Control
@onready var label: Label = $Label

class option:
	var target_window:String
	var arc:arc_renderer
	var index = 0
	var sprite:TextureRect
	var alias
	static var count = 0
	
	func _init(parent:Control,target,aka,img=null):
		index = count
		count+=1
		target_window = target
		alias = aka
		
		arc = arc_renderer.new()
		arc.set_anchors_preset(Control.PRESET_CENTER)
		parent.add_child(arc)
		
		if img!=null:
			sprite = TextureRect.new()
			sprite.texture = load(img)
			arc.add_child(sprite)
		
		update_render()
	
	func update_render():
		arc.radius = 80
		arc.width = 5
		arc.points = 4
		arc.arc_size = (2*PI)/count
		arc.arc_pos = (2*PI)/count * index
		if count==3:
			arc.arc_pos += PI/2
		elif count==4:
			arc.arc_pos += PI/4 
		elif count==5:
			arc.arc_pos += PI/10
		
		if sprite:
			sprite.position = arc.get_middle_point() - sprite.size/2
	

var options:Array[option] = []
var current_active:option

func _ready() -> void:
	add_option("Inventory","Inventário","res://Images/assets/backpack.png")
	add_option("Map","Mapa","res://Images/assets/MAPA.png")
	add_option("Bestiary","Bestiário","res://Images/assets/bestiary.png")
	add_option("Loadout","Equipamento","res://Images/Player/corrida/corrida1.png")


func _process(_delta: float) -> void:
	var mousedir
	
	if Crosshair.current.controller:
		mousedir = Input.get_vector("left","right","up","down")
	else:
		mousedir = (get_local_mouse_position() - size/2).normalized()
		
	var angle = atan2(mousedir.y,mousedir.x)
	if angle<0: angle+=2*PI
	position = position.lerp(mousedir*5,10*_delta)
	

	for i in options:
		i.arc.rotation = lerp(i.arc.rotation,mousedir.x/20,10*_delta) 
		var inside = i.arc.is_angle_inside_arc(angle)
		if inside:
			i.arc.self_modulate = Color(.8,1,.8)
			if i.sprite:
				i.sprite.modulate = Color(1,1,1)
			label.text = str(i.alias)
			current_active = i
		else:
			i.arc.self_modulate = Color(0,0,0,0.5)
			if i.sprite:
				i.sprite.modulate = Color(0,0,0,0.75)

func add_option(window,aka,img=null):
	var new_option = option.new(self,window,aka,img)
	options.push_back(new_option)
	for i in options:
		i.update_render()

func trigger():
	Ui.set_current_active(current_active.target_window)

func on_active():
	pass
