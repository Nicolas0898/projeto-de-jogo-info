extends Node
class_name StateMachine

signal onStateChange(currentState,oldState)

var character:CharacterBody2D
var avaliableStates = {}
var currentState:State
@export var initialState:State

func _ready() -> void:
	character = get_parent()
	for i in get_children():
		if i is State:
			avaliableStates[i.name.to_lower()] = i
			i.character = character
	
	currentState = initialState
	initialState.onStateEntered(null)
	print(avaliableStates)

func requestStateChange(newState:String,data={}):
	newState = newState.to_lower()

	if not avaliableStates.get(newState,null) :
		push_warning(newState + " not found in StateMachine")
		return
	var oldState = currentState
	currentState = avaliableStates[newState]
	
	oldState.onStateExit()
	currentState.stateData = data
	currentState.onStateEntered(oldState)
	
	onStateChange.emit(currentState,oldState)

func _physics_process(delta: float) -> void:
	currentState.onPhysics(delta)

func _input(event: InputEvent) -> void:
	currentState.onInput(event)
