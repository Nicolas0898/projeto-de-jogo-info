extends Node
class_name StateMachine

signal onStateChange(currentState,oldState)

var character:CharacterBody2D
var avaliableStates = {}
var currentState:State
@export var initialState:State
var health_component:HealthComponent
var lockstate = false

func _ready() -> void:
	character = get_parent()

	if character.has_node("HealthComponent"):
		health_component = character.get_node("HealthComponent")
	
	for i in get_children():
		if i is State:
			avaliableStates[i.name.to_lower()] = i
			i.character = character
	
	currentState = initialState
	initialState.onStateEntered(null)
	print(avaliableStates)
	
	if health_component:
		health_component.healthChanged.connect(healthChanged)

func requestStateChange(newState:String,data={}):
	if lockstate:return
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

func healthChanged(new,old):
	if new<=0:
		if has_state("Died"):
			requestStateChange("Died")
			lockstate = true
	
func has_state(name:String) -> bool:
	for i in avaliableStates:
		if i == name.to_lower():
			return true
	return false
