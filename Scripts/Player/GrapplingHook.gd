extends Node

@onready var character: PlayerCharacter = $".."
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var hook_select: Sprite2D = $HookSelect

var max_distance := 300.0
var selected_hook:GrappleNode
var disabled_points = []

func _input(event: InputEvent) -> void:
	if state_machine.currentState.name == "Falling"\
	and event.is_action_pressed("jump")\
	and is_instance_valid(selected_hook):
		state_machine.requestStateChange("Hooking",{"hook":selected_hook})
		disabled_points.append(selected_hook)
		

func state_changed(new,old):
	if old.name == "Hooking":
		old.stateData.hook.enabled = false
		disabled_points.append(old.stateData.hook)
	if new.name != "Falling":
		for i in disabled_points:
			i.enabled = true
		disabled_points.clear()

func get_closest_hook_point():
	var hookpoints = get_tree().get_nodes_in_group("GrappleNode")
	var nearest_instance
	var nearest_distance
	
	for hook in hookpoints:
		var current_distance = hook.global_position.distance_to(character.global_position)

		if current_distance>hook.range:continue
		if hook.enabled == false:continue
		if nearest_instance==null or nearest_distance >  current_distance:
			nearest_instance = hook
			nearest_distance = current_distance
	
	return nearest_instance
	
func set_hook_visibility(value):
	var t = create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)
		
	var finalColor = Color(1,1,1,1) if value else Color(1,1,1,0)
	create_tween().tween_property(hook_select,"modulate",finalColor,0.3)
	if value:
		hook_select.rotation_degrees=-45
		hook_select.scale = Vector2(0,0)
		t.parallel().tween_property(hook_select,"rotation_degrees",45,0.5)
		t.parallel().tween_property(hook_select,"scale",Vector2(1,1),0.4)
	else:
		hook_select.rotation_degrees=-45
		hook_select.scale = Vector2(1,1)
		t.set_ease(Tween.EASE_IN)
		t.parallel().tween_property(hook_select,"rotation_degrees",45,0.5)
		t.parallel().tween_property(hook_select,"scale",Vector2(0,0),0.4)
		
func set_current_active_hook_point(new_node:GrappleNode):
	if new_node==null:
		set_hook_visibility(false)
		selected_hook = null
		return
	
	set_hook_visibility(true)
	
	if selected_hook!=null:
		var t = create_tween()
		t.set_trans(Tween.TRANS_BACK)
		t.set_ease(Tween.EASE_OUT)
		hook_select.position = new_node.global_position
		#t.parallel().tween_property(hook_select,"global_position"\
		#,new_node.global_position,0.35)
		var rot_sum = 90
		
		if selected_hook.global_position.x>new_node.global_position.x:
			rot_sum=-90
		hook_select.rotation_degrees = 45-rot_sum
		t.parallel().tween_property(hook_select,"rotation_degrees",\
		45+rot_sum,0.6)
	else:
		hook_select.global_position = new_node.global_position
	
	selected_hook = new_node

func _physics_process(delta: float) -> void:
	var hook_point = get_closest_hook_point()
	
	if hook_point!=selected_hook:
		set_current_active_hook_point(hook_point)

func _ready() -> void:
	state_machine.onStateChange.connect(state_changed)
