extends Node2D
class_name Crosshair

static var current:Crosshair
var state = "core":
	set(_newval):
		_newval = _newval.to_lower()
		if state!=_newval: f=true
		if has_method("entered_"+_newval) and state!=_newval:
			call("entered_"+_newval)
			rpi()
		state = _newval.to_lower()
		if state!="ui":
			canvas_layer.visible = false
			if not controller:
				Cursor.visible = true

func rpi():
	Cursor.reset_physics_interpolation()
	line.reset_physics_interpolation()
	circle.reset_physics_interpolation()

@onready var Cursor: Sprite2D = $Cursor
@onready var line: Line2D = $Line
@onready var circle: Sprite2D = $Circle
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var canvas_layer_cursor: Sprite2D = $CanvasLayer/Cursor
@onready var entity_raycast: RayCast2D = $EntityRaycast
@onready var entity_area: Area2D = $EntityArea
@onready var collision: CollisionShape2D = $EntityArea/Collision

var currentStatePriority = 0
static var atkrange = Vector2(100,200)
static var pos
static var look
var targetRotation = 0.0
var cache = {}
var selectedTarget:Node2D
var f = true

var controller = false
var c_input = Vector2.ZERO

func _ready() -> void:
	current = self
	%DebugMenu.watch_as_vector(self,"look")

func get_closest_enemy_from_area():
	var closest = null
	var closest_dist = null
	for hurtbox:Hurtbox in entity_area.get_overlapping_areas():
		var dist = hurtbox.global_position.distance_to(GameHandler.Player.global_position)
		if not closest or closest_dist>dist:
			closest = hurtbox
			closest_dist = dist
	return closest
func _process(delta: float) -> void:
	if !is_instance_valid(Cursor): return
	
	if not controller:
		pos = get_global_mouse_position()
		look = GameHandler.Player.get_local_mouse_position().normalized()
	else:
		c_input = Vector2(Input.get_axis("left","right"),0)
		if(abs(Input.get_axis("up","down")) > 0.7):
			c_input = Vector2(0,Input.get_axis("up","down"))

		
		
		pos = GameHandler.Player.global_position + c_input*50
		look = c_input
	
	if has_method(state.to_lower()):
		call(state.to_lower(),delta)
		if f:
			f = false
			rpi()
	else:
		push_warning("State "+state+" does not exist");

func lerp_color_to(color,delta):
	circle.self_modulate = circle.self_modulate.lerp(color,7*delta)
	line.self_modulate = line.self_modulate.lerp(color,7*delta)
	Cursor.self_modulate = Cursor.self_modulate.lerp(color,7*delta)

func setCircleSize(size:Vector2):
	circle.texture.width = size.x
	circle.texture.height = size.y

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion and not controller:
		controller = true
		canvas_layer_cursor.visible = false
		GameHandler.emit_game_input_changed(true)

		
	if event is InputEventMouseMotion and controller:
		GameHandler.emit_game_input_changed(false)
		controller = false
		canvas_layer_cursor.visible = true
		
		Cursor.rotation += event.relative.x/100

func atkcheck():
	if is_instance_valid(GameHandler.Player):
		entity_area.global_position = GameHandler.Player.global_position
		entity_raycast.global_position = GameHandler.Player.global_position
		
		var localpos = entity_raycast.to_local(pos)
		var dist = localpos.length()
		if controller: dist = atkrange.x
		var true_dist = min(dist,atkrange.x) 
		var tp = localpos.normalized() * true_dist 
		entity_raycast.target_position = tp
		entity_area.look_at(pos) 
		collision.shape.size  = Vector2(true_dist,atkrange.y)
		collision.position = Vector2(true_dist/2,0)

func basic(delta:float):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Cursor.global_position = pos
	Cursor.rotation = lerp(Cursor.rotation,targetRotation,5*delta)

func core(delta:float):
	basic(delta)
	circle.scale = circle.scale.lerp(Vector2.ZERO,10*delta)
	line.visible = false
	if controller:
		Cursor.visible = false
	else:
		Cursor.visible = true
	lerp_color_to(Color(1,1,1),delta)

func hook(delta:float):
	basic(delta)
	circle.global_position = cache.hookpos
	circle.scale = circle.scale.lerp(Vector2.ONE,10*delta)
	circle.rotate(PI*delta)
	if controller:
		pos = cache.hookpos
		line.global_position = GameHandler.Player.global_position
		line.set_point_position(1,line.to_local(cache.hookpos))
	else:
		line.global_position = cache.hookpos
		line.set_point_position(1,line.to_local(pos))
	
	line.visible = true
	if not cache.able: 
		lerp_color_to(Color(1,0,0),delta)
	else:
		lerp_color_to(Color(1,1,1),delta)

func entered_hook():
	circle.scale = Vector2.ZERO
	setCircleSize(Vector2(128,128))
	
func entered_cast():
	circle.global_position = pos
	circle.scale = Vector2.ZERO
	setCircleSize(Vector2(40,40))

func entered_ui():
	canvas_layer.visible = true
	Cursor.visible = false

func ui(delta:float):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	canvas_layer_cursor.rotation = lerp(Cursor.rotation,targetRotation,5*delta)
	if not controller:
		canvas_layer_cursor.position = get_viewport().get_mouse_position()
	else:
		canvas_layer_cursor.position += Input.get_vector("left","right","up","down")*1.2

func cast(delta:float):
	atkcheck()
	selectedTarget = null
	Cursor.global_position = pos
	circle.scale = circle.scale.lerp(Vector2.ONE,10*delta)
	circle.rotate(PI*delta)
	
	Cursor.rotation = lerp(Cursor.rotation,PI/4,5*delta)
	
	var current_enemy = null
	
	var targetpos = pos
	if not controller:
		line.global_position = pos
	else:
		targetpos = GameHandler.Player.global_position
		line.global_position = GameHandler.Player.global_position
	
	if not controller:
		for node in get_tree().get_nodes_in_group("Enemy") :
			var distance_to_enemy = node.global_position.distance_to(pos)
			if distance_to_enemy>48 : continue
			if current_enemy and current_enemy.global_position.distance_to(pos)<distance_to_enemy:continue
			current_enemy = node
			targetpos = node.global_position
	else:
		current_enemy = get_closest_enemy_from_area()
		if current_enemy :
			current_enemy = current_enemy.get_parent()
			targetpos = current_enemy.global_position
		
	selectedTarget = current_enemy
	if current_enemy:
		lerp_color_to(Color(0,1,0),delta)
	else:
		lerp_color_to(Color(1,0.8,0.8),delta)
	
	circle.global_position = circle.global_position.lerp(targetpos,20*delta)
	line.set_point_position(1,line.to_local(circle.global_position))
	line.visible = true

func entered_charged_attack():
	setCircleSize(Vector2(128,128))
	circle.scale = Vector2.ONE*0.5
	
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(circle,"scale",Vector2.ZERO,cache.time)
	
	if not controller:
		circle.global_position = pos
	else:
		circle.global_position = GameHandler.Player.global_position
	

func charged_attack(delta:float):
	atkcheck()
	basic(delta)
	if not controller:
		circle.global_position = pos
	else:
		circle.global_position = GameHandler.Player.global_position
	circle.visible = true
	if not controller:
		line.visible = true
	else:
		line.visible = false
	Cursor.self_modulate = Cursor.self_modulate.lerp(Color(1,1,1,0.2),15*delta)
	line.global_position = GameHandler.Player.global_position 
	line.set_point_position(1,line.to_local(pos))

func requestStateChange(newstate,newPriority):
	if newPriority>=currentStatePriority:
		currentStatePriority = newPriority
		self.state = newstate

func backToCore(priority):
	if priority>=currentStatePriority:
		self.state = "core"
		currentStatePriority = 0
