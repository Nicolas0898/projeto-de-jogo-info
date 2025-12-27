extends Node
class_name StateMachine

signal onStateChange(currentState,oldState)

var character:CharacterBody2D
var avaliableStates = {}
var currentState:State
@export var initialState:State
var health_component:HealthComponent
var lockstate = false

#PARTES DO PIRES caso precisar deletar dps:
var bestiary_component:BestiaryComponent
signal bestiaryActivate()
signal bestiaryDeactivate()

func _ready() -> void:
	character = get_parent()

	if character.has_node("HealthComponent"):
		health_component = character.get_node("HealthComponent")
	if character.has_node("BestiaryComponent"):#pires
		bestiary_component = character.get_node("BestiaryComponent")
	
	for i in get_children():
		if i is State:
			avaliableStates[i.name.to_lower()] = i
			i.character = character
	
	currentState = initialState
	initialState.onStateEntered(null)
	print(avaliableStates)
	
	if health_component:
		health_component.healthChanged.connect(healthChanged)
	if bestiary_component: #pires
		bestiaryActivate.connect(bestiary_component.bestiaryActivate)

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
	
	if not currentState.f:
		currentState.f = true
		currentState.first()
	
	onStateChange.emit(currentState,oldState)

func _physics_process(delta: float) -> void:
	currentState.onPhysics(delta)

func _input(event: InputEvent) -> void:
	currentState.onInput(event)

func healthChanged(new,_old):
	if new<=0:
		if has_state("Died"):
			bestiaryActivate.emit()
			requestStateChange("Died")
			lockstate = true

@warning_ignore("shadowed_variable_base_class")
func has_state(name:String) -> bool:
	for i in avaliableStates:
		if i == name.to_lower():
			return true
	return false

func get_current_state_name()->String:
	return currentState.name.to_lower()
