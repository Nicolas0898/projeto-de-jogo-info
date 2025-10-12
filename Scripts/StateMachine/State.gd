extends Node
class_name State

var stateMachine:StateMachine 
var stateData = {}
var character:BaseEntity = null

func _ready() -> void:
	if get_parent() is not StateMachine:
		push_warning("State isn't found inside a state machine!")
		return
	
	stateMachine = get_parent()
	
	begin()

func begin():
	pass

func onStateEntered(_oldState:State):
	pass
	
func onStateExit():
	pass

func onPhysics(_delta:float):
	pass

func onInput(_input:InputEvent):
	pass
