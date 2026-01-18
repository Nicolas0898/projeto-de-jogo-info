extends Button
@onready var label_right: Label = $LabelRight
@onready var label_left: Label = $LabelLeft
@onready var btn: Control = $btn
@onready var sprite: TextureRect = $btn/sprite
# 34px
var inputname
var right


func update(item:LoadoutItem):
	var texture_rect: TextureRect = $TextureRect
	if item and item.name == "REMOVEIMAGE": item = null
	if item:
		texture_rect.texture = item.sprite
	else:
		texture_rect.texture = null

var convertTable = {"Right Mouse Button":"Botão Direito","Left Mouse Button":"Botão Esquerdo"}
var btnimage = {
	10:"res://Images/Keybinds/Controller/rb.png",
	2:"res://Images/Keybinds/Controller/Square.png",
	3:"res://Images/Keybinds/Controller/triangle.png",
	5:"res://Images/Keybinds/Controller/rt.png"
}



#	if convertTable.has(label.text):
		#label.text = convertTable[label.text]
		
func _ready() -> void:
	GameHandler.GameInputChanged.connect(update_keybind)

func update_keybind():
	if inputname==null: return
	var label = label_right if right else label_left
	btn.position.x = 38 * (1 if right else -1) - 2

	var values = InputMap.action_get_events(inputname)
	var value
	for i in values:
		if (i is InputEventMouseButton or i is InputEventKey) and not GameHandler.controller:
			value = i
			label.visible = true
			var a = value.as_text().replace(" (Physical)","")
			label.text = convertTable.get(a,a)
			btn.visible = false
			break
		elif (i is InputEventJoypadButton or i is InputEventJoypadMotion) and GameHandler.controller:
			var number
			if i is InputEventJoypadButton:
				number = i.button_index
			else:
				number =  i.axis
			
			sprite.texture = load(btnimage[number])
			
			value = i
			label.visible = false
			btn.visible = true
			break
	
	print(inputname,":",value)
	
	
	
	
