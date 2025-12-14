extends BaseEntity
class_name PlayerCharacter

@export var speed = 200
@export var gravity_multiplier = 1
@export var jump_power = 1
@export var cam_limit_r = 10000000
@export var cam_limit_l = -10000000
@export var cam_limit_t = -10000000
@export var cam_limit_b = 10000000
@export var zoom = Vector2(1.3,1.3)
var speed_multiplier = 1

@onready var camera: Camera2D = $Camera2D
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var sprite: PriorityAnimatedSprite2D = $Sprite
@onready var crouch_cast: RayCast2D = $CrouchCast
@onready var crouch_cast_2: RayCast2D = $CrouchCast2
@onready var top_edge_cast: RayCast2D = $TopEdgeCast
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var hook_cast: RayCast2D = $HookCast


var player_input = Vector2.ZERO
var last_looked_at = Vector2(1,0)
var current_core_priority = 0

func _ready() -> void:
	GameHandler.Player = self
	
	for i in GameHandler.player_habilities:
		if i=="" : continue
		add_child(load(i).instantiate())
	
	health_component.health = GameHandler.player_health
	%DebugMenu.watch(self,"true_constant_velocity")
	%DebugMenu.watch(self,"constant_velocity")
	%DebugMenu.watch(self,"variable_velocity")
	%DebugMenu.watch(state_machine,"currentState")
	%DebugMenu.watch(self,"speed_multiplier")
	%DebugMenu.watch_as_vector(self,"velocity")
	%DebugMenu.watch_as_vector(self,"player_input")
	%DebugMenu.watch_as_vector(self,"last_looked_at")
	camera.limit_left = cam_limit_l
	camera.limit_right = cam_limit_r
	camera.limit_bottom = cam_limit_b
	camera.limit_top = cam_limit_t
	camera.zoom = zoom
	
	if GameHandler.spawnpoint!=null:
		var spawn = get_tree().current_scene.find_child("SpawnLocation") as SpawnLocation
		if spawn != null and spawn.spawn.has(GameHandler.spawnpoint):
			global_position = spawn.spawn[GameHandler.spawnpoint].global_position

	Ui.player_ui.update_health(health_component.health)
	camera.reset_smoothing()
	camera.reset_physics_interpolation()
	await get_tree().create_timer(0.05).timeout
	Ui.set_transition(false)

func default_player_input(local_mult:float=1.0):
	var axis = Input.get_axis("left","right")
	constant_velocity.input =  Vector2(axis*speed*speed_multiplier*local_mult,0)
	if axis>0:
		sprite.flip_h = false
	elif axis<0:
		sprite.flip_h = true
	
	top_edge_cast.position.x = axis*6
	player_input = Input.get_vector("left","right","up","down")
	
	if player_input!=Vector2.ZERO:
		last_looked_at = Vector2(1 if player_input.x>0 else -1,0)
		if abs(player_input.y)>=0.7:
			last_looked_at = Vector2(0,1 if player_input.y>0 and not is_on_floor() else -1)
	if last_looked_at.y!=0 and player_input==Vector2.ZERO:
		last_looked_at =  Vector2(-1 if sprite.flip_h else 1,0)

func clear_player_input():
	constant_velocity.input = Vector2(0,0)
	
func set_core(priority):
	if current_core_priority < priority:
		state_machine.requestStateChange("Core")
		current_core_priority = priority

func remove_core(priority):
	if current_core_priority <= priority and state_machine.get_current_state_name()=="core":
		state_machine.requestStateChange("Falling")
		current_core_priority = 0
	else:
		current_core_priority = 0

func add_hability(path):
	if path!= "":
		add_child(load(path).instantiate())
	GameHandler.player_habilities.push_back(path)
	



func _on_health_component_health_changed(new: Variant, _old: Variant) -> void:
	print((new))
	GameHandler.player_health = new
	Ui.player_ui.update_health(new)
