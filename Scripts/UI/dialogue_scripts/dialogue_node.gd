extends Control
class_name dialogue_node

@onready var name_label: RichTextLabel = $Panel/Box/VBoxContainer/Name
@onready var box: HBoxContainer = $Panel/Box
@onready var margin_container: MarginContainer = $Panel/Box/MarginContainer
@onready var sprite: TextureRect = $Panel/Box/MarginContainer/Sprite
@onready var border: TextureRect = $Panel/Box/MarginContainer/Sprite/Border
@onready var dialogue_text: RichTextLabel = $Panel/Box/VBoxContainer/DialogueText
@onready var question_box: VBoxContainer = $Panel/Box/VBoxContainer/question_box
@onready var v_box_container: VBoxContainer = $Panel/Box/VBoxContainer
var question_label = preload("res://Scenes/UI/question_label.tscn")
var option = 0
var is_question : bool = false

var current_loaded_dialogue : Dialogue
var current_message : Message
var c : int = 0

func _input(event: InputEvent) -> void:
	if not current_loaded_dialogue: return
	
	if current_message is Question:
		if event.is_action_pressed("up"):
			question_handler(1)
		if event.is_action_pressed("down"):
			question_handler(0)
	
	if event.is_action_pressed("interact") and not current_message is Question:
		loadNextMessage()
	
	if event.is_action_pressed("dialogue_next"):
		if current_message is Question:
			confirm()
		else:
			loadNextMessage()

func updateText(label : RichTextLabel ,newValue : String):
	label.text = newValue

func updateSprite(sp : TextureRect, new : Texture):
	if new != null and new != sp.texture:
		sp.texture = new

func generate_alternatives():
	if current_message is Question:
		is_question = true
		for i in range(len(current_message.questions)):
			var q = question_label.instantiate()
			q.text = current_message.questions[i].question
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
		GameHandler.Player.set_core(2)
		
		current_loaded_dialogue = new_dialogue
		current_message = current_loaded_dialogue.messages[c]
		c = 0
		
		if current_message.action != null:
			current_message.action.act()
		
		#Ui.fade_in(self)
		updateMessageRender()
		#os()
		

#func _physics_process(delta: float) -> void:
	#print(selected)

func updateMessageRender():
	anchor(current_message.sprite_pos)
	updateSprite(sprite, current_message.sprite)
	updateSprite(border, current_message.border)
	updateText(dialogue_text, current_message.text)
	generate_alternatives()
	if current_message.name:
		name_label.visible = true
		updateText(name_label,"— "+current_message.name)
	else:
		name_label.visible = false

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
	GameHandler.Player.remove_core(2)

func loadNextMessage():
	if current_loaded_dialogue==null: return
	c+=1
	
	if c>=len(current_loaded_dialogue.messages):
		dialogueEnd()
		return
	
	current_message = current_loaded_dialogue.messages[c]
	
	if current_message.action != null: current_message.action.act()
	
	#Ui.fade_out(margin_container)
	#await Ui.fade_out(v_box_container)
	
	# -invis ####################################
	await fadeinout()
	updateMessageRender()
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
	if current_message is not Question: return
	for i in range(len(current_message.questions)):
		if question_box.has_node("question" + str(i)):
			question_box.get_node("question" + str(i)).queue_free()
	
	if current_message.lock_dialogue == true:
		current_loaded_dialogue = current_message.questions[option].response
	else:
		if current_message.questions[option].response == null:
			dialogueEnd()
			return
		
		var m = current_message.questions[option].response.messages
		var o = current_message.questions[option].response.oneshot
		var n = current_message.questions[option].response.next_dialogue
		current_loaded_dialogue.response(m, o, n)
	
	c = -1 # Pra compensar o "dialogue start"
	loadNextMessage()

func fadeinout():
	var t = get_tree().create_tween()
	t.tween_property(self,"modulate",Color(1,1,1,0),0.2)
	await t.finished
	
	get_tree().create_timer(0.1).timeout.connect(func():
		get_tree().create_tween().tween_property(self,"modulate",Color(1,1,1,1),0.2)
	)
func anchor(pos):
	#0 direita
	#1 esquerda
	#2 nenhum
	
	match(pos):
		0:
			box.move_child(v_box_container,0)
			box.move_child(margin_container,1)
			margin_container.visible = true
		1:
			margin_container.visible = true
			box.move_child(margin_container,0)
			box.move_child(v_box_container,1)
		2:
			margin_container.visible = false
