extends CharacterBody2D
class_name BaseEntity

var constant_velocity = {"input":Vector2(),"jump":Vector2.ZERO}
var variable_velocity = Vector2()
var true_constant_velocity = Vector2.ZERO
@onready var state_machine: StateMachine = $StateMachine

func apply_gravity(delta:float):
	variable_velocity  += get_gravity()*delta
	variable_velocity.x += -variable_velocity.normalized().x*20

func check_for_collisions(wall=true,floor=true,ceiling=true):
	if wall and is_on_wall():
		variable_velocity.x = 0
	
	if floor and is_on_floor() and variable_velocity.y>0:
		variable_velocity.y = 0
	
	if floor and is_on_ceiling() and variable_velocity.y<0:
		variable_velocity.y = 0

func update_velocity():
	true_constant_velocity = Vector2.ZERO
	for index in constant_velocity:
		true_constant_velocity+=constant_velocity[index]
	velocity = variable_velocity + true_constant_velocity

func default_move():
	update_velocity()
	move_and_slide()
