extends CanvasLayer

# Nodes
@onready var dialogue: Control = $Dialogue
@onready var inventory: Control = $Inventory
@onready var confirm: Confirm = $Confirm
@onready var map_node: Control = $Map
@onready var bestiary_node : Node = $Bestiary
@onready var debug: Label = $debug
@onready var transition: ColorRect = $Transition
@onready var player_ui: Control = $PlayerUI

# Variables
var window_cache:Dictionary[String,Control] = {}
var current_active:Control
var can_close = true

func _ready() -> void:
	InputManager.addNodeToGroup(self,"Player")
	set_current_active("playerui")

func set_current_active(window_name:String):
	hide_all()
	var window = window_cache[window_name.to_lower()]
	
	if not window:
		push_warning("Window "+window_name+ "Not found in UI")
		return
	
	
	var t = create_tween()
	
	t.tween_property(
				window,
				"modulate",
				Color(1,1,1,1),
				0.1
			)
	
	
	window.visible = true
	current_active = window
	
	if window.has_method("on_active"):
		window.on_active()

func hide_all():
	current_active = null
	for window in get_children():
		if window is Control and not window.has_meta("Ignore"):
			window_cache[window.name.to_lower()] = window
			var t = create_tween()
			
			t.tween_property(
				window,
				"modulate",
				Color(1,1,1,0),
				0.1
			)
			
			t.finished.connect(func():
				if not current_active or window.name!=current_active.name:
					window.visible = false
			)
			
			if window.has_method("exit_active"):
				window.exit_active()

func set_transition(value:bool):
	transition.visible = true
	var tween = create_tween()
	if value:
		tween.tween_property(transition,"modulate",Color(1,1,1,1),0.2)
	else : tween.tween_property(transition,"modulate",Color(1,1,1,0),0.2)
	await tween.finished

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if not current_active or current_active.name.to_lower() == "playerui":
			set_current_active("RadialMenu")
			
			if Crosshair.current.controller:
				GameHandler.Player.set_core(1)
				
			Crosshair.current.requestStateChange("ui",2)
		elif can_close:
			GameHandler.Player.remove_core(1)
			Crosshair.current.backToCore(2)
			set_current_active("playerui")
	if event.is_action_released("menu"):
		if current_active and current_active.name.to_lower() == "radialmenu":
			GameHandler.Player.set_core(1)
			current_active.trigger()
