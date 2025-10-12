extends BaseEntity
class_name PlayerCharacter

@export var speed = 200
@export var gravity_multiplier = 1
@export var jump_power = 1
@export var cam_limit_r = 10000000
@export var cam_limit_l = -10000000
@export var cam_limit_t = -10000000
@export var cam_limit_b = 10000000
var speed_multiplier = 1

@onready var camera: Camera2D = $Camera2D
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var crouch_cast: RayCast2D = $CrouchCast
@onready var crouch_cast_2: RayCast2D = $CrouchCast2
@onready var top_edge_cast: RayCast2D = $TopEdgeCast
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent


var player_input = Vector2.ZERO
var last_looked_at = Vector2(1,0)

func _ready() -> void:
	GameHandler.Player = self
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

func default_player_input(local_mult=1):
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
