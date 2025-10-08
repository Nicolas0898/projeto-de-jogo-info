extends Node
class_name State

var stateMachine:StateMachine 
var stateData = {}
var character = null

func _ready() -> void:
	if get_parent() is not StateMachine:
		push_warning("State isn't found inside a state machine!")
		return
	
	stateMachine = get_parent()
	
	begin()

func begin():
	pass

func onStateEntered(oldState:State):
	pass
	
func onStateExit():
	pass

func onPhysics(delta:float):
	pass

func onInput(input:InputEvent):
	pass
