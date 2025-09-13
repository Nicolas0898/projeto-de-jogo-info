extends Control
class_name DebugMenu

@onready var list: VBoxContainer = $List
@onready var vector_list: VBoxContainer = $VectorList

var watchlist = []
var vector_watchlist = []

func watch(instance:Object,variableName:String):
	var label = Label.new()
	if not list : await ready
	list.add_child(label)
	watchlist.append({label=label,instance=instance,variableName=variableName})

func watch_as_vector(instance:Object,variableName:String):
	var texture_rect: VectorRect = VectorRect.new()

	texture_rect.name = variableName
	vector_list.add_child(texture_rect)
	vector_watchlist.append({rect=texture_rect,instance=instance,variableName=variableName})

func _process(delta: float) -> void:
	for element in watchlist:
		element.label.text =\
		str(element.variableName) +" : "+ str(element.instance.get(element.variableName))
	for element in vector_watchlist:
		element.rect.target = element.instance.get(element.variableName)
