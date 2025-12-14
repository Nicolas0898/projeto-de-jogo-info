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

func rpi():
	Cursor.reset_physics_interpolation()
	line.reset_physics_interpolation()
	circle.reset_physics_interpolation()

@onready var Cursor: Sprite2D = $Cursor
@onready var line: Line2D = $Line
@onready var circle: Sprite2D = $Circle

var currentStatePriority = 0
static var pos
static var look
var targetRotation = 0.0
var cache = {}
var selectedTarget:Node2D
var f = true

func _ready() -> void:
	current = self
	%DebugMenu.watch(self,"state")

func _process(delta: float) -> void:
	if !is_instance_valid(Cursor) : return
	pos = get_global_mouse_position()
	look = GameHandler.Player.get_local_mouse_position().normalized()
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
	if event is InputEventMouseMotion:
		Cursor.rotation += event.relative.x/100

func basic(delta:float):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Cursor.global_position = pos
	Cursor.rotation = lerp(Cursor.rotation,targetRotation,5*delta)

func core(delta:float):
	basic(delta)
	circle.scale = circle.scale.lerp(Vector2.ZERO,10*delta)
	line.visible = false
	lerp_color_to(Color(1,1,1),delta)

func hook(delta:float):
	basic(delta)
	circle.global_position = cache.hookpos
	circle.scale = circle.scale.lerp(Vector2.ONE,10*delta)
	circle.rotate(PI*delta)
	line.global_position = pos
	line.set_point_position(1,line.to_local(cache.hookpos))
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

func cast(delta:float):
	selectedTarget = null
	Cursor.global_position = pos
	circle.scale = circle.scale.lerp(Vector2.ONE,10*delta)
	circle.rotate(PI*delta)
	
	Cursor.rotation = lerp(Cursor.rotation,PI/4,5*delta)
	
	var targetpos = pos
	line.global_position = pos
	
	var current_enemy = null
	for node in get_tree().get_nodes_in_group("Enemy") :
		var distance_to_enemy = node.global_position.distance_to(pos)
		if distance_to_enemy>48 : continue
		if current_enemy and current_enemy.global_position.distance_to(pos)<distance_to_enemy:continue
		current_enemy = node
		targetpos = node.global_position
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

func charged_attack(delta:float):
	basic(delta)
	circle.global_position = pos
	circle.visible = true
	line.visible = true
	Cursor.self_modulate = Cursor.self_modulate.lerp(Color(1,1,1,0.2),15*delta)
	line.global_position = pos
	line.set_point_position(1,line.to_local(GameHandler.Player.global_position))

func requestStateChange(newstate,newPriority):
	if newPriority>=currentStatePriority:
		currentStatePriority = newPriority
		self.state = newstate

func backToCore(priority):
	if priority>=currentStatePriority:
		self.state = "core"
		currentStatePriority = 0
