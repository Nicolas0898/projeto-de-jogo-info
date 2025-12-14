extends Control
class_name dialogue_node

@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var sprite: TextureRect = $Panel/MarginContainer/Sprite
@onready var border: TextureRect = $Panel/MarginContainer/Sprite/Border
@onready var dialogue_text: Label = $Panel/VBoxContainer/DialogueText
@onready var question_box: VBoxContainer = $Panel/VBoxContainer/question_box
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer
var question_label = preload('res://scenes/question_label.tscn')
var option = 0
var is_question : bool = false

var current_loaded_dialogue : Dialogue
var c : int = 0

func updateText(label : Label ,newValue : String):
	label.text = newValue

func updateSprite(sp : TextureRect, new : Texture):
	if new != null and new != sp.texture:
		sp.texture = new

func generate_alternatives():
	if current_loaded_dialogue.messages[c] is Question:
		is_question = true
		for i in range(len(current_loaded_dialogue.messages[c].questions)):
			var q = question_label.instantiate()
			q.text = current_loaded_dialogue.messages[c].questions[i].question
			question_box.add_child(q)
			q.name = "question" + str(i)
		question_box.get_node("question" + str(option)).modulate = Color("#15ee00")
	else: is_question = false

func question_handler(i : int):
	#0 = Down
	#1 = Up
	
	if i == 0: #Down
		if option == len(current_loaded_dialogue.messages[c].questions) - 1:
			question_box.get_node("question" + str(option)).modulate = Color(1, 1, 1, 1)
			option = 0
		else:
			question_box.get_node("question" + str(option)).modulate = Color(1, 1, 1, 1)
			option+=1
	if i == 1: #Up
		if option == 0:
			question_box.get_node("question" + str(option)).modulate = Color(1, 1, 1, 1)
			option = len(current_loaded_dialogue.messages[c].questions) - 1
		else:
			question_box.get_node("question" + str(option)).modulate = Color(1, 1, 1, 1)
			option-=1
	question_box.get_node("question" + str(option)).modulate = Color("#15ee00")

func os():
	if current_loaded_dialogue.oneshot:
		InteractionSystem.current_area.queue_free()

func start(new_dialogue : Dialogue):
	if new_dialogue != current_loaded_dialogue:
		Ui.can_close = false
		Ui.set_current_active("Dialogue")
		
		InteractionSystem.action = new_dialogue
		current_loaded_dialogue = new_dialogue
		c = 0
		
		if current_loaded_dialogue.messages[c].action != null: current_loaded_dialogue.messages[c].action.act()
		
		#Ui.fade_in(self)
		anchor(current_loaded_dialogue.messages[c].sprite_pos)
		updateSprite(sprite, current_loaded_dialogue.messages[c].sprite)
		updateSprite(border, current_loaded_dialogue.messages[c].border)
		updateText(dialogue_text, current_loaded_dialogue.messages[c].text)
		os()
		
		generate_alternatives()

#func _physics_process(delta: float) -> void:
	#print(selected)

func dialogueEnd():
	Ui.can_close = true
	Ui.hide_all()
	if not is_instance_valid(current_loaded_dialogue) : return
	c=0
	#await Ui.fade_out(self)
	updateText(dialogue_text, "")
	if current_loaded_dialogue!=null:
		current_loaded_dialogue.onDialogueEnd() #provavelmente o problema é se o player tentar iniciar o dialogo muito rapido depois de acabar ele
		current_loaded_dialogue = null
	InteractionSystem.action = null
	is_question = false
	GameHandler.Player.remove_core(1)

func loadNextMessage():
	if current_loaded_dialogue==null: return
	c+=1
	
	if c>=len(current_loaded_dialogue.messages):
		dialogueEnd()
		return
	
	if current_loaded_dialogue.messages[c].action != null: current_loaded_dialogue.messages[c].action.act()
	
	Ui.fade_out(margin_container)
	#await Ui.fade_out(v_box_container)
	
	# -invis ####################################
	
	anchor(current_loaded_dialogue.messages[c].sprite_pos)
	updateSprite(sprite, current_loaded_dialogue.messages[c].sprite)
	updateSprite(border, current_loaded_dialogue.messages[c].border)
	updateText(dialogue_text, current_loaded_dialogue.messages[c].text)
	generate_alternatives()
	# -visible ####################################
	
	
	#Ui.fade_in(margin_container)
	#await Ui.fade_in(v_box_container)

func create_message(text : String): #Apenas gera uma mensagem (pra não precisar criar um recurso toda hora)
	var d = Dialogue.new()
	var m = Message.new()
	
	m.text = text
	d.messages.append(m)
	current_loaded_dialogue = d

func change_current_dialogue(d : Dialogue): #Se quiser mudar o diálogo por recurso (mais detalhado)
	current_loaded_dialogue = d
	c = 0

func confirm():
	if current_loaded_dialogue.messages[c] is not Question: return
	for i in range(len(current_loaded_dialogue.messages[c].questions)):
		question_box.get_node("question" + str(i)).queue_free()
	
	if current_loaded_dialogue.messages[c].lock_dialogue == true:
		current_loaded_dialogue = current_loaded_dialogue.messages[c].questions[option].response
	else:
		if current_loaded_dialogue.messages[c].questions[option].response == null:
			dialogueEnd()
			return
		
		var m = current_loaded_dialogue.messages[c].questions[option].response.messages
		var o = current_loaded_dialogue.messages[c].questions[option].response.oneshot
		var n = current_loaded_dialogue.messages[c].questions[option].response.next_dialogue
		current_loaded_dialogue.response(m, o, n)
	
	c = -1 # Pra compensar o "dialogue start"
	loadNextMessage()



func anchor(pos):
	# 0 = direita
	# 1 = esquerda
	# 2 = nenhum
	
	if pos == 0:
		#print('0')
		v_box_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT,Control.PRESET_MODE_KEEP_SIZE,37)
		margin_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT,Control.PRESET_MODE_KEEP_SIZE,5)
		sprite.modulate = Color (1, 1, 1, 1)
	elif pos == 1:
		#print('1')
		v_box_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT,Control.PRESET_MODE_KEEP_SIZE,5)
		margin_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT,Control.PRESET_MODE_KEEP_SIZE,5)
		sprite.modulate = Color (1, 1, 1, 1)
	elif pos == 2:
		#print('2')
		sprite.modulate = Color (1, 1, 1, 0)
