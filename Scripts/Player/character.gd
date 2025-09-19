extends CharacterBody2D
class_name PlayerCharacter

@export var speed = 200
@export var gravity_multiplier = 1
@export var jump_power = 1
var speed_multiplier = 1

@onready var state_machine: StateMachine = $StateMachine
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var crouch_cast: RayCast2D = $CrouchCast
@onready var crouch_cast_2: RayCast2D = $CrouchCast2
@onready var top_edge_cast: RayCast2D = $TopEdgeCast
@onready var hurtbox: Hurtbox = $Hurtbox

var constant_velocity = {"input":Vector2(),"jump":Vector2.ZERO}
var variable_velocity = Vector2()
var true_constant_velocity = Vector2.ZERO
var player_input = Vector2.ZERO

func _ready() -> void:
	GameHandler.Player = self
	%DebugMenu.watch(self,"true_constant_velocity")
	%DebugMenu.watch(self,"constant_velocity")
	%DebugMenu.watch(self,"variable_velocity")
	%DebugMenu.watch(state_machine,"currentState")
	%DebugMenu.watch(self,"speed_multiplier")
	%DebugMenu.watch_as_vector(self,"velocity")
	%DebugMenu.watch_as_vector(self,"player_input")

func default_player_input():
	var axis = Input.get_axis("left","right")
	constant_velocity.input =  Vector2(axis*speed*speed_multiplier,0)
	if axis>0:
		sprite.flip_h = false
	elif axis<0:
		sprite.flip_h = true
	top_edge_cast.position.x = axis*13
	player_input = Input.get_vector("left","right","up","down")*50

func clear_player_input():
	constant_velocity.input = Vector2(0,0)

func apply_gravity(delta:float):
	variable_velocity  += get_gravity()*delta

func check_for_collisions(wall=true,floor=true,ceiling=true):
	if wall and is_on_wall():
		variable_velocity.x = 0
	
	if floor and is_on_floor() and variable_velocity.y>0:
		variable_velocity.y = 0
	
	if floor and is_on_ceiling() and variable_velocity.y<0:
		variable_velocity.y = 0

func default_move():
	true_constant_velocity = Vector2.ZERO
	for index in constant_velocity:
		true_constant_velocity+=constant_velocity[index]
	velocity = variable_velocity + true_constant_velocity
	move_and_slide()
