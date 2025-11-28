extends Node2D
class_name Crosshair

static var current:Crosshair
var state = "core":
	set(_newval):
		if has_method("entered_"+_newval) and state!=_newval:
			call("entered_"+_newval)
		state = _newval

@onready var Cursor: Sprite2D = $Cursor
@onready var line: Line2D = $Line
@onready var circle: Sprite2D = $Circle

var currentStatePriority = 0
static var pos
static var look
var targetRotation = 0.0
var cache = {}

func _ready() -> void:
	current = self

func _process(delta: float) -> void:
	if !is_instance_valid(Cursor) : return
	pos = get_global_mouse_position()
	look = GameHandler.Player.get_local_mouse_position().normalized()
	if has_method(state.to_lower()):
		call(state.to_lower(),delta)
	else:
		push_warning("State "+state+" does not exist");
		
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



func hook(delta:float):
	basic(delta)
	circle.global_position = cache.hookpos
	circle.scale = circle.scale.lerp(Vector2.ONE,10*delta)
	circle.rotate(PI*delta)
	line.global_position = pos
	line.set_point_position(1,line.to_local(cache.hookpos))
	line.visible = true

func entered_hook():
	circle.scale = Vector2.ZERO
	setCircleSize(Vector2(128,128))
	

func requestStateChange(state,newPriority):
	if currentStatePriority<=newPriority:
		self.state = state
